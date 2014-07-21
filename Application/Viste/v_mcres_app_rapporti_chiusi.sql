/* Formatted on 21/07/2014 18:42:43 (QP5 v5.227.12220.39754) */
CREATE OR REPLACE FORCE VIEW MCRE_OWN.V_MCRES_APP_RAPPORTI_CHIUSI
(
   COD_ABI,
   COD_NDG,
   COD_PROTOCOLLO_DELIBERA,
   COD_RAPPORTO,
   VAL_ESPOSIZIONE,
   VAL_STIMA_RETT,
   DTA_ULTIMA_STIMA_RETT,
   DESC_CAUSA_PREV_RECUPERO,
   FLG_PRES_PIANO,
   DTA_CHIUSURA_RAPP
)
AS
   SELECT                                          -- 20130117 Andrea Galliano
         r.cod_abi,
          r.cod_ndg,
          s.cod_protocollo_delibera,
          r.cod_rapporto,
          s.val_esposizione,
          NVL (s.val_rdv_tot, s.val_prev_recupero) val_stima_rett,
          s.dta_stima dta_ultima_stima_rett,
          s.desc_causa_prev_recupero,
          s.flg_pres_piano,
          r.dta_chiusura_rapp
     FROM t_mcres_app_rapporti r,
          (SELECT ROW_NUMBER ()
                  OVER (PARTITION BY t.cod_abi, t.cod_ndg, t.cod_rapporto
                        ORDER BY t.dta_stima DESC NULLS LAST)
                     rn,
                  t.*
             FROM (SELECT cod_abi,
                          cod_ndg,
                          cod_protocollo_delibera,
                          cod_rapporto,
                          val_esposizione,
                          val_rdv_tot,
                          val_prev_recupero,
                          dta_stima,
                          desc_causa_prev_recupero,
                          flg_pres_piano
                     FROM t_mcrei_app_stime
                   UNION ALL
                   SELECT cod_abi,
                          cod_ndg,
                          cod_protocollo_delibera,
                          cod_rapporto,
                          val_esposizione,
                          val_rdv_tot,
                          val_prev_recupero,
                          dta_stima,
                          desc_causa_prev_recupero,
                          flg_pres_piano
                     FROM t_mcrei_app_stime_extra
                   UNION ALL
                   SELECT cod_abi,
                          cod_ndg,
                          cod_protocollo_delibera,
                          cod_rapporto,
                          val_esposizione,
                          val_rdv_tot,
                          val_prev_recupero,
                          dta_stima,
                          desc_causa_prev_recupero,
                          flg_pres_piano
                     FROM t_mcrei_app_stime_batch) t) s
    WHERE     0 = 0
          AND r.cod_abi = s.cod_abi(+)
          AND r.cod_ndg = s.cod_ndg(+)
          AND r.cod_rapporto = s.cod_rapporto(+)
          AND r.dta_chiusura_rapp <= SYSDATE
          AND s.rn(+) = 1   --ultima stima in ordine cronologico sul rapporto
;
