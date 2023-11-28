/*
	View: LesgroepLeerlingen
	Leerlingen in een lesgroep.
	CHECK sis_svgd
*/

SELECT
	IIF(sis_lvak.idbgrp IS NOT NULL, sis_bgrp_cluster.idbgrp, sis_bgrp_stamklas.idbgrp) AS lesgroep_id,
	IIF(sis_lvak.idbgrp IS NOT NULL, sis_bgrp_cluster.groep, sis_bgrp_stamklas.groep) AS lesgroep_naam,
	CAST(IIF(sis_lvak.idbgrp IS NULL, 1, 0) AS bit) AS lesgroep_is_stamklas,
	-- Niet alle lesgroepen hebben een intrinsiek vak: stamklassen
	sis_lvak.c_vak AS vak_code,
	sis_lvak.stamnr AS stamnummer
FROM sis_lvak
	LEFT JOIN sis_bgrp sis_bgrp_cluster ON sis_lvak.idbgrp = sis_bgrp_cluster.idbgrp
	LEFT JOIN sis_aanm ON sis_lvak.stamnr = sis_aanm.stamnr
	LEFT JOIN sis_bgrp sis_bgrp_stamklas ON sis_aanm.idbgrp = sis_bgrp_stamklas.idbgrp
WHERE
	-- FUTURE "active date range" macro
	(sis_lvak.dbegin <= GETDATE() AND sis_lvak.deinde > GETDATE())
ORDER BY stamnummer, lesgroep_naam
