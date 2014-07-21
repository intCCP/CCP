/* Formatted on 21/07/2014 18:38:00 (QP5 v5.227.12220.39754) */
CREATE OR REPLACE FORCE VIEW MCRE_OWN.V_MCRE0_STATO
(
   COD_ABI_CARTOLARIZZATO,
   COD_NDG,
   COD_STATO,
   DTA_DECORRENZA_STATO,
   DTA_SCADENZA_STATO
)
AS
   SELECT cod_abi_cartolarizzato,
          cod_ndg,
          cod_stato,
          DTA_DECORRENZA_STATO,
          DTA_SCADENZA_STATO
     FROM t_mcre0_day_mopl m
    WHERE     NOT EXISTS
                     (SELECT 1
                        FROM T_MCRE0_APP_GB_GESTIONE g
                       WHERE     flg_stato = '1'
                             AND m.cod_abi_cartolarizzato =
                                    g.cod_abi_cartolarizzato
                             AND m.cod_ndg = g.cod_ndg)
          AND NOT EXISTS
                     (SELECT 1
                        FROM T_MCRE0_APP_RS_POSIZIONI rs
                       WHERE     m.cod_abi_cartolarizzato =
                                    rs.cod_abi_cartolarizzato
                             AND m.cod_ndg = rs.cod_ndg)
   UNION ALL
   SELECT cod_abi_cartolarizzato,
          cod_ndg,
          'GB' cod_stato,
          DTA_STATO AS DTA_DECORRENZA_STATO,
          NULL AS DTA_SCADENZA_STATO
     FROM T_MCRE0_APP_GB_GESTIONE g
    WHERE flg_stato = '1'
   UNION ALL
   SELECT cod_abi_cartolarizzato,
          cod_ndg,
          'RS' cod_stato,
          DTA_DECORRENZA_STATO,
          dta_chiusura_stato AS DTA_SCADENZA_STATO
     FROM (SELECT r.*,
                  MAX (tms_ini)
                     OVER (PARTITION BY cod_abi_cartolarizzato, cod_ndg)
                     max_tms
             FROM T_MCRE0_APP_RS_POSIZIONI r
            WHERE dta_chiusura_stato IS NULL)
    WHERE tms_ini = max_tms;
