CREATE OR REPLACE PACKAGE MCRE_OWN.PKG_MCRE0_MIG_NDG_RAP AS
/******************************************************************************
   NAME:       PKG_MCRE0_MIG_NDG_RAP
   PURPOSE:

   REVISIONS:
   Ver        Date        Author           Description
   ---------  ----------  ---------------  ------------------------------------
   1.0        22/06/2012  1.I.Gueorguieva  Created this package body.
******************************************************************************/

   c_package   CONSTANT VARCHAR2 (50) := 'PKG_MCRE0_MIG_NDG_RAP';
   ok                   NUMBER        := 1;
   ko                   NUMBER        := 0;
   c_caricata_st    CONSTANT  VARCHAR2(45):= 'ST_CARICATA';
   c_caricata_app   CONSTANT VARCHAR2(45):= 'APP_CARICATA';
   C_CALCOLATI_FLG  CONSTANT VARCHAR2(45):= 'FLG_CALCOLATI';
   c_inizio_caricamento CONSTANT VARCHAR2(45):= 'INIZIO';

  -- %author
  -- %version 0.1
  -- %usage  function che TESTA l'esistenza di una partizione sulla tabella passata per argomento
  -- %d La function testa l'esistenza di una partizione di nome INC_P||ID_dper
  -- %return 1 --> esiste partizione, 0 altrimenti
  -- %cd 25 GIU 2012
FUNCTION FNC_ESISTE_PARTIZIONE(ID_DPER IN NUMBER,
                               P_TAB_NAME IN VARCHAR2 ) RETURN NUMBER;
  -- %author
  -- %version 0.1
  -- %usage  function che tenta di CREARE una nuova partizione sulla tabella passata per argomento
  -- %d La function tenta di creare una partizione di nome INC_P||ID_dper
  -- %return 1 --> successo creazione, 0 altrimenti
  -- %cd 25 GIU 2012
FUNCTION fnc_add_partition(id_dper IN NUMBER,
                             P_TAB_NAME IN VARCHAR2 ) RETURN NUMBER;
  -- %author
  -- %version 0.1
  -- %usage  function che carica i dati provenianti dai file AFTABRAC  nelle tabelle ST
  -- %d La function carica i dati nella ST corrispondenente a seconda dell'id_flusso passato
  -- %d Sulla tabella T_MCRE0_MIG_ACQUISIZIONE deve essere presente un record con
  -- %d ID_FLUSSO = V_ID_FLUSSO. Il caricamento parte solo se
  -- %d T_MCRE0_MIG_ACQUISIZIONE.COD_FILE = T_MCRE0_WRK_MIG_NDG_RAP.COD_FLUSSO
  -- %param V_ID_FLUSSO numero unico identificativo del caricamento
  -- %param V_ID_DPER data trasformata in formato numerico YYYYMMDD inserita nella colonna ID_DPER della tabella ST
  -- %return 1 --> successo caricamento, 0 altrimenti
  -- %cd 27 GIU 2012
FUNCTION FNC_LOAD_ST(V_ID_FLUSSO IN NUMBER,
                    V_ID_DPER IN NUMBER) RETURN NUMBER;
  -- %author
  -- %version 0.1
  -- %usage  function che carica i dati provenianti dai file AFTABRAC  nelle tabelle APP
  -- %d Logica analoga a quella di FNC_LOAD_ST
  -- %param V_ID_FLUSSO numero unico identificativo del caricamento
  -- %param V_ID_DPER data trasformata in formato numerico YYYYMMDD inserita nella colonna ID_DPER della tabella APP
  -- %return 1 --> successo caricamento, 0 altrimenti
  -- %cd 27 GIU 2012
  FUNCTION FNC_LOAD_APP(V_ID_FLUSSO IN NUMBER,
                    V_ID_DPER IN NUMBER)  RETURN NUMBER;

  -- %author
  -- %version 0.1
  -- %usage  function che calcola il FLG_CRUSCOTTO SU T_MCRE0_APP_MIG_RECODE_NDG
  -- %d FLG_CRUSCOTTO = 1, se sulla tabella delle delibere e' presente almeno
  -- %d delibera, che non e' di classificazione ed il e' manuale.
  -- %param V_ID_FLUSSO numero unico identificativo del caricamento
  -- %return 1 --> successo calcolo, 0 altrimenti
  -- %cd 28 GIU 2012
    FUNCTION FNC_CALCOLA_FLG_CRUSCOTTO(V_ID_FLUSSO IN NUMBER) RETURN NUMBER;

  -- %author
  -- %version 0.1
  -- %usage  function che calcola il FLG_PARZIALE SU T_MCRE0_APP_MIG_RECODE_NDG
  -- %d FLG_PARZIALE = 1, se sul file guida e presente un NDG che coincide con NDG_NEW
  -- %param V_ID_FLUSSO numero unico identificativo del caricamento
  -- %return 1 --> successo calcolo, 0 altrimenti
  -- %cd 28 GIU 2012
FUNCTION FNC_CALCOLA_FLG_CONDIVISO(V_ID_FLUSSO IN NUMBER) RETURN NUMBER;

  -- %author
  -- %version 0.1
  -- %usage  function che calcola il FLG_PARZIALE SU T_MCRE0_APP_MIG_RECODE_NDG
  -- %d FLG_PARZIALE= 1, se non tutti i rapporti presenti sulla banca cedente
  -- %d verrranno rinumerati, ovvero se non esiste una coppia ABI_NEW, RAPPORTO_NEW
  -- %d per ogni rapporto di una certa posizione presente sulla banca cedente
  -- %d FLG_PARZIALE= 0, altrimenti
  -- %param V_ID_FLUSSO numero unico identificativo del caricamento
  -- %return 1 --> successo calcolo, 0 altrimenti
  -- %cd 28 GIU 2012
FUNCTION FNC_CALCOLA_FLG_PARZIALE(V_ID_FLUSSO IN NUMBER) RETURN NUMBER;

  -- %author
  -- %version 0.1
  -- %usage  function che inserisce un record in T_MCRE0_MIG_ACQUISIZIONE
  -- %d il record avrò popolati i campi ID_FLUSSO, COD_FILE, ID_DPER
  -- %param V_ID_FLUSSO numero unico identificativo del caricamento
  -- %param NDG_OR_RAPP valori possibili: AFTABRAC_NDG  oppure AFTABRAC_RAPP
  -- %return ID_DPER --> successo INSERIMENTO, 0 altrimenti
  -- %cd 28 GIU 2012
FUNCTION FNC_INIT_CARICAMENTO(V_ID_FLUSSO IN NUMBER,NDG_OR_RAPP IN VARCHAR2
                             ) RETURN NUMBER;

 FUNCTION FNC_DELETE_FLG_NDG RETURN NUMBER;

  -- %author
  -- %version 0.1
  -- %usage  Function che lancia il caricamnto e il calcolo flag
  -- %param V_ID_FLUSSO numero unico identificativo del caricamento
  -- %param NDG_OR_RAPP valori possibili: AFTABRAC_NDG  oppure AFTABRAC_RAPP
  -- %return ID_DPER --> successo CARICAMRNTO, 0 altrimenti
  -- %cd 29 GIU 2012
 FUNCTION FNC_EXE_LOAD(V_ID_FLUSSO IN NUMBER,NDG_OR_RAPP IN VARCHAR2) RETURN NUMBER;

  -- %author
  -- %version 0.1
  -- %usage  function che calcola il FLG_SOFFERENZA SU T_MCRE0_APP_MIG_RECODE_NDG
  -- %d FLG_SOFFERENZA= 1, se la posizione è in stato SOFFERENZA sul file guida
  -- %d FLG_SOFFERENZA = 0, altrimenti
  -- %d La funzione va chaiamata dopo che il file guida è stato rinumerato
  -- %param V_ID_FLUSSO numero unico identificativo del caricamento
  -- %return 1 --> successo calcolo, 0 altrimenti
  -- %cd 29 GIU 2012
FUNCTION FNC_CALCOLA_FLG_SOFFERENZA(V_ID_FLUSSO IN NUMBER, NDG_OR_RAPP IN VARCHAR2) RETURN NUMBER;

END PKG_MCRE0_MIG_NDG_RAP;
/


CREATE SYNONYM MCRE_APP.PKG_MCRE0_MIG_NDG_RAP FOR MCRE_OWN.PKG_MCRE0_MIG_NDG_RAP;


CREATE SYNONYM MCRE_USR.PKG_MCRE0_MIG_NDG_RAP FOR MCRE_OWN.PKG_MCRE0_MIG_NDG_RAP;


GRANT EXECUTE, DEBUG ON MCRE_OWN.PKG_MCRE0_MIG_NDG_RAP TO MCRE_USR;

