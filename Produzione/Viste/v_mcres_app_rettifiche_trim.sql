/* Formatted on 17/06/2014 18:11:15 (QP5 v5.227.12220.39754) */
CREATE OR REPLACE FORCE VIEW MCRE_OWN.V_MCRES_APP_RETTIFICHE_TRIM
(
   VAL_ANNOMESE,
   VAL_RETTIFICA_NETTA,
   VAL_EFF_TRANSAZIONI,
   VAL_EFF_VALUTAZIONI
)
AS
     SELECT t.cod_label_trim val_annomese,
            SUM (r.val_rettifica_netta) val_rettifica_netta,
            SUM (r.val_eff_transazioni) val_eff_transazioni,
            SUM (r.val_eff_valutazioni) val_eff_valutazioni
       FROM t_mcres_fen_rettifiche_pos_m r, v_mcres_app_lista_trimestri t
      WHERE     r.flg_gruppo = 1
            AND r.val_annomese BETWEEN TO_CHAR (
                                          ADD_MONTHS (
                                             TO_DATE (t.cod_label_trim,
                                                      'YYYYMM'),
                                             -2),
                                          'YYYYMM')
                                   AND t.cod_label_trim
   GROUP BY t.cod_label_trim;


GRANT DELETE, INSERT, REFERENCES, SELECT, UPDATE, ON COMMIT REFRESH, QUERY REWRITE, DEBUG, FLASHBACK, MERGE VIEW ON MCRE_OWN.V_MCRES_APP_RETTIFICHE_TRIM TO MCRE_USR;
