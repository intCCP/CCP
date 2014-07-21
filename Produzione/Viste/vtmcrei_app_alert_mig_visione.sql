/* Formatted on 17/06/2014 18:17:45 (QP5 v5.227.12220.39754) */
CREATE OR REPLACE FORCE VIEW MCRE_OWN.VTMCREI_APP_ALERT_MIG_VISIONE
(
   VAL_ALERT,
   ALERT,
   ID_ALERT,
   ID_ALERT_DA_ESPORRE,
   COD_NDG,
   COD_ABI,
   VAL_ORDINE_COLORE,
   DTA_INS_ALERT,
   ID_UTENTE,
   ID_REFERENTE,
   COD_COMPARTO_UTENTE,
   COD_COMPARTO_POSIZIONE,
   COD_MACROSTATO,
   COD_ABI_CARTOLARIZZATO,
   COD_STRUTTURA_COMPETENTE_DC,
   DESC_STRUTTURA_COMPETENTE_DC,
   COD_STRUTTURA_COMPETENTE_RG,
   DESC_STRUTTURA_COMPETENTE_RG,
   COD_STRUTTURA_COMPETENTE_AR,
   DESC_STRUTTURA_COMPETENTE_AR,
   COD_STRUTTURA_COMPETENTE_FI,
   DESC_STRUTTURA_COMPETENTE_FI,
   COD_ABI_CEDENTE,
   COD_NDG_CEDENTE,
   COD_ABI_RICEVENTE,
   COD_NDG_RICEVENTE,
   VAL_RDV_QC_PROGRESSIVA,
   VAL_RDV_PROGR_FI,
   VAL_RDV_MIGRATA,
   COD_SNDG,
   VAL_SOMMA_ESPOSIZIONI,
   VAL_SOMMA_DUBBI_ESITI,
   COD_STATO,
   DESC_NOME_CONTROPARTE,
   DESC_COGNOME_GEST,
   DESC_NOME_GEST,
   VAL_CNT_RAPPORTI,
   VAL_CNT_DELIBERE,
   COD_PROTOCOLLO_DELIBERA
)
AS
   SELECT DISTINCT
          'V' AS val_alert,
          'V' AS alert,
          33 AS id_alert,
          33 AS id_alert_da_esporre,
          d.cod_ndg,
          d.cod_abi,
          NULL AS val_ordine_colore,
          n.dta_upd AS dta_ins_alert,
          v.id_utente,
          v.id_referente,
          cod_comparto_utente,
          cod_comparto AS cod_comparto_posizione,
          cod_macrostato,
          cod_abi_cartolarizzato,
          cod_struttura_competente_dc,
          --direzione
          desc_struttura_competente_dc,
          cod_struttura_competente_rg,
          ---direzione regionale
          desc_struttura_competente_rg,
          cod_struttura_competente_ar,
          --area
          desc_struttura_competente_ar,
          cod_struttura_competente_fi,
          --filiale
          desc_struttura_competente_fi,
          n.cod_abi_old AS cod_abi_cedente,
          n.cod_ndg_old AS cod_ndg_cedente,
          n.cod_abi_new AS cod_abi_ricevente,
          n.cod_ndg_new AS cod_ndg_ricevente,
          NVL (d.val_rdv_qc_progressiva, 0) val_rdv_qc_progressiva,
          NVL (val_rdv_progr_fi, 0) val_rdv_progr_fi,
          SUM (val_rdv_tot) OVER (PARTITION BY n.cod_abi_old, n.cod_ndg_old)
             AS val_rdv_migrata,
          v.cod_sndg,
          NVL (d.val_uti_cassa_scsb, 0) + NVL (d.val_uti_firma_scsb, 0)
             AS val_somma_esposizioni,
          NVL (d.val_rdv_qc_progressiva, 0) + NVL (val_rdv_progr_fi, 0)
             AS val_somma_dubbi_esiti,
          cod_stato,
          desc_nome_controparte,
          cognome AS desc_cognome_gest,
          nome AS desc_nome_gest,
          1 AS val_cnt_rapporti,
          1 AS val_cnt_delibere,
          NULL cod_protocollo_delibera
     FROM t_mcre0_hst_mig_recode_ndg n,
          t_mcrei_app_delibere d,
          vtmcre0_app_upd_fields v,
          t_mcrei_app_stime s,
          t_mcre0_hst_mig_recode_rapp r
    WHERE     n.cod_abi_new = d.cod_abi(+)
          AND n.cod_ndg_new = d.cod_ndg(+)
          AND d.cod_microtipologia_delib(+) IN ('IM', 'IF')
          AND n.cod_abi_new = v.cod_abi_cartolarizzato
          AND n.cod_ndg_new = v.cod_ndg
          AND n.flg_pres_cruscotto = 1                    --solo per cruscotto
          AND n.flg_presa_visione = 1
          AND n.cod_abi_old = r.cod_abi_old
          AND n.cod_ndg_old = r.cod_ndg_old
          AND d.cod_abi = s.cod_abi
          AND d.cod_ndg = s.cod_ndg
          AND d.flg_no_delibera = 0
          AND d.flg_attiva = '1'
          AND d.cod_protocollo_delibera = s.cod_protocollo_delibera
          AND s.cod_rapporto = r.cod_rapporto_new
          AND s.cod_abi = r.cod_abi_new
          AND s.cod_ndg = r.cod_ndg_new
   UNION ALL
   SELECT DISTINCT
          'V' AS val_alert,
          'V' AS alert,
          33 AS id_alert,
          33 AS id_alert_da_esporre,
          d.cod_ndg,
          d.cod_abi,
          NULL AS val_ordine_colore,
          n.dta_upd AS dta_ins_alert,
          v.id_utente,
          v.id_referente,
          cod_comparto_utente,
          cod_comparto AS cod_comparto_posizione,
          cod_macrostato,
          cod_abi_cartolarizzato,
          cod_struttura_competente_dc,
          --direzione
          desc_struttura_competente_dc,
          cod_struttura_competente_rg,
          ---direzione regionale
          desc_struttura_competente_rg,
          cod_struttura_competente_ar,
          --area
          desc_struttura_competente_ar,
          cod_struttura_competente_fi,
          --filiale
          desc_struttura_competente_fi,
          n.cod_abi_old AS cod_abi_cedente,
          n.cod_ndg_old AS cod_ndg_cedente,
          n.cod_abi_new AS cod_abi_ricevente,
          n.cod_ndg_new AS cod_ndg_ricevente,
          NVL (d.val_rdv_qc_progressiva, 0) val_rdv_qc_progressiva,
          NVL (val_rdv_progr_fi, 0) val_rdv_progr_fi,
          0 AS val_rdv_migrata,
          v.cod_sndg,
          NVL (d.val_uti_cassa_scsb, 0) + NVL (d.val_uti_firma_scsb, 0)
             val_somma_esposizioni,
          NVL (d.val_rdv_qc_progressiva, 0) + NVL (val_rdv_progr_fi, 0)
             val_somma_dubbi_esiti,
          cod_stato,
          desc_nome_controparte,
          cognome AS desc_cognome_gest,
          nome AS desc_nome_gest,
          1 AS val_cnt_rapporti,
          1 AS val_cnt_delibere,
          NULL cod_protocollo_delibera
     FROM t_mcre0_hst_mig_recode_ndg n,
          t_mcrei_app_delibere d,
          vtmcre0_app_upd_fields v,
          t_mcrei_app_stime s
    WHERE     n.cod_abi_new = d.cod_abi(+)
          AND n.cod_ndg_new = d.cod_ndg(+)
          AND d.cod_microtipologia_delib(+) IN ('IM', 'IF')
          AND d.flg_no_delibera = 0
          AND d.flg_attiva = '1'
          AND n.cod_abi_new = v.cod_abi_cartolarizzato
          AND n.cod_ndg_new = v.cod_ndg
          AND n.flg_pres_cruscotto = 1                    --solo per cruscotto
          AND n.flg_presa_visione = 1
          AND d.cod_abi = s.cod_abi(+)
          AND d.cod_ndg = s.cod_ndg(+)
          AND d.cod_protocollo_delibera = s.cod_protocollo_delibera(+)
          AND s.cod_protocollo_delibera IS NULL;


GRANT DELETE, INSERT, REFERENCES, SELECT, UPDATE, ON COMMIT REFRESH, QUERY REWRITE, DEBUG, FLASHBACK ON MCRE_OWN.VTMCREI_APP_ALERT_MIG_VISIONE TO MCRE_USR;
