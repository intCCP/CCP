/* Formatted on 17/06/2014 18:08:04 (QP5 v5.227.12220.39754) */
CREATE OR REPLACE FORCE VIEW MCRE_OWN.V_MCREI_APP_DETT_RAPPORTI
(
   COD_ABI,
   COD_NDG,
   DTA_STIMA,
   COD_PROT_DELIBERA,
   COD_RAPPORTO,
   COD_TIPO_RAPPORTO,
   VAL_NUM_RAPPORTO,
   FLG_ESTINTO,
   NEW_RAPP_DA_VAL,
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
          dett.cod_abi,
          dett.cod_ndg,
          dta_stima,
          --30 maggio: forzato protocollo_Delibera anche per rapporti nuovi da agganciare
          --ad una delibera esistente mediante extra-delibera
          NVL (cod_prot_delibera,
               SUBSTR ( (SYS_CONTEXT ('userenv', 'client_info')), 22, 17))
             AS cod_prot_delibera,
          NVL (cod_rapporto, val_num_rapporto) AS cod_rapporto,
          NVL (cod_tipo_rapporto, cod_classe_ft) AS cod_tipo_rapporto,
          NVL (val_num_rapporto, cod_rapporto) AS val_num_rapporto,
          flg_estinto,
          new_rapp_da_val,
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
                  'Y', (val_utilizzato_lordo - val_utilizzato_mora),
                  val_stima_di_rec)
             val_stima_di_rec,                                     --11 MAGGIO
          flg_storico,
          val_intervallo,
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
          dta_efficacia_ristr,
          dta_efficacia_add,
          dta_inizio_segnalazione_ristr,                            --2 maggio
          dta_fine_segnalazione_ristr                               --2 maggio
     FROM (( (SELECT DISTINCT
                     NVL (pcr.cod_abi, st.cod_abi) AS cod_abi,
                     NVL (pcr.cod_ndg, st.cod_ndg) AS cod_ndg,
                     st.dta_stima,
                     DECODE (st.cod_rapporto, NULL, 'Y', 'N')
                        AS new_rapp_da_val,
                     DECODE (pcr.cod_rapporto, NULL, 'Y', 'N') AS flg_estinto,
                     st.cod_protocollo_delibera AS cod_prot_delibera,
                     NVL (pcr.cod_rapporto, st.cod_rapporto) cod_rapporto,
                     pcr.cod_classe_ft AS cod_tipo_rapporto,
                     st.cod_classe_ft,
                     pcr.cod_rapporto AS val_num_rapporto,
                     pcr.val_accordato_delib,
                     st.dta_efficacia_ristr,
                     st.dta_efficacia_add,
                     nat.cod_ftecnica,
                     nat.cod_ftecnica || ' ' || nat.desc_ftecnica
                        AS val_forma_tecnica,
                     DECODE (NVL (st.cod_classe_ft, pcr.cod_classe_ft),
                             'CA', pcr.val_imp_utilizzato,            --31 ott
                             0)
                        AS val_utilizzato_lordo,
                     ---in pcr l'utilizzato e' gia' comprensivo di mora
                     DECODE (NVL (st.cod_classe_ft, pcr.cod_classe_ft),
                             'FI', pcr.val_imp_utilizzato,            --31 ott
                             0)
                        AS val_utilizzato_firma,
                     DECODE (NVL (st.cod_classe_ft, pcr.cod_classe_ft),
                             'ST', pcr.val_imp_utilizzato,            --31 ott
                             0)
                        AS val_utilizzato_sosti,
                     DECODE (NVL (st.cod_classe_ft, pcr.cod_classe_ft),
                             'CA', pcr.val_imp_utilizzato,            --31 ott
                             -NVL (pcr.val_imp_mora, 0), 0)
                        AS val_utilizzato_netto,
                     NVL (pcr.val_imp_mora, 0) AS val_utilizzato_mora,
                     NVL (
                        st.flg_tipo_dato,
                        DECODE (nat.cod_natura,  '01', 'R',  '02', 'S',  'R'))
                        AS cod_operat_rientro,                      --8 MAGGIO
                     st.flg_ristrutturato AS flg_ristrutt,
                     st.flg_recupero_tot,
                     st.val_rdv_tot AS val_rettifica_livello_rapporto,
                     --MODIFICATO IL 13 MARZO PER CAMBIO LOGICA
                     st.val_prev_recupero AS val_stima_di_rec,
                     --MODIFICATO IL 13 MARZO PER CAMBIO LOGICA
                     'Y' AS flg_storico,
                     ---- 23 MAGGIO   : C'? ALMENO SE STESSO NELLO STORICO
                     DECODE (nat.cod_natura,  '01', 'BR',  '02', 'MLT')
                        AS val_intervallo,
                     ----24 ottobre: AD --> rdv su rapp operativi ? quella sui rapporti di tipo R di cassa
                     --decode(st.flg_tipo_dato, 'R', st.val_rdv_tot, 0) AS val_rdv_rapp_operativi,
                     (CASE
                         WHEN (    st.flg_tipo_dato = 'R'
                               AND st.cod_classe_ft = 'CA')
                         THEN
                            st.val_rdv_tot
                         ELSE
                            0
                      END)
                        AS val_rdv_rapp_operativi,
                     DECODE (st.cod_classe_ft, 'CA', st.val_rdv_tot, 0)
                        AS val_rett_cassa_qta_cap,
                     DECODE (st.cod_classe_ft, 'FI', st.val_rdv_tot, 0)
                        AS val_rdv_firma,
                     DECODE (st.cod_classe_ft,
                             'CA', st.val_imp_rettifica_pregr,
                             0)
                        AS val_rdv_pregr_cassa,
                     DECODE (st.cod_classe_ft,
                             'FI', st.val_imp_rettifica_pregr,
                             0)
                        AS val_rdv_pregr_firma,
                     ra.flg_fondo_terzi,
                     st.cod_protocollo_pacchetto AS cod_prot_pacchetto,
                     st.val_perc_rett_rapporto AS val_percentuale,
                     st.val_imp_prev_pregr,
                     st.val_imp_rettifica_pregr,
                     st.val_rdv_tot,
                     st.val_imp_rettifica_att,
                     st.dta_inizio_segnalazione_ristr,
                     --2 maggio
                     st.dta_fine_segnalazione_ristr,
                     --2 maggio
                     st.cod_protocollo_delibera,
                       --nvl(st.val_esposizione,pcr.val_imp_utilizzato) -
                       pcr.val_imp_utilizzato
                     -                                                --31 ott
                       (  (  (100 - ra.val_perc_fondo_terzi)
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
                                         st.cod_forma_tecnica
                            ORDER BY st.dta_stima DESC)))
                        rn
                FROM (SELECT DISTINCT s.cod_abi,
                                      s.cod_sndg,
                                      s.cod_ndg,
                                      s.cod_rapporto,
                                      s.dta_stima,
                                      s.desc_causa_prev_recupero,
                                      s.flg_recupero_tot,
                                      s.cod_uo_stima,
                                      s.val_imp_prev_pregr,
                                      s.val_imp_prev_att,
                                      s.val_prev_recupero,
                                      s.val_esposizione,
                                      s.val_rdv_tot,
                                      s.val_imp_rettifica_pregr,
                                      s.val_imp_rettifica_att,
                                      s.flg_tipo_dato,
                                      s.cod_utente,
                                      s.val_attualizzato,
                                      s.flg_pres_piano,
                                      s.cod_tipo_rapporto,
                                      s.cod_protocollo_delibera,
                                      s.cod_classe_ft,
                                      s.flg_ristrutturato,
                                      s.val_utilizzato_netto,
                                      s.val_utilizzato_mora,
                                      s.val_perc_rett_rapporto,
                                      s.val_accordato,
                                      s.cod_microtipologia_delibera,
                                      s.flg_attiva,
                                      s.cod_npe,
                                      s.flg_tipo_rapporto,
                                      s.dta_inizio_segnalazione_ristr,
                                      --2 maggio
                                      s.dta_fine_segnalazione_ristr,
                                      --2 maggio
                                      s.cod_forma_tecnica,
                                      d.dta_efficacia_ristr,
                                      d.dta_efficacia_add,
                                      cod_protocollo_pacchetto
                        FROM t_mcrei_app_stime s, t_mcrei_app_delibere d
                       WHERE     s.cod_abi = d.cod_abi
                             AND s.cod_ndg = d.cod_ndg
                             AND s.cod_protocollo_delibera =
                                    d.cod_protocollo_delibera
                             AND s.flg_attiva = 1
                             AND d.flg_attiva = 1
                             AND s.cod_abi =
                                    SUBSTR (
                                       (SYS_CONTEXT ('userenv',
                                                     'client_info')),
                                       1,
                                       5)
                             AND s.cod_ndg =
                                    SUBSTR (
                                       (SYS_CONTEXT ('userenv',
                                                     'client_info')),
                                       6,
                                       16)
                             AND s.cod_protocollo_delibera =
                                    SUBSTR (
                                       (SYS_CONTEXT ('userenv',
                                                     'client_info')),
                                       22,
                                       17)) st,
                     (SELECT DISTINCT
                             p.cod_abi,
                             p.cod_ndg,
                             p.cod_rapporto,
                             cod_classe_ft, ---24 OTT: INTRODOTTA GESTIONE DOPPIA FT
                             MAX (
                                cod_forma_tecnica)
                             OVER (
                                PARTITION BY p.cod_abi,
                                             p.cod_ndg,
                                             p.cod_rapporto)
                                cod_forma_tecnica,
                             NVL (i.val_imp_mora, 0) AS val_imp_mora,
                             --f.cod_natura, --01= CASSA BT, 02= CASSA VMLT
                             SUM (
                                p.val_imp_utilizzato)
                             OVER (
                                PARTITION BY p.cod_abi,
                                             p.cod_ndg,
                                             p.cod_rapporto)
                                val_imp_utilizzato,
                             SUM (
                                p.val_accordato_delib)
                             OVER (
                                PARTITION BY p.cod_abi,
                                             p.cod_ndg,
                                             p.cod_rapporto)
                                val_accordato_delib
                        /*cod_forma_tecnica,
                        nvl(i.val_imp_mora, 0) AS val_imp_mora,
                        --f.cod_natura, --01= CASSA BT, 02= CASSA VMLT
                        (p.val_imp_utilizzato),
                        (p.val_accordato_delib)*/
                        FROM t_mcrei_app_pcr_rapporti p,
                             t_mcre0_app_rate_daily i,
                             t_mcre0_app_natura_ftecnica f
                       WHERE     p.cod_abi = i.cod_abi_cartolarizzato(+)
                             AND p.cod_ndg = i.cod_ndg(+)
                             AND p.cod_rapporto = i.cod_rapporto(+)
                             AND p.cod_forma_tecnica = f.cod_ftecnica
                             AND p.cod_abi =
                                    SUBSTR (
                                       (SYS_CONTEXT ('userenv',
                                                     'client_info')),
                                       1,
                                       5)
                             AND p.cod_ndg =
                                    SUBSTR (
                                       (SYS_CONTEXT ('userenv',
                                                     'client_info')),
                                       6,
                                       16)) pcr,
                     t_mcre0_app_natura_ftecnica nat,
                     (SELECT DISTINCT cod_rapporto,
                                      cod_abi,
                                      cod_ndg,
                                      flg_attiva,
                                      flg_fondo_terzi,
                                      val_perc_fondo_terzi
                        FROM t_mcrei_app_rapporti) ra
               WHERE /*DA ESEGUIRE PRIMA DELLA CHIAMATA ALLA VISTA
                     BEGIN dbms_application_info.set_client_info( abi||ndg||cod_protocollo_delibera ); END;*/
                    st   .cod_abi = pcr.cod_abi(+)
                     AND st.cod_ndg = pcr.cod_ndg(+)
                     AND st.cod_rapporto = pcr.cod_rapporto(+) --AND st.cod_forma_tecnica = nat.cod_ftecnica(+)
                     AND pcr.cod_forma_tecnica = nat.cod_ftecnica(+) ---24 ottobre
                     AND st.flg_attiva = '1'
                     AND st.cod_abi =
                            SUBSTR (
                               (SYS_CONTEXT ('userenv', 'client_info')),
                               1,
                               5)
                     AND st.cod_ndg =
                            SUBSTR (
                               (SYS_CONTEXT ('userenv', 'client_info')),
                               6,
                               16)
                     AND st.cod_protocollo_delibera =
                            SUBSTR (
                               (SYS_CONTEXT ('userenv', 'client_info')),
                               22,
                               17)
                     AND pcr.cod_abi = ra.cod_abi(+)
                     AND pcr.cod_ndg = ra.cod_ndg(+)
                     AND pcr.cod_rapporto = ra.cod_rapporto(+)     -- 23 marzo
                     AND ra.flg_attiva(+) = '1')
            UNION
            (SELECT DISTINCT
                    NVL (pcr.cod_abi, s.cod_abi) AS cod_abi,
                    NVL (pcr.cod_ndg, s.cod_ndg) AS cod_ndg,
                    NULL AS dta_stima,
                    DECODE (s.cod_rapporto, NULL, 'Y', 'N')
                       AS new_rapp_da_val,
                    DECODE (pcr.cod_rapporto, NULL, 'Y', 'N') AS flg_estinto,
                    NULL AS cod_prot_delibera,
                    NVL (pcr.cod_rapporto, s.cod_rapporto) cod_rapporto,
                    pcr.cod_classe_ft AS cod_tipo_rapporto,
                    NULL AS cod_classe_ft,
                    pcr.cod_rapporto AS val_num_rapporto,
                    pcr.val_accordato_delib,
                    NULL AS dta_efficacia_ristr,
                    NULL AS dta_efficacia_add,
                    nat.cod_ftecnica,
                    nat.cod_ftecnica || ' ' || nat.desc_ftecnica
                       AS val_forma_tecnica,
                    DECODE (pcr.cod_classe_ft,
                            'CA', pcr.val_imp_utilizzato,
                            0)
                       AS val_utilizzato_lordo,
                    ---in pcr l'utilizzato ? gi¿ comprensivo di mora
                    DECODE (pcr.cod_classe_ft,
                            'FI', pcr.val_imp_utilizzato,
                            0)
                       AS val_utilizzato_firma,
                    DECODE (pcr.cod_classe_ft,
                            'ST', pcr.val_imp_utilizzato,
                            0)
                       AS val_utilizzato_sosti,
                    DECODE (pcr.cod_classe_ft,
                            'CA', pcr.val_imp_utilizzato,
                            -NVL (pcr.val_imp_mora, 0), 0)
                       AS val_utilizzato_netto,
                    NVL (pcr.val_imp_mora, 0) AS val_utilizzato_mora,
                    pcr.flg_tipo_dato AS cod_operat_rientro,
                    --8 MAGGIO
                    NULL AS flg_ristrutt,
                    NULL AS flg_recupero_tot,
                    NULL AS val_rettifica_livello_rapporto,
                    --MODIFICATO IL 13 MARZO PER CAMBIO LOGICA
                    NULL AS val_stima_di_rec, --MODIFICATO IL 13 MARZO PER CAMBIO LOGICA
                    'Y' AS flg_storico,
                    ---- 23 MAGGIO   : SI PUNTA COMUNQUE ALLO STORICO, AL MAX ? VUOTO
                    DECODE (nat.cod_natura,  '01', 'BR',  '02', 'MLT')
                       AS val_intervallo,
                    NULL AS val_rdv_rapp_operativi,
                    NULL AS val_rett_cassa_qta_cap,
                    NULL AS val_rdv_firma,
                    NULL AS val_rdv_pregr_cassa,
                    NULL AS val_rdv_pregr_firma,
                    ra.flg_fondo_terzi,
                    NULL AS cod_prot_pacchetto,
                    NULL AS val_percentuale,
                    NULL AS val_imp_prev_pregr,
                    NULL AS val_imp_rettifica_pregr,
                    NULL AS val_rdv_tot,
                    NULL AS val_imp_rettifica_att,
                    NULL AS dta_inizio_segnalazione_ristr,
                    --2 maggio
                    NULL AS dta_fine_segnalazione_ristr,
                    --2 maggio
                    NULL AS cod_protocollo_delibera,
                      NVL (pcr.val_imp_utilizzato, 0)
                    - (  (  (100 - ra.val_perc_fondo_terzi)
                          * NVL (pcr.val_imp_utilizzato, 0))
                       / 100)
                       AS fondo_terzi,
                    1 AS rn
               FROM (SELECT DISTINCT
                            p.cod_abi,
                            p.cod_ndg,
                            p.cod_rapporto,
                            cod_classe_ft,
                            -- f.cod_ftecnica,
                            DECODE (
                               (COUNT (
                                   DISTINCT p.cod_forma_tecnica)
                                OVER (
                                   PARTITION BY p.cod_abi,
                                                p.cod_ndg,
                                                p.cod_rapporto /*,                                                                                                                                                                                                                                                                                                                    f.cod_natura*/
                                                              )),
                               1, f.desc_ftecnica,
                               '-')
                               AS desc_ftecnica,
                            SUM (
                               val_imp_utilizzato)
                            OVER (
                               PARTITION BY p.cod_abi,
                                            p.cod_ndg,
                                            p.cod_rapporto)
                               AS val_imp_utilizzato,
                            SUM (
                               val_imp_mora)
                            OVER (
                               PARTITION BY i.cod_abi_cartolarizzato,
                                            i.cod_ndg,
                                            i.cod_rapporto)
                               AS val_imp_mora,
                            SUM (
                               val_accordato_delib)
                            OVER (
                               PARTITION BY p.cod_abi,
                                            p.cod_ndg,
                                            p.cod_rapporto)
                               AS val_accordato_delib,
                            DECODE (
                               (COUNT (
                                   DISTINCT p.cod_forma_tecnica) ----2 OTTOBRE: AGGIUNTA GESTIONE DOPPIA FT
                                OVER (
                                   PARTITION BY p.cod_abi,
                                                p.cod_ndg,
                                                p.cod_rapporto /*,                                                                                                                                                                                                                                                                                                                    f.cod_natura*/
                                                              )),
                               1, p.cod_forma_tecnica,
                               '-')
                               AS cod_ftecnica,
                            DECODE (f.cod_natura,
                                    '01', 'R',
                                    '02', 'S',
                                    'R')
                               flg_tipo_dato,
                            DECODE (f.cod_natura,  '01', 'BR',  '02', 'MLT')
                               val_intervallo
                       FROM t_mcrei_app_pcr_rapporti p,
                            t_mcre0_app_rate_daily i,
                            t_mcre0_app_natura_ftecnica f
                      WHERE     p.cod_abi = i.cod_abi_cartolarizzato(+)
                            AND p.cod_ndg = i.cod_ndg(+)
                            AND p.cod_rapporto = i.cod_rapporto(+)
                            AND p.cod_forma_tecnica = f.cod_ftecnica
                            AND p.val_imp_utilizzato > 0           --2 ottobre
                            AND p.cod_abi =
                                   SUBSTR (
                                      (SYS_CONTEXT ('userenv', 'client_info')),
                                      1,
                                      5)
                            AND p.cod_ndg =
                                   SUBSTR (
                                      (SYS_CONTEXT ('userenv', 'client_info')),
                                      6,
                                      16)) pcr,
                    t_mcrei_app_stime s,
                    t_mcre0_app_natura_ftecnica nat,
                    (SELECT DISTINCT cod_rapporto,
                                     cod_abi,
                                     cod_ndg,
                                     flg_attiva,
                                     flg_fondo_terzi,
                                     val_perc_fondo_terzi
                       FROM t_mcrei_app_rapporti) ra
              WHERE /*DA ESEGUIRE PRIMA DELLA CHIAMATA ALLA VISTA
                    BEGIN dbms_application_info.set_client_info( abi||ndg||cod_protocollo_delibera ); END;*/
                   pcr  .cod_abi =
                           SUBSTR ( (SYS_CONTEXT ('userenv', 'client_info')),
                                   1,
                                   5)
                    AND pcr.cod_ndg =
                           SUBSTR ( (SYS_CONTEXT ('userenv', 'client_info')),
                                   6,
                                   16)
                    AND s.cod_protocollo_delibera(+) =
                           SUBSTR ( (SYS_CONTEXT ('userenv', 'client_info')),
                                   22,
                                   17)
                    AND pcr.cod_abi = s.cod_abi(+)
                    AND pcr.cod_ndg = s.cod_ndg(+)
                    AND pcr.cod_rapporto = s.cod_rapporto(+)
                    AND pcr.cod_abi = ra.cod_abi(+)
                    AND pcr.cod_ndg = ra.cod_ndg(+)
                    AND pcr.cod_rapporto = ra.cod_rapporto(+)      -- 23 marzo
                    AND ra.flg_attiva(+) = '1'
                    AND pcr.cod_ftecnica = nat.cod_ftecnica(+)
                    AND s.cod_rapporto IS NULL))) dett,
          t_mcrei_app_rapporti_estero e
    WHERE     dett.rn = 1
          AND dett.cod_abi = e.cod_abi(+)
          AND dett.cod_ndg = e.cod_ndg(+)
          AND NVL (dett.cod_rapporto, dett.val_num_rapporto) =
                 e.cod_rapporto_estero(+);


GRANT DELETE, INSERT, REFERENCES, SELECT, UPDATE, ON COMMIT REFRESH, QUERY REWRITE, DEBUG, FLASHBACK, MERGE VIEW ON MCRE_OWN.V_MCREI_APP_DETT_RAPPORTI TO MCRE_USR;
