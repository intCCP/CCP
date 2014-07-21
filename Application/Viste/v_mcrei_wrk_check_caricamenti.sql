/* Formatted on 21/07/2014 18:41:09 (QP5 v5.227.12220.39754) */
CREATE OR REPLACE FORCE VIEW MCRE_OWN.V_MCREI_WRK_CHECK_CARICAMENTI
(
   ID_FLUSSO,
   COD_FLUSSO,
   ABI,
   PERIODO,
   DATA_CARICAMENTO,
   DESC_CARICAMENTO
)
AS
     SELECT "ID_FLUSSO",
            "COD_FLUSSO",
            "ABI",
            "PERIODO",
            "DATA_CARICAMENTO",
            "DESC_CARICAMENTO"
       FROM (SELECT qdc.id_flusso id_flusso,
                    qdc.flusso cod_flusso,
                    NVL (qdc.cod_abi, 'MULTI') abi,
                    TO_DATE (TO_CHAR (qdc.id_dper), 'YYYYMMDD') periodo,
                    qdc.dta_upd data_caricamento,
                    CASE
                       WHEN qdc.cod_stato = 'APP CARICATA E ARCHIVIATI FLG 0'
                       THEN
                          'SUCCESS: CARICAMENTO OK'
                       WHEN qdc.cod_stato = 'HST CARICATA E ESTRATTI FLAG 1'
                       THEN
                          'SUCCESS: CARICAMENTO OK'
                       WHEN qdc.cod_stato = 'APP CARICATA E FLG CALCOLATI'
                       THEN
                          'FAILURE:  PROBABILI ERRORI SULL''ARCHIVIATORE'
                       WHEN qdc.cod_stato = 'CARICATA APP'
                       THEN
                          (CASE
                              WHEN qdc.flusso IN
                                      ('PCR_RAPPORTI',
                                       'PARTI_CORRELATE',
                                       'ANAGR_GRUPPO_COINT',
                                       'LEGAMI_COINT',
                                       'FILE_GUIDA_COINT',
                                       'BENI',
                                       'BILANCI')
                              THEN
                                 'SUCCESS: CARICAMENTO OK'
                              ELSE
                                 'FAILURE:  PROBABILI ERRORI NEL CALCOLO FLG'
                           END)
                       WHEN qdc.cod_stato = 'CARICATA HST '
                       THEN
                          'FAILURE:   PROBABILI ERRORI SULL''ESTRATTORE'
                       WHEN qdc.cod_stato = 'VALIDO'
                       THEN
                          (CASE
                              WHEN qdc.flusso IN
                                      ('SISBA',
                                       'PROPOSTE_MOPLE_01',
                                       'PROPOSTE_MOPLE_03',
                                       'PROPOSTE_MOPLE_04',
                                       'PROPOSTE_MOPLE_05',
                                       'PROPOSTE_MOPLE_06')
                              THEN
                                 'SUCCESS: CARICAMENTO OK'
                              ELSE
                                 'WARNING : DIPENDENZE NON SODDISFATTE'
                           END)
                       WHEN     acq.cod_stato = 'CARICATO'
                            AND acq.cod_flusso = 'GGRATE'
                       THEN
                          'SUCCESS: CARICAMENTO OK'
                       ELSE
                          'FAILURE:   ERRORE II LIV'
                    END
                       desc_caricamento
               FROM t_mcrei_wrk_acquisizione acq, t_mcrei_wrk_qdc qdc
              WHERE acq.id_flusso(+) = qdc.id_flusso
             UNION
             SELECT acq.id_flusso id_flusso,
                    acq.cod_flusso cod_flusso,
                    acq.cod_abi abi,
                    acq.id_dper periodo,
                    acq.dta_fine data_caricamento,
                    NVL (acq.cod_stato, 'FAILURE:   ERRORE I LIV')
                       desc_caricamento
               FROM t_mcrei_wrk_acquisizione acq, t_mcrei_wrk_qdc qdc
              WHERE     acq.id_flusso = qdc.id_flusso(+)
                    AND qdc.id_flusso IS NULL
                    AND acq.cod_flusso = qdc.flusso
                    AND acq.id_dper =
                           TO_DATE (TO_CHAR (qdc.id_dper), 'YYYYMMDD')
             UNION
             SELECT acq.id_flusso id_flusso,
                    acq.cod_flusso cod_flusso,
                    acq.cod_abi abi,
                    acq.id_dper periodo,
                    acq.dta_fine data_caricamento,
                    DECODE (acq.cod_stato,
                            'CARICATO', 'SUCCESS: CARICAMENTO OK',
                            'FAILURE:   ERRORE I LIV')
               FROM t_mcrei_wrk_acquisizione acq
              WHERE     cod_flusso = 'RATE_DAILY'
                    AND acq.cod_stato != 'PERIODO GIA'' CARICATO')
   ORDER BY id_flusso DESC;
