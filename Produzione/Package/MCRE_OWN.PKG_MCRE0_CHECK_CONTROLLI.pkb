CREATE OR REPLACE PACKAGE BODY MCRE_OWN.PKG_MCRE0_CHECK_CONTROLLI
AS
   /******************************************************************************
      NAME:       PKG_MCRE0_CONTROLLI
      PURPOSE:    Implementazione controlli automatici

      REVISIONS:
      Ver        Date        Author           Description
      --------  ----------  ---------------  ------------------------------------
      1.0       23/11/2012  Luca Ferretti   Created this package.
      1.1       28/11/2012  Luca Ferretti   Aggiunto calcolo media aggiornato.
      1.2       28/11/2012  Luca Ferretti   Aggiunta procedura CONTROLLO_POS_MACROSTATO
      1.3       29/11/2012  Luca Ferretti   Aggiunta procedura CONTROLLO_POS_STATO
      1.4       05/12/2012  Luca Ferretti   Aggiunto calcolo per controlli singoli
      1.5       10/12/2012  Luca Ferretti   Gestione caso in cui non arrivi un'informazione (ABI, COMPARTO, etc). Si setta -1 in fase di pulizia
   ******************************************************************************/

   PROCEDURE CONTROLLO_POS_MACROSTATO (P_PID IN NUMBER, P_COD_CHECK IN VARCHAR2, P_ID_DPER DATE, P_RET_VALUE OUT NUMBER, P_RESULT OUT VARCHAR2, P_NOTES OUT VARCHAR2, P_OK VARCHAR2, P_KO VARCHAR2)
   IS

    v_id_lotto number;
    v_soglia01   number;
    v_soglia02  number;

   BEGIN

   select  max(id_lotto)+1
        into    v_id_lotto
        from    MCRE_OWN.T_MCRE0_CHECK_POS_MACROSTATO;

   -- Seleziono la soglia dalla tabella di configurazione
    v_soglia01 := MCRE_OWN.PKG_MCRE0_CHECK_ENGINE.GET_EXP_VALUE_THRESHOLD(P_COD_CHECK, 'CMP01');
    v_soglia02 := MCRE_OWN.PKG_MCRE0_CHECK_ENGINE.GET_EXP_VALUE_THRESHOLD(P_COD_CHECK, 'CMP02');

    select count(*) into v_primo_lotto from T_MCRE0_CHECK_POS_MACROSTATO;

     IF v_primo_lotto = 0
     THEN
        -- inserisco nella tabella di controllo il numero di posizioni per istituto.
        insert into MCRE_OWN.T_MCRE0_CHECK_POS_MACROSTATO
            (MACROSTATO, POSIZIONI_DIREZIONE, POSIZIONI, MEDIA_DIREZIONE, MEDIA, id_lotto)
            select  a.MACROSTATO, a.POS_DIR, a.POS, a.POS_DIR, a.POS, nvl(v_id_lotto, 1)
            from(MCRE_OWN.V_MCRE0_CHECK_POS_MACROSTATO) a;
     ELSE
        MERGE INTO MCRE_OWN.T_MCRE0_CHECK_POS_MACROSTATO a
        USING (select  nvl(c.macrostato, v.macrostato) macrostato, nvl(c.POS_DIR, -1) pos_dir, nvl(c.POS, -1) pos, nvl(v_id_lotto, 1) as id_lotto_2,
                    case when (v.media_direzione>100 and abs(v.POSIZIONI_DIREZIONE-v.media_direzione) > v_soglia01*(v.media_direzione/100))
                        then 1
                        when (v.media_direzione<100 and abs(v.POSIZIONI_DIREZIONE-v.media_direzione) > v_soglia02*(v.media_direzione/100))
                        then 1
                        else 0 end as ESITO_DIR,
                    case when (v.media >100 and abs(v.POSIZIONI-v.media) > v_soglia01*(v.media/100) )
                        then 1
                       when (v.media <100 and abs(v.POSIZIONI-v.media) > v_soglia02*(v.media/100) )
                       then 1
                       else 0 end as ESITO
                from MCRE_OWN.V_MCRE0_CHECK_POS_MACROSTATO c, T_MCRE0_CHECK_POS_MACROSTATO v
                where c.macrostato(+) = v.macrostato) b
        ON (b.macrostato=a.macrostato)
        WHEN MATCHED
            THEN
                UPDATE
                set a.esito             = b.ESITO+b.ESITO_DIR,
                a.posizioni_direzione   = b.pos_dir,
                a.posizioni             = b.pos,
                a.id_lotto              = b.id_lotto_2,
                a.media_direzione       = ((media_direzione*(v_id_lotto-1)
                                            +(select b.pos_dir
                                                from MCRE_OWN.T_MCRE0_CHECK_POS_MACROSTATO c
                                                where 1=1 and c.macrostato=a.macrostato))/v_id_lotto),
                a.media                 = ((media*(v_id_lotto-1)
                                            +(select b.pos
                                                from MCRE_OWN.T_MCRE0_CHECK_POS_MACROSTATO c
                                                where 1=1 and c.macrostato=a.macrostato))/v_id_lotto)
        WHEN NOT MATCHED
            THEN
                insert
                (macrostato, posizioni_direzione, posizioni, media_direzione, media, id_lotto, esito)
                values
                (b.macrostato, b.pos_dir, b.pos, b.pos_dir, b.pos, v_id_lotto, 0);
     END IF;

    select sum(ESITO) into p_ret_value
    from  MCRE_OWN.T_MCRE0_CHECK_POS_MACROSTATO;

    select  'Controllare MACROSTATO: '||dbms_lob.substr(wm_concat(case when esito<>0 then MACROSTATO end),1000, 1)  as messaggio
    into    p_notes
    from    T_MCRE0_CHECK_POS_MACROSTATO;

    select case when p_ret_value = 0 then p_ok
           else p_ko end into P_RESULT
    from dual;

    commit;

   END CONTROLLO_POS_MACROSTATO;

   PROCEDURE CONTROLLO_POS_STATO (P_PID IN NUMBER, P_COD_CHECK IN VARCHAR2, P_ID_DPER DATE, P_RET_VALUE OUT NUMBER, P_RESULT OUT VARCHAR2, P_NOTES OUT VARCHAR2, P_OK VARCHAR2, P_KO VARCHAR2)
   IS

    v_id_lotto number;
    v_soglia01   number;
    v_soglia02  number;

   BEGIN

   select  max(id_lotto)+1
        into    v_id_lotto
        from    MCRE_OWN.T_MCRE0_CHECK_POS_STATO;

    -- Seleziono la soglia dalla tabella di configurazione
    v_soglia01 := MCRE_OWN.PKG_MCRE0_CHECK_ENGINE.GET_EXP_VALUE_THRESHOLD(P_COD_CHECK, 'CMP01');
    v_soglia02:= MCRE_OWN.PKG_MCRE0_CHECK_ENGINE.GET_EXP_VALUE_THRESHOLD(P_COD_CHECK, 'CMP02');

    select count(*) into v_primo_lotto from T_MCRE0_CHECK_POS_STATO;

    IF v_primo_lotto = 0
       THEN
        -- inserisco nella tabella di controllo il numero di posizioni per istituto.
        insert into MCRE_OWN.T_MCRE0_CHECK_POS_STATO
            (STATO, POSIZIONI_DIREZIONE, POSIZIONI, MEDIA_DIREZIONE, MEDIA, id_lotto)
            select  a.STATO, a.POS_DIR, a.POS, a.POS_DIR, a.POS, nvl(v_id_lotto, 1)
            from( V_MCRE0_CHECK_POS_STATO) a;
    ELSE
        MERGE INTO MCRE_OWN.T_MCRE0_CHECK_POS_STATO a
        USING   (select  nvl(c.stato, v.stato) stato, nvl(c.POS_DIR,1) pos_dir, nvl(c.POS,1) pos, nvl(v_id_lotto, 1) as id_lotto_2,
                    case when (v.media_direzione >100 and abs(c.POS_DIR-v.media_direzione) > v_soglia01*(v.media_direzione/100) )
                        then 1
                       when (v.media_direzione <100 and abs(c.POS_DIR-v.media_direzione) > v_soglia02*(v.media_direzione/100) )
                        then 1
                        else 0 end as ESITO_DIR,
                    case when (v.media >100 and abs(c.POS-v.media) > v_soglia01*(v.media/100) )
                        then 1
                        when (v.media <100 and abs(c.POS-v.media) > v_soglia02*(v.media/100) )
                        then 1
                        else 0 end as ESITO
                from MCRE_OWN.V_MCRE0_CHECK_POS_STATO c, T_MCRE0_CHECK_POS_STATO v
                where c.stato(+) = v.stato) b
        ON (a.STATO=b.STATO)
        WHEN MATCHED
        THEN
            UPDATE
            set a.esito                 = b.ESITO+b.ESITO_DIR,
                a.posizioni_direzione   = b.pos_dir,
                a.posizioni             = b.pos,
                a.id_lotto              = b.id_lotto_2,
                a.media_direzione       = ((media_direzione*(v_id_lotto-1)
                                            +(select b.pos_dir
                                                from MCRE_OWN.T_MCRE0_CHECK_POS_STATO c
                                                where 1=1 and c.stato=a.stato))/v_id_lotto),
                a.media                 = ((media*(v_id_lotto-1)
                                            +(select b.pos
                                                from MCRE_OWN.T_MCRE0_CHECK_POS_STATO c
                                                where 1=1 and c.stato=a.stato))/v_id_lotto)
        WHEN NOT MATCHED
        THEN
            insert (STATO, posizioni_direzione, posizioni, MEDIA_DIREZIONE, MEDIA, id_lotto, ESITO)
            values (b.STATO, b.pos_dir, b.pos, b.pos_dir, b.pos, v_id_lotto, 0);

       END IF;

        select sum(ESITO) into p_ret_value
        from  MCRE_OWN.T_MCRE0_CHECK_POS_STATO;

        select  'Controllare STATO: '||dbms_lob.substr(wm_concat(case when esito<>0 then STATO end),1000, 1)  as messaggio
        into    p_notes
        from    T_MCRE0_CHECK_POS_STATO;

        select case when p_ret_value = 0 then p_ok
               else p_ko end into P_RESULT
        from dual;

   END CONTROLLO_POS_STATO;

   PROCEDURE CONTROLLO_POS_PROCESSO   (P_PID IN NUMBER, P_COD_CHECK IN VARCHAR2, P_ID_DPER DATE, P_RET_VALUE OUT NUMBER, P_RESULT OUT VARCHAR2, P_NOTES OUT VARCHAR2, P_OK VARCHAR2, P_KO VARCHAR2)
   IS

    v_id_lotto number;
    v_soglia01   number;
    v_soglia02  number;

   BEGIN

    select  max(id_lotto)+1
        into    v_id_lotto
        from    MCRE_OWN.T_MCRE0_CHECK_POS_PROCESSO;

   -- Seleziono la soglia dalla tabella di configurazione
    v_soglia01 := MCRE_OWN.PKG_MCRE0_CHECK_ENGINE.GET_EXP_VALUE_THRESHOLD(P_COD_CHECK, 'CMP01');
    v_soglia02:= MCRE_OWN.PKG_MCRE0_CHECK_ENGINE.GET_EXP_VALUE_THRESHOLD(P_COD_CHECK, 'CMP02');

    select count(*) into v_primo_lotto from T_MCRE0_CHECK_POS_PROCESSO;

     IF v_primo_lotto = 0
       THEN
            -- inserisco nella tabella di controllo il numero di posizioni per istituto.
            insert into MCRE_OWN.T_MCRE0_CHECK_POS_PROCESSO
                    (PROCESSO, POSIZIONI_DIREZIONE, POSIZIONI, MEDIA_DIREZIONE, MEDIA, id_lotto)
                select  a.PROCESSO, a.POS_DIR, a.POS, a.POS_DIR, a.POS, nvl(v_id_lotto, 1)
                from( V_MCRE0_CHECK_POS_PROCESSO) a;
     ELSE
        MERGE INTO MCRE_OWN.T_MCRE0_CHECK_POS_PROCESSO a
        USING (select  nvl(c.processo, v.processo) processo, nvl(c.POS_DIR, -1) pos_dir, nvl(c.POS, -1) pos, nvl(v_id_lotto, 1) as id_lotto_2,
                    case when (v.media_direzione >100 and abs(c.POS_DIR-v.media_direzione) > v_soglia01*(v.media_direzione/100) )
                        then 1
                       when  (v.media_direzione <100 and abs(c.POS_DIR-v.media_direzione) > v_soglia02*(v.media_direzione/100) )
                       then 1
                       else 0 end as ESITO_DIR,
                    case when (v.media >100 and abs(c.POS-v.media) > v_soglia01*(v.media/100) )
                        then 1
                     when (v.media<100 and  abs(c.POS-v.media) > v_soglia02*(v.media/100) )
                     then 1
                       else 0 end as ESITO
                from MCRE_OWN.V_MCRE0_CHECK_POS_PROCESSO c, T_MCRE0_CHECK_POS_PROCESSO v
                where c.processo(+) = v.processo) b
        ON (b.processo=a.processo)
        WHEN MATCHED
            THEN
                UPDATE
                set a.esito             = b.ESITO+b.ESITO_DIR,
                a.posizioni_direzione   = b.pos_dir,
                a.posizioni             = b.pos,
                a.id_lotto              = b.id_lotto_2,
                a.media_direzione       = ((media_direzione*(v_id_lotto-1)
                                            +(select b.pos_dir
                                                from MCRE_OWN.T_MCRE0_CHECK_POS_PROCESSO c
                                                where 1=1 and c.processo=a.processo))/v_id_lotto),
                a.media                 = ((media*(v_id_lotto-1)
                                            +(select b.pos
                                                from MCRE_OWN.T_MCRE0_CHECK_POS_PROCESSO c
                                                where 1=1 and c.processo=a.processo))/v_id_lotto)
        WHEN NOT MATCHED
            THEN
                insert
                (processo, posizioni_direzione, posizioni, media_direzione, media, id_lotto, esito)
                values
                (b.processo, b.pos_dir, b.pos, b.pos_dir, b.pos, v_id_lotto, 0);
     END IF;

        select sum(ESITO) into p_ret_value
        from  MCRE_OWN.T_MCRE0_CHECK_POS_PROCESSO;

        select  'Controllare PROCESSO: '||dbms_lob.substr(wm_concat(case when esito<>0 then PROCESSO end),1000, 1)  as messaggio
        into    p_notes
        from    T_MCRE0_CHECK_POS_PROCESSO;

        select case when p_ret_value = 0 then p_ok
               else p_ko end into P_RESULT
        from dual;

        commit;

   END CONTROLLO_POS_PROCESSO;

   PROCEDURE CONTROLLO_POS_COMPARTO   (P_PID IN NUMBER, P_COD_CHECK IN VARCHAR2, P_ID_DPER DATE, P_RET_VALUE OUT NUMBER, P_RESULT OUT VARCHAR2, P_NOTES OUT VARCHAR2, P_OK VARCHAR2, P_KO VARCHAR2)
   IS

    v_id_lotto number;
    v_soglia01   number;
    v_soglia02  number;

   BEGIN

   select  max(id_lotto)+1
        into    v_id_lotto
        from    MCRE_OWN.T_MCRE0_CHECK_POS_COMPARTO;

   select  count(*) into v_primo_lotto from T_MCRE0_CHECK_POS_COMPARTO;

   -- Seleziono la soglia dalla tabella di configurazione
    v_soglia01 := MCRE_OWN.PKG_MCRE0_CHECK_ENGINE.GET_EXP_VALUE_THRESHOLD(P_COD_CHECK, 'CMP01');
    v_soglia02 := MCRE_OWN.PKG_MCRE0_CHECK_ENGINE.GET_EXP_VALUE_THRESHOLD(P_COD_CHECK, 'CMP02');

   IF v_primo_lotto = 0
    THEN
        -- inserisco nella tabella di controllo il numero di posizioni per istituto.
        insert into MCRE_OWN.T_MCRE0_CHECK_POS_COMPARTO (COMPARTO, POSIZIONI, MEDIA, id_lotto)
            select  a.COMPARTO, a.POS, a.POS, nvl(v_id_lotto, 1)
            from( MCRE_OWN.V_MCRE0_CHECK_POS_COMPARTO) a;
   ELSE
        MERGE INTO MCRE_OWN.T_MCRE0_CHECK_POS_COMPARTO a
        USING ( select  nvl(c.comparto, v.comparto) comparto, nvl(c.POS,-1) POSIZIONI, nvl(v_id_lotto, 1) as id_lotto_2,
                    case when (v.media>100 and abs(c.POS-v.media) > v_soglia01*(v.media/100) )
                        then 1
                      when (v.media<100 and abs(c.POS-v.media) > v_soglia02*(v.media/100) )
                      then 1
                      else 0 end as ESITO
                from MCRE_OWN.V_MCRE0_CHECK_POS_COMPARTO c, T_MCRE0_CHECK_POS_COMPARTO v
                where c.comparto(+) = v.comparto) b
        on ( b.comparto = a.comparto )
        WHEN MATCHED
            THEN
                UPDATE
                set a.posizioni = b.posizioni,
                    a.media     = ((POSIZIONI*(v_id_lotto-1)+(select b.posizioni
                                                    from MCRE_OWN.T_MCRE0_CHECK_POS_COMPARTO c
                                                    where 1=1 and c.COMPARTO=a.COMPARTO))/v_id_lotto),
                    a.id_lotto  = b.id_lotto_2,
                    a.esito     = b.esito
        WHEN NOT MATCHED
            THEN
                insert (COMPARTO, posizioni, media, id_lotto, esito)
                values (b.COMPARTO, b.POSIZIONI, b.POSIZIONI, v_id_lotto, 0);
    END IF;

    select sum(ESITO) into p_ret_value
    from  MCRE_OWN.T_MCRE0_CHECK_POS_COMPARTO;

    select  'Controllare COMPARTO: '||dbms_lob.substr(wm_concat(case when esito<>0 then COMPARTO end),1000, 1)  as messaggio
    into    p_notes
    from    T_MCRE0_CHECK_POS_COMPARTO;

    select case when p_ret_value = 0 then p_ok
           else p_ko end into P_RESULT
    from dual;

    commit;

   END CONTROLLO_POS_COMPARTO;


   PROCEDURE CONTROLLO_POS_ISTITUTO (P_PID IN NUMBER, P_COD_CHECK IN VARCHAR2, P_ID_DPER DATE, P_RET_VALUE OUT NUMBER, P_RESULT OUT VARCHAR2, P_NOTES OUT VARCHAR2, P_OK VARCHAR2, P_KO VARCHAR2)
   IS

    v_id_lotto number;
    v_soglia01   number;
   v_soglia02   number;

   BEGIN

   select  max(id_lotto)+1
        into    v_id_lotto
        from    MCRE_OWN.T_MCRE0_CHECK_POS_ISTITUTO;

   select count(*) into v_primo_lotto from T_MCRE0_CHECK_POS_ISTITUTO;

   -- Seleziono la soglia dalla tabella di configurazione
    v_soglia01 := MCRE_OWN.PKG_MCRE0_CHECK_ENGINE.GET_EXP_VALUE_THRESHOLD(P_COD_CHECK, 'CMP01');
    v_soglia02 := MCRE_OWN.PKG_MCRE0_CHECK_ENGINE.GET_EXP_VALUE_THRESHOLD(P_COD_CHECK, 'CMP02');

   IF v_primo_lotto = 0
       THEN
        insert into T_MCRE0_CHECK_POS_ISTITUTO
        (abi, posizioni_direzione, posizioni, media_direzione, media, id_lotto, esito)
        select  ABI, POS_DIR, POS, POS_DIR, POS, nvl(v_id_lotto, 1) as id_lotto, 0
                from MCRE_OWN.V_MCRE0_CHECK_POS_ISTITUTO;
   ELSE
       merge into T_MCRE0_CHECK_POS_ISTITUTO a
       using (select  nvl(c.ABI, v.abi) abi, nvl(c.POS_DIR,-1) pos_dir, nvl(c.POS, -1) pos, nvl(v_id_lotto, 1) as id_lotto_2,
                    case when (v.media_direzione >100 and abs(c.POS_DIR-v.media_direzione) > v_soglia01*(v.media_direzione/100) )
                        then 1
                        when (v.media_direzione <100 and abs(c.POS_DIR-v.media_direzione) > v_soglia02*(v.media_direzione/100) )
                        then 1
                        else 0 end as ESITO_DIR,
                    case when (v.media > 100 and  abs(c.POS-v.media) > v_soglia01*(v.media/100) )
                        then 1
                    when (v.media < 100 and  abs(c.POS-v.media) > v_soglia02*(v.media/100) )
                     then 1
                     else 0 end as ESITO
                from MCRE_OWN.V_MCRE0_CHECK_POS_ISTITUTO c, T_MCRE0_CHECK_POS_ISTITUTO v
                where c.abi(+) = v.abi) b
        on (b.abi=a.abi)
       WHEN MATCHED
        THEN
            UPDATE
            set a.esito                 = b.ESITO+b.ESITO_DIR,
                a.posizioni_direzione   = b.pos_dir,
                a.posizioni             = b.pos,
                a.id_lotto              = b.id_lotto_2,
                a.media_direzione       = ((media_direzione*(v_id_lotto-1)
                                            +(select b.pos_dir
                                                from MCRE_OWN.T_MCRE0_CHECK_POS_ISTITUTO b
                                                where 1=1 and b.abi=a.abi))/v_id_lotto),
                a.media                 = ((media*(v_id_lotto-1)
                                            +(select b.pos
                                                from MCRE_OWN.T_MCRE0_CHECK_POS_ISTITUTO b
                                                where 1=1 and b.abi=a.abi))/v_id_lotto)
       WHEN NOT MATCHED
        THEN
            insert
            (abi, posizioni_direzione, posizioni, media_direzione, media, id_lotto, esito)
            values
            (b.abi, b.pos_dir, b.pos, b.pos_dir, b.pos, v_id_lotto, 0);
   END IF;

        select sum(ESITO) into p_ret_value
        from  MCRE_OWN.T_MCRE0_CHECK_POS_ISTITUTO;

        select  'Controllare ABI: '||dbms_lob.substr(wm_concat(case when esito<>0 then ABI end),1000, 1)  as messaggio
        into    p_notes
        from    T_MCRE0_CHECK_POS_ISTITUTO;

        select case when p_ret_value = 0 then p_ok
               else p_ko end into P_RESULT
        from dual;

        commit;

   END CONTROLLO_POS_ISTITUTO;

   PROCEDURE CONTROLLO_POS_EXACT (P_PID IN NUMBER, P_COD_CHECK IN VARCHAR2, P_ID_DPER DATE, P_RET_VALUE OUT NUMBER, P_RESULT OUT VARCHAR2, P_NOTES OUT VARCHAR2, P_OK VARCHAR2, P_KO VARCHAR2)
   IS

    v_id_lotto number;
    v_soglia01   number;
    v_soglia02 number;

   BEGIN

   select  max(id_lotto)+1
        into    v_id_lotto
        from    MCRE_OWN.T_MCRE0_CHECK_POS_EXACT;

   select count(*) into v_primo_lotto from T_MCRE0_CHECK_POS_EXACT;

   -- Seleziono la soglia dalla tabella di configurazione
    v_soglia01 := MCRE_OWN.PKG_MCRE0_CHECK_ENGINE.GET_EXP_VALUE_THRESHOLD(P_COD_CHECK, 'CMP01');
    v_soglia02 := MCRE_OWN.PKG_MCRE0_CHECK_ENGINE.GET_EXP_VALUE_THRESHOLD(P_COD_CHECK, 'CMP02');

   IF v_primo_lotto = 0
       THEN
        insert into T_MCRE0_CHECK_POS_EXACT
        (controllo, numero, media, id_lotto, esito)
        select  controllo, POS, POS, nvl(v_id_lotto, 1) as id_lotto, 0
                from MCRE_OWN.V_MCRE0_CHECK_POS_EXACT;
   ELSE
       merge into T_MCRE0_CHECK_POS_EXACT a
       using (select  nvl(c.controllo, v.controllo) controllo, nvl(c.pos, -1) as numero, nvl(v_id_lotto, 1) as id_lotto_2,
                    case when (v.media>100 and abs(c.pos-v.media) > v_soglia01*(v.media/100) )
                        then 1
                     when (v.media<100 and abs(c.pos-v.media) > v_soglia02*(v.media/100) )
                     then 1
                      else 0 end as ESITO
                from MCRE_OWN.V_MCRE0_CHECK_POS_EXACT c, T_MCRE0_CHECK_POS_EXACT v
                where c.controllo(+) = v.controllo) b
        on (b.controllo=a.controllo)
       WHEN MATCHED
        THEN
            UPDATE
            set a.esito                 = b.ESITO,
                a.numero                = b.numero,
                a.id_lotto              = b.id_lotto_2,
                a.media                 = ((media*(v_id_lotto-1)
                                            +(select b.numero
                                                from MCRE_OWN.T_MCRE0_CHECK_POS_EXACT c
                                                where 1=1 and c.controllo=a.controllo))/v_id_lotto)
       WHEN NOT MATCHED
        THEN
            insert
            (controllo, numero, media, id_lotto, esito)
            values
            (b.controllo, b.numero, b.numero, v_id_lotto, 0);
   END IF;

        select sum(ESITO) into p_ret_value
        from  MCRE_OWN.T_MCRE0_CHECK_POS_EXACT;

        select  'Controllare : '||dbms_lob.substr(wm_concat(case when esito<>0 then CONTROLLO end),1000, 1)  as messaggio
        into    p_notes
        from    T_MCRE0_CHECK_POS_EXACT;

        select case when p_ret_value = 0 then p_ok
               else p_ko end into P_RESULT
        from dual;

        commit;

   END CONTROLLO_POS_EXACT;

   PROCEDURE CONTROLLO_POS_ALERT (P_PID IN NUMBER, P_COD_CHECK IN VARCHAR2, P_ID_DPER DATE, P_RET_VALUE OUT NUMBER, P_RESULT OUT VARCHAR2, P_NOTES OUT VARCHAR2, P_OK VARCHAR2, P_KO VARCHAR2)
   IS

    v_id_lotto number;
    v_soglia01   number;
    v_soglia02  number;

   BEGIN

   select  max(id_lotto)+1
        into    v_id_lotto
        from    MCRE_OWN.T_MCRE0_CHECK_POS_ALERT;

   select count(*) into v_primo_lotto from T_MCRE0_CHECK_POS_ALERT;

   -- Seleziono la soglia dalla tabella di configurazione
    v_soglia01 := MCRE_OWN.PKG_MCRE0_CHECK_ENGINE.GET_EXP_VALUE_THRESHOLD(P_COD_CHECK, 'CMP01');
    v_soglia02 := MCRE_OWN.PKG_MCRE0_CHECK_ENGINE.GET_EXP_VALUE_THRESHOLD(P_COD_CHECK, 'CMP02');

   IF v_primo_lotto = 0
       THEN
        insert into T_MCRE0_CHECK_POS_ALERT
        (alert, numero, media, id_lotto, esito)
        select  alert, POS, POS, nvl(v_id_lotto, 1) as id_lotto, 0
                from MCRE_OWN.V_MCRE0_CHECK_POS_ALERT;
   ELSE
       merge into T_MCRE0_CHECK_POS_ALERT a
       using (select  nvl(c.alert, v.alert) alert, nvl(c.pos,-1) as numero, nvl(v_id_lotto, 1) as id_lotto_2,
                    case when ( v.media<100 and abs(c.pos-v.media) > v_soglia02*(v.media/100) )
                        then 1
                    when ( v.media>100 and abs(c.pos-v.media) > v_soglia01*(v.media/100) )
                        then 1
                        else 0 end as ESITO
                from MCRE_OWN.V_MCRE0_CHECK_POS_ALERT c, T_MCRE0_CHECK_POS_ALERT v
                where c.alert(+) = v.alert) b
        on (b.alert=a.alert)
       WHEN MATCHED
        THEN
            UPDATE
            set a.esito                 = b.ESITO,
                a.numero                = b.numero,
                a.id_lotto              = b.id_lotto_2,
                a.media                 = ((media*(v_id_lotto-1)
                                            +(select b.numero
                                                from MCRE_OWN.T_MCRE0_CHECK_POS_ALERT c
                                                where 1=1 and c.alert=a.alert))/v_id_lotto)
       WHEN NOT MATCHED
        THEN
            insert
            (alert, numero, media, id_lotto, esito)
            values
            (b.alert, b.numero, b.numero, v_id_lotto, 0);
   END IF;

        select sum(ESITO) into p_ret_value
        from  MCRE_OWN.T_MCRE0_CHECK_POS_ALERT;

        select  'Controllare Alert: '||dbms_lob.substr(wm_concat(case when esito<>0 then ALERT end),1000, 1)  as messaggio
        into    p_notes
        from    T_MCRE0_CHECK_POS_ALERT;

        select case when p_ret_value = 0 then p_ok
               else p_ko end into P_RESULT
        from dual;

        commit;

   END CONTROLLO_POS_ALERT;

   PROCEDURE CONTROLLO_LOG_ETL (P_PID IN NUMBER, P_COD_CHECK IN VARCHAR2, P_ID_DPER DATE, P_RET_VALUE OUT NUMBER, P_RESULT OUT VARCHAR2, P_NOTES OUT VARCHAR2, P_OK VARCHAR2, P_KO VARCHAR2)
   IS

    v_id_lotto number;
    v_soglia   number;

   BEGIN

       delete T_MCRE0_CHECK_LOG_ETL;
       insert into T_MCRE0_CHECK_LOG_ETL
       select   id, procedura, livello, sql_code, message, note, dta_ins
       from     V_MCRE0_CHECK_LOG_ETL;

       commit;

       select   count(*) into p_ret_value
       from     T_MCRE0_CHECK_LOG_ETL;

        select  'Controllare LOG ETL: '||dbms_lob.substr(wm_concat(case when p_ret_value!=0 then PROCEDURA end),1000, 1)  as messaggio
        into    p_notes
        from    T_MCRE0_CHECK_LOG_ETL;

        select case when p_ret_value = 0 then p_ok
               else p_ko end into P_RESULT
        from dual;

        commit;

   END CONTROLLO_LOG_ETL;


      PROCEDURE CONTROLLO_UTENTE (P_PID IN NUMBER, P_COD_CHECK IN VARCHAR2, P_ID_DPER DATE, P_RET_VALUE OUT NUMBER, P_RESULT OUT VARCHAR2, P_NOTES OUT VARCHAR2, P_OK VARCHAR2, P_KO VARCHAR2)
   IS

    v_id_lotto number;
    v_soglia01   number;
    v_soglia02  number;

   BEGIN

        select  max(id_lotto)+1
        into    v_id_lotto
        from    MCRE_OWN.T_MCRE0_CHECK_UTENTE;

   select count(*) into v_primo_lotto from T_MCRE0_CHECK_UTENTE;

   -- Seleziono la soglia dalla tabella di configurazione
    v_soglia01 := MCRE_OWN.PKG_MCRE0_CHECK_ENGINE.GET_EXP_VALUE_THRESHOLD(P_COD_CHECK, 'CMP01');
    v_soglia02 := MCRE_OWN.PKG_MCRE0_CHECK_ENGINE.GET_EXP_VALUE_THRESHOLD(P_COD_CHECK, 'CMP02');

   IF v_primo_lotto = 0
       THEN
        insert into T_MCRE0_CHECK_UTENTE
        (cod_matricola, cognome,nome, posizioni_direzione, media, id_lotto, esito)
        select  cod_matricola, cognome, nome,posizioni_direzione, posizioni_direzione, nvl(v_id_lotto, 1) as id_lotto, 0
                from MCRE_OWN.V_MCRE0_CHECK_UTENTI;
   ELSE
       merge into T_MCRE0_CHECK_UTENTE a
                      using (select  nvl(c.cod_matricola, v.cod_matricola) cod_matricola, c.cognome, c.nome, nvl(c.posizioni_direzione,-1) as posizioni_direzione, nvl(v_id_lotto, 1) as id_lotto_2,
                    case when ( v.media<100 and abs(c.posizioni_direzione-v.media) > v_soglia02*(v.media/100) )
                        then 1
                    when ( v.media>100 and abs(c.posizioni_direzione-v.media) > v_soglia01*(v.media/100) )
                        then 1
                        else 0 end as ESITO
                from MCRE_OWN.V_MCRE0_CHECK_UTENTI c, T_MCRE0_CHECK_UTENTE v
                where c.cod_matricola(+) = v.cod_matricola) b
        on (b.cod_matricola=a.cod_matricola)
       WHEN MATCHED
        THEN
            UPDATE
            set a.esito                 = b.ESITO,
                a.posizioni_direzione                = b.posizioni_direzione,
                a.id_lotto              = b.id_lotto_2,
                a.media                 = ((media*(v_id_lotto-1)
                                            +(select b.posizioni_direzione
                                                from MCRE_OWN.T_MCRE0_CHECK_UTENTE c
                                                where 1=1 and c.cod_matricola=a.cod_matricola))/v_id_lotto)
       WHEN NOT MATCHED
        THEN
            insert
            (cod_matricola, cognome, nome, posizioni_direzione, media, id_lotto, esito)
            values
            (b.cod_matricola, b.cognome, b.nome, b.posizioni_direzione, b.posizioni_direzione, v_id_lotto, 0);
   END IF;

        select sum(ESITO) into p_ret_value
        from  MCRE_OWN.T_MCRE0_CHECK_UTENTE;

        select  'Controllare Utente: '||dbms_lob.substr(wm_concat(case when esito<>0 then COD_MATRICOLA end),1000, 1)  as messaggio
        into    p_notes
        from    T_MCRE0_CHECK_UTENTE;

        select case when p_ret_value = 0 then p_ok
               else p_ko end into P_RESULT
        from dual;

        commit;


   END CONTROLLO_UTENTE;

END PKG_MCRE0_CHECK_CONTROLLI;
/


CREATE SYNONYM MCRE_APP.PKG_MCRE0_CHECK_CONTROLLI FOR MCRE_OWN.PKG_MCRE0_CHECK_CONTROLLI;


CREATE SYNONYM MCRE_USR.PKG_MCRE0_CHECK_CONTROLLI FOR MCRE_OWN.PKG_MCRE0_CHECK_CONTROLLI;


GRANT EXECUTE, DEBUG ON MCRE_OWN.PKG_MCRE0_CHECK_CONTROLLI TO MCRE_USR;

