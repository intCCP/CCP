/* Formatted on 17/06/2014 18:05:38 (QP5 v5.227.12220.39754) */
CREATE OR REPLACE FORCE VIEW MCRE_OWN.V_MCRE0_PCR_MAU
(
   COD_GRUPPO_ECONOMICO,
   GB_VAL_MAU,
   GEGB_MAU,
   GEGB_UTI_FIRMA,
   GEGB_UTI_CASSA,
   GEGB_ACC_FIRMA,
   GEGB_ACC_CASSA
)
AS
     SELECT g.COD_GRUPPO_ECONOMICO,              --count(distinct gb_val_mau),
            MIN (
               CASE
                  WHEN COD_GRUPPO_ECONOMICO =
                          (SELECT ge.cod_gruppo_economico
                             FROM t_mcre0_dwh_ge ge
                            WHERE g.cod_sndg = ge.cod_sndg(+))
                  THEN
                     gb_val_mau
                  ELSE
                     NULL
               END)
               GB_VAL_MAU,
            MIN (
               CASE
                  WHEN COD_GRUPPO_ECONOMICO =
                          (SELECT ge.cod_gruppo_economico
                             FROM t_mcre0_dwh_ge ge
                            WHERE g.cod_sndg = ge.cod_sndg(+))
                  THEN
                     GEGB_MAU
                  ELSE
                     NULL
               END)
               GEGB_MAU,
            MIN (
               CASE
                  WHEN COD_GRUPPO_ECONOMICO =
                          (SELECT ge.cod_gruppo_economico
                             FROM t_mcre0_dwh_ge ge
                            WHERE g.cod_sndg = ge.cod_sndg(+))
                  THEN
                     GEGB_UTI_FIRMA
                  ELSE
                     NULL
               END)
               GEGB_UTI_FIRMA,
            MIN (
               CASE
                  WHEN COD_GRUPPO_ECONOMICO =
                          (SELECT ge.cod_gruppo_economico
                             FROM t_mcre0_dwh_ge ge
                            WHERE g.cod_sndg = ge.cod_sndg(+))
                  THEN
                     GEGB_UTI_CASSA
                  ELSE
                     NULL
               END)
               GEGB_UTI_CASSA,
            MIN (
               CASE
                  WHEN COD_GRUPPO_ECONOMICO =
                          (SELECT ge.cod_gruppo_economico
                             FROM t_mcre0_dwh_ge ge
                            WHERE g.cod_sndg = ge.cod_sndg(+))
                  THEN
                     GEGB_ACC_FIRMA
                  ELSE
                     NULL
               END)
               GEGB_ACC_FIRMA,
            MIN (
               CASE
                  WHEN COD_GRUPPO_ECONOMICO =
                          (SELECT ge.cod_gruppo_economico
                             FROM t_mcre0_dwh_ge ge
                            WHERE g.cod_sndg = ge.cod_sndg(+))
                  THEN
                     GEGB_ACC_CASSA
                  ELSE
                     NULL
               END)
               GEGB_ACC_CASSA
       FROM ttmcre0_pcr_wrk g
      WHERE g.cod_gruppo_economico IS NOT NULL AND flg_erase = '0'
   GROUP BY g.cod_gruppo_economico
     HAVING COUNT (DISTINCT gb_val_mau) > 1;


GRANT SELECT ON MCRE_OWN.V_MCRE0_PCR_MAU TO MCRE_USR;
