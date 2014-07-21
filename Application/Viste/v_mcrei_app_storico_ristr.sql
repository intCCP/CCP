/* Formatted on 21/07/2014 18:40:54 (QP5 v5.227.12220.39754) */
CREATE OR REPLACE FORCE VIEW MCRE_OWN.V_MCREI_APP_STORICO_RISTR
(
   COD_ABI,
   COD_NDG,
   COD_TIPO_RISTR,
   DESC_INTENTO,
   DTA_EFFICACIA,
   DTA_CHIUSURA,
   VAL_ORDINALE,
   DTA_SCADENZA,
   DTA_EFFICACIA_ADD,
   COD_STATO_RISCHIO,
   DESC_NOMINATIVO_INS,
   COD_CAUSALE_CH_RISTR
)
AS
   SELECT r.cod_abi,
          r.cod_ndg,
          r.desc_tipo_ristr AS cod_tipo_ristr,
          r.desc_intento_ristr AS desc_intento,
          r.dta_efficacia_ristr AS dta_efficacia,
          r.dta_chiusura_ristr AS dta_chiusura,
          r.val_ordinale,
          r.dta_scadenza_ristr AS dta_scadenza,
          r.dta_efficacia_add AS dta_efficacia_add,
          r.cod_stato_proposto AS cod_stato_rischio,
          DECODE (r.cod_matricola_inserente,
                  'BATCH', 'IMPIANTO',
                  R.cod_matricola_inserente)
             AS desc_nominativo_ins,
          COD_CAUSALE_CH_RISTR
     FROM t_mcrei_hst_ristrutturazioni r;
