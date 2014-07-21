/* Formatted on 17/06/2014 18:16:58 (QP5 v5.227.12220.39754) */
CREATE OR REPLACE FORCE VIEW MCRE_OWN.VTMCRE0_APP_RIO_SCD
(
   RECORD_CHAR
)
AS
   SELECT CASE
             WHEN SUBSTR (record_char, 1, 10) = '0000000000'
             THEN
                RPAD (SUBSTR (record_char, 11, 8), 50, ' ')
             ELSE
                record_char
          END
             AS record_char
     FROM (SELECT RPAD ('0000000000' || TO_CHAR (SYSDATE, 'ddmmyyyy'),
                        50,
                        ' ')
                     AS record_char
             FROM DUAL
           UNION
           SELECT    NVL (F.COD_ABI_ISTITUTO, '     ')
                  || NVL (F.COD_ABI_CARTOLARIZZATO, '     ')
                  || NVL (F.COD_NDG, '                ')
                  || NVL (F.FLG_OUTSOURCING, ' ')
                  || DECODE (
                        DTA_ESITO,
                        NULL, TO_CHAR (
                                 (DTA_SERVIZIO + cm.VAL_GG_PRIMA_PROROGA),
                                 'dd/mm/yyyy'),
                        TO_CHAR ( (DTA_ESITO + cm.VAL_GG_SECONDA_PROROGA),
                                 'dd/mm/yyyy'))
                  || NVL (F.COD_STATO, '  ')
                  || '           '
                     record_char
             FROM t_mcre0_app_all_data_DAY F,
                  T_MCRE0_APP_COMPARTI cm,
                  T_MCRE0_APP_RIO_PROROGHE R
            WHERE     F.COD_MACROSTATO = 'RIO'
                  AND NVL (f.cod_comparto_assegnato, cod_comparto_calcolato) =
                         cm.cod_comparto(+)
                  AND f.cod_abi_cartolarizzato = r.cod_abi_cartolarizzato(+)
                  AND f.cod_ndg = r.cod_ndg(+)
                  AND r.flg_storico(+) = 0
                  AND r.flg_esito(+) = 1
                  AND f.flg_outsourcing = 'Y'
                  AND f.flg_target = 'Y'
                  AND flg_chk = '1'
                  AND today_flg = '1'
                  --AND 1 = 2
                  AND DECODE (DTA_ESITO,
                              NULL, (DTA_SERVIZIO + cm.VAL_GG_PRIMA_PROROGA),
                              DTA_ESITO + cm.VAL_GG_SECONDA_PROROGA) <
                         SYSDATE
           ORDER BY record_char ASC);


GRANT DELETE, INSERT, REFERENCES, SELECT, UPDATE, ON COMMIT REFRESH, QUERY REWRITE, DEBUG, FLASHBACK ON MCRE_OWN.VTMCRE0_APP_RIO_SCD TO MCRE_USR;
