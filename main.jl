import JSON

function main()
	open("reviews.json", "r") do f
		s = read(f, String)
		j = JSON.parse(s)
		jp_en_cards = j["cards_vocabulary_jp_en"]
		for i in eachindex(jp_en_cards)
			display(jp_en_cards[i]["reviews"])
			break
		end
	end
end

main()
