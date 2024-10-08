#set text(
  font: "New Computer Modern",
  size: 12pt
)
#set page(paper: "a4", margin: (x: 1cm, y: 2cm), numbering: "1", header: [Hurtownie Danych - Specyfikacja procesów biznesowych #line(length: 100%)])
#set heading(numbering: "1.")

#align(center)[
  #stack(
    v(12pt),
    text(size: 20pt)[Specyfikacja procesów biznesowych],
    v(12pt),
    text(size: 15pt)[Krzysztof Nasuta 193328, Filip Dawidowski 193433]
  )
]

= Cele biznesowe organizacji

_"DB Ski"_ jest alpejskim ośrodkiem narciarskim oferującym kilka tras zjazdowych oraz wypożyczalnię sprzętu narciarskiego. Klienci nabywają karnety, uprawniające do konkretnej ilości zjazdów. Karnety można nabywać online oraz w fizycznych punktach. Ceny karnetów w ciągu sezonu nie ulegają zmianie. Przed każdym zjazdem klienci odbijają karnet na specjalnej bramce, która rejestruje ich przejazd. Karnety są ważne tylko w sezonie narciarskim, który trwa od października do marca. Karnety nie utrzymują ważności pomiędzy sezonami. Dodatkowo narciarze mogą skorzystać z usług wypożyczalni sprzętu. Istnieje możliwość wypożyczenia godzinowego lub całodziennego.

Właściciel ośrodka oczekuje, że *zyski z sezonu narciarskiego rosnąć będą co najmniej o 3% co sezon*. W związku z tym wyróżniono następujące metryki:
- *miesięczny przychód całego ośrodka*,
- *ilość zjazdów w ciągu miesiąca*.
W takim razie, aby osiągnąć cel, oczekuje się, aby *w każdym miesiącu sezonu narciarskiego każda z tych metryk rosła o co najmniej 3% w stosunku do odpowiedniego miesiąca poprzedniego sezonu*.

Właściciel ośrodka chciałby przeanalizować wpływ dni wolnych i weekendów na ilość sprzedanych karnetów. Co więcej, chce wiedzieć karnety upoważniające do jakiej ilości zjazdów są najbardziej opłacalne dla resortu. Interesuje go także, jak zakup karnetów online wpływa na zachowanie klientów. Właściciel ośrodka chciałby także wiedzieć, jakie są najczęściej wypożyczane przedmioty w wypożyczalni sprzętu oraz których najczęściej brakuje.


= Procesy biznesowe

== Proces zakupu i wykorzystania karnetów przez klientów

a. *Ogólny opis procesu biznesowego*

Proces rozpoczyna się od zakupu karnetu przez klienta. Karnet może być zakupiony online lub w punkcie sprzedaży. W przypadku zakupu internetowego, użytkownik musi podać swoje dane, które są zapisywane w bazie danych. Po zakupie pierwszego karnetu, klient otrzymuje kod kreskowy, który pozwala na odbicie karnetu na bramce. W przypadku zakupu w punkcie sprzedaży, klient podaje swoje dane, po czym otrzymuje fizyczną kartę, którą także można odbić w bramce. Jeśli już posiada taką kartę, może ją doładować. Karta przypisana jest do użytkownika i jest zamienna z kodem kreskowym. Rachunki za zakup karnetów są przechowywane w bazie danych, wspólnej dla zakupów online i offline. Dodatkowo, w tej bazie przechowywane są informacje o pozostałej ilości zjazdów na każdym z karnetów oraz przypisaniu karnetu do danej karty/kodu. Po zakończeniu sezonu, karnety tracą ważność. W przypadku, gdy klient nie wykorzystał wszystkich zjazdów, nie ma możliwości ich przeniesienia na kolejny sezon. Karty oraz kody kreskowe nie ulegają dezaktywacji po zakończeniu sezonu.

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

== Proces wypożyczenia sprzętu narciarskiego

a. *Ogólny opis procesu biznesowego*

Proces rozpoczyna się od wyboru sprzętu przez klienta. Klient podaje swoje dane, które są zapisywane w bazie danych. Wypożyczalnia przechowuje informacje o dostępnych przedmiotach oraz ich ilości. Po wyborze sprzętu, klient otrzymuje rachunek, który jest przechowywany w bazie danych. Po zakończeniu wypożyczenia, klient zwraca sprzęt, a wypożyczalnia zapisuje informacje o zwróconym sprzęcie w bazie danych. Dodatkowo, w bazie przechowywane są informacje o ilości wypożyczonych przedmiotów oraz o ilości przedmiotów, które nie zostały zwrócone. Wypożyczalnia przechowuje także informacje o klientach, którzy nie zwrócili sprzętu w terminie.

b. *Typowe zapytania*

- Jakie są najczęściej wypożyczane przedmioty w wypożyczalni sprzętu?
- Które przedmioty najczęściej nie są zwracane w terminie?
- Ile średnio przedmiotów jest wypożyczanych w ramach jednego zamówienia?
- Jaki jest trend ilości wypożyczonych przedmiotów względem poprzedniego sezonu?
- Jaki przychód wygenerowała wypożyczalnia w ciągu sezonu?

c. *Dane*

Dane o wypożyczeniach, przedmiotach i klientach przechowywane są w relacyjnej bazie danych.