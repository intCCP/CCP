/* Formatted on 21/07/2014 18:45:47 (QP5 v5.227.12220.39754) */
CREATE OR REPLACE FORCE VIEW MCRE_OWN.VOMCRE0_APP_ALERT_POS_CLDAAL
(
   VAL_ALERT,
   VAL_ORDINE_COLORE,
   DTA_INS_ALERT,
   COD_SNDG,
   COD_ABI_CARTOLARIZZATO,
   COD_ABI_ISTITUTO,
   DESC_ISTITUTO,
   COD_NDG,
   COD_COMPARTO_POSIZIONE,
   COD_MACROSTATO,
   COD_COMPARTO_UTENTE,
   COD_RAMO_CALCOLATO,
   DESC_NOME_CONTROPARTE,
   COD_GRUPPO_ECONOMICO,
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
   COD_STATO_PRECEDENTE,
   COD_STATO,
   DTA_DECORRENZA_STATO,
   DTA_SCADENZA_STATO,
   ID_UTENTE,
   DTA_UTENTE_ASSEGNATO,
   DESC_NOME,
   DESC_COGNOME,
   ID_REFERENTE,
   COD_PRIV,
   FLG_GESTORE_ABILITATO,
   FLG_ABI_LAVORATO,
   COD_MACROSTATO_PRECEDENTE,
   COD_STATO_DESTINAZIONE,
   DTA_INS_STATO_DESTINAZIONE
)
AS
   SELECT                                  -- V1 ??/??/???? VG: prima versione
          -- V2 28/03/2011 MDM: Aggiunte  colonne "COD_STATO_DESTINAZIONE" e "DTA_INS_STATO_DESTINAZIONE" per uniformità con AFU
          -- V3 28/03/2011 MDM: Aggiunte  colonne "ID_REFERENTE", "COD_PRIV" e "FLG_GESTORE_ABILITATO"  per gestione visibilità in base al profilo utente
          -- v4 20/04/2011 VG: FLG_ABI_LAVORATO
          -- V5 22/04/2011 VG: cod_stato_precedente
          -- v6 06/05/2011 VG: COD_MACROSTATO
          alert_16 val_alert,
          (SELECT DECODE (
                     alert_16,
                     'V', val_verde,
                     DECODE (alert_16,
                             'A', val_arancio,
                             DECODE (alert_16, 'R', val_rosso, NULL)))
             FROM t_mcre0_app_alert
            WHERE id_alert = 16)
             val_ordine_colore,
          dta_ins_16 dta_ins_alert,
          a.cod_sndg,
          a.cod_abi_cartolarizzato,
          a.cod_abi_istituto,
          i.desc_istituto,
          a.cod_ndg,
          x.cod_comparto cod_comparto_posizione,
          x.cod_macrostato,
          NVL (u.cod_comparto_assegn, u.cod_comparto_appart)
             cod_comparto_utente,
          x.cod_ramo_calcolato,
          g.desc_nome_controparte,
          x.cod_gruppo_economico,
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
          x.cod_stato_precedente,
          x.cod_stato,
          x.dta_decorrenza_stato,
          x.dta_scadenza_stato,
          x.id_utente,
          x.dta_utente_assegnato,
          u.nome desc_nome,
          u.cognome desc_cognome,
          u.id_referente,
          u.cod_priv,
          u.flg_gestore_abilitato,
          i.flg_abi_lavorato,
          st.cod_macrostato cod_macrostato_precedente,
          DECODE (st.cod_macrostato,
                  'RIO', r.cod_macrostato_destinazione,
                  t.cod_macrostato)
             cod_stato_destinazione,
          DECODE (st.cod_macrostato, 'RIO', r.dta_ins, t.dta_ins)
             dta_ins_stato_destinazione
     FROM t_mcre0_app_alert_pos a,
          mv_mcre0_app_istituti i,
          t_mcre0_app_anagrafica_gruppo g,
          mv_mcre0_app_upd_field x,
          t_mcre0_app_anagr_gre ge,
          mv_mcre0_denorm_str_org s,
          t_mcre0_app_utenti u,
          t_mcre0_app_pt_gestione_tavoli t,
          t_mcre0_app_rio_gestione r,
          t_mcre0_app_stati st
    WHERE     alert_16 IS NOT NULL
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
          AND x.cod_abi_cartolarizzato = t.cod_abi_cartolarizzato(+)
          AND x.cod_ndg = t.cod_ndg(+)
          AND x.cod_abi_cartolarizzato = r.cod_abi_cartolarizzato(+)
          AND x.cod_ndg = r.cod_ndg(+)
          AND st.cod_microstato = x.cod_stato_precedente(+);
