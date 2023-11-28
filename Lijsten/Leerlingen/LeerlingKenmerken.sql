/*
	View: LeerlingKenmerken
	Kenmerken toegewezen aan leerlingen.
*/

SELECT
	lvsllkenmerk.stamnr AS stamnummer,
	lvsllkenmerk.idlvskenmerk AS kenmerk_id,
	lvskenmerk.kenmerk AS kenmerk_naam
FROM lvsllkenmerk
	LEFT JOIN lvskenmerk ON lvskenmerk.idlvskenmerk = lvsllkenmerk.idlvskenmerk
	-- FUTURE filter leerlingen
ORDER BY lvsllkenmerk.stamnr
