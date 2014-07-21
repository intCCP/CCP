/* Formatted on 17/06/2014 18:06:08 (QP5 v5.227.12220.39754) */
CREATE OR REPLACE FORCE VIEW MCRE_OWN.V_MCRE0_ST_CR_LG_GB
(
   ID_DPER,
   COD_SNDG_LG,
   VAL_ACC_LGGB,
   VAL_UTI_LGGB,
   VAL_SCO_LGGB,
   VAL_GAR_LGGB,
   VAL_ACC_SIS_LG,
   VAL_UTI_SIS_LG,
   VAL_SCO_SIS_LG,
   VAL_IMP_GAR_SIS_LG,
   DTA_RIFERIMENTO_CR
)
AS
   WITH T_MCRE0_FL_CR_LG_GB
        AS (SELECT (SELECT TO_NUMBER (
                              TO_CHAR (
                                 TO_DATE (TRIM (PERIODO_RIF), 'DDMMYYYY'),
                                 'YYYYMMDD'))
                      FROM TE_MCRE0_CLGG_IDT
                     WHERE ROWNUM = 1)
                      ID_DPER,
                   RPAD (FAO_NDG_CPG, 16, 0) AS COD_SNDG_LG,
                   TO_NUMBER (FAO_IMP_ACC_GBA) AS VAL_ACC_LGGB,
                   TO_NUMBER (FAO_IMP_UTI_GBA) AS VAL_UTI_LGGB,
                   TO_NUMBER (FAO_IMP_SCO_GBA) AS VAL_SCO_LGGB,
                   TO_NUMBER (FAO_IMP_GAR_GBA) AS VAL_GAR_LGGB,
                   TO_NUMBER (FAO_IMP_ACC_SIS) AS VAL_ACC_SIS_LG,
                   TO_NUMBER (FAO_IMP_UTI_SIS) AS VAL_UTI_SIS_LG,
                   TO_NUMBER (FAO_IMP_SCO_SIS) AS VAL_SCO_SIS_LG,
                   TO_NUMBER (FAO_IMP_GAR_SIS) AS VAL_IMP_GAR_SIS_LG,
                   TO_DATE (FAO_DAT_RIF, 'ddmmyyyy') AS DTA_RIFERIMENTO_CR
              FROM TE_MCRE0_CLGG_INC
             WHERE     FND_MCRE0_is_numeric (FAO_IMP_ACC_GBA) = 1
                   AND FND_MCRE0_is_numeric (FAO_IMP_UTI_GBA) = 1
                   AND FND_MCRE0_is_numeric (FAO_IMP_SCO_GBA) = 1
                   AND FND_MCRE0_is_numeric (FAO_IMP_GAR_GBA) = 1
                   AND FND_MCRE0_is_numeric (FAO_IMP_ACC_SIS) = 1
                   AND FND_MCRE0_is_numeric (FAO_IMP_UTI_SIS) = 1
                   AND FND_MCRE0_is_numeric (FAO_IMP_SCO_SIS) = 1
                   AND FND_MCRE0_is_numeric (FAO_IMP_GAR_SIS) = 1
                   AND FND_MCRE0_is_date (FAO_DAT_RIF) = 1)
   SELECT "ID_DPER",
          "COD_SNDG_LG",
          "VAL_ACC_LGGB",
          "VAL_UTI_LGGB",
          "VAL_SCO_LGGB",
          "VAL_GAR_LGGB",
          "VAL_ACC_SIS_LG",
          "VAL_UTI_SIS_LG",
          "VAL_SCO_SIS_LG",
          "VAL_IMP_GAR_SIS_LG",
          "DTA_RIFERIMENTO_CR"
     FROM (SELECT COUNT (1) OVER (PARTITION BY ID_DPER, COD_SNDG_LG) NUM_RECS,
                  ID_DPER,
                  COD_SNDG_LG,
                  VAL_ACC_LGGB,
                  VAL_UTI_LGGB,
                  VAL_SCO_LGGB,
                  VAL_GAR_LGGB,
                  VAL_ACC_SIS_LG,
                  VAL_UTI_SIS_LG,
                  VAL_SCO_SIS_LG,
                  VAL_IMP_GAR_SIS_LG,
                  DTA_RIFERIMENTO_CR
             FROM T_MCRE0_FL_CR_LG_GB) tmp
    WHERE     NUM_RECS = 1
          AND TRIM (TO_CHAR (ID_DPER)) IS NOT NULL
          AND TRIM (TO_CHAR (COD_SNDG_LG)) IS NOT NULL;


GRANT SELECT ON MCRE_OWN.V_MCRE0_ST_CR_LG_GB TO MCRE_USR;
