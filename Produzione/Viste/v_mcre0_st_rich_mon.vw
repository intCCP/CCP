/* Formatted on 17/06/2014 18:06:29 (QP5 v5.227.12220.39754) */
CREATE OR REPLACE FORCE VIEW MCRE_OWN.V_MCRE0_ST_RICH_MON
(
   ID_DPER,
   COD_SNDG
)
AS
   WITH T_MCRE0_FL_RICH_MON
        AS (SELECT (SELECT TO_NUMBER (
                              TO_CHAR (
                                 TO_DATE (TRIM (PERIODO_RIF), 'DDMMYYYY'),
                                 'YYYYMMDD'))
                      FROM TE_MCRE0_RICH_MON_DT
                     WHERE ROWNUM = 1)
                      ID_DPER,
                   RPAD (FA8_NDG_GRP, 16, 0) AS COD_SNDG
              FROM TE_MCRE0_RICH_MON
             WHERE FND_MCRE0_is_numeric (FA8_NDG_GRP) = 1)
   SELECT "ID_DPER", "COD_SNDG"
     FROM (SELECT COUNT (1) OVER (PARTITION BY ID_DPER, COD_SNDG) NUM_RECS,
                  ID_DPER,
                  COD_SNDG
             FROM T_MCRE0_FL_RICH_MON) tmp
    WHERE     NUM_RECS = 1
          AND TRIM (TO_CHAR (ID_DPER)) IS NOT NULL
          AND TRIM (TO_CHAR (COD_SNDG)) IS NOT NULL;


GRANT SELECT ON MCRE_OWN.V_MCRE0_ST_RICH_MON TO MCRE_USR;
