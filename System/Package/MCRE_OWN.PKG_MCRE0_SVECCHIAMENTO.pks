CREATE OR REPLACE PACKAGE MCRE_OWN.PKG_MCRE0_SVECCHIAMENTO AS
/******************************************************************************
   NAME:       PKG_MCR0_CONFORMITA
   PURPOSE:

   REVISIONS:
   Ver        Date        Author             Description
   ---------  ----------  -----------------  ------------------------------------
   1.0        21/04/2010  Andrea Bartolomei  Created this package.
   1.1        15/10/2012  Luca Ferretti      Aggiunto log corretto
   1.2        18/10/2012  Luca Ferretti      Aggiunta funzione per svecchiamento settimanale
   1.3        26/10/2012  Luca Ferretti      Aggiunto vincolo su cod_flusso nell'update
   1.4        30/10/2012  Luca Ferretti      Aggiunto log su drop partizione
   1.5        05/11/2012  Luca Ferretti      Aggiunto vincolo su cursore partizioni.
   1.6        12/11/2012  Luca Ferretti      Eliminato svecchiamento tabella di log.
   2.0        20/02/2013  M.Murro            ricerca dellìultimo flusso del mese scorso (ora gira weekly)
******************************************************************************/

    c_package CONSTANT VARCHAR2(50) := 'PKG_MCRE0_SVECCHIAMENTO';

    FUNCTION FND_MCRE0_svecchiamento(p_rec IN f_slave_par_type) RETURN BOOLEAN;
    FUNCTION FND_MCRE0_svecchiamento_weekly RETURN BOOLEAN;

END PKG_MCRE0_SVECCHIAMENTO;
/


CREATE SYNONYM MCRE_APP.PKG_MCRE0_SVECCHIAMENTO FOR MCRE_OWN.PKG_MCRE0_SVECCHIAMENTO;


CREATE SYNONYM MCRE_USR.PKG_MCRE0_SVECCHIAMENTO FOR MCRE_OWN.PKG_MCRE0_SVECCHIAMENTO;


GRANT EXECUTE, DEBUG ON MCRE_OWN.PKG_MCRE0_SVECCHIAMENTO TO MCRE_USR;

