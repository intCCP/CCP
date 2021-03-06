/* Formatted on 21/07/2014 18:34:02 (QP5 v5.227.12220.39754) */
CREATE OR REPLACE FORCE VIEW MCRE_OWN.V_MCRE0_APP_GEST_PDF
(
   ID_OBJECT,
   ID_PDF,
   DTA_INS,
   DESC_ISTITUTO,
   COD_ABI_CARTOLARIZZATO,
   DESC_NOME_CONTROPARTE,
   COD_NDG,
   COD_SNDG,
   COD_STRUTTURA_COMPETENTE_AR,
   DESC_STRUTTURA_COMPETENTE_AR,
   COD_STRUTTURA_COMPETENTE_FI,
   DESC_STRUTTURA_COMPETENTE_FI,
   SCSB_ACC_CASSA_BT_AT,
   SCSB_UTI_CASSA_BT_AT,
   SCSB_ACC_SMOBILIZZO_AT,
   SCSB_UTI_SMOBILIZZO_AT,
   SCSB_ACC_CASSA_MLT_AT,
   SCSB_UTI_CASSA_MLT_AT,
   SCSB_ACC_FIRMA_AT,
   SCSB_UTI_FIRMA_AT,
   SCSB_ACC_TOT_AT,
   SCSB_UTI_TOT_AT,
   SCSB_TOT_GAR_AT,
   SCSB_ACC_SOSTITUZIONI_AT,
   SCSB_UTI_SOSTITUZIONI_AT,
   SCSB_ACC_MASSIMALI_AT,
   SCSB_UTI_MASSIMALI_AT,
   DTA_PCR_AT,
   DTA_CR_AT,
   VAL_MESE_1,
   VAL_LR_MESE_1,
   VAL_MESE_2,
   VAL_LR_MESE_2,
   VAL_MESE_3,
   VAL_LR_MESE_3,
   VAL_MESE_4,
   VAL_LR_MESE_4,
   VAL_MESE_5,
   VAL_LR_MESE_5,
   VAL_MESE_6,
   VAL_LR_MESE_6,
   VAL_MESE_7,
   VAL_LR_MESE_7,
   DTA_RIF_IRIS,
   RATING_ONLINE,
   DTA_SCAD_REVISIONE_PEF,
   GESB_ACC_TOT_AT,
   GESB_UTI_TOT_AT,
   GEGB_UTI_TOT_AT,
   GEGB_ACC_TOT_AT,
   ID_ANOMALIA,
   ID_ADVISOR,
   ID_AZIONE,
   COD_STATO,
   COD_MACROSTATO,
   COD_MACROSTATO_DESTINAZIONE,
   NOTE_CLASSIFICAZIONE,
   FLG_LETTURA_VERBALE,
   COD_SEQUENCE_PROROGA,
   VAL_MOTIVO_ESITO,
   VAL_MOTIVO_RICHIESTA,
   SCGB_QIS_UTI,
   SCGB_QIS_ACC,
   SCGB_DTA_RIF_CR,
   VAL_UTENTE,
   COD_GRUPPO_ECONOMICO,
   VAL_ANA_GRE,
   FLG_DELETE,
   DESC_TIPO_OP
)
AS
   SELECT p.id_object,
          p.id_pdf,
          p.dta_ins,
          s.desc_istituto,
          p.cod_abi_cartolarizzato,
          s.desc_nome_controparte,
          p.cod_ndg,
          p.cod_sndg,
          p.cod_struttura_competente_ar,
          s.desc_struttura_competente_ar,
          p.cod_struttura_competente_fi,
          s.desc_struttura_competente_fi,
          p.scsb_acc_cassa_bt_at,
          p.scsb_uti_cassa_bt_at,
          p.scsb_acc_smobilizzo_at,
          p.scsb_uti_smobilizzo_at,
          p.scsb_acc_cassa_mlt_at,
          p.scsb_uti_cassa_mlt_at,
          p.scsb_acc_firma_at,
          p.scsb_uti_firma_at,
          p.scsb_acc_tot_at,
          p.scsb_uti_tot_at,
          p.scsb_tot_gar_at,
          p.scsb_acc_sostituzioni_at,
          p.scsb_uti_sostituzioni_at,
          p.scsb_acc_massimali_at,
          p.scsb_uti_massimali_at,
          p.dta_pcr_at,
          p.dta_cr_at,
          p.val_mese_1,
          p.val_lr_mese_1,
          p.val_mese_2,
          p.val_lr_mese_2,
          p.val_mese_3,
          p.val_lr_mese_3,
          p.val_mese_4,
          p.val_lr_mese_4,
          p.val_mese_5,
          p.val_lr_mese_5,
          p.val_mese_6,
          p.val_lr_mese_6,
          p.val_mese_7,
          p.val_lr_mese_7,
          p.dta_rif_iris,
          p.rating_online,
          p.dta_scad_revisione_pef,
          p.gesb_acc_tot_at,
          p.gesb_uti_tot_at,
          p.gegb_uti_tot_at,
          p.gegb_acc_tot_at,
          p.id_anomalia,
          p.id_advisor,
          p.id_azione,
          p.cod_stato,
          p.cod_macrostato,
          cod_macrostato_destinazione,
          note_classificazione,
          flg_lettura_verbale,
          cod_sequence_proroga,
          val_motivo_esito,
          val_motivo_richiesta,
          p.scgb_qis_uti,
          p.scgb_qis_acc,
          p.scgb_dta_rif_cr,
          p.val_utente,
          p.cod_gruppo_economico,
          p.val_ana_gre,
          p.flg_delete,
          p.desc_tipo_op
     FROM T_MCRE0_APP_GEST_PDF p, v_mcre0_app_scheda_anag s
    WHERE     p.cod_abi_cartolarizzato = s.cod_abi_cartolarizzato
          AND p.cod_ndg = s.cod_ndg;
