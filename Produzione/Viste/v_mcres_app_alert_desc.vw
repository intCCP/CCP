/* Formatted on 17/06/2014 18:09:23 (QP5 v5.227.12220.39754) */
CREATE OR REPLACE FORCE VIEW MCRE_OWN.V_MCRES_APP_ALERT_DESC
(
   ID_ALERT,
   ID_FUNZIONE,
   DESC_ALERT,
   FLG_ORDINE,
   VAL_CONDIZIONE_ALERT
)
AS
   SELECT NVL (r.id_alert, al.id_alert) id_alert,
          NVL (r.id_funzione, -1) id_funzione,
          r.desc_alert,
          r.flg_ordine,
             'verde <= '
          || VAL_CURRENT_GREEN
          || ', giallo > '
          || (VAL_CURRENT_GREEN)
          || ' < '
          || (VAL_CURRENT_ORANGE + 1)
          || ', rosso >= '
          || (VAL_CURRENT_ORANGE + 1)
             val_condizione_alert
     FROM T_MCRES_APP_GESTIONE_ALERT al, t_mcres_app_alert_ruoli r
    WHERE al.id_alert = r.id_alert(+) AND r.flg_attivo(+) = 'A';


GRANT SELECT ON MCRE_OWN.V_MCRES_APP_ALERT_DESC TO MCRE_USR;
