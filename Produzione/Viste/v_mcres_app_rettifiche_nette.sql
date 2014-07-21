/* Formatted on 17/06/2014 18:11:13 (QP5 v5.227.12220.39754) */
CREATE OR REPLACE FORCE VIEW MCRE_OWN.V_MCRES_APP_RETTIFICHE_NETTE
(
   COD_ABI,
   VAL_ANNOMESE,
   VAL_ANNO,
   COD_Q,
   COD_LABEL,
   VAL_RETTIFICA
)
AS
     SELECT COD_ABI,
            --FINE_NUMBER VAL_ANNOMESE,
            SUBSTR (VAL_ANNOMESE, 1, 4) || SUBSTR (FINE_NUMBER, 5, 2)
               VAL_ANNOMESE,
            VAL_ANNO,
            COD_Q,
            cod_label,
            SUM (VAL_RETTIFICA) VAL_RETTIFICA
       FROM (SELECT "COD_ABI",
                    E.VAL_ANNOMESE,
                    SUBSTR (E.VAL_ANNOMESE, 1, 4) val_anno,
                    Q.COD_Q,
                    Q.FINE_NUMBER,
                    cod_label,
                    "VAL_RETTIFICA"
               FROM T_MCRES_FEN_RETTIFICHE_NETTE E,
                    (SELECT cod_q, INIZIO_NUMBER, FINE_NUMBER
                       FROM V_MCRES_APP_QUARTERS
                      WHERE cod_q != 5) Q
              WHERE    SUBSTR (Q.FINE_NUMBER, 1, 4)
                    || SUBSTR (E.VAL_ANNOMESE, 5, 6) BETWEEN Q.INIZIO_NUMBER
                                                         AND Q.FINE_NUMBER)
   GROUP BY COD_ABI,
            --FINE_NUMBER,
            SUBSTR (VAL_ANNOMESE, 1, 4) || SUBSTR (FINE_NUMBER, 5, 2),
            val_anno,
            COD_Q,
            cod_label;


GRANT SELECT ON MCRE_OWN.V_MCRES_APP_RETTIFICHE_NETTE TO MCRE_USR;
