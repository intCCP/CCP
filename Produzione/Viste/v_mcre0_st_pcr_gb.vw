/* Formatted on 17/06/2014 18:06:19 (QP5 v5.227.12220.39754) */
CREATE OR REPLACE FORCE VIEW MCRE_OWN.V_MCRE0_ST_PCR_GB
(
   ID_DPER,
   COD_SNDG,
   COD_FORMA_TECNICA,
   VAL_IMP_UTI_CLI,
   VAL_IMP_ACC_CLI,
   VAL_IMP_UTI_GRE,
   VAL_IMP_ACC_GRE,
   VAL_IMP_UTI_LEG,
   VAL_IMP_ACC_LEG,
   COD_NATURA,
   DTA_RIFERIMENTO,
   MAU_GRP,
   MAU_CLI,
   VAL_IMP_GAR_CLI,
   DTA_SCADENZA_LDC_CLI,
   VAL_IMP_GAR_GRE,
   DTA_SCADENZA_LDC_GRE,
   VAL_IMP_GAR_LEG,
   DTA_SCADENZA_LDC_LEG,
   MAU_LEG
)
AS
   WITH T_MCRE0_FL_PCR_GB
        AS (SELECT (SELECT TO_NUMBER (
                              TO_CHAR (
                                 TO_DATE (TRIM (PERIODO_RIF), 'DDMMYYYY'),
                                 'YYYYMMDD'))
                      FROM TE_MCRE0_PGB_IDT
                     WHERE ROWNUM = 1)
                      ID_DPER,
                   RPAD (FAB_NDG_GRP, 16, 0) AS COD_SNDG,
                   TRIM (FAB_COD_FTE) AS COD_FORMA_TECNICA,
                   TO_NUMBER (FAB_IMP_UTI_CLI) AS VAL_IMP_UTI_CLI,
                   TO_NUMBER (FAB_IMP_ACC_CLI) AS VAL_IMP_ACC_CLI,
                   TO_NUMBER (FAB_IMP_UTI_GRE) AS VAL_IMP_UTI_GRE,
                   TO_NUMBER (FAB_IMP_ACC_GRE) AS VAL_IMP_ACC_GRE,
                   TO_NUMBER (FAB_IMP_UTI_LEG) AS VAL_IMP_UTI_LEG,
                   TO_NUMBER (FAB_IMP_ACC_LEG) AS VAL_IMP_ACC_LEG,
                   TRIM (FAB_COD_NAT) AS COD_NATURA,
                   TO_DATE (FAB_DAT_RIF, 'DDMMYYYY') AS DTA_RIFERIMENTO,
                   TO_NUMBER (FAB_MAU_GRP) AS MAU_GRP,
                   TO_NUMBER (FAB_MAU_CLI) AS MAU_CLI,
                   TO_NUMBER (FAB_IMP_GAR_CLI) AS VAL_IMP_GAR_CLI,
                   TO_DATE (FAB_DAT_LDC_CLI, 'DDMMYYYY')
                      AS DTA_SCADENZA_LDC_CLI,
                   TO_NUMBER (FAB_IMP_GAR_GRE) AS VAL_IMP_GAR_GRE,
                   TO_DATE (FAB_DAT_LDC_GRE, 'DDMMYYYY')
                      AS DTA_SCADENZA_LDC_GRE,
                   TO_NUMBER (FAB_IMP_GAR_LEG) AS VAL_IMP_GAR_LEG,
                   TO_DATE (FAB_DAT_LDC_LEG, 'DDMMYYYY')
                      AS DTA_SCADENZA_LDC_LEG,
                   TO_NUMBER (FAB_MAU_LEG) AS MAU_LEG
              FROM TE_MCRE0_PGB_INC
             WHERE     FND_MCRE0_is_numeric (FAB_IMP_UTI_CLI) = 1
                   AND FND_MCRE0_is_numeric (FAB_IMP_ACC_CLI) = 1
                   AND FND_MCRE0_is_numeric (FAB_IMP_UTI_GRE) = 1
                   AND FND_MCRE0_is_numeric (FAB_IMP_ACC_GRE) = 1
                   AND FND_MCRE0_is_numeric (FAB_IMP_UTI_LEG) = 1
                   AND FND_MCRE0_is_numeric (FAB_IMP_ACC_LEG) = 1
                   AND FND_MCRE0_is_date (FAB_DAT_RIF) = 1
                   AND FND_MCRE0_is_numeric (FAB_MAU_GRP) = 1
                   AND FND_MCRE0_is_numeric (FAB_MAU_CLI) = 1
                   AND FND_MCRE0_is_numeric (FAB_IMP_GAR_CLI) = 1
                   AND FND_MCRE0_is_date (FAB_DAT_LDC_CLI) = 1
                   AND FND_MCRE0_is_numeric (FAB_IMP_GAR_GRE) = 1
                   AND FND_MCRE0_is_date (FAB_DAT_LDC_GRE) = 1
                   AND FND_MCRE0_is_numeric (FAB_IMP_GAR_LEG) = 1
                   AND FND_MCRE0_is_date (FAB_DAT_LDC_LEG) = 1
                   AND FND_MCRE0_is_numeric (FAB_MAU_LEG) = 1)
   SELECT "ID_DPER",
          "COD_SNDG",
          "COD_FORMA_TECNICA",
          "VAL_IMP_UTI_CLI",
          "VAL_IMP_ACC_CLI",
          "VAL_IMP_UTI_GRE",
          "VAL_IMP_ACC_GRE",
          "VAL_IMP_UTI_LEG",
          "VAL_IMP_ACC_LEG",
          "COD_NATURA",
          "DTA_RIFERIMENTO",
          "MAU_GRP",
          "MAU_CLI",
          "VAL_IMP_GAR_CLI",
          "DTA_SCADENZA_LDC_CLI",
          "VAL_IMP_GAR_GRE",
          "DTA_SCADENZA_LDC_GRE",
          "VAL_IMP_GAR_LEG",
          "DTA_SCADENZA_LDC_LEG",
          "MAU_LEG"
     FROM (SELECT COUNT (1)
                     OVER (PARTITION BY ID_DPER, COD_SNDG, COD_FORMA_TECNICA)
                     NUM_RECS,
                  ID_DPER,
                  COD_SNDG,
                  COD_FORMA_TECNICA,
                  VAL_IMP_UTI_CLI,
                  VAL_IMP_ACC_CLI,
                  VAL_IMP_UTI_GRE,
                  VAL_IMP_ACC_GRE,
                  VAL_IMP_UTI_LEG,
                  VAL_IMP_ACC_LEG,
                  COD_NATURA,
                  DTA_RIFERIMENTO,
                  MAU_GRP,
                  MAU_CLI,
                  VAL_IMP_GAR_CLI,
                  DTA_SCADENZA_LDC_CLI,
                  VAL_IMP_GAR_GRE,
                  DTA_SCADENZA_LDC_GRE,
                  VAL_IMP_GAR_LEG,
                  DTA_SCADENZA_LDC_LEG,
                  MAU_LEG
             FROM T_MCRE0_FL_PCR_GB) tmp
    WHERE     NUM_RECS = 1
          AND TRIM (TO_CHAR (ID_DPER)) IS NOT NULL
          AND TRIM (TO_CHAR (COD_SNDG)) IS NOT NULL
          AND TRIM (TO_CHAR (COD_FORMA_TECNICA)) IS NOT NULL;


GRANT SELECT ON MCRE_OWN.V_MCRE0_ST_PCR_GB TO MCRE_USR;
