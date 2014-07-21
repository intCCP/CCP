/* Formatted on 21/07/2014 18:37:59 (QP5 v5.227.12220.39754) */
CREATE OR REPLACE FORCE VIEW MCRE_OWN.V_MCRE0_ST_SAG
(
   ID_DPER,
   COD_SNDG,
   COD_SAG,
   DTA_CALCOLO_SAG,
   FLG_ALLINEAMENTO,
   FLG_CONFERMA,
   DTA_CONFERMA
)
AS
   WITH T_MCRE0_FL_SAG
        AS (SELECT (SELECT TO_NUMBER (
                              TO_CHAR (
                                 TO_DATE (TRIM (PERIODO_RIF), 'DDMMYYYY'),
                                 'YYYYMMDD'))
                      FROM TE_MCRE0_SAG_IDT
                     WHERE ROWNUM = 1)
                      ID_DPER,
                   RPAD (FAE_NDG_GRP, 16, 0) AS COD_SNDG,
                   TRIM (FAE_COD_SAG) AS COD_SAG,
                   TO_DATE (FAE_DAT_SAG, 'ddmmyyyy') AS DTA_CALCOLO_SAG,
                   TRIM (FAE_FLG_ALL) AS FLG_ALLINEAMENTO,
                   TRIM (FAE_FLG_CNF) AS FLG_CONFERMA,
                   TO_DATE (FAE_DAT_CNF, 'ddmmyyyy') AS DTA_CONFERMA
              FROM TE_MCRE0_SAG_INC
             WHERE     FND_MCRE0_is_numeric (FAE_NDG_GRP) = 1
                   AND FND_MCRE0_is_date (FAE_DAT_SAG) = 1
                   AND FND_MCRE0_is_date (FAE_DAT_CNF) = 1)
   SELECT "ID_DPER",
          "COD_SNDG",
          "COD_SAG",
          "DTA_CALCOLO_SAG",
          "FLG_ALLINEAMENTO",
          "FLG_CONFERMA",
          "DTA_CONFERMA"
     FROM (SELECT COUNT (1) OVER (PARTITION BY ID_DPER, COD_SNDG) NUM_RECS,
                  ID_DPER,
                  COD_SNDG,
                  COD_SAG,
                  DTA_CALCOLO_SAG,
                  FLG_ALLINEAMENTO,
                  FLG_CONFERMA,
                  DTA_CONFERMA
             FROM T_MCRE0_FL_SAG) tmp
    WHERE     NUM_RECS = 1
          AND TRIM (TO_CHAR (ID_DPER)) IS NOT NULL
          AND TRIM (TO_CHAR (COD_SNDG)) IS NOT NULL;
