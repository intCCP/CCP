/* Formatted on 17/06/2014 18:05:54 (QP5 v5.227.12220.39754) */
CREATE OR REPLACE FORCE VIEW MCRE_OWN.V_MCRE0_RISTRUTTURATI
(
   COD_ABI_CARTOLARIZZATO,
   COD_NDG,
   COD_STATO,
   DTA_DECORRENZA_STATO,
   DTA_SCADENZA_STATO,
   COD_MACROSTATO,
   DTA_DEC_MACROSTATO
)
AS
   SELECT cod_abi_cartolarizzato,
          cod_ndg,
          CASE
             WHEN dta_chiusura_stato IS NULL THEN 'RS'
             ELSE cod_stato_dest
          END
             cod_stato,
          DTA_DECORRENZA_STATO,
          dta_chiusura_stato AS dta_scadenza_stato,
          CASE
             WHEN dta_chiusura_stato IS NULL THEN 'RS'
             ELSE cod_stato_dest
          END
             cod_macrostato,
          DTA_DECORRENZA_STATO dta_dec_macrostato
     FROM (SELECT r.*,
                  MAX (tms_ini)
                     OVER (PARTITION BY cod_abi_cartolarizzato, cod_ndg)
                     max_tms
             FROM T_MCRE0_APP_RS_POSIZIONI r
            WHERE dta_chiusura_stato IS NULL)
    WHERE tms_ini = max_tms;


GRANT SELECT ON MCRE_OWN.V_MCRE0_RISTRUTTURATI TO MCRE_USR;
