CREATE OR REPLACE PACKAGE MCRE_OWN.PKG_MCRES_grant AS
/******************************************************************************
   NAME:     PKG_MCRE0_LOG
   PURPOSE:

   REVISIONS:
   Ver        Date        Author             Description
   ---------  ----------  -----------------  ------------------------------------
   1.0        20/04/2010  Andrea Bartolomei  Created this package.
   1.1        29/04/2011  MM                 Aggiunta GRANT_ALL e grant per TYPE.
   1.2        09/06/2011  MM                 Aggiunto grant ai LOG.
******************************************************************************/

    PROCEDURE own_GRANT_TABLE_SELECT;
    PROCEDURE own_GRANT_TABLE_S_I_U_D;
    PROCEDURE own_GRANT_VIEW_SELECT;
    PROCEDURE own_GRANT_PKG_EXE;
    procedure own_GRANT_ALL;

END PKG_MCRES_grant;
/


CREATE SYNONYM MCRE_APP.PKG_MCRES_GRANT FOR MCRE_OWN.PKG_MCRES_GRANT;


CREATE SYNONYM MCRE_USR.PKG_MCRES_GRANT FOR MCRE_OWN.PKG_MCRES_GRANT;


GRANT EXECUTE, DEBUG ON MCRE_OWN.PKG_MCRES_GRANT TO MCRE_USR;

