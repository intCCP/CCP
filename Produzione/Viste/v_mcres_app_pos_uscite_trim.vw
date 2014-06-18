/* Formatted on 17/06/2014 18:10:54 (QP5 v5.227.12220.39754) */
CREATE OR REPLACE FORCE VIEW MCRE_OWN.V_MCRES_APP_POS_USCITE_TRIM
(
   COD_LABEL_TRIM,
   VAL_NUM_POS
)
AS
     SELECT t.cod_label_trim, COUNT (cod_ndg) val_num_pos
       FROM t_mcres_app_pratiche p, v_mcres_app_lista_trimestri t
      WHERE     p.flg_attiva = 0
            AND TO_CHAR (p.dta_chiusura, 'YYYYMM') BETWEEN TO_CHAR (
                                                              ADD_MONTHS (
                                                                 TO_DATE (
                                                                    t.cod_label_trim,
                                                                    'YYYYMM'),
                                                                 -2),
                                                              'YYYYMM')
                                                       AND t.cod_label_trim
   GROUP BY t.cod_label_trim;


GRANT DELETE, INSERT, REFERENCES, SELECT, UPDATE, ON COMMIT REFRESH, QUERY REWRITE, DEBUG, FLASHBACK, MERGE VIEW ON MCRE_OWN.V_MCRES_APP_POS_USCITE_TRIM TO MCRE_USR;
