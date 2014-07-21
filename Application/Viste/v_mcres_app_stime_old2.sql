/* Formatted on 21/07/2014 18:43:17 (QP5 v5.227.12220.39754) */
CREATE OR REPLACE FORCE VIEW MCRE_OWN.V_MCRES_APP_STIME_OLD2
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
   FLG_ASTERISCO
)
AS
   SELECT                   --AG 20120928   aggiunte stime extra e stime batch
 --AG 20121016   aggiunti campi esposizione capitale e quota interesse dai rapporti
                              --AG 20121024   aggiunto cod_abi_cartolarizzante
         r.cod_abi,
         r.cod_ndg,
         r.cod_rapporto,
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
            flg_asterisco
    FROM t_mcres_app_rapporti r,
         t_mcres_app_istituti i,
         (SELECT id_dper,
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
                 val_utilizzato_mora
            FROM t_mcrei_app_stime
           WHERE 0 = 0 AND flg_annullata = 0 AND flg_attiva = '1'
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
                 val_utilizzato_mora
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
                 val_utilizzato_mora
            FROM t_mcrei_app_stime_batch) s,
         (SELECT cod_abi,
                 cod_ndg,
                 val_rdv_qc_progressiva,
                 dta_conferma_delibera
            FROM (SELECT ROW_NUMBER ()
                         OVER (PARTITION BY cod_abi, cod_ndg
                               ORDER BY dta_conferma_delibera DESC NULLS LAST)
                            rn,
                         d.*
                    FROM t_mcrei_app_delibere d
                   WHERE     0 = 0
                         AND cod_fase_delibera = 'CO'
                         AND cod_microtipologia_delib IN
                                ('RV', 'T4', 'A0', 'IM')
                         AND dta_conferma_delibera IS NOT NULL
                         AND val_rdv_qc_progressiva IS NOT NULL
                         AND flg_attiva = '1')
           WHERE rn = 1) d
   WHERE     0 = 0
         AND r.cod_abi = s.cod_abi(+)
         AND r.cod_ndg = s.cod_ndg(+)
         AND r.cod_rapporto = s.cod_rapporto(+)
         AND r.cod_abi = i.cod_abi(+)
         AND r.cod_abi = d.cod_abi(+)
         AND r.cod_ndg = d.cod_ndg(+);
