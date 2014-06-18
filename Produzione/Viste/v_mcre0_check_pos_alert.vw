/* Formatted on 17/06/2014 18:04:48 (QP5 v5.227.12220.39754) */
CREATE OR REPLACE FORCE VIEW MCRE_OWN.V_MCRE0_CHECK_POS_ALERT
(
   ALERT,
   POS
)
AS
     SELECT a.id_alert AS alert, c.conteggio AS pos
       FROM (SELECT 1 id, COUNT (*) conteggio
               FROM t_mcre0_app_alert_pos
              WHERE alert_1 IS NOT NULL
             UNION
             SELECT 2 id, COUNT (*) conteggio
               FROM t_mcre0_app_alert_pos
              WHERE alert_2 IS NOT NULL
             UNION
             SELECT 3 id, COUNT (*) conteggio
               FROM t_mcre0_app_alert_pos
              WHERE alert_3 IS NOT NULL
             UNION
             SELECT 4 id, COUNT (*) conteggio
               FROM t_mcre0_app_alert_pos
              WHERE alert_4 IS NOT NULL
             UNION
             SELECT 5 id, COUNT (*) conteggio
               FROM t_mcre0_app_alert_pos
              WHERE alert_5 IS NOT NULL
             UNION
             SELECT 6 id, COUNT (*) conteggio
               FROM t_mcre0_app_alert_pos
              WHERE alert_6 IS NOT NULL
             UNION
             SELECT 7 id, COUNT (*) conteggio
               FROM t_mcre0_app_alert_pos
              WHERE alert_7 IS NOT NULL
             UNION
             SELECT 8 id, COUNT (*) conteggio
               FROM t_mcre0_app_alert_pos
              WHERE alert_8 IS NOT NULL
             UNION
             SELECT 9 id, COUNT (*) conteggio
               FROM t_mcre0_app_alert_pos
              WHERE alert_9 IS NOT NULL
             UNION
             SELECT 10 id, COUNT (*) conteggio
               FROM t_mcre0_app_alert_pos
              WHERE alert_10 IS NOT NULL
             UNION
             SELECT 11 id, COUNT (*) conteggio
               FROM t_mcre0_app_alert_pos
              WHERE alert_11 IS NOT NULL
             UNION
             SELECT 12 id, COUNT (*) conteggio
               FROM t_mcre0_app_alert_pos
              WHERE alert_12 IS NOT NULL
             UNION
             SELECT 13 id, COUNT (*) conteggio
               FROM t_mcre0_app_alert_pos
              WHERE alert_13 IS NOT NULL
             UNION
             SELECT 14 id, COUNT (*) conteggio
               FROM t_mcre0_app_alert_pos
              WHERE alert_14 IS NOT NULL
             UNION
             SELECT 15 id, COUNT (*) conteggio
               FROM t_mcre0_app_alert_pos
              WHERE alert_15 IS NOT NULL
             UNION
             SELECT 16 id, COUNT (*) conteggio
               FROM t_mcre0_app_alert_pos
              WHERE alert_16 IS NOT NULL
             UNION
             SELECT 17 id, COUNT (*) conteggio
               FROM t_mcre0_app_alert_pos
              WHERE alert_17 IS NOT NULL
             UNION
             SELECT 18 id, COUNT (*) conteggio
               FROM t_mcre0_app_alert_pos
              WHERE alert_18 IS NOT NULL
             UNION
             SELECT 19 id, COUNT (*) conteggio
               FROM t_mcre0_app_alert_pos
              WHERE alert_19 IS NOT NULL
             UNION
             SELECT 20 id, COUNT (*) conteggio
               FROM t_mcre0_app_alert_pos
              WHERE alert_20 IS NOT NULL
             UNION
             SELECT 21 id, COUNT (*) conteggio
               FROM t_mcre0_app_alert_pos
              WHERE alert_21 IS NOT NULL
             UNION
             SELECT 22 id, COUNT (*) conteggio
               FROM t_mcre0_app_alert_pos
              WHERE alert_22 IS NOT NULL
             UNION
             SELECT 23 id, COUNT (*) conteggio
               FROM t_mcre0_app_alert_pos
              WHERE alert_23 IS NOT NULL
             UNION
             SELECT 24 id, COUNT (*) conteggio
               FROM t_mcre0_app_alert_pos
              WHERE alert_24 IS NOT NULL
             UNION
             SELECT 25 id, COUNT (*) conteggio
               FROM t_mcre0_app_alert_pos
              WHERE alert_25 IS NOT NULL) c,
            t_mcre0_app_alert a
      WHERE a.id_alert = c.id
   ORDER BY 1;


GRANT SELECT ON MCRE_OWN.V_MCRE0_CHECK_POS_ALERT TO MCRE_USR;
