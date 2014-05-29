CREATE OR REPLACE PACKAGE MCRE_OWN.PKG_MCRE0_LOAD_CONFERIMENTI AS
  /******************************************************************************
   NAME:       PKG_MCRE0_MIG_NDG_RAP
   PURPOSE:

   REVISIONS:
   Ver        Date        Author           Description
   ---------  ----------  ---------------  ------------------------------------
   1.0        22/06/2012  1.I.Gueorguieva  Created this package body.
   1.1        24/09/2012  1.I.Gueorguieva  Inserito controllo id_dper caricamento t_mcre0_app_mig_recode_ndg
   1.2        05/10/2012  1.I.Gueorguieva Inserito controllo su id_dper su tutti i flussi; truncate se l'id_dper
                                           è superiore all'ultimo caricato per il flusso
   1.3        08/10/2012  M.Murro         filtro pres-cruscotto su no delibera = 0
   1.4        09/10/2012  I.Gueorguieva Cancellazione AFTABRAC per abi ricevente
   1.5        19/11/2012  M.Murro         filtro flag se presa_visione = 0
  ******************************************************************************/

  c_package CONSTANT VARCHAR2(50) := 'PKG_MCRE0_LOAD_CONFERIMENTI';
  ok NUMBER := 1;
  ko NUMBER := 0;
  c_caricata_st             CONSTANT VARCHAR2(45) := 'ST_CARICATA';
  c_caricata_app            CONSTANT VARCHAR2(45) := 'APP_CARICATA';
  c_calcolati_flg           CONSTANT VARCHAR2(45) := 'FLG_CALCOLATI';
  c_inizio_caricamento      CONSTANT VARCHAR2(45) := 'INIZIO';
  c_periodo_caricato        CONSTANT VARCHAR2(45) := 'PERIODO FLUSSO CARICATO';
  C_PERIODO_CARICATO_ABI    CONSTANT VARCHAR2(45) := 'PERIODO ABI CARICATO';

  -- %author
  -- %version 0.1
  -- %usage  function che TESTA l'esistenza di una partizione sulla tabella passata per argomento
  -- %d La function verifica se esiste una partizione di nome INC_P||ID_dper
  -- %return 1 --> esiste partizione, 0 altrimenti
  -- %cd 25 GIU 2012
  FUNCTION fnc_esiste_partizione(id_dper IN NUMBER, p_tab_name IN VARCHAR2) RETURN NUMBER;

  -- %author
  -- %version 0.1
  -- %usage  function che TESTA l'esistenza di una sottopartizione sulla tabella passata per argomento
  -- %d La function verifica se esiste una partizione di nome INC_P||ID_dper||_COD_ABI
  -- %return 1 --> esiste sottopartizione, 0 altrimenti
  -- %cd 11 LUG 2012
FUNCTION fnc_esiste_sottopartizione (v_id_dper IN NUMBER,
                                     p_tab_name IN VARCHAR2,
                                     v_cod_abi IN VARCHAR2) RETURN NUMBER;
  -- %author
  -- %version 0.1
  -- %usage  function che tenta di CREARE una nuova partizione sulla tabella passata per argomento
  -- %d La function tenta di creare una partizione di nome INC_P||ID_dper
  -- %return 1 --> successo creazione, 0 altrimenti
  -- %cd 25 GIU 2012
  FUNCTION fnc_add_partition(id_dper IN NUMBER, p_tab_name IN VARCHAR2) RETURN NUMBER;

  FUNCTION fnc_add_subpartition(v_id_dper   IN NUMBER, p_tab_name IN VARCHAR2,
                                v_cod_abi IN VARCHAR2)RETURN NUMBER;
  -- %author
  -- %version 0.1
  -- %usage  function che carica i dati provenienti dai file AFTABRAC  nelle tabelle ST
  -- %d La function carica i dati nella ST corrispondenente a seconda dell'id_flusso passato
  -- %d Sulla tabella T_MCRE0_MIG_ACQUISIZIONE deve essere presente un record con
  -- %d ID_FLUSSO = V_ID_FLUSSO. Il caricamento parte solo se
  -- %d T_MCRE0_MIG_ACQUISIZIONE.COD_FILE = T_MCRE0_WRK_MIG_NDG_RAP.COD_FLUSSO
  -- %param V_ID_FLUSSO numero unico identificativo del caricamento
  -- %param V_ID_DPER data trasformata in formato numerico YYYYMMDD inserita nella colonna ID_DPER della tabella ST
  -- %return 1 --> successo caricamento, 0 altrimenti
  -- %cd 27 GIU 2012
  FUNCTION fnc_load_st(v_id_flusso IN NUMBER, v_id_dper IN NUMBER) RETURN NUMBER;
  -- %author
  -- %version 0.1
  -- %usage  function che carica i dati provenienti dai file AFTABRAC  nelle tabelle APP
  -- %d Logica analoga a quella di FNC_LOAD_ST
  -- %param V_ID_FLUSSO numero unico identificativo del caricamento
  -- %param V_ID_DPER data trasformata in formato numerico YYYYMMDD inserita nella colonna ID_DPER della tabella APP
  -- %return 1 --> successo caricamento, 0 altrimenti
  -- %cd 27 GIU 2012
  FUNCTION fnc_load_app(v_id_flusso IN NUMBER, v_id_dper IN NUMBER)RETURN NUMBER;

  -- %author
  -- %version 0.1
  -- %usage  function che calcola il FLG_CRUSCOTTO SU T_MCRE0_APP_MIG_RECODE_NDG
  -- %d FLG_CRUSCOTTO = 1, se sulla tabella delle delibere e' presente almeno
  -- %d delibera, che non e' di classificazione ed il e' manuale.
  -- %param V_ID_FLUSSO numero unico identificativo del caricamento
  -- %return 1 --> successo calcolo, 0 altrimenti
  -- %cd 28 GIU 2012
  FUNCTION fnc_calcola_flg_cruscotto(v_id_flusso IN NUMBER) RETURN NUMBER;

  -- %author
  -- %version 0.1
  -- %usage  function che calcola il FLG_PARZIALE SU T_MCRE0_APP_MIG_RECODE_NDG
  -- %d FLG_PARZIALE = 1, se sul file guida e presente un NDG che coincide con NDG_NEW
  -- %param V_ID_FLUSSO numero unico identificativo del caricamento
  -- %return 1 --> successo calcolo, 0 altrimenti
  -- %cd 28 GIU 2012
  FUNCTION fnc_calcola_flg_condiviso(v_id_flusso IN NUMBER) RETURN NUMBER;

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
  FUNCTION fnc_calcola_flg_parziale(v_id_flusso IN NUMBER) RETURN NUMBER;

  -- %author
  -- %version 0.1
  -- %usage  function che inserisce un record in T_MCRE0_MIG_ACQUISIZIONE
  -- %d il record avr¿ popolati i campi ID_FLUSSO, COD_FILE, ID_DPER
  -- %param V_ID_FLUSSO numero unico identificativo del caricamento
  -- %param NDG_OR_RAPP valori possibili: AFTABRAC_NDG  oppure AFTABRAC_RAPP
  -- %return ID_DPER --> successo INSERIMENTO, 0 altrimenti
  -- %cd 28 GIU 2012
  FUNCTION fnc_init_caricamento(v_id_flusso IN NUMBER,
                                ndg_or_rapp IN VARCHAR2,
                                v_cod_abi in varchar2) RETURN NUMBER;

  FUNCTION fnc_delete_flg_ndg RETURN NUMBER;

  -- %author
  -- %version 0.1
  -- %usage  function che calcola il FLG_SOFFERENZA SU T_MCRE0_APP_MIG_RECODE_NDG
  -- %d FLG_SOFFERENZA= 1, se la posizione ¿ in stato SOFFERENZA sul file guida
  -- %d FLG_SOFFERENZA = 0, altrimenti
  -- %d La funzione va chiamata dopo che il file guida ¿ stato rinumerato
  -- %param V_ID_FLUSSO numero unico identificativo del caricamento
  -- %return 1 --> successo calcolo, 0 altrimenti
  -- %cd 29 GIU 2012
  FUNCTION fnc_calcola_flg_sofferenza(v_id_flusso IN NUMBER,
                                      ndg_or_rapp IN VARCHAR2) RETURN NUMBER;

  -- %author
  -- %version 0.1
  -- %usage  function che controlla  che tutti i file attesi siano arrivati
  -- %d
  -- %d
  -- %d
  -- %param
  -- %return
  -- %cd 29 GIU 2012
  FUNCTION fnc_chk_mig_file(p_nome_file t_mcre0_wrk_mig_recode_file.val_nome_file%TYPE)RETURN NUMBER;
END PKG_MCRE0_LOAD_CONFERIMENTI;
/


CREATE SYNONYM MCRE_APP.PKG_MCRE0_LOAD_CONFERIMENTI FOR MCRE_OWN.PKG_MCRE0_LOAD_CONFERIMENTI;


CREATE SYNONYM MCRE_USR.PKG_MCRE0_LOAD_CONFERIMENTI FOR MCRE_OWN.PKG_MCRE0_LOAD_CONFERIMENTI;


GRANT EXECUTE, DEBUG ON MCRE_OWN.PKG_MCRE0_LOAD_CONFERIMENTI TO MCRE_USR;

