/* Formatted on 21/07/2014 18:39:16 (QP5 v5.227.12220.39754) */
CREATE OR REPLACE FORCE VIEW MCRE_OWN.V_MCREI_APP_DATI_CONTABILI
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
   DTA_RIF_ULTIMA_PERC,
   ESPOSIZIONE_DI_CASSA
)
AS
   SELECT v.cod_abi_cartolarizzato,
          V.COD_NDG,
          v.cod_protocollo_pacchetto,
          v.cod_protocollo_delibera,
          v.data_aggiornamento_dati,
          v.fonte_dati,
          v.PERC_DUBBIO_ESITO,
          v.scadenza_incaglio,
          v.totale_accordato,
          v.TOTALE_UTILIZZATO,
          v.FONDO_TERZI,
          v.tot_uti_al_netto_fondo_terzi,
          v.utilizzato_di_cassa,
          v.utilizzato_di_firma,
          v.DERIVATI,
          v.uti_quota_capitale,
          v.INTERESSI_DI_MORA,
          v.VAL_RETTIFICA_PROG_DELIB,
          CASE
             WHEN (V.COD_PROTOCOLLO_PACCHETTO = W.COD_PROTOCOLLO_PACCHETTO)
             THEN
                CASE
                   WHEN (    W.COD_MICROTIPOLOGIA_DELIB = 'CS'
                         AND (SELECT q.VAL_PERC_DUBBIO_ESITO
                                FROM T_MCREI_APP_DELIBERE Q
                               WHERE     Q.COD_ABI = W.COD_ABI
                                     AND Q.COD_NDG = W.COD_NDG
                                     AND Q.COD_PROTOCOLLO_PACCHETTO =
                                            W.COD_PROTOCOLLO_PACCHETTO
                                     AND Q.COD_MICROTIPOLOGIA_DELIB = 'RV'
                                     AND Q.COD_FASE_DELIBERA != 'AN'
                                     AND Q.flg_no_delibera = '0')
                                IS NOT NULL)
                   THEN
                      (SELECT q.VAL_PERC_DUBBIO_ESITO
                         FROM T_MCREI_APP_DELIBERE Q
                        WHERE     Q.COD_ABI = W.COD_ABI
                              AND Q.COD_NDG = W.COD_NDG
                              AND Q.COD_PROTOCOLLO_PACCHETTO =
                                     W.COD_PROTOCOLLO_PACCHETTO
                              AND Q.COD_MICROTIPOLOGIA_DELIB = 'RV'
                              AND Q.COD_FASE_DELIBERA != 'AN'
                              AND Q.FLG_NO_DELIBERA = '0')
                   ELSE
                      V.VAL_PERC_RISK
                END
             ELSE
                NULL
          END
             VAL_ULTIMA_PERCENTUALE,
          CASE
             WHEN (V.COD_PROTOCOLLO_PACCHETTO = W.COD_PROTOCOLLO_PACCHETTO)
             THEN
                CASE
                   WHEN (    W.COD_MICROTIPOLOGIA_DELIB = 'CS'
                         AND (SELECT q.DTA_LAST_UPD_DELIBERA
                                FROM T_MCREI_APP_DELIBERE Q
                               WHERE     Q.COD_ABI = W.COD_ABI
                                     AND Q.COD_NDG = W.COD_NDG
                                     AND Q.COD_PROTOCOLLO_PACCHETTO =
                                            W.COD_PROTOCOLLO_PACCHETTO
                                     AND Q.COD_MICROTIPOLOGIA_DELIB = 'RV'
                                     AND Q.COD_FASE_DELIBERA != 'AN'
                                     AND Q.flg_no_delibera = '0')
                                IS NOT NULL)
                   THEN
                      (SELECT Q.DTA_LAST_UPD_DELIBERA
                         FROM T_MCREI_APP_DELIBERE Q
                        WHERE     Q.COD_ABI = W.COD_ABI
                              AND Q.COD_NDG = W.COD_NDG
                              AND Q.COD_PROTOCOLLO_PACCHETTO =
                                     W.COD_PROTOCOLLO_PACCHETTO
                              AND Q.COD_MICROTIPOLOGIA_DELIB = 'RV'
                              AND Q.COD_FASE_DELIBERA != 'AN'
                              AND Q.FLG_NO_DELIBERA = '0')
                   ELSE
                      v.dta_ref
                END
             ELSE
                NULL
          END
             DTA_RIF_ULTIMA_PERC,
          v.utilizzato_di_cassa AS esposizione_di_cassa
     FROM (  SELECT a.cod_abi_cartolarizzato,
                    a.cod_ndg,
                    d.cod_protocollo_pacchetto,
                    d.cod_protocollo_delibera,
                    p.scsb_dta_riferimento AS data_aggiornamento_dati,
                    'PCR RAPPORTI' AS fonte_dati,
                    D.VAL_PERC_DUBBIO_ESITO AS PERC_DUBBIO_ESITO,
                    d.dta_scadenza AS scadenza_incaglio,
                    NVL (p.scsb_acc_tot, 0) AS totale_accordato,
                    (NVL (P.SCSB_UTI_CASSA, 0) + NVL (P.SCSB_UTI_FIRMA, 0))
                       AS TOTALE_UTILIZZATO,
                      NVL (P.SCSB_UTI_TOT, 0)
                    - (  (  (100 - RA.TOT_PERC_RISCHIO_BANCA)
                          * NVL (P.SCSB_UTI_TOT, 0))
                       / 100)
                       AS FONDO_TERZI,
                      NVL (p.scsb_uti_tot, 0)
                    - (  NVL (p.scsb_uti_tot, 0)
                       - (  (  (100 - ra.tot_perc_rischio_banca)
                             * NVL (p.scsb_uti_tot, 0))
                          / 100))
                       AS tot_uti_al_netto_fondo_terzi,
                    NVL (p.scsb_uti_cassa, 0) AS utilizzato_di_cassa,
                    NVL (p.scsb_uti_firma, 0) AS utilizzato_di_firma,
                    NVL (P.SCSB_UTI_SOSTITUZIONI, 0) AS DERIVATI,
                    NVL (p.scsb_uti_cassa, 0) - NVL (i.interessi_di_mora, 0)
                       AS uti_quota_capitale,
                    i.interessi_di_mora,
                    (  NVL (D.VAL_RDV_QC_ANTE_DELIB, 0)
                     + NVL (D.VAL_RDV_PREGR_FI, 0))
                       AS VAL_RETTIFICA_PROG_DELIB,
                    X.VAL_PERC_RISK,              --as val_ultima_percentuale,
                    x.dta_ref                         --as dta_rif_ultima_perc
               FROM t_mcre0_app_all_data a,
                    t_mcrei_app_pcr_rapp_aggr p,
                    t_mcre0_app_comparti c,
                    T_MCRE0_APP_RIO_PROROGHE R,
                    (SELECT COD_ABI,
                            COD_NDG,
                            VAL_PERC_RISK,
                            DTA_REF
                       FROM (SELECT cod_abi,
                                    cod_ndg,
                                    val_perc_risk,
                                    dta_ref,
                                    MAX (dta_ref)
                                       OVER (PARTITION BY cod_abi, cod_ndg)
                                       max_dta_ref
                               FROM t_mcrei_app_percentuali_ret
                              WHERE     cod_abi =
                                           SUBSTR (
                                              (SYS_CONTEXT ('userenv',
                                                            'client_info')),
                                              1,
                                              5)
                                    AND cod_ndg =
                                           SUBSTR (
                                              (SYS_CONTEXT ('userenv',
                                                            'client_info')),
                                              6,
                                              16))
                      WHERE dta_ref = max_dta_ref) x,               --mm130515
                    (  SELECT r.cod_abi,
                              R.COD_NDG,
                              SUM (NVL (i.val_imp_mora, 0)) AS interessi_di_mora
                         FROM t_mcre0_app_rate_daily i,                ---5/03
                              t_mcrei_app_pcr_rapporti r
                        WHERE     i.cod_abi_cartolarizzato = r.cod_abi
                              AND r.cod_abi =
                                     SUBSTR (
                                        (SYS_CONTEXT ('userenv', 'client_info')),
                                        1,
                                        5)
                              AND r.cod_ndg =
                                     SUBSTR (
                                        (SYS_CONTEXT ('userenv', 'client_info')),
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
                                     SUBSTR (
                                        (SYS_CONTEXT ('userenv', 'client_info')),
                                        1,
                                        5)
                              AND r.cod_ndg =
                                     SUBSTR (
                                        (SYS_CONTEXT ('userenv', 'client_info')),
                                        6,
                                        16)
                     GROUP BY cod_abi, cod_ndg, flg_attiva) ra,
                    (SELECT d1.*
                       FROM t_mcrei_app_delibere d1, t_mcrei_cl_tipologie t
                      WHERE     d1.cod_microtipologia_delib =
                                   t.cod_microtipologia
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
                       / 100),                              -- AS fondo_terzi,
                      NVL (p.scsb_uti_tot, 0)
                    - (  NVL (p.scsb_uti_tot, 0)
                       - (  (  (100 - ra.tot_perc_rischio_banca)
                             * NVL (p.scsb_uti_tot, 0))
                          / 100)),         -- AS tot_uti_al_netto_fondo_terzi,
                    NVL (p.scsb_uti_cassa, 0),
                    NVL (p.scsb_uti_firma, 0),
                    NVL (p.scsb_uti_sostituzioni, 0),
                    NVL (p.scsb_uti_cassa, 0) - NVL (i.interessi_di_mora, 0),
                    interessi_di_mora,
                    (  NVL (D.VAL_RDV_QC_ANTE_DELIB, 0)
                     + NVL (D.VAL_RDV_PREGR_FI, 0)),
                    val_perc_risk,
                    DTA_REF) V,
          T_MCREI_APP_DELIBERE W
    WHERE     W.COD_ABI = V.COD_ABI_CARTOLARIZZATO
          AND W.COD_NDG = V.COD_NDG
          AND W.COD_PROTOCOLLO_PACCHETTO = V.COD_PROTOCOLLO_PACCHETTO
          AND W.COD_PROTOCOLLO_DELIBERA = V.COD_PROTOCOLLO_DELIBERA;
