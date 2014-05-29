CREATE OR REPLACE PACKAGE BODY MCRE_OWN.PKG_MCREI_GEST_DELIBERE AS
  /******************************************************************************
   NAME:       PKG_MCREI_GEST_DELIBERE
   PURPOSE:

   REVISIONS:
   Ver        Date              Author             Description
   ---------  ----------      -----------------  ------------------------------------
   1.0      13/01/2012            L.Ferretti      Created this package.
   1.1      20/01/2012            M.Murro         variazioni varie.
   1.2      16/02/2012            M.Murro         fix ordinale delibera
   1.3      20/02/2012            M.Murro         modificato ordinale delibera
   1.4      02/04/2012            Gueorguieva     aggiunte funzioni di recupero dei valori per il calcolo OD
   1.5      13/04/2012            D'ERRICO        aggiunta funct per recupero stralcio contabilizzato
   1.6      05/06/2012            d'errico        gestione automatica viene generalizzata su tutte le proposte
   1.7      12/07/2012            d'errico        aggiunto no_Data_found per get_last_rinuncia
   1.8      18/07/2012            d'errico        gestita assenza uo nella creazione del protocollo delibera. restituisce -1
   1.9      26/07/2012            d'errico        creazione funzione rdv_light abilitata
   2.0      31/07/2012            d'errico        corretto popolamento dta_last_upd_delibera nella gest_classif_autom
   2.1      31/08/2012            d'errico        popolato anche campo dta_delibera in fase di creazione CI
   2.2      26/09/2012            M.Murro         fix controllo rdv_light_abilitata
   2.3      12/10/2012            d'errico        modificato commento in gestione  exception per rdv_abilitata
   2.4      08/11/2012            Gueorguieva     eliminata filtro fase delibera CM da fnc_mcrei_get_max_rdv e
                                                  fnc_mcrei_get_max_rdv_in
   2.5      09/11/2012            d'errico        tolto filtro su fase_Delibera = 'CO'
   3.0      12/11/2012            pellizzi        update cod_fase delibera e cod_fase_microtipologia
   3.1      13/12/2012            M.Murro         fix scarta_proposta, insert di abi-ndg-sndg
   3.2      7/01/2013             D'ERRICO        modificata sovrascrivi_proposta e inserita distinct su controllo fase_pacchetto nella gest_classif_autom
                                                                 aggiunto flg_no_delibera = 0 e cod_Fase_Delibera !='AN' NELLA CTRL_ESIST_PACC_APERTO
   3.3      29/01/2013            i.gueorguieva   aggiunta T_MCRE0_APP_ALL_DATA IN JOIN NELLA QUERY DI CREA_PACCEHTTO_CLASSIF_AUTO
   3.4      29/01/2013            i.gueorguieva   aggiunta T_MCRE0_APP_ALL_DATA IN JOIN NELLA QUERY DI CREA_PACCEHTTO_CLASSIF_AUTO   PER ESTRAZIONE STATO E DECORRENZA STATO
   3.5      14/02/2013            D'ERRICO        CORRETTA fnc_gest_classif_autom per gestione annullamento pacchetti in attesa di conferma da banca rete in caso di arrivo di un incaglio automatico
   3.6      04/03/2013            M.Murro         Modifica gestione conferma di proposte automatiche
   3.7      20/03/2013            D'ERRICO        RIVISTA GESTIONE INCAGLI AUTOMATICI NELLA GEST_CLASSIF_AUTOM IN CASO SIA PRESENTE CI in fase (CA,CO) in un pacchetto gi? confermato
                                                  corretta sovrascrivi_proposta_esistente ,ponendo fase_Delibera= 'CA' e lasciando le altre fasi cos? com'erano gi? sulla tabella delibere
   3.8      07/05/2013           I.Gueorguieva    Fix prima update fnc_gest_classif_autom
   3.9      20/05/2013           IM.Murro         nuova Fix prima update fnc_gest_classif_autom
    ******************************************************************************/

  -- %author Reply
  -- %version 0.1
  -- %usage  Function che genera il num_progr_delibera che serve a dare un ordine sequenziale alla generazione delle delibere
  -- %d La function Genera il numero successivo al VAL_NUM_PROGR_DELIBERA per la pratica passata come parametro.
  -- %cd 13/01/2012
  FUNCTION fnc_mcrei_ordinale_delibera(pratica   IN VARCHAR2,
                                       anno      IN NUMBER,
                                       utente    IN VARCHAR2 DEFAULT NULL,
                                       pacchetto IN VARCHAR2) RETURN NUMBER IS
    c_nome      VARCHAR2(50) := 'FNC_MCREI_ORDINALE_DELIBERA';
    ko          NUMBER := -1;
    progressivo NUMBER := 0;
  BEGIN
    SELECT mcre_own.seq_mcrei_beni.nextval INTO progressivo FROM dual;

    pkg_mcrei_audit.log_app(c_package || c_nome,
                            pkg_mcrei_audit.c_debug,
                            SQLCODE,
                            'progressivo: ' || progressivo,
                            'PRATICA= ' || pratica || 'anno= ' || anno ||
                            ' pacchetto= ' || pacchetto,
                            utente);
    RETURN progressivo;
  EXCEPTION
    WHEN OTHERS THEN
      pkg_mcrei_audit.log_app(c_package || c_nome,
                              pkg_mcrei_audit.c_error,
                              SQLCODE,
                              'raise -20666',
                              'PRATICA= ' || pratica || 'anno= ' || anno ||
                              ' pacchetto= ' || pacchetto,
                              utente);
      raise_application_error(-20666, 'Null parameter');
      RETURN ko;
  END fnc_mcrei_ordinale_delibera;

  -- %author Reply
  -- %version 0.1
  -- %usage  Function che genera il protocollo delibera per Incagli e Sofferenze.
  -- %d La function S basata sulla seguente regola di calcolo del protocollo:
  -- %d un progressivo, a partire da 90000000, si incrementa per ANNO_PRATICA e COD_UO_PRATICA. Ogni anno per ogni COD_UO_PRATICA si resetta.
  -- %d COD_PROTOCOLLO_DELIBERA S cos? strutturato: progressivo(9 caratteri), anno (4 caratteri) e delibera (5 caratteri).
  -- %d Nella tabella T_MCREI_APP_ANAG_UO sono anagrafate le UO, per ogni UO S indicato anche l'anno e il progressivo di associato.
  -- %d T_MCREI_APP_DELIBERE
  -- %d in caso di uo_pratica nullo, determino la struttura competende della posizione (tramite abi, ndg)
  -- %cd 13/01/2012
  FUNCTION fnc_mcrei_protocollo_delibera(cod_uo IN VARCHAR2,
                                         utente IN VARCHAR2 DEFAULT NULL,
                                         p_abi  IN VARCHAR2 DEFAULT NULL,
                                         p_ndg  IN VARCHAR2 DEFAULT NULL)
    RETURN VARCHAR2 IS
    c_nome                  VARCHAR2(50) := 'FNC_MCREI_PROTOCOLLO_DELIBERA';
    ko                      VARCHAR2(6) := 'ERRORE';
    progressivo_attuale     VARCHAR(9) := '89999999';
    cod_protocollo_delibera VARCHAR2(17);
    quante_uo               NUMBER;
    anno_attuale            VARCHAR2(4);
    v_uo                    VARCHAR2(5);
  BEGIN
    v_uo := cod_uo;

    -- se uo pratica nullo, la ricavo dalla posizione stessa, se anche abi ndg nulli.. exit
    IF cod_uo IS NULL
    THEN
      IF (p_abi IS NULL AND p_ndg IS NULL)
      THEN
        pkg_mcrei_audit.log_app(c_package || c_nome,
                                pkg_mcrei_audit.c_error,
                                SQLCODE,
                                SQLERRM,
                                'parametri nulli.. raise',
                                utente);
        raise_application_error(-20666, 'Null parameter');
      ELSE
        BEGIN
          SELECT nvl(s.cod_struttura_competente, a.cod_struttura_competente)
            INTO v_uo
            FROM t_mcre0_app_all_data      a,
                 t_mcre0_app_struttura_org s
           WHERE a.cod_abi_cartolarizzato = p_abi
             AND a.cod_ndg = p_ndg
             AND a.cod_abi_cartolarizzato = s.cod_abi_istituto(+)
             AND nvl(nvl(a.cod_comparto_assegnato, a.cod_comparto_calcolato),
                     a.cod_struttura_competente) = s.cod_comparto(+);

          IF v_uo IS NULL
          THEN
            RETURN - 1;
          END IF;
        EXCEPTION
          WHEN no_data_found THEN

            RETURN - 1;
        END;
      END IF;
    END IF;

    /*
    * Per COD_UO e ANNO devo cercare nella tabella T_MCREI_APP_ANAG_UO.
    * Se esiste gi? la coppia allora prendo il progressivo e lo incremento.
    * Se la coppia esiste ma l'anno S vecchio allora riazzero il progressivo e aggiorno l'anno.
    * Se la coppia non esiste allora inserisco il cod_uo e l'anno e inizializzo anche il progressivo al valore minore previsto.
    */
    SELECT to_char(SYSDATE, 'YYYY') INTO anno_attuale FROM dual;

    SELECT COUNT(*)
      INTO quante_uo
      FROM t_mcrei_app_anag_uo
     WHERE cod_uo_pratica = v_uo;

    -- AND anno = anno_attuale;

    /*
    *  Se quante_uo = 0 allora devo inserire anche una riga nella tabella di anagrafica delle UO
    *  Altrimenti procedo all'aggiornamento. Praticamente implemento una merge
    */
    IF (quante_uo = 0)
    THEN
      INSERT INTO t_mcrei_app_anag_uo
        (cod_uo_pratica,
         anno,
         progressivo)
      VALUES
        (v_uo,
         to_char(SYSDATE, 'yyyy'),
         progressivo_attuale + 1);
    END IF;

    --  prendo, per l'anno maggiore, il progressivo massimo
    SELECT MAX(CASE
                 WHEN anno = anno_attuale THEN
                  to_char(progressivo + 1)
                 WHEN anno < anno_attuale THEN
                  '90000000'
                 ELSE
                  '99999999'
               END) progressivo
      INTO progressivo_attuale
      FROM t_mcrei_app_anag_uo
     WHERE cod_uo_pratica = v_uo
    --       AND anno = anno_attuale
     GROUP BY anno;

    UPDATE t_mcrei_app_anag_uo
       SET progressivo = progressivo_attuale,
           anno        = anno_attuale
     WHERE cod_uo_pratica = v_uo;

    cod_protocollo_delibera := progressivo_attuale || anno_attuale || v_uo;
    pkg_mcrei_audit.log_app(c_package || c_nome,
                            pkg_mcrei_audit.c_debug,
                            SQLCODE,
                            SQLERRM,
                            'cod_protocollo_delibera= ' ||
                            cod_protocollo_delibera,
                            utente);
    RETURN cod_protocollo_delibera;
  EXCEPTION
    WHEN OTHERS THEN
      pkg_mcrei_audit.log_app(c_package || c_nome,
                              pkg_mcrei_audit.c_error,
                              SQLCODE,
                              SQLERRM,
                              'COD_UO= ' || cod_uo || 'abi= ' || p_abi ||
                              ' ndg= ' || p_ndg || ' v_uo: ' || v_uo,
                              utente);
      raise_application_error(-20666, 'Null parameter');
      RETURN ko;
  END fnc_mcrei_protocollo_delibera;

  -- %author Reply
  -- %version 0.1
  -- %usage  Function che recupera il protocollo pacchetto per una delibera
  -- %d La function, per particolari microtipologie di delibera, recupera il protocollo_pacchetto
  -- %d associato alla relativa proposta di classificazione (cod_microtipologia CI o CS)
  -- %d presente nella T_MCREI_APP_DELIBERE
  -- %cd 16/01/2012
  FUNCTION fnc_mcrei_coll_pacchetto(p_cod_abi            IN t_mcrei_app_delibere.cod_abi%TYPE,
                                    p_cod_ndg            IN t_mcrei_app_delibere.cod_ndg%TYPE,
                                    p_val_anno_proposta  IN t_mcrei_app_delibere.val_anno_proposta%TYPE,
                                    p_val_progr_proposta IN t_mcrei_app_delibere.val_progr_proposta%TYPE)
    RETURN t_mcrei_app_delibere.cod_protocollo_pacchetto%TYPE IS
    c_nome CONSTANT VARCHAR2(100) := c_package ||
                                     '.fnc_mcrei_coll_pacchetto';
    p_note                 t_mcrei_wrk_audit_applicativo.note%TYPE;
    v_protocollo_pacchetto t_mcrei_app_delibere.cod_protocollo_pacchetto%TYPE;
  BEGIN
    p_note := 'recupero collegamento pacchetto';

    SELECT cod_protocollo_pacchetto
      INTO v_protocollo_pacchetto
      FROM t_mcrei_app_delibere
     WHERE cod_abi = p_cod_abi
       AND cod_ndg = p_cod_ndg
       AND val_anno_proposta = p_val_anno_proposta
       AND val_progr_proposta = p_val_progr_proposta
       AND cod_microtipologia_delib IN ('CI', 'CS');

    RETURN v_protocollo_pacchetto;
  EXCEPTION
    WHEN OTHERS THEN
      pkg_mcrei_audit.log_app(c_nome,
                              pkg_mcrei_audit.c_error,
                              SQLCODE,
                              SQLERRM,
                              p_note,
                              NULL);
  END;

  -- %author Reply
  -- %version 0.1
  -- %usage  Function che gestisce le classificazioni a incaglio e a sofferenza AUTOMATICHE
  -- %d La function, in base al tipo di classificazione, effettua controlli sull'eventuale
  -- %d pacchetto presente nella tabella t_mcrei_App_delibere, contenente eventualmente una
  -- %d delibera di classificazione dello stesso tipo. A seguito dei controlli, gestisce
  -- %d le diverse casistiche.
  -- %cd 24/01/2012
  -- %PARAM p_TIPO_PROPOSTA  : 'E' se si tratta di una proposta di incaglio, 'S' in caso di sofferenza
  -- PER LE SOFFERENZE CONTROLLA IL CASO  WHERE COD_PROTOCOLLO_DELIBERA = '00201200000008857'
  -- DEL TO_DATE('20120607','YYYYMMDD')
  FUNCTION fnc_gest_classif_autom(p_iddper        NUMBER,
                                  p_cod_abi       VARCHAR2,
                                  p_tipo_proposta VARCHAR2) RETURN VARCHAR2 IS
    v_protoc          t_mcrei_app_delibere.cod_protocollo_pacchetto%TYPE;
    v_stato_pacchetto t_mcrei_app_delibere.cod_fase_pacchetto%TYPE;
    v_stato_delibera  t_mcrei_app_delibere.cod_fase_delibera%TYPE;
    v_microtipol      t_mcrei_app_delibere.cod_microtipologia_delib%TYPE;
    v_proto_delib     t_mcrei_app_delibere.cod_protocollo_delibera%TYPE;
    c_nome CONSTANT VARCHAR2(100) := c_package || '.fnc_gest_classif_autom';
    p_note   t_mcrei_wrk_audit_applicativo.note%TYPE;
    v_ret    VARCHAR2(200);
    v_return NUMBER := NULL;
    v_fase_delibera    T_MCREI_APP_DELIBERE.COD_FASE_DELIBERA%TYPE;
    V_RES              NUMBER;
    V_RES_IN           NUMBER;

  BEGIN

    v_ret := 'PACCHETTO CREATO CORRETTAMENTE';

    FOR inc_auto IN (SELECT st.cod_abi        AS p_cod_abi,
                        st.cod_ndg            AS p_cod_ndg,
                        st.val_anno_proposta  AS p_anno_proposta,
                        st.val_progr_proposta AS p_progr_proposta,
                        st.id_dper,
                        st.desc_anag_deliberante as p_desc_anag_delib,
                        ST.COD_TIPO_PROPOSTA as tipo_proposta_cursore,
                        ST.COD_STATO_PROPOSTO AS STATO_PROPOSTO_CURSORE,
                        st.cod_sndg as P_COD_SNDG,
                        dta_consolid_prop_org_vig,
                        dta_accensione_prop_rischio
                   FROM t_mcrei_st_proposte st
                  WHERE st.id_dper = p_iddper
                    AND st.cod_abi = p_cod_abi
                    AND st.cod_protocollo_pacchetto IS NULL
                    AND ST.FLG_DISPOSIZIONE = 'A'
                    AND ST.COD_TIPO_PROPOSTA = 'E')
                                ---la gestione automatica viene generalizzata su tutte le proposte disposte automaticamente
    LOOP
        CASE WHEN INC_AUTO.tipo_proposta_cursore = 'E' THEN
            --recupero il set di record delle proposte per cui valutare l'eventuale inseirimento o aggiornamento

              p_note := 'verifica esistenza CI';

              ----GESTISCE LA CASISTICA RELATIVA ALLA RICEZIONE DI UN INCAGLIO AUTOMATICO

              ---verifico l'esistenza di una delibera di CI contenente l'anno e il progr_proposta in input
      BEGIN
                SELECT d.cod_protocollo_pacchetto
                  INTO v_protoc
                  FROM t_mcrei_app_delibere d
                 WHERE d.cod_abi = inc_auto.p_cod_abi
                   AND d.cod_ndg = inc_auto.p_cod_ndg
                   AND d.val_anno_proposta = inc_auto.p_anno_proposta
                   AND d.val_progr_proposta = inc_auto.p_progr_proposta
                   AND d.cod_microtipologia_delib = 'CI'
                   And flg_no_delibera = 0
                   AND flg_attiva = '1'
                   AND rownum = 1;

                ---se esiste una delibera di CI con l'anno e il progr.proposta in input, allora AGGIORNA SOLO LE DATE
                p_note := 'aggiorna classificazione A INCAGLIO esistente';

                UPDATE t_mcrei_app_delibere d  ---commentato il 31 luglio
                   SET /*d.desc_anag_deliberante = 'INCAGLIO AUTOMATICO', -- prendo la descrizione del st inc_auto.p_desc_anag_delib
                       D.DESC_NOTE = 'RICEVUTO INCAGLIO AUTOMATICO POST CONFERMA DA CRUSCOTTO',
                       d.dta_last_upd_delibera = SYSDATE,
                       */
                         d.dta_last_upd_delibera = decode(d.dta_Conferma_delibera,null,sysdate,d.dta_last_upd_delibera),
                         d.dta_upd               = SYSDATE,
                         --v3.6 aggiunta logica di cambio fase e data conferma
                         d.COD_FASE_MICROTIPOLOGIA =  DECODE(inc_auto.stato_proposto_cursore, 'S','INS', 'B','CNF','INS'),
                         --mm3.9 se stato B, non cambio fase delibera (fix rispetto alla 3.8 che imponeva inc_auto.stato_proposto_cursore)
                         d.COD_FASE_DELIBERA = DECODE(inc_auto.stato_proposto_cursore, 'S','IN', 'B',d.COD_FASE_DELIBERA,'IN'),
                         d.dta_Conferma_delibera = case when( inc_auto.stato_proposto_cursore = 'B' and d.COD_FASE_DELIBERA = 'IN' )
                                        then nvl(inc_auto.dta_consolid_prop_org_vig, inc_auto.dta_accensione_prop_rischio)
                                        else D.DTA_CONFERMA_DELIBERA
                                        end
                 WHERE d.cod_abi = inc_auto.p_cod_abi
                   AND d.cod_ndg = inc_auto.p_cod_ndg
                   AND d.cod_microtipologia_delib = 'CI'
                   AND d.cod_protocollo_pacchetto = v_protoc
                  --3.0
                   AND flg_attiva = '1';
              EXCEPTION
                WHEN no_data_found
                --- se si tratta di una nuova classificazione
                 THEN
                  p_note   := 'verifica esistenza di un pacchetto non chiuso';
                  v_protoc := ctrl_esist_pacc_aperto(inc_auto.p_cod_abi,
                                                                    inc_auto.p_cod_ndg,
                                                                      'CI');


      ----inizio gestione
                 IF v_protoc IS NULL
                  ---SE NON ESISTE UN PACCHETTO GI? APERTO CON CI
                  THEN
                    p_note   := 'creazione nuovo pacchetto automatico in caso di nuova CI';
                    v_return := crea_pacchetto_classif_auto(inc_auto.tipo_proposta_cursore,
                                                                                inc_auto.p_cod_abi,
                                                                                inc_auto.p_cod_ndg,
                                                                                p_iddper);

                    IF v_return = 0
                    THEN
                      v_ret := 'IMPOSSIBILE IMPORTARE LA PROPOSTA:VERIFICARE LOG';
                      RETURN v_ret;
                    END IF;
              ELSE

                    -- SE ESISTE UN PACCHETTO GIA APERTO CON CI
                    p_note := 'verifica stato del pacchetto';
                   v_fase_delibera := null;
                    --- verifico lo stato del pacchetto
                    BEGIN
                      SELECT distinct  cod_fase_pacchetto  ---AD: aggiunta distinct, 4 gennaio
                        INTO v_stato_pacchetto
                        FROM t_mcrei_app_delibere d
                       WHERE d.cod_protocollo_pacchetto = v_protoc
                       And flg_no_delibera = 0
                       and cod_fase_pacchetto NOT IN ( 'ANM','ANA')
                        AND FLG_ATTIVA = '1';

                      IF (v_stato_pacchetto NOT IN ('CNF', 'ULT'))
                      -- se il pacchetto non e' confermato ne' ultimato AD--> 14 feb
                      THEN

                            --- annullo logicamente il pacchetto
                        p_note := 'annulla logicamente il pacchetto';

                        UPDATE t_mcrei_app_delibere d
                           SET d.cod_fase_pacchetto = 'ANA',
                               d.cod_Fase_microtipologia = 'ANA',----4 GENNAIO AD
                               --- annullato automaticamente
                               d.cod_fase_delibera      = 'AN',
                               d.dta_upd_fase_pacchetto = SYSDATE,
                               d.dta_last_upd_delibera  = SYSDATE,
                               d.dta_upd                = SYSDATE
                         WHERE d.cod_protocollo_pacchetto = v_protoc;

                        --- poi CREA_NUOVO_PACCHETTO_AUTOMATICO
                        p_note := 'creazione nuovo pacchetto automatico dopo annullamento dell''esistente';
                        p_note := p_note||'; creazione nuovo pacchetto automatico in caso di nuova CI';
                        v_return := crea_pacchetto_classif_auto(inc_auto.tipo_proposta_cursore,
                                                                                    inc_auto.p_cod_abi,
                                                                                    inc_auto.p_cod_ndg,
                                                                                    p_iddper);

                        IF v_return = 0
                        THEN
                          v_ret := 'IMPOSSIBILE IMPORTARE LA PROPOSTA:VERIFICARE LOG';
                          RETURN v_ret;
                        END IF;

                      ELSE
                        --IF v_stato_pacchetto IN ('CNF', 'ULT') ---se il pacchetto e' stato confermato

                        --THEN
                        p_note := 'verifica se la delibera di CI e'' confermata';

                        ---verifico se la delibera di CI e' confermata
                        SELECT d.cod_fase_delibera,
                               d.cod_microtipologia_delib,
                               d.cod_protocollo_delibera
                          INTO v_stato_delibera,
                               v_microtipol,
                               v_proto_delib
                          FROM t_mcrei_app_delibere d
                         WHERE d.cod_abi = inc_auto.p_cod_abi
                           AND d.cod_ndg = inc_auto.p_cod_ndg
                           AND d.cod_microtipologia_delib = 'CI'
                           And flg_no_delibera = 0
                           and cod_Fase_Delibera !='AN'
                           AND flg_attiva = '1'
                           AND d.cod_protocollo_pacchetto = v_protoc;

                        BEGIN
                          IF v_stato_delibera NOT IN ('CO', 'CA')  ------7 GENNAIO: AGGIUNTO  'CA'
                          ------NON CONFERMATA
                          THEN
                            p_note := 'sovrascrive i dati della CI esistente con quelli nuovi';
                            /*I dati inseriti dall'utente vengono spostati nella tabella
                            di audit delle classificazioni automatiche
                            Sulla delibera esistente vengono copiati i dati della proposta
                            importata. */
                            v_return := sovrascrivi_proposta_esistente(inc_auto.p_cod_abi,
                                                                                           inc_auto.p_cod_ndg,
                                                                                           v_protoc,
                                                                                           v_microtipol,
                                                                                           v_proto_delib,
                                                                                           inc_auto.id_dper);

                            IF v_return = 0
                            THEN
                              v_ret := 'IMPOSSIBILE sovrascrivere LA PROPOSTA:VERIFICARE LOG';
                              RETURN v_ret;
                            else  ----se la sovrascrittura dei campi S andata correttamente
                               ---- accoda la richiesta di rigenerazione documenti per il pacchetto
                               INSERT INTO T_MCREI_PARAM_COMMANDS (  NUM_RETRY,
                                                                                                    VAL_PARAM,
                                                                                                    DTA_INSERIMENTO,
                                                                                                    DTA_ESECUZIONE
                                                                                                ) VALUES (
                                                                                                    5, --Numero di tentativi
                                                                                                    v_protoc, --codice protocollo del pacchetto
                                                                                                    sysdate,
                                                                                                    NULL
                                                                                                );
                                commit;

                            END IF;
                          ELSE
                            p_note := 'scarta i dati della delibera automatica';
                            /*Scarta i dati della delibera automatica:
                            salvare i campi della delibera automatica
                            nella tabella di audit delle classificazioni automatiche*/
                            v_return := scarta_proposta_automatica(inc_auto.p_progr_proposta,
                                                                   inc_auto.p_anno_proposta,
                                                                   inc_auto.id_dper,
                                                                   INC_AUTO.P_COD_ABI,
                                                                   INC_AUTO.P_COD_NDG);

                            IF v_return = 0
                            THEN
                              v_ret := 'IMPOSSIBILE scartare LA PROPOSTA:VERIFICARE LOG';
                              RETURN v_ret;
                            END IF;
                          END IF;
                        END;
                      END IF;
                    END;
              END IF;
              -----termine gestione

      END;

    WHEN inc_auto.tipo_proposta_cursore = 'S' THEN  ----------- Classificazione a sofferenza, non viene effetivamente eseguito

        p_note := 'verifica esistenza CS';
        ----GESTISCE LA CASISTICA RELATIVA ALLA RICEZIONE DI UN INCAGLIO AUTOMATICO
         BEGIN
           SELECT d.cod_protocollo_pacchetto,COD_FASE_DELIBERA
             INTO v_protoc,V_FASE_DELIBERA
             FROM t_mcrei_app_delibere d
            WHERE d.cod_abi = inc_auto.p_cod_abi
              AND d.cod_ndg = inc_auto.p_cod_ndg
              AND d.val_anno_proposta = inc_auto.p_anno_proposta
              AND d.val_progr_proposta = inc_auto.p_progr_proposta
              AND d.cod_microtipologia_delib = 'CS'
              AND flg_attiva = '1'
              AND rownum = 1;

           ---se esiste una delibera di CS con l'anno e il progr.proposta in input, allora
           ---aggiorno la classificazione esistente, settando a INCAGLIO AUTOMATICO il campo desc_anag_deliberante
           p_note := 'aggiorna classificazione A SOFFERENZA esistente';
           UPDATE t_mcrei_app_delibere d
              SET d.desc_anag_deliberante = 'SOFFERENZA AUTOMATICA',
                  d.dta_last_upd_delibera = SYSDATE
            WHERE d.cod_abi = inc_auto.p_cod_abi
              AND d.cod_ndg = inc_auto.p_cod_ndg
              AND d.cod_microtipologia_delib = 'CS'
              AND d.cod_protocollo_pacchetto = v_protoc
              AND flg_attiva = '1';

         EXCEPTION
           WHEN no_data_found --- se si tratta di una nuova classificazione
            THEN
             ---verifico se la proposta arrivata automaticamente S in stato confermato
              SELECT  DECODE(cod_stato_proposto, 'S','IN', 'B','CO','IN') AS COD_FASE_DELIBERA
                INTO V_FASE_DELIBERA
                FROM t_mcrei_st_proposte p
              WHERE p.id_dper =  p_iddper
                AND p.cod_abi = inc_auto.p_cod_abi
                AND p.cod_ndg = inc_auto.p_cod_ndg
                AND P.COD_TIPO_PROPOSTA = 'S';

        IF V_FASE_DELIBERA = 'CO' THEN
             p_note   := 'verifica esistenza di un pacchetto non chiuso';
             v_protoc := ctrl_esist_pacc_aperto(inc_auto.p_cod_abi, inc_auto.p_cod_ndg, 'CS');
             IF v_protoc IS NULL ---SE NON ESISTE UN PACCHETTO GIA' APERTO CON CS
             THEN
               p_note   := 'creazione nuovo pacchetto automatico in caso di nuova CS';
               v_return := crea_pacchetto_classif_auto(inc_auto.tipo_proposta_cursore,
                                                       inc_auto.p_cod_abi,
                                                       inc_auto.p_cod_ndg,
                                                       p_iddper);
               IF v_return = 0
               THEN
                 v_ret := 'IMPOSSIBILE IMPORTARE LA PROPOSTA:VERIFICARE LOG';
                 RETURN v_ret;
                   END IF;
             ELSE
               -- SE ESISTE UN PACCHETTO GIA APERTO CON CS
               p_note := 'verifica stato del pacchetto';
               --- verifico lo stato del pacchetto
               BEGIN
                 SELECT cod_fase_pacchetto
                   INTO v_stato_pacchetto
                   FROM t_mcrei_app_delibere d
                  WHERE FLG_ATTIVA = '1'
                    AND d.cod_protocollo_pacchetto = v_protoc;

                 IF v_stato_pacchetto NOT IN ('CNF', 'ULT') -- se il pacchetto non S confermato
                 THEN
                   --- annullo logicamente il pacchetto
                   p_note := 'annulla logicamente il pacchetto';

                   UPDATE t_mcrei_app_delibere d
                      SET d.cod_fase_pacchetto     = 'ANA', --- annullato automaticamente
                          d.cod_fase_delibera      = 'AN',
                          d.dta_upd_fase_pacchetto = SYSDATE,
                          d.dta_last_upd_delibera  = SYSDATE
                    WHERE d.cod_protocollo_pacchetto = v_protoc;

                   --- poi CREA_NUOVO_PACCHETTO_AUTOMATICO

                    p_note := 'creazione nuovo pacchetto automatico dopo annullamento dell''esistente';
                    v_return := crea_pacchetto_classif_auto(inc_auto.tipo_proposta_cursore,
                                                       inc_auto.p_cod_abi,
                                                       inc_auto.p_cod_ndg,
                                                       p_iddper);

                 ELSE --IF v_stato_pacchetto IN ('CNF', 'ULT') ---se il pacchetto S stato confermato

                   p_note := 'verifica se la delibera di CS S confermata';
                   ---verifico se la delibera di CS S confermata
                   SELECT d.cod_fase_delibera,
                          d.cod_microtipologia_delib,
                          d.cod_protocollo_delibera
                     INTO v_stato_delibera,
                          v_microtipol,
                          v_proto_delib
                     FROM t_mcrei_app_delibere d
                    WHERE d.cod_abi = inc_auto.p_cod_abi
                      AND d.cod_ndg = inc_auto.p_cod_ndg
                      AND d.cod_microtipologia_delib = 'CS'
                      AND flg_attiva = '1'
                      AND d.cod_protocollo_pacchetto = v_protoc;

                   BEGIN
                     IF v_stato_delibera NOT IN ('CO', 'AD') ------NON CONFERMATA NS ADEMPIUTA

                     THEN
                       p_note := 'sovrascrive i dati della CS esistente con quelli nuovi';
                       /*I dati inseriti dall'utente vengono spostati nella tabella
                       di audit delle classificazioni automatiche
                       Sulla delibera esistente vengono copiati i dati della proposta
                       importata.*/
                       v_return := sovrascrivi_proposta_esistente(inc_auto.p_cod_abi,
                                                                  inc_auto.p_cod_ndg,
                                                                  v_protoc,
                                                                  v_microtipol,
                                                                  v_proto_delib,
                                                                  p_iddper);

                      IF v_return = 0
                       THEN
                         v_ret := 'IMPOSSIBILE sovrascrivere LA PROPOSTA:VERIFICARE LOG';
                       RETURN v_ret;
                       else  ----se la sovrascrittura dei campi S andata correttamente
                               ---- accoda la richiesta di rigenerazione documenti per il pacchetto
                               INSERT INTO T_MCREI_PARAM_COMMANDS (  NUM_RETRY,
                                                                                                    VAL_PARAM,
                                                                                                    DTA_INSERIMENTO,
                                                                                                    DTA_ESECUZIONE
                                                                                                ) VALUES (
                                                                                                    5, --Numero di tentativi
                                                                                                    v_protoc, --codice protocollo del pacchetto
                                                                                                    sysdate,
                                                                                                    NULL
                                                                                                );
                                commit;
                               END IF;

                     ELSE
                       p_note := 'scarta i dati della delibera automatica';

                       /*Scarta i dati della delibera automatica:
                       salvare i campi della delibera automatica
                       nella tabella di audit delle classificazioni automatiche*/
                       v_return := scarta_proposta_automatica(inc_auto.p_progr_proposta,
                                                              inc_auto.p_anno_proposta,
                                                              p_iddper,
                                                                   INC_AUTO.P_COD_ABI,
                                                                   INC_AUTO.P_COD_NDG);

                       IF v_return = 0
                       THEN
                         v_ret := 'IMPOSSIBILE scartare LA PROPOSTA:VERIFICARE LOG';
                         RETURN v_ret;
                               END IF;

                     END IF;
                   END;

                 END IF;

               END;

             END IF;

        ELSE  -----------------------------------------se delibera esistenza S non confermata, diversa da 'CO'
           v_protoc := ctrl_esist_pacc_aperto_sndg(inc_auto.p_cod_sndg,'CS');
           IF V_PROTOC IS NOT NULL THEN

                v_proto_delib := CNTRL_ESIST_DELIB(INC_AUTO.P_COD_ABI,
                                           INC_AUTO.P_COD_NDG,
                                           'CS',
                                           V_PROTOC);

                IF v_proto_delib IS NOT NULL THEN
                -- SOVRASCRITTURA CS
                  V_RET:= sovrascrivi_proposta_esistente(INC_AUTO.P_COD_ABI,  ---- TOTALE SOVRASRITTURA OPPURE AGGIORNAMENTO SOLO
                                                         INC_AUTO.P_COD_NDG,  ---- DESC_ANAG_DELIBERANTE ???
                                                         V_PROTOC,
                                                         'CS',
                                                          v_proto_delib,
                                                          p_iddper);

                ELSE            -- il pacchetto non contiene una CS per NDG
                    p_note:= 'creazione nuova delibera agganciata a pacchetto '||v_protoc;
                    V_RETURN:= crea_pacchetto_classif_auto(inc_auto.tipo_proposta_cursore, --> CREA UNA NUOVA CS AGGANCIATA A V_PROTOC
                                                         inc_auto.p_cod_abi,
                                                         inc_auto.p_cod_ndg,
                                                         p_iddper,
                                                         V_PROTOC);
                        IF v_return = 0
                        THEN
                          v_ret := 'IMPOSSIBILE IMPORTARE LA PROPOSTA:VERIFICARE LOG';
                          RETURN v_ret;
                        END IF;
                END IF;
           ELSE -- NON ESISTE PACCHETTO APERTO CON DELIBERA APERTA CS SUL SNDG
                p_note := 'creazione nuovo pacchetto automatico dopo annullamento dell''esistente';
                v_return := crea_pacchetto_classif_auto(inc_auto.tipo_proposta_cursore,
                                                   inc_auto.p_cod_abi,
                                                   inc_auto.p_cod_ndg,
                                                   p_iddper);
           END IF;
         NULL;
        END IF;
      END;---gestione nuova classificazione

    ELSE
         raise_application_error(-1777, 'tipo di classif sconosciuta');
    END CASE;
  END LOOP;

    COMMIT;
    RETURN v_ret;
  EXCEPTION
    WHEN OTHERS THEN
      ROLLBACK;
      pkg_mcrei_audit.log_app(c_nome,
                                    pkg_mcrei_audit.c_error,
                              SQLCODE,
                              SQLERRM,
                              p_note,
                              NULL);
      v_ret := 0;
      RETURN v_ret;
  END fnc_gest_classif_autom;

  -- %author Reply
  -- %version 0.1
  -- %usage  Funzione che verifica l'esistenza di un pacchetto non ancora confermato per l'abi, ndg e microtipologia in input
  -- %usage (da usare nella gestione automatica degli incagli)
  -- %d  La funzione, per l'abi, ndg, e microtipologia in input, verifica l'esistenza di un eventuale
  -- %d  pacchetto ancora aperto. Se esiste, ne restituisce il protocollo,in caso contrario
  -- %d  restituisce NULL
  -- %cd 7 nov 2011
  -- %param P_ABI ABI
  -- %param P_NDG: NDG
  -- %param P_MICROTIPOLOG microtipologia pacchetto
  FUNCTION ctrl_esist_pacc_aperto(p_abi          IN VARCHAR2,
                                  p_ndg          IN VARCHAR2,
                                  p_microtipolog IN VARCHAR2) RETURN VARCHAR2 IS
   c_nome CONSTANT VARCHAR2(100) := c_package || '.CTRL_ESIST_PACC_APERTO';
    v_protoc t_mcrei_app_delibere.cod_protocollo_pacchetto%TYPE;
    p_note   t_mcrei_wrk_audit_applicativo.note%TYPE;
  BEGIN
    v_protoc := NULL;
    p_note   := 'Controlla esistenza pacchetto aperto per abi, ndg e microtipologia delibera';

    IF p_abi IS NULL OR
       p_ndg IS NULL OR
       p_microtipolog IS NULL
    THEN
      raise_application_error(-20666, 'Null parameter');
    END IF;

    BEGIN
      p_note := 'Controllo esistenza in tabella T_MCREI_APP_DELIBERE';

      SELECT d.cod_protocollo_pacchetto
        INTO v_protoc --PROTOCOLLO DI UN PACCHETTO aperto
        FROM t_mcrei_app_delibere d
       WHERE d.cod_abi = p_abi
         AND d.cod_ndg = p_ndg
         AND d.cod_microtipologia_delib = p_microtipolog
         and cod_fase_Delibera !='AN'
         AND FLG_NO_DELIBERA =0  ---4 GENNAIO
         AND cod_fase_pacchetto NOT IN ('ANA', 'ANM', 'ULT') --PACCHETTO IN FASE DI ELABORAZIONE
         AND flg_attiva = '1'
         AND rownum = 1;

      pkg_mcrei_audit.log_app(c_nome,
                              pkg_mcrei_audit.c_debug,
                              SQLCODE,
                              SQLERRM,
                              p_note,
                              NULL);
      RETURN v_protoc;
    EXCEPTION
      WHEN no_data_found THEN
      p_note := 'Controllo esistenza in tabella T_MCREI_APP_DELIBERE '||p_abi||', '||P_NDG;
        RETURN NULL;
    END;
  EXCEPTION
    WHEN OTHERS THEN
      pkg_mcrei_audit.log_app(c_nome,
                              pkg_mcrei_audit.c_error,
                              SQLCODE,
                              SQLERRM,
                              p_note,
                              NULL);
      RETURN NULL; ---ko
  END ctrl_esist_pacc_aperto;

  -- %author Reply
  -- %version 0.1
  -- %usage  Funzione che crea un pacchetto automatico in base al tipo di classificazione in input
  -- %d La funzione crea un pacchetto monotipologia/monodelibera in stato confermato
  -- %d importando i dati di una proposta ricevuta automaticamente
  -- %cd 26 gen 2012
  -- %param p_tipo_classif: E -> incaglio, S -> sofferenza
  FUNCTION crea_pacchetto_classif_auto(p_tipo_classif VARCHAR2,
                                       p_abi          VARCHAR2,
                                       p_ndg          VARCHAR2,
                                       p_periodo      NUMBER,
                                       V_PROTO_PAC  IN VARCHAR2 DEFAULT NULL) RETURN NUMBER IS
    c_nome CONSTANT VARCHAR2(100) := c_package ||
                                     '.crea_pacchetto_classif_auto';
    p_note t_mcrei_wrk_audit_applicativo.note%TYPE;
    V_SEQ       NUMBER;
    V_FASE_PAC  T_MCREI_APP_DELIBERE.COD_FASE_PACCHETTO%TYPE;
  BEGIN
    p_note := 'POPOLAMENTO DELIBERE CON PROPOSTA AUTOMATICA'||' '||
    P_ABI||', '||P_NDG||', '||V_PROTO_PAC
    ||P_TIPO_CLASSIF||';';

    SELECT mcre_own.seq_mcrei_pacchetto.nextval
      INTO V_SEQ
      FROM DUAL;

      IF V_PROTO_PAC IS NOT NULL THEN

      SELECT distinct COD_FASE_PACCHETTO  ----AD: aggiunta distinct il 4 gennaio
        INTO V_FASE_PAC
      FROM T_MCREI_APP_DELIBERE
      WHERE COD_ABI = P_ABI
        AND COD_NDG = P_NDG
        AND COD_PROTOCOLLO_PACCHETTO = V_PROTO_PAC
        AND ROWNUM = 1;

      END IF;

    MERGE INTO   t_mcrei_app_delibere t
     USING   (
     SELECT            pr.id_dper,
                       pr.cod_abi,
                       pr.cod_sndg,
                       PR.cod_ndg,
                       PR.val_anno_proposta,
                       PR.val_progr_proposta,
                       NVL(V_PROTO_PAC,pr.cod_sndg || '_' || V_SEQ) AS cod_protocollo_pacchetto,
                       DECODE( ( casE when cod_stato_proposto = 'S' AND dta_superam_stato_rischio IS NOT NULL
                       then 'AN'
                       else
                       DECODE(cod_stato_proposto, 'S','IN', 'B','CO','IN') end),'CO',  AD.COD_STATO, NULL) AS COD_STATO,
                       PR.COD_PROTOCOLLO_DELIBERA,
                       cod_stato_proposto,
                       dta_accensione_prop_rischio,
                       dta_superam_stato_rischio,
                       desc_anag_proponente,
                       dta_delib_prop_da_deliberante,
                       desc_anag_deliberante,
                       dta_delib_prop_da_proponente,
                       cod_uo_proponente,
                       dta_inizio_rapporto_cliente,
                       desc_ramo_affari,
                       dta_last_delibera_fido,
                       note_last_delib_fido,
                       desc_liv_last_delib_fido,
                       dta_revoca_fido_in_essere,
                       desc_rischi_indiretti,
                       desc_garanzie_accanton,
                       val_perc_dubbio_esito,
                       dta_consolid_prop_org_vig,
                       cod_matricola_conf_propos,
                       flg_disposizione,
                       val_accordato,
                       val_imp_utilizzo,
                       val_esp_lorda_capitale,
                       val_esp_lorda_mora,
                       val_imp_fondi_terzi,
                       val_imp_fondi_terzi_nb,
                       val_imp_crediti_firma,
                       val_esp_lorda,
                       cod_intest_sched_gen,
                       cod_uo_proposta,
                       flg_cancellaz_proposta,
                       val_interessi_mora_cassa,
                       val_esp_tot_cassa,
                       desc_note_annullo_prop,
                       dta_ins_delibera,
                       dta_trasfer_propo_fil_area,
                       DECODE (cod_tipo_proposta, 'S', 'CS', 'CI')
                          AS cod_microtipologia_delib,
                       CASE
                          WHEN cod_tipo_proposta = 'S' THEN 'SO'
                          WHEN cod_tipo_proposta = 'E' THEN 'IN'
                          ELSE NULL
                       END
                          cod_stato_pro,
                       cod_tipo_proposta,
                       --0 AS val_num_progr_delibera,
                       DECODE(cod_stato_proposto, 'S','INS', 'B','CNF','INS') AS COD_FASE_MICROTIPOLOGIA,
                       DECODE(cod_stato_proposto, 'S','IN', 'B','CO','IN') AS COD_FASE_DELIBERA,
                       'ULT' AS cod_fase_pacchetto,-- MODIFICATO IL 14 SEP------DECODE(V_PROTO_PAC, NULL,'ULT',V_FASE_PAC) as cod_fase_pacchetto,--- SE V_PROTO_PAC
                       0 AS FLG_NO_DELIBERA,
                       AD.DTA_DECORRENZA_STATO DTA_DEC_STATO_POS
                FROM   t_mcrei_st_proposte pr, T_MCRE0_APP_ALL_DATA AD
               WHERE  pr.id_dper = p_periodo
                  AND pr.cod_abi = p_abi
                  AND pr.cod_ndg = p_ndg
                  AND PR.COD_ABI = AD.COD_ABI_CARTOLARIZZATO(+)
                  AND PR.COD_NDG = AD.COD_NDG(+)
                  AND AD.FLG_ACTIVE(+) = '1'
                  AND pr.COD_PROTOCOLLO_PACCHETTO IS NULL
                  AND PR.COD_TIPO_PROPOSTA = p_tipo_classif ---- E = incaglio, S = sofferenza
                  ) s
ON (              s.cod_abi = t.cod_abi
              AND s.cod_ndg = t.cod_ndg
              AND s.val_anno_proposta = t.val_anno_proposta
              AND s.val_progr_proposta = t.val_progr_proposta
              AND s.cod_protocollo_delibera = t.cod_protocollo_delibera)
WHEN NOT MATCHED
THEN
   INSERT              (t.id_dper,
                        t.cod_abi,
                        t.cod_sndg,
                        t.cod_ndg,
                        t.val_anno_proposta,
                        t.val_progr_proposta,
                        t.cod_protocollo_delibera,
                        t.cod_stato_proposta,
                        t.cod_stato_proposto,
                        t.dta_accensione_prop_rischio,
                        t.dta_superam_stato_rischio,
                        t.desc_anag_proponente,
                        t.dta_delib_prop_da_deliberante,
                        t.desc_anag_deliberante,
                        t.dta_delib_prop_da_proponente,
                        t.cod_uo_proponente,
                        t.dta_inizio_rapporto_cliente,
                        t.desc_ramo_affari,
                        t.dta_last_delibera_fido,
                        t.note_last_delib_fido,
                        t.desc_liv_last_delib_fido,
                        t.dta_revoca_fido_in_essere,
                        t.desc_rischi_indiretti,
                        t.desc_garanzie_accanton,
                        t.val_perc_dubbio_esito,
                        t.dta_consolid_prop_org_vig,
                        t.cod_matricola_conf_propos,
                        t.flg_disposizione,
                        t.val_accordato,
                        t.val_imp_utilizzo,
                        t.val_esp_lorda_capitale,
                        t.val_esp_lorda_mora,
                        t.val_imp_fondi_terzi,
                        t.val_imp_fondi_terzi_nb,
                        t.val_imp_crediti_firma,
                        t.val_esp_lorda,
                        t.cod_intest_sched_gen,
                        t.cod_uo_proposta,
                        t.flg_cancellaz_proposta,
                        t.val_interessi_mora_cassa,
                        t.val_esp_tot_cassa,
                        t.desc_note_annullo_prop,
                        t.dta_ins_delibera,
                        t.dta_trasfer_propo_fil_area,
                        t.flg_attiva,
                        t.dta_ins,
                        t.dta_upd,
                        t.cod_operatore_ins_upd,  ----> seguono campi derivati
                        t.cod_protocollo_pacchetto,
                        t.dta_creazione_pacchetto,
                        t.DTA_CONFERMA_PACCHETTO,
                        t.cod_tipo_pacchetto,
                        t.cod_fase_microtipologia,
                        t.cod_fase_pacchetto,
                        t.cod_fase_delibera,
                        t.cod_macrotipologia_delib,
                        t.dta_delibera,
                        t.dta_conferma_delibera,
                        t.dta_last_upd_delibera,
                        t.dta_delibera_estero,
                        t.dta_scadenza,
                        t.dta_scadenza_estero,
                        t.dta_scadenza_transaz,
                        t.cod_tipo_proposta,
                        t.val_num_progr_delibera,
                        t.COD_MICROTIPOLOGIA_DELIB,
                        T.COD_MATRICOLA_INSERENTE,
                        T.FLG_NO_DELIBERA,
                        T.COD_STATO_POSIZ,
                        T.DTA_DEC_STATO_POSIZ
                        )
       VALUES   (s.id_dper,
                 s.cod_abi,
                 s.cod_sndg,
                 s.cod_ndg,
                 s.val_anno_proposta,
                 s.val_progr_proposta,
                 s.cod_protocollo_delibera,
                 s.cod_stato_proposto,
                 s.cod_Stato_pro,
                 s.dta_accensione_prop_rischio,
                 s.dta_superam_stato_rischio,
                 s.desc_anag_proponente,
                 s.dta_delib_prop_da_deliberante,
                 s.desc_anag_deliberante,
                 s.dta_delib_prop_da_proponente,
                 s.cod_uo_proponente,
                 s.dta_inizio_rapporto_cliente,
                 s.desc_ramo_affari,
                 s.dta_last_delibera_fido,
                 s.note_last_delib_fido,
                 s.desc_liv_last_delib_fido,
                 s.dta_revoca_fido_in_essere,
                 s.desc_rischi_indiretti,
                 s.desc_garanzie_accanton,
                 s.val_perc_dubbio_esito,
                 s.dta_consolid_prop_org_vig,
                 s.cod_matricola_conf_propos,
                 s.flg_disposizione,
                 s.val_accordato,
                 s.val_imp_utilizzo,
                 s.val_esp_lorda_capitale,
                 s.val_esp_lorda_mora,
                 s.val_imp_fondi_terzi,
                 s.val_imp_fondi_terzi_nb,
                 s.val_imp_crediti_firma,
                 s.val_esp_lorda,
                 s.cod_intest_sched_gen,
                 s.cod_uo_proposta,
                 s.flg_cancellaz_proposta,
                 s.val_interessi_mora_cassa,
                 s.val_esp_tot_cassa,
                 s.desc_note_annullo_prop,
                 s.dta_ins_delibera,
                 s.dta_trasfer_propo_fil_area,
                 1,
                 SYSDATE,
                 SYSDATE,
                 NULL,                            ----> SEGUONO CAMPI DERIVATI
                 s.cod_sndg || '_' || mcre_own.seq_mcrei_pacchetto.NEXTVAL,
                 nvl(s.dta_consolid_prop_org_vig, s.dta_accensione_prop_rischio), --T.DTA_CREAZIONE_PACCHETTO, --T_MCREI_ST_PROPOSTE
                 nvl(s.dta_consolid_prop_org_vig, s.dta_accensione_prop_rischio),   --T.DTA_CONFERMA_PACCHETTO,
                 'A',                                  --T.COD_TIPO_PACCHETTO,
                 S.COD_FASE_MICROTIPOLOGIA,            --T.COD_FASE_MICROTIPOLOGIA,
                 s.cod_fase_pacchetto,                                --T.COD_FASE_PACCHETTO,
                 s.cod_fase_delibera,                  -- t.COD_FASE_DELIBERA
                 'GE',                                 --t.COD_MACROTIPOLOGIA_DELIB
                  nvl(s.dta_delib_prop_da_proponente,s.dta_consolid_prop_org_vig) ,--31 aug   --  t.DTA_DELIBERA
                 nvl(s.dta_consolid_prop_org_vig, s.dta_accensione_prop_rischio),   --  t.DTA_CONFERMA_DELIBERA
                 nvl(s.dta_consolid_prop_org_vig, s.dta_accensione_prop_rischio),   --  t.DTA_LAST_UPD_DELIBERA
                 NULL,                   --  t.DTA_DELIBERA_ESTERO           ,
                 NULL,                   --  t.DTA_SCADENZA                  ,
                 NULL,                               --  t.DTA_SCADENZA_ESTERO
                 NULL,                              --  t.DTA_SCADENZA_TRANSAZ
                 s.cod_tipo_proposta,
                 DECODE (S.cod_tipo_proposta, 'S',seq_mcrei_prog_del.nextval, 0),-- val_num_progr_delibera,
                 S.COD_MICROTIPOLOGIA_DELIB,
                 'BATCH', -- COD_MATRICOLA_INSERENTE
                 S.FLG_NO_DELIBERA,
                 S.COD_STATO,
                 S.DTA_DEC_STATO_POS )
      WHERE S.DTA_SUPERAM_STATO_RISCHIO IS NULL;

    RETURN 1; --ok
  EXCEPTION
    WHEN OTHERS THEN
      pkg_mcrei_audit.log_app(c_nome,
                              pkg_mcrei_audit.c_error,
                              SQLCODE,
                              SQLERRM,
                              p_note,
                              NULL);
      RETURN 0;
  END;

  -- %author Reply
  -- %version 0.1
  -- %usage  Funzione che crea un pacchetto automatico in base al tipo di classificazione in input
  -- %d La funzione crea un pacchetto monotipologia/monodelibera in stato confermato
  -- %d importando i dati di una proposta ricevuta automaticamente
  -- %cd 26 gen 2012
  -- %param p_tipo_classif: E -> incaglio, S -> sofferenza
  FUNCTION sovrascrivi_proposta_esistente(p_abi         VARCHAR2,
                                          p_ndg         VARCHAR2,
                                          p_proto_pac   VARCHAR2,
                                          p_microtipol  VARCHAR2,
                                          p_proto_delib VARCHAR2,
                                          p_iddper      NUMBER) RETURN NUMBER IS
    -----da verificare: va trasformata in update dei soli campi delle proposte
     c_nome CONSTANT VARCHAR2(100) := c_package || '.sovrascrivi_proposta_esistente';

  p_note varchar2(40);
  BEGIN
    --sposta i dati della delibera di classificazione corrente nella tabella di audit.
    --Il RECORD della delibera verr? aggiornato con i dati della proposta generata automaticamente
    INSERT INTO t_mcrei_audit_classif_autom
      (cod_abi,
       cod_causa_chius_delibera,
       cod_fase_delibera,
       cod_fase_microtipologia,
       cod_fase_pacchetto,
       cod_filiale_delibera,
       cod_intest_sched_gen,
       cod_last_organo_delib_fido,
       cod_macrotipologia_delib,
       cod_matricola_conf_propos,
       cod_matricola_inserente,
       cod_microtipologia_delib,
       cod_microtipologia_host,
       cod_ndg,
       cod_operatore_ins_upd,
       cod_organo_calcolato,
       cod_organo_deliberante,
       cod_organo_deliberato,
      cod_organo_pacchetto,
       cod_pratica,
       cod_protocollo_delibera,
       cod_protocollo_delibera_col,
       cod_protocollo_pacchetto,
       cod_sag,
       cod_segmento,
       cod_sndg,
       cod_stato_proposta,
       cod_stato_proposto,
       cod_stato_provenienza,
       cod_stato_sag,
       cod_tipo_pacchetto,
       cod_tipo_proposta,
       cod_tipo_transazione,
       cod_uo_pratica,
       cod_uo_proponente,
       cod_uo_proposta,
       desc_anag_deliberante,
       desc_anag_proponente,
       desc_denominaz_ins_delibera,
       desc_garanzie_accanton,
       desc_liv_last_delib_fido,
       desc_modal_conferma_sag,
       desc_motivo_pass_rischio,
       desc_note,
       desc_note_annullo_prop,
       desc_note_coerenza,
       desc_note_delibere_annullate,
       desc_note_forzatura,
       desc_note_garanzie_prestate,
       desc_note_garanzie_ricevute,
       desc_note_rdv,
       desc_note_rischi,
       desc_note_urg,
       desc_parere_sndg,
       desc_ramo_affari,
       desc_rischi_indiretti,
       desc_secondo_referente,
       desc_tipo_conferma_delibera,
       desc_tipo_gestione,
       dta_accensione_prop_rischio,
       dta_calc_conf_sag,
       dta_conferma_delibera,
       dta_conferma_pacchetto,
       dta_congelamento,
       dta_consolid_prop_org_vig,
       dta_creazione_pacchetto,
       dta_delib_prop_da_deliberante,
       dta_delib_prop_da_proponente,
       dta_delibera,
       dta_delibera_estero,
       dta_ingresso_rdv_servizio,
       dta_inizio_rapporto_cliente,
       dta_ins,
       dta_ins_delibera,
       dta_last_delibera_fido,
       dta_last_upd_delibera,
       dta_motivo_pass_rischio,
       dta_revoca_fido_in_essere,
       dta_rif_dati_contabili,
       dta_scadenza,
       dta_scadenza_estero,
       dta_scadenza_transaz,
       dta_superam_stato_rischio,
       dta_trasfer_propo_fil_area,
       dta_udienza_ver_cred,
       dta_upd,
       dta_upd_fase_delibera,
       dta_upd_fase_microtipologia,
       dta_upd_fase_pacchetto,
       flg_100,
       flg_affidam_soc_recupero,
       flg_art_136,
       flg_attiva,
       flg_avviso_ex498cpc,
       flg_beni_non_in_garanzia,
       flg_cancellaz_proposta,
       flg_conti_categ_2000,
       flg_delib_in_linea,
       flg_depositi_collaterali,
       flg_disposizione,
       flg_esist_debitore_sotto_proc,
       flg_fondo_terzi,
       flg_forz_man_gest_interna,
       flg_garanzie_con_fidi,
       flg_garanzie_genworth,
       flg_garanzie_sace,
       flg_garanzie_sgfa,
       flg_interven_organi_superiori,
       flg_ipoteche_beni_deb_gar,
       flg_libretti_portatore_minori,
       flg_no_colleg_altre_pos,
       flg_no_delibera,
       flg_no_garanzie_capienti,
       flg_no_patrimon_aggred,
       flg_no_presupposti_class_soff,
       flg_no_rischi_firma,
       flg_parti_correlate,
       flg_perdur_difficolta_econ,
       flg_pignoramenti_immobiliari,
       flg_pignoramenti_mobiliari,
       flg_pignoramenti_terzi,
       flg_pratica_urg,
       flg_presen_covenants,
       flg_protesti,
       flg_rapporti_bloccati,
       flg_rapporti_con_depos_titoli,
       flg_rapporti_garanzia_cred_fir,
       flg_rapporto_concordato_preven,
       flg_soggetto_pot_fallibile,
       flg_to_copy,
       flg_visionato,
       id_dper,
       indirizzo_email,
       note_last_delib_fido,
       num_tel_secondo_referente,
       num_telefono,
       val_accordato,
       val_accordato_derivati,
       val_anno_pratica,
       val_anno_proposta,
       val_esp_lorda,
       val_esp_lorda_capitale,
       val_esp_lorda_mora,
       val_esp_netta_ante_delib,
       val_esp_netta_post_delib,
       val_esp_tot_cassa,
       val_imp_crediti_firma,
       val_imp_fondi_terzi,
       val_imp_fondi_terzi_nb,
       val_imp_offerto,
       val_imp_perdita,
       val_imp_utilizzo,
       val_interessi_futuri,
       val_interessi_mora_cassa,
       val_num_progr_delibera,
       val_perc_dubbio_esito,
       val_perc_perd_rm,
       val_perc_rdv,
       val_perc_rdv_estero,
       val_perdita_attuale,
       val_perdita_deliberata,
       val_progr_proposta,
       val_rdv_delib_banca_rete,
       val_rdv_extra_delibera,
       val_rdv_qc_ante_delib,
       val_rdv_qc_deliberata,
       val_rdv_qc_progressiva,
       val_rdv_quota_mora,
       val_rinuncia_capitale,
       val_rinuncia_deliberata,
       val_rinuncia_mora,
       val_rinuncia_proposta,
       val_rischi_indiretti,
       val_sacrif_capit_mora,
       val_stralcio_quota_cap,
       val_stralcio_quota_mora,
       val_stralcio_senza_accantonam,
       flg_tasso_base_appl,
       val_uti_cassa_scsb,
       val_uti_firma_scsb,
       val_uti_netto_fondo_terzi,
       val_uti_sosti_scsb,
       val_uti_tot_gegb,
       val_uti_tot_scsb)
      SELECT cod_abi,
             cod_causa_chius_delibera,
             cod_fase_delibera,
             cod_fase_microtipologia,
             cod_fase_pacchetto,
             cod_filiale_delibera,
             cod_intest_sched_gen,
             cod_last_organo_delib_fido,
             cod_macrotipologia_delib,
             cod_matricola_conf_propos,
             cod_matricola_inserente,
             cod_microtipologia_delib,
             cod_microtipologia_host,
             cod_ndg,
             'SOVRASCRITTA',
             --  INDICA  LA CI PRESENTE SULLA DELIBERE CHE S STATA SOVRASCRITTA
             cod_organo_calcolato,
             cod_organo_deliberante,
             cod_organo_deliberato,
             cod_organo_pacchetto,
             cod_pratica,
             cod_protocollo_delibera,
             cod_protocollo_delibera_col,
             cod_protocollo_pacchetto,
             cod_sag,
             cod_segmento,
             cod_sndg,
             cod_stato_proposta,
             cod_stato_proposto,
             cod_stato_provenienza,
             cod_stato_sag,
             cod_tipo_pacchetto,
             cod_tipo_proposta,
             cod_tipo_transazione,
             cod_uo_pratica,
             cod_uo_proponente,
             cod_uo_proposta,
             desc_anag_deliberante,
             desc_anag_proponente,
             desc_denominaz_ins_delibera,
             desc_garanzie_accanton,
             desc_liv_last_delib_fido,
             desc_modal_conferma_sag,
             desc_motivo_pass_rischio,
             desc_note,
             desc_note_annullo_prop,
             desc_note_coerenza,
             desc_note_delibere_annullate,
             desc_note_forzatura,
             desc_note_garanzie_prestate,
             desc_note_garanzie_ricevute,
             desc_note_rdv,
             desc_note_rischi,
             desc_note_urg,
             desc_parere_sndg,
             desc_ramo_affari,
             desc_rischi_indiretti,
             desc_secondo_referente,
             desc_tipo_conferma_delibera,
             desc_tipo_gestione,
             dta_accensione_prop_rischio,
             dta_calc_conf_sag,
             dta_conferma_delibera,
             dta_conferma_pacchetto,
             SYSDATE,
             ---indica data di spostamento
             dta_consolid_prop_org_vig,
             dta_creazione_pacchetto,
             dta_delib_prop_da_deliberante,
             dta_delib_prop_da_proponente,
             dta_delibera,
             dta_delibera_estero,
             dta_ingresso_rdv_servizio,
             dta_inizio_rapporto_cliente,
             dta_ins,
             dta_ins_delibera,
             dta_last_delibera_fido,
             dta_last_upd_delibera,
             dta_motivo_pass_rischio,
             dta_revoca_fido_in_essere,
             dta_rif_dati_contabili,
             dta_scadenza,
             dta_scadenza_estero,
             dta_scadenza_transaz,
             dta_superam_stato_rischio,
             dta_trasfer_propo_fil_area,
             dta_udienza_ver_cred,
             dta_upd,
             dta_upd_fase_delibera,
             dta_upd_fase_microtipologia,
             dta_upd_fase_pacchetto,
             flg_100,
             flg_affidam_soc_recupero,
             flg_art_136,
             flg_attiva,
             flg_avviso_ex498cpc,
             flg_beni_non_in_garanzia,
             flg_cancellaz_proposta,
             flg_conti_categ_2000,
             flg_delib_in_linea,
             flg_depositi_collaterali,
             flg_disposizione,
             flg_esist_debitore_sotto_proc,
             flg_fondo_terzi,
             flg_forz_man_gest_interna,
             flg_garanzie_con_fidi,
             flg_garanzie_genworth,
             flg_garanzie_sace,
             flg_garanzie_sgfa,
             flg_interven_organi_superiori,
             flg_ipoteche_beni_deb_gar,
             flg_libretti_portatore_minori,
             flg_no_colleg_altre_pos,
             flg_no_delibera,
             flg_no_garanzie_capienti,
             flg_no_patrimon_aggred,
             flg_no_presupposti_class_soff,
             flg_no_rischi_firma,
             flg_parti_correlate,
             flg_perdur_difficolta_econ,
             flg_pignoramenti_immobiliari,
             flg_pignoramenti_mobiliari,
             flg_pignoramenti_terzi,
             flg_pratica_urg,
             flg_presen_covenants,
             flg_protesti,
             flg_rapporti_bloccati,
             flg_rapporti_con_depos_titoli,
             flg_rapporti_garanzia_cred_fir,
             flg_rapporto_concordato_preven,
             flg_soggetto_pot_fallibile,
             flg_to_copy,
             flg_visionato,
             id_dper,
             indirizzo_email,
             note_last_delib_fido,
             num_tel_secondo_referente,
             num_telefono,
             val_accordato,
             val_accordato_derivati,
             val_anno_pratica,
             val_anno_proposta,
             val_esp_lorda,
             val_esp_lorda_capitale,
             val_esp_lorda_mora,
             val_esp_netta_ante_delib,
             val_esp_netta_post_delib,
             val_esp_tot_cassa,
             val_imp_crediti_firma,
             val_imp_fondi_terzi,
             val_imp_fondi_terzi_nb,
             val_imp_offerto,
             val_imp_perdita,
             val_imp_utilizzo,
             val_interessi_futuri,
             val_interessi_mora_cassa,
             val_num_progr_delibera,
             val_perc_dubbio_esito,
             val_perc_perd_rm,
             val_perc_rdv,
             val_perc_rdv_estero,
             val_perdita_attuale,
             val_perdita_deliberata,
             val_progr_proposta,
             val_rdv_delib_banca_rete,
             val_rdv_extra_delibera,
             val_rdv_qc_ante_delib,
             val_rdv_qc_deliberata,
             val_rdv_qc_progressiva,
             val_rdv_quota_mora,
             val_rinuncia_capitale,
             val_rinuncia_deliberata,
             val_rinuncia_mora,
             val_rinuncia_proposta,
             val_rischi_indiretti,
             val_sacrif_capit_mora,
             val_stralcio_quota_cap,
             val_stralcio_quota_mora,
             val_stralcio_senza_accantonam,
             val_tasso_base_appl,
             val_uti_cassa_scsb,
             val_uti_firma_scsb,
             val_uti_netto_fondo_terzi,
             val_uti_sosti_scsb,
             val_uti_tot_gegb,
             val_uti_tot_scsb
        FROM t_mcrei_app_delibere d
       WHERE d.cod_abi = p_abi
         AND d.cod_ndg = p_ndg
         AND d.cod_microtipologia_delib = p_microtipol
         AND d.flg_attiva = '1'
         AND d.cod_protocollo_pacchetto = p_proto_pac
         AND d.cod_protocollo_delibera = p_proto_delib;

    ---poi cancello dalla pareri gli eventuali pareri legati alla proposta
    ---che S stata spostata (li ricavo tramite protocollo_delibera,abi e ndg)

    ----> DELETE pareri...
    DELETE t_mcrei_app_pareri e
     WHERE e.cod_abi = p_abi
       AND e.cod_ndg = p_ndg
       AND e.flg_attiva = '1'
       AND e.cod_protocollo_delibera = p_proto_delib;

-- p_note:'sovrascrivo i dati della delibera esistente con quelli dell''incaglio automatico';
    -- poi aggiorno la tabella delle delibere sovrascrivendo i campi della proposta
    -- con quelli provenienti da incaglio automatico
    /* Formatted on 07/01/2013 17.10.55 (QP5 v5.163.1008.3004) */
MERGE INTO t_mcrei_app_delibere t
     USING (SELECT id_dper,
                   cod_abi,
                   cod_sndg,
                   cod_ndg,
                   val_anno_proposta,
                   val_progr_proposta,
                   cod_protocollo_delibera,
                   cod_stato_proposto,
                   dta_accensione_prop_rischio,
                   dta_superam_stato_rischio,
                   desc_anag_proponente,
                   dta_delib_prop_da_deliberante,
                   desc_anag_deliberante,
                   dta_delib_prop_da_proponente,
                   cod_uo_proponente,
                   dta_inizio_rapporto_cliente,
                   desc_ramo_affari,
                   dta_last_delibera_fido,
                   note_last_delib_fido,
                   desc_liv_last_delib_fido,
                   dta_revoca_fido_in_essere,
                   desc_rischi_indiretti,
                   desc_garanzie_accanton,
                   val_perc_dubbio_esito,
                   dta_consolid_prop_org_vig,
                   cod_matricola_conf_propos,
                   flg_disposizione,
                   val_accordato,
                   val_imp_utilizzo,
                  val_esp_lorda_capitale,
                   val_esp_lorda_mora,
                   val_imp_fondi_terzi,
                   val_imp_fondi_terzi_nb,
                   val_imp_crediti_firma,
                   val_esp_lorda,
                   cod_intest_sched_gen,
                   cod_uo_proposta,
                   flg_cancellaz_proposta,
                   val_interessi_mora_cassa,
                   val_esp_tot_cassa,
                   desc_note_annullo_prop,
                   dta_ins_delibera,
                   dta_trasfer_propo_fil_area,
                   DECODE (cod_tipo_proposta, 'S', 'CS', 'CI')
                      AS cod_microtipologia_delib,
                   CASE
                      WHEN cod_tipo_proposta = 'S' THEN 'SO'
                      WHEN cod_tipo_proposta = 'E' THEN 'IN'
                      ELSE NULL
                   END
                      cod_stato_pro,
                   cod_tipo_proposta,
--                   DECODE (cod_stato_proposto,
--                           'S', 'INS',
--                           'B', 'CNF',
--                           'INS')
--                      AS COD_FASE_MICROTIPOLOGIA,
                   'CA'  AS COD_FASE_DELIBERA    ----AD 20 marzo: la fase della delibera ? posta in condizione di essere poi lavorata dal job che la mattina dopo aggiorna le fasi a cascata
                  -- 'ULT' AS cod_fase_pacchetto     ELIMINATO IL 20/3
              FROM t_mcrei_st_proposte
             WHERE     id_dper = p_iddper
                   AND cod_abi = p_abi
                   AND cod_ndg = p_ndg
                   AND COD_PROTOCOLLO_PACCHETTO IS NULL) s
        ON (    s.cod_abi = t.cod_abi
            AND s.cod_ndg = t.cod_ndg
            and t.cod_protocollo_pacchetto =p_proto_pac
            --AND T.cod_protocollo_delibera = p_proto_delib
           -- AND s.val_anno_proposta = t.val_anno_proposta
           -- AND s.val_progr_proposta = t.val_progr_proposta
            --AND s.cod_protocollo_delibera = t.cod_protocollo_delibera : il protoocllo_delibera se arriva da filiale non ha lo stesso formato di quello nato da noi ----> 14 feb
            AND T.COD_MICROTIPOLOGIA_DELIB = p_microtipol
           -- AND T.COD_PROTOCOLLO_DELIBERA = p_proto_delib
           )
WHEN MATCHED
THEN
   UPDATE SET
      t.cod_protocollo_delibera = lpad(s.val_anno_proposta, 6, '0') ||lpad(s.val_progr_proposta, 11, '0'), --proto_Delibera
      t.ID_DPER = s.ID_DPER,
      t.COD_SNDG = S.COD_SNDG,
      t.COD_STATO_PROPOSTA = s.COD_STATO_PROPOSTO,
      t.COD_STATO_PROPOSTO = s.cod_stato_pro,
      t.DTA_ACCENSIONE_PROP_RISCHIO = s.DTA_ACCENSIONE_PROP_RISCHIO,
      t.DTA_SUPERAM_STATO_RISCHIO = s.DTA_SUPERAM_STATO_RISCHIO,
      t.DESC_ANAG_PROPONENTE = s.DESC_ANAG_PROPONENTE,
      t.DTA_DELIB_PROP_DA_DELIBERANTE = s.DTA_DELIB_PROP_DA_DELIBERANTE,
      t.DESC_ANAG_DELIBERANTE = s.DESC_ANAG_DELIBERANTE,
      t.DTA_DELIB_PROP_DA_PROPONENTE = s.DTA_DELIB_PROP_DA_PROPONENTE,
      t.COD_UO_PROPONENTE = s.COD_UO_PROPONENTE,
      t.DTA_INIZIO_RAPPORTO_CLIENTE = s.DTA_INIZIO_RAPPORTO_CLIENTE,
      t.DESC_RAMO_AFFARI = s.DESC_RAMO_AFFARI,
      t.DTA_LAST_DELIBERA_FIDO = s.DTA_LAST_DELIBERA_FIDO,
      t.NOTE_LAST_DELIB_FIDO = s.NOTE_LAST_DELIB_FIDO,
      t.DESC_LIV_LAST_DELIB_FIDO = s.DESC_LIV_LAST_DELIB_FIDO,
      t.DTA_REVOCA_FIDO_IN_ESSERE = s.DTA_REVOCA_FIDO_IN_ESSERE,
      t.DESC_RISCHI_INDIRETTI = s.DESC_RISCHI_INDIRETTI,
      t.DESC_GARANZIE_ACCANTON = s.DESC_GARANZIE_ACCANTON,
      t.VAL_PERC_DUBBIO_ESITO = s.VAL_PERC_DUBBIO_ESITO,
      t.DTA_CONSOLID_PROP_ORG_VIG = s.DTA_CONSOLID_PROP_ORG_VIG,
      t.COD_MATRICOLA_CONF_PROPOS = s.COD_MATRICOLA_CONF_PROPOS,
      t.FLG_DISPOSIZIONE = s.FLG_DISPOSIZIONE,
      t.VAL_ACCORDATO = s.VAL_ACCORDATO,
      t.VAL_IMP_UTILIZZO = s.VAL_IMP_UTILIZZO,
      t.VAL_ESP_LORDA_CAPITALE = s.VAL_ESP_LORDA_CAPITALE,
      t.VAL_ESP_LORDA_MORA = s.VAL_ESP_LORDA_MORA,
      t.VAL_IMP_FONDI_TERZI = s.VAL_IMP_FONDI_TERZI,
      t.VAL_IMP_FONDI_TERZI_NB = s.VAL_IMP_FONDI_TERZI_NB,
      t.VAL_IMP_CREDITI_FIRMA = s.VAL_IMP_CREDITI_FIRMA,
      t.VAL_ESP_LORDA = s.VAL_ESP_LORDA,
      t.COD_INTEST_SCHED_GEN = s.COD_INTEST_SCHED_GEN,
      t.COD_UO_PROPOSTA = s.COD_UO_PROPOSTA,
      t.FLG_CANCELLAZ_PROPOSTA = s.FLG_CANCELLAZ_PROPOSTA,
      t.VAL_INTERESSI_MORA_CASSA = s.VAL_INTERESSI_MORA_CASSA,
      t.VAL_ESP_TOT_CASSA = s.VAL_ESP_TOT_CASSA,
      t.DESC_NOTE_ANNULLO_PROP = s.DESC_NOTE_ANNULLO_PROP,
      t.DTA_INS_DELIBERA = s.DTA_INS_DELIBERA,
      t.DTA_TRASFER_PROPO_FIL_AREA = s.DTA_TRASFER_PROPO_FIL_AREA,
      t.DTA_UPD = SYSDATE,
      --t.DTA_DELIBERA = s.dta_delib_prop_da_proponente,
      t.DTA_CONFERMA_DELIBERA =
         NVL (s.dta_consolid_prop_org_vig, s.dta_accensione_prop_rischio),
      t.DTA_LAST_UPD_DELIBERA =
         NVL (s.dta_consolid_prop_org_vig, s.dta_accensione_prop_rischio),
      t.DTA_DELIBERA_ESTERO = TO_DATE ('00010101', 'yyyymmdd'),
      t.DTA_SCADENZA = TO_DATE ('99991231', 'yyyymmdd'),
      t.DTA_SCADENZA_ESTERO = TO_DATE ('99991231', 'yyyymmdd'),
      t.DTA_SCADENZA_TRANSAZ = TO_DATE ('99991231', 'yyyymmdd'),
      t.cod_tipo_proposta = s.cod_tipo_proposta,
     -- T.COD_FASE_MICROTIPOLOGIA = S.COD_FASE_MICROTIPOLOGIA,
      T.COD_FASE_DELIBERA = S.COD_FASE_DELIBERA,
--      T.DTA_CONFERMA_PACCHETTO =     PACCHETTO è GIà CONFERMATO SE STO SOVRASCRIVENDO LA PROPOSTA CON L'INCAGLIO AUTOMATICO ARRIVATO
--         NVL (s.dta_consolid_prop_org_vig, s.dta_accensione_prop_rischio),
      --T.COD_FASE_PACCHETTO = S.COD_FASE_PACCHETTO,
--      t.COD_DOC_APPENDICE_PARERE = NULL,
--      t.COD_DOC_CLASSIFICAZIONE = NULL,
        t.COD_DOC_DELIBERA_BANCA = NULL,
--      t.COD_DOC_DELIBERA_CAPOGRUPPO = NULL,
--      t.COD_DOC_PARERE_CONFORMITA = NULL,
      t.desc_note = 'Conferma automatica per incaglio generato automaticamente',
      T.VAL_PROGR_PROPOSTA = S.val_progr_proposta,   ---sbianco documenti e li rigenero
     T.VAL_ANNO_PROPOSTA = S.VAL_ANNO_PROPOSTA;

    RETURN 1;
  EXCEPTION
    WHEN OTHERS THEN
      pkg_mcrei_audit.log_app(c_nome,
                              pkg_mcrei_audit.c_error,
                              SQLCODE,
                              SQLERRM,
                              p_note,
                              NULL);
      ROLLBACK;
      RETURN 0;
  END;

  -- %author Reply
  -- %version 0.1
  -- %usage  Funzione che crea un pacchetto automatico in base al tipo di classificazione in input
  -- %d La funzione crea un pacchetto monotipologia/monodelibera in stato confermato
  -- %d importando i dati di una proposta ricevuta automaticamente
  -- %cd 26 gen 2012
  -- %param p_progres_proposta
  -- %param p_anno_propost
  -- %param p_idper
  FUNCTION scarta_proposta_automatica(p_progres_proposta NUMBER,
                                      p_anno_propost     NUMBER,
                                      p_idper            NUMBER,
                                      P_CODABI          VARCHAR2,
                                      P_CODNDG          VARCHAR2)
    RETURN NUMBER IS


      c_nome CONSTANT VARCHAR2(100) := c_package || '.scarta_proposta_automatica';
    p_note   t_mcrei_wrk_audit_applicativo.note%TYPE;


    BEGIN
        p_note:= 'archiviazione proposta esistente in tabella di audit';
    INSERT INTO t_mcrei_audit_classif_autom
      (cod_abi,
       cod_ndg,
       cod_sndg,
       cod_intest_sched_gen,
       cod_matricola_conf_propos,
       cod_stato_proposto,
       cod_tipo_proposta,
       cod_uo_proponente,
       cod_uo_proposta,
       desc_anag_deliberante,
       desc_anag_proponente,
       desc_garanzie_accanton,
       desc_liv_last_delib_fido,
       desc_note_annullo_prop,
       desc_ramo_affari,
      desc_rischi_indiretti,
       dta_accensione_prop_rischio,
       dta_consolid_prop_org_vig,
       dta_delib_prop_da_deliberante,
       dta_delib_prop_da_proponente,
       dta_inizio_rapporto_cliente,
       dta_ins_delibera,
       dta_last_delibera_fido,
       dta_revoca_fido_in_essere,
       dta_superam_stato_rischio,
       dta_trasfer_propo_fil_area,
       flg_cancellaz_proposta,
       flg_disposizione,
       id_dper,
       note_last_delib_fido,
       val_accordato,
       val_anno_proposta,
       val_accordato_derivati,
       val_esp_lorda,
       val_esp_lorda_capitale,
       val_esp_lorda_mora,
       val_esp_tot_cassa,
       val_imp_crediti_firma,
       val_imp_fondi_terzi,
       val_imp_fondi_terzi_nb,
       val_imp_utilizzo,
       val_interessi_mora_cassa,
       val_perc_dubbio_esito,
       val_progr_proposta,
       dta_congelamento,
       cod_operatore_ins_upd,
       COD_PROTOCOLLO_DELIBERA)
      SELECT cod_abi,
             cod_ndg,
             cod_sndg,
             cod_intest_sched_gen,
             cod_matricola_conf_propos,
             cod_stato_proposto,
             cod_tipo_proposta,
             cod_uo_proponente,
             cod_uo_proposta,
             desc_anag_deliberante,
             desc_anag_proponente,
             desc_garanzie_accanton,
             desc_liv_last_delib_fido,
             desc_note_annullo_prop,
             desc_ramo_affari,
             desc_rischi_indiretti,
             dta_accensione_prop_rischio,
             dta_consolid_prop_org_vig,
             dta_delib_prop_da_deliberante,
             dta_delib_prop_da_proponente,
             dta_inizio_rapporto_cliente,
             dta_ins_delibera,
             dta_last_delibera_fido,
             dta_revoca_fido_in_essere,
             dta_superam_stato_rischio,
             dta_trasfer_propo_fil_area,
             flg_cancellaz_proposta,
             flg_disposizione,
             id_dper,
             note_last_delib_fido,
             val_accordato,
            val_anno_proposta,
             val_derivati,
             val_esp_lorda,
             val_esp_lorda_capitale,
             val_esp_lorda_mora,
             val_esp_tot_cassa,
             val_imp_crediti_firma,
             val_imp_fondi_terzi,
             val_imp_fondi_terzi_nb,
             val_imp_utilizzo,
             val_interessi_mora_cassa,
             val_perc_dubbio_esito,
             val_progr_proposta,
             SYSDATE,
             'AUTOMATICA_SCARTATA', --28/2
             COD_PROTOCOLLO_DELIBERA
        FROM t_mcrei_st_proposte p
       WHERE p.val_progr_proposta = p_progres_proposta
         AND p.val_anno_proposta = p_anno_propost
         AND id_dper = p_idper
         AND COD_NDG =P_CODNDG
         AND COD_ABI = P_CODABI;

    RETURN 1;
  EXCEPTION
    WHEN dup_val_on_index
            THEN
                NULL; ---se esiste gi? la proposta archiviata, non si fa nulla
      RETURN 0;
        WHEN OTHERS THEN
      p_note:= 'Fallita archiviazione proposta esistente in tabella di audit';
            pkg_mcrei_audit.log_app(c_nome,
                              pkg_mcrei_audit.c_error,
                              SQLCODE,
                              SQLERRM,
                              p_note,
                              NULL);
            ROLLBACK;
      RETURN 0;
  END scarta_proposta_automatica;

  -- FUNZIONE USATA DA VISTA V_MCREI_APP_INFO_PER_CALC_OD
  FUNCTION fnc_mcrei_get_max_rdv_in(v_cod_abi  IN VARCHAR2,
                                    v_cod_ndg  IN VARCHAR2,
                                    v_cod_fase IN VARCHAR2) RETURN NUMBER IS
    v_retval NUMBER;
  BEGIN
    CASE
      WHEN v_cod_fase = 'CO' THEN
      SELECT rdv
          INTO v_retval
          FROM (SELECT nvl(VAL_RDV_PREGR_FI, 0) + nvl(d.VAL_RDV_QC_ANTE_DELIB, 0) AS rdv
                  FROM t_mcrei_app_delibere d
                 WHERE cod_abi = V_COD_ABI
                   AND cod_ndg = V_COD_NDG
                  -- AND cod_fase_delibera = 'CO'  ---commentato il 9 nov AD
                   AND cod_microtipologia_delib in ('A0','T4','RV','IM')
                   AND flg_no_delibera = '0'
                   AND FLG_ATTIVA = '1'
                 ORDER BY --dta_conferma_delibera  DESC NULLS LAST,
                          val_num_progr_delibera DESC NULLS LAST)---legge dalla delibera corrente
         WHERE rownum = 1;

      WHEN v_cod_fase IN ('CM') THEN---> inserita
        SELECT rdv
          INTO v_retval
          FROM (     SELECT NVL(VAL_RDV_PROGR_FI,0) - NVL(VAL_RDV_PREGR_FI,0) +
                       NVL(VAL_RDV_QC_PROGRESSIVA,0) - NVL(VAL_RDV_QC_ANTE_DELIB,0) RDV
                  FROM t_mcrei_app_delibere d
                 WHERE cod_abi = V_COD_ABI
                   AND cod_ndg = V_COD_NDG
                   --AND cod_fase_delibera = 'CM'
                   AND flg_no_delibera = '0'
                   AND FLG_ATTIVA = '1'
                   AND COD_MICROTIPOLOGIA_DELIB IN ('A0', 'T4', 'IM','RV')
                   and dta_CONFERMA_DELIBERA IS NULL
                   AND COD_FASE_DELIBERA != 'AN'
                 ORDER BY val_num_progr_delibera DESC,
                          dta_ins_delibera desc nulls last)
         WHERE rownum = 1;

    ELSE -- FASE NON GESTITA
        RETURN - 1;
    END CASE;

    RETURN v_retval;
  EXCEPTION
    WHEN OTHERS THEN
      RETURN NULL;
  END fnc_mcrei_get_max_rdv_in;

  -- FUNZIONE USATA DA VISTA V_MCREI_APP_INFO_PER_CALC_OD
  FUNCTION fnc_mcrei_get_max_rdv(v_cod_abi                  IN VARCHAR2,
                                 v_cod_ndg                  IN VARCHAR2,
                                 v_cod_fase                 IN VARCHAR2,
                                 v_cod_protocollo_pacchetto IN VARCHAR2 DEFAULT NULL)
    RETURN NUMBER IS
    v_retval NUMBER;
    v_add    NUMBER;

    CURSOR c_pac IS
      SELECT DISTINCT cod_abi,
                      cod_ndg
        FROM t_mcrei_app_delibere
       WHERE cod_protocollo_pacchetto = v_cod_protocollo_pacchetto;
--         AND cod_fase_delibera = v_cod_fase;
  BEGIN
    IF v_cod_abi = '01025'
    THEN
      v_retval := 0;

      FOR r_pac IN c_pac
      LOOP
        BEGIN
          v_add := fnc_mcrei_get_max_rdv_in(r_pac.cod_abi,
                                            r_pac.cod_ndg,
                                            v_cod_fase);

          IF v_add IS NOT NULL
          THEN
            v_retval := v_retval + v_add;
          END IF;
        EXCEPTION
          WHEN OTHERS THEN
            v_add := 0;
        END;
      END LOOP;
    ELSE
      --- cod_abi != '01025'
      v_retval := fnc_mcrei_get_max_rdv_in(v_cod_abi, v_cod_ndg, v_cod_fase);
    END IF;

    RETURN v_retval;
  EXCEPTION
    WHEN OTHERS THEN
      RETURN NULL;
  END fnc_mcrei_get_max_rdv;

  -- FUNZIONE USATA DA VISTA V_MCREI_APP_INFO_PER_CALC_OD
  FUNCTION fnc_mcrei_get_sum_rin(v_cod_abi                  IN VARCHAR2,
                                 v_cod_ndg                  IN VARCHAR2,
                                 v_cod_fase                 IN VARCHAR2,
                                 v_cod_protocollo_pacchetto IN VARCHAR2)
    RETURN NUMBER IS
    v_retval NUMBER;
    v_add    NUMBER;

    CURSOR c_pac IS
      SELECT DISTINCT cod_abi,
                      cod_ndg
        FROM t_mcrei_app_delibere
       WHERE cod_protocollo_pacchetto = v_cod_protocollo_pacchetto
         AND cod_fase_delibera = v_cod_fase;
  BEGIN
    IF v_cod_abi = '01025'
    THEN
      v_retval := 0;

      FOR r_pac IN c_pac
      LOOP
        BEGIN
          SELECT nvl(SUM(rin), 0)
            INTO v_add
            FROM (SELECT decode(v_cod_fase,
                                'CT',
                                val_sacrif_capit_mora,
                                val_imp_perdita) AS rin
                    FROM t_mcrei_app_delibere
                   WHERE cod_abi = r_pac.cod_abi
                     AND cod_ndg = r_pac.cod_ndg
                     AND cod_fase_delibera = v_cod_fase
                     AND flg_no_delibera = '0');

          v_retval := v_retval + v_add;
        EXCEPTION
          WHEN OTHERS THEN
            v_add := 0;
        END;
      END LOOP;
    ELSE
      SELECT nvl(SUM(rin), 0)
        INTO v_retval
        FROM (SELECT decode(v_cod_fase,
                            'CT',
                            val_sacrif_capit_mora,
                            val_imp_perdita) AS rin
                FROM t_mcrei_app_delibere
               WHERE cod_abi = v_cod_abi
                 AND cod_ndg = v_cod_ndg
                 AND cod_fase_delibera = v_cod_fase
                 AND flg_no_delibera = '0'
                 AND FLG_ATTIVA = '1'
);
    END IF;

    RETURN v_retval;
  EXCEPTION
    WHEN OTHERS THEN
      RETURN NULL;
  END fnc_mcrei_get_sum_rin;

  FUNCTION fnc_mcrei_get_sum_utilizzati(v_cod_abi VARCHAR2,
                                        v_cod_ndg VARCHAR2,
                                        v_cod_pac VARCHAR2) RETURN NUMBER IS
    v_retval NUMBER;
    v_add    NUMBER;

    CURSOR c_pac IS
      SELECT DISTINCT cod_abi,
                      cod_ndg
        FROM t_mcrei_app_delibere
       WHERE cod_protocollo_pacchetto = v_cod_pac
         AND COD_FASE_DELIBERA != 'AN'
         AND FLG_ATTIVA = '1';
  BEGIN
    IF v_cod_abi = '01025'
    THEN
      v_retval := 0;

      FOR r_pac IN c_pac
      LOOP
        BEGIN
          SELECT pcr.scsb_uti_cassa
            INTO v_add
            FROM t_mcrei_app_pcr_rapp_aggr pcr
           WHERE pcr.cod_abi_cartolarizzato = r_pac.cod_abi
             AND pcr.cod_ndg = r_pac.cod_ndg;

          v_retval := v_retval + v_add;
        EXCEPTION
          WHEN OTHERS THEN
            v_add := 0;
        END;
      END LOOP;
    ELSE
      SELECT pcr.scsb_uti_cassa
        INTO v_retval
        FROM t_mcrei_app_pcr_rapp_aggr pcr
       WHERE pcr.cod_abi_cartolarizzato = v_cod_abi
         AND pcr.cod_ndg = v_cod_ndg;
    END IF;

    RETURN v_retval;
  EXCEPTION
    WHEN OTHERS THEN
      RETURN NULL;
  END fnc_mcrei_get_sum_utilizzati;

  -- %author Reply
  -- %version 0.1
  -- %usage  recupero rinuncia pregressa (contabilizzata, inserita o confermata)
  -- %cd 4 mag 2012
FUNCTION fnc_mcrei_get_last_rinuncia(p_abi      VARCHAR2,
                                     p_ndg      VARCHAR2,
                                     p_cod_fase IN VARCHAR2) RETURN NUMBER IS
  v_imp_perdita NUMBER;

BEGIN

  CASE
    WHEN p_cod_fase = 'CT' THEN

      ---RECUPERA IL VALORE DELL'ULTIMA RINUNCIA CONTABILIZZATA
      BEGIN
        SELECT val_imp_perdita
          INTO v_imp_perdita
          FROM (SELECT nvl(s.val_sacrif_capit_mora, 0) AS val_imp_perdita
                  FROM t_mcrei_app_delibere s
                 WHERE s.cod_abi = p_abi
                   AND s.cod_ndg = p_ndg
                   AND s.cod_fase_delibera IN ('CT')
                   AND flg_attiva = '1'
                 ORDER BY s.dta_conferma_delibera  DESC,
                          s.val_num_progr_delibera DESC)
         WHERE rownum <= 1;
      EXCEPTION
        WHEN no_data_found THEN
          v_imp_perdita := NULL;
      END;
    WHEN p_cod_fase = 'CO' THEN

      BEGIN
        SELECT val_imp_perdita
          INTO v_imp_perdita
          FROM (SELECT nvl(val_rinuncia_totale, 0) AS val_imp_perdita
                  FROM t_mcrei_app_delibere s
                 WHERE s.cod_abi = p_abi
                   AND s.cod_ndg = p_ndg
                   AND s.cod_fase_delibera IN ('CO')
                   AND flg_attiva = '1'
                 ORDER BY s.dta_conferma_delibera  DESC,
                          s.val_num_progr_delibera DESC)
         WHERE rownum <= 1;
      EXCEPTION
        WHEN no_data_found THEN
          v_imp_perdita := NULL;
      END;

    WHEN p_cod_fase = 'CM' THEN
      BEGIN
        SELECT val_imp_perdita
          INTO v_imp_perdita
          FROM (SELECT nvl(val_rinuncia_totale, 0) AS val_imp_perdita
                  FROM t_mcrei_app_delibere s
                 WHERE s.cod_abi = p_abi
                   AND s.cod_ndg = p_ndg
                   AND s.cod_fase_delibera IN ('CM')
                   AND flg_attiva = '1'
                 ORDER BY s.dta_last_upd_delibera  DESC,
                          s.val_num_progr_delibera DESC)
         WHERE rownum <= 1;
      EXCEPTION
        WHEN no_data_found THEN
          v_imp_perdita := NULL;
      END;
    ELSE
      v_imp_perdita := NULL;
  END CASE;

  RETURN v_imp_perdita;
EXCEPTION
  WHEN OTHERS THEN
    RETURN NULL;
END fnc_mcrei_get_last_rinuncia;

  -- %author Reply
  -- %version 0.1
  -- %usage  Function che recupera lo stralcio contabilizzato per la posizione in input
  -- %cd 17/04/2012
  FUNCTION fnc_mcrei_get_stralci_ct(p_abi VARCHAR2, p_ndg VARCHAR2)
    RETURN NUMBER IS

    v_stralcio_ct NUMBER;

  BEGIN

    ---RECUPERA IL VALORE DELL'ULTIMA RINUNCIA CONTABILIZZATA --0806 se da Mople, ho solo sacrificio totale
    SELECT DISTINCT  SUM( nvl(s.val_sacrif_capit_mora,0)--28/08 aggiunta gestione campo per rinunce fatte su mople
        ) over(PARTITION BY cod_abi, cod_ndg)    AS stralci_ct
      INTO v_stralcio_ct
      FROM t_mcrei_app_delibere s
     WHERE s.cod_abi = p_abi
       AND s.cod_ndg = p_ndg
       AND s.cod_fase_delibera IN ('CT');

    RETURN v_stralcio_ct;
  EXCEPTION
    WHEN OTHERS THEN
      RETURN NULL;
  END fnc_mcrei_get_stralci_ct;

  -- %author Reply
  -- %version 0.1
  -- %usage  Funzione che verifica l'esistenza di un pacchetto non ancora confermato per l'abi, ndg e microtipologia in input
  -- %usage (da usare nella gestione automatica degli incagli)
  -- %d  La funzione, per l'abi, ndg, e microtipologia in input, verifica l'esistenza di un eventuale
  -- %d  pacchetto ancora aperto. Se esiste, ne restituisce il protocollo,in caso contrario
  -- %d  restituisce NULL
  -- %cd 6 giu 2012
  -- %param P_COD_SNDG SNDG
  -- %param P_MICROTIPOLOG microtipologia pacchetto
  FUNCTION ctrl_esist_pacc_aperto_sndg(p_cod_sndg          IN VARCHAR2,
                                  p_microtipolog IN VARCHAR2) RETURN VARCHAR2 IS
    c_nome CONSTANT VARCHAR2(100) := c_package || '.ctrl_esist_pacc_aperto_sndg';
    v_protoc t_mcrei_app_delibere.cod_protocollo_pacchetto%TYPE;
    p_note   t_mcrei_wrk_audit_applicativo.note%TYPE;
  BEGIN
    v_protoc := NULL;
    p_note   := 'Controlla esistenza pacchetto aperto per sndg e microtipologia delibera';

    IF p_cod_sndg IS NULL OR
       p_microtipolog IS NULL
    THEN
      raise_application_error(-20666, 'Null parameter');
    END IF;

    BEGIN
      p_note := 'Controllo esistenza in tabella T_MCREI_APP_DELIBERE';

      SELECT d.cod_protocollo_pacchetto
        INTO v_protoc --PROTOCOLLO DI UN PACCHETTO aperto
        FROM t_mcrei_app_delibere d
       WHERE d.cod_sndg = p_cod_sndg
         AND d.cod_microtipologia_delib = p_microtipolog
         AND cod_fase_pacchetto NOT IN ('ANA', 'ANM', 'ULT') --PACCHETTO IN FASE DI ELABORAZIONE
         AND flg_attiva = '1'
         AND rownum = 1;

      pkg_mcrei_audit.log_app(c_nome,
                              pkg_mcrei_audit.c_debug,
                              SQLCODE,
                              SQLERRM,
                              p_note,
                              NULL);
      RETURN v_protoc;
    EXCEPTION
      WHEN no_data_found THEN
        RETURN v_protoc;
    END;
  EXCEPTION
    WHEN OTHERS THEN
      pkg_mcrei_audit.log_app(c_nome,
                              pkg_mcrei_audit.c_error,
                              SQLCODE,
                              SQLERRM,
                              p_note,
                              NULL);
      RETURN 0; ---ko
  END ctrl_esist_pacc_aperto_sndg;

FUNCTION CNTRL_ESIST_DELIB(P_COD_ABI           IN VARCHAR2,
                            P_COD_NDG           IN VARCHAR2,
                            P_MICROTIP          IN VARCHAR2,
                            P_PROTO_PACCHETTO   IN VARCHAR2) RETURN varchar2 IS
c_nome CONSTANT VARCHAR2(100) := c_package || '.CNTRL_ESIST_DELIB';
    V_RET       NUMBER;
    p_note      t_mcrei_wrk_audit_applicativo.note%TYPE;
    V_PROTOC  T_MCREI_APP_DELIBERE.COD_PROTOCOLLO_DELIBERA%TYPE:=NULL;
  BEGIN
    v_protoc := NULL;
    p_note   := 'Controlla esistenza delibera per abi, ndg e microtipologia delibera e pacchetto';

    IF p_cod_ABI IS NULL OR
       P_COD_NDG IS NULL OR
       p_microtip IS NULL or
       p_proto_pacchetto IS NULL
    THEN
      raise_application_error(-20666, 'Null parameter');
    END IF;

    BEGIN
      p_note := 'Controllo esistenza in tabella T_MCREI_APP_DELIBERE';

      SELECT D.COD_PROTOCOLLO_DELIBERA
        INTO V_PROTOC --PROTOCOLLO DI UN PACCHETTO aperto
        FROM t_mcrei_app_delibere d
       WHERE D.COD_ABI = P_COD_ABI
         AND d.cod_ndg = p_cod_ndg
         AND d.cod_microtipologia_delib = p_microtip
         AND D.COD_PROTOCOLLO_PACCHETTO = P_PROTO_PACCHETTO
         AND cod_fase_pacchetto NOT IN ('ANA', 'ANM', 'ULT') --PACCHETTO IN FASE DI ELABORAZIONE
         AND flg_attiva = '1'
         AND rownum = 1;

      pkg_mcrei_audit.log_app(c_nome,
                              pkg_mcrei_audit.c_debug,
                              SQLCODE,
                              SQLERRM,
                              p_note,
                              NULL);

      RETURN V_PROTOC;
    EXCEPTION
      WHEN no_data_found THEN
        RETURN NULL;
    END;
  EXCEPTION
    WHEN OTHERS THEN
      pkg_mcrei_audit.log_app(c_nome,
                              pkg_mcrei_audit.c_error,
                              SQLCODE,
                              SQLERRM,
                              p_note,
                              NULL);
      RETURN NULL; ---ko
  END CNTRL_ESIST_DELIB;

    -- %author Reply
  -- %version 0.1
  -- %usage  Funzione che, data la posizione o l'sndg in input, restituisce il flag di abilitazione o meno alla rdv light post-impianto
  -- %d Se p_sndg is not null, verifica se esiste almeno un ndg associato che presenti come ultima delibera un IM o IF. Se si, restituisce Y, altrimenti N
  -- %d Se p_ndg is not null, verifica se la posizione presenta come ultima delibera una IM o IF.Se si, restituisce Y, altrimenti N
  -- %cd 26 lug 2012
  FUNCTION rdv_light_abilitata(p_sndg IN VARCHAR2,
                               p_abi  IN VARCHAR2,
                               P_NDG  IN VARCHAR2,
                               P_COD_GRUPPO_SUPER IN VARCHAR2) RETURN VARCHAR2 IS

    v_cod_micro_delib VARCHAR2(5);

  BEGIN

    IF (p_sndg IS NULL AND p_ndg IS NULL) OR
       (p_sndg IS NULL AND (p_ndg IS NULL OR p_abi IS NULL))
    THEN
      raise_application_error(-20666, 'Null parameter');
    END IF;

    CASE
      WHEN p_sndg IS NOT NULL ---controllo a livello di sndg
       THEN

        FOR n IN (SELECT g.cod_abi_cartolarizzato,
                         g.cod_ndg
                    FROM t_mcre0_app_all_data g
                   WHERE g.cod_sndg = p_sndg
                     AND G.TODAY_FLG = '1'
                     and g.cod_gruppo_super = nvl(p_cod_gruppo_super,g.cod_gruppo_super)
                        -- SOLO TARGET E OUTSOURCING
                     AND g.flg_outsourcing = 'Y'
                     AND g.flg_target = 'Y')
        LOOP

        begin
          SELECT cod_microtipologia_delib
            INTO v_cod_micro_delib
            FROM t_mcrei_app_delibere r
           WHERE val_num_progr_delibera =
                 (SELECT MAX(val_num_progr_delibera)
                    FROM t_mcrei_app_delibere r
                   WHERE r.cod_abi = n.cod_abi_cartolarizzato
                     AND r.cod_ndg = n.cod_ndg
                     AND flg_no_delibera = 0
                     AND cod_fase_pacchetto = 'ULT'
                     AND cod_fase_delibera != 'AN')
             AND cod_abi = n.cod_abi_cartolarizzato
             AND cod_ndg = n.cod_ndg;
        exception when no_data_found then
            v_cod_micro_delib := 'XX';--fittizio
        end;

          IF v_cod_micro_delib IN ('IM', 'IF')
          THEN
            RETURN 'Y';
          END IF;
        END LOOP;
      ELSE
        --- controllo a livello di posizione

        begin
        SELECT cod_microtipologia_delib
          INTO v_cod_micro_delib
          FROM T_MCREI_APP_DELIBERE R,
          t_mcre0_app_all_data a
         WHERE val_num_progr_delibera =
               (SELECT MAX(val_num_progr_delibera)
                  FROM t_mcrei_app_delibere r
                 WHERE r.cod_abi = p_abi
                   AND r.cod_ndg = p_ndg
                   AND flg_no_delibera = 0
                   AND cod_fase_pacchetto = 'ULT'
                   AND COD_FASE_DELIBERA != 'AN')
           AND R.COD_ABI = P_ABI
           AND R.COD_NDG = P_NDG
           AND R.COD_ABI = A.COD_ABI_CARTOLARIZZATO
           AND R.COD_NDG = A.COD_NDG
           and a.cod_gruppo_super=nvl(p_cod_gruppo_super,a.cod_gruppo_super);

        exception when no_data_found then
            v_cod_micro_delib := 'XX';--fittizio
        end;

        IF v_cod_micro_delib IN ('IM', 'IF')
        THEN
          RETURN 'Y';
        END IF;
    END CASE;
    RETURN 'N';

  EXCEPTION
    WHEN OTHERS THEN
      pkg_mcrei_audit.log_app('PKG_GEST_DELIBERE.rdv_light_abilitata',
                              pkg_mcrei_audit.c_error,
                              SQLCODE,
                              SQLERRM,
                              'ERRORE NEL REPERIMENTO DELLA MICROTIPOLOGIA: IL PACCHETTO NON E'' ULTIMATO',
                              NULL);
      RETURN 'N';
  END rdv_light_abilitata;

END pkg_mcrei_gest_delibere;
/


CREATE SYNONYM MCRE_APP.PKG_MCREI_GEST_DELIBERE FOR MCRE_OWN.PKG_MCREI_GEST_DELIBERE;


CREATE SYNONYM MCRE_USR.PKG_MCREI_GEST_DELIBERE FOR MCRE_OWN.PKG_MCREI_GEST_DELIBERE;


GRANT EXECUTE, DEBUG ON MCRE_OWN.PKG_MCREI_GEST_DELIBERE TO MCRE_USR;

