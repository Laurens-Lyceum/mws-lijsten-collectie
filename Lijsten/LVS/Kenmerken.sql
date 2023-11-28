/*
	View: Kenmerken
	Actieve kenmerken die aan leerlingen kunnen worden toegewezen.
*/

SELECT
	lvskenmerk.idlvskenmerk AS kenmerk_id,
	lvskenmerk.kenmerk AS kenmerk_naam,
	parent.kenmerk AS groep
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
