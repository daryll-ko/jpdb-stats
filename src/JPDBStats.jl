module JPDBStats

using CSV
using DataFrames
using Dates
using JSON
using Plots

#= Structs =#

struct Review
    datetime::DateTime
    grade::String
end

struct Card
    spelling::String
    reading::String
    reviews::Vector{Review}
end

#= Parsers =#

function parse_review(review)
    datetime = (localize ∘ unix2datetime)(review["timestamp"])
    grade = review["grade"]
    return Review(datetime, grade)
end

function parse_reviews(reviews)
    return map(review -> parse_review(review), reviews)
end

function parse_card(card)
    spelling = card["spelling"]
    reading = card["reading"]
    reviews = parse_reviews(card["reviews"])
    return Card(spelling, reading, reviews)
end

function parse_cards(cards)
    return map(card -> parse_card(card), cards)
end

#= Utilities =#

function localize(date)
    return date + Hour(8)
end

function earliest_review(card)
    _, index = findmin(review -> review.datetime, card.reviews)
    return card.reviews[index]
end

function latest_review(card)
    _, index = findmax(review -> review.datetime, card.reviews)
    return card.reviews[index]
end

#= Groupings =#

function is_new(result)
    return result == "unknown"
end

function is_passing(result)
    return result == "okay" || result == "pass"
end

function is_failing(result)
    return result == "nothing" || result == "fail"
end

function group_results_by_date(reviews)
    new_counter = Dict{Date,Int}()
    pass_counter = Dict{Date,Int}()
    fail_counter = Dict{Date,Int}()

    for review in reviews
        date = Date(review.datetime)
        if is_new(review.grade)
            new_counter[date] = get(new_counter, date, 0) + 1
        elseif is_passing(review.grade)
            pass_counter[date] = get(pass_counter, date, 0) + 1
        elseif is_failing(review.grade)
            fail_counter[date] = get(fail_counter, date, 0) + 1
        end
    end

    return new_counter, pass_counter, fail_counter
end

function group_by_date(reviews)
    counter = Dict{Date,Int}()
    for review in reviews
        date = Date(review.datetime)
        counter[date] = get(counter, date, 0) + 1
    end
    return counter
end

function group_by_unit(reviews, unit)
    counter = Dict{Int,Int}()
    for review in reviews
        hour_of_date = unit(review.datetime)
        counter[hour_of_date] = get(counter, hour_of_date, 0) + 1
    end
    return counter
end

function group_by_result(reviews)
    counter = Dict{String,Int}()
    for review in reviews
        result = review.grade
        counter[result] = get(counter, result, 0) + 1
    end
    return counter
end

#= Extractions =#

function load_cards(filename = "reviews.json")
    open(filename, "r") do f
        return read(f, String) |>
               JSON.parse |>
               (json -> json["cards_vocabulary_jp_en"]) |>
               parse_cards
    end
end

function get_all_reviews(cards)
    reviews = []
    for card in cards, review in card.reviews
        push!(reviews, review)
    end
    return reviews
end

function get_kanji_counter(cards)
    kanji_counter = Dict{String,Int}()
    kanji_regex = r"[一-龯]"
    for card in cards
        matches = unique(
            map(
                regex_match -> regex_match.match,
                collect(eachmatch(kanji_regex, card.spelling)),
            ),
        )
        for match in matches
            kanji_counter[match] = get(kanji_counter, match, 0) + 1
        end
    end
    return kanji_counter
end

function get_new_reviews(reviews)
    return filter(review -> review.grade == "unknown", reviews)
end

#= Views =#

function plot_reviews_by_result(reviews)
    plotlyjs()

    new_counter, pass_counter, fail_counter = group_results_by_date(reviews)

    new_data = bar(
        collect(keys(new_counter)),
        collect(values(new_counter)),
        name = "New",
        marker_color = "rgb(99,110,250)",
        linewidth = 0,
    )

    pass_data = bar(
        x = collect(keys(pass_counter)),
        y = collect(values(pass_counter)),
        name = "Pass",
        marker_color = "rgb(0,204,150)",
        linewidth = 0,
    )

    fail_data = bar(
        x = collect(keys(fail_counter)),
        y = collect(values(fail_counter)),
        name = "Fail",
        marker_color = "rgb(210,77,53)",
        linewidth = 0,
    )

    data = [fail_data, pass_data, new_data]
    layout = Layout(
        plot_bgcolor = "rgb(17,17,17)",
        paper_bgcolor = "rgb(17,17,17)",
        barmode = "stack",
    )

    plot(data, layout)
end

function tabulate_card_data(cards)
    rows = [
        (
            word = card.spelling,
            reading = card.reading,
            review_count = length(card.reviews),
            last_reviewed = latest_review(card).datetime,
            first_encountered = earliest_review(card).datetime,
        ) for card in cards
    ]

    df = DataFrame()
    for row in rows
        push!(df, row)
    end

    return df
end

function tabulate_review_data(reviews)
    rows = [(datetime = review.datetime, grade = review.grade) for review in reviews]

    df = DataFrame()
    for row in rows
        push!(df, row)
    end

    return df
end

function filter_words(df, pattern)
    matches_pattern(word) = occursin(pattern, word)
    filter(:word => matches_pattern, df)
end

#= Writes =#

function write_to_csv(df, filename)
    path = joinpath(pkgdir(JPDBStats), "results", "$filename.csv")
    CSV.write(path, df)
end

end
