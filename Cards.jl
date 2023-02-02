module Cards

export Card

using .Reviews: Review

struct Card
    vid::Int
    spelling::String
    reading::String
    reviews::Vector{Review}
end

end
