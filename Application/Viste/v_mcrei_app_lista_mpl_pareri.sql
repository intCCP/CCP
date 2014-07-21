/* Formatted on 21/07/2014 18:40:23 (QP5 v5.227.12220.39754) */
CREATE OR REPLACE FORCE VIEW MCRE_OWN.V_MCREI_APP_LISTA_MPL_PARERI
(
   COD_ABI,
   COD_NDG,
   DESC_CAUSA_INCAGLIO,
   DESC_PROVVEDIMENTI_PRESI,
   DESC_CAUSA_SOFFERENZA,
   DESC_PROVVEDIMENTI_ASSUNTI,
   DESC_PROVVEDIMENTI_LEGALI
)
AS
   SELECT NVL (a.cod_abi, m.cod_abi) cod_abi,
          NVL (a.cod_ndg, m.cod_ndg) cod_ndg,
          CASE
             WHEN NVL (a.cod_tipo_par, m.cod_tipo_parere) = 'F01'
             THEN
                NVL (a.desc_parere, m.descr_cod_tipo_parere)
             ELSE
                NULL
          END
             AS desc_causa_incaglio,
          CASE
             WHEN NVL (a.cod_tipo_par, m.cod_tipo_parere) = 'F02'
             THEN
                NVL (a.desc_parere, m.descr_cod_tipo_parere)
             ELSE
                NULL
          END
             AS desc_provvedimenti_presi,
          CASE
             WHEN NVL (a.cod_tipo_par, m.cod_tipo_parere) = 'F01'
             THEN
                NVL (a.desc_parere, m.descr_cod_tipo_parere)
             ELSE
                NULL
          END
             AS desc_causa_sofferenza,                          -- DA RIVEDERE
          CASE
             WHEN NVL (a.cod_tipo_par, m.cod_tipo_parere) = 'A01'
             THEN
                NVL (a.desc_parere, m.descr_cod_tipo_parere)
             ELSE
                NULL
          END
             AS desc_provvedimenti_assunti,                     -- DA RIVEDERE
          CASE
             WHEN NVL (a.cod_tipo_par, m.cod_tipo_parere) = 'A07'
             THEN
                NVL (a.desc_parere, m.descr_cod_tipo_parere)
             ELSE
                NULL
          END
             AS desc_provvedimenti_legali
     FROM t_mcrei_app_pareri a, t_mcrei_app_mpl_pareri m
    WHERE a.cod_abi = m.cod_abi(+) AND a.cod_ndg = m.cod_ndg(+);
