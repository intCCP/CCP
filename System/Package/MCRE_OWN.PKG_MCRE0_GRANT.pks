CREATE OR REPLACE PACKAGE MCRE_OWN.PKG_MCRE0_grant AS
/******************************************************************************
   NAME:     PKG_MCRE0_LOG
   PURPOSE:

   REVISIONS:
   Ver        Date        Author             Description
   ---------  ----------  -----------------  ------------------------------------
   1.0        20/04/2010  Andrea Bartolomei  Created this package.
   1.1        29/04/2011  MM                 Aggiunta GRANT_ALL e grant per TYPE.
   1.2        09/06/2011  MM                 Aggiunto grant ai LOG.
   1.3        25/11/2011  MM                 Grant per tutto mcre.
   1.4        02/04/2012  MM                 gestione eccezioni (per viste scompilate)
******************************************************************************/

    PROCEDURE own_GRANT_TABLE_SELECT;
    PROCEDURE own_GRANT_TABLE_S_I_U_D;
    PROCEDURE own_GRANT_VIEW_SELECT;
    PROCEDURE own_GRANT_PKG_EXE;
    procedure own_GRANT_ALL;

END PKG_MCRE0_grant;
/


CREATE SYNONYM MCRE_APP.PKG_MCRE0_GRANT FOR MCRE_OWN.PKG_MCRE0_GRANT;


CREATE SYNONYM MCRE_USR.PKG_MCRE0_GRANT FOR MCRE_OWN.PKG_MCRE0_GRANT;


GRANT EXECUTE, DEBUG ON MCRE_OWN.PKG_MCRE0_GRANT TO MCRE_USR;

