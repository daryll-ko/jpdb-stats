# `jpdb-stats` (`JPDBStats.jl`)

## Instructions

I assume you have [Julia](https://julialang.org/)?

1. Clone the project using `git clone`.

2. Download your `reviews.json` file from [jpdb's `Settings` page](https://jpdb.io/settings). If you don't use jpdb, you may use mine as a sample (it may not be up to date, however).

3. Activate the project in the Julia REPL (make sure you're in the package folder):

```bash
(v1.8) pkg> activate .
```

4. Install the relevant packages:

```bash
(JPDBStats) pkg> instantiate
```

5. Use the package!

```bash
julia> using JPDBStats

julia> main()
```

## Notes

Relevant structure:

```bash
reviews.json
│
├── cards_vocabulary_jp_en: Card[]
│   ├── vid: Int
│   ├── spelling: String
│   ├── reading: String
│   └── reviews: Review[]
│       ├── timestamp: Int
│       ├── grade: "unknown" | "okay"
│       └── from_anki: Bool
│
├── cards_vocabulary_en_jp: Card[]
├── cards_kanji_keyword_char: Card[]
└── cards_kanji_char_keyword: Card[]
```

Since I only use JP to EN vocab cards, the decks `cards_vocabulary_en_jp`, `cards_kanji_keyword_char`, and `cards_kanji_char_keyword` are empty for me.

I use the 2-point grading scale setting, so the value of `grade` in my case is always either `unknown` or `okay`.

## Dev write-up

This was inspired by `bijak`'s [`jpdb_stats` repo](https://github.com/bijak/jpdb_stats). Because I have a copious amount of jpdb.io data, I thought this would be an excellent opportunity to work with Julia from a data-driven perspective.

I'd like to highlight *data-driven* here. There have been a bunch of data-related projects that I've churned in my head, only to be shot down because I classified them as vanity metric obsessions. For example, I have a *lot* of data on AniList, but I've made it a personal rule to not bother doing data analysis related to it: I don't think it's a fruitful use of my time.

In contrast, analyzing my stats in `jpdb` gives me relevant ground to work on. One use case that motivated this whole thing is the first place is *batching*: at what time of the day do I usually do my reviews, and are there any immediate changes I can make to my review habits to make my active study time minimal?

One fun thing to think about throughout this project was how to keep the interface as modular as possible. If I had a table of card data, how could I design things to make feature extraction seamless?

At any rate, looking at my own stats has shown me how integral `jpdb` has been to my growth as a language learner over the past 9 months. My competence before and after incorporating it into my own life is staggering; I truly am happy I'm on the side where I want to be now.

Well, this is a journey that I expect to last an eternity, so you could say this is barely the first chapter into a grand adventure. I hope my future self has a great time!

Now to go back to my light novels...
