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
WITH MEMBER [Measures].[Average Rides Per Month] AS
    AVG(
        [Ride Date].[Year].[Year].MEMBERS,
        [Measures].[Ride Count]
    )
SELECT
    NON EMPTY {
        [Measures].[Average Rides Per Month]
    } * {
        [Ride Date].[Month].[Month].ALLMEMBERS
    } ON COLUMNS,
    NON EMPTY {
        [Pass].[Price].[Price].ALLMEMBERS
    } ON ROWS
FROM
    [Ski Center Data Warehouse]
```

== Jak długo trwa korzystanie z karnetu w zależności od jego ceny?
```
WITH MEMBER [Measures].[Average Days Since Pass Purchase] AS
    AVG(
        [Pass].[Pass Code].[Pass Code].MEMBERS,
        [Measures].[Days Since Pass Purchase Max]
    )
SELECT
    NON EMPTY {
        [Measures].[Average Days Since Pass Purchase]
    } ON COLUMNS,
    NON EMPTY {
        [Pass].[Price].[Price].ALLMEMBERS
    } ON ROWS
FROM
    [Ski Center Data Warehouse]

```

== Czy klienci kupujący karnety online częściej wykorzystują wszystkie zjazdy niż klienci kupujący karnety w punkcie sprzedaży?
```
SELECT
    NON EMPTY {
        [Measures].[Pass Purchase Count]
    } ON COLUMNS,
    NON EMPTY {
        ([Junk].[Transaction Type].[Transaction Type].ALLMEMBERS )
    } ON ROWS
FROM (
    SELECT
        {
            [Pass].[Used State].&[wykorzystany]
        } ON COLUMNS
    FROM [Ski Center Data Warehouse])
        WHERE ([Pass].[Used State].&[wykorzystany])
```

== Ile średnio zjazdów pozostaje niewykorzystanych na karnetach w zależności od ich ceny?
```
SELECT
    NON EMPTY {
        [Measures].[AverageLeftPassRidesPerPassPurchase]
    } ON COLUMNS,
    NON EMPTY {
        [Pass].[Price].[Price].ALLMEMBERS
    } ON ROWS
FROM [Ski Center Data Warehouse]
    WHERE
        EXCEPT(
            [Pass].[Used State].[Used State].MEMBERS,
            {
                [Pass].[Used State].&[wykorzystany]
            }
        )
```

== Jak zmienia się ilość wykupionych zjazdów w zależności od doświadczenia klienta (ilości kupionych wcześniej karnetów)?
```
SELECT
    NON EMPTY {
        [Measures].[Pass Purchase Count]
    } ON COLUMNS,
    NON EMPTY {
        [Client].[Experience].[Experience].ALLMEMBERS
     }  ON ROWS
FROM [Ski Center Data Warehouse]
```

== Podaj 3 najczęściej wybierane stoki.
```
SELECT
    NON EMPTY {
        [Measures].[Ride Count]
    } ON COLUMNS,
    NON EMPTY {
        TopCount([Slope].[Slope Name].[Slope Name].ALLMEMBERS, 3, [Measures].[Ride Count])
    } ON ROWS
FROM [Ski Center Data Warehouse]
```

== Podaj liczbę zjazdów w każdym roku.
```
SELECT
    NON EMPTY {
        [Measures].[Ride Count]
    } ON COLUMNS,
    NON EMPTY {
        [Ride Date].[DateHierarchy].[Year].ALLMEMBERS
    } ON ROWS
FROM [Ski Center Data Warehouse]
```
