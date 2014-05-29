CREATE OR REPLACE PACKAGE BODY MCRE_OWN.PKG_MCREI_WEB_UTIL_DELIB IS
/******************************************************************************
NAME:       PKG_MCREI_WEB_UTIL_DELIB
PURPOSE:

REVISIONS:
Ver        Date              Author             Description
---------  ----------      -----------------  ------------------------------------
1.0      13/03/2012                           Created this package.
1.1      02/08/2012         M.Murro           Aggiunta funzione per presa visione alert incagli
1.2      24/10/2012         M.Murro           Presavisione alert incagli - conferimenti-no commit
1.3      31/10/2012         I.Gueorguieva     Gestisci_utente
1.4      21/11/2012         M.Ceru            switch_criterio_assegnazione, assegnazione_gestori
1.5      03/04/2013         I.Gueorguieva
1.6      11/04/2013         M.Murro           aggiunta popola_rapporti_in_essere
1.7      14/05/2013         M.Murro           aggiinte funzioni RWA di Luca
1.8      15/05/2013         M.Murro           agginte funzioni check pos scadute
1.9      27/05/2013         M.Murro           agginta gestione dta_conferma_host
2.0      07/11/2013         M.Ceru'           fix pos_scadute_pacchetto- fix 11.11
2.1      28/11/2013         M.Murro           fix pos_scadute
2.2      29/01/2014         T.Bernardi        modificata fnc set_presa_visione_alert per gestione alert 48
2.3      24/03/2014         T.Bernardi        modificate func switch_criterio_assegnazione,assegnazione_gestori aggiunto caso 'PR'
******************************************************************************/
   PROCEDURE verifica_gestione_esterna (
      p_cod_sndg_da_class IN t_mcrei_app_delibere.cod_sndg%TYPE,
      p_cod_ndg IN t_mcrei_app_delibere.cod_ndg%TYPE,
      p_cod_abi IN t_mcrei_app_delibere.cod_abi%TYPE,
      p_cod_protocollo_delibera IN t_mcrei_app_delibere.cod_protocollo_delibera%TYPE,
      p_cod_protocollo_pacchetto IN t_mcrei_app_delibere.cod_protocollo_pacchetto%TYPE,
      p_forz_man_gest_interna IN t_mcrei_app_delibere.flg_forz_man_gest_interna%TYPE,
      p_esp_complessiva_cassa IN t_mcrei_app_delibere.val_esp_tot_cassa%TYPE,
      p_motivo_pass_rischio IN t_mcrei_app_delibere.desc_motivo_pass_rischio%TYPE,
      out_motivo_no_cess_rout IN OUT VARCHAR2,
      out_motivo_gestione IN OUT VARCHAR2,
      out_motivo_errore IN OUT VARCHAR2,
      out_esito IN OUT NUMBER
   )
   AS
      c_nome CONSTANT VARCHAR2 (100)
                                 := c_package || '.VERIFICA_GESTIONE_ESTERNA';
      c_esposizione_cliente_min CONSTANT NUMBER := 500;
      c_esposizione_cliente_max CONSTANT NUMBER := 15550;
      v_flg_cessione_rout t_mcre0_app_istituti_all.flg_cessione_rout%TYPE;
      v_flg_posiz_da_cedere t_mcrei_app_delibere.flg_posiz_da_cedere%TYPE;
   BEGIN
--Setting del parametro di configurazione
      DBMS_APPLICATION_INFO.set_client_info (p_cod_sndg_da_class);
--Setting dei valori di default per i parametri di ritorno
      out_motivo_no_cess_rout := '';
      out_motivo_gestione := '';
      out_motivo_errore := '';
--Setting del valore di default per il flag risultante dalla verifica di gestione interna/esterna
      v_flg_posiz_da_cedere := 'N';

--Verifica di consistenza dei parametri passati in input
      IF    p_cod_sndg_da_class IS NULL
         OR p_cod_ndg IS NULL
         OR p_cod_abi IS NULL
         OR p_cod_protocollo_delibera IS NULL
         OR p_cod_protocollo_pacchetto IS NULL
         OR p_forz_man_gest_interna IS NULL                               --OR
--P_ESP_COMPLESSIVA_CASSA IS NULL OR
--P_ESP_COMPLESSIVA_CASSA = 0 OR
--P_MOTIVO_PASS_RISCHIO IS NULL
      THEN
         out_esito := const_esito_ko;
         raise_application_error (-20666, 'Null parameter');
      END IF;

--PRIMO CONTROLLO: verifica del flag di forzatura manuale alla gestione interna del dettaglio della proposta di classificazione a sofferenza
      IF p_forz_man_gest_interna = 'Y'
      THEN
         v_flg_posiz_da_cedere := 'F';
         out_motivo_gestione :=
            'Passaggio a gestione esterna: S stata impostata la forzatura manuale';
      ELSE
--SECONDO CONTROLLO: Verifica della cessione routinaria : per le direzioni non sar¿ mai possibile

         --BEGIN CESSIONE ROUTINARIA

         --TODO: da implementare quando si aprir¿ alle filiali
         out_motivo_no_cess_rout :=
             'Per le direzioni non sar¿ mai possibile la cessione routinaria';
--END CESSIONE ROUTINARIA
      END IF;

--Se, per la posizione, non si e' ancora deciso se deve essere passata a gestione esterna, allora si prosegue con i controlli
      IF v_flg_posiz_da_cedere = 'N'
      THEN
--TERZO CONTROLLO: si verificano tutti i flag della vista V_MCREI_APP_VERIF_GEST_INTERNA per i condivisi e per i collegati della posizione
         SELECT CASE
                   WHEN j > 0
                      THEN 'J'
                   WHEN i > 0
                      THEN 'I'
                   WHEN t > 0
                      THEN 'T'
                   WHEN s > 0
                      THEN 'S'
                   WHEN x > 0
                      THEN 'X'
                   WHEN y > 0
                      THEN 'Y'
                   ELSE 'N'
                END AS risultato
           INTO v_flg_posiz_da_cedere
           FROM (SELECT SUM (CASE
                                WHEN cod_sndg = cod_sndg_da_class
                                AND flg_gestione_esterna = 'Y'
                                AND cod_stato = 'SO'
                                   THEN 1
                                ELSE 0
                             END
                            ) AS j,
                        SUM (CASE
                                WHEN cod_sndg <> cod_sndg_da_class
                                AND flg_gestione_esterna = 'Y'
                                AND cod_stato = 'SO'
                                   THEN 1
                                ELSE 0
                             END
                            ) AS i,
                        SUM (CASE
                                WHEN cod_sndg = cod_sndg_da_class
                                AND flg_fondo_terzi = 'Y'
                                   THEN 1
                                ELSE 0
                             END
                            ) AS t,
                        SUM (CASE
                                WHEN cod_sndg <> cod_sndg_da_class
                                AND flg_fondo_terzi = 'Y'
                                   THEN 1
                                ELSE 0
                             END
                            ) AS s,
                        SUM (CASE
                                WHEN cod_sndg = cod_sndg_da_class
                                AND flg_art_498 = 'Y'
                                   THEN 1
                                ELSE 0
                             END
                            ) AS x,
                        SUM (CASE
                                WHEN cod_sndg <> cod_sndg_da_class
                                AND flg_art_498 = 'Y'
                                   THEN 1
                                ELSE 0
                             END
                            ) AS y
                   FROM v_mcrei_app_verif_gest_interna
                  WHERE cod_sndg_da_class = p_cod_sndg_da_class);

         IF v_flg_posiz_da_cedere = 'N'
         THEN
            out_motivo_gestione :=
               'La posizione non ha superato nessun controllo per il passaggio a gestione esterna';
         ELSE
            out_motivo_gestione :=
               'Passaggio a gestione esterna: il controllo sui condivisi e sui collegati ha dato esito positivo';
         END IF;
      END IF;

      UPDATE t_mcrei_app_delibere
         SET flg_posiz_da_cedere = v_flg_posiz_da_cedere
       WHERE p_cod_ndg = cod_ndg
         AND p_cod_abi = cod_abi
         AND p_cod_protocollo_delibera = cod_protocollo_delibera
         AND p_cod_protocollo_pacchetto = cod_protocollo_pacchetto;

      out_esito := const_esito_ok;
   EXCEPTION
      WHEN OTHERS
      THEN
         pkg_mcrei_audit.log_app (c_nome,
                                  3,
                                  SQLCODE,
                                  SQLERRM,
                                     'abi: '
                                  || p_cod_abi
                                  || ' ndg: '
                                  || p_cod_ndg
                                  || ' cod_sndg: '
                                  || p_cod_sndg_da_class
                                  || ' cod_prot_delibera: '
                                  || p_cod_protocollo_delibera
                                  || ' cod_prot_pacchetto: '
                                  || p_cod_protocollo_pacchetto,
                                  NULL
                                 );
         out_esito := const_esito_ko;
   END verifica_gestione_esterna;

   FUNCTION set_presa_visione_alert (
      codabi IN t_mcrei_app_delibere.cod_abi%TYPE,
      codndg IN t_mcrei_app_delibere.cod_ndg%TYPE,
      codsndg IN t_mcrei_app_delibere.cod_sndg%TYPE,
      codprotocollopacchetto IN t_mcrei_app_delibere.cod_protocollo_pacchetto%TYPE,
      codprotocollodelibera IN t_mcrei_app_delibere.cod_protocollo_delibera%TYPE,
      id_alert IN NUMBER,
      codutente IN t_mcrei_app_delibere.cod_matricola_inserente%TYPE
            DEFAULT NULL
   )
      RETURN NUMBER
   AS
   BEGIN
--versione base.. da estendere in modo flessibile....
--utilizzare T_MCREI_APP_ALERT_FLG_PR_VIS che è partizionata per id_Alert per far spegnere l'alert
      CASE
         WHEN id_alert = 33
         THEN                                   -- presa visione conferimenti
            UPDATE t_mcre0_hst_mig_recode_ndg
               SET flg_presa_visione = 2,
                   dta_presa_visione = SYSDATE,
                   cod_matr_visione = codutente
             WHERE cod_abi_new = codabi AND cod_ndg_new = codndg;

            UPDATE t_mcre0_app_mig_recode_ndg
               SET flg_presa_visione = 2
             WHERE COD_ABI_NEW = CODABI AND COD_NDG_NEW = CODNDG;
         WHEN ID_ALERT = 48
         THEN
              INSERT INTO T_MCREI_APP_ALERT_FLG_PR_VIS (ID_ALERT            ,
                                                        COD_ABI             ,
                                                        COD_NDG             ,
                                                        FLG_PR_VIS          ,
                                                        COD_MATRICOLA_PR_VIS,
                                                        DTA_PR_VIS)
                                                  VALUES(48       ,
                                                        CODABI    ,
                                                        CODNDG    ,
                                                        1         ,
                                                        CODUTENTE ,
                                                        SYSDATE);
      ELSE
            NULL;
      END CASE;

--commit; --committa web
      pkg_mcrei_audit.log_app (c_package || '.set_presa_visione_alert',
                               3,
                               SQLCODE,
                               'presa visione alert ' || id_alert,
                                  'abi: '
                               || codabi
                               || ' ndg: '
                               || codndg
                               || ' cod_sndg: '
                               || codsndg
                               || ' cod_prot_delibera: '
                               || codprotocollodelibera
                               || ' cod_prot_pacchetto: '
                               || codprotocollopacchetto,
                               codutente
                              );
      RETURN const_esito_ok;
   EXCEPTION
      WHEN OTHERS
      THEN
         pkg_mcrei_audit.log_app (c_package || '.set_presa_visione_alert',
                                  1,
                                  SQLCODE,
                                  SQLERRM,
                                     'abi: '
                                  || codabi
                                  || ' ndg: '
                                  || codndg
                                  || ' cod_sndg: '
                                  || codsndg
                                  || ' cod_prot_delibera: '
                                  || codprotocollodelibera
                                  || ' cod_prot_pacchetto: '
                                  || codprotocollopacchetto
                                  || 'alert '
                                  || id_alert,
                                  codutente
                                 );
--rollback; --rollbak web
         RETURN const_esito_ko;
   END;

-- %AUTHOR REPLY
-- %VERSION 0.2
-- %USAGE  FUNZIONE CHE INSERISCE UN NUOVO UTENTE
-- %D Nel caso di cancellazione l'utente sara' inserito su T_MCRE0_HST_UTENTI
-- %PARAM P_ID_UTENTE ID del nuovo utente da inserire
-- %PARAM P_FLG_AZIONE: I insert, U update, D delete
-- %PARAM P_STATI_ASSOCIATI concatenazione degli stati separati da ;
-- %CD 31 OTT
-- %RETURN -> 1 se l'operazione e' andata a buon fine, 0 altrimenti
   FUNCTION gestisci_utente (
      p_id_utente IN t_mcre0_app_utenti.id_utente%TYPE,
      p_cod_matricola IN t_mcre0_app_utenti.cod_matricola%TYPE,
      p_cod_fiscale IN t_mcre0_app_utenti.cod_fiscale%TYPE,
      p_cognome IN t_mcre0_app_utenti.cognome%TYPE,
      p_nome IN t_mcre0_app_utenti.nome%TYPE,
      p_id_referente IN t_mcre0_app_utenti.id_referente%TYPE,
      p_data_assegnazione_ref IN t_mcre0_app_utenti.data_assegnazione_ref%TYPE,
      p_flg_gestore_abilitato IN t_mcre0_app_utenti.flg_gestore_abilitato%TYPE,
      p_cod_comparto_utente IN t_mcre0_app_utenti.cod_comparto_utente%TYPE,
      p_stati_associati IN VARCHAR2,
      p_flg_azione IN VARCHAR2,
      p_id_utente_new IN t_mcre0_app_utenti.id_utente%TYPE,
      p_flg_referente IN t_mcre0_app_utenti.flg_referente%TYPE,
      p_cod_comparto_appart IN t_mcre0_app_utenti.cod_comparto_appart%TYPE,
      p_cod_priv IN t_mcre0_app_utenti.cod_priv%TYPE,
      p_cod_comparto_assegn IN t_mcre0_app_utenti.cod_comparto_assegn%TYPE,
      p_cod_processo IN VARCHAR2 default 'XX'--tutti i processi
   )
      RETURN NUMBER
   IS
      p_note t_mcrei_wrk_audit_applicativo.note%TYPE;
      p_nome_fun VARCHAR2 (50) := '.GESTISCI_UTENTE';
      p_param VARCHAR2 (500) := 'ID_UTENTE             ' || p_id_utente;
      v_retstr mcre_own.parse.items_tt;
      v_delim VARCHAR2 (1) := ';';
      v_id_utente t_mcre0_app_utenti.id_utente%TYPE := p_id_utente;
   BEGIN
      IF    p_id_utente IS NULL
         OR p_id_utente_new IS NULL
         OR p_flg_azione IS NULL
         OR p_flg_azione NOT IN ('I', 'U', 'D', 'i', 'u', 'd')
      THEN
         raise_application_error (-20666, 'Null or invalid parameter');
      END IF;

      p_param :=
            p_param
         || CHR (10)
         || 'COD_MATRICOLA         '
         || p_cod_matricola
         || CHR (10)
         || 'COD_FISCALE           '
         || p_cod_fiscale
         || CHR (10)
         || 'COGNOME               '
         || p_cognome
         || CHR (10)
         || 'NOME                  '
         || p_nome
         || CHR (10)
         || 'ID_REFERENTE          '
         || p_id_referente
         || CHR (10)
         || 'DATA_ASSEGNAZIONE_REF '
         || p_data_assegnazione_ref
         || CHR (10)
         || 'FLG_GESTORE_ABILITATO '
         || p_flg_gestore_abilitato
         || CHR (10)
         || 'COD_COMPARTO_UTENTE   '
         || p_cod_comparto_utente
         || CHR (10)
         || 'STATI_ASSOCIATI       '
         || p_stati_associati
         || CHR (10)
         || 'FLG_AZIONE            '
         || p_flg_azione
         || CHR (10)
         || 'ID_UTENTE_NEW         '
         || p_id_utente_new
         || CHR (10)
         || 'FLG_REFERENTE         '
         || p_flg_referente
         || CHR (10)
         || 'P_COD_COMPARTO_APPART '
         || p_cod_comparto_appart
         || CHR (10)
         || 'COD_PRIV              '
         || p_cod_priv
         || CHR (10)
         || 'COD_COMPARTO_ASSEGN   '
         || p_cod_comparto_assegn
         || CHR (10)
         || 'PROCESSO_ASSOCIATO    '
         || p_cod_processo;
      v_retstr := parse.string_to_list (p_stati_associati, v_delim);

      CASE
         WHEN p_flg_azione IN ('I', 'i')
         THEN
            INSERT INTO t_mcre0_app_utenti
                        (id_utente, cod_matricola, cod_fiscale,
                         cognome, nome, id_referente,
                         data_assegnazione_ref, flg_gestore_abilitato,
                         cod_comparto_utente, flg_referente,
                         cod_comparto_appart, cod_priv,
                         cod_comparto_assegn
                        )
                 VALUES (p_id_utente, p_cod_matricola, p_cod_fiscale,
                         p_cognome, p_nome, p_id_referente,
                         p_data_assegnazione_ref, p_flg_gestore_abilitato,
                         p_cod_comparto_utente, NVL (p_flg_referente, '0'),
                         p_cod_comparto_appart, p_cod_priv,
                         p_cod_comparto_assegn
                        );

            FORALL i IN v_retstr.FIRST .. v_retstr.LAST
               INSERT INTO t_mcre0_app_gestori_stati_comp
                           (id_utente, cod_microstato
                           ,cod_processo--DR
                           )
                    VALUES (p_id_utente, v_retstr (i)
                            ,p_cod_processo--DR
                           );
         WHEN p_flg_azione IN ('U', 'u')
         THEN
            DELETE FROM t_mcre0_app_utenti
                  WHERE id_utente = p_id_utente;

            IF p_id_utente != p_id_utente_new
            THEN
               v_id_utente := p_id_utente_new;
            END IF;

            INSERT INTO t_mcre0_app_utenti
                        (id_utente, cod_matricola, cod_fiscale,
                         cognome, nome, id_referente,
                         data_assegnazione_ref, flg_gestore_abilitato,
                         cod_comparto_utente, flg_referente,
                         cod_comparto_appart, cod_priv,
                         cod_comparto_assegn
                        )
                 VALUES (v_id_utente, p_cod_matricola, p_cod_fiscale,
                         p_cognome, p_nome, p_id_referente,
                         p_data_assegnazione_ref, p_flg_gestore_abilitato,
                         p_cod_comparto_utente, NVL (p_flg_referente, '0'),
                         p_cod_comparto_appart, p_cod_priv,
                         p_cod_comparto_assegn
                        );

            DELETE FROM t_mcre0_app_gestori_stati_comp
                  WHERE id_utente = p_id_utente;

            FORALL i IN v_retstr.FIRST .. v_retstr.LAST
               INSERT INTO t_mcre0_app_gestori_stati_comp
                           (id_utente, cod_microstato
                           ,cod_processo--DR
                           )
                    VALUES (v_id_utente, v_retstr (i)
                            ,p_cod_processo--DR
                           );
         WHEN p_flg_azione IN ('D', 'd')
         THEN
-- CASO CANCELLAZIONE LOGICA DA CREARE ANCORA LA TABELLA HST DEGLI UTENTI
            INSERT INTO t_mcre0_hst_utenti
                        (id_utente, cod_matricola, cod_fiscale, cognome,
                         nome, id_referente, data_assegnazione_ref,
                         flg_gestore_abilitato, cod_comparto_utente,
                         flg_referente, cod_comparto_appart, cod_priv,
                         cod_comparto_assegn)
               SELECT id_utente, cod_matricola, cod_fiscale, cognome, nome,
                      id_referente, data_assegnazione_ref,
                      flg_gestore_abilitato, cod_comparto_utente,
                      flg_referente, cod_comparto_appart, cod_priv,
                      cod_comparto_assegn
                 FROM t_mcre0_app_utenti
                WHERE id_utente = p_id_utente;

            DELETE FROM t_mcre0_app_utenti
                  WHERE id_utente = p_id_utente;

            DELETE FROM t_mcre0_app_gestori_stati_comp
                  WHERE id_utente = p_id_utente;
      END CASE;

      pkg_mcrei_audit.log_app (pkg_mcrei_web_util_delib.c_package
                               || p_nome_fun,
                               3,
                               SQLCODE,
                               SQLERRM,
                               p_note || p_param,
                               NULL
                              );
      RETURN const_esito_ok;
   EXCEPTION
      WHEN OTHERS
      THEN
         pkg_mcrei_audit.log_app (   pkg_mcrei_web_util_delib.c_package
                                  || p_nome_fun,
                                  3,
                                  SQLCODE,
                                  SQLERRM,
                                  p_note || p_param,
                                  NULL
                                 );
         RETURN const_esito_ko;
   END gestisci_utente;

   FUNCTION switch_criterio_assegnazione (
      p_cod_struttura_competente_rg IN t_mcre0_app_struttura_org.cod_struttura_competente%TYPE,
      p_cod_abi_istituto IN t_mcre0_app_struttura_org.cod_abi_istituto%TYPE,
      p_desc_criterio_assegnazione IN t_mcre0_app_associa_gestori_uo.desc_criterio_assegnazione%TYPE,
      p_cod_matricola_assegnatario IN t_mcre0_app_utenti.cod_matricola%TYPE,
      p_cod_comparto_assegnatario IN t_mcre0_app_utenti.cod_comparto_appart%TYPE,
      p_cod_struttura_competente_ar IN t_mcre0_app_struttura_org.cod_struttura_competente%TYPE DEFAULT NULL
   )
      RETURN NUMBER
   IS
      p_note t_mcrei_wrk_audit_applicativo.note%TYPE;
      c_nome CONSTANT VARCHAR2 (100)
                              := c_package || '.SWITCH_CRITERIO_ASSEGNAZIONE';
      p_nome_fun VARCHAR2 (50) := 'SWITCH_CRITERIO_ASSEGNAZIONE';
      p_param VARCHAR2 (500)
         :=    'P_DESC_CRITERIO_ASSEGNAZIONE: '
            || p_desc_criterio_assegnazione
            || ' P_COD_STRUTTURA_COMPETENTE_RG: '
            || p_cod_struttura_competente_rg
            || ' P_COD_STRUTTURA_COMPETENTE_AR: '
            || NVL (p_cod_struttura_competente_ar, 'NULL')
            || ' P_COD_ABI_ISTITUTO: '
            || p_cod_abi_istituto;
      v_cod_livello_assegn t_mcre0_app_comparti.cod_livello%TYPE;
      v_count NUMBER;
   BEGIN
      IF    p_desc_criterio_assegnazione IS NULL
         OR p_cod_struttura_competente_rg IS NULL
         OR p_cod_abi_istituto IS NULL
      THEN
         raise_application_error (-20666, 'Null parameter');
      END IF;

--livello dell'utente assegnatario
      SELECT cod_livello
        INTO v_cod_livello_assegn
        FROM t_mcre0_app_comparti
       WHERE cod_comparto = p_cod_comparto_assegnatario;

--Lo switch di criterio ha senso solo per un utente di tipo regione (accede a entrambi i criteri di associazione):
      IF (v_cod_livello_assegn = 'RG')
      THEN
         IF (p_desc_criterio_assegnazione = 'FI')
         THEN
            UPDATE t_mcre0_app_associa_gestori_uo
               SET flg_attivo = '1'
             WHERE cod_abi_istituto = p_cod_abi_istituto
               AND cod_comparto_assegnatario = p_cod_comparto_assegnatario
               AND desc_criterio_assegnazione = 'FI'
               AND flg_attivo = '0';

            SELECT COUNT (*)
              INTO v_count
              FROM t_mcre0_app_associa_gestori_uo
             WHERE cod_abi_istituto = p_cod_abi_istituto
               AND cod_comparto_assegnatario = p_cod_comparto_assegnatario
               AND desc_criterio_assegnazione in ('PR','RG','AR')--= 'AR'
               AND flg_attivo = '1';

            IF (v_count >= 1)
            THEN
               UPDATE t_mcre0_app_associa_gestori_uo
                  SET flg_attivo = '0'
                WHERE cod_abi_istituto = p_cod_abi_istituto
                  AND cod_comparto_assegnatario = p_cod_comparto_assegnatario
                  AND desc_criterio_assegnazione in ('PR','RG','AR')--= 'AR'
                  AND flg_attivo = '1';
            --and COD_STRUTTURA_COMPETENTE_AR = P_COD_STRUTTURA_COMPETENTE_AR
            END IF;
         END IF;

         IF (p_desc_criterio_assegnazione = 'AR')
         THEN
            UPDATE t_mcre0_app_associa_gestori_uo
               SET flg_attivo = '1'
             WHERE cod_struttura_competente_rg = p_cod_struttura_competente_rg
               AND cod_abi_istituto = p_cod_abi_istituto
               AND cod_comparto_assegnatario = p_cod_comparto_assegnatario
               AND desc_criterio_assegnazione = 'AR'
               AND flg_attivo = '0';

            SELECT COUNT (*)
              INTO v_count
              FROM t_mcre0_app_associa_gestori_uo
             WHERE cod_struttura_competente_rg = p_cod_struttura_competente_rg
               AND cod_abi_istituto = p_cod_abi_istituto
               AND cod_comparto_assegnatario = p_cod_comparto_assegnatario
               AND desc_criterio_assegnazione in ('FI','RG','PR')--= 'FI'
               AND flg_attivo = '1';

            IF (v_count >= 1)
            THEN
               UPDATE t_mcre0_app_associa_gestori_uo
                  SET flg_attivo = '0'
                WHERE cod_struttura_competente_rg =
                                                 p_cod_struttura_competente_rg
                  AND cod_abi_istituto = p_cod_abi_istituto
                  AND cod_comparto_assegnatario = p_cod_comparto_assegnatario
                  AND desc_criterio_assegnazione in ('FI','RG','PR')--= 'FI'
                  AND flg_attivo = '1';
            END IF;
         END IF;
     -- END IF;

      IF (p_desc_criterio_assegnazione = 'PR')
      THEN
        UPDATE t_mcre0_app_associa_gestori_uo
          SET flg_attivo = '1'
        WHERE cod_struttura_competente_rg = p_cod_struttura_competente_rg
          AND cod_abi_istituto = p_cod_abi_istituto
          AND cod_comparto_assegnatario = p_cod_comparto_assegnatario
          AND desc_criterio_assegnazione = 'PR'
          AND flg_attivo = '0';

      SELECT COUNT (*)
        INTO v_count
        FROM t_mcre0_app_associa_gestori_uo
       WHERE cod_struttura_competente_rg = p_cod_struttura_competente_rg
         AND cod_abi_istituto = p_cod_abi_istituto
         AND cod_comparto_assegnatario = p_cod_comparto_assegnatario
         AND desc_criterio_assegnazione in ('FI','RG','AR')
         AND flg_attivo = '1';

         IF (v_count >= 1)
         THEN
            UPDATE t_mcre0_app_associa_gestori_uo
               SET flg_attivo = '0'
             WHERE cod_struttura_competente_rg = p_cod_struttura_competente_rg
               AND cod_abi_istituto = p_cod_abi_istituto
               AND cod_comparto_assegnatario = p_cod_comparto_assegnatario
               AND desc_criterio_assegnazione in ('FI','RG','AR')
               AND flg_attivo = '1';
          END IF;
        END IF;
     END IF;

      pkg_mcrei_audit.log_app (   pkg_mcrei_web_util_delib.c_package
                               || '.'
                               || p_nome_fun,
                               3,
                               SQLCODE,
                               SQLERRM,
                               p_note || p_param,
                               NULL
                              );
      RETURN const_esito_ok;
   EXCEPTION
      WHEN OTHERS
      THEN
         pkg_mcrei_audit.log_app (   pkg_mcrei_web_util_delib.c_package
                                  || '.'
                                  || p_nome_fun,
                                  3,
                                  SQLCODE,
                                  SQLERRM,
                                  p_note || p_param,
                                  NULL
                                 );
         RETURN const_esito_ko;
   END switch_criterio_assegnazione;

  FUNCTION assegnazione_gestori (
      p_cod_struttura_competente_dc IN t_mcre0_app_struttura_org.cod_struttura_competente%TYPE,
      p_cod_struttura_competente_dv IN t_mcre0_app_struttura_org.cod_struttura_competente%TYPE,
      p_cod_struttura_competente_rg IN t_mcre0_app_struttura_org.cod_struttura_competente%TYPE,
      p_cod_abi_istituto IN t_mcre0_app_struttura_org.cod_abi_istituto%TYPE,
      p_desc_criterio_assegnazione IN t_mcre0_app_associa_gestori_uo.desc_criterio_assegnazione%TYPE,
      --P_COD_CRITERIO_ASSEGN
      p_cod_matricola_assegnatario IN t_mcre0_app_utenti.cod_matricola%TYPE,
      --P_COD_MATRICOLA_ASSEGN
      p_cod_comparto_assegnatario IN t_mcre0_app_utenti.cod_comparto_appart%TYPE,
      --P_COD_COMPARTO_ASSEGN
      p_cod_struttura_competente IN t_mcre0_app_struttura_org.cod_struttura_competente%TYPE,
      p_cod_matricola_assegnata IN t_mcre0_app_utenti.cod_matricola%TYPE,
      --P_COD_MATRICOLA
      P_COD_STRUTTURA_COMPETENTE_AR IN T_MCRE0_APP_STRUTTURA_ORG.COD_STRUTTURA_COMPETENTE%TYPE
            DEFAULT NULL,
      P_TEAM in varchar2,                                                --MOD
      P_COD_PROCESSO in VARCHAR2 default '*'
   )
      RETURN NUMBER
   IS
      p_note t_mcrei_wrk_audit_applicativo.note%TYPE;
      c_nome CONSTANT VARCHAR2 (100) := c_package || '.ASSEGNAZIONE_GESTORI';
      p_nome_fun VARCHAR2 (50) := 'ASSEGNAZIONE_GESTORI';
      p_param VARCHAR2 (500)
         :=    'P_COD_STRUTTURA_COMPETENTE: '
            || p_cod_struttura_competente
            || ' P_COD_MATRICOLA: '
            || p_cod_matricola_assegnata
            || ' P_COD_PROCESSO: '
            || p_cod_processo;
      v_desc_tipo_struttura t_mcre0_app_associa_gestori_uo.desc_tipo_struttura%TYPE;
      v_cod_struttura_assegnatario t_mcre0_app_associa_gestori_uo.cod_struttura_assegnatario%TYPE;
      v_cod_livello_assegn t_mcre0_app_comparti.cod_livello%TYPE;
      v_desc_crit_ass_old t_mcre0_app_associa_gestori_uo.desc_criterio_assegnazione%TYPE
                                                                       := NULL;
      v_count NUMBER;
      V_ID_UTENTE_ASSEGNATO NUMBER;

   BEGIN
      p_note :=
            'Controllo parametri in ingresso: '
         || p_cod_struttura_competente_dc
         || ', '
         || p_cod_struttura_competente_dv
         || ', '
         || p_cod_struttura_competente_rg
         || ', '
         || p_cod_abi_istituto
         || ', '
         || p_desc_criterio_assegnazione
         || ', '
         || p_cod_matricola_assegnatario
         || ', '
         || p_cod_comparto_assegnatario
         || ', '
         || p_cod_struttura_competente
         || ', '
         || p_cod_matricola_assegnata
         || ', '
         || P_TEAM                                                             --MOD
         || ', '
         || p_cod_struttura_competente_ar;

      IF    p_desc_criterio_assegnazione IS NULL
         OR p_cod_struttura_competente IS NULL
         OR P_COD_MATRICOLA_ASSEGNATA IS NULL

      THEN
         raise_application_error (-20666, 'Null parameter');
      END IF;                               --livello dell'utente assegnatario

      SELECT cod_livello
        INTO v_cod_livello_assegn
        FROM t_mcre0_app_comparti
       WHERE cod_comparto = p_cod_comparto_assegnatario;

      IF (p_cod_matricola_assegnata <> 'D')
      THEN
         SELECT id_utente
           INTO v_id_utente_assegnato
           FROM t_mcre0_app_utenti
          WHERE cod_matricola = p_cod_matricola_assegnata;
      ELSE
         v_id_utente_assegnato := '-1';
      END IF;

      IF (v_cod_livello_assegn = 'RG')
      THEN
         v_desc_tipo_struttura := 'RG';
         v_cod_struttura_assegnatario := p_cod_struttura_competente_rg;
      ELSE
         v_desc_tipo_struttura := 'AR';
         v_cod_struttura_assegnatario := p_cod_struttura_competente_ar;
      END IF;

      IF (p_desc_criterio_assegnazione = 'FI')
      THEN
         MERGE INTO t_mcre0_app_associa_gestori_uo t
            USING (SELECT p_cod_struttura_competente_dc
                                              AS cod_struttura_competente_dc,
                          p_cod_struttura_competente_dv
                                              AS cod_struttura_competente_dv,
                          p_cod_struttura_competente_rg
                                              AS cod_struttura_competente_rg,
                          p_cod_struttura_competente_ar
                                              AS cod_struttura_competente_ar,
                          p_desc_criterio_assegnazione
                                               AS desc_criterio_assegnazione,
                          p_cod_matricola_assegnatario
                                               AS cod_matricola_assegnatario,
                          p_cod_comparto_assegnatario
                                                AS cod_comparto_assegnatario,
                          p_cod_struttura_competente
                                              AS cod_struttura_competente_fi,
                          DECODE
                             (p_cod_matricola_assegnata,
                              'D', NULL,
                              p_cod_matricola_assegnata
                             )
                                              AS cod_matricola_assegnata,
                          P_COD_ABI_ISTITUTO
                                              AS cod_abi_istituto,
                          v_desc_tipo_struttura
                                              AS desc_tipo_struttura,
                          v_cod_struttura_assegnatario
                                              AS COD_STRUTTURA_ASSEGNATARIO,
                          '1'                 AS FLG_ATTIVO,
                          V_ID_UTENTE_ASSEGNATO
                                              AS ID_UTENTE_ASSEGNATO
                     FROM DUAL) s
            ON (    t.cod_struttura_competente_fi =
                                                s.cod_struttura_competente_fi
                AND t.cod_abi_istituto = s.cod_abi_istituto
                AND t.desc_criterio_assegnazione =
                                                  s.desc_criterio_assegnazione)
            WHEN MATCHED THEN
               UPDATE
                  SET t.cod_struttura_competente_dc =
                                                 s.cod_struttura_competente_dc,
                      t.cod_struttura_competente_dv =
                                                 s.cod_struttura_competente_dv,
                      t.cod_struttura_competente_rg =
                                                 s.cod_struttura_competente_rg,
                      t.cod_struttura_competente_ar =
                                                 s.cod_struttura_competente_ar,
                      T.COD_MATRICOLA_ASSEGNATA =
                                                 decode(P_TEAM,'C',S.cod_matricola_assegnata,T.cod_matricola_assegnata),  --MOD
                      t.cod_matricola_assegnatario =
                                                  s.cod_matricola_assegnatario,
                      t.cod_comparto_assegnatario =
                                                   S.COD_COMPARTO_ASSEGNATARIO,
                      t.dta_upd =                SYSDATE,
                      t.desc_tipo_struttura =
                                                  s.desc_tipo_struttura,
                      t.cod_struttura_assegnatario =
                                                  S.COD_STRUTTURA_ASSEGNATARIO,
                      t.flg_attivo =
                                                  s.flg_attivo,
                      T.ID_UTENTE_ASSEGNATO =
                                                  decode(P_TEAM,'C',S.ID_UTENTE_ASSEGNATO,T.ID_UTENTE_ASSEGNATO),          --MOD
                      T.ID_UTENTE_ASSEGNATO_PT =
                                                  decode(P_TEAM,'B',S.ID_UTENTE_ASSEGNATO,T.ID_UTENTE_ASSEGNATO_PT),     --MOD
                      T.COD_MATRICOLA_ASSEGNATA_PT =
                                                  decode(P_TEAM,'B',S.cod_matricola_assegnata,T.cod_matricola_assegnata_pt)  --MOD
            WHEN NOT MATCHED THEN
               INSERT (t.cod_struttura_competente_dc,
                       t.cod_struttura_competente_dv,
                       t.cod_struttura_competente_rg,
                       t.cod_struttura_competente_ar,
                       t.desc_criterio_assegnazione,
                       t.cod_matricola_assegnatario,
                       t.cod_comparto_assegnatario,
                       t.cod_struttura_competente_fi,
                       T.COD_MATRICOLA_ASSEGNATA,
                       t.cod_abi_istituto,
                       T.DTA_INS,
                       t.desc_tipo_struttura,
                       T.COD_STRUTTURA_ASSEGNATARIO,
                       t.flg_attivo,
                       T.ID_UTENTE_ASSEGNATO,
                       T.ID_UTENTE_ASSEGNATO_PT,                                --MOD
                       T.COD_MATRICOLA_ASSEGNATA_PT)                            --MOD
               VALUES (s.cod_struttura_competente_dc,
                       s.cod_struttura_competente_dv,
                       s.cod_struttura_competente_rg,
                       s.cod_struttura_competente_ar,
                       s.desc_criterio_assegnazione,
                       s.cod_matricola_assegnatario,
                       s.cod_comparto_assegnatario,
                       s.cod_struttura_competente_fi,
                        DECODE(P_TEAM,'C',S.COD_MATRICOLA_ASSEGNATA,NULL),
                       S.COD_ABI_ISTITUTO,
                       SYSDATE,
                       V_DESC_TIPO_STRUTTURA,
                       v_cod_struttura_assegnatario,
                       '1',
                        DECODE(P_TEAM,'C',S.ID_UTENTE_ASSEGNATO,NULL),
                        DECODE(P_TEAM,'B',S.ID_UTENTE_ASSEGNATO,NULL),
                        DECODE(P_TEAM,'B',S.COD_MATRICOLA_ASSEGNATA,NULL)
                          );
      END IF;

      IF (p_desc_criterio_assegnazione = 'AR')
      THEN
         FOR v_rec IN (SELECT cod_struttura_competente
                         FROM t_mcre0_app_struttura_org
                        WHERE cod_str_org_sup = p_cod_struttura_competente
                          AND cod_abi_istituto = p_cod_abi_istituto)
         LOOP
            MERGE INTO t_mcre0_app_associa_gestori_uo t
               USING (SELECT p_cod_struttura_competente_dc
                                              AS cod_struttura_competente_dc,
                             p_cod_struttura_competente_dv
                                              AS cod_struttura_competente_dv,
                             p_cod_struttura_competente_rg
                                              AS cod_struttura_competente_rg,
                             p_cod_struttura_competente
                                              AS cod_struttura_competente_ar,
                             p_desc_criterio_assegnazione
                                               AS desc_criterio_assegnazione,
                             p_cod_matricola_assegnatario
                                               AS cod_matricola_assegnatario,
                             p_cod_comparto_assegnatario
                                                AS cod_comparto_assegnatario,
                             v_rec.cod_struttura_competente
                                              AS cod_struttura_competente_fi,
                             DECODE
                                (p_cod_matricola_assegnata,
                                 'D', NULL,
                                 P_COD_MATRICOLA_ASSEGNATA
                                )             AS COD_MATRICOLA_ASSEGNATA,
                             p_cod_abi_istituto
                                              AS cod_abi_istituto,
                             v_desc_tipo_struttura
                                              AS desc_tipo_struttura,
                             v_cod_struttura_assegnatario
                                               AS COD_STRUTTURA_ASSEGNATARIO,
                             '1'               AS flg_attivo,
                             V_ID_UTENTE_ASSEGNATO
                                               AS id_utente_assegnato
                        FROM DUAL) s
               ON (t.cod_struttura_competente_fi =
                                                s.cod_struttura_competente_fi
               AND t.cod_abi_istituto = s.cod_abi_istituto
               AND t.desc_criterio_assegnazione = s.desc_criterio_assegnazione)
               WHEN MATCHED THEN
                  UPDATE
                     SET t.cod_struttura_competente_dc =
                                                 s.cod_struttura_competente_dc,
                         t.cod_struttura_competente_dv =
                                                 s.cod_struttura_competente_dv,
                         t.cod_struttura_competente_rg =
                                                 s.cod_struttura_competente_rg,
                         t.cod_struttura_competente_ar =
                                                 s.cod_struttura_competente_ar,
                         T.COD_MATRICOLA_ASSEGNATA =
                                                  decode(P_TEAM,'B',S.cod_matricola_assegnata,T.cod_matricola_assegnata),  --MOD
                         t.cod_matricola_assegnatario =
                                                  s.cod_matricola_assegnatario,
                         t.cod_comparto_assegnatario =
                                                   s.cod_comparto_assegnatario,
                         t.dta_upd = SYSDATE,
                         t.desc_tipo_struttura = s.desc_tipo_struttura,
                         t.cod_struttura_assegnatario =
                                                  s.cod_struttura_assegnatario,
                         T.FLG_ATTIVO =
                                                  S.FLG_ATTIVO,
                         T.ID_UTENTE_ASSEGNATO =
                                                  DECODE(P_TEAM,'C',S.ID_UTENTE_ASSEGNATO,T.ID_UTENTE_ASSEGNATO),          --MOD
                         T.ID_UTENTE_ASSEGNATO_PT =
                                                  DECODE(P_TEAM,'B',S.ID_UTENTE_ASSEGNATO,T.ID_UTENTE_ASSEGNATO_PT),     --MOD
                         T.COD_MATRICOLA_ASSEGNATA_PT =
                                                  decode(P_TEAM,'B',S.cod_matricola_assegnata,T.cod_matricola_assegnata_pt)  --MOD
               WHEN NOT MATCHED THEN
                  INSERT (t.cod_struttura_competente_dc,
                          t.cod_struttura_competente_dv,
                          t.cod_struttura_competente_rg,
                          t.cod_struttura_competente_ar,
                          t.desc_criterio_assegnazione,
                          t.cod_matricola_assegnatario,
                          t.cod_comparto_assegnatario,
                          t.cod_struttura_competente_fi,
                          T.COD_MATRICOLA_ASSEGNATA,
                          t.cod_abi_istituto,
                          t.dta_ins, t.desc_tipo_struttura,
                          t.cod_struttura_assegnatario, t.flg_attivo,
                          T.ID_UTENTE_ASSEGNATO,
                          T.ID_UTENTE_ASSEGNATO_PT,                             --MOD
                          T.COD_MATRICOLA_ASSEGNATA_PT)                         --MOD
                  VALUES (s.cod_struttura_competente_dc,
                          s.cod_struttura_competente_dv,
                          s.cod_struttura_competente_rg,
                          s.cod_struttura_competente_ar,
                          s.desc_criterio_assegnazione,
                          s.cod_matricola_assegnatario,
                          s.cod_comparto_assegnatario,
                          S.COD_STRUTTURA_COMPETENTE_FI,
                          DECODE(P_TEAM,'C',S.COD_MATRICOLA_ASSEGNATA,NULL),
                          s.cod_abi_istituto,
                          SYSDATE, s.desc_tipo_struttura,
                          S.COD_STRUTTURA_ASSEGNATARIO, '1',
                          DECODE(P_TEAM,'C',S.ID_UTENTE_ASSEGNATO,NULL),
                          DECODE(P_TEAM,'B',S.ID_UTENTE_ASSEGNATO,NULL),
                          DECODE(P_TEAM,'B',S.COD_MATRICOLA_ASSEGNATA,NULL)
                          );
         END LOOP;
      END IF;
---------------------------DR---------------------------
IF (p_desc_criterio_assegnazione = 'PR')
      THEN
         FOR v_rec IN (SELECT cod_struttura_competente
                         FROM t_mcre0_app_struttura_org
                        WHERE cod_str_org_sup = p_cod_struttura_competente
                          AND cod_abi_istituto = p_cod_abi_istituto)
         LOOP
            MERGE INTO t_mcre0_app_associa_gestori_uo t
               USING (SELECT p_cod_struttura_competente_dc
                                              AS cod_struttura_competente_dc,
                             p_cod_struttura_competente_dv
                                              AS cod_struttura_competente_dv,
                             p_cod_struttura_competente_rg
                                              AS cod_struttura_competente_rg,
                             p_cod_struttura_competente
                                              AS cod_struttura_competente_ar,
                             p_desc_criterio_assegnazione
                                               AS desc_criterio_assegnazione,
                             p_cod_matricola_assegnatario
                                               AS cod_matricola_assegnatario,
                             p_cod_comparto_assegnatario
                                                AS cod_comparto_assegnatario,
                             v_rec.cod_struttura_competente
                                              AS cod_struttura_competente_fi,
                             DECODE
                                (p_cod_matricola_assegnata,
                                 'D', NULL,
                                 P_COD_MATRICOLA_ASSEGNATA
                                )             AS COD_MATRICOLA_ASSEGNATA,
                             p_cod_abi_istituto
                                              AS cod_abi_istituto,
                             v_desc_tipo_struttura
                                              AS desc_tipo_struttura,
                             v_cod_struttura_assegnatario
                                               AS COD_STRUTTURA_ASSEGNATARIO,
                             '1'               AS flg_attivo,
                             V_ID_UTENTE_ASSEGNATO
                                               AS id_utente_assegnato,
                             p_cod_processo    AS cod_processo
                        FROM DUAL) s
               ON (t.cod_struttura_competente_fi =
                                                s.cod_struttura_competente_fi
               AND t.cod_abi_istituto = s.cod_abi_istituto
               AND t.desc_criterio_assegnazione = s.desc_criterio_assegnazione)
               WHEN MATCHED THEN
                  UPDATE
                     SET t.cod_struttura_competente_dc =
                                                 s.cod_struttura_competente_dc,
                         t.cod_struttura_competente_dv =
                                                 s.cod_struttura_competente_dv,
                         t.cod_struttura_competente_rg =
                                                 s.cod_struttura_competente_rg,
                         t.cod_struttura_competente_ar =
                                                 s.cod_struttura_competente_ar,
                         T.COD_MATRICOLA_ASSEGNATA =
                                                  decode(P_TEAM,'B',S.cod_matricola_assegnata,T.cod_matricola_assegnata),  --MOD
                         t.cod_matricola_assegnatario =
                                                  s.cod_matricola_assegnatario,
                         t.cod_comparto_assegnatario =
                                                   s.cod_comparto_assegnatario,
                         t.dta_upd = SYSDATE,
                         t.desc_tipo_struttura = s.desc_tipo_struttura,
                         t.cod_struttura_assegnatario =
                                                  s.cod_struttura_assegnatario,
                         T.FLG_ATTIVO =
                                                  S.FLG_ATTIVO,
                         T.ID_UTENTE_ASSEGNATO =
                                                  DECODE(P_TEAM,'C',S.ID_UTENTE_ASSEGNATO,T.ID_UTENTE_ASSEGNATO),          --MOD
                         T.ID_UTENTE_ASSEGNATO_PT =
                                                  DECODE(P_TEAM,'B',S.ID_UTENTE_ASSEGNATO,T.ID_UTENTE_ASSEGNATO_PT),     --MOD
                         T.COD_MATRICOLA_ASSEGNATA_PT =
                                                  decode(P_TEAM,'B',S.cod_matricola_assegnata,T.cod_matricola_assegnata_pt),  --MOD
                         T.COD_PROCESSO = s.cod_processo
               WHEN NOT MATCHED THEN
                  INSERT (t.cod_struttura_competente_dc,
                          t.cod_struttura_competente_dv,
                          t.cod_struttura_competente_rg,
                          t.cod_struttura_competente_ar,
                          t.desc_criterio_assegnazione,
                          t.cod_matricola_assegnatario,
                          t.cod_comparto_assegnatario,
                          t.cod_struttura_competente_fi,
                          T.COD_MATRICOLA_ASSEGNATA,
                          t.cod_abi_istituto,
                          t.dta_ins, t.desc_tipo_struttura,
                          t.cod_struttura_assegnatario, t.flg_attivo,
                          T.ID_UTENTE_ASSEGNATO,
                          T.ID_UTENTE_ASSEGNATO_PT,                             --MOD
                          T.COD_MATRICOLA_ASSEGNATA_PT,                         --MOD
                          T.COD_PROCESSO)
                  VALUES (s.cod_struttura_competente_dc,
                          s.cod_struttura_competente_dv,
                          s.cod_struttura_competente_rg,
                          s.cod_struttura_competente_ar,
                          s.desc_criterio_assegnazione,
                          s.cod_matricola_assegnatario,
                          s.cod_comparto_assegnatario,
                          S.COD_STRUTTURA_COMPETENTE_FI,
                          DECODE(P_TEAM,'C',S.COD_MATRICOLA_ASSEGNATA,NULL),
                          s.cod_abi_istituto,
                          SYSDATE, s.desc_tipo_struttura,
                          S.COD_STRUTTURA_ASSEGNATARIO, '1',
                          DECODE(P_TEAM,'C',S.ID_UTENTE_ASSEGNATO,NULL),
                          DECODE(P_TEAM,'B',S.ID_UTENTE_ASSEGNATO,NULL),
                          DECODE(P_TEAM,'B',S.COD_MATRICOLA_ASSEGNATA,NULL),
                          S.COD_PROCESSO
                          );
         END LOOP;
      END IF;
---------------------------
      pkg_mcrei_audit.log_app (   pkg_mcrei_web_util_delib.c_package
                               || '.'
                               || p_nome_fun,
                               3,
                               SQLCODE,
                               SQLERRM,
                               p_note || ' ' || p_param,
                               NULL
                              );
      RETURN const_esito_ok;
   EXCEPTION
      WHEN OTHERS
      THEN
         pkg_mcrei_audit.log_app (   pkg_mcrei_web_util_delib.c_package
                                  || '.'
                                  || p_nome_fun,
                                  3,
                                  SQLCODE,
                                  SQLERRM,
                                  p_note || ' ' || p_param,
                                  NULL
                                 );
         RETURN CONST_ESITO_KO;
   END assegnazione_gestori;

  FUNCTION SET_CONFERMA_HOST(
  P_COD_PROTOCOLLO_PACCHETTO IN T_MCREI_APP_DELIBERE.COD_PROTOCOLLO_PACCHETTO%TYPE,
  P_COD_PROTOCOLLO_DELIBERA  IN  T_MCREI_APP_DELIBERE.COD_PROTOCOLLO_DELIBERA %TYPE,
  P_COD_ABI IN  T_MCREI_APP_DELIBERE.COD_ABI%TYPE,
  P_COD_NDG IN  T_MCREI_APP_DELIBERE.COD_NDG%TYPE,
  P_COD_SNDG IN  T_MCREI_APP_DELIBERE.COD_SNDG%TYPE
) RETURN NUMBER IS
    p_note t_mcrei_wrk_audit_applicativo.note%TYPE;
    c_nome CONSTANT VARCHAR2 (100) := c_package || '.SET_CONFERMA_HOST';
    p_nome_fun VARCHAR2 (50) := 'SET_CONFERMA_HOST';
    p_param VARCHAR2 (1000):='P_COD_PROTOCOLLO_PACCHETTO = '||P_COD_PROTOCOLLO_PACCHETTO||
    'P_COD_PROTOCOLLO_DELIBERA = '||P_COD_PROTOCOLLO_DELIBERA||
    'P_COD_ABI = '||P_COD_ABI||
    'P_COD_NDG = '||P_COD_NDG||
    'P_COD_SNDG = '||P_COD_SNDG;
  BEGIN

      IF    P_COD_PROTOCOLLO_DELIBERA IS NULL
         OR P_COD_ABI IS NULL
         OR P_COD_NDG IS NULL
      THEN
         raise_application_error (-20666, 'Null parameter');
      END IF;

    UPDATE T_MCREI_APP_DELIBERE
       SET FLG_CONFERMA_HOST = 'Y',
       --v1.9 dta_conferma
       DTA_CONFERMA_HOST = SYSDATE
    WHERE COD_ABI = P_COD_ABI
      AND COD_NDG = P_COD_NDG
      AND COD_PROTOCOLLO_DELIBERA = P_COD_PROTOCOLLO_DELIBERA;
  RETURN const_esito_ok;
   EXCEPTION
      WHEN OTHERS
      THEN
         pkg_mcrei_audit.log_app (   pkg_mcrei_web_util_delib.c_package
                                  || '.'
                                  || p_nome_fun,
                                  3,
                                  SQLCODE,
                                  SQLERRM,
                                  p_note || ' ' || p_param,
                                  NULL
                                 );
  RETURN const_esito_ko;

  END SET_CONFERMA_HOST;

FUNCTION POPOLA_RAPPORTI_IN_ESSERE(
  P_COD_PROTOCOLLO_PACCHETTO IN T_MCREI_APP_DELIBERE.COD_PROTOCOLLO_PACCHETTO%TYPE,
  p_flg_report IN varchar2 default 'N'
) RETURN NUMBER is

    p_note t_mcrei_wrk_audit_applicativo.note%TYPE;
    c_nome CONSTANT VARCHAR2 (100) := c_package || '.POPOLA_RAPPORTI_ESTERO';
    v_ricalcolo varchar2(1) := 'N';
  BEGIN

    if p_flg_report = 'Y' then
    select decode (count(*),0,'Y','N')
    into v_ricalcolo
    from T_MCREI_APP_RAPPORTI_IN_ESSERE
    where cod_protocollo_pacchetto = P_COD_PROTOCOLLO_PACCHETTO;

    end if;

    if (p_flg_report = 'N' or (p_flg_report = 'Y' and v_ricalcolo = 'Y') ) then
    delete T_MCREI_APP_RAPPORTI_IN_ESSERE
    where cod_protocollo_pacchetto = P_COD_PROTOCOLLO_PACCHETTO;

    insert into T_MCREI_APP_RAPPORTI_IN_ESSERE (ID_DPER, DTA_INZ_VLD, COD_ABI, COD_NDG, COD_SNDG,
    COD_FORMA_TECNICA_FIDO, COD_RAPPORTO_UTIL, NUM_FIDO, COD_ABI_FIL_OP, COD_FORMA_TECNICA,
    DTA_FINE_VALIDITA, VAL_ACCORDATO_DELIB, VAL_IMP_UTILIZZATO, COD_RAPPORTO_ATTR, FLG_ATTIVA,
    DTA_INS, DTA_UPD, COD_CLASSE_FT, COD_RAPPORTO, COD_STATO, VAL_MAU, COD_PROTOCOLLO_PACCHETTO)
    select distinct
      p.ID_DPER                  ,
      p.DTA_INZ_VLD              ,
      p.COD_ABI                  ,
      p.COD_NDG                  ,
      p.COD_SNDG                 ,
      p.COD_FORMA_TECNICA_FIDO   ,
      p.COD_RAPPORTO_UTIL        ,
      p.NUM_FIDO                 ,
      p.COD_ABI_FIL_OP           ,
      p.COD_FORMA_TECNICA        ,
      p.DTA_FINE_VALIDITA        ,
      p.VAL_ACCORDATO_DELIB      ,
      p.VAL_IMP_UTILIZZATO       ,
      p.COD_RAPPORTO_ATTR        ,
      p.FLG_ATTIVA               ,
      SYSDATE                    ,
      NULL                       ,
      p.COD_CLASSE_FT            ,
      p.COD_RAPPORTO             ,
      a.cod_stato                ,
      a.GB_VAL_MAU               ,
      d.cod_protocollo_pacchetto
    from t_mcrei_app_pcr_rapporti p,
    t_mcrei_app_delibere d, T_MCRE0_APP_ALL_DATA a
    where d.cod_abi = p.cod_abi
    and d.cod_ndg = p.cod_ndg
    and d.cod_abi = a.cod_abi_cartolarizzato
    and d.cod_ndg = a.cod_ndg
    and d.cod_protocollo_pacchetto = P_COD_PROTOCOLLO_PACCHETTO
    and d.flg_no_delibera = '0'
    and d.flg_attiva = '1'
    and d.cod_fase_delibera != 'AN'
    ;

  pkg_mcrei_audit.log_app (c_nome, 3, SQLCODE, 'flg_report '||p_flg_report ||' ricalcolo '||v_ricalcolo,
                  'congelati rapporti su pacchetto '||P_COD_PROTOCOLLO_PACCHETTO, NULL);

    end if;

  RETURN const_esito_ok;
   EXCEPTION
      WHEN OTHERS
      THEN
         pkg_mcrei_audit.log_app (   c_nome, 1, SQLCODE, SQLERRM,
                                  'errore congelamento rapporti su congela pacchetto '||P_COD_PROTOCOLLO_PACCHETTO||' flg_report '||p_flg_report ||' ricalcolo '||v_ricalcolo,
                                  NULL
                                 );
  RETURN const_esito_ko;

  END POPOLA_RAPPORTI_IN_ESSERE;

--FUNZIONE DI SALVATAGGIO ED INIZIALIZZAZIONE NUOVO RECORD
-- %return 1 -> se l'insert e' andata a buon fine, 0 altrimenti
FUNCTION FNC_INSERT_RWA_PACCHETTO
    (P_COD_PROTOCOLLO_PACCHETTO    IN T_MCREI_RWA_PACCHETTO.COD_PROTOCOLLO_PACCHETTO%TYPE,
     P_COD_BS                    IN T_MCREI_RWA_PACCHETTO.COD_BS%TYPE,
     P_TICKET_ID                IN T_MCREI_RWA_PACCHETTO.TICKET_ID%TYPE,
     P_RWA_TICKET_ID            IN T_MCREI_RWA_PACCHETTO.RWA_TICKET_ID%TYPE,
     P_COD_MATRICOLA            IN T_MCRE0_WRK_AUDIT_APPLICATIVO.UTENTE%TYPE default null)
RETURN NUMBER IS
    V_NOTE                        T_MCRE0_WRK_AUDIT_APPLICATIVO.NOTE%TYPE;
    V_PROC                        T_MCRE0_WRK_AUDIT_APPLICATIVO.PROCEDURA%TYPE := PKG_MCREI_WEB_UTIL_DELIB.C_PACKAGE||'.FNC_INSERT_RWA_PACCHETTO';
    V_SEQ                        NUMBER;
    V_COUNT                        NUMBER;

    BEGIN
        V_NOTE := 'P_COD_PROTOCOLLO_PACCHETTO = ' || P_COD_PROTOCOLLO_PACCHETTO ||
                  ', P_COD_BS = ' || P_COD_BS ||
                  ', P_TICKET_ID = ' || P_TICKET_ID ||
                  ', P_COD_MATRICOLA = ' || P_COD_MATRICOLA ||
                  ', P_RWA_TICKET_ID = ' || P_RWA_TICKET_ID || CHR(10);

        SELECT SEQ_MCR0_LOG_APP.NEXTVAL
        INTO V_SEQ
        FROM DUAL;

        SELECT COUNT(*)
        INTO V_COUNT
        FROM T_MCREI_RWA_PACCHETTO
        WHERE COD_PROTOCOLLO_PACCHETTO = P_COD_PROTOCOLLO_PACCHETTO
        AND COD_BS = P_COD_BS;

        IF V_COUNT = 1
        THEN

            UPDATE T_MCREI_RWA_PACCHETTO
            SET FLG_VALIDITA = '1',
                   DTA_UPD = SYSDATE,
                  TICKET_ID = P_TICKET_ID,
                  RWA_TICKET_ID = P_RWA_TICKET_ID
            WHERE COD_PROTOCOLLO_PACCHETTO = P_COD_PROTOCOLLO_PACCHETTO
            AND COD_BS = P_COD_BS;

        else

            INSERT INTO T_MCREI_RWA_PACCHETTO
                (COD_PROTOCOLLO_PACCHETTO, COD_BS, TICKET_ID, RWA_TICKET_ID, FLG_VALIDITA, DTA_INS, DTA_UPD)
            VALUES
                (P_COD_PROTOCOLLO_PACCHETTO, P_COD_BS, P_TICKET_ID, P_RWA_TICKET_ID, '1', SYSDATE, NULL);

        END IF;

        PKG_MCREI_AUDIT.LOG_APP(V_SEQ, V_PROC, 3, SQLCODE, SQLERRM, V_NOTE, P_COD_MATRICOLA);

        RETURN const_esito_ok;

        EXCEPTION
            WHEN OTHERS
            THEN PKG_MCRE0_AUDIT.LOG_APP(V_SEQ, V_PROC, 1, SQLCODE, SQLERRM, V_NOTE, P_COD_MATRICOLA);
            RETURN const_esito_ko;

END FNC_INSERT_RWA_PACCHETTO;

--FUNZIONE DI AGGIORNAMENTO DEL FLG_VALIDITA
-- %return 1 -> se l'update e' andata a buon fine, 0 altrimenti
FUNCTION FNC_UPD_VALIDITA_RWA_PACCHETTO
    (P_COD_PROTOCOLLO_PACCHETTO    IN T_MCREI_RWA_PACCHETTO.COD_PROTOCOLLO_PACCHETTO%TYPE,
     P_COD_BS                    IN T_MCREI_RWA_PACCHETTO.COD_BS%TYPE,
     P_FLG_VALIDITA                IN T_MCREI_RWA_PACCHETTO.FLG_VALIDITA%TYPE,
     P_COD_MATRICOLA            IN T_MCRE0_WRK_AUDIT_APPLICATIVO.UTENTE%TYPE default null)
RETURN NUMBER IS
    V_NOTE                        T_MCRE0_WRK_AUDIT_APPLICATIVO.NOTE%TYPE;
    V_PROC                        T_MCRE0_WRK_AUDIT_APPLICATIVO.PROCEDURA%TYPE := PKG_MCREI_WEB_UTIL_DELIB.C_PACKAGE||'.FNC_UPD_VALIDITA_RWA_PACCHETTO';
    V_SEQ                        NUMBER;
    V_COUNT                        NUMBER;

    BEGIN
        V_NOTE := 'P_COD_PROTOCOLLO_PACCHETTO = ' || P_COD_PROTOCOLLO_PACCHETTO ||
                  ', P_COD_BS = ' || P_COD_BS ||
                  ', P_FLG_VALIDITA = ' || P_FLG_VALIDITA ||
                  ', P_COD_MATRICOLA = ' || P_COD_MATRICOLA || CHR(10);

        SELECT SEQ_MCR0_LOG_APP.NEXTVAL
        INTO V_SEQ
        FROM DUAL;

        UPDATE T_MCREI_RWA_PACCHETTO
        SET FLG_VALIDITA = P_FLG_VALIDITA,
            DTA_UPD = SYSDATE
        WHERE COD_PROTOCOLLO_PACCHETTO = P_COD_PROTOCOLLO_PACCHETTO
        AND COD_BS = P_COD_BS;

        PKG_MCREI_AUDIT.LOG_APP(V_SEQ, V_PROC, 3, SQLCODE, SQLERRM, V_NOTE, P_COD_MATRICOLA);

        RETURN const_esito_ok;

        EXCEPTION
            WHEN OTHERS
            THEN PKG_MCREI_AUDIT.LOG_APP(V_SEQ, V_PROC, 1, SQLCODE, SQLERRM, V_NOTE, P_COD_MATRICOLA);
            RETURN const_esito_ko;

END FNC_UPD_VALIDITA_RWA_PACCHETTO;


   FUNCTION check_pos_scadute (
      codprotocollopacchetto IN t_mcrei_app_delibere.cod_protocollo_pacchetto%TYPE,
      codmicrotipologia IN t_mcrei_app_delibere.cod_microtipologia_delib%TYPE
   )
      RETURN NUMBER is

   v_scadenza date := sysdate -1; --inizializzo come Scaduto?!
   v_gestore varchar2(12) := null;

   begin

   begin
   --recupero la minima data scadenza proroga delle posizioni della microtipologia richieste
   --per vedere se almeno una è già scaduta
    select nvl(min(s.dta_scadenza_proroga), sysdate+180), max(COD_MATRICOLA_INSERENTE)
    into v_scadenza, v_gestore
    FROM T_MCREI_APP_DELIBERE D, V_MCRE0_APP_SCHEDA_ANAG S
    WHERE COD_TIPO_PACCHETTO = 'M' AND FLG_ATTIVA = '1'
    -- and flg_no_delibera = 0
    and cod_fase_delibera != 'AN'
    and cod_microtipologia_delib = codmicrotipologia
    and cod_protocollo_pacchetto = codprotocollopacchetto
    and d.cod_abi = s.cod_abi_cartolarizzato
    AND D.COD_NDG = S.COD_NDG
    and s.cod_stato in ('IN','RS');
   exception when no_data_found then
     return 1;--ok
    when others then
    PKG_MCREI_AUDIT.LOG_APP(c_package||'.check_pos_scadute', 1, SQLCODE, SQLERRM, 'errore controllo su pacchetto '||codprotocollopacchetto
        ||' microtipologia '||codmicrotipologia, v_gestore);
    return -1;--errore

   end;

   if v_scadenza >= sysdate then return 1;--ok
   else return 0; --ko
   end if;

   end check_pos_scadute;

   FUNCTION check_pos_scadute_pacchetto (
      codprotocollopacchetto IN t_mcrei_app_delibere.cod_protocollo_pacchetto%TYPE
   )
      RETURN NUMBER is

   v_scadenza date := sysdate -1; --inizializzo come Scaduto?!
   v_gestore varchar2(12) := null;
   v_esito number;

   begin

   begin
   --recupero la minima data scadenza proroga delle posizioni della microtipologia richieste
   --per vedere se almeno una è già scaduta
    select nvl(min(s.dta_scadenza_proroga), sysdate+180), max(COD_MATRICOLA_INSERENTE)
    into v_scadenza, v_gestore
    from t_mcrei_app_delibere d, v_mcre0_app_scheda_anag s
    WHERE COD_TIPO_PACCHETTO = 'M' AND FLG_ATTIVA = '1'
    --and flg_no_delibera = 0
    and cod_microtipologia_delib not in ('CI', 'CS', 'CZ', 'CH', 'CX', 'B8', 'PR', 'PS', 'PU')--('CI', 'CS', 'CZ', 'CH', 'CX', 'B8', 'PR', 'PT', 'PD')
    and cod_fase_delibera != 'AN'
    and cod_protocollo_pacchetto = codprotocollopacchetto
    AND D.COD_ABI = S.COD_ABI_CARTOLARIZZATO
    AND D.COD_NDG = S.COD_NDG
    and s.cod_stato in ('IN','RS');
   exception when no_data_found then
     return 1;--ok
   when others then
    PKG_MCREI_AUDIT.LOG_APP(c_package||'.check_pos_scadute', 1, SQLCODE, SQLERRM, 'errore controllo su pacchetto '
    ||codprotocollopacchetto, v_gestore);

    return -1;--errore

   end;

   if v_scadenza >= sysdate then return 1;--ok
   else
   begin
   select min (
        (case when exists
            (select * from t_mcrei_app_delibere dd
             where cod_tipo_pacchetto = 'M' and flg_attiva = '1'
             --and flg_no_delibera = 0
            AND S.COD_STATO IN ('IN','RS')
            and cod_microtipologia_delib in ('PR', 'PS', 'PU') --('PR', 'PT', 'PD')
            and cod_fase_delibera != 'AN'
            and cod_protocollo_pacchetto = codprotocollopacchetto
            and dd.cod_abi = d.cod_abi
            and dd.cod_ndg = d.cod_ndg) then 1 else 0 end) ) esito
    into v_esito
    from t_mcrei_app_delibere d, v_mcre0_app_scheda_anag s
    WHERE COD_TIPO_PACCHETTO = 'M' AND FLG_ATTIVA = '1'
    --and flg_no_delibera = 0
    AND S.COD_STATO IN ('IN','RS')
    and cod_microtipologia_delib not in ('CI', 'CS', 'CZ', 'CH', 'CX', 'B8', 'PR', 'PS', 'PU')--('CI', 'CS', 'CZ', 'CH', 'CX', 'B8', 'PR', 'PT', 'PD')
    and cod_fase_delibera != 'AN'
    and cod_protocollo_pacchetto = codprotocollopacchetto
    and d.cod_abi = s.cod_abi_cartolarizzato
    and d.cod_ndg = s.cod_ndg
    and s.dta_scadenza_proroga < trunc(sysdate);

    exception when others then
    PKG_MCREI_AUDIT.LOG_APP(c_package||'.check_pos_scadute_pacchetto', 1, SQLCODE, SQLERRM, 'errore controllo su pacchetto '
    ||codprotocollopacchetto, v_gestore);

    return -1;--errore
    end;

   return v_esito;

   end if;

   end check_pos_scadute_pacchetto;


PROCEDURE POPOLA_NOTE_DELIBERE(
                            P_COD_ABI IN T_MCREI_APP_DELIBERE.COD_ABI%TYPE ,
                            P_COD_NDG IN T_MCREI_APP_DELIBERE.COD_NDG%TYPE ,
                            P_PROTO_DELIBERA IN T_MCREI_APP_DELIBERE.COD_PROTOCOLLO_DELIBERA%TYPE ,
                            P_PROTO_PACCHETTO IN T_MCREI_APP_DELIBERE.COD_PROTOCOLLO_PACCHETTO%TYPE ,
                            P_NOTE_DEL IN T_MCREI_APP_DELIBERE.DESC_NOTE%TYPE DEFAULT NULL,
                             out_esito IN OUT NUMBER
                            )
AS

  C_NOME CONSTANT VARCHAR2 (100)
                                 := c_package || '.POPOLA_NOTE_DELIBERE';

BEGIN


  IF   P_COD_ABI IS NULL OR
       P_COD_NDG IS NULL OR
       p_proto_delibera IS NULL OR
       p_proto_pacchetto IS NULL
    THEN
      out_esito := const_esito_ko;
      RAISE_APPLICATION_ERROR(-20666, 'Null parameter');
  END IF;


UPDATE T_MCREI_APP_DELIBERE A SET DESC_NOTE= P_NOTE_DEL
                                              WHERE A.COD_ABI = P_COD_ABI
                                              AND A.COD_NDG = P_COD_NDG
                                              AND A.COD_PROTOCOLLO_DELIBERA = P_PROTO_DELIBERA
                                              AND A.COD_PROTOCOLLO_PACCHETTO = P_PROTO_PACCHETTO
                                              ;
     out_esito := const_esito_ok;
   EXCEPTION
      WHEN OTHERS
      THEN
         pkg_mcrei_audit.log_app (c_nome,
                                  3,
                                  SQLCODE,
                                  SQLERRM,
                                     'abi: '
                                  || p_cod_abi
                                  || ' ndg: '
                                  || p_cod_ndg
                                  || ' cod_prot_delibera: '
                                  || p_proto_delibera
                                  || ' cod_prot_pacchetto: '
                                  || P_PROTO_PACCHETTO
                                  || ' note: '
                                  || P_NOTE_DEL,
                                  NULL
                                 );

END POPOLA_NOTE_DELIBERE;


FUNCTION POPOLA_ALLEGATI_DELIBERA(
                                  P_COD_PROTOCOLLO_PACCHETTO IN  T_MCREI_APP_ALLEGATI_DELIBERA.COD_PROTOCOLLO_PACCHETTO%TYPE,
                                  P_COD_DOCUMENTO IN T_MCREI_APP_ALLEGATI_DELIBERA.COD_DOCUMENTO%TYPE,
                                  P_DTA_UPD IN T_MCREI_APP_ALLEGATI_DELIBERA.DTA_UPD%TYPE
                                ) RETURN NUMBER  IS
   BEGIN

   IF  P_COD_PROTOCOLLO_PACCHETTO IS NULL OR
       P_COD_DOCUMENTO IS NULL
    THEN
      RAISE_APPLICATION_ERROR(-20666, 'Null parameter');
      return const_esito_ko;
  END IF;

   INSERT INTO T_MCREI_APP_ALLEGATI_DELIBERA
                (COD_PROTOCOLLO_PACCHETTO,COD_DOCUMENTO,DTA_UPD)
    VALUES
          (P_COD_PROTOCOLLO_PACCHETTO,P_COD_DOCUMENTO,P_DTA_UPD);

   RETURN CONST_ESITO_OK;

   EXCEPTION
      WHEN OTHERS
      THEN
      return const_esito_ko;
         pkg_mcrei_audit.log_app ('POPOLA_ALLEGATI_DELIBERA',
                                  3,
                                  SQLCODE,
                                  SQLERRM,
                                     'COD_PROTOCOLLO_PACCHETTO: '
                                  || p_COD_PROTOCOLLO_PACCHETTO
                                  || 'COD_DOCUMENTO: '
                                  || P_COD_DOCUMENTO
                                  || ' DTA_UPD: '
                                  || P_DTA_UPD,
                                  NULL
                                 );

   END POPOLA_ALLEGATI_DELIBERA;


FUNCTION DELETE_ALLEGATI_DELIBERA(
                                  P_COD_PROTOCOLLO_PACCHETTO IN  T_MCREI_APP_ALLEGATI_DELIBERA.COD_PROTOCOLLO_PACCHETTO%TYPE
                                  ) RETURN NUMBER  IS
   BEGIN

   IF  P_COD_PROTOCOLLO_PACCHETTO IS NULL
    THEN
      RAISE_APPLICATION_ERROR(-20666, 'Null parameter');
      return const_esito_ko;
  END IF;

   DELETE FROM T_MCREI_APP_ALLEGATI_DELIBERA
    where COD_PROTOCOLLO_PACCHETTO = P_COD_PROTOCOLLO_PACCHETTO;


   RETURN CONST_ESITO_OK;

   EXCEPTION
      WHEN OTHERS
      THEN
      return const_esito_ko;
         pkg_mcrei_audit.log_app ('DELETE_ALLEGATI_DELIBERA',
                                  3,
                                  SQLCODE,
                                  SQLERRM,
                                     'COD_PROTOCOLLO_PACCHETTO: '
                                  || p_COD_PROTOCOLLO_PACCHETTO,
                                  NULL
                                 );

   END DELETE_ALLEGATI_DELIBERA;




FUNCTION TRASFERISCI_PACCHETTO(
                                  P_COD_PROTOCOLLO_PACCHETTO IN  T_MCREI_APP_ALLEGATI_DELIBERA.COD_PROTOCOLLO_PACCHETTO%TYPE
                                  ) RETURN NUMBER  IS
   BEGIN

   IF  P_COD_PROTOCOLLO_PACCHETTO IS NULL
    THEN
      RAISE_APPLICATION_ERROR(-20666, 'Null parameter');
      return const_esito_ko;
  END IF;

UPDATE T_MCREI_APP_DELIBERE
SET FLG_PACCHETTO_TRASFERITO='Y',
DTA_TRASF_PACCHETTO=TRUNC(SYSDATE)
WHERE COD_PROTOCOLLO_PACCHETTO=P_COD_PROTOCOLLO_PACCHETTO;

   RETURN CONST_ESITO_OK;

   EXCEPTION
      WHEN OTHERS
      THEN
      return const_esito_ko;
         pkg_mcrei_audit.log_app ('DELETE_ALLEGATI_DELIBERA',
                                  3,
                                  SQLCODE,
                                  SQLERRM,
                                     'COD_PROTOCOLLO_PACCHETTO: '
                                  || p_COD_PROTOCOLLO_PACCHETTO,
                                  NULL
                                 );

   END TRASFERISCI_PACCHETTO;




END pkg_mcrei_web_util_delib;
/


CREATE SYNONYM MCRE_APP.PKG_MCREI_WEB_UTIL_DELIB FOR MCRE_OWN.PKG_MCREI_WEB_UTIL_DELIB;


CREATE SYNONYM MCRE_USR.PKG_MCREI_WEB_UTIL_DELIB FOR MCRE_OWN.PKG_MCREI_WEB_UTIL_DELIB;


GRANT EXECUTE, DEBUG ON MCRE_OWN.PKG_MCREI_WEB_UTIL_DELIB TO MCRE_USR;

