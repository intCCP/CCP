/* Formatted on 17/06/2014 18:12:13 (QP5 v5.227.12220.39754) */
CREATE OR REPLACE FORCE VIEW MCRE_OWN.V_MCRES_FEN_MAIN_SOFF_GR
(
   RN,
   ID_DPER,
   COD_CLI_GE,
   VAL_VANTATO,
   VAL_GBV,
   VAL_NBV,
   VAL_GAR_REALI,
   VAL_GAR_PERSONALI
)
AS
   SELECT -- 20120917 AG  Nuova versione con cod_cli_ge e integrazione TOP_30_NT
         ROW_NUMBER () OVER (PARTITION BY id_dper ORDER BY val_gbv DESC) rn,
          id_dper,
          cod_cli_ge,
          val_vantato,
          val_gbv,
          val_nbv,
          val_gar_reali,
          val_gar_personali
     FROM (  SELECT id_dper,
                    cod_cli_ge,
                    SUM (val_vantato) val_vantato,
                    SUM (val_gbv) val_gbv,
                    SUM (val_nbv) val_nbv,
                    SUM (val_gar_reali) val_gar_reali,
                    SUM (val_gar_personali) val_gar_personali
               FROM (SELECT                         --------------------------
                           CASE
                               WHEN ge.cod_gruppo_economico IS NOT NULL
                               THEN
                                  ge.cod_gruppo_economico
                               ELSE
                                  b.cod_sndg
                            END
                               cod_cli_ge,
                            ----------------------------
                            b.id_dper,
                            b.cod_sndg,
                            ge.cod_gruppo_economico,
                            b.val_vantato,
                            b.val_gbv,
                            b.val_nbv,
                            b.val_gar_reali,
                            b.val_gar_personali
                       FROM (  SELECT cp.id_dper,
                                      cp.cod_sndg,
                                      SUM (ABS (cp.val_vant)) val_vantato,
                                      SUM (cp.val_uti_ret) val_gbv,
                                      SUM (cp.val_att) val_nbv,
                                      NVL (
                                           SUM (s.val_imp_garanzia_ipotecaria)
                                         + SUM (s.val_imp_garanzie_pignoratizie),
                                         0)
                                         val_gar_reali,
                                      NVL (SUM (s.val_imp_garanzie_personali), 0)
                                         val_gar_personali
                                 FROM t_mcres_app_sisba_cp cp,
                                      t_mcres_app_sisba s
                                WHERE     0 = 0
                                      AND cp.id_dper = s.id_dper(+)
                                      AND cp.cod_abi = s.cod_abi(+)
                                      AND cp.cod_ndg = s.cod_ndg(+)
                                      AND cp.cod_rapporto =
                                             s.cod_rapporto_sisba(+)
                                      AND cp.cod_sportello =
                                             s.cod_filiale_rapporto(+)
                             GROUP BY cp.id_dper, cp.cod_sndg
                             ---------------------------------------
                             UNION ALL
                             ---------------------------------------
                             SELECT TO_NUMBER (
                                       TO_CHAR (
                                          LAST_DAY (
                                             TO_DATE (id_dper, 'yyyymm')),
                                          'yyyymmdd'))
                                       id_dper,
                                    cod_sndg_gruppo_cliente cod_sndg,
                                    val_vantato,
                                    val_gbv,
                                    val_nbv,
                                    val_garanzie_reali val_gar_reali,
                                    val_garanzie_personali val_gar_personali
                               FROM t_mcres_app_top_30_nt
                              WHERE     0 = 0
                                    AND tipo_record = 2
                                    AND cod_stato_rischio = 'S') b,
                            t_mcre0_app_gruppo_economico ge
                      WHERE 0 = 0 AND b.cod_sndg = ge.cod_sndg(+))
              WHERE 0 = 0
           GROUP BY id_dper, cod_cli_ge)
    WHERE 0 = 0;


GRANT DELETE, INSERT, REFERENCES, SELECT, UPDATE, ON COMMIT REFRESH, QUERY REWRITE, DEBUG, FLASHBACK, MERGE VIEW ON MCRE_OWN.V_MCRES_FEN_MAIN_SOFF_GR TO MCRE_USR;
