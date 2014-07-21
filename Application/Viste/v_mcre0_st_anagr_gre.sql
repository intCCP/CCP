/* Formatted on 21/07/2014 18:37:40 (QP5 v5.227.12220.39754) */
CREATE OR REPLACE FORCE VIEW MCRE_OWN.V_MCRE0_ST_ANAGR_GRE
(
   ID_DPER,
   COD_GRUPPO_ECO,
   DESC_GRUPPO_ECO
)
AS
   WITH T_MCRE0_FL_ANAGRAFICA_GRE
        AS (SELECT (SELECT TO_NUMBER (
                              TO_CHAR (
                                 TO_DATE (TRIM (PERIODO_RIF), 'DDMMYYYY'),
                                 'YYYYMMDD'))
                      FROM TE_MCRE0_ANAGR_GRE_DT
                     WHERE ROWNUM = 1)
                      ID_DPER,
                   TRIM (FAM_COD_GRE) AS COD_GRUPPO_ECO,
                   TRIM (FAM_ANA_GRE) AS DESC_GRUPPO_ECO
              FROM TE_MCRE0_AGRE_INC
             WHERE FND_MCRE0_is_numeric (FAM_COD_GRE) = 1)
   SELECT "ID_DPER", "COD_GRUPPO_ECO", "DESC_GRUPPO_ECO"
     FROM (SELECT COUNT (1) OVER (PARTITION BY ID_DPER, COD_GRUPPO_ECO)
                     NUM_RECS,
                  ID_DPER,
                  COD_GRUPPO_ECO,
                  DESC_GRUPPO_ECO
             FROM T_MCRE0_FL_ANAGRAFICA_GRE) tmp
    WHERE     NUM_RECS = 1
          AND TRIM (TO_CHAR (ID_DPER)) IS NOT NULL
          AND TRIM (TO_CHAR (COD_GRUPPO_ECO)) IS NOT NULL;
