/* Formatted on 21/07/2014 18:39:02 (QP5 v5.227.12220.39754) */
CREATE OR REPLACE FORCE VIEW MCRE_OWN.V_MCREI_APP_ALERT_POS_CNT
(
   ID_ALERT,
   DESC_ALERT,
   CNT_R,
   CNT_G,
   CNT_V
)
AS
     SELECT cnt.id_alert,
            al.DESC_ALERT,
            SUM (cnt_r) AS CNT_R,
            SUM (cnt_g) AS CNT_G,
            SUM (cnt_v) AS CNT_V
       FROM (  SELECT id_alert,
                      -- rosso,
                      SUM (CASE WHEN alert = 'R' THEN 1 ELSE 0 END) CNT_R,
                      -- giallo,
                      SUM (CASE WHEN alert = 'G' THEN 1 ELSE 0 END) CNT_G,
                      -- verde,
                      SUM (CASE WHEN alert = 'V' THEN 1 ELSE 0 END) CNT_V
                 FROM t_mcrei_app_alert_pos_wrk
             GROUP BY id_alert, alert) cnt,
            t_mcrei_app_alert al
      WHERE cnt.id_alert = al.id_alert
   GROUP BY cnt.id_alert, al.DESC_ALERT;
