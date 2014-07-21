/* Formatted on 21/07/2014 18:36:58 (QP5 v5.227.12220.39754) */
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
