/* Formatted on 21/07/2014 18:32:31 (QP5 v5.227.12220.39754) */
CREATE OR REPLACE FORCE VIEW MCRE_OWN.V_MCRE0_APP_ALERT_OD_INFERIORE
(
   VAL_ALERT,
   DTA_INS_ALERT,
   VAL_ORDINE_COLORE,
   COD_ABI_CARTOLARIZZATO,
   COD_ABI_ISTITUTO,
   COD_COMPARTO_POSIZIONE,
   COD_COMPARTO_UTENTE,
   COD_GRUPPO_ECONOMICO,
   COD_MACROSTATO,
   COD_NDG,
   COD_SNDG,
   COD_PROCESSO,
   VAL_ANA_GRE,
   COD_PRIV,
   COD_RAMO_CALCOLATO,
   COD_STATO,
   ID_REFERENTE,
   ID_UTENTE,
   COD_STRUTTURA_COMPETENTE_AR,
   COD_STRUTTURA_COMPETENTE_DC,
   COD_STRUTTURA_COMPETENTE_FI,
   COD_STRUTTURA_COMPETENTE_RG,
   DESC_STRUTTURA_COMPETENTE_AR,
   DESC_STRUTTURA_COMPETENTE_DC,
   DESC_STRUTTURA_COMPETENTE_FI,
   DESC_STRUTTURA_COMPETENTE_RG,
   DESC_NOME_CONTROPARTE,
   DESC_COGNOME,
   DESC_NOME,
   DESC_ISTITUTO,
   FLG_GESTORE_ABILITATO,
   DTA_DECORRENZA_STATO,
   COD_MICROTIPOLOGIA,
   DTA_CONFERMA,
   VAL_OD_CALCOLATO,
   VAL_OD_EFFETTIVO,
   COD_PROTOCOLLO_PACCHETTO,
   COD_PROTOCOLLO_DELIBERA,
   VAL_UTI_TOT
)
AS
   SELECT DISTINCT
          al.alert AS val_alert,
          al.dta_ins AS dta_ins_alert,
          val_ordine_colore,
          ad.cod_abi_cartolarizzato,
          ad.cod_abi_istituto,
          NVL (ad.cod_comparto_assegnato, cod_comparto_calcolato)
             AS cod_comparto_posizione,
          u.cod_comparto_utente,
          ad.cod_gruppo_economico cod_gruppo_economico,
          ad.cod_macrostato,
          ad.cod_ndg,
          ad.cod_sndg,
          ad.cod_processo,
          ad.desc_gruppo_economico val_ana_gre,
          u.cod_priv,
          ad.cod_ramo_calcolato,
          ad.cod_stato,
          u.id_referente,
          ad.id_utente,
          o.cod_struttura_competente_ar,
          o.cod_struttura_competente_dc,
          o.cod_struttura_competente_fi,
          o.cod_struttura_competente_rg,
          o.desc_struttura_competente_ar,
          o.desc_struttura_competente_dc,
          o.desc_struttura_competente_fi,
          o.desc_struttura_competente_rg,
          ad.desc_nome_controparte,
          u.cognome desc_cognome,
          u.nome desc_nome,
          ad.desc_istituto,
          u.flg_gestore_abilitato,
          ad.dta_decorrenza_stato,
          d.cod_microtipologia_delib cod_microtipologia,
          d.dta_conferma_delibera dta_conferma,
          d.cod_organo_calcolato val_od_calcolato,
          d.cod_organo_deliberante val_od_effettivo,
          d.cod_protocollo_pacchetto cod_protocollo_pacchetto,
          d.cod_protocollo_delibera cod_protocollo_delibera,
          ad.SCSB_UTI_TOT VAL_UTI_TOT
     FROM t_mcrei_app_alert_pos_wrk PARTITION (inc_p39) al,
          t_mcre0_app_all_data PARTITION (ccp_p1) ad,
          t_mcre0_app_utenti u,
          mv_mcre0_denorm_str_org o,
          t_mcrei_app_delibere d,
          t_mcre0_cl_org_delib cal,
          t_mcre0_cl_org_delib del
    WHERE     al.cod_abi = ad.cod_abi_cartolarizzato
          AND al.cod_ndg = ad.cod_ndg
          AND al.cod_abi = d.cod_abi
          AND al.cod_ndg = d.cod_ndg
          AND ad.id_utente = u.id_utente
          AND ad.cod_abi_cartolarizzato = o.cod_abi_istituto_fi(+)
          AND ad.cod_filiale = o.cod_struttura_competente_fi(+)
          AND d.cod_abi = cal.cod_abi(+)
          AND d.cod_organo_calcolato = cal.cod_organo_deliberante(+)
          AND d.cod_abi = del.cod_abi(+)
          AND d.cod_organo_deliberante = del.cod_organo_deliberante(+)
          AND del.val_progr_organo_deliberante <
                 cal.val_progr_organo_deliberante ---od inferiore rispetto a quello calcolato
          AND ad.today_flg = '1'
          AND ad.cod_macrostato IN ('IN', 'RS')
          AND ad.flg_outsourcing = 'Y'
          AND ad.flg_target = 'Y'
          AND d.cod_microtipologia_delib NOT IN ('CI', 'CS')
          AND d.cod_fase_delibera = 'CO'
          AND d.cod_tipo_pacchetto = 'M'
          AND d.flg_no_delibera = 0
          AND d.flg_attiva = '1';
