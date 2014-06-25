
  CREATE OR REPLACE FORCE VIEW "MCRE_OWN"."V_MCREI_APP_ELENCO_DELIBERE" ("FLG_LAST_RDV_CONFERMATA", "DATA_INS_CONF_DELIBERA", "COD_PROTOCOLLO_DELIBERA", "COD_PROTOCOLLO_DELIBERA_MOPLE", "COD_MACROTIPOLOGIA_DELIB", "DESC_MACROTIPOLOGIA", "COD_MICROTIPOLOGIA_DELIB", "DESC_MICROTIPOLOGIA", "COD_FASE_DELIBERA", "DESC_FASE_DELIBERA", "DTA_DELIBERA", "DTA_CREAZIONE_PACCHETTO", "DTA_CONFERMA_PACCHETTO", "TIPO_PACCHETTO", "COD_FASE_PACCHETTO", "LABEL_STATO_PACCHETTO", "DTA_MODIFICA_STATO", "COD_ORGANO_DELIBERANTE", "COD_ORGANO_CALCOLATO", "COD_ORGANO_PACCHETTO_DELIB", "COD_ORGANO_PACCHETTO_CALCOLATO", "DESC_ORGANO_DELIBERANTE", "DESC_ORGANO_CALCOLATO", "DESC_ORGANO_PACCHETTO_DELIB", "DESC_ORGANO_PACCHETTO_CALC", "DTA_SCADENZA", "DTA_FINE_GESTIONE", "FLG_ART_136", "FLG_PARTI_CORRELATE", "COD_SNDG", "COD_ABI", "DESC_ISTITUTO", "COD_STATO", "DESC_MICROSTATO", "DESC_MACROSTATO", "DTA_DECORRENZA_STATO", "COD_PROCESSO", "COD_NDG", "COD_PROTOCOLLO_PACCHETTO", "COD_PRATICA", "VAL_ANNO_PRATICA", "COD_COMPARTO", "ID_UTENTE", "ID_REFERENTE", "COD_TIPO_PACCHETTO", "DESC_TIPO_PACCHETTO", "DESC_FASE_PACCHETTO", "FLG_NO_DELIBERA", "COD_DOC_DELIBERA_BANCA", "COD_DOC_PARERE_CONFORMITA", "COD_DOC_APPENDICE_PARERE", "COD_DOC_DELIBERA_CAPOGRUPPO", "COD_DOC_CLASSIFICAZIONE", "ORDINAMENTO", "COD_STATO_PRECEDENTE", "DTA_DEC_STATO_MOPLE", "DTA_DECORRENZA_STATO_PRE", "COD_PERCORSO", "FLG_RISTRUTTURATO", "COD_GRUPPO_SUPER", "DESC_NOTE_DELIBERE_ANNULLATE", "VAL_RDV_QC_ANTE_DELIB", "VAL_RDV_QC_DELIBERATA", "VAL_RDV_QC_PROGRESSIVA", "DESC_NO_DELIBERA","COD_DOC_CLASSIFICAZIONE_MCI") AS 
  SELECT                                                  /*no_parallel (f)*/
          --111115 MM:aggiunto comparto/utente
          --111121 MM: join con abi_.cartolarizzato!
          --120123 MM, doppio campo protocollo delibera
          --080212 AD: modificata scadenza stato
          --modificata dta_modifica_stato
          --0216 aggiunto filtro fase_del != 'AN' e no_delib = 0
          --05luglio2012: aggiunta gestione per pacchetto automatico al fine di permettere extradelibera anche su delibere mople
          --01feb2013: cod_stato_posiz e dta_dec_stato_posiz
          --130215 MM: protocollo-mople uo da proposta prima che da pratica
          DISTINCT
          DECODE (
             cod_tipo_pacchetto,
             'A',                                                   --5 LUGLIO
                  (CASE
                      ---FLG CHE ABILITA GESTIONE VALUTAZIONI SOLO SULL'ULTIMA RV CONFERMATA PER SNDG
                      WHEN (dta_last_upd_delibera =
                               (SELECT MAX (dta_last_upd_delibera)
                                  FROM t_mcrei_app_delibere r
                                 WHERE r.cod_abi = d.cod_abi
                                       AND r.cod_ndg = d.cod_ndg
                                       AND r.cod_microtipologia_delib IN
                                              ('RV', 'T4', 'A0', 'IM', 'IF')
                                       AND r.cod_fase_delibera = 'CO'
                                       AND r.flg_no_delibera = 0
                                       ---24 LUGLIO
                                       AND dta_conferma_delibera IS NOT NULL)
                            /*AND cod_tipo_pacchetto in ('M','B','A')*/
                            AND val_num_progr_delibera =
                                   (SELECT MAX (val_num_progr_delibera)
                                      FROM t_mcrei_app_delibere r
                                     WHERE     r.cod_abi = d.cod_abi
                                           AND r.cod_ndg = d.cod_ndg
                                           AND r.cod_fase_delibera = 'CO'
                                           AND r.flg_no_delibera = 0
                                           AND (r.cod_microtipologia_delib IN
                                                   ('RV',
                                                    'T4',
                                                    'A0',
                                                    'IM',
                                                    'IF')
                                                OR cod_macrotipologia_delib =
                                                      'TP')        --26 LUGLIO
                                                           )) --0629 controllo spostato qui da web.modificabile
                      THEN
                         'Y'
                      ELSE
                         'N'
                   END),
             (CASE
                 ---FLG CHE ABILITA GESTIONE VALUTAZIONI SOLO SULL'ULTIMA RV CONFERMATA PER SNDG
                 WHEN (dta_conferma_delibera =
                          (SELECT MAX (dta_conferma_delibera)
                             FROM t_mcrei_app_delibere r
                            WHERE r.cod_abi = d.cod_abi
                                  AND r.cod_ndg = d.cod_ndg
                                  AND r.cod_microtipologia_delib IN
                                         ('RV', 'T4', 'A0', 'IM', 'IF')
                                  AND r.cod_fase_delibera = 'CO'
                                  AND r.flg_no_delibera = 0
                                  ----24 LUGLIO
                                  AND dta_conferma_delibera IS NOT NULL)
                       /*AND cod_tipo_pacchetto in ('M','B','A')*/
                       AND val_num_progr_delibera =
                              (SELECT MAX (val_num_progr_delibera)
                                 FROM t_mcrei_app_delibere r
                                WHERE     r.cod_abi = d.cod_abi
                                      AND r.cod_ndg = d.cod_ndg
                                      AND r.cod_fase_delibera = 'CO'
                                      --26 OTTOBRE
                                      AND r.flg_no_delibera = 0
                                      AND (r.cod_microtipologia_delib IN
                                              ('RV', 'T4', 'A0', 'IM', 'IF')) --26 LUGLIO
                                                                             )) --0629 controllo spostato qui da web.modificabile
                 THEN
                    'Y'
                 ELSE
                    'N'
              END))
             AS flg_last_rdv_confermata,
          --28 maggio: abilitazione extra-delibera*/
          --modificata data_ins_conf_delibera il 30 /08
          TRUNC (NVL (d.dta_conferma_delibera, d.dta_ins_delibera))
             AS data_ins_conf_delibera,
          /*DECODE (d.cod_tipo_pacchetto,
                      'M', TRUNC (NVL (d.dta_conferma_delibera, d.dta_ins_delibera)),
                        NVL (d.dta_last_upd_delibera, d.dta_ins_delibera))*/
          d.cod_protocollo_delibera,
          /* cod_protocollo_delibera in formato MOPLE PPPPPPPPAAAAUUUUU => UUUUU/AAAA/PPPPPPPP  P = Progressivo A = Anno U = UO*/
          --MM 15.02 uo letta da uo_proposta su delibera prima che dalla pratiche
          CASE
             WHEN d.cod_microtipologia_delib IN ('CI', 'CS')
                  AND d.cod_tipo_pacchetto = 'M'
             THEN
                NVL (
                   d.cod_uo_pratica,
                   NVL (d.cod_uo_proposta, NVL (p.cod_uo_pratica, '00000')))
                || '/'
                || SUBSTR (cod_protocollo_delibera, 1, 4)
                || '/'
                || SUBSTR (cod_protocollo_delibera, 10, 8)
             WHEN d.cod_microtipologia_delib IN ('CI', 'CS')
                  AND d.cod_tipo_pacchetto = 'A'
             THEN
                NVL (
                   d.cod_uo_pratica,
                   NVL (d.cod_uo_proposta, NVL (p.cod_uo_pratica, '00000')))
                || '/'
                || SUBSTR (cod_protocollo_delibera, 3, 4)
                || '/'
                || SUBSTR (cod_protocollo_delibera, 9, 9)
             WHEN d.cod_microtipologia_delib IN ('CI', 'CS')          --30 AUG
                  AND d.cod_tipo_pacchetto = 'B'
             THEN
                NVL (
                   d.cod_uo_pratica,
                   NVL (d.cod_uo_proposta, NVL (p.cod_uo_pratica, '00000')))
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
          t1.cod_macrotipologia,                                        --31/8
          t1.desc_macrotipologia,
          d.cod_microtipologia_delib,
          t1.desc_microtipologia,
          d.cod_fase_delibera,
          do2.desc_dominio AS desc_fase_delibera,
          d.dta_delibera,
          TRUNC (d.dta_creazione_pacchetto) dta_creazione_pacchetto,
          d.dta_conferma_pacchetto,
          d.cod_tipo_pacchetto AS tipo_pacchetto,
          d.cod_fase_pacchetto,
          DO.cod_label_web AS label_stato_pacchetto,
          NVL (d.dta_upd_fase_delibera, dta_conferma_delibera)
             AS dta_modifica_stato,
          --- 31/8 modificata dta_conferma_delibera
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
                     'IR', d.dta_scadenza_ristr,                   --MM1304214
                     d.dta_scadenza))
             AS dta_scadenza,
          p.dta_fine_gestione,
          -- AS dta_scadenza, modificato prendendo scadenza incaglio dalla pratica
          NVL (d.flg_art_136, 'N') AS flg_art_136,
          NVL (d.flg_parti_correlate, 'N') AS flg_parti_correlate,
          d.cod_sndg,
          d.cod_abi,
          f.desc_istituto,
          DECODE (d.cod_stato_posiz,
                  '-1', F.COD_sTATO,
                  NULL, F.COD_STATO,
                  d.cod_stato_posiz)
             AS cod_stato,                    ---5 FEB   CHANGE REQUEST UTENTE
          --NVL (d.cod_stato_posiz, NULLIF (F.COD_STATO, '-1'))
          s.desc_microstato,
          s.desc_macrostato,
          DECODE (
             D.DTA_DEC_STATO_POSIZ,
             NULL, DECODE (d.cod_microtipologia_delib,
                           'CI', F.DTA_DECORRENZA_STATO,
                           NVL (P.DTA_APERTURA, F.DTA_DECORRENZA_STATO)),
             D.DTA_DEC_STATO_POSIZ)
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
          DECODE (d.cod_tipo_pacchetto,
                  'A', 'Automatico',
                  'M', 'Manuale',
                  'B', 'Batch')
             AS desc_tipo_pacchetto,
          DO.desc_dominio AS desc_fase_pacchetto,
          DECODE (d.flg_no_delibera,
                  1, 'Y',
                  0, 'N',
                  2, 'U',
                  flg_no_delibera)
             AS flg_no_delibera,
          cod_doc_delibera_banca,
          cod_doc_parere_conformita,
          cod_doc_appendice_parere,
          cod_doc_delibera_capogruppo,
          cod_doc_classificazione,
          DECODE (d.cod_abi, '01025', 1 || d.cod_abi, 2 || d.cod_abi)
             AS ordinamento,
          cod_stato_precedente,
          f.dta_decorrenza_stato AS dta_dec_stato_mople,
          dta_decorrenza_stato_pre,
          COD_PERCORSO,
          D.FLG_RISTRUTTURATO,                                     --AD: 29/10
          F.COD_GRUPPO_SUPER,
          D.DESC_NOTE_DELIBERE_ANNULLATE,
          d.val_rdv_qc_ante_delib,
          d.val_rdv_qc_deliberata,
          d.val_rdv_qc_progressiva,
          --131224
          d.desc_no_delibera,
          D.COD_DOC_CLASSIFICAZIONE_MCI --T.B. APERTURA MCI 25-06-14
     FROM t_mcrei_app_delibere d,
          t_mcrei_app_pratiche p,
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
          AND d.flg_attiva = '1'
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
          AND '01025' = o3.cod_abi_istituto(+)                        --11 giu
          AND o3.cod_stato_riferimento(+) = 'IN'
          AND d.cod_organo_pacchetto_calc = o4.cod_organo_deliberante(+)
          AND '01025' = o4.cod_abi_istituto(+)                        --11 giu
          AND o4.cod_stato_riferimento(+) = 'IN'
          AND d.cod_microtipologia_delib = t1.cod_microtipologia(+)
          --AND t1.flg_attivo(+) = 1 -- 25.03.13
          AND d.cod_macrotipologia_delib = t2.cod_macrotipologia(+)
          --AND t2.flg_attivo(+) = 1 -- 25.03.13
          AND d.cod_fase_pacchetto = DO.val_dominio
          AND DO.cod_dominio = 'PACCHETTO'
          AND d.cod_fase_delibera = do2.val_dominio
          AND do2.cod_dominio = 'DELIBERA'
          AND NVL (d.cod_stato_posiz, F.COD_STATO) = s.cod_microstato --28 gen: AD
          AND ( (d.cod_fase_pacchetto NOT IN ('ANA', 'ANM')       --13Dicembre
                 AND d.cod_fase_delibera NOT IN ('AN', 'VA')      --13Dicembre
                                                            )
               OR d.flg_to_copy = '9')--07Gennaio2014: condizione per visualizzare le delibere annullate con flg_to_copi='9' 
          AND d.flg_no_delibera = 0;
