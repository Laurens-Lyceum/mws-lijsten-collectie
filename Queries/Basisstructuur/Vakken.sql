/*
	View: Vakken
	Description: Vakken die op dit moment op school gegeven worden.
*/

/*
	CHECK op LL veel vakken die niet meer gegeven worden maar ook niet vervallen zijn.
	Alternatief: filter op EXISTS (sis_pgvk/sis_lvak WHERE dbegin <= GETDATE() AND deinde > GETDATE())
*/

SELECT
	sis_bvak.idbvak AS vak_id,
	sis_bvak.c_vak AS vak_code,
	sis_bvak.omschr AS vak_omschrijving,
	sis_bvak.off_nr AS officieel_nummer,
	sis_bvak.off_omschr AS officiele_vak_naam
	-- sis_bvak.off_omschr2 AS officiele_vaknaam_vervolg,

	-- sis_bvak.idblkl AS lokaalwens,
	-- sis_bvak.idlokaaltype AS lokaaltypewens,
	-- sis_bvak.bhardelokaaltypewens AS harde_lokaaltypewens,
FROM sis_bvak
WHERE
	sis_bvak.vervallen = false
ORDER BY sis_bvak.idbvak
