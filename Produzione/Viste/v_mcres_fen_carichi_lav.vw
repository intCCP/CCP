/* Formatted on 17/06/2014 18:12:05 (QP5 v5.227.12220.39754) */
CREATE OR REPLACE FORCE VIEW MCRE_OWN.V_MCRES_FEN_CARICHI_LAV
(
   COD_ABI,
   COD_MATR_PRATICA,
   COD_UO_PRATICA,
   VAL_NUM_PRATICHE,
   VAL_GBV_MEDIO,
   VAL_NBV_MEDIO,
   VAL_GARANTITO_GBV
)
AS
     SELECT P.COD_ABI,
            COD_MATR_PRATICA,
            R.Cod_Uo_Pratica,
            COUNT (DISTINCT r.COD_PRATICA) val_num_pratiche,
            ROUND (SUM (Z.VAL_IMP_GBV) / COUNT (DISTINCT Z.COD_RAPPORTO), 2)
               VAL_GBV_MEDIO,
            ROUND (SUM (Z.VAL_IMP_GBV) / COUNT (DISTINCT Z.COD_RAPPORTO), 2)
               VAL_NBV_MEDIO,
            0 val_garantito_gbv
       FROM T_MCRES_APP_POSIZIONI P,
            T_MCRES_APP_PRATICHE R,
            T_MCRES_APP_rapporti z
      WHERE     P.COD_ABI = R.COD_ABI
            AND P.COD_NDG = R.COD_NDG
            AND P.COD_ABI = Z.COD_ABI(+)
            AND P.COD_NDG = Z.COD_NDG(+)
            AND R.COD_MATR_PRATICA IS NOT NULL
   GROUP BY P.COD_ABI, Cod_Matr_Pratica, R.COD_UO_PRATICA;


GRANT DELETE, INSERT, REFERENCES, SELECT, UPDATE, ON COMMIT REFRESH, QUERY REWRITE, DEBUG, FLASHBACK, MERGE VIEW ON MCRE_OWN.V_MCRES_FEN_CARICHI_LAV TO MCRE_USR;
