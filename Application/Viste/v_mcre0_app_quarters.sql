/* Formatted on 21/07/2014 18:35:05 (QP5 v5.227.12220.39754) */
CREATE OR REPLACE FORCE VIEW MCRE_OWN.V_MCRE0_APP_QUARTERS
(
   COD_Q,
   DTA_START_Q,
   DTA_END_Q,
   INIZIO_NUMBER,
   FINE_NUMBER
)
AS
   SELECT cod_q,
          dta_start_q,
          DECODE (cod_q,
                  5, TRUNC (SYSDATE),
                  LAST_DAY (ADD_MONTHS (dta_start_q, 2)))
             dta_end_q,
          TO_NUMBER (TO_CHAR (dta_start_q, 'yyyymm')) inizio_number,
          TO_NUMBER (
             TO_CHAR (
                DECODE (cod_q,
                        5, TRUNC (SYSDATE),
                        LAST_DAY (ADD_MONTHS (dta_start_q, 2))),
                'yyyymm'))
             fine_number
     FROM (SELECT 5 cod_q, TRUNC (SYSDATE, 'Q') dta_start_q FROM DUAL
           UNION ALL
           SELECT 4 cod_q, ADD_MONTHS (TRUNC (SYSDATE, 'Q'), -3) dta_start_q
             FROM DUAL
           UNION ALL
           SELECT 3 cod_q, ADD_MONTHS (TRUNC (SYSDATE, 'Q'), -6) dta_start_q
             FROM DUAL
           UNION ALL
           SELECT 2 cod_q, ADD_MONTHS (TRUNC (SYSDATE, 'Q'), -9) dta_start_q
             FROM DUAL
           UNION ALL
           SELECT 1 cod_q, ADD_MONTHS (TRUNC (SYSDATE, 'Q'), -12) dta_start_q
             FROM DUAL);
