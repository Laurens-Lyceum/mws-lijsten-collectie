/*
    View: TelRijen
    Description: Tel alle rijen in alle tabellen in de database. Hiermee kan soms gevonden worden waar iets is opgeslagen.
*/

/*
    Parameter: profiling
    Description: Profiling aan of uit.
*/
DECLARE @INPUT_PROFILING nvarchar(1) = N'#profiling#';
DECLARE @ENABLE_PROFILING bit = 0;
IF @INPUT_PROFILING = N'1'
    SET @ENABLE_PROFILING = 1;

/*
    Parameter: quick
    Description: Sneller zoeken door tabellen met grote hoeveelheden rijen te negeren.
*/
DECLARE @INPUT_QUICK_SEARCH nvarchar(1) = N'#quick#';
DECLARE @ENABLE_QUICK_SEARCH bit = 1;
IF @INPUT_QUICK_SEARCH = N'0'
    SET @ENABLE_QUICK_SEARCH = 0;

DECLARE @OUTPUT_TELLINGEN TABLE(table_ref nvarchar(max), row_count int);
DECLARE @OUTPUT_PROFILING TABLE(table_ref nvarchar(max), ms int);

-- UNION geeft timeout, dus we moeten de queries apart uitvoeren.
DECLARE @CURSOR CURSOR;
SET @CURSOR = CURSOR FOR
    SELECT
        sch.name + '.' + tab.name AS table_ref,
        'SELECT ' +
        '''' + sch.name + '.' + tab.name + ''' AS table_ref, ' +
        'COUNT(*) AS row_count ' +
        'FROM [' + sch.name + '].[' + tab.name + ']'
        AS query
    FROM [sys].tables tab
        JOIN [sys].schemas sch ON (tab.schema_id = sch.schema_id)
    WHERE
        tab.type_desc = 'USER_TABLE'
        
        -- Versnel zoeken door tabellen te negeren met grote hoeveelheden rijen, tenzij anders aangegeven.
        AND (@ENABLE_QUICK_SEARCH = 0 OR tab.name NOT IN (
            '' -- TODO
        ))
OPEN @CURSOR

DECLARE @TABLE_REF nvarchar(max);
DECLARE @QUERY nvarchar(max);
FETCH NEXT FROM @CURSOR INTO @TABLE_REF, @QUERY;
WHILE @@FETCH_STATUS = 0
BEGIN
    DECLARE @MS_START datetime = SYSDATETIME();
    
    INSERT INTO @OUTPUT_TELLINGEN
        EXEC sp_executesql @QUERY, N'';
    
    IF @ENABLE_PROFILING = 1
        INSERT INTO @OUTPUT_PROFILING VALUES (@TABLE_REF, DATEDIFF(millisecond, @MS_START, SYSDATETIME()));
    
    FETCH NEXT FROM @CURSOR INTO @TABLE_REF, @QUERY;
END;

CLOSE @CURSOR;
DEALLOCATE @CURSOR;

IF @ENABLE_PROFILING = 0
    SELECT DISTINCT * FROM @OUTPUT_TELLINGEN;
ELSE
    SELECT * FROM @OUTPUT_PROFILING ORDER BY ms DESC;
