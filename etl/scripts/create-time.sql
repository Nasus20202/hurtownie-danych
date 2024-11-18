DECLARE @Hour INT = 0;
DECLARE @Minute INT;
DECLARE @TimeOfDay NVARCHAR(20);

WHILE @Hour < 24
BEGIN
    SET @Minute = 0;

    WHILE @Minute < 60
    BEGIN
        -- Determine the TimeOfDay
        IF @Hour BETWEEN 0 AND 11
            SET @TimeOfDay = N'Rano';
        ELSE IF @Hour BETWEEN 12 AND 17
            SET @TimeOfDay = N'Popołudnie';
        ELSE
            SET @TimeOfDay = N'Wieczór';

        -- Insert the record
        INSERT INTO Time (Hour, Minute, TimeOfDay)
        VALUES (@Hour, @Minute, @TimeOfDay);

        -- Increment the minute
        SET @Minute = @Minute + 1;
    END

    -- Increment the hour
    SET @Hour = @Hour + 1;
END;