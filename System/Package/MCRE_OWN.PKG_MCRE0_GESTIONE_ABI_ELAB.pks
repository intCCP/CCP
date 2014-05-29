CREATE OR REPLACE PACKAGE MCRE_OWN."PKG_MCRE0_GESTIONE_ABI_ELAB" AS
/******************************************************************************
   NAME:       PKG_MCRE0_ALIMENTAZIONE
   PURPOSE:

   REVISIONS:
   Ver        Date        Author             Description
   ---------  ----------  -----------------  ------------------------------------
   1.0        14/02/2011  Marco Murro        Created this package.
   1.1        01/03/2011  Marco Murro        Fix aggiorna_ge
   1.2        13/11/2012  Marco Murro        Fix aggiorna_fguida set flg_active = 1, aggiorna_mople today = 1
******************************************************************************/

  c_package CONSTANT VARCHAR2(50) := 'PKG_MCRE0_GESTIONE_ABI_ELAB';

  ok number := 1;
  ko number := 0;

  -- Procedura per controllo fine caricamenti
  --    stato esecuzione 1 OK 0 Errori
  FUNCTION aggiorna_mople return number ;

  FUNCTION aggiorna_file_guida return number ;

  FUNCTION aggiorna_legami return number ;

  FUNCTION aggiorna_ge return number ;

  FUNCTION check_abi_elab return number;


end PKG_MCRE0_GESTIONE_ABI_ELAB;
/


CREATE SYNONYM MCRE_APP.PKG_MCRE0_GESTIONE_ABI_ELAB FOR MCRE_OWN.PKG_MCRE0_GESTIONE_ABI_ELAB;


CREATE SYNONYM MCRE_USR.PKG_MCRE0_GESTIONE_ABI_ELAB FOR MCRE_OWN.PKG_MCRE0_GESTIONE_ABI_ELAB;


GRANT EXECUTE, DEBUG ON MCRE_OWN.PKG_MCRE0_GESTIONE_ABI_ELAB TO MCRE_USR;

