/* Formatted on 21/07/2014 18:40:20 (QP5 v5.227.12220.39754) */
CREATE OR REPLACE FORCE VIEW MCRE_OWN.V_MCREI_APP_HP_RISANAMENTO
(
   COD_ABI_CARTOLARIZZATO,
   DESC_ISTITUTO,
   COD_NDG,
   DESC_NOME_CONTROPARTE,
   COD_SNDG,
   COD_GRUPPO_ECONOMICO,
   DESC_GRUPPO_ECONOMICO,
   COD_STRUTTURA_COMPETENTE_DC,
   DESC_STRUTTURA_COMPETENTE_DC,
   COD_STRUTTURA_COMPETENTE_RG,
   DESC_STRUTTURA_COMPETENTE_RG,
   COD_STRUTTURA_COMPETENTE_AR,
   DESC_STRUTTURA_COMPETENTE_AR,
   COD_STRUTTURA_COMPETENTE_FI,
   DESC_STRUTTURA_COMPETENTE_FI,
   COD_STATO_PRECEDENTE,
   DTA_DECORRENZA_STATO,
   DTA_SCADENZA_STATO,
   DTA_UTENTE_ASSEGNATO,
   SCSB_ACC_TOT_CF,
   SCSB_UTI_TOT_CF,
   ID_UTENTE,
   ID_REFERENTE,
   COD_COMPARTO,
   COD_GRUPPO_SUPER
)
AS
   SELECT f.cod_abi_cartolarizzato,
          f.desc_istituto,
          f.cod_ndg,
          f.desc_nome_controparte,
          f.cod_sndg,
          NULLIF (f.cod_gruppo_economico, '-1') cod_gruppo_economico,
          f.desc_gruppo_economico AS desc_gruppo_economico,
          nor.cod_struttura_competente_dc,
          nor.desc_struttura_competente_dc,
          nor.cod_struttura_competente_rg,
          nor.desc_struttura_competente_rg,
          nor.cod_struttura_competente_ar,
          nor.desc_struttura_competente_ar,
          nor.cod_struttura_competente_fi,
          nor.desc_struttura_competente_fi,
          NULLIF (f.cod_stato_precedente, '-1') cod_stato_precedente,
          f.dta_decorrenza_stato,
          f.dta_scadenza_stato AS dta_scadenza_stato,
          f.dta_utente_assegnato,
          r.scsb_acc_tot AS scsb_acc_tot_cf,                    --cassa +firma
          r.scsb_uti_tot AS scsb_uti_tot_cf,                    --cassa +firma
          NULLIF (f.id_utente, -1) id_utente,
          u.id_referente,
          NVL (f.cod_comparto_assegnato,
               NULLIF (f.cod_comparto_calcolato, '#'))
             cod_comparto,
          f.cod_gruppo_super
     FROM t_mcre0_app_all_data f,
          mv_mcre0_denorm_str_org nor,
          t_mcre0_app_utenti u,
          t_mcrei_app_pcr_rapp_aggr r
    WHERE     f.cod_abi_cartolarizzato = nor.cod_abi_istituto_fi
          AND f.cod_filiale = nor.cod_struttura_competente_fi
          AND f.cod_abi_cartolarizzato = r.cod_abi_cartolarizzato(+)
          AND f.cod_ndg = r.cod_ndg(+)
          AND f.cod_stato = 'RM'
          AND f.flg_target = 'Y'                                      --13 GIU
          AND f.flg_outsourcing = 'Y'                                 --13 GIU
          AND f.today_flg = '1'
          AND f.id_utente = u.id_utente;
