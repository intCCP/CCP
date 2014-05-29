CREATE OR REPLACE PACKAGE MCRE_OWN.PKG_MCRE0_GEST_POS AS
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
  C_PACKAGE CONSTANT VARCHAR2(50) := 'PKG_MCRE0_GEST_POS';
  V_COD_ADVISOR_VAL  VARCHAR2(32);
  V_COD_ANOMALIA_VAL VARCHAR2(32);
  OK         CONSTANT NUMBER := 1;
  KO         CONSTANT NUMBER := 0;

-- %usage  Function di INSERT, UPDATE, DELETE su T_MCRE0_APP_GEST_ADVISOR
-- %d tabella di log T_MCRE0_WRK_AUDIT_APPLICATIVO
-- %param P_AZIONE I -> INSERT, U -> UPDATE, D -> DELETE LOGICA
-- %param P_COD_ADVISOR viene sovrascritto solo se P_AZIONE = I con il nuovo codice advisor generato, altrimenti non viene sovrascritto
-- %return 1 -> se l'azione e' andata a buon fine, 0 altrimenti
   FUNCTION FNC_GEST_ADVISOR_IUD(P_AZIONE      IN VARCHAR2, --OBBLIGA TORIO
                               P_COD_ADVISOR  IN OUT           T_MCRE0_APP_GEST_ADVISOR.COD_ADVISOR%TYPE, --OBBLIGA TORIO
                               P_COD_MATRICOLA          IN T_MCRE0_WRK_AUDIT_APPLICATIVO.UTENTE%TYPE, --OBBLIGA TORIO(anche NULL e' ok)
                               P_ID_ADVISOR_CONSULENZA  IN T_MCRE0_APP_GEST_ADVISOR.ID_ADVISOR_CONSULENZA%TYPE DEFAULT NULL,
                               P_ID_ADVISOR_GR_GESTIONE IN T_MCRE0_APP_GEST_ADVISOR.ID_ADVISOR_GR_GESTIONE%TYPE DEFAULT NULL,
                               P_ID_ADVISOR_GR_ISP      IN T_MCRE0_APP_GEST_ADVISOR.ID_ADVISOR_GR_ISP%TYPE DEFAULT NULL,
                               P_COD_ABI_CARTOLARIZZATO IN T_MCRE0_APP_GEST_ADVISOR.COD_ABI_CARTOLARIZZATO%TYPE DEFAULT NULL,
                               p_COD_NDG                IN T_MCRE0_APP_GEST_ADVISOR.COD_NDG%TYPE DEFAULT NULL,
                               P_COD_SNDG               IN T_MCRE0_APP_GEST_ADVISOR.COD_SNDG%TYPE DEFAULT NULL,
                               P_COD_MACROSTATO         IN T_MCRE0_APP_GEST_ADVISOR.COD_MACROSTATO%TYPE DEFAULT NULL
                               )RETURN NUMBER;

-- %usage  Function di UPDATE di T_MCRE0_APP_GEST_POSIZIONE durante il workflow
-- %d tabella di log T_MCRE0_WRK_AUDIT_APPLICATIVO
-- %return 1 -> se l'aggiornamento e' andata a buon fine, 0 altrimenti
   FUNCTION FNC_GEST_POSIZIONE_UWF(P_COD_ABI_CARTOLARIZZATO IN T_MCRE0_APP_GEST_POSIZIONE.COD_ABI_CARTOLARIZZATO%TYPE,
                                   P_COD_NDG                IN T_MCRE0_APP_GEST_POSIZIONE.COD_NDG%TYPE,
                                   P_COD_MACROSTATO         IN T_MCRE0_APP_GEST_POSIZIONE.COD_MACROSTATO%TYPE,
                                   P_FLG_WORKFLOW           IN T_MCRE0_APP_GEST_POSIZIONE.FLG_WORKFLOW%TYPE,
                                   P_COD_MATRICOLA          IN T_MCRE0_WRK_AUDIT_APPLICATIVO.UTENTE%TYPE,
                                    P_DTA_UPD_WORKFLOW       IN T_MCRE0_APP_GEST_POSIZIONE.DTA_UPD_WORKFLOW%TYPE DEFAULT NULL)
                           RETURN NUMBER;

-- %usage  Function di INSERT di T_MCRE0_APP_GEST_POSIZIONE
-- %d tabella di log T_MCRE0_WRK_AUDIT_APPLICATIVO
-- %return 1 -> se l'insert e' andata a buon fine, 0 altrimenti
       FUNCTION FNC_GEST_POSIZIONE_INR(P_COD_ABI_CARTOLARIZZATO IN T_MCRE0_APP_GEST_POSIZIONE.COD_ABI_CARTOLARIZZATO%TYPE,
                                       P_COD_NDG                IN T_MCRE0_APP_GEST_POSIZIONE.COD_NDG%TYPE,
                                       P_COD_MACROSTATO         IN T_MCRE0_APP_GEST_POSIZIONE.COD_MACROSTATO%TYPE,
                                       P_COD_SNDG               IN T_MCRE0_APP_GEST_POSIZIONE.COD_SNDG%TYPE,
                                       P_COD_STATO_RISCHIO      IN T_MCRE0_APP_GEST_POSIZIONE.COD_STATO_RISCHIO%TYPE,
                                       P_COD_MATRICOLA          IN T_MCRE0_WRK_AUDIT_APPLICATIVO.UTENTE%TYPE
                                      )
                           RETURN NUMBER;


-- %usage  Function di UPDATE di T_MCRE0_APP_GEST_POSIZIONE per ci campi del BOX CLASSIFICAZIONE
-- %d tabella di log T_MCRE0_WRK_AUDIT_APPLICATIVO
-- %return 1 -> se l'aggiornamento e' andata a buon fine, 0 altrimenti
       FUNCTION FNC_GEST_POSIZIONE_UBC(P_COD_ABI_CARTOLARIZZATO IN T_MCRE0_APP_GEST_POSIZIONE.COD_ABI_CARTOLARIZZATO%TYPE,
                                       P_COD_NDG                IN T_MCRE0_APP_GEST_POSIZIONE.COD_NDG%TYPE,
                                       P_COD_MACROSTATO         IN T_MCRE0_APP_GEST_POSIZIONE.COD_MACROSTATO%TYPE,
                                       P_COD_MACROSTATO_DESTINAZIONE   IN T_MCRE0_APP_GEST_POSIZIONE.COD_MACROSTATO_DESTINAZIONE%TYPE,
                                       P_NOTE_CLASSIFICAZIONE          IN T_MCRE0_APP_GEST_POSIZIONE.NOTE_CLASSIFICAZIONE%TYPE,
                                       P_FLG_LETTURA_VERBALE           IN T_MCRE0_APP_GEST_POSIZIONE.FLG_LETTURA_VERBALE%TYPE,
                                       P_COD_MATRICOLA          IN T_MCRE0_WRK_AUDIT_APPLICATIVO.UTENTE%TYPE
                                      )
                           RETURN NUMBER;

-- %usage  Function di INSERT, DELETE su T_MCRE0_APP_GEST_ANOMALIE
-- %d tabella di log T_MCRE0_WRK_AUDIT_APPLICATIVO
-- %param P_AZIONE I -> INSERT, D -> DELETE LOGICA
-- %param P_COD_ANOMALIA viene sovrascritto solo se P_AZIONE = I con il nuovo codice anomalia generato, altrimenti non viene sovrascritto
-- %return 1 -> se l'azione e' andata a buon fine, 0 altrimenti
   FUNCTION FNC_GEST_ANOMALIA_ID(P_AZIONE      IN VARCHAR2, --OBBLIGATORIO
                                P_COD_ANOMALIA            IN OUT T_MCRE0_APP_GEST_ANOMALIE.COD_ANOMALIA%TYPE,--OBBLIGATORIO
                                P_COD_MATRICOLA           IN T_MCRE0_WRK_AUDIT_APPLICATIVO.UTENTE%TYPE,
                                P_COD_ABI_CARTOLARIZZATO  IN T_MCRE0_APP_GEST_ANOMALIE.COD_ABI_CARTOLARIZZATO%TYPE DEFAULT NULL,
                                P_COD_NDG                 IN T_MCRE0_APP_GEST_ANOMALIE.COD_NDG%TYPE DEFAULT NULL,
                                P_COD_SNDG                IN T_MCRE0_APP_GEST_ANOMALIE.COD_SNDG%TYPE DEFAULT NULL,
                                P_DESC_ANOMALIA           IN T_MCRE0_APP_GEST_ANOMALIE.DESC_ANOMALIA%TYPE DEFAULT NULL,
                                P_FLG_GRUPPO_ECONOMICO    IN T_MCRE0_APP_GEST_ANOMALIE.FLG_GRUPPO_ECONOMICO%TYPE DEFAULT NULL,
                                P_COD_MACROSTATO          IN T_MCRE0_APP_GEST_ANOMALIE.COD_MACROSTATO%TYPE DEFAULT NULL
                               )RETURN NUMBER;

-- %usage  Function di INSERT, UPDATE, DELETE su T_MCRE0_APP_GEST_PRATICA_FASI
-- %d tabella di log T_MCRE0_WRK_AUDIT_APPLICATIVO
-- %param P_AZIONE I -> INSERT, U -> UPDATE, D -> DELETE LOGICA
-- %param COD_PRAT_FASE viene sovrascritto solo se P_AZIONE = I con il nuovo codice pratica generato, altrimenti non viene sovrascritto
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
                               P_COD_MACROSTATO         IN T_MCRE0_APP_GEST_PRATICA_FASI.COD_MACROSTATO%TYPE DEFAULT NULL) RETURN NUMBER;


FUNCTION FNC_GEST_PDF(p_abi             VARCHAR2,
                      p_ndg             VARCHAR2,
                      p_sndg            VARCHAR2,
                      p_utente          VARCHAR2,
                      p_tipo_operazione VARCHAR2,
                      p_cod_macrostato VARCHAR2) RETURN NUMBER;

FUNCTION FNC_GEST_POSIZIONE_UBP(P_COD_ABI_CARTOLARIZZATO IN T_MCRE0_APP_GEST_POSIZIONE.COD_ABI_CARTOLARIZZATO%TYPE,
                                       P_COD_NDG IN T_MCRE0_APP_GEST_POSIZIONE.COD_NDG%TYPE,
                                       P_COD_MACROSTATO IN T_MCRE0_APP_GEST_POSIZIONE.COD_MACROSTATO%TYPE,
                                       P_MOTIVO_PROROGA IN T_MCRE0_APP_GEST_POSIZIONE.MOTIVO_PROROGA%TYPE,
                                       P_COD_MATRICOLA IN T_MCRE0_WRK_AUDIT_APPLICATIVO.UTENTE%TYPE
                                      )
                           RETURN NUMBER;

---------RWA-----------------
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
RETURN NUMBER;

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
RETURN NUMBER;

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
RETURN NUMBER;

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
RETURN NUMBER;

FUNCTION FNC_UPD_GEST_PDF  (p_cod_abi  VARCHAR2,
                            p_cod_ndg        VARCHAR2,
                            p_cod_sndg       VARCHAR2,
                            p_cod_macrostato VARCHAR2,
                            p_id_object      VARCHAR2,
                            p_cod_matricola  VARCHAR2)
                            RETURN NUMBER;
END PKG_MCRE0_GEST_POS;
/


CREATE SYNONYM MCRE_APP.PKG_MCRE0_GEST_POS FOR MCRE_OWN.PKG_MCRE0_GEST_POS;


CREATE SYNONYM MCRE_USR.PKG_MCRE0_GEST_POS FOR MCRE_OWN.PKG_MCRE0_GEST_POS;


GRANT EXECUTE, DEBUG ON MCRE_OWN.PKG_MCRE0_GEST_POS TO MCRE_USR;

