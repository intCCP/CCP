/* Formatted on 21/07/2014 18:44:02 (QP5 v5.227.12220.39754) */
CREATE OR REPLACE FORCE VIEW MCRE_OWN.V_MCRES_FEN_NUOVI_INGR_CONT_NW
(
   COD_ABI,
   VAL_TOT_NDG,
   NUM_NDG_OVER,
   NUM_NDG_UNDER,
   VAL_NUM_NDG_CR,
   VAL_GBV,
   VAL_GBV_OVER,
   VAL_GBV_UNDER,
   VAL_GBV_CR,
   VAL_INDICE_COPERTURA
)
AS
     SELECT                                                   -- AG 30/12/2011
           cod_abi,
            SUM (1) val_tot_ndg,
            SUM (flg_soglia_gbv) num_ndg_over,
            SUM (DECODE (flg_soglia_gbv, 0, 1, 0)) num_ndg_under,
            SUM (flg_cr) val_num_ndg_cr,
            SUM (val_gbv) val_gbv,
            SUM (DECODE (flg_soglia_gbv, 1, val_gbv, 0)) val_gbv_over,
            SUM (DECODE (flg_soglia_gbv, 0, val_gbv, 0)) val_gbv_under,
            SUM (DECODE (flg_cr, 1, val_gbv, 0)) val_gbv_cr,
            1 - (SUM (val_nbv_rapporti) / SUM (val_gbv_rapporti))
               val_indice_copertura
       FROM (SELECT t.cod_abi,
                    t.cod_ndg,
                    t.val_gbv_rapporti,
                    t.val_nbv_rapporti,
                      NVL (t.val_gbv_rapporti, 0)
                    + NVL (t.val_gbv_pcr, 0)
                    - t.val_gbv_mople_meno
                    - t.val_gbv_mlt_meno
                       val_gbv,
                    --            case
                    --                when t.val_nbv_rapporti is not null
                    --                    then t.val_nbv_rapporti
                    --                when t.val_nbv_cp < nvl(t.val_gbv_rapporti,0) + nvl(t.val_gbv_pcr,0) - t.val_gbv_mople_meno - t.val_gbv_mlt_meno
                    --                    then t.val_nbv_cp
                    --                else
                    --                    nvl(t.val_gbv_rapporti,0) + nvl(t.val_gbv_pcr,0) - t.val_gbv_mople_meno - t.val_gbv_mlt_meno
                    --            end val_nbv,
                    CASE
                       WHEN   NVL (t.val_gbv_rapporti, 0)
                            + NVL (t.val_gbv_pcr, 0)
                            - t.val_gbv_mople_meno
                            - t.val_gbv_mlt_meno >= 250000
                       THEN
                          1
                       ELSE
                          0
                    END
                       flg_soglia_gbv,
                    NVL2 (n.cod_ndg, 1, 0) flg_cr
               FROM (  SELECT pp.cod_abi,
                              pp.cod_ndg,
                              pp.dta_rif_pcr,
                              pp.val_gbv_pcr,
                              rr.val_gbv_rapporti,
                              SUM (DECODE (r.cod_ssa, 'MO', -r.val_imp_gbv, 0))
                                 val_gbv_mople_meno,
                              SUM (
                                 DECODE (r.cod_ssa,
                                         'M0', -r.val_imp_gbv,
                                         'MI', -r.val_imp_gbv,
                                         0))
                                 val_gbv_mlt_meno,
                              rr.val_nbv_rapporti                          --,
                         --cp.val_nbv_cp
                         FROM (SELECT p.cod_abi,
                                      p.val_annomese,
                                      p.cod_ndg,
                                      NVL (pcr.dta_riferimento,
                                           TO_DATE ('00010101', 'YYYYMMDD'))
                                         dta_rif_pcr,
                                      NVL (pcr.val_gbv_pcr, 0) val_gbv_pcr
                                 FROM (SELECT p.cod_abi,
                                              u.val_annomese,
                                              p.cod_ndg,
                                              p.cod_stato_rischio,
                                              p.dta_passaggio_soff
                                         FROM t_mcres_app_posizioni p,
                                              (  SELECT cod_abi,
                                                        MAX (dta_dper) dta_dper,
                                                        MAX (val_annomese)
                                                           val_annomese
                                                   FROM v_mcres_ultima_acq_bilancio
                                               GROUP BY cod_abi) u
                                        WHERE     0 = 0
                                              AND p.cod_abi = u.cod_abi
                                              AND p.cod_stato_rischio = 'S'
                                              AND p.flg_attiva = 1
                                              AND p.dta_passaggio_soff >
                                                     u.dta_dper) p,
                                      (SELECT cod_abi_istituto cod_abi,
                                              cod_ndg,
                                              dta_riferimento,
                                              val_imp_uti_cli val_gbv_pcr
                                         FROM t_mcre0_app_pcr_sc_sb
                                        WHERE cod_forma_tecnica = 'SO') pcr
                                WHERE     0 = 0
                                      AND p.cod_abi = pcr.cod_abi(+)
                                      AND p.cod_ndg = pcr.cod_ndg(+)) pp,
                              (  SELECT cod_abi,
                                        cod_ndg,
                                        SUM (-val_imp_gbv) val_gbv_rapporti,
                                        SUM (-val_imp_nbv) val_nbv_rapporti
                                   FROM t_mcres_app_rapporti
                               GROUP BY cod_abi, cod_ndg) rr,
                              --                    (
                              --                        select
                              --                            scp.cod_abi,
                              --                            scp.cod_ndg,
                              --                            sum(scp.val_att) val_nbv_cp
                              --                        from
                              --                            t_mcres_app_sisba_cp scp,
                              --                            (
                              --                                select
                              --                                    cod_abi,
                              --                                    max(id_dper) id_dper
                              --                                from
                              --                                    v_mcres_ultima_acq_bilancio
                              --                                group by
                              --                                    cod_abi
                              --                            ) u
                              --                        where 0=0
                              --                            and scp.cod_abi = u.cod_abi
                              --                            and scp.id_dper = u.id_dper
                              --        --                    and scp.cod_stato_rischio = 'S' ---SERVE!?!?!?!
                              --        --                    and scp.val_firma != 'FIRMA'    ---SERVE!?!?!?!?
                              --                        group by
                              --                            scp.cod_abi,
                              --                            scp.cod_ndg
                              --                    ) cp
                              --                    ,
                              t_mcres_app_rapporti r
                        WHERE     0 = 0
                              AND pp.cod_abi = rr.cod_abi(+)
                              AND pp.cod_ndg = rr.cod_ndg(+)
                              --                    and pp.cod_abi = cp.cod_abi(+)
                              --                    and pp.cod_ndg = cp.cod_ndg(+)
                              AND pp.cod_abi = r.cod_abi(+)
                              AND pp.cod_ndg = r.cod_ndg(+)
                              AND pp.dta_rif_pcr > r.dta_apertura_rapp(+)
                     GROUP BY pp.cod_abi,
                              pp.cod_ndg,
                              pp.dta_rif_pcr,
                              pp.val_gbv_pcr,
                              rr.val_gbv_rapporti,
                              rr.val_nbv_rapporti                          --,
                                                 --cp.val_nbv_cp
                    ) t,
                    t_mcres_app_notizie n
              WHERE     0 = 0
                    AND t.cod_abi = n.cod_abi(+)
                    AND t.cod_ndg = n.cod_ndg(+)
                    AND n.cod_tipo_notizia(+) = '50'
                    AND n.dta_fine_validita(+) =
                           TO_DATE ('99991231', 'YYYYMMDD'))
      WHERE 0 = 0
   GROUP BY cod_abi;
