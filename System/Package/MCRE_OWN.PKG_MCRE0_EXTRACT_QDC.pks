CREATE OR REPLACE PACKAGE MCRE_OWN."PKG_MCRE0_EXTRACT_QDC"
AS
/******************************************************************************
NAME: MCRE_OWN.PKG_MCRE0_EXTRACT_QDC
PURPOSE:

REVISIONS:
 Ver        Date              Author             Description
 ---------  ----------      -----------------  ------------------------------------
 1.0          19/12/2011        C.Giannangeli        Created this package.
 1.1          25/10/2012        D.Manni              Modified: create funzioni
                                                        prc_extract_qdc_cruscdel,
                                                        prc_extract_qdc_bilancio,
                                                        prc_qdc_spool_to_file
 1.2          19/09/2013        D.Manni              Modified: change procedure
                                                        prc_extract_qdc_bilancio
 1.3          21/11/2013        D.Manni              Modified: Aggiunto stato SO a
                                                        funzione fnd_extract_qdc
 1.4          07/01/2014        D.Manni              Modified: dismessa estrazione
                                                        dati Cruscotto e Bilancio
 1.5          02/05/2014       A.Pilloni      commentati movimenti mod mov in extract qdc bilancio
******************************************************************************/
c_package CONSTANT VARCHAR2 (50) := 'PKG_MCRE0_EXTRACT_QDC';
ok NUMBER := 1;
ko NUMBER := 0;

function fnd_extract_qdc (p_id_dper IN varchar2) RETURN NUMBER;

procedure prc_extract_qdc_cruscdel(p_id_dper in varchar2 default null);

procedure prc_extract_qdc_bilancio;

procedure prc_qdc_spool_to_file (p_file_name in varchar2,p_dir in varchar2,p_view in varchar2,orderby varchar2 default null);


END PKG_MCRE0_EXTRACT_QDC;
/


CREATE SYNONYM MCRE_APP.PKG_MCRE0_EXTRACT_QDC FOR MCRE_OWN.PKG_MCRE0_EXTRACT_QDC;


CREATE SYNONYM MCRE_USR.PKG_MCRE0_EXTRACT_QDC FOR MCRE_OWN.PKG_MCRE0_EXTRACT_QDC;


GRANT EXECUTE, DEBUG ON MCRE_OWN.PKG_MCRE0_EXTRACT_QDC TO MCRE_USR;

