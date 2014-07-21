/* Formatted on 21/07/2014 18:41:38 (QP5 v5.227.12220.39754) */
CREATE OR REPLACE FORCE VIEW MCRE_OWN.V_MCRES_APP_ALERT_SPESE
(
   ID_ALERT,
   COD_ABI,
   COD_NDG,
   COD_UO_PRATICA,
   COD_MATR_PRATICA,
   COD_AUTORIZZAZIONE,
   DTA_SPESA,
   ALERT
)
AS
   SELECT DISTINCT                            ---- 20120207 vg: nuova sp spese
          6 id_alert,
          s.cod_abi,
          s.cod_ndg,
          s.cod_uo_pratica,
          s.cod_matr_pratica,
          s.cod_autorizzazione,
          s.dta_autorizzazione dta_spesa,
          CASE
             WHEN (TRUNC (SYSDATE) - s.dta_autorizzazione) BETWEEN 0
                                                               AND g.val_current_green
             THEN
                'V'
             WHEN (TRUNC (SYSDATE) - s.dta_autorizzazione) BETWEEN   g.val_current_green
                                                                   + 1
                                                               AND g.val_current_orange
             THEN
                'A'
             WHEN (TRUNC (SYSDATE) - s.dta_autorizzazione) >
                     g.val_current_orange
             THEN
                'R'
             ELSE
                'X'
          END
             alert
     FROM v_mcres_app_sospesi s, t_mcres_app_gestione_alert g
    WHERE 0 = 0 AND g.id_alert = 6;
