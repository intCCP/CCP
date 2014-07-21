/* Formatted on 17/06/2014 18:03:51 (QP5 v5.227.12220.39754) */
CREATE OR REPLACE FORCE VIEW MCRE_OWN.V_MCRE0_APP_RIO_GRAFICO_A
(
   COD_ABI_CARTOLARIZZATO,
   COD_NDG,
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
          A2.COD_AZIONE,
          A2.DTA_INSERIMENTO,
          0 TOT_AZIONI,
          A2.FLG_ESITO,
          A2.FLG_STATUS,
          CASE
             WHEN X.FLG_GRUPPO_ECONOMICO = '0' AND X.FLG_GRUPPO_LEGAME = '0'
             THEN
                'S'
             WHEN X.FLG_GRUPPO_ECONOMICO = '1' OR X.FLG_GRUPPO_LEGAME = '1'
             THEN
                'G'
             ELSE
                NULL
          END
             FLG_SG,
          a2.dta_scadenza,
          a2.note
     FROM V_MCRE0_APP_UPD_FIELDS_P1 X,
          T_MCRE0_APP_RIO_GESTIONE G,
          (SELECT *
             FROM (SELECT A.*,
                          CASE
                             WHEN     LAST_VALUE (
                                         COD_AZIONE)
                                      OVER (
                                         PARTITION BY A.COD_ABI_CARTOLARIZZATO,
                                                      A.COD_NDG
                                         ORDER BY DTA_INSERIMENTO DESC) =
                                         '15'
                                  AND COUNT (
                                         *)
                                      OVER (
                                         PARTITION BY A.COD_ABI_CARTOLARIZZATO,
                                                      A.COD_NDG) = 1
                             THEN
                                '15'
                             WHEN     LAST_VALUE (
                                         COD_AZIONE)
                                      OVER (
                                         PARTITION BY A.COD_ABI_CARTOLARIZZATO,
                                                      A.COD_NDG
                                         ORDER BY DTA_INSERIMENTO DESC) =
                                         '16'
                                  AND COUNT (
                                         *)
                                      OVER (
                                         PARTITION BY A.COD_ABI_CARTOLARIZZATO,
                                                      A.COD_NDG) = 1
                             THEN
                                '16'
                             WHEN     LAST_VALUE (
                                         COD_AZIONE)
                                      OVER (
                                         PARTITION BY A.COD_ABI_CARTOLARIZZATO,
                                                      A.COD_NDG
                                         ORDER BY DTA_INSERIMENTO DESC) =
                                         '17'
                                  AND COUNT (
                                         *)
                                      OVER (
                                         PARTITION BY A.COD_ABI_CARTOLARIZZATO,
                                                      A.COD_NDG) = 1
                             THEN
                                '17'
                             ELSE
                                (SELECT COD_AZIONE
                                   FROM (SELECT DISTINCT
                                                DTA_INSERIMENTO,
                                                COD_AZIONE,
                                                COD_ABI_CARTOLARIZZATO,
                                                COD_NDG,
                                                MAX (
                                                   DTA_INSERIMENTO)
                                                OVER (
                                                   PARTITION BY A1.COD_ABI_CARTOLARIZZATO,
                                                                A1.COD_NDG)
                                                   DTA_INSERIMENTO_MAX
                                           FROM T_MCRE0_APP_RIO_AZIONI A1
                                          WHERE     A1.COD_AZIONE NOT IN
                                                       ('15', '16', '17')
                                                AND a1.flg_delete = 0) A2
                                  WHERE     DTA_INSERIMENTO =
                                               DTA_INSERIMENTO_MAX
                                        AND A2.COD_ABI_CARTOLARIZZATO =
                                               A.COD_ABI_CARTOLARIZZATO
                                        AND A2.COD_NDG = A.COD_NDG)
                          END
                             COD_AZIONE_ULTIMA
                     FROM T_MCRE0_APP_RIO_AZIONI A
                    WHERE flg_delete = 0)
            WHERE COD_AZIONE = COD_AZIONE_ULTIMA) A2
    WHERE     COD_MACROSTATO = 'RIO'
          AND X.COD_ABI_CARTOLARIZZATO = G.COD_ABI_CARTOLARIZZATO(+)
          AND X.COD_NDG = G.COD_NDG(+)
          AND G.COD_ABI_CARTOLARIZZATO = A2.COD_ABI_CARTOLARIZZATO(+)
          AND G.COD_NDG = A2.COD_NDG(+)
          AND NVL (A2.COD_AZIONE, '01') IN ('01', '02', '15', '16', '17');


GRANT DELETE, INSERT, REFERENCES, SELECT, UPDATE, ON COMMIT REFRESH, QUERY REWRITE, DEBUG, FLASHBACK, MERGE VIEW ON MCRE_OWN.V_MCRE0_APP_RIO_GRAFICO_A TO MCRE_USR;
