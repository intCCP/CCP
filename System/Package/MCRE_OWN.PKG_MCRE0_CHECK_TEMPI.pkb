CREATE OR REPLACE PACKAGE BODY MCRE_OWN.pkg_mcre0_check_tempi
is

function add_column return number is
v_column_inizio varchar2(100);
v_column_durata varchar2(100);
v_column_fine varchar2(100);
i number;

begin

select seq_column.nextval
into i
from dual;

v_column_inizio:= 'ALTER TABLE T_MCRE0_CHECK_TEMPI
ADD (inizio_'|| i ||' VARCHAR2(20))' ;

execute immediate v_column_inizio;

v_column_durata:= 'ALTER TABLE T_MCRE0_CHECK_TEMPI
ADD (durata_'|| i ||' NUMBER)' ;

execute immediate v_column_durata;

v_column_fine:= 'ALTER TABLE T_MCRE0_CHECK_TEMPI
ADD (fine_'|| i ||' VARCHAR2(20))' ;

execute immediate v_column_fine;

return ok;

exception
when others
 then return ko;

end add_column;

procedure check_tempi(P_PID IN NUMBER, P_COD_CHECK IN VARCHAR2, P_ID_DPER DATE, P_RET_VALUE OUT NUMBER, P_RESULT OUT VARCHAR2, P_NOTES OUT VARCHAR2, P_OK VARCHAR2, P_KO VARCHAR2) is

    v_id_lotto number;
    v_soglia   number;
    RetVal     number;
    colnumber number;
    v_insert varchar2(100);

   BEGIN

   select  max(id_lotto)+1
        into    v_id_lotto
        from    MCRE_OWN.T_MCRE0_CHECK_TEMPI;

   -- Seleziono la soglia dalla tabella di configurazione
    v_soglia := MCRE_OWN.PKG_MCRE0_CHECK_ENGINE.GET_EXP_VALUE_THRESHOLD(P_COD_CHECK, 'CMP');

    select count(*) into v_primo_lotto from T_MCRE0_CHECK_TEMPI;

     IF v_primo_lotto = 0
     THEN
        -- inserisco nella tabella di controllo il numero di posizioni per istituto.
        insert into MCRE_OWN.T_MCRE0_CHECK_TEMPI
            (Descrizione, inizio, durata, fine, id_lotto)
            select  a.descrizione,a.inizio, a.durata, a.fine, nvl(v_id_lotto, 1)
            from(MCRE_OWN.V_MCRE0_CHECK_TEMPI) a;
     ELSE
          RetVal := MCRE_OWN.PKG_MCRE0_CHECK_TEMPI.ADD_COLUMN;
          select seq_column.currval
          into colnumber
          from dual;
        v_insert:='INSERT INTO MCRE_OWN.T_MCRE0_CHECK_TEMPI  (inizio_'||colnumber||',durata_'||colnumber||',fine_'||colnumber||')
               select  a.inizio, a.durata, a.fine
            from(MCRE_OWN.V_MCRE0_CHECK_TEMPI) a; ';
      execute immediate v_insert;

    select sum(ESITO) into p_ret_value
    from  MCRE_OWN.T_MCRE0_CHECK_TEMPI;
    end if;

    select  'Controllare TEMPI: '||dbms_lob.substr(wm_concat(case when esito<>0 then Descrizione end),1000, 1)  as messaggio
    into    p_notes
    from    T_MCRE0_CHECK_TEMPI;

    select case when p_ret_value = 0 then p_ok
           else p_ko end into P_RESULT
    from dual;

    commit;

   END check_tempi;

end;
/


CREATE SYNONYM MCRE_APP.PKG_MCRE0_CHECK_TEMPI FOR MCRE_OWN.PKG_MCRE0_CHECK_TEMPI;


CREATE SYNONYM MCRE_USR.PKG_MCRE0_CHECK_TEMPI FOR MCRE_OWN.PKG_MCRE0_CHECK_TEMPI;


GRANT EXECUTE, DEBUG ON MCRE_OWN.PKG_MCRE0_CHECK_TEMPI TO MCRE_USR;

