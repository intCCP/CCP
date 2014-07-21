/* Formatted on 21/07/2014 18:46:34 (QP5 v5.227.12220.39754) */
CREATE OR REPLACE FORCE VIEW MCRE_OWN.VOMCRE0_APP_RIO_GRAFICO_B
(
   COD_ABI_CARTOLARIZZATO,
   COD_NDG,
   COD_AZIONE,
   DTA_INSERIMENTO,
   TOT_AZIONI,
   FLG_ESITO,
   FLG_STATUS,
   FLG_SG
)
AS
   SELECT X.COD_ABI_CARTOLARIZZATO,
          X.COD_NDG,
          A.COD_AZIONE,
          A.DTA_INSERIMENTO,
          A.TOT_AZIONI,
          A.FLG_ESITO,
          A.FLG_STATUS,
          CASE
             WHEN X.FLG_GRUPPO_ECONOMICO = 0 AND X.FLG_GRUPPO_LEGAME = 0
             THEN
                'S'
             WHEN X.FLG_GRUPPO_ECONOMICO = 1 OR X.FLG_GRUPPO_LEGAME = 1
             THEN
                'G'
             ELSE
                NULL
          END
             FLG_SG
     FROM MV_MCRE0_APP_UPD_FIELD X,
          T_MCRE0_APP_RIO_GESTIONE G,
          (SELECT *
             FROM (SELECT A.*,
                          MAX (
                             DTA_INSERIMENTO)
                          OVER (
                             PARTITION BY A.COD_ABI_CARTOLARIZZATO, A.COD_NDG)
                             DTA_INSERIMENTO_LAST,
                          COUNT (
                             *)
                          OVER (
                             PARTITION BY A.COD_ABI_CARTOLARIZZATO, A.COD_NDG)
                             TOT_AZIONI
                     FROM T_MCRE0_APP_RIO_AZIONI A
                    WHERE COD_AZIONE NOT IN ('15', '16', '17'))
            WHERE DTA_INSERIMENTO = DTA_INSERIMENTO_LAST) A
    WHERE     COD_MACROSTATO = 'RIO'
          AND X.COD_ABI_CARTOLARIZZATO = G.COD_ABI_CARTOLARIZZATO
          AND X.COD_NDG = G.COD_NDG
          AND G.COD_ABI_CARTOLARIZZATO = A.COD_ABI_CARTOLARIZZATO
          AND G.COD_NDG = A.COD_NDG
          AND COD_AZIONE IN ('03', '04', '05');
