/* Formatted on 17/06/2014 18:15:39 (QP5 v5.227.12220.39754) */
CREATE OR REPLACE FORCE VIEW MCRE_OWN.VTMCRE0_APP_DETTAGLIO_MATR_SA
(
   COD_STRUTTURA_COMPETENTE,
   DESC_STRUTTURA_COMPETENTE,
   COD_MATRICOLA,
   COD_ABI_CARTOLARIZZATO,
   COD_DIVISIONE,
   COD_TIPO_FILIALE,
   DESC_ISTITUTO,
   COD_STRUTTURA_COMPETENTE_RG,
   COD_STRUTTURA_COMPETENTE_AR,
   COD_STRUTTURA_COMPETENTE_FI,
   DESC_STRUTTURA_COMPETENTE_RG,
   DESC_STRUTTURA_COMPETENTE_AR,
   DESC_STRUTTURA_COMPETENTE_FI,
   COD_SNDG,
   COD_NDG,
   DESC_NOME_CONTROPARTE,
   COD_PROCESSO,
   COD_STATO,
   DTA_DECORRENZA_STATO,
   DTA_SCADENZA_STATO,
   VAL_TOT_UTILIZZO,
   VAL_TOT_ACCORDATO,
   VAL_MAU,
   COD_LIVELLO_CRITICITA
)
AS
   SELECT ad.cod_struttura_competente,
          sorg.desc_struttura_competente,
          ad.cod_matricola,
          ad.cod_abi_cartolarizzato,
          clp.tip_div AS cod_divisione,
          clp.cod_div AS cod_tipo_filiale,
          ad.desc_istituto AS desc_istituto,
          ad.cod_struttura_competente_rg,
          ad.cod_struttura_competente_ar,
          ad.cod_struttura_competente_fi,
          ad.desc_struttura_competente_rg,
          ad.desc_struttura_competente_ar,
          ad.desc_struttura_competente_fi,
          ad.cod_sndg,
          ad.cod_ndg,
          ad.desc_nome_controparte,
          ad.cod_processo,
          ad.cod_stato,
          ad.dta_decorrenza_stato,
          ad.dta_scadenza_stato,
          rag.scsb_uti_tot AS val_tot_utilizzo,
          rag.scsb_acc_tot AS val_tot_accordato,
          ad.gb_val_mau AS val_mau,
          'V' cod_livello_criticita
     FROM vtmcre0_app_upd_fields ad,
          t_mcre0_app_struttura_org sorg,
          t_mcre0_cl_processi clp,
          t_mcrei_app_pcr_rapp_aggr rag
    WHERE     ad.cod_abi_cartolarizzato = sorg.cod_abi_istituto
          AND ad.cod_struttura_competente = sorg.cod_struttura_competente
          AND ad.cod_abi_cartolarizzato = clp.cod_abi
          AND ad.cod_processo = clp.cod_processo
          AND ad.cod_abi_cartolarizzato = rag.cod_abi_cartolarizzato
          AND ad.cod_ndg = rag.cod_ndg;


GRANT DELETE, INSERT, REFERENCES, SELECT, UPDATE, ON COMMIT REFRESH, QUERY REWRITE, DEBUG, FLASHBACK ON MCRE_OWN.VTMCRE0_APP_DETTAGLIO_MATR_SA TO MCRE_USR;
