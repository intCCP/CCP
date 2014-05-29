CREATE OR REPLACE PACKAGE BODY MCRE_OWN.pkg_mcrei_refresh_aggregate AS
  /******************************************************************************
     NAME:       PKG_MCREI_GESTIONE_PARTIZIONI
     PURPOSE:

     REVISIONS:
     Ver        Date              Author             Description
     ---------  ----------      -----------------  ------------------------------------
     1.0      13/12/2011         E.Pellizzi         Created this package.
     1.1      13/12/2011         E.Pellizzi         Gestite tabelle fisiche.
     1.2      14/12/2011            M.Murro         Aggiunta gestione Rate Impagate
     1.3      14/12/2011            M.Murro         Mascherati valori -1 su utenti e stati
     1.4      15/12/2011            M.Murro         Mascherati valori -1 su gruppo_eco
     1.5      31/01/2012            M.Murro         aggiornata procedure posiz_inc_ri
     1.6      01/02/2012            M.Murro         aggiornata procedure posiz_con_classif
     1.7      02/02/2012            D'ERRICO        aggiunta rank a popolamento posiz_inc_ri
     1.8      07/02/2012            M.Murro         delete invece di truncate, check ultimo refresh
     1.9      15/02/2012            M.Murro         filtrati no delibera e fasi annullate
     2.0      22/02/2012            M.Murro         aggiunta gestione t_mcrei_app_pcr_rapp_aggr
     2.1      22/02/2012            M.Murro         corretta gestione t_mcrei_app_pcr_rapp_aggr
     2.2      27/02/2012            M.Murro         rimosso filtro no CI/CS su posiz inc/ri
     2.3      14/03/2012            M.Murro         fix calcolo data iniziale per delete
     2.4      28/03/2012            M.Murro         fix order by in rank posiz inc_ri
     2.5      30/03/2012            D'errico        modificato calcolo rdv totale in CA + FI
     2.6      04/04/2012            M.Murro         variata gestione per evitare chiamate simultanee
     2.7      10/04/2012            d'errico        modificata order by per la ranck di recupero rdv_progressiva in posiz_inc_ri
     2.8      26/04/2012            M.Murro         data incaglio da pratiche in posiz_inc_ri
     2.9      06/06/2012            d'errico        modificato cod_tipo_GEstione per posiz_inc_ri
     3.0      13/06/2012            d'errico        aggiunto flg_target , outsourcing e outer su rapp_aggr nall posiz_inc_ri
     3.1      28/06/2012            M.Murro         aggiunto NULLS LAST sul rank della posiz_inc_ri
     3.2      04/07/2012            d'errico        modificata gestione dta_scadenza_stato nelle posiz_inc_ri e con classif
     3.3      17/07/2012            M.Murro         fix posiz inc_ri e con_classif
     3.4      09/11/2012            M.Murro         estensione tabelle con campi DV
     3.5      19/11/2012            I.Gueorguieva   fix fnc_upd_pcr_rapp_aggr gegb_uti_tot direttamente dall'all_data
     3.6       3/01/2013            I.Gueorguieva   Aggiunto popolamanto campo cod_livello in fnc_mcrei_mv_posiz_con_classif, fnc_mcrei_mv_posiz_inc_ri
     3.7      11/02/2013            d'errico        corretta fnc_mcrei_mv_posiz_inc_ri invertendo popolamento data scadenza stato e data scadenza permanenza nel servizio
     3.8      30/05/2013            M.Murro         corretta fnc_mcrei_mv_posiz_inc_ri per cod_tipo_gestione da pratica e non delibera
    ******************************************************************************/

  -- ricalcolo dalla tabella per home page posizioni in Incaglio /Ristrutturati
  FUNCTION fnc_mcrei_mv_posiz_inc_ri(seq_flusso IN NUMBER DEFAULT NULL)
    RETURN NUMBER IS
    c_nome CONSTANT VARCHAR2(100) := c_package ||
                                     '.fnc_mcrei_mv_posiz_inc_ri';
    note       t_mcrei_wrk_audit_caricamenti.note%TYPE := 'GENERALE';
    v_last_upd DATE;
    v_ora      DATE;
    v_delay    NUMBER;

  BEGIN
    note := 'UPD T_MCREI_APP_POSIZ_INC_RI';

    BEGIN
      SELECT nvl(dta_upd, SYSDATE - 1)
        INTO v_last_upd
        FROM t_mcrei_app_posiz_inc_ri
       WHERE rownum <= 1;
    EXCEPTION
      WHEN OTHERS THEN
        SELECT (SYSDATE - 1) INTO v_last_upd FROM dual;
    END;

    SELECT round(MAX(SYSDATE - v_last_upd) * 1440) INTO v_delay FROM dual;

    IF v_delay > 15
    THEN

      --aggiorno prima la data per evitare chiamate simultanee
      SELECT SYSDATE INTO v_ora FROM dual;
      UPDATE t_mcrei_app_posiz_inc_ri SET dta_upd = SYSDATE;
      COMMIT;

      pkg_mcrei_audit.log_caricamenti(seq_flusso,
                                      c_nome,
                                      pkg_mcrei_audit.c_debug,
                                      SQLCODE,
                                      'start delete',
                                      note);

      --EXECUTE IMMEDIATE 'truncate table T_MCREI_APP_POSIZ_INC_RI reuse storage';
      DELETE t_mcrei_app_posiz_inc_ri;
      INSERT INTO t_mcrei_app_posiz_inc_ri
        (cod_abi_istituto,
         desc_istituto,
         cod_abi_cartolarizzato,
         cod_ndg,
         desc_nome_controparte,
         cod_sndg,
         cod_gruppo_economico,
         desc_gruppo_economico,
         cod_struttura_competente_dv,
         desc_struttura_competente_dv,
         cod_struttura_competente_dc,
         desc_struttura_competente_dc,
         cod_struttura_competente_rg,
         desc_struttura_competente_rg,
         cod_struttura_competente_ar,
         desc_struttura_competente_ar,
         cod_struttura_competente_fi,
         desc_struttura_competente_fi,
         cod_processo,
         cod_stato,
         cod_stato_precedente,
         dta_decorrenza_stato,
         dta_scadenza_stato,
         dta_servizio,
         dta_scadenza_perm_servizio,
         id_utente,
         dta_utente_assegnato,
         scsb_acc_tot_cf,
         scsb_acc_tot_d,
         scsb_uti_tot_cf,
         scsb_uti_tot_d,
         val_rdv_tot,
         ultima_tipologia_conf,
         desc_ultima_tipologia_conf,
         cod_tipo_gestione,
         desc_tipo_gestione,
         val_num_progr_delibera,
         cod_comparto,
         COD_LIVELLO,
         id_referente,
         dta_upd
         )

        SELECT --0215 aggiunto filtro no_delibera = 0 e pacchetto non annullato
        --0227 rimosso filtro no CI/CS
        --0328 - variato ordinamento rank
        --0426 - decorrenza incaglio da pratica
         cod_abi_istituto,
         desc_istituto,
         cod_abi_cartolarizzato,
         cod_ndg,
         desc_nome_controparte,
         cod_sndg,
         cod_gruppo_economico,
         desc_gruppo_economico,
         cod_struttura_competente_dv,
         desc_struttura_competente_dv,
         cod_struttura_competente_dc,
         desc_struttura_competente_dc,
         cod_struttura_competente_rg,
         desc_struttura_competente_rg,
         cod_struttura_competente_ar,
         desc_struttura_competente_ar,
         cod_struttura_competente_fi,
         desc_struttura_competente_fi,
         cod_processo,
         cod_stato,
         cod_stato_precedente,
         dta_decorrenza_stato,
         dta_scadenza_stato,
         dta_servizio,
         dta_scadenza_perm_servizio,
         id_utente,
         dta_utente_assegnato,
         scsb_acc_tot_cf,
         scsb_acc_tot_d,
         scsb_uti_tot_cf,
         scsb_uti_tot_d,
         val_rdv_tot,
         ultima_tipologia_conf,
         desc_ultima_tipologia_conf,
         cod_tipo_gestione,
         desc_tipo_gestione,
         val_num_progr_delibera,
         cod_comparto,
         COD_LIVELLO,
         id_referente,
                 SYSDATE
          FROM (SELECT /*DA ESEGUIRE PRIMA DELLA CHIAMATA ALLA VISTA
                                         BEGIN dbms_application_info.set_client_info( cod_matricola loggata ); END;*/
                /*+ index(f IXU_T_MCRE0_APP_ALL_DATA) index(p PK_MCREI_APP_PRATICHE) index(de ixp_T_MCREI_APP_DELIBERE) */
                 f.cod_abi_istituto,
                 f.desc_istituto,
                 f.cod_abi_cartolarizzato,
                 f.cod_ndg,
                 f.desc_nome_controparte,
                 f.cod_sndg,
                 nullif(f.cod_gruppo_economico, '-1') cod_gruppo_economico,
                 f.desc_gruppo_economico AS desc_gruppo_economico,
                 nor.cod_struttura_competente_dv,
                 nor.desc_struttura_competente_dv,
                 nor.cod_struttura_competente_dc,
                 nor.desc_struttura_competente_dc,
                 nor.cod_struttura_competente_rg,
                 nor.desc_struttura_competente_rg,
                 nor.cod_struttura_competente_ar,
                 nor.desc_struttura_competente_ar,
                 nor.cod_struttura_competente_fi,
                 nor.desc_struttura_competente_fi,
                 f.cod_processo,
                 nullif(f.cod_stato, '-1') cod_stato,
                 nullif(f.cod_stato_precedente, '-1') cod_stato_precedente,
                 --f.dta_decorrenza_stato,
                 nvl(CASE
                       WHEN f.cod_stato = 'IN' THEN
                        p.dta_decorrenza_stato
                       ELSE
                        f.dta_decorrenza_stato
                     END,
                     f.dta_decorrenza_stato) AS dta_decorrenza_stato,
                 f.dta_scadenza_stato AS dta_scadenza_stato_mople,
                 dta_scadenza_stato AS dta_scadenza_stato, --10 feb, AD. richiesta correzione da ilaria su segnalazione utente
                 f.dta_servizio,
                 decode(pro.dta_esito,
                        NULL,
                        f.dta_servizio + c.val_gg_prima_proroga,
                        pro.dta_esito + c.val_gg_seconda_proroga) AS dta_scadenza_perm_servizio, --10 feb, AD. richiesta correzione da ilaria su segnalazione utente
                 nullif(f.id_utente, -1) id_utente,
                 f.dta_utente_assegnato,
                 r.scsb_acc_tot AS scsb_acc_tot_cf, --cassa +firma
                 r.scsb_acc_sostituzioni AS scsb_acc_tot_d, --derivati
                 r.scsb_uti_tot AS scsb_uti_tot_cf, --cassa +firma
                 r.scsb_uti_sostituzioni AS scsb_uti_tot_d, --derivati
                 ---30 marzo: modificato calcolo CA+FI per rdv totale
                 nvl(de.val_rdv_qc_progressiva, 0) +
                 nvl(de.val_rdv_progr_fi, 0) AS val_rdv_tot,
                 de.cod_microtipologia_delib AS ultima_tipologia_conf,
                 t.desc_microtipologia AS desc_ultima_tipologia_conf,
                 --nvl(de.desc_tipo_gestione, p.cod_tipo_gestione)
                 p.cod_tipo_gestione AS cod_tipo_gestione, --50.05
                 nvl(do.desc_dominio, 'Non Determinato') AS desc_tipo_gestione,
                 de.val_num_progr_delibera,
                 nvl(f.cod_comparto_assegnato,
                     nullif(f.cod_comparto_calcolato, '#')) cod_comparto,
                 C.COD_LIVELLO,
                 u.id_referente,
                 rank() over(PARTITION BY de.cod_abi, de.cod_ndg ORDER BY --decode(de.cod_fase_delibera, 'AD',1,'CO',1,3), commentato il 10 aprile
                 de.dta_conferma_delibera DESC NULLS LAST, val_num_progr_delibera DESC) rn
                  FROM t_mcre0_app_all_data      f,
                       t_mcre0_app_rio_proroghe  pro,
                       t_mcre0_app_comparti      c,
                       t_mcrei_app_pratiche      p,
                       t_mcrei_app_delibere      de,
                       mv_mcre0_denorm_str_org   nor,
                       t_mcrei_cl_tipologie      t,
                       t_mcre0_app_utenti        u,
                       t_mcrei_cl_domini         do,
                       t_mcrei_app_pcr_rapp_aggr r
                 WHERE
                       p.cod_abi = de.cod_abi
                   AND p.cod_ndg = de.cod_ndg
                   AND p.val_anno_pratica = de.val_anno_pratica
                   AND p.cod_pratica = de.cod_pratica
                   AND p.flg_attiva = '1'
                   AND de.flg_attiva = '1'
                   AND de.cod_fase_delibera NOT IN ('AN', 'NA', 'IN') --ripristinato stato 'IN' il 4 maggio
                      ---SI VISUALIZZANO TUTTI GLI STATI TRANNE INSERITO,ANNULLATO O NON ADEMPIUTO
                      --escludo i no_delibera, e fasi annullate
                   AND de.flg_no_delibera = 0
                   AND de.cod_abi = r.cod_abi_cartolarizzato(+) --9/3, outer il 13/6
                   AND de.cod_ndg = r.cod_ndg(+)
                   AND de.cod_fase_pacchetto NOT IN ('ANA', 'ANM')
                   AND p.cod_abi = f.cod_abi_cartolarizzato
                   AND p.cod_ndg = f.cod_ndg
                   AND f.cod_abi_cartolarizzato =
                       pro.cod_abi_cartolarizzato(+)
                   AND f.cod_ndg = pro.cod_ndg(+)
                   AND pro.flg_storico(+) = 0
                   AND pro.flg_esito(+) = 1
                   AND nvl(f.cod_comparto_assegnato, cod_comparto_calcolato) =
                       c.cod_comparto(+)
                   AND p.cod_tipo_gestione = do.val_dominio(+)
                   AND do.cod_dominio(+) = 'TIPO_GESTIONE'
                   AND f.today_flg = '1'
                   AND f.flg_target = 'Y' --13 giu
                   AND f.flg_outsourcing = 'Y' --13 giu
                   AND f.cod_abi_cartolarizzato = nor.cod_abi_istituto_fi
                   AND f.cod_filiale = nor.cod_struttura_competente_fi
                   AND f.cod_stato IN ('IN', 'RS')
                   AND f.id_utente = u.id_utente
                   AND de.cod_microtipologia_delib = t.cod_microtipologia(+)
                   AND t.flg_attivo(+) = 1) s
         WHERE s.rn = 1;

      COMMIT;
      pkg_mcrei_audit.log_caricamenti(seq_flusso,
                                      c_nome,
                                      pkg_mcrei_audit.c_debug,
                                      SQLCODE,
                                      'ok',
                                      note);

    ELSE
      RETURN delayed;
    END IF;

    RETURN ok;
  EXCEPTION
    WHEN OTHERS THEN
      pkg_mcrei_audit.log_caricamenti(seq_flusso,
                                      c_nome,
                                      pkg_mcrei_audit.c_error,
                                      SQLCODE,
                                      SQLERRM,
                                      note);
      ROLLBACK;
      RETURN ko;
  END;

  -- ricalcolo dalla tabella per home page posizioni con classificazione in corso
FUNCTION fnc_mcrei_mv_posiz_con_classif(seq_flusso IN NUMBER DEFAULT NULL)
  RETURN NUMBER IS
  c_nome CONSTANT VARCHAR2(100) := c_package ||
                                   '.fnc_mcrei_mv_posiz_con_classif';

  note       t_mcrei_wrk_audit_caricamenti.note%TYPE := 'GENERALE';
  v_last_upd DATE;
  v_ora      DATE;
  v_delay    NUMBER;

BEGIN
  note := 'UPD T_MCREI_APP_POSIZ_CON_CLASSIF';

  BEGIN
    SELECT nvl(dta_upd, SYSDATE - 1)
      INTO v_last_upd
      FROM t_mcrei_app_posiz_con_classif
     WHERE rownum <= 1;
  EXCEPTION
    WHEN OTHERS THEN
      --creo un record fittizio, nuovo per evitare nuove chiamate
      BEGIN
        INSERT INTO t_mcrei_app_posiz_con_classif
          (cod_sndg,
           dta_upd)
        VALUES
          ('00',
           SYSDATE);
        COMMIT;
      EXCEPTION
        WHEN OTHERS THEN
          NULL;
      END;

      SELECT (SYSDATE - 1) INTO v_last_upd FROM dual;
  END;

  SELECT round(MAX(SYSDATE - v_last_upd) * 1440) INTO v_delay FROM dual;

  IF v_delay > 15
  THEN

    SELECT SYSDATE INTO v_ora FROM dual;

    --aggiorno prima la data per evitare chiamate simultanee
    SELECT SYSDATE INTO v_ora FROM dual;
    UPDATE t_mcrei_app_posiz_con_classif SET dta_upd = SYSDATE;
    COMMIT;

    pkg_mcrei_audit.log_caricamenti(seq_flusso,
                                    c_nome,
                                    pkg_mcrei_audit.c_debug,
                                    SQLCODE,
                                    'start delete',
                                    note);

    --EXECUTE IMMEDIATE 'truncate table T_MCREI_APP_POSIZ_CON_CLASSIF reuse storage';

    DELETE t_mcrei_app_posiz_con_classif;

    -----con classsif
    INSERT INTO t_mcrei_app_posiz_con_classif
      (cod_sndg,
       desc_nome_controparte,
       cod_ndg,
       cod_abi_istituto,
       desc_istituto,
       cod_abi_cartolarizzato,
       cod_gruppo_economico,
       desc_gruppo_economico,
       cod_struttura_competente_dv,
       desc_struttura_competente_dv,
       cod_struttura_competente_dc,
       desc_struttura_competente_dc,
       cod_struttura_competente_rg,
       desc_struttura_competente_rg,
       cod_struttura_competente_ar,
       desc_struttura_competente_ar,
       cod_struttura_competente_fi,
       desc_struttura_competente_fi,
       cod_processo,
       cod_stato,
       cod_stato_precedente,
       id_utente,
       stato_proposto,
       dta_decorrenza_stato,
       dta_scadenza_stato,
       dta_servizio,
       dta_apertura_delibera,
       dta_utente_assegnato,
       scsb_acc_tot_cf,
       scsb_acc_tot_d,
       scsb_uti_tot_cf,
       scsb_uti_tot_d,
       val_rdv_tot,
       ultima_tipologia_conf,
       desc_ultima_tipologia_conf,
       dta_conferma_delibera,
       cod_macrotipologia_delib,
       cod_comparto,
       COD_LIVELLO,
       id_referente,
       cod_fase_delibera,
       dta_upd,
       dta_scadenza_perm_servizio  --12feb
       )
      SELECT /*+ index(de ixp_T_MCREI_APP_DELIBERE) index(f IXU_T_MCRE0_APP_ALL_DATA)  */
      --0215 aggiunto filtro per no-delibera = 0 e pacchetto non annullato
       f.cod_sndg,
       f.desc_nome_controparte,
       f.cod_ndg,
       f.cod_abi_istituto,
       f.desc_istituto,
       f.cod_abi_cartolarizzato,
       nullif(f.cod_gruppo_economico, '-1') cod_gruppo_economico,
       f.desc_gruppo_economico AS desc_gruppo_economico,
       nor.cod_struttura_competente_dv,
       nor.desc_struttura_competente_dv,
       nor.cod_struttura_competente_dc,
       nor.desc_struttura_competente_dc,
       nor.cod_struttura_competente_rg,
       nor.desc_struttura_competente_rg,
       nor.cod_struttura_competente_ar,
       nor.desc_struttura_competente_ar,
       nor.cod_struttura_competente_fi,
       nor.desc_struttura_competente_fi,
       f.cod_processo,
       nullif(f.cod_stato, '-1') cod_stato,
       nullif(f.cod_stato_precedente, '-1') cod_stato_precedente,
       f.id_utente,
       decode(de.cod_microtipologia_delib, 'CI', 'IN', 'CS', 'SO') AS stato_proposto,
       f.dta_decorrenza_stato,
       --f.dta_scadenza_stato AS dta_scadenza_stato_mople,
       dta_scadenza_stato AS dta_scadenza_stato, --12 feb, AD. richiesta correzione da ilaria su segnalazione utente
       f.dta_servizio,
       de.dta_ins_delibera AS dta_apertura_delibera,
       f.dta_utente_assegnato,
       r.scsb_acc_tot AS scsb_acc_tot_cf, --ACC CASSA+FIRMA
       r.scsb_acc_sostituzioni AS scsb_acc_tot_d, --ACC DERIVATI
       r.scsb_uti_tot AS scsb_uti_tot_cf, --ACC CASSA+FIRMA
       r.scsb_uti_sostituzioni AS scsb_uti_tot_d, --ACC DERIVATI
       de.val_rdv_qc_progressiva AS val_rdv_tot,
       de.cod_microtipologia_delib AS ultima_tipologia_conf,
       t.desc_microtipologia AS desc_ultima_tipologia_conf,
       de.dta_conferma_delibera,
       de.cod_macrotipologia_delib,
       nvl(f.cod_comparto_assegnato, f.cod_comparto_calcolato) cod_comparto,
       C.COD_LIVELLO,
       u.id_referente,
       cod_fase_delibera,
       SYSDATE,
       decode(pro.dta_esito,
              NULL,
              f.dta_servizio + c.val_gg_prima_proroga,
              pro.dta_esito + c.val_gg_seconda_proroga) AS dta_scadenza_perm_servizio --12 febbraio
        FROM t_mcrei_app_delibere      de,
             t_mcre0_app_all_data      f,
             t_mcre0_app_rio_proroghe  pro,
             t_mcre0_app_comparti      c,
             mv_mcre0_denorm_str_org   nor,
             t_mcrei_cl_tipologie      t,
             t_mcre0_app_utenti        u,
             t_mcrei_app_pcr_rapp_aggr r ---9/3
       WHERE
             de.cod_abi = f.cod_abi_cartolarizzato
         AND de.cod_ndg = f.cod_ndg
            -- AND de.cod_microtipologia_delib IN ('CI', 'CS') Cambiato con filtro su cod_famiglia_tipologia 17.04.2012
         AND f.flg_target = 'Y' --13 GIU
         AND f.flg_outsourcing = 'Y' --13 GIU
         AND f.today_flg = '1'
         AND f.cod_abi_cartolarizzato = pro.cod_abi_cartolarizzato(+)
         AND f.cod_ndg = pro.cod_ndg(+)
         AND pro.flg_storico(+) = 0
         AND pro.flg_esito(+) = 1
         AND nvl(f.cod_comparto_assegnato, cod_comparto_calcolato) =
             c.cod_comparto(+)
         AND t.cod_famiglia_tipologia IN ('DCLI', 'DCLS')
         AND t.flg_attivo(+) = 1 --- aggiunto outer 24/2
         AND de.cod_pratica IS NULL
         AND de.flg_attiva = '1'
         AND de.cod_tipo_pacchetto = 'M'
         AND de.cod_microtipologia_delib = t.cod_microtipologia
            --escludo i no_delibera, e fasi annullate
         AND de.flg_no_delibera = 0
         AND de.cod_fase_pacchetto NOT IN ('ANA', 'ANM')
            ---SI VISUALIZZANO TUTTI GLI STATI TRANNE INSERITO,ANNULLATO O NON ADEMPIUTO
         AND de.cod_fase_delibera NOT IN ('AN', 'NA')
         AND de.cod_abi = r.cod_abi_cartolarizzato(+)
         AND de.cod_ndg = r.cod_ndg(+) --13 giu
         AND f.cod_abi_cartolarizzato = nor.cod_abi_istituto_fi
         AND f.cod_filiale = nor.cod_struttura_competente_fi
         AND f.id_utente = u.id_utente;

    COMMIT;
    pkg_mcrei_audit.log_caricamenti(seq_flusso,
                                    c_nome,
                                    pkg_mcrei_audit.c_debug,
                                    SQLCODE,
                                    'ok',
                                    note);

  ELSE
    RETURN delayed;
  END IF;

  RETURN ok;
EXCEPTION
  WHEN OTHERS THEN
    pkg_mcrei_audit.log_caricamenti(seq_flusso,
                                    c_nome,
                                    pkg_mcrei_audit.c_error,
                                    SQLCODE,
                                    SQLERRM,
                                    note);
    ROLLBACK;
    RETURN ko;
END;

  -- Aggiorno la rate impagate a seguito del caricamento dalle Rate Arretrate CCP (invocato da TWS)
  -- Viene usata una tabella di transcodifica dei codici rapporto provenienti
  -- da altri sottosistemi (MCRE0 ecc...)
  FUNCTION fnc_upd_rate_impagate(seq_flusso IN NUMBER) RETURN NUMBER IS
    c_nome CONSTANT VARCHAR2(100) := c_package || '.FNC_UPD_RATE_IMPAGATE';
    note t_mcrei_wrk_audit_caricamenti.note%TYPE := 'GENERALE';
  BEGIN
    note := 'UPD T_MCREI_APP_RATE_IMPAGATE';

    RETURN ok;
  EXCEPTION
    WHEN OTHERS THEN
      pkg_mcrei_audit.log_caricamenti(seq_flusso,
                                      c_nome,
                                      pkg_mcrei_audit.c_error,
                                      SQLCODE,
                                      SQLERRM,
                                      note);
      ROLLBACK;
      RETURN ko;
  END;

  FUNCTION fnc_upd_pcr_rapp_aggr(seq_flusso IN NUMBER) RETURN NUMBER IS
    c_nome CONSTANT VARCHAR2(100) := c_package || '.FNC_UPD_PCR_RAPP_AGGR';
    v_count NUMBER;
    note    t_mcrei_wrk_audit_caricamenti.note%TYPE := 'GENERALE';

  BEGIN
    DELETE t_mcrei_app_pcr_rapp_aggr;

    INSERT INTO t_mcrei_app_pcr_rapp_aggr
      (cod_abi_cartolarizzato,
       cod_ndg,
       scsb_uti_tot,
       scsb_uti_sostituzioni,
       scsb_uti_firma,
       scsb_uti_cassa,
       scgb_uti_tot,
       scgb_uti_rischi_indiretti,
       gegb_uti_tot,
       scsb_acc_tot,
       scsb_acc_sostituzioni,
       scsb_acc_firma,
       scsb_acc_cassa,
       scsb_dta_riferimento)
      SELECT cod_abi cod_abi_cartolarizzato,
             cod_ndg,
             SUM(scsb_uti_tot) scsb_uti_tot,
             SUM(scsb_uti_sostituzioni) scsb_uti_sostituzioni,
             SUM(scsb_uti_firma) scsb_uti_firma,
             SUM(scsb_uti_cassa) scsb_uti_cassa,
             SUM(scgb_uti_tot) scgb_uti_tot,
             SUM(scgb_uti_rischi_indiretti) scgb_uti_rischi_indiretti,
             (max(gegb_uti_cassa)+max(gegb_uti_firma)) gegb_uti_tot,
             SUM(scsb_acc_tot) scsb_acc_tot,
             SUM(scsb_acc_sostituzioni) scsb_acc_sostituzioni,
             SUM(scsb_acc_firma) scsb_acc_firma,
             SUM(scsb_acc_cassa) scsb_acc_cassa,
             MAX(scsb_dta_riferimento) scsb_dta_riferimento
        FROM (SELECT DISTINCT r.cod_abi,
                              r.cod_ndg,
                              CASE
                                WHEN r.cod_classe_ft IN ('CA', 'FI') THEN
                                 SUM(r.val_imp_utilizzato)
                                 over(PARTITION BY r.cod_abi,r.cod_ndg, cod_classe_ft)
                                ELSE
                                 0
                              END scsb_uti_tot,

                              CASE
                                WHEN r.cod_classe_ft IN ('ST') THEN
                                 SUM(r.val_imp_utilizzato)
                                 over(PARTITION BY r.cod_abi,r.cod_ndg,r.cod_classe_ft)
                                ELSE
                                 0
                              END scsb_uti_sostituzioni,

                              CASE
                                WHEN r.cod_classe_ft IN ('FI') THEN
                                 SUM(r.val_imp_utilizzato)
                                 over(PARTITION BY r.cod_abi,r.cod_ndg,r.cod_classe_ft)
                                ELSE
                                 0
                              END scsb_uti_firma,

                              CASE
                                WHEN r.cod_classe_ft IN ('CA') THEN
                                 SUM(r.val_imp_utilizzato)
                                 over(PARTITION BY r.cod_abi,
                                      r.cod_ndg,
                                      r.cod_classe_ft)
                                ELSE
                                 0
                              END scsb_uti_cassa,

                              CASE
                                WHEN r.cod_classe_ft IN ('CA', 'FI') THEN
                                 SUM(r.val_imp_utilizzato)
                                 over(PARTITION BY w.cod_sndg,cod_classe_ft)
                                ELSE
                                 0
                              END scgb_uti_tot,

                              CASE
                                WHEN r.cod_classe_ft IN ('RI') THEN
                                 SUM(r.val_imp_utilizzato)
                                 over(PARTITION BY w.cod_sndg,
                                      r.cod_classe_ft)
                                ELSE
                                 0
                              END scgb_uti_rischi_indiretti,
                              w.gegb_uti_cassa,
                              w.gegb_uti_firma,
--                              CASE
--                                WHEN r.cod_classe_ft IN ('CA', 'FI') THEN
--                                 SUM(r.val_imp_utilizzato)
--                                 over(PARTITION BY w.cod_gruppo_economico)
--                                ELSE
--                                 0
--                              END gegb_uti_tot,

                              CASE
                                WHEN r.cod_classe_ft IN ('CA', 'FI') THEN
                                 SUM(r.val_accordato_delib)
                                 over(PARTITION BY r.cod_abi,
                                      r.cod_ndg,
                                      r.cod_classe_ft)
                                ELSE
                                 0
                              END scsb_acc_tot,

                              CASE
                                WHEN r.cod_classe_ft IN ('ST') THEN
                                 SUM(r.val_accordato_delib)
                                 over(PARTITION BY r.cod_abi,
                                      r.cod_ndg,
                                      r.cod_classe_ft)
                                ELSE
                                 0
                              END scsb_acc_sostituzioni,

                              CASE
                                WHEN r.cod_classe_ft IN ('FI') THEN
                                 SUM(r.val_accordato_delib)
                                 over(PARTITION BY r.cod_abi,
                                      r.cod_ndg,
                                      r.cod_classe_ft)
                                ELSE
                                 0
                              END scsb_acc_firma,

                              CASE
                                WHEN r.cod_classe_ft IN ('CA') THEN
                                 SUM(r.val_accordato_delib)
                                 over(PARTITION BY r.cod_abi,
                                      r.cod_ndg,
                                      r.cod_classe_ft)
                                ELSE
                                 0
                              END scsb_acc_cassa,

                              r.dta_inz_vld AS scsb_dta_riferimento

                FROM t_mcre0_app_all_data     w,
                     t_mcrei_app_pcr_rapporti r
               WHERE r.cod_abi = w.cod_abi_cartolarizzato
                 AND r.cod_ndg = w.cod_ndg
                 AND w.today_flg = '1'
                 )
       GROUP BY cod_abi,
                cod_ndg;

    v_count := SQL%ROWCOUNT;
    note    := 't_mcrei_app_pcr_rapp_aggr_old: inseriti ' || v_count ||
               ' record';
    COMMIT;
    pkg_mcrei_audit.log_caricamenti(seq_flusso,
                                    c_nome,
                                    pkg_mcrei_audit.c_debug,
                                    SQLCODE,
                                    'ok',
                                    note);
    RETURN ok;

  EXCEPTION
    WHEN OTHERS THEN
      pkg_mcrei_audit.log_caricamenti(seq_flusso,
                                      c_nome,
                                      pkg_mcrei_audit.c_error,
                                      SQLCODE,
                                      SQLERRM,
                                      note);
      ROLLBACK;
      RETURN ko;
  END;

END pkg_mcrei_refresh_aggregate;
/


CREATE SYNONYM MCRE_APP.PKG_MCREI_REFRESH_AGGREGATE FOR MCRE_OWN.PKG_MCREI_REFRESH_AGGREGATE;


CREATE SYNONYM MCRE_USR.PKG_MCREI_REFRESH_AGGREGATE FOR MCRE_OWN.PKG_MCREI_REFRESH_AGGREGATE;


GRANT EXECUTE, DEBUG ON MCRE_OWN.PKG_MCREI_REFRESH_AGGREGATE TO MCRE_USR;

