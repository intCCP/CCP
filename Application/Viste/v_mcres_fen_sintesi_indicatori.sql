/* Formatted on 21/07/2014 18:44:22 (QP5 v5.227.12220.39754) */
CREATE OR REPLACE FORCE VIEW MCRE_OWN.V_MCRES_FEN_SINTESI_INDICATORI
(
   COD_ABI,
   ID_DPER,
   COD_LIVELLO,
   COD_GRUPPO,
   COD_LABEL,
   VAL_GBV,
   VAL_NBV
)
AS
     SELECT a.cod_abi,
            a.id_dper,
            so.cod_livello,
            a.cod_gruppo,
            a.cod_label,
            SUM (a.val_gbv) val_gbv,
            SUM (a.val_nbv) val_nbv
       FROM ( /* SELECT cod_abi,
                             id_dper,
                             cod_filiale_area,
                             1 cod_gruppo,
                             cod_label_garanzie cod_label,
                             SUM (val_gbv) val_gbv,
                             SUM (val_nbv) val_nbv
                        FROM (SELECT c.cod_abi,
                                     c.id_dper,
                                     c.cod_filiale_area,
                                     c.val_uti_ret val_gbv,
                                     c.val_att val_nbv,
                                     CASE
                                        WHEN NVL (t.val_imp_garanzia_ipotecaria, 0) > 0
                                        THEN
                                           1
                                        WHEN NVL (t.val_imp_garanzie_pignoratizie, 0) >
                                                0
                                             AND NVL (t.val_imp_garanzia_ipotecaria, 0) =
                                                    0
                                        THEN
                                           2
                                        WHEN NVL (t.val_imp_garanzie_personali, 0) > 0
                                             AND NVL (t.val_imp_garanzia_ipotecaria, 0) =
                                                    0
                                             AND NVL (t.val_imp_garanzie_pignoratizie,
                                                      0) = 0
                                        THEN
                                           3
                                        WHEN (NVL (t.val_imp_garanzie_altre, 0) > 0
                                              OR NVL (t.val_imp_garanzie_altri, 0) > 0)
                                             AND NVL (t.val_imp_garanzia_ipotecaria, 0) =
                                                    0
                                             AND NVL (t.val_imp_garanzie_pignoratizie,
                                                      0) = 0
                                             AND NVL (t.val_imp_garanzie_personali, 0) =
                                                    0
                                        THEN
                                           4
                                        WHEN NVL (t.val_imp_garanzie_altre, 0) = 0
                                             AND NVL (t.val_imp_garanzie_altri, 0) = 0
                                             AND NVL (t.val_imp_garanzia_ipotecaria, 0) =
                                                    0
                                             AND NVL (t.val_imp_garanzie_pignoratizie,
                                                      0) = 0
                                             AND NVL (t.val_imp_garanzie_personali, 0) =
                                                    0
                                        THEN
                                           5
                                        ELSE
                                           NULL
                                     END
                                        cod_label_garanzie
                                FROM t_mcres_app_sisba_cp c, t_mcres_app_sisba t
                               WHERE     0 = 0
                                     AND c.cod_abi = t.cod_abi(+)
                                     AND c.cod_ndg = t.cod_ndg(+)
                                     AND c.id_dper = t.id_dper(+)
                                     AND c.cod_rapporto = t.cod_rapporto_sisba(+)
                                     AND c.cod_sportello = t.cod_filiale_rapporto(+)
                                     AND c.val_firma != 'FIRMA'
                                     AND c.cod_stato_rischio = 'S')
                    GROUP BY cod_abi,
                             id_dper,
                             cod_filiale_area,
                             cod_label_garanzie
                    ---------------------------------------------
                    UNION ALL
       */
             SELECT   cod_abi,
                      id_dper,
                      cod_filiale_area,
                      2 cod_gruppo,
                      cod_label_fasce cod_label,
                      SUM (val_gbv) val_gbv,
                      SUM (val_nbv) val_nbv
                 FROM (  SELECT c.cod_abi,
                                c.cod_ndg,
                                c.id_dper,
                                c.cod_filiale_area,
                                SUM (c.val_uti_ret) val_gbv,
                                SUM (c.val_att) val_nbv,
                                CASE
                                   WHEN SUM (c.val_uti_ret) <= 15500
                                   THEN
                                      1
                                   WHEN     SUM (c.val_uti_ret) > 15500
                                        AND SUM (c.val_uti_ret) <= 250000
                                   THEN
                                      2
                                   WHEN     SUM (c.val_uti_ret) > 250000
                                        AND SUM (c.val_uti_ret) <= 500000
                                   THEN
                                      3
                                   WHEN     SUM (c.val_uti_ret) > 500000
                                        AND SUM (c.val_uti_ret) <= 2500000
                                   THEN
                                      4
                                   WHEN SUM (c.val_uti_ret) > 2500000
                                   THEN
                                      5
                                END
                                   cod_label_fasce
                           FROM t_mcres_app_sisba_cp c
                          WHERE     0 = 0
                                AND c.val_firma != 'FIRMA'
                                AND c.cod_stato_rischio = 'S'
                       GROUP BY cod_abi,
                                cod_ndg,
                                c.cod_filiale_area,
                                id_dper)
             GROUP BY cod_abi,
                      id_dper,
                      cod_filiale_area,
                      cod_label_fasce
             ---------------------------------------------
             UNION ALL
               SELECT cod_abi,
                      id_dper,
                      cod_filiale_area,
                      3 cod_gruppo,
                      cod_label_stato_giuridico cod_label,
                      SUM (val_gbv) val_gbv,
                      SUM (val_nbv) val_nbv
                 FROM (SELECT c.cod_abi,
                              c.id_dper,
                              c.cod_filiale_area,
                              c.val_uti_ret val_gbv,
                              c.val_att val_nbv,
                              CASE
                                 WHEN UPPER (c.cod_stato_giuridico) = 'C'
                                 THEN
                                    1
                                 WHEN UPPER (c.cod_stato_giuridico) IN
                                         ('A', 'B', 'D', 'E')
                                 THEN
                                    2
                                 ELSE
                                    3
                              END
                                 cod_label_stato_giuridico
                         FROM t_mcres_app_sisba_cp c
                        WHERE     0 = 0
                              AND c.val_firma != 'FIRMA'
                              AND c.cod_stato_rischio = 'S')
             GROUP BY cod_abi,
                      id_dper,
                      cod_filiale_area,
                      cod_label_stato_giuridico) a,
            t_mcre0_app_struttura_org so
      WHERE     0 = 0
            AND a.cod_abi = so.cod_abi_istituto(+)
            AND a.cod_filiale_area = so.cod_struttura_competente(+)
   GROUP BY cod_abi,
            id_dper,
            so.cod_livello,
            cod_gruppo,
            cod_label;
