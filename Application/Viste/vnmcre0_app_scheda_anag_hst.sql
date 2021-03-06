/* Formatted on 21/07/2014 18:45:35 (QP5 v5.227.12220.39754) */
CREATE OR REPLACE FORCE VIEW MCRE_OWN.VNMCRE0_APP_SCHEDA_ANAG_HST
(
   COD_ABI_CARTOLARIZZATO,
   DESC_ISTITUTO,
   COD_NDG,
   DESC_NOME_CONTROPARTE,
   COD_SNDG,
   COD_GRUPPO_ECONOMICO,
   COD_GRUPPO_LEGAME,
   COD_SNDG_GE,
   COD_COMPARTO,
   COD_STRUTTURA_COMPETENTE,
   NOME,
   COGNOME,
   COD_STRUTTURA_COMPETENTE_DC,
   DESC_STRUTTURA_COMPETENTE_DC,
   COD_STRUTTURA_COMPETENTE_RG,
   DESC_STRUTTURA_COMPETENTE_RG,
   COD_STRUTTURA_COMPETENTE_AR,
   DESC_STRUTTURA_COMPETENTE_AR,
   COD_STRUTTURA_COMPETENTE_FI,
   DESC_STRUTTURA_COMPETENTE_FI,
   COD_STATO,
   COD_PROCESSO,
   VAL_GG_INTERCETTAMENTO,
   DTA_SCADENZA_STATO,
   DTA_LAST_DEL_FIDO,
   DTA_LAST_PEF_PROPOSTA,
   FLG_FIDI_SCADUTI,
   DTA_SCADENZA_FIDO,
   VAL_LAST_FASE_PEF,
   VAL_STRATEGIA_CREDIT,
   VAL_LAST_ORGANO_DEL_CP,
   VAL_CONTRASS_ORGANO_DEL_CP,
   FLG_CONFERMA_SAG,
   FLG_ALLINEATO_SAG,
   VAL_SCONFINO,
   DTA_LAST_UPDATE,
   COD_STATO_PRECEDENTE,
   DTA_DECORRENZA_STATO,
   COD_PERCORSO
)
AS
   SELECT /*+full(e) index(e,IB1_t_mcre0_app_storico_eventi)*/
         st.cod_abi_cartolarizzato,
          i.desc_istituto,
          st.cod_ndg,
          st.desc_nome_controparte,
          st.cod_sndg,
          st.cod_gruppo_economico,
          st.cod_gruppo_legame,
          st.cod_sndg cod_sndg_ge,
          NVL (st.cod_comparto_assegnato, st.cod_comparto_calcolato)
             cod_comparto,
          st.cod_struttura_competente,
          u.nome,
          u.cognome,
          s.cod_struttura_competente_dc,
          s.desc_struttura_competente_dc,
          s.cod_struttura_competente_rg,
          s.desc_struttura_competente_rg,
          s.cod_struttura_competente_ar,
          s.desc_struttura_competente_ar,
          s.cod_struttura_competente_fi,
          s.desc_struttura_competente_fi,
          st.cod_stato,
          st.cod_processo,
          TRUNC (SYSDATE) - st.dta_intercettamento val_gg_intercettamento,
          st.dta_scadenza_stato,
          st.dta_completamento_pef dta_last_del_fido,
          dta_ultima_revisione_pef dta_last_pef_proposta,
          st.flg_fidi_scaduti AS flg_fidi_scaduti,
          st.dat_ultimo_scaduto AS dta_scadenza_fido,
          st.cod_fase_pef val_last_fase_pef,
          st.cod_strategia_crz val_strategia_credit,
          NULL val_last_organo_del_cp,
          NULL val_contrass_organo_del_cp,
          st.flg_conferma_sag,
          st.flg_allineato_sag,
          st.val_sconfino,
          i.dta_abi_elab dta_last_update,
          st.COD_STATO_PRECEDENTE,
          st.DTA_DECORRENZA_STATO,
          st.COD_PERCORSO
     FROM t_mcre0_app_storico_eventi st,
          t_mcre0_app_utenti u,
          mv_mcre0_denorm_str_org s,
          mv_mcre0_app_istituti i
    WHERE     st.id_utente = u.id_utente                                 --(+)
          AND st.cod_abi_istituto = s.cod_abi_istituto_fi                --(+)
          AND st.cod_filiale = s.cod_struttura_competente_fi             --(+)
          AND st.cod_abi_cartolarizzato = i.cod_abi                      --(+)
          AND st.flg_cambio_stato = '1'
          AND st.flg_cambio_gestore = '0'
          AND st.flg_cambio_comparto = '0';
