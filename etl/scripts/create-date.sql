DECLARE @StartDate DATE = '2020-01-01';  -- Adjust as needed
DECLARE @EndDate DATE = '2025-12-31';    -- Adjust as needed
DECLARE @CurrentDate DATE = @StartDate;

WHILE @CurrentDate <= @EndDate
BEGIN
    DECLARE @Year INT = YEAR(@CurrentDate);
    DECLARE @MonthNumber INT = MONTH(@CurrentDate);
    DECLARE @Day INT = DAY(@CurrentDate);
    DECLARE @DayOfWeekNumber INT = DATEPART(WEEKDAY, @CurrentDate);
    DECLARE @DayOfWeek NVARCHAR(20);
    DECLARE @Month NVARCHAR(20);
    DECLARE @Season NVARCHAR(20);

    -- Map day of the week
    SET @DayOfWeek = CASE @DayOfWeekNumber
                        WHEN 1 THEN N'Niedziela'
                        WHEN 2 THEN N'Poniedziałek'
                        WHEN 3 THEN N'Wtorek'
                        WHEN 4 THEN N'Środa'
                        WHEN 5 THEN N'Czwartek'
                        WHEN 6 THEN N'Piątek'
                        WHEN 7 THEN N'Sobota'
                     END;

    -- Map month
    SET @Month = CASE @MonthNumber
                    WHEN 1 THEN N'Styczeń'
                    WHEN 2 THEN N'Luty'
                    WHEN 3 THEN N'Marzec'
                    WHEN 4 THEN N'Kwiecień'
                    WHEN 5 THEN N'Maj'
                    WHEN 6 THEN N'Czerwiec'
                    WHEN 7 THEN N'Lipiec'
                    WHEN 8 THEN N'Sierpień'
                    WHEN 9 THEN N'Wrzesień'
                    WHEN 10 THEN N'Październik'
                    WHEN 11 THEN N'Listopad'
                    WHEN 12 THEN N'Grudzień'
                 END;

    -- Determine season
    SET @Season = CASE 
                    WHEN @MonthNumber BETWEEN 1 AND 7 THEN N'Sezon ' + CAST(@Year - 1 AS NVARCHAR(4))
                    WHEN @MonthNumber BETWEEN 8 AND 12 THEN N'Sezon ' + CAST(@Year AS NVARCHAR(4))
                  END;

    -- Insert into the Date table
    INSERT INTO Date (Date, Year, Season, Month, MonthNumber, Day, DayOfWeek, DayOfWeekNumber)
    VALUES (@CurrentDate, @Year, @Season, @Month, @MonthNumber, @Day, @DayOfWeek, @DayOfWeekNumber);

    -- Increment date
    SET @CurrentDate = DATEADD(DAY, 1, @CurrentDate);
END;