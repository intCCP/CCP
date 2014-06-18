/* Formatted on 17/06/2014 18:07:29 (QP5 v5.227.12220.39754) */
CREATE OR REPLACE FORCE VIEW MCRE_OWN.V_MCREI_APP_DATI_CONTABILI_GEM
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
   UTILIZZATO_DI_CASSA,
   VAL_ULTIMA_PERCENTUALE,
   DTA_RIF_ULTIMA_PERC,
   ESPOSIZIONE_DI_CASSA
)
AS
   SELECT d.cod_abi,
          d.cod_ndg,
          d.cod_protocollo_pacchetto,
          d.cod_protocollo_delibera,
          d.dta_last_upd_delibera,
          'PCR',
          NVL (D.VAL_PERC_DUBBIO_ESITO, R.PERC_DE_APPL / 100)
             AS PERC_DUBBIO_ESITO,
          d.dta_scadenza AS scadenza_incaglio, --09-09-2013 eliminato calcolo data
          NVL (d.val_accordato, p.val_imp_accordato) AS totale_accordato,
          NVL (d.val_uti_tot_scsb, p.val_imp_esp_compl) AS totale_utilizzato,
          --mm06.12 aggiunta temporaneamente nvl val_imp_fondi_terzi, flg_fondo terzi
          NVL (NVL (d.val_imp_fondi_terzi, d.flg_fondo_terzi),
               p.val_imp_fondo_terzi)
             AS fondo_terzi,
          NVL (d.val_uti_netto_fondo_terzi, p.val_imp_esp_netto_terzi)
             AS tot_uti_al_netto_fondo_terzi,
          d.val_uti_firma_scsb AS utilizzato_di_firma,
          NVL (d.val_uti_sosti_scsb, p.val_imp_derivati) AS derivati,
          d.val_esp_lorda_capitale AS uti_quota_capitale,
          d.val_esp_lorda_mora AS interessi_di_mora,
          NVL (d.val_rdv_qc_ante_delib, 0) + NVL (d.val_rdv_pregr_fi, 0)
             AS val_rettifica_prog_delib, ---solo per le CS: AD, corretto il 23 gen
          d.val_uti_cassa_scsb AS utilizzato_di_cassa,
          X.VAL_PERC_RISK AS VAL_ULTIMA_PERCENTUALE,
          X.DTA_REF AS DTA_RIF_ULTIMA_PERC,
          d.val_uti_cassa_scsb AS esposizione_di_cassa
     FROM mcre_own.t_mcrei_app_delibere d,
          (  SELECT cod_abi,
                    cod_ndg,
                    perc_de_appl,
                    val_anno_proposta,
                    val_progr_proposta
               FROM mcre_own.t_mcrei_app_mpl_rapporti                 --22.970
           GROUP BY cod_abi,
                    cod_ndg,
                    perc_de_appl,
                    val_anno_proposta,
                    val_progr_proposta) r,                       ----> ???????
          t_mcrei_app_mpl_proposte p,
          t_mcre0_app_rio_proroghe r1,
          t_mcre0_app_comparti c,
          t_mcre0_app_all_Data a,
          (SELECT cod_abi,
                  cod_ndg,
                  val_perc_risk,
                  dta_ref
             FROM (SELECT cod_abi,
                          cod_ndg,
                          val_perc_risk,
                          dta_ref,
                          MAX (dta_ref) OVER (PARTITION BY cod_abi, cod_ndg)
                             max_dta_ref
                     FROM t_mcrei_app_percentuali_ret)
            WHERE dta_ref = max_dta_ref) x                          --mm130515
    WHERE     d.flg_attiva = '1'
          AND d.cod_abi = p.cod_abi(+)
          AND d.cod_ndg = p.cod_ndg(+)
          AND d.val_anno_proposta = p.val_anno_proposta(+)
          AND TO_CHAR (d.val_progr_proposta) = p.val_progr_proposta(+)
          AND d.cod_protocollo_delibera = p.cod_protocollo_delibera(+)
          AND d.cod_abi = a.cod_abi_cartolarizzato
          AND d.cod_ndg = a.cod_ndg
          --15/5
          AND d.cod_abi = x.cod_abi(+)
          AND d.cod_ndg = x.cod_ndg(+)
          --
          AND d.cod_abi = r.cod_abi(+)
          AND d.cod_ndg = r.cod_ndg(+)
          AND d.val_anno_proposta = r.val_anno_proposta(+)
          AND TO_CHAR (d.val_progr_proposta) = r.val_progr_proposta(+)
          AND NVL (a.cod_comparto_assegnato, cod_comparto_calcolato) =
                 c.cod_comparto(+) --30 mar aggiunto recupero data scadenza in base a proroghe di default
          AND a.cod_abi_cartolarizzato = r1.cod_abi_cartolarizzato(+)
          AND a.cod_ndg = r1.cod_ndg(+)
          AND r1.flg_storico(+) = 0
          AND r1.flg_esito(+) = 1;


GRANT DELETE, INSERT, REFERENCES, SELECT, UPDATE, ON COMMIT REFRESH, QUERY REWRITE, DEBUG, FLASHBACK, MERGE VIEW ON MCRE_OWN.V_MCREI_APP_DATI_CONTABILI_GEM TO MCRE_USR;
