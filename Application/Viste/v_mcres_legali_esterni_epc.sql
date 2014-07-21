/* Formatted on 21/07/2014 18:44:27 (QP5 v5.227.12220.39754) */
CREATE OR REPLACE FORCE VIEW MCRE_OWN.V_MCRES_LEGALI_ESTERNI_EPC
(
   LINE
)
AS
   SELECT REPLACE (
                RPAD (NVL (cod_user_id, ' '), 15, ' ')
             || ';'
             || RPAD (
                   NVL (
                         REPLACE (TRIM (val_legale_nome), ';', '')
                      || ' '
                      || REPLACE (TRIM (val_legale_cognome), ';', ''),
                      ' '),
                   200,
                   ' ')
             || ';'
             || RPAD (NVL (REPLACE (cod_id_contratto, ';', ''), ' '),
                      50,
                      ' ')
             || ';'
             || RPAD (NVL (TO_CHAR (dta_contratto, 'YYYYMMDD'), ' '), 8, ' ')
             || ';'
             || RPAD (NVL (TO_CHAR (dta_scad_contratto, 'YYYYMMDD'), ' '),
                      8,
                      ' ')
             || ';'
             || RPAD (NVL (REPLACE (cod_id_convenzione, ';', ''), ' '),
                      15,
                      ' ')
             || ';'
             || RPAD (NVL (TO_CHAR (dta_scad_convenzione, 'YYYYMMDD'), ' '),
                      8,
                      ' ')
             || ';'
             || RPAD (
                   NVL (REPLACE (TRIM (val_legale_indirizzo), ';', ''), ' '),
                   200,
                   ' ')
             || ';'
             || RPAD (NVL (REPLACE (val_legale_cap, ';', ''), ' '), 5, ' ')
             || ';'
             || RPAD (NVL (REPLACE (TRIM (val_legale_citta), ';', ''), ' '),
                      50,
                      ' ')
             || ';'
             || RPAD (NVL (REPLACE (val_legale_prov, ';', ''), ' '), 2, ' ')
             || ';'
             || RPAD (NVL (REPLACE (val_legale_telef, ';', ''), ' '),
                      20,
                      ' ')
             || ';'
             || RPAD (NVL (REPLACE (val_legale_fax, ';', ''), ' '), 20, ' ')
             || ';'
             || RPAD (NVL (REPLACE (TRIM (val_legale_email), ';', ''), ' '),
                      50,
                      ' ')
             || ';'
             || RPAD (NVL (COALESCE (val_iban1,
                                     val_iban2,
                                     val_iban3,
                                     val_iban4,
                                     val_iban5,
                                     val_iban6,
                                     val_iban7,
                                     val_iban8,
                                     val_iban9,
                                     val_iban10),
                           ' '),
                      27,
                      ' ')
             || ';'
             || RPAD (NVL (val_legale_piva, ' '), 11, ' ')
             || ';'
             || RPAD (NVL (val_legale_codfisc, ' '), 16, ' '),
             CHR (10),
             ' ')
             line
     FROM t_mcres_app_legali_esterni
    WHERE cod_user_id IS NOT NULL;
