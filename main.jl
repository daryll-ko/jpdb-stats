import JSON
import DataFrames as DF

include("./Cards.jl")

import .Cards: Card, Review, parse_cards

function get_review_frequencies(cards)
    rows = [
        (
            word=card.spelling,
            review_frequency=length(card.reviews),
        ) for card in cards
    ]
    df = DF.DataFrame(rows)
    sort!(df, [:review_frequency], rev=[true])
    return df
end

function main()
    open("reviews.json", "r") do f
        read(f, String) |> JSON.parse |> (j -> j["cards_vocabulary_jp_en"]) |> parse_cards |> get_review_frequencies |> display
    end
end

main()
