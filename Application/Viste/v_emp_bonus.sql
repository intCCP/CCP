/* Formatted on 21/07/2014 18:31:27 (QP5 v5.227.12220.39754) */
CREATE OR REPLACE FORCE VIEW MCRE_OWN.V_EMP_BONUS
(
   EMPNO,
   HIRE_DATE,
   WORK_DAYS,
   BONUS_COEF,
   BONUS,
   MODC,
   FLO,
   CE,
   MODC2,
   REMC,
   REMC2
)
AS
   SELECT empno,
          hire_date,
          TRUNC (SYSDATE) - hire_date AS work_days,
          CASE
             WHEN (FLOOR ( (TRUNC (SYSDATE) - hire_date) / 365) >= 1)
             THEN
                ROUND ( (TRUNC (SYSDATE) - hire_date) / 365, 2)
             ELSE
                0
          END
             bonus_coef,
          CASE
             WHEN (FLOOR ( (TRUNC (SYSDATE) - hire_date) / 365) >= 1)
             THEN
                ROUND ( (TRUNC (SYSDATE) - hire_date) / 365, 2) * sal
             ELSE
                0
          END
             bonus,
          MOD (TRUNC (SYSDATE) - hire_date, 365) AS modc,
          FLOOR ( (TRUNC (SYSDATE) - hire_date) / 365) AS flo,
          CEIL ( (TRUNC (SYSDATE) - hire_date) / 365) AS ce,
            (TRUNC (SYSDATE) - hire_date)
          - (365 * (FLOOR ( (TRUNC (SYSDATE) - hire_date) / 365)))
             AS modc2,
          REMAINDER (TRUNC (SYSDATE) - hire_date, 365) AS remc,
            (TRUNC (SYSDATE) - hire_date)
          - (365 * (ROUND ( (TRUNC (SYSDATE) - hire_date) / 365)))
             AS remc2
     FROM emp;
