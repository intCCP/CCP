/* Formatted on 17/06/2014 18:00:04 (QP5 v5.227.12220.39754) */
CREATE OR REPLACE FORCE VIEW MCRE_OWN.V_MCRE0_APP_ALERT_DEL_DA_CONF
(
   COD_FASE_PACCHETTO,
   COD_FASE_MICROTIPOLOGIA,
   COD_FASE_DELIBERA,
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
   FLG_ABI_LAVORATO,
   FLG_GESTORE_ABILITATO,
   ID_REFERENTE,
   ID_UTENTE,
   VAL_ALERT,
   VAL_ANA_GRE,
   DTA_INS_STATO_PROPOSTO,
   COD_MICRO_TIPOL,
   DESC_MICRO_TIPOL,
   COD_PROTOCOLLO_PACCHETTO,
   VAL_NUM_DELIBERE,
   VAL_UTI_TOT,
   COD_GRUPPO_SUPER
)
AS
   SELECT                 -- 10/10/2012 cambiata logica a livello di pacchetto
         DISTINCT
          d.cod_fase_pacchetto,                        --D.cod_fase_pacchetto,
          MAX (d.cod_fase_microtipologia)
             OVER (PARTITION BY d.cod_sndg, d.cod_protocollo_pacchetto)
             AS cod_fase_microtipologia,
          --D.cod_fase_microtipologia,
          MAX (d.cod_fase_delibera)
             OVER (PARTITION BY d.cod_sndg, d.cod_protocollo_pacchetto)
             AS cod_fase_delibera,
          --D.cod_fase_delibera,
          ad.cod_abi_cartolarizzato,
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
          ad.dta_decorrenza_stato,
          pw.dta_ins AS dta_ins_alert,
          ad.dta_scadenza_stato,
          ad.dta_utente_assegnato,
          '1' AS flg_abi_lavorato,
          ad.flg_gestore_abilitato,
          ad.id_referente,
          ad.id_utente,
          pw.alert AS val_alert,
          ad.desc_gruppo_economico AS val_ana_gre,
          MAX (d.dta_ins_delibera)
             OVER (PARTITION BY d.cod_sndg, d.cod_protocollo_pacchetto)
             AS dta_ins_stato_proposto,
          MAX (d.cod_microtipologia_delib)
             OVER (PARTITION BY d.cod_sndg, d.cod_protocollo_pacchetto)
             AS cod_micro_tipol,
          MAX (tip.desc_microtipologia)
             OVER (PARTITION BY d.cod_sndg, d.cod_protocollo_pacchetto)
             AS desc_micro_tipol,
          d.cod_protocollo_pacchetto,
          --d.cod_protocollo_pacchetto AS cod_protocollo_pacchetto,
          pw.val_cnt_delibere AS val_num_delibere,
          AD.SCSB_UTI_TOT VAL_UTI_TOT,
          AD.COD_GRUPPO_SUPER
     FROM t_mcrei_app_delibere PARTITION (inc_pattive) d,
          t_mcrei_app_alert_pos_wrk PARTITION (inc_p03) pw,
          v_mcre0_app_upd_fields ad,
          t_mcrei_cl_tipologie tip
    WHERE     pw.cod_abi = ad.cod_abi_cartolarizzato
          AND pw.cod_ndg = ad.cod_ndg
          AND d.cod_abi = ad.cod_abi_cartolarizzato
          AND d.cod_ndg = ad.cod_ndg
          AND d.cod_fase_delibera NOT IN ('CO', 'AD', 'AN', 'AM', 'VA') --13dic
          AND d.cod_microtipologia_delib NOT IN ('CI', 'CS')
          AND cod_fase_pacchetto NOT IN ('CNF', 'ULT', 'ANA', 'ANM')   --13dic
          AND d.cod_microtipologia_delib = tip.cod_microtipologia
          AND d.flg_no_delibera = 0
          AND ad.cod_stato IN ('IN', 'RS')                              -- ???
          AND ad.flg_outsourcing = 'Y'
          AND ad.flg_target = 'Y'
          AND d.flg_no_delibera = 0
          AND d.flg_attiva = '1';


GRANT DELETE, INSERT, REFERENCES, SELECT, UPDATE, ON COMMIT REFRESH, QUERY REWRITE, DEBUG, FLASHBACK, MERGE VIEW ON MCRE_OWN.V_MCRE0_APP_ALERT_DEL_DA_CONF TO MCRE_USR;
