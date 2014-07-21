/* Formatted on 21/07/2014 18:39:20 (QP5 v5.227.12220.39754) */
CREATE OR REPLACE FORCE VIEW MCRE_OWN.V_MCREI_APP_DATI_CONTABILI_MPL
(
   COD_ABI_CARTOLARIZZATO,
   COD_NDG,
   COD_PROTOCOLLO_PACCHETTO,
   COD_PROTOCOLLO_DELIBERA,
   DATA_AGGIORNAMENTO_DATI,
   FONTE_DATI,
   PERC_DUBBIO_ESITO,
   SCADENZA_INCAGLIO,
   TOTALE_ACCORDATO,
   TOTALE_UTILIZZATO,
   FONDO_TERZI,
   TOT_UTI_AL_NETTO_FONDO_TERZI,
   UTILIZZATO_DI_FIRMA,
   DERIVATI,
   UTI_QUOTA_CAPITALE,
   INTERESSI_DI_MORA,
   VAL_RETTIFICA_PROG_DELIB,
   UTILIZZATO_DI_CASSA
)
AS
   SELECT R.cod_abi AS COD_ABI_CARTOLARIZZATO,
          R.cod_ndg,
          D.cod_protocollo_pacchetto,
          D.cod_protocollo_delibera,
          D.dta_last_upd_delibera,
          'PCR' AS FONTE_DATI,
          R.PERC_DE_APPL / 100 AS PERC_DUBBIO_ESITO,
          D.dta_scadenza_incaglio AS SCADENZA_INCAGLIO,
          P.VAL_IMP_ACCORDATO AS TOTALE_ACCORDATO,
          P.VAL_IMP_ESP_COMPL AS TOTALE_UTILIZZATO, --> = D.val_uti_tot_scsb ???
          P.VAL_IMP_FONDO_TERZI AS FONDO_TERZI,     --> D.val_imp_fondi_terzi,
          P.VAL_IMP_ESP_NETTO_TERZI AS TOT_UTI_AL_NETTO_FONDO_TERZI, -->  D.val_uti_netto_fondo_terzi
          D.val_uti_firma_scsb AS UTILIZZATO_DI_FIRMA, --> val_uti_firma_scsb, --NON c'è di firma
          P.VAL_IMP_DERIVATI AS DERIVATI,               -->val_uti_sosti_scsb,
          D.VAL_eSP_LORDA_CAPITALE AS UTI_QUOTA_CAPITALE, -->val_esp_lorda_capitale, P.VAL_IMP_ESPOSIZ_QC + P.VAL_IMP_INT_MORA , ma non sono sempre uguali
          d.val_esp_lorda_mora AS INTERESSI_DI_MORA, --> p.VAL_IMP_INT_MORA , ma non sono sempre uguali
          d.val_rdv_qc_progressiva AS VAL_RETTIFICA_PROG_DELIB, --> val_rdv_qc_progressiva
          d.val_uti_cassa_scsb AS UTILIZZATO_DI_CASSA
     FROM (  SELECT COD_ABI, COD_NDG, PERC_DE_APPL
               FROM MCRE_OWN.T_MCREI_APP_MPL_RAPPORTI                 --22.970
           GROUP BY COD_ABI, COD_NDG, PERC_DE_APPL) R,           ----> ???????
          MCRE_OWN.T_MCREI_APP_DELIBERE D,
          T_MCREI_APP_MPL_PROPOSTE P                                  --10.128
    WHERE     P.COD_ABI = D.COD_ABI
          AND P.COD_NDG = D.COD_NDG
          AND P.VAL_ANNO_PROPOSTA = D.VAL_ANNO_PROPOSTA
          AND P.VAL_PROGR_PROPOSTA = D.VAL_PROGR_PROPOSTA
          AND R.COD_ABI = D.COD_ABI
          AND R.COD_NDG = D.COD_NDG
          AND D.FLG_ATTIVA = 1;
