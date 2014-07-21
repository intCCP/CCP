/* Formatted on 21/07/2014 18:31:18 (QP5 v5.227.12220.39754) */
CREATE OR REPLACE FORCE VIEW MCRE_OWN.V_CL_CONTROLLI_ETL1
(
   ESITO,
   COD_FILE,
   NOME_FILE,
   TMS_FILE,
   PERIODO_RIFERIMENTO
)
AS
   SELECT a.esito,
          a.cod_file,
          a.nome_file,
          a.tms_file,
          a.periodo_riferimento
     FROM t_mcre0_cl_controlli a
    WHERE     a.id_controllo =
                 (SELECT MAX (id_controllo) FROM t_mcre0_cl_controlli)
          AND a.cod_file IS NOT NULL;
