CREATE OR REPLACE PACKAGE BODY MCRE_OWN."PKG_MCRE0_ESTENDI_FILE_GUIDA2" AS
/******************************************************************************
   NAME:       PKG_MCRE0_ALIMENTAZIONE
   PURPOSE:

   REVISIONS:
   Ver        Date        Author             Description
   ---------  ----------  -----------------  ------------------------------------
   1.0        11/10/2010  Marco Murro        Created this package.
   1.1        24/11/2010  Marco Murro        filtri per IDDPER attivo
   1.2        02/12/2010  Marco Murro        aggiornata update_file_guida x filtrare il primo caricamento
   1.3        13/12/2010  Marco Murro        Aggiunto gestione Ramo (al posto di comparto)
   1.4        09/02/2011  Marco Murro        fix gestione gl-ge-flg
   1.5        14/02/2011  Marco Murro        estesa fix a superGruppo
   1.6        15/02/2011  Marco Murro        aggiorna nuovi collegati --> check su dta_upd
   1.7        22/02/2011  M.Murro Gianna     aggiunta pulizia posizioni uscite
   1.8        01/03/2011  Marco Murro        fix rimuovi prenotazione - annulla anche sezione
   1.9        07/03/2011  Marco Murro        check riportafogliazione solo in uscita da tavoli
   2.0        24/03/2011  Marco Murro        fix check riportafogliazione e storico riport.
   2.1        12/04/2011  Marco Murro        variato nuovi collegati
   2.2        09/05/2011  Marco Murro        semplificata Riportafogliazione + inizializzazione servizio
   2.3        24/05/2011  Marco Murro        aggiunta pulizia comparto per stati non gestiti + GB (fix 06.06)
   2.4        14/06/2011  Marco Murro        migliorie per performance
   2.5        04/07/2011  Marco Murro        Assegnazione comparto x Avocazioni
   3.0        18/07/2011  Marco Murre        Nuove strutture per tuning
   3.11       22/09/2011  Marco Murre        fix gestione flag, cambio nuovi ingressi
   3.12       19/10/2011  Paola Goitre       modificate set_cod_ge_gl,calc_cod_collegamento,calc_comparto,aggiorna_nuovi_collegati
   3.13       19/10/2011  Marco Murro        ripristinata calc_comparto
   3.2        28/10/2011  Marco Murre        Fix uscite automatiche: check sui soli outsourcing
   3.3        16/11/2011  Marco Murre        Fix assegnaCompartiGB - distinct!
   3.4        27/03/2012  Paola Goitre       aggiunta condizione selettiva di Silvio Bellani su calc_cod_collegamento
   4.0        21/05/2012  Marco Murro        Trascinamenti configurabili
   4.1        21/05/2012  Valeria Galli      Commenti con label:   VG - CIB/BDT - INIZIO
   4.2        08/11/2012  Luca Ferretti      Modifica update_file_guida_pre update solo del today_flg
   4.3        08/11/2012  Luca Ferretti      Aggiornamento log
   4.4        12/11/2012  Marco Murro        Aggiornamento disassegna-non_gestiti x GB
   4.5        21/11/2012  Marco Murro        fix aggiorna nuovi collegati per utente più vecchio
   5.0        23/11/2012  Emiliano Pellizzi  modifica calc_comparto con aggiunta calcolo cod_gruppo_super di AR e RG
   5.1        26/06/2013  Marco Murro        fix disassegna + gruppo_super_old
   5.2        20/08/2013  Marco Murro        fix disassegna x SO
******************************************************************************/

  FUNCTION update_file_guida_pre(p_storico number default 0) return number IS

    activ_id number;
    seq number;

  BEGIN

    select SEQ_MCR0_LOG_ETL.nextval
    into seq from dual;

--      log_caricamenti (c_package || '.UPDATE_FILE_GUIDA_pre - start', -2, 'storico:'||p_storico);
      PKG_MCRE0_AUDIT.LOG_ETL(seq, c_package||'.UPDATE_FILE_GUIDA_pre - start - storico:'||p_storico, PKG_MCRE0_AUDIT.C_DEBUG,SQLCODE,SQLERRM,'INIZIO');

      --determino l'id_dper attivo
      select IDPER into activ_id
      from MCRE_OWN.V_MCRE0_ULTIMA_ACQUISIZIONE v
      where COD_FILE = c_file_guida;


      PKG_MCRE0_AUDIT.LOG_ETL(seq, c_package||'.UPDATE_FILE_GUIDA_pre - aggiornamento today_flg',PKG_MCRE0_AUDIT.C_DEBUG,SQLCODE,SQLERRM,'INIZIO');
      -- 4.2 Update solo su today_flg. Tutte le altre modifiche sono state fatte precedentemente (fra restore e merge sulla APP).
      UPDATE T_MCRE0_APP_FILE_GUIDA24
       SET TODAY_FLG =
              CASE WHEN (COD_ABI_CARTOLARIZZATO, COD_NDG) IN
                         (SELECT COD_ABI_CARTOLARIZZATO, COD_NDG FROM T_MCRE0_APP_MOPLE24 PARTITION (CCP_P1))
                 THEN '1' ELSE '0' END
       where TODAY_FLG !=
              CASE WHEN (COD_ABI_CARTOLARIZZATO, COD_NDG) IN
                         (SELECT COD_ABI_CARTOLARIZZATO, COD_NDG FROM T_MCRE0_APP_MOPLE24 PARTITION (CCP_P1))
                 THEN '1' ELSE '0'
              END;

      commit;

      PKG_MCRE0_AUDIT.LOG_ETL(seq, c_package||'.UPDATE_FILE_GUIDA_pre - aggiornamento today_flg',PKG_MCRE0_AUDIT.C_DEBUG,SQLCODE,SQLERRM,'FINE');
      PKG_MCRE0_AUDIT.LOG_ETL(seq, c_package||'.UPDATE_FILE_GUIDA_pre - aggiornamento flg_stato',PKG_MCRE0_AUDIT.C_DEBUG,SQLCODE,SQLERRM,'INIZIO');

      UPDATE  t_mcre0_app_gb_gestione
       SET  flg_stato = -2,                               --classificato da Mople
            dta_stato = SYSDATE
      WHERE  (cod_abi_cartolarizzato, cod_ndg) IN
                   (SELECT   g.cod_abi_cartolarizzato, g.cod_ndg
                      FROM   T_MCRE0_APP_MOPLE24 m,
                             t_mcre0_app_stati s,
                             t_mcre0_app_gb_gestione g,
                             V_MCRE0_ULTIMA_ACQUISIZIONE v
                     WHERE   G.COD_ABI_CARTOLARIZZATO = M.COD_ABI_CARTOLARIZZATO
                             AND G.COD_NDG = M.COD_NDG
                             AND V.COD_FILE = 'MOPLE'
                             AND M.ID_DPER = V.IDPER
                             AND M.COD_STATO = S.COD_MICROSTATO
                             AND S.FLG_STATO_CHK = '1'
                             AND G.FLG_STATO = 1);

      commit;
      PKG_MCRE0_AUDIT.LOG_ETL(seq, c_package||'.UPDATE_FILE_GUIDA_pre - aggiornamento flg_stato',PKG_MCRE0_AUDIT.C_DEBUG,SQLCODE,SQLERRM,'FINE');


      --v3.11 unico update complessivo (incluso annulla prenotazioni!)
    --  Update t_mcre0_app_file_guida
    --  set today_flg = case
    --    when (cod_abi_cartolarizzato, cod_ndg) in (select cod_abi_cartolarizzato, cod_ndg
    --                        from t_mcre0_app_mople PARTITION (CCP_P1)) then '1'
    --    else '0' end,
    --  flg_source = '0',
    --  COD_MATR_ASSEGNATORE = null,
    --  COD_COMPARTO_PREASSEGNATO = null,
    --  ID_UTENTE_PREASSEGNATO = null,
    --  COD_PROCESSO_PREASSEGNATO = null,
    --  COD_SEZIONE_PREASSEGNATA = null,
    --  flg_active = case when id_dper=activ_id then '1' else '0' end
    --  ;
--      commit;


        PKG_MCRE0_AUDIT.LOG_ETL(seq, c_package||'.UPDATE_FILE_GUIDA_pre - aggiornamento flg_source',PKG_MCRE0_AUDIT.C_DEBUG,SQLCODE,SQLERRM,'INIZIO');
      update t_mcre0_app_file_guida24 f
      set f.flg_source = case when F.TODAY_FLG = '1' then '1' else '2' end
      where (f.cod_abi_cartolarizzato, f.cod_ndg) in
        (SELECT COD_ABI_CARTOLARIZZATO, COD_NDG
         FROM MCRE_OWN.T_MCRE0_APP_GB_GESTIONE GB
         WHERE GB.FLG_STATO = 1) ;

        commit;
        PKG_MCRE0_AUDIT.LOG_ETL(seq, c_package||'.UPDATE_FILE_GUIDA_pre - aggiornamento flg_source',PKG_MCRE0_AUDIT.C_DEBUG,SQLCODE,SQLERRM,'FINE');

--      log_caricamenti (c_package || '.UPDATE_FILE_GUIDA_pre - ..', -2, 'gestione flags..');

       -- v3.11 - non serve più!
       --rimuovi_prenotazioni(activ_id);
       set_cod_ge_gl(activ_id);

        PKG_MCRE0_AUDIT.LOG_ETL(seq, c_package||'.UPDATE_FILE_GUIDA_pre - storico:'||p_storico, PKG_MCRE0_AUDIT.C_DEBUG,SQLCODE,SQLERRM,'FINE');
--       log_caricamenti (c_package || '.UPDATE_FILE_GUIDA_pre - end', -2, 'storico:'||p_storico);
       return 1;
  END;


  FUNCTION update_file_guida(p_storico number default 0) return number IS

    activ_id number;
    seq number;

  BEGIN

    select SEQ_MCR0_LOG_ETL.nextval
    into seq from dual;

--  log_caricamenti (c_package || '.UPDATE_FILE_GUIDA - start', -2, 'storico:'||p_storico);
    PKG_MCRE0_AUDIT.LOG_ETL(seq, c_package||'.UPDATE_FILE_GUIDA - storico: '||p_storico, PKG_MCRE0_AUDIT.C_DEBUG,SQLCODE,SQLERRM,'INIZIO');
  --determino l'id_dper attivo
  select IDPER into activ_id
  from MCRE_OWN.V_MCRE0_ULTIMA_ACQUISIZIONE v
  where COD_FILE = c_file_guida;

   calc_cod_collegamento(activ_id);
   calc_comparto(activ_id);
   check_riportafogliazione(activ_id);
   disassegna_stati_non_gestiti(activ_id);--v2.3
   aggiorna_nuovi_collegati(sysdate, activ_id);
   storicizza_riportafogliati(activ_id); --spostato v3.0

    PKG_MCRE0_AUDIT.LOG_ETL(seq, c_package||'.UPDATE_FILE_GUIDA - storico: '||p_storico, PKG_MCRE0_AUDIT.C_DEBUG,SQLCODE,SQLERRM,'FINE');
   --log_caricamenti (c_package || '.UPDATE_FILE_GUIDA - end', -2, 'storico:'||p_storico);
   return 1;
  END;

  --annulla i campi 'prenotati' eventualmente rimasti senza conferma
  PROCEDURE rimuovi_prenotazioni(activ_id number) IS

    seq number;

  BEGIN

        select SEQ_MCR0_LOG_ETL.nextval
            into seq from dual;

    update MCRE_OWN.T_MCRE0_APP_FILE_GUIDA24
    set COD_MATR_ASSEGNATORE = null,
    COD_COMPARTO_PREASSEGNATO = null,
    ID_UTENTE_PREASSEGNATO = null,
    COD_PROCESSO_PREASSEGNATO = null,
    COD_SEZIONE_PREASSEGNATA = null --v1.8
    where flg_active = '1';--v3.0

    commit;

  EXCEPTION WHEN OTHERS THEN
--    log_caricamenti(c_package||'.rimuovi_prenotazioni_non_confermate',SQLCODE, SQLERRM||' - rollback');
    PKG_MCRE0_AUDIT.LOG_ETL(seq, c_package||'.rimuovi_prenotazioni', PKG_MCRE0_AUDIT.C_ERROR,SQLCODE,SQLERRM,'ECCEZIONE');
    rollback;

  END;

  PROCEDURE set_cod_ge_gl(activ_id number) IS

    seq number;

  BEGIN

  --determino l'id_dper attivo
--  select IDPER into activ_id
--  from MCRE_OWN.V_MCRE0_ULTIMA_ACQUISIZIONE v
--  where COD_FILE = c_file_guida;

-- valorizzo i campi codice Gruppo Economico e Gruppo Legame
   BEGIN
    --     UPDATE mcre_own.t_mcre0_app_file_guida m
  --      SET (m.cod_gruppo_economico, m.cod_gruppo_legame, /*M.COD_TIPO_LEGAME,*/
  --         m.flg_gruppo_economico, m.flg_gruppo_legame, m.flg_condiviso,
  --         m.flg_singolo) =
  --          (SELECT cod_gruppo_economico, cod_gruppo_legame,/*COD_LEGAME,*/ fl_gruppo,
  --              fl_legame, '1', '0'
  --           FROM (SELECT fg.cod_abi_istituto,
  --                  fg.cod_abi_cartolarizzato, fg.cod_ndg,
  --                  ge.cod_gruppo_economico,
  --                  gl.cod_gruppo_legame,  /*GL.COD_LEGAME,*/
  --                  DECODE (ge.cod_gruppo_economico, NULL, '0','1') fl_gruppo,
  --                  DECODE (gl.cod_gruppo_legame,NULL, '0', '1') fl_legame
  --               FROM mcre_own.t_mcre0_app_file_guida fg,
  --                  mcre_own.t_mcre0_app_gruppo_economico ge,
  --                  mcre_own.t_mcre0_app_gruppo_legame gl
  --               WHERE fg.cod_sndg = ge.cod_sndg(+)
  --                  AND fg.cod_sndg = gl.cod_sndg(+)
  --                  AND fg.flg_active = '1') codici
  --           WHERE m.cod_abi_istituto = codici.cod_abi_istituto
  --            AND m.cod_abi_cartolarizzato = codici.cod_abi_cartolarizzato
  --            AND m.cod_ndg = codici.cod_ndg)
  --           where m.flg_active = '1';--09.02: deve stare fuori!
  --  v 3.12 PG rimossa subquery (resta commentata sopra)

    select SEQ_MCR0_LOG_ETL.nextval
    into seq from dual;

    PKG_MCRE0_AUDIT.LOG_ETL(seq, c_package||'.set_cod_ge_gl', PKG_MCRE0_AUDIT.C_DEBUG,SQLCODE,SQLERRM,'INIZIO');

    UPDATE /*+index(m IDX_MCRE0_APP_FILE_GUIDA_FA)*/ mcre_own.t_mcre0_app_file_guida24 m
    SET m.cod_gruppo_economico = (SELECT  ge.cod_gruppo_economico FROM mcre_own.t_mcre0_app_gruppo_economico24 ge WHERE m.cod_sndg = ge.cod_sndg(+) ),
      m.flg_gruppo_economico = nvl( (SELECT  DECODE (ge.cod_gruppo_economico, NULL, '0', '1')  FROM mcre_own.t_mcre0_app_gruppo_economico24 ge WHERE m.cod_sndg = ge.cod_sndg(+) ),'0'),
      m.cod_gruppo_legame   = (select cod_gruppo_legame FROM mcre_own.t_mcre0_app_gruppo_legame gl WHERE  m.cod_sndg = gl.cod_sndg(+)),
      m.flg_gruppo_legame   = nvl( (select DECODE (cod_gruppo_legame, NULL, '0', '1') FROM mcre_own.t_mcre0_app_gruppo_legame gl WHERE  m.cod_sndg = gl.cod_sndg(+)),'0'),
      flg_condiviso = '1',
      flg_singolo = '0'
      WHERE m.flg_active = '1';

     COMMIT;

     PKG_MCRE0_AUDIT.LOG_ETL(seq, c_package||'.set_cod_ge_gl', PKG_MCRE0_AUDIT.C_DEBUG,SQLCODE,SQLERRM,'FINE');

   EXCEPTION
     WHEN OTHERS THEN
      log_caricamenti (c_package || '.SET_COD_GE_GL - upd codici', SQLCODE, SQLERRM );
      PKG_MCRE0_AUDIT.LOG_ETL(seq, c_package||'.set_cod_ge_gl', PKG_MCRE0_AUDIT.C_ERROR,SQLCODE,SQLERRM,'ECCEZIONE');
   END;

   BEGIN
     --valorizzo il flag singolo
     UPDATE mcre_own.t_mcre0_app_file_guida24 c
      SET c.flg_singolo = 1,
        c.flg_condiviso = 0
     WHERE cod_sndg IN (SELECT  mm.cod_sndg
                 FROM mcre_own.t_mcre0_app_file_guida24 mm
                 WHERE mm.flg_active = '1'
               GROUP BY (mm.cod_sndg)
                HAVING COUNT (DISTINCT mm.cod_ndg) = 1)
     AND c.flg_active = '1';

   EXCEPTION
     WHEN OTHERS THEN
      log_caricamenti (c_package || '.SET_COD_GE_GL - fl_singolo',SQLCODE,SQLERRM);
   END;

   --determino i cartolarizzati che non andrebbero sommati nelle statistiche di gruppo
   UPDATE mcre_own.t_mcre0_app_file_guida24 f
     SET f.flg_somma = '0'
    WHERE f.cod_abi_istituto != f.cod_abi_cartolarizzato
     AND f.cod_ndg IN (SELECT  g.cod_ndg
                FROM mcre_own.t_mcre0_app_file_guida24 g
                WHERE g.flg_active = '1'
               HAVING COUNT (*) > 1
              GROUP BY g.cod_abi_istituto, g.cod_ndg)
     and f.flg_active = '1';

   COMMIT;
  EXCEPTION
   WHEN OTHERS THEN
    log_caricamenti (c_package || '.SET_COD_GE_GL ', SQLCODE, SQLERRM );
  END;

  PROCEDURE calc_cod_collegamento(activ_id number) IS

  BEGIN
--debug..
   log_caricamenti (c_package || '.CALC_COD_COLLEGAMENTO - step 1', -1,'');

  --determino l'id_dper attivo
--  select IDPER into activ_id
--  from MCRE_OWN.V_MCRE0_ULTIMA_ACQUISIZIONE v
--  where COD_FILE = 'FILE_GUIDA';

-- determino il codice collegamento
--step 1: assegno un cod supergrupppo pari al gruppo Eco (se c'è), Gruppo Legame o super (con relativo prefisso)
   BEGIN
    --     UPDATE mcre_own.t_mcre0_app_file_guida mm
  --      SET mm.cod_gruppo_super =
  --          (SELECT CASE
  --               WHEN cod_gruppo_economico IS NOT NULL
  --                 THEN  'GE'|| LPAD (cod_gruppo_economico, 18, '0')
  --               WHEN cod_gruppo_legame IS NOT NULL
  --               AND cod_gruppo_economico IS NULL
  --                 THEN 'GL'|| LPAD (cod_gruppo_legame, 18, '0')
  --               WHEN cod_sndg = '0000000000000000'
  --                 THEN 'X'||cod_abi_cartolarizzato||SUBSTR( cod_ndg,0,14)
  --               ELSE 'SP' || LPAD (cod_sndg, 18, '0')
  --              END "cod_sprgrp"
  --           FROM mcre_own.t_mcre0_app_file_guida gc
  --           WHERE mm.cod_abi_cartolarizzato = gc.cod_abi_cartolarizzato
  --            AND mm.cod_ndg = gc.cod_ndg
  --            AND mm.cod_abi_istituto = gc.cod_abi_istituto
  --            AND gc.flg_active = '1') --v3.0
  --           WHERE mm.flg_active = '1'; --v3.0
  --v 3.12 PG rimossa subquery (commentata sopra)
  UPDATE /*+index(mm IDX_MCRE0_APP_FILE_GUIDA_FA)*/ mcre_own.t_mcre0_app_file_guida24 mm
        SET mm.cod_gruppo_super =
            CASE
                 WHEN cod_gruppo_economico IS NOT NULL
                   THEN  'GE'|| LPAD (cod_gruppo_economico, 18, '0')
                 WHEN cod_gruppo_legame IS NOT NULL
                 AND cod_gruppo_economico IS NULL
                   THEN 'GL'|| LPAD (cod_gruppo_legame, 18, '0')
                 WHEN cod_sndg = '0000000000000000'
                   THEN 'X'||cod_abi_cartolarizzato||SUBSTR( cod_ndg,0,14)
                 ELSE 'SP' || LPAD (cod_sndg, 18, '0')
                END
             WHERE mm.flg_active = '1'
             -- SBellani
             and (mm.cod_gruppo_super !=
          CASE
             WHEN cod_gruppo_economico IS NOT NULL THEN 'GE' || LPAD (cod_gruppo_economico, 18, '0')
             WHEN cod_gruppo_legame IS NOT NULL AND cod_gruppo_economico IS NULL THEN    'GL'
                                                                                      || LPAD (cod_gruppo_legame,
                                                                                               18,
                                                                                               '0'
                                                                                              )
             WHEN cod_sndg = '0000000000000000' THEN 'X' || cod_abi_cartolarizzato || SUBSTR (cod_ndg, 0, 14)
             ELSE 'SP' || LPAD (cod_sndg, 18, '0')
          END
     or mm.cod_gruppo_super is null);


    commit;
   EXCEPTION
     WHEN OTHERS THEN
      log_caricamenti (c_package || '.CALC_COD_COLLEGAMENTO - step 1',SQLCODE,SQLERRM);
   END;

--debug..
   log_caricamenti (c_package || '.CALC_COD_COLLEGAMENTO - step 2', -1, '');

--step 2: assegno a tutti i super di un legame solo parzialmente in un gruppo il cod GE
   BEGIN
     UPDATE mcre_own.t_mcre0_app_file_guida24 c
      SET c.cod_gruppo_super =
          (SELECT   'GE'|| LPAD (MAX (cod_gruppo_economico), 18, '0') ge
            FROM mcre_own.t_mcre0_app_file_guida24 h
            WHERE h.cod_gruppo_legame IN (
                SELECT  cod_gruppo_legame
                  FROM mcre_own.t_mcre0_app_file_guida24 mm
                  WHERE cod_gruppo_legame IS NOT NULL
                GROUP BY cod_gruppo_legame
                 HAVING COUNT(DISTINCT NVL(cod_gruppo_economico,-1)) > 1
                   AND MIN (NVL(cod_gruppo_economico,-1)) = -1)
             AND h.cod_gruppo_legame = c.cod_gruppo_legame
             --AND h.id_dper = c.id_dper
             AND h.flg_active = '1'
          GROUP BY cod_gruppo_legame)
     WHERE c.cod_gruppo_legame IS NOT NULL
      AND c.cod_gruppo_economico IS NULL
      AND c.flg_active = '1'
      AND c.cod_gruppo_legame IN (
          SELECT  cod_gruppo_legame
            FROM mcre_own.t_mcre0_app_file_guida24 mm
           WHERE cod_gruppo_legame IS NOT NULL
            AND flg_active = '1'
          GROUP BY cod_gruppo_legame
           HAVING COUNT (DISTINCT NVL(cod_gruppo_economico,-1)) > 1
            AND MIN (NVL(cod_gruppo_economico,-1)) = -1);
            commit;
   EXCEPTION
     WHEN OTHERS THEN
      log_caricamenti (c_package || '.CALC_COD_COLLEGAMENTO - step 2',SQLCODE, SQLERRM );
   END;

--debug..
   log_caricamenti (c_package || '.CALC_COD_COLLEGAMENTO - end', -1, '');
   commit;
  EXCEPTION
   WHEN OTHERS THEN
    log_caricamenti (c_package || '.CALC_COD_COLLEGAMENTO', SQLCODE, SQLERRM );
  END;

  --v1.3 aggiorno Ramo e Comparto Calcolato e setto comparto a Tavoli
  PROCEDURE calc_comparto(activ_id number) IS
   cib   mcre_own.t_mcre0_app_mople24.cod_comparto_host%TYPE := '000001';
   bdt   mcre_own.t_mcre0_app_mople24.cod_comparto_host%TYPE := '000002';
   tavoli  mcre_own.t_mcre0_app_mople24.cod_comparto_host%TYPE := '011901';

  BEGIN

  --determino l'id_dper attivo
--  select IDPER into activ_id
--  from MCRE_OWN.V_MCRE0_ULTIMA_ACQUISIZIONE v
--  where COD_FILE = c_file_guida;

--partiziono per supergruppo, cerco il min comparto: se CIB o BdT li assegno a tutto il gruppo
--altrimenti lascio il valore host della singola riga.
--aggiorno comparto pre e data comparto calcolato
   BEGIN
   /* versione 3.4
  MERGE INTO mcre_own.t_mcre0_app_file_guida fg
        USING (SELECT f.cod_abi_cartolarizzato, f.cod_ndg, m.cod_comparto_host,
               CASE
                 WHEN MIN (m.cod_ramo_host) OVER (PARTITION BY cod_gruppo_super) IN (cib, bdt)
                  THEN MIN (m.cod_ramo_host) OVER (PARTITION BY cod_gruppo_super)
                 ELSE m.cod_ramo_host
               END rhost
             FROM mcre_own.t_mcre0_app_file_guida f,
               mcre_own.t_mcre0_app_mople m
            WHERE f.cod_abi_cartolarizzato = m.cod_abi_cartolarizzato(+)
               AND f.cod_ndg = m.cod_ndg(+)
               AND f.flg_active = '1' ) calc
        ON (  fg.cod_abi_cartolarizzato = calc.cod_abi_cartolarizzato
          AND fg.cod_ndg = calc.cod_ndg
          AND fg.flg_active = '1') --14.02
        WHEN MATCHED THEN
          UPDATE
           SET fg.cod_comparto_calcolato_pre = fg.cod_comparto_calcolato,
             fg.cod_comparto_calcolato = nvl2(calc.rhost,tavoli,calc.cod_comparto_host),
             fg.cod_ramo_calcolato = calc.rhost,
             fg.dta_comparto_calcolato = SYSDATE
          ;
   */

   --versione 4.0
--  MERGE INTO mcre_own.t_mcre0_app_file_guida fg
--        USING (SELECT f.cod_abi_cartolarizzato, f.cod_ndg,
--               CASE
--                 WHEN MIN (m.cod_ramo) OVER (PARTITION BY cod_gruppo_super) is not null
--                  THEN MIN (m.cod_ramo) OVER (PARTITION BY cod_gruppo_super)
--                 ELSE m.cod_ramo_host
--               END rhost,
--               CASE
--                 WHEN MIN (m.cod_ramo) OVER (PARTITION BY cod_gruppo_super) is not null
--                  THEN MIN (m.cod_comparto) OVER (PARTITION BY cod_gruppo_super)
--                 ELSE m.cod_comparto_host
--               END chost
--             FROM mcre_own.t_mcre0_app_file_guida f,
--              (select * from
--               mcre_own.t_mcre0_app_mople mo,
--               mcre_own.t_mcre0_cl_trascinamenti c
--               where MO.COD_RAMO_HOST = c.cod_ramo (+)) m
--            WHERE f.cod_abi_cartolarizzato = m.cod_abi_cartolarizzato(+)
--               AND f.cod_ndg = m.cod_ndg(+)
--               AND f.flg_active = '1' ) calc
--        ON (  fg.cod_abi_cartolarizzato = calc.cod_abi_cartolarizzato
--          AND fg.cod_ndg = calc.cod_ndg
--          AND fg.flg_active = '1') 14.02
--        WHEN MATCHED THEN
--          UPDATE
--           SET fg.cod_comparto_calcolato_pre = fg.cod_comparto_calcolato,
--             fg.cod_comparto_calcolato = calc.chost,
--             fg.cod_ramo_calcolato = calc.rhost,
--             fg.dta_comparto_calcolato = SYSDATE;

     --5.0
    MERGE INTO mcre_own.t_mcre0_app_file_guida24 fg
       USING (SELECT cod_abi_cartolarizzato, cod_ndg, rhost, chost,
                     CASE
                        WHEN rhost IS NULL
                        AND EXISTS (
                               SELECT DISTINCT cod_abi_istituto,
                                               cod_struttura_competente
                                          FROM t_mcre0_app_struttura_org
                                         WHERE cod_livello IN ('AR', 'RG')
                                           AND cod_abi_istituto =
                                                            cod_abi_cartolarizzato
                                           AND cod_struttura_competente = chost)
                           THEN chost || SUBSTR (cod_gruppo_super, 6, 20)
                        ELSE cod_gruppo_super
                     END cod_gruppo_super,
                     CASE
                        WHEN rhost IS NULL
                        AND EXISTS (
                               SELECT DISTINCT cod_abi_istituto,
                                               cod_struttura_competente
                                          FROM t_mcre0_app_struttura_org
                                         WHERE cod_livello IN ('AR', 'RG')
                                           AND cod_abi_istituto = '01025' --fisso 01025 x trovare
                                           AND cod_struttura_competente =  min_chost)
                           THEN cod_gruppo_super
                        ELSE NULL
                     END cod_gruppo_super_old
                FROM (SELECT f.cod_abi_cartolarizzato, f.cod_ndg,
                             cod_gruppo_super,
                             CASE
                                WHEN MIN (m.cod_ramo) OVER (PARTITION BY cod_gruppo_super) IS NOT NULL
                                   THEN MIN (m.cod_ramo) OVER (PARTITION BY cod_gruppo_super)
                                ELSE m.cod_ramo_host
                             END rhost,
                             CASE
                                WHEN MIN (m.cod_ramo) OVER (PARTITION BY cod_gruppo_super) IS NOT NULL
                                   THEN MIN (m.cod_comparto) OVER (PARTITION BY cod_gruppo_super)
                                ELSE m.cod_comparto_host
                             END chost,
                             MIN (nvl(m.cod_comparto_host, '999999')) 
                                OVER (PARTITION BY cod_gruppo_super) min_chost --alemno un'area/regione nel gruppo
                        FROM mcre_own.t_mcre0_app_file_guida24 f,
                             (SELECT *
                                FROM mcre_own.t_mcre0_app_mople24 mo,
                                     mcre_own.t_mcre0_cl_trascinamenti c
                               WHERE mo.cod_ramo_host = c.cod_ramo(+)) m
                       WHERE f.cod_abi_cartolarizzato = m.cod_abi_cartolarizzato(+)
                         AND f.cod_ndg = m.cod_ndg(+)
                         AND f.flg_active = '1')) calc
       ON (    fg.cod_abi_cartolarizzato = calc.cod_abi_cartolarizzato
           AND fg.cod_ndg = calc.cod_ndg
           AND fg.flg_active = '1')                                        --14.02
       WHEN MATCHED THEN
          UPDATE
             SET fg.cod_comparto_calcolato_pre = fg.cod_comparto_calcolato,
                 fg.cod_comparto_calcolato = calc.chost,
                 fg.cod_ramo_calcolato = calc.rhost,
                 fg.dta_comparto_calcolato = SYSDATE,
                 fg.cod_gruppo_super = calc.cod_gruppo_super,
                 fg.cod_gruppo_super_old = calc.cod_gruppo_super_old;

          commit;
  -- v 3.12 PG aggiunte hint
--  MERGE /*+index(fg IDX_MCRE0_APP_FILE_GUIDA_FA) parallel(fg,2,1)*/ INTO mcre_own.t_mcre0_app_file_guida fg
--      USING (SELECT /*+ordered no_parallel(f) no_parallel(m) index(f IDX_MCRE0_APP_FILE_GUIDA_FA) index(m PKT_MCRE0_APP_MOPLE*/ f.cod_abi_cartolarizzato, f.cod_ndg, m.cod_comparto_host,
--             CASE
--               WHEN MIN (m.cod_ramo_host) OVER (PARTITION BY cod_gruppo_super) IN  (cib, bdt)
--                THEN MIN (m.cod_ramo_host) OVER (PARTITION BY cod_gruppo_super)
--               ELSE m.cod_ramo_host
--             END rhost
--           FROM mcre_own.t_mcre0_app_file_guida f,
--             mcre_own.t_mcre0_app_mople m
--          WHERE f.cod_abi_cartolarizzato = m.cod_abi_cartolarizzato(+)
--             AND f.cod_ndg = m.cod_ndg(+)
--             AND f.flg_active = '1'
--             and cod_ramo_host is not null ) calc
--      ON (  fg.cod_abi_cartolarizzato = calc.cod_abi_cartolarizzato(+)
--        AND fg.cod_ndg = calc.cod_ndg(+)
--        AND fg.flg_active = '1') --14.02
--      WHEN MATCHED THEN
--        UPDATE
--         SET fg.cod_comparto_calcolato_pre = fg.cod_comparto_calcolato,
--           fg.cod_comparto_calcolato = nvl2(calc.rhost,tavoli,calc.cod_comparto_host),
--           fg.cod_ramo_calcolato = calc.rhost,
--           fg.dta_comparto_calcolato = SYSDATE;

   log_caricamenti (c_package || '.calc_comparto - end', -1, '');

   EXCEPTION
     WHEN OTHERS THEN
      log_caricamenti (c_package || '.CALC_COMPARTO', SQLCODE, SQLERRM);
      rollback;
   END;

  EXCEPTION
   WHEN OTHERS THEN
    log_caricamenti (c_package || '.CALC_COMPARTO', SQLCODE, SQLERRM);
  END;


  --v2.2 se non più sui tavoli aggiorno SEMPRE!
  PROCEDURE check_riportafogliazione(activ_id number) IS
  --aggiorna flag e data riportafogliazione ed eventualmente id gestore e data assegnazione in caso di
  --riportafogliazione (verifica di comparto calcolato-calcolato_pre e calcolato-assegnato
  v_num number;
  BEGIN

  UPDATE MCRE_OWN.T_MCRE0_APP_FILE_GUIDA24 F
  SET F.FLG_RIPORTAFOGLIATO  = 1,
    F.DTA_LAST_RIPORTAF   = sysdate,
    F.ID_UTENTE_PRE     = F.ID_UTENTE,
    F.ID_UTENTE       = null,
    F.DTA_UTENTE_ASSEGNATO  = null,
    F.COD_COMPARTO_ASSEGNATO = null,--lasio null?!
    F.COD_SERVIZIO      = null,--lasio null?!
    F.DTA_SERVIZIO      = null
   WHERE
     NVL(F.COD_COMPARTO_CALCOLATO,-1) != c_tavoli
   and F.COD_COMPARTO_CALCOLATO_PRE = c_tavoli
   AND F.flg_active = '1';

  v_num := sql%rowcount;
  commit;

  log_caricamenti (c_package || '.check_riportafogliazione', -1, 'posizioni riportafogliate: '||v_num);

  END;

  --vecchia versione, utile per gestire comparto calcolato dinamico...
--  PROCEDURE check_riportafogliazione IS
--  --aggiorna flag e data riportafogliazione ed eventualmente id gestore e data assegnazione in caso di
--  --riportafogliazione (verifica di comparto calcolato-calcolato_pre e calcolato-assegnato
--  BEGIN
--
--  UPDATE MCRE_OWN.T_MCRE0_APP_FILE_GUIDA F
--  SET (F.FLG_RIPORTAFOGLIATO, F.DTA_LAST_RIPORTAF, F.ID_UTENTE,
--    F.ID_UTENTE_PRE, F.DTA_UTENTE_ASSEGNATO, F.COD_COMPARTO_ASSEGNATO) =
--     (SELECT CASE             --flg_riportafogliato
--           WHEN G.COD_COMPARTO_CALCOLATO = nvl(G.COD_COMPARTO_ASSEGNATO,-1) --non vario nulla, altrimenti setto
--            THEN 0
--           ELSE 1
--         END FL,
--         CASE             --dta_last_riportaf
--           WHEN G.COD_COMPARTO_CALCOLATO = nvl(G.COD_COMPARTO_ASSEGNATO,-1) --non vario nulla, altrimenti setto
--            THEN G.DTA_LAST_RIPORTAF
--           ELSE SYSDATE
--         END DT,
--         CASE             --id_utente
--           WHEN G.COD_COMPARTO_CALCOLATO = nvl(G.COD_COMPARTO_ASSEGNATO,-1) --non vario nulla, altrimenti sbianco
--            THEN G.ID_UTENTE
--           ELSE NULL
--         END UT,
--         CASE             --id_utente_pre
--           WHEN G.COD_COMPARTO_CALCOLATO = nvl(G.COD_COMPARTO_ASSEGNATO,-1) --non vario nulla, altrimenti storicizzo
--            THEN G.ID_UTENTE_PRE
--           ELSE G.ID_UTENTE
--         END PRE,
--         CASE             --dta_utente_asssegnato
--           WHEN G.COD_COMPARTO_CALCOLATO = nvl(G.COD_COMPARTO_ASSEGNATO,-1) --non vario nulla, altrimenti sbianco
--            THEN G.DTA_UTENTE_ASSEGNATO
--           ELSE NULL
--         END DT_ASS,
--         CASE             --cod_comparto_assegnato
--           WHEN G.COD_COMPARTO_CALCOLATO = nvl(G.COD_COMPARTO_ASSEGNATO,-1) --non vario nulla, altrimenti sbianco
--            THEN G.COD_COMPARTO_ASSEGNATO
--           ELSE NULL
--         END COMP
--       FROM MCRE_OWN.T_MCRE0_APP_FILE_GUIDA G
--      WHERE G.COD_ABI_CARTOLARIZZATO = F.COD_ABI_CARTOLARIZZATO
--       AND G.COD_NDG = F.COD_NDG
--      )
----v2.0 escludo questo primo controllo, lascio solo il check sui tavoli
----  WHERE F.COD_COMPARTO_CALCOLATO != F.COD_COMPARTO_CALCOLATO_PRE
----   AND F.COD_COMPARTO_CALCOLATO IS NOT NULL
--   --v1.9 controllo solo le uscite dai tavoli (upd v2.0)
--   WHERE
--   nvl(F.COD_COMPARTO_CALCOLATO,-1) != c_tavoli
--   and F.COD_COMPARTO_CALCOLATO_PRE = c_tavoli
--   --
--   AND F.ID_DPER = (select idper from MCRE_OWN.V_MCRE0_ULTIMA_ACQUISIZIONE
--                where cod_file = c_file_guida) ;
--  commit;
--
--  END;

  PROCEDURE storicizza_riportafogliati(activ_id number) is

  begin

  insert into MCRE_OWN.T_MCRE0_TMP_LISTA_STORICO
  (COD_ABI_CARTOLARIZZATO, COD_NDG, COD_SNDG, FLG_STATO, FLG_COMPARTO, FLG_GESTORE, FLG_MESE)
    (select COD_ABI_CARTOLARIZZATO, COD_NDG, COD_SNDG, 0 fl_stato,1 fl_comparto,
    case
      when id_utente IS NULL and id_utente_pre IS NOT NULL then 1
      else 0
    end fl_gestore,0 fl_mese
    from MCRE_OWN.T_MCRE0_APP_FILE_GUIDA24
    where FLG_RIPORTAFOGLIATO = '1'
    and flg_active = '1' );
    --v2.0 vnon faccio altri controlli (basta il flag!)
--    and (COD_COMPARTO_CALCOLATO in (select COD_COMPARTO from MCRE_OWN.T_MCRE0_APP_COMPARTI
--                    where FLG_CHK = '1')
--     or COD_COMPARTO_CALCOLATO_PRE in (select COD_COMPARTO from MCRE_OWN.T_MCRE0_APP_COMPARTI
--                      where FLG_CHK = '1')));
  commit;

  end;

  --v2.1: upd solo su chi ha due diversi comparti assegnati su gruppo super OGGI
  --v2.2: aggiunto update Servizio per nuovi ingressi
  --TODO: rivedere la select
  PROCEDURE aggiorna_nuovi_collegati( p_data DATE, activ_id number) is

  row_upd number := 0;
  n    number := 0;
  giorno date  := sysdate;

--  --v2.1 aggiunto controllo su idper
--  cursor upd is
--   SELECT COD_GRUPPO_SUPER, MAX(ID_UTENTE) ID_UTENTE,MAX(ID_UTENTE_PRE) ID_UTENTE_PRE,
--      MAX(DTA_UTENTE_ASSEGNATO) DTA_UTENTE_ASSEGNATO, MAX(COD_COMPARTO_ASSEGNATO) COD_COMPARTO_ASSEGNATO
--   FROM MCRE_OWN.T_MCRE0_APP_FILE_GUIDA T
--   WHERE T.COD_GRUPPO_SUPER is not null
--   AND T.flg_active = '1'
--   GROUP BY COD_GRUPPO_SUPER
--   having count(distinct COD_COMPARTO_ASSEGNATO)>1;

  --v3.11 cambiata la logica di selezione...
  -- la query va rilanciata con 'where pos >1' per vedere i casi anomali da gestire a mano..
--  cursor upd is
--  select * from (
--  select distinct COD_GRUPPO_SUPER, ID_UTENTE, ID_UTENTE_PRE, max_dta_utente, DTA_UTENTE_ASSEGNATO, COD_COMPARTO_ASSEGNATO,
--  count(distinct COD_GRUPPO_SUPER||ID_UTENTE||ID_UTENTE_PRE|| max_dta_utente||DTA_UTENTE_ASSEGNATO||COD_COMPARTO_ASSEGNATO) over (partition by cod_gruppo_super) pos
--   from (
--   SELECT COD_GRUPPO_SUPER, ID_UTENTE, nullif(ID_UTENTE_PRE, ID_UTENTE) ID_UTENTE_PRE,
--   MAX(DTA_UTENTE_ASSEGNATO) over (partition by COD_GRUPPO_SUPER) max_dta_utente,
--    DTA_UTENTE_ASSEGNATO, COD_COMPARTO_ASSEGNATO,
--    count(distinct nvl(COD_COMPARTO_ASSEGNATO,'-')) over (partition by COD_GRUPPO_SUPER) num_comp
--   FROM MCRE_OWN.T_MCRE0_APP_FILE_GUIDA T
--   WHERE T.COD_GRUPPO_SUPER is not null
--   AND T.flg_active = '1'
--      )
--   where (max_dta_utente = DTA_UTENTE_ASSEGNATO or (max_dta_utente is null and DTA_UTENTE_ASSEGNATO is null))
--   and num_comp >1
--   ) where pos =1;




  begin
    if p_data is null then
    giorno := sysdate;
    else
    giorno := p_data;
    end if;

    --    for rec_upd in upd loop
    --
    --    update MCRE_OWN.T_MCRE0_APP_FILE_GUIDA G
    --    SET ID_UTENTE = rec_upd.ID_UTENTE,
    --      ID_UTENTE_PRE = rec_upd.ID_UTENTE_PRE,
    --      DTA_UTENTE_ASSEGNATO = rec_upd.DTA_UTENTE_ASSEGNATO,
    --      COD_COMPARTO_ASSEGNATO = rec_upd.COD_COMPARTO_ASSEGNATO
    --    where G.COD_GRUPPO_SUPER = rec_upd.COD_GRUPPO_SUPER
    --    and DTA_UPD >= TRUNC(giorno); --15.02 DTA_INS--> DTA_UPD
    --
    --    n := sql%rowcount;
    --    row_upd := row_upd+n;
    --    commit;
    --
    --    end loop;
    -- v 3.12 PG rimosso cursore

    ---VG
--    MERGE /*+no_parallel(fg)*/ INTO mcre_own.t_mcre0_app_file_guida fg
--      USING (select * from (  select distinct COD_GRUPPO_SUPER, ID_UTENTE, ID_UTENTE_PRE, max_dta_utente, DTA_UTENTE_ASSEGNATO, COD_COMPARTO_ASSEGNATO,
--                        count(distinct COD_GRUPPO_SUPER||ID_UTENTE||ID_UTENTE_PRE|| max_dta_utente||DTA_UTENTE_ASSEGNATO||COD_COMPARTO_ASSEGNATO) over (partition by cod_gruppo_super) pos
--                         from (
--                               SELECT /*+index(t IDX_MCRE0_APP_FILE_GUIDA_FA)*/ COD_GRUPPO_SUPER, ID_UTENTE, nullif(ID_UTENTE_PRE, ID_UTENTE) ID_UTENTE_PRE,
--                               MAX(DTA_UTENTE_ASSEGNATO) over (partition by COD_GRUPPO_SUPER) max_dta_utente,
--                                DTA_UTENTE_ASSEGNATO, COD_COMPARTO_ASSEGNATO,
--                                count(distinct nvl(COD_COMPARTO_ASSEGNATO,'-')) over (partition by COD_GRUPPO_SUPER) num_comp
--                               FROM MCRE_OWN.T_MCRE0_APP_FILE_GUIDA T
--                               WHERE T.COD_GRUPPO_SUPER is not null
--                               AND T.flg_active = '1'
--                              )
--                         where (max_dta_utente = DTA_UTENTE_ASSEGNATO or (max_dta_utente is null and DTA_UTENTE_ASSEGNATO is null))
--                         and num_comp >1
--                         ) a
--             where pos =1 ) calc
--      ON (  fg.COD_GRUPPO_SUPER = calc.COD_GRUPPO_SUPER
--            and fg.DTA_UPD >= TRUNC(giorno)) --14.02
--      WHEN MATCHED THEN
--        UPDATE
--         SET fg.ID_UTENTE = calc.ID_UTENTE,
--             fg.ID_UTENTE_PRE = calc.ID_UTENTE_PRE,
--             fg.DTA_UTENTE_ASSEGNATO = calc.DTA_UTENTE_ASSEGNATO,
--             fg.COD_COMPARTO_ASSEGNATO = calc.COD_COMPARTO_ASSEGNATO;

        -------------------   VG - CIB/BDT - INIZIO --------------------
        MERGE /*+no_parallel(fg)*/ INTO mcre_own.t_mcre0_app_file_guida24 fg
        USING (
            select * from (
                select distinct COD_GRUPPO_SUPER,
                                ID_UTENTE,
                                DTA_UTENTE_ASSEGNATO,
                                COD_COMPARTO_ASSEGNATO,
                                --COD_SERVIZIO,
                                --cod_ramo,
                                min_DTA_UTENTE_ASSEGNATO,
                                min_COD_COMPARTO_ASSEGNATO,
                                min_cod_servizio,
                                min_cod_ramo,
                                min_ID_UTENTE_1,
                                num_UTENTI_1,
                                num_comp_ASSEGNATI_1,
                                num_SERVIZI_1,
                                num_RAMI_1,
                                min_ID_UTENTE_CON_DATA,
                                min_ID_UTENTE_CON_COMPARTO,
                                case
                                  when  num_UTENTI_1 > 1 and min_dta_utente_assegnato is not null and  num_comp_ASSEGNATI_1=1  then
                                                case
                                                    when dta_utente_assegnato = min_dta_utente_assegnato  and id_utente=min_ID_UTENTE_CON_DATA then 1
                                                    else 0
                                                 end
                                  when num_UTENTI_1 > 1 and min_dta_utente_assegnato is null and num_comp_ASSEGNATI_1=1  then
                                                case
                                                    when id_utente=min_ID_UTENTE_CON_COMPARTO and COD_COMPARTO_ASSEGNATO =  min_COD_COMPARTO_ASSEGNATO then 1
                                                    else 0
                                                 end
                                  when num_UTENTI_1 > 1 and min_dta_utente_assegnato is not null  and num_comp_ASSEGNATI_1>1  then
                                                case --v4.5.. solo qui?!
                                                    --when id_utente=min_ID_UTENTE_CON_COMPARTO  and dta_utente_assegnato = min_dta_utente_assegnato then decode(cod_comparto_assegnato,(select U.COD_COMPARTO_UTENTE from t_mcre0_app_utenti u where u.id_utente = min_ID_UTENTE_CON_COMPARTO) ,1,0)             ---comparto dell'utente
                                                    when id_utente is not null  and dta_utente_assegnato = min_dta_utente_assegnato then decode(cod_comparto_assegnato,(select U.COD_COMPARTO_UTENTE from t_mcre0_app_utenti u where u.id_utente = min_ID_UTENTE_CON_COMPARTO) ,1,0)             ---comparto dell'utente
                                                    else 0
                                                 end
                                  when num_UTENTI_1 > 1 and min_dta_utente_assegnato is null and num_comp_ASSEGNATI_1>1  then
                                                case
                                                    when id_utente=min_ID_UTENTE_CON_COMPARTO  then decode(cod_comparto_assegnato,(select U.COD_COMPARTO_UTENTE from t_mcre0_app_utenti u where u.id_utente = min_ID_UTENTE_CON_COMPARTO) ,1,0)             ---comparto dell'utente
                                                    else 0
                                                 end
                                  when num_UTENTI_1 = 1 and min_ID_UTENTE_1!=-1 and num_comp_ASSEGNATI_1>1 then decode(cod_comparto_assegnato,(select U.COD_COMPARTO_UTENTE from t_mcre0_app_utenti u where u.id_utente = min_ID_UTENTE) ,1,0)             ---comparto dell'utente
                                  when num_UTENTI_1 = 1 and min_ID_UTENTE_1=-1 and num_comp_ASSEGNATI_1>1 then decode(cod_ramo,min_COD_ramo_CON_COMPARTO,decode(cod_comparto_assegnato,null,0,1),0)
                                  else 0
                                end flg_riga_giusta
                    from (
                        SELECT /*+index(t IDX_MCRE0_APP_FILE_GUIDA_FA)*/
                                    COD_GRUPPO_SUPER,
                                    ID_UTENTE,
                                    DTA_UTENTE_ASSEGNATO,
                                    COD_COMPARTO_ASSEGNATO,
                                    COD_SERVIZIO,
                                    cod_ramo_calcolato cod_ramo,
                                    min(DTA_UTENTE_ASSEGNATO) over (partition by COD_GRUPPO_SUPER) min_DTA_UTENTE_ASSEGNATO,
                                    min(nvl(COD_COMPARTO_ASSEGNATO,-1)) over (partition by COD_GRUPPO_SUPER) min_COD_COMPARTO_ASSEGNATO_1,
                                    min(nvl(cod_servizio,-1)) over (partition by COD_GRUPPO_SUPER) min_cod_servizio_1,
                                    min(nvl(cod_ramo_calcolato,-1)) over (partition by COD_GRUPPO_SUPER) min_cod_ramo_1,
                                    min(nvl(ID_UTENTE,-1)) over (partition by COD_GRUPPO_SUPER) min_ID_UTENTE_1,
                                    min(COD_COMPARTO_ASSEGNATO) over (partition by COD_GRUPPO_SUPER) min_COD_COMPARTO_ASSEGNATO,
                                    min(cod_servizio) over (partition by COD_GRUPPO_SUPER) min_cod_servizio,
                                    min(cod_ramo_calcolato) over (partition by COD_GRUPPO_SUPER) min_cod_ramo,
                                    min(ID_UTENTE) over (partition by COD_GRUPPO_SUPER) min_ID_UTENTE,
                                    min(decode(DTA_UTENTE_ASSEGNATO,null,null,ID_UTENTE)) over (partition by COD_GRUPPO_SUPER) min_ID_UTENTE_CON_DATA,
                                    min(decode(COD_COMPARTO_ASSEGNATO,null,null,ID_UTENTE)) over (partition by COD_GRUPPO_SUPER) min_ID_UTENTE_CON_COMPARTO,
                                    min(decode(COD_COMPARTO_ASSEGNATO,null,null,DTA_UTENTE_ASSEGNATO)) over (partition by COD_GRUPPO_SUPER) min_DTA_UTENTE_CON_COMPARTO,
                                    min(decode(COD_COMPARTO_ASSEGNATO,null,null,COD_ramo_calcolato)) over (partition by COD_GRUPPO_SUPER) min_COD_ramo_CON_COMPARTO,
                                    COUNT( DISTINCT  nvl(COD_COMPARTO_ASSEGNATO,-1)   ) over (partition by COD_GRUPPO_SUPER) num_comp_ASSEGNATI_1,
                                    COUNT(DISTINCT nvl(cod_servizio,-1)  ) over (partition by COD_GRUPPO_SUPER) num_SERVIZI_1                 ,
                                    COUNT( DISTINCT nvl(cod_ramo_calcolato,-1)  ) over (partition by COD_GRUPPO_SUPER) num_RAMI_1,
                                    COUNT( DISTINCT nvl(ID_UTENTE,-1)  ) over (partition by COD_GRUPPO_SUPER) num_UTENTI_1 ,
                                    COUNT( DISTINCT  COD_COMPARTO_ASSEGNATO   ) over (partition by COD_GRUPPO_SUPER) num_comp_ASSEGNATI,
                                    COUNT(DISTINCT cod_servizio  ) over (partition by COD_GRUPPO_SUPER) num_SERVIZI                ,
                                    COUNT( DISTINCT cod_ramo_calcolato  ) over (partition by COD_GRUPPO_SUPER) num_RAMI,
                                    COUNT( DISTINCT ID_UTENTE ) over (partition by COD_GRUPPO_SUPER) num_UTENTI  ,
                                    COUNT( DISTINCT DTA_UTENTE_ASSEGNATO ) over (partition by COD_GRUPPO_SUPER) num_DTA_UTENTE_ASSEGNATO
                        FROM MCRE_OWN.T_MCRE0_APP_FILE_GUIDA24 T
                        WHERE T.COD_GRUPPO_SUPER is not null
                        AND T.flg_active = '1'
                    )
                    where num_UTENTI_1>1 or num_comp_ASSEGNATI_1>1
                )
                where  flg_riga_giusta = 1     ) calc
             ON (  fg.COD_GRUPPO_SUPER = calc.COD_GRUPPO_SUPER
            and fg.flg_active = '1' ) --14.02
          WHEN MATCHED THEN
            UPDATE
             SET fg.ID_UTENTE = calc.ID_UTENTE,
                 fg.DTA_UTENTE_ASSEGNATO = calc.DTA_UTENTE_ASSEGNATO,
                 fg.COD_COMPARTO_ASSEGNATO = calc.COD_COMPARTO_ASSEGNATO;
        --------------------   VG - CIB/BDT - FINE --------------------

  n := sql%rowcount;
  row_upd := row_upd+n;
  commit;

  --v2.2 ricalcolo il servizio per i nuovi ingressi/reingressi
--  UPDATE T_MCRE0_APP_FILE_GUIDA F
--  SET cod_servizio = (select cod_servizio from t_mcre0_app_comparti
--            where cod_comparto = nvl(F.COD_COMPARTO_ASSEGNATO, F.COD_COMPARTO_CALCOLATO)),
--    dta_servizio = dta_ins
--  WHERE F.COD_COMPARTO_CALCOLATO = '011901'
--  AND  F.DTA_SERVIZIO is null
----  AND  DTA_UPD >= TRUNC(sysdate);
  UPDATE T_MCRE0_APP_FILE_GUIDA24 F
  SET cod_servizio = (select cod_servizio from t_mcre0_app_comparti
            where cod_comparto = nvl(F.COD_COMPARTO_ASSEGNATO, F.COD_COMPARTO_CALCOLATO)),
    dta_servizio = sysdate
  WHERE F.COD_COMPARTO_CALCOLATO = '011901'
  and  nvl(cod_servizio,'-99999') != (select cod_servizio from t_mcre0_app_comparti
            where cod_comparto = nvl(F.COD_COMPARTO_ASSEGNATO, F.COD_COMPARTO_CALCOLATO))
  AND  flg_active = '1';
  n := sql%rowcount;

  commit;
  log_caricamenti (c_package || '.aggiorna_nuovi_collegati',-1,'aggiornati '||row_upd||' records, '||n||' x inizializzazione servizio' );

  exception when others then
  log_caricamenti (c_package || '.aggiorna_nuovi_collegati',SQLCODE,SQLERRM );
  end;

  --v2.3: ripulisce comparto e gestore se le uniche posizioni in mople non sono in stati gestiti
  PROCEDURE disassegna_stati_non_gestiti(activ_id number) is

  row_upd number := 0;

  begin

  update t_mcre0_app_file_guida24 f
    SET ID_UTENTE_PRE = NVL (ID_UTENTE, ID_UTENTE_PRE),
      ID_UTENTE = null,
      COD_COMPARTO_ASSEGNATO = null,
      DTA_UTENTE_ASSEGNATO = null,
      --------------------   VG - CIB/BDT - INIZIO --------------------
      cod_servizio = null,
      dta_servizio = null
      --------------------   VG - CIB/BDT - FINE --------------------
   where COD_GRUPPO_SUPER in
     (--v3.2 MM: aggiunto check su flag outsourcing
      select F.COD_GRUPPO_SUPER
       from t_mcre0_app_mople24 m,t_mcre0_app_file_guida24 f,
         t_mcre0_app_stati s--, t_mcre0_app_istituti i
      where M.COD_ABI_CARTOLARIZZATO = F.COD_ABI_CARTOLARIZZATO
       and M.COD_NDG = F.COD_NDG
       and M.TODAY_FLG = '1'
       and M.COD_STATO = S.COD_MICROSTATO
       and F.COD_COMPARTO_ASSEGNATO is not null
       --v3.4
       --and f.cod_abi_cartolarizzato = i.cod_abi
       --and m.flg_outsourcing = 'Y'--5.1 sostituito i.flg_outsourcing
       group by F.COD_GRUPPO_SUPER
       --v5.2 gestisco i Non Outsourcing come stati non gestiti!
       having max(decode(m.flg_outsourcing, 'Y', S.FLG_STATO_CHK,null)) is null
      minus --mm20121112 escludo le posizioni in GB
       select COD_GRUPPO_SUPER
       from t_mcre0_app_file_guida24 f, t_mcre0_app_gb_gestione g
       where  f.cod_abi_cartolarizzato = g.cod_abi_cartolarizzato 
       and f.cod_ndg = g.cod_ndg
       and g.flg_stato = 1
     );
  row_upd := sql%rowcount;

  commit;
  log_caricamenti (c_package || '.disassegna_stati_non_gestiti',-1,'aggiornati '||row_upd||' records' );

  exception when others then
  log_caricamenti (c_package || '.disassegna_stati_non_gestiti',SQLCODE,SQLERRM );
  end;

  --v2.5: Forza il comparto Assegnato ai collegati a Bonis non gestiti..
  Function assegna_comparto_GB_AV(seq number) return number is

  row_upd number := 0;
  row_ins number := 0;

  begin

  MERGE INTO T_MCRE0_APP_FILE_GUIDA24 FG
  USING (
    select distinct COD_GRUPPO_SUPER, COD_COMPARTO_PROPOSTO from(
    SELECT F.COD_GRUPPO_SUPER, G.COD_COMPARTO_PROPOSTO, DTA_STATO ,
        min(dta_stato) over(partition by cod_gruppo_super) min_dtata_stato
    FROM T_MCRE0_APP_FILE_GUIDA24 F,
    (select COD_ABI_CARTOLARIZZATO,COD_NDG, COD_COMPARTO_PROPOSTO, DTA_STATO from T_MCRE0_APP_GB_GESTIONE
     where FLG_STATO = 1
     union
     select COD_ABI_CARTOLARIZZATO,COD_NDG, COD_COMPARTO_AV, DTA_STATO from T_MCRE0_APP_AV_GESTIONE
     where FLG_STATO = 1) G
    WHERE F.COD_ABI_CARTOLARIZZATO = G.COD_ABI_CARTOLARIZZATO
    AND F.COD_NDG = G.COD_NDG
    AND F.COD_COMPARTO_ASSEGNATO IS NULL)
    where DTA_STATO = min_dtata_stato
    and COD_COMPARTO_PROPOSTO is not null) A
  ON (FG.COD_GRUPPO_SUPER = A.COD_GRUPPO_SUPER)
  WHEN MATCHED THEN
    UPDATE
    SET COD_COMPARTO_ASSEGNATO = A.COD_COMPARTO_PROPOSTO;

  row_upd := sql%rowcount;
  commit;
  --storicizzo l'avvenuto cambio comparto automatico
  insert into MCRE_OWN.T_MCRE0_TMP_LISTA_STORICO
     (COD_ABI_CARTOLARIZZATO, COD_NDG, COD_SNDG, FLG_STATO, FLG_COMPARTO, FLG_GESTORE, FLG_MESE)
    (SELECT f.COD_ABI_CARTOLARIZZATO, f.COD_NDG, f.COD_SNDG, 0 fl_stato,1 fl_comparto,0 flg_gestore,0 fl_mese
    FROM T_MCRE0_APP_FILE_GUIDA24 F,
    (select COD_ABI_CARTOLARIZZATO,COD_NDG, COD_COMPARTO_PROPOSTO, DTA_STATO from T_MCRE0_APP_GB_GESTIONE
     where FLG_STATO = '1'
     union
     select COD_ABI_CARTOLARIZZATO,COD_NDG, COD_COMPARTO_AV, DTA_STATO from T_MCRE0_APP_AV_GESTIONE
     where FLG_STATO = '1') G
    WHERE F.COD_ABI_CARTOLARIZZATO = G.COD_ABI_CARTOLARIZZATO
    AND F.COD_NDG = G.COD_NDG
    AND F.COD_COMPARTO_ASSEGNATO IS NULL
    AND G.COD_COMPARTO_PROPOSTO IS NOT NULL);
  row_ins := sql%rowcount;

  commit;
  PKG_MCRE0_AUDIT.log_etl (seq,c_package || '.assegna_comparto_GB_AV', 3, sqlcode, 'aggiornati '||row_upd||' records ('||row_ins||' in TMP_STORICO)', '');
  --log_caricamenti (c_package || '.assegna_comparto_GB',-1,'aggiornati '||row_upd||' records' );
  return 1;

  exception when others then
  PKG_MCRE0_AUDIT.log_etl (seq,c_package || '.assegna_comparto_GB_AV', 1, SQLCODE,SQLERRM, 'rollback');
  --log_caricamenti (c_package || '.assegna_comparto_GB',SQLCODE,SQLERRM );
  rollback;
  return 0;
  end;

  --ripulisce gestore e COMPARTO da ogni gruppo senza più posizioni in mople
  --v2.1 sbianco per singola riga e non più solo per intero gruppo super
  FUNCTION update_uscita_CCP RETURN NUMBER IS

    v_id_dper number;
    c_nome CONSTANT VARCHAR2(50) := c_package || '.update_uscita_CCP';
    RetVal number := -1;
    num number := 0;

   BEGIN

--    select IDPER into v_id_dper
--    from MCRE_OWN.V_MCRE0_ULTIMA_ACQUISIZIONE v
--    where COD_FILE = 'FILE_GUIDA';

    --ripulisco le posizioni non più aggiornate
    update T_MCRE0_APP_FILE_GUIDA24
    set
    ID_UTENTE_PRE = NVL(ID_UTENTE,ID_UTENTE_PRE),
    ID_UTENTE = null,
    COD_COMPARTO_ASSEGNATO = null,
    DTA_UTENTE_ASSEGNATO = null, --v2.1
      --------------------   VG - CIB/BDT - INIZIO --------------------
      cod_servizio = null,
      dta_servizio = null
      --------------------   VG - CIB/BDT - FINE --------------------
    WHERE flg_active = '0'
    AND not (id_utente IS NULL and cod_comparto_assegnato is null); --aggiorno solo se assegnati!
    num := sql%rowcount;
    commit;
    log_caricamenti(c_nome,RetVal,'aggiornate '||num||' righe con id_dper non aggiornato');
    RetVal:= 1;

    --ripulisco gli usciti di oggi, se erano le uniche posizioni in

    --log_caricamenti(c_nome,RetVal,'aggiornate '||num||' righe');

  RETURN RetVal;

  EXCEPTION WHEN OTHERS THEN
   log_caricamenti(c_nome,sqlcode,SQLERRM);
   RETURN -1;

  END update_uscita_CCP;

END PKG_MCRE0_ESTENDI_FILE_GUIDA2;
/


CREATE SYNONYM MCRE_APP.PKG_MCRE0_ESTENDI_FILE_GUIDA2 FOR MCRE_OWN.PKG_MCRE0_ESTENDI_FILE_GUIDA2;


CREATE SYNONYM MCRE_USR.PKG_MCRE0_ESTENDI_FILE_GUIDA2 FOR MCRE_OWN.PKG_MCRE0_ESTENDI_FILE_GUIDA2;


GRANT EXECUTE, DEBUG ON MCRE_OWN.PKG_MCRE0_ESTENDI_FILE_GUIDA2 TO MCRE_USR;

