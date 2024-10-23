/*
	View: AgendaitemVakken
	Description: Agendaitem-vak koppelingen.
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

-- FUTURE "current schoolyear" macro
/*DECLARE @schooljaar_dbegin DATETIME, @schooljaar_deinde DATETIME;
SELECT
	@schooljaar_dbegin = sis_blpe.dbegin,
	@schooljaar_deinde = sis_blpe.deinde
FROM sis_blpe
WHERE (sis_blpe.dbegin <= GETDATE() AND sis_blpe.deinde >= GETDATE())*/

SELECT
	agendaitemdeelname.idagendaitem AS agendaitem_id,
	sis_bvak.c_vak AS vak_code
FROM agendaitemdeelname
	LEFT JOIN sis_bvak ON agendaitemdeelname.idkey = sis_bvak.idbvak
	LEFT JOIN agendaitem ON agendaitemdeelname.idagendaitem = agendaitem.idagendaitem
WHERE
	(agendaitem.dstart >= @datum_begin AND agendaitem.dfinish <= @datum_eind)
	AND idAgendaitemdeelnamesoort = 5
	
	AND agendaitem.bprive = FALSE
	-- Lek geen persoonlijke afspraken
	AND agendaitem.idtype <> 1
ORDER BY agendaitem_id, vak_code
