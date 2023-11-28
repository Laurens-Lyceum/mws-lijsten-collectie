/*
    View: Lesgroepen
    Lesgroepen (stamklassen en clusters).
*/

SELECT
	sis_bgrp.idbgrp AS lesgroep_id,
	sis_bgrp.groep AS lesgroep_naam,
	sis_bgrp.omschr AS lesgroep_omschrijving,
	sis_bgrp.bklas AS is_stamklas,

	-- CHECK zijn mentoren geen many-to-many met aanstellings start/eind?
	-- sis_bgrp.idpers_mentor1 AS mentor1
	-- sis_bgrp.idpers_mentor1 AS mentor2
	-- sis_bgrp.idpers_mentor1 AS mentor3

	-- CHECK 1=stamklas, 2=cluster?
	-- sis_bgrp.groepssoort AS soort_groep

	sis_bgrp.idstud AS studie_id,
	sis_stud.studie AS studie_naam
FROM sis_bgrp
	LEFT JOIN sis_stud ON sis_stud.idstud = sis_bgrp.idstud
	LEFT JOIN sis_blpe ON sis_blpe.idblpe = sis_bgrp.idblpe
WHERE
	-- FUTURE "active date range" macro
	(sis_blpe.dbegin <= GETDATE() AND sis_blpe.deinde > GETDATE())
ORDER BY lesgroep_naam
