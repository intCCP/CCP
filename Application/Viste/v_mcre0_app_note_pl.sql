/* Formatted on 21/07/2014 18:34:14 (QP5 v5.227.12220.39754) */
CREATE OR REPLACE FORCE VIEW MCRE_OWN.V_MCRE0_APP_NOTE_PL
(
   VAL_ANNO,
   COD_NUMERO_PRATICA,
   COD_ABI,
   COD_NDG,
   FLG_PRATICA_AZIONI,
   VAL_NOTA,
   COD_MOTIVO
)
AS
   SELECT p.val_anno_pratica AS val_anno,
          p.cod_pratica AS cod_numero_pratica,
          p.cod_abi AS cod_abi,
          p.cod_ndg AS cod_ndg,
          'F' AS flg_pratica_azioni,
          val_nota,
          cod_motivo
     FROM t_mcrei_app_pratiche p;
