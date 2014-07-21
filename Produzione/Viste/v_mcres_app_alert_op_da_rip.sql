/* Formatted on 17/06/2014 18:09:30 (QP5 v5.227.12220.39754) */
CREATE OR REPLACE FORCE VIEW MCRE_OWN.V_MCRES_APP_ALERT_OP_DA_RIP
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
   SELECT 2 id_alert,
          p.cod_abi,
          p.cod_ndg,
          P.COD_MATR_PRATICA,
          P.COD_UO_PRATICA,
          O.COD_OPERAZIONE,
          O.COD_CAUSALE_OPERAZIONE,
          o.DTA_CONTABILE_OPERAZIONE,
          CASE
             WHEN ( (TRUNC (SYSDATE) - o.DTA_CONTABILE_OPERAZIONE) BETWEEN 0
                                                                       AND 2)
             THEN
                'V'
             WHEN ( (TRUNC (SYSDATE) - o.DTA_CONTABILE_OPERAZIONE) BETWEEN 3
                                                                       AND 4)
             THEN
                'A'
             WHEN ( (TRUNC (SYSDATE) - O.DTA_CONTABILE_OPERAZIONE) > 4)
             THEN
                'R'
             ELSE
                NULL
          END
             ALERT
     FROM T_MCRES_APP_PRATICHE P, T_MCRES_APP_OPERAZIONI O
    WHERE     P.FLG_ATTIVA = 1
          AND p.COD_ABI = o.COD_ABI
          AND P.COD_NDG = O.COD_NDG
          AND O.COD_STATO_OPERAZIONE IS NULL
          AND o.COD_STATO_RIPARTIZIONE IS NULL;


GRANT DELETE, INSERT, REFERENCES, SELECT, UPDATE, ON COMMIT REFRESH, QUERY REWRITE, DEBUG, FLASHBACK, MERGE VIEW ON MCRE_OWN.V_MCRES_APP_ALERT_OP_DA_RIP TO MCRE_USR;
