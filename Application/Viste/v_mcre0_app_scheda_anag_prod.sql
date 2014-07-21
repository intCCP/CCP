/* Formatted on 21/07/2014 18:36:07 (QP5 v5.227.12220.39754) */
CREATE OR REPLACE FORCE VIEW MCRE_OWN.V_MCRE0_APP_SCHEDA_ANAG_PROD
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
   FLG_PARTI_CORRELATE
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
         f.cod_abi_cartolarizzato,
         f.desc_istituto,
         f.cod_ndg,
         a.desc_nome_controparte,
         f.cod_sndg,
         a.val_partita_iva,
         f.cod_gruppo_economico,
         f.cod_gruppo_legame,
         f.desc_gruppo_economico val_ana_gre,
         ge.cod_sndg cod_sndg_ge,
         f.cod_comparto,
         f.cod_struttura_competente,
         f.nome,
         f.cognome,
         f.cod_matricola,
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
         f.cod_stato,
         f.cod_processo,
         CASE
            WHEN f.cod_stato IN ('IN', 'SO')
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
            ELSE
               f.dta_decorrenza_stato
         END
            AS dta_decorrenza_stato,
         TRUNC (SYSDATE) - TRUNC (f.dta_dec_macrostato) val_gg_in_macrostato,
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
         --              DECODE (f.cod_macrostato,'RIO',
         --                  DECODE (dta_esito,
         --                             NULL, dta_servizio + f.val_gg_prima_proroga,
         --                             dta_esito + f.val_gg_seconda_proroga),
         --                  TO_DATE (NULL)
         --              )
         --0629 esposta scadenza pratica anche per IN oltre che RIO
         CASE
            WHEN f.cod_macrostato IN ('RIO', 'IN')
            THEN
               DECODE (dta_esito,
                       NULL, dta_servizio + f.val_gg_prima_proroga,
                       dta_esito + f.val_gg_seconda_proroga)
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
         cod_tipo_notizia val_pregiudizievoli,
         preg.desc_tipo_notizia desc_tipo_notizia,
         DECODE (pc.cod_abi, NULL, 'N', 'S') flg_parti_correlate
    -------------------- VG - CIB/BDT - FINE --------------------
    FROM v_mcre0_app_upd_fields_all f,
         t_mcre0_app_anagrafica_gruppo a,
         t_mcre0_app_gruppo_economico ge,
         t_mcre0_app_sag sa,
         t_mcre0_app_sab_xra x,
         t_mcre0_app_pef p,                                               --v8
         t_mcre0_app_tipi_portafoglio t,
         t_mcre0_app_rio_proroghe r,
         t_mcrei_app_parti_correlate pc,
         (  SELECT cod_sndg,
                   RTRIM (
                      XMLAGG (XMLELEMENT ("x", cod_tipo_notizia || ',') ORDER BY
                                                                           cod_tipo_notizia).EXTRACT (
                         '//text()'),
                      ',')
                      cod_tipo_notizia,
                   RTRIM (
                      XMLAGG (XMLELEMENT ("x", desc_tipo_notizia || ',') ORDER BY
                                                                            cod_tipo_notizia).EXTRACT (
                         '//text()'),
                      ',')
                      desc_tipo_notizia
              FROM (SELECT cod_sndg,
                           cod_tipo_notizia,
                           dta_elaborazione,
                           desc_tipo_notizia
                      FROM (SELECT cod_sndg,
                                   cod_tipo_notizia,
                                   dta_elaborazione,
                                   desc_tipo_notizia,
                                   RANK ()
                                   OVER (PARTITION BY cod_sndg
                                         ORDER BY dta_elaborazione DESC)
                                      last_5
                              FROM t_mcre0_app_pregiudizievoli) a
                     WHERE last_5 < 6) b
          GROUP BY cod_sndg) preg
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
         AND f.cod_abi_istituto = pc.cod_abi(+)
         AND f.cod_ndg = pc.cod_ndg(+)
         AND f.cod_sndg = preg.cod_sndg(+);
