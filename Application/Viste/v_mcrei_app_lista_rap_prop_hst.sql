/* Formatted on 21/07/2014 18:40:25 (QP5 v5.227.12220.39754) */
CREATE OR REPLACE FORCE VIEW MCRE_OWN.V_MCREI_APP_LISTA_RAP_PROP_HST
(
   COD_ABI_CARTOLARIZZATO,
   COD_NDG,
   COD_RAPPORTO,
   COD_FORMA_TECNICA,
   DESC_FORMA_TECNICA,
   COD_NATURA,
   DESC_NATURA,
   VAL_ACCORDATO,
   VAL_UTILIZZATO,
   DI_CUI_CAPITALE,
   DI_CUI_MORA,
   NUMERO_RATE_IMPAGATE,
   IMPORTO_TOTALE_RATE_IMPAGATE,
   DEBITO_RESIDUO,
   PERIODICITA,
   COD_TIPO_FIDO,
   COD_CLASSE_FT,
   COD_TIPO_RAPPORTO,
   COD_RAPPORTO_ATTR
)
AS
   SELECT rp.cod_abi AS cod_abi_cartolarizzato,
          rp.cod_ndg,
          rp.cod_rapporto,
          rp.cod_forma_tecnica AS cod_forma_tecnica,
          desc_forma_tecnica_rp AS desc_forma_tecnica,
          rp.cod_natura AS cod_natura,
          nat.desc_natura AS desc_natura,
          rp.val_accordato_rp AS val_accordato,
          rp.val_utilizzato_rp AS val_utilizzato,
          rp.val_esp_quota_capitale_rp AS di_cui_capitale,
          rp.val_interessi AS di_cui_mora,
          rp.num_rate_rp AS numero_rate_impagate,
          rp.val_importo_tot_rate_impagate AS importo_totale_rate_impagate,
          rp.val_debito_residuo AS debito_residuo,
          rp.cod_periodicita_rate AS periodicita,
          rp.cod_tipo_fido_rp AS cod_tipo_fido,
          rp.cod_classe_ft AS cod_classe_ft,
          rp.cod_tipo_rapporto_rp AS cod_tipo_rapporto, ---modificato il 24/2,
          rp.desc_attr_anagrafico_rp AS cod_rapporto_attr               --28/2
     FROM t_mcrei_hst_rapporti_proposte rp, t_mcre0_app_natura_ftecnica nat
    WHERE rp.cod_forma_tecnica = nat.cod_ftecnica;
