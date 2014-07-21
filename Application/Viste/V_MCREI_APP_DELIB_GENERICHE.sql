/* Formatted on 21/07/2014 18:39:33 (QP5 v5.227.12220.39754) */
CREATE OR REPLACE FORCE VIEW MCRE_OWN.V_MCREI_APP_DELIB_GENERICHE
(
   COD_SNDG,
   COD_PROTOCOLLO_PACCHETTO,
   COD_ABI,
   COD_ABI_CARTOLARIZZATO,
   DESC_ISTITUTO,
   COD_NDG,
   COD_PROTOCOLLO_DELIBERA,
   COD_PROTOCOLLO_DELIBERA_MOPLE,
   FLG_NO_DELIBERA,
   COD_MICROTIPOLOGIA_DELIB,
   COD_MACROTIPOLOGIA_DELIB,
   DESC_MICROTIPOLOGIA,
   DESC_MACROTIPOLOGIA,
   COD_FASE_DELIBERA,
   COD_FASE_MICROTIPOLOGIA,
   COD_FASE_PACCHETTO,
   COD_STATO,
   DTA_DECORRENZA_STATO,
   DTA_SCADENZA_STATO,
   VAL_ACC_CASSA,
   VAL_ACC_FIRMA,
   VAL_ACC_DERIVATI,
   VAL_ACC_TOTALE,
   VAL_UTIL_CASSA,
   VAL_UTIL_FIRMA,
   VAL_UTIL_DERIVATI,
   VAL_UTIL_TOTALE,
   VAL_UTIL_CAPITALE,
   VAL_UTIL_MORA,
   VAL_DEL_RETTIFICA,
   VAL_DEL_RINUNCIA,
   VAL_PROP_RINUNCIA,
   VAL_TOT_RINUNCIA,
   DESC_NOTE,
   ORDINAMENTO,
   COD_DOC_DELIBERA_BANCA,
   COD_DOC_PARERE_CONFORMITA,
   COD_DOC_APPENDICE_PARERE,
   COD_DOC_DELIBERA_CAPOGRUPPO,
   COD_DOC_CLASSIFICAZIONE,
   FLG_RISTRUTTURATO,
   DESC_NO_DELIBERA,
   COD_DOC_CLASSIFICAZIONE_MCI
)
AS
   SELECT                                --0221 introdotta nuova pcr_rapp_aggr
          --130424 aggiunte microtipologie di proroga                                                                           -- 0216 aggiunto filtro fase_del != 'AN'
          DISTINCT
          d.cod_sndg,
          d.cod_protocollo_pacchetto,
          d.cod_abi,
          f.cod_abi_cartolarizzato,
          f.desc_istituto,
          d.cod_ndg,
          d.cod_protocollo_delibera,
             SUBSTR (cod_protocollo_delibera, 13, 5)
          || '/'
          || SUBSTR (cod_protocollo_delibera, 9, 4)
          || '/'
          || SUBSTR (cod_protocollo_delibera, 1, 8)
             AS cod_protocollo_delibera_mople,
          DECODE (d.flg_no_delibera,  1, 'Y',  0, 'N',  2, 'U')
             AS flg_no_delibera,
          d.cod_microtipologia_delib,
          d.cod_macrotipologia_delib,
          t1.desc_microtipologia,
          t2.desc_macrotipologia,
          d.cod_fase_delibera,
          d.cod_fase_microtipologia,
          d.cod_fase_pacchetto,
          NULLIF (f.cod_stato, '-1') cod_stato,
          f.dta_decorrenza_stato,
          --     DECODE (d.cod_microtipologia_delib,
          --       'PR', d.dta_ins_delibera + c.val_gg_seconda_proroga,
          --       --- AD: 14 nov sostituita c.val_gg_prima_proroga,
          --       d.dta_scadenza)
          --    (CASE
          --      WHEN (d.cod_microtipologia_delib IN ('PR', 'PT', 'PD')
          --        AND COD_LIVELLO = 'DC') THEN
          --       d.dta_ins_delibera + c.val_gg_seconda_proroga
          --      ELSE
          --       d.dta_scadenza
          --     END)
          d.dta_scadenza dta_scadenza_stato,                        ---5 marzo
          /*se lo stato della delibera e inserito, si recuperano i dati contabili direttamente da pcr*/
          NVL (
             DECODE (d.cod_fase_delibera,
                     'IN', p.scsb_acc_cassa,
                     d.val_accordato_cassa),
             0)
             AS val_acc_cassa,
          NVL (
             DECODE (d.cod_fase_delibera,
                     'IN', p.scsb_acc_firma,
                     d.val_accordato_firma),
             0)
             AS val_acc_firma,
          ----> aggiungere accordato di firma nelle delibere
          NVL (
             DECODE (d.cod_fase_delibera,
                     'IN', p.scsb_acc_sostituzioni,
                     d.val_accordato_derivati),
             0)
             AS val_acc_derivati,
          NVL (
             DECODE (d.cod_fase_delibera,
                     'IN', p.scsb_acc_tot,
                     d.val_accordato),
             0)
             AS val_acc_totale,
          NVL (
             DECODE (d.cod_fase_delibera,
                     'IN', p.scsb_uti_cassa,
                     d.val_uti_cassa_scsb),
             0)
             AS val_util_cassa,
          NVL (
             DECODE (d.cod_fase_delibera,
                     'IN', p.scsb_uti_firma,
                     d.val_uti_firma_scsb),
             0)
             AS val_util_firma,
          NVL (
             DECODE (d.cod_fase_delibera,
                     'IN', p.scsb_uti_sostituzioni,
                     d.val_uti_sosti_scsb),
             0)
             AS val_util_derivati,
          NVL (
             DECODE (d.cod_fase_delibera,
                     'IN', p.scsb_uti_tot,
                     d.val_uti_tot_scsb),
             0)
             AS val_util_totale,
          NVL (
             DECODE (d.cod_fase_delibera,
                     'IN', (p.scsb_uti_cassa - NVL (p.interessi_di_mora, 0)), --17 apr
                     d.val_esp_lorda_capitale),
             0)
             AS val_util_capitale,
          --modificato il 27/2 sostituendo uti_Cassa a uti_tot
          NVL (
             DECODE (d.cod_fase_delibera,
                     'IN', p.interessi_di_mora,
                     d.val_esp_lorda_mora),
             0)
             AS val_util_mora,
          ---rdv e rinunce modificate il 10 aprile
          d.val_rdv_qc_ante_delib + d.val_rdv_pregr_fi AS val_del_rettifica,
          NVL (val_rinuncia_deliberata, 0) AS val_del_rinuncia,
          ---rinuncia pregressa
          NVL (d.val_rinuncia_proposta, 0) AS val_prop_rinuncia,
          ---corrisponde a val_imp_perdita rinuncia qta capitale + rinuncia mora
          d.val_imp_perdita AS val_tot_rinuncia,                   --17 aprile
          d.desc_note,
          DECODE (d.cod_abi, '01025', 1 || d.cod_abi, 2 || d.cod_abi)
             AS ordinamento,
          d.cod_doc_delibera_banca,
          d.cod_doc_parere_conformita,
          d.cod_doc_appendice_parere,
          d.cod_doc_delibera_capogruppo,
          d.cod_doc_classificazione,
          d.flg_ristrutturato,
          d.desc_no_delibera,                                       --20131230
          D.COD_DOC_CLASSIFICAZIONE_MCI           --T.B. APERTURA MCI 25-06-14
     FROM t_mcrei_app_delibere d,
          t_mcre0_app_all_data f,
          t_mcre0_app_comparti c,                                  --21 MAGGIO
          (SELECT r.*,
                  SUM (NVL (i.val_imp_mora, 0))
                     OVER (PARTITION BY i.cod_abi_cartolarizzato, i.cod_ndg)
                     AS interessi_di_mora
             FROM t_mcre0_app_rate_daily i, t_mcrei_app_pcr_rapp_aggr r
            WHERE     r.cod_abi_cartolarizzato = i.cod_abi_cartolarizzato(+)
                  AND r.cod_ndg = i.cod_ndg(+)                           --5/3
                                              ) p,
          t_mcrei_cl_tipologie t1,
          t_mcrei_cl_tipologie t2
    WHERE     d.cod_abi = f.cod_abi_cartolarizzato
          AND d.cod_ndg = f.cod_ndg
          AND d.flg_attiva = '1'
          --  AND d.cod_macrotipologia_delib = 'GE'
          AND d.cod_abi = p.cod_abi_cartolarizzato(+)
          AND d.cod_ndg = p.cod_ndg(+)
          AND (   (    D.COD_FASE_PACCHETTO NOT IN ('ANA', 'ANM') --13Dicembre
                   AND d.cod_fase_delibera NOT IN ('AN', 'VA'))   --13Dicembre
               OR d.flg_to_copy = '9') --07Gennaio2014: condizione per visualizzare le delibere annullate con flg_to_copi='9'
          AND NVL (f.cod_comparto_assegnato, f.cod_comparto_calcolato) =
                 c.cod_comparto(+)
          AND d.cod_microtipologia_delib = t1.cod_microtipologia(+)
          AND t1.cod_famiglia_tipologia(+) IN ('DGE', 'DTR')          --17 APR
          AND t1.flg_attivo(+) = 1
          AND d.cod_macrotipologia_delib = t2.cod_macrotipologia(+)
          AND t2.flg_attivo(+) = 1;
