/* Formatted on 21/07/2014 18:39:12 (QP5 v5.227.12220.39754) */
CREATE OR REPLACE FORCE VIEW MCRE_OWN.V_MCREI_APP_COINTESTATARI
(
   COD_SNDG,
   COD_SNDG_COINT,
   COD_ABI_COINT,
   COD_NDG_COINT,
   DESC_NOME_CONTROPARTE,
   COD_TIPO_LEGAME
)
AS
   SELECT leg.cod_sndg,
          leg.cod_sndg_legame AS cod_sndg_coint,
          f.cod_abi_cartolarizzato AS cod_abi_coint,
          f.cod_ndg AS cod_ndg_coint,
          a.desc_nome_controparte,
          leg.cod_legame AS cod_tipo_legame
     FROM ( (SELECT a.cod_sndg, a.cod_sndg_legame, a.cod_legame
               FROM t_mcrei_app_legame_cointest a)
           UNION ALL
           (SELECT c.cod_sndg_legame, c.cod_sndg, c.cod_legame
              FROM t_mcrei_app_legame_cointest c)) leg,
          t_mcrei_app_file_guida_coint f,
          t_mcrei_app_anagr_gruppo_coint a
    WHERE     leg.cod_sndg_legame = f.cod_sndg
          AND leg.cod_sndg_legame = a.cod_sndg;
