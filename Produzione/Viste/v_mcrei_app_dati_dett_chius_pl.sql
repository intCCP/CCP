/* Formatted on 17/06/2014 18:07:32 (QP5 v5.227.12220.39754) */
CREATE OR REPLACE FORCE VIEW MCRE_OWN.V_MCREI_APP_DATI_DETT_CHIUS_PL
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
   VAL_TOTALE_RETTIFICHE,
   VAL_RINUNCIA_PROG_TOTALE,
   COD_GESTIONE,
   DESC_GESTIONE,
   COD_CAUSALE_CHIUSURA,
   DESC_CAUSALE_CHIUSURA,
   NOTE,
   PARERE,
   FLG_RISTRUTT
)
AS
   SELECT                                --0221 introdotta nuova pcr_rapp_aggr
          --
          DISTINCT
          d.cod_abi,
          d.cod_ndg,
          d.cod_protocollo_pacchetto,
          d.cod_protocollo_delibera,
          d.cod_macrotipologia_delib AS cod_macrotipologia,
          t2.desc_macrotipologia,
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
          VAL_RDV_QC_PROGRESSIVA AS val_totale_rettifiche, -----campo da verificare
          d.val_rinuncia_totale AS val_rinuncia_prog_totale,
          a.cod_tipo_gestione AS cod_gestione,
          do.desc_dominio AS desc_gestione,
          d.cod_causa_chius_delibera AS cod_causale_chiusura,
          NVL (DO1.DESC_DOMINIO, 'n.d.') AS DESC_CAUSALE_CHIUSURA,
          d.desc_note AS note,
          NVL (TO_CHAR (desc_parere_esteso), desc_parere) AS parere,
          NVL (st.flg_ristrutturato, ra.flg_ristrutturato)
     FROM t_mcrei_app_delibere d,
          t_mcre0_app_all_data f,
          --t_mcre0_app_pcr p,
          t_mcrei_app_pcr_rapp_aggr p,
          t_mcrei_cl_tipologie t1,
          t_mcrei_cl_tipologie t2,
          t_mcrei_app_pratiche a,
          t_mcrei_cl_domini DO,
          t_mcrei_app_pareri pa,
          t_mcrei_cl_domini do1,
          t_mcrei_app_stime st,
          t_mcrei_app_rapporti ra
    WHERE     d.cod_abi = f.cod_abi_cartolarizzato
          AND d.cod_ndg = f.cod_ndg
          AND d.flg_attiva = '1'
          AND d.cod_microtipologia_delib NOT IN
                 ('C5', 'C8', 'D1', 'C4', 'D4', 'D5')
          -- Non cambiata con la COD_FAMIGLIA_TIPOLOGIA, perche' nessuno rivendica di aver creato o usare la vista
          AND d.cod_abi = p.cod_abi_cartolarizzato(+)
          AND d.cod_ndg = p.cod_ndg(+)
          AND d.cod_fase_pacchetto NOT IN ('ANA', 'ANM')
          AND d.cod_abi = a.cod_abi
          AND d.cod_ndg = a.cod_ndg
          AND a.flg_attiva = '1'
          AND d.cod_protocollo_delibera = pa.cod_protocollo_delibera(+)
          AND d.cod_abi = pa.cod_abi(+)
          AND d.cod_ndg = pa.cod_ndg(+)
          AND pa.flg_attiva(+) = '1'
          AND a.cod_tipo_gestione = do.val_dominio
          AND do.cod_dominio = 'TIPO_GESTIONE'
          AND D.COD_CAUSA_CHIUS_DELIBERA = do1.val_dominio(+)
          AND do1.cod_dominio(+) = 'CAUSALE_CHIUSURA'
          AND d.cod_microtipologia_delib = t1.cod_microtipologia
          --            AND T1.COD_FAMIGLIA_TIPOLOGIA != 'DGE'
          AND t1.flg_attivo = 1
          AND d.cod_macrotipologia_delib = t2.cod_macrotipologia
          AND t2.flg_attivo = 1
          AND d.cod_abi = st.cod_abi(+)
          AND d.cod_ndg = st.cod_ndg(+)
          AND d.cod_protocollo_delibera = st.cod_protocollo_delibera(+)
          AND st.flg_attiva(+) = '1'
          AND d.cod_abi = ra.cod_abi(+)
          AND d.cod_ndg = ra.cod_ndg(+)
          AND ra.flg_attiva(+) = '1';


GRANT DELETE, INSERT, REFERENCES, SELECT, UPDATE, ON COMMIT REFRESH, QUERY REWRITE, DEBUG, FLASHBACK, MERGE VIEW ON MCRE_OWN.V_MCREI_APP_DATI_DETT_CHIUS_PL TO MCRE_USR;
