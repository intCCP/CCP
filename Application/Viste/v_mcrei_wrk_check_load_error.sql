/* Formatted on 21/07/2014 18:41:11 (QP5 v5.227.12220.39754) */
CREATE OR REPLACE FORCE VIEW MCRE_OWN.V_MCREI_WRK_CHECK_LOAD_ERROR
(
   ID_FLUSSO,
   ID_DPER,
   COD_FLUSSO,
   COD_ABI,
   SQL_CODE,
   MESSAGE
)
AS
   SELECT a.id_flusso,
          a.id_dper,
          cod_flusso,
          cod_abi,
          sql_code,
          MESSAGE
     FROM T_MCREI_WRK_ACQUISIZIONE a,
          T_MCREI_WRK_AUDIT_CARICAMENTI b,
          (SELECT MAX (id_dper) periodo_contr FROM t_mcrei_wrk_acquisizione) f
    WHERE     DTA_INIZIO IS NOT NULL
          AND DTA_FINE IS NOT NULL
          AND a.id_flusso = b.id_flusso
          AND a.cod_stato IS NULL
          AND sql_code NOT IN (0, 100, -29913, -942)
          AND a.id_dper(+) = f.periodo_contr;
