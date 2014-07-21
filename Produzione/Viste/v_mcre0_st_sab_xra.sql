/* Formatted on 17/06/2014 18:06:30 (QP5 v5.227.12220.39754) */
CREATE OR REPLACE FORCE VIEW MCRE_OWN.V_MCRE0_ST_SAB_XRA
(
   ID_DPER,
   COD_ABI_ISTITUTO,
   COD_ABI_CARTOLARIZZATO,
   COD_NDG,
   COD_SAB,
   FLG_SOGLIA,
   NUM_GIORNI_SCONFINO,
   COD_RAP,
   NUM_GIORNI_SCONFINO_RAP,
   VAL_IMP_SCONFINO
)
AS
   WITH T_MCRE0_FL_SAB_XRA
        AS (SELECT (SELECT TO_NUMBER (
                              TO_CHAR (
                                 TO_DATE (TRIM (PERIODO_RIF), 'DDMMYYYY'),
                                 'YYYYMMDD'))
                      FROM TE_MCRE0_XRA_IDT
                     WHERE ROWNUM = 1)
                      ID_DPER,
                   LPAD (FAF_ABI_IST, 5, 0) AS COD_ABI_ISTITUTO,
                   LPAD (FAF_ABI_ELA, 5, 0) AS COD_ABI_CARTOLARIZZATO,
                   RPAD (FAF_NDG_SET, 16, 0) AS COD_NDG,
                   TRIM (FAF_COD_SAB) AS COD_SAB,
                   TRIM (FAF_FLG_SGL) AS FLG_SOGLIA,
                   TO_NUMBER (FAF_GIO_SCF) AS NUM_GIORNI_SCONFINO,
                   TRIM (FAF_COD_RAP) AS COD_RAP,
                   TO_NUMBER (FAF_GIO_SCF_RAP) AS NUM_GIORNI_SCONFINO_RAP,
                   TO_NUMBER (FAF_IMP_SCO_NDG) AS VAL_IMP_SCONFINO
              FROM TE_MCRE0_XRA_INC
             WHERE     FND_MCRE0_is_numeric (FAF_ABI_IST) = 1
                   AND FND_MCRE0_is_numeric (FAF_ABI_ELA) = 1
                   AND FND_MCRE0_is_numeric (FAF_NDG_SET) = 1
                   AND FND_MCRE0_is_numeric (FAF_GIO_SCF) = 1
                   AND FND_MCRE0_is_numeric (FAF_GIO_SCF_RAP) = 1
                   AND FND_MCRE0_is_numeric (FAF_IMP_SCO_NDG) = 1)
   SELECT "ID_DPER",
          "COD_ABI_ISTITUTO",
          "COD_ABI_CARTOLARIZZATO",
          "COD_NDG",
          "COD_SAB",
          "FLG_SOGLIA",
          "NUM_GIORNI_SCONFINO",
          "COD_RAP",
          "NUM_GIORNI_SCONFINO_RAP",
          "VAL_IMP_SCONFINO"
     FROM (SELECT COUNT (
                     1)
                  OVER (
                     PARTITION BY ID_DPER, COD_ABI_CARTOLARIZZATO, COD_NDG)
                     NUM_RECS,
                  ID_DPER,
                  COD_ABI_ISTITUTO,
                  COD_ABI_CARTOLARIZZATO,
                  COD_NDG,
                  COD_SAB,
                  FLG_SOGLIA,
                  NUM_GIORNI_SCONFINO,
                  COD_RAP,
                  NUM_GIORNI_SCONFINO_RAP,
                  VAL_IMP_SCONFINO
             FROM T_MCRE0_FL_SAB_XRA) tmp
    WHERE     NUM_RECS = 1
          AND TRIM (TO_CHAR (ID_DPER)) IS NOT NULL
          AND TRIM (TO_CHAR (COD_ABI_CARTOLARIZZATO)) IS NOT NULL
          AND TRIM (TO_CHAR (COD_NDG)) IS NOT NULL;


GRANT SELECT ON MCRE_OWN.V_MCRE0_ST_SAB_XRA TO MCRE_USR;
