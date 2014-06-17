/* Formatted on 17/06/2014 18:15:33 (QP5 v5.227.12220.39754) */
CREATE OR REPLACE FORCE VIEW MCRE_OWN.VTMCRE0_APP_ARCHIVIO_FILE
(
   VAL_ARCHIVIO
)
AS
   SELECT    DTA_UPD
          || SUBSTR (LPAD (NVL (COD_RAMO_CALCOLATO, ' '), 6, ' '), 2, 5)
          || LPAD (NVL (COD_DIVISIONE, ' '), 3, ' ')
          || SUBSTR (LPAD (NVL (COD_COMPARTO, ' '), 6, ' '), 2, 5)
          || LPAD (NVL (COD_ABI_CARTOLARIZZATO, ' '), 5, ' ')
          || LPAD (NVL (COD_ABI_ISTITUTO, ' '), 5, ' ')
          || LPAD (NVL (COD_STRUTTURA_COMPETENTE_DC, ' '), 5, ' ')
          || LPAD (NVL (COD_STRUTTURA_COMPETENTE_RG, ' '), 5, ' ')
          || LPAD (NVL (COD_STRUTTURA_COMPETENTE_AR, ' '), 5, ' ')
          || LPAD (NVL (COD_STRUTTURA_COMPETENTE_FI, ' '), 5, ' ')
          || LPAD (NVL (COD_NDG, ' '), 16, ' ')
          || RPAD (NVL (DESC_NOME_CONTROPARTE, ' '), 50, ' ')
          || LPAD (NVL (COD_SNDG, ' '), 16, ' ')
          || LPAD (NVL (COD_GRUPPO_ECONOMICO, ' '), 8, ' ')
          || RPAD (NVL (VAL_ANA_GRE, ' '), 60, ' ')
          || LPAD (NVL (COD_PROCESSO, ' '), 2, ' ')
          || LPAD (NVL (COD_PROCESSO_MESE_PRE, ' '), 2, ' ')
          || LPAD (NVL (SCGB_COD_STATO_SIS, ' '), 3, ' ')
          || LPAD (NVL (COD_STATO_SIS_MESE_PRE, ' '), 3, ' ')
          || LPAD (NVL (COD_STATO, ' '), 2, ' ')
          || LPAD (NVL (COD_STATO_PRE, ' '), 2, ' ')
          || LPAD (NVL (TO_CHAR (DTA_DECORRENZA_STATO, 'DDMMYY'), ' '),
                   6,
                   ' ')
          || LPAD (NVL (TO_CHAR (DTA_SCADENZA_STATO, 'DDMMYY'), ' '), 6, ' ')
          || LPAD (NVL (NUM_GG_SERVIZIO, 0), 4, '0')
          || LPAD (NVL (NUM_GG_SCONFINO, 0), 4, '0')
          || LPAD (NVL (COD_TIPO_PORTAFOGLIO, ' '), 1, ' ')
          || RPAD (NVL (DESC_TIPO_PORT, ' '), 30, ' ')
          || LPAD (NVL (ROUND (SCSB_ACC_CASSA, 2), 0), 15, '0')
          || LPAD (NVL (ROUND (SCSB_ACC_FIRMA, 2), 0), 15, '0')
          || LPAD (NVL (ROUND (SCSB_ACC_SOSTITUZIONI, 2), 0), 15, '0')
          || LPAD (NVL (ROUND (SCSB_ACC_TOT, 2), 0), 15, '0')
          || LPAD (NVL (ROUND (SCSB_UTI_CASSA, 2), 0), 15, '0')
          || LPAD (NVL (ROUND (SCSB_UTI_FIRMA, 2), 0), 15, '0')
          || LPAD (NVL (ROUND (SCSB_UTI_SOSTITUZIONI, 2), 0), 15, '0')
          || LPAD (NVL (ROUND (SCSB_UTI_TOT, 2), 0), 15, '0')
          || LPAD (NVL (ROUND (SCGB_ACC_TOT, 2), 0), 15, '0')
          || LPAD (NVL (ROUND (SCGB_UTI_TOT, 2), 0), 15, '0')
          || LPAD (NVL (ROUND (GEB_ACC_TOT, 2), 0), 15, '0')
          || LPAD (NVL (ROUND (GEGB_UTI_TOT, 2), 0), 15, '0')
          || LPAD (NVL (ROUND (GB_VAL_MAU, 2), 0), 15, '0')
          || LPAD (NVL (COD_MATRICOLA, ' '), 7, ' ')
          || RPAD (NVL (COGNOME, ' '), 25, ' ')
          || LPAD (NVL (TO_CHAR (DTA_UTENTE_ASSEGNATO, 'DDMMYY'), ' '),
                   6,
                   ' ')
          || LPAD (NVL (COD_RAE, ' '), 3, ' ')
          || LPAD (NVL (COD_SAE, ' '), 3, ' ')
          || LPAD (NVL (COD_SEGMENTO_REGOLAMENTARE, ' '), 20, ' ')
          || LPAD (NVL (ROUND (VAL_UTI_CASSA_SISBA, 2), 0), 15, '0')
          || LPAD (NVL (ROUND (VAL_UTI_FIRMA_SISBA, 2), 0), 15, '0')
          || LPAD (NVL (ROUND (VAL_TOT_MORA_SISBA, 2), 0), 15, '0')
          || LPAD (NVL (ROUND (VAL_TOT_RATEO_SISBA, 2), 0), 15, '0')
          || LPAD (NVL (ROUND (VAL_TOT_UTI_SISBA, 2), 0), 15, '0')
          || LPAD (NVL (ROUND (VAL_DUBBIO_ESITO_CASSA_SISBA, 2), 0), 15, '0')
          || LPAD (NVL (ROUND (VAL_DUBBIO_ESITO_FIRMA_SISBA, 2), 0), 15, '0')
          || LPAD (NVL (ROUND (VAL_DUBBIO_ATT_SISBA, 2), 0), 15, '0')
          || LPAD (NVL (ROUND (VAL_DUBBIO_ESITO_DERIVATI, 2), 0), 15, '0')
          || LPAD (NVL (ROUND (VAL_TOT_DUBBIO_ESITO_NT_ATT, 2), 0), 15, '0')
          || LPAD (NVL (TO_CHAR (DTA_ULTIMA_REVISIONE_PEF, 'DDMMYY'), ' '),
                   6,
                   ' ')
          || RPAD (NVL (COD_ULTIMO_ODE, ' '), 5, ' ')
          || LPAD (NVL (TO_CHAR (DTA_ULTIMA_DELIBERA, 'DDMMYY'), ' '),
                   6,
                   ' ')
          || LPAD (NVL (VAL_TIPO_DELIBERA, ' '), 2, ' ')
          || LPAD (NVL (ROUND (VAL_RETTIFICA_DELIBERA, 2), 0), 15, '0')
          || RPAD (NVL (VAL_OD_ULTIMA_DELIBERA, ' '), 2, ' ')
          || RPAD (NVL (VAL_OD_ULTIMA_DELIBERA_NOTE, ' '), 5, ' ')
             VAL_ARCHIVIO
     FROM MCRE_OWN.VTMCRE0_APP_ARCHIVIO;


GRANT DELETE, INSERT, REFERENCES, SELECT, UPDATE, ON COMMIT REFRESH, QUERY REWRITE, DEBUG, FLASHBACK ON MCRE_OWN.VTMCRE0_APP_ARCHIVIO_FILE TO MCRE_USR;
