/* Formatted on 21/07/2014 18:44:24 (QP5 v5.227.12220.39754) */
CREATE OR REPLACE FORCE VIEW MCRE_OWN.V_MCRES_FEN_STOCK_POS
(
   COD_ABI,
   COD_NDG,
   COD_SNDG,
   COD_FILIALE_AREA,
   VAL_ANNOMESE,
   FLG_GAR_REALI_PERSONALI,
   FLG_GAR_REALI,
   VAL_TOT_NDG,
   VAL_VANTATO,
   VAL_GBV,
   VAL_NBV,
   VAL_GARANZIE_REALI_PERSONALI,
   VAL_GARANZIE_REALI,
   RN
)
AS
     SELECT cod_abi,
            cod_ndg,
            cod_sndg,
            COD_FILIALE_AREA,
            val_annomese,
            0 flg_gar_reali_personali,
            0 flg_gar_reali,
            COUNT (DISTINCT (cod_ndg)) val_tot_ndg,
            SUM (val_vant) val_vantato,
            SUM (val_uti_ret) val_gbv,
            SUM (val_att) val_nbv,
            SUM (
                 VAL_IMP_GARANZIE_PERSONALI
               + val_imp_garanzia_ipotecaria
               + VAL_IMP_GARANZIE_PIGNORATIZIE)
               VAL_GARANZIE_REALI_PERSONALI,
            SUM (val_imp_garanzia_ipotecaria + val_imp_garanzie_pignoratizie)
               val_garanzie_reali,
            ROW_NUMBER ()
            OVER (PARTITION BY COD_ABI, val_annomese
                  ORDER BY val_annomese, SUM (val_uti_ret) DESC)
               RN
       FROM (SELECT CP.COD_ABI,
                    SUBSTR (cp.id_dper, 1, 6) val_annomese,
                    cp.cod_ndg,
                    cp.cod_sndg,
                    CP.COD_FILIALE_AREA,
                    cp.val_vant,
                    cp.val_uti_ret,
                    cp.val_att,
                    s.val_imp_garanzie_personali,
                    s.val_imp_garanzia_ipotecaria,
                    s.val_imp_garanzie_pignoratizie
               FROM T_MCRES_APP_SISBA_CP CP, t_mcres_app_sisba s
              WHERE     cp.cod_abi = s.cod_abi(+)
                    AND cp.cod_ndg = s.cod_ndg(+)
                    AND cp.id_dper = s.id_dper(+)
                    AND cp.cod_rapporto = s.cod_rapporto_sisba(+)
                    AND cp.cod_sportello = s.cod_filiale_rapporto(+)
                    AND cp.val_firma != 'FIRMA'
                    AND CP.COD_STATO_RISCHIO = 'S')
   GROUP BY COD_ABI,
            cod_ndg,
            cod_sndg,
            COD_FILIALE_AREA,
            VAL_ANNOMESE;
