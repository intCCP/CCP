/* Formatted on 17/06/2014 18:06:10 (QP5 v5.227.12220.39754) */
CREATE OR REPLACE FORCE VIEW MCRE_OWN.V_MCRE0_ST_CR_SC_SB
(
   ID_DPER,
   COD_ABI_CARTOLARIZZATO,
   DTA_CR_SCSB,
   VAL_ACC_CR_SCSB,
   VAL_GAR_CR_SCSB,
   VAL_SCO_CR_SCSB,
   VAL_UTI_CR_SCSB,
   COD_NDG
)
AS
   WITH T_MCRE0_FL_CR_SC_SB
        AS (SELECT (SELECT TO_NUMBER (
                              TO_CHAR (
                                 TO_DATE (TRIM (PERIODO_RIF), 'DDMMYYYY'),
                                 'YYYYMMDD'))
                      FROM TE_MCRE0_CSCS_IDT
                     WHERE ROWNUM = 1)
                      ID_DPER,
                   LPAD (FAJ_ABI_ELA, 5, 0) AS COD_ABI_CARTOLARIZZATO,
                   TO_DATE (FAJ_DAT_RIF_CLI, 'ddmmyyyy') AS DTA_CR_SCSB,
                   TO_NUMBER (FAJ_IMP_ACC_CLI) AS VAL_ACC_CR_SCSB,
                   TO_NUMBER (FAJ_IMP_GAR_CLI) AS VAL_GAR_CR_SCSB,
                   TO_NUMBER (FAJ_IMP_SCO_CLI) AS VAL_SCO_CR_SCSB,
                   TO_NUMBER (FAJ_IMP_UTI_CLI) AS VAL_UTI_CR_SCSB,
                   RPAD (FAJ_NDG_SET, 16, 0) AS COD_NDG
              FROM TE_MCRE0_CSCS_INC
             WHERE     FND_MCRE0_is_date (FAJ_DAT_RIF_CLI) = 1
                   AND FND_MCRE0_is_numeric (FAJ_IMP_ACC_CLI) = 1
                   AND FND_MCRE0_is_numeric (FAJ_IMP_GAR_CLI) = 1
                   AND FND_MCRE0_is_numeric (FAJ_IMP_SCO_CLI) = 1
                   AND FND_MCRE0_is_numeric (FAJ_IMP_UTI_CLI) = 1)
   SELECT "ID_DPER",
          "COD_ABI_CARTOLARIZZATO",
          "DTA_CR_SCSB",
          "VAL_ACC_CR_SCSB",
          "VAL_GAR_CR_SCSB",
          "VAL_SCO_CR_SCSB",
          "VAL_UTI_CR_SCSB",
          "COD_NDG"
     FROM (SELECT COUNT (
                     1)
                  OVER (
                     PARTITION BY ID_DPER, COD_ABI_CARTOLARIZZATO, COD_NDG)
                     NUM_RECS,
                  ID_DPER,
                  COD_ABI_CARTOLARIZZATO,
                  DTA_CR_SCSB,
                  VAL_ACC_CR_SCSB,
                  VAL_GAR_CR_SCSB,
                  VAL_SCO_CR_SCSB,
                  VAL_UTI_CR_SCSB,
                  COD_NDG
             FROM T_MCRE0_FL_CR_SC_SB) tmp
    WHERE     NUM_RECS = 1
          AND TRIM (TO_CHAR (ID_DPER)) IS NOT NULL
          AND TRIM (TO_CHAR (COD_ABI_CARTOLARIZZATO)) IS NOT NULL
          AND TRIM (TO_CHAR (COD_NDG)) IS NOT NULL;


GRANT SELECT ON MCRE_OWN.V_MCRE0_ST_CR_SC_SB TO MCRE_USR;
