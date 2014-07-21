/* Formatted on 21/07/2014 18:34:36 (QP5 v5.227.12220.39754) */
CREATE OR REPLACE FORCE VIEW MCRE_OWN.V_MCRE0_APP_PRATICA_LEGALE
(
   COD_ISTITUTO,
   DESC_ISTITUTO,
   COD_NDG,
   COD_SNDG,
   DESC_NOME_CONTROPARTE,
   COD_DIREZIONE,
   DESC_DIREZIONE,
   COD_DIVISIONE,
   DESC_DIVISIONE,
   COD_REGIONE,
   DESC_REGIONE,
   COD_AREA,
   DESC_AREA,
   COD_FILIALE,
   DESC_FILIALE,
   COD_UO,
   COD_STATO_PRATICA,
   COD_TIPO_RISCHIO,
   VAL_ANNO,
   COD_NUMERO_PRATICA,
   COD_MATRICOLA,
   DTA_APERTURA,
   DTA_SCADENZA,
   COD_TIPO_GESTIONE,
   DESC_INTESTAZIONE,
   DESC_ADDETTO
)
AS
   SELECT p.cod_abi AS cod_istituto,
          ad.desc_istituto,
          p.cod_ndg,
          p.cod_sndg,
          ad.desc_nome_controparte,
          d.cod_struttura_competente_dc cod_direzione,
          d.desc_struttura_competente_dc desc_direzione,
          d.cod_struttura_competente_dv cod_divisione,
          d.desc_struttura_competente_dv desc_divisione,
          d.cod_struttura_competente_rg cod_regione,
          d.desc_struttura_competente_rg desc_regione,
          d.cod_struttura_competente_ar cod_area,
          d.desc_struttura_competente_ar desc_area,
          d.cod_struttura_competente_fi cod_filiale,
          d.desc_struttura_competente_fi desc_filiale,
          p.cod_uo_pratica cod_uo,
          DECODE (p.dta_chiusura, TO_DATE ('99991231', 'yyyymmdd'), 'A', 'C')
             cod_stato_pratica,
          ad.cod_stato cod_tipo_rischio,
          p.val_anno_pratica val_anno,
          p.cod_pratica cod_numero_pratica,
          p.cod_matr_pratica cod_matricola,
          p.dta_apertura dta_apertura,
          ad.dta_scadenza_stato dta_scadenza,
          p.cod_tipo_gestione cod_tipo_gestione,
          ad.desc_nome_controparte desc_intestazione,
          (SELECT u.cognome
             FROM t_mcre0_app_utenti u
            WHERE u.cod_matricola = p.cod_matr_pratica)
             desc_addetto
     FROM mv_mcre0_denorm_str_org d,
          t_mcre0_app_all_data ad,
          t_mcrei_app_pratiche p
    WHERE     d.cod_struttura_competente_fi = ad.cod_filiale
          AND d.cod_abi_istituto_fi = ad.cod_abi_istituto
          AND ad.flg_outsourcing = 'Y'
          AND ad.cod_stato IN ('IN', 'SO')
          AND ad.flg_active = '1'
          AND ad.flg_target = 'Y'
          AND p.cod_abi = ad.cod_abi_cartolarizzato
          AND p.cod_ndg = ad.cod_ndg
          AND p.flg_attiva = '1'
          AND p.cod_tipo_gestione IN ('F', 'A', 'AD', 'S', 'SD')
   UNION ALL
   SELECT p.cod_abi AS cod_istituto,
          ad.desc_istituto,
          p.cod_ndg,
          p.cod_sndg,
          ad.desc_nome_controparte,
          d.cod_struttura_competente_dc cod_direzione,
          d.desc_struttura_competente_dc desc_direzione,
          d.cod_struttura_competente_dv cod_divisione,
          d.desc_struttura_competente_dv desc_divisione,
          d.cod_struttura_competente_rg cod_regione,
          d.desc_struttura_competente_rg desc_regione,
          d.cod_struttura_competente_ar cod_area,
          d.desc_struttura_competente_ar desc_area,
          d.cod_struttura_competente_fi cod_filiale,
          d.desc_struttura_competente_fi desc_filiale,
          p.cod_uo_pratica cod_uo,
          DECODE (p.dta_chiusura, TO_DATE ('99991231', 'yyyymmdd'), 'A', 'C')
             cod_stato_pratica,
          ad.cod_stato cod_tipo_rischio,
          p.val_anno_pratica val_anno,
          p.cod_pratica cod_numero_pratica,
          p.cod_matr_pratica cod_matricola,
          p.dta_apertura dta_apertura,
          ad.dta_scadenza_stato dta_scadenza,
          p.cod_tipo_gestione cod_tipo_gestione,
          ad.desc_nome_controparte desc_intestazione,
          (SELECT u.cognome
             FROM t_mcre0_app_utenti u
            WHERE u.cod_matricola = p.cod_matr_pratica)
             desc_addetto
     FROM mv_mcre0_denorm_str_org d,
          t_mcre0_app_all_data ad,
          t_mcrei_hst_pratiche p
    WHERE     d.cod_struttura_competente_fi = ad.cod_filiale
          AND d.cod_abi_istituto_fi = ad.cod_abi_istituto
          AND ad.flg_outsourcing = 'Y'
          AND ad.cod_stato IN ('IN', 'SO')
          AND ad.flg_active = '1'
          AND ad.flg_target = 'Y'
          AND p.cod_abi = ad.cod_abi_cartolarizzato
          AND p.cod_ndg = ad.cod_ndg
          AND p.flg_attiva = '0'
          AND p.cod_tipo_gestione IN ('F', 'A', 'AD', 'S', 'SD');
