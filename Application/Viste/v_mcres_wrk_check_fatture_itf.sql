/* Formatted on 21/07/2014 18:44:37 (QP5 v5.227.12220.39754) */
CREATE OR REPLACE FORCE VIEW MCRE_OWN.V_MCRES_WRK_CHECK_FATTURE_ITF
(
   COD_AUTORIZZAZIONE,
   VAL_NUMERO_FATTURA,
   VAL_ANNO_FATTURA,
   DESC_CFPIVA_LEGALE
)
AS
   SELECT --  20130128    Andrea Galliano Vista di apppoggio per controllo fatture duplicate nel flusso spese di italfondiario
         cod_autorizzazione,
          val_numero_fattura,
          TO_CHAR (dta_fattura, 'Y') val_anno_fattura,
          desc_cfpiva_legale
     FROM t_mcres_fl_spese_itf
   UNION ALL
   SELECT cod_autorizzazione,
          val_numero_fattura,
          TO_CHAR (dta_fattura, 'Y') val_anno_fattura,
          desc_cfpiva_legale
     FROM t_mcres_app_spese_itf
   UNION ALL
   SELECT cod_autorizzazione,
          val_numero_fattura,
          TO_CHAR (dta_fattura, 'Y') val_anno_fattura,
          NVL (val_intestatario_piva, val_intestatario_codfisc)
             desc_cfpiva_legale
     FROM t_mcres_app_sp_spese;
