/* Formatted on 21/07/2014 18:30:07 (QP5 v5.227.12220.39754) */
CREATE OR REPLACE FORCE VIEW MCRE_OWN.AAA_PER_RETTIFICHE_NETTE
(
   ID_DPER,
   COD_ABI,
   COD_NDG,
   DTA_PASSAGGIO_SOFF
)
AS
   SELECT ee.id_dper,
          ee.cod_abi,
          ee.cod_ndg,
          x.dta_passaggio_soff
     FROM t_mcres_app_effetti_economici ee,
          (  SELECT a.id_dper,
                    cp.cod_abi,
                    cod_ndg,
                    MAX (cp.dta_decorrenza_stato) dta_passaggio_soff
               FROM t_mcres_app_sisba_cp cp, t_mcres_app_rvn_per a
              WHERE     0 = 0
                    AND cp.id_dper = a.id_dper_cp
                    AND cp.cod_stato_rischio = 'S'
           GROUP BY a.id_dper, cp.cod_abi, cp.cod_ndg) x
    WHERE     0 = 0
          AND ee.id_dper = x.id_dper(+)
          AND ee.cod_abi = x.cod_abi(+)
          AND ee.cod_ndg = x.cod_ndg(+);
