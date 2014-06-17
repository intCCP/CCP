/* Formatted on 17/06/2014 18:17:24 (QP5 v5.227.12220.39754) */
CREATE OR REPLACE FORCE VIEW MCRE_OWN.VTMCRE0_CHECK_POS_EXACT
(
   CONTROLLO,
   QUANTI
)
AS
   SELECT 'Posizioni GB e flg_source' AS controllo, NVL (COUNT (*), 0) quanti
     FROM (SELECT *
             FROM t_mcre0_app_all_data_DAY
            WHERE     1 = 1
                  AND (cod_abi_cartolarizzato, cod_ndg) IN
                         (SELECT cod_abi_cartolarizzato, cod_ndg
                            FROM t_mcre0_app_gb_gestione g
                           WHERE flg_stato = -2))
    WHERE flg_source != 0
   UNION
   SELECT 'Posizioni con comparto diverso da quello del gestore' AS controllo,
          COUNT (*) quanti
     FROM t_mcre0_app_all_data_DAY a, t_mcre0_app_utenti b
    WHERE     1 = 1
          AND a.id_utente = b.id_utente
          AND a.id_utente != -1
          AND flg_active = '1'
          AND NVL (a.cod_comparto_assegnato, a.cod_comparto_calcolato) !=
                 cod_comparto_utente
   UNION
   SELECT 'Numero di gruppi economici' AS controllo,
          COUNT (DISTINCT a.DESC_GE) AS GRUPPO_ECONOMICO
     FROM VTMCRE0_APP_HP_EXCEL a, t_mcre0_app_stati b
    WHERE     1 = 1
          AND cod_comparto IN
                 ('011905', '006601', '011906', '004195', '011901')
          AND a.COD_STATO = b.COD_MICROSTATO
          AND a.FLG_OUTSOURCING = 'Y'
   UNION
   SELECT 'Numero di posizioni con gruppo super nullo' AS controllo,
          COUNT (*) conteggio
     FROM t_mcre0_app_file_guida a
    WHERE flg_active = '1' --a.ID_DPER = (SELECT     MAX (id_dper) FROM t_mcre0_app_file_guida)
                          AND A.COD_GRUPPO_SUPER IS NULL
   UNION
   SELECT 'Numero di posizioni con diversi gestori' AS controllo,
          NVL (COUNT (cod_gruppo_super), 0)
     FROM (  SELECT cod_gruppo_super, COUNT (DISTINCT id_utente)
               FROM t_mcre0_app_all_data_DAY
              WHERE 1 = 1 AND today_flg = '1'
             HAVING COUNT (DISTINCT id_utente) > 1
           GROUP BY cod_gruppo_super
           ORDER BY cod_gruppo_super)
   UNION
   SELECT 'Numero di posizioni assegnati a diversi comparti' AS controllo,
          NVL (COUNT (*), 0)
     FROM (  SELECT cod_gruppo_super,
                    COUNT (
                       DISTINCT NVL (cod_comparto_assegnato,
                                     cod_comparto_calcolato))
               FROM t_mcre0_app_all_data_DAY
              WHERE     1 = 1
                    AND today_flg = '1'                      --- nessun record
                    AND cod_comparto_calcolato = '011901' -- equivale a filtrare sui 5 comparti di direzione (insieme all' nvl sulla count)
             HAVING COUNT (
                       DISTINCT NVL (cod_comparto_assegnato,
                                     cod_comparto_calcolato)) > 1
           GROUP BY cod_gruppo_super
           ORDER BY cod_gruppo_super)
   UNION
   SELECT 'Numero di cambi stato notturno' AS controllo, POSIZIONI AS quanti
     FROM (  SELECT a.FLG_CAMBIO_STATO,
                    COUNT (cod_abi_cartolarizzato || cod_ndg) POSIZIONI
               FROM t_mcre0_app_Storico_eventi a
              WHERE     a.dta_fine_val_tr = (SELECT TRUNC (MAX (a.tms_file))
                                               FROM T_MCRE0_WRK_ACQUISIZIONE a)
                    AND a.DTA_FINE_VALIDITA <=
                           (SELECT NVL (MAX (DTA_INS), SYSDATE)
                              FROM t_mcre0_wrk_audit_etl
                             WHERE procedura =
                                      '1_1 - PKG_MCRE0_TWS - END - Storicizza in seguito ai caricamenti')
                    AND flg_cambio_stato = '1'
           GROUP BY a.FLG_CAMBIO_STATO)
   UNION
   SELECT 'Numero di cambi comparto notturno' AS controllo,
          POSIZIONI AS quanti
     FROM (  SELECT a.FLG_CAMBIO_COMPARTO,
                    COUNT (cod_abi_cartolarizzato || cod_ndg) POSIZIONI
               FROM t_mcre0_app_Storico_eventi a
              WHERE     a.DTA_FINE_VALIDITA >=
                           (SELECT TRUNC (MAX (a.tms_file))
                              FROM T_MCRE0_WRK_ACQUISIZIONE a)
                    AND a.dta_fine_validita <=
                           (SELECT NVL (MAX (DTA_INS), SYSDATE)
                              FROM t_mcre0_wrk_audit_etl
                             WHERE procedura =
                                      '1_1 - PKG_MCRE0_TWS - END - Storicizza in seguito ai caricamenti')
                    AND FLG_CAMBIO_COMPARTO = '1'
                    AND cod_stato != '-1'                        --solo attivi
           GROUP BY a.FLG_CAMBIO_COMPARTO)
   UNION
   SELECT 'Numero di cambi gestore notturno' AS controllo,
          POSIZIONI AS quanti
     FROM (  SELECT a.FLG_CAMBIO_GESTORE,
                    COUNT (cod_abi_cartolarizzato || cod_ndg) POSIZIONI
               FROM t_mcre0_app_Storico_eventi a
              WHERE     a.DTA_FINE_VAL_TR = (SELECT TRUNC (MAX (a.tms_file))
                                               FROM T_MCRE0_WRK_ACQUISIZIONE a)
                    AND a.dta_fine_validita <=
                           (SELECT NVL (MAX (DTA_INS), SYSDATE)
                              FROM t_mcre0_wrk_audit_etl
                             WHERE procedura =
                                      '1_1 - PKG_MCRE0_TWS - END - Storicizza in seguito ai caricamenti')
                    AND FLG_CAMBIO_GESTORE = '1'
                    AND cod_stato != '-1'                        --solo attivi
           GROUP BY a.FLG_CAMBIO_GESTORE)
   UNION
   SELECT 'Numero di posizioni riportafogliate' AS controllo,
          n_posizioni AS quanti
     FROM (SELECT COUNT (cod_abi_cartolarizzato || cod_ndg) n_posizioni,
                  COUNT (DISTINCT COD_GRUPPO_SUPER) n_gruppi
             FROM t_mcre0_app_all_data_DAY
            WHERE     FLG_RIPORTAFOGLIATO = '1'
                  AND today_flg = '1'
                  AND FLG_ACTIVE = '1')
   UNION
   SELECT 'Numero di gruppi super riportafogliati' AS controllo,
          n_gruppi AS quanti
     FROM (SELECT COUNT (DISTINCT COD_GRUPPO_SUPER) n_gruppi
             FROM t_mcre0_app_all_data_DAY
            WHERE     FLG_RIPORTAFOGLIATO = '1'
                  AND today_flg = '1'
                  AND FLG_ACTIVE = '1');


GRANT DELETE, INSERT, REFERENCES, SELECT, UPDATE, ON COMMIT REFRESH, QUERY REWRITE, DEBUG, FLASHBACK ON MCRE_OWN.VTMCRE0_CHECK_POS_EXACT TO MCRE_USR;
