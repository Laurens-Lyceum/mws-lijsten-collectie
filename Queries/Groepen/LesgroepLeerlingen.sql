/*
	View: LesgroepLeerlingen
	Description: Leerlingen in een lesgroep.
*/

-- CHECK sis_svgd

/*
	Parameter: studie
	Studieid of studiecode om op te filteren (optioneel).
*/
DECLARE @studie varchar(max) = '#studie#';

SELECT
	sis_lvak.idlvak AS lesgroep_leerling_koppelid,
	
	-- sis_lvak.idbgrp IS NULL => stamklas
	IIF(sis_lvak.idbgrp IS NOT NULL, sis_bgrp_cluster.idbgrp, sis_bgrp_stamklas.idbgrp) AS lesgroep_id,
	IIF(sis_lvak.idbgrp IS NOT NULL, sis_bgrp_cluster.groep, sis_bgrp_stamklas.groep) AS lesgroep_naam,
	CAST(IIF(sis_lvak.idbgrp IS NULL, 1, 0) AS bit) AS lesgroep_is_stamklas,
	-- Niet alle lesgroepen hebben een intrinsiek vak (stamklassen)
	sis_lvak.c_vak AS vak_code,

	sis_lvak.idleer AS leerling_id,
	sis_lvak.stamnr AS stamnummer
FROM sis_lvak
	LEFT JOIN sis_bgrp sis_bgrp_cluster ON sis_lvak.idbgrp = sis_bgrp_cluster.idbgrp
	-- "Aanmelding die actief was ten tijde van deze leerling<>lesgroep koppeling" (aanmeldingen overlappen niet)
	LEFT JOIN sis_aanm ON sis_lvak.stamnr = sis_aanm.stamnr AND (sis_aanm.dbegin <= sis_lvak.dbegin AND sis_aanm.deinde >= sis_lvak.deinde)
	LEFT JOIN sis_bgrp sis_bgrp_stamklas ON sis_aanm.idbgrp = sis_bgrp_stamklas.idbgrp
	LEFT JOIN sis_stud ON sis_stud.idstud = sis_lvak.idstud
WHERE
	-- FUTURE "active date range" macro
	(sis_lvak.dbegin <= GETDATE() AND sis_lvak.deinde > GETDATE())

	-- FUTURE "matching id, name or ignore" macro
	AND (CASE
    	WHEN ISNUMERIC(@studie) = 1 THEN IIF(@studie = sis_lvak.idstud, true, false)
    	WHEN LEN(@studie) > 0 THEN IIF(@studie = sis_stud.studie, true, false)
	    ELSE true
	END = true)
ORDER BY stamnummer, lesgroep_naam
