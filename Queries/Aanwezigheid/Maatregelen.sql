/*
	View: Maatregelen
	Description: Ingestelde maatregelen voor het huidige schooljaar.
*/

SELECT
	sis_mreg.idmreg AS maatregel_id,
	sis_stud.studie AS studie_naam,
	-- sis_mreg.code AS maatregel_code,
	/*(CASE sis_mreg.type
		WHEN 1 THEN 'CHECK'
		WHEN 2 THEN 'CHECK'
		ELSE CAST(sis_mreg.type AS nvarchar)
	END) AS maatregel_type,*/
	sis_mreg.omschr AS maatregel_omschrijving,

	verantwoordingtypen.omschr AS verantwoording_type,
	-- Niet meer gebruikt sinds 10/11: aantalabsn, aantalovrt, aantaltl, aantaluitg
	sis_mreg.aantalvantype AS aantal_registraties,

	sis_mreg.dagen AS aantal_dagen,
	sis_mreg.tijd AS tijd_begin,
	sis_mreg.tijdtot AS tijd_eind        
FROM sis_mreg
	LEFT JOIN sis_stud ON sis_mreg.idstud = sis_stud.idstud
	LEFT JOIN verantwoordingtypen ON sis_mreg.idverantwoordingtypen = verantwoordingtypen.idverantwoordingtypen
WHERE
	-- FUTURE "active date range" macro
	(sis_stud.dbegin <= GETDATE() AND sis_stud.deinde > GETDATE()) 
ORDER BY sis_stud.studie, verantwoordingtypen.omschr, sis_mreg.aantalvantype, sis_mreg.idmreg
