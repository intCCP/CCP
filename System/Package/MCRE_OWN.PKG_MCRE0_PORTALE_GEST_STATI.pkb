CREATE OR REPLACE PACKAGE BODY MCRE_OWN.pkg_mcre0_portale_gest_stati AS
  /******************************************************************************
     NAME:     PKG_MCRE0_PORTALE_GESTIONE_STATI
     PURPOSE: Gestione stati da portale

     REVISIONS:
     Ver        Date        Author             Description
     ---------  ----------  -----------------  ------------------------------------
     1.0        25/01/2011  Galli Valeria      Created this package.
     2.0        09/03/2011  Galli Valeria      fnc_pt_avanzamento.
     3.0        01/04/2011  Galli Valeria      Gestito No_Data_Found in Anomalie
     3.1        08/04/2011  Galli Valeria      esito inizializzato a ok
     4.0        12/04/2011  Galli Valeria      gestione proroghe
     4.1        25/04/2011  Galli Valeria      Storicizzazione proroghe vecchie
     4.2        26/05/2011  Galli Valeria      Nuova gestione LOG
     4.3        30/05/2011  Galli Valeria      RIO azioni check gruppo
     4.4        30/06/2011  Murro Marco        Rimuovi record dopo 2gg dal cambio stato(ISPCPP-811)
     4.5        01/07/2011  Murro Marco        Svecchiamneto tab GB (365gg)
     5.0        03/08/2011  Murro Marco        Tuning - v_upd_fields
     6.0        21/05/2012  Murro Marco        Fix scadenza proroga e num proroghe
     7.0        06/06/2012   V.Galli           Commenti con label:   VG - CIB/BDT - INIZIO
     8.0        13/09/2012  d'errico           modificata logica di rimozione azioni in fnc_delete_rio_set
     8.1        20/09/2012   V.Galli           Delete Advisor ( Commenti con label:   VG - CIB/BDT - INIZIO )
     8.2        01/10/2012   V.Galli           Delete_RIO_Sett: trasformazione da cancellazione fisica a logica
     8.3        24/10/2012  Murro Marco        num proroghe+1 anche su Rifiuto
     8.4        24/10/2012  Murro Marco        tolto controllo data servizio se non direzione
     8.5        03/12/2012  Murro Marco        rafforzato controllo su delete PT e fix delete RIO
     8.6        07/01/2013  Murro Marco        rafforzato controllo su delete delete RIO (flg_delete = 0)
     8.7        15/01/2013  Murro Marco        aggiunta pulizia proroghe in attesa dopo cambio stato
     8.8        21/01/2013  Federico Galletti  mofiificato il cursore c_rio_proroghe
     8.9        04/04/2013  Murro Marco        gestione proroghe Divisione
     9.0.1      03/05/2013  Murro Marco        fix gestione flg_storico su nuova/conferma proroga
     9.1        03/07/2013  Murro Marco        nuova fix gestione flg_storico su nuova/conferma proroga
     9.2        20/08/2013  Murro Marco        nuova gestione Proroghe Incagli --fix 13/9
    *****************************************************************************/

  FUNCTION fnc_pt_avanzamento(p_cod_log t_mcre0_wrk_audit_etl.id%TYPE DEFAULT NULL)
    RETURN NUMBER IS

    v_cod_log t_mcre0_wrk_audit_etl.id%TYPE;

  BEGIN

    IF (p_cod_log IS NULL)
    THEN
      SELECT seq_mcr0_log_etl.nextval INTO v_cod_log FROM dual;
    ELSE
      v_cod_log := p_cod_log;
    END IF;

    UPDATE t_mcre0_app_pt_gestione_tavoli
       SET flg_workflow = 2
     WHERE (cod_abi_cartolarizzato, cod_ndg) IN
           (SELECT p.cod_abi_cartolarizzato,
                   p.cod_ndg
              FROM t_mcre0_app_pt_gestione_tavoli p
             WHERE p.flg_workflow < 2
               AND dta_deadline_ins_parere_area < SYSDATE);
    COMMIT;

    RETURN ok;

  EXCEPTION
    WHEN OTHERS THEN
      pkg_mcre0_audit.log_etl(v_cod_log,
                              'PKG_MCRE0_PORTALE_GEST_STATI.FNC_PT_AVANZAMENTO',
                              pkg_mcre0_audit.c_error,
                              SQLCODE,
                              SQLERRM,
                              'UPDATE T_MCRE0_APP_PT_GESTIONE_TAVOLI');
      RETURN ko;
  END;

  FUNCTION fnc_delete_pt_sett(p_cod_abi t_mcre0_app_pt_gestione_tavoli.cod_abi_cartolarizzato%TYPE,
                              p_cod_ndg t_mcre0_app_pt_gestione_tavoli.cod_ndg%TYPE,
                              p_cod_log t_mcre0_wrk_audit_etl.id%TYPE DEFAULT NULL)
    RETURN NUMBER IS

    v_cod_log t_mcre0_wrk_audit_etl.id%TYPE;
    v_note varchar2(1000);

  BEGIN

    IF (p_cod_log IS NULL)
    THEN
      SELECT seq_mcr0_log_etl.nextval INTO v_cod_log FROM dual;
    ELSE
      v_cod_log := p_cod_log;
    END IF;

    v_note := 'Delete gest_tav - ABI=' ||p_cod_abi||' NDG='||p_cod_ndg;
    DELETE FROM t_mcre0_app_pt_gestione_tavoli
     WHERE cod_abi_cartolarizzato = p_cod_abi
       AND cod_ndg = p_cod_ndg;

    --------------------   VG - CIB/BDT - INIZIO --------------------
    v_note := 'Delete comunic - ABI=' ||p_cod_abi||' NDG='||p_cod_ndg;
    DELETE FROM t_mcre0_app_pt_comunicazioni
     WHERE cod_abi_cartolarizzato = p_cod_abi
       AND cod_ndg = p_cod_ndg;
    --------------------   VG - CIB/BDT - FINE --------------------

    commit;

    RETURN ok;
  EXCEPTION
    WHEN OTHERS THEN
      pkg_mcre0_audit.log_etl(v_cod_log,
                              'PKG_MCRE0_PORTALE_GEST_STATI.FNC_DELETE_PT_SETT',
                              pkg_mcre0_audit.c_error,
                              SQLCODE,
                              SQLERRM,
                              v_note);
      RETURN ko;
  END;

  FUNCTION fnc_delete_pt(p_cod_log t_mcre0_wrk_audit_etl.id%TYPE DEFAULT NULL)
    RETURN NUMBER IS

    v_cod_log t_mcre0_wrk_audit_etl.id%TYPE;
    CURSOR c_pt IS --v8.5 aggiunto controllo per rilevare i pt con record antecedenti alla decorrenza stato
      SELECT cod_abi_cartolarizzato,cod_ndg from (
      SELECT cod_abi_cartolarizzato,cod_ndg
        FROM v_mcre0_app_upd_fields_p1 x --v5.0
       WHERE cod_macrostato != 'PT'
            --v4.4
         AND trunc(SYSDATE) - trunc(dta_decorrenza_stato) > 2
            --v4.4
         AND (EXISTS
              (SELECT DISTINCT 1
                 FROM t_mcre0_app_pt_gestione_tavoli g
                WHERE g.cod_abi_cartolarizzato = x.cod_abi_cartolarizzato
                  AND g.cod_ndg = x.cod_ndg))
         UNION
       select p.cod_abi_cartolarizzato, p.cod_ndg
         from t_mcre0_app_all_data a, T_MCRE0_APP_PT_GESTIONE_TAVOLI p
        where a.cod_abi_cartolarizzato = p.cod_abi_cartolarizzato
          and a.cod_ndg = p.cod_ndg
          and a.today_flg = '1' and a.cod_stato = 'PT'
          and dta_decorrenza_stato > p.dta_ins );
    v_esito NUMBER := ok;
  BEGIN

    IF (p_cod_log IS NULL)
    THEN
      SELECT seq_mcr0_log_etl.nextval INTO v_cod_log FROM dual;
    ELSE
      v_cod_log := p_cod_log;
    END IF;

    FOR rec_pt IN c_pt
    LOOP
      v_esito := v_esito * fnc_delete_pt_sett(rec_pt.cod_abi_cartolarizzato,
                                              rec_pt.cod_ndg,
                                              v_cod_log);
    END LOOP;
    RETURN v_esito;
  EXCEPTION
    WHEN OTHERS THEN
      pkg_mcre0_audit.log_etl(v_cod_log,
                              'PKG_MCRE0_PORTALE_GEST_STATI.FNC_DELETE_PT',
                              pkg_mcre0_audit.c_error,
                              SQLCODE,
                              SQLERRM,
                              'GENERALE');
      RETURN ko;
  END;

    ----13 sep 2012: modificata logica di pulizia delle azioni su un RIO post-cambio stato
    ----funzione che ripulisce le azioni internamente al GE della posizione che esc da RIO solo se
    ----all'interno del GE NON esistono altre posizioni in RIO
  FUNCTION fnc_delete_rio_sett(p_cod_abi      t_mcre0_app_pt_gestione_tavoli.cod_abi_cartolarizzato%TYPE,
                               p_cod_ndg      t_mcre0_app_pt_gestione_tavoli.cod_ndg%TYPE,
                               p_flg_proroghe NUMBER,
                               p_cod_log      t_mcre0_wrk_audit_etl.id%TYPE DEFAULT NULL)
    RETURN NUMBER IS

    v_cod_log              t_mcre0_wrk_audit_etl.id%TYPE;
    v_esecuzione           VARCHAR2(30);
    v_cod_gruppo_economico v_mcre0_app_rio_anomalie.cod_gruppo_economico%TYPE;

  BEGIN

    IF (p_cod_log IS NULL)
    THEN
      SELECT seq_mcr0_log_etl.nextval INTO v_cod_log FROM dual;
    ELSE
      v_cod_log := p_cod_log;
    END IF;

    IF (p_flg_proroghe = 0)
    THEN

      v_esecuzione := 'T_MCRE0_APP_RIO_GESTIONE';
      --DELETE FROM t_mcre0_app_rio_gestione
       update t_mcre0_app_rio_gestione
       set flg_delete = 1, dta_delete = sysdate
       WHERE cod_abi_cartolarizzato = p_cod_abi
         AND cod_ndg = p_cod_ndg;

      --------------------   VG - CIB/BDT - INIZIO --------------------
      v_esecuzione := 'T_MCRE0_APP_RIO_ADVISOR';
--      DELETE FROM t_mcre0_app_rio_advisor
       update t_mcre0_app_rio_advisor
       set flg_delete = 1, dta_delete = sysdate
      WHERE cod_abi_cartolarizzato = p_cod_abi
      AND cod_ndg = p_cod_ndg;

      v_esecuzione := 'T_MCRE0_APP_RIO_PDF';
       update t_mcre0_app_rio_pdf
       set flg_delete = 1, dta_delete = sysdate
      WHERE cod_abi_cartolarizzato = p_cod_abi
      AND cod_ndg = p_cod_ndg;
     --------------------   VG - CIB/BDT - FINE --------------------

      v_esecuzione := 'V_MCRE0_APP_UPD_FIELDS';
      BEGIN
        SELECT DISTINCT a.cod_gruppo_economico
          INTO v_cod_gruppo_economico
          FROM v_mcre0_app_upd_fields_p1 a --v5.0
         WHERE a.cod_abi_cartolarizzato = p_cod_abi
           AND a.cod_ndg = p_cod_ndg;
      EXCEPTION
        WHEN no_data_found THEN
          NULL;
        WHEN OTHERS THEN
          pkg_mcre0_audit.log_etl(v_cod_log,
                                  'PKG_MCRE0_PORTALE_GEST_STATI.FNC_DELETE_RIO_SETT',
                                  pkg_mcre0_audit.c_error,
                                  SQLCODE,
                                  SQLERRM,
                                  'SELECT ' || v_esecuzione || ' - ABI=' ||
                                  p_cod_abi || ' NDG=' || p_cod_ndg);
          RETURN ko;
      END;

      v_esecuzione := 'T_MCRE0_APP_RIO_AZIONI';
--      DELETE FROM t_mcre0_app_rio_azioni
        update t_mcre0_app_rio_azioni
       set flg_delete = 1, dta_delete = sysdate
       WHERE cod_abi_cartolarizzato = p_cod_abi
         AND cod_ndg = p_cod_ndg
         AND NOT EXISTS
       (SELECT DISTINCT 1
                --FROM v_mcre0_app_rio_azioni g
               FROM t_mcre0_app_rio_gestione g,
                                  v_mcre0_app_upd_fields_p1 u
                             WHERE g.cod_abi_cartolarizzato = u.cod_abi_cartolarizzato
                 AND g.cod_ndg = u.cod_ndg
                               AND u.cod_gruppo_economico = v_cod_gruppo_economico
                 AND u.cod_macrostato = 'RIO'
                 and g.flg_delete = 0);/*
                 AND (g.cod_abi_cartolarizzato, g.cod_ndg) NOT IN
                     (SELECT g2.cod_abi_cartolarizzato,
                             g2.cod_ndg
                        FROM v_mcre0_app_upd_fields_p1 g2 --v5.0
                       WHERE cod_abi_cartolarizzato = p_cod_abi
                         AND cod_ndg = p_cod_ndg));*/

      v_esecuzione := 'T_MCRE0_APP_RIO_ANOMALIE';
      BEGIN
        SELECT DISTINCT a.cod_gruppo_economico
          INTO v_cod_gruppo_economico
          FROM v_mcre0_app_rio_anomalie a
         WHERE a.cod_abi_cartolarizzato = p_cod_abi
           AND a.cod_ndg = p_cod_ndg;
      EXCEPTION
        WHEN no_data_found THEN
          NULL;
        WHEN OTHERS THEN
          pkg_mcre0_audit.log_etl(v_cod_log,
                                  'PKG_MCRE0_PORTALE_GEST_STATI.FNC_DELETE_RIO_SETT',
                                  pkg_mcre0_audit.c_error,
                                  SQLCODE,
                                  SQLERRM,
                                  'SELECT ' || v_esecuzione || ' - ABI=' ||
                                  p_cod_abi || ' NDG=' || p_cod_ndg);
          RETURN ko;
      END;

--      DELETE FROM t_mcre0_app_rio_anomalie
        update t_mcre0_app_rio_anomalie
       set flg_delete = 1, dta_delete = sysdate
       WHERE cod_abi_cartolarizzato = p_cod_abi
         AND cod_ndg = p_cod_ndg
         AND (flg_singolo_cliente = 'S' OR
             (flg_singolo_cliente = 'G' AND NOT EXISTS
              (SELECT DISTINCT 1
                  FROM v_mcre0_app_rio_anomalie g
                 WHERE g.cod_gruppo_economico = v_cod_gruppo_economico
                   AND g.cod_macrostato = 'RIO')));
    ELSIF (p_flg_proroghe = 1)
    THEN
      UPDATE t_mcre0_app_rio_proroghe
         SET flg_storico = 1
       WHERE flg_storico = 0
         AND cod_abi_cartolarizzato = p_cod_abi
         AND cod_ndg = p_cod_ndg;
    END IF;
    COMMIT;
    RETURN ok;
  EXCEPTION
    WHEN OTHERS THEN
      pkg_mcre0_audit.log_etl(v_cod_log,
                              'PKG_MCRE0_PORTALE_GEST_STATI.FNC_DELETE_RIO_SETT',
                              pkg_mcre0_audit.c_error,
                              SQLCODE,
                              SQLERRM,
                              'DELETE ' || v_esecuzione || ' - ABI=' ||
                              p_cod_abi || ' NDG=' || p_cod_ndg);
      RETURN ko;
  END;

  FUNCTION fnc_delete_rio(p_cod_log t_mcre0_wrk_audit_etl.id%TYPE DEFAULT NULL)
    RETURN NUMBER IS

    v_cod_log t_mcre0_wrk_audit_etl.id%TYPE;
    CURSOR c_rio IS
      SELECT cod_abi_cartolarizzato,
             cod_ndg
        FROM v_mcre0_app_upd_fields x --v5.0
       WHERE cod_macrostato != 'RIO'
            --v4.4
         AND trunc(SYSDATE) - trunc(dta_decorrenza_stato) > 2
            --v4.4
         AND (EXISTS
              (SELECT DISTINCT 1
                 FROM t_mcre0_app_rio_gestione g
                WHERE g.cod_abi_cartolarizzato = x.cod_abi_cartolarizzato
                  AND g.cod_ndg = x.cod_ndg
                  and g.flg_delete = 0) OR EXISTS
              (SELECT DISTINCT 1
                 FROM t_mcre0_app_rio_azioni g
                WHERE g.cod_abi_cartolarizzato = x.cod_abi_cartolarizzato
                  AND g.cod_ndg = x.cod_ndg
                  and g.flg_delete = 0) OR EXISTS
              (SELECT DISTINCT 1
                 FROM t_mcre0_app_rio_anomalie g
                WHERE g.cod_abi_cartolarizzato = x.cod_abi_cartolarizzato
                  AND g.cod_ndg = x.cod_ndg
                  and g.flg_delete = 0));

    CURSOR c_rio_proroghe IS
      SELECT cod_abi_cartolarizzato,
             cod_ndg
        FROM v_mcre0_app_upd_fields x --v.5
        --v8.5 rimuovo proroghe solo se esco da RIO/IN non solo RIO
       WHERE (cod_macrostato not in ('RIO','IN','RS') AND
             (EXISTS
              (SELECT DISTINCT 1
                  FROM t_mcre0_app_rio_proroghe g
                 WHERE g.cod_abi_cartolarizzato = x.cod_abi_cartolarizzato
                   AND g.cod_ndg = x.cod_ndg
                   AND g.flg_storico = 0)))
          OR (cod_macrostato in ('RIO','IN','RS') AND
             dta_servizio >
             (SELECT max(dta_richiesta)
                 FROM t_mcre0_app_rio_proroghe g
                WHERE g.cod_abi_cartolarizzato = x.cod_abi_cartolarizzato
                  AND g.cod_ndg = x.cod_ndg
                  AND g.flg_storico = 0))
                  --v8.7
           OR (cod_stato='IN' AND  cod_stato_precedente!='IN'
             AND   trunc(dta_decorrenza_stato)>=
               (select max(trunc(dta_richiesta))
               FROM t_mcre0_app_rio_proroghe g
                WHERE g.cod_abi_cartolarizzato = x.cod_abi_cartolarizzato
                  AND g.cod_ndg = x.cod_ndg
                  AND g.flg_storico = 0
                  and G.FLG_ESITO is null))
               ;
    v_esito NUMBER := ok;
  BEGIN
    v_esito := ok;

    IF (p_cod_log IS NULL)
    THEN
      SELECT seq_mcr0_log_etl.nextval INTO v_cod_log FROM dual;
    ELSE
      v_cod_log := p_cod_log;
    END IF;

    FOR rec_rio IN c_rio
    LOOP
      v_esito := v_esito * fnc_delete_rio_sett(rec_rio.cod_abi_cartolarizzato,
                                               rec_rio.cod_ndg,
                                               0,
                                               v_cod_log);
    END LOOP;

    FOR rec_rio_proroghe IN c_rio_proroghe
    LOOP
      v_esito := v_esito * fnc_delete_rio_sett(rec_rio_proroghe.cod_abi_cartolarizzato,
                                               rec_rio_proroghe.cod_ndg,
                                               1,
                                               v_cod_log);
    END LOOP;

    RETURN v_esito;
  EXCEPTION
    WHEN OTHERS THEN
      pkg_mcre0_audit.log_etl(v_cod_log,
                              'PKG_MCRE0_PORTALE_GEST_STATI.FNC_DELETE_RIO',
                              pkg_mcre0_audit.c_error,
                              SQLCODE,
                              SQLERRM,
                              'GENERALE ');
      RETURN ko;
  END;

  /*******************************************************************
  **** Nuova proroga
  **** Storicizzato record precendete, inserito il nuovo. Alert.
  ***** v9.0 non storicizzo più qui
  *******************************************************************/
  FUNCTION fnc_nuova_proroga(p_cod_abi_cartolarizzato t_mcre0_app_rio_proroghe.cod_abi_cartolarizzato%TYPE,
                             p_cod_ndg                t_mcre0_app_rio_proroghe.cod_ndg%TYPE,
                             p_cod_sndg               t_mcre0_app_alert_pos.cod_sndg%TYPE,
                             p_id_utente              t_mcre0_app_rio_proroghe.id_utente%TYPE,
                             p_val_motivo_richiesta   t_mcre0_app_rio_proroghe.val_motivo_richiesta%TYPE,
                             p_protocollo_delibera    t_mcrei_app_delibere.cod_protocollo_delibera%TYPE DEFAULT NULL,
                             p_cod_log                t_mcre0_wrk_audit_applicativo.id%TYPE DEFAULT NULL)
    RETURN NUMBER IS

    v_esito                NUMBER := ok;
    v_exists               NUMBER(1) := 0;
    v_num_proroghe         t_mcre0_app_rio_proroghe.val_num_proroghe%TYPE;
    v_dta_scadenza_proroga t_mcre0_app_rio_proroghe.dta_scadenza_proroga%TYPE;
    V_COD_LOG              T_MCRE0_WRK_AUDIT_APPLICATIVO.ID%TYPE;

    v_microtipologia       t_mcrei_app_delibere.cod_microtipologia_delib%TYPE :='CI';--default
    v_dta_scadenza_pre     t_mcre0_app_rio_proroghe.dta_scadenza_proroga%TYPE;

  BEGIN

    IF (p_cod_log IS NULL)
    THEN
      SELECT seq_mcr0_log_app.nextval INTO v_cod_log FROM dual;
    ELSE
      v_cod_log := p_cod_log;
    END IF;

--9.0 non posso 'archiviare su Nuova Proroga, perchè sennò la posizione resta scoperta
/*
    BEGIN
      UPDATE t_mcre0_app_rio_proroghe
         SET flg_storico = 1
       WHERE cod_abi_cartolarizzato = p_cod_abi_cartolarizzato
         AND cod_ndg = p_cod_ndg
         AND flg_esito IS NOT NULL
         AND flg_storico = 0;
    EXCEPTION
      WHEN OTHERS THEN
        pkg_mcre0_audit.log_app(v_cod_log,
                                'PKG_MCRE0_PORTALE_GEST_STATI.FNC_NUOVA_PROROGA',
                                pkg_mcre0_audit.c_error,
                                SQLCODE,
                                SQLERRM,
                                'UPDATE storico - ABI=' ||
                                p_cod_abi_cartolarizzato || ' NDG=' ||
                                p_cod_ndg, p_id_utente);
        RETURN ko;
    END;
*/
    BEGIN
      SELECT DISTINCT 1
        INTO v_exists
        FROM t_mcre0_app_rio_proroghe
       WHERE cod_abi_cartolarizzato = p_cod_abi_cartolarizzato
         AND cod_ndg = p_cod_ndg
         AND flg_esito IS NULL
         AND flg_storico = 0;
    EXCEPTION
      WHEN OTHERS THEN
        v_exists := 0;
    END;

    IF (v_exists = 0)
    THEN

      BEGIN
        SELECT DISTINCT MAX(val_num_proroghe),
                        MAX(dta_scadenza_proroga),
                        MAX(dta_scadenza_proroga)
          INTO v_num_proroghe,
               v_dta_scadenza_pre, v_dta_scadenza_proroga
          FROM t_mcre0_app_rio_proroghe p,
               t_mcre0_app_all_data     a --v6.0
         WHERE p.cod_abi_cartolarizzato = a.cod_abi_cartolarizzato
           AND p.cod_ndg = a.cod_ndg
           AND p.cod_abi_cartolarizzato = p_cod_abi_cartolarizzato
           AND p.cod_ndg = p_cod_ndg
           --v8.4 per le divisioni non si effettua il controllo sulla data servizio
           --AND p.dta_richiesta > a.dta_servizio; --conto solo le proroghe post servizio..! v6.0
           AND p.dta_richiesta >
           case when nvl(cod_ramo_calcolato, '900000') < '000003'then --check direzione!
            nvl(a.dta_servizio, to_date('01011900','ddmmyyyy')) --conto solo le proroghe post servizio..! v6.0
            else to_date('01011900','ddmmyyyy')
            end
          ;

      EXCEPTION
        WHEN OTHERS THEN
          v_num_proroghe := NULL;
      END;

    if p_protocollo_delibera is not null then
    begin
        select dta_scadenza ,  cod_microtipologia_delib
        into v_dta_scadenza_proroga, v_microtipologia
        from t_mcrei_app_delibere
        where cod_abi = p_cod_abi_cartolarizzato
          and cod_ndg = p_cod_ndg
          and cod_protocollo_delibera = p_protocollo_delibera;

        select dta_scadenza_stato into v_dta_scadenza_pre
          from t_mcre0_app_all_data
         where cod_abi_cartolarizzato = p_cod_abi_cartolarizzato
           AND cod_ndg = p_cod_ndg;

        --aggiorno la scadenza stato x proroga se non classificazione
--        if v_microtipologia not in ('CI','CS') then
--        update t_mcre0_app_all_data
--           set dta_scadenza_stato = v_dta_scadenza_proroga
--         where cod_abi_cartolarizzato = p_cod_abi_cartolarizzato
--           AND cod_ndg = p_cod_ndg;
--        end if;

    exception when no_data_found then
     pkg_mcre0_audit.log_app(v_cod_log, 'PKG_MCRE0_PORTALE_GEST_STATI.FNC_NUOVA_PROROGA - inc',
                             pkg_mcre0_audit.c_error, SQLCODE, SQLERRM,
                                  'mancatop recupero info delibera '||p_protocollo_delibera, p_id_utente);
    end;
    end if;



      BEGIN
        INSERT INTO t_mcre0_app_rio_proroghe
          (cod_abi_cartolarizzato,
           cod_ndg,
           cod_sequence,
           dta_richiesta,
           flg_storico,
           id_utente,
           val_motivo_richiesta,
           val_num_proroghe,
           dta_scadenza_proroga,
           DTA_SCADENZA_PRECEDENTE,
           COD_PROTOCOLLO_DELIBERA)
        VALUES
          (p_cod_abi_cartolarizzato,
           p_cod_ndg,
           seq_mcre0_rio_proroghe.nextval,
           SYSDATE,
           0,
           p_id_utente,
           p_val_motivo_richiesta,
           v_num_proroghe,
           V_DTA_SCADENZA_PROROGA,
           V_DTA_SCADENZA_PRE,
           p_protocollo_delibera);
      EXCEPTION
        WHEN OTHERS THEN
          pkg_mcre0_audit.log_app(v_cod_log,
                                  'PKG_MCRE0_PORTALE_GEST_STATI.FNC_NUOVA_PROROGA',
                                  pkg_mcre0_audit.c_error,
                                  SQLCODE,
                                  SQLERRM,
                                  'INSERT new', p_id_utente);
          RETURN ko;
      END;

        --9.2 - gestione proroga incaglio

      BEGIN
        v_esito := pkg_mcre0_alert.fnc_verifica_alert_ndg(p_cod_abi_cartolarizzato,
                                                          p_cod_ndg,
                                                          p_cod_sndg,
                                                          p_id_utente);
      EXCEPTION
        WHEN OTHERS THEN
          NULL;
      END;
    END IF;

    RETURN ok;

  EXCEPTION
    WHEN OTHERS THEN
      pkg_mcre0_audit.log_app(v_cod_log,
                              'PKG_MCRE0_PORTALE_GEST_STATI.FNC_NUOVA_PROROGA',
                              pkg_mcre0_audit.c_error,
                              SQLCODE,
                              SQLERRM,
                              'GENERALE - ABI=' || p_cod_abi_cartolarizzato ||
                              ' NDG=' || p_cod_ndg, p_id_utente);
      RETURN ko;
  END;

  /*******************************************************************
  **** Esito proroga
  **** Aggiorna la richiesta con conferma o rifuto. Alert.
  ***** v9.0 storicizzo ora l'eventuale proroga confermata precedente
  *******************************************************************/
  FUNCTION fnc_esito_proroga(p_cod_abi_cartolarizzato t_mcre0_app_rio_proroghe.cod_abi_cartolarizzato%TYPE,
                             p_cod_ndg                t_mcre0_app_rio_proroghe.cod_ndg%TYPE,
                             p_cod_sndg               t_mcre0_app_alert_pos.cod_sndg%TYPE,
                             p_cod_matricola_resp     t_mcre0_app_rio_proroghe.cod_matricola_resp%TYPE,
                             p_id_ruolo_resp          t_mcre0_app_rio_proroghe.id_ruolo_resp%TYPE,
                             p_flg_esito              t_mcre0_app_rio_proroghe.flg_esito%TYPE,
                             p_id_utente              t_mcre0_app_rio_proroghe.id_utente%TYPE,
                             p_val_motivo_esito       t_mcre0_app_rio_proroghe.val_motivo_esito%TYPE,
                             p_protocollo_delibera    t_mcrei_app_delibere.cod_protocollo_delibera%TYPE DEFAULT NULL,
                             p_cod_log                t_mcre0_wrk_audit_applicativo.id%TYPE DEFAULT NULL)
    RETURN NUMBER IS

    v_esito   NUMBER := ok;
    v_cod_log t_mcre0_wrk_audit_applicativo.id%TYPE;

    v_stato    varchar2(2);
    v_comparto varchar2(8);
    V_SCADENZA DATE;
    v_dta_scadenza_proroga t_mcre0_app_rio_proroghe.dta_scadenza_proroga%TYPE;
    v_microtipologia       t_mcrei_app_delibere.cod_microtipologia_delib%TYPE :='CI';--default

  BEGIN

    IF (p_cod_log IS NULL)
    THEN
      SELECT seq_mcr0_log_app.nextval INTO v_cod_log FROM dual;
    ELSE
      v_cod_log := p_cod_log;
    END IF;

    begin
        select a.cod_stato, a.cod_comparto_calcolato, d.dta_scadenza
        into v_stato, v_comparto, v_scadenza
        from t_mcre0_app_all_data a, t_mcrei_app_delibere d
        where a.cod_abi_cartolarizzato = d.cod_abi(+)
        and a.cod_ndg = d.cod_ndg(+)
        and d.cod_protocollo_delibera(+) = p_protocollo_delibera
        and a.cod_abi_cartolarizzato = p_cod_abi_cartolarizzato
        and a.cod_ndg = p_cod_ndg;

    exception when others then
        v_stato := null;
        v_comparto := '#';
        v_scadenza := null;

    end;

    pkg_mcre0_audit.log_app(v_cod_log,
                                'PKG_MCRE0_PORTALE_GEST_STATI.FNC_ESITO_PROROGA',
                                pkg_mcre0_audit.c_debug,
                                SQLCODE,
                                'ricerca dati posizione',
                                'posizione ABI=' ||
                                p_cod_abi_cartolarizzato || ' NDG=' ||
                                p_cod_ndg || ' comparto=' || v_comparto||' scadenza='||v_scadenza, p_id_utente);

  --v9.0 chiudo la proroga precedente prima confermare la corrente: solo se Conferma!
  if (p_flg_esito = 1) then --archivio!
    BEGIN
      UPDATE t_mcre0_app_rio_proroghe
         SET flg_storico = 1
       WHERE cod_abi_cartolarizzato = p_cod_abi_cartolarizzato
         AND cod_ndg = p_cod_ndg
         AND flg_esito IS NOT NULL
         AND FLG_STORICO = 0;

      if p_protocollo_delibera is not null then
        begin
            select dta_scadenza ,  cod_microtipologia_delib
            into v_dta_scadenza_proroga, v_microtipologia
            from t_mcrei_app_delibere
            where cod_abi = p_cod_abi_cartolarizzato
              AND COD_NDG = P_COD_NDG
              and cod_protocollo_delibera = p_protocollo_delibera;

            IF V_MICROTIPOLOGIA NOT IN ('CI','CS') THEN
              update t_mcre0_app_all_data
               set dta_scadenza_stato = v_dta_scadenza_proroga
                where cod_abi_cartolarizzato = p_cod_abi_cartolarizzato
                AND cod_ndg = p_cod_ndg;
            END IF;
         end;
       end if;

    EXCEPTION
      WHEN OTHERS THEN
        pkg_mcre0_audit.log_app(v_cod_log,
                                'PKG_MCRE0_PORTALE_GEST_STATI.FNC_ESITO_PROROGA',
                                pkg_mcre0_audit.c_error,
                                SQLCODE,
                                SQLERRM,
                                'UPDATE storico - ABI=' ||
                                p_cod_abi_cartolarizzato || ' NDG=' ||
                                p_cod_ndg, p_id_utente);
        RETURN ko;
    END;
  end if;

    BEGIN
      UPDATE t_mcre0_app_rio_proroghe
         SET flg_esito            = p_flg_esito,
             val_motivo_esito     = p_val_motivo_esito,
             dta_esito            = SYSDATE,
             cod_matricola_resp   = p_cod_matricola_resp,
             id_ruolo_resp        = p_id_ruolo_resp,
             --v8.3 tolta decode esito: +1 in ogni caso
--             val_num_proroghe     = decode(p_flg_esito,
--                                           0,
--                                           val_num_proroghe,
--                                           nvl(val_num_proroghe, 0) + 1),
             val_num_proroghe     = nvl(val_num_proroghe, 0) + 1,
             --03/07/13 aggiorno direttamente anche lo storico
             flg_storico = decode(p_flg_esito, 1, flg_storico, 1),
             dta_scadenza_proroga = decode(p_flg_esito,
                                           0,
                                           dta_scadenza_proroga,
                                           SYSDATE +
                                           (
                                            --            SELECT decode(decode(P_FLG_ESITO,0,VAL_NUM_PROROGHE,nvl(VAL_NUM_PROROGHE,0) + 1),1,C.VAL_GG_PRIMA_PROROGA,C.VAL_GG_SECONDA_PROROGA)
                                            SELECT c.val_gg_seconda_proroga --v6.0
                                              FROM t_mcre0_app_comparti   c,
                                                    v_mcre0_app_upd_fields x --v5.0
                                             WHERE x.cod_abi_cartolarizzato =
                                                   p_cod_abi_cartolarizzato
                                               AND x.cod_ndg = p_cod_ndg
                                               AND x.cod_comparto =
                                                   c.cod_comparto))
       WHERE cod_abi_cartolarizzato = p_cod_abi_cartolarizzato
         AND cod_ndg = p_cod_ndg
         AND flg_storico = 0
         AND flg_esito is null;
    EXCEPTION
      WHEN OTHERS THEN
        pkg_mcre0_audit.log_app(v_cod_log,
                                'PKG_MCRE0_PORTALE_GEST_STATI.FNC_ESITO_PROROGA',
                                pkg_mcre0_audit.c_error,
                                SQLCODE,
                                SQLERRM,
                                'UPDATE esito - ABI=' ||
                                p_cod_abi_cartolarizzato || ' NDG=' ||
                                p_cod_ndg || ' ESITO=' || p_flg_esito, p_id_utente);
        RETURN ko;
    END;

    if (v_stato in ('IN','RS') and p_protocollo_delibera is not null) then

--simulo un cambio di stato
        update t_mcre0_app_all_data
        set cod_stato_precedente = cod_stato,
        dta_decorrenza_stato_pre = dta_decorrenza_stato,
        dta_decorrenza_stato = trunc(sysdate),
        dta_scadenza_stato = v_scadenza
        where cod_abi_cartolarizzato = p_cod_abi_cartolarizzato
        and cod_ndg = p_cod_ndg;

        update t_mcre0_app_rio_proroghe
        set dta_scadenza_proroga = v_scadenza
        where cod_abi_cartolarizzato = p_cod_abi_cartolarizzato
        and cod_ndg = p_cod_ndg;

        pkg_mcre0_audit.log_app(v_cod_log,
                                'PKG_MCRE0_PORTALE_GEST_STATI.FNC_ESITO_PROROGA',
                                pkg_mcre0_audit.c_debug,
                                SQLCODE,
                                'aggiornata scadenza stato non di direzione',
                                'posizione ABI=' ||
                                p_cod_abi_cartolarizzato || ' NDG=' ||
                                p_cod_ndg || ' comparto=' || v_comparto, p_id_utente);

    end if;

    BEGIN
      v_esito := pkg_mcre0_alert.fnc_verifica_alert_ndg(p_cod_abi_cartolarizzato,
                                                        p_cod_ndg,
                                                        p_cod_sndg,
                                                        p_id_utente);
    EXCEPTION
      WHEN OTHERS THEN
        NULL;
    END;

    RETURN ok;

  EXCEPTION
    WHEN OTHERS THEN
      pkg_mcre0_audit.log_app(v_cod_log,
                              'PKG_MCRE0_PORTALE_GEST_STATI.FNC_ESITO_PROROGA',
                              pkg_mcre0_audit.c_error,
                              SQLCODE,
                              SQLERRM,
                              'GENERALE - ABI=' || p_cod_abi_cartolarizzato ||
                              ' NDG=' || p_cod_ndg || ' ESITO=' ||
                              p_flg_esito, p_id_utente);
      RETURN ko;
  END;

  --v4.5 svecchio i GB dopo 365gg
  FUNCTION fnc_delete_gb(p_cod_log t_mcre0_wrk_audit_etl.id%TYPE DEFAULT NULL)
    RETURN NUMBER IS

    v_cod_log t_mcre0_wrk_audit_etl.id%TYPE;
    v_esito   NUMBER := ok;
  BEGIN

    IF (p_cod_log IS NULL)
    THEN
      SELECT seq_mcr0_log_etl.nextval INTO v_cod_log FROM dual;
    ELSE
      v_cod_log := p_cod_log;
    END IF;

    DELETE t_mcre0_app_gb_gestione WHERE SYSDATE > dta_ins + 365;

    RETURN ok;
  EXCEPTION
    WHEN OTHERS THEN
      pkg_mcre0_audit.log_etl(v_cod_log,
                              'PKG_MCRE0_PORTALE_GEST_STATI.FNC_DELETE_GB',
                              pkg_mcre0_audit.c_error,
                              SQLCODE,
                              SQLERRM,
                              'GENERALE');
      RETURN ko;
  END;

END pkg_mcre0_portale_gest_stati;
/


CREATE SYNONYM MCRE_APP.PKG_MCRE0_PORTALE_GEST_STATI FOR MCRE_OWN.PKG_MCRE0_PORTALE_GEST_STATI;


CREATE SYNONYM MCRE_USR.PKG_MCRE0_PORTALE_GEST_STATI FOR MCRE_OWN.PKG_MCRE0_PORTALE_GEST_STATI;


GRANT EXECUTE, DEBUG ON MCRE_OWN.PKG_MCRE0_PORTALE_GEST_STATI TO MCRE_USR;

