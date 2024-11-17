USE SkiCenterDataWarehouse;

INSERT INTO Client (Email, Experience, IsCurrent) VALUES
    (N'user1@example.com', N'1-3', 1),
    (N'user2@example.com', N'1-3', 1),
    (N'user3@example.com', N'1-3', 1);

INSERT INTO Card (CardCode) VALUES
    (N'7238cc0e-4b74-4ec1-8f4a-90c1752cca42'),
    (N'897e5dc0-1602-4d1f-9102-6865afbbf8d3'),
    (N'6260128f-a4d6-451e-8c16-28a1ebeb5518'),
    (N'7da6e0a5-1802-4780-8877-c253e72fbde5');

INSERT INTO Date (Date, Year, Season, Month, MonthNumber, Day, DayOfWeek, DayOfWeekNumber) VALUES
    (N'2024-03-31', 2024, N'Sezon 2023', N'Marzec', 3, 31, N'Niedziela', 7),
    (N'2023-10-21', 2023, N'Sezon 2023', N'Październik', 10, 21, N'Poniedziałek', 1),
    (N'2023-12-01', 2023, N'Sezon 2023', N'Grudzień', 12, 1, N'Piątek', 5),
    (N'2024-01-03', 2024, N'Sezon 2023', N'Styczeń', 1, 3, N'Środa', 3),
    (N'2024-02-21', 2024, N'Sezon 2023', N'Luty', 2, 21, N'Środa', 3),
    (N'2024-02-22', 2024, N'Sezon 2023', N'Luty', 2, 22, N'Czwartek', 4);

INSERT INTO Junk (TransactionType) VALUES
    (N'online'),
    (N'offline');

INSERT INTO Pass (PassCode, ValidUntilDateID, Price, TotalRides, UsedState) VALUES
    (N'Karnet 1', 1, N'0-25€', N'0-20', N'wykorzystany'),
    (N'Karnet 2', 1, N'0-25€', N'0-20', N'wykorzystany'),
    (N'Karnet 3', 1, N'25-50€', N'20-35', N'aktywny'),
    (N'Karnet 4', 1, N'50-100€', N'35-60', N'aktywny');

INSERT INTO Slope (SlopeName, Country, Region, MountainPeak) VALUES
    (N'Chamonix', N'Francja', N'Haute-Savoie', N'Mont Blanc'),
    (N'Zermatt', N'Szwajcaria', N'Valais', N'Matterhorn');

INSERT INTO Time (Hour, Minute, TimeOfDay) VALUES
    (7, 21, N'Rano'),
    (9, 45, N'Rano'),
    (11, 32, N'Rano'),
    (13, 15, N'Popołudnie'),
    (15, 45, N'Popołudnie'),
    (16, 21, N'Popołudnie'),
    (17, 1, N'Popołudnie'),
    (17, 30, N'Popołudnie'),
    (19, 15, N'Wieczór'),
    (21, 0, N'Wieczór');

INSERT INTO PassPurchase (PassPurchaseDateID, CardID, ClientID, PassID, JunkID, Price, TotalTransactionPrice, BoughtRides, LeftPassRides, TransactionNumber, ClientEmail) VALUES
    (2, 1, 1, 1, 1, 10, 10, 10, 0, 5828328, N'user1@example.com'),
    (3, 2, 2, 2, 2, 10, 10, 10, 0, 5828329, N'user2@example.com'),
    (4, 3, 3, 3, 1, 35, 35, 60, 55, 5828330, N'user3@example.com'),
    (5, 4, 3, 4, 2, 60, 60, 100, 95, 5828331, N'user3@example.com');

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
    (6, 4, 2, 4, 4, 1),
    (6, 5, 1, 4, 4, 1);
