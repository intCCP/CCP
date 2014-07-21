/* Formatted on 21/07/2014 18:39:19 (QP5 v5.227.12220.39754) */
CREATE OR REPLACE FORCE VIEW MCRE_OWN.V_MCREI_APP_DATI_CONTABILI_MM
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
   VAL_RETTIFICA_PROG_DELIB
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
            d.val_perc_dubbio_esito AS perc_dubbio_esito,
            CASE
               WHEN a.cod_macrostato = 'RIO'
               THEN              --regola rio, + seonda proroga se già scaduta
                  CASE
                     WHEN DECODE (dta_esito,
                                  NULL, dta_servizio + c.val_gg_prima_proroga,
                                  dta_esito + c.val_gg_seconda_proroga) <
                             SYSDATE
                     THEN
                        TRUNC (SYSDATE) + c.val_gg_seconda_proroga
                     ELSE
                        DECODE (dta_esito,
                                NULL, dta_servizio + c.val_gg_prima_proroga,
                                dta_esito + c.val_gg_seconda_proroga)
                  END
               WHEN cod_macrostato = 'SC'
               THEN              --regola rio, + seonda proroga se già scaduta
                  CASE
                     WHEN (dta_servizio + c.val_gg_prima_proroga) < SYSDATE
                     THEN
                        TRUNC (SYSDATE) + c.val_gg_seconda_proroga
                     ELSE
                        dta_servizio + c.val_gg_prima_proroga
                  END
               ELSE
                  (d.dta_ins_delibera + c.val_gg_prima_proroga) -- 21 maggio modificata scadenza incaglio
            END
               AS scadenza_incaglio,
            --a.dta_scadenza_stato AS scadenza_incaglio, --ripristinata fonte all_Data --solo CI --(data permanenza nel servizio)
            --(d.dta_ins_delibera + c.val_gg_prima_proroga) AS scadenza_incaglio,
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
            del.val_rdv_qc_progressiva AS val_rettifica_prog_delib -- solo CS,
       FROM /*DA ESEGUIRE PRIMA DELLA CHIAMATA ALLA VISTA
              BEGIN dbms_application_info.set_client_info( cod_abi||cod_nsg ); END;*/
           t_mcre0_app_all_data a,
            t_mcrei_app_pcr_rapp_aggr p,
            t_mcre0_app_comparti c,
            t_mcre0_app_rio_proroghe r,
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
                    AND t.flg_attivo = '1') d,
            (SELECT cod_abi, cod_ndg, val_rdv_qc_progressiva
               FROM (SELECT cod_abi,
                            cod_ndg,
                            val_rdv_qc_progressiva,
                            dta_ins_delibera,
                            RANK ()
                            OVER (PARTITION BY cod_abi, cod_ndg
                                  ORDER BY val_num_progr_delibera DESC)
                               rn
                       FROM t_mcrei_app_delibere u
                      WHERE     cod_fase_delibera = 'CO'
                            AND val_rdv_qc_progressiva IS NOT NULL) s
              WHERE s.rn = 1) del
      WHERE     a.cod_abi_cartolarizzato = p.cod_abi_cartolarizzato(+)
            AND a.cod_ndg = p.cod_ndg(+)
            AND a.cod_abi_cartolarizzato = del.cod_abi(+)
            AND a.cod_abi_cartolarizzato = d.cod_abi
            AND a.cod_ndg = d.cod_ndg
            AND d.flg_attiva = '1'
            --                         AND d.cod_microtipologia_delib IN ('CI', 'CS')  --17.04.2012, aggiunta join con t_mcrei_cl_tipologie e filtro
            AND a.cod_ndg = del.cod_ndg(+)
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
            d.val_perc_dubbio_esito,
            --                             (d.dta_ins_delibera + c.val_gg_prima_proroga),
            CASE
               WHEN a.cod_macrostato = 'RIO'
               THEN              --regola rio, + seonda proroga se già scaduta
                  CASE
                     WHEN DECODE (
                             dta_esito,
                             NULL, dta_servizio + c.val_gg_prima_proroga,
                             dta_esito + c.val_gg_seconda_proroga) < SYSDATE
                     THEN
                        TRUNC (SYSDATE) + c.val_gg_seconda_proroga
                     ELSE
                        DECODE (dta_esito,
                                NULL, dta_servizio + c.val_gg_prima_proroga,
                                dta_esito + c.val_gg_seconda_proroga)
                  END
               WHEN cod_macrostato = 'SC'
               THEN              --regola rio, + seonda proroga se già scaduta
                  CASE
                     WHEN (dta_servizio + c.val_gg_prima_proroga) < SYSDATE
                     THEN
                        TRUNC (SYSDATE) + c.val_gg_seconda_proroga
                     ELSE
                        dta_servizio + c.val_gg_prima_proroga
                  END
               ELSE
                  (d.dta_ins_delibera + c.val_gg_prima_proroga)
            END,
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
            del.val_rdv_qc_progressiva;
