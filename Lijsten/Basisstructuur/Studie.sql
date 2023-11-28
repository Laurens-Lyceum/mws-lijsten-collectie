/*
	View: Studie
	Studie/klassenlagen (4VWO, 5HAVO, etc).
*/

SELECT
	sis_stud.idstud AS studie_id,
	sis_stud.studie AS studie_naam,
	sis_stud.omschr AS studie_omschrijving,

	sis_stud.idschoolsoort AS schoolsoort_id,
	schoolsoort.code AS schoolsoort_code,

	sis_stud.leerjaar AS leerjaar,
	sis_stud.bonderbouw AS is_onderbouw
FROM sis_stud
	LEFT JOIN schoolsoort ON schoolsoort.idschoolsoort = sis_stud.idschoolsoort
WHERE
	-- FUTURE "active date range" macro
	(sis_stud.dbegin <= GETDATE() AND sis_stud.deinde > GETDATE())
ORDER BY studie_naam
