CREATE OR REPLACE PACKAGE BODY MCRE_OWN."PKG_MCRE0_GESTIONE_ABI_ELAB" AS
/******************************************************************************
   NAME:       PKG_MCRE0_ALIMENTAZIONE
   PURPOSE:

   REVISIONS:
   Ver        Date        Author             Description
   ---------  ----------  -----------------  ------------------------------------
   1.0        14/02/2011  Marco Murro        Created this package.
   1.1        01/03/2011  Marco Murro        Fix aggiorna_ge
   1.2        13/11/2012  Marco Murro        Fix aggiorna_fguida set flg_active = 1, aggiorna_mople today = 1
******************************************************************************/

  FUNCTION aggiorna_mople return number is

  cursor abi is
  select COD_ABI_ISTITUTO
  from MCRE_OWN.T_MCRE0_APP_ABI_ELABORATI24
  where ID_DPER != (select IDPER from MCRE_OWN.V_MCRE0_ULTIMA_ACQUISIZIONE
                    where cod_file = 'ABIELAB');

  noelab abi%rowtype;

  v_iddper T_MCRE0_APP_ABI_ELABORATI24.ID_DPER%type;
  v_lastid T_MCRE0_APP_ABI_ELABORATI24.ID_DPER%type;


  begin

  -- id_dper mople corrente
  select idper into v_iddper
  from MCRE_OWN.V_MCRE0_ULTIMA_ACQUISIZIONE
  where cod_file = 'MOPLE'  ;

  open abi;
  loop
  fetch abi into noelab;
  exit when abi%notfound;

  begin
    select max(id_dper) into v_lastid
    from MCRE_OWN.T_MCRE0_APP_MOPLE24
    where id_dper != v_iddper
    and COD_ABI_ISTITUTO = noelab.cod_abi_istituto;

    update MCRE_OWN.T_MCRE0_APP_MOPLE24
    set id_dper = v_iddper, 
        today_flg = '1' --v1.2
    where id_dper = v_lastid
    and COD_ABI_ISTITUTO = noelab.cod_abi_istituto;

  exception when others then
    log_caricamenti(c_package||'.aggiorna_mople - last id: '||v_lastid||' abi: '||noelab.cod_abi_istituto, sqlcode, sqlerrm);
    rollback;
    return ko;
  end;

  end loop;
  close abi;

    commit;
    return ok;
  exception when others then
    log_caricamenti(c_package||'.aggiorna_mople ', sqlcode, sqlerrm);
    rollback;
    return ko;
  end;


  FUNCTION aggiorna_file_guida return number is


  v_iddper T_MCRE0_APP_ABI_ELABORATI24.ID_DPER%type;
  v_lastid T_MCRE0_APP_ABI_ELABORATI24.ID_DPER%type;
  v_exist number;


  begin

  select count(*) into v_exist
  from MCRE_OWN.T_MCRE0_APP_ABI_ELABORATI24
  where ID_DPER != (select IDPER from MCRE_OWN.V_MCRE0_ULTIMA_ACQUISIZIONE
                    where cod_file = 'ABIELAB');
  if (v_exist != 0) then

  -- id_dper file_guida corrente
  select idper into v_iddper
  from MCRE_OWN.V_MCRE0_ULTIMA_ACQUISIZIONE
  where cod_file = 'FILE_GUIDA'  ;


    select max(id_dper) into v_lastid
    from MCRE_OWN.T_MCRE0_APP_FILE_GUIDA24
    where id_dper != v_iddper;

    update MCRE_OWN.T_MCRE0_APP_FILE_GUIDA24
    set id_dper = v_iddper,
        flg_active = '1' --v1.2
    where id_dper = v_lastid;

  commit;
  end if;

  return ok;

  exception when others then
    log_caricamenti(c_package||'.aggiorna_file_guida - last id: '||v_lastid, sqlcode, sqlerrm);
    rollback;
    return ko;
  end;


  FUNCTION aggiorna_legami return number is


  v_iddper T_MCRE0_APP_ABI_ELABORATI24.ID_DPER%type;
  v_lastid T_MCRE0_APP_ABI_ELABORATI24.ID_DPER%type;
  v_exist number;


  begin

  select count(*) into v_exist
  from MCRE_OWN.T_MCRE0_APP_ABI_ELABORATI24
  where ID_DPER != (select IDPER from MCRE_OWN.V_MCRE0_ULTIMA_ACQUISIZIONE
                    where cod_file = 'ABIELAB');
  if (v_exist != 0) then

  -- id_dper legami corrente
  select idper into v_iddper
  from MCRE_OWN.V_MCRE0_ULTIMA_ACQUISIZIONE
  where cod_file = 'LEGAME'  ;


    select max(id_dper) into v_lastid
    from MCRE_OWN.T_MCRE0_APP_LEGAME24
    where id_dper != v_iddper;

    update MCRE_OWN.T_MCRE0_APP_LEGAME24
    set id_dper = v_iddper
    where id_dper = v_lastid;

  commit;
  end if;

  return ok;

  exception when others then
    log_caricamenti(c_package||'.aggiorna_legami - last id: '||v_lastid, sqlcode, sqlerrm);
    rollback;
    return ko;
  end;


  FUNCTION aggiorna_ge return number is


  v_iddper T_MCRE0_APP_ABI_ELABORATI24.ID_DPER%type;
  v_lastid T_MCRE0_APP_ABI_ELABORATI24.ID_DPER%type;
  v_exist number;


  begin

  select count(*) into v_exist
  from MCRE_OWN.T_MCRE0_APP_ABI_ELABORATI24
  where ID_DPER != (select IDPER from MCRE_OWN.V_MCRE0_ULTIMA_ACQUISIZIONE
                    where cod_file = 'ABIELAB');
  if (v_exist != 0) then

  -- id_dper legami corrente
  select idper into v_iddper
  from MCRE_OWN.V_MCRE0_ULTIMA_ACQUISIZIONE
  where cod_file = 'GRUPPO_ECONOMICO'  ;


    select max(id_dper) into v_lastid
    from MCRE_OWN.T_MCRE0_APP_GRUPPO_ECONOMICO24
    where id_dper != v_iddper;

    update MCRE_OWN.T_MCRE0_APP_GRUPPO_ECONOMICO24
    set id_dper = v_iddper
    where id_dper = v_lastid;

  commit;

  update T_MCRE0_APP_GRUPPO_ECONOMICO24 e
    set e.FLG_CAPOGRUPPO = 'N'
    where (cod_gruppo_economico, FLG_CAPOGRUPPO, dta_upd) in --v1.1 - era un =..
   (select distinct cod_gruppo_economico, FLG_CAPOGRUPPO, min(dta_upd) over (partition by cod_gruppo_economico)
    from MCRE_OWN.T_MCRE0_APP_GRUPPO_ECONOMICO24 f
    where cod_gruppo_economico in (
        select COD_GRUPPO_ECONOMICO
        from MCRE_OWN.T_MCRE0_APP_GRUPPO_ECONOMICO24 e
        where FLG_CAPOGRUPPO = 'S'
        group by cod_gruppo_economico
        having count(*) >1
        )
    and F.FLG_CAPOGRUPPO = 'S');
  commit;

  end if;

  return ok;

  exception when others then
    log_caricamenti(c_package||'.aggiorna_ge - last id: '||v_lastid, sqlcode, sqlerrm);
    rollback;
    return ko;
  end;


  function check_abi_elab return number is

  esito number:= 1;

  begin

  log_caricamenti(c_package||'.check_abi_elab',-1,'start mople');
   esito:= esito * aggiorna_mople;

  log_caricamenti(c_package||'.check_abi_elab',-1,'start file_guida');
   esito:= esito * aggiorna_file_guida;

  log_caricamenti(c_package||'.check_abi_elab',-1,'start legami');
   esito:= esito * aggiorna_legami;

  log_caricamenti(c_package||'.check_abi_elab',-1,'start ge');
   esito:= esito * aggiorna_ge;
  log_caricamenti(c_package||'.check_abi_elab',-1,'end!');

   return esito;
  exception when others then
   log_caricamenti(c_package||'.check_abi_elab - ko', sqlcode, sqlerrm);
   return ko;

  end;


end PKG_MCRE0_GESTIONE_ABI_ELAB;
/


CREATE SYNONYM MCRE_APP.PKG_MCRE0_GESTIONE_ABI_ELAB FOR MCRE_OWN.PKG_MCRE0_GESTIONE_ABI_ELAB;


CREATE SYNONYM MCRE_USR.PKG_MCRE0_GESTIONE_ABI_ELAB FOR MCRE_OWN.PKG_MCRE0_GESTIONE_ABI_ELAB;


GRANT EXECUTE, DEBUG ON MCRE_OWN.PKG_MCRE0_GESTIONE_ABI_ELAB TO MCRE_USR;

