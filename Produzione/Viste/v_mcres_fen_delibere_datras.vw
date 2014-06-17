/* Formatted on 17/06/2014 18:12:07 (QP5 v5.227.12220.39754) */
CREATE OR REPLACE FORCE VIEW MCRE_OWN.V_MCRES_FEN_DELIBERE_DATRAS
(
   COD_ABI,
   COD_NDG,
   COD_SNDG,
   COD_PRATICA,
   VAL_ANNO_PRATICA,
   DESC_DELIBERA,
   COD_MATR_AUTORE_DEL,
   COD_MATR_PRATICA,
   COD_UO_PRATICA,
   VAL_GBV
)
AS
     SELECT P.COD_ABI,
            P.COD_NDG,
            ' ' COD_SNDG,
            A.COD_PRATICA,
            A.VAL_ANNO VAL_ANNO_PRATICA,
            '  ' desc_delibera,
            D.COD_ORGANO_DELIBERANTE COD_MATR_AUTORE_DEL,
            A.COD_MATR_PRATICA,
            A.COD_UO_PRATICA,
            SUM (R.VAL_IMP_GBV) val_gbv
       ---- manca la condizione Ente superiore
       FROM T_MCRES_APP_POSIZIONI P,
            T_MCRES_APP_PRATICHE A,
            T_MCRES_APP_RAPPORTI R,
            T_MCRES_APP_DELIBERE D
      WHERE     P.COD_ABI = A.COD_ABI
            AND P.COD_NDG = A.COD_NDG
            AND P.COD_ABI = R.COD_ABI(+)
            AND P.COD_NDG = R.COD_NDG(+)
            AND a.COD_ABI = d.COD_ABI
            AND A.COD_NDG = D.COD_NDG
            AND A.COD_PRATICA = D.COD_DELIBERA
   GROUP BY P.COD_ABI,
            P.COD_NDG,
            A.COD_PRATICA,
            A.VAL_ANNO,
            D.COD_ORGANO_DELIBERANTE,
            A.COD_MATR_PRATICA,
            A.COD_UO_PRATICA;


GRANT DELETE, INSERT, REFERENCES, SELECT, UPDATE, ON COMMIT REFRESH, QUERY REWRITE, DEBUG, FLASHBACK, MERGE VIEW ON MCRE_OWN.V_MCRES_FEN_DELIBERE_DATRAS TO MCRE_USR;
