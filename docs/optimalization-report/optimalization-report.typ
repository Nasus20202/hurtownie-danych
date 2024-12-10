#set text(
  font: "New Computer Modern",
  size: 12pt,
)
#set page(
  paper: "a4",
  margin: (x: 1cm, y: 2cm),
  numbering: "1",
  header: [Hurtownie Danych - Optymalizacja hurtowni #line(length: 100%)],
)
#set heading(numbering: "1.")

#align(center)[
  #stack(
    v(12pt),
    text(size: 20pt)[Optymalizacja hurtowni],
    v(12pt),
    text(size: 18pt)[_Proces zakupu i wykorzystania karnetów przez klientów_],
    v(12pt),
    text(size: 15pt)[Krzysztof Nasuta 193328, Filip Dawidowski 193433],
  )
]

= Wstęp

Celem raportu jest pokazanie wpływu różnych fizyczny modeli kostki oraz sposobu agregacji na wydajność.

= Założenia wstępne

== Wielkość hurtowni danych

- Rozmiar bazy danych: 136MB (+264MB log)
- Ilość wierszy w tabeli faktu zjazdu: 1 599 884

== Środowisko testowe

Maszyna wirtualna QEMU z systemem Windows 11, 16GB RAM, 8 vCPU (4 rdzenie, 8 wątków), procesor AMD Ryzen 5 3600, dysk SSD.

= Testowanie

Sprawdzanie czasu wykonania zapytań i czasu procesowania kostki dla różnych modeli fizycznych kostki, z oraz bez agregacji.

== Opis zapytań

=== Agregacja dat:
```
SELECT
    {
	    [Ride Date].[DateHierarchy].[Year]
	  } ON ROWS,
    {
        [Measures].[AverageRideCountPerCard], [Measures].[Ride Count]
    } ON COLUMNS
FROM
    [Ski Center Data Warehouse]
```

=== Wymiar:
```
SELECT
    {
	    [Pass].[Price].[Price].MEMBERS
	} ON ROWS,
    {
        [Measures].[AverageRideCountPerCard], [Measures].[Ride Count]
    } ON COLUMNS
FROM
    [Ski Center Data Warehouse]
```

=== Ogólne:
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

== Wyniki

#text(size: 9pt)[Czas podany w milisekundach, średnia z 10 pomiarów]

#table(
  columns: (2fr, 1fr, 1fr, 1fr, 1fr, 1fr, 1fr),
  table.cell(rowspan: 2)[], table.cell(colspan: 2)[MOLAP], table.cell(colspan: 2)[ROLAP], table.cell(colspan: 2)[HOLAP],
  [Agregacja], [Bez agr.], [Agregacja], [Bez agr.], [Agregacja], [Bez agr.],
  //[Opóźnienie],
  //[], [], [], [], [], [],
  table.cell(rowspan: 3)[Czas zapytania (3 zapytania)],
  [192.67], [], [], [], [], [],
  [198.33], [], [], [], [], [],
  [31], [], [], [], [], [],
  [Czas procesowania],
  [6534,25], [], [], [], [], [],
  [Łączny rozmiar],
  [16,46 MB], [], [], [], [], [],
)

= Wnioski