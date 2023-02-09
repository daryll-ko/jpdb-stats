# `jpdb-stats`

## Instructions

ー、Download the `reviews.json` file from [jpdb's `Settings` page](https://jpdb.io/settings). If you don't have a jpdb account, you may use mine as a sample (it may not be up to date, however).

二、Install the necessary packages:

```bash
pkg> add JSON DataFrames
```

三、Run `julia main.jl`.

## Notes

Relevant structure:

```bash
j
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

(`cards_vocabulary_en_jp`, `cards_kanji_keyword_char`, and `cards_kanji_char_keyword` are not applicable to my use case.)

## Dev write-up

This was inspired by `bijak`'s [`jpdb_stats` repo](https://github.com/bijak/jpdb_stats). Because I have a copious amount of jpdb.io data, I thought this would be an excellent opportunity to work with Julia from a data-driven perspective.