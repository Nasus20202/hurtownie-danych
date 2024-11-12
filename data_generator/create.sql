CREATE DATABASE SkiCenter;

GO 

USE SkiCenter;

GO
CREATE TABLE
	Clients (
		client_id INTEGER PRIMARY KEY,
		name NVARCHAR (64),
		surname NVARCHAR (64),
		email NVARCHAR (64),
		phone NVARCHAR (16),
		registered datetime,
	) GO
CREATE TABLE
	Cards (
		card_id INTEGER PRIMARY KEY,
		card_code NVARCHAR (64),
		registered datetime,
		client_id INTEGER FOREIGN KEY REFERENCES Clients,
	) GO
CREATE TABLE
	Transactions (
		transaction_id INTEGER PRIMARY KEY,
		total_price INTEGER,
		type NVARCHAR (16),
		date datetime,
		client_id INTEGER FOREIGN KEY REFERENCES Clients,
	) GO
CREATE TABLE
	Passes (
		pass_id INTEGER PRIMARY KEY,
		price INTEGER,
		total_rides INTEGER,
		used_rides INTEGER,
		valid_until datetime,
		transaction_id INTEGER FOREIGN KEY REFERENCES Transactions,
		card_id INTEGER FOREIGN KEY REFERENCES Cards,
	) GO