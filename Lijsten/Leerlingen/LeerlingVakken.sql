/*
    View: LeerlingVakken
    Huidige vakkenpakketten van leerlingen die op dit moment op school zitten.
*/

SELECT
    sis_lvak.stamnr AS stamnummer,
    sis_lvak.c_vak AS vakcode
    -- sis_lvak.idbgrp AS lesgroep, (NULL if stamklas)

    -- sis_lvak.idstud AS klassenlaag,
    -- sis_lvak.idaanmelding AS aanmelding_id,

    -- FUTURE handle vrijstellingen
    -- sis_lvak.heeftvrijstelling*
    -- sis_lvak.bdispensatie AS dispensatie,
    -- sis_lvak.idlvakvervangendvak AS vervangend_vak,
FROM sis_lvak
WHERE
    -- FUTURE "active date range" macro
    (sis_lvak.dbegin <= GETDATE() AND sis_lvak.deinde > GETDATE())
ORDER BY sis_lvak.stamnr
