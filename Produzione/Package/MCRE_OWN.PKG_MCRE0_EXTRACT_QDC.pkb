CREATE OR REPLACE PACKAGE BODY MCRE_OWN."PKG_MCRE0_EXTRACT_QDC"
AS
/*********
 NAME: MCRE_OWN.PKG_MCRE0_EXTRACT_QDC
 PURPOSE:

 REVISIONS:
 Ver        Date              Author             Description
 ---------  ----------      -----------------  ------------------------------------
 1.0          19/12/2011        C.Giannangeli        Created this package.
 1.1          25/10/2012        D.Manni              Modified: create funzioni
                                                        prc_extract_qdc_cruscdel,
                                                        prc_extract_qdc_bilancio,
                                                        prc_qdc_spool_to_file
 1.2          19/09/2013        D.Manni              Modified: change procedure
                                                        prc_extract_qdc_bilancio
 1.3          21/11/2013        D.Manni              Modified: Aggiunto stato SO a
                                                        funzione fnd_extract_qdc
 1.4          07/01/2014        D.Manni              Modified: dismessa estrazione
                                                        dati Cruscotto e Bilancio
 1.5          02/05/2014       A.Pilloni      commentati movimenti mod mov in extract qdc bilancio
***********/
   c_package   CONSTANT VARCHAR2 (50) := 'PKG_MCRE0_EXTRACT_QDC';
   ok   NUMBER        := 1;
   ko   NUMBER        := 0;

   FUNCTION fnd_extract_qdc (p_id_dper IN varchar2)
        RETURN NUMBER
        is

        v_cod_mese_hst number;

        BEGIN

SELECT MAX(COD_MESE_HST)
into v_cod_mese_hst
FROM t_mcre0_app_storico_eventi
WHERE substr(to_char(cod_mese_hst), 1, 6) = p_id_dper;


execute immediate 'truncate table T_MCRE0_APP_QDC_STORICO_MESE';
INSERT
INTO T_MCRE0_APP_QDC_STORICO_MESE (RECORD_CHAR)

  SELECT
   RPAD (NVL (TRIM (cod_abi_istituto), ' '), 5, ' ')
|| RPAD (NVL (TRIM (ev.cod_abi_cartolarizzato), ' '), 5, ' ')
|| RPAD (NVL (TRIM (ev.cod_ndg), ' '), 16, ' ')
|| RPAD (NVL (TRIM (cod_sndg), ' '), 16, ' ')
|| RPAD (NVL (TRIM (TO_CHAR (dta_ini_validita, 'yyyymmdd')), ' '),
         8,
         ' '
        )
|| RPAD (NVL (TRIM (TO_CHAR (dta_fine_validita, 'yyyymmdd')), ' '),
         8,
         ' '
        )
|| RPAD (NVL (TRIM (flg_cambio_stato), ' '), 1, ' ')
|| RPAD (NVL (TRIM (flg_cambio_gestore), ' '), 1, ' ')
|| RPAD (NVL (TRIM (flg_cambio_comparto), ' '), 1, ' ')
|| RPAD (NVL (TRIM (flg_cambio_mese), ' '), 1, ' ')
|| RPAD (NVL (TRIM (desc_nome_controparte), ' '), 64, ' ')
|| RPAD (NVL (TRIM (cod_gruppo_legame), ' '), 18, ' ')
|| RPAD (NVL (TRIM (REPLACE(cod_gruppo_economico, '-1', ' ')), ' '), 8, ' ')
|| RPAD (NVL (TRIM (cod_gruppo_super), ' '), 20, ' ')
|| RPAD (NVL (TRIM (TO_CHAR (dta_intercettamento, 'yyyymmdd')), ' '),
         8,
         ' '
        )
|| RPAD (NVL (TRIM (cod_filiale), ' '), 5, ' ')
|| RPAD (NVL (TRIM (cod_struttura_competente), ' '), 5, ' ')
|| RPAD (NVL (TRIM (cod_ramo_host), ' '), 6, ' ')
|| RPAD (NVL (TRIM (cod_comparto_host), ' '), 6, ' ')
|| RPAD (NVL (TRIM (REPLACE(cod_comparto_calcolato_pre, '#', ' ')), ' '), 6, ' ')
|| RPAD (NVL (TRIM (REPLACE(cod_comparto_calcolato, '#', ' ')), ' '), 6, ' ')
|| RPAD (NVL (TRIM (cod_comparto_assegnato), ' '), 6, ' ')
|| RPAD (NVL (TRIM (TO_CHAR (cod_percorso)), ' '), 3, ' ')
|| RPAD (NVL (TRIM (cod_processo), ' '), 2, ' ')
|| RPAD (NVL (TRIM (REPLACE(cod_stato, '-1', ' ')), ' '), 2, ' ')
|| RPAD (NVL (TRIM (TO_CHAR (dta_decorrenza_stato, 'yyyymmdd')),
              ' '),
         8,
         ' '
        )
|| RPAD (NVL (TRIM (TO_CHAR (dta_scadenza_stato, 'yyyymmdd')), ' '),
         8,
         ' '
        )
|| RPAD (NVL (TRIM (REPLACE(cod_stato_precedente, '-1', ' ')), ' '), 2, ' ')
|| RPAD (NVL (TRIM (cod_tipo_ingresso), ' '), 1, ' ')
|| RPAD (NVL (TRIM (id_transizione), ' '), 1, ' ')
|| RPAD (NVL (TRIM (TO_CHAR (dta_processo, 'yyyymmdd')), ' '),
         8,
         ' '
        )
|| RPAD (NVL (TRIM (TO_CHAR (id_referente)), ' '), 20, ' ')
|| RPAD (NVL (TRIM (TO_CHAR (REPLACE(ev.id_utente, '-1', ' '))), ' '), 20, ' ')
|| RPAD (NVL (TRIM (TO_CHAR (REPLACE(id_utente_pre, '-1', ' '))), ' '), 20, ' ')
|| RPAD (NVL (TRIM (TO_CHAR (dta_ini_utente, 'yyyymmdd')), ' '),
         8,
         ' '
        )
|| RPAD (NVL (TRIM (TO_CHAR (dta_fine_utente, 'yyyymmdd')), ' '),
         8,
         ' '
        )
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
|| RPAD (NVL (TRIM (TO_CHAR (scsb_dta_riferimento, 'yyyymmdd')),
              ' '),
         8,
         ' '
        )
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
|| RPAD (NVL (TRIM (TO_CHAR (gesb_dta_riferimento, 'yyyymmdd')),
              ' '),
         8,
         ' '
        )
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
|| RPAD (NVL (TRIM (TO_CHAR (gb_dta_riferimento, 'yyyymmdd')), ' '),
         8,
         ' '
        )
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
         ' '
        )
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
         ' '
        )
|| RPAD (NVL (TRIM (TO_CHAR (cod_mese_hst)), ' '), 8, ' ')
|| RPAD (NVL (TRIM (TO_CHAR (id_dper_fg)), ' '), 8, ' ')
|| RPAD (NVL (TRIM (cod_pef), ' '), 17, ' ')
|| RPAD (NVL (TRIM (cod_fase_pef), ' '), 3, ' ')
|| RPAD (NVL (TRIM (TO_CHAR (dta_ultima_revisione_pef, 'yyyymmdd')),
              ' '
             ),
         8,
         ' '
        )
|| RPAD (NVL (TRIM (TO_CHAR (dta_scadenza_fido, 'yyyymmdd')), ' '),
         8,
         ' '
        )
|| RPAD (NVL (TRIM (TO_CHAR (dta_ultima_delibera, 'yyyymmdd')), ' '),
         8,
         ' '
        )
|| RPAD (NVL (TRIM (flg_fidi_scaduti), ' '), 1, ' ')
|| RPAD (NVL (TRIM (TO_CHAR (dat_ultimo_scaduto, 'yyyymmdd')), ' '),
         8,
         ' '
        )
|| RPAD (NVL (TRIM (cod_ultimo_ode), ' '), 2, ' ')
|| RPAD (NVL (TRIM (cod_cts_ultimo_ode), ' '), 5, ' ')
|| RPAD (NVL (TRIM (cod_strategia_crz), ' '), 3, ' ')
|| RPAD (NVL (TRIM (cod_ode), ' '), 2, ' ')
|| RPAD (NVL (TRIM (TO_CHAR (dta_completamento_pef, 'yyyymmdd')),
              ' '
             ),
         8,
         ' '
        )
|| RPAD (NVL (TRIM (val_rating), ' '), 4, ' ')
|| RPAD (NVL (TRIM (cod_servizio), ' '), 6, ' ')
|| RPAD (NVL (TRIM (TO_CHAR (dta_servizio, 'YYYYMMDD')), ' '),
         8,
         ' '
        )
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
         ' '
        )
|| RPAD (NVL (TRIM (TO_CHAR (scgb_dta_stato_sis, 'YYYYMMDD')), ' '),
         8,
         ' '
        )
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
|| RPAD (NVL (TRIM (TO_CHAR (scsb_dta_cr, 'YYYYMMDD')), ' '), 8,
         ' ')
|| RPAD (NVL (TRIM (TO_CHAR (gesb_dta_cr, 'YYYYMMDD')), ' '), 8,
         ' ')
|| RPAD (NVL (TRIM (TO_CHAR (gegb_dta_rif_cr, 'YYYYMMDD')), ' '),
         8,
         ' '
        )
|| RPAD (NVL (TRIM (TO_CHAR (glgb_dta_rif_cr, 'YYYYMMDD')), ' '),
         8,
         ' '
        )
|| '    '
|| LPAD (NVL (TRIM (TO_CHAR (val_num_proroghe)), '0'), 5, ' ')
|| '                        ' record_char



     FROM t_mcre0_app_storico_eventi ev

     INNER JOIN t_mcre0_app_stati st
ON ev.cod_stato = cod_microstato

     LEFT JOIN
(SELECT *
   FROM t_mcre0_app_rio_proroghe
  WHERE flg_storico = 0 and flg_esito is not null) pr --mm13.05.09
ON ev.cod_abi_cartolarizzato = pr.cod_abi_cartolarizzato
AND ev.cod_ndg = pr.cod_ndg
    WHERE ev.cod_stato IS NOT NULL
      AND (tip_stato = 'A' OR (tip_stato <> 'A' AND cod_stato IN ('BO','SO'))) --(1.3)

      and substr(to_char(ev.cod_mese_hst), 1, 6) = p_id_dper



UNION


select
   RPAD (NVL (TRIM (cod_abi_istituto), ' '), 5, ' ')
|| RPAD (NVL (TRIM (cod_abi_cartolarizzato), ' '), 5, ' ')
|| RPAD (NVL (TRIM (cod_ndg), ' '), 16, ' ')
|| RPAD (NVL (TRIM (cod_sndg), ' '), 16, ' ')
|| RPAD (NVL (TRIM (TO_CHAR (dta_ini_validita, 'yyyymmdd')), ' '),
         8,
         ' '
        )
|| RPAD (NVL (TRIM (TO_CHAR (dta_fine_validita, 'yyyymmdd')), ' '),
         8,
         ' '
        )
|| RPAD (NVL (TRIM (flg_cambio_stato), ' '), 1, ' ')
|| RPAD (NVL (TRIM (flg_cambio_gestore), ' '), 1, ' ')
|| RPAD (NVL (TRIM (flg_cambio_comparto), ' '), 1, ' ')
|| RPAD (NVL (TRIM (flg_cambio_mese), ' '), 1, ' ')
|| RPAD (NVL (TRIM (desc_nome_controparte), ' '), 64, ' ')
|| RPAD (NVL (TRIM (cod_gruppo_legame), ' '), 18, ' ')
|| RPAD (NVL (TRIM (REPLACE(cod_gruppo_economico, '-1', ' ')), ' '), 8, ' ')
|| RPAD (NVL (TRIM (cod_gruppo_super), ' '), 20, ' ')
|| RPAD (NVL (TRIM (TO_CHAR (dta_intercettamento, 'yyyymmdd')), ' '),
         8,
         ' '
        )
|| RPAD (NVL (TRIM (cod_filiale), ' '), 5, ' ')
|| RPAD (' ', 5, ' ')
|| RPAD (NVL (TRIM (cod_ramo_host), ' '), 6, ' ')
|| RPAD (NVL (TRIM (cod_comparto_host), ' '), 6, ' ')
|| RPAD (NVL (TRIM (REPLACE(cod_comparto_calcolato_pre, '#', ' ')), ' '), 6, ' ')
|| RPAD (' ', 6, ' ')
|| RPAD (' ', 6, ' ')
|| RPAD (NVL (TRIM (TO_CHAR (cod_percorso)), ' '), 3, ' ')
|| RPAD (NVL (TRIM (cod_processo_perc), ' '), 2, ' ')
|| RPAD (NVL (TRIM (REPLACE(cod_stato_perc, '-1', ' ')), ' '), 2, ' ')
|| RPAD (NVL (TRIM (TO_CHAR (dta_decorrenza_stato, 'yyyymmdd')),
              ' '),
         8,
         ' '
        )
|| RPAD (NVL (TRIM (TO_CHAR (dta_scadenza_stato, 'yyyymmdd')), ' '),
         8,
         ' '
        )
|| RPAD (NVL (TRIM (REPLACE(cod_stato_precedente, '-1', ' ')), ' '), 2, ' ')
|| RPAD (NVL (TRIM (cod_tipo_ingresso), ' '), 1, ' ')
|| RPAD (NVL (TRIM (id_transizione), ' '), 1, ' ')
|| RPAD (NVL (TRIM (TO_CHAR (dta_processo, 'yyyymmdd')), ' '),
         8,
         ' '
        )
|| RPAD (NVL (TRIM (TO_CHAR (id_referente)), ' '), 20, ' ')
|| RPAD (NVL (TRIM (TO_CHAR (REPLACE(id_utente, '-1', ' '))), ' '), 20, ' ')
|| RPAD (NVL (TRIM (TO_CHAR (REPLACE(id_utente_pre, '-1', ' '))), ' '), 20, ' ')
|| RPAD (NVL (TRIM (TO_CHAR (dta_ini_utente, 'yyyymmdd')), ' '),
         8,
         ' '
        )
|| RPAD (NVL (TRIM (TO_CHAR (dta_fine_utente, 'yyyymmdd')), ' '),
         8,
         ' '
        )
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
|| RPAD (NVL (TRIM (TO_CHAR (scsb_dta_riferimento, 'yyyymmdd')),
              ' '),
         8,
         ' '
        )
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
|| RPAD (NVL (TRIM (TO_CHAR (gesb_dta_riferimento, 'yyyymmdd')),
              ' '),
         8,
         ' '
        )
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
|| RPAD (NVL (TRIM (TO_CHAR (gb_dta_riferimento, 'yyyymmdd')), ' '),
         8,
         ' '
        )
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
         ' '
        )
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
         ' '
        )
|| RPAD (NVL (TRIM (TO_CHAR (v_cod_mese_hst)), ' '), 8, ' ')
|| RPAD (NVL (TRIM (TO_CHAR (id_dper_fg)), ' '), 8, ' ')
|| RPAD (NVL (TRIM (cod_pef), ' '), 17, ' ')
|| RPAD (NVL (TRIM (cod_fase_pef), ' '), 3, ' ')
|| RPAD (NVL (TRIM (TO_CHAR (dta_ultima_revisione_pef, 'yyyymmdd')),
              ' '
             ),
         8,
         ' '
        )
|| RPAD (NVL (TRIM (TO_CHAR (dta_scadenza_fido, 'yyyymmdd')), ' '),
         8,
         ' '
        )
|| RPAD (NVL (TRIM (TO_CHAR (dta_ultima_delibera, 'yyyymmdd')), ' '),
         8,
         ' '
        )
|| RPAD (NVL (TRIM (flg_fidi_scaduti), ' '), 1, ' ')
|| RPAD (NVL (TRIM (TO_CHAR (dat_ultimo_scaduto, 'yyyymmdd')), ' '),
         8,
         ' '
        )
|| RPAD (NVL (TRIM (cod_ultimo_ode), ' '), 2, ' ')
|| RPAD (NVL (TRIM (cod_cts_ultimo_ode), ' '), 5, ' ')
|| RPAD (NVL (TRIM (cod_strategia_crz), ' '), 3, ' ')
|| RPAD (NVL (TRIM (cod_ode), ' '), 2, ' ')
|| RPAD (NVL (TRIM (TO_CHAR (dta_completamento_pef, 'yyyymmdd')),
              ' '
             ),
         8,
         ' '
        )
|| RPAD (NVL (TRIM (val_rating), ' '), 4, ' ')
|| RPAD (NVL (TRIM (cod_servizio), ' '), 6, ' ')
|| RPAD (NVL (TRIM (TO_CHAR (dta_servizio, 'YYYYMMDD')), ' '),
         8,
         ' '
        )
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
         ' '
        )
|| RPAD (NVL (TRIM (TO_CHAR (scgb_dta_stato_sis, 'YYYYMMDD')), ' '),
         8,
         ' '
        )
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
|| RPAD (NVL (TRIM (TO_CHAR (scsb_dta_cr, 'YYYYMMDD')), ' '), 8,
         ' ')
|| RPAD (NVL (TRIM (TO_CHAR (gesb_dta_cr, 'YYYYMMDD')), ' '), 8,
         ' ')
|| RPAD (NVL (TRIM (TO_CHAR (gegb_dta_rif_cr, 'YYYYMMDD')), ' '),
         8,
         ' '
        )
|| RPAD (NVL (TRIM (TO_CHAR (glgb_dta_rif_cr, 'YYYYMMDD')), ' '),
         8,
         ' '
        )
|| '    '
|| '     '
|| '                        ' record_char

 from
(select * from  (

(SELECT * from


(SELECT
prc.COD_ABI_CARTOLARIZZATO as COD_ABI_CARTOLARIZZATO_prc,
prc.cod_ndg as cod_ndg_prc,
prc.COD_STATO as cod_stato_perc,
prc.COD_STATO_PRECEDENTE as cod_stato_perc_pre,
prc.cod_percorso as cod_percorso_prc,
prc.COD_PROCESSO as COD_PROCESSO_perc,
st.tip_stato,
st2.tip_stato as tip_stato2,
to_date(substr(tms, 1, 10), 'yyyy-mm-dd') tms,
rank() over (partition by COD_ABI_CARTOLARIZZATO, cod_ndg order by to_date(substr(tms, 1, 10), 'yyyy-mm-dd')  desc ) ord

from T_MCRE0_APP_PERCORSI prc

 INNER JOIN t_mcre0_app_stati st
ON prc.cod_stato = st.cod_microstato

 INNER JOIN t_mcre0_app_stati st2
ON prc.COD_STATO_PRECEDENTE = st2.cod_microstato
 where
     to_date(substr(tms, 1, 7), 'yyyy-mm')  =  to_date(p_id_dper, 'yyyymm')
     and st.tip_stato = 'U'
     and st2.tip_stato <> 'U')

WHERE
ord = 1) uno


INNER JOIN

---------
(SELECT
ev.*,
rank() over (partition by ev.COD_ABI_CARTOLARIZZATO, ev.cod_ndg order by dta_fine_validita desc ) ord_ev

FROM
T_MCRE0_APP_STORICO_EVENTI ev

WHERE
to_char(dta_fine_validita, 'yyyymm') = p_id_dper) tre



 on
uno.COD_ABI_CARTOLARIZZATO_prc = tre.COD_ABI_CARTOLARIZZATO
and uno.cod_ndg_prc = tre.cod_ndg
and uno.COD_STATO_perc_pre = tre.cod_stato
and uno.cod_percorso_prc = tre.cod_percorso)

WHERE
 flg_cambio_mese <> 1
and ord_ev = 1) uscite


left outer join
(select cod_abi_cartolarizzato cod_abi_cartolarizzato_ , cod_ndg cod_ndg_
from t_mcre0_app_storico_eventi ev
where substr(to_char(ev.cod_mese_hst), 1, 6) = p_id_dper) st_ev
on st_ev.cod_abi_cartolarizzato_ = uscite.cod_abi_cartolarizzato
and st_ev.cod_ndg_ =  uscite.cod_ndg

where
st_ev.cod_abi_cartolarizzato_ is null;

        commit;

        return 1;
      EXCEPTION WHEN OTHERS THEN

  PKG_MCRE0_LOG.SPO_MCRE0_LOG_EVENTO(0,'FND_MCRE0_load','ERRORE' ,SUBSTR(SQLERRM, 1, 255));
  DBMS_OUTPUT.PUT_LINE(SUBSTR(SQLERRM, 1, 255));
  RETURN 0;


        END fnd_extract_qdc;

PROCEDURE prc_extract_qdc_cruscdel(p_id_dper in varchar2 default null )
IS
    vPeriodo varchar2(8);
BEGIN

    vPeriodo:=p_id_dper;

    if vPeriodo is null then
        SELECT TO_CHAR (MAX(cod_mese_hst))
          INTO vPeriodo
        FROM t_mcre0_app_storico_eventi;
    end if;

    /*p_id_dper=YYYYMMDD*/
    dbms_application_info.set_client_info(vPeriodo);

    DELETE FROM MCRE_OWN.QZT_ST_QDC_WRK WHERE COD_FILE='QDC_CRUSCDEL';

    COMMIT;

    EXECUTE IMMEDIATE 'truncate table T_MCRE0_APP_QDC_CDR_CRUSCOTTO';

    EXECUTE IMMEDIATE 'truncate table T_MCRE0_APP_QDC_POSIZ_DELIB';

    --seleziona tutte le posizioni e le eventuali delibere associate
    INSERT INTO T_MCRE0_APP_QDC_POSIZ_DELIB
    SELECT *
    FROM v_mcre0_app_qdc_posiz_delib

    COMMIT;

    /*(1.4)*/
    INSERT INTO T_MCRE0_APP_QDC_CDR_CRUSCOTTO (RECORD_CHAR)
    SELECT 'DATA_RIF'|| vPeriodo
    FROM dual
    --UNION
    --SELECT RPAD(record_char, 1020, ' ')
    --FROM v_mcre0_app_qdc_cdr_storico
    UNION
    SELECT RPAD(record_char, 1020, ' ')
    FROM v_mcre0_app_qdc_cdr_delibere;

    INSERT INTO MCRE_OWN.QZT_ST_QDC_WRK VALUES ('QDC_CRUSCDEL',1,0);

    COMMIT;

    EXCEPTION
        WHEN OTHERS THEN
            pkg_mcre0_log.spo_mcre0_log_evento(0,'PRC_EXTRACT_QDC_CRUSCDEL','ERRORE' ,SUBSTR(SQLERRM, 1, 255));
            dbms_output.put_line(SUBSTR(SQLERRM, 1, 255));

END prc_extract_qdc_cruscdel;

PROCEDURE prc_extract_qdc_bilancio
IS
    v_val_parameter NUMBER(8);
    v_flg_ricarico  NUMBER(1);

    v_caricamenti_mese NUMBER;
    v_abi_non_caricati NUMBER;

    v_periodo_successivo_atteso varchar2(8);

    exec_caricamento  number;
    msg_warning varchar(200);
begin

    --pkg_mcre0_log.spo_mcre0_log_evento(0,'FND_MCRE0_estraz_bil','INFO' ,'Inizio Procedura');

    DELETE FROM MCRE_OWN.QZT_ST_QDC_WRK WHERE COD_FILE IN('QDC_BILANCIO','QDC_SISBA','QDC_EFF_ECO');

    COMMIT;

    select VAL_PARAMETER, FLG_RICARICO
    into v_val_parameter, v_flg_ricarico
    from  (select rank() over (order by VAL_PARAMETER asc) r , VAL_PARAMETER,FLG_RICARICO from QZT_ST_QDC_PARAM where DES_PARAMETER='ID_DPER')
    where  r<2;

    SELECT count(*)
    into v_caricamenti_mese
    from T_MCRES_WRK_ACQUISIZIONE acq
    --AP 02/05/2014
    --where acq.cod_flusso in ('SISBA_CP','EFFETTI_ECONOMICI','MOVIMENTI_MOD_MOV','MCRDSISBACP','MCRDEFFEECO','MCRDMODMOV')
    where acq.cod_flusso in ('SISBA_CP','EFFETTI_ECONOMICI','MCRDSISBACP','MCRDEFFEECO')
        and acq.cod_stato='CARICATO'
        and acq.id_dper=to_date(v_val_parameter,'yyyymmdd');

    SELECT sum(case when acq.COD_FLUSSO is null then 1 else 0 end)
    into v_abi_non_caricati
    from T_MCRES_WRK_ANAGRAFICA_BILANCI anb, T_MCRES_WRK_ACQUISIZIONE acq
    where anb.cod_flusso=acq.cod_flusso(+)
        and anb.cod_abi=acq.cod_abi(+)
        --AP 02/05/2014
        --and anb.cod_flusso in ('SISBA_CP','EFFETTI_ECONOMICI','MOVIMENTI_MOD_MOV','MCRDSISBACP','MCRDEFFEECO','MCRDMODMOV')
        and anb.cod_flusso in ('SISBA_CP','EFFETTI_ECONOMICI','MCRDSISBACP','MCRDEFFEECO')
        and anb.FLG_IGNORE=0
        and acq.cod_stato(+)='CARICATO'
        and acq.id_dper(+)=to_date(v_val_parameter,'yyyymmdd');


    if v_flg_ricarico=0 then
        if v_caricamenti_mese=0 then
            msg_warning:='periodo non caricato.';
            exec_caricamento:=0;
        elsif v_abi_non_caricati=0 then
            exec_caricamento:=1;
        else
            msg_warning:='abi non caricati.';
            exec_caricamento:=0;
        end if;
    else
        if v_caricamenti_mese>0 then
            exec_caricamento:=1;
        else
            msg_warning:='periodo non caricato.';
            exec_caricamento:=0;
        end if;
    end if;


    if exec_caricamento=0 then

        pkg_mcre0_log.spo_mcre0_log_evento(0,'PRC_EXTRACT_QDC_BILANCIO','INFO' ,msg_warning);

        INSERT INTO MCRE_OWN.QZT_ST_QDC_WRK VALUES ('QDC_BILANCIO',0,0); /*(1.4) lo lasciamo*/
        INSERT INTO MCRE_OWN.QZT_ST_QDC_WRK VALUES ('QDC_SISBA',0,0);
        INSERT INTO MCRE_OWN.QZT_ST_QDC_WRK VALUES ('QDC_EFF_ECO',0,0);

        COMMIT;

    else

         /*v_val_parameter=YYYYMMDD*/
        dbms_application_info.set_client_info(substr(v_val_parameter,1,6));

        /*(1.4)*/
        --EXECUTE IMMEDIATE 'truncate table T_MCRE0_APP_QDC_CDR_BILANCIO';
        EXECUTE IMMEDIATE 'truncate table T_MCRE0_APP_QDC_SISBA_CP';
        EXECUTE IMMEDIATE 'truncate table T_MCRE0_APP_QDC_EFF_ECONOMICI';

        /*(1.4) Inizio*/
        /* INSERT
        INTO T_MCRE0_APP_QDC_CDR_BILANCIO
        SELECT *
        FROM V_MCRE0_APP_QDC_CDR_BILANCIO;
        */
        /*(1.2) Aggiornamento cod_filiale_area nei casi in cui è 00000, prendendolo da fonte cruscotto */
        /*
        UPDATE T_MCRE0_APP_QDC_CDR_BILANCIO b
        SET COD_STRUTTURA_COMPETENTE = (
        SELECT NVL(MAX(c.COD_STRUTTURA_COMPETENTE),'00000')
        FROM T_MCRE0_APP_STORICO_EVENTI c
        WHERE b.COD_NDG=C.COD_NDG
                AND b.COD_ABI=c.COD_ABI_CARTOLARIZZATO
                AND ((b.VAL_UTILIZZO_TOT=0 AND SUBSTR(c.COD_MESE_HST ,1,6) = b.ID_DPER)
                    OR (b.VAL_UTILIZZO_TOT=1 AND SUBSTR(c.COD_MESE_HST,1,6) = TO_CHAR(add_months(TO_DATE(b.ID_DPER,'YYYYMM'),-1),'YYYYMM'))))
        WHERE b.COD_STRUTTURA_COMPETENTE = '00000';

        COMMIT; */
        /*(1.2)fine  */
        /*(1.4) Fine*/

        INSERT
        INTO T_MCRE0_APP_QDC_SISBA_CP
        SELECT *
        FROM V_MCRE0_APP_SISBA_CP;

        INSERT
        INTO T_MCRE0_APP_QDC_EFF_ECONOMICI
        SELECT *
        FROM V_MCRE0_APP_EFFETTI_ECONOMICI;

        COMMIT;

        DELETE FROM MCRE_OWN.QZT_ST_QDC_PARAM WHERE DES_PARAMETER='ID_DPER' AND VAL_PARAMETER = v_val_parameter;

        INSERT INTO MCRE_OWN.QZT_ST_QDC_WRK VALUES ('QDC_BILANCIO',1,0); /*(1.4) lo lasciamo*/
        INSERT INTO MCRE_OWN.QZT_ST_QDC_WRK VALUES ('QDC_SISBA',1,0);
        INSERT INTO MCRE_OWN.QZT_ST_QDC_WRK VALUES ('QDC_EFF_ECO',1,0);

        if v_flg_ricarico = 0 then
            v_periodo_successivo_atteso:= TO_CHAR(ADD_MONTHS(LAST_DAY(TO_DATE(TO_CHAR(v_val_parameter),'YYYYMMDD')),1),'YYYYMMDD');
            /*(1.2) ulteriore forzatura, deve rimanere un'unica riga di caricamento ordinario, che viene aggiornata automaticamente*/
            DELETE FROM MCRE_OWN.QZT_ST_QDC_PARAM WHERE DES_PARAMETER='ID_DPER' AND FLG_RICARICO = 0;

            INSERT INTO MCRE_OWN.QZT_ST_QDC_PARAM VALUES ('ID_DPER',v_periodo_successivo_atteso,0);
        end if;

        COMMIT;

     end if;

    EXCEPTION
        WHEN OTHERS THEN
            pkg_mcre0_log.spo_mcre0_log_evento(0,'PRC_EXTRACT_QDC_BILANCIO','ERRORE' ,SUBSTR(SQLERRM, 1, 255));
            dbms_output.put_line(SUBSTR(SQLERRM, 1, 255));

end prc_extract_qdc_bilancio;

PROCEDURE prc_qdc_spool_to_file (p_file_name in varchar2,p_dir in varchar2,p_view in varchar2,orderby varchar2 default null )
is
/******************************************************************************
   NAME:       PRC_QDC_SPOOL_TO_FILE
   PURPOSE:    Effetturare lo spool su file delle righe di una vista il cui unico
               campo RECORD_CHAR è di tipo varchar2(4000)

   INPUT:
                p_view          vista da cui leggere per creare il file
                p_file_name     nome del file
                p_dir           nome della directory Oracle in cui depositare il file
                orderby         se previsto ordinamento (ASC DESC NULL)
******************************************************************************/

    v_stmt          varchar2(32767);

begin

    v_stmt := '
    declare
        v_outfile       utl_file.file_type;
    begin
        v_outfile   := utl_file.fopen (''' || upper(p_dir) || ''', ''' || p_file_name || ''', ''w'');
        for r in (select record_char from ' || upper(p_view) || ''|| CASE WHEN orderby IS NULL THEN ' ' ELSE ' order by 1 ' || orderby END || ')
        loop
            utl_file.put_line (v_outfile, r.record_char, false);
            utl_file.fflush (v_outfile);
        end loop;
        commit;
        utl_file.fclose (v_outfile);
    end;';

    execute immediate v_stmt;


exception
   WHEN OTHERS THEN
            pkg_mcre0_log.spo_mcre0_log_evento(0,'PRC_QDC_SPOOL_TO_FILE','ERRORE' ,SUBSTR(SQLERRM, 1, 255));
            dbms_output.put_line(SUBSTR(SQLERRM, 1, 255));

end prc_qdc_spool_to_file;

end PKG_MCRE0_EXTRACT_QDC;
/


CREATE SYNONYM MCRE_APP.PKG_MCRE0_EXTRACT_QDC FOR MCRE_OWN.PKG_MCRE0_EXTRACT_QDC;


CREATE SYNONYM MCRE_USR.PKG_MCRE0_EXTRACT_QDC FOR MCRE_OWN.PKG_MCRE0_EXTRACT_QDC;


GRANT EXECUTE, DEBUG ON MCRE_OWN.PKG_MCRE0_EXTRACT_QDC TO MCRE_USR;

