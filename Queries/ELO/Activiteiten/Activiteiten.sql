/*
	View: Activiteiten
	Description: Activiteiten zichtbaar in het huidige schooljaar.
*/

-- FUTURE include macro?
-- CHECK could be used to simplify other queries?
DECLARE @HUIDIG_SCHOOLJAAR_BEGIN datetime;
DECLARE @HUIDIG_SCHOOLJAAR_EIND datetime;
SELECT
	@HUIDIG_SCHOOLJAAR_BEGIN = sis_blpe.dbegin,
	@HUIDIG_SCHOOLJAAR_EIND = sis_blpe.deinde
FROM sis_blpe
WHERE
    sis_blpe.dbegin <= GETDATE() AND sis_blpe.deinde > GETDATE();


SELECT
	activiteit.idactiviteit AS activiteit_id,
	activiteit.titel AS activiteit_titel,
	activiteit.details AS activiteit_details,
	-- CHECK activiteit.detailsoud

	activiteit.startinschrijfdatum AS inschrijven_start,
	activiteit.eindeinschrijfdatum AS inschrijven_einde,
	activiteit.zichtbaarvanaf AS zichtbaar_start,
	activiteit.zichtbaartotenmet AS zichtbaar_einde,

	activiteit.minonderdeelinschrijvingen AS inschrijvingen_min,
	activiteit.maxonderdeelinschrijvingen AS inschrijvingen_max

	-- CHECK activiteit.status
FROM activiteit
WHERE
	-- Zichtbaarheid overlapt met huidig schooljaar
	(activiteit.zichtbaarvanaf <= @HUIDIG_SCHOOLJAAR_EIND) AND (activiteit.zichtbaartotenmet >= @HUIDIG_SCHOOLJAAR_BEGIN)
ORDER BY activiteit.zichtbaarvanaf, activiteit.titel
