/* Formatted on 21/07/2014 18:30:09 (QP5 v5.227.12220.39754) */
CREATE OR REPLACE FORCE VIEW MCRE_OWN.ANDREA_ALERT
(
   ID_ALERT,
   DESC_ALERT
)
AS
     SELECT DISTINCT id_alert, desc_alert
       FROM t_mcres_app_alert_ruoli
   ORDER BY id_alert;
