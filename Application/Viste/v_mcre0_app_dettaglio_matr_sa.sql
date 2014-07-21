/* Formatted on 21/07/2014 18:33:25 (QP5 v5.227.12220.39754) */
CREATE OR REPLACE FORCE VIEW MCRE_OWN.V_MCRE0_APP_DETTAGLIO_MATR_SA
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
   COD_LIVELLO_CRITICITA,
   COD_LIVELLO,
   COD_SEGMENTO,
   DESC_SEGMENTO
)
AS
   SELECT                                  -- VG 20140707 aggiunto cod_livello
         ad.COD_STRUTTURA_COMPETENTE,
          sorg.DESC_STRUTTURA_COMPETENTE,
          ad.COD_MATRICOLA,
          ad.COD_ABI_CARTOLARIZZATO,
          clp.tip_div AS COD_DIVISIONE,
          clp.cod_div AS COD_TIPO_FILIALE,
          ad.DESC_ISTITUTO AS DESC_ISTITUTO,
          ad.COD_STRUTTURA_COMPETENTE_RG,
          ad.COD_STRUTTURA_COMPETENTE_AR,
          ad.COD_STRUTTURA_COMPETENTE_FI,
          ad.DESC_STRUTTURA_COMPETENTE_RG,
          ad.DESC_STRUTTURA_COMPETENTE_AR,
          ad.DESC_STRUTTURA_COMPETENTE_FI,
          ad.COD_SNDG,
          ad.COD_NDG,
          ad.DESC_NOME_CONTROPARTE,
          ad.COD_PROCESSO,
          ad.COD_STATO,
          ad.DTA_DECORRENZA_STATO,
          ad.DTA_SCADENZA_STATO,
          rag.SCSB_UTI_TOT AS VAL_TOT_UTILIZZO,
          rag.SCSB_ACC_TOT AS VAL_TOT_ACCORDATO,
          ad.GB_VAL_MAU AS VAL_MAU,
          'V' COD_LIVELLO_CRITICITA,
          ad.cod_livello,
          cod_SEGMENTO,
          DESC_SEGMENTO
     FROM v_mcre0_app_upd_fields ad,
          t_mcre0_app_struttura_org sorg,
          T_MCRE0_CL_PROCESSI clp,
          t_mcrei_app_pcr_rapp_aggr rag,
          T_MCRE0_DWH_AGRU a,
          T_MCRE0_CL_SEGMENTI_REG r
    WHERE     ad.cod_abi_cartolarizzato = sorg.cod_abi_istituto
          AND ad.cod_struttura_competente = sorg.cod_struttura_competente
          AND ad.cod_abi_cartolarizzato = clp.cod_abi
          AND ad.cod_processo = clp.cod_processo
          AND ad.cod_abi_cartolarizzato = rag.cod_abi_cartolarizzato
          AND ad.cod_ndg = rag.cod_ndg
          AND ad.cod_sndg = a.cod_sndg
          AND a.val_segmento_regolamentare = r.COD_SEGMENTO(+);
