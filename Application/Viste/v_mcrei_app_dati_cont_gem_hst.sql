/* Formatted on 21/07/2014 18:39:15 (QP5 v5.227.12220.39754) */
CREATE OR REPLACE FORCE VIEW MCRE_OWN.V_MCREI_APP_DATI_CONT_GEM_HST
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
   SELECT d.cod_abi,
          d.cod_ndg,
          d.cod_protocollo_pacchetto,
          d.cod_protocollo_delibera,
          d.dta_last_upd_delibera,
          'PCR',
          NVL (d.val_perc_dubbio_esito, r.perc_de_appl / 100)
             AS perc_dubbio_esito,
          d.dta_scadenza_incaglio,
          NVL (d.val_accordato, p.val_imp_accordato) AS totale_accordato,
          NVL (d.val_uti_tot_scsb, p.val_imp_esp_compl) AS totale_utilizzato,
          NVL (d.val_imp_fondi_terzi, p.val_imp_fondo_terzi) AS fondo_terzi,
          NVL (d.val_uti_netto_fondo_terzi, p.val_imp_esp_netto_terzi)
             AS tot_uti_al_netto_fondo_terzi,
          d.val_uti_firma_scsb AS utilizzato_di_firma,
          NVL (d.val_uti_sosti_scsb, p.val_imp_derivati) AS derivati,
          d.val_esp_lorda_capitale AS uti_quota_capitale,
          d.val_esp_lorda_mora AS interessi_di_mora,
          d.val_rdv_qc_progressiva AS val_rettifica_prog_delib,
          d.val_uti_cassa_scsb AS utilizzato_di_cassa
     FROM mcre_own.t_mcrei_hst_delibere d,
          (  SELECT cod_abi, cod_ndg, perc_de_appl
               FROM mcre_own.t_mcrei_app_mpl_rapporti                 --22.970
           GROUP BY cod_abi, cod_ndg, perc_de_appl) r,           ----> ???????
          t_mcrei_app_mpl_proposte p
    WHERE     d.cod_abi = p.cod_abi(+)
          AND d.cod_ndg = p.cod_ndg(+)
          AND d.val_anno_proposta = p.val_anno_proposta(+)
          AND TO_CHAR (d.val_progr_proposta) = p.val_progr_proposta(+)
          AND d.cod_abi = r.cod_abi(+)
          AND d.cod_ndg = r.cod_ndg(+);
