import JSON

using DataFrames

include("./Cards.jl")

import .Cards: Card, Review, parse_cards

function get_review_frequencies(cards)
    rows = [(word=card.spelling, review_frequency=length(card.reviews)) for card in cards]
    return DataFrame(rows)
end

function main()
    open("reviews.json", "r") do f
        read(f, String) |> JSON.parse |> (j -> j["cards_vocabulary_jp_en"]) |> parse_cards |> get_review_frequencies |> display
    end
end

main()
