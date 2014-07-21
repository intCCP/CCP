/* Formatted on 17/06/2014 18:13:08 (QP5 v5.227.12220.39754) */
CREATE OR REPLACE FORCE VIEW MCRE_OWN.V_MCRES_FEN_SOFF_DA_ASS
(
   COD_ABI,
   COD_NDG,
   COD_SNDG,
   COD_UO_PRATICA,
   VAL_ANNO,
   COD_PRATICA,
   VAL_GBV,
   VAL_DUBBIO,
   FLG_RAPP_FONDO_TERZO
)
AS
     SELECT P.COD_ABI,
            P.COD_NDG,
            ' ' COD_SNDG,
            R.COD_UO_PRATICA,
            R.VAL_ANNO,
            R.COD_PRATICA,
            SUM (Z.VAL_IMP_GBV) VAL_GBV,
            ROUND (
               SUM (
                    Z.VAL_IMP_NBV
                  / DECODE (NVL (Z.VAL_IMP_GBV, 1), 0, 1, VAL_IMP_GBV)),
               2)
               VAL_DUBBIO,
            Z.FLG_RAPP_FONDO_TERZO
       FROM T_MCRES_APP_POSIZIONI P,
            T_MCRES_APP_PRATICHE R,
            T_MCRES_APP_rapporti z
      WHERE     P.COD_ABI = R.COD_ABI
            AND P.COD_NDG = R.COD_NDG
            AND P.COD_ABI = Z.COD_ABI(+)
            AND P.COD_NDG = z.COD_NDG(+)
            AND R.COD_MATR_PRATICA IS NULL
   GROUP BY P.COD_ABI,
            P.COD_NDG,
            R.COD_UO_PRATICA,
            R.VAL_ANNO,
            R.COD_PRATICA,
            FLG_RAPP_FONDO_TERZO;


GRANT DELETE, INSERT, REFERENCES, SELECT, UPDATE, ON COMMIT REFRESH, QUERY REWRITE, DEBUG, FLASHBACK, MERGE VIEW ON MCRE_OWN.V_MCRES_FEN_SOFF_DA_ASS TO MCRE_USR;
