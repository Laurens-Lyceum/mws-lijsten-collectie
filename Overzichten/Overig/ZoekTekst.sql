/*
    View: TekstZoeken
    Description: Zoek naar een bepaalde tekst in alle string-achtige velden in de database.
*/

/*
	Parameter: tekst
	Description: Tekst om naar te zoeken.
*/
DECLARE @INPUT_ZOEKTEKST nvarchar(max) = N'#tekst#';

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
    Description: Sneller zoeken door tabellen met grote hoeveelheden tekst te negeren.
*/
DECLARE @INPUT_QUICK_SEARCH nvarchar(1) = N'#quick#';
DECLARE @ENABLE_QUICK_SEARCH bit = 1;
IF @INPUT_QUICK_SEARCH = N'0'
    SET @ENABLE_QUICK_SEARCH = 0;

DECLARE @OUTPUT_VELDEN TABLE(field nvarchar(max));
DECLARE @OUTPUT_PROFILING TABLE(column_ref nvarchar(max), ms int);

-- UNION geeft timeout, dus we moeten de queries apart uitvoeren.
DECLARE @CURSOR CURSOR;
SET @CURSOR = CURSOR FOR
    SELECT
        sch.name + '.' + tab.name + '.' + col.name AS column_ref,
        'SELECT TOP 1 ' +
        '''' + sch.name + '.' + tab.name + '.' + col.name + ''' AS field ' +
        'FROM [' + sch.name + '].[' + tab.name + '] ' +
        'WHERE [' + col.name + '] LIKE ''%''+@ZOEKTEKST+''%'''
        AS query
    FROM [sys].tables tab
        JOIN [sys].schemas sch ON (tab.schema_id = sch.schema_id)
        JOIN [sys].columns col ON (tab.object_id = col.object_id)
        JOIN [sys].types types ON (col.system_type_id = types.system_type_id)
    WHERE
        tab.type_desc = 'USER_TABLE'
        AND types.name IN ('CHAR', 'NCHAR', 'VARCHAR', 'NVARCHAR')
        
        -- Versnel zoeken door tabellen te negeren met grote hoeveelheden tekst, tenzij anders aangegeven.
        AND (@ENABLE_QUICK_SEARCH = 0 OR tab.name NOT IN (
            'AgendaHuiswerkLL', 'agendaitem', 'AgendaLog', 
            'basisroosteritem', 'berichtdata',
            'CommunicatieArchief',
            'dbo_agendaitem_v1_CT', 'docitem', 'docitemhtml', 'doctable1', 'doctable2', 'DuoMeldingVO', 
            'elobron', 'elolog', 'eloopdrachtexportresultaat',
            'fileblob',
            'lvstllresultaat', 
            'osoaanvraaglog', 
            'reportsusr', 
            'sis_ckol', 'sis_fdat', 'sis_foto', 'sis_gebr', 'sis_ibgm', 'sis_leer', 'sis_lvak', 'sis_mlog',
            'smsqueue', 'syslog', 'syslogbatch',
            'Taak', 'tblogmemo', 'ToetsDeelnemer', 
            'verantwoording', 'verwijderd'
        ))
OPEN @CURSOR

DECLARE @COLUMN_REF nvarchar(max);
DECLARE @QUERY nvarchar(max);
FETCH NEXT FROM @CURSOR INTO @COLUMN_REF, @QUERY
WHILE @@FETCH_STATUS = 0
BEGIN
    DECLARE @MS_START datetime = SYSDATETIME();
    
    INSERT INTO @OUTPUT_VELDEN
        EXEC sp_executesql @QUERY, N'@ZOEKTEKST nvarchar(max)', @ZOEKTEKST = @INPUT_ZOEKTEKST;
    
    IF @ENABLE_PROFILING = 1
        INSERT INTO @OUTPUT_PROFILING VALUES (@COLUMN_REF, DATEDIFF(millisecond, @MS_START, SYSDATETIME()));
    
    FETCH NEXT FROM @CURSOR INTO @COLUMN_REF, @QUERY
END;

CLOSE @CURSOR;
DEALLOCATE @CURSOR;

IF @ENABLE_PROFILING = 0
    SELECT DISTINCT * FROM @OUTPUT_VELDEN;
ELSE
    SELECT * FROM @OUTPUT_PROFILING ORDER BY ms DESC;
