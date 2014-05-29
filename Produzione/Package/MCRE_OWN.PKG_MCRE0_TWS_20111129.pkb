CREATE OR REPLACE PACKAGE BODY MCRE_OWN.PKG_MCRE0_TWS_20111129 AS
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
   1.4        24/08/2011  Luca Ferretti     Modifiche per attività tuning Goitre/Murro   
   1.5        06/10/2011  Luca Ferretti     Inserimento progressivo per log
   1.6        14/10/2011  Luca Ferretti     Aggiornamento log
   1.7        14/10/2011  Luca Ferretti     Spalmamento Alert
   1.8        14/10/2011  Luca Ferretti     Aggiunta Clean Alert post-alert
   1.9        18/10/2011  Luca Ferretti     Correzione log e eliminazione doppio calcolo ALERT
   2.0        16/11/2011  Luca Ferretti     Aggiunta controlli dopo apertura portale
   2.1        21/11/2011  M.Murro           Accodato ex L5G1 L5G7 e L5G8 a L4G1 (AnaGen e uscite)
   2.2        22/11/2011  Luca Ferretti     Modifica controlli post apertura portale
******************************************************************************/

    RetVal number:=0;
    esito  number:=0;
    seq number;
    V_TOT_ALERT number;
    V_RESULT_CLEAN number; 
    ret_analyze boolean;

    FUNCTION TWS_MCRE0_CHIUDI_PORTALE return number is
        BEGIN            
            select SEQ_MCR0_LOG_ETL.nextval into seq from dual;
            PKG_MCRE0_AUDIT.log_etl (seq, '0 - PKG_MCRE0_TWS_20111129 - INI - TWS_MCRE0_CHIUDI_PORTALE', PKG_MCRE0_AUDIT.C_DEBUG, sqlcode, 'INIZIO', 'INIZIO');
            PKG_MCRE0_AUDIT.log_etl (seq, '0 - PKG_MCRE0_TWS_20111129 - INI - TWS_MCRE0_CHIUDI_PORTALE', PKG_MCRE0_AUDIT.C_DEBUG, sqlcode, 'INIZIO', 'INIZIO - Portale chiuso');
            update T_MCRE0_WRK_CONFIGURAZIONE set VALORE_COSTANTE = 0 where NOME_COSTANTE = 'STATO_PORTALE';
            commit;
            PKG_MCRE0_AUDIT.log_etl (seq, '0 - PKG_MCRE0_TWS_20111129 - END - TWS_MCRE0_CHIUDI_PORTALE', PKG_MCRE0_AUDIT.C_DEBUG, sqlcode, 'FINE', 'FINE - Portale chiuso');
            PKG_MCRE0_AUDIT.log_etl (seq, '0 - PKG_MCRE0_TWS_20111129 - END - TWS_MCRE0_CHIUDI_PORTALE', PKG_MCRE0_AUDIT.C_DEBUG, sqlcode, 'FINE', 'FINE');
            return ok;
        EXCEPTION WHEN OTHERS THEN
            PKG_MCRE0_AUDIT.log_etl (seq, '0 - TWS_MCRE0_CHIUDI_PORTALE', PKG_MCRE0_AUDIT.C_ERROR, sqlcode, sqlerrm, 'Errore in TWS_MCRE0_CHIUDI_PORTALE');
            return ko;
        END TWS_MCRE0_CHIUDI_PORTALE;

    FUNCTION TWS_MCRE0_APRI_PORTALE return number is
        BEGIN
            select SEQ_MCR0_LOG_ETL.nextval into seq from dual;
            PKG_MCRE0_AUDIT.log_etl (seq, '9_1 - PKG_MCRE0_TWS_20111129 - INI - TWS_MCRE0_APRI_PORTALE', PKG_MCRE0_AUDIT.C_DEBUG, sqlcode, 'INIZIO', 'INIZIO');
            PKG_MCRE0_AUDIT.log_etl (seq, '9_1 - PKG_MCRE0_TWS_20111129 - INI - TWS_MCRE0_APRI_PORTALE', PKG_MCRE0_AUDIT.C_DEBUG, sqlcode, 'INIZIO', 'INIZIO - Portale aperto');
            update T_MCRE0_WRK_CONFIGURAZIONE set VALORE_COSTANTE = 1 where NOME_COSTANTE = 'STATO_PORTALE';
            commit;
            PKG_MCRE0_AUDIT.log_etl (seq, '9_1 - PKG_MCRE0_TWS_20111129 - END - TWS_MCRE0_APRI_PORTALE', PKG_MCRE0_AUDIT.C_DEBUG, sqlcode, 'FINE', 'FINE - Portale aperto');
            PKG_MCRE0_AUDIT.log_etl (seq, '9_1 - PKG_MCRE0_TWS_20111129 - END - TWS_MCRE0_APRI_PORTALE', PKG_MCRE0_AUDIT.C_DEBUG, sqlcode, 'FINE', 'FINE');
            return ok;
        EXCEPTION WHEN OTHERS THEN
            PKG_MCRE0_AUDIT.log_etl (seq, '9_1 - TWS_MCRE0_APRI_PORTALE', PKG_MCRE0_AUDIT.C_ERROR, sqlcode, sqlerrm, 'Errore in TWS_MCRE0_APRI_PORTALE');
            return ko;
        END TWS_MCRE0_APRI_PORTALE;

    FUNCTION TWS_MCRE0_CHECK_ABI_ELAB return number IS
        BEGIN            
            select SEQ_MCR0_LOG_ETL.nextval into seq from dual;
            PKG_MCRE0_AUDIT.log_etl (seq, '0_1 - PKG_MCRE0_TWS_20111129 - INI - CHECK_ABI_ELAB', PKG_MCRE0_AUDIT.C_DEBUG, sqlcode, 'INIZIO', 'INIZIO');
            esito:=0;
            PKG_MCRE0_AUDIT.log_etl (seq, '0_1 - PKG_MCRE0_TWS_20111129 - INI - CHECK_ABI_ELAB', PKG_MCRE0_AUDIT.C_DEBUG, sqlcode, 'INIZIO', 'INIZIO - check_abi_elab');
            RetVal := PKG_MCRE0_GESTIONE_ABI_ELAB.CHECK_ABI_ELAB;
            PKG_MCRE0_AUDIT.log_etl (seq, '0_1 - PKG_MCRE0_TWS_20111129 - END - CHECK_ABI_ELAB', PKG_MCRE0_AUDIT.C_DEBUG, sqlcode, 'Esito '||RetVal, 'FINE - check_abi_elab');
            esito := esito+RetVal;            
            PKG_MCRE0_AUDIT.log_etl (seq, '0_1 - PKG_MCRE0_TWS_20111129 - INI - CHECK_ABI_ELAB', PKG_MCRE0_AUDIT.C_DEBUG, sqlcode, 'INIZIO', 'INIZIO - ETL_GESTIONE_TAPPI');
            RetVal := MCRE_OWN.PKG_MCRE0_GESTIONE_ALL_DATA.ETL_GESTIONE_TAPPI(seq);
            PKG_MCRE0_AUDIT.log_etl (seq, '0_1 - PKG_MCRE0_TWS_20111129 - END - CHECK_ABI_ELAB', PKG_MCRE0_AUDIT.C_DEBUG, sqlcode, 'Esito '||RetVal, 'FINE - ETL_GESTIONE_TAPPI');
            PKG_MCRE0_AUDIT.log_etl (seq, '0_1 - PKG_MCRE0_TWS_20111129 - END - CHECK_ABI_ELAB', PKG_MCRE0_AUDIT.C_DEBUG, sqlcode, 'FINE', 'FINE');
            return ok;
        EXCEPTION WHEN OTHERS THEN
            PKG_MCRE0_AUDIT.log_etl ('0_1 - PKG_MCRE0_TWS_20111129 ERROR CHECK_ABI_ELAB', PKG_MCRE0_AUDIT.C_ERROR, sqlcode, sqlerrm, 'Errore in CHECK_ABI_ELAB');
            return ko;
        END TWS_MCRE0_CHECK_ABI_ELAB;

    FUNCTION TWS_MCRE0_LIVELLO1_G1 return number IS

        BEGIN            
            select SEQ_MCR0_LOG_ETL.nextval into seq from dual;
            PKG_MCRE0_AUDIT.log_etl (seq, '1_1 - PKG_MCRE0_TWS_20111129 - INI - LIVELLO1_G1 ', PKG_MCRE0_AUDIT.C_DEBUG, sqlcode, 'INIZIO', 'INIZIO');
            esito:=0;
            --svecchio GE
            PKG_MCRE0_AUDIT.log_etl (seq, '1_1 - PKG_MCRE0_TWS_20111129 - INI - Svecchiamento GE ', PKG_MCRE0_AUDIT.C_DEBUG, sqlcode, 'INIZIO', 'INIZIO - Svecchiamento GE ');
            RetVal := MCRE_OWN.PKG_MCRE0_CARICA_GRUPPO_LEGAME.SVECCHIA_GE;
            PKG_MCRE0_AUDIT.log_etl (seq, '1_1 - PKG_MCRE0_TWS_20111129 - END - Svecchiamento GE ', PKG_MCRE0_AUDIT.C_DEBUG, sqlcode, 'Esito '||RetVal, 'FINE - Svecchiamento GE ');
            esito := esito+RetVal;
            --svecchio GL
            PKG_MCRE0_AUDIT.log_etl (seq, '1_1 - PKG_MCRE0_TWS_20111129 - INI - Svecchiamento GL ', PKG_MCRE0_AUDIT.C_DEBUG, sqlcode, 'INIZIO', 'INIZIO - Svecchiamento GL ');
            RetVal := MCRE_OWN.PKG_MCRE0_CARICA_GRUPPO_LEGAME.SVECCHIA_LEGAMI;
            PKG_MCRE0_AUDIT.log_etl (seq, '1_1 - PKG_MCRE0_TWS_20111129 - END - Svecchiamento GL ', PKG_MCRE0_AUDIT.C_DEBUG, sqlcode, 'Esito '||RetVal, 'FINE - Svecchiamento GL ');
            esito := esito+RetVal;
            --gruppo legame
            PKG_MCRE0_AUDIT.log_etl (seq, '1_1 - PKG_MCRE0_TWS_20111129 - INI - Calcolo GL ', PKG_MCRE0_AUDIT.C_DEBUG, sqlcode, 'INIZIO', 'INIZIO - Calcolo GL ');
            RetVal := MCRE_OWN.PKG_MCRE0_CARICA_GRUPPO_LEGAME.LOAD_FULL_GRUPPO_LEGAME;
            PKG_MCRE0_AUDIT.log_etl (seq, '1_1 - PKG_MCRE0_TWS_20111129 - END - Calcolo GL ', PKG_MCRE0_AUDIT.C_DEBUG, sqlcode, 'Esito '||RetVal, 'FINE - Calcolo GL ');
            esito := esito+RetVal;
            PKG_MCRE0_AUDIT.log_etl (seq, '1_1 - PKG_MCRE0_TWS_20111129 - INI - Set TODAY FLG ', PKG_MCRE0_AUDIT.C_DEBUG, sqlcode, 'INIZIO', 'INIZIO - TODAY FLG');
            RetVal := MCRE_OWN.PKG_MCRE0_ESTENDI_MOPLE.FNC_SET_TODAY_FLG;
            PKG_MCRE0_AUDIT.log_etl (seq, '1_1 - PKG_MCRE0_TWS_20111129 - END - Set TODAY FLG ', PKG_MCRE0_AUDIT.C_DEBUG, sqlcode, 'Esito '||RetVal, 'FINE - TODAY FLG');
            esito := esito+RetVal;
            PKG_MCRE0_AUDIT.log_etl (seq, '1_1 - PKG_MCRE0_TWS_20111129 - INI - UPD_GB_STATUS ', PKG_MCRE0_AUDIT.C_DEBUG, sqlcode, 'INIZIO', 'INIZIO - eseguito Aggiornamento GB');
            RetVal := MCRE_OWN.PKG_MCRE0_ESTENDI_MOPLE.UPD_GB_STATUS;
            PKG_MCRE0_AUDIT.log_etl (seq, '1_1 - PKG_MCRE0_TWS_20111129 - END - UPD_GB_STATUS ', PKG_MCRE0_AUDIT.C_DEBUG, sqlcode, 'Esito '||RetVal, 'FINE - eseguito Aggiornamento GB');
            esito := esito+RetVal;
            esito:=0;
            --comparto
            PKG_MCRE0_AUDIT.log_etl (seq, '1_1 - PKG_MCRE0_TWS_20111129 - INI - Calcolo comparto ', PKG_MCRE0_AUDIT.C_DEBUG, sqlcode, 'INIZIO', 'INIZIO - Calcolo comparto ');
            RetVal := MCRE_OWN.PKG_MCRE0_ESTENDI_MOPLE.SET_COMPARTO_HOST;
            PKG_MCRE0_AUDIT.log_etl (seq, '1_1 - PKG_MCRE0_TWS_20111129 - END - Calcolo comparto ', PKG_MCRE0_AUDIT.C_DEBUG, sqlcode, 'Esito '||RetVal, 'FINE - Calcolo comparto ');
            esito := esito+RetVal;
            --macrostato
            PKG_MCRE0_AUDIT.log_etl (seq, '1_1 - PKG_MCRE0_TWS_20111129 - INI - Calcolo macrostato ', PKG_MCRE0_AUDIT.C_DEBUG, sqlcode, 'INIZIO', 'INIZIO - Calcolo macrostato ');
            RetVal := MCRE_OWN.PKG_MCRE0_ESTENDI_MOPLE.FNC_GESTIONE_MACROSTATO;
            PKG_MCRE0_AUDIT.log_etl (seq, '1_1 - PKG_MCRE0_TWS_20111129 - END - Calcolo macrostato ', PKG_MCRE0_AUDIT.C_DEBUG, sqlcode, 'Esito '||RetVal, 'FINE - Calcolo macrostato ');            
            esito := esito+RetVal;
            --processo_pre
            PKG_MCRE0_AUDIT.log_etl (seq, '1_1 - PKG_MCRE0_TWS_20111129 - INI - Calcolo processo precedente ', PKG_MCRE0_AUDIT.C_DEBUG, sqlcode, 'INIZIO', 'INIZIO - Calcolo processo precedente ');
            RetVal := MCRE_OWN.PKG_MCRE0_ESTENDI_MOPLE.FNC_GESTIONE_PROCESSO_PRE;
            PKG_MCRE0_AUDIT.log_etl (seq, '1_1 - PKG_MCRE0_TWS_20111129 - END - Calcolo processo precedente ', PKG_MCRE0_AUDIT.C_DEBUG, sqlcode, 'Esito '||RetVal, 'FINE - Calcolo processo precedente ');
            esito := esito+RetVal;
            --dta_decorrenza_stato_pre
            PKG_MCRE0_AUDIT.log_etl (seq, '1_1 - PKG_MCRE0_TWS_20111129 - INI - Calcolo data decorrenza stato precedente ', PKG_MCRE0_AUDIT.C_DEBUG, sqlcode, 'INIZIO', 'INIZIO - Calcolo data decorrenza stato precedente ');
            RetVal := MCRE_OWN.PKG_MCRE0_ESTENDI_MOPLE.FNC_GESTIONE_DTA_STATO_PRE;
            PKG_MCRE0_AUDIT.log_etl (seq, '1_1 - PKG_MCRE0_TWS_20111129 - END - Calcolo data decorrenza stato precedente ', PKG_MCRE0_AUDIT.C_DEBUG, sqlcode, 'Esito '||RetVal, 'FINE - Calcolo data decorrenza stato precedente ');
            esito := esito+RetVal;
            PKG_MCRE0_AUDIT.log_etl (seq, '1_1 - PKG_MCRE0_TWS_20111129 - END - LIVELLO1_G1 ', PKG_MCRE0_AUDIT.C_DEBUG, sqlcode, 'FINE', 'FINE');
            return ok;
        EXCEPTION WHEN OTHERS THEN
            PKG_MCRE0_AUDIT.log_etl (seq, '1_1 - PKG_MCRE0_TWS_20111129 ERROR - LIVELLO_1 GRUPPO_1', PKG_MCRE0_AUDIT.C_ERROR, sqlcode, sqlerrm, 'Errore in ERROR - LIVELLO_1 GRUPPO_1');
            return ko;
        END TWS_MCRE0_LIVELLO1_G1;


    FUNCTION TWS_MCRE0_LIVELLO1_G2 return number IS

        BEGIN            
            select SEQ_MCR0_LOG_ETL.nextval into seq from dual;
            PKG_MCRE0_AUDIT.log_etl (seq, '1_2 - PKG_MCRE0_TWS_20111129 - INI - LIVELLO1_G2', PKG_MCRE0_AUDIT.C_DEBUG, sqlcode, 'INIZIO', 'INIZIO');
            PKG_MCRE0_AUDIT.log_etl (seq, '1_2 - PKG_MCRE0_TWS_20111129 - END - LIVELLO1_G2', PKG_MCRE0_AUDIT.C_DEBUG, sqlcode, 'FINE', 'FINE');
            return ok;
        EXCEPTION WHEN OTHERS THEN
            PKG_MCRE0_AUDIT.log_etl (seq, '1_2 - PKG_MCRE0_TWS_20111129 ERROR - LIVELLO_1 GRUPPO_2', PKG_MCRE0_AUDIT.C_ERROR, sqlcode, sqlerrm, 'Errore in ERROR - LIVELLO_1 GRUPPO_2');
            return ko;
        END TWS_MCRE0_LIVELLO1_G2;

    FUNCTION TWS_MCRE0_LIVELLO1_G3 return number IS

        BEGIN            
            select SEQ_MCR0_LOG_ETL.nextval into seq from dual;
            PKG_MCRE0_AUDIT.log_etl (seq, '1_3 - PKG_MCRE0_TWS_20111129 - INI - LIVELLO1_G3', PKG_MCRE0_AUDIT.C_DEBUG, sqlcode, 'INIZIO', 'INIZIO'); 
            PKG_MCRE0_AUDIT.log_etl (seq, '1_3 - PKG_MCRE0_TWS_20111129 - END - LIVELLO1_G3', PKG_MCRE0_AUDIT.C_DEBUG, sqlcode, 'FINE', 'FINE');         
            return ok;
        EXCEPTION WHEN OTHERS THEN
            PKG_MCRE0_AUDIT.log_etl (seq, '1_3 - PKG_MCRE0_TWS_20111129 ERROR - LIVELLO_1 GRUPPO_3', PKG_MCRE0_AUDIT.C_ERROR, sqlcode, sqlerrm, 'Errore in ERROR - LIVELLO_1 GRUPPO_3');
            return ko;
        END TWS_MCRE0_LIVELLO1_G3;

    FUNCTION TWS_MCRE0_LIVELLO1_G4 return number IS

        BEGIN
            select SEQ_MCR0_LOG_ETL.nextval into seq from dual;
            PKG_MCRE0_AUDIT.log_etl (seq, '1_4 - PKG_MCRE0_TWS_20111129 - INI - LIVELLO1_G4', PKG_MCRE0_AUDIT.C_DEBUG, sqlcode, 'INIZIO', 'INIZIO');
            esito:=0;
            -- Istituti
            PKG_MCRE0_AUDIT.log_etl (seq, '1_4 - PKG_MCRE0_TWS_20111129 - INI - Aggiorna Istituti in seguito ai caricamenti ', PKG_MCRE0_AUDIT.C_DEBUG, sqlcode, 'INIZIO', 'INIZIO - Aggiorna Istituti in seguito ai caricamenti ');
            Retval := Mcre_Own.Pkg_Mcre0_Aggiorna_Mv.Aggiorna_Istituti(seq);
            PKG_MCRE0_AUDIT.log_etl (seq, '1_4 - PKG_MCRE0_TWS_20111129 - END - Aggiorna Istituti in seguito ai caricamenti ', PKG_MCRE0_AUDIT.C_DEBUG, sqlcode, 'Esito '||RetVal, 'FINE - Aggiorna Istituti in seguito ai caricamenti ');
            esito := esito+RetVal;
            -- Strutt_ORG
            PKG_MCRE0_AUDIT.log_etl (seq, '1_4 - PKG_MCRE0_TWS_20111129 - INI - Aggiorna Strutt_ORG in seguito ai caricamenti ', PKG_MCRE0_AUDIT.C_DEBUG, sqlcode, 'INIZIO', 'INIZIO - Aggiorna Strutt_ORG in seguito ai caricamenti ');
            Retval := Mcre_Own.Pkg_Mcre0_Aggiorna_Mv.aggiorna_DENORM_STR_ORG(seq);
            PKG_MCRE0_AUDIT.log_etl (seq, '1_4 - PKG_MCRE0_TWS_20111129 - END - Aggiorna Strutt_ORG in seguito ai caricamenti ', PKG_MCRE0_AUDIT.C_DEBUG, sqlcode, 'Esito '||RetVal, 'FINE - Aggiorna Strutt_ORG in seguito ai caricamenti ');
            esito := esito+RetVal;
            PKG_MCRE0_AUDIT.log_etl (seq, '1_4 - PKG_MCRE0_TWS_20111129 - END - LIVELLO1_G4', PKG_MCRE0_AUDIT.C_DEBUG, sqlcode, 'FINE', 'FINE');
            return ok;
        EXCEPTION WHEN OTHERS THEN
            PKG_MCRE0_AUDIT.log_etl ('1_4 - PKG_MCRE0_TWS_20111129 ERROR - LIVELLO_1 GRUPPO_4', PKG_MCRE0_AUDIT.C_ERROR, sqlcode, sqlerrm, 'Errore in ERROR - LIVELLO_1 GRUPPO_4');
            return ko;
        END TWS_MCRE0_LIVELLO1_G4;FUNCTION TWS_MCRE0_LIVELLO2_G1 return number IS

        BEGIN
            select SEQ_MCR0_LOG_ETL.nextval into seq from dual;
            PKG_MCRE0_AUDIT.log_etl (seq, '2_1 - PKG_MCRE0_TWS_20111129 - INI - LIVELLO2_G1', PKG_MCRE0_AUDIT.C_DEBUG, sqlcode, 'INIZIO', 'INIZIO');
            esito:=0;
            -- Aggiornamento File Guida
            PKG_MCRE0_AUDIT.log_etl (seq, '2_1 - PKG_MCRE0_TWS_20111129 - INI - Aggiornamento File Guida', PKG_MCRE0_AUDIT.C_DEBUG, sqlcode, 'INIZIO', 'INIZIO - Aggiornamento File Guida');
            RetVal := MCRE_OWN.PKG_MCRE0_ESTENDI_FILE_GUIDA.UPDATE_FILE_GUIDA;
            PKG_MCRE0_AUDIT.log_etl (seq, '2_1 - PKG_MCRE0_TWS_20111129 - END - Aggiornamento File Guida', PKG_MCRE0_AUDIT.C_DEBUG, sqlcode, 'Esito '||RetVal, 'FINE - Aggiornamento File Guida');
            esito := esito+RetVal;
            -- assegnazione comparti per GB
            PKG_MCRE0_AUDIT.log_etl (seq,'2_1 - PKG_MCRE0_TWS_20111129 - INI - assegna_comparto_GB_AV', PKG_MCRE0_AUDIT.C_DEBUG, sqlcode, 'INIZIO', 'INIZIO - eseguito assegna_comparto_GB_AV');
            RetVal := MCRE_OWN.PKG_MCRE0_ESTENDI_FILE_GUIDA.assegna_comparto_GB_AV(seq);
            PKG_MCRE0_AUDIT.log_etl (seq,'2_1 - PKG_MCRE0_TWS_20111129 - END - assegna_comparto_GB_AV', PKG_MCRE0_AUDIT.C_DEBUG, sqlcode, 'Esito '||RetVal, 'FINE - eseguito assegna_comparto_GB_AV');
            esito := esito+RetVal;
            -- gestione Gestori/Comparti su gruppi usciti da mople
            PKG_MCRE0_AUDIT.log_etl (seq, '2_1 - PKG_MCRE0_TWS_20111129 - INI - update_uscita_CCP', PKG_MCRE0_AUDIT.C_DEBUG, sqlcode, 'INIZIO', 'INIZIO - update_uscita_CCP');
            RetVal := MCRE_OWN.PKG_MCRE0_ESTENDI_FILE_GUIDA.update_uscita_CCP; --v 1.9
            PKG_MCRE0_AUDIT.log_etl (seq, '2_1 - PKG_MCRE0_TWS_20111129 - END - update_uscita_CCP', PKG_MCRE0_AUDIT.C_DEBUG, sqlcode, 'Esito '||RetVal, 'FINE - update_uscita_CCP');
            esito := esito+RetVal;
            -- Analize FILE_GUIDA e MOPLE
            PKG_MCRE0_AUDIT.log_etl (seq,'2_1 - PKG_MCRE0_TWS_20111129 - INI STATISTICHE FILE_GUIDA', PKG_MCRE0_AUDIT.C_DEBUG, sqlcode, 'INIZIO', 'INIZIO - eseguito Calcolo Statistiche su FileGuida');
            if( MCRE_OWN.PKG_MCRE0_ANALYZE.FND_MCRE0_ANALYZE_TABLE_APP ( 'MCRE_OWN', 'T_MCRE0_APP_FILE_GUIDA' ) )then
             esito := esito+1;
             PKG_MCRE0_AUDIT.log_etl (seq,'2_1 - PKG_MCRE0_TWS_20111129 - END STATISTICHE FILE_GUIDA', PKG_MCRE0_AUDIT.C_DEBUG, sqlcode, 'Esito 1', 'FINE - eseguito Calcolo Statistiche su FileGuida');
            else
             PKG_MCRE0_AUDIT.log_etl (seq,'2_1 - PKG_MCRE0_TWS_20111129 - END STATISTICHE FILE_GUIDA', PKG_MCRE0_AUDIT.C_DEBUG, sqlcode, 'Esito 0', 'FINE - impossibile eseguire Calcolo Statistiche su FileGuida');
            end if;
            PKG_MCRE0_AUDIT.log_etl (seq,'2_1 - PKG_MCRE0_TWS_20111129 - INI STATISTICHE MOPLE', PKG_MCRE0_AUDIT.C_DEBUG, sqlcode, 'INIZIO', 'INIZIO - eseguito Calcolo Statistiche su Mople');
            if( MCRE_OWN.PKG_MCRE0_ANALYZE.FND_MCRE0_ANALYZE_TABLE_APP ( 'MCRE_OWN', 'T_MCRE0_APP_MOPLE' ) )then
             esito := esito+1;
             PKG_MCRE0_AUDIT.log_etl (seq,'2_1 - PKG_MCRE0_TWS_20111129 - END STATISTICHE MOPLE', PKG_MCRE0_AUDIT.C_DEBUG, sqlcode, 'Esito 1', 'FINE - eseguito Calcolo Statistiche su Mople');
            else
             PKG_MCRE0_AUDIT.log_etl (seq,'2_1 - PKG_MCRE0_TWS_20111129 - END STATISTICHE MOPLE', PKG_MCRE0_AUDIT.C_DEBUG, sqlcode, 'Esito 0', 'FINE - impossibile eseguire Calcolo Statistiche su Mople');
            end if;
            -- assegnazione automatica su incagli
            PKG_MCRE0_AUDIT.log_etl ('2_1 - PKG_MCRE0_TWS_20111129 - INI - ASSEGNAZIONE AUTOMATICA SU INCAGLI', PKG_MCRE0_AUDIT.C_DEBUG, sqlcode, 'INIZIO', 'INZIO - eseguita assegnazione automatica');
            RetVal := MCRE_OWN.PKG_MCRE0_ASS_AUTOM.FND_MCRE0_ASSEGNA(seq);  --v.2.3
            PKG_MCRE0_AUDIT.log_etl ('2_1 - PKG_MCRE0_TWS_20111129 - END - ASSEGNAZIONE AUTOMATICA SU INCAGLI', PKG_MCRE0_AUDIT.C_DEBUG, sqlcode, 'Esito '||RetVal, 'FINE - eseguita assegnazione automatica');
            esito := esito+RetVal;

            -- Storico
            PKG_MCRE0_AUDIT.log_etl (seq, '2_1 - PKG_MCRE0_TWS_20111129 - INI - Storicizza in seguito ai caricamenti', PKG_MCRE0_AUDIT.C_DEBUG, sqlcode, 'INIZIO', 'INIZIO - Storicizza in seguito ai caricamenti');
            RetVal := MCRE_OWN.PKG_MCRE0_STORICIZZA.STORICIZZA_CARICAMENTI(seq);
            PKG_MCRE0_AUDIT.log_etl (seq, '2_1 - PKG_MCRE0_TWS_20111129 - END - Storicizza in seguito ai caricamenti', PKG_MCRE0_AUDIT.C_DEBUG, sqlcode, 'Esito '||RetVal, 'FINE - Storicizza in seguito ai caricamenti');
            esito := esito+RetVal;
            PKG_MCRE0_AUDIT.log_etl (seq, '2_1 - PKG_MCRE0_TWS_20111129 - END - LIVELLO2_G1', PKG_MCRE0_AUDIT.C_DEBUG, sqlcode, 'FINE', 'FINE');
            return ok;
        EXCEPTION WHEN OTHERS THEN
            PKG_MCRE0_AUDIT.log_etl ('2_1 - PKG_MCRE0_TWS_20111129 ERROR - LIVELLO_2 GRUPPO_1', PKG_MCRE0_AUDIT.C_ERROR, sqlcode, sqlerrm, 'Errore in ERROR - LIVELLO_2 GRUPPO_1');
            return ko;
        END TWS_MCRE0_LIVELLO2_G1;


    FUNCTION TWS_MCRE0_LIVELLO3_G1 return number IS

        BEGIN
            select SEQ_MCR0_LOG_ETL.nextval into seq from dual;
            PKG_MCRE0_AUDIT.log_etl (seq, '3_1 - PKG_MCRE0_TWS_20111129 - INI - LIVELLO3_G1', PKG_MCRE0_AUDIT.C_DEBUG, sqlcode, 'INIZIO', 'INIZIO');
            esito:=0;
            --riempio prima la tabellona PCR
            PKG_MCRE0_AUDIT.log_etl (seq, '3_1 - PKG_MCRE0_TWS_20111129 - INI - FNC_LOAD_PCR in seguito ai caricamenti', PKG_MCRE0_AUDIT.C_DEBUG, sqlcode, 'INIZIO', 'INIZIO - FNC_LOAD_PCR in seguito ai caricamenti');
            RetVal := MCRE_OWN.PKG_MCRE0_PCR.FNC_LOAD_PCR(seq);
            PKG_MCRE0_AUDIT.log_etl (seq, '3_1 - PKG_MCRE0_TWS_20111129 - END - FNC_LOAD_PCR in seguito ai caricamenti', PKG_MCRE0_AUDIT.C_DEBUG, sqlcode, 'Esito '||RetVal, 'FINE - FNC_LOAD_PCR in seguito ai caricamenti');
            esito := esito+RetVal;            
    
            begin
                 PKG_MCRE0_AUDIT.log_etl (seq,'3_1 - INI - ANALYZE PCR ', PKG_MCRE0_AUDIT.C_DEBUG, sqlcode, 'INIZIO', 'INIZIO - eseguito Analyze PCR');
                 if( MCRE_OWN.PKG_MCRE0_ANALYZE.FND_MCRE0_ANALYZE_TABLE_APP ( 'MCRE_OWN', 'T_MCRE0_APP_PCR' ) )then
                     esito := esito+1;
                     PKG_MCRE0_AUDIT.log_etl (seq,'3_1 - ETL2 - PCR ', PKG_MCRE0_AUDIT.C_DEBUG, sqlcode, 'Esito 1', 'FINE - eseguito Analyze PCR');
                 else
                     PKG_MCRE0_AUDIT.log_etl (seq,'3_1 - ETL2 - PCR ', PKG_MCRE0_AUDIT.C_DEBUG, sqlcode, 'Esito 0', 'FINE - impossibile eseguire Analyze PCR');
                 end if;
            EXCEPTION WHEN OTHERS THEN
             PKG_MCRE0_AUDIT.log_etl (seq,'3_1 - END - ANALYZE PCR ', PKG_MCRE0_AUDIT.C_ERROR, sqlcode, 'Esito 0 '||SQLERRM, 'impossibile eseguire Analyze PCR');
            end;
            --TABELLONE al posto della UPD_FIELDS
            PKG_MCRE0_AUDIT.log_etl (seq,'3_1 - ETL2 - INI - AGGIORNA ALL_DATA', PKG_MCRE0_AUDIT.C_DEBUG, sqlcode, 'INIZIO', 'INIZIO - eseguito Ricarico All_Data');
            RetVal := MCRE_OWN.PKG_MCRE0_GESTIONE_ALL_DATA.LOAD_ALL_DATA(seq);
            PKG_MCRE0_AUDIT.log_etl (seq,'3_1 - ETL2 - END - AGGIORNA ALL_DATA', PKG_MCRE0_AUDIT.C_DEBUG, sqlcode, 'Esito '||RetVal, 'FINE - eseguito Ricarico All_Data');
            esito := esito+RetVal;
            PKG_MCRE0_AUDIT.log_etl (seq, '3_1 - PKG_MCRE0_TWS_20111129 - END - LIVELLO3_G1', PKG_MCRE0_AUDIT.C_DEBUG, sqlcode, 'FINE', 'FINE');
            return ok;

        EXCEPTION WHEN OTHERS THEN
            PKG_MCRE0_AUDIT.log_etl ('PKG_MCRE0_TWS_20111129 ERROR - LIVELLO_3 GRUPPO_1', PKG_MCRE0_AUDIT.C_ERROR, sqlcode, sqlerrm, 'Errore in ERROR - LIVELLO_3 GRUPPO_1');
            return ko;
        END TWS_MCRE0_LIVELLO3_G1;

        FUNCTION TWS_MCRE0_LIVELLO3_G2 return number IS

        BEGIN
            select SEQ_MCR0_LOG_ETL.nextval into seq from dual;
            PKG_MCRE0_AUDIT.log_etl (seq, '3_2 - PKG_MCRE0_TWS_20111129 - INI - LIVELLO3_G2', PKG_MCRE0_AUDIT.C_DEBUG, sqlcode, 'INIZIO', 'INIZIO');
            esito:=0;
            --riempo la tabellona CR
            PKG_MCRE0_AUDIT.log_etl (seq,'3_2 - INI - CR ', PKG_MCRE0_AUDIT.C_DEBUG, sqlcode, 'INIZIO', 'INIZIO - eseguito Calcolo CR');
            RetVal := MCRE_OWN.PKG_MCRE0_CR.FNC_LOAD_CR(seq);
            PKG_MCRE0_AUDIT.log_etl (seq,'3_2 - END - CR ', PKG_MCRE0_AUDIT.C_DEBUG, sqlcode, 'Esito '||RetVal, 'FINE - eseguito Calcolo CR');
            esito := esito+RetVal;

              begin
                PKG_MCRE0_AUDIT.log_etl (seq,'3_2 - INI - ANALYZE CR ', PKG_MCRE0_AUDIT.C_DEBUG, sqlcode, 'INIZIO', 'INIZIO - eseguito Analyze CR');
                 if( MCRE_OWN.PKG_MCRE0_ANALYZE.FND_MCRE0_ANALYZE_TABLE_APP ( 'MCRE_OWN', 'T_MCRE0_APP_CR' ) )then
                     esito := esito+1;
                     PKG_MCRE0_AUDIT.log_etl (seq,'3_2 - ETL2 - CR ', PKG_MCRE0_AUDIT.C_DEBUG, sqlcode, 'Esito 1', 'FINE - eseguito Analyze CR');
                 else
                     PKG_MCRE0_AUDIT.log_etl (seq,'3_2 - ETL2 - CR ', PKG_MCRE0_AUDIT.C_DEBUG, sqlcode, 'Esito 0', 'FINE - impossibile eseguire Analyze CR');
                 end if;
              exception when others then
              PKG_MCRE0_AUDIT.log_etl (seq,'3_2 - END - ANALYZE CR ', 1, sqlcode, 'Esito 0 '||SQLERRM, 'impossibile eseguire Analyze CR');
              end;
            PKG_MCRE0_AUDIT.log_etl (seq, '3_2 - PKG_MCRE0_TWS_20111129 - END - LIVELLO3_G2', PKG_MCRE0_AUDIT.C_DEBUG, sqlcode, 'FINE', 'FINE');
            return ok;

        EXCEPTION WHEN OTHERS THEN
            PKG_MCRE0_AUDIT.log_etl ('3_2 - PKG_MCRE0_TWS_20111129 ERROR - LIVELLO_3 GRUPPO_2', PKG_MCRE0_AUDIT.C_ERROR, sqlcode, sqlerrm, 'Errore in ERROR - LIVELLO_3 GRUPPO_2');
            return ko;
        END TWS_MCRE0_LIVELLO3_G2;



    FUNCTION TWS_MCRE0_LIVELLO4_G1 return number IS

        BEGIN
            select SEQ_MCR0_LOG_ETL.nextval into seq from dual;
            PKG_MCRE0_AUDIT.log_etl (seq, '4_1 - PKG_MCRE0_TWS_20111129 - INI - LIVELLO4_G1', PKG_MCRE0_AUDIT.C_DEBUG, sqlcode, 'INIZIO', 'INIZIO');
            esito:=0;
            -- PT
            PKG_MCRE0_AUDIT.log_etl (seq, '4_1 - PKG_MCRE0_TWS_20111129 - INI - Delete PT', PKG_MCRE0_AUDIT.C_DEBUG, sqlcode, 'INIZIO', 'INIZIO - Delete PT');
            RetVal := PKG_MCRE0_PORTALE_GEST_STATI.FNC_DELETE_PT(SEQ);
            PKG_MCRE0_AUDIT.log_etl (seq, '4_1 - PKG_MCRE0_TWS_20111129 - END - Delete PT', PKG_MCRE0_AUDIT.C_DEBUG, sqlcode, 'Esito '||RetVal, 'FINE - Delete PT');
            esito := esito+RetVal;
            -- RIO
            PKG_MCRE0_AUDIT.log_etl (seq, '4_1 - PKG_MCRE0_TWS_20111129 - INI - Delete RIO', PKG_MCRE0_AUDIT.C_DEBUG, sqlcode, 'INIZIO', 'INIZIO - Delete RIO');
            RetVal := PKG_MCRE0_PORTALE_GEST_STATI.FNC_DELETE_RIO(SEQ);
            PKG_MCRE0_AUDIT.log_etl (seq, '4_1 - PKG_MCRE0_TWS_20111129 - END - Delete RIO', PKG_MCRE0_AUDIT.C_DEBUG, sqlcode, 'Esito '||RetVal, 'FINE - Delete RIO');
            esito := esito+RetVal;
            -- GB
            PKG_MCRE0_AUDIT.log_etl (seq,'4_1 - INI - CLEAN STATI', PKG_MCRE0_AUDIT.C_DEBUG, sqlcode, 'INIZIO', 'INIZIO - eseguito Delete GB');
            RetVal := PKG_MCRE0_PORTALE_GEST_STATI.FNC_DELETE_GB(SEQ);
            PKG_MCRE0_AUDIT.log_etl (seq,'4_1 - END - CLEAN STATI', PKG_MCRE0_AUDIT.C_DEBUG, sqlcode, 'Esito '||RetVal, 'FINE - eseguito Delete GB');
            esito := esito+RetVal;          
            -- Anagrafica generale --spostata!ex 5_1 v2.1
            PKG_MCRE0_AUDIT.log_etl (seq, '4_1 - PKG_MCRE0_TWS_20111129 - INI - Aggiorna AnaGen in seguito ai caricamenti', PKG_MCRE0_AUDIT.C_DEBUG, sqlcode, 'Esito 1', 'INIZIO - Aggiorna AnaGen in seguito ai caricamenti');
            RetVal := MCRE_OWN.PKG_MCRE0_AGGIORNA_MV.aggiorna_AnaGenETL(seq);
            PKG_MCRE0_AUDIT.log_etl (seq, '4_1 - PKG_MCRE0_TWS_20111129 - END - Aggiorna AnaGen in seguito ai caricamenti', PKG_MCRE0_AUDIT.C_DEBUG, sqlcode, 'Esito '||RetVal, 'FINE - Aggiorna AnaGen in seguito ai caricamenti');
            esito := esito+RetVal;
            PKG_MCRE0_AUDIT.log_etl (seq, '4_1 - PKG_MCRE0_TWS_20111129 - END - LIVELLO4_G1', PKG_MCRE0_AUDIT.C_DEBUG, sqlcode, 'FINE', 'FINE');
            return ok;
        EXCEPTION WHEN OTHERS THEN
            PKG_MCRE0_AUDIT.log_etl ('4_1 - PKG_MCRE0_TWS_20111129 ERROR - LIVELLO_4 GRUPPO_1', PKG_MCRE0_AUDIT.C_ERROR, sqlcode, sqlerrm, 'Errore in ERROR - LIVELLO_4 GRUPPO_1');
            return ko;
        END TWS_MCRE0_LIVELLO4_G1;
        FUNCTION TWS_MCRE0_LIVELLO5_G1 return number IS
        BEGIN
            select SEQ_MCR0_LOG_ETL.nextval into seq from dual;
            PKG_MCRE0_AUDIT.log_etl (seq, '5_1 - PKG_MCRE0_TWS_20111129 - INI - LIVELLO5_G1', PKG_MCRE0_AUDIT.C_DEBUG, sqlcode, 'INIZIO', 'INIZIO');
            esito:=0;
            -- Anagrafica generale
--            PKG_MCRE0_AUDIT.log_etl (seq, '5_1 - PKG_MCRE0_TWS_20111129 - INI - Aggiorna AnaGen in seguito ai caricamenti', PKG_MCRE0_AUDIT.C_DEBUG, sqlcode, 'Esito 1', 'INIZIO - Aggiorna AnaGen in seguito ai caricamenti');
--            RetVal := MCRE_OWN.PKG_MCRE0_AGGIORNA_MV.aggiorna_AnaGenETL(seq);
--            PKG_MCRE0_AUDIT.log_etl (seq, '5_1 - PKG_MCRE0_TWS_20111129 - END - Aggiorna AnaGen in seguito ai caricamenti', PKG_MCRE0_AUDIT.C_DEBUG, sqlcode, 'Esito '||RetVal, 'FINE - Aggiorna AnaGen in seguito ai caricamenti');
--            esito := esito+RetVal;            
            -- Uscite Aut - ex 5_7 v2.1
            PKG_MCRE0_AUDIT.log_etl (seq, '5_1 - PKG_MCRE0_TWS_20111129 - INI - Aggiorna Uscite Aut in seguito ai caricamenti', PKG_MCRE0_AUDIT.C_DEBUG, sqlcode, 'INIZIO', 'INIZIO - Aggiorna Uscite Aut in seguito ai caricamenti');
            RETVAL := MCRE_OWN.PKG_MCRE0_AGGIORNA_MV.AGGIORNA_USCITE_AUT(seq);
            PKG_MCRE0_AUDIT.log_etl (seq, '5_1 - PKG_MCRE0_TWS_20111129 - END - Aggiorna Uscite Aut in seguito ai caricamenti', PKG_MCRE0_AUDIT.C_DEBUG, sqlcode, 'Esito '||RetVal, 'FINE - Aggiorna Uscite Aut in seguito ai caricamenti');
            --Uscite Man - ex 5_8 v2.1
            PKG_MCRE0_AUDIT.log_etl (seq, '5_1 - PKG_MCRE0_TWS_20111129 - INI - Aggiorna Uscite Man in seguito ai caricamenti', PKG_MCRE0_AUDIT.C_DEBUG, sqlcode, 'INIZIO', 'INIZIO - Aggiorna Uscite Man in seguito ai caricamenti');
            RETVAL := MCRE_OWN.PKG_MCRE0_AGGIORNA_MV.AGGIORNA_USCITE_MAN(seq);
            PKG_MCRE0_AUDIT.log_etl (seq, '5_1 - PKG_MCRE0_TWS_20111129 - END - Aggiorna Uscite Man in seguito ai caricamenti', PKG_MCRE0_AUDIT.C_DEBUG, sqlcode, 'Esito '||RetVal, 'FINE - Aggiorna Uscite Man in seguito ai caricamenti');
            ESITO := ESITO+RETVAL;

            PKG_MCRE0_AUDIT.log_etl (seq, '5_1 - PKG_MCRE0_TWS_20111129 - END - LIVELLO5_G1', PKG_MCRE0_AUDIT.C_DEBUG, sqlcode, 'FINE', 'FINE');
            return ok;
        EXCEPTION WHEN OTHERS THEN
        PKG_MCRE0_AUDIT.log_etl ('5_1 - PKG_MCRE0_TWS_20111129 ERROR - LIVELLO_5 GRUPPO_1', PKG_MCRE0_AUDIT.C_ERROR, sqlcode, sqlerrm, 'Errore in ERROR - LIVELLO_5 GRUPPO_1');
            return ko;
        END TWS_MCRE0_LIVELLO5_G1;
  
  
    FUNCTION TWS_MCRE0_LIVELLO5_G2 return number IS
         BEGIN
            select SEQ_MCR0_LOG_ETL.nextval into seq from dual;
            PKG_MCRE0_AUDIT.log_etl (seq, '5_2 - PKG_MCRE0_TWS_20111129 - INI - LIVELLO5_G2', PKG_MCRE0_AUDIT.C_DEBUG, sqlcode, 'INIZIO', 'INIZIO');
            esito:=0;
            PKG_MCRE0_AUDIT.log_etl (seq, '5_2 - PKG_MCRE0_TWS_20111129 - INI - Aggiorna Rio Monit. in seguito ai caricamenti', PKG_MCRE0_AUDIT.C_DEBUG, sqlcode, 'Esito 1', 'INIZIO - Aggiorna Rio Monit. in seguito ai caricamenti');
            RETVAL := MCRE_OWN.PKG_MCRE0_AGGIORNA_MV.aggiorna_RIO_MONITORAGGIO(seq);
            PKG_MCRE0_AUDIT.log_etl (seq, '5_2 - PKG_MCRE0_TWS_20111129 - END - Aggiorna Rio Monit. in seguito ai caricamenti', PKG_MCRE0_AUDIT.C_DEBUG, sqlcode, 'Esito '||RetVal, 'FINE - Aggiorna Rio Monit. in seguito ai caricamenti');
            ESITO := ESITO+RETVAL;
            -- MV CR
            PKG_MCRE0_AUDIT.log_etl (seq,'5_2 - ETL2 - INI - AGGIORNA MV', PKG_MCRE0_AUDIT.C_DEBUG, sqlcode, 'INIZIO', 'INIZIO - eseguito Aggiorna CR.');
            RETVAL := MCRE_OWN.PKG_MCRE0_AGGIORNA_MV.AGGIORNA_CR_ALL(seq);
            PKG_MCRE0_AUDIT.log_etl (seq,'5_2 - ETL2 - END - AGGIORNA MV', PKG_MCRE0_AUDIT.C_DEBUG, sqlcode, 'Esito '||RetVal, 'FINE - eseguito Aggiorna CR.');
            ESITO := ESITO+RETVAL;
--            PKG_MCRE0_AUDIT.log_etl (seq,'5_2 - ETL2 - INI - FNC_VERIFICA_ALERT_BLOCCO 1', PKG_MCRE0_AUDIT.C_DEBUG, sqlcode, 'INIZIO', 'INIZIO - FNC_VERIFICA_ALERT_BLOCCO 1.');
--            RetVal := MCRE_OWN.PKG_MCRE0_ALERT.FNC_VERIFICA_ALERT_BLOCCO ( seq, 1 );
--            PKG_MCRE0_AUDIT.log_etl (seq,'5_2 - ETL2 - END - FNC_VERIFICA_ALERT_BLOCCO 1', PKG_MCRE0_AUDIT.C_DEBUG, sqlcode, 'Esito '||RETVAL, 'FINE - FNC_VERIFICA_ALERT_BLOCCO 1.');
            PKG_MCRE0_AUDIT.log_etl (seq, '5_2 - PKG_MCRE0_TWS_20111129 - END - LIVELLO5_G2', PKG_MCRE0_AUDIT.C_DEBUG, sqlcode, 'FINE', 'FINE');           
                        return ok;
        EXCEPTION WHEN OTHERS THEN
            PKG_MCRE0_AUDIT.log_etl ('5_2 - PKG_MCRE0_TWS_20111129 ERROR - LIVELLO_5 GRUPPO_2', PKG_MCRE0_AUDIT.C_ERROR, sqlcode, sqlerrm, 'Errore in ERROR - LIVELLO_5 GRUPPO_2');
            return ko;
        END TWS_MCRE0_LIVELLO5_G2;

    FUNCTION TWS_MCRE0_LIVELLO5_G3 return number IS
         BEGIN
            select SEQ_MCR0_LOG_ETL.nextval into seq from dual;           
            PKG_MCRE0_AUDIT.log_etl (seq, '5_3 - PKG_MCRE0_TWS_20111129 - INI - LIVELLO5_G3', PKG_MCRE0_AUDIT.C_DEBUG, sqlcode, 'INIZIO', 'INIZIO');
            esito:=0;
            PKG_MCRE0_AUDIT.log_etl (seq, '5_3 - PKG_MCRE0_TWS_20111129 - INI - Aggiorna Rio ESP SC in seguito ai caricamenti', PKG_MCRE0_AUDIT.C_DEBUG, sqlcode, 'INIZIO', 'INIZIO - Aggiorna Rio ESP SC in seguito ai caricamenti');
            RETVAL := MCRE_OWN.PKG_MCRE0_AGGIORNA_MV.aggiorna_RIO_ESP_SC(seq);
            PKG_MCRE0_AUDIT.log_etl (seq, '5_3 - PKG_MCRE0_TWS_20111129 - END - Aggiorna Rio ESP SC in seguito ai caricamenti', PKG_MCRE0_AUDIT.C_DEBUG, sqlcode, 'Esito '||RetVal, 'FINE - Aggiorna Rio ESP SC in seguito ai caricamenti');
            ESITO := ESITO+RETVAL;
            --v2.1
            PKG_MCRE0_AUDIT.log_etl (seq, '5_3 - PKG_MCRE0_TWS_20111129 - INI - Aggiorna Rio ESP SC Ann in seguito ai caricamenti', PKG_MCRE0_AUDIT.C_DEBUG, sqlcode, 'INIZIO', 'INIZIO - Aggiorna Rio ESP SC Ann in seguito ai caricamenti');
            RETVAL := MCRE_OWN.PKG_MCRE0_AGGIORNA_MV.aggiorna_RIO_ESP_SC_ANN(seq);
            PKG_MCRE0_AUDIT.log_etl (seq, '5_3 - PKG_MCRE0_TWS_20111129 - END - Aggiorna Rio ESP SC Ann in seguito ai caricamenti', PKG_MCRE0_AUDIT.C_DEBUG, sqlcode, 'Esito '||RetVal, 'FINE - Aggiorna Rio ESP SC Ann in seguito ai caricamenti');
            ESITO := ESITO+RETVAL;
--            PKG_MCRE0_AUDIT.log_etl (seq,'5_3 - ETL2 - INI - FNC_VERIFICA_ALERT_BLOCCO 2', PKG_MCRE0_AUDIT.C_DEBUG, sqlcode, 'INIZIO', 'INIZIO - FNC_VERIFICA_ALERT_BLOCCO 2.');
--            RetVal := MCRE_OWN.PKG_MCRE0_ALERT.FNC_VERIFICA_ALERT_BLOCCO ( seq, 2 );
--            PKG_MCRE0_AUDIT.log_etl (seq,'5_3 - ETL2 - END - FNC_VERIFICA_ALERT_BLOCCO 2', PKG_MCRE0_AUDIT.C_DEBUG, sqlcode, 'Esito '||RETVAL, 'FINE - FNC_VERIFICA_ALERT_BLOCCO 2.');
            PKG_MCRE0_AUDIT.log_etl (seq, '5_3 - PKG_MCRE0_TWS_20111129 - END - LIVELLO5_G3', PKG_MCRE0_AUDIT.C_DEBUG, sqlcode, 'FINE', 'FINE');
            return ok;
        EXCEPTION WHEN OTHERS THEN
            PKG_MCRE0_AUDIT.log_etl ('5_3 - PKG_MCRE0_TWS_20111129 ERROR - LIVELLO_5 GRUPPO_3', PKG_MCRE0_AUDIT.C_ERROR, sqlcode, sqlerrm, 'Errore in ERROR - LIVELLO_5 GRUPPO_3');
            return ko;
        END TWS_MCRE0_LIVELLO5_G3;

    FUNCTION TWS_MCRE0_LIVELLO5_G4 return number IS
         BEGIN
            select SEQ_MCR0_LOG_ETL.nextval into seq from dual;
            PKG_MCRE0_AUDIT.log_etl (seq, '5_4 - PKG_MCRE0_TWS_20111129 - INI - LIVELLO5_G4', PKG_MCRE0_AUDIT.C_DEBUG, sqlcode, 'INIZIO', 'INIZIO');
            esito:=0;
--            PKG_MCRE0_AUDIT.log_etl (seq, '5_4 - PKG_MCRE0_TWS_20111129 - INI - Aggiorna Rio ESP SC Ann in seguito ai caricamenti', PKG_MCRE0_AUDIT.C_DEBUG, sqlcode, 'INIZIO', 'INIZIO - Aggiorna Rio ESP SC Ann in seguito ai caricamenti');
--            RETVAL := MCRE_OWN.PKG_MCRE0_AGGIORNA_MV.aggiorna_RIO_ESP_SC_ANN(seq);
--            PKG_MCRE0_AUDIT.log_etl (seq, '5_4 - PKG_MCRE0_TWS_20111129 - END - Aggiorna Rio ESP SC Ann in seguito ai caricamenti', PKG_MCRE0_AUDIT.C_DEBUG, sqlcode, 'Esito '||RetVal, 'FINE - Aggiorna Rio ESP SC Ann in seguito ai caricamenti');
--            ESITO := ESITO+RETVAL;
--            PKG_MCRE0_AUDIT.log_etl (seq,'5_4 - ETL2 - INI - FNC_VERIFICA_ALERT_BLOCCO 3', PKG_MCRE0_AUDIT.C_DEBUG, sqlcode, 'INIZIO', 'INIZIO - FNC_VERIFICA_ALERT_BLOCCO 3.');
--            RetVal := MCRE_OWN.PKG_MCRE0_ALERT.FNC_VERIFICA_ALERT_BLOCCO ( seq, 3 );
--            PKG_MCRE0_AUDIT.log_etl (seq,'5_4 - ETL2 - END - FNC_VERIFICA_ALERT_BLOCCO 3', PKG_MCRE0_AUDIT.C_DEBUG, sqlcode, 'Esito '||RETVAL, 'FINE - FNC_VERIFICA_ALERT_BLOCCO 3.');
            PKG_MCRE0_AUDIT.log_etl (seq, '5_4 - PKG_MCRE0_TWS_20111129 - END - LIVELLO5_G4', PKG_MCRE0_AUDIT.C_DEBUG, sqlcode, 'FINE', 'FINE');
            return ok;
        EXCEPTION WHEN OTHERS THEN
            PKG_MCRE0_AUDIT.log_etl ('5_4 - PKG_MCRE0_TWS_20111129 ERROR - LIVELLO_5 GRUPPO_4', PKG_MCRE0_AUDIT.C_ERROR, sqlcode, sqlerrm, 'Errore in ERROR - LIVELLO_5 GRUPPO_4');
            return ko;
        END TWS_MCRE0_LIVELLO5_G4;

    FUNCTION TWS_MCRE0_LIVELLO5_G5 return number IS
         BEGIN
            select SEQ_MCR0_LOG_ETL.nextval into seq from dual;
            PKG_MCRE0_AUDIT.log_etl (seq, '5_5 - PKG_MCRE0_TWS_20111129 - INI - LIVELLO5_G5', PKG_MCRE0_AUDIT.C_DEBUG, sqlcode, 'INIZIO', 'INIZIO');
            esito:=0;
            PKG_MCRE0_AUDIT.log_etl (seq, '5_5 - PKG_MCRE0_TWS_20111129 - INI - Aggiorna Rio ESP GE in seguito ai caricamenti', PKG_MCRE0_AUDIT.C_DEBUG, sqlcode, 'INIZIO', 'INIZIO - Aggiorna Rio ESP GE in seguito ai caricamenti');
            RETVAL := MCRE_OWN.PKG_MCRE0_AGGIORNA_MV.aggiorna_RIO_ESP_GE(seq);
            PKG_MCRE0_AUDIT.log_etl (seq, '5_5 - PKG_MCRE0_TWS_20111129 - END - Aggiorna Rio ESP GE in seguito ai caricamenti', PKG_MCRE0_AUDIT.C_DEBUG, sqlcode, 'Esito '||RetVal, 'FINE - Aggiorna Rio ESP GE in seguito ai caricamenti');
            ESITO := ESITO+RETVAL;
            PKG_MCRE0_AUDIT.log_etl (seq, '5_5 - PKG_MCRE0_TWS_20111129 - INI - Aggiorna Rio ESP GE Ann in seguito ai caricamenti', PKG_MCRE0_AUDIT.C_DEBUG, sqlcode, 'INIZIO', 'INIZIO - Aggiorna Rio ESP GE Ann in seguito ai caricamenti');
            RETVAL := MCRE_OWN.PKG_MCRE0_AGGIORNA_MV.aggiorna_RIO_ESP_GE_ANN(seq);
            PKG_MCRE0_AUDIT.log_etl (seq, '5_5 - PKG_MCRE0_TWS_20111129 - END - Aggiorna Rio ESP GE Ann in seguito ai caricamenti', PKG_MCRE0_AUDIT.C_DEBUG, sqlcode, 'Esito '||RetVal, 'FINE - Aggiorna Rio ESP GE Ann in seguito ai caricamenti');
            ESITO := ESITO+RETVAL;
--            PKG_MCRE0_AUDIT.log_etl (seq,'5_5 - ETL2 - INI - FNC_VERIFICA_ALERT_BLOCCO 4', PKG_MCRE0_AUDIT.C_DEBUG, sqlcode, 'INIZIO', 'INIZIO - FNC_VERIFICA_ALERT_BLOCCO 4.');
--            RetVal := MCRE_OWN.PKG_MCRE0_ALERT.FNC_VERIFICA_ALERT_BLOCCO ( seq, 4 );
--            PKG_MCRE0_AUDIT.log_etl (seq,'5_5 - ETL2 - INI - FNC_VERIFICA_ALERT_BLOCCO 4', PKG_MCRE0_AUDIT.C_DEBUG, sqlcode, 'Esito '||RETVAL, 'FINE - FNC_VERIFICA_ALERT_BLOCCO 4.');
            PKG_MCRE0_AUDIT.log_etl (seq, '5_5 - PKG_MCRE0_TWS_20111129 - END - LIVELLO5_G5', PKG_MCRE0_AUDIT.C_DEBUG, sqlcode, 'FINE', 'FINE');
            return ok;
        EXCEPTION WHEN OTHERS THEN
            PKG_MCRE0_AUDIT.log_etl ('5_5 - PKG_MCRE0_TWS_20111129 ERROR - LIVELLO_5 GRUPPO_5', PKG_MCRE0_AUDIT.C_ERROR, sqlcode, sqlerrm, 'Errore in ERROR - LIVELLO_5 GRUPPO_5');
            return ko;
        END TWS_MCRE0_LIVELLO5_G5;

    FUNCTION TWS_MCRE0_LIVELLO5_G6 return number IS
         BEGIN
            select SEQ_MCR0_LOG_ETL.nextval into seq from dual;
            PKG_MCRE0_AUDIT.log_etl (seq, '5_6 - PKG_MCRE0_TWS_20111129 - INI - LIVELLO5_G6', PKG_MCRE0_AUDIT.C_DEBUG, sqlcode, 'INIZIO', 'INIZIO');
            esito:=0;
--            PKG_MCRE0_AUDIT.log_etl (seq, '5_6 - PKG_MCRE0_TWS_20111129 - INI - Aggiorna Rio ESP GE Ann in seguito ai caricamenti', PKG_MCRE0_AUDIT.C_DEBUG, sqlcode, 'INIZIO', 'INIZIO - Aggiorna Rio ESP GE Ann in seguito ai caricamenti');
--            RETVAL := MCRE_OWN.PKG_MCRE0_AGGIORNA_MV.aggiorna_RIO_ESP_GE_ANN(seq);
--            PKG_MCRE0_AUDIT.log_etl (seq, '5_6 - PKG_MCRE0_TWS_20111129 - END - Aggiorna Rio ESP GE Ann in seguito ai caricamenti', PKG_MCRE0_AUDIT.C_DEBUG, sqlcode, 'Esito '||RetVal, 'FINE - Aggiorna Rio ESP GE Ann in seguito ai caricamenti');
--            ESITO := ESITO+RETVAL;
--            PKG_MCRE0_AUDIT.log_etl (seq,'5_6 - ETL2 - INI - FNC_VERIFICA_ALERT_BLOCCO 5', PKG_MCRE0_AUDIT.C_DEBUG, sqlcode, 'INIZIO', 'INIZIO - FNC_VERIFICA_ALERT_BLOCCO 5.');
--            RetVal := MCRE_OWN.PKG_MCRE0_ALERT.FNC_VERIFICA_ALERT_BLOCCO ( seq, 5 );
--            PKG_MCRE0_AUDIT.log_etl (seq,'5_6 - ETL2 - END - FNC_VERIFICA_ALERT_BLOCCO 5', PKG_MCRE0_AUDIT.C_DEBUG, sqlcode, 'Esito '||RETVAL, 'FINE - FNC_VERIFICA_ALERT_BLOCCO 5.');
            PKG_MCRE0_AUDIT.log_etl (seq, '5_6 - PKG_MCRE0_TWS_20111129 - END - LIVELLO5_G6', PKG_MCRE0_AUDIT.C_DEBUG, sqlcode, 'FINE', 'FINE');
            return ok;
        EXCEPTION WHEN OTHERS THEN
            PKG_MCRE0_AUDIT.log_etl ('5_6 - PKG_MCRE0_TWS_20111129 ERROR - LIVELLO_5 GRUPPO_6', PKG_MCRE0_AUDIT.C_ERROR, sqlcode, sqlerrm, 'Errore in ERROR - LIVELLO_5 GRUPPO_6');
            return ko;
        END TWS_MCRE0_LIVELLO5_G6;

    FUNCTION TWS_MCRE0_LIVELLO5_G7 return number IS
         BEGIN
            select SEQ_MCR0_LOG_ETL.nextval into seq from dual;
            PKG_MCRE0_AUDIT.log_etl (seq, '5_7 - PKG_MCRE0_TWS_20111129 - INI - LIVELLO5_G7', PKG_MCRE0_AUDIT.C_DEBUG, sqlcode, 'INIZIO', 'INIZIO');
            esito:=0;
--            PKG_MCRE0_AUDIT.log_etl (seq, '5_7 - PKG_MCRE0_TWS_20111129 - INI - Aggiorna Uscite Aut in seguito ai caricamenti', PKG_MCRE0_AUDIT.C_DEBUG, sqlcode, 'INIZIO', 'INIZIO - Aggiorna Uscite Aut in seguito ai caricamenti');
--            RETVAL := MCRE_OWN.PKG_MCRE0_AGGIORNA_MV.AGGIORNA_USCITE_AUT(seq);
--            PKG_MCRE0_AUDIT.log_etl (seq, '5_7 - PKG_MCRE0_TWS_20111129 - END - Aggiorna Uscite Aut in seguito ai caricamenti', PKG_MCRE0_AUDIT.C_DEBUG, sqlcode, 'Esito '||RetVal, 'FINE - Aggiorna Uscite Aut in seguito ai caricamenti');
--            ESITO := ESITO+RETVAL;
--            PKG_MCRE0_AUDIT.log_etl (seq,'5_7 - ETL2 - INI - FNC_VERIFICA_ALERT_BLOCCO 6', PKG_MCRE0_AUDIT.C_DEBUG, sqlcode, 'INIZIO', 'INIZIO - FNC_VERIFICA_ALERT_BLOCCO 6.');
--            RetVal := MCRE_OWN.PKG_MCRE0_ALERT.FNC_VERIFICA_ALERT_BLOCCO ( seq, 6 );
--            PKG_MCRE0_AUDIT.log_etl (seq,'5_7 - ETL2 - END - FNC_VERIFICA_ALERT_BLOCCO 6', PKG_MCRE0_AUDIT.C_DEBUG, sqlcode, 'Esito '||RETVAL, 'FINE - FNC_VERIFICA_ALERT_BLOCCO 6.');
            PKG_MCRE0_AUDIT.log_etl (seq, '5_7 - PKG_MCRE0_TWS_20111129 - END - LIVELLO5_G7', PKG_MCRE0_AUDIT.C_DEBUG, sqlcode, 'FINE', 'FINE');
            return ok;
        EXCEPTION WHEN OTHERS THEN
            PKG_MCRE0_AUDIT.log_etl ('5_7 - PKG_MCRE0_TWS_20111129 ERROR - LIVELLO_5 GRUPPO_7', PKG_MCRE0_AUDIT.C_ERROR, sqlcode, sqlerrm, 'Errore in ERROR - LIVELLO_5 GRUPPO_7');
            return ko;
        END TWS_MCRE0_LIVELLO5_G7;

    FUNCTION TWS_MCRE0_LIVELLO5_G8 return number IS
         BEGIN
            select SEQ_MCR0_LOG_ETL.nextval into seq from dual;
            PKG_MCRE0_AUDIT.log_etl (seq, '5_8 - PKG_MCRE0_TWS_20111129 - INI - LIVELLO5_G8', PKG_MCRE0_AUDIT.C_DEBUG, sqlcode, 'INIZIO', 'INIZIO');
            esito:=0;
--            PKG_MCRE0_AUDIT.log_etl (seq, '5_8 - PKG_MCRE0_TWS_20111129 - INI - Aggiorna Uscite Man in seguito ai caricamenti', PKG_MCRE0_AUDIT.C_DEBUG, sqlcode, 'INIZIO', 'INIZIO - Aggiorna Uscite Man in seguito ai caricamenti');
--            RETVAL := MCRE_OWN.PKG_MCRE0_AGGIORNA_MV.AGGIORNA_USCITE_MAN(seq);
--            PKG_MCRE0_AUDIT.log_etl (seq, '5_8 - PKG_MCRE0_TWS_20111129 - END - Aggiorna Uscite Man in seguito ai caricamenti', PKG_MCRE0_AUDIT.C_DEBUG, sqlcode, 'Esito '||RetVal, 'FINE - Aggiorna Uscite Man in seguito ai caricamenti');
--            ESITO := ESITO+RETVAL;
--            PKG_MCRE0_AUDIT.log_etl (seq,'5_8 - ETL2 - INI - FNC_VERIFICA_ALERT_BLOCCO 7', PKG_MCRE0_AUDIT.C_DEBUG, sqlcode, 'INIZIO', 'INIZIO - FNC_VERIFICA_ALERT_BLOCCO 7.');
--            RetVal := MCRE_OWN.PKG_MCRE0_ALERT.FNC_VERIFICA_ALERT_BLOCCO ( seq, 7 );
--            PKG_MCRE0_AUDIT.log_etl (seq,'5_8 - ETL2 - END - FNC_VERIFICA_ALERT_BLOCCO 7', PKG_MCRE0_AUDIT.C_DEBUG, sqlcode, 'Esito '||RETVAL, 'FINE - FNC_VERIFICA_ALERT_BLOCCO 7.');
            PKG_MCRE0_AUDIT.log_etl (seq, '5_8 - PKG_MCRE0_TWS_20111129 - END - LIVELLO5_G8', PKG_MCRE0_AUDIT.C_DEBUG, sqlcode, 'FINE', 'FINE');
            return ok;
        EXCEPTION WHEN OTHERS THEN
            PKG_MCRE0_AUDIT.log_etl ('5_8 - PKG_MCRE0_TWS_20111129 ERROR - LIVELLO_5 GRUPPO_8', PKG_MCRE0_AUDIT.C_ERROR, sqlcode, sqlerrm, 'Errore in ERROR - LIVELLO_5 GRUPPO_8');
            return ko;
        END TWS_MCRE0_LIVELLO5_G8;

    FUNCTION TWS_MCRE0_LIVELLO5_G9 return number IS

        v_new_per date;
        v_last_period date;
        v_last_month number;

         BEGIN
            select SEQ_MCR0_LOG_ETL.nextval into seq from dual;
            PKG_MCRE0_AUDIT.log_etl (seq, '5_9 - PKG_MCRE0_TWS_20111129 - INI - LIVELLO5_G9', PKG_MCRE0_AUDIT.C_DEBUG, sqlcode, 'INIZIO', 'INIZIO');
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
                PKG_MCRE0_AUDIT.log_etl (seq, '5_9 - PKG_MCRE0_TWS_20111129 - INI - Aggiorna POS_STATO_STORICO aggiornamento effettuato', PKG_MCRE0_AUDIT.C_DEBUG, sqlcode, 'INIZIO', 'INIZIO - Aggiorna POS_STATO_STORICO aggiornamento effettuato');
                RETVAL := MCRE_OWN.PKG_MCRE0_AGGIORNA_MV.aggiorna_pos_stato_st;
                PKG_MCRE0_AUDIT.log_etl (seq, '5_9 - PKG_MCRE0_TWS_20111129 - END - Aggiorna POS_STATO_STORICO aggiornamento effettuato', PKG_MCRE0_AUDIT.C_DEBUG, sqlcode, 'Esito '||RETVAL, 'FINE - Aggiorna POS_STATO_STORICO aggiornamento effettuato');                                                           
                ESITO := ESITO+RETVAL;                
            END IF; 
--            PKG_MCRE0_AUDIT.log_etl (seq,'5_9 - ETL2 - FNC_VERIFICA_ALERT_BLOCCO 8', PKG_MCRE0_AUDIT.C_DEBUG, sqlcode, 'INIZIO', 'INIZIO - FNC_VERIFICA_ALERT_BLOCCO 8.');
--            RetVal := MCRE_OWN.PKG_MCRE0_ALERT.FNC_VERIFICA_ALERT_BLOCCO ( seq, 8 );
--            PKG_MCRE0_AUDIT.log_etl (seq,'5_9 - ETL2 - FNC_VERIFICA_ALERT_BLOCCO 8', PKG_MCRE0_AUDIT.C_DEBUG, sqlcode, 'Esito '||RETVAL, 'FINE - FNC_VERIFICA_ALERT_BLOCCO 8.');
            PKG_MCRE0_AUDIT.log_etl (seq, '5_9 - PKG_MCRE0_TWS_20111129 - END - LIVELLO5_G9', PKG_MCRE0_AUDIT.C_DEBUG, sqlcode, 'FINE', 'FINE');
            return ok;
        EXCEPTION WHEN OTHERS THEN
            PKG_MCRE0_AUDIT.log_etl ('5_9 - PKG_MCRE0_TWS_20111129 ERROR - LIVELLO_5 GRUPPO_9', PKG_MCRE0_AUDIT.C_ERROR, sqlcode, sqlerrm, 'Errore in ERROR - LIVELLO_5 GRUPPO_9');
            return ko;
        END TWS_MCRE0_LIVELLO5_G9;

    FUNCTION TWS_MCRE0_LIVELLO6_G1 return number IS

        BEGIN
            
            select SEQ_MCR0_LOG_ETL.nextval into seq from dual;
            select COUNT(*) into V_TOT_ALERT
            from T_MCRE0_APP_ALERT
            where FLG_ATTIVO = 'A';
            V_RESULT_CLEAN := PKG_MCRE0_ALERT.FNC_CLEAN_ALERT(seq);
                    
            if(V_TOT_ALERT=V_RESULT_CLEAN) then
             RETVAL := 1;
             else
             RETVAL := 0;
            end if;
            PKG_MCRE0_AUDIT.log_etl (seq, '6_1 - PKG_MCRE0_TWS_20111129 - INI - LIVELLO6_G1', PKG_MCRE0_AUDIT.C_DEBUG, sqlcode, 'INIZIO', 'INIZIO');
            esito:=0;


            PKG_MCRE0_AUDIT.log_etl (seq,'6_1 - ETL2 - INI - FNC_VERIFICA_ALERT_BLOCCO 1', PKG_MCRE0_AUDIT.C_DEBUG, sqlcode, 'INIZIO', 'INIZIO - FNC_VERIFICA_ALERT_BLOCCO 1.');
            RetVal := MCRE_OWN.PKG_MCRE0_ALERT.FNC_VERIFICA_ALERT_BLOCCO ( seq, 1 );
            PKG_MCRE0_AUDIT.log_etl (seq,'6_1 - ETL2 - END - FNC_VERIFICA_ALERT_BLOCCO 1', PKG_MCRE0_AUDIT.C_DEBUG, sqlcode, 'Esito '||RETVAL, 'FINE - FNC_VERIFICA_ALERT_BLOCCO 1.');
            
            PKG_MCRE0_AUDIT.log_etl (seq,'6_1 - ETL2 - INI - FNC_VERIFICA_ALERT_BLOCCO 2', PKG_MCRE0_AUDIT.C_DEBUG, sqlcode, 'INIZIO', 'INIZIO - FNC_VERIFICA_ALERT_BLOCCO 2.');
            RetVal := MCRE_OWN.PKG_MCRE0_ALERT.FNC_VERIFICA_ALERT_BLOCCO ( seq, 2 );
            PKG_MCRE0_AUDIT.log_etl (seq,'6_1 - ETL2 - END - FNC_VERIFICA_ALERT_BLOCCO 2', PKG_MCRE0_AUDIT.C_DEBUG, sqlcode, 'Esito '||RETVAL, 'FINE - FNC_VERIFICA_ALERT_BLOCCO 2.');
            
            PKG_MCRE0_AUDIT.log_etl (seq,'6_1 - ETL2 - INI - FNC_VERIFICA_ALERT_BLOCCO 3', PKG_MCRE0_AUDIT.C_DEBUG, sqlcode, 'INIZIO', 'INIZIO - FNC_VERIFICA_ALERT_BLOCCO 3.');
            RetVal := MCRE_OWN.PKG_MCRE0_ALERT.FNC_VERIFICA_ALERT_BLOCCO ( seq, 3 );
            PKG_MCRE0_AUDIT.log_etl (seq,'6_1 - ETL2 - END - FNC_VERIFICA_ALERT_BLOCCO 3', PKG_MCRE0_AUDIT.C_DEBUG, sqlcode, 'Esito '||RETVAL, 'FINE - FNC_VERIFICA_ALERT_BLOCCO 3.');
            
            PKG_MCRE0_AUDIT.log_etl (seq,'6_1 - ETL2 - INI - FNC_VERIFICA_ALERT_BLOCCO 4', PKG_MCRE0_AUDIT.C_DEBUG, sqlcode, 'INIZIO', 'INIZIO - FNC_VERIFICA_ALERT_BLOCCO 4.');
            RetVal := MCRE_OWN.PKG_MCRE0_ALERT.FNC_VERIFICA_ALERT_BLOCCO ( seq, 4 );
            PKG_MCRE0_AUDIT.log_etl (seq,'6_1 - ETL2 - END - FNC_VERIFICA_ALERT_BLOCCO 4', PKG_MCRE0_AUDIT.C_DEBUG, sqlcode, 'Esito '||RETVAL, 'FINE - FNC_VERIFICA_ALERT_BLOCCO 4.');
            
             PKG_MCRE0_AUDIT.log_etl (seq,'6_1 - ETL2 - INI - FNC_VERIFICA_ALERT_BLOCCO 5', PKG_MCRE0_AUDIT.C_DEBUG, sqlcode, 'INIZIO', 'INIZIO - FNC_VERIFICA_ALERT_BLOCCO 5.');
            RetVal := MCRE_OWN.PKG_MCRE0_ALERT.FNC_VERIFICA_ALERT_BLOCCO ( seq, 5 );
            PKG_MCRE0_AUDIT.log_etl (seq,'6_1 - ETL2 - END - FNC_VERIFICA_ALERT_BLOCCO 5', PKG_MCRE0_AUDIT.C_DEBUG, sqlcode, 'Esito '||RETVAL, 'FINE - FNC_VERIFICA_ALERT_BLOCCO 5.');
            
            PKG_MCRE0_AUDIT.log_etl (seq,'6_1 - ETL2 - INI - FNC_VERIFICA_ALERT_BLOCCO 6', PKG_MCRE0_AUDIT.C_DEBUG, sqlcode, 'INIZIO', 'INIZIO - FNC_VERIFICA_ALERT_BLOCCO 6.');
            RetVal := MCRE_OWN.PKG_MCRE0_ALERT.FNC_VERIFICA_ALERT_BLOCCO ( seq, 6 );
            PKG_MCRE0_AUDIT.log_etl (seq,'6_1 - ETL2 - END - FNC_VERIFICA_ALERT_BLOCCO 6', PKG_MCRE0_AUDIT.C_DEBUG, sqlcode, 'Esito '||RETVAL, 'FINE - FNC_VERIFICA_ALERT_BLOCCO 6.');

            PKG_MCRE0_AUDIT.log_etl (seq,'6_1 - ETL2 - INI - FNC_VERIFICA_ALERT_BLOCCO 7', PKG_MCRE0_AUDIT.C_DEBUG, sqlcode, 'INIZIO', 'INIZIO - FNC_VERIFICA_ALERT_BLOCCO 7.');
            RetVal := MCRE_OWN.PKG_MCRE0_ALERT.FNC_VERIFICA_ALERT_BLOCCO ( seq, 7 );
            PKG_MCRE0_AUDIT.log_etl (seq,'6_1 - ETL2 - END - FNC_VERIFICA_ALERT_BLOCCO 7', PKG_MCRE0_AUDIT.C_DEBUG, sqlcode, 'Esito '||RETVAL, 'FINE - FNC_VERIFICA_ALERT_BLOCCO 7.');
            
            PKG_MCRE0_AUDIT.log_etl (seq,'6_1 - ETL2 - FNC_VERIFICA_ALERT_BLOCCO 8', PKG_MCRE0_AUDIT.C_DEBUG, sqlcode, 'INIZIO', 'INIZIO - FNC_VERIFICA_ALERT_BLOCCO 8.');
            RetVal := MCRE_OWN.PKG_MCRE0_ALERT.FNC_VERIFICA_ALERT_BLOCCO ( seq, 8 );
            PKG_MCRE0_AUDIT.log_etl (seq,'6_1 - ETL2 - FNC_VERIFICA_ALERT_BLOCCO 8', PKG_MCRE0_AUDIT.C_DEBUG, sqlcode, 'Esito '||RETVAL, 'FINE - FNC_VERIFICA_ALERT_BLOCCO 8.');
            
            
            
            PKG_MCRE0_AUDIT.log_etl (seq, '6_1 - PKG_MCRE0_TWS_20111129 - INI - Sveccchia Log_APP', PKG_MCRE0_AUDIT.C_DEBUG, sqlcode, 'INIZIO', 'INIZIO - eseguito Svecchiamento log APP');
            RetVal := PKG_MCRE0_AUDIT.SVECCHIA_LOG_APP;
            PKG_MCRE0_AUDIT.log_etl (seq, '6_1 - PKG_MCRE0_TWS_20111129 - END - Sveccchia Log_APP', PKG_MCRE0_AUDIT.C_DEBUG, sqlcode, 'Esito '||RetVal, 'FINE - eseguito Svecchiamento log APP');
            esito := esito+RetVal;
            PKG_MCRE0_AUDIT.log_etl (seq, '6_1 - PKG_MCRE0_TWS_20111129 - INI - Sveccchia Log_ETL', PKG_MCRE0_AUDIT.C_DEBUG, sqlcode, 'INIZIO', 'INIZIO - eseguito Svecchiamento log ETL');
            RetVal := PKG_MCRE0_AUDIT.SVECCHIA_LOG_ETL;
            PKG_MCRE0_AUDIT.log_etl (seq, '6_1 - PKG_MCRE0_TWS_20111129 - END - Sveccchia Log_ETL', PKG_MCRE0_AUDIT.C_DEBUG, sqlcode, 'Esito '||RetVal, 'FINE - eseguito Svecchiamento log ETL');
            esito := esito+RetVal;

            --Ver 2.0 inizializzazione T_MCRE0_WRK_SENDING_FILES per estrazione flussi per host
            update MCRE_OWN.T_MCRE0_WRK_SENDING_FILES
            set DTA_EXPORT = sysdate,
            ID_DPER=NULL,
            ESITO=-1,
            RECORD_EXP=NULL,
            RECORD_SC=NULL,
            COMPARTO_NULL=NULL;
            commit;
            PKG_MCRE0_AUDIT.log_etl (seq, '6_1 - PKG_MCRE0_TWS_20111129 - END - LIVELLO6_G1', PKG_MCRE0_AUDIT.C_DEBUG, sqlcode, 'FINE', 'FINE');
            return ok;
        EXCEPTION WHEN OTHERS THEN
            PKG_MCRE0_AUDIT.log_etl ('6_1 - PKG_MCRE0_TWS_20111129 ERROR - LIVELLO_6 GRUPPO_1', PKG_MCRE0_AUDIT.C_ERROR, sqlcode, sqlerrm, 'Errore in ERROR - LIVELLO_6 GRUPPO_1');
            return ko;
        END TWS_MCRE0_LIVELLO6_G1;

    FUNCTION TWS_MCRE0_LIVELLO8_G1 return number IS

        BEGIN
            select SEQ_MCR0_LOG_ETL.nextval into seq from dual;
            PKG_MCRE0_AUDIT.log_etl (seq, '8_1 - PKG_MCRE0_TWS_20111129 - INI - LIVELLO8_G1', PKG_MCRE0_AUDIT.C_DEBUG, sqlcode, 'INIZIO', 'INIZIO');
            esito:=0;
            PKG_MCRE0_AUDIT.log_etl (seq, '8_1 APRI_PORTALE - INI', PKG_MCRE0_AUDIT.C_DEBUG, sqlcode, 'INIZIO', 'INIZIO - APRI_PORTALE');
            RetVal := MCRE_OWN.PKG_MCRE0_TWS_20111129.TWS_MCRE0_APRI_PORTALE;
            PKG_MCRE0_AUDIT.log_etl (seq, '8_1 APRI_PORTALE - END', PKG_MCRE0_AUDIT.C_DEBUG, sqlcode, 'Esito '||RetVal, 'FINE - APRI_PORTALE');
            COMMIT;            
            ESITO := ESITO+RETVAL;
            PKG_MCRE0_AUDIT.log_etl (seq, '8_1 - PKG_MCRE0_TWS_20111129 - END - LIVELLO8_G1', PKG_MCRE0_AUDIT.C_DEBUG, sqlcode, 'FINE', 'FINE');
            PKG_MCRE0_AUDIT.log_etl (seq, '8_2 - CONTROLLI - INI', PKG_MCRE0_AUDIT.C_DEBUG, sqlcode, 'INIZIO', 'INIZIO - CONTROLLI');
            RetVal := MCRE_OWN.PKG_MCRE0_UTILS.FND_MCRE0_CONTROLLI;
            COMMIT; 
            PKG_MCRE0_AUDIT.log_etl (seq, '8_2 - CONTROLLI - END', PKG_MCRE0_AUDIT.C_DEBUG, sqlcode, 'FINE', 'FINE - CONTROLLI');            
            return ok;
        EXCEPTION WHEN OTHERS THEN
        PKG_MCRE0_AUDIT.log_etl ('8_1 - PKG_MCRE0_TWS_20111129 ERROR - LIVELLO_8 GRUPPO_1', PKG_MCRE0_AUDIT.C_ERROR, sqlcode, sqlerrm, 'Errore in ERROR - LIVELLO_8 GRUPPO_1');
            return ko;
        END TWS_MCRE0_LIVELLO8_G1;

END PKG_MCRE0_TWS_20111129;
/


CREATE SYNONYM MCRE_APP.PKG_MCRE0_TWS_20111129 FOR MCRE_OWN.PKG_MCRE0_TWS_20111129;


CREATE SYNONYM MCRE_USR.PKG_MCRE0_TWS_20111129 FOR MCRE_OWN.PKG_MCRE0_TWS_20111129;


GRANT EXECUTE, DEBUG ON MCRE_OWN.PKG_MCRE0_TWS_20111129 TO MCRE_USR;

