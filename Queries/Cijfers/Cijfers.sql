/*
	View: Cijfers.
	Description: Cijfers.
*/

SELECT
	sis_cijf.idcijf AS cijfer_id,

	sis_cijf.idckol AS cijferkolom_id,
	sis_ckol.c_vak AS vak_code,
	sis_ckol.kol_nr AS cijferkolom_nummer,
	
	sis_cijf.stamnr AS stamnummer,
	sis_cijf.cijfer AS cijfer,
	sis_cijf.binhalen AS is_inhalen,
	sis_cijf.bvrijstelling AS is_vrijstelling,

	-- sis_cijf.btelt_mee AS telt_mee
	IIF(ISNUMERIC(sis_cijf.wfac) = true, sis_cijf.wfac, sis_ckol.init_wfac) AS weegfactor,
	sis_cijf.dbehaald AS behaald_op,

	-- sis_ckol.bherkansing AS cijferkolom_is_herkansing,
	sis_ckol.herkansing AS herkansing_index

	-- sis_cijf.blok AS geblokkeerd,
	-- sis_cijf.manual AS handmatig,
FROM sis_cijf
	LEFT JOIN sis_ckol ON sis_cijf.idckol = sis_ckol.idckol
	LEFT JOIN sis_cper ON sis_ckol.idcper = sis_cper.idcper
	LEFT JOIN sis_stud ON sis_ckol.idstud = sis_stud.idstud
WHERE
	-- FUTURE "active date range" macro
	-- FUTURE "active cijfer periode"
	(sis_stud.dbegin <= GETDATE() AND sis_stud.deinde > GETDATE())
ORDER BY sis_stud.volgnr, sis_cper.dbegin, sis_ckol.volgnr, stamnr
