CREATE OR REPLACE PACKAGE BODY MCRE_OWN.PKG_MCREI_ALIMENTA_STORICO_DEL AS
/******************************************************************************
   NAME:       PKG_MCREI_ALIMENTA_STORICO_DEL
   PURPOSE:    STORICIZZARE GIORNALMENTE LE DELIBERE
  NOTA: PER DISABILTARE UNA QUALUNQUE FUNZIONALITA
  ASSEGNARE A T_MCREI_WRK_ALIMENTAZIONE_ST.FLG_ATTIVA= 0

   REVISIONS:
   VER        DATE        AUTHOR           DESCRIPTION
   ---------  ----------  ---------------  ------------------------------------
   1.0        18/03/2013   I.GUEORGUIEVA   1. CREATED THIS PACKAGE.
******************************************************************************/

  FUNCTION FNC_ALIMENTA_STORICO RETURN NUMBER IS
  V_FLUSSO_APP        T_MCREI_WRK_ALIMENTAZIONE.COD_FLUSSO%TYPE;
  V_QRY_APP_ATTIVA    T_MCREI_WRK_ALIMENTAZIONE_ST.VAL_QRY_APP_ATTIVA%TYPE;
  NOTE                T_MCREI_WRK_AUDIT_CARICAMENTI.NOTE%TYPE := 'GENERALE';
  V_VAL_TAB_APP       T_MCREI_WRK_ALIMENTAZIONE_ST.VAL_TAB_APP%TYPE;
  C_NOME              T_MCREI_WRK_AUDIT_CARICAMENTI.PROCEDURA%TYPE:=C_PACKAGE||'.FNC_ALIMENTA_STORICO';
  V_LOCK_RESULT       NUMBER;
  V_LOCKHANDLE        VARCHAR2 (200);
  V_FLUSSO            NUMBER:=TO_NUMBER(TO_CHAR(SYSDATE,'YYYYMMDD'));
  V_ESITO             NUMBER;
  V_IDDPER_STO        NUMBER;
  V_COD_ABI           VARCHAR2(5);
  V_PERIODO_STO       DATE;
  V_MAX_ID_DPER       DATE;
  V_TOMORROW          DATE;

  CURSOR CQRY IS
      SELECT VAL_QRY_APP_ATTIVA, VAL_TAB_APP
      INTO V_QRY_APP_ATTIVA, V_VAL_TAB_APP
       FROM T_MCREI_WRK_ALIMENTAZIONE_ST
    WHERE FLG_ATTIVA = 1
      AND ORDINE_ELABORAZIONE IN (1,2)
    ORDER BY ORDINE_ELABORAZIONE ASC;
  BEGIN

    BEGIN
    SELECT MAX(ID_DPER)
      INTO V_MAX_ID_DPER
      FROM T_MCREI_WRK_ACQUISIZIONE
    WHERE COD_FILE NOT LIKE 'PROPOSTE_MOPLE%'
     AND COD_FILE LIKE 'DELIBERE%';
    EXCEPTION WHEN OTHERS THEN
         NOTE:='Non rilevato id_dper massimo per archivio '||TO_CHAR(SYSDATE);
         PKG_MCREI_AUDIT.LOG_CARICAMENTI(V_FLUSSO, C_NOME,PKG_MCREI_AUDIT.C_ERROR, SQLCODE, SQLERRM, NOTE);
         RETURN OK;
    END;
    NOTE:='NON SI STORICIZZA OGGI '||TO_NUMBER(TO_CHAR (V_MAX_ID_DPER, 'YYYYMMDD')) ;
                 SELECT CASE
                      WHEN TO_CHAR (V_MAX_ID_DPER,
                                    'D',
                                    'NLS_DATE_LANGUAGE = ITALIAN'
                                   ) = 1
                         THEN (V_MAX_ID_DPER+1)
                      WHEN TO_CHAR (V_MAX_ID_DPER,
                                    'D',
                                    'NLS_DATE_LANGUAGE = ITALIAN'
                                   ) = 2
                         THEN (V_MAX_ID_DPER + 1)
                      WHEN TO_CHAR (V_MAX_ID_DPER,
                                    'D',
                                    'NLS_DATE_LANGUAGE = ITALIAN'
                                   ) = 3
                         THEN (V_MAX_ID_DPER + 1)
                      WHEN TO_CHAR (V_MAX_ID_DPER,
                                    'D',
                                    'NLS_DATE_LANGUAGE = ITALIAN'
                                   ) = 4
                         THEN (V_MAX_ID_DPER + 1)
                      WHEN TO_CHAR (V_MAX_ID_DPER,
                                    'D',
                                    'NLS_DATE_LANGUAGE = ITALIAN'
                                   ) = 5
                         THEN (V_MAX_ID_DPER + 3) -- DI VENERDI CREA LA NUOVA PARTIZIONE
                   ELSE (V_MAX_ID_DPER)
                   END,
                 TO_NUMBER(TO_CHAR (TRUNC ((V_MAX_ID_DPER),'MM'),'YYYYMMDD')),TRUNC (V_MAX_ID_DPER,'MM')
              INTO V_TOMORROW,V_IDDPER_STO, V_PERIODO_STO
              FROM DUAL;
            IF TO_NUMBER(TO_CHAR (V_PERIODO_STO, 'YYYYMM')) <
                    TO_NUMBER (TO_CHAR (V_TOMORROW, 'YYYYMM'))
            THEN
               NOTE:='STORICIZZAZIONE MESE'||TO_NUMBER(TO_CHAR (V_PERIODO_STO, 'YYYYMMDD')) ;
               V_ESITO :=PKG_MCREI_GESTIONE_PARTIZIONI.FNC_CREA_PARTIZIONE ('T_MCREI_APP_DELIBERE_STORICO',
                                             (TO_CHAR (TRUNC (V_MAX_ID_DPER,'MM'),'YYYYMMDD')),
                                             V_FLUSSO,
                                             'MULTI');
                IF V_ESITO = 1 THEN
                FOR RQRY IN CQRY LOOP
                ------------------------------------------------------------------------------------
                EXECUTE IMMEDIATE TO_CHAR (RQRY.VAL_QRY_APP_ATTIVA) USING V_PERIODO_STO;
                COMMIT;
                -------------------------------------------------------------------------------------
                END LOOP;
                END IF;
            END IF;
           -- V_LOCK_RESULT := DBMS_LOCK.RELEASE (V_LOCKHANDLE);
            PKG_MCREI_AUDIT.LOG_CARICAMENTI(V_FLUSSO, C_NOME,PKG_MCREI_AUDIT.C_ERROR, SQLCODE, SQLERRM, NOTE);
            RETURN OK;
  EXCEPTION WHEN OTHERS THEN
    PKG_MCREI_AUDIT.LOG_CARICAMENTI(V_FLUSSO, C_NOME,PKG_MCREI_AUDIT.C_ERROR, SQLCODE, SQLERRM, NOTE);
    ROLLBACK;
    RETURN KO;
  END;

-- IN FONDO ALL'ALERT 5 PRESUBILMENTE
  FUNCTION FNC_STORICIZZA_DELIB_DAILY RETURN NUMBER IS
  V_FLUSSO            NUMBER:=TO_NUMBER(TO_CHAR(SYSDATE,'YYYYMMDD'));
  C_NOME              T_MCREI_WRK_AUDIT_CARICAMENTI.PROCEDURA%TYPE:=C_PACKAGE||'.FNC_STORICIZZA_DELIB_DAILY';
  NOTE                T_MCREI_WRK_AUDIT_CARICAMENTI.NOTE%TYPE := 'GENERALE';
  V_MAX_ID_DPER DATE;

  CURSOR CQRY IS
      SELECT VAL_QRY_APP_ATTIVA, VAL_TAB_APP
       FROM T_MCREI_WRK_ALIMENTAZIONE_ST
    WHERE FLG_ATTIVA = 1
      AND ORDINE_ELABORAZIONE in (3,4)
    ORDER BY ORDINE_ELABORAZIONE ASC;
  BEGIN
        BEGIN
        SELECT MAX(ID_DPER)
          INTO V_MAX_ID_DPER
          FROM T_MCREI_WRK_ACQUISIZIONE
        WHERE COD_FILE NOT LIKE 'PROPOSTE_MOPLE%'
             AND COD_FILE LIKE 'DELIBERE%';
        EXCEPTION WHEN OTHERS THEN
             NOTE:='Non rilevato id_dper massimo per archivio '||TO_CHAR(SYSDATE);
             PKG_MCREI_AUDIT.LOG_CARICAMENTI(V_FLUSSO, C_NOME,PKG_MCREI_AUDIT.C_ERROR, SQLCODE, SQLERRM, NOTE);
             RETURN OK;
        END;
        BEGIN
        EXECUTE IMMEDIATE 'TRUNCATE TABLE T_MCREI_WRK_DELIB_DAILY';
        INSERT INTO T_MCREI_WRK_DELIB_DAILY(
        ID_DPER, COD_ABI, COD_NDG, COD_PROTOCOLLO_DELIBERA, COD_PROTOCOLLO_PACCHETTO, COD_FASE_DELIBERA,
        COD_MICROTIPOLOGIA_DELIB,
        DTA_LAST_UPD_DELIBERA)
        (SELECT
        ID_DPER, COD_ABI, COD_NDG, COD_PROTOCOLLO_DELIBERA, COD_PROTOCOLLO_PACCHETTO, COD_FASE_DELIBERA,
        COD_MICROTIPOLOGIA_DELIB,
        DTA_LAST_UPD_DELIBERA
              FROM T_MCREI_ST_DELIBERE
         WHERE ID_DPER = TO_NUMBER(TO_CHAR(V_MAX_ID_DPER,'YYYYMMDD'))
         AND COD_PROTOCOLLO_PACCHETTO IS NULL
         UNION
          SELECT  ID_DPER, COD_ABI, COD_NDG, COD_PROTOCOLLO_DELIBERA, COD_PROTOCOLLO_PACCHETTO,
                  DECODE(cod_stato_proposto, 'S','IN', 'B','CO','IN')  AS COD_FASE_DELIBERA,
                  DECODE (cod_tipo_proposta, 'S', 'CS', 'CI')AS COD_MICROTIPOLOGIA_DELIB,
        TO_DATE(NULL) DTA_LAST_UPD_DELIBERA
              FROM T_MCREI_ST_PROPOSTE
         WHERE ID_DPER = TO_NUMBER(TO_CHAR(V_MAX_ID_DPER,'YYYYMMDD'))
         AND COD_PROTOCOLLO_PACCHETTO IS NULL
         );
         COMMIT;

            FOR RQRY IN CQRY LOOP
            ------------------------------------------------------------------------------------
            EXECUTE IMMEDIATE TO_CHAR (RQRY.VAL_QRY_APP_ATTIVA);
            COMMIT;
            -------------------------------------------------------------------------------------
            END LOOP;

       EXCEPTION WHEN OTHERS THEN
       NOTE:='ERRORE RECUPERO DELIBERE GIORNALIERE RICEVUTE IL '|| TO_NUMBER(TO_CHAR(V_MAX_ID_DPER),'YYYYMMDD');
           PKG_MCREI_AUDIT.LOG_CARICAMENTI(V_FLUSSO, C_NOME,PKG_MCREI_AUDIT.C_ERROR, SQLCODE, SQLERRM, NOTE);
       END;
         RETURN OK;
  EXCEPTION WHEN OTHERS THEN
    PKG_MCREI_AUDIT.LOG_CARICAMENTI(V_FLUSSO, C_NOME,PKG_MCREI_AUDIT.C_ERROR, SQLCODE, SQLERRM, NOTE);
    ROLLBACK;
    RETURN KO;
  END FNC_STORICIZZA_DELIB_DAILY;

END PKG_MCREI_ALIMENTA_STORICO_DEL;
/


CREATE SYNONYM MCRE_APP.PKG_MCREI_ALIMENTA_STORICO_DEL FOR MCRE_OWN.PKG_MCREI_ALIMENTA_STORICO_DEL;


CREATE SYNONYM MCRE_USR.PKG_MCREI_ALIMENTA_STORICO_DEL FOR MCRE_OWN.PKG_MCREI_ALIMENTA_STORICO_DEL;


GRANT EXECUTE, DEBUG ON MCRE_OWN.PKG_MCREI_ALIMENTA_STORICO_DEL TO MCRE_USR;

