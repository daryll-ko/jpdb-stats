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