/*
	View: Leerlingen
	Leerlingen die op dit moment op school zitten.
*/

SELECT
	sis_leer.idleer AS leerling_id,
	sis_leer.stamnr AS stamnummer,

	sis_leer.voorlett AS voorletters,
	sis_leer.roepnaam AS roepnaam,
	sis_leer.voornamen AS voornamen,
	sis_leer.tussenvoeg AS tussenvoegsel,
	sis_leer.achternaam AS achternaam,
	
	sis_bgrp.groep AS stamklas
FROM sis_leer
	INNER JOIN sis_aanm ON sis_leer.stamnr = sis_aanm.stamnr
	INNER JOIN sis_bgrp ON sis_aanm.idbgrp = sis_bgrp.idbgrp

	-- CHECK komt uit Mag2ADLeerlingen
	-- INNER JOIN sis_stud ON sis_aanm.idstud = sis_stud.idstud
	-- INNER JOIN sis_blfa ON sis_stud.idblfa = sis_blfa.idblfa
WHERE
	-- FUTURE "active date range" macro
	(sis_aanm.dbegin <= GETDATE() AND sis_aanm.deinde > GETDATE())
	-- CHECK komt uit Mag2ADLeerlingen
	-- AND sis_blfa.leerjaar IS NOT NULL
ORDER BY sis_leer.stamnr
