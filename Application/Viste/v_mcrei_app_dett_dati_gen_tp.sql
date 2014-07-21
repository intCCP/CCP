/* Formatted on 21/07/2014 18:39:50 (QP5 v5.227.12220.39754) */
CREATE OR REPLACE FORCE VIEW MCRE_OWN.V_MCREI_APP_DETT_DATI_GEN_TP
(
   COD_ABI,
   COD_NDG,
   COD_PROTOCOLLO_DELIBERA,
   COD_PROTOCOLLO_PACCHETTO,
   VAL_ESPOSIZIONE_CASSA,
   VAL_ESPOSIZIONE_FIRMA,
   VAL_ESPOSIZIONE_DERIVATI,
   VAL_ESPOSIZIONE_CASSA_QTA_CAP,
   VAL_ESPOSIZIONE_CASSA_MORA,
   VAL_RDV_CASSA,
   VAL_RDV_FIRMA,
   RINUNCIA_CONTABILIZZATA,
   VAL_RINUNCIA_DELIBERATA,
   NUOVA_RINUNCIA_PROPOSTA,
   RDV_PROGRESSIVE,
   TOTALE_RINUNCE,
   VAL_PERC_RINUNCIA
)
AS
   SELECT cod_abi,
          cod_ndg,
          cod_protocollo_delibera,
          cod_protocollo_pacchetto,
          val_esposizione_cassa,
          val_esposizione_firma,
          val_esposizione_derivati,
          val_esposizione_cassa_qta_cap,
          val_esposizione_cassa_mora,
          val_rdv_cassa,
          val_rdv_firma,
          rinuncia_contabilizzata,
          val_rinuncia_deliberata,
          DECODE (rinuncia_contabilizzata,
                  NULL, nuova_rinuncia_proposta,
                  NULL)
             AS nuova_rinuncia_proposta, ---21 FEB, AD: CORRETTA VISUALIZZAZIONE SU SEGNALAZIONE DI DURANTE
          (val_rdv_cassa + val_rdv_firma) AS rdv_progressive,
          (  rinuncia_contabilizzata
           + val_rinuncia_deliberata
           + DECODE (rinuncia_contabilizzata,
                     NULL, nuova_rinuncia_proposta,
                     0))
             AS totale_rinunce, -- SE ESISTONO STRALCI CONTABILIZZATI, LA NUOVA PROPOSTA NON VA PI¿ VISUALIZZATA
          val_perc_rinuncia
     FROM v_mcrei_app_dett_delib_transaz;
