CREATE OR REPLACE PACKAGE BODY MCRE_OWN.PKG_MCRE0_GEST_POS AS
/******************************************************************************
   NAME:       PKG_MCRE0_GEST_POS
   PURPOSE:  funzioni per pagina sintesi della gestione posizione in stato IN, RIO, SC

   REVISIONS:
   Ver        Date        Author           Description
   ---------  ----------  ---------------  ------------------------------------
   1.0        21/01/2013  I.gueorguieva    Created this package.
   1.1        10/06/2013  M.Murro          Aggiunte procedure RWA
   1.2        26/06/2013  M.Murro          Aggiunte procedure gest PDF
******************************************************************************/

-- %usage  Function di INSERT, UPDATE, DELETE su T_MCRE0_APP_GEST_ADVISOR
-- %d tabella di log T_MCRE0_WRK_AUDIT_APPLICATIVO
-- %param P_AZIONE I -> INSERT, U -> UPDATE, D -> DELETE LOGICA
-- %param P_COD_ADVISOR viene sovrascritto solo se P_AZIONE = I con il nuovo codice advisor generato, altrimenti non viene sovrascritto
-- %return 1 -> se l'azione e' andata a buon fine, 0 altrimenti
   FUNCTION FNC_GEST_ADVISOR_IUD(P_AZIONE      IN VARCHAR2, --OBBLIGATORIO
                               P_COD_ADVISOR            IN OUT T_MCRE0_APP_GEST_ADVISOR.COD_ADVISOR%TYPE,--OBBLIGATORIO
                               P_COD_MATRICOLA          IN T_MCRE0_WRK_AUDIT_APPLICATIVO.UTENTE%TYPE,
                               P_ID_ADVISOR_CONSULENZA  IN T_MCRE0_APP_GEST_ADVISOR.ID_ADVISOR_CONSULENZA%TYPE DEFAULT NULL,
                               P_ID_ADVISOR_GR_GESTIONE IN T_MCRE0_APP_GEST_ADVISOR.ID_ADVISOR_GR_GESTIONE%TYPE DEFAULT NULL,
                               P_ID_ADVISOR_GR_ISP      IN T_MCRE0_APP_GEST_ADVISOR.ID_ADVISOR_GR_ISP%TYPE DEFAULT NULL,
                               P_COD_ABI_CARTOLARIZZATO IN T_MCRE0_APP_GEST_ADVISOR.COD_ABI_CARTOLARIZZATO%TYPE DEFAULT NULL,
                               p_COD_NDG                IN T_MCRE0_APP_GEST_ADVISOR.COD_NDG%TYPE DEFAULT NULL,
                               P_COD_SNDG               IN T_MCRE0_APP_GEST_ADVISOR.COD_SNDG%TYPE DEFAULT NULL,
                               P_COD_MACROSTATO         IN T_MCRE0_APP_GEST_ADVISOR.COD_MACROSTATO%TYPE DEFAULT NULL
                               )RETURN NUMBER IS
    V_SEQ              NUMBER;
    V_NOTE             T_MCRE0_WRK_AUDIT_APPLICATIVO.NOTE%TYPE;
    V_PROC             T_MCRE0_WRK_AUDIT_APPLICATIVO.PROCEDURA%TYPE:=PKG_MCRE0_GEST_POS.C_PACKAGE||'.FNC_GEST_ADVISOR_IUD';
    V_NEW_ID_ADVISOR   NUMBER;
    V_COD_ADVISOR      T_MCRE0_APP_GEST_ADVISOR.COD_ADVISOR%TYPE:=NULL;
    V_COD_STATO_RISCHIO   T_MCRE0_APP_ALL_DATA.COD_STATO%TYPE;


BEGIN
  V_NOTE:='P_AZIONE = '||P_AZIONE||', P_COD_ABI_CARTOLARIZZATO = '||P_COD_ABI_CARTOLARIZZATO||
  ', P_COD_NDG = '||P_COD_NDG||'P_COD_SNDG = '||P_COD_SNDG||', P_COD_ADVISOR = '||P_COD_ADVISOR||
  ', P_COD_MACROSTATO = '||P_COD_MACROSTATO||CHR(10);
  SELECT seq_mcr0_log_app.nextval INTO v_seq FROM dual;
  IF P_AZIONE IS NULL OR P_AZIONE NOT IN ('I','U','D','i','u','d') THEN
        raise_application_error(-20666, 'Null or illegal parameter');
  END IF;

  CASE WHEN P_AZIONE IN ('I','i') THEN
    IF P_COD_ABI_CARTOLARIZZATO IS NULL  OR P_COD_NDG IS NULL OR P_COD_MACROSTATO NOT IN ('IN','RIO','SC')
    THEN
        raise_application_error(-20666, 'Null or illegal parameter');
    END IF;
      SELECT COD_STATO
        INTO V_COD_STATO_RISCHIO
        FROM T_MCRE0_APP_ALL_DATA
       WHERE COD_ABI_CARTOLARIZZATO = P_COD_ABI_CARTOLARIZZATO
         AND COD_NDG = P_COD_NDG
         AND ROWNUM = 1;
    SELECT MCRE0_SEQ_GEST_ADVISOR.NEXTVAL
      INTO V_NEW_ID_ADVISOR
      FROM DUAL;
    V_COD_ADVISOR:=P_COD_ABI_CARTOLARIZZATO||P_COD_NDG||LPAD(TO_CHAR(V_NEW_ID_ADVISOR),11,'0');
    INSERT INTO T_MCRE0_APP_GEST_ADVISOR(
    COD_ABI_CARTOLARIZZATO, COD_NDG, COD_SNDG,
    ID_ADVISOR_CONSULENZA, ID_ADVISOR_GR_GESTIONE,
    ID_ADVISOR_GR_ISP, COD_STATO_RISCHIO, DTA_INS,
    COD_ADVISOR, COD_MACROSTATO
    )
    VALUES(
      P_COD_ABI_CARTOLARIZZATO, P_COD_NDG, P_COD_SNDG,
      P_ID_ADVISOR_CONSULENZA, P_ID_ADVISOR_GR_GESTIONE,
      P_ID_ADVISOR_GR_ISP, V_COD_STATO_RISCHIO, SYSDATE,
      V_COD_ADVISOR, P_COD_MACROSTATO
    );
    P_COD_ADVISOR:= V_COD_ADVISOR;
    V_NOTE:=V_NOTE||P_COD_ADVISOR||' GENERATO'||CHR(10);
  WHEN P_AZIONE IN ('U','u') THEN
  BEGIN
   SELECT AD.COD_STATO
     INTO V_COD_STATO_RISCHIO
     FROM T_MCRE0_APP_ALL_DATA AD, T_MCRE0_APP_GEST_ADVISOR ADV
    WHERE  ADV.COD_ADVISOR = P_COD_ADVISOR
       AND ADV.COD_ABI_CARTOLARIZZATO = AD.COD_ABI_CARTOLARIZZATO
       AND ADV.COD_NDG = AD.COD_NDG
       AND ROWNUM = 1;
   EXCEPTION WHEN NO_DATA_FOUND THEN
   V_COD_STATO_RISCHIO:=NULL;
   V_NOTE:=V_NOTE||'SELECT AD.COD_STATO
     INTO V_COD_STATO_RISCHIO
     FROM T_MCRE0_APP_ALL_DATA AD, T_MCRE0_APP_GEST_ADVISOR ADV
    WHERE  ADV.COD_ADVISOR = P_COD_ADVISOR
       AND ADV.COD_ABI = AD.COD_ABI_CARTOLARIZZATO
       AND ADV.COD_NDG = AD.COD_NDG
       AND ROWNUM = 1'||CHR(10)||'L''UPDATE VERRA'' ESEGUITA CON COD_STATO_RISCHIO=NULL COD_MACROSTATO=NULL';
   PKG_MCRE0_AUDIT.LOG_APP(V_SEQ, C_PACKAGE, 3, SQLCODE,SQLERRM, V_NOTE, P_COD_MATRICOLA);
  END;
    UPDATE T_MCRE0_APP_GEST_ADVISOR
       SET
            ID_ADVISOR_CONSULENZA    = P_ID_ADVISOR_CONSULENZA,
            ID_ADVISOR_GR_GESTIONE   = P_ID_ADVISOR_GR_GESTIONE,
            ID_ADVISOR_GR_ISP        = P_ID_ADVISOR_GR_ISP,
            COD_STATO_RISCHIO        = V_COD_STATO_RISCHIO,
            DTA_UPD                  = SYSDATE
    WHERE COD_ADVISOR = P_COD_ADVISOR;
  WHEN P_AZIONE IN ('D','d') THEN
    UPDATE T_MCRE0_APP_GEST_ADVISOR
      SET  FLG_DELETE = 'Y',
           DTA_DELETE = SYSDATE,
           DTA_UPD = SYSDATE
    WHERE COD_ADVISOR = P_COD_ADVISOR;
  ELSE
     raise_application_error(-20666, 'Null or illegal parameter');
  END CASE;
    PKG_MCRE0_AUDIT.LOG_APP(V_SEQ, V_PROC, 3, SQLCODE,SQLERRM,V_NOTE, P_COD_MATRICOLA);
  RETURN PKG_MCRE0_GEST_POS.OK;
  EXCEPTION WHEN OTHERS THEN
    PKG_MCRE0_AUDIT.LOG_APP(V_SEQ, V_PROC, 3, SQLCODE,SQLERRM, V_NOTE, P_COD_MATRICOLA);
    RETURN PKG_MCRE0_GEST_POS.KO;
  END FNC_GEST_ADVISOR_IUD;

-- %usage  Function di UPDATE di T_MCRE0_APP_GEST_POSIZIONE durante il workflow
-- %d tabella di log T_MCRE0_WRK_AUDIT_APPLICATIVO
-- %return 1 -> se l'aggiornamento e' andata a buon fine, 0 altrimenti
   FUNCTION FNC_GEST_POSIZIONE_UWF(P_COD_ABI_CARTOLARIZZATO IN T_MCRE0_APP_GEST_POSIZIONE.COD_ABI_CARTOLARIZZATO%TYPE,
                                   P_COD_NDG                IN T_MCRE0_APP_GEST_POSIZIONE.COD_NDG%TYPE,
                                   P_COD_MACROSTATO         IN T_MCRE0_APP_GEST_POSIZIONE.COD_MACROSTATO%TYPE,
                                   P_FLG_WORKFLOW           IN T_MCRE0_APP_GEST_POSIZIONE.FLG_WORKFLOW%TYPE,
                                   P_COD_MATRICOLA          IN T_MCRE0_WRK_AUDIT_APPLICATIVO.UTENTE%TYPE,
                                   P_DTA_UPD_WORKFLOW       IN T_MCRE0_APP_GEST_POSIZIONE.DTA_UPD_WORKFLOW%TYPE DEFAULT NULL)
                           RETURN NUMBER IS
    V_NOTE             T_MCRE0_WRK_AUDIT_APPLICATIVO.NOTE%TYPE;
    V_PROC             T_MCRE0_WRK_AUDIT_APPLICATIVO.PROCEDURA%TYPE:=PKG_MCRE0_GEST_POS.C_PACKAGE||'.FNC_GEST_POSIZIONE_UWF';
    V_SEQ              NUMBER;
    BEGIN
        V_NOTE:='P_COD_ABI_CARTOLARIZZATO = '||P_COD_ABI_CARTOLARIZZATO||
      ', P_COD_NDG = '||P_COD_NDG||'P_COD_MATRICOLA = '||P_COD_MATRICOLA||', P_FLG_WORKFLOW = '||P_FLG_WORKFLOW
      ||', P_DTA_UPD_WORKFLOW = '||P_DTA_UPD_WORKFLOW||CHR(10);

        SELECT seq_mcr0_log_app.nextval INTO v_seq FROM dual;
        UPDATE T_MCRE0_APP_GEST_POSIZIONE
           SET FLG_WORKFLOW = P_FLG_WORKFLOW,
               DTA_UPD_WORKFLOW = NVL(P_DTA_UPD_WORKFLOW, DTA_UPD_WORKFLOW)
         WHERE COD_ABI_CARTOLARIZZATO = P_COD_ABI_CARTOLARIZZATO
           AND COD_NDG                = P_COD_NDG
           AND COD_MACROSTATO         = P_COD_MACROSTATO;

        PKG_MCRE0_AUDIT.LOG_APP(V_SEQ, V_PROC, 3, SQLCODE,SQLERRM,V_NOTE, P_COD_MATRICOLA);
        RETURN PKG_MCRE0_GEST_POS.OK;
    EXCEPTION WHEN OTHERS THEN
        PKG_MCRE0_AUDIT.LOG_APP(V_SEQ, V_PROC, 3, SQLCODE,SQLERRM, V_NOTE, P_COD_MATRICOLA);
        RETURN PKG_MCRE0_GEST_POS.KO;
    END FNC_GEST_POSIZIONE_UWF;


-- %usage  Function di INSERT di T_MCRE0_APP_GEST_POSIZIONE
-- %d tabella di log T_MCRE0_WRK_AUDIT_APPLICATIVO
-- %return 1 -> se l'insert e' andata a buon fine, 0 altrimenti
       FUNCTION FNC_GEST_POSIZIONE_INR(P_COD_ABI_CARTOLARIZZATO IN T_MCRE0_APP_GEST_POSIZIONE.COD_ABI_CARTOLARIZZATO%TYPE,
                                       P_COD_NDG                IN T_MCRE0_APP_GEST_POSIZIONE.COD_NDG%TYPE,
                                       P_COD_MACROSTATO         IN T_MCRE0_APP_GEST_POSIZIONE.COD_MACROSTATO%TYPE,
                                       P_COD_SNDG               IN T_MCRE0_APP_GEST_POSIZIONE.COD_SNDG%TYPE,
                                       P_COD_STATO_RISCHIO      IN T_MCRE0_APP_GEST_POSIZIONE.COD_STATO_RISCHIO%TYPE,--microstato della posizione
                                       P_COD_MATRICOLA          IN T_MCRE0_WRK_AUDIT_APPLICATIVO.UTENTE%TYPE
                                      )
                           RETURN NUMBER IS
    V_NOTE             T_MCRE0_WRK_AUDIT_APPLICATIVO.NOTE%TYPE;
    V_PROC             T_MCRE0_WRK_AUDIT_APPLICATIVO.PROCEDURA%TYPE:=PKG_MCRE0_GEST_POS.C_PACKAGE||'.FNC_GEST_POSIZIONE_INR';
    V_SEQ              NUMBER;
    V_COUNT            NUMBER;
    BEGIN
        V_NOTE:='P_COD_ABI_CARTOLARIZZATO = '||P_COD_ABI_CARTOLARIZZATO||
                ', P_COD_NDG = '||P_COD_NDG||
                ', P_COD_SNDG = '||P_COD_SNDG||
                ', P_COD_MACROSTATO = '||P_COD_MACROSTATO||
                ', P_COD_MATRICOLA = '||P_COD_MATRICOLA||
                ', P_COD_STATO_RISCHIO = '||P_COD_STATO_RISCHIO||CHR(10);

        SELECT seq_mcr0_log_app.nextval INTO v_seq FROM dual;

        SELECT COUNT(*)
          INTO V_COUNT
          FROM T_MCRE0_APP_GEST_POSIZIONE
         WHERE COD_ABI_CARTOLARIZZATO = P_COD_ABI_CARTOLARIZZATO
           AND COD_NDG = P_COD_NDG
           AND COD_SNDG = P_COD_SNDG
           AND COD_MACROSTATO = P_COD_MACROSTATO
           AND FLG_DELETE = 'Y';

        IF V_COUNT = 1
        THEN
          DELETE T_MCRE0_APP_GEST_POSIZIONE
           WHERE COD_ABI_CARTOLARIZZATO = P_COD_ABI_CARTOLARIZZATO
             AND COD_NDG = P_COD_NDG
             AND COD_SNDG = P_COD_SNDG
             AND COD_MACROSTATO = P_COD_MACROSTATO
             AND FLG_DELETE = 'Y';
        END IF;

        INSERT INTO T_MCRE0_APP_GEST_POSIZIONE(COD_ABI_CARTOLARIZZATO,
                                               COD_NDG,
                                               COD_MACROSTATO,
                                               COD_SNDG,
                                               COD_STATO_RISCHIO,
                                               FLG_LETTURA_VERBALE,
                                               FLG_DELETE,
                                               FLG_WORKFLOW,
                                               DTA_INS
                                               )
                                       VALUES(P_COD_ABI_CARTOLARIZZATO,
                                               P_COD_NDG,
                                               P_COD_MACROSTATO,
                                               P_COD_SNDG,
                                               P_COD_STATO_RISCHIO,
                                               'N',
                                               'N',
                                               '0',
                                               SYSDATE
                                       );

        PKG_MCRE0_AUDIT.LOG_APP(V_SEQ, V_PROC, 3, SQLCODE,SQLERRM,V_NOTE, P_COD_MATRICOLA);
        RETURN PKG_MCRE0_GEST_POS.OK;
    EXCEPTION WHEN OTHERS THEN
        PKG_MCRE0_AUDIT.LOG_APP(V_SEQ, V_PROC, 3, SQLCODE,SQLERRM, V_NOTE, P_COD_MATRICOLA);
        RETURN PKG_MCRE0_GEST_POS.KO;
    END FNC_GEST_POSIZIONE_INR;


-- %usage  Function di UPDATE di T_MCRE0_APP_GEST_POSIZIONE per il BOX CLASSIFICAZIONE
-- %d tabella di log T_MCRE0_WRK_AUDIT_APPLICATIVO
-- %return 1 -> se l'aggiornamento e' andata a buon fine, 0 altrimenti
       FUNCTION FNC_GEST_POSIZIONE_UBC(P_COD_ABI_CARTOLARIZZATO IN T_MCRE0_APP_GEST_POSIZIONE.COD_ABI_CARTOLARIZZATO%TYPE,
                                       P_COD_NDG                IN T_MCRE0_APP_GEST_POSIZIONE.COD_NDG%TYPE,
                                       P_COD_MACROSTATO         IN T_MCRE0_APP_GEST_POSIZIONE.COD_MACROSTATO%TYPE,
                                       P_COD_MACROSTATO_DESTINAZIONE   IN T_MCRE0_APP_GEST_POSIZIONE.COD_MACROSTATO_DESTINAZIONE%TYPE,
                                       P_NOTE_CLASSIFICAZIONE          IN T_MCRE0_APP_GEST_POSIZIONE.NOTE_CLASSIFICAZIONE%TYPE,
                                       P_FLG_LETTURA_VERBALE           IN T_MCRE0_APP_GEST_POSIZIONE.FLG_LETTURA_VERBALE%TYPE,
                                       P_COD_MATRICOLA                 IN T_MCRE0_WRK_AUDIT_APPLICATIVO.UTENTE%TYPE
                                      )
                           RETURN NUMBER IS
    V_NOTE             T_MCRE0_WRK_AUDIT_APPLICATIVO.NOTE%TYPE;
    V_PROC             T_MCRE0_WRK_AUDIT_APPLICATIVO.PROCEDURA%TYPE:=PKG_MCRE0_GEST_POS.C_PACKAGE||'.FNC_GEST_POSIZIONE_UBC';
    V_SEQ              NUMBER;
    BEGIN
        V_NOTE:='P_COD_ABI_CARTOLARIZZATO = '||P_COD_ABI_CARTOLARIZZATO||
                ', P_COD_NDG = '||P_COD_NDG||
                ', P_COD_MACROSTATO = '||P_COD_MACROSTATO||
                ', P_COD_MACROSTATO_DESTINAZIONE = '||P_COD_MACROSTATO_DESTINAZIONE||
                ', P_NOTE_CLASSIFICAZIONE  = '||P_NOTE_CLASSIFICAZIONE ||
                ', P_FLG_LETTURA_VERBALE  = '||P_NOTE_CLASSIFICAZIONE ||
                ', P_COD_MATRICOLA  = '||P_NOTE_CLASSIFICAZIONE ||CHR(10);

        SELECT seq_mcr0_log_app.nextval INTO v_seq FROM dual;

        UPDATE T_MCRE0_APP_GEST_POSIZIONE
           SET COD_MACROSTATO_DESTINAZIONE = P_COD_MACROSTATO_DESTINAZIONE,
               NOTE_CLASSIFICAZIONE = P_NOTE_CLASSIFICAZIONE,
               FLG_LETTURA_VERBALE = P_FLG_LETTURA_VERBALE,
               DTA_UPD_BC = SYSDATE
         WHERE COD_ABI_CARTOLARIZZATO = P_COD_ABI_CARTOLARIZZATO
           AND COD_NDG                = P_COD_NDG
           AND COD_MACROSTATO         = P_COD_MACROSTATO;

        PKG_MCRE0_AUDIT.LOG_APP(V_SEQ, V_PROC, 3, SQLCODE,SQLERRM,V_NOTE, P_COD_MATRICOLA);
        RETURN PKG_MCRE0_GEST_POS.OK;
    EXCEPTION WHEN OTHERS THEN
        PKG_MCRE0_AUDIT.LOG_APP(V_SEQ, V_PROC, 3, SQLCODE,SQLERRM, V_NOTE, P_COD_MATRICOLA);
        RETURN PKG_MCRE0_GEST_POS.KO;
    END FNC_GEST_POSIZIONE_UBC;


-- %usage  Function di INSERT, DELETE su T_MCRE0_APP_GEST_ANOMALIE
-- %d tabella di log T_MCRE0_WRK_AUDIT_APPLICATIVO
-- %param P_AZIONE I -> INSERT, D -> DELETE LOGICA
-- %param P_COD_ANOMALIA viene sovrascritto solo se P_AZIONE = I con il nuovo codice anomalia generato, altrimenti non viene sovrascritto
-- %return 1 -> se l'azione e' andata a buon fine, 0 altrimenti
   FUNCTION FNC_GEST_ANOMALIA_ID(P_AZIONE      IN VARCHAR2, --OBBLIGATORIO
                               P_COD_ANOMALIA            IN OUT T_MCRE0_APP_GEST_ANOMALIE.COD_ANOMALIA%TYPE,--OBBLIGATORIO
                               P_COD_MATRICOLA          IN T_MCRE0_WRK_AUDIT_APPLICATIVO.UTENTE%TYPE,
                               P_COD_ABI_CARTOLARIZZATO IN T_MCRE0_APP_GEST_ANOMALIE.COD_ABI_CARTOLARIZZATO%TYPE DEFAULT NULL,
                               p_COD_NDG                IN T_MCRE0_APP_GEST_ANOMALIE.COD_NDG%TYPE DEFAULT NULL,
                               P_COD_SNDG               IN T_MCRE0_APP_GEST_ANOMALIE.COD_SNDG%TYPE DEFAULT NULL,
                               P_DESC_ANOMALIA          IN T_MCRE0_APP_GEST_ANOMALIE.DESC_ANOMALIA%TYPE DEFAULT NULL,
                               P_FLG_GRUPPO_ECONOMICO   IN T_MCRE0_APP_GEST_ANOMALIE.FLG_GRUPPO_ECONOMICO%TYPE DEFAULT NULL,
                               P_COD_MACROSTATO         IN T_MCRE0_APP_GEST_ANOMALIE.COD_MACROSTATO%TYPE DEFAULT NULL
                               )RETURN NUMBER IS
    V_SEQ              NUMBER;
    V_NOTE             T_MCRE0_WRK_AUDIT_APPLICATIVO.NOTE%TYPE;
    V_PROC             T_MCRE0_WRK_AUDIT_APPLICATIVO.PROCEDURA%TYPE:=PKG_MCRE0_GEST_POS.C_PACKAGE||'.FNC_GEST_ANOMALIA_ID';
    V_NEW_COD_ANOMALIA   NUMBER;
    V_COD_ANOMALIA      T_MCRE0_APP_GEST_ANOMALIE.COD_ANOMALIA%TYPE:=NULL;
    V_COD_STATO_RISCHIO   T_MCRE0_APP_ALL_DATA.COD_STATO%TYPE;

BEGIN
  V_NOTE:='P_AZIONE = '||P_AZIONE||', P_COD_ABI_CARTOLARIZZATO = '||P_COD_ABI_CARTOLARIZZATO||
  ', P_COD_NDG = '||P_COD_NDG||'P_COD_SNDG = '||P_COD_SNDG||', P_COD_ANOMALIA = '||P_COD_ANOMALIA||CHR(10);

  SELECT seq_mcr0_log_app.nextval INTO v_seq FROM dual;
  IF P_AZIONE IS NULL OR P_AZIONE NOT IN ('I','D','i','d') THEN
        raise_application_error(-20666, 'Null or illegal parameter');
  END IF;

  CASE WHEN P_AZIONE IN ('I','i') THEN
    IF P_COD_ABI_CARTOLARIZZATO IS NULL  OR P_COD_NDG IS NULL OR P_COD_MACROSTATO NOT IN ('IN','RIO','SC')
    THEN
        raise_application_error(-20666, 'Null or illegal parameter');
    END IF;

      SELECT COD_STATO
        INTO V_COD_STATO_RISCHIO
        FROM T_MCRE0_APP_ALL_DATA
       WHERE COD_ABI_CARTOLARIZZATO = P_COD_ABI_CARTOLARIZZATO
         AND COD_NDG = P_COD_NDG
         AND ROWNUM = 1;

    SELECT MCRE0_SEQ_GEST_ANOMALIE.NEXTVAL
      INTO V_NEW_COD_ANOMALIA
      FROM DUAL;

    V_COD_ANOMALIA:=P_COD_ABI_CARTOLARIZZATO||P_COD_NDG||LPAD(TO_CHAR(V_NEW_COD_ANOMALIA),11,'0');

    INSERT INTO T_MCRE0_APP_GEST_ANOMALIE(
    COD_ABI_CARTOLARIZZATO, COD_NDG, COD_SNDG,
    DESC_ANOMALIA,FLG_GRUPPO_ECONOMICO,
    COD_ANOMALIA,COD_STATO_RISCHIO,COD_MACROSTATO,DTA_INS,FLG_DELETE)
    VALUES(
    P_COD_ABI_CARTOLARIZZATO, P_COD_NDG, P_COD_SNDG,
    P_DESC_ANOMALIA,P_FLG_GRUPPO_ECONOMICO,
    V_COD_ANOMALIA,V_COD_STATO_RISCHIO,P_COD_MACROSTATO,SYSDATE,'N'
    );
    P_COD_ANOMALIA:= V_COD_ANOMALIA;
    V_NOTE:=V_NOTE||P_COD_ANOMALIA||' GENERATO'||CHR(10);
  WHEN P_AZIONE IN ('D','d') THEN
    UPDATE T_MCRE0_APP_GEST_ANOMALIE
      SET  FLG_DELETE = 'Y',
           DTA_DELETE = SYSDATE
    WHERE COD_ANOMALIA = P_COD_ANOMALIA;
  ELSE
     raise_application_error(-20666, 'Null or illegal parameter');
  END CASE;


    PKG_MCRE0_AUDIT.LOG_APP(V_SEQ, V_PROC, 3, SQLCODE,SQLERRM,V_NOTE, P_COD_MATRICOLA);
  RETURN PKG_MCRE0_GEST_POS.OK;
  EXCEPTION WHEN OTHERS THEN
    PKG_MCRE0_AUDIT.LOG_APP(V_SEQ, V_PROC, 3, SQLCODE,SQLERRM, V_NOTE, P_COD_MATRICOLA);
    RETURN PKG_MCRE0_GEST_POS.KO;
  END FNC_GEST_ANOMALIA_ID;

-- %usage  Function di INSERT, UPDATE, DELETE su T_MCRE0_APP_GEST_PRATICA_FASI
-- %d tabella di log T_MCRE0_WRK_AUDIT_APPLICATIVO
-- %param P_IUD I -> INSERT, U -> UPDATE, D -> DELETE LOGICA
-- %param COD_PRAT_FASE viene sovrascritto solo se P_IUD = I con il nuovo codice pratica generato, altrimenti non viene sovrascritto
-- %return 1 -> se l'azione e' andata a buon fine, 0 altrimenti
FUNCTION FNC_GEST_PRAT_FAS_IUD(P_IUD IN VARCHAR2,
                               P_COD_PRAT_FASE          IN OUT T_MCRE0_APP_GEST_PRATICA_FASI.COD_PRAT_FASE%TYPE,
                               P_COD_MATRICOLA          IN T_MCRE0_WRK_AUDIT_APPLICATIVO.UTENTE%TYPE,
                               P_ID_TIPOLOGIA_PRATICA   IN T_MCRE0_APP_GEST_PRATICA_FASI.ID_TIPOLOGIA_PRATICA%TYPE,
                               P_ID_FASE_GESTIONE       IN T_MCRE0_APP_GEST_PRATICA_FASI.ID_FASE_GESTIONE%TYPE,
                               P_DTA_SCADENZA           IN T_MCRE0_APP_GEST_PRATICA_FASI.DTA_SCADENZA%TYPE,
                               P_FLG_ESITO_POSITIVO     IN T_MCRE0_APP_GEST_PRATICA_FASI.FLG_ESITO_POSITIVO%TYPE,
                               P_FLG_COMPLETATA         IN T_MCRE0_APP_GEST_PRATICA_FASI.FLG_COMPLETATA%TYPE,
                               P_NOTE                   IN T_MCRE0_APP_GEST_PRATICA_FASI.NOTE%TYPE,
                               P_COD_ABI_CARTOLARIZZATO IN T_MCRE0_APP_GEST_PRATICA_FASI.COD_ABI_CARTOLARIZZATO%TYPE,
                               P_COD_NDG                IN T_MCRE0_APP_GEST_PRATICA_FASI.COD_NDG%TYPE,
                               P_COD_SNDG               IN T_MCRE0_APP_GEST_PRATICA_FASI.COD_SNDG %TYPE,
                               P_COD_MACROSTATO         IN T_MCRE0_APP_GEST_PRATICA_FASI.COD_MACROSTATO%TYPE DEFAULT NULL) RETURN NUMBER IS
    V_SEQ               NUMBER;
    V_NOTE               T_MCRE0_WRK_AUDIT_APPLICATIVO.NOTE%TYPE;
    V_PROC               T_MCRE0_WRK_AUDIT_APPLICATIVO.PROCEDURA%TYPE:=PKG_MCRE0_GEST_POS.C_PACKAGE||'.FNC_GEST_PRAT_FAS_IUD';
    V_NEW_ID_PRAT_FASE   NUMBER;
    V_COD_PRAT           T_MCRE0_APP_GEST_PRATICA_FASI.COD_PRAT_FASE%TYPE:=NULL;
    V_COD_STATO_RISCHIO  T_MCRE0_APP_ALL_DATA.COD_STATO%TYPE;

BEGIN
  V_NOTE:='P_IUD = '||P_IUD||', P_COD_PRAT_FASE = '||P_COD_PRAT_FASE||
  ', P_COD_MATRICOLA = '||P_COD_MATRICOLA||'P_ID_TIPOLOGIA_PRATICA = '||P_ID_TIPOLOGIA_PRATICA||', P_ID_FASE_GESTIONE = '||P_ID_FASE_GESTIONE||
  ', P_DTA_SCADENZA = '||P_DTA_SCADENZA||', P_FLG_ESITO_POSITIVO ='||P_FLG_ESITO_POSITIVO
  ||', P_FLG_COMPLETATA = '||P_FLG_COMPLETATA||', P_NOTE = '||P_NOTE||
  ', P_COD_ABI_CARTOLARIZZATO = '||P_COD_ABI_CARTOLARIZZATO||
  ', P_COD_NDG= '||P_COD_NDG||
  ', P_COD_SNDG'||P_COD_SNDG||
  ', P_COD_MACROSTATO'||P_COD_MACROSTATO|| CHR(10);
  SELECT seq_mcr0_log_app.nextval INTO v_seq FROM dual;
  IF P_IUD IS NULL OR P_IUD NOT IN ('I','U','D','i','u','d') THEN
        raise_application_error(-20666, 'Null or illegal parameter');
  END IF;
  CASE WHEN P_IUD IN ('I','i') THEN
    IF P_COD_ABI_CARTOLARIZZATO IS NULL  OR P_COD_NDG IS NULL OR P_COD_MACROSTATO NOT IN('IN','RIO','SC')
    THEN
        raise_application_error(-20666, 'Null or illegal parameter');
    END IF;
      SELECT COD_STATO
        INTO V_COD_STATO_RISCHIO
        FROM T_MCRE0_APP_ALL_DATA
       WHERE COD_ABI_CARTOLARIZZATO = P_COD_ABI_CARTOLARIZZATO
         AND COD_NDG = P_COD_NDG
         AND ROWNUM = 1;
    SELECT MCRE0_SEQ_GEST_PRAT.NEXTVAL
      INTO V_NEW_ID_PRAT_FASE
      FROM DUAL;
    V_COD_PRAT:=P_COD_ABI_CARTOLARIZZATO||P_COD_NDG||LPAD(TO_CHAR(V_NEW_ID_PRAT_FASE),11,'0');
    V_NOTE:=V_NOTE||P_IUD||' GENERATO'||CHR(10);
    P_COD_PRAT_FASE:=V_COD_PRAT;
    INSERT INTO T_MCRE0_APP_GEST_PRATICA_FASI(
    COD_PRAT_FASE, COD_ABI_CARTOLARIZZATO, COD_NDG,
    ID_TIPOLOGIA_PRATICA, ID_FASE_GESTIONE, ID_AZIONE,
    DTA_INS, DTA_UPD, DTA_SCADENZA, COD_STATO_RISCHIO,
    COD_MACROSTATO, FLG_ESITO_POSITIVO, FLG_COMPLETATA,
    NOTE, DTA_DELETE, FLG_DELETE, COD_SNDG
    )
    VALUES(V_COD_PRAT, P_COD_ABI_CARTOLARIZZATO, P_COD_NDG,
    P_ID_TIPOLOGIA_PRATICA, P_ID_FASE_GESTIONE, NULL,
    SYSDATE, NULL, P_DTA_SCADENZA, V_COD_STATO_RISCHIO,
    P_COD_MACROSTATO, P_FLG_ESITO_POSITIVO, P_FLG_COMPLETATA,
    P_NOTE, NULL, 'N', P_COD_SNDG);
    P_COD_PRAT_FASE:=V_COD_PRAT;
  WHEN P_IUD IN ('U','u') THEN
  BEGIN
     SELECT AD.COD_STATO
     INTO V_COD_STATO_RISCHIO
     FROM T_MCRE0_APP_ALL_DATA AD, T_MCRE0_APP_GEST_PRATICA_FASI PRT
    WHERE  PRT.COD_PRAT_FASE = P_COD_PRAT_FASE
       AND PRT.COD_ABI_CARTOLARIZZATO = AD.COD_ABI_CARTOLARIZZATO
       AND PRT.COD_NDG = AD.COD_NDG
       AND ROWNUM = 1;
   EXCEPTION WHEN NO_DATA_FOUND THEN
   V_COD_STATO_RISCHIO:=NULL;
   V_NOTE:=V_NOTE||'SELECT AD.COD_STATO
     INTO V_COD_STATO_RISCHIO
     FROM T_MCRE0_APP_ALL_DATA AD, T_MCRE0_APP_GEST_ADVISOR ADV
    WHERE  ADV.COD_ADVISOR = P_COD_ADVISOR
       AND ADV.COD_ABI = AD.COD_ABI_CARTOLARIZZATO
       AND ADV.COD_NDG = AD.COD_NDG
       AND ROWNUM = 1'||CHR(10)||'L''UPDATE VERRA'' ESEGUITA CON COD_STATO_RISCHIO=NULL COD_MACROSTATO=NULL';
   PKG_MCRE0_AUDIT.LOG_APP(V_SEQ, V_PROC, 3, SQLCODE,SQLERRM, V_NOTE, P_COD_MATRICOLA);
  END;
   UPDATE T_MCRE0_APP_GEST_PRATICA_FASI
     SET ID_TIPOLOGIA_PRATICA = P_ID_TIPOLOGIA_PRATICA,
         ID_FASE_GESTIONE     = P_ID_FASE_GESTIONE,
         DTA_SCADENZA         = P_DTA_SCADENZA,
         FLG_ESITO_POSITIVO   = P_FLG_ESITO_POSITIVO,
         FLG_COMPLETATA       = P_FLG_COMPLETATA,
         NOTE                 = P_NOTE,
         COD_STATO_RISCHIO    = V_COD_STATO_RISCHIO,
         DTA_UPD              = SYSDATE
   WHERE COD_PRAT_FASE = P_COD_PRAT_FASE;
  WHEN P_IUD IN ('D','d') THEN
   UPDATE T_MCRE0_APP_GEST_PRATICA_FASI
     SET FLG_DELETE = 'Y',
         DTA_DELETE = SYSDATE,
         DTA_UPD              = SYSDATE
   WHERE COD_PRAT_FASE = P_COD_PRAT_FASE;  ELSE
     raise_application_error(-20666, 'Null or illegal parameter');
  END CASE;
    PKG_MCRE0_AUDIT.LOG_APP(V_SEQ, V_PROC, 3, SQLCODE,SQLERRM,V_NOTE, P_COD_MATRICOLA);
  RETURN PKG_MCRE0_GEST_POS.OK;
  EXCEPTION WHEN OTHERS THEN
    PKG_MCRE0_AUDIT.LOG_APP(V_SEQ, V_PROC, 3, SQLCODE,SQLERRM, V_NOTE, P_COD_MATRICOLA);
    RETURN PKG_MCRE0_GEST_POS.KO;
  END FNC_GEST_PRAT_FAS_IUD;



FUNCTION FNC_GEST_PDF
    (p_abi             VARCHAR2,
     p_ndg             VARCHAR2,
     p_sndg            VARCHAR2,
     p_utente          VARCHAR2,
     p_tipo_operazione VARCHAR2,
     p_cod_macrostato  VARCHAR2) RETURN NUMBER IS

v_note VARCHAR2(2000);
---------------------------------
v_id_anomalia VARCHAR2(4000);
v_id_advisor  VARCHAR2(4000);
v_id_azione   VARCHAR2(4000);

v_cod_gruppo_economico t_mcre0_app_all_data.cod_gruppo_economico%TYPE := 'NO_GE';
v_cod_macrostato_att   t_mcre0_app_all_data.cod_macrostato%TYPE;
BEGIN
v_note := 'GET GE - cod_abi: ' || p_abi || ' - cod_ndg: ' ||p_ndg || ' - cod_sndg: ' || p_sndg;

BEGIN
    SELECT DISTINCT a.cod_gruppo_economico, a.cod_macrostato
    INTO v_cod_gruppo_economico, v_cod_macrostato_att
    FROM t_mcre0_app_all_data a --v5.0
    WHERE flg_active = 1
    AND a.cod_abi_cartolarizzato = p_abi
    AND a.cod_ndg = p_ndg
    AND a.cod_sndg = p_sndg;
  EXCEPTION
    WHEN no_data_found
    THEN NULL;
  END;


v_note := 'GET anomalie - cod_abi: ' || p_abi || ' - cod_ndg: ' || p_ndg || ' - cod_sndg: ' || p_sndg || ' - cod_macrostato: ' || p_cod_macrostato;

SELECT RTRIM( xmlagg( xmlelement( "x", cod_anomalia || ',' ) ).EXTRACT( '//text()' ), ',' ) cod_anomalia
INTO v_id_anomalia
FROM v_mcre0_app_gest_anomalie an, v_mcre0_app_upd_fields_p1 u
WHERE an.cod_abi_cartolarizzato = u.cod_abi_cartolarizzato
AND an.cod_ndg = u.cod_ndg
and an.flg_delete = 'N'
--AD: se il GE restituito dalla ALL_DATA all'inizio è pari a -1, non contribuisce all'estrazione,
--    perciò è stata messa una decode che vanifica l'uguaglianza in caso di GE -1
AND( DECODE( an.cod_gruppo_economico, '-1', '-2' ) = v_cod_gruppo_economico      --u.cod_gruppo_economico = v_cod_gruppo_economico
                                                                                 --AD: inserita decode l'8 gennaio 2013 per evitare chee estragga tutte le
                                                                                 --    posizioni con GE = -1 e valore preso dalle anomalie
     OR( u.cod_abi_cartolarizzato = p_abi AND
         u.cod_ndg = p_ndg AND
         u.cod_sndg = p_sndg ) )
AND an.cod_sndg = u.cod_sndg
AND an.cod_macrostato = p_cod_macrostato
AND ( ( an.flg_gruppo_economico = 'S' AND
        an.cod_abi_cartolarizzato = p_abi AND
        an.cod_ndg = p_ndg AND
        an.cod_sndg = p_sndg )
      OR
      an.flg_gruppo_economico = 'G' );

v_note := 'GET advisor - cod_abi: ' || p_abi || ' - cod_ndg: ' || p_ndg || ' - cod_sndg: ' || p_sndg || ' - cod_macrostato: ' || p_cod_macrostato;

SELECT RTRIM( xmlagg( xmlelement( "x", cod_advisor || ',' ) ).EXTRACT( '//text()' ), ',' ) cod_advisor
INTO v_id_advisor
FROM v_mcre0_app_gest_advisor an
WHERE cod_abi_cartolarizzato = p_abi
AND cod_ndg = p_ndg
AND an.cod_sndg = p_sndg
AND an.cod_macrostato = p_cod_macrostato
and an.flg_delete = 'N';

v_note := 'GET azioni - cod_abi: ' || p_abi || ' - cod_ndg: ' || p_ndg || ' - cod_sndg: ' || p_sndg || ' - cod_macrostato: ' || p_cod_macrostato;

SELECT RTRIM( xmlagg( xmlelement( "x", cod_prat_fase || ',' ) ).EXTRACT( '//text()' ), ',' ) id_azione
INTO v_id_azione
FROM v_mcre0_app_gest_pratica_fasi a, v_mcre0_app_upd_fields_p1 u
WHERE a.cod_abi_cartolarizzato = u.cod_abi_cartolarizzato
AND a.cod_ndg = u.cod_ndg
--AD: se il GE restituito dalla ALL_DATA all'inizio è pari a -1, non contribuisce all'estrazione,
--    perciò è stato messo un nvl che vanifica l'uguaglianza in caso di GE -1
AND( NVL( a.cod_gruppo_economico,'-2' ) = v_cod_gruppo_economico                  --u.cod_gruppo_economico = v_cod_gruppo_economico
                                                                                 --AD: sostituito u.cod_gruppo_economico  con a.cod_gruppo_economico
     OR( u.cod_abi_cartolarizzato = p_abi AND
         u.cod_ndg = p_ndg AND
         u.cod_sndg = p_sndg ) )
AND a.cod_sndg = u.cod_sndg
AND a.cod_macrostato = p_cod_macrostato
and a.flg_delete = 'N';


v_note := 'Insert pdf_rio - cod_abi: ' || p_abi || ' - cod_ndg: ' || p_ndg || ' - cod_sndg: ' || p_sndg || ' - cod_macrostato: ' || p_cod_macrostato;

INSERT INTO t_mcre0_app_gest_pdf
    ( id_pdf,
      dta_ins,
      cod_abi_cartolarizzato,
        cod_ndg,
      cod_sndg,
      cod_struttura_competente_ar,
      cod_struttura_competente_fi,
      scsb_acc_cassa_bt_at,
      scsb_uti_cassa_bt_at,
      scsb_acc_smobilizzo_at,
      scsb_uti_smobilizzo_at,
      scsb_acc_cassa_mlt_at,
      scsb_uti_cassa_mlt_at,
      scsb_acc_firma_at,
      scsb_uti_firma_at,
      scsb_acc_tot_at,
      scsb_uti_tot_at,
      scsb_tot_gar_at,
      scsb_acc_sostituzioni_at,
      scsb_uti_sostituzioni_at,
      scsb_acc_massimali_at,
      scsb_uti_massimali_at,
      dta_pcr_at,
      dta_cr_at,
      val_mese_1,
      val_lr_mese_1,
      val_mese_2,
      val_lr_mese_2,
      val_mese_3,
      val_lr_mese_3,
      val_mese_4,
      val_lr_mese_4,
      val_mese_5,
      val_lr_mese_5,
      val_mese_6,
      val_lr_mese_6,
      val_mese_7,
      val_lr_mese_7,
      dta_rif_iris,
      rating_online,
      dta_scad_revisione_pef,
      gesb_acc_tot_at,
      gesb_uti_tot_at,
      gegb_uti_tot_at,
      gegb_acc_tot_at,
      id_anomalia,
      id_azione,
      val_utente,
      cod_macrostato_destinazione,
      note_classificazione,
      flg_lettura_verbale,
      cod_sequence_proroga,
      val_motivo_esito,
      val_motivo_richiesta,
      scgb_qis_uti,
      scgb_qis_acc,
      scgb_dta_rif_cr,
      cod_gruppo_economico,
      val_ana_gre,
      cod_stato,
      cod_macrostato,
      id_advisor,
      desc_tipo_op )
    SELECT
        seq_mcre0_gest_pdf.NEXTVAL,
        SYSDATE,
        a.cod_abi_cartolarizzato,
        a.cod_ndg,
        a.cod_sndg,
        a.cod_struttura_competente_ar,
        a.cod_struttura_competente_fi,
        e.val_sb_acc_cassa_bt_at,
        e.val_sb_uti_cassa_bt_at,
        e.val_sb_acc_smobilizzo_at,
        e.val_sb_uti_smobilizzo_at,
        e.val_sb_acc_cassa_mlt_at,
        e.val_sb_uti_cassa_mlt_at,
        e.val_sb_acc_firma_at,
        e.val_sb_uti_firma_at,
        e.val_sb_acc_tot_at,
        e.val_sb_uti_tot_at,
        e.val_sb_tot_gar_at,
        e.val_sb_acc_sostituzioni_at,
        e.val_sb_uti_sostituzioni_at,
        e.val_sb_acc_massimali_at,
        e.val_sb_uti_massimali_at,
        e.dta_pcr_at,
        e.dta_cr_at,
        o.mese1,
        i.mese1,
        o.mese2,
        i.mese2,
        o.mese3,
        i.mese3,
        o.mese4,
        i.mese4,
        o.mese5,
        i.mese5,
        o.mese6,
        i.mese6,
        o.mese7,
        i.mese7,
        MAX( ir.dta_riferimento ) over( PARTITION BY ir.cod_sndg ) dta_rif_iris,
        m.val_rating_pc rating_online,
        a.dta_scad_revisione_pef,
        g.val_sb_acc_tot_at,
        g.val_sb_uti_tot_at,
        g.val_gb_uti_tot_at,
        g.val_gb_acc_tot_at,
        v_id_anomalia,
        v_id_azione,
        p_utente,
        pos.cod_macrostato_destinazione,
        pos.note_classificazione,
        pos.flg_lettura_verbale,
        pr.cod_sequence,
        pr.val_motivo_esito,
        pos.motivo_proroga,
        sb.scgb_qis_uti,
        sb.scgb_qis_acc,
        sb.scgb_dta_rif_cr,
        a.cod_gruppo_economico,
        a.val_ana_gre,
        a.cod_stato,
        v_cod_macrostato_att,
        v_id_advisor,
        p_tipo_operazione
    FROM v_mcre0_app_gest_monitoraggio m,
         v_mcre0_app_evol_gest_esp_sc e,
         v_mcre0_app_evol_gest_esp_ge g,
         v_mcre0_scheda_iris i,
         v_mcre0_scheda_iris o,
         v_mcre0_app_scheda_anag a,
         t_mcre0_app_iris ir,
         t_mcre0_app_gest_posizione pos,
         t_mcre0_app_all_data f,
         ( SELECT * FROM t_mcre0_app_rio_proroghe WHERE flg_storico = 0 ) pr,
         t_mcre0_app_cr sb
    WHERE a.cod_abi_cartolarizzato = e.cod_abi_cartolarizzato(+)
    AND   a.cod_ndg = e.cod_ndg(+)
    AND   a.cod_abi_cartolarizzato = m.cod_abi_cartolarizzato(+)
    AND   a.cod_ndg = m.cod_ndg(+)
    AND   a.cod_abi_cartolarizzato = g.cod_abi_cartolarizzato(+)
    AND   a.cod_ndg = g.cod_ndg(+)
    AND   a.cod_sndg = i.cod_sndg(+)
    AND   a.cod_sndg = ir.cod_sndg(+)
    AND   a.cod_sndg = o.cod_sndg(+)
    AND   a.cod_abi_cartolarizzato = pos.cod_abi_cartolarizzato(+)
    AND   a.cod_ndg = pos.cod_ndg(+)
    AND   a.cod_abi_cartolarizzato = pr.cod_abi_cartolarizzato(+)
    AND   a.cod_ndg = pr.cod_ndg(+)
    AND   a.cod_abi_cartolarizzato = sb.cod_abi_cartolarizzato(+)
    AND   a.cod_ndg = sb.cod_ndg(+)
    AND   a.cod_abi_cartolarizzato = f.cod_abi_cartolarizzato
    AND   a.cod_ndg = f.cod_ndg
    AND   f.flg_active = 1
    AND   i.ordine(+) = 1
    AND   o.ordine(+) = 0
    AND   pos.cod_ndg = p_ndg
    AND   pos.cod_abi_cartolarizzato = p_abi
    AND   pos.cod_sndg = p_sndg
    AND   pos.cod_macrostato = p_cod_macrostato
    ;

RETURN ok;

EXCEPTION
    WHEN OTHERS THEN
        pkg_mcre0_audit.log_app( c_package || '.gest_pos', 1, SQLCODE, SQLERRM, v_note, p_utente);
        RETURN ko;

END FNC_GEST_PDF;


  FUNCTION FNC_GEST_POSIZIONE_UBP(P_COD_ABI_CARTOLARIZZATO IN T_MCRE0_APP_GEST_POSIZIONE.COD_ABI_CARTOLARIZZATO%TYPE,
                                  P_COD_NDG IN T_MCRE0_APP_GEST_POSIZIONE.COD_NDG%TYPE,
                                  P_COD_MACROSTATO IN T_MCRE0_APP_GEST_POSIZIONE.COD_MACROSTATO%TYPE,
                                  P_MOTIVO_PROROGA IN T_MCRE0_APP_GEST_POSIZIONE.MOTIVO_PROROGA%TYPE,
                                  P_COD_MATRICOLA IN T_MCRE0_WRK_AUDIT_APPLICATIVO.UTENTE%TYPE
                                 )
                              RETURN NUMBER IS
    V_SEQ              NUMBER;
    V_NOTE             T_MCRE0_WRK_AUDIT_APPLICATIVO.NOTE%TYPE;
    V_PROC             T_MCRE0_WRK_AUDIT_APPLICATIVO.PROCEDURA%TYPE:=PKG_MCRE0_GEST_POS.C_PACKAGE||'.FNC_GEST_POSIZIONE_UBP';
    V_NEW_ID_ADVISOR   NUMBER;
    V_COD_ADVISOR      T_MCRE0_APP_GEST_ADVISOR.COD_ADVISOR%TYPE:=NULL;
    V_COD_STATO_RISCHIO   T_MCRE0_APP_ALL_DATA.COD_STATO%TYPE;


  BEGIN
        V_NOTE:='P_COD_ABI_CARTOLARIZZATO = '||P_COD_ABI_CARTOLARIZZATO||
                ', P_COD_NDG = '||P_COD_NDG||
                ',P_COD_MATRICOLA = '||P_COD_MATRICOLA||
                ', P_COD_MACROSTATO = '||P_COD_MACROSTATO||
                ', P_MOTIVO_PROROGA = '||P_MOTIVO_PROROGA||CHR(10);

        SELECT seq_mcr0_log_app.nextval INTO v_seq FROM dual;

        UPDATE T_MCRE0_APP_GEST_POSIZIONE
           SET MOTIVO_PROROGA = P_MOTIVO_PROROGA
         WHERE COD_ABI_CARTOLARIZZATO = P_COD_ABI_CARTOLARIZZATO
           AND COD_NDG                = P_COD_NDG
           AND COD_MACROSTATO         = P_COD_MACROSTATO;

        PKG_MCRE0_AUDIT.LOG_APP(V_SEQ, V_PROC, 3, SQLCODE,SQLERRM,V_NOTE, P_COD_MATRICOLA);
  return ok;

   EXCEPTION
    WHEN OTHERS THEN
      pkg_mcre0_audit.log_app(c_package || '.FNC_GEST_POSIZIONE_UBP',
                              1,
                              SQLCODE,
                              SQLERRM,
                              v_note,
                              p_cod_matricola);
      RETURN ko;


  END FNC_GEST_POSIZIONE_UBP;


-------------RWA-----------
--FUNZIONE DI INIZIALIZZAZIONE DI UN NUOVO RECORD DI SINCRONIZZAZIONE
-- %return 1 -> se l'insert e' andata a buon fine, 0 altrimenti
FUNCTION FNC_INIT_SYNC_RWA_POS
    (P_COD_ABI                     IN T_MCRE0_RWA_POSIZIONE.COD_ABI%TYPE,
     P_COD_NDG                     IN T_MCRE0_RWA_POSIZIONE.COD_NDG%TYPE,
     P_COD_SNDG                     IN T_MCRE0_RWA_POSIZIONE.COD_SNDG%TYPE,
     P_COD_UO_POSIZ                 IN T_MCRE0_RWA_POSIZIONE.COD_UO_POSIZ%TYPE,
     P_COD_STATO                 IN T_MCRE0_RWA_POSIZIONE.COD_STATO%TYPE,
     P_DTA_DECOR_STATO             IN T_MCRE0_RWA_POSIZIONE.DTA_DECOR_STATO%TYPE,
     P_COD_FUNZIONALITA             IN T_MCRE0_RWA_POSIZIONE.COD_FUNZIONALITA%TYPE,
     P_COD_BS                   IN T_MCRE0_RWA_POSIZIONE.COD_BS%TYPE,
     P_FLG_PRIMA_CHIAMATA        IN VARCHAR2 DEFAULT 'Y',
     P_COD_MATRICOLA            IN T_MCRE0_WRK_AUDIT_APPLICATIVO.UTENTE%TYPE DEFAULT NULL)
RETURN NUMBER IS
    V_NOTE                        T_MCRE0_WRK_AUDIT_APPLICATIVO.NOTE%TYPE;
    V_PROC                        T_MCRE0_WRK_AUDIT_APPLICATIVO.PROCEDURA%TYPE := PKG_MCRE0_GEST_POS.C_PACKAGE||'.FNC_INIT_SYNC_RWA_POS';
    V_SEQ                        NUMBER;
    V_COUNT                        NUMBER;

    BEGIN
        V_NOTE := 'P_COD_ABI = ' || P_COD_ABI ||
                  ', P_COD_NDG = ' || P_COD_NDG ||
                  ', P_COD_SNDG = ' || P_COD_SNDG ||
                  ', P_COD_STATO = ' || P_COD_STATO ||
                  ', P_DTA_DECOR_STATO = ' || P_DTA_DECOR_STATO ||
                  ', P_COD_FUNZIONALITA = ' || P_COD_FUNZIONALITA ||
                  ', P_COD_BS = ' || P_COD_BS ||
                  ', P_FLG_PRIMA_CHIAMATA = ' || P_FLG_PRIMA_CHIAMATA ||
                  ', P_COD_MATRICOLA = ' || P_COD_MATRICOLA || CHR(10);

        SELECT SEQ_MCR0_LOG_APP.NEXTVAL
        INTO V_SEQ
        FROM DUAL;

        SELECT COUNT(*)
        INTO V_COUNT
        FROM T_MCRE0_RWA_POSIZIONE
        WHERE COD_ABI = P_COD_ABI
        AND COD_NDG = P_COD_NDG
        AND COD_SNDG = P_COD_SNDG
        AND COD_UO_POSIZ = P_COD_UO_POSIZ
        AND COD_STATO = P_COD_STATO
        AND TRUNC(DTA_DECOR_STATO) = TRUNC(P_DTA_DECOR_STATO)
        AND COD_FUNZIONALITA = P_COD_FUNZIONALITA
        AND COD_BS = P_COD_BS
        AND COD_MATRICOLA = P_COD_MATRICOLA
        AND VAL_STORICO = 0;

        IF
            V_COUNT = 1
        THEN
            UPDATE T_MCRE0_RWA_POSIZIONE
            SET RWA_TICKET_ID = NULL,
                FLG_VALIDITA = DECODE(P_FLG_PRIMA_CHIAMATA, 'Y', 0, 2),
                COD_ESITO = NULL,
                DTA_INS = DECODE(P_FLG_PRIMA_CHIAMATA, 'Y', SYSDATE, dta_ins),
                DTA_UPD = DECODE(P_FLG_PRIMA_CHIAMATA, 'Y', null, sysdate),
                COD_PROC_CALC = NULL,
                COD_UO_COMP = NULL,
                COD_UO_CAPOFILA_ANAG = NULL,
                COD_UO_CAPOFILA_CALC = NULL,
                VAL_RWA = NULL,
                VAL_LIV_UTENTE = NULL,
                VAL_LIV_POSIZ = NULL
            WHERE COD_ABI = P_COD_ABI
            AND COD_NDG = P_COD_NDG
            AND COD_SNDG = P_COD_SNDG
            AND COD_UO_POSIZ = P_COD_UO_POSIZ
            AND COD_STATO = P_COD_STATO
            AND TRUNC(DTA_DECOR_STATO) = TRUNC(P_DTA_DECOR_STATO)
            AND COD_FUNZIONALITA = P_COD_FUNZIONALITA
            AND COD_BS = P_COD_BS
            AND COD_MATRICOLA = P_COD_MATRICOLA
            AND VAL_STORICO = 0;
        ELSE
            IF
                P_FLG_PRIMA_CHIAMATA = 'Y'
            THEN
                INSERT INTO T_MCRE0_RWA_POSIZIONE
                    (COD_ABI, COD_NDG, COD_SNDG, COD_UO_POSIZ, COD_STATO, DTA_DECOR_STATO, COD_FUNZIONALITA, COD_BS, COD_MATRICOLA,
                     VAL_LIV_UTENTE, VAL_STORICO, RWA_TICKET_ID, COD_ESITO, FLG_VALIDITA, DTA_INS, DTA_UPD, COD_PROC_CALC, VAL_LIV_POSIZ, COD_UO_COMP,
                     COD_UO_CAPOFILA_ANAG, COD_UO_CAPOFILA_CALC, VAL_RWA)
                VALUES
                    (P_COD_ABI, P_COD_NDG, P_COD_SNDG, P_COD_UO_POSIZ, P_COD_STATO, P_DTA_DECOR_STATO, P_COD_FUNZIONALITA, P_COD_BS, P_COD_MATRICOLA,
                     NULL, 0, NULL, NULL, 0, sysdate, NULL, NULL, NULL, NULL,
                     NULL, NULL, NULL);
            ELSE
                PKG_MCRE0_AUDIT.LOG_APP(V_SEQ, V_PROC, 1, SQLCODE, SQLERRM, V_NOTE, P_COD_MATRICOLA);
                RETURN KO;
            END IF;
        END IF;

        PKG_MCRE0_AUDIT.LOG_APP(V_SEQ, V_PROC, 3, SQLCODE, SQLERRM, V_NOTE, P_COD_MATRICOLA);

        RETURN OK;

        EXCEPTION
            WHEN OTHERS
            THEN PKG_MCRE0_AUDIT.LOG_APP(V_SEQ, V_PROC, 1, SQLCODE, SQLERRM, V_NOTE, P_COD_MATRICOLA);
                 RETURN KO;

END FNC_INIT_SYNC_RWA_POS;

--FUNZIONE DI AGGIORNAMENTO DI UN RECORD DI SINCRONIZZAZIONE
-- %return 1 -> se l'insert e' andata a buon fine, 0 altrimenti
FUNCTION FNC_SYNC_FINE_RWA_POS
    (P_COD_ABI                     IN T_MCRE0_RWA_POSIZIONE.COD_ABI%TYPE,
     P_COD_NDG                     IN T_MCRE0_RWA_POSIZIONE.COD_NDG%TYPE,
     P_COD_SNDG                     IN T_MCRE0_RWA_POSIZIONE.COD_SNDG%TYPE,
     P_COD_UO_POSIZ                 IN T_MCRE0_RWA_POSIZIONE.COD_UO_POSIZ%TYPE,
     P_VAL_LIV_POSIZ             IN T_MCRE0_RWA_POSIZIONE.VAL_LIV_POSIZ%TYPE,
     P_COD_STATO                 IN T_MCRE0_RWA_POSIZIONE.COD_STATO%TYPE,
     P_DTA_DECOR_STATO             IN T_MCRE0_RWA_POSIZIONE.DTA_DECOR_STATO%TYPE,
     P_COD_FUNZIONALITA             IN T_MCRE0_RWA_POSIZIONE.COD_FUNZIONALITA%TYPE,
     P_COD_BS                   IN T_MCRE0_RWA_POSIZIONE.COD_BS%TYPE,
     P_RWA_TICKET_ID            IN T_MCRE0_RWA_POSIZIONE.RWA_TICKET_ID%TYPE,
     P_COD_ESITO                 IN T_MCRE0_RWA_POSIZIONE.COD_ESITO%TYPE,
     P_COD_PROC_CALC             IN T_MCRE0_RWA_POSIZIONE.COD_PROC_CALC%TYPE,
     P_COD_UO_COMP                 IN T_MCRE0_RWA_POSIZIONE.COD_UO_COMP%TYPE,
     P_COD_UO_CAPOFILA_ANAG        IN T_MCRE0_RWA_POSIZIONE.COD_UO_CAPOFILA_ANAG%TYPE,
     P_COD_UO_CAPOFILA_CALC        IN T_MCRE0_RWA_POSIZIONE.COD_UO_CAPOFILA_CALC%TYPE,
     P_VAL_RWA                     IN T_MCRE0_RWA_POSIZIONE.VAL_RWA%TYPE,
     P_VAL_LIV_UTENTE            IN T_MCRE0_RWA_POSIZIONE.VAL_LIV_UTENTE%TYPE,
     P_COD_MATRICOLA            IN T_MCRE0_WRK_AUDIT_APPLICATIVO.UTENTE%TYPE DEFAULT NULL)
RETURN NUMBER IS
    V_FLG_VALIDITA                T_MCRE0_RWA_POSIZIONE.FLG_VALIDITA%TYPE;
    V_RWA_TICKET_ID                T_MCRE0_RWA_POSIZIONE.RWA_TICKET_ID%TYPE := NULL;
    V_COD_PROC_CALC                T_MCRE0_RWA_POSIZIONE.COD_PROC_CALC%TYPE := NULL;
    V_COD_UO_COMP                T_MCRE0_RWA_POSIZIONE.COD_UO_COMP%TYPE := NULL;
    V_COD_UO_CAPOFILA_ANAG        T_MCRE0_RWA_POSIZIONE.COD_UO_CAPOFILA_ANAG%TYPE := NULL;
    V_COD_UO_CAPOFILA_CALC        T_MCRE0_RWA_POSIZIONE.COD_UO_CAPOFILA_CALC%TYPE := NULL;
    V_VAL_RWA                    T_MCRE0_RWA_POSIZIONE.VAL_RWA%TYPE := NULL;

    V_NOTE                        T_MCRE0_WRK_AUDIT_APPLICATIVO.NOTE%TYPE;
    V_PROC                        T_MCRE0_WRK_AUDIT_APPLICATIVO.PROCEDURA%TYPE := PKG_MCRE0_GEST_POS.C_PACKAGE||'.FNC_SYNC_FINE_RWA_POS';
    V_SEQ                        NUMBER;
    V_COUNT                        NUMBER;

    v_liv_utente number;
    v_liv_processo number;

    BEGIN
        V_NOTE := 'P_COD_ABI = ' || P_COD_ABI ||
                  ', P_COD_NDG = ' || P_COD_NDG ||
                  ', P_COD_SNDG = ' || P_COD_SNDG ||
                  ', P_COD_UO_POSIZ = ' || P_COD_UO_POSIZ ||
                  ', P_COD_STATO = ' || P_COD_STATO ||
                  ', P_DTA_DECOR_STATO = ' || P_DTA_DECOR_STATO ||
                  ', P_COD_FUNZIONALITA = ' || P_COD_FUNZIONALITA ||
                  ', P_COD_BS = ' || P_COD_BS ||
                  ', P_RWA_TICKET_ID = ' || P_RWA_TICKET_ID ||
                  ', P_COD_ESITO = ' || P_COD_ESITO ||
                  ', P_COD_PROC_CALC = ' || P_COD_PROC_CALC ||
                  ', P_COD_UO_COMP = ' || P_COD_UO_COMP ||
                  ', P_COD_UO_CAPOFILA_ANAG = ' || P_COD_UO_CAPOFILA_ANAG ||
                  ', P_COD_UO_CAPOFILA_CALC = ' || P_COD_UO_CAPOFILA_CALC ||
                  ', P_VAL_RWA = ' || P_VAL_RWA ||
                  ', P_VAL_LIV_UTENTE = ' || P_VAL_LIV_UTENTE ||
                  ', P_COD_MATRICOLA = ' || P_COD_MATRICOLA ||
                  ', P_VAL_LIV_POSIZ = ' || P_VAL_LIV_POSIZ || CHR(10);

        SELECT SEQ_MCR0_LOG_APP.NEXTVAL
        INTO V_SEQ
        FROM DUAL;

        IF
            P_COD_ESITO = '01'
        THEN
            -- calcolo processo ancora in corso
            V_FLG_VALIDITA := 1;
            V_RWA_TICKET_ID := P_RWA_TICKET_ID;
        ELSE
            IF
                P_COD_ESITO = '02'
            THEN
                -- calcolo processo terminato con successo
                V_COD_PROC_CALC := P_COD_PROC_CALC;
                V_COD_UO_COMP := P_COD_UO_COMP;
                V_COD_UO_CAPOFILA_ANAG := P_COD_UO_CAPOFILA_ANAG;
                V_COD_UO_CAPOFILA_CALC := P_COD_UO_CAPOFILA_CALC;
                V_VAL_RWA := P_VAL_RWA;

                select DECODE(P_VAL_LIV_UTENTE, 'FI', 1, 'AR', 2, 'RG', 3, 'DV', 4, 'DC', 5, 6)
                into v_liv_utente
                from dual;
                select DECODE(P_VAL_LIV_POSIZ, 'FI', 1, 'AR', 2, 'RG', 3, 'DV', 4, 'DC', 5, 7)
                into v_liv_processo
                from dual;

                IF   v_liv_utente >= v_liv_processo
                THEN V_FLG_VALIDITA := 3;
                ELSE V_FLG_VALIDITA := -3;
                END IF;

            ELSE
                -- calcolo processo terminato con fallimento
                -- oppure
                -- errore durante la chiamata al motore di calcolo del processo
                V_FLG_VALIDITA := -1;
            END IF;

        END IF;

    SELECT COUNT(*)
    INTO V_COUNT
    FROM T_MCRE0_RWA_POSIZIONE
    WHERE COD_ABI = P_COD_ABI
        AND COD_NDG = P_COD_NDG
        AND COD_SNDG = P_COD_SNDG
        AND COD_UO_POSIZ = P_COD_UO_POSIZ
        AND COD_STATO = P_COD_STATO
        AND TRUNC(DTA_DECOR_STATO) = TRUNC(P_DTA_DECOR_STATO)
        AND COD_FUNZIONALITA = P_COD_FUNZIONALITA
        AND COD_BS = P_COD_BS
        AND COD_MATRICOLA = P_COD_MATRICOLA
        AND VAL_STORICO = 0;

        IF
            V_COUNT = 1
        THEN
            UPDATE T_MCRE0_RWA_POSIZIONE
            SET RWA_TICKET_ID = V_RWA_TICKET_ID,
                FLG_VALIDITA = V_FLG_VALIDITA,
                COD_ESITO = P_COD_ESITO,
                DTA_UPD = SYSDATE,
                COD_PROC_CALC = V_COD_PROC_CALC,
                COD_UO_COMP = V_COD_UO_COMP,
                COD_UO_CAPOFILA_ANAG = V_COD_UO_CAPOFILA_ANAG,
                COD_UO_CAPOFILA_CALC = V_COD_UO_CAPOFILA_CALC,
                VAL_RWA = V_VAL_RWA,
                VAL_LIV_UTENTE = P_VAL_LIV_UTENTE,
                VAL_LIV_POSIZ = P_VAL_LIV_POSIZ
            WHERE COD_ABI = P_COD_ABI
            AND COD_NDG = P_COD_NDG
            AND COD_SNDG = P_COD_SNDG
            AND COD_UO_POSIZ = P_COD_UO_POSIZ
            AND COD_STATO = P_COD_STATO
            AND TRUNC(DTA_DECOR_STATO) = TRUNC(P_DTA_DECOR_STATO)
            AND COD_FUNZIONALITA = P_COD_FUNZIONALITA
            AND COD_BS = P_COD_BS
            AND COD_MATRICOLA = P_COD_MATRICOLA
            AND VAL_STORICO = 0;
        ELSE
            PKG_MCRE0_AUDIT.LOG_APP(V_SEQ, V_PROC, 1, SQLCODE, SQLERRM, V_NOTE, P_COD_MATRICOLA);
            RETURN KO;
        END IF;

        PKG_MCRE0_AUDIT.LOG_APP(V_SEQ, V_PROC, 3, SQLCODE, SQLERRM, V_NOTE, P_COD_MATRICOLA);

        RETURN OK;

        EXCEPTION
            WHEN OTHERS
            THEN
                PKG_MCRE0_AUDIT.LOG_APP(V_SEQ, V_PROC, 1, SQLCODE, SQLERRM, V_NOTE, P_COD_MATRICOLA);
                RETURN KO;

END FNC_SYNC_FINE_RWA_POS;

--FUNZIONE DI INVALIDAZIONE DI UN RECORD DI SINCRONIZZAZIONE SCADUTO
-- %return 1 -> se l'insert e' andata a buon fine, 0 altrimenti
FUNCTION FNC_SYNC_NO_UPDATE_RWA_POS
    (P_COD_ABI                     IN T_MCRE0_RWA_POSIZIONE.COD_ABI%TYPE,
     P_COD_NDG                     IN T_MCRE0_RWA_POSIZIONE.COD_NDG%TYPE,
     P_COD_SNDG                     IN T_MCRE0_RWA_POSIZIONE.COD_SNDG%TYPE,
     P_COD_UO_POSIZ                 IN T_MCRE0_RWA_POSIZIONE.COD_UO_POSIZ%TYPE,
     P_COD_STATO                 IN T_MCRE0_RWA_POSIZIONE.COD_STATO%TYPE,
     P_DTA_DECOR_STATO             IN T_MCRE0_RWA_POSIZIONE.DTA_DECOR_STATO%TYPE,
     P_COD_FUNZIONALITA             IN T_MCRE0_RWA_POSIZIONE.COD_FUNZIONALITA%TYPE,
     P_COD_BS                   IN T_MCRE0_RWA_POSIZIONE.COD_BS%TYPE,
     P_COD_MATRICOLA            IN T_MCRE0_WRK_AUDIT_APPLICATIVO.UTENTE%TYPE DEFAULT NULL)
RETURN NUMBER IS
    V_NOTE                        T_MCRE0_WRK_AUDIT_APPLICATIVO.NOTE%TYPE;
    V_PROC                        T_MCRE0_WRK_AUDIT_APPLICATIVO.PROCEDURA%TYPE := PKG_MCRE0_GEST_POS.C_PACKAGE||'.FNC_SYNC_NO_UPDATE_RWA_POS';
    V_SEQ                        NUMBER;
    V_COUNT                        NUMBER;

    BEGIN
        V_NOTE := 'P_COD_ABI = ' || P_COD_ABI ||
                  ', P_COD_NDG = ' || P_COD_NDG ||
                  ', P_COD_SNDG = ' || P_COD_SNDG ||
                  ', P_COD_UO_POSIZ = ' || P_COD_UO_POSIZ ||
                  ', P_COD_STATO = ' || P_COD_STATO ||
                  ', P_DTA_DECOR_STATO = ' || P_DTA_DECOR_STATO ||
                  ', P_COD_FUNZIONALITA = ' || P_COD_FUNZIONALITA ||
                  ', P_COD_BS = ' || P_COD_BS ||
                  ', P_COD_MATRICOLA = ' || P_COD_MATRICOLA || CHR(10);

        SELECT SEQ_MCR0_LOG_APP.NEXTVAL
        INTO V_SEQ
        FROM DUAL;

        SELECT COUNT(*)
        INTO V_COUNT
        FROM T_MCRE0_RWA_POSIZIONE
        WHERE COD_ABI = P_COD_ABI
        AND COD_NDG = P_COD_NDG
        AND COD_SNDG = P_COD_SNDG
        AND COD_UO_POSIZ = P_COD_UO_POSIZ
        AND COD_STATO = P_COD_STATO
        AND TRUNC(DTA_DECOR_STATO) = TRUNC(P_DTA_DECOR_STATO)
        AND COD_FUNZIONALITA = P_COD_FUNZIONALITA
        AND COD_BS = P_COD_BS
        AND COD_MATRICOLA = P_COD_MATRICOLA
        AND VAL_STORICO = 0;

        IF
            V_COUNT = 1
        THEN
            UPDATE T_MCRE0_RWA_POSIZIONE
            SET FLG_VALIDITA = -2,
                DTA_UPD = SYSDATE
            WHERE COD_ABI = P_COD_ABI
            AND COD_NDG = P_COD_NDG
            AND COD_SNDG = P_COD_SNDG
            AND COD_UO_POSIZ = P_COD_UO_POSIZ
            AND COD_STATO = P_COD_STATO
            AND TRUNC(DTA_DECOR_STATO) = TRUNC(P_DTA_DECOR_STATO)
            AND COD_FUNZIONALITA = P_COD_FUNZIONALITA
            AND COD_BS = P_COD_BS
            AND COD_MATRICOLA = P_COD_MATRICOLA
            AND VAL_STORICO = 0;
        ELSE
            PKG_MCRE0_AUDIT.LOG_APP(V_SEQ, V_PROC, 1, SQLCODE, SQLERRM, V_NOTE, P_COD_MATRICOLA);
            RETURN KO;
        END IF;

        PKG_MCRE0_AUDIT.LOG_APP(V_SEQ, V_PROC, 3, SQLCODE, SQLERRM, V_NOTE, P_COD_MATRICOLA);

        RETURN OK;

        EXCEPTION
            WHEN OTHERS
            THEN
                PKG_MCRE0_AUDIT.LOG_APP(V_SEQ, V_PROC, 1, SQLCODE, SQLERRM, V_NOTE, P_COD_MATRICOLA);
                RETURN KO;

END FNC_SYNC_NO_UPDATE_RWA_POS;

--FUNZIONE DI STORICIZZAZIONE DI UN RECORD DI SINCRONIZZAZIONE "USATO"
-- %return 1 -> se l'insert e' andata a buon fine, 0 altrimenti
FUNCTION FNC_STOR_SYNC_RWA_POS
    (P_COD_ABI                     IN T_MCRE0_RWA_POSIZIONE.COD_ABI%TYPE,
     P_COD_NDG                     IN T_MCRE0_RWA_POSIZIONE.COD_NDG%TYPE,
     P_COD_SNDG                     IN T_MCRE0_RWA_POSIZIONE.COD_SNDG%TYPE,
     P_COD_UO_POSIZ             IN T_MCRE0_RWA_POSIZIONE.COD_UO_POSIZ%TYPE,
     P_COD_STATO                 IN T_MCRE0_RWA_POSIZIONE.COD_STATO%TYPE,
     P_DTA_DECOR_STATO    IN T_MCRE0_RWA_POSIZIONE.DTA_DECOR_STATO%TYPE,
     P_COD_FUNZIONALITA    IN T_MCRE0_RWA_POSIZIONE.COD_FUNZIONALITA%TYPE,
   P_COD_BS           IN T_MCRE0_RWA_POSIZIONE.COD_BS%TYPE,
   P_COD_MATRICOLA    IN T_MCRE0_WRK_AUDIT_APPLICATIVO.UTENTE%TYPE DEFAULT NULL)
RETURN NUMBER IS
    V_NOTE                        T_MCRE0_WRK_AUDIT_APPLICATIVO.NOTE%TYPE;
    V_PROC                        T_MCRE0_WRK_AUDIT_APPLICATIVO.PROCEDURA%TYPE := PKG_MCRE0_GEST_POS.C_PACKAGE||'.FNC_STOR_SYNC_RWA_POS';
    V_SEQ                        NUMBER;
    V_COUNT                        NUMBER;

    BEGIN
        V_NOTE := 'P_COD_ABI = ' || P_COD_ABI ||
                  ', P_COD_NDG = ' || P_COD_NDG ||
                  ', P_COD_SNDG = ' || P_COD_SNDG ||
                  ', P_COD_UO_POSIZ = ' || P_COD_UO_POSIZ ||
                  ', P_COD_STATO = ' || P_COD_STATO ||
                  ', P_DTA_DECOR_STATO = ' || P_DTA_DECOR_STATO ||
                  ', P_COD_FUNZIONALITA = ' || P_COD_FUNZIONALITA ||
          ', P_COD_BS = ' || P_COD_BS ||
          ', P_COD_MATRICOLA = ' || P_COD_MATRICOLA || CHR(10);

        SELECT SEQ_MCR0_LOG_APP.NEXTVAL
        INTO V_SEQ
        FROM DUAL;

        SELECT COUNT(*)
        INTO V_COUNT
        FROM T_MCRE0_RWA_POSIZIONE
        WHERE COD_ABI = P_COD_ABI
        AND COD_NDG = P_COD_NDG
        AND COD_SNDG = P_COD_SNDG
        AND COD_UO_POSIZ = P_COD_UO_POSIZ
        AND COD_STATO = P_COD_STATO
        AND TRUNC(DTA_DECOR_STATO) = TRUNC(P_DTA_DECOR_STATO)
        AND COD_FUNZIONALITA = P_COD_FUNZIONALITA
        AND COD_BS = P_COD_BS
        AND COD_MATRICOLA = P_COD_MATRICOLA
        AND VAL_STORICO = 0;

        IF
            V_COUNT = 1
        THEN
            UPDATE T_MCRE0_RWA_POSIZIONE
            SET VAL_STORICO = VAL_STORICO + 1,
                DTA_UPD = SYSDATE
            WHERE COD_ABI = P_COD_ABI
            AND COD_NDG = P_COD_NDG
            AND COD_SNDG = P_COD_SNDG
            AND COD_UO_POSIZ = P_COD_UO_POSIZ
            AND COD_STATO = P_COD_STATO
            AND TRUNC(DTA_DECOR_STATO) = TRUNC(P_DTA_DECOR_STATO)
            AND COD_FUNZIONALITA = P_COD_FUNZIONALITA
            AND COD_BS = P_COD_BS
            AND COD_MATRICOLA = P_COD_MATRICOLA;
        ELSE
            PKG_MCRE0_AUDIT.LOG_APP(V_SEQ, V_PROC, 1, SQLCODE, SQLERRM, V_NOTE, P_COD_MATRICOLA);
            RETURN KO;
        END IF;

        PKG_MCRE0_AUDIT.LOG_APP(V_SEQ, V_PROC, 3, SQLCODE, SQLERRM, V_NOTE, P_COD_MATRICOLA);

        RETURN OK;

        EXCEPTION WHEN OTHERS
            THEN
                PKG_MCRE0_AUDIT.LOG_APP(V_SEQ, V_PROC, 1, SQLCODE, SQLERRM, V_NOTE, P_COD_MATRICOLA);
                RETURN OK;

END FNC_STOR_SYNC_RWA_POS;

FUNCTION FNC_UPD_GEST_PDF  (p_cod_abi  VARCHAR2,
                            p_cod_ndg        VARCHAR2,
                            p_cod_sndg       VARCHAR2,
                            p_cod_macrostato VARCHAR2,
                            p_id_object      VARCHAR2,
                            p_cod_matricola  VARCHAR2)
                            RETURN NUMBER IS

    v_note VARCHAR2(2000);
    BEGIN
       v_note := 'UPDATE ID_OBJECT =' || p_id_object || 'PER T_MCRE0_APP_GEST_PDF';

       UPDATE T_MCRE0_APP_GEST_PDF
        SET ID_OBJECT = p_id_object,
                VAL_UTENTE = p_cod_matricola,
                DTA_UPD = SYSDATE
       WHERE  COD_ABI_CARTOLARIZZATO = p_cod_abi
       AND COD_NDG = p_cod_ndg
       AND COD_SNDG = p_cod_sndg
       AND COD_MACROSTATO = p_cod_macrostato
       AND FLG_DELETE = 'N';

       RETURN OK;

    EXCEPTION WHEN OTHERS THEN
        pkg_mcre0_audit.log_app(c_package || '.FNC_UPD_GEST_PDF ', 1, SQLCODE, SQLERRM, v_note, p_cod_matricola);

        RETURN KO;

END FNC_UPD_GEST_PDF;


END PKG_MCRE0_GEST_POS;
/


CREATE SYNONYM MCRE_APP.PKG_MCRE0_GEST_POS FOR MCRE_OWN.PKG_MCRE0_GEST_POS;


CREATE SYNONYM MCRE_USR.PKG_MCRE0_GEST_POS FOR MCRE_OWN.PKG_MCRE0_GEST_POS;


GRANT EXECUTE, DEBUG ON MCRE_OWN.PKG_MCRE0_GEST_POS TO MCRE_USR;

