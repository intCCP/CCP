/* Formatted on 21/07/2014 18:42:15 (QP5 v5.227.12220.39754) */
CREATE OR REPLACE FORCE VIEW MCRE_OWN.V_MCRES_APP_GESTIONE_ALERT
(
   ID_ALERT,
   DESC_ALERT,
   VAL_CURRENT_GREEN,
   VAL_CURRENT_ORANGE,
   VAL_NEXT_GREEN,
   VAL_NEXT_ORANGE,
   FLG_MODIFICATO,
   FLG_ATTIVO
)
AS
   SELECT -- 20130207     AG  Vista per la sezione Gestione valori semafori alert
                                       -- 20130312     AG  Aggiunto flg_attivo
         g.id_alert,
         d.desc_alert,
         g.val_current_green,
         g.val_current_orange,
         g.val_next_green,
         g.val_next_orange,
         CASE
            WHEN     g.val_current_green = g.val_next_green
                 AND g.val_current_orange = val_next_orange
            THEN
               0
            WHEN    g.val_current_green != g.val_next_green
                 OR g.val_current_orange != val_next_orange
            THEN
               1
            ELSE
               -1
         END
            flg_modificato,
         CASE WHEN d.sum_attivo >= 0 THEN 1 ELSE 0 END flg_attivo
    FROM t_mcres_app_gestione_alert g,
         (  SELECT id_alert,
                   MAX (desc_alert) desc_alert,
                   SUM (DECODE (flg_attivo, 'A', 1, 0)) sum_attivo
              FROM t_mcres_app_alert_ruoli
          GROUP BY id_alert) d
   WHERE 0 = 0 AND g.id_alert = d.id_alert(+);
