### A Pluto.jl notebook ###
# v0.19.27

using Markdown
using InteractiveUtils

# ╔═╡ 644037fa-2f64-441c-abe3-d145f63e9602
begin
	using Dates
	using JSON
end

# ╔═╡ d6cc3a7d-6cad-4ff5-b601-4209a494abbe
struct Review
    datetime::DateTime
    grade::String
end

# ╔═╡ 7b014fda-366f-11ee-2ab1-c95a638d2b04
struct Card
    spelling::String
    reading::String
    reviews::Vector{Review}
end

# ╔═╡ 62ec0354-5560-4470-b4c2-640e241dee7e
function localize(date)
    return date + Hour(8)
end

# ╔═╡ 346747a9-9940-4955-aa2f-be3cfa38d04f
function parse_review(review)
    datetime = (localize ∘ unix2datetime)(review["timestamp"])
    grade = review["grade"]
    return Review(datetime, grade)
end

# ╔═╡ 032c0df7-c6a4-4b64-baec-ed4c9443d716
function parse_reviews(reviews)
    return map(review -> parse_review(review), reviews)
end

# ╔═╡ 67fe9c8b-75fb-41d7-a416-3084ef583e66
function parse_card(card)
    spelling = card["spelling"]
    reading = card["reading"]
    reviews = parse_reviews(card["reviews"])
    return Card(spelling, reading, reviews)
end

# ╔═╡ 233c4b66-1591-492e-af33-c0d359e295bd
function parse_cards(cards)
    return map(card -> parse_card(card), cards)
end

# ╔═╡ 05b93b07-68d5-459e-b1c7-b51174139610
cards_url = "https://raw.githubusercontent.com/daryll-ko/JPDBStats.jl/main/reviews.json"

# ╔═╡ 66ba483a-f5f1-4666-ae27-dd53941c42cc
cards_filename = download(cards_url)

# ╔═╡ 347bcddd-6ffc-45b2-baea-89361ddae480
cards = open(cards_filename, "r") do f
	read(f, String) |>
	JSON.parse |>
	(json -> json["cards_vocabulary_jp_en"]) |>
	parse_cards
end

# ╔═╡ d49abd42-c93e-43ab-bb41-c73eef330854
length(cards)

# ╔═╡ 862cc331-99ef-4e3d-8b4a-88428b26b0bb
function get_kanji_counter(cards)
    kanji_counter = Dict{String,Int}()
    kanji_regex = r"[一-龯]"
    for card in cards
        matches = unique(
            map(
                regex_match -> regex_match.match,
                collect(eachmatch(kanji_regex, card.spelling)),
            ),
        )
        for match in matches
            kanji_counter[match] = get(kanji_counter, match, 0) + 1
        end
    end
    return kanji_counter
end

# ╔═╡ 8fcba01a-d700-46fc-a308-cf5c5e4db9c8
kanji_counter = get_kanji_counter(cards)

# ╔═╡ 7117465f-4b30-4d80-8389-f4593d1045e2
length(kanji_counter)

# ╔═╡ 00000000-0000-0000-0000-000000000001
PLUTO_PROJECT_TOML_CONTENTS = """
[deps]
Dates = "ade2ca70-3891-5945-98fb-dc099432e06a"
JSON = "682c06a0-de6a-54ab-a142-c8b1cf79cde6"

[compat]
JSON = "~0.21.4"
"""

# ╔═╡ 00000000-0000-0000-0000-000000000002
PLUTO_MANIFEST_TOML_CONTENTS = """
# This file is machine-generated - editing it directly is not advised

julia_version = "1.9.2"
manifest_format = "2.0"
project_hash = "92e5efaf4eb324d929cb42e9a20b5734b00b06f9"

[[deps.Dates]]
deps = ["Printf"]
uuid = "ade2ca70-3891-5945-98fb-dc099432e06a"

[[deps.JSON]]
deps = ["Dates", "Mmap", "Parsers", "Unicode"]
git-tree-sha1 = "31e996f0a15c7b280ba9f76636b3ff9e2ae58c9a"
uuid = "682c06a0-de6a-54ab-a142-c8b1cf79cde6"
version = "0.21.4"

[[deps.Mmap]]
uuid = "a63ad114-7e13-5084-954f-fe012c677804"

[[deps.Parsers]]
deps = ["Dates", "PrecompileTools", "UUIDs"]
git-tree-sha1 = "716e24b21538abc91f6205fd1d8363f39b442851"
uuid = "69de0a69-1ddd-5017-9359-2bf0b02dc9f0"
version = "2.7.2"

[[deps.PrecompileTools]]
deps = ["Preferences"]
git-tree-sha1 = "9673d39decc5feece56ef3940e5dafba15ba0f81"
uuid = "aea7be01-6a6a-4083-8856-8a6e6704d82a"
version = "1.1.2"

[[deps.Preferences]]
deps = ["TOML"]
git-tree-sha1 = "7eb1686b4f04b82f96ed7a4ea5890a4f0c7a09f1"
uuid = "21216c6a-2e73-6563-6e65-726566657250"
version = "1.4.0"

[[deps.Printf]]
deps = ["Unicode"]
uuid = "de0858da-6303-5e67-8744-51eddeeeb8d7"

[[deps.Random]]
deps = ["SHA", "Serialization"]
uuid = "9a3f8284-a2c9-5f02-9a11-845980a1fd5c"

[[deps.SHA]]
uuid = "ea8e919c-243c-51af-8825-aaa63cd721ce"
version = "0.7.0"

[[deps.Serialization]]
uuid = "9e88b42a-f829-5b0c-bbe9-9e923198166b"

[[deps.TOML]]
deps = ["Dates"]
uuid = "fa267f1f-6049-4f14-aa54-33bafae1ed76"
version = "1.0.3"

[[deps.UUIDs]]
deps = ["Random", "SHA"]
uuid = "cf7118a7-6976-5b1a-9a39-7adc72f591a4"

[[deps.Unicode]]
uuid = "4ec0a83e-493e-50e2-b9ac-8f72acf5a8f5"
"""

# ╔═╡ Cell order:
# ╠═644037fa-2f64-441c-abe3-d145f63e9602
# ╠═d6cc3a7d-6cad-4ff5-b601-4209a494abbe
# ╠═7b014fda-366f-11ee-2ab1-c95a638d2b04
# ╟─62ec0354-5560-4470-b4c2-640e241dee7e
# ╟─346747a9-9940-4955-aa2f-be3cfa38d04f
# ╟─032c0df7-c6a4-4b64-baec-ed4c9443d716
# ╟─67fe9c8b-75fb-41d7-a416-3084ef583e66
# ╟─233c4b66-1591-492e-af33-c0d359e295bd
# ╠═05b93b07-68d5-459e-b1c7-b51174139610
# ╠═66ba483a-f5f1-4666-ae27-dd53941c42cc
# ╠═347bcddd-6ffc-45b2-baea-89361ddae480
# ╠═d49abd42-c93e-43ab-bb41-c73eef330854
# ╟─862cc331-99ef-4e3d-8b4a-88428b26b0bb
# ╠═8fcba01a-d700-46fc-a308-cf5c5e4db9c8
# ╠═7117465f-4b30-4d80-8389-f4593d1045e2
# ╟─00000000-0000-0000-0000-000000000001
# ╟─00000000-0000-0000-0000-000000000002
