/* Formatted on 17/06/2014 18:00:46 (QP5 v5.227.12220.39754) */
CREATE OR REPLACE FORCE VIEW MCRE_OWN.V_MCRE0_APP_ALERT_RIO_RICHPROR
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
   DTA_SERVIZIO,
   DTA_ULTIMA_PROROGA,
   DTA_LIMITE_PROROGA,
   COD_OD,
   COD_ORG_DELIB,
   DTA_RICHIESTA,
   VAL_MOTIVO_RICHIESTA,
   VAL_MOTIVO_RICHIESTA_1,
   VAL_NUM_PROROGHE,
   DESC_OD,
   DESC_ORG_DELIB,
   FLG_GESTORE_ABILITATO,
   COD_PRIV,
   FLG_ABI_LAVORATO,
   ID_ALERT,
   COD_LIVELLO,
   VAL_UTI_TOT,
   COD_GRUPPO_SUPER
)
AS
   SELECT /*+ordered no_parallel(a) no_parallel(r)*/
                                         -- v1 20/04/2011 VG: FLG_ABI_LAVORATO
                                           -- v2 06/05/2011 VG: COD_MACROSTATO
                                    -- v3 08/06/2011 VG: Flg_esito per storico
                               -- v4 25/07/2012 VG: Numero Proroghe e alert 36
                                     -- v4 12/09/2012 VG: alert 36 in alert 40
         NVL (alert_19, alert_40) val_alert,
         (SELECT DECODE (
                    NVL (alert_19, alert_40),
                    'V', val_verde,
                    DECODE (
                       NVL (alert_19, alert_40),
                       'A', val_arancio,
                       DECODE (NVL (alert_19, alert_40), 'R', val_rosso, NULL)))
            FROM t_mcre0_app_alert
           WHERE id_alert = DECODE (a.alert_19, NULL, 40, 19))
            val_ordine_colore,
         DECODE (alert_19, NULL, dta_ins_40, dta_ins_19) dta_ins_alert,
         a.cod_sndg,
         a.cod_abi_cartolarizzato,
         a.cod_abi_istituto,
         x.desc_istituto,
         a.cod_ndg,
         x.cod_comparto cod_comparto_posizione,
         x.cod_macrostato,
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
         x.id_referente,
         --x.dta_servizio,
         DECODE (x.cod_livello, 'DC', X.DTA_SERVIZIO, NULL) DTA_SERVIZIO, ----3/01/12 AD: modificata per estensione aree/regioni
         t.dta_esito dta_ultima_proroga,
         DECODE (
            x.cod_livello,
            'DC',          ----AD: 3/01 modificato per estensione aree/REgioni
                  (DECODE (t.dta_esito,
                           NULL, dta_servizio + x.val_gg_prima_proroga,
                           t.dta_esito + x.val_gg_seconda_proroga)),
            NULL)
            AS dta_limite_proroga,
         DECODE (t.dta_esito,
                 NULL, x.val_od_prima_proroga,
                 x.val_od_seconda_proroga)
            cod_od,
         --MM05.30 decodifico l'ID_SERVIZIO sul vero OD
         (SELECT cod_organo_deliberante
            FROM t_mcre0_cl_org_delib
           WHERE     id_servizio =
                        DECODE (t.dta_esito,
                                NULL, x.val_od_prima_proroga,
                                x.val_od_seconda_proroga)
                 AND cod_abi = '01025'
                 AND '0' || cod_uo = x.cod_comparto)
            cod_org_delib,
         r.dta_richiesta,
         r.val_motivo_richiesta,
         TO_CHAR (SUBSTR (r.val_motivo_richiesta, 1, 4000)) val_motivo_richiesta_1,
         NVL (r.val_num_proroghe, 0) + 1 val_num_proroghe,
         (SELECT nome_gruppo
            FROM t_mcre0_app_pr_lov_gruppi
           WHERE id_gruppo =
                    DECODE (t.dta_esito,
                            NULL, x.val_od_prima_proroga,
                            x.val_od_seconda_proroga))
            desc_od,
         --MM05.30 decodifico l'ID_SERVIZIO sul vero OD
         (SELECT desc_organo_deliberante
            FROM t_mcre0_cl_organi_deliberanti
           WHERE     cod_organo_deliberante =
                        (SELECT cod_organo_deliberante
                           FROM t_mcre0_cl_org_delib
                          WHERE     id_servizio =
                                       DECODE (t.dta_esito,
                                               NULL, x.val_od_prima_proroga,
                                               x.val_od_seconda_proroga)
                                AND cod_abi = '01025'
                                AND '0' || cod_uo = x.cod_comparto)
                 AND cod_abi_istituto = '01025')
            desc_org_delib,
         x.flg_gestore_abilitato,
         x.cod_priv,
         --I.FLG_ABI_LAVORATO,
         DECODE (
            dta_abi_elab,
            (SELECT MAX (dta_abi_elab) dta_abi_elab_max
               FROM t_mcre0_app_abi_elaborati), '1',
            '0')
            flg_abi_lavorato,
         DECODE (a.alert_19, NULL, 40, 19) id_alert,
         X.COD_LIVELLO,
         X.SCSB_UTI_TOT VAL_UTI_TOT, --3 gen: AD, aggiunto per estensione aree/regioni
         x.cod_gruppo_super
    FROM t_mcre0_app_alert_pos a,
         --   MV_MCRE0_app_istituti i,
         --   t_mcre0_app_anagrafica_gruppo g,
         --   MV_MCRE0_APP_UPD_field x,
         --   t_mcre0_app_anagr_gre ge,
         --   MV_MCRE0_denorm_str_org s,
         --   t_mcre0_app_utenti u,
         (SELECT p.*,
                 FIRST_VALUE (
                    p.cod_sequence)
                 OVER (PARTITION BY cod_abi_cartolarizzato, cod_ndg
                       ORDER BY cod_sequence DESC)
                    cod_sequence_max
            FROM t_mcre0_app_rio_proroghe p
           WHERE p.flg_storico = 1 AND p.flg_esito = 1) t,
         t_mcre0_app_rio_proroghe r,
         --  t_mcre0_app_comparti c
         -- V_MCRE0_APP_UPD_FIELDS_ALL x
         -- todo_verificare che sia sufficiente lavorare sulla partizione attiva
         v_mcre0_app_upd_fields x
   WHERE     (alert_19 IS NOT NULL OR alert_40 IS NOT NULL)
         --AND NVL (X.FLG_OUTSOURCING, 'N') = 'Y'
         AND x.flg_outsourcing = 'Y'
         -- AND I.FLG_TARGET = 'Y'
         AND x.flg_target = 'Y'
         AND x.cod_abi_cartolarizzato = a.cod_abi_cartolarizzato
         AND x.cod_ndg = a.cod_ndg
         AND x.cod_abi_cartolarizzato = t.cod_abi_cartolarizzato(+)
         AND x.cod_ndg = t.cod_ndg(+)
         AND NVL (t.cod_sequence, r.cod_sequence) =
                NVL (t.cod_sequence_max, r.cod_sequence)
         AND x.cod_abi_cartolarizzato = r.cod_abi_cartolarizzato
         AND x.cod_ndg = r.cod_ndg
         AND r.flg_esito IS NULL
         AND r.flg_storico = 0;


GRANT DELETE, INSERT, REFERENCES, SELECT, UPDATE, ON COMMIT REFRESH, QUERY REWRITE, DEBUG, FLASHBACK, MERGE VIEW ON MCRE_OWN.V_MCRE0_APP_ALERT_RIO_RICHPROR TO MCRE_USR;
