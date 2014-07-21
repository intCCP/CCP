/* Formatted on 21/07/2014 18:39:21 (QP5 v5.227.12220.39754) */
CREATE OR REPLACE FORCE VIEW MCRE_OWN.V_MCREI_APP_DATI_CONTABILI_OLD
(
   COD_ABI_CARTOLARIZZATO,
   COD_NDG,
   COD_PROTOCOLLO_PACCHETTO,
   COD_PROTOCOLLO_DELIBERA,
   DATA_AGGIORNAMENTO_DATI,
   FONTE_DATI,
   PERC_DUBBIO_ESITO,
   SCADENZA_INCAGLIO,
   TOTALE_ACCORDATO,
   TOTALE_UTILIZZATO,
   FONDO_TERZI,
   TOT_UTI_AL_NETTO_FONDO_TERZI,
   UTILIZZATO_DI_CASSA,
   UTILIZZATO_DI_FIRMA,
   DERIVATI,
   UTI_QUOTA_CAPITALE,
   INTERESSI_DI_MORA,
   VAL_RETTIFICA_PROG_DELIB,
   VAL_ULTIMA_PERCENTUALE,
   DTA_RIF_ULTIMA_PERC
)
AS
     SELECT                              --0221 introdotta nuova pcr_rapp_aggr
            --0301 marzo aggiunta join con rapporti per calcolo interessi di mora
            a.cod_abi_cartolarizzato,
            a.cod_ndg,
            d.cod_protocollo_pacchetto,
            d.cod_protocollo_delibera,
            p.scsb_dta_riferimento AS data_aggiornamento_dati,
            'PCR RAPPORTI' AS fonte_dati,
            D.VAL_PERC_DUBBIO_ESITO AS PERC_DUBBIO_ESITO,
            d.dta_scadenza AS scadenza_incaglio, --09-09-2013 rimosso calcolo della data
            NVL (p.scsb_acc_tot, 0) AS totale_accordato,
            (NVL (p.scsb_uti_cassa, 0) + NVL (p.scsb_uti_firma, 0))
               AS totale_utilizzato,
              NVL (p.scsb_uti_tot, 0)
            - (  ( (100 - ra.tot_perc_rischio_banca) * NVL (p.scsb_uti_tot, 0))
               / 100)
               AS fondo_terzi,
              NVL (p.scsb_uti_tot, 0)
            - (  NVL (p.scsb_uti_tot, 0)
               - (  (  (100 - ra.tot_perc_rischio_banca)
                     * NVL (p.scsb_uti_tot, 0))
                  / 100))
               AS tot_uti_al_netto_fondo_terzi, -- formula: uti_tot - [(100-perc_rischio)% dell'uti_tot]
            NVL (p.scsb_uti_cassa, 0) AS utilizzato_di_cassa,
            NVL (p.scsb_uti_firma, 0) AS utilizzato_di_firma,
            NVL (p.scsb_uti_sostituzioni, 0) AS derivati,
            NVL (p.scsb_uti_cassa, 0) - NVL (i.interessi_di_mora, 0)
               AS uti_quota_capitale,            --corretto con uti_cassa 27/2
            i.interessi_di_mora,
            --del.val_rdv_qc_progressiva
            (NVL (d.val_rdv_qc_ante_delib, 0) + NVL (D.VAL_rDV_PREGR_FI, 0))
               AS val_rettifica_prog_delib, -- solo CS,   -->AD, 27 feb: aggiunta rdv di firma deliberata
            x.val_perc_risk AS val_ultima_percentuale,
            x.dta_ref AS dta_rif_ultima_perc
       FROM /*DA ESEGUIRE PRIMA DELLA CHIAMATA ALLA VISTA
          BEGIN dbms_application_info.set_client_info( cod_abi||cod_nsg ); END;*/
           t_mcre0_app_all_data a,
            t_mcrei_app_pcr_rapp_aggr p,
            t_mcre0_app_comparti c,
            t_mcre0_app_rio_proroghe r,
            (SELECT cod_abi,
                    cod_ndg,
                    val_perc_risk,
                    dta_ref
               FROM (SELECT cod_abi,
                            cod_ndg,
                            val_perc_risk,
                            dta_ref,
                            MAX (dta_ref) OVER (PARTITION BY cod_abi, cod_ndg)
                               max_dta_ref
                       FROM t_mcrei_app_percentuali_ret
                      WHERE     cod_abi =
                                   SUBSTR (
                                      (SYS_CONTEXT ('userenv', 'client_info')),
                                      1,
                                      5)
                            AND cod_ndg =
                                   SUBSTR (
                                      (SYS_CONTEXT ('userenv', 'client_info')),
                                      6,
                                      16))
              WHERE dta_ref = max_dta_ref) x,                       --mm130515
            (  SELECT r.cod_abi,
                      r.cod_ndg,
                      SUM (NVL (i.val_imp_mora, 0)) AS interessi_di_mora
                 FROM t_mcre0_app_rate_daily i,                        ---5/03
                                               t_mcrei_app_pcr_rapporti r
                WHERE     i.cod_abi_cartolarizzato = r.cod_abi
                      AND r.cod_abi =
                             SUBSTR ( (SYS_CONTEXT ('userenv', 'client_info')),
                                     1,
                                     5)
                      AND r.cod_ndg =
                             SUBSTR ( (SYS_CONTEXT ('userenv', 'client_info')),
                                     6,
                                     16)
                      AND i.cod_ndg = r.cod_ndg
                      AND i.cod_rapporto = r.cod_rapporto
             GROUP BY r.cod_abi, r.cod_ndg) i,
            (  SELECT cod_abi,
                      cod_ndg,
                      flg_attiva,
                      SUM (NVL (r.val_perc_fondo_terzi, 0))
                         AS tot_perc_rischio_banca
                 FROM t_mcrei_app_rapporti r
                WHERE     r.flg_fondo_terzi = 'S'
                      AND r.cod_abi =
                             SUBSTR ( (SYS_CONTEXT ('userenv', 'client_info')),
                                     1,
                                     5)
                      AND r.cod_ndg =
                             SUBSTR ( (SYS_CONTEXT ('userenv', 'client_info')),
                                     6,
                                     16)
             GROUP BY cod_abi, cod_ndg, flg_attiva) ra,
            (SELECT d1.*
               FROM t_mcrei_app_delibere d1, t_mcrei_cl_tipologie t
              WHERE     d1.cod_microtipologia_delib = t.cod_microtipologia
                    AND t.cod_famiglia_tipologia IN ('DCLS', 'DCLI')
                    AND d1.flg_no_delibera = 0
                    AND d1.cod_fase_delibera != 'AN'
                    AND t.flg_attivo = '1') d
      WHERE     a.cod_abi_cartolarizzato = p.cod_abi_cartolarizzato(+)
            AND a.cod_ndg = p.cod_ndg(+)
            --  AND d.cod_abi = del.cod_abi(+)
            AND a.cod_abi_cartolarizzato = d.cod_abi
            AND a.cod_ndg = d.cod_ndg
            --15/5
            AND a.cod_abi_cartolarizzato = x.cod_abi(+)
            AND a.cod_ndg = x.cod_ndg(+)
            --
            AND d.flg_attiva = '1'
            -- AND d.cod_microtipologia_delib IN ('CI', 'CS')  --17.04.2012, aggiunta join con t_mcrei_cl_tipologie e filtro
            -- AND d.cod_ndg = del.cod_ndg(+)
            -- and  d.cod_protocollo_delibera =del.cod_protocollo_delibera(+)
            AND p.cod_abi_cartolarizzato = ra.cod_abi(+)
            AND p.cod_ndg = ra.cod_ndg(+)
            AND ra.flg_attiva(+) = '1'
            AND p.cod_abi_cartolarizzato = i.cod_abi(+)
            AND p.cod_ndg = i.cod_ndg(+)
            AND NVL (a.cod_comparto_assegnato, cod_comparto_calcolato) =
                   c.cod_comparto(+) --30 mar aggiunto recupero data scadenza in base a proroghe di default
            AND a.cod_abi_cartolarizzato = r.cod_abi_cartolarizzato(+)
            AND a.cod_ndg = r.cod_ndg(+)
            AND r.flg_storico(+) = 0
            AND r.flg_esito(+) = 1
   GROUP BY a.cod_abi_cartolarizzato,
            a.cod_ndg,
            d.cod_protocollo_pacchetto,
            d.cod_protocollo_delibera,
            p.scsb_dta_riferimento,
            'PCR RAPPORTI',
            D.VAL_PERC_DUBBIO_ESITO,
            d.dta_scadenza,
            NVL (p.scsb_acc_tot, 0),
            (NVL (p.scsb_uti_cassa, 0) + NVL (p.scsb_uti_firma, 0)), --uti_tot
              NVL (p.scsb_uti_tot, 0)
            - (  (  (100 - ra.tot_perc_rischio_banca)
                  * NVL (p.scsb_uti_tot, 0))
               / 100),                                      -- AS fondo_terzi,
              NVL (p.scsb_uti_tot, 0)
            - (  NVL (p.scsb_uti_tot, 0)
               - (  (  (100 - ra.tot_perc_rischio_banca)
                     * NVL (p.scsb_uti_tot, 0))
                  / 100)),                 -- AS tot_uti_al_netto_fondo_terzi,
            NVL (p.scsb_uti_cassa, 0),
            NVL (p.scsb_uti_firma, 0),
            NVL (p.scsb_uti_sostituzioni, 0),
            NVL (p.scsb_uti_cassa, 0) - NVL (i.interessi_di_mora, 0),
            interessi_di_mora,
            (NVL (d.val_rdv_qc_ante_delib, 0) + NVL (D.VAL_rDV_PREGR_FI, 0)),
            val_perc_risk,
            dta_ref;
