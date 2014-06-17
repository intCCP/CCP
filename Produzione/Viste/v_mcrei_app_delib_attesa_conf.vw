/* Formatted on 17/06/2014 18:07:38 (QP5 v5.227.12220.39754) */
CREATE OR REPLACE FORCE VIEW MCRE_OWN.V_MCREI_APP_DELIB_ATTESA_CONF
(
   COD_PROTOCOLLO_PACCHETTO,
   COD_SNDG,
   DESC_NOME_CONTROPARTE,
   COD_MICROTIPOLOGIA_DELIB,
   COD_FASE_PACCHETTO,
   COD_FASE_MICROTIPOLOGIA,
   VAL_RET_TOT_DA_DELIB_CASSA,
   VAL_RET_TOT_DA_DELIB_FIRMA,
   VAL_RET_TOT_DA_DELIB_DERIVATI,
   TOT_RETTIFICA_DA_DELIB,
   DTA_SCADENZA_TOT_DA_DELIB,
   VAL_RDV_TOT_CASSA,
   VAL_RDV_TOT_FIRMA,
   VAL_RDV_TOT_DERIVATI,
   VAL_RDV_TOT,
   TOT_RINUNCIA_DA_DELIB
)
AS
   SELECT DISTINCT
          cod_protocollo_pacchetto,
          ---5 LUGLIO: RAGGRUPPAMENTI PER ELIMINAZIONE DUPLICATI SU VALORI NUMERICI
          cod_sndg,
          desc_nome_controparte,
          cod_microtipologia_delib,
          cod_fase_pacchetto,
          cod_fase_microtipologia,
          ---5 set: mascherati campi di rdv per le TP e DR
          SUM (
             val_ret_tot_da_delib_cassa)
          OVER (
             PARTITION BY cod_protocollo_pacchetto, cod_microtipologia_delib)
             AS val_ret_tot_da_delib_cassa,
          SUM (
             val_ret_tot_da_delib_firma)
          OVER (
             PARTITION BY cod_protocollo_pacchetto, cod_microtipologia_delib)
             AS val_ret_tot_da_delib_firma,
          SUM (
             val_ret_tot_da_delib_derivati)
          OVER (
             PARTITION BY cod_protocollo_pacchetto, cod_microtipologia_delib)
             AS val_ret_tot_da_delib_derivati,
          SUM (
             tot_rettifica_da_delib)
          OVER (
             PARTITION BY cod_protocollo_pacchetto, cod_microtipologia_delib)
             AS tot_rettifica_da_delib,
          dta_scadenza_tot_da_delib,
          SUM (
             val_rdv_tot_cassa)
          OVER (
             PARTITION BY cod_protocollo_pacchetto, cod_microtipologia_delib)
             AS val_rdv_tot_cassa,
          SUM (
             val_rdv_tot_firma)
          OVER (
             PARTITION BY cod_protocollo_pacchetto, cod_microtipologia_delib)
             AS val_rdv_tot_firma,
          SUM (
             val_rdv_tot_derivati)
          OVER (
             PARTITION BY cod_protocollo_pacchetto, cod_microtipologia_delib)
             AS val_rdv_tot_derivati,
          SUM (
             val_rdv_tot)
          OVER (
             PARTITION BY cod_protocollo_pacchetto, cod_microtipologia_delib)
             AS val_rdv_tot,
          MAX (
             tot_rinuncia_da_delib)
          OVER (
             PARTITION BY cod_protocollo_pacchetto, cod_microtipologia_delib)
             AS tot_rinuncia_da_delib
     FROM (SELECT              --02.15 aggiunto filtro fase_microtipol = 'ATT'
                  --RISTRUTTURATA COMPLETAMENTE IL 13 APRILE
                  cod_protocollo_pacchetto,
                  d.cod_sndg,
                  desc_nome_controparte,
                  cod_microtipologia_delib,
                  cod_fase_pacchetto,
                  cod_fase_microtipologia,
                  --valori da deliberare
                  (CASE
                      WHEN (   d.cod_microtipologia_delib IN
                                  ('CI', 'CS', 'CH')
                            OR d.cod_macrotipologia_delib IN ('TP', 'DR'))
                      THEN
                         TO_NUMBER (NULL)
                      ELSE
                         d.val_rdv_qc_progressiva
                   END)
                     AS val_ret_tot_da_delib_cassa,
                  (CASE
                      WHEN (   d.cod_microtipologia_delib IN
                                  ('CI', 'CS', 'CH')
                            OR d.cod_macrotipologia_delib IN ('TP', 'DR'))
                      THEN
                         TO_NUMBER (NULL)
                      ELSE
                         d.val_rdv_progr_fi
                   END)
                     AS val_ret_tot_da_delib_firma,
                  TO_NUMBER (NULL) AS val_ret_tot_da_delib_derivati,
                  ---tot_da deliberare
                  (CASE
                      WHEN (   d.cod_microtipologia_delib IN
                                  ('CI', 'CS', 'CH')
                            OR d.cod_macrotipologia_delib IN ('TP', 'DR'))
                      THEN
                         TO_NUMBER (NULL)
                      ELSE
                         (  NVL (d.val_rdv_qc_progressiva, 0)
                          + NVL (d.val_rdv_progr_fi, 0) ----17 luglio commentato su indicazione utente
                                                        /*+ NVL (
                               (pkg_mcrei_gest_delibere.fnc_mcrei_get_last_rinuncia ( -- aggiunto NVL 27 giugno
                                   d.cod_abi,
                                   d.cod_ndg,
                                   'CT'
                                )),
                               0
                            )*/
                         )                                         --13 aprile
                   END)
                     AS tot_rettifica_da_delib,
                  MAX (NVL (dta_scadenza, dta_scadenza_transaz))
                     OVER (PARTITION BY d.cod_sndg, cod_microtipologia_delib)
                     AS dta_scadenza_tot_da_delib,
                  ---5 luglio
                  (CASE
                      WHEN (   d.cod_microtipologia_delib IN
                                  ('CI', 'CS', 'CH')
                            OR d.cod_macrotipologia_delib IN ('TP', 'DR'))
                      THEN
                         TO_NUMBER (NULL)
                      ELSE
                         d.val_rdv_qc_progressiva
                   END)
                     AS val_rdv_tot_cassa,
                  (CASE
                      WHEN (   d.cod_microtipologia_delib IN
                                  ('CI', 'CS', 'CH')
                            OR d.cod_macrotipologia_delib IN ('TP', 'DR'))
                      THEN
                         TO_NUMBER (NULL)
                      ELSE
                         d.val_rdv_progr_fi
                   END)
                     AS val_rdv_tot_firma,
                  TO_NUMBER (NULL) AS val_rdv_tot_derivati,
                  (CASE
                      WHEN (   d.cod_microtipologia_delib IN
                                  ('CI', 'CS', 'CH')
                            OR d.cod_macrotipologia_delib IN ('TP', 'DR'))
                      THEN
                         TO_NUMBER (NULL)
                      ELSE
                         (  NVL (d.val_rdv_qc_progressiva, 0)
                          + NVL (d.val_rdv_progr_fi, 0))
                   END)
                     AS val_rdv_tot,
                  (CASE
                      WHEN cod_microtipologia_delib IN ('CI', 'CS')
                      THEN
                         TO_NUMBER (NULL)
                      ELSE
                         d.val_imp_perdita                         --17 aprile
                   END)
                     AS tot_rinuncia_da_delib
             FROM t_mcrei_app_delibere d, t_mcre0_app_anagrafica_gruppo g
            WHERE     d.cod_macrotipologia_delib != 'TP'
                  -----SOLO GESTIONALI
                  AND d.cod_fase_pacchetto = 'CNF'
                  AND (   d.cod_fase_microtipologia = 'ATT'
                       OR (    d.cod_fase_microtipologia = 'CNF'
                           AND d.cod_microtipologia_delib IN
                                  (SELECT cod_microtipologia
                                     FROM t_mcrei_cl_tipologie
                                    WHERE    flg_segn_ristr = 1
                                          OR flg_contab_ademp = 1))
                       OR (    d.cod_fase_microtipologia = 'RIS'
                           AND d.cod_microtipologia_delib IN
                                  (SELECT cod_microtipologia
                                     FROM t_mcrei_cl_tipologie r
                                    WHERE r.flg_contab_ademp = 1   --21 giugno
                                                                )))
                  AND d.cod_fase_delibera NOT IN ('AN', 'VA')          --13dic
                  AND d.flg_no_delibera = '0'
                  AND d.flg_attiva = '1'
                  AND d.cod_sndg = g.cod_sndg
                  AND d.cod_protocollo_pacchetto =
                         (SYS_CONTEXT ('userenv', 'client_info'))
           --          AND D.COD_SNDG = '0000000015618210'
           UNION
           ----20 marzo per gestire nuova fase microtipologia ACT
           SELECT              --02.15 aggiunto filtro fase_microtipol = 'ATT'
                  --RISTRUTTURATA COMPLETAMENTE IL 13 APRILE
                  cod_protocollo_pacchetto,
                  d.cod_sndg,
                  desc_nome_controparte,
                  cod_microtipologia_delib,
                  cod_fase_pacchetto,
                  cod_fase_microtipologia,
                  --valori da deliberare
                  (CASE
                      WHEN (   d.cod_microtipologia_delib IN
                                  ('CI', 'CS', 'CH')
                            OR d.cod_macrotipologia_delib IN ('TP', 'DR'))
                      THEN
                         TO_NUMBER (NULL)
                      ELSE
                         d.val_rdv_qc_progressiva
                   END)
                     AS val_ret_tot_da_delib_cassa,
                  (CASE
                      WHEN (   d.cod_microtipologia_delib IN
                                  ('CI', 'CS', 'CH')
                            OR d.cod_macrotipologia_delib IN ('TP', 'DR'))
                      THEN
                         TO_NUMBER (NULL)
                      ELSE
                         d.val_rdv_progr_fi
                   END)
                     AS val_ret_tot_da_delib_firma,
                  TO_NUMBER (NULL) AS val_ret_tot_da_delib_derivati,
                  ---tot_da deliberare
                  (CASE
                      WHEN (   d.cod_microtipologia_delib IN
                                  ('CI', 'CS', 'CH')
                            OR d.cod_macrotipologia_delib IN ('TP', 'DR'))
                      THEN
                         TO_NUMBER (NULL)
                      ELSE
                         (  NVL (d.val_rdv_qc_progressiva, 0)
                          + NVL (d.val_rdv_progr_fi, 0) /*+ NVL (
                                                             (pkg_mcrei_gest_delibere.fnc_mcrei_get_last_rinuncia ( -- aggiunto NVL 27 giugno
                                                                 d.cod_abi,
                                                                 d.cod_ndg,
                                                                 'CT'
                                                              )),
                                                             0
                                                          )*/
                                                       )
                   --13 aprile
                   END)
                     AS tot_rettifica_da_delib,
                  MAX (dta_scadenza_transaz)     ---4 set: segnalazione utente
                     OVER (PARTITION BY d.cod_sndg, cod_microtipologia_delib)
                     AS dta_scadenza_tot_da_delib,
                  ---5 luglio
                  (CASE
                      WHEN (   d.cod_microtipologia_delib IN
                                  ('CI', 'CS', 'CH')
                            OR d.cod_macrotipologia_delib IN ('TP', 'DR'))
                      THEN
                         TO_NUMBER (NULL)
                      ELSE
                         d.val_rdv_qc_progressiva
                   END)
                     AS val_rdv_tot_cassa,
                  (CASE
                      WHEN (   d.cod_microtipologia_delib IN
                                  ('CI', 'CS', 'CH')
                            OR d.cod_macrotipologia_delib IN ('TP', 'DR'))
                      THEN
                         TO_NUMBER (NULL)
                      ELSE
                         d.val_rdv_progr_fi
                   END)
                     AS val_rdv_tot_firma,
                  TO_NUMBER (NULL) AS val_rdv_tot_derivati,
                  (CASE
                      WHEN (   d.cod_microtipologia_delib IN
                                  ('CI', 'CS', 'CH')
                            OR d.cod_macrotipologia_delib IN ('TP', 'DR'))
                      THEN
                         TO_NUMBER (NULL)
                      ELSE
                         (  NVL (d.val_rdv_qc_progressiva, 0)
                          + NVL (d.val_rdv_progr_fi, 0))
                   END)
                     AS val_rdv_tot,
                  (CASE
                      WHEN cod_microtipologia_delib IN ('CI', 'CS')
                      THEN
                         TO_NUMBER (NULL)
                      ELSE
                         d.val_imp_perdita
                   END)
                     AS tot_rinuncia_da_delib
             FROM t_mcrei_app_delibere d, t_mcre0_app_anagrafica_gruppo g
            WHERE     d.cod_macrotipologia_delib = 'TP'
                  -----SOLO TRANSAZIONI A PRONTI
                  AND d.cod_fase_pacchetto = 'CNF'
                  AND (   d.cod_fase_microtipologia = ('ATT')
                       OR                                         ---21 giugno
                          (    d.cod_fase_microtipologia = 'CNF'
                           AND d.cod_microtipologia_delib IN
                                  (SELECT cod_microtipologia
                                     FROM t_mcrei_cl_tipologie r
                                    WHERE r.flg_contab_ademp = 1)))
                  AND d.cod_fase_delibera NOT IN ('AN', 'VA')          --13dic
                  AND d.flg_no_delibera = '0'
                  AND d.flg_attiva = '1'
                  AND d.cod_sndg = g.cod_sndg
                  AND d.cod_protocollo_pacchetto =
                         (SYS_CONTEXT ('userenv', 'client_info')));


GRANT DELETE, INSERT, REFERENCES, SELECT, UPDATE, ON COMMIT REFRESH, QUERY REWRITE, DEBUG, FLASHBACK, MERGE VIEW ON MCRE_OWN.V_MCREI_APP_DELIB_ATTESA_CONF TO MCRE_USR;
