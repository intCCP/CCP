/* Formatted on 17/06/2014 18:02:55 (QP5 v5.227.12220.39754) */
CREATE OR REPLACE FORCE VIEW MCRE_OWN.V_MCRE0_APP_QDC_DIM_PROCESSI
(
   ID_DPER,
   RECORD_CHAR
)
AS
   (SELECT TO_CHAR (SYSDATE, 'yyyymm') AS id_dper,
              '00007'
           || LPAD (NVL (TRIM (cod_abi), ' '), 5, ' ')
           || LPAD (NVL (TRIM (cod_processo), ' '), 2, ' ')
           || RPAD (NVL (TRIM (desc_processo), ' '), 50, ' ')
           || LPAD (NVL (TRIM (tip_processo), ' '), 2, ' ')
           || LPAD (NVL (TRIM (cod_div), ' '), 5, ' ')
           || LPAD (NVL (TRIM (tip_credito), ' '), 1, ' ')
           || LPAD (NVL (TRIM (tip_div), ' '), 1, ' ')
           || LPAD (NVL (TRIM (flg_attivostorico), ' '), 1, ' ')
           || LPAD (NVL (TRIM (TO_CHAR (val_ordine)), ' '), 1, ' ')
           || '                 '
           || 'QDC_DIM_PROCESSI'
      FROM t_mcre0_cl_processi);


GRANT DELETE, INSERT, REFERENCES, SELECT, UPDATE, ON COMMIT REFRESH, QUERY REWRITE, DEBUG, FLASHBACK, MERGE VIEW ON MCRE_OWN.V_MCRE0_APP_QDC_DIM_PROCESSI TO MCRE_USR;
