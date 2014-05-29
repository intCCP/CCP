CREATE OR REPLACE PACKAGE BODY MCRE_OWN.PKG_MCRES_GEST_CONFERIMENTI AS
  /******************************************************************************
  NAME:       PKG_MCRES_GEST_CONFERIMENTI
  PURPOSE:

  REVISIONS:
  Ver        Date        Author           Description
  ---------  ----------  ---------------  ------------------------------------
  1.0        14/01/2013  M.Murro          Created this package body.
  1.1        23/07/2013  T.Bernardi       Aggiunte procedure archiviazione.
  ******************************************************************************/

  n number := 0;

  -- setta data chiusura per le entita' non aggiornate da piu' di 6 giorni (parametrico!)
  function archiviatore return number is

  --gestisco archiviazione per singola entita'
  begin
  null;
  end archiviatore;


  PROCEDURE ARCHIVIA_PRATICHE
  as
    c_nome varchar2(128) := c_package||'.archivia_pratiche';

    BEGIN


MERGE INTO T_MCRES_APP_PRATICHE TGT
USING(SELECT
      ID_DPER,
      COD_ABI,
      COD_NDG,
      VAL_ANNO,
      COD_PRATICA,
      DTA_APERTURA,
      CASE WHEN ID_DPER <>0 THEN
            TO_DATE (ID_DPER,'YYYYMMDD')
            ELSE SYSDATE
      END DTA_CLOSE,
      COD_UO_PRATICA,
      COD_MATR_PRATICA,
      DTA_ASSEGN_ADDET,
      FLG_ATTIVA,
      DTA_INS,
      DTA_UPD,
      COD_OPERATORE_INS_UPD,
      COD_SNDG,
      DTA_ASSEGN_UO,
      COD_TIPO_GESTIONE,
      FLG_GESTIONE
      FROM T_MCRES_APP_PRATICHE
      WHERE ID_DPER < (SELECT (MAX(ID_DPER)-6) FROM MCRE_OWN.T_MCRES_APP_PRATICHE)
      AND DTA_CHIUSURA = to_date('31/12/9999','DD/MM/YYYY')
      AND FLG_ATTIVA= 1
      )SRC
      ON(TGT.COD_ABI=SRC.COD_ABI AND TGT.COD_NDG = SRC.COD_NDG AND TGT.VAL_ANNO=SRC.VAL_ANNO AND TGT.COD_PRATICA=SRC.COD_PRATICA AND SRC.FLG_ATTIVA ='0')
      WHEN NOT MATCHED THEN INSERT
        (
        TGT.ID_DPER,
      TGT.COD_ABI,
      TGT.COD_NDG,
      TGT.VAL_ANNO,
      TGT.COD_PRATICA,
      TGT.DTA_APERTURA,
      TGT.DTA_CHIUSURA,
      TGT.COD_UO_PRATICA,
      TGT.COD_MATR_PRATICA,
      TGT.DTA_ASSEGN_ADDET,
      TGT.FLG_ATTIVA,
      TGT.DTA_INS,
      TGT.DTA_UPD,
      TGT.COD_OPERATORE_INS_UPD,
      TGT.COD_SNDG,
      TGT.DTA_ASSEGN_UO,
      TGT.COD_TIPO_GESTIONE,
      TGT.FLG_GESTIONE
        )
        VALUES
        (
        SRC.ID_DPER,
        SRC.COD_ABI,
        SRC.COD_NDG,
        SRC.VAL_ANNO,
        SRC.COD_PRATICA,
        SRC.DTA_APERTURA,
        SRC.DTA_CLOSE,
        SRC.COD_UO_PRATICA,
        SRC.COD_MATR_PRATICA,
        SRC.DTA_ASSEGN_ADDET,
        '0',
        SRC.DTA_INS,
        SRC.DTA_UPD,
        'BATCH',
        SRC.COD_SNDG,
        SRC.DTA_ASSEGN_UO,
        SRC.COD_TIPO_GESTIONE,
        SRC.FLG_GESTIONE
        )
        ;


        DELETE FROM T_MCRES_APP_PRATICHE
        WHERE ID_DPER < (SELECT (MAX(ID_DPER)-6) FROM MCRE_OWN.T_MCRES_APP_PRATICHE)
        AND DTA_CHIUSURA = TO_DATE('31/12/9999','DD/MM/YYYY')
        AND FLG_ATTIVA= 1
         ;

 PKG_MCRES_AUDIT.LOG_APP(C_NOME,PKG_MCRES_AUDIT.C_DEBUG,SQLCODE,SQLERRM,'chiusi '||SQL%ROWCOUNT||' pratiche', 'BATCH');
 commit;

EXCEPTION WHEN OTHERS THEN
    pkg_mcres_audit.log_app(c_nome,pkg_mcres_audit.c_error,sqlcode,sqlerrm,'errore chiusura pratiche', 'BATCH');
    rollback;

END ARCHIVIA_PRATICHE;



PROCEDURE ARCHIVIA_RAPPORTI
  as
    c_nome varchar2(128) := c_package||'.archivia_rapporti';

    BEGIN


UPDATE T_MCRES_APP_RAPPORTI r1 SET(r1.DTA_CHIUSURA_RAPP,r1.COD_OPERATORE_INS_UPD) =
                                (SELECT
                                      CASE WHEN R2.ID_DPER <>0 THEN
                                      TO_DATE (r2.ID_DPER,'YYYYMMDD')
                                      ELSE SYSDATE
                                      END ,
                                      'BATCH'
                                  FROM T_MCRES_APP_RAPPORTI R2
                                  where R1.COD_ABI=R1.COD_ABI and R1.COD_NDG = R2.COD_NDG and R1.COD_RAPPORTO=R2.COD_RAPPORTO
                                 )
                                  WHERE R1.ID_DPER < (SELECT (MAX(ID_DPER)-6) FROM MCRE_OWN.T_MCRES_APP_RAPPORTI)
                                  AND R1.DTA_CHIUSURA_RAPP = TO_DATE('31/12/9999','DD/MM/YYYY')
                                  ;

PKG_MCRES_AUDIT.LOG_APP(C_NOME,PKG_MCRES_AUDIT.C_DEBUG,SQLCODE,SQLERRM,'chiusi '||SQL%ROWCOUNT||' rapporti', 'BATCH');
 commit;

EXCEPTION WHEN OTHERS THEN
    pkg_mcres_audit.log_app(c_nome,pkg_mcres_audit.c_error,sqlcode,sqlerrm,'errore chiusura rapporti', 'BATCH');
    rollback;

END ARCHIVIA_RAPPORTI;




PROCEDURE ARCHIVIA_GARANZIE
  as
    c_nome varchar2(128) := c_package||'.archivia_garanzie';

    BEGIN


UPDATE T_MCRES_APP_GARANZIE r1 SET(r1.DTA_SCADENZA_GARANZIA,r1.COD_OPERATORE_INS_UPD) =
                                (SELECT
                                      CASE WHEN R2.ID_DPER <>0 THEN
                                      TO_DATE (r2.ID_DPER,'YYYYMMDD')
                                      ELSE SYSDATE
                                      END ,
                                      'BATCH'
                                  FROM T_MCRES_APP_GARANZIE R2
                                  where R1.COD_ABI=R1.COD_ABI and R1.COD_NDG = R2.COD_NDG and R1.COD_GARANZIA=R2.COD_GARANZIA and R1.COD_NDG_GARANTE=R2.COD_NDG_GARANTE
                                 )
                                  WHERE R1.ID_DPER < (SELECT (MAX(ID_DPER)-6) FROM MCRE_OWN.T_MCRES_APP_GARANZIE)
                                  AND R1.DTA_SCADENZA_GARANZIA = TO_DATE('31/12/9999','DD/MM/YYYY')
                                  ;



PKG_MCRES_AUDIT.LOG_APP(C_NOME,PKG_MCRES_AUDIT.C_DEBUG,SQLCODE,SQLERRM,'chiuse '||SQL%ROWCOUNT||' garanzie', 'BATCH');
 commit;

EXCEPTION WHEN OTHERS THEN
    pkg_mcres_audit.log_app(c_nome,pkg_mcres_audit.c_error,sqlcode,sqlerrm,'errore chiusura garanzie', 'BATCH');
    rollback;

END ARCHIVIA_GARANZIE;




PROCEDURE ARCHIVIA_POSIZIONI
  AS
    c_nome varchar2(128) := c_package||'.archivia_posizioni';

    BEGIN




MERGE INTO T_MCRES_APP_POSIZIONI TGT
USING(
      SELECT
            ID_DPER	,
            COD_ABI	,
            COD_NDG	,
            DTA_PASSAGGIO_SOFF	,
            CASE WHEN ID_DPER <>0 THEN
                  TO_DATE (ID_DPER,'YYYYMMDD')
                  ELSE SYSDATE
            END DTA_CLOSE,
            COD_STATO_RISCHIO	,
            COD_STATO_GIURIDICO	,
            FLG_ART_498	,
            COD_UO_ART_498	,
            FLG_FONDI_TERZI	,
            FLG_RAPP_CARTOLARIZZATI	,
            FLG_RAPP_ESTERI	,
            FLG_CONFERIMENTO	,
            DTA_CONFERIMENTO	,
            COD_SNDG	,
            FLG_ATTIVA	,
            DTA_INS	,
            DTA_UPD	,
            COD_OPERATORE_INS_UPD	,
            COD_FILIALE_PRINCIPALE	,
            FLG_SGR_FONDI
            FROM T_MCRES_APP_POSIZIONI
            WHERE ID_DPER < (SELECT (MAX(ID_DPER)-6) FROM MCRE_OWN.T_MCRES_APP_POSIZIONI)
            AND DTA_CHIUSURA = TO_DATE('31/12/9999','DD/MM/YYYY')
            AND FLG_ATTIVA ='1'
            )SRC
            ON(TGT.COD_ABI=SRC.COD_ABI AND TGT.COD_NDG = SRC.COD_NDG AND TGT.DTA_PASSAGGIO_SOFF=SRC.DTA_PASSAGGIO_SOFF AND TGT.COD_STATO_RISCHIO=SRC.COD_STATO_RISCHIO AND SRC.FLG_ATTIVA ='0')
WHEN NOT MATCHED THEN INSERT
        (
        TGT.	ID_DPER	,
        TGT.	COD_ABI	,
        TGT.	COD_NDG	,
        TGT.	DTA_PASSAGGIO_SOFF	,
        TGT.	DTA_CHIUSURA	,
        TGT.	COD_STATO_RISCHIO	,
        TGT.	COD_STATO_GIURIDICO	,
        TGT.	FLG_ART_498	,
        TGT.	COD_UO_ART_498	,
        TGT.	FLG_FONDI_TERZI	,
        TGT.	FLG_RAPP_CARTOLARIZZATI	,
        TGT.	FLG_RAPP_ESTERI	,
        TGT.	FLG_CONFERIMENTO	,
        TGT.	DTA_CONFERIMENTO	,
        TGT.	COD_SNDG	,
        TGT.	FLG_ATTIVA	,
        TGT.	DTA_INS	,
        TGT.	DTA_UPD	,
        TGT.	COD_OPERATORE_INS_UPD	,
        TGT.	COD_FILIALE_PRINCIPALE	,
        TGT.	FLG_SGR_FONDI
        )
        VALUES
        (
        SRC.	ID_DPER	,
        SRC.	COD_ABI	,
        SRC.	COD_NDG	,
        SRC.	DTA_PASSAGGIO_SOFF	,
        SRC.	DTA_CLOSE	,
        SRC.	COD_STATO_RISCHIO	,
        SRC.	COD_STATO_GIURIDICO	,
        SRC.	FLG_ART_498	,
        SRC.	COD_UO_ART_498	,
        SRC.	FLG_FONDI_TERZI	,
        SRC.	FLG_RAPP_CARTOLARIZZATI	,
        SRC.	FLG_RAPP_ESTERI	,
        SRC.	FLG_CONFERIMENTO	,
        SRC.	DTA_CONFERIMENTO	,
        SRC.	COD_SNDG	,
        '0'	,
        SRC.	DTA_INS	,
        SRC.	DTA_UPD	,
        'BATCH',
        SRC.	COD_FILIALE_PRINCIPALE	,
        SRC.	FLG_SGR_FONDI
        )
        ;



        DELETE FROM T_MCRES_APP_POSIZIONI
        WHERE ID_DPER < (SELECT (MAX(ID_DPER)-6) FROM MCRE_OWN.T_MCRES_APP_POSIZIONI)
        AND DTA_CHIUSURA = TO_DATE('31/12/9999','DD/MM/YYYY')
        AND FLG_ATTIVA ='1'
        ;




PKG_MCRES_AUDIT.LOG_APP(C_NOME,PKG_MCRES_AUDIT.C_DEBUG,SQLCODE,SQLERRM,'chiuse '||SQL%ROWCOUNT||' posizioni', 'BATCH');
 commit;

EXCEPTION WHEN OTHERS THEN
    pkg_mcres_audit.log_app(c_nome,pkg_mcres_audit.c_error,sqlcode,sqlerrm,'errore chiusura posizioni', 'BATCH');
    rollback;

END ARCHIVIA_POSIZIONI;


END pkg_mcres_gest_conferimenti;
/


GRANT EXECUTE, DEBUG ON MCRE_OWN.PKG_MCRES_GEST_CONFERIMENTI TO MCRE_USR;

