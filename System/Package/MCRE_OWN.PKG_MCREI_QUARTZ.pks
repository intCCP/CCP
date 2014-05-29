CREATE OR REPLACE PACKAGE MCRE_OWN.pkg_mcrei_quartz AS
	c_package CONSTANT	VARCHAR2 (50) := 'PKG_MCREI_QUARTZ';

	FUNCTION inserisci_log_inc_auto (P_DTA_ERRORE						DATE,
												P_DESC_ERRORE						VARCHAR2,
												P_COD_PROTOCOLLO_PACCHETTO 	VARCHAR2,
												P_COD_PROTOCOLLO_DELIBERA		VARCHAR2,
												P_COD_ABI							VARCHAR2,
												P_COD_NDG							VARCHAR2)
		RETURN NUMBER;

	/* INCAGLI AUTOMATICI */

	FUNCTION inserisci_esecuzione_quartz (p_dta_esecuzione	IN DATE,
													  p_val_servername	IN VARCHAR)
		RETURN NUMBER;

	FUNCTION aggiorna_esecuzione_quartz (p_dta_esecuzione   IN DATE,
													 p_val_servername   IN VARCHAR,
													 p_val_stato		  IN CHAR)
		RETURN NUMBER;

	FUNCTION annulla_esecuzione_quartz (p_dta_esecuzione IN DATE)
		RETURN NUMBER;

	FUNCTION richiedi_esecuzione_quartz (P_DTA_ESECUZIONE IN DATE)
		RETURN NUMBER;

	FUNCTION aggiorna_esecuzione_parere (p_dta_esecuzione 				IN DATE,
													 P_COD_PROTOCOLLO_PACCHETTO	IN VARCHAR)
		RETURN NUMBER;

	FUNCTION RICHIESTA_ESECUZIONE_PARERE (P_DTA_INSERIMENTO				 IN DATE,
													  P_COD_PROTOCOLLO_PACCHETTO	 IN VARCHAR)
		RETURN NUMBER;

	/* CONFERIMENTI */

	FUNCTION inserisci_esecuzione_confer (p_dta_esecuzione	IN DATE,
													  p_ora_esecuzione	IN VARCHAR,
													  p_val_servername	IN VARCHAR)
		RETURN NUMBER;

	FUNCTION aggiorna_esecuzione_confer (p_dta_esecuzione   IN DATE,
													 p_ora_esecuzione   IN VARCHAR,
													 p_val_servername   IN VARCHAR,
													 p_val_stato		  IN CHAR)
		RETURN NUMBER;

	FUNCTION annulla_esecuzione_confer (p_dta_esecuzione	 IN DATE,
													p_ora_esecuzione	 IN VARCHAR)
		RETURN NUMBER;

	FUNCTION richiedi_esecuzione_confer (P_DTA_ESECUZIONE   IN DATE,
													 p_ora_esecuzione   IN VARCHAR)
		RETURN NUMBER;

	FUNCTION elimina_esecuzione_confer (P_DTA_ESECUZIONE	 IN DATE,
													P_ORA_ESECUZIONE	 IN VARCHAR)
		RETURN NUMBER;

	FUNCTION SETTA_ESITO_AUTO_RISTR (
		P_COD_ABI		  IN T_MCREI_MORA_POS_RISTR.COD_ABI%TYPE,
		P_COD_NDG		  IN T_MCREI_MORA_POS_RISTR.COD_NDG%TYPE,
		P_VAL_ORDINALE   IN T_MCREI_MORA_POS_RISTR.VAL_ORDINALE%TYPE,
		P_FLG_ESITO 	  IN T_MCREI_MORA_POS_RISTR.FLG_ESITO%TYPE DEFAULT NULL
	)
		RETURN NUMBER;
END pkg_mcrei_quartz;
/


CREATE SYNONYM MCRE_APP.PKG_MCREI_QUARTZ FOR MCRE_OWN.PKG_MCREI_QUARTZ;


CREATE SYNONYM MCRE_USR.PKG_MCREI_QUARTZ FOR MCRE_OWN.PKG_MCREI_QUARTZ;


GRANT EXECUTE, DEBUG ON MCRE_OWN.PKG_MCREI_QUARTZ TO MCRE_USR;

