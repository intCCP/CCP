/* Formatted on 17/06/2014 18:07:57 (QP5 v5.227.12220.39754) */
CREATE OR REPLACE FORCE VIEW MCRE_OWN.V_MCREI_APP_DETT_PACCH_CLASSIF
(
   COD_SNDG,
   COD_PROTOCOLLO_PACCHETTO,
   COD_ABI,
   COD_NDG,
   COD_PROTOCOLLO_DELIBERA,
   COD_ABI_CARTOLARIZZATO,
   DESC_ISTITUTO,
   COD_STATO,
   DTA_DECORRENZA_STATO,
   DTA_ACCENSIONE_PROP_RISCHIO,
   DESC_MOTIVO_PASS_RISCHIO,
   VAL_ACCORDATO,
   VAL_ACCORDATO_DERIVATI,
   TOTALE_UTILIZZI,
   UTILIZZI_CASSA,
   UTI_CASSA_CAPITALE,
   UTI_CASSA_MORA,
   UTILIZZI_FIRMA,
   UTILIZZI_SOSTI,
   VAL_RDV_QC_ANTE_DELIB,
   COD_FASE_DELIBERA,
   COD_FASE_MICROTIPOLOGIA,
   COD_FASE_PACCHETTO,
   TIPO_GESTIONE,
   COD_UO_PROPONENTE,
   PROPONENTE,
   FLG_NO_DELIBERA,
   ORDINAMENTO,
   COD_DOC_DELIBERA_BANCA,
   COD_DOC_PARERE_CONFORMITA,
   COD_DOC_APPENDICE_PARERE,
   COD_DOC_DELIBERA_CAPOGRUPPO,
   COD_DOC_CLASSIFICAZIONE,
   DESC_NO_DELIBERA
)
AS
   SELECT --0221 introdotta nuova pcr_rapp_aggr                                                                                                                                                                                                                     -- 0216 aghgiunto filtro fase_delib != 'AN'
         d.cod_sndg,
          d.cod_protocollo_pacchetto,
          d.cod_abi,
          d.cod_ndg,
          d.cod_protocollo_delibera,
          f.cod_abi_cartolarizzato,
          f.desc_istituto,
          NULLIF (f.cod_stato, '-1') cod_stato,
          f.dta_decorrenza_stato,
          d.dta_motivo_pass_rischio AS dta_accensione_prop_rischio,
          d.desc_motivo_pass_rischio,
          /*se lo stato della delibera è inserito, si recuperano i dati contabili direttamente da pcr*/
          NVL (
             DECODE (cod_fase_delibera,
                     'IN', p.scsb_acc_tot,
                     d.val_accordato),
             0)
             AS val_accordato,
          NVL (
             DECODE (cod_fase_delibera,
                     'IN', p.scsb_acc_sostituzioni,
                     d.val_accordato_derivati),
             0)
             AS val_accordato_derivati,
          NVL (
             DECODE (cod_fase_delibera,
                     'IN', p.scsb_uti_tot,
                     d.val_uti_tot_scsb),
             0)
             AS totale_utilizzi,
          NVL (
             DECODE (cod_fase_delibera,
                     'IN', p.scsb_uti_cassa,
                     d.val_uti_cassa_scsb),
             0)
             AS utilizzi_cassa,
          NVL (
             DECODE (cod_fase_delibera,
                     'IN', p.scsb_uti_cassa - i.interessi_di_mora,
                     d.val_esp_lorda_capitale),
             0)
             AS uti_cassa_capitale,             --modificato il 27/2 uti_Cassa
          NVL (
             DECODE (cod_fase_delibera,
                     'IN', i.interessi_di_mora,
                     d.val_esp_lorda_mora),
             0)
             AS uti_cassa_mora,
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
          d.val_rdv_qc_ante_delib,
          d.cod_fase_delibera,
          d.cod_fase_microtipologia,
          d.cod_fase_pacchetto,
          (CASE
              WHEN (NVL (p.scsb_uti_tot, 0) < DO.desc_dominio)
              THEN
                 'FORFETARIO'
              ELSE
                 'ANALITICO'
           END)
             AS tipo_gestione,
          CASE
             WHEN NVL (
                     NVL (NULLIF (f.cod_comparto_assegnato, '#'),
                          NULLIF (f.cod_comparto_calcolato, '#')),
                     NULLIF (f.cod_struttura_competente, '#'))
                     IS NOT NULL
             THEN
                NVL (
                   NVL (NULLIF (f.cod_comparto_assegnato, '#'),
                        NULLIF (f.cod_comparto_calcolato, '#')),
                   NULLIF (f.cod_struttura_competente, '#'))
             ELSE
                (SELECT o.cod_struttura_competente
                   FROM t_mcre0_App_Struttura_org o
                  WHERE     o.cod_abi_istituto = f.cod_abi_cartolarizzato
                        AND O.COD_COMPARTO =
                               NVL (f.cod_comparto_assegnato,
                                    f.cod_comparto_calcolato))
          END
             cod_uo_proponente,
          d.cod_matricola_inserente AS proponente,
          DECODE (d.flg_no_delibera,  1, 'Y',  0, 'N',  2, 'U')
             AS flg_no_delibera,
          DECODE (cod_abi, '01025', 1 || cod_abi, 2 || cod_abi)
             AS ordinamento,
          cod_doc_delibera_banca,
          cod_doc_parere_conformita,
          cod_doc_appendice_parere,
          cod_doc_delibera_capogruppo,
          cod_doc_classificazione,
          D.DESC_NO_DELIBERA                                       -- 20131230
     FROM t_mcrei_app_delibere d,
          t_mcre0_app_all_data f,
          --t_mcre0_app_pcr p,
          t_mcrei_app_pcr_rapp_aggr p,
          t_mcrei_cl_domini DO,
          (  SELECT cod_abi_cartolarizzato,
                    cod_ndg,
                    SUM (NVL (i.val_imp_mora, 0)) AS interessi_di_mora
               FROM t_mcre0_app_rate_daily i                             --5/3
           GROUP BY cod_abi_cartolarizzato, cod_ndg) i
    WHERE     d.cod_abi = f.cod_abi_cartolarizzato
          AND d.cod_ndg = f.cod_ndg
          AND d.flg_attiva = '1'
          AND d.cod_microtipologia_delib IN ('CI', 'CS', 'CZ')
          AND d.cod_abi = p.cod_abi_cartolarizzato(+)
          AND d.cod_ndg = p.cod_ndg(+)
          AND d.cod_abi = i.cod_abi_cartolarizzato(+)
          AND d.cod_ndg = i.cod_ndg(+)
          AND d.cod_abi = DO.val_dominio(+)
          AND DO.cod_dominio(+) = 'LIM_INC_FORF'
          AND d.cod_fase_pacchetto NOT IN ('ANA', 'ANM')          --13Dicembre
          AND d.cod_fase_delibera NOT IN ('AN', 'VA');


GRANT DELETE, INSERT, REFERENCES, SELECT, UPDATE, ON COMMIT REFRESH, QUERY REWRITE, DEBUG, FLASHBACK, MERGE VIEW ON MCRE_OWN.V_MCREI_APP_DETT_PACCH_CLASSIF TO MCRE_USR;
