CREATE OR REPLACE PACKAGE MCRE_OWN.PKG_MCRE0_MIS AS
/*****************************************************************************************************
NAME:     PKG_MCRE0_MIS
PURPOSE:  delivers MIS (Monitoraggio Incagli Sofferenze) data to QdC

REVISIONS:
Ver        Date        Author             Description
---------  ----------  -----------------  ------------------------------------
1.0        11/04/2011   Paola Goitre       Created this package.
1.1        15/05/2012   Andrea Galliano    Added procedures pPrepareDailyImage pPrepareMonthlyImage pPrepareCurrentImage
1.2        18/05/2012   Andrea Galliano    Added procedure pPrepareCurrentImage
1.3        11/07/2012   Andrea Galliano    Added new pPrepareCurrentImage  pPrepareMonthlyImage
**********************************************************************************************************/

--
PROCEDURE pLog(p_id_dper in number,p_cod_src in varchar2,p_cod_err in number default 0,p_des_err in varchar2 default NULL);
--
PROCEDURE pDeQueue(p_id_dper in number,p_cod_src in varchar2);
--
PROCEDURE pEnQueue(p_id_dper in number,p_cod_src in varchar2);
--
PROCEDURE pPrepareDailyImage;
--
PROCEDURE pPrepareMonthlyImage( p_id_dper number);
--
PROCEDURE pPrepareCurrentImage;
--
PROCEDURE pLoadCurrentImage;

END PKG_MCRE0_MIS;
/


CREATE SYNONYM MCRE_APP.PKG_MCRE0_MIS FOR MCRE_OWN.PKG_MCRE0_MIS;


CREATE SYNONYM MCRE_USR.PKG_MCRE0_MIS FOR MCRE_OWN.PKG_MCRE0_MIS;


GRANT EXECUTE, DEBUG ON MCRE_OWN.PKG_MCRE0_MIS TO MCRE_USR;

