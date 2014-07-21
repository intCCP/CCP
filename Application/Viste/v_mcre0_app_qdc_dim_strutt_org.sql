/* Formatted on 21/07/2014 18:34:59 (QP5 v5.227.12220.39754) */
CREATE OR REPLACE FORCE VIEW MCRE_OWN.V_MCRE0_APP_QDC_DIM_STRUTT_ORG
(
   ID_DPER,
   RECORD_CHAR
)
AS
   SELECT TO_CHAR (SYSDATE, 'yyyymm') AS id_dper,
             '00005'
          || LPAD (NVL (TRIM (cod_abi_istituto), ' '), 5, ' ')
          || LPAD (NVL (TRIM (cod_struttura_competente), ' '), 5, ' ')
          || RPAD (NVL (TRIM (desc_struttura_competente), ' '), 100, ' ')
          || LPAD (NVL (TRIM (cod_str_org_sup), ' '), 5, ' ')
          || LPAD (NVL (TRIM (cod_div), ' '), 5, ' ')
          || LPAD (NVL (TRIM (cod_livello), ' '), 2, ' ')
          || LPAD (NVL (TRIM (cod_comparto), ' '), 6, ' ')
          || RPAD (NVL (TRIM (desc_comparto), ' '), 50, ' ')
          || LPAD (NVL (TRIM (cod_ramo), ' '), 6, ' ')
          || LPAD (NVL (TRIM (TO_CHAR (id_dominio)), ' '), 5, ' ')
          || '        '
          || 'QDC_DIM_STRUTT_ORG'
     FROM t_mcre0_app_struttura_org
    WHERE cod_struttura_competente <> '-';
