/* Formatted on 17/06/2014 18:08:06 (QP5 v5.227.12220.39754) */
CREATE OR REPLACE FORCE VIEW MCRE_OWN.V_MCREI_APP_DETT_RAPPORTI_RIS
(
   COD_ABI,
   COD_NDG,
   COD_SNDG,
   COD_RAPPORTO,
   COD_FTECNICA,
   VAL_FORMA_TECNICA,
   FLG_RISTRUTT,
   VAL_UTILIZZATO_LORDO,
   VAL_UTILIZZATO_MORA,
   DTA_INIZIO_SEGNALAZIONE_RISTR,
   DTA_FINE_SEGNALAZIONE_RISTR,
   COD_OPERAT_RIENTRO,
   NEW_RAPP_DA_VAL,
   COD_TIPO_RAPPORTO,
   COD_PROT_DELIBERA,
   COD_PROT_PACCHETTO,
   COD_NPE,
   FLG_ESTINTO,
   LAST_FLG_RISTR,
   FLG_RAPP_CNF
)
AS
   SELECT DISTINCT
          COD_ABI,                         -- aggiunto campo cod_tipo_rapporto
          COD_NDG,
          COD_SNDG,
          COD_RAPPORTO,
          MAX (COD_FTECNICA)
             OVER (PARTITION BY COD_ABI, COD_NDG, COD_RAPPORTO)
             AS COD_FTECNICA,
          MAX (VAL_FORMA_TECNICA)
             OVER (PARTITION BY COD_ABI, COD_NDG, COD_RAPPORTO)
             AS VAL_FORMA_TECNICA,
          FLG_RISTRUTT,
          VAL_UTILIZZATO_LORDO,
          VAL_UTILIZZATO_MORA,
          MIN (DTA_INIZIO_SEGNALAZIONE_RISTR)
             OVER (PARTITION BY COD_ABI, COD_NDG, COD_RAPPORTO)
             DTA_INIZIO_SEGNALAZIONE_RISTR,
          MAX (DTA_FINE_SEGNALAZIONE_RISTR)
             OVER (PARTITION BY COD_ABI, COD_NDG, COD_RAPPORTO)
             DTA_FINE_SEGNALAZIONE_RISTR,
          COD_OPERAT_RIENTRO,
          NEW_RAPP_DA_VAL,
          COD_TIPO_RAPPORTO,
          COD_PROTOCOLLO_DELIBERA COD_PROT_DELIBERA,
          COD_PROTOCOLLO_PACCHETTO COD_PROT_PACCHETTO,
          COD_NPE,
          flg_estinto,
          last_flg_ristr,
          '1' FLG_RAPP_CNF
     FROM (   /*BEGIN dbms_application_info.set_client_info( abi||ndg); END;*/
            (SELECT DISTINCT
                    NVL (pcr.cod_abi, st.cod_abi) AS cod_abi,
                    NVL (pcr.cod_ndg, st.cod_ndg) AS cod_ndg,
                    NVL (PCR.COD_SNDG, ST.COD_SNDG) AS COD_SNDG,
                    DECODE (st.cod_rapporto, NULL, 'Y', 'N')
                       AS new_rapp_da_val,
                    DECODE (pcr.cod_rapporto, NULL, 'Y', 'N') AS flg_estinto,
                    st.cod_protocollo_delibera AS cod_prot_delibera,
                    NVL (pcr.cod_rapporto, st.cod_rapporto) cod_rapporto,
                    pcr.cod_classe_ft AS cod_tipo_rapporto,
                    st.cod_classe_ft,
                    st.dta_efficacia_ristr,
                    st.dta_efficacia_add,
                    nat.cod_ftecnica,
                    nat.cod_ftecnica || ' ' || nat.desc_ftecnica
                       AS val_forma_tecnica,
                    DECODE (
                       pcr.cod_classe_ft,
                       'CA', NVL (st.val_esposizione, pcr.val_imp_utilizzato),
                       0)
                       AS val_utilizzato_lordo,
                    ---in pcr l'utilizzato ? gi¿ comprensivo di mora
                    NVL (pcr.val_imp_mora, 0) AS val_utilizzato_mora,
                    NVL (
                       st.flg_tipo_dato,
                       DECODE (nat.cod_natura,  '01', 'R',  '02', 'S',  'R'))
                       AS cod_operat_rientro,
                    st.flg_ristrutturato AS flg_ristrutt,
                    'Y' AS flg_sTorico,
                    st.dta_inizio_segnalazione_ristr,
                    st.dta_fine_segnalazione_ristr,
                    st.cod_protocollo_delibera,
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
                                        st.cod_forma_tecnica
                           ORDER BY st.dta_stima DESC)))
                       rn,
                    COD_PROTOCOLLO_PACCHETTO,
                    cod_npe,
                    NVL (flg_ristrutturato, 'N') AS last_flg_ristr
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
                                     s.dta_fine_segnalazione_ristr,
                                     s.cod_forma_tecnica,
                                     d.dta_efficacia_ristr,
                                     d.dta_efficacia_add,
                                     D.cod_protocollo_pacchetto
                       FROM t_mcrei_app_stime s, --- DA CAMBIARE EVANTUALMENTE CON T_MCREI_HST_RAPP_RISTR
                                                T_MCREI_APP_DELIBERE D
                      --                                   t_mcrei_app_delibere D
                      WHERE     s.cod_abi = d.cod_abi
                            AND s.cod_ndg = d.cod_ndg
                            AND s.cod_protocollo_delibera =
                                   d.cod_protocollo_delibera
                            AND s.flg_attiva = 1
                            AND s.FLG_RISTRUTTURATO = 'Y'
                            AND s.cod_abi =
                                   SUBSTR (
                                      (SYS_CONTEXT ('userenv', 'client_info')),
                                      1,
                                      5)
                            AND s.cod_ndg =
                                   SUBSTR (
                                      (SYS_CONTEXT ('userenv', 'client_info')),
                                      6,
                                      16)) st,
                    (SELECT DISTINCT p.cod_abi,
                                     p.cod_ndg,
                                     P.COD_SNDG,
                                     p.cod_rapporto,
                                     cod_classe_ft,
                                     cod_forma_tecnica,
                                     NVL (i.val_imp_mora, 0) AS val_imp_mora,
                                     --f.cod_natura, --01= CASSA BT, 02= CASSA VMLT
                                     (p.val_imp_utilizzato),
                                     (p.val_accordato_delib)
                       FROM t_mcrei_app_pcr_rapporti p,
                            t_mcre0_app_rate_daily i,
                            t_mcre0_app_natura_ftecnica f
                      WHERE     p.cod_abi = i.cod_abi_cartolarizzato(+)
                            AND p.cod_ndg = i.cod_ndg(+)
                            AND p.cod_rapporto = i.cod_rapporto(+)
                            AND p.cod_forma_tecnica = f.cod_ftecnica) pcr,
                    t_mcre0_app_natura_ftecnica nat,
                    (SELECT DISTINCT cod_rapporto,
                                     cod_abi,
                                     cod_ndg,
                                     flg_attiva,
                                     flg_fondo_terzi,
                                     val_perc_fondo_terzi
                       FROM t_mcrei_app_rapporti) ra
              WHERE     st.cod_abi = pcr.cod_abi(+)
                    AND st.cod_ndg = pcr.cod_ndg(+)
                    AND st.cod_rapporto = pcr.cod_rapporto(+)
                    AND st.cod_forma_tecnica = nat.cod_ftecnica(+)
                    AND st.flg_attiva = '1'
                    AND st.cod_abi =
                           SUBSTR ( (SYS_CONTEXT ('userenv', 'client_info')),
                                   1,
                                   5)
                    AND st.cod_ndg =
                           SUBSTR ( (SYS_CONTEXT ('userenv', 'client_info')),
                                   6,
                                   16)
                    AND pcr.cod_abi = ra.cod_abi(+)
                    AND pcr.cod_ndg = ra.cod_ndg(+)
                    AND pcr.cod_rapporto = ra.cod_rapporto(+)
                    AND ra.flg_attiva(+) = '1')
           UNION
           (SELECT DISTINCT
                   NVL (pcr.cod_abi, s.cod_abi) AS cod_abi,
                   NVL (pcr.cod_ndg, s.cod_ndg) AS cod_ndg,
                   NVL (PCR.COD_SNDG, S.COD_SNDG) AS COD_SNDG,
                   DECODE (s.cod_rapporto, NULL, 'Y', 'N') AS new_rapp_da_val,
                   DECODE (pcr.cod_rapporto, NULL, 'Y', 'N') AS flg_estinto,
                   NULL AS cod_prot_delibera,
                   NVL (pcr.cod_rapporto, s.cod_rapporto) cod_rapporto,
                   pcr.cod_classe_ft AS cod_tipo_rapporto,
                   NULL AS cod_classe_ft,
                   NULL AS dta_efficacia_ristr,
                   NULL AS dta_efficacia_add,
                   nat.cod_ftecnica,
                   nat.cod_ftecnica || ' ' || nat.desc_ftecnica
                      AS val_forma_tecnica,
                   DECODE (pcr.cod_classe_ft,
                           'CA', pcr.val_imp_utilizzato,
                           0)
                      AS val_utilizzato_lordo,
                   NVL (pcr.val_imp_mora, 0) AS val_utilizzato_mora,
                   pcr.flg_tipo_dato AS cod_operat_rientro,
                   --8 MAGGIO
                   NULL AS flg_ristrutt,
                   'Y' AS flg_storico,
                   ---- 23 MAGGIO   : SI PUNTA COMUNQUE ALLO STORICO, AL MAX ? VUOTO
                   NULL AS dta_inizio_segnalazione_ristr,
                   NULL AS dta_fine_segnalazione_ristr,
                   NULL AS cod_protocollo_delibera,
                     NVL (pcr.val_imp_utilizzato, 0)
                   - (  (  (100 - ra.val_perc_fondo_terzi)
                         * NVL (pcr.val_imp_utilizzato, 0))
                      / 100)
                      AS fondo_terzi,
                   1 AS rn,
                   COD_PROTOCOLLO_PACCHETTO,
                   S.COD_NPE,
                   NVL (S.flg_ristrutturato, 'N') AS last_flg_ristr
              FROM (SELECT DISTINCT
                           p.cod_abi,
                           p.cod_ndg,
                           P.cod_sndg,
                           p.cod_rapporto,
                           cod_classe_ft,
                           f.cod_ftecnica,
                           f.desc_ftecnica,
                           DECODE (f.cod_natura,
                                   '01', 'R',
                                   '02', 'S',
                                   'R')
                              flg_tipo_dato,
                           DECODE (f.cod_natura,  '01', 'BR',  '02', 'MLT')
                              val_intervallo,
                           NVL (i.val_imp_mora, 0) AS val_imp_mora,
                           --f.cod_natura, --01= CASSA BT, 02= CASSA VMLT
                           (p.val_imp_utilizzato),
                           (p.val_accordato_delib),
                           TO_CHAR (NULL) COD_PROTOCOLLO_PACCHETTO
                      FROM t_mcrei_app_pcr_rapporti p,
                           t_mcre0_app_rate_daily i,
                           t_mcre0_app_natura_ftecnica f
                     WHERE     p.cod_abi = i.cod_abi_cartolarizzato(+)
                           AND p.cod_ndg = i.cod_ndg(+)
                           AND p.cod_rapporto = i.cod_rapporto(+)
                           AND p.cod_forma_tecnica = f.cod_ftecnica
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
                                    cod_sndg,
                                    flg_attiva,
                                    flg_fondo_terzi,
                                    val_perc_fondo_terzi
                      FROM t_mcrei_app_rapporti) ra
             WHERE     pcr.cod_abi =
                          SUBSTR ( (SYS_CONTEXT ('userenv', 'client_info')),
                                  1,
                                  5)
                   AND pcr.cod_ndg =
                          SUBSTR ( (SYS_CONTEXT ('userenv', 'client_info')),
                                  6,
                                  16)
                   AND pcr.cod_abi = s.cod_abi(+)
                   AND pcr.cod_ndg = s.cod_ndg(+)
                   AND pcr.cod_rapporto = s.cod_rapporto(+)
                   AND pcr.cod_abi = ra.cod_abi(+)
                   AND pcr.cod_ndg = ra.cod_ndg(+)
                   AND pcr.cod_rapporto = ra.cod_rapporto(+)
                   -- 23 marzo
                   AND ra.flg_attiva(+) = '1'
                   AND pcr.cod_ftecnica = nat.cod_ftecnica(+)
                   AND s.cod_rapporto IS NULL)) nn_est
    WHERE nn_est.flg_estinto = 'N';


GRANT DELETE, INSERT, REFERENCES, SELECT, UPDATE, ON COMMIT REFRESH, QUERY REWRITE, DEBUG, FLASHBACK, MERGE VIEW ON MCRE_OWN.V_MCREI_APP_DETT_RAPPORTI_RIS TO MCRE_USR;
