CREATE OR REPLACE PACKAGE MCRE_OWN."PKG_MCREI_GEST_BATCH" AS
    /******************************************************************************
    NAME:         PKG_MCREI_GEST_BATCH
    PURPOSE: Gestione impianto ristrutturati, batch rapporti nuovi ed estinti
    I rapporti legati a chiusure di ristrutturazione (B8) non vengono gestiti dal batch notturno.
    1.         Nascita nuovo rapporti
    1.1.      Ristrutturazione totale: inserimento con flg_ristrutturato = `Y? e dta_inizio_segnalazione = sysdate e va in coda mora
    1.2.      Ristrutturazione parziale solo con NPE presente su hst_rapp_ristr e stime: inserimento con flg_ristrutturato e data inizio segnalazione ereditati dalla famiglia NPE e va in coda mora
    2.         Estinzione rapporto
    2.1.      Ristrutturazione totale: aggiornamento flg_ristrutturato = `N?, dta_fine_segnalazione, dta_estinzione = sysdate
    2.2.      Ristrutturazione parziale
    2.2.1.  Rapporto non estero: aggiornamento
    2.2.1.1.                  se flg_ristrutturato valeva Y e flg_ristrutturato = `N? e dta_fine_segnalazione, dta_estinzione = sysdate;
    2.2.1.2.                  se flg_ristrutturato = `N? e dta_estinzione = sysdate e va in coda mora solo 1 volta;
    2.2.2. Rapporto estero, dovrebbe avere lo stesso flg_ristrutturato e dta_inizio_segnalazione del gruppo    NPE,    non si tocca il flg_ristrutturato (perche deve essere ereditato e uguale per tutti i rapporti del gruppo?)
    2.2.3. Non si tocca dta_fine_segnalazione (?)
    2.2.4. dta_estinzione = sysdate
    Per quanto riguarda la tripla (flg_ristrutturato, dta_inizio_segnalazione, dta_fine_dsegnalazione) ci sono quattro comabinazioni possibili che interpretiamo in modo particolare:
    Y, NULL, NULL                            -> caso non possibile
    Y, NULL, NOT NULL             -> caso non possibile
    Y, NOT NULL, NOT NULL -> caso non possibile (se si estingue il flg va a N)
    Y, NOT NULL, NULL               -> vivo segnalato come ristrutturato
    N, NULL, NULL                            -> vivo segnalato come non ristrutturato
    N, NOT NULL, NOT NULL  -> era con flg_ristrutturato = Y e si e estinto
    N, NULL, NOT NULL               -> era con flg_ristrutturato = N e si e estinto
    N, NOT NULL, NULL             -> caso non possibile
    REVISIONS:
    Ver          Date          Author              Description
    ---------  ----------  ---------------  ------------------------------------
    1.0          26/07/2012  i.gueorguieva      created this package
    1.1          27/07/2012  i.gueorguieva      procedure creazione delibere e stime d'impianto e popolamento tabelle storiche
    1.2          30/07/2012  D'errico          prc_main, procedure popolamento coda per BS MORA
    1.3          14/08/2012  i.gueorguieva      parametrizzata dta_delibera e dta_inizio_segnalazione
    1.4          16/08/2012  i.gueorguieva      aggiunte funzioni di caricamento app
    1.5          23/08/2012  D'ERRICO          aggiunta t_mcrei_app_ristrutturazioni a popola_hst_ristr per recuperate info sul tipo di ristrutturazione (T o P)
    AGGIUNTA PULIZIA RECORD IN CASO DI RILANCIO ALL'INTERNO DELLA CREA_dELIB_IMPIANTO
    1.6          28/08/2012  D'ERRICO                  modificato calcolo flg_ristrutturato in prc_popola_hst_rapp_ristr
    1.7          24/09/2012  i.gueorguieva      Correzione gestione nuovi rapporti, solo ristrutturazione parziale gestita da batch
    1.8          28/09/2012  i.gueorguieva      Correzione popolamento code mora, gestione rapporti estero parziali
    1.9          02/09/2012  i.gueorguieva      Popolamento T_MCREI_HST_RAPP_RISTR.DTA_INIZIO_SEGNALAZIONE_RISTR CON (T_MCREI_APP_PCR_RAPPORTI.ID_DPER-2)
    2.0          16/10/2012  d'errico          inserita gestione cambio stato nella prc_main e aggiunta variabile di output
    2.1          19/10/2012  d'errico          inserito chiamata a funzione aggiorna_stato per gestire RS
    2.2          30/10/2012  d'errico          aggiunto popolamento utilizzo e accordato per rapporti
    2.3          31/10/2012  M.murro              aggiunta data scadenza su IR
    2.4          05/11/2012  Gueorguieva          Corretta gestione prc_popola_coda_rapporti per rapporto
    2.5          21/11/2012  Gueorguieva          Fix propagazione cod_npe e disabilitazione aggiornament flg_estinto su tabelle rapporti ristrutturati
    2.6          29/11/2012  Gueorguieva          Aggiunto calcolo alert Ristrutturazioni parziali con rapporti privi di attributo in coda a prc_main_gest_batch_ristr
    2.7          06/02/2013  Gueorguieva         Inibizione invio rapporti su posizioni con chiusura ristrutturazione inviata
    2.8          06/02/2013  Gueorguieva         Segnalazione rapporti estinti solo oltre il 3o giorno dal rilevamento estinzione per la prima volta
    2.9          06/02/2013  Gueorguieva         Per i rapporti esteri su ristrutturazioni parziali si recupera flg_ristrutturato e dta_inizio_segnalazione_ristr dagli altri rapporti con lo stesso NPE
    3.0          26/02/2013  Gueorguieva         Aggiunta decodifica Flg N184 in fnc_carica_posizioni
    3.1          04/03/2013  Gueorguieva         Cancellazione rapporti candidati all'estinzione dalla t_mcrei_hst_Rapp_ristr_cand_est nel caso riarrivino.
    3.2          04/03/2013  Gueorguieva         Cambiato calcolo posiozioni con max_ordinale pre chiamata gest_nuovi ed estinti, esclusione chiusure ristrutturazione
    3.3       04/03/2013  Gueorguieva         dta_inizio_segnalazione_ristr dei nuovi rapporti ¿ sysdate
    3.4       30/05/2013  M.Murro            fix salvataggio utilizzati e decode desc_tipo-ristr
    ******************************************************************************/

    c_package CONSTANT    VARCHAR2 (50) := 'PKG_MCREI_GEST_BATCH';
    ok CONSTANT             NUMBER := 1;
    ko CONSTANT             NUMBER := 0;

    -- %AUTHOR REPLY
    -- %VERSION 0.2
    -- %USAGE  Crea una delibera d'impianto di ristrutturazione
    -- %d Per la posizione individuata dalla coppia (ABI, NDG) viene creata una delibera
    -- %d di microtipologia IR. I campi della delibera vengono popolati a partire dai
    -- %d parametri in input e dalle Pratiche.
    -- %CD 13 AUG 2012
    -- %PARAM p_cod_abi    ABI
    -- %PARAM p_cod_ndg    NDG
    -- %PARAM p_dta_efficacia_ristr data efficacia ristrutturazione
    -- %PARAM p_dta_scadenza_ristr date scadenza ristrutturazione
    -- %PARAM p_desc_tipo_ristr  T: Totale; P: Parziale
    -- %PARAM p_desc_intento_ristr Y: Con intento liquidatorio; N: senza intento liquidatorio
    -- %PARAM p_cod_abi    ABI
    -- %PARAM p_cod_ndg NDG
    -- %PARAM p_protodel protocollo delibera a cui associare le stime generate
    -- %PARAM p_dta_inizio_sg data inizio segnalazione
    PROCEDURE prc_crea_delibera_impianto_ri (
        p_cod_abi                    IN      t_mcrei_app_delibere.cod_abi%TYPE,
        p_cod_ndg                    IN      t_mcrei_app_delibere.cod_ndg%TYPE,
        p_dta_efficacia_ristr    IN      DATE,
        p_dta_efficacia_add        IN      DATE,
        p_dta_scadenza_ristr     IN      DATE,
        p_desc_tipo_ristr         IN      t_mcrei_app_delibere.desc_tipo_ristr%TYPE,
        p_desc_intento_ristr     IN      t_mcrei_app_delibere.desc_intento_ristr%TYPE,
        p_dta_delibera             IN      DATE,
        p_proto                            OUT t_mcrei_app_delibere.cod_protocollo_delibera%TYPE,
        p_proto_pacch                    OUT t_mcrei_app_delibere.cod_protocollo_pacchetto%TYPE
    );

    -- %AUTHOR REPLY
    -- %VERSION 0.1
    -- %USAGE Crea una stima per ogni rapporto presente su PCR Rapporti per la posizione individuata dalla coppia (ABI, NDG)
    -- %d Se un rapporto S presente anche sulla tabella dei rapporti ristrutturati,
    -- %d T_MCREI_APP_RAPP_RIST, allora i campi della stima generata verranno popolati a partire
    -- %d dalla tabella dei rapporti ristrutturati.
    -- %d Altrimenti verranno popolati a partire da PCR Rapporti, con FLG_RISTRUTTURATO = N
    -- %d e DTA_INIZIO_SEGNALAZIONE_RISTR = DTA_EFFICACIA_RISTR.
    -- %CD 13 AUG 2012
    -- %param p_cod_abi    ABI
    -- %param p_cod_ndg    NDG
    -- %param p_protodel protocollo delibera a cui associare le stime generate
    -- %param p_dta_inizio_sg    data inizio segnalazione
    PROCEDURE prc_crea_stime_impianto (
        p_cod_abi            IN t_mcrei_app_delibere.cod_abi%TYPE,
        p_cod_ndg            IN t_mcrei_app_delibere.cod_ndg%TYPE,
        p_protodel            IN t_mcrei_app_delibere.cod_protocollo_delibera%TYPE,
        p_dta_inizio_sg    IN DATE
    );

    -- %USAGE FUNCTION CHE INDIVIDUA I RAPPORTI NUOVI SU UNA POSIZIONE
    -- %D SE LA POSIZIONE INDIVIDUA UNA RISTRUTTURAIONE PARZIALE LA
    -- %D GESTIONE COINCIDE CON QUELLA DELL'ALERT 'RISTRUTTURAZIONI PARZIALI
    -- %D CON RAPPORTI PRIVI DI ATTRIBUTO'
    -- %D SE LA RISTRUTTURAZINE E' TOTALE L'AGGIORNAMENTO DELLA RISTRUTTURAZIONE E'
    -- %D GESTITO IN AUTOMATICO
    -- %param p_cod_abi ABI
    -- %param p_cod_ndg NDG
    FUNCTION fnc_gest_nuovi_rapporti (
        p_cod_abi                          IN        T_MCREI_HST_RISTRUTTURAZIONI.cod_abi%TYPE,
        p_cod_ndg                          IN        T_MCREI_HST_RISTRUTTURAZIONI.cod_ndg%TYPE,
        p_tipo_ristr                      IN        t_mcrei_hst_ristrutturazioni.desc_tipo_ristr%TYPE,
        p_val_ordinale                   IN        t_mcrei_hst_ristrutturazioni.val_ordinale%TYPE,
        P_COD_PROTOCOLLO_DELIBERA      IN        T_MCREI_HST_RISTRUTTURAZIONI.COD_PROTOCOLLO_DELIBERA%TYPE,
        P_COD_MICROTIPOLOGIA_DELIB   IN        T_MCREI_HST_RISTRUTTURAZIONI.COD_MICROTIPOLOGIA_DELIB%TYPE,
        P_VARIAZIONE                          OUT NUMBER,
        P_DTA_DELIBERA                       OUT DATE
    )
        RETURN NUMBER;

    -- %AUTHOR REPLY
    -- %VERSION 0.1
    -- %USAGE Popola la tabella usata da Business service MORA T_MCREI_MORA_POS_RISTR
    -- %cd 14 AUG 2012
    -- %param p_codabi ABI
    -- %param p_codndg NDG
    -- %param p_ordinale numero ordinale da associare al blocco di rapporti
    -- %param p_dta_delibera data delibera
    PROCEDURE prc_popola_coda_posizioni (p_codabi      IN VARCHAR2,
                                                     p_codndg      IN VARCHAR2,
                                                     p_ordinale   IN NUMBER,
                                                     p_dta_del      IN DATE);

    -- %AUTHOR REPLY
    -- %VERSION 0.1
    -- %usage Popola la tabella dei rapporti T_MCREI_MORA_RAPP_RISTR usata da Business service MORA
    -- %d Lavora a livello di posizione individuando i rapporti assocciati
    -- %cd 14 AUG 2012
    -- %param p_codabi ABI
    -- %param p_codndg NDG
    -- %param p_ordinale numero ordinale da associare al blocco di rapporti
    PROCEDURE prc_popola_coda_rapporti (p_codabi      IN VARCHAR2,
                                                    p_codndg      IN VARCHAR2,
                                                    p_ordinale     IN NUMBER);

    -- %AUTHOR REPLY
    -- %VERSION 0.1
    -- %usage Popola la tabella dei rapporti T_MCREI_MORA_RAPP_RISTR usata da Business service MORA
    -- %d Lavora a livello del rapporto passato per argomento
    -- %cd 14 AUG 2012
    -- %param p_codabi ABI
    -- %param p_codndg NDG
    -- %param p_ordinale numero ordinale da associare al blocco di rapporti
    -- % param p_cod_rapporto codice rapporto
    PROCEDURE prc_popola_coda_rapporti (p_codabi           IN VARCHAR2,
                                                    p_codndg           IN VARCHAR2,
                                                    p_ordinale          IN NUMBER,
                                                    p_cod_rapporto   IN VARCHAR2);

    -- %author
    -- %version 0.1
    -- %usage Procedura per il lancio del processo di caricamento delle posizioni ristrutturate in fase di impianto
    -- %d La procedura richiama le funzioni di gestione dell'impianto dei ristrutturati. L'iter S il seguente:
    -- %d per ogni posizione da impiantare, caricata nella tabella t_mcrei_app_ristrutturazioni,
    -- %d e per tutti i rapporti ad essa collegati (presenti nella t_mcrei_app_rapp_ristr):
    -- %d
    -- %d   1) si crea la delibera di tipo IR
    -- %d   2) si crea il record nella hst_ristrutturazioni
    -- %d   3) si creano i record nella stime, corrispondenti ai rapporti associati presenti nella t_mcrei_app_rapp_ristr
    -- %d   4) si creano i record nella hst_rapp_ristr, corrispondenti ai rapporti associati presenti nella t_mcrei_app_rapp_ristr
    -- %d   5) si popola la coda delle posizioni che verr¿ elaborata dal job java con l'immagine corrispondente al max(ordinale) presente nella hst_ristrutturazioni,
    -- %d   6) si popola la coda dei rapporti che verr¿ elaborata dal job java con l'immagine corrispondente al max(ordinale) presente nella hst_ristrutturazioni,
    -- %cd 30 lug 2012
    -- %Md 16 OCT 2012
    PROCEDURE prc_main (v_posizioni_da_processare    OUT NUMBER,
                              v_posizioni_processate        OUT NUMBER,
                              V_NUM_RS_PREVISTI                OUT NUMBER,
                              V_NUM_RS_GESTITI                OUT NUMBER);

    -- %USAGE Popola la tabella dei rapporti delle posizioni ristrutturate T_MCREI_HST_RAPP_RISTR.
    -- %d Dopo l¿esecuzione, per ogni stima generata da prc_crea_stime_impianto,
    -- %d ci sar¿ un record sulla T_MCREI_HST_RAPP_RISTR. Ad una posizione con val_ordinale = n e
    -- %d cod_protocollo_delibera = d, su T_MCREI_HST_RISTRUTTURAZIONI, corrisponderanno k rapporti
    -- %d (dove k S la numerosit¿ dei rapporti su PCR per la posizione) con val_ordinale = n e
    -- %d cod_protocollo_delibera_padre = d su T_MCREI_HST_RAPP_RIST.
    -- %CD 13 AUG 2012
    -- %param p_cod_abi ABI
    -- %param p_cod_ndg      NDG
    -- %param p_protodel Protocollo delibera a cui associare le stime generate
    -- %param p_ordinale     Numero ordinale da associare al blocco di rapporti
    -- %param p_dta_inizio_sg        Data inizio segnalazione
    PROCEDURE prc_popola_hst_rapp_ristr (p_codabi             IN VARCHAR2,
                                                     p_codndg             IN VARCHAR2,
                                                     p_protodel          IN VARCHAR2,
                                                     p_ordinale          IN NUMBER,
                                                     p_dta_inizio_sg     IN DATE);

    --%USAGE funzione che gestisce i rapporti estinti delle posizioni con ristrutturazione
    --%d la gestione e' la stessa per le ristrutturazioni parziali (DEDSC_TIPO_RISTR = 'P')
    --%d    e quelle totali (DESC_TIPO_RISTR = 'T')
    FUNCTION fnc_gest_rapporti_estinti (
        p_cod_abi                          IN        T_MCREI_HST_RISTRUTTURAZIONI.cod_abi%TYPE,
        p_cod_ndg                          IN        T_MCREI_HST_RISTRUTTURAZIONI.cod_ndg%TYPE,
        p_tipo_ristr                      IN        t_mcrei_hst_ristrutturazioni.desc_tipo_ristr%TYPE,
        p_val_ordinale                   IN        t_mcrei_hst_ristrutturazioni.val_ordinale%TYPE,
        P_COD_PROTOCOLLO_DELIBERA      IN        T_MCREI_HST_RISTRUTTURAZIONI.COD_PROTOCOLLO_DELIBERA%TYPE,
        P_COD_MICROTIPOLOGIA_DELIB   IN        T_MCREI_HST_RISTRUTTURAZIONI.COD_MICROTIPOLOGIA_DELIB%TYPE,
        P_VARIAZIONE                          OUT NUMBER,
        P_DTA_DELIBERA                       OUT DATE
    )
        RETURN NUMBER;


    -- %d La funzione svuota la tabella T_MCREI_APP_RISTRUTTURAZIONI e
    -- %d carica i dati convertiti dalla tabella esterna TE_MCREI_RISTRUTTURATI
    -- %return 1 -> Esecuzione terminata con successo, 0 -> Esecuzione con errori / esecuzione non avvenuta
    FUNCTION fnc_carica_posizioni
        RETURN NUMBER;

    -- %d La funzione svuota la tabella T_MCREI_APP_RAPP_RISTR e
    -- %d carica i dati convertiti dalla tabella esterna TE_MCREI_RISTRUTTURATI_RAPP
    -- %d esegue la seguente decodifica sul campo N184 della TE_MCREI_RISTRUTTURATI_RAPP
    -- %d N184=3: parziale; N184 = 2: totale con intento liquidatorio, N184 = 3: totale senza intento liquidatorio
    -- %return 1 -> Esecuzione terminata con successo, 0 -> Esecuzione con errori / esecuzione non avvenuta
    FUNCTION fnc_carica_rapporti
        RETURN NUMBER;



    -- %author
    -- %version 0.1
    -- %usage La procedura che gestisce i rapporti nuovi e dei rapporti associati a posizioni ristrutturate
    -- %d La procedura richiama le funzioni di gestione dei rapporti nuovi e dei rapporti estinti per
    -- %d tutte le posizioni per cui esiste una ristrutturazione
    -- %d viene preso solo il massimo ordinale e considerate le posizioni per cui
    -- %d l'ultima configurazione non ¿ di chiusura ristrutturazione
    -- %param v_posizioni_da_processare posizioni con ristrutturazione da processare
    -- %param v_posizioni_processate posizioni effettivamente processate
    -- %cd 30 lug 2012
    FUNCTION prc_main_batch_ris (p_rec IN f_slave_par_type)
        RETURN NUMBER;

    PROCEDURE prc_cancella_rapporti_arrivati;
END pkg_mcrei_gest_batch;
/


CREATE SYNONYM MCRE_APP.PKG_MCREI_GEST_BATCH FOR MCRE_OWN.PKG_MCREI_GEST_BATCH;


CREATE SYNONYM MCRE_USR.PKG_MCREI_GEST_BATCH FOR MCRE_OWN.PKG_MCREI_GEST_BATCH;


GRANT EXECUTE, DEBUG ON MCRE_OWN.PKG_MCREI_GEST_BATCH TO MCRE_USR;

