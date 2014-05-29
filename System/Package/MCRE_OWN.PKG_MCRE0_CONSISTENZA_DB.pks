CREATE OR REPLACE PACKAGE MCRE_OWN.PKG_MCRE0_CONSISTENZA_DB
IS
/******************************************************************************
   NAME:       PKG_MCRE0_CONSISTENZA_DB
   PURPOSE:    Eseguire un check sulla consistenza del database e fornire un resoconto sullo stesso.

   REVISIONS:
   Ver        Date        Author             Description
   ---------  ----------  -----------------  ------------------------------------
   1.0        05/06/2012 Luca Ferretti       Created this package.
   1.1        19/06/2012 Luca Ferretti       Aggiunta procedura di scrittura clob su file
   1.2        23/12/2012 Luca Ferretti       Modifica calcolo posizioni segnalate
   1.3        03/12/2012 Luca Ferretti       Aggiunta descrizione controllo nella insert
   1.4        04/12/2012 Luca Ferretti       Gestione soglia
******************************************************************************/

ret_ok      number := 0;
ret_ko      number := 1;


FUNCTION FND_MCRE0_MASTER RETURN NUMBER;

FUNCTION FND_MCRE0_chiusura_pratiche (
      p_id_lotto   IN   T_MCRE0_CHK_CONSISTENZA_DB.id_lotto%TYPE
   ) RETURN NUMBER;

FUNCTION FND_MCRE0_chiusura_rapporti (
      p_id_lotto   IN   T_MCRE0_CHK_CONSISTENZA_DB.id_lotto%TYPE
   ) RETURN NUMBER;

FUNCTION FND_MCRE0_check_num_pratiche (
      p_id_lotto   IN   T_MCRE0_CHK_CONSISTENZA_DB.id_lotto%TYPE
   ) RETURN NUMBER;

FUNCTION FND_MCRE0_check_num_delibere (
      p_id_lotto   IN   T_MCRE0_CHK_CONSISTENZA_DB.id_lotto%TYPE
   ) RETURN NUMBER;

FUNCTION FND_MCRE0_stato_rischio (
      p_id_lotto   IN   T_MCRE0_CHK_CONSISTENZA_DB.id_lotto%TYPE
   ) RETURN NUMBER;

FUNCTION FND_MCRE0_stato_mople_soff (
      p_id_lotto   IN   T_MCRE0_CHK_CONSISTENZA_DB.id_lotto%TYPE
   ) RETURN NUMBER;

FUNCTION FND_MCRE0_stato_soff_mople (
      p_id_lotto   IN   T_MCRE0_CHK_CONSISTENZA_DB.id_lotto%TYPE
   ) RETURN NUMBER;

PROCEDURE PRC_MCRE0_clob_to_file (
      p_dir        IN   varchar2,
      p_file       IN   varchar2,
      p_clob       IN   clob
   ) ;

FUNCTION FND_MCRE0_create_file
    RETURN NUMBER;

END;
/


CREATE SYNONYM MCRE_APP.PKG_MCRE0_CONSISTENZA_DB FOR MCRE_OWN.PKG_MCRE0_CONSISTENZA_DB;


CREATE SYNONYM MCRE_USR.PKG_MCRE0_CONSISTENZA_DB FOR MCRE_OWN.PKG_MCRE0_CONSISTENZA_DB;


GRANT EXECUTE, DEBUG ON MCRE_OWN.PKG_MCRE0_CONSISTENZA_DB TO MCRE_USR;

