CREATE OR REPLACE PACKAGE BODY MCRE_OWN."PKG_MCRE0_CR" AS
/******************************************************************************
   NAME:     PKG_MCRE0_CR

   REVISIONS:
   Ver        Date        Author             Description
   ---------  ----------  -----------------  ------------------------------------
   1.0        25/10/2011  Luca Ferretti      Created this package.
   1.1        10/05/2011  Luca Ferretti      Modifica fnc_clean_cr
   1.2        19/05/2011  Luca Ferretti      Aggiunta controllo presenza flussi nuovi
   1.3        20/05/2011  Luca Ferretti      Parametrizzazione valori di uscita (ok=0, ko=1)
   1.4        08/07/2011  Luca Ferretti      Modificate funzion clean_cr (1, 3 e 4)
   2.0        11/07/2011  Luca Ferretti      Aggiornamento logica sbiancamento
   2.1        11/07/2011  Marco Murro        Se ok, return 1!
   2.2        08/09/2011  Marco Murro        fix ge_gb: calcolo per sndg e QIS numerico
   2.3        27/09/2011  Marco Murro        fix sndg, return, clean..
   2.4        08/10/2012  Luca Ferretti      Modifica parametro di ritorno per file già caricati
   2.5        18/12/2012  Marco Murro        fix logica aggiornamneto app_cr - commentata clean
   2.6        02/04/2013  Marco Murro        rimosso controllo iniziale caricamneto app_cr 
******************************************************************************/

--    ko      number  := 1;
--    val_ok  number  := 0;
    ko      number  := 0;
    val_ok  number  := 1;
    seq     number;

FUNCTION FNC_LOAD_CR(
    P_COD_LOG T_MCRE0_WRK_AUDIT_ETL.ID%TYPE DEFAULT NULL) RETURN NUMBER IS
        
    cr_scsb_data        date;
    cr_scgb_data        date;
    cr_gesb_data        date;
    cr_gegb_data        date;
    cr_glgb_data        date;
    scsb_data           date;
    scgb_data           date;
    gesb_data           date;
    gegb_data           date;
    glgb_data           date;


    BEGIN
        
    IF( P_COD_LOG IS NULL) THEN
        SELECT SEQ_MCR0_LOG_ETL.NEXTVAL
        INTO seq
        FROM DUAL;
    ELSE
      seq := P_COD_LOG;
    end if;

       -- Se sono arrivati dei flussi nuovi allora li carico, altrimenti non faccio niente
       select max(cr.SCSB_DTA_CR) into cr_scsb_data from t_mcre0_app_cr24 cr;
       select max(cr.SCGB_DTA_RIF_CR) into cr_scgb_data from t_mcre0_app_cr24 cr;
       select max(cr.GESB_DTA_CR) into cr_gesb_data from t_mcre0_app_cr24 cr;
       select max(cr.GEGB_DTA_RIF_CR) into cr_gegb_data from t_mcre0_app_cr24 cr;
       select max(cr.GLGB_DTA_RIF_CR) into cr_glgb_data from t_mcre0_app_cr24 cr;

       select max(DTA_CR_SCSB) into scsb_data from t_mcre0_app_cr_sc_sb24 scsb;
       select max(DTA_RIFERIMENTO_CR) into scgb_data from t_mcre0_app_cr_sc_gb24 scgb;
       select max(DTA_CR_GESB) into gesb_data from t_mcre0_app_cr_ge_sb24 gesb;
       select max(DTA_RIFERIMENTO_CR) into gegb_data from t_mcre0_app_cr_ge_gb24 gegb;
       select max(DTA_RIFERIMENTO_CR) into glgb_data from t_mcre0_app_cr_lg_gb24 glgb;

    --v2.6 commento intero blocco.. si lasciano i singoli check
--    --v2.5 modificati OR in AND.. esco solo se TUTTI UGUALI
--       if(cr_scsb_data=scsb_data and
--          cr_scgb_data=scgb_data and
--          cr_gesb_data=gesb_data and
--          cr_gegb_data=gegb_data and
--          cr_glgb_data=glgb_data )  then
--            PKG_MCRE0_AUDIT.log_etl (seq, 'FNC_LOAD_CR', 3, sqlcode, 'i file arrivati hanno lo stesso periodo di riferimento di quelli già caricati', NULL);
--            return val_ok; --v2.1 val_ok;
--       end if;
--       -- fine modifica 1.2

       --nuovi controlli per il lancio delle merge - v2.5
       if(cr_scsb_data!=scsb_data) then --aggiorno scsb
           PKG_MCRE0_AUDIT.log_etl(seq, 'FNC_LOAD_CR', 3, sqlcode, 'SCSB', null);
           val_ok := fnc_load_cr_sc_sb(seq);
           if(val_ok=ko)then 
            PKG_MCRE0_AUDIT.log_etl(seq, 'FNC_LOAD_CR', 1, sqlcode, sqlerrm, 'errore su CR SCSB');
           end if;
       end if;
       
       if(cr_scgb_data!=scgb_data) then --aggiorno scgb
           PKG_MCRE0_AUDIT.log_etl(seq, 'FNC_LOAD_CR', 3, sqlcode, 'SCGB', null);
           val_ok := fnc_load_cr_sc_gb(seq);
           if(val_ok=ko)then 
            PKG_MCRE0_AUDIT.log_etl(seq, 'FNC_LOAD_CR', 1, sqlcode, sqlerrm, 'errore su CR SCGB');
           end if;
       end if;
           
       if(cr_gesb_data!=gesb_data) then --aggiorno gesb
           PKG_MCRE0_AUDIT.log_etl(seq, 'FNC_LOAD_CR', 3, sqlcode, 'GESB', null);
           val_ok := fnc_load_cr_ge_sb(seq);
           if(val_ok=ko)then 
            PKG_MCRE0_AUDIT.log_etl(seq, 'FNC_LOAD_CR', 1, sqlcode, sqlerrm, 'errore su CR GESB');
           end if;
       end if;
           
       if(cr_gegb_data!=gegb_data) then --aggiorno gegb
           PKG_MCRE0_AUDIT.log_etl(seq, 'FNC_LOAD_CR', 3, sqlcode, 'GEGB', null);
           val_ok := fnc_load_cr_ge_gb(seq);
           if(val_ok=ko)then 
            PKG_MCRE0_AUDIT.log_etl(seq, 'FNC_LOAD_CR', 1, sqlcode, sqlerrm, 'errore su CR GEGB');
           end if;
       end if;
           
       if(cr_glgb_data!=glgb_data) then --aggiorno glgb
           PKG_MCRE0_AUDIT.log_etl(seq, 'FNC_LOAD_CR', 3, sqlcode, 'LGGB', null);
           val_ok := fnc_load_cr_lg_gb(seq);
           if(val_ok=ko)then 
            PKG_MCRE0_AUDIT.log_etl(seq, 'FNC_LOAD_CR', 1, sqlcode, sqlerrm, 'errore su CR LGGB');
           end if;
       end if;
       
       --v2.5... clean da ripensare... mostrare un dato vecchio potrebbe non essere troppo errato
--       PKG_MCRE0_AUDIT.log_etl(seq, 'FNC_LOAD_CR', 3, sqlcode, 'DELETE', null);
--       val_ok := fnc_clean_cr(seq);
--       if(val_ok=ko)then return ko; end if;

       return val_ok; --v2.1 val_ok;
    EXCEPTION WHEN OTHERS THEN
--v2.3      RETURN -1;
        RETURN ko;
    END FNC_LOAD_CR;

FUNCTION FNC_CLEAN_CR  (
 P_COD_LOG T_MCRE0_WRK_AUDIT_ETL.ID%TYPE DEFAULT NULL,
 p_id_dper t_mcre0_app_cr_sc_sb24.id_dper%type default null)
 RETURN NUMBER IS

BEGIN
    BEGIN
    /*
     * Non è arrivata la CR
     * Si mettono a null tutti gli attributi relativi al singolo cliente su singola banca
     */
        UPDATE T_MCRE0_APP_CR24 CR
        SET
             SCSB_DTA_CR        = NULL
            ,SCSB_ACC_CR        = NULL
            ,SCSB_GAR_CR        = NULL
            ,SCSB_SCO_CR        = NULL
            ,SCSB_UTI_CR        = NULL
            ,SCSB_COD_NDG       = NULL
            ,SCSB_DTA_INS       = NULL
            ,SCSB_DTA_UPD        = SYSDATE
            ,SCSB_COD_OP_INS_UPD = NULL
            ,SCSB_ID_DPER       = NULL
            ,SCSB_QIS_ACC       = NULL
            ,SCSB_QIS_UTI       = NULL
              where SCSB_ID_DPER < nvl(p_id_dper,(
              select idper
              FROM V_MCRE0_ULTIMA_ACQUISIZIONE
              WHERE COD_FILE = 'FILE_GUIDA' ))
            and exists (
            SELECT DISTINCT 1
            FROM    T_MCRE0_APP_FILE_GUIDA24 F
            WHERE   F.COD_ABI_CARTOLARIZZATO = CR.COD_ABI_CARTOLARIZZATO
            AND     F.COD_NDG = CR.COD_NDG
            AND     F.ID_DPER = (
                SELECT  IDPER
                FROM    V_MCRE0_ULTIMA_ACQUISIZIONE
                WHERE   COD_FILE = 'FILE_GUIDA') );

        COMMIT;

        PKG_MCRE0_AUDIT.log_etl(P_COD_LOG, 'FNC_CLEAN_CR', 3, sqlcode, 'UPDATE NO CR - t_mcre0_app_cr', 'Tutto ok');
    EXCEPTION WHEN OTHERS THEN
        PKG_MCRE0_AUDIT.log_etl(P_COD_LOG, 'FNC_CLEAN_CR', 1, sqlcode, 'UPDATE NO CR - t_mcre0_app_cr', 'SQLERRM='||SQLERRM);
        return ko;
    END;

    BEGIN
    -- Sbianco gli attributi relativi a il gruppo bancario

        UPDATE T_MCRE0_APP_CR24 CR
        SET
            GEGB_DTA_RIF_CR     = NULL,
            GEGB_ACC_CR         = NULL,
            GEGB_ACC_SIS        = NULL,
            GEGB_GAR_CR         = NULL,
            GEGB_GAR_SIS        = NULL,
            GEGB_SCO_CR         = NULL,
            GEGB_SCO_SIS        = NULL,
            GEGB_UTI_CR         = NULL,
            GEGB_UTI_SIS        = NULL,
            GEGB_COD_SNDG       = NULL,
            GEGB_DTA_UPD        = SYSDATE,
            GEGB_COD_OP_INS_UPD = NULL,
            GEGB_QIS_ACC        = NULL,
            GEGB_QIS_UTI        = NULL
        WHERE
            GEGB_ID_DPER < nvl(p_id_dper,(
              select idper
              FROM V_MCRE0_ULTIMA_ACQUISIZIONE
              WHERE COD_FILE = 'FILE_GUIDA' ))
           AND GEGB_ID_DPER IN (
            SELECT ID_DPER FROM (
                SELECT  DISTINCT ID_DPER
                FROM    T_MCRE0_APP_CR_GE_GB24
                WHERE   ID_DPER <= nvl(p_id_dper, id_dper)
                ORDER BY ID_DPER desc)
               WHERE rownum <3)
           and exists (
            select distinct 1
            FROM T_MCRE0_APP_FILE_GUIDA24 F
            where f.cod_abi_cartolarizzato = CR.cod_abi_cartolarizzato
            and f.cod_ndg = CR.cod_ndg
            and f.id_dper = (
                select idper
                from V_MCRE0_ULTIMA_ACQUISIZIONE
                where COD_FILE = 'FILE_GUIDA' ) ) ;
           COMMIT;

        PKG_MCRE0_AUDIT.log_etl(P_COD_LOG, 'FNC_CLEAN_CR', 3, sqlcode, 'UPDATE NO GEGB - t_mcre0_app_cr', 'Tutto ok');
    EXCEPTION WHEN OTHERS THEN
        PKG_MCRE0_AUDIT.log_etl(P_COD_LOG, 'FNC_CLEAN_CR', 1, sqlcode, 'UPDATE NO GEGB - t_mcre0_app_cr', 'SQLERRM='||SQLERRM);
        return ko;
    END;


    BEGIN
    -- Sbianco gli attributi relativi a il gruppo bancario

        UPDATE T_MCRE0_APP_CR24 CR
        SET
            GLGB_COD_SNDG       = NULL,
            GLGB_ACC_CR         = NULL,
            GLGB_UTI_CR         = NULL,
            GLGB_SCO_CR         = NULL,
            GLGB_GAR_CR         = NULL,
            GLGB_ACC_SIS        = NULL,
            GLGB_UTI_SIS        = NULL,
            GLGB_SCO_SIS        = NULL,
            GLGB_IMP_GAR_SIS    = NULL,
            GLGB_DTA_RIF_CR     = NULL,
            GLGB_DTA_UPD        = SYSDATE,
            GLGB_COD_OP_INS_UPD = NULL,
            GLGB_QIS_ACC        = NULL,
            GLGB_QIS_UTI        = NULL
        WHERE
            GEGB_ID_DPER < nvl(p_id_dper,(
              select idper
              FROM V_MCRE0_ULTIMA_ACQUISIZIONE
              WHERE COD_FILE = 'FILE_GUIDA' ))
           AND GEGB_ID_DPER IN (
            SELECT ID_DPER FROM (
                SELECT  DISTINCT ID_DPER
                FROM    T_MCRE0_APP_CR_LG_GB24
                WHERE   ID_DPER <= nvl(p_id_dper, id_dper)
                ORDER BY ID_DPER desc)
               WHERE rownum <3)
           and exists (
            select distinct 1
            FROM T_MCRE0_APP_FILE_GUIDA24 F
            where f.cod_abi_cartolarizzato = CR.cod_abi_cartolarizzato
            and f.cod_ndg = CR.cod_ndg
            and f.id_dper = (
                select idper
                from V_MCRE0_ULTIMA_ACQUISIZIONE
                where COD_FILE = 'FILE_GUIDA' ) ) ;
            COMMIT;

        PKG_MCRE0_AUDIT.log_etl(P_COD_LOG, 'FNC_CLEAN_CR', 3, sqlcode, 'UPDATE NO GLGB - t_mcre0_app_cr', 'Tutto ok');
    EXCEPTION WHEN OTHERS THEN
        PKG_MCRE0_AUDIT.log_etl(P_COD_LOG, 'FNC_CLEAN_CR', 1, sqlcode, 'UPDATE NO GLGB - t_mcre0_app_cr', 'SQLERRM='||SQLERRM);
        return ko;
    END;

     BEGIN
    -- Sbianco gli attributi relativi a il gruppo bancario
--

        UPDATE T_MCRE0_APP_CR24 CR
        SET
            SCGB_DTA_RIF_CR     = NULL,
            SCGB_DTA_STATO_SIS  = NULL,
            SCGB_ACC_CR         = NULL,
            SCGB_ACC_SIS        = NULL,
            SCGB_GAR_CR         = NULL,
            SCGB_GAR_SIS        = NULL,
            SCGB_SCO_CR         = NULL,
            SCGB_SCO_SIS        = NULL,
            SCGB_UTI_CR         = NULL,
            SCGB_UTI_SIS        = NULL,
            SCGB_COD_SNDG       = NULL,
            SCGB_COD_STATO_SIS  = NULL,
            SCGB_DTA_UPD        = SYSDATE,
            SCGB_COD_OP_INS_UPD = NULL,
            SCGB_QIS_ACC        = NULL,
            SCGB_QIS_UTI        = NULL
        WHERE
            GEGB_ID_DPER < nvl(p_id_dper,(
              select idper
              FROM V_MCRE0_ULTIMA_ACQUISIZIONE
              WHERE COD_FILE = 'FILE_GUIDA' ))
           AND GEGB_ID_DPER IN (
            SELECT ID_DPER FROM (
                SELECT  DISTINCT ID_DPER
                FROM    T_MCRE0_APP_CR_SC_GB24
                WHERE   ID_DPER <= nvl(p_id_dper, id_dper)
                ORDER BY ID_DPER desc)
               WHERE rownum <3)
           and exists (
            select distinct 1
            FROM T_MCRE0_APP_FILE_GUIDA24 F
            where f.cod_abi_cartolarizzato = CR.cod_abi_cartolarizzato
            and f.cod_ndg = CR.cod_ndg
            and f.id_dper = (
                select idper
                from V_MCRE0_ULTIMA_ACQUISIZIONE
                where COD_FILE = 'FILE_GUIDA' ) ) ;
           COMMIT;

        PKG_MCRE0_AUDIT.log_etl(P_COD_LOG, 'FNC_CLEAN_CR', 3, sqlcode, 'UPDATE NO SCGB - t_mcre0_app_cr', 'Tutto ok');
    EXCEPTION WHEN OTHERS THEN
        PKG_MCRE0_AUDIT.log_etl(P_COD_LOG, 'FNC_CLEAN_CR', 1, sqlcode, 'UPDATE NO SCGB - t_mcre0_app_cr', 'SQLERRM='||SQLERRM);
        return ko;
    END;


    BEGIN
        /*
         * E' uscito dal gruppo economico.
         * Si mettono a null tutti gli attributi del gruppo economico dei record che esistono
         * nel file guida ma che hanno gruppo economico a null
         */
        UPDATE T_MCRE0_APP_CR24 CR
        SET
             CR.GEGB_ACC_CR     = NULL
            ,CR.GEGB_ACC_SIS    = NULL
            ,CR.GEGB_GAR_CR     = NULL
            ,CR.GEGB_GAR_SIS    = NULL
            ,CR.GEGB_SCO_CR     = NULL
            ,CR.GEGB_SCO_SIS    = NULL
            ,CR.GEGB_UTI_CR     = NULL
            ,CR.GEGB_UTI_SIS    = NULL
            ,CR.GEGB_COD_SNDG   = NULL
            ,CR.GEGB_DTA_UPD    = SYSDATE
            ,CR.GESB_DTA_CR     = NULL
            ,CR.GESB_ACC_CR     = NULL
            ,CR.GESB_GAR_CR     = NULL
            ,CR.GESB_SCO_CR     = NULL
            ,CR.GESB_UTI_CR     = NULL
            ,CR.GESB_DTA_UPD    = NULL
            WHERE (
                NOT EXISTS (
                    SELECT  DISTINCT 1
                    FROM    T_MCRE0_APP_GRUPPO_ECONOMICO24 e
                    WHERE   e.COD_SNDG = CR.COD_SNDG
                    )
                OR EXISTS (
                    SELECT  DISTINCT 1 FROM T_MCRE0_APP_FILE_GUIDA24 f
                    WHERE   CR.COD_ABI_CARTOLARIZZATO = f.COD_ABI_CARTOLARIZZATO
                    AND     CR.COD_NDG = f.COD_NDG
                    AND     f.FLG_GRUPPO_ECONOMICO = 0
                    )
               );

        COMMIT;
        PKG_MCRE0_AUDIT.log_etl(P_COD_LOG, 'FNC_CLEAN_CR', 3, sqlcode, 'UPDATE USCITI dal gruppo economico - t_mcre0_app_cr', 'Tutto ok');
    EXCEPTION WHEN OTHERS THEN
        PKG_MCRE0_AUDIT.log_etl(P_COD_LOG, 'FNC_CLEAN_CR', 1, sqlcode, 'UPDATE USCITI dal gruppo economico - t_mcre0_app_cr', 'SQLERRM='||SQLERRM);
        RETURN KO;
    END;


    BEGIN
        /*
         * E' uscito dal gruppo legame.
         * Si mette a null tutti gli attributi del gruppo legame dei record che sono vivi
         * nel file guida ma hanno gruppo legame a null
         */
        UPDATE T_MCRE0_APP_CR24 CR
        SET
             CR.GLGB_COD_SNDG       = NULL
            ,CR.GLGB_IMP_GAR_SIS    = NULL
            ,CR.GLGB_ACC_CR         = NULL
            ,CR.GLGB_UTI_CR         = NULL
            ,CR.GLGB_SCO_CR         = NULL
            ,CR.GLGB_GAR_CR         = NULL
            ,CR.GLGB_ACC_SIS        = NULL
            ,CR.GLGB_UTI_SIS        = NULL
            ,CR.GLGB_SCO_SIS        = NULL
            ,CR.GLGB_DTA_UPD        = SYSDATE
        WHERE (
                NOT EXISTS (
                SELECT DISTINCT 1
                FROM    T_MCRE0_APP_GRUPPO_LEGAME l
                WHERE   L.COD_SNDG = CR.GLGB_COD_SNDG
                )
            OR EXISTS (
                SELECT  DISTINCT 1
                FROM    T_MCRE0_APP_FILE_GUIDA24 F
                WHERE   CR.COD_ABI_CARTOLARIZZATO = F.COD_ABI_CARTOLARIZZATO
                AND     CR.COD_NDG = F.COD_NDG
                AND     F.FLG_GRUPPO_LEGAME = 0
                )
            )    ;
        COMMIT;
        PKG_MCRE0_AUDIT.log_etl(P_COD_LOG, 'FNC_CLEAN_CR', 3, sqlcode, 'UPDATE USCITI da legame - t_mcre0_app_cr', 'Tutto ok');
    EXCEPTION WHEN OTHERS THEN
        PKG_MCRE0_AUDIT.log_etl(P_COD_LOG, 'FNC_CLEAN_CR', 1, sqlcode, 'UPDATE USCITI da legame - t_mcre0_app_cr', 'SQLERRM='||SQLERRM);
        RETURN KO;
    END;

    BEGIN
        DELETE FROM T_MCRE0_APP_CR24 CR
        WHERE
                SCSB_DTA_CR IS NULL
            AND SCSB_ACC_CR IS NULL
            AND SCSB_GAR_CR IS NULL
            AND SCSB_SCO_CR IS NULL
            AND SCSB_UTI_CR IS NULL
            AND SCSB_COD_NDG IS NULL
            AND SCSB_DTA_INS IS NULL
            AND SCSB_COD_OP_INS_UPD IS NULL
            AND SCSB_ID_DPER IS NULL
            AND SCSB_QIS_ACC IS NULL
            AND SCSB_QIS_UTI IS NULL
            --------------------------
            AND GEGB_DTA_RIF_CR IS NULL
            AND GEGB_ACC_CR IS NULL
            AND GEGB_ACC_SIS IS NULL
            AND GEGB_GAR_CR IS NULL
            AND GEGB_GAR_SIS IS NULL
            AND GEGB_SCO_CR IS NULL
            AND GEGB_SCO_SIS IS NULL
            AND GEGB_UTI_CR IS NULL
            AND GEGB_UTI_SIS IS NULL
            AND GEGB_COD_SNDG IS NULL
            AND GEGB_COD_OP_INS_UPD IS NULL
            AND GEGB_QIS_ACC IS NULL
            AND GEGB_QIS_UTI IS NULL
            --------------------------
            AND GLGB_COD_SNDG IS NULL
            AND GLGB_ACC_CR IS NULL
            AND GLGB_UTI_CR IS NULL
            AND GLGB_SCO_CR IS NULL
            AND GLGB_GAR_CR IS NULL
            AND GLGB_ACC_SIS IS NULL
            AND GLGB_UTI_SIS IS NULL
            AND GLGB_SCO_SIS IS NULL
            AND GLGB_IMP_GAR_SIS IS NULL
            AND GLGB_DTA_RIF_CR IS NULL
            AND GLGB_COD_OP_INS_UPD IS NULL
            AND GLGB_QIS_ACC IS NULL
            AND GLGB_QIS_UTI IS NULL
            --------------------------
            AND SCGB_DTA_RIF_CR IS NULL
            AND SCGB_DTA_STATO_SIS IS NULL
            AND SCGB_ACC_CR IS NULL
            AND SCGB_ACC_SIS IS NULL
            AND SCGB_GAR_CR IS NULL
            AND SCGB_GAR_SIS IS NULL
            AND SCGB_SCO_CR IS NULL
            AND SCGB_SCO_SIS IS NULL
            AND SCGB_UTI_CR IS NULL
            AND SCGB_UTI_SIS IS NULL
            AND SCGB_COD_SNDG IS NULL
            AND SCGB_COD_STATO_SIS IS NULL
            AND SCGB_COD_OP_INS_UPD IS NULL
            AND SCGB_QIS_ACC IS NULL
            AND SCGB_QIS_UTI IS NULL
            --------------------------
            AND CR.GEGB_ACC_CR IS NULL
            AND CR.GEGB_ACC_SIS IS NULL
            AND CR.GEGB_GAR_CR IS NULL
            AND CR.GEGB_GAR_SIS IS NULL
            AND CR.GEGB_SCO_CR IS NULL
            AND CR.GEGB_SCO_SIS IS NULL
            AND CR.GEGB_UTI_CR IS NULL
            AND CR.GEGB_UTI_SIS IS NULL
            AND CR.GEGB_COD_SNDG IS NULL
            AND CR.GESB_DTA_CR IS NULL
            AND CR.GESB_ACC_CR IS NULL
            AND CR.GESB_GAR_CR IS NULL
            AND CR.GESB_SCO_CR IS NULL
            AND CR.GESB_UTI_CR IS NULL
            AND CR.GESB_DTA_UPD IS NULL
            --------------------------
            AND CR.GLGB_COD_SNDG IS NULL
            AND CR.GLGB_IMP_GAR_SIS IS NULL
            AND CR.GLGB_ACC_CR IS NULL
            AND CR.GLGB_UTI_CR IS NULL
            AND CR.GLGB_SCO_CR IS NULL
            AND CR.GLGB_GAR_CR IS NULL
            AND CR.GLGB_ACC_SIS IS NULL
            AND CR.GLGB_UTI_SIS IS NULL
            AND CR.GLGB_SCO_SIS IS NULL;
        COMMIT;
        PKG_MCRE0_AUDIT.log_etl(P_COD_LOG, 'FNC_CLEAN_CR', 3, sqlcode, 'DELETE NO CR - t_mcre0_app_cr', 'Tutto ok');
    EXCEPTION WHEN OTHERS THEN
        ROLLBACK;
        PKG_MCRE0_AUDIT.log_etl(P_COD_LOG, 'FNC_CLEAN_CR', 3, sqlcode, 'DELETE NO CR - t_mcre0_app_cr', 'SQLERRM='||SQLERRM);
    END;

    RETURN val_ok;
EXCEPTION WHEN OTHERS THEN
    RETURN KO;
END FNC_CLEAN_CR;

FUNCTION FNC_LOAD_CR_SC_SB (
 P_COD_LOG T_MCRE0_WRK_AUDIT_ETL.ID%TYPE DEFAULT NULL,
 p_id_dper T_MCRE0_APP_CR_SC_SB24.id_dper%type default null) RETURN NUMBER IS

begin
    MERGE INTO T_MCRE0_APP_CR24 cr
    USING   (
        SELECT  COD_ABI_CARTOLARIZZATO, COD_NDG, DTA_CR_SCSB, VAL_ACC_CR_SCSB, VAL_GAR_CR_SCSB,
                VAL_SCO_CR_SCSB, VAL_UTI_CR_SCSB, DTA_INS, DTA_UPD, COD_OPERATORE_INS_UPD, ID_DPER, QIS_SCSB_ACC
                , QIS_SCSB_UTI, COD_SNDG
        FROM    (
                SELECT  CR_SC_SB.COD_ABI_CARTOLARIZZATO COD_ABI_CARTOLARIZZATO, CR_SC_SB.DTA_CR_SCSB,
                        CR_SC_SB.VAL_ACC_CR_SCSB, CR_SC_SB.VAL_GAR_CR_SCSB, CR_SC_SB.VAL_SCO_CR_SCSB,
                        CR_SC_SB.VAL_UTI_CR_SCSB, CR_SC_SB.COD_NDG cod_ndg, CR_SC_SB.DTA_INS,
                        CR_SC_SB.DTA_UPD, CR_SC_SB.COD_OPERATORE_INS_UPD, CR_SC_SB.ID_DPER, FG.COD_SNDG, FG.COD_ABI_CARTOLARIZZATO COD_ABI_CART_FG,
                        --v2.2 - number!
                        CASE WHEN ROUND(CR_SC_SB.VAL_ACC_CR_SCSB / ( (CASE WHEN NVL(GB.VAL_ACC_SIS_SC,0) = 0 THEN -1 ELSE GB.VAL_ACC_SIS_SC  END) )*100) < 0 THEN null ELSE ROUND(CR_SC_SB.VAL_ACC_CR_SCSB / ( (CASE WHEN NVL(GB.VAL_ACC_SIS_SC,0) = 0 THEN -1 ELSE GB.VAL_ACC_SIS_SC  END) )*100) END QIS_SCSB_ACC,
                        CASE WHEN ROUND(CR_SC_SB.VAL_UTI_CR_SCSB / ( (CASE WHEN NVL(GB.VAL_UTI_SIS_SC,0) = 0 THEN -1 ELSE GB.VAL_UTI_SIS_SC  END) )*100) < 0 THEN null ELSE ROUND(CR_SC_SB.VAL_UTI_CR_SCSB / ( (CASE WHEN NVL(GB.VAL_UTI_SIS_SC,0) = 0 THEN -1 ELSE GB.VAL_UTI_SIS_SC  END) )*100) END QIS_SCSB_UTI
                                
                FROM    T_MCRE0_APP_CR_SC_SB24 CR_SC_SB, 
                        T_MCRE0_APP_FILE_GUIDA24 FG, 
                        (select * from T_MCRE0_APP_CR_SC_GB24 , v_mcre0_ultima_acquisizione 
                         where COD_FILE = 'CR_SC_GB'
                         and id_dper = idper) GB,
                        v_mcre0_ultima_acquisizione a
                WHERE   CR_SC_SB.COD_ABI_CARTOLARIZZATO=FG.COD_ABI_CARTOLARIZZATO
                AND     CR_SC_SB.COD_NDG=FG.COD_NDG
                AND     FG.flg_active = '1'
                and     FG.COD_SNDG != '0000000000000000'
                AND     FG.COD_SNDG = GB.COD_SNDG(+)
                AND     a.cod_file = 'CR_SC_SB'
                AND     a.idper = CR_SC_SB.ID_DPER)
            ) SC_SB
    ON      ( SC_SB.COD_ABI_CARTOLARIZZATO = CR.COD_ABI_CARTOLARIZZATO
              AND SC_SB.COD_NDG = CR.COD_NDG )
    WHEN MATCHED THEN
        update set
             CR.SCSB_ACC_CR         =   SC_SB.VAL_ACC_CR_SCSB
            ,CR.SCSB_COD_ABI_CART   =   SC_SB.COD_ABI_CARTOLARIZZATO
            ,CR.SCSB_COD_NDG        =   SC_SB.COD_NDG
            ,CR.SCSB_COD_OP_INS_UPD =   SC_SB.COD_OPERATORE_INS_UPD
            ,CR.SCSB_DTA_CR         =   SC_SB.DTA_CR_SCSB
            ,CR.SCSB_DTA_INS        =   SC_SB.DTA_INS
            ,CR.SCSB_DTA_UPD        =   SC_SB.DTA_UPD
            ,CR.SCSB_GAR_CR         =   SC_SB.VAL_GAR_CR_SCSB
            ,CR.SCSB_ID_DPER        =   SC_SB.ID_DPER
            ,CR.SCSB_QIS_ACC        =   SC_SB.QIS_SCSB_ACC
            ,CR.SCSB_QIS_UTI        =   SC_SB.QIS_SCSB_UTI
            ,CR.SCSB_SCO_CR         =   SC_SB.VAL_SCO_CR_SCSB
            ,CR.SCSB_UTI_CR         =   SC_SB.VAL_UTI_CR_SCSB
            ,CR.COD_SNDG            =   SC_SB.COD_SNDG
    WHEN NOT MATCHED THEN
            INSERT (
            CR.SCSB_DTA_CR, CR.SCSB_ACC_CR, CR.SCSB_GAR_CR, CR.SCSB_SCO_CR,
            CR.SCSB_DTA_INS,CR.SCSB_DTA_UPD, CR.SCSB_COD_OP_INS_UPD, CR.SCSB_ID_DPER,
            CR.SCSB_COD_ABI_CART, CR.SCSB_COD_NDG, CR.SCSB_QIS_ACC, CR.SCSB_QIS_UTI, CR.COD_ABI_CARTOLARIZZATO, CR.COD_NDG, CR.COD_SNDG
            )
            VALUES(
            SC_SB.DTA_CR_SCSB, SC_SB.VAL_ACC_CR_SCSB, SC_SB.VAL_GAR_CR_SCSB, SC_SB.VAL_SCO_CR_SCSB,
            SC_SB.DTA_INS, SC_SB.DTA_UPD, SC_SB.COD_OPERATORE_INS_UPD, SC_SB.ID_DPER,
            SC_SB.COD_ABI_CARTOLARIZZATO, SC_SB.COD_NDG,  SC_SB.QIS_SCSB_ACC, SC_SB.QIS_SCSB_UTI, SC_SB.COD_ABI_CARTOLARIZZATO, SC_SB.COD_NDG,
            SC_SB.COD_SNDG
            );
            COMMIT;
            PKG_MCRE0_AUDIT.log_etl(P_COD_LOG, 'FNC_LOAD_CR_SC_SB', 3, sqlcode, 'SCSB: - t_mcre0_app_cr', 'Tutto ok');
            return val_ok;
EXCEPTION
    WHEN OTHERS THEN
    PKG_MCRE0_AUDIT.log_etl(P_COD_LOG, 'FNC_LOAD_CR_SC_SB', 1, sqlcode, 'SCSB: - t_mcre0_app_cr', 'SQLERRM:'||SQLERRM);
        return ko;
END FNC_LOAD_CR_SC_SB;


FUNCTION FNC_LOAD_CR_SC_GB (
    P_COD_LOG T_MCRE0_WRK_AUDIT_ETL.ID%TYPE DEFAULT NULL,
    p_id_dper T_MCRE0_APP_CR_SC_GB24.id_dper%type default null) RETURN NUMBER IS
    BEGIN
        MERGE INTO T_MCRE0_APP_CR24 cr
        USING       (
            SELECT  COD_ABI_CARTOLARIZZATO, COD_NDG, COD_SNDG, COD_SNDG_FG,
                    DTA_RIFERIMENTO_CR, DTA_STATO_SIS, VAL_ACC_CR_SC,
                    VAL_ACC_SIS_SC, VAL_GAR_CR_SC, VAL_GAR_SIS_SC,
                    VAL_SCO_CR_SC, VAL_SCO_SIS_SC, VAL_UTI_CR_SC,
                    VAL_UTI_SIS_SC, COD_SNDG_GB, COD_STATO_SIS,
                    DTA_INS, DTA_UPD, COD_OPERATORE_INS_UPD, ID_DPER, SCGB_QIS_ACC, SCGB_QIS_UTI
            FROM
                    (
                    SELECT      FG.COD_ABI_CARTOLARIZZATO, FG.COD_NDG, fg.COD_SNDG cod_sndg_FG,
                                SC_GB.COD_SNDG,
                                SC_GB.DTA_RIFERIMENTO_CR, SC_GB.DTA_STATO_SIS, SC_GB.VAL_ACC_CR_SC,
                                SC_GB.VAL_ACC_SIS_SC, SC_GB.VAL_GAR_CR_SC, SC_GB.VAL_GAR_SIS_SC,
                                SC_GB.VAL_SCO_CR_SC, SC_GB.VAL_SCO_SIS_SC, SC_GB.VAL_UTI_CR_SC,
                                SC_GB.VAL_UTI_SIS_SC, SC_GB.COD_SNDG COD_SNDG_GB, SC_GB.COD_STATO_SIS,
                                SC_GB.DTA_INS, SC_GB.DTA_UPD, SC_GB.COD_OPERATORE_INS_UPD, SC_GB.ID_DPER,
                                --v2.2 number!
                                CASE WHEN ROUND(sc_gb.VAL_ACC_CR_SC  / ( (CASE WHEN NVL(sc_gb.VAL_ACC_SIS_SC,0) = 0 THEN -1 ELSE sc_gb.VAL_ACC_SIS_SC  END) )*100) < 0 THEN null ELSE ROUND(sc_gb.VAL_ACC_CR_SC  / ( (CASE WHEN NVL(sc_gb.VAL_ACC_SIS_SC,0) = 0 THEN -1 ELSE sc_gb.VAL_ACC_SIS_SC  END) )*100) END SCGB_QIS_ACC,
                                CASE WHEN ROUND(sc_gb.VAL_UTI_CR_SC / ( (CASE WHEN NVL(sc_gb.VAL_UTI_SIS_SC,0) = 0 THEN -1 ELSE sc_gb.VAL_UTI_SIS_SC  END) )*100) < 0 THEN null ELSE ROUND(sc_gb.VAL_UTI_CR_SC / ( (CASE WHEN NVL(sc_gb.VAL_UTI_SIS_SC,0) = 0 THEN -1 ELSE sc_gb.VAL_UTI_SIS_SC  END) )*100) END SCGB_QIS_UTI
                        FROM        (SELECT DISTINCT COD_SNDG, COD_ABI_CARTOLARIZZATO,
                                              COD_ABI_ISTITUTO, COD_NDG
                                      from   T_MCRE0_APP_FILE_GUIDA24 F
                                      WHERE  F.COD_SNDG!='0000000000000000' ) FG, 
                                    T_MCRE0_APP_CR_SC_GB24 SC_GB,
                                    v_mcre0_ultima_acquisizione a
                        WHERE       sc_gb.COD_SNDG = fg.COD_SNDG
                        AND         SC_GB.ID_DPER =  a.idper
                        AND         a.cod_file = 'CR_SC_GB'
                    )
                ) CR_SC_GB
                ON( CR_SC_GB.COD_ABI_CARTOLARIZZATO = CR.COD_ABI_CARTOLARIZZATO
                    and CR_SC_GB.COD_NDG = CR.COD_NDG
                )
           WHEN MATCHED THEN
            UPDATE SET
                     CR.SCGB_DTA_RIF_CR     =   CR_SC_GB.DTA_RIFERIMENTO_CR
                    ,CR.SCGB_DTA_STATO_SIS  =   CR_SC_GB.DTA_STATO_SIS
                    ,CR.SCGB_ACC_CR         =   CR_SC_GB.VAL_ACC_CR_SC
                    ,CR.SCGB_ACC_SIS        =   CR_SC_GB.VAL_ACC_SIS_SC
                    ,CR.SCGB_GAR_CR         =   CR_SC_GB.VAL_GAR_CR_SC
                    ,CR.SCGB_GAR_SIS        =   CR_SC_GB.VAL_GAR_SIS_SC
                    ,CR.SCGB_SCO_CR         =   CR_SC_GB.VAL_SCO_CR_SC
                    ,CR.SCGB_SCO_SIS        =   CR_SC_GB.VAL_SCO_SIS_SC
                    ,CR.SCGB_UTI_CR         =   CR_SC_GB.VAL_UTI_CR_SC
                    ,CR.SCGB_UTI_SIS        =   CR_SC_GB.VAL_UTI_SIS_SC
                    ,CR.SCGB_COD_STATO_SIS  =   CR_SC_GB.COD_STATO_SIS
                    ,CR.SCGB_DTA_UPD        =   CR_SC_GB.DTA_UPD
                    ,CR.SCGB_DTA_INS        =   CR_SC_GB.DTA_INS
                    ,CR.SCGB_COD_OP_INS_UPD =   CR_SC_GB.COD_OPERATORE_INS_UPD
                    ,CR.SCGB_ID_DPER        =   CR_SC_GB.ID_DPER
                    ,CR.SCGB_COD_SNDG       =   CR_SC_GB.COD_SNDG
                    ,CR.SCGB_QIS_ACC        =   CR_SC_GB.SCGB_QIS_ACC
                    ,CR.SCGB_QIS_UTI        =   CR_SC_GB.SCGB_QIS_UTI
         -- v2.2    ,CR.COD_SNDG            =   CR_SC_GB.COD_SNDG_FG
                    ,CR.COD_SNDG            =   CR_SC_GB.COD_SNDG
           WHEN NOT MATCHED THEN
            INSERT (
                     COD_ABI_CARTOLARIZZATO
                    ,COD_NDG
                    ,CR.SCGB_DTA_RIF_CR
                    ,CR.SCGB_DTA_STATO_SIS
                    ,CR.SCGB_ACC_CR
                    ,CR.SCGB_ACC_SIS
                    ,CR.SCGB_GAR_CR
                    ,CR.SCGB_GAR_SIS
                    ,CR.SCGB_SCO_CR
                    ,CR.SCGB_SCO_SIS
                    ,CR.SCGB_UTI_CR
                    ,CR.SCGB_UTI_SIS
                    ,CR.SCGB_COD_SNDG
                    ,CR.SCGB_COD_STATO_SIS
                    ,CR.SCGB_DTA_INS
                    ,CR.SCGB_DTA_UPD
                    ,CR.SCGB_COD_OP_INS_UPD
                    ,CR.SCGB_ID_DPER
                    ,CR.SCGB_QIS_ACC
                    ,CR.SCGB_QIS_UTI
                    ,CR.COD_SNDG
                    )
            VALUES (
                     CR_SC_GB.COD_ABI_CARTOLARIZZATO
                    ,CR_SC_GB.COD_NDG
                    ,CR_SC_GB.DTA_RIFERIMENTO_CR
                    ,CR_SC_GB.DTA_STATO_SIS
                    ,CR_SC_GB.VAL_ACC_CR_SC
                    ,CR_SC_GB.VAL_ACC_SIS_SC
                    ,CR_SC_GB.VAL_GAR_CR_SC
                    ,CR_SC_GB.VAL_GAR_SIS_SC
                    ,CR_SC_GB.VAL_SCO_CR_SC
                    ,CR_SC_GB.VAL_SCO_SIS_SC
                    ,CR_SC_GB.VAL_UTI_CR_SC
                    ,CR_SC_GB.VAL_UTI_SIS_SC
                    ,CR_SC_GB.COD_SNDG_GB
                    ,CR_SC_GB.COD_STATO_SIS
                    ,CR_SC_GB.DTA_INS
                    ,CR_SC_GB.DTA_UPD
                    ,CR_SC_GB.COD_OPERATORE_INS_UPD
                    ,CR_SC_GB.ID_DPER
                    ,CR_SC_GB.SCGB_QIS_ACC
                    ,CR_SC_GB.SCGB_QIS_UTI
            --v2.2  ,CR_SC_GB.COD_SNDG_FG
                    ,CR_SC_GB.COD_SNDG
            );
            COMMIT;
            PKG_MCRE0_AUDIT.log_etl(P_COD_LOG, 'FNC_LOAD_CR_SC_GB', 3, sqlcode, 'SCGB: - t_mcre0_app_cr', 'Tutto ok');
        return val_ok;
    EXCEPTION
        WHEN OTHERS THEN
        PKG_MCRE0_AUDIT.log_etl(P_COD_LOG, 'FNC_LOAD_CR_SC_GB', 1, sqlcode, 'SCGB: - t_mcre0_app_cr', 'SQLERRM: '||SQLERRM);
            return ko;
    END FNC_LOAD_CR_SC_GB;


  FUNCTION FNC_LOAD_CR_GE_GB (
    P_COD_LOG T_MCRE0_WRK_AUDIT_ETL.ID%TYPE DEFAULT NULL,
    p_id_dper T_MCRE0_APP_CR_GE_GB24.id_dper%type default null) RETURN NUMBER IS
    BEGIN
        MERGE INTO T_MCRE0_APP_CR24 cr
        USING (
                SELECT   GE_GB.COD_SNDG_GE
                        ,GE_GB.VAL_ACC_CR_GE
                        ,GE_GB.VAL_ACC_SIS_GE
                        ,GE_GB.VAL_GAR_CR_GE
                        ,GE_GB.VAL_GAR_SIS_GE
                        ,GE_GB.VAL_SCO_CR_GE
                        ,GE_GB.VAL_SCO_SIS_GE
                        ,GE_GB.VAL_UTI_CR_GE
                        ,GE_GB.VAL_UTI_SIS_GE
                        ,GE_GB.COD_GRUPPO_ECONOMICO
                        ,GE_GB.COD_OPERATORE_INS_UPD
                        ,GE_GB.DTA_INS
                        ,GE_GB.DTA_UPD
                        ,GE_GB.ID_DPER
                        ,FG.COD_ABI_CARTOLARIZZATO
                        ,FG.COD_NDG
                        ,FG.COD_SNDG
                        ,GE_GB.DTA_RIFERIMENTO_CR
                        ,GE_GB.GEGB_QIS_ACC
                        ,GE_GB.GEGB_QIS_UTI
--                            FROM     T_MCRE0_APP_FILE_GUIDA FG
                FROM    (select COD_ABI_CARTOLARIZZATO, COD_NDG, COD_SNDG 
                         from T_MCRE0_APP_FILE_GUIDA24
                         where flg_active = '1') FG
                        ,(
                            SELECT    GE.COD_GRUPPO_ECONOMICO,
                            --v2.3 cod_sndg x join al posto di GE
                                      GE.COD_SNDG
                                     ,cr_ge_gb.COD_SNDG_GE
                                     ,cr_ge_gb.VAL_ACC_CR_GE
                                     ,cr_ge_gb.VAL_ACC_SIS_GE
                                     ,cr_ge_gb.VAL_GAR_CR_GE
                                     ,cr_ge_gb.VAL_GAR_SIS_GE
                                     ,cr_ge_gb.VAL_SCO_CR_GE
                                     ,cr_ge_gb.VAL_SCO_SIS_GE
                                     ,cr_ge_gb.VAL_UTI_CR_GE
                                     ,cr_ge_gb.VAL_UTI_SIS_GE
                                     ,cr_ge_gb.ID_DPER
                                     ,cr_ge_gb.DTA_INS
                                     ,cr_ge_gb.DTA_UPD
                                     ,cr_ge_gb.COD_OPERATORE_INS_UPD
                                     ,CR_GE_GB.DTA_RIFERIMENTO_CR
                                     --v2.2 number
                                     ,CASE WHEN ROUND(CR_GE_GB.VAL_ACC_CR_GE / ( (CASE WHEN NVL(cr_ge_gb.VAL_ACC_SIS_GE,0) = 0 THEN -1 ELSE cr_ge_gb.VAL_ACC_SIS_GE  END) )*100) < 0 THEN null ELSE ROUND(CR_GE_GB.VAL_ACC_CR_GE / ( (CASE WHEN NVL(cr_ge_gb.VAL_ACC_SIS_GE,0) = 0 THEN -1 ELSE cr_ge_gb.VAL_ACC_SIS_GE  END) )*100) END GEGB_QIS_ACC
                                     ,CASE WHEN ROUND(CR_GE_GB.VAL_UTI_CR_GE / ( (CASE WHEN NVL(cr_ge_gb.VAL_UTI_SIS_GE,0) = 0 THEN -1 ELSE cr_ge_gb.VAL_UTI_SIS_GE  END) )*100) < 0 THEN null ELSE ROUND(CR_GE_GB.VAL_UTI_CR_GE / ( (CASE WHEN NVL(cr_ge_gb.VAL_UTI_SIS_GE,0) = 0 THEN -1 ELSE cr_ge_gb.VAL_UTI_SIS_GE  END) )*100) END GEGB_QIS_UTI
                            FROM     T_MCRE0_APP_CR_GE_GB24 cr_ge_gb
                                    ,T_MCRE0_APP_GRUPPO_ECONOMICO24 GE,
                                     v_mcre0_ultima_acquisizione a                                                
                            WHERE    GE.COD_SNDG = CR_GE_GB.COD_SNDG_GE
                            AND      CR_GE_GB.ID_DPER = a.idper
                            AND      a.cod_file = 'CR_GE_GB'
                        ) GE_GB
--                            WHERE   FG.COD_GRUPPO_ECONOMICO = GE_GB.COD_GRUPPO_ECONOMICO
                WHERE   FG.COD_SNDG = GE_GB.COD_SNDG
        ) CR_GE_GB
        ON(         CR.COD_ABI_CARTOLARIZZATO = CR_GE_GB.COD_ABI_CARTOLARIZZATO
            AND     CR.COD_NDG = CR_GE_GB.COD_NDG   )
        WHEN MATCHED THEN
            UPDATE SET
             CR.GEGB_ACC_CR         =   CR_GE_GB.VAL_ACC_CR_GE
            ,CR.GEGB_ACC_SIS        =   CR_GE_GB.VAL_ACC_SIS_GE
            ,CR.GEGB_GAR_CR         =   CR_GE_GB.VAL_GAR_CR_GE
            ,CR.GEGB_GAR_SIS        =   CR_GE_GB.VAL_GAR_SIS_GE
            ,CR.GEGB_SCO_CR         =   CR_GE_GB.VAL_SCO_CR_GE
            ,CR.GEGB_SCO_SIS        =   CR_GE_GB.VAL_SCO_SIS_GE
            ,CR.GEGB_UTI_CR         =   CR_GE_GB.VAL_UTI_CR_GE
            ,CR.GEGB_UTI_SIS        =   CR_GE_GB.VAL_UTI_SIS_GE
            ,CR.GEGB_COD_SNDG       =   CR_GE_GB.COD_SNDG_GE
            ,CR.GEGB_DTA_INS        =   CR_GE_GB.DTA_INS
            ,CR.GEGB_DTA_UPD        =   CR_GE_GB.DTA_UPD
            ,CR.GEGB_COD_OP_INS_UPD =   CR_GE_GB.COD_OPERATORE_INS_UPD
            ,CR.GEGB_ID_DPER        =   CR_GE_GB.ID_DPER
            ,CR.GEGB_QIS_ACC        =   CR_GE_GB.GEGB_QIS_ACC
            ,CR.GEGB_QIS_UTI        =   CR_GE_GB.GEGB_QIS_UTI
            ,CR.GEGB_DTA_RIF_CR     =   CR_GE_GB.DTA_RIFERIMENTO_CR
     --v2.2 ,CR.COD_SNDG            =   CR_GE_GB.COD_SNDG_GE
            ,CR.COD_SNDG            =   CR_GE_GB.COD_SNDG
           WHEN NOT MATCHED THEN
            INSERT (
                     CR.COD_ABI_CARTOLARIZZATO
                    ,CR.COD_NDG
                    ,CR.GEGB_COD_SNDG
                    ,CR.GEGB_ACC_CR
                    ,CR.GEGB_ACC_SIS
                    ,CR.GEGB_GAR_CR
                    ,CR.GEGB_GAR_SIS
                    ,CR.GEGB_SCO_CR
                    ,CR.GEGB_SCO_SIS
                    ,CR.GEGB_UTI_CR
                    ,CR.GEGB_UTI_SIS
                    ,CR.GEGB_DTA_INS
                    ,CR.GEGB_DTA_UPD
                    ,CR.GEGB_COD_OP_INS_UPD
                    ,CR.GEGB_ID_DPER
                    ,CR.GEGB_DTA_RIF_CR
                    ,CR.GEGB_QIS_ACC
                    ,CR.GEGB_QIS_UTI
                    ,CR.COD_SNDG
                    )
            VALUES (
                     CR_GE_GB.COD_ABI_CARTOLARIZZATO
                    ,CR_GE_GB.COD_NDG
                    ,CR_GE_GB.COD_SNDG_GE
                    ,CR_GE_GB.VAL_ACC_CR_GE
                    ,CR_GE_GB.VAL_ACC_SIS_GE
                    ,CR_GE_GB.VAL_GAR_CR_GE
                    ,CR_GE_GB.VAL_GAR_SIS_GE
                    ,CR_GE_GB.VAL_SCO_CR_GE
                    ,CR_GE_GB.VAL_SCO_SIS_GE
                    ,CR_GE_GB.VAL_UTI_CR_GE
                    ,CR_GE_GB.VAL_UTI_SIS_GE
                    ,CR_GE_GB.DTA_INS
                    ,CR_GE_GB.DTA_UPD
                    ,CR_GE_GB.COD_OPERATORE_INS_UPD
                    ,CR_GE_GB.ID_DPER
                    ,CR_GE_GB.DTA_RIFERIMENTO_CR
                    ,CR_GE_GB.GEGB_QIS_ACC
                    ,CR_GE_GB.GEGB_QIS_UTI
                    ,CR_GE_GB.COD_SNDG
            );
            COMMIT;
            PKG_MCRE0_AUDIT.log_etl(P_COD_LOG, 'FNC_LOAD_CR_GE_GB', 3, sqlcode, 'GEGB: - t_mcre0_app_cr', 'Tutto ok');
        return val_ok;
    EXCEPTION
        WHEN OTHERS THEN
        PKG_MCRE0_AUDIT.log_etl(P_COD_LOG, 'FNC_LOAD_CR_GE_GB', 1, sqlcode, 'GEGB: - t_mcre0_app_cr', 'SQLERRM: '||SQLERRM);
            return ko;
    END FNC_LOAD_CR_GE_GB;

  FUNCTION FNC_LOAD_CR_GE_SB (
    P_COD_LOG T_MCRE0_WRK_AUDIT_ETL.ID%TYPE DEFAULT NULL,
    p_id_dper T_MCRE0_APP_CR_GE_SB24.id_dper%type default null)  RETURN NUMBER IS
    BEGIN
        MERGE INTO T_MCRE0_APP_CR24 cr
        USING       (
               SELECT
                     FG.COD_ABI_CARTOLARIZZATO,FG.COD_NDG ,FG.COD_SNDG 
                    ,GE_SB.COD_SNDG_GE ,GE_SB.DTA_CR_GESB
                    ,GE_SB.DTA_INS ,GE_SB.DTA_UPD
                    ,GE_SB.ID_DPER,GE_SB.COD_OPERATORE_INS_UPD
                    ,GE_SB.VAL_ACC_CR_GESB ,GE_SB.VAL_GAR_CR_GESB
                    ,GE_SB.VAL_SCO_CR_GESB ,GE_SB.VAL_UTI_CR_GESB
                    --v2.2 number
                    ,CASE WHEN ROUND(ge_sb.VAL_ACC_CR_GESB / ( (CASE WHEN NVL(ge_gb.VAL_ACC_SIS_GE,0) = 0 THEN -1 ELSE ge_gb.VAL_ACC_SIS_GE  END) )*100) < 0 THEN null ELSE ROUND(ge_sb.VAL_ACC_CR_GESB / ( (CASE WHEN NVL(ge_gb.VAL_ACC_SIS_GE,0) = 0 THEN -1 ELSE ge_gb.VAL_ACC_SIS_GE  END) )*100) END GESB_QIS_ACC
                    ,CASE WHEN ROUND(ge_sb.VAL_UTI_CR_GESB / ( (CASE WHEN NVL(ge_gb.VAL_UTI_SIS_GE,0) = 0 THEN -1 ELSE ge_gb.VAL_UTI_SIS_GE  END) )*100) < 0 THEN null ELSE ROUND(ge_sb.VAL_UTI_CR_GESB / ( (CASE WHEN NVL(ge_gb.VAL_UTI_SIS_GE,0) = 0 THEN -1 ELSE ge_gb.VAL_UTI_SIS_GE  END) )*100) END GESB_QIS_UTI
            FROM    T_MCRE0_APP_CR_GE_SB24 GE_SB,
                    T_MCRE0_APP_FILE_GUIDA24 FG,
                    (select g.* from T_MCRE0_APP_CR_GE_GB24 g, v_mcre0_ultima_acquisizione 
                     where COD_FILE = 'CR_GE_GB'
                     and g.id_dper = idper) GE_GB,
                    v_mcre0_ultima_acquisizione a
            WHERE   GE_SB.COD_SNDG_GE = FG.COD_SNDG
            AND     GE_SB.COD_ABI_CARTOLARIZZATO = FG.COD_ABI_CARTOLARIZZATO
            AND     FG.COD_SNDG = GE_GB.COD_SNDG_GE(+)
            AND     GE_SB.ID_DPER =  a.idper
            AND     a.cod_file = 'CR_GE_SB'
        ) GE_SB_2
        ON (CR.COD_ABI_CARTOLARIZZATO = GE_SB_2.COD_ABI_CARTOLARIZZATO
        AND CR.COD_NDG = GE_SB_2.COD_NDG )
        WHEN MATCHED THEN
            UPDATE SET
                 CR.GESB_DTA_CR         =   GE_SB_2.DTA_CR_GESB
                ,CR.GESB_ACC_CR         =   GE_SB_2.VAL_ACC_CR_GESB
                ,CR.GESB_GAR_CR         =   GE_SB_2.VAL_GAR_CR_GESB
                ,CR.GESB_SCO_CR         =   GE_SB_2.VAL_SCO_CR_GESB
                ,CR.GESB_UTI_CR         =   GE_SB_2.VAL_UTI_CR_GESB
                ,CR.GESB_COD_SNDG       =   GE_SB_2.COD_SNDG_GE
                ,CR.GESB_DTA_INS        =   GE_SB_2.DTA_INS
                ,CR.GESB_DTA_UPD        =   GE_SB_2.DTA_UPD
                ,CR.GESB_COD_OP_INS_UPD =   GE_SB_2.COD_OPERATORE_INS_UPD
                ,CR.GESB_ID_DPER        =   GE_SB_2.ID_DPER
                ,CR.GESB_QIS_ACC        =   GE_SB_2.GESB_QIS_ACC
                ,CR.GESB_QIS_UTI        =   GE_SB_2.GESB_QIS_UTI
                ,CR.COD_SNDG            =   GE_SB_2.COD_SNDG
        WHEN NOT MATCHED THEN
            INSERT(
                     CR.COD_ABI_CARTOLARIZZATO
                    ,CR.COD_NDG
                    ,CR.GESB_COD_ABI_CART
                    ,CR.GESB_DTA_CR
                    ,CR.GESB_ACC_CR
                    ,CR.GESB_GAR_CR
                    ,CR.GESB_SCO_CR
                    ,CR.GESB_UTI_CR
                    ,CR.GESB_COD_SNDG
                    ,CR.GESB_DTA_INS
                    ,CR.GESB_DTA_UPD
                    ,CR.GESB_COD_OP_INS_UPD
                    ,CR.GESB_ID_DPER
                    ,CR.GESB_QIS_ACC
                    ,CR.GESB_QIS_UTI
                    ,CR.COD_SNDG
            )
            VALUES(
                     GE_SB_2.COD_ABI_CARTOLARIZZATO
                    ,GE_SB_2.COD_NDG
                    ,GE_SB_2.COD_ABI_CARTOLARIZZATO
                    ,GE_SB_2.DTA_CR_GESB
                    ,GE_SB_2.VAL_ACC_CR_GESB
                    ,GE_SB_2.VAL_GAR_CR_GESB
                    ,GE_SB_2.VAL_SCO_CR_GESB
                    ,GE_SB_2.VAL_UTI_CR_GESB
                    ,GE_SB_2.COD_SNDG_GE
                    ,GE_SB_2.DTA_INS
                    ,GE_SB_2.DTA_UPD
                    ,GE_SB_2.COD_OPERATORE_INS_UPD
                    ,GE_SB_2.ID_DPER
                    ,GE_SB_2.GESB_QIS_ACC
                    ,GE_SB_2.GESB_QIS_UTI
                    ,GE_SB_2.COD_SNDG
            );
            COMMIT;
            PKG_MCRE0_AUDIT.log_etl(P_COD_LOG, 'FNC_LOAD_CR_GE_SB', 3, sqlcode, 'GESB: - t_mcre0_app_cr', 'Tutto ok');
        return val_ok;
    EXCEPTION
        WHEN OTHERS THEN
        PKG_MCRE0_AUDIT.log_etl(P_COD_LOG, 'FNC_LOAD_CR_GE_SB', 1, sqlcode, 'GESB: - t_mcre0_app_cr', 'SQLERRM: '||SQLERRM);
            return ko;
    END FNC_LOAD_CR_GE_SB;


  FUNCTION FNC_LOAD_CR_LG_GB (
    P_COD_LOG T_MCRE0_WRK_AUDIT_ETL.ID%TYPE DEFAULT NULL,
    p_id_dper T_MCRE0_APP_CR_LG_GB24.id_dper%type default null) RETURN NUMBER IS
    BEGIN
        MERGE INTO T_MCRE0_APP_CR24 cr
        USING       (
            select   COD_ABI_CARTOLARIZZATO
                    ,COD_NDG
                    ,COD_SNDG
                    ,CR_LG.COD_OPERATORE_INS_UPD
                    ,CR_LG.COD_SNDG_LG
                    ,CR_LG.DTA_RIFERIMENTO_CR
                    ,CR_LG.ID_DPER
                    ,CR_LG.VAL_ACC_LGGB
                    ,CR_LG.VAL_ACC_SIS_LG
                    ,CR_LG.VAL_GAR_LGGB
                    ,CR_LG.VAL_IMP_GAR_SIS_LG
                    ,CR_LG.VAL_SCO_LGGB
                    ,CR_LG.VAL_SCO_SIS_LG
                    ,CR_LG.VAL_UTI_LGGB
                    ,CR_LG.VAL_UTI_SIS_LG
                    ,CR_LG.DTA_INS
                    ,CR_LG.DTA_UPD
                    --v2.2 number
                    ,CASE WHEN ROUND(cr_lg.VAL_ACC_LGGB / ( (CASE WHEN NVL(cr_lg.VAL_ACC_SIS_LG,0) = 0 THEN -1 ELSE cr_lg.VAL_ACC_SIS_LG  END) )*100) < 0 THEN null ELSE ROUND(cr_lg.VAL_ACC_LGGB / ( (CASE WHEN NVL(cr_lg.VAL_ACC_SIS_LG,0) = 0 THEN -1 ELSE cr_lg.VAL_ACC_SIS_LG  END) )*100) END glgb_qis_acc
                    ,CASE WHEN ROUND(cr_lg.VAL_UTI_LGGB / ( (CASE WHEN NVL(cr_lg.VAL_UTI_SIS_LG,0) = 0 THEN -1 ELSE cr_lg.VAL_UTI_SIS_LG  END) )*100) < 0 THEN null ELSE ROUND(cr_lg.VAL_UTI_LGGB / ( (CASE WHEN NVL(cr_lg.VAL_UTI_SIS_LG,0) = 0 THEN -1 ELSE cr_lg.VAL_UTI_SIS_LG  END) )*100) END glgb_qis_uti
            from    T_MCRE0_APP_FILE_GUIDA24 FG, 
                    T_MCRE0_APP_CR_LG_GB24 CR_LG,
                    v_mcre0_ultima_acquisizione a
            where   cr_lg.COD_SNDG_LG = fg.COD_SNDG
            and     cr_lg.ID_DPER = a.idper
            and     a.cod_file = 'CR_LG_GB'
        ) CRLG
        ON (CR.COD_ABI_CARTOLARIZZATO = CRLG.COD_ABI_CARTOLARIZZATO
        AND CR.COD_NDG = CRLG.COD_NDG )
        WHEN MATCHED THEN
            UPDATE SET
                 CR.GLGB_COD_SNDG       =   CRLG.COD_SNDG_LG
                ,CR.GLGB_ACC_CR         =   CRLG.VAL_ACC_LGGB
                ,CR.GLGB_UTI_CR         =   CRLG.VAL_UTI_LGGB
                ,CR.GLGB_SCO_CR         =   CRLG.VAL_SCO_LGGB
                ,CR.GLGB_GAR_CR         =   CRLG.VAL_GAR_LGGB
                ,CR.GLGB_ACC_SIS        =   CRLG.VAL_ACC_SIS_LG
                ,CR.GLGB_UTI_SIS        =   CRLG.VAL_UTI_SIS_LG
                ,CR.GLGB_SCO_SIS        =   CRLG.VAL_SCO_SIS_LG
                ,CR.GLGB_IMP_GAR_SIS    =   CRLG.VAL_IMP_GAR_SIS_LG
                ,CR.GLGB_DTA_RIF_CR     =   CRLG.DTA_RIFERIMENTO_CR
                ,CR.GLGB_DTA_INS        =   CRLG.DTA_INS
                ,CR.GLGB_DTA_UPD        =   CRLG.DTA_UPD
                ,CR.GLGB_COD_OP_INS_UPD =   CRLG.COD_OPERATORE_INS_UPD
                ,CR.GLGB_ID_DPER        =   CRLG.ID_DPER
                ,CR.GLGB_QIS_ACC        =   CRLG.GLGB_QIS_ACC
                ,CR.GLGB_QIS_UTI        =   CRLG.GLGB_QIS_UTI
                ,CR.COD_SNDG            =   CRLG.COD_SNDG
        WHEN NOT MATCHED THEN
            INSERT(
                     CR.COD_ABI_CARTOLARIZZATO
                    ,CR.COD_NDG
                    ,CR.GLGB_COD_SNDG
                    ,CR.GLGB_ACC_CR
                    ,CR.GLGB_ACC_SIS
                    ,CR.GLGB_GAR_CR
                    ,CR.GLGB_IMP_GAR_SIS
                    ,CR.GLGB_SCO_CR
                    ,CR.GLGB_SCO_SIS
                    ,CR.GLGB_UTI_CR
                    ,CR.GLGB_UTI_SIS
                    ,CR.GLGB_COD_OP_INS_UPD
                    ,CR.GLGB_DTA_INS
                    ,CR.GLGB_DTA_RIF_CR
                    ,CR.GLGB_DTA_UPD
                    ,CR.GLGB_ID_DPER
                    ,CR.GLGB_QIS_ACC
                    ,CR.GLGB_QIS_UTI
                    ,CR.COD_SNDG
            )
            VALUES(
                     CRLG.COD_ABI_CARTOLARIZZATO
                    ,CRLG.COD_NDG
                    ,CRLG.COD_SNDG
                    ,CRLG.VAL_ACC_LGGB
                    ,CRLG.VAL_ACC_SIS_LG
                    ,CRLG.VAL_GAR_LGGB
                    ,CRLG.VAL_IMP_GAR_SIS_LG
                    ,CRLG.VAL_SCO_LGGB
                    ,CRLG.VAL_SCO_SIS_LG
                    ,CRLG.VAL_UTI_LGGB
                    ,CRLG.VAL_UTI_SIS_LG
                    ,CRLG.COD_OPERATORE_INS_UPD
                    ,CRLG.DTA_INS
                    ,CRLG.DTA_RIFERIMENTO_CR
                    ,CRLG.DTA_UPD
                    ,CRLG.ID_DPER
                    ,CRLG.GLGB_QIS_ACC
                    ,CRLG.GLGB_QIS_UTI
                    ,CRLG.COD_SNDG
            );
            COMMIT;
            PKG_MCRE0_AUDIT.log_etl(P_COD_LOG, 'FNC_LOAD_CR_LG_GB', 3, sqlcode, 'LGGB: - t_mcre0_app_cr', 'Tutto ok');
        return val_ok;
    EXCEPTION
        WHEN OTHERS THEN
            PKG_MCRE0_AUDIT.log_etl(P_COD_LOG, 'FNC_LOAD_CR_LG_GB', 3, sqlcode, 'LGGB: - t_mcre0_app_cr', 'SQLERRM: '||SQLERRM);
            return ko;
    END FNC_LOAD_CR_LG_GB;


END PKG_MCRE0_CR;
/


CREATE SYNONYM MCRE_APP.PKG_MCRE0_CR FOR MCRE_OWN.PKG_MCRE0_CR;


CREATE SYNONYM MCRE_USR.PKG_MCRE0_CR FOR MCRE_OWN.PKG_MCRE0_CR;


GRANT EXECUTE, DEBUG ON MCRE_OWN.PKG_MCRE0_CR TO MCRE_USR;

