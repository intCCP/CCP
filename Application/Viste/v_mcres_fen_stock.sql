/* Formatted on 21/07/2014 18:44:23 (QP5 v5.227.12220.39754) */
CREATE OR REPLACE FORCE VIEW MCRE_OWN.V_MCRES_FEN_STOCK
(
   ID_DPER,
   COD_ABI,
   VAL_ANNOMESE,
   FLG_GAR_REALI_PERSONALI,
   FLG_GAR_REALI,
   VAL_TOT_NDG,
   VAL_VANTATO,
   VAL_GBV,
   VAL_NBV
)
AS
     SELECT                                            --  20130930 VG id_dper
           id_dper,
            cod_abi,
            SUBSTR (id_dper, 1, 6) val_annomese,
            0 flg_gar_reali_personali,
            0 flg_gar_reali,
            COUNT (DISTINCT (cod_ndg)) val_tot_ndg,
            SUM (val_vant) val_vantato,
            SUM (val_uti_ret) val_gbv,
            SUM (val_att) val_nbv
       FROM t_mcres_app_sisba_cp cp
      WHERE cp.val_firma != 'FIRMA' AND cp.cod_stato_rischio = 'S'
   GROUP BY COD_ABI, ID_DPER;
