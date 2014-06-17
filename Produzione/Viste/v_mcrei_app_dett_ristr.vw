/* Formatted on 17/06/2014 18:08:08 (QP5 v5.227.12220.39754) */
CREATE OR REPLACE FORCE VIEW MCRE_OWN.V_MCREI_APP_DETT_RISTR
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
 --2.   Intento ristrutturazione                                           - -> desc_INTENTO_RISTR
 --3.   Data efficacia                                                         - -> DTA_EFFICACIA_ristr
 --4.   Data efficacia ristrutturazioni successive                   - -> DTA_EFFICACIA_add
 --5.   Data scadenza ristrutturazione                                - -> DTA_SCADENZA_RISTR -> Manuale
 --6.   Stato di rischio calcolato                                         - -> COD_STATO_PROPOSTO
 --7.   Data chiusura ristrutturazione                                  - -> DTA_CHIUSURA_RISTR
 --8.   Nominativo inserente                                              - -> COD_MATRICOLA_INSERENTE
         d.cod_abi,
         d.cod_ndg,
         d.cod_protocollo_delibera,
         d.cod_protocollo_pacchetto,
         d.cod_microtipologia_delib,
         d.cod_fase_delibera,
         d.cod_fase_microtipologia,
         d.cod_fase_pacchetto,
         d.desc_tipo_ristr, ---in realta' contiene il codice del tipo di ristrutturazione
         d.desc_intento_ristr,
         NVL (d.dta_efficacia_ristr, SYSDATE) AS dta_efficacia_ristr,
         (CASE
             --se la delibera e' dopo la conferma della ristrutturazione
             WHEN d.cod_fase_delibera NOT IN ('IN', 'CM', 'AT', 'CA', 'CO') --allora si visualizza la data efficacia addendum salvata sulla delibera
             THEN
                d.dta_efficacia_add
             --se la delibera e' prima della conferma della ristrutturazione
             --e la data efficacia addendum non e' NULL sulla delibera
             WHEN d.dta_efficacia_add IS NOT NULL --allora mostro la data efficacia addendum salvata sulla delibera
             THEN
                d.dta_efficacia_add
             --se la delibera e' prima della conferma della ristrutturazione
             --e la data efficacia addendum e' NULL sulla delibera
             --e la data efficacia (prima) ristrutturazione e' NULL
             WHEN d.cod_microtipologia_delib = 'IR'                 ----26 FEB
             THEN
                d.dta_efficacia_add
             WHEN d.dta_efficacia_ristr IS NULL --allora mostro NULL come data efficacia addendum
             THEN
                NULL
             ELSE     --altrimenti mostro SYSDATE come data efficacia addendum
                SYSDATE
          END)
            AS dta_efficacia_add,
         --d.dta_efficacia_add,
         --se assente,prende la eventuale max dta_scad_transaz delle delib con flg_contab_ademp nell tipologie all'interno del pacchetto di riferimento
         NVL (
            d.dta_scadenza_ristr,
            (SELECT MAX (dta_scadenza_transaz)
               FROM t_mcrei_app_delibere de, t_mcrei_cl_tipologie tip
              WHERE     de.flg_attiva = '1'
                    AND de.cod_microtipologia_delib = tip.cod_microtipologia
                    AND flg_contab_ademp = 1
                    AND de.cod_protocollo_pacchetto = d.cod_protocollo_pacchetto
                    AND de.cod_abi = d.cod_abi
                    AND de.cod_ndg = d.cod_ndg
                    AND de.flg_no_delibera = 0))
            AS dta_scadenza_ristr,                                ----5 luglio
         d.cod_stato_post_ristr,                                   --13 luglio
         d.dta_chiusura_ristr,
         DECODE (
            COD_MICROTIPOLOGIA_dELIB,
            'IR', d.cod_matricola_inserente || ' ' || TRUNC (DTA_INS_dELIBERA),
            d.cod_matricola_inserente)
            AS cod_matricola_inserente,                            --DOCUMENTI
         d.desc_denominaz_ins_delibera,
         d.dta_delibera,
         d.dta_ins_delibera,
         d.dta_conferma_delibera
    FROM t_mcrei_app_delibere d, t_mcrei_cl_tipologie tip
   WHERE     d.flg_attiva = '1'
         AND flg_no_Delibera = 0
         AND cod_fase_Delibera != 'AN'
         AND d.cod_microtipologia_delib = tip.cod_microtipologia
         AND (tip.flg_segn_ristr = '1' OR d.cod_microtipologia_delib = 'B8');


GRANT DELETE, INSERT, REFERENCES, SELECT, UPDATE, ON COMMIT REFRESH, QUERY REWRITE, DEBUG, FLASHBACK, MERGE VIEW ON MCRE_OWN.V_MCREI_APP_DETT_RISTR TO MCRE_USR;
