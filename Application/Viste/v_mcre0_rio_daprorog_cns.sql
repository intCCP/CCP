/* Formatted on 21/07/2014 18:37:32 (QP5 v5.227.12220.39754) */
CREATE OR REPLACE FORCE VIEW MCRE_OWN.V_MCRE0_RIO_DAPROROG_CNS
(
   COD_ABI_CARTOLARIZZATO,
   COD_NDG
)
AS
   SELECT DISTINCT R.COD_ABI_CARTOLARIZZATO, r.cod_ndg
     FROM V_MCRE0_APP_ALERT_RIO_DAPROROG r, t_mcrei_app_delibere p
    WHERE     p.cod_abi(+) = r.cod_abi_cartolarizzato
          AND p.cod_ndg(+) = r.cod_ndg
          AND p.cod_microtipologia_delib(+) = 'CI'
          AND COD_MACROSTATO = 'IN'
          AND cod_fase_delibera(+) = 'CO'
          AND p.cod_protocollo_delibera IS NULL;
