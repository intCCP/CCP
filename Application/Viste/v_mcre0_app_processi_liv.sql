CREATE OR REPLACE FORCE VIEW V_MCRE0_APP_PROCESSI_LIV
(
   COD_ABI,
   COD_PROCESSO,
   DESC_PROCESSO,
   TIP_PROCESSO,
   COD_PROCESSO_LIV,
   DESC_PROCESSO_LIV,
   COD_LIVELLO,
   VAL_ORDINE
)
AS
   SELECT COD_ABI,
          COD_PROCESSO,
          DESC_PROCESSO,
          TIP_PROCESSO,
          COD_PROCESSO_LIV,
          DESC_PROCESSO_LIV,
          COD_LIVELLO,
          VAL_ORDINE
     FROM (        -- V1 0412 versione oparametrica da interrogare per livello
           SELECT                      --v2140723 MM ordino per val ordine asc
                 p.cod_abi,
                  p.cod_processo,
                  p.desc_processo,
                  p.tip_processo,
                  p1.cod_processo cod_processo_liv,
                  p1.desc_processo desc_processo_liv,
                  p1.tip_processo cod_livello,
                  p1.val_ordine,
                  MIN (
                     p1.val_ordine)
                  OVER (
                     PARTITION BY p.cod_abi, p.cod_processo, p1.tip_processo)
                     primo
             FROM t_mcre0_cl_processi p, t_mcre0_cl_processi p1
            WHERE     p.cod_abi = p1.cod_abi
                  AND p.cod_div = p1.cod_div
                  AND p.tip_credito = p1.tip_credito
                  AND p.flg_attivostorico = 'A'
                  AND p1.flg_attivostorico = 'A')
    WHERE val_ordine = primo;