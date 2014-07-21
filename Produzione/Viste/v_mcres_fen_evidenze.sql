/* Formatted on 17/06/2014 18:12:09 (QP5 v5.227.12220.39754) */
CREATE OR REPLACE FORCE VIEW MCRE_OWN.V_MCRES_FEN_EVIDENZE
(
   COD_ABI,
   COD_NDG,
   COD_SNDG,
   COD_UO_PRATICA,
   COD_MATR_PRATICA,
   COD_LABEL
)
AS
   SELECT                                  -- AG 20120911 Fixed alias cod_sndg
         DISTINCT r.COD_ABI,
                  r.COD_NDG,
                  r.cod_sndg,
                  COD_UO_PRATICA,
                  COD_MATR_PRATICA,
                  1 COD_LABEL
     FROM T_MCRES_APP_RAPPORTI R,
          t_mcres_app_pratiche p,
          T_MCRES_APP_POSIZIONI N
    WHERE     p.flg_attiva = 1
          AND N.FLG_ATTIVA = 1
          AND r.dta_nbv IS NULL
          AND r.val_imp_nbv != 0
          AND R.COD_ABI = P.COD_ABI
          AND r.cod_ndg = p.cod_ndg
          AND R.COD_ABI = n.COD_ABI
          AND r.cod_ndg = n.cod_ndg
          AND n.cod_stato_rischio = 'S'
   UNION ALL
   SELECT p.COD_ABI,
          p.COD_NDG,
          n.cod_sndg,
          COD_UO_PRATICA,
          COD_MATR_PRATICA,
          2 cod_label
     FROM T_MCRES_APP_PRATICHE P, T_MCRES_APP_POSIZIONI N
    WHERE     P.FLG_ATTIVA = 1
          AND n.flg_attiva = 1
          AND P.DTA_ASSEGN_ADDET >= TRUNC (SYSDATE) - 30
          AND p.COD_ABI = N.COD_ABI
          AND p.cod_ndg = n.cod_ndg
          AND n.cod_stato_rischio = 'S'
   UNION ALL
   SELECT P.COD_ABI,
          p.COD_NDG,
          p.cod_sndg,
          COD_UO_PRATICA,
          COD_MATR_PRATICA,
          DECODE (P.FLG_CONFERIMENTO, 'A', 3, 4) COD_LABEL
     FROM T_MCRES_APP_PRATICHE r, T_MCRES_APP_POSIZIONI P
    WHERE     P.FLG_ATTIVA = 1
          AND R.FLG_ATTIVA = 1
          AND P.COD_ABI = R.COD_ABI
          AND p.cod_abi = r.cod_ndg
          AND p.cod_stato_rischio = 'S'
          AND DTA_CONFERIMENTO >= TRUNC (SYSDATE) - 30
   UNION ALL
   SELECT p.COD_ABI,
          p.COD_NDG,
          n.cod_sndg,
          COD_UO_PRATICA,
          COD_MATR_PRATICA,
          5 cod_label
     FROM T_MCRES_APP_PRATICHE P, T_MCRES_APP_POSIZIONI N
    WHERE     P.FLG_ATTIVA = 1
          AND N.FLG_ATTIVA = 1
          AND P.DTA_ASSEGN_ADDET < TRUNC (SYSDATE) - 30
          AND P.COD_ABI = N.COD_ABI
          AND p.cod_ndg = n.cod_ndg
          AND n.cod_stato_rischio = 'S'
          AND NOT EXISTS
                     (SELECT DISTINCT 1
                        FROM T_MCRES_APP_DELIBERE D
                       WHERE     D.COD_ABI = P.COD_ABI
                             AND d.cod_ndg = p.cod_ndg
                             AND d.cod_delibera IN ('NS', 'NZ', 'IS'));


GRANT DELETE, INSERT, REFERENCES, SELECT, UPDATE, ON COMMIT REFRESH, QUERY REWRITE, DEBUG, FLASHBACK, MERGE VIEW ON MCRE_OWN.V_MCRES_FEN_EVIDENZE TO MCRE_USR;
