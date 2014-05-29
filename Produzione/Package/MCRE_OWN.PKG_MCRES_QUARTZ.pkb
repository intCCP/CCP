CREATE OR REPLACE PACKAGE BODY MCRE_OWN.PKG_MCRES_QUARTZ AS

/******************************************************************************
   NAME:      PKG_MCRES_QUARTZ
   PURPOSE:   Gestione job sofferenze

   REVISIONS:
   Ver        Date        Author             Description
   ---------  ----------  -----------------  -------------------------------
   1.0        29/10/2013  Pepe Mauro         Created this package.
******************************************************************************/

  /*
    Inserisce loggata di una operazione
  */
  FUNCTION inserisci_log ( P_COD_JOB IN CHAR, P_DESC_ERRORE IN VARCHAR2, P_VAL_PARAMS IN VARCHAR2 ) RETURN NUMBER IS
  BEGIN
    INSERT INTO T_MCRES_APP_LOG_JOB (
      COD_JOB,
      DTA_ERRORE,
      DESC_ERRORE,
      VAL_PARAMS
    ) VALUES (
      P_COD_JOB,
      current_timestamp,
      P_DESC_ERRORE,
      P_VAL_PARAMS
    );
    RETURN PKG_MCRES_QUARTZ.c_ok;

    EXCEPTION WHEN OTHERS THEN
      RETURN PKG_MCRES_QUARTZ.c_ko;
  END inserisci_log;

  /*
    Stabilisco ultima esecuzione
  */
  FUNCTION get_ultima_esecuzione ( p_cod_job IN CHAR ) RETURN TIMESTAMP IS
    dta_ultima_esecuzione TIMESTAMP;
  BEGIN
    SELECT
      max(dta_esecuzione)
    INTO
      dta_ultima_esecuzione
    FROM
      T_MCRES_APP_QUARTZ
    WHERE
      cod_job = P_COD_JOB;

    return dta_ultima_esecuzione;
  END get_ultima_esecuzione;

  /*
    Richiede il 'permesso' di eseguire i passi del job
  */
  FUNCTION inizio_job ( p_cod_job IN CHAR, p_val_servername IN VARCHAR2 ) RETURN NUMBER IS
    dta_ultima_esecuzione TIMESTAMP;
    val_esecuzione_in_sospeso NUMBER;
  BEGIN
    --istruzione necessaria per serializzare le invocazioni concorrenti dei diversi server
    LOCK TABLE T_MCRES_APP_QUARTZ IN EXCLUSIVE MODE;

    --stabilisco ultima esecuzione
    dta_ultima_esecuzione := get_ultima_esecuzione( p_cod_job );

    --verifico che l'ultima elaborazione sia stata terminata
    IF dta_ultima_esecuzione IS NOT NULL THEN

      --verifico che oggi non sia stato gia' eseguito
      IF trunc(dta_ultima_esecuzione) = trunc(current_timestamp) THEN
        RETURN PKG_MCRES_QUARTZ.c_non_procedere;
      END IF;

      --verifico che non sia presente un'elaborazione precedente in sospeso
      val_esecuzione_in_sospeso := 0;
      SELECT
        count(*)
      INTO
        val_esecuzione_in_sospeso
      FROM
        T_MCRES_APP_QUARTZ
      WHERE
        dta_esecuzione = dta_ultima_esecuzione
        AND cod_job = p_cod_job
        AND cod_stato in (c_stato_avviato, c_stato_da_annullare);

      IF val_esecuzione_in_sospeso > 0 THEN
        RETURN PKG_MCRES_QUARTZ.c_non_procedere;
      END IF;

    END IF;

    --si puo' procedere
    INSERT INTO T_MCRES_APP_QUARTZ (
      dta_esecuzione,
      cod_job,
      cod_stato,
      val_servername
    ) VALUES (
      current_timestamp,
      p_cod_job,
      PKG_MCRES_QUARTZ.c_stato_avviato,
      p_val_servername
    );

    RETURN PKG_MCRES_QUARTZ.c_procedi;

    EXCEPTION WHEN OTHERS THEN
      RETURN PKG_MCRES_QUARTZ.c_non_procedere;
  END inizio_job;

  /*
    Imposta lo stato dell'ultima esecuzione del job in 'terminato'
  */
  FUNCTION fine_job ( p_cod_job IN CHAR ) RETURN NUMBER IS
    dta_ultima_esecuzione TIMESTAMP;
  BEGIN
    dta_ultima_esecuzione := get_ultima_esecuzione( p_cod_job );

    update
      T_MCRES_APP_QUARTZ
    set
      cod_stato = PKG_MCRES_QUARTZ.c_stato_completato
    where
      dta_esecuzione = dta_ultima_esecuzione
      and cod_job = p_cod_job;

    RETURN PKG_MCRES_QUARTZ.c_ok;

    EXCEPTION WHEN OTHERS THEN
      RETURN PKG_MCRES_QUARTZ.c_ko;
  END fine_job;

  /*
    Imposta lo stato dell'ultima esecuzione del job in 'terminato con errore'
  */
  FUNCTION fine_job_con_errore ( p_cod_job IN CHAR ) RETURN NUMBER IS
    dta_ultima_esecuzione TIMESTAMP;
  BEGIN
    dta_ultima_esecuzione := get_ultima_esecuzione( p_cod_job );

    update
      T_MCRES_APP_QUARTZ
    set
      cod_stato = PKG_MCRES_QUARTZ.c_stato_errore
    where
      dta_esecuzione = dta_ultima_esecuzione
      and cod_job = p_cod_job;

    RETURN PKG_MCRES_QUARTZ.c_ok;

    EXCEPTION WHEN OTHERS THEN
      RETURN PKG_MCRES_QUARTZ.c_ko;
  END fine_job_con_errore;

  /*
    Imposta lo stato dell'ultima esecuzione del job in 'richiesta annullo'
  */
  FUNCTION richiedi_annullo_job ( p_cod_job IN CHAR ) RETURN NUMBER IS
    dta_ultima_esecuzione TIMESTAMP;
  BEGIN
    --istruzione necessaria per serializzare le invocazioni concorrenti dei diversi server
    LOCK TABLE T_MCRES_APP_QUARTZ IN EXCLUSIVE MODE;

    dta_ultima_esecuzione := get_ultima_esecuzione( p_cod_job );

    update
      T_MCRES_APP_QUARTZ
    set
      cod_stato = PKG_MCRES_QUARTZ.c_stato_da_annullare
    where
      dta_esecuzione = dta_ultima_esecuzione
      and cod_job = p_cod_job
      and cod_stato = PKG_MCRES_QUARTZ.c_stato_avviato;

    if (sql%rowcount = 0) then
      RETURN PKG_MCRES_QUARTZ.c_ko;
    end if;

    RETURN PKG_MCRES_QUARTZ.c_ok;

    EXCEPTION WHEN OTHERS THEN
      RETURN PKG_MCRES_QUARTZ.c_ko;
  END richiedi_annullo_job;

  /*
    Imposta lo stato dell'ultima esecuzione del job in 'annullato'
  */
  FUNCTION annulla_job ( p_cod_job IN CHAR ) RETURN NUMBER IS
    dta_ultima_esecuzione TIMESTAMP;
  BEGIN
    dta_ultima_esecuzione := get_ultima_esecuzione( p_cod_job );

    update
      T_MCRES_APP_QUARTZ
    set
      cod_stato = PKG_MCRES_QUARTZ.c_stato_annullato
    where
      dta_esecuzione = dta_ultima_esecuzione
      and cod_job = p_cod_job;

    RETURN PKG_MCRES_QUARTZ.c_ok;

    EXCEPTION WHEN OTHERS THEN
      RETURN PKG_MCRES_QUARTZ.c_ko;
  END annulla_job;

  /*
    Imposta lo stato dell'ultima esecuzione del job in 'annullato'
  */
  FUNCTION elimina_ultima_esecuzione_job ( p_cod_job IN CHAR ) RETURN NUMBER IS
  BEGIN
    --istruzione necessaria per serializzare le invocazioni concorrenti dei diversi server
    LOCK TABLE T_MCRES_APP_QUARTZ IN EXCLUSIVE MODE;

    delete from
      T_MCRES_APP_QUARTZ
    where
      trunc(dta_esecuzione) = trunc( current_timestamp )
      and cod_job = p_cod_job
      and cod_stato not in (PKG_MCRES_QUARTZ.c_stato_avviato, PKG_MCRES_QUARTZ.c_stato_da_annullare);

    if (sql%rowcount = 0) then
      RETURN PKG_MCRES_QUARTZ.c_ko;
    end if;

    RETURN PKG_MCRES_QUARTZ.c_ok;

    EXCEPTION WHEN OTHERS THEN
      RETURN PKG_MCRES_QUARTZ.c_ko;
  END elimina_ultima_esecuzione_job;

  /*
    Restituisce lo stato dell'ultima esecuzione del job
  */
  FUNCTION get_stato_job ( p_cod_job IN CHAR ) RETURN CHAR IS
    cod_ultimo_stato char;
    dta_ultima_esecuzione TIMESTAMP;
  BEGIN
    dta_ultima_esecuzione := get_ultima_esecuzione( p_cod_job );

    select
      cod_stato
    into
      cod_ultimo_stato
    from
      T_MCRES_APP_QUARTZ
    where
      dta_esecuzione = dta_ultima_esecuzione
      and cod_job = p_cod_job;

    return cod_ultimo_stato;
  END get_stato_job;

END PKG_MCRES_QUARTZ;
/


CREATE SYNONYM MCRE_APP.PKG_MCRES_QUARTZ FOR MCRE_OWN.PKG_MCRES_QUARTZ;


GRANT EXECUTE, DEBUG ON MCRE_OWN.PKG_MCRES_QUARTZ TO MCRE_USR;

