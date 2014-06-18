/* Formatted on 17/06/2014 18:06:57 (QP5 v5.227.12220.39754) */
CREATE OR REPLACE FORCE VIEW MCRE_OWN.V_MCRE0_WEB_DATA_TT5
(
   TODAY_FLG,
   FLG_ACTIVE,
   FLG_SOURCE,
   FLG_BLOCCO,
   ID_DPER,
   ID_DPERFG,
   ID_DPERMO,
   COD_SNDG,
   DESC_NOME_CONTROPARTE,
   COD_NDG,
   COD_ABI_CARTOLARIZZATO,
   COD_ABI_ISTITUTO,
   DESC_ISTITUTO,
   DESC_BREVE,
   FLG_TARGET,
   FLG_CARTOLARIZZATO,
   DTA_ABI_ELAB,
   COD_GRUPPO_ECONOMICO,
   DESC_GRUPPO_ECONOMICO,
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
   DTA_COMPARTO_CALCOLATO,
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
   COD_MATR_ASSEGNATORE,
   COD_SEZIONE_PREASSEGNATA,
   ID_UTENTE_PREASSEGNATO,
   COD_COMPARTO_PREASSEGNATO,
   COD_PROCESSO_PREASSEGNATO,
   FLG_STATO_GB,
   COD_FILIALE_GB,
   COD_PROCESSO_CALCOLATO_GB,
   COD_MACROSTATO_PROPOSTO_GB,
   DTA_INS_GB
)
AS
   SELECT today_flg,
          flg_active,
          flg_source,
          flg_blocco,
          w.id_dper,
          id_dperfg,
          id_dpermo,
          w.cod_sndg,
          desc_nome_controparte,
          cod_ndg,
          cod_abi_cartolarizzato,
          w.cod_abi_istituto,
          desc_istituto,
          desc_breve,
          flg_target,
          flg_cartolarizzato,
          dta_abi_elab,
          --          CASE
          --             WHEN w.cod_gruppo_economico = '-1' THEN NULL
          --             ELSE w.cod_gruppo_economico
          --          END
          w.cod_gruppo_economico,
          val_ana_gre desc_gruppo_economico,
          CASE
             WHEN w.cod_gruppo_legame = '-1' THEN NULL
             ELSE w.cod_gruppo_legame
          END
             cod_gruppo_legame,
          flg_gruppo_economico,
          flg_gruppo_legame,
          flg_singolo,
          flg_condiviso,
          w.flg_somma,
          w.flg_outsourcing,
          NVL (w.cod_filiale, '-') cod_filiale,
          cod_struttura_competente,
          cod_stato,
          dta_decorrenza_stato,
          dta_scadenza_stato,
          cod_stato_precedente,
          dta_decorrenza_stato_pre,
          dta_intercettamento,
          cod_tipo_ingresso,
          cod_causale_ingresso,
          cod_percorso,
          cod_processo,
          dta_processo,
          cod_processo_pre,
          cod_macrostato,
          dta_dec_macrostato,
          cod_ramo_calcolato,
          cod_comparto_calcolato,
          SYSDATE dta_comparto_calcolato,
          cod_comparto_calcolato_pre,
          cod_gruppo_super,
          cod_gruppo_super_old,
          flg_riportafogliato,
          dta_last_riportaf,
          flg_proposto_assegnato,
          dta_utente_assegnato,
          cod_comparto_assegnato,
          NVL (id_utente, -1) id_utente,
          NVL (id_utente_pre, -1) id_utente_pre,
          cod_servizio,
          dta_servizio,
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
          cod_matr_assegnatore,
          cod_sezione_preassegnata,
          id_utente_preassegnato,
          cod_comparto_preassegnato,
          cod_processo_preassegnato,
          flg_stato_gb,
          cod_filiale_gb,
          cod_processo_calcolato_gb,
          cod_macrostato_proposto_gb,
          dta_ins_gb
     FROM (SELECT /*+full(t) full(gb)*/
                                                       --                 CASE
                   --                     WHEN gb.cod_ndg IS NOT NULL THEN '1'
                                       --                     ELSE t.today_flg
                                                       --                  END
                 t.today_flg,
                 --                  CASE
                 --                     WHEN gb.cod_ndg IS NOT NULL
                 --                     THEN
                 --                        NVL (
                 --                           (SELECT '1'
                 --                              FROM t_mcre0_day_mopl u
                 --                             WHERE u.cod_ndg = t.cod_ndg
                 --                                   AND u.cod_abi_cartolarizzato =
                 --                                          t.cod_abi_cartolarizzato),
                 --                           '2')
                 --                     ELSE
                 --                        '0'
                 --                  END
                 '0' flg_source,
                 '1' flg_active,
                 t.id_dper,
                 t.id_dperfg,
                 t.id_dpermo,
                 t.cod_abi_istituto,
                 t.cod_abi_cartolarizzato,
                 t.cod_ndg,
                 t.cod_sndg,
                 t.cod_gruppo_economico,
                 t.cod_gruppo_legame,
                 t.flg_gruppo_economico,
                 t.flg_gruppo_legame,
                 t.flg_singolo,
                 t.flg_condiviso,
                 t.flg_somma,
                 t.flg_outsourcing,
                 t.cod_filiale,
                 t.cod_struttura_competente,
                 t.cod_stato,
                 --                  CASE
                 --                     WHEN     t.COD_STATO = 'IN'
                 --                          AND R.DTA_DECORRENZA_STATO IS NOT NULL
                 --                          AND DTA_CHIUSURA_STATO IS NULL
                 --                     THEN
                 --                        'RS'
                 --                     ELSE
                 --                        NVL (t.COD_STATO, '-1')
                 --                  END
                 --                     COD_STATO,
                 t.dta_decorrenza_stato,
                 --                  CASE
                 --                     WHEN     t.COD_STATO = 'IN'
                 --                          AND R.DTA_DECORRENZA_STATO IS NOT NULL
                 --                          AND DTA_CHIUSURA_STATO IS NULL
                 --                     THEN
                 --                        TRUNC (R.DTA_DECORRENZA_STATO)
                 --                     ELSE           --maggiore tra le 2 M.DTA_DECORRENZA_STATO
                 --                        CASE
                 --                           WHEN (TRUNC (R.DTA_CHIUSURA_STATO) - t.DTA_DECORRENZA_STATO) <
                 --                                   0
                 --                           THEN
                 --                              t.DTA_DECORRENZA_STATO
                 --                           WHEN (TRUNC (R.DTA_CHIUSURA_STATO)
                 --                                 - t.DTA_DECORRENZA_STATO) > 0
                 --                           THEN
                 --                              TRUNC (R.DTA_CHIUSURA_STATO)
                 --                           WHEN (TRUNC (R.DTA_CHIUSURA_STATO)
                 --                                 - t.DTA_DECORRENZA_STATO) = 0
                 --                           THEN
                 --                              t.DTA_DECORRENZA_STATO
                 --                           ELSE
                 --                              t.DTA_DECORRENZA_STATO
                 --                        END
                 --                  END
                 --                     DTA_DECORRENZA_STATO,
                 t.dta_scadenza_stato,
                 t.cod_stato_precedente,
                 --                  CASE
                 --                     WHEN     t.COD_STATO IN ('IN', 'SO')
                 --                          AND R.DTA_DECORRENZA_STATO IS NOT NULL
                 --                          AND DTA_CHIUSURA_STATO IS NOT NULL
                 --                     THEN
                 --                        (SELECT COD_STATO_PRECEDENTE
                 --                           FROM (SELECT X.COD_STATO_PRECEDENTE,
                 --                                        X.COD_ABI_CARTOLARIZZATO,
                 --                                        X.COD_NDG,
                 --                                        X.TMS,
                 --                                        MAX (
                 --                                           X.TMS)
                 --                                        OVER (
                 --                                           PARTITION BY X.COD_ABI_CARTOLARIZZATO,
                 --                                                        X.COD_NDG)
                 --                                           MAX_TMS
                 --                                   FROM T_MCRE0_dwh_PERC X) GR
                 --                          WHERE gr.TMS = gr.MAX_TMS
                 --                                AND t.COD_ABI_CARTOLARIZZATO =
                 --                                       GR.COD_ABI_CARTOLARIZZATO(+)
                 --                                AND t.COD_NDG = GR.COD_NDG(+))
                 --                     ELSE
                 --                        NVL (t.COD_STATO_PRECEDENTE, '-1')
                 --                  END
                 --                     COD_STATO_PRECEDENTE,
                 t.dta_decorrenza_stato_pre,
                 t.dta_intercettamento,
                 t.cod_tipo_ingresso,
                 t.cod_causale_ingresso,
                 t.cod_percorso,
                 t.cod_processo,
                 t.dta_processo,
                 t.cod_processo_pre,
                 t.cod_macrostato,
                 t.dta_dec_macrostato,
                 --                  CASE
                 --                     WHEN     t.COD_STATO = 'IN'
                 --                          AND R.DTA_DECORRENZA_STATO IS NOT NULL
                 --                          AND DTA_CHIUSURA_STATO IS NULL
                 --                     THEN
                 --                        'RS'
                 --                     ELSE
                 --                        t.COD_MACROSTATO
                 --                  END
                 --                     COD_MACROSTATO,
                 --                  CASE
                 --                     WHEN     t.COD_STATO = 'IN'
                 --                          AND R.DTA_DECORRENZA_STATO IS NOT NULL
                 --                          AND DTA_CHIUSURA_STATO IS NULL
                 --                     THEN
                 --                        TRUNC (R.DTA_DECORRENZA_STATO)
                 --                     ELSE
                 --                        t.DTA_DEC_MACROSTATO
                 --                  END
                 --                     DTA_DEC_MACROSTATO,
                 t.cod_ramo_calcolato,
                 t.cod_comparto_calcolato,
                 t.cod_comparto_calcolato_pre,
                 t.cod_gruppo_super,
                 t.cod_gruppo_super_old,
                 t.flg_riportafogliato,
                 t.dta_last_riportaf,
                 t.flg_proposto_assegnato,
                 --                  CASE
                 --                     WHEN w.cod_ndg IS NOT NULL THEN w.dta_utente_assegnato
                 --                     ELSE t.dta_utente_assegnato
                 --                  END
                 w.dta_utente_assegnato,
                 --                  CASE
                 --                     WHEN w.cod_ndg IS NOT NULL THEN w.cod_comparto_assegnato
                 --                     ELSE t.cod_comparto_assegnato
                 --                  END
                 w.cod_comparto_assegnato,
                 --                  CASE
                 --                     WHEN w.cod_ndg IS NOT NULL THEN w.id_utente
                 --                     ELSE t.id_utente
                 --                  END
                 w.id_utente,
                 t.id_utente_pre,
                 --                  CASE
                 --                     WHEN w.cod_ndg IS NOT NULL THEN w.cod_servizio
                 --                     ELSE t.cod_servizio
                 --                  END
                 w.cod_servizio,
                 w.dta_servizio,
                 t.id_stato_posizione,
                 t.cod_cliente_esteso,
                 t.id_cliente_esteso,
                 t.desc_anag_gestore_mkt,
                 t.cod_gestore_mkt,
                 t.cod_tipo_portafoglio,
                 t.flg_gestione_esterna,
                 t.val_perc_decurtazione,
                 t.cod_comparto_host,
                 t.id_transizione,
                 t.cod_ramo_host,
                 t.cod_matr_rischio,
                 t.cod_uo_rischio,
                 t.cod_disp_rischio,
                 t.dta_ins,
                 t.dta_upd,
                 w.flg_blocco,
                 w.cod_operatore_ins_upd,
                 w.cod_matr_assegnatore,
                 w.cod_sezione_preassegnata,
                 w.id_utente_preassegnato,
                 w.cod_comparto_preassegnato,
                 w.cod_processo_preassegnato,
                 --                  CASE
                 --                     WHEN gb.cod_ndg IS NOT NULL THEN gb.flg_stato
                 --                     ELSE w.flg_stato_gb
                 --                  END
                 flg_stato_gb,
                 --                  CASE
                 --                     WHEN gb.cod_ndg IS NOT NULL THEN gb.cod_filiale
                 --                     ELSE w.cod_filiale_gb
                 --                  END
                 cod_filiale_gb,
                 --                  CASE
                 --                     WHEN gb.cod_ndg IS NOT NULL
                 --                     THEN
                 --                        gb.cod_processo_calcolato
                 --                     ELSE
                 --                        w.cod_processo_calcolato_gb
                 --                  END
                 cod_processo_calcolato_gb,
                 --                  CASE
                 --                     WHEN gb.cod_ndg IS NOT NULL
                 --                     THEN
                 --                        gb.cod_macrostato_proposto
                 --                     ELSE
                 --                        w.cod_macrostato_proposto_gb
                 --                  END
                 cod_macrostato_proposto_gb,
                 --                  CASE
                 --                     WHEN gb.cod_ndg IS NOT NULL THEN gb.dta_ins
                 --                     ELSE w.dta_ins_gb
                 --                  END
                 dta_ins_gb
            FROM ttmcre0_web_data_4 t, t_mcre0_all_data w                  --,
           --                  t_mcre0_app_gb_gestione gb--,
           --                  (SELECT *
           --                     FROM (SELECT r.*,
           --                                  MAX (
           --                                     tms_ini)
           --                                  OVER (
           --                                     PARTITION BY cod_abi_cartolarizzato,
           --                                                  cod_ndg)
           --                                     max_tms
           --                             FROM T_MCRE0_APP_RS_POSIZIONI r)
           --                    WHERE tms_ini = max_tms) r                          --v1.3
           WHERE     t.cod_ndg = w.cod_ndg(+)
                 AND t.cod_abi_cartolarizzato = w.cod_abi_cartolarizzato(+) --        AND t.cod_abi_cartolarizzato = gb.cod_abi_cartolarizzato(+)
                                                                           --                  AND t.COD_ABI_CARTOLARIZZATO = R.COD_ABI_CARTOLARIZZATO(+)
                                                                           --                  AND t.COD_NDG = R.COD_NDG(+)
                                                                           --                 AND t.cod_ndg = gb.cod_ndg(+)
                                                                           --                AND gb.flg_stato(+) = 1
          ) w,
          t_mcre0_dwh_agru ag,
          t_mcre0_dwh_agre ge,
          mv_mcre0_app_istituti i
    WHERE     ag.cod_sndg(+) = w.cod_sndg
          AND ge.cod_gre(+) = w.cod_gruppo_economico
          AND w.cod_abi_istituto = i.cod_abi;


GRANT SELECT ON MCRE_OWN.V_MCRE0_WEB_DATA_TT5 TO MCRE_USR;
