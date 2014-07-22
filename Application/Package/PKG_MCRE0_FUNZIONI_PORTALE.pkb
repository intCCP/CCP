CREATE OR REPLACE PACKAGE          pkg_mcre0_funzioni_portale AS
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
    2.1        23/02/2011       L.Ferretti  nuova versione di inserisci_posizione
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
    5.5.       20/10/2011          M.Murro  AV: filtro anche se comparto di direnzione
    5.6        22/11/2011          M.Murro  conferma: fix tab assegnazioni Incaglio
    5.7        27/12/2011          M.Murro  check abi elaborato da MV
    6.0        12/04/2012          M.Murro  variato conferma assegna_pos per aprire a Divisioni
    6.1        27/04/2012          M.Murro  gestione RS su cambio stato
    7.0        22/05/2012         V.Galli   Commenti con label:   VG - CIB/BDT - INIZIO
    8.0        10/07/2012        E.Pellizzi  Add function pdf_rio
    8.1        11/09/2012        E.Pellizzi  Add function upd_pdf_rio
    8.2        19/09/2012        V.Galli Modificata assegna posizioni
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
    9.4        24/09/2013        M.Murro      gestione 'disassegna' in Avocazione
    9.5        07/05/2014        M.Ceru       aggiunti parametri in input a assegna_posizione_blk per la variazione perimetro DR
    9.6        08/05/2014        M.Ceru       modificato filtro da = a like per DESC_NOME_CONTROPARTE e VAL_ANA_GRE
 ******************************************************************************/
  c_package CONSTANT VARCHAR2(50) := 'PKG_MCRE0_FUNZIONI_PORTALE';
  c_mese    CONSTANT VARCHAR2(1) := 'M';
  c_gestore CONSTANT VARCHAR2(1) := 'G';
  c_stato   CONSTANT VARCHAR2(1) := 'S';
  ok NUMBER := 1;
  ko NUMBER := -1;
  --esito conterr¿ normalmente il numero di righe aggiornato
  abi_non_elaborato NUMBER := -2; --aggiornamento dati inibito
  --avocazione
  pos_non_cp NUMBER := -2;
  --posizione non in Mople: non avocabile
  pos_av     NUMBER := -3; --posizione gi¿ in elenco AV
  pos_ario   NUMBER := -4; --pos in stato Ante RIO
  pos_dir    NUMBER := -5; --pos con processo di Direzione
  pos_non_av NUMBER := -2; --posizione non avocabile

  --funzione da chiamare da portale, dopo aver effettuato l'update su HOST
  --chiamata al refresh delle MV da effettuare esternamente
  --NO COMMIT
  --v3.2 aggiunto p_utente (default null)
  FUNCTION aggiorna_stato(p_abi_cart      IN VARCHAR2,
                          p_ndg           IN VARCHAR2,
                          p_sndg          IN VARCHAR2 DEFAULT NULL,
                          p_stato         VARCHAR2,
                          p_data_scadenza DATE,
                          p_utente        VARCHAR2 DEFAULT NULL)
    RETURN NUMBER;

  --funzione per rimuovere le prenotazioni di un assegnatore - COMMIT-v3.8
  FUNCTION rimuovi_prenotazioni(p_utente  VARCHAR2,
                                p_sezione NUMBER DEFAULT 0,
                                p_seq     NUMBER DEFAULT NULL,
                                --------------------   VG - CIB/BDT - INIZIO --------------------
                                p_seq_blocco NUMBER DEFAULT 0,
                                p_flg_esito_conferme NUMBER DEFAULT NULL
                                --------------------   VG - CIB/BDT - FINE --------------------
                                ) RETURN NUMBER;

  --conferma le prenotazioni effettuate da un utente - COMMITTA
  PROCEDURE conferma_assegna_posizione(p_utente          IN VARCHAR2,
                                       p_sezione         IN NUMBER,
                                       esito             OUT NUMBER,
                                       host_param        OUT host_tab,
                                       mopl_param        OUT mopl_tab,
                                       p_flg_ass_massiva IN NUMBER DEFAULT 0,
                                       --------------------   VG - CIB/BDT - INIZIO --------------------
                                       p_seq_blocco NUMBER
                                       --------------------   VG - CIB/BDT - FINE --------------------
                                       );

  --procedura per prenotare cambi comparto/gestore - COMMIT-v3.8
  PROCEDURE assegna_posizione(p_cod_sndg         IN VARCHAR2,
                              p_cod_abi          IN VARCHAR2, --abi cart? per usi futuri..
                              p_cod_ndg          IN VARCHAR2,
                              p_cod_gruppo_super IN VARCHAR2,
                              p_id_utente        IN NUMBER,
                              -- ID del gestore per assegna gestore (-1 = DISASSEGNA)
                              p_cod_comparto IN VARCHAR2,
                              -- CODICE comparto per assegna comparto
                              p_sezione IN INTEGER DEFAULT 0,
                              -- 1-assegna_posizione, 2-riassegna per cambio_stato, 3 riassegna
                              p_matr_assegnatore IN VARCHAR2,
                              p_rownum           OUT NUMBER);

  -- v3.3 procedura per prenotare cambi comparto/gestore bulk- commit! (solo Riassegna)
  PROCEDURE assegna_posizione_blk(p_gestore IN NUMBER,
                                  --gi¿ assegnato, da filtro
                                  p_macrostato   IN VARCHAR2, --da filtro
                                  p_cod_comparto IN VARCHAR2,
                                  --ccomparto gestore, per filtro
                                  p_id_utente IN NUMBER,
                                  -- ID del gestore per assegna gestore (-1 = DISASSEGNA)
                                  p_matr_assegnatore IN VARCHAR2,
                                  p_rownum           OUT NUMBER,
                                  --------------------   VG - CIB/BDT - INIZIO --------------------
                                  p_flg_girocomparto t_mcre0_app_comparti.flg_girocomparto%TYPE,
                                  p_sezione          IN INTEGER DEFAULT 0,
                                  -- 1-assegna_posizione, 2-riassegna per cambio_stato, 3 riassegna
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
                                  p_assegn_a DATE DEFAULT NULL
                                  );

  --aggiorna processo su singola posizione mople.. no commit
  --v3.2 aggiunto p_utente (default null)
  FUNCTION aggiorna_processo(p_abi_cart VARCHAR2,
                             p_ndg      VARCHAR2,
                             p_processo VARCHAR2,
                             p_utente   VARCHAR2 DEFAULT NULL) RETURN NUMBER;

  --inserisce nuova posizione su mople e file guida.. no commit
  --v3.2 aggiunto p_utente (default null)
  FUNCTION inserisci_posizione(p_abi_cart  VARCHAR2,
                               p_ndg       VARCHAR2,
                               p_stato     VARCHAR2,
                               p_processo  VARCHAR2,
                               p_tipo_elab VARCHAR2,
                               p_utente    VARCHAR2 DEFAULT NULL)
    RETURN NUMBER;

  --verifica se l'abi ¿ elaborato
  FUNCTION check_elaborazione_abi(p_abi_cart VARCHAR2) RETURN NUMBER;

  --v3.5 inserisce in mople tutti i GB se gi¿ collegati - commit  + refresh
  PROCEDURE inserisci_gb(p_utente IN VARCHAR2, p_rownum OUT NUMBER);

  --funzione da chiamare da portale, dopo aver effettuato l'update su HOST
  --chiamata al refresh delle MV da effettuare esternamente
  --NO COMMIT
  --v3.2 aggiunto p_utente (default null)
  FUNCTION classifica_gb(p_abi_cart      IN VARCHAR2,
                         p_ndg           IN VARCHAR2,
                         p_sndg          IN VARCHAR2,
                         p_stato         VARCHAR2,
                         p_processo      VARCHAR2,
                         p_data_scadenza DATE,
                         p_utente        VARCHAR2,
                         p_tipo_utente CHAR default null) RETURN NUMBER;

  --rifiuta classificazione GB - aggiorna solo il flag su Gb_gestione v3.9-rinominata, + flg default - commit
  FUNCTION rifiuta_gb(p_abi_cart IN VARCHAR2,
                      p_ndg      IN VARCHAR2,
                      p_utente   IN VARCHAR2,
                      p_motivo   IN VARCHAR DEFAULT NULL) RETURN NUMBER;

  --annulla richiesta GB
  FUNCTION annulla_gb(p_abi_cart IN VARCHAR2,
                      p_ndg      IN VARCHAR2,
                      p_utente   IN VARCHAR2,
                      p_motivo   IN VARCHAR) RETURN NUMBER;

  --inserisce nuova posizione per richiesta AV - NO commit
  FUNCTION inserisci_av(p_abi_cart VARCHAR2,
                        p_ndg      VARCHAR2,
                        p_comparto VARCHAR2,
                        p_utente   VARCHAR2) RETURN NUMBER;

  --rimuovi posizione da richieste AV - NO commit
  FUNCTION rimuovi_av(p_abi_cart VARCHAR2,
                      p_ndg      VARCHAR2,
                      p_utente   VARCHAR2) RETURN NUMBER;

  --avvia richiesta di avocazione - NO commit
  --function avoca (p_abi_cart varchar2, p_ndg varchar2, p_utente varchar2) return number;

  --Avocazione ok o fallita su Host - NO commit
  FUNCTION avocazione(p_abi_cart VARCHAR2,
                      p_ndg      VARCHAR2,
                      p_utente   VARCHAR2,
                      p_esito    NUMBER,
                      p_message  VARCHAR2 DEFAULT NULL) RETURN NUMBER;

  --------------------   VG - CIB/BDT - INIZIO --------------------
  FUNCTION email(p_cod_matricola t_mcre0_app_email.cod_matric%TYPE,
                 p_val_cognome   t_mcre0_app_email.val_cognome%TYPE,
                 p_val_nome      t_mcre0_app_email.val_nome%TYPE,
                 p_val_email     t_mcre0_app_email.val_email%TYPE,
                 p_val_telefono  t_mcre0_app_email.val_tel_uff%TYPE,
                 p_cod_istituto  t_mcre0_app_email.cod_socpspo%TYPE,
                 p_cod_uo        t_mcre0_app_email.cod_uo_pspo%TYPE,
                 p_val_sede      t_mcre0_app_email.cod_lopuops%TYPE,
                 -- (fi FILIALE /sc SEDE CENTRALE)
                 p_utente     t_mcre0_app_email.cod_operatore_ins_upd%TYPE,
                 p_flg_delete NUMBER) RETURN NUMBER;

  FUNCTION mailinglist(p_val_nome_gruppo t_mcre0_app_email_gruppi.val_nome_gruppo%TYPE,
                       p_cod_matricola   t_mcre0_app_email_gruppi.cod_matricola%TYPE,
                       p_utente          t_mcre0_app_email_gruppi.cod_operatore_ins_upd%TYPE,
                       p_flg_delete      NUMBER) RETURN NUMBER;

  PROCEDURE blocca_posizioni(p_utente             IN VARCHAR2,
                             p_sezione            IN NUMBER,
                             esito                OUT NUMBER,
                             p_seq_blocco         IN OUT NUMBER,
                             p_flg_esito_conferme NUMBER DEFAULT NULL);

  FUNCTION pt_comunicazioni(p_cod_abi_cartolarizzato  t_mcre0_app_pt_comunicazioni.cod_abi_cartolarizzato%TYPE,
                            p_cod_ndg                 t_mcre0_app_pt_comunicazioni.cod_ndg%TYPE,
                            p_cod_sndg                t_mcre0_app_pt_comunicazioni.cod_sndg%TYPE,
                            p_cod_matricola_gestore   t_mcre0_app_pt_comunicazioni.cod_matricola_gestore%TYPE,
                            p_cod_tipo_comunicazione  t_mcre0_app_pt_comunicazioni.cod_tipo_comunicazione%TYPE,
                            p_dta_invio_comunicazione t_mcre0_app_pt_comunicazioni.dta_invio_comunicazione%TYPE,
                            p_utente                  VARCHAR2) RETURN NUMBER;

  ------------------   VG - CIB/BDT - FINE --------------------
  FUNCTION pdf_rio(p_abi             VARCHAR2,
                   p_ndg             VARCHAR2,
                   p_utente          VARCHAR2,
                   p_tipo_operazione VARCHAR2) RETURN NUMBER;

  FUNCTION upd_pdf_rio(p_abi       VARCHAR2,
                       p_ndg       VARCHAR2,
                       p_utente    VARCHAR2,
                       p_id_object VARCHAR2) RETURN NUMBER;
END pkg_mcre0_funzioni_portale;

/
