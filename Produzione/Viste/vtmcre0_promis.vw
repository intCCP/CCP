/* Formatted on 17/06/2014 18:17:30 (QP5 v5.227.12220.39754) */
CREATE OR REPLACE FORCE VIEW MCRE_OWN.VTMCRE0_PROMIS
(
   COMPARTO,
   ABI,
   COD_NDG,
   DATA_DOCUMENTO,
   LINE
)
AS
     SELECT DISTINCT
            comparto,
            abi,
            cod_ndg,
            Data_Documento,
            REPLACE (
                  comparto
               || ';'
               || Data_Documento
               || ';'
               || ABI
               || ';'
               || COD_NDG
               || ';'
               || COD_PERCORSO
               || ';'
               || COD_STATO
               || ';'
               || COD_STATO_PRECEDENTE
               || ';'
               || DTA_DECORRENZA_STATO
               || ';'
               || DTA_SCADENZA_STATO
               || ';'
               || TipoDoc
               || ';'
               || VAL_CLASSIFICAZIONE
               || ';'
               || nome_doc
               || ';'
               || cod_filiale
               || ';'
               || m.cod_struttura_competente_ar
               || ';'
               || m.desc_struttura_competente_ar,
               CHR (10),
               '')
               line
       FROM (  SELECT SUBSTR (MIN (dtcomp), 13) COMPARTO,
                      Data_Documento,
                      ABI,
                      COD_NDG,
                      COD_PERCORSO,
                      COD_STATO,
                      COD_STATO_PRECEDENTE,
                      DTA_DECORRENZA_STATO,
                      DTA_SCADENZA_STATO,
                      TipoDoc,
                      VAL_CLASSIFICAZIONE,
                      nome_doc,
                      cod_filiale                            --, min( dtcomp )
                 FROM (  SELECT NVL (
                                   NVL (s.COD_COMPARTO_assegnato,
                                        s.COD_COMPARTO_CALCOLATO),
                                   NVL (a.COD_COMPARTO_assegnato,
                                        a.COD_COMPARTO_CALCOLATO))
                                   COMPARTO,
                                d.DTA_ISN Data_Documento,
                                d.COD_ABI_CARTOLARIZZATO ABI,
                                d.COD_NDG,
                                d.COD_PERCORSO,
                                d.COD_STATO,
                                d.COD_STATO_PRECEDENTE,
                                d.DTA_DECORRENZA_STATO,
                                d.DTA_SCADENZA_STATO,
                                d.VAL_DOC_TYPE TipoDoc,
                                d.VAL_CLASSIFICAZIONE,
                                d.val_doc_name nome_doc,
                                s.cod_filiale,
                                MIN (
                                      NVL (
                                         TO_CHAR (s.dta_fine_validita,
                                                  'yyyymmddhh24mi'),
                                         ' ')
                                   || NVL (
                                         NVL (s.COD_COMPARTO_assegnato,
                                              s.COD_COMPARTO_CALCOLATO),
                                         NVL (a.COD_COMPARTO_assegnato,
                                              a.COD_COMPARTO_CALCOLATO)))
                                   dtcomp
                           FROM t_mcre0_app_documenti d,
                                T_MCRE0_APP_STORICO_EVENTI s,
                                t_mcre0_app_all_data_DAY a
                          WHERE     d.val_doc_type IN
                                       ('VERBALE_TAVOLO', 'PIANO_AZIONE')
                                AND d.cod_abi_cartolarizzato =
                                       s.cod_abi_cartolarizzato(+)
                                AND d.cod_ndg = s.cod_ndg(+)
                                AND d.cod_stato = s.cod_stato(+)
                                AND d.cod_stato_precedente =
                                       s.cod_stato_precedente(+)
                                AND d.dta_decorrenza_stato =
                                       s.dta_decorrenza_stato(+)
                                AND d.cod_percorso = s.cod_percorso(+)
                                AND dta_isn <= s.dta_fine_validita(+)
                                AND dta_isn BETWEEN TO_DATE ('01/01/2013',
                                                             'dd/mm/yyyy')
                                                AND TO_DATE ('31/01/2013',
                                                             'dd/mm/yyyy')
                                AND d.cod_abi_cartolarizzato =
                                       a.cod_abi_cartolarizzato
                                AND d.cod_ndg = a.cod_ndg
                       --and d.cod_abi_cartolarizzato = '01025' and d.cod_ndg = '0007575634322000'
                       GROUP BY NVL (
                                   NVL (s.COD_COMPARTO_assegnato,
                                        s.COD_COMPARTO_CALCOLATO),
                                   NVL (a.COD_COMPARTO_assegnato,
                                        a.COD_COMPARTO_CALCOLATO)),
                                d.DTA_ISN,
                                d.COD_ABI_CARTOLARIZZATO,
                                d.COD_NDG,
                                d.COD_PERCORSO,
                                d.COD_STATO,
                                d.COD_STATO_PRECEDENTE,
                                d.DTA_DECORRENZA_STATO,
                                d.DTA_SCADENZA_STATO,
                                d.VAL_DOC_TYPE,
                                d.VAL_CLASSIFICAZIONE,
                                d.val_doc_name,
                                s.cod_filiale,
                                   TO_CHAR (s.dta_fine_validita,
                                            'yyyymmddhh24mi')
                                || NVL (
                                      NVL (s.COD_COMPARTO_assegnato,
                                           s.COD_COMPARTO_CALCOLATO),
                                      NVL (a.COD_COMPARTO_assegnato,
                                           a.COD_COMPARTO_CALCOLATO)))
             GROUP BY Data_Documento,
                      ABI,
                      COD_NDG,
                      COD_PERCORSO,
                      COD_STATO,
                      COD_STATO_PRECEDENTE,
                      DTA_DECORRENZA_STATO,
                      DTA_SCADENZA_STATO,
                      TipoDoc,
                      VAL_CLASSIFICAZIONE,
                      nome_doc,
                      cod_filiale) z,
            MV_MCRE0_DENORM_STR_ORG m
      WHERE     m.cod_abi_istituto_fi = z.abi(+)
            AND m.cod_struttura_competente_fi = z.cod_filiale(+)
   ORDER BY comparto,
            Data_Documento DESC,
            abi,
            cod_ndg;


GRANT DELETE, INSERT, REFERENCES, SELECT, UPDATE, ON COMMIT REFRESH, QUERY REWRITE, DEBUG, FLASHBACK ON MCRE_OWN.VTMCRE0_PROMIS TO MCRE_USR;
