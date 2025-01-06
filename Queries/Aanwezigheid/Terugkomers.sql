/*
	View: Terugkomers
	Description: Terugkommaatregelen van het huidige schooljaar.
*/

SELECT
	sis_trgk.idtrgk AS terugkomer_id,
	sis_trgk.stamnr AS stamnummer,
	sis_trgk.idmreg AS gebruikte_maatregel,

	-- sis_trgk.aantal,
	sis_trgk.datum AS datum,
	sis_trgk.tijd AS tijd_begin,
	sis_trgk.tijdtot AS tijd_eind,

	sis_trgk.omschr AS terugkomer_omschrijving,
	-- sis_trgk.opmerking,

	-- Vreemde veldnamen in de database, maar dit komt overeen met de interface ten tijde van versie 6.4.25.0 (jan 2025)
	-- MWS tript met de alias "gemeld" voor btrgk_ok
	sis_trgk.btrgk_ok AS gemeld_ok,
	sis_trgk.gemeld AS gemeld_niet_of_niet_tijdig

	-- sis_trgk.idpers_mw_ctrl AS afhandeling_medewerker?,
	-- sis_trgk.t_ctrl AS afhandeling_tijd?
FROM sis_trgk
	LEFT JOIN sis_stud ON sis_trgk.idstud = sis_stud.idstud
WHERE
	-- FUTURE "active date range" macro
	(sis_stud.dbegin <= GETDATE() AND sis_stud.deinde > GETDATE()) 
ORDER BY datum DESC, sis_trgk.tijd, sis_trgk.stamnr 
