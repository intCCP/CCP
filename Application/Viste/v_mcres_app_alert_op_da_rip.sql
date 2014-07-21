/* Formatted on 21/07/2014 18:41:28 (QP5 v5.227.12220.39754) */
CREATE OR REPLACE FORCE VIEW MCRE_OWN.V_MCRES_APP_ALERT_OP_DA_RIP
(
   ID_ALERT,
   COD_ABI,
   COD_NDG,
   COD_MATR_PRATICA,
   COD_UO_PRATICA,
   COD_OPERAZIONE,
   COD_CAUSALE_OPERAZIONE,
   DTA_CONTABILE_OPERAZIONE,
   ALERT
)
AS
   SELECT 2 id_alert,
          p.cod_abi,
          p.cod_ndg,
          p.cod_matr_pratica,
          p.cod_uo_pratica,
          o.cod_operazione,
          o.cod_causale_operazione,
          o.dta_contabile_operazione,
          --
          CASE
             WHEN (TRUNC (SYSDATE) - o.dta_contabile_operazione) BETWEEN 0
                                                                     AND g.val_current_green
             THEN
                'V'
             WHEN (TRUNC (SYSDATE) - o.dta_contabile_operazione) BETWEEN   g.val_current_green
                                                                         + 1
                                                                     AND g.val_current_orange
             THEN
                'A'
             WHEN (TRUNC (SYSDATE) - o.dta_contabile_operazione) >
                     g.val_current_orange
             THEN
                'R'
             ELSE
                'X'
          END
             alert
     --
     FROM t_mcres_app_pratiche p,
          t_mcres_app_operazioni o,
          t_mcres_app_gestione_alert g
    WHERE     0 = 0
          AND g.id_alert = 2
          AND p.flg_attiva = 1
          AND p.cod_abi = o.cod_abi
          AND p.cod_ndg = o.cod_ndg
          AND o.cod_stato_operazione IS NULL
          AND o.cod_stato_ripartizione IS NULL;
