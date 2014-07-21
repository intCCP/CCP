/* Formatted on 21/07/2014 18:37:42 (QP5 v5.227.12220.39754) */
CREATE OR REPLACE FORCE VIEW MCRE_OWN.V_MCRE0_ST_CR_GE_SB
(
   ID_DPER,
   COD_ABI_CARTOLARIZZATO,
   DTA_CR_GESB,
   VAL_ACC_CR_GESB,
   VAL_GAR_CR_GESB,
   VAL_SCO_CR_GESB,
   VAL_UTI_CR_GESB,
   COD_SNDG_GE
)
AS
   WITH T_MCRE0_FL_CR_GE_SB
        AS (SELECT (SELECT TO_NUMBER (
                              TO_CHAR (
                                 TO_DATE (TRIM (PERIODO_RIF), 'DDMMYYYY'),
                                 'YYYYMMDD'))
                      FROM TE_MCRE0_CGES_IDT
                     WHERE ROWNUM = 1)
                      ID_DPER,
                   LPAD (FAK_ABI_ELA, 5, 0) AS COD_ABI_CARTOLARIZZATO,
                   TO_DATE (FAK_DAT_RIF_GRE, 'ddmmyyyy') AS DTA_CR_GESB,
                   TO_NUMBER (FAK_IMP_ACC_GRE) AS VAL_ACC_CR_GESB,
                   TO_NUMBER (FAK_IMP_GAR_GRE) AS VAL_GAR_CR_GESB,
                   TO_NUMBER (FAK_IMP_SCO_GRE) AS VAL_SCO_CR_GESB,
                   TO_NUMBER (FAK_IMP_UTI_GRE) AS VAL_UTI_CR_GESB,
                   RPAD (FAK_NDG_CPG, 16, 0) AS COD_SNDG_GE
              FROM TE_MCRE0_CGES_INC
             WHERE     FND_MCRE0_is_date (FAK_DAT_RIF_GRE) = 1
                   AND FND_MCRE0_is_numeric (FAK_IMP_ACC_GRE) = 1
                   AND FND_MCRE0_is_numeric (FAK_IMP_GAR_GRE) = 1
                   AND FND_MCRE0_is_numeric (FAK_IMP_SCO_GRE) = 1
                   AND FND_MCRE0_is_numeric (FAK_IMP_UTI_GRE) = 1)
   SELECT "ID_DPER",
          "COD_ABI_CARTOLARIZZATO",
          "DTA_CR_GESB",
          "VAL_ACC_CR_GESB",
          "VAL_GAR_CR_GESB",
          "VAL_SCO_CR_GESB",
          "VAL_UTI_CR_GESB",
          "COD_SNDG_GE"
     FROM (SELECT COUNT (
                     1)
                  OVER (
                     PARTITION BY ID_DPER,
                                  COD_ABI_CARTOLARIZZATO,
                                  COD_SNDG_GE)
                     NUM_RECS,
                  ID_DPER,
                  COD_ABI_CARTOLARIZZATO,
                  DTA_CR_GESB,
                  VAL_ACC_CR_GESB,
                  VAL_GAR_CR_GESB,
                  VAL_SCO_CR_GESB,
                  VAL_UTI_CR_GESB,
                  COD_SNDG_GE
             FROM T_MCRE0_FL_CR_GE_SB) tmp
    WHERE     NUM_RECS = 1
          AND TRIM (TO_CHAR (ID_DPER)) IS NOT NULL
          AND TRIM (TO_CHAR (COD_ABI_CARTOLARIZZATO)) IS NOT NULL
          AND TRIM (TO_CHAR (COD_SNDG_GE)) IS NOT NULL;
