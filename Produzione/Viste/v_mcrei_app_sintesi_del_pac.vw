/* Formatted on 17/06/2014 18:08:49 (QP5 v5.227.12220.39754) */
CREATE OR REPLACE FORCE VIEW MCRE_OWN.V_MCREI_APP_SINTESI_DEL_PAC
(
   COD_PROTOCOLLO_PACCHETTO,
   COD_SNDG,
   COD_MICROTIPOLOGIA_DELIB,
   COD_FASE_MICROTIPOLOGIA,
   COD_FASE_PACCHETTO,
   FLG_FORZ_DA_IMP,
   DTA_CREAZIONE_PACCHETTO,
   FLG_ALTRO,
   COD_ORGANO_PACCHETTO,
   COD_ORGANO_PACCHETTO_CALC,
   DTA_DELIBERA,
   VAL_TOT_DELIBERATO_DERIVATI,
   VAL_TOT_PROPOSTA_DERIVATI,
   VAL_TOT_DERIVATI,
   DTA_SCADENZA,
   VAL_RINUNCIA_CORRENTE,
   DTA_SCADENZA_PROPOSTA,
   VAL_TOT_DELIBERATO_CASSA,
   VAL_TOT_DELIBERATO_FIRMA,
   VAL_RINUNCIA_PREGRESSA,
   VAL_RINUNCIA_DELIBERATA,
   VAL_TOT_PROPOSTA_CASSA,
   VAL_TOT_PROPOSTA_FIRMA,
   VAL_TOT_CASSA,
   VAL_TOT_FIRMA,
   VAL_TOT_RETTIFICA,
   DESC_MICROTIPOLOGIA,
   FLG_PACCHETTO_CLONATO
)
AS
   SELECT DISTINCT
          dd.cod_protocollo_pacchetto,
          dd.cod_sndg,
          dd.cod_microtipologia_delib,
          dd.cod_fase_microtipologia,
          dd.cod_fase_pacchetto,
          dd.flg_forz_da_imp,                                      --27 luglio
          TRUNC (dd.dta_creazione_pacchetto) AS dta_creazione_pacchetto,
          --inserita trunc il 27/2
          dd.flg_altro,
          dd.cod_organo_pacchetto,
          dd.cod_organo_pacchetto_calc,                                  --9/3
          MIN (
             dd.dta_delibera)
          OVER (
             PARTITION BY dd.cod_protocollo_pacchetto,
                          dd.cod_microtipologia_delib)
             AS dta_delibera,
          ---AGGIUNTO IL 24/2
          SUM (
             dd.val_tot_deliberato_derivati)
          OVER (
             PARTITION BY dd.cod_protocollo_pacchetto,
                          dd.cod_microtipologia_delib)
             AS val_tot_deliberato_derivati,
          --29 MARZO: AGGIUNTI CASE PER MASCHERARE CAMPI IN VISUALIZZAZIONE
          --8 GIU: MASCHERO CAMPI ANCHE PER CH
          --3 SET: MASCHERATI CAMPI ANCHE PER TP E DR
          (CASE
              WHEN (   dd.cod_microtipologia_delib IN ('CI', 'CS', 'CH')
                    OR dd.cod_macrotipologia_delib IN ('TP', 'DR'))
              THEN
                 TO_NUMBER (NULL)
              ELSE
                 SUM (
                    val_tot_proposta_derivati)
                 OVER (
                    PARTITION BY dd.cod_protocollo_pacchetto,
                                 dd.cod_microtipologia_delib)
           END)
             AS val_tot_proposta_derivati,
          (CASE
              WHEN dd.cod_microtipologia_delib IN ('CI', 'CS', 'CH')
              THEN
                 TO_NUMBER (NULL)
              ELSE
                 SUM (
                    val_tot_derivati)
                 OVER (
                    PARTITION BY dd.cod_protocollo_pacchetto,
                                 dd.cod_microtipologia_delib)
           END)
             AS val_tot_derivati,
          MAX (
             NVL (dd.dta_scadenza, dd.dta_scadenza_transaz)) -- 4 SET SU INDICAZIONE UTENTE
          OVER (
             PARTITION BY dd.cod_protocollo_pacchetto,
                          dd.cod_microtipologia_delib)
             AS dta_scadenza,
          (CASE
              WHEN dd.cod_microtipologia_delib IN ('CI', 'CS', 'CH')
              THEN
                 TO_NUMBER (NULL)
              ELSE
                 SUM (
                    NVL (dd.val_rinuncia_proposta, 0))
                 --23 aprile
                 OVER (
                    PARTITION BY dd.cod_protocollo_pacchetto,
                                 dd.cod_microtipologia_delib)
           --17 aprile
           END)
             AS val_rinuncia_corrente,
          MAX (
             NVL (dd.dta_scadenza, dd.dta_scadenza_transaz))          --18 lug
          OVER (
             PARTITION BY dd.cod_protocollo_pacchetto,
                          dd.cod_microtipologia_delib)
             AS dta_scadenza_proposta,
          ----aggiunta sum 23 marzo
          SUM (
             NVL (dd.val_tot_deliberato_cassa, 0))
          OVER (
             PARTITION BY dd.cod_protocollo_pacchetto,
                          dd.cod_microtipologia_delib)
             AS val_tot_deliberato_cassa,
          SUM (
             NVL (d2.val_rdv_progr_fi, 0))
          OVER (
             PARTITION BY dd.cod_protocollo_pacchetto,
                          dd.cod_microtipologia_delib)
             AS val_tot_deliberato_firma,
          SUM (
             NVL (dd.val_rinuncia_deliberata, 0))
          OVER (
             PARTITION BY dd.cod_protocollo_pacchetto,
                          dd.cod_microtipologia_delib)
             AS val_rinuncia_pregressa,
          ---10 aprile
          (CASE
              WHEN (dd.cod_microtipologia_delib IN ('CI', 'CS', 'CH'))
              THEN
                 TO_NUMBER (NULL)
              ELSE
                 SUM (
                    NVL (dd.val_imp_perdita, 0))
                 OVER (
                    PARTITION BY dd.cod_protocollo_pacchetto,
                                 dd.cod_microtipologia_delib)
           END)
             AS val_rinuncia_deliberata,
          (CASE
              WHEN (   dd.cod_microtipologia_delib IN ('CI', 'CS', 'CH')
                    OR dd.cod_macrotipologia_delib IN ('TP', 'DR'))
              THEN
                 TO_NUMBER (NULL)
              ELSE
                 SUM (
                      NVL (dd.val_tot_cassa, 0)
                    - NVL (dd.val_tot_deliberato_cassa, 0))
                 OVER (
                    PARTITION BY dd.cod_protocollo_pacchetto,
                                 dd.cod_microtipologia_delib)
           END)
             AS val_tot_proposta_cassa,
          (CASE
              WHEN (   dd.cod_microtipologia_delib IN ('CI', 'CS', 'CH')
                    OR dd.cod_macrotipologia_delib IN ('TP', 'DR'))
              THEN
                 TO_NUMBER (NULL)
              ELSE
                 SUM (
                      NVL (dd.val_rdv_progr_fi, 0)
                    - NVL (d2.val_rdv_progr_fi, 0))
                 OVER (
                    PARTITION BY dd.cod_protocollo_pacchetto,
                                 dd.cod_microtipologia_delib)
           END)
             AS val_tot_proposta_firma,
          (CASE
              WHEN (   dd.cod_microtipologia_delib IN ('CI', 'CS', 'CH')
                    OR dd.cod_macrotipologia_delib IN ('TP', 'DR'))
              THEN
                 TO_NUMBER (NULL)
              ELSE
                 SUM (
                    dd.val_tot_cassa)
                 OVER (
                    PARTITION BY dd.cod_protocollo_pacchetto,
                                 dd.cod_microtipologia_delib)
           END)
             AS val_tot_cassa,
          (CASE
              WHEN (   dd.cod_microtipologia_delib IN ('CI', 'CS', 'CH')
                    OR dd.cod_macrotipologia_delib IN ('TP', 'DR'))
              THEN
                 TO_NUMBER (NULL)
              ELSE
                 SUM (
                    dd.val_tot_firma)
                 OVER (
                    PARTITION BY dd.cod_protocollo_pacchetto,
                                 dd.cod_microtipologia_delib)
           END)
             AS val_tot_firma,
          (CASE
              WHEN (   dd.cod_microtipologia_delib IN ('CI', 'CS', 'CH')
                    OR dd.cod_macrotipologia_delib IN ('TP', 'DR'))
              THEN
                 TO_NUMBER (NULL)
              ELSE
                 SUM (
                      NVL (dd.val_rdv_progr_fi, 0)
                    + NVL (dd.val_rdv_qc_progressiva, 0))
                 OVER (
                    PARTITION BY dd.cod_protocollo_pacchetto,
                                 dd.cod_microtipologia_delib)
           END)
             AS val_tot_rettifica,
          desc_microtipologia,
          dd.flg_pacchetto_clonato
     --,dd.cod_pacchetto_servizio
     --,dd.cod_delibera_servizio
     FROM (SELECT DISTINCT
                  ----aggiunta distinct 27/2                  -- DISTINCT
                  --02.15 aggiunto fesa_delibera != 'AN'
                  --0216 aggiunto flg_altro
                  --0217 aggiunte sum su valori rinuncia etc..
                  --0220 usato filtro pacchetto con client-info
                  --0223 aggiunta query esterna di sum
                  --0321 recuperati dati dalle delibere invece che dalle stime, eccetto che per i derivati
                  /*DA ESEGUIRE PRIMA DELLA CHIAMATA ALLA VISTA
                         BEGIN dbms_application_info.set_client_info( cod_protocollo_pacchetto ); END;*/
                  cod_protocollo_pacchetto,
                  d.cod_sndg,
                  cod_microtipologia_delib,
                  cod_macrotipologia_delib,
                  d.cod_fase_microtipologia,
                  cod_fase_pacchetto,
                  dta_creazione_pacchetto,
                  dta_delibera,
                  d.cod_organo_pacchetto,
                  d.cod_organo_pacchetto_calc,
                  NVL (d.val_imp_perdita, 0) AS val_imp_perdita,
                  DECODE (t.flg_altro,  1, 'Y',  0, 'N',  'N') flg_altro,
                  NVL (d.val_rdv_qc_ante_delib, 0)
                     AS val_tot_deliberato_cassa,
                  CASE
                     WHEN     cod_classe_ft = 'ST'
                          AND cod_microtipologia_delib NOT IN
                                 ('CI', 'CS', 'CH')
                     THEN
                        SUM (
                           val_imp_rettifica_pregr)
                        OVER (
                           PARTITION BY cod_protocollo_pacchetto,
                                        cod_microtipologia_delib,
                                        cod_classe_ft)
                     ELSE
                        0
                  END
                     val_tot_deliberato_derivati,
                  (  NVL (d.val_rdv_qc_progressiva, 0)
                   - NVL (d.val_rdv_qc_ante_delib, 0))
                     AS val_tot_proposta_cassa,
                  NVL (d.val_rdv_progr_fi, 0) val_rdv_progr_fi,
                  CASE
                     WHEN     cod_classe_ft = 'ST'
                          AND cod_microtipologia_delib NOT IN
                                 ('CI', 'CS', 'CH')
                     THEN
                        SUM (
                           val_imp_rettifica_att)
                        OVER (
                           PARTITION BY cod_protocollo_pacchetto,
                                        cod_microtipologia_delib,
                                        cod_classe_ft)
                     ELSE
                        0
                  END
                     val_tot_proposta_derivati,
                  NVL (d.val_rdv_qc_progressiva, 0) AS val_tot_cassa,
                  NVL (d.val_rdv_progr_fi, 0) AS val_tot_firma,
                  CASE
                     WHEN     cod_classe_ft = 'ST'
                          AND cod_microtipologia_delib NOT IN
                                 ('CI', 'CS', 'CH')
                     THEN
                        SUM (
                           val_rdv_tot)
                        OVER (
                           PARTITION BY cod_protocollo_pacchetto,
                                        cod_microtipologia_delib,
                                        cod_classe_ft)
                     ELSE
                        NULL
                  END
                     val_tot_derivati,
                  NVL (val_rdv_qc_progressiva, 0) val_rdv_qc_progressiva,
                  NVL (val_rinuncia_deliberata, 0) val_rinuncia_deliberata,
                  NVL (val_rinuncia_proposta, 0) val_rinuncia_proposta,
                  NVL (val_rinuncia_capitale, 0) AS val_rinuncia_capitale,
                  NVL (val_rinuncia_mora, 0) AS val_rinuncia_mora,
                  dta_scadenza,
                  dta_scadenza_transaz,
                  --18 lug
                  --val_rdv_tot,
                  d.cod_ndg,
                  d.cod_abi,
                  cod_protocollo_delibera_pre,
                  t.desc_microtipologia,
                  d.flg_forz_da_imp,
                  d.flg_pacchetto_clonato
             --,d.cod_pacchetto_servizio
             --,d.cod_delibera_servizio
             FROM t_mcrei_app_delibere d,
                  t_mcrei_app_stime s,
                  t_mcrei_cl_tipologie t
            WHERE     d.cod_protocollo_delibera =
                         s.cod_protocollo_delibera(+)
                  AND d.cod_abi = s.cod_abi(+)
                  AND d.cod_ndg = s.cod_ndg(+)
                  AND d.cod_fase_pacchetto NOT IN
                         ('ANA', 'ANM', 'CNF', 'ULT') -- 9 GENNAIO: AD, ESCLUSO ULT PER SICUREZZA
                  --13Dicembre
                  AND d.cod_fase_delibera NOT IN ('AN')           --13Dicembre
                  AND d.flg_attiva = '1'
                  AND s.flg_attiva(+) = '1'
                  AND t.cod_microtipologia = d.cod_microtipologia_delib
                  AND d.cod_protocollo_pacchetto =
                         (SYS_CONTEXT ('userenv', 'client_info'))) dd,
          t_mcrei_app_delibere d2
    WHERE     dd.cod_abi = d2.cod_abi(+)
          AND dd.cod_ndg = d2.cod_ndg(+)
          AND dd.cod_protocollo_delibera_pre = d2.cod_protocollo_delibera(+);


GRANT DELETE, INSERT, REFERENCES, SELECT, UPDATE, ON COMMIT REFRESH, QUERY REWRITE, DEBUG, FLASHBACK, MERGE VIEW ON MCRE_OWN.V_MCREI_APP_SINTESI_DEL_PAC TO MCRE_USR;
