module Cards

export Card, parse_cards

include("./Reviews.jl")
import .Reviews: Review, parse_reviews

struct Card
    vid::Int
    spelling::String
    reading::String
    reviews::Vector{Review}
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

end
