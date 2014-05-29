CREATE OR REPLACE PACKAGE MCRE_OWN.PKG_MCRE0_PCR_NEW AS
/******************************************************************************
   NAME:     PKG_MCRE0_PCR
   PURPOSE: Gestione alert ed evidenze

   REVISIONS:
   Ver        Date        Author             Description
   ---------  ----------  -----------------  ------------------------------------
   1.0        27/12/2010  Galli Valeria      Created this package.
   2.0        13/01/2011    Marco Murro      Gestione merge
   2.1        04/03/2011  Galli Valeria      Storico indipendente da MV (da dismettere) - Aggiunti ID_DPER e DTA_UPD
   2.2        14/03/2011  Galli Valeria      Aggiunti Massimali/Sostituzioni/Rischi Indiretti e totali per acc/uti di GB
   2.3        05/04/2011  Galli Valeria      Aggiunti Consegne e garantiti GB
   2.4        21/04/2011  Galli Valeria      Pulizia gruppi
   2.5        06/06/2011  Galli Valeria      GB_VAL_MAU
******************************************************************************/

  ok number := 1;
  ko number := 0;

  -- Procedura per calcolo MAU
  -- INPUT :
  -- OUTPUT :
  --    stato esecuzione 1 OK 0 Errori
  FUNCTION FNC_CALCOLO_MAU
  RETURN NUMBER;

  -- Procedura per pulizia delle posizioni di file guida senza pcr
  -- INPUT :
  -- OUTPUT :
  --    stato esecuzione 1 OK 0 Errori
  FUNCTION fnc_clean_no_pcr
  RETURN NUMBER;

  -- Procedura per calcolo pcr
  -- INPUT :
  -- OUTPUT :
  --    stato esecuzione 1 OK 0 Errori
  FUNCTION fnc_load_pcr
  RETURN NUMBER;

  -- Procedura per calcolo pcr scsb con Merge
  --    stato esecuzione 1 OK 0 Errori
  FUNCTION fnc_load_pcr_scsb_merge  RETURN NUMBER;

  -- Procedura per calcolo pcr gesb con Merge
  --    stato esecuzione 1 OK 0 Errori
  FUNCTION fnc_load_pcr_gesb_merge RETURN NUMBER;

  -- Procedura per calcolo pcr gb con Merge
  --    stato esecuzione 1 OK 0 Errori
  FUNCTION fnc_load_pcr_gb_merge RETURN NUMBER;

  --caricamento dello storico di pcr_aggr
  FUNCTION fnc_load_storico_pcr(p_id_dper t_mcre0_app_pcr_sc_sb.id_dper%type default null)
  RETURN NUMBER;


END PKG_MCRE0_PCR_NEW;
/


CREATE SYNONYM MCRE_APP.PKG_MCRE0_PCR_NEW FOR MCRE_OWN.PKG_MCRE0_PCR_NEW;


CREATE SYNONYM MCRE_USR.PKG_MCRE0_PCR_NEW FOR MCRE_OWN.PKG_MCRE0_PCR_NEW;


GRANT EXECUTE, DEBUG ON MCRE_OWN.PKG_MCRE0_PCR_NEW TO MCRE_USR;

