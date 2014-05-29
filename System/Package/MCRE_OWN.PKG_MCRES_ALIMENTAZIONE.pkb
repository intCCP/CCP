CREATE OR REPLACE PACKAGE BODY MCRE_OWN.PKG_MCRES_ALIMENTAZIONE
AS
  /******************************************************************************
  NAME:       PKG_MCRES_ALIMENTAZIONE
  PURPOSE:
  REVISIONS:
  Ver        Date        Author             Description
  ---------  ----------      -----------------  ------------------------------------
  1.0      08/07/2011  V.Galli       Created this package.
  1.1      28/07/2011  L.Ferretti    Aggiunta funzione alimenta_FL
  1.2      09/09/2011  V.Galli       Controllo Mensili/Giornaliere in caricamento FEN
  1.3      31/10/2011  V.Galli      Id_dper in FEN
  1.4      07/11/2011  V.Galli      Gestione LOCK
  1.5      09/11/2011  A.Galliano   Gestione val_annomese
  2.0      10/02/2012  V.Galli      Aggiornamento stato acquisizione in  nuova tabella T_MCRES_WRK_last_ACQUISIZIONE
                                    Aggiunta gestione partizionamento in tabelle FEN
                                    Aggiunto Lock a ST e truncate subpart invece di delete
  2.1      16/02/2012   A.Galliano  Funzioni per caricamento istituti non target
  2.2      29/02/2012   A.Galliano  Alimentazione St e APP per non target
  2.3      12/03/2012   V.Galli      APP mensili con partizione periodo
  2.4      12/03/2012   V.Galli      Aggiornamento fine primo livello T_MCRES_WRK_last_ACQUISIZIONE
  2.5      18/05/2012   A.Galliano   Aggiornamento fine primo livello T_MCRES_WRK_ANAGRAFICA_BILANCI
  2.5      18/05/2012   A.Galliano   Rimossa gestione T_MCRES_WRK_ANAGRAFICA_BILANCI
  2.6      25/09/2012   A.Galliano  Creata fnc_mcres_alimenta_app_inc
  2.7      15/10/2012   A.Galliano  Gestione flussi multibanca
  2.7.1    18/10/2012   A.Galliano  Fix gestione flussi multibanca
  2.7.2    23/10/2012  A.Galliano  Modifica v_note in alimenta_app_multi
  2.8       12/12/2012  V.Galli Alimenta_fl se qry_convert nulla allora 2 bind_var in execute qry_fl
  2.9       19/12/2012 V.Galli  Spool_file
  3.0       23/01/2013 V.Galli substr della qry nel log FL
  3.1       03/07/2013 V.Galli alimenta_app/st_multi aggiunto flg_daily T
  3.2       18/07/2013 V.Galli alimenta_fl_nt truncate per nome tabella fl
  3.4       03/10/2013 V.Galli copia mcrd in bilancio e sopravve
  3.5       15/01/2014 A.Pilloni merge spese EPC in app sp spese, app documenti ed sp_fatture
  3.6       07/02/2014 A. Pilloni modifica per epc rilanciabile su fatture e documenti (aggiunte delete)
  3.7       24/02/2014 A.Pilloni modifica per epc impostazione aliquota dinamica
  3.8       12/03/2014 A.Pilloni modifica per epc per aggiunta voce spese non imponibili
  3.9       13/03/2014 V.Galli gestione partizioni in copy_mcrd
  3.10     19/03/2014     V.Galli        fun annullamneto del forfettarie
 3.11    27/05/2014 A.Pilloni aggiunte funzioni reload alert 40 fnc_reload_alert_rapp_da_volt, 41 fnc_reload_alert_delibere_ft,
             45 fnc_reload_alert_rapp_cmlt NB. (da richiamare come work around nel caso non funzionasse la chiamata in step elaborazione
             di ALIMENTA_FEN del package alimentazione)
  ******************************************************************************/
FUNCTION FNC_MCRES_ALIMENTA_FL(
    P_REC IN F_SLAVE_PAR_TYPE)
  RETURN NUMBER
IS
  C_NOME  CONSTANT VARCHAR2(100) := C_PACKAGE || '.FNC_MCRES_ALIMENTA_FL';
  v_esito NUMBER;
  V_COUNT NUMBER;
  note t_mcres_wrk_audit_caricamenti.NOTE%type:='GENERALE';
  V_COD_ABI T_MCRES_WRK_ACQUISIZIONE.COD_ABI%type;
  V_COD_FILE T_MCRES_WRK_ACQUISIZIONE.COD_FILE%TYPE;
  v_cod_flusso  t_mcres_wrk_alimentazione.cod_flusso%type;
--  V_VAL_QRY_FL T_MCRES_WRK_ALIMENTAZIONE.VAL_QRY_FL%type;
--  V_VAL_QRY_CONVERT T_MCRES_WRK_ALIMENTAZIONE.VAL_QRY_CONVERT%TYPE;
  V_VAL_QRY_FL varchar2(32000);
  V_VAL_QRY_CONVERT varchar2(32000);
  V_VAL_TAB_FL T_MCRES_WRK_ALIMENTAZIONE.VAL_TAB_FL%TYPE;
  V_VAL_TAB_CONVERT T_MCRES_WRK_ALIMENTAZIONE.VAL_TAB_CONVERT%TYPE;
  V_SUFFIX_PARTITION T_MCRES_WRK_CONFIGURAZIONE.VALORE_COSTANTE%type;
  V_SEQ NUMBER := P_REC.SEQ_FLUSSO;
BEGIN

  BEGIN
    SELECT
        COD_ABI,
        COD_FILE,
        cod_flusso
    INTO
        V_COD_ABI,
        V_COD_FILE,
        v_cod_flusso
    FROM T_MCRES_WRK_ACQUISIZIONE
    WHERE ID_FLUSSO = P_REC.SEQ_FLUSSO;
  EXCEPTION
  WHEN OTHERS THEN
    PKG_MCRES_AUDIT.LOG_CARICAMENTI(P_REC.SEQ_FLUSSO,C_NOME,PKG_MCRES_AUDIT.C_ERROR,SQLCODE,SQLERRM,'COD_ABI='||V_COD_ABI);
    raise;
  END;

  BEGIN
    SELECT substr(VAL_QRY_CONVERT,1,32000),
      substr(VAL_QRY_FL,1,32000),
      VAL_TAB_FL,
      VAL_TAB_CONVERT
    INTO V_VAL_QRY_CONVERT,
      V_VAL_QRY_FL,
      V_VAL_TAB_FL,
      V_VAL_TAB_CONVERT
    FROM T_MCRES_WRK_ALIMENTAZIONE
    where cod_flusso = v_cod_flusso;
  EXCEPTION
  WHEN OTHERS THEN
    PKG_MCRES_AUDIT.LOG_CARICAMENTI(P_REC.SEQ_FLUSSO,C_NOME,PKG_MCRES_AUDIT.C_ERROR,SQLCODE,SQLERRM,'Parametri alimentazione FL');
    raise;
  END;

  V_ESITO := PKG_MCRES_GESTIONE_PARTIZIONI.FNC_CREA_PARTIZIONE(V_VAL_TAB_FL,V_COD_ABI,P_REC.SEQ_FLUSSO);
  ---- Controllo creazione sotto_partizioni da template
  IF (V_ESITO = 1) THEN
    V_ESITO  := PKG_MCRES_GESTIONE_PARTIZIONI.FNC_TRUNCATE_PARTITION(V_VAL_TAB_FL,V_COD_ABI,P_REC.SEQ_FLUSSO);
  END IF;

  IF(V_ESITO=1) THEN
    PKG_MCRES_AUDIT.LOG_CARICAMENTI(p_rec.SEQ_FLUSSO,C_NOME,PKG_MCRES_AUDIT.C_DEBUG,SQLCODE,SQLERRM,substr(V_VAL_QRY_CONVERT,1,4000));
    IF(V_VAL_QRY_CONVERT IS NOT NULL) THEN
      EXECUTE immediate V_VAL_QRY_CONVERT USING V_SEQ,
      V_COD_ABI;
      COMMIT;
      note := 'eseguita QRY_CONVERT';
    END IF;
    V_SUFFIX_PARTITION := PKG_MCRES_GESTIONE_PARTIZIONI.FNC_GET_SUFFIX_PARTITION(P_REC.SEQ_FLUSSO);
    note               := 'eseguita GESTIONE_PARTIZIONI';
    V_VAL_QRY_FL       := REPLACE(V_VAL_QRY_FL,'V_PARTITION',V_SUFFIX_PARTITION||V_COD_ABI);
    PKG_MCRES_AUDIT.LOG_CARICAMENTI(p_rec.SEQ_FLUSSO,C_NOME,PKG_MCRES_AUDIT.C_DEBUG,SQLCODE,SQLERRM,substr(V_VAL_QRY_FL,1,4000));

    IF(V_VAL_QRY_CONVERT IS NULL)THEN ---v.2.8 VGalli
       EXECUTE immediate V_VAL_QRY_FL USING V_SEQ,V_COD_ABI;
    ELSE
        EXECUTE immediate V_VAL_QRY_FL USING V_COD_ABI;
    END IF;

    COMMIT;

    note     := 'eseguita QRY_FL';
    IF(V_ESITO=1)THEN
      EXECUTE IMMEDIATE 'SELECT COUNT(*) FROM ' ||V_VAL_TAB_CONVERT||' WHERE ID_FLUSSO = '||P_REC.SEQ_FLUSSO INTO V_COUNT;
      COMMIT;
      UPDATE T_MCRES_WRK_ACQUISIZIONE
      SET VAL_SCARTI_CONVERT = v_count
      WHERE ID_FLUSSO        = p_rec.SEQ_FLUSSO;
      COMMIT;
    END IF;

  END IF;

  RETURN OK*V_ESITO;

EXCEPTION
  WHEN OTHERS THEN
    PKG_MCRES_AUDIT.LOG_CARICAMENTI(p_rec.SEQ_FLUSSO,C_NOME,PKG_MCRES_AUDIT.C_ERROR,SQLCODE,SQLERRM,note);
    RETURN KO;
END FNC_MCRES_ALIMENTA_FL;

FUNCTION FNC_MCRES_ALIMENTA_FEN(
    P_REC IN F_SLAVE_PAR_TYPE)
  RETURN NUMBER
IS

  C_NOME CONSTANT VARCHAR2(100) := C_PACKAGE || '.FNC_MCRES_ALIMENTA_FEN';
  V_SUFFIX_PARTITION T_MCRES_WRK_CONFIGURAZIONE.VALORE_COSTANTE%TYPE;
  V_ESITO NUMBER := 0;
  V_NOTE T_MCRES_WRK_AUDIT_CARICAMENTI.NOTE%TYPE;

  CURSOR C_LISTA( P_SEQ_FLUSSO T_MCRES_WRK_ACQUISIZIONE.ID_FLUSSO%TYPE)
  IS
    SELECT A.Cod_Abi,
      G.Val_Tbl_Name,
      G.Val_Ins_Query,
      G.Val_Del_Qry,
      G.FLG_DAILY,
      G.VAL_LISTA_FLUSSI,
      G.FLG_GRUPPO,
      G.FLG_TIPO_PARTIZIONE
    FROM T_MCRES_WRK_ACQUISIZIONE A,
      T_MCRES_WRK_ALIMENTAZIONE_FEN G
    WHERE A.ID_FLUSSO = P_SEQ_FLUSSO
    AND INSTR(G.VAL_LISTA_FLUSSI,','||A.COD_FLUSSO||',')  >0
    AND G.FLG_ATTIVA = 1
    ORDER BY VAL_TBL_NAME, FLG_DAILY DESC;

  --- val_annomese
  V_VAL_ANNOMESE NUMBER(6);
  v_id_dper number(8);
  --V_COD_ABI VARCHAR2(5);
  --V_ID_DPER VARCHAR2(8);

  --- LOCK
  v_LOCK_result NUMBER;
  V_LOCKHANDLE  VARCHAR2(200);

BEGIN
  FOR REC_LISTA IN C_LISTA(P_REC.SEQ_FLUSSO)
  LOOP
    --- LOCK_INIZIO
    DBMS_LOCK.ALLOCATE_UNIQUE(REC_LISTA.VAL_TBL_NAME||'_'||REC_LISTA.COD_ABI||'_'||TO_CHAR(P_REC.PERIODO,'YYYYMM'), V_LOCKHANDLE);
    V_LOCK_RESULT := DBMS_LOCK.REQUEST(V_LOCKHANDLE, DBMS_LOCK.X_MODE);
    PKG_MCRES_AUDIT.LOG_CARICAMENTI(P_REC.SEQ_FLUSSO,C_NOME,PKG_MCRES_AUDIT.c_debug,SQLCODE,SQLERRM,'LOCK_RESULT LOCKED - '||
    CASE
      WHEN v_LOCK_result=1 THEN 'Timeout'
      WHEN v_LOCK_result=2 THEN 'Deadlock'
      WHEN v_LOCK_result=3 THEN 'Parameter Error'
      WHEN V_LOCK_RESULT=4 THEN 'Already owned'
      WHEN v_LOCK_result=5 THEN 'Illegal Lock Handle'
    END);
    --- LOCK_FINE

    -- Controllo partizioni
    IF(REC_LISTA.FLG_TIPO_PARTIZIONE = 'T') THEN
        V_NOTE   := 'Creazione partizione Tutte - Periodo';
        V_ESITO  := PKG_MCRES_GESTIONE_PARTIZIONI.FNC_CREA_PARTIZIONE(REC_LISTA.VAL_TBL_NAME,TO_CHAR(P_REC.PERIODO,'YYYYMM'),P_REC.SEQ_FLUSSO);
        IF(V_ESITO = 1) THEN
          V_Note  := 'Creazione sottopartizione Tutte - ABI';
          V_ESITO := PKG_MCRES_GESTIONE_PARTIZIONI.FNC_CREA_SOTTOPARTIZIONE(REC_LISTA.Val_Tbl_Name,REC_LISTA.cod_abi,P_REC.SEQ_FLUSSO);
        END IF;
    ELSIF(REC_LISTA.FLG_TIPO_PARTIZIONE = 'P') THEN
      V_NOTE   := 'Creazione partizione Periodo';
      V_ESITO  := PKG_MCRES_GESTIONE_PARTIZIONI.FNC_CREA_PARTIZIONE(REC_LISTA.VAL_TBL_NAME,TO_CHAR(P_REC.PERIODO,'YYYYMM'),P_REC.SEQ_FLUSSO);
    ELSIF(REC_LISTA.FLG_TIPO_PARTIZIONE = 'A') THEN
      V_NOTE   := 'Creazione partizione Abi';
      V_ESITO  := PKG_MCRES_GESTIONE_PARTIZIONI.FNC_CREA_PARTIZIONE(REC_LISTA.VAL_TBL_NAME,REC_LISTA.cod_abi,P_REC.SEQ_FLUSSO);
    end if;

    IF (V_ESITO=0 AND REC_LISTA.flg_tipo_partizione is not null) THEN
      PKG_MCRES_AUDIT.LOG_CARICAMENTI(P_REC.SEQ_FLUSSO,C_NOME,PKG_MCRES_AUDIT.C_ERROR,SQLCODE,SQLERRM,'Gestione partizioni - '||V_NOTE);
      exit;
    end if;

    IF(REC_LISTA.FLG_DAILY='M')THEN
      V_NOTE := 'Controllo ultimo id_dper per '||REC_LISTA.VAL_TBL_NAME||' Mensile - Gruppo='||nvl(REC_LISTA.flg_gruppo,'-');
      BEGIN
        IF(INSTR(UPPER(REC_LISTA.VAL_INS_QUERY),UPPER(':v_cod_abi'))= 0) then
          EXECUTE IMMEDIATE '
            select count( distinct 1) from
                (SELECT MAX(VAL_ANNOMESE)VAL_ANNOMESE
                  FROM ' ||REC_LISTA.VAL_TBL_NAME|| ' )A,
                (SELECT substr(ID_DPER,1,6)VAL_ANNOMESE FROM V_MCRES_ULTIMA_ACQ_MAXDT WHERE FLG_DAILY = ''M'')B
            where a.val_annomese = b.VAL_ANNOMESE ' INTO V_ESITO ;
        elsIF(REC_LISTA.FLG_GRUPPO IS NULL) THEN
          EXECUTE IMMEDIATE '
            select count( distinct 1) from
                (SELECT MAX(VAL_ANNOMESE)VAL_ANNOMESE
                  FROM ' ||REC_LISTA.VAL_TBL_NAME|| '
                  where cod_abi = '''||REC_LISTA.COD_ABI|| ''' )A,
                (SELECT substr(ID_DPER,1,6)VAL_ANNOMESE FROM V_MCRES_ULTIMA_ACQ_MAXDT WHERE FLG_DAILY = ''M'')B
            where a.val_annomese = b.VAL_ANNOMESE ' INTO V_ESITO ;
        else
          EXECUTE IMMEDIATE '
            select count( distinct 1) from
                (SELECT MAX(VAL_ANNOMESE)VAL_ANNOMESE
                  FROM ' ||REC_LISTA.VAL_TBL_NAME|| '
                  where cod_abi = '''||REC_LISTA.COD_ABI|| '''
                  and '||REC_LISTA.flg_gruppo||' )A,
                (SELECT substr(ID_DPER,1,6)VAL_ANNOMESE FROM V_MCRES_ULTIMA_ACQ_MAXDT WHERE FLG_DAILY = ''M'')B
            where a.val_annomese = b.VAL_ANNOMESE ' INTO V_ESITO ;
        end if;
      EXCEPTION
        WHEN NO_DATA_FOUND THEN
          V_ESITO:=0;
      END;
    END IF;

    IF(V_ESITO=0)THEN
      BEGIN
        BEGIN
          V_NOTE := 'Controllo caricamento flussi coinvolti - '||REC_LISTA.VAL_TBL_NAME||' - Gruppo='||nvl(REC_LISTA.flg_gruppo,'-');
          SELECT COUNT(DISTINCT 1)
          INTO V_ESITO
          FROM
            (SELECT E.COD_FLUSSO,
              E.ID_DPER,
              DECODE(FLG_DAILY,'S','D',FLG_DAILY) FLG_DAILY
            FROM V_MCRES_ULTIMA_ACQ_FILE E ,
              T_MCRES_WRK_ALIMENTAZIONE F
            WHERE INSTR(REC_LISTA.val_lista_flussi,','
              ||E.COD_FLUSSO
              ||',')         >0
            AND E.COD_FLUSSO = F.COD_FLUSSO
            AND E.COD_ABI    = REC_LISTA.COD_ABI
            ) a,
            V_MCRES_ULTIMA_ACQ_maxdt B
          WHERE a.ID_DPER =B.ID_DPER
          AND A.FLG_DAILY = B.FLG_DAILY
          HAVING COUNT(*) =LENGTH(REC_LISTA.VAL_LISTA_FLUSSI)-LENGTH(REPLACE(REC_LISTA.VAL_LISTA_FLUSSI,','))-1;
        EXCEPTION
        WHEN NO_DATA_FOUND THEN
          V_ESITO:=0;
        END;
        IF(V_ESITO=1) THEN
          SELECT
            CASE
              WHEN INSTR(REC_LISTA.VAL_LISTA_FLUSSI,',EFFETTI_ECONOMICI,')>0
              THEN
                (SELECT id_dper
                FROM V_MCRES_ULTIMA_ACQ_FILE
                WHERE COD_ABI  = REC_LISTA.COD_ABI
                AND COD_FLUSSO = 'EFFETTI_ECONOMICI'
                )
              WHEN INSTR(REC_LISTA.VAL_LISTA_FLUSSI,',SISBA_CP,')>0
              THEN
                (SELECT id_dper
                FROM V_MCRES_ULTIMA_ACQ_FILE
                WHERE COD_ABI  = REC_LISTA.COD_ABI
                AND COD_FLUSSO = 'SISBA_CP'
                )
              WHEN INSTR(REC_LISTA.VAL_LISTA_FLUSSI,',MOVIMENTI_MOD_MOV,')>0
              THEN
                (SELECT id_dper
                FROM V_MCRES_ULTIMA_ACQ_FILE
                WHERE COD_ABI  = REC_LISTA.COD_ABI
                AND COD_FLUSSO = 'MOVIMENTI_MOD_MOV'
                )
              WHEN INSTR(REC_LISTA.VAL_LISTA_FLUSSI,',MCRDEFFEECO,')>0
              THEN
                (SELECT id_dper
                FROM V_MCRES_ULTIMA_ACQ_FILE
                WHERE COD_ABI  = REC_LISTA.COD_ABI
                AND COD_FLUSSO = 'MCRDEFFEECO'
                )
              WHEN INSTR(REC_LISTA.VAL_LISTA_FLUSSI,',MCRDSISBACP,')>0
              THEN
                (SELECT id_dper
                FROM V_MCRES_ULTIMA_ACQ_FILE
                WHERE COD_ABI  = REC_LISTA.COD_ABI
                AND COD_FLUSSO = 'MCRDSISBACP'
                )
              WHEN INSTR(REC_LISTA.VAL_LISTA_FLUSSI,',MCRDMODMOV,')>0
              THEN
                (SELECT id_dper
                FROM V_MCRES_ULTIMA_ACQ_FILE
                WHERE COD_ABI  = REC_LISTA.COD_ABI
                AND COD_FLUSSO = 'MCRDMODMOV'
                )
              ELSE
                (SELECT id_dper
                FROM V_MCRES_ULTIMA_ACQ_FILE
                WHERE COD_ABI  = REC_LISTA.COD_ABI
                AND COD_FLUSSO = 'SISBA_CP'
                )
            END
          INTO v_id_dper
          FROM DUAL;

          V_VAL_ANNOMESE := substr(v_id_dper,1,6);

          IF(REC_LISTA.VAL_DEL_QRY IS NOT NULL)THEN
            V_NOTE                 := 'Delete dati vecchi in '||REC_LISTA.VAL_TBL_NAME||' - Gruppo='||nvl(REC_LISTA.flg_gruppo,'-');
            if(instr(upper(REC_LISTA.VAL_DEL_QRY),upper('v_cod_abi'))>0 and instr(upper(REC_LISTA.VAL_DEL_QRY),upper('v_val_annomese'))>0) then
              EXECUTE immediate REC_LISTA.VAL_DEL_QRY USING REC_LISTA.COD_ABI, V_VAL_ANNOMESE ;
            elsif(instr(upper(REC_LISTA.VAL_DEL_QRY),upper('v_cod_abi'))=0 and instr(upper(REC_LISTA.VAL_DEL_QRY),upper('v_val_annomese'))>0) then
              EXECUTE immediate REC_LISTA.VAL_DEL_QRY USING V_VAL_ANNOMESE ;
            else
              EXECUTE immediate REC_LISTA.VAL_DEL_QRY USING REC_LISTA.COD_ABI ;
            end if;
            COMMIT;
          END IF;

          V_NOTE := 'Insert dati raggruppati in '||REC_LISTA.VAL_TBL_NAME||' - Gruppo='||nvl(REC_LISTA.flg_gruppo,'-');
          BEGIN
            IF(INSTR(UPPER(REC_LISTA.VAL_INS_QUERY),UPPER(':v_cod_abi'))>0 and INSTR(UPPER(REC_LISTA.VAL_INS_QUERY),UPPER(':VAL_ANNOMESE'))>0)THEN
              PKG_MCRES_AUDIT.LOG_CARICAMENTI(P_REC.SEQ_FLUSSO,C_NOME,PKG_MCRES_AUDIT.c_debug,SQLCODE,SQLERRM,'Tabella da popolare:' || REC_LISTA.VAL_TBL_NAME || ' val_annomese = ' || TO_CHAR(P_REC.PERIODO,'YYYYMM') );
              EXECUTE IMMEDIATE REC_LISTA.VAL_INS_QUERY USING REC_LISTA.COD_ABI,V_VAL_ANNOMESE;
            ELSIF(INSTR(UPPER(REC_LISTA.VAL_INS_QUERY),UPPER(':v_cod_abi'))>0 and INSTR(UPPER(REC_LISTA.VAL_INS_QUERY),UPPER(':V_ID_DPER'))>0)THEN
              PKG_MCRES_AUDIT.LOG_CARICAMENTI(P_REC.SEQ_FLUSSO,C_NOME,PKG_MCRES_AUDIT.c_debug,SQLCODE,SQLERRM,'Tabella da popolare:' || REC_LISTA.VAL_TBL_NAME || ' val_annomese = ' || TO_CHAR(P_REC.PERIODO,'YYYYMM') );
              EXECUTE IMMEDIATE REC_LISTA.VAL_INS_QUERY USING REC_LISTA.COD_ABI,v_id_dper;
            ELSIF(INSTR(UPPER(REC_LISTA.VAL_INS_QUERY),UPPER(':v_cod_abi'))=0 and INSTR(UPPER(REC_LISTA.VAL_INS_QUERY),UPPER(':V_ID_DPER'))>0)THEN
              PKG_MCRES_AUDIT.LOG_CARICAMENTI(P_REC.SEQ_FLUSSO,C_NOME,PKG_MCRES_AUDIT.c_debug,SQLCODE,SQLERRM,'Tabella da popolare:' || REC_LISTA.VAL_TBL_NAME || ' val_annomese = ' || TO_CHAR(P_REC.PERIODO,'YYYYMM') );
              EXECUTE IMMEDIATE REC_LISTA.VAL_INS_QUERY USING v_id_dper;
            ELSE
              PKG_MCRES_AUDIT.LOG_CARICAMENTI(P_REC.SEQ_FLUSSO,C_NOME,PKG_MCRES_AUDIT.c_debug,SQLCODE,SQLERRM,'Tabella da popolare:' || REC_LISTA.VAL_TBL_NAME );
              EXECUTE IMMEDIATE REC_LISTA.VAL_INS_QUERY USING REC_LISTA.COD_ABI ;
            END IF;
          EXCEPTION
            WHEN PK_VIOLATA THEN
              NULL;
          END;

          COMMIT;

        END IF;

      EXCEPTION
        WHEN OTHERS THEN
          PKG_MCRES_AUDIT.LOG_CARICAMENTI(P_REC.SEQ_FLUSSO,C_NOME,PKG_MCRES_AUDIT.C_ERROR,SQLCODE,SQLERRM,REC_LISTA.VAL_TBL_NAME||' - EXECUTE QUERY - '||V_NOTE);
          RETURN KO;
      END;

    END IF;

    V_ESITO:= 0;

    --- LOCK_INIZIO
    V_LOCK_RESULT := DBMS_LOCK.RELEASE(V_LOCKHANDLE);
    PKG_MCRES_AUDIT.LOG_CARICAMENTI(P_REC.SEQ_FLUSSO,C_NOME,PKG_MCRES_AUDIT.c_debug,SQLCODE,SQLERRM,'LOCK_RESULT RELEASED - '||REC_LISTA.VAL_TBL_NAME||'_'||REC_LISTA.COD_ABI||'_'||TO_CHAR(P_REC.PERIODO,'YYYYMM')||' - '||
    CASE
      WHEN v_LOCK_result=1 THEN 'Timeout'
      WHEN v_LOCK_result=2 THEN 'Deadlock'
      WHEN v_LOCK_result=3 THEN 'Parameter Error'
      WHEN v_LOCK_result=4 THEN   'Already owned'
      WHEN V_LOCK_RESULT=5 THEN 'Illegal Lock Handle'
    END);
    --- LOCK_FINE

  END LOOP;
  RETURN OK;
EXCEPTION
  WHEN OTHERS THEN
      PKG_MCRES_AUDIT.LOG_CARICAMENTI(P_REC.SEQ_FLUSSO,C_NOME,PKG_MCRES_AUDIT.C_ERROR,SQLCODE,SQLERRM,'GENERALE - '||V_NOTE);
      --- LOCK_INIZIO
      V_LOCK_RESULT := DBMS_LOCK.RELEASE(V_LOCKHANDLE);
      PKG_MCRES_AUDIT.LOG_CARICAMENTI(P_REC.SEQ_FLUSSO,C_NOME,PKG_MCRES_AUDIT.c_debug,SQLCODE,SQLERRM,'LOCK_RESULT RELEASED - '||
      CASE
        WHEN v_LOCK_result=1 THEN 'Timeout'
        WHEN v_LOCK_result=2 THEN 'Deadlock'
        WHEN v_LOCK_result=3 THEN 'Parameter Error'
        WHEN v_LOCK_result=4 THEN 'Already owned'
        WHEN V_LOCK_RESULT=5 THEN'Illegal Lock Handle'
      END);
      --- LOCK_FINE
      RETURN KO;
END FNC_MCRES_ALIMENTA_FEN;

FUNCTION FNC_MCRES_ALIMENTA_ST(
    P_REC IN F_SLAVE_PAR_TYPE)
  RETURN NUMBER
IS

  C_NOME  CONSTANT VARCHAR2(100) := C_PACKAGE || '.FNC_MCRES_ALIMENTA_ST';
  v_esito NUMBER;
  V_COUNT NUMBER;

  V_COD_ABI T_MCRES_WRK_ACQUISIZIONE.COD_ABI%type;
  V_COD_FILE T_MCRES_WRK_ACQUISIZIONE.COD_FILE%TYPE;
--  V_VAL_QRY_ST T_MCRES_WRK_ALIMENTAZIONE.VAL_QRY_ST%type;
--  V_VAL_QRY_VINCOLI T_MCRES_WRK_ALIMENTAZIONE.VAL_QRY_VINCOLI%TYPE;
  V_VAL_QRY_ST varchar2(32000);
  V_VAL_QRY_VINCOLI varchar2(32000);
  V_VAL_TAB_ST T_MCRES_WRK_ALIMENTAZIONE.VAL_TAB_ST%TYPE;
  V_VAL_TAB_VINCOLI T_MCRES_WRK_ALIMENTAZIONE.VAL_TAB_VINCOLI%TYPE;
  V_NOTE T_MCRES_WRK_AUDIT_CARICAMENTI.NOTE%TYPE:='GENERALE';

   --- LOCK
  V_LOCK_RESULT NUMBER;
  V_LOCKHANDLE  VARCHAR2(200);

BEGIN

  BEGIN
    V_NOTE := 'Recupero ABI - ID_FLUSSO='||P_REC.SEQ_FLUSSO;
    SELECT COD_ABI,
      COD_FILE
    INTO V_COD_ABI,
      V_COD_FILE
    FROM T_MCRES_WRK_ACQUISIZIONE
    WHERE ID_FLUSSO = P_REC.SEQ_FLUSSO;
  EXCEPTION
  WHEN OTHERS THEN
    PKG_MCRES_AUDIT.LOG_CARICAMENTI(P_REC.SEQ_FLUSSO,C_NOME,PKG_MCRES_AUDIT.C_ERROR,SQLCODE,SQLERRM,V_NOTE);
  END;

  BEGIN
    V_NOTE := 'Recupero Query - COD_FLUSSO='||V_COD_FILE;
    SELECT substr(VAL_QRY_VINCOLI,1,32000),
      substr(VAL_QRY_ST,1,32000),
      VAL_TAB_ST,
      VAL_TAB_VINCOLI
    INTO V_VAL_QRY_VINCOLI,
      V_VAL_QRY_ST,
      V_VAL_TAB_ST,
      V_VAL_TAB_VINCOLI
    FROM T_MCRES_WRK_ALIMENTAZIONE
    WHERE COD_FLUSSO = SUBSTR(V_COD_FILE,0,LENGTH(V_COD_FILE)-6);
  EXCEPTION
  WHEN OTHERS THEN
    PKG_MCRES_AUDIT.LOG_CARICAMENTI(P_REC.SEQ_FLUSSO,C_NOME,PKG_MCRES_AUDIT.C_ERROR,SQLCODE,SQLERRM,V_NOTE);
  END;

  BEGIN
    V_NOTE := 'Query vincoli';

    if v_val_qry_vincoli is not null
    then

        EXECUTE immediate V_VAL_QRY_VINCOLI USING P_REC.SEQ_FLUSSO, TO_CHAR(P_REC.PERIODO,'YYYYMMDD'), V_COD_ABI;

    end if;

    COMMIT;

  EXCEPTION
    WHEN OTHERS THEN
      PKG_MCRES_AUDIT.LOG_CARICAMENTI(P_REC.SEQ_FLUSSO,C_NOME,PKG_MCRES_AUDIT.C_ERROR,SQLCODE,SQLERRM,v_note);
  end;

  BEGIN
      V_NOTE:='Count dalla tabella vincoli';
      EXECUTE IMMEDIATE 'SELECT COUNT(*) FROM ' ||V_VAL_TAB_VINCOLI||' WHERE ID_FLUSSO = '||P_REC.SEQ_FLUSSO INTO V_COUNT;
      COMMIT;
      V_NOTE:='Aggiornamento tabella acquisizione';
      UPDATE T_MCRES_WRK_ACQUISIZIONE
      SET VAL_SCARTI_VINCOLI = v_count
      WHERE ID_FLUSSO        = p_rec.SEQ_FLUSSO;
      COMMIT;
  EXCEPTION
    WHEN OTHERS THEN
      PKG_MCRES_AUDIT.LOG_CARICAMENTI(P_REC.SEQ_FLUSSO,C_NOME,PKG_MCRES_AUDIT.C_ERROR,SQLCODE,SQLERRM,v_note);
  end;

  --- LOCK_INIZIO
  DBMS_LOCK.ALLOCATE_UNIQUE(V_VAL_TAB_ST, V_LOCKHANDLE);
  V_LOCK_RESULT := DBMS_LOCK.REQUEST(V_LOCKHANDLE, DBMS_LOCK.X_MODE);
  PKG_MCRES_AUDIT.LOG_CARICAMENTI(P_REC.SEQ_FLUSSO,C_NOME,PKG_MCRES_AUDIT.c_debug,SQLCODE,SQLERRM,'LOCK_RESULT LOCKED - '||
  CASE
    WHEN v_LOCK_result=1 THEN 'Timeout'
    WHEN v_LOCK_result=2 THEN 'Deadlock'
    WHEN v_LOCK_result=3 THEN 'Parameter Error'
    WHEN V_LOCK_RESULT=4 THEN 'Already owned'
    WHEN v_LOCK_result=5 THEN 'Illegal Lock Handle'
  END);
  --- LOCK_FINE

  V_ESITO    := PKG_MCRES_GESTIONE_PARTIZIONI.FNC_CREA_PARTIZIONE(V_VAL_TAB_ST,TO_CHAR(P_REC.PERIODO,'YYYYMMDD'),P_REC.SEQ_FLUSSO);
  v_note     := 'Esito crea partizione: '||V_ESITO;
  IF (V_ESITO = 1) THEN
    V_ESITO  := PKG_MCRES_GESTIONE_PARTIZIONI.FNC_CREA_SOTTOPARTIZIONE(V_VAL_TAB_ST,V_COD_ABI,P_REC.SEQ_FLUSSO);
    V_NOTE   := 'Esito crea subpartition: '||V_ESITO;
  END IF;

  IF (V_ESITO = 1) THEN
    --V_ESITO := PKG_MCRES_GESTIONE_PARTIZIONI.FNC_TRUNCATE_SUBPARTITION(V_VAL_TAB_ST,TO_CHAR(P_REC.PERIODO,'YYYYMMDD')||'_'||V_COD_ABI,P_REC.SEQ_FLUSSO);
    V_NOTE := ' DELETE periodo='||TO_CHAR(P_REC.PERIODO,'YYYYMMDD')||' - ABI='|| V_COD_ABI;
    EXECUTE immediate ' DELETE '||V_VAL_TAB_ST||' WHERE id_dper = '||TO_CHAR(P_REC.PERIODO,'YYYYMMDD')||' AND COD_ABI='''|| V_COD_ABI ||'''';
    COMMIT;
    V_NOTE := 'Eseguita truncate subpartition '||TO_CHAR(P_REC.PERIODO,'YYYYMMDD')||'_'||V_COD_ABI||' con esito: '||V_ESITO;
  END IF;

  IF(V_ESITO=1) THEN

    v_note := 'Query storico';

    EXECUTE immediate V_VAL_QRY_ST USING TO_CHAR(P_REC.PERIODO,'YYYYMMDD'), V_COD_ABI;

    COMMIT;

  END IF;

   --- LOCK_INIZIO
  V_LOCK_RESULT := DBMS_LOCK.RELEASE(V_LOCKHANDLE);
  PKG_MCRES_AUDIT.LOG_CARICAMENTI(P_REC.SEQ_FLUSSO,C_NOME,PKG_MCRES_AUDIT.c_debug,SQLCODE,SQLERRM,'LOCK_RESULT RELEASED - '||V_VAL_TAB_ST||'_'||V_COD_ABI||'_'||TO_CHAR(P_REC.PERIODO,'YYYYMM')||' - '||
  CASE
    WHEN v_LOCK_result=1 THEN 'Timeout'
    WHEN v_LOCK_result=2 THEN 'Deadlock'
    WHEN v_LOCK_result=3 THEN 'Parameter Error'
    WHEN v_LOCK_result=4 THEN   'Already owned'
    WHEN V_LOCK_RESULT=5 THEN 'Illegal Lock Handle'
  END);
  --- LOCK_FINE

  RETURN OK*V_ESITO;

EXCEPTION
WHEN OTHERS THEN
  PKG_MCRES_AUDIT.LOG_CARICAMENTI(p_rec.SEQ_FLUSSO,C_NOME,PKG_MCRES_AUDIT.C_ERROR,SQLCODE,SQLERRM,'GENERALE '||v_note);
  RETURN KO;
END FNC_MCRES_ALIMENTA_ST;

FUNCTION FNC_MCRES_ALIMENTA_APP(
    P_REC IN F_SLAVE_PAR_TYPE)
  RETURN NUMBER
IS
  V_ESITO NUMBER := 0;
  V_SQL   VARCHAR2(5000);
  V_COD_ABI T_MCRES_WRK_ACQUISIZIONE.COD_ABI%TYPE;
  V_COD_FILE T_MCRES_WRK_ACQUISIZIONE.COD_FILE%type;
  v_COD_Flusso T_MCRES_WRK_ACQUISIZIONE.COD_Flusso%type;
--  V_VAL_QRY_APP_ATTIVA T_MCRES_WRK_ALIMENTAZIONE.VAL_QRY_APP_ATTIVA%type;
--  V_VAL_QRY_APP_STORICA T_MCRES_WRK_ALIMENTAZIONE.VAL_QRY_APP_STORICA%TYPE;
  V_VAL_QRY_APP_ATTIVA varchar2(32000);
  V_VAL_QRY_APP_STORICA varchar2(32000);
  V_VAL_TAB_APP T_MCRES_WRK_ALIMENTAZIONE.VAL_TAB_APP%type;
  V_FLG_DAILY T_MCRES_WRK_ALIMENTAZIONE.FLG_DAILY%type;
  V_SUFFIX_PARTITION T_MCRES_WRK_CONFIGURAZIONE.VALORE_COSTANTE%type;
  C_NOME   CONSTANT VARCHAR2(100) := C_PACKAGE||'.FNC_MCRES_ALIMENTA_APP';
  V_EXISTS number;
  V_NOTE T_MCRES_WRK_AUDIT_CARICAMENTI.NOTE%TYPE:='GENERALE';
  v_last_bil QZT_ST_MIS_PARAM.VAL_PARAMETER%type;
  v_count number:=0;

BEGIN

  BEGIN
    SELECT COD_ABI,
      COD_FILE,
      COD_FLUSSO
    INTO V_COD_ABI,
      V_COD_FILE,
      v_COD_Flusso
    FROM T_MCRES_WRK_ACQUISIZIONE
    WHERE ID_FLUSSO = P_REC.SEQ_FLUSSO;
  EXCEPTION
  WHEN OTHERS THEN
    PKG_MCRES_AUDIT.LOG_CARICAMENTI(P_REC.SEQ_FLUSSO,C_NOME,PKG_MCRES_AUDIT.C_ERROR,SQLCODE,SQLERRM,'COD_ABI='||V_COD_ABI);
  END;

  BEGIN
    SELECT substr(VAL_QRY_APP_ATTIVA,1,32000),
      substr(VAL_QRY_APP_STORICA,1,32000),
      VAL_TAB_APP,
      FLG_DAILY
    INTO V_VAL_QRY_APP_ATTIVA,
      V_VAL_QRY_APP_STORICA,
      V_VAL_TAB_APP,
      V_FLG_DAILY
    FROM T_MCRES_WRK_ALIMENTAZIONE
    WHERE Cod_Flusso = V_Cod_Flusso;
  EXCEPTION
    WHEN OTHERS THEN
      PKG_MCRES_AUDIT.LOG_CARICAMENTI(P_REC.SEQ_FLUSSO,C_NOME,PKG_MCRES_AUDIT.C_ERROR,SQLCODE,SQLERRM,'Parametri alimentazione APP');
  END;



  BEGIN
    SELECT DECODE(COUNT(*),0,0,1)
    INTO V_EXISTS
    FROM USER_TAB_SUBPARTITIONS
    WHERE Table_Name = Upper(V_Val_Tab_App);
  EXCEPTION
    WHEN OTHERS THEN
      PKG_MCRES_AUDIT.LOG_CARICAMENTI(P_REC.SEQ_FLUSSO,C_NOME,PKG_MCRES_AUDIT.C_ERROR,SQLCODE,SQLERRM,'Esistenza sottopartizioni');
  END;


  if (V_EXISTS  =1)then
     begin

        if (V_FLG_DAILY='M') then
         V_ESITO    := PKG_MCRES_GESTIONE_PARTIZIONI.FNC_CREA_PARTIZIONE(V_VAL_TAB_APP,TO_CHAR(P_REC.PERIODO,'YYYYMMDD'),P_REC.SEQ_FLUSSO);
         V_NOTE     := 'Esito crea partizione periodo (Mensili): '||V_ESITO;
        end if;

        V_ESITO    := PKG_MCRES_GESTIONE_PARTIZIONI.FNC_CREA_SOTTOPARTIZIONE(V_VAL_TAB_APP,V_COD_ABI,P_REC.SEQ_FLUSSO);
        V_NOTE   := 'Esito crea subpartition: '||V_ESITO;

      IF (V_ESITO = 1 AND V_FLG_DAILY='D') THEN
        --V_ESITO := PKG_MCRES_GESTIONE_PARTIZIONI.FNC_TRUNCATE_SUBPARTITION(V_VAL_TAB_APP,'ATTIVE_'||V_COD_ABI,P_REC.SEQ_FLUSSO);
        V_NOTE := ' DELETE ABI='|| V_COD_ABI;
        EXECUTE IMMEDIATE ' DELETE '||V_VAL_TAB_APP||' WHERE FLG_ATTIVA = 1 AND COD_ABI='''|| V_COD_ABI ||'''';
        commit;
      ELSIF (V_ESITO = 1 and V_FLG_DAILY='M') then
        --V_ESITO := PKG_MCRES_GESTIONE_PARTIZIONI.FNC_TRUNCATE_SUBPARTITION(V_VAL_TAB_ST,TO_CHAR(P_REC.PERIODO,'YYYYMMDD')||'_'||V_COD_ABI,P_REC.SEQ_FLUSSO);
        V_NOTE := ' DELETE periodo='||TO_CHAR(P_REC.PERIODO,'YYYYMMDD')||' - ABI='|| V_COD_ABI;
        EXECUTE immediate ' DELETE '||V_VAL_TAB_APP||' WHERE id_dper = '||TO_CHAR(P_REC.PERIODO,'YYYYMMDD')||' AND COD_ABI='''|| V_COD_ABI ||'''';
        COMMIT;
      end if;

    EXCEPTION
      WHEN OTHERS THEN
        PKG_MCRES_AUDIT.LOG_CARICAMENTI(P_REC.SEQ_FLUSSO,C_NOME,PKG_MCRES_AUDIT.C_ERROR,SQLCODE,SQLERRM,V_NOTE);
    end;

  ELSE
    V_NOTE := ' COUNT partizioni tabella='||V_VAL_TAB_APP||' - periodo='||TO_CHAR(P_REC.PERIODO,'YYYYMMDD')||' - ABI='|| V_COD_ABI;
    begin
        SELECT count(*)
        into v_count
        from USER_TAB_PARTITIONS
        WHERE TABLE_NAME = upper(V_VAL_TAB_APP);
    EXCEPTION
      WHEN OTHERS THEN
        PKG_MCRES_AUDIT.LOG_CARICAMENTI(P_REC.SEQ_FLUSSO,C_NOME,PKG_MCRES_AUDIT.C_ERROR,SQLCODE,SQLERRM,V_NOTE);
    end;

    if (v_count>0)then
        V_ESITO    := PKG_MCRES_GESTIONE_PARTIZIONI.FNC_CREA_PARTIZIONE(V_VAL_TAB_APP,V_COD_ABI,P_REC.SEQ_FLUSSO);
    ELSE
      V_ESITO := 1;
    end if;
    IF (V_ESITO = 1 AND V_FLG_DAILY='D') THEN
      --V_ESITO := PKG_MCRES_GESTIONE_PARTIZIONI.FNC_TRUNCATE_PARTITION(V_VAL_TAB_APP,V_COD_ABI,P_REC.SEQ_FLUSSO);
      EXECUTE IMMEDIATE ' DELETE '||V_VAL_TAB_APP||' WHERE COD_ABI='''|| V_COD_ABI ||'''';
      COMMIT;
    END IF;
    IF (V_ESITO = 1 AND V_FLG_DAILY='M') THEN
      BEGIN
        EXECUTE IMMEDIATE ' DELETE FROM '||V_VAL_TAB_APP||' WHERE COD_ABI='''||V_COD_ABI||''' AND ID_DPER='||TO_CHAR(P_REC.PERIODO,'YYYYMMDD');
        COMMIT;
      EXCEPTION
      WHEN OTHERS THEN
        PKG_MCRES_AUDIT.LOG_CARICAMENTI(P_REC.SEQ_FLUSSO,C_PACKAGE||'.FNC_MCRES_ALIMENTA_APP',PKG_MCRES_AUDIT.C_ERROR,SQLCODE,SQLERRM,'DELETE ABI='||V_COD_ABI||' ID_DPER='||TO_CHAR(P_REC.PERIODO,'YYYYMMDD'));
        RETURN KO;
      END;
    END IF;
  END IF;





  IF(V_ESITO=1) THEN
    EXECUTE immediate V_VAL_QRY_APP_ATTIVA USING TO_CHAR(P_REC.PERIODO,'YYYYMMDD'), V_COD_ABI ;
    COMMIT;
    IF (V_VAL_QRY_APP_STORICA IS NOT NULL) THEN
      --      V_SUFFIX_PARTITION := PKG_MCRES_GESTIONE_PARTIZIONI.FNC_GET_SUFFIX_PARTITION(P_REC.SEQ_FLUSSO);
      --      V_VAL_QRY_APP_STORICA := replace(V_VAL_QRY_APP_STORICA,'V_PARTITION',V_SUFFIX_PARTITION||TO_CHAR(P_REC.PERIODO,'YYYYMMDD')||'_'||V_COD_ABI);
      EXECUTE immediate V_VAL_QRY_APP_STORICA USING TO_CHAR(P_REC.PERIODO,'YYYYMMDD'),  V_COD_ABI ;
      COMMIT;
    END IF;
  END IF;

  BEGIN
    update T_MCRES_WRK_ACQUISIZIONE
    set COD_STATO   = 'CARICATO_APP'
    WHERE id_FLUSSO = P_REC.SEQ_FLUSSO;
    COMMIT;
  EXCEPTION
  WHEN OTHERS THEN
    PKG_MCRES_AUDIT.LOG_CARICAMENTI(P_REC.SEQ_FLUSSO,C_PACKAGE||'.FNC_MCRES_ALIMENTA_APP',PKG_MCRES_AUDIT.C_ERROR,SQLCODE,SQLERRM,'UPDATE T_MCRES_WRK_ACQUISIZIONE');
    RETURN KO;
  END;

  --******************T_MCRES_WRK_last_acquisizione************************************************
  BEGIN
    UPDATE T_MCRES_WRK_LAST_ACQUISIZIONE
    set COD_STATO = 'CARICATO_APP',
       DTA_END_PRIMO_LIVELLO = sysdate
    WHERE id_FLUSSO = P_REC.SEQ_FLUSSO;
    COMMIT;
  EXCEPTION
    WHEN OTHERS THEN
      PKG_MCRES_AUDIT.LOG_CARICAMENTI(P_REC.SEQ_FLUSSO,C_PACKAGE||'.FNC_MCRES_ALIMENTA_APP',PKG_MCRES_AUDIT.C_ERROR,SQLCODE,SQLERRM,'Nuova Tabella T_MCRES_WRK_last_acquisizione');
  end;
  --****************************************************************************************

/*
  --******************T_MCRES_WRK_ANAGRAFICA_BILANCI************************************************
  begin

    -- ID_DPER di cui fare lo spool. Massimo nel caso in cui presenti più ID_DPER
    select max(val_parameter)
    into v_last_bil
    from qzt_st_mis_param
    where upper(des_parameter) = 'ID_DPER';

    --Se p_rec.periodo = v_last_bil utile in caso di ricarico
    if(to_char(p_rec.periodo, 'yyyymmdd') >= v_last_bil)
    then

        --Aggiornamento solo per i flussi di bilancio.
        --In questo ramo si entra anche durante il caricamento
        --dei flussi giornalieri ma non viene aggiornata alcuna riga
        --in quanto la where condition non è soddisfatta.
        update t_mcres_wrk_anagrafica_bilanci
        set flg_to_spool = 1
        where cod_flusso || '_' || cod_abi = p_rec.nome_file;

        commit;

    end if;

  exception
    when others then
      pkg_mcres_audit.log_caricamenti(p_rec.seq_flusso,c_package||'.FNC_MCRES_ALIMENTA_APP',pkg_mcres_audit.c_error,sqlcode,sqlerrm,'Update T_MCRES_WRK_ANAGRAFICA_BILANCI');
  end;
  --****************************************************************************************
 */

  RETURN OK*V_ESITO;
EXCEPTION
WHEN OTHERS THEN
  Pkg_Mcres_Audit.Log_Caricamenti(P_Rec.Seq_Flusso,C_Package||'.FNC_MCRES_ALIMENTA_APP',Pkg_Mcres_Audit.C_Error,SQLCODE,Sqlerrm,'GENERALE');
  RETURN KO;
END FNC_MCRES_ALIMENTA_APP;

FUNCTION FNC_MCRES_ALIMENTA_TAPPI(
    P_REC IN F_SLAVE_PAR_TYPE)
  RETURN NUMBER
IS
  C_NOME  CONSTANT VARCHAR2(100) := C_PACKAGE || '.FNC_MCRES_ALIMENTA_TAPPI';
  V_ESITO NUMBER;
  V_SQL   VARCHAR2(5000);
  V_COD_ABI T_MCRES_WRK_ACQUISIZIONE.COD_ABI%TYPE;
  V_COD_FILE T_MCRES_WRK_ACQUISIZIONE.COD_FILE%type;
  V_COD_FLUSSO T_MCRES_WRK_ACQUISIZIONE.COD_FLUSSO%TYPE;
--  V_VAL_QRY_tappi T_MCRES_WRK_ALIMENTAZIONE.VAL_QRY_tappi%type;
  V_VAL_QRY_tappi varchar2(32000);
  V_VAL_TAB_APP T_MCRES_WRK_ALIMENTAZIONE.VAL_TAB_APP%type;
  V_FLG_DAILY T_MCRES_WRK_ALIMENTAZIONE.FLG_DAILY%type;
  V_SUFFIX_PARTITION T_MCRES_WRK_CONFIGURAZIONE.VALORE_COSTANTE%type;
  V_EXISTS NUMBER;
BEGIN
  BEGIN
    SELECT COD_ABI,
      COD_FILE,
      COD_FLUSSO
    INTO V_COD_ABI,
      V_COD_FILE,
      v_COD_Flusso
    FROM T_MCRES_WRK_ACQUISIZIONE
    WHERE ID_FLUSSO = P_REC.SEQ_FLUSSO;
  EXCEPTION
  WHEN OTHERS THEN
    PKG_MCRES_AUDIT.LOG_CARICAMENTI(P_REC.SEQ_FLUSSO,C_NOME,PKG_MCRES_AUDIT.C_ERROR,SQLCODE,SQLERRM,'COD_ABI='||V_COD_ABI);
  END;
  BEGIN
    SELECT substr(VAL_QRY_TAPPI,1,32000),
      VAL_TAB_APP,
      FLG_DAILY
    INTO v_VAL_QRY_tappi,
      V_VAL_TAB_APP,
      V_FLG_DAILY
    FROM T_MCRES_WRK_ALIMENTAZIONE
    WHERE COD_FLUSSO = v_COD_Flusso;
  EXCEPTION
  WHEN OTHERS THEN
    PKG_MCRES_AUDIT.LOG_CARICAMENTI(P_REC.SEQ_FLUSSO,C_NOME,PKG_MCRES_AUDIT.C_ERROR,SQLCODE,SQLERRM,'Parametri alimentazione APP');
  END;
  V_ESITO  := PKG_MCRES_GESTIONE_PARTIZIONI.FNC_CREA_PARTIZIONE(V_VAL_TAB_APP,V_COD_ABI,P_REC.SEQ_FLUSSO);
  IF(V_ESITO=1) THEN
    EXECUTE immediate V_VAL_QRY_tappi USING V_COD_ABI,
    TO_CHAR(P_REC.PERIODO,'YYYYMMDD'),
    P_REC.SEQ_FLUSSO,
    C_NOME;
    COMMIT;
  END IF;
  RETURN OK*V_ESITO;
EXCEPTION
WHEN OTHERS THEN
  PKG_MCRES_AUDIT.LOG_CARICAMENTI(P_REC.SEQ_FLUSSO,C_NOME,PKG_MCRES_AUDIT.C_ERROR,SQLCODE,SQLERRM,'GENERALE');
  RETURN KO;
END FNC_MCRES_ALIMENTA_TAPPI;

FUNCTION FNC_MCRES_ALIMENTA_FEN_PERIODI(
    P_COD_ABI T_MCRES_APP_SISBA_CP.COD_ABI%TYPE DEFAULT NULL,
    P_ID_DPER T_MCRES_APP_SISBA_CP.ID_DPER%TYPE DEFAULT NULL )
  RETURN NUMBER
IS
  C_NOME CONSTANT VARCHAR2(100) := C_PACKAGE || '.FNC_MCRES_ALIMENTA_FEN_PERIODI';
  V_REC F_SLAVE_PAR_TYPE        :=NULL;
  V_ESITO NUMBER                :=ok;
  CURSOR C_LISTA_ABI_PERIODI
  IS
    SELECT MAX(ID_FLUSSO) ID_FLUSSO,
      COD_FLUSSO,
      COD_ABI,
      TRUNC(ID_DPER) ID_DPER
    FROM T_MCRES_WRK_ACQUISIZIONE
    WHERE COD_FLUSSO               IN ('SISBA_CP','EFFETTI_ECONOMICI','POSIZIONI')
    AND COD_STATO                   = 'CARICATO'
    AND COD_ABI                     = NVL(P_COD_ABI,COD_ABI)
    AND TO_CHAR(id_dper,'YYYYMMDD') = NVL(P_ID_DPER,TO_CHAR(id_dper,'YYYYMMDD'))
    GROUP BY COD_FLUSSO,
      COD_ABI,
      TRUNC(ID_DPER)
    ORDER BY COD_FLUSSO,
      COD_ABI,
      TRUNC(ID_DPER) ;
BEGIN
  FOR REC_LISTA_ABI_PERIODI IN C_LISTA_ABI_PERIODI
  LOOP
    V_REC   :=F_SLAVE_PAR_TYPE(REC_LISTA_ABI_PERIODI.ID_FLUSSO,NULL,REC_LISTA_ABI_PERIODI.ID_DPER,NULL,NULL,9);
    V_ESITO := V_ESITO * FNC_MCRES_ALIMENTA_FEN(V_REC);
  END LOOP;
  RETURN V_ESITO;
EXCEPTION
WHEN OTHERS THEN
  PKG_MCRES_AUDIT.LOG_CARICAMENTI(V_REC.SEQ_FLUSSO,C_NOME,PKG_MCRES_AUDIT.C_ERROR,SQLCODE,SQLERRM,'GENERALE');
  RETURN KO;
END FNC_MCRES_ALIMENTA_FEN_PERIODI;

FUNCTION FNC_MCRES_ALIMENTA_FEN_STORICO(
    P_REC IN F_SLAVE_PAR_TYPE)
  RETURN NUMBER
IS
  C_NOME CONSTANT VARCHAR2(100) := C_PACKAGE || '.FNC_MCRES_ALIMENTA_FEN';
  V_SUFFIX_PARTITION T_MCRES_WRK_CONFIGURAZIONE.VALORE_COSTANTE%TYPE;
  V_ESITO NUMBER := 0;
  v_note t_mcres_wrk_audit_caricamenti.NOTE%type;
  CURSOR C_LISTA( P_SEQ_FLUSSO T_MCRES_WRK_ACQUISIZIONE.ID_FLUSSO%TYPE)
  IS
    SELECT A.COD_ABI,
      G.VAL_TBL_NAME,
      G.VAL_INS_QUERY,
      G.VAL_DEL_QRY,
      G.FLG_DAILY,
      g.val_lista_flussi
    FROM T_MCRES_WRK_ACQUISIZIONE A,
      T_MCRES_WRK_ALIMENTAZIONE_FEN G
    WHERE A.ID_FLUSSO = P_SEQ_FLUSSO
    AND INSTR(G.VAL_LISTA_FLUSSI,','
      ||A.COD_FLUSSO
      ||',')         >0
    AND G.FLG_ATTIVA = 1
    ORDER BY VAL_TBL_NAME,
      FLG_DAILY DESC;
BEGIN
  FOR REC_LISTA IN C_LISTA(P_REC.SEQ_FLUSSO)
  LOOP
    IF(REC_LISTA.FLG_DAILY='M')THEN
      V_NOTE             := 'Controllo ultimo id_dper per '||REC_LISTA.VAL_TBL_NAME||' Mensile ';
      BEGIN
        EXECUTE IMMEDIATE '

select count( distinct 1) from

(SELECT MAX(VAL_ANNOMESE)VAL_ANNOMESE FROM ' ||REC_LISTA.VAL_TBL_NAME|| ' where cod_abi = '''||REC_LISTA.COD_ABI||''')A,

(SELECT substr(ID_DPER,1,6)VAL_ANNOMESE FROM V_MCRES_ULTIMA_ACQ_MAXDT WHERE FLG_DAILY = ''M'')B

where a.val_annomese = b.VAL_ANNOMESE

' INTO V_ESITO ;
      EXCEPTION
      WHEN NO_DATA_FOUND THEN
        V_ESITO:=0;
      END;
    END IF;
    IF(V_ESITO=0)THEN
      BEGIN
        --          BEGIN
        --            V_NOTE := 'Controllo caricamento flussi coinvolti - '||REC_LISTA.VAL_TBL_NAME;
        --            SELECT COUNT(DISTINCT 1)
        --            into V_ESITO
        --            FROM
        --            (select E.COD_FLUSSO, E.ID_DPER, DECODE(FLG_DAILY,'S','D',FLG_DAILY) FLG_DAILY
        --            from V_MCRES_ULTIMA_ACQ_FILE E ,
        --                 T_MCRES_WRK_ALIMENTAZIONE F
        --            where INSTR(REC_LISTA.val_lista_flussi,','||E.COD_FLUSSO||',')>0
        --            and E.COD_FLUSSO = F.COD_FLUSSO
        --            and E.COD_ABI = REC_LISTA.COD_ABI) a,
        --                      V_MCRES_ULTIMA_ACQ_maxdt B
        --            where a.ID_DPER=B.ID_DPER
        --            AND A.FLG_DAILY = B.FLG_DAILY
        --            HAVING COUNT(*)=LENGTH(REC_LISTA.VAL_LISTA_FLUSSI)-LENGTH(REPLACE(REC_LISTA.VAL_LISTA_FLUSSI,','))-1;
        --          EXCEPTION
        --            WHEN NO_DATA_FOUND THEN V_ESITO:=0;
        --          END;
        V_ESITO                    := 1;
        IF(V_ESITO                  =1) THEN
          IF(REC_LISTA.VAL_DEL_QRY IS NOT NULL)THEN
            V_NOTE                 := 'Delete dati vecchi in '||REC_LISTA.VAL_TBL_NAME;
            EXECUTE immediate REC_LISTA.VAL_DEL_QRY USING REC_LISTA.COD_ABI ;
            COMMIT;
          END IF;
          V_NOTE := 'Insert dati raggruppati in '||REC_LISTA.VAL_TBL_NAME;
          BEGIN
            IF(INSTR(UPPER(REC_LISTA.VAL_INS_QUERY),UPPER(':VAL_ANNOMESE'))>0)THEN
              EXECUTE IMMEDIATE REC_LISTA.VAL_INS_QUERY USING REC_LISTA.COD_ABI,
              TO_CHAR(P_REC.PERIODO,'YYYYMM') ;
            ELSE
              EXECUTE IMMEDIATE REC_LISTA.VAL_INS_QUERY USING REC_LISTA.COD_ABI ;
            END IF;
          EXCEPTION
          WHEN PK_VIOLATA THEN
            NULL;
          END;
          COMMIT;
        END IF;
      EXCEPTION
      WHEN OTHERS THEN
        PKG_MCRES_AUDIT.LOG_CARICAMENTI(P_REC.SEQ_FLUSSO,C_NOME,PKG_MCRES_AUDIT.C_ERROR,SQLCODE,SQLERRM,'EXECUTE QUERY - '||V_NOTE);
        RETURN KO;
      END;
    END IF;
    v_esito:= 0;
  END LOOP;
  RETURN OK;
EXCEPTION
WHEN OTHERS THEN
  PKG_MCRES_AUDIT.LOG_CARICAMENTI(p_rec.SEQ_FLUSSO,C_NOME,PKG_MCRES_AUDIT.C_ERROR,SQLCODE,SQLERRM,'GENERALE - '||V_NOTE);
  RETURN KO;
END FNC_MCRES_ALIMENTA_FEN_STORICO;



FUNCTION FNC_MCRES_ALIMENTA_FL_NT(
    P_REC IN F_SLAVE_PAR_TYPE)
  RETURN NUMBER
IS
  C_NOME  CONSTANT VARCHAR2(100) := C_PACKAGE || '.FNC_MCRES_ALIMENTA_FL_NT';
  V_COUNT NUMBER;
  note t_mcres_wrk_audit_caricamenti.NOTE%type:='GENERALE';
  V_COD_ABI T_MCRES_WRK_ACQUISIZIONE.COD_ABI%type := 'NT';
  V_COD_FLUSSO T_MCRES_WRK_ACQUISIZIONE.COD_FLUSSO%TYPE;
--  V_VAL_QRY_FL T_MCRES_WRK_ALIMENTAZIONE.VAL_QRY_FL%type;
--  V_VAL_QRY_CONVERT T_MCRES_WRK_ALIMENTAZIONE.VAL_QRY_CONVERT%TYPE;
  V_VAL_QRY_FL varchar2(32000);
  V_VAL_QRY_CONVERT varchar2(32000);
  V_VAL_TAB_FL T_MCRES_WRK_ALIMENTAZIONE.VAL_TAB_FL%TYPE;
  V_VAL_TAB_CONVERT T_MCRES_WRK_ALIMENTAZIONE.VAL_TAB_CONVERT%TYPE;
  V_SEQ NUMBER := P_REC.SEQ_FLUSSO;
  v_sql varchar2(1000);


BEGIN


  BEGIN
    SELECT
      COD_FLUSSO
    INTO
      V_COD_FLUSSO
    FROM T_MCRES_WRK_ACQUISIZIONE
    WHERE ID_FLUSSO = P_REC.SEQ_FLUSSO;
  EXCEPTION
  WHEN OTHERS THEN
    PKG_MCRES_AUDIT.LOG_CARICAMENTI(P_REC.SEQ_FLUSSO,C_NOME,PKG_MCRES_AUDIT.C_ERROR,SQLCODE,SQLERRM,'COD_ABI='||V_COD_ABI);
  END;

  BEGIN
    SELECT substr(VAL_QRY_CONVERT,1,32000),
      substr(VAL_QRY_FL,1,32000),
      VAL_TAB_FL,
      VAL_TAB_CONVERT
    INTO V_VAL_QRY_CONVERT,
      V_VAL_QRY_FL,
      V_VAL_TAB_FL,
      V_VAL_TAB_CONVERT
    FROM T_MCRES_WRK_ALIMENTAZIONE
    WHERE COD_FLUSSO = V_COD_FLUSSO;
  EXCEPTION
  WHEN OTHERS THEN
    PKG_MCRES_AUDIT.LOG_CARICAMENTI(P_REC.SEQ_FLUSSO,C_NOME,PKG_MCRES_AUDIT.C_ERROR,SQLCODE,SQLERRM,'Parametri alimentazione FL');
  END;


    PKG_MCRES_AUDIT.LOG_CARICAMENTI(p_rec.SEQ_FLUSSO,C_NOME,PKG_MCRES_AUDIT.C_DEBUG,SQLCODE,SQLERRM,V_VAL_QRY_CONVERT);
    IF(V_VAL_QRY_CONVERT IS NOT NULL) THEN
      EXECUTE immediate V_VAL_QRY_CONVERT USING V_SEQ;
      --V_COD_ABI;
      COMMIT;
      note := 'eseguita QRY_CONVERT';
    END IF;

    v_sql := 'truncate table ' || V_VAL_TAB_FL;

    execute immediate v_sql;

    note := 'trocancata tabella FL';

    PKG_MCRES_AUDIT.LOG_CARICAMENTI(p_rec.SEQ_FLUSSO,C_NOME,PKG_MCRES_AUDIT.C_DEBUG,SQLCODE,SQLERRM,V_VAL_QRY_FL);
    EXECUTE immediate V_VAL_QRY_FL;
    COMMIT;

    note     := 'eseguita QRY_FL';

   EXECUTE IMMEDIATE 'SELECT COUNT(*) FROM ' ||V_VAL_TAB_CONVERT||' WHERE ID_FLUSSO = '||P_REC.SEQ_FLUSSO INTO V_COUNT;
   COMMIT;
   UPDATE T_MCRES_WRK_ACQUISIZIONE
   SET VAL_SCARTI_CONVERT = v_count
   WHERE ID_FLUSSO        = p_rec.SEQ_FLUSSO;
   COMMIT;

   return ok;

EXCEPTION
  WHEN OTHERS THEN
    PKG_MCRES_AUDIT.LOG_CARICAMENTI(p_rec.SEQ_FLUSSO,C_NOME,PKG_MCRES_AUDIT.C_ERROR,SQLCODE,SQLERRM,note);
    RETURN KO;
END FNC_MCRES_ALIMENTA_FL_NT;



FUNCTION FNC_MCRES_ALIMENTA_ST_NT(P_REC IN F_SLAVE_PAR_TYPE) RETURN NUMBER
IS

  C_NOME  CONSTANT VARCHAR2(100) := C_PACKAGE || '.FNC_MCRES_ALIMENTA_ST_NT';
  V_COUNT NUMBER;

  V_COD_flusso T_MCRES_WRK_ACQUISIZIONE.COD_flusso%TYPE;
--  V_VAL_QRY_ST T_MCRES_WRK_ALIMENTAZIONE.VAL_QRY_ST%type;
--  V_VAL_QRY_VINCOLI T_MCRES_WRK_ALIMENTAZIONE.VAL_QRY_VINCOLI%TYPE;
  V_VAL_QRY_ST varchar2(32000);
  V_VAL_QRY_VINCOLI varchar2(32000);
  V_VAL_TAB_ST T_MCRES_WRK_ALIMENTAZIONE.VAL_TAB_ST%TYPE;
  V_VAL_TAB_VINCOLI T_MCRES_WRK_ALIMENTAZIONE.VAL_TAB_VINCOLI%TYPE;
  V_NOTE T_MCRES_WRK_AUDIT_CARICAMENTI.NOTE%TYPE:='GENERALE';


BEGIN

  BEGIN
    V_NOTE := 'Recupero ID_FLUSSO='||P_REC.SEQ_FLUSSO;
    SELECT
      COD_FLUSSO
    INTO
      V_COD_FLUSSO
    FROM T_MCRES_WRK_ACQUISIZIONE
    WHERE ID_FLUSSO = P_REC.SEQ_FLUSSO;
  EXCEPTION
  WHEN OTHERS THEN
    PKG_MCRES_AUDIT.LOG_CARICAMENTI(P_REC.SEQ_FLUSSO,C_NOME,PKG_MCRES_AUDIT.C_ERROR,SQLCODE,SQLERRM,V_NOTE);
  END;

  BEGIN
    V_NOTE := 'Recupero Query - COD_FLUSSO='||V_COD_FLUSSO;
    SELECT substr(VAL_QRY_VINCOLI,1,32000),
      substr(VAL_QRY_ST,1,32000),
      VAL_TAB_ST,
      VAL_TAB_VINCOLI
    INTO V_VAL_QRY_VINCOLI,
      V_VAL_QRY_ST,
      V_VAL_TAB_ST,
      V_VAL_TAB_VINCOLI
    FROM T_MCRES_WRK_ALIMENTAZIONE
    WHERE COD_FLUSSO = V_COD_FLUSSO;
  EXCEPTION
  WHEN OTHERS THEN
    PKG_MCRES_AUDIT.LOG_CARICAMENTI(P_REC.SEQ_FLUSSO,C_NOME,PKG_MCRES_AUDIT.C_ERROR,SQLCODE,SQLERRM,V_NOTE);
  END;

  BEGIN
    V_NOTE := 'Query vincoli';
    EXECUTE immediate V_VAL_QRY_VINCOLI USING P_REC.SEQ_FLUSSO;
    COMMIT;
  EXCEPTION
    WHEN OTHERS THEN
      PKG_MCRES_AUDIT.LOG_CARICAMENTI(P_REC.SEQ_FLUSSO,C_NOME,PKG_MCRES_AUDIT.C_ERROR,SQLCODE,SQLERRM,v_note);
  end;

  BEGIN
      V_NOTE:='Count dalla tabella vincoli';
      EXECUTE IMMEDIATE 'SELECT COUNT(*) FROM ' ||V_VAL_TAB_VINCOLI||' WHERE ID_FLUSSO = '||P_REC.SEQ_FLUSSO INTO V_COUNT;
      COMMIT;
      V_NOTE:='Aggiornamento tabella acquisizione';
      UPDATE T_MCRES_WRK_ACQUISIZIONE
      SET VAL_SCARTI_VINCOLI = v_count
      WHERE ID_FLUSSO        = p_rec.SEQ_FLUSSO;
      COMMIT;
  EXCEPTION
    WHEN OTHERS THEN
      PKG_MCRES_AUDIT.LOG_CARICAMENTI(P_REC.SEQ_FLUSSO,C_NOME,PKG_MCRES_AUDIT.C_ERROR,SQLCODE,SQLERRM,v_note);
  end;



    v_note := 'Query storico';
    EXECUTE immediate V_VAL_QRY_ST USING P_REC.SEQ_FLUSSO;
    COMMIT;
    PKG_MCRES_AUDIT.LOG_CARICAMENTI(p_rec.SEQ_FLUSSO,C_NOME,PKG_MCRES_AUDIT.C_DEBUG,SQLCODE,SQLERRM,V_VAL_QRY_ST);

  RETURN OK;

EXCEPTION
WHEN OTHERS THEN
  PKG_MCRES_AUDIT.LOG_CARICAMENTI(p_rec.SEQ_FLUSSO,C_NOME,PKG_MCRES_AUDIT.C_ERROR,SQLCODE,SQLERRM,'GENERALE '||v_note);
  RETURN KO;
END FNC_MCRES_ALIMENTA_ST_NT;

FUNCTION FNC_MCRES_ALIMENTA_APP_NT(
    P_REC IN F_SLAVE_PAR_TYPE)
  RETURN NUMBER
IS
  V_ESITO NUMBER;
  V_SQL   VARCHAR2(5000);
  V_COD_FILE T_MCRES_WRK_ACQUISIZIONE.COD_FILE%type;
  v_COD_Flusso T_MCRES_WRK_ACQUISIZIONE.COD_Flusso%type;
--  V_VAL_QRY_APP_ATTIVA T_MCRES_WRK_ALIMENTAZIONE.VAL_QRY_APP_ATTIVA%type;
  V_VAL_QRY_APP_ATTIVA varchar2(32000);
  V_VAL_TAB_APP T_MCRES_WRK_ALIMENTAZIONE.VAL_TAB_APP%type;
  C_NOME   CONSTANT VARCHAR2(100) := C_PACKAGE||'.FNC_MCRES_ALIMENTA_APP_NT';
  V_Exists NUMBER;
BEGIN

  BEGIN
    SELECT
      COD_FILE,
      COD_FLUSSO
    INTO
      V_COD_FILE,
      v_COD_Flusso
    FROM T_MCRES_WRK_ACQUISIZIONE
    WHERE ID_FLUSSO = P_REC.SEQ_FLUSSO;
  EXCEPTION
  WHEN OTHERS THEN
    PKG_MCRES_AUDIT.LOG_CARICAMENTI(P_REC.SEQ_FLUSSO,C_NOME,PKG_MCRES_AUDIT.C_ERROR,SQLCODE,SQLERRM,v_cod_flusso);
  END;

  BEGIN
    SELECT substr(VAL_QRY_APP_ATTIVA,1,32000),
      VAL_TAB_APP
    INTO V_VAL_QRY_APP_ATTIVA,
      V_VAL_TAB_APP
    FROM T_MCRES_WRK_ALIMENTAZIONE
    WHERE Cod_Flusso = V_Cod_Flusso;
  EXCEPTION
  WHEN OTHERS THEN
    PKG_MCRES_AUDIT.LOG_CARICAMENTI(P_REC.SEQ_FLUSSO,C_NOME,PKG_MCRES_AUDIT.C_ERROR,SQLCODE,SQLERRM,'Parametri alimentazione APP');
  END;


    EXECUTE immediate V_VAL_QRY_APP_ATTIVA USING P_REC.SEQ_FLUSSO;
    PKG_MCRES_AUDIT.LOG_CARICAMENTI(P_REC.SEQ_FLUSSO,C_NOME,PKG_MCRES_AUDIT.C_DEBUG,SQLCODE,SQLERRM,V_VAL_QRY_APP_ATTIVA);

  BEGIN
    UPDATE T_MCRES_WRK_ACQUISIZIONE
    SET COD_STATO   = 'CARICATO'
    WHERE id_FLUSSO = P_REC.SEQ_FLUSSO;
    COMMIT;
  EXCEPTION
  WHEN OTHERS THEN
    PKG_MCRES_AUDIT.LOG_CARICAMENTI(P_REC.SEQ_FLUSSO,C_NOME,PKG_MCRES_AUDIT.C_ERROR,SQLCODE,SQLERRM,'UPDATE T_MCRES_WRK_ACQUISIZIONE');
    RETURN KO;
  END;

  --******************T_MCRES_WRK_last_acquisizione************************************************
  BEGIN
    UPDATE T_MCRES_WRK_LAST_ACQUISIZIONE
    set Cod_Stato = 'CARICATO'
    WHERE Cod_Flusso=V_Cod_Flusso;
    COMMIT;
  EXCEPTION
    WHEN OTHERS THEN
      PKG_MCRES_AUDIT.LOG_CARICAMENTI(P_REC.SEQ_FLUSSO,C_NOME,PKG_MCRES_AUDIT.C_ERROR,SQLCODE,SQLERRM,'Nuova Tabella T_MCRES_WRK_last_acquisizione');
  end;
  --****************************************************************************************

  RETURN OK;
EXCEPTION
WHEN OTHERS THEN
  Pkg_Mcres_Audit.Log_Caricamenti(P_Rec.Seq_Flusso,c_nome,Pkg_Mcres_Audit.C_Error,SQLCODE,Sqlerrm,'GENERALE');
  RETURN KO;
END FNC_MCRES_ALIMENTA_APP_NT;



function fnc_mcres_alimenta_app_inc
(
    p_rec   f_slave_par_type
)
return number
is


    c_nome              constant t_mcres_wrk_audit_caricamenti.procedura%type    := c_package || 'FNC_MCRES_ALIMENTA_APP_INC';
    v_note                       t_mcres_wrk_audit_caricamenti.note%type;

    type tp_lista_varchar
    is
        table of varchar2(200)
        index by pls_integer;




    v_id_dper           number(8);
    v_cod_abi           t_mcres_wrk_acquisizione.cod_abi%type;
    v_cod_flusso        t_mcres_wrk_acquisizione.cod_flusso%type;
    v_qry_app_inc_lob   t_mcres_wrk_alimentazione.val_qry_app_inc%type;
    v_tabs_app          t_mcres_wrk_alimentazione.val_tabs_app_inc%type;
    v_string            t_mcres_wrk_alimentazione.val_tabs_app_inc%type;
    v_qry_app_inc       varchar2(32767);
    n                   pls_integer;

    v_lista             tp_lista_varchar;
    v_lockhandle        tp_lista_varchar;
    v_result            varchar2(255);
    v_lock_result       number;

begin

    v_note      := 'Inizializzazione v_id_dper';

    v_id_dper   := to_number( to_char( p_rec.periodo, 'yyyymmdd') );


    v_note:= 'Recupero dati da T_MCRES_WRK_ACQUISIZIONE';

    begin

        select cod_abi, cod_flusso
        into v_cod_abi, v_cod_flusso
        from t_mcres_wrk_acquisizione
        where id_flusso = p_rec.seq_flusso;

    exception
    when others
    then

        pkg_mcres_audit.log_caricamenti(p_rec.seq_flusso, c_nome, pkg_mcres_audit.c_error, sqlcode, sqlerrm, v_note);

        return ko;

    end;


    v_note:= 'Recupero dati da T_MCRES_WRK_ALIMENTAZIONE';

    begin

        select val_tabs_app_inc, val_qry_app_inc
        into v_tabs_app, v_qry_app_inc_lob
        from t_mcres_wrk_alimentazione
        where cod_flusso = v_cod_flusso;

    exception
    when others
    then

        pkg_mcres_audit.log_caricamenti(p_rec.seq_flusso, c_nome, pkg_mcres_audit.c_error, sqlcode, sqlerrm, v_note);

        return ko;

    end;


    v_note  :=  'Conversione CLOB -> VARCHAR2';

    -- In questa versione non si prevede lunghezza maggiore
    if length( v_qry_app_inc_lob) <= 32767
    then

        v_qry_app_inc   := substr( v_qry_app_inc_lob,1, 32767);

    else

        pkg_mcres_audit.log_caricamenti(p_rec.seq_flusso, c_nome, pkg_mcres_audit.c_error,SQLCODE,SQLERRM,'Errore! lenght(QRY_APP_INC) > 32767');


    end if;

    v_note  := 'Inizializzazione lista tabelle APP per allocamento lock';

    n           :=    1;
    v_string    :=  upper( trim(v_tabs_app) ) || ',';

    while length( v_string ) > 0
    loop

        v_lista(n)  := substr( v_string, 1, instr(v_string, ',') -1);

        v_string    := substr( v_string,  instr(v_string, ',') + 1 );

        n   :=  n + 1;

    end loop;


    v_note  := 'Allocamento lock';

    for i in 1..v_lista.count
    loop

        dbms_lock.allocate_unique ( v_lista(i), v_lockhandle(i) );

    end loop;


    v_note := 'Richiesta accodamento lock';

    for i in 1..v_lista.count
    loop


        v_lock_result := dbms_lock.request (v_lockhandle(i), dbms_lock.x_mode);

        if v_lock_result <> 0
        then

            case v_lock_result
                when 1
                   then v_result := 'Timeout';
                when 2
                   then v_result := 'Deadlock';
                when 3
                   then v_result := 'Parameter Error';
                when 4
                   then v_result := 'Already owned';
                when 5
                   then v_result := 'Illegal Lock Handle';
            end case;

            pkg_mcres_audit.log_caricamenti(p_rec.seq_flusso, c_nome, pkg_mcres_audit.c_error,SQLCODE,SQLERRM,'Errore richiesta lock. Esito ' || v_result);

            return ko;

        end if;

    end loop;


    v_note  := 'Esecuzione qry_app_inc';

    execute immediate v_qry_app_inc using v_cod_abi, v_id_dper;

    commit;

    pkg_mcres_audit.log_caricamenti(p_rec.seq_flusso, c_nome, pkg_mcres_audit.c_debug,SQLCODE,SQLERRM,'Eseguita qry_app_inc');



    v_note := 'Richiesta rilascio lock';


    for i in 1..v_lockhandle.count
    loop

        v_lock_result := DBMS_LOCK.release (v_lockhandle(i));

        if v_lock_result <> 0
        then

            case v_lock_result
                when 3
                   then v_result := 'Parameter Error';
                when 4
                   then v_result := 'Do Not Own Lock Specified By Lockhandle';
                when 5
                   then v_result := 'Illegal Lockhandle';
                else v_result := null;
            end case;

            pkg_mcres_audit.log_caricamenti(p_rec.seq_flusso, c_nome, pkg_mcres_audit.c_error,SQLCODE,SQLERRM,'Errore richiesta rimozione lock. Esito ' || v_result);

            return ko;

        end if;

    end loop;

    v_note  := 'Aggiornamento T_MCRES_WRK_ACQUISIZIONE con stato CARICATO_APP';

    update t_mcres_wrk_acquisizione
    set cod_stato = 'CARICATO_APP'
    where id_flusso = p_rec.seq_flusso;

    commit;


    v_note  := 'Aggiornamento T_MCRES_WRK_LAST_ACQUISIZIONE con ultimo id_dper caricato';


    update t_mcres_wrk_last_acquisizione
    set
        cod_stato = 'CARICATO_APP',
        dta_end_primo_livello = sysdate
    where id_flusso = p_rec.seq_flusso;

    commit;

    return ok;


exception
when others
then

    rollback;

    if v_lockhandle.count > 0
    then    --rilascio eventuale lock

        for i in 1..v_lockhandle.count
        loop

            v_lock_result := dbms_lock.release (v_lockhandle(i));

            if v_lock_result <> 0
            then

                case v_lock_result
                    when 3
                       then v_result := 'Parameter Error';
                    when 4
                       then v_result := 'Do Not Own Lock Specified By Lockhandle';
                    when 5
                       then v_result := 'Illegal Lockhandle';
                    else v_result := null;
                end case;

            end if;

            pkg_mcres_audit.log_caricamenti(p_rec.seq_flusso, c_nome, pkg_mcres_audit.c_error,SQLCODE,SQLERRM,'Errore richiesta rimozione lock nel blocco delle eccezioni. Esito ' || v_result);

        end loop;

        pkg_mcres_audit.log_caricamenti(p_rec.seq_flusso, c_nome, pkg_mcres_audit.c_debug,SQLCODE,SQLERRM,'Rimosso lock nel blocco delle eccezioni');



    end if;

    pkg_mcres_audit.log_caricamenti( p_rec.seq_flusso, c_nome, pkg_mcres_audit.c_error, sqlcode, sqlerrm, 'GENERALE ' || v_note);

    return ko;

end;

function fnc_mcres_alimenta_fl_multi
(
    p_rec in f_slave_par_type
)
return number is

    c_nome              constant t_mcres_wrk_audit_caricamenti.procedura%type    := c_package || 'FNC_MCRES_ALIMENTA_FL_MULTI';
    v_note                       t_mcres_wrk_audit_caricamenti.note%type;

    v_cod_flusso        t_mcres_wrk_acquisizione.cod_flusso%type;
    v_tab_fl            t_mcres_wrk_alimentazione.val_tab_fl%type;
    v_tab_sc_convert    t_mcres_wrk_alimentazione.val_tab_convert%type;
    v_qry_fl            t_mcres_wrk_alimentazione.val_qry_fl%type;
    v_stmt              varchar2(32767);
    v_count             number;



begin

    v_note  := 'Recupero parametri da tabelle di configurazione';

    select cod_flusso
    into v_cod_flusso
    from t_mcres_wrk_acquisizione
    where id_flusso = p_rec.seq_flusso;

    select val_tab_fl, val_qry_fl, val_tab_convert
    into v_tab_fl, v_qry_fl, v_tab_sc_convert
    from t_mcres_wrk_alimentazione
    where cod_flusso = v_cod_flusso;

    v_note  := 'Truncate tablella FL';

    v_stmt  := 'truncate table ' || v_tab_fl;

    execute immediate v_stmt;

    v_note  :=  'controllo validità qry_fl';


    if length( v_qry_fl) <= 32767
    then

        v_stmt  :=  substr(v_qry_fl, 1, 32767);

    else


        pkg_mcres_audit.log_caricamenti( p_rec.seq_flusso, c_nome, pkg_mcres_audit.c_error, sqlcode, sqlerrm, 'QRY_FL too long');

        return ko;

    end if;


    v_note  := 'Esecuzione insert FL';

    execute immediate v_stmt using p_rec.seq_flusso;

    commit;



    v_note  := 'Aggiornamento T_MCRES_WRK_ACQUISIZIONE con numero scarti convert';

    v_stmt  := 'select count(*) from ' || v_tab_sc_convert || ' where id_flusso = ' || p_rec.seq_flusso;

    execute immediate v_stmt into v_count;

    update t_mcres_wrk_acquisizione
    set val_scarti_convert = v_count
    where id_flusso = p_rec.seq_flusso;

    commit;


    pkg_mcres_audit.log_caricamenti( p_rec.seq_flusso, c_nome, pkg_mcres_audit.c_debug, sqlcode, sqlerrm, 'Eseguita insert tabellla FL');


    return ok;

exception
when others
then

    pkg_mcres_audit.log_caricamenti( p_rec.seq_flusso, c_nome, pkg_mcres_audit.c_error, sqlcode, sqlerrm, 'GENERALE: ' || v_note);

    return ko;

end;

function fnc_mcres_alimenta_st_multi
(
    p_rec in f_slave_par_type
)
return number is

    c_nome              constant t_mcres_wrk_audit_caricamenti.procedura%type    := c_package || 'FNC_MCRES_ALIMENTA_ST_MULTI';
    v_note                       t_mcres_wrk_audit_caricamenti.note%type;

    v_cod_flusso        t_mcres_wrk_acquisizione.cod_flusso%type;
    v_id_dper           varchar2(8);
    v_tab_st            t_mcres_wrk_alimentazione.val_tab_st%type;
    v_tab_sc_vincoli    t_mcres_wrk_alimentazione.val_tab_vincoli%type;
    v_qry_st            t_mcres_wrk_alimentazione.val_qry_st%type;
    v_flg_daily           t_mcres_wrk_alimentazione.flg_daily%type;
    v_stmt              varchar2(32767);
    v_part_prefix       t_mcres_wrk_configurazione.valore_costante%type;
    v_partition_name    varchar2(30);
    v_esiste_partizione number;
    v_esito             number;
    v_count             number;



begin

    v_note  := 'Recupero parametri da tabelle di configurazione';

    select valore_costante
    into v_part_prefix
    from t_mcres_wrk_configurazione
    where nome_costante = 'PARTITION_SUFFIX';

    select cod_flusso, to_char(id_dper, 'yyyymmdd')
    into v_cod_flusso, v_id_dper
    from t_mcres_wrk_acquisizione
    where id_flusso = p_rec.seq_flusso;

    select val_tab_st, val_qry_st, val_tab_vincoli,flg_daily
    into v_tab_st, v_qry_st, v_tab_sc_vincoli, v_flg_daily
    from t_mcres_wrk_alimentazione
    where cod_flusso = v_cod_flusso;


    v_note  := 'Controllo esistenza partizione relativa al periodo da caricare';

    v_partition_name := v_part_prefix || v_id_dper;

    select count(*)
    into v_esiste_partizione
    from user_tab_partitions
    where table_name = v_tab_st
    and partition_name = v_partition_name;


    if v_esiste_partizione = 0
    then

        v_esito:= pkg_mcres_gestione_partizioni.fnc_add_partition( v_tab_st, p_rec.seq_flusso);

        if v_esito = ko
        then

            pkg_mcres_audit.log_caricamenti( p_rec.seq_flusso, c_nome, pkg_mcres_audit.c_error, sqlcode, sqlerrm, 'Errore nella creazione della partizione');

            return ko;

        end if;

    else

        v_stmt  := 'alter table ' || v_tab_st || ' truncate partition ' || v_partition_name ;

        execute immediate v_stmt;

    end if;


    v_note  :=  'controllo validità qry_st';

    if length( v_qry_st) <= 32767
    then

        v_stmt  :=  substr(v_qry_st, 1, 32767);

    else


        pkg_mcres_audit.log_caricamenti( p_rec.seq_flusso, c_nome, pkg_mcres_audit.c_error, sqlcode, sqlerrm, 'QRY_ST too long');

        return ko;

    end if;


    v_note  := 'Esecuzione insert ST';

     if(v_flg_daily='T')then
         execute immediate v_stmt;
     else
        execute immediate v_stmt using p_rec.seq_flusso;
     end if;

    commit;


    v_note  := 'Aggiornamento T_MCRES_WRK_ACQUISIZIONE con numero scarti vincoli';

    v_stmt := 'select count(*) from ' || v_tab_sc_vincoli || ' where id_flusso = ' || p_rec.seq_flusso;

    execute immediate v_stmt into v_count;

    update t_mcres_wrk_acquisizione
    set val_scarti_vincoli = v_count
    where id_flusso = p_rec.seq_flusso;

    commit;

    pkg_mcres_audit.log_caricamenti( p_rec.seq_flusso, c_nome, pkg_mcres_audit.c_debug, sqlcode, sqlerrm, 'Eseguita insert tabellla ST');


    return ok;

exception
when others
then

    pkg_mcres_audit.log_caricamenti( p_rec.seq_flusso, c_nome, pkg_mcres_audit.c_error, sqlcode, sqlerrm, 'GENERALE: ' || v_note);

    return ko;

end;


function fnc_mcres_alimenta_app_multi
(
    p_rec in f_slave_par_type
)
return number is

    c_nome              constant t_mcres_wrk_audit_caricamenti.procedura%type    := c_package || 'FNC_MCRES_ALIMENTA_APP_MULTI';
    v_note                       t_mcres_wrk_audit_caricamenti.note%type;

    v_cod_flusso        t_mcres_wrk_acquisizione.cod_flusso%type;
    v_id_dper           varchar2(8);
    v_tab_app           t_mcres_wrk_alimentazione.val_tab_app%type;
    v_qry_app           t_mcres_wrk_alimentazione.val_qry_app_attiva%type;
    v_flg_daily           t_mcres_wrk_alimentazione.flg_daily%type;
    v_stmt              varchar2(32767);



begin

    v_note  := 'Recupero parametri da tabelle di configurazione';

    select cod_flusso, to_char(id_dper, 'yyyymmdd')
    into v_cod_flusso, v_id_dper
    from t_mcres_wrk_acquisizione
    where id_flusso = p_rec.seq_flusso;

    select val_tab_app, val_qry_app_attiva, flg_daily
    into v_tab_app, v_qry_app, v_flg_daily
    from t_mcres_wrk_alimentazione
    where cod_flusso = v_cod_flusso;

    v_note  :=  'controllo validità qry_app';

    if length( v_qry_app) <= 32767
    then

        v_stmt  :=  substr(v_qry_app, 1, 32767);

    else


        pkg_mcres_audit.log_caricamenti( p_rec.seq_flusso, c_nome, pkg_mcres_audit.c_error, sqlcode, sqlerrm, 'QRY_APP either NULL or too long');

        return ko;

    end if;

    if(v_flg_daily='T')then
        v_note  := 'Esecuzione trunacte APP';
        execute immediate 'truncate table '||v_tab_app;
     end if;
     v_note  := 'Esecuzione insert/merge APP';
     execute immediate v_stmt using v_id_dper;

    commit;


    pkg_mcres_audit.log_caricamenti( p_rec.seq_flusso, c_nome, pkg_mcres_audit.c_debug, sqlcode, sqlerrm, 'Eseguita insert tabellla APP');


    return ok;

exception
when others
then

    pkg_mcres_audit.log_caricamenti( p_rec.seq_flusso, c_nome, pkg_mcres_audit.c_error, sqlcode, sqlerrm, 'GENERALE: ' || v_note);

    return ko;

end;

function fnc_mcres_spool_to_file (
    P_REC IN F_SLAVE_PAR_TYPE
)return number
is
     c_nome       constant varchar2(50) := c_package || '.fnc_mcres_spool_to_file';
     v_note                      t_mcres_wrk_audit_caricamenti.note%type;
     v_stmt          varchar2(32767);

    p_view_name  varchar2(30);
    v_dir        varchar2(30) default 'D_MCRES_WORK'   ;
    V_COD_ABI  T_MCRES_WRK_ACQUISIZIONE.cod_abi%type;
    v_cod_flusso T_MCRES_WRK_ACQUISIZIONE.cod_flusso%type;
    v_cod_file T_MCRES_WRK_ACQUISIZIONE.cod_file%type;
    v_tab_src T_MCRES_WRK_ELABORAZIONE.tab_src%type;
    v_prefix_file_qdc T_MCRES_WRK_configurazione.valore_costante%type;

begin

    BEGIN
        SELECT
            COD_ABI,
            cod_flusso,
            cod_file
        INTO
            V_COD_ABI,
            v_cod_flusso,
            v_cod_file
        FROM T_MCRES_WRK_ACQUISIZIONE
        WHERE ID_FLUSSO = P_REC.SEQ_FLUSSO;
    EXCEPTION
        WHEN OTHERS THEN
            PKG_MCRES_AUDIT.LOG_CARICAMENTI(P_REC.SEQ_FLUSSO,C_NOME,PKG_MCRES_AUDIT.C_ERROR,SQLCODE,SQLERRM,'COD_ABI='||V_COD_ABI);
            raise;
    END;

    BEGIN
        SELECT tab_src
        INTO v_tab_src
        FROM T_MCRES_WRK_elaborazione e
        WHERE cod_flusso = v_cod_flusso
        and E.ORDINE_ALIMENTAZIONE = P_REC.ORDINE_ALIMENTAZIONE ;
    EXCEPTION
        WHEN OTHERS THEN
            PKG_MCRES_AUDIT.LOG_CARICAMENTI(P_REC.SEQ_FLUSSO,C_NOME,PKG_MCRES_AUDIT.C_ERROR,SQLCODE,SQLERRM,'COD_ABI='||V_COD_ABI);
            raise;
    END;

    BEGIN
        SELECT E.VALORE_COSTANTE
        INTO v_prefix_file_qdc
        FROM T_MCRES_WRK_configurazione e
        WHERE E.NOME_COSTANTE = 'QDC_FILE_PREFIX' ;
    EXCEPTION
        WHEN OTHERS THEN
            PKG_MCRES_AUDIT.LOG_CARICAMENTI(P_REC.SEQ_FLUSSO,C_NOME,PKG_MCRES_AUDIT.C_ERROR,SQLCODE,SQLERRM,'QDC_FILE_PREFIX='||v_prefix_file_qdc);
            raise;
    END;

    v_note := ' Setting system context - ABI='||V_COD_ABI;
   dbms_application_info.set_client_info( V_COD_ABI );

    v_stmt := '
    declare
        v_outfile       utl_file.file_type;
    begin
        v_outfile   := utl_file.fopen (''' || upper(v_dir) || ''', ''' || v_prefix_file_qdc||v_cod_flusso ||'.'||V_COD_ABI||''', ''w'');
        for r in (select line from ' || upper(v_tab_src) || ')
        loop
            utl_file.put_line (v_outfile, r.line, false);
            utl_file.fflush (v_outfile);
        end loop;
        commit;
        utl_file.fclose (v_outfile);
    end;';
    v_note := ' Spool file -'||v_stmt;
    execute immediate v_stmt;

   return ok;
exception
   when others then
        pkg_mcres_audit.log_caricamenti(P_REC.SEQ_FLUSSO, c_nome, pkg_mcres_audit.c_error, sqlcode, sqlerrm, 'ERRORE ' ||  v_note);
        return ko;
end;

function fnc_mcres_copy_mcrd (
    P_REC IN F_SLAVE_PAR_TYPE
)return number
is
     c_nome       constant varchar2(50) := c_package || '.fnc_mcres_copy_mcrd';
     v_note                      t_mcres_wrk_audit_caricamenti.note%type;
     v_stmt          varchar2(32767);

    V_COD_ABI  T_MCRES_WRK_ACQUISIZIONE.cod_abi%type;
    v_cod_flusso T_MCRES_WRK_ACQUISIZIONE.cod_flusso%type;
    V_ESITO number(1):=0;

begin

    BEGIN
        SELECT
            COD_ABI,
            cod_flusso
        INTO
            V_COD_ABI,
            v_cod_flusso
        FROM T_MCRES_WRK_ACQUISIZIONE
        WHERE ID_FLUSSO = P_REC.SEQ_FLUSSO;
    EXCEPTION
        WHEN OTHERS THEN
            PKG_MCRES_AUDIT.LOG_CARICAMENTI(P_REC.SEQ_FLUSSO,C_NOME,PKG_MCRES_AUDIT.C_ERROR,SQLCODE,SQLERRM,'ID_FLUSSO = '|| P_REC.SEQ_FLUSSO);
            raise;
    END;

    if(v_cod_flusso= 'MCRDSISBACP') then
        V_ESITO    := PKG_MCRES_GESTIONE_PARTIZIONI.FNC_CREA_PARTIZIONE('T_MCRES_APP_SISBA_CP',TO_CHAR(P_REC.PERIODO,'YYYYMMDD'),P_REC.SEQ_FLUSSO);
        V_NOTE     := 'Esito crea partizione periodo (Mensili) SISBA_CP : '||V_ESITO||' ABI='||V_COD_ABI;
        V_ESITO    := PKG_MCRES_GESTIONE_PARTIZIONI.FNC_CREA_SOTTOPARTIZIONE('T_MCRES_APP_SISBA_CP',V_COD_ABI,P_REC.SEQ_FLUSSO);
        V_NOTE   := 'Esito crea subpartition SISBA_CP: '||V_ESITO||' ABI='||V_COD_ABI;

      delete from T_MCRES_APP_SISBA_CP
      WHERE COD_ABI = V_COD_ABI
      AND ID_DPER = TO_CHAR(P_REC.PERIODO,'YYYYMMDD');
      INSERT INTO T_MCRES_APP_SISBA_CP (
        COD_ABI,
        COD_FILIALE,
        COD_FILIALE_AREA,
        COD_FORMA_TECN,
        COD_FORMA_TECN_CMLT,
        COD_NDG,
        COD_RAPPORTO,
        COD_RAPPORTO_ORIG,
        COD_R437,
        COD_SEGM_IRB,
        COD_SEGM_STAND,
        COD_SNDG,
        COD_SPORTELLO,
        COD_STATO_GIURIDICO,
        COD_STATO_RISCHIO,
        DTA_DECORRENZA_STATO,
        DTA_SISBA_CP,
        VAL_ATT,
        VAL_ATT_OLD,
        VAL_DELTA_IAS_LORDO,
        VAL_DELTA_IAS_RET,
        VAL_FIRMA,
        VAL_IMP_GAR_IPOT,
        VAL_MORA,
        VAL_NUM_ATT,
        VAL_NUM_DUBBIO_ESITO,
        VAL_RATEO_CORR,
        VAL_RATEO_MORA,
        VAL_SOPRAVVENIENZE,
        VAL_STRALCI_ALTRI_CAP,
        VAL_STRALCI_ALTRI_MORA,
        VAL_STRALCI_FISC_CAP,
        VAL_STRALCI_FISC_MORA,
        VAL_UTI_FIRMA,
        VAL_UTI_RET,
        VAL_UTI_RET_OLD,
        VAL_VANT,
        COD_OPERATORE_INS_UPD,
        DTA_INS,
        DTA_UPD,
        ID_DPER )
    SELECT COD_ABI,
        COD_FILIALE,
        COD_FILIALE_AREA,
        COD_FORMA_TECN,
        COD_FORMA_TECN_CMLT,
        COD_NDG,
        COD_RAPPORTO,
        COD_RAPPORTO_ORIG,
        COD_R437,
        COD_SEGM_IRB,
        COD_SEGM_STAND,
        COD_SNDG,
        COD_SPORTELLO,
        COD_STATO_GIURIDICO,
        COD_STATO_RISCHIO,
        DTA_DECORRENZA_STATO,
        DTA_SISBA_CP,
        VAL_ATT,
        VAL_ATT_OLD,
        VAL_DELTA_IAS_LORDO,
        VAL_DELTA_IAS_RET,
        VAL_FIRMA,
        VAL_IMP_GAR_IPOT,
        VAL_MORA,
        VAL_NUM_ATT,
        VAL_NUM_DUBBIO_ESITO,
        VAL_RATEO_CORR,
        VAL_RATEO_MORA,
        VAL_SOPRAVVENIENZE,
        VAL_STRALCI_ALTRI_CAP,
        VAL_STRALCI_ALTRI_MORA,
        VAL_STRALCI_FISC_CAP,
        VAL_STRALCI_FISC_MORA,
        VAL_UTI_FIRMA,
        VAL_UTI_RET,
        VAL_UTI_RET_OLD,
        VAL_VANT,
     'MCRD'COD_OPERATORE_INS_UPD,
     SYSDATE DTA_INS,
     SYSDATE DTA_UPD,
      ID_DPER
    FROM T_MCRES_APP_MCRDSISBACP
    WHERE COD_ABI = V_COD_ABI
    AND ID_DPER = TO_CHAR(P_REC.PERIODO,'YYYYMMDD');

    elsif(v_cod_flusso= 'MCRDEFFEECO') then
        V_ESITO    := PKG_MCRES_GESTIONE_PARTIZIONI.FNC_CREA_PARTIZIONE('T_MCRES_APP_EFFETTI_ECONOMICI',TO_CHAR(P_REC.PERIODO,'YYYYMMDD'),P_REC.SEQ_FLUSSO);
        V_NOTE     := 'Esito crea partizione periodo (Mensili) EFFETTI_ECONOMICI : '||V_ESITO||' ABI='||V_COD_ABI;
        V_ESITO    := PKG_MCRES_GESTIONE_PARTIZIONI.FNC_CREA_SOTTOPARTIZIONE('T_MCRES_APP_EFFETTI_ECONOMICI',V_COD_ABI,P_REC.SEQ_FLUSSO);
        V_NOTE   := 'Esito crea subpartition EFFETTI_ECONOMICI: '||V_ESITO||' ABI='||V_COD_ABI;

      delete from T_MCRES_APP_EFFETTI_ECONOMICI
      WHERE COD_ABI = V_COD_ABI
      AND ID_DPER = TO_CHAR(P_REC.PERIODO,'YYYYMMDD');
      INSERT INTO T_MCRES_APP_EFFETTI_ECONOMICI (
        COD_ABI,
        COD_NDG,
        COD_STATO_FIN,
        COD_STATO_INI,
        DTA_EFFETTI_ECONOMICI,
        --FLG_TAPPO
        ID_DPER,
        VAL_ATTUALIZZAZIONE,
        VAL_PER_CE,
        VAL_QUOTA_ATT,
        VAL_QUOTA_SVAL,
        VAL_RETT_ATT,
        VAL_RETT_SVAL,
        VAL_RIP_ATT,
        VAL_RIP_MORA,
        VAL_RIP_SVAL,
        COD_OPERATORE_INS_UPD,
        DTA_INS,
        DTA_UPD)
        SELECT
        COD_ABI,
        COD_NDG,
        COD_STATO_FIN,
        COD_STATO_INI,
        DTA_EFFETTI_ECONOMICI,
      --  FLG_TAPPO
        ID_DPER,
        VAL_ATTUALIZZAZIONE,
        VAL_PER_CE,
        VAL_QUOTA_ATT,
        VAL_QUOTA_SVAL,
        VAL_RETT_ATT,
        VAL_RETT_SVAL,
        VAL_RIP_ATT,
        VAL_RIP_MORA,
        VAL_RIP_SVAL,
        'MCRD'COD_OPERATORE_INS_UPD,
        SYSDATE DTA_INS,
        SYSDATE DTA_UPD
        FROM T_MCRES_APP_MCRDEFFEECO
        WHERE COD_ABI = V_COD_ABI
        AND ID_DPER = TO_CHAR(P_REC.PERIODO,'YYYYMMDD');
    elsif(v_cod_flusso= 'MCRDMODMOV') then
         V_ESITO    := PKG_MCRES_GESTIONE_PARTIZIONI.FNC_CREA_PARTIZIONE('T_MCRES_APP_MOVIMENTI_MOD_MOV',TO_CHAR(P_REC.PERIODO,'YYYYMMDD'),P_REC.SEQ_FLUSSO);
        V_NOTE     := 'Esito crea partizione periodo (Mensili) MOVIMENTI_MOD_MOV : '||V_ESITO||' ABI='||V_COD_ABI;
        V_ESITO    := PKG_MCRES_GESTIONE_PARTIZIONI.FNC_CREA_SOTTOPARTIZIONE('T_MCRES_APP_MOVIMENTI_MOD_MOV',V_COD_ABI,P_REC.SEQ_FLUSSO);
        V_NOTE   := 'Esito crea subpartition MOVIMENTI_MOD_MOV: '||V_ESITO||' ABI='||V_COD_ABI;

      delete from T_MCRES_APP_MOVIMENTI_MOD_MOV
      WHERE COD_ABI = V_COD_ABI
      AND ID_DPER = TO_CHAR(P_REC.PERIODO,'YYYYMMDD');
      INSERT INTO T_MCRES_APP_MOVIMENTI_MOD_MOV (
        ID_DPER,
        COD_ABI,
        COD_NDG,
        COD_STATO_RISCHIO,
        DESC_MODULO,
        DTA_MOD_MOV,
        FLG_TAPPO,
        VAL_CR_INDU,
        VAL_CR_ORDINARIO,
        VAL_CR_SPEC,
        VAL_CR_TOT,
        VAL_DUBES_ATT,
        VAL_DUBES_PREC,
        COD_OPERATORE_INS_UPD,
        DTA_INS,
        DTA_UPD
      )
 SELECT ID_DPER,
        COD_ABI,
        COD_NDG,
        max(COD_STATO_RISCHIO),
        DESC_MODULO,
        DTA_MOD_MOV,
        FLG_TAPPO,
        SUM(VAL_CR_INDU),
        SUM(VAL_CR_ORDINARIO),
        SUM(VAL_CR_SPEC),
        SUM(VAL_CR_TOT),
        SUM(VAL_DUBES_ATT),
        SUM(VAL_DUBES_PREC),
        'MCRD' COD_OPERATORE_INS_UPD,
        SYSDATE DTA_INS,
        SYSDATE DTA_UPD
      FROM T_MCRES_APP_MCRDMODMOV
      WHERE COD_ABI = V_COD_ABI
      AND ID_DPER = TO_CHAR(P_REC.PERIODO,'YYYYMMDD')
      GROUP BY ID_DPER,
        COD_ABI,
        COD_NDG,
        DESC_MODULO,
        DTA_MOD_MOV,
        FLG_TAPPO,
        ID_DPER;

    end if;

    COMMIT;
    RETURN OK;

exception
   when others then
        pkg_mcres_audit.log_caricamenti(P_REC.SEQ_FLUSSO, c_nome, pkg_mcres_audit.c_error, sqlcode, sqlerrm, 'ERRORE ' ||  v_note);
        return ko;
end;

function fnc_mcres_sopravve (
    P_REC IN F_SLAVE_PAR_TYPE
)return number
is
     c_nome       constant varchar2(50) := c_package || '.fnc_mcres_sopravve';
     v_note                      t_mcres_wrk_audit_caricamenti.note%type;
     v_stmt          varchar2(32767);

    V_COD_ABI  T_MCRES_WRK_ACQUISIZIONE.cod_abi%type;
    v_cod_flusso T_MCRES_WRK_ACQUISIZIONE.cod_flusso%type;

begin

    BEGIN
        SELECT
            COD_ABI,
            cod_flusso
        INTO
            V_COD_ABI,
            v_cod_flusso
        FROM T_MCRES_WRK_ACQUISIZIONE
        WHERE ID_FLUSSO = P_REC.SEQ_FLUSSO;
    EXCEPTION
        WHEN OTHERS THEN
            PKG_MCRES_AUDIT.LOG_CARICAMENTI(P_REC.SEQ_FLUSSO,C_NOME,PKG_MCRES_AUDIT.C_ERROR,SQLCODE,SQLERRM,'ID_FLUSSO = '|| P_REC.SEQ_FLUSSO);
            return ko;
    END;

    BEGIN
        delete from t_mcres_app_sisba_cp
        where cod_abi  = V_COD_ABI
        and id_dper =  (select MAX(id_dper) from V_MCRES_ULTIMA_ACQ_BILANCIO where cod_abi  = V_COD_ABI)
        and cod_rapporto = '-1';

        insert into t_mcres_app_sisba_cp
        (id_dper,cod_abi,cod_ndg,cod_rapporto,cod_sportello,val_sopravvenienze,
         COD_STATO_GIURIDICO,COD_STATO_RISCHIO,DTA_DECORRENZA_STATO,
          cod_sndg,cod_filiale_area,dta_ins,dta_upd)
        select
           (select MAX(id_dper) from V_MCRES_ULTIMA_ACQ_BILANCIO where cod_abi  = V_COD_ABI)id_dper,
          v.cod_abi, v.cod_ndg, -1 cod_rapporto, -1 cod_sportello,val_importo,
          p.COD_STATO_GIURIDICO,p.COD_STATO_RISCHIO,p.DTA_passaggio_soff,
          a.cod_sndg,cod_uo_pratica,sysdate,sysdate
        from t_mcres_app_sopravve v,
             t_mcres_app_posizioni p,
             t_mcres_app_pratiche a
        where v.cod_abi = p.cod_abi(+)
        and v.cod_ndg = p.cod_ndg (+)
        and p.flg_attiva (+) = 1
        and v.cod_abi = a.cod_abi(+)
        and v.cod_ndg = a.cod_ndg (+)
        and a.flg_attiva (+) = 1
        and v.cod_abi = V_COD_ABI;

    EXCEPTION
        WHEN OTHERS THEN
            PKG_MCRES_AUDIT.LOG_CARICAMENTI(P_REC.SEQ_FLUSSO,C_NOME,PKG_MCRES_AUDIT.C_ERROR,SQLCODE,SQLERRM,'Insert sopravve - ID_FLUSSO = '|| P_REC.SEQ_FLUSSO);
            return ko;
    END;

    COMMIT;
    RETURN OK;

exception
   when others then
        pkg_mcres_audit.log_caricamenti(P_REC.SEQ_FLUSSO, c_nome, pkg_mcres_audit.c_error, sqlcode, sqlerrm, 'ERRORE ' ||  v_note);
        return ko;
end;


function fnc_mcres_spese_epc (
    P_REC IN F_SLAVE_PAR_TYPE
)return number
is
     c_nome       constant varchar2(50) := c_package || '.fnc_mcres_spese_epc';
     v_note                      t_mcres_wrk_audit_caricamenti.note%type;
     v_stmt          varchar2(32767);

    v_cod_flusso T_MCRES_WRK_ACQUISIZIONE.cod_flusso%type;
    v_id_dper varchar2(8);

begin

    BEGIN
        SELECT
            cod_flusso,
            to_char(id_dper, 'yyyymmdd')
        INTO
            v_cod_flusso,
            v_id_dper
        FROM T_MCRES_WRK_ACQUISIZIONE
        WHERE ID_FLUSSO = P_REC.SEQ_FLUSSO;
    EXCEPTION
        WHEN OTHERS THEN
            PKG_MCRES_AUDIT.LOG_CARICAMENTI(P_REC.SEQ_FLUSSO,C_NOME,PKG_MCRES_AUDIT.C_ERROR,SQLCODE,SQLERRM,'ID_FLUSSO = '|| P_REC.SEQ_FLUSSO);
            return ko;
    END;

    BEGIN


    MERGE INTO t_mcres_app_sp_spese s
   USING (SELECT id_dper, cod_abi, cod_ndg, cod_autorizzazione,
        cod_tipo_autorizzazione, val_anno_pratica, cod_pratica_legale,
        val_numero_fattura, dta_fattura, cod_importo_divisa,
        val_importo_valore, cod_causale, val_afavore_piva,
        val_afavore_codfisc, cod_iban, val_obj_id_doc, val_desc_file,
        flg_doc_automatico, val_rif_nominativo, val_prof_cap,
        val_prof_comune, val_prof_fax, val_prof_indirizzo, val_prof_ncivico,
        val_prof_provincia, val_tot_imp, val_tot_iva, val_tot_netdaliq,
        val_aliq_contrprev, val_imp_contrprev, val_aliq_ritacc, val_perc_ritenuta_fo,
        val_imp_ritacc, val_aliq_iva, val_imponibile_iva, val_spes_non_imp, val_rimborso_forfetar, (select max(lg.flg_convenz)
from  t_mcres_app_legali_esterni lg
where lg.val_legale_codfisc = val_afavore_codfisc) flg_convenzione
            FROM t_mcres_app_spese_epc epc left join
       (select cod_abi_fo, val_codice_fiscale_fo, val_perc_ritenuta_fo, val_aliquota_ritenuta_fo,
               val_aliquota_cpa_fo from (select cod_abi cod_abi_fo, val_codice_fiscale val_codice_fiscale_fo, val_perc_ritenuta val_perc_ritenuta_fo,
               val_aliquota_ritenuta val_aliquota_ritenuta_fo, val_aliquota_cpa val_aliquota_cpa_fo,
               row_number() over (partition by val_codice_fiscale, f.cod_societa order by cod_sap_fornitore desc) r
          from t_mcres_app_fornitori f join t_mcres_cl_sap s on f.cod_societa = s.cod_societa) where r = 1) fo
          on epc.cod_abi = fo.cod_abi_fo and epc.val_afavore_codfisc = fo.val_codice_fiscale_fo
          WHERE id_dper = v_id_dper) t
   ON (s.cod_autorizzazione = t.cod_autorizzazione)
   WHEN MATCHED THEN
      UPDATE
         SET s.id_dper = t.id_dper, s.cod_abi = t.cod_abi, s.cod_ndg = t.cod_ndg, s.cod_tipo_autorizzazione = t.cod_tipo_autorizzazione,
         s.val_anno_pratica = t.val_anno_pratica, s.cod_pratica = t.cod_pratica_legale,
         s.val_numero_fattura = t.val_numero_fattura, s.dta_fattura = t.dta_fattura, s.cod_importo_divisa = t.cod_importo_divisa,
         s.val_importo_valore = t.val_importo_valore, s.cod_causale = t.cod_causale, s.val_intestatario_piva = t.val_afavore_piva,
         s.val_intestatario_codfisc = t.val_afavore_codfisc, s.cod_iban = t.cod_iban, s.cod_intestatario_tipo = 'L',
         s.desc_intestatario = substr(t.val_rif_nominativo,0,80), s.val_riferimento_nominativo = substr(t.val_rif_nominativo,0,64), s.val_prof_cap = t.val_prof_cap,
         s.val_prof_comune = t.val_prof_comune, s.val_prof_fax = t.val_prof_fax, s.val_prof_indirizzo = t.val_prof_indirizzo,
         s.val_prof_ncivico = t.val_prof_ncivico, s.val_prof_provincia = t.val_prof_provincia, s.importo_voce = REPLACE(t.val_imponibile_iva || ';'||
         CASE WHEN t.val_spes_non_imp > 0 THEN t.val_spes_non_imp
              WHEN t.val_rimborso_forfetar > 0 THEN t.val_rimborso_forfetar ELSE 0 END || ';' ||
         CASE WHEN t.val_spes_non_imp > 0 AND t.val_rimborso_forfetar > 0 THEN t.val_rimborso_forfetar ELSE 0 END || ';0;0', ',', '.'), s.importo_iva = t.val_tot_iva,
         s.aliquota_cpa = t.val_aliq_contrprev, s.importo_cpa = t.val_imp_contrprev,
         s.val_aliquota_ritenuta = t.val_aliq_ritacc, s.importo_ritenuta = t.val_imp_ritacc, s.dta_upd = SYSDATE,
         s.regime_iva = NVL((SELECT COD_IVA FROM T_MCRES_CL_CODIVA
                        WHERE VAL_SCHEMA_IVA = 'TAXIT' AND FLG_ATTIVO = 1
                        AND VAL_PERC_IVA = t.val_aliq_iva
                        AND COD_IVA IN ('EA','I2','IA','IB')), 'I2') || ';' ||
         CASE WHEN t.val_spes_non_imp > 0 THEN 'NP'
              WHEN t.val_rimborso_forfetar > 0 THEN 'NS' ELSE 'I2' END || ';' ||
         CASE WHEN t.val_spes_non_imp > 0 AND t.val_rimborso_forfetar > 0 THEN 'NS' ELSE 'I2' END || ';I2;I2',
         s.flg_ritenuta_applicabile = CASE WHEN t.val_imp_ritacc > 0 THEN 'S' ELSE 'N' END, s.val_perc_ritenuta = t.val_perc_ritenuta_fo, s.flg_convenzione = t.flg_convenzione
   WHEN NOT MATCHED THEN
      INSERT (id_dper, cod_abi, cod_ndg, cod_autorizzazione, cod_tipo_autorizzazione,
         val_anno_pratica, cod_pratica,
         val_numero_fattura, dta_fattura, cod_importo_divisa,
         val_importo_valore, cod_causale, val_intestatario_piva,
         val_intestatario_codfisc, cod_iban,
         val_riferimento_nominativo, val_prof_cap,
         val_prof_comune, val_prof_fax, val_prof_indirizzo,
         val_prof_ncivico, val_prof_provincia, importo_voce, importo_iva,
         aliquota_cpa, importo_cpa,
         val_aliquota_ritenuta, importo_ritenuta, dta_ins,
         dta_upd, cod_operatore_ins_upd, flg_source, cod_stato, regime_iva, flg_ritenuta_applicabile, cod_intestatario_tipo, desc_intestatario, val_perc_ritenuta, flg_convenzione)
      VALUES (t.id_dper, t.cod_abi, t.cod_ndg, t.cod_autorizzazione,
        t.cod_tipo_autorizzazione, t.val_anno_pratica, t.cod_pratica_legale,
        t.val_numero_fattura, t.dta_fattura, t.cod_importo_divisa,
        t.val_importo_valore, t.cod_causale, t.val_afavore_piva,
        t.val_afavore_codfisc, t.cod_iban, substr(t.val_rif_nominativo,0,64), t.val_prof_cap,
        t.val_prof_comune, t.val_prof_fax, t.val_prof_indirizzo, t.val_prof_ncivico,
        t.val_prof_provincia, REPLACE(t.val_imponibile_iva || ';'||
         CASE WHEN t.val_spes_non_imp > 0 THEN t.val_spes_non_imp
              WHEN t.val_rimborso_forfetar > 0 THEN t.val_rimborso_forfetar ELSE 0 END || ';' ||
         CASE WHEN t.val_spes_non_imp > 0 AND t.val_rimborso_forfetar > 0 THEN t.val_rimborso_forfetar ELSE 0 END || ';0;0', ',', '.'), t.val_tot_iva,
        t.val_aliq_contrprev, t.val_imp_contrprev, t.val_aliq_ritacc,
        t.val_imp_ritacc, SYSDATE, SYSDATE, 'BATCH_EPC', 'EPC', 'NC', NVL((SELECT COD_IVA FROM T_MCRES_CL_CODIVA
                        WHERE VAL_SCHEMA_IVA = 'TAXIT' AND FLG_ATTIVO = 1
                        AND VAL_PERC_IVA = t.val_aliq_iva
                        AND COD_IVA IN ('EA','I2','IA','IB')), 'I2') || ';' ||
         CASE WHEN t.val_spes_non_imp > 0 THEN 'NP'
              WHEN t.val_rimborso_forfetar > 0 THEN 'NS' ELSE 'I2' END || ';' ||
         CASE WHEN t.val_spes_non_imp > 0 AND t.val_rimborso_forfetar > 0 THEN 'NS' ELSE 'I2' END || ';I2;I2',
                        CASE WHEN t.val_imp_ritacc > 0 THEN 'S' ELSE 'N' END, 'L', substr(t.val_rif_nominativo,0,80), t.val_perc_ritenuta_fo, t.flg_convenzione);


    EXCEPTION
        WHEN OTHERS THEN
            PKG_MCRES_AUDIT.LOG_CARICAMENTI(P_REC.SEQ_FLUSSO,C_NOME,PKG_MCRES_AUDIT.C_ERROR,SQLCODE,SQLERRM,'Merge spese epc in app sp spese - ID_FLUSSO = '|| P_REC.SEQ_FLUSSO);
            return ko;
    END;

     BEGIN


    FOR I IN (SELECT COD_AUTORIZZAZIONE FROM T_MCRES_APP_SP_SPESE
           WHERE COD_STATO = 'NC' AND FLG_SOURCE = 'EPC' AND ID_DPER = v_id_dper)

    LOOP

    --AP 07/02/2014
    DELETE FROM T_MCRES_APP_SP_FATTURE WHERE COD_AUTORIZZAZIONE = I.COD_AUTORIZZAZIONE;

    INSERT INTO T_MCRES_APP_SP_FATTURE (COD_AUTORIZZAZIONE, COD_TIPO_AUTORIZZAZIONE, VAL_IMPORTO_VOCE, COD_SAP_IVA, PROG_FATTURA, DTA_INS)
    SELECT A.COD_AUTORIZZAZIONE,
           A.COD_TIPO_AUTORIZZAZIONE,
           TO_NUMBER(REGEXP_SUBSTR (IMPORTO_VOCE,'[^;]+', 1, LEVEL),  '9999999999999D99999', 'NLS_NUMERIC_CHARACTERS = ''.,''') AS VAL_IMPORTO_VOCE,
           REGEXP_SUBSTR (REGIME_IVA,'[^;]+', 1, LEVEL) AS COD_SAP_IVA,
           ROWNUM PROG_FATTURA,
           SYSDATE DTA_INS
      FROM
           (SELECT * FROM T_MCRES_APP_SP_SPESE
           WHERE COD_AUTORIZZAZIONE = I.COD_AUTORIZZAZIONE) A
           CONNECT BY REGEXP_SUBSTR (IMPORTO_VOCE,'[^;]+', 1, LEVEL) IS NOT NULL
           AND REGEXP_SUBSTR (REGIME_IVA,'[^;]+', 1, LEVEL) IS NOT NULL;

    END LOOP;

MERGE INTO t_mcres_app_sp_fatture t
   USING (SELECT cod_autorizzazione, prog_fattura,
                 val_importo_voce val_imponibile_iva,
                 cl.val_perc_iva val_aliquota_iva,
                 ROUND (val_importo_voce * val_perc_iva / 100,
                        2
                       ) val_importo_iva,
                   val_importo_voce
                 + ROUND (val_importo_voce * val_perc_iva / 100, 2)
                                                              val_importo_pos
            FROM t_mcres_app_sp_fatture f, t_mcres_cl_codiva cl
           WHERE 0 = 0 AND f.cod_sap_iva = cl.cod_iva AND cl.flg_attivo = 1
             AND exists (SELECT 1 FROM T_MCRES_APP_SP_SPESE
           WHERE COD_STATO = 'NC' AND FLG_SOURCE = 'EPC' AND ID_DPER = v_id_dper AND COD_AUTORIZZAZIONE = f.cod_autorizzazione)) s
   ON (    t.cod_autorizzazione = s.cod_autorizzazione
       AND t.prog_fattura = s.prog_fattura)
   WHEN MATCHED THEN
      UPDATE
         SET t.val_imponibile_iva = s.val_imponibile_iva,
             t.val_aliquota_iva = s.val_aliquota_iva,
             t.val_importo_iva = s.val_importo_iva,
             t.val_importo_pos = s.val_importo_pos;


    EXCEPTION
        WHEN OTHERS THEN
            PKG_MCRES_AUDIT.LOG_CARICAMENTI(P_REC.SEQ_FLUSSO,C_NOME,PKG_MCRES_AUDIT.C_ERROR,SQLCODE,SQLERRM,'Insert/Merge spese epc in app sp fatture - ID_FLUSSO = '|| P_REC.SEQ_FLUSSO);
            return ko;
    END;


     BEGIN

     --AP 07/02/2014
     DELETE FROM t_mcres_app_documenti doc
     where exists (select 1 from t_mcres_app_sp_spese sp
               where sp.cod_autorizzazione = doc.cod_aut_protoc
                 and sp.cod_Stato = 'NC' and sp.flg_source = 'EPC'
                 and sp.id_dper = v_id_dper);

    INSERT INTO t_mcres_app_documenti
    (ID_OBJECT, COD_ABI, COD_NDG, COD_PRATICA,
  VAL_ANNO_PRATICA, COD_AUT_PROTOC, COD_TIPO_DEL_SPESA,
  COD_TIPO_DOCUMENTO, COD_PROGRESSIVO, COD_STATO,
  COD_ORIGINE, VAL_DOC_NAME, DTA_INS, COD_IDENTIFICATIVO)
select
  epc.val_obj_id_doc ID_OBJECT,
  COD_ABI,
  COD_NDG,
  epc.cod_pratica_legale COD_PRATICA,
  VAL_ANNO_PRATICA,
  epc.cod_autorizzazione COD_AUT_PROTOC,
  epc.cod_tipo_autorizzazione COD_TIPO_DEL_SPESA,
  'DO' COD_TIPO_DOCUMENTO,
  '01' COD_PROGRESSIVO,
  'IN' COD_STATO,
  'EPC' COD_ORIGINE,
  epc.val_desc_file VAL_DOC_NAME,
  SYSDATE,
  epc.cod_autorizzazione COD_IDENTIFICATIVO from t_mcres_app_spese_epc epc
where exists (select 1 from t_mcres_app_sp_spese sp
               where sp.cod_autorizzazione = epc.cod_autorizzazione
                 and sp.cod_Stato = 'NC' and sp.flg_source = 'EPC'
                 and sp.id_dper = v_id_dper);


    EXCEPTION
        WHEN OTHERS THEN
            PKG_MCRES_AUDIT.LOG_CARICAMENTI(P_REC.SEQ_FLUSSO,C_NOME,PKG_MCRES_AUDIT.C_ERROR,SQLCODE,SQLERRM,'Insert spese epc in app documenti - ID_FLUSSO = '|| P_REC.SEQ_FLUSSO);
            return ko;
    END;

    COMMIT;
    RETURN OK;

exception
   when others then
        pkg_mcres_audit.log_caricamenti(P_REC.SEQ_FLUSSO, c_nome, pkg_mcres_audit.c_error, sqlcode, sqlerrm, 'ERRORE ' ||  v_note);
        return ko;
end;

function fnc_annullamento_delibere(
    P_REC IN F_SLAVE_PAR_TYPE)
return number is

  C_NOME CONSTANT VARCHAR2(100) := C_PACKAGE || '.FNC_ANNULLAMENTO_DELIBERE';
  V_NOTE VARCHAR2(1000) := 'GENERALE';
  V_COD_ABI T_MCRES_WRK_ACQUISIZIONE.COD_ABI%type;
  V_COD_FILE T_MCRES_WRK_ACQUISIZIONE.COD_FILE%TYPE;
  v_cod_flusso  t_mcres_wrk_alimentazione.cod_flusso%type;

  cursor c (p_cod_abi T_MCRES_WRK_ACQUISIZIONE.COD_ABI%type)  is
    select * from v_mcres_app_del_da_ann where cod_abi = p_cod_abi;

begin

  BEGIN
    SELECT
        COD_ABI,
        COD_FILE,
        cod_flusso
    INTO
        V_COD_ABI,
        V_COD_FILE,
        v_cod_flusso
    FROM T_MCRES_WRK_ACQUISIZIONE
    WHERE ID_FLUSSO = P_REC.SEQ_FLUSSO;
  EXCEPTION
  WHEN OTHERS THEN
    PKG_MCRES_AUDIT.LOG_CARICAMENTI(P_REC.SEQ_FLUSSO,C_NOME,PKG_MCRES_AUDIT.C_ERROR,SQLCODE,SQLERRM,'COD_ABI='||V_COD_ABI);
    raise;
    return ko;
  END;

    V_NOTE := 'Inizio annullamento delibere';
    for rec_c in c(V_COD_ABI) loop
        begin
            V_NOTE := 'ABI= '||rec_c.cod_abi||' NDG= '||rec_c.cod_ndg||' PROTOCOLLO_DEL= '||rec_c.cod_protocollo_delibera;
            update t_mcres_app_delibere
            set cod_stato_delibera = 'AN',
                 DTA_ANNULLAMENTO_DELIBERA = sysdate
            where cod_abi = rec_c.cod_abi
            and cod_ndg = rec_c.cod_ndg
            and cod_protocollo_delibera = rec_c.cod_protocollo_delibera;
            commit;
            PKG_MCRES_AUDIT.LOG_CARICAMENTI(P_REC.SEQ_FLUSSO,C_NOME,PKG_MCRES_AUDIT.C_DEBUG,SQLCODE,SQLERRM,V_NOTE);
        end;
     end loop;
     return ok;
EXCEPTION
  WHEN OTHERS THEN
    PKG_MCRES_AUDIT.LOG_CARICAMENTI(P_REC.SEQ_FLUSSO,C_NOME,PKG_MCRES_AUDIT.C_ERROR,SQLCODE,SQLERRM,V_NOTE);
    return ko;
end fnc_annullamento_delibere;


function fnc_reload_alert_rapp_da_volt
(
    p_rec f_slave_par_type
)
return number
is

 C_NOME CONSTANT VARCHAR2(100) := C_PACKAGE || '.FNC_RELOAD_RAPP_DA_VOLT';
  V_NOTE VARCHAR2(1000) := 'GENERALE';
  V_COD_ABI T_MCRES_WRK_ACQUISIZIONE.COD_ABI%type;
  V_COD_FILE T_MCRES_WRK_ACQUISIZIONE.COD_FILE%TYPE;
  v_cod_flusso  t_mcres_wrk_alimentazione.cod_flusso%type;


    cursor c_alert is
        select val_ins_query, val_del_qry, val_note
        from t_mcres_wrk_alimentazione_fen
        where 0=0
            and flg_attiva = 1
            and val_tbl_name = 'T_MCRES_FEN_ALERT_POS'
            and instr(flg_gruppo, 'ID_ALERT = 40') = 1;

    cursor c_abi is

        select cod_abi
        from t_mcres_app_istituti
        where flg_target = 'Y';

begin

 PKG_MCRES_AUDIT.LOG_CARICAMENTI(P_REC.SEQ_FLUSSO,C_NOME,PKG_MCRES_AUDIT.C_DEBUG,SQLCODE,SQLERRM, 'INIZIO');

    for r_alert in c_alert
    loop

        for r_abi in c_abi
        loop

            execute immediate r_alert.val_del_qry using r_abi.cod_abi;

            execute immediate r_alert.val_ins_query using r_abi.cod_abi;


        end loop;


        PKG_MCRES_AUDIT.LOG_CARICAMENTI(P_REC.SEQ_FLUSSO,C_NOME,PKG_MCRES_AUDIT.C_DEBUG,SQLCODE,SQLERRM, 'Effettuato reload alert ' || r_alert.val_note);

        commit;


    end loop;


 PKG_MCRES_AUDIT.LOG_CARICAMENTI(P_REC.SEQ_FLUSSO,C_NOME,PKG_MCRES_AUDIT.C_DEBUG,SQLCODE,SQLERRM, 'FINE');

    return ok;


exception
when others
then


PKG_MCRES_AUDIT.LOG_CARICAMENTI(P_REC.SEQ_FLUSSO,C_NOME,PKG_MCRES_AUDIT.C_ERROR,SQLCODE,SQLERRM, 'GENERALE: ' || v_note);

    rollback;

    return ko;

end fnc_reload_alert_rapp_da_volt;


function fnc_reload_alert_delibere_ft
(
    p_rec f_slave_par_type
)
return number
is

 C_NOME CONSTANT VARCHAR2(100) := C_PACKAGE || '.FNC_RELOAD_ALERT_DELIBERE_FT';
  V_NOTE VARCHAR2(1000) := 'GENERALE';
  V_COD_ABI T_MCRES_WRK_ACQUISIZIONE.COD_ABI%type;
  V_COD_FILE T_MCRES_WRK_ACQUISIZIONE.COD_FILE%TYPE;
  v_cod_flusso  t_mcres_wrk_alimentazione.cod_flusso%type;


    cursor c_alert is
        select val_ins_query, val_del_qry, val_note
        from t_mcres_wrk_alimentazione_fen
        where 0=0
            and flg_attiva = 1
            and val_tbl_name = 'T_MCRES_FEN_ALERT_POS'
            and instr(flg_gruppo, 'ID_ALERT = 41') = 1;

    cursor c_abi is

        select cod_abi
        from t_mcres_app_istituti
        where flg_target = 'Y'
        and cod_Abi = (SELECT
            COD_ABI
        FROM T_MCRES_WRK_ACQUISIZIONE
        WHERE ID_FLUSSO = P_REC.SEQ_FLUSSO);

begin

    PKG_MCRES_AUDIT.LOG_CARICAMENTI(P_REC.SEQ_FLUSSO,C_NOME,PKG_MCRES_AUDIT.C_DEBUG,SQLCODE,SQLERRM, 'INIZIO');


    for r_alert in c_alert
    loop

        for r_abi in c_abi
        loop

            execute immediate r_alert.val_del_qry using r_abi.cod_abi;

            execute immediate r_alert.val_ins_query using r_abi.cod_abi;


        end loop;

        PKG_MCRES_AUDIT.LOG_CARICAMENTI(P_REC.SEQ_FLUSSO,C_NOME,PKG_MCRES_AUDIT.C_DEBUG,SQLCODE,SQLERRM, 'Effettuato reload alert ' || r_alert.val_note);

        commit;


    end loop;

    PKG_MCRES_AUDIT.LOG_CARICAMENTI(P_REC.SEQ_FLUSSO,C_NOME,PKG_MCRES_AUDIT.C_DEBUG,SQLCODE,SQLERRM, 'FINE');

    return ok;


exception
when others
then

PKG_MCRES_AUDIT.LOG_CARICAMENTI(P_REC.SEQ_FLUSSO,C_NOME,PKG_MCRES_AUDIT.C_ERROR,SQLCODE,SQLERRM, 'GENERALE: ' || v_note);

    rollback;

    return ko;

end fnc_reload_alert_delibere_ft;



function fnc_reload_alert_rapp_cmlt
(
    p_rec f_slave_par_type
)
return number
is

 C_NOME CONSTANT VARCHAR2(100) := C_PACKAGE || '.FNC_RELOAD_ALERT_RAPP_CMLT';
  V_NOTE VARCHAR2(1000) := 'GENERALE';
  V_COD_ABI T_MCRES_WRK_ACQUISIZIONE.COD_ABI%type;
  V_COD_FILE T_MCRES_WRK_ACQUISIZIONE.COD_FILE%TYPE;
  v_cod_flusso  t_mcres_wrk_alimentazione.cod_flusso%type;


    cursor c_alert is
        select val_ins_query, val_del_qry, val_note
        from t_mcres_wrk_alimentazione_fen
        where 0=0
            and flg_attiva = 1
            and val_tbl_name = 'T_MCRES_FEN_ALERT_POS'
            and instr(flg_gruppo, 'ID_ALERT = 45') = 1;

    cursor c_abi is

        select cod_abi
        from t_mcres_app_istituti
        where flg_target = 'Y'
        and cod_Abi = (SELECT
            COD_ABI
        FROM T_MCRES_WRK_ACQUISIZIONE
        WHERE ID_FLUSSO = P_REC.SEQ_FLUSSO);

begin

   PKG_MCRES_AUDIT.LOG_CARICAMENTI(P_REC.SEQ_FLUSSO,C_NOME,PKG_MCRES_AUDIT.C_DEBUG,SQLCODE,SQLERRM, 'INIZIO');

    for r_alert in c_alert
    loop

        for r_abi in c_abi
        loop

            execute immediate r_alert.val_del_qry using r_abi.cod_abi;

            execute immediate r_alert.val_ins_query using r_abi.cod_abi;


        end loop;

PKG_MCRES_AUDIT.LOG_CARICAMENTI(P_REC.SEQ_FLUSSO,C_NOME,PKG_MCRES_AUDIT.C_DEBUG,SQLCODE,SQLERRM, 'Effettuato reload alert ' || r_alert.val_note);

        commit;


    end loop;

PKG_MCRES_AUDIT.LOG_CARICAMENTI(P_REC.SEQ_FLUSSO,C_NOME,PKG_MCRES_AUDIT.C_DEBUG,SQLCODE,SQLERRM, 'FINE');

    return ok;


exception
when others
then

    PKG_MCRES_AUDIT.LOG_CARICAMENTI(P_REC.SEQ_FLUSSO,C_NOME,PKG_MCRES_AUDIT.C_ERROR,SQLCODE,SQLERRM, 'GENERALE: ' || v_note);

    rollback;

    return ko;

end fnc_reload_alert_rapp_cmlt;


--function fnc_ges_raccolta_doc_step0 (
--    P_REC IN F_SLAVE_PAR_TYPE
--)return number is
--
--  C_NOME CONSTANT VARCHAR2(100) := C_PACKAGE || '.FNC_GEST_RACCOLTA_DOC_STEP0';
--  V_NOTE VARCHAR2(1000) := 'GENERALE';
--
--  cursor c_list(p_cod_abi t_mcres_app_pratiche.cod_abi%type) is
--    select distinct cod_abi, cod_ndg, flg_gestione
--    from V_MCRES_APP_ALERT_NEWSOFFDAVAL
--    where cod_stato_raccolta_doc != 4
--    and cod_abi = p_cod_abi
--    order by cod_abi,cod_ndg ;
--
--    cursor c_listr(
--        p_cod_abi t_mcres_app_rapporti.cod_abi%type,
--        p_cod_ndg t_mcres_app_rapporti.cod_ndg%type
--    ) is
--    select distinct cod_uo_rapporto
--    from t_mcres_app_rapporti
--    where cod_abi = p_cod_abi
--    and cod_ndg = p_cod_ndg
--    and dta_chiusura_rapp > SYSDATE
--    and cod_uo_rapporto is not null
--    order by cod_uo_rapporto;
--
--    cursor c_listid is
--        select *
--        from T_MCRES_CL_DOCUMENTI
--        where FLG_CESSIONE_ROUTINARIA = 'S'
--        or FLG_GESTIONE_INTERNA = 'S';
--
--    v_esito number:=ok;
--    V_COD_ABI  T_MCRES_WRK_ACQUISIZIONE.cod_abi%type;
--    v_cod_flusso T_MCRES_WRK_ACQUISIZIONE.cod_flusso%type;
--    v_id_dper T_MCRES_WRK_ACQUISIZIONE.id_dper%type;
--    V_ok number;
--
--begin
--
--    V_NOTE := 'Popolamento workflow - Select ABI=';
--     BEGIN
--        SELECT COD_ABI, cod_flusso, id_dper
--        INTO V_COD_ABI, v_cod_flusso, v_id_dper
--        FROM T_MCRES_WRK_ACQUISIZIONE
--        WHERE ID_FLUSSO = P_REC.SEQ_FLUSSO;
--    EXCEPTION
--        WHEN OTHERS THEN
--            PKG_MCRES_AUDIT.LOG_CARICAMENTI(P_REC.SEQ_FLUSSO,C_NOME,PKG_MCRES_AUDIT.C_ERROR,SQLCODE,SQLERRM,v_note||'ID_FLUSSO = '|| P_REC.SEQ_FLUSSO);
--            return ko;
--    END;
--
--     V_NOTE := 'Popolamento workflow - Select ABI=';
--     BEGIN
--        SELECT count(*)
--        INTO V_ok
--        FROM T_MCRES_WRK_ACQUISIZIONE
--        WHERE cod_flusso in ('PRATICHE','POSIZIONI','RAPPORTI')
--        AND cod_flusso != v_cod_flusso
--        and cod_stato like 'CARICATO%'
--        and id_dper = v_id_dper ;
--    EXCEPTION
--        WHEN OTHERS THEN
--            PKG_MCRES_AUDIT.LOG_CARICAMENTI(P_REC.SEQ_FLUSSO,C_NOME,PKG_MCRES_AUDIT.C_ERROR,SQLCODE,SQLERRM,v_note||'ID_FLUSSO = '|| P_REC.SEQ_FLUSSO);
--            return ko;
--    END;
--
--    if (V_ok=2)then
--                V_NOTE := 'Popolamento workflow - ABI='||V_COD_ABI;
--
--                for rec_list in c_list(V_COD_ABI) loop
--                    for rec_listr in c_listr( rec_list.cod_abi, rec_list.cod_ndg) loop
--                        V_NOTE := 'Popolamento workflow - Abi='|| rec_list.cod_abi||', Ndg='|| rec_list.cod_ndg||', Uo_rapp='|| rec_listr.cod_uo_rapporto;
--                        v_esito := v_esito * pkg_mcres_funzioni_portale.fnc_gestione_raccolta_doc(
--                                                rec_list.cod_abi,
--                                                rec_list.cod_ndg ,
--                                                rec_listr.cod_uo_rapporto ,
--                                               1,
--                                               'BATCH'
--                                         );
--                          commit;
--                     for rec_listid in c_listid loop
--                        if(rec_list.flg_gestione = 'I' and rec_listid.FLG_GESTIONE_INTERNA='S') then
--                            V_NOTE := 'Scheda dod - Gestion Int - Abi='|| rec_list.cod_abi||', Ndg='|| rec_list.cod_ndg||', Uo_rapp='|| rec_listr.cod_uo_rapporto||', Id_doc='|| rec_listid.id_documento;
--                            v_esito := v_esito * pkg_mcres_funzioni_portale.fnc_gestione_scheda_doc(
--                                                                    rec_list.cod_abi,
--                                                                    rec_list.cod_ndg ,
--                                                                    rec_listr.cod_uo_rapporto ,
--                                                                    rec_listid.id_documento,
--                                                                    null,
--                                                                    null,
--                                                                    null,
--                                                                    null ,
--                                                                    null,
--                                                                    'BATCH');
--                           commit;
--                        end if;
--                        if(rec_list.flg_gestione = 'R' and rec_listid.FLG_CESSIONE_ROUTINARIA='S') then
--                            V_NOTE := 'Scheda dod - Cess.Rout. - Abi='|| rec_list.cod_abi||', Ndg='|| rec_list.cod_ndg||', Uo_rapp='|| rec_listr.cod_uo_rapporto||', Id_doc='|| rec_listid.id_documento;
--                            v_esito := v_esito * pkg_mcres_funzioni_portale.fnc_gestione_scheda_doc(
--                                                                    rec_list.cod_abi,
--                                                                    rec_list.cod_ndg ,
--                                                                    rec_listr.cod_uo_rapporto ,
--                                                                    rec_listid.id_documento,
--                                                                    null,
--                                                                    null,
--                                                                    null,
--                                                                    null ,
--                                                                    null,
--                                                                    'BATCH');
--                              commit;
--                        end if;
--                     end loop;
--                    end loop;
--                end loop;
--    end if;
--
--    if (v_esito=ko)then
--        PKG_MCRES_AUDIT.log_caricamenti(P_REC.SEQ_FLUSSO, c_nome, pkg_mcres_audit.c_error, -1, sqlerrm, 'Verificare Audit_APP ' ||  v_note);
--    end if;
--    commit;
--    return v_esito;
--
--EXCEPTION
--  WHEN OTHERS THEN
--    PKG_MCRES_AUDIT.log_caricamenti(P_REC.SEQ_FLUSSO, c_nome, pkg_mcres_audit.c_error, sqlcode, sqlerrm, 'ERRORE ' ||  v_note);
--    return ko;
--
--end fnc_ges_raccolta_doc_step0;

end pkg_mcres_alimentazione;
/


CREATE SYNONYM MCRE_APP.PKG_MCRES_ALIMENTAZIONE FOR MCRE_OWN.PKG_MCRES_ALIMENTAZIONE;


CREATE SYNONYM MCRE_USR.PKG_MCRES_ALIMENTAZIONE FOR MCRE_OWN.PKG_MCRES_ALIMENTAZIONE;


GRANT EXECUTE, DEBUG ON MCRE_OWN.PKG_MCRES_ALIMENTAZIONE TO MCRE_USR;

