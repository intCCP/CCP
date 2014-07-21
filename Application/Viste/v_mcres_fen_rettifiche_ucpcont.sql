/* Formatted on 21/07/2014 18:44:20 (QP5 v5.227.12220.39754) */
CREATE OR REPLACE FORCE VIEW MCRE_OWN.V_MCRES_FEN_RETTIFICHE_UCPCONT
(
   COD_ABI,
   ID_DPER,
   VAL_DRC_ULTIMO_MESE_CONT
)
AS
     SELECT                                                    --AG 14/12/2011
           ee.cod_abi,
            ee.id_dper,
            SUM (
                 (ee.val_per_ce + ee.val_rett_sval + ee.val_rett_att)
               - (  ee.val_rip_mora
                  + ee.val_quota_sval
                  + ee.val_quota_att
                  + ee.val_rip_sval
                  + ee.val_rip_att
                  + ee.val_attualizzazione)
               - (  (n.val_gbv_iniziale - val_nbv_iniziale)
                  - (n.val_gbv_prec - n.val_nbv_prec)))
               val_drc_ultimo_mese_cont
       FROM t_mcres_app_effetti_economici ee,
            (SELECT p.cod_abi,
                    p.cod_ndg,
                    p.val_annomese_delibera,
                    r.val_gbv_iniziale,
                    r.val_nbv_iniziale,
                    cp.val_gbv_prec,
                    cp.val_nbv_prec
               FROM (SELECT DISTINCT
                            cod_abi,
                            cod_ndg,
                            TO_CHAR (dta_inserimento_delibera, 'YYYYMM')
                               val_annomese_delibera
                       FROM t_mcres_app_delibere
                      WHERE cod_delibera = 'NS') p,
                    (  SELECT cod_abi,
                              cod_ndg,
                              SUM (-val_imp_gbv_iniziale) val_gbv_iniziale,
                              SUM (-val_imp_nbv_iniziale) val_nbv_iniziale
                         FROM t_mcres_app_rapporti
                     GROUP BY cod_abi, cod_ndg) r,
                    (  SELECT cod_abi,
                              cod_ndg,
                              id_dper,
                              SUM (val_uti_ret) val_gbv_prec,
                              SUM (val_att) val_nbv_prec
                         FROM t_mcres_app_sisba_cp
                        WHERE     0 = 0
                              AND cod_stato_rischio IN ('S', 'I')
                              AND val_firma != 'FIRMA'
                     GROUP BY cod_abi, cod_ndg, id_dper) cp
              WHERE     0 = 0
                    AND p.cod_abi = r.cod_abi
                    AND p.cod_ndg = r.cod_ndg
                    AND p.cod_abi = cp.cod_abi
                    AND p.cod_ndg = cp.cod_ndg
                    AND TO_CHAR (TO_DATE (val_annomese_delibera, 'YYYYMM') - 1,
                                 'YYYYMMDD') = cp.id_dper
                    AND r.val_gbv_iniziale > r.val_nbv_iniziale --delta iniziale posistivo
                    AND cp.val_gbv_prec > cp.val_nbv_prec --delta mese precedente positivo
                                                         ) n
      WHERE     0 = 0
            AND ee.cod_abi = n.cod_abi
            AND ee.cod_ndg = n.cod_ndg
            AND ee.id_dper =
                   TO_CHAR (
                      LAST_DAY (TO_DATE (n.val_annomese_delibera, 'YYYYMM')),
                      'YYYYMMDD')
   GROUP BY ee.cod_abi, ee.id_dper;
