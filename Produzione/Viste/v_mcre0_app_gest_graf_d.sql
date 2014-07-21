/* Formatted on 17/06/2014 18:01:58 (QP5 v5.227.12220.39754) */
CREATE OR REPLACE FORCE VIEW MCRE_OWN.V_MCRE0_APP_GEST_GRAF_D
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
          A.ID_AZIONE AS COD_AZIONE,
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
          (SELECT R1.*
             FROM (SELECT R.*,
                          MAX (
                             R.DTA_INS)
                          OVER (
                             PARTITION BY R.COD_ABI_CARTOLARIZZATO, R.COD_NDG)
                             DTA_INS_LAST,
                          COUNT (
                             *)
                          OVER (
                             PARTITION BY R.COD_ABI_CARTOLARIZZATO, R.COD_NDG)
                             TOT_AZIONI
                     FROM T_MCRE0_APP_GEST_PRATICA_FASI R
                    WHERE (   R.ID_AZIONE NOT IN ('15', '16', '17')
                           OR R.ID_AZIONE IS NULL)) R1
            WHERE R1.DTA_INS = R1.DTA_INS_LAST) A
    WHERE     X.COD_ABI_CARTOLARIZZATO = G.COD_ABI_CARTOLARIZZATO
          AND G.COD_ABI_CARTOLARIZZATO = A.COD_ABI_CARTOLARIZZATO
          AND X.COD_NDG = G.COD_NDG
          AND G.COD_NDG = A.COD_NDG
          AND X.COD_MACROSTATO = G.COD_MACROSTATO
          AND G.COD_MACROSTATO = A.COD_MACROSTATO
          AND A.ID_AZIONE IN ('09', '10', '11');


GRANT SELECT ON MCRE_OWN.V_MCRE0_APP_GEST_GRAF_D TO MCRE_USR;
