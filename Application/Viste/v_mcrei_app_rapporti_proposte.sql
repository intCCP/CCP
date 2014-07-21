/* Formatted on 21/07/2014 18:40:45 (QP5 v5.227.12220.39754) */
CREATE OR REPLACE FORCE VIEW MCRE_OWN.V_MCREI_APP_RAPPORTI_PROPOSTE
(
   COD_ABI_CARTOLARIZZATO,
   COD_RAPPORTO,
   COD_FORMA_TECNICA,
   DESC_FORMA_TECNICA,
   COD_TIPO_FIDO,
   COD_NATURA,
   VAL_ACCORDATO,
   VAL_UTILIZZATO,
   VAL_DI_CUI_CAPITALE,
   VAL_DI_CUI_MORA,
   VAL_NUM_RATE_IMPAGATE,
   VAL_IMP_RATE_IMPAGATE,
   VAL_DEBITO_RESIDUO,
   COD_PERIODICITA_RATE
)
AS
   SELECT DISTINCT
          d.cod_abi AS cod_abi_cartolarizzato,
          d.cod_rapporto AS cod_rapporto,
          d.cod_forma_tecnica AS cod_forma_tecnica,
          NVL (d.desc_forma_tecnica_rp, m.desc_ft) AS desc_forma_tecnica,
          NVL (d.cod_tipo_fido_rp, m.cod_tipo_rapp) AS cod_tipo_fido,
          d.cod_natura AS cod_natura,
          NVL (d.val_accordato_rp, m.val_imp_accordato) AS val_accordato,
          NVL (d.val_utilizzato_rp, m.val_imp_utilizzato) AS val_utilizzato,
          NVL (d.val_esp_quota_capitale_rp, m.val_esposizione_qc)
             AS val_di_cui_capitale,                       --> di cui capitale
          NVL (d.val_interessi, m.val_interessi_mora) AS val_di_cui_mora, --> di cui mora
          NVL (d.num_rate_rp, m.num_rate_impagate) AS val_num_rate_impagate, --> numero rate impagate
          NVL (d.val_importo_tot_rate_impagate, m.val_qc_rate_imp)
             AS val_imp_rate_impagate,                --> totale rate impagate
          NVL (d.val_debito_residuo, m.val_debito_residuo)
             AS val_debito_residuo,
          NVL (d.cod_periodicita_rate, m.desc_periodo)
             AS cod_periodicita_rate                      --> periodicità rate
     FROM t_mcrei_app_rapporti_proposte d, t_mcrei_app_mpl_rapporti m
    WHERE     d.cod_abi = m.cod_abi(+)
          AND d.cod_ndg = m.cod_ndg(+)
          AND d.val_anno_proposta = m.val_anno_proposta(+)
          AND TO_CHAR (d.val_progr_proposta) = m.val_progr_proposta(+);
