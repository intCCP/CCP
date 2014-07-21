/* Formatted on 17/06/2014 18:08:09 (QP5 v5.227.12220.39754) */
CREATE OR REPLACE FORCE VIEW MCRE_OWN.V_MCREI_APP_DETT_RISTR_HST
(
   COD_ABI,
   COD_NDG,
   COD_PROTOCOLLO_DELIBERA,
   COD_PROTOCOLLO_PACCHETTO,
   COD_MICROTIPOLOGIA_DELIB,
   COD_FASE_DELIBERA,
   COD_FASE_MICROTIPOLOGIA,
   COD_FASE_PACCHETTO,
   DESC_TIPO_RISTR,
   DESC_INTENTO_RISTR,
   DTA_EFFICACIA_RISTR,
   DTA_EFFICACIA_ADD,
   DTA_SCADENZA_RISTR,
   COD_STATO_PROPOSTO,
   DTA_CHIUSURA_RISTR,
   COD_MATRICOLA_INSERENTE,
   DESC_DENOMINAZ_INS_DELIBERA,
   DTA_DELIBERA,
   DTA_INS_DELIBERA,
   DTA_CONFERMA_DELIBERA
)
AS
   SELECT --1.     Tipologia ristrutturazione                                        - -> DESC_TIPO_RISTR-> Manuale
 --2.     Intento ristrutturazione                                           - -> desc_INTENTO_RISTR
 --3.     Data efficacia                                                         - -> DTA_EFFICACIA_ristr
 --4.     Data efficacia ristrutturazioni successive                   - -> DTA_EFFICACIA_add
 --5.     Data scadenza ristrutturazione                                - -> DTA_SCADENZA_RISTR -> Manuale
 --6.     Stato di rischio calcolato                                         - -> COD_STATO_PROPOSTO
 --7.     Data chiusura ristrutturazione                                  - -> DTA_CHIUSURA_RISTR
 --8.     Nominativo inserente                                              - -> COD_MATRICOLA_INSERENTE
         d.cod_abi,
         d.cod_ndg,
         d.cod_protocollo_delibera,
         d.cod_protocollo_pacchetto,
         d.cod_microtipologia_delib,
         d.cod_fase_delibera,
         d.cod_fase_microtipologia,
         d.cod_fase_pacchetto,
         d.desc_tipo_ristr,
         ---in realta' contiene il codice del tipo di ristrutturazione
         d.desc_intento_ristr,
         TO_DATE (NULL) dta_efficacia_ristr,
         TO_DATE (NULL) dta_efficacia_add,
         d.dta_scadenza_ristr,
         d.cod_stato_proposto,
         TO_DATE (NULL) dta_chiusura_ristr,
         d.cod_matricola_inserente,                                --DOCUMENTI
         d.desc_denominaz_ins_delibera,
         d.dta_delibera,
         d.dta_ins_delibera,
         d.dta_conferma_delibera
    FROM t_mcrei_hst_delibere d, t_mcrei_cl_tipologie tip
   WHERE     d.flg_attiva = '0'
         AND d.cod_microtipologia_delib = tip.cod_microtipologia
         AND tip.flg_segn_ristr = '1';


GRANT DELETE, INSERT, REFERENCES, SELECT, UPDATE, ON COMMIT REFRESH, QUERY REWRITE, DEBUG, FLASHBACK, MERGE VIEW ON MCRE_OWN.V_MCREI_APP_DETT_RISTR_HST TO MCRE_USR;
