/* Formatted on 21/07/2014 18:44:21 (QP5 v5.227.12220.39754) */
CREATE OR REPLACE FORCE VIEW MCRE_OWN.V_MCRES_FEN_SINTESI_GESTIONE
(
   ID_DPER,
   COD_ABI,
   VAL_ANNOMESE,
   COD_LABEL,
   VAL_TOT_NDG,
   VAL_GBV,
   VAL_NBV
)
AS
     SELECT                                            --  20130930 VG id_dper
           id_dper,
            cod_abi,
            SUBSTR (id_dper, 1, 6) val_annomese,
            cod_label,
            SUM (num_ndg) val_tot_ndg,
            SUM (val_gbv) val_gbv,
            SUM (val_nbv) val_nbv
       FROM (SELECT a.cod_abi,
                    a.id_dper,
                    a.num_ndg,
                    a.cod_filiale_area,
                    CASE
                       WHEN so.cod_livello IN ('PL', 'RC') THEN 1
                       WHEN so.cod_livello IN ('IC', 'IP') THEN 2
                       ELSE 3
                    END
                       cod_label,
                    a.val_gbv,
                    a.val_nbv
               FROM (  SELECT cod_abi,
                              id_dper,
                              COUNT (cod_ndg) num_ndg,
                              cod_filiale_area,
                              SUM (val_gbv) val_gbv,
                              SUM (val_nbv) val_nbv
                         FROM (  SELECT cod_abi,
                                        id_dper,
                                        cod_ndg,
                                        cod_filiale_area,
                                        SUM (val_uti_ret) val_gbv,
                                        SUM (val_att) val_nbv
                                   FROM t_mcres_app_sisba_cp
                                  WHERE     1 = 1
                                        AND cod_stato_rischio = 'S'
                                        AND val_firma != 'FIRMA'
                               GROUP BY cod_abi,
                                        id_dper,
                                        cod_ndg,
                                        cod_filiale_area)
                     GROUP BY cod_abi, id_dper, cod_filiale_area) a,
                    t_mcre0_app_struttura_org so
              WHERE     1 = 1
                    AND a.cod_abi = so.cod_abi_istituto(+)
                    AND a.cod_filiale_area = so.cod_struttura_competente(+))
      WHERE 1 = 1
   GROUP BY id_dper,
            cod_abi,
            SUBSTR (id_dper, 1, 6),
            cod_label;
