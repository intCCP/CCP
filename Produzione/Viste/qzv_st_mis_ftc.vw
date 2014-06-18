/* Formatted on 17/06/2014 17:59:07 (QP5 v5.227.12220.39754) */
CREATE OR REPLACE FORCE VIEW MCRE_OWN.QZV_ST_MIS_FTC
(
   COD_STATO_RISCHIO,
   COD_ABI,
   COD_NDG,
   COD_FORMA_TECNICA,
   NUM_RAPPORTI,
   NUM_POSIZIONI
)
AS
     SELECT 'S' cod_stato_rischio,
            COD_ABI,
            COD_NDG,
            CASE
               WHEN NVL (R.FLG_CONFIDI, 'N') = 'S' THEN 'C'
               WHEN NVL (R.FLG_AGEVOLATO, 'N') = 'S' THEN 'G'
               WHEN NVL (R.FLG_CONTRIBUTO, 'N') = 'S' THEN 'R'
               WHEN NVL (R.FLG_RAPP_CARTOLARIZZATO, 'N') = 'S' THEN 'Z'
               WHEN NVL (R.FLG_RAPP_FONDO_TERZO, 'N') = 'S' THEN 'T'
               ELSE 'A'
            END
               cod_forma_tecnica,
            COUNT (DISTINCT COD_RAPPORTO) num_rapporti,
            COUNT (DISTINCT COD_ABI || COD_NDG) num_posizioni
       FROM mcre_own.T_MCRES_APP_RAPPORTI r
   GROUP BY COD_ABI,
            COD_NDG,
            CASE
               WHEN NVL (R.FLG_CONFIDI, 'N') = 'S' THEN 'C'
               WHEN NVL (R.FLG_AGEVOLATO, 'N') = 'S' THEN 'G'
               WHEN NVL (R.FLG_CONTRIBUTO, 'N') = 'S' THEN 'R'
               WHEN NVL (R.FLG_RAPP_CARTOLARIZZATO, 'N') = 'S' THEN 'Z'
               WHEN NVL (R.FLG_RAPP_FONDO_TERZO, 'N') = 'S' THEN 'T'
               ELSE 'A'
            END;


GRANT DELETE, INSERT, REFERENCES, SELECT, UPDATE, ON COMMIT REFRESH, QUERY REWRITE, DEBUG, FLASHBACK, MERGE VIEW ON MCRE_OWN.QZV_ST_MIS_FTC TO MCRE_USR;
