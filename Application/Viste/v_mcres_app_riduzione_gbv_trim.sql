/* Formatted on 21/07/2014 18:42:54 (QP5 v5.227.12220.39754) */
CREATE OR REPLACE FORCE VIEW MCRE_OWN.V_MCRES_APP_RIDUZIONE_GBV_TRIM
(
   COD_LABEL_TRIM,
   VAL_RIDUZIONE_GBV
)
AS
   WITH rapp
        AS (  SELECT t.cod_label_trim,
                     SUM (r.val_imp_gbv_iniziale) val_imp_gbv_iniziale
                FROM t_mcres_app_rapporti r,
                     t_mcres_app_posizioni p,
                     v_mcres_app_lista_trimestri t
               WHERE     r.cod_abi = p.cod_abi
                     AND r.cod_ndg = p.cod_ndg
                     AND LAST_DAY (TO_DATE (t.cod_label_trim, 'YYYYMM')) BETWEEN p.dta_passaggio_soff
                                                                             AND p.dta_chiusura
            GROUP BY t.cod_label_trim),
        sisba_cp
        AS (  SELECT t.cod_label_trim, SUM (r.val_uti_ret) val_imp_gbv_finale
                FROM t_mcres_app_sisba_cp r,
                     t_mcres_app_posizioni p,
                     v_mcres_app_lista_trimestri t
               WHERE     r.cod_abi = p.cod_abi
                     AND r.cod_ndg = p.cod_ndg
                     AND r.cod_stato_rischio = 'S'
                     AND TO_CHAR (
                            LAST_DAY (TO_DATE (t.cod_label_trim, 'YYYYMM')),
                            'YYYYMMDD') = r.id_dper
            GROUP BY t.cod_label_trim)
   SELECT rapp.cod_label_trim,
          val_imp_gbv_iniziale - val_imp_gbv_finale val_riduzione_gbv
     FROM rapp, sisba_cp
    WHERE rapp.cod_label_trim = sisba_cp.cod_label_trim;
