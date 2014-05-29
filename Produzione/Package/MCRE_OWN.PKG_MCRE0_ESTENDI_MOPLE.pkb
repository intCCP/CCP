CREATE OR REPLACE PACKAGE BODY MCRE_OWN.PKG_MCRE0_ESTENDI_MOPLE
AS
/******************************************************************************
   NAME:       PKG_MCRE0_ESTENDI_MOPLE
   PURPOSE:

   REVISIONS:
   Ver        Date        Author           Description
   ---------  ----------  ---------------  ------------------------------------
   1.0        21/10/2010  M.Murro.           Created this package.
   1.1        19/11/2010  Galli Valeria      Tabella CL_STATI cambiata in APP_STATI.
   1.2        24/11/2010  Marco Murro        gestito filtro per IDDPER per gli update
   1.3        25/11/2010  Galli Valeria      Aggiunto calcolo processo PRE
   1.4        13/12/2010  Marco Murro        Aggiunto gestione Ramo (al posto di comparto_host)
   1.5        17/12/2010  Galli Valeria      Tolto controllo comparti + data_decorrenza_stato_precedente
   2.0        11/01/2011  Marco  Murro       Aggiunta gestione MOPLE_PK_TODAY
   2.1        31/03/2011  Marco  Murro       Varato calcolo decorrenza macrostato su stati uscita
   2.2        27/04/2011  Marco  Murro       Varato calcolo decorrenza macrostato su SO
   2.3        11/05/2011  Marco  Murro       Varato calcolo decorrenza macrostato su SO (= dta_dec.Stato)
   2.4        24/05/2011  Marco  Murro       Gestione GB
   2.5        06/06/2011  Marco  Murro       Fix Gestione GB
   3.0        18/07/2011  Marco Murre        Nuove strutture per tuning
   3.1        30/08/2011  Marco Murre        commit intermedio in set_today_flag
   3.2        19/10/2011  Paola Goitre       noparallel mople sui cursori e cambiata fnc_set_today_flg
******************************************************************************/
   --v1.4 - aggiorno comparto e ramo
   FUNCTION SET_COMPARTO_HOST return number IS
   BEGIN

      UPDATE MCRE_OWN.T_MCRE0_APP_MOPLE M
         SET (M.COD_COMPARTO_HOST, COD_RAMO_HOST) =
                (SELECT COD_COMPARTO, COD_RAMO
                   FROM MCRE_OWN.T_MCRE0_APP_STRUTTURA_ORG S
                  WHERE S.COD_ABI_ISTITUTO = M.COD_ABI_ISTITUTO
                    AND S.COD_STRUTTURA_COMPETENTE = M.COD_STRUTTURA_COMPETENTE)
         WHERE M.TODAY_FLG = '1';

      COMMIT;
      return ok;
   END;

  -- Procedura per update cod_processo_precedente in MOPLE
  -- INPUT :
  --    p_cod_abi
  --    p_cod_ndg
  -- OUTPUT :
  --    stato esecuzione 1 OK 0 Errori
  FUNCTION fnc_gestione_processo_pre_ndg(
    p_cod_abi   T_MCRE0_APP_MOPLE.COD_ABI_CARTOLARIZZATO%type,
    p_cod_ndg   T_MCRE0_APP_MOPLE.COD_NDG%type
  )
  RETURN NUMBER IS

    v_cod_proc_pre T_MCRE0_APP_MOPLE.cod_processo_pre%type;
    v_cod_percorso T_MCRE0_APP_MOPLE.COD_PERCORSO%type;
    v_cod_processo T_MCRE0_APP_MOPLE.COD_PROCESSO%type;

  begin

    begin
      select cod_percorso,b.cod_processo
      into  v_cod_percorso, v_cod_processo
      from  T_MCRE0_APP_MOPLE b
      where b.COD_ABI_CARTOLARIZZATO = p_cod_abi
      and   b.COD_NDG = p_cod_ndg;
    exception
      when no_data_found then
        null;
      when others then
        log_caricamenti('fnc_gestione_processo_pre_ndg SELECT',SQLCODE,'SQLERRM='||SQLERRM);
        return ko;
    end;

    begin
      select cod_processo_pre
      into   v_cod_proc_pre
      from (
              select cod_abi_cartolarizzato, cod_ndg, COD_PROCESSO, tms,
                     lag(COD_PROCESSO,1) over (ORDER BY cod_abi_cartolarizzato, cod_ndg, tms ) AS cod_processo_pre
              from   t_mcre0_app_percorsi
              where cod_abi_cartolarizzato= p_cod_abi
              and   cod_ndg = p_cod_ndg
              AND   cod_percorso = v_cod_percorso
              order by tms desc
              ) q
      where cod_processo != cod_processo_pre
      and   rownum = 1;
    exception
      when no_data_found then
        v_cod_proc_pre := null;
      when others then
        log_caricamenti('fnc_gestione_processo_pre_ndg PROCESSO PRE',SQLCODE,'SQLERRM='||SQLERRM);
        return ko;
    end;

    begin
      update t_mcre0_app_mople m
      set    m.cod_processo_pre = v_cod_proc_pre
      where  m.cod_abi_cartolarizzato = p_cod_abi
      and    m.cod_ndg = p_cod_ndg;
      commit;
    exception
      when others then
        log_caricamenti('fnc_gestione_processo_pre_ndg UPDATE PROCESSO PRE',SQLCODE,'SQLERRM='||SQLERRM);
        return ko;
    end;

    return ok;

  exception
    when others then
      log_caricamenti('fnc_gestione_processo_pre_ndg ',SQLCODE,'GENERALE - SQLERRM='||SQLERRM);
      return ko;
  end;

  -- Procedura per update cod_processo_precedente in MOPLE
  -- INPUT :
  --
  -- OUTPUT :
  --    stato esecuzione 1 OK 0 Errori
  FUNCTION fnc_gestione_processo_pre
  RETURN NUMBER IS

    v_cod_proc_pre T_MCRE0_APP_MOPLE.cod_processo_pre%type;
    cursor c_percorso is
      select /*+no_parallel(b)*/ b.cod_abi_cartolarizzato,b.cod_ndg,cod_percorso,b.COD_PROCESSO
      from   T_MCRE0_APP_MOPLE b,
             T_MCRE0_APP_FILE_GUIDA g
      where b.COD_ABI_CARTOLARIZZATO = g.COD_ABI_CARTOLARIZZATO
      and   b.COD_NDG = g.COD_NDG
--      and   nvl(g.COD_COMPARTO_ASSEGNATO,g.COD_COMPARTO_CALCOLATO) in (
--              select c.COD_COMPARTO from T_MCRE0_app_COMPARTI c where c.flg_chk = 1
--            )
      and   b.COD_STATO in (
               select cod_microstato
               from   T_MCRE0_APP_STATI s
               where  s.flg_stato_chk=1
             )
      and   B.TODAY_FLG = '1'
      AND   g.id_dper = (SELECT a.idper
                  FROM v_mcre0_ultima_acquisizione a
                 WHERE a.cod_file = 'FILE_GUIDA')
      order by b.cod_abi_cartolarizzato,b.cod_ndg;

  begin

    for rec_percorso in c_percorso loop
      v_cod_proc_pre := null;
      begin
        select cod_processo_pre
        into   v_cod_proc_pre
        from (
                select cod_abi_cartolarizzato, cod_ndg, COD_PROCESSO, tms,
                       lag(COD_PROCESSO,1) over (ORDER BY cod_abi_cartolarizzato, cod_ndg, tms ) AS cod_processo_pre
                from   t_mcre0_app_percorsi
                where cod_abi_cartolarizzato= rec_percorso.cod_abi_cartolarizzato
                and   cod_ndg = rec_percorso.cod_ndg
                AND   cod_percorso = rec_percorso.cod_percorso
                order by tms desc
                ) q
        where cod_processo != cod_processo_pre
        and   rownum = 1;
      exception
        when no_data_found then
          v_cod_proc_pre := null;
        when others then
          log_caricamenti('fnc_gestione_processo_pre PROCESSO PRE',SQLCODE,'SQLERRM='||SQLERRM);
          return ko;
      end;

      begin
        update t_mcre0_app_mople m
        set    m.cod_processo_pre = v_cod_proc_pre
        where  m.cod_abi_cartolarizzato = rec_percorso.cod_abi_cartolarizzato
        and    m.cod_ndg = rec_percorso.cod_ndg;
        commit;
      exception
        when others then
          log_caricamenti('fnc_gestione_processo_pre UPDATE PROCESSO PRE',SQLCODE,'SQLERRM='||SQLERRM);
          return ko;
      end;
    end loop;

    return ok;

  exception
    when others then
      log_caricamenti('fnc_gestione_processo_pre ',SQLCODE,'GENERALE - SQLERRM='||SQLERRM);
      return ko;
  end;


  -- Procedura per update cod_macrostato, dta_decorrenza_macrostato in MOPLE
  -- INPUT :
  --
  -- OUTPUT :
  --    stato esecuzione 1 OK 0 Errori
  FUNCTION fnc_gestione_macrostato
  RETURN NUMBER IS

    v_dta_dec_macrostato T_MCRE0_APP_MOPLE.DTA_DEC_MACROSTATO%type;
    cursor c_percorso is
      select /*+no_parallel(b)*/ b.cod_abi_cartolarizzato,b.cod_ndg,cod_percorso,cod_macrostato,cod_stato
      from   T_MCRE0_APP_MOPLE b,
             T_MCRE0_APP_FILE_GUIDA g
      where b.COD_ABI_CARTOLARIZZATO = g.COD_ABI_CARTOLARIZZATO
      and   b.COD_NDG = g.COD_NDG
--      and   nvl(g.COD_COMPARTO_ASSEGNATO,g.COD_COMPARTO_CALCOLATO) in (
--              select c.COD_COMPARTO from T_MCRE0_app_COMPARTI c where c.flg_chk = 1
--            )
      and   b.COD_STATO in (
               select cod_microstato
               from   T_MCRE0_APP_STATI s
               where  s.flg_stato_chk=1
               or  s.tip_stato = 'U'
             )
      and   B.TODAY_FLG = '1'
      AND   g.id_dper = (SELECT a.idper
                  FROM v_mcre0_ultima_acquisizione a
                 WHERE a.cod_file = 'FILE_GUIDA')
      order by b.cod_abi_cartolarizzato,b.cod_ndg;

  begin

    begin
      update T_MCRE0_APP_MOPLE m
      set m.cod_macrostato = (
        select cod_macrostato
        from   T_MCRE0_APP_STATI s
        where  s.cod_microstato = m.cod_stato)
      where M.TODAY_FLG = '1';
      --where m.cod_macrostato is null;
        commit;
    exception
      when others then
        log_caricamenti('fnc_gestione_macrostato UPDATE MACROSTATO',SQLCODE,'SQLERRM='||SQLERRM);
        return ko;
    end;

    for rec_percorso in c_percorso loop
      v_dta_dec_macrostato := null;
      begin --v2.2 se SO --> sysdate! <-- rimosso da v2.3
        --select decode(rec_percorso.COD_STATO, 'SO', sysdate, min(p.DTA_DECORRENZA_STATO)) dta_dec_macrostato
        select min(p.DTA_DECORRENZA_STATO) dta_dec_macrostato
        into  v_dta_dec_macrostato
        from  t_mcre0_app_percorsi p,
              t_mcre0_app_stati s1,
              t_mcre0_app_stati s2
        where p.cod_stato_precedente = s1.cod_microstato
        and   p.cod_stato = s2.cod_microstato
        AND   cod_abi_cartolarizzato= rec_percorso.cod_abi_cartolarizzato
        and   cod_ndg = rec_percorso.cod_ndg
        AND   cod_percorso = rec_percorso.cod_percorso
        and   s1.COD_MACROSTATO != s2.COD_MACROSTATO
        and   s2.COD_MACROSTATO = rec_percorso.COD_MACROSTATO;
      exception
        when no_data_found then
          v_dta_dec_macrostato := null;
        when others then
          log_caricamenti('fnc_gestione_macrostato DTA MACROSTATO',SQLCODE,'SQLERRM='||SQLERRM);
          return ko;
      end;

      begin
        update t_mcre0_app_mople m
        -- v2.3 metto qui la forzatura a dec_stato per SO
        set    dta_dec_macrostato = decode(m.cod_stato, 'SO', m.DTA_DECORRENZA_STATO, v_dta_dec_macrostato)
        where  m.cod_abi_cartolarizzato = rec_percorso.cod_abi_cartolarizzato
        and    m.cod_ndg = rec_percorso.cod_ndg
        and    m.cod_macrostato = rec_percorso.cod_macrostato;
        commit;
      exception
        when others then
          log_caricamenti('fnc_gestione_macrostato UPDATE DTA MACROSTATO',SQLCODE,'SQLERRM='||SQLERRM);
          return ko;
      end;
    end loop;

    return ok;

  exception
    when others then
      log_caricamenti('fnc_gestione_macrostato ',SQLCODE,'GENERALE - SQLERRM='||SQLERRM);
      return ko;
  end;

--v3.0 --spostata in gestione_all_data!
--  -- Procedura per update cod_macrostato, dta_decorrenza_macrostato in MOPLE
--  -- dopo cambio stato.
--  -- INPUT :
--  --    p_cod_abi
--  --    p_cod_ndg
--  -- OUTPUT :
--  --    stato esecuzione 1 OK 0 Errori
--  -- NO COMMIT
--  FUNCTION fnc_gestione_macrost_cambiost(
--    p_cod_abi   T_MCRE0_APP_MOPLE.COD_ABI_CARTOLARIZZATO%type,
--    p_cod_ndg   T_MCRE0_APP_MOPLE.COD_NDG%type
--  )
--  RETURN NUMBER IS

--    v_dta_dec_macrostato T_MCRE0_APP_MOPLE.DTA_DEC_MACROSTATO%type;
--    v_cod_percorso       T_MCRE0_APP_MOPLE.COD_PERCORSO%type;
--    v_cod_macrostato     T_MCRE0_APP_MOPLE.COD_MACROSTATO%type;

--  begin

--    begin
--      select decode(s.cod_macrostato,m.COD_MACROSTATO,m.DTA_DEC_MACROSTATO,null),
--             m.COD_PERCORSO,m.COD_MACROSTATO
--      into   v_dta_dec_macrostato , v_cod_percorso, v_cod_macrostato
--      from   T_MCRE0_APP_STATI s ,
--             T_MCRE0_APP_MOPLE m
--      where m.COD_ABI_CARTOLARIZZATO = p_cod_abi
--      and   m.COD_NDG = p_cod_ndg
--      and   s.cod_microstato = m.cod_stato ;
--    exception
--      when others then
--        log_caricamenti('fnc_gestione_macrost_cambiost DTA MACROSTATO',SQLCODE,'SQLERRM='||SQLERRM);
--        return ko;
--    end;

--    if(v_dta_dec_macrostato is null)then
--      begin
--        select min(p.DTA_DECORRENZA_STATO) dta_dec_macrostato
--        into  v_dta_dec_macrostato
--        from  t_mcre0_app_percorsi p,
--              t_mcre0_app_stati s2
--        where p.cod_stato = s2.cod_microstato
--        AND   cod_abi_cartolarizzato= p_cod_abi
--        and   cod_ndg = p_cod_ndg
--        AND   cod_percorso = v_cod_percorso
--        and   s2.COD_MACROSTATO = v_cod_macrostato;
--      exception
--        when others then
--          log_caricamenti('fnc_gestione_macrost_cambiost MIN DTA MACROSTATO',SQLCODE,'SQLERRM='||SQLERRM);
--          return ko;
--      end;
--    end if;

--    begin
--      update t_mcre0_app_mople m
--      set    dta_dec_macrostato = v_dta_dec_macrostato
--      where  m.cod_abi_cartolarizzato = p_cod_abi
--      and    m.cod_ndg = p_cod_ndg;
--      --commit;
--    exception
--      when others then
--        log_caricamenti('fnc_gestione_macrost_cambiost UPDATE DTA MACROSTATO',SQLCODE,'SQLERRM='||SQLERRM);
--        return ko;
--    end;

--    begin
--      update T_MCRE0_APP_MOPLE m
--      set m.cod_macrostato = (
--        select cod_macrostato
--        from   T_MCRE0_APP_STATI s
--        where  s.cod_microstato = m.cod_stato)
--      where m.COD_ABI_CARTOLARIZZATO = p_cod_abi
--      and   m.COD_NDG = p_cod_ndg;
--      --commit;
--    exception
--      when others then
--        log_caricamenti('fnc_gestione_macrost_cambiost UPDATE MACROSTATO',SQLCODE,'SQLERRM='||SQLERRM);
--        return ko;
--    end;

--    return ok;

--  exception
--    when others then
--      log_caricamenti('fnc_gestione_macrost_cambiost ',SQLCODE,'GENERALE - SQLERRM='||SQLERRM);
--      return ko;
--  end;

  -- Procedura per update dta_stato_precedente in MOPLE
  -- INPUT :
  --
  -- OUTPUT :
  --    stato esecuzione 1 OK 0 Errori
  FUNCTION fnc_gestione_dta_stato_pre
  RETURN NUMBER IS

    v_dta_stato_pre T_MCRE0_APP_MOPLE.DTA_DECORRENZA_STATO_PRE%type;
    cursor c_percorso is
      select /*+no_parallel(b)*/ b.cod_abi_cartolarizzato,b.cod_ndg,cod_percorso,b.COD_PROCESSO
      from  T_MCRE0_APP_MOPLE b,
            T_MCRE0_APP_FILE_GUIDA g
      where b.COD_ABI_CARTOLARIZZATO = g.COD_ABI_CARTOLARIZZATO
      and   b.COD_NDG = g.COD_NDG
--      and   nvl(g.COD_COMPARTO_ASSEGNATO,g.COD_COMPARTO_CALCOLATO) in (
--              select c.COD_COMPARTO from T_MCRE0_app_COMPARTI c where c.flg_chk = 1
--            )
      and   b.COD_STATO in (
               select cod_microstato
               from   T_MCRE0_APP_STATI s
               where  s.flg_stato_chk=1
             )
      and   B.TODAY_FLG = '1'
      AND   g.id_dper = (SELECT a.idper
                  FROM v_mcre0_ultima_acquisizione a
                 WHERE a.cod_file = 'FILE_GUIDA')
      order by b.cod_abi_cartolarizzato,b.cod_ndg;

  begin

    for rec_percorso in c_percorso loop
      v_dta_stato_pre := null;
      begin
        select dta_stato_pre
        into   v_dta_stato_pre
        from (
                select cod_abi_cartolarizzato, cod_ndg, cod_stato,p.cod_stato_precedente, p.DTA_DECORRENZA_STATO,
                       lag(p.DTA_DECORRENZA_STATO,1) over (ORDER BY cod_abi_cartolarizzato, cod_ndg, tms ) AS dta_stato_pre,
                       tms
                from   t_mcre0_app_percorsi p
                where cod_abi_cartolarizzato= rec_percorso.cod_abi_cartolarizzato
                and   cod_ndg = rec_percorso.cod_ndg
                AND   cod_percorso = rec_percorso.cod_percorso
                order by tms desc
                ) q
        --where cod_stato != cod_stato_precedente
        where rownum = 1;
      exception
        when no_data_found then
          v_dta_stato_pre := null;
        when others then
          log_caricamenti('fnc_gestione_dta_stato_pre DTA_STATO PRE',SQLCODE,'SQLERRM='||SQLERRM);
          return ko;
      end;

      begin
        update t_mcre0_app_mople m
        set    m.dta_decorrenza_stato_pre = v_dta_stato_pre
        where  m.cod_abi_cartolarizzato = rec_percorso.cod_abi_cartolarizzato
        and    m.cod_ndg = rec_percorso.cod_ndg;
        commit;
      exception
        when others then
          log_caricamenti('fnc_gestione_dta_stato_pre UPDATE DTA_STATO PRE',SQLCODE,'SQLERRM='||SQLERRM);
          return ko;
      end;
    end loop;

    return ok;

  exception
    when others then
      log_caricamenti('fnc_gestione_dta_stato_pre ',SQLCODE,'GENERALE - SQLERRM='||SQLERRM);
      return ko;
  end;

  -- Procedura per update dta_stato_precedente in MOPLE
  -- INPUT :
  --    p_cod_abi
  --    p_cod_ndg
  -- OUTPUT :
  --    stato esecuzione 1 OK 0 Errori
  FUNCTION fnc_gestione_dta_stato_pre_ndg(
    p_cod_abi   T_MCRE0_APP_MOPLE.COD_ABI_CARTOLARIZZATO%type,
    p_cod_ndg   T_MCRE0_APP_MOPLE.COD_NDG%type
  )
  RETURN NUMBER IS

    v_dta_stato_pre T_MCRE0_APP_MOPLE.DTA_DECORRENZA_STATO_PRE%type;
    v_cod_percorso T_MCRE0_APP_MOPLE.COD_PERCORSO%type;
    v_cod_stato T_MCRE0_APP_MOPLE.COD_STATO%type;

  begin

    begin
      select cod_percorso,b.cod_stato
      into  v_cod_percorso, v_cod_stato
      from  T_MCRE0_APP_MOPLE b
      where b.COD_ABI_CARTOLARIZZATO = p_cod_abi
      and   b.COD_NDG = p_cod_ndg;
    exception
      when no_data_found then
        null;
      when others then
        log_caricamenti('fnc_gestione_dta_stato_pre_ndg SELECT',SQLCODE,'SQLERRM='||SQLERRM);
        return ko;
    end;

    begin
      select dta_stato_pre
      into   v_dta_stato_pre
      from (
              select cod_abi_cartolarizzato, cod_ndg, cod_stato,p.cod_stato_precedente, p.DTA_DECORRENZA_STATO,
                     lag(p.DTA_DECORRENZA_STATO,1) over (ORDER BY cod_abi_cartolarizzato, cod_ndg, tms ) AS dta_stato_pre,
                     tms
              from   t_mcre0_app_percorsi p
              where cod_abi_cartolarizzato= p_cod_abi
              and   cod_ndg = p_cod_ndg
              AND   cod_percorso = v_cod_percorso
              order by tms desc
              ) q
      --where cod_stato != cod_stato_precedente
      where 1=1
      and   rownum = 1;
    exception
      when no_data_found then
        v_dta_stato_pre := null;
      when others then
        log_caricamenti('fnc_gestione_dta_stato_pre_ndg DTA_STATO PRE',SQLCODE,'SQLERRM='||SQLERRM);
        return ko;
    end;

    begin
      update t_mcre0_app_mople m
      set    m.dta_decorrenza_stato_pre = v_dta_stato_pre
      where  m.cod_abi_cartolarizzato = p_cod_abi
      and    m.cod_ndg = p_cod_ndg;
      commit;
    exception
      when others then
        log_caricamenti('fnc_gestione_dta_stato_pre_ndg UPDATE DTA_STATO PRE',SQLCODE,'SQLERRM='||SQLERRM);
        return ko;
    end;

    return ok;

  exception
    when others then
      log_caricamenti('fnc_gestione_dta_stato_pre_ndg ',SQLCODE,'GENERALE - SQLERRM='||SQLERRM);
      return ko;
  end;

  -- Procedura per popolare la tabella delle chiavi mople aggiornate giornalmente
  -- INPUT :
  --
  -- OUTPUT :
  --    stato esecuzione 1 OK 0 Errori
  FUNCTION fnc_fill_mople_pk_today RETURN NUMBER is

  begin
/*
  execute immediate 'truncate table MCRE_OWN.T_MCRE0_APP_MOPLE_PK_TODAY';

    insert into T_MCRE0_APP_MOPLE_PK_TODAY
    (cod_abi_cartolarizzato,cod_ndg,flg_source)
   (select cod_abi_cartolarizzato,cod_ndg,0 --v2.5
    from T_MCRE0_APP_MOPLE
    where id_dper = (SELECT a.idper
    FROM v_mcre0_ultima_acquisizione a
    WHERE a.cod_file = 'MOPLE'));

    --v2.5
    MERGE into T_MCRE0_APP_MOPLE_PK_TODAY p
    using
     (SELECT COD_ABI_CARTOLARIZZATO, COD_NDG
      FROM MCRE_OWN.T_MCRE0_APP_GB_GESTIONE GB
      WHERE GB.FLG_STATO = 1) g
    on (P.COD_ABI_CARTOLARIZZATO = G.COD_ABI_CARTOLARIZZATO
         and P.COD_NDG = G.COD_NDG)
      when matched then
          UPDATE
          set P.FLG_SOURCE = 1
      when not matched then
          INSERT (COD_ABI_CARTOLARIZZATO, COD_NDG, FLG_SOURCE)
          values (g.COD_ABI_CARTOLARIZZATO, g.COD_NDG, 2);

    commit;
*/
    return ok;

  exception when others then
    log_caricamenti(c_package||'.fnc_fill_mople_pk_today',sqlcode, sqlerrm);
    return ko;
  end;

  --v3.0 sostituisce la pk_today!
  FUNCTION fnc_set_today_flg RETURN NUMBER is

  begin

--aggiorno il today_flag
--    Update t_mcre0_app_mople
--    set today_flg = '0'
--    where today_flg = '1';--azzero tutti
--
--    commit; --v3.1
--
--    Update t_mcre0_app_mople
--    set today_flg = '1'
--    where id_dper=(SELECT a.idper
--                   FROM v_mcre0_ultima_acquisizione a
--                   WHERE a.cod_file = 'MOPLE');
--
--    commit;
    -- v 3.2 PG una sola upd
    UPDATE t_mcre0_app_mople
    SET today_flg =
          CASE
             WHEN id_dper = (SELECT a.idper
                               FROM v_mcre0_ultima_acquisizione a
                              WHERE a.cod_file = 'MOPLE') THEN '1'
             ELSE '0'
          END;
    commit;
    return ok;

  exception when others then
    log_caricamenti(c_package||'.fnc_set_today_flg',sqlcode, sqlerrm);
    return ko;
  end;

  --v2.4: setta stato a 2 su GB gestione se classificato da mople
  FUNCTION UPD_GB_STATUS RETURN NUMBER is

  begin

    --cambio stato se ancora in 'inviato' ma ora in mople
    update t_mcre0_app_gb_gestione
    set flg_stato = -2, --classificato da Mople
        dta_stato = sysdate
    where (cod_abi_cartolarizzato, cod_ndg) in
            (select g.cod_abi_cartolarizzato, g.cod_ndg
             from t_mcre0_app_mople m, t_mcre0_app_stati s,
                  t_mcre0_app_gb_gestione g, V_MCRE0_ULTIMA_ACQUISIZIONE v
             where G.COD_ABI_CARTOLARIZZATO = M.COD_ABI_CARTOLARIZZATO
               and G.COD_NDG = M.COD_NDG
               and V.COD_FILE = 'MOPLE'
               and M.ID_DPER = V.IDPER
               and M.COD_STATO = S.COD_MICROSTATO
               and S.FLG_STATO_CHK = '1'
               and G.FLG_STATO = 1);
    log_caricamenti(c_package||'.UPD_GB_STATUS',sqlcode, 'classidficati '||sql%rowcount||' GB');
    commit;
    return ok;
  exception when others then
    log_caricamenti(c_package||'.UPD_GB_STATUS',sqlcode, sqlerrm);
    rollback;
    return ko;
  end;

END PKG_MCRE0_ESTENDI_MOPLE;
/


CREATE SYNONYM MCRE_APP.PKG_MCRE0_ESTENDI_MOPLE FOR MCRE_OWN.PKG_MCRE0_ESTENDI_MOPLE;


CREATE SYNONYM MCRE_USR.PKG_MCRE0_ESTENDI_MOPLE FOR MCRE_OWN.PKG_MCRE0_ESTENDI_MOPLE;


GRANT EXECUTE ON MCRE_OWN.PKG_MCRE0_ESTENDI_MOPLE TO MCRE_USR WITH GRANT OPTION;
GRANT DEBUG ON MCRE_OWN.PKG_MCRE0_ESTENDI_MOPLE TO MCRE_USR;

