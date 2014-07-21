/* Formatted on 21/07/2014 18:45:55 (QP5 v5.227.12220.39754) */
CREATE OR REPLACE FORCE VIEW MCRE_OWN.VOMCRE0_APP_ALERT_RIO_DAPROROG
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
   COD_STATO,
   DTA_DECORRENZA_STATO,
   DTA_SCADENZA_STATO,
   ID_UTENTE,
   DTA_UTENTE_ASSEGNATO,
   DESC_NOME,
   DESC_COGNOME,
   DTA_SERVIZIO,
   DTA_ULTIMA_PROROGA,
   DTA_LIMITE_PROROGA,
   COD_OD,
   COD_PRIV,
   FLG_GESTORE_ABILITATO,
   VAL_MOTIVO_RICHIESTA,
   DESC_OD,
   FLG_ABI_LAVORATO
)
AS
   SELECT                                -- v1 20/04/2011 VG: FLG_ABI_LAVORATO
          -- v2 06/05/2011 VG: COD_MACROSTATO
          alert_18 val_alert,
          (SELECT DECODE (
                     alert_18,
                     'V', val_verde,
                     DECODE (alert_18,
                             'A', val_arancio,
                             DECODE (alert_18, 'R', val_rosso, NULL)))
             FROM t_mcre0_app_alert
            WHERE id_alert = 18)
             val_ordine_colore,
          dta_ins_18 dta_ins_alert,
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
          x.cod_stato,
          x.dta_decorrenza_stato,
          x.dta_scadenza_stato,
          x.id_utente,
          x.dta_utente_assegnato,
          u.nome desc_nome,
          u.cognome desc_cognome,
          x.dta_servizio,
          t.dta_esito dta_ultima_proroga,
          DECODE (dta_esito,
                  NULL, dta_servizio + c.val_gg_prima_proroga,
                  dta_esito + c.val_gg_seconda_proroga)
             dta_limite_proroga,
          DECODE (dta_esito,
                  NULL, c.val_od_prima_proroga,
                  c.val_od_seconda_proroga)
             cod_od,
          u.cod_priv,
          u.flg_gestore_abilitato,
          t.val_motivo_richiesta,
          (SELECT nome_gruppo
             FROM t_mcre0_app_pr_lov_gruppi
            WHERE id_gruppo =
                     DECODE (dta_esito,
                             NULL, c.val_od_prima_proroga,
                             c.val_od_seconda_proroga))
             desc_od,
          i.flg_abi_lavorato
     FROM t_mcre0_app_alert_pos a,
          mv_mcre0_app_istituti i,
          t_mcre0_app_anagrafica_gruppo g,
          mv_mcre0_app_upd_field x,
          t_mcre0_app_anagr_gre ge,
          mv_mcre0_denorm_str_org s,
          t_mcre0_app_utenti u,
          (SELECT *
             FROM t_mcre0_app_rio_proroghe p
            WHERE p.flg_storico = 0 AND p.flg_esito = 1) t,
          t_mcre0_app_comparti c
    WHERE     alert_18 IS NOT NULL
          AND NVL (x.flg_outsourcing, 'N') = 'Y'
          AND i.flg_target = 'Y'
          AND x.cod_abi_cartolarizzato = a.cod_abi_cartolarizzato
          AND x.cod_ndg = a.cod_ndg
          AND x.cod_abi_cartolarizzato = t.cod_abi_cartolarizzato(+)
          AND x.cod_ndg = t.cod_ndg(+)
          AND x.cod_abi_istituto = i.cod_abi(+)
          AND x.cod_sndg = g.cod_sndg(+)
          AND x.cod_gruppo_economico = ge.cod_gre(+)
          AND x.cod_abi_istituto = s.cod_abi_istituto_fi(+)
          AND x.cod_filiale = s.cod_struttura_competente_fi(+)
          AND x.id_utente = u.id_utente(+)
          AND x.cod_comparto = c.cod_comparto;
