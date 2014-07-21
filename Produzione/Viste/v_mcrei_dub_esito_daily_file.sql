/* Formatted on 17/06/2014 18:08:57 (QP5 v5.227.12220.39754) */
CREATE OR REPLACE FORCE VIEW MCRE_OWN.V_MCREI_DUB_ESITO_DAILY_FILE
(
   LINE
)
AS
   SELECT    'COD_ABI'
          || ';'
          || 'COD_NSG'
          || ';'
          || 'DTA_DECORRENZA_STATO'
          || ';'
          || 'DTA_DELIBERA'
          || ';'
          || 'DTA_LAST_UPD_DELIBERA'
          || ';'
          || 'note'
          || ';'
          || 'IMPORTO_DELIB'
          || ';'
          || 'PERC_RDV'
             AS DUBBIO_ESITO
     FROM DUAL
   UNION ALL
   SELECT REPLACE (
                NVL (COD_ABI, '')
             || ';'
             || NVL (COD_NDG, '')
             || ';'
             || NVL (TO_CHAR (DTA_DECORRENZA_STATO, 'DD/MM/YYYY'), '')
             || ';'
             || NVL (TO_CHAR (DTA_DELIBERA, 'DD/MM/YYYY'), '')
             || ';'
             || NVL (TO_CHAR (DTA_LAST_UPD_DELIBERA, 'DD/MM/YYYY'), '')
             || ';'
             || NVL (REPLACE (NOTE, CHR (0), ''), '')
             || ';'
             || NVL (
                   REPLACE (
                      TO_CHAR (IMPORTO_DELIBERATO, 'FM9999999999990.00'),
                      CHR (0),
                      ''),
                   '')
             || ';'
             || NVL (REPLACE (TO_CHAR (PERC_STIMA, 'FM990.00'), CHR (0), ''),
                     ''),
             CHR (10),
             '')
             AS LINE
     FROM (SELECT *
             FROM (SELECT (CASE
                              WHEN COD_ABI = '01025' THEN '03069'
                              ELSE COD_ABI
                           END)
                             AS COD_ABI,
                          COD_NDG,
                          DTA_REF AS DTA_DECORRENZA_STATO,
                          DTA_DELIBERA_IT AS DTA_DELIBERA,
                          DTA_SCAD_DELIB_IT AS DTA_LAST_UPD_DELIBERA,
                          DESC_MOTIVAZIONE_PERC_RISK AS NOTE,
                          VAL_IMPORTO_DELIBERA_IT AS IMPORTO_DELIBERATO,
                          VAL_PERC_RISK AS PERC_STIMA
                     FROM T_MCREI_APP_PERCENTUALI_RET r
                    WHERE flg_attiva = '1'));


GRANT DELETE, INSERT, REFERENCES, SELECT, UPDATE, ON COMMIT REFRESH, QUERY REWRITE, DEBUG, FLASHBACK, MERGE VIEW ON MCRE_OWN.V_MCREI_DUB_ESITO_DAILY_FILE TO MCRE_USR;
