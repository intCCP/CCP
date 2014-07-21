/* Formatted on 17/06/2014 18:12:31 (QP5 v5.227.12220.39754) */
CREATE OR REPLACE FORCE VIEW MCRE_OWN.V_MCRES_FEN_MCRD_SININDICATORI
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
       FROM (  SELECT cod_abi,
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
                           FROM t_mcres_app_mcrdsisbacp c
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
                         FROM t_mcres_app_mcrdsisbacp c
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


GRANT SELECT ON MCRE_OWN.V_MCRES_FEN_MCRD_SININDICATORI TO MCRE_USR;
