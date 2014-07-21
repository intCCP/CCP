/* Formatted on 21/07/2014 18:30:28 (QP5 v5.227.12220.39754) */
CREATE OR REPLACE FORCE VIEW MCRE_OWN.QZV_ST_MIS_BM_RID_GBV
(
   COD_SRC,
   ID_DPER,
   DTA_COMPETENZA,
   COD_STATO_RISCHIO,
   DES_STATO_RISCHIO,
   COD_ABI,
   COD_NDG,
   VAL_GBV,
   VAL_NBV,
   FLG_FIRMA
)
AS
     SELECT 'BM' Cod_src,
            SUBSTR (cp.id_dper, 1, 6) id_dper,
            cp.id_dper dta_competenza,
            cp.cod_stato_rischio,
            'Sofferenze' des_stato_rischio,
            cp.cod_abi,
            '0' cod_ndg,
            SUM (NVL (r.val_gbv, 0) - cp.val_gbv) val_gbv,
            SUM (NVL (r.val_nbv, 0) - cp.val_nbv) val_nbv,
            2 flg_firma
       FROM (  SELECT id_dper,
                      cod_abi,
                      cod_ndg,
                      cod_stato_rischio,
                      SUM (val_uti_ret) val_gbv,
                      SUM (val_att) val_nbv
                 FROM t_mcres_app_sisba_cp
                WHERE     0 = 0
                      AND cod_stato_rischio = 'S'   --and val_firma != 'FIRMA'
                      AND id_dper = SYS_CONTEXT ('userenv', 'client_info')
             GROUP BY id_dper,
                      cod_abi,
                      cod_ndg,
                      cod_stato_rischio) cp,
            (  SELECT cod_abi,
                      cod_ndg,
                      SUM (-val_imp_gbv_iniziale) val_gbv,
                      SUM (-val_imp_nbv_iniziale) val_nbv
                 FROM t_mcres_app_rapporti
                WHERE 0 = 0
             GROUP BY cod_abi, cod_ndg) r
      WHERE 0 = 0 AND cp.cod_abi = r.cod_abi(+) AND cp.cod_ndg = r.cod_ndg(+)
   GROUP BY cp.id_dper, cp.cod_abi, cod_stato_rischio
--, cp.cod_ndg
;
