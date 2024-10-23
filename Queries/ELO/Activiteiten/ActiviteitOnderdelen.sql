/*
	View: ActiviteitOnderdelen
	Description: Onderdelen van activiteiten zichtbaar in het huidige schooljaar.
*/

-- FUTURE include macro?
DECLARE @HUIDIG_SCHOOLJAAR_BEGIN datetime;
DECLARE @HUIDIG_SCHOOLJAAR_EIND datetime;
SELECT
	@HUIDIG_SCHOOLJAAR_BEGIN = sis_blpe.dbegin,
	@HUIDIG_SCHOOLJAAR_EIND = sis_blpe.deinde
FROM sis_blpe
WHERE
    sis_blpe.dbegin <= GETDATE() AND sis_blpe.deinde > GETDATE()


SELECT
	activiteitonderdeel.idactiviteitonderdeel AS activiteit_onderdeel_id,
	activiteitonderdeel.idactiviteit AS activiteit_id,
	activiteitonderdeel.titel AS activiteit_onderdeel_titel,
	activiteitonderdeel.details AS activiteit_onderdeel_details,
	-- CHECK activiteitonderdeel.detailsoud

	activiteitonderdeel.minaantaldeelnemers AS deelnemers_min,
	activiteitonderdeel.maxaantaldeelnemers AS deelnemers_max,
	activiteitonderdeel.isopinteschrijven AS kan_inschrijven,

	-- TODO linked to what?
	activiteitonderdeel.kleurstelling AS kleur_id,
	activiteitonderdeel.volgnummer AS volgnummer
-- CHECK activiteitonderdeel.iddocumentscontainer  
FROM activiteitonderdeel
	LEFT JOIN activiteit ON activiteit.idactiviteit = activiteitonderdeel.idactiviteit
WHERE
	-- Zichtbaarheid overlapt met huidig schooljaar
	(activiteit.zichtbaarvanaf <= @HUIDIG_SCHOOLJAAR_EIND) AND (activiteit.zichtbaartotenmet >= @HUIDIG_SCHOOLJAAR_BEGIN)
ORDER BY activiteit.zichtbaarvanaf, activiteitonderdeel.idactiviteit, activiteitonderdeel.volgnummer
