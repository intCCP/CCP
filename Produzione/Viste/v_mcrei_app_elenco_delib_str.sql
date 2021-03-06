/* Formatted on 17/06/2014 18:08:11 (QP5 v5.227.12220.39754) */
CREATE OR REPLACE FORCE VIEW MCRE_OWN.V_MCREI_APP_ELENCO_DELIB_STR
(
   ID_DPER,
   COD_STRUTTURA_COMPETENTE,
   COD_COMPARTO,
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
   COD_FASE_DELIBERA,
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
   VAL_RDV_PROGR_FI,
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
   (SELECT d.id_dper,
           D.cod_struttura_competente,
           D.cod_comparto,
           D.desc_comparto,
           d.cod_protocollo_delibera,
           d.cod_abi AS cod_abi_cartolarizzato,
           D.desc_istituto,
           D.cod_filiale,
           D.cod_struttura_competente_dv,
           D.desc_struttura_competente_dv,
           D.cod_struttura_competente_dc,
           D.desc_struttura_competente_dc,
           D.cod_struttura_competente_rg,
           D.desc_struttura_competente_rg,
           D.cod_struttura_competente_ar,
           D.desc_struttura_competente_ar,
           D.cod_struttura_competente_fi,
           D.desc_struttura_competente_fi,
           d.cod_ndg,
           D.desc_nome_controparte,
           D.cod_stato,
           D.cod_processo,
           d.desc_tipo_gestione,
           D.cod_gruppo_economico,
           D.desc_gruppo_economico,
           d.cod_microtipologia_delib,
           D.desc_microtipologia,
           d.dta_delibera,
           d.dta_last_upd_delibera dta_aggiornamento,
           d.cod_organo_deliberante,
           D.cod_matricola gestore,
           D.nome || ' ' || D.cognome desc_gestore,
           D.cod_tipo_gestione,
           d.desc_note,
           d.cod_sndg,
           d.cod_fase_delibera,
           d.cod_fase_microtipologia,
           d.cod_macrotipologia_delib,
           D.desc_macrotipologia,
           d.cod_causa_chius_delibera,
           D.dta_decorrenza_stato,
           d.dta_scadenza,
           d.dta_scadenza_transaz,
           d.dta_conferma_delibera,
           dta_last_upd_delibera,
           d.desc_denominaz_ins_delibera,
           d.cod_organo_calcolato,
           d.cod_protocollo_delibera_col,                        --ESPOSIZIONE
           d.val_esp_lorda AS val_cassa_lorda,
           d.val_esp_lorda_capitale AS val_cassa_lorda_capitale,
           val_esp_lorda_mora AS val_cassa_lorda_mora,
           d.val_esp_netta_ante_delib,
           val_esp_netta_post_delib,
           val_esp_firma,
           --RDV
           NVL (d.val_rdv_qc_progressiva, 0) + NVL (d.val_rdv_progr_fi, 0)
              AS val_rdv_progr_tot,
           d.val_rdv_qc_ante_delib,
             NVL (d.val_rdv_qc_progressiva, 0)
           - NVL (d.val_rdv_qc_ante_delib, 0)
              AS val_rdv_qc_deliberata,
           d.val_rdv_qc_progressiva,
           d.val_rdv_pregr_fi,
           NVL (d.val_rdv_pregr_fi, 0) - NVL (d.val_rdv_progr_fi, 0)
              AS val_rdv_fi_proposta,
           d.val_rdv_progr_fi,                                      --DERIVATI
           TO_NUMBER (NULL) val_rdv_der_ante_delib,
           TO_NUMBER (NULL) val_rdv_der_proposta,
           TO_NUMBER (NULL) val_rdv_der_progr,
           d.val_perc_rdv,
           d.val_rinuncia_deliberata,
           d.val_rinuncia_proposta,
           d.val_rinuncia_mora,
           d.val_rinuncia_totale,                                    --STRALCI
           d.val_stralcio_quota_cap,
           d.val_stralcio_quota_mora
      FROM t_mcrei_app_delibere_storico D
     WHERE id_dper < TO_NUMBER (TO_CHAR (TRUNC (SYSDATE, 'MM'), 'YYYYMMDD'))
    UNION ALL
    SELECT TO_NUMBER (
              TO_CHAR (TRUNC (DTA_LAST_UPD_DELIBERA, 'MM'), 'YYYYMMDD'))
              id_dper,
           f.cod_struttura_competente,
           f.cod_comparto,
           f.desc_comparto,
           d.cod_protocollo_delibera,
           d.cod_abi AS cod_abi_cartolarizzato,
           f.desc_istituto,
           f.cod_filiale,
           cod_struttura_competente_dv,
           f.desc_struttura_competente_dv,
           cod_struttura_competente_dc,
           f.desc_struttura_competente_dc,
           cod_struttura_competente_rg,
           f.desc_struttura_competente_rg,
           cod_struttura_competente_ar,
           f.desc_struttura_competente_ar,
           cod_struttura_competente_fi,
           f.desc_struttura_competente_fi,
           d.cod_ndg,
           f.desc_nome_controparte,
           f.cod_stato,
           f.cod_processo,
           d.desc_tipo_gestione,
           f.cod_gruppo_economico,
           f.desc_gruppo_economico,
           d.cod_microtipologia_delib,
           tip.desc_microtipologia,
           d.dta_delibera,
           d.dta_last_upd_delibera dta_aggiornamento,
           d.cod_organo_deliberante,
           f.cod_matricola gestore,
           f.nome || ' ' || f.cognome desc_gestore,
           p.cod_tipo_gestione,
           d.desc_note,
           d.cod_sndg,
           d.cod_fase_delibera,
           d.cod_fase_microtipologia,
           d.cod_macrotipologia_delib,
           tip.desc_macrotipologia,
           d.cod_causa_chius_delibera,
           f.dta_decorrenza_stato,
           d.dta_scadenza,
           d.dta_scadenza_transaz,
           d.dta_conferma_delibera,
           dta_last_upd_delibera,
           d.desc_denominaz_ins_delibera,
           d.cod_organo_calcolato,
           d.cod_protocollo_delibera_col,                        --ESPOSIZIONE
           d.val_esp_lorda AS val_cassa_lorda,
           d.val_esp_lorda_capitale AS val_cassa_lorda_capitale,
           val_esp_lorda_mora AS val_cassa_lorda_mora,
           d.val_esp_netta_ante_delib,
           val_esp_netta_post_delib,
           val_esp_firma,
           --RDV
           NVL (d.val_rdv_qc_progressiva, 0) + NVL (d.val_rdv_progr_fi, 0)
              AS val_rdv_progr_tot,
           d.val_rdv_qc_ante_delib,
             NVL (d.val_rdv_qc_progressiva, 0)
           - NVL (d.val_rdv_qc_ante_delib, 0)
              AS val_rdv_qc_deliberata,
           d.val_rdv_qc_progressiva,
           d.val_rdv_pregr_fi,
           NVL (d.val_rdv_pregr_fi, 0) - NVL (d.val_rdv_progr_fi, 0)
              AS val_rdv_fi_proposta,
           d.val_rdv_progr_fi,                                      --DERIVATI
           TO_NUMBER (NULL) val_rdv_der_ante_delib,
           TO_NUMBER (NULL) val_rdv_der_proposta,
           TO_NUMBER (NULL) val_rdv_der_progr,
           d.val_perc_rdv,
           d.val_rinuncia_deliberata,
           d.val_rinuncia_proposta,
           d.val_rinuncia_mora,
           d.val_rinuncia_totale,                                    --STRALCI
           d.val_stralcio_quota_cap,
           d.val_stralcio_quota_mora
      FROM t_mcrei_app_delibere d
           LEFT OUTER JOIN t_mcrei_cl_tipologie tip
              ON D.COD_MICROTIPOLOGIA_DELIB = TIP.COD_MICROTIPOLOGIA
           LEFT OUTER JOIN
           t_mcrei_app_pratiche p
              ON     D.COD_ABI = P.COD_ABI
                 AND D.COD_NDG = P.COD_NDG
                 AND D.COD_PRATICA = P.COD_PRATICA
                 AND P.VAL_ANNO_PRATICA = P.VAL_ANNO_PRATICA
           INNER JOIN
           v_mcre0_app_upd_fields f
              ON     D.COD_ABI = F.COD_ABI_CARTOLARIZZATO
                 AND D.COD_NDG = F.COD_NDG
     WHERE     d.flg_no_delibera = 0
           AND d.flg_attiva = '1'
           AND P.FLG_ATTIVA = '1'
           AND D.COD_FASE_DELIBERA != 'AN'
           AND TRUNC (DTA_LASt_UPD_DELIBERA) >= TRUNC (SYSDATE, 'MM'));


GRANT DELETE, INSERT, REFERENCES, SELECT, UPDATE, ON COMMIT REFRESH, QUERY REWRITE, DEBUG, FLASHBACK, MERGE VIEW ON MCRE_OWN.V_MCREI_APP_ELENCO_DELIB_STR TO MCRE_USR;
