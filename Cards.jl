module Cards

export Card, get_card_info_array

include("./Reviews.jl")

import .Reviews: Review, get_review_info_array

struct Card
    vid::Int
    spelling::String
    reading::String
    reviews::Vector{Review}
end

function get_card_info(card)
    vid = card["vid"]
    spelling = card["spelling"]
    reading = card["reading"]
    reviews = get_review_info_array(card["reviews"])
    return Card(vid, spelling, reading, reviews)
end

function get_card_info_array(cards)
    return map(card -> get_card_info(card), cards)
end

end
