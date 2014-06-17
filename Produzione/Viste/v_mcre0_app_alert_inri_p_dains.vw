/* Formatted on 17/06/2014 18:00:12 (QP5 v5.227.12220.39754) */
CREATE OR REPLACE FORCE VIEW MCRE_OWN.V_MCRE0_APP_ALERT_INRI_P_DAINS
(
   VAL_ALERT,
   COD_ABI_CARTOLARIZZATO,
   COD_ABI_ISTITUTO,
   COD_COMPARTO_POSIZIONE,
   COD_COMPARTO_UTENTE,
   COD_GRUPPO_ECONOMICO,
   COD_MACROSTATO,
   COD_NDG,
   COD_PRIV,
   COD_PROCESSO,
   COD_RAMO_CALCOLATO,
   COD_SNDG,
   COD_STATO,
   COD_STRUTTURA_COMPETENTE_AR,
   COD_STRUTTURA_COMPETENTE_DC,
   COD_STRUTTURA_COMPETENTE_FI,
   COD_STRUTTURA_COMPETENTE_RG,
   DESC_COGNOME,
   DESC_ISTITUTO,
   DESC_NOME,
   DESC_NOME_CONTROPARTE,
   DESC_STRUTTURA_COMPETENTE_AR,
   DESC_STRUTTURA_COMPETENTE_DC,
   DESC_STRUTTURA_COMPETENTE_FI,
   DESC_STRUTTURA_COMPETENTE_RG,
   DTA_DECORRENZA_STATO,
   DTA_INS_ALERT,
   FLG_ABI_LAVORATO,
   FLG_GESTORE_ABILITATO,
   ID_REFERENTE,
   ID_UTENTE,
   VAL_ANA_GRE,
   VAL_ORDINE_COLORE,
   COD_MICRO_TIPOL,
   VAL_AMM_RINUNCIA,
   DTA_SCADENZA,
   COD_PROTOCOLLO_PACCHETTO,
   VAL_UTI_TOT,
   COD_GRUPPO_SUPER
)
AS
   SELECT DISTINCT
          pw.alert AS val_alert,
          d.cod_abi_cartolarizzato AS cod_abi_cartolarizzato,
          d.cod_abi_istituto AS cod_abi_istituto,
          d.cod_comparto_assegnato AS cod_comparto_posizione,
          u.cod_comparto_utente AS cod_comparto_utente,
          d.cod_gruppo_economico AS cod_gruppo_economico,
          d.cod_macrostato AS cod_macrostato,
          d.cod_ndg AS cod_ndg,
          u.cod_priv AS cod_priv,
          d.cod_processo AS cod_processo,
          d.cod_ramo_calcolato AS cod_ramo_calcolato,
          d.cod_sndg AS cod_sndg,
          d.cod_stato AS cod_stato,
          d.cod_struttura_competente_ar AS cod_struttura_competente_ar,
          d.cod_struttura_competente_dc AS cod_struttura_competente_dc,
          d.cod_struttura_competente_fi AS cod_struttura_competente_fi,
          d.cod_struttura_competente_rg AS cod_struttura_competente_rg,
          u.cognome AS desc_cognome,
          d.desc_istituto AS desc_istituto,
          u.nome AS desc_nome,
          d.desc_nome_controparte AS desc_nome_controparte,
          d.desc_struttura_competente_ar AS desc_struttura_competente_ar,
          d.desc_struttura_competente_dc AS desc_struttura_competente_dc,
          d.desc_struttura_competente_fi AS desc_struttura_competente_fi,
          d.desc_struttura_competente_rg AS desc_struttura_competente_rg,
          d.dta_decorrenza_stato AS dta_decorrenza_stato,
          SYSDATE AS dta_ins_alert,
          '1' AS flg_abi_lavorato,
          u.flg_gestore_abilitato AS flg_gestore_abilitato,
          u.id_referente AS id_referente,
          u.id_utente AS id_utente,
          d.desc_gruppo_economico AS val_ana_gre,
          DECODE (pw.alert,  'V', 3,  'R', 9,  6) AS val_ordine_colore,
          de.cod_microtipologia_delib AS cod_micro_tipol,
          de.val_rinuncia_totale AS val_amm_rinuncia,
          de.dta_scadenza_transaz AS dta_scadenza,
          -- OPPURE DTA_SCADENZA DELLE DELIBERE
          DE.COD_PROTOCOLLO_PACCHETTO AS COD_PROTOCOLLO_PACCHETTO,
          D.SCSB_UTI_TOT VAL_UTI_TOT,
          D.COD_GRUPPO_SUPER
     FROM t_mcrei_app_alert_pos_wrk PARTITION (inc_p32) pw,
          v_mcre0_app_upd_fields d,
          t_mcrei_app_delibere PARTITION (inc_pattive) de,
          t_mcre0_app_utenti u
    WHERE     pw.cod_abi = de.cod_abi
          AND pw.cod_ndg = de.cod_ndg
          AND pw.cod_protocollo_delibera = de.cod_protocollo_delibera
          AND de.cod_abi = d.cod_abi_cartolarizzato
          AND de.cod_ndg = d.cod_ndg
          AND de.flg_no_delibera = 0
          AND d.id_utente = u.id_utente(+)
          AND d.cod_stato IN ('IN', 'RS')
          AND d.flg_outsourcing = 'Y'
          AND d.flg_target = 'Y'
          AND de.flg_no_delibera = 0
          AND de.flg_attiva = '1';


GRANT DELETE, INSERT, REFERENCES, SELECT, UPDATE, ON COMMIT REFRESH, QUERY REWRITE, DEBUG, FLASHBACK, MERGE VIEW ON MCRE_OWN.V_MCRE0_APP_ALERT_INRI_P_DAINS TO MCRE_USR;
