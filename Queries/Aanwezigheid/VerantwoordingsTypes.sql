/*
	View: VerantwoordingsTypes.
	Description: Type verantwoordingen.
*/

SELECT
	verantwoordingtypen.idverantwoordingtypen AS verantwoordingstype_id,
	verantwoordingtypen.omschr AS verantwoordingstype_omschrijving
FROM verantwoordingtypen
ORDER BY verantwoordingtypen.volgnr
