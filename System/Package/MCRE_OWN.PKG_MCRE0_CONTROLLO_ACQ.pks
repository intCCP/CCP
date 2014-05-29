CREATE OR REPLACE PACKAGE MCRE_OWN.PKG_MCRE0_CONTROLLO_ACQ AS
/******************************************************************************
   NAME:       PKG_MCRE0_CONTROLLO_ACQ
   PURPOSE:

   REVISIONS:
   Ver        Date        Author             Description
   ---------  ----------  -----------------  ------------------------------------
   1.0        21/04/2010  Andrea Bartolomei  Created this package.
   2.0        08/06/2011  Luca Ferretti      Aggiunta procedura per controllo ETL secondo livello
   2.1        22/11/2011  Luca Ferretti      Rimozione di dbms_output
   2.2        25/11/2011  Luca Ferretti      Ordina inserimento in tabella per data desc
   2.3        13/12/2011  Luca Ferertti      Aggiunta procedura per tempistica blocchi TWS2
   2.4        04/10/2012  Luca Ferretti      Commentati controlli su primo livello
******************************************************************************/

    c_package CONSTANT VARCHAR2(50) := 'PKG_MCR0_CONTROLLO_ACQ';

    PROCEDURE SPO_MCRE0_CONTROLLO_ACQ(COD_FLUSSO IN VARCHAR2);
    PROCEDURE SPO_MCRE0_CONTROLLO_ACQ_all;
    FUNCTION  SPO_MCRE0_CONTROLLO_SEC_LIV return number;
    PROCEDURE SPO_MCRE0_TEMPI_BLOCCHI;

END PKG_MCRE0_CONTROLLO_ACQ;
/


CREATE SYNONYM MCRE_APP.PKG_MCRE0_CONTROLLO_ACQ FOR MCRE_OWN.PKG_MCRE0_CONTROLLO_ACQ;


CREATE SYNONYM MCRE_USR.PKG_MCRE0_CONTROLLO_ACQ FOR MCRE_OWN.PKG_MCRE0_CONTROLLO_ACQ;


GRANT EXECUTE, DEBUG ON MCRE_OWN.PKG_MCRE0_CONTROLLO_ACQ TO MCRE_USR;

