CREATE OR REPLACE PACKAGE BODY MCRE_OWN.pkg_mcre0_gest_conferimenti AS
  /******************************************************************************
  NAME:       PKG_MCRE0_MIG_NDG_RAP
  PURPOSE:

  REVISIONS:
  Ver        Date        Author           Description
  ---------  ----------  ---------------  ------------------------------------
  1.0        22/06/2012  1.I.Gueorguieva  Created this package body.
  1.1        17/07/2012  M.Murro          estesa logica
  1.2        30/07/2012  d'errico         corretto popolamento mor5 e aggiunti campi nelle crea_delibere_impianto
  1.3        27/09/2012  d'errico         inserita decode del flg_recupero_tot per popolamento mor5_rap
  1.4        27/09/2012  I.Gueorguieva    corretta query di recupero_last_rdv_cedente
  1.5        27/09/2012  d'errico         corretto recupero_stime_ricevente
  2.0        04/10/2012  M.Murro          introdotte tabelle tmp e filtro stime su rapporti ancora attivi
  2.1        11/10/2012  M.Murro          fix calcolo fine gestione (mor5) e delib cedente
  2.2        23/10/2012  M.Murro          aggiunta dta_conferma su delibere impianto
  3.0        30/10/2012  M.Murro          calcolo esposizioni e rettifiche da Stime
  3.1        07/11/2012  M.Murro          limitato corsore a presa_visione 0
  3.2        19/11/2012  M.Murro          esposta Archivia Evento e Rimuovi Blocco
  ******************************************************************************/

  -- %author
  -- %version 0.1
  -- %usage  Function che lancia il caricamnto e il calcolo flag
  -- %param V_ID_FLUSSO numero unico identificativo del caricamento
  -- %param NDG_OR_RAPP valori possibili: AFTABRAC_NDG  oppure AFTABRAC_RAPP
  -- %return ID_DPER --> successo CARICAMRNTO, 0 altrimenti
  -- %cd 29 GIU 2012
  FUNCTION fnc_exe_load(v_id_flusso IN NUMBER,
                        ndg_or_rapp IN VARCHAR2,
                        v_cod_abi   IN VARCHAR2) RETURN NUMBER IS
    c_nome CONSTANT VARCHAR2(100) := c_package || '.FNC_EXE_LOAD';
    c_note    t_mcrei_wrk_audit_applicativo.note%TYPE := 'Generale';
    v_id_dper NUMBER;
    v_ret     NUMBER := ko;
    v_count   NUMBER := 0;

  BEGIN

    v_id_dper := pkg_mcre0_load_conferimenti.fnc_init_caricamento(v_id_flusso,
                                                                  ndg_or_rapp,
                                                                  v_cod_abi);
    IF v_id_dper != ko
    THEN
      v_ret := pkg_mcre0_load_conferimenti.fnc_load_st(v_id_flusso,
                                                       v_id_dper);
      IF v_ret = ok
      THEN
        v_ret := pkg_mcre0_load_conferimenti.fnc_load_app(v_id_flusso,
                                                          v_id_dper);
      END IF;

    END IF;
    RETURN v_ret;

  EXCEPTION
    WHEN OTHERS THEN
      ROLLBACK;
      pkg_mcrei_audit.log_app(c_nome,
                              pkg_mcrei_audit.c_error,
                              SQLCODE,
                              SQLERRM,
                              c_note,
                              NULL);
      RETURN ko;
  END fnc_exe_load;

  /*************************************************************************/
  /*                     CREAZIONE AUTOMATICA DELIBERE                     */
  /*************************************************************************/

  -- %author reply
  -- %version 0.1
  -- %usage  procedura di creazione automatica delle delibere di impianto Ricevente
  -- %d
  -- %d
  -- %d
  -- %param  p_new_cod_abi
  -- %param  p_new_cod_abi
  -- %param  p_old_cod_abi
  -- %param  p_old_cod_abi
  -- %param  p_tipo_posiz : C-> condivisa, T-> migrata totalmente, P-> migrata parzialmente
  -- %return out_proto_delibera
  -- %return out_proto_pacchetto
  -- %return out_esito
  -- %cd 9 jul 2012
  PROCEDURE crea_delibera_impianto(p_new_cod_abi       IN VARCHAR2,
                                   p_new_cod_ndg       IN VARCHAR2,
                                   p_tipo_posiz        IN VARCHAR2,
                                   p_lista_abi_old     IN VARCHAR2,
                                   out_proto_delibera  OUT VARCHAR2,
                                   out_proto_pacchetto OUT VARCHAR2,
                                   out_esito           OUT NUMBER) ---1 OK, 0 KO
   AS
    c_nome CONSTANT VARCHAR2(100) := c_package || '.crea_delibera_impianto';
    p_note              t_mcrei_wrk_audit_applicativo.note%TYPE;
    v_sndg              t_mcre0_app_all_data.cod_sndg%TYPE;
    v_last_rdv_qc_progr NUMBER := 0;
    v_last_rdv_progr_fi NUMBER := 0;
    v_progre_delib      NUMBER;
    v_cod_pratica       VARCHAR2(11);
    v_anno_pratica      NUMBER(4);
    v_prot              t_mcrei_app_delibere.cod_protocollo_pacchetto%TYPE;
    v_tipo_gestione     t_mcrei_app_pratiche.cod_tipo_gestione%TYPE;
    v_flg_condiviso     t_mcre0_app_mig_recode_ndg.flg_condiviso%TYPE;

  BEGIN

    CASE
      WHEN p_tipo_posiz = 'T' THEN

        p_note := 'crea_delibera_impianto per' || p_new_cod_abi || ' ' ||
                  p_new_cod_ndg;

        IF p_new_cod_ndg IS NULL OR
           p_new_cod_abi IS NULL
        THEN
          out_esito := 0;
          raise_application_error(-20666, 'Null parameter');
        END IF;

        BEGIN
          SELECT cod_sndg
            INTO v_sndg
            FROM t_mcre0_app_all_data
           WHERE cod_abi_cartolarizzato = p_new_cod_abi
             AND cod_ndg = p_new_cod_ndg;
        EXCEPTION
          WHEN OTHERS THEN
            v_sndg := '1000000000000000';
            pkg_mcrei_audit.log_app(c_nome,
                                    pkg_mcrei_audit.c_debug,
                                    SQLCODE,
                                    SQLERRM,
                                    'sndg non trovato',
                                    'BATCH');
        END;

        SELECT v_sndg || '_' || mcre_own.seq_mcrei_pacchetto.nextval
          INTO v_prot
          FROM dual;

        ------RECUPERO LAST RDV CONFERMATA AL NETTO DI SUCCESSIVI STRALCI CONTABILIZZATI
        --con l'aggiorna_delibera potrebbe essere del tutto eliminato
        recupera_last_rdv_conf(p_cod_abi        => p_new_cod_abi,
                               p_cod_ndg        => p_new_cod_ndg,
                               v_last_rdv_cassa => v_last_rdv_qc_progr,
                               v_last_rdv_firma => v_last_rdv_progr_fi);

        /*recupero il tipo gestione:
        se la posizione ¿ condivisa, verifico la presenza di pi¿ cedenti a fronte di un ricevente e ne calcolo la somma delle esposizioni
        in caso contrario, recupero il tipo gestione dalla pratica) */
        v_tipo_gestione := recupera_tipo_gestione(p_cod_abi  => p_new_cod_abi,
                                                  p_cod_ndg  => p_new_cod_ndg,
                                                  p_tipo_pos => v_flg_condiviso);

        p_note := 'INSERT della delibera di impianto per '|| p_new_cod_abi||' '||p_new_cod_ndg;
        INSERT INTO t_mcrei_app_delibere d
          (id_dper,
           cod_sndg,
           cod_abi,
           cod_ndg,
           cod_protocollo_pacchetto,
           cod_protocollo_delibera,
           flg_attiva,
           cod_microtipologia_delib,
           val_rdv_qc_progressiva,
           --val_esp_netta_post_delib,
           val_rdv_qc_ante_delib,
           --val_esp_netta_ante_delib,
           val_rdv_qc_deliberata,
           val_esp_lorda,
		   VAL_ESP_LORDA_CAPITALE,
		   VAL_ESP_TOT_CASSA,
		   VAL_IMP_UTILIZZO,
		   val_esp_firma,
           val_uti_cassa_scsb,
           val_uti_firma_scsb,
           val_uti_tot_scsb,
           cod_fase_delibera,
           cod_fase_microtipologia,
           cod_fase_pacchetto,
           dta_creazione_pacchetto,
           dta_ins_delibera,
           cod_tipo_pacchetto,
           cod_matricola_inserente,
           cod_macrotipologia_delib,
           cod_pratica,
           val_anno_pratica,
           cod_uo_pratica,
           cod_segmento,
           desc_denominaz_ins_delibera,
           cod_filiale_delibera,
           val_num_progr_delibera,
           flg_no_delibera,
           val_rdv_pregr_fi,
           val_rdv_progr_fi,
           desc_note,
           dta_delibera,
           cod_organo_deliberante,
		   DTA_INS,
		   DTA_LAST_UPD_DELIBERA,
		   val_anno_proposta,
		   val_progr_proposta,
           dta_conferma_delibera,
           dta_conferma_pacchetto
           )
          (SELECT to_number(to_char(trunc(SYSDATE), 'YYYYMMDD')),
                  g.cod_sndg,
                  g.cod_abi_cartolarizzato,
                  g.cod_ndg,
                  v_prot, ----proto_pacchetto
                  mcre_own.pkg_mcrei_gest_delibere.fnc_mcrei_protocollo_delibera(Ap.cod_uo_pratica,
                                                                                 'BATCH',
                                                                                 g.cod_abi_cartolarizzato,
                                                                                 g.cod_ndg),
                  '1' AS flg_attiva,
                  decode(v_tipo_gestione,
                         'G',
                         'IM',
                         'F',
                         'IM',
                         'E',
                         'IM',
                         'B',
                         'IF',
                         'A',
                         'IF',
                         'D',
                         'IF',
                         'C',
                         'IF',
                         v_tipo_gestione), --v_microtipolog,
                  v_last_rdv_qc_progr AS val_rdv_qc_progressiva,
                  --pc.scsb_uti_cassa - v_last_rdv_qc_progr AS val_esp_netta_post_delib,
                  0 AS val_rdv_qc_ante_delib,
                  --pc.scsb_uti_cassa - v_last_rdv_qc_progr AS val_esp_netta_ante_delib,
                  v_last_rdv_qc_progr AS val_rdv_qc_deliberata,
                  pc.scsb_uti_cassa AS val_esp_lorda,
                  pc.scsb_uti_cassa AS VAL_ESP_LORDA_CAPITALE,
                  pc.scsb_uti_cassa AS VAL_ESP_TOT_CASSA,
                  pc.scsb_uti_tot AS VAL_IMP_UTILIZZO,
                  pc.scsb_uti_firma AS val_esp_firma,
                  pc.scsb_uti_cassa AS val_uti_cassa_scsb,
                  pc.scsb_uti_firma AS val_uti_firma_scsb,
                  pc.scsb_uti_tot AS val_uti_tot_scsb,
                  'CO',
                  'CNF',
                  'ULT',
                  SYSDATE,
                  SYSDATE,
                  'I', ----delibera di Impianto creata a fronte di riordini territoriali
                  'BATCH',
                  t.cod_macrotipologia,
                  Ap.cod_pratica, -----da pratica appena migrata
                  Ap.val_anno_pratica,
                  Ap.cod_uo_pratica,
                  a.val_segmento_regolamentare,
                  'Batch per impianto',
                  g.cod_filiale,
                  seq_mcrei_prog_del.nextval,
                  0 AS fl_no_del,
                  0, ----pregr_fi
                  nvl(v_last_rdv_progr_fi, 0),
                  'Impianto del ' || TO_dATE(trunc(SYSDATE),'DD/MM/YYYY') ||
                  ' a seguito migrazione da ' || p_lista_abi_old,
                  --p_old_cod_abi, --note
                  trunc(SYSDATE),
                  'OI' desc_organo_deliberante,
                    SYSDATE,
                    SYSDATE,
                    ap.anno_proposta_ci,
                    ap.prog_proposta_ci,
                    sysdate,
                    sysdate
             FROM t_mcre0_app_all_data          g,
                  t_mcrei_cl_tipologie          t,
                  t_mcre0_app_anagrafica_gruppo a,
                  t_mcre0_app_utenti            u,
                  t_mcrei_app_pcr_rapp_aggr     pc,
                  V_MCREI_APP_PRATICHE          AP
            WHERE g.cod_abi_cartolarizzato = p_new_cod_abi
              AND g.cod_ndg = p_new_cod_ndg
              AND g.cod_sndg = a.cod_sndg
              AND g.today_flg = '1'
              AND g.cod_abi_cartolarizzato = pc.cod_abi_cartolarizzato(+)
              AND g.cod_ndg = pc.cod_ndg(+)
              AND g.cod_abi_cartolarizzato = AP.COD_ABI
              AND g.cod_ndg = AP.cod_ndg
                 -- SOLO TARGET E OUTSOURCING
              AND g.flg_outsourcing = 'Y'
              AND g.flg_target = 'Y'
              AND g.id_utente = u.id_utente(+)
              AND AP.COD_MICROTIPOLOGIA_DELIB = 'CI'
              AND t.cod_microtipologia =
                  decode(v_tipo_gestione,
                         'G',
                         'IM',
                         'F',
                         'IM',
                         'E',
                         'IM',
                         'B',
                         'IF',
                         'A',
                         'IF',
                         'D',
                         'IF',
                         'C',
                         'IF',
                         v_tipo_gestione)
              AND t.flg_attivo = 1) ;


        pkg_mcrei_audit.log_app(c_nome,
                                pkg_mcrei_audit.c_debug,
                                SQLCODE,
                                SQL%ROWCOUNT || ' righe inserite',
                                p_note,
                                'BATCH');

        ---restituisco i valori dei protocolli generati per la nuova delibera di impianto
        SELECT cod_protocollo_delibera,
               cod_protocollo_pacchetto
          INTO out_proto_delibera,
               out_proto_pacchetto
          FROM t_mcrei_app_delibere r
         WHERE r.cod_abi = p_new_cod_abi
           AND r.cod_ndg = p_new_cod_ndg
					 AND R.COD_PROTOCOLLO_PACCHETTO = v_prot
           AND cod_matricola_inserente = 'BATCH'
           AND flg_attiva = '1';

        pkg_mcrei_audit.log_app(c_nome,
                                pkg_mcrei_audit.c_debug,
                                SQLCODE,
                                'out: del ' || out_proto_delibera ||
                                ' pacc ' || out_proto_pacchetto,
                                p_note,
                                'BATCH');
        out_esito := 1;

      WHEN p_tipo_posiz = 'P' THEN
        out_esito           := 0;
        out_proto_delibera  := '-';
        out_proto_pacchetto := '-';
        pkg_mcrei_audit.log_app(c_nome,
                                pkg_mcrei_audit.c_error,
                                SQLCODE,
                                'tipo_posiz P',
                                p_note,
                                'BATCH');
      WHEN p_tipo_posiz = 'C' THEN
        out_esito           := 0;
        out_proto_delibera  := '-';
        out_proto_pacchetto := '-';
        pkg_mcrei_audit.log_app(c_nome,
                                pkg_mcrei_audit.c_error,
                                SQLCODE,
                                'tipo_posiz C',
                                p_note,
                                'BATCH');

      ELSE
        out_esito           := 0;
        out_proto_delibera  := '-';
        out_proto_pacchetto := '-';
        pkg_mcrei_audit.log_app(c_nome,
                                pkg_mcrei_audit.c_debug,
                                SQLCODE,
                                'Tipo di posizione non riconosciuto e quindi non lavorabile:' ||
                                p_new_cod_abi || ' ' || p_new_cod_ndg,
                                p_note,
                                'BATCH');
    END CASE;

  EXCEPTION
    WHEN OTHERS THEN
      out_esito := 0;
      pkg_mcrei_audit.log_app(c_nome,
                              pkg_mcrei_audit.c_error,
                              SQLCODE,
                              SQLERRM,
                              p_note,
                              'BATCH');
  END crea_delibera_impianto;

  -- %author reply
  -- %version 0.1
  -- %usage  function di recupero del tipo gestione di un cliente
  -- %d A prescindere dal tipo di posizione, se esistono più cedenti che migrano verso un ricevente,
  -- %d il tipo gestione viene derivato dal valore della somma delle esposizioni di tutte le posizioni coinvolte.
  -- %d se SUM > 250000, allora tipo gestione è analitica, altrimenti forfettaria
  -- %param  p_tipo_posiz : C-> condivisa, T-> migrata totalmente, P-> migrata parzialmente
  -- %return
  -- %cd 9 jul 2012
  FUNCTION recupera_tipo_gestione(p_cod_abi  IN t_mcrei_app_delibere.cod_abi%TYPE,
                                  p_cod_ndg  IN t_mcrei_app_delibere.cod_ndg%TYPE,
                                  p_tipo_pos IN t_mcre0_app_mig_recode_ndg.flg_condiviso%TYPE)
    RETURN VARCHAR2 IS

    v_tipo_ge         t_mcrei_app_pratiche.cod_tipo_gestione%TYPE;
    cnt_cedenti       NUMBER;
    v_val_esposizione NUMBER;

  BEGIN

    /****************************************************************************
    Se la posizione e' condivisa, nel caso di piu' banche cedenti,
    occorre sommare l'esposizione della posizione su ognuna di esse e:
    se esposizione_totale < 250000, allora F (Analitica), altrimenti A (Forfettaria)
    *****************************************************************************/
    --    IF p_tipo_pos = 1

    --    THEN
    ---VERIFICO SE PER LA POSIZIONE CI SONO PI¿ CEDENTI SU UN RICEVENTE

    SELECT COUNT(cod_abi_old)
      INTO cnt_cedenti
      FROM t_mcre0_app_mig_recode_ndg n
     WHERE n.cod_abi_new = p_cod_abi
       AND n.cod_ndg_new = p_cod_ndg;

    IF cnt_cedenti > 1
    THEN

      ----sommo le esposizioni eventuali recuperandole da pcr
      ----e verifico condizione
      BEGIN
			SELECT DISTINCT SUM(val_esposizione) over(PARTITION BY rs.cod_abi, rs.cod_ndg) AS val_esposizione
        INTO v_val_esposizione
        FROM (SELECT DISTINCT s.cod_abi,
                              s.cod_ndg,
                              s.cod_rapporto,
                              val_esposizione,
                              (rank()
                               over(PARTITION BY s.cod_abi,
                                    s.cod_ndg,
                                    s.cod_rapporto ORDER BY s.dta_stima DESC)) rn
                FROM t_mcrei_tmp_stime_conferimenti s
               WHERE s.cod_abi = p_cod_abi --'01025'
                 AND s.cod_ndg = p_cod_ndg --'0009981845826000'
              ) rs
       WHERE rn = 1;
      EXCEPTION WHEN no_Data_found
			THEN

				v_tipo_ge := 'F'; --di default, non conoscendo l'esposizione sui cendenti, mettiamo

			END;

      IF v_val_esposizione >= 250000
      THEN
        v_tipo_ge := 'F'; --analitico
      ELSE
        v_tipo_ge := 'A';
      END IF;

      RETURN v_tipo_ge;

    ELSE
      ---se la migrazione è 1:1, il tipo gestione si deriva dalla pratica della posizione
      ---
      BEGIN
        SELECT cod_tipo_gestione
          INTO v_tipo_ge
          FROM t_mcrei_app_pratiche       p,
               t_mcre0_app_mig_recode_ndg n
         WHERE p.cod_abi = n.cod_abi_old
           AND p.cod_ndg = n.cod_ndg_old
           AND n.cod_abi_new = p_cod_abi
           AND n.cod_ndg_new = p_cod_ndg
           AND rownum = 1
         ORDER BY p.dta_apertura DESC;

      EXCEPTION
        WHEN OTHERS THEN
          v_tipo_ge := '#';
					RETURN v_tipo_ge;
      END;
    RETURN v_tipo_ge;
		END IF;

  END recupera_tipo_gestione;

  -- %author reply
  -- %version 0.1
  -- %usage recupero dell'ultima rdv confermata al netto di successivi stralci contabilizzati
  -- %d
  -- %param
  -- %return
  -- %cd 9 jul 2012
  PROCEDURE recupera_last_rdv_conf(p_cod_abi        IN t_mcrei_app_delibere.cod_abi%TYPE,
                                   p_cod_ndg        IN t_mcrei_app_delibere.cod_ndg%TYPE,
                                   v_last_rdv_cassa OUT t_mcrei_app_delibere.val_rdv_qc_progressiva%TYPE,
                                   v_last_rdv_firma OUT t_mcrei_app_delibere.val_rdv_progr_fi%TYPE) AS

    c_nome CONSTANT VARCHAR2(100) := c_package || '.recupera_last_rdv_conf';
    p_note              t_mcrei_wrk_audit_applicativo.note%TYPE;
    v_delibera_pre      t_mcrei_app_delibere.cod_protocollo_delibera_pre%TYPE;

  BEGIN
    -----recupero last rdv al netto di successivi stralci contabilizzati
    --2.0 calcolo da stime_comferiemnti
    p_note := 'recupero last rdv confermata';

    SELECT DISTINCT SUM(val_rdv_qc_progressiva) over(PARTITION BY rs.cod_abi, rs.cod_ndg) AS val_rdv_qc_progressiva,
                    SUM(val_rdv_progr_fi) over(PARTITION BY rs.cod_abi, rs.cod_ndg) AS val_rdv_progr_fi
      INTO v_last_rdv_cassa,
           v_last_rdv_firma
      FROM (SELECT DISTINCT s.cod_abi,
                            s.cod_ndg,
                            dta_stima,
                            SUM(decode(s.cod_classe_ft,
                                       'CA',
                                       (val_rdv_tot),
                                       0)) over(PARTITION BY s.cod_abi, s.cod_ndg, s.cod_classe_ft, s.dta_stima ORDER BY s.dta_stima DESC) AS val_rdv_qc_progressiva,
                            SUM(decode(s.cod_classe_ft,
                                       'FI',
                                       (val_rdv_tot),
                                       0)) over(PARTITION BY s.cod_abi, s.cod_ndg, s.cod_classe_ft, s.dta_stima ORDER BY s.dta_stima DESC) AS val_rdv_progr_fi,
                            (rank()
                             over(PARTITION BY s.cod_abi,
                                  s.cod_ndg,
                                  s.cod_rapporto ORDER BY s.dta_stima DESC)) rn
              FROM t_mcrei_tmp_stime_conferimenti s
             WHERE s.cod_abi = p_cod_abi --'01025'
               AND s.cod_ndg = p_cod_ndg --'0009981845826000'
            --90000200201211906
            ) rs
     WHERE rn = 1;

  EXCEPTION
    WHEN no_data_found THEN
      v_last_rdv_cassa := 0;
      v_last_rdv_firma := 0;

		WHEN OTHERS THEN
      v_last_rdv_cassa := 0;
      v_last_rdv_firma := 0;
      pkg_mcrei_audit.log_app(c_nome,
                              pkg_mcrei_audit.c_error,
                              SQLCODE,
                              SQLERRM,
                              p_note,
                              'BATCH');

  END recupera_last_rdv_conf;

  -- %author reply
  -- %version 0.1
  -- %usage  Main di GESTIONE DEL PROCESSO DI CREAZIONE AUTOMATICA DELLE DELIBERE DI IMPIANTO
  -- %d Questa procedura processa i cluster di posizioni ricevuti mediante file aftabrac da host. Tali file
  -- %d contengono le posizioni soggette a riordino territoriale. Per ogni posizione che presenti
  -- %d delibere su cruscotto incagli, viene creata una delibera di impianto.
  -- %d Il tipo di delibera ¿ determinato IN base al tipo gestione della pratica associata:
  -- %d --> 'IM' se la pratica ha gestione analitica,
  -- %d --> 'IF' se la pratica ha gestione forfettaria.
  -- %d Per ogni delibera si recupera, inoltre, il valore dell'ultima rettifica di valore confermata, direttamente reperendola sull
  -- %d tabella delle stime migrate sul ricevente.
  -- %d Recuperate le stime, ad esse si aggancia il protocollo della delibera di impianto appena creata.
  -- %d In base ai rapporti agganciati nelle stime, si aggancia il protocollo della delibera anche ai piani di rientro
  -- %param
  -- %return
  -- %cd 10 jul 2012
  PROCEDURE main AS

    v_proto_delibera   t_mcrei_app_delibere.cod_protocollo_delibera%TYPE;
    v_proto_pacchetto  t_mcrei_app_delibere.cod_protocollo_pacchetto%TYPE;
    v_esito            NUMBER;
    v_delibera_cedente t_mcrei_app_delibere.cod_protocollo_delibera%TYPE;
    esito              NUMBER := 0;

  BEGIN
    /*****************************************************************************
    !!!!
    Per iniziare e' necessario che:
    --> la tabella PCR_RAPPORTI sia stata rinumerata
    --> la RAPP_AGGR sia stata calcolata
    ******************************************************************************/
    --1) Annullamento di tutte le delibere in stato Inserito sulla banca cedente

    --annulla_delibere_ins_cedenti --> si testa e si lancia a mano

    --2) Cancellazione delle stime legate a delibere annullate

    -->>PER OGNI CLUSTER DI POSIZIONI DA LAVORARE, si effettuano le seguenti operazioni:
    --* creazione delibera di impianto (attivita' che include il recupero dell'ultima rdv confermata e il tipo di gestione della pratica)
    --* aggancio stime
    --* aggancio piani
    --* popolamento coda per batch web
    ---PRIMA DI PARTIRE, UNA VOLTA RINUMERATO PCR A CALCOLATA LA RAPP_aGGR,
		--- SI LANCIA IL CALCOLO DELLA CLASSE_FT SULLE STIME MIGRATE (NELLA STIME_EXTRA):


		esito := CALCOLO_CLASSE_FT;
		IF ESITO = 0
			THEN
				pkg_mcrei_audit.log_app('CONFERIMENTI: main',
                                pkg_mcrei_audit.c_ERROR,
                                SQLCODE,
                                SQLERRM,
                                'fallito CALCOLO_CLASSE_FT',
                                'BATCH');
			 ELSE

			 pkg_mcrei_audit.log_app('CONFERIMENTI: main',
                                pkg_mcrei_audit.c_DEBUG,
                                SQLCODE,
                                SQLERRM,
                                'CALCOLO_CLASSE_FT EFFETTUATO CON SUCCESSO',
                                'BATCH');

		END IF;

		--- POI, PER I RAPPORTI A RIENTRO, DERIVO LA VAL_RDV_TOT DALLA STIMA E DALL'ESPOSIZIONE DEI RAPPORTI
			UPDATE t_mcrei_app_stime_extra
				 SET val_rdv_tot = NVL(val_esposizione,0) - NVL(val_prev_recupero,0)
			 WHERE flg_tipo_dato = 'S'
				 AND val_rdv_tot = 0;
      COMMIT;

		esito := recupera_abi_cedenti;

    ---Gestionme Riceventi (non in sofferenza) di cedenti su cruscotto
    FOR pos_t IN (SELECT DISTINCT cod_abi_new,
                                  cod_ndg_new,
                                  desc_list_abi_old
                    FROM t_mcre0_app_mig_recode_ndg i
                   WHERE nvl(i.flg_pres_cruscotto, 0) = 1
                   --v3.1
                     and i.flg_presa_visione = 0 --escluto già elaborati
                        -- AND i.flg_totale = 1 ---???
                     AND i.flg_sofferenza = 0)
    LOOP

      --step 0: se il ricevente e' condiviso e quindi ha gia' stime su rapporti 'pre migrazione' le si ribalta sulle stime extra
      --        cos da essere conteggiate insieme a quelle migrate per l'impianto

      esito := recupera_stime_ricevente(pos_t.cod_abi_new,
                                        pos_t.cod_ndg_new);

      --2.0 introdotta la tmp_stime_conferimenti, va clonato ciò che c'è su stime extra
      begin

        insert into t_mcrei_tmp_stime_conferimenti
            (select e.* from t_mcrei_app_stime_extra e,
                             t_mcrei_app_pcr_rapporti p
            where e.cod_abi = pos_t.cod_abi_new
              and e.cod_ndg = pos_t.cod_ndg_new
              and e.cod_abi = p.cod_abi
              and e.cod_ndg = p.cod_ndg
              and e.cod_rapporto = p.cod_rapporto);--solo rapporti attivi

      exception when others then
         pkg_mcrei_audit.log_app('CONFERIMENTI: main - pos_t',
                                pkg_mcrei_audit.c_ERROR,
                                SQLCODE,
                                SQLERRM,
                                'fallito insert stime extra su tmp ' ||
                                pos_t.cod_abi_new || ' ' ||
                                pos_t.cod_ndg_new,
                                'BATCH');
      end;

      begin

        insert into t_mcrei_tmp_piani_rientro_conf
            (select e.* from t_mcrei_app_piani_rientro_extr e,
                             t_mcrei_app_pcr_rapporti p
            where e.cod_abi = pos_t.cod_abi_new
              and e.cod_ndg = pos_t.cod_ndg_new
              and e.cod_abi = p.cod_abi
              and e.cod_ndg = p.cod_ndg
              and e.cod_rapporto = p.cod_rapporto);--solo rapporti attivi

      exception when others then
         pkg_mcrei_audit.log_app('CONFERIMENTI: main - pos_t',
                                pkg_mcrei_audit.c_ERROR,
                                SQLCODE,
                                SQLERRM,
                                'fallito insert piani extra su tmp ' ||
                                pos_t.cod_abi_new || ' ' ||
                                pos_t.cod_ndg_new,
                                'BATCH');
      end;

      IF esito = 0
      THEN
        ROLLBACK;
        pkg_mcrei_audit.log_app('CONFERIMENTI: main - pos_t',
                                pkg_mcrei_audit.c_ERROR,
                                SQLCODE,
                                SQLERRM,
                                'fallito clona stime/piani ' ||
                                pos_t.cod_abi_new || ' ' ||
                                pos_t.cod_ndg_new,
                                'BATCH');
      ELSE
        crea_delibera_impianto(p_new_cod_abi       => pos_t.cod_abi_new,
                               p_new_cod_ndg       => pos_t.cod_ndg_new,
                               p_tipo_posiz        => 'T',
                               p_lista_abi_old     => pos_t.desc_list_abi_old,
                               out_proto_delibera  => v_proto_delibera,
                               out_proto_pacchetto => v_proto_pacchetto,
                               out_esito           => v_esito);
        IF v_esito = 0
        THEN
          ROLLBACK;
          pkg_mcrei_audit.log_app('CONFERIMENTI: main - pos_t',
                                  pkg_mcrei_audit.c_error,
                                  SQLCODE,
                                  SQLERRM,
                                  'fallita delibera di impianto ' ||
                                  pos_t.cod_abi_new || ' ' ||
                                  pos_t.cod_ndg_new,
                                  'BATCH');

        ELSE
          --4) aggancio stime
          v_esito := aggancia_stime(pos_t.cod_abi_new,
                                            pos_t.cod_ndg_new,
                                            v_proto_delibera);

          v_esito := v_esito * aggiorna_delibera(pos_t.cod_abi_new,
                                            pos_t.cod_ndg_new,
                                            v_proto_delibera);
          --5) aggancio piani
          IF v_esito = 0
          THEN

            ROLLBACK;
            pkg_mcrei_audit.log_app('CONFERIMENTI: main - pos_t',
                                    pkg_mcrei_audit.c_error,
                                    SQLCODE,
                                    SQLERRM,
                                    'fallito aggancia stime ' ||
                                    pos_t.cod_abi_new || ' ' ||
                                    pos_t.cod_ndg_new || ' ' ||
                                    v_proto_delibera,
                                    'BATCH');

          ELSE

            v_esito := aggancia_piani(pos_t.cod_abi_new,
                                              pos_t.cod_ndg_new,
                                              v_proto_delibera);
            IF v_esito = 0
            THEN
              ROLLBACK;
              pkg_mcrei_audit.log_app('CONFERIMENTI: main - pos_t',
                                      pkg_mcrei_audit.c_error,
                                      SQLCODE,
                                      SQLERRM,
                                      'fallito aggancia piani ' ||
                                      pos_t.cod_abi_new || ' ' ||
                                      pos_t.cod_ndg_new || ' ' ||
                                      v_proto_delibera,
                                      'BATCH');

            ELSE
              --6) Popolamento coda per batch web
              IF v_esito = 1
              THEN

								COMMIT;---salvo la creazione delibera effettuata
								v_esito := popola_tab_mig_mor5(pos_t.cod_abi_new,
                                               pos_t.cod_ndg_new,
                                               v_proto_delibera);
                IF v_esito = 1
                THEN

                  v_esito := popola_tab_mig_mor5_rapp(pos_t.cod_abi_new,
                                                      pos_t.cod_ndg_new,
                                                      v_proto_delibera);

                  IF v_esito = 1
                  THEN
                    v_esito := popola_tab_mig_mor5_rate(pos_t.cod_abi_new,
                                                        pos_t.cod_ndg_new,
                                                        v_proto_delibera);
                  ELSE
                    ROLLBACK;
                    pkg_mcrei_audit.log_app('CONFERIMENTI: main - pos_t',
                                            pkg_mcrei_audit.c_error,
                                            SQLCODE,
                                            SQLERRM,
                                            'fallito popola mor5_rate ' ||
                                            pos_t.cod_abi_new || ' ' ||
                                            pos_t.cod_ndg_new || ' ' ||
                                            v_proto_delibera,
                                            'BATCH');

                  END IF;

                ELSE
                  ROLLBACK;
                  pkg_mcrei_audit.log_app('CONFERIMENTI: main - pos_t',
                                          pkg_mcrei_audit.c_error,
                                          SQLCODE,
                                          SQLERRM,
                                          'fallito popola mor5_rapp ' ||
                                          pos_t.cod_abi_new || ' ' ||
                                          pos_t.cod_ndg_new || ' ' ||
                                          v_proto_delibera,
                                          'BATCH');

                END IF;

              ELSE
                ROLLBACK;
                pkg_mcrei_audit.log_app('CONFERIMENTI: main - pos_t',
                                        pkg_mcrei_audit.c_error,
                                        SQLCODE,
                                        SQLERRM,
                                        'fallito popola mor5 ' ||
                                        pos_t.cod_abi_new || ' ' ||
                                        pos_t.cod_ndg_new || ' ' ||
                                        v_proto_delibera,
                                        'BATCH');
              END IF;
            END IF;
          END IF;
        END IF;
      END IF;
      COMMIT;

    END LOOP;

    ---cluster posizioni migrate PARZIALMENTE -- gestione Cedente per posizioni parziali
    FOR pos_p IN (SELECT DISTINCT cod_abi_old,
                                  cod_ndg_old,
                                  cod_abi_new,
                                  cod_ndg_new,
                                  desc_list_abi_old
                    FROM t_mcre0_app_mig_recode_ndg u
                   WHERE u.flg_pres_cruscotto = 1
                     AND u.flg_parziale = 1
                     AND u.flg_sofferenza = 0
                     --v3.1
                     and u.flg_presa_visione = 0 --escluto già elaborati
                  )
    LOOP
      --2) Creazione delibera di impianto

      crea_delibera_impianto_cedente(p_new_cod_abi         => pos_p.cod_abi_new,
                                     p_new_cod_ndg         => pos_p.cod_ndg_new,
                                     p_old_cod_abi         => pos_p.cod_abi_old,
                                     p_old_cod_ndg         => pos_p.cod_ndg_old,
                                     p_tipo_posiz          => 'P',
                                     out_proto_delibera    => v_proto_delibera,
                                     out_proto_pacchetto   => v_proto_pacchetto,
                                     out_esito             => v_esito,
                                     out_proto_del_cedente => v_delibera_cedente);
      IF v_esito = 0
      THEN

        ROLLBACK;
        pkg_mcrei_audit.log_app('CONFERIMENTI: main - pos_p',
                                pkg_mcrei_audit.c_error,
                                SQLCODE,
                                SQLERRM,
                                'fallito delibera impianto ' ||
                                pos_p.cod_abi_new || ' ' ||
                                pos_p.cod_ndg_new || ' ' ||
                                v_proto_delibera,
                                'BATCH');

      ELSE
        --4) aggancio stime /piani

        v_esito := clona_stime_cedente(pos_p.cod_abi_old,
                                       pos_p.cod_ndg_old,
                                       v_proto_delibera,
                                       v_delibera_cedente);


        v_esito := v_esito * aggiorna_delibera(pos_p.cod_abi_old,
                                               pos_p.cod_ndg_old,
                                               v_proto_delibera);
        IF v_esito = 0
        THEN
          ROLLBACK;
          pkg_mcrei_audit.log_app('CONFERIMENTI: main - pos_p',
                                  pkg_mcrei_audit.c_error,
                                  SQLCODE,
                                  SQLERRM,
                                  'fallito clona stime/piani ' ||
                                  pos_p.cod_abi_new || ' ' ||
                                  pos_p.cod_ndg_new || ' ' ||
                                  v_proto_delibera,
                                  'BATCH');

        ELSE
          COMMIT;----SALVO DELIBERE CREATE SUI CEDENTI

					v_esito := popola_tab_mig_mor5(pos_p.cod_abi_old,
                                         pos_p.cod_ndg_old,
                                         v_proto_delibera);
          IF v_esito = 0
          THEN

            ROLLBACK;
            pkg_mcrei_audit.log_app('CONFERIMENTI: main - pos_p',
                                    pkg_mcrei_audit.c_error,
                                    SQLCODE,
                                    SQLERRM,
                                    'fallito popola mor5 ' ||
                                    pos_p.cod_abi_new || ' ' ||
                                    pos_p.cod_ndg_new || ' ' ||
                                    v_proto_delibera,
                                    'BATCH');

          ELSE

            v_esito := popola_tab_mig_mor5_rapp(pos_p.cod_abi_old,
                                                pos_p.cod_ndg_old,
                                                v_proto_delibera);

            IF v_esito = 0
            THEN

              ROLLBACK;
              pkg_mcrei_audit.log_app('CONFERIMENTI: main - pos_p',
                                      pkg_mcrei_audit.c_error,
                                      SQLCODE,
                                      SQLERRM,
                                      'fallito popola mor5 rapp ' ||
                                      pos_p.cod_abi_new || ' ' ||
                                      pos_p.cod_ndg_new || ' ' ||
                                      v_proto_delibera,
                                      'BATCH');

            ELSE

              v_esito := popola_tab_mig_mor5_rate(pos_p.cod_abi_old,
                                                  pos_p.cod_ndg_old,
                                                  v_proto_delibera);

              IF v_esito = 0
              THEN
                ROLLBACK;
                pkg_mcrei_audit.log_app('CONFERIMENTI: main - pos_p',
                                        pkg_mcrei_audit.c_error,
                                        SQLCODE,
                                        SQLERRM,
                                        'fallito popola mor5 rate ' ||
                                        pos_p.cod_abi_new || ' ' ||
                                        pos_p.cod_ndg_new || ' ' ||
                                        v_proto_delibera,
                                        'BATCH');
              END IF;

            END IF;

          END IF;
        END IF;

      END IF;

      COMMIT;

    END LOOP;
    /*****************************************************************************/

  END main;

  -- %author reply
  -- %version 0.1
  -- %usage  Funzione di
  -- %d La function
  -- %d
  -- %cd 9 jul 2012
  PROCEDURE prc_calcola_lista_abi_old IS

    c_nome CONSTANT VARCHAR2(100) := c_package ||
                                     '.prc_calcola_lista_abi_old';
    p_note       t_mcrei_wrk_audit_applicativo.note%TYPE;
    v_str_concat t_mcre0_app_mig_recode_ndg.desc_list_abi_old%TYPE := '';

    CURSOR c_new IS
      SELECT DISTINCT cod_abi_new,
                      cod_ndg_new
        FROM t_mcre0_app_mig_recode_ndg;

    CURSOR c_old(c_cod_abi VARCHAR2, c_cod_ndg VARCHAR2) IS
      SELECT DISTINCT cod_abi_old
        FROM t_mcre0_app_mig_recode_ndg
       WHERE cod_abi_new = c_cod_abi
         AND cod_ndg_new = c_cod_ndg;

  BEGIN

    FOR r_new IN c_new
    LOOP
      v_str_concat := '';
      FOR r_old IN c_old(r_new.cod_abi_new, r_new.cod_ndg_new)
      LOOP
        v_str_concat := v_str_concat || r_old.cod_abi_old || ' ';
      END LOOP;
      UPDATE t_mcre0_app_mig_recode_ndg
         SET desc_list_abi_old = v_str_concat
       WHERE cod_abi_new = r_new.cod_abi_new
         AND cod_ndg_new = r_new.cod_ndg_new;
      COMMIT;

    END LOOP;

  EXCEPTION
    WHEN OTHERS THEN
      ROLLBACK;
      pkg_mcrei_audit.log_app(c_nome,
                              pkg_mcrei_audit.c_error,
                              SQLCODE,
                              SQLERRM,
                              p_note,
                              'BATCH');
  END;

  -- %author reply
  -- %version 0.1
  -- %usage  Procedura di creazione automatica delle delibere di impianto per i clienti migrati parzialmente
  -- %d
  -- %d
  -- %d
  -- %param  p_new_cod_abi
  -- %param  p_new_cod_abi
  -- %param  p_old_cod_abi
  -- %param  p_old_cod_abi
  -- %param  p_tipo_posiz : C-> condivisa, T-> migrata totalmente, P-> migrata parzialmente
  -- %return out_proto_delibera
  -- %return out_proto_pacchetto
  -- %return out_esito
  -- %cd 9 jul 2012
PROCEDURE crea_delibera_impianto_cedente(p_new_cod_abi         IN VARCHAR2,
                                         p_new_cod_ndg         IN VARCHAR2,
                                         p_old_cod_abi         IN VARCHAR2,
                                         p_old_cod_ndg         IN VARCHAR2,
                                         p_tipo_posiz          IN VARCHAR2,
                                         out_proto_delibera    OUT VARCHAR2,
                                         out_proto_pacchetto   OUT VARCHAR2,
                                         out_esito             OUT NUMBER,
                                         out_proto_del_cedente OUT VARCHAR2) ---1 OK, 0 KO
 AS
  c_nome CONSTANT VARCHAR2(100) := c_package ||
                                   '.crea_delibera_impianto_cedente';
  p_note              t_mcrei_wrk_audit_applicativo.note%TYPE;
  v_sndg              t_mcre0_app_all_data.cod_sndg%TYPE;
  v_last_rdv_qc_progr NUMBER := 0;
  v_last_rdv_progr_fi NUMBER := 0;
  v_progre_delib      NUMBER;
  v_cod_pratica       VARCHAR2(11);
  v_anno_pratica      NUMBER(4);
  v_prot              t_mcrei_app_delibere.cod_protocollo_pacchetto%TYPE;
  v_tipo_gestione     t_mcrei_app_pratiche.cod_tipo_gestione%TYPE;
  v_flg_condiviso     t_mcre0_app_mig_recode_ndg.flg_condiviso%TYPE;
  v_delibera_cedente  t_mcrei_app_delibere.cod_protocollo_delibera%TYPE;

BEGIN

  CASE
    WHEN p_tipo_posiz = 'P' THEN

      p_note := 'crea_delibera_impianto_cedente per' || p_old_cod_abi || ' ' ||
                p_old_cod_ndg;

      IF p_new_cod_ndg IS NULL OR
         p_new_cod_abi IS NULL
      THEN
        out_esito := 0;
        raise_application_error(-20666, 'Null parameter');
      END IF;

      ---recupera sndg

      SELECT cod_sndg
        INTO v_sndg
        FROM t_mcre0_app_all_data d
       WHERE cod_abi_cartolarizzato = p_old_cod_abi ----interrogo con l'old
         AND cod_ndg = p_old_cod_ndg
         AND today_flg = 1;

      SELECT v_sndg || '_' || mcre_own.seq_mcrei_pacchetto.nextval
        INTO v_prot
        FROM dual;

      ------RECUPERO LAST RDV CONFERMATA AL NETTO DI SUCCESSIVI STRALCI CONTABILIZZATI
      --con l'aggiorna_delibera potrebbe essere del tutto eliminato
      recupera_last_rdv_cedente(p_cod_abi        => p_old_cod_abi,
                                p_cod_ndg        => p_old_cod_ndg,
                                v_last_rdv_cassa => v_last_rdv_qc_progr,
                                v_last_rdv_firma => v_last_rdv_progr_fi,
                                v_delibera_rv    => v_delibera_cedente);

      out_proto_del_cedente := v_delibera_cedente;

      -- RECUPERA ESPOSIZIONE
      -- RECUPERA_ESPOSIZIONE_CEDENTE(P_COD_ABI            => P_OLD_COLD_ABI,
      --                              P_COD_NDG            => P_OLD_COD_NDG,
      --                              P_VAL_ESP_LORDA      => V_VAL_ESP_LORDA,
      --                              P_VAL_ESP_FIRMA      => V_VAL_ESP_FIRMA,
      --                              P_VAL_UTI_CASSA_SCSB => V_VAL_UTI_CASSA_SCSB,
      --                              P_VAL_UTI_FIRMA_SCSB => V_VAL_UTI_FIRMA_SCSB,
      --                              P_VAL_UTI_TOT_SCSB   => V_VAL_UTI_TOT_SCSB);

      /*recupero cmq il tipo gestione dalla nuova versione della pratica old, aggiornata poist conferimento */
      BEGIN
        SELECT cod_tipo_gestione
          INTO v_tipo_gestione
          FROM t_mcrei_app_pratiche
         WHERE cod_abi = p_old_cod_abi
           AND cod_ndg = p_old_cod_ndg
           AND flg_attiva = '1';

      EXCEPTION
        WHEN no_data_found THEN
          pkg_mcrei_audit.log_app(c_nome,
                                  pkg_mcrei_audit.c_debug,
                                  SQLCODE,
                                  SQLERRM,
                                  'crea_delibera_impianto_cedente per' ||
                                  p_old_cod_abi || ' ' || p_old_cod_ndg ||
                                  ' -manca la pratica',
                                  'BATCH');

      END;

      p_note := 'INSERT della delibera di impianto cedente per '||p_old_cod_abi || ' ' || p_old_cod_ndg ;

      INSERT INTO t_mcrei_app_delibere d
        (id_dper,
         cod_sndg,
         cod_abi,
         cod_ndg,
         cod_protocollo_pacchetto,
         cod_protocollo_delibera,
         flg_attiva,
         cod_microtipologia_delib,
         val_rdv_qc_progressiva,
         val_rdv_qc_ante_delib,
         val_rdv_qc_deliberata,
         val_esp_lorda,
         VAL_ESP_LORDA_CAPITALE,
         VAL_ESP_TOT_CASSA,
         VAL_IMP_UTILIZZO,
         val_esp_firma,
         val_uti_cassa_scsb,
         val_uti_firma_scsb,
         val_uti_tot_scsb,
         cod_organo_deliberante,
         dta_delibera,
         cod_fase_delibera,
         cod_fase_microtipologia,
         cod_fase_pacchetto,
         dta_creazione_pacchetto,
         dta_ins_delibera,
         cod_tipo_pacchetto,
         cod_matricola_inserente,
         cod_macrotipologia_delib,
         cod_pratica,
         val_anno_pratica,
         cod_uo_pratica,
         cod_segmento,
         desc_denominaz_ins_delibera,
         cod_filiale_delibera,
         val_num_progr_delibera,
         flg_no_delibera,
         val_rdv_pregr_fi,
         val_rdv_progr_fi,
         desc_note,
         dta_ins,
         dta_last_upd_delibera,
         val_anno_proposta,
         val_progr_proposta,
         dta_conferma_delibera,
         dta_conferma_pacchetto
         )
        (SELECT to_number(to_char(trunc(SYSDATE), 'YYYYMMDD')),
                v_sndg,
                g.cod_abi_cartolarizzato,
                g.cod_ndg,
                v_prot, ----proto_pacchetto
                mcre_own.pkg_mcrei_gest_delibere.fnc_mcrei_protocollo_delibera(ap.cod_uo_pratica,
                                                                               'BATCH',
                                                                               g.cod_abi_cartolarizzato,
                                                                               g.cod_ndg),
                '1' AS flg_attiva,
                decode(v_tipo_gestione,
                       'G',
                       'IM',
                       'F',
                       'IM',
                       'E',
                       'IM',
                       'B',
                       'IF',
                       'A',
                       'IF',
                       'D',
                       'IF',
                       'C',
                       'IF',
                       v_tipo_gestione), --v_microtipolog,
                v_last_rdv_qc_progr AS val_rdv_qc_progressiva,
                0 AS val_rdv_qc_ante_delib,
                v_last_rdv_qc_progr AS val_rdv_qc_deliberata,
                pc.scsb_uti_cassa AS val_esp_lorda,
                pc.scsb_uti_cassa AS VAL_ESP_LORDA_CAPITALE,
                pc.scsb_uti_cassa AS VAL_ESP_TOT_CASSA,
                pc.scsb_uti_tot AS VAL_IMP_UTILIZZO,
                pc.scsb_uti_firma AS val_esp_firma,
                pc.scsb_uti_cassa AS val_uti_cassa_scsb,
                pc.scsb_uti_firma AS val_uti_firma_scsb,
                pc.scsb_uti_tot AS val_uti_tot_scsb,
                'OI' AS cod_organo_deliberante,
                trunc(SYSDATE) AS dta_delibera, --25 LUGLIO
                'CO',
                'CNF',
                'ULT',
                SYSDATE,
                SYSDATE,
                'I', ----delibera di Impianto creata a fronte di riordini territoriali
                'BATCH',
                t.cod_macrotipologia,
                ap.cod_pratica, -----vecchia pratica
                ap.val_anno_pratica,
                ap.cod_uo_pratica,
                a.val_segmento_regolamentare,
                'Batch per impianto',
                g.cod_filiale,
                seq_mcrei_prog_del.nextval,
                0 AS fl_no_del,
                0, ----pregr_fi
                nvl(v_last_rdv_progr_fi, 0),
                'Impianto del ' || trunc(SYSDATE) ||
                ' a seguito migrazione verso ' || p_new_cod_abi, --note
                SYSDATE,
                SYSDATE,
                ap.anno_proposta_ci,
                ap.prog_proposta_ci,
                sysdate,
                sysdate
           FROM t_mcre0_app_all_data          g,
                t_mcrei_cl_tipologie          t,
                t_mcre0_app_anagrafica_gruppo a,
                t_mcre0_app_utenti            u,
                t_mcrei_app_pcr_rapp_aggr     pc,
                v_mcrei_app_pratiche          ap
          WHERE g.cod_abi_cartolarizzato = p_old_cod_abi
            AND g.cod_ndg = p_old_cod_ndg
            AND g.cod_sndg = a.cod_sndg
            AND g.today_flg = '1'
            AND g.cod_abi_cartolarizzato = pc.cod_abi_cartolarizzato(+)
            AND g.cod_ndg = pc.cod_ndg(+)
            AND g.cod_abi_cartolarizzato = ap.cod_abi
            AND g.cod_ndg = ap.cod_ndg
               -- SOLO TARGET E OUTSOURCING
            AND g.flg_outsourcing = 'Y'
            AND g.flg_target = 'Y'
            AND g.id_utente = u.id_utente(+)
            AND ap.cod_microtipologia_delib = 'CI'
            AND t.cod_microtipologia =
                decode(v_tipo_gestione,
                       'G',
                       'IM',
                       'F',
                       'IM',
                       'E',
                       'IM',
                       'B',
                       'IF',
                       'A',
                       'IF',
                       'D',
                       'IF',
                       'C',
                       'IF',
                       v_tipo_gestione)
            AND t.flg_attivo = 1);

        ---restituisco i valori dei protocolli generati per la nuova delibera di impianto
        SELECT cod_protocollo_delibera,
               cod_protocollo_pacchetto
          INTO out_proto_delibera,
               out_proto_pacchetto
          FROM t_mcrei_app_delibere r
         WHERE r.cod_abi = p_old_cod_abi
           AND r.cod_ndg = p_old_cod_ndg
           AND R.COD_PROTOCOLLO_PACCHETTO = v_prot
           AND cod_matricola_inserente = 'BATCH'
           AND flg_attiva = '1';

        pkg_mcrei_audit.log_app(c_nome,
                                pkg_mcrei_audit.c_debug,
                                SQLCODE,
                                'out: del ' || out_proto_delibera ||
                                ' pacc ' || out_proto_pacchetto,
                                p_note,
                                'BATCH');

      pkg_mcrei_audit.log_app(c_nome,
                              pkg_mcrei_audit.c_debug,
                              SQLCODE,
                              'out: del ' || out_proto_delibera || ' pacc ' ||
                              out_proto_pacchetto,
                              p_note,
                              'BATCH');
      out_esito := 1;

    ELSE
      pkg_mcrei_audit.log_app(c_nome,
                              pkg_mcrei_audit.c_debug,
                              SQLCODE,
                              'Tipo di posizione non riconosciuto e quindi non lavorabile:' ||
                              p_new_cod_abi || ' ' || p_new_cod_ndg,
                              p_note,
                              'BATCH');
  END CASE;

EXCEPTION
  WHEN OTHERS THEN
    out_esito             := 0;
    out_proto_delibera    := '-';
    out_proto_pacchetto   := '-';
    out_proto_del_cedente := '-';

    pkg_mcrei_audit.log_app(c_nome,
                            pkg_mcrei_audit.c_error,
                            SQLCODE,
                            SQLERRM,
                            p_note,
                            'BATCH');
END crea_delibera_impianto_cedente;

  -- %author reply
  -- %version 0.1
  -- %usage
  -- %d
  -- %param
  -- %return
  -- %cd 9 jul 2012
PROCEDURE recupera_last_rdv_cedente(p_cod_abi        IN t_mcrei_app_delibere.cod_abi%TYPE,
                                    p_cod_ndg        IN t_mcrei_app_delibere.cod_ndg%TYPE,
                                    v_last_rdv_cassa OUT t_mcrei_app_delibere.val_rdv_qc_progressiva%TYPE,
                                    v_last_rdv_firma OUT t_mcrei_app_delibere.val_rdv_progr_fi%TYPE,
                                    v_delibera_rv    OUT t_mcrei_app_delibere.cod_protocollo_delibera%TYPE) AS

  c_nome CONSTANT VARCHAR2(100) := c_package ||
                                   '.recupera_last_rdv_cedente';
  p_note              t_mcrei_wrk_audit_applicativo.note%TYPE;
  v_last_rdv_qc_progr NUMBER := 0;
  v_last_rdv_progr_fi NUMBER := 0;
  v_dta_stima         DATE;
BEGIN
  -----recupero last rdv al netto di successivi stralci contabilizzati
  p_note := 'recupero last rdv confermata cedente';

  BEGIN
    --1) recupero il protocollo dell'ultima rettifica confermata (RV, A0, T4)
    SELECT cod_protocollo_delibera
      INTO v_delibera_rv
      FROM (SELECT cod_protocollo_delibera
              FROM t_mcrei_app_delibere d
             WHERE d.cod_abi = p_cod_abi
               AND d.cod_ndg = p_cod_ndg
               AND d.cod_microtipologia_delib IN ('RV', 'T4', 'A0') -- <-- tutte le tipologie di rettifica?!
                  --and d.cod_fase_pacchetto in ('ULT') --corretto?!
               AND d.cod_fase_delibera IN ('AD', 'CO', 'CT', 'NA')
               AND d.flg_no_delibera = 0
               AND flg_attiva = '1'
            --and cod_tipo_pacchetto = 'M'--opportuno ribadire?!
             ORDER BY --s.dta_upd_fase_delibera  DESC,
                      d.val_num_progr_delibera DESC,
                      d.dta_conferma_delibera  DESC)
     WHERE rownum <= 1;
  EXCEPTION
    WHEN no_data_found THEN
      pkg_mcrei_audit.log_app(c_nome,
                              pkg_mcrei_audit.c_debug,
                              SQLCODE,
                              SQLERRM,
                              'Posizione senza RV confermate.. ' ||
                              p_cod_abi || ' ' || p_cod_ndg,
                              'BATCH');
      v_last_rdv_cassa := 0;
      v_last_rdv_firma := 0;
      v_delibera_rv    := '-';
  END;
  --2) se ho trovato una delibera confermata, aggrego le stime dei rapporti non migrati

  BEGIN
    ------x marco: controlla che sia corretta la query!!

    SELECT val_rdv_qc_progressiva, val_rdv_progr_fi
      INTO v_last_rdv_cassa, v_last_rdv_firma
      FROM (SELECT DISTINCT SUM(decode(cod_classe_ft, 'CA', val_rdv_tot, 0)) over(PARTITION BY cod_abi, cod_ndg, cod_classe_ft, cod_protocollo_delibera) AS val_rdv_qc_progressiva,
                            SUM(decode(cod_classe_ft, 'FI', val_rdv_tot, 0)) over(PARTITION BY cod_abi, cod_ndg, cod_classe_ft, cod_protocollo_delibera) AS val_rdv_progr_fi
              FROM (SELECT cod_abi,
                           cod_ndg,
                           dta_stima,
                           cod_protocollo_delibera,
                           nvl(cod_classe_ft, 'CA') AS cod_classe_ft,----forzatura in caso di classe_ft non esistente
                           val_rdv_tot
                      FROM (SELECT cod_abi,
                                   cod_ndg,
                                   dta_stima,
                                   cod_protocollo_delibera,
                                   cod_classe_ft,
                                   val_rdv_tot,
                                   rank() over(PARTITION BY cod_abi, cod_ndg, cod_rapporto ORDER BY dta_stima DESC) rn
                              FROM ((SELECT DISTINCT s.cod_abi,
                                                     s.cod_ndg,
                                                     dta_stima,
                                                     s.cod_rapporto,
                                                     s.cod_classe_ft,
                                                     val_rdv_tot,
                                                     s.cod_protocollo_delibera,
                                                     r.id_dper
                                       FROM t_mcrei_app_stime s,
                                            t_mcrei_app_pcr_rapporti p,
                                            (SELECT r.*
                                               FROM t_mcre0_app_mig_recode_rapp r,
                                                    t_mcre0_app_mig_recode_ndg  n
                                              WHERE n.cod_abi_old =
                                                    r.cod_abi_old
                                                AND n.cod_ndg_old =
                                                    r.cod_ndg_old) r --rapporti effettivamente migrati
                                      WHERE s.cod_abi = p_cod_abi
                                        AND s.cod_ndg = p_cod_ndg
                                        AND s.cod_protocollo_delibera = v_delibera_rv
                                        AND s.cod_abi = p.cod_abi
                                        AND s.cod_ndg = p.cod_ndg
                                        AND s.cod_rapporto = p.cod_rapporto
                                        AND s.cod_abi = r.cod_abi_old(+)
                                        AND s.cod_ndg = r.cod_ndg_old(+)
                                        AND s.cod_rapporto = r.cod_rapporto_old(+)
                                        AND r.cod_rapporto_old IS NULL)
                                    UNION
                                    (SELECT DISTINCT s.cod_abi,
                                                     s.cod_ndg,
                                                     dta_stima,
                                                     s.cod_rapporto,
                                                     s.cod_classe_ft,
                                                     val_rdv_tot,
                                                     s.cod_protocollo_delibera,
                                                     r.id_dper
                                       FROM t_mcrei_app_stime_batch s,
                                            t_mcrei_app_pcr_rapporti p,
                                            (SELECT r.*
                                               FROM t_mcre0_app_mig_recode_rapp r,
                                                    t_mcre0_app_mig_recode_ndg  n
                                              WHERE n.cod_abi_old = r.cod_abi_old
                                                AND n.cod_ndg_old = r.cod_ndg_old) r --rapporti effettivamente migrati
                                      WHERE s.cod_abi = p_cod_abi
                                        AND s.cod_ndg = p_cod_ndg
                                        AND s.cod_protocollo_delibera = v_delibera_rv
                                        AND s.cod_abi = p.cod_abi
                                        AND s.cod_ndg = p.cod_ndg
                                        AND s.cod_rapporto = p.cod_rapporto
                                        AND s.cod_abi = r.cod_abi_old(+)
                                        AND s.cod_ndg = r.cod_ndg_old(+)
                                        AND s.cod_rapporto = r.cod_rapporto_old(+)
                                        AND r.cod_rapporto_old IS NULL)))
                     WHERE rn = 1));

     EXCEPTION WHEN no_data_found ---se non trova la stima collegata alla delibera
    THEN
    ---se non esistono stime sul cedente, si recupera l'eventuale rdv progressiva presente sulla delibera: questo può capitare
    --solo per delibere nata su MOPLE

    SELECT val_rdv_qc_progressiva,
           val_rdv_progr_fi
      INTO v_last_rdv_cassa,
           v_last_rdv_firma
      FROM t_mcrei_app_delibere n
     WHERE n.cod_abi = p_cod_abi
       AND n.cod_ndg = p_cod_ndg
       AND n.cod_protocollo_delibera = v_delibera_rv;

  END;

END recupera_last_rdv_cedente;

  -- %author reply
  -- %version 0.1
  -- %usage  Funzione di clonazione delle stime e dei piani per posizioni migrate parzialmente
  -- %d La function clona le stime e i piani legate ai rapporti NON MIGRATI sulla banca cedente. In questo modo, il set di rapporti
  -- %d generato verrà successivamente agganciato alla dcelibera di impianto creata sul cliente rimasto sulla banca cedente
  -- %d a fronte di una migrazione parziale
  -- %param  p_cod_abi
  -- %param  p_cod_ndg
  -- %param  p_proto_delibera
  -- %param  p_delibera_cedente
  -- %cd 9 jul 2012
  FUNCTION clona_stime_cedente(p_cod_abi          VARCHAR2,
                               p_cod_ndg          VARCHAR2,
                               p_proto_delibera   VARCHAR2,
                               p_delibera_cedente VARCHAR2) RETURN NUMBER IS

  BEGIN

    --clono le stime legate ai rapporti non migrati
    INSERT INTO t_mcrei_app_stime
      (id_dper,
       cod_abi,
       cod_sndg,
       cod_ndg,
       cod_rapporto,
       dta_stima,
       desc_causa_prev_recupero,
       flg_recupero_tot,
       cod_uo_stima,
       val_imp_prev_pregr,
       val_imp_prev_att,
       val_prev_recupero,
       val_esposizione,
       val_rdv_tot,
       val_imp_rettifica_pregr,
       val_imp_rettifica_att,
       flg_tipo_dato,
       cod_utente,
       val_attualizzato,
       flg_pres_piano,
       cod_tipo_rapporto,
       cod_protocollo_delibera,
       flg_attiva,
       dta_ins,
       dta_upd,
       cod_operatore_ins_upd,
       cod_classe_ft,
       flg_ristrutturato,
       val_utilizzato_netto,
       val_utilizzato_mora,
       val_perc_rett_rapporto,
       val_accordato,
       cod_microtipologia_delibera,
       cod_npe,
       flg_tipo_rapporto,
       cod_forma_tecnica,
       dta_inizio_segnalazione_ristr,
       dta_fine_segnalazione_ristr,
       dta_decorrenza_stato)
      SELECT to_number(to_char(SYSDATE, 'YYYYMMDD')) id_dper,
             p_cod_abi,
             s.cod_sndg,
             p_cod_ndg,
             s.cod_rapporto,
             trunc(sysdate) as dta_stima,
             desc_causa_prev_recupero,
             flg_recupero_tot,
             cod_uo_stima,
             val_imp_prev_pregr,
             val_imp_prev_att,
             val_prev_recupero,
             val_esposizione,
             val_rdv_tot,
             val_imp_rettifica_pregr,
             val_imp_rettifica_att,
             flg_tipo_dato,
             'BATCH' cod_utente,
             val_attualizzato,
             flg_pres_piano,
             cod_tipo_rapporto,
             p_proto_delibera,
             s.flg_attiva,
             SYSDATE,
             SYSDATE,
             'BATCH' cod_operatore_ins_upd,
             s.cod_classe_ft,
             flg_ristrutturato,
             val_utilizzato_netto,
             val_utilizzato_mora,
             val_perc_rett_rapporto,
             val_accordato,
             cod_microtipologia_delibera,
             cod_npe,
             flg_tipo_rapporto,
             s.cod_forma_tecnica,
             dta_inizio_segnalazione_ristr,
             dta_fine_segnalazione_ristr,
             dta_decorrenza_stato
        FROM t_mcrei_app_stime s,
             t_mcrei_app_pcr_rapporti p,
             (SELECT r.*
                FROM t_mcre0_app_mig_recode_rapp r,
                     t_mcre0_app_mig_recode_ndg  n
               WHERE n.cod_abi_old = r.cod_abi_old
                 AND n.cod_ndg_old = r.cod_ndg_old) r --rapporti effettivamente migrati
       WHERE s.cod_abi = p_cod_abi --'01025'
         AND s.cod_ndg = p_cod_ndg --'0009981845826000'
         AND s.cod_protocollo_delibera = p_delibera_cedente
         AND s.cod_abi = p.cod_abi
         AND s.cod_ndg = p.cod_ndg
         AND s.cod_rapporto = p.cod_rapporto
         AND s.cod_abi = r.cod_abi_old(+)
         AND s.cod_ndg = r.cod_ndg_old(+)
         AND s.cod_rapporto = r.cod_rapporto_old(+)
         AND r.cod_rapporto_old IS NULL;

    pkg_mcrei_audit.log_app('clona_stime_cedente',
                            pkg_mcrei_audit.c_debug,
                            SQLCODE,
                            'recupero stime ' || p_cod_abi || ' ' ||
                            p_cod_ndg,
                            SQL%ROWCOUNT || ' stime inserite',
                            'BATCH');

    --clono le stime batch legate ai rapporti non migrati
    INSERT INTO t_mcrei_app_stime_batch
      (id_dper,
       cod_abi,
       cod_sndg,
       cod_ndg,
       cod_rapporto,
       dta_stima,
       desc_causa_prev_recupero,
       flg_recupero_tot,
       cod_uo_stima,
       val_imp_prev_pregr,
       val_imp_prev_att,
       val_prev_recupero,
       val_esposizione,
       val_rdv_tot,
       val_imp_rettifica_pregr,
       val_imp_rettifica_att,
       flg_tipo_dato,
       cod_utente,
       val_attualizzato,
       flg_pres_piano,
       cod_tipo_rapporto,
       cod_protocollo_delibera,
       --flg_attiva,
       dta_ins,
       dta_upd,
       cod_operatore_ins_upd,
       cod_classe_ft,
       flg_ristrutturato,
       val_utilizzato_netto,
       val_utilizzato_mora,
       val_perc_rett_rapporto,
       val_accordato,
       cod_microtipologia_delibera,
       cod_npe,
       flg_tipo_rapporto,
       cod_forma_tecnica,
       dta_inizio_segnalazione_ristr,
       dta_fine_segnalazione_ristr,
       dta_decorrenza_stato)
      SELECT to_number(to_char(SYSDATE, 'YYYYMMDD')) id_dper,
             p_cod_abi,
             cod_sndg,
             p_cod_ndg,
             s.cod_rapporto,
             dta_stima,
             desc_causa_prev_recupero,
             flg_recupero_tot,
             cod_uo_stima,
             val_imp_prev_pregr,
             val_imp_prev_att,
             val_prev_recupero,
             val_esposizione,
             val_rdv_tot,
             val_imp_rettifica_pregr,
             val_imp_rettifica_att,
             flg_tipo_dato,
             'BATCH' cod_utente,
             val_attualizzato,
             flg_pres_piano,
             cod_tipo_rapporto,
             p_proto_delibera,
             --flg_attiva,
             SYSDATE,
             SYSDATE,
             'BATCH' cod_operatore_ins_upd,
             cod_classe_ft,
             flg_ristrutturato,
             val_utilizzato_netto,
             val_utilizzato_mora,
             val_perc_rett_rapporto,
             val_accordato,
             cod_microtipologia_delibera,
             cod_npe,
             flg_tipo_rapporto,
             cod_forma_tecnica,
             dta_inizio_segnalazione_ristr,
             dta_fine_segnalazione_ristr,
             dta_decorrenza_stato
        FROM t_mcrei_app_stime_batch s,
             (SELECT r.*
                FROM t_mcre0_app_mig_recode_rapp r,
                     t_mcre0_app_mig_recode_ndg  n
               WHERE n.cod_abi_old = r.cod_abi_old
                 AND n.cod_ndg_old = r.cod_ndg_old) r --rapporti effettivamente migrati
       WHERE s.cod_abi = p_cod_abi --'01025'
         AND s.cod_ndg = p_cod_ndg --'0009981845826000'
         AND s.cod_protocollo_delibera = p_delibera_cedente
         AND s.cod_abi = r.cod_abi_old(+)
         AND s.cod_ndg = r.cod_ndg_old(+)
         AND s.cod_rapporto = r.cod_rapporto_old(+)
         AND r.cod_rapporto_old IS NULL;

    pkg_mcrei_audit.log_app('clona_stime_cedente',
                            pkg_mcrei_audit.c_debug,
                            SQLCODE,
                            'recupero stime batch ' || p_cod_abi || ' ' ||
                            p_cod_ndg,
                            SQL%ROWCOUNT || ' stime inserite',
                            'BATCH');

    --clono i piani delle stime legate ai rapporti non migrati
    INSERT INTO t_mcrei_app_piani_rientro
      (id_dper,
       cod_abi,
       cod_sndg,
       cod_ndg,
       cod_rapporto,
       dta_stima,
       num_rata,
       dta_scadenza_rata,
       val_rata,
       dta_ins_piano,
       dta_upd_piano,
       cod_utente,
       cod_protocollo_delibera,
       flg_attiva,
       dta_ins,
       dta_upd,
       cod_operatore_ins_upd,
       cod_forma_tecnica)
      SELECT to_number(to_char(SYSDATE, 'YYYYMMDD')) id_dper,
             p_cod_abi,
             s.cod_sndg,
             p_cod_ndg,
             s.cod_rapporto,
             trunc(sysdate) as dta_stima,
             num_rata,
             dta_scadenza_rata,
             val_rata,
             dta_ins_piano,
             dta_upd_piano,
             cod_utente,
             cod_protocollo_delibera,
             s.flg_attiva,
             SYSDATE,
             SYSDATE,
             'BATCH',
             s.cod_forma_tecnica
        FROM t_mcrei_app_piani_rientro s,
             t_mcrei_app_pcr_rapporti p,
             (SELECT r.*
                FROM t_mcre0_app_mig_recode_rapp r,
                     t_mcre0_app_mig_recode_ndg  n
               WHERE n.cod_abi_old = r.cod_abi_old
                 AND n.cod_ndg_old = r.cod_ndg_old) r --rapporti effettivamente migrati
       WHERE s.cod_abi = p_cod_abi --'01025'
         AND s.cod_ndg = p_cod_ndg --'0009981845826000'
         AND s.cod_protocollo_delibera = p_delibera_cedente
         AND s.cod_abi = p.cod_abi
         AND s.cod_ndg = p.cod_ndg
         AND s.cod_rapporto = p.cod_rapporto
         AND s.cod_abi = r.cod_abi_old(+)
         AND s.cod_ndg = r.cod_ndg_old(+)
         AND s.cod_rapporto = r.cod_rapporto_old(+)
         AND r.cod_rapporto_old IS NULL;

    pkg_mcrei_audit.log_app('clona_stime_cedente',
                            pkg_mcrei_audit.c_debug,
                            SQLCODE,
                            'recupero stime ' || p_cod_abi || ' ' ||
                            p_cod_ndg,
                            SQL%ROWCOUNT || ' piani inseriti',
                            'BATCH');

    --commit;
    RETURN 1;

  EXCEPTION
    WHEN OTHERS THEN
      --rollback;
      pkg_mcrei_audit.log_app(c_package || '.clona_stime_cedente',
                              pkg_mcrei_audit.c_debug,
                              SQLCODE,
                              SQLERRM,
                              'errore nella clonazione stime/piani ' ||
                              p_cod_abi || ' ' || p_cod_ndg,
                              'BATCH');
      RETURN 0;

  END clona_stime_cedente;

  -- %author reply
  -- %version 0.1
  -- %usage  Funzione di pulizia delle delibere in stato inserito
  -- %d La function annulla tutte le delibere che, ante migrazione, sono rimaste in stato IN sul cruscotto
  -- %param  p_cod_abi
  -- %param  p_cod_ndg
  -- %param  p_proto_delibera
  -- %cd 9 jul 2012
  FUNCTION annulla_delibere_ins_cedenti RETURN NUMBER IS

    c_nome CONSTANT VARCHAR2(100) := c_package ||
                                     '.annulla_delibere_ins_cedenti';
  BEGIN

    MERGE INTO t_mcrei_app_delibere d
    USING (SELECT *
             FROM t_mcre0_app_mig_recode_ndg
            WHERE nvl(flg_pres_cruscotto, 0) = 1) n
    ON (cod_abi = cod_abi_old AND cod_ndg = cod_ndg_old)
    WHEN MATCHED THEN
      UPDATE
         SET cod_fase_delibera       = 'AN',
             cod_fase_microtipologia = 'ANM',
             cod_fase_pacchetto      = 'ANM',
             desc_note               = 'Annullata causa migrazione del ' ||
                                       to_char(SYSDATE, 'dd/mm/yyyy') ||
                                       ' verso ' || cod_abi_new,
             dta_upd                 = SYSDATE,
             dta_last_upd_delibera   = SYSDATE,
             cod_operatore_ins_upd   = 'BATCH MIGRAZIONE'
       WHERE (cod_fase_delibera IN ('IN', 'CM') OR
             cod_fase_microtipologia = 'ATT')
         AND cod_tipo_pacchetto = 'M'
         AND flg_attiva = '1';

    COMMIT;
    RETURN 1;
  EXCEPTION
    WHEN OTHERS THEN
      pkg_mcrei_audit.log_app(c_nome,
                              pkg_mcrei_audit.c_debug,
                              SQLCODE,
                              SQLERRM,
                              'errore annullamento delibere ',
                              'BATCH');
      ROLLBACK;
      RETURN 0;
  END;

  -- %author reply
  -- %version 0.1
  -- %usage  Funzione di popolamento della tabella delibere usata dal batch per il BS
  -- %d La function popola la tabella letta dal BS per comunicare a HOST i dati relativi all adelibera di impianto
  -- %d generata in automatico
  -- %param  p_cod_abi
  -- %param  p_cod_ndg
  -- %param  p_proto_delibera
  -- %cd 9 jul 2012
FUNCTION popola_tab_mig_mor5(p_abi       t_mcrei_app_delibere.cod_abi%TYPE,
                             p_ndg       t_mcrei_app_delibere.cod_ndg%TYPE,
                             p_proto_del t_mcrei_app_delibere.cod_protocollo_delibera%TYPE)
  RETURN NUMBER IS

  p_note t_mcrei_wrk_audit_applicativo.note%TYPE;
BEGIN

  p_note := 'Controllo parametri input' || p_abi || ', ' || p_ndg || ', ' ||
            p_proto_del;

  IF p_abi IS NULL OR
     p_ndg IS NULL OR
     p_proto_del IS NULL

  THEN
    raise_application_error(-20666, 'Null parameter');
  END IF;

  p_note := 'POPOLA MIG_MOR5 PER DELIBERA DI IMPIANTO CON PROTO_dELIB= ' ||
            p_proto_del;
  INSERT INTO t_mcre0_mig_mor5
    (cod_abi,
     cod_matricola_utente,
     cod_funzione,
     val_anno_pratica,
     numero_pratica,
     stato_pratica,
     dta_pratica,
     cod_protocollo_delibera,
     cod_protocollo_pacchetto,
     cod_ndg,
     desc_nome_controparte,
     cod_struttura_competente_fi,
     desc_struttura_competente_fi,
     cod_comparto,
     val_anno_proposta,
     val_progr_proposta,
     dta_passaggio_stato_rischio,
     cod_microtipologia_delib,
     cod_stato_delibera,
     dta_aggiornamento_delibera,
     cod_organo_deliberante,
     desc_organo_deliberante,
     dta_delibera,
     desc_gruppo,
     val_esp_lorda_capitale_mora,
     val_esp_lorda_qt_cap,
     val_esp_lorda_qt_mora,
     val_rett_qt_cap_ante98,
     val_rett_qt_cap_ante_del,
     val_rett_qt_mora,
     val_esp_netta_ante_del,
     val_rett_qt_cap_del,
     val_rett_qt_cap_progr,
     val_esp_netta_post_del,
     val_importo_sacrificio,
     val_importo_offerto,
     val_esp_lorda_tot,
     val_utilizzo_sicli,
     val_capitale_sicli,
     val_mora_sicli,
     desc_cognome_utente,
     val_esp_complessiva_da_val,
     val_tot_rett_calcolata,
     cod_uo_pratica,
     cod_stato_rischio,
     cod_organo_calcolato,
     dta_inizio_rapporti,
     dta_fine_gestione,
     flg_esito,
     val_perc_rett_val,
     desc_note)
    SELECT d.cod_abi,
           u.cod_matricola,
           'CO',
           p.val_anno_pratica,
           p.cod_pratica,
           'APERTA',
           dta_apertura,
           d.cod_protocollo_delibera,
           d.cod_protocollo_pacchetto,
           d.cod_ndg,
           desc_nome_controparte,
           cod_filiale,
           '-',
           nvl(g.cod_comparto_assegnato, cod_comparto_calcolato),
           val_anno_proposta,
           d.val_progr_proposta,
           p.dta_decorrenza_stato, --dta_passaggio_stato_rischio,
           d.cod_microtipologia_delib,
           d.cod_fase_delibera,
           SYSDATE,
           d.cod_organo_deliberante,
           'Organo di Impianto', --desc_organo_deliberante,
           d.dta_delibera,
           '-',
           nvl(d.val_esp_lorda, 0),
           nvl(d.val_esp_lorda, 0),
           0,
           0,
           0,
           0,
           0,
           nvl(d.val_rdv_qc_progressiva, 0),
           nvl(d.val_rdv_qc_progressiva, 0) + nvl(d.val_rdv_progr_fi, 0),
           0,
           0,
           0,
           nvl(d.val_esp_lorda, 0) + nvl(d.val_esp_firma, 0),
           0,
           0,
           0,
           u.cognome,
           nvl(d.val_esp_lorda, 0) + nvl(d.val_esp_firma, 0),
           nvl(d.val_rdv_qc_progressiva, 0) + nvl(d.val_rdv_progr_fi, 0),
           p.cod_uo_pratica,
           g.cod_stato,
           '-',
           p.dta_decorrenza_stato,
           p.dta_fine_gestione,
           NULL,
           d.val_perc_rdv,
           d.desc_note
      FROM t_mcrei_app_delibere d,
           v_mcrei_app_pratiche p,--1011. per corretto calcolo fine gestione
           t_mcre0_app_all_data g,
           t_mcre0_app_utenti   u
     WHERE d.cod_abi = p.cod_abi
       AND d.cod_ndg = p.cod_ndg
       and d.cod_protocollo_delibera = p.cod_protocollo_delibera --1011
       AND d.cod_abi = g.cod_abi_cartolarizzato(+)
       AND d.cod_ndg = g.cod_ndg(+)
       AND g.today_flg(+) = 1
       AND d.cod_microtipologia_delib IN ('IM', 'IF')
       AND d.cod_tipo_pacchetto = 'I'
       AND d.flg_attiva = '1'
       AND p.flg_attiva = '1'
       AND d.cod_abi = p_abi
       AND d.cod_ndg = p_ndg
       AND d.cod_protocollo_delibera = p_proto_del
	   AND G.ID_UTENTE = u.ID_UTENTE;

  --COMMIT;
  RETURN 1;

EXCEPTION
  WHEN OTHERS THEN
    --              ROLLBACK;

    pkg_mcrei_audit.log_app('Delib di impianto:POPOLA_MIG_MOR5',
                            pkg_mcrei_audit.c_debug,
                            SQLCODE,
                            SQLERRM,
                            p_note,
                            'BATCH');

    RETURN 0;

END popola_tab_mig_mor5;

  -- %author reply
  -- %version 0.1
  -- %usage  Funzione di popolamento della tabella contenente i dati dei piani usata dal batch per il BS
  -- %d La function popola la tabella dei piani (con le rate) letta dal BS per comunicare a HOST i dati relativi all adelibera di impianto
  -- %d generata in automatico
  -- %param  p_cod_abi
  -- %param  p_cod_ndg
  -- %param  p_proto_delibera
  -- %cd 9 jul 2012
  FUNCTION popola_tab_mig_mor5_rate(p_abi       t_mcrei_app_delibere.cod_abi%TYPE,
                                    p_ndg       t_mcrei_app_delibere.cod_ndg%TYPE,
                                    p_proto_del t_mcrei_app_delibere.cod_protocollo_delibera%TYPE)
    RETURN NUMBER IS

    p_note t_mcrei_wrk_audit_applicativo.note%TYPE;
  BEGIN

    p_note := 'Controllo parametri input' || p_abi || ', ' || p_ndg || ', ' ||
              p_proto_del;

    IF p_abi IS NULL OR
       p_ndg IS NULL OR
       p_proto_del IS NULL

    THEN
      raise_application_error(-20666, 'Null parameter');
    END IF;

    p_note := 'POPOLA MIG_MOR5_RATE PER DELIBERA DI IMPIANTO CON PROTO_dELIB= ' ||
              p_proto_del;
    INSERT INTO t_mcre0_mig_mor5_rate
      (cod_rapporto,
       dta_ins_piano,
       dta_aggior_piano,
       numero_rata,
       val_importo_rata,
       dta_scadenza_rata,
       cod_protocollo_delibera,
       cod_protocollo_pacchetto)
      SELECT cod_rapporto,
             p.dta_ins_piano,
             dta_upd_piano,
             num_rata,
             p.val_rata,
             dta_scadenza_rata,
             d.cod_protocollo_delibera,
             d.cod_protocollo_pacchetto
        FROM t_mcrei_app_piani_rientro p,
             t_mcrei_app_delibere      d
       WHERE d.cod_abi = p.cod_abi
         AND d.cod_ndg = p.cod_ndg
         AND d.cod_protocollo_delibera = p.cod_protocollo_delibera
         AND cod_microtipologia_delib IN ('IM', 'IF')
         AND cod_tipo_pacchetto = 'I'
         AND d.flg_attiva = '1'
         AND p.flg_attiva = '1'
         AND d.cod_abi = p_abi
         AND d.cod_ndg = p_ndg
         AND d.cod_protocollo_delibera = p_proto_del;

    --COMMIT;
    RETURN 1;

  EXCEPTION
    WHEN OTHERS THEN
      --ROLLBACK;

      pkg_mcrei_audit.log_app('Delib di impianto:POPOLA_MIG_MOR5_RATE',
                              pkg_mcrei_audit.c_debug,
                              SQLCODE,
                              SQLERRM,
                              p_note,
                              NULL);

      RETURN 0;

  END popola_tab_mig_mor5_rate;

  -- %author reply
  -- %version 0.1
  -- %usage  Funzione di popolamento della tabella contenente i rapporti usata dal batch per il BS
  -- %d La function popola la tabella dei rapporti letta dal BS per comunicare a HOST i dati relativi all adelibera di impianto
  -- %d generata in automatico
  -- %param  p_cod_abi
  -- %param  p_cod_ndg
  -- %param  p_proto_delibera
  -- %cd 9 jul 2012
  FUNCTION popola_tab_mig_mor5_rapp(p_abi       t_mcrei_app_delibere.cod_abi%TYPE,
                                    p_ndg       t_mcrei_app_delibere.cod_ndg%TYPE,
                                    p_proto_del t_mcrei_app_delibere.cod_protocollo_delibera%TYPE)
    RETURN NUMBER IS

    p_note t_mcrei_wrk_audit_applicativo.note%TYPE;
  BEGIN

    p_note := 'Controllo parametri input' || p_abi || ', ' || p_ndg || ', ' ||
              p_proto_del;

    IF p_abi IS NULL OR
       p_ndg IS NULL OR
       p_proto_del IS NULL

    THEN
      raise_application_error(-20666, 'Null parameter');
    END IF;

    p_note := 'POPOLA MIG_MOR5_RAPP PER DELIBERA DI IMPIANTO CON PROTO_dELIB= ' ||
              p_proto_del;

    INSERT INTO t_mcre0_mig_mor5_rapp
      (cod_rapporto,
       val_netto_rapporto,
       val_utilizzato_firma,
       flg_ind_recupero_tot,
       cod_tipo_dato,
       val_rett_effettuata,
       val_stima_recupero,
       val_rett_livello_rapporto,
       flg_ind_piano,
       cod_rapporto_npe,
       cod_tipo_rapporto,
       val_rett_rapp_operativi_progr,
       val_perc_rett_rapp_firma,
       cod_protocollo_delibera,
       cod_protocollo_pacchetto)
      SELECT s.cod_rapporto,
             decode(cod_classe_ft, 'CA', val_esposizione, 0) AS val_netto_rapporto,
             decode(cod_classe_ft, 'FI', val_esposizione, 0) AS val_utilizzato_firma,
             decode (s.flg_recupero_tot,'Y','S',S.flg_recupero_tot) AS flg_ind_recupero_tot,--27 SETTEMBRE
             s.flg_tipo_dato AS cod_tipo_dato,
             round(decode(s.cod_classe_ft, 'CA', s.val_rdv_tot, 0), 2) AS val_rett_effettuata,
             s.val_prev_recupero AS val_stima_recupero, --27 luglio
             decode(s.cod_classe_ft, 'FI', s.val_rdv_tot, 0) AS val_rett_livello_rapporto,
             nvl(s.flg_pres_piano, 'N') AS flg_ind_piano,
             s.cod_npe AS cod_rapporto_npe,
             CASE
               WHEN s.cod_classe_ft = 'CA' AND
                    s.flg_tipo_dato = 'R' THEN
                'O'
               WHEN s.cod_classe_ft = 'CA' AND
                    s.flg_tipo_dato = 'S' THEN
                'R'
               WHEN s.cod_classe_ft = 'FI' THEN
                'F'
             END AS cod_tipo_rapporto,
             nvl(d.val_rdv_rapp_operativi, 0) AS val_rett_rapp_operativi_progr,
             nvl(d.val_perc_rett_rapp_firma, 0) AS val_perc_rett_rapp_firma,
             d.cod_protocollo_delibera,
             d.cod_protocollo_pacchetto
        FROM t_mcrei_app_stime    s,
             t_mcrei_app_delibere d
       WHERE s.cod_abi = d.cod_abi
         AND s.cod_ndg = d.cod_ndg
         AND s.cod_protocollo_delibera = d.cod_protocollo_delibera
         AND d.cod_microtipologia_delib IN ('IM', 'IF')
         AND d.cod_tipo_pacchetto = 'I'
         AND s.cod_abi = p_abi
         AND s.cod_ndg = p_ndg
         AND s.cod_protocollo_delibera = p_proto_del;
    --COMMIT;
    RETURN 1;

  EXCEPTION
    WHEN OTHERS THEN
      -- ROLLBACK;

      pkg_mcrei_audit.log_app('Delib di impianto:POPOLA_MIG_MOR5_RAPP',
                              pkg_mcrei_audit.c_debug,
                              SQLCODE,
                              SQLERRM,
                              p_note,
                              NULL);

      RETURN 0;

  END popola_tab_mig_mor5_rapp;

  -- %AUTHOR
  -- %VERSION 0.1
  -- %USAGE FUNCTION CHE AGGIORNA I FLAG DI ESITO PER L'ALERT E/O PER LA TABELLA DEI CONFERIMENTI
  -- %D LA FUNCTION, SE P_FLG_ESITO SETTATO LO IMPOSTA SULLA TABELLA DEI CONFERIMENTI
  -- %D SE P_FLG_ALERT SETTATO LO IMPOSTA SULLA TABELLA DELL'ALERT DEI CONFERIMENTI
  -- %CD 13 JUL 2012
  FUNCTION setta_esito_conferimento(p_proto_pacchetto IN t_mcre0_mig_mor5.cod_protocollo_pacchetto%TYPE,
                                    p_proto_delibera  IN t_mcre0_mig_mor5.cod_protocollo_delibera%TYPE,
                                    p_cod_abi         IN t_mcre0_mig_mor5.cod_abi%TYPE,
                                    p_cod_ndg         IN t_mcre0_mig_mor5.cod_ndg%TYPE,
                                    p_flg_esito       IN t_mcre0_mig_mor5.flg_esito%TYPE DEFAULT NULL, --Valori possibili: [NULL, 'Y', 'N']
                                    p_flg_alert       IN NUMBER DEFAULT NULL --Valori possibili: [NULL, 0, 1, 2]
                                    ) RETURN NUMBER IS
    c_nome CONSTANT VARCHAR2(100) := c_package ||
                                     '.SETTA_ESITO_CONFERIMENTO';
    p_note t_mcrei_wrk_audit_applicativo.note%TYPE;
  BEGIN

    p_note := 'Controllo parametri in ingresso: ' || p_proto_pacchetto || ', ' ||
              p_proto_delibera || ', ' || p_cod_abi || ', ' || p_cod_ndg || ', ' ||
              p_flg_esito || ', ' || p_flg_alert;

    --Esito job
    IF p_flg_esito IS NOT NULL AND
       (p_proto_pacchetto IS NULL OR p_proto_delibera IS NULL)
    THEN
      raise_application_error(-20666, 'Null parameter');
    ELSE
      p_note := 'UPDATE T_MCRE0_MIG_MOR5 setta esito conferimento:' ||
                p_proto_pacchetto || ', ' || p_proto_delibera || ', ' ||
                p_flg_esito;

      UPDATE t_mcre0_mig_mor5
         SET flg_esito = p_flg_esito
       WHERE cod_protocollo_pacchetto = p_proto_pacchetto
         AND cod_protocollo_delibera = p_proto_delibera;
    END IF;

    --Esito alert
    IF p_flg_alert IS NOT NULL AND
       (p_cod_abi IS NULL OR p_cod_ndg IS NULL)
    THEN
      raise_application_error(-20666, 'Null parameter');
    ELSE
      p_note := 'UPDATE T_MCRE0_... setta esito alert conferimento:' ||
                p_cod_abi || ', ' || p_cod_ndg || ', ' || p_flg_alert;

      --TODO
      UPDATE t_mcre0_app_mig_recode_ndg r
         SET r.flg_presa_visione = p_flg_alert
       WHERE cod_abi_new = p_cod_abi
         AND cod_ndg_new = p_cod_ndg;

      --TODO
      UPDATE t_mcre0_hst_mig_recode_ndg r
         SET r.flg_presa_visione = p_flg_alert
       WHERE cod_abi_new = p_cod_abi
         AND cod_ndg_new = p_cod_ndg;

    END IF;

    pkg_mcrei_audit.log_app(c_nome,
                            pkg_mcrei_audit.c_debug,
                            SQLCODE,
                            SQLERRM,
                            p_note,
                            NULL);
    RETURN ok;

  EXCEPTION
    WHEN OTHERS THEN
      pkg_mcrei_audit.log_app(c_nome,
                              pkg_mcrei_audit.c_error,
                              SQLCODE,
                              SQLERRM,
                              p_note,
                              NULL);
      RETURN ko;

  END setta_esito_conferimento;

  -- %author reply
  -- %version 0.1
  -- %usage  Funzione di
  -- %d La function
  -- %d
  -- %param  p_cod_abi
  -- %param  p_cod_ndg
  -- %param  p_proto_delibera
  -- %cd 9 jul 2012
  FUNCTION recupera_stime_ricevente(p_cod_abi VARCHAR2, p_cod_ndg VARCHAR2)
    RETURN NUMBER IS

    v_delibera_rv t_mcrei_app_delibere.cod_protocollo_delibera%TYPE;

  BEGIN

    --1) recupero il protocollo dell'ultima rettifica confermata (RV, A0, T4) SE C'E'..
    BEGIN
      SELECT cod_protocollo_delibera
        INTO v_delibera_rv
        FROM (SELECT cod_protocollo_delibera
                FROM t_mcrei_app_delibere d
               WHERE d.cod_abi = p_cod_abi
                 AND d.cod_ndg = p_cod_ndg
                 AND d.cod_microtipologia_delib IN ('RV', 'T4', 'A0') -- <-- tutte le tipologie di rettifica?!
                    --and d.cod_fase_pacchetto in ('ULT') --corretto?!
                 AND d.cod_fase_delibera IN ('AD', 'CO', 'CT', 'NA')
                 AND d.flg_no_delibera = 0
                 AND flg_attiva = '1'
              --and cod_tipo_pacchetto = 'M'--opportuno ribadire?!
               ORDER BY --s.dta_upd_fase_delibera  DESC,
                        d.val_num_progr_delibera DESC,
                        d.dta_conferma_delibera  DESC)
       WHERE rownum <= 1;
    EXCEPTION
      WHEN no_data_found THEN

        pkg_mcrei_audit.log_app('recupera_stime_ricevente',
                                pkg_mcrei_audit.c_debug,
                                SQLCODE,
                                SQLERRM,
                                'recupero stime ' || p_cod_abi || ' ' ||
                                p_cod_ndg || 'nessuna delibera RV trovata',
                                'BATCH');
        RETURN 1;
    END;

    --2)clono le stime legate ai rapporti gia' esistenti non migrati
    INSERT INTO t_mcrei_tmp_stime_conferimenti
      (id_dper,
       cod_abi,
       cod_sndg,
       cod_ndg,
       cod_rapporto,
       dta_stima,
       desc_causa_prev_recupero,
       flg_recupero_tot,
       cod_uo_stima,
       val_imp_prev_pregr,
       val_imp_prev_att,
       val_prev_recupero,
       val_esposizione,
       val_rdv_tot,
       val_imp_rettifica_pregr,
       val_imp_rettifica_att,
       flg_tipo_dato,
       cod_utente,
       val_attualizzato,
       flg_pres_piano,
       cod_tipo_rapporto,
       cod_protocollo_delibera,
       dta_ins,
       dta_upd,
       cod_operatore_ins_upd,
       cod_classe_ft,
       flg_ristrutturato,
       val_utilizzato_netto,
       val_utilizzato_mora,
       val_perc_rett_rapporto,
       val_accordato,
       cod_microtipologia_delibera,
       cod_npe,
       flg_tipo_rapporto,
       cod_forma_tecnica,
       dta_inizio_segnalazione_ristr,
       dta_fine_segnalazione_ristr,
       dta_decorrenza_stato)
      SELECT to_number(to_char(SYSDATE, 'YYYYMMDD')) id_dper,
             p_cod_abi,
             s.cod_sndg,
             p_cod_ndg,
             s.cod_rapporto,
             dta_stima,
             desc_causa_prev_recupero,
             flg_recupero_tot,
             cod_uo_stima,
             val_imp_prev_pregr,
             val_imp_prev_att,
             val_prev_recupero,
             val_esposizione,
             val_rdv_tot,
             val_imp_rettifica_pregr,
             val_imp_rettifica_att,
             flg_tipo_dato,
             'BATCH' AS cod_utente,
             val_attualizzato,
             flg_pres_piano,
             cod_tipo_rapporto,
             NULL cod_protocollo_delibera,
             SYSDATE,
             SYSDATE,
              'recupero da cedente' AS cod_operatore_ins_upd,---CORRETTO IL 26 SEP
             s.cod_classe_ft,
             flg_ristrutturato,
             val_utilizzato_netto,
             val_utilizzato_mora,
             val_perc_rett_rapporto,
             val_accordato,
             cod_microtipologia_delibera,
             cod_npe,
             flg_tipo_rapporto,
             s.cod_forma_tecnica,
             dta_inizio_segnalazione_ristr,
             dta_fine_segnalazione_ristr,
             dta_decorrenza_stato
        FROM t_mcrei_app_stime s,
             t_mcrei_app_pcr_rapporti p, --SOLO RAPPORTI ANCORA ATTIVI
             (SELECT DISTINCT r.*
                FROM t_mcre0_app_mig_recode_rapp r,
                     t_mcre0_app_mig_recode_ndg  n
               WHERE n.cod_abi_new = r.cod_abi_new
                 AND n.cod_ndg_new = r.cod_ndg_new) r --rapporti effettivamente migrati
       WHERE s.cod_abi = p_cod_abi --'01025'
         AND s.cod_ndg = p_cod_ndg --'0009981845826000'
         AND s.cod_protocollo_delibera = v_delibera_rv
         AND s.cod_abi = p.cod_abi
         AND s.cod_ndg = p.cod_ndg
         AND s.cod_rapporto = p.cod_rapporto --solo stime di rapporti ancora vivi
         AND s.cod_abi = r.cod_abi_new(+)
         AND s.cod_ndg = r.cod_ndg_new(+)
         AND s.cod_rapporto = r.cod_rapporto_new(+)
         AND r.cod_rapporto_new IS NULL
			UNION
			SELECT to_number(to_char(SYSDATE, 'YYYYMMDD')) id_dper,
             p_cod_abi,
             s.cod_sndg,
             p_cod_ndg,
             s.cod_rapporto,
             dta_stima,
             desc_causa_prev_recupero,
             flg_recupero_tot,
             cod_uo_stima,
             val_imp_prev_pregr,
             val_imp_prev_att,
             val_prev_recupero,
             val_esposizione,
             val_rdv_tot,
             val_imp_rettifica_pregr,
             val_imp_rettifica_att,
             flg_tipo_dato,
               'BATCH' AS cod_utente,
             val_attualizzato,
             flg_pres_piano,
             cod_tipo_rapporto,
             NULL cod_protocollo_delibera,
             SYSDATE,
             SYSDATE,
              'recupero da cedente' AS cod_operatore_ins_upd,
             s.cod_classe_ft,
             flg_ristrutturato,
             val_utilizzato_netto,
             val_utilizzato_mora,
             val_perc_rett_rapporto,
             val_accordato,
             cod_microtipologia_delibera,
             cod_npe,
             flg_tipo_rapporto,
             s.cod_forma_tecnica,
             dta_inizio_segnalazione_ristr,
             dta_fine_segnalazione_ristr,
             dta_decorrenza_stato
        FROM t_mcrei_app_stime_batch s,
             t_mcrei_app_pcr_rapporti p,
             (SELECT DISTINCT r.*
                FROM t_mcre0_app_mig_recode_rapp r,
                     t_mcre0_app_mig_recode_ndg  n
               WHERE n.cod_abi_new = r.cod_abi_new
                 AND n.cod_ndg_new = r.cod_ndg_new) r --rapporti effettivamente migrati
       WHERE s.cod_abi = p_cod_abi --'01025'
         AND s.cod_ndg = p_cod_ndg --'0009981845826000'
         AND s.cod_protocollo_delibera = v_delibera_rv
         AND s.cod_abi = p.cod_abi
         AND s.cod_ndg = p.cod_ndg
         AND s.cod_rapporto = p.cod_rapporto --solo stime di rapporti ancora vivi
         AND s.cod_abi = r.cod_abi_new(+)
         AND s.cod_ndg = r.cod_ndg_new(+)
         AND s.cod_rapporto = r.cod_rapporto_new(+)
         AND r.cod_rapporto_new IS NULL;

    pkg_mcrei_audit.log_app('recupera_stime_ricevente',
                            pkg_mcrei_audit.c_debug,
                            SQLCODE,
                            'recupero stime ' || p_cod_abi || ' ' ||
                            p_cod_ndg,
                            SQL%ROWCOUNT || ' stime inserite',
                            'BATCH');

    --clono i piani delle stime legate ai rapporti non migrati
    INSERT INTO t_mcrei_tmp_piani_rientro_conf
      (id_dper,
       cod_abi,
       cod_sndg,
       cod_ndg,
       cod_rapporto,
       dta_stima,
       num_rata,
       dta_scadenza_rata,
       val_rata,
       dta_ins_piano,
       dta_upd_piano,
       cod_utente,
       cod_protocollo_delibera,
       flg_attiva,
       dta_ins,
       dta_upd,
       cod_operatore_ins_upd,
       cod_forma_tecnica)
      SELECT to_number(to_char(SYSDATE, 'YYYYMMDD')) id_dper,
             p_cod_abi,
             s.cod_sndg,
             p_cod_ndg,
             s.cod_rapporto,
             dta_stima,
             num_rata,
             dta_scadenza_rata,
             val_rata,
             dta_ins_piano,
             dta_upd_piano,
             cod_utente,
             NULL cod_protocollo_delibera,
             s.flg_attiva,
             SYSDATE,
             SYSDATE,
             'recupero da cedente',
             s.cod_forma_tecnica
        FROM t_mcrei_app_piani_rientro s,
             t_mcrei_app_pcr_rapporti p,
             (SELECT DISTINCT r.*
                FROM t_mcre0_app_mig_recode_rapp r,
                     t_mcre0_app_mig_recode_ndg  n
               WHERE n.cod_abi_new = r.cod_abi_new
                 AND n.cod_ndg_new = r.cod_ndg_new) r --rapporti effettivamente migrati
       WHERE s.cod_abi = p_cod_abi --'01025'
         AND s.cod_ndg = p_cod_ndg --'0009981845826000'
         AND s.cod_protocollo_delibera = v_delibera_rv
         AND s.cod_abi = p.cod_abi
         AND s.cod_ndg = p.cod_ndg
         AND s.cod_rapporto = p.cod_rapporto --solo stime di rapporti ancora vivi
         AND s.cod_abi = r.cod_abi_new(+)
         AND s.cod_ndg = r.cod_ndg_new(+)
         AND s.cod_rapporto = r.cod_rapporto_new(+)
         AND r.cod_rapporto_new IS NULL;
    pkg_mcrei_audit.log_app('recupera_stime_ricevente',
                            pkg_mcrei_audit.c_debug,
                            SQLCODE,
                            'recupero stime ' || p_cod_abi || ' ' ||
                            p_cod_ndg,
                            SQL%ROWCOUNT || ' piani inseriti',
                            'BATCH');

    --commit;
    RETURN 1;

  EXCEPTION
    WHEN OTHERS THEN
      --rollback;
      pkg_mcrei_audit.log_app(c_package || '.recupera_stime_ricevente',
                              pkg_mcrei_audit.c_error,
                              SQLCODE,
                              SQLERRM,
                              'errore nella clonazione stime/piani ' ||
                              p_cod_abi || ' ' || p_cod_ndg,
                              'BATCH');
      RETURN 0;

  END recupera_stime_ricevente;

  -- %author reply
  -- %version 0.1
  -- %usage  Funzione di aggancio delle stime per le posizioni su banca cedente
  -- %d La function setta il protocollo delibera nella tabella delle stime extra per tutte le
  -- %d stime associate ai rapporti collegati alla posizione in input.
  -- %d Poi sposta il lotto di rapporti agganciati nella tabella delle stime
  -- %d infine, cancella il lotto dalla stime_extra
  -- %param  p_cod_abi
  -- %param  p_cod_ndg
  -- %param  p_proto_delibera
  -- %cd 9 jul 2012
  FUNCTION aggancia_stime(p_cod_abi        VARCHAR2,
                                  p_cod_ndg        VARCHAR2,
                                  p_proto_delibera VARCHAR2) RETURN NUMBER IS

  n number;

  BEGIN

    UPDATE t_mcrei_tmp_stime_conferimenti
       SET cod_protocollo_delibera = p_proto_delibera
     WHERE (cod_abi, cod_ndg, cod_rapporto, dta_stima) IN
           (SELECT cod_abi,
                   cod_ndg,
                   cod_rapporto,
                   dta_stima
              FROM (SELECT s.*,
                           (rank()
                            over(PARTITION BY s.cod_abi,
                                 s.cod_ndg,
                                 s.cod_rapporto ORDER BY s.dta_stima DESC)) rn
                      FROM t_mcrei_tmp_stime_conferimenti s
                     WHERE s.cod_abi = p_cod_abi
                       AND s.cod_ndg = p_cod_ndg) rs
             WHERE rn = 1);

    INSERT INTO t_mcrei_app_stime
      (id_dper,
       cod_abi,
       cod_sndg,
       cod_ndg,
       cod_rapporto,
       dta_stima,
       desc_causa_prev_recupero,
       flg_recupero_tot,
       cod_uo_stima,
       val_imp_prev_pregr,
       val_imp_prev_att,
       val_prev_recupero,
       val_esposizione,
       val_rdv_tot,
       val_imp_rettifica_pregr,
       val_imp_rettifica_att,
       flg_tipo_dato,
       cod_utente,
       val_attualizzato,
       flg_pres_piano,
       cod_tipo_rapporto,
       cod_protocollo_delibera,
       dta_ins,
       dta_upd,
       cod_operatore_ins_upd,
       cod_classe_ft,
       flg_ristrutturato,
       val_utilizzato_netto,
       val_utilizzato_mora,
       val_perc_rett_rapporto,
       val_accordato,
       cod_microtipologia_delibera,
       cod_npe,
       flg_tipo_rapporto,
       cod_forma_tecnica,
       dta_inizio_segnalazione_ristr,
       dta_fine_segnalazione_ristr,
       dta_decorrenza_stato,
			 FLG_ATTIVA)
      SELECT id_dper,
             cod_abi,
             cod_sndg,
             cod_ndg,
             cod_rapporto,
             trunc(sysdate), --dta_stima,
             desc_causa_prev_recupero,
             flg_recupero_tot,
             cod_uo_stima,
             val_imp_prev_pregr,
             val_imp_prev_att,
             val_prev_recupero,
             val_esposizione,
             val_rdv_tot,
             val_imp_rettifica_pregr,
             val_imp_rettifica_att,
             flg_tipo_dato,
             cod_utente,
             val_attualizzato,
             flg_pres_piano,
             cod_tipo_rapporto,
             cod_protocollo_delibera,
             dta_ins,
             sysdate, --dta_upd,
             'BATCH',--cod_operatore_ins_upd
             cod_classe_ft,
             flg_ristrutturato,
             val_utilizzato_netto,
             val_utilizzato_mora,
             val_perc_rett_rapporto,
             val_accordato,
             cod_microtipologia_delibera,
             cod_npe,
             flg_tipo_rapporto,
             cod_forma_tecnica,
             dta_inizio_segnalazione_ristr,
             dta_fine_segnalazione_ristr,
             dta_decorrenza_stato,
			 1 as FLG_ATTIVA
        FROM t_mcrei_tmp_stime_conferimenti s
       WHERE s.cod_abi = p_cod_abi
         AND s.cod_ndg = p_cod_ndg
         AND s.cod_protocollo_delibera = p_proto_delibera;

         n := sql%rowcount;

    DELETE t_mcrei_tmp_stime_conferimenti s
     WHERE s.cod_abi = p_cod_abi
       AND s.cod_ndg = p_cod_ndg;
       --AND s.cod_protocollo_delibera = p_proto_delibera ripulisco tutti i record tmp


    RETURN 1;

  EXCEPTION
    WHEN OTHERS THEN
      pkg_mcrei_audit.log_app(c_package || '.aggancia_stime_cedente',
                              pkg_mcrei_audit.c_error,
                              SQLCODE,
                              SQLERRM,
                              'errore nell''aggancio stime ' || p_cod_abi || ' ' ||
                              p_cod_ndg || ' ' || p_proto_delibera,
                              'BATCH');
      RETURN 0;

  END aggancia_Stime;

  -- %author reply
  -- %version 0.1
  -- %usage  Funzione di AGGANCIO DEI PIANI DI RIENTRO PER LE POSIZIONI SU BANCA CEDENTE
  -- %d La function setta il protocollo delibera nella tabella dei piani extra per tutti i
  -- %d piani associati ai rapporti collegati alla posizione IN input.
  -- %d Poi sposta il lotto di rapporti agganciati nella tabella dei piani di rientro
  -- %d infine, cancella il lotto dalla piani_extra
  -- %param  p_cod_abi
  -- %param  p_cod_ndg
  -- %param  p_proto_delibera
  -- %cd 9 jul 2012
  FUNCTION aggancia_piani(p_cod_abi        VARCHAR2,
                                  p_cod_ndg        VARCHAR2,
                                  p_proto_delibera VARCHAR2) RETURN NUMBER IS

  BEGIN

    UPDATE t_mcrei_tmp_piani_rientro_conf
       SET cod_protocollo_delibera = p_proto_delibera
     WHERE (cod_abi, cod_ndg, cod_rapporto, dta_stima) IN
           (SELECT cod_abi,
                   cod_ndg,
                   cod_rapporto,
                   dta_stima
              FROM (SELECT s.*,
                           (rank()
                            over(PARTITION BY s.cod_abi,
                                 s.cod_ndg,
                                 s.cod_rapporto ORDER BY s.dta_stima DESC)) rn
                      FROM t_mcrei_tmp_piani_rientro_conf s
                     WHERE s.cod_abi = p_cod_abi
                       AND s.cod_ndg = p_cod_ndg) rs
             WHERE rn = 1);

    INSERT INTO t_mcrei_tmp_piani_rientro_conf
      (id_dper,
       cod_abi,
       cod_sndg,
       cod_ndg,
       cod_rapporto,
       dta_stima,
       num_rata,
       dta_scadenza_rata,
       val_rata,
       dta_ins_piano,
       dta_upd_piano,
       cod_utente,
       cod_protocollo_delibera,
       flg_attiva,
       dta_ins,
       dta_upd,
       cod_operatore_ins_upd,
       cod_forma_tecnica)
      SELECT id_dper,
             cod_abi,
             cod_sndg,
             cod_ndg,
             cod_rapporto,
             trunc(sysdate), --dta_stima,
             num_rata,
             dta_scadenza_rata,
             val_rata,
             dta_ins_piano,
             dta_upd_piano,
             cod_utente,
             cod_protocollo_delibera,
             '1',
             dta_ins,
             sysdate, --dta_upd,
             'BATCH',--cod_operatore_ins_upd,
             cod_forma_tecnica
        FROM t_mcrei_app_piani_rientro_extr s
       WHERE s.cod_abi = p_cod_abi
         AND s.cod_ndg = p_cod_ndg
         AND s.cod_protocollo_delibera = p_proto_delibera;

    DELETE t_mcrei_tmp_piani_rientro_conf s
     WHERE s.cod_abi = p_cod_abi
       AND s.cod_ndg = p_cod_ndg;
       --AND s.cod_protocollo_delibera = p_proto_delibera --rimuovo tutto da tmp

    RETURN 1;

  EXCEPTION
    WHEN OTHERS THEN
      pkg_mcrei_audit.log_app(pkg_mcre0_gest_conferimenti.c_package ||
                              '.aggancia_piani_cedente',
                              pkg_mcrei_audit.c_error,
                              SQLCODE,
                              SQLERRM,
                              'errore nell''aggancio piani ' || p_cod_abi || ' ' ||
                              p_cod_ndg || ' ' || p_proto_delibera,
                              'BATCH');
      RETURN 0;

  END aggancia_piani;

  ---recupera gli abi indicanti il/i cendente/i
 FUNCTION recupera_abi_cedenti RETURN NUMBER IS
   RESULT         NUMBER;
   v_prev_ndg     VARCHAR2(20) := NULL;
   v_old_abi      VARCHAR2(20) := NULL;
   v_prev_abi_new VARCHAR2(20) := NULL;
 BEGIN
   FOR i IN (SELECT DISTINCT cod_abi_old,
                             cod_ndg_new,
                             cod_abi_new --,lag(cod_ndg_new,1) over (partition by cod_ndg_old,cod_ndg_new order by cod_abi_old)
               FROM t_mcre0_app_mig_recode_ndg e
              WHERE flg_pres_cruscotto = 1
              ORDER BY e.cod_ndg_new)
   LOOP
     --v_prev_ndg := i.cod_ndg_new;
     --v_curr_ndg := i.cod_ndg_new;
     CASE
       WHEN v_prev_ndg != i.cod_ndg_new THEN
       ---AGGIORNA LA POSIZIONE PRECEDENTE
			  UPDATE t_mcre0_app_mig_recode_ndg
            SET desc_list_abi_old = v_old_abi
          WHERE cod_abi_new = v_prev_abi_new
            AND cod_ndg_new = v_prev_ndg;
         COMMIT;
				 --PREVENTIVAMENTE AGGIORNA ANCHE LA POSIZIONE CORRENTE
         v_old_abi      := i.cod_abi_old;
         v_prev_ndg     := i.cod_ndg_new;
         v_prev_abi_new := i.cod_abi_new;

				UPDATE t_mcre0_app_mig_recode_ndg
            SET desc_list_abi_old = v_old_abi
          WHERE cod_abi_new = v_prev_abi_new
            AND cod_ndg_new = v_prev_ndg;
         COMMIT;

			 WHEN v_prev_ndg IS NULL THEN
         v_old_abi      := i.cod_abi_old;
         v_prev_ndg     := i.cod_ndg_new;
         v_prev_abi_new := i.cod_abi_new;
       ELSE
         v_old_abi      := v_old_abi || ',' || i.cod_abi_old;
         v_prev_ndg     := i.cod_ndg_new;
         v_prev_abi_new := i.cod_abi_new;
     END CASE;
   END LOOP;

   RETURN(RESULT);
 END recupera_abi_cedenti;

FUNCTION calcolo_classe_ft RETURN NUMBER IS

  res NUMBER := 1;
BEGIN

  MERGE INTO t_mcrei_app_stime_extra t
  USING (SELECT st.id_dper,
                st.cod_abi,
                st.cod_sndg,
                st.cod_ndg,
                st.cod_rapporto,
                st.dta_stima,
                st.desc_causa_prev_recupero,
                st.flg_recupero_tot,
                st.cod_uo_stima,
                st.val_imp_prev_pregr,
                st.val_imp_prev_att,
                st.val_prev_recupero,
                st.val_esposizione,
                st.val_rdv_tot,
                st.val_imp_rettifica_pregr,
                st.val_imp_rettifica_att,
                st.flg_tipo_dato,
                st.cod_utente,
                st.val_attualizzato,
                st.flg_pres_piano,
                st.cod_tipo_rapporto,
                st.cod_protocollo_delibera,
                p.cod_classe_ft,
                st.cod_npe,
                st.flg_tipo_rapporto,
                st.dta_decorrenza_stato
           FROM t_mcrei_app_stime_extra st,
                (SELECT cod_classe_ft,
                        cod_abi,
                        cod_ndg,
                        cod_rapporto
                   FROM (SELECT row_number() over(PARTITION BY cod_abi, cod_ndg, cod_rapporto ORDER BY cod_classe_ft) AS row_number,
                                cod_classe_ft,
                                cod_abi,
                                cod_ndg,
                                cod_rapporto
                           FROM t_mcrei_app_pcr_rapporti
                          WHERE cod_classe_ft IN ('CA', 'FI', 'ST'))
                  WHERE row_number = 1) p,
                (select distinct cod_abi_new, cod_ndg_new
                   from t_mcre0_app_mig_recode_ndg) ng              -- 26.07
          WHERE st.cod_abi = p.cod_abi(+)
            AND st.cod_ndg = p.cod_ndg(+)
            AND st.cod_abi = ng.cod_abi_new(+)
            AND st.cod_ndg = ng.cod_ndg_new(+)
            AND st.cod_rapporto = p.cod_rapporto(+)
            AND st.cod_classe_ft IS NULL) s
  ON (s.cod_abi = t.cod_abi AND s.cod_ndg = t.cod_ndg AND s.cod_rapporto = t.cod_rapporto AND s.dta_stima = t.dta_stima)
  WHEN MATCHED THEN
    UPDATE SET t.cod_classe_ft = s.cod_classe_ft;

  COMMIT;
  RETURN res;
EXCEPTION
  WHEN OTHERS THEN
    ROLLBACK;
    pkg_mcrei_audit.log_app('CALCOLA CLASSE FT',
                            pkg_mcrei_audit.c_error,
                            SQLCODE,
                            SQLERRM,
                            'FALLITO AGGANCIO CLASSE FT',
                            'BATCH');
    res := 0;
    RETURN res;
END calcolo_classe_ft;

  PROCEDURE crea_rdv_light(p_new_cod_abi       IN VARCHAR2,
                           p_new_cod_ndg       IN VARCHAR2,
                           p_utente            IN VARCHAR2,
                           p_lista_abi_old     IN VARCHAR2,
                           out_proto_delibera  OUT VARCHAR2,
                           out_proto_pacchetto OUT VARCHAR2,
                           out_esito           OUT NUMBER) ---1 OK, 0 KO
   AS
    c_nome CONSTANT VARCHAR2(100) := c_package || '.crea_delibera_impianto';
    p_note              t_mcrei_wrk_audit_applicativo.note%TYPE;
    v_sndg              t_mcre0_app_all_data.cod_sndg%TYPE;
    v_last_rdv_qc_progr NUMBER := 0;
    v_last_rdv_progr_fi NUMBER := 0;
    v_prot              t_mcrei_app_delibere.cod_protocollo_pacchetto%TYPE;
    v_tipo_gestione     t_mcrei_app_pratiche.cod_tipo_gestione%TYPE;

  BEGIN
    p_note := 'crea_delibera_impianto per' || p_new_cod_abi || ' ' ||
              p_new_cod_ndg;

    IF p_new_cod_ndg IS NULL OR
       p_new_cod_abi IS NULL
    THEN
      out_esito := 0;
      raise_application_error(-20666, 'Null parameter');
    END IF;

    BEGIN
      SELECT cod_sndg
        INTO v_sndg
        FROM t_mcre0_app_all_data
       WHERE cod_abi_cartolarizzato = p_new_cod_abi
         AND cod_ndg = p_new_cod_ndg;
    EXCEPTION
      WHEN OTHERS THEN
        v_sndg := '1000000000000000';
        pkg_mcrei_audit.log_app(c_nome,
                                pkg_mcrei_audit.c_ERROR,
                                SQLCODE,
                                SQLERRM,
                                'sndg non trovato',
                                'BATCH');
    END;

    SELECT v_sndg || '_' || mcre_own.seq_mcrei_pacchetto.nextval
      INTO v_prot
      FROM dual;

    ------RECUPERO LAST RDV CONFERMATA AL NETTO DI SUCCESSIVI STRALCI CONTABILIZZATI
    recupera_last_rdv_conf(p_cod_abi        => p_new_cod_abi,
                           p_cod_ndg        => p_new_cod_ndg,
                           v_last_rdv_cassa => v_last_rdv_qc_progr,
                           v_last_rdv_firma => v_last_rdv_progr_fi);

    /* \*recupero il tipo gestione:
    se la posizione ¿ condivisa, verifico la presenza di pi¿ cedenti a fronte di un ricevente e ne calcolo la somma delle esposizioni
    in caso contrario, recupero il tipo gestione dalla pratica) *\
    v_tipo_gestione := recupera_tipo_gestione(p_cod_abi  => p_new_cod_abi,
                                        p_cod_ndg  => p_new_cod_ndg,
                                        p_tipo_pos => v_flg_condiviso);

    */
    p_note := 'INSERT delibera light';

    INSERT INTO t_mcrei_app_delibere d
      (id_dper,
       cod_sndg,
       cod_abi,
       cod_ndg,
       cod_protocollo_pacchetto,
       cod_protocollo_delibera,
       flg_attiva,
       cod_microtipologia_delib,
       val_rdv_qc_progressiva,
       --val_esp_netta_post_delib,
       val_rdv_qc_ante_delib,
       --val_esp_netta_ante_delib,
       val_rdv_qc_deliberata,
       val_esp_lorda,
       val_esp_firma,
       val_uti_cassa_scsb,
       val_uti_firma_scsb,
       val_uti_tot_scsb,
       cod_fase_delibera,
       cod_fase_microtipologia,
       cod_fase_pacchetto,
       dta_creazione_pacchetto,
       dta_ins_delibera,
       cod_tipo_pacchetto,
       cod_matricola_inserente,
       cod_macrotipologia_delib,
       cod_pratica,
       val_anno_pratica,
       cod_uo_pratica,
       cod_segmento,
       desc_denominaz_ins_delibera,
       cod_filiale_delibera,
       val_num_progr_delibera,
       flg_no_delibera,
       val_rdv_pregr_fi,
       val_rdv_progr_fi,
       desc_note,
       dta_delibera,
       cod_organo_deliberante)
      (SELECT to_number(to_char(trunc(SYSDATE), 'YYYYMMDD')),
              g.cod_sndg,
              g.cod_abi_cartolarizzato,
              g.cod_ndg,
              v_prot, ----proto_pacchetto
              mcre_own.pkg_mcrei_gest_delibere.fnc_mcrei_protocollo_delibera(p.cod_uo_pratica,
                                                                             'BATCH',
                                                                             g.cod_abi_cartolarizzato,
                                                                             g.cod_ndg),
              '1' AS flg_attiva,
              'RL', --v_microtipolog,
              v_last_rdv_qc_progr AS val_rdv_qc_progressiva,
              --pc.scsb_uti_cassa - v_last_rdv_qc_progr AS val_esp_netta_post_delib,
              0 AS val_rdv_qc_ante_delib,
              --pc.scsb_uti_cassa - v_last_rdv_qc_progr AS val_esp_netta_ante_delib,
              v_last_rdv_qc_progr AS val_rdv_qc_deliberata,
              pc.scsb_uti_cassa AS val_esp_lorda,
              pc.scsb_uti_firma AS val_esp_firma,
              pc.scsb_uti_cassa AS val_uti_cassa_scsb,
              pc.scsb_uti_firma AS val_uti_firma_scsb,
              pc.scsb_uti_tot AS val_uti_tot_scsb,
              'IN',
              'INS',
              'INS',
              SYSDATE,
              SYSDATE,
              'L', ----delibera di aggiustamento rdv post impianto (rdv light), con percorso apporvativo abbreviato
              'BATCH',
              t.cod_macrotipologia,
              p.cod_pratica, -----da pratica appena migrata
              p.val_anno_pratica,
              p.cod_uo_pratica,
              a.val_segmento_regolamentare,
              p_utente,
              g.cod_filiale,
              seq_mcrei_prog_del.nextval,
              0 AS fl_no_del,
              0, ----pregr_fi
              nvl(v_last_rdv_progr_fi, 0),
              'rdv light del ' || trunc(SYSDATE) ||
              ' a seguito migrazione da ' || p_lista_abi_old,
              --p_old_cod_abi, --note
              trunc(SYSDATE),
              'OI' desc_organo_deliberante
         FROM t_mcre0_app_all_data          g,
              t_mcrei_app_pratiche          p,
              t_mcrei_cl_tipologie          t,
              t_mcre0_app_anagrafica_gruppo a,
              t_mcrei_app_pcr_rapp_aggr     pc
        WHERE g.cod_abi_cartolarizzato = p_new_cod_abi
          AND g.cod_ndg = p_new_cod_ndg
          AND g.cod_sndg = a.cod_sndg
          AND g.today_flg = '1'
          AND g.cod_abi_cartolarizzato = p.cod_abi(+)
          AND g.cod_ndg = p.cod_ndg(+)
          AND g.cod_abi_cartolarizzato = pc.cod_abi_cartolarizzato(+)
          AND g.cod_ndg = pc.cod_ndg(+)
          AND p.flg_attiva(+) = '1'
          AND t.cod_microtipologia =
              decode(v_tipo_gestione,
                     'G',
                     'IM',
                     'F',
                     'IM',
                     'E',
                     'IM',
                     'B',
                     'IF',
                     'A',
                     'IF',
                     'D',
                     'IF',
                     'C',
                     'IF',
                     v_tipo_gestione)
          AND t.flg_attivo = 1);

    --   COMMIT;
    pkg_mcrei_audit.log_app(c_nome,
                            pkg_mcrei_audit.c_debug,
                            SQLCODE,
                            SQL%ROWCOUNT || ' righe inserite',
                            p_note,
                            'BATCH');

    ---restituisco i valori dei protocolli generati per la nuova delibera di impianto
    SELECT cod_protocollo_delibera,
           cod_protocollo_pacchetto
      INTO out_proto_delibera,
           out_proto_pacchetto
      FROM t_mcrei_app_delibere r
     WHERE r.cod_abi = p_new_cod_abi
       AND r.cod_ndg = p_new_cod_ndg
       AND cod_matricola_inserente = 'BATCH'
       AND flg_attiva = '1';

    pkg_mcrei_audit.log_app(c_nome,
                            pkg_mcrei_audit.c_debug,
                            SQLCODE,
                            'out: del ' || out_proto_delibera || ' pacc ' ||
                            out_proto_pacchetto,
                            p_note,
                            'BATCH');
    out_esito := 1;

  END crea_rdv_light;

--mantiene lo storico delle posizioni impattate su una tabella ad hoc (usata da presa visione)
  function archivia_evento return number is

  n number := 0;
  m number := 0;

  begin
  --da raffinare... storicizza le pres-cruscotto
    insert into T_MCRE0_hst_MIG_RECODE_NDG
    select n.*, null, null from T_MCRE0_APP_MIG_RECODE_NDG n
    where flg_pres_cruscotto = '1'
    and flg_presa_visione = '0';--no pos storiche
    n := sql%rowcount;

    insert into T_MCRE0_hst_MIG_RECODE_rapp
    select r.* from T_MCRE0_APP_MIG_RECODE_NDG n, T_MCRE0_APP_MIG_RECODE_RAPP r
    where n.cod_abi_old = r.cod_abi_old
    and n.cod_ndg_old = r.cod_ndg_old
    and n.flg_pres_cruscotto = '1'
    and n.flg_presa_visione = '0';--no pos storiche
    m := sql%rowcount;


  pkg_mcrei_audit.log_app('pkg_mcre0_gest_conferimenti.archivia_evento',pkg_mcrei_audit.c_debug,SQLCODE,
                   'archiviazione posizioni conferite','copiate '||n||' posizioni con '||m||' rapporti associati',
                            'BATCH');

    commit;
    return 1;

  exception when others then
     pkg_mcrei_audit.log_app('pkg_mcre0_gest_conferimenti.archivia_evento',pkg_mcrei_audit.c_error,SQLCODE,
                   sqlerrm,'errore storicizzazione evento','BATCH');
     rollback;
     return 0;


  end archivia_evento;

--rimuove il blocco sulle posizioni a fine evento
  function rimuovi_blocco return number is

  n number := 0;
  m number := 0;

  begin

    update T_MCRE0_hst_MIG_RECODE_NDG
       set flg_presa_visione = '3'
    where flg_presa_visione = '0';--no pos storiche
    n := sql%rowcount;


  pkg_mcrei_audit.log_app('pkg_mcre0_gest_conferimenti.rimuovi_blocco',pkg_mcrei_audit.c_debug,SQLCODE,
                   'rimosso blocco su posizioni conferite','spente '||n||' posizioni',
                            'BATCH');

    commit;
    return 1;

  exception when others then
     pkg_mcrei_audit.log_app('pkg_mcre0_gest_conferimenti.rimuovi_blocco',pkg_mcrei_audit.c_error,SQLCODE,
                   sqlerrm,'errore rimozione blocco','BATCH');
     rollback;
     return 0;


  end rimuovi_blocco;

  --v3.0 aggiorna dati di esposizione e rettifica su delibera a partire dalle stime recuperate
  FUNCTION aggiorna_delibera(p_cod_abi        VARCHAR2,
                                  p_cod_ndg        VARCHAR2,
                                  p_proto_delibera VARCHAR2) RETURN NUMBER is
  v_val_rdv_ca number;
  v_val_rdv_fi number;
  v_val_esp_lorda number;
  v_val_esp_firma number;

  begin

     select sum(case when cod_classe_ft = 'CA' then nvl(val_rdv_tot,0) else 0 end) val_rdv_ca,
     sum(case when cod_classe_ft = 'FI' then nvl(val_rdv_tot,0) else 0 end) val_rdv_fi,
     sum(case when cod_classe_ft = 'CA' then nvl(val_esposizione,0) else 0 end) val_esp_lorda,
     sum(case when cod_classe_ft = 'FI' then nvl(val_esposizione,0) else 0 end) val_esp_firma
     into v_val_rdv_ca, v_val_rdv_fi, v_val_esp_lorda, v_val_esp_firma
     from t_mcrei_app_stime s
     where s.cod_abi = p_cod_abi
     AND s.cod_ndg = p_cod_ndg
     AND s.cod_protocollo_delibera = p_proto_delibera;

     update t_mcrei_app_delibere d
     set val_rdv_qc_progressiva = v_val_rdv_ca,
       val_rdv_qc_ante_delib    = 0,
       val_rdv_qc_deliberata    = v_val_rdv_ca,
       val_esp_lorda            = v_val_esp_lorda,
       VAL_ESP_LORDA_CAPITALE   = v_val_esp_lorda,
       VAL_ESP_TOT_CASSA        = v_val_esp_lorda,
       VAL_IMP_UTILIZZO         = v_val_esp_lorda + v_val_esp_firma,
       val_esp_firma            = v_val_esp_firma,
       val_uti_cassa_scsb       = v_val_esp_lorda,
       val_uti_firma_scsb       = v_val_esp_firma,
       val_uti_tot_scsb         = v_val_esp_lorda + v_val_esp_firma,
       val_rdv_pregr_fi         = 0,
       val_rdv_progr_fi         = v_val_rdv_fi,
       val_perc_rdv             =   CASE
                                       WHEN v_val_esp_lorda + v_val_esp_firma = 0 THEN 100
                                       WHEN (v_val_rdv_ca + v_val_rdv_fi) = 0 THEN 100
                                       ELSE
                                        round((((v_val_rdv_ca + v_val_rdv_fi) * 100) /
                                            (v_val_esp_lorda + v_val_esp_firma)),2)--20 luglio
                                     END

     where d.cod_abi = p_cod_abi
     AND d.cod_ndg = p_cod_ndg
     AND d.cod_protocollo_delibera = p_proto_delibera;

  pkg_mcrei_audit.log_app('pkg_mcre0_gest_conferimenti.aggiorna_delibera',pkg_mcrei_audit.c_debug,SQLCODE,
                   'aggiornate esposizioni e rdv','delibera '||p_cod_abi||
                   ' '||p_cod_ndg||' prot '||p_proto_delibera,
                            'BATCH');
    return 1;

  exception when others then
     pkg_mcrei_audit.log_app('pkg_mcre0_gest_conferimenti.aggiorna_delibera',pkg_mcrei_audit.c_error,SQLCODE,
                   sqlerrm,'errore aggironamento delibera '||p_cod_abi||
                   ' '||p_cod_ndg||' prot '||p_proto_delibera,'BATCH');
     return 0;

  end aggiorna_delibera;



END pkg_mcre0_gest_conferimenti;
/


CREATE SYNONYM MCRE_APP.PKG_MCRE0_GEST_CONFERIMENTI FOR MCRE_OWN.PKG_MCRE0_GEST_CONFERIMENTI;


CREATE SYNONYM MCRE_USR.PKG_MCRE0_GEST_CONFERIMENTI FOR MCRE_OWN.PKG_MCRE0_GEST_CONFERIMENTI;


GRANT EXECUTE, DEBUG ON MCRE_OWN.PKG_MCRE0_GEST_CONFERIMENTI TO MCRE_USR;

