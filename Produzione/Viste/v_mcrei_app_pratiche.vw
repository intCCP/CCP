/* Formatted on 17/06/2014 18:08:36 (QP5 v5.227.12220.39754) */
CREATE OR REPLACE FORCE VIEW MCRE_OWN.V_MCREI_APP_PRATICHE
(
   COD_ABI,
   COD_CAUSALE_CHIUSURA,
   COD_MATR_PRATICA,
   COD_NDG,
   COD_OPERATORE_INS_UPD,
   COD_PRATICA,
   COD_SNDG,
   COD_PROTOCOLLO_DELIBERA,
   COD_MICROTIPOLOGIA_DELIB,
   COD_PROTOCOLLO_PACCHETTO,
   COD_ORGANO_DELIBERANTE,
   DESC_ORGANO_DELIBERANTE,
   COD_ORGANO_CALCOLATO,
   COD_ORGANO_PACCHETTO,
   COD_ORGANO_PACCHETTO_CALC,
   COD_STATO_GIUR,
   COD_TIPO_GESTIONE,
   COD_UO_PRATICA,
   DTA_AFFID_UO,
   DTA_APERTURA,
   DTA_ASSEGN_ADDETTO,
   DTA_CHIUSURA,
   DTA_DECORRENZA_STATO,
   DTA_FINE_GESTIONE,
   DTA_FINE_GESTIONE_PRATICA,
   FLG_PROROGA_IMPLICITA,
   DTA_FINE_STATO,
   DTA_INIZIO_GESTIONE,
   DTA_INS,
   DTA_INS_STATO_GIUR,
   DTA_UPD,
   FLG_ATTIVA,
   ID_DPER,
   VAL_ANNO_PRATICA,
   PROG_PROPOSTA_CI,
   ANNO_PROPOSTA_CI,
   UO_PROPOSTA_CI,
   DTA_LAST_UPD_DELIBERA,
   DTA_MOTIVO_PASS_RISCHIO,
   COD_FASE_DELIBERA,
   DTA_DELIBERA,
   DTA_SCADENZA_TRANSAZ,
   DESC_NOTE,
   COD_MATRICOLA_INSERENTE,
   DTA_INIZIO_RAPPORTO_CLIENTE,
   VAL_ACCORDATO,
   VAL_ACCORDATO_CASSA,
   VAL_ACCORDATO_DERIVATI,
   VAL_ACCORDATO_FIRMA,
   VAL_ESP_LORDA,
   VAL_ESP_LORDA_CAPITALE,
   VAL_ESP_LORDA_MORA,
   VAL_ESP_NETTA_ANTE_DELIB,
   VAL_ESP_NETTA_POST_DELIB,
   VAL_ESP_TOT_CASSA,
   VAL_IMP_CREDITI_FIRMA,
   VAL_IMP_FONDI_TERZI,
   VAL_IMP_FONDI_TERZI_NB,
   VAL_IMP_OFFERTO,
   VAL_IMP_PERDITA,
   VAL_IMP_UTILIZZO,
   VAL_INTERESSI_MORA_CASSA,
   VAL_NUM_PROGR_DELIBERA,
   VAL_PERC_DUBBIO_ESITO,
   VAL_PERC_PERD_RM,
   VAL_PERC_RDV,
   VAL_PERC_RDV_ESTERO,
   VAL_PERDITA_ATTUALE,
   VAL_PERDITA_DELIBERATA,
   VAL_PROGR_PROPOSTA,
   VAL_RDV_DELIB_BANCA_RETE,
   VAL_RDV_EXTRA_DELIBERA,
   VAL_RDV_QC_ANTE_DELIB,
   VAL_RDV_QC_DELIBERATA,
   VAL_RDV_QC_PROGRESSIVA,
   VAL_RDV_QC_PROGRESSIVA_ORIG,
   VAL_RDV_QUOTA_MORA,
   VAL_RINUNCIA_CAPITALE,
   VAL_RINUNCIA_DELIBERATA,
   VAL_RINUNCIA_MORA,
   VAL_RINUNCIA_PROPOSTA,
   VAL_RINUNCIA_TOTALE,
   VAL_RISCHI_INDIRETTI,
   VAL_SACRIF_CAPIT_MORA,
   VAL_STRALCIO_QUOTA_CAP,
   VAL_STRALCIO_QUOTA_MORA,
   VAL_STRALCIO_SENZA_ACCANTONAM,
   VAL_TASSO_BASE_APPL,
   VAL_UTI_CASSA_SCSB,
   VAL_UTI_FIRMA_SCSB,
   VAL_UTI_NETTO_FONDO_TERZI,
   VAL_UTI_SOSTI_SCSB,
   VAL_UTI_TOT_GEGB,
   VAL_UTI_TOT_SCGB,
   VAL_UTI_TOT_SCSB,
   DESC_RAMO_AFFARI
)
AS
   SELECT DISTINCT
          p."COD_ABI",                                                   --5/3
          p."COD_CAUSALE_CHIUSURA",
          p."COD_MATR_PRATICA",
          p."COD_NDG",
          p."COD_OPERATORE_INS_UPD",
          p."COD_PRATICA",
          p."COD_SNDG",
          d."COD_PROTOCOLLO_DELIBERA",
          d."COD_MICROTIPOLOGIA_DELIB",
          d."COD_PROTOCOLLO_PACCHETTO",
          d.cod_organo_deliberante,
          NVL (o1.desc_organo_deliberante, 'n.d.') AS desc_organo_deliberante, --21 maggio
          d.cod_organo_calcolato,
          d.cod_organo_pacchetto,
          d.cod_organo_pacchetto_calc,
          p."COD_STATO_GIUR",
          p."COD_TIPO_GESTIONE",
          p."COD_UO_PRATICA",
          p."DTA_AFFID_UO",
          p."DTA_APERTURA",
          p."DTA_ASSEGN_ADDETTO",
          p."DTA_CHIUSURA",
          DECODE (
             d.cod_microtipologia_delib,
             'CS', (DECODE (
                       p.dta_fine_stato,
                       TO_DATE ('31/12/9999', 'DD/MM/YYYY'), p.dta_decorrenza_stato,
                       (p.dta_fine_stato + 1))),
             p.dta_decorrenza_stato)
             AS dta_decorrenza_stato,
          CASE
             WHEN d."COD_MICROTIPOLOGIA_DELIB" IN
                     ('RV', 'T4', 'A0', 'IM', 'IF')
             THEN                  --leggo direttamente dallo stato --MM131115
                X.DTA_SCADENZA_STATO
             ELSE
                p."DTA_FINE_GESTIONE"
          END
             AS DTA_FINE_GESTIONE,
          p."DTA_FINE_GESTIONE" AS DTA_FINE_GESTIONE_PRATICA, --ex DTA_FINE_GESTIONE
          --x le rdv dico se ho fatto proroga implicita --non serve più, ma rimane
          CASE
             WHEN d."COD_MICROTIPOLOGIA_DELIB" IN
                     ('RV', 'T4', 'A0', 'IM', 'IF')
             THEN  --uso la regola standard, usata anche nelle classificazioni
                CASE
                   WHEN DECODE (dta_esito,
                                NULL, dta_servizio + c.val_gg_prima_proroga,
                                dta_esito + c.val_gg_seconda_proroga) <
                           SYSDATE
                   THEN
                      'Y'
                   ELSE
                      'N'
                END
             ELSE
                'N'
          END
             AS FLG_PROROGA_IMPLICITA,
          p."DTA_FINE_STATO",
          p."DTA_INIZIO_GESTIONE",
          p."DTA_INS",
          p."DTA_INS_STATO_GIUR",
          p."DTA_UPD",
          p."FLG_ATTIVA",
          p."ID_DPER",
          p."VAL_ANNO_PRATICA",
          s.val_progr_proposta AS prog_proposta_ci,
          s.val_anno_proposta AS anno_proposta_ci,
          s.cod_uo_proposta AS uo_proposta_ci,
          d.dta_last_upd_delibera,
          d.dta_motivo_pass_rischio,
          d.cod_fase_delibera,
          d.dta_delibera,
          d.dta_scadenza_transaz,                                       ---5/3
          d.desc_note,                                                  ---5/3
          d.cod_matricola_inserente,
          d.dta_inizio_rapporto_cliente,
          d.val_accordato,
          d.val_accordato_cassa,
          d.val_accordato_derivati,
          d.val_accordato_firma,
          d.val_esp_lorda,
          d.val_esp_lorda_capitale,
          d.val_esp_lorda_mora,
          d.val_esp_netta_ante_delib,
          d.val_esp_netta_post_delib,
          d.val_esp_tot_cassa,
          d.val_imp_crediti_firma,
          d.val_imp_fondi_terzi,
          d.val_imp_fondi_terzi_nb,
          d.val_imp_offerto,
          d.val_imp_perdita,
          d.val_imp_utilizzo,
          d.val_interessi_mora_cassa,
          d.val_num_progr_delibera,
          d.val_perc_dubbio_esito,
          d.val_perc_perd_rm,
          d.val_perc_rdv,
          d.val_perc_rdv_estero,
          d.val_perdita_attuale,
          d.val_perdita_deliberata,
          d.val_progr_proposta,
          d.val_rdv_delib_banca_rete,
          d.val_rdv_extra_delibera,
          CASE
             WHEN d.cod_microtipologia_delib NOT IN --('RV', 'T4', 'A0', 'IM', 'IF') applico patch solo alle proroghe
                                                   ('PR', 'PU', 'PS')
             THEN
                d.val_rdv_qc_ante_delib
             ELSE                                                   --mm131216
                NVL (
                   (SELECT v.val_rdv_qc_progressiva
                      FROM v_mcrei_app_elenco_delibere v
                     WHERE     v.cod_abi = d.cod_abi
                           AND v.cod_ndg = d.cod_ndg
                           AND FLG_LAST_RDV_CONFERMATA = 'Y'),
                   0)
          END
             val_rdv_qc_ante_delib,
          CASE
             WHEN d.cod_microtipologia_delib NOT IN --('RV', 'T4', 'A0', 'IM', 'IF') applico patch solo alle proroghe
                                                   ('PR', 'PU', 'PS')
             THEN
                d.val_rdv_qc_deliberata
             ELSE                                                   --mm131216
                0
          END
             val_rdv_qc_deliberata,
          CASE
             WHEN d.cod_microtipologia_delib NOT IN --('RV', 'T4', 'A0', 'IM', 'IF') applico patch solo alle proroghe
                                                   ('PR', 'PU', 'PS')
             THEN
                d.val_rdv_qc_progressiva
             ELSE                                                   --mm131216
                NVL (
                   (SELECT v.val_rdv_qc_progressiva
                      FROM v_mcrei_app_elenco_delibere v
                     WHERE     v.cod_abi = d.cod_abi
                           AND v.cod_ndg = d.cod_ndg
                           AND FLG_LAST_RDV_CONFERMATA = 'Y'),
                   0)
          END
             val_rdv_qc_progressiva,
          d.val_rdv_qc_progressiva val_rdv_qc_progressiva_orig,
          d.val_rdv_quota_mora,
          d.val_rinuncia_capitale,
          d.val_rinuncia_deliberata,
          d.val_rinuncia_mora,
          d.val_rinuncia_proposta,
          d.val_rinuncia_totale,
          d.val_rischi_indiretti,
          d.val_sacrif_capit_mora,
          d.val_stralcio_quota_cap,
          d.val_stralcio_quota_mora,
          d.val_stralcio_senza_accantonam,
          DECODE (d.val_tasso_base_appl,  'Y', 1,  'N', 0,  TO_NUMBER (NULL))
             AS val_tasso_base_appl,                             ---ad: 19 sep
          d.val_uti_cassa_scsb,
          d.val_uti_firma_scsb,
          d.val_uti_netto_fondo_terzi,
          d.val_uti_sosti_scsb,
          d.val_uti_tot_gegb,
          d.val_uti_tot_scgb,
          d.val_uti_tot_scsb,
          D.DESC_RAMO_AFFARI
     FROM t_mcrei_app_delibere d,
          t_mcrei_app_pratiche p,
          t_mcre0_app_rio_proroghe r,
          t_mcre0_app_comparti c,
          t_mcre0_app_all_data x,
          t_mcre0_cl_organi_deliberanti o1,
          (SELECT DISTINCT
                  A.val_progr_proposta,
                  A.val_anno_proposta,
                  A.cod_uo_proposta,
                  A.VAL_aNNO_PRATICA,
                  A.COD_PRATICA,
                  A.COD_UO_PRATICA,
                  A.COD_ABI,
                  A.COD_NDG,
                  A.COD_PROTOCOLLO_DELIBERA,
                  MAX (
                     TO_NUMBER (
                           VAL_ANNO_PROPOSTA
                        || LPAD (VAL_PROGR_PROPOSTA, 11, '0')))
                  -- 15FEB: ESTRAGGO ULTIMA CLASSIFICAZIONE SE CE NE SONO PIù DI UNA CAUSA IMPIANTO
                  OVER (
                     PARTITION BY cod_abi,
                                  cod_ndg,
                                  cod_pratica,
                                  val_anno_pratica)
                     last_progr
             FROM t_mcrei_app_delibere a
            WHERE     cod_microtipologia_delib = 'CI'
                  AND flg_attiva = '1'
                  AND cod_fase_delibera = 'CO'
                  AND A.FLG_NO_DELIBERA = 0) s
    ---6MAR
    WHERE     d.cod_abi = p.cod_abi
          AND d.cod_ndg = p.cod_ndg
          AND d.cod_sndg = p.cod_sndg
          AND d.cod_pratica = p.cod_pratica
          AND d.val_anno_pratica = p.val_anno_pratica
          AND p.flg_attiva = '1'
          AND d.flg_attiva = '1'
          -- and d.cod_fase_delibera = 'CO'
          --MM:1010
          AND D.FLG_NO_DELIBERA = 0
          --11 OCT
          AND d.cod_abi = s.cod_abi
          AND d.cod_ndg = s.cod_ndg
          --x proroghe
          AND d.cod_abi = x.cod_abi_cartolarizzato
          AND d.cod_ndg = x.cod_ndg
          AND NVL (x.cod_comparto_assegnato, cod_comparto_calcolato) =
                 c.cod_comparto(+)
          AND x.cod_abi_cartolarizzato = r.cod_abi_cartolarizzato(+)
          AND x.cod_ndg = r.cod_ndg(+)
          AND r.flg_storico(+) = 0
          AND r.flg_esito(+) = 1
          AND d.cod_pratica = s.cod_pratica
          AND d.val_anno_pratica = s.val_anno_pratica
          AND (TO_NUMBER (
                  s.VAL_ANNO_PROPOSTA || LPAD (s.VAL_PROGR_PROPOSTA, 11, '0'))) =
                 s.last_progr
          AND d.cod_organo_deliberante = o1.cod_organo_deliberante(+)
          --11 maggio
          AND d.cod_abi = o1.cod_abi_istituto(+)
          AND o1.cod_stato_riferimento(+) = 'IN';


GRANT DELETE, INSERT, REFERENCES, SELECT, UPDATE, ON COMMIT REFRESH, QUERY REWRITE, DEBUG, FLASHBACK, MERGE VIEW ON MCRE_OWN.V_MCREI_APP_PRATICHE TO MCRE_USR;
