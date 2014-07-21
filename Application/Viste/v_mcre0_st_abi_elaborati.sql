/* Formatted on 21/07/2014 18:37:39 (QP5 v5.227.12220.39754) */
CREATE OR REPLACE FORCE VIEW MCRE_OWN.V_MCRE0_ST_ABI_ELABORATI
(
   ID_DPER,
   COD_ABI_ISTITUTO,
   DTA_ELABORAZIONE,
   TMS_ULTIMA_ELABORAZIONE
)
AS
   WITH T_MCRE0_FL_ABI_ELABORATI
        AS (SELECT (SELECT TO_NUMBER (
                              TO_CHAR (
                                 TO_DATE (TRIM (PERIODO_RIF), 'DDMMYYYY'),
                                 'YYYYMMDD'))
                      FROM TE_MCRE0_ABI_IDT
                     WHERE ROWNUM = 1)
                      AS ID_DPER,
                   LPAD (FA0_ABI_IST, 5, 0) AS COD_ABI_ISTITUTO,
                   TO_DATE (FA0_DAT_ELA, 'DDMMYYYY') AS DTA_ELABORAZIONE,
                   FA0_ULT_TMS AS TMS_ULTIMA_ELABORAZIONE
              FROM TE_MCRE0_ABI_INC
             WHERE     FND_MCRE0_is_numeric (FA0_ABI_IST) = 1
                   AND FND_MCRE0_is_date (FA0_DAT_ELA) = 1)
   SELECT "ID_DPER",
          "COD_ABI_ISTITUTO",
          "DTA_ELABORAZIONE",
          "TMS_ULTIMA_ELABORAZIONE"
     FROM (SELECT COUNT (1) OVER (PARTITION BY ID_DPER, COD_ABI_ISTITUTO)
                     NUM_RECS,
                  ID_DPER,
                  COD_ABI_ISTITUTO,
                  DTA_ELABORAZIONE,
                  TMS_ULTIMA_ELABORAZIONE
             FROM T_MCRE0_FL_ABI_ELABORATI) tmp
    WHERE     NUM_RECS = 1
          AND TRIM (TO_CHAR (ID_DPER)) IS NOT NULL
          AND TRIM (TO_CHAR (COD_ABI_ISTITUTO)) IS NOT NULL;
