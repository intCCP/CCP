/* Formatted on 21/07/2014 18:40:27 (QP5 v5.227.12220.39754) */
CREATE OR REPLACE FORCE VIEW MCRE_OWN.V_MCREI_APP_LOG
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
       FROM T_MCREI_WRK_AUDIT_APPLICATIVO
      WHERE DTA_INS > TRUNC (SYSDATE)
   ORDER BY DTA_INS DESC;
