/* Formatted on 21/07/2014 18:40:48 (QP5 v5.227.12220.39754) */
CREATE OR REPLACE FORCE VIEW MCRE_OWN.V_MCREI_APP_REPORT_DUBBIO_ESIT
(
   DUBBIO_ESITO
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
          || 'DESC_OSSERVAZIONI'
          || ';'
          || 'IMPORTO_DELIB'
          || ';'
          || 'PERC_RDV'
             AS DUBBIO_ESITO
     FROM DUAL
   UNION ALL
   SELECT    COD_ABI
          || ';'
          || COD_NDG
          || ';'
          || DTA_DECORRENZA_STATO
          || ';'
          || DTA_DELIBERA
          || ';'
          || DTA_LAST_UPD_DELIBERA
          || ';'
          || DESC_OSSERVAZIONI
          || ';'
          || IMPORTO_DELIB
          || ';'
          || PERC_STIMA
             AS PERC_RDV
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
                          DESC_MOTIVAZIONE_PERC_RISK AS DESC_OSSERVAZIONI,
                          VAL_IMPORTO_DELIBERA_IT AS IMPORTO_DELIB,
                          VAL_PERC_RISK AS PERC_STIMA
                     FROM T_MCREI_APP_PERCENTUALI_RET r
                    WHERE flg_attiva = '1')
            WHERE (    COD_ABI IN
                          ('03069',
                           '01010',
                           '06385',
                           '06010',
                           '05748',
                           '06345',
                           '06340',
                           '06225',
                           '03059')
                   AND (   DESC_OSSERVAZIONI LIKE '%/%/% Prot%'
                        OR UPPER (DESC_OSSERVAZIONI) LIKE 'IMPIANTO%'
                        OR UPPER (DESC_OSSERVAZIONI) LIKE
                              'RETTIFICA DI VALORE DERIVANTE DA TABELLA FORFETARI%'
                        OR /*DTA_DECORRENZA_stima = @VARIABLE('Data Adeguamenti Mensile') AND*/
                          UPPER (DESC_OSSERVAZIONI) LIKE 'ADEGUAMENTO%')))
   ORDER BY 1 DESC;
