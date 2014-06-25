
  CREATE OR REPLACE FORCE VIEW "MCRE_OWN"."V_MCRE0_APP_ALERT_DEL_FORZ_N_D" ("COD_ABI_CARTOLARIZZATO", "COD_COMPARTO_POSIZIONE", "COD_DOC_APPENDICE_PARERE", "COD_DOC_CLASSIFICAZIONE", "COD_DOC_DELIBERA_BANCA", "COD_DOC_DELIBERA_CAPOGRUPPO", "COD_DOC_PARERE_CONFORMITA", "COD_GRUPPO", "COD_MACROSTATO", "COD_MICROSTATO", "COD_MICROTIPOLOGIA", "COD_NDG", "COD_PROCESSO", "COD_PROT_DELIBERA", "COD_SNDG", "COD_STATO", "COD_STRUTTURA_COMPETENTE_AR", "COD_STRUTTURA_COMPETENTE_DC", "COD_STRUTTURA_COMPETENTE_DV", "COD_STRUTTURA_COMPETENTE_FI", "COD_STRUTTURA_COMPETENTE_RG", "DESC_COGNOME_GESTORE", "DESC_GRUPPO", "DESC_MACROSTATO", "DESC_MICROSTATO", "DESC_MICROTIPOLOGIA", "DESC_NOME_CONTROPARTE", "DESC_NOME_GESTORE", "DESC_STRUTTURA_COMPETENTE_AR", "DESC_STRUTTURA_COMPETENTE_DC", "DESC_STRUTTURA_COMPETENTE_DV", "DESC_STRUTTURA_COMPETENTE_FI", "DESC_STRUTTURA_COMPETENTE_RG", "DTA_FORZ_DELIBERA", "DTA_INS_ALERT", "DTA_RILEV", "FLG_ABI_LAVORATO", "FLG_GESTORE_ABILITATO", "ID_UTENTE", "VAL_ALERT", "DESC_ISTITUTO", "VAL_ORDINE_COLORE", "VAL_UTI_TOT","COD_DOC_CLASSIFICAZIONE_MCI") AS 
  SELECT d.cod_abi AS cod_abi_cartolarizzato,
          NVL (ad.cod_comparto_assegnato, ad.cod_comparto_calcolato)
             cod_comparto_posizione,
          d.cod_doc_appendice_parere,
          d.cod_doc_classificazione,
          d.cod_doc_delibera_banca,
          d.cod_doc_delibera_capogruppo,
          d.cod_doc_parere_conformita,
          ad.cod_gruppo_economico AS cod_gruppo,
          ad.cod_macrostato,
          ad.cod_stato AS cod_microstato,
          d.cod_microtipologia_delib AS cod_microtipologia,
          d.cod_ndg,
          ad.cod_processo,
          d.cod_protocollo_delibera AS cod_prot_delib,
          d.cod_sndg,
          ad.cod_stato,
          org.cod_struttura_competente_ar,
          org.cod_struttura_competente_dc,
          org.cod_struttura_competente_dv,
          org.cod_struttura_competente_fi,
          org.cod_struttura_competente_rg,
          u.cognome AS desc_cognome_gestore,
          ad.desc_gruppo_economico AS desc_gruppo,
          s.desc_macrostato,
          s.desc_microstato,
          tip.desc_microtipologia AS desc_microtipologia,
          ad.desc_nome_controparte,
          u.nome AS desc_nome_gestore,
          org.desc_struttura_competente_ar,
          org.desc_struttura_competente_dc,
          org.desc_struttura_competente_dv,
          org.desc_struttura_competente_fi,
          org.desc_struttura_competente_rg,
          NULL AS dta_forz_delibera,
          pw.dta_ins,
          NULL AS dta_rilev,
          '1' AS flg_abi_lavorato,
          u.flg_gestore_abilitato AS flg_gestore_abilitato,
          u.id_utente AS id_utente,
          pw.alert,
          ad.desc_istituto,
          pw.val_ordine_colore,
          ad.SCSB_UTI_TOT VAL_UTI_TOT,
          D.COD_DOC_CLASSIFICAZIONE_MCI --T.B. APERTURA MCI 25-06-14
     FROM t_mcrei_app_alert_pos_wrk PARTITION (inc_p44) pw,
          t_mcrei_app_delibere d,
          t_mcre0_app_all_data ad,
          mv_mcre0_denorm_str_org org,
          t_mcre0_app_stati s,
          t_mcre0_app_utenti u,
          t_mcrei_cl_tipologie tip
    WHERE     pw.cod_abi = d.cod_abi
          AND pw.cod_ndg = d.cod_ndg
          AND pw.cod_protocollo_delibera = d.cod_protocollo_delibera
          AND ad.cod_abi_cartolarizzato = d.cod_abi
          AND ad.cod_ndg = d.cod_ndg
          AND ad.cod_filiale = org.cod_struttura_competente_fi
          AND ad.cod_abi_istituto = org.cod_abi_istituto_fi
          AND ad.cod_stato = s.cod_microstato
          AND ad.flg_outsourcing = 'Y'
          AND ad.flg_target = 'Y'
          AND d.flg_no_delibera = 0
          AND d.flg_attiva = '1'
          AND ad.id_utente = u.id_utente
          AND d.cod_microtipologia_delib = tip.cod_microtipologia
          and d.cod_doc_delibera_banca is null

;
