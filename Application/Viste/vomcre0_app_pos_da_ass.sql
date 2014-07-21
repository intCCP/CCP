/* Formatted on 21/07/2014 18:46:13 (QP5 v5.227.12220.39754) */
CREATE OR REPLACE FORCE VIEW MCRE_OWN.VOMCRE0_APP_POS_DA_ASS
(
   ID_ALERT,
   VAL_ORDINE_COLORE,
   DESC_ALERT,
   VAL_ALERT,
   DTA_INS_ALERT,
   COD_COMPARTO,
   DESC_COMPARTO,
   COD_RAMO_CALCOLATO,
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
   COD_PROCESSO,
   COD_STATO,
   COD_MACROSTATO,
   DTA_DECORRENZA_STATO,
   COD_STATO_DESTINAZIONE,
   ID_UTENTE_GIRATO_DA,
   DESC_UTENTE_GIRATO_DA,
   DESC_ISTITUTO,
   FLG_OUTSOURCING,
   ID_UTENTE_PRE,
   ID_UTENTE_PREASSEGNATO,
   DESC_COGNOME_PREASS,
   DESC_NOME_PREASS,
   COD_COMPARTO_PREASSEGNATO,
   DESC_COMPARTO_PREASS,
   COD_MATR_ASSEGNATORE,
   FLG_ABI_LAVORATO
)
AS
   SELECT                                       -- V1 02/12/2010 VG: Congelata
          --  17/12/2010 MM aggiunto grupppo Super
          -- V2 22/12/2010 VG: COD_RAMO_CALCOLATO
          -- V3 30/12/2010 ML: modifica clausola AND co2.cod_comparto=f.cod_comparto_preassegnato con OUTER JOIN e aggiunta flag gruppo / Legame
          -- VG 26/01/2011 Outsourcing e target
          -- VG 02/01/2011 vista alert sostituita con tabella
          -- VG 08/06/2011 TOLTA FILE_GUIDA
          DISTINCT
          DECODE (p.alert_5, NULL, 9, 5) id_alert,
          (SELECT DECODE (
                     alert_5,
                     'V', val_verde,
                     DECODE (alert_5,
                             'A', val_arancio,
                             DECODE (alert_5, 'R', val_rosso, NULL)))
             FROM t_mcre0_app_alert
            WHERE id_alert = 5)
             val_ordine_colore,
          (SELECT r.desc_alert
             FROM t_mcre0_app_alert r
            WHERE r.id_alert = DECODE (p.alert_5, NULL, 9, 5))
             desc_alert,
          NVL (p.alert_5, p.alert_9) val_alert,
          NVL (p.dta_ins_5, p.dta_ins_9) dta_ins_alert,
          x.cod_comparto,
          co.desc_comparto,
          x.cod_ramo_calcolato,
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
          x.cod_processo,
          x.cod_stato,
          x.cod_macrostato,
          x.dta_decorrenza_stato,
          ' ' cod_stato_destinazione,
          x.cod_operatore_ins_upd id_utente_girato_da,
          u.cognome || ' ' || u.nome desc_utente_girato_da,
          i.desc_istituto,
          i.flg_outsourcing,
          x.id_utente_pre,
          x.id_utente_preassegnato,
          u2.cognome desc_cognome_preass,
          u2.nome desc_nome_preass,
          x.cod_comparto_preassegnato,
          co2.desc_comparto desc_comparto_preass,
          x.cod_matr_assegnatore,
          i.flg_abi_lavorato
     FROM mcre_own.mv_mcre0_app_upd_field x,
          t_mcre0_app_anagrafica_gruppo a,
          mv_mcre0_denorm_str_org s,
          mcre_own.mv_mcre0_app_istituti i,
          t_mcre0_app_comparti co,
          t_mcre0_app_comparti co2,
          t_mcre0_app_alert_pos p,
          t_mcre0_app_anagr_gre ge,
          t_mcre0_app_gruppo_legame le,
          t_mcre0_app_utenti u,
          t_mcre0_app_utenti u2
    WHERE     co.cod_comparto = x.cod_comparto
          --nvl(f.cod_comparto_calcolato,f.cod_comparto_assegnato) --
          AND co.flg_chk = 1
          AND x.cod_comparto_preassegnato = co2.cod_comparto(+)
          AND (p.alert_5 IS NOT NULL OR p.alert_9 IS NOT NULL)
          AND x.id_utente IS NULL
          AND x.cod_abi_cartolarizzato = p.cod_abi_cartolarizzato
          AND x.cod_ndg = p.cod_ndg
          AND x.cod_sndg = a.cod_sndg(+)
          AND x.cod_gruppo_economico = ge.cod_gre(+)
          AND x.cod_sndg = le.cod_sndg(+)
          AND x.cod_abi_istituto = s.cod_abi_istituto_fi(+)
          AND x.cod_filiale = s.cod_struttura_competente_fi(+)
          AND x.cod_abi_cartolarizzato = i.cod_abi(+)
          AND x.cod_operatore_ins_upd = u.cod_matricola(+)
          AND x.id_utente_preassegnato = u2.id_utente(+)
          AND x.cod_stato IN (SELECT cod_microstato
                                FROM t_mcre0_app_stati s
                               WHERE s.flg_stato_chk = 1)
          AND NVL (x.flg_outsourcing, 'N') = 'Y'
          AND i.flg_target = 'Y'
          AND DECODE (p.alert_5, NULL, 9, 5) = 5;
