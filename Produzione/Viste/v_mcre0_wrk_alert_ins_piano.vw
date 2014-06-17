/* Formatted on 17/06/2014 18:07:06 (QP5 v5.227.12220.39754) */
CREATE OR REPLACE FORCE VIEW MCRE_OWN.V_MCRE0_WRK_ALERT_INS_PIANO
(
   VAL_ALERT,
   DTA_INS,
   COD_ABI,
   COD_NDG,
   COD_SNDG,
   COD_STATO,
   COD_PROTOCOLLO_DELIBERA,
   VAL_CNT_RAPPORTI,
   VAL_CNT_DELIBERE
)
AS
   SELECT DISTINCT
          CASE
             WHEN     (SYSDATE - ds.min_dta) >= 15
                  AND (SYSDATE - ds.min_dta) < 30
             THEN
                'A'
             WHEN (SYSDATE - ds.min_dta) >= 30
             THEN
                'R'
          END
             AS val_alert,
          SYSDATE AS dta_ins,
          ds.cod_abi,
          ds.cod_ndg,
          ds.cod_sndg,
          ds.cod_stato,
          ds.cod_protocollo_delibera,
          COUNT (*) OVER (PARTITION BY ds.cod_abi, ds.cod_ndg)
             val_cnt_rapporti,
          1 val_cnt_delibere
     FROM (SELECT d12.cod_abi,
                  d12.cod_ndg,
                  d12.cod_sndg,
                  COD_COMPARTO,
                  d12.cod_protocollo_delibera,  -- LIVELLO 2 DELIBERE STIME DS
                  d12.cod_stato,
                  s11.cod_rapporto,
                  s11.min_dta
             FROM (SELECT d11.cod_abi,
                          d11.cod_ndg,
                          d11.cod_sndg,
                          d11.cod_protocollo_delibera,
                          d11.cod_stato,
                          COD_COMPARTO
                     -- LIVELLO 1 ULTIME DELIBERE JOIN ALL_DATA
                     FROM (SELECT d1.cod_abi,
                                  d1.cod_ndg,
                                  d1.cod_sndg,
                                  d1.cod_protocollo_delibera,
                                  ad.cod_stato,
                                  AD.COD_COMPARTO,
                                  RANK ()
                                  OVER (
                                     PARTITION BY d1.cod_abi, d1.cod_ndg
                                     ORDER BY
                                        NVL (d1.dta_conferma_delibera,
                                             d1.dta_last_upd_delibera) DESC,
                                        d1.val_anno_proposta DESC,
                                        d1.val_num_progr_delibera DESC)
                                     AS rnk_proto
                             FROM t_mcrei_app_delibere
                                  PARTITION (inc_pattive) d1,
                                  v_mcre0_app_upd_fields ad
                            WHERE     ad.cod_abi_cartolarizzato = d1.cod_abi
                                  AND ad.cod_ndg = d1.cod_ndg
                                  AND d1.cod_fase_pacchetto NOT IN
                                         ('ANM', 'ANA')
                                  --and 'CNF', 'ULT') -- ANCORA IN FAS EDI ELABORAZIONE
                                  AND (   d1.cod_fase_Delibera NOT IN
                                             ('CO', 'CA')
                                       OR (    d1.cod_fase_Delibera IN
                                                  ('CO', 'CA')
                                           AND dta_conferma_host IS NOT NULL))
                                  AND d1.cod_tipo_pacchetto <> 'A'
                                  AND AD.ID_UTENTE != -1
                                  AND d1.flg_no_delibera = 0
                                  AND d1.flg_attiva = '1'
                                  AND d1.cod_microtipologia_delib IN
                                         ('A0', 'T4', 'RV', 'IM')
                                  AND ad.today_flg = '1'
                                  AND ad.flg_active = '1'
                                  AND ad.cod_stato IN ('IN', 'RS')
                                  AND ad.flg_target = 'Y'
                                  AND ad.flg_outsourcing = 'Y') d11
                    WHERE rnk_proto = 1) d12,
                  -- LIVELLO 1 ULTIME DELIBERE JOIN ALL_DATA
                  (SELECT s1.cod_abi,
                          s1.cod_ndg,
                          s1.cod_rapporto,
                          s1.cod_protocollo_delibera,
                          MIN (dta_stima)
                             OVER (PARTITION BY s1.cod_abi, s1.cod_ndg)
                             AS min_dta
                     FROM t_mcrei_app_stime s1
                    WHERE     s1.val_esposizione > 0
                          AND s1.flg_recupero_tot = 'N'
                          AND s1.flg_tipo_dato = 'S') s11
            -- LIVELLO 1 STIME RECUPERO MIN_DTA PER OGNI POSIZIONE
            WHERE     d12.cod_abi = s11.cod_abi
                  AND d12.cod_ndg = s11.cod_ndg
                  AND d12.cod_protocollo_delibera =
                         s11.cod_protocollo_delibera) ds,
          t_mcrei_app_piani_rientro PARTITION (inc_pattive) pr
    -- LIVELLO 2 PIANI RIENTRO
    WHERE     ds.cod_abi = pr.cod_abi(+)
          AND ds.cod_ndg = pr.cod_ndg(+)
          AND ds.cod_protocollo_delibera = pr.cod_protocollo_delibera(+)
          AND ds.cod_rapporto = pr.cod_rapporto(+)
          AND pr.cod_rapporto IS NULL
          AND ds.min_dta <= SYSDATE - 15;


GRANT DELETE, INSERT, REFERENCES, SELECT, UPDATE, ON COMMIT REFRESH, QUERY REWRITE, DEBUG, FLASHBACK, MERGE VIEW ON MCRE_OWN.V_MCRE0_WRK_ALERT_INS_PIANO TO MCRE_USR;
