USE SkiCenter;
GO

BULK INSERT Clients FROM 'output\clients_t1.csv' WITH (fieldterminator=';',rowterminator='\n',datafiletype='widechar')
BULK INSERT Cards FROM 'output\cards_t1.csv' WITH (fieldterminator=';',rowterminator='\n',datafiletype='widechar')
BULK INSERT Transactions FROM 'output\transactions_t1.csv' WITH (fieldterminator=';',rowterminator='\n',datafiletype='widechar')
BULK INSERT Passes FROM 'output\passes_t1.csv' WITH (fieldterminator=';',rowterminator='\n',datafiletype='widechar')
GO