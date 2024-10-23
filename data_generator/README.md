# Creating database

Simply execute commands from `create_db.sql` file. It will create database `SkiCenter` with appropriate tables.

# Data generation
First you need to generate data using `data_generator.py` script. The data will be saved in CSV files in `output` directory.

Each of these files can be inserted into database using with following SQL commands:
```sql
USE SkiCenter;
GO

BULK INSERT table_name FROM '/path/to/file.csv' WITH (fieldterminator=';',rowterminator='\n',datafiletype='widechar')
```