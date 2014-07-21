/* Formatted on 21/07/2014 18:39:34 (QP5 v5.227.12220.39754) */
CREATE OR REPLACE FORCE VIEW MCRE_OWN.V_MCREI_APP_DELIB_PAR_CONF
(
   COD_ABI,
   COD_PROTOCOLLO_DELIBERA,
   COD_MICROTIPOLOGIA_DELIB,
   DESC_MICROTIPOLOGIA,
   COD_FASE_DELIBERA,
   DESC_FASE_DELIBERA,
   COD_PROTOCOLLO_PACCHETTO,
   COD_NDG,
   COD_SNDG,
   STATO_ATTUALE,
   DTA_CONFERMA_DELIBERA,
   DTA_DELIBERA,
   COD_ORGANO_DELIBERANTE,
   COD_ORGANO_CALCOLATO,
   DTA_CONFERMA_PACCHETTO,
   COD_STATO_PROPOSTO,
   UTILIZZATO_CASSA,
   UTILIZZATO_FIRMA,
   UTILIZZATO_DERIVATI,
   TOT_UTILIZZATO,
   TOTALE_RINUNCIA_PREGRESSA,
   VAL_RINUNCIA_PROPOSTA,
   TOTALE_RINUNCIA,
   TERMINE_TRANSAZIONE,
   TERMINE_TRANS_POST_PROROGA,
   VAL_ESP_LORDA_MORA,
   VAL_RDV_DELIB_BANCA_RETE,
   "Cassa Rett.Esistente",
   "Firma Rett.Esistente",
   "Derivati Rett.Esistente",
   "Cassa Rett.Proposta",
   "Firma Rett.Proposta",
   "Derivati Rett.Proposta",
   "Cassa Totale Rett.",
   "Firma Totale Rett.",
   "Derivati Totale Rett.",
   "Totale Rett.Esistente",
   "Totale Rett.Proposta",
   "Totale Rett.",
   COD_FASE_MICROTIPOLOGIA,
   DESC_FASE_MICROTIPOLOGIA,
   COD_FASE_PACCHETTO,
   DESC_FASE_PACCHETTO,
   DESC_ORGANO_DELIBERANTE,
   VAL_NUM_PROROGHE,
   DTA_SCADENZA_PROROGA,
   DTA_SCADENZA_PRECEDENTE
)
AS
   SELECT /*+  no_parallel (f)*/
                -- 0216 aggiunto filtro no_delibera = 0 e fase-delibera != 'AN
         d.cod_abi,
         d.cod_protocollo_delibera,
         d.cod_microtipologia_delib,
         (SELECT desc_microtipologia
            FROM t_mcrei_cl_tipologie
           WHERE cod_microtipologia = d.cod_microtipologia_delib)
            AS desc_microtipologia,
         ---25 OCT
         d.cod_fase_delibera,
         (SELECT desc_dominio
            FROM t_mcrei_cl_domini
           WHERE cod_dominio = 'DELIBERA' AND val_dominio = d.cod_fase_delibera)
            desc_fase_delibera,
         --17 maggio
         --19 marzo
         d.cod_protocollo_pacchetto,
         d.cod_ndg,
         d.cod_sndg,
         f.cod_stato AS stato_attuale,
         d.dta_conferma_delibera,
         d.dta_delibera_rete AS dta_delibera,
         d.cod_organo_deliberante,
         d.cod_organo_calcolato,
         d.dta_conferma_pacchetto,
         NVL (d.cod_stato_proposto,
              DECODE (cod_microtipologia_delib,  'CI', 'IN',  'CS', 'SO',  NULL))
            AS cod_stato_proposto,
         NVL (d.val_uti_cassa_scsb, d.val_esp_lorda) AS utilizzato_cassa,
         NVL (d.val_uti_firma_scsb, d.val_esp_firma) AS utilizzato_firma,
         d.val_uti_sosti_scsb AS utilizzato_derivati,
         (  NVL (NVL (d.val_uti_cassa_scsb, d.val_esp_lorda), 0)
          +                                                            --7 giu
           NVL (NVL (d.val_uti_firma_scsb, d.val_esp_firma), 0)
          + NVL (d.val_uti_sosti_scsb, 0))
            AS tot_utilizzato,
         d.val_rinuncia_deliberata AS totale_rinuncia_pregressa,
         d.val_rinuncia_proposta,
         d.val_rinuncia_totale AS totale_rinuncia,
         dta_scadenza_transaz AS termine_transazione,
         NULL AS termine_trans_post_proroga,
         NVL (d.val_esp_lorda_mora, 0) AS val_esp_lorda_mora,
         DECODE (d.cod_abi, '01025', NULL, NVL (d.val_rdv_delib_banca_rete, 0))
            AS val_rdv_delib_banca_rete,                           --17 luglio
         (CASE
             WHEN d.cod_microtipologia_delib NOT IN ('CI', 'CS', 'CH')
             THEN
                NVL (val_rdv_qc_ante_delib, 0)                         --7 giu
             ELSE
                TO_NUMBER (NULL)
          END)
            AS "Cassa Rett.Esistente",
         (CASE
             WHEN d.cod_microtipologia_delib NOT IN ('CI', 'CS', 'CH')
             THEN
                NVL (d.val_rdv_pregr_fi, 0)
             ELSE
                TO_NUMBER (NULL)
          END)
            AS "Firma Rett.Esistente",
         TO_NUMBER (NULL) AS "Derivati Rett.Esistente",
         --variazioni proposte
         ---maschero rdv per le classificazioni
         (CASE
             WHEN d.cod_microtipologia_delib NOT IN ('CI', 'CS', 'CH')
             THEN
                (NVL (val_rdv_qc_progressiva, 0) - NVL (val_rdv_qc_ante_delib, 0))
             ELSE
                TO_NUMBER (NULL)
          END)
            AS "Cassa Rett.Proposta",
         (CASE
             WHEN d.cod_microtipologia_delib NOT IN ('CI', 'CS', 'CH')
             THEN
                (NVL (d.val_rdv_progr_fi, 0) - NVL (d.val_rdv_pregr_fi, 0))
             ELSE
                TO_NUMBER (NULL)
          END)
            AS "Firma Rett.Proposta",
         TO_NUMBER (NULL) AS "Derivati Rett.Proposta",
         ----totali_da_deliberare
         ---maschero rdv per le classificazioni
         (CASE
             WHEN d.cod_microtipologia_delib NOT IN ('CI', 'CS', 'CH')
             THEN
                NVL (val_rdv_qc_progressiva, 0)
             ELSE
                TO_NUMBER (NULL)
          END)
            AS "Cassa Totale Rett.",
         (CASE
             WHEN d.cod_microtipologia_delib NOT IN ('CI', 'CS', 'CH')
             THEN
                NVL (d.val_rdv_progr_fi, 0)
             ELSE
                TO_NUMBER (NULL)
          END)
            AS "Firma Totale Rett.",
         TO_NUMBER (NULL) AS "Derivati Totale Rett.",
         --totale
         (CASE
             WHEN d.cod_microtipologia_delib NOT IN ('CI', 'CS', 'CH')
             THEN
                (NVL (val_rdv_qc_ante_delib, 0) + NVL (d.val_rdv_pregr_fi, 0))
             ELSE
                TO_NUMBER (NULL)
          END)
            AS "Totale Rett.Esistente",
         ---maschero rdv per le classificazioni
         (CASE
             WHEN d.cod_microtipologia_delib NOT IN ('CI', 'CS', 'CH')
             THEN
                  (  NVL (val_rdv_qc_progressiva, 0)
                   - NVL (val_rdv_qc_ante_delib, 0))
                + (NVL (d.val_rdv_progr_fi, 0) - NVL (d.val_rdv_pregr_fi, 0))
             ELSE
                TO_NUMBER (NULL)
          END)
            AS "Totale Rett.Proposta",
         (CASE
             WHEN d.cod_microtipologia_delib NOT IN ('CI', 'CS', 'CH')
             THEN
                NVL (d.val_rdv_qc_deliberata, 0)                   --17 luglio
             /*(NVL (val_rdv_qc_progressiva, 0)
          + NVL (d.val_rdv_progr_fi, 0))*/
             ELSE
                TO_NUMBER (NULL)
          END)
            AS "Totale Rett.",
         --------------
         d.cod_fase_microtipologia,                               --17/05/2012
         t1.desc_dominio desc_fase_microtipologia,
         d.cod_fase_pacchetto,
         d1.desc_dominio desc_fase_pacchetto,
         --12/06/2012
         o1.desc_organo_deliberante AS desc_organo_deliberante,
         NVL (P.VAL_NUM_PROROGHE, 0) + 1 VAL_NUM_PROROGHE,
         d.dta_scadenza DTA_SCADENZA_PROROGA,
         f.dta_scadenza_stato DTA_SCADENZA_PRECEDENTE
    FROM t_mcrei_app_delibere d,
         t_mcre0_app_istituti i,
         t_mcre0_app_all_data f,
         t_mcrei_cl_domini t1,
         t_mcrei_cl_domini d1,
         t_mcre0_cl_organi_deliberanti o1,
         (SELECT *
            FROM (SELECT p.*,
                         MAX (
                            p.dta_richiesta)
                         OVER (
                            PARTITION BY p.cod_abi_cartolarizzato, p.cod_ndg)
                            last_richiesta
                    FROM t_mcre0_app_rio_proroghe p)
           WHERE dta_richiesta = last_richiesta) p
   WHERE     d.cod_fase_delibera NOT IN ('AN', 'VA')                   --13dic
         --AND d.cod_fase_pacchetto = 'COD'  ----6 MARZO
         AND d.flg_no_delibera = 0
         AND d.flg_attiva = '1'
         AND d.cod_abi = f.cod_abi_cartolarizzato
         AND d.cod_ndg = f.cod_ndg
         AND d.cod_abi = p.cod_abi_cartolarizzato(+)
         AND d.cod_ndg = p.cod_ndg(+)
         AND d.cod_abi = i.cod_abi
         AND t1.cod_dominio = 'MICROTIPOLOGIA'
         AND t1.val_dominio = d.cod_fase_microtipologia
         AND d1.cod_dominio = 'PACCHETTO'
         AND d1.val_dominio = d.cod_fase_pacchetto
         AND d.cod_organo_deliberante = o1.cod_organo_deliberante(+)
         AND d.cod_abi = o1.cod_abi_istituto(+)
         AND o1.cod_stato_riferimento(+) = 'IN';
