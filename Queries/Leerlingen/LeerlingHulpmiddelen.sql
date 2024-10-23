/*
	View: LeerlingHulpmiddelen
	Description: Hulpmiddelen toegekend aan leerlingen.
*/

-- FUTURE unpivot?

SELECT
	ToegekendeHulpmiddelenLeerling.id AS leerling_hulpmiddel_koppelid,
	sis_leer.stamnr AS stamnummer,

	ToegekendeHulpmiddelenLeerling.heeftextratijd AS extra_tijd,
	ToegekendeHulpmiddelenLeerling.heeftextratijdrekenen AS extra_tijd_rekenen,
	ToegekendeHulpmiddelenLeerling.heeftlaptop AS laptop,
	ToegekendeHulpmiddelenLeerling.heeftpauze AS pauze,
	ToegekendeHulpmiddelenLeerling.heeftrekenkaart AS rekenkaart,
	ToegekendeHulpmiddelenLeerling.heeftspellingscontrole AS spellingscontrole,
	ToegekendeHulpmiddelenLeerling.heeftverklanking AS verklanking
FROM ToegekendeHulpmiddelenLeerling
	LEFT JOIN sis_leer ON sis_leer.idLeer = ToegekendeHulpmiddelenLeerling.idleer
	LEFT JOIN sis_blpe ON sis_blpe.lesperiode = ToegekendeHulpmiddelenLeerling.lesperiode
WHERE
	-- FUTURE "active date range" macro
    (sis_blpe.dbegin <= GETDATE() AND sis_blpe.deinde > GETDATE())
	-- FUTURE filter leerlingen
	-- FUTURE filter hulpmiddelen
ORDER BY sis_leer.stamnr
