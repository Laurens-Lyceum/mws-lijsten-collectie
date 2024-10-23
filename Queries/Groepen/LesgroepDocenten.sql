/*
	View: LesgroepDocenten
	Description: Lesgroepen met de docent(en) die les geven in een vak.
*/

SELECT
	sis_pgvk.idpgvk AS lesgroep_docent_koppelid,
	sis_bgrp.idbgrp AS lesgroep_id,
	sis_bgrp.groep AS lesgroep_naam,
	-- Niet alle lesgroepen hebben een intrinsiek vak: stamklassen
	sis_pgvk.c_vak AS vak_code,
	sis_pgvk.idpers AS docent_id,
	sis_pers.doc_code AS docent_code
FROM sis_pgvk
	INNER JOIN sis_pers ON sis_pers.idpers = sis_pgvk.idpers
	INNER JOIN sis_bgrp ON sis_bgrp.idbgrp = sis_pgvk.idbgrp
	INNER JOIN sis_blpe ON sis_pgvk.lesperiode = sis_blpe.lesperiode
WHERE
	-- FUTURE "active date range" macro
	(sis_blpe.dbegin <= GETDATE() AND sis_blpe.deinde > GETDATE())

	-- CHECK staat in decibel als "hoofddocent", controleer meerdere docenten op één lesgroep
	--   Zou eigenlijk willen filteren op "aanstelling" start/einde
	AND sis_pgvk.actief = true
ORDER BY docent_code, lesgroep_naam
