/* Formatted on 21/07/2014 18:43:05 (QP5 v5.227.12220.39754) */
CREATE OR REPLACE FORCE VIEW MCRE_OWN.V_MCRES_APP_SP_LEGALI_EL_DIS
(
   ID_LEGALE,
   NOMINATIVO,
   CODICE_FISCALE,
   PARTITA_IVA,
   DTA_ST_SAP
)
AS
     SELECT a.id_legale,
            a.nominativo,
            a.codice_fiscale,
            a.partita_iva,
            b.dta_st_sap
       FROM (SELECT cod_id_legale AS id_legale,
                       val_legale_cognome
                    || CASE
                          WHEN val_legale_nome IS NOT NULL THEN ' - '
                          ELSE NULL
                       END
                    || val_legale_nome
                       AS nominativo,
                    val_legale_codfisc AS codice_fiscale,
                    val_legale_piva AS partita_iva
               FROM t_mcres_app_legali_esterni) a
            JOIN
            (  SELECT cod_id_legale AS id_legale, MAX (dta_mov) AS dta_st_sap
                 FROM t_mcres_app_legali_esterni_mov
             GROUP BY cod_id_legale) b
               ON a.id_legale = b.id_legale
   ORDER BY dta_st_sap DESC;
