/* Formatted on 21/07/2014 18:35:02 (QP5 v5.227.12220.39754) */
CREATE OR REPLACE FORCE VIEW MCRE_OWN.V_MCRE0_APP_QDC_POSIZ_DELIB
(
   COD_MESE_HST,
   COD_ABI,
   COD_NDG,
   COD_PROTOCOLLO_DELIBERA,
   COD_STATO,
   DTA_DECORRENZA_STATO,
   COD_STRUTTURA_COMPETENTE,
   COD_COMPARTO,
   COD_ORGANO_DELIBERANTE,
   COD_PROCESSO,
   COD_MICROTIPOLOGIA_DELIB,
   DTA_CONFERMA_DELIBERA,
   VAL_NUM_PROGR_DELIBERA,
   COD_FASE_DELIBERA,
   VAL_ACCORDATO,
   VAL_ACCORDATO_CASSA,
   VAL_ACCORDATO_DERIVATI,
   VAL_ACCORDATO_FIRMA,
   VAL_ESP_FIRMA,
   VAL_ESP_LORDA,
   VAL_ESP_LORDA_CAPITALE,
   VAL_ESP_LORDA_MORA,
   VAL_ESP_NETTA_ANTE_DELIB,
   VAL_ESP_NETTA_POST_DELIB,
   VAL_ESP_TOT_CASSA,
   VAL_IMP_CREDITI_FIRMA,
   VAL_IMP_FONDI_TERZI,
   VAL_IMP_FONDI_TERZI_NB,
   VAL_IMP_OFFERTO,
   VAL_IMP_PERDITA,
   VAL_IMP_UTILIZZO,
   VAL_RDV_QC_PROGRESSIVA,
   VAL_RDV_PROGR_FI,
   VAL_UTI_CASSA_SCSB,
   VAL_UTI_FIRMA_SCSB,
   VAL_UTI_SOSTI_SCSB,
   VAL_UTI_TOT_SCSB,
   SCSB_UTI_CASSA,
   SCSB_UTI_FIRMA,
   SCSB_UTI_SOSTITUZIONI,
   SCSB_UTI_TOT,
   VAL_RDV_QC_DELIBERATA
)
AS
     SELECT se.cod_mese_hst, --è diventato o fine mese o 0 se delibere con fine validità nel mese (mod 03.2013)
            se.cod_abi_cartolarizzato,
            se.cod_ndg,
            d.cod_protocollo_delibera,
            se.cod_stato,
            se.dta_decorrenza_stato,
            se.cod_struttura_competente,
            NVL (
               CASE
                  WHEN TRIM (se.cod_comparto_assegnato) = '#' THEN NULL
                  ELSE TRIM (se.cod_comparto_assegnato)
               END,
               CASE
                  WHEN TRIM (se.cod_comparto_calcolato) = '#' THEN NULL
                  ELSE TRIM (se.cod_comparto_calcolato)
               END),
            d.cod_organo_deliberante,
            se.cod_processo,
            d.cod_microtipologia_delib,
            d.dta_conferma_delibera,
            d.val_num_progr_delibera,
            d.cod_fase_delibera,
            d.val_accordato,
            d.val_accordato_cassa,
            d.val_accordato_derivati,
            d.val_accordato_firma,
            d.val_esp_firma,
            d.val_esp_lorda,
            d.val_esp_lorda_capitale,
            d.val_esp_lorda_mora,
            d.val_esp_netta_ante_delib,
            d.val_esp_netta_post_delib,
            d.val_esp_tot_cassa,
            d.val_imp_crediti_firma,
            d.val_imp_fondi_terzi,
            d.val_imp_fondi_terzi_nb,
            d.val_imp_offerto,
            d.val_imp_perdita,
            d.val_imp_utilizzo,
            d.val_rdv_qc_progressiva,
            d.val_rdv_progr_fi,
            d.val_uti_cassa_scsb,
            d.val_uti_firma_scsb,
            d.val_uti_sosti_scsb,
            d.val_uti_tot_scsb,
            se.scsb_uti_cassa,
            se.scsb_uti_firma,
            se.scsb_uti_sostituzioni,
            se.scsb_uti_tot,
            d.val_rdv_qc_deliberata                              --mod 03.2013
       FROM (SELECT cod_mese_hst,                            --mod 03.2013 INI
                    cod_abi_cartolarizzato,
                    cod_ndg,
                    cod_stato,
                    dta_decorrenza_stato,
                    cod_struttura_competente,
                    cod_comparto_assegnato,
                    cod_comparto_calcolato,
                    cod_processo,
                    scsb_uti_cassa,
                    scsb_uti_firma,
                    scsb_uti_sostituzioni,
                    scsb_uti_tot
               FROM mcre_own.t_mcre0_app_storico_eventi
              WHERE     cod_mese_hst = SYS_CONTEXT ('userenv', 'client_info')
                    AND flg_cambio_mese = '1'
                    AND UPPER (cod_stato) IN ('IN', 'XS', 'RS')
             UNION
               SELECT cod_mese_hst,
                      cod_abi_cartolarizzato,
                      cod_ndg,
                      cod_stato,
                      dta_decorrenza_stato,
                      cod_struttura_competente,
                      cod_comparto_assegnato,
                      cod_comparto_calcolato,
                      cod_processo,
                      scsb_uti_cassa,
                      scsb_uti_firma,
                      scsb_uti_sostituzioni,
                      scsb_uti_tot
                 FROM (SELECT NVL (pos.cod_mese_hst, 0) cod_mese_hst,
                              pos.cod_abi_cartolarizzato,
                              pos.cod_ndg,
                              FIRST_VALUE (
                                 pos.cod_stato)
                              OVER (
                                 PARTITION BY pos.cod_abi_cartolarizzato,
                                              pos.cod_ndg
                                 ORDER BY pos.dta_fine_validita)
                                 cod_stato,
                              FIRST_VALUE (
                                 pos.dta_decorrenza_stato)
                              OVER (
                                 PARTITION BY pos.cod_abi_cartolarizzato,
                                              pos.cod_ndg
                                 ORDER BY pos.dta_fine_validita)
                                 dta_decorrenza_stato,
                              FIRST_VALUE (
                                 pos.cod_struttura_competente)
                              OVER (
                                 PARTITION BY pos.cod_abi_cartolarizzato,
                                              pos.cod_ndg
                                 ORDER BY pos.dta_fine_validita)
                                 cod_struttura_competente,
                              FIRST_VALUE (
                                 pos.cod_comparto_assegnato)
                              OVER (
                                 PARTITION BY pos.cod_abi_cartolarizzato,
                                              pos.cod_ndg
                                 ORDER BY pos.dta_fine_validita)
                                 cod_comparto_assegnato,
                              FIRST_VALUE (
                                 pos.cod_comparto_calcolato)
                              OVER (
                                 PARTITION BY pos.cod_abi_cartolarizzato,
                                              pos.cod_ndg
                                 ORDER BY pos.dta_fine_validita)
                                 cod_comparto_calcolato,
                              FIRST_VALUE (
                                 pos.cod_processo)
                              OVER (
                                 PARTITION BY pos.cod_abi_cartolarizzato,
                                              pos.cod_ndg
                                 ORDER BY pos.dta_fine_validita)
                                 cod_processo,
                              FIRST_VALUE (
                                 pos.scsb_uti_cassa)
                              OVER (
                                 PARTITION BY pos.cod_abi_cartolarizzato,
                                              pos.cod_ndg
                                 ORDER BY pos.dta_fine_validita)
                                 scsb_uti_cassa,
                              FIRST_VALUE (
                                 pos.scsb_uti_firma)
                              OVER (
                                 PARTITION BY pos.cod_abi_cartolarizzato,
                                              pos.cod_ndg
                                 ORDER BY pos.dta_fine_validita)
                                 scsb_uti_firma,
                              FIRST_VALUE (
                                 pos.scsb_uti_sostituzioni)
                              OVER (
                                 PARTITION BY pos.cod_abi_cartolarizzato,
                                              pos.cod_ndg
                                 ORDER BY pos.dta_fine_validita)
                                 scsb_uti_sostituzioni,
                              FIRST_VALUE (
                                 pos.scsb_uti_tot)
                              OVER (
                                 PARTITION BY pos.cod_abi_cartolarizzato,
                                              pos.cod_ndg
                                 ORDER BY pos.dta_fine_validita)
                                 scsb_uti_tot
                         FROM mcre_own.t_mcre0_app_storico_eventi pos,
                              (SELECT cod_abi_cartolarizzato, cod_ndg
                                 FROM mcre_own.t_mcre0_app_storico_eventi
                                WHERE     TRUNC (dta_fine_validita) BETWEEN TO_DATE (
                                                                               SUBSTR (
                                                                                  SYS_CONTEXT (
                                                                                     'userenv',
                                                                                     'client_info'),
                                                                                  1,
                                                                                  6),
                                                                               'YYYYMM')
                                                                        AND TO_DATE (
                                                                               SYS_CONTEXT (
                                                                                  'userenv',
                                                                                  'client_info'),
                                                                               'YYYYMMDD')
                                      AND NVL (cod_mese_hst, 0) = 0
                                      AND flg_cambio_stato = '1'
                                      AND UPPER (cod_stato) IN ('IN', 'XS', 'RS')
                               MINUS
                               SELECT cod_abi_cartolarizzato, cod_ndg
                                 FROM mcre_own.t_mcre0_app_storico_eventi
                                WHERE     cod_mese_hst =
                                             SYS_CONTEXT ('userenv',
                                                          'client_info')
                                      AND flg_cambio_mese = '1'
                                      AND UPPER (cod_stato) IN ('IN', 'XS', 'RS')) pre
                        WHERE     pos.cod_abi_cartolarizzato =
                                     pre.cod_abi_cartolarizzato
                              AND pos.cod_ndg = pre.cod_ndg
                              AND TRUNC (dta_fine_validita) BETWEEN TO_DATE (
                                                                       SUBSTR (
                                                                          SYS_CONTEXT (
                                                                             'userenv',
                                                                             'client_info'),
                                                                          1,
                                                                          6),
                                                                       'YYYYMM')
                                                                AND TO_DATE (
                                                                       SYS_CONTEXT (
                                                                          'userenv',
                                                                          'client_info'),
                                                                       'YYYYMMDD')
                              AND NVL (cod_mese_hst, 0) = 0
                              AND flg_cambio_stato = '1'
                              AND UPPER (cod_stato) IN ('IN', 'XS', 'RS'))
             GROUP BY cod_mese_hst,
                      cod_abi_cartolarizzato,
                      cod_ndg,
                      cod_stato,
                      dta_decorrenza_stato,
                      cod_struttura_competente,
                      cod_comparto_assegnato,
                      cod_comparto_calcolato,
                      cod_processo,
                      scsb_uti_cassa,
                      scsb_uti_firma,
                      scsb_uti_sostituzioni,
                      scsb_uti_tot) se,
            (  SELECT cod_abi,
                      cod_ndg,
                      cod_protocollo_delibera,
                      cod_organo_deliberante,
                      cod_microtipologia_delib,
                      dta_conferma_delibera,
                      val_num_progr_delibera,
                      cod_fase_delibera,
                      val_accordato,
                      val_accordato_cassa,
                      val_accordato_derivati,
                      val_accordato_firma,
                      val_esp_firma,
                      val_esp_lorda,
                      val_esp_lorda_capitale,
                      val_esp_lorda_mora,
                      val_esp_netta_ante_delib,
                      val_esp_netta_post_delib,
                      val_esp_tot_cassa,
                      val_imp_crediti_firma,
                      val_imp_fondi_terzi,
                      val_imp_fondi_terzi_nb,
                      val_imp_offerto,
                      val_imp_perdita,
                      val_imp_utilizzo,
                      val_rdv_qc_progressiva,
                      val_rdv_progr_fi,
                      val_uti_cassa_scsb,
                      val_uti_firma_scsb,
                      val_uti_sosti_scsb,
                      val_uti_tot_scsb,
                      val_rdv_qc_deliberata                      --mod 03.2013
                 FROM (SELECT cod_abi,
                              cod_ndg,
                              cod_protocollo_delibera,
                              FIRST_VALUE (
                                 cod_organo_deliberante)
                              OVER (
                                 PARTITION BY cod_abi,
                                              cod_ndg,
                                              cod_protocollo_delibera
                                 ORDER BY val_num_progr_delibera)
                                 cod_organo_deliberante,
                              FIRST_VALUE (
                                 cod_microtipologia_delib)
                              OVER (
                                 PARTITION BY cod_abi,
                                              cod_ndg,
                                              cod_protocollo_delibera
                                 ORDER BY val_num_progr_delibera)
                                 cod_microtipologia_delib,
                              FIRST_VALUE (
                                 dta_conferma_delibera)
                              OVER (
                                 PARTITION BY cod_abi,
                                              cod_ndg,
                                              cod_protocollo_delibera
                                 ORDER BY val_num_progr_delibera)
                                 dta_conferma_delibera,
                              FIRST_VALUE (
                                 val_num_progr_delibera)
                              OVER (
                                 PARTITION BY cod_abi,
                                              cod_ndg,
                                              cod_protocollo_delibera
                                 ORDER BY val_num_progr_delibera)
                                 val_num_progr_delibera,
                              FIRST_VALUE (
                                 cod_fase_delibera)
                              OVER (
                                 PARTITION BY cod_abi,
                                              cod_ndg,
                                              cod_protocollo_delibera
                                 ORDER BY val_num_progr_delibera)
                                 cod_fase_delibera,
                              FIRST_VALUE (
                                 val_accordato)
                              OVER (
                                 PARTITION BY cod_abi,
                                              cod_ndg,
                                              cod_protocollo_delibera
                                 ORDER BY val_num_progr_delibera)
                                 val_accordato,
                              FIRST_VALUE (
                                 val_accordato_cassa)
                              OVER (
                                 PARTITION BY cod_abi,
                                              cod_ndg,
                                              cod_protocollo_delibera
                                 ORDER BY val_num_progr_delibera)
                                 val_accordato_cassa,
                              FIRST_VALUE (
                                 val_accordato_derivati)
                              OVER (
                                 PARTITION BY cod_abi,
                                              cod_ndg,
                                              cod_protocollo_delibera
                                 ORDER BY val_num_progr_delibera)
                                 val_accordato_derivati,
                              FIRST_VALUE (
                                 val_accordato_firma)
                              OVER (
                                 PARTITION BY cod_abi,
                                              cod_ndg,
                                              cod_protocollo_delibera
                                 ORDER BY val_num_progr_delibera)
                                 val_accordato_firma,
                              FIRST_VALUE (
                                 val_esp_firma)
                              OVER (
                                 PARTITION BY cod_abi,
                                              cod_ndg,
                                              cod_protocollo_delibera
                                 ORDER BY val_num_progr_delibera)
                                 val_esp_firma,
                              FIRST_VALUE (
                                 val_esp_lorda)
                              OVER (
                                 PARTITION BY cod_abi,
                                              cod_ndg,
                                              cod_protocollo_delibera
                                 ORDER BY val_num_progr_delibera)
                                 val_esp_lorda,
                              FIRST_VALUE (
                                 val_esp_lorda_capitale)
                              OVER (
                                 PARTITION BY cod_abi,
                                              cod_ndg,
                                              cod_protocollo_delibera
                                 ORDER BY val_num_progr_delibera)
                                 val_esp_lorda_capitale,
                              FIRST_VALUE (
                                 val_esp_lorda_mora)
                              OVER (
                                 PARTITION BY cod_abi,
                                              cod_ndg,
                                              cod_protocollo_delibera
                                 ORDER BY val_num_progr_delibera)
                                 val_esp_lorda_mora,
                              FIRST_VALUE (
                                 val_esp_netta_ante_delib)
                              OVER (
                                 PARTITION BY cod_abi,
                                              cod_ndg,
                                              cod_protocollo_delibera
                                 ORDER BY val_num_progr_delibera)
                                 val_esp_netta_ante_delib,
                              FIRST_VALUE (
                                 val_esp_netta_post_delib)
                              OVER (
                                 PARTITION BY cod_abi,
                                              cod_ndg,
                                              cod_protocollo_delibera
                                 ORDER BY val_num_progr_delibera)
                                 val_esp_netta_post_delib,
                              FIRST_VALUE (
                                 val_esp_tot_cassa)
                              OVER (
                                 PARTITION BY cod_abi,
                                              cod_ndg,
                                              cod_protocollo_delibera
                                 ORDER BY val_num_progr_delibera)
                                 val_esp_tot_cassa,
                              FIRST_VALUE (
                                 val_imp_crediti_firma)
                              OVER (
                                 PARTITION BY cod_abi,
                                              cod_ndg,
                                              cod_protocollo_delibera
                                 ORDER BY val_num_progr_delibera)
                                 val_imp_crediti_firma,
                              FIRST_VALUE (
                                 val_imp_fondi_terzi)
                              OVER (
                                 PARTITION BY cod_abi,
                                              cod_ndg,
                                              cod_protocollo_delibera
                                 ORDER BY val_num_progr_delibera)
                                 val_imp_fondi_terzi,
                              FIRST_VALUE (
                                 val_imp_fondi_terzi_nb)
                              OVER (
                                 PARTITION BY cod_abi,
                                              cod_ndg,
                                              cod_protocollo_delibera
                                 ORDER BY val_num_progr_delibera)
                                 val_imp_fondi_terzi_nb,
                              FIRST_VALUE (
                                 val_imp_offerto)
                              OVER (
                                 PARTITION BY cod_abi,
                                              cod_ndg,
                                              cod_protocollo_delibera
                                 ORDER BY val_num_progr_delibera)
                                 val_imp_offerto,
                              FIRST_VALUE (
                                 val_imp_perdita)
                              OVER (
                                 PARTITION BY cod_abi,
                                              cod_ndg,
                                              cod_protocollo_delibera
                                 ORDER BY val_num_progr_delibera)
                                 val_imp_perdita,
                              FIRST_VALUE (
                                 val_imp_utilizzo)
                              OVER (
                                 PARTITION BY cod_abi,
                                              cod_ndg,
                                              cod_protocollo_delibera
                                 ORDER BY val_num_progr_delibera)
                                 val_imp_utilizzo,
                              FIRST_VALUE (
                                 val_rdv_qc_deliberata)
                              OVER (
                                 PARTITION BY cod_abi,
                                              cod_ndg,
                                              cod_protocollo_delibera
                                 ORDER BY val_num_progr_delibera)
                                 val_rdv_qc_deliberata,
                              FIRST_VALUE (
                                 val_rdv_qc_progressiva)
                              OVER (
                                 PARTITION BY cod_abi,
                                              cod_ndg,
                                              cod_protocollo_delibera
                                 ORDER BY val_num_progr_delibera)
                                 val_rdv_qc_progressiva,
                              FIRST_VALUE (
                                 val_rdv_progr_fi)
                              OVER (
                                 PARTITION BY cod_abi,
                                              cod_ndg,
                                              cod_protocollo_delibera
                                 ORDER BY val_num_progr_delibera)
                                 val_rdv_progr_fi,
                              FIRST_VALUE (
                                 val_uti_cassa_scsb)
                              OVER (
                                 PARTITION BY cod_abi,
                                              cod_ndg,
                                              cod_protocollo_delibera
                                 ORDER BY val_num_progr_delibera)
                                 val_uti_cassa_scsb,
                              FIRST_VALUE (
                                 val_uti_firma_scsb)
                              OVER (
                                 PARTITION BY cod_abi,
                                              cod_ndg,
                                              cod_protocollo_delibera
                                 ORDER BY val_num_progr_delibera)
                                 val_uti_firma_scsb,
                              FIRST_VALUE (
                                 val_uti_sosti_scsb)
                              OVER (
                                 PARTITION BY cod_abi,
                                              cod_ndg,
                                              cod_protocollo_delibera
                                 ORDER BY val_num_progr_delibera)
                                 val_uti_sosti_scsb,
                              FIRST_VALUE (
                                 val_uti_tot_scsb)
                              OVER (
                                 PARTITION BY cod_abi,
                                              cod_ndg,
                                              cod_protocollo_delibera
                                 ORDER BY val_num_progr_delibera)
                                 val_uti_tot_scsb
                         FROM (SELECT cod_abi,
                                      cod_ndg,
                                      cod_protocollo_delibera,
                                      cod_organo_deliberante,
                                      cod_microtipologia_delib,
                                      dta_conferma_delibera,
                                      val_num_progr_delibera,
                                      cod_fase_delibera,
                                      NVL (val_accordato, 0) val_accordato,
                                      NVL (val_accordato_cassa, 0)
                                         val_accordato_cassa,
                                      NVL (val_accordato_derivati, 0)
                                         val_accordato_derivati,
                                      NVL (val_accordato_firma, 0)
                                         val_accordato_firma,
                                      NVL (val_esp_firma, 0) val_esp_firma,
                                      NVL (val_esp_lorda, 0) val_esp_lorda,
                                      NVL (val_esp_lorda_capitale, 0)
                                         val_esp_lorda_capitale,
                                      NVL (val_esp_lorda_mora, 0)
                                         val_esp_lorda_mora,
                                      NVL (val_esp_netta_ante_delib, 0)
                                         val_esp_netta_ante_delib,
                                      NVL (val_esp_netta_post_delib, 0)
                                         val_esp_netta_post_delib,
                                      NVL (val_esp_tot_cassa, 0)
                                         val_esp_tot_cassa,
                                      NVL (val_imp_crediti_firma, 0)
                                         val_imp_crediti_firma,
                                      NVL (val_imp_fondi_terzi, 0)
                                         val_imp_fondi_terzi,
                                      NVL (val_imp_fondi_terzi_nb, 0)
                                         val_imp_fondi_terzi_nb,
                                      NVL (val_imp_offerto, 0) val_imp_offerto,
                                      NVL (val_imp_perdita, 0) val_imp_perdita,
                                      NVL (val_imp_utilizzo, 0) val_imp_utilizzo,
                                      NVL (val_rdv_qc_deliberata, 0)
                                         val_rdv_qc_deliberata,  --mod 03.2013
                                      NVL (val_rdv_qc_progressiva, 0)
                                         val_rdv_qc_progressiva,
                                      NVL (val_rdv_progr_fi, 0) val_rdv_progr_fi,
                                      NVL (val_uti_cassa_scsb, 0)
                                         val_uti_cassa_scsb,
                                      NVL (val_uti_firma_scsb, 0)
                                         val_uti_firma_scsb,
                                      NVL (val_uti_sosti_scsb, 0)
                                         val_uti_sosti_scsb,
                                      NVL (val_uti_tot_scsb, 0) val_uti_tot_scsb
                                 FROM mcre_own.t_mcrei_app_delibere
                                --WHERE dta_conferma_delibera between TO_DATE(SUBSTR(SYS_CONTEXT ('userenv', 'client_info'),1,6),'YYYYMM')  and TO_DATE (SYS_CONTEXT ('userenv', 'client_info'),'YYYYMMDD') --mod 04.2013
                                WHERE     dta_conferma_delibera <=
                                             TO_DATE (
                                                SYS_CONTEXT ('userenv',
                                                             'client_info'),
                                                'YYYYMMDD')      --mod 04.2013
                                      AND flg_attiva = '1'
                                      AND cod_fase_delibera NOT IN
                                             ('AN', 'IN', 'CM')
                                      AND cod_fase_pacchetto = 'ULT'
                                      AND flg_no_delibera = 0
                               UNION
                               SELECT cod_abi,
                                      cod_ndg,
                                      cod_protocollo_delibera,
                                      cod_organo_deliberante,
                                      cod_microtipologia_delib,
                                      dta_conferma_delibera,
                                      val_num_progr_delibera,
                                      cod_fase_delibera,
                                      NVL (val_accordato, 0) val_accordato,
                                      NVL (val_accordato_cassa, 0)
                                         val_accordato_cassa,
                                      NVL (val_accordato_derivati, 0)
                                         val_accordato_derivati,
                                      NVL (val_accordato_firma, 0)
                                         val_accordato_firma,
                                      NVL (val_esp_firma, 0) val_esp_firma,
                                      NVL (val_esp_lorda, 0) val_esp_lorda,
                                      NVL (val_esp_lorda_capitale, 0)
                                         val_esp_lorda_capitale,
                                      NVL (val_esp_lorda_mora, 0)
                                         val_esp_lorda_mora,
                                      NVL (val_esp_netta_ante_delib, 0)
                                         val_esp_netta_ante_delib,
                                      NVL (val_esp_netta_post_delib, 0)
                                         val_esp_netta_post_delib,
                                      NVL (val_esp_tot_cassa, 0)
                                         val_esp_tot_cassa,
                                      NVL (val_imp_crediti_firma, 0)
                                         val_imp_crediti_firma,
                                      NVL (val_imp_fondi_terzi, 0)
                                         val_imp_fondi_terzi,
                                      NVL (val_imp_fondi_terzi_nb, 0)
                                         val_imp_fondi_terzi_nb,
                                      NVL (val_imp_offerto, 0) val_imp_offerto,
                                      NVL (val_imp_perdita, 0) val_imp_perdita,
                                      NVL (val_imp_utilizzo, 0) val_imp_utilizzo,
                                      NVL (val_rdv_qc_deliberata, 0)
                                         val_rdv_qc_deliberata,  --mod 03.2013
                                      NVL (val_rdv_qc_progressiva, 0)
                                         val_rdv_qc_progressiva,
                                      NVL (val_rdv_progr_fi, 0) val_rdv_progr_fi,
                                      NVL (val_uti_cassa_scsb, 0)
                                         val_uti_cassa_scsb,
                                      NVL (val_uti_firma_scsb, 0)
                                         val_uti_firma_scsb,
                                      NVL (val_uti_sosti_scsb, 0)
                                         val_uti_sosti_scsb,
                                      NVL (val_uti_tot_scsb, 0) val_uti_tot_scsb
                                 FROM mcre_own.t_mcrei_hst_delibere
                                --WHERE dta_conferma_delibera between TO_DATE(SUBSTR(SYS_CONTEXT ('userenv', 'client_info'),1,6),'YYYYMM')  and TO_DATE (SYS_CONTEXT ('userenv', 'client_info'),'YYYYMMDD') --mod 04.2013
                                WHERE     dta_conferma_delibera <=
                                             TO_DATE (
                                                SYS_CONTEXT ('userenv',
                                                             'client_info'),
                                                'YYYYMMDD')      --mod 04.2013
                                      AND cod_fase_delibera NOT IN
                                             ('AN', 'IN', 'CM')
                                      AND cod_fase_pacchetto = 'ULT'
                                      AND flg_no_delibera = 0))
             GROUP BY cod_abi,
                      cod_ndg,
                      cod_protocollo_delibera,
                      cod_organo_deliberante,
                      cod_microtipologia_delib,
                      dta_conferma_delibera,
                      val_num_progr_delibera,
                      cod_fase_delibera,
                      val_accordato,
                      val_accordato_cassa,
                      val_accordato_derivati,
                      val_accordato_firma,
                      val_esp_firma,
                      val_esp_lorda,
                      val_esp_lorda_capitale,
                      val_esp_lorda_mora,
                      val_esp_netta_ante_delib,
                      val_esp_netta_post_delib,
                      val_esp_tot_cassa,
                      val_imp_crediti_firma,
                      val_imp_fondi_terzi,
                      val_imp_fondi_terzi_nb,
                      val_imp_offerto,
                      val_imp_perdita,
                      val_imp_utilizzo,
                      val_rdv_qc_deliberata,
                      val_rdv_qc_progressiva,
                      val_rdv_progr_fi,
                      val_uti_cassa_scsb,
                      val_uti_firma_scsb,
                      val_uti_sosti_scsb,
                      val_uti_tot_scsb) d                    --mod 03.2013 FIN
      WHERE     se.cod_abi_cartolarizzato = d.cod_abi(+)
            AND se.cod_ndg = d.cod_ndg(+)
   GROUP BY se.cod_mese_hst,
            se.cod_abi_cartolarizzato,
            se.cod_ndg,
            d.cod_protocollo_delibera,
            se.cod_stato,
            se.dta_decorrenza_stato,
            se.cod_struttura_competente,
            NVL (
               CASE
                  WHEN TRIM (se.cod_comparto_assegnato) = '#' THEN NULL
                  ELSE TRIM (se.cod_comparto_assegnato)
               END,
               CASE
                  WHEN TRIM (se.cod_comparto_calcolato) = '#' THEN NULL
                  ELSE TRIM (se.cod_comparto_calcolato)
               END),
            d.cod_organo_deliberante,
            se.cod_processo,
            d.cod_microtipologia_delib,
            d.dta_conferma_delibera,
            d.val_num_progr_delibera,
            d.cod_fase_delibera,
            d.val_accordato,
            d.val_accordato_cassa,
            d.val_accordato_derivati,
            d.val_accordato_firma,
            d.val_esp_firma,
            d.val_esp_lorda,
            d.val_esp_lorda_capitale,
            d.val_esp_lorda_mora,
            d.val_esp_netta_ante_delib,
            d.val_esp_netta_post_delib,
            d.val_esp_tot_cassa,
            d.val_imp_crediti_firma,
            d.val_imp_fondi_terzi,
            d.val_imp_fondi_terzi_nb,
            d.val_imp_offerto,
            d.val_imp_perdita,
            d.val_imp_utilizzo,
            d.val_rdv_qc_deliberata,
            d.val_rdv_qc_progressiva,
            d.val_rdv_progr_fi,
            d.val_uti_cassa_scsb,
            d.val_uti_firma_scsb,
            d.val_uti_sosti_scsb,
            d.val_uti_tot_scsb,
            se.scsb_uti_cassa,
            se.scsb_uti_firma,
            se.scsb_uti_sostituzioni,
            se.scsb_uti_tot;
