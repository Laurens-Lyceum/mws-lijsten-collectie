/*
	View: StudieTeamleiders
	Description: Teamleiders van een studie.
*/


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
