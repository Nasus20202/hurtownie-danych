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
  #box(width: 80%)[
    #text(font: "FreeSans")[#image("schema.svg")]
  ]
]

== Opis tabel
#table(
  stroke: none,
  fill: (x, y) => if y == 0 {
    gray
  } else if calc.rem(y, 2) == 0 {
    silver
  },
  columns: (1fr, 1fr, 1fr, 1fr),
  table.header(
    text("Tabela"),
    text("Atrybut"),
    text("Typ atrybutu"),
    text("Opis"),
  ),

  [*PassSale (Fact table)*], table.cell(colspan: 3)[*Jedna encja reprezentuje fakt sprzedaży karnetu.*],
  [], [PassSaleDateID], [Numeric], [FK Pass #linebreak() Data sprzedaży.],
  [], [CardID], [Numeric], [FK Pass #linebreak() Karta, na którą został sprzedany karnet.],
  [], [ClientID], [Numeric], [FK Pass #linebreak() Klient, który zakupił karnet.],
  [], [PassID], [Numeric], [FK Pass #linebreak() Sprzedany karnet.],
  [], [JunkID], [Numeric], [FK Junk #linebreak() Śmieciowe atrybuty.],
  [], [Price], [Money], [Cena karnetu.],
  [], [TotalTransactionPrice], [Money], [Całkowita kwota transakcji, której częścią jest ta sprzedaż.],
  [], [BoughtRider], [Numeric], [Ilość zjazdów sprzedanych w karnecie.],
  [], [TransactionNumber], [Numeric], [Numer transakcji.],
  table.cell(colspan: 4)[#line(length: 100%)],


  [*Ride (Fact table)*], table.cell(colspan: 3)[*Jedna encja reprezentuje fakt zjazdu ze stoku narciarskiego.*],
  [], [RideDateID], [Numeric], [FK Date #linebreak() Data zjazdu.],
  [], [SlopeID], [Numeric], [FK Slope #linebreak() Stok, na którym nastąpił zjazd.],
  [], [CardID], [Numeric], [FK Card #linebreak() Karta, która została wykorzystana do zjazdu.],
  [], [PassID], [Numeric], [FK Pass #linebreak() Karnet, z którego pobrano zjazd.],
  table.cell(colspan: 4)[#line(length: 100%)],


  [*Client (Dimension table)*], table.cell(colspan: 3)[*Jedna encja reprezentuje pojedynczego klienta ośrodka narciarskiego.*],
  [], [ClientID], [Numeric], [PK #linebreak() (klucz zastępczy)],
  [], [Email], [nvarchar(64)], [Email klienta],
  [], [Experience], [nvarchar(20)], [Doświadczenie klienta na podstawie liczby wykupionych wcześniej karnetów. #linebreak() Dopuszczalne wartości: "1-3", "4-10", ">10"],
  [], [IsCurrent], [Boolean], [1 jeśli informacja jest aktualna, 0 w przeciwnym wypadku. (implementacja SCD2)],
  table.cell(colspan: 4)[#line(length: 100%)],


  [*Card (Dimension table)*], table.cell(colspan: 3)[*Jedna encja reprezentuje pojedynczą kartę zjazdową.*],
  [], [CardID], [Numeric], [PK #linebreak() (klucz zastępczy)],
  [], [CardCode], [nvarchar(64)], [Kod karty zjazdowej.],
  table.cell(colspan: 4)[#line(length: 100%)],


  [*Date (Dimension table)*], table.cell(colspan: 3)[*Jedna encja reprezentuje pojedynczy dzień.*],
  [], [DateID], [Numeric], [PK #linebreak() (klucz zastępczy)],
  [], [Date], [Date], [Data.],
  [], [Year], [Numeric], [Rok.],
  [], [Season], [nvarchar(20)], [Sezon narciarski. Dopuszczalne wartości: "Season XXXX", gdzie XXXX to rok rozpoczęcia sezonu.],
  [], [Month], [nvarchar(20)], [Nazwa miesiąca. Dopuszczalne wartości: Styczeń, Luty, Marzec, Kwiecień, Maj, Czerwiec, Lipiec, Sierpień, Wrzesień, Październik, Listopad, Grudzień],
  [], [MonthNumber], [Numeric], [Numer miesiąca. (1-12)],
  [], [Day], [Numeric], [Numer dnia. (1-31)],
  [], [DayOfWeek], [nvarchar(20)], [Dzień tygodnia. Dopuszczalne wartości: Poniedziałek, Wtorek, Środa, Czwartek, Piątek, Sobota, Niedziela],
  [], [DayOfWeekNumber], [Numeric], [Numer dnia tygodnia. (1-7)],
  table.cell(colspan: 4)[#line(length: 100%)],


  [*Junk (Dimension table)*], table.cell(colspan: 3)[*Encje reprezentują wszystkie możliwe metody płatności.*],
  [], [JunkID], [Numeric], [PK #linebreak() (klucz zastępczy)],
  [], [PaymentMethod], [varchar(10)], [Typ płatności. Dopuszczalne wartości: "online", "offline"],


  [*Pass (Dimension table)*], table.cell(colspan: 3)[*Jedna encja reprezentuje jeden karnet.*],
  [], [PassID], [Numeric], [PK #linebreak() (klucz zastępczy)],
  [], [ValidUntilDateID], [Numeric], [FK Date #linebreak() Data ważności karnetu.],
  [], [Price], [Money], [Cena karnetu.],
  [], [TotalRides], [Numeric], [Ilość zjazdów możliwych do wykonania na karnecie.],
  [], [LeftRides], [Numeric], [Ilość pozostałych zjazdów na karnecie.],
  [], [UsedRides], [Numeric], [Ilość zjazdów wykonanych na karnecie.],
  [], [UsedState], [nvarchar(20)], [Stan karnetu. Dopuszczalne wartości: "zużyty", "aktywny", "wygasły"],

  [*Slope (Dimension table)*], table.cell(colspan: 3)[*Jedna encja reprezentuje jeden stok narciarskie.*],
  [], [SlopeID], [Numeric], [PK #linebreak() (klucz zastępczy)],
  [], [SlopeName], [varchar(20)], [Nazwa stoku narciarskiego.]
)