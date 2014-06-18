/* Formatted on 17/06/2014 18:11:45 (QP5 v5.227.12220.39754) */
CREATE OR REPLACE FORCE VIEW MCRE_OWN.V_MCRES_APP_STIME
(
   COD_ABI,
   COD_NDG,
   COD_RAPPORTO,
   VAL_IMP_SALDO_CAP_RAPPORTI,
   VAL_IMP_SALDO_INT_RAPPORTI,
   COD_ABI_CARTOLARIZZANTE,
   FLG_TIPO_DATO,
   COD_PROTOCOLLO_DELIBERA,
   COD_SNDG,
   DTA_STIMA,
   DESC_CAUSA_PREV_RECUPERO,
   FLG_RECUPERO_TOT,
   COD_UO_STIMA,
   VAL_IMP_PREV_PREGR,
   VAL_IMP_PREV_ATT,
   VAL_PREV_RECUPERO,
   VAL_ESPOSIZIONE,
   VAL_RDV_TOT,
   VAL_IMP_RETTIFICA_PREGR,
   VAL_IMP_RETTIFICA_ATT,
   COD_UTENTE,
   VAL_ATTUALIZZATO,
   FLG_PRES_PIANO,
   COD_TIPO_RAPPORTO,
   FLG_RISTRUTTURATO,
   VAL_UTILIZZATO_MORA,
   DTA_DECORRENZA_STATO,
   FLG_INVIO_DELIBERE_SISBA,
   DTA_RETTIFICA_INCAGLIO,
   FLG_ASTERISCO,
   FLG_INDICATORE,
   FLG_RAPP_FONDO_TERZO,
   VAL_PERC_RISCHIO_IST,
   DTA_UPD,
   DTA_CONFERMA,
   DTA_DELIBERA,
   DTA_CHIUSURA_RAPP,
   FLG_TIPO_RAPPORTO,
   FLG_PIANI_SCADUTI,
   DTA_ULTIMA_RATA
)
AS
   SELECT                        ------ VG 20130603 Aggiunta microtipologia PR
          -------AP 20131205  Aggiunto flg_tipo_rapporto
          -------VG 20140306 Data_ultima_rata
          -------VG 20140414 nvl flg_tipo-rapporto a X
          aa."COD_ABI",
          aa."COD_NDG",
          aa."COD_RAPPORTO",
          aa."VAL_IMP_SALDO_CAP_RAPPORTI",
          aa."VAL_IMP_SALDO_INT_RAPPORTI",
          aa."COD_ABI_CARTOLARIZZANTE",
          aa."FLG_TIPO_DATO",
          aa."COD_PROTOCOLLO_DELIBERA",
          aa."COD_SNDG",
          aa."DTA_STIMA",
          aa."DESC_CAUSA_PREV_RECUPERO",
          aa."FLG_RECUPERO_TOT",
          aa."COD_UO_STIMA",
          aa."VAL_IMP_PREV_PREGR",
          aa."VAL_IMP_PREV_ATT",
          aa."VAL_PREV_RECUPERO",
          aa."VAL_ESPOSIZIONE",
          aa."VAL_RDV_TOT",
          aa."VAL_IMP_RETTIFICA_PREGR",
          aa."VAL_IMP_RETTIFICA_ATT",
          aa."COD_UTENTE",
          aa."VAL_ATTUALIZZATO",
          aa."FLG_PRES_PIANO",
          aa."COD_TIPO_RAPPORTO",
          aa."FLG_RISTRUTTURATO",
          aa."VAL_UTILIZZATO_MORA",
          aa."DTA_DECORRENZA_STATO",
          aa."FLG_INVIO_DELIBERE_SISBA",
          aa."DTA_RETTIFICA_INCAGLIO",
          aa."FLG_ASTERISCO",
          aa."FLG_INDICATORE",
          aa."FLG_RAPP_FONDO_TERZO",
          aa."VAL_PERC_RISCHIO_IST",
          aa.dta_upd,
          de.dta_conferma,
          de.dta_delibera,
          dta_chiusura_rapp,
          NVL (aa.flg_tipo_Rapporto, 'X') flg_tipo_Rapporto,
          CASE WHEN TRUNC (SYSDATE) - dta_ultima_rata > 0 THEN 1 ELSE 0 END
             flg_piani_scaduti,
          dta_ultima_rata
     FROM (SELECT           --AG 20120928   aggiunte stime extra e stime batch
                  --AG 20121016   aggiunti campi esposizione capitale e quota interesse dai rapporti
                  --AG 20121024   aggiunto cod_abi_cartolarizzante
                  --AG 20121129   aggiunta join con piani di rietro per calcolo flag presenza piano (in precedenza era mappato sul campo T_MCREI_APP_STIME%.flg_pres_piano)
                  --VG 20121220   aggiunti fgl_indicatore e flg_piani_scaduti
                  --VG 20130325   aggiunta data conferma delibera
                  s.cod_abi,
                  s.cod_ndg,
                  s.cod_rapporto,
                  -r.val_imp_saldo_cap val_imp_saldo_cap_rapporti, -- esposizione capitale flusso rapporti
                  -r.val_imp_saldo_int val_imp_saldo_int_rapporti, -- quanta interessi flusso rapporti
                  r.cod_abi_cartolarizzante,
                  s.flg_tipo_dato,
                  s.cod_protocollo_delibera,
                  s.cod_sndg,
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
                  s.cod_utente,
                  s.val_attualizzato,
                  s.flg_pres_piano,
                  s.cod_tipo_rapporto,
                  --    s.cod_classe_ft,
                  s.flg_ristrutturato,
                  --    s.val_utilizzato_netto,
                  s.val_utilizzato_mora,
                  --    s.val_perc_rett_rapporto,
                  --    s.val_accordato,
                  --    s.cod_microtipologia_delibera,
                  --    s.cod_npe,
                  --    s.flg_tipo_rapporto,
                  --    s.cod_forma_tecnica,
                  --    s.dta_inizio_segnalazione_ristr,
                  --    s.dta_fine_segnalazione_ristr,
                  s.dta_decorrenza_stato,
                  i.flg_invio_delibere_sisba,
                  d.dta_conferma_delibera dta_rettifica_incaglio,
                  CASE
                     WHEN r.cod_ssa NOT IN ('MO', 'MI') THEN '*'
                     WHEN r.val_imp_gbv > 0 THEN '+'
                     WHEN r.flg_rapp_cartolarizzato = 'S' THEN 'C'
                  END
                     flg_asterisco,
                  CASE
                     WHEN     r.cod_ssa IN ('MO', 'MI')
                          AND (   SUBSTR (r.cod_rapporto, 6, 4) >= 9540
                               OR SUBSTR (r.cod_rapporto, 5, 4) <= 9550)
                     THEN
                        1
                     ELSE
                        0
                  END
                     flg_indicatore,
                  (SELECT MAX (DTA_SCADENZA_RATA) dta_ultima_rata
                     --flg_piani_scaduti
                     FROM T_MCREI_APP_PIANI_RIENTRO o
                    WHERE     o.cod_abi = r.cod_abi
                          AND o.cod_ndg = r.cod_ndg
                          AND o.cod_rapporto = R.COD_RAPPORTO
                          AND o.cod_protocollo_delibera =
                                 s.cod_protocollo_delibera)
                     dta_ultima_rata,
                  R.FLG_RAPP_FONDO_TERZO,
                  R.VAL_PERC_RISCHIO_IST,
                  s.dta_upd,
                  r.dta_chiusura_rapp,
                  s.flg_tipo_Rapporto
             FROM t_mcres_app_rapporti r,
                  t_mcres_app_istituti i,
                  (SELECT st.id_dper,
                          st.cod_abi,
                          st.cod_sndg,
                          st.cod_ndg,
                          st.cod_rapporto,
                          st.dta_stima,
                          st.desc_causa_prev_recupero,
                          st.flg_recupero_tot,
                          st.cod_uo_stima,
                          st.val_prev_recupero,
                          st.val_imp_prev_att,
                          st.val_imp_prev_pregr,
                          st.val_esposizione,
                          st.val_rdv_tot,
                          st.val_imp_rettifica_pregr,
                          st.val_imp_rettifica_att,
                          st.flg_tipo_dato,
                          st.cod_utente,
                          st.val_attualizzato,
                          NVL2 (pr.cod_rapporto, 1, NULL) flg_pres_piano,
                          st.cod_tipo_rapporto,
                          st.cod_protocollo_delibera,
                          st.dta_decorrenza_stato,
                          st.flg_ristrutturato,
                          st.val_utilizzato_mora,
                          st.dta_upd,
                          st.flg_tipo_Rapporto
                     FROM (SELECT id_dper,
                                  cod_abi,
                                  cod_sndg,
                                  cod_ndg,
                                  cod_rapporto,
                                  dta_stima,
                                  desc_causa_prev_recupero,
                                  flg_recupero_tot,
                                  cod_uo_stima,
                                  val_prev_recupero,
                                  val_imp_prev_att,
                                  val_imp_prev_pregr,
                                  val_esposizione,
                                  val_rdv_tot,
                                  val_imp_rettifica_pregr,
                                  val_imp_rettifica_att,
                                  flg_tipo_dato,
                                  cod_utente,
                                  val_attualizzato,
                                  flg_pres_piano,
                                  cod_tipo_rapporto,
                                  cod_protocollo_delibera,
                                  dta_decorrenza_stato,
                                  flg_ristrutturato,
                                  val_utilizzato_mora,
                                  dta_upd,
                                  flg_tipo_Rapporto
                             FROM t_mcrei_app_stime
                            WHERE     0 = 0
                                  AND flg_annullata = 0
                                  AND flg_attiva = '1'
                           UNION ALL
                           SELECT id_dper,
                                  cod_abi,
                                  cod_sndg,
                                  cod_ndg,
                                  cod_rapporto,
                                  dta_stima,
                                  desc_causa_prev_recupero,
                                  flg_recupero_tot,
                                  cod_uo_stima,
                                  val_prev_recupero,
                                  val_imp_prev_att,
                                  val_imp_prev_pregr,
                                  val_esposizione,
                                  val_rdv_tot,
                                  val_imp_rettifica_pregr,
                                  val_imp_rettifica_att,
                                  flg_tipo_dato,
                                  cod_utente,
                                  val_attualizzato,
                                  flg_pres_piano,
                                  cod_tipo_rapporto,
                                  cod_protocollo_delibera,
                                  dta_decorrenza_stato,
                                  flg_ristrutturato,
                                  val_utilizzato_mora,
                                  dta_upd,
                                  flg_tipo_Rapporto
                             FROM t_mcrei_app_stime_extra
                           UNION ALL
                           SELECT id_dper,
                                  cod_abi,
                                  cod_sndg,
                                  cod_ndg,
                                  cod_rapporto,
                                  dta_stima,
                                  desc_causa_prev_recupero,
                                  flg_recupero_tot,
                                  cod_uo_stima,
                                  val_prev_recupero,
                                  val_imp_prev_att,
                                  val_imp_prev_pregr,
                                  val_esposizione,
                                  val_rdv_tot,
                                  val_imp_rettifica_pregr,
                                  val_imp_rettifica_att,
                                  flg_tipo_dato,
                                  cod_utente,
                                  val_attualizzato,
                                  flg_pres_piano,
                                  cod_tipo_rapporto,
                                  cod_protocollo_delibera,
                                  dta_decorrenza_stato,
                                  flg_ristrutturato,
                                  val_utilizzato_mora,
                                  dta_upd,
                                  flg_tipo_Rapporto
                             FROM t_mcrei_app_stime_batch) st,
                          (SELECT cod_abi,
                                  cod_ndg,
                                  cod_rapporto,
                                  cod_protocollo_delibera,
                                  dta_stima
                             FROM t_mcrei_app_piani_rientro
                            WHERE     0 = 0
                                  AND flg_attiva = '1'
                                  AND flg_annullato = 0
                                  AND num_rata = 1) pr
                    WHERE     0 = 0
                          AND st.cod_abi = pr.cod_abi(+)
                          AND st.cod_ndg = pr.cod_ndg(+)
                          AND st.cod_rapporto = pr.cod_rapporto(+)
                          AND st.cod_protocollo_delibera =
                                 pr.cod_protocollo_delibera(+)
                          AND st.dta_stima = pr.dta_stima(+)) s,
                  (SELECT cod_abi,
                          cod_ndg,
                          val_rdv_qc_progressiva,
                          dta_conferma_delibera
                     FROM (SELECT ROW_NUMBER ()
                                  OVER (
                                     PARTITION BY cod_abi, cod_ndg
                                     ORDER BY
                                        dta_conferma_delibera DESC NULLS LAST)
                                     rn,
                                  d.*
                             FROM t_mcrei_app_delibere d
                            WHERE     0 = 0
                                  AND cod_fase_delibera = 'CO'
                                  AND cod_microtipologia_delib IN
                                         ('RV', 'T4', 'A0', 'IM', 'PR')
                                  AND dta_conferma_delibera IS NOT NULL
                                  AND val_rdv_qc_progressiva IS NOT NULL
                                  AND flg_attiva = '1')
                    WHERE rn = 1) d
            WHERE     0 = 0
                  AND s.cod_abi = r.cod_abi(+)
                  AND s.cod_ndg = r.cod_ndg(+)
                  AND s.cod_rapporto = r.cod_rapporto(+)
                  AND s.cod_abi = i.cod_abi(+)
                  AND s.cod_abi = d.cod_abi(+)
                  AND s.cod_ndg = d.cod_ndg(+)) aa,
          t_mcres_app_delibere de
    WHERE     aa.cod_abi = de.cod_abi(+)
          AND aa.cod_ndg = de.cod_ndg(+)
          AND aa.cod_protocollo_delibera = de.cod_protocollo_delibera(+)
          AND NVL (de.cod_stato_delibera, '-') != 'AN';


GRANT DELETE, INSERT, REFERENCES, SELECT, UPDATE, ON COMMIT REFRESH, QUERY REWRITE, DEBUG, FLASHBACK, MERGE VIEW ON MCRE_OWN.V_MCRES_APP_STIME TO MCRE_USR;
