/*
	View: AgendaItem
	Agenda items.
*/

/*
	Parameter: studie
	Studie-id of -code om op te filteren (optioneel).
	TODO studie filter (deelnemers?)
*/
-- DECLARE @studie varchar(20) = '#studie#';

/*
	Parameter: datum_begin
	Begin van de op te vragen periode.
*/
DECLARE @datum_begin date = '#datum_begin#';

/*
	Parameter: datum_eind
	Einde van de op te vragen periode.
*/
DECLARE @datum_eind date = '#datum_eind#';

-- FUTURE 'current schoolyear' macro
/*DECLARE @schooljaar_dbegin DATETIME, @schooljaar_deinde DATETIME;
SELECT
	@schooljaar_dbegin = sis_blpe.dbegin,
	@schooljaar_deinde = sis_blpe.deinde
FROM sis_blpe
WHERE (sis_blpe.dbegin <= GETDATE() AND sis_blpe.deinde >= GETDATE())*/

SELECT
	agendaitem.idagendaitem AS agendaitem_id,
	-- agendaitem.parentid,
	agendaitem.dstart AS agendaitem_start,
	agendaitem.dfinish AS agendaitem_einde,
	agendaitem.omschrijving AS agendaitem_omschrijving,
	agendaitem.bericht AS agendaitem_bericht,
	-- agendaitem.idafgeslotendoor,
	-- agendaitem.dafgesloten,
	agendaitem.lesuurvan AS lesuurvan,
	agendaitem.lesuurtm AS lesuurtm,

	(CASE agendaitem.idtype
		WHEN 1 THEN 'Persoonlijke afspraak'
		WHEN 2 THEN 'Gezamelijke afspraak'
		WHEN 3 THEN 'Schoolbreed'
		--WHEN 4 THEN ''
		--WHEN 5 THEN ''
		WHEN 6 THEN 'Roostervrij'
		WHEN 7 THEN 'KWT'
		-- WHEN 8 THEN 'CHECK'
		-- WHEN 9 THEN 'CHECK'
		-- WHEN 10 THEN ''
		-- WHEN 11 THEN 'CHECK'
		-- WHEN 12 THEN ''
		WHEN 13 THEN 'Les'
		-- WHEN 14 THEN ''
		-- WHEN 15 THEN ''
		-- WHEN 16 THEN 'CHECK'
		-- WHEN 17 THEN 'CHECK'
		-- WHEN 18 THEN 'CHECK'
		ELSE CAST(agendaitem.idtype AS nvarchar)
	END) AS agendaitem_type,

	(CASE agendaitem.idagendastatus
		WHEN 1 THEN 'Automatisch geroosterd'
		WHEN 2 THEN 'Handmatig geroosterd'
		WHEN 3 THEN 'Gewijzigd'
		WHEN 4 THEN 'Vervallen'
		WHEN 5 THEN 'Automatisch vervallen'
		WHEN 6 THEN 'In gebruik'
		WHEN 7 THEN 'Afgesloten'
		WHEN 8 THEN 'Surveillance'
		WHEN 9 THEN 'Verplaatst'
		WHEN 10 THEN 'Gewijzigd en verplaatst'
		ELSE CAST(agendaitem.idagendastatus AS nvarchar)
	END) AS agendaitem_status
FROM agendaitem
WHERE
	(agendaitem.dstart >= @datum_begin AND agendaitem.dfinish <= @datum_eind)

	AND agendaitem.bprive = FALSE
	-- Lek geen persoonlijke afspraken
	AND agendaitem.idtype <> 1
ORDER BY agendaitem.dstart DESC, agendaitem_id
