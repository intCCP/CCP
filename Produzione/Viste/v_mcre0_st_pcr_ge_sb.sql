/* Formatted on 17/06/2014 18:06:20 (QP5 v5.227.12220.39754) */
CREATE OR REPLACE FORCE VIEW MCRE_OWN.V_MCRE0_ST_PCR_GE_SB
(
   ID_DPER,
   COD_ABI_ISTITUTO,
   COD_SNDG,
   COD_FORMA_TECN,
   VAL_IMP_GAR_GRE,
   VAL_IMP_UTI_GRE,
   VAL_IMP_ACC_GRE,
   DTA_RIFERIMENTO,
   COD_NATURA,
   DTA_SCADENZA_LDC
)
AS
   WITH T_MCRE0_FL_PCR_GE_SB
        AS (SELECT (SELECT TO_NUMBER (
                              TO_CHAR (
                                 TO_DATE (TRIM (PERIODO_RIF), 'DDMMYYYY'),
                                 'YYYYMMDD'))
                      FROM TE_MCRE0_PGES_IDT
                     WHERE ROWNUM = 1)
                      ID_DPER,
                   LPAD (FAA_ABI_IST, 5, 0) AS COD_ABI_ISTITUTO,
                   RPAD (FAA_NDG_CPG, 16, 0) AS COD_SNDG,
                   TRIM (FAA_COD_FTE) AS COD_FORMA_TECN,
                   TO_NUMBER (FAA_IMP_GAR_GRE) AS VAL_IMP_GAR_GRE,
                   TO_NUMBER (FAA_IMP_UTI_GRE) AS VAL_IMP_UTI_GRE,
                   TO_NUMBER (FAA_IMP_ACC_GRE) AS VAL_IMP_ACC_GRE,
                   TO_DATE (FAA_DAT_RIF, 'ddmmyyyy') AS DTA_RIFERIMENTO,
                   TRIM (FAA_COD_NAT) AS COD_NATURA,
                   TO_DATE (FAA_DAT_SCA_LDC, 'ddmmyyyy') AS DTA_SCADENZA_LDC
              FROM TE_MCRE0_PGES_INC
             WHERE     FND_MCRE0_is_numeric (FAA_ABI_IST) = 1
                   AND FND_MCRE0_is_numeric (FAA_NDG_CPG) = 1
                   AND FND_MCRE0_is_numeric (FAA_IMP_GAR_GRE) = 1
                   AND FND_MCRE0_is_numeric (FAA_IMP_UTI_GRE) = 1
                   AND FND_MCRE0_is_numeric (FAA_IMP_ACC_GRE) = 1
                   AND FND_MCRE0_is_date (FAA_DAT_RIF) = 1
                   AND FND_MCRE0_is_date (FAA_DAT_SCA_LDC) = 1)
   SELECT "ID_DPER",
          "COD_ABI_ISTITUTO",
          "COD_SNDG",
          "COD_FORMA_TECN",
          "VAL_IMP_GAR_GRE",
          "VAL_IMP_UTI_GRE",
          "VAL_IMP_ACC_GRE",
          "DTA_RIFERIMENTO",
          "COD_NATURA",
          "DTA_SCADENZA_LDC"
     FROM (SELECT COUNT (
                     1)
                  OVER (
                     PARTITION BY ID_DPER,
                                  COD_ABI_ISTITUTO,
                                  COD_SNDG,
                                  COD_FORMA_TECN)
                     NUM_RECS,
                  ID_DPER,
                  COD_ABI_ISTITUTO,
                  COD_SNDG,
                  COD_FORMA_TECN,
                  VAL_IMP_GAR_GRE,
                  VAL_IMP_UTI_GRE,
                  VAL_IMP_ACC_GRE,
                  DTA_RIFERIMENTO,
                  COD_NATURA,
                  DTA_SCADENZA_LDC
             FROM T_MCRE0_FL_PCR_GE_SB) tmp
    WHERE     NUM_RECS = 1
          AND TRIM (TO_CHAR (ID_DPER)) IS NOT NULL
          AND TRIM (TO_CHAR (COD_ABI_ISTITUTO)) IS NOT NULL
          AND TRIM (TO_CHAR (COD_SNDG)) IS NOT NULL
          AND TRIM (TO_CHAR (COD_FORMA_TECN)) IS NOT NULL;


GRANT SELECT ON MCRE_OWN.V_MCRE0_ST_PCR_GE_SB TO MCRE_USR;
