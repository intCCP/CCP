/* Formatted on 17/06/2014 18:12:25 (QP5 v5.227.12220.39754) */
CREATE OR REPLACE FORCE VIEW MCRE_OWN.V_MCRES_FEN_MCRD_PTF
(
   COD_ABI,
   COD_NDG,
   ID_DPER,
   VAL_ANNOMESE,
   COD_MATR_PRATICA,
   COD_UO_PRATICA,
   COD_PRESIDIO,
   VAL_NUM_RAPPORTI,
   VAL_VANTATO,
   VAL_GBV,
   VAL_NBV,
   VAL_GBV_BT,
   VAL_NBV_BT,
   VAL_GBV_MLT,
   VAL_NBV_MLT,
   COD_LABEL_STATO_GIURIDICO,
   COD_LABEL_ANZIANITA,
   COD_SEG_ECONOMICO,
   VAL_TIPO_GESTIONE,
   COD_LABEL_GARANZIE,
   VAL_INCASSI
)
AS
     SELECT DISTINCT a.cod_abi,
                     a.cod_ndg,
                     a.id_dper,
                     SUBSTR (a.id_dper, 1, 6) val_annomese,
                     SUBSTR (cod_uo_matr, 7, 7) cod_matr_pratica,
                     SUBSTR (cod_uo_matr, 1, 5) cod_uo_pratica,
                     cod_presidio,
                     COUNT (DISTINCT cod_rapporto) val_num_rapporti,
                     SUM (val_vantato) val_vantato,
                     SUM (val_gbv) val_gbv,
                     SUM (val_nbv) val_nbv,
                     SUM (val_gbv) val_gbv_bt,
                     SUM (val_nbv) val_nbv_bt,
                     SUM (val_gbv) val_gbv_mlt,
                     SUM (val_nbv) val_nbv_mlt,
                     cod_label_stato_giuridico,
                     cod_label_anzianita,
                     cod_seg_economico,
                     val_tipo_gestione,
                     cod_label_garanzie,
                     val_incassi
       FROM (SELECT /*+ parallel(s,2) parallel_index(s idx_mcres_app_sisbacp_perabi)*/
                   DISTINCT
                    c.id_dper,
                    c.cod_abi,
                    c.cod_ndg,
                    (SELECT MAX (p.cod_uo_pratica || '*' || p.cod_matr_pratica)
                       FROM t_mcres_app_pratiche p
                      WHERE     c.cod_abi = p.cod_abi
                            AND c.cod_ndg = p.cod_ndg
                            AND c.id_dper BETWEEN TO_CHAR (p.dta_apertura,
                                                           'YYYYMMDD')
                                              AND TO_CHAR (p.dta_chiusura,
                                                           'YYYYMMDD'))
                       cod_uo_matr,
                    c.cod_rapporto,
                    c.cod_sportello,
                    DECODE (r.COD_TIPO, 'P', r.COD_PRESIDIO, 'A') COD_PRESIDIO,
                    c.val_vant val_vantato,
                    c.val_uti_ret val_gbv,
                    c.val_att val_nbv,
                    CASE
                       WHEN C.VAL_FIRMA IN ('ORD', 'AGES') THEN c.val_uti_ret
                       ELSE 0
                    END
                       val_gbv_bt,
                    CASE
                       WHEN C.VAL_FIRMA IN ('AGMI', 'FOND', 'CREDIOP', 'IMI')
                       THEN
                          c.val_uti_ret
                       ELSE
                          0
                    END
                       val_gbv_mlt,
                    CASE
                       WHEN C.VAL_FIRMA IN ('ORD', 'AGES') THEN c.val_att
                       ELSE 0
                    END
                       val_nbv_bt,
                    CASE
                       WHEN C.VAL_FIRMA IN ('AGMI', 'FOND', 'CREDIOP', 'IMI')
                       THEN
                          c.val_att
                       ELSE
                          0
                    END
                       val_nbv_mlt,
                    CASE
                       WHEN c.cod_stato_giuridico = 'C'
                       THEN
                          1
                       WHEN c.cod_stato_giuridico IN ('A', 'B', 'D', 'E')
                       THEN
                          2
                       ELSE
                          3
                    END
                       cod_label_stato_giuridico,
                    CASE
                       WHEN c.dta_decorrenza_stato >= ADD_MONTHS (SYSDATE, -12)
                       THEN
                          1
                       WHEN c.dta_decorrenza_stato BETWEEN ADD_MONTHS (SYSDATE,
                                                                       -24)
                                                       AND ADD_MONTHS (SYSDATE,
                                                                       -12)
                       THEN
                          2
                       WHEN c.dta_decorrenza_stato BETWEEN ADD_MONTHS (SYSDATE,
                                                                       -48)
                                                       AND ADD_MONTHS (SYSDATE,
                                                                       -24)
                       THEN
                          3
                       WHEN c.dta_decorrenza_stato BETWEEN ADD_MONTHS (SYSDATE,
                                                                       -72)
                                                       AND ADD_MONTHS (SYSDATE,
                                                                       -48)
                       THEN
                          4
                       WHEN c.dta_decorrenza_stato BETWEEN ADD_MONTHS (SYSDATE,
                                                                       -96)
                                                       AND ADD_MONTHS (SYSDATE,
                                                                       -72)
                       THEN
                          5
                       WHEN c.dta_decorrenza_stato BETWEEN ADD_MONTHS (SYSDATE,
                                                                       -120)
                                                       AND ADD_MONTHS (SYSDATE,
                                                                       -96)
                       THEN
                          6
                       WHEN c.dta_decorrenza_stato < ADD_MONTHS (SYSDATE, -120)
                       THEN
                          7
                       ELSE
                          8
                    END
                       cod_label_anzianita,
                    s.cod_seg_economico,
                    DECODE (r.COD_TIPO, 'P', r.val_tipo_gestione, 'A')
                       val_tipo_gestione,
                    CASE
                       WHEN NVL (t.val_imp_garanzia_ipotecaria, 0) > 0
                       THEN
                          1
                       WHEN     NVL (t.val_imp_garanzie_pignoratizie, 0) > 0
                            AND NVL (t.val_imp_garanzia_ipotecaria, 0) = 0
                       THEN
                          2
                       WHEN     NVL (t.val_imp_garanzie_personali, 0) > 0
                            AND NVL (t.val_imp_garanzia_ipotecaria, 0) = 0
                            AND NVL (t.val_imp_garanzie_pignoratizie, 0) = 0
                       THEN
                          3
                       WHEN     (   NVL (t.val_imp_garanzie_altre, 0) > 0
                                 OR NVL (t.val_imp_garanzie_altri, 0) > 0)
                            AND NVL (t.val_imp_garanzia_ipotecaria, 0) = 0
                            AND NVL (t.val_imp_garanzie_pignoratizie, 0) = 0
                            AND NVL (t.val_imp_garanzie_personali, 0) = 0
                       THEN
                          4
                       WHEN     NVL (t.val_imp_garanzie_altre, 0) = 0
                            AND NVL (t.val_imp_garanzie_altri, 0) = 0
                            AND NVL (t.val_imp_garanzia_ipotecaria, 0) = 0
                            AND NVL (t.val_imp_garanzie_pignoratizie, 0) = 0
                            AND NVL (t.val_imp_garanzie_personali, 0) = 0
                       THEN
                          5
                    END
                       cod_label_garanzie
               FROM t_mcres_app_mcrdsisbacp c,
                    t_mcres_app_sisba t,
                    t_mcres_cl_seg_regolamentari s,
                    v_mcres_app_lista_strutture r
              WHERE     NVL (c.cod_segm_irb, 0) = s.cod_seg_regolamentare(+)
                    AND c.cod_filiale_area = r.cod_presidio(+)
                    AND c.cod_stato_rischio = 'S'
                    AND c.val_firma != 'FIRMA'
                    AND c.cod_abi = t.cod_abi(+)
                    AND c.cod_ndg = t.cod_ndg(+)
                    AND c.id_dper = t.id_dper(+)
                    AND c.cod_rapporto = t.cod_rapporto_sisba(+)
                    AND c.cod_sportello = t.cod_filiale_rapporto(+)) a,
            (  SELECT cod_abi,
                      cod_ndg,
                      id_dper,
                      SUM (
                         CASE
                            WHEN UPPER (desc_modulo) IN
                                    (SELECT DISTINCT desc_modulo
                                       FROM t_mcres_cl_mcrdmodmov
                                      WHERE     val_source = 'MCRD'
                                            AND UPPER (val_sottotipologia) =
                                                   'INCASSO')          -- MCRD
                            THEN
                               val_cr_tot
                            ELSE
                               0
                         END)
                         val_incassi
                 FROM t_mcres_app_mcrdmodmov
             GROUP BY cod_abi, cod_ndg, id_dper) mov
      WHERE     a.cod_abi = mov.cod_abi(+)
            AND a.cod_ndg = mov.cod_ndg(+)
            AND a.id_dper = mov.id_dper(+)
   GROUP BY a.cod_abi,
            a.cod_ndg,
            a.id_dper,
            SUBSTR (cod_uo_matr, 7, 7),                    --cod_matr_pratica,
            SUBSTR (cod_uo_matr, 1, 5),                      --cod_uo_pratica,
            cod_presidio,
            cod_label_stato_giuridico,
            cod_label_anzianita,
            cod_seg_economico,
            val_tipo_gestione,
            cod_label_garanzie,
            val_incassi;


GRANT SELECT ON MCRE_OWN.V_MCRES_FEN_MCRD_PTF TO MCRE_USR;
