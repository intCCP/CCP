/* Formatted on 21/07/2014 18:42:16 (QP5 v5.227.12220.39754) */
CREATE OR REPLACE FORCE VIEW MCRE_OWN.V_MCRES_APP_INDICI_COP_TRIM
(
   VAL_ANNOMESE,
   VAL_NBV,
   VAL_GBV,
   VAL_IND_COP
)
AS
   SELECT val_annomese,
          val_nbv,
          val_gbv,
          1 - val_nbv / DECODE (val_gbv, 0, 1, val_gbv) val_ind_cop
     FROM (  SELECT DISTINCT
                    val_annomese, SUM (val_nbv) val_nbv, SUM (val_gbv) val_gbv
               FROM t_mcres_fen_indici_copertura c,
                    v_mcres_app_lista_trimestri q
              WHERE q.cod_label_trim = c.val_annomese
           GROUP BY val_annomese);
