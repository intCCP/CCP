CREATE OR REPLACE PACKAGE BODY MCRE_OWN.PKG_MCRES_CHECK_CONTROLLI AS

/******************************************************************************
   NAME:       PKG_MCRES_CHECK_CONTROLLI
   PURPOSE:    Implementazione controlli automatici

   REVISIONS:
   Ver        Date        Author           Description
   ---------  ----------  ---------------  ------------------------------------
   1.0        23/11/2012  A.Pilloni        Created this package.
   1.1        13/02/2013  A.Pilloni        Procedura controllo allineamento alert
   1.2        26/02/2013  A.Pilloni        Reload Alert
******************************************************************************/


PROCEDURE NUM_FLUSSI_GIORNALIERI (P_PID IN NUMBER, P_COD_CHECK IN VARCHAR2, P_ID_DPER DATE, P_RET_VALUE OUT NUMBER, P_RESULT OUT VARCHAR2, P_NOTES OUT VARCHAR2, P_OK VARCHAR2, P_KO VARCHAR2) IS

v_count NUMBER;
v_exp   NUMBER;

BEGIN

SELECT COUNT(*)
  INTO v_count
  FROM
    T_MCRES_WRK_ACQUISIZIONE
 WHERE 0 = 0
   AND TO_CHAR(DTA_INIZIO, 'YYYYMMDDHH24MI') >= TO_CHAR(P_ID_DPER, 'YYYYMMDD') || '1800'
   AND COD_FLUSSO != 'SISBA';


v_exp := PKG_MCRE0_CHECK_ENGINE.GET_EXP_VALUE_THRESHOLD(P_COD_CHECK, 'EXP');


IF (v_count != v_exp) THEN

P_RESULT := p_ko;

P_NOTES := 'La numerosità dei flussi giornalieri non corrisponde al valore atteso ' || v_exp || '.';

ELSE

P_RESULT := p_ok;

P_NOTES := 'La numerosità dei flussi giornalieri corrisponde al valore atteso ' || v_exp || '.';

END IF;


P_RET_VALUE := v_count;

END;


PROCEDURE NUM_FLUSSI_MENSILI_SISBA (P_PID IN NUMBER, P_COD_CHECK IN VARCHAR2, P_ID_DPER DATE, P_RET_VALUE OUT NUMBER, P_RESULT OUT VARCHAR2, P_NOTES OUT VARCHAR2, P_OK VARCHAR2, P_KO VARCHAR2) IS

v_count NUMBER;

v_min   NUMBER;
v_max   NUMBER;
v_exp   NUMBER;


BEGIN

SELECT COUNT(*)
  INTO v_count
  FROM
    T_MCRES_WRK_ACQUISIZIONE
 WHERE 0 = 0
   AND TO_CHAR(DTA_INIZIO, 'YYYYMMDDHH24MI') >= TO_CHAR(P_ID_DPER, 'YYYYMMDD') || '1800'
   AND COD_FLUSSO = 'SISBA'
   AND ID_DPER = LAST_DAY(ADD_MONTHS(TRUNC(SYSDATE), -1));


v_min := PKG_MCRE0_CHECK_ENGINE.GET_EXP_VALUE_THRESHOLD(P_COD_CHECK, 'CMP01');
v_max := PKG_MCRE0_CHECK_ENGINE.GET_EXP_VALUE_THRESHOLD(P_COD_CHECK, 'CMP02');
v_exp := PKG_MCRE0_CHECK_ENGINE.GET_EXP_VALUE_THRESHOLD(P_COD_CHECK, 'EXP');


IF (v_count != v_exp AND TO_NUMBER(TO_CHAR(CURRENT_DATE, 'DD')) BETWEEN v_min AND v_max) THEN

P_RESULT := p_ko;

P_NOTES := 'La numerosità dei flussi mensili SISBA non corrisponde al valore atteso ' || v_exp || '.';

ELSIF (v_count = v_exp) THEN

P_RESULT := p_ok;

P_NOTES := 'La numerosità dei flussi mensili SISBA corrisponde al valore atteso ' || v_exp || '.';

ELSE

P_RESULT := p_ko;

P_NOTES := 'La numerosità dei flussi mensili SISBA attualmente risulta pari a ' || v_count ||
           '. Il valore atteso dal controllo nel periodo dal ' || v_min || ' al ' || v_max || ' del mese corrente Ú di ' || v_exp || '.';

END IF;


P_RET_VALUE := v_count;

END;


PROCEDURE FLUSSI_ELABORATI_ERRORE (P_PID IN NUMBER, P_COD_CHECK IN VARCHAR2, P_ID_DPER DATE, P_RET_VALUE OUT NUMBER, P_RESULT OUT VARCHAR2, P_NOTES OUT VARCHAR2, P_OK VARCHAR2, P_KO VARCHAR2) IS

v_count NUMBER;
v_exp   NUMBER;

BEGIN


INSERT INTO T_MCRES_CHECK_SOF0000003 (PID, COD_FLUSSO, COD_ABI, PROCEDURA, SQL_CODE, MESSAGE, NOTE, DTA_INS)
SELECT
    P_PID,
    B.COD_FLUSSO,
    B.COD_ABI,
    A.PROCEDURA,
    A.SQL_CODE,
    A.MESSAGE,
    A.NOTE,
    A.DTA_INS
FROM
    T_MCRES_WRK_AUDIT_CARICAMENTI A,
    T_MCRES_WRK_ACQUISIZIONE B
WHERE 0 = 0
    AND A.ID_FLUSSO = B.ID_FLUSSO
    AND TO_CHAR(B.DTA_INIZIO, 'YYYYMMDDHH24MI') >= TO_CHAR(P_ID_DPER, 'YYYYMMDD') || '1800'
    AND (B.COD_STATO IS NULL OR B.COD_STATO NOT IN ('PERIODO NON RILEVATO'))
    AND A.LIVELLO = 1;

v_exp := PKG_MCRE0_CHECK_ENGINE.GET_EXP_VALUE_THRESHOLD(P_COD_CHECK, 'EXP');

SELECT COUNT(*)
  INTO v_count
  FROM T_MCRES_CHECK_SOF0000003
 WHERE PID = P_PID;

IF (v_count != v_exp) THEN

P_RESULT := p_ko;

P_NOTES := 'Sono presenti ' || v_count || ' flussi elaborati in errore (Vedi Tab. T_MCRES_CHECK_SOF0000003).';

ELSE

P_RESULT := p_ok;

P_NOTES := 'Non sono presenti flussi elaborati in errore.';

END IF;


P_RET_VALUE := v_count;


COMMIT;

END;


PROCEDURE NUM_FLUSSI_SCARTI (P_PID IN NUMBER, P_COD_CHECK IN VARCHAR2, P_ID_DPER DATE, P_RET_VALUE OUT NUMBER, P_RESULT OUT VARCHAR2, P_NOTES OUT VARCHAR2, P_OK VARCHAR2, P_KO VARCHAR2) IS

v_count NUMBER;
v_exp   NUMBER;

BEGIN


INSERT INTO T_MCRES_CHECK_SOF0000004 (PID, ID_DPER, COD_FLUSSO, COD_ABI, COD_STATO, DTA_INIZIO, DTA_FINE, VAL_SCARTI_CONVERT, VAL_SCARTI_VINCOLI)
SELECT P_PID, ID_DPER, COD_FLUSSO, COD_ABI, COD_STATO, DTA_INIZIO, DTA_FINE, VAL_SCARTI_CONVERT, VAL_SCARTI_VINCOLI FROM
(
    SELECT
        TO_CHAR(ID_DPER, 'YYYYMMDD') ID_DPER,
        COD_FLUSSO,
        COD_ABI,
        COD_STATO,
        DTA_INIZIO,
        DTA_FINE,
        VAL_SCARTI_CONVERT,
        VAL_SCARTI_VINCOLI
    FROM
        T_MCRES_WRK_ACQUISIZIONE
    WHERE 0=0
        AND TO_CHAR(DTA_INIZIO, 'YYYYMMDDHH24MI') >= TO_CHAR(P_ID_DPER, 'YYYYMMDD') || '1800'
        AND (VAL_SCARTI_CONVERT > 0 OR VAL_SCARTI_VINCOLI > 0)
    MINUS
    (
        SELECT
            TO_CHAR(ID_DPER, 'YYYYMMDD') ID_DPER,
            COD_FLUSSO,
            COD_ABI,
            COD_STATO,
            DTA_INIZIO,
            DTA_FINE,
            VAL_SCARTI_CONVERT,
            VAL_SCARTI_VINCOLI
        FROM
            T_MCRES_WRK_ACQUISIZIONE
        WHERE 0=0
            AND TO_CHAR(DTA_INIZIO, 'YYYYMMDDHH24MI') >= TO_CHAR(P_ID_DPER, 'YYYYMMDD') || '1800'
            AND COD_FLUSSO = 'GARANZIE'
            AND VAL_SCARTI_CONVERT = 0
            AND VAL_SCARTI_VINCOLI > 0
        UNION ALL
        SELECT
            TO_CHAR(ID_DPER, 'YYYYMMDD') ID_DPER,
            COD_FLUSSO,
            COD_ABI,
            COD_STATO,
            DTA_INIZIO,
            DTA_FINE,
            VAL_SCARTI_CONVERT,
            VAL_SCARTI_VINCOLI
        FROM
            T_MCRES_WRK_ACQUISIZIONE
        WHERE 0=0
            AND TO_CHAR(DTA_INIZIO, 'YYYYMMDDHH24MI') >= TO_CHAR(P_ID_DPER, 'YYYYMMDD') || '1800'
            AND COD_FLUSSO IN ('PIANIS','STIMES')
            AND VAL_SCARTI_CONVERT = 0
            AND VAL_SCARTI_VINCOLI = 1
    )
)
ORDER BY
   VAL_SCARTI_CONVERT DESC NULLS LAST,
   VAL_SCARTI_VINCOLI DESC NULLS LAST,
   COD_ABI;

v_exp := PKG_MCRE0_CHECK_ENGINE.GET_EXP_VALUE_THRESHOLD(P_COD_CHECK, 'EXP');

SELECT COUNT(*)
  INTO v_count
  FROM T_MCRES_CHECK_SOF0000004
 WHERE PID = P_PID
  AND (VAL_SCARTI_CONVERT != 0 OR VAL_SCARTI_VINCOLI != 0);

IF (v_count != v_exp) THEN

P_RESULT := p_ko;

P_NOTES := 'Sono presenti ' || v_count || ' flussi con scarti (Vedi Tab. T_MCRES_CHECK_SOF0000004).';

ELSE

P_RESULT := p_ok;

P_NOTES := 'Non sono presenti flussi con scarti.';

END IF;


P_RET_VALUE := v_count;


COMMIT;
END;


PROCEDURE CONSISTENZA_DB (P_PID IN NUMBER, P_COD_CHECK IN VARCHAR2, P_ID_DPER DATE, P_RET_VALUE OUT NUMBER, P_RESULT OUT VARCHAR2, P_NOTES OUT VARCHAR2, P_OK VARCHAR2, P_KO VARCHAR2, P_VIEW VARCHAR2) IS

v_count       NUMBER;
v_threshold   NUMBER;

BEGIN

EXECUTE IMMEDIATE 'INSERT INTO T_MCRES_CHECK_SOFCONSDB0 (PID, COD_CHECK, REC) SELECT :1, :2, REC FROM ' || P_VIEW USING P_PID, P_COD_CHECK;

SELECT COUNT(*) - 2
  INTO v_count
  FROM
    T_MCRES_CHECK_SOFCONSDB0
 WHERE 0 = 0
   AND PID = P_PID
   AND COD_CHECK = P_COD_CHECK;

v_threshold := PKG_MCRE0_CHECK_ENGINE.GET_EXP_VALUE_THRESHOLD(P_COD_CHECK, 'CHECK', v_count);

IF (v_threshold = 1) THEN

P_RESULT := p_ok;

P_NOTES := v_count || ' records (Vedi Tab. T_MCRES_CHECK_SOFCONSDB0).';

ELSE

P_RESULT := p_ko;

P_NOTES := v_count || ' records (Vedi Tab. T_MCRES_CHECK_SOFCONSDB0).';

END IF;

P_RET_VALUE := v_count;

END;

PROCEDURE CHECK_ALERT (P_PID IN NUMBER, P_COD_CHECK IN VARCHAR2, P_ID_DPER DATE, P_RET_VALUE OUT NUMBER, P_RESULT OUT VARCHAR2, P_NOTES OUT VARCHAR2, P_OK VARCHAR2, P_KO VARCHAR2, P_ID_ALERT NUMBER, P_QUERY_ALERT CLOB) IS

v_count       NUMBER;
v_exp         NUMBER;
v_noitf       NUMBER;
v_sum         NUMBER;
v_query       NUMBER;
v_ret         NUMBER;

BEGIN

v_exp := PKG_MCRE0_CHECK_ENGINE.GET_EXP_VALUE_THRESHOLD(P_COD_CHECK, 'EXP');

BEGIN

v_noitf := PKG_MCRE0_CHECK_ENGINE.GET_EXP_VALUE_THRESHOLD(P_COD_CHECK, 'NOITF');

EXCEPTION
WHEN NO_DATA_FOUND THEN

v_noitf := 0;

END;

IF (v_noitf = 1) THEN

SELECT SUM(VAL_VERDE + VAL_ARANCIO + VAL_ROSSO)
INTO v_sum
FROM T_MCRES_FEN_ALERT
WHERE ID_ALERT = P_ID_ALERT
  AND COD_UO_PRATICA NOT IN ('12001','12012');

ELSE

SELECT SUM(VAL_VERDE + VAL_ARANCIO + VAL_ROSSO)
INTO v_sum
FROM T_MCRES_FEN_ALERT
WHERE ID_ALERT = P_ID_ALERT;

END IF;


IF v_sum IS NULL THEN

v_sum := 0;

END IF;

EXECUTE IMMEDIATE TO_CHAR(P_QUERY_ALERT) INTO v_query;

v_count := v_sum - v_query;

IF (v_count != v_exp) THEN

P_RESULT := p_ko;

P_NOTES := 'Alert non allineato (FEN_ALERT: ' || v_sum || '; QUERY: ' || v_query || ') => ';

ELSE

P_RESULT := p_ok;

P_NOTES := 'Alert allineato (FEN_ALERT: ' || v_sum || '; QUERY: ' || v_query || ').';

END IF;

P_RET_VALUE := v_count;

IF (P_RESULT = p_ko) THEN

    v_ret := RELOAD_ALERT (P_COD_CHECK, P_ID_ALERT);

    IF (v_ret = 0) THEN

        P_NOTES := P_NOTES || 'RELOAD ESEGUITO.';

    ELSE

        P_NOTES := P_NOTES || 'RELOAD NON ESEGUITO. VEDI CONFIGURAZIONE RELOAD ALERT';

    END IF;

END IF;



END;


FUNCTION RELOAD_ALERT (P_COD_CHECK IN VARCHAR2, P_ID_ALERT NUMBER) RETURN NUMBER IS


cursor c_abi
    is
        select cod_abi
        from t_mcres_app_istituti
        where flg_target = 'Y';

v_del_stmt                  t_mcres_wrk_alimentazione_fen.val_del_qry%type;
v_ins_stmt                  t_mcres_wrk_alimentazione_fen.val_ins_query%type;
v_id_alert                  t_mcre0_check_engine_work.def_id_alert%type;


BEGIN

           select val_del_qry, val_ins_query
             into v_del_stmt, v_ins_stmt
             from t_mcres_wrk_alimentazione_fen
            where 0=0
              and val_tbl_name = 'T_MCRES_FEN_ALERT'
              and replace (upper (flg_gruppo), ' ') = 'ID_ALERT=' || P_ID_ALERT;

            for r_abi in c_abi
            loop

                execute immediate v_del_stmt using r_abi.cod_abi;

                execute immediate v_ins_stmt using r_abi.cod_abi;


            end loop;

commit;

RETURN 0;

exception
when others then

rollback;

RETURN 1;

END;

END;
/


CREATE SYNONYM MCRE_APP.PKG_MCRES_CHECK_CONTROLLI FOR MCRE_OWN.PKG_MCRES_CHECK_CONTROLLI;


CREATE SYNONYM MCRE_USR.PKG_MCRES_CHECK_CONTROLLI FOR MCRE_OWN.PKG_MCRES_CHECK_CONTROLLI;


GRANT EXECUTE, DEBUG ON MCRE_OWN.PKG_MCRES_CHECK_CONTROLLI TO MCRE_USR;

