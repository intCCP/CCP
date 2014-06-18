/* Formatted on 17/06/2014 18:13:16 (QP5 v5.227.12220.39754) */
CREATE OR REPLACE FORCE VIEW MCRE_OWN.V_MCRES_LEGALI_ESTERNI_MOPLE
(
   LINE
)
AS
   SELECT REPLACE (
                RPAD (cod_id_legale, 5, ' ')
             || RPAD (NVL (cod_abi, ' '), 5, ' ')
             || RPAD (NVL (cod_presidio, ' '), 5, ' ')
             || RPAD (cod_id_legale, 5, ' ')
             || RPAD (NVL (val_legale_cognome, ' '), 50, ' ')
             || RPAD (NVL (val_legale_nome, ' '), 50, ' ')
             || RPAD (NVL (val_legale_codfisc, ' '), 16, ' ')
             || RPAD (NVL (val_legale_piva, ' '), 11, ' ')
             || RPAD (NVL (val_legale_indirizzo, ' '), 100, ' ')
             || RPAD (NVL (val_legale_citta, ' '), 80, ' ')
             || RPAD (NVL (val_legale_prov, ' '), 2, ' ')
             || RPAD (NVL (val_legale_cap, ' '), 5, ' ')
             || RPAD (NVL (val_legale_telef, ' '), 20, ' ')
             || RPAD (NVL (val_legale_fax, ' '), 20, ' ')
             || RPAD (NVL (val_legale_email, ' '), 80, ' ')
             || RPAD (NVL (val_legale_abi, ' '), 5, ' ')
             || RPAD (NVL (val_legale_cab, ' '), 5, ' ')
             || RPAD (NVL (val_legale_conto, ' '), 10, ' ')
             || RPAD (NVL (val_legale_cin, ' '), 1, ' ')
             || RPAD (NVL (cod_specializzazione, ' '), 2, ' ')
             || RPAD (NVL (val_legale_ind_proc_gen, ' '), 1, ' ')
             || RPAD (NVL (TO_CHAR (dta_procura_gen, 'DD/MM/YYYY'), ' '),
                      10,
                      ' ')
             || RPAD (NVL (cod_num_repertorio_pg, ' '), 15, ' ')
             || RPAD (NVL (val_nominativo_notaio, ' '), 50, ' ')
             || RPAD (NVL (val_note, ' '), 200, ' ')
             || RPAD (TO_CHAR (dta_ins, 'DD/MM/YYYY'), 10, ' ')
             || RPAD (NVL (TO_CHAR (dta_cancellazione, 'DD/MM/YYYY'), ' '),
                      10,
                      ' ')
             || RPAD (NVL (flg_obbligo_autoriz, ' '), 1, ' ')
             || RPAD (NVL (flg_visualizza, ' '), 1, ' ')
             || RPAD (NVL (cod_citta, ' '), 6, ' ')
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
                      ' '),
             CHR (10),
             ' ')
             line
     FROM t_mcres_app_legali_esterni;


GRANT DELETE, INSERT, REFERENCES, SELECT, UPDATE, ON COMMIT REFRESH, QUERY REWRITE, DEBUG, FLASHBACK, MERGE VIEW ON MCRE_OWN.V_MCRES_LEGALI_ESTERNI_MOPLE TO MCRE_USR;
