/*
	View: StudieTeamleiderNamen
	Description: Namen van teamleiders van studies. Zie <StudieTeamleiders>.
*/


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
	stl.studie_id AS studie_id,
	stl.studie_naam AS studie_naam,
	STRING_AGG(CONCAT(p.voorletters, ' ', TRIM(CONCAT(p.tussenvoegsel, ' ', p.achternaam))), ', ') WITHIN GROUP (ORDER BY p.achternaam ASC) AS teamleiders
FROM @studie_teamleiders AS stl
	LEFT JOIN @personeel AS p ON stl.teamleider_id = p.personeel_id
GROUP BY stl.studie_id, stl.studie_naam
