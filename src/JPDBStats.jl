module JPDBStats

using Dates
using Plots
using CSV

import JSON
import DataFrames as DF

#= Structs =#

struct Review
    datetime::DateTime
    grade::String
    from_anki::Bool
end

struct Card
    vid::Int
    spelling::String
    reading::String
    reviews::Vector{Review}
end

#= Parsers =#

function parse_review(review)
    datetime = (unix2datetime ∘ localize)(review["timestamp"])
    grade = review["grade"]
    from_anki = review["from_anki"]
    return Review(datetime, grade, from_anki)
end

function parse_reviews(reviews)
    return map(review -> parse_review(review), reviews)
end

function parse_card(card)
    vid = card["vid"]
    spelling = card["spelling"]
    reading = card["reading"]
    reviews = parse_reviews(card["reviews"])
    return Card(vid, spelling, reading, reviews)
end

function parse_cards(cards)
    return map(card -> parse_card(card), cards)
end

#= Utilities =#

function localize(timestamp)
    return datetime2unix(unix2datetime(timestamp) + Hour(8))
end

function latest_review(card)
    (_, index) = findmax(review -> review.datetime, card.reviews)
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

function group_by_hour(reviews)
    counter = Dict{Int, Int}()
    for review in reviews
        hour_of_date = hour(review.datetime)
        counter[hour_of_date] = get(counter, hour_of_date, 0) + 1
    end
    return counter
end

#= Extractions =#

function load_cards(filename="reviews.json")
    open(filename, "r") do f
        return read(f, String) |> JSON.parse |> (j -> j["cards_vocabulary_jp_en"]) |> parse_cards
    end
end

function get_all_reviews(cards)
    reviews = []
    for card in cards, review in card.reviews
        push!(reviews, review)
    end
    return reviews
end

#= Views =#

function plot_review_stats(counter)
    bar(collect(keys(counter)), collect(values(counter)))
end

function tabulate_card_data(cards)
    rows = [(
        word = card.spelling,
        reading = card.reading,
        review_count = length(card.reviews),
        last_reviewed = Dates.format(latest_review(card).datetime, "u d, Y")
    ) for card in cards]

    df = DF.DataFrame()
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
