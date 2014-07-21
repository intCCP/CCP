/* Formatted on 17/06/2014 18:02:52 (QP5 v5.227.12220.39754) */
CREATE OR REPLACE FORCE VIEW MCRE_OWN.V_MCRE0_APP_QDC_DIM_COMPARTI
(
   ID_DPER,
   RECORD_CHAR
)
AS
   SELECT TO_CHAR (SYSDATE, 'yyyymm') AS id_dper,
             '00002'
          || LPAD (NVL (TRIM (cod_comparto), ' '), 6, ' ')
          || RPAD (NVL (TRIM (desc_comparto), ' '), 50, ' ')
          || LPAD (NVL (TRIM (val_sigla), ' '), 3, ' ')
          || LPAD (NVL (TRIM (flg_chk), ' '), 1, ' ')
          || LPAD (NVL (TRIM (cod_servizio), ' '), 6, ' ')
          || RPAD (NVL (TRIM (desc_servizio), ' '), 50, ' ')
          || LPAD (NVL (TRIM (flg_girocomparto), ' '), 1, ' ')
          || LPAD (NVL (TRIM (cod_livello), ' '), 2, ' ')
          || LPAD (NVL (TRIM (TO_CHAR (val_gg_prima_proroga)), ' '), 41, ' ')
          || LPAD (NVL (TRIM (TO_CHAR (val_gg_seconda_proroga)), ' '),
                   41,
                   ' ')
          || LPAD (NVL (TRIM (TO_CHAR (val_od_prima_proroga)), ' '), 41, ' ')
          || LPAD (NVL (TRIM (TO_CHAR (val_od_seconda_proroga)), ' '),
                   41,
                   ' ')
          || '                  '
          || 'QDC_DIM_UTENTI'
     FROM t_mcre0_app_comparti
    WHERE cod_comparto <> '#';


GRANT DELETE, INSERT, REFERENCES, SELECT, UPDATE, ON COMMIT REFRESH, QUERY REWRITE, DEBUG, FLASHBACK, MERGE VIEW ON MCRE_OWN.V_MCRE0_APP_QDC_DIM_COMPARTI TO MCRE_USR;
