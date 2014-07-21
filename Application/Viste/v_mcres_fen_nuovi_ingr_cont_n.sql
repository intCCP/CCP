/* Formatted on 21/07/2014 18:44:01 (QP5 v5.227.12220.39754) */
CREATE OR REPLACE FORCE VIEW MCRE_OWN.V_MCRES_FEN_NUOVI_INGR_CONT_N
(
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
     SELECT cod_abi,
            val_annomese,
            0 FLG_GAR_REALI_PERSONALI,
            0 FLG_GAR_REALI,
            COUNT (DISTINCT (cod_ndg)) VAL_TOT_NDG,
            SUM (val_vant) VAL_VANTATO,
            SUM (val_uti_ret) val_gbv,
            SUM (val_att) val_nbv
       FROM (SELECT cp.cod_abi,
                    SUBSTR (cp.id_dper, 1, 6) val_annomese,
                    cp.cod_ndg,
                    cp.val_uti_ret,
                    cp.val_att,
                    cp.val_vant,
                    s.val_imp_garanzie_personali,
                    s.val_imp_garanzia_ipotecaria,
                    s.val_imp_garanzie_pignoratizie
               FROM t_mcres_app_sisba_cp cp, T_MCRES_APP_SISBA S
              WHERE     cp.cod_abi = s.cod_abi(+)
                    AND cp.cod_ndg = s.cod_ndg(+)
                    AND cp.id_dper = s.id_dper(+)
                    AND cp.cod_rapporto = s.cod_rapporto_sisba(+)
                    AND cp.cod_sportello = s.cod_filiale_rapporto(+)
                    AND cp.val_firma != 'FIRMA'
                    AND CP.COD_STATO_RISCHIO = 'S'
                    AND TO_CHAR (cp.dta_decorrenza_stato, 'YYYY') =
                           SUBSTR (cp.id_dper, 1, 4))
   GROUP BY cod_abi, val_annomese
   UNION ALL
     SELECT cod_abi,
            val_annomese,
            1 FLG_GAR_REALI_PERSONALI,
            1 FLG_GAR_REALI,
            COUNT (DISTINCT (cod_ndg)) tot_ndg,
            SUM (val_vant) VAL_VANTATO,
            SUM (val_uti_ret) val_gbv,
            SUM (val_att) val_nbv
       FROM (SELECT cp.cod_abi,
                    SUBSTR (cp.id_dper, 1, 6) val_annomese,
                    cp.cod_ndg,
                    cp.val_uti_ret,
                    cp.val_att,
                    cp.val_vant,
                    s.val_imp_garanzie_personali,
                    s.val_imp_garanzia_ipotecaria,
                    s.val_imp_garanzie_pignoratizie
               FROM t_mcres_app_sisba_cp cp, T_MCRES_APP_SISBA S
              WHERE     cp.cod_abi = s.cod_abi(+)
                    AND cp.cod_ndg = s.cod_ndg(+)
                    AND cp.id_dper = s.id_dper(+)
                    AND cp.cod_rapporto = s.cod_rapporto_sisba(+)
                    AND cp.cod_sportello = s.cod_filiale_rapporto(+)
                    AND cp.val_firma != 'FIRMA'
                    AND CP.COD_STATO_RISCHIO = 'S'
                    AND TO_CHAR (cp.dta_decorrenza_stato, 'YYYY') =
                           SUBSTR (cp.id_dper, 1, 4))
      WHERE    NVL (val_imp_garanzie_personali, 0) > 0
            OR NVL (val_imp_garanzia_ipotecaria, 0) > 0
            OR NVL (val_imp_garanzie_pignoratizie, 0) > 0
   GROUP BY cod_abi, val_annomese
   UNION ALL
     SELECT cod_abi,
            val_annomese,
            0 FLG_GAR_REALI_PERSONALI,
            1 FLG_GAR_REALI,
            COUNT (DISTINCT (cod_ndg)) VAL_TOT_NDG,
            SUM (val_vant) val_vantato,
            SUM (val_uti_ret) val_gbv,
            SUM (val_att) val_nbv
       FROM (SELECT cp.cod_abi,
                    SUBSTR (cp.id_dper, 1, 6) val_annomese,
                    cp.cod_ndg,
                    cp.val_uti_ret,
                    cp.val_att,
                    cp.val_vant,
                    s.val_imp_garanzie_personali,
                    s.val_imp_garanzia_ipotecaria,
                    s.val_imp_garanzie_pignoratizie
               FROM t_mcres_app_sisba_cp cp, T_MCRES_APP_SISBA S
              WHERE     cp.cod_abi = s.cod_abi(+)
                    AND cp.cod_ndg = s.cod_ndg(+)
                    AND cp.id_dper = s.id_dper(+)
                    AND cp.cod_rapporto = s.cod_rapporto_sisba(+)
                    AND cp.cod_sportello = s.cod_filiale_rapporto(+)
                    AND cp.val_firma != 'FIRMA'
                    AND CP.COD_STATO_RISCHIO = 'S'
                    AND TO_CHAR (cp.dta_decorrenza_stato, 'YYYY') =
                           SUBSTR (cp.id_dper, 1, 4))
      WHERE    NVL (val_imp_garanzie_pignoratizie, 0) > 0
            OR NVL (val_imp_garanzia_ipotecaria, 0) > 0
   GROUP BY COD_ABI, val_annomese;
