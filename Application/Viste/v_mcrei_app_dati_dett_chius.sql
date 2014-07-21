/* Formatted on 21/07/2014 18:39:24 (QP5 v5.227.12220.39754) */
CREATE OR REPLACE FORCE VIEW MCRE_OWN.V_MCREI_APP_DATI_DETT_CHIUS
(
   COD_ABI,
   COD_NDG,
   COD_PROTOCOLLO_PACCHETTO,
   COD_PROTOCOLLO_DELIBERA,
   COD_MACROTIPOLOGIA,
   DESC_MACROTIPOLOGIA,
   COD_MICROTIPOLOGIA,
   DESC_MICROTIPOLOGIA,
   VAL_TOTALE_ACCORDATO,
   VAL_ACCORDATO_DERIVATI,
   VAL_TOTALE_UTILIZZATO,
   VAL_TOTALE_RETTIFICHE_PREGR,
   VAL_RINUNCIA_PROG_TOTALE,
   COD_GESTIONE,
   DESC_GESTIONE,
   COD_CAUSALE_CHIUSURA,
   DESC_CAUSALE_CHIUSURA,
   DESC_CAUSALE_CHIUSURA_RISTR,
   NOTE,
   DTA_EFFICACIA_RISTR,
   NOMINATIVO_INSERENTE,
   STATO_RISCHIO,
   STATO_POST_RISTR,
   VAL_TOTALE_UTILIZZATO_DERIVATI,
   VAL_TOTALE_RETTIFICHE,
   VAL_TOT_RETT_DELIBERATE,
   DESC_TIPO_RISTR,
   DESC_INTENTO_RISTR,
   DTA_EFFICACIA_ADD,
   DTA_SCADENZA_RISTR,
   DTA_CHIUSURA_RISTR,
   STATO_RISTR,
   COD_CAUSA_CHIUS_DELIBERA,
   COD_PROCESSO,
   FLG_RDV
)
AS
   SELECT                                --0221 introdotta nuova pcr_rapp_aggr
         DISTINCT
          d.cod_abi,
          d.cod_ndg,
          d.cod_protocollo_pacchetto,
          d.cod_protocollo_delibera,
          d.cod_macrotipologia_delib AS cod_macrotipologia,
          t1.desc_macrotipologia,
          d.cod_microtipologia_delib AS cod_microtipologia,
          t1.desc_microtipologia,
          NVL (
             DECODE (cod_fase_delibera,
                     'IN', p.scsb_acc_tot,
                     d.val_accordato),
             0)
             AS val_totale_accordato,
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
             AS val_totale_utilizzato,
          NVL (d.val_rdv_qc_ante_delib, 0) + NVL (d.val_rdv_pregr_fi, 0)
             AS val_totale_rettifiche_pregr,
          -----campo da verificare
          d.val_rinuncia_deliberata AS val_rinuncia_prog_totale,
          ---10 aprile
          a.cod_tipo_gestione AS cod_gestione,
          DO.desc_dominio AS desc_gestione,
          d.cod_causa_chius_delibera AS cod_causale_chiusura,
          ---CONTIENE LA CAUSALE PER LE DELIB DI CH.INCAGLIO O DI CH.RISTRUTT
          NVL (do1.desc_dominio, 'n.d.') AS desc_causale_chiusura,
          NVL (do2.desc_dominio, 'n.d.') AS desc_causale_chiusura_ristr,
          d.desc_note AS note,
          dta_efficacia_ristr,
          d.desc_denominaz_ins_delibera AS nominativo_inserente,
          f.cod_stato AS stato_rischio,
          d.cod_stato_proposto AS stato_post_ristr,
          NVL (
             DECODE (cod_fase_delibera,
                     'IN', p.scsb_uti_sostituzioni,
                     d.val_uti_sosti_scsb),
             0)
             AS val_totale_utilizzato_derivati,
          NVL (d.val_rdv_qc_progressiva, 0) + NVL (d.val_rdv_progr_fi, 0) -- MODIFICATA 11 APR
             AS val_totale_rettifiche,
          NVL (d.val_rdv_qc_progressiva, 0) + NVL (d.val_rdv_progr_fi, 0) -- MODIFICATA 11 APR
             AS val_tot_rett_deliberate,
          d.desc_tipo_ristr,
          d.desc_intento_ristr,
          d.dta_efficacia_add,
          d.dta_scadenza_ristr,
          d.dta_chiusura_ristr,
          d.cod_stato_post_ristr AS stato_ristr,                      --16 lug
          d.cod_causa_chius_delibera,
          f.cod_processo,
          d.flg_rdv
     FROM t_mcrei_app_delibere d,
          t_mcre0_app_all_data f,
          --t_mcre0_app_pcr p,
          t_mcrei_app_pcr_rapp_aggr p,
          t_mcrei_cl_tipologie t1,
          --  t_mcrei_cl_tipologie t2,
          t_mcrei_app_pratiche a,
          t_mcrei_cl_domini DO,
          t_mcrei_app_pareri pa,
          t_mcrei_cl_domini do1,
          t_mcrei_cl_domini do2
    WHERE     d.cod_abi = f.cod_abi_cartolarizzato
          AND d.cod_ndg = f.cod_ndg
          AND d.flg_attiva = '1'
          --AND d.cod_microtipologia_delib = 'CH'
          AND d.cod_abi = p.cod_abi_cartolarizzato(+)
          AND D.COD_NDG = P.COD_NDG(+)
          AND (   D.COD_FASE_PACCHETTO NOT IN ('ANA', 'ANM')
               OR d.flg_to_copy = '9') --07Gennaio2014: condizione per visualizzare le delibere annullate con flg_to_copi='9'
          AND d.cod_abi = a.cod_abi
          AND d.cod_ndg = a.cod_ndg
          AND a.flg_attiva = '1'
          AND d.cod_protocollo_delibera = pa.cod_protocollo_delibera(+)
          AND d.cod_abi = pa.cod_abi(+)
          AND d.cod_ndg = pa.cod_ndg(+)
          AND pa.flg_attiva(+) = '1'
          AND a.cod_tipo_gestione = do.val_dominio(+)
          AND do.cod_dominio(+) = 'TIPO_GESTIONE'
          AND d.cod_causa_chius_delibera = do1.val_dominio(+)
          AND do1.cod_dominio(+) = 'CAUSALE_CHIUSURA'
          AND d.cod_causa_chius_delibera = do2.val_dominio(+)
          AND do2.cod_dominio(+) = 'CAUSALE_CHIUSURA_RISTR'
          AND d.cod_microtipologia_delib = t1.cod_microtipologia
          AND t1.flg_attivo = 1
          AND d.cod_macrotipologia_delib = t1.cod_macrotipologia
          AND T1.FLG_ATTIVO = 1;
