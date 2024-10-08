#set text(
  font: "New Computer Modern",
  size: 12pt
)
#set page(paper: "a4", margin: (x: 1cm, y: 2cm), numbering: "1", header: [Hurtownie Danych - Specyfikacja wymagań dla procesu biznesowego #line(length: 100%)])
#set heading(numbering: "1.")

#align(center)[
  #stack(
    v(12pt),
    text(size: 20pt)[Specyfikacja wymagań dla procesu biznesowego],
    v(12pt),
    text(size: 18pt)[_Proces zakupu i wykorzystania karnetów przez klientów_],
    v(12pt),
    text(size: 15pt)[Krzysztof Nasuta 193328, Filip Dawidowski 193433]
  )
]

= Ogólny opis procesu biznesowego

a. *Ogólny opis procesu biznesowego*

Proces rozpoczyna się od zakupu karnetu przez klienta. Karnet może być zakupiony online lub w punkcie sprzedaży. W przypadku zakupu internetowego, użytkownik musi podać swoje dane, które są zapisywane w bazie danych. Po zakupie pierwszego karnetu, klient otrzymuje kod kreskowy, który pozwala na odbicie karnetu na bramce. W przypadku zakupu w punkcie sprzedaży, klient podaje swoje dane, po czym otrzymuje fizyczną kartę, którą także można odbić w bramce. Jeśli już posiada taką kartę, może ją doładować. Karta przypisana jest do użytkownika i jest zamienna z kodem kreskowym. Rachunki za zakup karnetów są przechowywane w bazie danych, wspólnej dla zakupów online i offline. Dodatkowo, w tej bazie przechowywane są informacje o pozostałej ilości zjazdów na każdym z karnetów oraz przypisaniu karnetu do danej karty/kodu. Po zakończeniu sezonu, karnety tracą ważność. W przypadku, gdy klient nie wykorzystał wszystkich zjazdów, nie ma możliwości ich przeniesienia na kolejny sezon. Karty oraz kody kreskowe nie ulegają dezaktywacji po zakończeniu sezonu.

Cele:
- *zyski z sezonu narciarskiego rosnąć będą co najmniej o 3% względem poprzedniego sezonu*.
- *miesięczny przychód całego ośrodka oraz ilość zjazdów w ciągu miesiąca będą rosnąć o co najmniej 3% w stosunku do odpowiedniego miesiąca poprzedniego sezonu*.

b. *Typowe zapytania*

- Który ze stoków cieszy się największą popularnością?
- Ile karnetów zostało zakupionych online, a ile w punkcie sprzedaży?
- Ile zjazdów zostało wykonanych w ciągu każdego miesiąca sezonu narciarskiego?
- Ile średnio zjazdów wykonuje klient w ciągu jednego dnia?
- Porównanie ilości zjazdów w dni wolne i weekendy.
- Karnety upoważniające do jakiej ilości zjazdów są najbardziej opłacalne dla resortu?
- Ile średnio karnetów jest kupowanych w ramach jednego zamówienia?
- Jaki jest trend ilości aktywnych kart na osobę względem poprzedniego sezonu?
- Jaki jest trend ilości zjazdów na kartę względem poprzedniego sezonu?
- Ile wynosi średni odcinek czasu pomiędzy pierwszym a ostatnim zjazdem na jednej karcie?
- Ile pieniędzy przynosi średnio jedna karta w ciągu sezonu?

c. *Dane*

Dane o transakcjach, kartach i karnetach przechowywane są w relacyjnej bazie danych. Dodatkowo, informacje o odbiciach karnetów na bramce są przechowywane w logach systemu bramki w pliku csv.

= Struktura źródeł danych

== Baza danych

Baza danych przechowuje informacje o klientach, karnetach, transakcjach oraz kartach/kodach kreskowych. Struktura bazy danych jest następująca:

#table(
  stroke: none,
  fill: (x, y) =>
    if y == 0 { gray }
    else if calc.rem(y, 2) == 0 { silver },
  columns: (1fr, 1fr, 1fr, 1fr),
  table.header(
    text("Tabela"),
    text("Atrybut"),
    text("Typ atrybutu"),
    text("Opis")
  ),
  [Clients], [ClientID], [int], [ID klienta - klucz główny],
  [], [Imie], [String], [Imię klienta],
  [], [Nazwisko], [String], [Nazwisko klienta],
  [], [Email], [String], [Adres email klienta],
  [], [Phone], [String], [Numer telefonu klienta],
  [], [Registered], [Date], [Data rejestracji klienta],
  table.cell(colspan: 4)[#line(length: 100%)],
  [Cards], [CardID], [int], [ID karty - klucz główny],
  [], [ClientID], [int], [ID klienta - klucz obcy],
  [], [CardCode], [String], [Kod kreskowy karty],
  [], [Registered], [Date], [Data rejestracji karty],
  table.cell(colspan: 4)[#line(length: 100%)],
  [Transactions], [TransactionID], [int], [ID transakcji - klucz główny],
  [], [ClientID], [int], [ID klienta - klucz obcy],
  [], [TotalPrice], [decimal], [Łączny koszt transakcji],
  [], [Type], [String], [Typ transakcji (online/offline)],
  [], [Date], [Date], [Data transakcji],
  table.cell(colspan: 4)[#line(length: 100%)],
  [Passes], [PassID], [int], [ID karnetu - klucz główny],
  [], [TransactionID], [int], [ID transakcji - klucz obcy],
  [], [CardID], [int], [ID karty - klucz obcy],
  [], [Price], [decimal], [Cena karnetu],
  [], [TotalRides], [int], [Ilość zjazdów na karnecie],
  [], [UsedRides], [int], [Ilość wykorzystanych zjazdów],
  [], [ValidUntil], [Date], [Data ważności karnetu]
)

== Logi bramki

Bramki na każdym ze stoków rejestrują odbicia karnetów. Logi bramki są przechowywane w plikach csv. Struktura pliku csv jest następująca:
- ID karnetu, z którego pobrano zjazd na podstawie zeskanowanej karty (int),
- numer bramki (oznaczający również numer stoku) (int), 
- data i godzina odbicia karty (unix timestamp lub RRRR-MM-DD HH:MM:SS) (string),
- status odbicia (poprawne/niepoprawne) (bool).

Przykład pliku csv:
```
13123;3;2021-01-01 12:00:56;true
26554;1;2021-01-01 12:01:02;true
7123;3;2021-01-01 12:01:12;false
```

= Problemy analityczne

== Co wpływa na ilość sprzedanych karnetów?

- Ile średnio trwał pobyt w resorcie (czas pomiędzy pierwszym a ostatnim zjazdem na karcie w sezonie)?
- Ile średnio zjazdów wykonuje jedna osoba w ciągu dnia?
- Jakie stoki cieszą się największą popularnością?
- Porównaj ilość karnetów zakupionych online i offline względem poprzedniego sezonu.
- Porównaj popularność karnetów upoważniających do różnej ilości zjazdów.
- Jak pogoda wpływa na ilość sprzedanych karnetów?

== Czy obniżka cen karnetów zwiększy zysk ze sprzedaży?

- Ile zjazdów wykonuje się w ciągu miesiąca korzystając z karnetów o różnej cenie?
- Jak długo trwa korzystanie z karnetu w zależności od jego ceny?
- Jak zmienia się ilość sprzedanych karnetów w zależności od ceny?
- Ile średnio zjazdów pozostaje niewykorzystanych na karnetach?
- Jak zmiany cen względem poprzedniego sezonu wpływają na zysk?
- Czy ceny w konkurencyjnych ośrodkach wpływają na podejmowane przez klientów decyzje?

= Dane wymagane do problemów analitycznych

== Co wpływa na ilość sprzedanych karnetów?

- Ile średnio trwał pobyt w resorcie (czas pomiędzy pierwszym a ostatnim zjazdem na karcie w sezonie)?
  - data pierwszego i ostatniego zjazdu na karnetach - logi z bramek
  - karnety przypisane do karty - baza danych, tabele Passes, Cards
- Ile średnio zjazdów wykonuje jedna osoba w ciągu dnia?
  - odbicia kart w ciągu jednego dnia - logi z bramek
  - karnety przypisane do karty - baza danych, tabele Passes, Cards
- Jakie stoki cieszą się największą popularnością?
  - odbicia kart na poszczególnych stokach - logi z bramek
- Porównaj ilość karnetów zakupionych online i offline względem poprzedniego sezonu.
  - transakcje online i offline - baza danych, tabela Transactions
- Porównaj popularność karnetów upoważniających do różnej ilości zjazdów.
  - zakupione karnety - baza danych, tabela Passes
- Jak pogoda wpływa na ilość sprzedanych karnetów?
  - historia sprzedaży karnetów - baza danych, tabela Transactions
  - dane pogodowe - zewnętrzne źródło, np. _openweathermap.org_

== Czy obniżka cen karnetów zwiększy zysk ze sprzedaży?

- Ile zjazdów wykonuje się w ciągu miesiąca korzystając z karnetów o różnej cenie?
  - cena karnetów - baza danych, tabela Passes
  - odbicia kart - logi z bramek
- Jak długo trwa korzystanie z karnetu w zależności od jego ceny?
  - cena karnetów - baza danych, tabela Passes
  - pierwsze i ostatnie użycie karnetu - logi z bramek
- Jak zmienia się ilość sprzedanych karnetów w zależności od ceny?
  - cena karnetów - baza danych, tabela Passes
  - data sprzedaży - baza danych, tabela Transactions
- Ile średnio zjazdów pozostaje niewykorzystanych na karnetach?
  - karnety - baza danych, tabela Passes
- Jak zmiany cen względem poprzedniego sezonu wpływają na zysk?
  - cena karnetów - baza danych, tabela Passes
  - data sprzedaży - baza danych, tabela Transactions
- Czy ceny w konkurencyjnych ośrodkach wpływają na podejmowane przez klientów decyzje?
  - ceny naszych karnetów - baza danych, tabela Passes
  - wpływ cen konkurencji na sprzedaż - brak danych

Na podstawie posiadanych danych nie jesteśmy w stanie określić wpływu cen konkurencji na sprzedaż naszych karnetów. Aby dowiedzieć się, jak wpływają one na decyzje podejmowane przez naszych klientów, należałoby przeprowadzić badanie ankietowe wśród klientów ośrodka narciarskiego. Proponujemy, aby przy sprzedaży zarówno fizycznej, jak i internetowej, zadać klientom następująca pytania:
- Czy ceny karnetów w naszym ośrodku narciarskim były niższe, wyższe czy podobne do cen karnetów w innych ośrodkach narciarskich?
- Jak bardzo duży był wpływ na wybór ośrodka miała cena karnetu?

Wyniki badań zapisane są w pliku csv o następującej strukturze:
- ID transakcji (int),
- odpowiedź na pierwsze pytanie (dużo niższe = 0, trochę niższe = 1, podobne = 2, trochę wyższe = 3, dużo wyższe = 4) (int),
- odpowiedź na drugie pytanie (bardzo mały = 0, mały = 1, średni = 2, duży = 3, bardzo duży = 4) (int).