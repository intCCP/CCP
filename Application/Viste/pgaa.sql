/* Formatted on 21/07/2014 18:30:14 (QP5 v5.227.12220.39754) */
CREATE OR REPLACE FORCE VIEW MCRE_OWN.PGAA
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
   FLG_BLOCCO
)
AS
   SELECT today_flg,
          NVL (m.flg_active, w.flg_active) flg_active,
          '0' flg_source,
          id_dper,
          w.cod_abi_istituto,
          w.cod_abi_cartolarizzato,
          w.cod_ndg,
          w.cod_sndg,
          cod_gruppo_economico,
          cod_gruppo_legame,
          flg_gruppo_economico,
          flg_gruppo_legame,
          flg_singolo,
          flg_condiviso,
          flg_somma,
          flg_outsourcing,
          NVL (w.cod_filiale, '-') cod_filiale,
          w.cod_struttura_competente,
          --stati
          CASE WHEN w.cod_stato IS NULL THEN s.cod_stato ELSE w.cod_stato END
             cod_stato,
          NULLIF (w.cod_stato, '-1') AS cod_stato_orig,
          CASE
             WHEN w.cod_stato IS NULL THEN s.dta_decorrenza_stato
             ELSE w.dta_decorrenza_stato
          END
             dta_decorrenza_stato,
          CASE
             WHEN w.cod_stato IS NULL THEN s.dta_scadenza_stato
             ELSE w.dta_scadenza_stato
          END
             dta_scadenza_stato,
          --
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
          NVL (NVL (cod_comparto_assegnato, cod_comparto_calcolato), '#')
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
     FROM mcre_own.t_mcre0_web_data w,
          mcre_own.v_mcre0_stato s,
          mcre_own.v_mcre0_etl_lavorabili m
    WHERE     w.today_flg = '1'
          AND w.cod_abi_cartolarizzato = s.cod_abi_cartolarizzato(+)
          AND w.cod_ndg = s.cod_ndg(+)
          AND w.cod_abi_cartolarizzato = m.cod_abi_cartolarizzato(+)
          AND w.cod_ndg = m.cod_ndg(+)
          AND NOT EXISTS             /*contributo di t_mcre0_app_gb_gestione*/
                     (SELECT 1
                        FROM t_mcre0_app_gb_gestione gb
                       WHERE     w.cod_abi_cartolarizzato =
                                    gb.cod_abi_cartolarizzato
                             AND w.cod_ndg = gb.cod_ndg
                             AND gb.flg_stato(+) = 1);