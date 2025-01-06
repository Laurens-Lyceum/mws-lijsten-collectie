/*
	View: TerugkommaatregelBrieven
	Description: Nog niet afgehandelde toekomstige terugkommaatregelen in het huidige schooljaar, met gegevens voor brieven.
*/


-- TerugkomdagenPerMaatregel
DECLARE @terugkomdagen table (stamnummer nvarchar(max), maatregel_omschrijving nvarchar(max), datums nvarchar(max));
-- FUTURE query embed macro?
	INSERT INTO @terugkomdagen
	SELECT
		sis_trgk.stamnr AS stamnummer,
		sis_mreg.omschr AS maatregel_omschrijving,
		-- FIXME DISTINCT subquery?
		STRING_AGG(FORMAT(sis_trgk.datum, 'd MMMM yyyy', 'nl-NL'), ', ') WITHIN GROUP (ORDER BY sis_trgk.datum ASC) AS datums
	FROM sis_trgk
		LEFT JOIN sis_stud ON sis_trgk.idstud = sis_stud.idstud
		LEFT JOIN sis_mreg ON sis_trgk.idmreg = sis_mreg.idmreg
	WHERE
		-- FUTURE "active date range" macro
		(sis_stud.dbegin <= GETDATE() AND sis_stud.deinde > GETDATE()) 
		AND (sis_trgk.btrgk_ok = FALSE AND sis_trgk.gemeld = FALSE)
		AND (sis_trgk.datum >= GETDATE())
	GROUP BY sis_trgk.stamnr, sis_mreg.omschr
	ORDER BY stamnr, datums


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


-- LeerlingMentorenNamen
DECLARE @leerling_mentoren_namen table (stamnummer nvarchar(max), mentoren nvarchar(max));
-- FUTURE query embed macro?

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

	INSERT INTO @leerling_mentoren_namen
	SELECT
		lm.stamnummer AS stamnummer,
		STRING_AGG(CONCAT(p.voorletters, ' ', TRIM(CONCAT(p.tussenvoegsel, ' ', p.achternaam))), ', ') WITHIN GROUP (ORDER BY p.achternaam ASC) AS mentoren
	FROM @leerling_mentoren AS lm
		LEFT JOIN @personeel AS p ON lm.mentor_id = p.personeel_id
	GROUP BY lm.stamnummer


-- StudieTeamleiderNamen
DECLARE @studie_teamleider_namen table (studie_id nvarchar(max), studie_naam nvarchar(max), teamleiders nvarchar(max));
-- FUTURE query embed macro?

	-- StudieTeamleiders
	DECLARE @studie_teamleiders table (studie_id nvarchar(max), studie_naam nvarchar(max), teamleider_id nvarchar(max), teamleider_code nvarchar(max));
	-- FUTURE query embed macro?
		INSERT INTO @studie_teamleiders
		SELECT
			studtl.idstud AS studie_id,
			studtl.studie AS studie_naam,
			studtl.teamleider_id AS teamleider_id,
			sis_pers.doc_code AS teamleider_code
		FROM
			(
				SELECT
					sis_stud.idstud,
					sis_stud.studie,

					sis_stud.idpers_coord1 AS tl1,
					sis_stud.idpers_coord2 AS tl2
				FROM sis_stud
				WHERE
					-- FUTURE "active date range" macro
					(sis_stud.dbegin <= GETDATE() AND sis_stud.deinde > GETDATE())
			) AS studtl_pv

			UNPIVOT (
				teamleider_id FOR _ IN (tl1, tl2)
			) AS studtl

			LEFT JOIN sis_pers ON studtl.teamleider_id = sis_pers.idpers
		ORDER BY studie_naam ASC, teamleider_code ASC

	INSERT INTO @studie_teamleider_namen
	SELECT
		stl.studie_id AS studie_id,
		stl.studie_naam AS studie_naam,
		STRING_AGG(CONCAT(p.voorletters, ' ', TRIM(CONCAT(p.tussenvoegsel, ' ', p.achternaam))), ', ') WITHIN GROUP (ORDER BY p.achternaam ASC) AS teamleiders
	FROM @studie_teamleiders AS stl
		LEFT JOIN @personeel AS p ON stl.teamleider_id = p.personeel_id
	GROUP BY stl.studie_id, stl.studie_naam



SELECT
	terugkomdagen.stamnummer AS Stamnummer,
	terugkomdagen.maatregel_omschrijving AS Maatregel,
	terugkomdagen.datums AS Terugkomdagen,

	sis_leer.roepnaam AS Voornaam,
	TRIM(CONCAT(sis_leer.tussenvoeg, ' ', sis_leer.achternaam)) AS Achternaam,
	sis_bgrp.groep AS Stamklas,

	leerling_mentoren_namen.mentoren AS Mentoren,
	studie_teamleider_namen.teamleiders AS Teamleiders
	
	-- STRING_AGG(mentoren.mentor_code, ', ') WITHIN GROUP (ORDER BY mentoren.mentor_code ASC) AS Mentor,
	-- Mentor
	-- Teamleider
FROM @terugkomdagen AS terugkomdagen
	LEFT JOIN sis_leer ON terugkomdagen.stamnummer = sis_leer.stamnr
	LEFT JOIN sis_aanm ON terugkomdagen.stamnummer = sis_aanm.stamnr
	LEFT JOIN sis_bgrp ON sis_aanm.idbgrp = sis_bgrp.idbgrp

	LEFT JOIN @leerling_mentoren_namen AS leerling_mentoren_namen ON terugkomdagen.stamnummer = leerling_mentoren_namen.stamnummer
	LEFT JOIN @studie_teamleider_namen AS studie_teamleider_namen ON sis_aanm.idstud = studie_teamleider_namen.studie_id
WHERE
	-- FUTURE "active date range" macro
	(sis_aanm.dbegin <= GETDATE() AND sis_aanm.deinde > GETDATE())
ORDER BY Stamnummer, Terugkomdagen, Maatregel
