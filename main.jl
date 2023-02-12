using Dates
using Plots

import JSON
import DataFrames as DF

include("./Cards.jl")

import .Cards: Card, Review, parse_cards

function convert_timestamp(timestamp)
    return Dates.format(unix2datetime(timestamp) + Hour(8), "U d, yyyy (HH:MM)")
end

function latest_timestamp(reviews)
    latest = 0
    for review in reviews
        latest = max(latest, review.timestamp)
    end
    return latest
end

function tabulate_data(cards)
    rows = [
        (
            word=card.spelling,
            review_frequency=length(card.reviews),
            latest_review=(convert_timestamp ∘ latest_timestamp)(card.reviews)
        ) for card in cards
    ]
    df = DF.DataFrame(rows)
    return df
end

function group_reviews_by_date(cards)
    date_counts = Dict{Date, Int}()
    for card in cards, review in card.reviews
        review_date = Date(unix2datetime(review.timestamp) + Hour(8))
        date_counts[review_date] = get(date_counts, review_date, 0) + 1
    end
    return date_counts
end

function plot_reviews_by_date(date_counts)
    bar(collect(keys(date_counts)), collect(values(date_counts)))
end

function main()
    open("reviews.json", "r") do f
        cards = read(f, String) |> JSON.parse |> (j -> j["cards_vocabulary_jp_en"]) |> parse_cards
        cards |> group_reviews_by_date |> plot_reviews_by_date
    end
end
