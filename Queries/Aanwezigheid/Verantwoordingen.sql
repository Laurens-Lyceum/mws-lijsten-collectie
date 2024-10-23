/*
	View: Verantwoordingen
	Description: Aanwezigheidsverantwoordingen.
*/

/*
	Parameter: studie
	Studie-id of -code om op te filteren (optioneel).
*/
DECLARE @studie varchar(20) = '#studie#';

/*
	Parameter: absentiereden
	Absentiereden-id of -code om op te filteren (optioneel).
*/
DECLARE @reden varchar(20) = '#reden#';

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

-- TODO default value datum_begin/eind huidig schooljaar
-- TODO datetime datum_begin/eind?

SELECT
	verantwoording.idverantwoording AS verantwoording_id,
	-- sis_stud.studie AS studie_naam,
	-- verantwoording.idbgrp AS lesgroep_id,
	verantwoording.stamnr AS stamnummer,
	verantwoording.idagendaitem AS agendaitem_id,
	verantwoording.moment AS moment,
	verantwoording.lesuur AS lesuur,
	sis_abty.code AS aanwezigheidsreden_code,
	sis_abty.geoorloofd AS aanwezigheidsreden_geoorloofd,
	verantwoording.idgebr AS genoteerd_door,
	-- verantwoording.idmldr AS melder_id,
	-- verantwoording.idmldw AS meldwijze_id,
	verantwoording.dinvoer AS genoteerd_op,
	verantwoording.opmerking AS opmerking
	-- verantwoording.bmaatrgetrf,
FROM
	verantwoording
	LEFT JOIN sis_stud ON verantwoording.idstud = sis_stud.idstud
	LEFT JOIN sis_abty ON verantwoording.idabty = sis_abty.idabty
WHERE
	-- FUTURE "active date range" macro
	(verantwoording.daanwezigheid >= @datum_begin AND verantwoording.daanwezigheid <= @datum_eind)

	-- FUTURE "matching id, name or ignore" macro
	AND (CASE
		WHEN ISNUMERIC(@studie) = 1 THEN IIF(@studie = verantwoording.idstud, true, false)
		WHEN LEN(@studie) > 0 THEN IIF(@studie = sis_stud.studie, true, false)
		ELSE true
	END = true)

	AND (CASE
		WHEN ISNUMERIC(@reden) = 1 THEN IIF(@reden = verantwoording.idabty, true, false)
		WHEN LEN(@reden) > 0 THEN IIF(@reden = sis_abty.code, true, false)
		ELSE true
	END = true)
ORDER BY verantwoording.daanwezigheid DESC, moment DESC, stamnummer
