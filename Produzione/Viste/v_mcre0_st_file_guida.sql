/* Formatted on 17/06/2014 18:06:12 (QP5 v5.227.12220.39754) */
CREATE OR REPLACE FORCE VIEW MCRE_OWN.V_MCRE0_ST_FILE_GUIDA
(
   ID_DPER,
   COD_ABI_ISTITUTO,
   COD_ABI_CARTOLARIZZATO,
   COD_NDG,
   COD_SNDG
)
AS
   WITH T_MCRE0_FL_FILE_GUIDA
        AS (SELECT (SELECT TO_NUMBER (
                              TO_CHAR (
                                 TO_DATE (TRIM (PERIODO_RIF), 'DDMMYYYY'),
                                 'YYYYMMDD'))
                      FROM TE_MCRE0_FG_IDT
                     WHERE ROWNUM = 1)
                      AS ID_DPER,
                   LPAD (FA1_ABI_IST, 5, 0) AS COD_ABI_ISTITUTO,
                   LPAD (FA1_ABI_ELA, 5, 0) AS COD_ABI_CARTOLARIZZATO,
                   RPAD (FA1_NDG_SET, 16, 0) AS COD_NDG,
                   RPAD (FA1_NDG_GRP, 16, 0) AS COD_SNDG
              FROM TE_MCRE0_FG_INC
             WHERE     FND_MCRE0_is_numeric (FA1_ABI_IST) = 1
                   AND FND_MCRE0_is_numeric (FA1_ABI_ELA) = 1
                   AND FND_MCRE0_is_numeric (FA1_NDG_SET) = 1
                   AND FND_MCRE0_is_numeric (FA1_NDG_GRP) = 1)
   SELECT "ID_DPER",
          "COD_ABI_ISTITUTO",
          "COD_ABI_CARTOLARIZZATO",
          "COD_NDG",
          "COD_SNDG"
     FROM (SELECT COUNT (
                     1)
                  OVER (
                     PARTITION BY ID_DPER, COD_ABI_CARTOLARIZZATO, COD_NDG)
                     NUM_RECS,
                  ID_DPER,
                  COD_ABI_ISTITUTO,
                  COD_ABI_CARTOLARIZZATO,
                  COD_NDG,
                  COD_SNDG
             FROM T_MCRE0_FL_FILE_GUIDA) tmp
    WHERE     NUM_RECS = 1
          AND TRIM (TO_CHAR (ID_DPER)) IS NOT NULL
          AND TRIM (TO_CHAR (COD_ABI_CARTOLARIZZATO)) IS NOT NULL
          AND TRIM (TO_CHAR (COD_NDG)) IS NOT NULL;


GRANT SELECT ON MCRE_OWN.V_MCRE0_ST_FILE_GUIDA TO MCRE_USR;
