/* Formatted on 21/07/2014 18:40:08 (QP5 v5.227.12220.39754) */
CREATE OR REPLACE FORCE VIEW MCRE_OWN.V_MCREI_APP_DETTAGLIO_DELIBERA
(
   COD_PROTOCOLLO_PACCHETTO,
   COD_PROTOCOLLO_DELIBERA,
   COD_ABI,
   COD_NDG,
   COD_MICROTIPOLOGIA_DELIB,
   COD_FILIALE_DELIBERA,
   COD_STRUTTURA_COMPETENTE,
   COD_MATR_PRATICA,
   COD_MATRICOLA_INSERENTE,
   COD_SEGMENTO,
   DTA_CONSOLID_PROP_ORG_VIG,
   COD_TIPO_GESTIONE,
   DESC_TIPO_GESTIONE,
   COD_GRUPPO_ECONOMICO,
   VAL_ESP_LORDA,
   VAL_ESP_LORDA_CAPITALE,
   VAL_ESP_LORDA_MORA,
   VAL_RDV_QC_ANTE_DELIB,
   VAL_RDV_EXTRA_DELIBERA,
   VAL_ESP_NETTA_ANTE_DELIB,
   VAL_RDV_QC_DELIBERATA,
   VAL_RDV_QC_PROGRESSIVA,
   VAL_ESP_NETTA_POST_DELIB,
   VAL_PERC_RDV,
   VAL_STRALCIO_QUOTA_CAP,
   VAL_STRALCIO_QUOTA_MORA,
   COD_ORGANO_CALCOLATO,
   COD_ORGANO_DELIBERANTE,
   DESC_ORGANO_DELIBERANTE,
   DESC_ORGANO_CALCOLATO,
   DTA_DELIBERA,
   DTA_CONFERMA_DELIBERA,
   DTA_SCADENZA,
   DTA_SCADENZA_TRANSAZ,
   DTA_DELIBERA_ESTERO,
   DTA_SCADENZA_ESTERO,
   VAL_PERC_RDV_ESTERO,
   DTA_LAST_UPD_DELIBERA,
   COD_FASE_DELIBERA,
   DESC_FASE_DELIBERA,
   DESC_NOTE,
   VAL_IMP_PERDITA,
   VAL_SACRIF_CAPIT_MORA,
   COD_PROTOCOLLO_DELIBERA_MOPLE,
   DTA_MOTIVO_PASS_RISCHIO,
   DTA_PASSAGGIO_RISCHIO
)
AS
   SELECT /******************************************************************************
          Data di creazione:
          Autore:

          mod    : 001
          data   : 25.03.2014
          desc   : BRB1 reqfu 5 : aggiunta tabella pareri
          Autore : Reply - S. De Cesaris

          mod    :
          data   :
          desc   :
          autore :
         ******************************************************************************/
                             --120123 mm, variata gestione P.COD_TIPO_GESTIONE
                                    --020212 ad, variata gestione dta_scadenza
         d.cod_protocollo_pacchetto,
         d.cod_protocollo_delibera,
         d.cod_abi,
         d.cod_ndg,
         d.cod_microtipologia_delib,
         d.cod_filiale_delibera,
         f.cod_struttura_competente,
         p.cod_matr_pratica,
         d.cod_matricola_inserente,
         d.cod_segmento,
         d.dta_consolid_prop_org_vig,
         p.cod_tipo_gestione AS cod_tipo_gestione,                  --2 APRILE
         dom.desc_dominio AS desc_tipo_gestione,
         f.cod_gruppo_economico,
         d.val_esp_lorda,
         d.val_esp_lorda_capitale,
         d.val_esp_lorda_mora,
         ---12 aprile ripristinati valori solo di cassa
         ---30 marzo modificato calcolo rdv totali
         (NVL (d.val_rdv_qc_ante_delib, 0) /*+ nvl(d.val_rdv_pregr_fi, 0)*/
                                          ) AS val_rdv_qc_ante_delib,
         d.val_rdv_extra_delibera,
         d.val_esp_netta_ante_delib,
         (NVL (d.val_rdv_qc_progressiva, 0) /*+ nvl(d.val_rdv_progr_fi, 0)*/
                                           ) - (NVL (d.val_rdv_qc_ante_delib, 0) /*+ nvl(d.val_rdv_pregr_fi, 0)*/
                                                                                )
            AS val_rdv_qc_deliberata,
         NVL (d.val_rdv_qc_progressiva, 0) /*+ nvl(d.val_rdv_progr_fi, 0)*/
                                          AS val_rdv_qc_progressiva,
         --(30 mar: CA+FI)
         d.val_esp_netta_post_delib,
         d.val_perc_rdv,
         d.val_stralcio_quota_cap,
         d.val_stralcio_quota_mora,
         d.cod_organo_calcolato,
         d.cod_organo_deliberante,
         o1.desc_organo_deliberante AS desc_organo_deliberante,
         o2.desc_organo_deliberante AS desc_organo_calcolato,
         d.dta_delibera,
         d.dta_conferma_delibera,
         DECODE (
            cod_macrotipologia_delib,
            'TP', d.dta_scadenza_transaz,
            DECODE (d.cod_microtipologia_delib,
                    'CS', TO_DATE (NULL, 'ddmmyyyy'),
                    'CI', TO_DATE (NULL, 'ddmmyyyy'),
                    'TR', NVL (d.dta_scadenza_transaz, d.dta_scadenza),
                    d.dta_scadenza))
            AS dta_scadenza,
         d.dta_scadenza_transaz,
         d.dta_delibera_estero,
         d.dta_scadenza_estero,
         d.val_perc_rdv_estero,
         d.dta_last_upd_delibera,
         d.cod_fase_delibera,
         dl.desc_dominio AS desc_fase_delibera,
         --mod. 001
         CASE
            WHEN par.desc_parere IS NOT NULL
            THEN
               d.desc_note || ' - ' || par.desc_parere
            ELSE
               d.desc_note
         END
            AS desc_note,
         d.val_imp_perdita,
         d.val_sacrif_capit_mora,
         CASE
            WHEN     d.cod_microtipologia_delib IN ('CI', 'CS')
                 AND d.cod_tipo_pacchetto = 'M'
            THEN
                  NVL (p.cod_uo_pratica, '00000')
               || '/'
               || SUBSTR (d.cod_protocollo_delibera, 1, 4)
               || '/'
               || SUBSTR (d.cod_protocollo_delibera, 10, 8)
            WHEN     d.cod_microtipologia_delib IN ('CI', 'CS')
                 AND d.cod_tipo_pacchetto = 'A'
            THEN
                  NVL (p.cod_uo_pratica, '00000')
               || '/'
               || SUBSTR (d.cod_protocollo_delibera, 3, 4)
               || '/'
               || SUBSTR (d.cod_protocollo_delibera, 9, 9)
            ELSE
                  SUBSTR (d.cod_protocollo_delibera, 13, 5)
               || '/'
               || SUBSTR (d.cod_protocollo_delibera, 9, 4)
               || '/'
               || SUBSTR (d.cod_protocollo_delibera, 1, 8)
         END
            AS cod_protocollo_delibera_mople,
         d.dta_motivo_pass_rischio,
         DECODE (
            d.cod_microtipologia_delib,
            'CS', (DECODE (
                      p.dta_fine_stato,
                      TO_DATE ('31/12/9999', 'DD/MM/YYYY'), p.dta_decorrenza_stato,
                      (p.dta_fine_stato + 1))),
            p.dta_decorrenza_stato)
            AS dta_passaggio_rischio                        ---modificata 24/2
    FROM t_mcrei_app_delibere d,
         t_mcrei_app_pratiche p,
         t_mcre0_app_all_data f,
         t_mcrei_cl_domini dom,
         t_mcre0_cl_organi_deliberanti o1,
         t_mcre0_cl_organi_deliberanti o2,
         t_mcrei_cl_domini dl,
         -- mod. 001
         (SELECT DISTINCT cod_abi,
                          cod_ndg,
                          cod_protocollo_delibera,
                          desc_parere
            FROM t_mcrei_app_pareri
           WHERE     flg_attiva = '1'
                 AND desc_parere = 'INCAGLIO AUTOMATICO DA SAG' /* unico modo per identificare univocamente � la descrizione */
                                                               ) par
   WHERE     d.cod_abi = p.cod_abi(+)
         AND d.cod_ndg = p.cod_ndg(+)
         AND d.val_anno_pratica = p.val_anno_pratica(+)
         AND d.cod_pratica = p.cod_pratica(+)
         AND p.flg_attiva(+) = '1'
         AND d.cod_abi = f.cod_abi_cartolarizzato
         AND d.cod_ndg = f.cod_ndg
         AND d.flg_attiva = '1'
         AND (d.cod_fase_delibera NOT IN ('AN', 'VA')             --13Dicembre
                                                     OR d.flg_to_copy = '9') --07Gennaio2014: condizione per visualizzare le delibere annullate con flg_to_copi='9'
         AND d.cod_organo_deliberante = o1.cod_organo_deliberante(+)
         AND d.cod_abi = o1.cod_abi_istituto(+)
         AND o1.cod_stato_riferimento(+) = 'IN'
         AND d.cod_organo_calcolato = o2.cod_organo_deliberante(+)
         AND d.cod_abi = o2.cod_abi_istituto(+)
         AND o2.cod_stato_riferimento(+) = 'IN'
         AND dom.cod_dominio(+) = 'TIPO_GESTIONE'
         AND dom.val_dominio(+) = d.desc_tipo_gestione
         AND dl.cod_dominio = 'DELIBERA'
         AND dl.val_dominio = d.cod_fase_delibera
         --mod. 001
         AND d.cod_abi = par.cod_abi(+)
         AND d.cod_ndg = par.cod_ndg(+)
         AND d.cod_protocollo_delibera = par.cod_protocollo_delibera(+);
