/* Formatted on 21/07/2014 18:45:12 (QP5 v5.227.12220.39754) */
CREATE OR REPLACE FORCE VIEW MCRE_OWN.VNMCRE0_APP_ALERT_RIO_RICHPROR
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
   DTA_RICHIESTA,
   VAL_MOTIVO_RICHIESTA,
   VAL_NUM_PROROGHE,
   DESC_OD,
   FLG_GESTORE_ABILITATO,
   COD_PRIV,
   FLG_ABI_LAVORATO
)
AS
   SELECT /*+ordered no_parallel(a) no_parallel(r)*/
                                         -- v1 20/04/2011 VG: FLG_ABI_LAVORATO
                                           -- v2 06/05/2011 VG: COD_MACROSTATO
                                    -- v3 08/06/2011 VG: Flg_esito per storico
                               -- v4 25/07/2012 VG: Numero Proroghe e alert 36
         NVL (alert_19, alert_36) val_alert,
         (SELECT DECODE (
                    NVL (alert_19, alert_36),
                    'V', val_verde,
                    DECODE (
                       NVL (alert_19, alert_36),
                       'A', val_arancio,
                       DECODE (NVL (alert_19, alert_36), 'R', val_rosso, NULL)))
            FROM t_mcre0_app_alert
           WHERE id_alert = DECODE (a.alert_19, NULL, 36, 19))
            val_ordine_colore,
         DECODE (alert_19, NULL, dta_ins_36, dta_ins_19) dta_ins_alert,
         a.cod_sndg,
         a.cod_abi_cartolarizzato,
         a.cod_abi_istituto,
         x.DESC_ISTITUTO,
         a.cod_ndg,
         x.cod_comparto cod_comparto_posizione,
         x.COD_MACROSTATO,
         --  NVL (x.cod_comparto_assegn, x.cod_comparto_appart) cod_comparto_utente
         x.cod_comparto_utente,
         x.cod_ramo_calcolato,
         x.desc_nome_controparte,
         x.cod_gruppo_economico,
         x.desc_gruppo_economico val_ana_gre,
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
         x.dta_servizio,
         t.dta_esito dta_ultima_proroga,
         DECODE (t.dta_esito,
                 NULL, dta_servizio + x.val_gg_prima_proroga,
                 t.dta_esito + x.val_gg_seconda_proroga)
            dta_limite_proroga,
         DECODE (t.dta_esito,
                 NULL, x.val_od_prima_proroga,
                 x.val_od_seconda_proroga)
            cod_od,
         r.dta_richiesta,
         r.val_motivo_richiesta,
         NVL (r.val_num_proroghe, 0) + 1 val_num_proroghe,
         (SELECT nome_gruppo
            FROM t_mcre0_app_pr_lov_gruppi
           WHERE id_gruppo =
                    DECODE (t.dta_esito,
                            NULL, x.val_od_prima_proroga,
                            x.val_od_seconda_proroga))
            desc_od,
         x.flg_gestore_abilitato,
         x.cod_priv,
         --I.FLG_ABI_LAVORATO,
         DECODE (
            DTA_ABI_ELAB,
            (SELECT MAX (DTA_ABI_ELAB) DTA_ABI_ELAB_MAX
               FROM T_MCRE0_APP_ABI_ELABORATI), '1',
            '0')
            FLG_ABI_LAVORATO
    FROM t_mcre0_app_alert_pos a,
         --          MV_MCRE0_app_istituti i,
         --          t_mcre0_app_anagrafica_gruppo g,
         --          MV_MCRE0_APP_UPD_field x,
         --          t_mcre0_app_anagr_gre ge,
         --          MV_MCRE0_denorm_str_org s,
         --          t_mcre0_app_utenti u,
         (SELECT p.*,
                 FIRST_VALUE (
                    p.cod_sequence)
                 OVER (PARTITION BY cod_abi_cartolarizzato, cod_ndg
                       ORDER BY cod_sequence DESC)
                    cod_sequence_max
            FROM T_MCRE0_APP_RIO_PROROGHE P
           WHERE P.FLG_STORICO = 1 AND p.flg_esito = 1) t,
         t_mcre0_app_rio_proroghe r,
         --  t_mcre0_app_comparti c
         -- V_MCRE0_APP_UPD_FIELDS_ALL x
         -- todo_verificare che sia sufficiente lavorare sulla partizione attiva
         V_MCRE0_APP_UPD_FIELDS x
   WHERE     (alert_19 IS NOT NULL OR alert_36 IS NOT NULL)
         --AND NVL (X.FLG_OUTSOURCING, 'N') = 'Y'
         AND X.FLG_OUTSOURCING = 'Y'
         -- AND I.FLG_TARGET = 'Y'
         AND X.FLG_TARGET = 'Y'
         AND x.cod_abi_cartolarizzato = a.cod_abi_cartolarizzato
         AND x.cod_ndg = a.cod_ndg
         AND x.cod_abi_cartolarizzato = t.cod_abi_cartolarizzato(+)
         AND x.cod_ndg = t.cod_ndg(+)
         AND NVL (t.cod_sequence, r.cod_sequence) =
                NVL (t.cod_sequence_max, r.cod_sequence)
         AND x.cod_abi_cartolarizzato = r.cod_abi_cartolarizzato
         AND x.cod_ndg = r.cod_ndg
         AND r.flg_esito IS NULL
         AND r.flg_storico = 0
--          AND x.cod_abi_istituto = i.cod_abi(+)
--          AND x.cod_sndg = g.cod_sndg(+)
--          AND x.cod_gruppo_economico = ge.cod_gre(+)
--          AND x.cod_abi_istituto = s.cod_abi_istituto_fi(+)
--          AND x.cod_filiale = s.cod_struttura_competente_fi(+)
--          AND x.id_utente = u.id_utente(+)
--          AND X.COD_COMPARTO = x.COD_COMPARTO
;
