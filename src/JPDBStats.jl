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
    datetime = (unix2datetime ∘ localize)(review["timestamp"])
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

function localize(timestamp)
    return datetime2unix(unix2datetime(timestamp) + Hour(8))
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

function group_by_date(reviews)
    counter = Dict{Date, Int}()
    for review in reviews
        date = Date(review.datetime)
        counter[date] = get(counter, date, 0) + 1
    end
    return counter
end

function group_by_unit(reviews, unit)
    counter = Dict{Int, Int}()
    for review in reviews
        hour_of_date = unit(review.datetime)
        counter[hour_of_date] = get(counter, hour_of_date, 0) + 1
    end
    return counter
end

#= Extractions =#

function load_cards(filename="reviews.json")
    open(filename, "r") do f
        return read(f, String)                           |>
                JSON.parse                               |>
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

function get_new_reviews(reviews)
    return filter(review -> review.grade == "unknown", reviews)
end

#= Views =#

function plot_counter(counter)
    bar(collect(keys(counter)), collect(values(counter)))
end

function tabulate_card_data(cards)
    rows = [(
        word = card.spelling,
        reading = card.reading,
        review_count = length(card.reviews),
        last_reviewed = latest_review(card).datetime,
        first_encountered = earliest_review(card).datetime,
    ) for card in cards]

    df = DataFrame()
    for row in rows
        push!(df, row)
    end

    return df
end

function tabulate_review_data(reviews)
    rows = [(
        datetime = review.datetime,
        grade = review.grade,
    ) for review in reviews]

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
