/* Formatted on 21/07/2014 18:39:27 (QP5 v5.227.12220.39754) */
CREATE OR REPLACE FORCE VIEW MCRE_OWN.V_MCREI_APP_DATI_GENERALI
(
   COD_NDG,
   DESC_NOME_CONTROPARTE,
   COD_ABI_CARTOLARIZZATO,
   DESC_ISTITUTO,
   COD_SNDG,
   COD_PROTOCOLLO_DELIBERA,
   COD_PROTOCOLLO_PACCHETTO,
   OD_EFFETTIVO,
   STATO_PROVENIENZA,
   DTA_DECORRENZA_STATO,
   TIPO_GESTIONE,
   COD_TIPO_GESTIONE,
   DATA_INS_DELIBERA,
   UO_PROPONENTE,
   COD_MATR_PROPONENTE,
   DATA_INIZIO_RAPPORTI,
   MOTIVO_PASSAGGIO_RISCHIO,
   DTA_MOTIVO_PASS_RISCHIO,
   SAG,
   COD_STATO_SAG,
   DTA_SAG,
   MODALITA_CONFERMA_SAG,
   FLG_INTERVEN_ORGANI_SUPERIORI,
   DTA_ULT_DELIBERA_FIDO,
   ULT_ORGANO_DELIB_FIDO,
   DATA_REVOCA_FIDO,
   SCGB_UTI_RISCHI_INDIRETTI,
   FLG_DEPOSITI_COLLATERALI,
   ESP_SINGOLO_CLIENTE_GB,
   FLG_AFFID_SOC_REC,
   FLG_SOGGETTO_POT_FALLIBILE,
   FLG_PRESEN_COVENANTS,
   ESP_GE_GB,
   COD_GRUPPO_ECONOMICO,
   DESC_GRUPPO_ECONOMICO,
   PROPOSTA_DI_STATO_RISCHIO,
   DTA_CONFERMA_PROPOSTA,
   STATO_PROPOSTA,
   RAMO_AFFARI,
   LIV_ULTIMO_DELIB_FIDO,
   DTA_ULTIMO_AGGIORNAMENTO,
   NUM_PROPOSTA,
   DTA_INIZIO_PROPOSTA,
   FLG_DISPOSIZIONE,
   FLG_POSIZ_DA_CEDERE,
   FLG_PACCHETTO_BATCH,
   VAL_ANNO_PROPOSTA,
   VAL_PROGR_PROPOSTA,
   STATO_PROPOSTO,
   DESC_UO_PROPONENTE,
   DESC_PROPONENTE
)
AS
   SELECT                                                  /*no_parallel (f)*/
          --120123 mm: aggiunto cod_tipo_gestione
          a.cod_ndg,
          a.desc_nome_controparte,
          a.cod_abi_cartolarizzato,
          a.desc_istituto,
          a.cod_sndg,
          d.cod_protocollo_delibera,
          d.cod_protocollo_pacchetto,
          d.cod_organo_deliberante AS od_effettivo,
          -- (a livello di singola banca rete)
          NULLIF (a.cod_stato, '-1') AS stato_provenienza,
          a.dta_decorrenza_stato,
          --mm131217 confronto valore soglia su uti_cassa e non più su uti_tot
          (CASE
              WHEN (p.scsb_uti_cassa < DO.desc_dominio) THEN 'FORFETARIO'
              ELSE 'ANALITICO'
           END)
             AS tipo_gestione,
          CASE
             WHEN (p.scsb_uti_cassa < DO.desc_dominio)
             THEN
                DECODE (cod_microtipologia_delib, 'CI', 'A', 'Z')
             ELSE
                DECODE (cod_microtipologia_delib, 'CI', 'E', 'S')
          END
             AS cod_tipo_gestione,                                --26/02/2014
          SYSDATE AS data_ins_delibera,
          a.cod_struttura_competente AS uo_proponente,
          d.cod_matricola_inserente AS cod_matr_proponente,           -- nuovo
          g.dta_inizio_relazione AS data_inizio_rapporti,
          d.desc_motivo_pass_rischio AS motivo_passaggio_rischio,
          --visualizzato solo se si tratta di CI
          d.dta_motivo_pass_rischio,
          s.cod_sag AS sag,                                      -- NUOVO L.F.
          DECODE (s.flg_conferma, 'S', 'Confermato', 'Calcolato')
             AS cod_stato_sag,                          -- DA DOVE LO PRENDO??
          NVL (s.dta_calcolo_sag, s.dta_conferma) AS dta_sag,
          NULL AS modalita_conferma_sag,                  -- DA DOVE LO PRENDO
          NVL (d.flg_interven_organi_superiori, 'N'),          -- dato manuale
          --rank() over(PARTITION BY d.cod_abi, d.cod_ndg ORDER BY d.dta_conferma_delibera DESC, val_num_progr_delibera DESC) rn,
          --d.dta_last_upd_delibera AS dta_ultima_delibera,
          e.dta_ultima_delibera AS dta_ult_delibera_fido,
          --??? DA MODIFICARE PROVENIENZA
          e.cod_ultimo_ode AS ult_organo_delib_fido,
          TO_DATE (NULL, 'ddmmyyyy') AS data_revoca_fido,
          p.scgb_uti_rischi_indiretti,
          NVL (d.flg_depositi_collaterali, 'N'),
          -- dato manuale
          p.scgb_uti_tot AS esp_singolo_cliente_gb,
          DECODE (f.cod_ndg, NULL, 'N', 'Y') AS flg_affid_soc_rec,
          --Affidamento A società di recupero in corso --? MANCA ANCORA IL FLUSSO
          NVL (d.flg_soggetto_pot_fallibile, 'N'),             -- dato manuale
          NVL (d.flg_presen_covenants, 'N'),                   -- dato manuale
          p.gegb_uti_tot AS esp_ge_gb,
          a.cod_gruppo_economico,
          a.desc_gruppo_economico,
          NVL (d.cod_tipo_proposta, pp.cod_tipo_rischio)
             AS proposta_di_stato_rischio,
          d.dta_conferma_delibera AS dta_conferma_proposta,
          d.cod_fase_delibera AS stato_proposta,
          NVL (d.desc_ramo_affari, pp.desc_ramo_affari) AS ramo_affari,
          NVL (d.desc_liv_last_delib_fido, pp.cod_desc_delibera_fido)
             AS liv_ultimo_delib_fido,
          d.dta_last_upd_delibera AS dta_ultimo_aggiornamento,
          d.val_anno_proposta || '/' || d.val_progr_proposta AS num_proposta,
          d.dta_ins_delibera AS dta_inizio_proposta,
          NVL (d.flg_disposizione, pp.disposizione) AS disposizione,
          NVL (d.flg_posiz_da_cedere, 'N') flg_posiz_da_cedere,
          DECODE (d.cod_tipo_pacchetto, 'B', 'Y', 'N') AS flg_pacchetto_batch,
          d.val_anno_proposta,
          d.val_progr_proposta,
          CASE WHEN d.cod_microtipologia_delib = 'CI' THEN 'IN' ELSE 'SO' END
             stato_proposto,
          CASE
             WHEN NVL (
                     NVL (NULLIF (a.DESC_ISTITUTO, '#'),
                          NULLIF (a.DESC_ISTITUTO, '#')),
                     NULLIF (a.DESC_ISTITUTO, '#'))
                     IS NOT NULL
             THEN
                NVL (
                   NVL (NULLIF (a.DESC_ISTITUTO, '#'),
                        NULLIF (a.DESC_ISTITUTO, '#')),
                   NULLIF (a.DESC_ISTITUTO, '#'))
             ELSE
                (SELECT o.desc_struttura_competente
                   FROM t_mcre0_App_Struttura_org o
                  WHERE     o.cod_abi_istituto = a.cod_abi_cartolarizzato
                        AND O.COD_COMPARTO =
                               NVL (a.cod_comparto_assegnato,
                                    a.cod_comparto_calcolato))
          END
             desc_uo_proponente,
          d.desc_denominaz_ins_delibera AS desc_proponente
     FROM t_mcre0_app_all_data a,
          t_mcre0_app_pcr p,
          t_mcre0_app_anagrafica_gruppo g,
          t_mcrei_app_delibere d,
          t_mcre0_app_sag s,         -- 22.12.2011 Aggiunta per campi SAG L.F.
          t_mcrei_app_affidamenti f,
          t_mcre0_app_pef e,                           --05.01.12 x campi fido
          t_mcrei_cl_domini DO,
          t_mcrei_app_mpl_proposte pp
    WHERE     a.cod_abi_cartolarizzato = p.cod_abi_cartolarizzato
          AND a.cod_ndg = p.cod_ndg
          AND a.cod_sndg = g.cod_sndg
          AND a.cod_abi_cartolarizzato = d.cod_abi
          AND a.cod_ndg = d.cod_ndg
          AND d.cod_abi = pp.cod_abi(+)
          AND d.cod_ndg = pp.cod_ndg(+)
          AND d.val_anno_proposta = pp.val_anno_proposta(+)
          AND TO_CHAR (d.val_progr_proposta) = pp.val_progr_proposta(+)
          AND d.cod_abi = DO.val_dominio(+)
          AND DO.cod_dominio(+) = 'LIM_INC_FORF'
          AND a.cod_sndg = s.cod_sndg(+)
          AND a.cod_abi_cartolarizzato = e.cod_abi_istituto(+)
          AND a.cod_ndg = e.cod_ndg(+)
          AND d.flg_attiva(+) = '1'
          AND d.cod_microtipologia_delib IN ('CI', 'CS', 'CZ')
          AND d.cod_abi = f.cod_abi(+)
          AND d.cod_ndg = f.cod_ndg(+)
          AND f.flg_attiva(+) = '1';
