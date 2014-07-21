/* Formatted on 21/07/2014 18:39:42 (QP5 v5.227.12220.39754) */
CREATE OR REPLACE FORCE VIEW MCRE_OWN.V_MCREI_APP_DETT_CH_INC_1
(
   COD_SNDG,
   COD_PROTOCOLLO_PACCHETTO,
   COD_ABI,
   COD_ABI_CARTOLARIZZATO,
   DESC_ISTITUTO,
   COD_NDG,
   COD_PROTOCOLLO_DELIBERA,
   FLG_NO_DELIBERA,
   COD_FASE_DELIBERA,
   COD_FASE_MICROTIPOLOGIA,
   COD_FASE_PACCHETTO,
   COD_STATO,
   COD_UO_PROPONENTE,
   PROPONENTE,
   CAUSALE_CHIUSURA,
   TIPO_GESTIONE,
   DTA_DECORRENZA_STATO,
   TOTALE_UTILIZZI,
   UTI_CASSA_CAPITALE,
   UTI_CASSA_MORA,
   UTILIZZI_CASSA,
   UTILIZZI_FIRMA,
   UTILIZZI_SOSTI,
   VAL_ACCORDATO,
   VAL_RDV_QC_ANTE_DELIB,
   VAL_TOTALE_RINUNCIA,
   ORDINAMENTO,
   VAL_ESP_LORDA,
   VAL_ESP_LORDA_CAPITALE,
   VAL_ESP_LORDA_MORA,
   VAL_ESP_NETTA_ANTE_DELIB,
   VAL_ESP_NETTA_POST_DELIB,
   COD_MICROTIPOLOGIA,
   COD_DOC_DELIBERA_BANCA,
   COD_DOC_PARERE_CONFORMITA,
   COD_DOC_APPENDICE_PARERE,
   COD_DOC_DELIBERA_CAPOGRUPPO,
   COD_DOC_CLASSIFICAZIONE
)
AS
   SELECT --0221 introdotta nuova pcr_rapp_aggr                                                                                                                                                                                 -- 0216 aggiunto filtro fase_del != 'AN'
         d.cod_sndg,
          d.cod_protocollo_pacchetto,
          d.cod_abi,
          f.cod_abi_cartolarizzato,
          f.desc_istituto,
          d.cod_ndg,
          d.cod_protocollo_delibera,
          DECODE (d.flg_no_delibera,  1, 'Y',  0, 'N',  2, 'U')
             AS flg_no_delibera,
          d.cod_fase_delibera,
          d.cod_fase_microtipologia,
          d.cod_fase_pacchetto,
          NULLIF (f.cod_stato, '-1') cod_stato,
          f.cod_struttura_competente AS cod_uo_proponente,
          NULL AS proponente,
          d.cod_causa_chius_delibera AS causale_chiusura,
          do.desc_dominio AS tipo_gestione,
          f.dta_decorrenza_stato,
          NVL (
             DECODE (cod_fase_delibera,
                     'IN', p.scsb_uti_tot,
                     d.val_uti_tot_scsb),
             0)
             AS totale_utilizzi,
          NVL (
             DECODE (cod_fase_delibera,
                     'IN', (NVL (p.scsb_uti_cassa, 0) - i.interessi_di_mora), --10 aprile
                     d.val_esp_lorda_capitale),
             0)
             AS uti_cassa_capitale,
          NVL (
             DECODE (cod_fase_delibera,
                     'IN', i.interessi_di_mora,
                     d.val_esp_lorda_mora),
             0)
             AS uti_cassa_mora,
            NVL (
               DECODE (cod_fase_delibera,
                       'IN', i.interessi_di_mora,
                       d.val_esp_lorda_mora),
               0)                                                      -- mora
          + NVL (
               DECODE (
                  cod_fase_delibera,
                  'IN', (NVL (p.scsb_uti_cassa, 0) - i.interessi_di_mora), --10 aprile
                  d.val_esp_lorda_capitale),
               0)
             AS utilizzi_cassa,
          -- capitale

          --            NVL (
          --               DECODE (cod_fase_delibera,
          --                       'IN', p.scsb_uti_cassa,
          --                       d.val_uti_cassa_scsb),
          --               0
          --            )

          NVL (
             DECODE (cod_fase_delibera,
                     'IN', p.scsb_uti_firma,
                     d.val_uti_firma_scsb),
             0)
             AS utilizzi_firma,
          NVL (
             DECODE (cod_fase_delibera,
                     'IN', p.scsb_uti_sostituzioni,
                     d.val_uti_sosti_scsb),
             0)
             AS utilizzi_sosti,
          NVL (
             DECODE (cod_fase_delibera,
                     'IN', p.scsb_acc_tot,
                     d.val_accordato),
             0)
             AS val_accordato,
          NVL (d.val_rdv_qc_ante_delib, 0) + NVL (d.val_rdv_pregr_fi, 0)
             AS val_rdv_qc_ante_delib,                           ----10 aprile
          d.val_rinuncia_deliberata AS val_totale_rinuncia, ---totale rinuncia pregressa
          DECODE (d.cod_abi, '01025', 1 || d.cod_abi, 2 || d.cod_abi)
             AS ordinamento,
          d.val_esp_lorda,
          d.val_esp_lorda_capitale,
          d.val_esp_lorda_mora,
          d.val_esp_netta_ante_delib,
          d.val_esp_netta_post_delib,
          d.cod_microtipologia_delib,
          cod_doc_delibera_banca,
          cod_doc_parere_conformita,
          cod_doc_appendice_parere,
          cod_doc_delibera_capogruppo,
          cod_doc_classificazione
     FROM t_mcrei_app_delibere d,
          t_mcre0_app_all_data f,
          --t_mcre0_app_pcr p,
          t_mcrei_app_pcr_rapp_aggr p,
          (  SELECT cod_abi_cartolarizzato,
                    cod_ndg,
                    SUM (NVL (i.val_imp_mora, 0)) AS interessi_di_mora
               FROM t_mcre0_app_rate_daily i                             --5/3
           GROUP BY cod_abi_cartolarizzato, cod_ndg) i,
          t_mcrei_app_pratiche a,
          t_mcrei_cl_domini do
    WHERE     d.cod_abi = f.cod_abi_cartolarizzato
          AND d.cod_ndg = f.cod_ndg
          AND d.flg_attiva = '1'
          -- AND d.cod_microtipologia_delib = 'CH'  eliminato per adeguamento a dil/rin/ris
          AND d.cod_abi = p.cod_abi_cartolarizzato(+)
          AND d.cod_ndg = p.cod_ndg(+)
          AND d.cod_fase_pacchetto NOT IN ('ANA', 'ANM')
          AND d.cod_fase_delibera != 'AN'
          AND d.cod_abi = i.cod_abi_cartolarizzato(+)
          AND d.cod_ndg = i.cod_ndg(+)
          AND d.cod_abi = a.cod_abi
          AND d.cod_ndg = a.cod_ndg
          AND a.flg_attiva = 1
          AND a.cod_tipo_gestione = do.val_dominio
          AND do.cod_dominio = 'TIPO_GESTIONE';
