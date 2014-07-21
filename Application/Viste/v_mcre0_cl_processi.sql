/* Formatted on 21/07/2014 18:36:42 (QP5 v5.227.12220.39754) */
CREATE OR REPLACE FORCE VIEW MCRE_OWN.V_MCRE0_CL_PROCESSI (COD_PROCESSO)
AS
     SELECT DISTINCT cod_processo
       FROM t_mcre0_cl_processi
      WHERE flg_attivostorico = 'A'
   ORDER BY cod_processo;
