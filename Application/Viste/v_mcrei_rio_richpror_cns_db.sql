/* Formatted on 21/07/2014 18:41:08 (QP5 v5.227.12220.39754) */
CREATE OR REPLACE FORCE VIEW MCRE_OWN.V_MCREI_RIO_RICHPROR_CNS_DB
(
   REC
)
AS
   SELECT DISTINCT r.cod_abi_cartolarizzato || '-' || r.cod_ndg
     FROM v_mcre0_app_alert_rio_richpror r, t_mcrei_app_delibere p
    WHERE     p.cod_abi(+) = r.cod_abi_cartolarizzato
          AND p.cod_ndg(+) = r.cod_ndg
          AND p.cod_microtipologia_delib(+) = 'CI'
          AND cod_macrostato = 'IN'
          AND cod_fase_delibera(+) = 'CO'
          AND p.cod_protocollo_delibera IS NULL;
