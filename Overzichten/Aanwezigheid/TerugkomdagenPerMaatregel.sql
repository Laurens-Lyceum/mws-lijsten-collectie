/*
	View: TerugkomdagenPerMaatregel
	Description: Nog niet afgehandelde toekomstige terugkomdagen in het huidige schooljaar per leerling per maatregel.
*/

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
