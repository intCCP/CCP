/* Formatted on 21/07/2014 18:39:10 (QP5 v5.227.12220.39754) */
CREATE OR REPLACE FORCE VIEW MCRE_OWN.V_MCREI_APP_CHECK_ABI_LOAD
(
   COD_DIPENDENZA,
   ABI,
   FLUSSO,
   ID_DPER,
   DTA_INIZIO,
   DTA_FINE,
   "TEMPO LOAD FLUSSO sec",
   "TEMPO TOT LOAD ABI sec",
   VAL_SCARTI_CONVERT,
   VAL_SCARTI_VINCOLI,
   DESC_CARICAMENTO,
   FLG_ABI_LAVORATO
)
AS
     SELECT dipendenza || '-' || NVL (cod_abi, 'MULTI') cod_dipendenza,
            NVL (cod_abi, 'MULTI') abi,
            flusso,
            periodo_contr id_dper,
            dta_inizio,
            dta_fine,
            (dta_fine - dta_inizio) * 24 * 60 * 60 AS "TEMPO LOAD FLUSSO sec",
            (max_per_abi - min_per_abi) * 24 * 60 * 60
               AS "TEMPO TOT LOAD ABI sec",
            val_scarti_convert,
            val_scarti_vincoli,
            CASE
               WHEN     flusso = 'SISBA'
                    AND periodo_contr <> LAST_DAY (periodo_contr)
               THEN
                  NVL (
                     desc_caricamento,
                        'CARICAMENTO PREVISTO PER IL '
                     || TO_CHAR (LAST_DAY (periodo_contr), 'YYYYMMDD'))
               ELSE
                  NVL (desc_caricamento, 'FLUSSO MANCANTE')
            END
               desc_caricamento,
            CASE
               WHEN     flusso = 'SISBA'
                    AND periodo_contr <> LAST_DAY (periodo_contr)
               THEN
                  NVL (desc_caricamento, '0')
               ELSE
                  NVL (desc_caricamento, '0')
            END
               flg_abi_lavorato
       FROM (SELECT f.cod_abi,
                    flusso,
                    id_dper,
                    f.dipendenza,
                    dta_inizio,
                    dta_fine,
                    MIN (dta_inizio)
                       OVER (PARTITION BY f.cod_abi, dipendenza, id_dper)
                       min_per_abi,
                    MAX (dta_fine)
                       OVER (PARTITION BY f.cod_abi, dipendenza, id_dper)
                       max_per_abi,
                    flg_abi_lavorato,
                    desc_caricamento,
                    periodo_contr,
                    val_scarti_convert,
                    val_scarti_vincoli
               FROM (SELECT q.id_flusso,
                            q.cod_flusso,
                            q.cod_abi,
                            q.id_dper,
                            q.dta_inizio,
                            q.dta_fine,
                            CASE
                               WHEN     (   q.cod_flusso = 'GGRATE'
                                         OR q.cod_flusso = 'RAPPORTI_ESTERO'
                                         OR q.cod_flusso = 'LIFA'
                                         OR q.cod_flusso LIKE
                                               ' PROPOSTE_MOPLE_0%')
                                    AND q.cod_stato = 'CARICATO'
                               THEN
                                  'SUCCESS: CARICAMENTO OK'
                               ELSE
                                  c.desc_caricamento
                            END
                               desc_caricamento,
                            CASE
                               WHEN     (   q.cod_flusso = 'GGRATE'
                                         OR q.cod_flusso = 'RAPPORTI_ESTERO'
                                         OR q.cod_flusso = 'LIFA'
                                         OR q.cod_flusso LIKE
                                               ' PROPOSTE_MOPLE_0%')
                                    AND q.cod_stato = 'CARICATO'
                               THEN
                                  '1'
                               ELSE
                                  DECODE (c.desc_caricamento,
                                          'SUCCESS: CARICAMENTO OK', '1',
                                          '0')
                            END
                               flg_abi_lavorato,
                            q.val_scarti_convert,
                            q.val_scarti_vincoli
                       FROM v_mcrei_wrk_check_caricamenti c,
                            t_mcrei_wrk_acquisizione q
                      WHERE     c.id_flusso(+) = q.id_flusso
                            AND q.cod_stato(+) = 'CARICATO') a,
                    (SELECT cod_abi,
                            flusso,
                            dipendenza,
                            periodo_contr
                       FROM t_mcrei_wrk_anag_flussi,
                            (SELECT MAX (id_dper - 4) periodo_contr
                               FROM t_mcrei_wrk_acquisizione)) f
              WHERE     NVL (a.cod_abi(+), 'MULTI') = NVL (f.cod_abi, 'MULTI')
                    AND a.cod_flusso(+) = f.flusso
                    AND a.id_dper(+) = periodo_contr)
   ORDER BY 1, 2 ASC;
