/* Formatted on 21/07/2014 18:37:49 (QP5 v5.227.12220.39754) */
CREATE OR REPLACE FORCE VIEW MCRE_OWN.V_MCRE0_ST_LEGAME
(
   ID_DPER,
   COD_SNDG,
   COD_SNDG_LEGAME,
   COD_LEGAME
)
AS
   WITH T_MCRE0_FL_LEGAME
        AS (SELECT (SELECT TO_NUMBER (
                              TO_CHAR (
                                 TO_DATE (TRIM (PERIODO_RIF), 'DDMMYYYY'),
                                 'YYYYMMDD'))
                      FROM TE_MCRE0_LEG_IDT
                     WHERE ROWNUM = 1)
                      ID_DPER,
                   RPAD (FA2_NDG_GRP, 16, 0) AS COD_SNDG,
                   RPAD (FA2_NDG_GRP_LEG, 16, 0) AS COD_SNDG_LEGAME,
                   TRIM (FA2_COD_LEG) AS COD_LEGAME
              FROM TE_MCRE0_LEG_INC
             WHERE     FND_MCRE0_is_numeric (FA2_NDG_GRP) = 1
                   AND FND_MCRE0_is_numeric (FA2_NDG_GRP_LEG) = 1)
   SELECT "ID_DPER",
          "COD_SNDG",
          "COD_SNDG_LEGAME",
          "COD_LEGAME"
     FROM (SELECT COUNT (
                     1)
                  OVER (
                     PARTITION BY ID_DPER,
                                  COD_SNDG,
                                  COD_SNDG_LEGAME,
                                  COD_LEGAME)
                     NUM_RECS,
                  ID_DPER,
                  COD_SNDG,
                  COD_SNDG_LEGAME,
                  COD_LEGAME
             FROM T_MCRE0_FL_LEGAME) tmp
    WHERE     NUM_RECS = 1
          AND TRIM (TO_CHAR (ID_DPER)) IS NOT NULL
          AND TRIM (TO_CHAR (COD_SNDG)) IS NOT NULL
          AND TRIM (TO_CHAR (COD_SNDG_LEGAME)) IS NOT NULL
          AND TRIM (TO_CHAR (COD_LEGAME)) IS NOT NULL;
