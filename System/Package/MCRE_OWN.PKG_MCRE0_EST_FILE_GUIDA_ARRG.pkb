CREATE OR REPLACE PACKAGE BODY MCRE_OWN.PKG_MCRE0_EST_FILE_GUIDA_ARRG AS
/******************************************************************************
   NAME:       PKG_MCRE0_EST_FILE_GUIDA_ARRG
   PURPOSE: Copia di PKG_MCRE0_ESTENDI_FILE_GUIDA2 per test caricamento file guida e all_data per aree e regioni 
******************************************************************************/

  FUNCTION update_file_guida_pre(p_storico number default 0) return number IS

    activ_id number;
    seq number;

  BEGIN

    select SEQ_MCR0_LOG_ETL.nextval
    into seq from dual;
    PKG_MCRE0_AUDIT.LOG_ETL(seq, c_package||'.UPDATE_FILE_GUIDA_pre - start - storico:'||p_storico, PKG_MCRE0_AUDIT.C_DEBUG,SQLCODE,SQLERRM,'INIZIO');

      --determino l'id_dper attivo
      select IDPER into activ_id
      from MCRE_OWN.V_MCRE0_ULTIMA_ACQUISIZIONE v
      where COD_FILE = c_file_guida;


      PKG_MCRE0_AUDIT.LOG_ETL(seq, c_package||'.UPDATE_FILE_GUIDA_pre - aggiornamento today_flg',PKG_MCRE0_AUDIT.C_DEBUG,SQLCODE,SQLERRM,'INIZIO');
      -- 4.2 Update solo su today_flg. Tutte le altre modifiche sono state fatte precedentemente (fra restore e merge sulla APP).
      UPDATE T_MCRE0_APP_FILE_GUIDA_ARRG
       SET TODAY_FLG =
              CASE WHEN (COD_ABI_CARTOLARIZZATO, COD_NDG) IN
                         (SELECT COD_ABI_CARTOLARIZZATO, COD_NDG FROM T_MCRE0_APP_MOPLE PARTITION (CCP_P1))
                 THEN '1' ELSE '0' END
       where TODAY_FLG !=
              CASE WHEN (COD_ABI_CARTOLARIZZATO, COD_NDG) IN
                         (SELECT COD_ABI_CARTOLARIZZATO, COD_NDG FROM T_MCRE0_APP_MOPLE PARTITION (CCP_P1))
                 THEN '1' ELSE '0'
              END;

      commit;

      PKG_MCRE0_AUDIT.LOG_ETL(seq, c_package||'.UPDATE_FILE_GUIDA_pre - aggiornamento today_flg',PKG_MCRE0_AUDIT.C_DEBUG,SQLCODE,SQLERRM,'FINE');
      PKG_MCRE0_AUDIT.LOG_ETL(seq, c_package||'.UPDATE_FILE_GUIDA_pre - aggiornamento flg_stato',PKG_MCRE0_AUDIT.C_DEBUG,SQLCODE,SQLERRM,'INIZIO');
      PKG_MCRE0_AUDIT.LOG_ETL(seq, c_package||'.UPDATE_FILE_GUIDA_pre - aggiornamento flg_stato',PKG_MCRE0_AUDIT.C_DEBUG,SQLCODE,SQLERRM,'FINE');
      PKG_MCRE0_AUDIT.LOG_ETL(seq, c_package||'.UPDATE_FILE_GUIDA_pre - aggiornamento flg_source',PKG_MCRE0_AUDIT.C_DEBUG,SQLCODE,SQLERRM,'INIZIO');
      update T_MCRE0_APP_FILE_GUIDA_ARRG f
      set f.flg_source = case when F.TODAY_FLG = '1' then '1' else '2' end
      where (f.cod_abi_cartolarizzato, f.cod_ndg) in
        (SELECT COD_ABI_CARTOLARIZZATO, COD_NDG
         FROM MCRE_OWN.T_MCRE0_APP_GB_GESTIONE GB
         WHERE GB.FLG_STATO = 1) ;

        commit;
        PKG_MCRE0_AUDIT.LOG_ETL(seq, c_package||'.UPDATE_FILE_GUIDA_pre - aggiornamento flg_source',PKG_MCRE0_AUDIT.C_DEBUG,SQLCODE,SQLERRM,'FINE');
       set_cod_ge_gl(activ_id);

        PKG_MCRE0_AUDIT.LOG_ETL(seq, c_package||'.UPDATE_FILE_GUIDA_pre - storico:'||p_storico, PKG_MCRE0_AUDIT.C_DEBUG,SQLCODE,SQLERRM,'FINE');
       return 1;
  END;


  FUNCTION update_file_guida(p_storico number default 0) return number IS

    activ_id number;
    seq number;

  BEGIN

    select SEQ_MCR0_LOG_ETL.nextval
    into seq from dual;

  PKG_MCRE0_AUDIT.LOG_ETL(seq, c_package||'.UPDATE_FILE_GUIDA - storico: '||p_storico, PKG_MCRE0_AUDIT.C_DEBUG,SQLCODE,SQLERRM,'INIZIO');
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

    update MCRE_OWN.T_MCRE0_APP_FILE_GUIDA_ARRG
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

   BEGIN
    select SEQ_MCR0_LOG_ETL.nextval
    into seq from dual;

    PKG_MCRE0_AUDIT.LOG_ETL(seq, c_package||'.set_cod_ge_gl', PKG_MCRE0_AUDIT.C_DEBUG,SQLCODE,SQLERRM,'INIZIO');

    UPDATE /*+index(m IDX_MCRE0_APP_FILE_GUIDA_FA)*/ mcre_own.T_MCRE0_APP_FILE_GUIDA_ARRG m
    SET m.cod_gruppo_economico = (SELECT  ge.cod_gruppo_economico FROM mcre_own.t_mcre0_app_gruppo_economico ge WHERE m.cod_sndg = ge.cod_sndg(+) ),
      m.flg_gruppo_economico = nvl( (SELECT  DECODE (ge.cod_gruppo_economico, NULL, '0', '1')  FROM mcre_own.t_mcre0_app_gruppo_economico ge WHERE m.cod_sndg = ge.cod_sndg(+) ),'0'),
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
     UPDATE mcre_own.T_MCRE0_APP_FILE_GUIDA_ARRG c
      SET c.flg_singolo = 1,
        c.flg_condiviso = 0
     WHERE cod_sndg IN (SELECT  mm.cod_sndg
                 FROM mcre_own.T_MCRE0_APP_FILE_GUIDA_ARRG mm
                 WHERE mm.flg_active = '1'
               GROUP BY (mm.cod_sndg)
                HAVING COUNT (DISTINCT mm.cod_ndg) = 1)
     AND c.flg_active = '1';

   EXCEPTION
     WHEN OTHERS THEN
      log_caricamenti (c_package || '.SET_COD_GE_GL - fl_singolo',SQLCODE,SQLERRM);
   END;

   --determino i cartolarizzati che non andrebbero sommati nelle statistiche di gruppo
   UPDATE mcre_own.T_MCRE0_APP_FILE_GUIDA_ARRG f
     SET f.flg_somma = '0'
    WHERE f.cod_abi_istituto != f.cod_abi_cartolarizzato
     AND f.cod_ndg IN (SELECT  g.cod_ndg
                FROM mcre_own.T_MCRE0_APP_FILE_GUIDA_ARRG g
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
   log_caricamenti (c_package || '.CALC_COD_COLLEGAMENTO - step 1', -1,'');

-- determino il codice collegamento
--step 1: assegno un cod supergrupppo pari al gruppo Eco (se c'è), Gruppo Legame o super (con relativo prefisso)
   BEGIN
  UPDATE /*+index(mm IDX_MCRE0_APP_FILE_GUIDA_FA)*/ mcre_own.T_MCRE0_APP_FILE_GUIDA_ARRG mm
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
     UPDATE mcre_own.T_MCRE0_APP_FILE_GUIDA_ARRG c
      SET c.cod_gruppo_super =
          (SELECT   'GE'|| LPAD (MAX (cod_gruppo_economico), 18, '0') ge
            FROM mcre_own.T_MCRE0_APP_FILE_GUIDA_ARRG h
            WHERE h.cod_gruppo_legame IN (
                SELECT  cod_gruppo_legame
                  FROM mcre_own.T_MCRE0_APP_FILE_GUIDA_ARRG mm
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
            FROM mcre_own.T_MCRE0_APP_FILE_GUIDA_ARRG mm
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
   cib   mcre_own.t_mcre0_app_mople.cod_comparto_host%TYPE := '000001';
   bdt   mcre_own.t_mcre0_app_mople.cod_comparto_host%TYPE := '000002';
   tavoli  mcre_own.t_mcre0_app_mople.cod_comparto_host%TYPE := '011901';

  BEGIN

   BEGIN
    MERGE INTO mcre_own.T_MCRE0_APP_FILE_GUIDA_ARRG fg
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
                                           AND cod_abi_istituto =
                                                            cod_abi_cartolarizzato
                                           AND cod_struttura_competente = chost)
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
                             END chost
                        FROM mcre_own.T_MCRE0_APP_FILE_GUIDA_ARRG f,
                             (SELECT *
                                FROM mcre_own.t_mcre0_app_mople mo,
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

  UPDATE MCRE_OWN.T_MCRE0_APP_FILE_GUIDA_ARRG F
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

  PROCEDURE storicizza_riportafogliati(activ_id number) is

  begin
null;
end;
  --v2.1: upd solo su chi ha due diversi comparti assegnati su gruppo super OGGI
  --v2.2: aggiunto update Servizio per nuovi ingressi
  --TODO: rivedere la select
  PROCEDURE aggiorna_nuovi_collegati( p_data DATE, activ_id number) is

  row_upd number := 0;
  n    number := 0;
  giorno date  := sysdate;

  begin
    if p_data is null then
    giorno := sysdate;
    else
    giorno := p_data;
    end if;
        -------------------   VG - CIB/BDT - INIZIO --------------------
        MERGE /*+no_parallel(fg)*/ INTO mcre_own.T_MCRE0_APP_FILE_GUIDA_ARRG fg
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
                        FROM MCRE_OWN.T_MCRE0_APP_FILE_GUIDA_ARRG T
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
  UPDATE T_MCRE0_APP_FILE_GUIDA_ARRG F
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

  update T_MCRE0_APP_FILE_GUIDA_ARRG f
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
       from t_mcre0_app_mople m,T_MCRE0_APP_FILE_GUIDA_ARRG f,
         t_mcre0_app_stati s, t_mcre0_app_istituti i
      where M.COD_ABI_CARTOLARIZZATO = F.COD_ABI_CARTOLARIZZATO
       and M.COD_NDG = F.COD_NDG
       and M.TODAY_FLG = '1'
       and M.COD_STATO = S.COD_MICROSTATO
       and F.COD_COMPARTO_ASSEGNATO is not null
       --v3.4
       and f.cod_abi_cartolarizzato = i.cod_abi
       and i.flg_outsourcing = 'Y'
       group by F.COD_GRUPPO_SUPER
       having max(S.FLG_STATO_CHK) is null
      minus --mm20121112 escludo le posizioni in GB
       select COD_GRUPPO_SUPER
       from T_MCRE0_APP_FILE_GUIDA_ARRG f, t_mcre0_app_gb_gestione g
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

  MERGE INTO T_MCRE0_APP_FILE_GUIDA_ARRG FG
  USING (
    select distinct COD_GRUPPO_SUPER, COD_COMPARTO_PROPOSTO from(
    SELECT F.COD_GRUPPO_SUPER, G.COD_COMPARTO_PROPOSTO, DTA_STATO ,
        min(dta_stato) over(partition by cod_gruppo_super) min_dtata_stato
    FROM T_MCRE0_APP_FILE_GUIDA_ARRG F,
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
  commit;
  PKG_MCRE0_AUDIT.log_etl (seq,c_package || '.assegna_comparto_GB_AV', 3, sqlcode, 'aggiornati '||row_upd||' records ('||row_ins||' in TMP_STORICO)', '');
  return 1;

  exception when others then
  PKG_MCRE0_AUDIT.log_etl (seq,c_package || '.assegna_comparto_GB_AV', 1, SQLCODE,SQLERRM, 'rollback');
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
    update T_MCRE0_APP_FILE_GUIDA_ARRG
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
  RETURN RetVal;

  EXCEPTION WHEN OTHERS THEN
   log_caricamenti(c_nome,sqlcode,SQLERRM);
   RETURN -1;

  END update_uscita_CCP;

END PKG_MCRE0_EST_FILE_GUIDA_ARRG;
/


CREATE SYNONYM MCRE_APP.PKG_MCRE0_EST_FILE_GUIDA_ARRG FOR MCRE_OWN.PKG_MCRE0_EST_FILE_GUIDA_ARRG;


GRANT EXECUTE, DEBUG ON MCRE_OWN.PKG_MCRE0_EST_FILE_GUIDA_ARRG TO MCRE_USR;

