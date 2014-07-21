/* Formatted on 21/07/2014 18:40:16 (QP5 v5.227.12220.39754) */
CREATE OR REPLACE FORCE VIEW MCRE_OWN.V_MCREI_APP_GARANZIE
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
   SELECT DISTINCT          --0227- invertiamo garante e garantito xchè errati
          gar.cod_abi,
          gar.cod_garanzia,
          gar.cod_forma_tecnica,
          D.DESC_DOMINIO desc_forma_tecnica,
          gar.dta_perf_garanzia AS dta_perfezionamento,
          gar.cod_ndg_garante AS cod_ndg_garantito,
          gar.cod_ndg_garantito AS cod_ndg_garante,
          gar.val_imp_garanzia AS val_importo,
          DECODE (gar.cod_ndg, gar.cod_ndg_garante, 'R', 'P')
             cod_tipo_garanzia
     FROM t_mcrei_app_garanzie gar, t_mcrei_cl_domini d
    WHERE /*DA ESEGUIRE PRIMA DELLA CHIAMATA ALLA VISTA
        BEGIN dbms_application_info.set_client_info( cod_abi||cod_nsg ); END;*/
         D    .COD_DOMINIO(+) = 'FT_GARANZIA'
          AND GAR.COD_FORMA_TECNICA = D.VAL_DOMINIO(+)
          AND (id_dper, cod_abi) IN --23 marzo (si visualizzano SOLO le garanzie ricevute nell'ultimo flusso)
                 (SELECT MAX (id_dper) OVER (PARTITION BY cod_abi) last_load,
                         cod_abi
                    FROM t_mcrei_app_garanzie
                   WHERE     cod_abi =
                                SUBSTR (
                                   (SYS_CONTEXT ('userenv', 'client_info')),
                                   1,
                                   5)
                         AND cod_ndg =
                                SUBSTR (
                                   (SYS_CONTEXT ('userenv', 'client_info')),
                                   6,
                                   16));
