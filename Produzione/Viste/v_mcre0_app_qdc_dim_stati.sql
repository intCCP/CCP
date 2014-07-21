/* Formatted on 17/06/2014 18:02:56 (QP5 v5.227.12220.39754) */
CREATE OR REPLACE FORCE VIEW MCRE_OWN.V_MCRE0_APP_QDC_DIM_STATI
(
   ID_DPER,
   RECORD_CHAR
)
AS
   SELECT TO_CHAR (SYSDATE, 'yyyymm') AS id_dper,
             '00004'
          || LPAD (NVL (TRIM (cod_microstato), ' '), 2, ' ')
          || RPAD (NVL (TRIM (desc_microstato), ' '), 50, ' ')
          || RPAD (NVL (TRIM (cod_macrostato), ' '), 3, ' ')
          || RPAD (NVL (TRIM (desc_macrostato), ' '), 50, ' ')
          || LPAD (NVL (TRIM (TO_CHAR (val_ordine)), ' '), 38, ' ')
          || LPAD (NVL (TRIM (tip_stato), ' '), 1, ' ')
          || LPAD (NVL (TRIM (flg_stato_chk), ' '), 1, ' ')
          || LPAD (NVL (TRIM (TO_CHAR (val_gruppo)), ' '), 38, ' ')
          || RPAD (NVL (TRIM (val_label_macrostato), ' '), 50, ' ')
          || LPAD (NVL (TRIM (flg_alert), ' '), 1, ' ')
          || '        '
          || 'QDC_DIM_STATI'
     FROM t_mcre0_app_stati
    WHERE cod_microstato <> '-1';


GRANT DELETE, INSERT, REFERENCES, SELECT, UPDATE, ON COMMIT REFRESH, QUERY REWRITE, DEBUG, FLASHBACK, MERGE VIEW ON MCRE_OWN.V_MCRE0_APP_QDC_DIM_STATI TO MCRE_USR;
