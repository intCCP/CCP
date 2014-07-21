/* Formatted on 21/07/2014 18:35:11 (QP5 v5.227.12220.39754) */
CREATE OR REPLACE FORCE VIEW MCRE_OWN.V_MCRE0_APP_RIO_ANOMALIE
(
   COD_ABI_CARTOLARIZZATO,
   COD_GRUPPO_ECONOMICO,
   COD_NDG,
   DTA_RILEVAZIONE,
   FLG_SINGOLO_CLIENTE,
   FLG_TIPO_ANOMALIA,
   ID_ANOMALIA,
   VAL_ANOMALIA,
   COD_MACROSTATO,
   COD_STATO,
   COD_STATO_INIZIO
)
AS
   SELECT a.cod_abi_cartolarizzato,
          x.cod_gruppo_economico,
          a.cod_ndg,
          a.dta_rilevazione,
          a.flg_singolo_cliente,
          a.flg_tipo_anomalia,
          a.id_anomalia,
          a.val_anomalia,
          x.cod_macrostato,
          x.cod_stato,
          a.cod_stato_inizio
     FROM t_mcre0_app_rio_anomalie a, v_mcre0_app_upd_fields_p1 x
    WHERE     a.cod_abi_cartolarizzato = x.cod_abi_cartolarizzato
          AND a.cod_ndg = x.cod_ndg
          AND a.flg_delete = 0;
