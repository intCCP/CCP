/* Formatted on 21/07/2014 18:34:58 (QP5 v5.227.12220.39754) */
CREATE OR REPLACE FORCE VIEW MCRE_OWN.V_MCRE0_APP_QDC_DIM_PROCESSI
(
   ID_DPER,
   RECORD_CHAR
)
AS
   (SELECT TO_CHAR (SYSDATE, 'yyyymm') AS id_dper,
              '00007'
           || LPAD (NVL (TRIM (COD_ABI), ' '), 5, ' ')
           || LPAD (NVL (TRIM (COD_PROCESSO), ' '), 2, ' ')
           || RPAD (NVL (TRIM (DESC_PROCESSO), ' '), 50, ' ')
           || LPAD (NVL (TRIM (TIP_PROCESSO), ' '), 2, ' ')
           || LPAD (NVL (TRIM (COD_DIV), ' '), 5, ' ')
           || LPAD (NVL (TRIM (TIP_CREDITO), ' '), 1, ' ')
           || LPAD (NVL (TRIM (TIP_DIV), ' '), 1, ' ')
           || LPAD (NVL (TRIM (FLG_ATTIVOSTORICO), ' '), 1, ' ')
           || LPAD (NVL (TRIM (TO_CHAR (VAL_ORDINE)), ' '), 1, ' ')
           || '                 '
           || 'QDC_DIM_PROCESSI'
      FROM T_MCRE0_CL_PROCESSI);
