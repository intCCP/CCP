/* Formatted on 21/07/2014 18:45:01 (QP5 v5.227.12220.39754) */
CREATE OR REPLACE FORCE VIEW MCRE_OWN.VNMCRE0_APP_ALERT_OD_INF
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
   ID_REFERENTE,
   COD_PRIV,
   FLG_GESTORE_ABILITATO,
   TIP_DELIBERA_AZIONE,
   DTA_ESITO,
   ID_RUOLO_RESP,
   VAL_OD_SECONDA_PROROGA,
   DESC_OD,
   DESC_OD_SECONDA_PROROGA,
   FLG_ABI_LAVORATO
)
AS
   SELECT                                -- v4 20/04/2011 VG: FLG_ABI_LAVORATO
          -- v2 06/05/2011 VG: COD_MACROSTATO
          alert_11 val_alert,
          (SELECT DECODE (
                     alert_11,
                     'V', val_verde,
                     DECODE (alert_11,
                             'A', val_arancio,
                             DECODE (alert_11, 'R', val_rosso, NULL)))
             FROM t_mcre0_app_alert
            WHERE id_alert = 11)
             val_ordine_colore,
          dta_ins_11 dta_ins_alert,
          a.cod_sndg,
          a.cod_abi_cartolarizzato,
          a.cod_abi_istituto,
          x.desc_istituto,
          a.cod_ndg,
          x.cod_comparto cod_comparto_posizione,
          x.cod_macrostato,
          --  NVL (x.cod_comparto_assegn, x.cod_comparto_appart) cod_comparto_utente
          x.cod_comparto_utente,
          x.desc_istituto,
          x.cod_gruppo_economico,
          x.desc_gruppo_economico val_ana_gre,
          x.desc_nome_controparte,
          x.cod_struttura_competente_dc,
          x.desc_struttura_competente_dc,
          x.cod_struttura_competente_rg,
          x.desc_struttura_competente_rg,
          x.cod_struttura_competente_ar,
          x.desc_struttura_competente_ar,
          x.cod_struttura_competente_fi,
          x.desc_struttura_competente_fi,
          x.cod_processo,
          x.cod_stato,
          x.dta_decorrenza_stato,
          x.dta_scadenza_stato,
          x.id_utente,
          x.dta_utente_assegnato,
          x.nome desc_nome,
          x.cognome desc_cognome,
          x.id_referente,
          x.cod_priv,
          x.flg_gestore_abilitato,
          'Proroga' tip_delibera_azione,
          dta_esito,
          t.id_ruolo_resp,
          x.val_od_seconda_proroga,
          (SELECT nome_gruppo
             FROM t_mcre0_app_pr_lov_gruppi
            WHERE id_gruppo = t.id_ruolo_resp)
             desc_od,
          (SELECT nome_gruppo
             FROM t_mcre0_app_pr_lov_gruppi
            WHERE id_gruppo = x.val_od_seconda_proroga)
             desc_od_seconda_proroga,
          --i.FLG_ABI_LAVORATO,
          DECODE (
             DTA_ABI_ELAB,
             (SELECT MAX (DTA_ABI_ELAB) DTA_ABI_ELAB_MAX
                FROM T_MCRE0_APP_ABI_ELABORATI), '1',
             '0')
             FLG_ABI_LAVORATO
     FROM t_mcre0_app_alert_pos a,
          -- todo_verificare che sia sufficiente lavorare sulla partizione attiva
          V_MCRE0_APP_UPD_FIELDS x,
          --  mv_mcre0_app_istituti i,
          -- t_mcre0_app_anagrafica_gruppo g,
          --  mv_mcre0_app_upd_field x,
          --   t_mcre0_app_anagr_gre ge,
          --   mv_mcre0_denorm_str_org s,
          --   t_mcre0_app_utenti u,
          t_mcre0_app_rio_proroghe t                                       --,
    --    t_mcre0_app_comparti c
    WHERE     alert_11 IS NOT NULL
          --   AND NVL (X.FLG_OUTSOURCING, 'N') = 'Y'
          AND X.FLG_OUTSOURCING = 'Y'
          --     AND I.FLG_TARGET = 'Y'
          AND x.FLG_TARGET = 'Y'
          AND x.cod_abi_cartolarizzato = a.cod_abi_cartolarizzato
          AND x.cod_ndg = a.cod_ndg
          --     AND x.cod_abi_istituto = i.cod_abi(+)
          --    AND x.cod_sndg = g.cod_sndg(+)
          --    AND x.cod_gruppo_economico = ge.cod_gre(+)
          --    AND x.cod_abi_istituto = s.cod_abi_istituto_fi(+)
          --    AND x.cod_filiale = s.cod_struttura_competente_fi(+)
          --    AND x.id_utente = u.id_utente(+)
          AND x.cod_abi_cartolarizzato = t.cod_abi_cartolarizzato
          AND x.cod_ndg = t.cod_ndg
          AND t.flg_storico = 0
          AND t.flg_esito = 1
-- AND x.cod_comparto = c.cod_comparto
;
