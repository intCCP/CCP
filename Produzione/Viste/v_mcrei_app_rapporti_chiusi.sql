/* Formatted on 17/06/2014 18:08:39 (QP5 v5.227.12220.39754) */
CREATE OR REPLACE FORCE VIEW MCRE_OWN.V_MCREI_APP_RAPPORTI_CHIUSI
(
   COD_ABI,
   COD_NDG,
   COD_PROTOCOLLO_DELIBERA,
   RAPPORTO_STIME,
   RAPPORTO_PCR,
   VAL_ESPOSIZIONE,
   STIMA_RETT,
   DTA_ULTIMA_STIMA_RETT
)
AS
   SELECT s.cod_abi,
          s.cod_ndg,
          s.cod_protocollo_delibera,
          s.cod_rapporto AS rapporto_stime,
          r.cod_rapporto AS rapporto_pcr,
          s.val_esposizione,
          NVL (s.val_rdv_tot, s.val_prev_recupero) AS stima_rett,
          s.dta_stima AS dta_ultima_stima_rett
     FROM t_mcrei_app_stime s, t_mcrei_app_pcr_rapporti r
    WHERE     s.cod_abi = r.cod_abi(+)
          AND s.cod_ndg = r.cod_ndg(+)
          AND s.cod_rapporto = r.cod_rapporto(+)
          AND s.flg_attiva = '1'
          AND r.cod_rapporto IS NULL
          AND s.dta_stima =
                 (SELECT MAX (st.dta_stima)
                    FROM t_mcrei_app_stime st
                   WHERE st.cod_abi = s.cod_abi AND st.cod_ndg = s.cod_ndg);


GRANT DELETE, INSERT, REFERENCES, SELECT, UPDATE, ON COMMIT REFRESH, QUERY REWRITE, DEBUG, FLASHBACK, MERGE VIEW ON MCRE_OWN.V_MCREI_APP_RAPPORTI_CHIUSI TO MCRE_USR;
