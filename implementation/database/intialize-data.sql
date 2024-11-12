USE SkiCenterDataWarehouse;

INSERT INTO Client (ClientID, Email, Experience, IsCurrent) VALUES
    (1, 'user1@example.com', '1-3', 1),
    (2, 'user2@example.com', '1-3', 1),
    (3, 'user3@example.com', '1-3', 1);

INSERT INTO Card (CardID, CardCode) VALUES
    (1, '7238cc0e-4b74-4ec1-8f4a-90c1752cca42'),
    (2, '897e5dc0-1602-4d1f-9102-6865afbbf8d3'),
    (3, '6260128f-a4d6-451e-8c16-28a1ebeb5518'),
    (4, '7da6e0a5-1802-4780-8877-c253e72fbde5');

INSERT INTO Date (DateID, Date, Year, Season, Month, MonthNumber, Day, DayOfWeek, DayOfWeekNumber) VALUES
    (1, '2024-03-31', 2024, 'Sezon 2023', 'Marzec', 3, 31, 'Niedziela', 7),
    (2, '2023-10-21', 2023, 'Sezon 2023', 'Październik', 10, 21, 'Poniedziałek', 1),
    (3, '2023-12-01', 2023, 'Sezon 2023', 'Grudzień', 12, 1, 'Piątek', 5),
    (4, '2024-01-03', 2024, 'Sezon 2023', 'Styczeń', 1, 3, 'Środa', 3),
    (5, '2024-02-21', 2024, 'Sezon 2023', 'Luty', 2, 21, 'Środa', 3);

INSERT INTO Junk (JunkID, TransactionType) VALUES
    (1, 'online'),
    (2, 'offline');

INSERT INTO Pass (PassID, PassCode, ValidUntilDateID, Price, UsedState) VALUES
    (1, 'Karnet 1', 1, 10, 'wykorzystany'),
    (2, 'Karnet 2', 1, 10, 'wykorzystany'),
    (3, 'Karnet 3', 1, 35, 'aktywny'),
    (4, 'Karnet 4', 1, 60, 'aktywny');

INSERT INTO Slope (SlopeID, SlopeName, Country, Region, MountainPeak) VALUES
    (1, 'Chamonix', 'Francja', 'Haute-Savoie', 'Mont Blanc'),
    (2, 'Zermatt', 'Szwajcaria', 'Valais', 'Matterhorn');

INSERT INTO Time (TimeID, Hour, Minute, TimeOfDay) VALUES
    (1, 7, 21, 'Rano'),
    (2, 9, 45, 'Rano'),
    (3, 11, 32, 'Rano'),
    (4, 13, 15, 'Popołudnie'),
    (5, 15, 45, 'Popołudnie'),
    (6, 16, 21, 'Popołudnie'),
    (7, 17, 1, 'Popołudnie'),
    (8, 17, 30, 'Popołudnie'),
    (9, 19, 15, 'Wieczór'),
    (10, 21, 0, 'Wieczór');

INSERT INTO PassPurchase (PassPurchaseDateID, CardID, ClientID, PassID, JunkID, Price, TotalTransactionPrice, BoughtRides, LeftPassRides, TransactionNumber, ClientEmail) VALUES
    (2, 1, 1, 1, 1, 10, 10, 10, 0, 5828328, 'user1@example.com'),
    (3, 2, 2, 2, 2, 10, 10, 10, 0, 5828329, 'user2@example.com'),
    (4, 3, 3, 3, 1, 35, 35, 60, 55, 5828330, 'user3@example.com'),
    (5, 4, 3, 4, 2, 60, 60, 100, 95, 5828331, 'user3@example.com');

INSERT INTO Ride (RideDateID, RideTimeID, SlopeID, CardID, PassID, DaysSincePassPurchase) VALUES
    (2, 1, 1, 1, 1, 0),
    (2, 2, 2, 1, 1, 0),
    (2, 3, 1, 1, 1, 0),
    (2, 4, 2, 1, 1, 0),
    (2, 5, 1, 1, 1, 0),
    (2, 6, 2, 1, 1, 0),
    (2, 7, 1, 1, 1, 0),
    (2, 8, 2, 1, 1, 0),
    (2, 9, 1, 1, 1, 0),
    (2, 10, 2, 1, 1, 0),
    (3, 1, 1, 2, 2, 0),
    (3, 2, 2, 2, 2, 0),
    (3, 3, 1, 2, 2, 0),
    (3, 4, 2, 2, 2, 0),
    (3, 5, 1, 2, 2, 0),
    (3, 6, 2, 2, 2, 0),
    (3, 7, 1, 2, 2, 0),
    (3, 8, 2, 2, 2, 0),
    (3, 9, 1, 2, 2, 0),
    (3, 10, 2, 2, 2, 0),
    (4, 1, 1, 3, 3, 0),
    (4, 2, 2, 3, 3, 0),
    (4, 3, 1, 3, 3, 0),
    (4, 4, 2, 3, 3, 0),
    (4, 5, 1, 3, 3, 0),
    (5, 1, 1, 4, 4, 0),
    (5, 2, 2, 4, 4, 0),
    (5, 3, 1, 4, 4, 0),
    (5, 4, 2, 4, 4, 0),
    (5, 5, 1, 4, 4, 0);
