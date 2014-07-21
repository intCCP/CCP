/* Formatted on 21/07/2014 18:36:20 (QP5 v5.227.12220.39754) */
CREATE OR REPLACE FORCE VIEW MCRE_OWN.V_MCRE0_APP_STORICO_PL
(
   VAL_ANNO,
   COD_NUMERO_PRATICA,
   COD_ABI,
   COD_NDG,
   DESC_EVENTO,
   DTA_EVENTO,
   DESC_RIFERIMENTO
)
AS
   SELECT p.val_anno_pratica AS val_anno,                                 --PK
          p.cod_pratica AS cod_numero_pratica,
          --PK
          p.cod_abi AS cod_abi,                                           --PK
          p.cod_ndg AS cod_ndg,                                           --PK
          NULL AS desc_evento,
          NULL AS dta_evento,
          NULL AS desc_riferimento
     FROM t_mcrei_app_pratiche p;
