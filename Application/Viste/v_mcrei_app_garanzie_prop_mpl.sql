/* Formatted on 21/07/2014 18:40:18 (QP5 v5.227.12220.39754) */
CREATE OR REPLACE FORCE VIEW MCRE_OWN.V_MCREI_APP_GARANZIE_PROP_MPL
(
   COD_ABI,
   COD_GARANZIA,
   COD_FORMA_TECNICA,
   DESC_FORMA_TECNICA,
   DTA_PERFEZIONAMENTO,
   COD_NDG_GARANTITO,
   COD_NDG_GARANTE,
   VAL_IMPORTO,
   COD_TIPO_GARANZIA
)
AS
   SELECT                   --0227- invertiamo garante e garantito xchè errati
         GAR.COD_ABI,
          GAR.COD_GARANZIA,
          D.VAL_DOMINIO,
          gar.DESC_FT,
          GAR.DTA_PERF AS DTA_PERFEZIONAMENTO,
          GAR.COD_NSG_GARANTE COD_NDG_GARANTE,                             -->
          g.COD_NDG_GARANTE AS COD_NDG_GARANTITO, ---> Non c'è l'NDG Garantito
          GAR.VAL_IMP_GARANZIA AS VAL_IMPORTO,
          DECODE (Gar.COD_NDG, GAR.COD_NSG_GARANTE, 'R', 'P')
             COD_TIPO_GARANZIA
     FROM T_MCREI_APP_MPL_GARANZIE GAR,
          t_mcrei_cl_domini d,
          t_mcrei_app_garanzie g
    WHERE     D.COD_DOMINIO(+) = 'FT_GARANZIA'
          AND TRIM (GAR.DESC_FT) = TRIM (D.DESC_DOMINIO)
          AND gar.cod_abi = g.cod_abi
          AND gar.cod_ndg = g.cod_ndg
          AND gar.cod_garanzia = g.cod_garanzia;
