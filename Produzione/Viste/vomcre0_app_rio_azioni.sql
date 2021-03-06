/* Formatted on 17/06/2014 18:14:03 (QP5 v5.227.12220.39754) */
CREATE OR REPLACE FORCE VIEW MCRE_OWN.VOMCRE0_APP_RIO_AZIONI
(
   COD_ABI_CARTOLARIZZATO,
   COD_GRUPPO_ECONOMICO,
   COD_NDG,
   ID_AZIONE,
   DTA_INSERIMENTO,
   DTA_SCADENZA,
   FLG_STATUS,
   NOTE,
   COD_AZIONE,
   FLG_ESITO,
   COD_MACROSTATO,
   COD_STATO,
   DESCRIZIONE_AZIONE
)
AS
   SELECT A.COD_ABI_CARTOLARIZZATO,
          X.COD_GRUPPO_ECONOMICO,
          A.COD_NDG,
          A.ID_AZIONE,
          A.DTA_INSERIMENTO,
          A.DTA_SCADENZA,
          A.FLG_STATUS,
          A.NOTE,
          A.COD_AZIONE,
          A.FLG_ESITO,
          X.COD_MACROSTATO,
          X.COD_STATO,
          T.DESCRIZIONE_AZIONE
     FROM T_MCRE0_APP_RIO_AZIONI A,
          MV_MCRE0_APP_UPD_FIELD X,
          T_MCRE0_CL_RIO_AZIONI T
    WHERE     A.COD_ABI_CARTOLARIZZATO = X.COD_ABI_CARTOLARIZZATO
          AND A.COD_NDG = X.COD_NDG
          AND T.COD_AZIONE = A.COD_AZIONE;


GRANT DELETE, INSERT, REFERENCES, SELECT, UPDATE, ON COMMIT REFRESH, QUERY REWRITE, DEBUG, FLASHBACK, MERGE VIEW ON MCRE_OWN.VOMCRE0_APP_RIO_AZIONI TO MCRE_USR;
