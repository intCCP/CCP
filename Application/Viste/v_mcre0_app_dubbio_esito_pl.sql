/* Formatted on 21/07/2014 18:33:26 (QP5 v5.227.12220.39754) */
CREATE OR REPLACE FORCE VIEW MCRE_OWN.V_MCRE0_APP_DUBBIO_ESITO_PL
(
   VAL_ANNO,
   COD_NUMERO_PRATICA,
   COD_ABI,
   COD_NDG,
   DTA_REF,
   VAL_PCT_DUBBIO_ESITO,
   DESC_MOTIVO,
   VAL_RDV_CAPITALE,
   DTA_DELIBERA
)
AS
   SELECT p.val_anno_pratica AS val_anno,                                 --PK
          p.cod_pratica AS cod_numero_pratica,
          --PK
          p.cod_abi AS cod_abi,                                           --PK
          p.cod_ndg AS cod_ndg,                                           --PK
          pr.dta_ref AS dta_ref,
          pr.val_perc_risk AS val_pct_dubbio_esito,
          pr.desc_motivazione_perc_risk AS desc_motivo,
          pr.val_importo_delibera_it AS val_rdv_capitale,
          pr.dta_delibera_it AS dta_delibera
     FROM t_mcrei_app_pratiche p,
          t_mcrei_app_percentuali_ret pr,
          t_mcre0_app_all_data ad
    WHERE     p.cod_abi = pr.cod_abi
          AND p.cod_ndg = pr.cod_ndg
          AND p.cod_abi = ad.cod_abi_cartolarizzato
          AND p.cod_ndg = ad.cod_ndg
          AND ad.flg_active = '1';
