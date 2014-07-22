/* Formatted on 21/07/2014 18:40:13 (QP5 v5.227.12220.39754) */
CREATE OR REPLACE FORCE VIEW MCRE_OWN.V_MCREI_APP_ELENCO_DELIB_STRUT
(
   ID_DPER,
   COD_STRUTTURA_COMPETENTE,
   DESC_COMPARTO,
   COD_PROTOCOLLO_DELIBERA,
   COD_ABI_CARTOLARIZZATO,
   DESC_ISTITUTO,
   COD_FILIALE,
   COD_STRUTTURA_COMPETENTE_DV,
   DESC_STRUTTURA_COMPETENTE_DV,
   COD_STRUTTURA_COMPETENTE_DC,
   DESC_STRUTTURA_COMPETENTE_DC,
   COD_STRUTTURA_COMPETENTE_RG,
   DESC_STRUTTURA_COMPETENTE_RG,
   COD_STRUTTURA_COMPETENTE_AR,
   DESC_STRUTTURA_COMPETENTE_AR,
   COD_STRUTTURA_COMPETENTE_FI,
   DESC_STRUTTURA_COMPETENTE_FI,
   COD_NDG,
   DESC_NOME_CONTROPARTE,
   COD_STATO,
   COD_PROCESSO,
   DESC_TIPO_GESTIONE,
   COD_GRUPPO_ECONOMICO,
   DESC_GRUPPO_ECONOMICO,
   COD_MICROTIPOLOGIA_DELIB,
   DESC_MICROTIPOLOGIA,
   DTA_DELIBERA,
   DTA_AGGIORNAMENTO,
   COD_ORGANO_DELIBERANTE,
   GESTORE,
   DESC_GESTORE,
   COD_TIPO_GESTIONE,
   DESC_NOTE,
   COD_SNDG,
   COD_FASE_MICROTIPOLOGIA,
   COD_MACROTIPOLOGIA_DELIB,
   DESC_MACROTIPOLOGIA,
   COD_CAUSA_CHIUS_DELIBERA,
   DTA_DECORRENZA_STATO,
   DTA_SCADENZA,
   DTA_SCADENZA_TRANSAZ,
   DTA_CONFERMA_DELIBERA,
   DTA_LAST_UPD_DELIBERA,
   DESC_DENOMINAZ_INS_DELIBERA,
   COD_ORGANO_CALCOLATO,
   COD_PROTOCOLLO_DELIBERA_COL,
   VAL_CASSA_LORDA,
   VAL_CASSA_LORDA_CAPITALE,
   VAL_CASSA_LORDA_MORA,
   VAL_ESP_NETTA_ANTE_DELIB,
   VAL_ESP_NETTA_POST_DELIB,
   VAL_ESP_FIRMA,
   VAL_RDV_PROGR_TOT,
   VAL_RDV_QC_ANTE_DELIB,
   VAL_RDV_QC_DELIBERATA,
   VAL_RDV_QC_PROGRESSIVA,
   VAL_RDV_PREGR_FI,
   VAL_RDV_FI_PROPOSTA,
   VAL_RDV_DER_ANTE_DELIB,
   VAL_RDV_DER_PROPOSTA,
   VAL_RDV_DER_PROGR,
   VAL_PERC_RDV,
   VAL_RINUNCIA_DELIBERATA,
   VAL_RINUNCIA_PROPOSTA,
   VAL_RINUNCIA_MORA,
   VAL_RINUNCIA_TOTALE,
   VAL_STRALCIO_QUOTA_CAP,
   VAL_STRALCIO_QUOTA_MORA
)
AS
   SELECT d.id_dper,
          f.cod_struttura_competente,
          f.desc_comparto,
          d.cod_protocollo_delibera,
          d.cod_abi AS cod_abi_cartolarizzato,
          f.DESC_ISTITUTO,
          f.cod_filiale,
          cod_struttura_competente_dv,
          f.DESC_STRUTTURA_COMPETENTE_DV,
          cod_struttura_competente_dc,
          f.DESC_STRUTTURA_COMPETENTE_DC,
          cod_struttura_competente_rg,
          f.DESC_STRUTTURA_COMPETENTE_RG,
          cod_struttura_competente_ar,
          f.DESC_STRUTTURA_COMPETENTE_AR,
          cod_struttura_competente_fi,
          f.DESC_STRUTTURA_COMPETENTE_FI,
          d.cod_ndg,
          f.desc_nome_controparte,
          f.cod_stato,
          f.cod_processo,
          d.desc_tipo_gestione,
          f.COD_GRUPPO_ECONOMICO,
          f.DESC_GRUPPO_ECONOMICO,
          d.cod_microtipologia_delib,
          tip.DESC_MICROTIPOLOGIA,
          d.dta_delibera,
          d.dta_last_upd_delibera DTA_AGGIORNAMENTO,
          d.cod_organo_deliberante,
          f.cod_matricola gestore,
          f.nome || ' ' || f.cognome desc_gestore,
          p.COD_TIPO_GESTIONE,
          d.desc_note,
          d.cod_sndg,
          d.cod_fase_microtipologia,
          d.cod_macrotipologia_delib,
          tip.DESC_MACROTIPOLOGIA,
          d.cod_causa_chius_delibera,
          f.dta_decorrenza_stato,
          d.dta_scadenza,
          d.dta_scadenza_transaz,
          d.dta_conferma_delibera,
          dta_last_upd_delibera,
          d.desc_denominaz_ins_delibera,
          d.cod_organo_calcolato,
          d.cod_protocollo_delibera_col,
          --ESPOSIZIONE CASSA
          d.val_esp_lorda AS val_cassa_lorda,
          d.val_esp_lorda_capitale AS val_cassa_lorda_capitale,
          val_esp_lorda_mora AS val_cassa_lorda_mora,
          d.val_esp_netta_ante_delib,
          val_esp_netta_post_delib,
          val_esp_firma,
          --RDV
          NVL (d.val_rdv_qc_progressiva, 0) + NVL (D.val_rdv_progr_fi, 0)
             AS VAL_RDV_PROGR_TOT,
          D.VAL_RDV_QC_ANTE_DELIB,
            NVL (d.val_rdv_qc_progressiva, 0)
          - NVL (D.VAL_RDV_QC_ANTE_DELIB, 0)
             AS VAL_RDV_QC_DELIBERATA,
          d.val_rdv_qc_progressiva,
          d.val_rdv_pregr_fi,
          NVL (d.val_rdv_pregr_fi, 0) - NVL (D.val_rdv_progr_fi, 0)
             AS VAL_RDV_FI_PROPOSTA,
          TO_NUMBER (NULL) VAL_rdv_der_ante_delib,
          TO_NUMBER (NULL) VAL_rdv_der_proposta,
          TO_NUMBER (NULL) VAL_rdv_der_progr,
          d.val_perc_rdv,
          --RINUNCIA
          d.val_rinuncia_deliberata,
          d.val_rinuncia_proposta,
          d.val_rinuncia_mora,
          d.val_rinuncia_totale,
          --STRALCI
          d.val_stralcio_quota_cap,
          d.val_stralcio_quota_mora
     FROM t_mcrei_app_delibere_storico d,
          v_mcre0_app_upd_fields f,                                        --,
          t_mcrei_app_pratiche p,
          t_mcrei_cl_tipologie tip
    WHERE                         --d.cod_fase_pacchetto NOT IN ('ANA', 'ANM')
              --AND d.cod_tipo_pacchetto != 'A'
              d.flg_no_delibera = '1'
          AND d.flg_attiva = '1'
          AND d.cod_microtipologia_delib = tip.cod_microtipologia(+)
          AND d.cod_abi = f.cod_abi_cartolarizzato
          AND d.cod_ndg = f.cod_ndg
          AND d.cod_abi = p.cod_abi
          AND d.cod_ndg = p.cod_ndg;