/* Formatted on 17/06/2014 18:08:26 (QP5 v5.227.12220.39754) */
CREATE OR REPLACE FORCE VIEW MCRE_OWN.V_MCREI_APP_LISTA_RAPPORTI
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
   ORIG_COD_RAPPORTO_ATTR,
   COD_RAPPORTO_ATTR,
   COD_TIPO_RAPPORTO
)
AS
   SELECT pcr.cod_abi AS cod_abi_cartolarizzato,
          pcr.cod_ndg,
          pcr.cod_rapporto,
          pcr.cod_forma_tecnica,
          nat.desc_ftecnica AS desc_forma_tecnica,
          nat.cod_natura,
          nat.desc_natura,
          pcr.val_accordato_delib AS val_accordato,
          pcr.val_imp_utilizzato AS val_utilizzato,
          TO_NUMBER (pcr.val_imp_utilizzato - NVL (rate.val_imp_mora, 0))
             AS di_cui_capitale,
          TO_NUMBER (NVL (rate.val_imp_mora, 0)) AS di_cui_mora,
          TRUNC (rate.val_coeff_rate_arretrate) AS numero_rate_impagate, --5 marzo
          rate.val_imp_arretrato AS importo_totale_rate_impagate,
          rate.val_imp_debito_residuo AS debito_residuo,
          rate.cod_periodo AS periodicita,
          pcr.cod_tipo_fido,
          pcr.cod_classe_ft,
          pcr.cod_rapporto_attr AS orig_cod_rapporto_attr,
          NULL AS cod_rapporto_attr, --19 marzo ripristino null per gestione lato host del recupero da anagrafe
          nat.cod_tipo_rapporto
     FROM t_mcrei_app_pcr_rapporti pcr,
          t_mcre0_app_natura_ftecnica nat,
          t_mcre0_app_rate_daily rate,                                  -- 5/3
          t_mcre0_app_all_data g                                       --6 giu
    WHERE     pcr.cod_forma_tecnica = nat.cod_ftecnica(+)
          AND pcr.cod_abi = rate.cod_abi_cartolarizzato(+)
          AND pcr.cod_ndg = rate.cod_ndg(+)
          AND pcr.cod_rapporto = rate.cod_rapporto(+)
          AND pcr.cod_classe_ft IN ('CA', 'FI', 'ST')
          AND g.cod_abi_cartolarizzato = pcr.cod_abi
          AND g.cod_ndg = pcr.cod_ndg
          -- SOLO TARGET E OUTSOURCING  7 giu
          AND g.flg_outsourcing = 'Y'
          AND g.flg_target = 'Y'
          AND g.today_flg = 1;


GRANT DELETE, INSERT, REFERENCES, SELECT, UPDATE, ON COMMIT REFRESH, QUERY REWRITE, DEBUG, FLASHBACK, MERGE VIEW ON MCRE_OWN.V_MCREI_APP_LISTA_RAPPORTI TO MCRE_USR;
