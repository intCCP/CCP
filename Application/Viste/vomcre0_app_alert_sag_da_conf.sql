/* Formatted on 21/07/2014 18:45:59 (QP5 v5.227.12220.39754) */
CREATE OR REPLACE FORCE VIEW MCRE_OWN.VOMCRE0_APP_ALERT_SAG_DA_CONF
(
   VAL_ALERT,
   VAL_ORDINE_COLORE,
   DTA_INS_ALERT,
   COD_SNDG,
   COD_NDG,
   COD_ABI_CARTOLARIZZATO,
   COD_ABI_ISTITUTO,
   COD_COMPARTO_POSIZIONE,
   COD_RAMO_CALCOLATO,
   COD_MACROSTATO,
   COD_COMPARTO_UTENTE,
   DESC_ISTITUTO,
   COD_GRUPPO_ECONOMICO,
   VAL_ANA_GRE,
   DESC_NOME_CONTROPARTE,
   COD_STRUTTURA_COMPETENTE_DC,
   DESC_STRUTTURA_COMPETENTE_DC,
   COD_STRUTTURA_COMPETENTE_RG,
   DESC_STRUTTURA_COMPETENTE_RG,
   COD_STRUTTURA_COMPETENTE_AR,
   DESC_STRUTTURA_COMPETENTE_AR,
   COD_STRUTTURA_COMPETENTE_FI,
   DESC_STRUTTURA_COMPETENTE_FI,
   COD_PROCESSO,
   COD_STATO,
   DTA_DECORRENZA_STATO,
   DTA_SCADENZA_STATO,
   ID_UTENTE,
   DTA_UTENTE_ASSEGNATO,
   DESC_NOME,
   DESC_COGNOME,
   DTA_CALCOLO_SAG,
   COD_SAG,
   COD_PRIV,
   FLG_GESTORE_ABILITATO,
   ID_REFERENTE,
   FLG_ABI_LAVORATO
)
AS
   SELECT                      -- v1 06/04/2011 VG: sistemate condizioni where
          -- v2 08/04/2011 VG Modificata da DeMattia
          -- v3 20/04/2011 VG: FLG_ABI_LAVORATO
          -- v4 06/05/2011 VG: COD_MACROSTATO
          alert_1 val_alert,
          (SELECT DECODE (
                     alert_1,
                     'V', val_verde,
                     DECODE (alert_1,
                             'A', val_arancio,
                             DECODE (alert_1, 'R', val_rosso, NULL)))
             FROM t_mcre0_app_alert
            WHERE id_alert = 1)
             val_ordine_colore,
          dta_ins_1 dta_ins_alert,
          a.cod_sndg,
          a.cod_ndg,
          a.cod_abi_cartolarizzato,
          a.cod_abi_istituto,
          x.cod_comparto cod_comparto_posizione,
          x.cod_ramo_calcolato,
          x.cod_macrostato,
          NVL (u.cod_comparto_assegn, u.cod_comparto_appart)
             cod_comparto_utente,
          i.desc_istituto,
          x.cod_gruppo_economico,
          ge.val_ana_gre,
          g.desc_nome_controparte,
          s.cod_struttura_competente_dc,
          s.desc_struttura_competente_dc,
          s.cod_struttura_competente_rg,
          s.desc_struttura_competente_rg,
          s.cod_struttura_competente_ar,
          s.desc_struttura_competente_ar,
          s.cod_struttura_competente_fi,
          s.desc_struttura_competente_fi,
          x.cod_processo,
          x.cod_stato,
          x.dta_decorrenza_stato,
          x.dta_scadenza_stato,
          x.id_utente,
          x.dta_utente_assegnato,
          u.nome desc_nome,
          u.cognome desc_cognome,
          t.dta_calcolo_sag,
          t.cod_sag,
          u.cod_priv,
          u.flg_gestore_abilitato,
          u.id_referente,
          i.flg_abi_lavorato
     FROM t_mcre0_app_alert_pos a,
          mv_mcre0_app_istituti i,
          t_mcre0_app_anagrafica_gruppo g,
          mv_mcre0_app_upd_field x,
          t_mcre0_app_anagr_gre ge,
          mv_mcre0_denorm_str_org s,
          t_mcre0_app_utenti u,
          t_mcre0_app_sag t
    WHERE     alert_1 IS NOT NULL
          AND NVL (x.flg_outsourcing, 'N') = 'Y'
          AND i.flg_target = 'Y'
          AND x.cod_abi_cartolarizzato = a.cod_abi_cartolarizzato
          AND x.cod_ndg = a.cod_ndg
          AND x.cod_sndg = t.cod_sndg(+)
          AND x.cod_abi_istituto = i.cod_abi(+)
          AND x.cod_sndg = g.cod_sndg(+)
          AND x.cod_gruppo_economico = ge.cod_gre(+)
          AND x.cod_abi_istituto = s.cod_abi_istituto_fi(+)
          AND x.cod_filiale = s.cod_struttura_competente_fi(+)
          AND x.id_utente = u.id_utente(+);
