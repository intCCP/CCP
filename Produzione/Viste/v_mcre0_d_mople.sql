/* Formatted on 17/06/2014 18:05:00 (QP5 v5.227.12220.39754) */
CREATE OR REPLACE FORCE VIEW MCRE_OWN.V_MCRE0_D_MOPLE
(
   ID_DPER,
   COD_ABI_ISTITUTO,
   COD_ABI_CARTOLARIZZATO,
   COD_NDG,
   COD_SNDG,
   DTA_INTERCETTAMENTO,
   COD_FILIALE,
   COD_STRUTTURA_COMPETENTE,
   COD_TIPO_INGRESSO,
   COD_CAUSALE_INGRESSO,
   COD_PERCORSO,
   COD_PROCESSO,
   COD_STATO,
   DTA_DECORRENZA_STATO,
   DTA_SCADENZA_STATO,
   COD_STATO_PRECEDENTE,
   ID_STATO_POSIZIONE,
   COD_CLIENTE_ESTESO,
   ID_CLIENTE_ESTESO,
   DESC_ANAG_GESTORE_MKT,
   COD_GESTORE_MKT,
   COD_TIPO_PORTAFOGLIO,
   FLG_GESTIONE_ESTERNA,
   VAL_PERC_DECURTAZIONE,
   COD_COMPARTO_HOST,
   DTA_INS,
   DTA_UPD,
   COD_OPERATORE_INS_UPD,
   COD_MACROSTATO,
   DTA_DEC_MACROSTATO,
   ID_TRANSIZIONE,
   DTA_PROCESSO,
   COD_PROCESSO_PRE,
   COD_RAMO_HOST,
   DTA_DECORRENZA_STATO_PRE,
   COD_MATR_RISCHIO,
   COD_UO_RISCHIO,
   COD_DISP_RISCHIO
)
AS
   WITH st
        AS (SELECT /*+no_parallel(app) index(app PKT_MCRE0_DWH_MOPL)*/
                  a.*,
                   s.cod_macrostato,
                   s.flg_stato_chk,
                   s.tip_stato,
                   app.cod_comparto_host cod_comparto_app,
                   app.cod_ramo_host cod_ramo_app,
                   app.cod_percorso cod_percorso_app,
                   app.cod_processo_pre cod_processo_pre_app,
                   app.dta_decorrenza_stato_pre dta_decorrenza_stato_pre_app,
                   app.cod_macrostato cod_macrostato_app,
                   app.dta_dec_macrostato dta_dec_macrostato_app,
                   app.dta_ins dta_ins_app
              FROM t_mcre0_stg_mopl a,
                   t_mcre0_app_stati s,                    -- tabella statica,
                   t_mcre0_dwh_mopl app
             --t_mcre0_all_data app
             WHERE     s.cod_microstato = a.cod_stato
                   AND a.cod_abi_cartolarizzato =
                          app.cod_abi_cartolarizzato(+)
                   AND a.cod_ndg = app.cod_ndg(+)),
        s
        AS (SELECT st.*,
                   CASE
                      WHEN b.cod_abi_istituto || b.cod_struttura_competente
                              IS NOT NULL
                      THEN
                         cod_comparto
                      ELSE
                         cod_comparto_app
                   END
                      COD_COMPARTO_HOST,
                   CASE
                      WHEN b.cod_abi_istituto || b.cod_struttura_competente
                              IS NOT NULL
                      THEN
                         cod_ramo
                      ELSE
                         cod_ramo_app
                   END
                      cod_ramo_host
              FROM st, t_mcre0_app_struttura_org b --,      -- tabella statica
             --                     t_mcre0_app_istituti c -- tabella statica
             WHERE     st.cod_abi_istituto = b.cod_abi_istituto(+) --mm sostituito st.cod_abi_cartolarizzato con istituto
                   AND st.cod_struttura_competente =
                          b.cod_struttura_competente(+) --AND c.cod_abi = st.cod_abi_cartolarizzato
                                                       ),
        macrostato
        AS (  SELECT p.cod_abi_cartolarizzato,
                     p.cod_ndg,
                     p.cod_percorso,
                     s2.cod_macrostato,
                     MIN (p.dta_decorrenza_stato) dta_decorrenza_stato
                FROM mcre_own.ttmcre0_st_percorsi p, -- leggo il file dei percorsi perché sono sul primo livello e non so a che punto sia il caricamento
                     t_mcre0_app_stati s1,                  -- tabella statica
                     t_mcre0_app_stati s2                   -- tabella statica
               WHERE     p.cod_stato_precedente = s1.cod_microstato
                     AND p.cod_stato = s2.cod_microstato
                     AND s1.cod_macrostato != s2.cod_macrostato
            GROUP BY p.cod_abi_cartolarizzato,
                     p.cod_ndg,
                     p.cod_percorso,
                     s2.cod_macrostato),
        dta_dec
        AS (SELECT *
              FROM (SELECT s.*,
                           COUNT (
                              *)
                           OVER (
                              PARTITION BY s.cod_abi_cartolarizzato,
                                           s.cod_ndg)
                              AS mycount,
                           CASE
                              WHEN     s.cod_stato = 'SO'
                                   AND m.cod_abi_cartolarizzato || m.cod_ndg
                                          IS NOT NULL
                              THEN
                                 s.dta_dec_macrostato_app
                              WHEN --(s.flg_stato_chk = 1 OR s.tip_stato = 'U')AND
                                  m.cod_abi_cartolarizzato || m.cod_ndg
                                      IS NOT NULL
                              THEN
                                 CASE
                                    WHEN     s.cod_macrostato_app =
                                                m.cod_macrostato
                                         AND s.cod_percorso_app =
                                                m.cod_percorso
                                    THEN
                                       LEAST (m.dta_decorrenza_stato,
                                              s.dta_dec_macrostato_app)
                                    ELSE
                                       m.dta_decorrenza_stato
                                 END
                              ELSE
                                 dta_dec_macrostato_app
                           END
                              dta_dec_macrostato
                      FROM s, macrostato m
                     WHERE     s.cod_abi_cartolarizzato =
                                  m.cod_abi_cartolarizzato(+)
                           AND s.cod_ndg = m.cod_ndg(+)
                           --MM140128 aggiunto condizione su percorso corrente
                           AND s.cod_percorso = m.cod_percorso(+)
                           AND s.cod_macrostato = m.cod_macrostato(+))
             WHERE mycount = 1),
        pre
        AS (SELECT s.*,
                   CASE
                      WHEN     m.cod_abi_cartolarizzato || m.cod_ndg
                                  IS NOT NULL
                           AND m.cod_processo_pre IS NOT NULL
                      THEN
                         m.cod_processo_pre
                      ELSE
                         s.cod_processo_pre_app
                   END
                      cod_processo_pre,
                   CASE
                      WHEN     m.cod_abi_cartolarizzato || m.cod_ndg
                                  IS NOT NULL
                           AND m.dta_decorrenza_stato_pre IS NOT NULL
                      THEN
                         m.dta_decorrenza_stato_pre
                      ELSE
                         s.dta_decorrenza_stato_pre_app
                   END
                      dta_decorrenza_stato_pre
              FROM dta_dec s, mcre_own.ttmcre0_st_percorsi_pre m
             WHERE     s.cod_abi_cartolarizzato = m.cod_abi_cartolarizzato(+)
                   AND s.cod_ndg = m.cod_ndg(+) -- AND s.cod_percorso_app = m.cod_percorso(+)
                                               )
   SELECT id_dper,
          cod_abi_istituto,
          cod_abi_cartolarizzato,
          cod_ndg,
          cod_sndg,
          dta_intercettamento,
          cod_filiale,
          cod_struttura_competente,
          cod_tipo_ingresso,
          cod_causale_ingresso,
          cod_percorso,
          cod_processo,
          cod_stato,
          dta_decorrenza_stato,
          dta_scadenza_stato,
          NVL (cod_stato_precedente, -1) cod_stato_precedente,
          id_stato_posizione,
          cod_cliente_esteso,
          id_cliente_esteso,
          desc_anag_gestore_mkt,
          cod_gestore_mkt,
          cod_tipo_portafoglio,
          flg_gestione_esterna,
          val_perc_decurtazione,
          cod_comparto_host,
          NVL (dta_ins_app, SYSDATE) dta_ins,
          SYSDATE dta_upd,
          NULL cod_operatore_ins_upd,
          cod_macrostato,
          dta_dec_macrostato,
          id_transizione,
          dta_processo,
          cod_processo_pre,
          cod_ramo_host,
          CASE
             WHEN cod_stato_precedente IS NOT NULL
             THEN
                dta_decorrenza_stato_pre
             ELSE
                NULL
          END
             dta_decorrenza_stato_pre,
          --flg_outsourcing,
          cod_matr_rischio,
          cod_uo_rischio,
          cod_disp_rischio
     FROM pre
   UNION
   SELECT id_dpermo id_dper,
          cod_abi_istituto,
          cod_abi_cartolarizzato,
          cod_ndg,
          cod_sndg,
          dta_intercettamento,
          cod_filiale,
          cod_struttura_competente,
          cod_tipo_ingresso,
          cod_causale_ingresso,
          cod_percorso,
          cod_processo,
          cod_stato,
          dta_decorrenza_stato,
          dta_scadenza_stato,
          NVL (cod_stato_precedente, -1) cod_stato_precedente,
          id_stato_posizione,
          cod_cliente_esteso,
          id_cliente_esteso,
          desc_anag_gestore_mkt,
          cod_gestore_mkt,
          cod_tipo_portafoglio,
          flg_gestione_esterna,
          val_perc_decurtazione,
          cod_comparto_host,
          dta_ins,
          dta_upd,
          NULL cod_operatore_ins_upd,
          cod_macrostato,
          dta_dec_macrostato,
          id_transizione,
          dta_processo,
          cod_processo_pre,
          cod_ramo_host,
          dta_decorrenza_stato_pre,
          --flg_outsourcing,
          cod_matr_rischio,
          cod_uo_rischio,
          cod_disp_rischio
     FROM mcre_own.v_mcre0_pos_mancanti;


GRANT SELECT ON MCRE_OWN.V_MCRE0_D_MOPLE TO MCRE_USR;
