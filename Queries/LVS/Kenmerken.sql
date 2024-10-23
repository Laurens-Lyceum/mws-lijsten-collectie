/*
	View: Kenmerken
	Description: Actieve kenmerken die aan leerlingen kunnen worden toegewezen.
*/

SELECT
	lvskenmerk.idlvskenmerk AS kenmerk_id,
	lvskenmerk.kenmerk AS kenmerk_naam,
	-- XXX only the first parent, not the full path. Does MSSQL have a 'path'/tree type like Postgres?
	parent.kenmerk AS groep,
	lvskenmerk.diagnosecode AS diagnose_code
FROM lvskenmerk
	LEFT JOIN lvskenmerk parent ON parent.idlvskenmerk = lvskenmerk.parentid
WHERE
	lvskenmerk.actief = true
	-- idlvskenmerk wordt nooit gebruikt als parentid -> dus is het geen groep
	AND NOT EXISTS (
		SELECT lvskenmerk.parentid
		FROM lvskenmerk it
		WHERE it.parentid = lvskenmerk.idlvskenmerk
	)
ORDER BY lvskenmerk.idlvskenmerk
