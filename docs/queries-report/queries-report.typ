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