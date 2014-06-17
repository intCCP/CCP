/* Formatted on 17/06/2014 18:03:57 (QP5 v5.227.12220.39754) */
CREATE OR REPLACE FORCE VIEW MCRE_OWN.V_MCRE0_APP_RIO_GRAFICO_TP
(
   COD_SNDG,
   COD_ABI_CARTOLARIZZATO,
   COD_ABI_ISTITUTO,
   DESC_ISTITUTO,
   COD_NDG,
   COD_COMPARTO,
   COD_RAMO_CALCOLATO,
   DESC_NOME_CONTROPARTE,
   COD_GRUPPO_ECONOMICO,
   VAL_ANA_GRE,
   COD_STRUTTURA_COMPETENTE_DC,
   DESC_STRUTTURA_COMPETENTE_DC,
   COD_STRUTTURA_COMPETENTE_DV,
   DESC_STRUTTURA_COMPETENTE_DV,
   COD_STRUTTURA_COMPETENTE_RG,
   DESC_STRUTTURA_COMPETENTE_RG,
   COD_STRUTTURA_COMPETENTE_AR,
   DESC_STRUTTURA_COMPETENTE_AR,
   COD_STRUTTURA_COMPETENTE_FI,
   DESC_STRUTTURA_COMPETENTE_FI,
   COD_PROCESSO,
   COD_STATO,
   DTA_DECORRENZA_STATO,
   DTA_SCADENZA_STATO,
   ID_UTENTE,
   DTA_UTENTE_ASSEGNATO,
   DESC_NOME,
   DESC_COGNOME,
   ID_REFERENTE,
   COD_AZIONE,
   DTA_INSERIMENTO,
   TOT_AZIONI,
   COD_TIPOLOGIA_PRATICA,
   FLG_ESITO,
   FLG_STATUS,
   FLG_SG,
   DTA_SCADENZA,
   NOTE,
   COD_LIVELLO
)
AS
   SELECT x.cod_sndg,
          x.cod_abi_cartolarizzato,
          x.cod_abi_istituto,
          x.desc_istituto,
          x.cod_ndg,
          x.cod_comparto,
          x.cod_ramo_calcolato,
          x.desc_nome_controparte,
          x.cod_gruppo_economico,
          x.desc_gruppo_economico val_ana_gre,
          x.cod_struttura_competente_dc,
          x.desc_struttura_competente_dc,
          x.cod_struttura_competente_dv,
          x.desc_struttura_competente_dv,
          x.cod_struttura_competente_rg,
          x.desc_struttura_competente_rg,
          x.cod_struttura_competente_ar,
          x.desc_struttura_competente_ar,
          x.cod_struttura_competente_fi,
          x.desc_struttura_competente_fi,
          x.cod_processo,
          x.cod_stato,
          x.dta_decorrenza_stato,
          x.dta_scadenza_stato,
          NULLIF (x.id_utente, -1) id_utente,
          x.dta_utente_assegnato,
          x.nome desc_nome,
          x.cognome desc_cognome,
          x.id_referente,
          a.cod_azione,
          a.dta_inserimento,
          a.tot_azioni,
          a.cod_tipologia_pratica,
          a.flg_esito,
          a.flg_status,
          CASE
             WHEN x.flg_gruppo_economico = '0' AND x.flg_gruppo_legame = '0'
             THEN
                'S'
             WHEN x.flg_gruppo_economico = '1' OR x.flg_gruppo_legame = '1'
             THEN
                'G'
             ELSE
                NULL
          END
             flg_sg,
          a.dta_scadenza,
          a.note,
          x.cod_livello
     FROM v_mcre0_app_upd_fields x,
          t_mcre0_app_rio_gestione g,
          (SELECT r.*,
                  COUNT (
                     *)
                  OVER (
                     PARTITION BY r.cod_abi_cartolarizzato,
                                  r.cod_ndg,
                                  r.cod_tipologia_pratica)
                     tot_azioni
             FROM t_mcre0_app_rio_azioni r
            WHERE r.flg_delete = 0) a
    WHERE     cod_macrostato = 'RIO'
          AND x.cod_abi_cartolarizzato = g.cod_abi_cartolarizzato
          AND x.cod_ndg = g.cod_ndg
          AND g.cod_abi_cartolarizzato = a.cod_abi_cartolarizzato
          AND g.cod_ndg = a.cod_ndg
          AND a.cod_tipologia_pratica IS NOT NULL
          AND g.flg_delete = 0;


GRANT DELETE, INSERT, REFERENCES, SELECT, UPDATE, ON COMMIT REFRESH, QUERY REWRITE, DEBUG, FLASHBACK, MERGE VIEW ON MCRE_OWN.V_MCRE0_APP_RIO_GRAFICO_TP TO MCRE_USR;
