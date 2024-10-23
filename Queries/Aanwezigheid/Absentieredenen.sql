/*
	View: Absentieredenen
	Description: Actieve absentieredenen.
*/

SELECT
	sis_abty.idabty as absentiereden_id,
	sis_abty.code as absentiereden_code,
	sis_abty.omschr as absentiereden_omschrijving,
	-- sis_abty.barcode as barcode

	sis_abty.idverantwoordingtypen as verantwoordingstype_id,
	verantwoordingtypen.omschr as verantwoordingstype_omschrijving,
	
	sis_abty.geoorloofd as geoorloofd,
	sis_abty.bluxeverzuim as luxeverzuim
	-- sis_abty.isbeschikbaarvoorouders as beschikbaar_voor_ouders,
	-- sis_abty.bsuggmtr as maatregel_voorstellen
	-- sis_abty.typemaat as maatregel_type
FROM sis_abty
	LEFT JOIN verantwoordingtypen ON verantwoordingtypen.idverantwoordingtypen = sis_abty.idverantwoordingtypen
WHERE
	sis_abty.bvervallen = FALSE
ORDER BY absentiereden_code
