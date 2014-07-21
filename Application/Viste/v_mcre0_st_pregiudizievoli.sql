/* Formatted on 21/07/2014 18:37:56 (QP5 v5.227.12220.39754) */
CREATE OR REPLACE FORCE VIEW MCRE_OWN.V_MCRE0_ST_PREGIUDIZIEVOLI
(
   ID_DPER,
   COD_SNDG,
   COD_TIPO_NOTIZIA,
   DESC_TIPO_NOTIZIA,
   DTA_ELABORAZIONE
)
AS
   WITH T_MCRE0_FL_PREGIUDIZIEVOLI
        AS (SELECT (SELECT TO_NUMBER (
                              TO_CHAR (
                                 TO_DATE (TRIM (PERIODO_RIF), 'DDMMYYYY'),
                                 'YYYYMMDD'))
                      FROM TE_MCRE0_PGDZ_IDT
                     WHERE ROWNUM = 1)
                      ID_DPER,
                   COD_SNDG,
                   COD_TIPO_NOTIZIA,
                   DESC_TIPO_NOTIZIA,
                   TO_DATE (DTA_ELABORAZIONE, 'ddmmyyyy') AS DTA_ELABORAZIONE
              FROM TE_MCRE0_PGDZ_INC
             WHERE fnd_mcre0_is_date (DTA_ELABORAZIONE) = 1)
   SELECT "ID_DPER",
          "COD_SNDG",
          "COD_TIPO_NOTIZIA",
          "DESC_TIPO_NOTIZIA",
          "DTA_ELABORAZIONE"
     FROM (SELECT COUNT (
                     1)
                  OVER (
                     PARTITION BY id_dper,
                                  cod_sndg,
                                  cod_tipo_notizia,
                                  dta_elaborazione)
                     num_recs,
                  id_dper,
                  cod_sndg,
                  cod_tipo_notizia,
                  desc_tipo_notizia,
                  dta_elaborazione
             FROM T_MCRE0_FL_PREGIUDIZIEVOLI) tmp
    WHERE     NUM_RECS = 1
          AND TRIM (TO_CHAR (id_dper)) IS NOT NULL
          AND TRIM (cod_tipo_notizia) IS NOT NULL
          AND dta_elaborazione IS NOT NULL;
