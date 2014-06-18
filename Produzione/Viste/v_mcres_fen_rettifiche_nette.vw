/* Formatted on 17/06/2014 18:12:56 (QP5 v5.227.12220.39754) */
CREATE OR REPLACE FORCE VIEW MCRE_OWN.V_MCRES_FEN_RETTIFICHE_NETTE
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
                  WHEN (  SELECT MAX (
                                    SUBSTR (
                                       TO_CHAR (A.DTA_DECORRENZA_STATO,
                                                'YYYYMMDD'),
                                       1,
                                       4))
                            FROM t_mcres_app_sisba_cp a
                           WHERE     a.id_dper IN
                                        (ee.id_dper,
                                         TO_CHAR (
                                            ADD_MONTHS (
                                               TO_DATE (ee.id_dper, 'YYYYMMDD'),
                                               -1),
                                            'YYYYMMDD'))
                                 AND a.cod_abi = ee.cod_abi
                                 AND a.cod_ndg = ee.cod_ndg
                                 AND A.COD_STATO_RISCHIO = 'S'
                        GROUP BY a.cod_abi, a.cod_ndg) =
                          SUBSTR (ee.id_dper, 1, 4)
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
       FROM t_mcres_app_effetti_economici ee
   GROUP BY ee.cod_abi, ee.id_dper;


GRANT DELETE, INSERT, REFERENCES, SELECT, UPDATE, ON COMMIT REFRESH, QUERY REWRITE, DEBUG, FLASHBACK, MERGE VIEW ON MCRE_OWN.V_MCRES_FEN_RETTIFICHE_NETTE TO MCRE_USR;
