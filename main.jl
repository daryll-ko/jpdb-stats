import JSON

include("./Cards.jl")

import .Cards: Card, Review, parse_cards

function main()
    open("reviews.json", "r") do f
        s = read(f, String)
        j = JSON.parse(s)
        jp_en_deck = j["cards_vocabulary_jp_en"]
        jp_en_cards = parse_cards(jp_en_deck)
        for i in eachindex(jp_en_cards)
            display(jp_en_cards[i])
            break
        end
    end
end

main()
