/* Formatted on 21/07/2014 18:35:59 (QP5 v5.227.12220.39754) */
CREATE OR REPLACE FORCE VIEW MCRE_OWN.V_MCRE0_APP_SCHEDA_ANAG
(
   COD_ABI_CARTOLARIZZATO,
   DESC_ISTITUTO,
   COD_NDG,
   DESC_NOME_CONTROPARTE,
   COD_SNDG,
   VAL_PARTITA_IVA,
   COD_GRUPPO_ECONOMICO,
   COD_GRUPPO_LEGAME,
   VAL_ANA_GRE,
   COD_SNDG_GE,
   COD_COMPARTO,
   COD_STRUTTURA_COMPETENTE,
   NOME,
   COGNOME,
   COD_MATRICOLA,
   COD_STRUTTURA_COMPETENTE_DC,
   DESC_STRUTTURA_COMPETENTE_DC,
   COD_STRUTTURA_COMPETENTE_RG,
   DESC_STRUTTURA_COMPETENTE_RG,
   COD_STRUTTURA_COMPETENTE_AR,
   DESC_STRUTTURA_COMPETENTE_AR,
   COD_STRUTTURA_COMPETENTE_FI,
   DESC_STRUTTURA_COMPETENTE_FI,
   VAL_SEGMENTO_REGOLAMENTARE,
   DTA_INIZIO_RELAZIONE,
   COD_GESTORE_MKT,
   DESC_ANAG_GESTORE_MKT,
   COD_STATO,
   COD_PROCESSO,
   DTA_DECORRENZA_STATO,
   VAL_GG_IN_MACROSTATO,
   VAL_DODICI_MESI,
   VAL_GG_INTERCETTAMENTO,
   DTA_SCADENZA_STATO,
   DTA_RIF_PD_ONLINE,
   DTA_LAST_DEL_FIDO,
   DTA_LAST_PEF_PROPOSTA,
   FLG_FIDI_SCADUTI,
   DTA_SCADENZA_FIDO,
   VAL_LAST_FASE_PEF,
   VAL_STRATEGIA_CREDIT,
   VAL_LAST_ORGANO_DEL,
   VAL_CONTRASS_ORGANO_DEL,
   VAL_LAST_ORGANO_DEL_CP,
   VAL_CONTRASS_ORGANO_DEL_CP,
   COD_SAG,
   FLG_CONFERMA,
   FLG_ALLINEAMENTO,
   DTA_SAG,
   COD_SAB,
   FLG_ART_136,
   COD_SNDG_SOGGETTO,
   NUM_GIORNI_SCONFINO,
   FLG_SOGLIA,
   FLG_GESTIONE_ESTERNA,
   DTA_LAST_UPDATE_FG,
   DTA_LAST_UPDATE,
   FLG_OUTSOURCING,
   COD_TIPO_PORTAFOGLIO,
   DESC_TIPO_PORTAFOGLIO,
   COD_COMPETENZA,
   DTA_SCADENZA_PROROGA,
   VAL_MAU,
   ESISTE_DEL_ATTIVA,
   ESISTE_DEL_ATTIVA_SNDG,
   DTA_SCAD_REVISIONE_PEF,
   VAL_PREGIUDIZIEVOLI,
   DESC_TIPO_NOTIZIA,
   FLG_PARTI_CORRELATE,
   DESC_TIPO_RISTR,
   DESC_INTENTO_RISTR,
   DTA_EFFICACIA_RISTR,
   COD_PERCORSO,
   COD_GRUPPO_SUPER,
   COD_STATO_SOFF,
   FLG_PARTI_CORR_BANKIT,
   FLG_PARTI_CORR_136,
   FLG_PARTI_CORR_IA24,
   FLG_PARTI_CORR_CONSOB,
   FLG_OUTSOURCING_ABI,
   FLG_LIV_CRIT,
   DESC_NOTE_LIV_CRIT
)
AS
   SELECT /*+ NOPARALLEL(A) NOPARALLEL(X) NOPARALLEL(SA)*/
                                                -- V1 02/12/2010 VG: Congelata
                                           -- V2 21/12/2010 VG: trunc(sysdate)
                         -- V3 27/01/2011 MM: aggiunta Struttura Competente RG
                                             -- V4 03/02/2011 VG: dta_abi_elab
                                          -- V5 07/02/2011 VG: flg_outsourcing
                                          -- V6 08/02/2011 LF: flg_outsourcing
 -- V7 08/02/2011 VG: nvl(f.cod_comparto_calcolato,cod_compato_assegnato) cod_comparto
                                              -- V8 07/03/2011 MM: inserta PEF
                         -- v9 15/03/2011 MM: aggiunta Competenza e Tipo Port.
                                           -- V10 06/05/2011 VG: cod_matricola
                          -- v11 28/06/2011 MM: aggiunta data scadenza proroga
                                                            -- 21.07 Riscritta
                              -- 31.10 MM: aggiunta colonna 'ESISTE_DEL_ATTIVA
         --111115: aggiunta ESISTE_DEL_ATTIVA_SNDG, dtata_sag, mau, data_stato
                        --0223MM: aggiunto outer pratiche per data stato IN/SO
 --  21/05/2012 Valeria Galli pregiudizievoli (Commenti con label:   VG - CIB/BDT - INIZIO)
                    --0629 esposta scadenza pratica anche per IN oltre che RIO
                      --0709 fix bug decorrenza stato per stati not in (IN SO)
                                                --0808 fix bug pregiuduzievoli
                            --2610 aggiunto recupero info per ristrutturazioni
                        --0320 scadenza prorogo distinta per direzione o altro
             --0828 scadenza Incaglio come per regioni (non scadenza servizio)
                                              --0904 dati di ris se non chiusa
                               --unità organizzativa , addetto, stato attuale.
 --T.B.: modifica data_decorrenza_Stato : messo flg_target = 'Y' all'ultima when
 --M.C: 06/05/2014 modificata per risoluzione riga doppia, sulla tabella t_mcres_app_parti_corr.
         f.cod_abi_cartolarizzato,
         f.desc_istituto,
         f.cod_ndg,
         a.desc_nome_controparte,
         f.cod_sndg,
         a.val_partita_iva,
         f.cod_gruppo_economico,
         f.cod_gruppo_legame,
         f.desc_gruppo_economico val_ana_gre,
         GE.COD_SNDG COD_SNDG_GE,
         -- F.COD_COMPARTO,
         CASE
            WHEN F.COD_STATO = 'SO' AND today_flg = '1'
            THEN
               (SELECT COD_UO_PRATICA
                  FROM T_MCRES_APP_PRATICHE E
                 WHERE     E.COD_ABI = F.COD_ABI_CARTOLARIZZATO
                       AND E.COD_NDG = F.COD_NDG
                       AND e.flg_attiva = '1')
            WHEN F.COD_STATO = 'SO' AND today_flg = '0'
            THEN
               NULL
            ELSE
               F.COD_COMPARTO
         END
            COD_COMPARTO,
         f.cod_struttura_competente,
         -- f.nome,
         CASE
            WHEN F.COD_STATO = 'SO' AND today_flg = '1'
            THEN
               (SELECT g.val_nome
                  FROM T_MCRES_APP_PRATICHE E, t_mcres_app_gestori g
                 WHERE     E.COD_ABI = F.COD_ABI_CARTOLARIZZATO
                       AND E.COD_NDG = F.COD_NDG
                       AND e.cod_matr_pratica = g.cod_matricola
                       AND e.flg_attiva = '1')
            WHEN F.COD_STATO = 'SO' AND today_flg = '0'
            THEN
               NULL
            ELSE
               f.nome
         END
            NOME,
         --  f.cognome,
         CASE
            WHEN F.COD_STATO = 'SO' AND today_flg = '1'
            THEN
               (SELECT g.val_cognome
                  FROM T_MCRES_APP_PRATICHE E, t_mcres_app_gestori g
                 WHERE     E.COD_ABI = F.COD_ABI_CARTOLARIZZATO
                       AND E.COD_NDG = F.COD_NDG
                       AND e.cod_matr_pratica = g.cod_matricola
                       AND e.flg_attiva = '1')
            WHEN F.COD_STATO = 'SO' AND today_flg = '0'
            THEN
               NULL
            ELSE
               f.cognome
         END
            cognome,
         CASE
            WHEN F.COD_STATO = 'SO' AND today_flg = '1'
            THEN
               (SELECT E.COD_MATR_PRATICA
                  FROM T_MCRES_APP_PRATICHE E
                 WHERE     E.COD_ABI = F.COD_ABI_CARTOLARIZZATO
                       AND E.COD_NDG = F.COD_NDG
                       AND e.flg_attiva = '1')
            WHEN F.COD_STATO = 'SO' AND today_flg = '0'
            THEN
               NULL
            ELSE
               f.cod_matricola
         END
            cod_matricola,
         f.cod_struttura_competente_dc,
         f.desc_struttura_competente_dc,
         f.cod_struttura_competente_rg,
         f.desc_struttura_competente_rg,
         f.cod_struttura_competente_ar,
         f.desc_struttura_competente_ar,
         f.cod_struttura_competente_fi,
         f.desc_struttura_competente_fi,
         a.val_segmento_regolamentare,
         a.dta_inizio_relazione,
         f.cod_gestore_mkt,
         f.desc_anag_gestore_mkt,
         CASE
            WHEN f.flg_Target = 'Y'
            THEN
               f.cod_stato
            ELSE
               (SELECT s.cod_sag
                  FROM t_mcre0_app_Sag s
                 WHERE s.cod_sndg = f.cod_sndg)
         END
            cod_stato,
         f.cod_processo,
         CASE
            WHEN f.cod_stato IN ('IN', 'SO') AND f.flg_target = 'Y'
            THEN
               (SELECT NVL (
                          CASE
                             WHEN f.cod_stato = 'IN'
                             THEN
                                pr.dta_decorrenza_stato
                             WHEN f.cod_stato = 'SO'
                             THEN
                                DECODE (
                                   pr.dta_fine_stato,
                                   TO_DATE ('31/12/9999', 'DD/MM/YYYY'), pr.dta_decorrenza_stato,
                                   (pr.dta_fine_stato + 1))
                             ELSE
                                f.dta_decorrenza_stato
                          END,
                          f.dta_decorrenza_stato)
                  -- dta_apertura
                  FROM (  SELECT pr.cod_abi,
                                 pr.cod_ndg,
                                 MIN (pr.dta_decorrenza_stato) dta_decorrenza_stato,
                                 MIN (pr.dta_fine_stato) dta_fine_stato
                            FROM (  SELECT pr.cod_abi,
                                           pr.cod_ndg,
                                           MAX (pr.dta_decorrenza_stato)
                                              dta_decorrenza_stato,
                                           NULL dta_fine_stato
                                      FROM t_mcrei_app_pratiche pr
                                     WHERE dta_fine_stato =
                                              TO_DATE ('31/12/9999', 'DD/MM/YYYY')
                                  GROUP BY cod_abi, cod_ndg
                                  UNION ALL
                                    SELECT pr.cod_abi,
                                           pr.cod_ndg,
                                           NULL dta_decorrenza_stato,
                                           MAX (pr.dta_fine_stato) dta_fine_stato
                                      FROM t_mcrei_app_pratiche pr
                                     WHERE dta_fine_stato !=
                                              TO_DATE ('31/12/9999', 'DD/MM/YYYY')
                                  GROUP BY cod_abi, cod_ndg) pr
                        GROUP BY pr.cod_abi, pr.cod_ndg) pr
                 WHERE     pr.cod_abi(+) = f.cod_abi_cartolarizzato
                       AND pr.cod_ndg(+) = f.cod_ndg)
            WHEN f.flg_Target = 'N'
            THEN
               (SELECT s.dta_calcolo_sag
                  FROM t_mcre0_app_Sag s
                 WHERE s.cod_sndg = f.cod_sndg)
            WHEN f.cod_stato NOT IN ('IN', 'SO') AND f.flg_Target = 'Y'
            THEN
               f.dta_decorrenza_stato
         END
            AS dta_decorrenza_stato,
         --mm130517 fix Sofferenze
         CASE
            WHEN f.cod_stato = 'SO'
            THEN
               TRUNC (SYSDATE) - TRUNC (f.dta_decorrenza_stato)
            ELSE
               TRUNC (SYSDATE) - TRUNC (f.dta_dec_macrostato)
         END
            val_gg_in_macrostato,
         NULL val_dodici_mesi,                                      --- to_do,
         TRUNC (SYSDATE) - f.dta_intercettamento val_gg_intercettamento,
         f.dta_scadenza_stato,
         a.dta_rif_pd_online,
         dta_completamento_pef dta_last_del_fido,
         dta_ultima_revisione dta_last_pef_proposta,
         flg_fidi_scaduti AS flg_fidi_scaduti,
         dat_ultimo_scaduto AS dta_scadenza_fido,
         cod_fase_pef val_last_fase_pef,
         cod_strategia_crz val_strategia_credit,
         cod_ultimo_ode val_last_organo_del,
         cod_cts_ultimo_ode val_contrass_organo_del,
         NULL val_last_organo_del_cp,
         NULL val_contrass_organo_del_cp,
         sa.cod_sag,
         sa.flg_conferma,
         sa.flg_allineamento,
         CASE
            WHEN sa.flg_conferma = 'S' THEN sa.dta_conferma
            ELSE sa.dta_calcolo_sag
         END
            dta_sag,
         x.cod_sab,
         a.flg_art_136,
         a.cod_sndg_soggetto,
         x.num_giorni_sconfino,
         x.flg_soglia,
         f.flg_gestione_esterna,
         TRUNC (f.dta_upd) dta_last_update_fg,
         f.dta_abi_elab dta_last_update,
         f.flg_outsourcing,
         f.cod_tipo_portafoglio,
         t.desc_tipo_port desc_tipo_portafoglio,
         CASE                                   --TODO usare cl_trascinamenti!
            WHEN f.cod_ramo_calcolato = '000001' THEN 'CIB'
            WHEN f.cod_ramo_calcolato = '000002' THEN 'BdT'
            ELSE ''
         END
            cod_competenza,
         --v11
         --     DECODE (f.cod_macrostato,'RIO',
         --     DECODE (dta_esito,
         --          NULL, dta_servizio + f.val_gg_prima_proroga,
         --          dta_esito + f.val_gg_seconda_proroga),
         --     TO_DATE (NULL)
         --     )
         --0629 esposta scadenza pratica anche per IN oltre che RIO
         CASE                           --0320 distinguo tra direzione e altro
            WHEN (    f.cod_comparto_calcolato = '011901'
                  AND f.cod_macrostato IN ('RIO'))
            THEN
               DECODE (dta_esito,
                       NULL, dta_servizio + f.val_gg_prima_proroga,
                       dta_esito + f.val_gg_seconda_proroga)
            WHEN (   (    f.cod_comparto_calcolato != '011901'
                      AND f.cod_stato IN ('OC', 'OP', 'IN', 'RS'))
                  OR (    f.cod_comparto_calcolato = '011901'
                      AND f.cod_macrostato IN ('IN', 'RS')))
            THEN
               f.dta_scadenza_stato
            ELSE
               TO_DATE (NULL)
         END
            AS dta_scadenza_proroga,
         f.gb_val_mau AS val_mau,
         --gestione flag Esiste delibera.. per ora con query diretta
         (SELECT esiste_del_attiva
            FROM v_mcre0_app_ricerca_list_ndg v
           WHERE     v.cod_abi_cartolarizzato = f.cod_abi_cartolarizzato
                 AND v.cod_ndg = f.cod_ndg)
            AS esiste_del_attiva,
         --gestione flag Esiste delibera SNDG.. per ora con query diretta
         (SELECT esiste_del_attiva
            FROM v_mcre0_app_ricerca_list_sndg v
           WHERE v.cod_sndg = f.cod_sndg)
            AS esiste_del_attiva_sndg,
         --------------------   VG - CIB/BDT - INIZIO --------------------
         dta_sca_rev_pef dta_scad_revisione_pef,
         (  SELECT RTRIM (
                      XMLAGG (XMLELEMENT ("x", desc_tipo_notizia || ',') ORDER BY
                                                                            cod_tipo_notizia).EXTRACT (
                         '//text()'),
                      ',')
                      desc_tipo_notizia
              FROM (SELECT DISTINCT cod_sndg, cod_tipo_notizia, desc_tipo_notizia
                      FROM (SELECT cod_sndg,
                                   cod_tipo_notizia,
                                   desc_tipo_notizia,
                                   RANK ()
                                   OVER (PARTITION BY cod_sndg
                                         ORDER BY dta_elaborazione DESC)
                                      last_5
                              FROM t_mcre0_app_pregiudizievoli) a
                     WHERE last_5 < 6) b
             WHERE cod_sndg = f.cod_sndg
          GROUP BY cod_sndg)
            val_pregiudizievoli,
         -- cod_tipo_notizia val_pregiudizievoli,
         (  SELECT RTRIM (
                      XMLAGG (XMLELEMENT ("x", cod_tipo_notizia || ',') ORDER BY
                                                                           cod_tipo_notizia).EXTRACT (
                         '//text()'),
                      ',')
                      desc_tipo_notizia
              FROM (SELECT DISTINCT cod_sndg, cod_tipo_notizia, desc_tipo_notizia
                      FROM (SELECT cod_sndg,
                                   cod_tipo_notizia,
                                   desc_tipo_notizia,
                                   RANK ()
                                   OVER (PARTITION BY cod_sndg
                                         ORDER BY dta_elaborazione DESC)
                                      last_5
                              FROM t_mcre0_app_pregiudizievoli) a
                     WHERE last_5 < 6) b
             WHERE cod_sndg = f.cod_sndg
          GROUP BY cod_sndg)
            desc_tipo_notizia,
         -- 09/01/2014 modifica da T_MCREI_APP_PARTI_CORRELATE a T_MCRES_APP_PARTI_CORR
         DECODE (pc_new.cod_abi, NULL, 'N', 'S') flg_parti_correlate,
         --0904 filtro sui dati ris
         DECODE (ris.dta_chiusura_ristr, NULL, ris.desc_tipo_ristr, NULL)
            desc_tipo_ristr,
         DECODE (ris.dta_chiusura_ristr, NULL, ris.desc_intento_ristr, NULL)
            desc_intento_ristr,
         DECODE (ris.dta_chiusura_ristr,
                 NULL, ris.dta_efficacia_ristr,
                 TO_DATE (NULL))
            dta_efficacia_ristr,
         --19/09/2012
         F.COD_PERCORSO,
         -------------------- VG - CIB/BDT - FINE --------------------
         F.COD_GRUPPO_SUPER,
         CASE
            WHEN (F.COD_STATO = 'SO' AND F.TODAY_FLG = '1')
            THEN
               'APERTO'
            ELSE
               CASE
                  WHEN (F.COD_STATO = 'SO' AND F.TODAY_FLG = '0') THEN 'CHIUSO'
                  ELSE NULL
               END
         END
            COD_STATO_SOFF,
         DECODE (SUBSTR (pc_new.flg_rilevanza_normativa, 1, 1),
                 NULL, 'N',
                 'R', 'S',
                 'N')
            flg_parti_corr_bankit,
         DECODE (SUBSTR (pc_new.flg_rilevanza_normativa, 2, 1),
                 NULL, 'N',
                 'R', 'S',
                 'N')
            flg_parti_corr_136,
         DECODE (SUBSTR (pc_new.flg_rilevanza_normativa, 3, 1),
                 NULL, 'N',
                 'R', 'S',
                 'N')
            flg_parti_corr_ia24,
         DECODE (SUBSTR (pc_new.flg_rilevanza_normativa, 4, 1),
                 NULL, 'N',
                 'R', 'S',
                 'N')
            flg_parti_corr_consob,
         (SELECT NVL (flg_outsourcing, 'N')
            FROM t_mcre0_app_istituti_all a
           WHERE a.cod_abi = f.COD_ABI_CARTOLARIZZATO)
            AS FLG_OUTSOURCING_ABI,
         CASE
            WHEN F.COD_STATO IN ('GF', 'PB')
            THEN
               (SELECT cr.FL_SEMAFORO
                  FROM T_MCRE0_DAY_LIV_CRIT cr
                 WHERE     CR.COD_ABI = f.cod_abi_cartolarizzato
                       AND CR.COD_NDG = f.cod_ndg)
            ELSE
               NULL
         END
            FLG_LIV_CRIT,
         CASE
            WHEN F.COD_STATO IN ('GF', 'PB')
            THEN
               (SELECT cr.note
                  FROM T_MCRE0_DAY_LIV_CRIT cr
                 WHERE     CR.COD_ABI = f.cod_abi_cartolarizzato
                       AND CR.COD_NDG = f.cod_ndg)
            ELSE
               NULL
         END
            AS DESC_NOTE_LIV_CRIT
    FROM v_mcre0_app_upd_fields_all f,
         t_mcre0_app_anagrafica_gruppo a,
         t_mcre0_app_gruppo_economico ge,
         t_mcre0_app_sag sa,
         t_mcre0_app_sab_xra x,
         t_mcre0_app_pef p,                                               --v8
         t_mcre0_app_tipi_portafoglio t,
         t_mcre0_app_rio_proroghe r,
         --t_mcrei_app_parti_correlate pc,
         (SELECT *
            FROM (SELECT c.*,
                         RANK ()
                         OVER (PARTITION BY cod_abi, cod_sndg_sogg_connesso
                               ORDER BY flg_rilevanza_normativa DESC)
                            r
                    FROM t_mcres_app_parti_corr c)
           WHERE r = 1) pc_new, --06/05/2014 Modifica per risoluzione riga doppia
         --t_mcres_app_parti_corr  pc_new,
         (SELECT cod_abi,
                 cod_ndg,
                 DECODE (cod_microtipologia_delib,
                         'B8', TO_CHAR (NULL),
                         desc_tipo_ristr)
                    AS desc_tipo_ristr,
                 DECODE (cod_microtipologia_delib,
                         'B8', TO_CHAR (NULL),
                         desc_intento_ristr)
                    AS desc_intento_ristr,
                 DECODE (cod_microtipologia_delib,
                         'B8', TO_DATE (NULL),
                         dta_efficacia_ristr)
                    AS dta_efficacia_ristr,
                 dta_chiusura_ristr
            FROM (SELECT DISTINCT
                         cod_abi,
                         cod_ndg,
                         desc_tipo_ristr,
                         desc_intento_ristr,
                         dta_efficacia_ristr,
                         val_ordinale,
                         cod_microtipologia_delib,
                         dta_chiusura_ristr,
                         MAX (val_ordinale)
                            OVER (PARTITION BY cod_abi, cod_ndg)
                            max_ordinale                         ---29 ottobre
                    FROM t_mcrei_hst_ristrutturazioni)
           WHERE val_ordinale = max_ordinale) ris
   WHERE     f.cod_sndg = a.cod_sndg                                     --(+)
         AND f.cod_sndg = sa.cod_sndg(+)
         AND f.cod_abi_cartolarizzato = x.cod_abi_cartolarizzato(+)
         AND f.cod_ndg = x.cod_ndg(+)
         AND f.cod_gruppo_economico = ge.cod_gruppo_economico(+)
         AND f.cod_abi_istituto = p.cod_abi_istituto(+)
         AND f.cod_ndg = p.cod_ndg(+)
         AND f.cod_tipo_portafoglio = t.cod_tipo_port(+)
         --v11
         AND f.cod_abi_cartolarizzato = r.cod_abi_cartolarizzato(+)
         AND f.cod_ndg = r.cod_ndg(+)
         AND r.flg_storico(+) = 0
         AND r.flg_esito(+) = 1
         AND ge.flg_capogruppo(+) = 'S'
         --29/06/2012
         --AND f.cod_abi_istituto = pc.cod_abi(+)  commentata 09/01/2014
         --AND f.cod_ndg = pc.cod_ndg(+) commentata 09/01/2014
         AND f.cod_abi_cartolarizzato = ris.cod_abi(+)
         AND f.cod_ndg = ris.cod_ndg(+)
         -- 09/01/2014 dismissione T_MCREI_APP_PARTI_CORRELATE x leggere info da T_MCRES_APP_PARTI_CORR
         AND f.cod_abi_istituto = pc_new.cod_abi(+)
         AND f.cod_sndg = pc_new.cod_sndg_sogg_connesso(+);
