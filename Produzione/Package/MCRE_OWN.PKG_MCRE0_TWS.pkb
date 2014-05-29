CREATE OR REPLACE PACKAGE BODY MCRE_OWN."PKG_MCRE0_TWS" AS
/******************************************************************************
   NAME:       PKG_MCR0_TWS
   PURPOSE:

   REVISIONS:
   Ver        Date        Author             Description
   ---------  ----------  -----------------  ------------------------------------
   1.0        30/03/2011  Luca Ferretti     Created this package.
   1.1        13/06/2011  Luca Ferretti     Aggiornamento funzione di log e ristruttuturazione chiamate
   1.2        21/06/2011  Luca Ferretti     Modifica valore di uscita
   1.3        07/07/2011  M.Murro           aggiunta gestione GB/AV
   1.4        24/08/2011  Luca Ferretti     Modifiche per attivit¿ tuning Goitre/Murro
   1.5        06/10/2011  Luca Ferretti     Inserimento progressivo per log
   1.6        14/10/2011  Luca Ferretti     Aggiornamento log
   1.7        14/10/2011  Luca Ferretti     Spalmamento Alert
   1.8        14/10/2011  Luca Ferretti     Aggiunta Clean Alert post-alert
   1.9        18/10/2011  Luca Ferretti     Correzione log e eliminazione doppio calcolo ALERT
   2.0        16/11/2011  Luca Ferretti     Aggiunta controlli dopo apertura portale
   2.1        21/11/2011  M.Murro           Accodato ex L5G1 L5G7 e L5G8 a L4G1 (AnaGen e uscite)
   2.2        22/11/2011  Luca Ferretti     Modifica controlli post apertura portale
   2.3        19/12/2011  Paola Goitre      PKG 2
   2.4        20/12/2011  Luca Ferretti     Rimesse in serie MOPLE e FILE_GUIDA
   2.5        17/01/2012  Luca Ferretti     Modifica ordine esecuzione per test in system di caricamento in parallelo (modifiche Paola).
   2.6        20/01/2012  Luca Ferretti     Aggiunta Refresh Aggregate per M.Murro
   2.7        13/02/2012  Paola Goitre      Spostato ini(alert da 1_4 a 4_1)
   2.8        16/02/2012  Luca Ferretti     Eliminazione Analyze PCR e CR in secondo livello
   2.9        23/03/2012  Luca Ferretti     Nuova PCR di Paola (PCR3)+PCR_RAPP_AGGR
   3.0        02/04/2012  Luca Ferretti     Aggiunto livello 3_12, 3_13 e 3_14 per PCR in parallelo (nuovo albero schedulazione)
                                            Aggiunto livello 3_22, 3_23, 3_24, 3_25, 3_26 per CR in parallelo (nuovo albero schedulazione)
                                            Aggiunto livello da 5_01 a 5_31 per livello ALERT in parallelo.
   3.1        26/06/2012  Luca Ferretti     Commentata invocazione a ESTENDI_MOPLE.UPD_GB_STATUS
   3.2        02/08/2012  Luca Ferretti     Aggiunta procedura per scrittura file con errore e passi da intraprendere
   3.3        20/08/2012  Luca Ferretti     Eliminata chiamata a package controlli
   3.4        26/09/2012  Luca Ferretti     Migliorata gestione eccezione
   3.5        08/10/2012  Luca Ferretti     Modifica gestione eccezioni su svecchiamento (tolto return errore e lasciata solo la segnalazione)
   3.6        06/11/2012  Valeria Galli     Aggiunto nuovo calcolo alert
   3.7        27/11/2012  Luca Ferretti     Rimosso controllo esito procedura PKG_MCREI_REFRESH_AGGREGATE.FNC_UPD_RATE_IMPAGATE (non bloccante)
   3.8        06/12/2012  Luca Ferretti     Aggiunta controllo POST_ETL
   3.9        10/12/2012 Valeria Galli      Nuova gestione alert
   3.10       12/12/2012  I.Gueorguieva     Gestione Alert MCREI
   3.11       17/12/2012  Luca Ferretti     Modifica log livello 1_3
   3.12       07/01/2013  Valeria Galli     Commentata nuova gestione alert post controlli
   3.13       09/01/2013  Federico Galletti Aggiunto la procedura per la copia della all_data e spostato l'apertura del portale al livello 5g_10
   3.14       09/01/2012  I.Gueorguieva     Commentata chiamata MCRE_OWN.PKG_MCRE0_CONTROLLO_ACQ.SPO_MCRE0_CONTROLLO_POST_ETL in attesa che venga portato il PKG
   3.15       15/01/2013  F.Galletti        Fix nella procedura copy all data
   3.16       05/02/2013   F. Galletti      Spostato la truncate del tmp_storico al livello 4g1 ed inserito le modifiche commentate per il nuovo albero di schedulatura
   3.17       11/04/2013   M.Murro          aggiunta fill-all_data_day chiamata in Apri_portale
   3.18       24/04/2013   M.Murro          aggiunta gestione soff nn in portafoglio chiamata in Apri_portale
   4.0        06/02/2014   M.Murro          -switch etl: non apre il portale
   4.1        10/02/2014   M.Murro          -switch etl: riapre il portale + insert esplicita all_data%
******************************************************************************/

    RetVal number:=0;
    esito  number:=0;
    seq number;
    V_TOT_ALERT number;
    V_RESULT_CLEAN number;
    ret_analyze boolean;
    id_alert number;

 PROCEDURE TWS_MCRE0_COPY_ALL_DATA AS
    v_tsrc VARCHAR2(3200);
    v_ttrg VARCHAR2(3200);
    v_day VARCHAR2(3200);
    v_sql VARCHAR2(32000);
    v_sess VARCHAR2(3200);
    BEGIN
    select SEQ_MCR0_LOG_ETL.nextval into seq from dual;
    v_sess:='ALTER SESSION SET NLS_LANGUAGE= ''ITALIAN''';
   -- DBMS_OUTPUT.PUT_LINE(v_sess);
    execute immediate v_sess;
    v_tsrc := 'T_MCRE0_APP_ALL_DATA';
    select to_char(sysdate,'DY') into v_day from dual;
    v_ttrg := v_tsrc||'_'||v_day;
       PKG_MCRE0_AUDIT.log_etl (seq, '0 - PKG_MCRE0_TWS - INI - TWS_MCRE0_COPY_ALL_DATA', PKG_MCRE0_AUDIT.C_DEBUG, sqlcode, 'INIZIO', 'INIZIO-Truncate tabella backup');
    v_sql := 'truncate table '||v_ttrg;
    --DBMS_OUTPUT.PUT_LINE(v_day);
    EXECUTE IMMEDIATE v_sql;
     PKG_MCRE0_AUDIT.log_etl (seq, '0 - PKG_MCRE0_TWS - END - TWS_MCRE0_COPY_ALL_DATA', PKG_MCRE0_AUDIT.C_DEBUG, sqlcode, 'FINE', 'FINE-Truncate tabella backup');
     PKG_MCRE0_AUDIT.log_etl (seq, '0 - PKG_MCRE0_TWS - INI - TWS_MCRE0_COPY_ALL_DATA', PKG_MCRE0_AUDIT.C_DEBUG, sqlcode, 'INIZIO', 'INIZIO-Insert tabella backup');

    v_sql := 'insert /*+ APPEND PARALLEL(trg, 2) */ into ' || v_ttrg || ' trg (TODAY_FLG, COD_ABI_ISTITUTO, COD_ABI_CARTOLARIZZATO, COD_NDG, COD_SNDG, COD_COMPARTO_CALCOLATO_PRE, COD_COMPARTO_CALCOLATO, COD_COMPARTO_ASSEGNATO, FLG_GRUPPO_ECONOMICO, FLG_GRUPPO_LEGAME, FLG_SINGOLO, FLG_CONDIVISO, '||
    'COD_GRUPPO_LEGAME, COD_GRUPPO_ECONOMICO, COD_GRUPPO_SUPER, DTA_COMPARTO_CALCOLATO, ID_UTENTE, ID_UTENTE_PRE, COD_OPERATORE_INS_UPD, DTA_INS, DTA_UPD, ID_DPERFG, DTA_UTENTE_ASSEGNATO, FLG_SOMMA, FLG_RIPORTAFOGLIATO, DTA_LAST_RIPORTAF, COD_MATR_ASSEGNATORE, COD_COMPARTO_PREASSEGNATO, ID_UTENTE_PREASSEGNATO, '||
    'COD_PROCESSO_PREASSEGNATO, COD_SEZIONE_PREASSEGNATA, COD_RAMO_CALCOLATO, COD_SERVIZIO, DTA_SERVIZIO, FLG_SOURCE, FLG_ACTIVE, DTA_INTERCETTAMENTO, COD_FILIALE, COD_STRUTTURA_COMPETENTE, COD_TIPO_INGRESSO, COD_CAUSALE_INGRESSO, COD_PERCORSO, COD_PROCESSO, COD_STATO, DTA_DECORRENZA_STATO, DTA_SCADENZA_STATO, '||
    'COD_STATO_PRECEDENTE, DTA_DECORRENZA_STATO_PRE, DTA_PROCESSO, COD_PROCESSO_PRE, COD_MACROSTATO, DTA_DEC_MACROSTATO, COD_COMPARTO_HOST, COD_RAMO_HOST, ID_STATO_POSIZIONE, COD_CLIENTE_ESTESO, ID_CLIENTE_ESTESO, DESC_ANAG_GESTORE_MKT, COD_GESTORE_MKT, COD_TIPO_PORTAFOGLIO, FLG_GESTIONE_ESTERNA, VAL_PERC_DECURTAZIONE, '||
    'ID_DPERMO, ID_TRANSIZIONE, FLG_OUTSOURCING, COD_MATR_RISCHIO, COD_UO_RISCHIO, COD_DISP_RISCHIO, DESC_ISTITUTO, DESC_BREVE, FLG_TARGET, FLG_CARTOLARIZZATO, DTA_ABI_ELAB, DESC_NOME_CONTROPARTE, DESC_GRUPPO_ECONOMICO, DTA_RIF_PD_ONLINE, VAL_RATING_ONLINE, VAL_PD_ONLINE, SCSB_UTI_TOT, SCSB_ACC_TOT, SCSB_UTI_CASSA, SCSB_UTI_FIRMA, '||
    'SCSB_ACC_CASSA, SCSB_ACC_FIRMA, GB_VAL_MAU, GEGB_ACC_CASSA, GEGB_ACC_FIRMA, GEGB_UTI_CASSA, GEGB_UTI_FIRMA, GLGB_ACC_CASSA, GLGB_ACC_FIRMA, GLGB_UTI_CASSA, GLGB_UTI_FIRMA, COD_FILIALE_GB, COD_PROCESSO_CALCOLATO_GB, COD_MACROSTATO_PROPOSTO_GB, DTA_INS_GB, FLG_STATO_GB, SCSB_ACC_SOSTITUZIONI, SCSB_UTI_SOSTITUZIONI, FLG_BLOCCO, COD_GRUPPO_SUPER_OLD)' ||
     ' select /*+ PARALLEL (src, 2) */  TODAY_FLG, COD_ABI_ISTITUTO, COD_ABI_CARTOLARIZZATO, COD_NDG, COD_SNDG, COD_COMPARTO_CALCOLATO_PRE, COD_COMPARTO_CALCOLATO, COD_COMPARTO_ASSEGNATO, FLG_GRUPPO_ECONOMICO, FLG_GRUPPO_LEGAME, FLG_SINGOLO, FLG_CONDIVISO, COD_GRUPPO_LEGAME, COD_GRUPPO_ECONOMICO, COD_GRUPPO_SUPER, DTA_COMPARTO_CALCOLATO, ID_UTENTE, '||
     'ID_UTENTE_PRE, COD_OPERATORE_INS_UPD, DTA_INS, DTA_UPD, ID_DPERFG, DTA_UTENTE_ASSEGNATO, FLG_SOMMA, FLG_RIPORTAFOGLIATO, DTA_LAST_RIPORTAF, COD_MATR_ASSEGNATORE, COD_COMPARTO_PREASSEGNATO, ID_UTENTE_PREASSEGNATO, COD_PROCESSO_PREASSEGNATO, COD_SEZIONE_PREASSEGNATA, COD_RAMO_CALCOLATO, COD_SERVIZIO, DTA_SERVIZIO, FLG_SOURCE, FLG_ACTIVE, '||
     'DTA_INTERCETTAMENTO, COD_FILIALE, COD_STRUTTURA_COMPETENTE, COD_TIPO_INGRESSO, COD_CAUSALE_INGRESSO, COD_PERCORSO, COD_PROCESSO, COD_STATO, DTA_DECORRENZA_STATO, DTA_SCADENZA_STATO, COD_STATO_PRECEDENTE, DTA_DECORRENZA_STATO_PRE, DTA_PROCESSO, COD_PROCESSO_PRE, COD_MACROSTATO, DTA_DEC_MACROSTATO, COD_COMPARTO_HOST, COD_RAMO_HOST, '||
     'ID_STATO_POSIZIONE, COD_CLIENTE_ESTESO, ID_CLIENTE_ESTESO, DESC_ANAG_GESTORE_MKT, COD_GESTORE_MKT, COD_TIPO_PORTAFOGLIO, FLG_GESTIONE_ESTERNA, VAL_PERC_DECURTAZIONE, ID_DPERMO, ID_TRANSIZIONE, FLG_OUTSOURCING, COD_MATR_RISCHIO, COD_UO_RISCHIO, COD_DISP_RISCHIO, DESC_ISTITUTO, DESC_BREVE, FLG_TARGET, FLG_CARTOLARIZZATO, DTA_ABI_ELAB, DESC_NOME_CONTROPARTE, '||
     'DESC_GRUPPO_ECONOMICO, DTA_RIF_PD_ONLINE, VAL_RATING_ONLINE, VAL_PD_ONLINE, SCSB_UTI_TOT, SCSB_ACC_TOT, SCSB_UTI_CASSA, SCSB_UTI_FIRMA, SCSB_ACC_CASSA, SCSB_ACC_FIRMA, GB_VAL_MAU, GEGB_ACC_CASSA, GEGB_ACC_FIRMA, GEGB_UTI_CASSA, GEGB_UTI_FIRMA, GLGB_ACC_CASSA, GLGB_ACC_FIRMA, GLGB_UTI_CASSA, GLGB_UTI_FIRMA, COD_FILIALE_GB, COD_PROCESSO_CALCOLATO_GB, '||
     'COD_MACROSTATO_PROPOSTO_GB, DTA_INS_GB, FLG_STATO_GB, SCSB_ACC_SOSTITUZIONI, SCSB_UTI_SOSTITUZIONI, FLG_BLOCCO, COD_GRUPPO_SUPER_OLD from ' || v_tsrc || ' src ';
     --DBMS_OUTPUT.PUT_LINE(v_sql);
    EXECUTE IMMEDIATE v_sql;
    COMMIT;
     PKG_MCRE0_AUDIT.log_etl (seq, '0 - PKG_MCRE0_TWS - END - TWS_MCRE0_COPY_ALL_DATA', PKG_MCRE0_AUDIT.C_DEBUG, sqlcode, 'FINE', 'FINE-Insert tabella backup');
     EXCEPTION
    WHEN OTHERS
    THEN
      PKG_MCRE0_AUDIT.log_etl (seq, 'Copy all Data', PKG_MCRE0_AUDIT.C_ERROR, sqlcode, 'eccezione altri', 'log');
     END TWS_MCRE0_COPY_ALL_DATA;

    FUNCTION TWS_MCRE0_FILL_ALL_DATA_DAY return number is

        v_sql VARCHAR2(32000);

        BEGIN

            select SEQ_MCR0_LOG_ETL.nextval into seq from dual;
            PKG_MCRE0_AUDIT.log_etl (seq, '0 - PKG_MCRE0_TWS - INI - TWS_MCRE0_FILL_ALL_DATA_DAY', PKG_MCRE0_AUDIT.C_DEBUG, sqlcode, 'INIZIO', 'INIZIO');
            execute immediate 'TRUNCATE TABLE T_MCRE0_APP_ALL_DATA_DAY REUSE STORAGE';
            execute immediate 'ALTER SESSION ENABLE PARALLEL DML';

           -- v_sql := 'insert /*+ APPEND PARALLEL(trg, 2) */ into T_MCRE0_APP_ALL_DATA_DAY trg select /*+ PARALLEL (src, 2) */  src.* from T_MCRE0_APP_ALL_DATA src';
    v_sql := 'insert /*+ APPEND PARALLEL(trg, 2) */ into T_MCRE0_APP_ALL_DATA_DAY trg (TODAY_FLG, COD_ABI_ISTITUTO, COD_ABI_CARTOLARIZZATO, COD_NDG, COD_SNDG, COD_COMPARTO_CALCOLATO_PRE, COD_COMPARTO_CALCOLATO, COD_COMPARTO_ASSEGNATO, FLG_GRUPPO_ECONOMICO, FLG_GRUPPO_LEGAME, FLG_SINGOLO, FLG_CONDIVISO, '||
    'COD_GRUPPO_LEGAME, COD_GRUPPO_ECONOMICO, COD_GRUPPO_SUPER, DTA_COMPARTO_CALCOLATO, ID_UTENTE, ID_UTENTE_PRE, COD_OPERATORE_INS_UPD, DTA_INS, DTA_UPD, ID_DPERFG, DTA_UTENTE_ASSEGNATO, FLG_SOMMA, FLG_RIPORTAFOGLIATO, DTA_LAST_RIPORTAF, COD_MATR_ASSEGNATORE, COD_COMPARTO_PREASSEGNATO, ID_UTENTE_PREASSEGNATO, '||
    'COD_PROCESSO_PREASSEGNATO, COD_SEZIONE_PREASSEGNATA, COD_RAMO_CALCOLATO, COD_SERVIZIO, DTA_SERVIZIO, FLG_SOURCE, FLG_ACTIVE, DTA_INTERCETTAMENTO, COD_FILIALE, COD_STRUTTURA_COMPETENTE, COD_TIPO_INGRESSO, COD_CAUSALE_INGRESSO, COD_PERCORSO, COD_PROCESSO, COD_STATO, DTA_DECORRENZA_STATO, DTA_SCADENZA_STATO, '||
    'COD_STATO_PRECEDENTE, DTA_DECORRENZA_STATO_PRE, DTA_PROCESSO, COD_PROCESSO_PRE, COD_MACROSTATO, DTA_DEC_MACROSTATO, COD_COMPARTO_HOST, COD_RAMO_HOST, ID_STATO_POSIZIONE, COD_CLIENTE_ESTESO, ID_CLIENTE_ESTESO, DESC_ANAG_GESTORE_MKT, COD_GESTORE_MKT, COD_TIPO_PORTAFOGLIO, FLG_GESTIONE_ESTERNA, VAL_PERC_DECURTAZIONE, '||
    'ID_DPERMO, ID_TRANSIZIONE, FLG_OUTSOURCING, COD_MATR_RISCHIO, COD_UO_RISCHIO, COD_DISP_RISCHIO, DESC_ISTITUTO, DESC_BREVE, FLG_TARGET, FLG_CARTOLARIZZATO, DTA_ABI_ELAB, DESC_NOME_CONTROPARTE, DESC_GRUPPO_ECONOMICO, DTA_RIF_PD_ONLINE, VAL_RATING_ONLINE, VAL_PD_ONLINE, SCSB_UTI_TOT, SCSB_ACC_TOT, SCSB_UTI_CASSA, SCSB_UTI_FIRMA, '||
    'SCSB_ACC_CASSA, SCSB_ACC_FIRMA, GB_VAL_MAU, GEGB_ACC_CASSA, GEGB_ACC_FIRMA, GEGB_UTI_CASSA, GEGB_UTI_FIRMA, GLGB_ACC_CASSA, GLGB_ACC_FIRMA, GLGB_UTI_CASSA, GLGB_UTI_FIRMA, COD_FILIALE_GB, COD_PROCESSO_CALCOLATO_GB, COD_MACROSTATO_PROPOSTO_GB, DTA_INS_GB, FLG_STATO_GB, SCSB_ACC_SOSTITUZIONI, SCSB_UTI_SOSTITUZIONI, FLG_BLOCCO, COD_GRUPPO_SUPER_OLD)' ||
     ' select /*+ PARALLEL (src, 2) */  TODAY_FLG, COD_ABI_ISTITUTO, COD_ABI_CARTOLARIZZATO, COD_NDG, COD_SNDG, COD_COMPARTO_CALCOLATO_PRE, COD_COMPARTO_CALCOLATO, COD_COMPARTO_ASSEGNATO, FLG_GRUPPO_ECONOMICO, FLG_GRUPPO_LEGAME, FLG_SINGOLO, FLG_CONDIVISO, COD_GRUPPO_LEGAME, COD_GRUPPO_ECONOMICO, COD_GRUPPO_SUPER, DTA_COMPARTO_CALCOLATO, ID_UTENTE, '||
     'ID_UTENTE_PRE, COD_OPERATORE_INS_UPD, DTA_INS, DTA_UPD, ID_DPERFG, DTA_UTENTE_ASSEGNATO, FLG_SOMMA, FLG_RIPORTAFOGLIATO, DTA_LAST_RIPORTAF, COD_MATR_ASSEGNATORE, COD_COMPARTO_PREASSEGNATO, ID_UTENTE_PREASSEGNATO, COD_PROCESSO_PREASSEGNATO, COD_SEZIONE_PREASSEGNATA, COD_RAMO_CALCOLATO, COD_SERVIZIO, DTA_SERVIZIO, FLG_SOURCE, FLG_ACTIVE, '||
     'DTA_INTERCETTAMENTO, COD_FILIALE, COD_STRUTTURA_COMPETENTE, COD_TIPO_INGRESSO, COD_CAUSALE_INGRESSO, COD_PERCORSO, COD_PROCESSO, COD_STATO, DTA_DECORRENZA_STATO, DTA_SCADENZA_STATO, COD_STATO_PRECEDENTE, DTA_DECORRENZA_STATO_PRE, DTA_PROCESSO, COD_PROCESSO_PRE, COD_MACROSTATO, DTA_DEC_MACROSTATO, COD_COMPARTO_HOST, COD_RAMO_HOST, '||
     'ID_STATO_POSIZIONE, COD_CLIENTE_ESTESO, ID_CLIENTE_ESTESO, DESC_ANAG_GESTORE_MKT, COD_GESTORE_MKT, COD_TIPO_PORTAFOGLIO, FLG_GESTIONE_ESTERNA, VAL_PERC_DECURTAZIONE, ID_DPERMO, ID_TRANSIZIONE, FLG_OUTSOURCING, COD_MATR_RISCHIO, COD_UO_RISCHIO, COD_DISP_RISCHIO, DESC_ISTITUTO, DESC_BREVE, FLG_TARGET, FLG_CARTOLARIZZATO, DTA_ABI_ELAB, DESC_NOME_CONTROPARTE, '||
     'DESC_GRUPPO_ECONOMICO, DTA_RIF_PD_ONLINE, VAL_RATING_ONLINE, VAL_PD_ONLINE, SCSB_UTI_TOT, SCSB_ACC_TOT, SCSB_UTI_CASSA, SCSB_UTI_FIRMA, SCSB_ACC_CASSA, SCSB_ACC_FIRMA, GB_VAL_MAU, GEGB_ACC_CASSA, GEGB_ACC_FIRMA, GEGB_UTI_CASSA, GEGB_UTI_FIRMA, GLGB_ACC_CASSA, GLGB_ACC_FIRMA, GLGB_UTI_CASSA, GLGB_UTI_FIRMA, COD_FILIALE_GB, COD_PROCESSO_CALCOLATO_GB, '||
     'COD_MACROSTATO_PROPOSTO_GB, DTA_INS_GB, FLG_STATO_GB, SCSB_ACC_SOSTITUZIONI, SCSB_UTI_SOSTITUZIONI, FLG_BLOCCO, COD_GRUPPO_SUPER_OLD from T_MCRE0_APP_ALL_DATA src ';
            EXECUTE IMMEDIATE v_sql;
            COMMIT;
             PKG_MCRE0_AUDIT.log_etl (seq, '0 - PKG_MCRE0_TWS - END - TWS_MCRE0_FILL_ALL_DATA_DAY', PKG_MCRE0_AUDIT.C_DEBUG, sqlcode, 'FINE', 'FINE-Insert tabella backup');
            return ok;
        EXCEPTION WHEN OTHERS THEN
            PKG_MCRE0_AUDIT.log_etl (seq, '0 - TWS_MCRE0_FILL_ALL_DATA_DAY', PKG_MCRE0_AUDIT.C_ERROR, sqlcode, sqlerrm, 'Errore in TWS_MCRE0_FILL_ALL_DATA_DAY');
            return ko;
        END TWS_MCRE0_FILL_ALL_DATA_DAY;

    FUNCTION TWS_MCRE0_CHIUDI_PORTALE return number is
        BEGIN
            select SEQ_MCR0_LOG_ETL.nextval into seq from dual;
            PKG_MCRE0_AUDIT.log_etl (seq, '0 - PKG_MCRE0_TWS - INI - TWS_MCRE0_CHIUDI_PORTALE', PKG_MCRE0_AUDIT.C_DEBUG, sqlcode, 'INIZIO', 'INIZIO');
            PKG_MCRE0_AUDIT.log_etl (seq, '0 - PKG_MCRE0_TWS - INI - TWS_MCRE0_CHIUDI_PORTALE', PKG_MCRE0_AUDIT.C_DEBUG, sqlcode, 'INIZIO', 'INIZIO - Portale chiuso');
            update T_MCRE0_WRK_CONFIGURAZIONE set VALORE_COSTANTE = 0 where NOME_COSTANTE = 'STATO_PORTALE';
            commit;
            PKG_MCRE0_AUDIT.log_etl (seq, '0 - PKG_MCRE0_TWS - END - TWS_MCRE0_CHIUDI_PORTALE', PKG_MCRE0_AUDIT.C_DEBUG, sqlcode, 'FINE', 'FINE - Portale chiuso');
            PKG_MCRE0_TWS.TWS_MCRE0_COPY_ALL_DATA;
            PKG_MCRE0_AUDIT.log_etl (seq, '0 - PKG_MCRE0_TWS - END - TWS_MCRE0_CHIUDI_PORTALE', PKG_MCRE0_AUDIT.C_DEBUG, sqlcode, 'FINE', 'FINE');
            return ok;
        EXCEPTION WHEN OTHERS THEN
            PKG_MCRE0_AUDIT.log_etl (seq, '0 - TWS_MCRE0_CHIUDI_PORTALE', PKG_MCRE0_AUDIT.C_ERROR, sqlcode, sqlerrm, 'Errore in TWS_MCRE0_CHIUDI_PORTALE');
            return ko;
        END TWS_MCRE0_CHIUDI_PORTALE;

    FUNCTION TWS_MCRE0_APRI_PORTALE return number is
        BEGIN
            select SEQ_MCR0_LOG_ETL.nextval into seq from dual;
            PKG_MCRE0_AUDIT.log_etl (seq, '9_1 - PKG_MCRE0_TWS - INI - TWS_MCRE0_APRI_PORTALE', PKG_MCRE0_AUDIT.C_DEBUG, sqlcode, 'INIZIO', 'INIZIO');
            PKG_MCRE0_AUDIT.log_etl (seq, '9_1 - PKG_MCRE0_TWS - INI - TWS_MCRE0_APRI_PORTALE', PKG_MCRE0_AUDIT.C_DEBUG, sqlcode, 'INIZIO', 'INIZIO - Portale aperto');
            update T_MCRE0_WRK_CONFIGURAZIONE set VALORE_COSTANTE = 1 where NOME_COSTANTE = 'STATO_PORTALE';
            commit;
            PKG_MCRE0_AUDIT.log_etl (seq, '9_1 - PKG_MCRE0_TWS - END - TWS_MCRE0_APRI_PORTALE', PKG_MCRE0_AUDIT.C_DEBUG, sqlcode, 'FINE', 'FINE - Portale aperto');
            PKG_MCRE0_AUDIT.log_etl (seq, '9_1 - PKG_MCRE0_TWS - END - TWS_MCRE0_APRI_PORTALE', PKG_MCRE0_AUDIT.C_DEBUG, sqlcode, 'FINE', 'FINE');
            return ok;
        EXCEPTION WHEN OTHERS THEN
            PKG_MCRE0_AUDIT.log_etl (seq, '9_1 - TWS_MCRE0_APRI_PORTALE', PKG_MCRE0_AUDIT.C_ERROR, sqlcode, sqlerrm, 'Errore in TWS_MCRE0_APRI_PORTALE');
            return ko;
        END TWS_MCRE0_APRI_PORTALE;

    FUNCTION TWS_MCRE0_CHECK_ABI_ELAB return number IS
        BEGIN
            select SEQ_MCR0_LOG_ETL.nextval into seq from dual;
            PKG_MCRE0_AUDIT.log_etl (seq, '0_1 - PKG_MCRE0_TWS - INI - CHECK_ABI_ELAB', PKG_MCRE0_AUDIT.C_DEBUG, sqlcode, 'INIZIO', 'INIZIO');
            esito:=0;
            PKG_MCRE0_AUDIT.log_etl (seq, '0_1 - PKG_MCRE0_TWS - INI - CHECK_ABI_ELAB', PKG_MCRE0_AUDIT.C_DEBUG, sqlcode, 'INIZIO', 'INIZIO - check_abi_elab');
            RetVal := PKG_MCRE0_GESTIONE_ABI_ELAB.CHECK_ABI_ELAB;
            PKG_MCRE0_AUDIT.log_etl (seq, '0_1 - PKG_MCRE0_TWS - END - CHECK_ABI_ELAB', PKG_MCRE0_AUDIT.C_DEBUG, sqlcode, 'Esito '||RetVal, 'FINE - check_abi_elab');
            if (RetVal = 0) then
                raise eccezione_interna;
            end if;
            PKG_MCRE0_AUDIT.log_etl (seq, '0_1 - PKG_MCRE0_TWS - INI - CHECK_ABI_ELAB', PKG_MCRE0_AUDIT.C_DEBUG, sqlcode, 'INIZIO', 'INIZIO - ETL_GESTIONE_TAPPI');
            RetVal := MCRE_OWN.PKG_MCRE0_GESTIONE_ALL_DATA.ETL_GESTIONE_TAPPI(seq);
            PKG_MCRE0_AUDIT.log_etl (seq, '0_1 - PKG_MCRE0_TWS - END - CHECK_ABI_ELAB', PKG_MCRE0_AUDIT.C_DEBUG, sqlcode, 'Esito '||RetVal, 'FINE - ETL_GESTIONE_TAPPI');
            if (RetVal = 0) then
                raise eccezione_interna;
            end if;
            /*
                 prerequisiti per esecuzione parallela di MOPLE,FILE_GUIDA e PCR
            */
            --svecchio GE
            PKG_MCRE0_AUDIT.log_etl (seq, '0_1 - PKG_MCRE0_TWS - INI - Svecchiamento GE ', PKG_MCRE0_AUDIT.C_DEBUG, sqlcode, 'INIZIO', 'INIZIO - Svecchiamento GE ');
            RetVal := MCRE_OWN.PKG_MCRE0_CARICA_GRUPPO_LEGAME.SVECCHIA_GE;
            PKG_MCRE0_AUDIT.log_etl (seq, '0_1 - PKG_MCRE0_TWS - END - Svecchiamento GE ', PKG_MCRE0_AUDIT.C_DEBUG, sqlcode, 'Esito '||RetVal, 'FINE - Svecchiamento GE ');
            if (RetVal = 0) then
                raise eccezione_interna;
            end if;
            --svecchio GL
            PKG_MCRE0_AUDIT.log_etl (seq, '0_1 - PKG_MCRE0_TWS - INI - Svecchiamento GL ', PKG_MCRE0_AUDIT.C_DEBUG, sqlcode, 'INIZIO', 'INIZIO - Svecchiamento GL ');
            RetVal := MCRE_OWN.PKG_MCRE0_CARICA_GRUPPO_LEGAME.SVECCHIA_LEGAMI;
            PKG_MCRE0_AUDIT.log_etl (seq, '0_1 - PKG_MCRE0_TWS - END - Svecchiamento GL ', PKG_MCRE0_AUDIT.C_DEBUG, sqlcode, 'Esito '||RetVal, 'FINE - Svecchiamento GL ');
            if (RetVal = 0) then
                raise eccezione_interna;
            end if;
            --gruppo legame
            PKG_MCRE0_AUDIT.log_etl (seq, '0_1 - PKG_MCRE0_TWS - INI - Calcolo GL ', PKG_MCRE0_AUDIT.C_DEBUG, sqlcode, 'INIZIO', 'INIZIO - Calcolo GL ');
            RetVal := MCRE_OWN.PKG_MCRE0_CARICA_GRUPPO_LEGAME.LOAD_FULL_GRUPPO_LEGAME;
            PKG_MCRE0_AUDIT.log_etl (seq, '0_1 - PKG_MCRE0_TWS - END - Calcolo GL ', PKG_MCRE0_AUDIT.C_DEBUG, sqlcode, 'Esito '||RetVal, 'FINE - Calcolo GL ');
            if (RetVal = 0) then
                raise eccezione_interna;
            end if;
            -- setta partizione e attiva e comparto
            PKG_MCRE0_AUDIT.log_etl (seq, '0_1 - PKG_MCRE0_TWS - INI - Set TODAY FLG ', PKG_MCRE0_AUDIT.C_DEBUG, sqlcode, 'INIZIO', 'INIZIO - TODAY FLG');
            RetVal := MCRE_OWN.PKG_MCRE0_ESTENDI_MOPLE2.FNC_SET_TODAY_FLG;
            PKG_MCRE0_AUDIT.log_etl (seq, '0_1 - PKG_MCRE0_TWS - END - Set TODAY FLG ', PKG_MCRE0_AUDIT.C_DEBUG, sqlcode, 'Esito '||RetVal, 'FINE - TODAY FLG');
            if (RetVal = 0) then
                raise eccezione_interna;
            end if;
            --
             -- Aggiornamento File Guida Pre
            PKG_MCRE0_AUDIT.log_etl (seq, '0_1 - PKG_MCRE0_TWS - INI - Aggiornamento File Guida', PKG_MCRE0_AUDIT.C_DEBUG, sqlcode, 'INIZIO', 'INIZIO - Aggiornamento File Guida');
            RetVal := MCRE_OWN.PKG_MCRE0_ESTENDI_FILE_GUIDA2.UPDATE_FILE_GUIDA_PRE;
            PKG_MCRE0_AUDIT.log_etl (seq, '0_1 - PKG_MCRE0_TWS - END - Aggiornamento File Guida', PKG_MCRE0_AUDIT.C_DEBUG, sqlcode, 'Esito '||RetVal, 'FINE - Aggiornamento File Guida');
            if (RetVal = 0) then
                raise eccezione_interna;
            end if;

            PKG_MCRE0_AUDIT.log_etl (seq, '0_1 - PKG_MCRE0_TWS - END - CHECK_ABI_ELAB', PKG_MCRE0_AUDIT.C_DEBUG, sqlcode, 'FINE', 'FINE');
            return ok;
    exception
        when eccezione_interna then
            PKG_MCRE0_AUDIT.log_etl ('0_1 - PKG_MCRE0_TWS ERROR CHECK_ABI_ELAB', PKG_MCRE0_AUDIT.C_ERROR, sqlcode, sqlerrm, 'Errore interno');
            return ko;
        when others then
            PKG_MCRE0_AUDIT.log_etl ('0_1 - PKG_MCRE0_TWS ERROR CHECK_ABI_ELAB', PKG_MCRE0_AUDIT.C_ERROR, sqlcode, sqlerrm, 'Errore generico');
                    return ko;
    end TWS_MCRE0_CHECK_ABI_ELAB;

    FUNCTION TWS_MCRE0_LIVELLO1_G1 return number IS

        BEGIN
            select SEQ_MCR0_LOG_ETL.nextval into seq from dual;
            PKG_MCRE0_AUDIT.log_etl (seq, '1_1 - PKG_MCRE0_TWS - INI - LIVELLO1_G1 ', PKG_MCRE0_AUDIT.C_DEBUG, sqlcode, 'INIZIO', 'INIZIO');
              -- Storico
            PKG_MCRE0_AUDIT.log_etl (seq, '1_1 - PKG_MCRE0_TWS - INI - Storicizza in seguito ai caricamenti', PKG_MCRE0_AUDIT.C_DEBUG, sqlcode, 'INIZIO', 'INIZIO - Storicizza in seguito ai caricamenti');
            RetVal := MCRE_OWN.PKG_MCRE0_STORICIZZA.STORICIZZA_CARICAMENTI(seq);
            PKG_MCRE0_AUDIT.log_etl (seq, '1_1 - PKG_MCRE0_TWS - END - Storicizza in seguito ai caricamenti', PKG_MCRE0_AUDIT.C_DEBUG, sqlcode, 'Esito '||RetVal, 'FINE - Storicizza in seguito ai caricamenti');
            if (RetVal = 0) then
                raise eccezione_interna;
            end if;
            PKG_MCRE0_AUDIT.log_etl (seq, '1_1 - PKG_MCRE0_TWS - END - LIVELLO1_G2', PKG_MCRE0_AUDIT.C_DEBUG, sqlcode, 'FINE', 'FINE');
            PKG_MCRE0_AUDIT.log_etl (seq, '1_1 - PKG_MCRE0_TWS - END - LIVELLO1_G1 ', PKG_MCRE0_AUDIT.C_DEBUG, sqlcode, 'FINE', 'FINE');
            return ok;
        EXCEPTION
          WHEN eccezione_interna THEN
         PKG_MCRE0_AUDIT.log_etl (seq, '1_1 - PKG_MCRE0_TWS ERROR - LIVELLO_1 GRUPPO_1', PKG_MCRE0_AUDIT.C_ERROR, sqlcode, sqlerrm, 'Errore in ERROR - LIVELLO_1 GRUPPO_1');
            return ko;
        WHEN OTHERS THEN
            PKG_MCRE0_AUDIT.log_etl (seq, '1_1 - PKG_MCRE0_TWS ERROR - LIVELLO_1 GRUPPO_1', PKG_MCRE0_AUDIT.C_ERROR, sqlcode, sqlerrm, 'Errore in ERROR - LIVELLO_1 GRUPPO_1');
            return ko;
        END TWS_MCRE0_LIVELLO1_G1;


    FUNCTION TWS_MCRE0_LIVELLO1_G2 return number IS

        BEGIN
            esito:=0;
            select SEQ_MCR0_LOG_ETL.nextval into seq from dual;
            PKG_MCRE0_AUDIT.log_etl (seq, '1_2 - PKG_MCRE0_TWS - INI - LIVELLO1_G2', PKG_MCRE0_AUDIT.C_DEBUG, sqlcode, 'INIZIO', 'INIZIO');
--            PKG_MCRE0_AUDIT.log_etl (seq, '1_2 - PKG_MCRE0_TWS - INI - UPD_GB_STATUS ', PKG_MCRE0_AUDIT.C_DEBUG, sqlcode, 'INIZIO', 'INIZIO - eseguito Aggiornamento GB');
--            RetVal := MCRE_OWN.PKG_MCRE0_ESTENDI_MOPLE2.UPD_GB_STATUS;
--            PKG_MCRE0_AUDIT.log_etl (seq, '1_2 - PKG_MCRE0_TWS - END - UPD_GB_STATUS ', PKG_MCRE0_AUDIT.C_DEBUG, sqlcode, 'Esito '||RetVal, 'FINE - eseguito Aggiornamento GB');
--            esito := esito+RetVal;
--            esito:=0;
            --macrostato
            PKG_MCRE0_AUDIT.log_etl (seq, '1_2 - PKG_MCRE0_TWS - INI - Calcolo macrostato ', PKG_MCRE0_AUDIT.C_DEBUG, sqlcode, 'INIZIO', 'INIZIO - Calcolo macrostato ');
            RetVal := MCRE_OWN.PKG_MCRE0_ESTENDI_MOPLE2.FNC_GESTIONE_MACROSTATO;
            PKG_MCRE0_AUDIT.log_etl (seq, '1_2 - PKG_MCRE0_TWS - END - Calcolo macrostato ', PKG_MCRE0_AUDIT.C_DEBUG, sqlcode, 'Esito '||RetVal, 'FINE - Calcolo macrostato ');
            if (RetVal = 0) then
                raise eccezione_interna;
            end if;
            --processo_pre e dta_decorrenza_stato_pre
            PKG_MCRE0_AUDIT.log_etl (seq, '1_2 - PKG_MCRE0_TWS - INI - Calcolo data decorrenza stato precedente ', PKG_MCRE0_AUDIT.C_DEBUG, sqlcode, 'INIZIO', 'INIZIO - Calcolo data decorrenza stato precedente ');
            RetVal := MCRE_OWN.PKG_MCRE0_ESTENDI_MOPLE2.FNC_GESTIONE_PRE;
            PKG_MCRE0_AUDIT.log_etl (seq, '1_2 - PKG_MCRE0_TWS - END - Calcolo data decorrenza stato precedente ', PKG_MCRE0_AUDIT.C_DEBUG, sqlcode, 'Esito '||RetVal, 'FINE - Calcolo data decorrenza stato precedente ');
            if (RetVal = 0) then
                raise eccezione_interna;
            end if;
--            -- Storico
--            PKG_MCRE0_AUDIT.log_etl (seq, '1_2 - PKG_MCRE0_TWS - INI - Storicizza in seguito ai caricamenti', PKG_MCRE0_AUDIT.C_DEBUG, sqlcode, 'INIZIO', 'INIZIO - Storicizza in seguito ai caricamenti');
--            RetVal := MCRE_OWN.PKG_MCRE0_STORICIZZA.STORICIZZA_CARICAMENTI(seq);
--            PKG_MCRE0_AUDIT.log_etl (seq, '1_2 - PKG_MCRE0_TWS - END - Storicizza in seguito ai caricamenti', PKG_MCRE0_AUDIT.C_DEBUG, sqlcode, 'Esito '||RetVal, 'FINE - Storicizza in seguito ai caricamenti');
--            if (RetVal = 0) then
--                raise eccezione_interna;
--            end if;
--            PKG_MCRE0_AUDIT.log_etl (seq, '1_2 - PKG_MCRE0_TWS - END - LIVELLO1_G2', PKG_MCRE0_AUDIT.C_DEBUG, sqlcode, 'FINE', 'FINE');
            return ok;
        exception
            when eccezione_interna then
                PKG_MCRE0_AUDIT.log_etl (seq, '1_2 - PKG_MCRE0_TWS ERROR - LIVELLO_1 GRUPPO_2', PKG_MCRE0_AUDIT.C_ERROR, sqlcode, sqlerrm, 'Errore interno');
                return ko;
            when others then
                PKG_MCRE0_AUDIT.log_etl (seq, '1_2 - PKG_MCRE0_TWS ERROR - LIVELLO_1 GRUPPO_2', PKG_MCRE0_AUDIT.C_ERROR, sqlcode, sqlerrm, 'Errore generico');
                        return ko;
        end TWS_MCRE0_LIVELLO1_G2;

    FUNCTION TWS_MCRE0_LIVELLO1_G3 return number IS

        BEGIN
            select SEQ_MCR0_LOG_ETL.nextval into seq from dual;
            esito := 0;
            PKG_MCRE0_AUDIT.log_etl (seq, '1_3 - PKG_MCRE0_TWS - INI - LIVELLO1_G3', PKG_MCRE0_AUDIT.C_DEBUG, sqlcode, 'INIZIO', 'INIZIO');

--           -- Aggiornamento File Guida
            PKG_MCRE0_AUDIT.log_etl (seq, '1_3 - PKG_MCRE0_TWS - INI - Aggiornamento File Guida', PKG_MCRE0_AUDIT.C_DEBUG, sqlcode, 'INIZIO', 'INIZIO - Aggiornamento File Guida');
            RetVal := MCRE_OWN.PKG_MCRE0_ESTENDI_FILE_GUIDA2.UPDATE_FILE_GUIDA;
            PKG_MCRE0_AUDIT.log_etl (seq, '1_3 - PKG_MCRE0_TWS - END - Aggiornamento File Guida', PKG_MCRE0_AUDIT.C_DEBUG, sqlcode, 'Esito '||RetVal, 'FINE - Aggiornamento File Guida');
            if (RetVal = 0) then
                raise eccezione_interna;
            end if;
            -- assegnazione comparti per GB
            PKG_MCRE0_AUDIT.log_etl (seq,'1_3 - PKG_MCRE0_TWS - INI - assegna_comparto_GB_AV', PKG_MCRE0_AUDIT.C_DEBUG, sqlcode, 'INIZIO', 'INIZIO - eseguito assegna_comparto_GB_AV');
            RetVal := MCRE_OWN.PKG_MCRE0_ESTENDI_FILE_GUIDA2.assegna_comparto_GB_AV(seq);
            PKG_MCRE0_AUDIT.log_etl (seq,'1_3 - PKG_MCRE0_TWS - END - assegna_comparto_GB_AV', PKG_MCRE0_AUDIT.C_DEBUG, sqlcode, 'Esito '||RetVal, 'FINE - eseguito assegna_comparto_GB_AV');
            if (RetVal = 0) then
                raise eccezione_interna;
            end if;
            -- gestione Gestori/Comparti su gruppi usciti da mople
            PKG_MCRE0_AUDIT.log_etl (seq, '1_3 - PKG_MCRE0_TWS - INI - update_uscita_CCP', PKG_MCRE0_AUDIT.C_DEBUG, sqlcode, 'INIZIO', 'INIZIO - update_uscita_CCP');
            RetVal := MCRE_OWN.PKG_MCRE0_ESTENDI_FILE_GUIDA2.update_uscita_CCP; --v 1.9
            PKG_MCRE0_AUDIT.log_etl (seq, '1_3 - PKG_MCRE0_TWS - END - update_uscita_CCP', PKG_MCRE0_AUDIT.C_DEBUG, sqlcode, 'Esito '||RetVal, 'FINE - update_uscita_CCP');
--            if (RetVal = -1) then
--                raise eccezione_interna;
--            end if;
            -- assegnazione automatica su incagli
            PKG_MCRE0_AUDIT.log_etl ('1_3 - PKG_MCRE0_TWS - INI - ASSEGNAZIONE AUTOMATICA SU INCAGLI', PKG_MCRE0_AUDIT.C_DEBUG, sqlcode, 'INIZIO', 'INZIO - eseguita assegnazione automatica');
            RetVal := MCRE_OWN.PKG_MCRE0_ASS_AUTOM.FND_MCRE0_ASSEGNA(seq);  --v.2.3
            PKG_MCRE0_AUDIT.log_etl ('1_3 - PKG_MCRE0_TWS - END - ASSEGNAZIONE AUTOMATICA SU INCAGLI', PKG_MCRE0_AUDIT.C_DEBUG, sqlcode, 'Esito '||RetVal, 'FINE - eseguita assegnazione automatica');
--            if (RetVal = -1) then
--                raise eccezione_interna;
--            end if;
            PKG_MCRE0_AUDIT.log_etl (seq, '1_3 - PKG_MCRE0_TWS - END - LIVELLO1_G3', PKG_MCRE0_AUDIT.C_DEBUG, sqlcode, 'FINE', 'FINE');
            return ok;
        exception
            when eccezione_interna then
                PKG_MCRE0_AUDIT.log_etl (seq, '1_3 - PKG_MCRE0_TWS ERROR - LIVELLO_1 GRUPPO_3', PKG_MCRE0_AUDIT.C_ERROR, sqlcode, sqlerrm, 'Errore interno');
                return ko;
            when others then
                PKG_MCRE0_AUDIT.log_etl (seq, '1_3 - PKG_MCRE0_TWS ERROR - LIVELLO_1 GRUPPO_3', PKG_MCRE0_AUDIT.C_ERROR, sqlcode, sqlerrm, 'Errore generico');
                        return ko;
        end TWS_MCRE0_LIVELLO1_G3;

    FUNCTION TWS_MCRE0_LIVELLO1_G4 return number IS

        BEGIN
            select SEQ_MCR0_LOG_ETL.nextval into seq from dual;
            PKG_MCRE0_AUDIT.log_etl (seq, '1_4 - PKG_MCRE0_TWS - INI - LIVELLO1_G4', PKG_MCRE0_AUDIT.C_DEBUG, sqlcode, 'INIZIO', 'INIZIO');
            esito:=0;
            -- Istituti
            PKG_MCRE0_AUDIT.log_etl (seq, '1_4 - PKG_MCRE0_TWS - INI - Aggiorna Istituti in seguito ai caricamenti ', PKG_MCRE0_AUDIT.C_DEBUG, sqlcode, 'INIZIO', 'INIZIO - Aggiorna Istituti in seguito ai caricamenti ');
            Retval := Mcre_Own.Pkg_Mcre0_Aggiorna_Mv.Aggiorna_Istituti(seq);
            PKG_MCRE0_AUDIT.log_etl (seq, '1_4 - PKG_MCRE0_TWS - END - Aggiorna Istituti in seguito ai caricamenti ', PKG_MCRE0_AUDIT.C_DEBUG, sqlcode, 'Esito '||RetVal, 'FINE - Aggiorna Istituti in seguito ai caricamenti ');
            if (RetVal = 0) then
                raise eccezione_interna;
            end if;
            -- Strutt_ORG
            PKG_MCRE0_AUDIT.log_etl (seq, '1_4 - PKG_MCRE0_TWS - INI - Aggiorna Strutt_ORG in seguito ai caricamenti ', PKG_MCRE0_AUDIT.C_DEBUG, sqlcode, 'INIZIO', 'INIZIO - Aggiorna Strutt_ORG in seguito ai caricamenti ');
            Retval := Mcre_Own.Pkg_Mcre0_Aggiorna_Mv.aggiorna_DENORM_STR_ORG(seq);
            PKG_MCRE0_AUDIT.log_etl (seq, '1_4 - PKG_MCRE0_TWS - END - Aggiorna Strutt_ORG in seguito ai caricamenti ', PKG_MCRE0_AUDIT.C_DEBUG, sqlcode, 'Esito '||RetVal, 'FINE - Aggiorna Strutt_ORG in seguito ai caricamenti ');
            if (RetVal = 0) then
                raise eccezione_interna;
            end if;
            --refresh aggregate (rate impagate)
            PKG_MCRE0_AUDIT.log_etl (seq,'1_4 - ETL2 - FNC_UPD_RATE_IMPAGATE', PKG_MCRE0_AUDIT.C_DEBUG, sqlcode, 'INIZIO', 'INIZIO - FNC_UPD_RATE_IMPAGATE');
            RetVal := MCRE_OWN.PKG_MCREI_REFRESH_AGGREGATE.FNC_UPD_RATE_IMPAGATE ( seq );
            PKG_MCRE0_AUDIT.log_etl (seq,'1_4 - ETL2 - FNC_UPD_RATE_IMPAGATE', PKG_MCRE0_AUDIT.C_DEBUG, sqlcode, 'Esito '||RETVAL, 'FINE - FNC_UPD_RATE_IMPAGATE');
--            if (RetVal = 0) then
--                raise eccezione_interna;
--            end if;
            PKG_MCRE0_AUDIT.log_etl (seq, '1_4 - PKG_MCRE0_TWS - END - LIVELLO1_G4', PKG_MCRE0_AUDIT.C_DEBUG, sqlcode, 'FINE', 'FINE');
            return ok;
        exception
            when eccezione_interna then
                PKG_MCRE0_AUDIT.log_etl ('1_4 - PKG_MCRE0_TWS ERROR - LIVELLO_1 GRUPPO_4', PKG_MCRE0_AUDIT.C_ERROR, sqlcode, sqlerrm, 'Errore interno');
                return ko;
            when others then
                PKG_MCRE0_AUDIT.log_etl ('1_4 - PKG_MCRE0_TWS ERROR - LIVELLO_1 GRUPPO_4', PKG_MCRE0_AUDIT.C_ERROR, sqlcode, sqlerrm, 'Errore generico');
                        return ko;
        end TWS_MCRE0_LIVELLO1_G4;

        FUNCTION TWS_MCRE0_LIVELLO2_G1 return number IS

        BEGIN
            select SEQ_MCR0_LOG_ETL.nextval into seq from dual;
            PKG_MCRE0_AUDIT.log_etl (seq, '2_1 - PKG_MCRE0_TWS - INI - LIVELLO2_G1', PKG_MCRE0_AUDIT.C_DEBUG, sqlcode, 'INIZIO', 'INIZIO');
         PKG_MCRE0_AUDIT.log_etl (seq, '2_1 - PKG_MCRE0_TWS - INI - LIVELLO4_G1', PKG_MCRE0_AUDIT.C_DEBUG, sqlcode, 'INIZIO', 'INIZIO');
            esito:=0;
             --TABELLONE al posto della UPD_FIELDS
            PKG_MCRE0_AUDIT.log_etl (seq,'2_1 - ETL2 - INI - AGGIORNA ALL_DATA', PKG_MCRE0_AUDIT.C_DEBUG, sqlcode, 'INIZIO', 'INIZIO - eseguito Ricarico All_Data');
            RetVal := MCRE_OWN.PKG_MCRE0_GESTIONE_ALL_DATA.LOAD_ALL_DATA(seq);
            PKG_MCRE0_AUDIT.log_etl (seq,'2_1 - ETL2 - END - AGGIORNA ALL_DATA', PKG_MCRE0_AUDIT.C_DEBUG, sqlcode, 'Esito '||RetVal, 'FINE - eseguito Ricarico All_Data');
            if (RetVal = 0) then
                raise eccezione_interna;
            end if;
            PKG_MCRE0_AUDIT.log_etl (seq, '2_1 - PKG_MCRE0_TWS - END - LIVELLO2_G1', PKG_MCRE0_AUDIT.C_DEBUG, sqlcode, 'FINE', 'FINE');
            return ok;
        EXCEPTION
        when eccezione_interna then
                PKG_MCRE0_AUDIT.log_etl ('PKG_MCRE0_TWS ERROR - LIVELLO_3 GRUPPO_1', PKG_MCRE0_AUDIT.C_ERROR, sqlcode, sqlerrm, 'Errore interno');
                return ko;
        WHEN OTHERS THEN
            PKG_MCRE0_AUDIT.log_etl ('2_1 - PKG_MCRE0_TWS ERROR - LIVELLO_2 GRUPPO_1', PKG_MCRE0_AUDIT.C_ERROR, sqlcode, sqlerrm, 'Errore in ERROR - LIVELLO_2 GRUPPO_1');
            return ko;
        END TWS_MCRE0_LIVELLO2_G1;


    FUNCTION TWS_MCRE0_LIVELLO3_G1 return number IS

        BEGIN
            select SEQ_MCR0_LOG_ETL.nextval into seq from dual;
            PKG_MCRE0_AUDIT.log_etl (seq, '3_1 - PKG_MCRE0_TWS - INI - LIVELLO3_G1', PKG_MCRE0_AUDIT.C_DEBUG, sqlcode, 'INIZIO', 'INIZIO');
            esito:=0;
            --riempio prima la tabellona PCR
            PKG_MCRE0_AUDIT.log_etl (seq, '3_1 - PKG_MCRE0_TWS - INI - FNC_LOAD_PCR in seguito ai caricamenti', PKG_MCRE0_AUDIT.C_DEBUG, sqlcode, 'INIZIO', 'INIZIO - FNC_LOAD_PCR in seguito ai caricamenti');
            RetVal := MCRE_OWN.PKG_MCRE0_PCR3.FNC_LOAD_PCR(seq);
            PKG_MCRE0_AUDIT.log_etl (seq, '3_1 - PKG_MCRE0_TWS - END - FNC_LOAD_PCR in seguito ai caricamenti', PKG_MCRE0_AUDIT.C_DEBUG, sqlcode, 'Esito '||RetVal, 'FINE - FNC_LOAD_PCR in seguito ai caricamenti');
            if (RetVal = 0) then
                raise eccezione_interna;
            end if;
            PKG_MCRE0_AUDIT.log_etl (seq, '3_1 - PKG_MCRE0_TWS - END - LIVELLO3_G1', PKG_MCRE0_AUDIT.C_DEBUG, sqlcode, 'FINE', 'FINE');
            return ok;

        exception
            when eccezione_interna then
                PKG_MCRE0_AUDIT.log_etl ('PKG_MCRE0_TWS ERROR - LIVELLO_3 GRUPPO_1', PKG_MCRE0_AUDIT.C_ERROR, sqlcode, sqlerrm, 'Errore interno');
                return ko;
            when others then
                PKG_MCRE0_AUDIT.log_etl ('PKG_MCRE0_TWS ERROR - LIVELLO_3 GRUPPO_1', PKG_MCRE0_AUDIT.C_ERROR, sqlcode, sqlerrm, 'Errore generico');
                        return ko;
        end TWS_MCRE0_LIVELLO3_G1;

        FUNCTION TWS_MCRE0_LIVELLO3_G2 return number IS

        BEGIN
            select SEQ_MCR0_LOG_ETL.nextval into seq from dual;
            PKG_MCRE0_AUDIT.log_etl (seq, '3_2 - PKG_MCRE0_TWS - INI - LIVELLO3_G2', PKG_MCRE0_AUDIT.C_DEBUG, sqlcode, 'INIZIO', 'INIZIO');
            esito:=0;
            --riempo la tabellona CR
            PKG_MCRE0_AUDIT.log_etl (seq,'3_2 - INI - CR ', PKG_MCRE0_AUDIT.C_DEBUG, sqlcode, 'INIZIO', 'INIZIO - eseguito Calcolo CR');
            RetVal := MCRE_OWN.PKG_MCRE0_CR.FNC_LOAD_CR(seq);
            PKG_MCRE0_AUDIT.log_etl (seq,'3_2 - END - CR ', PKG_MCRE0_AUDIT.C_DEBUG, sqlcode, 'Esito '||RetVal, 'FINE - eseguito Calcolo CR');
--            if (RetVal = 0) then
--                raise eccezione_interna;
--            end if;
            PKG_MCRE0_AUDIT.log_etl (seq, '3_2 - PKG_MCRE0_TWS - END - LIVELLO3_G2', PKG_MCRE0_AUDIT.C_DEBUG, sqlcode, 'FINE', 'FINE');
            return ok;

        exception
            when eccezione_interna then
                PKG_MCRE0_AUDIT.log_etl ('3_2 - PKG_MCRE0_TWS ERROR - LIVELLO_3 GRUPPO_2', PKG_MCRE0_AUDIT.C_ERROR, sqlcode, sqlerrm, 'Errore interno');
                return ko;
            when others then
                PKG_MCRE0_AUDIT.log_etl ('3_2 - PKG_MCRE0_TWS ERROR - LIVELLO_3 GRUPPO_2', PKG_MCRE0_AUDIT.C_ERROR, sqlcode, sqlerrm, 'Errore generico');
                        return ko;
        end TWS_MCRE0_LIVELLO3_G2;

        FUNCTION TWS_MCRE0_LIVELLO3_G12 return number IS

        BEGIN
            select SEQ_MCR0_LOG_ETL.nextval into seq from dual;
            PKG_MCRE0_AUDIT.log_etl (seq, '3_12 - PKG_MCRE0_TWS - INI - LIVELLO3_12', PKG_MCRE0_AUDIT.C_DEBUG, sqlcode, 'INIZIO', 'INIZIO');
            esito:=0;
            --riempio prima la tabellona PCR
            --PKG_MCRE0_AUDIT.log_etl (seq, '3_02 - PKG_MCRE0_TWS - INI - FNC_LOAD_PCR in seguito ai caricamenti', PKG_MCRE0_AUDIT.C_DEBUG, sqlcode, 'INIZIO', 'INIZIO - FNC_LOAD_PCR in seguito ai caricamenti');
            --RetVal := MCRE_OWN.PKG_MCRE0_PCR3.FNC_LOAD_PCR(seq);
            --PKG_MCRE0_AUDIT.log_etl (seq, '3_02 - PKG_MCRE0_TWS - END - FNC_LOAD_PCR in seguito ai caricamenti', PKG_MCRE0_AUDIT.C_DEBUG, sqlcode, 'Esito '||RetVal, 'FINE - FNC_LOAD_PCR in seguito ai caricamenti');

            PKG_MCRE0_AUDIT.log_etl (seq, '3_12 - PKG_MCRE0_TWS - END - LIVELLO3_12', PKG_MCRE0_AUDIT.C_DEBUG, sqlcode, 'FINE', 'FINE');
            return ok;

        EXCEPTION WHEN OTHERS THEN
            PKG_MCRE0_AUDIT.log_etl ('PKG_MCRE0_TWS ERROR - LIVELLO_3 GRUPPO_12', PKG_MCRE0_AUDIT.C_ERROR, sqlcode, sqlerrm, 'Errore in ERROR - LIVELLO_3 GRUPPO_12');
            return ko;
        END TWS_MCRE0_LIVELLO3_G12;

        FUNCTION TWS_MCRE0_LIVELLO3_G13 return number IS

        BEGIN
            select SEQ_MCR0_LOG_ETL.nextval into seq from dual;
            PKG_MCRE0_AUDIT.log_etl (seq, '3_13 - PKG_MCRE0_TWS - INI - LIVELLO3_13', PKG_MCRE0_AUDIT.C_DEBUG, sqlcode, 'INIZIO', 'INIZIO');
            esito:=0;
            --riempio prima la tabellona PCR
            --PKG_MCRE0_AUDIT.log_etl (seq, '3_02 - PKG_MCRE0_TWS - INI - FNC_LOAD_PCR in seguito ai caricamenti', PKG_MCRE0_AUDIT.C_DEBUG, sqlcode, 'INIZIO', 'INIZIO - FNC_LOAD_PCR in seguito ai caricamenti');
            --RetVal := MCRE_OWN.PKG_MCRE0_PCR3.FNC_LOAD_PCR(seq);
            --PKG_MCRE0_AUDIT.log_etl (seq, '3_02 - PKG_MCRE0_TWS - END - FNC_LOAD_PCR in seguito ai caricamenti', PKG_MCRE0_AUDIT.C_DEBUG, sqlcode, 'Esito '||RetVal, 'FINE - FNC_LOAD_PCR in seguito ai caricamenti');

            PKG_MCRE0_AUDIT.log_etl (seq, '3_13 - PKG_MCRE0_TWS - END - LIVELLO3_13', PKG_MCRE0_AUDIT.C_DEBUG, sqlcode, 'FINE', 'FINE');
            return ok;

        EXCEPTION WHEN OTHERS THEN
            PKG_MCRE0_AUDIT.log_etl ('PKG_MCRE0_TWS ERROR - LIVELLO_3 GRUPPO_13', PKG_MCRE0_AUDIT.C_ERROR, sqlcode, sqlerrm, 'Errore in ERROR - LIVELLO_3 GRUPPO_13');
            return ko;
        END TWS_MCRE0_LIVELLO3_G13;

        FUNCTION TWS_MCRE0_LIVELLO3_G14 return number IS

        BEGIN
            select SEQ_MCR0_LOG_ETL.nextval into seq from dual;
            PKG_MCRE0_AUDIT.log_etl (seq, '3_14 - PKG_MCRE0_TWS - INI - LIVELLO3_14', PKG_MCRE0_AUDIT.C_DEBUG, sqlcode, 'INIZIO', 'INIZIO');
            esito:=0;
            --riempio prima la tabellona PCR
            --PKG_MCRE0_AUDIT.log_etl (seq, '3_02 - PKG_MCRE0_TWS - INI - FNC_LOAD_PCR in seguito ai caricamenti', PKG_MCRE0_AUDIT.C_DEBUG, sqlcode, 'INIZIO', 'INIZIO - FNC_LOAD_PCR in seguito ai caricamenti');
            --RetVal := MCRE_OWN.PKG_MCRE0_PCR3.FNC_LOAD_PCR(seq);
            --PKG_MCRE0_AUDIT.log_etl (seq, '3_02 - PKG_MCRE0_TWS - END - FNC_LOAD_PCR in seguito ai caricamenti', PKG_MCRE0_AUDIT.C_DEBUG, sqlcode, 'Esito '||RetVal, 'FINE - FNC_LOAD_PCR in seguito ai caricamenti');

            PKG_MCRE0_AUDIT.log_etl (seq, '3_14 - PKG_MCRE0_TWS - END - LIVELLO3_14', PKG_MCRE0_AUDIT.C_DEBUG, sqlcode, 'FINE', 'FINE');
            return ok;

        EXCEPTION WHEN OTHERS THEN
            PKG_MCRE0_AUDIT.log_etl ('PKG_MCRE0_TWS ERROR - LIVELLO_3 GRUPPO_14', PKG_MCRE0_AUDIT.C_ERROR, sqlcode, sqlerrm, 'Errore in ERROR - LIVELLO_3 GRUPPO_14');
            return ko;
        END TWS_MCRE0_LIVELLO3_G14;

        FUNCTION TWS_MCRE0_LIVELLO3_G22 return number IS

        BEGIN
            select SEQ_MCR0_LOG_ETL.nextval into seq from dual;
            PKG_MCRE0_AUDIT.log_etl (seq, '3_22 - PKG_MCRE0_TWS - INI - LIVELLO3_22', PKG_MCRE0_AUDIT.C_DEBUG, sqlcode, 'INIZIO', 'INIZIO');
            esito:=0;
            --riempio prima la tabellona PCR
            --PKG_MCRE0_AUDIT.log_etl (seq, '3_02 - PKG_MCRE0_TWS - INI - FNC_LOAD_PCR in seguito ai caricamenti', PKG_MCRE0_AUDIT.C_DEBUG, sqlcode, 'INIZIO', 'INIZIO - FNC_LOAD_PCR in seguito ai caricamenti');
            --RetVal := MCRE_OWN.PKG_MCRE0_PCR3.FNC_LOAD_PCR(seq);
            --PKG_MCRE0_AUDIT.log_etl (seq, '3_02 - PKG_MCRE0_TWS - END - FNC_LOAD_PCR in seguito ai caricamenti', PKG_MCRE0_AUDIT.C_DEBUG, sqlcode, 'Esito '||RetVal, 'FINE - FNC_LOAD_PCR in seguito ai caricamenti');

            PKG_MCRE0_AUDIT.log_etl (seq, '3_22 - PKG_MCRE0_TWS - END - LIVELLO3_22', PKG_MCRE0_AUDIT.C_DEBUG, sqlcode, 'FINE', 'FINE');
            return ok;

        EXCEPTION WHEN OTHERS THEN
            PKG_MCRE0_AUDIT.log_etl ('PKG_MCRE0_TWS ERROR - LIVELLO_3 GRUPPO_22', PKG_MCRE0_AUDIT.C_ERROR, sqlcode, sqlerrm, 'Errore in ERROR - LIVELLO_3 GRUPPO_22');
            return ko;
        END TWS_MCRE0_LIVELLO3_G22;

        FUNCTION TWS_MCRE0_LIVELLO3_G23 return number IS

        BEGIN
            select SEQ_MCR0_LOG_ETL.nextval into seq from dual;
            PKG_MCRE0_AUDIT.log_etl (seq, '3_23 - PKG_MCRE0_TWS - INI - LIVELLO3_23', PKG_MCRE0_AUDIT.C_DEBUG, sqlcode, 'INIZIO', 'INIZIO');
            esito:=0;
            --riempio prima la tabellona PCR
            --PKG_MCRE0_AUDIT.log_etl (seq, '3_02 - PKG_MCRE0_TWS - INI - FNC_LOAD_PCR in seguito ai caricamenti', PKG_MCRE0_AUDIT.C_DEBUG, sqlcode, 'INIZIO', 'INIZIO - FNC_LOAD_PCR in seguito ai caricamenti');
            --RetVal := MCRE_OWN.PKG_MCRE0_PCR3.FNC_LOAD_PCR(seq);
            --PKG_MCRE0_AUDIT.log_etl (seq, '3_02 - PKG_MCRE0_TWS - END - FNC_LOAD_PCR in seguito ai caricamenti', PKG_MCRE0_AUDIT.C_DEBUG, sqlcode, 'Esito '||RetVal, 'FINE - FNC_LOAD_PCR in seguito ai caricamenti');

            PKG_MCRE0_AUDIT.log_etl (seq, '3_23 - PKG_MCRE0_TWS - END - LIVELLO3_23', PKG_MCRE0_AUDIT.C_DEBUG, sqlcode, 'FINE', 'FINE');
            return ok;

        EXCEPTION WHEN OTHERS THEN
            PKG_MCRE0_AUDIT.log_etl ('PKG_MCRE0_TWS ERROR - LIVELLO_3 GRUPPO_23', PKG_MCRE0_AUDIT.C_ERROR, sqlcode, sqlerrm, 'Errore in ERROR - LIVELLO_3 GRUPPO_23');
            return ko;
        END TWS_MCRE0_LIVELLO3_G23;

        FUNCTION TWS_MCRE0_LIVELLO3_G24 return number IS

        BEGIN
            select SEQ_MCR0_LOG_ETL.nextval into seq from dual;
            PKG_MCRE0_AUDIT.log_etl (seq, '3_24 - PKG_MCRE0_TWS - INI - LIVELLO3_24', PKG_MCRE0_AUDIT.C_DEBUG, sqlcode, 'INIZIO', 'INIZIO');
            esito:=0;
            --riempio prima la tabellona PCR
            --PKG_MCRE0_AUDIT.log_etl (seq, '3_02 - PKG_MCRE0_TWS - INI - FNC_LOAD_PCR in seguito ai caricamenti', PKG_MCRE0_AUDIT.C_DEBUG, sqlcode, 'INIZIO', 'INIZIO - FNC_LOAD_PCR in seguito ai caricamenti');
            --RetVal := MCRE_OWN.PKG_MCRE0_PCR3.FNC_LOAD_PCR(seq);
            --PKG_MCRE0_AUDIT.log_etl (seq, '3_02 - PKG_MCRE0_TWS - END - FNC_LOAD_PCR in seguito ai caricamenti', PKG_MCRE0_AUDIT.C_DEBUG, sqlcode, 'Esito '||RetVal, 'FINE - FNC_LOAD_PCR in seguito ai caricamenti');

            PKG_MCRE0_AUDIT.log_etl (seq, '3_24 - PKG_MCRE0_TWS - END - LIVELLO3_24', PKG_MCRE0_AUDIT.C_DEBUG, sqlcode, 'FINE', 'FINE');
            return ok;

        EXCEPTION WHEN OTHERS THEN
            PKG_MCRE0_AUDIT.log_etl ('PKG_MCRE0_TWS ERROR - LIVELLO_3 GRUPPO_24', PKG_MCRE0_AUDIT.C_ERROR, sqlcode, sqlerrm, 'Errore in ERROR - LIVELLO_3 GRUPPO_24');
            return ko;
        END TWS_MCRE0_LIVELLO3_G24;

        FUNCTION TWS_MCRE0_LIVELLO3_G25 return number IS

        BEGIN
            select SEQ_MCR0_LOG_ETL.nextval into seq from dual;
            PKG_MCRE0_AUDIT.log_etl (seq, '3_25 - PKG_MCRE0_TWS - INI - LIVELLO3_25', PKG_MCRE0_AUDIT.C_DEBUG, sqlcode, 'INIZIO', 'INIZIO');
            esito:=0;
            --riempio prima la tabellona PCR
            --PKG_MCRE0_AUDIT.log_etl (seq, '3_02 - PKG_MCRE0_TWS - INI - FNC_LOAD_PCR in seguito ai caricamenti', PKG_MCRE0_AUDIT.C_DEBUG, sqlcode, 'INIZIO', 'INIZIO - FNC_LOAD_PCR in seguito ai caricamenti');
            --RetVal := MCRE_OWN.PKG_MCRE0_PCR3.FNC_LOAD_PCR(seq);
            --PKG_MCRE0_AUDIT.log_etl (seq, '3_02 - PKG_MCRE0_TWS - END - FNC_LOAD_PCR in seguito ai caricamenti', PKG_MCRE0_AUDIT.C_DEBUG, sqlcode, 'Esito '||RetVal, 'FINE - FNC_LOAD_PCR in seguito ai caricamenti');

            PKG_MCRE0_AUDIT.log_etl (seq, '3_25 - PKG_MCRE0_TWS - END - LIVELLO3_25', PKG_MCRE0_AUDIT.C_DEBUG, sqlcode, 'FINE', 'FINE');
            return ok;

        EXCEPTION WHEN OTHERS THEN
            PKG_MCRE0_AUDIT.log_etl ('PKG_MCRE0_TWS ERROR - LIVELLO_3 GRUPPO_25', PKG_MCRE0_AUDIT.C_ERROR, sqlcode, sqlerrm, 'Errore in ERROR - LIVELLO_3 GRUPPO_25');
            return ko;
        END TWS_MCRE0_LIVELLO3_G25;

        FUNCTION TWS_MCRE0_LIVELLO3_G26 return number IS

        BEGIN
            select SEQ_MCR0_LOG_ETL.nextval into seq from dual;
            PKG_MCRE0_AUDIT.log_etl (seq, '3_26 - PKG_MCRE0_TWS - INI - LIVELLO3_26', PKG_MCRE0_AUDIT.C_DEBUG, sqlcode, 'INIZIO', 'INIZIO');
            esito:=0;
            --riempio prima la tabellona PCR
            --PKG_MCRE0_AUDIT.log_etl (seq, '3_02 - PKG_MCRE0_TWS - INI - FNC_LOAD_PCR in seguito ai caricamenti', PKG_MCRE0_AUDIT.C_DEBUG, sqlcode, 'INIZIO', 'INIZIO - FNC_LOAD_PCR in seguito ai caricamenti');
            --RetVal := MCRE_OWN.PKG_MCRE0_PCR3.FNC_LOAD_PCR(seq);
            --PKG_MCRE0_AUDIT.log_etl (seq, '3_02 - PKG_MCRE0_TWS - END - FNC_LOAD_PCR in seguito ai caricamenti', PKG_MCRE0_AUDIT.C_DEBUG, sqlcode, 'Esito '||RetVal, 'FINE - FNC_LOAD_PCR in seguito ai caricamenti');

            PKG_MCRE0_AUDIT.log_etl (seq, '3_26 - PKG_MCRE0_TWS - END - LIVELLO3_26', PKG_MCRE0_AUDIT.C_DEBUG, sqlcode, 'FINE', 'FINE');
            return ok;

        EXCEPTION WHEN OTHERS THEN
            PKG_MCRE0_AUDIT.log_etl ('PKG_MCRE0_TWS ERROR - LIVELLO_3 GRUPPO_26', PKG_MCRE0_AUDIT.C_ERROR, sqlcode, sqlerrm, 'Errore in ERROR - LIVELLO_3 GRUPPO_26');
            return ko;
        END TWS_MCRE0_LIVELLO3_G26;

       FUNCTION TWS_MCRE0_LIVELLO4_G0 return number IS

        BEGIN
            select SEQ_MCR0_LOG_ETL.nextval into seq from dual;
--            PKG_MCRE0_AUDIT.log_etl (seq, '4_0 - PKG_MCRE0_TWS - INI - LIVELLO4_G0', PKG_MCRE0_AUDIT.C_DEBUG, sqlcode, 'INIZIO', 'INIZIO');
--            esito:=0;
--            PKG_MCRE0_AUDIT.log_etl (seq,'4_0 - ETL2 - INI - AGGIORNA ALL_DATA', PKG_MCRE0_AUDIT.C_DEBUG, sqlcode, 'INIZIO', 'INIZIO - eseguito Ricarico All_Data');
--            RetVal := MCRE_OWN.PKG_MCRE0_GESTIONE_ALL_DATA.LOAD_ALL_DATA(seq);
--            PKG_MCRE0_AUDIT.log_etl (seq,'4_0 - ETL2 - END - AGGIORNA ALL_DATA', PKG_MCRE0_AUDIT.C_DEBUG, sqlcode, 'Esito '||RetVal, 'FINE - eseguito Ricarico All_Data');
--            if (RetVal = 0) then
--                raise eccezione_interna;
--            end if;
--            PKG_MCRE0_AUDIT.log_etl (seq, '4_0 - PKG_MCRE0_TWS - END - LIVELLO4_G0', PKG_MCRE0_AUDIT.C_DEBUG, sqlcode, 'FINE', 'FINE');
            return ok;
        exception
--            when eccezione_interna then
--                PKG_MCRE0_AUDIT.log_etl ('4_0 - PKG_MCRE0_TWS ERROR - LIVELLO_4 GRUPPO_0', PKG_MCRE0_AUDIT.C_ERROR, sqlcode, sqlerrm, 'Errore interno');
--                return ko;
            when others then
                PKG_MCRE0_AUDIT.log_etl ('4_0 - PKG_MCRE0_TWS ERROR - LIVELLO_4 GRUPPO_0', PKG_MCRE0_AUDIT.C_ERROR, sqlcode, sqlerrm, 'Errore generico');
                        return ko;
        end TWS_MCRE0_LIVELLO4_G0;

    FUNCTION TWS_MCRE0_LIVELLO4_G1 return number IS

        BEGIN
            select SEQ_MCR0_LOG_ETL.nextval into seq from dual;
            PKG_MCRE0_AUDIT.log_etl (seq, '4_1 - PKG_MCRE0_TWS - INI - LIVELLO4_G1', PKG_MCRE0_AUDIT.C_DEBUG, sqlcode, 'INIZIO', 'INIZIO');
--            esito:=0;
--             --TABELLONE al posto della UPD_FIELDS
--            PKG_MCRE0_AUDIT.log_etl (seq,'4_1 - ETL2 - INI - AGGIORNA ALL_DATA', PKG_MCRE0_AUDIT.C_DEBUG, sqlcode, 'INIZIO', 'INIZIO - eseguito Ricarico All_Data');
--            RetVal := MCRE_OWN.PKG_MCRE0_GESTIONE_ALL_DATA.LOAD_ALL_DATA(seq);
--            PKG_MCRE0_AUDIT.log_etl (seq,'4_1 - ETL2 - END - AGGIORNA ALL_DATA', PKG_MCRE0_AUDIT.C_DEBUG, sqlcode, 'Esito '||RetVal, 'FINE - eseguito Ricarico All_Data');
--            if (RetVal = 0) then
--                raise eccezione_interna;
--            end if;
            -- PT
            PKG_MCRE0_AUDIT.log_etl (seq, '4_1 - PKG_MCRE0_TWS - INI - Delete PT', PKG_MCRE0_AUDIT.C_DEBUG, sqlcode, 'INIZIO', 'INIZIO - Delete PT');
            RetVal := PKG_MCRE0_PORTALE_GEST_STATI.FNC_DELETE_PT(SEQ);
            PKG_MCRE0_AUDIT.log_etl (seq, '4_1 - PKG_MCRE0_TWS - END - Delete PT', PKG_MCRE0_AUDIT.C_DEBUG, sqlcode, 'Esito '||RetVal, 'FINE - Delete PT');
            if (RetVal = 0) then
                raise eccezione_interna;
            end if;
            -- RIO
            PKG_MCRE0_AUDIT.log_etl (seq, '4_1 - PKG_MCRE0_TWS - INI - Delete RIO', PKG_MCRE0_AUDIT.C_DEBUG, sqlcode, 'INIZIO', 'INIZIO - Delete RIO');
            RetVal := PKG_MCRE0_PORTALE_GEST_STATI.FNC_DELETE_RIO(SEQ);
            PKG_MCRE0_AUDIT.log_etl (seq, '4_1 - PKG_MCRE0_TWS - END - Delete RIO', PKG_MCRE0_AUDIT.C_DEBUG, sqlcode, 'Esito '||RetVal, 'FINE - Delete RIO');
            if (RetVal = 0) then
                raise eccezione_interna;
            end if;
            -- GB
            PKG_MCRE0_AUDIT.log_etl (seq,'4_1 - INI - CLEAN STATI', PKG_MCRE0_AUDIT.C_DEBUG, sqlcode, 'INIZIO', 'INIZIO - eseguito Delete GB');
            RetVal := PKG_MCRE0_PORTALE_GEST_STATI.FNC_DELETE_GB(SEQ);
            PKG_MCRE0_AUDIT.log_etl (seq,'4_1 - END - CLEAN STATI', PKG_MCRE0_AUDIT.C_DEBUG, sqlcode, 'Esito '||RetVal, 'FINE - eseguito Delete GB');
            if (RetVal = 0) then
                raise eccezione_interna;
            end if;
            -- Anagrafica generale --spostata!ex 5_1 v2.1
            PKG_MCRE0_AUDIT.log_etl (seq, '4_1 - PKG_MCRE0_TWS - INI - Aggiorna AnaGen in seguito ai caricamenti', PKG_MCRE0_AUDIT.C_DEBUG, sqlcode, 'Esito 1', 'INIZIO - Aggiorna AnaGen in seguito ai caricamenti');
            RetVal := MCRE_OWN.PKG_MCRE0_AGGIORNA_MV.aggiorna_AnaGenETL(seq);
            PKG_MCRE0_AUDIT.log_etl (seq, '4_1 - PKG_MCRE0_TWS - END - Aggiorna AnaGen in seguito ai caricamenti', PKG_MCRE0_AUDIT.C_DEBUG, sqlcode, 'Esito '||RetVal, 'FINE - Aggiorna AnaGen in seguito ai caricamenti');
            if (RetVal = 0) then
                raise eccezione_interna;
            end if;
            --   execute immediate 'truncate table  T_MCRE0_TMP_LISTA_STORICO';
--             --prerequisiti per esecuzione in parallelo degli alter a livello 5
--            PKG_MCRE0_AUDIT.log_etl (seq,'4_1 - ETL2 - FNC_BATCH_TRUNC_POS_TMP', PKG_MCRE0_AUDIT.C_DEBUG, sqlcode, 'INIZIO', 'INIZIO - FNC_BATCH_TRUNC_POS_TMP');
            /***** VG: Truncate TMP nuova gestione alert *****/
            --RetVal := MCRE_OWN.PKG_MCRE0_ALERT3.FNC_TO_WORKING_TABLE;
            RetVal := MCRE_OWN.PKG_MCRE0_ALERT.FNC_BATCH_TRUNC_POS_TMP(seq);
            PKG_MCRE0_AUDIT.log_etl (seq,'4_1 - ETL2 - FNC_BATCH_TRUNC_POS_TMP', PKG_MCRE0_AUDIT.C_DEBUG, sqlcode, 'Esito '||RETVAL, 'FINE - FNC_BATCH_TRUNC_POS_TMP');
            if (RetVal = 0) then
                raise eccezione_interna;
            end if;
            PKG_MCRE0_AUDIT.log_etl (seq, '4_1 - PKG_MCRE0_TWS - END - LIVELLO4_G1', PKG_MCRE0_AUDIT.C_DEBUG, sqlcode, 'FINE', 'FINE');
            return ok;
        exception
            when eccezione_interna then
                PKG_MCRE0_AUDIT.log_etl ('4_1 - PKG_MCRE0_TWS ERROR - LIVELLO_4 GRUPPO_1', PKG_MCRE0_AUDIT.C_ERROR, sqlcode, sqlerrm, 'Errore interno');
                return ko;
            when others then
                PKG_MCRE0_AUDIT.log_etl ('4_1 - PKG_MCRE0_TWS ERROR - LIVELLO_4 GRUPPO_1', PKG_MCRE0_AUDIT.C_ERROR, sqlcode, sqlerrm, 'Errore generico');
                        return ko;
        end TWS_MCRE0_LIVELLO4_G1;

    FUNCTION TWS_MCRE0_LIVELLO5_G01 return number IS
        BEGIN
            select SEQ_MCR0_LOG_ETL.nextval into seq from dual;
            PKG_MCRE0_AUDIT.log_etl (seq, '5_1 - PKG_MCRE0_TWS - INI - LIVELLO5_G1', PKG_MCRE0_AUDIT.C_DEBUG, sqlcode, 'INIZIO', 'INIZIO');
            esito:=0;
            PKG_MCRE0_AUDIT.log_etl (seq, '5_1 - PKG_MCRE0_TWS - INI - Aggiorna Uscite in seguito ai caricamenti', PKG_MCRE0_AUDIT.C_DEBUG, sqlcode, 'INIZIO', 'INIZIO - Aggiorna Uscite in seguito ai caricamenti');
            RETVAL := MCRE_OWN.PKG_MCRE0_AGGIORNA_MV2.AGGIORNA_USCITE(seq);
            PKG_MCRE0_AUDIT.log_etl (seq, '5_1 - PKG_MCRE0_TWS - END - Aggiorna Uscite in seguito ai caricamenti', PKG_MCRE0_AUDIT.C_DEBUG, sqlcode, 'Esito '||RetVal, 'FINE - Aggiorna Uscite in seguito ai caricamenti');
            if (RetVal = 0) then
                raise eccezione_interna;
            end if;

            PKG_MCRE0_AUDIT.log_etl (seq, '5_1 - PKG_MCRE0_TWS - END - LIVELLO5_G1', PKG_MCRE0_AUDIT.C_DEBUG, sqlcode, 'FINE', 'FINE');
            return ok;
        exception
            when eccezione_interna then
                PKG_MCRE0_AUDIT.log_etl ('5_1 - PKG_MCRE0_TWS ERROR - LIVELLO_5 GRUPPO_1', PKG_MCRE0_AUDIT.C_ERROR, sqlcode, sqlerrm, 'Errore interno');
                return ko;
            when others then
                PKG_MCRE0_AUDIT.log_etl ('5_1 - PKG_MCRE0_TWS ERROR - LIVELLO_5 GRUPPO_1', PKG_MCRE0_AUDIT.C_ERROR, sqlcode, sqlerrm, 'Errore generico');
                        return ko;
        end TWS_MCRE0_LIVELLO5_G01;

    FUNCTION TWS_MCRE0_LIVELLO5_G02 return number IS
       BEGIN
            select SEQ_MCR0_LOG_ETL.nextval into seq from dual;
            PKG_MCRE0_AUDIT.log_etl (seq, '5_2 - PKG_MCRE0_TWS - INI - LIVELLO5_G2', PKG_MCRE0_AUDIT.C_DEBUG, sqlcode, 'INIZIO', 'INIZIO');
            esito:=0;
            PKG_MCRE0_AUDIT.log_etl (seq, '5_2 - PKG_MCRE0_TWS - INI - Aggiorna Rio Monit. in seguito ai caricamenti', PKG_MCRE0_AUDIT.C_DEBUG, sqlcode, 'Esito 1', 'INIZIO - Aggiorna Rio Monit. in seguito ai caricamenti');
            RETVAL := MCRE_OWN.PKG_MCRE0_AGGIORNA_MV.aggiorna_RIO_MONITORAGGIO(seq);
            PKG_MCRE0_AUDIT.log_etl (seq, '5_2 - PKG_MCRE0_TWS - END - Aggiorna Rio Monit. in seguito ai caricamenti', PKG_MCRE0_AUDIT.C_DEBUG, sqlcode, 'Esito '||RetVal, 'FINE - Aggiorna Rio Monit. in seguito ai caricamenti');
            if (RetVal = 0) then
                raise eccezione_interna;
            end if;
            -- MV CR
--            PKG_MCRE0_AUDIT.log_etl (seq,'5_2 - ETL2 - INI - AGGIORNA MV', PKG_MCRE0_AUDIT.C_DEBUG, sqlcode, 'INIZIO', 'INIZIO - eseguito Aggiorna CR.');
--            RETVAL := MCRE_OWN.PKG_MCRE0_AGGIORNA_MV.AGGIORNA_CR_ALL(seq);
--            PKG_MCRE0_AUDIT.log_etl (seq,'5_2 - ETL2 - END - AGGIORNA MV', PKG_MCRE0_AUDIT.C_DEBUG, sqlcode, 'Esito '||RetVal, 'FINE - eseguito Aggiorna CR.');
--            if (RetVal = 0) then
--                raise eccezione_interna;
--            end if;
--            PKG_MCRE0_AUDIT.log_etl (seq,'5_2 - ETL2 - FNC_VERIFICA_ALERT_BLOCCO 9', PKG_MCRE0_AUDIT.C_DEBUG, sqlcode, 'INIZIO', 'INIZIO - FNC_VERIFICA_ALERT_BLOCCO 9.');
--            RetVal := MCRE_OWN.PKG_MCRE0_ALERT3.FNC_VERIFICA_ALERT_BLOCCO ( seq, 9 );
--            PKG_MCRE0_AUDIT.log_etl (seq,'5_2 - ETL2 - FNC_VERIFICA_ALERT_BLOCCO 9', PKG_MCRE0_AUDIT.C_DEBUG, sqlcode, 'Esito '||RETVAL, 'FINE - FNC_VERIFICA_ALERT_BLOCCO 9.');
--            if (RetVal = 0) then
--                raise eccezione_interna;
--            end if;
            PKG_MCRE0_AUDIT.log_etl (seq, '5_2 - PKG_MCRE0_TWS - END - LIVELLO5_G2', PKG_MCRE0_AUDIT.C_DEBUG, sqlcode, 'FINE', 'FINE');
                        return ok;
       exception
            when eccezione_interna then
                PKG_MCRE0_AUDIT.log_etl ('5_2 - PKG_MCRE0_TWS ERROR - LIVELLO_5 GRUPPO_2', PKG_MCRE0_AUDIT.C_ERROR, sqlcode, sqlerrm, 'Errore interno');
                return ko;
            when others then
                PKG_MCRE0_AUDIT.log_etl ('5_2 - PKG_MCRE0_TWS ERROR - LIVELLO_5 GRUPPO_2', PKG_MCRE0_AUDIT.C_ERROR, sqlcode, sqlerrm, 'Errore generico');
                        return ko;
       end TWS_MCRE0_LIVELLO5_G02;

    FUNCTION TWS_MCRE0_LIVELLO5_G03 return number IS
       BEGIN
            select SEQ_MCR0_LOG_ETL.nextval into seq from dual;
            PKG_MCRE0_AUDIT.log_etl (seq, '5_3 - PKG_MCRE0_TWS - INI - LIVELLO5_G3', PKG_MCRE0_AUDIT.C_DEBUG, sqlcode, 'INIZIO', 'INIZIO');
            esito:=0;
            PKG_MCRE0_AUDIT.log_etl (seq, '5_3 - PKG_MCRE0_TWS - INI - Aggiorna Rio ESP GE e SC in seguito ai caricamenti', PKG_MCRE0_AUDIT.C_DEBUG, sqlcode, 'INIZIO', 'INIZIO - Aggiorna Rio ESP GE e SC in seguito ai caricamenti');
            RETVAL := MCRE_OWN.PKG_MCRE0_AGGIORNA_MV2.aggiorna_RIO_ESP(seq);
            PKG_MCRE0_AUDIT.log_etl (seq, '5_3 - PKG_MCRE0_TWS - END - Aggiorna Rio ESP GE e SC in seguito ai caricamenti', PKG_MCRE0_AUDIT.C_DEBUG, sqlcode, 'Esito '||RetVal, 'FINE - Aggiorna Rio ESP GE e SC in seguito ai caricamenti');
            if (RetVal = 0) then
                raise eccezione_interna;
            end if;
            PKG_MCRE0_AUDIT.log_etl (seq, '5_3 - PKG_MCRE0_TWS - END - LIVELLO5_G3', PKG_MCRE0_AUDIT.C_DEBUG, sqlcode, 'FINE', 'FINE');
            return ok;
       exception
            when eccezione_interna then
                PKG_MCRE0_AUDIT.log_etl ('5_3 - PKG_MCRE0_TWS ERROR - LIVELLO_5 GRUPPO_3', PKG_MCRE0_AUDIT.C_ERROR, sqlcode, sqlerrm, 'Errore interno');
                return ko;
            when others then
                PKG_MCRE0_AUDIT.log_etl ('5_3 - PKG_MCRE0_TWS ERROR - LIVELLO_5 GRUPPO_3', PKG_MCRE0_AUDIT.C_ERROR, sqlcode, sqlerrm, 'Errore generico');
                        return ko;
       end TWS_MCRE0_LIVELLO5_G03;

    FUNCTION TWS_MCRE0_LIVELLO5_G04 return number IS
        BEGIN
            select SEQ_MCR0_LOG_ETL.nextval into seq from dual;
            PKG_MCRE0_AUDIT.log_etl (seq, '5_4 - PKG_MCRE0_TWS - INI - LIVELLO5_G4', PKG_MCRE0_AUDIT.C_DEBUG, sqlcode, 'INIZIO', 'INIZIO');
            esito:=0;
--            PKG_MCRE0_AUDIT.log_etl (seq,'5_4 - ETL2 - INI - FNC_VERIFICA_ALERT_BLOCCO 1', PKG_MCRE0_AUDIT.C_DEBUG, sqlcode, 'INIZIO', 'INIZIO - FNC_VERIFICA_ALERT_BLOCCO 1.');
--            RetVal := MCRE_OWN.PKG_MCRE0_ALERT3.FNC_VERIFICA_ALERT_BLOCCO ( seq, 1 );
--            PKG_MCRE0_AUDIT.log_etl (seq,'5_4 - ETL2 - END - FNC_VERIFICA_ALERT_BLOCCO 1', PKG_MCRE0_AUDIT.C_DEBUG, sqlcode, 'Esito '||RETVAL, 'FINE - FNC_VERIFICA_ALERT_BLOCCO 1.');
            /***** VG: Reload Gruppo 1 nuova gestione alert *****/
            PKG_MCRE0_AUDIT.log_etl (seq,'5_4 - ETL2 - FNC_BATCH_ALERT_GRUPPO_1', PKG_MCRE0_AUDIT.C_DEBUG, sqlcode, 'INIZIO', 'INIZIO - FNC_BATCH_ALERT_GRUPPO_1.');
            RetVal := MCRE_OWN.PKG_MCRE0_ALERT.FNC_BATCH_ALERT_GRUPPO_1(seq);
            PKG_MCRE0_AUDIT.log_etl (seq,'5_4 - ETL2 - FNC_BATCH_ALERT_GRUPPO_1', PKG_MCRE0_AUDIT.C_DEBUG, sqlcode, 'Esito '||RETVAL, 'FINE - FNC_BATCH_ALERT_GRUPPO_1.');
            if (RetVal = 0) then
                raise eccezione_interna;
            end if;
            PKG_MCRE0_AUDIT.log_etl (seq, '5_4 - PKG_MCRE0_TWS - END - LIVELLO5_G4', PKG_MCRE0_AUDIT.C_DEBUG, sqlcode, 'FINE', 'FINE');
            return ok;
        exception
            when eccezione_interna then
                PKG_MCRE0_AUDIT.log_etl ('5_4 - PKG_MCRE0_TWS ERROR - LIVELLO_5 GRUPPO_4', PKG_MCRE0_AUDIT.C_ERROR, sqlcode, sqlerrm, 'Errore interno');
                return ko;
            when others then
                PKG_MCRE0_AUDIT.log_etl ('5_4 - PKG_MCRE0_TWS ERROR - LIVELLO_5 GRUPPO_4', PKG_MCRE0_AUDIT.C_ERROR, sqlcode, sqlerrm, 'Errore generico');
                        return ko;
        end TWS_MCRE0_LIVELLO5_G04;

    FUNCTION TWS_MCRE0_LIVELLO5_G05 return number IS
       BEGIN
            select SEQ_MCR0_LOG_ETL.nextval into seq from dual;
            PKG_MCRE0_AUDIT.log_etl (seq, '5_5 - PKG_MCRE0_TWS - INI - LIVELLO5_G5', PKG_MCRE0_AUDIT.C_DEBUG, sqlcode, 'INIZIO', 'INIZIO');
            esito:=0;
            PKG_MCRE0_AUDIT.log_etl (seq, '5_5 - PKG_MCRE0_TWS - INI - Aggiorna Rio ESP Ann in seguito ai caricamenti', PKG_MCRE0_AUDIT.C_DEBUG, sqlcode, 'INIZIO', 'INIZIO - Aggiorna Rio ESP Ann in seguito ai caricamenti');
            RETVAL := MCRE_OWN.PKG_MCRE0_AGGIORNA_MV2.aggiorna_RIO_ESP_ANN(seq);
            PKG_MCRE0_AUDIT.log_etl (seq, '5_5 - PKG_MCRE0_TWS - END - Aggiorna Rio ESP Ann in seguito ai caricamenti', PKG_MCRE0_AUDIT.C_DEBUG, sqlcode, 'Esito '||RetVal, 'FINE - Aggiorna Rio ESP Ann in seguito ai caricamenti');
            if (RetVal = 0) then
                raise eccezione_interna;
            end if;
--            PKG_MCRE0_AUDIT.log_etl (seq,'5_5 - ETL2 - INI - FNC_VERIFICA_ALERT_BLOCCO 2', PKG_MCRE0_AUDIT.C_DEBUG, sqlcode, 'INIZIO', 'INIZIO - FNC_VERIFICA_ALERT_BLOCCO 2.');
--            RetVal := MCRE_OWN.PKG_MCRE0_ALERT3.FNC_VERIFICA_ALERT_BLOCCO ( seq, 2 );
--            PKG_MCRE0_AUDIT.log_etl (seq,'5_5 - ETL2 - END - FNC_VERIFICA_ALERT_BLOCCO 2', PKG_MCRE0_AUDIT.C_DEBUG, sqlcode, 'Esito '||RETVAL, 'FINE - FNC_VERIFICA_ALERT_BLOCCO 2.');
--            if (RetVal = 0) then
--                raise eccezione_interna;
--            end if;
--            PKG_MCRE0_AUDIT.log_etl (seq,'5_5 - ETL2 - INI - FNC_VERIFICA_ALERT_BLOCCO 4', PKG_MCRE0_AUDIT.C_DEBUG, sqlcode, 'INIZIO', 'INIZIO - FNC_VERIFICA_ALERT_BLOCCO 4.');
--            RetVal := MCRE_OWN.PKG_MCRE0_ALERT3.FNC_VERIFICA_ALERT_BLOCCO ( seq, 4 );
--            PKG_MCRE0_AUDIT.log_etl (seq,'5_5 - ETL2 - END - FNC_VERIFICA_ALERT_BLOCCO 4', PKG_MCRE0_AUDIT.C_DEBUG, sqlcode, 'Esito '||RETVAL, 'FINE - FNC_VERIFICA_ALERT_BLOCCO 4.');
--            if (RetVal = 0) then
--                raise eccezione_interna;
--            end if;
            PKG_MCRE0_AUDIT.log_etl (seq, '5_5 - PKG_MCRE0_TWS - END - LIVELLO5_G5', PKG_MCRE0_AUDIT.C_DEBUG, sqlcode, 'FINE', 'FINE');
            return ok;
       exception
            when eccezione_interna then
                PKG_MCRE0_AUDIT.log_etl ('5_5 - PKG_MCRE0_TWS ERROR - LIVELLO_5 GRUPPO_5', PKG_MCRE0_AUDIT.C_ERROR, sqlcode, sqlerrm, 'Errore interno');
                return ko;
            when others then
                PKG_MCRE0_AUDIT.log_etl ('5_5 - PKG_MCRE0_TWS ERROR - LIVELLO_5 GRUPPO_5', PKG_MCRE0_AUDIT.C_ERROR, sqlcode, sqlerrm, 'Errore generico');
                        return ko;
       end TWS_MCRE0_LIVELLO5_G05;

    FUNCTION TWS_MCRE0_LIVELLO5_G06 return number IS
        BEGIN
            select SEQ_MCR0_LOG_ETL.nextval into seq from dual;
            PKG_MCRE0_AUDIT.log_etl (seq, '5_6 - PKG_MCRE0_TWS - INI - LIVELLO5_G6', PKG_MCRE0_AUDIT.C_DEBUG, sqlcode, 'INIZIO', 'INIZIO');
            esito:=0;
--            PKG_MCRE0_AUDIT.log_etl (seq,'5_6 - ETL2 - INI - FNC_VERIFICA_ALERT_BLOCCO 3', PKG_MCRE0_AUDIT.C_DEBUG, sqlcode, 'INIZIO', 'INIZIO - FNC_VERIFICA_ALERT_BLOCCO 3.');
--            RetVal := MCRE_OWN.PKG_MCRE0_ALERT3.FNC_VERIFICA_ALERT_BLOCCO ( seq, 3 );
--            PKG_MCRE0_AUDIT.log_etl (seq,'5_6 - ETL2 - END - FNC_VERIFICA_ALERT_BLOCCO 3', PKG_MCRE0_AUDIT.C_DEBUG, sqlcode, 'Esito '||RETVAL, 'FINE - FNC_VERIFICA_ALERT_BLOCCO 3.');
            /***** VG: Reload Gruppo 2 nuova gestione alert *****/
            PKG_MCRE0_AUDIT.log_etl (seq,'5_6 - ETL2 - FNC_BATCH_ALERT_GRUPPO_2', PKG_MCRE0_AUDIT.C_DEBUG, sqlcode, 'INIZIO', 'INIZIO - FNC_BATCH_ALERT_GRUPPO_2.');
            RetVal := MCRE_OWN.PKG_MCRE0_ALERT.FNC_BATCH_ALERT_GRUPPO_2(seq);
            PKG_MCRE0_AUDIT.log_etl (seq,'5_6 - ETL2 - FNC_BATCH_ALERT_GRUPPO_2', PKG_MCRE0_AUDIT.C_DEBUG, sqlcode, 'Esito '||RETVAL, 'FINE - FNC_BATCH_ALERT_GRUPPO_2.');
            if (RetVal = 0) then
                raise eccezione_interna;
            end if;
            PKG_MCRE0_AUDIT.log_etl (seq, '5_6 - PKG_MCRE0_TWS - END - LIVELLO5_G6', PKG_MCRE0_AUDIT.C_DEBUG, sqlcode, 'FINE', 'FINE');
            return ok;
        exception
            when eccezione_interna then
                PKG_MCRE0_AUDIT.log_etl ('5_6 - PKG_MCRE0_TWS ERROR - LIVELLO_5 GRUPPO_6', PKG_MCRE0_AUDIT.C_ERROR, sqlcode, sqlerrm, 'Errore interno');
                return ko;
            when others then
                PKG_MCRE0_AUDIT.log_etl ('5_6 - PKG_MCRE0_TWS ERROR - LIVELLO_5 GRUPPO_6', PKG_MCRE0_AUDIT.C_ERROR, sqlcode, sqlerrm, 'Errore generico');
                        return ko;
        end TWS_MCRE0_LIVELLO5_G06;

    FUNCTION TWS_MCRE0_LIVELLO5_G07 return number IS
        BEGIN
            select SEQ_MCR0_LOG_ETL.nextval into seq from dual;
            PKG_MCRE0_AUDIT.log_etl (seq, '5_7 - PKG_MCRE0_TWS - INI - LIVELLO5_G7', PKG_MCRE0_AUDIT.C_DEBUG, sqlcode, 'INIZIO', 'INIZIO');
            esito:=0;
            /***** VG: Reload Gruppo 1 nuova gestione alert *****/
            PKG_MCRE0_AUDIT.log_etl (seq,'5_7 - ETL2 - FNC_BATCH_ALERT_GRUPPO_3', PKG_MCRE0_AUDIT.C_DEBUG, sqlcode, 'INIZIO', 'INIZIO - FNC_BATCH_ALERT_GRUPPO_3.');
            RetVal := MCRE_OWN.PKG_MCRE0_ALERT.FNC_BATCH_ALERT_GRUPPO_3(seq);
            PKG_MCRE0_AUDIT.log_etl (seq,'5_7 - ETL2 - FNC_BATCH_ALERT_GRUPPO_3', PKG_MCRE0_AUDIT.C_DEBUG, sqlcode, 'Esito '||RETVAL, 'FINE - FNC_BATCH_ALERT_GRUPPO_3.');
            if (RetVal = 0) then
                raise eccezione_interna;
            end if;
--            PKG_MCRE0_AUDIT.log_etl (seq,'5_7 - ETL2 - INI - FNC_VERIFICA_ALERT_BLOCCO 5', PKG_MCRE0_AUDIT.C_DEBUG, sqlcode, 'INIZIO', 'INIZIO - FNC_VERIFICA_ALERT_BLOCCO 5.');
--            RetVal := MCRE_OWN.PKG_MCRE0_ALERT3.FNC_VERIFICA_ALERT_BLOCCO ( seq, 5 );
--            PKG_MCRE0_AUDIT.log_etl (seq,'5_7 - ETL2 - END - FNC_VERIFICA_ALERT_BLOCCO 5', PKG_MCRE0_AUDIT.C_DEBUG, sqlcode, 'Esito '||RETVAL, 'FINE - FNC_VERIFICA_ALERT_BLOCCO 5.');
--            if (RetVal = 0) then
--                raise eccezione_interna;
--            end if;
            PKG_MCRE0_AUDIT.log_etl (seq, '5_7 - PKG_MCRE0_TWS - END - LIVELLO5_G7', PKG_MCRE0_AUDIT.C_DEBUG, sqlcode, 'FINE', 'FINE');
            return ok;
        exception
            when eccezione_interna then
                PKG_MCRE0_AUDIT.log_etl ('5_7 - PKG_MCRE0_TWS ERROR - LIVELLO_5 GRUPPO_7', PKG_MCRE0_AUDIT.C_ERROR, sqlcode, sqlerrm, 'Errore interno');
                return ko;
            when others then
                PKG_MCRE0_AUDIT.log_etl ('5_7 - PKG_MCRE0_TWS ERROR - LIVELLO_5 GRUPPO_7', PKG_MCRE0_AUDIT.C_ERROR, sqlcode, sqlerrm, 'Errore generico');
                        return ko;
        end TWS_MCRE0_LIVELLO5_G07;

    FUNCTION TWS_MCRE0_LIVELLO5_G08 return number IS
        BEGIN
            select SEQ_MCR0_LOG_ETL.nextval into seq from dual;
            PKG_MCRE0_AUDIT.log_etl (seq, '5_8 - PKG_MCRE0_TWS - INI - LIVELLO5_G8', PKG_MCRE0_AUDIT.C_DEBUG, sqlcode, 'INIZIO', 'INIZIO');
            esito:=0;
            /***** VG: Reload Gruppo 4 nuova gestione alert *****/
            PKG_MCRE0_AUDIT.log_etl (seq,'5_8 - ETL2 - FNC_BATCH_ALERT_GRUPPO_4', PKG_MCRE0_AUDIT.C_DEBUG, sqlcode, 'INIZIO', 'INIZIO - FNC_BATCH_ALERT_GRUPPO_4.');
            RetVal := MCRE_OWN.PKG_MCRE0_ALERT.FNC_BATCH_ALERT_GRUPPO_4(seq);
            PKG_MCRE0_AUDIT.log_etl (seq,'5_8 - ETL2 - FNC_BATCH_ALERT_GRUPPO_4', PKG_MCRE0_AUDIT.C_DEBUG, sqlcode, 'Esito '||RETVAL, 'FINE - FNC_BATCH_ALERT_GRUPPO_4.');
            if (RetVal = 0) then
                raise eccezione_interna;
            end if;
--            PKG_MCRE0_AUDIT.log_etl (seq,'5_8 - ETL2 - INI - FNC_VERIFICA_ALERT_BLOCCO 6', PKG_MCRE0_AUDIT.C_DEBUG, sqlcode, 'INIZIO', 'INIZIO - FNC_VERIFICA_ALERT_BLOCCO 6.');
--            RetVal := MCRE_OWN.PKG_MCRE0_ALERT3.FNC_VERIFICA_ALERT_BLOCCO ( seq, 6 );
--            PKG_MCRE0_AUDIT.log_etl (seq,'5_8 - ETL2 - END - FNC_VERIFICA_ALERT_BLOCCO 6', PKG_MCRE0_AUDIT.C_DEBUG, sqlcode, 'Esito '||RETVAL, 'FINE - FNC_VERIFICA_ALERT_BLOCCO 6.');
--            if (RetVal = 0) then
--                raise eccezione_interna;
--            end if;
--            PKG_MCRE0_AUDIT.log_etl (seq,'5_8 - ETL2 - INI - FNC_VERIFICA_ALERT_BLOCCO 7', PKG_MCRE0_AUDIT.C_DEBUG, sqlcode, 'INIZIO', 'INIZIO - FNC_VERIFICA_ALERT_BLOCCO 7.');
--            RetVal := MCRE_OWN.PKG_MCRE0_ALERT3.FNC_VERIFICA_ALERT_BLOCCO ( seq, 7 );
--            PKG_MCRE0_AUDIT.log_etl (seq,'5_8 - ETL2 - END - FNC_VERIFICA_ALERT_BLOCCO 7', PKG_MCRE0_AUDIT.C_DEBUG, sqlcode, 'Esito '||RETVAL, 'FINE - FNC_VERIFICA_ALERT_BLOCCO 7.');
--            if (RetVal = 0) then
--                raise eccezione_interna;
--            end if;
            PKG_MCRE0_AUDIT.log_etl (seq, '5_8 - PKG_MCRE0_TWS - END - LIVELLO5_G8', PKG_MCRE0_AUDIT.C_DEBUG, sqlcode, 'FINE', 'FINE');
            return ok;
        exception
            when eccezione_interna then
                PKG_MCRE0_AUDIT.log_etl ('5_8 - PKG_MCRE0_TWS ERROR - LIVELLO_5 GRUPPO_8', PKG_MCRE0_AUDIT.C_ERROR, sqlcode, sqlerrm, 'Errore interno');
                return ko;
            when others then
                PKG_MCRE0_AUDIT.log_etl ('5_8 - PKG_MCRE0_TWS ERROR - LIVELLO_5 GRUPPO_8', PKG_MCRE0_AUDIT.C_ERROR, sqlcode, sqlerrm, 'Errore generico');
                        return ko;
        end TWS_MCRE0_LIVELLO5_G08;

    FUNCTION TWS_MCRE0_LIVELLO5_G09 return number IS
        v_new_per date;
        v_last_period date;
        v_last_month number;

         BEGIN
            select SEQ_MCR0_LOG_ETL.nextval into seq from dual;
            PKG_MCRE0_AUDIT.log_etl (seq, '5_9 - PKG_MCRE0_TWS - INI - LIVELLO5_G9', PKG_MCRE0_AUDIT.C_DEBUG, sqlcode, 'INIZIO', 'INIZIO');
             v_last_month := 0;
             select (max(PERIODO_RIFERIMENTO))
             into v_new_per
             FROM T_MCRE0_WRK_ACQUISIZIONE
             where PERIODO_RIFERIMENTO = (SELECT MAX(PERIODO_RIFERIMENTO) FROM V_MCRE0_ULTIMA_ACQUISIZIONE);

             select (max(PERIODO_RIFERIMENTO))
             into v_last_period
             FROM T_MCRE0_WRK_ACQUISIZIONE
             where PERIODO_RIFERIMENTO < v_new_per;

             if extract (month from v_last_period) <>  extract (month from v_new_per) then
                v_last_month:= TO_NUMBER(TO_CHAR(v_last_period, 'yyyymmdd'));
             end if;

            IF (v_last_month <> 0) THEN
                PKG_MCRE0_AUDIT.log_etl (seq, '5_9 - PKG_MCRE0_TWS - INI - Aggiorna POS_STATO_STORICO aggiornamento effettuato', PKG_MCRE0_AUDIT.C_DEBUG, sqlcode, 'INIZIO', 'INIZIO - Aggiorna POS_STATO_STORICO aggiornamento effettuato');
                RETVAL := MCRE_OWN.PKG_MCRE0_AGGIORNA_MV.aggiorna_pos_stato_st;
                PKG_MCRE0_AUDIT.log_etl (seq, '5_9 - PKG_MCRE0_TWS - END - Aggiorna POS_STATO_STORICO aggiornamento effettuato', PKG_MCRE0_AUDIT.C_DEBUG, sqlcode, 'Esito '||RETVAL, 'FINE - Aggiorna POS_STATO_STORICO aggiornamento effettuato');
                if (RetVal = 0) then
                raise eccezione_interna;
            end if;
            END IF;
--            PKG_MCRE0_AUDIT.log_etl (seq,'5_9 - ETL2 - FNC_VERIFICA_ALERT_BLOCCO 8', PKG_MCRE0_AUDIT.C_DEBUG, sqlcode, 'INIZIO', 'INIZIO - FNC_VERIFICA_ALERT_BLOCCO 8.');
--            RetVal := MCRE_OWN.PKG_MCRE0_ALERT3.FNC_VERIFICA_ALERT_BLOCCO ( seq, 8 );
--            PKG_MCRE0_AUDIT.log_etl (seq,'5_9 - ETL2 - FNC_VERIFICA_ALERT_BLOCCO 8', PKG_MCRE0_AUDIT.C_DEBUG, sqlcode, 'Esito '||RETVAL, 'FINE - FNC_VERIFICA_ALERT_BLOCCO 8.');
--            if (RetVal = 0) then
--                raise eccezione_interna;
--            end if;
            PKG_MCRE0_AUDIT.log_etl (seq, '5_9 - PKG_MCRE0_TWS - END - LIVELLO5_G9', PKG_MCRE0_AUDIT.C_DEBUG, sqlcode, 'FINE', 'FINE');
            return ok;
        exception
            when eccezione_interna then
                PKG_MCRE0_AUDIT.log_etl ('5_9 - PKG_MCRE0_TWS ERROR - LIVELLO_5 GRUPPO_9', PKG_MCRE0_AUDIT.C_ERROR, sqlcode, sqlerrm, 'Errore interno');
                return ko;
            when others then
                PKG_MCRE0_AUDIT.log_etl ('5_9 - PKG_MCRE0_TWS ERROR - LIVELLO_5 GRUPPO_9', PKG_MCRE0_AUDIT.C_ERROR, sqlcode, sqlerrm, 'Errore generico');
                        return ko;
        end TWS_MCRE0_LIVELLO5_G09;

    FUNCTION TWS_MCRE0_LIVELLO5_G10 return number IS

        BEGIN
        select SEQ_MCR0_LOG_ETL.nextval into seq from dual;
            PKG_MCRE0_AUDIT.log_etl (seq, '5_10 - PKG_MCRE0_TWS - INI - LIVELLO5_G10', PKG_MCRE0_AUDIT.C_DEBUG, sqlcode, 'INIZIO', 'INIZIO');
            esito:=0;

            PKG_MCRE0_AUDIT.log_etl (seq, '5_10 FILL_ALL_DATA_DAY - INI', PKG_MCRE0_AUDIT.C_DEBUG, sqlcode, 'INIZIO', 'INIZIO - FILL_ALL_DATA_DAY');
            RetVal := MCRE_OWN.PKG_MCRE0_TWS.TWS_MCRE0_FILL_ALL_DATA_DAY;
            PKG_MCRE0_AUDIT.log_etl (seq, '5_10 FILL_ALL_DATA_DAY - END', PKG_MCRE0_AUDIT.C_DEBUG, sqlcode, 'Esito '||RetVal, 'FINE - FILL_ALL_DATA_DAY');

            PKG_MCRE0_AUDIT.log_etl (seq, '5_10 APRI_PORTALE - INI', PKG_MCRE0_AUDIT.C_DEBUG, sqlcode, 'INIZIO', 'INIZIO - APRI_PORTALE');
            RetVal := MCRE_OWN.PKG_MCRE0_TWS.TWS_MCRE0_APRI_PORTALE;
            PKG_MCRE0_AUDIT.log_etl (seq, '5_10 APRI_PORTALE - END', PKG_MCRE0_AUDIT.C_DEBUG, sqlcode, 'Esito '||RetVal, 'FINE - APRI_PORTALE');

            --V3.18 UPDATE TEMPORANEO FLG_OUTSOURCING SOFF sull abase delle pratiche soff (aggiungere vioncolo?)
            PKG_MCRE0_AUDIT.log_etl (seq, '5_10 Ricalcolo Soff - INI', PKG_MCRE0_AUDIT.C_DEBUG, sqlcode, 'INIZIO', 'INIZIO - Ricalcolo Soff');
            begin
            merge into t_mcre0_app_all_data d
            using (
            select      a.cod_abi_cartolarizzato, a.cod_ndg,
                            CASE
                                 WHEN a.cod_stato = 'SO'
                                    THEN DECODE (b.cod_livello,
                                                 'PL', 'N',
                                                 'IP', 'N',
                                                 'IC', 'N',
                                                 'RC', 'N',
                                                 c.FLG_OUTSOURCING
                                                )
                                 ELSE c.FLG_OUTSOURCING
                            END  FLG_OUTSOURCING, a.FLG_OUTSOURCING flg_orig
                FROM        T_MCRE0_app_all_data a,
                            T_MCRE0_APP_STRUTTURA_ORG b,
                            MV_MCRE0_APP_ISTITUTI c, t_mcres_app_pratiche p
                where       a.COD_ABI_CARTOLARIZZATO = b.COD_ABI_ISTITUTO
               -- and         a.COD_STRUTTURA_COMPETENTE = b.COD_STRUTTURA_COMPETENTE
                and         p.COD_UO_PRATICA = b.COD_STRUTTURA_COMPETENTE
                and         c.COD_ABI = a.COD_ABI_CARTOLARIZZATO
                and today_flg = '1'
                and a.cod_stato = 'SO'
                and a.COD_ABI_CARTOLARIZZATO = p.cod_abi
                and a.cod_ndg = p.cod_ndg
                and p.flg_attiva = 1
              ) soff
             on (d.cod_abi_cartolarizzato = soff.cod_abi_cartolarizzato and d.cod_ndg = soff.cod_ndg and soff.FLG_ORIG != soff.FLG_OUTSOURCING)
             when matched then update
             set d.FLG_OUTSOURCING = soff.FLG_OUTSOURCING;
             commit;
            PKG_MCRE0_AUDIT.log_etl (seq, '5_10 Ricalcolo Soff - END', PKG_MCRE0_AUDIT.C_DEBUG, sqlcode, 'Esito ok', 'FINE  Ricalcolo Soff');
            exception when others then
            rollback;
            PKG_MCRE0_AUDIT.log_etl (seq, '5_10 Ricalcolo Soff - END', PKG_MCRE0_AUDIT.C_ERROR, sqlcode, 'Esito KO', 'FINE  Ricalcolo Soff');
            end;

--            select SEQ_MCR0_LOG_ETL.nextval into seq from dual;
--            id_alert:=10;
--            PKG_MCRE0_AUDIT.log_etl (seq, '5_0'||id_alert||' - PKG_MCRE0_TWS - LIVELLO5_G0'||id_alert, PKG_MCRE0_AUDIT.C_DEBUG, sqlcode, 'INIZIO', 'INIZIO');
--            esito:=0;
--            PKG_MCRE0_AUDIT.log_etl (seq, '5_0'||id_alert||' - PKG_MCRE0_TWS', PKG_MCRE0_AUDIT.C_DEBUG, sqlcode, 'INIZIO', 'INIZIO - Calcolo Alert '||id_alert);
--            RETVAL := MCRE_OWN.PKG_MCRE0_ALERT3.FNC_VERIFICA_ALERT_ID (seq,ID_ALERT);
--            PKG_MCRE0_AUDIT.log_etl (seq, '5_0'||id_alert||' - PKG_MCRE0_TWS', PKG_MCRE0_AUDIT.C_DEBUG, sqlcode, 'Esito '||RetVal, 'FINE - Calcolo Alert '||id_alert);
--            ESITO := ESITO+RETVAL;

--            PKG_MCRE0_AUDIT.log_etl (seq, '5_0'||id_alert||' - PKG_MCRE0_TWS - LIVELLO5_G0'||id_alert, PKG_MCRE0_AUDIT.C_DEBUG, sqlcode, 'FINE', 'FINE');
            return ok;
        EXCEPTION
                when eccezione_interna then
                PKG_MCRE0_AUDIT.log_etl ('5_10 - PKG_MCRE0_TWS ERROR - LIVELLO_5 GRUPPO_10', PKG_MCRE0_AUDIT.C_ERROR, sqlcode, sqlerrm, 'Errore interno');
                return ko;
                 WHEN OTHERS THEN
         PKG_MCRE0_AUDIT.log_etl ('5_10 - PKG_MCRE0_TWS ERROR - LIVELLO_5 GRUPPO_10', PKG_MCRE0_AUDIT.C_ERROR, sqlcode, sqlerrm, 'Errore generico');
--        PKG_MCRE0_AUDIT.log_etl ('5_0'||id_alert||' - PKG_MCRE0_TWS ERROR - LIVELLO_5 GRUPPO_0'||id_alert, PKG_MCRE0_AUDIT.C_ERROR, sqlcode, sqlerrm, 'Errore in ERROR - LIVELLO_5 GRUPPO_0'||id_alert);
            return ko;
        END TWS_MCRE0_LIVELLO5_G10;

    FUNCTION TWS_MCRE0_LIVELLO5_G11 return number IS
        BEGIN
            select SEQ_MCR0_LOG_ETL.nextval into seq from dual;
            PKG_MCRE0_AUDIT.log_etl (seq, '5_11 - INIZIO ALERT MCREI', PKG_MCRE0_AUDIT.C_DEBUG, sqlcode, 'INIZIO', 'LOG');
            COMMIT;
            return ok;
        EXCEPTION WHEN OTHERS THEN
            PKG_MCRE0_AUDIT.log_etl ('5_11 - PKG_MCRE0_TWS ERROR - LIVELLO_5 GRUPPO_11', PKG_MCRE0_AUDIT.C_ERROR, sqlcode, sqlerrm, 'Errore generico');
            return ko;
        END TWS_MCRE0_LIVELLO5_G11;

    FUNCTION TWS_MCRE0_LIVELLO5_G12 return number IS
        BEGIN
            select SEQ_MCR0_LOG_ETL.nextval into seq from dual;
            PKG_MCRE0_AUDIT.log_etl (seq, '5_12 - INIZIO CALCOLO BLOCCO 1', PKG_MCRE0_AUDIT.C_DEBUG, sqlcode, 'INIZIO', 'INIZIO - Calcolo BLOCCO 1');
            RetVal := PKG_MCREI_ALERT_2.FNC_MCREI_CALCOLO_BLOCCO(1);
            PKG_MCRE0_AUDIT.log_etl (seq, '5_12 - FINE CALCOLO BLOCCO 1', PKG_MCRE0_AUDIT.C_DEBUG, sqlcode, 'Esito '||RetVal, 'FINE - Calcolo BLOCCO 1');
            COMMIT;
            return ok;

        EXCEPTION WHEN OTHERS THEN
        PKG_MCRE0_AUDIT.log_etl ('5_12 - PKG_MCRE0_TWS ERROR - LIVELLO_5 GRUPPO_12', PKG_MCRE0_AUDIT.C_ERROR, sqlcode, sqlerrm, 'Errore generico');
            return ko;
        END TWS_MCRE0_LIVELLO5_G12;

    FUNCTION TWS_MCRE0_LIVELLO5_G13 return number IS
        BEGIN
            select SEQ_MCR0_LOG_ETL.nextval into seq from dual;
            PKG_MCRE0_AUDIT.log_etl (seq, '5_13 - INIZIO CALCOLO BLOCCO 2', PKG_MCRE0_AUDIT.C_DEBUG, sqlcode, 'INIZIO', 'INIZIO - Calcolo BLOCCO 2');
            RetVal := PKG_MCREI_ALERT_2.FNC_MCREI_CALCOLO_BLOCCO(2);
            PKG_MCRE0_AUDIT.log_etl (seq, '5_13 - FINE CALCOLO BLOCCO 2', PKG_MCRE0_AUDIT.C_DEBUG, sqlcode, 'Esito '||RetVal, 'FINE - Calcolo BLOCCO 2');
            COMMIT;
            return ok;

        EXCEPTION WHEN OTHERS THEN
        PKG_MCRE0_AUDIT.log_etl ('5_13 - PKG_MCRE0_TWS ERROR - LIVELLO_5 GRUPPO_13', PKG_MCRE0_AUDIT.C_ERROR, sqlcode, sqlerrm, 'Errore generico');
            return ko;
        END TWS_MCRE0_LIVELLO5_G13;

    FUNCTION TWS_MCRE0_LIVELLO5_G14 return number IS
        BEGIN
            select SEQ_MCR0_LOG_ETL.nextval into seq from dual;
            PKG_MCRE0_AUDIT.log_etl (seq, '5_14 - INIZIO CALCOLO BLOCCO 3', PKG_MCRE0_AUDIT.C_DEBUG, sqlcode, 'INIZIO', 'INIZIO - Calcolo BLOCCO 3');
            RetVal := PKG_MCREI_ALERT_2.FNC_MCREI_CALCOLO_BLOCCO(3);
            PKG_MCRE0_AUDIT.log_etl (seq, '5_14 - FINE CALCOLO BLOCCO 3', PKG_MCRE0_AUDIT.C_DEBUG, sqlcode, 'Esito '||RetVal, 'FINE - Calcolo BLOCCO 3');
            COMMIT;
            return ok;

        EXCEPTION WHEN OTHERS THEN
        PKG_MCRE0_AUDIT.log_etl ('5_14 - PKG_MCRE0_TWS ERROR - LIVELLO_5 GRUPPO_14', PKG_MCRE0_AUDIT.C_ERROR, sqlcode, sqlerrm, 'Errore generico');
            return ko;
        END TWS_MCRE0_LIVELLO5_G14;

    FUNCTION TWS_MCRE0_LIVELLO5_G15 return number IS
        BEGIN
            select SEQ_MCR0_LOG_ETL.nextval into seq from dual;
            PKG_MCRE0_AUDIT.log_etl (seq, '5_15 - INIZIO CALCOLO BLOCCO 4', PKG_MCRE0_AUDIT.C_DEBUG, sqlcode, 'INIZIO', 'INIZIO - Calcolo BLOCCO 4');
            RetVal := PKG_MCREI_ALERT_2.FNC_MCREI_CALCOLO_BLOCCO(4);
            PKG_MCRE0_AUDIT.log_etl (seq, '5_15 - FINE CALCOLO BLOCCO 4', PKG_MCRE0_AUDIT.C_DEBUG, sqlcode, 'Esito '||RetVal, 'FINE - Calcolo BLOCCO 4');
            COMMIT;
            return ok;

        EXCEPTION WHEN OTHERS THEN
        PKG_MCRE0_AUDIT.log_etl ('5_15 - PKG_MCRE0_TWS ERROR - LIVELLO_5 GRUPPO_15', PKG_MCRE0_AUDIT.C_ERROR, sqlcode, sqlerrm, 'Errore generico');
            return ko;
        END TWS_MCRE0_LIVELLO5_G15;

    FUNCTION TWS_MCRE0_LIVELLO5_G16 return number IS
        BEGIN
            select SEQ_MCR0_LOG_ETL.nextval into seq from dual;
            PKG_MCRE0_AUDIT.log_etl (seq, '5_16 - INIZIO CALCOLO BLOCCO 5', PKG_MCRE0_AUDIT.C_DEBUG, sqlcode, 'INIZIO', 'INIZIO - Calcolo BLOCCO 5');
            RetVal := PKG_MCREI_ALERT_2.FNC_MCREI_CALCOLO_BLOCCO(5);
            PKG_MCRE0_AUDIT.log_etl (seq, '5_16 - FINE CALCOLO BLOCCO 5', PKG_MCRE0_AUDIT.C_DEBUG, sqlcode, 'Esito '||RetVal, 'FINE - Calcolo BLOCCO 5');
            COMMIT;
            return ok;

        EXCEPTION WHEN OTHERS THEN
        PKG_MCRE0_AUDIT.log_etl ('5_16 - PKG_MCRE0_TWS ERROR - LIVELLO_5 GRUPPO_16', PKG_MCRE0_AUDIT.C_ERROR, sqlcode, sqlerrm, 'Errore generico');
            return ko;
        END TWS_MCRE0_LIVELLO5_G16;

    FUNCTION TWS_MCRE0_LIVELLO5_G17 return number IS
        BEGIN
--            select SEQ_MCR0_LOG_ETL.nextval into seq from dual;
--            id_alert:=17;
--            PKG_MCRE0_AUDIT.log_etl (seq, '5_0'||id_alert||' - PKG_MCRE0_TWS - LIVELLO5_G0'||id_alert, PKG_MCRE0_AUDIT.C_DEBUG, sqlcode, 'INIZIO', 'INIZIO');
--            esito:=0;
--            PKG_MCRE0_AUDIT.log_etl (seq, '5_0'||id_alert||' - PKG_MCRE0_TWS', PKG_MCRE0_AUDIT.C_DEBUG, sqlcode, 'INIZIO', 'INIZIO - Calcolo Alert '||id_alert);
--            RETVAL := MCRE_OWN.PKG_MCRE0_ALERT3.FNC_VERIFICA_ALERT_ID (seq,ID_ALERT);
--            PKG_MCRE0_AUDIT.log_etl (seq, '5_0'||id_alert||' - PKG_MCRE0_TWS', PKG_MCRE0_AUDIT.C_DEBUG, sqlcode, 'Esito '||RetVal, 'FINE - Calcolo Alert '||id_alert);
--            ESITO := ESITO+RETVAL;

--            PKG_MCRE0_AUDIT.log_etl (seq, '5_0'||id_alert||' - PKG_MCRE0_TWS - LIVELLO5_G0'||id_alert, PKG_MCRE0_AUDIT.C_DEBUG, sqlcode, 'FINE', 'FINE');
            return ok;
        EXCEPTION WHEN OTHERS THEN
--        PKG_MCRE0_AUDIT.log_etl ('5_0'||id_alert||' - PKG_MCRE0_TWS ERROR - LIVELLO_5 GRUPPO_0'||id_alert, PKG_MCRE0_AUDIT.C_ERROR, sqlcode, sqlerrm, 'Errore in ERROR - LIVELLO_5 GRUPPO_0'||id_alert);
            return ko;
        END TWS_MCRE0_LIVELLO5_G17;

    FUNCTION TWS_MCRE0_LIVELLO5_G18 return number IS
        BEGIN
--            select SEQ_MCR0_LOG_ETL.nextval into seq from dual;
--            id_alert:=18;
--            PKG_MCRE0_AUDIT.log_etl (seq, '5_0'||id_alert||' - PKG_MCRE0_TWS - LIVELLO5_G0'||id_alert, PKG_MCRE0_AUDIT.C_DEBUG, sqlcode, 'INIZIO', 'INIZIO');
--            esito:=0;
--            PKG_MCRE0_AUDIT.log_etl (seq, '5_0'||id_alert||' - PKG_MCRE0_TWS', PKG_MCRE0_AUDIT.C_DEBUG, sqlcode, 'INIZIO', 'INIZIO - Calcolo Alert '||id_alert);
--            RETVAL := MCRE_OWN.PKG_MCRE0_ALERT3.FNC_VERIFICA_ALERT_ID (seq,ID_ALERT);
--            PKG_MCRE0_AUDIT.log_etl (seq, '5_0'||id_alert||' - PKG_MCRE0_TWS', PKG_MCRE0_AUDIT.C_DEBUG, sqlcode, 'Esito '||RetVal, 'FINE - Calcolo Alert '||id_alert);
--            ESITO := ESITO+RETVAL;

--            PKG_MCRE0_AUDIT.log_etl (seq, '5_0'||id_alert||' - PKG_MCRE0_TWS - LIVELLO5_G0'||id_alert, PKG_MCRE0_AUDIT.C_DEBUG, sqlcode, 'FINE', 'FINE');
            return ok;
        EXCEPTION WHEN OTHERS THEN
--        PKG_MCRE0_AUDIT.log_etl ('5_0'||id_alert||' - PKG_MCRE0_TWS ERROR - LIVELLO_5 GRUPPO_0'||id_alert, PKG_MCRE0_AUDIT.C_ERROR, sqlcode, sqlerrm, 'Errore in ERROR - LIVELLO_5 GRUPPO_0'||id_alert);
            return ko;
        END TWS_MCRE0_LIVELLO5_G18;

    FUNCTION TWS_MCRE0_LIVELLO5_G19 return number IS
        BEGIN
--            select SEQ_MCR0_LOG_ETL.nextval into seq from dual;
--            id_alert:=19;
--            PKG_MCRE0_AUDIT.log_etl (seq, '5_0'||id_alert||' - PKG_MCRE0_TWS - LIVELLO5_G0'||id_alert, PKG_MCRE0_AUDIT.C_DEBUG, sqlcode, 'INIZIO', 'INIZIO');
--            esito:=0;
--            PKG_MCRE0_AUDIT.log_etl (seq, '5_0'||id_alert||' - PKG_MCRE0_TWS', PKG_MCRE0_AUDIT.C_DEBUG, sqlcode, 'INIZIO', 'INIZIO - Calcolo Alert '||id_alert);
--            RETVAL := MCRE_OWN.PKG_MCRE0_ALERT3.FNC_VERIFICA_ALERT_ID (seq,ID_ALERT);
--            PKG_MCRE0_AUDIT.log_etl (seq, '5_0'||id_alert||' - PKG_MCRE0_TWS', PKG_MCRE0_AUDIT.C_DEBUG, sqlcode, 'Esito '||RetVal, 'FINE - Calcolo Alert '||id_alert);
--            ESITO := ESITO+RETVAL;

--            PKG_MCRE0_AUDIT.log_etl (seq, '5_0'||id_alert||' - PKG_MCRE0_TWS - LIVELLO5_G0'||id_alert, PKG_MCRE0_AUDIT.C_DEBUG, sqlcode, 'FINE', 'FINE');
            return ok;
        EXCEPTION WHEN OTHERS THEN
--        PKG_MCRE0_AUDIT.log_etl ('5_0'||id_alert||' - PKG_MCRE0_TWS ERROR - LIVELLO_5 GRUPPO_0'||id_alert, PKG_MCRE0_AUDIT.C_ERROR, sqlcode, sqlerrm, 'Errore in ERROR - LIVELLO_5 GRUPPO_0'||id_alert);
            return ko;
        END TWS_MCRE0_LIVELLO5_G19;

    FUNCTION TWS_MCRE0_LIVELLO5_G20 return number IS
        BEGIN
--            select SEQ_MCR0_LOG_ETL.nextval into seq from dual;
--            id_alert:=20;
--            PKG_MCRE0_AUDIT.log_etl (seq, '5_0'||id_alert||' - PKG_MCRE0_TWS - LIVELLO5_G0'||id_alert, PKG_MCRE0_AUDIT.C_DEBUG, sqlcode, 'INIZIO', 'INIZIO');
--            esito:=0;
--            PKG_MCRE0_AUDIT.log_etl (seq, '5_0'||id_alert||' - PKG_MCRE0_TWS', PKG_MCRE0_AUDIT.C_DEBUG, sqlcode, 'INIZIO', 'INIZIO - Calcolo Alert '||id_alert);
--            RETVAL := MCRE_OWN.PKG_MCRE0_ALERT3.FNC_VERIFICA_ALERT_ID (seq,ID_ALERT);
--            PKG_MCRE0_AUDIT.log_etl (seq, '5_0'||id_alert||' - PKG_MCRE0_TWS', PKG_MCRE0_AUDIT.C_DEBUG, sqlcode, 'Esito '||RetVal, 'FINE - Calcolo Alert '||id_alert);
--            ESITO := ESITO+RETVAL;

--            PKG_MCRE0_AUDIT.log_etl (seq, '5_0'||id_alert||' - PKG_MCRE0_TWS - LIVELLO5_G0'||id_alert, PKG_MCRE0_AUDIT.C_DEBUG, sqlcode, 'FINE', 'FINE');
            return ok;
        EXCEPTION WHEN OTHERS THEN
--        PKG_MCRE0_AUDIT.log_etl ('5_0'||id_alert||' - PKG_MCRE0_TWS ERROR - LIVELLO_5 GRUPPO_0'||id_alert, PKG_MCRE0_AUDIT.C_ERROR, sqlcode, sqlerrm, 'Errore in ERROR - LIVELLO_5 GRUPPO_0'||id_alert);
            return ko;
        END TWS_MCRE0_LIVELLO5_G20;

    FUNCTION TWS_MCRE0_LIVELLO5_G21 return number IS
        BEGIN
--            select SEQ_MCR0_LOG_ETL.nextval into seq from dual;
--            id_alert:=21;
--            PKG_MCRE0_AUDIT.log_etl (seq, '5_0'||id_alert||' - PKG_MCRE0_TWS - LIVELLO5_G0'||id_alert, PKG_MCRE0_AUDIT.C_DEBUG, sqlcode, 'INIZIO', 'INIZIO');
--            esito:=0;
--            PKG_MCRE0_AUDIT.log_etl (seq, '5_0'||id_alert||' - PKG_MCRE0_TWS', PKG_MCRE0_AUDIT.C_DEBUG, sqlcode, 'INIZIO', 'INIZIO - Calcolo Alert '||id_alert);
--            RETVAL := MCRE_OWN.PKG_MCRE0_ALERT3.FNC_VERIFICA_ALERT_ID (seq,ID_ALERT);
--            PKG_MCRE0_AUDIT.log_etl (seq, '5_0'||id_alert||' - PKG_MCRE0_TWS', PKG_MCRE0_AUDIT.C_DEBUG, sqlcode, 'Esito '||RetVal, 'FINE - Calcolo Alert '||id_alert);
--            ESITO := ESITO+RETVAL;

--            PKG_MCRE0_AUDIT.log_etl (seq, '5_0'||id_alert||' - PKG_MCRE0_TWS - LIVELLO5_G0'||id_alert, PKG_MCRE0_AUDIT.C_DEBUG, sqlcode, 'FINE', 'FINE');
            return ok;
        EXCEPTION WHEN OTHERS THEN
--        PKG_MCRE0_AUDIT.log_etl ('5_0'||id_alert||' - PKG_MCRE0_TWS ERROR - LIVELLO_5 GRUPPO_0'||id_alert, PKG_MCRE0_AUDIT.C_ERROR, sqlcode, sqlerrm, 'Errore in ERROR - LIVELLO_5 GRUPPO_0'||id_alert);
            return ko;
        END TWS_MCRE0_LIVELLO5_G21;

    FUNCTION TWS_MCRE0_LIVELLO5_G22 return number IS
        BEGIN
--            select SEQ_MCR0_LOG_ETL.nextval into seq from dual;
--            id_alert:=22;
--            PKG_MCRE0_AUDIT.log_etl (seq, '5_0'||id_alert||' - PKG_MCRE0_TWS - LIVELLO5_G0'||id_alert, PKG_MCRE0_AUDIT.C_DEBUG, sqlcode, 'INIZIO', 'INIZIO');
--            esito:=0;
--            PKG_MCRE0_AUDIT.log_etl (seq, '5_0'||id_alert||' - PKG_MCRE0_TWS', PKG_MCRE0_AUDIT.C_DEBUG, sqlcode, 'INIZIO', 'INIZIO - Calcolo Alert '||id_alert);
--            RETVAL := MCRE_OWN.PKG_MCRE0_ALERT3.FNC_VERIFICA_ALERT_ID (seq,ID_ALERT);
--            PKG_MCRE0_AUDIT.log_etl (seq, '5_0'||id_alert||' - PKG_MCRE0_TWS', PKG_MCRE0_AUDIT.C_DEBUG, sqlcode, 'Esito '||RetVal, 'FINE - Calcolo Alert '||id_alert);
--            ESITO := ESITO+RETVAL;

--            PKG_MCRE0_AUDIT.log_etl (seq, '5_0'||id_alert||' - PKG_MCRE0_TWS - LIVELLO5_G0'||id_alert, PKG_MCRE0_AUDIT.C_DEBUG, sqlcode, 'FINE', 'FINE');
            return ok;
        EXCEPTION WHEN OTHERS THEN
--        PKG_MCRE0_AUDIT.log_etl ('5_0'||id_alert||' - PKG_MCRE0_TWS ERROR - LIVELLO_5 GRUPPO_0'||id_alert, PKG_MCRE0_AUDIT.C_ERROR, sqlcode, sqlerrm, 'Errore in ERROR - LIVELLO_5 GRUPPO_0'||id_alert);
            return ko;
        END TWS_MCRE0_LIVELLO5_G22;

    FUNCTION TWS_MCRE0_LIVELLO5_G23 return number IS
        BEGIN
--            select SEQ_MCR0_LOG_ETL.nextval into seq from dual;
--            id_alert:=23;
--            PKG_MCRE0_AUDIT.log_etl (seq, '5_0'||id_alert||' - PKG_MCRE0_TWS - LIVELLO5_G0'||id_alert, PKG_MCRE0_AUDIT.C_DEBUG, sqlcode, 'INIZIO', 'INIZIO');
--            esito:=0;
--            PKG_MCRE0_AUDIT.log_etl (seq, '5_0'||id_alert||' - PKG_MCRE0_TWS', PKG_MCRE0_AUDIT.C_DEBUG, sqlcode, 'INIZIO', 'INIZIO - Calcolo Alert '||id_alert);
--            RETVAL := MCRE_OWN.PKG_MCRE0_ALERT3.FNC_VERIFICA_ALERT_ID (seq,ID_ALERT);
--            PKG_MCRE0_AUDIT.log_etl (seq, '5_0'||id_alert||' - PKG_MCRE0_TWS', PKG_MCRE0_AUDIT.C_DEBUG, sqlcode, 'Esito '||RetVal, 'FINE - Calcolo Alert '||id_alert);
--            ESITO := ESITO+RETVAL;

--            PKG_MCRE0_AUDIT.log_etl (seq, '5_0'||id_alert||' - PKG_MCRE0_TWS - LIVELLO5_G0'||id_alert, PKG_MCRE0_AUDIT.C_DEBUG, sqlcode, 'FINE', 'FINE');
            return ok;
        EXCEPTION WHEN OTHERS THEN
--        PKG_MCRE0_AUDIT.log_etl ('5_0'||id_alert||' - PKG_MCRE0_TWS ERROR - LIVELLO_5 GRUPPO_0'||id_alert, PKG_MCRE0_AUDIT.C_ERROR, sqlcode, sqlerrm, 'Errore in ERROR - LIVELLO_5 GRUPPO_0'||id_alert);
            return ko;
        END TWS_MCRE0_LIVELLO5_G23;

    FUNCTION TWS_MCRE0_LIVELLO5_G24 return number IS
        BEGIN
--            select SEQ_MCR0_LOG_ETL.nextval into seq from dual;
--            id_alert:=24;
--            PKG_MCRE0_AUDIT.log_etl (seq, '5_0'||id_alert||' - PKG_MCRE0_TWS - LIVELLO5_G0'||id_alert, PKG_MCRE0_AUDIT.C_DEBUG, sqlcode, 'INIZIO', 'INIZIO');
--            esito:=0;
--            PKG_MCRE0_AUDIT.log_etl (seq, '5_0'||id_alert||' - PKG_MCRE0_TWS', PKG_MCRE0_AUDIT.C_DEBUG, sqlcode, 'INIZIO', 'INIZIO - Calcolo Alert '||id_alert);
--            RETVAL := MCRE_OWN.PKG_MCRE0_ALERT3.FNC_VERIFICA_ALERT_ID (seq,ID_ALERT);
--            PKG_MCRE0_AUDIT.log_etl (seq, '5_0'||id_alert||' - PKG_MCRE0_TWS', PKG_MCRE0_AUDIT.C_DEBUG, sqlcode, 'Esito '||RetVal, 'FINE - Calcolo Alert '||id_alert);
--            ESITO := ESITO+RETVAL;

--            PKG_MCRE0_AUDIT.log_etl (seq, '5_0'||id_alert||' - PKG_MCRE0_TWS - LIVELLO5_G0'||id_alert, PKG_MCRE0_AUDIT.C_DEBUG, sqlcode, 'FINE', 'FINE');
            return ok;
        EXCEPTION WHEN OTHERS THEN
--        PKG_MCRE0_AUDIT.log_etl ('5_0'||id_alert||' - PKG_MCRE0_TWS ERROR - LIVELLO_5 GRUPPO_0'||id_alert, PKG_MCRE0_AUDIT.C_ERROR, sqlcode, sqlerrm, 'Errore in ERROR - LIVELLO_5 GRUPPO_0'||id_alert);
            return ko;
        END TWS_MCRE0_LIVELLO5_G24;

    FUNCTION TWS_MCRE0_LIVELLO5_G25 return number IS
        BEGIN
--            select SEQ_MCR0_LOG_ETL.nextval into seq from dual;
--            id_alert:=25;
--            PKG_MCRE0_AUDIT.log_etl (seq, '5_0'||id_alert||' - PKG_MCRE0_TWS - LIVELLO5_G0'||id_alert, PKG_MCRE0_AUDIT.C_DEBUG, sqlcode, 'INIZIO', 'INIZIO');
--            esito:=0;
--            PKG_MCRE0_AUDIT.log_etl (seq, '5_0'||id_alert||' - PKG_MCRE0_TWS', PKG_MCRE0_AUDIT.C_DEBUG, sqlcode, 'INIZIO', 'INIZIO - Calcolo Alert '||id_alert);
--            RETVAL := MCRE_OWN.PKG_MCRE0_ALERT3.FNC_VERIFICA_ALERT_ID (seq,ID_ALERT);
--            PKG_MCRE0_AUDIT.log_etl (seq, '5_0'||id_alert||' - PKG_MCRE0_TWS', PKG_MCRE0_AUDIT.C_DEBUG, sqlcode, 'Esito '||RetVal, 'FINE - Calcolo Alert '||id_alert);
--            ESITO := ESITO+RETVAL;

--            PKG_MCRE0_AUDIT.log_etl (seq, '5_0'||id_alert||' - PKG_MCRE0_TWS - LIVELLO5_G0'||id_alert, PKG_MCRE0_AUDIT.C_DEBUG, sqlcode, 'FINE', 'FINE');
            return ok;
        EXCEPTION WHEN OTHERS THEN
--        PKG_MCRE0_AUDIT.log_etl ('5_0'||id_alert||' - PKG_MCRE0_TWS ERROR - LIVELLO_5 GRUPPO_0'||id_alert, PKG_MCRE0_AUDIT.C_ERROR, sqlcode, sqlerrm, 'Errore in ERROR - LIVELLO_5 GRUPPO_0'||id_alert);
            return ko;
        END TWS_MCRE0_LIVELLO5_G25;

    FUNCTION TWS_MCRE0_LIVELLO5_G26 return number IS
        BEGIN
--            select SEQ_MCR0_LOG_ETL.nextval into seq from dual;
--            PKG_MCRE0_AUDIT.log_etl (seq, '5_26 - PKG_MCRE0_TWS - LIVELLO5_G26', PKG_MCRE0_AUDIT.C_DEBUG, sqlcode, 'INIZIO', 'INIZIO');
--            esito:=0;
--            PKG_MCRE0_AUDIT.log_etl (seq, '5_26 - PKG_MCRE0_TWS - Aggiorna Uscite in seguito ai caricamenti', PKG_MCRE0_AUDIT.C_DEBUG, sqlcode, '0', 'INIZIO');
--            RETVAL := MCRE_OWN.PKG_MCRE0_AGGIORNA_MV2.AGGIORNA_USCITE(seq);
--            PKG_MCRE0_AUDIT.log_etl (seq, '5_26 - PKG_MCRE0_TWS - Aggiorna Uscite in seguito ai caricamenti', PKG_MCRE0_AUDIT.C_DEBUG, sqlcode, 'Esito '||RetVal, 'FINE');
--            ESITO := ESITO+RETVAL;

--            PKG_MCRE0_AUDIT.log_etl (seq, '5_26 - PKG_MCRE0_TWS - LIVELLO5_G26', PKG_MCRE0_AUDIT.C_DEBUG, sqlcode, 'FINE', 'FINE');
            return ok;
        EXCEPTION WHEN OTHERS THEN
--        PKG_MCRE0_AUDIT.log_etl ('5_26 - PKG_MCRE0_TWS ERROR - LIVELLO_5 GRUPPO_26', PKG_MCRE0_AUDIT.C_ERROR, sqlcode, sqlerrm, 'Errore in ERROR - LIVELLO_5 GRUPPO_26');
            return ko;
        END TWS_MCRE0_LIVELLO5_G26;

    FUNCTION TWS_MCRE0_LIVELLO5_G27 return number IS
        BEGIN
--            select SEQ_MCR0_LOG_ETL.nextval into seq from dual;
--            PKG_MCRE0_AUDIT.log_etl (seq, '5_27 - PKG_MCRE0_TWS - LIVELLO5_G27', PKG_MCRE0_AUDIT.C_DEBUG, sqlcode, '0', 'INIZIO');
--            esito:=0;
--            PKG_MCRE0_AUDIT.log_etl (seq,'5_27 - ETL2 - AGGIORNA MV', PKG_MCRE0_AUDIT.C_DEBUG, sqlcode, '0', 'INIZIO - eseguito Aggiorna CR.');
--            RETVAL := MCRE_OWN.PKG_MCRE0_AGGIORNA_MV.AGGIORNA_CR_ALL(seq);
--            PKG_MCRE0_AUDIT.log_etl (seq,'5_27 - ETL2 - AGGIORNA MV', PKG_MCRE0_AUDIT.C_DEBUG, sqlcode, 'Esito '||RetVal, 'FINE - eseguito Aggiorna CR.');
--            ESITO := ESITO+RETVAL;

--            PKG_MCRE0_AUDIT.log_etl (seq, '5_27 - PKG_MCRE0_TWS - LIVELLO5_G27', PKG_MCRE0_AUDIT.C_DEBUG, sqlcode, '0', 'FINE');
            return ok;
        EXCEPTION WHEN OTHERS THEN
--        PKG_MCRE0_AUDIT.log_etl ('5_27 - PKG_MCRE0_TWS ERROR - LIVELLO_5 GRUPPO_27', PKG_MCRE0_AUDIT.C_ERROR, sqlcode, sqlerrm, 'Errore in ERROR - LIVELLO_5 GRUPPO_27');
            return ko;
        END TWS_MCRE0_LIVELLO5_G27;

    FUNCTION TWS_MCRE0_LIVELLO5_G28 return number IS
        BEGIN
--            select SEQ_MCR0_LOG_ETL.nextval into seq from dual;
--            PKG_MCRE0_AUDIT.log_etl (seq, '5_28 - PKG_MCRE0_TWS - LIVELLO5_G28', PKG_MCRE0_AUDIT.C_DEBUG, sqlcode, 'INIZIO', 'INIZIO');
--            esito:=0;
--            PKG_MCRE0_AUDIT.log_etl (seq, '5_28 - PKG_MCRE0_TWS - Aggiorna Rio Monit.', PKG_MCRE0_AUDIT.C_DEBUG, sqlcode, '0', 'INIZIO - Aggiorna Rio Monit. in seguito ai caricamenti');
--            RETVAL := MCRE_OWN.PKG_MCRE0_AGGIORNA_MV.aggiorna_RIO_MONITORAGGIO(seq);
--            PKG_MCRE0_AUDIT.log_etl (seq, '5_28 - PKG_MCRE0_TWS - Aggiorna Rio Monit.', PKG_MCRE0_AUDIT.C_DEBUG, sqlcode, 'Esito '||RetVal, 'FINE - Aggiorna Rio Monit. in seguito ai caricamenti');
--            ESITO := ESITO+RETVAL;

--            PKG_MCRE0_AUDIT.log_etl (seq, '5_28 - PKG_MCRE0_TWS - END - LIVELLO5_G28', PKG_MCRE0_AUDIT.C_DEBUG, sqlcode, 'FINE', 'FINE');
            return ok;
        EXCEPTION WHEN OTHERS THEN
--        PKG_MCRE0_AUDIT.log_etl ('5_28 - PKG_MCRE0_TWS ERROR - LIVELLO_5 GRUPPO_28', PKG_MCRE0_AUDIT.C_ERROR, sqlcode, sqlerrm, 'Errore in ERROR - LIVELLO_5 GRUPPO_28');
            return ko;
        END TWS_MCRE0_LIVELLO5_G28;

    FUNCTION TWS_MCRE0_LIVELLO5_G29 return number IS
        BEGIN
--            select SEQ_MCR0_LOG_ETL.nextval into seq from dual;
--            PKG_MCRE0_AUDIT.log_etl (seq, '5_29 - PKG_MCRE0_TWS - LIVELLO5_G29', PKG_MCRE0_AUDIT.C_DEBUG, sqlcode, 'INIZIO', 'INIZIO');
--            esito:=0;
--            PKG_MCRE0_AUDIT.log_etl (seq, '5_29 - PKG_MCRE0_TWS - Aggiorna Rio Esp', PKG_MCRE0_AUDIT.C_DEBUG, sqlcode, '0', 'INIZIO - Aggiorna Rio Esp in seguito ai caricamenti');
--            RETVAL := MCRE_OWN.PKG_MCRE0_AGGIORNA_MV2.aggiorna_RIO_ESP(seq);
--            PKG_MCRE0_AUDIT.log_etl (seq, '5_29 - PKG_MCRE0_TWS - Aggiorna Rio Esp', PKG_MCRE0_AUDIT.C_DEBUG, sqlcode, 'Esito '||RetVal, 'FINE - Aggiorna Rio Esp in seguito ai caricamenti');
--            ESITO := ESITO+RETVAL;

--            PKG_MCRE0_AUDIT.log_etl (seq, '5_29 - PKG_MCRE0_TWS - LIVELLO5_G29', PKG_MCRE0_AUDIT.C_DEBUG, sqlcode, 'FINE', 'FINE');
            return ok;
        EXCEPTION WHEN OTHERS THEN
--        PKG_MCRE0_AUDIT.log_etl ('5_29 - PKG_MCRE0_TWS ERROR - LIVELLO_5 GRUPPO_29', PKG_MCRE0_AUDIT.C_ERROR, sqlcode, sqlerrm, 'Errore in ERROR - LIVELLO_5 GRUPPO_29');
            return ko;
        END TWS_MCRE0_LIVELLO5_G29;

    FUNCTION TWS_MCRE0_LIVELLO5_G30 return number IS
        BEGIN
--            select SEQ_MCR0_LOG_ETL.nextval into seq from dual;
--            PKG_MCRE0_AUDIT.log_etl (seq, '5_30 - PKG_MCRE0_TWS - LIVELLO5_G30', PKG_MCRE0_AUDIT.C_DEBUG, sqlcode, 'INIZIO', 'INIZIO');
--            esito:=0;
--            PKG_MCRE0_AUDIT.log_etl (seq, '5_30 - PKG_MCRE0_TWS - Aggiorna Rio Esp Ann', PKG_MCRE0_AUDIT.C_DEBUG, sqlcode, '0', 'INIZIO - Aggiorna Esp Ann in seguito ai caricamenti');
--            RETVAL := MCRE_OWN.PKG_MCRE0_AGGIORNA_MV2.aggiorna_RIO_ESP_ANN(seq);
--            PKG_MCRE0_AUDIT.log_etl (seq, '5_30 - PKG_MCRE0_TWS - Aggiorna Rio Esp Ann', PKG_MCRE0_AUDIT.C_DEBUG, sqlcode, 'Esito '||RetVal, 'FINE - Aggiorna Esp Ann in seguito ai caricamenti');
--            ESITO := ESITO+RETVAL;

--            PKG_MCRE0_AUDIT.log_etl (seq, '5_30 - PKG_MCRE0_TWS - END - LIVELLO5_G30', PKG_MCRE0_AUDIT.C_DEBUG, sqlcode, 'FINE', 'FINE');
            return ok;
        EXCEPTION WHEN OTHERS THEN
--        PKG_MCRE0_AUDIT.log_etl ('5_30 - PKG_MCRE0_TWS ERROR - LIVELLO_5 GRUPPO_30', PKG_MCRE0_AUDIT.C_ERROR, sqlcode, sqlerrm, 'Errore in ERROR - LIVELLO_5 GRUPPO_30');
            return ko;
        END TWS_MCRE0_LIVELLO5_G30;

    FUNCTION TWS_MCRE0_LIVELLO5_G31 return number IS

--        v_new_per date;
--        v_last_period date;
--        v_last_month number;

        BEGIN
--            select SEQ_MCR0_LOG_ETL.nextval into seq from dual;
--            PKG_MCRE0_AUDIT.log_etl (seq, '5_31 - PKG_MCRE0_TWS - LIVELLO5_G31', PKG_MCRE0_AUDIT.C_DEBUG, sqlcode, 'INIZIO', 'INIZIO');
--            esito:=0;
--            v_last_month := 0;
--             select (max(PERIODO_RIFERIMENTO))
--             into v_new_per
--             FROM T_MCRE0_WRK_ACQUISIZIONE
--             where PERIODO_RIFERIMENTO = (SELECT MAX(PERIODO_RIFERIMENTO) FROM V_MCRE0_ULTIMA_ACQUISIZIONE);

--             select (max(PERIODO_RIFERIMENTO))
--             into v_last_period
--             FROM T_MCRE0_WRK_ACQUISIZIONE
--             where PERIODO_RIFERIMENTO < v_new_per;

--             if extract (month from v_last_period) <>  extract (month from v_new_per) then
--                v_last_month:= TO_NUMBER(TO_CHAR(v_last_period, 'yyyymmdd'));
--             end if;

--            IF (v_last_month <> 0) THEN
--                PKG_MCRE0_AUDIT.log_etl (seq, '5_31 - PKG_MCRE0_TWS - Aggiorna POS_STATO_STORICO aggiornamento effettuato', PKG_MCRE0_AUDIT.C_DEBUG, sqlcode, '0', 'INIZIO - Aggiorna POS_STATO_STORICO aggiornamento effettuato');
--                RETVAL := MCRE_OWN.PKG_MCRE0_AGGIORNA_MV.aggiorna_pos_stato_st;
--                PKG_MCRE0_AUDIT.log_etl (seq, '5_31 - PKG_MCRE0_TWS - Aggiorna POS_STATO_STORICO aggiornamento effettuato', PKG_MCRE0_AUDIT.C_DEBUG, sqlcode, 'Esito '||RETVAL, 'FINE - Aggiorna POS_STATO_STORICO aggiornamento effettuato');
--                ESITO := ESITO+RETVAL;
--            END IF;
--            ESITO := ESITO+RETVAL;

--            PKG_MCRE0_AUDIT.log_etl (seq, '5_31 - PKG_MCRE0_TWS - LIVELLO5_G31', PKG_MCRE0_AUDIT.C_DEBUG, sqlcode, 'FINE', 'FINE');
            return ok;
        EXCEPTION WHEN OTHERS THEN
--        PKG_MCRE0_AUDIT.log_etl ('5_31 - PKG_MCRE0_TWS ERROR - LIVELLO_5 GRUPPO_31', PKG_MCRE0_AUDIT.C_ERROR, sqlcode, sqlerrm, 'Errore in ERROR - LIVELLO_5 GRUPPO_31');
            return ko;
        END TWS_MCRE0_LIVELLO5_G31;



    FUNCTION TWS_MCRE0_LIVELLO5_G1 return number IS
        BEGIN
            select SEQ_MCR0_LOG_ETL.nextval into seq from dual;
            PKG_MCRE0_AUDIT.log_etl (seq, '5_1 - PKG_MCRE0_TWS - INI - LIVELLO5_G1', PKG_MCRE0_AUDIT.C_DEBUG, sqlcode, 'INIZIO', 'INIZIO');
            esito:=0;
            PKG_MCRE0_AUDIT.log_etl (seq, '5_1 - PKG_MCRE0_TWS - INI - Aggiorna Uscite in seguito ai caricamenti', PKG_MCRE0_AUDIT.C_DEBUG, sqlcode, 'INIZIO', 'INIZIO - Aggiorna Uscite in seguito ai caricamenti');
            RETVAL := MCRE_OWN.PKG_MCRE0_AGGIORNA_MV2.AGGIORNA_USCITE(seq);
            PKG_MCRE0_AUDIT.log_etl (seq, '5_1 - PKG_MCRE0_TWS - END - Aggiorna Uscite in seguito ai caricamenti', PKG_MCRE0_AUDIT.C_DEBUG, sqlcode, 'Esito '||RetVal, 'FINE - Aggiorna Uscite in seguito ai caricamenti');
            if (RetVal = 0) then
                raise eccezione_interna;
            end if;

            PKG_MCRE0_AUDIT.log_etl (seq, '5_1 - PKG_MCRE0_TWS - END - LIVELLO5_G1', PKG_MCRE0_AUDIT.C_DEBUG, sqlcode, 'FINE', 'FINE');
            return ok;
        exception
            when eccezione_interna then
                PKG_MCRE0_AUDIT.log_etl ('5_1 - PKG_MCRE0_TWS ERROR - LIVELLO_5 GRUPPO_1', PKG_MCRE0_AUDIT.C_ERROR, sqlcode, sqlerrm, 'Errore interno');
                return ko;
            when others then
                PKG_MCRE0_AUDIT.log_etl ('5_1 - PKG_MCRE0_TWS ERROR - LIVELLO_5 GRUPPO_1', PKG_MCRE0_AUDIT.C_ERROR, sqlcode, sqlerrm, 'Errore generico');
                        return ko;
        end TWS_MCRE0_LIVELLO5_G1;


    FUNCTION TWS_MCRE0_LIVELLO5_G2 return number IS
         BEGIN
            select SEQ_MCR0_LOG_ETL.nextval into seq from dual;
            PKG_MCRE0_AUDIT.log_etl (seq, '5_2 - PKG_MCRE0_TWS - INI - LIVELLO5_G2', PKG_MCRE0_AUDIT.C_DEBUG, sqlcode, 'INIZIO', 'INIZIO');
            esito:=0;
            PKG_MCRE0_AUDIT.log_etl (seq, '5_2 - PKG_MCRE0_TWS - INI - Aggiorna Rio Monit. in seguito ai caricamenti', PKG_MCRE0_AUDIT.C_DEBUG, sqlcode, 'Esito 1', 'INIZIO - Aggiorna Rio Monit. in seguito ai caricamenti');
            RETVAL := MCRE_OWN.PKG_MCRE0_AGGIORNA_MV.aggiorna_RIO_MONITORAGGIO(seq);
            PKG_MCRE0_AUDIT.log_etl (seq, '5_2 - PKG_MCRE0_TWS - END - Aggiorna Rio Monit. in seguito ai caricamenti', PKG_MCRE0_AUDIT.C_DEBUG, sqlcode, 'Esito '||RetVal, 'FINE - Aggiorna Rio Monit. in seguito ai caricamenti');
            if (RetVal = 0) then
                raise eccezione_interna;
            end if;
            -- MV CR
            PKG_MCRE0_AUDIT.log_etl (seq,'5_2 - ETL2 - INI - AGGIORNA MV', PKG_MCRE0_AUDIT.C_DEBUG, sqlcode, 'INIZIO', 'INIZIO - eseguito Aggiorna CR.');
            RETVAL := MCRE_OWN.PKG_MCRE0_AGGIORNA_MV.AGGIORNA_CR_ALL(seq);
            PKG_MCRE0_AUDIT.log_etl (seq,'5_2 - ETL2 - END - AGGIORNA MV', PKG_MCRE0_AUDIT.C_DEBUG, sqlcode, 'Esito '||RetVal, 'FINE - eseguito Aggiorna CR.');
            if (RetVal = 0) then
                raise eccezione_interna;
            end if;
            PKG_MCRE0_AUDIT.log_etl (seq,'5_2 - ETL2 - FNC_VERIFICA_ALERT_BLOCCO 9', PKG_MCRE0_AUDIT.C_DEBUG, sqlcode, 'INIZIO', 'INIZIO - FNC_VERIFICA_ALERT_BLOCCO 9.');
            RetVal := MCRE_OWN.PKG_MCRE0_ALERT3.FNC_VERIFICA_ALERT_BLOCCO ( seq, 9 );
            PKG_MCRE0_AUDIT.log_etl (seq,'5_2 - ETL2 - FNC_VERIFICA_ALERT_BLOCCO 9', PKG_MCRE0_AUDIT.C_DEBUG, sqlcode, 'Esito '||RETVAL, 'FINE - FNC_VERIFICA_ALERT_BLOCCO 9.');
            if (RetVal = 0) then
                raise eccezione_interna;
            end if;
            PKG_MCRE0_AUDIT.log_etl (seq, '5_2 - PKG_MCRE0_TWS - END - LIVELLO5_G2', PKG_MCRE0_AUDIT.C_DEBUG, sqlcode, 'FINE', 'FINE');
                        return ok;
        exception
            when eccezione_interna then
                PKG_MCRE0_AUDIT.log_etl ('5_2 - PKG_MCRE0_TWS ERROR - LIVELLO_5 GRUPPO_2', PKG_MCRE0_AUDIT.C_ERROR, sqlcode, sqlerrm, 'Errore interno');
                return ko;
            when others then
                PKG_MCRE0_AUDIT.log_etl ('5_2 - PKG_MCRE0_TWS ERROR - LIVELLO_5 GRUPPO_2', PKG_MCRE0_AUDIT.C_ERROR, sqlcode, sqlerrm, 'Errore generico');
                        return ko;
        end TWS_MCRE0_LIVELLO5_G2;

    FUNCTION TWS_MCRE0_LIVELLO5_G3 return number IS
         BEGIN
            select SEQ_MCR0_LOG_ETL.nextval into seq from dual;
            PKG_MCRE0_AUDIT.log_etl (seq, '5_3 - PKG_MCRE0_TWS - INI - LIVELLO5_G3', PKG_MCRE0_AUDIT.C_DEBUG, sqlcode, 'INIZIO', 'INIZIO');
            esito:=0;
            PKG_MCRE0_AUDIT.log_etl (seq, '5_3 - PKG_MCRE0_TWS - INI - Aggiorna Rio ESP GE e SC in seguito ai caricamenti', PKG_MCRE0_AUDIT.C_DEBUG, sqlcode, 'INIZIO', 'INIZIO - Aggiorna Rio ESP GE e SC in seguito ai caricamenti');
            RETVAL := MCRE_OWN.PKG_MCRE0_AGGIORNA_MV2.aggiorna_RIO_ESP(seq);
            PKG_MCRE0_AUDIT.log_etl (seq, '5_3 - PKG_MCRE0_TWS - END - Aggiorna Rio ESP GE e SC in seguito ai caricamenti', PKG_MCRE0_AUDIT.C_DEBUG, sqlcode, 'Esito '||RetVal, 'FINE - Aggiorna Rio ESP GE e SC in seguito ai caricamenti');
            if (RetVal = 0) then
                raise eccezione_interna;
            end if;
            PKG_MCRE0_AUDIT.log_etl (seq, '5_3 - PKG_MCRE0_TWS - END - LIVELLO5_G3', PKG_MCRE0_AUDIT.C_DEBUG, sqlcode, 'FINE', 'FINE');
            return ok;
        exception
            when eccezione_interna then
                PKG_MCRE0_AUDIT.log_etl ('5_3 - PKG_MCRE0_TWS ERROR - LIVELLO_5 GRUPPO_3', PKG_MCRE0_AUDIT.C_ERROR, sqlcode, sqlerrm, 'Errore interno');
                return ko;
            when others then
                PKG_MCRE0_AUDIT.log_etl ('5_3 - PKG_MCRE0_TWS ERROR - LIVELLO_5 GRUPPO_3', PKG_MCRE0_AUDIT.C_ERROR, sqlcode, sqlerrm, 'Errore generico');
                        return ko;
        end TWS_MCRE0_LIVELLO5_G3;

    FUNCTION TWS_MCRE0_LIVELLO5_G4 return number IS
         BEGIN
            select SEQ_MCR0_LOG_ETL.nextval into seq from dual;
            PKG_MCRE0_AUDIT.log_etl (seq, '5_4 - PKG_MCRE0_TWS - INI - LIVELLO5_G4', PKG_MCRE0_AUDIT.C_DEBUG, sqlcode, 'INIZIO', 'INIZIO');
            esito:=0;
            PKG_MCRE0_AUDIT.log_etl (seq,'5_4 - ETL2 - INI - FNC_VERIFICA_ALERT_BLOCCO 1', PKG_MCRE0_AUDIT.C_DEBUG, sqlcode, 'INIZIO', 'INIZIO - FNC_VERIFICA_ALERT_BLOCCO 1.');
            RetVal := MCRE_OWN.PKG_MCRE0_ALERT3.FNC_VERIFICA_ALERT_BLOCCO ( seq, 1 );
            PKG_MCRE0_AUDIT.log_etl (seq,'5_4 - ETL2 - END - FNC_VERIFICA_ALERT_BLOCCO 1', PKG_MCRE0_AUDIT.C_DEBUG, sqlcode, 'Esito '||RETVAL, 'FINE - FNC_VERIFICA_ALERT_BLOCCO 1.');
            if (RetVal = 0) then
                raise eccezione_interna;
            end if;
            PKG_MCRE0_AUDIT.log_etl (seq, '5_4 - PKG_MCRE0_TWS - END - LIVELLO5_G4', PKG_MCRE0_AUDIT.C_DEBUG, sqlcode, 'FINE', 'FINE');
            return ok;
        exception
            when eccezione_interna then
                PKG_MCRE0_AUDIT.log_etl ('5_4 - PKG_MCRE0_TWS ERROR - LIVELLO_5 GRUPPO_4', PKG_MCRE0_AUDIT.C_ERROR, sqlcode, sqlerrm, 'Errore interno');
                return ko;
            when others then
                PKG_MCRE0_AUDIT.log_etl ('5_4 - PKG_MCRE0_TWS ERROR - LIVELLO_5 GRUPPO_4', PKG_MCRE0_AUDIT.C_ERROR, sqlcode, sqlerrm, 'Errore generico');
                        return ko;
        end TWS_MCRE0_LIVELLO5_G4;

    FUNCTION TWS_MCRE0_LIVELLO5_G5 return number IS
         BEGIN
            select SEQ_MCR0_LOG_ETL.nextval into seq from dual;
            PKG_MCRE0_AUDIT.log_etl (seq, '5_5 - PKG_MCRE0_TWS - INI - LIVELLO5_G5', PKG_MCRE0_AUDIT.C_DEBUG, sqlcode, 'INIZIO', 'INIZIO');
            esito:=0;
            PKG_MCRE0_AUDIT.log_etl (seq, '5_5 - PKG_MCRE0_TWS - INI - Aggiorna Rio ESP Ann in seguito ai caricamenti', PKG_MCRE0_AUDIT.C_DEBUG, sqlcode, 'INIZIO', 'INIZIO - Aggiorna Rio ESP Ann in seguito ai caricamenti');
            RETVAL := MCRE_OWN.PKG_MCRE0_AGGIORNA_MV2.aggiorna_RIO_ESP_ANN(seq);
            PKG_MCRE0_AUDIT.log_etl (seq, '5_5 - PKG_MCRE0_TWS - END - Aggiorna Rio ESP Ann in seguito ai caricamenti', PKG_MCRE0_AUDIT.C_DEBUG, sqlcode, 'Esito '||RetVal, 'FINE - Aggiorna Rio ESP Ann in seguito ai caricamenti');
            if (RetVal = 0) then
                raise eccezione_interna;
            end if;
            PKG_MCRE0_AUDIT.log_etl (seq,'5_5 - ETL2 - INI - FNC_VERIFICA_ALERT_BLOCCO 2', PKG_MCRE0_AUDIT.C_DEBUG, sqlcode, 'INIZIO', 'INIZIO - FNC_VERIFICA_ALERT_BLOCCO 2.');
            RetVal := MCRE_OWN.PKG_MCRE0_ALERT3.FNC_VERIFICA_ALERT_BLOCCO ( seq, 2 );
            PKG_MCRE0_AUDIT.log_etl (seq,'5_5 - ETL2 - END - FNC_VERIFICA_ALERT_BLOCCO 2', PKG_MCRE0_AUDIT.C_DEBUG, sqlcode, 'Esito '||RETVAL, 'FINE - FNC_VERIFICA_ALERT_BLOCCO 2.');
            if (RetVal = 0) then
                raise eccezione_interna;
            end if;
            PKG_MCRE0_AUDIT.log_etl (seq,'5_5 - ETL2 - INI - FNC_VERIFICA_ALERT_BLOCCO 4', PKG_MCRE0_AUDIT.C_DEBUG, sqlcode, 'INIZIO', 'INIZIO - FNC_VERIFICA_ALERT_BLOCCO 4.');
            RetVal := MCRE_OWN.PKG_MCRE0_ALERT3.FNC_VERIFICA_ALERT_BLOCCO ( seq, 4 );
            PKG_MCRE0_AUDIT.log_etl (seq,'5_5 - ETL2 - END - FNC_VERIFICA_ALERT_BLOCCO 4', PKG_MCRE0_AUDIT.C_DEBUG, sqlcode, 'Esito '||RETVAL, 'FINE - FNC_VERIFICA_ALERT_BLOCCO 4.');
            if (RetVal = 0) then
                raise eccezione_interna;
            end if;
            PKG_MCRE0_AUDIT.log_etl (seq, '5_5 - PKG_MCRE0_TWS - END - LIVELLO5_G5', PKG_MCRE0_AUDIT.C_DEBUG, sqlcode, 'FINE', 'FINE');
            return ok;
        exception
            when eccezione_interna then
                PKG_MCRE0_AUDIT.log_etl ('5_5 - PKG_MCRE0_TWS ERROR - LIVELLO_5 GRUPPO_5', PKG_MCRE0_AUDIT.C_ERROR, sqlcode, sqlerrm, 'Errore interno');
                return ko;
            when others then
                PKG_MCRE0_AUDIT.log_etl ('5_5 - PKG_MCRE0_TWS ERROR - LIVELLO_5 GRUPPO_5', PKG_MCRE0_AUDIT.C_ERROR, sqlcode, sqlerrm, 'Errore generico');
                        return ko;
        end TWS_MCRE0_LIVELLO5_G5;

    FUNCTION TWS_MCRE0_LIVELLO5_G6 return number IS
         BEGIN
            select SEQ_MCR0_LOG_ETL.nextval into seq from dual;
            PKG_MCRE0_AUDIT.log_etl (seq, '5_6 - PKG_MCRE0_TWS - INI - LIVELLO5_G6', PKG_MCRE0_AUDIT.C_DEBUG, sqlcode, 'INIZIO', 'INIZIO');
            esito:=0;
            PKG_MCRE0_AUDIT.log_etl (seq,'5_6 - ETL2 - INI - FNC_VERIFICA_ALERT_BLOCCO 3', PKG_MCRE0_AUDIT.C_DEBUG, sqlcode, 'INIZIO', 'INIZIO - FNC_VERIFICA_ALERT_BLOCCO 3.');
            RetVal := MCRE_OWN.PKG_MCRE0_ALERT3.FNC_VERIFICA_ALERT_BLOCCO ( seq, 3 );
            PKG_MCRE0_AUDIT.log_etl (seq,'5_6 - ETL2 - END - FNC_VERIFICA_ALERT_BLOCCO 3', PKG_MCRE0_AUDIT.C_DEBUG, sqlcode, 'Esito '||RETVAL, 'FINE - FNC_VERIFICA_ALERT_BLOCCO 3.');
            if (RetVal = 0) then
                raise eccezione_interna;
            end if;
            PKG_MCRE0_AUDIT.log_etl (seq, '5_6 - PKG_MCRE0_TWS - END - LIVELLO5_G6', PKG_MCRE0_AUDIT.C_DEBUG, sqlcode, 'FINE', 'FINE');
            return ok;
        exception
            when eccezione_interna then
                PKG_MCRE0_AUDIT.log_etl ('5_6 - PKG_MCRE0_TWS ERROR - LIVELLO_5 GRUPPO_6', PKG_MCRE0_AUDIT.C_ERROR, sqlcode, sqlerrm, 'Errore interno');
                return ko;
            when others then
                PKG_MCRE0_AUDIT.log_etl ('5_6 - PKG_MCRE0_TWS ERROR - LIVELLO_5 GRUPPO_6', PKG_MCRE0_AUDIT.C_ERROR, sqlcode, sqlerrm, 'Errore generico');
                        return ko;
        end TWS_MCRE0_LIVELLO5_G6;

    FUNCTION TWS_MCRE0_LIVELLO5_G7 return number IS
         BEGIN
            select SEQ_MCR0_LOG_ETL.nextval into seq from dual;
            PKG_MCRE0_AUDIT.log_etl (seq, '5_7 - PKG_MCRE0_TWS - INI - LIVELLO5_G7', PKG_MCRE0_AUDIT.C_DEBUG, sqlcode, 'INIZIO', 'INIZIO');
            esito:=0;
            PKG_MCRE0_AUDIT.log_etl (seq,'5_7 - ETL2 - INI - FNC_VERIFICA_ALERT_BLOCCO 5', PKG_MCRE0_AUDIT.C_DEBUG, sqlcode, 'INIZIO', 'INIZIO - FNC_VERIFICA_ALERT_BLOCCO 5.');
            RetVal := MCRE_OWN.PKG_MCRE0_ALERT3.FNC_VERIFICA_ALERT_BLOCCO ( seq, 5 );
            PKG_MCRE0_AUDIT.log_etl (seq,'5_7 - ETL2 - END - FNC_VERIFICA_ALERT_BLOCCO 5', PKG_MCRE0_AUDIT.C_DEBUG, sqlcode, 'Esito '||RETVAL, 'FINE - FNC_VERIFICA_ALERT_BLOCCO 5.');
            if (RetVal = 0) then
                raise eccezione_interna;
            end if;
            PKG_MCRE0_AUDIT.log_etl (seq, '5_7 - PKG_MCRE0_TWS - END - LIVELLO5_G7', PKG_MCRE0_AUDIT.C_DEBUG, sqlcode, 'FINE', 'FINE');
            return ok;
        exception
            when eccezione_interna then
                PKG_MCRE0_AUDIT.log_etl ('5_7 - PKG_MCRE0_TWS ERROR - LIVELLO_5 GRUPPO_7', PKG_MCRE0_AUDIT.C_ERROR, sqlcode, sqlerrm, 'Errore interno');
                return ko;
            when others then
                PKG_MCRE0_AUDIT.log_etl ('5_7 - PKG_MCRE0_TWS ERROR - LIVELLO_5 GRUPPO_7', PKG_MCRE0_AUDIT.C_ERROR, sqlcode, sqlerrm, 'Errore generico');
                        return ko;
        end TWS_MCRE0_LIVELLO5_G7;

    FUNCTION TWS_MCRE0_LIVELLO5_G8 return number IS
         BEGIN
            select SEQ_MCR0_LOG_ETL.nextval into seq from dual;
            PKG_MCRE0_AUDIT.log_etl (seq, '5_8 - PKG_MCRE0_TWS - INI - LIVELLO5_G8', PKG_MCRE0_AUDIT.C_DEBUG, sqlcode, 'INIZIO', 'INIZIO');
            esito:=0;
            PKG_MCRE0_AUDIT.log_etl (seq,'5_8 - ETL2 - INI - FNC_VERIFICA_ALERT_BLOCCO 6', PKG_MCRE0_AUDIT.C_DEBUG, sqlcode, 'INIZIO', 'INIZIO - FNC_VERIFICA_ALERT_BLOCCO 6.');
            RetVal := MCRE_OWN.PKG_MCRE0_ALERT3.FNC_VERIFICA_ALERT_BLOCCO ( seq, 6 );
            PKG_MCRE0_AUDIT.log_etl (seq,'5_8 - ETL2 - END - FNC_VERIFICA_ALERT_BLOCCO 6', PKG_MCRE0_AUDIT.C_DEBUG, sqlcode, 'Esito '||RETVAL, 'FINE - FNC_VERIFICA_ALERT_BLOCCO 6.');
            if (RetVal = 0) then
                raise eccezione_interna;
            end if;
            PKG_MCRE0_AUDIT.log_etl (seq,'5_8 - ETL2 - INI - FNC_VERIFICA_ALERT_BLOCCO 7', PKG_MCRE0_AUDIT.C_DEBUG, sqlcode, 'INIZIO', 'INIZIO - FNC_VERIFICA_ALERT_BLOCCO 7.');
            RetVal := MCRE_OWN.PKG_MCRE0_ALERT3.FNC_VERIFICA_ALERT_BLOCCO ( seq, 7 );
            PKG_MCRE0_AUDIT.log_etl (seq,'5_8 - ETL2 - END - FNC_VERIFICA_ALERT_BLOCCO 7', PKG_MCRE0_AUDIT.C_DEBUG, sqlcode, 'Esito '||RETVAL, 'FINE - FNC_VERIFICA_ALERT_BLOCCO 7.');
            if (RetVal = 0) then
                raise eccezione_interna;
            end if;
            PKG_MCRE0_AUDIT.log_etl (seq, '5_8 - PKG_MCRE0_TWS - END - LIVELLO5_G8', PKG_MCRE0_AUDIT.C_DEBUG, sqlcode, 'FINE', 'FINE');
            return ok;
        exception
            when eccezione_interna then
                PKG_MCRE0_AUDIT.log_etl ('5_8 - PKG_MCRE0_TWS ERROR - LIVELLO_5 GRUPPO_8', PKG_MCRE0_AUDIT.C_ERROR, sqlcode, sqlerrm, 'Errore interno');
                return ko;
            when others then
                PKG_MCRE0_AUDIT.log_etl ('5_8 - PKG_MCRE0_TWS ERROR - LIVELLO_5 GRUPPO_8', PKG_MCRE0_AUDIT.C_ERROR, sqlcode, sqlerrm, 'Errore generico');
                        return ko;
        end TWS_MCRE0_LIVELLO5_G8;

    FUNCTION TWS_MCRE0_LIVELLO5_G9 return number IS

        v_new_per date;
        v_last_period date;
        v_last_month number;

         BEGIN
            select SEQ_MCR0_LOG_ETL.nextval into seq from dual;
            PKG_MCRE0_AUDIT.log_etl (seq, '5_9 - PKG_MCRE0_TWS - INI - LIVELLO5_G9', PKG_MCRE0_AUDIT.C_DEBUG, sqlcode, 'INIZIO', 'INIZIO');
             v_last_month := 0;
             select (max(PERIODO_RIFERIMENTO))
             into v_new_per
             FROM T_MCRE0_WRK_ACQUISIZIONE
             where PERIODO_RIFERIMENTO = (SELECT MAX(PERIODO_RIFERIMENTO) FROM V_MCRE0_ULTIMA_ACQUISIZIONE);

             select (max(PERIODO_RIFERIMENTO))
             into v_last_period
             FROM T_MCRE0_WRK_ACQUISIZIONE
             where PERIODO_RIFERIMENTO < v_new_per;

             if extract (month from v_last_period) <>  extract (month from v_new_per) then
                v_last_month:= TO_NUMBER(TO_CHAR(v_last_period, 'yyyymmdd'));
             end if;

            IF (v_last_month <> 0) THEN
                PKG_MCRE0_AUDIT.log_etl (seq, '5_9 - PKG_MCRE0_TWS - INI - Aggiorna POS_STATO_STORICO aggiornamento effettuato', PKG_MCRE0_AUDIT.C_DEBUG, sqlcode, 'INIZIO', 'INIZIO - Aggiorna POS_STATO_STORICO aggiornamento effettuato');
                RETVAL := MCRE_OWN.PKG_MCRE0_AGGIORNA_MV.aggiorna_pos_stato_st;
                PKG_MCRE0_AUDIT.log_etl (seq, '5_9 - PKG_MCRE0_TWS - END - Aggiorna POS_STATO_STORICO aggiornamento effettuato', PKG_MCRE0_AUDIT.C_DEBUG, sqlcode, 'Esito '||RETVAL, 'FINE - Aggiorna POS_STATO_STORICO aggiornamento effettuato');
                if (RetVal = 0) then
                raise eccezione_interna;
                end if;
            END IF;
            PKG_MCRE0_AUDIT.log_etl (seq,'5_9 - ETL2 - FNC_VERIFICA_ALERT_BLOCCO 8', PKG_MCRE0_AUDIT.C_DEBUG, sqlcode, 'INIZIO', 'INIZIO - FNC_VERIFICA_ALERT_BLOCCO 8.');
            RetVal := MCRE_OWN.PKG_MCRE0_ALERT3.FNC_VERIFICA_ALERT_BLOCCO ( seq, 8 );
            PKG_MCRE0_AUDIT.log_etl (seq,'5_9 - ETL2 - FNC_VERIFICA_ALERT_BLOCCO 8', PKG_MCRE0_AUDIT.C_DEBUG, sqlcode, 'Esito '||RETVAL, 'FINE - FNC_VERIFICA_ALERT_BLOCCO 8.');
            if (RetVal = 0) then
                raise eccezione_interna;
            end if;
            PKG_MCRE0_AUDIT.log_etl (seq, '5_9 - PKG_MCRE0_TWS - END - LIVELLO5_G9', PKG_MCRE0_AUDIT.C_DEBUG, sqlcode, 'FINE', 'FINE');
            return ok;
        exception
            when eccezione_interna then
                PKG_MCRE0_AUDIT.log_etl ('5_9 - PKG_MCRE0_TWS ERROR - LIVELLO_5 GRUPPO_9', PKG_MCRE0_AUDIT.C_ERROR, sqlcode, sqlerrm, 'Errore interno');
                return ko;
            when others then
                PKG_MCRE0_AUDIT.log_etl ('5_9 - PKG_MCRE0_TWS ERROR - LIVELLO_5 GRUPPO_9', PKG_MCRE0_AUDIT.C_ERROR, sqlcode, sqlerrm, 'Errore generico');
                        return ko;
        end TWS_MCRE0_LIVELLO5_G9;

    FUNCTION TWS_MCRE0_LIVELLO6_G1 return number IS

        BEGIN

            select SEQ_MCR0_LOG_ETL.nextval into seq from dual;
            PKG_MCRE0_AUDIT.log_etl (seq, '6_1 - PKG_MCRE0_TWS - INI - LIVELLO6_G1', PKG_MCRE0_AUDIT.C_DEBUG, sqlcode, 'INIZIO', 'INIZIO');
            esito:=0;

            --a valle dell'esecuzione in parallelo degli alter a livello 5
            PKG_MCRE0_AUDIT.log_etl (seq,'6_1 - ETL2 - FNC_BATCH_LOAD_ALERT_POS', PKG_MCRE0_AUDIT.C_DEBUG, sqlcode, 'INIZIO', 'INIZIO - FNC_BATCH_LOAD_ALERT_POS');
            --RetVal := MCRE_OWN.PKG_MCRE0_ALERT3.FNC_FROM_WORKING_TABLE;
            /***** VG: TMP to ALERT_POS nuova gestione alert *****/
            RetVal := MCRE_OWN.PKG_MCRE0_ALERT.FNC_BATCH_LOAD_ALERT_POS;
            PKG_MCRE0_AUDIT.log_etl (seq,'6_1 - ETL2 - FNC_BATCH_LOAD_ALERT_POS', PKG_MCRE0_AUDIT.C_DEBUG, sqlcode, 'Esito '||RETVAL, 'FINE - FNC_BATCH_LOAD_ALERT_POS');
            if (RetVal = 0) then
                raise eccezione_interna;
            end if;
--
--            PKG_MCRE0_AUDIT.log_etl (seq, '6_1 APRI_PORTALE - INI', PKG_MCRE0_AUDIT.C_DEBUG, sqlcode, 'INIZIO', 'INIZIO - APRI_PORTALE');
--            RetVal := MCRE_OWN.PKG_MCRE0_TWS.TWS_MCRE0_APRI_PORTALE;
--            PKG_MCRE0_AUDIT.log_etl (seq, '6_1 APRI_PORTALE - END', PKG_MCRE0_AUDIT.C_DEBUG, sqlcode, 'Esito '||RetVal, 'FINE - APRI_PORTALE');

            PKG_MCRE0_AUDIT.log_etl (seq, '6_1 - PKG_MCRE0_TWS - INI - Sveccchia Log_APP', PKG_MCRE0_AUDIT.C_DEBUG, sqlcode, 'INIZIO', 'INIZIO - eseguito Svecchiamento log APP');
            RetVal := PKG_MCRE0_AUDIT.SVECCHIA_LOG_APP;
            PKG_MCRE0_AUDIT.log_etl (seq, '6_1 - PKG_MCRE0_TWS - END - Sveccchia Log_APP', PKG_MCRE0_AUDIT.C_DEBUG, sqlcode, 'Esito '||RetVal, 'FINE - eseguito Svecchiamento log APP');

            PKG_MCRE0_AUDIT.log_etl (seq, '6_1 - PKG_MCRE0_TWS - INI - Sveccchia Log_ETL', PKG_MCRE0_AUDIT.C_DEBUG, sqlcode, 'INIZIO', 'INIZIO - eseguito Svecchiamento log ETL');
            RetVal := PKG_MCRE0_AUDIT.SVECCHIA_LOG_ETL;
            PKG_MCRE0_AUDIT.log_etl (seq, '6_1 - PKG_MCRE0_TWS - END - Sveccchia Log_ETL', PKG_MCRE0_AUDIT.C_DEBUG, sqlcode, 'Esito '||RetVal, 'FINE - eseguito Svecchiamento log ETL');

            --Ver 2.0 inizializzazione T_MCRE0_WRK_SENDING_FILES per estrazione flussi per host
            update MCRE_OWN.T_MCRE0_WRK_SENDING_FILES
            set DTA_EXPORT = sysdate,
            ID_DPER=NULL,
            ESITO=-1,
            RECORD_EXP=NULL,
            RECORD_SC=NULL,
            COMPARTO_NULL=NULL;
            commit;
            PKG_MCRE0_AUDIT.log_etl (seq, '6_1 - PKG_MCRE0_TWS - END - LIVELLO6_G1', PKG_MCRE0_AUDIT.C_DEBUG, sqlcode, 'FINE', 'FINE');
            return ok;
        exception
--            when eccezione_interna then
--                PKG_MCRE0_AUDIT.log_etl ('6_1 - PKG_MCRE0_TWS ERROR - LIVELLO_6 GRUPPO_1', PKG_MCRE0_AUDIT.C_ERROR, sqlcode, sqlerrm, 'Errore interno');
--                return ko;
            when others then
                PKG_MCRE0_AUDIT.log_etl ('6_1 - PKG_MCRE0_TWS ERROR - LIVELLO_6 GRUPPO_1', PKG_MCRE0_AUDIT.C_ERROR, sqlcode, sqlerrm, 'Errore generico');
                        return ko;
        end TWS_MCRE0_LIVELLO6_G1;

    FUNCTION TWS_MCRE0_LIVELLO8_G1 return number IS

        N_GIORNI NUMBER;
--        v_esito_alert_new number:=-100;

        BEGIN
            select SEQ_MCR0_LOG_ETL.nextval into seq from dual;
            esito:=0;
            PKG_MCRE0_AUDIT.log_etl (seq, '8_1 - REFRESH_PCR_RAPP_AGGR - INI', PKG_MCRE0_AUDIT.C_DEBUG, sqlcode, 'INIZIO', 'REFRESH_PCR_RAPP_AGGR');
            RetVal := MCRE_OWN.PKG_MCREI_REFRESH_AGGREGATE.FNC_UPD_PCR_RAPP_AGGR ( SEQ );
            PKG_MCRE0_AUDIT.log_etl (seq, '8_1 - REFRESH_PCR_RAPP_AGGR - END', PKG_MCRE0_AUDIT.C_DEBUG, sqlcode, 'FINE', 'REFRESH_PCR_RAPP_AGGR');
            PKG_MCRE0_AUDIT.log_etl (seq, '8_1 - CONTROLLI - INI', PKG_MCRE0_AUDIT.C_DEBUG, sqlcode, 'INIZIO', 'INIZIO - CONTROLLI');
            N_GIORNI := 0;
--            RetVal := MCRE_OWN.PKG_MCRE0_UTILS.FND_MCRE0_CONTROLLI2;
            COMMIT;
          -- MCRE_OWN.PKG_MCRE0_CONTROLLO_ACQ.SPO_MCRE0_CONTROLLO_POST_ETL;
            MCRE_OWN.MCREO_TEMPI_BLOCCHI_TWS ( N_GIORNI );
            COMMIT;
            PKG_MCRE0_AUDIT.log_etl (seq, '8_1 - CONTROLLI - END', PKG_MCRE0_AUDIT.C_DEBUG, sqlcode, 'FINE', 'FINE - CONTROLLI');
--            v_esito_alert_new := PKG_MCRE0_ALERT_NEW.fnc_batch_alert_accesi;
            return ok;
        EXCEPTION WHEN OTHERS THEN
        PKG_MCRE0_AUDIT.log_etl ('8_1 - PKG_MCRE0_TWS ERROR - LIVELLO_8 GRUPPO_1', PKG_MCRE0_AUDIT.C_ERROR, sqlcode, sqlerrm, 'Errore generico');
            return ko;
        END TWS_MCRE0_LIVELLO8_G1;


-------ALERT MCREI--------
    FUNCTION TWS_MCRE0_LIVELLO9_G0 return number IS

        BEGIN
--            select SEQ_MCR0_LOG_ETL.nextval into seq from dual;
--            PKG_MCRE0_AUDIT.log_etl (seq, '9_0 - INIZIO ALERT MCREI', PKG_MCRE0_AUDIT.C_DEBUG, sqlcode, 'INIZIO', 'LOG');
--            COMMIT;
            return ok;
        EXCEPTION WHEN OTHERS THEN
--            PKG_MCRE0_AUDIT.log_etl ('9_0 - PKG_MCRE0_TWS ERROR - LIVELLO_9 GRUPPO_0', PKG_MCRE0_AUDIT.C_ERROR, sqlcode, sqlerrm, 'Errore generico');
            return ko;
        END TWS_MCRE0_LIVELLO9_G0;


    FUNCTION TWS_MCRE0_LIVELLO9_G1 return number IS

        BEGIN

          RetVal :=MCRE_OWN.FNC_MCRE0_SEND_MAIL;
          if (RetVal <>0) then
              raise eccezione_interna;
          end if;
            return ok;

        EXCEPTION
       when eccezione_interna then
              PKG_MCRE0_AUDIT.log_etl ('9_1 - PKG_MCRE0_TWS ERROR - LIVELLO_9 GRUPPO_1', PKG_MCRE0_AUDIT.C_ERROR, sqlcode, sqlerrm, 'Errore interno');
              return ko;
        WHEN OTHERS THEN
            return ko;
        END TWS_MCRE0_LIVELLO9_G1;


    FUNCTION TWS_MCRE0_LIVELLO9_G2 return number IS

        v_esito_alert_mcrei number:=-100;

        BEGIN
--            select SEQ_MCR0_LOG_ETL.nextval into seq from dual;
--            PKG_MCRE0_AUDIT.log_etl (seq, '9_2 - INIZIO CALCOLO BLOCCO 2', PKG_MCRE0_AUDIT.C_DEBUG, sqlcode, 'INIZIO', 'BLOCCO 2');
----            v_esito_alert_mcrei := PKG_MCREI_ALERT_2.FNC_MCREI_CALCOLO_BLOCCO(2);
--            PKG_MCRE0_AUDIT.log_etl (seq, '9_2 - FINE CALCOLO BLOCCO 2', PKG_MCRE0_AUDIT.C_DEBUG, sqlcode, 'FINE', 'BLOCCO 2');
--            COMMIT;
            return ok;

        EXCEPTION WHEN OTHERS THEN
--        PKG_MCRE0_AUDIT.log_etl ('9_2 - PKG_MCRE0_TWS ERROR - LIVELLO_9 GRUPPO_2', PKG_MCRE0_AUDIT.C_ERROR, sqlcode, sqlerrm, 'Errore generico');
            return ko;
        END TWS_MCRE0_LIVELLO9_G2;


    FUNCTION TWS_MCRE0_LIVELLO9_G3 return number IS

        v_esito_alert_mcrei number:=-100;

        BEGIN
--            select SEQ_MCR0_LOG_ETL.nextval into seq from dual;
--            PKG_MCRE0_AUDIT.log_etl (seq, '9_3 - INIZIO CALCOLO BLOCCO 3', PKG_MCRE0_AUDIT.C_DEBUG, sqlcode, 'INIZIO', 'BLOCCO 3');
----            v_esito_alert_mcrei := PKG_MCREI_ALERT_2.FNC_MCREI_CALCOLO_BLOCCO(3);
--            PKG_MCRE0_AUDIT.log_etl (seq, '9_3 - FINE CALCOLO BLOCCO 3', PKG_MCRE0_AUDIT.C_DEBUG, sqlcode, 'FINE', 'BLOCCO 3');
--            COMMIT;
            return ok;

        EXCEPTION WHEN OTHERS THEN
--        PKG_MCRE0_AUDIT.log_etl ('9_3 - PKG_MCRE0_TWS ERROR - LIVELLO_9 GRUPPO_3', PKG_MCRE0_AUDIT.C_ERROR, sqlcode, sqlerrm, 'Errore generico');
            return ko;
        END TWS_MCRE0_LIVELLO9_G3;


    FUNCTION TWS_MCRE0_LIVELLO9_G4 return number IS

        v_esito_alert_mcrei number:=-100;

        BEGIN
--            select SEQ_MCR0_LOG_ETL.nextval into seq from dual;
--            PKG_MCRE0_AUDIT.log_etl (seq, '9_4 - INIZIO CALCOLO BLOCCO 4', PKG_MCRE0_AUDIT.C_DEBUG, sqlcode, 'INIZIO', 'BLOCCO 4');
----            v_esito_alert_mcrei := PKG_MCREI_ALERT_2.FNC_MCREI_CALCOLO_BLOCCO(4);
--            PKG_MCRE0_AUDIT.log_etl (seq, '9_4 - FINE CALCOLO BLOCCO 4', PKG_MCRE0_AUDIT.C_DEBUG, sqlcode, 'FINE', 'BLOCCO 4');
--            COMMIT;
            return ok;

        EXCEPTION WHEN OTHERS THEN
--        PKG_MCRE0_AUDIT.log_etl ('9_4 - PKG_MCRE0_TWS ERROR - LIVELLO_9 GRUPPO_4', PKG_MCRE0_AUDIT.C_ERROR, sqlcode, sqlerrm, 'Errore generico');
            return ko;
        END TWS_MCRE0_LIVELLO9_G4;


    FUNCTION TWS_MCRE0_LIVELLO9_G5 return number IS

        v_esito_alert_mcrei number:=-100;

        BEGIN
--            select SEQ_MCR0_LOG_ETL.nextval into seq from dual;
--            PKG_MCRE0_AUDIT.log_etl (seq, '9_5 - INIZIO CALCOLO BLOCCO 5', PKG_MCRE0_AUDIT.C_DEBUG, sqlcode, 'INIZIO', 'BLOCCO 5');
----            v_esito_alert_mcrei := PKG_MCREI_ALERT_2.FNC_MCREI_CALCOLO_BLOCCO(5);
--            PKG_MCRE0_AUDIT.log_etl (seq, '9_5 - FINE CALCOLO BLOCCO 5', PKG_MCRE0_AUDIT.C_DEBUG, sqlcode, 'FINE', 'BLOCCO 5');
--            COMMIT;
            return ok;

        EXCEPTION WHEN OTHERS THEN
--        PKG_MCRE0_AUDIT.log_etl ('9_5 - PKG_MCRE0_TWS ERROR - LIVELLO_9 GRUPPO_5', PKG_MCRE0_AUDIT.C_ERROR, sqlcode, sqlerrm, 'Errore generico');
            return ko;
        END TWS_MCRE0_LIVELLO9_G5;


    PROCEDURE MCRE0_WRITE_ERRORS (errore IN VARCHAR2, v_file IN VARCHAR2, sequenza IN NUMBER default -666) IS

        v_nome_procedura    varchar2(50)    := '.PRC_MCRE0_WRITE_ERROR';
        l_output            utl_file.file_type;
        msg                 varchar2(500);
        seq                 number          := sequenza;
        nome_package        varchar2(50)    := 'PKG_MCRE0_TWS';
        p_dir               varchar2(20)    := 'D_MCRE0_DISC';
        p_file              varchar2(20)    := v_file;
        err                 varchar2(20)    := errore;
        messaggio           varchar2(500)   :=
'Anagrafica errori noti e azioni da intraprendere di conseguenza:

- 0600: Errore sistemistico --> Contattare supporto tecnico database
- Altri:                        --> Contattare Reperibile applicazione';

        BEGIN
            esito:=0;
            PKG_MCRE0_AUDIT.log_etl (seq, nome_package||v_nome_procedura, PKG_MCRE0_AUDIT.C_DEBUG, sqlcode, 'INIZIO', '');
            RetVal := MCRE_OWN.PKG_MCREI_REFRESH_AGGREGATE.FNC_UPD_PCR_RAPP_AGGR ( SEQ );
            l_output := utl_file.fopen(p_dir, p_file, 'w',  32760);

            msg := err||chr(10)||messaggio;
            utl_file.put(l_output, msg );
            utl_file.fflush(l_output);

            utl_file.new_line(l_output);
            utl_file.fclose(l_output);

            COMMIT;
            PKG_MCRE0_AUDIT.log_etl (seq, nome_package||v_nome_procedura, PKG_MCRE0_AUDIT.C_DEBUG, sqlcode, 'FINE', '');

        EXCEPTION WHEN OTHERS THEN
            PKG_MCRE0_AUDIT.log_etl (seq, nome_package||v_nome_procedura, PKG_MCRE0_AUDIT.C_ERROR, sqlcode, sqlerrm, 'Errore generico');
        END MCRE0_WRITE_ERRORS;

END PKG_MCRE0_TWS;
/


CREATE SYNONYM MCRE_APP.PKG_MCRE0_TWS FOR MCRE_OWN.PKG_MCRE0_TWS;


CREATE SYNONYM MCRE_USR.PKG_MCRE0_TWS FOR MCRE_OWN.PKG_MCRE0_TWS;


GRANT EXECUTE, DEBUG ON MCRE_OWN.PKG_MCRE0_TWS TO MCRE_USR;

