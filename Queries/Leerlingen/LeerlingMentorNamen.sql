/*
	View: LeerlingMentorNamen
	Description: Namen van mentoren van leerlingen. Zie <LeerlingMentoren> voor belangrijke kanttekeningen.
*/


-- LeerlingMentoren
DECLARE @leerling_mentoren table (leerling_id nvarchar(max), stamnummer nvarchar(max), mentor_id nvarchar(max), mentor_code nvarchar(max));
-- FUTURE query embed macro?
	-- Huidige lesperiode
	DECLARE @lesperiode varchar(max);

	SELECT
		@lesperiode = sis_blpe.lesperiode
	FROM sis_blpe
	WHERE
		(sis_blpe.dbegin <= GETDATE() AND sis_blpe.deinde >= GETDATE());

	-- Mentoren van leerlingen
	INSERT INTO @leerling_mentoren
	SELECT
		leerment.idleer AS leerling_id,
		leerment.stamnr AS stamnummer,
		leerment.mentor_id AS mentor_id,
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


-- Personeel
DECLARE @personeel table (personeel_id nvarchar(max), personeel_code nvarchar(max), voorletters nvarchar(max), roepnaam nvarchar(max), tussenvoegsel nvarchar(max), achternaam nvarchar(max));
-- FUTURE query embed macro?
	INSERT INTO @personeel
	SELECT
		sis_pers.idpers AS personeel_id,
		sis_pers.doc_code AS personeel_code,

		sis_pers.voorlett AS voorletters,
		sis_pers.roepnaam AS roepnaam,
		-- BUG wordt doorgegeven als Off._voornamen
		-- sis_pers.voornamen AS voornamen,
		sis_pers.tussenvoeg AS tussenvoegsel,
		-- Geboortenaam gebruiken indien gevraagd	
		IIF(sis_pers.bgmsnm = true, sis_pers.ms_achtnm, sis_pers.achternaam) AS achternaam

		-- CHECK persfunctie tabel bestaat niet, maar staat wel met * in Decibel lijst?
		-- sis_pers.idpersfunctie AS functie_id,
		-- sis_pers.c_hfdvak AS hoofdvak_code
	FROM sis_pers
	WHERE
		sis_pers.dvertrek IS NULL
	ORDER BY personeel_code, achternaam



SELECT
	lm.stamnummer AS stamnummer,
	STRING_AGG(CONCAT(p.voorletters, ' ', TRIM(CONCAT(p.tussenvoegsel, ' ', p.achternaam))), ', ') WITHIN GROUP (ORDER BY p.achternaam ASC) AS mentoren
FROM @leerling_mentoren AS lm
	LEFT JOIN @personeel AS p ON lm.mentor_id = p.personeel_id
GROUP BY lm.stamnummer
