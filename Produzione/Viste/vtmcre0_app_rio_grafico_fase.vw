/* Formatted on 17/06/2014 18:16:50 (QP5 v5.227.12220.39754) */
CREATE OR REPLACE FORCE VIEW MCRE_OWN.VTMCRE0_APP_RIO_GRAFICO_FASE
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
          A.COD_AZIONE,
          A.DTA_INSERIMENTO,
          A.TOT_AZIONI,
          A.FLG_ESITO,
          A.FLG_STATUS,
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
          a.dta_scadenza,
          a.note
     FROM VTMCRE0_APP_UPD_FIELDS_P1 X,
          T_MCRE0_APP_RIO_GESTIONE G,
          (SELECT r.*,
                  COUNT (
                     *)
                  OVER (
                     PARTITION BY r.COD_ABI_CARTOLARIZZATO,
                                  r.COD_NDG,
                                  r.cod_azione)
                     TOT_AZIONI
             FROM T_MCRE0_APP_RIO_AZIONI r
            WHERE     cod_azione IN (SELECT LPAD (TO_CHAR (cod_tipo), 2, '0')
                                       FROM t_mcre0_cl_rio
                                      WHERE val_utilizzo = 'FASE')
                  AND r.flg_delete = 0) a
    WHERE     COD_MACROSTATO = 'RIO'
          AND X.COD_ABI_CARTOLARIZZATO = G.COD_ABI_CARTOLARIZZATO
          AND X.COD_NDG = G.COD_NDG
          AND G.COD_ABI_CARTOLARIZZATO = A.COD_ABI_CARTOLARIZZATO
          AND G.COD_NDG = A.COD_NDG
          AND g.flg_delete = 0;


GRANT DELETE, INSERT, REFERENCES, SELECT, UPDATE, ON COMMIT REFRESH, QUERY REWRITE, DEBUG, FLASHBACK ON MCRE_OWN.VTMCRE0_APP_RIO_GRAFICO_FASE TO MCRE_USR;
