/*
	View: Leerlingen
	Description: Leerlingen die op dit moment op school zitten.
*/

SELECT
	sis_leer.idleer AS leerling_id,
	sis_leer.stamnr AS stamnummer,

	sis_leer.voorlett AS voorletters,
	sis_leer.roepnaam AS roepnaam,
	sis_leer.voornamen AS voornamen,
	sis_leer.tussenvoeg AS tussenvoegsel,
	sis_leer.achternaam AS achternaam,
	
	sis_stud.studie AS studie_naam,
	sis_bgrp.groep AS stamklas_naam
	-- TODO vorige stamklas/blijven zitten/leerlijn
FROM sis_leer
	LEFT JOIN sis_aanm ON sis_leer.stamnr = sis_aanm.stamnr
	LEFT JOIN sis_bgrp ON sis_aanm.idbgrp = sis_bgrp.idbgrp
	LEFT JOIN sis_stud ON sis_aanm.idstud = sis_stud.idstud

	-- CHECK komt uit Mag2ADLeerlingen
	-- INNER JOIN sis_blfa ON sis_stud.idblfa = sis_blfa.idblfa
WHERE
	-- FUTURE "active date range" macro
	(sis_aanm.dbegin <= GETDATE() AND sis_aanm.deinde > GETDATE())
	-- CHECK komt uit Mag2ADLeerlingen
	-- AND sis_blfa.leerjaar IS NOT NULL
ORDER BY sis_leer.stamnr
