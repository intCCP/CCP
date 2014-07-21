/* Formatted on 17/06/2014 17:59:58 (QP5 v5.227.12220.39754) */
CREATE OR REPLACE FORCE VIEW MCRE_OWN.V_MCRE0_APP_AL_DELIB_DACONF_BR
(
   DTA_INS_ALERT,
   VAL_ORDINE_COLORE,
   STRUTT_COMPETENTE,
   COD_SNDG,
   COD_ABI_CARTOLARIZZATO,
   COD_ABI_ISTITUTO,
   COD_NDG,
   COD_MACROSTATO,
   DESC_NOME_CONTROPARTE,
   VAL_ALERT,
   DTA_INS_DELIBERA,
   COD_GRUPPO_ECONOMICO,
   DESC_DENOM_GRUPPO,
   VAL_ANA_GRE,
   DIREZ_REGIONALE,
   COD_AREA,
   COD_FILIALE,
   COD_PROCESSO,
   COD_COMPARTO_POSIZIONE,
   COD_COMPARTO_UTENTE,
   COD_STATO,
   COD_STATO_PROPOSTO,
   COD_GESTORE,
   DTA_CONFERMA_PACCHETTO,
   COD_MICRO_TIPOL,
   COD_PROTOCOLLO_DELIBERA,
   COD_OD_CALCOLATO,
   DESC_OD_CALCOLATO,
   COD_STRUTTURA_COMPETENTE_AR,
   COD_STRUTTURA_COMPETENTE_DC,
   COD_STRUTTURA_COMPETENTE_FI,
   COD_STRUTTURA_COMPETENTE_RG,
   DESC_STRUTTURA_COMPETENTE_AR,
   DESC_STRUTTURA_COMPETENTE_DC,
   DESC_STRUTTURA_COMPETENTE_FI,
   DESC_STRUTTURA_COMPETENTE_RG,
   DESC_COGNOME,
   DESC_ISTITUTO,
   DESC_NOME,
   FLG_GESTORE_ABILITATO,
   ID_REFERENTE,
   ID_UTENTE,
   COD_PRIV,
   COD_RAMO_CALCOLATO,
   VAL_UTI_TOT
)
AS
   SELECT /*+ index(a pkt_mcre0_app_all_data)   index(d IAM_T_MCREI_APP_DELIBERE) */
         pw.dta_ins AS dta_ins_alert,
          pw.val_ordine_colore,
          a.cod_struttura_competente AS strutt_competente,
          d.cod_sndg,
          a.cod_abi_cartolarizzato,
          a.cod_abi_istituto,
          d.cod_ndg,
          a.cod_macrostato,
          a.desc_nome_controparte,
          pw.alert AS val_alert,
          d.dta_ins_delibera,
          a.cod_gruppo_economico,
          a.desc_gruppo_economico AS desc_denom_gruppo,
          a.desc_gruppo_economico AS val_ana_gre,
          a.cod_struttura_competente_rg,
          a.cod_struttura_competente_ar AS cod_area,
          a.cod_filiale,
          a.cod_processo,
          a.cod_comparto_assegnato AS cod_comparto_posizione,
          a.cod_comparto_utente,
          a.cod_stato,
          DECODE (cod_microtipologia_delib,  'CI', 'IN',  'CS', 'SO',  NULL)
             AS cod_stato_proposto,
          a.id_utente AS cod_gestore,
          d.dta_conferma_pacchetto,
          d.cod_microtipologia_delib AS cod_micro_tipol,
          pw.cod_protocollo_delibera,
          DECODE (d.cod_organo_calcolato, '-1', 'ND', d.cod_organo_calcolato)
             AS cod_od_calcolato,
          o.desc_organo_deliberante AS desc_od_calcolato,
          a.cod_struttura_competente_ar,
          a.cod_struttura_competente_dc,
          a.cod_struttura_competente_fi,
          a.cod_struttura_competente_rg,
          a.desc_struttura_competente_ar,
          a.desc_struttura_competente_dc,
          a.desc_struttura_competente_fi,
          a.desc_struttura_competente_rg,
          a.cognome AS desc_cognome,
          a.desc_istituto,
          a.nome AS desc_nome,
          a.flg_gestore_abilitato,
          a.id_referente,
          a.id_utente,
          a.cod_priv,
          a.cod_ramo_calcolato,
          a.SCSB_UTI_TOT VAL_UTI_TOT
     FROM t_mcrei_app_alert_pos_wrk PARTITION (inc_p06) pw,
          t_mcrei_app_delibere d,
          v_mcre0_app_upd_fields a,
          t_mcre0_cl_organi_deliberanti o
    WHERE     pw.cod_abi = a.cod_abi_cartolarizzato
          AND pw.cod_ndg = a.cod_ndg
          AND pw.cod_abi = d.cod_abi
          AND pw.cod_ndg = d.cod_ndg
          AND pw.cod_protocollo_delibera = d.cod_protocollo_delibera --AD: 2 aprile, si visualizzano tutte le delibere in attesa di conferma
          AND d.cod_fase_delibera NOT IN ('CO', 'CA')              ---2 aprile
          AND d.cod_fase_pacchetto = 'CNF'
          AND d.cod_fase_microtipologia = 'ATT'
          AND a.flg_outsourcing = 'Y'
          AND a.flg_target = 'Y'
          AND d.cod_organo_calcolato = o.cod_organo_deliberante(+)
          AND d.cod_abi = o.cod_abi_istituto(+)
          AND d.flg_no_delibera = 0
          AND d.flg_attiva = '1';


GRANT DELETE, INSERT, REFERENCES, SELECT, UPDATE, ON COMMIT REFRESH, QUERY REWRITE, DEBUG, FLASHBACK, MERGE VIEW ON MCRE_OWN.V_MCRE0_APP_AL_DELIB_DACONF_BR TO MCRE_USR;
