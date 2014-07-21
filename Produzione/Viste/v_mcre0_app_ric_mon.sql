/* Formatted on 17/06/2014 18:03:05 (QP5 v5.227.12220.39754) */
CREATE OR REPLACE FORCE VIEW MCRE_OWN.V_MCRE0_APP_RIC_MON
(
   RECORD_CHAR
)
AS
     SELECT CASE
               WHEN SUBSTR (record_char, 1, 16) = 'XXXXXXXXXXXXXXXX'
               THEN
                  RPAD (SUBSTR (record_char, 17, 8), 80, ' ')
               ELSE
                  record_char
            END
               AS record_char
       FROM (SELECT RPAD ('XXXXXXXXXXXXXXXX' || TO_CHAR (SYSDATE, 'ddmmyyyy'),
                          80,
                          ' ')
                       AS record_char
               FROM DUAL
             UNION
             SELECT DISTINCT RPAD (NVL (COD_SNDG, ' '), 80, ' ')
               FROM t_mcre0_app_gb_gestione
              WHERE FLG_STATO = '1'
             UNION
             SELECT DISTINCT RPAD (NVL (COD_SNDG, ' '), 80, ' ')
               FROM t_mcrei_app_delibere
              WHERE cod_tipo_pacchetto = 'B')
   ORDER BY record_char DESC;


GRANT DELETE, INSERT, REFERENCES, SELECT, UPDATE, ON COMMIT REFRESH, QUERY REWRITE, DEBUG, FLASHBACK, MERGE VIEW ON MCRE_OWN.V_MCRE0_APP_RIC_MON TO MCRE_USR;
