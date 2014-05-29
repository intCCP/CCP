CREATE OR REPLACE PACKAGE BODY MCRE_OWN."PKG_MCREI_ALERT" 
AS
   /******************************************************************************
    NAME:       pkg_mcrei_alert
    PURPOSE:

    REVISIONS:
    Ver        Date              Author             Description
    ---------  ----------      -----------------  ------------------------------------
    1.0        31/05/2012         E.Pellizzi         Created this package.
    1.1        27/08/2012         M.Murro            Procedura per Abi con lock
    1.2        24/10/2012         I.Gueorguieva      Procedura generazione query merge
    1.3        25/10/2012         I.Gueorguieva      Query separate per calcolo posizione ed abi
    1.4        20/11/2012         I.Gueorguieva      Truncate(Delete per pos)/Insert per alert 1 e 32
    1.5        9/12/2012           I.Gueorguieva      Chiamata calcola alert per abi agganciabile all'alimentazione MCREI  con log parlante per calcolo tempi
    1.6        12/12/2012         I.Gueorguieva      Aggiunta funzione calcolo ABI per blocchi
    1.7        04/01/2012         I.Gueorguieva      Modifica funzione calcolo Blocco per ABI con controllo sugli ABI arrivati
    1.8        15/05/2013        I.Gueorguieva      No Truncate per le partizioni/sottopartizioni per l'alert 1, 7, 32; calcola in tabella temporanea e merge
   ******************************************************************************/
   FUNCTION fnc_mcrei_calcola_all
      RETURN NUMBER
   IS
      c_nome   CONSTANT VARCHAR2 (100) := c_package || '.FNC_MCREI_CALCOLA_ALL';
      v_esito           NUMBER;
      v_count           NUMBER;
      note              t_mcrei_wrk_audit_caricamenti.note%TYPE := 'GENERALE';
      v_cur_id_alert    number:=0;

      CURSOR c_alert
      IS
         SELECT id_alert, VIEW_CALCOLO, desc_alert
           FROM t_mcrei_app_alert
          WHERE flg_attivo = 'A'
                   OR FLG_ATTIVO = 'T';
   BEGIN
      FOR r_alert IN c_alert  LOOP
         v_esito := fnc_mcrei_calcolo_id (r_alert.id_alert);
         v_cur_id_alert:=r_alert.id_alert;
         IF v_esito = 1 THEN
         note := note||'OK::id_alert '||TO_CHAR(SYSTIMESTAMP,'DD-MM-YYYY HH:MI:SS.FF')||
          ' PER L''ALERT ' || R_ALERT.desc_alert||CHR(10);
         ELSE
            note := note||'ERR:id_alert '||TO_CHAR(SYSTIMESTAMP,'DD-MM-YYYY HH:MI:SS.FF')||
             ' PER L''ALERT '||  R_ALERT.desc_alert||SQLCODE||' '||SQLERRM||' '||CHR(10);
         END IF;
      END LOOP;
      RETURN OK;
   EXCEPTION
      WHEN OTHERS THEN
        pkg_mcrei_audit.log_caricamenti  (v_cur_id_alert,c_nome,pkg_mcrei_alert.c_liv_alert, SQLCODE,SQLERRM, 'FINE ::'||note);
         RETURN ko;
   END fnc_mcrei_calcola_all;

   FUNCTION FNC_MCREI_CALCOLO_BLOCCO(P_ID_BLOCCO IN NUMBER) RETURN NUMBER IS
      C_NOME   CONSTANT     VARCHAR2 (100) := C_PACKAGE || '.FNC_MCREI_CALCOLO_BLOCCO';
      NOTE                  T_MCREI_WRK_AUDIT_CARICAMENTI.NOTE%TYPE := 'GENERALE ';
      V_RET                 NUMBER;
      V_TOT_ABI_CNT         NUMBER:=0;
      V_ABI_TIMBRATI        NUMBER:=0;
      V_ABI_TIMBRATI_PRE    NUMBER:=0;
      V_N_ABI_CALCOLATI       NUMBER:=0;
      V_N_ABI_CALCOLATI_PRE   NUMBER:=0;
      V_CUR_ID_ALERT        NUMBER:=0;
      V_QRY_UPDATE          VARCHAR2(4000);
      V_CALC_BOOL           NUMBER:=0;
      V_NUM_ABI_LAVORATI    NUMBER:=0;
      V_RET_STOR NUMBER;

      CURSOR C_BLOCKS IS
      SELECT ID_ALERT
       FROM T_MCREI_APP_ALERT
      WHERE (FLG_ATTIVO = 'A' OR FLG_ATTIVO = 'T')
        AND COD_BLOCCO = P_ID_BLOCCO
        AND ID_ALERT !=33;

      CURSOR C_ABI_DA_CALC IS
      SELECT COD_ABI
        FROM T_MCREI_WRK_ABI_LAVORATI
      WHERE FLG_STORICO_CALCOLATO = 1
       AND (   DECODE(P_ID_BLOCCO,1,FLG_ALERT_1_CALCOLATO,100) = 0
            OR DECODE(P_ID_BLOCCO,2,FLG_ALERT_2_CALCOLATO,100) = 0
            OR DECODE(P_ID_BLOCCO,3,FLG_ALERT_3_CALCOLATO,100) = 0
            OR DECODE(P_ID_BLOCCO,4,FLG_ALERT_4_CALCOLATO,100) = 0
            OR DECODE(P_ID_BLOCCO,5,FLG_ALERT_5_CALCOLATO,100) = 0
            OR DECODE(P_ID_BLOCCO,6,FLG_ALERT_6_CALCOLATO,100) = 0);

      BEGIN
      IF P_ID_BLOCCO IS NULL AND P_ID_BLOCCO <> 1  AND P_ID_BLOCCO <> 2
      AND P_ID_BLOCCO <> 3 AND P_ID_BLOCCO <> 4 AND P_ID_BLOCCO <> 5 AND
      P_ID_BLOCCO <> 6 THEN
         pkg_mcrei_audit.log_caricamenti  (1000,c_nome,pkg_mcrei_alert.c_liv_alert, SQLCODE,SQLERRM, 'PARAMETRO NON CONFORME P_ID_BLOCCO = '||P_ID_BLOCCO);
         RETURN PKG_MCREI_ALERT.KO;
      END IF;
       NOTE:=NOTE||'CALCOLO BLOCCO: '||P_ID_BLOCCO||CHR(10);
       SELECT COUNT(*)
         INTO V_NUM_ABI_LAVORATI
         FROM T_MCREI_WRK_ABI_LAVORATI;

       SELECT  COUNT(*),
       NVL(SUM(FLG_STORICO_CALCOLATO),0) AS CNT_STORICO,
       NVL(
         SUM(
            CASE WHEN P_ID_BLOCCO = 1 THEN FLG_ALERT_1_CALCOLATO
                 WHEN P_ID_BLOCCO = 2 THEN FLG_ALERT_2_CALCOLATO
                 WHEN P_ID_BLOCCO = 3 THEN FLG_ALERT_3_CALCOLATO
                 WHEN P_ID_BLOCCO = 4 THEN FLG_ALERT_4_CALCOLATO
                 WHEN P_ID_BLOCCO = 5 THEN FLG_ALERT_5_CALCOLATO
                 WHEN P_ID_BLOCCO = 6 THEN FLG_ALERT_6_CALCOLATO

            END
         )
       ,0) AS SUM_ALERT_N
        INTO V_TOT_ABI_CNT, V_ABI_TIMBRATI,
             V_N_ABI_CALCOLATI
       FROM T_MCREI_WRK_ABI_LAVORATI
      WHERE FLG_STORICO_CALCOLATO = 1;
      V_ABI_TIMBRATI_PRE:=-1; -- LA PRIMA VOLTA APRE IL CURSORE
      V_N_ABI_CALCOLATI_PRE:=V_N_ABI_CALCOLATI;
      WHILE V_ABI_TIMBRATI <> V_N_ABI_CALCOLATI OR V_ABI_TIMBRATI = 0 OR V_ABI_TIMBRATI <> V_NUM_ABI_LAVORATI LOOP

      IF V_ABI_TIMBRATI <> V_ABI_TIMBRATI_PRE OR V_N_ABI_CALCOLATI <> V_N_ABI_CALCOLATI_PRE  THEN
        V_ABI_TIMBRATI_PRE:=V_ABI_TIMBRATI;
        FOR R_ABI_DA_CALC IN C_ABI_DA_CALC LOOP
            V_CALC_BOOL:=0;
            FOR  R_BLOCKS IN C_BLOCKS LOOP
                V_RET:=FNC_MCREI_CALC_ID_ABI(R_BLOCKS.ID_ALERT,R_ABI_DA_CALC.COD_ABI);
                V_CUR_ID_ALERT:=R_BLOCKS.ID_ALERT;
                V_CALC_BOOL:=1; --HA CALCOLATO QUALCOSA, NON CONTROLLO I SINGOLI VALORI DI RITORNO VEDI LOG
            END LOOP;
            IF V_CALC_BOOL = 1 THEN
                NOTE:=NOTE||'OK::ID_ALERT '||V_CUR_ID_ALERT||' ABI '||R_ABI_DA_CALC.COD_ABI||CHR(10);
                V_QRY_UPDATE:='UPDATE T_MCREI_WRK_ABI_LAVORATI
                         SET FLG_ALERT_'||TO_CHAR(P_ID_BLOCCO)||'_CALCOLATO= 1,
                         DTA_UPD = SYSDATE
                         WHERE COD_ABI = :1';
                EXECUTE IMMEDIATE V_QRY_UPDATE USING R_ABI_DA_CALC.COD_ABI ;
                COMMIT;
            END IF;
            V_N_ABI_CALCOLATI_PRE:=V_N_ABI_CALCOLATI_PRE+1;
        END LOOP;
      END IF;
       SELECT  COUNT(*),
       NVL(SUM(FLG_STORICO_CALCOLATO),0) AS CNT_STORICO,
       NVL(
         SUM(
            CASE WHEN P_ID_BLOCCO = 1 THEN FLG_ALERT_1_CALCOLATO
                 WHEN P_ID_BLOCCO = 2 THEN FLG_ALERT_2_CALCOLATO
                 WHEN P_ID_BLOCCO = 3 THEN FLG_ALERT_3_CALCOLATO
                 WHEN P_ID_BLOCCO = 4 THEN FLG_ALERT_4_CALCOLATO
                 WHEN P_ID_BLOCCO = 5 THEN FLG_ALERT_5_CALCOLATO
                 WHEN P_ID_BLOCCO = 6 THEN FLG_ALERT_6_CALCOLATO

            END
         )
       ,0) AS SUM_ALERT_N
        INTO V_TOT_ABI_CNT, V_ABI_TIMBRATI,
             V_N_ABI_CALCOLATI
       FROM T_MCREI_WRK_ABI_LAVORATI
      WHERE FLG_STORICO_CALCOLATO = 1;
      IF V_ABI_TIMBRATI = V_ABI_TIMBRATI_PRE AND V_ABI_TIMBRATI !=V_NUM_ABI_LAVORATI THEN
         DBMS_LOCK.SLEEP(300); -- DORMI PER 5 MIN
      END IF;
      END LOOP;

      IF  P_ID_BLOCCO = 5 then
        v_ret_stor:= MCRE_OWN.PKG_MCREI_ALIMENTA_STORICO_DEL.FNC_STORICIZZA_DELIB_DAILY;
        v_ret_stor:= MCRE_OWN.PKG_MCREI_ALIMENTA_STORICO_DEL.FNC_ALIMENTA_STORICO;
      end if;

      RETURN PKG_MCREI_ALERT.OK;
      EXCEPTION WHEN OTHERS THEN
        ROLLBACK;
        pkg_mcrei_audit.log_caricamenti  (v_cur_id_alert,c_nome,pkg_mcrei_alert.c_liv_alert, SQLCODE,SQLERRM, 'FINE ::'||note);
        RETURN PKG_MCREI_ALERT.KO;
      END FNC_MCREI_CALCOLO_BLOCCO;
   FUNCTION fnc_mcrei_calcolo_id(p_id_alert IN NUMBER)
      RETURN NUMBER  IS
      c_nome   CONSTANT VARCHAR2 (100)
                                   := c_package || '.fnc_mcrei_calcolo_id';
      v_qry_calcolo     t_mcrei_alert_alim_wrk_bk.qry_calcolo_alert%TYPE;
      v_qry_insert_tmp  t_mcrei_alert_alim_wrk_bk.qry_insert_tmp%type;
      note              t_mcrei_wrk_audit_caricamenti.note%TYPE := 'GENERALE';
      v_desc_alert      t_mcrei_app_alert.desc_alert%TYPE;
   BEGIN
      SELECT qry_calcolo_alert, desc_alert, qry_insert_tmp
        INTO v_qry_calcolo, v_desc_alert, v_qry_insert_tmp
        FROM t_mcrei_alert_alim_wrk_bk al, t_mcrei_app_alert an
       WHERE al.id_alert = p_id_alert AND al.id_alert = an.id_alert
         AND (AN.FLG_ATTIVO = 'A'
          OR AN.FLG_ATTIVO = 'T');
       NOTE:='INI:id_alert '||P_ID_ALERT||' '||TO_CHAR(SYSTIMESTAMP,'DD-MM-YYYY HH:MI:SS.FF')
         || ' PER L''ALERT ' ||v_desc_alert||CHR(10);
      pkg_mcrei_audit.log_caricamenti  (p_id_alert,c_nome,pkg_mcrei_alert.c_liv_alert, SQLCODE,SQLERRM, note);
       CASE WHEN p_id_alert in (1, 7, 32)  THEN
         EXECUTE IMMEDIATE to_char(v_qry_insert_tmp);
       ELSE NULL;
       END CASE;
     EXECUTE IMMEDIATE TO_CHAR (v_qry_calcolo);
     COMMIT;
      note := note||'OK::id_alert '||P_ID_ALERT||' '||TO_CHAR(SYSTIMESTAMP,'DD-MM-YYYY HH:MI:SS.FF')
         || ' PER L''ALERT ' ||v_desc_alert||CHR(10);
      pkg_mcrei_audit.log_caricamenti  (p_id_alert,c_nome,pkg_mcrei_alert.c_liv_alert, SQLCODE,SQLERRM, note);
      RETURN ok;
   EXCEPTION
      WHEN OTHERS THEN
      ROLLBACK;
     note := note||'ERR:id_alert '||P_ID_ALERT||' '||TO_CHAR(SYSTIMESTAMP,'DD-MM-YYYY HH:MI:SS.FF')
         || ' PER L''ALERT ' ||v_desc_alert|| CHR(10);
      pkg_mcrei_audit.log_caricamenti  (p_id_alert,c_nome,pkg_mcrei_alert.c_liv_alert, SQLCODE,SQLERRM, note);
     RETURN ko;
   END fnc_mcrei_calcolo_id;

   FUNCTION fnc_mcrei_calcolo_id_pos (
      p_id_alert   IN   NUMBER,
      p_cod_abi    IN   VARCHAR2,
      p_cod_ndg    IN   VARCHAR2
   )
      RETURN NUMBER
   IS
      c_nome   CONSTANT VARCHAR2 (100)   := c_package || '.fnc_mcrei_calcolo_id_pos';
      v_qry_upd_pos     t_mcrei_alert_alim_wrk_bk.qry_upd_alert%TYPE;
      v_qry_insert_tmp  t_mcrei_alert_alim_wrk_bk.qry_insert_tmp%type;
      v_dta_rilevazione DATE;      
      note              t_mcrei_wrk_audit_caricamenti.note%TYPE := 'INIZIO::';
      v_desc_alert      t_mcrei_app_alert.desc_alert%TYPE;
      v_qry_executed    BOOLEAN:=false;


   BEGIN
      SELECT qry_upd_alert, qry_insert_tmp, desc_alert
        INTO v_qry_upd_pos, v_qry_insert_tmp, v_desc_alert
        FROM t_mcrei_alert_alim_wrk_bk al, t_mcrei_app_alert an
       WHERE al.id_alert = p_id_alert AND al.id_alert = an.id_alert;
         note := note||'IN::id_alert '||P_ID_ALERT||' '||TO_CHAR(SYSTIMESTAMP,'DD-MM-YYYY HH:MI:SS.FF')||' ' || p_cod_abi|| '/'|| p_cod_ndg
         || ' PER L''ALERT ' ||v_desc_alert||CHR(10);
         CASE
         WHEN P_ID_ALERT in (1,7,32) THEN
         
           BEGIN
            SELECT dta_ins
              INTO v_dta_rilevazione
              FROM t_mcrei_app_alert_pos_wrk
            WHERE COD_ABI = P_COD_ABI
              AND COD_NDG = P_COD_NDG
              AND ID_ALERT = P_ID_ALERT;
           EXCEPTION WHEN NO_DATA_FOUND THEN 
            v_dta_rilevazione:=SYSDATE;
           END;
           DELETE t_mcrei_app_alert_pos_wrk
           WHERE id_alert = p_id_alert
             AND cod_abi = p_cod_abi
             AND cod_ndg = p_cod_ndg;
           EXECUTE IMMEDIATE TO_CHAR (v_qry_upd_pos) USING v_dta_rilevazione, p_cod_abi, p_cod_ndg;
           v_qry_executed:=TRUE;
         ELSE NULL;
         END CASE;
     
     IF NOT v_qry_executed THEN
        EXECUTE IMMEDIATE TO_CHAR (v_qry_upd_pos) USING p_cod_abi, p_cod_ndg;
     END IF;
     note := note||'OK::id_alert '||P_ID_ALERT||' '||TO_CHAR(SYSTIMESTAMP,'DD-MM-YYYY HH:MI:SS.FF')||' ' || p_cod_abi|| '/'|| p_cod_ndg
      || ' PER L''ALERT ' ||v_desc_alert||CHR(10);
     pkg_mcrei_audit.log_app (c_nome,pkg_mcrei_audit.c_debug, SQLCODE,SQLERRM, note, NULL);
     RETURN ok;
   EXCEPTION
      WHEN OTHERS
      THEN
      note := 'ERR:id_alert '||P_ID_ALERT||' '||TO_CHAR(SYSTIMESTAMP,'DD-MM-YYYY HH:MI:SS.FF')||' '|| p_cod_abi || '/'|| p_cod_ndg
      || ' PER L''ALERT '|| v_desc_alert||SQLCODE||' '||SQLERRM||' '||CHR(10);
      pkg_mcrei_audit.log_app (c_nome,pkg_mcrei_audit.c_debug, SQLCODE,SQLERRM, note, NULL);
      RETURN ko;
   END fnc_mcrei_calcolo_id_pos;

   FUNCTION fnc_mcrei_calc_pos (p_cod_abi IN VARCHAR2,p_cod_ndg IN VARCHAR2) RETURN NUMBER IS
      c_nome   CONSTANT VARCHAR2 (100) := c_package || '.fnc_mcrei_calc_pos';
      v_esito           NUMBER;
      v_count           NUMBER;
      note              t_mcrei_wrk_audit_caricamenti.note%TYPE := 'GENERALE';
  P_QRY VARCHAR2(32767);
CURSOR c_alert
      IS
         SELECT ID_ALERT, VIEW_CALCOLO, DESC_ALERT
           FROM t_mcrei_app_alert
          WHERE (flg_attivo = 'A'
            OR FLG_ATTIVO = 'T');
   BEGIN
      FOR r_alert IN c_alert
      LOOP
         v_esito := fnc_mcrei_calcolo_id_pos (r_alert.id_alert,p_cod_abi,p_cod_ndg);
      END LOOP;
     pkg_mcrei_audit.log_app (c_nome,pkg_mcrei_audit.c_debug, SQLCODE,SQLERRM, note, NULL);
      RETURN OK;
   EXCEPTION
      WHEN OTHERS
      THEN
         pkg_mcrei_audit.log_app (c_nome,pkg_mcrei_audit.c_debug, SQLCODE,SQLERRM, note, NULL);
         RETURN ko;
   END fnc_mcrei_calc_pos;

   FUNCTION FNC_MCREI_CALC_ABI (P_REC IN F_SLAVE_PAR_TYPE)
      RETURN NUMBER
   IS
      C_NOME   CONSTANT VARCHAR2 (100) := C_PACKAGE || '.FNC_MCREI_CALCOLA_ABI';
      V_ESITO                   NUMBER;
      V_COUNT                   NUMBER;
      NOTE                          T_MCREI_WRK_AUDIT_CARICAMENTI.NOTE%TYPE := 'GENERALE';
      V_LOCK_RESULT         NUMBER;
      V_LOCKHANDLE          VARCHAR2 (200);
      V_QRY_ALERT_ABI       t_mcrei_alert_alim_wrk_bk.QRY_ALERT_ABI%TYPE;
      P_COD_ABI                 VARCHAR2(5);

CURSOR c_alert
      IS
         SELECT ID_ALERT, VIEW_CALCOLO, DESC_ALERT
           FROM T_MCREI_APP_ALERT
          WHERE (FLG_ATTIVO = 'A'
                OR FLG_ATTIVO = 'T')
         ORDER BY ID_ALERT;
   BEGIN
--        BEGIN
--        SELECT COD_ABI
--          INTO P_COD_ABI
--          FROM T_MCREI_WRK_ACQUISIZIONE
--        WHERE ID_FLUSSO = p_rec.SEQ_FLUSSO;
--        EXCEPTION WHEN OTHERS THEN
--        P_COD_ABI:= NULL;
--        END;
--        note:='INIZIO::'||'Calcolo alert per abi '||p_cod_abi||' '||TO_CHAR(SYSTIMESTAMP,'DD-MM-YYYY HH24:MI:SS.FF')||chr(10);
--        pkg_mcrei_audit.log_caricamenti  (p_rec.seq_flusso,c_nome,pkg_mcrei_alert_2.c_liv_alert, SQLCODE,SQLERRM, 'FINE ::'||note);
--       IF P_COD_ABI IS NOT NULL THEN
--        FOR r_alert IN c_alert LOOP
--          BEGIN
--              SELECT QRY_ALERT_ABI
--                INTO V_QRY_ALERT_ABI
--                FROM t_mcrei_alert_alim_wrk_bk
--              WHERE ID_ALERT = R_ALERT.ID_ALERT;
--
--           CASE WHEN r_alert.id_alert = 1 THEN
--             EXECUTE IMMEDIATE 'ALTER TABLE T_MCREI_APP_ALERT_POS_WRK TRUNCATE SUBPARTITION INC_P01_'||P_COD_ABI;
--            WHEN r_alert.id_alert = 32 THEN
--              EXECUTE IMMEDIATE 'ALTER TABLE T_MCREI_APP_ALERT_POS_WRK TRUNCATE SUBPARTITION INC_P32_'||P_COD_ABI;
--           END CASE;
--          EXECUTE IMMEDIATE TO_CHAR(V_QRY_ALERT_ABI) USING P_COD_ABI;
--          COMMIT;
--          NOTE :=NOTE||'OK ::id_alert '||LPAD(R_ALERT.ID_ALERT,3)||' '||TO_CHAR(SYSTIMESTAMP,'DD-MM-YYYY HH24:MI:SS.FF')||' '||R_ALERT.DESC_ALERT||CHR(10);
--          EXCEPTION WHEN OTHERS THEN
--          ROLLBACK;
--          NOTE:=NOTE||'ERR::id_alert '||LPAD(R_ALERT.ID_ALERT,3)||' '||TO_CHAR(SYSTIMESTAMP,'DD-MM-YYYY HH24:MI:SS.FF')||' '|| R_ALERT.DESC_ALERT||' '||SQLCODE||' '||SQLERRM||' '||CHR(10);
--          END;
--          END LOOP;
--       END IF;
    pkg_mcrei_audit.log_caricamenti (p_rec.seq_flusso,c_nome,pkg_mcrei_alert.c_liv_alert, SQLCODE,SQLERRM, 'FINE ::'||note);
    RETURN OK;
   EXCEPTION
      WHEN OTHERS THEN
        ROLLBACK;
       pkg_mcrei_audit.log_caricamenti  (p_rec.seq_flusso,c_nome,pkg_mcrei_alert.c_liv_alert, SQLCODE,SQLERRM, 'FINE ::'||note);
      RETURN ko;
   END fnc_mcrei_calc_abi;
FUNCTION FNC_MCREI_CALC_ID_ABI (p_id_alert IN NUMBER, P_COD_ABI IN VARCHAR2)RETURN NUMBER
   IS
      c_nome   constant varchar2 (100) := c_package || '.FNC_MCREI_CALC_ID_ABI';
      v_esito                   number;
      v_count                   number;
      note                          t_mcrei_wrk_audit_caricamenti.note%type := 'GENERALE';
      v_lock_result         number;
      v_lockhandle          varchar2 (200);
      v_qry_alert_abi       t_mcrei_alert_alim_wrk_bk.qry_alert_abi%type;
      v_qry_insert_tmp_abi  t_mcrei_alert_alim_wrk_bk.qry_insert_tmp_abi%type;
      v_desc_alert          t_mcrei_app_alert.desc_alert%type;
      v_cod_blocco          t_mcrei_app_alert.cod_blocco%type:=0;

   BEGIN
      note:='INIZIO::Calcolo alert '||p_id_alert||' per abi '||p_cod_abi||' '||TO_CHAR(SYSTIMESTAMP,'DD-MM-YYYY HH24:MI:SS.FF')||chr(10);
      
      select w.qry_alert_abi, w.qry_insert_tmp_abi, a.desc_alert, a.cod_blocco
        into v_qry_alert_abi, v_qry_insert_tmp_abi, v_desc_alert, v_cod_blocco
        from t_mcrei_alert_alim_wrk_bk w, t_mcrei_app_alert a
      where w.id_alert = p_id_alert
        and w.id_alert = a.id_alert
        and (a.flg_attivo = 'A'
          or a.flg_attivo = 'T');
      
      pkg_mcrei_audit.log_caricamenti  (((100*v_cod_blocco+p_id_alert)*100000+to_number(p_cod_abi)),c_nome,pkg_mcrei_alert.c_liv_alert, sqlcode,sqlerrm, note);

       CASE WHEN p_id_alert IN (1,7,32) THEN
        EXECUTE IMMEDIATE to_char(v_qry_insert_tmp_abi) USING P_COD_ABI;
        ELSE NULL;
       END CASE;
       EXECUTE IMMEDIATE TO_CHAR(V_QRY_ALERT_ABI) USING P_COD_ABI;
       COMMIT;
       NOTE :=NOTE||'OK ::id_alert '||LPAD(p_id_alert,3)||' '||TO_CHAR(SYSTIMESTAMP,'DD-MM-YYYY HH24:MI:SS.FF')||' '||V_DESC_ALERT||CHR(10);
       pkg_mcrei_audit.log_caricamenti  ((100*V_COD_BLOCCO+p_id_alert)*100000+TO_NUMBER(P_COD_ABI),c_nome,pkg_mcrei_alert.c_liv_alert, SQLCODE,SQLERRM, note);
   RETURN OK;
   EXCEPTION
      WHEN OTHERS THEN
        ROLLBACK;
        NOTE:=NOTE||'ERR::id_alert '||LPAD(P_ID_ALERT,3)||' '||TO_CHAR(SYSTIMESTAMP,'DD-MM-YYYY HH24:MI:SS.FF')||' '|| v_desc_alert||' '||SQLCODE||' '||SQLERRM||' '||CHR(10);
      pkg_mcrei_audit.log_caricamenti  ((100*V_COD_BLOCCO+p_id_alert)*100000+TO_NUMBER(P_COD_ABI),c_nome,pkg_mcrei_alert.c_liv_alert, SQLCODE,SQLERRM, note);
      RETURN ko;
   END fnc_mcrei_calc_id_abi;

PROCEDURE PRC_MCREI_GEN_QUERY(
P_ID_ALERT IN NUMBER,
P_ABI IN VARCHAR2 DEFAULT NULL,
P_NDG IN VARCHAR2 DEFAULT NULL,
P_QRY OUT VARCHAR2) IS

V_VISTA_WRK         T_MCREI_APP_ALERT.VIEW_CALCOLO%TYPE;
V_ID_ALERT_DA_ESP   T_MCREI_APP_ALERT.ID_ALERT_DA_ESPORRE%TYPE;
V_LPAD_ID           VARCHAR2(2);
V_LPAD_ID_DA_ESP    VARCHAR2(2);
V_QRY_USING_1       VARCHAR2(32767):=NULL;
V_QRY_USING_2       VARCHAR2(32767):=NULL;
V_INSERT_1          VARCHAR2(32767):=NULL;
V_INSERT_2          VARCHAR2(32767):=NULL;
V_UPDATE            VARCHAR2(32767):=NULL;
V_ALERT_NO_VAL      VARCHAR2(30);
CURSOR CCOL
IS
SELECT COLUMN_NAME, FLG_UPD_FIELD
 FROM T_MCREI_WRK_ALERT_MERG_COLMNS
WHERE FLG_ATTIVO = 1;

BEGIN
    SELECT VIEW_CALCOLO, ID_ALERT_DA_ESPORRE
    INTO V_VISTA_WRK, V_ID_ALERT_DA_ESP
      FROM T_MCREI_APP_ALERT
      WHERE ID_ALERT= P_ID_ALERT;
    V_LPAD_ID:= LPAD(TO_CHAR(P_ID_ALERT), 2,'0');
    V_LPAD_ID_DA_ESP:=LPAD(TO_CHAR(V_ID_ALERT_DA_ESP), 2,'0');


    FOR RCOL IN CCOL LOOP
    IF RCOL.COLUMN_NAME='VAL_ALERT' THEN
    V_ALERT_NO_VAL:='ALERT';
    ELSE
    V_ALERT_NO_VAL:=RCOL.COLUMN_NAME;
    END IF;
    V_QRY_USING_1:=V_QRY_USING_1||'A.'||RCOL.COLUMN_NAME||',';
    V_QRY_USING_2:=V_QRY_USING_2||'P.'||V_ALERT_NO_VAL||',';
    V_INSERT_1:=V_INSERT_1||'T.'||V_ALERT_NO_VAL||',';
    V_INSERT_2:=V_INSERT_2||'S.'||RCOL.COLUMN_NAME||',';
    IF RCOL.FLG_UPD_FIELD='1' THEN
    V_UPDATE:=V_UPDATE||'T.'||V_ALERT_NO_VAL||'='||'S.'||RCOL.COLUMN_NAME||',';
    END IF;
    END LOOP;

    P_QRY:='MERGE INTO   t_mcrei_app_alert_pos_wrk PARTITION (INC_P'||V_LPAD_ID||') t USING ';
    IF P_ABI IS NOT NULL THEN
    P_QRY:=P_QRY||'(SELECT S1.* FROM '||CHR(13) || CHR(10);
    END IF;
    P_QRY:=P_QRY||'(SELECT '||CHR(13) || CHR(10)||
                    V_QRY_USING_1||
                    '1 FLG '||CHR(13) || CHR(10)||
                    'FROM  '||V_VISTA_WRK||' a, t_mcrei_app_alert_pos_wrk PARTITION (INC_P'||V_LPAD_ID||') p'||CHR(13) || CHR(10)||
                    'WHERE   a.cod_abi = p.cod_abi(+) AND a.cod_ndg = p.cod_ndg(+)'||CHR(13) || CHR(10)||
                     'UNION SELECT '||CHR(13) || CHR(10)||
                    V_QRY_USING_2||'0 FLG '||CHR(13) || CHR(10)||
                    'FROM '||V_VISTA_WRK||' a, t_mcrei_app_alert_pos_wrk PARTITION (INC_P'||V_LPAD_ID||') p'||CHR(13) || CHR(10)||
                     'WHERE   a.cod_abi(+) = p.cod_abi AND a.cod_ndg(+) = p.cod_ndg AND a.cod_ndg IS NULL)';
    IF P_ABI IS NOT NULL THEN
      P_QRY:=P_QRY||'S1
               WHERE   S1.COD_ABI='||':v_cod_abi';
      IF P_NDG IS NULL THEN
            P_QRY:=P_QRY||')';
      ELSE
            P_QRY:=P_QRY||' AND S1.COD_NDG='||':v_cod_ndg'||')';
      END IF;
    END IF;
    P_QRY:=P_QRY||' S'||CHR(13) || CHR(10)||
                ' ON (t.cod_abi = s.cod_abi AND t.cod_ndg = s.cod_ndg)'|| CHR(13) || CHR(10)||
                'WHEN MATCHED THEN UPDATE SET '|| CHR(13) || CHR(10)||
                V_UPDATE||'T.DTA_UPD = SYSDATE,T.ID_ALERT_DA_ESPORRE = '||V_LPAD_ID_DA_ESP|| CHR(13) || CHR(10)||
                'DELETE WHERE   s.flg = 0'|| CHR(13) || CHR(10)||
                'WHEN NOT MATCHED THEN INSERT('|| CHR(13) || CHR(10)||
                V_INSERT_1||'T.DTA_INS,T.ID_ALERT, T.ID_ALERT_DA_ESPORRE)'||CHR(13) || CHR(10)||
                'VALUES('||CHR(13) || CHR(10)||
                V_INSERT_2||'SYSDATE,'||TO_CHAR(P_ID_ALERT)||','||V_LPAD_ID_DA_ESP||')';

END;
PROCEDURE PRC_GEN_QUERY_IN_TAB IS
    CURSOR CIDA IS SELECT
    A1.ID_ALERT FROM t_mcrei_alert_alim_wrk_bk A1,
    T_MCREI_APP_ALERT A
    WHERE A.ID_ALERT = A1.ID_ALERT
    AND A.FLG_ATTIVO='A';
    P_QRY VARCHAR2(32767);
    BEGIN
    FOR RIDA IN CIDA LOOP
        PRC_MCREI_GEN_QUERY(RIDA.ID_ALERT, NULL, NULL,P_QRY);
        UPDATE t_mcrei_alert_alim_wrk_bk
        SET QRY_CALCOLO_ALERT=P_QRY
        WHERE ID_ALERT = RIDA.ID_ALERT;
        COMMIT;
         PRC_MCREI_GEN_QUERY(RIDA.ID_ALERT, 'A', NULL,P_QRY);
        UPDATE t_mcrei_alert_alim_wrk_bk
        SET QRY_ALERT_ABI=P_QRY
        WHERE ID_ALERT = RIDA.ID_ALERT;
        COMMIT;
       PRC_MCREI_GEN_QUERY(RIDA.ID_ALERT, 'A', 'N',P_QRY);
        UPDATE t_mcrei_alert_alim_wrk_bk
        SET  QRY_UPD_ALERT =P_QRY
        WHERE ID_ALERT = RIDA.ID_ALERT;
        COMMIT;
    END LOOP;
    END;
END pkg_mcrei_alert;
/


CREATE SYNONYM MCRE_APP.PKG_MCREI_ALERT FOR MCRE_OWN.PKG_MCREI_ALERT;


CREATE SYNONYM MCRE_USR.PKG_MCREI_ALERT FOR MCRE_OWN.PKG_MCREI_ALERT;


GRANT EXECUTE, DEBUG ON MCRE_OWN.PKG_MCREI_ALERT TO MCRE_USR;

