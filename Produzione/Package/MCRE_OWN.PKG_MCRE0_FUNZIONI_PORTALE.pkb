CREATE OR REPLACE PACKAGE BODY MCRE_OWN.pkg_mcre0_funzioni_portale AS
  /******************************************************************************
    NAME:       PKG_MCRE0_FUNZIONI_PORTALE
    PURPOSE:
    REVISIONS:
    Ver        Date        Author           Description
    ---------  ----------  ---------------  ------------------------------------
    1.0        18/10/2010          M.Murro. Created this package.
    1.1        17/12/2010          M.Murro  aggiornato conferma e prenota
    1.2        20/01/2011          M.Murro  added inserisci_posizione
    1.3        25/01/2011          M.Murro  aggiunta canceella PT in CambioStato
    1.4        28/01/2011          M.Murro  rimosso cancella PT, cursore per alert in conferma
    1.5        03/02/2011          M.Murro  inserisci_posizione (+ dta_utente_assegnato (07.02)
    1.6        08/02/2011          M.Murro  check elaborazione abi
    1.7        10/02/2011          M.Murro  spostato rimuovi prenotazione
    1.8        17/02/2011          M.Murro  raddoppiato il refresh per rimettere il rimuovi prenotazioni in coda
    2.0        18/02/2011          M.Murro  nuova gestione prenota/conferma/annulla su sezione e gestione 'disassegna'
    2.1        23/02/2011       L.Ferretti nuova versione di inserisci_posizione
    2.2        01/03/2011          M.Murro  fix su rimuovi prenotazione
    2.3        02/03/2011          M.Murro  fix su aggiorna stato (non storicizzava)
    2.4        04/03/2011       L.Ferretti  fix su stati di uscita
    2.5        04/03/2011          M.Murro  fix su controllo stati abiliytati in assegna posizione
    2.6        15/03/2011          M.Murro  fix su controllo comparto utente e abi elaborati
    3.0        25/03/2011          M.Murro  nuova Conferma con tab incagfi e 1 solo refresh
    3.1        06/04/2011          M.Murro  variato storico_sndg in cambio_stato
    3.2        11/04/2011          M.Murro  nuovo Audit
    3.3        26/04/2011          M.Murro  assegna bulk
    3.4        02/05/2011          M.Murro  fix assegna bulk
    3.5        06/05/2011          M.Murro  gestione Servizio
    3.6        23/05/2011          M.Murro  gestione GB, fix su inserisci pos
    3.7        06/06/2011          M.Murro  nuova gestione GB
    3.8        09/06/2011          M.Murro  prenota e rimuovi con commit + refresh al prenota
    3.9        10/06/2011          M.Murro  nuova annulla_gb, rinominata la vecchia in rifiuta
    4.0        01/07/2011          M.Murro  Gestione Avocazione
    4.1        14/07/2011          M.Murro  fix av: escludo i PT dagli avocabili
    5.0        19/07/2011          M.Murro  Nuove strutture per tuning
    5.1        22/08/2011          M.Murro  Variata gestione Av
    5.2        30/08/2011          M.Murro  fix inserisci posizione
    5.3        02/09/2011          M.Murro  Nuovaq Inserisci_AV
    5.4        30/09/2011          M.Murro  messaggio esito in avocazione
    5.5        20/10/2011          M.Murro  AV: filtro anche se comparto di direnzione
    5.6        22/11/2011          M.Murro  conferma: fix tab assegnazioni Incaglio
    5.7        27/12/2011          M.Murro  check abi elaborato da MV
    6.0        12/04/2012          M.Murro  variato conferma assegna_pos per aprire a Divisioni
    6.1        27/04/2012          M.Murro  gestione RS su cambio stato
    7.0        22/05/2012         V.Galli   Commenti con label:   VG - CIB/BDT - INIZIO
    8.0        10/07/2012        E.Pellizzi  Add function pdf_rio
    8.1        11/09/2012        E.Pellizzi  Add function upd_pdf_rio
    8.2        19/09/2012        V.Galli      Modificata assegna posizioni
    8.3        25/09/2012        A.Galliano   Modifica funzione pdf_rio
    8.4        03/10/2012        V.Galli      Modificata assegna posizioni per sblocco posizioni
    8.5        04/10/2012        V.Galli      Modificata rio_pdf
    8.6        20/12/2012        M.Murro      loggato flg_blocco. fix gestione processo su disassegnazione
    8.7        04/01/2013        d'errico      modificata pdr_rio inserendo nullif per estrazione id_anomalie e prendnendo il GE dalle azioni e dalle anomalie invece che dall'upd_filelds
    8.8        05/03/2013        M.Murro      Fix formato TMS su RS_POSIZIONI e percorsi
    8.9        22/03/2013        M.Murro      aggiunto p_tipo_utente a classifica_GB
    9.0        10/04/2013        M.Murro      fix GB su cambio stato
    9.1        08/05/2013        M.Murro      fix RO_PDF
    9.2        08/05/2013        M.Murro      cambio formato tms in gestione RS
    9.3        12/09/2013        M.Murro      trappato errore nella ricerca del processo in assegna posizioni per estensione RG
    9.5        07/05/2014        M.Ceru       aggiunti parametri in input a assegna_posizione_blk per la variazione perimetro DR
    9.6        08/05/2014        M.Ceru       modificato filtro da = a like per DESC_NOME_CONTROPARTE e VAL_ANA_GRE
  ******************************************************************************/

  --verifica se l'abi S elaborato (v5.7 - da MV)
  FUNCTION check_elaborazione_abi(p_abi_cart VARCHAR2) RETURN NUMBER IS

    esito NUMBER := 0;

  BEGIN

    --v5.7
    SELECT flg_abi_lavorato
      INTO esito
      FROM mv_mcre0_app_istituti e
     WHERE e.cod_abi = p_abi_cart;

    RETURN esito;

  END;

  --funzione per rimuovere le prenotazioni di un assegnatore - commit v3.8 -v5
  FUNCTION rimuovi_prenotazioni(p_utente  VARCHAR2,
                                p_sezione IN NUMBER DEFAULT 0,
                                p_seq     IN NUMBER DEFAULT NULL,
                                --------------------   VG - CIB/BDT - INIZIO --------------------
                                p_seq_blocco NUMBER DEFAULT 0,
                                p_flg_esito_conferme NUMBER DEFAULT NULL
                                --------------------   VG - CIB/BDT - FINE --------------------
                                ) RETURN NUMBER IS

    v_rownum NUMBER;
    v_seq    NUMBER;
    esito    NUMBER := 0;
     v_note           VARCHAR2(3000);
  BEGIN

    UPDATE mcre_own.t_mcre0_app_all_data --v5.0 ex FG
       SET cod_matr_assegnatore      = NULL,
           cod_comparto_preassegnato = NULL,
           id_utente_preassegnato    = NULL,
           cod_processo_preassegnato = NULL,
           cod_sezione_preassegnata  = NULL, --v2.2
           --------------------   VG - CIB/BDT - INIZIO --------------------
           flg_blocco = 0
    --------------------   VG - CIB/BDT - FINE --------------------
     WHERE cod_matr_assegnatore = p_utente
       AND nvl(cod_sezione_preassegnata, 0) = p_sezione
       AND flg_blocco = p_seq_blocco; --v2.0

    v_rownum := SQL%ROWCOUNT;

    IF p_seq IS NULL
    THEN
      SELECT seq_mcr0_log_app.nextval INTO v_seq FROM dual;
    ELSE
      v_seq := p_seq;
    END IF;

    --v3.8 - chiamo il refresh!
    --  esito := MCRE_OWN.PKG_MCRE0_AGGIORNA_MV.REFRESH_fast_SNP ( v_seq );

    pkg_mcre0_audit.log_app(v_seq,
                            c_package || 'rimuovi_prenotazioni',
                            3,
                            SQLCODE,
                            'rimosse ' || v_rownum ||
                            ' prenotazioni - esito refresh: ' || esito,
                            ' sezione: ' || p_sezione ||
                            ' - no rollback, return',
                            p_utente);

        -- VG 02/10/2012  spostato da blocc_ posizioni
        if(p_seq_blocco !=0) then
            v_note := 'FINE report conferma posizioni - flg_blocco=' ||p_seq_blocco || ' sezione: ' || p_sezione;
            pkg_mcre0_audit.log_app(v_seq, c_package || '.rimuovi_prenotazioni ',3, SQLCODE,sqlerrm,  v_note, p_utente);
            UPDATE t_mcre0_app_report_confermapos
            SET dta_fine  = SYSDATE,
            flg_esito = nvl(p_flg_esito_conferme, -1)
            WHERE cod_matr_assegnatore = p_utente
            AND cod_sezione = p_sezione
            AND cod_blocco = p_seq_blocco;
        end if;


    RETURN v_rownum;

  EXCEPTION
    WHEN OTHERS THEN
      pkg_mcre0_audit.log_app(v_seq,
                              c_package || 'rimuovi_prenotazioni',
                              1,
                              SQLCODE,
                              SQLERRM,
                              ' sezione: ' || p_sezione ||
                              ' - no rollback, return',
                              p_utente);
      ROLLBACK;
      RETURN ko;
  END;
  --conferma le prenotazioni effettuate da un utente - COMMITTA!
  PROCEDURE conferma_assegna_posizione(p_utente          IN VARCHAR2,
                                       p_sezione         IN NUMBER,
                                       esito             OUT NUMBER,
                                       host_param        OUT host_tab,
                                       mopl_param        OUT mopl_tab,
                                       p_flg_ass_massiva IN NUMBER DEFAULT 0,
                                       --------------------   VG - CIB/BDT - INIZIO --------------------
                                       p_seq_blocco NUMBER
                                       --------------------   VG - CIB/BDT - FINE --------------------
                                       ) IS
    CURSOR storico IS
      SELECT DISTINCT cod_abi_cartolarizzato,
                      cod_ndg,
                      cod_sndg,
                      MAX(t.flg_stato) over(PARTITION BY t.cod_sndg) flg_stato,
                      MAX(t.flg_comparto) over(PARTITION BY t.cod_sndg) flg_comparto,
                      MAX(t.flg_gestore) over(PARTITION BY t.cod_sndg) flg_gestore,
                      MAX(t.flg_mese) over(PARTITION BY t.cod_sndg) flg_mese
        FROM mcre_own.t_mcre0_tmp_lista_storico t;

    counter          NUMBER := 0;
    RESULT           NUMBER := 0;
    v_proc_dir       VARCHAR2(2) := NULL;
    tab_prenotazioni host_tab;
    seq              NUMBER;
    v_servizio       t_mcre0_app_all_data.cod_servizio%TYPE;

    --v3.0 join con tabella parametrica dei prenotati e upd_field
    CURSOR alert_upd IS
      SELECT f.cod_abi_cartolarizzato,
             f.cod_ndg,
             f.cod_sndg,
             nvl(f.cod_comparto_assegnato, f.cod_comparto_calcolato) cod_comparto,
             f.id_utente
        FROM v_mcre0_app_upd_fields_p1 f, t_mcre0_app_stati s
       WHERE cod_matr_assegnatore = p_utente
         AND cod_sezione_preassegnata = p_sezione
         AND f.cod_stato = s.cod_microstato
         AND s.flg_alert = '1'
         AND flg_blocco = p_seq_blocco;

    CURSOR prenotati IS
      SELECT f.cod_abi_cartolarizzato,
             f.cod_ndg,
             f.cod_sndg,
             CASE
               WHEN u.cod_comparto_utente IS NOT NULL THEN
                (SELECT c.cod_livello
                   FROM t_mcre0_app_comparti c
                  WHERE cod_comparto_utente = c.cod_comparto(+))
               ELSE
                (SELECT c.cod_livello
                   FROM t_mcre0_app_comparti c
                  WHERE nvl(cod_comparto_preassegnato, --v.8.6
                        nvl(cod_comparto_assegnato, cod_comparto_calcolato)) = c.cod_comparto(+))
             END AS cod_livello, --v6.0
             cod_comparto_preassegnato,
             decode(id_utente_preassegnato, 0, NULL, id_utente_preassegnato) id_utente_preassegnato
        FROM t_mcre0_app_all_data f, --v5.0 FG
             t_mcre0_app_utenti   u
       WHERE cod_matr_assegnatore = p_utente
         AND f.cod_sezione_preassegnata = p_sezione --v2.0
         AND id_utente_preassegnato = u.id_utente(+)
         AND flg_blocco = p_seq_blocco;

    rec  prenotati%ROWTYPE;
    sett alert_upd%ROWTYPE;
  BEGIN
    SELECT seq_mcr0_log_app.nextval INTO seq FROM dual;

    pkg_mcre0_audit.log_app(seq,
                            c_package || '.conferma_assegna_posizione ',
                            3,
                            SQLCODE,
                            'start',
                            ' sezione: ' || p_sezione ||' blocco: ' ||p_seq_blocco,
                            p_utente);

    --popolo la tmp_lista_storico per la storicizzazione
    BEGIN

      INSERT INTO mcre_own.t_mcre0_tmp_lista_storico
        (cod_abi_cartolarizzato,
         cod_ndg,
         cod_sndg,
         flg_stato,
         flg_comparto,
         flg_gestore,
         flg_mese)
        (SELECT f.cod_abi_cartolarizzato,
                f.cod_ndg,
                f.cod_sndg,
                '0' stato,
                nvl2(f.cod_comparto_preassegnato, '1', '0') comparto,
                nvl2(f.id_utente_preassegnato, '1', '0'),
                '0' mese
           FROM mcre_own.t_mcre0_app_all_data f --v5.0 FG
          WHERE cod_matr_assegnatore = p_utente
            AND cod_sezione_preassegnata = p_sezione --v5.0
            AND flg_blocco = p_seq_blocco
            AND NOT (cod_comparto_preassegnato IS NULL AND
                 id_utente_preassegnato IS NULL));

    EXCEPTION
      WHEN OTHERS THEN
        pkg_mcre0_audit.log_app(seq,
                                c_package || '.conferma_assegna_posizione ',
                                1,
                                SQLCODE,
                                SQLERRM,
                                ' sezione: ' || p_sezione || ' blocco: ' ||p_seq_blocco||
                                ' - rollback, return',
                                p_utente);
        ROLLBACK;
        esito := ko;
        RETURN;
    END;

    --storicizzo- no commit
    BEGIN

      FOR riga IN storico
      LOOP
        --storicizzo il singolo settoriale
        esito  := pkg_mcre0_storicizza.insert_storico_ndg(riga.cod_abi_cartolarizzato,
                                                          riga.cod_ndg,
                                                          riga.flg_comparto,
                                                          riga.flg_gestore,
                                                          riga.flg_stato,
                                                          riga.flg_mese);
        RESULT := RESULT * esito;
      END LOOP;

    EXCEPTION
      WHEN OTHERS THEN
        pkg_mcre0_audit.log_app(seq,
                                c_package || '.conferma_assegna_posizione ',
                                1,
                                SQLCODE,
                                SQLERRM,
                                ' sezione: ' || p_sezione || ' blocco: ' ||p_seq_blocco||
                                ' - rollback, return',
                                p_utente);
        ROLLBACK;
        esito := ko;
        RETURN;
    END;

    --se non ho storicizzato tutti i record da confermare, abort
    IF RESULT = 0
    THEN
      pkg_mcre0_audit.log_app(seq,
                              c_package || '.conferma_assegna_posizione ',
                              2,
                              SQLCODE,
                              'storicizza',
                              ' sezione: ' || p_sezione ||' blocco: ' ||p_seq_blocco|| ' -proseguo..',
                              p_utente);
      --ROLLBACK;
      --esito := ko;
      --RETURN;
    END IF;

    OPEN prenotati;
    LOOP
      FETCH prenotati
        INTO rec;
      EXIT WHEN prenotati%NOTFOUND;
      BEGIN
        --calcolo il nuovo processo, se diverso dall'attuale
        --MM 12/01/2011: solo per idper corrente in Mople
        SELECT v.cod_processo_liv
          INTO v_proc_dir
          FROM mcre_own.t_mcre0_app_all_data m, --v5.0 mople
               --  MCRE_OWN.V_MCRE0_DENORM_PROCESSI v
               mcre_own.v_mcre0_app_processi_liv v --v6.0
         WHERE m.cod_processo = v.cod_processo
           AND m.cod_abi_cartolarizzato = v.cod_abi
           AND m.cod_processo != v.cod_processo_liv --dir
           AND v.cod_livello = nvl(rec.cod_livello, v.tip_processo) --v6.0 (se nullo, non cambio processo)
           AND m.cod_abi_cartolarizzato = rec.cod_abi_cartolarizzato
           AND m.cod_ndg = rec.cod_ndg
           AND m.today_flg = '1'; --v5.0
      EXCEPTION
        WHEN no_data_found THEN
          v_proc_dir := NULL;
        WHEN OTHERS THEN
        --v9.3 MM non faccio return, ma proseguo senza variare il processo
          pkg_mcre0_audit.log_app(seq,
                                  c_package ||
                                  '.conferma_assegna_posizione - calcolo processo',
                                  1,
                                  SQLCODE,
                                  SQLERRM,
                                  ' sezione: ' || p_sezione ||
                                  ', abi_cart: ' ||
                                  rec.cod_abi_cartolarizzato || ', ndg: ' ||
                                  rec.cod_ndg || ' -no rollback, no return',
                                  p_utente);
--          ROLLBACK;
--          esito := ko;
--          RETURN;
          v_proc_dir := NULL;

      END;

      --confermo le prenotazioni
      BEGIN

        IF rec.cod_comparto_preassegnato IS NOT NULL
        THEN
          --v3.5 - gestisco il cambio di servizio..
          BEGIN
            SELECT cod_servizio
              INTO v_servizio
              FROM t_mcre0_app_comparti
             WHERE cod_comparto = rec.cod_comparto_preassegnato;
          EXCEPTION
            WHEN OTHERS THEN
              v_servizio := NULL;
              pkg_mcre0_audit.log_app(seq,
                                      c_package ||
                                      '.conferma_assegna_posizione - calcolo servizio',
                                      2,
                                      SQLCODE,
                                      SQLERRM,
                                      ' sezione: ' || p_sezione ||
                                      ', abi_cart: ' ||
                                      rec.cod_abi_cartolarizzato ||
                                      ', ndg: ' || rec.cod_ndg ||
                                      ' servizio := null',
                                      p_utente);
          END;

          UPDATE mcre_own.t_mcre0_app_all_data f --v5.0 FG
             SET cod_comparto_assegnato = rec.cod_comparto_preassegnato,
                 --v3.6 non setto il processo se posizione non di direzione
                 --          COD_PROCESSO_PREASSEGNATO     = decode(F.COD_COMPARTO_CALCOLATO, '011901', v_proc_dir,null),
                 cod_processo_preassegnato = decode(rec.cod_livello,
                                                    'DC',
                                                    v_proc_dir,
                                                    'DV',
                                                    v_proc_dir,
                                                    'DI',
                                                    v_proc_dir,
                                                    NULL),
                 --v3.5
                 cod_servizio = v_servizio,
                 dta_servizio = decode(nvl(f.cod_servizio, '-'),
                                       v_servizio,
                                       f.dta_servizio,
                                       SYSDATE),
                 --
                 cod_operatore_ins_upd = p_utente,
                 dta_upd               = SYSDATE
           WHERE cod_abi_cartolarizzato = rec.cod_abi_cartolarizzato
             AND cod_ndg = rec.cod_ndg;

        ELSIF (rec.id_utente_preassegnato IS NOT NULL AND
              rec.id_utente_preassegnato != -1)
        THEN

          --v3.5 - gestisco il cambio di servizio..
          BEGIN
            SELECT cod_servizio
              INTO v_servizio
              FROM t_mcre0_app_comparti
             WHERE cod_comparto =
                   (SELECT nvl(cod_comparto_assegn, cod_comparto_appart)
                      FROM mcre_own.t_mcre0_app_utenti u
                     WHERE u.id_utente = rec.id_utente_preassegnato);
          EXCEPTION
            WHEN OTHERS THEN
              v_servizio := NULL;
              pkg_mcre0_audit.log_app(seq,
                                      c_package ||
                                      '.conferma_assegna_posizione - calcolo servizio',
                                      2,
                                      SQLCODE,
                                      SQLERRM,
                                      ' sezione: ' || p_sezione ||
                                      ', abi_cart: ' ||
                                      rec.cod_abi_cartolarizzato ||
                                      ', ndg: ' || rec.cod_ndg ||
                                      ' servizio := null',
                                      p_utente);
          END;

          UPDATE mcre_own.t_mcre0_app_all_data f --v5.0 FG
             SET id_utente_pre          = id_utente,
                 id_utente              = rec.id_utente_preassegnato,
                 cod_comparto_assegnato =
                   (SELECT nvl(cod_comparto_assegn, cod_comparto_appart) --v2.6 - invertito l'ordine!
                    FROM mcre_own.t_mcre0_app_utenti u
                   WHERE u.id_utente = rec.id_utente_preassegnato),
                 --v3.6 non setto il processo se posizione non di direzione
                 --          COD_PROCESSO_PREASSEGNATO     = decode(F.COD_COMPARTO_CALCOLATO, '011901', v_proc_dir,null),
                 cod_processo_preassegnato = decode(rec.cod_livello,
                                                    'DC',
                                                    v_proc_dir,
                                                    'DV',
                                                    v_proc_dir,
                                                    'DI',
                                                    v_proc_dir,
                                                    NULL),
                 --v3.5
                 cod_servizio = v_servizio,
                 dta_servizio = decode(nvl(f.cod_servizio, '-'),
                                       v_servizio,
                                       f.dta_servizio,
                                       SYSDATE),
                 --
                 cod_operatore_ins_upd = p_utente,
                 dta_upd               = SYSDATE,
                 dta_utente_assegnato  = SYSDATE
           WHERE cod_abi_cartolarizzato = rec.cod_abi_cartolarizzato
             AND cod_ndg = rec.cod_ndg;

        ELSIF rec.id_utente_preassegnato = -1
        THEN
          --disassegno, senza toccare il comparto

          UPDATE mcre_own.t_mcre0_app_all_data f
             SET id_utente_pre = id_utente,
                 id_utente     = -1, --v5.0 NULL
                 --COD_COMPARTO_ASSEGNATO     = rec.COD_COMPARTO_PREASSEGNATO,
                 --COD_PROCESSO_PREASSEGNATO  = v_proc_dir, v3.6.. non serve..
                 cod_operatore_ins_upd = p_utente,
                 dta_upd               = SYSDATE,
                 cod_comparto_assegnato=CASE WHEN rec.cod_livello != 'DC' then null else cod_comparto_assegnato end
                 --disassegnazione comparto_assegnato escludendo le direzioni
           WHERE cod_abi_cartolarizzato = rec.cod_abi_cartolarizzato
             AND cod_ndg = rec.cod_ndg;

        ELSIF (rec.id_utente_preassegnato IS NULL AND
              rec.cod_comparto_preassegnato IS NULL)
        THEN

          UPDATE mcre_own.t_mcre0_app_all_data f
             SET id_utente_pre          = id_utente,
                 id_utente              = rec.id_utente_preassegnato,
                 cod_comparto_assegnato = rec.cod_comparto_preassegnato,
                 --v3.6 non setto il processo se posizione non di direzione
                 --          COD_PROCESSO_PREASSEGNATO     = decode(F.COD_COMPARTO_CALCOLATO, '011901', v_proc_dir,null),
                 cod_processo_preassegnato = decode(rec.cod_livello,
                                                    'DC',
                                                    v_proc_dir,
                                                    'DV',
                                                    v_proc_dir,
                                                    'DI',
                                                    v_proc_dir,
                                                    NULL),
                 cod_operatore_ins_upd     = p_utente,
                 dta_upd                   = SYSDATE
           WHERE cod_abi_cartolarizzato = rec.cod_abi_cartolarizzato
             AND cod_ndg = rec.cod_ndg;

        END IF;
        RESULT := RESULT + SQL%ROWCOUNT;
      EXCEPTION
        WHEN OTHERS THEN
          pkg_mcre0_audit.log_app(seq,
                                  c_package ||
                                  '.conferma_assegna_posizione ',
                                  1,
                                  SQLCODE,
                                  SQLERRM,
                                  ' sezione: ' || p_sezione ||
                                  ', abi_cart: ' ||
                                  rec.cod_abi_cartolarizzato || ', ndg: ' ||
                                  rec.cod_ndg || ' comparto: ' ||
                                  rec.cod_comparto_preassegnato ||
                                  ', gestore: ' ||
                                  rec.id_utente_preassegnato ||
                                  ' - rollback, return',
                                  p_utente);
          ROLLBACK;
          esito := ko;
          RETURN;
      END;
    END LOOP;
    CLOSE prenotati;
    pkg_mcre0_audit.log_app(seq,
                            c_package || '.conferma_assegna_posizione ',
                            3,
                            SQLCODE,
                            'confermato (n righe upd:' || RESULT,
                            ' sezione: ' || p_sezione ||' blocco: ' ||p_seq_blocco,
                            p_utente);

    --popolo la tabella di output dei processi da aggiornare
    BEGIN
      SELECT host_row(cod_abi_istituto,
                      cod_ndg,
                      cod_comparto_preassegnato,
                      cod_processo_preassegnato) BULK COLLECT
        INTO host_param
        FROM mcre_own.t_mcre0_app_all_data --v5.0 FG
       WHERE cod_matr_assegnatore = p_utente
         AND cod_sezione_preassegnata = p_sezione --v5.0
         AND flg_blocco = p_seq_blocco
         AND NOT (cod_comparto_preassegnato IS NULL AND
              cod_processo_preassegnato IS NULL);

    EXCEPTION
      WHEN OTHERS THEN
        pkg_mcre0_audit.log_app(seq,
                                c_package ||
                                '.conferma_assegna_posizione -tab processi',
                                2,
                                SQLCODE,
                                SQLERRM,
                                '',
                                p_utente);
    END;

    --v3.0 popolo la tabella di output dei comparti da aggiornare su mople SOLO INCAGLI
    --v5.0 su upd_fields
    BEGIN
      --    SELECT mopl_row(
      --        m.COD_ABI_ISTITUTO,
      --        m.COD_NDG,
      --        S.COD_STRUTTURA_COMPETENTE,
      --        U.COD_MATRICOLA) bulk collect
      --    INTO mopl_param
      --    FROM MCRE_OWN.T_MCRE0_APP_FILE_GUIDA f, MCRE_OWN.T_MCRE0_APP_MOPLE m,
      --         MCRE_OWN.T_MCRE0_APP_STRUTTURA_ORG s, MCRE_OWN.T_MCRE0_APP_UTENTI u
      --    WHERE COD_MATR_ASSEGNATORE = p_utente
      --    and F.COD_ABI_CARTOLARIZZATO = M.COD_ABI_CARTOLARIZZATO
      --    and F.COD_NDG = M.COD_NDG
      --    and M.COD_STATO = 'IN'
      --    and F.ID_UTENTE = U.ID_UTENTE(+)
      --    and nvl(F.COD_COMPARTO_ASSEGNATO,F.COD_COMPARTO_CALCOLATO) = S.COD_COMPARTO
      --    and F.COD_ABI_ISTITUTO = S.COD_ABI_ISTITUTO;
      --    --and F.COD_COMPARTO_CALCOLATO = '011901';

      SELECT mopl_row(v.cod_abi_istituto,
                      v.cod_ndg,
                      s.cod_struttura_competente,
                      v.cod_matricola) BULK COLLECT
        INTO mopl_param
        FROM v_mcre0_app_upd_fields v, t_mcre0_app_struttura_org s --v5.6 -aggiunta decodifica su struttorg
       WHERE v.cod_abi_cartolarizzato = s.cod_abi_istituto --10.4!!!
         AND v.cod_comparto = s.cod_comparto
         AND cod_matr_assegnatore = p_utente
         AND cod_sezione_preassegnata = p_sezione --v5.0
         AND flg_blocco = p_seq_blocco
         AND cod_stato = 'IN';

    EXCEPTION
      WHEN OTHERS THEN
        pkg_mcre0_audit.log_app(seq,
                                c_package ||
                                '.conferma_assegna_posizione -tab incagli asssegnati',
                                2,
                                SQLCODE,
                                SQLERRM,
                                '',
                                p_utente);
    END;

    COMMIT;

    --v3.0 memorizzo le posizioni prenotate
    --v5.0 passo direttamente dalla tabella
    --  BEGIN
    --    SELECT host_row(
    --        COD_ABI_ISTITUTO,
    --        COD_NDG,
    --        null,
    --        null) bulk collect
    --    INTO tab_prenotazioni
    --    FROM MCRE_OWN.T_MCRE0_APP_ALL_DATA --v5.0 FG
    --    where COD_MATR_ASSEGNATORE = p_utente
    --    AND   COD_SEZIONE_PREASSEGNATA = p_sezione;

    --  EXCEPTION
    --  WHEN OTHERS THEN
    --    PKG_MCRE0_AUDIT.LOG_APP ( seq, c_package||'.conferma_assegna_posizione -tab prenotazioni', 2, SQLCODE, sqlerrm, 'sezione '||p_sezione, p_utente );
    --  END;

    --aggiorno FAST le MV (gi¿ fatto dal Rimuovi! v3.8)
    --  esito := MCRE_OWN.PKG_MCRE0_AGGIORNA_MV.REFRESH_FAST_SNP(seq);
    --  PKG_MCRE0_AUDIT.LOG_APP ( seq, c_package||'.conferma_assegna_posizione ', 3, SQLCODE, 'refresh(esito: '||esito||')', ' sezione: '||p_sezione, p_utente );

    --aggiorno gli alert delle posizioni prenotate usando la tabella temporanea v3.0
    BEGIN
      OPEN alert_upd;
      LOOP
        FETCH alert_upd
          INTO sett;
        EXIT WHEN alert_upd%NOTFOUND;

        esito   := pkg_mcre0_alert.fnc_verifica_alert_ndg(sett.cod_abi_cartolarizzato,
                                                          sett.cod_ndg,
                                                          sett.cod_sndg,
                                                          sett.id_utente);
        counter := counter + 1;

      END LOOP;
      CLOSE alert_upd;

      pkg_mcre0_audit.log_app(seq,
                              c_package || '.conferma_assegna_posizione ',
                              3,
                              SQLCODE,
                              'calcolati ' || counter || ' alert',
                              ' sezione: ' || p_sezione ||' blocco: ' ||p_seq_blocco,
                              p_utente);

      --rimuovo le prenotazioni confermate --17.02 dopo gli alert, altrimenti non girano!
      --v3.0 anticipato nuovamente
      --v5.0 posticipato nuovamente!
      esito := rimuovi_prenotazioni(p_utente, p_sezione, seq, p_seq_blocco,1); --v2.0
      IF esito = ko
      THEN
        pkg_mcre0_audit.log_app(seq,
                                c_package ||
                                '.conferma_assegna_posizione -rimuovi prenotazione',
                                2,
                                SQLCODE,
                                SQLERRM,
                                'sezione ' || p_sezione ||' blocco: ' ||p_seq_blocco,
                                p_utente);
      END IF;

    EXCEPTION
      WHEN OTHERS THEN
        pkg_mcre0_audit.log_app(seq,
                                c_package ||
                                '.conferma_assegna_posizione -alert',
                                2,
                                SQLCODE,
                                SQLERRM,
                                'sezione ' || p_sezione ||' blocco: ' ||p_seq_blocco,
                                p_utente);
    END;

    COMMIT;

    esito := RESULT;
  EXCEPTION
    WHEN OTHERS THEN
      pkg_mcre0_audit.log_app(seq,
                              c_package || '.conferma_assegna_posizione ',
                              1,
                              SQLCODE,
                              SQLERRM,
                              'sezione ' || p_sezione || ' blocco: ' ||p_seq_blocco||' - ROLLBACK',
                              p_utente);
      ROLLBACK;
      esito := ko;
  END;

  --------------------   VG - CIB/BDT - INIZIO --------------------
  PROCEDURE blocca_posizioni(p_utente             IN VARCHAR2,
                             p_sezione            IN NUMBER,
                             esito                OUT NUMBER,
                             p_seq_blocco         IN OUT NUMBER,
                             p_flg_esito_conferme NUMBER DEFAULT NULL) IS
    seq              NUMBER;
    seq_blocco       NUMBER;
    RESULT           NUMBER := 0;
    v_note           VARCHAR2(3000);
    v_elenco_gestori t_mcre0_app_report_confermapos.val_elenco_gestori%TYPE;
  BEGIN

    SELECT seq_mcr0_log_app.nextval INTO seq FROM dual;

    IF (p_seq_blocco IS NULL)
    THEN

      SELECT seq_mcre0_report_conf_pos.nextval INTO seq_blocco FROM dual;

      BEGIN
        SELECT MAX(sys_connect_by_path(cognome, ',')) val_elenco_gestori
          INTO v_elenco_gestori
          FROM (SELECT cognome,
                       row_number() over(PARTITION BY flg_blocco ORDER BY flg_blocco, cognome) rn,
                       flg_blocco
                  FROM (SELECT DISTINCT u.cognome, flg_blocco
                          FROM t_mcre0_app_all_data d, t_mcre0_app_utenti u
                         WHERE cod_matr_assegnatore = p_utente
                           AND cod_sezione_preassegnata = p_sezione
                           AND flg_blocco = 0
                           AND d.id_utente_preassegnato = u.id_utente)) t
         START WITH t.rn = 1
        CONNECT BY t.rn = PRIOR t.rn + 1
               AND flg_blocco = PRIOR flg_blocco
         GROUP BY flg_blocco;
      EXCEPTION
        WHEN OTHERS THEN
          pkg_mcre0_audit.log_app(seq,
                                  c_package || '.blocca_posizioni ',
                                  1,
                                  SQLCODE,
                                  SQLERRM,
                                  ' Elenco_gestori - Sezione ' || p_sezione,
                                  p_utente);
      END;

      pkg_mcre0_audit.log_app(seq,
                              c_package || '.blocca_posizioni ',
                              3,
                              SQLCODE,
                              'flg_blocco=' || seq_blocco,
                              ' sezione: ' || p_sezione,
                              p_utente);
      UPDATE t_mcre0_app_all_data
         SET flg_blocco = seq_blocco
       WHERE cod_matr_assegnatore = p_utente
         AND cod_sezione_preassegnata = p_sezione
         AND flg_blocco = 0;
      RESULT := SQL%ROWCOUNT;

      v_note := 'Insert report conferma posizioni - flg_blocco=' ||
                seq_blocco || ' sezione: ' || p_sezione;
      INSERT INTO t_mcre0_app_report_confermapos
        (cod_blocco,
         cod_matr_assegnatore,
         cod_sezione,
         dta_inizio,
         val_num_modificati,
         val_elenco_gestori)
      VALUES
        (seq_blocco,
         p_utente,
         p_sezione,
         SYSDATE,
         RESULT,
         substr(v_elenco_gestori, 2, length(v_elenco_gestori)));
    end if;

    COMMIT;

    p_seq_blocco := nvl(p_seq_blocco, seq_blocco);
    esito        := RESULT;

  EXCEPTION
    WHEN OTHERS THEN
      pkg_mcre0_audit.log_app(seq,
                              c_package || '.blocca_posizioni ',
                              1,
                              SQLCODE,
                              SQLERRM,
                              v_note || ' -- sezione ' || p_sezione ||
                              ' - ROLLBACK',
                              p_utente);
      ROLLBACK;
      esito := ko;
  END;
  --------------------   VG - CIB/BDT - FINE --------------------

  --funzione da chiamare da portale, dopo aver effettuato l'update su HOST
  --chiamata al refresh delle MV da effettuare esternamente -NO COMMIT
  FUNCTION aggiorna_stato(p_abi_cart      IN VARCHAR2,
                          p_ndg           IN VARCHAR2,
                          p_sndg          IN VARCHAR2 DEFAULT NULL,
                          p_stato         VARCHAR2,
                          p_data_scadenza DATE,
                          p_utente        VARCHAR2 DEFAULT NULL)
    RETURN NUMBER IS
    esito         NUMBER := 0;
    esito_storico NUMBER := 0;
    v_sndg        VARCHAR2(16) := NULL;
    v_utente      NUMBER := NULL;
    num           NUMBER := 0;
    deleted       NUMBER := 0;
    v_stato_pre   VARCHAR2(2) := NULL;
    -- v. 2.4
    flg_uscita   VARCHAR2(1) := 0;
    seq          NUMBER;
    v_macrostato VARCHAR2(3) := NULL;
    --v6.1
    v_scad_stato    DATE;
    v_dta_dec_stato DATE;
    v_percorso      t_mcre0_app_all_data.cod_percorso%TYPE;
    v_processo      t_mcre0_app_all_data.cod_processo%TYPE;
    v_dta_processo  t_mcre0_app_all_data.dta_processo%TYPE;
    v_flg_stato_gb  t_mcre0_app_all_data.flg_stato_gb%TYPE;

    x NUMBER := 0;

  BEGIN
    SELECT seq_mcr0_log_app.nextval INTO seq FROM dual;

    --controllo se l'abi S stato elaborato
    IF (check_elaborazione_abi(p_abi_cart) != 1)
    THEN
      pkg_mcre0_audit.log_app(seq,
                              c_package || '.aggiorna stato ',
                              2,
                              SQLCODE,
                              'abi non elaborato',
                              p_abi_cart,
                              p_utente);
      RETURN abi_non_elaborato;

    END IF;
    --debug

    --salvo lo stato attuale Ante Update
    SELECT cod_stato,
           cod_sndg,
           dta_scadenza_stato,
           cod_percorso,
           cod_processo,
           dta_processo,
           dta_decorrenza_stato,
           flg_stato_gb
      INTO v_stato_pre,
           v_sndg,
           v_scad_stato,
           v_percorso,
           v_processo,
           v_dta_processo,
           v_dta_dec_stato, --v2.3, v6.1
           v_flg_stato_gb --v9.0
      FROM t_mcre0_app_all_data --v5.0 ex MOPLE
     WHERE cod_abi_cartolarizzato = p_abi_cart
       AND cod_ndg = p_ndg;
    pkg_mcre0_audit.log_app(seq,
                            c_package || '.aggiorna stato ',
                            3,
                            SQLCODE,
                            'start',
                            'abi: ' || p_abi_cart || ' ndg: ' || p_ndg ||
                            ' stato: ' || p_stato || '(precedente: ' ||
                            v_stato_pre || ') scadenza:' || p_data_scadenza,
                            p_utente);

    --v. 2.4

    SELECT CASE
             WHEN nvl(tip_stato, 'x') = 'U' THEN
              '1'
             ELSE
              '0'
           END,
           cod_macrostato
      INTO flg_uscita, v_macrostato
      FROM t_mcre0_app_stati
     WHERE cod_microstato = p_stato;

    --fine 2.4
    x := 1;

    IF v_stato_pre != p_stato
    THEN
      --storicizzo tutte le banche dell'SNDG - no commit
      esito_storico := pkg_mcre0_storicizza.insert_storico_sndg(p_abi_cart,
                                                                p_ndg,
                                                                v_sndg,
                                                                '0',
                                                                '0',
                                                                '1',
                                                                '0');
    ELSE
      esito_storico := ok;
    END IF;

    IF esito_storico = ok
    THEN

      --GESTIONE RISTRUTTURAZIONI: ramo standard
      IF p_stato != 'RS' AND
         v_stato_pre != 'RS'
      THEN
        x := 2;
        --v. 2.4
        UPDATE mcre_own.t_mcre0_app_all_data m --v5.0 mop
           SET m.cod_stato_precedente     = m.cod_stato,
               m.dta_decorrenza_stato_pre = m.dta_decorrenza_stato,
               m.cod_stato                = p_stato,
               m.dta_decorrenza_stato     = SYSDATE,
               m.dta_scadenza_stato = CASE
                                        WHEN (flg_uscita = '1') THEN
                                         to_date('31/12/9999', 'dd/mm/yyyy')
                                        ELSE
                                         p_data_scadenza
                                      END,
               m.dta_upd                  = SYSDATE,
               m.id_stato_posizione = CASE
                                        WHEN (flg_uscita = '1') THEN
                                         'S'
                                        ELSE
                                         'A'
                                      END,
               --v3.3 se stato uscita, aggiorno anche dtata e macrostato
               m.dta_dec_macrostato = CASE
                                        WHEN (flg_uscita = '1') THEN
                                         SYSDATE
                                        ELSE
                                         m.dta_dec_macrostato
                                      END,
               m.cod_macrostato = CASE
                                    WHEN (flg_uscita = '1') THEN
                                     v_macrostato
                                    ELSE
                                     m.cod_macrostato
                                  END,
               m.cod_operatore_ins_upd = p_utente --v5.0
         WHERE m.cod_abi_cartolarizzato = p_abi_cart
           AND m.cod_ndg = p_ndg;
        --fine v. 2.4

        --    UPDATE MCRE_OWN.T_MCRE0_APP_MOPLE m
        --    SET M.COD_STATO_PRECEDENTE     = M.COD_STATO,
        --      M.DTA_DECORRENZA_STATO_PRE   = M.DTA_DECORRENZA_STATO,
        --      M.COD_STATO                  = p_stato,
        --      M.DTA_DECORRENZA_STATO       = sysdate,
        --      M.DTA_SCADENZA_STATO         = p_data_scadenza,
        --      M.DTA_UPD                    = sysdate
        --    WHERE M.COD_ABI_CARTOLARIZZATO = p_abi_cart
        --    AND M.COD_NDG                  = p_ndg;
        num := SQL%ROWCOUNT;
        --commit;
        x := 3;

        --v9.0 gestisco l'eventuale cambio stato legato alla GB
        IF v_flg_stato_gb = '1' then

        UPDATE t_mcre0_app_all_data
           SET flg_source   = 0,
               flg_stato_gb = 2 --classificato
         WHERE cod_abi_cartolarizzato = p_abi_cart
           AND cod_ndg = p_ndg;

        --aggiorno anche il flag sulla GB gestione
        UPDATE t_mcre0_app_gb_gestione
           SET flg_stato = 2, --classificato
               dta_stato = SYSDATE
         WHERE cod_abi_cartolarizzato = p_abi_cart
           AND cod_ndg = p_ndg;

        END IF;


        --aggiorno mople --> no commit <--
        IF v_stato_pre != p_stato AND
           flg_uscita = '0'
        THEN
          esito := pkg_mcre0_gestione_all_data.fnc_gestione_macrost_cambiost(p_abi_cart,
                                                                             p_ndg,
                                                                             p_utente,
                                                                             seq);
        ELSE
          esito := ok;
        END IF;

      ELSE
        --entro o esco da RS!
        x := 4;
        --gestione percorsi (prima di update per gestione dta_macrostato)
        INSERT INTO t_mcre0_app_percorsi
          (cod_abi_istituto,
           cod_abi_cartolarizzato,
           cod_ndg,
           cod_stato_precedente,
           cod_stato,
           dta_decorrenza_stato,
           dta_scadenza_stato,
           cod_percorso,
           tms,
           cod_codutrm,
           cod_processo,
           dta_ins,
           dta_upd,
          -- cod_operatore_ins_upd,
           id_dper,
           dta_processo)
        VALUES
          (p_abi_cart,
           p_abi_cart,
           p_ndg,
           v_stato_pre,
           p_stato,
           trunc(SYSDATE),
           v_scad_stato,
           v_percorso,
           to_char(localtimestamp(6), 'yyyy-mm-dd-hh24.mi.ss.ff'),
           'MAN',
           v_processo,
           SYSDATE,
           SYSDATE,
          -- p_utente,
           to_number(to_char(SYSDATE, 'yyyymmdd')),
           v_dta_processo);

        x := 5;
        UPDATE mcre_own.t_mcre0_app_all_data m --v5.0 mop
           SET m.cod_stato_precedente     = m.cod_stato,
               m.dta_decorrenza_stato_pre = m.dta_decorrenza_stato,
               m.cod_stato                = p_stato,
               m.dta_decorrenza_stato     = trunc(SYSDATE),
               -- M.DTA_SCADENZA_STATO         = case when (flg_uscita='1') then to_date('31/12/9999','dd/mm/yyyy') else p_data_scadenza end,
               m.dta_upd = SYSDATE,
               -- M.ID_STATO_POSIZIONE         = case when (flg_uscita='1') then 'S' else 'A' end,
               --v3.3 se stato uscita, aggiorno anche dtata e macrostato
               m.dta_dec_macrostato   =
               (SELECT MIN(p.dta_decorrenza_stato) dta_dec_macrostato
                  FROM t_mcre0_app_percorsi p, t_mcre0_app_stati s2
                 WHERE p.cod_stato = s2.cod_microstato
                   AND cod_abi_cartolarizzato = p_abi_cart
                   AND cod_ndg = p_ndg
                   AND cod_percorso = v_percorso
                   AND s2.cod_macrostato = v_macrostato),
               m.cod_macrostato        = v_macrostato,
               m.cod_operatore_ins_upd = p_utente --v5.0
         WHERE m.cod_abi_cartolarizzato = p_abi_cart
           AND m.cod_ndg = p_ndg;

        num := SQL%ROWCOUNT;

        x := 6;
        --popola rs_posizioni
        IF (p_stato = 'RS')
        THEN
          x := 7;
          --censisco l'ingresso in stato Ristrutturato
          INSERT INTO t_mcre0_app_rs_posizioni
            (cod_abi_cartolarizzato,
             cod_ndg,
             dta_decorrenza_stato,
             dta_chiusura_stato,
             cod_stato_dest,
             cod_percorso,
             tms_ini,
             utente,
             cod_stato_orig,
             dta_stato_orig)
          VALUES
            (p_abi_cart,
             p_ndg,
             trunc(SYSDATE),
             NULL,
             NULL,
             v_percorso,
             to_char(localtimestamp(6), 'yyyy-mm-dd-hh24.mi.ss.ff'),
             p_utente,
             v_stato_pre,
             v_dta_dec_stato);

        ELSE
          x := 8;
          --chiudo il Ristrutturato
          UPDATE t_mcre0_app_rs_posizioni
             SET dta_chiusura_stato = SYSDATE,
                 cod_stato_dest     = p_stato,
                 tms_fine           = to_char(localtimestamp(6),
                                              'yyyy-mm-dd-hh24.mi.ss.ff')
           WHERE cod_abi_cartolarizzato = p_abi_cart
             AND cod_ndg = p_ndg
             AND cod_percorso = v_percorso
             AND dta_decorrenza_stato = v_dta_dec_stato; --max tms?!
          x := 9;
        END IF;
        esito := ok; ----- 3 SETTEMBRE  PER GESTIONE CAMBIO STATO DA IN A RS
      END IF;
      x := 10;
      IF esito = ok
      THEN

        pkg_mcre0_audit.log_app(seq,
                                c_package || '.aggiorna stato ',
                                3,
                                SQLCODE,
                                'end',
                                '',
                                p_utente);
        RETURN num;
      ELSE
        pkg_mcre0_audit.log_app(seq,
                                c_package ||
                                '.aggiorna stato -errore aggiorna parte-mople',
                                1,
                                SQLCODE,
                                '',
                                'abi: ' || p_abi_cart || ' ndg: ' || p_ndg,
                                p_utente);
        --ROLLBACK;
        RETURN ko;
      END IF;
    ELSE
      pkg_mcre0_audit.log_app(seq,
                              c_package ||
                              '.aggiorna stato -errore storicizza',
                              1,
                              SQLCODE,
                              '',
                              'abi: ' || p_abi_cart || ' ndg: ' || p_ndg,
                              p_utente);
      --ROLLBACK;
      RETURN ko;
    END IF;

  EXCEPTION
    WHEN OTHERS THEN
      pkg_mcre0_audit.log_app(seq,
                              c_package || '.aggiorna stato ',
                              1,
                              SQLCODE,
                              SQLERRM,
                              'abi: ' || p_abi_cart || ' ndg: ' || p_ndg ||
                              ' x:' || x,
                              p_utente);
      RETURN ko;

  END;

  --procedura per prenotare cambi comparto/gestore - no commit
  PROCEDURE assegna_posizione(p_cod_sndg         IN VARCHAR2,
                              p_cod_abi          IN VARCHAR2, --abi cart? per usi futuri..
                              p_cod_ndg          IN VARCHAR2,
                              p_cod_gruppo_super IN VARCHAR2,
                              p_id_utente        IN NUMBER, -- ID del gestore per assegna gestore (-1 = DISASSEGNA)
                              p_cod_comparto     IN VARCHAR2, -- CODICE comparto per assegna comparto
                              p_sezione          IN INTEGER DEFAULT 0, -- 1-assegna_posizione, 2-riassegna per cambio_stato, 3 riassegna
                              p_matr_assegnatore IN VARCHAR2,
                              p_rownum           OUT NUMBER) AS

    seq   NUMBER;
    esito NUMBER := 0;

  BEGIN
    p_rownum := 0;
    SELECT seq_mcr0_log_app.nextval INTO seq FROM dual;

    --se assegnatore o sezione non valorizzati esco
    IF (p_matr_assegnatore IS NULL OR nvl(p_sezione, 0) = 0)
    THEN
      pkg_mcre0_audit.log_app(seq,
                              c_package ||
                              '.assegna_posizione -  parametri non valorizzati',
                              1,
                              SQLCODE,
                              '',
                              'sezione: ' || p_sezione,
                              p_matr_assegnatore);
      RETURN;
    END IF;

    --debug
    pkg_mcre0_audit.log_app(seq,
                            c_package || '.assegna_posizione',
                            3,
                            SQLCODE,
                            'start',
                            'sezione: ' || p_sezione || ' id_utente: ' ||
                            p_id_utente || ' comparto: ' || p_cod_comparto,
                            p_matr_assegnatore);

    --se comparto e gestore non valorizzati rimuovo prenotazione ed esco v2.0
    IF (p_id_utente IS NULL AND p_cod_comparto IS NULL)
    THEN
      UPDATE t_mcre0_app_all_data fg --v5.0 fg
         SET fg.cod_matr_assegnatore      = NULL,
             fg.id_utente_preassegnato    = NULL,
             fg.cod_comparto_preassegnato = NULL,
             fg.cod_sezione_preassegnata  = NULL
       WHERE fg.cod_gruppo_super = p_cod_gruppo_super -- <--??
         AND fg.cod_matr_assegnatore = p_matr_assegnatore -- <--??
         AND fg.cod_sezione_preassegnata = p_sezione; -- <--??

      p_rownum := SQL%ROWCOUNT;
      RETURN;
    END IF;

    IF (p_sezione = 2 OR p_sezione = 3)
    THEN
      -- 18.02 non prima assegnazione!

      IF (p_id_utente IS NOT NULL)
      THEN
        --assegna gestore (o sbianca se -1!)

        UPDATE t_mcre0_app_all_data fg --v5.0 fg
           SET fg.cod_matr_assegnatore      = p_matr_assegnatore,
               fg.id_utente_preassegnato    = p_id_utente,
               fg.cod_comparto_preassegnato = p_cod_comparto,
               fg.cod_sezione_preassegnata  = p_sezione
         WHERE fg.cod_gruppo_super = p_cod_gruppo_super
              --10.02-check su vista dei collegati
              /* and (cod_abi_cartolarizzato, cod_ndg) in (select cod_abi_cartolarizzato, cod_ndg
                                                          from MCRE_OWN.V_MCRE0_APP_POS_COLLEGATE
                                                          where COD_GRUPPO_SUPER = P_COD_GRUPPO_SUPER
                                                          union
                                                          select cod_abi_cartolarizzato, cod_ndg
                                                          from MCRE_OWN.V_MCRE0_APP_POS_ASSEGNATE -- <-- ASSEGNATE
                                                          where cod_gruppo_super = P_COD_GRUPPO_SUPER)
              */
           AND ( --eventuale ccontrollo stati/gestore
                (fg.flg_gruppo_economico = '0' AND
                fg.flg_gruppo_legame = '0' AND
                ( --controllo stati
                  SELECT decode(p_id_utente, -1, 0, COUNT(stato))
                    FROM (SELECT DISTINCT m.cod_stato AS stato
                             FROM v_mcre0_app_upd_fields m
                            WHERE m.cod_sndg = p_cod_sndg
                              AND flg_stato_chk = '1'
                              AND m.cod_stato != 'GB'
                           MINUS
                           SELECT gs.cod_microstato AS stato
                             FROM t_mcre0_app_gestori_stati_comp gs
                            WHERE gs.id_utente = p_id_utente)

                  ) = 0) OR fg.flg_gruppo_economico = '1' OR
                fg.flg_gruppo_legame = '1')
           AND nvl(fg.cod_matr_assegnatore, p_matr_assegnatore) =
               p_matr_assegnatore
              --v3.5 gestisto le posizioni presenti sia in sezione 2 che 3
           AND nvl(fg.cod_sezione_preassegnata, p_sezione) = p_sezione;

        p_rownum := SQL%ROWCOUNT;

      ELSIF (p_cod_comparto IS NOT NULL)
      THEN
        --assegna comparto

        UPDATE t_mcre0_app_all_data fg --v5.0 fg
           SET fg.cod_matr_assegnatore      = p_matr_assegnatore,
               fg.id_utente_preassegnato    = p_id_utente,
               fg.cod_comparto_preassegnato = p_cod_comparto,
               fg.cod_sezione_preassegnata  = p_sezione
         WHERE fg.cod_gruppo_super = p_cod_gruppo_super
              --10.02-check su vista dei collegati
              /*  and (cod_abi_cartolarizzato, cod_ndg) in (select cod_abi_cartolarizzato, cod_ndg
                                                           from MCRE_OWN.V_MCRE0_APP_POS_COLLEGATE
                                                           where COD_GRUPPO_SUPER = P_COD_GRUPPO_SUPER
                                                           union
                                                           select cod_abi_cartolarizzato, cod_ndg
                                                           from MCRE_OWN.V_MCRE0_APP_POS_ASSEGNATE
                                                           where cod_gruppo_super = P_COD_GRUPPO_SUPER)
              */ --check assegnatore..
           AND nvl(fg.cod_matr_assegnatore, p_matr_assegnatore) =
               p_matr_assegnatore
              --v3.5 gestisto le posizioni presenti sia in sezione 2 che 3
           AND nvl(fg.cod_sezione_preassegnata, p_sezione) = p_sezione;

        p_rownum := SQL%ROWCOUNT;
      END IF;

      ----- VG 20120919
      IF (p_rownum > 0)
      THEN
        SELECT COUNT(*)
          INTO p_rownum
          FROM (SELECT cod_abi_cartolarizzato, cod_ndg
                  FROM mcre_own.v_mcre0_app_pos_collegate
                 WHERE cod_gruppo_super = p_cod_gruppo_super
                UNION
                SELECT cod_abi_cartolarizzato, cod_ndg
                  FROM mcre_own.v_mcre0_app_pos_assegnate -- <-- ASSEGNATE
                 WHERE cod_gruppo_super = p_cod_gruppo_super);
      END IF;

    ELSIF (p_sezione = 1)
    THEN
      -- 18.02  prima assegnazione!

      IF (p_id_utente IS NOT NULL)
      THEN
        --assegna gestore
        UPDATE t_mcre0_app_all_data fg --v5.0 fg
           SET fg.cod_matr_assegnatore      = p_matr_assegnatore,
               fg.id_utente_preassegnato    = p_id_utente,
               fg.cod_comparto_preassegnato = p_cod_comparto,
               fg.cod_sezione_preassegnata  = p_sezione
         WHERE fg.cod_gruppo_super = p_cod_gruppo_super
              --10.02-check su vista dei collegati
              /* and (cod_abi_cartolarizzato, cod_ndg) in (select cod_abi_cartolarizzato, cod_ndg
                                                            from MCRE_OWN.V_MCRE0_APP_POS_COLLEGATE
                                                            where COD_GRUPPO_SUPER = P_COD_GRUPPO_SUPER
                                                            union
                                                            select cod_abi_cartolarizzato, cod_ndg
                                                            from MCRE_OWN.V_MCRE0_APP_POS_DA_ASS  -- <-- DA ASSEGNARE
                                                            where cod_gruppo_super = P_COD_GRUPPO_SUPER)
              */
           AND ( --eventuale ccontrollo stati/gestore
                (fg.flg_gruppo_economico = '0' AND
                fg.flg_gruppo_legame = '0' AND
                ( --controllo stati
                  SELECT decode(p_id_utente, -1, 0, COUNT(stato))
                    FROM (SELECT DISTINCT m.cod_stato AS stato
                             FROM v_mcre0_app_upd_fields m
                            WHERE m.cod_sndg = p_cod_sndg
                              AND flg_stato_chk = '1'
                              AND m.cod_stato != 'GB'
                           MINUS
                           SELECT gs.cod_microstato AS stato
                             FROM t_mcre0_app_gestori_stati_comp gs
                            WHERE gs.id_utente = p_id_utente)

                  ) = 0) OR fg.flg_gruppo_economico = '1' OR
                fg.flg_gruppo_legame = '1')
              --check assegnatore..
           AND nvl(fg.cod_matr_assegnatore, p_matr_assegnatore) =
               p_matr_assegnatore;

        p_rownum := SQL%ROWCOUNT;

      ELSIF (p_cod_comparto IS NOT NULL)
      THEN
        --assegna comparto

        UPDATE t_mcre0_app_all_data fg --v5.0 fg
           SET fg.cod_matr_assegnatore      = p_matr_assegnatore,
               fg.id_utente_preassegnato    = p_id_utente,
               fg.cod_comparto_preassegnato = p_cod_comparto,
               fg.cod_sezione_preassegnata  = p_sezione
         WHERE fg.cod_gruppo_super = p_cod_gruppo_super
              --10.02-check su vista dei collegati
              /*  and (cod_abi_cartolarizzato, cod_ndg) in (select cod_abi_cartolarizzato, cod_ndg
                                                              from MCRE_OWN.V_MCRE0_APP_POS_COLLEGATE
                                                              where COD_GRUPPO_SUPER = P_COD_GRUPPO_SUPER
                                                              union
                                                              select cod_abi_cartolarizzato, cod_ndg
                                                              from MCRE_OWN.V_MCRE0_APP_POS_DA_ASS  -- <-- DA ASSEGNARE
                                                              where cod_gruppo_super = P_COD_GRUPPO_SUPER)
              */ --check assegnatore..
           AND nvl(fg.cod_matr_assegnatore, p_matr_assegnatore) =
               p_matr_assegnatore;
        p_rownum := SQL%ROWCOUNT;
      END IF;

      ----- VG 20120919
      IF (p_rownum > 0)
      THEN
        SELECT COUNT(*)
          INTO p_rownum
          FROM (SELECT cod_abi_cartolarizzato, cod_ndg
                  FROM mcre_own.v_mcre0_app_pos_collegate
                 WHERE cod_gruppo_super = p_cod_gruppo_super
                UNION
                SELECT cod_abi_cartolarizzato, cod_ndg
                  FROM mcre_own.v_mcre0_app_pos_da_ass -- <-- DA ASSEGNARE
                 WHERE cod_gruppo_super = p_cod_gruppo_super);
      END IF;

    END IF;

    ---P_ROWNUM:= SQL%RowCount; ad: spostato dopo ogni statement

    --v3.8 - chiamo il refresh!
    --esito := MCRE_OWN.PKG_MCRE0_AGGIORNA_MV.REFRESH_fast_SNP ( seq );

    pkg_mcre0_audit.log_app(seq,
                            c_package || '.assegna_posizione',
                            3,
                            SQLCODE,
                            'end',
                            'prenotate ' || p_rownum ||
                            ' posizioni- esito refresh: ' || esito,
                            p_matr_assegnatore);

  EXCEPTION
    WHEN OTHERS THEN
      pkg_mcre0_audit.log_app(seq,
                              c_package || '.assegna_posizione',
                              1,
                              SQLCODE,
                              SQLERRM,
                              'esito: -1',
                              p_matr_assegnatore);
      p_rownum := -1; --errror!!
      ROLLBACK;

  END;

  -- v3.3 procedura per prenotare cambi comparto/gestore bulk- commit!
  PROCEDURE assegna_posizione_blk(p_gestore      IN NUMBER, --gi¿ assegnato, da filtro
                                  p_macrostato   IN VARCHAR2, --da filtro
                                  p_cod_comparto IN VARCHAR2, --ccomparto gestore, per filtro
                                  p_id_utente    IN NUMBER, -- ID del gestore per assegna gestore (-1 = DISASSEGNA)
                                  --    P_SEZIONE IN INTEGER DEFAULT 3, -- 1-assegna_posizione, 2-riassegna per cambio_stato, 3 riassegna
                                  p_matr_assegnatore IN VARCHAR2,
                                  p_rownum           OUT NUMBER,
                                  --------------------   VG - CIB/BDT - INIZIO --------------------
                                  p_flg_girocomparto            t_mcre0_app_comparti.flg_girocomparto%TYPE,
                                  p_sezione                     IN INTEGER DEFAULT 0, -- 1-assegna_posizione, 2-riassegna per cambio_stato, 3 riassegna
                                  p_cod_abi_cartolarizzato      IN v_mcre0_app_pos_assegnate.cod_abi_cartolarizzato%TYPE DEFAULT NULL, ----da filtro
                                  p_cod_struttura_competente_rg IN mv_mcre0_denorm_str_org.cod_struttura_competente_rg%TYPE DEFAULT NULL, ----da filtro
                                  p_cod_struttura_competente_ar IN mv_mcre0_denorm_str_org.cod_struttura_competente_ar%TYPE DEFAULT NULL, ----da filtro
                                  --------------------   VG - CIB/BDT - FINE --------------------
                                  ---------------------   nuovi filtri ---------------------------
                                  p_data_rilev_da  IN DATE DEFAULT NULL,
                                  p_data_rilev_a   IN DATE DEFAULT NULL,
                                  p_cod_sndg       IN t_mcre0_app_all_data.cod_sndg%TYPE DEFAULT NULL,
                                  p_cod_ndg        IN t_mcre0_app_all_data.cod_ndg%TYPE DEFAULT NULL,
                                  p_processo       IN t_mcre0_app_all_data.cod_processo%TYPE DEFAULT NULL,
                                  p_nom_controp    IN t_mcre0_app_all_data.desc_nome_controparte%TYPE DEFAULT NULL,
                                  p_str_liv_compet IN VARCHAR2 DEFAULT NULL,
                                  p_gruppo         IN VARCHAR2 DEFAULT NULL,
                                  p_dec_stato_da   IN DATE DEFAULT NULL,
                                  p_dec_stato_a    IN DATE DEFAULT NULL,
                                  --07/05/2014 Parametri aggiungi per la variazione perimetro DR
                                  p_filiale IN VARCHAR2 DEFAULT NULL,
                                  p_assegn_da DATE DEFAULT NULL,
                                  p_assegn_a DATE DEFAULT NULL     ) AS

    seq NUMBER;
    ---------   VG      v_sezione number := 3;

    v_qry VARCHAR2(2000);

    v_stati NUMBER;

    assegnate bulk_tab;
    esito     NUMBER := 0;

    v_note t_mcre0_wrk_audit_applicativo.note%TYPE;

    v_data_rilev_da VARCHAR2(8);
    v_data_rilev_a  VARCHAR2(8);
    v_dec_stato_da  VARCHAR2(8);
    v_dec_stato_a   VARCHAR2(8);
    v_assegn_da  VARCHAR2(8);
    v_assegn_a VARCHAR2(8);

  BEGIN

    v_note := ' sezione: ' || p_sezione || ' Utente: ' || p_id_utente ||' p_flg_girocomparto: '||p_flg_girocomparto||
              ' Gestore originale: ' || p_gestore || ' MacroStato: ' ||
              p_macrostato || ' Comparto: ' || p_cod_comparto || ' Abi: ' ||
              p_cod_abi_cartolarizzato || ' Regione: ' ||
              p_cod_struttura_competente_rg || ' Area: ' ||
              p_cod_struttura_competente_ar || ' Data Rilev da :' ||
              p_data_rilev_da || ' Data Rilev a :' || p_data_rilev_a ||
              ' Sndg :' || p_cod_sndg || ' Ndg: ' || p_cod_ndg ||
              ' Processo: ' || p_processo || ' Nome Controparte: ' ||
              p_nom_controp || ' Struttura\Livello: ' || p_str_liv_compet ||
              ' Gruppo: ' || p_gruppo || ' Dec stato da : ' ||
              p_dec_stato_da || ' Dec stato a: ' || p_dec_stato_a ||
              --07/05/2014 parametri per variazione perimetro DR
              'filiale: ' || p_filiale || 'assegn da:' || p_assegn_da ||
              'assegn a: ' || p_assegn_a ;

    --se assegnatore o sezione non valorizzati esco
    IF (p_matr_assegnatore IS NULL)
    THEN
      pkg_mcre0_audit.log_app(c_package ||
                              '.assegna_posizione_blk -  parametri non valorizzati',
                              1,
                              SQLCODE,
                              '',
                              'Matr_Assegnatore nullo - ' || v_note,
                              p_matr_assegnatore);
      RETURN;
    END IF;

    p_rownum := 0;
    SELECT seq_mcr0_log_app.nextval INTO seq FROM dual;

    --debug
    pkg_mcre0_audit.log_app(seq,
                            c_package || '.assegna_posizione_blk',
                            3,
                            SQLCODE,
                            'start',
                            v_note,
                            p_matr_assegnatore);

    --------------------   VG - CIB/BDT - INIZIO --------------------
    IF (p_sezione = 1)
    THEN
      v_qry := 'SELECT bulk_row(a.cod_abi_cartolarizzato, a.cod_ndg, a.cod_gruppo_super, a.cod_stato,  a.flg_gruppo)
             FROM MCRE_OWN.V_MCRE0_APP_POS_DA_ASS a,
            t_mcre0_app_all_data c  WHERE 1 = 1
            and a.COD_ABI_CARTOLARIZZATO = c.COD_ABI_CARTOLARIZZATO
            and a.cod_ndg = c.cod_ndg
            and a.cod_sndg = c.cod_sndg
            and ( c.COD_MATR_ASSEGNATORE is null or c.cod_matr_assegnatore =  ' || '''' ||
               p_matr_assegnatore || '''' || ') and a.FLG_GIROCOMPARTO =  ' || '''' ||
               p_flg_girocomparto || '''';
    ELSIF (p_sezione = 3)
    THEN
      v_qry := 'SELECT bulk_row(a.cod_abi_cartolarizzato, a.cod_ndg, a.cod_gruppo_super, a.cod_stato,  a.flg_gruppo)
            FROM MCRE_OWN.V_MCRE0_APP_POS_ASSEGNATE a,
            t_mcre0_app_all_data c  WHERE 1 = 1
            and a.COD_ABI_CARTOLARIZZATO = c.COD_ABI_CARTOLARIZZATO
            and a.cod_ndg = c.cod_ndg
            and a.cod_sndg = c.cod_sndg
            and ( c.COD_MATR_ASSEGNATORE is null or c.cod_matr_assegnatore = ' || '''' ||
               p_matr_assegnatore || '''' || ') and a.FLG_GIROCOMPARTO =  ' || '''' ||
               p_flg_girocomparto || '''';
    ELSE
      v_qry := 'SELECT bulk_row(a.cod_abi_cartolarizzato, a.cod_ndg, a.cod_gruppo_super, a.cod_stato,  a.flg_gruppo)
             FROM MCRE_OWN.V_MCRE0_APP_POS_ASSEGNATE a,
            t_mcre0_app_all_data c  WHERE 1 = 1
            and a.COD_ABI_CARTOLARIZZATO = c.COD_ABI_CARTOLARIZZATO
            and a.cod_ndg = c.cod_ndg
            and a.cod_sndg = c.cod_sndg
            and ( c.COD_MATR_ASSEGNATORE is null or c.cod_matr_assegnatore = ' || '''' ||
               p_matr_assegnatore || '''' || ') and a.FLG_GIROCOMPARTO =  ' || '''' ||
               p_flg_girocomparto || '''';
    END IF;

    --------------------   VG - CIB/BDT - FINE --------------------

    IF (p_gestore IS NOT NULL)
    THEN
      v_qry := v_qry || ' and a.id_utente = ' || p_gestore;
    END IF;
    IF (p_cod_comparto IS NOT NULL)
    THEN
      v_qry := v_qry || ' and a.cod_comparto = ''' || p_cod_comparto || '''';
    END IF;
    IF (p_macrostato IS NOT NULL)
    THEN
      v_qry := v_qry || ' and a.cod_stato in (select cod_microstato from
        t_mcre0_app_stati where cod_macrostato = ''' ||
               p_macrostato || ''')';
    END IF;
    --------------------   VG - CIB/BDT - INIZIO --------------------
    IF (p_cod_abi_cartolarizzato IS NOT NULL)
    THEN
      v_qry := v_qry || ' and a.COD_abi_cartolarizzato = ''' ||
               p_cod_abi_cartolarizzato || '''';
    END IF;
    IF (p_cod_struttura_competente_rg IS NOT NULL)
    THEN
      v_qry := v_qry || ' and a.COD_STRUTTURA_COMPETENTE_RG = ''' ||
               p_cod_struttura_competente_rg || '''';
    END IF;
    IF (p_cod_struttura_competente_rg IS NOT NULL)
    THEN
      v_qry := v_qry || ' and a.COD_STRUTTURA_COMPETENTE_AR = ''' ||
               p_cod_struttura_competente_ar || '''';
    END IF;
    --------------------   VG - CIB/BDT - FINE --------------------

    --------------------    NUOVI FILTRI       ---------------------
    IF (p_data_rilev_da IS NOT NULL)
    THEN
      v_data_rilev_da := to_char(p_data_rilev_da, 'YYYYMMDD');
      v_qry           := v_qry || ' and a.DTA_INS_ALERT >= TO_DATE(''' ||
                         v_data_rilev_da || ''',''YYYYMMDD'')';
    END IF;
    IF (p_data_rilev_a IS NOT NULL)
    THEN
      v_data_rilev_a := to_char(p_data_rilev_a, 'YYYYMMDD');
      v_qry          := v_qry || ' and a.DTA_INS_ALERT <= TO_DATE(''' ||
                        v_data_rilev_a || ''',''YYYYMMDD'')';
    END IF;
    IF (p_cod_sndg IS NOT NULL)
    THEN
      v_qry := v_qry || ' and a.COD_SNDG = lpad(''' || p_cod_sndg ||
               ''',16,0)';
    END IF;
    IF (p_cod_ndg IS NOT NULL)
    THEN
      v_qry := v_qry || ' and a.COD_NDG = lpad(''' || p_cod_ndg ||
               ''',16,''0'')';
    END IF;
    IF (p_processo IS NOT NULL)
    THEN
      v_qry := v_qry || ' and UPPER(a.COD_PROCESSO) = UPPER(''' ||
               p_processo || ''')';
    END IF;
    IF (p_nom_controp IS NOT NULL)
    THEN
      v_qry := v_qry || ' and UPPER(a.DESC_NOME_CONTROPARTE) like UPPER(''%' ||
               p_nom_controp || '%'')';
    END IF;
    IF (p_str_liv_compet IS NOT NULL)
    THEN
      v_qry := v_qry || ' and a.COD_COMPARTO = ''' || p_str_liv_compet || '''';
    END IF;
    IF (p_gruppo IS NOT NULL)
    THEN
      v_qry := v_qry || ' and UPPER(a.VAL_ANA_GRE) like UPPER(''%' || p_gruppo ||
               '%'')';
    END IF;
    IF (p_dec_stato_da IS NOT NULL)
    THEN
      v_dec_stato_da := to_char(p_dec_stato_da, 'YYYYMMDD');
      v_qry          := v_qry ||
                        ' and a.DTA_DECORRENZA_STATO >= TO_DATE(''' ||
                        v_dec_stato_da || ''',''YYYYMMDD'')';
    END IF;
    IF (p_dec_stato_a IS NOT NULL)
    THEN
      v_dec_stato_a := to_char(p_dec_stato_a, 'YYYYMMDD');
      v_qry         := v_qry || ' and a.DTA_DECORRENZA_STATO <= TO_DATE(''' ||
                       v_dec_stato_a || ''',''YYYYMMDD'')';
    END IF;

--07/05/2014 filtri su DTA_UTENTE_ASSEGNATO e cod_struttura_competente_fi per variazione perimetro DR

 IF (p_filiale IS NOT NULL)
 THEN
  v_qry := v_qry || ' and a.cod_struttura_competente_fi = ''' || p_filiale || '''';
  END IF;

    IF (P_ASSEGN_DA IS NOT NULL)
    THEN
      v_assegn_da := to_char(P_ASSEGN_DA, 'YYYYMMDD');
      v_qry           := v_qry || ' and a.DTA_UTENTE_ASSEGNATO >= TO_DATE(''' ||
                         v_assegn_da || ''',''YYYYMMDD'')';
    END IF;
    IF (P_ASSEGN_A IS NOT NULL)
    THEN
      v_assegn_a := to_char(P_ASSEGN_A, 'YYYYMMDD');
      v_qry          := v_qry || ' and a.DTA_UTENTE_ASSEGNATO <= TO_DATE(''' ||
                        v_assegn_a || ''',''YYYYMMDD'')';
    END IF;

    dbms_output.put_line(v_qry);
    EXECUTE IMMEDIATE v_qry BULK COLLECT
      INTO assegnate;
    pkg_mcre0_audit.log_app(seq,
                            c_package || '.assegna_posizione_blk',
                            3,
                            SQLCODE,
                            'bulk collect',
                            v_note,
                            p_matr_assegnatore);

    --se comparto e gestore non valorizzati rimuovo prenotazione ed esco v2.0
    IF (p_id_utente IS NULL)
    THEN
      UPDATE t_mcre0_app_all_data fg --v5.0 fg
         SET fg.cod_matr_assegnatore      = NULL,
             fg.id_utente_preassegnato    = NULL,
             fg.cod_comparto_preassegnato = NULL,
             fg.cod_sezione_preassegnata  = NULL
       WHERE (fg.cod_matr_assegnatore = p_matr_assegnatore AND
             fg.cod_sezione_preassegnata = p_sezione) -- <--??
            --v3.5 checck sezione
         AND fg.cod_gruppo_super IN
             (SELECT cod_gruppo_super
                FROM TABLE(CAST(assegnate AS bulk_tab)));

      p_rownum := SQL%ROWCOUNT;
      COMMIT;

      --v3.8 - chiamo il refresh!
      --esito := MCRE_OWN.PKG_MCRE0_AGGIORNA_MV.REFRESH_fast_SNP ( seq );

      pkg_mcre0_audit.log_app(seq,
                              c_package || '.assegna_posizione_blk',
                              3,
                              SQLCODE,
                              'end',
                              'annullate ' || p_rownum ||
                              ' posizioni - esito refresh: ' || esito ||
                              ' - ' || v_note,
                              p_matr_assegnatore);
      RETURN;
    END IF;

    --  IF (P_SEZIONE = 3) THEN -- per ora solo per gi¿ assegnate!

    --assegna gestore (o sbianca se -1!)

    --controlo gli stati per i 'singoli', tranne per le disassegnazioni
    SELECT decode(p_id_utente, -1, 0, COUNT(stato))
      INTO v_stati
      FROM (SELECT DISTINCT cod_stato AS stato
              FROM TABLE(CAST(assegnate AS bulk_tab))
             WHERE flg_gruppo = 'S'
            MINUS
            SELECT gs.cod_microstato AS stato
              FROM t_mcre0_app_gestori_stati_comp gs
             WHERE gs.id_utente = p_id_utente);

    IF (v_stati = 0 AND p_sezione = 3)
    THEN

      UPDATE t_mcre0_app_all_data fg --v5.0 fg
         SET fg.cod_matr_assegnatore   = p_matr_assegnatore,
             fg.id_utente_preassegnato = p_id_utente,
             --FG.COD_COMPARTO_PREASSEGNATO = P_COD_COMPARTO,
             fg.cod_sezione_preassegnata = p_sezione
       WHERE (cod_abi_cartolarizzato, cod_ndg) IN
             (SELECT cod_abi_cartolarizzato, cod_ndg
                FROM mcre_own.v_mcre0_app_pos_collegate
               WHERE cod_gruppo_super IN
                     (SELECT cod_gruppo_super
                        FROM TABLE(CAST(assegnate AS bulk_tab)))
              UNION
              SELECT cod_abi_cartolarizzato, cod_ndg
              --v3.6 - tutte le assegnate, senza filtro!
                FROM mcre_own.v_mcre0_app_pos_assegnate
               WHERE cod_gruppo_super IN
                     (SELECT cod_gruppo_super
                        FROM TABLE(CAST(assegnate AS bulk_tab))))
            --check assegnatore..
         AND nvl(fg.cod_matr_assegnatore, p_matr_assegnatore) =
             p_matr_assegnatore
            --v3.5 check sezione (solo 3!)
         AND nvl(fg.cod_sezione_preassegnata, p_sezione) = p_sezione;

    ELSIF (v_stati = 0 AND p_sezione = 1)
    THEN

      UPDATE t_mcre0_app_all_data fg --v5.0 fg
         SET fg.cod_matr_assegnatore   = p_matr_assegnatore,
             fg.id_utente_preassegnato = p_id_utente,
             --FG.COD_COMPARTO_PREASSEGNATO = P_COD_COMPARTO,
             fg.cod_sezione_preassegnata = p_sezione
       WHERE (cod_abi_cartolarizzato, cod_ndg) IN
             (SELECT cod_abi_cartolarizzato, cod_ndg
                FROM mcre_own.v_mcre0_app_pos_collegate
               WHERE cod_gruppo_super IN
                     (SELECT cod_gruppo_super
                        FROM TABLE(CAST(assegnate AS bulk_tab)))
              UNION
              SELECT cod_abi_cartolarizzato, cod_ndg
              --v3.6 - tutte le assegnate, senza filtro!
                FROM mcre_own.v_mcre0_app_pos_da_ass
               WHERE cod_gruppo_super IN
                     (SELECT cod_gruppo_super
                        FROM TABLE(CAST(assegnate AS bulk_tab))))
            --check assegnatore..
         AND nvl(fg.cod_matr_assegnatore, p_matr_assegnatore) =
             p_matr_assegnatore
            --v3.5 check sezione (solo 3!)
         AND nvl(fg.cod_sezione_preassegnata, p_sezione) = p_sezione;

    ELSE

      pkg_mcre0_audit.log_app(seq,
                              c_package || '.assegna_posizione_blk',
                              3,
                              SQLCODE,
                              'controllo stati '||v_stati,
                              'stati non compatibili per il gestore destinazione - ' ||
                              p_id_utente || ' - ' || v_note,
                              p_matr_assegnatore);

    END IF;
    --END IF;

    p_rownum := SQL%ROWCOUNT;
    COMMIT;

    --v3.8 - chiamo il refresh!
    --esito := MCRE_OWN.PKG_MCRE0_AGGIORNA_MV.REFRESH_fast_SNP ( seq );

    pkg_mcre0_audit.log_app(seq,
                            c_package || '.assegna_posizione_blk',
                            3,
                            SQLCODE,
                            'end',
                            'prenotate ' || p_rownum ||
                            ' posizioni - esito refresh: ' || esito ||
                            ' - ' || v_note,
                            p_matr_assegnatore);

  EXCEPTION
    WHEN OTHERS THEN
      pkg_mcre0_audit.log_app(seq,
                              c_package || '.assegna_posizione_blk',
                              1,
                              SQLCODE,
                              SQLERRM,
                              'esito: -1' || ' - ' || v_note,
                              p_matr_assegnatore);
      ROLLBACK;
      p_rownum := -1; --errror!!

  END;

  --aggiorna processo su singola posizione mople.. no commit
  --v3.2 aggiunto p_utente (default null)
  FUNCTION aggiorna_processo(p_abi_cart VARCHAR2,
                             p_ndg      VARCHAR2,
                             p_processo VARCHAR2,
                             p_utente   VARCHAR2 DEFAULT NULL) RETURN NUMBER IS

    esito NUMBER := 0;
    seq   NUMBER;

  BEGIN
    --controllo se l'abi S stato elaborato
    IF (check_elaborazione_abi(p_abi_cart) != 1)
    THEN
      pkg_mcre0_audit.log_app(seq,
                              c_package || '.aggiorna processo ',
                              2,
                              SQLCODE,
                              'abi non elaborato',
                              p_abi_cart,
                              p_utente);
      RETURN abi_non_elaborato;

    END IF;

    SELECT seq_mcr0_log_app.nextval INTO seq FROM dual;

    --debug
    pkg_mcre0_audit.log_app(seq,
                            c_package || '.aggiorna_processo',
                            3,
                            SQLCODE,
                            'start',
                            'abi: ' || p_abi_cart || ' ndg: ' || p_ndg ||
                            ' processo: ' || p_processo,
                            p_utente);

    UPDATE mcre_own.t_mcre0_app_all_data m --v5.0 Mople
       SET m.cod_processo_pre = m.cod_processo,
           m.cod_processo     = p_processo,
           m.dta_processo     = SYSDATE
     WHERE m.cod_abi_cartolarizzato = p_abi_cart
       AND m.cod_ndg = p_ndg
       AND m.today_flg = '1';

    esito := SQL%ROWCOUNT;

    pkg_mcre0_audit.log_app(seq,
                            c_package || '.aggiorna_processo',
                            3,
                            SQLCODE,
                            'end',
                            'abi: ' || p_abi_cart || ' ndg: ' || p_ndg ||
                            ' processo: ' || p_processo,
                            p_utente);
    RETURN esito;

  EXCEPTION
    WHEN OTHERS THEN
      pkg_mcre0_audit.log_app(seq,
                              c_package || '.aggiorna_processo',
                              1,
                              SQLCODE,
                              SQLERRM,
                              'abi: ' || p_abi_cart || ' ndg: ' || p_ndg ||
                              ' processo: ' || p_processo,
                              p_utente);
      RETURN 0;
  END;

  --inserisce nuova posizione su mople e file guida.. no commit
  --v3.2 aggiunto p_utente (default null)
  FUNCTION inserisci_posizione(p_abi_cart  VARCHAR2,
                               p_ndg       VARCHAR2,
                               p_stato     VARCHAR2,
                               p_processo  VARCHAR2,
                               p_tipo_elab VARCHAR2,
                               p_utente    VARCHAR2 DEFAULT NULL)
    RETURN NUMBER IS

    v_abi                VARCHAR2(5);
    v_outs               VARCHAR2(1);
    v_iddper_fg          VARCHAR2(8);
    v_iddper_mo          VARCHAR2(8);
    v_macros             VARCHAR2(3) := NULL;
    v_dta_scadenza_stato DATE;
    v_flg_outsourcing    VARCHAR2(1);
    v_gruppo_super       VARCHAR2(20);
    v_sndg               VARCHAR2(16);
    esito                NUMBER;
    seq                  NUMBER;
    v_desc               mv_mcre0_app_istituti.desc_istituto%TYPE;
    v_descb              mv_mcre0_app_istituti.desc_breve%TYPE;
    v_target             VARCHAR2(1);
    v_cart               VARCHAR2(1);
    v_data_elab          DATE;
    esiste               NUMBER := 0;

  BEGIN

    --controllo se l'abi S stato elaborato
    IF (check_elaborazione_abi(p_abi_cart) != 1)
    THEN
      pkg_mcre0_audit.log_app(seq,
                              c_package || '.inserisci_posizione ',
                              2,
                              SQLCODE,
                              'abi non elaborato',
                              p_abi_cart,
                              p_utente);
      RETURN abi_non_elaborato;

    END IF;

    SELECT seq_mcr0_log_app.nextval INTO seq FROM dual;

    pkg_mcre0_audit.log_app(seq,
                            c_package || '.inserisci_posizione',
                            3,
                            SQLCODE,
                            'start',
                            'p_abi_cart: ' || p_abi_cart || '
    p_ndg: ' || p_ndg || ' p_stato: ' || p_stato ||
                            ' p_processo: ' || p_processo ||
                            ' p_tipo_elab: ' || p_tipo_elab,
                            p_utente);

    --recupero l'isituto non cart e il flg_outsourcing
    SELECT decode(flg_cartolarizzato, 'Y', cod_abi_visualizzato, cod_abi),
           nvl(flg_outsourcing, 'N'),
           i.desc_istituto,
           i.desc_breve,
           flg_target,
           flg_cartolarizzato,
           dta_abi_elab
      INTO v_abi, v_outs, v_desc, v_descb, v_target, v_cart, v_data_elab
      FROM mcre_own.mv_mcre0_app_istituti i
     WHERE cod_abi = p_abi_cart;

    --recupero il macrostato
    BEGIN
      SELECT cod_macrostato
        INTO v_macros
        FROM mcre_own.t_mcre0_app_stati
       WHERE cod_microstato = p_stato;
    EXCEPTION
      WHEN OTHERS THEN
        v_macros := NULL;
    END;

    --recupero gli IDDPER
    SELECT idper
      INTO v_iddper_fg
      FROM mcre_own.v_mcre0_ultima_acquisizione
     WHERE cod_file = 'FILE_GUIDA';

    SELECT idper
      INTO v_iddper_mo
      FROM mcre_own.v_mcre0_ultima_acquisizione
     WHERE cod_file = 'MOPLE';

    --recupero la durata di default della scandeza stato 21/02
    BEGIN
      SELECT SYSDATE + nvl(val_durata_gg_deflt, 0)
        INTO v_dta_scadenza_stato
        FROM t_mcre0_app_processi_stati
       WHERE cod_abi_istituto = p_abi_cart
         AND cod_microstato = p_stato
         AND cod_processo = p_processo;

    EXCEPTION
      WHEN no_data_found THEN
        v_dta_scadenza_stato := SYSDATE;
    END;

    -- recupero il flg_outsourcing --ha senso???
    BEGIN
      SELECT CASE
               WHEN a.cod_stato = 'SO' THEN
                decode(b.cod_livello,
                       'PL',
                       'N',
                       'IP',
                       'N',
                       'IC',
                       'N',
                       'RC',
                       'N',
                       nvl(c.flg_outsourcing, 'N'))
               ELSE
                nvl(c.flg_outsourcing, 'N')
             END flg_outsourcing
        INTO v_flg_outsourcing
        FROM t_mcre0_app_all_data      a,
             t_mcre0_app_struttura_org b,
             t_mcre0_app_istituti      c
       WHERE a.cod_abi_cartolarizzato = b.cod_abi_istituto --(+)
         AND a.cod_struttura_competente = b.cod_struttura_competente --(+)
         AND c.cod_abi = a.cod_abi_cartolarizzato
         AND a.cod_abi_cartolarizzato = p_abi_cart --v_abi????
         AND a.cod_ndg = p_ndg;

    EXCEPTION
      WHEN no_data_found THEN
        v_flg_outsourcing := v_outs;

    END;

    --insert/Update su all_data

    --v5.2 potrebbe esistere ma con today_flg a 0.. non devo duplicare la riga..
    SELECT COUNT(*)
      INTO esiste
      FROM t_mcre0_app_all_data
     WHERE cod_abi_cartolarizzato = p_abi_cart
       AND cod_ndg = p_ndg;

    IF esiste = 0
    THEN
      INSERT INTO t_mcre0_app_all_data
        (today_flg,
         cod_abi_istituto,
         cod_abi_cartolarizzato,
         cod_ndg,
         flg_gruppo_economico,
         flg_gruppo_legame,
         flg_singolo,
         flg_condiviso,
         cod_gruppo_super,
         id_utente,
         id_utente_pre,
         cod_operatore_ins_upd,
         dta_ins,
         dta_upd,
         id_dperfg,
         flg_somma,
         flg_source,
         flg_active,
         cod_tipo_ingresso,
         cod_causale_ingresso,
         cod_percorso,
         cod_processo,
         dta_intercettamento,
         cod_stato,
         dta_decorrenza_stato,
         dta_scadenza_stato,
         cod_stato_precedente,
         dta_processo,
         cod_macrostato,
         dta_dec_macrostato,
         id_stato_posizione,
         id_dpermo,
         id_transizione,
         flg_outsourcing,
         desc_istituto,
         desc_breve,
         flg_target,
         flg_cartolarizzato,
         dta_abi_elab)
      VALUES
        ('1',
         v_abi,
         p_abi_cart,
         p_ndg,
         '0',
         '0',
         '1',
         '0',
         'X' || p_abi_cart || substr(p_ndg, 0, 14),
         -1,
         -1,
         'MOPLE',
         SYSDATE,
         SYSDATE,
         v_iddper_fg,
         '1',
         '0',
         '1',
         'M',
         'M',
         1,
         p_processo,
         SYSDATE,
         p_stato,
         SYSDATE,
         v_dta_scadenza_stato,
         'BO',
         SYSDATE,
         v_macros,
         SYSDATE,
         'A',
         v_iddper_mo,
         'M',
         v_flg_outsourcing,
         v_desc,
         v_descb,
         v_target,
         v_cart,
         v_data_elab);

    ELSE
      UPDATE t_mcre0_app_all_data
         SET today_flg                = '1',
             cod_operatore_ins_upd    = 'MOPLE',
             dta_upd                  = SYSDATE,
             id_dperfg                = v_iddper_fg,
             flg_active               = '1',
             cod_tipo_ingresso        = 'M',
             cod_causale_ingresso     = 'M',
             dta_intercettamento      = SYSDATE,
             cod_percorso             = cod_percorso + 1,
             cod_stato_precedente     = cod_stato,
             cod_stato                = p_stato,
             dta_decorrenza_stato_pre = dta_decorrenza_stato,
             dta_decorrenza_stato     = SYSDATE,
             id_stato_posizione       = 'A',
             id_dpermo                = v_iddper_mo,
             cod_macrostato           = v_macros,
             dta_dec_macrostato       = SYSDATE,
             id_transizione           = 'M',
             dta_processo             = SYSDATE,
             cod_processo_pre         = cod_processo,
             cod_processo             = p_processo
       WHERE cod_abi_istituto = p_abi_cart
         AND cod_ndg = p_ndg;

    END IF;

    pkg_mcre0_audit.log_app(seq,
                            c_package || '.inserisci_posizione',
                            3,
                            SQLCODE,
                            'end',
                            'abi: ' || p_abi_cart || ' ndg: ' || p_ndg,
                            p_utente);
    RETURN ok;

  EXCEPTION
    WHEN OTHERS THEN
      pkg_mcre0_audit.log_app(seq,
                              c_package || '.inserisci_posizione',
                              1,
                              SQLCODE,
                              SQLERRM,
                              'abi: ' || p_abi_cart || ' ndg: ' || p_ndg,
                              p_utente);
      RETURN ko;
  END;

  --v3.5 inserisce in mople tutti i GB se gi¿ collegati - commit  + refresh
  PROCEDURE inserisci_gb(p_utente IN VARCHAR2, p_rownum OUT NUMBER) IS

    seq     NUMBER;
    v_idper NUMBER;
    esito   NUMBER := 0;
    counter NUMBER := 0;
    new_gb  host_tab;
    v_abi   VARCHAR2(5);
    v_ndg   VARCHAR2(16);

    CURSOR nuovi IS
      SELECT cod_abi_cartolarizzato, cod_ndg
        FROM mcre_own.v_mcre0_app_gb_gestione gb
       WHERE gb.flg_stato = 1
         AND gb.cod_comparto IS NOT NULL
         AND gb.dta_stato >= trunc(SYSDATE);

  BEGIN
    p_rownum := 0;
    SELECT seq_mcr0_log_app.nextval INTO seq FROM dual;

    --debug
    pkg_mcre0_audit.log_app(seq,
                            c_package || '.inserisci_gb',
                            3,
                            SQLCODE,
                            'insert',
                            '',
                            p_utente);

    MERGE INTO t_mcre0_app_all_data a
    USING (SELECT cod_abi_cartolarizzato,
                  cod_ndg,
                  cod_struttura_competente_fi,
                  cod_processo_calcolato,
                  cod_processo,
                  cod_macrostato_proposto,
                  cod_comparto_proposto,
                  dta_ins,
                  flg_stato,
                  dta_stato
             FROM mcre_own.v_mcre0_app_gb_gestione gb
            WHERE gb.flg_stato = 1
              AND gb.cod_comparto IS NOT NULL
              AND gb.dta_stato >= trunc(SYSDATE)) b
    ON (b.cod_abi_cartolarizzato = a.cod_abi_cartolarizzato AND b.cod_ndg = a.cod_ndg)
    WHEN MATCHED THEN
      UPDATE
         SET cod_filiale_gb            = b.cod_struttura_competente_fi,
             cod_processo_calcolato_gb = b.cod_processo_calcolato,
             --COD_PROCESSO_GB            = B.COD_PROCESSO,
             cod_macrostato_proposto_gb = b.cod_macrostato_proposto,
             --COD_COMPARTO_PROPOSTO_GB   = B.COD_COMPARTO_PROPOSTO,
             dta_ins_gb   = b.dta_ins,
             flg_stato_gb = b.flg_stato,
             --DTA_STATO_GB               = B.DTA_STATO,
             flg_source = decode(cod_stato, '-1', 2, 1),
             flg_active = '1',
             today_flg  = '1';

    p_rownum := SQL%ROWCOUNT;
    COMMIT;
    pkg_mcre0_audit.log_app(seq,
                            c_package || '.inserisci_gb',
                            3,
                            SQLCODE,
                            'MERGE',
                            'aggiornati' || p_rownum || 'record',
                            p_utente);

    --esito := MCRE_OWN.PKG_MCRE0_AGGIORNA_MV.REFRESH_FAST_SNP;
    --PKG_MCRE0_AUDIT.LOG_APP ( seq, c_package||'.inserisci_gb', 3, SQLCODE, 'refresh mv', 'Esito: '||esito, p_utente);

    --se ci sono aggiornamenti immediati
    IF p_rownum > 0
    THEN

      OPEN nuovi;
      LOOP
        FETCH nuovi
          INTO v_abi, v_ndg;
        EXIT WHEN nuovi%NOTFOUND;
        --aggiorno gli alert per le nuove posizioni
        esito   := esito +
                   pkg_mcre0_alert.fnc_verifica_alert_ndg(v_abi,
                                                          v_ndg,
                                                          NULL,
                                                          NULL);
        counter := counter + 1;

      END LOOP;
      CLOSE nuovi;

      IF (esito != counter)
      THEN
        pkg_mcre0_audit.log_app(seq,
                                c_package || '.inserisci_gb',
                                1,
                                SQLCODE,
                                'calcolo alert',
                                'calcolati ' || esito || ' alert su ' ||
                                counter,
                                p_utente);
      ELSE
        pkg_mcre0_audit.log_app(seq,
                                c_package || '.inserisci_gb ',
                                3,
                                SQLCODE,
                                'calcolati ' || counter || ' alert',
                                ' nuovi gb: ' || p_rownum,
                                p_utente);
      END IF;

    END IF;

  EXCEPTION
    WHEN OTHERS THEN
      pkg_mcre0_audit.log_app(seq,
                              c_package || '.inserisci_gb',
                              1,
                              SQLCODE,
                              SQLERRM,
                              '',
                              p_utente);
      ROLLBACK;
      p_rownum := 0;
  END;

  --funzione da chiamare da portale, dopo aver effettuato l'update su HOST
  --chiamata al refresh delle MV e alert da effettuare esternamente --no commit
  FUNCTION classifica_gb(p_abi_cart      IN VARCHAR2,
                         p_ndg           IN VARCHAR2,
                         p_sndg          IN VARCHAR2,
                         p_stato         VARCHAR2,
                         p_processo      VARCHAR2,
                         p_data_scadenza DATE,
                         p_utente        VARCHAR2,
                         p_tipo_utente   CHAR default null) RETURN NUMBER IS
    esito         NUMBER := 0;
    esito_storico NUMBER := 0;
    v_sndg        VARCHAR2(16) := NULL;
    v_utente      NUMBER := NULL;
    num           NUMBER := 0;
    deleted       NUMBER := 0;
    v_stato_pre   VARCHAR2(2) := NULL;
    -- v. 2.4
    flg_uscita   VARCHAR2(1) := 0;
    seq          NUMBER;
    v_macrostato VARCHAR2(3) := NULL;

  BEGIN
    SELECT seq_mcr0_log_app.nextval INTO seq FROM dual;

    --controllo se l'abi S stato elaborato
    IF (check_elaborazione_abi(p_abi_cart) != 1)
    THEN
      pkg_mcre0_audit.log_app(seq,
                              c_package || '.classifica_GB ',
                              2,
                              SQLCODE,
                              'abi non elaborato',
                              p_abi_cart,
                              p_utente);
      RETURN abi_non_elaborato;

    END IF;
    --debug

    BEGIN
      --salvo lo stato attuale Ante Update
      SELECT cod_stato
        INTO v_stato_pre
        FROM t_mcre0_app_all_data --v5.0 mople
       WHERE cod_abi_cartolarizzato = p_abi_cart
         AND cod_ndg = p_ndg;
    EXCEPTION
      WHEN no_data_found THEN
        v_stato_pre := NULL;
    END;
    pkg_mcre0_audit.log_app(seq,
                            c_package || '.classifica_GB ',
                            3,
                            SQLCODE,
                            'start',
                            'abi: ' || p_abi_cart || ' ndg: ' || p_ndg ||
                            ' stato: ' || p_stato || '(precedente: ' ||
                            v_stato_pre || ') scadenza:' || p_data_scadenza,
                            p_utente);

    --mantengo check stati uscita
    SELECT CASE
             WHEN nvl(tip_stato, 'x') = 'U' THEN
              '1'
             ELSE
              '0'
           END,
           cod_macrostato
      INTO flg_uscita, v_macrostato
      FROM t_mcre0_app_stati
     WHERE cod_microstato = p_stato;

    --storicizzo solo se ero in mople ante PT
    IF nvl(v_stato_pre, p_stato) != p_stato
    THEN
      --storicizzo tutte le banche dell'SNDG - no commit
      esito_storico := pkg_mcre0_storicizza.insert_storico_sndg(p_abi_cart,
                                                                p_ndg,
                                                                v_sndg,
                                                                '0',
                                                                '0',
                                                                '1',
                                                                '0');
    ELSE
      esito_storico := ok;
    END IF;

    IF esito_storico = ok
    THEN

      esito := inserisci_posizione(p_abi_cart,
                                   p_ndg,
                                   p_stato,
                                   p_processo,
                                   NULL,
                                   p_utente);

      --mantengo update per gestione Sofferenze..
      UPDATE mcre_own.t_mcre0_app_all_data m --v5.0 mople
         SET m.dta_scadenza_stato = CASE
                                      WHEN (flg_uscita = '1') THEN
                                       to_date('31/12/9999', 'dd/mm/yyyy')
                                      ELSE
                                       p_data_scadenza
                                    END,
             m.id_stato_posizione = CASE
                                      WHEN (flg_uscita = '1') THEN
                                       'S'
                                      ELSE
                                       'A'
                                    END,
             --v3.3 se stato uscita, aggiorno anche dtata e macrostato
             m.dta_dec_macrostato = CASE
                                      WHEN (flg_uscita = '1') THEN
                                       SYSDATE
                                      ELSE
                                       m.dta_dec_macrostato
                                    END,
             m.cod_macrostato = CASE
                                  WHEN (flg_uscita = '1') THEN
                                   v_macrostato
                                  ELSE
                                   m.cod_macrostato
                                END,
             m.cod_operatore_ins_upd = p_utente, --v5.0
             m.today_flg             = '1' --5.0
       WHERE m.cod_abi_cartolarizzato = p_abi_cart
         AND m.cod_ndg = p_ndg;
      num := SQL%ROWCOUNT;

      IF esito = ok
      THEN
        --rimuovo la chiave da pk_today se non esiste autonomamente in mople, altrimenti cambio flag
        UPDATE t_mcre0_app_all_data
           SET flg_source   = 0,
               flg_stato_gb = 2 --classificato
        --DTA_STATO_GB = sysdate --mantengo allineate le due tabelle...
         WHERE cod_abi_cartolarizzato = p_abi_cart
           AND cod_ndg = p_ndg;
        num := SQL%ROWCOUNT;

        pkg_mcre0_audit.log_app(c_package || '.classifica_GB ',
                                3,
                                SQLCODE,
                                'rimossa/aggiornata ' || num ||
                                ' chiave di pk_today',
                                'abi: ' || p_abi_cart || ' ndg: ' || p_ndg||' tipo_utente: '||p_tipo_utente,
                                p_utente);

        --aggiorno anche il flag sulla GB gestione
        UPDATE t_mcre0_app_gb_gestione
           SET flg_stato = 2, --classificato
               dta_stato = SYSDATE,
               flg_tipo_utente_inserente = p_tipo_utente --nuova gestione PT
         WHERE cod_abi_cartolarizzato = p_abi_cart
           AND cod_ndg = p_ndg;

        --8.9 aggiorno al gb-pt_gestione
        if (p_stato = 'PT') then
        delete t_mcre0_app_gb_pt_gestione g where  cod_abi_cartolarizzato = p_abi_cart and  cod_ndg = p_ndg;
        insert into t_mcre0_app_gb_pt_gestione
            (select COD_ABI_ISTITUTO, COD_ABI_CARTOLARIZZATO, COD_NDG, COD_SNDG, COD_FILIALE, COD_MACROSTATO_PROPOSTO,
                      DTA_INS, FLG_STATO, DESC_NOME_CONTROPARTE, DTA_STATO, COD_MATRICOLA, FLG_TIPO_UTENTE_INSERENTE,
                      COD_COMPARTO_INSERENTE, COD_TIP_CLI, COD_INDICATORE
                      from T_MCRE0_APP_GB_GESTIONE
               where  cod_abi_cartolarizzato = p_abi_cart
                 AND  cod_ndg = p_ndg);

        pkg_mcre0_audit.log_app(c_package || '.classifica_GB ', 3, SQLCODE,
                                'archivio richieste GB PT ',
                                'abi: ' || p_abi_cart || ' ndg: ' || p_ndg||' tipo_utente: '||p_tipo_utente,
                                p_utente);
        end if;

        pkg_mcre0_audit.log_app(seq,
                                c_package || '.classifica_GB ',
                                3,
                                SQLCODE,
                                'inserito e aggiornato ' || num ||
                                ' record',
                                '',
                                p_utente);
        RETURN num;
      ELSE
        pkg_mcre0_audit.log_app(seq,
                                c_package ||
                                '.classifica_GB -errore inserisci posizione',
                                1,
                                SQLCODE,
                                '',
                                'abi: ' || p_abi_cart || ' ndg: ' || p_ndg,
                                p_utente);
        --ROLLBACK;
        RETURN ko;
      END IF;
    ELSE
      pkg_mcre0_audit.log_app(seq,
                              c_package ||
                              '.classifica_GB -errore storicizza',
                              1,
                              SQLCODE,
                              '',
                              'abi: ' || p_abi_cart || ' ndg: ' || p_ndg,
                              p_utente);
      --ROLLBACK;
      RETURN ko;
    END IF;

  EXCEPTION
    WHEN OTHERS THEN
      pkg_mcre0_audit.log_app(seq,
                              c_package || '.classifica_GB ',
                              1,
                              SQLCODE,
                              SQLERRM,
                              'abi: ' || p_abi_cart || ' ndg: ' || p_ndg,
                              p_utente);
      RETURN ko;

  END;

  --rifiuta classificazione GB - aggiorna solo il flag su Gb_gestione v3.9-rinominata, + flg default - commit
  FUNCTION rifiuta_gb(p_abi_cart IN VARCHAR2,
                      p_ndg      IN VARCHAR2,
                      p_utente   IN VARCHAR2,
                      p_motivo   IN VARCHAR DEFAULT NULL) RETURN NUMBER IS

    num   NUMBER;
    v_flg NUMBER;

  BEGIN

    IF p_motivo IS NULL
    THEN
      v_flg := -1; --Allineamento rifiutato dall'Utente
    ELSE
      v_flg := -3; --Annullata dall'Utente
    END IF;

    --rimuovo la chiave da pk_today se non esiste autonomamente in mople, altrimenti cambio flag
    UPDATE t_mcre0_app_all_data
       SET flg_source   = 0,
           flg_stato_gb = v_flg -- rifiutato(-1)/annullato(-3) dall'utente
    --DTA_STATO_GB = sysdate --mantengo allineate le due tabelle...
     WHERE cod_abi_cartolarizzato = p_abi_cart
       AND cod_ndg = p_ndg;
    num := SQL%ROWCOUNT;
    pkg_mcre0_audit.log_app(c_package || '.rifiuta_GB ',
                            3,
                            SQLCODE,
                            'rimossa/aggiornata ' || num ||
                            ' chiave di pk_today',
                            'abi: ' || p_abi_cart || ' ndg: ' || p_ndg,
                            p_utente);

    --aggiorno lo stato su gb_gestione
    UPDATE t_mcre0_app_gb_gestione
       SET flg_stato           = v_flg, -- rifiutato(-1)/annullato(-3) dall'utente
           dta_stato           = SYSDATE,
           desc_motivo_annullo = p_motivo
     WHERE cod_abi_cartolarizzato = p_abi_cart
       AND cod_ndg = p_ndg;
    num := SQL%ROWCOUNT;
    COMMIT;

    pkg_mcre0_audit.log_app(c_package || '.rifiuta_GB ',
                            3,
                            SQLCODE,
                            'aggiornato stato (' || v_flg || ') a ' || num ||
                            ' record',
                            'abi: ' || p_abi_cart || ' ndg: ' || p_ndg ||
                            ' motivo: ' || p_motivo,
                            p_utente);
    RETURN num;

  EXCEPTION
    WHEN OTHERS THEN
      pkg_mcre0_audit.log_app(c_package || '.rifiuta_GB ',
                              1,
                              SQLCODE,
                              SQLERRM,
                              'abi: ' || p_abi_cart || ' ndg: ' || p_ndg,
                              p_utente);
      ROLLBACK;
      RETURN ko;

  END;

  --annulla richiesta GB - commit
  FUNCTION annulla_gb(p_abi_cart IN VARCHAR2,
                      p_ndg      IN VARCHAR2,
                      p_utente   IN VARCHAR2,
                      p_motivo   IN VARCHAR) RETURN NUMBER IS

    esito NUMBER := 0;
    v_flg NUMBER := -3; --annullato dall'utente
    seq   NUMBER;

  BEGIN

    SELECT seq_mcr0_log_app.nextval INTO seq FROM dual;

    --annullo il flag e rimuovo dalle viste (e aggiorno il motivo annullo)
    esito := rifiuta_gb(p_abi_cart, p_ndg, p_utente, p_motivo);

    --esito := MCRE_OWN.PKG_MCRE0_AGGIORNA_MV.REFRESH_FAST_SNP;

    esito := esito + pkg_mcre0_alert.fnc_verifica_alert_ndg(p_abi_cart,
                                                            p_ndg,
                                                            NULL,
                                                            NULL);
    pkg_mcre0_audit.log_app(seq,
                            c_package || '.annulla_GB',
                            3,
                            SQLCODE,
                            'ricalcolati gli alert',
                            'Esito: ' || esito,
                            p_utente);
    COMMIT;
    RETURN ok;

  EXCEPTION
    WHEN OTHERS THEN
      pkg_mcre0_audit.log_app(c_package || '.annulla_GB ',
                              1,
                              SQLCODE,
                              SQLERRM,
                              'abi: ' || p_abi_cart || ' ndg: ' || p_ndg,
                              p_utente);
      ROLLBACK;
      RETURN ko;

  END;

  --inserisce nuova posizione per richiesta AV - NO commit
  FUNCTION inserisci_av(p_abi_cart VARCHAR2,
                        p_ndg      VARCHAR2,
                        p_comparto VARCHAR2,
                        p_utente   VARCHAR2) RETURN NUMBER IS

    esiste      NUMBER := 0;
    v_sndg      VARCHAR2(16);
    v_proc      t_mcre0_cl_processi.tip_processo%TYPE;
    v_fl_stato  t_mcre0_app_stati.flg_stato_chk%TYPE;
    v_cod_stato t_mcre0_app_stati.cod_microstato%TYPE;
    v_stato     t_mcre0_app_av_gestione.flg_stato%TYPE;
    v_comp      t_mcre0_app_all_data.cod_comparto_calcolato%TYPE;

  BEGIN

    BEGIN
      SELECT cod_sndg
        INTO v_sndg
        FROM v_mcre0_app_upd_fields_p1 --v5.0
       WHERE cod_abi_cartolarizzato = p_abi_cart
         AND cod_ndg = p_ndg
         AND cod_stato<>'SO';
--         AND cod_stato NOT IN ('SO', 'IN');
      --v4.1: escludo i PT dagli avocabili- 5.0 escludo anche IN,
      --v5.1: SOLO SO, v5.3 ritornano anche gli IN
    EXCEPTION
      WHEN no_data_found THEN
        RETURN pos_non_cp;
    END;

    SELECT COUNT(*)
      INTO esiste
      FROM t_mcre0_app_av_gestione
     WHERE cod_abi_cartolarizzato = p_abi_cart
       AND cod_ndg = p_ndg;

    IF esiste = 1
    THEN
      --posizione gi¿ presente!
      RETURN pos_av;
    ELSE

      --v5.3
      --controllo processo/stato
      SELECT p.tip_processo,
             s.flg_alert,
             s.cod_microstato,
             a.cod_comparto_calcolato
        INTO v_proc, v_fl_stato, v_cod_stato, v_comp
        FROM v_mcre0_app_upd_fields_p1 a,
             t_mcre0_app_stati         s,
             t_mcre0_cl_processi       p
       WHERE a.cod_stato = s.cod_microstato
         AND a.cod_abi_istituto = p.cod_abi(+)
         AND a.cod_processo = p.cod_processo(+)
         AND a.cod_abi_cartolarizzato = p_abi_cart
         AND a.cod_ndg = p_ndg;

      --v.5.5 filtro anche se solo comparto calcolato gi¿ di direzione
      IF (v_proc = 'DC' OR v_comp = '011901')
      THEN
        RETURN pos_dir; --processo gi¿ di direzione
      ELSIF v_fl_stato IS NULL OR
            v_cod_stato = 'PT'
      THEN
        RETURN pos_ario; --posizione ante Rio
        --        elsif v_cod_stato = 'IN' then
        --            return pos_non_cp; --?????????????????
      END IF;

      INSERT INTO t_mcre0_app_av_gestione
        (cod_abi_cartolarizzato,
         cod_ndg,
         cod_matricola,
         cod_comparto_av)
      VALUES
        (p_abi_cart,
         p_ndg,
         p_utente,
         p_comparto);
      RETURN ok; --posizione inseribile
    END IF;

    pkg_mcre0_audit.log_app(c_package || '.inserisci_av ',
                            3,
                            SQLCODE,
                            'Inserita posizione da Avocare',
                            'abi: ' || p_abi_cart || ' ndg: ' || p_ndg,
                            p_utente);

  EXCEPTION
    WHEN OTHERS THEN
      pkg_mcre0_audit.log_app(c_package || '.inserisci_av ',
                              1,
                              SQLCODE,
                              SQLERRM,
                              'abi: ' || p_abi_cart || ' ndg: ' || p_ndg,
                              p_utente);
      RETURN ko;

  END;

  --rimuovi posizione da richieste AV - NO commit
  FUNCTION rimuovi_av(p_abi_cart VARCHAR2,
                      p_ndg      VARCHAR2,
                      p_utente   VARCHAR2) RETURN NUMBER IS

  BEGIN

    DELETE t_mcre0_app_av_gestione
     WHERE cod_abi_cartolarizzato = p_abi_cart
       AND cod_ndg = p_ndg;

    pkg_mcre0_audit.log_app(c_package || '.rimuovi_av ',
                            3,
                            SQLCODE,
                            'rimosso abi: ' || p_abi_cart || ' ndg: ' ||
                            p_ndg,
                            'ok',
                            p_utente);
    RETURN ok;

  EXCEPTION
    WHEN OTHERS THEN
      pkg_mcre0_audit.log_app(c_package || '.rimuovi_av ',
                              1,
                              SQLCODE,
                              SQLERRM,
                              'abi: ' || p_abi_cart || ' ndg: ' || p_ndg,
                              p_utente);
      RETURN ko;
  END;

  --avvia richiesta di avocazione - NO commit
  FUNCTION avoca(p_abi_cart VARCHAR2, p_ndg VARCHAR2, p_utente VARCHAR2)
    RETURN NUMBER IS

    v_proc      t_mcre0_cl_processi.tip_processo%TYPE;
    v_fl_stato  t_mcre0_app_stati.flg_stato_chk%TYPE;
    v_cod_stato t_mcre0_app_stati.cod_microstato%TYPE;

    v_stato t_mcre0_app_av_gestione.flg_stato%TYPE;

    esito NUMBER;

  BEGIN

    --controllo processo/stato
    SELECT p.tip_processo, s.flg_alert, s.cod_microstato
      INTO v_proc, v_fl_stato, v_cod_stato
      FROM v_mcre0_app_av_gestione a,
           t_mcre0_app_stati       s,
           t_mcre0_cl_processi     p
     WHERE a.cod_stato = s.cod_microstato
       AND a.cod_abi_istituto = p.cod_abi(+)
       AND a.cod_processo = p.cod_processo(+)
       AND a.cod_abi_cartolarizzato = p_abi_cart
       AND a.cod_ndg = p_ndg;

    IF v_proc = 'DC'
    THEN
      v_stato := -1; --processo gi¿ di direzione
      esito   := pos_non_av;
    ELSIF v_fl_stato IS NULL OR
          v_cod_stato = 'PT'
    THEN
      v_stato := -2; --stato con cp
      esito   := pos_non_av;
    ELSIF v_cod_stato = 'IN'
    THEN
      v_stato := -3; --stato con cp
      esito   := pos_non_av;
    ELSE
      v_stato := 1; --avocabile
      esito   := ok;
    END IF;

    UPDATE t_mcre0_app_av_gestione
       SET flg_stato = v_stato,
           dta_stato = SYSDATE
     WHERE cod_abi_cartolarizzato = p_abi_cart
       AND cod_ndg = p_ndg;

    pkg_mcre0_audit.log_app(c_package || '.avoca ',
                            3,
                            SQLCODE,
                            'richiesto abi: ' || p_abi_cart || ' ndg: ' ||
                            p_ndg,
                            'Esito ' || esito,
                            p_utente);
    RETURN esito;

  EXCEPTION
    WHEN OTHERS THEN
      pkg_mcre0_audit.log_app(c_package || '.avoca ',
                              1,
                              SQLCODE,
                              SQLERRM,
                              'abi: ' || p_abi_cart || ' ndg: ' || p_ndg,
                              p_utente);
      RETURN ko;
  END;

  FUNCTION avocazione(p_abi_cart VARCHAR2,
                      p_ndg      VARCHAR2,
                      p_utente   VARCHAR2,
                      p_esito    NUMBER,
                      p_message  VARCHAR2 DEFAULT NULL) RETURN NUMBER IS

  v_livello     t_mcre0_app_comparti.cod_livello%type;
  v_gruppo   t_mcre0_app_all_data.cod_gruppo_super%type;

  cursor disassegna (v_cod_gruppo varchar2) is
   select cod_abi_cartolarizzato, cod_ndg, cod_sndg, decode(cod_comparto_assegnato, null, '0','1') FL_COMPARTO, decode(id_utente, -1, '0', '1') FL_GESTORE
   from t_mcre0_app_all_data a
   where today_flg = '1' and nvl(cod_gruppo_super_old, cod_gruppo_super) = v_cod_gruppo;

  v_rec disassegna%rowtype;
  RetVal number :=1;

  BEGIN
    --setto l'esito
    UPDATE t_mcre0_app_av_gestione
       SET flg_stato  = p_esito, --( 1 ok, -2 errore host)
           dta_stato  = SYSDATE,
           desc_esito = substr(p_message, 1, 256)
     WHERE cod_abi_cartolarizzato = p_abi_cart
       AND cod_ndg = p_ndg;

       --v9.4 verifico il livello della struttura avocante
      begin
        select cod_livello, nvl(cod_gruppo_super_old, cod_gruppo_super) gruppo
        into v_livello, v_gruppo
        from t_mcre0_app_all_data a , t_mcre0_app_av_gestione v, t_mcre0_app_comparti c
        where a.cod_abi_cartolarizzato = v.cod_abi_cartolarizzato
        and a.cod_ndg = v.cod_ndg
        and  c.cod_comparto = v.cod_comparto_av
        and a.cod_abi_cartolarizzato = p_abi_cart
        and a.cod_ndg =p_ndg;

      exception when others then
       v_livello := 'NP';
       v_gruppo :='NP';
       pkg_mcre0_audit.log_app(c_package || '.avocazione  -test livello', 2,  SQLCODE,  SQLERRM, 'errore riccerca livello/gruppo per abi: ' || p_abi_cart || ' ndg: ' || p_ndg,  p_utente);
      end;

if p_esito = 1 then
    if v_livello in ( 'DC', 'DV' ) then
   --v9.4 disassegno il gruppo della posizione avocata
       open disassegna(v_gruppo);
        loop
        fetch disassegna into v_rec;
        exit when disassegna%notfound;

            RetVal := MCRE_OWN.PKG_MCRE0_STORICIZZA.INSERT_STORICO_NDG ( v_rec.cod_abi_cartolarizzato, v_rec.cod_ndg, v_rec.FL_COMPARTO, v_rec.FL_GESTORE, '0', '0' );

            update t_mcre0_app_all_data a
            set cod_comparto_assegnato = null, id_utente_pre = decode(id_utente, -1, id_utente_pre, id_utente), id_utente = -1,
            dta_utente_assegnato = null, cod_servizio = null, dta_servizio = null
            where cod_abi_cartolarizzato =  v_rec.cod_abi_cartolarizzato
                and cod_ndg =  v_rec.cod_ndg;

             RetVal := RetVal * MCRE_OWN.PKG_MCRE0_ALERT.FNC_VERIFICA_ALERT_NDG ( v_rec.cod_abi_cartolarizzato, v_rec.cod_ndg , v_rec.COD_SNDG, null );

             pkg_mcre0_audit.log_app(c_package || '.avocazione ', 3,  SQLCODE,  'disassegna posizioni collegate verso '||v_livello,
                             'disassegnato abi: ' || v_rec.cod_abi_cartolarizzato || ' ndg: ' || v_rec.cod_ndg|| ' RetVal: '||RetVal,  p_utente);
        end loop;
       close disassegna;

    else
    --disassegno solo la posizione corrente
       select cod_abi_cartolarizzato, cod_ndg, cod_sndg, decode(cod_comparto_assegnato, null, '0','1') FL_COMPARTO, decode(id_utente, -1, '0', '1') FL_GESTORE
       into v_rec
       from t_mcre0_app_all_data a
       where cod_abi_cartolarizzato = p_abi_cart and cod_ndg = p_ndg ;

            RetVal := MCRE_OWN.PKG_MCRE0_STORICIZZA.INSERT_STORICO_NDG ( p_abi_cart, p_ndg , v_rec.FL_COMPARTO, v_rec.FL_GESTORE, '0', '0' );

            update t_mcre0_app_all_data a
            set cod_comparto_assegnato = null, id_utente_pre = decode(id_utente, -1, id_utente_pre, id_utente), id_utente = -1,
            dta_utente_assegnato = null, cod_servizio = null, dta_servizio = null
            where cod_abi_cartolarizzato = p_abi_cart
                and cod_ndg =  p_ndg;

             RetVal := RetVal * MCRE_OWN.PKG_MCRE0_ALERT.FNC_VERIFICA_ALERT_NDG ( v_rec.cod_abi_cartolarizzato, v_rec.cod_ndg , v_rec.COD_SNDG, null );

             pkg_mcre0_audit.log_app(c_package || '.avocazione ', 3,  SQLCODE,  'disassegna posizioni singole verso '||v_livello,
                             'disassegnato abi: ' || v_rec.cod_abi_cartolarizzato || ' ndg: ' || v_rec.cod_ndg|| ' RetVal: '||RetVal,  p_utente);


    end if;
 end if;
    pkg_mcre0_audit.log_app(c_package || '.avocazione ', 3,  SQLCODE,  'aggiornato abi: ' || p_abi_cart || ' ndg: ' || p_ndg, 'settato stato ' || p_esito || ' esito: ' ||
                            p_message,  p_utente);



    RETURN ok;

  EXCEPTION
    WHEN OTHERS THEN
      pkg_mcre0_audit.log_app(c_package || '.avocazione ',
                              1,
                              SQLCODE,
                              SQLERRM,
                              'abi: ' || p_abi_cart || ' ndg: ' || p_ndg ||
                              ' p_esito: ' || p_esito,
                              p_utente);
      RETURN ko;
  END;

  --------------------   VG - CIB/BDT - INIZIO --------------------
  FUNCTION email(p_cod_matricola t_mcre0_app_email.cod_matric%TYPE,
                 p_val_cognome   t_mcre0_app_email.val_cognome%TYPE,
                 p_val_nome      t_mcre0_app_email.val_nome%TYPE,
                 p_val_email     t_mcre0_app_email.val_email%TYPE,
                 p_val_telefono  t_mcre0_app_email.val_tel_uff%TYPE,
                 p_cod_istituto  t_mcre0_app_email.cod_socpspo%TYPE,
                 p_cod_uo        t_mcre0_app_email.cod_uo_pspo%TYPE,
                 p_val_sede      t_mcre0_app_email.cod_lopuops%TYPE, -- (fi FILIALE /sc SEDE CENTRALE)
                 p_utente        t_mcre0_app_email.cod_operatore_ins_upd%TYPE,
                 p_flg_delete    NUMBER) RETURN NUMBER IS

    v_exists NUMBER(1);

  BEGIN

    IF (p_flg_delete = 1)
    THEN
      DELETE FROM t_mcre0_app_email
       WHERE cod_matric = p_cod_matricola
         AND val_email = p_val_email
         AND flg_web = 1;
    ELSE
      SELECT COUNT(DISTINCT cod_matric)
        INTO v_exists
        FROM t_mcre0_app_email
       WHERE cod_matric = p_cod_matricola
         AND val_email = p_val_email
         AND flg_web = 1;

      IF (v_exists = 0)
      THEN
        INSERT INTO t_mcre0_app_email
          (id_dper,
           cod_matric,
           val_cognome,
           val_nome,
           val_email,
           val_tel_uff,
           cod_socpspo,
           cod_uo_pspo,
           cod_lopuops,
           flg_web,
           dta_ins,
           dta_upd,
           cod_operatore_ins_upd)
        VALUES
          (to_char(SYSDATE, 'YYYYMMDD'),
           p_cod_matricola,
           p_val_cognome,
           p_val_nome,
           p_val_email,
           p_val_telefono,
           p_cod_istituto,
           p_cod_uo,
           p_val_sede,
           1,
           SYSDATE,
           SYSDATE,
           p_utente);
      ELSE
        UPDATE t_mcre0_app_email
           SET cod_matric            = p_cod_matricola,
               val_cognome           = p_val_cognome,
               val_nome              = p_val_nome,
               val_email             = p_val_email,
               val_tel_uff           = p_val_telefono,
               cod_socpspo           = p_cod_istituto,
               cod_uo_pspo           = p_cod_uo,
               cod_lopuops           = p_val_sede,
               dta_upd               = SYSDATE,
               cod_operatore_ins_upd = p_utente
         WHERE cod_matric = p_cod_matricola
           AND val_email = p_val_email
           AND flg_web = 1;
      END IF;
    END IF;
    COMMIT;

    RETURN ok;

  EXCEPTION
    WHEN OTHERS THEN
      pkg_mcre0_audit.log_app(c_package || '.email ',
                              1,
                              SQLCODE,
                              SQLERRM,
                              'Esiste:' || v_exists || ' - COD_MATRICOLA: ' ||
                              p_cod_matricola || '  - Nome: ' || p_val_nome ||
                              '  - Email: ' || p_val_email || '  - Tel: ' ||
                              p_val_telefono || ' - Sede: ' || p_val_sede,
                              p_utente);
      RETURN ko;
  END;

  FUNCTION mailinglist(p_val_nome_gruppo t_mcre0_app_email_gruppi.val_nome_gruppo%TYPE,
                       p_cod_matricola   t_mcre0_app_email_gruppi.cod_matricola%TYPE,
                       p_utente          t_mcre0_app_email_gruppi.cod_operatore_ins_upd%TYPE,
                       p_flg_delete      NUMBER) RETURN NUMBER IS

    v_exists NUMBER(1);

  BEGIN

    IF (p_flg_delete = 1)
    THEN
      DELETE FROM t_mcre0_app_email_gruppi
       WHERE val_nome_gruppo = p_val_nome_gruppo
         AND cod_matricola = p_cod_matricola;
    ELSE
      SELECT COUNT(DISTINCT 1)
        INTO v_exists
        FROM t_mcre0_app_email_gruppi
       WHERE val_nome_gruppo = p_val_nome_gruppo
         AND cod_matricola = p_cod_matricola;

      IF (v_exists = 0)
      THEN
        INSERT INTO t_mcre0_app_email_gruppi
          (val_nome_gruppo,
           cod_matricola,
           dta_ins,
           dta_upd,
           cod_operatore_ins_upd)
        VALUES
          (p_val_nome_gruppo,
           p_cod_matricola,
           SYSDATE,
           SYSDATE,
           p_utente);
      END IF;

    END IF;
    COMMIT;

   -- RETURN ok;

  EXCEPTION
    WHEN OTHERS THEN
      pkg_mcre0_audit.log_app(c_package || '.mailinglist ',
                              1,
                              SQLCODE,
                              SQLERRM,
                              'Esiste:' || v_exists || ' - COD_MATRICOLA: ' ||
                              p_cod_matricola || '  - Nome: ' ||
                              p_val_nome_gruppo,
                              p_utente);
      RETURN ko;
  END;

  FUNCTION pt_comunicazioni(p_cod_abi_cartolarizzato  t_mcre0_app_pt_comunicazioni.cod_abi_cartolarizzato%TYPE,
                            p_cod_ndg                 t_mcre0_app_pt_comunicazioni.cod_ndg%TYPE,
                            p_cod_sndg                t_mcre0_app_pt_comunicazioni.cod_sndg%TYPE,
                            p_cod_matricola_gestore   t_mcre0_app_pt_comunicazioni.cod_matricola_gestore%TYPE,
                            p_cod_tipo_comunicazione  t_mcre0_app_pt_comunicazioni.cod_tipo_comunicazione%TYPE,
                            p_dta_invio_comunicazione t_mcre0_app_pt_comunicazioni.dta_invio_comunicazione%TYPE,
                            p_utente                  VARCHAR2) RETURN NUMBER IS

    v_note VARCHAR2(2000);

  BEGIN

    v_note := 'Insert comunicazione - ' || p_cod_abi_cartolarizzato ||
              ' - ' || p_cod_ndg || ' - ' || p_cod_matricola_gestore ||
              ' - ' || p_cod_tipo_comunicazione || ' - ' ||
              p_dta_invio_comunicazione;
    INSERT INTO t_mcre0_app_pt_comunicazioni
      (cod_abi_cartolarizzato,
       cod_ndg,
       cod_sndg,
       cod_matricola_gestore,
       cod_tipo_comunicazione,
       dta_invio_comunicazione,
       dta_ins)
    VALUES
      (p_cod_abi_cartolarizzato,
       p_cod_ndg,
       p_cod_sndg,
       p_cod_matricola_gestore,
       p_cod_tipo_comunicazione,
       p_dta_invio_comunicazione,
       SYSDATE);
    --COMMIT;

    RETURN ok;

  EXCEPTION
    WHEN OTHERS THEN
      pkg_mcre0_audit.log_app(c_package || '.pt_comunicazioni ',
                              1,
                              SQLCODE,
                              SQLERRM,
                              v_note,
                              p_utente);
      RETURN ko;
  END;
  --------------------   VG - CIB/BDT - FINE --------------------

  FUNCTION pdf_rio(p_abi             VARCHAR2,
                   p_ndg             VARCHAR2,
                   p_utente          VARCHAR2,
                   p_tipo_operazione VARCHAR2) RETURN NUMBER IS
    v_note VARCHAR2(2000);
    ---------------------------------
    v_id_anomalia VARCHAR2(4000);
    v_id_advisor  VARCHAR2(4000);
    v_id_azione   VARCHAR2(4000);

    v_val_motivo_richiesta CLOB;
    v_val_motivo_esito     VARCHAR2(4000);

    v_sndg VARCHAR2(16);
    v_cod_gruppo_economico t_mcre0_app_all_data.cod_gruppo_economico%TYPE:='NO_GE';
    ---------------------------------
  BEGIN
    v_note := 'GET GE - cod_abi: ' || p_abi || ' - cod_ndg: ' ||p_ndg;

     BEGIN
        SELECT DISTINCT a.cod_gruppo_economico
          INTO v_cod_gruppo_economico
          FROM t_mcre0_app_all_data a --v5.0
         WHERE flg_active = 1
            and a.cod_abi_cartolarizzato = p_abi
           AND a.cod_ndg = p_ndg;
      EXCEPTION
        WHEN no_data_found THEN
          NULL;
      END;

    v_note := 'GET anomalie - cod_abi: ' || p_abi || ' - cod_ndg: ' ||p_ndg;
    SELECT rtrim(xmlagg(xmlelement("x", id_anomalia || ','))
                 .extract('//text()'),
                 ',') id_anomalia
      INTO v_id_anomalia
      FROM v_mcre0_app_rio_anomalie an, v_mcre0_app_upd_fields_p1 u
     WHERE an.cod_abi_cartolarizzato = u.cod_abi_cartolarizzato
     AND an.cod_ndg = u.cod_ndg
     --AD: se il GE restituito dalla ALL_DATA all'inizio Ú pari a -1, non contribuisce all'estrazione, perciò Ú stata messa una decode che vanifica l'uguaglianza in caso di GE -1
     AND (DECODE(an.cod_gruppo_economico,'-1','-2')  = v_cod_gruppo_economico      --u.cod_gruppo_economico = v_cod_gruppo_economico     AD: inserita decode l'8 gennaio 2013per evitare chee estragga tutte le posizioni con GE = -1 e valore preso dalle anomalie
            OR ( u.cod_abi_cartolarizzato = p_abi AND u.cod_ndg = p_ndg)
            )
     --AND u.cod_macrostato = 'RIO'
     and ( (an.flg_singolo_cliente = 'S'
                and an.cod_abi_cartolarizzato = p_abi
                AND an.cod_ndg = p_ndg)
            or
            an.flg_singolo_cliente = 'G' );

    v_note := 'GET advisor - cod_abi: ' || p_abi || ' - cod_ndg: ' ||p_ndg;
    SELECT rtrim(xmlagg(xmlelement("x", id_advisor || ','))
                 .extract('//text()'),
                 ',') id_advisor
      INTO v_id_advisor
      FROM v_mcre0_app_rio_advisor an
     WHERE cod_abi_cartolarizzato = p_abi
       AND cod_ndg = p_ndg;

    v_note := 'GET azioni - cod_abi: ' || p_abi || ' - cod_ndg: ' ||p_ndg;
    SELECT rtrim(xmlagg(xmlelement("x", id_azione || ','))
                 .extract('//text()'),
                 ',') id_azione
      INTO V_ID_AZIONE
      FROM V_MCRE0_APP_GEST_PRATICA_FASI A, --V_MCRE0_APP_RIO_AZIONI A,
           v_mcre0_app_upd_fields_p1 u
     WHERE a.cod_abi_cartolarizzato = u.cod_abi_cartolarizzato
     AND a.cod_ndg = u.cod_ndg
     --AD: se il GE restituito dalla ALL_DATA all'inizio Ú pari a -1, non contribuisce all'estrazione, perciò Ú stato messo un nvl che vanifica l'uguaglianza in caso di GE -1
     AND (nvl (a.cod_gruppo_economico,'-2') = v_cod_gruppo_economico --u.cod_gruppo_economico = v_cod_gruppo_economico   AD: sostituito u.cod_gruppo_economico  con a.cod_gruppo_economico
            OR ( u.cod_abi_cartolarizzato = p_abi AND u.cod_ndg = p_ndg)
            );
     --AND u.cod_macrostato = 'RIO';

    v_note := 'GET sndg - cod_abi: ' || p_abi || ' - cod_ndg: ' ||p_ndg;
    SELECT cod_sndg
      INTO v_sndg
      FROM v_mcre0_app_scheda_anag a
     WHERE a.cod_ndg = p_ndg
       AND a.cod_abi_cartolarizzato = p_abi;

     v_note := 'Insert pdf_rio - cod_abi: ' || p_abi || ' - cod_ndg: ' ||p_ndg;
    INSERT INTO t_mcre0_app_rio_pdf
      (id_rio_pdf,
       dta_ins,
       cod_abi_cartolarizzato,
       cod_ndg,
       cod_sndg,
       cod_struttura_competente_ar,
       cod_struttura_competente_fi,
       scsb_acc_cassa_bt_at,
       scsb_uti_cassa_bt_at,
       scsb_acc_smobilizzo_at,
       scsb_uti_smobilizzo_at,
       scsb_acc_cassa_mlt_at,
       scsb_uti_cassa_mlt_at,
       scsb_acc_firma_at,
       scsb_uti_firma_at,
       scsb_acc_tot_at,
       scsb_uti_tot_at,
       scsb_tot_gar_at,
       scsb_acc_sostituzioni_at,
       scsb_uti_sostituzioni_at,
       scsb_acc_massimali_at,
       scsb_uti_massimali_at,
       dta_pcr_at,
       dta_cr_at,
       val_mese_1,
       val_lr_mese_1,
       val_mese_2,
       val_lr_mese_2,
       val_mese_3,
       val_lr_mese_3,
       val_mese_4,
       val_lr_mese_4,
       val_mese_5,
       val_lr_mese_5,
       val_mese_6,
       val_lr_mese_6,
       val_mese_7,
       val_lr_mese_7,
       dta_rif_iris,
       rating_online,
       dta_scad_revisione_pef,
       gesb_acc_tot_at,
       gesb_uti_tot_at,
       gegb_uti_tot_at,
       gegb_acc_tot_at,
       id_anomalia,
       id_azione,
       val_utente,
       cod_macrostato_destinazione,
       note_classificazione,
       flg_lettura_verbale,
       cod_sequence_proroga,
       val_motivo_esito,
       val_motivo_richiesta,
       scgb_qis_uti,
       scgb_qis_acc,
       scgb_dta_rif_cr,
       cod_gruppo_economico,
       val_ana_gre,
       cod_stato,
       cod_macrostato,
       id_advisor)
      SELECT seq_mcre0_pdf_rio.nextval,
             SYSDATE,
             a.cod_abi_cartolarizzato,
             a.cod_ndg,
             a.cod_sndg,
             a.cod_struttura_competente_ar,
             a.cod_struttura_competente_fi,
             e.scsb_acc_cassa_bt_at,
             e.scsb_uti_cassa_bt_at,
             e.scsb_acc_smobilizzo_at,
             e.scsb_uti_smobilizzo_at,
             e.scsb_acc_cassa_mlt_at,
             e.scsb_uti_cassa_mlt_at,
             e.scsb_acc_firma_at,
             e.scsb_uti_firma_at,
             e.scsb_acc_tot_at,
             e.scsb_uti_tot_at,
             scsb_tot_gar_at,
             e.scsb_acc_sostituzioni_at,
             e.scsb_uti_sostituzioni_at,
             e.scsb_acc_massimali_at,
             e.scsb_uti_massimali_at,
             e.dta_pcr_at,
             e.dta_cr_at,
             o.mese1,
             i.mese1,
             o.mese2,
             i.mese2,
             o.mese3,
             i.mese3,
             o.mese4,
             i.mese4,
             o.mese5,
             i.mese5,
             o.mese6,
             i.mese6,
             o.mese7,
             i.mese7,
             MAX(ir.dta_riferimento) over(PARTITION BY ir.cod_sndg) dta_rif_iris,
--           m.val_rating_pc rating_online,
             f.val_rating_online,
             a.dta_scad_revisione_pef,
             gesb_acc_tot_at,
             gesb_uti_tot_at,
             gegb_uti_tot_at,
             gegb_acc_tot_at,
             v_id_anomalia,
             v_id_azione,
             p_utente,
             decode(p_tipo_operazione, 'P','RIO', decode(clas.cod_macrostato_destinazione,
                    NULL,
                    'RIO',
                    clas.cod_macrostato_destinazione)),
             clas.note_classificazione,
             clas.flg_lettura_verbale,
             pr.cod_sequence,
             pr.val_motivo_esito,
             pr.val_motivo_richiesta,
             sb.scgb_qis_uti,
             sb.scgb_qis_acc,
             sb.scgb_dta_rif_cr,
             a.cod_gruppo_economico,
             a.val_ana_gre,
             a.cod_stato,
             --f.COD_MACROSTATO, 20120925 Galliano
             decode(p_tipo_operazione,
                    'I',
                    'GB',
                    'P',
                    f.cod_macrostato,
                    'U',
                    'RIO',
                    f.cod_macrostato),
             v_id_advisor
        FROM v_mcre0_app_rio_monitoraggio m,
             v_mcre0_app_rio_esp_sc e,
             v_mcre0_app_rio_esp_ge g,
             v_mcre0_scheda_iris i,
             v_mcre0_scheda_iris o,
             v_mcre0_app_scheda_anag a,
             t_mcre0_app_iris ir,
             t_mcre0_app_rio_gestione clas,
             t_mcre0_app_all_data f,
             (select * from (
                SELECT p.*, max(cod_sequence) over (partition by cod_abi_cartolarizzato, cod_ndg) max_sq
                FROM t_mcre0_app_rio_proroghe p
                WHERE flg_storico = 0)
              where cod_sequence = max_sq) pr,--ultima proroga in lavorazione o già esitata
             t_mcre0_app_cr sb
       WHERE a.cod_abi_cartolarizzato = e.cod_abi_cartolarizzato(+)
         AND a.cod_ndg = e.cod_ndg(+)
         AND a.cod_abi_cartolarizzato = m.cod_abi_cartolarizzato(+)
         AND a.cod_ndg = m.cod_ndg(+)
         AND a.cod_abi_cartolarizzato = g.cod_abi_cartolarizzato(+)
         AND a.cod_ndg = g.cod_ndg(+)
         AND a.cod_ndg = p_ndg
         AND a.cod_abi_cartolarizzato = p_abi
         AND a.cod_sndg = v_sndg
         AND a.cod_sndg = i.cod_sndg(+)
         AND a.cod_sndg = ir.cod_sndg(+)
         AND a.cod_sndg = o.cod_sndg(+)
         AND a.cod_abi_cartolarizzato = clas.cod_abi_cartolarizzato(+)
         AND a.cod_ndg = clas.cod_ndg(+)
         AND a.cod_abi_cartolarizzato = pr.cod_abi_cartolarizzato(+)
         AND a.cod_ndg = pr.cod_ndg(+)
         AND a.cod_abi_cartolarizzato = sb.cod_abi_cartolarizzato(+)
         AND a.cod_ndg = sb.cod_ndg(+)
         AND a.cod_abi_cartolarizzato = f.cod_abi_cartolarizzato
         AND a.cod_ndg = f.cod_ndg
         AND f.flg_active = 1
         AND i.ordine(+) = 1
         AND o.ordine(+) = 0;

    RETURN ok;

  EXCEPTION
    WHEN OTHERS THEN
      pkg_mcre0_audit.log_app(c_package || '.pdf_rio ',
                              1,
                              SQLCODE,
                              SQLERRM,
                              v_note,
                              p_utente);
      RETURN ko;
  END pdf_rio;

  FUNCTION upd_pdf_rio(p_abi       VARCHAR2,
                       p_ndg       VARCHAR2,
                       p_utente    VARCHAR2,
                       p_id_object VARCHAR2) RETURN NUMBER IS
    v_note VARCHAR2(2000);

  BEGIN

    v_note := 'UPDATE ID_OBJECT =' || p_id_object ||
              'PER  T_MCRE0_APP_RIO_PDF';

    UPDATE t_mcre0_app_rio_pdf
       SET id_object  = p_id_object,
           val_utente = p_utente,
           dta_upd    = SYSDATE
     WHERE cod_abi_cartolarizzato = p_abi
       AND cod_ndg = p_ndg
       and flg_delete = 0;

    RETURN ok;
  EXCEPTION
    WHEN OTHERS THEN
      pkg_mcre0_audit.log_app(c_package || '.pdf_rio ',
                              1,
                              SQLCODE,
                              SQLERRM,
                              v_note,
                              p_utente);
      RETURN ko;
  END upd_pdf_rio;

END pkg_mcre0_funzioni_portale;
/


CREATE SYNONYM MCRE_APP.PKG_MCRE0_FUNZIONI_PORTALE FOR MCRE_OWN.PKG_MCRE0_FUNZIONI_PORTALE;


CREATE SYNONYM MCRE_USR.PKG_MCRE0_FUNZIONI_PORTALE FOR MCRE_OWN.PKG_MCRE0_FUNZIONI_PORTALE;


GRANT EXECUTE, DEBUG ON MCRE_OWN.PKG_MCRE0_FUNZIONI_PORTALE TO MCRE_USR;

