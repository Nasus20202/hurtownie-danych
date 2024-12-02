#set text(
  font: "New Computer Modern",
  size: 12pt,
)
#set page(
  paper: "a4",
  margin: (x: 1cm, y: 2cm),
  numbering: "1",
  header: [Hurtownie Danych - Raport zapytań MDX #line(length: 100%)],
)
#set heading(numbering: "1.")

#align(center)[
  #stack(
    v(12pt),
    text(size: 20pt)[Raport zapytań MDX],
    v(12pt),
    text(size: 18pt)[_Proces zakupu i wykorzystania karnetów przez klientów_],
    v(12pt),
    text(size: 15pt)[Krzysztof Nasuta 193328, Filip Dawidowski 193433],
  )
]
#show raw: it => box(
  fill: silver,
  outset: 5pt,
  radius: 5pt,
  it,
)

= KPI

== Zyski z sezonu narciarskiego

Zyski z sezonu narciarskiego rosnąć będą co najmniej o 3% względem poprzedniego sezonu.

- Value Expression
```
[Measures].[Income]
```

- Goal Expression
```
(
  (
    [Measures].[Income],
    StrToMember("[Pass Purchase Date].[Season].&[Sezon " + CStr(CInt(StrConv(Right([Pass Purchase Date].[Season].CurrentMember.Name, 4), 8, 1041)) - 1) + "]")
  )
) * 1.03
```

- Status Expression
```
IIF (KPIVALUE("Zyski z sezonu narciarskiego") >= KPIGOAL("Zyski z sezonu narciarskiego"), 1, -1)
```

- Trend Expression
```
IIF (KPIVALUE("Zyski z sezonu narciarskiego") >= (KPIVALUE("Zyski z sezonu narciarskiego"),
StrToMember(
  "[Pass Purchase Date].[Season].&[Sezon " + CStr(CInt(StrConv(Right([Pass Purchase Date].[Season].CurrentMember.Name, 4), 8, 1041)) - 1) + "]")
), 1, -1)
```

== Miesięczny przychód całego ośrodka

Miesięczny przychód całego ośrodka będzie rosnąć o co najmniej 3% w stosunku do odpowiedniego miesiąca poprzedniego sezonu.

- Value Expression
```
[Measures].[Price Sum]
```

- Goal Expression
```
(KPIVALUE("Miesięczny przychód całego ośrodka"), PARALLELPERIOD([Pass Purchase Date].[DateHierarchy].[Month], 12, [Pass Purchase Date].[DateHierarchy].CurrentMember)) * 1.03
```

- Status Expression
```
IIF (KPIVALUE("Zyski z sezonu narciarskiego") >= KPIGOAL("Zyski z sezonu narciarskiego"), 1, -1)
```

- Trend Expression
```
IIF (KPIVALUE("Miesięczny przychód całego ośrodka") >= (KPIVALUE("Miesięczny przychód całego ośrodka"), PARALLELPERIOD([Pass Purchase Date].
[DateHierarchy].[Month], 12, [Pass Purchase Date].[DateHierarchy].CurrentMember)), 1, -1)
```

== Ilość zjazdów w ciągu miesiąca

Ilość zjazdów w ciągu miesiąca będą rosnąć o co najmniej 3% w stosunku do odpowiedniego miesiąca poprzedniego sezonu.

- Value Expression
```
[Measures].[Ride Count]
```

- Goal Expression
```
(KPIVALUE("Ilość zjazdów w ciągu miesiąca"), PARALLELPERIOD([Ride Date].[DateHierarchy].[Month], 12, [Ride Date].[DateHierarchy].CurrentMember)) * 1.03
```

- Status Expression
```
IIF (KPIVALUE("Ilość zjazdów w ciągu miesiąca") >= KPIGOAL("Ilość zjazdów w ciągu miesiąca"), 1, -1)
```

- Trend Expression
```
IIF (KPIVALUE("Ilość zjazdów w ciągu miesiąca") >= (KPIVALUE("Ilość zjazdów w ciągu miesiąca"), PARALLELPERIOD([Ride Date].[DateHierarchy].[Month], 12, [Ride Date].[DateHierarchy].CurrentMember)), 1, -1)
```

= Zapytania MDX

== Oblicz średnią ilość zjazdów jednej osoby na każdym ze stoków w zależności od dnia tygodnia.
```
SELECT
    NON EMPTY {
        [Measures].[AverageRideCountPerCard]
    } * {
        [Ride Date].[Day Of Week].[Day Of Week].ALLMEMBERS
    } ON COLUMNS,
    NON EMPTY {
        [Slope].[Slope Name].[Slope Name].ALLMEMBERS
    } ON ROWS
FROM
    [Ski Center Data Warehouse]
```

== Ile średnio zjazdów wykonuje jedna osoba w ciągu dnia?
```
SELECT
    NON EMPTY {
        [Measures].[AverageRideCountPerCard]
    } ON COLUMNS,
    NON EMPTY {
        [Ride Date].[Date].[Date]
    } ON ROWS
FROM
    [Ski Center Data Warehouse]
```

== Porównanie ilości sprzedanych karnetów w zależności od miesiąca.
```
SELECT
    NON EMPTY {
        [Measures].[Pass Purchase Count]
    } ON COLUMNS,
    NON EMPTY {
        [Pass Purchase Date].[Month].[Month].ALLMEMBERS
    } ON ROWS
FROM
    [Ski Center Data Warehouse]
```

== Porównaj ilość karnetów zakupionych online i offline względem poprzedniego sezonu.
```
SELECT
    NON EMPTY {
        [Measures].[Pass Purchase Count]
    } * {
        [Junk].[Transaction Type].[Transaction Type].ALLMEMBERS
    } ON COLUMNS,
    NON EMPTY {
        [Pass Purchase Date].[Season].[Season].ALLMEMBERS
    } ON ROWS
FROM
    [Ski Center Data Warehouse]
```

== Porównaj popularność karnetów upoważniających do różnej ilości zjazdów.
```
SELECT
    NON EMPTY {
        [Measures].[Pass Purchase Count]
    } ON COLUMNS,
    NON EMPTY {
        [Pass].[Total Rides].[Total Rides].ALLMEMBERS
    } ON ROWS
FROM
    [Ski Center Data Warehouse]
```

== Ile zjazdów średnio wykonuje się w ciągu miesiąca korzystając z karnetów o różnej cenie?
```
SELECT NON EMPTY { [Measures].[Ride Count] } ON COLUMNS, NON EMPTY { ([Ride Date].[Month].[Month].ALLMEMBERS * [Pass].[Price].[Price].ALLMEMBERS ) } DIMENSION PROPERTIES MEMBER_CAPTION, MEMBER_UNIQUE_NAME ON ROWS FROM [Ski Center Data Warehouse] CELL PROPERTIES VALUE, BACK_COLOR, FORE_COLOR, FORMATTED_VALUE, FORMAT_STRING, FONT_NAME, FONT_SIZE, FONT_FLAGS
```

== Jak długo trwa korzystanie z karnetu w zależności od jego ceny?
```
SELECT NON EMPTY { [Measures].[Days Since Pass Purchase Max] } ON COLUMNS, NON EMPTY { ([Pass].[Price].[Price].ALLMEMBERS * [Pass].[Pass Code].[Pass Code].ALLMEMBERS ) } DIMENSION PROPERTIES MEMBER_CAPTION, MEMBER_UNIQUE_NAME ON ROWS FROM [Ski Center Data Warehouse] CELL PROPERTIES VALUE, BACK_COLOR, FORE_COLOR, FORMATTED_VALUE, FORMAT_STRING, FONT_NAME, FONT_SIZE, FONT_FLAGS
```

== Czy klienci kupujący karnety online częściej wykorzystują wszystkie zjazdy niż klienci kupujący karnety w punkcie sprzedaży?
```
SELECT NON EMPTY { [Measures].[Pass Purchase Count] } ON COLUMNS, NON EMPTY { ([Junk].[Transaction Type].[Transaction Type].ALLMEMBERS ) } DIMENSION PROPERTIES MEMBER_CAPTION, MEMBER_UNIQUE_NAME ON ROWS FROM ( SELECT ( { [Pass].[Used State].&[wykorzystany] } ) ON COLUMNS FROM [Ski Center Data Warehouse]) WHERE ( [Pass].[Used State].&[wykorzystany] ) CELL PROPERTIES VALUE, BACK_COLOR, FORE_COLOR, FORMATTED_VALUE, FORMAT_STRING, FONT_NAME, FONT_SIZE, FONT_FLAGS
```

== Ile średnio zjazdów pozostaje niewykorzystanych na karnetach w zależności od ich ceny?
```
SELECT NON EMPTY { [Measures].[AverageLeftPassRidesPerPassPurchase] } ON COLUMNS, NON EMPTY { ([Pass].[Price].[Price].ALLMEMBERS ) } DIMENSION PROPERTIES MEMBER_CAPTION, MEMBER_UNIQUE_NAME ON ROWS FROM [Ski Center Data Warehouse] CELL PROPERTIES VALUE, BACK_COLOR, FORE_COLOR, FORMATTED_VALUE, FORMAT_STRING, FONT_NAME, FONT_SIZE, FONT_FLAGS
```

== Jak zmienia się ilość wykupionych zjazdów w zależności od doświadczenia klienta (ilości kupionych wcześniej karnetów)?
```
SELECT NON EMPTY { [Measures].[Pass Purchase Count] } ON COLUMNS, NON EMPTY { ([Client].[Experience].[Experience].ALLMEMBERS ) } DIMENSION PROPERTIES MEMBER_CAPTION, MEMBER_UNIQUE_NAME ON ROWS FROM [Ski Center Data Warehouse] CELL PROPERTIES VALUE, BACK_COLOR, FORE_COLOR, FORMATTED_VALUE, FORMAT_STRING, FONT_NAME, FONT_SIZE, FONT_FLAGS
```
