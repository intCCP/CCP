/* Formatted on 17/06/2014 18:08:31 (QP5 v5.227.12220.39754) */
CREATE OR REPLACE FORCE VIEW MCRE_OWN.V_MCREI_APP_POS_CON_CLASS_ALL
(
   COD_SNDG,
   DESC_NOME_CONTROPARTE,
   COD_NDG,
   COD_ABI_ISTITUTO,
   DESC_ISTITUTO,
   COD_ABI_CARTOLARIZZATO,
   COD_GRUPPO_ECONOMICO,
   DESC_GRUPPO_ECONOMICO,
   COD_STRUTTURA_COMPETENTE_DC,
   DESC_STRUTTURA_COMPETENTE_DC,
   COD_STRUTTURA_COMPETENTE_RG,
   DESC_STRUTTURA_COMPETENTE_RG,
   COD_STRUTTURA_COMPETENTE_AR,
   DESC_STRUTTURA_COMPETENTE_AR,
   COD_STRUTTURA_COMPETENTE_FI,
   DESC_STRUTTURA_COMPETENTE_FI,
   COD_PROCESSO,
   COD_STATO,
   COD_STATO_PRECEDENTE,
   ID_UTENTE,
   STATO_PROPOSTO,
   DTA_DECORRENZA_STATO,
   DTA_SCADENZA_STATO,
   DTA_SERVIZIO,
   DTA_APERTURA_DELIBERA,
   DTA_UTENTE_ASSEGNATO,
   SCSB_ACC_TOT_CF,
   SCSB_ACC_TOT_D,
   SCSB_UTI_TOT_CF,
   SCSB_UTI_TOT_D,
   VAL_RDV_TOT,
   ULTIMA_TIPOLOGIA_CONF,
   DESC_ULTIMA_TIPOLOGIA_CONF,
   COD_MACROTIPOLOGIA_DELIB,
   COD_COMPARTO,
   ID_REFERENTE,
   COD_FASE_DELIBERA
)
AS
   SELECT "COD_SNDG",
          "DESC_NOME_CONTROPARTE",
          "COD_NDG",
          "COD_ABI_ISTITUTO",
          "DESC_ISTITUTO",
          "COD_ABI_CARTOLARIZZATO",
          "COD_GRUPPO_ECONOMICO",
          "DESC_GRUPPO_ECONOMICO",
          "COD_STRUTTURA_COMPETENTE_DC",
          "DESC_STRUTTURA_COMPETENTE_DC",
          "COD_STRUTTURA_COMPETENTE_RG",
          "DESC_STRUTTURA_COMPETENTE_RG",
          "COD_STRUTTURA_COMPETENTE_AR",
          "DESC_STRUTTURA_COMPETENTE_AR",
          "COD_STRUTTURA_COMPETENTE_FI",
          "DESC_STRUTTURA_COMPETENTE_FI",
          "COD_PROCESSO",
          "COD_STATO",
          "COD_STATO_PRECEDENTE",
          "ID_UTENTE",
          "STATO_PROPOSTO",
          "DTA_DECORRENZA_STATO",
          "DTA_SCADENZA_STATO",
          "DTA_SERVIZIO",
          "DTA_APERTURA_DELIBERA",
          "DTA_UTENTE_ASSEGNATO",
          "SCSB_ACC_TOT_CF",
          "SCSB_ACC_TOT_D",
          "SCSB_UTI_TOT_CF",
          "SCSB_UTI_TOT_D",
          "VAL_RDV_TOT",
          "ULTIMA_TIPOLOGIA_CONF",
          "DESC_ULTIMA_TIPOLOGIA_CONF",
          "COD_MACROTIPOLOGIA_DELIB",
          "COD_COMPARTO",
          "ID_REFERENTE",
          cod_fase_delibera
     FROM (SELECT *
             FROM (SELECT /*+full(de)
                index(de IXP_T_MCREI_APP_DELIBERE) parallel(f,2,1) parallel_index(f PKT_MCRE0_APP_ALL_DATA)
                no_parallel(t) no_parallel(u) no_parallel(nor)
                */
                         F.COD_SNDG,
                          F.DESC_NOME_CONTROPARTE,
                          F.COD_NDG,
                          F.COD_ABI_ISTITUTO,
                          F.DESC_ISTITUTO,
                          F.COD_ABI_CARTOLARIZZATO,
                          F.COD_GRUPPO_ECONOMICO,
                          F.DESC_GRUPPO_ECONOMICO AS DESC_GRUPPO_ECONOMICO,
                          NOR.COD_STRUTTURA_COMPETENTE_DC,
                          NOR.DESC_STRUTTURA_COMPETENTE_DC,
                          NOR.COD_STRUTTURA_COMPETENTE_RG,
                          NOR.DESC_STRUTTURA_COMPETENTE_RG,
                          NOR.COD_STRUTTURA_COMPETENTE_AR,
                          NOR.DESC_STRUTTURA_COMPETENTE_AR,
                          NOR.COD_STRUTTURA_COMPETENTE_FI,
                          NOR.DESC_STRUTTURA_COMPETENTE_FI,
                          F.COD_PROCESSO,
                          F.COD_STATO,
                          F.COD_STATO_PRECEDENTE,
                          F.ID_UTENTE,
                          DECODE (DE.COD_MICROTIPOLOGIA_DELIB,
                                  'CI', 'IN',
                                  'CS', 'SO')
                             AS STATO_PROPOSTO,
                          F.DTA_DECORRENZA_STATO,
                          F.DTA_SCADENZA_STATO,
                          F.DTA_SERVIZIO,
                          DE.DTA_DELIBERA AS DTA_APERTURA_DELIBERA,
                          F.DTA_UTENTE_ASSEGNATO,
                          F.SCSB_ACC_TOT AS SCSB_ACC_TOT_CF, --ACC CASSA+FIRMA
                          F.SCSB_ACC_SOSTITUZIONI AS SCSB_ACC_TOT_D, --ACC DERIVATI
                          F.SCSB_UTI_TOT AS SCSB_UTI_TOT_CF, --ACC CASSA+FIRMA
                          F.SCSB_UTI_SOSTITUZIONI AS SCSB_UTI_TOT_D, --ACC DERIVATI
                          DE.VAL_RDV_QC_PROGRESSIVA AS VAL_RDV_TOT,
                          DE.COD_MICROTIPOLOGIA_DELIB
                             AS ULTIMA_TIPOLOGIA_CONF,
                          T.DESC_MICROTIPOLOGIA AS DESC_ULTIMA_TIPOLOGIA_CONF,
                          DE.DTA_CONFERMA_DELIBERA,
                          DE.COD_MACROTIPOLOGIA_DELIB,
                          NVL (F.COD_COMPARTO_ASSEGNATO,
                               F.COD_COMPARTO_CALCOLATO)
                             COD_COMPARTO,
                          U.ID_REFERENTE,
                          cod_fase_Delibera,
                          RANK ()
                          OVER (
                             PARTITION BY DE.COD_ABI, DE.COD_NDG
                             ORDER BY
                                DE.DTA_CONFERMA_DELIBERA DESC,
                                de.val_progr_proposta DESC)
                             RN
                     FROM T_MCREI_APP_DELIBERE DE,
                          T_MCRE0_APP_ALL_DATA F,
                          MV_MCRE0_DENORM_STR_ORG NOR,
                          T_MCREI_CL_TIPOLOGIE T,
                          T_MCRE0_APP_UTENTI U
                    WHERE     DE.COD_ABI = F.COD_ABI_CARTOLARIZZATO
                          AND DE.COD_NDG = F.COD_NDG
                          AND DE.COD_MICROTIPOLOGIA_DELIB IN ('CI', 'CS')
                          AND DE.COD_PRATICA IS NULL
                          AND de.flg_Attiva = '1'
                          AND COD_FASE_DELIBERA = 'CO'
                          AND F.TODAY_FLG = '1' -- CLASSIFICAZIONI ANCORA IN ATTESA DI PRATICA, OPPURE CON STATO_DELIBERA CONF O IN ATTESA
                          AND DE.COD_MICROTIPOLOGIA_DELIB =
                                 T.COD_MICROTIPOLOGIA
                          AND T.FLG_ATTIVO = 1
                          AND F.COD_ABI_CARTOLARIZZATO =
                                 NOR.COD_ABI_ISTITUTO_FI
                          AND F.COD_FILIALE = NOR.COD_STRUTTURA_COMPETENTE_FI
                          AND F.ID_UTENTE = U.ID_UTENTE) S
            WHERE S.RN = 1);


GRANT DELETE, INSERT, REFERENCES, SELECT, UPDATE, ON COMMIT REFRESH, QUERY REWRITE, DEBUG, FLASHBACK, MERGE VIEW ON MCRE_OWN.V_MCREI_APP_POS_CON_CLASS_ALL TO MCRE_USR;
