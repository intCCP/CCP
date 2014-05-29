CREATE OR REPLACE PACKAGE BODY MCRE_OWN.pkg_mcrei_check_controlli
AS
/******************************************************************************
   NAME:       PKG_MCRES_CHECK_CONTROLLI
   PURPOSE:    Implementazione controlli automatici

   REVISIONS:
   Ver        Date        Author           Description
   ---------  ----------  ---------------  ------------------------------------
   1.0        04/12/2012  E.Pellizzi        Created this package.
******************************************************************************/
   PROCEDURE num_flussi_giornalieri (
      p_pid         IN       NUMBER,
      p_cod_check   IN       VARCHAR2,
      p_id_dper              DATE,
      p_ret_value   OUT      NUMBER,
      p_result      OUT      VARCHAR2,
      p_notes       OUT      VARCHAR2,
      p_ok                   VARCHAR2,
      p_ko                   VARCHAR2
   )
   IS
      v_count   NUMBER;
      v_exp     NUMBER;
      --INC0000001
   BEGIN
      SELECT COUNT (*)
        INTO v_count
        FROM t_mcreI_wrk_acquisizione
       WHERE 0 = 0
         AND id_dper = p_id_dper
         AND cod_flusso != 'SISBA';

      v_exp :=  pkg_mcre0_check_engine.get_exp_value_threshold (p_cod_check, 'EXP');

      IF (v_count != v_exp)
      THEN
         p_result := p_ko;
         p_notes :=
               'La numerosità dei flussi giornalieri non corrisponde al valore atteso '
            || v_exp
            || '.';
      ELSE
         p_result := p_ok;
         p_notes :=
               'La numerosità dei flussi giornalieri corrisponde al valore atteso '
            || v_exp
            || '.';
      END IF;

      p_ret_value := v_count;
   END;

   PROCEDURE num_flussi_mensili_sisba (
      p_pid         IN       NUMBER,
      p_cod_check   IN       VARCHAR2,
      p_id_dper              DATE,
      p_ret_value   OUT      NUMBER,
      p_result      OUT      VARCHAR2,
      p_notes       OUT      VARCHAR2,
      p_ok                   VARCHAR2,
      p_ko                   VARCHAR2
   )
   IS
      v_count   NUMBER;
      v_min     NUMBER;
      v_max     NUMBER;
      v_exp     NUMBER;
      --INC0000002  
   BEGIN
      SELECT COUNT (*)
        INTO v_count
        FROM t_mcrei_wrk_acquisizione
       WHERE 0 = 0
         AND dta_inizio >=p_id_dper
         AND cod_flusso = 'SISBA'
         AND id_dper = LAST_DAY (ADD_MONTHS (TRUNC (SYSDATE), -1));

      v_min := pkg_mcre0_check_engine.get_exp_value_threshold (p_cod_check, 'CMP01');
      v_max := pkg_mcre0_check_engine.get_exp_value_threshold (p_cod_check, 'CMP02');
      v_exp := pkg_mcre0_check_engine.get_exp_value_threshold (p_cod_check, 'EXP');

      IF (    v_count != v_exp
          AND TO_NUMBER (TO_CHAR (CURRENT_DATE, 'DD')) BETWEEN v_min AND v_max
         )
      THEN
         p_result := p_ko;
         p_notes :=
               'La numerosità dei flussi mensili SISBA non corrisponde al valore atteso '
            || v_exp
            || '.';
      ELSIF (v_count = v_exp)
      THEN
         p_result := p_ok;
         p_notes :=
               'La numerosità dei flussi mensili SISBA corrisponde al valore atteso '
            || v_exp
            || '.';
      ELSE
         p_result := p_ko;
         p_notes :=
               'La numerosità dei flussi mensili SISBA attualmente risulta pari a '
            || v_count
            || '. Il valore atteso dal controllo nel periodo dal '
            || v_min
            || ' al '
            || v_max
            || ' del mese corrente è di '
            || v_exp
            || '.';
      END IF;

      p_ret_value := v_count;
   END;

  PROCEDURE abi_lavorabili (
      p_pid         IN       NUMBER,
      p_cod_check   IN       VARCHAR2,
      p_id_dper              DATE,
      p_ret_value   OUT      NUMBER,
      p_result      OUT      VARCHAR2,
      p_notes       OUT      VARCHAR2,
      p_ok                   VARCHAR2,
      p_ko                   VARCHAR2
   )
   IS
      v_count   NUMBER;
      v_exp     NUMBER;
      v_cod_abi VARCHAR2(500);
      --INC0000003
   BEGIN
    
     SELECT COUNT (*)
        INTO v_count
        FROM t_mcrei_wrk_abi_lavorati
       WHERE 0 = 0
         AND FLG_ABI_LAVORATO = 1 ;
         

 
      v_exp := pkg_mcre0_check_engine.get_exp_value_threshold (p_cod_check, 'EXP');

      IF ( v_count != v_exp )
      THEN
                 p_result := p_ko;
         
         FOR I IN (SELECT cod_abi 
                   from  t_mcrei_wrk_abi_lavorati
                  WHERE 0 = 0
                  AND FLG_ABI_LAVORATO = 0 )
         
         loop
         v_cod_abi := v_cod_abi|| i.cod_abi ||' - ' ;       
         end loop;
         p_notes :=
               'Gli abi : '|| v_cod_abi ||' non sono lavorabili.';
      ELSE
         p_result := p_ok;
         p_notes := 'Tutti gli abi sono lavorabili.';
         
      END IF;

       p_ret_value := v_count;

   END;

   PROCEDURE flussi_elaborati_errore (
      p_pid         IN       NUMBER,
      p_cod_check   IN       VARCHAR2,
      p_id_dper              DATE,
      p_ret_value   OUT      NUMBER,
      p_result      OUT      VARCHAR2,
      p_notes       OUT      VARCHAR2,
      p_ok                   VARCHAR2,
      p_ko                   VARCHAR2
   )
   IS
      v_count   NUMBER;
      v_exp     NUMBER;
      --INC0000004      
   BEGIN
      INSERT INTO T_MCREI_CHECK_INC0000004
                  (pid, cod_flusso, cod_abi, procedura, sql_code, MESSAGE,
                   note, dta_ins)
          select p_pid, a.COD_FLUSSO, a.COD_ABI, b.PROCEDURA,b.MESSAGE,b.NOTE,b.SQL_CODE,b.DTA_INS
          FROM t_mcrei_wrk_acquisizione a,
          t_mcrei_wrk_audit_caricamenti b
    WHERE dta_inizio IS NOT NULL
      AND dta_fine IS NOT NULL
      AND a.id_flusso = b.id_flusso
      AND a.cod_stato IS NULL
      AND sql_code NOT IN (0, 100, -29913, -942)
      and a.id_dper = p_id_dper;
    

      v_exp :=
           pkg_mcre0_check_engine.get_exp_value_threshold (p_cod_check, 'EXP');

      SELECT COUNT (*)
        INTO v_count
        FROM T_MCREI_CHECK_INC0000004
       WHERE pid = p_pid;

      IF (v_count != v_exp)
      THEN
         p_result := p_ko;
         p_notes :=
               'Sono presenti '
            || v_count
            || ' flussi elaborati in errore (Vedi Tab. T_MCREI_CHECK_INC0000004).';
      ELSE
         p_result := p_ok;
         p_notes := 'Non sono presenti flussi elaborati in errore.';
      END IF;

      p_ret_value := v_count;
      COMMIT;
   END;
   
   
 

   PROCEDURE flussi_abi (
      p_pid         IN       NUMBER,
      p_cod_check   IN       VARCHAR2,
      p_id_dper              DATE,
      p_ret_value   OUT      NUMBER,
      p_result      OUT      VARCHAR2,
      p_notes       OUT      VARCHAR2,
      p_ok                   VARCHAR2,
      p_ko                   VARCHAR2
   )
   IS
      v_count   NUMBER;
      v_exp     NUMBER;
   --INC0000005 
   BEGIN
   
    EXECUTE IMMEDIATE 'TRUNCATE TABLE T_MCREI_CHECK_INC0000005';
    
      INSERT INTO T_MCREI_CHECK_INC0000005  
                  (pid, id_dper, cod_flusso, cod_abi, cod_stato, dta_inizio,
                   dta_fine, val_scarti_convert, val_scarti_vincoli)
         SELECT   p_pid, id_dper, flusso, abi, desc_caricamento, dta_inizio,
                  dta_fine, val_scarti_convert, val_scarti_vincoli
             FROM (    SELECT   dipendenza || '-' || NVL (cod_abi, 'MULTI') cod_dipendenza,
            NVL (cod_abi, 'MULTI') abi, flusso, periodo_contr id_dper,
            dta_inizio, dta_fine,
            (dta_fine - dta_inizio) * 24 * 60 * 60 AS "TEMPO LOAD FLUSSO sec",
              (max_per_abi - min_per_abi)
            * 24
            * 60
            * 60 AS "TEMPO TOT LOAD ABI sec",
            val_scarti_convert, val_scarti_vincoli,
            CASE
               WHEN flusso = 'SISBA'
               AND periodo_contr <> LAST_DAY (periodo_contr)
                  THEN NVL (desc_caricamento,
                               'CARICAMENTO PREVISTO PER IL '
                            || TO_CHAR (LAST_DAY (periodo_contr), 'YYYYMMDD')
                           )
               ELSE NVL (desc_caricamento, 'FLUSSO MANCANTE')
            END desc_caricamento
       FROM (SELECT f.cod_abi, flusso, id_dper, f.dipendenza, dta_inizio,
                    dta_fine,
                    MIN (dta_inizio) OVER (PARTITION BY f.cod_abi, dipendenza, id_dper)
                                                                  min_per_abi,
                    MAX (dta_fine) OVER (PARTITION BY f.cod_abi, dipendenza, id_dper)
                                                                  max_per_abi,
                    desc_caricamento, periodo_contr, val_scarti_convert,
                    val_scarti_vincoli
               FROM (SELECT q.id_flusso, q.cod_flusso, q.cod_abi, q.id_dper,
                            q.dta_inizio, q.dta_fine,
                            CASE
                               WHEN (   q.cod_flusso = 'GGRATE'
                                     OR q.cod_flusso = 'RAPPORTI_ESTERO'
                                     OR q.cod_flusso = 'LIFA'
                                     OR q.cod_flusso LIKE ' PROPOSTE_MOPLE_0%'
                                    )
                               AND q.cod_stato = 'CARICATO'
                                  THEN 'SUCCESS: CARICAMENTO OK'
                               ELSE c.desc_caricamento
                            END desc_caricamento,
                            q.val_scarti_convert, q.val_scarti_vincoli
                       FROM v_mcrei_wrk_check_caricamenti c,
                            t_mcrei_wrk_acquisizione q
                      WHERE c.id_flusso(+) = q.id_flusso AND q.cod_stato(+) =
                                                                    'CARICATO') a,
                    (SELECT cod_abi, flusso, dipendenza, periodo_contr
                       FROM t_mcrei_wrk_anag_flussi,
                            (SELECT max(id_dper) periodo_contr
                               FROM t_mcrei_wrk_acquisizione
                               where id_dper = p_id_dper)
                      WHERE flusso NOT LIKE 'SISBA%') f
              WHERE NVL (a.cod_abi(+), 'MULTI') = NVL (f.cod_abi, 'MULTI')
                AND a.cod_flusso(+) = f.flusso
                AND a.id_dper(+) = periodo_contr));

      v_exp :=
           pkg_mcre0_check_engine.get_exp_value_threshold (p_cod_check, 'EXP');

      SELECT COUNT (*)
        INTO v_count
        FROM T_MCREI_CHECK_INC0000005
       WHERE pid = p_pid 
         AND cod_stato NOT LIKE 'SUCCESS: CARICAMENTO OK';

      IF (v_count != v_exp)
      THEN
         p_result := p_ko;
         p_notes :=
               'Sono presenti '
            || v_count
            || ' flussi non caricati';
      ELSE
         p_result := p_ok;
         p_notes := 'Tutti i flussi sono stati caricati.';
      END IF;

      p_ret_value := v_count;
      COMMIT;
   END;
PROCEDURE CONSISTENZA_DB (P_PID IN NUMBER, P_COD_CHECK IN VARCHAR2, P_ID_DPER DATE, P_RET_VALUE OUT NUMBER, P_RESULT OUT VARCHAR2, P_NOTES OUT VARCHAR2, P_OK VARCHAR2, P_KO VARCHAR2, P_VIEW VARCHAR2) IS

v_count       NUMBER;
v_threshold   NUMBER;

BEGIN

EXECUTE IMMEDIATE 'INSERT INTO T_MCREI_CHECK_INCCONSDB0 (PID, COD_CHECK, REC) SELECT :1, :2, REC FROM ' || P_VIEW USING P_PID, P_COD_CHECK;

SELECT COUNT(*) 
  INTO v_count
  FROM
    T_MCREI_CHECK_INCCONSDB0
 WHERE 0 = 0
   AND PID = P_PID
   AND COD_CHECK = P_COD_CHECK;

v_threshold := PKG_MCRE0_CHECK_ENGINE.GET_EXP_VALUE_THRESHOLD(P_COD_CHECK, 'CHECK', v_count);

IF (v_threshold = 1) THEN

P_RESULT := p_ok;

P_NOTES := v_count || ' records (Vedi Tab. T_MCREI_CHECK_INCCONSDB0).';

ELSE

P_RESULT := p_ko;

P_NOTES := v_count || ' records (Vedi Tab. T_MCREI_CHECK_INCCONSDB0).';

END IF;

P_RET_VALUE := v_count;

END;
END pkg_mcrei_check_controlli;
/


CREATE SYNONYM MCRE_APP.PKG_MCREI_CHECK_CONTROLLI FOR MCRE_OWN.PKG_MCREI_CHECK_CONTROLLI;


CREATE SYNONYM MCRE_USR.PKG_MCREI_CHECK_CONTROLLI FOR MCRE_OWN.PKG_MCREI_CHECK_CONTROLLI;


GRANT EXECUTE, DEBUG ON MCRE_OWN.PKG_MCREI_CHECK_CONTROLLI TO MCRE_USR;

