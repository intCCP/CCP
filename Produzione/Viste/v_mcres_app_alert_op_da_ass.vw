/* Formatted on 17/06/2014 18:09:29 (QP5 v5.227.12220.39754) */
CREATE OR REPLACE FORCE VIEW MCRE_OWN.V_MCRES_APP_ALERT_OP_DA_ASS
(
   ID_ALERT,
   COD_ABI,
   COD_NDG,
   COD_MATR_PRATICA,
   COD_UO_PRATICA,
   COD_OPERAZIONE,
   COD_CAUSALE_OPERAZIONE,
   DTA_CONTABILE_OPERAZIONE,
   ALERT
)
AS
   SELECT 1 id_alert,
          p.cod_abi,
          p.cod_ndg,
          P.COD_MATR_PRATICA,
          P.COD_UO_PRATICA,
          O.COD_OPERAZIONE,
          O.COD_CAUSALE_OPERAZIONE,
          DTA_CONTABILE_OPERAZIONE,
          CASE
             WHEN ( (TRUNC (SYSDATE) - o.DTA_CONTABILE_OPERAZIONE) BETWEEN 0
                                                                       AND 7)
             THEN
                'V'
             WHEN ( (TRUNC (SYSDATE) - o.DTA_CONTABILE_OPERAZIONE) BETWEEN 8
                                                                       AND 30)
             THEN
                'A'
             WHEN ( (TRUNC (SYSDATE) - o.DTA_CONTABILE_OPERAZIONE) > 30)
             THEN
                'R'
             ELSE
                NULL
          END
             ALERT
     FROM T_MCRES_APP_PRATICHE P,
          T_MCRES_APP_posizioni z,
          T_MCRES_APP_OPERAZIONI O
    WHERE     P.FLG_ATTIVA = 1
          AND z.FLG_ATTIVA = 1
          AND p.COD_ABI = z.COD_ABI
          AND P.COD_NDG = z.COD_NDG
          AND p.COD_ABI = o.COD_ABI
          AND P.COD_NDG = O.COD_NDG
          AND p.COD_MATR_PRATICA IS NOT NULL
          AND O.COD_STATO_OPERAZIONE IS NULL
          AND o.COD_STATO_RIPARTIZIONE = 'CO'
          AND o.val_importo_operazione >= 0
          AND o.cod_rapporto <> '99999999999999999'
          AND o.dta_contabile_operazione >
                 TO_DATE ('01/01/2006', 'dd/mm/yyyy')
          AND o.dta_contabile_operazione >= z.dta_passaggio_soff
          AND (   o.cod_operazione_fattibile = 'RATIN'
               OR o.cod_causale_operazione <> '068');


GRANT DELETE, INSERT, REFERENCES, SELECT, UPDATE, ON COMMIT REFRESH, QUERY REWRITE, DEBUG, FLASHBACK, MERGE VIEW ON MCRE_OWN.V_MCRES_APP_ALERT_OP_DA_ASS TO MCRE_USR;
