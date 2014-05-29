CREATE OR REPLACE PACKAGE BODY MCRE_OWN."PKG_MCRE0_CARICA_GRUPPO_LEGAME" AS
/******************************************************************************
   NAME:       PKG_MCRE0_ALIMENTAZIONE
   PURPOSE:

   REVISIONS:
   Ver        Date        Author             Description
   ---------  ----------  -----------------  ------------------------------------
   1.0        06/10/2010  Marco Murro        Created this package.
   1.1        24/11/2010  Marco Murro        Filtrato cursore legami con IDDPER
   1.2        01/03/2011  Marco Murro        Variata svecchia GE (evito doppi capogruppo)
   1.3        01/03/2011  Marco Murro        Variata svecchia GE (ripensato lo svecchiamento)
   1.4        01/03/2011  Marco Murro        Variata svecchia LEG (pulizia su File Guida)
   1.5        22/04/2011  Marco Murro        Variata svecchia GE (potenziato lo svecchiamento)
   1.6        27/03/2012  Paola Goitre       Aggiunta gestione dei flag flg_gruppo_economico e flg_gruppo_legame
******************************************************************************/


FUNCTION SVECCHIA_LEGAMI return number IS

righe_fg number ;

last_period MCRE_OWN.T_MCRE0_APP_LEGAME24.ID_DPER%type := NULL;

BEGIN
  BEGIN
 --recupero l'ultimo periodo elaborato sulla Legami
    select IDPER into last_period
    from MCRE_OWN.V_MCRE0_ULTIMA_ACQUISIZIONE
    where COD_FILE = c_file_legame;

  EXCEPTION
  WHEN NO_DATA_FOUND THEN
    log_caricamenti(c_package||'.SVECCHIA_LEGAMI',SQLCODE,SQLERRM||' - last_period '||last_period);
    RETURN 0;
  WHEN OTHERS THEN
    log_caricamenti(c_package||'.SVECCHIA_LEGAMI',SQLCODE,SQLERRM||' - last_period '||last_period);
  END ;

    IF(last_period IS NOT NULL) THEN
    BEGIN

    --elimino dalla Legame i record non aggiornati, che si riferiscono a sndg non aggionrati sul File Guida
    delete MCRE_OWN.T_MCRE0_APP_LEGAME24 l
    where cod_sndg in
    (
       (select cod_sndg from MCRE_OWN.T_MCRE0_APP_LEGAME24 l
        where cod_legame = 'TIT'
        and ID_DPER < last_period
        union
        select cod_sndg_legame from MCRE_OWN.T_MCRE0_APP_LEGAME24 l
        where cod_legame = 'FCM'
        and ID_DPER < last_period  )
    minus
        select COD_SNDG from MCRE_OWN.T_MCRE0_APP_FILE_GUIDA24 g
        where id_dper =
            (select IDPER
             from MCRE_OWN.V_MCRE0_ULTIMA_ACQUISIZIONE
             where COD_FILE = c_file_guida)
    )
    and ID_DPER < last_period;

    commit;


    update  t_mcre0_app_file_guida24
    set cod_gruppo_legame = null,flg_gruppo_legame=0
    where (cod_abi_cartolarizzato, cod_ndg) in ( select f.cod_abi_cartolarizzato, cod_ndg
            from t_mcre0_app_file_guida24 f,T_MCRE0_APP_GRUPPO_LEGAME l
            where F.COD_SNDG = L.COD_SNDG(+)
            and F.COD_GRUPPO_LEGAME = L.COD_GRUPPO_LEGAME(+)
            and L.COD_SNDG is null
            and F.COD_GRUPPO_LEGAME is not null)
    and cod_gruppo_legame is not null;
    righe_fg:=sql%rowcount;
    log_caricamenti(c_package||'.SVECCHIA_LEGAMI - bonifica su FG',-1,'Rimossi '||righe_fg||'righe. ID_DPER caricato: '||last_period);

    EXCEPTION WHEN OTHERS THEN
    log_caricamenti(c_package||'.SVECCHIA_LEGAMI - DELETE',SQLCODE,SQLERRM||' - last_period '||last_period);

    END;
    END IF;
    return 1;
END;

FUNCTION SVECCHIA_GE return number IS

righe_fg number := 0;
righe_ge number := 0;

last_period MCRE_OWN.T_MCRE0_APP_GRUPPO_ECONOMICO24.ID_DPER%type := NULL;

BEGIN
  BEGIN
 --recupero l'ultimo periodo elaborato della GE
    select IDPER into last_period
    from MCRE_OWN.V_MCRE0_ULTIMA_ACQUISIZIONE
    where COD_FILE = c_file_ge;
  EXCEPTION
  WHEN NO_DATA_FOUND THEN
    log_caricamenti(c_package||'.SVECCHIA_GE',SQLCODE,SQLERRM||' - last_period '||last_period);
    RETURN 0;
  WHEN OTHERS THEN
    log_caricamenti(c_package||'.SVECCHIA_GE',SQLCODE,SQLERRM||' - last_period '||last_period);
  END ;

    IF(last_period IS NOT NULL) THEN
    BEGIN

--    --elimino dalla GE i record non aggiornati, che si riferiscono a sndg non aggionrati sul File Guida
--    delete MCRE_OWN.T_MCRE0_APP_GRUPPO_ECONOMICO
--    where cod_sndg in
--    (
--        select cod_sndg from MCRE_OWN.T_MCRE0_APP_GRUPPO_ECONOMICO
--        where ID_DPER < last_period
--    minus
--        select COD_SNDG from MCRE_OWN.T_MCRE0_APP_FILE_GUIDA g
--        where id_dper =
--            (select IDPER
--             from MCRE_OWN.V_MCRE0_ULTIMA_ACQUISIZIONE
--             where COD_FILE = c_file_guida)
--    )
--    and ID_DPER < last_period;
--    commit;
--
--    --ripulisco eventuali doppi capogruppo - v1.2
--    update T_MCRE0_APP_GRUPPO_ECONOMICO e
--    set e.FLG_CAPOGRUPPO = 'N'
--    where (cod_gruppo_economico, FLG_CAPOGRUPPO, dta_upd) in
--    (select distinct cod_gruppo_economico, FLG_CAPOGRUPPO, min(dta_upd) over (partition by cod_gruppo_economico)
--     from MCRE_OWN.T_MCRE0_APP_GRUPPO_ECONOMICO f
--     where cod_gruppo_economico in (
--        select COD_GRUPPO_ECONOMICO
--        from MCRE_OWN.T_MCRE0_APP_GRUPPO_ECONOMICO e
--        where FLG_CAPOGRUPPO = 'S'
--        group by cod_gruppo_economico
--        having count(*) >1
--        )
--    and F.FLG_CAPOGRUPPO = 'S');
--    commit;
    --v1.3 -sbianco il gruppo su File Guida per chi è uscito
    update t_mcre0_app_file_guida24
    set cod_gruppo_economico = null,flg_gruppo_economico=0
    where cod_sndg in (
        select cod_sndg from MCRE_OWN.T_MCRE0_APP_GRUPPO_ECONOMICO24
        where COD_GRUPPO_ECONOMICO in (
            select COD_GRUPPO_ECONOMICO
            from MCRE_OWN.T_MCRE0_APP_GRUPPO_ECONOMICO24
            group by COD_GRUPPO_ECONOMICO
            having max(id_dper) = last_period
            and count(distinct id_dper) >1)
        and ID_DPER !=last_period);
    righe_fg:=sql%rowcount;

    --v1.3 -rimuovo gli sndg non aggiornati nel gruppo
    delete MCRE_OWN.T_MCRE0_APP_GRUPPO_ECONOMICO24
    where COD_GRUPPO_ECONOMICO in (
        select COD_GRUPPO_ECONOMICO
        from MCRE_OWN.T_MCRE0_APP_GRUPPO_ECONOMICO24
        group by COD_GRUPPO_ECONOMICO
        having max(id_dper) = last_period
        and count(distinct id_dper) >1)
    and ID_DPER !=last_period;
    righe_ge:=sql%rowcount;

    --v1.5 -rimuovo tutti i record che hanno un idper più vecchio che sul file guida
    delete t_mcre0_app_gruppo_economico24
    where (cod_sndg, ID_DPER) in (
    select distinct g.cod_sndg, G.ID_DPER from
    t_mcre0_app_file_guida24 f, t_mcre0_app_gruppo_economico24 g
    where F.COD_SNDG = G.COD_SNDG
    and F.ID_DPER > G.ID_DPER);
    righe_ge:=righe_ge+sql%rowcount;

    commit;
    log_caricamenti(c_package||'.SVECCHIA_GE',-1,'sbiancato ge su '||righe_fg||'record di fileguida e '||righe_ge||' da ana_ge - last_period '||last_period);

    EXCEPTION WHEN OTHERS THEN
    log_caricamenti(c_package||'.SVECCHIA_GE - DELETE',SQLCODE,SQLERRM||' - last_period '||last_period);
    rollback;
    END;
    END IF;
    return 1;
END;

FUNCTION LOAD_FULL_GRUPPO_LEGAME return number IS

cursor c_capoleg is
select distinct L.COD_SNDG_LEGAME sndg, L.COD_LEGAME tipo
from MCRE_OWN.T_MCRE0_APP_LEGAME24 l
where L.COD_LEGAME = 'TIT'
and L.ID_DPER = (select idper from MCRE_OWN.V_MCRE0_ULTIMA_ACQUISIZIONE
                 where cod_file = c_file_legame)
union
select distinct L.COD_SNDG sndg, L.COD_LEGAME tipo
from MCRE_OWN.T_MCRE0_APP_LEGAME24 l
where L.COD_LEGAME = 'FCM'
and L.ID_DPER = (select idper from MCRE_OWN.V_MCRE0_ULTIMA_ACQUISIZIONE
                 where cod_file = c_file_legame)

order by 1;

r_capoleg   c_capoleg%rowtype;

v_gruppolegame    varchar2(18);
step              number(10) :=0;
err_code number := -1;
err_msg  varchar2(1000):= '';


BEGIN

execute immediate 'truncate table MCRE_OWN.T_MCRE0_APP_GRUPPO_LEGAME';
commit;

/* per ogni 'capo' battezzo un gruppo, inserisco con fl_capo a 1 e cerco le altre righe*/

open c_capoleg;
loop
    fetch c_capoleg into r_capoleg;
    exit when c_capoleg%notfound;

    begin
    --genero un nuovo codice gruppolegame a partire dall'SNDG del capo
        step := step+1;
        v_gruppolegame := 'G'||lpad (r_capoleg.sndg,17,'0');


    --inserisco riga capolegame
    begin
        insert into MCRE_OWN.T_MCRE0_APP_GRUPPO_LEGAME (COD_SNDG, COD_GRUPPO_LEGAME, COD_LEGAME, FLG_CAPOLEGAME)
        values (r_capoleg.sndg, v_gruppolegame, r_capoleg.tipo, 1);
    exception when others then
       err_code := SQLCODE;
       err_msg  := SQLERRM;
       log_caricamenti(c_package||'.LOAD_FULL_GRUPPOLEGAME',err_code,err_msg||' C - tipo '||r_capoleg.tipo||' - sndg '||r_capoleg.sndg);

    end;

    --inserisco le righe slave legate al capolegame
        case
            when r_capoleg.tipo = 'TIT' then --titolare-ditta
            begin
                insert into MCRE_OWN.T_MCRE0_APP_GRUPPO_LEGAME
                (COD_SNDG, COD_GRUPPO_LEGAME, COD_LEGAME, FLG_CAPOLEGAME)
                (select L.COD_SNDG, v_gruppolegame, r_capoleg.tipo,0
                 from MCRE_OWN.T_MCRE0_APP_LEGAME24 l
                 where L.COD_SNDG_LEGAME = r_capoleg.sndg
                 --22.03 filtro solo app attiva
                 and L.ID_DPER = (select idper from MCRE_OWN.V_MCRE0_ULTIMA_ACQUISIZIONE
                 where cod_file = c_file_legame));
            exception when others then
                err_code := SQLCODE;
                err_msg  := SQLERRM;
                log_caricamenti(c_package||'.LOAD_FULL_GRUPPOLEGAME',err_code,err_msg||' - tipo '||r_capoleg.tipo||' - sndg '||r_capoleg.sndg);

            end;

            when r_capoleg.tipo = 'FCM' then --filiale-casa madre
            begin
                insert into MCRE_OWN.T_MCRE0_APP_GRUPPO_LEGAME
                (COD_SNDG, COD_GRUPPO_LEGAME, COD_LEGAME, FLG_CAPOLEGAME)
             (select L.COD_SNDG_LEGAME, v_gruppolegame, r_capoleg.tipo,0
              from MCRE_OWN.T_MCRE0_APP_LEGAME24 l
              where L.COD_SNDG = r_capoleg.sndg
              --22.03 filtro solo app attiva
              and L.ID_DPER = (select idper from MCRE_OWN.V_MCRE0_ULTIMA_ACQUISIZIONE
                 where cod_file = c_file_legame));
             exception when others then
                err_code := SQLCODE;
                err_msg  := SQLERRM;
                log_caricamenti(c_package||'.LOAD_FULL_GRUPPOLEGAME',err_code,err_msg||' - tipo '||r_capoleg.tipo||' - sndg '||r_capoleg.sndg);

            end;

            else log_caricamenti(c_package||'.LOAD_FULL_GRUPPOLEGAME',-1,'capolegame anomalo? '||r_capoleg.sndg);

         end case;

         commit;

    end;

end loop;
close c_capoleg;

return 1;


END;


END PKG_MCRE0_CARICA_GRUPPO_LEGAME;
/


CREATE SYNONYM MCRE_APP.PKG_MCRE0_CARICA_GRUPPO_LEGAME FOR MCRE_OWN.PKG_MCRE0_CARICA_GRUPPO_LEGAME;


CREATE SYNONYM MCRE_USR.PKG_MCRE0_CARICA_GRUPPO_LEGAME FOR MCRE_OWN.PKG_MCRE0_CARICA_GRUPPO_LEGAME;


GRANT EXECUTE, DEBUG ON MCRE_OWN.PKG_MCRE0_CARICA_GRUPPO_LEGAME TO MCRE_USR;

