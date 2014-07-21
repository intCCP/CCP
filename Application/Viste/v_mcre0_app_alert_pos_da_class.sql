/* Formatted on 21/07/2014 18:32:38 (QP5 v5.227.12220.39754) */
CREATE OR REPLACE FORCE VIEW MCRE_OWN.V_MCRE0_APP_ALERT_POS_DA_CLASS
(
   VAL_ALERT,
   VAL_ORDINE_COLORE,
   DTA_INS_ALERT,
   COD_SNDG,
   COD_ABI_CARTOLARIZZATO,
   COD_ABI_ISTITUTO,
   DESC_ISTITUTO,
   FLG_ABI_LAVORATO,
   COD_NDG,
   COD_COMPARTO_POSIZIONE,
   COD_COMPARTO_UTENTE,
   COD_RAMO_CALCOLATO,
   COD_MACROSTATO,
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
   COD_STATO_PRECEDENTE,
   DTA_DECORRENZA_STATO,
   DTA_SCADENZA_STATO,
   VAL_DURATA_STATO,
   COD_STATO_DESTINAZIONE,
   DTA_INS_STATO_PROPOSTO,
   ID_UTENTE,
   DTA_UTENTE_ASSEGNATO,
   DESC_NOME,
   DESC_COGNOME,
   ID_REFERENTE,
   COD_PRIV,
   FLG_GESTORE_ABILITATO,
   FLG_CLASSIFICA,
   FLG_MOPLE,
   FLG_ANNULLA_PROPOSTA,
   COD_STATO_ORIG,
   FLG_PROPOSTA_BATCH,
   FLG_CLASS_ATTIVA,
   VAL_UTI_TOT,
   COD_GRUPPO_SUPER
)
AS
   SELECT /*+ordered no_parallel(a) no_parallel(t) no_parallel(r)*/
                                           -- V1 ??/??/???? VG: prima versione
 -- V2 07/03/2011 ML: Aggiunta ID_REFERENTE, COD_PRIV, FLG_GESTORE_ABILITATO per gestione visibilità in base al profilo utente
                            -- V3 08/03/2011 VG: aggiunta tabella gestione_rio
                                         -- v4 20/04/2011 VG: FLG_ABI_LAVORATO
                                           -- v5 06/05/2011 VG: COD_MACROSTATO
                                                       -- v6 24/05/2011 VG: GB
                    -- V7 20/06/2011 VG: se RIO e dta_dest null bottoni accesi
 -- v8 25/01/2012 MM aggiunto campo cod_stato_orig per riconoscere come classificare i bonis
         alert_8 val_alert,
         (SELECT DECODE (
                    alert_8,
                    'V', val_verde,
                    DECODE (alert_8,
                            'A', val_arancio,
                            DECODE (alert_8, 'R', val_rosso, NULL)))
            FROM t_mcre0_app_alert
           WHERE id_alert = 8)
            val_ordine_colore,
         dta_ins_8 dta_ins_alert,
         x.cod_sndg,
         x.cod_abi_cartolarizzato,
         x.cod_abi_istituto,
         x.desc_istituto,
         --I.FLG_ABI_LAVORATO,
         DECODE (
            dta_abi_elab,
            (SELECT MAX (dta_abi_elab) dta_abi_elab_max
               FROM t_mcre0_app_abi_elaborati), '1',
            '0')
            flg_abi_lavorato,
         x.cod_ndg,
         x.cod_comparto cod_comparto_posizione,
         --NVL (x.COD_COMPARTO_ASSEGN, x.COD_COMPARTO_APPART)   COD_COMPARTO_UTENTE,
         x.cod_comparto_utente,
         x.cod_ramo_calcolato,
         x.cod_macrostato,
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
         x.cod_stato_precedente,
         x.dta_decorrenza_stato,
         x.dta_scadenza_stato,
         t.val_durata_stato,                                           --04/07
         --    DECODE (x.cod_macrostato,
         --      'RIO', r.cod_macrostato_destinazione,
         --      DECODE (x.cod_macrostato, 'PT', t.cod_macrostato, x.cod_macrostato_proposto))
         CASE
            WHEN x.cod_macrostato = 'RIO'
            THEN
               CASE
                  WHEN r.cod_macrostato_destinazione IS NOT NULL
                  THEN
                     r.cod_macrostato_destinazione
                  ELSE
                     (SELECT DISTINCT
                             DECODE (
                                MAX (cod_microtipologia_delib)
                                   OVER (PARTITION BY d.cod_abi, d.cod_ndg),
                                'CS', 'SO',
                                'CI', 'IN',
                                '')
                        FROM t_mcrei_app_delibere d
                       WHERE     d.cod_abi = x.cod_abi_cartolarizzato
                             AND d.cod_ndg = x.cod_ndg
                             AND d.cod_tipo_pacchetto != 'A'
                             AND d.flg_no_delibera = '0'
                             AND d.cod_fase_delibera NOT IN ('AN', 'VA')
                             AND d.cod_microtipologia_delib IN ('CI', 'CS'))
               END
            WHEN x.cod_macrostato = 'PT'
            THEN
               t.cod_macrostato
            WHEN x.cod_macrostato = 'IN'
            THEN
               'SO'                                         --solo sofferenza!
            WHEN x.cod_macrostato = 'SC'
            THEN
               (SELECT DISTINCT
                       DECODE (
                          MAX (cod_microtipologia_delib)
                             OVER (PARTITION BY d.cod_abi, d.cod_ndg),
                          'CS', 'SO',
                          'CI', 'IN',
                          '')
                  FROM t_mcrei_app_delibere d
                 WHERE     d.cod_abi = x.cod_abi_cartolarizzato
                       AND d.cod_ndg = x.cod_ndg
                       AND d.cod_tipo_pacchetto != 'A'
                       AND d.flg_no_delibera = '0'
                       AND d.cod_fase_delibera NOT IN ('AN', 'VA')
                       AND d.cod_microtipologia_delib IN ('CI', 'CS'))
            ELSE
               x.cod_macrostato_proposto
         END
            cod_stato_destinazione,
         --    DECODE (x.cod_macrostato, 'RIO', r.dta_ins, DECODE (x.cod_macrostato, 'PT', t.dta_ins, x.dta_ins))
         CASE
            WHEN x.cod_macrostato = 'RIO'
            THEN
               CASE
                  WHEN r.dta_ins IS NOT NULL
                  THEN
                     r.dta_ins
                  ELSE
                     (SELECT MAX (dta_ins_delibera)
                                OVER (PARTITION BY d.cod_abi, d.cod_ndg)
                        FROM t_mcrei_app_delibere d
                       WHERE     d.cod_abi = x.cod_abi_cartolarizzato
                             AND d.cod_ndg = x.cod_ndg
                             AND d.cod_tipo_pacchetto != 'A'
                             AND d.flg_no_delibera = '0'
                             AND d.cod_fase_delibera NOT IN ('AN', 'VA')
                             AND d.cod_microtipologia_delib IN ('CI', 'CS'))
               END
            WHEN x.cod_macrostato = 'PT'
            THEN
               t.dta_ins
            WHEN x.cod_macrostato = 'IN'
            THEN
               (SELECT DISTINCT
                       TRUNC (
                          MAX (dta_ins_delibera)
                             OVER (PARTITION BY d.cod_abi, d.cod_ndg))
                  FROM t_mcrei_app_delibere d
                 WHERE     d.cod_abi = x.cod_abi_cartolarizzato
                       AND d.cod_ndg = x.cod_ndg
                       AND d.cod_tipo_pacchetto != 'A'
                       AND d.flg_no_delibera = '0'
                       AND d.cod_fase_delibera NOT IN ('AN', 'VA')
                       AND d.cod_microtipologia_delib IN ('CI', 'CS'))
            WHEN x.cod_macrostato = 'SC'
            THEN
               (SELECT DISTINCT
                       TRUNC (
                          MAX (dta_ins_delibera)
                             OVER (PARTITION BY d.cod_abi, d.cod_ndg))
                  FROM t_mcrei_app_delibere d
                 WHERE     d.cod_abi = x.cod_abi_cartolarizzato
                       AND d.cod_ndg = x.cod_ndg
                       AND d.cod_tipo_pacchetto != 'A'
                       AND d.flg_no_delibera = '0'
                       AND d.cod_fase_delibera NOT IN ('AN', 'VA')
                       AND d.cod_microtipologia_delib IN ('CI', 'CS'))
            ELSE
               x.dta_ins
         END
            dta_ins_stato_proposto,
         x.id_utente,
         x.dta_utente_assegnato,
         x.nome desc_nome,
         x.cognome desc_cognome,
         x.id_referente,
         x.cod_priv,
         x.flg_gestore_abilitato,
         --    CASE
         --     WHEN x.cod_macrostato = 'PT' AND t.cod_macrostato = 'GA' THEN 1
         --     WHEN x.cod_macrostato = 'PT' AND t.cod_macrostato = 'RIO' THEN 1
         --     WHEN x.cod_macrostato = 'RIO' AND NVL (r.cod_macrostato_destinazione, 'BO') = 'BO' THEN 1
         --     WHEN x.cod_macrostato = 'RIO' AND r.cod_macrostato_destinazione = 'ES' THEN 1
         --     WHEN x.cod_macrostato = 'GB' AND x.cod_macrostato_proposto = 'RIO' THEN 1
         --     ELSE 0
         --    END
         1 flg_classifica,
         --    CASE
         --     WHEN x.cod_macrostato = 'PT' AND t.cod_macrostato = 'IN' THEN 1
         --     WHEN x.cod_macrostato = 'PT' AND t.cod_macrostato = 'SO' THEN 1
         --     WHEN x.cod_macrostato = 'RIO' AND NVL (r.cod_macrostato_destinazione, 'IN') = 'IN' THEN 1
         --     WHEN x.cod_macrostato = 'RIO' AND r.cod_macrostato_destinazione = 'SO' THEN 1
         --     WHEN x.cod_macrostato = 'GB' AND x.cod_macrostato_proposto IN ('SO', 'IN') THEN 1
         --     ELSE 0
         --    END
         0 flg_mople,
         DECODE (x.cod_macrostato, 'GB', 1, 0) flg_annulla_proposta,
         x.cod_stato_orig,
         CASE
            WHEN (EXISTS
                     (SELECT DISTINCT 1
                        FROM t_mcrei_app_delibere d
                       WHERE     x.cod_abi_cartolarizzato = d.cod_abi
                             AND x.cod_ndg = d.cod_ndg
                             AND d.flg_attiva = '1'
                             AND d.cod_tipo_pacchetto = 'B'
                             AND d.flg_no_delibera = '0'
                             AND d.cod_fase_delibera NOT IN ('AN', 'VA', 'CO') --1017 aggiunto CO
                             AND d.cod_microtipologia_delib IN ('CI', 'CS')))
            THEN
               'Y'
            ELSE
               'N'
         END
            flg_proposta_batch,
         CASE
            WHEN (EXISTS
                     (SELECT DISTINCT 1
                        FROM t_mcrei_app_delibere d
                       WHERE     x.cod_abi_cartolarizzato = d.cod_abi
                             AND x.cod_ndg = d.cod_ndg
                             AND d.flg_attiva = '1'
                             AND d.flg_no_delibera = '0'
                             AND d.cod_tipo_pacchetto != 'A'
                             AND d.cod_fase_delibera NOT IN ('AN', 'VA', 'CO') --1017 aggiunto CO
                             AND d.cod_microtipologia_delib IN ('CI', 'CS')))
            THEN
               'Y'
            ELSE
               'N'
         END
            FLG_CLASS_ATTIVA,
         X.SCSB_UTI_TOT VAL_UTI_TOT,
         X.COD_GRUPPO_SUPER
    FROM t_mcre0_app_alert_pos a,
         --  MV_MCRE0_APP_ISTITUTI I,
         --   T_MCRE0_APP_ANAGRAFICA_GRUPPO G,
         --   MV_MCRE0_APP_UPD_FIELD X,
         --   T_MCRE0_APP_ANAGR_GRE GE,
         --   MV_MCRE0_DENORM_STR_ORG S,
         --   T_MCRE0_APP_UTENTI U,
         t_mcre0_app_pt_gestione_tavoli t,
         t_mcre0_app_rio_gestione r,
         -- V_MCRE0_APP_UPD_FIELDS_ALL x
         -- todo_verificare che sia sufficiente lavorare sulla partizione attiva
         v_mcre0_app_upd_fields x
   WHERE     alert_8 IS NOT NULL
         AND x.cod_macrostato IN ('PT', 'RIO', 'GB', 'IN', 'SC')
         --AND NVL (X.FLG_OUTSOURCING, 'N') = 'Y'
         AND x.flg_outsourcing = 'Y'
         -- AND I.FLG_TARGET = 'Y'
         AND x.flg_target = 'Y'
         AND x.cod_abi_cartolarizzato = a.cod_abi_cartolarizzato
         AND x.cod_ndg = a.cod_ndg
         AND x.cod_abi_cartolarizzato = t.cod_abi_cartolarizzato(+)
         AND x.cod_ndg = t.cod_ndg(+)
         AND x.cod_abi_cartolarizzato = r.cod_abi_cartolarizzato(+)
         AND x.cod_ndg = r.cod_ndg(+);
