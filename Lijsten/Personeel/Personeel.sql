/*
    View: Personeel
    Personeelsleden in dienst.
*/

SELECT
    sis_pers.idpers AS personeel_id,
    sis_pers.doc_code AS personeel_code,

    sis_pers.voorlett AS voorletters,
    sis_pers.roepnaam AS roepnaam,
    sis_pers.voornamen AS voornamen,
    sis_pers.tussenvoeg AS tussenvoegsel,
    -- Geboortenaam gebruiken indien gevraagd	
    IIF(sis_pers.bgmsnm = true, sis_pers.ms_achtnm, sis_pers.achternaam) AS achternaam,

    -- CHECK persfunctie tabel bestaat niet, maar staat wel met * in Decibel lijst?
    -- sis_pers.idpersfunctie AS functie_id,
    sis_pers.c_hfdvak AS hoofdvak_code
FROM sis_pers
WHERE
    sis_pers.dvertrek IS NULL
ORDER BY personeel_code, achternaam
