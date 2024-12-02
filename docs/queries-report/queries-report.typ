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

Zyski z sezonu narciarskiego rosnąć będą co najmniej o 3% względem poprzedniego
sezonu

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

== Miesięczny przychód całego ośrodka oraz ilość zjazdów w ciągu miesiąca

Miesięczny przychód całego ośrodka oraz ilość zjazdów w ciągu miesiąca będą rosnąć
o co najmniej 3% w stosunku do odpowiedniego miesiąca poprzedniego sezonu.