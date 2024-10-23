/*
	View: LeerlingKenmerken
	Description: Kenmerken toegewezen aan leerlingen.
*/

SELECT
	lvsllkenmerk.idlvsllkenmerk AS leerling_kenmerk_koppelid,
	lvsllkenmerk.stamnr AS stamnummer,
	lvsllkenmerk.idlvskenmerk AS kenmerk_id,
	lvskenmerk.kenmerk AS kenmerk_naam
FROM lvsllkenmerk
	LEFT JOIN lvskenmerk ON lvskenmerk.idlvskenmerk = lvsllkenmerk.idlvskenmerk
	-- FUTURE filter leerlingen
	-- FUTURE filter hulpmiddelen
ORDER BY lvsllkenmerk.stamnr
