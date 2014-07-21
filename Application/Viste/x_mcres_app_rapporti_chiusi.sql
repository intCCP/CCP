/* Formatted on 21/07/2014 18:46:59 (QP5 v5.227.12220.39754) */
CREATE OR REPLACE FORCE VIEW MCRE_OWN.X_MCRES_APP_RAPPORTI_CHIUSI
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
   SELECT s.cod_abi,
          s.cod_ndg,
          s.cod_protocollo_delibera,
          s.cod_rapporto,
          s.val_esposizione,
          NVL (s.val_rdv_tot, s.val_prev_recupero) AS val_stima_rett,
          s.dta_stima AS dta_ultima_stima_rett,
          S.DESC_CAUSA_PREV_RECUPERO,
          S.FLG_PRES_PIANO,
          r.dta_chiusura_rapp
     FROM t_mcrei_app_stime s, t_mcres_app_rapporti r
    WHERE     s.cod_abi = r.cod_abi
          AND s.cod_ndg = r.cod_ndg
          AND s.cod_rapporto = r.cod_rapporto
          AND s.flg_attiva = '1'
          AND r.dta_chiusura_rapp < SYSDATE
          AND s.dta_stima =
                 (SELECT MAX (st.dta_stima)
                    FROM t_mcrei_app_stime st
                   WHERE st.cod_abi = s.cod_abi AND st.cod_ndg = s.cod_ndg);
