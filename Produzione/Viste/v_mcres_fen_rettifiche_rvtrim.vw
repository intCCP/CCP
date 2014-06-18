/* Formatted on 17/06/2014 18:12:59 (QP5 v5.227.12220.39754) */
CREATE OR REPLACE FORCE VIEW MCRE_OWN.V_MCRES_FEN_RETTIFICHE_RVTRIM
(
   COD_ABI,
   COD_NDG,
   VAL_RETTIFICA_MESE_TRIM,
   COD_DIVISIONE
)
AS
   WITH DIVISIONE
        AS (SELECT DISTINCT
                   CP.COD_ABI,
                   CP.COD_NDG,
                   CASE
                      WHEN O.COD_DIV IN ('DIVRE', 'DIVCI', 'DIVPR')
                      THEN
                         1
                      WHEN O.COD_DIV IN ('DIVCC', 'DIVLC', 'DIVFI', 'DIVES')
                      THEN
                         2
                      ELSE
                         3
                   END
                      COD_DIVISIONE
              FROM T_MCRES_APP_SISBA_CP CP,
                   V_MCRES_ULTIMA_ACQ_FILE F,
                   T_MCRE0_APP_STRUTTURA_ORG O
             WHERE     CP.COD_ABI = F.COD_ABI
                   AND CP.ID_DPER = F.ID_DPER
                   AND F.COD_FLUSSO = 'SISBA_CP'
                   AND CP.COD_ABI = O.COD_ABI_ISTITUTO
                   AND CP.COD_FILIALE = O.COD_STRUTTURA_COMPETENTE),
        EFFE_ECO
        AS (  SELECT EE.COD_ABI,
                     EE.COD_NDG,
                     SUM (EE.VAL_PER_CE + EE.VAL_RETT_SVAL + EE.VAL_RETT_ATT)
                        val_rettifica_mese_trim
                FROM T_MCRES_APP_EFFETTI_ECONOMICI EE, V_MCRES_APP_QUARTERS Q
               WHERE     Q.COD_Q = 4
                     AND EE.DTA_EFFETTI_ECONOMICI BETWEEN Q.DTA_START_Q
                                                      AND Q.DTA_END_Q
            GROUP BY ee.cod_abi, ee.cod_ndg)
   SELECT E.COD_ABI,
          E.COD_NDG,
          val_rettifica_mese_trim,
          NVL (COD_DIVISIONE, 3) COD_DIVISIONE
     FROM EFFE_ECO E, DIVISIONE D
    WHERE E.COD_ABI = D.COD_ABI(+) AND e.cod_ndg = d.cod_ndg(+);


GRANT SELECT ON MCRE_OWN.V_MCRES_FEN_RETTIFICHE_RVTRIM TO MCRE_USR;
