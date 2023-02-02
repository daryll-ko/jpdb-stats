module Reviews

export Review, parse_reviews

struct Review
    timestamp::Int
    grade::String
    from_anki::Bool
end

function parse_review(review)
    timestamp = review["timestamp"]
    grade = review["grade"]
    from_anki = review["from_anki"]
    return Review(timestamp, grade, from_anki)
end

function parse_reviews(reviews)
    return map(review -> parse_review(review), reviews)
end

end
