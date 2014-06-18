/* Formatted on 17/06/2014 18:08:34 (QP5 v5.227.12220.39754) */
CREATE OR REPLACE FORCE VIEW MCRE_OWN.V_MCREI_APP_POSIZ_INC_RI_ALL
(
   COD_ABI_ISTITUTO,
   DESC_ISTITUTO,
   COD_ABI_CARTOLARIZZATO,
   COD_NDG,
   DESC_NOME_CONTROPARTE,
   COD_SNDG,
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
   DTA_DECORRENZA_STATO,
   DTA_SCADENZA_STATO,
   DTA_SERVIZIO,
   DTA_SCADENZA_PERM_SERVIZIO,
   ID_UTENTE,
   DTA_UTENTE_ASSEGNATO,
   SCSB_ACC_TOT_CF,
   SCSB_ACC_TOT_D,
   SCSB_UTI_TOT_CF,
   SCSB_UTI_TOT_D,
   VAL_RDV_TOT,
   ULTIMA_TIPOLOGIA_CONF,
   DESC_ULTIMA_TIPOLOGIA_CONF,
   COD_TIPO_GESTIONE,
   COD_COMPARTO,
   ID_REFERENTE
)
AS
   SELECT "COD_ABI_ISTITUTO",
          "DESC_ISTITUTO",
          "COD_ABI_CARTOLARIZZATO",
          "COD_NDG",
          "DESC_NOME_CONTROPARTE",
          "COD_SNDG",
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
          "DTA_DECORRENZA_STATO",
          "DTA_SCADENZA_STATO",
          "DTA_SERVIZIO",
          "DTA_SCADENZA_PERM_SERVIZIO",
          "ID_UTENTE",
          "DTA_UTENTE_ASSEGNATO",
          "SCSB_ACC_TOT_CF",
          "SCSB_ACC_TOT_D",
          "SCSB_UTI_TOT_CF",
          "SCSB_UTI_TOT_D",
          "VAL_RDV_TOT",
          "ULTIMA_TIPOLOGIA_CONF",
          "DESC_ULTIMA_TIPOLOGIA_CONF",
          "COD_TIPO_GESTIONE",
          "COD_COMPARTO",
          "ID_REFERENTE"
     FROM (SELECT *
             FROM (SELECT /*+ full(p) parallel(p,4,1) index(de IXP_T_MCREI_APP_DELIBERE) parallel(f,2,1) parallel_index(f PKT_MCRE0_APP_ALL_DATA)
                              no_parallel(t) no_parallel(u) no_parallel(nor)*/
                         F.COD_ABI_ISTITUTO,
                          F.DESC_ISTITUTO,
                          F.COD_ABI_CARTOLARIZZATO,
                          F.COD_NDG,
                          F.DESC_NOME_CONTROPARTE,
                          F.COD_SNDG,
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
                          F.DTA_DECORRENZA_STATO,
                          F.DTA_SCADENZA_STATO,
                          F.DTA_SERVIZIO,
                          DTA_SCADENZA_STATO AS DTA_SCADENZA_PERM_SERVIZIO,
                          F.ID_UTENTE,
                          F.DTA_UTENTE_ASSEGNATO,
                          F.SCSB_ACC_TOT AS SCSB_ACC_TOT_CF,    --cassa +firma
                          F.SCSB_ACC_SOSTITUZIONI AS SCSB_ACC_TOT_D, --derivati
                          F.SCSB_UTI_TOT AS SCSB_UTI_TOT_CF,    --cassa +firma
                          F.SCSB_UTI_SOSTITUZIONI AS SCSB_UTI_TOT_D, --derivati
                          DE.VAL_RDV_QC_PROGRESSIVA AS VAL_RDV_TOT,
                          DE.COD_MICROTIPOLOGIA_DELIB
                             AS ULTIMA_TIPOLOGIA_CONF,
                          T.DESC_MICROTIPOLOGIA AS DESC_ULTIMA_TIPOLOGIA_CONF,
                          P.COD_TIPO_GESTIONE,
                          DE.VAL_NUM_PROGR_DELIBERA,
                          NVL (F.COD_COMPARTO_ASSEGNATO,
                               F.COD_COMPARTO_CALCOLATO)
                             COD_COMPARTO,
                          U.ID_REFERENTE,
                          RANK ()
                          OVER (
                             PARTITION BY DE.COD_ABI, DE.COD_NDG
                             ORDER BY
                                DE.DTA_CONFERMA_DELIBERA DESC,
                                VAL_NUM_PROGR_DELIBERA DESC)
                             RN
                     FROM T_MCREI_APP_PRATICHE P,
                          T_MCREI_APP_DELIBERE DE,
                          T_MCRE0_APP_ALL_DATA F,
                          MV_MCRE0_DENORM_STR_ORG NOR,
                          --T_MCREI_APP_STIME       ST,
                          T_MCREI_CL_TIPOLOGIE T,
                          T_MCRE0_APP_UTENTI U
                    WHERE     P.COD_ABI = DE.COD_ABI
                          AND P.COD_NDG = DE.COD_NDG
                          AND P.VAL_ANNO_PRATICA = DE.VAL_ANNO_PRATICA
                          AND P.COD_PRATICA = DE.COD_PRATICA
                          AND P.FLG_ATTIVA = '1'
                          AND DE.FLG_ATTIVA = '1'
                          AND DE.COD_MICROTIPOLOGIA_DELIB NOT IN ('CI', 'CS')
                          AND DE.COD_FASE_DELIBERA = 'CO'
                          /*AND DE.COD_ABI = ST.COD_ABI(+)
                          AND DE.COD_NDG = ST.COD_NDG(+)
                          AND DE.COD_PROTOCOLLO_DELIBERA =
                              ST.COD_PROTOCOLLO_DELIBERA(+)
                          AND ST.FLG_ATTIVA(+) = '1'*/
                          AND P.COD_ABI = F.COD_ABI_CARTOLARIZZATO
                          AND P.COD_NDG = F.COD_NDG
                          AND F.TODAY_FLG = '1'
                          AND F.COD_ABI_CARTOLARIZZATO =
                                 NOR.COD_ABI_ISTITUTO_FI
                          AND F.COD_FILIALE = NOR.COD_STRUTTURA_COMPETENTE_FI
                          AND F.COD_STATO IN ('IN', 'RI')
                          AND F.ID_UTENTE = U.ID_UTENTE
                          AND DE.COD_MICROTIPOLOGIA_DELIB =
                                 T.COD_MICROTIPOLOGIA
                          AND T.FLG_ATTIVO = 1) S
            WHERE S.RN = 1);


GRANT DELETE, INSERT, REFERENCES, SELECT, UPDATE, ON COMMIT REFRESH, QUERY REWRITE, DEBUG, FLASHBACK, MERGE VIEW ON MCRE_OWN.V_MCREI_APP_POSIZ_INC_RI_ALL TO MCRE_USR;
