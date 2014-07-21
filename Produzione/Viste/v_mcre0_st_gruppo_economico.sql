/* Formatted on 17/06/2014 18:06:13 (QP5 v5.227.12220.39754) */
CREATE OR REPLACE FORCE VIEW MCRE_OWN.V_MCRE0_ST_GRUPPO_ECONOMICO
(
   ID_DPER,
   COD_SNDG,
   COD_GRUPPO_ECONOMICO,
   FLG_CAPOGRUPPO
)
AS
   WITH T_MCRE0_FL_GRUPPO_ECONOMICO
        AS (SELECT (SELECT TO_NUMBER (
                              TO_CHAR (
                                 TO_DATE (TRIM (PERIODO_RIF), 'DDMMYYYY'),
                                 'YYYYMMDD'))
                      FROM TE_MCRE0_GE_IDT
                     WHERE ROWNUM = 1)
                      ID_DPER,
                   RPAD (FA3_NDG_GRP, 16, 0) AS COD_SNDG,
                   FA3_COD_GRE AS COD_GRUPPO_ECONOMICO,
                   FA3_FLG_CPG AS FLG_CAPOGRUPPO
              FROM TE_MCRE0_GE_INC
             WHERE     FND_MCRE0_is_numeric (FA3_NDG_GRP) = 1
                   AND FND_MCRE0_is_numeric (FA3_COD_GRE) = 1)
   SELECT "ID_DPER",
          "COD_SNDG",
          "COD_GRUPPO_ECONOMICO",
          "FLG_CAPOGRUPPO"
     FROM (SELECT COUNT (1) OVER (PARTITION BY ID_DPER, COD_SNDG) NUM_RECS,
                  ID_DPER,
                  COD_SNDG,
                  COD_GRUPPO_ECONOMICO,
                  FLG_CAPOGRUPPO
             FROM T_MCRE0_FL_GRUPPO_ECONOMICO) tmp
    WHERE     NUM_RECS = 1
          AND TRIM (TO_CHAR (ID_DPER)) IS NOT NULL
          AND TRIM (TO_CHAR (COD_SNDG)) IS NOT NULL;


GRANT SELECT ON MCRE_OWN.V_MCRE0_ST_GRUPPO_ECONOMICO TO MCRE_USR;
