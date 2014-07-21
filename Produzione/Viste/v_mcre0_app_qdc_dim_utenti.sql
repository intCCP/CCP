/* Formatted on 17/06/2014 18:03:00 (QP5 v5.227.12220.39754) */
CREATE OR REPLACE FORCE VIEW MCRE_OWN.V_MCRE0_APP_QDC_DIM_UTENTI
(
   ID_DPER,
   RECORD_CHAR
)
AS
   SELECT TO_CHAR (SYSDATE, 'yyyymm') AS id_dper,
             '00006'
          || RPAD (NVL (TRIM (TO_CHAR (id_utente)), ' '), 10, ' ')
          || LPAD (NVL (TRIM (cod_matricola), ' '), 7, ' ')
          || LPAD (NVL (TRIM (cod_fiscale), ' '), 22, ' ')
          || RPAD (NVL (TRIM (cognome), ' '), 100, ' ')
          || RPAD (NVL (TRIM (nome), ' '), 100, ' ')
          || LPAD (NVL (TRIM (cod_comparto_appart), ' '), 6, ' ')
          || LPAD (NVL (TRIM (cod_comparto_assegn), ' '), 6, ' ')
          || RPAD (NVL (TRIM (TO_CHAR (id_referente)), ' '), 10, ' ')
          || LPAD (
                NVL (TRIM (TO_CHAR (data_assegnazione_ref, 'ddmmyyyy')), ' '),
                8,
                ' ')
          || LPAD (NVL (TRIM (flg_gestore_abilitato), ' '), 1, ' ')
          || LPAD (NVL (TRIM (cod_priv), ' '), 6, ' ')
          || LPAD (NVL (TRIM (cod_comparto_utente), ' '), 6, ' ')
          || '         '
          || 'QDC_DIM_UTENTI'
     FROM t_mcre0_app_utenti
    WHERE id_utente <> -1;


GRANT DELETE, INSERT, REFERENCES, SELECT, UPDATE, ON COMMIT REFRESH, QUERY REWRITE, DEBUG, FLASHBACK, MERGE VIEW ON MCRE_OWN.V_MCRE0_APP_QDC_DIM_UTENTI TO MCRE_USR;
