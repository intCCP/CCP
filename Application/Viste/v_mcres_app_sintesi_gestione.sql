/* Formatted on 21/07/2014 18:42:58 (QP5 v5.227.12220.39754) */
CREATE OR REPLACE FORCE VIEW MCRE_OWN.V_MCRES_APP_SINTESI_GESTIONE
(
   COD_ABI,
   VAL_ANNOMESE,
   VAL_ANNO,
   COD_Q,
   FINE_NUMBER,
   COD_LABEL,
   VAL_GBV,
   VAL_NBV,
   VAL_TOT_NDG
)
AS
   SELECT E.COD_ABI,
          E.VAL_ANNOMESE,
          SUBSTR (E.VAL_ANNOMESE, 1, 4) val_anno,
          Q.COD_Q,
          SUBSTR (VAL_ANNOMESE, 1, 4) || SUBSTR (FINE_NUMBER, 5, 2)
             FINE_NUMBER,
          E.COD_LABEL,
          E.VAL_GBV,
          E.VAL_NBV,
          E.VAL_TOT_NDG
     FROM T_MCRES_FEN_SINTESI_GESTIONE E,
          (SELECT cod_q, INIZIO_NUMBER, FINE_NUMBER
             FROM V_MCRES_APP_QUARTERS
            WHERE cod_q != 5) Q
    WHERE SUBSTR (Q.FINE_NUMBER, 1, 4) || SUBSTR (E.VAL_ANNOMESE, 5, 6) BETWEEN Q.INIZIO_NUMBER
                                                                            AND Q.FINE_NUMBER;
