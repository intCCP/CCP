/* Formatted on 17/06/2014 18:12:22 (QP5 v5.227.12220.39754) */
CREATE OR REPLACE FORCE VIEW MCRE_OWN.V_MCRES_FEN_MCRD_MAINSOFGRPOSN
(
   COD_ABI,
   COD_NDG,
   COD_SNDG,
   COD_GRUPPO_ECONOMICO,
   ID_DPER,
   VAL_ANNOMESE,
   COD_SEGM_IRB,
   DTA_DECORRENZA_STATO,
   COD_STATO_GIURIDICO,
   VAL_VANTATO,
   VAL_GBV,
   VAL_NBV,
   VAL_GBV_MLT,
   VAL_NBV_MLT,
   VAL_GBV_BT,
   VAL_NBV_BT,
   VAL_GAR_REALI,
   VAL_GAR_PERSONALI,
   RN,
   VAL_RISCHIO_FIRMA,
   VAL_FIRMA
)
AS
   SELECT "COD_ABI",
          "COD_NDG",
          "COD_SNDG",
          "COD_GRUPPO_ECONOMICO",
          "ID_DPER",
          "VAL_ANNOMESE",
          "COD_SEGM_IRB",
          "DTA_DECORRENZA_STATO",
          "COD_STATO_GIURIDICO",
          "VAL_VANTATO",
          "VAL_GBV",
          "VAL_NBV",
          "VAL_GBV_MLT",
          "VAL_NBV_MLT",
          "VAL_GBV_BT",
          "VAL_NBV_BT",
          "VAL_GAR_REALI",
          "VAL_GAR_PERSONALI",
          "RN",
          "VAL_RISCHIO_FIRMA",
          "VAL_FIRMA"
     FROM (  SELECT cp.cod_abi,
                    cp.cod_ndg,
                    cp.cod_sndg,
                    gr.cod_gruppo_economico,
                    cp.id_dper,
                    SUBSTR (cp.id_dper, 1, 6) val_annomese,
                    cod_segm_irb,
                    MAX (cp.dta_decorrenza_stato) dta_decorrenza_stato,
                    UPPER (cp.cod_stato_giuridico) cod_stato_giuridico,
                    SUM (
                       CASE
                          WHEN UPPER (cp.val_firma) != 'FIRMA' THEN cp.val_vant
                          ELSE 0
                       END)
                       val_vantato,
                    SUM (
                       CASE
                          WHEN UPPER (cp.val_firma) != 'FIRMA'
                          THEN
                             cp.val_uti_ret
                          ELSE
                             0
                       END)
                       val_gbv,
                    SUM (
                       CASE
                          WHEN UPPER (cp.val_firma) != 'FIRMA' THEN cp.val_att
                          ELSE 0
                       END)
                       val_nbv,
                    SUM (
                       CASE
                          WHEN UPPER (cp.val_firma) != 'FIRMA'
                          THEN
                             cp.val_uti_ret
                          ELSE
                             0
                       END)
                       val_gbv_mlt,
                    SUM (
                       CASE
                          WHEN UPPER (cp.val_firma) != 'FIRMA' THEN cp.val_att
                          ELSE 0
                       END)
                       val_nbv_mlt,
                    SUM (
                       CASE
                          WHEN UPPER (cp.val_firma) != 'FIRMA'
                          THEN
                             cp.val_uti_ret
                          ELSE
                             0
                       END)
                       val_gbv_bt,
                    SUM (
                       CASE
                          WHEN UPPER (cp.val_firma) != 'FIRMA' THEN cp.val_att
                          ELSE 0
                       END)
                       val_nbv_bt,
                    SUM (
                       CASE
                          WHEN UPPER (cp.val_firma) != 'FIRMA'
                          THEN
                               s.val_imp_garanzia_ipotecaria
                             + s.val_imp_garanzie_pignoratizie
                          ELSE
                             0
                       END)
                       val_gar_reali,
                    SUM (
                       CASE
                          WHEN UPPER (cp.val_firma) != 'FIRMA'
                          THEN
                             s.val_imp_garanzie_personali
                          ELSE
                             0
                       END)
                       val_gar_personali,
                    ROW_NUMBER ()
                    OVER (
                       PARTITION BY cp.cod_abi, SUBSTR (cp.id_dper, 1, 6)
                       ORDER BY
                          SUBSTR (cp.id_dper, 1, 6), SUM (cp.val_uti_ret) DESC)
                       rn,
                    SUM (
                       CASE
                          WHEN UPPER (cp.val_firma) = 'FIRMA'
                          THEN
                             cp.val_uti_firma
                          ELSE
                             0
                       END)
                       val_rischio_firma,
                    UPPER (cp.val_firma) val_firma
               FROM t_mcres_st_sisba s,
                    t_mcres_st_mcrdsisbacp cp,
                    t_mcre0_app_gruppo_economico gr
              WHERE     cp.cod_abi = s.cod_abi(+)
                    AND cp.cod_ndg = s.cod_ndg(+)
                    AND cp.id_dper = s.id_dper(+)
                    AND cp.cod_rapporto = s.cod_rapporto_sisba(+)
                    AND cp.cod_sportello = s.cod_filiale_rapporto(+)
                    AND cp.cod_sndg = gr.cod_sndg(+)
                    AND UPPER (CP.COD_STATO_RISCHIO) = 'S'
           GROUP BY cp.cod_abi,
                    cp.cod_ndg,
                    cp.cod_sndg,
                    gr.cod_gruppo_economico,
                    cp.id_dper,
                    SUBSTR (cp.id_dper, 1, 6),
                    cod_segm_irb,
                    dta_decorrenza_stato,
                    UPPER (cp.cod_stato_giuridico),
                    UPPER (CP.VAL_FIRMA));


GRANT SELECT ON MCRE_OWN.V_MCRES_FEN_MCRD_MAINSOFGRPOSN TO MCRE_USR;
