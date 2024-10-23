/*
	View: Verantwoordingen
	Description: Verantwoordingen van het huidige schooljaar die geen presentie zijn en niet in de toekomst liggen.
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
	verantwoording.idverantwoording AS verantwoording_id,
	sis_abty.code AS absentiereden_code,
	verantwoording.stamnr AS stamnummer,

	verantwoording.daanwezigheid AS verantwoording_datum,
	verantwoording.lesuur AS verantwoording_lesuur,
	verantwoording.moment AS verantwoording_moment,
	verantwoording.idagendaitem AS agendaitem_id,

	verantwoording.dinvoer AS datum_invoer,
	-- verantwoording.idmldr AS gemeld_door,
	-- verantwoording.idgebr AS genoteerd_door,
	verantwoording.bmaatrgetrf AS maatregel_getroffen,
	verantwoording.opmerking AS opmerking

	-- verantwoording.idbgrp AS lesgroep,
	-- verantwoording.idpers AS docent,
	-- verantwoording.idstud AS studie,
	-- verantwoording.idblkl AS lokaal,
	-- verantwoording.idmldw AS meldwijze
FROM verantwoording
	LEFT JOIN sis_abty ON sis_abty.idabty = verantwoording.idabty
WHERE
	(verantwoording.moment >= @HUIDIG_SCHOOLJAAR_BEGIN) AND (verantwoording.moment < @HUIDIG_SCHOOLJAAR_EIND)
	AND verantwoording.daanwezigheid <= GETDATE()
	AND verantwoording.idabty NOT IN (
		-- Verantwoordingen die als "Present" worden beschouwd
		SELECT
			sis_abty.idabty
		FROM sis_abty
			LEFT JOIN verantwoordingtypen ON verantwoordingtypen.idverantwoordingtypen = sis_abty.idverantwoordingtypen
		WHERE
			sis_abty.bvervallen = 0
			-- XXX Omschrijvingen zijn waarschijnlijk niet immutable, maar id (5 bij LL) zijn misschien niet constant...
			AND verantwoordingtypen.omschr = 'Present'
	)
	-- TODO filter on code
ORDER BY verantwoording.daanwezigheid DESC, verantwoording.stamnr, verantwoording.moment, verantwoording.idagendaitem
