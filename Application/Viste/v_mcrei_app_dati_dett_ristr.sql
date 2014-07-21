/* Formatted on 21/07/2014 18:39:25 (QP5 v5.227.12220.39754) */
CREATE OR REPLACE FORCE VIEW MCRE_OWN.V_MCREI_APP_DATI_DETT_RISTR
(
   COD_ABI,
   COD_NDG,
   COD_PROTOCOLLO_PACCHETTO,
   COD_PROTOCOLLO_DELIBERA,
   COD_TIPO_RISTRUTTURAZIONE,
   COD_INTENTO_RISTRUTTURAZIONE,
   DTA_SCADENZA_RISTRUTT,
   COD_STATO_POST_RISTRUTT,
   TIPO_RISTR,
   INTENTO_RISTR,
   DTA_EFFICACIA,
   DTA_EFFICACIA_RISTR_SUCC,
   DTA_SCADENZA_RISTR,
   STATO_RISCHIO_CALCOLATO,
   DTA_CHIUSURA_RISTR,
   NOMINATIVO_INSERENTE,
   STATO_RISCHIO,
   VAL_TOTALE_UTILIZZATO_DERIVATI,
   VAL_TOT_RETT_DELIBERATE,
   DTA_EFFICACIA_RISTR,
   STATO_POST_RISTR
)
AS
   SELECT d.cod_abi AS "COD_ABI",
          D.COD_NDG AS "COD_NDG",
          D.COD_PROTOCOLLO_PACCHETTO AS "COD_PROTOCOLLO_PACCHETTO",
          D.COD_PROTOCOLLO_DELIBERA AS "COD_PROTOCOLLO_DELIBERA",
          DESC_TIPO_RISTR AS "COD_TIPO_RISTRUTTURAZIONE",            ----> ???
          D.DESC_INTENTO_RISTR AS "COD_INTENTO_RISTRUTTURAZIONE",
          D.DTA_SCADENZA_RISTR "DTA_SCADENZA_RISTRUTT",
          D.COD_STATO_POST_RISTR AS "COD_STATO_POST_RISTRUTT",
          ----
          d.desc_tipo_ristr AS TIPO_RISTR,
          D.DESC_INTENTO_RISTR AS INTENTO_RISTR,
          d.dta_efficacia_ristr AS DTA_EFFICACIA,
          dta_efficacia_add AS DTA_EFFICACIA_RISTR_SUCC,
          D.DTA_SCADENZA_RISTR AS DTA_SCADENZA_RISTR,
          (CASE
              WHEN (desc_Tipo_ristr = 'T' AND DESC_INTENTO_RISTR = 'N')
              THEN
                 'RS'
              ELSE
                 'IN'
           END)
             AS STATO_RISCHIO_CALCOLATO,
          d.dta_Chiusura_ristr AS DTA_CHIUSURA_RISTR,
          D.DESC_DENOMINAZ_INS_DELIBERA AS NOMINATIVO_INSERENTE,
          F.COD_STATO AS STATO_RISCHIO,
          NVL (
             DECODE (cod_fase_delibera,
                     'IN', p.scsb_uti_sostituzioni,
                     d.val_uti_sosti_scsb),
             0)
             AS VAL_TOTALE_UTILIZZATO_DERIVATI,
          NVL (D.VAL_RDV_qc_ante_delib, 0) + NVL (D.VAL_RDV_pregr_fi, 0)
             AS VAL_TOT_RETT_DELIBERATE,
          d.dta_efficacia_ristr AS DTA_EFFICACIA_RISTR,
          (CASE
              WHEN (desc_Tipo_ristr = 'T' AND DESC_INTENTO_RISTR = 'N')
              THEN
                 'RS'
              ELSE
                 'IN'
           END)
             AS STATO_POST_RISTR
     FROM t_mcrei_app_delibere d,
          T_MCRE0_APP_ALL_DATA F,
          t_mcrei_app_pcr_rapp_aggr p
    WHERE     d.cod_abi = f.cod_abi_cartolarizzato
          AND d.cod_ndg = f.cod_ndg
          AND d.flg_attiva = '1'
          AND d.cod_abi = p.cod_abi_cartolarizzato(+)
          AND d.cod_ndg = p.cod_ndg(+)
          AND d.cod_fase_pacchetto NOT IN ('ANA', 'ANM');
