#set text(
  font: "New Computer Modern",
  size: 12pt,
)
#set page(
  paper: "a4",
  margin: (x: 1cm, y: 2cm),
  numbering: "1",
  header: [Hurtownie Danych - Schemat hurtowni danych dla ośrodka narciarskiego #line(length: 100%)],
)
#set heading(numbering: "1.")
#show link: underline

#set table(
  stroke: none,
  fill: (x, y) => if y == 0 {
    gray
  } else if calc.rem(y, 2) == 0 {
    silver
  },
)

#align(center)[
  #stack(
    v(12pt),
    text(size: 20pt)[Schemat hurtowni danych dla ośrodka narciarskiego],
    v(12pt),
    text(size: 15pt)[Krzysztof Nasuta 193328, Filip Dawidowski 193433],
  )
]

= Proces biznesowy

Hurtownia danych została zaprojektowana dla ośrodka narciarskiego. Opisywanym procesem biznesowym jest proces zakupu i wykorzystania karnetów narciarskich. Został on opisany w dokumencie pt. _Specyfikacja wymagań dla procesu biznesowego_.


= Schemat relacyjnej bazy danych

#align(center)[
  #box(height: 76%)[
    #text(font: "FreeSans")[#image("schema.svg")]
  ]
]

== Opis tabel

#table(
  columns: (1fr, 1fr, 1fr, 1fr),
  table.header(
    text("Tabela"),
    text("Atrybut"),
    text("Typ atrybutu"),
    text("Opis"),
  ),

  [*PassPurchase (Tabela faktu)*], table.cell(colspan: 3)[*Jedna encja reprezentuje fakt wykupienia karnetu przez klienta.*],
  [], [PassPurchaseDateID], [Numeric], [FK Pass #linebreak() Data transakcji.],
  [], [CardID], [Numeric], [FK Card #linebreak() Karta, na którą został zakupiony karnet.],
  [], [ClientID], [Numeric], [FK Client #linebreak() Klient, który zakupił karnet.],
  [], [PassID], [Numeric], [FK Pass #linebreak() Kupiony karnet.],
  [], [JunkID], [Numeric], [FK Junk #linebreak() Dodatkowe atrybuty.],
  [], [Price], [Money], [Cena karnetu.],
  [], [TotalTransactionPrice], [Money], [Całkowita kwota transakcji, której częścią jest to kupno.],
  [], [BoughtRides], [Numeric], [Ilość zjazdów wykupionych w karnecie.],
  [], [LeftPassRides], [Numeric], [Pozostała ilość zjazdów możliwych do wykonania na zakupionym karnecie.],
  [], [TransactionNumber], [Numeric], [Numer transakcji.],
  table.cell(colspan: 4)[#line(length: 100%)],


  [*Ride (Tabela faktu)*], table.cell(colspan: 3)[*Jedna encja reprezentuje fakt zjazdu ze stoku narciarskiego.*],
  [], [RideDateID], [Numeric], [FK Date #linebreak() Data zjazdu.],
  [], [SlopeID], [Numeric], [FK Slope #linebreak() Stok, na którym nastąpił zjazd.],
  [], [CardID], [Numeric], [FK Card #linebreak() Karta, która została wykorzystana do zjazdu.],
  [], [PassID], [Numeric], [FK Pass #linebreak() Karnet, z którego pobrano zjazd.],
  [], [DaysSincePassPurchase], [Numeric], [Liczba dni od zakupu karnetu do daty zjazdu.],
  table.cell(colspan: 4)[#line(length: 100%)],


  [*Client (Tabela wymiaru)*], table.cell(colspan: 3)[*Jedna encja reprezentuje pojedynczego klienta ośrodka narciarskiego.*],
  [], [ClientID], [Numeric], [PK #linebreak() (klucz zastępczy)],
  [], [Email], [nvarchar(64)], [Adres email klienta],
  [], [Experience], [nvarchar(20)], [Doświadczenie klienta na podstawie liczby wykupionych wcześniej karnetów. #linebreak() Dopuszczalne wartości: "1-3", "4-10", ">10"],
  [], [IsCurrent], [Boolean], [1 jeśli informacja jest aktualna, 0 w przeciwnym wypadku. (implementacja SCD2)],
  table.cell(colspan: 4)[#line(length: 100%)],


  [*Card (Tabela wymiaru)*], table.cell(colspan: 3)[*Jedna encja reprezentuje pojedynczą kartę zjazdową.*],
  [], [CardID], [Numeric], [PK #linebreak() (klucz zastępczy)],
  [], [CardCode], [nvarchar(64)], [Kod karty zjazdowej.],
  table.cell(colspan: 4)[#line(length: 100%)],


  [*Date (Tabela wymiaru)*], table.cell(colspan: 3)[*Jedna encja reprezentuje pojedynczy dzień.*],
  [], [DateID], [Numeric], [PK #linebreak() (klucz zastępczy)],
  [], [Date], [Date], [Data.],
  [], [Year], [Numeric], [Rok.],
  [], [Season], [nvarchar(20)], [Sezon narciarski. Dopuszczalne wartości: "Sezon XXXX", gdzie XXXX to rok rozpoczęcia sezonu.],
  [], [Month], [nvarchar(20)], [Nazwa miesiąca. Dopuszczalne wartości: Styczeń, Luty, Marzec, Kwiecień, Maj, Czerwiec, Lipiec, Sierpień, Wrzesień, Październik, Listopad, Grudzień],
  [], [MonthNumber], [Numeric], [Numer miesiąca. (1-12)],
  [], [Day], [Numeric], [Numer dnia. (1-31)],
  [], [DayOfWeek], [nvarchar(20)], [Dzień tygodnia. Dopuszczalne wartości: Poniedziałek, Wtorek, Środa, Czwartek, Piątek, Sobota, Niedziela],
  [], [DayOfWeekNumber], [Numeric], [Numer dnia tygodnia. (1-7)],
  table.cell(colspan: 4)[#line(length: 100%)],


  [*Junk (Tabela wymiaru)*], table.cell(colspan: 3)[*Encje reprezentują dodatkowe atrybuty.*],
  [], [JunkID], [Numeric], [PK #linebreak() (klucz zastępczy)],
  [], [TransactionType], [nvarchar(10)], [Typ transakcji. Dopuszczalne wartości: "online", "offline"],
  table.cell(colspan: 4)[#line(length: 100%)],


  [*Pass (Tabela wymiaru)*], table.cell(colspan: 3)[*Jedna encja reprezentuje jeden karnet.*],
  [], [PassID], [Numeric], [PK #linebreak() (klucz zastępczy)],
  [], [PassCode], [nvarchar(32)], [Kod karnetu w formacie "Karnet XXXX", gdzie XXXX to numer karnetu.],
  [], [ValidUntilDateID], [Numeric], [FK Date #linebreak() Data ważności karnetu.],
  [], [Price], [nvarchar(20)], [Cena karnetu. Dopuszczalne wartości: "0-25€", "25-50€", "50-100€", "100-200€", "200+€"],
  [], [UsedState], [nvarchar(20)], [Stan karnetu. Dopuszczalne wartości: "wykorzystany", "aktywny", "wygasły"],
  table.cell(colspan: 4)[#line(length: 100%)],


  [*Slope (Tabela wymiaru)*], table.cell(colspan: 3)[*Jedna encja reprezentuje jeden stok narciarski.*],
  [], [SlopeID], [Numeric], [PK #linebreak() (klucz zastępczy)],
  [], [SlopeName], [nvarchar(20)], [Nazwa stoku narciarskiego.],
  [], [Country], [nvarchar(20)], [Kraj stoku narciarskiego.],
  [], [Region], [nvarchar(20)], [Region, w którym znajduje się stok.],
  [], [MountainPeak], [nvarchar(20)], [Szczyt górski, na którym znajduje się stok.],
)

= Model wymiarowy

== Definicje faktów

=== Fakt 1 - Zjazd ze stoku

Zjazd ze stoku narciarskiego, dokonany w danym dniu, na danym stoku, przy użyciu jednej karty, na której znajduje się karnet umożliwiający zjazd.

Tabela faktu: *Ride*

Ziarnistość:
- określony dzień, w którym odbył się zjazd,
- określony stok, na którym odbył się zjazd,
- określona karta, z której skorzystano,
- określony karnet, z którego pobrano zjazd.

Miary:
- Ilość zjazdów - `COUNT(*)` <ilosc_zjazdow>
- Średnia liczba zjazdów na osobę - `COUNT(*) / COUNT(DISTINCT CardID)` <srednia_liczba_zjazdow_na_osobe>
- Maksymalna liczba dni od zakupu karnetu do zjazdu - `MAX(DaysSincePassPurchase)` <maksymalna_liczba_dni_od_zakupu_karnetu_do_zjazdu>

=== Fakt 2 - Wykupienie karnetu przez klienta

Zakup karnetu narciarskiego, dokonany w danym dniu. Zakupu dokonuje jeden klient o danym poziomie doświadczenia, w ramach jednej transakcji, dokonanej offline lub online. Kupiony karnet ma określoną cenę oraz liczbę zjazdów, do których uprawnia. Jest on przypisany do jednej karty.

Tabela faktu: *PassPurchase*

Ziarnistość:
- określony dzień transakcji,
- określony klient, który zakupił karnet,
- określona karta, do której przypisano karnet,
- określony karnet, wraz z jego ceną i ilością zjazdów,
- określona transakcja, wraz z wybranym rodzajem transakcji (offline/online).

Miary i funkcje agregujące:
- Ilość sprzedanych karnetów - `COUNT(*)` <ilosc_sprzedanych_karnetow>
- Średnia ilość zjazdów wykupionych w karnetach - `SUM(BoughtRides) / COUNT(*)` <srednia_ilosc_zjazdow_wykupionych_w_karnetach>
- Liczba transakcji -` COUNT(DISTINCT TransactionNumber)` <liczba_transakcji>
- Średnia liczba transakcji na osobę - `Liczba transakcji / COUNT(DISTINCT ClientID)` <srednia_liczba_transakcji_na_osobe>
- Łączna kwota - `SUM(Price)` <laczna_kwota>
- Przychód - `Łączna kwota / 1.23` <przychod>
- Średnia pozostała ilość zjazdów na karnetach - `SUM(LeftPassRides) / COUNT(*)` <srednia_pozostala_ilosc_zjazdow_na_karnetach>

== Definicje wymiarów

=== Wymiary dla faktu 1 - Zjazd ze stoku

#table(
  columns: (1fr, 1fr, 1fr),
  table.header(
    text("Wymiar/atrybut wymiaru"),
    text("Tabela/column"),
    text("Typ"),
  ),

  [Hierarchia daty zjazdu],
  [#sym.circle.filled.tiny Date.Year \
    #sym.circle.filled.tiny #sym.circle.filled.tiny Date.Month \
    #sym.circle.filled.tiny #sym.circle.filled.tiny #sym.circle.filled.tiny Date.Day],
  [Wymiar hierarchiczny],

  [Data zjazdu], [Date], [Wymiar],
  [Rok zjazdu], [Date.Year], [Atrybut wymiaru],
  [Sezon zjazdu], [Date.Season], [Atrybut wymiaru],
  [Miesiąc zjazdu], [Date.Month], [Atrybut wymiaru],
  [Dzień zjazdu], [Date.Day], [Atrybut wymiaru],
  [Dzień tygodnia zjazdu], [Date.DayOfWeek], [Atrybut wymiaru],
  [Hierarchia lokalizacji stoku],
  [#sym.circle.filled.tiny Slope.Country \
    #sym.circle.filled.tiny #sym.circle.filled.tiny Slope.Region \
    #sym.circle.filled.tiny #sym.circle.filled.tiny #sym.circle.filled.tiny Slope.MountainPeak],
  [Wymiar hierarchiczny],

  [Stok], [Slope], [Wymiar],
  [Nazwa stoku], [Slope.SlopeName], [Atrybut wymiaru],
  [Kraj stoku], [Slope.Country], [Atrybut wymiaru],
  [Region stoku], [Slope.Region], [Atrybut wymiaru],
  [Szczyt górski], [Slope.MountainPeak], [Atrybut wymiaru],
  [Karta], [Card], [Wymiar],
  [Kod karty], [Card.CardCode], [Atrybut wymiaru],
  [Karnet], [Pass], [Wymiar],
  [Kod karnetu], [Pass.PassCode], [Atrybut wymiaru],
  [Cena], [Pass.Price], [Atrybut wymiaru],
  [Stan karnetu], [Pass.UsedState], [Atrybut wymiaru],
)

=== Wymiary dla faktu 2 - Wykupienie karnetu przez klienta

#table(
  columns: (1fr, 1fr, 1fr),
  table.header(
    text("Wymiar/atrybut wymiaru"),
    text("Tabela/column"),
    text("Typ"),
  ),

  [Numer transakcji], [PassPurchase.TransactionNumber], [Wymiar zdegenerowany],
  [Hierarchia daty zakupu],
  [#sym.circle.filled.tiny Date.Year \
    #sym.circle.filled.tiny #sym.circle.filled.tiny Date.Month \
    #sym.circle.filled.tiny #sym.circle.filled.tiny #sym.circle.filled.tiny Date.Day],
  [Wymiar hierarchiczny],

  [Data zakupu], [Date], [Wymiar],
  [Rok zakupu], [Date.Year], [Atrybut wymiaru],
  [Sezon zakupu], [Date.Season], [Atrybut wymiaru],
  [Miesiąc zakupu], [Date.Month], [Atrybut wymiaru],
  [Dzień zakupu], [Date.Day], [Atrybut wymiaru],
  [Dzień tygodnia zakupu], [Date.DayOfWeek], [Atrybut wymiaru],
  [Karnet], [Pass], [Wymiar],
  [Cena], [Pass.Price], [Atrybut wymiaru],
  [Kod karnetu], [Pass.PassCode], [Atrybut wymiaru],
  [Stan karnetu], [Pass.UsedState], [Atrybut wymiaru],
  [Hierarchia daty ważności karnetu],
  [#sym.circle.filled.tiny Date.Year \
    #sym.circle.filled.tiny #sym.circle.filled.tiny Date.Month \
    #sym.circle.filled.tiny #sym.circle.filled.tiny #sym.circle.filled.tiny Date.Day],
  [Wymiar hierarchiczny],

  [Data ważności karnetu], [Date], [Wymiar],
  [Rok ważności karnetu], [Date.Year], [Atrybut wymiaru],
  [Sezon ważności karnetu], [Date.Season], [Atrybut wymiaru],
  [Miesiąc ważności karnetu], [Date.Month], [Atrybut wymiaru],
  [Dzień ważności karnetu], [Date.Day], [Atrybut wymiaru],
  [Dzień tygodnia ważności karnetu], [Date.DayOfWeek], [Atrybut wymiaru],
  [Karta], [Card], [Wymiar],
  [Kod karty], [Card.CardCode], [Atrybut wymiaru],
  [Klient], [Client], [Wymiar],
  [Email], [Client.Email], [Atrybut wymiaru],
  [Doświadczenie], [Client.Experience], [Atrybut wymiaru],
  [Junk], [Junk], [Wymiar],
  [Typ transakcji], [Junk.TransactionType], [Atrybut wymiaru],
)

#set table(
  stroke: 0.5pt + silver,
  columns: (1fr, 2fr, 2fr, 2fr),
  fill: (x, y) => if calc.rem(y, 2) == 0 {
    silver
  },
)

= Sprawdzenie możliwości wykonania zapytań

== Oblicz średnią ilość zjazdów jednej osoby na każdym ze stoków w zależności od dnia tygodnia.

#table(
  [*Miara*], table.cell(colspan: 3)[#link(<srednia_liczba_zjazdow_na_osobe>)[Średnia liczba zjazdów na osobę]],
  [*Wymiar*], [Stok], [*Atrybuty wymiaru*], [Nazwa stoku],
  [*Wymiar*], [Data zjazdu], [*Atrybuty wymiaru*], [Dzień tygodnia zjazdu],
)

== Ile średnio zjazdów wykonuje jedna osoba w ciągu dnia?

#table(
  [*Miara*], table.cell(colspan: 3)[#link(<srednia_liczba_zjazdow_na_osobe>)[Średnia liczba zjazdów na osobę]],
  [*Wymiar*], [Data zjazdu], [*Atrybuty wymiaru*], [Rok zjazdu, Miesiąc zjazdu, Dzień zjazdu],
)

== Porównanie ilości sprzedanych karnetów w zależności od miesiąca.

#table(
  [*Miara*], table.cell(colspan: 3)[#link(<ilosc_sprzedanych_karnetow>)[Ilość sprzedanych karnetów]],
  [*Wymiar*], [Data zakupu], [*Atrybuty wymiaru*], [Miesiąc zakupu],
)

== Porównaj ilość karnetów zakupionych online i offline względem poprzedniego sezonu.

#table(
  [*Miara*], table.cell(colspan: 3)[#link(<ilosc_sprzedanych_karnetow>)[Ilość sprzedanych karnetów]],
  [*Wymiar*], [Data zakupu], [*Atrybuty wymiaru*], [Sezon zakupu],
  [*Wymiar*], [Junk], [*Atrybuty wymiaru*], [Typ transakcji],
)

== Porównaj popularność karnetów upoważniających do różnej ilości zjazdów.

#table(
  [*Miara*], table.cell(colspan: 3)[#link(<ilosc_sprzedanych_karnetow>)[Ilość sprzedanych karnetów]],
  [*Wymiar*], [Karnet], [*Atrybuty wymiaru*], [Łączna ilość zjazdów],
)

== Ile zjazdów średnio wykonuje się w ciągu miesiąca korzystając z karnetów o różnej cenie?

#table(
  [*Miara*], table.cell(colspan: 3)[#link(<ilosc_zjazdow>)[Ilość zjazdów]],
  [*Wymiar*], [Karnet], [*Atrybuty wymiaru*], [Cena],
  [*Wymiar*], [Data zjazdu], [*Atrybuty wymiaru*], [Miesiąc zjazdu],
)

== Jak długo trwa korzystanie z karnetu w zależności od jego ceny?

#table(
  [*Miara*], table.cell(colspan: 3)[#link(<maksymalna_liczba_dni_od_zakupu_karnetu_do_zjazdu>)[Maksymalna liczba dni od zakupu karnetu do zjazdu]],
  [*Wymiar*], [Karnet], [*Atrybuty wymiaru*], [Cena],
)

== Czy klienci kupujący karnety online częściej wykorzystują wszystkie zjazdy niż klienci kupujący karnety w punkcie sprzedaży?

#table(
  [*Miara*], table.cell(colspan: 3)[#link(<ilosc_sprzedanych_karnetow>)[Ilość sprzedanych karnetów]],
  [*Wymiar*], [Junk], [*Atrybuty wymiaru*], [Typ transakcji],
  [*Wymiar*], [Karnet], [*Atrybuty wymiaru*], [Stan karnetu],
)

== Ile średnio zjazdów pozostaje niewykorzystanych na karnetach w zależności od ich ceny?

#table(
  [*Miara*], table.cell(colspan: 3)[#link(<srednia_pozostala_ilosc_zjazdow_na_karnetach>)[Średnia pozostała ilość zjazdów na karnetach]],
  [*Wymiar*], [Karnet], [*Atrybuty wymiaru*], [Cena],
)

== Jak zmienia się ilość wykupionych zjazdów w zależności od doświadczenia klienta (ilości kupionych wcześniej karnetów)?

#table(
  [*Miara*], table.cell(colspan: 3)[#link(<ilosc_sprzedanych_karnetow>)[Ilość sprzedanych karnetów]],
  [*Wymiar*], [Karnet], [*Atrybuty wymiaru*], [Łączna ilość zjazdów],
  [*Wymiar*], [Klient], [*Atrybuty wymiaru*], [Doświadczenie],
)

#set table(
  stroke: none,
  fill: (x, y) => if y == 0 {
    gray
  } else if calc.rem(y, 2) == 0 {
    silver
  },
)

= Weryfikacja dostępności wymaganych danych w źródłach

#table(
  columns: (2fr, 3fr, 7fr),
  table.header(
    text("Tabela"),
    text("Kolumna"),
    text("Źródło danych"),
  ),

  [*PassPurchase*], table.cell(colspan: 2)[*Jedna encja reprezentuje fakt wykupienia karnetu przez klienta.*],
  [], [PassPurchaseDateID], [ID daty zakupu karnetu. Klucz obcy z tabeli wymiaru. Bazuje na polu `Date` z tabeli `Transactions` z bazy danych.],
  [], [CardID], [ID karty, na którą zakupiono karnet. Klucz obcy z tabeli wymiaru. Bazuje na polu `CardCode` z tabeli `Cards` z bazy danych.],
  [], [ClientID], [ID klienta, który dokonał transakcji. Klucz obcy z tabeli wymiaru. Bazuje na polu `Email` z tabeli `Clients` z bazy danych.],
  [], [PassID], [ID karnetu, który został zakupiony. Klucz obcy z tabeli wymiaru. Tworzony na podstawie klucza głównego `PassID` z tabeli `Passes` z bazy danych.],
  [], [JunkID], [ID dodatkowych atrybutów. Klucz obcy z tabeli wymiaru. Bazuje na polu `Type` z tabeli `Transactions` z bazy danych.],
  [], [Price], [Cena zakupu karnetu. Bazuje na polu `Price` z tabeli `Passes` z bazy danych],
  [], [TotalTransactionPrice], [Kwota całej transakcji, której częścią jest zakup tego karnetu. Bazuje na polu `TotalPrice` z tabeli `Transactions` z bazy danych.],
  [], [BoughtRides], [Ilość zakupionych zjazdów w karnecie. Bazuje na polu `TotalRides` z tabeli `Passes` z bazy danych.],
  [], [LeftPassRides], [Pozostała ilość zjazdów możliwych do wykonania na zakupionym karnecie. Bazuje na różnicy pól `TotalRides` i `UsedRides` z tabeli `Passes`.],
  [], [TransactionNumber], [Numer transakcji. Wymiar zdegenerowany. Bazuje na polu `TransactionID` z tabeli `Transactions` z bazy danych.],
  table.cell(colspan: 3)[#line(length: 100%)],


  [*Ride*], table.cell(colspan: 2)[*Jedna encja reprezentuje fakt zjazdu ze stoku narciarskiego.*],
  [], [RideDateID], [ID daty zjazdu. Klucz obcy z tabeli wymiaru. Bazuje na polu `data i godzina odbicia karty` z logów bramek w formacie csv.],
  [], [SlopeID], [ID stoku, na którym odbył się zjazd. Klucz obcy z tabeli wymiaru. Bazuje na polu `numer bramki` z logów bramek w formacie csv.],
  [], [CardID], [ID karty, którą odbito w bramce. Klucz obcy z tabeli wymiaru. Bazuje kluczu biznesowym `CardCode` z tabeli `Cards` oraz pola `ID karnetu` z logów bramek w formacie csv.],
  [], [PassID], [ID karnetu, z którego pobrano zjazd. Klucz obcy z tabeli wymiaru. Bazuje na polu `ID karnetu` z logów bramek w formacie csv.],
  [], [DaysSincePassPurchase], [Liczba dni od zakupu karnetu do daty zjazdu. Bazuje na różnicy pól `data i godzina odbicia kart` z logów bramek w formacie csv i `Date` z tabeli `Transactions`.],
  table.cell(colspan: 3)[#line(length: 100%)],


  [*Client*], table.cell(colspan: 2)[*Jedna encja reprezentuje pojedynczego klienta ośrodka narciarskiego. (Implementacja SCD2)*],
  [], [ClientID], [ID klienta ośrodka narciarskiego. Klucz główny sztuczny - nadawany automatycznie.],
  [], [Email], [Adres email klienta. Klucz biznesowy pobrany z pola `Email` z tabeli `Clients` z bazy danych.],
  [], [Experience], [Doświadczenie klienta na podstawie liczby wykupionych wcześniej karnetów. Dopuszczalne wartości: "1-3", "4-10", ">10". Wartości mogą zostać policzone na podstawie tabel `Transactions` i `Passes` z bazy danych.],
  [], [IsCurrent], ["1" jeśli informacja jest aktualna, "0" w przeciwnym wypadku. (implementacja SCD2).],
  table.cell(colspan: 3)[#line(length: 100%)],


  [*Card*], table.cell(colspan: 2)[*Jedna encja reprezentuje pojedynczą kartę zjazdową.*],
  [], [CardID], [ID karty. Klucz główny sztuczny - nadawany automatycznie.],
  [], [CardCode], [Kod kreskowy karty. Klucz biznesowy pobrany z pola `CardCode` z tabeli `Cards` z bazy danych.],
  table.cell(colspan: 3)[#line(length: 100%)],


  [*Date*], table.cell(colspan: 2)[*Jedna encja reprezentuje pojedynczy dzień.*],
  [], [DateID], [ID daty. Klucz główny sztuczny - nadawany automatycznie.],
  [], table.cell(colspan: 2)[Wszystkie dane wymagane dla tej tabeli mogą zostać wygenerowane na podstawie dowolnego kalendarza przed procesem ETL.],
  table.cell(colspan: 3)[#line(length: 100%)],


  [*Junk*], table.cell(colspan: 2)[*Encje reprezentują dodatkowe atrybuty.*],
  [], [JunkID], [ID dodatkowych atrybutów. Klucz główny sztuczny - nadawany automatycznie.],
  [], table.cell(colspan: 2)[Wszystkie encje odpowiadają wszystkim możliwym wartościom `Type` z tabeli `Transactions`, wygenerowane będą przed procesem ETL.],

  table.cell(colspan: 3)[#line(length: 100%)],


  [*Pass*], table.cell(colspan: 2)[*Jedna encja reprezentuje jeden karnet.*],
  [], [PassID], [ID karnetu. Klucz główny sztuczny - nadawany automatycznie.],
  [], [PassCode], [Numer karnetu. Klucz biznesowy, utworzony na podstawie pola `PassID` z tabeli `Passes`.],
  [], [ValidUntilDateID], [ID daty ważności karnetu. Klucz obcy z tabeli wymiaru. Bazuje na polu `ValidUntil` z tabeli `Passes` z bazy danych.],
  [], [Price], [Cena karnetu. Bazuje na polu `Price` z tabeli `Passes` z bazy danych.],
  [], [UsedState], [Stan wykorzystana karnetu. Dopuszczalne wartości "wykorzystany", "aktywny", "wygasły". Wartości mogą zostać policzone na podstawie tabeli `Passes` z bazy danych.],
  table.cell(colspan: 3)[#line(length: 100%)],


  [*Slope*], table.cell(colspan: 2)[*Jedna encja reprezentuje jeden stok narciarski.*],
  [], [SlopeID], [ID stoku. Klucz główny sztuczny - nadawany automatycznie.],
  [], table.cell(colspan: 2)[Dane o stokach nie ulegają zmianom, więc mogą zostać wprowadzone ręcznie przed procesem ETL.],
)
