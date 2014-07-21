/* Formatted on 21/07/2014 18:44:38 (QP5 v5.227.12220.39754) */
CREATE OR REPLACE FORCE VIEW MCRE_OWN.V_MCRES_WRK_CHECK_PROFORMA_ITF
(
   COD_AUTORIZZAZIONE,
   COD_ABI,
   COD_NDG,
   DESC_CFPIVA_LEGALE
)
AS
   SELECT                                     -- 20130131 AG Created this view
         cod_autorizzazione,
          cod_abi,
          cod_ndg,
          NVL (val_intestatario_piva, val_intestatario_codfisc)
             desc_cfpiva_legale
     FROM t_mcres_app_sp_spese
    WHERE     0 = 0
          AND cod_tipo_autorizzazione = '5'
          AND cod_stato != 'AN'
          AND val_numero_fattura IS NULL
   ---
   UNION ALL
   ---
   SELECT cod_autorizzazione,
          cod_abi,
          cod_ndg,
          desc_cfpiva_legale
     FROM t_mcres_fl_spese_itf
    WHERE     0 = 0
          AND cod_tipo_autorizzazione = '5'
          AND val_numero_fattura IS NULL;
