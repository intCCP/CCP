/* Formatted on 17/06/2014 18:09:54 (QP5 v5.227.12220.39754) */
CREATE OR REPLACE FORCE VIEW MCRE_OWN.V_MCRES_APP_CONFERIMENTO_DIFF
(
   COD_ABI,
   COD_NDG,
   COD_SOURCE
)
AS
   (SELECT DISTINCT
           cod_abi_old cod_abi, COD_NDG_OLD cod_ndg, 'FLUSSO' cod_source
      FROM v_mcres_app_conferimento_pos
    MINUS
    SELECT DISTINCT cod_abi, cod_ndg, 'FLUSSO' cod_source
      FROM v_mcres_app_conferimento_nt)
   UNION ALL
   (SELECT DISTINCT cod_abi, cod_ndg, 'NOTIZIE' cod_source
      FROM v_mcres_app_conferimento_nt
    MINUS
    SELECT DISTINCT
           cod_abi_old cod_abi, COD_NDG_OLD cod_ndg, 'NOTIZIE' cod_source
      FROM v_mcres_app_conferimento_pos);


GRANT DELETE, INSERT, REFERENCES, SELECT, UPDATE, ON COMMIT REFRESH, QUERY REWRITE, DEBUG, FLASHBACK, MERGE VIEW ON MCRE_OWN.V_MCRES_APP_CONFERIMENTO_DIFF TO MCRE_USR;
