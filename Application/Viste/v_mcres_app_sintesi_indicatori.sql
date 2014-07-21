/* Formatted on 21/07/2014 18:42:58 (QP5 v5.227.12220.39754) */
CREATE OR REPLACE FORCE VIEW MCRE_OWN.V_MCRES_APP_SINTESI_INDICATORI
(
   COD_ABI,
   COD_LIVELLO,
   VAL_ANNOMESE,
   VAL_ANNO,
   COD_Q,
   FINE_NUMBER,
   COD_LABEL,
   FLG_GRUPPO,
   VAL_GBV,
   VAL_NBV
)
AS
   SELECT E.COD_ABI,
          E.COD_LIVELLO,
          E.VAL_ANNOMESE,
          SUBSTR (E.VAL_ANNOMESE, 1, 4) val_anno,
          Q.COD_Q,
          Q.FINE_NUMBER,
          E.COD_LABEL,
          E.COD_GRUPPO FLG_GRUPPO,
          E.VAL_GBV,
          E.VAL_NBV
     FROM T_MCRES_FEN_SINTESI_INDICATORI E,
          (SELECT cod_q, INIZIO_NUMBER, FINE_NUMBER
             FROM V_MCRES_APP_QUARTERS
            WHERE cod_q != 5) Q
    WHERE SUBSTR (Q.FINE_NUMBER, 1, 4) || SUBSTR (E.VAL_ANNOMESE, 5, 6) BETWEEN Q.INIZIO_NUMBER
                                                                            AND Q.FINE_NUMBER;
