/* Formatted on 21/07/2014 18:41:40 (QP5 v5.227.12220.39754) */
CREATE OR REPLACE FORCE VIEW MCRE_OWN.V_MCRES_APP_ANZIANITA_TRIM_NEW
(
   COD_LABEL_TRIM,
   VAL_NUM_POS
)
AS
     SELECT cod_label_trim,
            (SUM (val_tot_gg) / SUM (val_tot_posizioni)) / 365 val_num_pos
       FROM t_mcres_fen_anzianita_trim
   GROUP BY cod_label_trim;
