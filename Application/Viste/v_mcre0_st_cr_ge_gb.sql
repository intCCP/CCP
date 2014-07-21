/* Formatted on 21/07/2014 18:37:42 (QP5 v5.227.12220.39754) */
CREATE OR REPLACE FORCE VIEW MCRE_OWN.V_MCRE0_ST_CR_GE_GB
(
   ID_DPER,
   DTA_RIFERIMENTO_CR,
   VAL_ACC_CR_GE,
   VAL_ACC_SIS_GE,
   VAL_GAR_CR_GE,
   VAL_GAR_SIS_GE,
   VAL_SCO_CR_GE,
   VAL_SCO_SIS_GE,
   VAL_UTI_CR_GE,
   VAL_UTI_SIS_GE,
   COD_SNDG_GE
)
AS
   WITH T_MCRE0_FL_CR_GE_GB
        AS (SELECT (SELECT TO_NUMBER (
                              TO_CHAR (
                                 TO_DATE (TRIM (PERIODO_RIF), 'DDMMYYYY'),
                                 'YYYYMMDD'))
                      FROM TE_MCRE0_CGEG_IDT
                     WHERE ROWNUM = 1)
                      ID_DPER,
                   TO_DATE (FAI_DAT_RIF_CR, 'ddmmyyyy') AS DTA_RIFERIMENTO_CR,
                   TO_NUMBER (FAI_IMP_ACC_GRE) AS VAL_ACC_CR_GE,
                   TO_NUMBER (FAI_IMP_ACC_SIS) AS VAL_ACC_SIS_GE,
                   TO_NUMBER (FAI_IMP_GAR_GRE) AS VAL_GAR_CR_GE,
                   TO_NUMBER (FAI_IMP_GAR_SIS) AS VAL_GAR_SIS_GE,
                   TO_NUMBER (FAI_IMP_SCO_GRE) AS VAL_SCO_CR_GE,
                   TO_NUMBER (FAI_IMP_SCO_SIS) AS VAL_SCO_SIS_GE,
                   TO_NUMBER (FAI_IMP_UTI_GRE) AS VAL_UTI_CR_GE,
                   TO_NUMBER (FAI_IMP_UTI_SIS) AS VAL_UTI_SIS_GE,
                   RPAD (FAI_NDG_CPG, 16, 0) AS COD_SNDG_GE
              FROM TE_MCRE0_CGEG_INC
             WHERE     FND_MCRE0_is_date (FAI_DAT_RIF_CR) = 1
                   AND FND_MCRE0_is_numeric (FAI_IMP_ACC_GRE) = 1
                   AND FND_MCRE0_is_numeric (FAI_IMP_ACC_SIS) = 1
                   AND FND_MCRE0_is_numeric (FAI_IMP_GAR_GRE) = 1
                   AND FND_MCRE0_is_numeric (FAI_IMP_GAR_SIS) = 1
                   AND FND_MCRE0_is_numeric (FAI_IMP_SCO_GRE) = 1
                   AND FND_MCRE0_is_numeric (FAI_IMP_SCO_SIS) = 1
                   AND FND_MCRE0_is_numeric (FAI_IMP_UTI_GRE) = 1
                   AND FND_MCRE0_is_numeric (FAI_IMP_UTI_SIS) = 1)
   SELECT "ID_DPER",
          "DTA_RIFERIMENTO_CR",
          "VAL_ACC_CR_GE",
          "VAL_ACC_SIS_GE",
          "VAL_GAR_CR_GE",
          "VAL_GAR_SIS_GE",
          "VAL_SCO_CR_GE",
          "VAL_SCO_SIS_GE",
          "VAL_UTI_CR_GE",
          "VAL_UTI_SIS_GE",
          "COD_SNDG_GE"
     FROM (SELECT COUNT (1) OVER (PARTITION BY ID_DPER, COD_SNDG_GE) NUM_RECS,
                  ID_DPER,
                  DTA_RIFERIMENTO_CR,
                  VAL_ACC_CR_GE,
                  VAL_ACC_SIS_GE,
                  VAL_GAR_CR_GE,
                  VAL_GAR_SIS_GE,
                  VAL_SCO_CR_GE,
                  VAL_SCO_SIS_GE,
                  VAL_UTI_CR_GE,
                  VAL_UTI_SIS_GE,
                  COD_SNDG_GE
             FROM T_MCRE0_FL_CR_GE_GB) tmp
    WHERE     NUM_RECS = 1
          AND TRIM (TO_CHAR (ID_DPER)) IS NOT NULL
          AND TRIM (TO_CHAR (COD_SNDG_GE)) IS NOT NULL;
