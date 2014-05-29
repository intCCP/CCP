CREATE OR REPLACE PACKAGE MCRE_OWN."PKG_MCRE0_ASS_AUTOM" AS
/******************************************************************************
   NAME:       PKG_MCRE0_ASS_AUTOM
   PURPOSE:

   REVISIONS:
   Ver        Date        Author             Description
   ---------  ----------  -----------------  ------------------------------------
   1.0        21/04/2010  Chiara Giannangeli  Created this package.
   1.1        04/07/2010  M.Murro             sequence di log come parametro
   1.2        13/12/2012  Luca Ferretti       Eliminati i dbms_output
******************************************************************************/

    c_package CONSTANT VARCHAR2(50) := 'PKG_MCRE0_ASS_AUTOM';

    FUNCTION FND_MCRE0_assegna(p_seq number) RETURN NUMBER;
    FUNCTION FND_MCRE0_popola_tmp(p_id NUMBER) RETURN NUMBER;
    FUNCTION FND_MCRE0_update_file_guida(p_id NUMBER) RETURN NUMBER;
    FUNCTION FND_MCRE0_log_warning(p_id NUMBER) RETURN NUMBER;

END PKG_MCRE0_ASS_AUTOM;
/


CREATE SYNONYM MCRE_APP.PKG_MCRE0_ASS_AUTOM FOR MCRE_OWN.PKG_MCRE0_ASS_AUTOM;


CREATE SYNONYM MCRE_USR.PKG_MCRE0_ASS_AUTOM FOR MCRE_OWN.PKG_MCRE0_ASS_AUTOM;


GRANT EXECUTE, DEBUG ON MCRE_OWN.PKG_MCRE0_ASS_AUTOM TO MCRE_USR;

