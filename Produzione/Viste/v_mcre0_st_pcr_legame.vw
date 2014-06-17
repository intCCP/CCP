/* Formatted on 17/06/2014 18:06:21 (QP5 v5.227.12220.39754) */
CREATE OR REPLACE FORCE VIEW MCRE_OWN.V_MCRE0_ST_PCR_LEGAME
(
   ID_DPER,
   COD_SNDG,
   COD_FORMA_TECNICA,
   VAL_UTI_LEG,
   VAL_ACC_LEG,
   COD_SNDG_LEGANTE,
   COD_LEGAME,
   DTA_RIFERIMENTO,
   COD_NATURA,
   VAL_IMP_GAR_LEG,
   DTA_SCADENZA_LDC
)
AS
   WITH T_MCRE0_FL_PCR_LEGAME
        AS (SELECT (SELECT TO_NUMBER (
                              TO_CHAR (
                                 TO_DATE (TRIM (PERIODO_RIF), 'DDMMYYYY'),
                                 'YYYYMMDD'))
                      FROM TE_MCRE0_PCR_LEGAME_DT
                     WHERE ROWNUM = 1)
                      ID_DPER,
                   RPAD (FAN_NDG_GRP_LTO, 16, 0) AS COD_SNDG,
                   TRIM (FAN_COD_FTE) AS COD_FORMA_TECNICA,
                   TO_NUMBER (FAN_IMP_UTI_LEG) AS VAL_UTI_LEG,
                   TO_NUMBER (FAN_IMP_ACC_LEG) AS VAL_ACC_LEG,
                   RPAD (FAN_NDG_GRP_LTE, 16, 0) AS COD_SNDG_LEGANTE,
                   TRIM (FAN_COD_LEG) AS COD_LEGAME,
                   TO_DATE (FAN_DAT_RIF, 'DDMMYYYY') AS DTA_RIFERIMENTO,
                   TRIM (FAN_COD_NAT) AS COD_NATURA,
                   TO_NUMBER (FAN_IMP_GAR_LEG) AS VAL_IMP_GAR_LEG,
                   TO_DATE (FAN_DAT_SCA_LDC, 'DDMMYYYY') AS DTA_SCADENZA_LDC
              FROM TE_MCRE0_PCR_LEGAME
             WHERE     FND_MCRE0_is_numeric (FAN_NDG_GRP_LTO) = 1
                   AND FND_MCRE0_is_numeric (FAN_IMP_UTI_LEG) = 1
                   AND FND_MCRE0_is_numeric (FAN_IMP_ACC_LEG) = 1
                   AND FND_MCRE0_is_numeric (FAN_NDG_GRP_LTE) = 1
                   AND FND_MCRE0_is_date (FAN_DAT_RIF) = 1
                   AND FND_MCRE0_is_numeric (FAN_IMP_GAR_LEG) = 1
                   AND FND_MCRE0_is_date (FAN_DAT_SCA_LDC) = 1)
   SELECT "ID_DPER",
          "COD_SNDG",
          "COD_FORMA_TECNICA",
          "VAL_UTI_LEG",
          "VAL_ACC_LEG",
          "COD_SNDG_LEGANTE",
          "COD_LEGAME",
          "DTA_RIFERIMENTO",
          "COD_NATURA",
          "VAL_IMP_GAR_LEG",
          "DTA_SCADENZA_LDC"
     FROM (SELECT COUNT (
                     1)
                  OVER (
                     PARTITION BY ID_DPER,
                                  COD_SNDG,
                                  COD_SNDG_LEGANTE,
                                  COD_FORMA_TECNICA)
                     NUM_RECS,
                  ID_DPER,
                  COD_SNDG,
                  COD_FORMA_TECNICA,
                  VAL_UTI_LEG,
                  VAL_ACC_LEG,
                  COD_SNDG_LEGANTE,
                  COD_LEGAME,
                  DTA_RIFERIMENTO,
                  COD_NATURA,
                  VAL_IMP_GAR_LEG,
                  DTA_SCADENZA_LDC
             FROM T_MCRE0_FL_PCR_LEGAME) tmp
    WHERE     NUM_RECS = 1
          AND TRIM (TO_CHAR (ID_DPER)) IS NOT NULL
          AND TRIM (TO_CHAR (COD_SNDG)) IS NOT NULL
          AND TRIM (TO_CHAR (COD_SNDG_LEGANTE)) IS NOT NULL
          AND TRIM (TO_CHAR (COD_FORMA_TECNICA)) IS NOT NULL;


GRANT SELECT ON MCRE_OWN.V_MCRE0_ST_PCR_LEGAME TO MCRE_USR;
