/* Formatted on 21/07/2014 18:39:39 (QP5 v5.227.12220.39754) */
CREATE OR REPLACE FORCE VIEW MCRE_OWN.V_MCREI_APP_DELIBERE_HST
(
   DATA_INS_CONF_DELIBERA,
   COD_PROTOCOLLO_DELIBERA,
   COD_PROTOCOLLO_DELIBERA_MOPLE,
   COD_MACROTIPOLOGIA_DELIB,
   DESC_MACROTIPOLOGIA,
   COD_MICROTIPOLOGIA_DELIB,
   DESC_MICROTIPOLOGIA,
   COD_FASE_DELIBERA,
   DESC_FASE_DELIBERA,
   DTA_DELIBERA,
   DTA_CREAZIONE_PACCHETTO,
   DTA_CONFERMA_PACCHETTO,
   TIPO_PACCHETTO,
   COD_FASE_PACCHETTO,
   LABEL_STATO_PACCHETTO,
   DTA_MODIFICA_STATO,
   COD_ORGANO_DELIBERANTE,
   COD_ORGANO_CALCOLATO,
   COD_ORGANO_PACCHETTO_DELIB,
   COD_ORGANO_PACCHETTO_CALC,
   DESC_ORGANO_DELIBERANTE,
   DESC_ORGANO_CALCOLATO,
   DESC_ORGANO_PACCHETTO_DELIB,
   DESC_ORGANO_PACCHETTO_CALC,
   DTA_SCADENZA,
   DTA_FINE_GESTIONE,
   FLG_ART_136,
   FLG_PARTI_CORRELATE,
   COD_SNDG,
   COD_ABI,
   DESC_ISTITUTO,
   COD_STATO,
   DESC_MICROSTATO,
   DESC_MACROSTATO,
   DTA_DECORRENZA_STATO,
   COD_PROCESSO,
   COD_NDG,
   COD_PROTOCOLLO_PACCHETTO,
   COD_PRATICA,
   VAL_ANNO_PRATICA,
   COD_COMPARTO,
   ID_UTENTE,
   ID_REFERENTE,
   COD_TIPO_PACCHETTO,
   DESC_TIPO_PACCHETTO,
   DESC_FASE_PACCHETTO,
   COD_DOC_DELIBERA_BANCA,
   COD_DOC_PARERE_CONFORMITA,
   COD_DOC_APPENDICE_PARERE,
   COD_DOC_DELIBERA_CAPOGRUPPO,
   COD_DOC_CLASSIFICAZIONE,
   VAL_RDV_QC_ANTE_DELIB,
   VAL_RDV_EXTRA_DELIBERA,
   VAL_ESP_NETTA_ANTE_DELIB,
   VAL_RDV_QC_DELIBERATA,
   VAL_RDV_QC_PROGRESSIVA,
   COD_GRUPPO_SUPER
)
AS
   SELECT DISTINCT                                         /*no_parallel (f)*/
          --111115 MM:aggiunto comparto/utente
          --111121 MM: join con abi_.cartolarizzato!
          --120123 MM, doppio campo protocollo delibera
          DECODE (d.cod_tipo_pacchetto,
                  'M', NVL (d.dta_conferma_delibera, d.dta_ins_delibera),
                  NVL (d.dta_last_upd_delibera, d.dta_ins_delibera))
             AS data_ins_conf_delibera,                      --MODIFICATA 28/2
          d.cod_protocollo_delibera,
          /* cod_protocollo_delibera in formato MOPLE
          PPPPPPPPAAAAUUUUU  => UUUUU/AAAA/PPPPPPPP
          P = Progressivo
           A = Anno
          U = UO
           */
          CASE
             WHEN     d.cod_microtipologia_delib IN ('CI', 'CS')
                  AND d.cod_tipo_pacchetto = 'M'
             THEN
                   NVL (p.cod_uo_pratica, '00000')
                || '/'
                || SUBSTR (cod_protocollo_delibera, 1, 4)
                || '/'
                || SUBSTR (cod_protocollo_delibera, 10, 8)
             WHEN     d.cod_microtipologia_delib IN ('CI', 'CS')
                  AND d.cod_tipo_pacchetto = 'A'
             THEN
                   NVL (p.cod_uo_pratica, '00000')
                || '/'
                || SUBSTR (cod_protocollo_delibera, 3, 4)
                || '/'
                || SUBSTR (cod_protocollo_delibera, 9, 9)
             ELSE
                   SUBSTR (cod_protocollo_delibera, 13, 5)
                || '/'
                || SUBSTR (cod_protocollo_delibera, 9, 4)
                || '/'
                || SUBSTR (cod_protocollo_delibera, 1, 8)
          END
             AS cod_protocollo_delibera_mople,
          d.cod_macrotipologia_delib,
          t2.desc_macrotipologia,
          d.cod_microtipologia_delib,
          t1.desc_microtipologia,
          d.cod_fase_delibera,
          do2.desc_dominio AS desc_fase_delibera,
          d.dta_delibera,
          d.dta_creazione_pacchetto,
          d.dta_conferma_pacchetto,
          d.cod_tipo_pacchetto AS tipo_pacchetto,
          d.cod_fase_pacchetto,
          DO.cod_label_web AS label_stato_pacchetto,
          NVL (d.dta_upd_fase_delibera, dta_last_upd_delibera)
             AS dta_modifica_stato,
          ---campo che indica la data in cui l'utente ha aggiornato lo stato facendolo avanzare a valle del workflow
          d.cod_organo_deliberante,
          d.cod_organo_calcolato,
          d.cod_organo_pacchetto AS cod_organo_pacchetto_delib,
          d.cod_organo_pacchetto_calc AS cod_organo_pacchetto_calc,
          o2.desc_organo_deliberante AS desc_organo_deliberante,
          o1.desc_organo_deliberante AS desc_organo_calcolato,
          o3.desc_organo_deliberante AS desc_organo_pacchetto_delib,
          o4.desc_organo_deliberante AS desc_organo_pacchetto_calc,
          DECODE (
             cod_macrotipologia_delib,
             'TP', d.dta_scadenza_transaz,
             DECODE (d.cod_microtipologia_delib,
                     'CS', TO_DATE (NULL, 'ddmmyyyy'),
                     'CI', TO_DATE (NULL, 'ddmmyyyy'),
                     'TR', d.dta_scadenza_transaz,
                     d.dta_scadenza))
             AS dta_scadenza,
          p.dta_fine_gestione,
          -- AS dta_scadenza, modificato prendendo scadenza incaglio dalla pratica
          NVL (d.flg_art_136, 'N') AS flg_art_136,
          NVL (d.flg_parti_correlate, 'N') AS flg_parti_correlate,
          d.cod_sndg,
          d.cod_abi,
          f.desc_istituto,
          NULLIF (f.cod_stato, '-1') cod_stato,
          s.desc_microstato,
          s.desc_macrostato,
          DECODE (
             d.cod_microtipologia_delib,
             'CS', (DECODE (
                       p.dta_fine_stato,
                       TO_DATE ('31/12/9999', 'DD/MM/YYYY'), p.dta_decorrenza_stato,
                       (p.dta_fine_stato + 1))),
             p.dta_decorrenza_stato)
             AS dta_decorrenza_stato,                       ---modificata 24/2
          f.cod_processo,
          d.cod_ndg,
          d.cod_protocollo_pacchetto,
          d.cod_pratica,
          d.val_anno_pratica,
          -- assegnazione
          NVL (f.cod_comparto_assegnato, f.cod_comparto_calcolato)
             cod_comparto,
          f.id_utente,
          u.id_referente,
          d.cod_tipo_pacchetto,
          DECODE (d.cod_tipo_pacchetto,  'A', 'Automatico',  'M', 'Manuale')
             AS desc_tipo_pacchetto,
          DO.desc_dominio AS desc_fase_pacchetto,
          /*   DECODE (d.flg_no_delibera, 1, 'Y', 0, 'N', 2, 'U', flg_no_delibera)
          AS flg_no_delibera,*/
          cod_doc_delibera_banca,
          cod_doc_parere_conformita,
          cod_doc_appendice_parere,
          cod_doc_delibera_capogruppo,
          cod_doc_classificazione,
          ---30 marzo modificato calcolo rdv totali
          (NVL (d.val_rdv_qc_ante_delib, 0) + NVL (d.val_rdv_pregr_fi, 0))
             AS val_rdv_qc_ante_delib,
          d.val_rdv_extra_delibera,
          d.val_esp_netta_ante_delib,
            (NVL (d.val_rdv_qc_progressiva, 0) + NVL (d.val_rdv_progr_fi, 0))
          - (NVL (d.val_rdv_qc_ante_delib, 0) + NVL (d.val_rdv_pregr_fi, 0))
             AS val_rdv_qc_deliberata,
          NVL (d.val_rdv_qc_progressiva, 0) + NVL (d.val_rdv_progr_fi, 0)
             AS val_rdv_qc_progressiva,
          --(30 mar: CA+FI)
          F.COD_GRUPPO_SUPER
     FROM t_mcrei_hst_delibere d,
          t_mcrei_hst_pratiche p,
          t_mcre0_app_all_data f,
          t_mcre0_app_utenti u,
          t_mcre0_cl_organi_deliberanti o1,
          t_mcre0_cl_organi_deliberanti o2,
          t_mcre0_cl_organi_deliberanti o3,
          t_mcre0_cl_organi_deliberanti o4,
          t_mcrei_cl_tipologie t1,
          t_mcrei_cl_tipologie t2,
          t_mcrei_cl_domini DO,
          t_mcrei_cl_domini do2,
          t_mcre0_app_stati s
    WHERE     d.cod_abi = f.cod_abi_cartolarizzato
          AND d.cod_ndg = f.cod_ndg
          AND d.cod_abi = p.cod_abi(+)
          AND d.cod_ndg = p.cod_ndg(+)
          AND d.val_anno_pratica = p.val_anno_pratica(+)
          AND d.cod_pratica = p.cod_pratica(+)
          AND p.flg_attiva(+) = '1'
          AND f.id_utente = u.id_utente
          AND d.cod_organo_calcolato = o1.cod_organo_deliberante(+)
          AND d.cod_abi = o1.cod_abi_istituto(+)
          AND o1.cod_stato_riferimento(+) = 'IN'
          AND d.cod_organo_deliberante = o2.cod_organo_deliberante(+)
          AND d.cod_abi = o2.cod_abi_istituto(+)
          AND o2.cod_stato_riferimento(+) = 'IN'
          AND d.cod_organo_pacchetto = o3.cod_organo_deliberante(+)
          AND d.cod_abi = o3.cod_abi_istituto(+)
          AND o3.cod_stato_riferimento(+) = 'IN'
          AND d.cod_organo_pacchetto_calc = o4.cod_organo_deliberante(+)
          AND d.cod_abi = o4.cod_abi_istituto(+)
          AND o4.cod_stato_riferimento(+) = 'IN'
          AND d.cod_microtipologia_delib = t1.cod_microtipologia(+)
          AND t1.flg_attivo(+) = 1
          AND d.cod_macrotipologia_delib = t2.cod_macrotipologia(+)
          AND t2.flg_attivo(+) = 1
          AND d.cod_fase_pacchetto = DO.val_dominio
          AND DO.cod_dominio = 'PACCHETTO'
          AND d.cod_fase_delibera = do2.val_dominio
          AND do2.cod_dominio = 'DELIBERA'
          AND f.cod_stato = s.cod_microstato
          AND d.cod_fase_pacchetto NOT IN ('ANA', 'ANM')          --13Dicembre
          AND d.cod_fase_delibera NOT IN ('AN', 'VA');
