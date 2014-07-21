/* Formatted on 21/07/2014 18:38:41 (QP5 v5.227.12220.39754) */
CREATE OR REPLACE FORCE VIEW MCRE_OWN.V_MCRE0_WRK_ALERT_RAPP_DA_VALX
(
   COD_ABI,
   COD_NDG,
   COD_SNDG,
   COD_STATO,
   VAL_ALERT,
   VAL_CNT_DELIBERE,
   VAL_CNT_RAPPORTI,
   DTA_INS
)
AS
   SELECT                                             -- modificata 02.10.2012
         DISTINCT cod_abi,
                  cod_ndg,
                  cod_sndg,
                  cod_stato,
                  'R' val_alert,
                  val_cnt_delibere,
                  val_cnt_rapporti,
                  SYSDATE dta_ins
     FROM (SELECT ppcr.cod_abi,                                           --53
                  ppcr.cod_ndg,
                  ppcr.cod_sndg,
                  ppcr.cod_rapporto AS rapp_pcr,
                  s.cod_rapporto AS rapp_stime,
                  ad.cod_stato,
                  1 AS val_cnt_delibere,
                  COUNT (*) OVER (PARTITION BY ppcr.cod_abi, ppcr.cod_ndg)
                     AS val_cnt_rapporti,
                  s.cod_protocollo_delibera
             FROM (SELECT DISTINCT
                          cod_abi,
                          cod_ndg,
                          cod_sndg,
                          cod_rapporto,
                          SUM (val_imp_utilizzato)
                          OVER (PARTITION BY cod_abi, cod_ndg, cod_rapporto)
                             val_imp_utilizzato
                     FROM t_mcrei_app_pcr_rapporti) ppcr,
                  (SELECT DISTINCT s1.cod_abi,
                                   s1.cod_ndg,
                                   s1.cod_sndg,
                                   s1.cod_rapporto,
                                   s1.cod_protocollo_delibera
                     FROM (SELECT cod_abi,
                                  cod_ndg,
                                  cod_rapporto,
                                  cod_protocollo_delibera,
                                  MAX (dta_stima)
                                  OVER (PARTITION BY s2.cod_abi, s2.cod_ndg)
                                     AS max_dta
                             FROM t_mcrei_app_stime
                                  PARTITION (inc_pattive) s2) s_max,
                          t_mcrei_app_stime s1
                    WHERE     s_max.cod_abi = s1.cod_abi
                          AND s_max.cod_ndg = s1.cod_ndg
                          AND s_max.cod_rapporto = s1.cod_rapporto
                          AND s_max.max_dta = s1.dta_stima) s,
                  (SELECT DISTINCT cod_abi, cod_ndg
                     FROM t_mcrei_app_delibere PARTITION (inc_pattive) p
                    WHERE     p.cod_fase_delibera = 'CO'
                          AND p.flg_no_delibera = 0
                          AND p.cod_microtipologia_delib IN
                                 ('A0', 'T4', 'RV')) p,
                  t_mcrei_app_rapporti_estero e,
                  v_mcre0_app_upd_fields ad
            WHERE     ppcr.cod_abi = s.cod_abi(+)
                  AND ppcr.cod_ndg = s.cod_ndg(+)
                  AND ppcr.cod_rapporto = s.cod_rapporto(+)
                  AND s.cod_rapporto IS NULL            --rapporto non stimato
                  AND ppcr.cod_abi = ad.cod_abi_cartolarizzato
                  AND ppcr.cod_ndg = ad.cod_ndg
                  AND ad.flg_outsourcing = 'Y'
                  AND ad.flg_target = 'Y'
                  AND ad.cod_stato IN ('IN', 'RS')
                  AND ppcr.cod_abi = p.cod_abi
                  --posizioni con delibere di rettifica
                  AND ppcr.cod_ndg = p.cod_ndg
                  AND ppcr.val_imp_utilizzato > 0        -- 6 con utilizzato 0
                  AND ppcr.cod_abi = e.cod_abi(+)
                  AND ppcr.cod_ndg = e.cod_ndg(+)
                  AND ppcr.cod_rapporto = e.cod_rapporto_estero(+)
                  AND e.cod_rapporto_estero IS NULL);
