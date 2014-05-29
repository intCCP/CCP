CREATE OR REPLACE PACKAGE BODY MCRE_OWN.PKG_MCRE0_ESTENDI_fileguida2 AS
/******************************************************************************
NAME: PKG_MCRE0_ALIMENTAZIONE
PURPOSE:
REVISIONS:
Ver Date Author Description
--------- ---------- ----------------- ------------------------------------
1.0 06/10/2010 Marco Murro Created this package.
1.1 24/11/2010 Marco Murro filtri per IDDPER attivo
1.2 02/12/2010 Marco Murro aggiornata update_file_guida x filtrare il primo caricamento
1.3 13/12/2010 Marco Murro Aggiunto gestione Ramo (al posto di comparto)
1.4 09/02/2011 Marco Murro fix gestione gl-ge-flg
1.5 14/02/2011 Marco Murro estesa fix a superGruppo
1.6 15/02/2011 Marco Murro aggiorna nuovi collegati --> check su dta_upd
1.7 22/02/2011 M.Murro Gianna aggiunta pulizia posizioni uscite
1.8 01/03/2011 Marco Murro fix rimuovi prenotazione - annulla anche sezione
1.9 07/03/2011 Marco Murro check riportafogliazione solo in uscita da tavoli
2.0 24/03/2011 Marco Murro fix check riportafogliazione e storico riport.
2.1 12/04/2011 Marco Murro variato nuovi collegati
2.2 09/05/2011 Marco Murro semplificata Riportafogliazione + inizializzazione servizio
2.3 24/05/2011 Marco Murro aggiunta pulizia comparto per stati non gestiti + GB (fix 06.06)
2.4 14/06/2011 Marco Murro migliorie per performance
2.5 04/07/2011 Marco Murro Assegnazione comparto x Avocazioni
3.0 18/07/2011 Marco Murro Nuove strutture per tuning
3.11 22/09/2011 Marco Murro fix gestione flag, cambio nuovi ingressi
3.12 19/10/2011 Paola Goitre modificate set_cod_ge_gl,calc_cod_collegamento,calc_comparto,aggiorna_nuovi_collegati
3.13 19/10/2011 Marco Murro ripristinata calc_comparto
3.2 28/11/2011 Marco Murre Fix uscite automatiche: check sui soli outsourcing
3.3 16/11/2011 Marco Murre Fix assegnaCompartiGB - distinct!
3.4 07/12/2011 Paola Goitre indipendenza mople,rimosso cursore, 
******************************************************************************/
FUNCTION update_file_guida(p_storico number default 0) return number IS
activ_id number;
BEGIN
EXECUTE IMMEDIATE 'ALTER SESSION ENABLE PARALLEL DML';
execute immediate 'alter table t_mcre0_app_fileguida2 nologging'; 
execute immediate 'alter table t_mcre0_app_fileguida2 noparallel';
log_caricamenti (c_package || '.update_file_guida - start', -2, 'storico:'||p_storico); 
UPDATE /*+parallel(a,4,1) all_rows*/ t_mcre0_app_fileguida2 a
SET today_flg =
CASE
WHEN (cod_abi_cartolarizzato, cod_ndg) IN
(SELECT cod_abi_cartolarizzato, cod_ndg
FROM t_mcre0_app_mople PARTITION (CCP_P1)
)
THEN
'1'
ELSE
'0'
END,
flg_source =
CASE
WHEN (cod_abi_cartolarizzato, cod_ndg) in
(select cod_abi_cartolarizzato, cod_ndg
from mcre_own.t_mcre0_app_gb_gestione gb
where gb.flg_stato = 1)
THEN
CASE
WHEN (cod_abi_cartolarizzato, cod_ndg) in
(select cod_abi_cartolarizzato, cod_ndg
from t_mcre0_app_mople partition (ccp_p1) 
)
THEN
'1'
ELSE
'2'
END
ELSE
'0'
END,
cod_matr_assegnatore = null,
cod_comparto_preassegnato = null,
id_utente_preassegnato = null,
cod_processo_preassegnato = null,
cod_sezione_preassegnata = null,
flg_active =
CASE
WHEN id_dper = (select idper
from mcre_own.v_mcre0_ultima_acquisizione
where cod_file = 'FILE_GUIDA')
THEN
'1'
ELSE
'0'
END;
commit; 
log_caricamenti (c_package || '.update_file_guida - ..', -2, 'gestione flags..');
-- -- v3.11 - non serve più! 
-- --rimuovi_prenotazioni(activ_id);
set_cod_ge_gl(activ_id);
calc_cod_collegamento(activ_id);
-- --dipende da mople
calc_comparto(activ_id);
-- --dipende calc_comparto
check_riportafogliazione(activ_id);
-- --dipende da mople
disassegna_stati_non_gestiti(activ_id);--v2.3
aggiorna_nuovi_collegati(sysdate, activ_id);
storicizza_riportafogliati(activ_id); --spostato v3.0
execute immediate 'alter table t_mcre0_app_fileguida2 logging';
execute immediate 'alter table t_mcre0_app_fileguida2 parallel (degree 2 instances 1)';
log_caricamenti (c_package || '.update_file_guida - end', -2, 'storico:'||p_storico);
return 1;
END;
--annulla i campi 'prenotati' eventualmente rimasti senza conferma
-- non più usato
PROCEDURE rimuovi_prenotazioni(activ_id number) IS
BEGIN
-- update MCRE_OWN.t_mcre0_app_fileguida2
-- set COD_MATR_ASSEGNATORE = null,
-- COD_COMPARTO_PREASSEGNATO = null,
-- ID_UTENTE_PREASSEGNATO = null,
-- COD_PROCESSO_PREASSEGNATO = null,
-- COD_SEZIONE_PREASSEGNATA = null --v1.8
-- where id_dper = (SELECT a.idper FROM v_mcre0_ultima_acquisizione a WHERE a.cod_file = 'FILE_GUIDA');--v3.0
commit;
EXCEPTION WHEN OTHERS THEN
log_caricamenti(c_package||'.rimuovi_prenotazioni_non_confermate',SQLCODE, SQLERRM||' - rollback');
rollback;
END;
PROCEDURE set_cod_ge_gl(activ_id number) IS
BEGIN
EXECUTE IMMEDIATE 'ALTER SESSION ENABLE PARALLEL DML'; 
begin
UPDATE mcre_own.t_mcre0_app_fileguida2 m
SET m.cod_gruppo_economico = (SELECT ge.cod_gruppo_economico FROM mcre_own.t_mcre0_app_gruppo_economico ge WHERE m.cod_sndg = ge.cod_sndg(+) ),
m.flg_gruppo_economico = nvl( (SELECT DECODE (ge.cod_gruppo_economico, NULL, '0', '1') FROM mcre_own.t_mcre0_app_gruppo_economico ge WHERE m.cod_sndg = ge.cod_sndg(+) ),'0'),
m.cod_gruppo_legame = (select cod_gruppo_legame FROM mcre_own.t_mcre0_app_gruppo_legame gl WHERE m.cod_sndg = gl.cod_sndg(+)),
m.flg_gruppo_legame = nvl( (select DECODE (cod_gruppo_legame, NULL, '0', '1') FROM mcre_own.t_mcre0_app_gruppo_legame gl WHERE m.cod_sndg = gl.cod_sndg(+)),'0'),
flg_condiviso = '1',
flg_singolo = '0'
WHERE m.id_dper = (SELECT a.idper FROM v_mcre0_ultima_acquisizione a WHERE a.cod_file = 'FILE_GUIDA'); 
COMMIT;
EXCEPTION
WHEN OTHERS THEN
log_caricamenti (c_package || '.SET_COD_GE_GL - upd codici', SQLCODE, SQLERRM );
END;
BEGIN
--valorizzo il flag singolo
UPDATE mcre_own.t_mcre0_app_fileguida2 c
SET c.flg_singolo = 1,
c.flg_condiviso = 0
WHERE cod_sndg IN (SELECT mm.cod_sndg
FROM mcre_own.t_mcre0_app_fileguida2 mm
WHERE mm.id_dper = (SELECT a.idper FROM v_mcre0_ultima_acquisizione a WHERE a.cod_file = 'FILE_GUIDA')
GROUP BY (mm.cod_sndg)
HAVING COUNT (DISTINCT mm.cod_ndg) = 1)
AND c.id_dper = (SELECT a.idper FROM v_mcre0_ultima_acquisizione a WHERE a.cod_file = 'FILE_GUIDA');
EXCEPTION
WHEN OTHERS THEN
log_caricamenti (c_package || '.SET_COD_GE_GL - fl_singolo',SQLCODE,SQLERRM);
END;
begin
--determino i cartolarizzati che non andrebbero sommati nelle statistiche di gruppo
UPDATE mcre_own.t_mcre0_app_fileguida2 f
SET f.flg_somma = '0'
WHERE f.cod_abi_istituto != f.cod_abi_cartolarizzato
AND f.cod_ndg IN (SELECT g.cod_ndg
FROM mcre_own.t_mcre0_app_fileguida2 g
WHERE g.id_dper = (SELECT a.idper FROM v_mcre0_ultima_acquisizione a WHERE a.cod_file = 'FILE_GUIDA')
HAVING COUNT (*) > 1
GROUP BY g.cod_abi_istituto, g.cod_ndg)
and f.id_dper = (SELECT a.idper FROM v_mcre0_ultima_acquisizione a WHERE a.cod_file = 'FILE_GUIDA');
COMMIT;
EXCEPTION
WHEN OTHERS THEN
log_caricamenti (c_package || '.SET_COD_GE_GL fl_somma', SQLCODE, SQLERRM );
END; 
END;
PROCEDURE calc_cod_collegamento(activ_id number) IS
BEGIN
-- log_caricamenti (c_package || '.CALC_COD_COLLEGAMENTO - step 1', -1,'');
-- step 1: assegno un cod supergrupppo pari al gruppo Eco (se c'è), Gruppo Legame o super (con relativo prefisso)
-- PG 20111123 accorpato nella SET_COD_GE_GL
--step 2: assegno a tutti i super di un legame solo parzialmente in un gruppo il cod GE
EXECUTE IMMEDIATE 'ALTER SESSION ENABLE PARALLEL DML'; 
UPDATE mcre_own.t_mcre0_app_fileguida2 c
SET c.cod_gruppo_super =
(SELECT 'GE'|| LPAD (MAX (cod_gruppo_economico), 18, '0') ge
FROM mcre_own.t_mcre0_app_fileguida2 h
WHERE h.cod_gruppo_legame IN (
SELECT cod_gruppo_legame
FROM mcre_own. t_mcre0_app_fileguida2 mm
WHERE cod_gruppo_legame IS NOT NULL
GROUP BY cod_gruppo_legame
HAVING COUNT(DISTINCT NVL(cod_gruppo_economico,-1)) > 1
AND MIN (NVL(cod_gruppo_economico,-1)) = -1)
AND h.cod_gruppo_legame = c.cod_gruppo_legame
AND h.id_dper = c.id_dper
GROUP BY cod_gruppo_legame)
WHERE c.cod_gruppo_legame IS NOT NULL
AND c.cod_gruppo_economico IS NULL
AND c.id_dper = (select a.idper
from v_mcre0_ultima_acquisizione a
where a.cod_file = 'FILE_GUIDA')
AND c.cod_gruppo_legame IN (
SELECT cod_gruppo_legame
FROM mcre_own.t_mcre0_app_fileguida2 mm
WHERE cod_gruppo_legame IS NOT NULL
AND id_dper = (select a.idper
from v_mcre0_ultima_acquisizione a
where a.cod_file = 'FILE_GUIDA')
GROUP BY cod_gruppo_legame
HAVING COUNT (DISTINCT NVL(cod_gruppo_economico,-1)) > 1
AND MIN (NVL(cod_gruppo_economico,-1)) = -1);
commit; 
log_caricamenti (c_package || '.CALC_COD_COLLEGAMENTO - end', -1, '');
commit;
EXCEPTION
WHEN OTHERS THEN
log_caricamenti (c_package || '.CALC_COD_COLLEGAMENTO', SQLCODE, SQLERRM );
END;
--v1.3 aggiorno Ramo e Comparto Calcolato e setto comparto a Tavoli
PROCEDURE calc_comparto(activ_id number) IS
cib mcre_own.t_mcre0_app_mople.cod_comparto_host%TYPE := '000001';
bdt mcre_own.t_mcre0_app_mople.cod_comparto_host%TYPE := '000002';
tavoli mcre_own.t_mcre0_app_mople.cod_comparto_host%TYPE := '011901';
BEGIN
--partiziono per supergruppo, cerco il min comparto: se CIB o BdT li assegno a tutto il gruppo
--altrimenti lascio il valore host della singola riga.
--aggiorno comparto pre e data comparto calcolato
BEGIN
EXECUTE IMMEDIATE 'ALTER SESSION disable PARALLEL DML'; 
-- dipendenza da mople
MERGE 
INTO mcre_own.t_mcre0_app_fileguida2 fg
USING ( 
SELECT /*+parallel(f,2,1) parallel_index(f IDX_MCRE0_APP_fileguida2_IDPER)*/
f.cod_abi_cartolarizzato, f.cod_ndg, m.cod_comparto_host,
CASE
WHEN MIN (m.cod_ramo_host) OVER (PARTITION BY cod_gruppo_super) IN (cib, bdt)
THEN MIN (m.cod_ramo_host) OVER (PARTITION BY cod_gruppo_super)
ELSE m.cod_ramo_host
END rhost
FROM mcre_own.t_mcre0_app_fileguida2 f,
mcre_own.t_mcre0_app_mople m
WHERE f.cod_abi_cartolarizzato = m.cod_abi_cartolarizzato(+)
AND f.cod_ndg = m.cod_ndg(+)
AND f.id_dper = (SELECT a.idper FROM v_mcre0_ultima_acquisizione a WHERE a.cod_file ='FILE_GUIDA') 
) calc
ON ( fg.cod_abi_cartolarizzato = calc.cod_abi_cartolarizzato
AND fg.cod_ndg = calc.cod_ndg
AND fg.id_dper = (SELECT a.idper FROM v_mcre0_ultima_acquisizione a WHERE a.cod_file ='FILE_GUIDA') 
) 
WHEN MATCHED THEN
UPDATE
SET fg.cod_comparto_calcolato_pre = fg.cod_comparto_calcolato,
fg.cod_comparto_calcolato = nvl2(calc.rhost,tavoli,calc.cod_comparto_host),
fg.cod_ramo_calcolato = calc.rhost,
fg.dta_comparto_calcolato = SYSDATE; 
commit;
--debug..
log_caricamenti (c_package || '.calc_comparto - end', -1, '');
EXCEPTION
WHEN OTHERS THEN
log_caricamenti (c_package || '.CALC_COMPARTO', SQLCODE, SQLERRM);
rollback;
END;
EXCEPTION
WHEN OTHERS THEN
log_caricamenti (c_package || '.CALC_COMPARTO', SQLCODE, SQLERRM);
END;
--v2.2 se non più sui tavoli aggiorno SEMPRE!
PROCEDURE check_riportafogliazione(activ_id number) IS
--aggiorna flag e data riportafogliazione ed eventualmente id gestore e data assegnazione in caso di
--riportafogliazione (verifica di comparto calcolato-calcolato_pre e calcolato-assegnato
v_num number;
BEGIN
EXECUTE IMMEDIATE 'ALTER SESSION ENABLE PARALLEL DML'; 
UPDATE MCRE_OWN.t_mcre0_app_fileguida2 F
set f.flg_riportafogliato = 1,
f.dta_last_riportaf = sysdate,
f.id_utente_pre = f.id_utente,
f.id_utente = null,
f.dta_utente_assegnato = null,
f.cod_comparto_assegnato = null, --lasio null?!
f.cod_servizio = null, --lasio null?!
f.dta_servizio = null
where
nvl(f.cod_comparto_calcolato,-1) != c_tavoli
and f.cod_comparto_calcolato_pre = c_tavoli
AND f.id_dper = (SELECT a.idper FROM v_mcre0_ultima_acquisizione a WHERE a.cod_file ='FILE_GUIDA');
v_num := sql%rowcount;
commit;
log_caricamenti (c_package || '.check_riportafogliazione', -1, 'posizioni riportafogliate: '||v_num);
END;
PROCEDURE storicizza_riportafogliati(activ_id number) is
begin
EXECUTE IMMEDIATE 'ALTER SESSION ENABLE PARALLEL DML';
execute immediate 'alter table T_MCRE0_TMP_LISTA_STORICO nologging';
insert /*+append parallel(s,2,1)*/ into MCRE_OWN.T_MCRE0_TMP_LISTA_STORICO s
(COD_ABI_CARTOLARIZZATO, COD_NDG, COD_SNDG, FLG_STATO, FLG_COMPARTO, FLG_GESTORE, FLG_MESE)
select /*+parallel(fg,2,1) parallel_index(fg IDX_MCRE0_APP_fileguida2_IDPER)*/
cod_abi_cartolarizzato, cod_ndg, cod_sndg, 0 fl_stato,1 fl_comparto,
case
when id_utente IS NULL and id_utente_pre IS NOT NULL then 1
else 0
end fl_gestore,0 fl_mese
from MCRE_OWN.t_mcre0_app_fileguida2 fg
where FLG_RIPORTAFOGLIATO = '1' 
and id_dper = (SELECT a.idper FROM v_mcre0_ultima_acquisizione a WHERE a.cod_file ='FILE_GUIDA');
commit;
execute immediate 'alter table T_MCRE0_TMP_LISTA_STORICO logging';
end;
--v2.1: upd solo su chi ha due diversi comparti assegnati su gruppo super OGGI
--v2.2: aggiunto update Servizio per nuovi ingressi
--TODO: rivedere la select
PROCEDURE aggiorna_nuovi_collegati( p_data DATE, activ_id number) is
row_upd number := 0;
n number := 0;
giorno date := sysdate;
-- --v2.1 aggiunto controllo su idper
begin
EXECUTE IMMEDIATE 'ALTER SESSION ENABLE PARALLEL DML';
execute immediate 'alter table t_mcre0_app_fileguida2 nologging';
execute immediate 'alter table t_mcre0_app_fileguida2 noparallel';
if p_data is null then
giorno := sysdate;
else
giorno := p_data;
end if;
MERGE /*+parallel(fg,2,1) */ INTO mcre_own.t_mcre0_app_fileguida2 fg
USING (select * from 
(select distinct cod_gruppo_super, id_utente, id_utente_pre, max_dta_utente, dta_utente_assegnato, cod_comparto_assegnato, 
count(distinct cod_gruppo_super||id_utente||id_utente_pre|| max_dta_utente||dta_utente_assegnato||cod_comparto_assegnato) over (partition by cod_gruppo_super) pos
from ( 
select /*+parallel(t,2,1) parallel_index(t IDX_MCRE0_APP_fileguida2_IDPER)*/ 
cod_gruppo_super, id_utente, nullif(id_utente_pre, id_utente) id_utente_pre,
max(dta_utente_assegnato) over (partition by cod_gruppo_super) max_dta_utente, 
dta_utente_assegnato, cod_comparto_assegnato, 
count(distinct nvl(cod_comparto_assegnato,'-')) over (partition by cod_gruppo_super) num_comp 
from mcre_own.t_mcre0_app_fileguida2 t
where t.cod_gruppo_super is not null
and t.id_dper = (select a.idper from v_mcre0_ultima_acquisizione a where a.cod_file ='FILE_GUIDA')
)
where (max_dta_utente = dta_utente_assegnato or (max_dta_utente is null and dta_utente_assegnato is null))
and num_comp >1
) a
where pos =1 ) calc
ON ( fg.cod_gruppo_super = calc.cod_gruppo_super 
and fg.dta_upd >= trunc(giorno)) 
when matched then
update
set fg.id_utente = calc.id_utente,
fg.id_utente_pre = calc.id_utente_pre,
fg.dta_utente_assegnato = calc.dta_utente_assegnato,
fg.cod_comparto_assegnato = calc.cod_comparto_assegnato; 
n := sql%rowcount;
row_upd := row_upd+n;
commit;
--v2.2 ricalcolo il servizio per i nuovi ingressi/reingressi
UPDATE /*+parallel(f,2,1) */t_mcre0_app_fileguida2 F
SET cod_servizio = (select cod_servizio from t_mcre0_app_comparti
where cod_comparto = nvl(f.cod_comparto_assegnato, f.cod_comparto_calcolato)),
dta_servizio = dta_ins
where f.cod_comparto_calcolato = c_tavoli--'011901'
and f.dta_servizio is null
and dta_upd >= trunc(sysdate);
n := sql%rowcount;
commit;
execute immediate 'alter table t_mcre0_app_fileguida2 logging';
execute immediate 'alter table t_mcre0_app_fileguida2 parallel (degree 2 instances 1)';
log_caricamenti (c_package || '.aggiorna_nuovi_collegati',-1,'aggiornati '||row_upd||' records, '||n||' x inizializzazione servizio' );
exception when others then
log_caricamenti (c_package || '.aggiorna_nuovi_collegati',SQLCODE,SQLERRM );
end;
--v2.3: ripulisce comparto e gestore se le uniche posizioni in mople non sono in stati gestiti
PROCEDURE disassegna_stati_non_gestiti(activ_id number) is
row_upd number := 0;
begin
update /*+parallel(f,2,1)*/t_mcre0_app_fileguida2 f
set id_utente_pre = nvl (id_utente, id_utente_pre),
id_utente = null,
cod_comparto_assegnato = null,
dta_utente_assegnato = null
where cod_gruppo_super in
(--v3.2 mm: aggiunto check su flag outsourcing
select f.cod_gruppo_super
from t_mcre0_app_mople m,
t_mcre0_app_fileguida2 f,
t_mcre0_app_stati s, 
t_mcre0_app_istituti i
where m.cod_abi_cartolarizzato = f.cod_abi_cartolarizzato
and m.cod_ndg = f.cod_ndg
and m.today_flg = '1' 
and m.cod_stato = s.cod_microstato
and f.cod_comparto_assegnato is not null
and f.cod_abi_cartolarizzato = i.cod_abi
and i.flg_outsourcing = 'Y'
group by f.cod_gruppo_super
having max(s.flg_stato_chk) is null
);
row_upd := sql%rowcount;
commit;
log_caricamenti (c_package || '.disassegna_stati_non_gestiti',-1,'aggiornati '||row_upd||' records' );
exception when others then
log_caricamenti (c_package || '.disassegna_stati_non_gestiti',SQLCODE,SQLERRM );
end;
--v2.5: Forza il comparto Assegnato ai collegati a Bonis non gestiti..
Function assegna_comparto_GB_AV(seq number) return number is
row_upd number := 0;
row_ins number := 0;
begin
EXECUTE IMMEDIATE 'ALTER SESSION ENABLE PARALLEL DML'; 
merge /*+parallel(fg,2,1)*/into t_mcre0_app_fileguida2 fg
using (
select distinct cod_gruppo_super, cod_comparto_proposto from (
select f.cod_gruppo_super, g.cod_comparto_proposto, dta_stato ,
min(dta_stato) over(partition by cod_gruppo_super) min_dtata_stato
from t_mcre0_app_fileguida2 f,
(select cod_abi_cartolarizzato,cod_ndg, cod_comparto_proposto, dta_stato from t_mcre0_app_gb_gestione
where flg_stato = 1
union
select cod_abi_cartolarizzato,cod_ndg, cod_comparto_av, dta_stato from t_mcre0_app_av_gestione
where flg_stato = 1) g
where f.cod_abi_cartolarizzato = g.cod_abi_cartolarizzato
and f.cod_ndg = g.cod_ndg
and f.cod_comparto_assegnato is null)
where dta_stato = min_dtata_stato
and cod_comparto_proposto is not null) a
on (fg.cod_gruppo_super = a.cod_gruppo_super)
when matched then
update
set cod_comparto_assegnato = a.cod_comparto_proposto;
row_upd := sql%rowcount;
commit;
--storicizzo l'avvenuto cambio comparto automatico
insert /*+append*/ into mcre_own.t_mcre0_tmp_lista_storico
(cod_abi_cartolarizzato, cod_ndg, cod_sndg, flg_stato, flg_comparto, flg_gestore, flg_mese)
(select f.cod_abi_cartolarizzato, f.cod_ndg, f.cod_sndg, 0 fl_stato,1 fl_comparto,0 flg_gestore,0 fl_mese
from t_mcre0_app_fileguida2 f,
(select cod_abi_cartolarizzato,cod_ndg, cod_comparto_proposto, dta_stato from t_mcre0_app_gb_gestione
where flg_stato = '1'
union
select cod_abi_cartolarizzato,cod_ndg, cod_comparto_av, dta_stato from t_mcre0_app_av_gestione
where flg_stato = '1') g
where f.cod_abi_cartolarizzato = g.cod_abi_cartolarizzato
and f.cod_ndg = g.cod_ndg
and f.cod_comparto_assegnato is null
and g.cod_comparto_proposto is not null);
row_ins := sql%rowcount;
commit;
PKG_MCRE0_AUDIT.log_etl (seq,c_package || '.assegna_comparto_GB_AV', 3, sqlcode, 'aggiornati '||row_upd||' records ('||row_ins||' in TMP_STORICO)', '');
--log_caricamenti (c_package || '.assegna_comparto_GB',-1,'aggiornati '||row_upd||' records' );
return 1;
exception when others then
PKG_MCRE0_AUDIT.log_etl (seq,c_package || '.assegna_comparto_GB_AV', 1, SQLCODE,SQLERRM, 'rollback');
--log_caricamenti (c_package || '.assegna_comparto_GB',SQLCODE,SQLERRM );
rollback;
return 0;
end;
--ripulisce gestore e COMPARTO da ogni gruppo senza più posizioni in mople
--v2.1 sbianco per singola riga e non più solo per intero gruppo super
FUNCTION update_uscita_CCP RETURN NUMBER IS
v_id_dper number;
c_nome CONSTANT VARCHAR2(50) := c_package || '.update_uscita_CCP';
RetVal number := -1;
num number := 0;
BEGIN
--ripulisco le posizioni non più aggiornate
update /*+parallel(g,4,1)*/t_mcre0_app_fileguida2 g
set
id_utente_pre = nvl(id_utente,id_utente_pre),
id_utente = null,
cod_comparto_assegnato = null,
dta_utente_assegnato = null --v2.1
where flg_active = '0' 
AND not (id_utente IS NULL and cod_comparto_assegnato is null); --aggiorno solo se assegnati!
num := sql%rowcount;
commit;
log_caricamenti(c_nome,RetVal,'aggiornate '||num||' righe con id_dper non aggiornato');
RetVal:= 1;
--ripulisco gli usciti di oggi, se erano le uniche posizioni in
--log_caricamenti(c_nome,RetVal,'aggiornate '||num||' righe');
RETURN RetVal;
EXCEPTION WHEN OTHERS THEN
log_caricamenti(c_nome,sqlcode,SQLERRM);
RETURN -1;
END update_uscita_CCP;
END PKG_MCRE0_ESTENDI_fileguida2;
/


CREATE SYNONYM MCRE_APP.PKG_MCRE0_ESTENDI_FILEGUIDA2 FOR MCRE_OWN.PKG_MCRE0_ESTENDI_FILEGUIDA2;


CREATE SYNONYM MCRE_USR.PKG_MCRE0_ESTENDI_FILEGUIDA2 FOR MCRE_OWN.PKG_MCRE0_ESTENDI_FILEGUIDA2;


GRANT EXECUTE, DEBUG ON MCRE_OWN.PKG_MCRE0_ESTENDI_FILEGUIDA2 TO MCRE_USR;

