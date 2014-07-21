/* Formatted on 21/07/2014 18:43:42 (QP5 v5.227.12220.39754) */
CREATE OR REPLACE FORCE VIEW MCRE_OWN.V_MCRES_FEN_MAIN_SOFF
(
   COD_ABI,
   ID_DPER,
   COD_NDG,
   DTA_DECORRENZA_STATO,
   DTA_CHIUSURA,
   FLG_TIPO,
   VAL_GBV,
   VAL_NBV,
   VAL_GBV_INCASSI,
   VAL_NBV_INCASSI,
   VAL_ANNOMESE,
   COD_SNDG,
   "SYSDATE"
)
AS
   SELECT "COD_ABI",
          "ID_DPER",
          "COD_NDG",
          "DTA_DECORRENZA_STATO",
          "DTA_CHIUSURA",
          "FLG_TIPO",
          "VAL_GBV",
          "VAL_NBV",
          "VAL_GBV_INCASSI",
          "VAL_NBV_INCASSI",
          "VAL_ANNOMESE",
          "COD_SNDG",
          "SYSDATE"
     FROM (SELECT cod_abi,
                  id_dper,
                  cod_ndg,
                  dta_decorrenza_stato,
                  TO_DATE ('99991231', 'YYYYMMDD') dta_chiusura,
                  'ST' flg_tipo,
                  VAL_GBV,
                  val_nbv,
                  NULL val_gbv_incassi,
                  NULL val_nbv_incassi,
                  val_annomese,
                  cod_sndg,
                  SYSDATE
             FROM (SELECT cod_abi,
                          id_dper,
                          val_annomese,
                          cod_ndg,
                          cod_sndg,
                          val_gbv,
                          val_nbv,
                          dta_decorrenza_stato,
                          flg_da_contabilizzare,
                          rn_idc,
                          rn_stk
                     FROM (SELECT a.*,
                                  ROW_NUMBER ()
                                  OVER (
                                     PARTITION BY cod_abi,
                                                  val_annomese,
                                                  flg_da_contabilizzare
                                     ORDER BY val_gbv DESC)
                                     rn_idc,
                                  ROW_NUMBER ()
                                  OVER (PARTITION BY cod_abi, val_annomese
                                        ORDER BY val_gbv DESC)
                                     rn_stk
                             FROM (  SELECT CP.COD_ABI,
                                            TO_CHAR (id_dper) id_dper,
                                            TO_CHAR (cp.dta_sisba_cp, 'YYYYMM')
                                               val_annomese,
                                            cp.cod_ndg,
                                            cp.cod_sndg,
                                            SUM (cp.val_uti_ret) val_gbv,
                                            SUM (cp.val_att) val_nbv,
                                            MIN (cp.dta_decorrenza_stato)
                                               dta_decorrenza_stato,
                                            CASE
                                               WHEN MIN (
                                                       cp.dta_decorrenza_stato) BETWEEN TO_DATE (
                                                                                              TO_CHAR (
                                                                                                 dta_sisba_cp,
                                                                                                 'YYYY')
                                                                                           || '0101',
                                                                                           'YYYYMMDD')
                                                                                    AND dta_sisba_cp
                                               THEN
                                                  1
                                               ELSE
                                                  0
                                            END
                                               flg_da_contabilizzare
                                       FROM t_mcres_app_sisba_cp cp
                                      WHERE     cp.val_firma != 'FIRMA'
                                            AND cod_stato_rischio = 'S'
                                   GROUP BY cp.cod_abi,
                                            id_dper,
                                            cp.cod_ndg,
                                            cp.cod_sndg,
                                            cp.dta_sisba_cp) a)
                    WHERE    (rn_idc <= 50 AND flg_da_contabilizzare = 1)
                          OR rn_stk <= 50)
            WHERE rn_stk <= 50
           UNION ALL
           SELECT cod_abi,
                  id_dper,
                  cod_ndg,
                  dta_decorrenza_stato,
                  TO_DATE ('99991231', 'YYYYMMDD') dta_chiusura,
                  'CO' flg_tipo,
                  val_gbv,
                  val_nbv,
                  NULL val_gbv_incassi,
                  NULL val_nbv_incassi,
                  val_annomese,
                  cod_sndg,
                  SYSDATE
             FROM (SELECT cod_abi,
                          id_dper,
                          val_annomese,
                          cod_ndg,
                          cod_sndg,
                          val_gbv,
                          val_nbv,
                          dta_decorrenza_stato,
                          flg_da_contabilizzare,
                          rn_idc,
                          rn_stk
                     FROM (SELECT a.*,
                                  ROW_NUMBER ()
                                  OVER (
                                     PARTITION BY cod_abi,
                                                  val_annomese,
                                                  flg_da_contabilizzare
                                     ORDER BY val_gbv DESC)
                                     rn_idc,
                                  ROW_NUMBER ()
                                  OVER (PARTITION BY cod_abi, val_annomese
                                        ORDER BY val_gbv DESC)
                                     rn_stk
                             FROM (  SELECT cp.cod_abi,
                                            TO_CHAR (id_dper) id_dper,
                                            TO_CHAR (cp.dta_sisba_cp, 'YYYYMM')
                                               val_annomese,
                                            cp.cod_ndg,
                                            cp.cod_sndg,
                                            SUM (cp.val_uti_ret) val_gbv,
                                            SUM (cp.val_att) val_nbv,
                                            MIN (cp.dta_decorrenza_stato)
                                               dta_decorrenza_stato,
                                            CASE
                                               WHEN MIN (
                                                       cp.dta_decorrenza_stato) BETWEEN TO_DATE (
                                                                                              TO_CHAR (
                                                                                                 dta_sisba_cp,
                                                                                                 'YYYY')
                                                                                           || '0101',
                                                                                           'YYYYMMDD')
                                                                                    AND dta_sisba_cp
                                               THEN
                                                  1
                                               ELSE
                                                  0
                                            END
                                               flg_da_contabilizzare
                                       FROM T_MCRES_APP_SISBA_CP CP
                                      WHERE     cp.val_firma != 'FIRMA'
                                            AND cod_stato_rischio = 'S'
                                   GROUP BY cp.cod_abi,
                                            id_dper,
                                            cp.cod_ndg,
                                            cp.cod_sndg,
                                            cp.dta_sisba_cp) a)
                    WHERE    (rn_idc <= 50 AND flg_da_contabilizzare = 1)
                          OR rn_stk <= 50)
            WHERE flg_da_contabilizzare = 1
           UNION ALL
           SELECT cod_abi,
                  id_dper,
                  cod_ndg,
                  dta_passaggio_soff dta_decorrenza_stato,
                  TO_DATE ('99991231', 'YYYYMMDD') dta_chiusura,
                  'DC' flg_tipo,
                  val_gbv,
                  val_nbv,
                  NULL val_gbv_incassi,
                  NULL val_nbv_incassi,
                  val_annomese,
                  cod_sndg,
                  SYSDATE
             FROM v_mcres_fen_main_soff_idc
           UNION ALL
           SELECT cod_abi,
                  id_dper,
                  cod_ndg,
                  NULL dta_decorrenza_stato,
                  dta_chiusura,
                  'US' flg_tipo,
                  val_gbv,
                  val_nbv,
                  val_gbv_incassi,
                  val_nbv_incassi,
                  val_annomese,
                  cod_sndg,
                  SYSDATE
             FROM V_MCRES_FEN_MAIN_SOFF_CHIUSE);
