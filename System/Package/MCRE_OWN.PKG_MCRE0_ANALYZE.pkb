CREATE OR REPLACE PACKAGE BODY MCRE_OWN.PKG_MCRE0_ANALYZE
AS
/******************************************************************************
   NAME:       PKG_MCRE0_ANALYZE
   PURPOSE:

   REVISIONS:
   Ver        Date        Author             Description
   ---------  ----------  -----------------  ------------------------------------
   1.0        ??/??/2010  ??                Created this package.
   1.1        02/02/2012  L.Ferretti        Aggiornato cursore.
   1.2        14/02/2012  L.Ferretti        Aggiunta funzione per statistiche nel weekend.
******************************************************************************/
   pkgname     CONSTANT VARCHAR2 (30) := 'PKG_MCRE0_ANALYZE';
   defdegree   CONSTANT NUMBER        := 4;
   esito_ok    CONSTANT NUMBER        := 3;
   esito_ko    CONSTANT NUMBER        := 1;

   CURSOR cparams (pschema IN VARCHAR2, ptable IN VARCHAR2)
   IS
      SELECT
            BLOCK_SAMPLE ,
            CASCADE	,
            DEGREE	,
            ESTIMATE_PERCENT	,
            GRANULARITY	,
            METHOD_OPTION ,
            FORCE,
            NO_INVALIDATE
       FROM T_MCRE0_WRK_STATISTICHE
       WHERE table_name = ptable AND table_owner = pschema;

   CURSOR cweek (pschema IN VARCHAR2, ptable IN VARCHAR2)
   IS
     SELECT
            WEEK_BLOCK_SAMPLE,
            WEEK_CASCADE,
            WEEK_DEGREE,
            WEEK_ESTIMATE_PERCENT,
            WEEK_GRANULARITY,
            WEEK_METHOD_OPTION,
            WEEK_FORCE,
            WEEK_NO_INVALIDATE
     FROM   T_MCRE0_WRK_STATISTICHE
     WHERE  table_name = ptable AND table_owner = pschema
     AND    WEEKEND='1';


   FUNCTION FND_MCRE0_analyze_table_FL (
      pschema   IN   T_MCRE0_WRK_STATISTICHE.table_owner%TYPE DEFAULT USER,
      ptable    IN   T_MCRE0_WRK_STATISTICHE.table_name%TYPE
   )
   RETURN BOOLEAN IS
      procedura        CONSTANT PKG_MCRE0_QD_TYPES.nome_procedura
                                                           := 'FND_MCRE0_analyze_table_FL';
      m_procedura      CONSTANT PKG_MCRE0_QD_TYPES.chiamata
                                               := pkgname || '.' || procedura;
      v_estimatepercent           NUMBER;
      v_blocksample               NUMBER;
      p_blocksample               BOOLEAN;
      v_methodoption              VARCHAR2 (2000);
      pdegree                     NUMBER;
      v_granularity               VARCHAR2 (30);
      v_cascade                   NUMBER;
      p_cascade                   BOOLEAN;
      sttime                      DATE;
      stepname                    VARCHAR2 (60);
      pcascade                    BOOLEAN;
      pbsample                    BOOLEAN;
      v_trovato                   BOOLEAN;
      tabella_non_configurata     EXCEPTION;
      stmt                        VARCHAR2 (100);
      preturn                     BOOLEAN;
      ppartition                  varchar2(100) default null;
      v_invalidate                 varchar2(10);
      pinvalidate                 BOOLEAN;
      v_force                     number;
      pforce                      BOOLEAN;

   BEGIN

      stmt := 'alter session set query_rewrite_enabled=false';

      EXECUTE IMMEDIATE stmt;

      v_trovato := FALSE;

      OPEN cparams (pschema, ptable);

      FETCH cparams
      INTO v_blocksample, v_cascade, pdegree, v_estimatepercent, v_granularity, v_methodoption, v_force, v_invalidate;

      v_trovato := cparams%FOUND;
      CLOSE cparams;

      if v_blocksample = 0
      then
      pbsample :=  FALSE;
      else
      pbsample :=TRUE;
       end if;

      if v_cascade = 0
      then
      p_cascade :=  FALSE;
      else
      p_cascade :=TRUE;
       end if;

      if v_force = 0
      then
        pforce :=  FALSE;
      else
        pforce :=TRUE;
       end if;

      if v_invalidate = 0
      then
        pinvalidate :=  FALSE;
      else
        pinvalidate :=TRUE;
       end if;

      IF NOT v_trovato
      THEN
         PKG_MCRE0_LOG.SPO_MCRE0_LOG_EVENTO ( -777, ptable||' - '||procedura, esito_ko, 'tabella_non_configurata' );
         RAISE tabella_non_configurata;
      END IF;

      sttime := SYSDATE;
        PKG_MCRE0_LOG.SPO_MCRE0_LOG_EVENTO ( -777, ptable||' - '||procedura, esito_ok, 'pschema: '||pschema );
        PKG_MCRE0_LOG.SPO_MCRE0_LOG_EVENTO ( -777, ptable||' - '||procedura, esito_ok, 'ptable: '||ptable );
        PKG_MCRE0_LOG.SPO_MCRE0_LOG_EVENTO ( -777, ptable||' - '||procedura, esito_ok, 'ppartition: '||ppartition );
        PKG_MCRE0_LOG.SPO_MCRE0_LOG_EVENTO ( -777, ptable||' - '||procedura, esito_ok, 'v_estimatepercent: '||v_estimatepercent );
        PKG_MCRE0_LOG.SPO_MCRE0_LOG_EVENTO ( -777, ptable||' - '||procedura, esito_ok, 'pbsample: '||v_blocksample );
        PKG_MCRE0_LOG.SPO_MCRE0_LOG_EVENTO ( -777, ptable||' - '||procedura, esito_ok, 'v_methodoption: '||v_methodoption );
        PKG_MCRE0_LOG.SPO_MCRE0_LOG_EVENTO ( -777, ptable||' - '||procedura, esito_ok, 'pdegree: '||pdegree );
        PKG_MCRE0_LOG.SPO_MCRE0_LOG_EVENTO ( -777, ptable||' - '||procedura, esito_ok, 'v_granularity: '||v_granularity );
        PKG_MCRE0_LOG.SPO_MCRE0_LOG_EVENTO ( -777, ptable||' - '||procedura, esito_ok, 'pcascade: '||v_cascade );
        PKG_MCRE0_LOG.SPO_MCRE0_LOG_EVENTO ( -777, ptable||' - '||procedura, esito_ok, 'pinvalidate: '||v_invalidate );
        PKG_MCRE0_LOG.SPO_MCRE0_LOG_EVENTO ( -777, ptable||' - '||procedura, esito_ok, 'pforce: '||v_force );


      stepname := 'Tabella FL';
      DBMS_OUTPUT.PUT_LINE(stepname);

    DBMS_STATS.gather_table_stats (
                             ownname               => pschema,
                             tabname               => ptable,
                             partname              => ppartition,
                             estimate_percent      => v_estimatepercent,
                             block_sample          => p_blocksample,
                             method_opt            => v_methodoption,
                             degree                => pdegree,
                             granularity           => v_granularity,
                             CASCADE               => pcascade,
                             no_invalidate         => pinvalidate,
                             force                 => pforce
                            );

      preturn := TRUE;
      RETURN preturn;

   EXCEPTION
     WHEN tabella_non_configurata
      THEN
        PKG_MCRE0_LOG.SPO_MCRE0_LOG_EVENTO ( -777, ptable||' - '||procedura, esito_ko,'ERRORE IN FND_MCRE0_analyze_table_FL - ERRORE: '||SQLERRM );
         preturn := FALSE;
         return TRUE;
--         RAISE;
      WHEN OTHERS
      THEN
        PKG_MCRE0_LOG.SPO_MCRE0_LOG_EVENTO ( -777, ptable||' - '||procedura, esito_ko,'ERRORE IN FND_MCRE0_analyze_table_FL - ERRORE: '||SQLERRM );
         preturn := FALSE;
         return TRUE;
--         RAISE;
   END;

   FUNCTION FND_MCRE0_analyze_table_ST (
      pschema      IN   T_MCRE0_WRK_STATISTICHE.table_owner%TYPE DEFAULT USER,
      ptable       IN   T_MCRE0_WRK_STATISTICHE.table_name%TYPE,
      ppartition   IN   VARCHAR2 default NULL
   )
   RETURN BOOLEAN IS
      procedura        CONSTANT PKG_MCRE0_QD_TYPES.nome_procedura
                                                           := 'FND_MCRE0_analyze_table_ST';
      m_procedura      CONSTANT PKG_MCRE0_QD_TYPES.chiamata
                                               := pkgname || '.' || procedura;
      v_estimatepercent           NUMBER;
      v_blocksample               NUMBER;
      v_methodoption              VARCHAR2 (2000);
      pdegree                   NUMBER;
      v_granularity               VARCHAR2 (30);
      v_cascade                  NUMBER;
      pcascade                  BOOLEAN;
      pbsample                  BOOLEAN;
      sttime                    DATE;
      stepname                  VARCHAR2 (60);
      v_trovato                   BOOLEAN;
      tabella_non_configurata   EXCEPTION;
      preturn                     BOOLEAN;
      v_invalidate                 varchar2(10);
      pinvalidate                 BOOLEAN;
      v_force                     number;
      pforce                      BOOLEAN;
      stmt                      VARCHAR2 (100);

   BEGIN
      stmt := 'alter session set query_rewrite_enabled=false';
      EXECUTE IMMEDIATE stmt;
      v_trovato := FALSE;

      OPEN cparams (pschema, ptable);

      FETCH cparams
      INTO v_blocksample, v_cascade, pdegree, v_estimatepercent, v_granularity, v_methodoption, v_force, v_invalidate;

      v_trovato := cparams%FOUND;

      CLOSE cparams;

      IF NOT v_trovato
      THEN
         RAISE tabella_non_configurata;
      END IF;

      IF v_cascade = 1
      THEN
         pcascade := TRUE;
      ELSE
         pcascade := FALSE;
      END IF;

      IF v_blocksample = 1
      THEN
         pbsample := TRUE;
      ELSE
         pbsample := FALSE;
      END IF;

      if v_force = 0
      then
        pforce :=  FALSE;
      else
        pforce :=TRUE;
       end if;

      if v_invalidate = 0
      then
        pinvalidate :=  FALSE;
      else
        pinvalidate :=TRUE;
       end if;

      sttime := SYSDATE;

        PKG_MCRE0_LOG.SPO_MCRE0_LOG_EVENTO ( -777, ptable||' - '||procedura, esito_ok, 'pschema: '||pschema );
        PKG_MCRE0_LOG.SPO_MCRE0_LOG_EVENTO ( -777, ptable||' - '||procedura, esito_ok, 'ptable: '||ptable );
        PKG_MCRE0_LOG.SPO_MCRE0_LOG_EVENTO ( -777, ptable||' - '||procedura, esito_ok, 'ppartition: '||ppartition );
        PKG_MCRE0_LOG.SPO_MCRE0_LOG_EVENTO ( -777, ptable||' - '||procedura, esito_ok, 'v_estimatepercent: '||v_estimatepercent );
        PKG_MCRE0_LOG.SPO_MCRE0_LOG_EVENTO ( -777, ptable||' - '||procedura, esito_ok, 'pbsample: '||v_blocksample );
        PKG_MCRE0_LOG.SPO_MCRE0_LOG_EVENTO ( -777, ptable||' - '||procedura, esito_ok, 'v_methodoption: '||v_methodoption );
        PKG_MCRE0_LOG.SPO_MCRE0_LOG_EVENTO ( -777, ptable||' - '||procedura, esito_ok, 'pdegree: '||pdegree );
        PKG_MCRE0_LOG.SPO_MCRE0_LOG_EVENTO ( -777, ptable||' - '||procedura, esito_ok, 'v_granularity: '||v_granularity );
        PKG_MCRE0_LOG.SPO_MCRE0_LOG_EVENTO ( -777, ptable||' - '||procedura, esito_ok, 'pcascade: '||v_cascade );
        PKG_MCRE0_LOG.SPO_MCRE0_LOG_EVENTO ( -777, ptable||' - '||procedura, esito_ok, 'pinvalidate: '||v_invalidate );
        PKG_MCRE0_LOG.SPO_MCRE0_LOG_EVENTO ( -777, ptable||' - '||procedura, esito_ok, 'pforce: '||v_force );

      stepname := 'Tabella ST';
      DBMS_OUTPUT.PUT_LINE(stepname);
      DBMS_STATS.gather_table_stats (
                             ownname               => pschema,
                             tabname               => ptable,
                             partname              => ppartition,
                             estimate_percent      => v_estimatepercent,
                             block_sample          => pbsample,
                             method_opt            => v_methodoption,
                             degree                => pdegree,
                             granularity           => v_granularity,
                             CASCADE               => pcascade,
                             no_invalidate         => pinvalidate,
                             force                 => pforce
                            );

    preturn := TRUE;
    RETURN preturn;

   EXCEPTION
      WHEN tabella_non_configurata
      THEN
       PKG_MCRE0_LOG.SPO_MCRE0_LOG_EVENTO ( -777, ptable||' - '||procedura, esito_ko,'ERRORE IN FND_MCRE0_analyze_table_ST - ERRORE: '||SQLERRM );
       preturn := FALSE;
       return TRUE;
--       RAISE;

      WHEN OTHERS
      THEN
       PKG_MCRE0_LOG.SPO_MCRE0_LOG_EVENTO ( -777, ptable||' - '||procedura, esito_ko,'ERRORE IN FND_MCRE0_analyze_table_ST - ERRORE: '||SQLERRM );
         preturn := FALSE;
         return TRUE;
--         RAISE;
   END;

  FUNCTION FND_MCRE0_analyze_table_APP (
      pschema   IN   T_MCRE0_WRK_STATISTICHE.table_owner%TYPE DEFAULT USER,
      ptable    IN   T_MCRE0_WRK_STATISTICHE.table_name%TYPE
   )
   RETURN BOOLEAN IS
      procedura        CONSTANT PKG_MCRE0_QD_TYPES.nome_procedura
                                                           := 'FND_MCRE0_analyze_table_APP';
      m_procedura      CONSTANT PKG_MCRE0_QD_TYPES.chiamata
                                               := pkgname || '.' || procedura;
      v_estimatepercent           NUMBER;
      v_blocksample               NUMBER;
      p_blocksample               BOOLEAN;
      v_methodoption              VARCHAR2 (2000);
      pdegree                     NUMBER;
      v_granularity               VARCHAR2 (30);
      v_cascade                   NUMBER;
      p_cascade                   BOOLEAN;
      sttime                      DATE;
      stepname                    VARCHAR2 (60);
      pcascade                    BOOLEAN;
      pbsample                    BOOLEAN;
      v_trovato                   BOOLEAN;
      tabella_non_configurata     EXCEPTION;
      stmt                        VARCHAR2 (100);
      preturn                     BOOLEAN;
      ppartition                  varchar2(100) default null;
      v_invalidate                 varchar2(10);
      pinvalidate                 BOOLEAN;
      v_force                     number;
      pforce                      BOOLEAN;


   BEGIN

      stmt := 'alter session set query_rewrite_enabled=false';
      EXECUTE IMMEDIATE stmt;
      v_trovato := FALSE;

      OPEN cparams (pschema, ptable);

      FETCH cparams
      INTO v_blocksample, v_cascade, pdegree, v_estimatepercent, v_granularity, v_methodoption, v_force, v_invalidate;

      v_trovato := cparams%FOUND;

      CLOSE cparams;

      if v_blocksample = 0
      then
      p_blocksample :=  FALSE;
      else
      p_blocksample :=TRUE;
       end if;

      if v_cascade = 0
      then
      p_cascade :=  FALSE;
      else
      p_cascade :=TRUE;
       end if;

      IF NOT v_trovato
      THEN
         RAISE tabella_non_configurata;
      END IF;

      if v_force = 0
      then
        pforce :=  FALSE;
      else
        pforce :=TRUE;
       end if;

      if v_invalidate = 0
      then
        pinvalidate :=  FALSE;
      else
        pinvalidate :=TRUE;
       end if;

      sttime := SYSDATE;

        PKG_MCRE0_LOG.SPO_MCRE0_LOG_EVENTO ( -777, ptable||' - '||procedura, esito_ok, 'pschema: '||pschema );
        PKG_MCRE0_LOG.SPO_MCRE0_LOG_EVENTO ( -777, ptable||' - '||procedura, esito_ok, 'ptable: '||ptable );
        PKG_MCRE0_LOG.SPO_MCRE0_LOG_EVENTO ( -777, ptable||' - '||procedura, esito_ok, 'ppartition: '||ppartition );
        PKG_MCRE0_LOG.SPO_MCRE0_LOG_EVENTO ( -777, ptable||' - '||procedura, esito_ok, 'v_estimatepercent: '||v_estimatepercent );
        PKG_MCRE0_LOG.SPO_MCRE0_LOG_EVENTO ( -777, ptable||' - '||procedura, esito_ok, 'pbsample: '||v_blocksample );
        PKG_MCRE0_LOG.SPO_MCRE0_LOG_EVENTO ( -777, ptable||' - '||procedura, esito_ok, 'v_methodoption: '||v_methodoption );
        PKG_MCRE0_LOG.SPO_MCRE0_LOG_EVENTO ( -777, ptable||' - '||procedura, esito_ok, 'pdegree: '||pdegree );
        PKG_MCRE0_LOG.SPO_MCRE0_LOG_EVENTO ( -777, ptable||' - '||procedura, esito_ok, 'v_granularity: '||v_granularity );
        PKG_MCRE0_LOG.SPO_MCRE0_LOG_EVENTO ( -777, ptable||' - '||procedura, esito_ok, 'pcascade: '||v_cascade );
        PKG_MCRE0_LOG.SPO_MCRE0_LOG_EVENTO ( -777, ptable||' - '||procedura, esito_ok, 'pinvalidate: '||v_invalidate );
        PKG_MCRE0_LOG.SPO_MCRE0_LOG_EVENTO ( -777, ptable||' - '||procedura, esito_ok, 'pforce: '||v_force );

      stepname := 'Tabella APP';
      DBMS_OUTPUT.PUT_LINE(stepname);
      DBMS_STATS.gather_table_stats (
                             ownname               => pschema,
                             tabname               => ptable,
                             partname              => ppartition,
                             estimate_percent      => v_estimatepercent,
                             block_sample          => pbsample,
                             method_opt            => v_methodoption,
                             degree                => pdegree,
                             granularity           => v_granularity,
                             CASCADE               => pcascade,
                             no_invalidate         => pinvalidate,
                             force                 => pforce
                            );
       preturn := TRUE;
       RETURN preturn;

   EXCEPTION
     WHEN tabella_non_configurata
      THEN
       PKG_MCRE0_LOG.SPO_MCRE0_LOG_EVENTO ( -777, ptable||' - '||procedura, esito_ko,'ERRORE IN FND_MCRE0_analyze_table_APP - ERRORE: '||SQLERRM );
         preturn := FALSE;
         return TRUE;
--         RAISE;
      WHEN OTHERS
      THEN
       PKG_MCRE0_LOG.SPO_MCRE0_LOG_EVENTO ( -777, ptable||' - '||procedura, esito_ko,'ERRORE IN FND_MCRE0_analyze_table_APP - ERRORE: '||SQLERRM );
       preturn := FALSE;
       return TRUE;
--      RAISE;
   END;

FUNCTION FND_MCRE0_analyze_table_WEEKLY (
      pschema      IN   T_MCRE0_WRK_STATISTICHE.table_owner%TYPE DEFAULT USER,
      ptable       IN   T_MCRE0_WRK_STATISTICHE.table_name%TYPE,
      ppartition   IN   VARCHAR2 default NULL
   )
   RETURN BOOLEAN IS
      procedura         CONSTANT PKG_MCRE0_QD_TYPES.nome_procedura := 'FND_MCRE0_analyze_table_WEEKLY';
      m_procedura       CONSTANT PKG_MCRE0_QD_TYPES.chiamata := pkgname || '.' || procedura;
      v_estimatepercent             NUMBER;
      v_blocksample                 NUMBER;
      v_methodoption                VARCHAR2 (2000);
      pdegree                       NUMBER;
      v_granularity                 VARCHAR2 (30);
      v_cascade                     NUMBER;
      pcascade                      BOOLEAN;
      pbsample                      BOOLEAN;
      sttime                        DATE;
      stepname                      VARCHAR2 (60);
      v_trovato                     BOOLEAN;
      tabella_non_configurata       EXCEPTION;
      preturn                       BOOLEAN;
      v_invalidate                  varchar2(10);
      pinvalidate                   BOOLEAN;
      v_force                       number;
      pforce                        BOOLEAN;
      stmt                          VARCHAR2 (100);
      v_seq                           number;

   BEGIN
      select SEQ_MCR0_LOG_ETL.nextval into v_seq from dual;
      stmt := 'alter session set query_rewrite_enabled=false';
      EXECUTE IMMEDIATE stmt;
      v_trovato := FALSE;

      OPEN cweek (pschema, ptable);

      FETCH cweek
      INTO v_blocksample, v_cascade, pdegree, v_estimatepercent, v_granularity, v_methodoption, v_force, v_invalidate;

      v_trovato := cweek%FOUND;

      CLOSE cweek;

      IF NOT v_trovato
      THEN
         RAISE tabella_non_configurata;
      END IF;

      IF v_cascade = 1
      THEN
         pcascade := TRUE;
      ELSE
         pcascade := FALSE;
      END IF;

      IF v_blocksample = 1
      THEN
         pbsample := TRUE;
      ELSE
         pbsample := FALSE;
      END IF;

      if v_force = 0
      then
        pforce :=  FALSE;
      else
        pforce :=TRUE;
       end if;

      if v_invalidate = 0
      then
        pinvalidate :=  FALSE;
      else
        pinvalidate :=TRUE;
       end if;

      sttime := SYSDATE;

        PKG_MCRE0_LOG.SPO_MCRE0_LOG_EVENTO ( v_seq, ptable||' - '||procedura, esito_ok, 'pschema: '||pschema );
        PKG_MCRE0_LOG.SPO_MCRE0_LOG_EVENTO ( v_seq, ptable||' - '||procedura, esito_ok, 'ptable: '||ptable );
        PKG_MCRE0_LOG.SPO_MCRE0_LOG_EVENTO ( v_seq, ptable||' - '||procedura, esito_ok, 'ppartition: '||ppartition );
        PKG_MCRE0_LOG.SPO_MCRE0_LOG_EVENTO ( v_seq, ptable||' - '||procedura, esito_ok, 'v_estimatepercent: '||v_estimatepercent );
        PKG_MCRE0_LOG.SPO_MCRE0_LOG_EVENTO ( v_seq, ptable||' - '||procedura, esito_ok, 'pbsample: '||v_blocksample );
        PKG_MCRE0_LOG.SPO_MCRE0_LOG_EVENTO ( v_seq, ptable||' - '||procedura, esito_ok, 'v_methodoption: '||v_methodoption );
        PKG_MCRE0_LOG.SPO_MCRE0_LOG_EVENTO ( v_seq, ptable||' - '||procedura, esito_ok, 'pdegree: '||pdegree );
        PKG_MCRE0_LOG.SPO_MCRE0_LOG_EVENTO ( v_seq, ptable||' - '||procedura, esito_ok, 'v_granularity: '||v_granularity );
        PKG_MCRE0_LOG.SPO_MCRE0_LOG_EVENTO ( v_seq, ptable||' - '||procedura, esito_ok, 'pcascade: '||v_cascade );
        PKG_MCRE0_LOG.SPO_MCRE0_LOG_EVENTO ( v_seq, ptable||' - '||procedura, esito_ok, 'pinvalidate: '||v_invalidate );
        PKG_MCRE0_LOG.SPO_MCRE0_LOG_EVENTO ( v_seq, ptable||' - '||procedura, esito_ok, 'pforce: '||v_force );

      stepname := 'WEEKLY';
      DBMS_STATS.gather_table_stats (
                             ownname               => pschema,
                             tabname               => ptable,
                             partname              => ppartition,
                             estimate_percent      => v_estimatepercent,
                             block_sample          => pbsample,
                             method_opt            => v_methodoption,
                             degree                => pdegree,
                             granularity           => v_granularity,
                             CASCADE               => pcascade,
                             no_invalidate         => pinvalidate,
                             force                 => pforce
                            );

    preturn := TRUE;
    RETURN preturn;

   EXCEPTION
      WHEN tabella_non_configurata
      THEN
       PKG_MCRE0_LOG.SPO_MCRE0_LOG_EVENTO ( v_seq, ptable||' - '||procedura, esito_ko,'ERRORE IN FND_MCRE0_analyze_table_WEEKLY - ERRORE: '||SQLERRM );
       preturn := FALSE;
       return TRUE;

      WHEN OTHERS
      THEN
       PKG_MCRE0_LOG.SPO_MCRE0_LOG_EVENTO ( v_seq, ptable||' - '||procedura, esito_ko,'ERRORE IN FND_MCRE0_analyze_table_WEEKLY - ERRORE: '||SQLERRM );
         preturn := FALSE;
         return TRUE;
   END;

END;
/


CREATE SYNONYM MCRE_APP.PKG_MCRE0_ANALYZE FOR MCRE_OWN.PKG_MCRE0_ANALYZE;


CREATE SYNONYM MCRE_USR.PKG_MCRE0_ANALYZE FOR MCRE_OWN.PKG_MCRE0_ANALYZE;


GRANT EXECUTE, DEBUG ON MCRE_OWN.PKG_MCRE0_ANALYZE TO MCRE_USR;

