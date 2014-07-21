/* Formatted on 17/06/2014 18:05:13 (QP5 v5.227.12220.39754) */
CREATE OR REPLACE FORCE VIEW MCRE_OWN.V_MCRE0_ERROR_APPLICATIVO
(
   ID,
   PROCEDURA,
   LIVELLO,
   SQL_CODE,
   MESSAGE,
   NOTE,
   UTENTE,
   DTA_INS
)
AS
   SELECT "ID",
          "PROCEDURA",
          "LIVELLO",
          "SQL_CODE",
          "MESSAGE",
          "NOTE",
          "UTENTE",
          "DTA_INS"
     FROM t_mcre0_wrk_audit_applicativo
    WHERE dta_ins >= TRUNC (SYSDATE - 1) AND livello = 1;


GRANT SELECT ON MCRE_OWN.V_MCRE0_ERROR_APPLICATIVO TO MCRE_USR;
