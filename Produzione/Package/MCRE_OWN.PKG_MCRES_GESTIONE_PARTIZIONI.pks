CREATE OR REPLACE PACKAGE MCRE_OWN.PKG_MCRES_GESTIONE_PARTIZIONI  as

/******************************************************************************
   NAME:       PKG_MCRES_GESTIONE_PARTIZIONI 
   PURPOSE:

   REVISIONS:
   Ver          Date            Author              Description
   ---------    ----------      -----------------   ------------------------------------
   1.0          04/07/2011      V.Galli             Created this package.
   1.1          15/10/2012      A.Galliano          Aggiunta funzione fnc_add_partition e fnc_truncate_partition
                                                    per tabelle partizionate by list
  1.2           07/01/2013     F. Galletti          Modificata il cursore nella funzione crea sotto partizione                                                   
******************************************************************************/

  ok NUMBER := 1;
  ko NUMBER := 0;
  C_PACKAGE varchar2(30):='PKG_MCRES_GESTIONE_PARTIZIONI';
  
  IN_USE EXCEPTION;
  pragma exception_init(in_use, -54);
  
   -- Truncate partition
   function fnc_truncate_subpartition(
     p_tabella VARCHAR2, 
     P_PARTIZIONE VARCHAR2,
     P_ID_FLUSSO T_MCRES_WRK_AUDIT_CARICAMENTI.ID_FLUSSO%TYPE) 
   RETURN NUMBER;
  
   -- Truncate partition
   function fnc_truncate_partition(
     p_tabella VARCHAR2, 
     P_PARTIZIONE VARCHAR2,
     P_ID_FLUSSO T_MCRES_WRK_AUDIT_CARICAMENTI.ID_FLUSSO%TYPE) 
   RETURN NUMBER;
  
  -- Exchange partition
 /* function fnc_exchange_partition(
     P_ID_FLUSSO T_MCRES_WRK_AUDIT_CARICAMENTI.ID_FLUSSO%TYPE) 
  RETURN NUMBER;*/
  
  -- Elimina sottopartizione
  FUNCTION FNC_ELIMINA_SOTTOPARTIZIONE(
    p_tabella VARCHAR2,
    P_PARTIZIONE VARCHAR2,
    P_ID_FLUSSO T_MCRES_WRK_AUDIT_CARICAMENTI.ID_FLUSSO%TYPE) 
  RETURN NUMBER;
  
  -- Crea sottopartizione
  FUNCTION FNC_CREA_SOTTOPARTIZIONE(
    p_tabella VARCHAR2, 
    P_PARTIZIONE VARCHAR2,
    P_ID_FLUSSO T_MCRES_WRK_AUDIT_CARICAMENTI.ID_FLUSSO%TYPE) 
  RETURN NUMBER;
  
  -- Set template per sottopartizioni
  function fnc_set_subpart_template(
     P_TABLE in varchar2,
     P_ID_FLUSSO T_MCRES_WRK_AUDIT_CARICAMENTI.ID_FLUSSO%type) 
   return number;
   
  -- Esiste sotto_partizione 
  FUNCTION fnc_esiste_sottopartizione(
    P_TABELLA varchar2,
    p_partizione VARCHAR2,
    P_ID_FLUSSO T_MCRES_WRK_AUDIT_CARICAMENTI.ID_FLUSSO%TYPE) 
  return number;
  
  -- Aggiorna sottopartizioni
  FUNCTION FNC_UPDATE_SUBPARTITION_LIST(
    P_TABELLA varchar2 default null, 
    p_type_table varchar2 DEFAULT NULL,
    P_ID_FLUSSO T_MCRES_WRK_AUDIT_CARICAMENTI.ID_FLUSSO%type)
  RETURN number;
  
  -- Aggiorna partizioni
  FUNCTION FNC_UPDATE_PARTITION_LIST(
    P_TABELLA VARCHAR2 DEFAULT NULL, 
    p_type_table varchar2 DEFAULT NULL,
    P_ID_FLUSSO T_MCRES_WRK_AUDIT_CARICAMENTI.ID_FLUSSO%TYPE)
  RETURN number;
  
  -- Suffisso partizioni
  FUNCTION fnc_get_suffix_partition(
     P_ID_FLUSSO T_MCRES_WRK_AUDIT_CARICAMENTI.ID_FLUSSO%TYPE)
  RETURN T_MCRES_WRK_CONFIGURAZIONE.VALORE_COSTANTE%type;
  
  -- Partizione default
  FUNCTION fnc_get_default_partition(
     P_ID_FLUSSO T_MCRES_WRK_AUDIT_CARICAMENTI.ID_FLUSSO%TYPE)
  RETURN T_MCRES_WRK_CONFIGURAZIONE.VALORE_COSTANTE%type;

  -- Esiste partizione 
  FUNCTION fnc_esiste_partizione(
    p_tabella VARCHAR2,
    p_partizione VARCHAR2,
    P_ID_FLUSSO T_MCRES_WRK_AUDIT_CARICAMENTI.ID_FLUSSO%TYPE)
  RETURN NUMBER;
  
  -- Crea partizione 
    FUNCTION FNC_CREA_PARTIZIONE(
    p_tabella VARCHAR2, 
    p_partizione VARCHAR2,
    P_ID_FLUSSO T_MCRES_WRK_AUDIT_CARICAMENTI.ID_FLUSSO%TYPE) 
  RETURN NUMBER;
  
  -- Elimina partizione 
    FUNCTION FNC_ELIMINA_PARTIZIONE(
    p_tabella VARCHAR2,
    p_partizione VARCHAR2,
    P_ID_FLUSSO T_MCRES_WRK_AUDIT_CARICAMENTI.ID_FLUSSO%TYPE)
  RETURN NUMBER;
  
function fnc_add_partition
( 
    p_tabella       in varchar2,
    p_id_flusso     in number
)
return number;  

  
END PKG_MCRES_GESTIONE_PARTIZIONI;
/


CREATE SYNONYM MCRE_APP.PKG_MCRES_GESTIONE_PARTIZIONI FOR MCRE_OWN.PKG_MCRES_GESTIONE_PARTIZIONI;


CREATE SYNONYM MCRE_USR.PKG_MCRES_GESTIONE_PARTIZIONI FOR MCRE_OWN.PKG_MCRES_GESTIONE_PARTIZIONI;


GRANT EXECUTE, DEBUG ON MCRE_OWN.PKG_MCRES_GESTIONE_PARTIZIONI TO MCRE_USR;

