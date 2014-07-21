/* Formatted on 21/07/2014 18:46:02 (QP5 v5.227.12220.39754) */
CREATE OR REPLACE FORCE VIEW MCRE_OWN.VOMCRE0_APP_ALERT_USRIP
(
   VAL_ALERT,
   VAL_ORDINE_COLORE,
   DTA_INS_ALERT,
   COD_ABI_CARTOLARIZZATO,
   COD_ABI_ISTITUTO,
   COD_SNDG,
   COD_NDG,
   DESC_ISTITUTO,
   COD_GRUPPO_ECONOMICO,
   COD_MACROSTATO,
   VAL_ANA_GRE,
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
   COD_COMPARTO_POSIZIONE,
   COD_RAMO_CALCOLATO,
   COD_COMPARTO_UTENTE,
   DESC_NOME,
   DESC_COGNOME,
   DTA_LAST_RIPORTAF,
   ID_UTENTE_PRE,
   COD_PRIV,
   FLG_GESTORE_ABILITATO,
   ID_REFERENTE,
   DESC_NOME_CONTROPARTE,
   DESC_NOME_PRE,
   DESC_COGNOME_PRE,
   FLG_ABI_LAVORATO
)
AS
   SELECT                                  -- V1 ??/??/???? VG: prima versione
          -- V2 30/03/2011 MDM: Aggiunte  colonne "ID_REFERENTE", "COD_PRIV" e "FLG_GESTORE_ABILITATO"  per gestione visibilità in base al profilo utente
          -- V3 31/03/2011 LM: Aggiunte colonne "DESC_COGNOME_PRE", "DESC_NOME_PRE" e "DESC_NOME_CONTROPARTE" per recupero generalità cliente e gestore precedente
          -- V4 31/03/2011 LM: Aggiunta colonna "COD_NDG"
          -- v5 20/04/2011 VG: FLG_ABI_LAVORATO
          -- v6 06/05/2011 VG: COD_MACROSTATO
          -- v7 27/05/2011 VG: desc istituto
          alert_10 val_alert,
          (SELECT DECODE (
                     alert_10,
                     'V', val_verde,
                     DECODE (alert_10,
                             'A', val_arancio,
                             DECODE (alert_10, 'R', val_rosso, NULL)))
             FROM t_mcre0_app_alert
            WHERE id_alert = 10)
             val_ordine_colore,
          dta_ins_10 dta_ins_alert,
          x.cod_abi_cartolarizzato,
          x.cod_abi_istituto,
          x.cod_sndg,
          x.cod_ndg,
          i.desc_istituto,
          x.cod_gruppo_economico,
          x.cod_macrostato,
          ge.val_ana_gre,
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
          x.cod_comparto cod_comparto_posizione,
          x.cod_ramo_calcolato,
          NVL (u.cod_comparto_assegn, u.cod_comparto_appart)
             cod_comparto_utente,
          u.nome desc_nome,
          u.cognome desc_cognome,
          x.dta_last_riportaf,
          a.id_utente_pre,
          u.cod_priv,
          u.flg_gestore_abilitato,
          u.id_referente,
          g.desc_nome_controparte,
          u2.nome desc_nome_pre,
          u2.cognome desc_cognome_pre,
          i.flg_abi_lavorato
     FROM v_mcre0_app_alert_pos a,
          mv_mcre0_app_istituti i,
          t_mcre0_app_anagrafica_gruppo g,
          mv_mcre0_app_upd_field x,
          t_mcre0_app_anagr_gre ge,
          mv_mcre0_denorm_str_org s,
          t_mcre0_app_utenti u,
          t_mcre0_app_utenti u2
    WHERE     alert_10 IS NOT NULL
          AND NVL (x.flg_outsourcing, 'N') = 'Y'
          AND i.flg_target = 'Y'
          AND x.cod_abi_cartolarizzato = a.cod_abi_cartolarizzato
          AND x.cod_ndg = a.cod_ndg
          AND x.cod_abi_istituto = i.cod_abi(+)
          AND x.cod_sndg = g.cod_sndg(+)
          AND x.cod_gruppo_economico = ge.cod_gre(+)
          AND x.cod_abi_istituto = s.cod_abi_istituto_fi(+)
          AND x.cod_filiale = s.cod_struttura_competente_fi(+)
          AND x.id_utente = u.id_utente(+)
          AND a.id_utente_pre = u2.id_utente(+);
