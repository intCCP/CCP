/* Formatted on 21/07/2014 18:37:45 (QP5 v5.227.12220.39754) */
CREATE OR REPLACE FORCE VIEW MCRE_OWN.V_MCRE0_ST_EMAIL
(
   ID_DPER,
   COD_TIPO_REC,
   DESC_REC,
   TS_AGGIORN,
   COD_SOC_GDR,
   DESC_SOC_GDR,
   COD_TIP_DIP,
   COD_MATRIC,
   VAL_COGNOME,
   VAL_NOME,
   COD_POS_ORG,
   DESC_POS_ORG,
   COD_PRF_SIC,
   DESC_PRF_SIC,
   DTA_PRFSINI,
   DTA_PRFSFIN,
   COD_MATR_PS,
   COD_TIPUOPS,
   COD_SOCPSPO,
   COD_UO_PSPO,
   DESC_UO_PSPO,
   COD_LOPUOPS,
   COD_SOCW2K,
   COD_UOW2K,
   ID_SN_W2K,
   COD_SOCPSS1,
   COD_UO_PSS1,
   DESC_UO_PSS1,
   COD_SOCPSS2,
   COD_UO_PSS2,
   DESC_UO_PSS2,
   COD_SOCPSS3,
   COD_UO_PSS3,
   DESC_UO_PSS3,
   COD_SOCPSS4,
   COD_UO_PSS4,
   COD_SOCPSS5,
   COD_UO_PSS5,
   COD_SOCPSS6,
   COD_UO_PSS6,
   COD_SOCPSS7,
   COD_UO_PSS7,
   COD_SOCSOST,
   COD_UO_SOST,
   DESC_UO_SOST,
   COD_PO_SOST,
   COD_PS_SOST,
   DESC_PS_SOST,
   DTA_SOSTINI,
   DTA_SOSTFIN,
   COD_SOCASS,
   COD_UO_ASS,
   DESC_UO_ASS,
   DTA_ASSINI,
   DTA_ASSFIN,
   COD_PO_ASS,
   DTA_POINASS,
   DTA_POFIASS,
   COD_SOCODIS,
   COD_UO_DIS,
   DESC_UO_DIS,
   DTA_DISINI,
   DTA_DISFIN,
   COD_PO_DIS,
   DTA_POINDIS,
   DTA_POFIDIS,
   COD_TIP_PAL,
   COD_SOCPAL,
   COD_UO_PAL,
   DESC_UO_PAL,
   INDIRIZZO,
   CITTA,
   CAP,
   PROVINCIA,
   COD_NAZIONE,
   ID_SESSO,
   COD_FISCALE,
   DTA_ASSUNZ,
   DTA_CESSAZ,
   COD_GRADO,
   DTA_GRADO,
   COD_UFFICIO,
   COD_RUOLO,
   VAL_TEL_UFF,
   VAL_TEL_CEL,
   VAL_FAX,
   AN_STANZAT,
   COD_APP_GR1,
   COD_APP_GR2,
   COD_APP_GR3,
   COD_APP_GR4,
   COD_DG_OLD,
   COD_DG_NEW,
   VAL_EMAIL,
   COD_PSIGAP,
   DESC_PO_ASS,
   DESC_PO_DIS,
   FL_RESPON,
   FLAGD,
   COD_INC,
   COD_UOINC,
   COD_GRUPPO,
   COD_AZIENDA,
   COD_MATR_10,
   FL_EML_SIC
)
AS
   WITH T_MCRE0_FL_EMAIL
        AS (SELECT (SELECT TO_NUMBER (
                              TO_CHAR (
                                 TO_DATE (TRIM (PERIODO_RIF), 'DDMMYYYY'),
                                 'YYYYMMDD'))
                      FROM TE_MCRE0_RUBR_IDT
                     WHERE ROWNUM = 1)
                      ID_DPER,
                   cod_tipo_rec,
                   desc_rec,
                   ts_aggiorn,
                   cod_soc_gdr,
                   desc_soc_gdr,
                   cod_tip_dip,
                   cod_utenza || cod_matric AS cod_matric,
                   val_cognome,
                   val_nome,
                   cod_pos_org,
                   desc_pos_org,
                   cod_prf_sic,
                   desc_prf_sic,
                   TO_DATE (dta_prfsini, 'yyyymmdd') AS dta_prfsini,
                   TO_DATE (dta_prfsfin, 'yyyymmdd') AS dta_prfsfin,
                   cod_matr_ps,
                   cod_tipuops,
                   cod_socpspo,
                   cod_uo_pspo,
                   desc_uo_pspo,
                   cod_lopuops,
                   cod_socw2k,
                   cod_uow2k,
                   id_sn_w2k,
                   cod_socpss1,
                   cod_uo_pss1,
                   desc_uo_pss1,
                   cod_socpss2,
                   cod_uo_pss2,
                   desc_uo_pss2,
                   cod_socpss3,
                   cod_uo_pss3,
                   desc_uo_pss3,
                   cod_socpss4,
                   cod_uo_pss4,
                   cod_socpss5,
                   cod_uo_pss5,
                   cod_socpss6,
                   cod_uo_pss6,
                   cod_socpss7,
                   cod_uo_pss7,
                   cod_socsost,
                   cod_uo_sost,
                   desc_uo_sost,
                   cod_po_sost,
                   cod_ps_sost,
                   desc_ps_sost,
                   TO_DATE (dta_sostini, 'yyyymmdd') AS dta_sostini,
                   TO_DATE (dta_sostfin, 'yyyymmdd') AS dta_sostfin,
                   cod_socass,
                   cod_uo_ass,
                   desc_uo_ass,
                   TO_DATE (dta_assini, 'yyyymmdd') AS dta_assini,
                   TO_DATE (dta_assfin, 'yyyymmdd') AS dta_assfin,
                   cod_po_ass,
                   TO_DATE (dta_poinass, 'yyyymmdd') AS dta_poinass,
                   TO_DATE (dta_pofiass, 'yyyymmdd') AS dta_pofiass,
                   cod_socodis,
                   cod_uo_dis,
                   desc_uo_dis,
                   TO_DATE (dta_disini, 'yyyymmdd') AS dta_disini,
                   TO_DATE (dta_disfin, 'yyyymmdd') AS dta_disfin,
                   cod_po_dis,
                   TO_DATE (dta_poindis, 'yyyymmdd') AS dta_poindis,
                   TO_DATE (dta_pofidis, 'yyyymmdd') AS dta_pofidis,
                   cod_tip_pal,
                   cod_socpal,
                   cod_uo_pal,
                   desc_uo_pal,
                   indirizzo,
                   citta,
                   cap,
                   provincia,
                   cod_nazione,
                   id_sesso,
                   cod_fiscale,
                   TO_DATE (dta_assunz, 'yyyymmdd') AS dta_assunz,
                   TO_DATE (dta_cessaz, 'yyyymmdd') AS dta_cessaz,
                   cod_grado,
                   TO_DATE (dta_grado, 'yyyymmdd') AS dta_grado,
                   cod_ufficio,
                   cod_ruolo,
                   val_tel_uff,
                   val_tel_cel,
                   val_fax,
                   an_stanzat,
                   cod_app_gr1,
                   cod_app_gr2,
                   cod_app_gr3,
                   cod_app_gr4,
                   cod_dg_old,
                   cod_dg_new,
                   val_email,
                   cod_psigap,
                   desc_po_ass,
                   desc_po_dis,
                   fl_respon,
                   flagd,
                   cod_inc,
                   cod_uoinc,
                   cod_gruppo,
                   cod_azienda,
                   cod_matr_10,
                   fl_eml_sic
              FROM TE_MCRE0_RUBR_INC
             WHERE     fnd_mcre0_is_date (dta_prfsini) = 1
                   AND fnd_mcre0_is_date (dta_prfsfin) = 1
                   AND fnd_mcre0_is_date (dta_sostini) = 1
                   AND fnd_mcre0_is_date (dta_sostfin) = 1
                   AND fnd_mcre0_is_date (dta_assini) = 1
                   AND fnd_mcre0_is_date (dta_assfin) = 1
                   AND fnd_mcre0_is_date (dta_poinass) = 1
                   AND fnd_mcre0_is_date (dta_pofiass) = 1
                   AND fnd_mcre0_is_date (dta_disini) = 1
                   AND fnd_mcre0_is_date (dta_disfin) = 1
                   AND fnd_mcre0_is_date (dta_poindis) = 1
                   AND fnd_mcre0_is_date (dta_pofidis) = 1
                   AND fnc_mcrei_is_date (dta_assunz, 'yyyymmdd') = 1
                   AND fnd_mcre0_is_date (dta_cessaz) = 1
                   AND fnd_mcre0_is_date (dta_grado) = 1)
   SELECT "ID_DPER",
          "COD_TIPO_REC",
          "DESC_REC",
          "TS_AGGIORN",
          "COD_SOC_GDR",
          "DESC_SOC_GDR",
          "COD_TIP_DIP",
          "COD_MATRIC",
          "VAL_COGNOME",
          "VAL_NOME",
          "COD_POS_ORG",
          "DESC_POS_ORG",
          "COD_PRF_SIC",
          "DESC_PRF_SIC",
          "DTA_PRFSINI",
          "DTA_PRFSFIN",
          "COD_MATR_PS",
          "COD_TIPUOPS",
          "COD_SOCPSPO",
          "COD_UO_PSPO",
          "DESC_UO_PSPO",
          "COD_LOPUOPS",
          "COD_SOCW2K",
          "COD_UOW2K",
          "ID_SN_W2K",
          "COD_SOCPSS1",
          "COD_UO_PSS1",
          "DESC_UO_PSS1",
          "COD_SOCPSS2",
          "COD_UO_PSS2",
          "DESC_UO_PSS2",
          "COD_SOCPSS3",
          "COD_UO_PSS3",
          "DESC_UO_PSS3",
          "COD_SOCPSS4",
          "COD_UO_PSS4",
          "COD_SOCPSS5",
          "COD_UO_PSS5",
          "COD_SOCPSS6",
          "COD_UO_PSS6",
          "COD_SOCPSS7",
          "COD_UO_PSS7",
          "COD_SOCSOST",
          "COD_UO_SOST",
          "DESC_UO_SOST",
          "COD_PO_SOST",
          "COD_PS_SOST",
          "DESC_PS_SOST",
          "DTA_SOSTINI",
          "DTA_SOSTFIN",
          "COD_SOCASS",
          "COD_UO_ASS",
          "DESC_UO_ASS",
          "DTA_ASSINI",
          "DTA_ASSFIN",
          "COD_PO_ASS",
          "DTA_POINASS",
          "DTA_POFIASS",
          "COD_SOCODIS",
          "COD_UO_DIS",
          "DESC_UO_DIS",
          "DTA_DISINI",
          "DTA_DISFIN",
          "COD_PO_DIS",
          "DTA_POINDIS",
          "DTA_POFIDIS",
          "COD_TIP_PAL",
          "COD_SOCPAL",
          "COD_UO_PAL",
          "DESC_UO_PAL",
          "INDIRIZZO",
          "CITTA",
          "CAP",
          "PROVINCIA",
          "COD_NAZIONE",
          "ID_SESSO",
          "COD_FISCALE",
          "DTA_ASSUNZ",
          "DTA_CESSAZ",
          "COD_GRADO",
          "DTA_GRADO",
          "COD_UFFICIO",
          "COD_RUOLO",
          "VAL_TEL_UFF",
          "VAL_TEL_CEL",
          "VAL_FAX",
          "AN_STANZAT",
          "COD_APP_GR1",
          "COD_APP_GR2",
          "COD_APP_GR3",
          "COD_APP_GR4",
          "COD_DG_OLD",
          "COD_DG_NEW",
          "VAL_EMAIL",
          "COD_PSIGAP",
          "DESC_PO_ASS",
          "DESC_PO_DIS",
          "FL_RESPON",
          "FLAGD",
          "COD_INC",
          "COD_UOINC",
          "COD_GRUPPO",
          "COD_AZIENDA",
          "COD_MATR_10",
          "FL_EML_SIC"
     FROM (SELECT COUNT (1) OVER (PARTITION BY id_dper, cod_matric) num_recs,
                  id_dper,
                  cod_tipo_rec,
                  desc_rec,
                  ts_aggiorn,
                  cod_soc_gdr,
                  desc_soc_gdr,
                  cod_tip_dip,
                  cod_matric,
                  val_cognome,
                  val_nome,
                  cod_pos_org,
                  desc_pos_org,
                  cod_prf_sic,
                  desc_prf_sic,
                  dta_prfsini,
                  dta_prfsfin,
                  cod_matr_ps,
                  cod_tipuops,
                  cod_socpspo,
                  cod_uo_pspo,
                  desc_uo_pspo,
                  cod_lopuops,
                  cod_socw2k,
                  cod_uow2k,
                  id_sn_w2k,
                  cod_socpss1,
                  cod_uo_pss1,
                  desc_uo_pss1,
                  cod_socpss2,
                  cod_uo_pss2,
                  desc_uo_pss2,
                  cod_socpss3,
                  cod_uo_pss3,
                  desc_uo_pss3,
                  cod_socpss4,
                  cod_uo_pss4,
                  cod_socpss5,
                  cod_uo_pss5,
                  cod_socpss6,
                  cod_uo_pss6,
                  cod_socpss7,
                  cod_uo_pss7,
                  cod_socsost,
                  cod_uo_sost,
                  desc_uo_sost,
                  cod_po_sost,
                  cod_ps_sost,
                  desc_ps_sost,
                  dta_sostini,
                  dta_sostfin,
                  cod_socass,
                  cod_uo_ass,
                  desc_uo_ass,
                  dta_assini,
                  dta_assfin,
                  cod_po_ass,
                  dta_poinass,
                  dta_pofiass,
                  cod_socodis,
                  cod_uo_dis,
                  desc_uo_dis,
                  dta_disini,
                  dta_disfin,
                  cod_po_dis,
                  dta_poindis,
                  dta_pofidis,
                  cod_tip_pal,
                  cod_socpal,
                  cod_uo_pal,
                  desc_uo_pal,
                  indirizzo,
                  citta,
                  cap,
                  provincia,
                  cod_nazione,
                  id_sesso,
                  cod_fiscale,
                  dta_assunz,
                  dta_cessaz,
                  cod_grado,
                  dta_grado,
                  cod_ufficio,
                  cod_ruolo,
                  val_tel_uff,
                  val_tel_cel,
                  val_fax,
                  an_stanzat,
                  cod_app_gr1,
                  cod_app_gr2,
                  cod_app_gr3,
                  cod_app_gr4,
                  cod_dg_old,
                  cod_dg_new,
                  val_email,
                  cod_psigap,
                  desc_po_ass,
                  desc_po_dis,
                  fl_respon,
                  flagd,
                  cod_inc,
                  cod_uoinc,
                  cod_gruppo,
                  cod_azienda,
                  cod_matr_10,
                  fl_eml_sic
             FROM T_MCRE0_FL_EMAIL) tmp
    WHERE     NUM_RECS = 1
          AND TRIM (TO_CHAR (id_dper)) IS NOT NULL
          AND TRIM (TO_CHAR (cod_matric)) IS NOT NULL;
