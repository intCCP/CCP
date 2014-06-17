/* Formatted on 17/06/2014 18:06:22 (QP5 v5.227.12220.39754) */
CREATE OR REPLACE FORCE VIEW MCRE_OWN.V_MCRE0_ST_PCR_SC_SB
(
   ID_DPER,
   COD_ABI_ISTITUTO,
   COD_NDG,
   COD_FORMA_TECNICA,
   VAL_IMP_UTI_CLI,
   VAL_IMP_ACC_CLI,
   DTA_RIFERIMENTO,
   COD_NATURA,
   VAL_IMP_GAR_TOT,
   DTA_SCADENZA_LDC
)
AS
   WITH T_MCRE0_FL_PCR_SC_SB
        AS (SELECT (SELECT TO_NUMBER (
                              TO_CHAR (
                                 TO_DATE (TRIM (PERIODO_RIF), 'DDMMYYYY'),
                                 'YYYYMMDD'))
                      FROM TE_MCRE0_PSCB_IDT
                     WHERE ROWNUM = 1)
                      ID_DPER,
                   LPAD (FA9_ABI_IST, 5, 0) AS COD_ABI_ISTITUTO,
                   RPAD (FA9_NDG_SET, 16, 0) AS COD_NDG,
                   FA9_COD_FTE AS COD_FORMA_TECNICA,
                   TO_NUMBER (FA9_IMP_UTI_CLI) AS VAL_IMP_UTI_CLI,
                   TO_NUMBER (FA9_IMP_ACC_CLI) AS VAL_IMP_ACC_CLI,
                   TO_DATE (FA9_DAT_RIF, 'DDMMYYYY') AS DTA_RIFERIMENTO,
                   FA9_COD_NAT AS COD_NATURA,
                   TO_NUMBER (FA9_IMP_GAR_TOT) AS VAL_IMP_GAR_TOT,
                   TO_DATE (FA9_DAT_SCA_LDC, 'DDMMYYYY') AS DTA_SCADENZA_LDC
              FROM TE_MCRE0_PSCB_INC
             WHERE     FND_MCRE0_is_numeric (FA9_ABI_IST) = 1
                   AND FND_MCRE0_is_numeric (FA9_NDG_SET) = 1
                   AND FND_MCRE0_is_numeric (FA9_IMP_UTI_CLI) = 1
                   AND FND_MCRE0_is_numeric (FA9_IMP_ACC_CLI) = 1
                   AND FND_MCRE0_is_date (FA9_DAT_RIF) = 1
                   AND FND_MCRE0_is_numeric (FA9_IMP_GAR_TOT) = 1
                   AND FND_MCRE0_is_date (FA9_DAT_SCA_LDC) = 1)
   SELECT "ID_DPER",
          "COD_ABI_ISTITUTO",
          "COD_NDG",
          "COD_FORMA_TECNICA",
          "VAL_IMP_UTI_CLI",
          "VAL_IMP_ACC_CLI",
          "DTA_RIFERIMENTO",
          "COD_NATURA",
          "VAL_IMP_GAR_TOT",
          "DTA_SCADENZA_LDC"
     FROM (SELECT COUNT (
                     1)
                  OVER (
                     PARTITION BY ID_DPER,
                                  COD_ABI_ISTITUTO,
                                  COD_NDG,
                                  COD_FORMA_TECNICA)
                     NUM_RECS,
                  ID_DPER,
                  COD_ABI_ISTITUTO,
                  COD_NDG,
                  COD_FORMA_TECNICA,
                  VAL_IMP_UTI_CLI,
                  VAL_IMP_ACC_CLI,
                  DTA_RIFERIMENTO,
                  COD_NATURA,
                  VAL_IMP_GAR_TOT,
                  DTA_SCADENZA_LDC
             FROM T_MCRE0_FL_PCR_SC_SB) tmp
    WHERE     NUM_RECS = 1
          AND TRIM (TO_CHAR (ID_DPER)) IS NOT NULL
          AND TRIM (TO_CHAR (COD_ABI_ISTITUTO)) IS NOT NULL
          AND TRIM (TO_CHAR (COD_NDG)) IS NOT NULL
          AND TRIM (TO_CHAR (COD_FORMA_TECNICA)) IS NOT NULL;


GRANT SELECT ON MCRE_OWN.V_MCRE0_ST_PCR_SC_SB TO MCRE_USR;
