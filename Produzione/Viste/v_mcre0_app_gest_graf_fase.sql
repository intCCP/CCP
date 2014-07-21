/* Formatted on 17/06/2014 18:02:00 (QP5 v5.227.12220.39754) */
CREATE OR REPLACE FORCE VIEW MCRE_OWN.V_MCRE0_APP_GEST_GRAF_FASE
(
   COD_ABI_CARTOLARIZZATO,
   COD_NDG,
   COD_MACROSTATO,
   COD_AZIONE,
   DTA_INSERIMENTO,
   TOT_AZIONI,
   FLG_ESITO,
   FLG_STATUS,
   FLG_SG,
   DTA_SCADENZA,
   NOTE
)
AS
   SELECT X.COD_ABI_CARTOLARIZZATO,
          X.COD_NDG,
          X.COD_MACROSTATO,
          TO_CHAR (A.ID_FASE_GESTIONE) AS COD_AZIONE,
          A.DTA_INS AS DTA_INSERIMENTO,
          A.TOT_AZIONI,
          A.FLG_ESITO_POSITIVO AS FLG_ESITO,
          A.FLG_COMPLETATA AS FLG_STATUS,
          CASE
             WHEN (X.FLG_GRUPPO_ECONOMICO = '0' AND X.FLG_GRUPPO_LEGAME = '0')
             THEN
                'S'
             WHEN (X.FLG_GRUPPO_ECONOMICO = '1' OR X.FLG_GRUPPO_LEGAME = '1')
             THEN
                'G'
             ELSE
                NULL
          END
             FLG_SG,
          A.DTA_SCADENZA,
          A.NOTE
     FROM V_MCRE0_APP_UPD_FIELDS_P1 X,
          T_MCRE0_APP_GEST_POSIZIONE G,
          (SELECT R.*,
                  COUNT (
                     *)
                  OVER (
                     PARTITION BY R.COD_ABI_CARTOLARIZZATO,
                                  R.COD_NDG,
                                  R.ID_FASE_GESTIONE)
                     TOT_AZIONI
             FROM T_MCRE0_APP_GEST_PRATICA_FASI R
            WHERE     R.ID_FASE_GESTIONE IN (SELECT CL.COD_TIPO
                                               FROM T_MCRE0_CL_GEST CL
                                              WHERE CL.VAL_UTILIZZO = 'FASE')
                  AND R.FLG_DELETE = 'N') A
    WHERE     X.COD_ABI_CARTOLARIZZATO = G.COD_ABI_CARTOLARIZZATO
          AND G.COD_ABI_CARTOLARIZZATO = A.COD_ABI_CARTOLARIZZATO
          AND X.COD_NDG = G.COD_NDG
          AND G.COD_NDG = A.COD_NDG
          AND X.COD_MACROSTATO = G.COD_MACROSTATO
          AND G.COD_MACROSTATO = A.COD_MACROSTATO
          AND G.FLG_DELETE = 'N';


GRANT SELECT ON MCRE_OWN.V_MCRE0_APP_GEST_GRAF_FASE TO MCRE_USR;
