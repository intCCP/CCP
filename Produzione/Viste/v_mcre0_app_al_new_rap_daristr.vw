/* Formatted on 17/06/2014 17:59:59 (QP5 v5.227.12220.39754) */
CREATE OR REPLACE FORCE VIEW MCRE_OWN.V_MCRE0_APP_AL_NEW_RAP_DARISTR
(
   VAL_ALERT,
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
   DTA_INS_ALERT,
   DESC_COGNOME,
   DESC_ISTITUTO,
   DESC_NOME,
   DESC_NOME_CONTROPARTE,
   DESC_STRUTTURA_COMPETENTE_AR,
   DESC_STRUTTURA_COMPETENTE_DC,
   DESC_STRUTTURA_COMPETENTE_FI,
   DESC_STRUTTURA_COMPETENTE_RG,
   FLG_ABI_LAVORATO,
   FLG_GESTORE_ABILITATO,
   ID_REFERENTE,
   ID_UTENTE,
   VAL_ANA_GRE,
   VAL_ORDINE_COLORE,
   VAL_NUM_RAPPORTI,
   DTA_DECORRENZA_RISTRUTT,
   COD_PROTOCOLLO_PACCHETTO,
   COD_PROTOCOLLO_DELIBERA,
   COD_MICROTIPOLOGIA,
   VAL_ORDINALE,
   VAL_UTI_TOT
)
AS
   SELECT DECODE (al.alert, 'G', 'A', AL.ALERT) AS val_alert,
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
          al.dta_ins AS dta_ins_alert,
          ad.cognome AS desc_cognome,
          ad.desc_istituto,
          ad.nome AS desc_nome,
          ad.desc_nome_controparte,
          ad.desc_struttura_competente_ar,
          ad.desc_struttura_competente_dc,
          ad.desc_struttura_competente_fi,
          ad.desc_struttura_competente_rg,
          '1' AS flg_abi_lavorato,
          ad.flg_gestore_abilitato,
          ad.id_referente,
          ad.id_utente,
          ad.desc_gruppo_economico AS val_ana_gre,
          al.val_ordine_colore,
          al.val_cnt_rapporti AS val_num_rapporti,
          rst_max.dta_efficacia_ristr AS dta_decorrenza_ristrutt,
          rst_max.cod_protocollo_pacchetto,
          rst_max.cod_protocollo_delibera,
          rst_max.cod_microtipologia_delib AS cod_microtipologia,
          rst_max.val_ordinale,
          ad.SCSB_UTI_TOT VAL_UTI_TOT
     FROM t_mcrei_app_alert_pos_wrk PARTITION (inc_p08) al,
          (SELECT rst.*
             FROM (  SELECT cod_abi, cod_ndg, MAX (val_ordinale) AS max_val
                       FROM t_mcrei_hst_ristrutturazioni
                   GROUP BY cod_abi, cod_ndg) pos,
                  t_mcrei_hst_ristrutturazioni rst
            WHERE     pos.cod_abi = rst.cod_abi
                  AND pos.cod_ndg = rst.cod_ndg
                  AND pos.max_val = rst.val_ordinale
                  AND rst.desc_tipo_ristr = 'P') rst_max,
          v_mcre0_app_upd_fields ad
    WHERE     al.cod_abi = ad.cod_abi_cartolarizzato
          AND al.cod_ndg = ad.cod_ndg
          AND al.cod_abi = rst_max.cod_abi
          AND al.cod_ndg = rst_max.cod_ndg
          AND ad.flg_outsourcing = 'Y'
          AND ad.flg_target = 'Y'
          AND ad.flg_outsourcing = 'Y';


GRANT DELETE, INSERT, REFERENCES, SELECT, UPDATE, ON COMMIT REFRESH, QUERY REWRITE, DEBUG, FLASHBACK, MERGE VIEW ON MCRE_OWN.V_MCRE0_APP_AL_NEW_RAP_DARISTR TO MCRE_USR;
