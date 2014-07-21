/* Formatted on 21/07/2014 18:31:35 (QP5 v5.227.12220.39754) */
CREATE OR REPLACE FORCE VIEW MCRE_OWN.V_MCRE0_APP_AL_DEL_NON_CONFORM
(
   VAL_ALERT,
   DTA_INS_ALERT,
   VAL_ORDINE_COLORE,
   COD_ABI_CARTOLARIZZATO,
   COD_ABI_ISTITUTO,
   COD_COMPARTO_POSIZIONE,
   COD_COMPARTO_UTENTE,
   COD_GRUPPO_ECONOMICO,
   COD_MACROSTATO,
   COD_NDG,
   COD_SNDG,
   COD_PROCESSO,
   VAL_ANA_GRE,
   COD_PRIV,
   COD_RAMO_CALCOLATO,
   COD_STATO,
   ID_REFERENTE,
   ID_UTENTE,
   COD_STRUTTURA_COMPETENTE_AR,
   COD_STRUTTURA_COMPETENTE_DC,
   COD_STRUTTURA_COMPETENTE_FI,
   COD_STRUTTURA_COMPETENTE_RG,
   DESC_STRUTTURA_COMPETENTE_AR,
   DESC_STRUTTURA_COMPETENTE_DC,
   DESC_STRUTTURA_COMPETENTE_FI,
   DESC_STRUTTURA_COMPETENTE_RG,
   DESC_NOME_CONTROPARTE,
   DESC_COGNOME,
   DESC_NOME,
   DESC_ISTITUTO,
   FLG_GESTORE_ABILITATO,
   DTA_DECORRENZA_STATO,
   DTA_CONFERMA_NDG,
   DTA_DELIBERA,
   COD_MICROTIPOLOGIA,
   VAL_RDV_PROPOSTA,
   VAL_RDV_DELIBERATA,
   COD_PROTOCOLLO_PACCHETTO,
   COD_PROTOCOLLO_DELIBERA,
   COD_FASE_DELIBERA,
   VAL_UTI_TOT,
   COD_GRUPPO_SUPER
)
AS
   SELECT al.alert AS val_alert,
          al.dta_ins AS dta_ins_alert,
          val_ordine_colore,
          ad.cod_abi_cartolarizzato,
          ad.cod_abi_istituto,
          NVL (ad.cod_comparto_assegnato, cod_comparto_calcolato)
             AS cod_comparto_posizione,
          ad.cod_comparto_utente,
          NULLIF (ad.cod_gruppo_economico, '-1') cod_gruppo_economico,
          ad.cod_macrostato,
          ad.cod_ndg,
          ad.cod_sndg,
          ad.cod_processo,
          ad.desc_gruppo_economico val_ana_gre,
          ad.cod_priv,
          ad.cod_ramo_calcolato,
          ad.cod_stato,
          ad.id_referente,
          ad.id_utente,
          ad.cod_struttura_competente_ar,
          ad.cod_struttura_competente_dc,
          ad.cod_struttura_competente_fi,
          ad.cod_struttura_competente_rg,
          ad.desc_struttura_competente_ar,
          ad.desc_struttura_competente_dc,
          ad.desc_struttura_competente_fi,
          ad.desc_struttura_competente_rg,
          ad.desc_nome_controparte,
          ad.cognome desc_cognome,
          ad.nome desc_nome,
          ad.desc_istituto,
          ad.flg_gestore_abilitato,
          ad.dta_decorrenza_stato,
          d.dta_conferma_delibera dta_conferma_ndg,
          d.dta_delibera,
          d.cod_microtipologia_delib cod_microtipologia,
          d.val_rdv_delib_banca_rete val_rdv_proposta,
          d.val_rdv_qc_deliberata val_rdv_deliberata,
          d.cod_protocollo_pacchetto,
          d.cod_protocollo_delibera,
          D.COD_FASE_DELIBERA,
          AD.SCSB_UTI_TOT VAL_UTI_TOT,
          AD.COD_GRUPPO_SUPER
     FROM t_mcrei_app_alert_pos_wrk PARTITION (inc_p36) al,
          v_mcre0_app_upd_fields_all ad,
          t_mcrei_app_delibere d
    WHERE     al.cod_abi = ad.cod_abi_cartolarizzato
          AND al.cod_ndg = ad.cod_ndg
          AND al.cod_abi = d.cod_abi
          AND al.cod_ndg = d.cod_ndg
          AND al.cod_protocollo_delibera = d.cod_protocollo_delibera
          AND ad.today_flg = '1'
          AND ad.cod_macrostato = 'IN'
          AND ad.flg_outsourcing = 'Y'
          AND ad.flg_target = 'Y'
          AND d.flg_no_delibera = 0
          AND d.flg_attiva = '1';
