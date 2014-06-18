/* Formatted on 17/06/2014 18:08:18 (QP5 v5.227.12220.39754) */
CREATE OR REPLACE FORCE VIEW MCRE_OWN.V_MCREI_APP_GARANZIE_PROPOSTA
(
   COD_ABI,
   COD_NDG,
   COD_PROTOCOLLO_DELIBERA,
   COD_PROTOCOLLO_PACCHETTO,
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
         g.cod_abi,
          g.cod_ndg,
          g.cod_protocollo_delibera,
          g.cod_protocollo_pacchetto,
          g.cod_garanzia,
          d.val_dominio,
          TRIM (NVL (gar.desc_ft, d.desc_dominio)),
          NVL (g.DTA_PERF_GARANZIA, gar.dta_perf) AS dta_perfezionamento,
          NVL (g.cod_ndg_garante, gar.COD_NSG_GARANTE) cod_ndg_garante,    -->
          g.cod_ndg_garantito AS cod_ndg_garantito, ---> Non c'è l'NDG Garantito
          NVL (g.val_imp_garanzia, gar.val_imp_garanzia) AS val_importo,
          DECODE (g.cod_ndg, g.cod_ndg_garante, 'R', 'P') cod_tipo_garanzia
     FROM t_mcrei_app_mpl_garanzie gar,
          t_mcrei_cl_domini d,
          t_mcrei_app_garanzie_proposte g
    WHERE     d.cod_dominio(+) = 'FT_GARANZIA'
          AND g.cod_forma_tecnica = d.val_dominio(+)
          AND gar.cod_abi(+) = g.cod_abi
          AND gar.cod_ndg(+) = g.cod_ndg
          AND gar.cod_garanzia(+) = g.cod_garanzia;


GRANT DELETE, INSERT, REFERENCES, SELECT, UPDATE, ON COMMIT REFRESH, QUERY REWRITE, DEBUG, FLASHBACK, MERGE VIEW ON MCRE_OWN.V_MCREI_APP_GARANZIE_PROPOSTA TO MCRE_USR;
