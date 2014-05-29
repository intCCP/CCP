CREATE OR REPLACE PACKAGE BODY MCRE_OWN.pkg_mcrei_quartz AS
	/*
	  STATI DEI JOB:
			V = Valutato
			A = Avviato
		 C = Completato
		 E = Completato con errori
		  X = Errore di esecuzione del job
		 D = Job da annullare
		 Z = Job annullato
	*/

	FUNCTION inserisci_log_inc_auto (P_DTA_ERRORE						DATE,
												P_DESC_ERRORE						VARCHAR2,
												P_COD_PROTOCOLLO_PACCHETTO 	VARCHAR2,
												P_COD_PROTOCOLLO_DELIBERA		VARCHAR2,
												P_COD_ABI							VARCHAR2,
												P_COD_NDG							VARCHAR2)
		RETURN NUMBER IS
	BEGIN
		INSERT INTO T_MCREI_APP_LOG_INC_AUTO (DTA_ERRORE,
														  DESC_ERRORE,
														  COD_PROTOCOLLO_PACCHETTO,
														  COD_PROTOCOLLO_DELIBERA,
														  COD_ABI,
														  COD_NDG)
		  VALUES   (P_DTA_ERRORE,
						P_DESC_ERRORE,
						P_COD_PROTOCOLLO_PACCHETTO,
						P_COD_PROTOCOLLO_DELIBERA,
						P_COD_ABI,
						P_COD_NDG);

		RETURN pkg_mcrei_web_utilities.const_esito_ok;
	EXCEPTION
		WHEN OTHERS THEN
			RETURN pkg_mcrei_web_utilities.const_esito_ko;
	END INSERISCI_LOG_INC_AUTO;

	/* INCAGLI AUTOMATICI */

	FUNCTION inserisci_esecuzione_quartz (p_dta_esecuzione	IN DATE,
													  p_val_servername	IN VARCHAR)
		RETURN NUMBER IS
		p_num_record		  NUMBER;
		P_NUM_RECORD_IERI   NUMBER;
		STATO_PORTALE		  VARCHAR2 (255);
	BEGIN
		STATO_PORTALE := NULL;
		p_num_record := 0;
		p_num_record_ieri := 0;

		--Determino lo stato del portale
		SELECT	VALORE_COSTANTE
		  INTO	STATO_PORTALE
		  FROM	T_MCRE0_WRK_CONFIGURAZIONE
		 WHERE	NOME_COSTANTE = 'STATO_PORTALE';

		IF STATO_PORTALE IS NULL OR STATO_PORTALE <> '1' THEN
			RETURN 0;
		END IF;

		--verifico esecuzioni
		LOCK TABLE T_MCREI_APP_QUARTZ IN EXCLUSIVE MODE;

		--conto le esecuzioni non completate del job di ieri
		SELECT	COUNT (T_MCREI_APP_QUARTZ.dta_esecuzione) AS conteggio
		  INTO	p_num_record_ieri
		  FROM		T_MCREI_APP_QUARTZ
					LEFT JOIN
						T_MCREI_APP_QUARTZ_ENABLED
					ON TO_CHAR (T_MCREI_APP_QUARTZ.dta_esecuzione, 'DD-MM-YYYY') =
							TO_CHAR (T_MCREI_APP_QUARTZ_ENABLED.dta_esecuzione, 'DD-MM-YYYY')
						AND T_MCREI_APP_QUARTZ_ENABLED.FLG_DISABILITATO = 'S'
		 WHERE	T_MCREI_APP_QUARTZ_ENABLED.dta_esecuzione IS NULL
					AND TO_CHAR (T_MCREI_APP_QUARTZ.dta_esecuzione, 'DD-MM-YYYY') =
							TO_CHAR ( (p_dta_esecuzione - 1), 'DD-MM-YYYY')
					AND T_MCREI_APP_QUARTZ.VAL_STATO IN ('D', 'V', 'A');

		--conto le esecuzioni del job di oggi
		SELECT	COUNT (dta_esecuzione) AS conteggio
		  INTO	p_num_record
		  FROM	T_MCREI_APP_QUARTZ
		 WHERE	TO_CHAR (dta_esecuzione, 'DD-MM-YYYY') =
						TO_CHAR (p_dta_esecuzione, 'DD-MM-YYYY');

		IF p_num_record = 0 AND p_num_record_ieri = 0 THEN
			INSERT INTO T_MCREI_APP_QUARTZ (DTA_ESECUZIONE, VAL_SERVERNAME, VAL_STATO)
			  VALUES   (p_dta_esecuzione, p_val_servername, 'V');

			RETURN 1;																				--Esegui Job
		END IF;

		RETURN 0;																			--Non eseguire Job
	EXCEPTION
		WHEN OTHERS THEN
			RETURN 0;
	END INSERISCI_ESECUZIONE_QUARTZ;

	FUNCTION aggiorna_esecuzione_quartz (p_dta_esecuzione   IN DATE,
													 p_val_servername   IN VARCHAR,
													 p_val_stato		  IN CHAR)
		RETURN NUMBER IS
	BEGIN
		UPDATE	T_MCREI_APP_QUARTZ
			SET	val_stato = p_val_stato
		 WHERE	TO_CHAR (dta_esecuzione, 'DD-MM-YYYY') =
						TO_CHAR (p_dta_esecuzione, 'DD-MM-YYYY')
					AND val_servername = p_val_servername;

		RETURN pkg_mcrei_web_utilities.const_esito_ok;
	EXCEPTION
		WHEN OTHERS THEN
			RETURN pkg_mcrei_web_utilities.const_esito_ko;
	END aggiorna_esecuzione_quartz;

	FUNCTION aggiorna_esecuzione_parere (p_dta_esecuzione 				IN DATE,
													 P_COD_PROTOCOLLO_PACCHETTO	IN VARCHAR)
		RETURN NUMBER IS
	BEGIN
		UPDATE	T_MCREI_PARAM_COMMANDS
			SET	dta_esecuzione = p_dta_esecuzione
		 WHERE		 dta_inserimento IS NOT NULL
					AND dta_esecuzione IS NULL
					AND VAL_PARAM = P_COD_PROTOCOLLO_PACCHETTO
					AND TO_CHAR (dta_inserimento, 'YYYY-MM-DD') <=
							TO_CHAR (p_dta_esecuzione, 'YYYY-MM-DD');

		RETURN pkg_mcrei_web_utilities.const_esito_ok;
	EXCEPTION
		WHEN OTHERS THEN
			RETURN pkg_mcrei_web_utilities.const_esito_ko;
	END aggiorna_esecuzione_parere;

	FUNCTION RICHIESTA_ESECUZIONE_PARERE (P_DTA_INSERIMENTO				 IN DATE,
													  P_COD_PROTOCOLLO_PACCHETTO	 IN VARCHAR)
		RETURN NUMBER IS
	BEGIN
		INSERT INTO T_MCREI_PARAM_COMMANDS (NUM_RETRY,
														VAL_PARAM,
														DTA_INSERIMENTO,
														DTA_ESECUZIONE)
		  VALUES   (5,
						P_COD_PROTOCOLLO_PACCHETTO,
						P_DTA_INSERIMENTO,
						NULL);

		RETURN pkg_mcrei_web_utilities.const_esito_ok;
	EXCEPTION
		WHEN OTHERS THEN
			RETURN pkg_mcrei_web_utilities.const_esito_ko;
	END RICHIESTA_ESECUZIONE_PARERE;

	FUNCTION annulla_esecuzione_quartz (p_dta_esecuzione IN DATE)
		RETURN NUMBER IS
		p_num_record	NUMBER;
	BEGIN
		SELECT	COUNT (dta_esecuzione) AS conteggio
		  INTO	p_num_record
		  FROM	T_MCREI_APP_QUARTZ
		 WHERE	TO_CHAR (DTA_ESECUZIONE, 'DD-MM-YYYY') =
						TO_CHAR (P_DTA_ESECUZIONE, 'DD-MM-YYYY')
					AND T_MCREI_APP_QUARTZ.VAL_STATO IN ('A');

		IF p_num_record = 1 THEN
			UPDATE	T_MCREI_APP_QUARTZ
				SET	val_stato = 'D'
			 WHERE	TO_CHAR (dta_esecuzione, 'DD-MM-YYYY') =
							TO_CHAR (p_dta_esecuzione, 'DD-MM-YYYY');
		ELSE
			RETURN pkg_mcrei_web_utilities.const_esito_ko;
		END IF;

		RETURN pkg_mcrei_web_utilities.const_esito_ok;
	EXCEPTION
		WHEN OTHERS THEN
			RETURN pkg_mcrei_web_utilities.const_esito_ko;
	END annulla_esecuzione_quartz;

	FUNCTION richiedi_esecuzione_quartz (P_DTA_ESECUZIONE IN DATE)
		RETURN NUMBER IS
		p_num_record	NUMBER;
	BEGIN
		SELECT	COUNT (dta_esecuzione) AS conteggio
		  INTO	p_num_record
		  FROM	T_MCREI_APP_QUARTZ
		 WHERE	TO_CHAR (DTA_ESECUZIONE, 'DD-MM-YYYY') =
						TO_CHAR (P_DTA_ESECUZIONE, 'DD-MM-YYYY')
					AND T_MCREI_APP_QUARTZ.VAL_STATO IN ('Z', 'X', 'E', 'C');

		IF P_NUM_RECORD = 1 THEN
			DELETE FROM   T_MCREI_APP_QUARTZ
					WHERE   TO_CHAR (dta_esecuzione, 'DD-MM-YYYY') =
								  TO_CHAR (p_dta_esecuzione, 'DD-MM-YYYY');

			DELETE FROM   T_MCREI_APP_QUARTZ_ENABLED
					WHERE   TO_CHAR (dta_esecuzione, 'DD-MM-YYYY') =
								  TO_CHAR (p_dta_esecuzione, 'DD-MM-YYYY');
		ELSE
			RETURN pkg_mcrei_web_utilities.const_esito_ko;
		END IF;

		RETURN pkg_mcrei_web_utilities.const_esito_ok;
	EXCEPTION
		WHEN OTHERS THEN
			RETURN pkg_mcrei_web_utilities.const_esito_ko;
	END richiedi_esecuzione_quartz;

	/* CONFERIMENTI */

	FUNCTION inserisci_esecuzione_confer (p_dta_esecuzione	IN DATE,
													  p_ora_esecuzione	IN VARCHAR,
													  P_VAL_SERVERNAME	IN VARCHAR)
		RETURN NUMBER IS
		P_DTA_ORA_ESEC_PREC	 VARCHAR (13);
		P_STATO_ESEC_PREC 	 VARCHAR (12);
		P_NUM_RECORD			 NUMBER;
	BEGIN
		--verifico esecuzioni
		LOCK TABLE T_MCREI_APP_CONFERIM_QUARTZ IN EXCLUSIVE MODE;

		--stabilisco se e' in programma una esecuzione per la data e l'ora attuale
		SELECT	COUNT ( * )
		  INTO	P_NUM_RECORD
		  FROM	T_MCREI_APP_CONFERIM_QUARTZ t
		 WHERE		TO_CHAR (T.DTA_ESECUZIONE, 'YYYY-MM-DD')
					|| ':'
					|| TO_CHAR (T.ORA_ESECUZIONE) =
							TO_CHAR (P_DTA_ESECUZIONE, 'YYYY-MM-DD')
						|| ':'
						|| TO_CHAR (P_ORA_ESECUZIONE)
					AND VAL_STATO IS NULL;

		IF P_NUM_RECORD = 1 THEN
			UPDATE	T_MCREI_APP_CONFERIM_QUARTZ
				SET	VAL_STATO = 'V', VAL_SERVERNAME = P_VAL_SERVERNAME
			 WHERE	TO_CHAR (DTA_ESECUZIONE, 'YYYY-MM-DD') =
							TO_CHAR (p_dta_esecuzione, 'YYYY-MM-DD')
						AND ORA_ESECUZIONE = p_ora_esecuzione;

			--individuo esecuzione precedente (P_DTA_ORA_ESEC_PREC)
			P_DTA_ORA_ESEC_PREC := NULL;

			SELECT	MAX(	 TO_CHAR (t.dta_esecuzione, 'YYYY-MM-DD')
							 || ':'
							 || TO_CHAR (t.ora_esecuzione))
			  INTO	P_DTA_ORA_ESEC_PREC
			  FROM	T_MCREI_APP_CONFERIM_QUARTZ t
			 WHERE		TO_CHAR (t.dta_esecuzione, 'YYYY-MM-DD')
						|| ':'
						|| TO_CHAR (t.ora_esecuzione) <=
								TO_CHAR (p_dta_esecuzione, 'YYYY-MM-DD')
							|| ':'
							|| TO_CHAR (p_ora_esecuzione)
						AND	TO_CHAR (t.dta_esecuzione, 'YYYY-MM-DD')
							|| ':'
							|| TO_CHAR (t.ora_esecuzione) <>
									TO_CHAR (p_dta_esecuzione, 'YYYY-MM-DD')
								|| ':'
								|| TO_CHAR (p_ora_esecuzione);

			--stabilisco lo stato dell'ultima esecuzione (P_STATO_ESEC_PREC)
			P_STATO_ESEC_PREC := NULL;

			IF P_DTA_ORA_ESEC_PREC IS NOT NULL THEN
				SELECT	CASE
								WHEN T.VAL_STATO IN ('C', 'E', 'X', 'Z') THEN 'ESEGUITO'
								ELSE 'NON ESEGUITO'
							END
				  INTO	P_STATO_ESEC_PREC
				  FROM	T_MCREI_APP_CONFERIM_QUARTZ t
				 WHERE		TO_CHAR (t.dta_esecuzione, 'YYYY-MM-DD')
							|| ':'
							|| TO_CHAR (t.ora_esecuzione) = P_DTA_ORA_ESEC_PREC;
			END IF;

			--stabilisco se il job debba essere eseguito
			IF P_STATO_ESEC_PREC IS NULL OR P_STATO_ESEC_PREC = 'ESEGUITO' THEN
				RETURN 1;																			--Esegui Job
			END IF;
		END IF;

		RETURN 0;																			--Non eseguire Job
	EXCEPTION
		WHEN OTHERS THEN
			RETURN 0;
	END inserisci_esecuzione_confer;

	FUNCTION aggiorna_esecuzione_confer (p_dta_esecuzione   IN DATE,
													 p_ora_esecuzione   IN VARCHAR,
													 p_val_servername   IN VARCHAR,
													 p_val_stato		  IN CHAR)
		RETURN NUMBER IS
	BEGIN
		UPDATE	T_MCREI_APP_CONFERIM_QUARTZ
			SET	val_stato = p_val_stato
		 WHERE	TO_CHAR (DTA_ESECUZIONE, 'DD-MM-YYYY') =
						TO_CHAR (P_DTA_ESECUZIONE, 'DD-MM-YYYY')
					AND ORA_ESECUZIONE = p_ora_esecuzione;

		RETURN pkg_mcrei_web_utilities.const_esito_ok;
	EXCEPTION
		WHEN OTHERS THEN
			RETURN pkg_mcrei_web_utilities.const_esito_ko;
	END aggiorna_esecuzione_confer;

	FUNCTION annulla_esecuzione_confer (p_dta_esecuzione	 IN DATE,
													p_ora_esecuzione	 IN VARCHAR)
		RETURN NUMBER IS
		P_NUM_RECORD	NUMBER;
	BEGIN
		SELECT	COUNT ( * ) AS conteggio
		  INTO	p_num_record
		  FROM	T_MCREI_APP_CONFERIM_QUARTZ
		 WHERE	TO_CHAR (DTA_ESECUZIONE, 'YYYY-MM-DD') =
						TO_CHAR (P_DTA_ESECUZIONE, 'YYYY-MM-DD')
					AND ORA_ESECUZIONE = p_ora_esecuzione
					AND T_MCREI_APP_CONFERIM_QUARTZ.VAL_STATO IN ('A');

		IF p_num_record = 1 THEN
			UPDATE	T_MCREI_APP_CONFERIM_QUARTZ
				SET	val_stato = 'D'
			 WHERE	TO_CHAR (DTA_ESECUZIONE, 'YYYY-MM-DD') =
							TO_CHAR (P_DTA_ESECUZIONE, 'YYYY-MM-DD')
						AND ORA_ESECUZIONE = p_ora_esecuzione;
		ELSE
			RETURN pkg_mcrei_web_utilities.const_esito_ko;
		END IF;

		RETURN pkg_mcrei_web_utilities.const_esito_ok;
	EXCEPTION
		WHEN OTHERS THEN
			RETURN PKG_MCREI_WEB_UTILITIES.CONST_ESITO_KO;
	END annulla_esecuzione_confer;

	FUNCTION richiedi_esecuzione_confer (P_DTA_ESECUZIONE   IN DATE,
													 P_ORA_ESECUZIONE   IN VARCHAR)
		RETURN NUMBER IS
		p_num_record	NUMBER;
	BEGIN
		--Esecuzione gia' schedulata?
		SELECT	COUNT ( * ) AS conteggio
		  INTO	p_num_record
		  FROM	T_MCREI_APP_CONFERIM_QUARTZ
		 WHERE	TO_CHAR (DTA_ESECUZIONE, 'YYYY-MM-DD') =
						TO_CHAR (P_DTA_ESECUZIONE, 'YYYY-MM-DD')
					AND ORA_ESECUZIONE = p_ora_esecuzione;

		IF P_NUM_RECORD = 0 THEN
			INSERT INTO T_MCREI_APP_CONFERIM_QUARTZ (DTA_ESECUZIONE, ORA_ESECUZIONE)
			  VALUES   (P_DTA_ESECUZIONE, P_ORA_ESECUZIONE);
		ELSE
			RETURN pkg_mcrei_web_utilities.const_esito_ko;
		END IF;

		RETURN pkg_mcrei_web_utilities.const_esito_ok;
	EXCEPTION
		WHEN OTHERS THEN
			RETURN pkg_mcrei_web_utilities.const_esito_ko;
	END richiedi_esecuzione_confer;

	FUNCTION elimina_esecuzione_confer (P_DTA_ESECUZIONE	 IN DATE,
													P_ORA_ESECUZIONE	 IN VARCHAR)
		RETURN NUMBER IS
		p_num_record	NUMBER;
	BEGIN
		--Esecuzione gia' schedulata?
		SELECT	COUNT ( * ) AS conteggio
		  INTO	p_num_record
		  FROM	T_MCREI_APP_CONFERIM_QUARTZ
		 WHERE	TO_CHAR (DTA_ESECUZIONE, 'YYYY-MM-DD') =
						TO_CHAR (P_DTA_ESECUZIONE, 'YYYY-MM-DD')
					AND ORA_ESECUZIONE = P_ORA_ESECUZIONE
					AND VAL_STATO IN ('V', 'A', 'D');

		IF P_NUM_RECORD = 0 THEN
			--non ci sono esecuzioni in corso
			DELETE FROM   T_MCREI_APP_CONFERIM_QUARTZ
					WHERE   TO_CHAR (DTA_ESECUZIONE, 'YYYY-MM-DD') =
								  TO_CHAR (P_DTA_ESECUZIONE, 'YYYY-MM-DD')
							  AND ORA_ESECUZIONE = p_ora_esecuzione;
		ELSE
			RETURN pkg_mcrei_web_utilities.const_esito_ko;
		END IF;

		RETURN pkg_mcrei_web_utilities.const_esito_ok;
	EXCEPTION
		WHEN OTHERS THEN
			RETURN pkg_mcrei_web_utilities.const_esito_ko;
	END elimina_esecuzione_confer;

	-- %AUTHOR
	-- %VERSION 0.1
	-- %USAGE FUNCTION CHE AGGIORNA IL FLAG DI ESITO PER LA TABELLA DEL JOB DELLE RISTRUTTURAZIONI
	-- %D LA FUNCTION, SE P_FLG_ESITO SETTATO LO IMPOSTA SULLA TABELLA DEI CONFERIMENTI
	-- %CD 1 AUG 2012
	FUNCTION SETTA_ESITO_AUTO_RISTR (
		P_COD_ABI		  IN T_MCREI_MORA_POS_RISTR.COD_ABI%TYPE,
		P_COD_NDG		  IN T_MCREI_MORA_POS_RISTR.COD_NDG%TYPE,
		P_VAL_ORDINALE   IN T_MCREI_MORA_POS_RISTR.VAL_ORDINALE%TYPE,
		P_FLG_ESITO 	  IN T_MCREI_MORA_POS_RISTR.FLG_ESITO%TYPE DEFAULT NULL --Valori possibili: [NULL, 'Y', 'N']
	)
		RETURN NUMBER IS
		C_NOME CONSTANT	VARCHAR2 (100) := 'PKG_MCREI_QUARTZ.SETTA_ESITO_AUTO_RISTR';
		P_NOTE				T_MCREI_WRK_AUDIT_APPLICATIVO.NOTE%TYPE;
	BEGIN
		P_NOTE :=
				'Controllo parametri in ingresso: '
			|| P_COD_ABI
			|| ', '
			|| P_COD_NDG
			|| ', '
			|| P_VAL_ORDINALE
			|| ', '
			|| P_FLG_ESITO;

		IF (	 P_COD_ABI IS NULL
			 OR P_COD_NDG IS NULL
			 OR P_VAL_ORDINALE IS NULL
			 OR P_FLG_ESITO IS NULL) THEN
			RAISE_APPLICATION_ERROR (-20666, 'Null parameter');
		ELSE
			P_NOTE :=
					'UPDATE T_MCREI_MORA_POS setta esito job ristrutturazioni:'
				|| P_COD_ABI
				|| ', '
				|| P_COD_NDG
				|| ', '
				|| P_VAL_ORDINALE
				|| ', '
				|| P_FLG_ESITO;

			UPDATE	T_MCREI_MORA_POS_RISTR
				SET	FLG_ESITO = P_FLG_ESITO
			 WHERE		 COD_ABI = P_COD_ABI
						AND COD_NDG = P_COD_NDG
						AND VAL_ORDINALE = P_VAL_ORDINALE;
		END IF;

		PKG_MCREI_AUDIT.LOG_APP (C_NOME,
										 PKG_MCREI_AUDIT.C_DEBUG,
										 SQLCODE,
										 SQLERRM,
										 P_NOTE,
										 NULL);
		RETURN pkg_mcrei_web_utilities.const_esito_ok;
	EXCEPTION
		WHEN OTHERS THEN
			PKG_MCREI_AUDIT.LOG_APP (C_NOME,
											 PKG_MCREI_AUDIT.C_ERROR,
											 SQLCODE,
											 SQLERRM,
											 P_NOTE,
											 NULL);
			RETURN pkg_mcrei_web_utilities.const_esito_ko;
	END SETTA_ESITO_AUTO_RISTR;
END PKG_MCREI_QUARTZ;
/


CREATE SYNONYM MCRE_APP.PKG_MCREI_QUARTZ FOR MCRE_OWN.PKG_MCREI_QUARTZ;


CREATE SYNONYM MCRE_USR.PKG_MCREI_QUARTZ FOR MCRE_OWN.PKG_MCREI_QUARTZ;


GRANT EXECUTE, DEBUG ON MCRE_OWN.PKG_MCREI_QUARTZ TO MCRE_USR;

