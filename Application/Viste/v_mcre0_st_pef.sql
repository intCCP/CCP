/* Formatted on 21/07/2014 18:37:54 (QP5 v5.227.12220.39754) */
CREATE OR REPLACE FORCE VIEW MCRE_OWN.V_MCRE0_ST_PEF
(
   ID_DPER,
   COD_ABI_ISTITUTO,
   COD_NDG,
   COD_PEF,
   COD_FASE_PEF,
   DTA_ULTIMA_REVISIONE,
   DTA_SCADENZA_FIDO,
   DTA_ULTIMA_DELIBERA,
   FLG_FIDI_SCADUTI,
   DAT_ULTIMO_SCADUTO,
   COD_ULTIMO_ODE,
   COD_CTS_ULTIMO_ODE,
   COD_STRATEGIA_CRZ,
   COD_ODE,
   DTA_COMPLETAMENTO_PEF,
   DTA_SCA_REV_PEF
)
AS
   WITH T_MCRE0_FL_PEF
        AS (SELECT (SELECT TO_NUMBER (
                              TO_CHAR (
                                 TO_DATE (TRIM (PERIODO_RIF), 'DDMMYYYY'),
                                 'YYYYMMDD'))
                      FROM TE_MCRE0_PEF_IDT
                     WHERE ROWNUM = 1)
                      ID_DPER,
                   LPAD (FAC_ABI_IST, 5, 0) AS COD_ABI_ISTITUTO,
                   RPAD (FAC_NDG_SET, 16, 0) AS COD_NDG,
                   TRIM (FAC_COD_PEF) AS COD_PEF,
                   TRIM (FAC_FSE_PEF) AS COD_FASE_PEF,
                   TO_DATE (FAC_DAT_ULT_REV, 'DDMMYYYY')
                      AS DTA_ULTIMA_REVISIONE,
                   TO_DATE (FAC_DAT_SCA_FID, 'DDMMYYYY') AS DTA_SCADENZA_FIDO,
                   TO_DATE (FAC_DAT_ULT_DEL, 'DDMMYYYY')
                      AS DTA_ULTIMA_DELIBERA,
                   TRIM (FAC_FLG_FID_SCA) AS FLG_FIDI_SCADUTI,
                   TO_DATE (FAC_DAT_ULT_SCA, 'DDMMYYYY')
                      AS DAT_ULTIMO_SCADUTO,
                   TRIM (FAC_COD_ULT_ODE) AS COD_ULTIMO_ODE,
                   TRIM (FAC_CTS_ULT_ODE) AS COD_CTS_ULTIMO_ODE,
                   TRIM (FAC_COD_STR_CRZ) AS COD_STRATEGIA_CRZ,
                   TRIM (FAC_COD_ODE) AS COD_ODE,
                   TO_DATE (FAC_DAT_CMP_PEF, 'DDMMYYYY')
                      AS DTA_COMPLETAMENTO_PEF,
                   TO_DATE (DTA_SCA_REV_PEF, 'DDMMYYYY') AS DTA_SCA_REV_PEF
              FROM TE_MCRE0_PEF_INC
             WHERE     FND_MCRE0_is_date (FAC_DAT_ULT_REV) = 1
                   AND FND_MCRE0_is_date (FAC_DAT_SCA_FID) = 1
                   AND FND_MCRE0_is_date (FAC_DAT_ULT_DEL) = 1
                   AND FND_MCRE0_is_date (FAC_DAT_ULT_SCA) = 1
                   AND FND_MCRE0_is_date (FAC_DAT_CMP_PEF) = 1
                   AND FND_MCRE0_is_date (DTA_SCA_REV_PEF) = 1)
   SELECT "ID_DPER",
          "COD_ABI_ISTITUTO",
          "COD_NDG",
          "COD_PEF",
          "COD_FASE_PEF",
          "DTA_ULTIMA_REVISIONE",
          "DTA_SCADENZA_FIDO",
          "DTA_ULTIMA_DELIBERA",
          "FLG_FIDI_SCADUTI",
          "DAT_ULTIMO_SCADUTO",
          "COD_ULTIMO_ODE",
          "COD_CTS_ULTIMO_ODE",
          "COD_STRATEGIA_CRZ",
          "COD_ODE",
          "DTA_COMPLETAMENTO_PEF",
          "DTA_SCA_REV_PEF"
     FROM (SELECT COUNT (1)
                     OVER (PARTITION BY ID_DPER, COD_ABI_ISTITUTO, COD_NDG)
                     NUM_RECS,
                  ID_DPER,
                  COD_ABI_ISTITUTO,
                  COD_NDG,
                  COD_PEF,
                  COD_FASE_PEF,
                  DTA_ULTIMA_REVISIONE,
                  DTA_SCADENZA_FIDO,
                  DTA_ULTIMA_DELIBERA,
                  FLG_FIDI_SCADUTI,
                  DAT_ULTIMO_SCADUTO,
                  COD_ULTIMO_ODE,
                  COD_CTS_ULTIMO_ODE,
                  COD_STRATEGIA_CRZ,
                  COD_ODE,
                  DTA_COMPLETAMENTO_PEF,
                  DTA_SCA_REV_PEF
             FROM T_MCRE0_FL_PEF) tmp
    WHERE     NUM_RECS = 1
          AND TRIM (TO_CHAR (ID_DPER)) IS NOT NULL
          AND TRIM (TO_CHAR (COD_ABI_ISTITUTO)) IS NOT NULL
          AND TRIM (TO_CHAR (COD_NDG)) IS NOT NULL;
