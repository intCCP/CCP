/* Formatted on 21/07/2014 18:38:20 (QP5 v5.227.12220.39754) */
CREATE OR REPLACE FORCE VIEW MCRE_OWN.V_MCRE0_WEB_DATA_BASE
(
   TODAY_FLG,
   FLG_ACTIVE,
   FLG_SOURCE,
   ID_DPER,
   COD_ABI_ISTITUTO,
   COD_ABI_CARTOLARIZZATO,
   COD_NDG,
   COD_SNDG,
   COD_GRUPPO_ECONOMICO,
   COD_GRUPPO_LEGAME,
   FLG_GRUPPO_ECONOMICO,
   FLG_GRUPPO_LEGAME,
   FLG_SINGOLO,
   FLG_CONDIVISO,
   FLG_SOMMA,
   FLG_OUTSOURCING,
   COD_FILIALE,
   COD_STRUTTURA_COMPETENTE,
   COD_STATO,
   COD_STATO_ORIG,
   DTA_DECORRENZA_STATO,
   DTA_SCADENZA_STATO,
   COD_STATO_PRECEDENTE,
   DTA_DECORRENZA_STATO_PRE,
   DTA_INTERCETTAMENTO,
   COD_TIPO_INGRESSO,
   COD_CAUSALE_INGRESSO,
   COD_PERCORSO,
   COD_PROCESSO,
   DTA_PROCESSO,
   COD_PROCESSO_PRE,
   COD_MACROSTATO,
   DTA_DEC_MACROSTATO,
   COD_RAMO_CALCOLATO,
   COD_COMPARTO_CALCOLATO,
   COD_COMPARTO_CALCOLATO_PRE,
   COD_GRUPPO_SUPER,
   COD_GRUPPO_SUPER_OLD,
   FLG_RIPORTAFOGLIATO,
   DTA_LAST_RIPORTAF,
   FLG_PROPOSTO_ASSEGNATO,
   DTA_UTENTE_ASSEGNATO,
   COD_COMPARTO_ASSEGNATO,
   ID_UTENTE,
   ID_UTENTE_PRE,
   COD_SERVIZIO,
   DTA_SERVIZIO,
   COD_COMPARTO,
   COD_MATR_ASSEGNATORE,
   COD_SEZIONE_PREASSEGNATA,
   ID_UTENTE_PREASSEGNATO,
   COD_COMPARTO_PREASSEGNATO,
   ID_STATO_POSIZIONE,
   COD_CLIENTE_ESTESO,
   ID_CLIENTE_ESTESO,
   DESC_ANAG_GESTORE_MKT,
   COD_GESTORE_MKT,
   COD_TIPO_PORTAFOGLIO,
   FLG_GESTIONE_ESTERNA,
   VAL_PERC_DECURTAZIONE,
   COD_COMPARTO_HOST,
   ID_TRANSIZIONE,
   COD_RAMO_HOST,
   COD_MATR_RISCHIO,
   COD_UO_RISCHIO,
   COD_DISP_RISCHIO,
   DTA_INS,
   DTA_UPD,
   COD_OPERATORE_INS_UPD,
   COD_FILIALE_GB,
   COD_PROCESSO_CALCOLATO_GB,
   COD_PROCESSO_CALCOLATO,
   COD_MACROSTATO_PROPOSTO_GB,
   COD_MACROSTATO_PROPOSTO,
   DTA_INS_GB,
   FLG_STATO_GB,
   FLG_BLOCCO,
   DESC_NOME_CONTROPARTE,
   DESC_GRUPPO_ECONOMICO
)
AS
   WITH a
        AS (SELECT                                     /* +full(w) hash(w,m)*/
                  today_flg,
                   flg_active,
                   '0' flg_source,
                   id_dper,
                   w.cod_abi_istituto,
                   w.cod_abi_cartolarizzato,
                   w.cod_ndg,
                   w.cod_sndg,
                   CASE
                      WHEN w.cod_gruppo_economico = '-1' THEN NULL
                      ELSE w.cod_gruppo_economico
                   END
                      cod_gruppo_economico,
                   CASE
                      WHEN w.cod_gruppo_legame = '-1' THEN NULL
                      ELSE w.cod_gruppo_legame
                   END
                      cod_gruppo_legame,
                   flg_gruppo_economico,
                   flg_gruppo_legame,
                   flg_singolo,
                   flg_condiviso,
                   flg_somma,
                   flg_outsourcing,
                   NVL (w.cod_filiale, '-') cod_filiale,
                   w.cod_struttura_competente,
                   ----stati
                   --                   CASE
                   --                      WHEN w.cod_stato = 'IN'
                   --                           AND s.dta_decorrenza_stato IS NOT NULL
                   --                      THEN
                   --                         s.cod_stato
                   --                      ELSE
                   --                         NULLIF (w.cod_stato, '-1')
                   --                   END
                   cod_stato,
                   NULLIF (w.cod_stato, '-1') AS cod_stato_orig,
                   --                   CASE
                   --                      WHEN w.cod_stato = 'IN'
                   --                           AND s.dta_decorrenza_stato IS NOT NULL
                   --                      THEN
                   --                         s.dta_decorrenza_stato
                   --                      ELSE
                   --                         w.dta_decorrenza_stato
                   --                   END
                   dta_decorrenza_stato,
                   --                   CASE
                   --                      WHEN w.cod_stato = 'IN'
                   --                           AND s.dta_decorrenza_stato IS NOT NULL
                   --                      THEN
                   --                         s.dta_scadenza_stato
                   --                      ELSE
                   --                         w.dta_scadenza_stato
                   --                   END
                   dta_scadenza_stato,
                   --          --
                   cod_stato_precedente,
                   dta_decorrenza_stato_pre,
                   dta_intercettamento,
                   cod_tipo_ingresso,
                   cod_causale_ingresso,
                   cod_percorso,
                   cod_processo,
                   dta_processo,
                   cod_processo_pre,
                   --                   CASE
                   --                      WHEN w.cod_stato = 'IN'
                   --                           AND s.dta_decorrenza_stato IS NOT NULL
                   --                      THEN
                   --                         s.cod_macrostato
                   --                      ELSE
                   --                         w.cod_macrostato
                   --                   END
                   cod_macrostato,
                   --                   CASE
                   --                      WHEN w.cod_stato = 'IN'
                   --                           AND s.dta_decorrenza_stato IS NOT NULL
                   --                      THEN
                   --                         s.dta_dec_macrostato
                   --                      ELSE
                   --                         w.dta_dec_macrostato
                   --                   END
                   dta_dec_macrostato,
                   cod_ramo_calcolato,
                   cod_comparto_calcolato,
                   cod_comparto_calcolato_pre,
                   w.cod_gruppo_super,
                   cod_gruppo_super_old,
                   flg_riportafogliato,
                   dta_last_riportaf,
                   flg_proposto_assegnato,
                   dta_utente_assegnato,
                   cod_comparto_assegnato,
                   id_utente,
                   id_utente_pre,
                   cod_servizio,
                   dta_servizio,
                   NVL (NVL (cod_comparto_assegnato, cod_comparto_calcolato),
                        '#')
                      cod_comparto,
                   cod_matr_assegnatore,
                   cod_sezione_preassegnata,
                   id_utente_preassegnato,
                   cod_comparto_preassegnato,
                   id_stato_posizione,
                   cod_cliente_esteso,
                   id_cliente_esteso,
                   desc_anag_gestore_mkt,
                   cod_gestore_mkt,
                   cod_tipo_portafoglio,
                   flg_gestione_esterna,
                   val_perc_decurtazione,
                   cod_comparto_host,
                   id_transizione,
                   cod_ramo_host,
                   cod_matr_rischio,
                   cod_uo_rischio,
                   cod_disp_rischio,
                   w.dta_ins,
                   w.dta_upd,
                   cod_operatore_ins_upd,
                   --GB
                   NULL cod_filiale_gb,
                   NULL cod_processo_calcolato_gb,
                   NULL cod_processo_calcolato,
                   NULL cod_macrostato_proposto_gb,
                   NULL cod_macrostato_proposto,
                   NULL dta_ins_gb,
                   NULL flg_stato_gb,
                   -- CIB/BDT
                   w.FLG_BLOCCO
              FROM t_mcre0_web_data w                                      --,
                                     --                   v_mcre0_ristrutturati s,
                                     --                   (SELECT cod_ndg, cod_abi_cartolarizzato
                                     --                      FROM t_mcre0_app_gb_gestione
                                     --                     WHERE flg_stato = '1') gb
                                     --             WHERE w.cod_abi_cartolarizzato = s.cod_abi_cartolarizzato(+)
                                     --                   AND w.cod_ndg = s.cod_ndg(+)
                                     --                   AND w.cod_abi_cartolarizzato =
                                     --                          gb.cod_abi_cartolarizzato(+)
                                     --                   AND w.cod_ndg = gb.cod_ndg(+)
                                     --                   AND gb.cod_ndg || gb.cod_abi_cartolarizzato IS NULL
                                     --            UNION ALL
                                     --            /*contributo di t_mcre0_app_gb_gestione*/
                                     --            SELECT *
                                     --              FROM v_mcre0_gb_gestione gb
           )
   SELECT a."TODAY_FLG",
          a."FLG_ACTIVE",
          a."FLG_SOURCE",
          a."ID_DPER",
          a."COD_ABI_ISTITUTO",
          a."COD_ABI_CARTOLARIZZATO",
          a."COD_NDG",
          a."COD_SNDG",
          a."COD_GRUPPO_ECONOMICO",
          a."COD_GRUPPO_LEGAME",
          a."FLG_GRUPPO_ECONOMICO",
          a."FLG_GRUPPO_LEGAME",
          a."FLG_SINGOLO",
          a."FLG_CONDIVISO",
          a."FLG_SOMMA",
          a."FLG_OUTSOURCING",
          a."COD_FILIALE",
          a."COD_STRUTTURA_COMPETENTE",
          a."COD_STATO",
          a."COD_STATO_ORIG",
          a."DTA_DECORRENZA_STATO",
          a."DTA_SCADENZA_STATO",
          a."COD_STATO_PRECEDENTE",
          a."DTA_DECORRENZA_STATO_PRE",
          a."DTA_INTERCETTAMENTO",
          a."COD_TIPO_INGRESSO",
          a."COD_CAUSALE_INGRESSO",
          a."COD_PERCORSO",
          a."COD_PROCESSO",
          a."DTA_PROCESSO",
          a."COD_PROCESSO_PRE",
          a."COD_MACROSTATO",
          a."DTA_DEC_MACROSTATO",
          a."COD_RAMO_CALCOLATO",
          a."COD_COMPARTO_CALCOLATO",
          a."COD_COMPARTO_CALCOLATO_PRE",
          a."COD_GRUPPO_SUPER",
          a."COD_GRUPPO_SUPER_OLD",
          a."FLG_RIPORTAFOGLIATO",
          a."DTA_LAST_RIPORTAF",
          a."FLG_PROPOSTO_ASSEGNATO",
          a."DTA_UTENTE_ASSEGNATO",
          a."COD_COMPARTO_ASSEGNATO",
          a."ID_UTENTE",
          a."ID_UTENTE_PRE",
          a."COD_SERVIZIO",
          a."DTA_SERVIZIO",
          a."COD_COMPARTO",
          a."COD_MATR_ASSEGNATORE",
          a."COD_SEZIONE_PREASSEGNATA",
          a."ID_UTENTE_PREASSEGNATO",
          a."COD_COMPARTO_PREASSEGNATO",
          a."ID_STATO_POSIZIONE",
          a."COD_CLIENTE_ESTESO",
          a."ID_CLIENTE_ESTESO",
          a."DESC_ANAG_GESTORE_MKT",
          a."COD_GESTORE_MKT",
          a."COD_TIPO_PORTAFOGLIO",
          a."FLG_GESTIONE_ESTERNA",
          a."VAL_PERC_DECURTAZIONE",
          a."COD_COMPARTO_HOST",
          a."ID_TRANSIZIONE",
          a."COD_RAMO_HOST",
          a."COD_MATR_RISCHIO",
          a."COD_UO_RISCHIO",
          a."COD_DISP_RISCHIO",
          a."DTA_INS",
          a."DTA_UPD",
          a."COD_OPERATORE_INS_UPD",
          a."COD_FILIALE_GB",
          a."COD_PROCESSO_CALCOLATO_GB",
          a."COD_PROCESSO_CALCOLATO",
          a."COD_MACROSTATO_PROPOSTO_GB",
          a."COD_MACROSTATO_PROPOSTO",
          a."DTA_INS_GB",
          a."FLG_STATO_GB",
          a."FLG_BLOCCO",
          --          (SELECT desc_nome_controparte
          --             FROM t_mcre0_app_anagrafica_gruppo g
          --            WHERE a.cod_sndg = g.cod_sndg)
          'aaaa' desc_nome_controparte,
          --          (SELECT DISTINCT val_ana_gre desc_gruppo_economico
          --             FROM t_mcre0_app_anagr_gre g
          --            WHERE a.cod_gruppo_economico = g.cod_gre)
          'bbbb' desc_gruppo_economico
     FROM a;
