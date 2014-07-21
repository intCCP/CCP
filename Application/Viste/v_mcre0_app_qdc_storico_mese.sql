/* Formatted on 21/07/2014 18:35:04 (QP5 v5.227.12220.39754) */
CREATE OR REPLACE FORCE VIEW MCRE_OWN.V_MCRE0_APP_QDC_STORICO_MESE
(
   ID_DPER,
   RECORD_CHAR
)
AS
   SELECT SUBSTR (TO_CHAR (cod_mese_hst), 1, 6),
             RPAD (NVL (TRIM (cod_abi_istituto), ' '), 5, ' ')
          || RPAD (NVL (TRIM (ev.cod_abi_cartolarizzato), ' '), 5, ' ')
          || RPAD (NVL (TRIM (ev.cod_ndg), ' '), 16, ' ')
          || RPAD (NVL (TRIM (cod_sndg), ' '), 16, ' ')
          || RPAD (NVL (TRIM (TO_CHAR (dta_ini_validita, 'yyyymmdd')), ' '),
                   8,
                   ' ')
          || RPAD (NVL (TRIM (TO_CHAR (dta_fine_validita, 'yyyymmdd')), ' '),
                   8,
                   ' ')
          || RPAD (NVL (TRIM (flg_cambio_stato), ' '), 1, ' ')
          || RPAD (NVL (TRIM (flg_cambio_gestore), ' '), 1, ' ')
          || RPAD (NVL (TRIM (flg_cambio_comparto), ' '), 1, ' ')
          || RPAD (NVL (TRIM (flg_cambio_mese), ' '), 1, ' ')
          || RPAD (NVL (TRIM (desc_nome_controparte), ' '), 64, ' ')
          || RPAD (NVL (TRIM (cod_gruppo_legame), ' '), 18, ' ')
          || RPAD (NVL (TRIM (cod_gruppo_economico), ' '), 8, ' ')
          || RPAD (NVL (TRIM (cod_gruppo_super), ' '), 20, ' ')
          || RPAD (
                NVL (TRIM (TO_CHAR (dta_intercettamento, 'yyyymmdd')), ' '),
                8,
                ' ')
          || RPAD (NVL (TRIM (cod_filiale), ' '), 5, ' ')
          || RPAD (NVL (TRIM (cod_struttura_competente), ' '), 5, ' ')
          || RPAD (NVL (TRIM (cod_ramo_host), ' '), 6, ' ')
          || RPAD (NVL (TRIM (cod_comparto_host), ' '), 6, ' ')
          || RPAD (NVL (TRIM (cod_comparto_calcolato_pre), ' '), 6, ' ')
          || RPAD (NVL (TRIM (cod_comparto_calcolato), ' '), 6, ' ')
          || RPAD (NVL (TRIM (cod_comparto_assegnato), ' '), 6, ' ')
          || RPAD (NVL (TRIM (TO_CHAR (cod_percorso)), ' '), 3, ' ')
          || RPAD (NVL (TRIM (cod_processo), ' '), 2, ' ')
          || RPAD (NVL (TRIM (cod_stato), ' '), 2, ' ')
          || RPAD (
                NVL (TRIM (TO_CHAR (dta_decorrenza_stato, 'yyyymmdd')), ' '),
                8,
                ' ')
          || RPAD (
                NVL (TRIM (TO_CHAR (dta_scadenza_stato, 'yyyymmdd')), ' '),
                8,
                ' ')
          || RPAD (NVL (TRIM (cod_stato_precedente), ' '), 2, ' ')
          || RPAD (NVL (TRIM (cod_tipo_ingresso), ' '), 1, ' ')
          || RPAD (NVL (TRIM (id_transizione), ' '), 1, ' ')
          || RPAD (NVL (TRIM (TO_CHAR (dta_processo, 'yyyymmdd')), ' '),
                   8,
                   ' ')
          || RPAD (NVL (TRIM (TO_CHAR (id_referente)), ' '), 20, ' ')
          || RPAD (NVL (TRIM (TO_CHAR (ev.id_utente)), ' '), 20, ' ')
          || RPAD (NVL (TRIM (TO_CHAR (id_utente_pre)), ' '), 20, ' ')
          || RPAD (NVL (TRIM (TO_CHAR (dta_ini_utente, 'yyyymmdd')), ' '),
                   8,
                   ' ')
          || RPAD (NVL (TRIM (TO_CHAR (dta_fine_utente, 'yyyymmdd')), ' '),
                   8,
                   ' ')
          || RPAD (NVL (TRIM (TO_CHAR (flg_somma)), ' '), 1, ' ')
          || RPAD (NVL (TRIM (flg_riportafogliato), ' '), 1, ' ')
          || RPAD (NVL (TRIM (flg_gruppo_economico), ' '), 1, ' ')
          || RPAD (NVL (TRIM (flg_gruppo_legame), ' '), 1, ' ')
          || RPAD (NVL (TRIM (flg_singolo), ' '), 1, ' ')
          || RPAD (NVL (TRIM (flg_condiviso), ' '), 1, ' ')
          || RPAD (NVL (TRIM (cod_operatore_ins_upd), ' '), 20, ' ')
          || RPAD (NVL (TRIM (TO_CHAR (scsb_uti_cassa)), ' '), 20, ' ')
          || RPAD (NVL (TRIM (TO_CHAR (scsb_uti_firma)), ' '), 20, ' ')
          || RPAD (NVL (TRIM (TO_CHAR (scsb_acc_cassa)), ' '), 20, ' ')
          || RPAD (NVL (TRIM (TO_CHAR (scsb_acc_firma)), ' '), 20, ' ')
          || RPAD (NVL (TRIM (TO_CHAR (scsb_uti_cassa_bt)), ' '), 20, ' ')
          || RPAD (NVL (TRIM (TO_CHAR (scsb_uti_cassa_mlt)), ' '), 20, ' ')
          || RPAD (NVL (TRIM (TO_CHAR (scsb_uti_smobilizzo)), ' '), 20, ' ')
          || RPAD (NVL (TRIM (TO_CHAR (scsb_uti_firma_dt)), ' '), 20, ' ')
          || RPAD (NVL (TRIM (TO_CHAR (scsb_acc_cassa_bt)), ' '), 20, ' ')
          || RPAD (NVL (TRIM (TO_CHAR (scsb_acc_cassa_mlt)), ' '), 20, ' ')
          || RPAD (NVL (TRIM (TO_CHAR (scsb_acc_smobilizzo)), ' '), 20, ' ')
          || RPAD (NVL (TRIM (TO_CHAR (scsb_acc_firma_dt)), ' '), 20, ' ')
          || RPAD (NVL (TRIM (TO_CHAR (scsb_tot_gar)), ' '), 20, ' ')
          || RPAD (NVL (TRIM (TO_CHAR (scsb_uti_tot)), ' '), 20, ' ')
          || RPAD (NVL (TRIM (TO_CHAR (scsb_acc_tot)), ' '), 20, ' ')
          || RPAD (
                NVL (TRIM (TO_CHAR (scsb_dta_riferimento, 'yyyymmdd')), ' '),
                8,
                ' ')
          || RPAD (NVL (TRIM (TO_CHAR (gesb_uti_cassa)), ' '), 20, ' ')
          || RPAD (NVL (TRIM (TO_CHAR (gesb_uti_firma)), ' '), 20, ' ')
          || RPAD (NVL (TRIM (TO_CHAR (gesb_acc_cassa)), ' '), 20, ' ')
          || RPAD (NVL (TRIM (TO_CHAR (gesb_acc_firma)), ' '), 20, ' ')
          || RPAD (NVL (TRIM (TO_CHAR (gesb_uti_cassa_bt)), ' '), 20, ' ')
          || RPAD (NVL (TRIM (TO_CHAR (gesb_uti_cassa_mlt)), ' '), 20, ' ')
          || RPAD (NVL (TRIM (TO_CHAR (gesb_uti_smobilizzo)), ' '), 20, ' ')
          || RPAD (NVL (TRIM (TO_CHAR (gesb_uti_firma_dt)), ' '), 20, ' ')
          || RPAD (NVL (TRIM (TO_CHAR (gesb_acc_cassa_bt)), ' '), 20, ' ')
          || RPAD (NVL (TRIM (TO_CHAR (gesb_acc_cassa_mlt)), ' '), 20, ' ')
          || RPAD (NVL (TRIM (TO_CHAR (gesb_acc_smobilizzo)), ' '), 20, ' ')
          || RPAD (NVL (TRIM (TO_CHAR (gesb_acc_firma_dt)), ' '), 20, ' ')
          || RPAD (NVL (TRIM (TO_CHAR (gesb_tot_gar)), ' '), 20, ' ')
          || RPAD (
                NVL (TRIM (TO_CHAR (gesb_dta_riferimento, 'yyyymmdd')), ' '),
                8,
                ' ')
          || RPAD (NVL (TRIM (TO_CHAR (scgb_uti_cassa)), ' '), 20, ' ')
          || RPAD (NVL (TRIM (TO_CHAR (scgb_uti_firma)), ' '), 20, ' ')
          || RPAD (NVL (TRIM (TO_CHAR (scgb_acc_cassa)), ' '), 20, ' ')
          || RPAD (NVL (TRIM (TO_CHAR (scgb_acc_firma)), ' '), 20, ' ')
          || RPAD (NVL (TRIM (TO_CHAR (scgb_uti_cassa_bt)), ' '), 20, ' ')
          || RPAD (NVL (TRIM (TO_CHAR (scgb_uti_cassa_mlt)), ' '), 20, ' ')
          || RPAD (NVL (TRIM (TO_CHAR (scgb_uti_smobilizzo)), ' '), 20, ' ')
          || RPAD (NVL (TRIM (TO_CHAR (scgb_uti_firma_dt)), ' '), 20, ' ')
          || RPAD (NVL (TRIM (TO_CHAR (scgb_acc_cassa_bt)), ' '), 20, ' ')
          || RPAD (NVL (TRIM (TO_CHAR (scgb_acc_cassa_mlt)), ' '), 20, ' ')
          || RPAD (NVL (TRIM (TO_CHAR (scgb_acc_smobilizzo)), ' '), 20, ' ')
          || RPAD (NVL (TRIM (TO_CHAR (scgb_acc_firma_dt)), ' '), 20, ' ')
          || RPAD (NVL (TRIM (TO_CHAR (scgb_tot_gar)), ' '), 20, ' ')
          || RPAD (NVL (TRIM (TO_CHAR (gegb_uti_cassa)), ' '), 20, ' ')
          || RPAD (NVL (TRIM (TO_CHAR (gegb_uti_firma)), ' '), 20, ' ')
          || RPAD (NVL (TRIM (TO_CHAR (gegb_acc_cassa)), ' '), 20, ' ')
          || RPAD (NVL (TRIM (TO_CHAR (gegb_acc_firma)), ' '), 20, ' ')
          || RPAD (NVL (TRIM (TO_CHAR (gegb_uti_cassa_bt)), ' '), 20, ' ')
          || RPAD (NVL (TRIM (TO_CHAR (gegb_uti_cassa_mlt)), ' '), 20, ' ')
          || RPAD (NVL (TRIM (TO_CHAR (gegb_uti_smobilizzo)), ' '), 20, ' ')
          || RPAD (NVL (TRIM (TO_CHAR (gegb_uti_firma_dt)), ' '), 20, ' ')
          || RPAD (NVL (TRIM (TO_CHAR (gegb_acc_cassa_bt)), ' '), 20, ' ')
          || RPAD (NVL (TRIM (TO_CHAR (gegb_acc_cassa_mlt)), ' '), 20, ' ')
          || RPAD (NVL (TRIM (TO_CHAR (gegb_acc_smobilizzo)), ' '), 20, ' ')
          || RPAD (NVL (TRIM (TO_CHAR (gegb_acc_firma_dt)), ' '), 20, ' ')
          || RPAD (NVL (TRIM (TO_CHAR (gegb_tot_gar)), ' '), 20, ' ')
          || RPAD (NVL (TRIM (TO_CHAR (glgb_uti_cassa)), ' '), 20, ' ')
          || RPAD (NVL (TRIM (TO_CHAR (glgb_uti_firma)), ' '), 20, ' ')
          || RPAD (NVL (TRIM (TO_CHAR (glgb_acc_cassa)), ' '), 20, ' ')
          || RPAD (NVL (TRIM (TO_CHAR (glgb_acc_firma)), ' '), 20, ' ')
          || RPAD (NVL (TRIM (TO_CHAR (glgb_uti_cassa_bt)), ' '), 20, ' ')
          || RPAD (NVL (TRIM (TO_CHAR (glgb_uti_cassa_mlt)), ' '), 20, ' ')
          || RPAD (NVL (TRIM (TO_CHAR (glgb_uti_smobilizzo)), ' '), 20, ' ')
          || RPAD (NVL (TRIM (TO_CHAR (glgb_uti_firma_dt)), ' '), 20, ' ')
          || RPAD (NVL (TRIM (TO_CHAR (glgb_acc_cassa_bt)), ' '), 20, ' ')
          || RPAD (NVL (TRIM (TO_CHAR (glgb_acc_cassa_mlt)), ' '), 20, ' ')
          || RPAD (NVL (TRIM (TO_CHAR (glgb_acc_smobilizzo)), ' '), 20, ' ')
          || RPAD (NVL (TRIM (TO_CHAR (glgb_acc_firma_dt)), ' '), 20, ' ')
          || RPAD (NVL (TRIM (TO_CHAR (glgb_tot_gar)), ' '), 20, ' ')
          || RPAD (
                NVL (TRIM (TO_CHAR (gb_dta_riferimento, 'yyyymmdd')), ' '),
                8,
                ' ')
          || RPAD (NVL (TRIM (gb_val_mau), ' '), 20, ' ')
          || RPAD (NVL (TRIM (TO_CHAR (val_lgd)), ' '), 20, ' ')
          || RPAD (NVL (TRIM (TO_CHAR (dta_lgd, 'yyyymmdd')), ' '), 8, ' ')
          || RPAD (NVL (TRIM (TO_CHAR (val_ead)), ' '), 20, ' ')
          || RPAD (NVL (TRIM (TO_CHAR (dta_ead, 'yyyymmdd')), ' '), 8, ' ')
          || RPAD (NVL (TRIM (TO_CHAR (val_pa)), ' '), 20, ' ')
          || RPAD (NVL (TRIM (TO_CHAR (dta_pa, 'yyyymmdd')), ' '), 8, ' ')
          || RPAD (NVL (TRIM (TO_CHAR (val_pd_online)), ' '), 16, ' ')
          || RPAD (NVL (TRIM (TO_CHAR (dta_pd_online, 'yyyymmdd')), ' '),
                   8,
                   ' ')
          || RPAD (NVL (TRIM (val_rating_online), ' '), 4, ' ')
          || RPAD (NVL (TRIM (TO_CHAR (val_pd)), ' '), 20, ' ')
          || RPAD (NVL (TRIM (TO_CHAR (dta_pd, 'yyyymmdd')), ' '), 8, ' ')
          || RPAD (NVL (TRIM (TO_CHAR (val_iris_ge)), ' '), 20, ' ')
          || RPAD (NVL (TRIM (TO_CHAR (val_iris_cli)), ' '), 20, ' ')
          || RPAD (NVL (TRIM (TO_CHAR (dta_iris, 'yyyymmdd')), ' '), 8, ' ')
          || RPAD (NVL (TRIM (liv_rischio_ge), ' '), 2, ' ')
          || RPAD (NVL (TRIM (liv_rischio_cli), ' '), 2, ' ')
          || RPAD (NVL (TRIM (TO_CHAR (val_sconfino)), ' '), 5, ' ')
          || RPAD (NVL (TRIM (cod_rap), ' '), 17, ' ')
          || RPAD (NVL (TRIM (TO_CHAR (val_sconfino_rap)), ' '), 5, ' ')
          || RPAD (NVL (TRIM (flg_allineato_sag), ' '), 2, ' ')
          || RPAD (NVL (TRIM (flg_conferma_sag), ' '), 1, ' ')
          || RPAD (NVL (TRIM (TO_CHAR (dta_conferma_sag, 'yyyymmdd')), ' '),
                   8,
                   ' ')
          || RPAD (NVL (TRIM (TO_CHAR (cod_mese_hst)), ' '), 8, ' ')
          || RPAD (NVL (TRIM (TO_CHAR (id_dper_fg)), ' '), 8, ' ')
          || RPAD (NVL (TRIM (cod_pef), ' '), 17, ' ')
          || RPAD (NVL (TRIM (cod_fase_pef), ' '), 3, ' ')
          || RPAD (
                NVL (TRIM (TO_CHAR (dta_ultima_revisione_pef, 'yyyymmdd')),
                     ' '),
                8,
                ' ')
          || RPAD (NVL (TRIM (TO_CHAR (dta_scadenza_fido, 'yyyymmdd')), ' '),
                   8,
                   ' ')
          || RPAD (
                NVL (TRIM (TO_CHAR (dta_ultima_delibera, 'yyyymmdd')), ' '),
                8,
                ' ')
          || RPAD (NVL (TRIM (flg_fidi_scaduti), ' '), 1, ' ')
          || RPAD (
                NVL (TRIM (TO_CHAR (dat_ultimo_scaduto, 'yyyymmdd')), ' '),
                8,
                ' ')
          || RPAD (NVL (TRIM (cod_ultimo_ode), ' '), 2, ' ')
          || RPAD (NVL (TRIM (cod_cts_ultimo_ode), ' '), 5, ' ')
          || RPAD (NVL (TRIM (cod_strategia_crz), ' '), 3, ' ')
          || RPAD (NVL (TRIM (cod_ode), ' '), 2, ' ')
          || RPAD (
                NVL (TRIM (TO_CHAR (dta_completamento_pef, 'yyyymmdd')), ' '),
                8,
                ' ')
          || RPAD (NVL (TRIM (val_rating), ' '), 4, ' ')
          || RPAD (NVL (TRIM (cod_servizio), ' '), 6, ' ')
          || RPAD (NVL (TRIM (TO_CHAR (dta_servizio, 'YYYYMMDD')), ' '),
                   8,
                   ' ')
          || RPAD (NVL (TRIM (TO_CHAR (scsb_acc_cr)), ' '), 15, ' ')
          || RPAD (NVL (TRIM (TO_CHAR (scsb_uti_cr)), ' '), 15, ' ')
          || RPAD (NVL (TRIM (TO_CHAR (scsb_gar_cr)), ' '), 15, ' ')
          || RPAD (NVL (TRIM (TO_CHAR (scsb_sco_cr)), ' '), 15, ' ')
          || RPAD (NVL (TRIM (scsb_qis_acc), ' '), 10, ' ')
          || RPAD (NVL (TRIM (scsb_qis_uti), ' '), 10, ' ')
          || RPAD (NVL (TRIM (TO_CHAR (scgb_acc_cr)), ' '), 15, ' ')
          || RPAD (NVL (TRIM (TO_CHAR (scgb_acc_sis)), ' '), 15, ' ')
          || RPAD (NVL (TRIM (TO_CHAR (scgb_gar_cr)), ' '), 15, ' ')
          || RPAD (NVL (TRIM (TO_CHAR (scgb_gar_sis)), ' '), 15, ' ')
          || RPAD (NVL (TRIM (TO_CHAR (scgb_sco_cr)), ' '), 15, ' ')
          || RPAD (NVL (TRIM (TO_CHAR (scgb_sco_sis)), ' '), 15, ' ')
          || RPAD (NVL (TRIM (TO_CHAR (scgb_uti_cr)), ' '), 15, ' ')
          || RPAD (NVL (TRIM (TO_CHAR (scgb_uti_sis)), ' '), 15, ' ')
          || RPAD (NVL (TRIM (scgb_qis_acc), ' '), 10, ' ')
          || RPAD (NVL (TRIM (scgb_qis_uti), ' '), 10, ' ')
          || RPAD (NVL (TRIM (TO_CHAR (scgb_dta_rif_cr, 'YYYYMMDD')), ' '),
                   8,
                   ' ')
          || RPAD (
                NVL (TRIM (TO_CHAR (scgb_dta_stato_sis, 'YYYYMMDD')), ' '),
                8,
                ' ')
          || RPAD (NVL (TRIM (TO_CHAR (scgb_id_dper)), ' '), 8, ' ')
          || RPAD (NVL (TRIM (TO_CHAR (gesb_acc_cr)), ' '), 15, ' ')
          || RPAD (NVL (TRIM (TO_CHAR (gesb_uti_cr)), ' '), 15, ' ')
          || RPAD (NVL (TRIM (TO_CHAR (gesb_gar_cr)), ' '), 15, ' ')
          || RPAD (NVL (TRIM (TO_CHAR (gesb_sco_cr)), ' '), 15, ' ')
          || RPAD (NVL (TRIM (gesb_qis_acc), ' '), 10, ' ')
          || RPAD (NVL (TRIM (gesb_qis_uti), ' '), 10, ' ')
          || RPAD (NVL (TRIM (TO_CHAR (gegb_acc_cr)), ' '), 15, ' ')
          || RPAD (NVL (TRIM (TO_CHAR (gegb_acc_sis)), ' '), 15, ' ')
          || RPAD (NVL (TRIM (TO_CHAR (gegb_uti_cr)), ' '), 15, ' ')
          || RPAD (NVL (TRIM (TO_CHAR (gegb_uti_sis)), ' '), 15, ' ')
          || RPAD (NVL (TRIM (TO_CHAR (gegb_gar_cr)), ' '), 15, ' ')
          || RPAD (NVL (TRIM (TO_CHAR (gegb_gar_sis)), ' '), 15, ' ')
          || RPAD (NVL (TRIM (TO_CHAR (gegb_sco_cr)), ' '), 15, ' ')
          || RPAD (NVL (TRIM (TO_CHAR (gegb_sco_sis)), ' '), 15, ' ')
          || RPAD (NVL (TRIM (gegb_qis_acc), ' '), 10, ' ')
          || RPAD (NVL (TRIM (gegb_qis_uti), ' '), 10, ' ')
          || RPAD (NVL (TRIM (TO_CHAR (glgb_acc_cr)), ' '), 15, ' ')
          || RPAD (NVL (TRIM (TO_CHAR (glgb_uti_cr)), ' '), 15, ' ')
          || RPAD (NVL (TRIM (TO_CHAR (glgb_sco_cr)), ' '), 15, ' ')
          || RPAD (NVL (TRIM (TO_CHAR (glgb_gar_cr)), ' '), 15, ' ')
          || RPAD (NVL (TRIM (TO_CHAR (glgb_acc_sis)), ' '), 15, ' ')
          || RPAD (NVL (TRIM (TO_CHAR (glgb_uti_sis)), ' '), 15, ' ')
          || RPAD (NVL (TRIM (TO_CHAR (glgb_sco_sis)), ' '), 15, ' ')
          || RPAD (NVL (TRIM (TO_CHAR (glgb_imp_gar_sis)), ' '), 15, ' ')
          || RPAD (NVL (TRIM (glgb_qis_acc), ' '), 10, ' ')
          || RPAD (NVL (TRIM (glgb_qis_uti), ' '), 10, ' ')
          || RPAD (NVL (TRIM (scgb_cod_stato_sis), ' '), 3, ' ')
          || RPAD (NVL (TRIM (TO_CHAR (scsb_dta_cr, 'YYYYMMDD')), ' '),
                   8,
                   ' ')
          || RPAD (NVL (TRIM (TO_CHAR (gesb_dta_cr, 'YYYYMMDD')), ' '),
                   8,
                   ' ')
          || RPAD (NVL (TRIM (TO_CHAR (gegb_dta_rif_cr, 'YYYYMMDD')), ' '),
                   8,
                   ' ')
          || RPAD (NVL (TRIM (TO_CHAR (glgb_dta_rif_cr, 'YYYYMMDD')), ' '),
                   8,
                   ' ')
          || RPAD (NVL (TRIM (TO_CHAR (val_num_proroghe)), ' '), 5, ' ')
          || '                            '
             record_char
     FROM t_mcre0_app_storico_eventi ev
          INNER JOIN t_mcre0_app_stati st ON ev.cod_stato = cod_microstato
          LEFT JOIN
          (SELECT *
             FROM t_mcre0_app_rio_proroghe
            WHERE flg_storico = 0 AND flg_esito IS NOT NULL) pr
             ON     ev.cod_abi_cartolarizzato = pr.cod_abi_cartolarizzato
                AND ev.cod_ndg = pr.cod_ndg
    WHERE     ev.cod_stato IS NOT NULL
          AND (tip_stato = 'A' OR (tip_stato <> 'A' AND cod_stato = 'BO'));
