/* Formatted on 17/06/2014 18:05:18 (QP5 v5.227.12220.39754) */
CREATE OR REPLACE FORCE VIEW MCRE_OWN.V_MCRE0_ETL_PROC
(
   DAY,
   FLG_STORICIZZA_MENSILE,
   FLG_STORICIZZA_GIORNALIERO
)
AS
     SELECT day,
            CASE
               WHEN     n_max = 1
                    AND c_max = 1
                    AND month > LAG (month) OVER (PARTITION BY 1 ORDER BY day)
               THEN
                  1
               ELSE
                  0
            END
               flg_storicizza_mensile,     --terminati entrambi la prima volta
            CASE WHEN c_min = 1 THEN 1 ELSE 0 END flg_storicizza_giornaliero --iniziato web la prima volta
       --upper(err_msg) like '%PKG_STORICIZZA%'
       FROM (  SELECT TRUNC (start_date) day,
                      TO_CHAR (start_date, 'mm') month,
                      area,                                          --caller,
                      SUM (
                         CASE
                            WHEN sql_ord = (SELECT MAX (sql_ord)
                                              FROM mcre_own.t_mcre0_etl_caller c
                                             WHERE c.caller = l.caller)
                            THEN
                               1
                            ELSE
                               0
                         END)
                         n_max,
                      SUM (
                         CASE
                            WHEN sql_ord =
                                    (SELECT MIN (sql_ord)
                                       FROM mcre_own.t_mcre0_etl_caller c
                                      WHERE     caller = 'load_web'
                                            AND c.caller = l.caller)
                            THEN
                               1
                            ELSE
                               0
                         END)
                         n_min,
                      SIGN (
                           SUM (
                              CASE
                                 WHEN sql_ord =
                                         (SELECT MAX (sql_ord)
                                            FROM mcre_own.t_mcre0_etl_caller c
                                           WHERE c.caller = l.caller)
                                 THEN
                                    1
                                 ELSE
                                    0
                              END)
                         - 1)
                         c_max,                           --terminati entrambi
                      SIGN (
                         SUM (
                            CASE
                               WHEN sql_ord =
                                       (SELECT MIN (sql_ord)
                                          FROM mcre_own.t_mcre0_etl_caller c
                                         WHERE     caller = 'load_web'
                                               AND c.caller = l.caller)
                               THEN
                                  1
                               ELSE
                                  0
                            END))
                         c_min                           --iniziato almeno web
                 FROM mcre_own.t_mcre0_etl_log l
                WHERE caller IN ('load_web', 'load_dwh')
             --and upper(err_msg) like '%PKG_STORICIZZA%'
             --and trunc(end_date)=trunc(sysdate)-10
             GROUP BY TRUNC (start_date), TO_CHAR (start_date, 'mm'), area --,caller
             ORDER BY day DESC) a       --where trunc(end_date)=trunc(sysdate)
   ORDER BY day DESC;


GRANT SELECT ON MCRE_OWN.V_MCRE0_ETL_PROC TO MCRE_USR;
