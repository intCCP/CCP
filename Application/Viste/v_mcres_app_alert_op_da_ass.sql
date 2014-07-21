/* Formatted on 21/07/2014 18:41:28 (QP5 v5.227.12220.39754) */
CREATE OR REPLACE FORCE VIEW MCRE_OWN.V_MCRES_APP_ALERT_OP_DA_ASS
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
   SELECT 1 id_alert,
          p.cod_abi,
          p.cod_ndg,
          p.cod_matr_pratica,
          p.cod_uo_pratica,
          o.cod_operazione,
          o.cod_causale_operazione,
          dta_contabile_operazione,
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
                NULL
          END
             alert
     FROM t_mcres_app_pratiche p,
          t_mcres_app_posizioni z,
          t_mcres_app_operazioni o,
          t_mcres_app_gestione_alert g
    WHERE     0 = 0
          AND g.id_alert = 1
          AND p.flg_attiva = 1
          AND z.flg_attiva = 1
          AND p.cod_abi = z.cod_abi
          AND p.cod_ndg = z.cod_ndg
          AND p.cod_abi = o.cod_abi
          AND p.cod_ndg = o.cod_ndg
          AND p.cod_matr_pratica IS NOT NULL
          AND o.cod_stato_operazione IS NULL
          AND o.cod_stato_ripartizione = 'CO'
          AND o.val_importo_operazione >= 0
          AND o.cod_rapporto <> '99999999999999999'
          AND o.dta_contabile_operazione >
                 TO_DATE ('01/01/2006', 'dd/mm/yyyy')
          AND o.dta_contabile_operazione >= z.dta_passaggio_soff
          AND (   o.cod_operazione_fattibile = 'RATIN'
               OR o.cod_causale_operazione <> '068');
