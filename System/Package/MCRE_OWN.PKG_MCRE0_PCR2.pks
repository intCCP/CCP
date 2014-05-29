CREATE OR REPLACE PACKAGE MCRE_OWN."PKG_MCRE0_PCR2" AS
/******************************************************************************
   NAME:     PKG_MCRE0_PCR2
   PURPOSE: Gestione alert ed evidenze

   REVISIONS:
   Ver        Date        Author             Description
   ---------  ----------  -----------------  ------------------------------------
   1.0        07/06/2011  Galli Valeria      Created this package.
   1.1        09/06/2011  Galli Valeria      Tabella T_mcre0_app_PCR e LOG
   2.0        08/08/2011  Marco Murro        Aggiunta Gestioen today_flg - tuning!
   2.1        02/09/2011  Marco Murro        Fix Gestioen today_flg - tuning!
   2.2        05/09/2011  Marco Murro        Fix gb_merge per sndg variati
   2.3        06/09/2011  Marco Murro        Fix merge per sndg variati + gestione ko
   3.1        06/09/2011  Alberto Guzzi      Fix Blocco il piano di esecuzione
******************************************************************************/

  ok number := 1;
  ko number := 0;

  -- Procedura per calcolo MAU
  -- INPUT :
  -- OUTPUT :
  --    stato esecuzione 1 OK 0 Errori
  FUNCTION FNC_CALCOLO_MAU (
    P_COD_LOG T_MCRE0_WRK_AUDIT_ETL.ID%TYPE DEFAULT NULL)
  RETURN NUMBER;

  -- Procedura per pulizia delle posizioni di file guida senza pcr
  -- INPUT :
  -- OUTPUT :
  --    stato esecuzione 1 OK 0 Errori
  FUNCTION fnc_clean_no_pcr  (
    P_COD_LOG T_MCRE0_WRK_AUDIT_ETL.ID%TYPE DEFAULT NULL )
  RETURN NUMBER;

  -- Procedura per calcolo pcr
  -- INPUT :
  -- OUTPUT :
  --    stato esecuzione 1 OK 0 Errori
  FUNCTION fnc_load_pcr (
    P_COD_LOG T_MCRE0_WRK_AUDIT_ETL.ID%TYPE DEFAULT NULL )
  RETURN NUMBER;

  -- Procedura per calcolo pcr scsb con Merge
  --    stato esecuzione 1 OK 0 Errori
  FUNCTION fnc_load_pcr_scsb_merge (
    P_COD_LOG T_MCRE0_WRK_AUDIT_ETL.ID%TYPE DEFAULT NULL )
  RETURN NUMBER;

  -- Procedura per calcolo pcr gesb con Merge
  --    stato esecuzione 1 OK 0 Errori
  FUNCTION fnc_load_pcr_gesb_merge (
    P_COD_LOG T_MCRE0_WRK_AUDIT_ETL.ID%TYPE DEFAULT NULL )
  RETURN NUMBER;

  -- Procedura per calcolo pcr gb con Merge
  --    stato esecuzione 1 OK 0 Errori
  FUNCTION FNC_LOAD_PCR_GB_MERGE (
    P_COD_LOG T_MCRE0_WRK_AUDIT_ETL.ID%TYPE DEFAULT NULL )
  RETURN NUMBER;

END PKG_MCRE0_PCR2;
/


CREATE SYNONYM MCRE_APP.PKG_MCRE0_PCR2 FOR MCRE_OWN.PKG_MCRE0_PCR2;


CREATE SYNONYM MCRE_USR.PKG_MCRE0_PCR2 FOR MCRE_OWN.PKG_MCRE0_PCR2;


GRANT EXECUTE, DEBUG ON MCRE_OWN.PKG_MCRE0_PCR2 TO MCRE_USR;

