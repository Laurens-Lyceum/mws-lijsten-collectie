/*
	View: Cijferkolommen.
	Description: Cijferkolommen.
*/

SELECT
	sis_ckol.idckol AS cijferkolom_id,
	
	sis_ckol.idstud AS studie_id,
	sis_stud.studie AS studie_naam,

	sis_ckol.idcper AS cijferperiode_id,
	sis_ckol.c_periode AS cijferperiode_naam,

	sis_ckol.kol_naam AS cijferkolom_naam,
	sis_ckol.c_vak AS vak_code,
	sis_ckol.kol_nr AS cijferkolom_nummer,

	kol_oms.omschr AS cijferkolom_kop,
	sis_ckol.omschr AS cijferkolom_omschrijving,
	
	-- Lijkt altijd 1 te zijn in moderne gegevens
	-- sis_ckol.soort,
	
	(CASE sis_ckol.soort_kol
		WHEN 1 THEN 'Cijfer'
		WHEN 2 THEN 'Gemiddelde'
		WHEN 3 THEN 'Maximum'
		WHEN 4 THEN 'Formule'
		-- WHEN 5 THEN ''
		WHEN 6 THEN 'Som'
		-- WHEN 7 THEN 'CHECK'
		-- WHEN 8 THEN 'CHECK'
		-- WHEN 9 THEN 'CHECK'
		-- WHEN 10 THEN 'CHECK'
		-- WHEN 11 THEN 'CHECK'
		-- WHEN 12 THEN 'CHECK'
		-- WHEN 13 THEN 'CHECK'
		-- WHEN 14 THEN 'CHECK'
		ELSE CAST(sis_ckol.soort_kol AS nvarchar)
	END) AS cijferkolom_soort,
	
	sis_ckol.init_wfac AS weegfactor,
	sis_ckol.bflexcijfer AS zichtbaar,
	sis_ckol.bherkansing AS herkansing,
	sis_ckol.dvervallen AS vervallen,

	-- sis_ckol.no_dec,
	-- sis_ckol.min_cijfer,
	-- sis_ckol.max_cijfer,
	-- sis_ckol.bex_kolom AS ptopta,
	
	-- sis_ckol.idformule,
	-- sis_ckol.formule,

	sis_ckol.externeid AS cijferkolom_extid,
	sis_ckol.volgnr AS cijferkolom_volgnr
FROM sis_ckol
	LEFT JOIN sis_stud ON sis_ckol.idstud = sis_stud.idstud
	LEFT JOIN kol_oms ON kol_oms.idkol_oms = sis_ckol.idkol_oms
	LEFT JOIN sis_cper ON sis_ckol.idcper = sis_cper.idcper
WHERE
	-- FUTURE "active date range" macro
	-- FUTURE "active cijfer periode"
	(sis_stud.dbegin <= GETDATE() AND sis_stud.deinde > GETDATE())
ORDER BY sis_stud.volgnr, sis_cper.dbegin, sis_ckol.c_vak, sis_ckol.volgnr, sis_ckol.kol_nr
