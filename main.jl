import JSON

using DataFrames

include("./Cards.jl")

import .Cards: Card, Review, parse_cards

function get_word_review_frequency_table(cards)
    rows = [(word=card.spelling, review_frequency=length(card.reviews)) for card in cards]
    return DataFrame(rows)
end

function main()
    open("reviews.json", "r") do f
        s = read(f, String)
        j = JSON.parse(s)
        jp_en_deck = j["cards_vocabulary_jp_en"]
        jp_en_cards = parse_cards(jp_en_deck)
        display(get_word_review_frequency_table(jp_en_cards))
    end
end

main()
