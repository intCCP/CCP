/* Formatted on 21/07/2014 18:43:07 (QP5 v5.227.12220.39754) */
CREATE OR REPLACE FORCE VIEW MCRE_OWN.V_MCRES_APP_SP_LEGALI_NO_SAP
(
   ID_LEGALE,
   NOMINATIVO,
   CODICE_FISCALE,
   PARTITA_IVA,
   IN_CONVENZIONE,
   IN_ALBO
)
AS
     SELECT cod_id_legale AS id_legale,
               val_legale_cognome
            || CASE WHEN val_legale_nome IS NOT NULL THEN ' - ' ELSE NULL END
            || val_legale_nome
               AS nominativo,
            val_legale_codfisc AS codice_fiscale,
            val_legale_piva AS partita_iva,
            flg_convenz AS in_convenzione,
            flg_albo AS in_albo
       FROM t_mcres_app_legali_esterni
      WHERE SUBSTR (cod_sap_fornitore, 0, 1) = 'S' AND flg_active = 1
   ORDER BY nominativo;
