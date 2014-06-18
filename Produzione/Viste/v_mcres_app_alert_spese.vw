/* Formatted on 17/06/2014 18:09:43 (QP5 v5.227.12220.39754) */
CREATE OR REPLACE FORCE VIEW MCRE_OWN.V_MCRES_APP_ALERT_SPESE
(
   ID_ALERT,
   COD_ABI,
   COD_NDG,
   COD_UO_PRATICA,
   COD_MATR_PRATICA,
   COD_AUTORIZZAZIONE,
   DTA_SPESA,
   ALERT
)
AS
   SELECT DISTINCT                            ---- 20120207 VG: Nuova SP spese
          6 id_alert,
          S.cod_abi,
          S.cod_ndg,
          S.COD_UO_PRATICA,
          S.COD_MATR_PRATICA,
          S.COD_AUTORIZZAZIONE,
          S.DTA_AUTORIZZAZIONE dta_spesa,
          CASE
             WHEN ( (TRUNC (SYSDATE) - S.DTA_AUTORIZZAZIONE) BETWEEN 0 AND 7)
             THEN
                'V'
             WHEN ( (TRUNC (SYSDATE) - S.DTA_AUTORIZZAZIONE) BETWEEN 8 AND 30)
             THEN
                'A'
             WHEN ( (TRUNC (SYSDATE) - S.DTA_AUTORIZZAZIONE) > 30)
             THEN
                'R'
             ELSE
                NULL
          END
             ALERT
     FROM V_MCRES_APP_SOSPESI S;


GRANT DELETE, INSERT, REFERENCES, SELECT, UPDATE, ON COMMIT REFRESH, QUERY REWRITE, DEBUG, FLASHBACK, MERGE VIEW ON MCRE_OWN.V_MCRES_APP_ALERT_SPESE TO MCRE_USR;
