/* Formatted on 17/06/2014 17:59:46 (QP5 v5.227.12220.39754) */
CREATE OR REPLACE FORCE VIEW MCRE_OWN.V_CK_ACQ_SAG

(ID_FLUSSO, COD_FILE, ID_PER, STEP, ESITO, 

 STATO_FILE, INIZIO_ACQ, TMS_STATO)

AS 



SELECT   tmp.id_flusso, idp.cod_file, idp.id_dper,



            COALESCE



               (CASE



                   WHEN le.nome_funzione = 'PKG_MCRE0_UTILS.FND_MCRE0_checkIn'



                      THEN '1_VALIDAZIONE PERIODO'



                   WHEN le.nome_funzione =



                                     'PKG_MCR0_CONFORMITA.verifica_conformita'



                      THEN '2_VERIFICA CONFORMITA'



                   WHEN le.nome_funzione = 'EXTERNAL TABLE SENZA SCARTI'



                      THEN '3_VERIFICA SCARTI EXTERNAL'



                   WHEN le.nome_funzione LIKE '%PKG_MCRE0_CONVERSIONE%'



                      THEN '4_CONVERSIONE'



                   WHEN le.nome_funzione =



                          'PKG_MCRE0_FUNZIONI_SLAVEFND_MCRE0_analyze_table_FL'



                      THEN '5_TABELLA FL POPOLATA E ANALIZZATA'



                   WHEN le.nome_funzione =



                          'PKG_MCRE0_FUNZIONI_SLAVEFND_MCRE0_analyze_table_ST'



                      THEN '6_TABELLA ST POPOLATA E ANALIZZATA'



                   WHEN le.nome_funzione =



                          'PKG_MCRE0_FUNZIONI_SLAVEFND_MCRE0_analyze_table_APP'



                      THEN '7_TABELLA APP POPOLATA E ANALIZZATA'



                END,



                CASE



                   WHEN tmp.step = 'PKG_MCRE0_UTILS.FND_MCRE0_checkIn'



                      THEN '1_VALIDAZIONE PERIODO'



                   WHEN tmp.step = 'PKG_MCR0_CONFORMITA.verifica_conformita'



                      THEN '2_VERIFICA CONFORMITA'



                   WHEN tmp.step = 'EXTERNAL TABLE SENZA SCARTI'



                      THEN '3_VERIFICA SCARTI EXTERNAL'



                   WHEN tmp.step LIKE '%PKG_MCRE0_CONVERSIONE%'



                      THEN '4_CONVERSIONE'



                   WHEN tmp.step =



                          'PKG_MCRE0_FUNZIONI_SLAVEFND_MCRE0_analyze_table_FL'



                      THEN '5_TABELLA FL POPOLATA E ANALIZZATA'



                   WHEN tmp.step =



                          'PKG_MCRE0_FUNZIONI_SLAVEFND_MCRE0_analyze_table_ST'



                      THEN '6_TABELLA ST POPOLATA E ANALIZZATA'



                   WHEN tmp.step =



                          'PKG_MCRE0_FUNZIONI_SLAVEFND_MCRE0_analyze_table_APP'



                      THEN '7_TABELLA APP POPOLATA E ANALIZZATA'



                   ELSE ''



                END



               ) AS step,



            COALESCE (le.esito, 'NON ESEGUITO') AS esito,



            CASE le.stato



               WHEN 'CARICATO'



                  THEN le.stato



               ELSE 'NON CARICATO'



            END AS stato_file,



            idp.inizio_acq, idp.fine_acq



       FROM (SELECT step, id_flusso



               FROM (SELECT 'PKG_MCRE0_UTILS.FND_MCRE0_checkIn' AS step,



                            (SELECT DISTINCT id_flusso



                                        FROM t_mcre0_wrk_acquisizione



                                       WHERE cod_file = 'SAG'



                                         AND periodo_riferimento =



                                                (SELECT MAX



                                                           (periodo_riferimento



                                                           ) AS id_dper



                                                   FROM t_mcre0_wrk_acquisizione



                                                  WHERE cod_file = 'SAG'))



                                                                 AS id_flusso



                       FROM DUAL



                     UNION



                     SELECT 'PKG_MCR0_CONFORMITA.verifica_conformita',



                            (SELECT DISTINCT id_flusso



                                        FROM t_mcre0_wrk_acquisizione



                                       WHERE cod_file = 'SAG'



                                         AND periodo_riferimento =



                                                (SELECT MAX



                                                           (periodo_riferimento



                                                           ) AS id_dper



                                                   FROM t_mcre0_wrk_acquisizione



                                                  WHERE cod_file = 'SAG'))



                                                                 AS id_flusso



                       FROM DUAL



                     UNION



                     SELECT 'EXTERNAL TABLE SENZA SCARTI',



                            (SELECT DISTINCT id_flusso



                                        FROM t_mcre0_wrk_acquisizione



                                       WHERE cod_file = 'SAG'



                                         AND periodo_riferimento =



                                                (SELECT MAX



                                                           (periodo_riferimento



                                                           ) AS id_dper



                                                   FROM t_mcre0_wrk_acquisizione



                                                  WHERE cod_file = 'SAG'))



                                                                 AS id_flusso



                       FROM DUAL



                     UNION



                     SELECT 'PKG_MCRE0_CONVERSIONE',



                            (SELECT DISTINCT id_flusso



                                        FROM t_mcre0_wrk_acquisizione



                                       WHERE cod_file = 'SAG'



                                         AND periodo_riferimento =



                                                (SELECT MAX



                                                           (periodo_riferimento



                                                           ) AS id_dper



                                                   FROM t_mcre0_wrk_acquisizione



                                                  WHERE cod_file = 'SAG'))



                                                                 AS id_flusso



                       FROM DUAL



                     UNION



                     SELECT 'PKG_MCRE0_FUNZIONI_SLAVEFND_MCRE0_analyze_table_FL',



                            (SELECT DISTINCT id_flusso



                                        FROM t_mcre0_wrk_acquisizione



                                       WHERE cod_file = 'SAG'



                                         AND periodo_riferimento =



                                                (SELECT MAX



                                                           (periodo_riferimento



                                                           ) AS id_dper



                                                   FROM t_mcre0_wrk_acquisizione



                                                  WHERE cod_file = 'SAG'))



                                                                 AS id_flusso



                       FROM DUAL



                     UNION



                     SELECT 'PKG_MCRE0_FUNZIONI_SLAVEFND_MCRE0_analyze_table_ST',



                            (SELECT DISTINCT id_flusso



                                        FROM t_mcre0_wrk_acquisizione



                                       WHERE cod_file = 'SAG'



                                         AND periodo_riferimento =



                                                (SELECT MAX



                                                           (periodo_riferimento



                                                           ) AS id_dper



                                                   FROM t_mcre0_wrk_acquisizione



                                                  WHERE cod_file = 'SAG'))



                                                                 AS id_flusso



                       FROM DUAL



                     UNION



                     SELECT 'PKG_MCRE0_FUNZIONI_SLAVEFND_MCRE0_analyze_table_APP',



                            (SELECT DISTINCT id_flusso



                                        FROM t_mcre0_wrk_acquisizione



                                       WHERE cod_file = 'SAG'



                                         AND periodo_riferimento =



                                                (SELECT MAX



                                                           (periodo_riferimento



                                                           ) AS id_dper



                                                   FROM t_mcre0_wrk_acquisizione



                                                  WHERE cod_file = 'SAG'))



                                                                 AS id_flusso



                       FROM DUAL) tmp1) tmp



            LEFT OUTER JOIN



            (SELECT   ev.*, ac.stato



                 FROM t_mcre0_wrk_log_eventi ev INNER JOIN t_mcre0_wrk_acquisizione ac



                      ON ev.id_flusso = ac.id_flusso



             ORDER BY ID ASC) le



            ON le.nome_funzione LIKE '%' || tmp.step || '%'



          AND tmp.id_flusso = le.id_flusso



            ,



            (SELECT   MAX (periodo_riferimento) AS id_dper, cod_file,



                      MAX (tms_file) AS inizio_acq,



                      MAX (tms_stato) AS fine_acq



                 FROM t_mcre0_wrk_acquisizione



                WHERE cod_file = 'SAG'



             GROUP BY cod_file) idp



   ORDER BY step ASC;


GRANT SELECT ON MCRE_OWN.V_CK_ACQ_SAG TO MCRE_USR;
