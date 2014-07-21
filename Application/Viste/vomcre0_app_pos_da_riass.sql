/* Formatted on 21/07/2014 18:46:14 (QP5 v5.227.12220.39754) */
CREATE OR REPLACE FORCE VIEW MCRE_OWN.VOMCRE0_APP_POS_DA_RIASS
(
   ID_ALERT,
   VAL_ORDINE_COLORE,
   DESC_ALERT,
   VAL_ALERT,
   DTA_INS_ALERT,
   COD_COMPARTO,
   COD_RAMO_CALCOLATO,
   DESC_COMPARTO,
   COD_ABI_ISTITUTO,
   COD_ABI_CARTOLARIZZATO,
   COD_NDG,
   COD_SNDG,
   DESC_NOME_CONTROPARTE,
   COD_GRUPPO_ECONOMICO,
   COD_GRUPPO_SUPER,
   VAL_ANA_GRE,
   COD_LEGAME,
   FLG_GRUPPO_ECONOMICO,
   FLG_GRUPPO_LEGAME,
   FLG_SINGOLO,
   FLG_CONDIVISO,
   COD_STRUTTURA_COMPETENTE_DC,
   DESC_STRUTTURA_COMPETENTE_DC,
   COD_STRUTTURA_COMPETENTE_RG,
   DESC_STRUTTURA_COMPETENTE_RG,
   COD_STRUTTURA_COMPETENTE_AR,
   DESC_STRUTTURA_COMPETENTE_AR,
   COD_STRUTTURA_COMPETENTE_FI,
   DESC_STRUTTURA_COMPETENTE_FI,
   COD_PROCESSO_PRE,
   COD_PROCESSO,
   COD_STATO_PRECEDENTE,
   COD_STATO,
   COD_MACROSTATO,
   DTA_DECORRENZA_STATO,
   DESC_ISTITUTO,
   FLG_OUTSOURCING,
   ID_UTENTE,
   ID_REFERENTE,
   DESC_COGNOME,
   COD_MATR_ASSEGNATORE,
   ID_UTENTE_PREASSEGNATO,
   DESC_COGNOME_PREASS,
   DESC_NOME_PREASS,
   COD_COMPARTO_PREASSEGNATO,
   DESC_COMPARTO_PREASS,
   COD_SEZIONE_PREASSEGNATA,
   FLG_ABI_LAVORATO
)
AS
   SELECT                                -- v1 08/06/2011 VG: Tolta file_guida
         DISTINCT
          4 id_alert,
          (SELECT DECODE (
                     alert_4,
                     'V', val_verde,
                     DECODE (alert_4,
                             'A', val_arancio,
                             DECODE (alert_4, 'R', val_rosso, NULL)))
             FROM t_mcre0_app_alert
            WHERE id_alert = 4)
             val_ordine_colore,
          (SELECT r.desc_alert
             FROM t_mcre0_app_alert r
            WHERE r.id_alert = 4)
             desc_alert,
          p.alert_4 val_alert,
          p.dta_ins_4 dta_ins_alert,
          x.cod_comparto,
          x.cod_ramo_calcolato,
          co.desc_comparto,
          x.cod_abi_istituto,
          x.cod_abi_cartolarizzato,
          x.cod_ndg,
          x.cod_sndg,
          a.desc_nome_controparte,
          x.cod_gruppo_economico,
          x.cod_gruppo_super,
          ge.val_ana_gre,
          le.cod_legame,
          x.flg_gruppo_economico,
          x.flg_gruppo_legame,
          x.flg_singolo,
          x.flg_condiviso,
          s.cod_struttura_competente_dc,
          s.desc_struttura_competente_dc,
          s.cod_struttura_competente_rg,
          s.desc_struttura_competente_rg,
          s.cod_struttura_competente_ar,
          s.desc_struttura_competente_ar,
          s.cod_struttura_competente_fi,
          s.desc_struttura_competente_fi,
          x.cod_processo_pre,
          x.cod_processo,
          x.cod_stato_precedente,
          x.cod_stato,
          x.cod_macrostato,
          x.dta_decorrenza_stato,
          i.desc_istituto,
          i.flg_outsourcing,
          x.id_utente,
          p.id_referente,
          u.cognome desc_cognome,
          x.cod_matr_assegnatore,
          x.id_utente_preassegnato,
          u2.cognome desc_cognome_preass,
          u2.nome desc_nome_preass,
          x.cod_comparto_preassegnato,
          co2.desc_comparto desc_comparto_preass,
          x.cod_sezione_preassegnata,
          i.flg_abi_lavorato
     FROM mcre_own.mv_mcre0_app_upd_field x,
          mcre_own.t_mcre0_app_anagrafica_gruppo a,
          mcre_own.mv_mcre0_denorm_str_org s,
          mcre_own.mv_mcre0_app_istituti i,
          mcre_own.t_mcre0_app_comparti co,
          mcre_own.t_mcre0_app_comparti co2,
          mcre_own.v_mcre0_app_alert_pos p,
          mcre_own.t_mcre0_app_anagr_gre ge,
          mcre_own.t_mcre0_app_gruppo_legame le,
          mcre_own.t_mcre0_app_utenti u,
          mcre_own.t_mcre0_app_utenti u2
    WHERE     co.cod_comparto = x.cod_comparto
          AND co.flg_chk = 1
          AND x.cod_comparto_preassegnato = co2.cod_comparto(+)
          AND p.alert_4 IS NOT NULL
          AND x.cod_abi_cartolarizzato = x.cod_abi_cartolarizzato
          AND x.cod_ndg = x.cod_ndg
          AND x.cod_abi_cartolarizzato = p.cod_abi_cartolarizzato
          AND x.cod_ndg = p.cod_ndg
          AND x.id_utente = u.id_utente(+)
          AND x.id_utente_preassegnato = u2.id_utente(+)
          AND x.cod_sndg = a.cod_sndg(+)
          AND x.cod_gruppo_economico = ge.cod_gre(+)
          AND x.cod_sndg = le.cod_sndg(+)
          AND x.cod_abi_istituto = s.cod_abi_istituto_fi(+)
          AND x.cod_filiale = s.cod_struttura_competente_fi(+)
          AND x.cod_abi_cartolarizzato = i.cod_abi(+)
          AND x.cod_stato IN (SELECT cod_microstato
                                FROM t_mcre0_app_stati s
                               WHERE s.flg_stato_chk = 1);
