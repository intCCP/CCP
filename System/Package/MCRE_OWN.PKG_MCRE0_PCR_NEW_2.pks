CREATE OR REPLACE PACKAGE MCRE_OWN.PKG_MCRE0_PCR_NEW_2 AS
/******************************************************************************
   NAME:     PKG_MCRE0_PCR
   PURPOSE: Gestione alert ed evidenze

   REVISIONS:
   Ver        Date        Author             Description
   ---------  ----------  -----------------  ------------------------------------
   1.0        07/06/2011  Galli Valeria      Created this package.
   1.1        13/06/2011  Galli Valeria      A mano.
******************************************************************************/

  ok number := 1;
  ko number := 0;
  
  -- Procedura per calcolo MAU 
  -- INPUT : 
  -- OUTPUT :
  --    stato esecuzione 1 OK 0 Errori   
  FUNCTION FNC_CALCOLO_MAU (p_id_dper t_mcre0_app_pcr_sc_sb.id_dper%type default null)   
  RETURN NUMBER;
  
  -- Procedura per pulizia delle posizioni di file guida senza pcr
  -- INPUT : 
  -- OUTPUT :
  --    stato esecuzione 1 OK 0 Errori   
  FUNCTION fnc_clean_no_pcr (p_id_dper t_mcre0_app_pcr_sc_sb.id_dper%type default null)     
  RETURN NUMBER;

  -- Procedura per calcolo pcr
  -- INPUT : 
  -- OUTPUT :
  --    stato esecuzione 1 OK 0 Errori   
  FUNCTION fnc_load_pcr(p_id_dper t_mcre0_app_pcr_sc_sb.id_dper%type default null) 
  RETURN NUMBER;

  -- Procedura per calcolo pcr scsb con Merge
  --    stato esecuzione 1 OK 0 Errori   
  FUNCTION fnc_load_pcr_scsb_merge(p_id_dper t_mcre0_app_pcr_sc_sb.id_dper%type default null)  RETURN NUMBER;

  -- Procedura per calcolo pcr gesb con Merge
  --    stato esecuzione 1 OK 0 Errori   
  FUNCTION fnc_load_pcr_gesb_merge(p_id_dper t_mcre0_app_pcr_sc_sb.id_dper%type default null) RETURN NUMBER;

  -- Procedura per calcolo pcr gb con Merge
  --    stato esecuzione 1 OK 0 Errori   
  FUNCTION FNC_LOAD_PCR_GB_MERGE(p_id_dper t_mcre0_app_pcr_sc_sb.id_dper%type default null) RETURN NUMBER;
  
END PKG_MCRE0_PCR_NEW_2;
/


CREATE SYNONYM MCRE_APP.PKG_MCRE0_PCR_NEW_2 FOR MCRE_OWN.PKG_MCRE0_PCR_NEW_2;


CREATE SYNONYM MCRE_USR.PKG_MCRE0_PCR_NEW_2 FOR MCRE_OWN.PKG_MCRE0_PCR_NEW_2;


GRANT EXECUTE, DEBUG ON MCRE_OWN.PKG_MCRE0_PCR_NEW_2 TO MCRE_USR;

