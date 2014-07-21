/* Formatted on 21/07/2014 18:44:15 (QP5 v5.227.12220.39754) */
CREATE OR REPLACE FORCE VIEW MCRE_OWN.V_MCRES_FEN_RETTIFICHE_NETTE_1
(
   COD_ABI,
   ID_DPER,
   VAL_RETTIFICA_NUOVI_INGRESSI,
   VAL_RETTIFICA_STOCK
)
AS
     SELECT                     --AG: 16/12/2011 (Nuova fromula e uso id_dper)
           ee.cod_abi,
            ee.id_dper,
            SUM (
               CASE
                  WHEN TO_NUMBER (
                          TO_CHAR (LAST_DAY (p.dta_passaggio_soff), 'YYYYMMDD')) =
                          ee.id_dper
                  THEN
                       (ee.val_per_ce + ee.val_rett_sval + ee.val_rett_att)
                     - (  ee.val_rip_mora
                        + ee.val_quota_sval
                        + ee.val_quota_att
                        + ee.val_rip_sval
                        + ee.val_rip_att
                        + ee.val_attualizzazione)
                  ELSE
                     0
               END)
               val_rettifica_nuovi_ingressi,
            SUM (
                 (ee.val_per_ce + ee.val_rett_sval + ee.val_rett_att)
               - (  ee.val_rip_mora
                  + ee.val_quota_sval
                  + ee.val_quota_att
                  + ee.val_rip_sval
                  + ee.val_rip_att
                  + ee.val_attualizzazione))
               val_rettifica_stock
       FROM t_mcres_app_effetti_economici ee, t_mcres_app_posizioni p
      WHERE ee.cod_abi = p.cod_abi AND ee.cod_ndg = p.cod_ndg
   GROUP BY ee.cod_abi, ee.id_dper;
