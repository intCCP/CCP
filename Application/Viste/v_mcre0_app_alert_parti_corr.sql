/* Formatted on 21/07/2014 18:32:33 (QP5 v5.227.12220.39754) */
CREATE OR REPLACE FORCE VIEW MCRE_OWN.V_MCRE0_APP_ALERT_PARTI_CORR
(
   COD_ABI_CARTOLARIZZATO,
   COD_ABI_ISTITUTO,
   COD_COMPARTO_POSIZIONE,
   COD_COMPARTO_UTENTE,
   COD_GRUPPO_ECONOMICO,
   COD_MACROSTATO,
   COD_NDG,
   COD_PRIV,
   COD_PROCESSO,
   COD_RAMO_CALCOLATO,
   COD_SNDG,
   COD_STATO,
   COD_STRUTTURA_COMPETENTE_AR,
   COD_STRUTTURA_COMPETENTE_DC,
   COD_STRUTTURA_COMPETENTE_FI,
   COD_STRUTTURA_COMPETENTE_RG,
   COGNOME,
   DESC_ISTITUTO,
   NOME,
   DESC_NOME_CONTROPARTE,
   DESC_STRUTTURA_COMPETENTE_AR,
   DESC_STRUTTURA_COMPETENTE_DC,
   DESC_STRUTTURA_COMPETENTE_FI,
   DESC_STRUTTURA_COMPETENTE_RG,
   DTA_DECORRENZA_STATO,
   DTA_INS_ALERT,
   DTA_SCADENZA_STATO,
   DTA_UTENTE_ASSEGNATO,
   FLG_GESTORE_ABILITATO,
   ID_REFERENTE,
   ID_UTENTE,
   VAL_ALERT,
   COD_GRUPPO_SUPER,
   COD_STATO_PROV,
   VAL_ANA_GRE,
   VAL_UTI_TOT,
   VAL_ORDINE_COLORE,
   FLG_ABI_LAVORATO
)
AS
   SELECT ad.cod_abi_cartolarizzato,
          ad.cod_abi_istituto,
          ad.cod_comparto_assegnato AS cod_comparto_posizione,
          ad.cod_comparto_utente,
          ad.cod_gruppo_economico,
          ad.cod_macrostato,
          ad.cod_ndg,
          ad.cod_priv,
          ad.cod_processo,
          ad.cod_ramo_calcolato,
          ad.cod_sndg,
          ad.cod_stato,
          ad.cod_struttura_competente_ar,
          ad.cod_struttura_competente_dc,
          ad.cod_struttura_competente_fi,
          ad.cod_struttura_competente_rg,
          ad.cognome,
          ad.desc_istituto,
          ad.nome,
          ad.desc_nome_controparte,
          ad.desc_struttura_competente_ar,
          ad.desc_struttura_competente_dc,
          ad.desc_struttura_competente_fi,
          ad.desc_struttura_competente_rg,
          AD.DTA_DECORRENZA_STATO,
          ad.dta_ins AS DTA_INS_ALERT,
          ad.dta_scadenza_stato,
          ad.dta_utente_assegnato,
          ad.flg_gestore_abilitato,
          AD.ID_REFERENTE,
          AD.ID_UTENTE,
          V.VAL_ALERT,
          AD.COD_GRUPPO_SUPER,
          AD.COD_STATO_PRECEDENTE AS COD_STATO_PROV,
          NULL AS VAL_ANA_GRE,
          NULL AS VAL_UTI_TOT,
          DECODE (V.VAL_ALERT, 'R', 9) AS VAL_ORDINE_COLORE,
          DECODE (
             dta_abi_elab,
             (SELECT MAX (dta_abi_elab) dta_abi_elab_max
                FROM t_mcre0_app_abi_elaborati), '1',
             '0')
             AS flg_abi_lavorato
     FROM V_MCRE0_APP_UPD_FIELDS AD,
          V_MCRE0_WRK_ALERT_PARTI_CORR V,
          T_MCREI_APP_ALERT_POS_WRK W,
          T_MCREI_APP_ALERT_FLG_PR_VIS PV
    WHERE     AD.COD_ABI_CARTOLARIZZATO = V.COD_ABI
          AND AD.COD_NDG = V.COD_NDG
          AND AD.COD_ABI_CARTOLARIZZATO = W.COD_ABI
          AND AD.COD_NDG = W.COD_NDG
          AND W.ID_ALERT = 48
          AND W.COD_NDG = PV.COD_NDG(+)
          AND W.COD_ABI = PV.COD_ABI(+)
          AND W.ID_ALERT = PV.ID_ALERT(+)
          AND TRUNC (NVL (PV.DTA_PR_VIS, TO_DATE ('01011000', 'DDMMYYYY'))) <=
                 TRUNC (W.DTA_INS);
