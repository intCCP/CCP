/* Formatted on 21/07/2014 18:37:44 (QP5 v5.227.12220.39754) */
CREATE OR REPLACE FORCE VIEW MCRE_OWN.V_MCRE0_ST_CR_SC_GB
(
   ID_DPER,
   DTA_RIFERIMENTO_CR,
   DTA_STATO_SIS,
   VAL_ACC_CR_SC,
   VAL_ACC_SIS_SC,
   VAL_GAR_CR_SC,
   VAL_GAR_SIS_SC,
   VAL_SCO_CR_SC,
   VAL_SCO_SIS_SC,
   VAL_UTI_CR_SC,
   VAL_UTI_SIS_SC,
   COD_SNDG,
   COD_STATO_SIS
)
AS
   WITH T_MCRE0_FL_CR_SC_GB
        AS (SELECT (SELECT TO_NUMBER (
                              TO_CHAR (
                                 TO_DATE (TRIM (PERIODO_RIF), 'DDMMYYYY'),
                                 'YYYYMMDD'))
                      FROM TE_MCRE0_CSCG_IDT
                     WHERE ROWNUM = 1)
                      ID_DPER,
                   TO_DATE (FAH_DAT_RIF_CR, 'ddmmyyyy') AS DTA_RIFERIMENTO_CR,
                   TO_DATE (FAH_DAT_SIS, 'ddmmyyyy') AS DTA_STATO_SIS,
                   TO_NUMBER (FAH_IMP_ACC_CLI) AS VAL_ACC_CR_SC,
                   TO_NUMBER (FAH_IMP_ACC_SIS) AS VAL_ACC_SIS_SC,
                   TO_NUMBER (FAH_IMP_GAR_CLI) AS VAL_GAR_CR_SC,
                   TO_NUMBER (FAH_IMP_GAR_SIS) AS VAL_GAR_SIS_SC,
                   TO_NUMBER (FAH_IMP_SCO_CLI) AS VAL_SCO_CR_SC,
                   TO_NUMBER (FAH_IMP_SCO_SIS) AS VAL_SCO_SIS_SC,
                   TO_NUMBER (FAH_IMP_UTI_CLI) AS VAL_UTI_CR_SC,
                   TO_NUMBER (FAH_IMP_UTI_SIS) AS VAL_UTI_SIS_SC,
                   RPAD (FAH_NDG_GRP, 16, 0) AS COD_SNDG,
                   TRIM (FAH_STA_SIS) AS COD_STATO_SIS
              FROM TE_MCRE0_CSCG_INC
             WHERE     FND_MCRE0_is_date (FAH_DAT_RIF_CR) = 1
                   AND FND_MCRE0_is_date (FAH_DAT_SIS) = 1
                   AND FND_MCRE0_is_numeric (FAH_IMP_ACC_CLI) = 1
                   AND FND_MCRE0_is_numeric (FAH_IMP_ACC_SIS) = 1
                   AND FND_MCRE0_is_numeric (FAH_IMP_GAR_CLI) = 1
                   AND FND_MCRE0_is_numeric (FAH_IMP_GAR_SIS) = 1
                   AND FND_MCRE0_is_numeric (FAH_IMP_SCO_CLI) = 1
                   AND FND_MCRE0_is_numeric (FAH_IMP_SCO_SIS) = 1
                   AND FND_MCRE0_is_numeric (FAH_IMP_UTI_CLI) = 1
                   AND FND_MCRE0_is_numeric (FAH_IMP_UTI_SIS) = 1)
   SELECT "ID_DPER",
          "DTA_RIFERIMENTO_CR",
          "DTA_STATO_SIS",
          "VAL_ACC_CR_SC",
          "VAL_ACC_SIS_SC",
          "VAL_GAR_CR_SC",
          "VAL_GAR_SIS_SC",
          "VAL_SCO_CR_SC",
          "VAL_SCO_SIS_SC",
          "VAL_UTI_CR_SC",
          "VAL_UTI_SIS_SC",
          "COD_SNDG",
          "COD_STATO_SIS"
     FROM (SELECT COUNT (1) OVER (PARTITION BY ID_DPER, COD_SNDG) NUM_RECS,
                  ID_DPER,
                  DTA_RIFERIMENTO_CR,
                  DTA_STATO_SIS,
                  VAL_ACC_CR_SC,
                  VAL_ACC_SIS_SC,
                  VAL_GAR_CR_SC,
                  VAL_GAR_SIS_SC,
                  VAL_SCO_CR_SC,
                  VAL_SCO_SIS_SC,
                  VAL_UTI_CR_SC,
                  VAL_UTI_SIS_SC,
                  COD_SNDG,
                  COD_STATO_SIS
             FROM T_MCRE0_FL_CR_SC_GB) tmp
    WHERE     NUM_RECS = 1
          AND TRIM (TO_CHAR (ID_DPER)) IS NOT NULL
          AND TRIM (TO_CHAR (COD_SNDG)) IS NOT NULL;
