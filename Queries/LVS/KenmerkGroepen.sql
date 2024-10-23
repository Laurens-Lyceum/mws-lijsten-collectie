/*
	View: KenmerkGroepen
	Description: Actieve kenmerk groepen waar kenmerken aan kunnen worden toegewezen.
*/

SELECT
	lvskenmerk.idlvskenmerk AS kenmerk_groep_id,
	lvskenmerk.kenmerk AS kenmerk_groep_naam
FROM lvskenmerk
WHERE
	lvskenmerk.actief = true
	-- idlvskenmerk ooit gebruikt als parentid -> dus is het een groep
	AND EXISTS (
		SELECT lvskenmerk.parentid
		FROM lvskenmerk it
		WHERE it.parentid = lvskenmerk.idlvskenmerk
	)
ORDER BY lvskenmerk.idlvskenmerk
