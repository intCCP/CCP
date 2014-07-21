/* Formatted on 17/06/2014 18:12:33 (QP5 v5.227.12220.39754) */
CREATE OR REPLACE FORCE VIEW MCRE_OWN.V_MCRES_FEN_MCRD_VAR_STOCK
(
   COD_ABI,
   ID_DPER,
   DTA_RIF,
   VAL_TOT_NDG,
   VAL_GBV,
   VAL_VAR_AUMENTO,
   VAL_VAR_DIMINUZIONE,
   VAL_INCASSI
)
AS
   SELECT                                                      --AG 16/11/2011
          --AG 12/03/2012
          cp.cod_abi,
          cp.id_dper,
          cp.dta_rif,
          cp.val_tot_ndg,
          cp.val_gbv,
          m.val_var_aumento,
          m.val_var_diminuzione,
          m.val_incassi
     FROM (  SELECT cod_abi,
                    id_dper,
                    TO_DATE (id_dper, 'YYYYMMDD') dta_rif,
                    COUNT (DISTINCT cod_ndg) val_tot_ndg,
                    SUM (val_uti_ret) val_gbv
               FROM t_mcres_app_mcrdsisbacp
              WHERE cod_stato_rischio = 'S' AND val_firma != 'FIRMA'
           GROUP BY cod_abi, id_dper, TO_DATE (id_dper, 'YYYYMMDD')) cp,
          (  SELECT cod_abi,
                    id_dper,
                    SUM (
                       CASE
                          WHEN desc_modulo IN
                                  ('ALL.1 - NUOVE SOFFERENZE DA INCAGLIO',
                                   'ALL.2 - NUOVE SOFFERENZE DA BONIS',
                                   'ALL.3 - ADDEBITI SU SOFFERENZE')
                          THEN
                             val_cr_tot
                          ELSE
                             0
                       END)
                       val_var_aumento,
                    SUM (
                       CASE
                          WHEN desc_modulo IN
                                  ('ALL.4 - SOFFERENZE TRASFERITE AD INCAGLIO',
                                   'ALL.5 - SOFFERENZE TRASFERITE A BONIS',
                                   'ALL.6 - SOFFERENZE ESTINTE',
                                   'ALL.7 - SOFFERENZE RIDOTTE',
                                   'ALL.8 - STRALCI SU SOFFERENZE')
                          THEN
                             val_cr_tot
                          ELSE
                             0
                       END)
                       val_var_diminuzione,
                    SUM (
                       CASE
                          WHEN desc_modulo IN
                                  ('ALL.6 - SOFFERENZE ESTINTE',
                                   'ALL.7 - SOFFERENZE RIDOTTE')
                          THEN
                             val_cr_tot
                          ELSE
                             0
                       END)
                       val_incassi
               FROM t_mcres_app_mcrdmodmov
           GROUP BY cod_abi, id_dper) m
    WHERE cp.cod_abi = m.cod_abi(+) AND cp.id_dper = m.id_dper(+);


GRANT SELECT ON MCRE_OWN.V_MCRES_FEN_MCRD_VAR_STOCK TO MCRE_USR;
