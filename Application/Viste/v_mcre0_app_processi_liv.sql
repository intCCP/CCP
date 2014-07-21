/* Formatted on 21/07/2014 18:34:38 (QP5 v5.227.12220.39754) */
CREATE OR REPLACE FORCE VIEW MCRE_OWN.V_MCRE0_APP_PROCESSI_LIV
(
   COD_ABI,
   COD_PROCESSO,
   DESC_PROCESSO,
   TIP_PROCESSO,
   COD_PROCESSO_LIV,
   DESC_PROCESSO_LIV,
   COD_LIVELLO
)
AS
   SELECT          -- V1 0412 versione oparametrica da interrogare per livello
         p.cod_abi,
          p.cod_processo,
          p.desc_processo,
          p.tip_processo,
          p1.cod_processo cod_processo_liv,
          p1.desc_processo desc_processo_liv,
          p1.tip_processo cod_livello
     FROM t_mcre0_cl_processi p, t_mcre0_cl_processi p1
    WHERE     p.cod_abi = p1.cod_abi
          AND p.cod_div = p1.cod_div
          AND p.tip_credito = p1.tip_credito
          AND p.flg_attivostorico = 'A'
          AND p1.flg_attivostorico = 'A';
