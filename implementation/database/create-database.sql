CREATE DATABASE SkiCenterDataWarehouse;

GO 

USE SkiCenterDataWarehouse;

CREATE TABLE
    Client (
        ClientID INT IDENTITY (1,1) PRIMARY KEY,
        Email NVARCHAR (64) NOT NULL,
        Experience NVARCHAR (20) NOT NULL CHECK 
                                    (Experience IN (N'1-3', N'4-10', N'>10')),
        IsCurrent BIT NOT NULL,
    )
CREATE TABLE
    Card (CardID INT IDENTITY (1,1) PRIMARY KEY, CardCode NVARCHAR (64),)
CREATE TABLE
    Date (
        DateID INT IDENTITY (1,1) PRIMARY KEY,
        Date DATE NOT NULL,
        Year INT NOT NULL,
        Season NVARCHAR (20) NOT NULL CHECK 
                                    (Season LIKE N'Sezon [0-9][0-9][0-9][0-9]'),
        Month NVARCHAR (20) NOT NULL CHECK (Month IN
                                    (N'Styczeń', N'Luty', N'Marzec', N'Kwiecień', N'Maj',
                                     N'Czerwiec', N'Lipiec', N'Sierpień', N'Wrzesień',
                                     N'Październik', N'Listopad', N'Grudzień')),
        MonthNumber INT NOT NULL CHECK (MonthNumber BETWEEN 1 AND 12),
        Day INT NOT NULL CHECK (Day BETWEEN 1 AND 31),
        DayOfWeek NVARCHAR (20) NOT NULL CHECK (DayOfWeek IN
                                    (N'Poniedziałek', N'Wtorek', N'Środa', 
                                     N'Czwartek', N'Piątek', N'Sobota', N'Niedziela')),
        DayOfWeekNumber INT NOT NULL CHECK (DayOfWeekNumber BETWEEN 1 AND 7),
    )
CREATE TABLE
    Junk (
        JunkID INT IDENTITY (1,1) PRIMARY KEY,
        TransactionType NVARCHAR (10) NOT NULL CHECK 
                                    (TransactionType IN (N'online', N'offline')),
    )
CREATE TABLE
    Pass (
        PassID INT IDENTITY (1,1) PRIMARY KEY,
        PassCode NVARCHAR (32) NOT NULL UNIQUE CHECK 
                                    (PassCode LIKE N'Karnet [0-9]%'),
        ValidUntilDateID INT FOREIGN KEY REFERENCES Date (DateID),
        Price NVARCHAR (20) NOT NULL CHECK (Price IN 
                                    (N'0-25€', N'25-50€', N'50-100€', N'100-200€', N'200+€')),
        UsedState NVARCHAR (20) NOT NULL CHECK (UsedState IN 
                                    (N'wykorzystany', N'aktywny', N'wygasły')),
    )
CREATE TABLE
    Slope (
        SlopeID INT IDENTITY (1,1) PRIMARY KEY,
        SlopeName NVARCHAR (32) NOT NULL,
        Country NVARCHAR (32) NOT NULL,
        Region NVARCHAR (32) NOT NULL,
        MountainPeak NVARCHAR (32) NOT NULL,
    )
CREATE TABLE
    Time (
        TimeID INT IDENTITY (1,1) PRIMARY KEY,
        Hour INT NOT NULL CHECK (Hour BETWEEN 0 AND 23),
        Minute INT NOT NULL CHECK (Minute BETWEEN 0 AND 59),
        TimeOfDay NVARCHAR (20) NOT NULL CHECK (TimeOfDay IN 
                                    (N'Rano', N'Popołudnie', N'Wieczór')),
    )
CREATE TABLE
    PassPurchase (
        PassPurchaseDateID INT FOREIGN KEY REFERENCES Date (DateID) NOT NULL,
        CardID INT FOREIGN KEY REFERENCES Card (CardID) NOT NULL,
        ClientID INT FOREIGN KEY REFERENCES Client (ClientID) NOT NULL,
        PassID INT FOREIGN KEY REFERENCES Pass (PassID) NOT NULL,
        JunkID INT FOREIGN KEY REFERENCES Junk (JunkID) NOT NULL,
        Price MONEY NOT NULL,
        TotalTransactionPrice MONEY NOT NULL,
        BoughtRides INT NOT NULL,
        LeftPassRides INT NOT NULL,
        TransactionNumber INT NOT NULL,
        ClientEmail NVARCHAR (64) NOT NULL,
        PRIMARY KEY (
            PassPurchaseDateID,
            CardID,
            ClientID,
            PassID,
            JunkID
        )
    )
CREATE TABLE
    Ride (
        RideDateID INT FOREIGN KEY REFERENCES Date (DateID) NOT NULL,
        RideTimeID INT FOREIGN KEY REFERENCES Time (TimeID) NOT NULL,
        SlopeID INT FOREIGN KEY REFERENCES Slope (SlopeID) NOT NULL,
        CardID INT FOREIGN KEY REFERENCES Card (CardID) NOT NULL,
        PassID INT FOREIGN KEY REFERENCES Pass (PassID) NOT NULL,
        DaysSincePassPurchase INT NOT NULL,
        PRIMARY KEY (RideDateID, RideTimeID, SlopeID, CardID, PassID)
    )