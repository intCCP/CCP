/* Formatted on 17/06/2014 18:02:47 (QP5 v5.227.12220.39754) */
CREATE OR REPLACE FORCE VIEW MCRE_OWN.V_MCRE0_APP_QDC_CDR_DELIBERE
(
   ID_DPER,
   RECORD_CHAR
)
AS
   SELECT id_dper,                                               --mod 03.2013
             '002'
          || LPAD (TRIM (cod_abi), 5, 0)
          || LPAD (TRIM (cod_ndg), 16, 0)
          || LPAD (TRIM (cod_protocollo_delibera), 17, ' ')
          || LPAD (NVL (TRIM (cod_stato), ' '), 2, ' ')
          || LPAD (NVL (TO_CHAR (dta_decorrenza_stato, 'YYYYMMDD'), ' '),
                   8,
                   ' ')
          || LPAD (NVL (TRIM (cod_comparto), ' '), 6, ' ')
          || LPAD (NVL (TRIM (cod_struttura_competente), ' '), 5, ' ')
          || LPAD (NVL (TRIM (cod_organo_deliberante), ' '), 2, ' ')
          || LPAD (NVL (TRIM (cod_processo), ' '), 2, ' ')
          || LPAD (NVL (TRIM (cod_microtipologia_delib), ' '), 2, ' ')
          || LPAD (NVL (val_accordato, 0) * 100, 16, ' ')
          || LPAD (NVL (val_accordato_cassa, 0) * 100, 16, ' ')
          || LPAD (NVL (val_accordato_derivati, 0) * 100, 16, ' ')
          || LPAD (NVL (val_accordato_firma, 0) * 100, 16, ' ')
          || LPAD (NVL (val_esp_firma, 0) * 100, 16, ' ')
          || LPAD (NVL (val_esp_lorda, 0) * 100, 16, ' ')
          || LPAD (NVL (val_esp_lorda_capitale, 0) * 100, 16, ' ')
          || LPAD (NVL (val_esp_lorda_mora, 0) * 100, 16, ' ')
          || LPAD (NVL (val_esp_netta_ante_delib, 0) * 100, 16, ' ')
          || LPAD (NVL (val_esp_netta_post_delib, 0) * 100, 16, ' ')
          || LPAD (NVL (val_esp_tot_cassa, 0) * 100, 16, ' ')
          || LPAD (NVL (val_imp_crediti_firma, 0) * 100, 16, ' ')
          || LPAD (NVL (val_imp_fondi_terzi, 0) * 100, 16, ' ')
          || LPAD (NVL (val_imp_fondi_terzi_nb, 0) * 100, 16, ' ')
          || LPAD (NVL (val_imp_offerto, 0) * 100, 16, ' ')
          || LPAD (NVL (val_imp_perdita, 0) * 100, 16, ' ')
          || LPAD (NVL (val_imp_utilizzo, 0) * 100, 16, ' ')
     FROM mcre_own.t_mcre0_app_qdc_posiz_delib,
          (SELECT SUBSTR (MAX (cod_mese_hst), 1, 6) id_dper
             FROM T_MCRE0_APP_QDC_POSIZ_DELIB)
    WHERE     cod_protocollo_delibera IS NOT NULL
          AND dta_conferma_delibera >= TO_DATE (id_dper, 'YYYYMM') --mod 04.2013
;


GRANT DELETE, INSERT, REFERENCES, SELECT, UPDATE, ON COMMIT REFRESH, QUERY REWRITE, DEBUG, FLASHBACK, MERGE VIEW ON MCRE_OWN.V_MCRE0_APP_QDC_CDR_DELIBERE TO MCRE_USR;
