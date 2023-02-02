module Reviews

export Review, get_review_info_array

struct Review
    timestamp::Int
    grade::String
    from_anki::Bool
end

function get_review_info(review)
    timestamp = review["timestamp"]
    grade = review["grade"]
    from_anki = review["from_anki"]
    return Review(timestamp, grade, from_anki)
end

function get_review_info_array(reviews)
    return map(review -> get_review_info(review), reviews)
end

end
