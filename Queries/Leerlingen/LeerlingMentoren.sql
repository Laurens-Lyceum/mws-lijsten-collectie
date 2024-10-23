/*
	View: LeerlingMentoren.
	Description: Mentoren van een leerling.
	Column: bron
		- `null` voor persoonlijke mentoren
		- `lesgroep_naam` voor mentoren via een lesgroep
	
	Warning: Ten tijde van Magister 6.4.23 (okt 2024) kunnen mentoren gekoppeld worden aan alle lesgroepen, maar alleen die van de stamklas worden getoond op Magister Web.
	Deze view volgt voorlopig Magister Web en toont alleen de stamklas mentoren.
*/


-- Huidige lesperiode
DECLARE @lesperiode varchar(max);

SELECT
	@lesperiode = sis_blpe.lesperiode
FROM sis_blpe
WHERE
	(sis_blpe.dbegin <= GETDATE() AND sis_blpe.deinde >= GETDATE());


-- Mentoren van leerlingen
SELECT
	leerment.idleer AS leerling_id,
	leerment.stamnr AS stamnummer,
	leerment.mentor_id,
	sis_pers.doc_code AS mentor_code
FROM
	(
		SELECT
			sis_aanm.idleer,
			sis_aanm.stamnr,

			sis_aanm.idpers_mentor1 AS p1,
			sis_aanm.idpers_mentor2 AS p2,

			sis_bgrp.idpers_mentor1 AS k1,
			sis_bgrp.idpers_mentor2 AS k2,
			sis_bgrp.idpers_mentor3 AS k3
		FROM sis_aanm
			-- NOTE Magister Web toont alleen stamklassen, zie waarschuwing bovenaan. Anders route via sis_lvak...
			LEFT JOIN sis_bgrp ON sis_bgrp.idbgrp = sis_aanm.idbgrp
		WHERE
			sis_aanm.lesperiode = @lesperiode
	) AS leerment_pv

	UNPIVOT (
		mentor_id FOR _ IN (p1, p2, k1, k2, k3)
	) AS leerment

	LEFT JOIN sis_pers ON leerment.mentor_id = sis_pers.idpers
ORDER BY stamnummer ASC, mentor_code ASC
