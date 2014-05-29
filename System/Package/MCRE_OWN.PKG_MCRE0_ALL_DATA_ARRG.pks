CREATE OR REPLACE PACKAGE MCRE_OWN.PKG_MCRE0_ALL_DATA_ARRG AS
/******************************************************************************
   NAME:       PKG_MCRE0_ALL_DATA_ARRG1
   PURPOSE:    Simulazione caricamento dati sulla tabella "copia" T_MCRE0_APP_ALL_DATA_ARRG 
               con gruppo super per area e regione 

   REVISIONS:
   Ver        Date        Author           Description
   ---------  ----------  ---------------  ------------------------------------
   1.0        10/04/2013  1.I.Gueorguieva  Created this package.
   
   L'ordine delle azioni è il seguente, ciascuna può essere disabilitata 
   mediante T_MCRE0_WRK_FILEGUID_ARRG.FLG_ATTIVA, controllando 
   T_MCRE0_WRK_FILE_GUIDA_ARRG.DESC_OPERAZIONE
   
   0) INIT_TAB_WRK -- INIZIALIZZAZIONE TABELLA DI LAVORO 
   
   1) FNC_COPY_APP_FILE_GUIDA
   Copia in T_MCRE0_APP_FILE_GUIDA_ARRG i dati da T_MCRE0_APP_FILE_GUIDA,
   aggiorna il T_MCRE0_WRK_FILEGUID_ARRG.FLG_ATTIVA = 0, di regola viene
   eseguito una tantum
   
   2)FNC_ETL_RIBALTA_FILE_GUIDA
   Funzione analoga a PKG_MCRE0_GESTIONE_ALL_DATA.ETL_RESTORE_FILE_GUIDA.
   Alla prima esecuzione ribalta integralmente i dati dalla tabella T_MCRE0_APP_ALL_DATA.
   Successivamente distingue i casi.
   Se il comparto è di area o regione ribalta dalla T_MCRE0_APP_ALL_DATA_ARRG
   altrimenti ribalta da T_MCRE0_APP_ALL_DATA
   
   3) FNC_FILE_GUIDA_APP
   Simula il caricamento di primo livello del FILE GUIDA dalla ST alla APP,
   come nel package PKG_MCRE0_ALIMENTAZIONE
   
   4) FNC_UPDATE_FILE_GUIDA_EXT
   FNC_UPDATE_FILE_GUIDA_PRE; FNC_UPDATE_FILE_GUIDA
   Simula il comportamento del package PKG_MCRE0_ESTENDI_FILE_GUIDA2
   usando T_MCRE0_APP_FILE_GUIDA_ARRG
   
   5) FNC_LOAD_ALL_DATA_ARRG
   LOAD SU T_MCRE0_APP_ALL_DATA_RG
   
   6) FNG_GRUPPO_UTENTE_COMPARTO
   MERGE AGGIUNTIVA GRUPPO E COMPARTO
******************************************************************************/

  FUNCTION FNC_COPY_APP_FILE_GUIDA RETURN NUMBER;
  FUNCTION FNC_ETL_RIBALTA_FILE_GUIDA RETURN NUMBER;
  FUNCTION FNC_FILE_GUIDA_APP (P_PARTITION NUMBER) RETURN NUMBER;
  FUNCTION FNC_UPDATE_FILE_GUIDA_EXT RETURN NUMBER;
  FUNCTION FNC_LOAD_ALL_DATA_ARRG RETURN NUMBER;
  FUNCTION FNG_GRUPPO_UTENTE_COMPARTO RETURN NUMBER;
  PROCEDURE INIT_TAB_WRK;
  PROCEDURE ESTRAI_WRK_SU_STDOUT;
  PROCEDURE PRC_CALL_ALL;
END PKG_MCRE0_ALL_DATA_ARRG;
/


CREATE SYNONYM MCRE_APP.PKG_MCRE0_ALL_DATA_ARRG FOR MCRE_OWN.PKG_MCRE0_ALL_DATA_ARRG;


GRANT EXECUTE, DEBUG ON MCRE_OWN.PKG_MCRE0_ALL_DATA_ARRG TO MCRE_USR;

