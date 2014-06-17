/* Formatted on 17/06/2014 18:11:53 (QP5 v5.227.12220.39754) */
CREATE OR REPLACE FORCE VIEW MCRE_OWN.V_MCRES_APP_TRIM_EFF_ECO
(
   VAL_ANNOMESE,
   COD_Q,
   DTA_START_Q,
   DTA_END_Q,
   INIZIO_NUMBER,
   FINE_NUMBER
)
AS
   SELECT TO_NUMBER (TO_CHAR (ID_DPER, 'YYYYMM')) val_annomese,
          cod_q,
          dta_start_q,
          DECODE (cod_q,
                  5, TRUNC (ID_DPER),
                  LAST_DAY (ADD_MONTHS (dta_start_q, 2)))
             dta_end_q,
          TO_NUMBER (TO_CHAR (dta_start_q, 'yyyymm')) inizio_number,
          TO_NUMBER (
             TO_CHAR (
                DECODE (cod_q,
                        5, TRUNC (ID_DPER),
                        LAST_DAY (ADD_MONTHS (dta_start_q, 2))),
                'yyyymm'))
             fine_number
     FROM (SELECT 5 cod_q, TRUNC (ID_DPER, 'Q') dta_start_q, ID_DPER
             FROM (SELECT DISTINCT id_dper
                     FROM MCRE_OWN.T_MCRES_WRK_ACQUISIZIONE W
                    WHERE     COD_STATO IN ('CARICATO', 'CARICATO_APP')
                          AND COD_FLUSSO = 'EFFETTI_ECONOMICI')
           UNION ALL
           SELECT 4 cod_q,
                  ADD_MONTHS (TRUNC (ID_DPER, 'Q'), -3) dta_start_q,
                  ID_DPER
             FROM (SELECT DISTINCT id_dper
                     FROM MCRE_OWN.T_MCRES_WRK_ACQUISIZIONE W
                    WHERE     COD_STATO IN ('CARICATO', 'CARICATO_APP')
                          AND COD_FLUSSO = 'EFFETTI_ECONOMICI')
           UNION ALL
           SELECT 3 cod_q,
                  ADD_MONTHS (TRUNC (ID_dPER, 'Q'), -6) dta_start_q,
                  ID_DPER
             FROM (SELECT DISTINCT id_dper
                     FROM MCRE_OWN.T_MCRES_WRK_ACQUISIZIONE W
                    WHERE     COD_STATO IN ('CARICATO', 'CARICATO_APP')
                          AND COD_FLUSSO = 'EFFETTI_ECONOMICI')
           UNION ALL
           SELECT 2 cod_q,
                  ADD_MONTHS (TRUNC (ID_DPER, 'Q'), -9) dta_start_q,
                  ID_DPER
             FROM (SELECT DISTINCT id_dper
                     FROM MCRE_OWN.T_MCRES_WRK_ACQUISIZIONE W
                    WHERE     COD_STATO IN ('CARICATO', 'CARICATO_APP')
                          AND COD_FLUSSO = 'EFFETTI_ECONOMICI')
           UNION ALL
           SELECT 1 cod_q,
                  ADD_MONTHS (TRUNC (ID_DPER, 'Q'), -12) dta_start_q,
                  ID_DPER
             FROM (SELECT DISTINCT id_dper
                     FROM MCRE_OWN.T_MCRES_WRK_ACQUISIZIONE W
                    WHERE     COD_STATO IN ('CARICATO', 'CARICATO_APP')
                          AND COD_FLUSSO = 'EFFETTI_ECONOMICI'));


GRANT DELETE, INSERT, REFERENCES, SELECT, UPDATE, ON COMMIT REFRESH, QUERY REWRITE, DEBUG, FLASHBACK, MERGE VIEW ON MCRE_OWN.V_MCRES_APP_TRIM_EFF_ECO TO MCRE_USR;
