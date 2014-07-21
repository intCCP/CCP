/* Formatted on 21/07/2014 18:40:04 (QP5 v5.227.12220.39754) */
CREATE OR REPLACE FORCE VIEW MCRE_OWN.V_MCREI_APP_DETT_RAPPORTI_RV
(
   COD_ABI,
   COD_NDG,
   DTA_STIMA,
   COD_PROT_DELIBERA,
   COD_RAPPORTO,
   COD_TIPO_RAPPORTO,
   VAL_NUM_RAPPORTO,
   VAL_FORMA_TECNICA,
   VAL_UTILIZZATO_LORDO,
   VAL_UTILIZZATO_NETTO,
   VAL_UTILIZZATO_MORA,
   VAL_UTILIZZATO_FIRMA,
   COD_OPERAT_RIENTRO,
   FLG_RISTRUTT,
   FLG_RECUPERO_TOT,
   VAL_RETTIFICA_LIVELLO_RAPPORTO,
   VAL_STIMA_DI_REC,
   FLG_STORICO,
   VAL_INTERVALLO,
   FLG_FONDO_TERZI,
   COD_PROT_PACCHETTO,
   VAL_PERCENTUALE,
   VAL_IMP_PREV_PREGR,
   VAL_IMP_RETTIFICA_PREGR,
   VAL_RDV_TOT,
   FONDO_TERZI,
   VAL_UTILIZZATO_SOSTI,
   VAL_RDV_RAPP_OPERATIVI,
   VAL_IMP_RETTIFICA_ATT,
   VAL_RETT_CASSA_QTA_CAP,
   VAL_RDV_FIRMA,
   VAL_RDV_PREGR_CASSA,
   VAL_RDV_PREGR_FIRMA,
   COD_NPE,
   VAL_ACCORDATO_DELIB,
   COD_FTECNICA,
   DTA_EFFICACIA_RISTR,
   DTA_EFFICACIA_ADD,
   DTA_INIZIO_SEGNALAZIONE_RISTR,
   DTA_FINE_SEGNALAZIONE_RISTR
)
AS
   SELECT DISTINCT
          --20/11/2013 aggiunto case per gestione flg_fondo_terzi
          dett.cod_abi,
          dett.cod_ndg,
          dta_stima,
          cod_prot_delibera,
          cod_rapporto,
          cod_tipo_rapporto,
          val_num_rapporto,
          DECODE (TRIM (val_forma_tecnica), '-', NULL, val_forma_tecnica)
             AS val_forma_tecnica,
          val_utilizzato_lordo,
          val_utilizzato_lordo - val_utilizzato_mora AS val_utilizzato_netto, --18 apr
          val_utilizzato_mora,
          val_utilizzato_firma,
          cod_operat_rientro,
          flg_ristrutt,
          flg_recupero_tot,
          val_rettifica_livello_rapporto,
          DECODE (flg_recupero_tot,
                  'Y', (val_utilizzato_lordo - NVL (val_utilizzato_mora, 0)),
                  val_stima_di_rec)
             val_stima_di_rec,                                     --11 MAGGIO
          flg_storico,
          val_intervallo,
          CASE WHEN cod_ftecnica = '54' THEN 'Y' ELSE flg_fondo_terzi END
             flg_fondo_terzi,
          cod_prot_pacchetto,
          val_percentuale,
          val_imp_prev_pregr,
          val_imp_rettifica_pregr,
          val_rdv_tot,
          fondo_terzi,
          val_utilizzato_sosti,
          val_rdv_rapp_operativi,
          val_imp_rettifica_att,
          val_rett_cassa_qta_cap,                                       --14/3
          val_rdv_firma,
          val_rdv_pregr_cassa,
          val_rdv_pregr_firma,
          e.cod_npe,
          val_accordato_delib,                                      --21 MARZO
          cod_ftecnica,
          DTA_EFFICACIA_RISTR,
          DTA_EFFICACIA_ADD,
          dta_inizio_segnalazione_ristr,                            --2 maggio
          dta_fine_segnalazione_ristr                               --2 maggio
     FROM (SELECT DISTINCT
                  pcr.cod_abi,
                  pcr.cod_ndg,
                  st.dta_stima,
                  pcr.cod_protocollo_delibera AS cod_prot_delibera,
                  pcr.cod_rapporto,
                  pcr.cod_classe_ft AS cod_tipo_rapporto,
                  pcr.cod_rapporto AS val_num_rapporto,
                  pcr.val_accordato_delib,
                  pcr.DTA_EFFICACIA_RISTR,
                  pcr.DTA_EFFICACIA_ADD,
                  nat.cod_ftecnica,
                  nat.cod_ftecnica || ' ' || nat.desc_ftecnica
                     AS val_forma_tecnica,
                  DECODE (pcr.cod_classe_ft, 'CA', pcr.val_imp_utilizzato, --31 ott
                                                                          0)
                     AS val_utilizzato_lordo, ---in pcr l'utilizzato Š gi¿ comprensivo di mora
                  DECODE (pcr.cod_classe_ft, 'FI', pcr.val_imp_utilizzato, --31 ott
                                                                          0)
                     AS val_utilizzato_firma,
                  DECODE (pcr.cod_classe_ft, 'ST', pcr.val_imp_utilizzato, --31 ott
                                                                          0)
                     AS val_utilizzato_sosti,
                  DECODE (pcr.cod_classe_ft,
                          'CA', pcr.val_imp_utilizzato,               --31 ott
                          -NVL (i.val_imp_mora, 0), 0)
                     AS val_utilizzato_netto,
                  NVL (i.val_imp_mora, 0) AS val_utilizzato_mora,
                  NVL (st.flg_tipo_dato,
                       DECODE (nat.cod_natura,  '01', 'R',  '02', 'S',  'R'))
                     AS cod_operat_rientro,                         --8 MAGGIO
                  st.flg_ristrutturato AS flg_ristrutt,
                  st.flg_recupero_tot,
                  st.val_rdv_tot AS val_rettifica_livello_rapporto, --MODIFICATO IL 13 MARZO PER CAMBIO LOGICA
                  st.val_prev_recupero AS val_stima_di_rec, --MODIFICATO IL 13 MARZO PER CAMBIO LOGICA
                  'Y' AS flg_storico, ---- 23 MAGGIO   : C'Š ALMENO SE STESSO NELLO STORICO
                  DECODE (nat.cod_natura,  '01', 'BR',  '02', 'MLT')
                     AS val_intervallo,
                  ----24 ottobre: AD --> rdv su rapp operativi Š quella sui rapporti di tipo R di cassa
                  --decode(st.flg_tipo_dato, 'R', st.val_rdv_tot, 0) AS val_rdv_rapp_operativi,
                  (CASE
                      WHEN (    st.flg_tipo_dato = 'R'
                            AND pcr.cod_classe_ft = 'CA')
                      THEN
                         st.val_rdv_tot
                      ELSE
                         0
                   END)
                     AS val_rdv_rapp_operativi,
                  DECODE (pcr.cod_classe_ft, 'CA', st.val_rdv_tot, 0)
                     AS val_rett_cassa_qta_cap,
                  DECODE (pcr.cod_classe_ft, 'FI', st.val_rdv_tot, 0)
                     AS val_rdv_firma,
                  DECODE (pcr.cod_classe_ft,
                          'CA', st.val_imp_rettifica_pregr,
                          0)
                     AS val_rdv_pregr_cassa,
                  DECODE (pcr.cod_classe_ft,
                          'FI', st.val_imp_rettifica_pregr,
                          0)
                     AS val_rdv_pregr_firma,
                  ra.flg_fondo_terzi,
                  pcr.cod_protocollo_pacchetto AS cod_prot_pacchetto,
                  st.val_perc_rett_rapporto AS val_percentuale,
                  st.val_imp_prev_pregr,
                  st.val_imp_rettifica_pregr,
                  st.val_rdv_tot,
                  st.val_imp_rettifica_att,
                  st.dta_inizio_segnalazione_ristr,                 --2 maggio
                  st.dta_fine_segnalazione_ristr,                   --2 maggio
                    NVL (pcr.val_imp_utilizzato, 0)
                  - (  (  (100 - ra.val_perc_fondo_terzi)
                        * NVL (pcr.val_imp_utilizzato, 0))
                     / 100)
                     AS fondo_terzi,
                  DECODE (
                     st.cod_protocollo_delibera,
                     NULL, 1,
                     (RANK ()
                      OVER (
                         PARTITION BY st.cod_abi,
                                      st.cod_ndg,
                                      st.cod_protocollo_delibera,
                                      st.cod_rapporto,
                                      ST.COD_FORMA_TECNICA
                         ORDER BY st.dta_stima DESC)))
                     rn
             FROM t_mcrei_app_stime st,
                  (SELECT DISTINCT
                          dd.cod_abi,
                          dd.cod_ndg,
                          pc.cod_rapporto,
                          dd.cod_protocollo_delibera,
                          DECODE (
                             (COUNT (
                                 DISTINCT cod_forma_tecnica)
                              OVER (
                                 PARTITION BY pc.cod_abi,
                                              pc.cod_ndg,
                                              pc.cod_rapporto,
                                              f.cod_natura)),
                             1, cod_forma_tecnica,
                             '-')
                             AS cod_forma_tecnica,
                          f.cod_natura,         --01= CASSA BT, 02= CASSA VMLT
                          SUM (
                             pc.val_imp_utilizzato)
                          OVER (
                             PARTITION BY pc.cod_abi,
                                          pc.cod_ndg,
                                          pc.cod_rapporto,
                                          f.cod_natura)
                             AS val_imp_utilizzato,
                          SUM (
                             pc.val_accordato_delib)
                          OVER (
                             PARTITION BY pc.cod_abi,
                                          pc.cod_ndg,
                                          pc.cod_rapporto,
                                          f.cod_natura)
                             AS val_accordato_delib,
                          cod_protocollo_pacchetto,
                          cod_classe_ft,
                          DD.DTA_EFFICACIA_RISTR, --30 APRILE PER GESTIONE RISTRUTTURATI
                          DD.DTA_EFFICACIA_ADD
                     FROM t_mcrei_app_delibere dd,
                          t_mcrei_app_pcr_rapporti pc,
                          t_mcre0_app_natura_ftecnica f
                    WHERE     dd.cod_abi = pc.cod_abi
                          AND dd.cod_ndg = pc.cod_ndg
                          AND dd.flg_attiva = '1'
                          AND pc.cod_classe_ft IN ('CA', 'FI', 'ST')   ----7/3
                          AND dd.cod_abi =
                                 SUBSTR (
                                    (SYS_CONTEXT ('userenv', 'client_info')),
                                    1,
                                    5)
                          AND dd.cod_ndg =
                                 SUBSTR (
                                    (SYS_CONTEXT ('userenv', 'client_info')),
                                    6,
                                    16)
                          AND dd.cod_protocollo_delibera =
                                 SUBSTR (
                                    (SYS_CONTEXT ('userenv', 'client_info')),
                                    22,
                                    17)
                          AND cod_forma_tecnica = f.cod_ftecnica) pcr,
                  t_mcre0_app_natura_ftecnica nat,
                  t_mcre0_app_rate_daily i,          ----a livello di rapporti
                  t_mcrei_app_rapporti ra /*,
                   t_mcrei_hst_valutazioni h --27 APRILE*/
            WHERE /*DA ESEGUIRE PRIMA DELLA CHIAMATA ALLA VISTA
             BEGIN dbms_application_info.set_client_info( abi||ndg||cod_protocollo_delibera ); END;*/
                 pcr  .cod_abi = st.cod_abi(+)
                  AND pcr.cod_ndg = st.cod_ndg(+)
                  AND pcr.cod_protocollo_delibera =
                         st.cod_protocollo_delibera(+)
                  AND pcr.cod_forma_tecnica = st.cod_forma_tecnica(+)
                  AND pcr.cod_rapporto = st.cod_rapporto(+)
                  AND st.flg_attiva(+) = '1'
                  AND pcr.cod_abi = i.cod_abi_cartolarizzato(+)
                  AND pcr.cod_ndg = i.cod_ndg(+)
                  AND pcr.cod_rapporto = i.cod_rapporto(+)
                  AND pcr.cod_abi = ra.cod_abi(+)
                  AND pcr.cod_ndg = ra.cod_ndg(+)
                  AND pcr.cod_rapporto = ra.cod_rapporto(+)        -- 23 marzo
                  AND ra.flg_attiva(+) = '1'
                  -- AND st.cod_rapporto = h.cod_rapporto(+)
                  AND pcr.cod_forma_tecnica = nat.cod_ftecnica) dett,
          t_mcrei_app_rapporti_estero e
    WHERE     rn = 1
          AND dett.cod_abi = e.cod_abi(+)
          AND dett.cod_ndg = e.cod_ndg(+)
          AND dett.cod_rapporto = e.cod_rapporto_estero(+);
