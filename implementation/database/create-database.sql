CREATE DATABASE SkiCenterDataWarehouse;

GO 

USE SkiCenterDataWarehouse;

CREATE TABLE
    Client (
        ClientID INT PRIMARY KEY,
        Email NVARCHAR (64),
        Experience NVARCHAR (20),
        IsCurrent BIT NOT NULL,
    )
CREATE TABLE
    Card (CardID INT PRIMARY KEY, CardCode NVARCHAR (64),)
CREATE TABLE
    Date (
        DateID INT PRIMARY KEY,
        Date DATE,
        Year INT,
        Season NVARCHAR (20),
        Month NVARCHAR (20),
        MonthNumber INT,
        Day INT,
        DayOfWeek NVARCHAR (20),
        DayOfWeekNumber INT,
    )
CREATE TABLE
    Junk (
        JunkID INT PRIMARY KEY,
        TransactionType NVARCHAR (10),
    )
CREATE TABLE
    Pass (
        PassID INT PRIMARY KEY,
        PassCode NVARCHAR (32),
        ValidUntilDateID INT FOREIGN KEY REFERENCES Date (DateID),
        Price NVARCHAR (20),
        UsedState NVARCHAR (20),
    )
CREATE TABLE
    Slope (
        SlopeID INT PRIMARY KEY,
        SlopeName NVARCHAR (32),
        Country NVARCHAR (32),
        Region NVARCHAR (32),
        MountainPeak NVARCHAR (32),
    )
CREATE TABLE
    Time (
        TimeID INT PRIMARY KEY,
        Hour INT,
        Minute INT,
        TimeOfDay NVARCHAR (20),
    )
CREATE TABLE
    PassPurchase (
        PassPurchaseDateID INT FOREIGN KEY REFERENCES Date (DateID) NOT NULL,
        CardID INT FOREIGN KEY REFERENCES Card (CardID) NOT NULL,
        ClientID INT FOREIGN KEY REFERENCES Client (ClientID) NOT NULL,
        PassID INT FOREIGN KEY REFERENCES Pass (PassID) NOT NULL,
        JunkID INT FOREIGN KEY REFERENCES Junk (JunkID) NOT NULL,
        Price MONEY,
        TotalTransactionPrice MONEY,
        BoughtRides INT,
        LeftPassRides INT,
        TransactionNumber INT,
        ClientEmail NVARCHAR (64),
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
        DaysSincePassPurchase INT,
        PRIMARY KEY (RideDateID, RideTimeID, SlopeID, CardID, PassID)
    )