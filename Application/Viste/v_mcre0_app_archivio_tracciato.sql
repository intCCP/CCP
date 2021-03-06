/* Formatted on 21/07/2014 18:33:17 (QP5 v5.227.12220.39754) */
CREATE OR REPLACE FORCE VIEW MCRE_OWN.V_MCRE0_APP_ARCHIVIO_TRACCIATO
(
   DTA_UPD,
   COD_RAMO_CALCOLATO,
   COD_DIVISIONE,
   COD_COMPARTO,
   COD_ABI_CARTOLARIZZATO,
   COD_ABI_ISTITUTO,
   COD_STRUTTURA_COMPETENTE_DC,
   COD_STRUTTURA_COMPETENTE_RG,
   COD_STRUTTURA_COMPETENTE_AR,
   COD_STRUTTURA_COMPETENTE_FI,
   COD_NDG,
   DESC_NOME_CONTROPARTE,
   COD_SNDG,
   COD_GRUPPO_ECONOMICO,
   VAL_ANA_GRE,
   COD_PROCESSO,
   COD_PROCESSO_MESE_PRE,
   SCGB_COD_STATO_SIS,
   COD_STATO_SIS_MESE_PRE,
   COD_STATO,
   COD_STATO_PRE,
   DTA_DECORRENZA_STATO,
   DTA_SCADENZA_STATO,
   NUM_GG_SERVIZIO,
   NUM_GG_SCONFINO,
   COD_TIPO_PORTAFOGLIO,
   DESC_TIPO_PORT,
   SCSB_ACC_CASSA,
   SCSB_ACC_FIRMA,
   SCSB_ACC_SOSTITUZIONI,
   SCSB_ACC_TOT,
   SCSB_UTI_CASSA,
   SCSB_UTI_FIRMA,
   SCSB_UTI_SOSTITUZIONI,
   SCSB_UTI_TOT,
   SCGB_ACC_TOT,
   SCGB_UTI_TOT,
   GEB_ACC_TOT,
   GEGB_UTI_TOT,
   GB_VAL_MAU,
   COD_MATRICOLA,
   COGNOME,
   DTA_UTENTE_ASSEGNATO,
   COD_RAE,
   COD_SAE,
   COD_SEGMENTO_REGOLAMENTARE,
   VAL_UTI_CASSA_SISBA,
   VAL_UTI_FIRMA_SISBA,
   VAL_TOT_MORA_SISBA,
   VAL_TOT_RATEO_SISBA,
   VAL_TOT_UTI_SISBA,
   VAL_DUBBIO_ESITO_CASSA_SISBA,
   VAL_DUBBIO_ESITO_FIRMA_SISBA,
   VAL_DUBBIO_ATT_SISBA,
   VAL_DUBBIO_ESITO_DERIVATI,
   VAL_TOT_DUBBIO_ESITO_NT_ATT,
   DTA_ULTIMA_REVISIONE_PEF,
   COD_ULTIMO_ODE,
   DTA_ULTIMA_DELIBERA,
   VAL_TIPO_DELIBERA,
   VAL_RETTIFICA_DELIBERA,
   VAL_OD_ULTIMA_DELIBERA,
   VAL_OD_ULTIMA_DELIBERA_NOTE
)
AS
   SELECT DTA_UPD,
          SUBSTR (LPAD (NVL (COD_RAMO_CALCOLATO, ' '), 6, ' '), 2, 5)
             COD_RAMO_CALCOLATO,
          LPAD (NVL (COD_DIVISIONE, ' '), 3, ' ') COD_DIVISIONE,
          SUBSTR (LPAD (NVL (COD_COMPARTO, ' '), 6, ' '), 2, 5) COD_COMPARTO,
          LPAD (NVL (COD_ABI_CARTOLARIZZATO, ' '), 5, ' ')
             COD_ABI_CARTOLARIZZATO,
          LPAD (NVL (COD_ABI_ISTITUTO, ' '), 5, ' ') COD_ABI_ISTITUTO,
          LPAD (NVL (COD_STRUTTURA_COMPETENTE_DC, ' '), 5, ' ')
             COD_STRUTTURA_COMPETENTE_DC,
          LPAD (NVL (COD_STRUTTURA_COMPETENTE_RG, ' '), 5, ' ')
             COD_STRUTTURA_COMPETENTE_RG,
          LPAD (NVL (COD_STRUTTURA_COMPETENTE_AR, ' '), 5, ' ')
             COD_STRUTTURA_COMPETENTE_AR,
          LPAD (NVL (COD_STRUTTURA_COMPETENTE_FI, ' '), 5, ' ')
             COD_STRUTTURA_COMPETENTE_FI,
          LPAD (NVL (COD_NDG, ' '), 16, ' ') COD_NDG,
          RPAD (NVL (DESC_NOME_CONTROPARTE, ' '), 50, ' ')
             DESC_NOME_CONTROPARTE,
          LPAD (NVL (COD_SNDG, ' '), 16, ' ') COD_SNDG,
          LPAD (NVL (COD_GRUPPO_ECONOMICO, ' '), 8, ' ') COD_GRUPPO_ECONOMICO,
          RPAD (NVL (VAL_ANA_GRE, ' '), 60, ' ') VAL_ANA_GRE,
          LPAD (NVL (COD_PROCESSO, ' '), 2, ' ') COD_PROCESSO,
          LPAD (NVL (COD_PROCESSO_MESE_PRE, ' '), 2, ' ')
             COD_PROCESSO_MESE_PRE,
          LPAD (NVL (SCGB_COD_STATO_SIS, ' '), 3, ' ') SCGB_COD_STATO_SIS,
          LPAD (NVL (COD_STATO_SIS_MESE_PRE, ' '), 3, ' ')
             COD_STATO_SIS_MESE_PRE,
          LPAD (NVL (COD_STATO, ' '), 2, ' ') COD_STATO,
          LPAD (NVL (COD_STATO_PRE, ' '), 2, ' ') COD_STATO_PRE,
          LPAD (NVL (TO_CHAR (DTA_DECORRENZA_STATO, 'DDMMYY'), ' '), 6, ' ')
             DTA_DECORRENZA_STATO,
          LPAD (NVL (TO_CHAR (DTA_SCADENZA_STATO, 'DDMMYY'), ' '), 6, ' ')
             DTA_SCADENZA_STATO,
          LPAD (NVL (NUM_GG_SERVIZIO, 0), 4, '0') NUM_GG_SERVIZIO,
          LPAD (NVL (NUM_GG_SCONFINO, 0), 4, '0') NUM_GG_SCONFINO,
          LPAD (NVL (COD_TIPO_PORTAFOGLIO, ' '), 1, ' ') COD_TIPO_PORTAFOGLIO,
          RPAD (NVL (DESC_TIPO_PORT, ' '), 30, ' ') DESC_TIPO_PORT,
          LPAD (NVL (ROUND (SCSB_ACC_CASSA, 2), 0), 15, '0') SCSB_ACC_CASSA,
          LPAD (NVL (ROUND (SCSB_ACC_FIRMA, 2), 0), 15, '0') SCSB_ACC_FIRMA,
          LPAD (NVL (ROUND (SCSB_ACC_SOSTITUZIONI, 2), 0), 15, '0')
             SCSB_ACC_SOSTITUZIONI,
          LPAD (NVL (ROUND (SCSB_ACC_TOT, 2), 0), 15, '0') SCSB_ACC_TOT,
          LPAD (NVL (ROUND (SCSB_UTI_CASSA, 2), 0), 15, '0') SCSB_UTI_CASSA,
          LPAD (NVL (ROUND (SCSB_UTI_FIRMA, 2), 0), 15, '0') SCSB_UTI_FIRMA,
          LPAD (NVL (ROUND (SCSB_UTI_SOSTITUZIONI, 2), 0), 15, '0')
             SCSB_UTI_SOSTITUZIONI,
          LPAD (NVL (ROUND (SCSB_UTI_TOT, 2), 0), 15, '0') SCSB_UTI_TOT,
          LPAD (NVL (ROUND (SCGB_ACC_TOT, 2), 0), 15, '0') SCGB_ACC_TOT,
          LPAD (NVL (ROUND (SCGB_UTI_TOT, 2), 0), 15, '0') SCGB_UTI_TOT,
          LPAD (NVL (ROUND (GEB_ACC_TOT, 2), 0), 15, '0') GEB_ACC_TOT,
          LPAD (NVL (ROUND (GEGB_UTI_TOT, 2), 0), 15, '0') GEGB_UTI_TOT,
          LPAD (NVL (ROUND (GB_VAL_MAU, 2), 0), 15, '0') GB_VAL_MAU,
          LPAD (NVL (COD_MATRICOLA, ' '), 7, ' ') COD_MATRICOLA,
          RPAD (NVL (COGNOME, ' '), 25, ' ') COGNOME,
          LPAD (NVL (TO_CHAR (DTA_UTENTE_ASSEGNATO, 'DDMMYY'), ' '), 6, ' ')
             DTA_UTENTE_ASSEGNATO,
          LPAD (NVL (COD_RAE, ' '), 3, ' ') COD_RAE,
          LPAD (NVL (COD_SAE, ' '), 3, ' ') COD_SAE,
          LPAD (NVL (COD_SEGMENTO_REGOLAMENTARE, ' '), 20, ' ')
             COD_SEGMENTO_REGOLAMENTARE,
          LPAD (NVL (ROUND (VAL_UTI_CASSA_SISBA, 2), 0), 15, '0')
             VAL_UTI_CASSA_SISBA,
          LPAD (NVL (ROUND (VAL_UTI_FIRMA_SISBA, 2), 0), 15, '0')
             VAL_UTI_FIRMA_SISBA,
          LPAD (NVL (ROUND (VAL_TOT_MORA_SISBA, 2), 0), 15, '0')
             VAL_TOT_MORA_SISBA,
          LPAD (NVL (ROUND (VAL_TOT_RATEO_SISBA, 2), 0), 15, '0')
             VAL_TOT_RATEO_SISBA,
          LPAD (NVL (ROUND (VAL_TOT_UTI_SISBA, 2), 0), 15, '0')
             VAL_TOT_UTI_SISBA,
          LPAD (NVL (ROUND (VAL_DUBBIO_ESITO_CASSA_SISBA, 2), 0), 15, '0')
             VAL_DUBBIO_ESITO_CASSA_SISBA,
          LPAD (NVL (ROUND (VAL_DUBBIO_ESITO_FIRMA_SISBA, 2), 0), 15, '0')
             VAL_DUBBIO_ESITO_FIRMA_SISBA,
          LPAD (NVL (ROUND (VAL_DUBBIO_ATT_SISBA, 2), 0), 15, '0')
             VAL_DUBBIO_ATT_SISBA,
          LPAD (NVL (ROUND (VAL_DUBBIO_ESITO_DERIVATI, 2), 0), 15, '0')
             VAL_DUBBIO_ESITO_DERIVATI,
          LPAD (NVL (ROUND (VAL_TOT_DUBBIO_ESITO_NT_ATT, 2), 0), 15, '0')
             VAL_TOT_DUBBIO_ESITO_NT_ATT,
          LPAD (NVL (TO_CHAR (DTA_ULTIMA_REVISIONE_PEF, 'DDMMYY'), ' '),
                6,
                ' ')
             DTA_ULTIMA_REVISIONE_PEF,
          RPAD (NVL (COD_ULTIMO_ODE, ' '), 5, ' ') COD_ULTIMO_ODE,
          LPAD (NVL (TO_CHAR (DTA_ULTIMA_DELIBERA, 'DDMMYY'), ' '), 6, ' ')
             DTA_ULTIMA_DELIBERA,
          LPAD (NVL (VAL_TIPO_DELIBERA, ' '), 2, ' ') VAL_TIPO_DELIBERA,
          LPAD (NVL (ROUND (VAL_RETTIFICA_DELIBERA, 2), 0), 15, '0')
             VAL_RETTIFICA_DELIBERA,
          RPAD (NVL (VAL_OD_ULTIMA_DELIBERA, ' '), 2, ' ')
             VAL_OD_ULTIMA_DELIBERA,
          RPAD (NVL (VAL_OD_ULTIMA_DELIBERA_NOTE, ' '), 5, ' ')
             VAL_OD_ULTIMA_DELIBERA_NOTE
     -- val_archivio
     FROM MCRE_OWN.V_MCRE0_APP_ARCHIVIO;
