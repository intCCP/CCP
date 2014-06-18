/* Formatted on 17/06/2014 18:01:54 (QP5 v5.227.12220.39754) */
CREATE OR REPLACE FORCE VIEW MCRE_OWN.V_MCRE0_APP_GEST_GRAF_A
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
          0 AS TOT_AZIONI,
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
          (SELECT R3.*
             FROM (SELECT R2.COD_ABI_CARTOLARIZZATO,
                          R2.COD_MACROSTATO,
                          R2.COD_NDG,
                          R2.DTA_INS,
                          R2.DTA_SCADENZA,
                          R2.FLG_COMPLETATA,
                          R2.FLG_ESITO_POSITIVO,
                          NVL (R2.ID_AZIONE, R2.ID_FASE_GESTIONE)
                             AS ID_AZIONE,
                          R2.NOTE,
                          CASE
                             WHEN     LAST_VALUE (
                                         NVL (R2.ID_AZIONE,
                                              R2.ID_FASE_GESTIONE))
                                      OVER (
                                         PARTITION BY R2.COD_ABI_CARTOLARIZZATO,
                                                      R2.COD_NDG
                                         ORDER BY R2.DTA_INS DESC) = '15'
                                  AND COUNT (
                                         *)
                                      OVER (
                                         PARTITION BY R2.COD_ABI_CARTOLARIZZATO,
                                                      R2.COD_NDG) = 1
                             THEN
                                '15'
                             WHEN     LAST_VALUE (
                                         NVL (R2.ID_AZIONE,
                                              R2.ID_FASE_GESTIONE))
                                      OVER (
                                         PARTITION BY R2.COD_ABI_CARTOLARIZZATO,
                                                      R2.COD_NDG
                                         ORDER BY R2.DTA_INS DESC) = '16'
                                  AND COUNT (
                                         *)
                                      OVER (
                                         PARTITION BY R2.COD_ABI_CARTOLARIZZATO,
                                                      R2.COD_NDG) = 1
                             THEN
                                '16'
                             WHEN     LAST_VALUE (
                                         NVL (R2.ID_AZIONE,
                                              R2.ID_FASE_GESTIONE))
                                      OVER (
                                         PARTITION BY R2.COD_ABI_CARTOLARIZZATO,
                                                      R2.COD_NDG
                                         ORDER BY R2.DTA_INS DESC) = '17'
                                  AND COUNT (
                                         *)
                                      OVER (
                                         PARTITION BY R2.COD_ABI_CARTOLARIZZATO,
                                                      R2.COD_NDG) = 1
                             THEN
                                '17'
                             ELSE
                                (SELECT R1.ID_AZIONE
                                   FROM (SELECT DISTINCT
                                                R.DTA_INS,
                                                NVL (R.ID_AZIONE,
                                                     R.ID_FASE_GESTIONE)
                                                   AS ID_AZIONE,
                                                R.COD_ABI_CARTOLARIZZATO,
                                                R.COD_NDG,
                                                MAX (
                                                   R.DTA_INS)
                                                OVER (
                                                   PARTITION BY R.COD_ABI_CARTOLARIZZATO,
                                                                R.COD_NDG)
                                                   DTA_INS_MAX
                                           FROM T_MCRE0_APP_GEST_PRATICA_FASI R
                                          WHERE     (   R.ID_AZIONE NOT IN
                                                           ('15', '16', '17')
                                                     OR R.ID_AZIONE IS NULL)
                                                AND R.FLG_DELETE = 'N') R1
                                  WHERE     R1.DTA_INS = R1.DTA_INS_MAX
                                        AND R1.COD_ABI_CARTOLARIZZATO =
                                               R2.COD_ABI_CARTOLARIZZATO
                                        AND R1.COD_NDG = R2.COD_NDG)
                          END
                             ID_AZIONE_ULTIMA
                     FROM T_MCRE0_APP_GEST_PRATICA_FASI R2
                    WHERE R2.FLG_DELETE = 'N') R3
            WHERE R3.ID_AZIONE = R3.ID_AZIONE_ULTIMA) A
    WHERE     X.COD_ABI_CARTOLARIZZATO = G.COD_ABI_CARTOLARIZZATO(+)
          AND G.COD_ABI_CARTOLARIZZATO = A.COD_ABI_CARTOLARIZZATO(+)
          AND X.COD_NDG = G.COD_NDG(+)
          AND G.COD_NDG = A.COD_NDG(+)
          AND X.COD_MACROSTATO = G.COD_MACROSTATO(+)
          AND G.COD_MACROSTATO = A.COD_MACROSTATO(+)
          AND NVL (A.ID_AZIONE, '01') IN ('01', '02', '15', '16', '17');


GRANT SELECT ON MCRE_OWN.V_MCRE0_APP_GEST_GRAF_A TO MCRE_USR;
