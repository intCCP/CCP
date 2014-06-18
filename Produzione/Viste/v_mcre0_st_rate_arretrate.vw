/* Formatted on 17/06/2014 18:06:28 (QP5 v5.227.12220.39754) */
CREATE OR REPLACE FORCE VIEW MCRE_OWN.V_MCRE0_ST_RATE_ARRETRATE
(
   ID_DPER,
   COD_ABI_ISTITUTO,
   COD_ABI_CARTOLARIZZATO,
   COD_NDG,
   TMS,
   COD_RAPPORTO,
   VAL_COEFF_RATE_ARRETRATE,
   COD_PERIODO,
   DTA_SCADENZA,
   VAL_IMP_ARRETRATO,
   VAL_IMP_MORA,
   VAL_IMP_ULTIMA_RATA,
   VAL_IMP_DEBITO_RESIDUO,
   COD_PERCORSO
)
AS
   WITH T_MCRE0_FL_RATE_ARRETRATE
        AS (SELECT (SELECT TO_NUMBER (
                              TO_CHAR (
                                 TO_DATE (TRIM (PERIODO_RIF), 'DDMMYYYY'),
                                 'YYYYMMDD'))
                      FROM TE_MCRE0_RARR_IDT
                     WHERE ROWNUM = 1)
                      ID_DPER,
                   LPAD (FA6_ABI_IST, 5, 0) AS COD_ABI_ISTITUTO,
                   LPAD (FA6_ABI_ELA, 5, 0) AS COD_ABI_CARTOLARIZZATO,
                   RPAD (FA6_NDG_SET, 16, 0) AS COD_NDG,
                   TRIM (FA6_TMS) AS TMS,
                   TRIM (FA6_COD_RAP) AS COD_RAPPORTO,
                   FA6_COE_RAT AS VAL_COEFF_RATE_ARRETRATE,
                   TRIM (FA6_PER_RAT) AS COD_PERIODO,
                   TO_DATE (FA6_DAT_SCA, 'DDMMYYYY') AS DTA_SCADENZA,
                   FA6_IMP_ARR AS VAL_IMP_ARRETRATO,
                   FA6_IMP_MRA AS VAL_IMP_MORA,
                   FA6_IMP_RAT AS VAL_IMP_ULTIMA_RATA,
                   FA6_IMP_RES AS VAL_IMP_DEBITO_RESIDUO,
                   TO_NUMBER (FA6_NUM_PRG_PRO) AS COD_PERCORSO
              FROM TE_MCRE0_RARR_INC
             WHERE     FND_MCRE0_is_numeric (FA6_ABI_IST) = 1
                   AND FND_MCRE0_is_numeric (FA6_ABI_ELA) = 1
                   AND FND_MCRE0_is_numeric (FA6_NDG_SET) = 1
                   AND FND_MCRE0_is_date (FA6_DAT_SCA) = 1
                   AND FND_MCRE0_is_numeric (FA6_NUM_PRG_PRO) = 1)
   SELECT "ID_DPER",
          "COD_ABI_ISTITUTO",
          "COD_ABI_CARTOLARIZZATO",
          "COD_NDG",
          "TMS",
          "COD_RAPPORTO",
          "VAL_COEFF_RATE_ARRETRATE",
          "COD_PERIODO",
          "DTA_SCADENZA",
          "VAL_IMP_ARRETRATO",
          "VAL_IMP_MORA",
          "VAL_IMP_ULTIMA_RATA",
          "VAL_IMP_DEBITO_RESIDUO",
          "COD_PERCORSO"
     FROM (SELECT COUNT (
                     1)
                  OVER (
                     PARTITION BY ID_DPER,
                                  COD_ABI_CARTOLARIZZATO,
                                  COD_NDG,
                                  TMS,
                                  COD_RAPPORTO)
                     NUM_RECS,
                  ID_DPER,
                  COD_ABI_ISTITUTO,
                  COD_ABI_CARTOLARIZZATO,
                  COD_NDG,
                  TMS,
                  COD_RAPPORTO,
                  VAL_COEFF_RATE_ARRETRATE,
                  COD_PERIODO,
                  DTA_SCADENZA,
                  VAL_IMP_ARRETRATO,
                  VAL_IMP_MORA,
                  VAL_IMP_ULTIMA_RATA,
                  VAL_IMP_DEBITO_RESIDUO,
                  COD_PERCORSO
             FROM T_MCRE0_FL_RATE_ARRETRATE) tmp
    WHERE     NUM_RECS = 1
          AND TRIM (TO_CHAR (ID_DPER)) IS NOT NULL
          AND TRIM (TO_CHAR (COD_ABI_CARTOLARIZZATO)) IS NOT NULL
          AND TRIM (TO_CHAR (COD_NDG)) IS NOT NULL
          AND TRIM (TO_CHAR (TMS)) IS NOT NULL
          AND TRIM (TO_CHAR (COD_RAPPORTO)) IS NOT NULL;


GRANT SELECT ON MCRE_OWN.V_MCRE0_ST_RATE_ARRETRATE TO MCRE_USR;
