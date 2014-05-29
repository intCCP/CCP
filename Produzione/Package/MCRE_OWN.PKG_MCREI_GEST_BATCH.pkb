CREATE OR REPLACE PACKAGE BODY MCRE_OWN."PKG_MCREI_GEST_BATCH" AS
/******************************************************************************
NAME:       PKG_MCREI_GEST_BATCH
PURPOSE: Gestione impianto ristrutturati, batch rapporti nuovi ed estinti
I rapporti legati a chiusure di ristrutturazione (B8) non vengono gestiti dal batch notturno.
1.       Nascita nuovo rapporti
1.1.    Ristrutturazione totale: inserimento con flg_ristrutturato = `Y? e dta_inizio_segnalazione = sysdate e va in coda mora
1.2.    Ristrutturazione parziale solo con NPE presente su hst_rapp_ristr e stime: inserimento con flg_ristrutturato e data inizio segnalazione ereditati dalla famiglia NPE e va in coda mora
2.       Estinzione rapporto
2.1.    Ristrutturazione totale: aggiornamento flg_ristrutturato = `N?, dta_fine_segnalazione, dta_estinzione = sysdate
2.2.    Ristrutturazione parziale
2.2.1.  Rapporto non estero: aggiornamento
2.2.1.1.              se flg_ristrutturato valeva Y e flg_ristrutturato = `N? e dta_fine_segnalazione, dta_estinzione = sysdate;
2.2.1.2.              se flg_ristrutturato = `N? e dta_estinzione = sysdate e va in coda mora solo 1 volta;
2.2.2. Rapporto estero, dovrebbe avere lo stesso flg_ristrutturato e dta_inizio_segnalazione del gruppo  NPE,  non si tocca il flg_ristrutturato (perche deve essere ereditato e uguale per tutti i rapporti del gruppo?)
2.2.3. Non si tocca dta_fine_segnalazione (?)
2.2.4. dta_estinzione = sysdate
Per quanto riguarda la tripla (flg_ristrutturato, dta_inizio_segnalazione, dta_fine_dsegnalazione) ci sono quattro comabinazioni possibili che interpretiamo in modo particolare:
Y, NULL, NULL                    -> caso non possibile
Y, NULL, NOT NULL          -> caso non possibile
Y, NOT NULL, NOT NULL -> caso non possibile (se si estingue il flg va a N)
Y, NOT NULL, NULL            -> vivo segnalato come ristrutturato
N, NULL, NULL                    -> vivo segnalato come non ristrutturato
N, NOT NULL, NOT NULL  -> era con flg_ristrutturato = Y e si e estinto
N, NULL, NOT NULL            -> era con flg_ristrutturato = N e si e estinto
N, NOT NULL, NULL          -> caso non possibile
REVISIONS:
Ver        Date        Author           Description
---------  ----------  ---------------  ------------------------------------
1.0        26/07/2012  i.gueorguieva     created this package
1.1        27/07/2012  i.gueorguieva     procedure creazione delibere e stime d'impianto e popolamento tabelle storiche
1.2        30/07/2012  D'errico          prc_main, procedure popolamento coda per BS MORA
1.3        14/08/2012  i.gueorguieva     parametrizzata dta_delibera e dta_inizio_segnalazione
1.4        16/08/2012  i.gueorguieva     aggiunte funzioni di caricamento app
1.5        23/08/2012  D'ERRICO          aggiunta t_mcrei_app_ristrutturazioni a popola_hst_ristr per recuperate info sul tipo di ristrutturazione (T o P)
AGGIUNTA PULIZIA RECORD IN CASO DI RILANCIO ALL'INTERNO DELLA CREA_dELIB_IMPIANTO
1.6        28/08/2012  D'ERRICO                  modificato calcolo flg_ristrutturato in prc_popola_hst_rapp_ristr
1.7        24/09/2012  i.gueorguieva     Correzione gestione nuovi rapporti, solo ristrutturazione parziale gestita da batch
1.8        28/09/2012  i.gueorguieva     Correzione popolamento code mora, gestione rapporti estero parziali
1.9        02/09/2012  i.gueorguieva     Popolamento T_MCREI_HST_RAPP_RISTR.DTA_INIZIO_SEGNALAZIONE_RISTR CON (T_MCREI_APP_PCR_RAPPORTI.ID_DPER-2)
2.0        16/10/2012  d'errico          inserita gestione cambio stato nella prc_main e aggiunta variabile di output
2.1        19/10/2012  d'errico          inserito chiamata a funzione aggiorna_stato per gestire RS
2.2        30/10/2012  d'errico          aggiunto popolamento utilizzo e accordato per rapporti
2.3        31/10/2012  M.murro           aggiunta data scadenza su IR
2.4        05/11/2012  Gueorguieva       Corretta gestione prc_popola_coda_rapporti per rapporto
2.5        21/11/2012  Gueorguieva       Fix propagazione cod_npe e disabilitazione aggiornament flg_estinto su tabelle rapporti ristrutturati
2.6        29/11/2012  Gueorguieva       Aggiunto calcolo alert Ristrutturazioni parziali con rapporti privi di attributo in coda a prc_main_gest_batch_ristr
2.7        06/02/2013  Gueorguieva      Inibizione invio rapporti su posizioni con chiusura ristrutturazione inviata
2.8        06/02/2013  Gueorguieva      Segnalazione rapporti estinti solo oltre il 3o giorno dal rilevamento estinzione per la prima volta
2.9        06/02/2013  Gueorguieva      Per i rapporti esteri su ristrutturazioni parziali si recupera flg_ristrutturato e dta_inizio_segnalazione_ristr dagli altri rapporti con lo stesso NPE
3.0        26/02/2013  Gueorguieva      Aggiunta decodifica Flg N184 in fnc_carica_posizioni
3.1        04/03/2013  Gueorguieva      Cancellazione rapporti candidati all'estinzione dalla t_mcrei_hst_Rapp_ristr_cand_est nel caso riarrivino.
3.2        04/03/2013  Gueorguieva      Cambiato calcolo posiozioni con max_ordinale pre chiamata gest_nuovi ed estinti, esclusione chiusure ristrutturazione
3.3        04/03/2013  Gueorguieva      dta_inizio_segnalazione_ristr dei nuovi rapporti ¿ sysdate
3.4       30/05/2013  M.Murro            fix salvataggio utilizzati e decode desc_tipo-ristr
******************************************************************************/

-- %AUTHOR REPLY
-- %VERSION 0.2
-- %USAGE  Crea una delibera d'impianto di ristrutturazione
-- %d Per la posizione individuata dalla coppia (ABI, NDG) viene creata una delibera
-- %d di microtipologia IR. I campi della delibera vengono popolati a partire dai
-- %d parametri in input e dalle Pratiche.
-- %CD 13 AUG 2012
-- %PARAM p_cod_abi  ABI
-- %PARAM p_cod_ndg  NDG
-- %PARAM p_dta_efficacia_ristr data efficacia ristrutturazione
-- %PARAM p_dta_scadenza_ristr date scadenza ristrutturazione
-- %PARAM p_desc_tipo_ristr  T: Totale; P: Parziale
-- %PARAM p_desc_intento_ristr Y: Con intento liquidatorio; N: senza intento liquidatorio
-- %PARAM p_cod_abi  ABI
-- %PARAM p_cod_ndg NDG
-- %PARAM p_protodel protocollo delibera a cui associare le stime generate
-- %PARAM p_dta_inizio_sg data inizio segnalazione
PROCEDURE prc_crea_delibera_impianto_ri(
    p_cod_abi             IN t_mcrei_app_delibere.cod_abi%TYPE,
    p_cod_ndg             IN t_mcrei_app_delibere.cod_ndg%TYPE,
    p_dta_efficacia_ristr IN DATE,
    p_dta_efficacia_add   IN DATE,
    p_dta_scadenza_ristr  IN DATE,
    p_desc_tipo_ristr     IN t_mcrei_app_delibere.desc_tipo_ristr%TYPE,
    p_desc_intento_ristr  IN t_mcrei_app_delibere.desc_intento_ristr%TYPE,
    p_dta_delibera        IN DATE,
    p_proto               OUT t_mcrei_app_delibere.cod_protocollo_delibera%TYPE,
    p_proto_pacch         OUT t_mcrei_app_delibere.cod_protocollo_pacchetto%TYPE) IS

    c_nome CONSTANT VARCHAR2(100) := c_package || '.crea_delibera_impianto_ri';
    p_note           t_mcrei_wrk_audit_applicativo.note%TYPE;
    p_param          VARCHAR2(300);
    val_rdv_qc_progr t_mcrei_app_delibere.val_rdv_qc_progressiva%TYPE;
    v_delibera_pre   t_mcrei_app_delibere.cod_protocollo_delibera%TYPE;
    v_rdv_progr_fi   t_mcrei_app_delibere.val_rdv_progr_fi%TYPE;
    v_imp_perdita    t_mcrei_app_delibere.val_imp_perdita%TYPE;
    v_stralcio_ct    NUMBER := 0;
    v_esiste         NUMBER;

BEGIN
p_param       := 'ABI ' || p_cod_abi || ', NDG ' || p_cod_ndg || ';';
p_note        := 'Recupero rettifiche ed esposizione per ' || p_param;
p_proto       := NULL;
p_proto_pacch := NULL;

---VERIFICO ESISTENZA EVENTUALE DI UNA DELIBERA IR: SE ESISTE, SI CANCELLA E REINSERISCE

SELECT COUNT(1)
INTO v_esiste
FROM t_mcrei_app_delibere
WHERE cod_abi = p_cod_abi
AND cod_ndg = p_cod_ndg
AND cod_microtipologia_delib = 'IR';

IF v_esiste > 0
THEN
----ELIMINO RAPPORTI PRESENTI SULLE STIME E LEGATI A IR FATTA PRECEDENTEMENTE
DELETE t_mcrei_app_stime
WHERE cod_protocollo_delibera IN
(SELECT cod_protocollo_delibera
FROM t_mcrei_app_delibere
WHERE cod_abi = p_cod_abi
AND cod_ndg = p_cod_ndg
AND cod_microtipologia_delib = 'IR');

----ELIMINO RECORD PRESENTE SU RISTRUTTURAZIONI E LEGATO A IR FATTA PRECEDENTEMENTE
DELETE t_mcrei_hst_ristrutturazioni s
WHERE s.cod_protocollo_delibera IN
(SELECT cod_protocollo_delibera
FROM t_mcrei_app_delibere
WHERE cod_abi = p_cod_abi
AND cod_ndg = p_cod_ndg
AND cod_microtipologia_delib = 'IR');

----ELIMINO RAPPORTI PRESENTI SU RAPP RISTRUTTURATI E LEGATI A IR FATTA PRECEDENTEMENTE
DELETE t_mcrei_hst_rapp_ristr r
WHERE r.cod_protocollo_delibera_padre IN
(SELECT cod_protocollo_delibera
FROM t_mcrei_app_delibere
WHERE cod_abi = p_cod_abi
AND cod_ndg = p_cod_ndg
AND cod_microtipologia_delib = 'IR');

--CANCELLO DELIBERE IR PREESISTENTI
DELETE t_mcrei_app_delibere
WHERE cod_abi = p_cod_abi
AND cod_ndg = p_cod_ndg
AND cod_microtipologia_delib = 'IR';
--COMMIT; SI COMMITTA TUTTO ALLA FINE
END IF;

BEGIN
BEGIN
v_stralcio_ct := nvl(pkg_mcrei_gest_delibere.fnc_mcrei_get_stralci_ct(p_cod_abi,
      p_cod_ndg),
0);
EXCEPTION
WHEN OTHERS THEN
v_stralcio_ct := 0;
END;

SELECT val_rdv_qc_progressiva,
cod_protocollo_delibera,
val_rdv_progr_fi,
val_imp_perdita
INTO val_rdv_qc_progr,
v_delibera_pre,
v_rdv_progr_fi,
v_imp_perdita
FROM (SELECT nvl(s.val_rdv_qc_progressiva, 0) val_rdv_qc_progressiva,
s.cod_protocollo_delibera,
nvl(s.val_rdv_progr_fi, 0) AS val_rdv_progr_fi,
decode(s.cod_fase_delibera,
'CT',
--11 MAGGIO: aggiunta logica su rinuncia pregressa in caso di CT
--MM 0808: in fase di inizializzazione, la rinuncia pregressa CT S lo stralcio capitalizzato
--nvl(s.val_rinuncia_totale, 0) -
--nvl(val_imp_perdita, 0) +
--nvl(s.val_sacrif_capit_mora, 0),
v_stralcio_ct,
nvl(s.val_imp_perdita, 0)) AS val_imp_perdita
FROM t_mcrei_app_delibere s
WHERE s.cod_abi = p_cod_abi
AND s.cod_ndg = p_cod_ndg
AND s.cod_fase_delibera IN ('AD', 'CO', 'CT', 'NA')
AND s.flg_no_delibera = 0
AND flg_attiva = '1'
ORDER BY s.val_num_progr_delibera DESC NULLS LAST,
s.dta_conferma_delibera  DESC NULLS LAST)
WHERE rownum <= 1;
EXCEPTION
WHEN no_data_found THEN
val_rdv_qc_progr := 0;
v_rdv_progr_fi   := 0;
v_imp_perdita    := 0;
v_delibera_pre   := '#';
END;
p_note := 'Inserimento nuova delibera per ' || p_param;
INSERT INTO t_mcrei_app_delibere
(id_dper,
cod_abi,
cod_ndg,
cod_sndg,
cod_protocollo_delibera,
cod_protocollo_pacchetto,
cod_microtipologia_delib,
cod_fase_delibera,
cod_fase_microtipologia,
cod_fase_pacchetto,
cod_tipo_pacchetto,
val_anno_proposta,
val_progr_proposta,
cod_pratica,
val_anno_pratica,
cod_uo_pratica,
dta_ins,
dta_creazione_pacchetto,
dta_ins_delibera,
dta_conferma_delibera,
dta_conferma_pacchetto,
flg_attiva,
cod_matricola_inserente,
val_num_progr_delibera,
val_rdv_qc_progressiva,
cod_protocollo_delibera_pre,
val_rdv_progr_fi,
val_imp_perdita,
dta_last_upd_delibera,
desc_tipo_ristr,
desc_intento_ristr,
dta_scadenza_ristr,
dta_efficacia_ristr,
dta_efficacia_add,
flg_ristrutturato,
dta_delibera,
dta_scadenza,
cod_macrotipologia_delib,
cod_stato_posiz,
dta_dec_stato_posiz
)
SELECT id_dper,
cod_abi,
cod_ndg,
cod_sndg,
cod_protocollo_delibera,
(cod_sndg || '_' || mcre_own.seq_mcrei_pacchetto.nextval) AS cod_protocollo_pacchetto,
'IR' AS cod_microtipologia_delib,
'CO' AS cod_fase_delibera,
'CNF' AS cod_fase_microtipologia,
'ULT' AS cod_fase_pacchetto,
'I' AS cod_tipo_pacchetto,
anno_proposta_ci,
prog_proposta_ci,
cod_pratica,
val_anno_pratica,
cod_uo_pratica,
SYSDATE AS dta_ins,
SYSDATE AS dta_creazione_pacchetto,
SYSDATE AS dta_ins_delibera,
SYSDATE AS dta_conferma_delibera,
SYSDATE AS dta_conferma_pacchetto,
'1' AS flg_attiva,
'IMPIANTO' AS cod_matricola_inserente,
seq_mcrei_prog_del.nextval AS val_progr_delibera,
val_rdv_qc_progr AS val_rdv_qc_progressiva,
v_delibera_pre AS cod_protocollo_delibera_pre,
v_rdv_progr_fi AS val_rdv_progr_fi,
v_imp_perdita AS val_imp_perdita,
SYSDATE AS dta_last_upd_delibera,
p_desc_tipo_ristr AS desc_tipo_ristr, ----campo da prendere nella tabella dove caricheremo posizioni da impiantare
p_desc_intento_ristr AS desc_intento_ristr,
p_dta_scadenza_ristr AS dta_scadenza_ristr,
p_dta_efficacia_ristr AS dta_efficacia_ristr,
p_dta_efficacia_add AS dta_efficacia_add,
'Y',
trunc(SYSDATE),
(select dta_scadenza_stato from t_mcre0_app_all_data
where cod_abi_cartolarizzato = p_cod_abi
and cod_ndg = p_cod_ndg
AND TODAY_FLG = '1') as dta_scadenza,
 (SELECT cod_macrotipologia
FROM t_mcrei_cl_tipologie it
WHERE it.cod_microtipologia = 'IR'),-- macrotipologia
(select cod_stato from t_mcre0_app_all_data
where cod_abi_cartolarizzato = p_cod_abi
and cod_ndg = p_cod_ndg
AND TODAY_FLG = '1'),          --cod_stato
(select dta_decorrenza_stato from t_mcre0_app_all_data
where cod_abi_cartolarizzato = p_cod_abi
and cod_ndg = p_cod_ndg
AND TODAY_FLG = '1')-- dta_dec_stato_posiz
FROM
    (SELECT to_number(to_char(SYSDATE, 'YYYYMMDD')) AS id_dper,
p.cod_abi,
p.cod_ndg,
p.cod_sndg,
mcre_own.pkg_mcrei_gest_delibere.fnc_mcrei_protocollo_delibera(p.cod_uo_pratica,
            'BATCH',
            p.cod_abi,
            p.cod_ndg) AS cod_protocollo_delibera,
p.anno_proposta_ci,
p.prog_proposta_ci,
p.cod_pratica,
p.val_anno_pratica,
p.cod_uo_pratica
FROM v_mcrei_app_pratiche p
WHERE cod_abi = p_cod_abi
AND cod_ndg = p_cod_ndg
AND p.cod_microtipologia_delib = 'CI'
ORDER BY dta_apertura DESC NULLS LAST) dup
WHERE rownum = 1;

IF SQL%ROWCOUNT = 0
THEN
INSERT INTO t_mcrei_app_delibere
    (
id_dper,
cod_abi,
cod_ndg,
cod_sndg,
cod_protocollo_delibera,
cod_protocollo_pacchetto,
cod_microtipologia_delib,
cod_fase_delibera,
cod_fase_microtipologia,
cod_fase_pacchetto,
cod_tipo_pacchetto,
val_anno_proposta,
val_progr_proposta,
cod_pratica,
val_anno_pratica,
cod_uo_pratica,
dta_ins,
dta_creazione_pacchetto,
dta_ins_delibera,
dta_conferma_delibera,
dta_conferma_pacchetto,
flg_attiva,
cod_matricola_inserente,
val_num_progr_delibera,
val_rdv_qc_progressiva,
cod_protocollo_delibera_pre,
val_rdv_progr_fi,
val_imp_perdita,
dta_last_upd_delibera,
desc_tipo_ristr,
desc_intento_ristr,
dta_scadenza_ristr,
dta_efficacia_ristr,
dta_efficacia_add,
flg_ristrutturato,
dta_delibera,
DTA_SCADENZA,
cod_macrotipologia_delib,
cod_stato_posiz,
dta_dec_stato_posiz)
SELECT
    id_dper,
    cod_abi,
    cod_ndg,
    cod_sndg,
    cod_protocollo_delibera,
    (cod_sndg || '_' || mcre_own.seq_mcrei_pacchetto.nextval) AS cod_protocollo_pacchetto,
    'IR' AS cod_microtipologia_delib,
    'CO' AS cod_fase_delibera,
    'CNF' AS cod_fase_microtipologia,
    'ULT' AS cod_fase_pacchetto,
    'I' AS cod_tipo_pacchetto,
    anno_proposta_ci,
    prog_proposta_ci,
    cod_pratica,
    val_anno_pratica,
    cod_uo_pratica,
    SYSDATE AS dta_ins,
    SYSDATE AS dta_creazione_pacchetto,
    SYSDATE AS dta_ins_delibera,
    SYSDATE AS dta_conferma_delibera,
    SYSDATE AS dta_conferma_pacchetto,
    '1' AS flg_attiva,
    'IMPIANTO' AS cod_matricola_inserente,
    seq_mcrei_prog_del.nextval AS val_progr_delibera,
    val_rdv_qc_progr AS val_rdv_qc_progressiva,
    v_delibera_pre AS cod_protocollo_delibera_pre,
    v_rdv_progr_fi AS val_rdv_progr_fi,
    v_imp_perdita AS val_imp_perdita,
    SYSDATE AS dta_last_upd_delibera,
    p_desc_tipo_ristr AS desc_tipo_ristr, ----campo da prendere nella tabella dove caricheremo posizioni da impiantare
    p_desc_intento_ristr AS desc_intento_ristr,
    p_dta_scadenza_ristr AS dta_scadenza_ristr,
    p_dta_efficacia_ristr AS dta_efficacia_ristr,
    p_dta_efficacia_add AS dta_efficacia_add,
    'Y',
    trunc(SYSDATE),
    (select dta_scadenza_stato from t_mcre0_app_all_data
where cod_abi_cartolarizzato = p_cod_abi
and cod_ndg = p_cod_ndg
AND TODAY_FLG = '1') as dta_scadenza,
 (SELECT cod_macrotipologia
FROM t_mcrei_cl_tipologie it
WHERE it.cod_microtipologia = 'IR'),-- macrotipologia
(select cod_stato from t_mcre0_app_all_data
where cod_abi_cartolarizzato = p_cod_abi
and cod_ndg = p_cod_ndg
AND TODAY_FLG = '1'),          --cod_stato
(select dta_decorrenza_stato from t_mcre0_app_all_data
where cod_abi_cartolarizzato = p_cod_abi
and cod_ndg = p_cod_ndg
AND TODAY_FLG = '1')-- dta_dec_stato_posiz
FROM
    (SELECT to_number(to_char(SYSDATE, 'YYYYMMDD')) AS id_dper,
p.cod_abi,
p.cod_ndg,
p.cod_sndg,
mcre_own.pkg_mcrei_gest_delibere.fnc_mcrei_protocollo_delibera(p.cod_uo_pratica,
              'BATCH',
              p.cod_abi,
              p.cod_ndg) AS cod_protocollo_delibera,
NULL AS anno_proposta_ci,
NULL AS prog_proposta_ci,
p.cod_pratica,
p.val_anno_pratica,
p.cod_uo_pratica
FROM t_mcrei_app_pratiche p
WHERE cod_abi = p_cod_abi
AND cod_ndg = p_cod_ndg
ORDER BY dta_apertura DESC NULLS LAST) dup
WHERE rownum = 1;
END IF;

--COMMIT;

p_note := 'Recupero protocollo delibera creata per ' || p_param;

SELECT cod_protocollo_delibera,
cod_protocollo_pacchetto
INTO p_proto,
p_proto_pacch
FROM t_mcrei_app_delibere
WHERE cod_abi = p_cod_abi
AND cod_ndg = p_cod_ndg
AND cod_microtipologia_delib = 'IR'
AND dta_ins > trunc(SYSDATE);

pkg_mcrei_audit.log_app(c_nome,
pkg_mcrei_audit.c_debug,
SQLCODE,
SQLERRM,
p_note,
'BATCH');

EXCEPTION
WHEN OTHERS THEN
pkg_mcrei_audit.log_app(c_nome,
pkg_mcrei_audit.c_debug,
SQLCODE,
SQLERRM,
p_note,
'BATCH');
END prc_crea_delibera_impianto_ri;

-- %AUTHOR REPLY
-- %VERSION 0.1
-- %USAGE Crea una stima per ogni rapporto presente su PCR Rapporti per la posizione individuata dalla coppia (ABI, NDG)
-- %d Se un rapporto S presente anche sulla tabella dei rapporti ristrutturati,
-- %d T_MCREI_APP_RAPP_RIST, allora i campi della stima generata verranno popolati a partire
-- %d dalla tabella dei rapporti ristrutturati.
-- %d Altrimenti verranno popolati a partire da PCR Rapporti, con FLG_RISTRUTTURATO = N
-- %d e DTA_INIZIO_SEGNALAZIONE_RISTR = DTA_EFFICACIA_RISTR.
-- %CD 30 LUG 2012
-- %param p_cod_abi  ABI
-- %param p_cod_ndg  NDG
-- %param p_protodel protocollo delibera a cui associare le stime generate
-- %param p_dta_inizio_sg  data inizio segnalazione
/* Formatted on 04/06/2013 14.52.22 (QP5 v5.163.1008.3004) */
PROCEDURE prc_crea_stime_impianto (
   p_cod_abi         IN t_mcrei_app_delibere.cod_abi%TYPE,
   p_cod_ndg         IN t_mcrei_app_delibere.cod_ndg%TYPE,
   p_protodel        IN t_mcrei_app_delibere.cod_protocollo_delibera%TYPE,
   p_dta_inizio_sg   IN DATE)
AS
   c_nome   CONSTANT VARCHAR2 (100) := c_package || '.crea_stime_impianto';
   p_note            t_mcrei_wrk_audit_applicativo.note%TYPE;
   p_param           VARCHAR2 (500);
-- NON TUTTI I RAPPORTI SONO PRESENTI SU T_MCREI_APP_RAPP_RISTR
BEGIN
   INSERT INTO t_mcrei_app_stime (cod_abi,
                                  cod_classe_ft,
                                  cod_forma_tecnica,
                                  cod_microtipologia_delibera,
                                  cod_ndg,
                                  cod_sndg,
                                  dta_stima,
                                  val_Esposizione,
                                  val_accordato,
                                  val_utilizzato_netto,
                                  val_utilizzato_mora,
                                  cod_operatore_ins_upd,
                                  cod_protocollo_delibera,
                                  cod_rapporto,
                                  cod_utente,
                                  dta_fine_segnalazione_ristr,
                                  dta_inizio_segnalazione_ristr,
                                  dta_ins,
                                  flg_attiva,
                                  flg_ristrutturato,
                                  id_dper,
                                  flg_tipo_dato,
                                  cod_npe)
      SELECT DISTINCT
             ra.cod_abi,
             MAX (ra.cod_classe_ft)
                OVER (PARTITION BY ra.cod_abi, ra.cod_ndg, ra.cod_rapporto),
             MAX (ra.cod_forma_tecnica)
                OVER (PARTITION BY ra.cod_abi, ra.cod_ndg, ra.cod_rapporto),
             'IR',
             ra.cod_ndg,
             ra.cod_sndg,
             SYSDATE AS dta_stima,
             -- si somma per eventuali rapporti su doppia forma tecnica
             SUM (ra.val_imp_utilizzato)
                OVER (PARTITION BY ra.cod_abi, ra.cod_ndg, ra.cod_rapporto)
                val_esposizione,
             SUM (ra.val_accordato_delib)
                OVER (PARTITION BY ra.cod_abi, ra.cod_ndg, ra.cod_rapporto)
                val_accordato,
             SUM (NVL (ra.val_imp_utilizzato, 0) - NVL (i.val_imp_mora, 0))
                OVER (PARTITION BY ra.cod_abi, ra.cod_ndg, ra.cod_rapporto)
                AS val_utilizzato_netto,
             SUM (NVL (i.val_imp_mora, 0))
                OVER (PARTITION BY ra.cod_abi, ra.cod_ndg, ra.cod_rapporto)
                AS val_utilizzato_mora,
             'BATCH',
             p_protodel,
             ra.cod_rapporto,
             'BATCH',
             r.dta_fine_segnalazione_ristr,
             CASE
                WHEN A.DESC_TIPO_RISTR = 'T'
                THEN
                   NVL (R.DTA_INIZIO_SEGNALAZIONE_RISTR, P_DTA_INIZIO_SG)
                ELSE
                   CASE
                      WHEN R.COD_RAPPORTO IS NOT NULL
                           AND R.FLG_RISTRUTTURATO = 'Y'
                      THEN
                         NVL (r.DTA_INIZIO_SEGNALAZIONE_RISTR,
                              p_dta_inizio_sg)
                      ELSE
                         R.DTA_INIZIO_SEGNALAZIONE_RISTR
                   END
             END
                DTA_INIZIO_SEGNALAZIONE_RISTR,
             SYSDATE,
             '1',                                                --FLG_ATTIVA,
             DECODE (A.DESC_TIPO_RISTR,
                     'T', 'Y',
                     DECODE (R.COD_RAPPORTO, NULL, 'N', R.FLG_RISTRUTTURATO))
                AS FLG_RISTRUTTURATO,
             TO_NUMBER (TO_CHAR (SYSDATE, 'YYYYMMDD')),
             'R', --DI DEFAULT POPOLIAMO CON OPERATIVO, SOLO PER NON VIOLARE LA CHIAVE,
             re.cod_npe
        FROM t_mcrei_app_rapp_ristr r,
             t_mcrei_app_pcr_rapporti ra,
             t_mcrei_app_rapporti_estero re,
             t_mcrei_app_ristrutturazioni a,
             t_mcre0_app_rate_daily i
       WHERE     a.cod_abi = ra.cod_abi
             AND a.cod_ndg = ra.cod_ndg
             AND ra.cod_abi = r.cod_abi(+)
             AND ra.cod_ndg = r.cod_ndg(+)
             AND ra.cod_rapporto = r.cod_rapporto(+)
             AND ra.cod_abi = re.cod_abi(+)
             AND ra.cod_ndg = re.cod_ndg(+)
             AND ra.cod_abi = i.cod_abi_CARTOLARIZZATO(+)
             AND ra.cod_ndg = i.cod_ndg(+)
             AND ra.cod_rapporto = i.cod_rapporto(+)
             AND ra.cod_rapporto = re.cod_rapporto_estero(+)
             AND ra.cod_abi = p_cod_abi
             AND ra.cod_ndg = p_cod_ndg;
--COMMIT;

END;
-- %USAGE Popola la tabella dei rapporti delle posizioni ristrutturate T_MCREI_HST_RAPP_RISTR.
-- %d Dopo l'esecuzione, per ogni stima generata da prc_crea_stime_impianto,
-- %d ci sar? un record sulla T_MCREI_HST_RAPP_RISTR. Ad una posizione con val_ordinale = n e
-- %d cod_protocollo_delibera = d, su T_MCREI_HST_RISTRUTTURAZIONI, corrisponderanno k rapporti
-- %d (dove k S la numerosit? dei rapporti su PCR per la posizione) con val_ordinale = n e
-- %d cod_protocollo_delibera_padre = d su T_MCREI_HST_RAPP_RIST.
-- %CD 13 AUG 2012
-- %param p_cod_abi ABI
-- %param p_cod_ndg    NDG
-- %param p_protodel Protocollo delibera a cui associare le stime generate
-- %param p_ordinale    Numero ordinale da associare al blocco di rapporti
-- %param p_dta_inizio_sg     Data inizio segnalazione
PROCEDURE prc_popola_hst_rapp_ristr(p_codabi        IN VARCHAR2,
p_codndg        IN VARCHAR2,
p_protodel      IN VARCHAR2,
p_ordinale      IN NUMBER,
p_dta_inizio_sg IN DATE) AS

BEGIN

-- SE ESISTE GIA' UNA DE
-- Si inseriscono tutti i rapporti della posizione, a prescindere che si tratti di ristrutt tot o parziale.
-- vanno tutti comunque inviati a host, con indicazione del flg ristrutturato opportuna
-- EXECUTE IMMEDIATE 'TRUNCATE TABLE MCRE_OWN.t_mcrei_hst_rapp_ristr';
INSERT INTO t_mcrei_hst_rapp_ristr (cod_abi, cod_classe_ft, cod_forma_tecnica, cod_microtipologia_delibera,
cod_ndg, cod_sndg, cod_utente, cod_protocollo_delibera_padre, cod_rapporto, cod_operatore_ins_upd, dta_fine_segnalazione_ristr,
dta_inizio_segnalazione_ristr, dta_ins, flg_attiva, flg_ristrutturato, id_dper, flg_tipo_dato, val_ordinale, dta_stima, val_esposizione, val_Accordato,
val_utilizzato_netto,val_utilizzato_mora,cod_npe, flg_estinto,flg_nuovo)
   SELECT   DISTINCT ra.cod_abi,
                     MAX(ra.cod_classe_ft) OVER (PARTITION BY ra.cod_abi, ra.cod_ndg, ra.cod_rapporto),
                     MAX(ra.cod_forma_tecnica) OVER (PARTITION BY ra.cod_abi, ra.cod_ndg, ra.cod_rapporto),
                     'IR', ra.cod_ndg, ra.cod_sndg, 'BATCH', p_protodel,
                     ra.cod_rapporto, 'BATCH', dta_fine_segnalazione_ristr,
                     decode(a.desc_tipo_ristr,'T', NVL (dta_inizio_segnalazione_ristr, p_dta_inizio_sg),
                     DECODE(R.COD_RAPPORTO, NULL, TO_DATE(NULL),NVL (dta_inizio_segnalazione_ristr, p_dta_inizio_sg))) DTA_INIZIO_SEGNALAZIONE_RISTR,
                     SYSDATE,                                        --DTA_INS
                             '1',                                --FLG_ATTIVA,
                     --nel caso di ristr totale, tutti i rapporti vanno fleggati a Y
                     DECODE (a.desc_tipo_ristr, 'T', 'Y', DECODE (r.cod_rapporto, NULL, 'N', flg_ristrutturato)) AS flg_ristrutturato,
                     TO_NUMBER (TO_CHAR (SYSDATE, 'YYYYMMDD')), 'R', --DI DEFAULT POPOLIAMO CON OPERATIVO, SOLO PER NON VIOLARE LA CHIAVE
                     p_ordinale, TRUNC (SYSDATE) AS dta_stima,
                     SUM(ra.val_imp_utilizzato) OVER (PARTITION BY ra.cod_abi, ra.cod_ndg, ra.cod_rapporto) val_esposizione,
                     SUM(ra.val_accordato_delib) OVER (PARTITION BY ra.cod_abi, ra.cod_ndg, ra.cod_rapporto)val_Accordato,
                     sum (nvl(ra.val_imp_utilizzato,0) - NVL (i.val_imp_mora, 0) ) over(PARTITION BY ra.cod_abi, ra.cod_ndg, ra.cod_rapporto)  AS val_utilizzato_netto,
                     sum(NVL (i.val_imp_mora, 0)) over(PARTITION BY ra.cod_abi, ra.cod_ndg, ra.cod_rapporto) AS val_utilizzato_mora,
                     re.cod_npe, 'N','N'
     FROM   t_mcrei_app_rapp_ristr r, t_mcrei_app_pcr_rapporti ra,
            t_mcrei_app_rapporti_estero re, t_mcrei_app_ristrutturazioni a,
            t_mcre0_app_rate_daily i
    WHERE       a.cod_abi = ra.cod_abi
            AND a.cod_ndg = ra.cod_ndg
            AND ra.cod_abi = r.cod_abi(+)
            AND ra.cod_ndg = r.cod_ndg(+)
            AND ra.cod_rapporto = r.cod_rapporto(+)
            AND ra.cod_abi = re.cod_abi(+)
            AND ra.cod_ndg = re.cod_ndg(+)
            AND ra.cod_rapporto = re.cod_rapporto_estero(+)
            AND ra.cod_abi = i.cod_abi_cartolarizzato(+)
            AND ra.cod_ndg = i.cod_ndg(+)
            AND ra.cod_rapporto = i.cod_rapporto(+)
            AND ra.cod_abi = p_codabi
            AND ra.cod_ndg = p_codndg;
--COMMIT;

END prc_popola_hst_rapp_ristr;

-- %AUTHOR REPLY
-- %VERSION 0.1
-- %USAGE Popola la tabella usata da Business service MORA T_MCREI_MORA_POS_RISTR
-- %cd 14 AUG 2012
-- %param p_codabi ABI
-- %param p_codndg NDG
-- %param p_ordinale numero ordinale da associare al blocco di rapporti
-- %param p_dta_delibera data delibera
PROCEDURE prc_popola_coda_posizioni(p_codabi   IN VARCHAR2,
p_codndg   IN VARCHAR2,
p_ordinale IN NUMBER,
p_dta_del  IN DATE) AS

v_tab_name VARCHAR2(30);
V_VAL_ORDINALE T_MCREI_HST_RISTRUTTURAZIONI.VAL_ORDINALE%TYPE;
P_NOTE VARCHAR2(4000);
c_nome t_mcrei_wrk_audit_applicativo.procedura%type:='PKG_MCREI_GEST_BATCH.PRC_POPOLA_CODA_POSIZIONI';
BEGIN

-- BONIFICA INVII ANDATI MALE LA SCORSA NOTTE
UPDATE T_MCREI_MORA_POS_RISTR
   SET FLG_ESITO = 'Z'
 WHERE cod_abi = p_codabi
   AND cod_ndg = p_codndg
   AND FLG_ESITO IS NULL;

 -- LE NUOVE POSIZIONI DA INVIARE
   INSERT  INTO T_MCREI_MORA_POS_RISTR T (t.cod_abi, t.cod_comparto, t.cod_matricola_utente,
                        t.cod_ndg, t.cod_tipo_ristrutturazione,
                        t.dta_chiusura_ristr, t.dta_efficacia_add_ristr,
                        t.dta_efficacia_ristr, t.dta_scadenza_ristr,
                        t.flg_intento, t.val_ordinale, t.dta_delibera,T.FLG_ESITO,
                        t.dta_ins)
   SELECT              r.cod_abi,
                       NVL (d.cod_comparto_assegnato, d.cod_comparto_calcolato) AS cod_comparto,
                       u.cod_matricola, r.cod_ndg, r.desc_tipo_ristr,
                       r.dta_chiusura_ristr, r.dta_efficacia_add,
                       r.dta_efficacia_ristr, r.dta_scadenza_ristr,
                       desc_intento_ristr, r.val_ordinale,
                       p_dta_del dta_delibera, NULL,
                       SYSDATE
                FROM   t_mcrei_hst_ristrutturazioni r, t_mcre0_app_all_data d,
                       t_mcre0_app_utenti u
               WHERE       r.cod_abi = d.cod_abi_cartolarizzato
                       AND r.cod_ndg = d.cod_ndg
                       AND r.cod_abi = p_codabi
                       AND r.cod_ndg = p_codndg
                       AND r.val_ordinale = p_ordinale
                       AND d.today_flg = '1'
                       AND d.id_utente = u.id_utente
                       AND R.DTA_CHIUSURA_RISTR IS NULL;
COMMIT;
EXCEPTION WHEN OTHERS
THEN ROLLBACK;
    pkg_mcrei_audit.log_app(c_nome,pkg_mcrei_audit.c_error,SQLCODE, SQLERRM,p_note,NULL);
END prc_popola_coda_posizioni;

-- %AUTHOR REPLY
-- %VERSION 0.1
-- %usage Popola la tabella dei rapporti T_MCREI_MORA_RAPP_RISTR usata da Business service MORA
-- %d Lavora a livello di posizione individuando i rapporti assocciati
-- %cd 14 AUG 2012
-- %param p_codabi ABI
-- %param p_codndg NDG
-- %param p_ordinale numero ordinale da associare al blocco di rapporti
PROCEDURE prc_popola_coda_rapporti(p_codabi   IN VARCHAR2,
p_codndg   IN VARCHAR2,
p_ordinale IN NUMBER) AS

P_NOTE VARCHAR2(4000);
c_nome t_mcrei_wrk_audit_applicativo.procedura%type:='PKG_MCREI_GEST_BATCH.PRC_POPOLA_CODA_RAPPORTI';

BEGIN
P_NOTE:='INSERIMENTO BLOCCO RAPPORTI PER  '||P_CODABI||' '||P_CODNDG||' val_ordinale='||p_ordinale;
DELETE FROM   T_MCREI_MORA_RAPP_RISTR
      WHERE   (COD_ABI,COD_NDG, VAL_ORDINALE)
        IN   (SELECT COD_ABI, COD_NDG, VAL_ORDINALE
       FROM T_MCREI_MORA_POS_RISTR
     WHERE FLG_ESITO IS NULL);

INSERT INTO T_MCREI_MORA_RAPP_RISTR (COD_ABI, COD_NDG, COD_RAPPORTO, DTA_FINE_RISTR_RAPP, DTA_INIZIO_RISTR_RAPP, FLG_RISTRUTTURATO, VAL_ORDINALE, DTA_INS)
   SELECT   R.COD_ABI, R.COD_NDG, R.COD_RAPPORTO,
            R.DTA_ESTINZIONE, R.DTA_INIZIO_SEGNALAZIONE_RISTR, --DTA_ESTINZIONE NEW
            R.FLG_RISTRUTTURATO, R.VAL_ORDINALE, SYSDATE
     FROM   T_MCREI_HST_RAPP_RISTR R, T_MCREI_MORA_POS_RISTR POS
    WHERE   R.COD_ABI = POS.COD_ABI
            AND R.COD_NDG = POS.COD_NDG
            AND R.VAL_ORDINALE = POS.VAL_ORDINALE
            AND POS.FLG_ESITO IS NULL
            and FLG_INVIATO = 0;
 BEGIN
   P_NOTE:= P_NOTE||CHR(10)||'UPDATE T_MCREI_HST_RAPP_RISTR SET FLG_INVIATO =1';
   UPDATE T_MCREI_HST_RAPP_RISTR
     SET FLG_INVIATO = 1
    WHERE (COD_ABI, COD_NDG, VAL_ORDINALE) IN
    (SELECT COD_ABI, COD_NDG, VAL_ORDINALE
       FROM T_MCREI_MORA_POS_RISTR
     WHERE FLG_ESITO IS NULL)
     AND FLG_ESTINTO = 'Y';
   EXCEPTION WHEN OTHERS THEN
    pkg_mcrei_audit.log_app(c_nome,pkg_mcrei_audit.c_error,SQLCODE, SQLERRM,p_note,NULL);
 END;
COMMIT;
EXCEPTION WHEN OTHERS
THEN ROLLBACK;
    pkg_mcrei_audit.log_app(c_nome,pkg_mcrei_audit.c_error,SQLCODE, SQLERRM,p_note,NULL);
END prc_popola_coda_rapporti;

-- %AUTHOR REPLY
-- %VERSION 0.1
-- %usage Popola la tabella dei rapporti T_MCREI_MORA_RAPP_RISTR usata da Business service MORA
-- %d Lavora a livello del rapporto passato per argomento
-- %cd 14 AUG 2012
-- %param p_codabi ABI
-- %param p_codndg NDG
-- %param p_ordinale numero ordinale da associare al blocco di rapporti
-- % param p_cod_rapporto codice rapporto
PROCEDURE prc_popola_coda_rapporti(p_codabi       IN VARCHAR2,
p_codndg       IN VARCHAR2,
p_ordinale     IN NUMBER,
p_cod_rapporto IN VARCHAR2) AS

BEGIN
DELETE FROM T_MCREI_MORA_RAPP_RISTR
WHERE cod_abi = p_codabi
AND cod_ndg = p_codndg
AND val_ordinale = p_ordinale
AND cod_rapporto =  p_cod_rapporto;

INSERT INTO T_MCREI_MORA_RAPP_RISTR
(cod_abi,
cod_ndg,
cod_rapporto,
dta_fine_ristr_rapp,
dta_inizio_ristr_rapp,
flg_ristrutturato,
val_ordinale,
DTA_INS)
SELECT
r.cod_abi,
r.cod_ndg,
r.cod_rapporto,
r.dta_fine_segnalazione_ristr,
r.dta_inizio_segnalazione_ristr,
r.flg_ristrutturato,
r.val_ordinale,
sysdate
FROM T_MCREI_HST_RAPP_RISTR R
WHERE  r.cod_abi = p_codabi
AND r.cod_ndg = p_codndg
AND r.val_ordinale = p_ordinale
AND r.cod_rapporto =  p_cod_rapporto
AND ((r.flg_estinto = 'Y' AND R.dta_fine_segnalazione_ristr IS NOT NULL)
OR FLG_ESTINTO IS NULL OR FLG_ESTINTO = 'N');

END prc_popola_coda_rapporti;

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
-- %d   5) si popola la coda delle posizioni che verr? elaborata dal job java con l'immagine corrispondente al max(ordinale) presente nella hst_ristrutturazioni,
-- %d   6) si popola la coda dei rapporti che verr? elaborata dal job java con l'immagine corrispondente al max(ordinale) presente nella hst_ristrutturazioni,
-- %cd 30 lug 2012
PROCEDURE prc_main(v_posizioni_da_processare OUT NUMBER,
v_posizioni_processate    OUT NUMBER,
V_NUM_RS_PREVISTI OUT NUMBER,
V_NUM_RS_GESTITI OUT NUMBER) AS

v_protodel VARCHAR2(50);
v_protopac VARCHAR2(50);
ret        NUMBER;
c_nome CONSTANT VARCHAR2(100) := c_package || '.PRC_MAIN';
p_note              t_mcrei_wrk_audit_applicativo.note%TYPE;
p_params            t_mcrei_wrk_audit_applicativo.note%TYPE;
v_out_ordinale      NUMBER;
v_pos_da_processare NUMBER := 0;
v_pos_processate    NUMBER := 0;
v_dta_efficacia     DATE := to_date('01011900', 'DDMMYYYY');
v_dta_delibera      DATE := SYSDATE;

BEGIN

V_NUM_RS_PREVISTI := 0;
V_NUM_RS_GESTITI  := 0;
---pulizia preventiva tabelle coinvolte

DELETE t_mcrei_mora_rapp_ristr r
WHERE r.val_ordinale IN (SELECT val_ordinale
FROM t_mcrei_mora_pos_ristr a
WHERE a.flg_esito IS NULL);

DELETE t_mcrei_mora_pos_ristr a WHERE a.flg_esito IS NULL;
COMMIT;
/*************************************************************************************
Per ogni posizione da impiantare, caricata nella tabella t_mcrei_app_ristrutturazioni,
e per tutti i rapporti ad essa collegati (presenti nella t_mcrei_app_rapp_ristr):   */

FOR pos_da_ristr IN (SELECT DISTINCT r.cod_abi AS abi,
r.cod_ndg AS ndg,
'IN' AS stato_prec,
case when (desc_TIPO_ristr = 'T' AND DESC_INTENTO_RISTR = 'N') THEN 'RS' ELSE 'IN' END AS stato_new,
a.dta_scadenza_stato AS scad_stato,
A.COD_SNDG,
a.cod_percorso,
a.cod_processo,
a.dta_processo,
a.dta_decorrenza_stato,
desc_tipo_ristr,
desc_intento_ristr,
dta_efficacia_ristr,
dta_efficacia_add,
dta_scadenza_ristr,
cod_stato_proposto,
dta_chiusura_ristr,
cod_matricola_inserente,
cod_causale_ch_ristr,
cod_microtipologia_delib,
flg_rdv,
val_ordinale,
dta_delibera
FROM t_mcrei_app_ristrutturazioni r,
t_mcre0_app_all_data         a
WHERE r.cod_abi = a.cod_abi_cartolarizzato
AND r.cod_ndg = a.cod_ndg
AND a.today_flg = 1

--                           WHERE COD_ABI = '01025'
--                             AND COD_NDG = '0003039381125000'
ORDER BY 1, 2)

LOOP
v_pos_da_processare := v_pos_da_processare + 1;

BEGIN
--1) si crea la delibera di tipo IR
pkg_mcrei_audit.log_app(c_nome, pkg_mcrei_audit.c_debug, SQLCODE,
SQLERRM, p_note, 'BATCH');

p_note := 'Inserisce delibera IR per la posizione con abi: ' ||
pos_da_ristr.abi || 'e ndg: ' || pos_da_ristr.ndg;
IF pos_da_ristr.dta_efficacia_ristr IS NOT NULL
THEN
v_dta_efficacia := pos_da_ristr.dta_efficacia_ristr;
ELSE
v_dta_efficacia := to_date('01012011', 'DDMMYYYY');
END IF;
v_dta_delibera := pos_da_ristr.dta_delibera;
prc_crea_delibera_impianto_ri(p_cod_abi => pos_da_ristr.abi,
p_cod_ndg => pos_da_ristr.ndg,
p_dta_efficacia_ristr => v_dta_efficacia,
p_dta_efficacia_add => pos_da_ristr.dta_efficacia_add,
p_dta_scadenza_ristr => pos_da_ristr.dta_scadenza_ristr,
p_desc_tipo_ristr => pos_da_ristr.desc_tipo_ristr,
p_desc_intento_ristr => pos_da_ristr.desc_intento_ristr,
p_dta_delibera => v_dta_delibera,
p_proto => v_protodel,
p_proto_pacch => v_protopac);

IF v_protodel IS NULL
THEN
p_note := 'WARNING: Non trovata classificazione per ' ||
pos_da_ristr.abi || ', ' || pos_da_ristr.ndg;
raise_application_error(-20998,
'Non trovata classificazione, vedi NOTE');
END IF;
--2) si crea la riga nella HST_RISTRUTTURAZIONI
pkg_mcrei_audit.log_app(c_nome, pkg_mcrei_audit.c_debug, SQLCODE,
SQLERRM, p_note, 'BATCH');

p_note := 'Inserisce posizione con abi: ' || pos_da_ristr.abi ||
'e ndg: ' || pos_da_ristr.ndg ||
' nella hst_ristrutturazioni';

v_out_ordinale := mcre_own.pkg_mcrei_web_utilities.insert_hst_ristrutturazioni(pos_da_ristr.dta_scadenza_ristr,
              pos_da_ristr.abi,
              pos_da_ristr.ndg,
              v_protodel,
              v_protopac,
              pos_da_ristr.desc_tipo_ristr,
              pos_da_ristr.desc_intento_ristr,
              NULL,
               --COD_STATO_PROPOSTO
              'BATCH',
               --MATRICOLA
              'IR',
               --MICROTIPOLOGIA
              NULL,
               --FLG_RDV
              v_dta_efficacia,
              pos_da_ristr.dta_efficacia_add); --DTA_EFFICIACIA

IF v_out_ordinale != 0 ----ALLORA TUTTO OK
THEN
pkg_mcrei_audit.log_app(c_nome, pkg_mcrei_audit.c_debug, SQLCODE,
SQLERRM, p_note, 'BATCH');
ELSE
pkg_mcrei_audit.log_app(c_nome, pkg_mcrei_audit.c_error, SQLCODE,
SQLERRM, p_note, 'BATCH');

p_note := 'Inserimento in HST_RISTRUTTURAZIONI non riuscito per ' ||
pos_da_ristr.abi || ', ' || pos_da_ristr.ndg;

raise_application_error(-20998,
'Inserimento in hst ristrutturazioni non riuscita, vedi note');
END IF;

--3) si creano i record nella STIME, corrispondenti ai rapporti associati presenti nella t_mcrei_app_rapp_ristr
p_note := 'Inserisce nella t_mcrei_App_stime i rapporti legati a posizione con abi: ' ||
pos_da_ristr.abi || 'e ndg: ' || pos_da_ristr.ndg;

prc_crea_stime_impianto(pos_da_ristr.abi, pos_da_ristr.ndg,
v_protodel, v_dta_efficacia);

--4) si creano le righe nella HST_RAPP_RISTR, corrispondenti ai rapporti associati presenti nella t_mcrei_app_rapp_ristr
p_note := 'Inserisce nella HST_RAPP_RISTR i rapporti ristrutturati legati a posizione con abi: ' ||
pos_da_ristr.abi || 'e ndg: ' || pos_da_ristr.ndg;

prc_popola_hst_rapp_ristr(pos_da_ristr.abi, pos_da_ristr.ndg,
v_protodel, v_out_ordinale, v_dta_efficacia);
--5) si popola la coda delle posizioni che verr? elaborata dal job java con l'immagine corrispondente al max(ordinale) presente nella HST_RISTRUTTURAZIONI,

p_note := 'popola_coda_posizioni per con abi: ' || pos_da_ristr.abi ||
'e ndg: ' || pos_da_ristr.ndg;

prc_popola_coda_posizioni(pos_da_ristr.abi, pos_da_ristr.ndg,
v_out_ordinale, v_dta_delibera);
--6) si popola la coda dei rapporti che verr? elaborata dal job java con l'immagine corrispondente al max(ordinale) presente nella HST_RISTRUTTURAZIONI,
p_note := 'popola_coda_rapporti per abi: ' || pos_da_ristr.abi ||
'e ndg: ' || pos_da_ristr.ndg;
prc_popola_coda_rapporti(pos_da_ristr.abi, pos_da_ristr.ndg,v_out_ordinale);

/***********************************************************************************
per ogni posizione processata, se si tratta di una ristrutturazione totale senza
intento liquidatorio, quindi con cambio di stato a RS, si inseriscono:

1) una riga nei percorsi che attesti il cambio stato
2) una riga nella t_mcre0_app_rs_posizioni per censisco l'ingresso in
stato Ristrutturato
************************************************************************************/
IF (POS_DA_RISTR.DESC_TIPO_RISTR = 'T' AND
POS_DA_RISTR.DESC_INTENTO_RISTR ='N')

THEN

V_NUM_RS_PREVISTI := V_NUM_RS_PREVISTI +1;

BEGIN  -- INIZIO GESTIONE CAMBIO STATO

ret := mcre_own.pkg_mcre0_funzioni_portale.aggiorna_stato(pos_da_ristr.Abi,
pos_da_ristr.ndg,
pos_da_ristr.cod_sndg,
pos_da_ristr.stato_new, --'RS'
pos_da_ristr.scad_stato,
'BATCH');


V_NUM_RS_GESTITI := V_NUM_RS_GESTITI +1;

EXCEPTION
WHEN OTHERS THEN

pkg_mcrei_audit.log_app(c_nome,
pkg_mcrei_audit.c_error,
SQLCODE,
SQLERRM,
'Fallita ' || p_note||'per: '||pos_da_ristr.abi||' ndg:'||pos_da_ristr.ndg, 'BATCH');
END; ---FINE GESTIONE CAMBIO STATO

END IF;

---COMMITTA DOPO OGNI POSIZIONE PORTATA A TERMINE CORRETTAMENTE
COMMIT;
v_pos_processate := v_pos_processate + 1;
EXCEPTION
WHEN OTHERS THEN
ROLLBACK;
pkg_mcrei_audit.log_app(c_nome, pkg_mcrei_audit.c_error, SQLCODE,
SQLERRM, 'Fallimento ' || p_note, 'BATCH');
--          EXIT; ---procede con la posizione successiva -->  ????
END;

END LOOP;
v_posizioni_da_processare := v_pos_da_processare;
v_posizioni_processate    := v_pos_processate;

EXCEPTION
WHEN OTHERS THEN
ROLLBACK;
pkg_mcrei_audit.log_app(c_nome, pkg_mcrei_audit.c_error, SQLCODE,
SQLERRM, p_note, 'BATCH');
END prc_main;

-- %USAGE FUNCTION CHE INDIVIDUA I RAPPORTI NUOVI SU UNA POSIZIONE
-- %D SE LA POSIZIONE INDIVIDUA UNA RISTRUTTURAIONE PARZIALE LA
-- %D GESTIONE COINCIDE CON QUELLA DELL'ALERT 'RISTRUTTURAZIONI PARZIALI
-- %D CON RAPPORTI PRIVI DI ATTRIBUTO'
-- %D SE LA RISTRUTTURAZINE E' TOTALE L'AGGIORNAMENTO DELLA RISTRUTTURAZIONE E'
-- %D GESTITO IN AUTOMATICO
-- %param p_cod_abi ABI
-- %param p_cod_ndg NDG
FUNCTION fnc_gest_nuovi_rapporti(p_cod_abi IN T_MCREI_HST_RISTRUTTURAZIONI.cod_abi%TYPE,
p_cod_ndg IN T_MCREI_HST_RISTRUTTURAZIONI.cod_ndg%TYPE,
p_tipo_ristr in t_mcrei_hst_ristrutturazioni.desc_tipo_ristr%type,
p_val_ordinale in t_mcrei_hst_ristrutturazioni.val_ordinale%type,
P_COD_PROTOCOLLO_DELIBERA IN T_MCREI_HST_RISTRUTTURAZIONI.COD_PROTOCOLLO_DELIBERA%TYPE,
P_COD_MICROTIPOLOGIA_DELIB IN T_MCREI_HST_RISTRUTTURAZIONI.COD_MICROTIPOLOGIA_DELIB%TYPE,
P_VARIAZIONE OUT NUMBER,
P_DTA_DELIBERA OUT DATE)
RETURN NUMBER IS
c_nome CONSTANT VARCHAR2(100) := c_package || '.gest_nuovi_rapporti';
p_note                  t_mcrei_wrk_audit_applicativo.note%TYPE;
p_param                 VARCHAR2(500);
v_esiste_rapporto_nuovo BOOLEAN := FALSE;
v_dta_delibera          DATE := NULL;
V_FLG_RISTRUTTURATO     T_MCREI_HST_RISTRUTTURAZIONI.DESC_TIPO_RISTR%TYPE :='Y';
V_ESIST_RIST_EST        BOOLEAN:=FALSE;
V_DTA_INIZIO_PCR        DATE;
-- RILEVAZIONE NUOVI RAPPORTI RISPETTOA PCR E RAPPORTI ESTERI
-- SE ESISTE NPE LO SI RILEVA
CURSOR c_nr IS
SELECT   distinct
         HST_RAPP.FLG_ESTINTO,
         hst_rapp.val_ordinale AS val_ordinale_r, R.ID_DPER, r.cod_abi,
         r.cod_ndg, r.cod_sndg, r.cod_rapporto, r.cod_forma_tecnica,
         r.cod_classe_ft, RE.COD_NPE,
         SUM(r.val_imp_utilizzato) OVER (PARTITION BY r.cod_abi, r.cod_ndg, r.cod_rapporto) val_esposizione,
         SUM(r.val_accordato_delib) OVER (PARTITION BY r.cod_abi, r.cod_ndg, r.cod_rapporto)val_Accordato,
         sum (nvl(r.val_imp_utilizzato,0) - NVL (i.val_imp_mora, 0) ) over(PARTITION BY r.cod_abi, r.cod_ndg, r.cod_rapporto)  AS val_utilizzato_netto,
         sum(NVL (i.val_imp_mora, 0)) over(PARTITION BY r.cod_abi, r.cod_ndg, r.cod_rapporto) AS val_utilizzato_mora
  FROM   t_mcrei_app_pcr_rapporti r,
         t_mcre0_app_rate_daily i,
         t_mcrei_app_rapporti_estero re,
         (SELECT RR.COD_ABI, RR.COD_NDG, RR.COD_RAPPORTO, RR.VAL_ORDINALE,RR.FLG_ESTINTO
         FROM T_MCREI_HST_RAPP_RISTR RR
         where rr.cod_abi = p_cod_abi
           and rr.cod_ndg = p_cod_ndg
           and rr.val_ordinale = p_val_ordinale
           AND RR.FLG_ESTINTO = 'N'
         ) HST_RAPP
 WHERE       r.cod_abi = hst_rapp.cod_abi(+)
         AND r.cod_ndg = hst_rapp.cod_ndg(+)
         AND r.cod_rapporto = hst_rapp.cod_rapporto(+)
         AND hst_rapp.cod_rapporto IS NULL
         AND r.cod_abi = p_COD_ABI
         AND r.cod_ndg = p_COD_NDG
         AND r.cod_abi = i.cod_abi_cartolarizzato(+)
         AND r.cod_ndg = i.cod_ndg(+)
         AND r.cod_rapporto = i.cod_rapporto(+)
         AND R.COD_ABI = RE.COD_ABI(+)
         AND R.COD_NDG = RE.COD_NDG(+)
         AND R.COD_RAPPORTO = RE.COD_RAPPORTO_ESTERO(+);
BEGIN
p_param := 'ABI ' || p_cod_abi || ', NDG ' || p_cod_ndg;
p_note  := 'Recupero max ordinale per ' || p_param ||CHR(10);
P_VARIAZIONE:= 0;
P_DTA_DELIBERA:=TO_DATE(NULL);
V_DTA_INIZIO_PCR:=SYSDATE;

BEGIN
    SELECT   dta_delibera
      INTO   v_dta_delibera
      FROM   t_mcrei_app_delibere
     WHERE       cod_abi = p_cod_abi
             AND cod_ndg = p_cod_ndg
             AND cod_protocollo_delibera = P_COD_PROTOCOLLO_DELIBERA;
EXCEPTION WHEN OTHERS THEN
    V_DTA_DELIBERA:=TO_CHAR(NULL);
    p_note:=p_note||' dta_delibera non recuperata';
    pkg_mcrei_audit.log_app(c_nome,pkg_mcrei_audit.c_error,SQLCODE,SQLERRM,p_note,NULL);

END;


FOR r_nr IN c_nr
LOOP

IF p_tipo_ristr = 'P' THEN
    BEGIN
    SELECT   FLG_RISTRUTTURATO, DTA_INIZIO_SEGNALAZIONE_RISTR
      INTO   V_FLG_RISTRUTTURATO, V_DTA_INIZIO_PCR
      FROM   T_MCREI_HST_RAPP_RISTR
     WHERE       cod_abi = p_cod_abi
             AND cod_ndg = p_cod_ndg
             AND COD_NPE = R_NR.COD_NPE
             AND R_NR.COD_NPE IS NOT NULL
             AND ROWNUM = 1;
    V_ESIST_RIST_EST:=TRUE;
    EXCEPTION WHEN NO_DATA_FOUND THEN
    V_ESIST_RIST_EST:=FALSE;--- PRIMO RAPPORTO ESTERO INSERITO , S VERO CHE S RISTRUTTURATO? VA INSERITO ???
    END;
END IF;

-- SE IL NUOVO RAPPORTO RILEVATO HA GIA UN FRATELLO ESTERO RISTRUTTURATO ALLORA IL NUOVO RAPPORTO
-- EREDITA TUTTE LE INFORMAZIONI
IF P_TIPO_RISTR = 'T' OR (P_TIPO_RISTR = 'P' AND R_NR.COD_NPE IS NOT NULL AND V_ESIST_RIST_EST) THEN
v_esiste_rapporto_nuovo := TRUE;
BEGIN
    p_note:=' '||p_note||' INSERIMENTO HST_RISTRUTTURAZIONI per ' ||p_param || ', COD_RAPPORTO ' ||
r_nr.cod_rapporto||chr(10);
EXCEPTION WHEN OTHERS THEN NULL;
END;


DELETE FROM   t_mcrei_hst_rapp_ristr
      WHERE       cod_abi = r_nr.cod_abi
              AND cod_ndg = r_nr.cod_ndg
              AND cod_rapporto = r_nr.cod_rapporto
              AND val_ordinale =p_val_ordinale;
COMMIT;

INSERT INTO t_mcrei_hst_rapp_ristr (id_dper,
                                    val_ordinale,
                                    cod_abi,
                                    cod_ndg,
                                    cod_sndg,
                                    cod_rapporto,
                                    dta_stima,
                                    flg_tipo_dato,
                                    cod_forma_tecnica,
                                    cod_classe_ft,
                                    cod_protocollo_delibera_padre,
                                    cod_microtipologia_delibera,
                                    val_esposizione,
                                    val_accordato,
                                    val_utilizzato_netto,
                                    val_utilizzato_mora,
                                    flg_estinto,
                                    flg_nuovo,
                                    dta_estinzione,
                                    dta_nascita,
                                    flg_da_alert,
                                    flg_ristrutturato,
                                    dta_inizio_segnalazione_ristr,
                                    dta_fine_segnalazione_ristr,
                                    dta_ins,
                                    cod_operatore_ins_upd,
                                    flg_attiva,
                                    cod_npe)
     VALUES (TO_NUMBER (TO_CHAR (SYSDATE, 'yyyymmdd')),
             p_val_ordinale,
             r_nr.cod_abi,
             r_nr.cod_ndg,
             r_nr.cod_sndg,
             r_nr.cod_rapporto,
             SYSDATE,  -- DTA_STIMA
             'R',            -- FLG_TIPO_DATO
             r_nr.cod_forma_tecnica,
             r_nr.cod_classe_ft,
             p_cod_protocollo_delibera,
             P_COD_MICROTIPOLOGIA_DELIB,
             r_nr.val_esposizione,
             r_nr.val_accordato,
             r_nr.val_utilizzato_netto,
             r_nr.val_utilizzato_mora,
             'N',                                           -- AS FLG_ESTINTO,
             'Y',                                             -- AS FLG_NUOVO,
             TO_DATE (NULL),                              -- AS DTA_ESTIZIONE,
             SYSDATE,                                       -- AS DTA_NASCITA,
             'N',                                          -- AS FLG_DA_ALERT,
             V_FLG_RISTRUTTURATO,                     -- AS FLG_RISTRUTTURATO,
             DECODE (V_FLG_RISTRUTTURATO, 'Y', V_DTA_INIZIO_PCR), -- AS DTA_INIZIO_SEGNALAZIONE_RISTR,
             TO_DATE (NULL),                  --AS DTA_FINE_SEGNALAZIONE_RISTR
             SYSDATE,                                               -- dta_ins
             'BATCH',                                  --COD_OPERATORE_INS_UPD
             '1',                                                -- FLG_ATTIVA
             r_nr.cod_npe);

DELETE FROM   t_mcrei_app_stime
      WHERE       cod_abi = r_nr.cod_abi
              AND cod_ndg = r_nr.cod_ndg
              AND cod_rapporto = r_nr.cod_rapporto
              AND cod_protocollo_delibera = p_cod_protocollo_delibera;

INSERT INTO t_mcrei_app_stime (id_dper,
                               cod_abi,
                               cod_ndg,
                               cod_sndg,
                               cod_rapporto,
                               dta_stima,
                               flg_tipo_dato,
                               cod_forma_tecnica,
                               cod_classe_ft,
                               cod_protocollo_delibera,
                               cod_microtipologia_delibera,
                               val_esposizione,
                               val_accordato,
                               val_utilizzato_netto,
                               val_utilizzato_mora,
                               flg_ristrutturato,
                               dta_inizio_segnalazione_ristr,
                               dta_fine_segnalazione_ristr,
                               dta_ins,
                               cod_operatore_ins_upd,
                               flg_attiva,
                               cod_npe)
     VALUES (TO_NUMBER (TO_CHAR (SYSDATE, 'yyyymmdd')),
             r_nr.cod_abi,
             r_nr.cod_ndg,
             r_nr.cod_sndg,
             r_nr.cod_rapporto,
             SYSDATE,                                             -- DTA_STIMA
             'R',                                             -- FLG_TIPO_DATO
             r_nr.cod_forma_tecnica,
             r_nr.cod_classe_ft,
             p_cod_protocollo_delibera,
             p_cod_microtipologia_delib,
             r_nr.val_esposizione,
             r_nr.val_accordato,
             r_nr.val_utilizzato_netto,
             r_nr.val_utilizzato_mora,
             V_FLG_RISTRUTTURATO,                     -- AS FLG_RISTRUTTURATO,
             DECODE (V_FLG_RISTRUTTURATO, 'Y', V_DTA_INIZIO_PCR), -- AS DTA_INIZIO_SEGNALAZIONE_RISTR, ???
             TO_DATE (NULL),              --AS DTA_FINE_SEGNALAZIONE_RISTR ???
             SYSDATE,
             'BATCH',
             '1',
             r_nr.cod_npe);
END IF;
END LOOP;
IF v_esiste_rapporto_nuovo
THEN
    P_NOTE:=P_NOTE||CHR(10)||'Rilevati nuovi rapporti';
    P_VARIAZIONE:=1;
ELSE
   P_NOTE:=P_NOTE||CHR(10)||'Nessun rapporto nuovo rilevato';
END IF;
P_DTA_DELIBERA:= v_dta_delibera;
pkg_mcrei_audit.log_app(c_nome,pkg_mcrei_audit.c_error,SQLCODE,SQLERRM,p_note,NULL);
COMMIT;
RETURN p_val_ordinale;
EXCEPTION
WHEN OTHERS THEN
ROLLBACK;
pkg_mcrei_audit.log_app(c_nome,pkg_mcrei_audit.c_error,SQLCODE,SQLERRM,p_note,NULL);
RETURN pkg_mcrei_gest_batch.ko;
END fnc_gest_nuovi_rapporti;

  --%USAGE funzione che gestisce i rapporti estinti delle posizioni con ristrutturazione
  --%d la gestione e' la stessa per le ristrutturazioni parziali (DEDSC_TIPO_RISTR = 'P')
  --%d  e quelle totali (DESC_TIPO_RISTR = 'T')
  FUNCTION fnc_gest_rapporti_estinti(p_cod_abi IN T_MCREI_HST_RISTRUTTURAZIONI.cod_abi%TYPE,
p_cod_ndg IN T_MCREI_HST_RISTRUTTURAZIONI.cod_ndg%TYPE,
p_tipo_ristr in t_mcrei_hst_ristrutturazioni.desc_tipo_ristr%type,
p_val_ordinale in t_mcrei_hst_ristrutturazioni.val_ordinale%type,
P_COD_PROTOCOLLO_DELIBERA IN T_MCREI_HST_RISTRUTTURAZIONI.COD_PROTOCOLLO_DELIBERA%TYPE,
P_COD_MICROTIPOLOGIA_DELIB IN T_MCREI_HST_RISTRUTTURAZIONI.COD_MICROTIPOLOGIA_DELIB%TYPE,
P_VARIAZIONE OUT NUMBER,
P_DTA_DELIBERA OUT DATE)
    RETURN NUMBER IS
c_nome CONSTANT VARCHAR2(100) := c_package || '.GEST_RAPPORTI_ESTINTI';
p_note            t_mcrei_wrk_audit_applicativo.note%TYPE;
p_param           VARCHAR2(500);
v_inserito_record BOOLEAN := FALSE;
v_dta_delibera    DATE := NULL;
V_DTA_ENTRATA     DATE:=NULL;
V_DTA_LAST_UPD    DATE:=NULL;

CURSOR c_nr IS
    SELECT DISTINCT
    hst_rapp.val_ordinale      AS val_ordinale_r,
    hst_rapp.cod_abi,
    hst_rapp.cod_ndg,
    hst_rapp.cod_sndg,
    hst_rapp.cod_rapporto,
    hst_rapp.flg_ristrutturato,
    hst_rapp.flg_estinto,
    hst_rapp.dta_inizio_segnalazione_ristr,
    hst_rapp.dta_fine_segnalazione_ristr,
    hst_rapp.cod_npe
    FROM (SELECT rst.*
     FROM t_mcrei_hst_rapp_ristr rst
    WHERE rst.cod_abi =P_COD_ABI
    AND rst.cod_ndg=P_COD_NDG
    AND RST.VAL_ORDINALE = P_VAL_ORDINALE) hst_rapp,
    t_mcrei_app_pcr_rapporti r
    WHERE hst_rapp.cod_abi = r.cod_abi(+)
    AND hst_rapp.cod_ndg = r.cod_ndg(+)
    AND hst_rapp.cod_rapporto = r.cod_rapporto(+)
    AND r.cod_rapporto IS NULL
    AND hst_rapp.cod_abi = P_cod_abi
    AND hst_rapp.cod_ndg = P_cod_ndg
    AND hst_rapp.flg_inviato = 0;

BEGIN
p_param := 'ABI ' || p_cod_abi || ', NDG ' || p_cod_ndg;
p_note  := 'Recupero max ordinale per ' || p_param;

BEGIN
    SELECT dta_delibera
    INTO v_dta_delibera
    FROM t_mcrei_app_delibere
    WHERE cod_abi = p_cod_abi
        AND cod_ndg = p_cod_ndg
        AND cod_protocollo_delibera = P_COD_PROTOCOLLO_DELIBERA;
EXCEPTION WHEN OTHERS THEN
    V_DTA_DELIBERA:=TO_CHAR(NULL);
    p_note:=p_note||' dta_delibera non recuperata';
    pkg_mcrei_audit.log_app(c_nome,pkg_mcrei_audit.c_error,SQLCODE,SQLERRM,p_note,NULL);

END;


    P_DTA_DELIBERA:=V_DTA_dELIBERA;
    FOR r_nr IN c_nR
    LOOP
    -- INIZIO RICERCO SE ERA CANDIDATO AL'ESTINZIONE
        BEGIN
        SELECT TRUNC(DTA_ENTRATA), TRUNC(DTA_LAST_UPD)
          INTO V_DTA_ENTRATA, V_DTA_LAST_UPD
          FROM T_MCREI_HST_RAPP_RISTR_CANDEST
        WHERE COD_ABI = P_COD_ABI
          AND COD_NDG = P_COD_NDG
          AND COD_RAPPORTO = R_NR.COD_RAPPORTO;

        EXCEPTION WHEN NO_DATA_FOUND THEN
           V_DTA_ENTRATA:=NULL;
           INSERT INTO T_MCREI_HST_RAPP_RISTR_CANDEST(
           COD_ABI, COD_NDG, COD_SNDG, COD_RAPPORTO,VAL_ORDINALE,
           DTA_ENTRATA, DTA_LAST_UPD,
           FLG_ESTINTO, FLG_RISTRUTTURATO,
           DTA_INIZIO_SEGNALAZIONE_RISTR,
           DTA_FINE_SEGNALAZIONE_RISTR )
         VALUES(
           R_NR.COD_ABI, R_NR.COD_NDG, R_NR.COD_SNDG, R_NR.COD_RAPPORTO,P_VAL_ORDINALE,
           TRUNC(SYSDATE), TRUNC(SYSDATE),
           'N', R_NR.FLG_RISTRUTTURATO,
           R_NR.DTA_INIZIO_SEGNALAZIONE_RISTR,
           R_NR.DTA_FINE_SEGNALAZIONE_RISTR);

        END;

         UPDATE  T_MCREI_HST_RAPP_RISTR_CANDEST
           SET DTA_LAST_UPD=TRUNC(SYSDATE),
               VAL_ORDINALE = P_VAL_ORDINALE,
               FLG_RISTRUTTURATO = R_NR.FLG_RISTRUTTURATO,
               DTA_INIZIO_SEGNALAZIONE_RISTR = R_NR.DTA_INIZIO_SEGNALAZIONE_RISTR,
               DTA_FINE_SEGNALAZIONE_RISTR = R_NR.DTA_FINE_SEGNALAZIONE_RISTR
        WHERE COD_ABI = P_COD_ABI
          AND COD_NDG = P_COD_NDG
          AND COD_RAPPORTO = R_NR.COD_RAPPORTO;
       IF V_DTA_ENTRATA IS NOT NULL AND ((V_DTA_LAST_UPD - V_DTA_ENTRATA)>=5) THEN
                IF r_nr.flg_ristrutturato = 'Y' and (R_NR.FLG_ESTINTO = 'N' OR R_NR.FLG_ESTINTO IS NULL) THEN
                    V_INSERITO_RECORD:=TRUE;
                END IF;
                DELETE FROM T_MCREI_HST_RAPP_RISTR_CANDEST
                WHERE COD_ABI = P_COD_ABI
                 AND COD_NDG = P_COD_NDG
                 AND COD_RAPPORTO = R_NR.COD_RAPPORTO;

                UPDATE t_mcrei_hst_rapp_ristr T
                    SET T.flg_ristrutturato           = CASE WHEN COD_NPE IS NULL THEN-- RAPPORTO NON ESTERO
                                                        CASE WHEN R_NR.FLG_RISTRUTTURATO = 'Y' THEN 'N'
                                                             ELSE T.FLG_RISTRUTTURATO END
                                                     ELSE T.FLG_RISTRUTTURATO END,
                    T.DTA_FINE_SEGNALAZIONE_RISTR  = CASE WHEN COD_NPE IS NULL THEN-- RAPPORTO NON ESTERO
                                                        CASE WHEN R_NR.FLG_RISTRUTTURATO = 'Y' THEN SYSDATE
                                                             ELSE T.DTA_FINE_SEGNALAZIONE_RISTR END
                                                     ELSE T.DTA_FINE_SEGNALAZIONE_RISTR END,
                    T.flg_estinto                 = 'Y',
                    T.flg_nuovo                   = 'N',
                    T.dta_estinzione              = NVL(DTA_ESTINZIONE,SYSDATE),
                    T.flg_da_alert                = 'N',
                    T.dta_upd                     = SYSDATE
                    --dta_fine_segnalazione_ristr = decode(r_nr.flg_estinto, 'N',SYSDATE, to_char(null),sysdate,null)
                WHERE val_ordinale = P_VAL_ORDINALE
                    AND cod_abi = r_nr.cod_abi
                    AND cod_ndg = r_nr.cod_ndg
                    AND cod_rapporto = r_nr.cod_rapporto;
                UPDATE t_mcrei_app_stime T
                SET
                  T.flg_ristrutturato           = CASE WHEN COD_NPE IS NULL THEN-- RAPPORTO NON ESTERO
                                                    CASE WHEN R_NR.FLG_RISTRUTTURATO = 'Y' THEN 'N'
                                                         ELSE T.FLG_RISTRUTTURATO END
                                                 ELSE T.FLG_RISTRUTTURATO END,
                T.DTA_FINE_SEGNALAZIONE_RISTR  = CASE WHEN COD_NPE IS NULL THEN-- RAPPORTO NON ESTERO
                                                    CASE WHEN R_NR.FLG_RISTRUTTURATO = 'Y' THEN SYSDATE
                                                         ELSE T.DTA_FINE_SEGNALAZIONE_RISTR END
                                                 ELSE T.DTA_FINE_SEGNALAZIONE_RISTR END,
                dta_upd                     = SYSDATE
                WHERE cod_abi = r_nr.cod_abi
                AND cod_ndg = r_nr.cod_ndg
                AND cod_rapporto = r_nr.cod_rapporto
                AND cod_protocollo_delibera = P_COD_PROTOCOLLO_DELIBERA;

          END IF;

    END LOOP;
    IF V_INSERITO_RECORD THEN
     p_note:=p_note||chr(10)||'Rilevati rapporti estinti ';
     P_VARIAZIONE:=1;
    ELSE p_note:=p_note||chr(10)||'Nessun rapporto estinto inviato';
    END IF;
    pkg_mcrei_audit.log_app(c_nome,pkg_mcrei_audit.c_error,SQLCODE, SQLERRM,p_note,NULL);
COMMIT;
RETURN P_VAL_ORDINALE;
EXCEPTION
WHEN OTHERS THEN
ROLLBACK;
pkg_mcrei_audit.log_app(c_nome,pkg_mcrei_audit.c_error,SQLCODE,SQLERRM,p_note,NULL);
RETURN pkg_mcrei_gest_batch.ko;
END fnc_gest_rapporti_estinti;

  -- %d La funzione svuota la tabella T_MCREI_APP_RAPP_RISTR e
  -- %d carica i dati convertiti dalla tabella esterna TE_MCREI_RISTRUTTURATI_RAPP
  -- %d esegue la seguente decodifica sul campo N184 della TE_MCREI_RISTRUTTURATI_RAPP
  -- %d N184=1: parziale; N184 = 2: totale con intento liquidatorio, N184 = 3: totale senza intento liquidatorio
  -- %return 1 -> Esecuzione terminata con successo, 0 -> Esecuzione con errori / esecuzione non avvenuta
FUNCTION fnc_carica_posizioni RETURN NUMBER IS
c_nome CONSTANT VARCHAR2(100) := c_package || '.CARICA_POSIZIONI';
p_note t_mcrei_wrk_audit_applicativo.note%TYPE;
BEGIN

    DELETE t_mcrei_app_ristrutturazioni;
    p_note := 'Insert posizioni da risrutturare';
    INSERT INTO t_mcrei_app_ristrutturazioni
    (cod_abi,
    cod_ndg,
    desc_tipo_ristr, -- T,P
    desc_intento_ristr, --Y,N
    dta_efficacia_ristr,
    dta_efficacia_add,
    dta_ins,
    dta_scadenza_ristr,
    dta_inizio_ristr,
    dta_delibera)
    SELECT decode(r.cod_abi, '03069', '01025', r.cod_abi) AS cod_abi,
    lpad(r.cod_schedario, 16, '0'),
    decode(flg_ristrutturato, '1', 'P', '2', 'T', '3', 'T') AS desc_tipo_ristr,
    decode(flg_ristrutturato,'1',NVL(cod_intento,'Y'),'2','Y',3,'N') AS desc_intento_ristr,
    nvl(dta_efficacia_ristr, to_date('01012011', 'DDMMYYYY')),
    dta_efficacia_add,
    SYSDATE,
    dta_scadenza_ristr,
    dta_inizio_ristr,
    dta_delibera
    FROM te_mcrei_ristrutturati r;
RETURN pkg_mcrei_gest_batch.ko;
END fnc_carica_posizioni;

-- %d La funzione svuota la tabella T_MCREI_APP_RAPP_RISTR e
-- %d carica i dati convertiti dalla tabella esterna TE_MCREI_RISTRUTTURATI_RAPP
-- %return 1 -> Esecuzione terminata con successo, 0 -> Esecuzione con errori / esecuzione non avvenuta
FUNCTION fnc_carica_rapporti RETURN NUMBER IS
c_nome CONSTANT VARCHAR2(100) := c_package || '.CARICA_RAPPORTI';
p_note t_mcrei_wrk_audit_applicativo.note%TYPE;
BEGIN

    DELETE t_mcrei_app_rapp_ristr;
    p_note := 'Insert rapporti di posizioni risrutturate';
    DELETE t_mcrei_app_rapp_ristr;
    INSERT INTO t_mcrei_app_rapp_ristr
    (id_dper,
    cod_abi,
    cod_ndg,
    cod_rapporto,
    flg_ristrutturato,
    dta_inizio_segnalazione_ristr,
    dta_ins)
    SELECT to_number(to_char(SYSDATE, 'YYYYMMDD')),
    decode(rr.cod_abi, '03069', '01025', rr.cod_abi) AS cod_abi,
    lpad(rr.cod_schedario, 16, '0') AS cod_ndg,
    concat(lpad(ltrim(cod_sportello, '0'), 5, '0'),
    rr.cod_rapporto) AS cod_rapporto,
    decode(flg_ristrutturato, '0', 'N', 'Y') AS flg_ristrutturato,
    dta_inizio_segnalazione,
    SYSDATE
    FROM te_mcrei_ristrutturati_rapp rr;
    RETURN pkg_mcrei_gest_batch.ok;
EXCEPTION
WHEN OTHERS THEN
    pkg_mcrei_audit.log_app(c_nome,
    pkg_mcrei_audit.c_error,
    SQLCODE,
    SQLERRM,
    p_note,
    NULL);
    RETURN pkg_mcrei_gest_batch.ko;
END fnc_carica_rapporti;

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
function prc_main_batch_ris(p_rec IN f_slave_par_type) return number AS


v_pos_da_processare NUMBER := 0;
v_pos_processate    NUMBER := 0;
c_nome CONSTANT     VARCHAR2(100) := c_package || '.PRC_MAIN_BATCH_RIS';
p_note              t_mcrei_wrk_audit_applicativo.note%TYPE;
V_MAX_ORDINALE      NUMBER;
V_RET               NUMBER;
V_VARIAZIONE_E      NUMBER:=0;
V_VARIAZIONE_N      NUMBER:=0;
V_DTA_DELIBERA      DATE;

CURSOR C_POS_DA_PROC IS
SELECT RD.COD_ABI, RD.COD_NDG,RD.DESC_TIPO_RISTR, RD.VAL_ORDINALE, RD.COD_PROTOCOLLO_DELIBERA,
       RD.cod_microtipologia_delib
  FROM
  (SELECT DISTINCT COD_ABI, COD_NDG, MAX(VAL_ORDINALE) OVER (PARTITION BY COD_ABI, COD_NDG) MAX_ORDINALE
    FROM T_MCREI_HST_RISTRUTTURAZIONI)RM,
  T_MCREI_HST_RISTRUTTURAZIONI RD
WHERE RD.COD_ABI = RM.COD_ABI
  AND RD.COD_NDG = RM.COD_NDG
  AND RD.VAL_ORDINALE = RM.MAX_ORDINALE
  AND RD.DTA_CHIUSURA_RISTR IS NULL;

BEGIN
FOR r in C_POS_DA_PROC LOOP
BEGIN
    V_MAX_ORDINALE := fnc_gest_rapporti_estinti(r.cod_abi,r.cod_ndg, r.desc_tipo_ristr,
                                                r.val_ordinale,R.COD_PROTOCOLLO_DELIBERA,
                                                R.cod_microtipologia_delib,
                                                V_VARIAZIONE_E,V_DTA_DELIBERA);

    V_MAX_ORDINALE := fnc_gest_nuovi_rapporti(r.cod_abi,r.cod_ndg,r.desc_tipo_ristr,
                                              r.val_ordinale, R.COD_PROTOCOLLO_DELIBERA,
                                              R.cod_microtipologia_delib, V_VARIAZIONE_N,V_DTA_DELIBERA);

    IF V_VARIAZIONE_E = 1 OR V_VARIAZIONE_N = 1 THEN
        prc_popola_coda_posizioni(p_codabi   => R.COD_ABI,
                    p_codndg   => R.COD_NDG,
                    p_ordinale => V_MAX_ORDINALE,
                    p_dta_del  => V_DTA_DELIBERA);
    END IF;
    prc_cancella_rapporti_arrivati;
--    v_ret:=pkg_mcrei_alert.fnc_mcrei_calcolo_id(8);
EXCEPTION
WHEN OTHERS THEN
    ROLLBACK;
    pkg_mcrei_audit.log_app(c_nome,pkg_mcrei_audit.c_error, SQLCODE,SQLERRM, p_note, 'BATCH');
    END;
    END LOOP;
        prc_popola_coda_rapporti(p_codabi   => NULL,
        p_codndg   => NULL,
        p_ordinale => NULL);
    return ok;
EXCEPTION
WHEN OTHERS THEN
    ROLLBACK;
    pkg_mcrei_audit.log_app(c_nome,
    pkg_mcrei_audit.c_error,
    SQLCODE,
    SQLERRM,
    p_note,
    'BATCH');
    return ko;
END prc_main_batch_ris;
  procedure prc_cancella_rapporti_arrivati IS
  BEGIN
    BEGIN
       DELETE T_MCREI_HST_RAPP_RISTR_CANDEST S
        WHERE EXISTS (
       SELECT DISTINCT COD_ABI, COD_NDG, COD_RAPPORTO
        FROM T_MCREI_APP_PCR_RAPPORTI PCR
       WHERE PCR.COD_ABI = S.COD_ABI
         AND PCR.COD_NDG = S.COD_NDG
         AND PCR.COD_RAPPORTO = S.COD_RAPPORTO);
        COMMIT;
    EXCEPTION WHEN OTHERS THEN
        ROLLBACK;
    END;
  END prc_cancella_rapporti_arrivati;
END pkg_mcrei_gest_batch;
/


CREATE SYNONYM MCRE_APP.PKG_MCREI_GEST_BATCH FOR MCRE_OWN.PKG_MCREI_GEST_BATCH;


CREATE SYNONYM MCRE_USR.PKG_MCREI_GEST_BATCH FOR MCRE_OWN.PKG_MCREI_GEST_BATCH;


GRANT EXECUTE, DEBUG ON MCRE_OWN.PKG_MCREI_GEST_BATCH TO MCRE_USR;

