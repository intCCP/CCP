/* Formatted on 21/07/2014 18:32:29 (QP5 v5.227.12220.39754) */
CREATE OR REPLACE FORCE VIEW MCRE_OWN.V_MCRE0_APP_ALERT_OD_INF
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
   FLG_ABI_LAVORATO,
   COD_ORG_DELIB_IND,
   DESC_ORG_DELIB_IND,
   COD_ORG_DELIB_CALC,
   DESC_ORG_DELIB_CALC,
   VAL_UTI_TOT
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
          t.id_ruolo_resp,                              --cod od che autorizza
          x.val_od_seconda_proroga,                         --cod_od calcolato
          (SELECT nome_gruppo
             FROM t_mcre0_app_pr_lov_gruppi
            WHERE id_gruppo = t.id_ruolo_resp)
             desc_od,
          (SELECT nome_gruppo
             FROM t_mcre0_app_pr_lov_gruppi
            WHERE id_gruppo = x.val_od_seconda_proroga)
             desc_od_seconda_proroga,
          DECODE (
             dta_abi_elab,
             (SELECT MAX (dta_abi_elab) dta_abi_elab_max
                FROM t_mcre0_app_abi_elaborati), '1',
             '0')
             flg_abi_lavorato,
          (SELECT cod_organo_deliberante
             FROM t_mcre0_cl_org_delib
            WHERE     id_servizio = t.id_ruolo_resp                     --1giu
                  AND cod_abi = '01025'
                  AND '0' || cod_uo = x.cod_comparto)
             AS cod_org_delib_ind,
          (SELECT desc_organo_deliberante
             FROM t_mcre0_cl_organi_deliberanti
            WHERE     cod_organo_deliberante =
                         (SELECT cod_organo_deliberante
                            FROM t_mcre0_cl_org_delib
                           WHERE     id_servizio = t.id_ruolo_resp      --1giu
                                 AND cod_abi = '01025'
                                 AND '0' || cod_uo = x.cod_comparto)
                  AND cod_abi_istituto = '01025')
             desc_org_delib_ind,
          (SELECT cod_organo_deliberante
             FROM t_mcre0_cl_org_delib
            WHERE     id_servizio = x.val_od_seconda_proroga            --1giu
                  AND cod_abi = '01025'
                  AND '0' || cod_uo = x.cod_comparto)
             AS cod_org_delib_calc,
          (SELECT desc_organo_deliberante
             FROM t_mcre0_cl_organi_deliberanti
            WHERE     cod_organo_deliberante =
                         (SELECT cod_organo_deliberante
                            FROM t_mcre0_cl_org_delib
                           WHERE     id_servizio = x.val_od_seconda_proroga --1giu
                                 AND cod_abi = '01025'
                                 AND '0' || cod_uo = x.cod_comparto)
                  AND cod_abi_istituto = '01025')
             desc_org_delib_calc,
          X.SCSB_UTI_TOT VAL_UTI_TOT
     FROM t_mcre0_app_alert_pos a, -- todo_verificare che sia sufficiente lavorare sulla partizione attiva
          v_mcre0_app_upd_fields x,
          t_mcre0_app_rio_proroghe t
    WHERE     alert_11 IS NOT NULL
          AND x.flg_outsourcing = 'Y'
          AND x.flg_target = 'Y'
          AND x.cod_abi_cartolarizzato = a.cod_abi_cartolarizzato
          AND x.cod_ndg = a.cod_ndg
          AND x.cod_abi_cartolarizzato = t.cod_abi_cartolarizzato
          AND x.cod_ndg = t.cod_ndg
          AND t.flg_storico = 0
          AND t.flg_esito = 1;
