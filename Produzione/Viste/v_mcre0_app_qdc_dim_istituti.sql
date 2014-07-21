/* Formatted on 17/06/2014 18:02:53 (QP5 v5.227.12220.39754) */
CREATE OR REPLACE FORCE VIEW MCRE_OWN.V_MCRE0_APP_QDC_DIM_ISTITUTI
(
   ID_DPER,
   RECORD_CHAR
)
AS
   (SELECT TO_CHAR (SYSDATE, 'yyyymm') AS id_dper,
              '00003'
           || LPAD (NVL (TRIM (cod_istituto), ' '), 2, ' ')
           || LPAD (NVL (TRIM (cod_abi), ' '), 5, ' ')
           || RPAD (NVL (TRIM (desc_istituto), ' '), 100, ' ')
           || RPAD (NVL (TRIM (desc_breve), ' '), 10, ' ')
           || LPAD (NVL (TRIM (cod_istituto_soa), ' '), 2, ' ')
           || LPAD (NVL (TRIM (cod_abi_visualizzato), ' '), 5, ' ')
           || LPAD (NVL (TRIM (flg_outsourcing), ' '), 1, ' ')
           || LPAD (NVL (TRIM (flg_target), ' '), 1, ' ')
           || LPAD (NVL (TRIM (flg_cartolarizzato), ' '), 1, ' ')
           || LPAD (NVL (TRIM (flg_chiusura_mancato_agg), ' '), 1, ' ')
           || LPAD (NVL (TRIM (flg_segregato), ' '), 1, ' ')
           || LPAD (NVL (TRIM (cod_abi_istituto), ' '), 5, ' ')
           || '               '
           || 'QDC_DIM_ISTITUTI'
      FROM mv_mcre0_app_istituti);


GRANT DELETE, INSERT, REFERENCES, SELECT, UPDATE, ON COMMIT REFRESH, QUERY REWRITE, DEBUG, FLASHBACK, MERGE VIEW ON MCRE_OWN.V_MCRE0_APP_QDC_DIM_ISTITUTI TO MCRE_USR;
