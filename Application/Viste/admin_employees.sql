/* Formatted on 21/07/2014 18:30:08 (QP5 v5.227.12220.39754) */
CREATE OR REPLACE FORCE VIEW MCRE_OWN.ADMIN_EMPLOYEES
(
   NAME,
   EMAIL,
   POSITION
)
AS
   SELECT first_name || last_name AS name, email, job_id POSITIOn
     FROM employees
    WHERE department_id = 10;
