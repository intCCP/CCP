CREATE OR REPLACE PACKAGE BODY MCRE_OWN."PKG_MCRE0_PCR"
AS 
FUNCTION fnc_calcolo_mau (
p_cod_log t_mcre0_wrk_audit_etl.ID%TYPE DEFAULT NULL,
p_id_dper t_mcre0_app_pcr_sc_sb.id_dper%TYPE DEFAULT NULL
)
RETURN NUMBER
IS
v_cod_log t_mcre0_wrk_audit_etl.ID%TYPE;
CURSOR gec
IS
SELECT g.cod_gruppo_economico, COUNT (DISTINCT gb_val_mau)
FROM t_mcre0_app_pcr p, t_mcre0_app_file_guida g
WHERE p.cod_abi_cartolarizzato = g.cod_abi_cartolarizzato
AND p.cod_ndg = g.cod_ndg
AND g.cod_gruppo_economico IS NOT NULL
GROUP BY g.cod_gruppo_economico
HAVING COUNT (DISTINCT gb_val_mau) > 1;
BEGIN
IF (p_cod_log IS NULL)
THEN
SELECT seq_mcr0_log_etl.NEXTVAL
INTO v_cod_log
FROM DUAL;
ELSE
v_cod_log := p_cod_log;
END IF;
BEGIN
MERGE INTO t_mcre0_app_pcr a
USING (SELECT DISTINCT f.cod_abi_cartolarizzato, f.cod_ndg,
f.flg_gruppo_economico,
f.flg_gruppo_legame
FROM t_mcre0_app_file_guida f,
t_mcre0_app_pcr p
WHERE f.cod_abi_cartolarizzato =
p.cod_abi_cartolarizzato
AND f.cod_ndg = p.cod_ndg
AND p.gb_val_mau IS NULL) b
ON ( a.cod_abi_cartolarizzato = b.cod_abi_cartolarizzato
AND a.cod_ndg = b.cod_ndg)
WHEN MATCHED THEN
UPDATE
SET a.gb_val_mau =
DECODE (b.flg_gruppo_economico,
1, gegb_mau,
DECODE (flg_gruppo_legame,
1, glgb_mau,
scgb_mau
)
)
;
COMMIT;
EXCEPTION
WHEN OTHERS
THEN
log_caricamenti ('fnc_calcolo_mau',
SQLCODE,
'UPDATE MAU PCR - t_mcre0_app_pcr - SQLERRM='
|| SQLERRM
);
ROLLBACK;
RETURN ko;
END;
BEGIN
FOR ge IN gec
LOOP
BEGIN
MERGE INTO t_mcre0_app_pcr a
USING (SELECT p.cod_sndg, p.gegb_acc_cassa,
p.gegb_acc_firma, p.gegb_uti_cassa,
p.gegb_uti_firma, p.gegb_mau, p.gb_val_mau
FROM t_mcre0_app_file_guida f, t_mcre0_app_pcr p
WHERE f.cod_abi_cartolarizzato =
p.cod_abi_cartolarizzato
AND f.cod_ndg = p.cod_ndg
AND f.cod_gruppo_economico =
ge.cod_gruppo_economico
AND p.id_dper_gb =
NVL (p_id_dper,
(SELECT idper
FROM v_mcre0_ultima_acquisizione
WHERE cod_file = 'PCR_GB')
)
AND ROWNUM = 1) c
ON (a.cod_sndg = c.cod_sndg)
WHEN MATCHED THEN
UPDATE
SET a.gegb_acc_cassa = c.gegb_acc_cassa,
a.gegb_acc_firma = c.gegb_acc_firma,
a.gegb_uti_cassa = c.gegb_uti_cassa,
a.gegb_uti_firma = c.gegb_uti_firma,
a.gegb_mau = c.gegb_mau,
a.gb_val_mau = c.gb_val_mau
;
EXCEPTION
WHEN OTHERS
THEN
log_caricamenti
('fnc_calcolo_mau',
SQLCODE,
'GEGB uniforme - t_mcre0_app_pcr - ge: '
|| ge.cod_gruppo_economico
|| ' - SQLERRM='
|| SQLERRM
);
END;
END LOOP;
COMMIT;
END;
RETURN ok;
EXCEPTION
WHEN OTHERS
THEN
log_caricamenti ('fnc_calcolo_mau',
SQLCODE,
'generale - t_mcre0_app_pcr - SQLERRM=' || SQLERRM
);
ROLLBACK;
RETURN ko;
END; 
FUNCTION fnc_clean_no_pcr (
p_cod_log t_mcre0_wrk_audit_etl.ID%TYPE DEFAULT NULL,
p_id_dper t_mcre0_app_pcr_sc_sb.id_dper%TYPE DEFAULT NULL
)
RETURN NUMBER
IS
v_cod_log t_mcre0_wrk_audit_etl.ID%TYPE;
BEGIN
IF (p_cod_log IS NULL)
THEN
SELECT seq_mcr0_log_etl.NEXTVAL
INTO v_cod_log
FROM DUAL;
ELSE
v_cod_log := p_cod_log;
END IF;
BEGIN
UPDATE t_mcre0_app_pcr p
SET scsb_acc_consegne = NULL,
scsb_acc_consegne_dt = NULL,
scsb_uti_consegne = NULL,
scsb_uti_consegne_dt = NULL,
scsb_acc_cassa = NULL,
scsb_acc_cassa_bt = NULL,
scsb_acc_cassa_mlt = NULL,
scsb_acc_firma = NULL,
scsb_acc_firma_dt = NULL,
scsb_acc_massimali = NULL,
scsb_acc_massimali_dt = NULL,
scsb_acc_rischi_indiretti = NULL,
scsb_acc_rischi_indiretti_dt = NULL,
scsb_acc_smobilizzo = NULL,
scsb_acc_sostituzioni = NULL,
scsb_acc_sostituzioni_dt = NULL,
scsb_acc_tot = NULL,
scsb_dta_riferimento = NULL,
scsb_tot_gar = NULL,
scsb_uti_cassa = NULL,
scsb_uti_cassa_bt = NULL,
scsb_uti_cassa_mlt = NULL,
scsb_uti_firma = NULL,
scsb_uti_firma_dt = NULL,
scsb_uti_massimali = NULL,
scsb_uti_massimali_dt = NULL,
scsb_uti_rischi_indiretti = NULL,
scsb_uti_rischi_indiretti_dt = NULL,
scsb_uti_smobilizzo = NULL,
scsb_uti_sostituzioni = NULL,
scsb_uti_sostituzioni_dt = NULL,
scsb_uti_tot = NULL
WHERE id_dper_scsb <
NVL (p_id_dper,
(SELECT idper
FROM v_mcre0_ultima_acquisizione
WHERE cod_file = 'FILE_GUIDA'))
AND id_dper_scsb IN (
SELECT id_dper
FROM (SELECT DISTINCT id_dper
FROM t_mcre0_app_pcr_sc_sb
WHERE id_dper <=
NVL (p_id_dper, '99999999')
--id_dper)
ORDER BY id_dper DESC)
WHERE ROWNUM < 3)
AND EXISTS (
SELECT /*+parallel(f,2,1) parallel_index(f IDX_MCRE0_APP_FILE_GUIDA_IDPER)*/
1
FROM t_mcre0_app_file_guida f
WHERE f.cod_abi_cartolarizzato = p.cod_abi_cartolarizzato
AND f.cod_ndg = p.cod_ndg
AND f.id_dper = (SELECT idper
FROM v_mcre0_ultima_acquisizione
WHERE cod_file = 'FILE_GUIDA')); 
COMMIT;
EXCEPTION
WHEN OTHERS
THEN
log_caricamenti ('fnc_clean_no_pcr',
SQLCODE,
'UPDATE NO PCR - t_mcre0_app_pcr - SQLERRM='
|| SQLERRM
);
ROLLBACK;
RETURN ko;
END;
BEGIN
UPDATE t_mcre0_app_pcr p
SET scgb_acc_consegne = NULL,
scgb_acc_consegne_dt = NULL,
scgb_uti_consegne = NULL,
scgb_uti_consegne_dt = NULL,
scgb_acc_cassa = NULL,
scgb_acc_cassa_bt = NULL,
scgb_acc_cassa_mlt = NULL,
scgb_acc_firma = NULL,
scgb_acc_firma_dt = NULL,
scgb_acc_massimali = NULL,
scgb_acc_massimali_dt = NULL,
scgb_acc_rischi_indiretti = NULL,
scgb_acc_rischi_indiretti_dt = NULL,
scgb_acc_smobilizzo = NULL,
scgb_acc_sostituzioni = NULL,
scgb_acc_sostituzioni_dt = NULL,
scgb_acc_tot = NULL,
scgb_tot_gar = NULL,
scgb_uti_cassa = NULL,
scgb_uti_cassa_bt = NULL,
scgb_uti_cassa_mlt = NULL,
scgb_uti_firma = NULL,
scgb_uti_firma_dt = NULL,
scgb_uti_massimali = NULL,
scgb_uti_massimali_dt = NULL,
scgb_uti_rischi_indiretti = NULL,
scgb_uti_rischi_indiretti_dt = NULL,
scgb_uti_smobilizzo = NULL,
scgb_uti_sostituzioni = NULL,
scgb_uti_sostituzioni_dt = NULL,
scgb_uti_tot = NULL,
gegb_acc_consegne = NULL,
gegb_acc_consegne_dt = NULL,
gegb_uti_consegne = NULL,
gegb_uti_consegne_dt = NULL,
gegb_acc_cassa = NULL,
gegb_acc_cassa_bt = NULL,
gegb_acc_cassa_mlt = NULL,
gegb_acc_firma = NULL,
gegb_acc_firma_dt = NULL,
gegb_acc_massimali = NULL,
gegb_acc_massimali_dt = NULL,
gegb_acc_rischi_indiretti = NULL,
gegb_acc_rischi_indiretti_dt = NULL,
gegb_acc_smobilizzo = NULL,
gegb_acc_sostituzioni = NULL,
gegb_acc_sostituzioni_dt = NULL,
gegb_acc_tot = NULL,
gegb_tot_gar = NULL,
gegb_uti_cassa = NULL,
gegb_uti_cassa_bt = NULL,
gegb_uti_cassa_mlt = NULL,
gegb_uti_firma = NULL,
gegb_uti_firma_dt = NULL,
gegb_uti_massimali = NULL,
gegb_uti_massimali_dt = NULL,
gegb_uti_rischi_indiretti = NULL,
gegb_uti_rischi_indiretti_dt = NULL,
gegb_uti_smobilizzo = NULL,
gegb_uti_sostituzioni = NULL,
gegb_uti_sostituzioni_dt = NULL,
gegb_uti_tot = NULL,
glgb_acc_consegne = NULL,
glgb_acc_consegne_dt = NULL,
glgb_uti_consegne = NULL,
glgb_uti_consegne_dt = NULL,
glgb_acc_cassa = NULL,
glgb_acc_cassa_bt = NULL,
glgb_acc_cassa_mlt = NULL,
glgb_acc_firma = NULL,
glgb_acc_firma_dt = NULL,
glgb_acc_massimali = NULL,
glgb_acc_massimali_dt = NULL,
glgb_acc_rischi_indiretti = NULL,
glgb_acc_rischi_indiretti_dt = NULL,
glgb_acc_smobilizzo = NULL,
glgb_acc_sostituzioni = NULL,
glgb_acc_sostituzioni_dt = NULL,
glgb_acc_tot = NULL,
glgb_tot_gar = NULL,
glgb_uti_cassa = NULL,
glgb_uti_cassa_bt = NULL,
glgb_uti_cassa_mlt = NULL,
glgb_uti_firma = NULL,
glgb_uti_firma_dt = NULL,
glgb_uti_massimali = NULL,
glgb_uti_massimali_dt = NULL,
glgb_uti_rischi_indiretti = NULL,
glgb_uti_rischi_indiretti_dt = NULL,
glgb_uti_smobilizzo = NULL,
glgb_uti_sostituzioni = NULL,
glgb_uti_sostituzioni_dt = NULL,
glgb_uti_tot = NULL,
gb_dta_riferimento = NULL,
gegb_mau = NULL,
glgb_mau = NULL,
scgb_mau = NULL,
gb_val_mau = NULL
WHERE id_dper_gb <
NVL (p_id_dper,
(SELECT idper
FROM v_mcre0_ultima_acquisizione
WHERE cod_file = 'FILE_GUIDA'))
AND id_dper_gb IN (
SELECT id_dper
FROM (SELECT DISTINCT id_dper
FROM t_mcre0_app_pcr_gb
WHERE id_dper <= NVL (p_id_dper, id_dper)
ORDER BY id_dper DESC)
WHERE ROWNUM < 3)
AND EXISTS (
SELECT /*+parallel(f,2,1) parallel_index(f IDX_MCRE0_APP_FILE_GUIDA_IDPER)*/
1
FROM t_mcre0_app_file_guida f
WHERE f.cod_abi_cartolarizzato = p.cod_abi_cartolarizzato
AND f.cod_ndg = p.cod_ndg
AND f.id_dper = (SELECT idper
FROM v_mcre0_ultima_acquisizione
WHERE cod_file = 'FILE_GUIDA'));
-- and SCSB_DTA_RIFERIMENTO is not null;
COMMIT;
EXCEPTION
WHEN OTHERS
THEN
log_caricamenti ('fnc_clean_no_pcr',
SQLCODE,
'UPDATE NO PCR - t_mcre0_app_pcr - SQLERRM='
|| SQLERRM
);
ROLLBACK;
RETURN ko;
END;
BEGIN
 UPDATE t_mcre0_app_pcr p
SET gegb_acc_consegne = NULL,
gegb_acc_consegne_dt = NULL,
gegb_uti_consegne = NULL,
gegb_uti_consegne_dt = NULL,
gesb_acc_consegne = NULL,
gesb_acc_consegne_dt = NULL,
gesb_uti_consegne = NULL,
gesb_uti_consegne_dt = NULL,
gegb_acc_cassa = NULL,
gegb_acc_cassa_bt = NULL,
gegb_acc_cassa_mlt = NULL,
gegb_acc_firma = NULL,
gegb_acc_firma_dt = NULL,
gegb_acc_massimali = NULL,
gegb_acc_massimali_dt = NULL,
gegb_acc_rischi_indiretti = NULL,
gegb_acc_rischi_indiretti_dt = NULL,
gegb_acc_smobilizzo = NULL,
gegb_acc_sostituzioni = NULL,
gegb_acc_sostituzioni_dt = NULL,
gegb_acc_tot = NULL,
gegb_mau = NULL,
gegb_tot_gar = NULL,
gegb_uti_cassa = NULL,
gegb_uti_cassa_bt = NULL,
gegb_uti_cassa_mlt = NULL,
gegb_uti_firma = NULL,
gegb_uti_firma_dt = NULL,
gegb_uti_massimali = NULL,
gegb_uti_massimali_dt = NULL,
gegb_uti_rischi_indiretti = NULL,
gegb_uti_rischi_indiretti_dt = NULL,
gegb_uti_smobilizzo = NULL,
gegb_uti_sostituzioni = NULL,
gegb_uti_sostituzioni_dt = NULL,
gegb_uti_tot = NULL,
gesb_acc_cassa = NULL,
gesb_acc_cassa_bt = NULL,
gesb_acc_cassa_mlt = NULL,
gesb_acc_firma = NULL,
gesb_acc_firma_dt = NULL,
gesb_acc_massimali = NULL,
gesb_acc_massimali_dt = NULL,
gesb_acc_rischi_indiretti = NULL,
gesb_acc_rischi_indiretti_dt = NULL,
gesb_acc_smobilizzo = NULL,
gesb_acc_sostituzioni = NULL,
gesb_acc_sostituzioni_dt = NULL,
gesb_acc_tot = NULL,
gesb_dta_riferimento = NULL,
gesb_tot_gar = NULL,
gesb_uti_cassa = NULL,
gesb_uti_cassa_bt = NULL,
gesb_uti_cassa_mlt = NULL,
gesb_uti_firma = NULL,
gesb_uti_firma_dt = NULL,
gesb_uti_massimali = NULL,
gesb_uti_massimali_dt = NULL,
gesb_uti_rischi_indiretti = NULL,
gesb_uti_rischi_indiretti_dt = NULL,
gesb_uti_smobilizzo = NULL,
gesb_uti_sostituzioni = NULL,
gesb_uti_sostituzioni_dt = NULL,
gesb_uti_tot = NULL,
dta_upd = SYSDATE,
gb_val_mau = NULL
WHERE ( NOT EXISTS (SELECT DISTINCT 1
FROM t_mcre0_app_gruppo_economico e
WHERE e.cod_sndg = p.cod_sndg)
-- OR EXISTS (
-- SELECT DISTINCT 1
-- FROM t_mcre0_app_file_guida f
-- WHERE p.cod_abi_cartolarizzato =
-- f.cod_abi_cartolarizzato
-- AND p.cod_ndg = f.cod_ndg
-- AND f.flg_gruppo_economico = 0)
)
AND id_dper_gb IN (
SELECT id_dper
FROM (SELECT DISTINCT id_dper
FROM t_mcre0_app_pcr_gb
WHERE id_dper <=
NVL (p_id_dper, '99999999')
--id_dper)
ORDER BY id_dper DESC)
WHERE ROWNUM < 3);
COMMIT;

UPDATE t_mcre0_app_pcr p
SET gegb_acc_consegne = NULL,
gegb_acc_consegne_dt = NULL,
gegb_uti_consegne = NULL,
gegb_uti_consegne_dt = NULL,
gesb_acc_consegne = NULL,
gesb_acc_consegne_dt = NULL,
gesb_uti_consegne = NULL,
gesb_uti_consegne_dt = NULL,
gegb_acc_cassa = NULL,
gegb_acc_cassa_bt = NULL,
gegb_acc_cassa_mlt = NULL,
gegb_acc_firma = NULL,
gegb_acc_firma_dt = NULL,
gegb_acc_massimali = NULL,
gegb_acc_massimali_dt = NULL,
gegb_acc_rischi_indiretti = NULL,
gegb_acc_rischi_indiretti_dt = NULL,
gegb_acc_smobilizzo = NULL,
gegb_acc_sostituzioni = NULL,
gegb_acc_sostituzioni_dt = NULL,
gegb_acc_tot = NULL,
gegb_mau = NULL,
gegb_tot_gar = NULL,
gegb_uti_cassa = NULL,
gegb_uti_cassa_bt = NULL,
gegb_uti_cassa_mlt = NULL,
gegb_uti_firma = NULL,
gegb_uti_firma_dt = NULL,
gegb_uti_massimali = NULL,
gegb_uti_massimali_dt = NULL,
gegb_uti_rischi_indiretti = NULL,
gegb_uti_rischi_indiretti_dt = NULL,
gegb_uti_smobilizzo = NULL,
gegb_uti_sostituzioni = NULL,
gegb_uti_sostituzioni_dt = NULL,
gegb_uti_tot = NULL,
gesb_acc_cassa = NULL,
gesb_acc_cassa_bt = NULL,
gesb_acc_cassa_mlt = NULL,
gesb_acc_firma = NULL,
gesb_acc_firma_dt = NULL,
gesb_acc_massimali = NULL,
gesb_acc_massimali_dt = NULL,
gesb_acc_rischi_indiretti = NULL,
gesb_acc_rischi_indiretti_dt = NULL,
gesb_acc_smobilizzo = NULL,
gesb_acc_sostituzioni = NULL,
gesb_acc_sostituzioni_dt = NULL,
gesb_acc_tot = NULL,
gesb_dta_riferimento = NULL,
gesb_tot_gar = NULL,
gesb_uti_cassa = NULL,
gesb_uti_cassa_bt = NULL,
gesb_uti_cassa_mlt = NULL,
gesb_uti_firma = NULL,
gesb_uti_firma_dt = NULL,
gesb_uti_massimali = NULL,
gesb_uti_massimali_dt = NULL,
gesb_uti_rischi_indiretti = NULL,
gesb_uti_rischi_indiretti_dt = NULL,
gesb_uti_smobilizzo = NULL,
gesb_uti_sostituzioni = NULL,
gesb_uti_sostituzioni_dt = NULL,
gesb_uti_tot = NULL,
dta_upd = SYSDATE,
gb_val_mau = NULL
WHERE ( -- NOT EXISTS (SELECT DISTINCT 1
-- FROM t_mcre0_app_gruppo_economico e
-- WHERE e.cod_sndg = p.cod_sndg)
-- OR 
EXISTS (
SELECT /*+parallel(f,2,1) parallel_index(f IDX_MCRE0_APP_FILE_GUIDA_IDPER)*/ 1
FROM t_mcre0_app_file_guida f
WHERE p.cod_abi_cartolarizzato = f.cod_abi_cartolarizzato
AND p.cod_ndg = f.cod_ndg
AND f.flg_gruppo_economico = 0)
)
AND id_dper_gb IN (
SELECT id_dper
FROM (SELECT DISTINCT id_dper
FROM t_mcre0_app_pcr_gb
WHERE id_dper <= NVL (p_id_dper, '99999999')
--id_dper)
ORDER BY id_dper DESC)
WHERE ROWNUM < 3);
COMMIT;
EXCEPTION
WHEN OTHERS
THEN
log_caricamenti
('fnc_clean_no_pcr',
SQLCODE,
'UPDATE USCITI dal gruppo economico - t_mcre0_app_pcr - SQLERRM='
|| SQLERRM
);
ROLLBACK;
RETURN ko;
END;
BEGIN
UPDATE t_mcre0_app_pcr p
SET glgb_acc_consegne = NULL,
glgb_acc_consegne_dt = NULL,
glgb_uti_consegne = NULL,
glgb_uti_consegne_dt = NULL,
glgb_acc_cassa = NULL,
glgb_acc_cassa_bt = NULL,
glgb_acc_cassa_mlt = NULL,
glgb_acc_firma = NULL,
glgb_acc_firma_dt = NULL,
glgb_acc_massimali = NULL,
glgb_acc_massimali_dt = NULL,
glgb_acc_rischi_indiretti = NULL,
glgb_acc_rischi_indiretti_dt = NULL,
glgb_acc_smobilizzo = NULL,
glgb_acc_sostituzioni = NULL,
glgb_acc_sostituzioni_dt = NULL,
glgb_acc_tot = NULL,
glgb_mau = NULL,
glgb_tot_gar = NULL,
glgb_uti_cassa = NULL,
glgb_uti_cassa_bt = NULL,
glgb_uti_cassa_mlt = NULL,
glgb_uti_firma = NULL,
glgb_uti_firma_dt = NULL,
glgb_uti_massimali = NULL,
glgb_uti_massimali_dt = NULL,
glgb_uti_rischi_indiretti = NULL,
glgb_uti_rischi_indiretti_dt = NULL,
glgb_uti_smobilizzo = NULL,
glgb_uti_sostituzioni = NULL,
glgb_uti_sostituzioni_dt = NULL,
glgb_uti_tot = NULL,
dta_upd = SYSDATE,
gb_val_mau = NULL
WHERE ( -- NOT EXISTS (SELECT DISTINCT 1
-- FROM t_mcre0_app_gruppo_legame e
-- WHERE e.cod_sndg = p.cod_sndg)
-- OR 
EXISTS (
SELECT /*+parallel(f,2,1) parallel_index(f IDX_MCRE0_APP_FILE_GUIDA_IDPER)*/ 
1
FROM t_mcre0_app_file_guida f
WHERE p.cod_abi_cartolarizzato =
f.cod_abi_cartolarizzato
AND p.cod_ndg = f.cod_ndg
AND f.flg_gruppo_legame = 0)
)
AND id_dper_gb IN (
SELECT id_dper
FROM (SELECT DISTINCT id_dper
FROM t_mcre0_app_pcr_gb
WHERE id_dper <= NVL (p_id_dper, id_dper)
ORDER BY id_dper DESC)
WHERE ROWNUM < 3);
COMMIT;

UPDATE t_mcre0_app_pcr p
SET glgb_acc_consegne = NULL,
glgb_acc_consegne_dt = NULL,
glgb_uti_consegne = NULL,
glgb_uti_consegne_dt = NULL,
glgb_acc_cassa = NULL,
glgb_acc_cassa_bt = NULL,
glgb_acc_cassa_mlt = NULL,
glgb_acc_firma = NULL,
glgb_acc_firma_dt = NULL,
glgb_acc_massimali = NULL,
glgb_acc_massimali_dt = NULL,
glgb_acc_rischi_indiretti = NULL,
glgb_acc_rischi_indiretti_dt = NULL,
glgb_acc_smobilizzo = NULL,
glgb_acc_sostituzioni = NULL,
glgb_acc_sostituzioni_dt = NULL,
glgb_acc_tot = NULL,
glgb_mau = NULL,
glgb_tot_gar = NULL,
glgb_uti_cassa = NULL,
glgb_uti_cassa_bt = NULL,
glgb_uti_cassa_mlt = NULL,
glgb_uti_firma = NULL,
glgb_uti_firma_dt = NULL,
glgb_uti_massimali = NULL,
glgb_uti_massimali_dt = NULL,
glgb_uti_rischi_indiretti = NULL,
glgb_uti_rischi_indiretti_dt = NULL,
glgb_uti_smobilizzo = NULL,
glgb_uti_sostituzioni = NULL,
glgb_uti_sostituzioni_dt = NULL,
glgb_uti_tot = NULL,
dta_upd = SYSDATE,
gb_val_mau = NULL
WHERE ( NOT EXISTS (SELECT DISTINCT 1
FROM t_mcre0_app_gruppo_legame e
WHERE e.cod_sndg = p.cod_sndg)
-- OR EXISTS (
-- SELECT 1
-- FROM t_mcre0_app_file_guida f
-- WHERE p.cod_abi_cartolarizzato =
-- f.cod_abi_cartolarizzato
-- AND p.cod_ndg = f.cod_ndg
-- AND f.flg_gruppo_legame = 0)
)
AND id_dper_gb IN (
SELECT id_dper
FROM (SELECT DISTINCT id_dper
FROM t_mcre0_app_pcr_gb
WHERE id_dper <= NVL (p_id_dper, id_dper)
ORDER BY id_dper DESC)
WHERE ROWNUM < 3);
COMMIT; 
EXCEPTION
WHEN OTHERS
THEN
log_caricamenti
('fnc_clean_no_pcr',
SQLCODE,
'UPDATE USCITI da legame - t_mcre0_app_pcr - SQLERRM='
|| SQLERRM
);
ROLLBACK;
RETURN ko;
END;
BEGIN
DELETE FROM t_mcre0_app_pcr
WHERE gegb_acc_consegne IS NULL
AND gegb_acc_consegne_dt IS NULL
AND gegb_uti_consegne IS NULL
AND gegb_uti_consegne_dt IS NULL
AND gesb_acc_consegne IS NULL
AND gesb_acc_consegne_dt IS NULL
AND gesb_uti_consegne IS NULL
AND gesb_uti_consegne_dt IS NULL
AND glgb_acc_consegne IS NULL
AND glgb_acc_consegne_dt IS NULL
AND glgb_uti_consegne IS NULL
AND glgb_uti_consegne_dt IS NULL
AND scgb_uti_consegne_dt IS NULL
AND scgb_uti_consegne IS NULL
AND scgb_acc_consegne_dt IS NULL
AND scgb_acc_consegne IS NULL
AND scsb_uti_consegne_dt IS NULL
AND scsb_uti_consegne IS NULL
AND scsb_acc_consegne_dt IS NULL
AND scsb_acc_consegne IS NULL
AND gegb_acc_cassa IS NULL
AND gegb_acc_cassa_bt IS NULL
AND gegb_acc_cassa_mlt IS NULL
AND gegb_acc_firma IS NULL
AND gegb_acc_firma_dt IS NULL
AND gegb_acc_massimali IS NULL
AND gegb_acc_massimali_dt IS NULL
AND gegb_acc_rischi_indiretti IS NULL
AND gegb_acc_rischi_indiretti_dt IS NULL
AND gegb_acc_smobilizzo IS NULL
AND gegb_acc_sostituzioni IS NULL
AND gegb_acc_sostituzioni_dt IS NULL
AND gegb_acc_tot IS NULL
AND gegb_uti_cassa IS NULL
AND gegb_uti_cassa_bt IS NULL
AND gegb_uti_cassa_mlt IS NULL
AND gegb_uti_firma IS NULL
AND gegb_uti_firma_dt IS NULL
AND gegb_uti_massimali IS NULL
AND gegb_uti_massimali_dt IS NULL
AND gegb_uti_rischi_indiretti IS NULL
AND gegb_uti_rischi_indiretti_dt IS NULL
AND gegb_uti_smobilizzo IS NULL
AND gegb_uti_sostituzioni IS NULL
AND gegb_uti_sostituzioni_dt IS NULL
AND gegb_uti_tot IS NULL
AND gesb_acc_cassa IS NULL
AND gesb_acc_cassa_bt IS NULL
AND gesb_acc_cassa_mlt IS NULL
AND gesb_acc_firma IS NULL
AND gesb_acc_firma_dt IS NULL
AND gesb_acc_massimali IS NULL
AND gesb_acc_massimali_dt IS NULL
AND gesb_acc_rischi_indiretti IS NULL
AND gesb_acc_rischi_indiretti_dt IS NULL
AND gesb_acc_smobilizzo IS NULL
AND gesb_acc_sostituzioni IS NULL
AND gesb_acc_sostituzioni_dt IS NULL
AND gesb_acc_tot IS NULL
AND gesb_uti_cassa IS NULL
AND gesb_uti_cassa_bt IS NULL
AND gesb_uti_cassa_mlt IS NULL
AND gesb_uti_firma IS NULL
AND gesb_uti_firma_dt IS NULL
AND gesb_uti_massimali IS NULL
AND gesb_uti_massimali_dt IS NULL
AND gesb_uti_rischi_indiretti IS NULL
AND gesb_uti_rischi_indiretti_dt IS NULL
AND gesb_uti_smobilizzo IS NULL
AND gesb_uti_sostituzioni IS NULL
AND gesb_uti_sostituzioni_dt IS NULL
AND gesb_uti_tot IS NULL
AND glgb_acc_cassa IS NULL
AND glgb_acc_cassa_bt IS NULL
AND glgb_acc_cassa_mlt IS NULL
AND glgb_acc_firma IS NULL
AND glgb_acc_firma_dt IS NULL
AND glgb_acc_massimali IS NULL
AND glgb_acc_massimali_dt IS NULL
AND glgb_acc_rischi_indiretti IS NULL
AND glgb_acc_rischi_indiretti_dt IS NULL
AND glgb_acc_smobilizzo IS NULL
AND glgb_acc_sostituzioni IS NULL
AND glgb_acc_sostituzioni_dt IS NULL
AND glgb_acc_tot IS NULL
AND glgb_uti_cassa IS NULL
AND glgb_uti_cassa_bt IS NULL
AND glgb_uti_cassa_mlt IS NULL
AND glgb_uti_firma IS NULL
AND glgb_uti_firma_dt IS NULL
AND glgb_uti_massimali IS NULL
AND glgb_uti_massimali_dt IS NULL
AND glgb_uti_rischi_indiretti IS NULL
AND glgb_uti_rischi_indiretti_dt IS NULL
AND glgb_uti_smobilizzo IS NULL
AND glgb_uti_sostituzioni IS NULL
AND glgb_uti_sostituzioni_dt IS NULL
AND glgb_uti_tot IS NULL
AND scgb_acc_cassa IS NULL
AND scgb_acc_cassa_bt IS NULL
AND scgb_acc_cassa_mlt IS NULL
AND scgb_acc_firma IS NULL
AND scgb_acc_firma_dt IS NULL
AND scgb_acc_massimali IS NULL
AND scgb_acc_massimali_dt IS NULL
AND scgb_acc_rischi_indiretti IS NULL
AND scgb_acc_rischi_indiretti_dt IS NULL
AND scgb_acc_smobilizzo IS NULL
AND scgb_acc_sostituzioni IS NULL
AND scgb_acc_sostituzioni_dt IS NULL
AND scgb_acc_tot IS NULL
AND scgb_uti_cassa IS NULL
AND scgb_uti_cassa_bt IS NULL
AND scgb_uti_cassa_mlt IS NULL
AND scgb_uti_firma IS NULL
AND scgb_uti_firma_dt IS NULL
AND scgb_uti_massimali IS NULL
AND scgb_uti_massimali_dt IS NULL
AND scgb_uti_rischi_indiretti IS NULL
AND scgb_uti_rischi_indiretti_dt IS NULL
AND scgb_uti_smobilizzo IS NULL
AND scgb_uti_sostituzioni IS NULL
AND scgb_uti_sostituzioni_dt IS NULL
AND scgb_uti_tot IS NULL
AND scsb_acc_cassa IS NULL
AND scsb_acc_cassa_bt IS NULL
AND scsb_acc_cassa_mlt IS NULL
AND scsb_acc_firma IS NULL
AND scsb_acc_firma_dt IS NULL
AND scsb_acc_massimali IS NULL
AND scsb_acc_massimali_dt IS NULL
AND scsb_acc_rischi_indiretti IS NULL
AND scsb_acc_rischi_indiretti_dt IS NULL
AND scsb_acc_smobilizzo IS NULL
AND scsb_acc_sostituzioni IS NULL
AND scsb_acc_sostituzioni_dt IS NULL
AND scsb_acc_tot IS NULL
AND scsb_uti_cassa IS NULL
AND scsb_uti_cassa_bt IS NULL
AND scsb_uti_cassa_mlt IS NULL
AND scsb_uti_firma IS NULL
AND scsb_uti_firma_dt IS NULL
AND scsb_uti_massimali IS NULL
AND scsb_uti_massimali_dt IS NULL
AND scsb_uti_rischi_indiretti IS NULL
AND scsb_uti_rischi_indiretti_dt IS NULL
AND scsb_uti_smobilizzo IS NULL
AND scsb_uti_sostituzioni IS NULL
AND scsb_uti_sostituzioni_dt IS NULL
AND scsb_uti_tot IS NULL;
COMMIT;
EXCEPTION
WHEN OTHERS
THEN
log_caricamenti ('fnc_clean_no_pcr',
SQLCODE,
'DELETE NO PCR - t_mcre0_app_pcr - SQLERRM='
|| SQLERRM
);
ROLLBACK;
END;
RETURN ok;
EXCEPTION
WHEN OTHERS
THEN
log_caricamenti ('fnc_clean_no_pcr',
SQLCODE,
'CLEAN PCR - t_mcre0_app_pcr - SQLERRM=' || SQLERRM
);
RETURN ko;
END;
-- Procedura per calcolo pcr
-- INPUT :
-- OUTPUT :
-- stato esecuzione 1 OK 0 Errori
FUNCTION fnc_load_pcr (
p_cod_log t_mcre0_wrk_audit_etl.ID%TYPE DEFAULT NULL,
p_id_dper t_mcre0_app_pcr_sc_sb.id_dper%TYPE DEFAULT NULL
)
RETURN NUMBER
IS
val_ok INTEGER;
v_cod_log t_mcre0_wrk_audit_etl.ID%TYPE;
e_invalid_pcr EXCEPTION;
BEGIN
IF (p_cod_log IS NULL)
THEN
SELECT seq_mcr0_log_etl.NEXTVAL
INTO v_cod_log
FROM DUAL;
ELSE
v_cod_log := p_cod_log;
END IF; 
pkg_mcre0_audit.log_etl (v_cod_log,
'PKG_MCRE0_PCR.FNC_LOAD_PCR',
pkg_mcre0_audit.c_debug,
SQLCODE,
SQLERRM,
'SCSB - START'
);
val_ok := fnc_load_pcr_scsb_merge (v_cod_log, p_id_dper);
IF (val_ok = ko)
THEN 
RAISE e_invalid_pcr;
END IF;
pkg_mcre0_audit.log_etl (v_cod_log,
'PKG_MCRE0_PCR.FNC_LOAD_PCR',
pkg_mcre0_audit.c_debug,
SQLCODE,
SQLERRM,
'GESB - START'
);
val_ok := fnc_load_pcr_gesb_merge (v_cod_log, p_id_dper);
IF (val_ok = ko)
THEN 
RAISE e_invalid_pcr;
END IF;
pkg_mcre0_audit.log_etl (v_cod_log,
'PKG_MCRE0_PCR.FNC_LOAD_PCR',
pkg_mcre0_audit.c_debug,
SQLCODE,
SQLERRM,
'GB - START'
);
val_ok := fnc_load_pcr_gb_merge (v_cod_log, p_id_dper);
IF (val_ok = ko)
THEN 
RAISE e_invalid_pcr;
END IF;
pkg_mcre0_audit.log_etl (v_cod_log,
'PKG_MCRE0_PCR.FNC_LOAD_PCR',
pkg_mcre0_audit.c_debug,
SQLCODE,
SQLERRM,
'CLEAN - START'
);
val_ok := fnc_clean_no_pcr (v_cod_log, p_id_dper);
IF (val_ok = ko)
THEN 
RAISE e_invalid_pcr;
END IF;
pkg_mcre0_audit.log_etl (v_cod_log,
'PKG_MCRE0_PCR.FNC_LOAD_PCR',
pkg_mcre0_audit.c_debug,
SQLCODE,
SQLERRM,
'MAU - START'
);
val_ok := fnc_calcolo_mau (v_cod_log, p_id_dper);
pkg_mcre0_audit.log_etl (v_cod_log,
'PKG_MCRE0_PCR.FNC_LOAD_PCR',
pkg_mcre0_audit.c_debug,
SQLCODE,
SQLERRM,
'END'
);
IF (val_ok = ko)
THEN 
RAISE e_invalid_pcr;
END IF;
--v2.0 - ripristino la partizione attiva
pkg_mcre0_audit.log_etl (v_cod_log,
'PKG_MCRE0_PCR.FNC_LOAD_PCR',
pkg_mcre0_audit.c_debug,
SQLCODE,
SQLERRM,
'UPDATE PCR FLG_TAODAY - START'
);
UPDATE t_mcre0_app_pcr
SET today_flg =
CASE
WHEN (cod_abi_cartolarizzato, cod_ndg) IN (
SELECT cod_abi_cartolarizzato, cod_ndg
FROM t_mcre0_app_mople PARTITION (ccp_p1))
THEN '1'
ELSE '0'
END;
COMMIT;
pkg_mcre0_audit.log_etl (v_cod_log,
'PKG_MCRE0_PCR.FNC_LOAD_PCR',
pkg_mcre0_audit.c_debug,
SQLCODE,
SQLERRM,
'UPDATE PCR FLG_TAODAY - END'
);
RETURN ok;
EXCEPTION
WHEN e_invalid_pcr
THEN
UPDATE t_mcre0_app_pcr
SET today_flg =
CASE
WHEN (cod_abi_cartolarizzato, cod_ndg) IN (
SELECT cod_abi_cartolarizzato, cod_ndg
FROM t_mcre0_app_mople PARTITION (ccp_p1))
THEN '1'
ELSE '0'
END;
COMMIT;
pkg_mcre0_audit.log_etl (v_cod_log,
'PKG_MCRE0_PCR.FNC_LOAD_PCR',
pkg_mcre0_audit.c_error,
SQLCODE,
SQLERRM,
'e_invalid_pcr - SQLERRM=' || SQLERRM
);
RETURN ok;
WHEN OTHERS
THEN
pkg_mcre0_audit.log_etl (v_cod_log,
'PKG_MCRE0_PCR.FNC_LOAD_PCR',
pkg_mcre0_audit.c_error,
SQLCODE,
SQLERRM,
'GENERALE - SQLERRM=' || SQLERRM
);
RETURN ko;
END;  
FUNCTION fnc_load_pcr_scsb_merge (
p_cod_log t_mcre0_wrk_audit_etl.ID%TYPE DEFAULT NULL,
p_id_dper t_mcre0_app_pcr_sc_sb.id_dper%TYPE DEFAULT NULL
)
RETURN NUMBER
IS
v_cod_log t_mcre0_wrk_audit_etl.ID%TYPE;
BEGIN
IF (p_cod_log IS NULL)
THEN
SELECT seq_mcr0_log_etl.NEXTVAL
INTO v_cod_log
FROM DUAL;
ELSE
v_cod_log := p_cod_log;
END IF;
MERGE INTO mcre_own.t_mcre0_app_pcr a
USING (SELECT xx.cod_abi_istituto, xx.cod_abi_cartolarizzato,
xx.cod_ndg, val_tot_acc_consegne scsb_acc_consegne,
val_tot_acc_consegne_dt scsb_acc_consegne_dt,
val_tot_uti_consegne scsb_uti_consegne,
val_tot_uti_consegne_dt scsb_uti_consegne_dt,
val_tot_uti_massimali scsb_uti_massimali,
val_tot_uti_sostituzioni scsb_uti_sostituzioni,
val_tot_uti_rischi_indiretti scsb_uti_rischi_indiretti,
val_tot_dett_uti_massimali scsb_uti_massimali_dt,
val_tot_dett_uti_sostituzioni scsb_uti_sostituzioni_dt,
val_tot_dett_uti_rischi_ind
scsb_uti_rischi_indiretti_dt,
val_tot_acc_massimali scsb_acc_massimali,
val_tot_acc_sostituzioni scsb_acc_sostituzioni,
val_tot_acc_rischi_indiretti scsb_acc_rischi_indiretti,
val_tot_dett_acc_massimali scsb_acc_massimali_dt,
val_tot_dett_acc_sostituzioni scsb_acc_sostituzioni_dt,
val_tot_dett_acc_rischi_ind
scsb_acc_rischi_indiretti_dt,
val_tot_uti_cassa scsb_uti_cassa,
val_tot_uti_firma scsb_uti_firma,
(val_tot_uti_cassa + val_tot_uti_firma) scsb_uti_tot,
val_tot_acc_cassa scsb_acc_cassa,
val_tot_acc_firma scsb_acc_firma,
(val_tot_acc_cassa + val_tot_acc_firma) scsb_acc_tot,
val_tot_dett_uti_cassa_bt scsb_uti_cassa_bt,
val_tot_dett_uti_cassa_mlt scsb_uti_cassa_mlt,
val_tot_dett_uti_smobilizzo scsb_uti_smobilizzo,
val_tot_dett_uti_firma scsb_uti_firma_dt,
val_tot_dett_acc_cassa_bt scsb_acc_cassa_bt,
val_tot_dett_acc_cassa_mlt scsb_acc_cassa_mlt,
val_tot_dett_acc_smobilizzo scsb_acc_smobilizzo,
val_tot_dett_acc_firma scsb_acc_firma_dt,
val_tot_gar scsb_tot_gar,
dta_riferimento scsb_dta_riferimento, xx.cod_sndg,
SYSDATE dta_ins, id_dper, SYSDATE dta_upd
FROM (SELECT cod_abi_istituto, cod_ndg, id_dper,
SUM
(CASE
WHEN cl.cod_classe_appl_cf = 'CO'
THEN pcr.val_imp_uti_cli
ELSE 0
END
) val_tot_uti_consegne,
SUM
(CASE
WHEN cl.cod_classe_appl_cf = 'CO'
THEN pcr.val_imp_uti_cli
ELSE 0
END
) val_tot_uti_consegne_dt,
SUM
(CASE
WHEN cl.cod_classe_appl_cf = 'CO'
THEN pcr.val_imp_acc_cli
ELSE 0
END
) val_tot_acc_consegne,
SUM
(CASE
WHEN cl.cod_classe_appl_cf = 'CO'
THEN pcr.val_imp_acc_cli
ELSE 0
END
) val_tot_acc_consegne_dt,
SUM
(CASE
WHEN cl.cod_classe_appl_cf = 'ST'
THEN pcr.val_imp_uti_cli
ELSE 0
END
) val_tot_uti_sostituzioni,
SUM
(CASE
WHEN cl.cod_classe_appl_cf = 'MS'
THEN pcr.val_imp_uti_cli
ELSE 0
END
) val_tot_uti_massimali,
SUM
(CASE
WHEN cl.cod_classe_appl_cf = 'RI'
THEN pcr.val_imp_uti_cli
ELSE 0
END
) val_tot_uti_rischi_indiretti,
SUM
(CASE
WHEN cl.cod_classe_appl_cf = 'ST'
THEN pcr.val_imp_acc_cli
ELSE 0
END
) val_tot_acc_sostituzioni,
SUM
(CASE
WHEN cl.cod_classe_appl_cf = 'MS'
THEN pcr.val_imp_acc_cli
ELSE 0
END
) val_tot_acc_massimali,
SUM
(CASE
WHEN cl.cod_classe_appl_cf = 'RI'
THEN pcr.val_imp_acc_cli
ELSE 0
END
) val_tot_acc_rischi_indiretti,
SUM
(CASE
WHEN cl.cod_classe_appl_cf = 'ST'
THEN pcr.val_imp_uti_cli
ELSE 0
END
) val_tot_dett_uti_sostituzioni,
SUM
(CASE
WHEN cl.cod_classe_appl_cf = 'MS'
THEN pcr.val_imp_uti_cli
ELSE 0
END
) val_tot_dett_uti_massimali,
SUM
(CASE
WHEN cl.cod_classe_appl_cf = 'RI'
THEN pcr.val_imp_uti_cli
ELSE 0
END
) val_tot_dett_uti_rischi_ind,
SUM
(CASE
WHEN cl.cod_classe_appl_cf = 'ST'
THEN pcr.val_imp_acc_cli
ELSE 0
END
) val_tot_dett_acc_sostituzioni,
SUM
(CASE
WHEN cl.cod_classe_appl_cf = 'MS'
THEN pcr.val_imp_acc_cli
ELSE 0
END
) val_tot_dett_acc_massimali,
SUM
(CASE
WHEN cl.cod_classe_appl_cf = 'RI'
THEN pcr.val_imp_acc_cli
ELSE 0
END
) val_tot_dett_acc_rischi_ind,

---------------------- OLD
SUM
(CASE
WHEN cl.cod_classe_appl_cf = 'CA'
THEN pcr.val_imp_uti_cli
ELSE 0
END
) val_tot_uti_cassa,
SUM
(CASE
WHEN cl.cod_classe_appl_cf = 'FI'
THEN pcr.val_imp_uti_cli
ELSE 0
END
) val_tot_uti_firma,
SUM
(CASE
WHEN cl.cod_classe_appl_cf = 'CA'
THEN pcr.val_imp_acc_cli
ELSE 0
END
) val_tot_acc_cassa,
SUM
(CASE
WHEN cl.cod_classe_appl_cf = 'FI'
THEN pcr.val_imp_acc_cli
ELSE 0
END
) val_tot_acc_firma,
MAX (val_imp_gar_tot) val_tot_gar,

--stesso valore su tutte le Forme Tecniche
SUM
(CASE
WHEN cl.cod_classe_appl_dett = 'CB'
THEN pcr.val_imp_uti_cli
ELSE 0
END
) val_tot_dett_uti_cassa_bt,
SUM
(CASE
WHEN cl.cod_classe_appl_dett = 'CM'
THEN pcr.val_imp_uti_cli
ELSE 0
END
) val_tot_dett_uti_cassa_mlt,
SUM
(CASE
WHEN cl.cod_classe_appl_dett = 'SM'
THEN pcr.val_imp_uti_cli
ELSE 0
END
) val_tot_dett_uti_smobilizzo,
SUM
(CASE
WHEN cl.cod_classe_appl_dett = 'FI'
THEN pcr.val_imp_uti_cli
ELSE 0
END
) val_tot_dett_uti_firma,
SUM
(CASE
WHEN cl.cod_classe_appl_dett = 'CB'
THEN pcr.val_imp_acc_cli
ELSE 0
END
) val_tot_dett_acc_cassa_bt,
SUM
(CASE
WHEN cl.cod_classe_appl_dett = 'CM'
THEN pcr.val_imp_acc_cli
ELSE 0
END
) val_tot_dett_acc_cassa_mlt,
SUM
(CASE
WHEN cl.cod_classe_appl_dett = 'SM'
THEN pcr.val_imp_acc_cli
ELSE 0
END
) val_tot_dett_acc_smobilizzo,
SUM
(CASE
WHEN cl.cod_classe_appl_dett = 'FI'
THEN pcr.val_imp_acc_cli
ELSE 0
END
) val_tot_dett_acc_firma,
MAX (pcr.dta_riferimento) dta_riferimento
FROM t_mcre0_app_pcr_sc_sb pcr,
t_mcre0_app_natura_ftecnica cl
WHERE pcr.cod_forma_tecnica = cl.cod_ftecnica
AND pcr.id_dper =
NVL (p_id_dper,
(SELECT a.idper
FROM v_mcre0_ultima_acquisizione a
WHERE a.cod_file = 'PCR_SC_SB')
)
GROUP BY pcr.cod_abi_istituto,
pcr.cod_ndg,
pcr.id_dper) s,
(SELECT /*+parallel(f,2,1) parallel_index(f IDX_MCRE0_APP_FILE_GUIDA_IDPER)*/
DISTINCT cod_sndg, cod_abi_cartolarizzato,
cod_abi_istituto, cod_ndg
FROM t_mcre0_app_file_guida f
WHERE f.id_dper =
(SELECT a.idper
FROM v_mcre0_ultima_acquisizione a
WHERE a.cod_file = 'FILE_GUIDA')) xx
WHERE xx.cod_abi_istituto = s.cod_abi_istituto
AND xx.cod_ndg = s.cod_ndg) b
ON ( a.cod_abi_cartolarizzato = b.cod_abi_cartolarizzato
AND a.cod_ndg = b.cod_ndg)
WHEN MATCHED THEN
UPDATE
SET a.scsb_uti_cassa = b.scsb_uti_cassa,
a.scsb_uti_firma = b.scsb_uti_firma,
a.scsb_uti_tot = b.scsb_uti_tot,
a.scsb_acc_cassa = b.scsb_acc_cassa,
a.scsb_acc_firma = b.scsb_acc_firma,
a.scsb_acc_tot = b.scsb_acc_tot,
a.scsb_uti_cassa_bt = b.scsb_uti_cassa_bt,
a.scsb_uti_cassa_mlt = b.scsb_uti_cassa_mlt,
a.scsb_uti_smobilizzo = b.scsb_uti_smobilizzo,
a.scsb_uti_firma_dt = b.scsb_uti_firma_dt,
a.scsb_acc_cassa_bt = b.scsb_acc_cassa_bt,
a.scsb_acc_cassa_mlt = b.scsb_acc_cassa_mlt,
a.scsb_acc_smobilizzo = b.scsb_acc_smobilizzo,
a.scsb_acc_firma_dt = b.scsb_acc_firma_dt,
a.scsb_tot_gar = b.scsb_tot_gar,
a.scsb_dta_riferimento = b.scsb_dta_riferimento,
a.scsb_uti_massimali = b.scsb_uti_massimali,
a.scsb_uti_sostituzioni = b.scsb_uti_sostituzioni,
a.scsb_uti_rischi_indiretti = b.scsb_uti_rischi_indiretti,
a.scsb_uti_massimali_dt = b.scsb_uti_massimali_dt,
a.scsb_uti_sostituzioni_dt = b.scsb_uti_sostituzioni_dt,
a.scsb_uti_rischi_indiretti_dt =
b.scsb_uti_rischi_indiretti_dt,
a.scsb_acc_massimali = b.scsb_acc_massimali,
a.scsb_acc_sostituzioni = b.scsb_acc_sostituzioni,
a.scsb_acc_rischi_indiretti = b.scsb_acc_rischi_indiretti,
a.scsb_acc_massimali_dt = b.scsb_acc_massimali_dt,
a.scsb_acc_sostituzioni_dt = b.scsb_acc_sostituzioni_dt,
a.scsb_acc_rischi_indiretti_dt =
b.scsb_acc_rischi_indiretti_dt,
a.scsb_acc_consegne = b.scsb_acc_consegne,
a.scsb_acc_consegne_dt = b.scsb_acc_consegne_dt,
a.scsb_uti_consegne = b.scsb_uti_consegne,
a.scsb_uti_consegne_dt = b.scsb_uti_consegne_dt,
a.cod_sndg = b.cod_sndg, a.dta_upd = b.dta_upd,
a.id_dper_scsb = b.id_dper
WHEN NOT MATCHED THEN
INSERT (cod_abi_istituto, cod_ndg, cod_abi_cartolarizzato,
scsb_uti_sostituzioni, scsb_uti_massimali,
scsb_uti_rischi_indiretti, scsb_uti_sostituzioni_dt,
scsb_uti_massimali_dt, scsb_uti_rischi_indiretti_dt,
scsb_acc_sostituzioni, scsb_acc_massimali,
scsb_acc_rischi_indiretti, scsb_acc_sostituzioni_dt,
scsb_acc_massimali_dt, scsb_acc_rischi_indiretti_dt,
scsb_acc_consegne, scsb_acc_consegne_dt,
scsb_uti_consegne, scsb_uti_consegne_dt, scsb_uti_cassa,
scsb_uti_firma, scsb_uti_tot, scsb_acc_cassa,
scsb_acc_firma, scsb_acc_tot, scsb_uti_cassa_bt,
scsb_uti_cassa_mlt, scsb_uti_smobilizzo,
scsb_uti_firma_dt, scsb_acc_cassa_bt, scsb_acc_cassa_mlt,
scsb_acc_smobilizzo, scsb_acc_firma_dt, scsb_tot_gar,
scsb_dta_riferimento, cod_sndg, dta_ins, id_dper_scsb)
VALUES (b.cod_abi_istituto, b.cod_ndg, b.cod_abi_cartolarizzato,
b.scsb_uti_sostituzioni, b.scsb_uti_massimali,
b.scsb_uti_rischi_indiretti, b.scsb_uti_sostituzioni_dt,
b.scsb_uti_massimali_dt, b.scsb_uti_rischi_indiretti_dt,
b.scsb_acc_sostituzioni, b.scsb_acc_massimali,
b.scsb_acc_rischi_indiretti, b.scsb_acc_sostituzioni_dt,
b.scsb_acc_massimali_dt, b.scsb_acc_rischi_indiretti_dt,
b.scsb_acc_consegne, b.scsb_acc_consegne_dt,
b.scsb_uti_consegne, b.scsb_uti_consegne_dt,
b.scsb_uti_cassa, b.scsb_uti_firma, b.scsb_uti_tot,
b.scsb_acc_cassa, b.scsb_acc_firma, b.scsb_acc_tot,
b.scsb_uti_cassa_bt, b.scsb_uti_cassa_mlt,
b.scsb_uti_smobilizzo, b.scsb_uti_firma_dt,
b.scsb_acc_cassa_bt, b.scsb_acc_cassa_mlt,
b.scsb_acc_smobilizzo, b.scsb_acc_firma_dt,
b.scsb_tot_gar, b.scsb_dta_riferimento, b.cod_sndg,
b.dta_ins, b.id_dper);
COMMIT;
RETURN ok;
EXCEPTION
WHEN OTHERS
THEN
log_caricamenti ('fnc_load_pcr_scsb_merge', SQLCODE, SQLERRM);
RETURN ko;
END;
-- Procedura per calcolo pcr gesb usando la MERGE
-- INPUT :
-- OUTPUT :
-- stato esecuzione 1 OK 0 Errori
FUNCTION fnc_load_pcr_gesb_merge (
p_cod_log t_mcre0_wrk_audit_etl.ID%TYPE DEFAULT NULL,
p_id_dper t_mcre0_app_pcr_sc_sb.id_dper%TYPE DEFAULT NULL
)
RETURN NUMBER
IS
v_cod_log t_mcre0_wrk_audit_etl.ID%TYPE;
BEGIN
IF (p_cod_log IS NULL)
THEN
SELECT seq_mcr0_log_etl.NEXTVAL
INTO v_cod_log
FROM DUAL;
ELSE
v_cod_log := p_cod_log;
END IF;
MERGE INTO mcre_own.t_mcre0_app_pcr a
USING (SELECT id_dper, gesb_acc_consegne, gesb_acc_consegne_dt,
gesb_uti_consegne, gesb_uti_consegne_dt,
gesb_uti_sostituzioni, gesb_uti_massimali,
gesb_uti_rischi_indiretti, gesb_uti_sostituzioni_dt,
gesb_uti_massimali_dt, gesb_uti_rischi_indiretti_dt,
gesb_acc_sostituzioni, gesb_acc_massimali,
gesb_acc_rischi_indiretti, gesb_acc_sostituzioni_dt,
gesb_acc_massimali_dt, gesb_acc_rischi_indiretti_dt,
gesb_uti_cassa, gesb_uti_firma, gesb_acc_cassa,
gesb_acc_firma, gesb_uti_cassa_bt, gesb_uti_cassa_mlt,
gesb_uti_smobilizzo, gesb_uti_firma_dt,
gesb_acc_cassa_bt, gesb_acc_cassa_mlt,
gesb_acc_smobilizzo, gesb_acc_firma_dt, gesb_tot_gar,
gesb_dta_riferimento,
gesb_acc_cassa + gesb_acc_firma gesb_acc_tot,
gesb_uti_cassa + gesb_uti_firma gesb_uti_tot,
xx.cod_sndg, xx.cod_abi_istituto, xx.cod_ndg,
cod_abi_cartolarizzato, SYSDATE dta_ins,
SYSDATE dta_upd
FROM (SELECT pcr.cod_abi_istituto, pcr.cod_sndg,
pcr.id_dper, ge.cod_gruppo_economico,
SUM
(CASE
WHEN cl.cod_classe_appl_cf = 'CO'
THEN pcr.val_imp_uti_gre
ELSE 0
END
) gesb_uti_consegne,
SUM
(CASE
WHEN cl.cod_classe_appl_cf = 'CO'
THEN pcr.val_imp_uti_gre
ELSE 0
END
) gesb_uti_consegne_dt,
SUM
(CASE
WHEN cl.cod_classe_appl_cf = 'CO'
THEN pcr.val_imp_acc_gre
ELSE 0
END
) gesb_acc_consegne,
SUM
(CASE
WHEN cl.cod_classe_appl_cf = 'CO'
THEN pcr.val_imp_acc_gre
ELSE 0
END
) gesb_acc_consegne_dt,
SUM
(CASE
WHEN cl.cod_classe_appl_cf = 'ST'
THEN pcr.val_imp_uti_gre
ELSE 0
END
) gesb_uti_sostituzioni,
SUM
(CASE
WHEN cl.cod_classe_appl_cf = 'MS'
THEN pcr.val_imp_uti_gre
ELSE 0
END
) gesb_uti_massimali,
SUM
(CASE
WHEN cl.cod_classe_appl_cf = 'RI'
THEN pcr.val_imp_uti_gre
ELSE 0
END
) gesb_uti_rischi_indiretti,
SUM
(CASE
WHEN cl.cod_classe_appl_cf = 'ST'
THEN pcr.val_imp_acc_gre
ELSE 0
END
) gesb_acc_sostituzioni,
SUM
(CASE
WHEN cl.cod_classe_appl_cf = 'MS'
THEN pcr.val_imp_acc_gre
ELSE 0
END
) gesb_acc_massimali,
SUM
(CASE
WHEN cl.cod_classe_appl_cf = 'RI'
THEN pcr.val_imp_acc_gre
ELSE 0
END
) gesb_acc_rischi_indiretti,
SUM
(CASE
WHEN cl.cod_classe_appl_cf = 'ST'
THEN pcr.val_imp_acc_gre
ELSE 0
END
) gesb_acc_sostituzioni_dt,
SUM
(CASE
WHEN cl.cod_classe_appl_cf = 'MS'
THEN pcr.val_imp_acc_gre
ELSE 0
END
) gesb_acc_massimali_dt,
SUM
(CASE
WHEN cl.cod_classe_appl_cf = 'RI'
THEN pcr.val_imp_acc_gre
ELSE 0
END
) gesb_acc_rischi_indiretti_dt,
SUM
(CASE
WHEN cl.cod_classe_appl_cf = 'ST'
THEN pcr.val_imp_uti_gre
ELSE 0
END
) gesb_uti_sostituzioni_dt,
SUM
(CASE
WHEN cl.cod_classe_appl_cf = 'MS'
THEN pcr.val_imp_uti_gre
ELSE 0
END
) gesb_uti_massimali_dt,
SUM
(CASE
WHEN cl.cod_classe_appl_cf = 'RI'
THEN pcr.val_imp_uti_gre
ELSE 0
END
) gesb_uti_rischi_indiretti_dt,
---------------------------------------- OLD
SUM
(CASE
WHEN cl.cod_classe_appl_cf = 'CA'
THEN pcr.val_imp_uti_gre
ELSE 0
END
) gesb_uti_cassa,
SUM
(CASE
WHEN cl.cod_classe_appl_cf = 'FI'
THEN pcr.val_imp_uti_gre
ELSE 0
END
) gesb_uti_firma,
SUM
(CASE
WHEN cl.cod_classe_appl_cf = 'CA'
THEN pcr.val_imp_acc_gre
ELSE 0
END
) gesb_acc_cassa,
SUM
(CASE
WHEN cl.cod_classe_appl_cf = 'FI'
THEN pcr.val_imp_acc_gre
ELSE 0
END
) gesb_acc_firma,
MAX (val_imp_gar_gre) gesb_tot_gar,

--stesso valore su tutte le Forme Tecniche
SUM
(CASE
WHEN cl.cod_classe_appl_dett = 'CB'
THEN pcr.val_imp_uti_gre
ELSE 0
END
) gesb_uti_cassa_bt,
SUM
(CASE
WHEN cl.cod_classe_appl_dett = 'CM'
THEN pcr.val_imp_uti_gre
ELSE 0
END
) gesb_uti_cassa_mlt,
SUM
(CASE
WHEN cl.cod_classe_appl_dett = 'SM'
THEN pcr.val_imp_uti_gre
ELSE 0
END
) gesb_uti_smobilizzo,
SUM
(CASE
WHEN cl.cod_classe_appl_dett = 'FI'
THEN pcr.val_imp_uti_gre
ELSE 0
END
) gesb_uti_firma_dt,
SUM
(CASE
WHEN cl.cod_classe_appl_dett = 'CB'
THEN pcr.val_imp_acc_gre
ELSE 0
END
) gesb_acc_cassa_bt,
SUM
(CASE
WHEN cl.cod_classe_appl_dett = 'CM'
THEN pcr.val_imp_acc_gre
ELSE 0
END
) gesb_acc_cassa_mlt,
SUM
(CASE
WHEN cl.cod_classe_appl_dett = 'SM'
THEN pcr.val_imp_acc_gre
ELSE 0
END
) gesb_acc_smobilizzo,
SUM
(CASE
WHEN cl.cod_classe_appl_dett = 'FI'
THEN pcr.val_imp_acc_gre
ELSE 0
END
) gesb_acc_firma_dt,
MAX
(pcr.dta_riferimento)
gesb_dta_riferimento
FROM t_mcre0_app_pcr_ge_sb pcr,
t_mcre0_app_natura_ftecnica cl,
mcre_own.t_mcre0_app_gruppo_economico ge
WHERE pcr.cod_forma_tecn = cl.cod_ftecnica
AND pcr.cod_sndg = ge.cod_sndg
AND pcr.id_dper =
NVL (p_id_dper,
(SELECT a.idper
FROM v_mcre0_ultima_acquisizione a
WHERE a.cod_file = 'PCR_GE_SB')
)
GROUP BY pcr.cod_abi_istituto,
pcr.cod_sndg,
ge.cod_gruppo_economico,
pcr.id_dper) p,
(SELECT DISTINCT cod_sndg, cod_abi_cartolarizzato,
cod_abi_istituto, cod_ndg
FROM t_mcre0_app_file_guida f
WHERE f.id_dper =
NVL
(p_id_dper,
(SELECT a.idper
FROM v_mcre0_ultima_acquisizione a
WHERE a.cod_file =
'FILE_GUIDA')
)) xx
WHERE xx.cod_sndg = p.cod_sndg
AND xx.cod_abi_istituto =
p.cod_abi_istituto
--and rownum<101
) b
ON ( a.cod_abi_cartolarizzato = b.cod_abi_cartolarizzato
AND a.cod_ndg = b.cod_ndg)
WHEN MATCHED THEN
UPDATE
SET
--v2.2 aggiorno anche sndg
a.cod_sndg = b.cod_sndg,
a.gesb_acc_cassa = b.gesb_acc_cassa,
a.gesb_acc_cassa_bt = b.gesb_acc_cassa_bt,
a.gesb_acc_cassa_mlt = b.gesb_acc_cassa_mlt,
a.gesb_acc_firma = b.gesb_acc_firma,
a.gesb_acc_firma_dt = b.gesb_acc_firma_dt,
a.gesb_acc_smobilizzo = b.gesb_acc_smobilizzo,
a.gesb_dta_riferimento = b.gesb_dta_riferimento,
a.gesb_tot_gar = b.gesb_tot_gar,
a.gesb_uti_cassa = b.gesb_uti_cassa,
a.gesb_uti_cassa_bt = b.gesb_uti_cassa_bt,
a.gesb_uti_cassa_mlt = b.gesb_uti_cassa_mlt,
a.gesb_uti_firma = b.gesb_uti_firma,
a.gesb_uti_firma_dt = b.gesb_uti_firma_dt,
a.gesb_uti_smobilizzo = b.gesb_uti_smobilizzo,
a.gesb_acc_tot = b.gesb_acc_tot,
a.gesb_uti_tot = b.gesb_uti_tot,
a.gesb_uti_massimali = b.gesb_uti_massimali,
a.gesb_uti_sostituzioni = b.gesb_uti_sostituzioni,
a.gesb_uti_rischi_indiretti = b.gesb_uti_rischi_indiretti,
a.gesb_uti_massimali_dt = b.gesb_uti_massimali_dt,
a.gesb_uti_sostituzioni_dt = b.gesb_uti_sostituzioni_dt,
a.gesb_uti_rischi_indiretti_dt =
b.gesb_uti_rischi_indiretti_dt,
a.gesb_acc_massimali = b.gesb_acc_massimali,
a.gesb_acc_sostituzioni = b.gesb_acc_sostituzioni,
a.gesb_acc_rischi_indiretti = b.gesb_acc_rischi_indiretti,
a.gesb_acc_massimali_dt = b.gesb_acc_massimali_dt,
a.gesb_acc_sostituzioni_dt = b.gesb_acc_sostituzioni_dt,
a.gesb_acc_rischi_indiretti_dt =
b.gesb_acc_rischi_indiretti_dt,
a.gesb_acc_consegne = b.gesb_acc_consegne,
a.gesb_acc_consegne_dt = b.gesb_acc_consegne_dt,
a.gesb_uti_consegne = b.gesb_uti_consegne,
a.gesb_uti_consegne_dt = b.gesb_uti_consegne_dt,
a.id_dper_gesb = b.id_dper
WHEN NOT MATCHED THEN
INSERT (cod_abi_istituto, cod_ndg, cod_abi_cartolarizzato,
gesb_uti_sostituzioni, gesb_uti_massimali,
gesb_uti_rischi_indiretti, gesb_uti_sostituzioni_dt,
gesb_uti_massimali_dt, gesb_uti_rischi_indiretti_dt,
gesb_acc_sostituzioni, gesb_acc_massimali,
gesb_acc_rischi_indiretti, gesb_acc_sostituzioni_dt,
gesb_acc_massimali_dt, gesb_acc_rischi_indiretti_dt,
gesb_uti_consegne, gesb_uti_consegne_dt,
gesb_acc_consegne, gesb_acc_consegne_dt, gesb_uti_cassa,
gesb_uti_firma, gesb_uti_tot, gesb_acc_cassa,
gesb_acc_firma, gesb_acc_tot, gesb_uti_cassa_bt,
gesb_uti_cassa_mlt, gesb_uti_smobilizzo,
gesb_uti_firma_dt, gesb_acc_cassa_bt, gesb_acc_cassa_mlt,
gesb_acc_smobilizzo, gesb_acc_firma_dt, gesb_tot_gar,
gesb_dta_riferimento, cod_sndg, dta_ins, id_dper_gesb)
VALUES (b.cod_abi_istituto, b.cod_ndg, b.cod_abi_cartolarizzato,
b.gesb_uti_sostituzioni, b.gesb_uti_massimali,
b.gesb_uti_rischi_indiretti, b.gesb_uti_sostituzioni_dt,
b.gesb_uti_massimali_dt, b.gesb_uti_rischi_indiretti_dt,
b.gesb_acc_sostituzioni, b.gesb_acc_massimali,
b.gesb_acc_rischi_indiretti, b.gesb_acc_sostituzioni_dt,
b.gesb_acc_massimali_dt, b.gesb_acc_rischi_indiretti_dt,
b.gesb_uti_consegne, b.gesb_uti_consegne_dt,
b.gesb_acc_consegne, b.gesb_acc_consegne_dt,
b.gesb_uti_cassa, b.gesb_uti_firma, b.gesb_uti_tot,
b.gesb_acc_cassa, b.gesb_acc_firma, b.gesb_acc_tot,
b.gesb_uti_cassa_bt, b.gesb_uti_cassa_mlt,
b.gesb_uti_smobilizzo, b.gesb_uti_firma_dt,
b.gesb_acc_cassa_bt, b.gesb_acc_cassa_mlt,
b.gesb_acc_smobilizzo, b.gesb_acc_firma_dt,
b.gesb_tot_gar, b.gesb_dta_riferimento, b.cod_sndg,
b.dta_ins, b.id_dper);
COMMIT;
RETURN ok;
EXCEPTION
WHEN OTHERS
THEN
log_caricamenti ('fnc_load_pcr_gesb_merge', SQLCODE, SQLERRM);
RETURN ko;
END; 
FUNCTION fnc_load_pcr_gb_merge (
p_cod_log t_mcre0_wrk_audit_etl.ID%TYPE DEFAULT NULL,
p_id_dper t_mcre0_app_pcr_sc_sb.id_dper%TYPE DEFAULT NULL
)
RETURN NUMBER
IS
v_cod_log t_mcre0_wrk_audit_etl.ID%TYPE;
BEGIN
IF (p_cod_log IS NULL)
THEN
SELECT seq_mcr0_log_etl.NEXTVAL
INTO v_cod_log
FROM DUAL;
ELSE
v_cod_log := p_cod_log;
END IF;
MERGE INTO mcre_own.t_mcre0_app_pcr a
USING (SELECT id_dper, xx.cod_sndg, xx.cod_abi_istituto,
cod_abi_cartolarizzato, xx.cod_ndg, p.dta_riferimento,
SYSDATE dta_ins, SYSDATE dta_upd, gegb_tot_gar,
scgb_tot_gar, glgb_tot_gar, scgb_acc_consegne,
scgb_acc_consegne_dt, scgb_uti_consegne,
scgb_uti_consegne_dt, gegb_acc_consegne,
gegb_acc_consegne_dt, gegb_uti_consegne,
gegb_uti_consegne_dt, glgb_acc_consegne,
glgb_acc_consegne_dt, glgb_uti_consegne,
glgb_uti_consegne_dt, scgb_uti_massimali,
scgb_uti_sostituzioni, scgb_uti_rischi_indiretti,
scgb_uti_massimali_dt, scgb_uti_sostituzioni_dt,
scgb_uti_rischi_indiretti_dt, scgb_acc_massimali,
scgb_acc_sostituzioni, scgb_acc_rischi_indiretti,
scgb_acc_massimali_dt, scgb_acc_sostituzioni_dt,
scgb_acc_rischi_indiretti_dt, gegb_uti_massimali,
gegb_uti_sostituzioni, gegb_uti_rischi_indiretti,
gegb_uti_massimali_dt, gegb_uti_sostituzioni_dt,
gegb_uti_rischi_indiretti_dt, gegb_acc_massimali,
gegb_acc_sostituzioni, gegb_acc_rischi_indiretti,
gegb_acc_massimali_dt, gegb_acc_sostituzioni_dt,
gegb_acc_rischi_indiretti_dt, glgb_uti_massimali,
glgb_uti_sostituzioni, glgb_uti_rischi_indiretti,
glgb_uti_massimali_dt, glgb_uti_sostituzioni_dt,
glgb_uti_rischi_indiretti_dt, glgb_acc_massimali,
glgb_acc_sostituzioni, glgb_acc_rischi_indiretti,
glgb_acc_massimali_dt, glgb_acc_sostituzioni_dt,
glgb_acc_rischi_indiretti_dt, scgb_uti_cassa,
scgb_uti_firma, scgb_acc_cassa, scgb_acc_firma,
scgb_uti_cassa_bt, scgb_uti_cassa_mlt,
scgb_uti_smobilizzo, scgb_uti_firma_dt,
scgb_acc_cassa_bt, scgb_acc_cassa_mlt,
scgb_acc_smobilizzo, scgb_acc_firma_dt, gegb_uti_cassa,
gegb_uti_firma, gegb_acc_cassa, gegb_acc_firma,
gegb_uti_cassa_bt, gegb_uti_cassa_mlt,
gegb_uti_smobilizzo, gegb_uti_firma_dt,
gegb_acc_cassa_bt, gegb_acc_cassa_mlt,
gegb_acc_smobilizzo, gegb_acc_firma_dt, glgb_uti_cassa,
glgb_uti_firma, glgb_acc_cassa, glgb_acc_firma,
glgb_uti_cassa_bt, glgb_uti_cassa_mlt,
glgb_uti_smobilizzo, glgb_uti_firma_dt,
glgb_acc_cassa_bt, glgb_acc_cassa_mlt,
glgb_acc_smobilizzo, glgb_acc_firma_dt,
gegb_uti_cassa + gegb_uti_firma gegb_uti_tot,
gegb_acc_cassa + gegb_acc_firma gegb_acc_tot,
glgb_uti_cassa + glgb_uti_firma glgb_uti_tot,
glgb_acc_cassa + glgb_acc_firma glgb_acc_tot,
scgb_uti_cassa + scgb_uti_firma scgb_uti_tot,
scgb_acc_cassa + scgb_acc_firma scgb_acc_tot,
DECODE (SIGN ( (gegb_uti_cassa + gegb_uti_firma)
- (gegb_acc_cassa + gegb_acc_firma)
),
-1, (gegb_acc_cassa + gegb_acc_firma),
(gegb_uti_cassa + gegb_uti_firma
)
) gegb_mau,
DECODE (SIGN ( (glgb_uti_cassa + glgb_uti_firma)
- (glgb_acc_cassa + glgb_acc_firma)
),
-1, (glgb_acc_cassa + glgb_acc_firma),
(glgb_uti_cassa + glgb_uti_firma
)
) glgb_mau,
DECODE (SIGN ( (scgb_uti_cassa + scgb_uti_firma)
- (scgb_acc_cassa + scgb_acc_firma)
),
-1, (scgb_acc_cassa + scgb_acc_firma),
(scgb_uti_cassa + scgb_uti_firma
)
) scgb_mau
FROM (SELECT pcr.cod_sndg, pcr.id_dper,
MAX (val_imp_gar_gre) gegb_tot_gar,
MAX (val_imp_gar_cli) scgb_tot_gar,
MAX (val_imp_gar_leg) glgb_tot_gar,
SUM
(CASE
WHEN cl.cod_classe_appl_cf = 'CO'
THEN pcr.val_imp_uti_gre
ELSE 0
END
) gegb_uti_consegne,
SUM
(CASE
WHEN cl.cod_classe_appl_cf = 'CO'
THEN pcr.val_imp_uti_gre
ELSE 0
END
) gegb_uti_consegne_dt,
SUM
(CASE
WHEN cl.cod_classe_appl_cf = 'CO'
THEN pcr.val_imp_acc_gre
ELSE 0
END
) gegb_acc_consegne,
SUM
(CASE
WHEN cl.cod_classe_appl_cf = 'CO'
THEN pcr.val_imp_acc_gre
ELSE 0
END
) gegb_acc_consegne_dt,
SUM
(CASE
WHEN cl.cod_classe_appl_cf = 'CO'
THEN pcr.val_imp_uti_cli
ELSE 0
END
) scgb_uti_consegne,
SUM
(CASE
WHEN cl.cod_classe_appl_cf = 'CO'
THEN pcr.val_imp_uti_cli
ELSE 0
END
) scgb_uti_consegne_dt,
SUM
(CASE
WHEN cl.cod_classe_appl_cf = 'CO'
THEN pcr.val_imp_acc_cli
ELSE 0
END
) scgb_acc_consegne,
SUM
(CASE
WHEN cl.cod_classe_appl_cf = 'CO'
THEN pcr.val_imp_acc_cli
ELSE 0
END
) scgb_acc_consegne_dt,
SUM
(CASE
WHEN cl.cod_classe_appl_cf = 'CO'
THEN pcr.val_imp_uti_leg
ELSE 0
END
) glgb_uti_consegne,
SUM
(CASE
WHEN cl.cod_classe_appl_cf = 'CO'
THEN pcr.val_imp_uti_leg
ELSE 0
END
) glgb_uti_consegne_dt,
SUM
(CASE
WHEN cl.cod_classe_appl_cf = 'CO'
THEN pcr.val_imp_acc_leg
ELSE 0
END
) glgb_acc_consegne,
SUM
(CASE
WHEN cl.cod_classe_appl_cf = 'CO'
THEN pcr.val_imp_acc_leg
ELSE 0
END
) glgb_acc_consegne_dt,
SUM
(CASE
WHEN cl.cod_classe_appl_cf = 'ST'
THEN pcr.val_imp_uti_gre
ELSE 0
END
) gegb_uti_sostituzioni,
SUM
(CASE
WHEN cl.cod_classe_appl_cf = 'MS'
THEN pcr.val_imp_uti_gre
ELSE 0
END
) gegb_uti_massimali,
SUM
(CASE
WHEN cl.cod_classe_appl_cf = 'RI'
THEN pcr.val_imp_uti_gre
ELSE 0
END
) gegb_uti_rischi_indiretti,
SUM
(CASE
WHEN cl.cod_classe_appl_cf = 'ST'
THEN pcr.val_imp_acc_gre
ELSE 0
END
) gegb_acc_sostituzioni,
SUM
(CASE
WHEN cl.cod_classe_appl_cf = 'MS'
THEN pcr.val_imp_acc_gre
ELSE 0
END
) gegb_acc_massimali,
SUM
(CASE
WHEN cl.cod_classe_appl_cf = 'RI'
THEN pcr.val_imp_acc_gre
ELSE 0
END
) gegb_acc_rischi_indiretti,
SUM
(CASE
WHEN cl.cod_classe_appl_cf = 'ST'
THEN pcr.val_imp_uti_gre
ELSE 0
END
) gegb_uti_sostituzioni_dt,
SUM
(CASE
WHEN cl.cod_classe_appl_cf = 'MS'
THEN pcr.val_imp_uti_gre
ELSE 0
END
) gegb_uti_massimali_dt,
SUM
(CASE
WHEN cl.cod_classe_appl_cf = 'RI'
THEN pcr.val_imp_uti_gre
ELSE 0
END
) gegb_uti_rischi_indiretti_dt,
SUM
(CASE
WHEN cl.cod_classe_appl_cf = 'ST'
THEN pcr.val_imp_acc_gre
ELSE 0
END
) gegb_acc_sostituzioni_dt,
SUM
(CASE
WHEN cl.cod_classe_appl_cf = 'MS'
THEN pcr.val_imp_acc_gre
ELSE 0
END
) gegb_acc_massimali_dt,
SUM
(CASE
WHEN cl.cod_classe_appl_cf = 'RI'
THEN pcr.val_imp_acc_gre
ELSE 0
END
) gegb_acc_rischi_indiretti_dt,
SUM
(CASE
WHEN cl.cod_classe_appl_cf = 'ST'
THEN pcr.val_imp_uti_cli
ELSE 0
END
) scgb_uti_sostituzioni,
SUM
(CASE
WHEN cl.cod_classe_appl_cf = 'MS'
THEN pcr.val_imp_uti_cli
ELSE 0
END
) scgb_uti_massimali,
SUM
(CASE
WHEN cl.cod_classe_appl_cf = 'RI'
THEN pcr.val_imp_uti_cli
ELSE 0
END
) scgb_uti_rischi_indiretti,
SUM
(CASE
WHEN cl.cod_classe_appl_cf = 'ST'
THEN pcr.val_imp_acc_cli
ELSE 0
END
) scgb_acc_sostituzioni,
SUM
(CASE
WHEN cl.cod_classe_appl_cf = 'MS'
THEN pcr.val_imp_acc_cli
ELSE 0
END
) scgb_acc_massimali,
SUM
(CASE
WHEN cl.cod_classe_appl_cf = 'RI'
THEN pcr.val_imp_acc_cli
ELSE 0
END
) scgb_acc_rischi_indiretti,
SUM
(CASE
WHEN cl.cod_classe_appl_cf = 'ST'
THEN pcr.val_imp_uti_cli
ELSE 0
END
) scgb_uti_sostituzioni_dt,
SUM
(CASE
WHEN cl.cod_classe_appl_cf = 'MS'
THEN pcr.val_imp_uti_cli
ELSE 0
END
) scgb_uti_massimali_dt,
SUM
(CASE
WHEN cl.cod_classe_appl_cf = 'RI'
THEN pcr.val_imp_uti_cli
ELSE 0
END
) scgb_uti_rischi_indiretti_dt,
SUM
(CASE
WHEN cl.cod_classe_appl_cf = 'ST'
THEN pcr.val_imp_acc_cli
ELSE 0
END
) scgb_acc_sostituzioni_dt,
SUM
(CASE
WHEN cl.cod_classe_appl_cf = 'MS'
THEN pcr.val_imp_acc_cli
ELSE 0
END
) scgb_acc_massimali_dt,
SUM
(CASE
WHEN cl.cod_classe_appl_cf = 'RI'
THEN pcr.val_imp_acc_cli
ELSE 0
END
) scgb_acc_rischi_indiretti_dt,
SUM
(CASE
WHEN cl.cod_classe_appl_cf = 'ST'
THEN pcr.val_imp_uti_leg
ELSE 0
END
) glgb_uti_sostituzioni,
SUM
(CASE
WHEN cl.cod_classe_appl_cf = 'MS'
THEN pcr.val_imp_uti_leg
ELSE 0
END
) glgb_uti_massimali,
SUM
(CASE
WHEN cl.cod_classe_appl_cf = 'RI'
THEN pcr.val_imp_uti_leg
ELSE 0
END
) glgb_uti_rischi_indiretti,
SUM
(CASE
WHEN cl.cod_classe_appl_cf = 'ST'
THEN pcr.val_imp_acc_leg
ELSE 0
END
) glgb_acc_sostituzioni,
SUM
(CASE
WHEN cl.cod_classe_appl_cf = 'MS'
THEN pcr.val_imp_acc_leg
ELSE 0
END
) glgb_acc_massimali,
SUM
(CASE
WHEN cl.cod_classe_appl_cf = 'RI'
THEN pcr.val_imp_acc_leg
ELSE 0
END
) glgb_acc_rischi_indiretti,
SUM
(CASE
WHEN cl.cod_classe_appl_cf = 'ST'
THEN pcr.val_imp_uti_leg
ELSE 0
END
) glgb_uti_sostituzioni_dt,
SUM
(CASE
WHEN cl.cod_classe_appl_cf = 'MS'
THEN pcr.val_imp_uti_leg
ELSE 0
END
) glgb_uti_massimali_dt,
SUM
(CASE
WHEN cl.cod_classe_appl_cf = 'RI'
THEN pcr.val_imp_uti_leg
ELSE 0
END
) glgb_uti_rischi_indiretti_dt,
SUM
(CASE
WHEN cl.cod_classe_appl_cf = 'ST'
THEN pcr.val_imp_acc_leg
ELSE 0
END
) glgb_acc_sostituzioni_dt,
SUM
(CASE
WHEN cl.cod_classe_appl_cf = 'MS'
THEN pcr.val_imp_acc_leg
ELSE 0
END
) glgb_acc_massimali_dt,
SUM
(CASE
WHEN cl.cod_classe_appl_cf = 'RI'
THEN pcr.val_imp_acc_leg
ELSE 0
END
) glgb_acc_rischi_indiretti_dt,

---------------------------------------- OLD
SUM
(CASE
WHEN cl.cod_classe_appl_cf = 'CA'
THEN pcr.val_imp_uti_cli
ELSE 0
END
) scgb_uti_cassa,
SUM
(CASE
WHEN cl.cod_classe_appl_cf = 'FI'
THEN pcr.val_imp_uti_cli
ELSE 0
END
) scgb_uti_firma,
SUM
(CASE
WHEN cl.cod_classe_appl_cf = 'CA'
THEN pcr.val_imp_acc_cli
ELSE 0
END
) scgb_acc_cassa,
SUM
(CASE
WHEN cl.cod_classe_appl_cf = 'FI'
THEN pcr.val_imp_acc_cli
ELSE 0
END
) scgb_acc_firma,
SUM
(CASE
WHEN cl.cod_classe_appl_dett = 'CB'
THEN pcr.val_imp_uti_cli
ELSE 0
END
) scgb_uti_cassa_bt,
SUM
(CASE
WHEN cl.cod_classe_appl_dett = 'CM'
THEN pcr.val_imp_uti_cli
ELSE 0
END
) scgb_uti_cassa_mlt,
SUM
(CASE
WHEN cl.cod_classe_appl_dett = 'SM'
THEN pcr.val_imp_uti_cli
ELSE 0
END
) scgb_uti_smobilizzo,
SUM
(CASE
WHEN cl.cod_classe_appl_dett = 'FI'
THEN pcr.val_imp_uti_cli
ELSE 0
END
) scgb_uti_firma_dt,
SUM
(CASE
WHEN cl.cod_classe_appl_dett = 'CB'
THEN pcr.val_imp_acc_cli
ELSE 0
END
) scgb_acc_cassa_bt,
SUM
(CASE
WHEN cl.cod_classe_appl_dett = 'C'
THEN pcr.val_imp_acc_cli
ELSE 0
END
) scgb_acc_cassa_mlt,
SUM
(CASE
WHEN cl.cod_classe_appl_dett = 'SM'
THEN pcr.val_imp_acc_cli
ELSE 0
END
) scgb_acc_smobilizzo,
SUM
(CASE
WHEN cl.cod_classe_appl_dett = 'FI'
THEN pcr.val_imp_acc_cli
ELSE 0
END
) scgb_acc_firma_dt,
SUM
(CASE
WHEN cl.cod_classe_appl_cf = 'CA'
THEN pcr.val_imp_uti_gre
ELSE 0
END
) gegb_uti_cassa,
SUM
(CASE
WHEN cl.cod_classe_appl_cf = 'FI'
THEN pcr.val_imp_uti_gre
ELSE 0
END
) gegb_uti_firma,
SUM
(CASE
WHEN cl.cod_classe_appl_cf = 'CA'
THEN pcr.val_imp_acc_gre
ELSE 0
END
) gegb_acc_cassa,
SUM
(CASE
WHEN cl.cod_classe_appl_cf = 'FI'
THEN pcr.val_imp_acc_gre
ELSE 0
END
) gegb_acc_firma,
SUM
(CASE
WHEN cl.cod_classe_appl_dett = 'CB'
THEN pcr.val_imp_uti_gre
ELSE 0
END
) gegb_uti_cassa_bt,
SUM
(CASE
WHEN cl.cod_classe_appl_dett = 'CM'
THEN pcr.val_imp_uti_gre
ELSE 0
END
) gegb_uti_cassa_mlt,
SUM
(CASE
WHEN cl.cod_classe_appl_dett = 'SM'
THEN pcr.val_imp_uti_gre
ELSE 0
END
) gegb_uti_smobilizzo,
SUM
(CASE
WHEN cl.cod_classe_appl_dett = 'FI'
THEN pcr.val_imp_uti_gre
ELSE 0
END
) gegb_uti_firma_dt,
SUM
(CASE
WHEN cl.cod_classe_appl_dett = 'CB'
THEN pcr.val_imp_acc_gre
ELSE 0
END
) gegb_acc_cassa_bt,
SUM
(CASE
WHEN cl.cod_classe_appl_dett = 'CM'
THEN pcr.val_imp_acc_gre
ELSE 0
END
) gegb_acc_cassa_mlt,
SUM
(CASE
WHEN cl.cod_classe_appl_dett = 'SM'
THEN pcr.val_imp_acc_gre
ELSE 0
END
) gegb_acc_smobilizzo,
SUM
(CASE
WHEN cl.cod_classe_appl_dett = 'FI'
THEN pcr.val_imp_acc_gre
ELSE 0
END
) gegb_acc_firma_dt,
SUM
(CASE
WHEN cl.cod_classe_appl_cf = 'CA'
THEN pcr.val_imp_uti_leg
ELSE 0
END
) glgb_uti_cassa,
SUM
(CASE
WHEN cl.cod_classe_appl_cf = 'FI'
THEN pcr.val_imp_uti_leg
ELSE 0
END
) glgb_uti_firma,
SUM
(CASE
WHEN cl.cod_classe_appl_cf = 'CA'
THEN pcr.val_imp_acc_leg
ELSE 0
END
) glgb_acc_cassa,
SUM
(CASE
WHEN cl.cod_classe_appl_cf = 'FI'
THEN pcr.val_imp_acc_leg
ELSE 0
END
) glgb_acc_firma,
SUM
(CASE
WHEN cl.cod_classe_appl_dett = 'CB'
THEN pcr.val_imp_uti_leg
ELSE 0
END
) glgb_uti_cassa_bt,
SUM
(CASE
WHEN cl.cod_classe_appl_dett = 'CM'
THEN pcr.val_imp_uti_leg
ELSE 0
END
) glgb_uti_cassa_mlt,
SUM
(CASE
WHEN cl.cod_classe_appl_dett = 'SM'
THEN pcr.val_imp_uti_leg
ELSE 0
END
) glgb_uti_smobilizzo,
SUM
(CASE
WHEN cl.cod_classe_appl_dett = 'FI'
THEN pcr.val_imp_uti_leg
ELSE 0
END
) glgb_uti_firma_dt,
SUM
(CASE
WHEN cl.cod_classe_appl_dett = 'CB'
THEN pcr.val_imp_acc_leg
ELSE 0
END
) glgb_acc_cassa_bt,
SUM
(CASE
WHEN cl.cod_classe_appl_dett = 'CM'
THEN pcr.val_imp_acc_leg
ELSE 0
END
) glgb_acc_cassa_mlt,
SUM
(CASE
WHEN cl.cod_classe_appl_dett = 'SM'
THEN pcr.val_imp_acc_leg
ELSE 0
END
) glgb_acc_smobilizzo,
SUM
(CASE
WHEN cl.cod_classe_appl_dett = 'FI'
THEN pcr.val_imp_acc_leg
ELSE 0
END
) glgb_acc_firma_dt,
MAX (pcr.dta_riferimento) dta_riferimento
FROM t_mcre0_app_pcr_gb pcr,
t_mcre0_app_natura_ftecnica cl
WHERE pcr.cod_forma_tecnica = cl.cod_ftecnica
AND pcr.id_dper =
NVL (p_id_dper,
(SELECT a.idper
FROM v_mcre0_ultima_acquisizione a
WHERE a.cod_file = 'PCR_GB')
)
GROUP BY pcr.cod_sndg, pcr.id_dper) p,
(SELECT DISTINCT cod_sndg, cod_abi_cartolarizzato,
cod_abi_istituto, cod_ndg
FROM t_mcre0_app_file_guida f
WHERE f.cod_sndg != '0000000000000000') xx
WHERE xx.cod_sndg = p.cod_sndg) b
ON ( a.cod_ndg = b.cod_ndg
AND a.cod_abi_cartolarizzato = b.cod_abi_cartolarizzato)
WHEN MATCHED THEN
UPDATE
SET
--v2.2 aggiorno anche sndg
a.cod_sndg = b.cod_sndg,
a.scgb_uti_massimali = b.scgb_uti_massimali,
a.scgb_uti_sostituzioni = b.scgb_uti_sostituzioni,
a.scgb_uti_rischi_indiretti = b.scgb_uti_rischi_indiretti,
a.scgb_uti_massimali_dt = b.scgb_uti_massimali_dt,
a.scgb_uti_sostituzioni_dt = b.scgb_uti_sostituzioni_dt,
a.scgb_uti_rischi_indiretti_dt =
b.scgb_uti_rischi_indiretti_dt,
a.scgb_acc_massimali = b.scgb_acc_massimali,
a.scgb_acc_sostituzioni = b.scgb_acc_sostituzioni,
a.scgb_acc_rischi_indiretti = b.scgb_acc_rischi_indiretti,
a.scgb_acc_massimali_dt = b.scgb_acc_massimali_dt,
a.scgb_acc_sostituzioni_dt = b.scgb_acc_sostituzioni_dt,
a.scgb_acc_rischi_indiretti_dt =
b.scgb_acc_rischi_indiretti_dt,
a.scgb_acc_consegne = b.scgb_acc_consegne,
a.scgb_acc_consegne_dt = b.scgb_acc_consegne_dt,
a.scgb_uti_consegne = b.scgb_uti_consegne,
a.scgb_uti_consegne_dt = b.scgb_uti_consegne_dt,
a.scgb_acc_cassa = b.scgb_acc_cassa,
a.scgb_acc_cassa_bt = b.scgb_acc_cassa_bt,
a.scgb_acc_cassa_mlt = b.scgb_acc_cassa_mlt,
a.scgb_acc_firma = b.scgb_acc_firma,
a.scgb_acc_firma_dt = b.scgb_acc_firma_dt,
a.scgb_acc_smobilizzo = b.scgb_acc_smobilizzo,
a.scgb_tot_gar = b.scgb_tot_gar,
a.scgb_uti_cassa = b.scgb_uti_cassa,
a.scgb_uti_cassa_bt = b.scgb_uti_cassa_bt,
a.scgb_uti_cassa_mlt = b.scgb_uti_cassa_mlt,
a.scgb_uti_firma = b.scgb_uti_firma,
a.scgb_uti_firma_dt = b.scgb_uti_firma_dt,
a.scgb_uti_smobilizzo = b.scgb_uti_smobilizzo,
a.gegb_uti_massimali = b.gegb_uti_massimali,
a.gegb_uti_sostituzioni = b.gegb_uti_sostituzioni,
a.gegb_uti_rischi_indiretti = b.gegb_uti_rischi_indiretti,
a.gegb_uti_massimali_dt = b.gegb_uti_massimali_dt,
a.gegb_uti_sostituzioni_dt = b.gegb_uti_sostituzioni_dt,
a.gegb_uti_rischi_indiretti_dt =
b.gegb_uti_rischi_indiretti_dt,
a.gegb_acc_massimali = b.gegb_acc_massimali,
a.gegb_acc_sostituzioni = b.gegb_acc_sostituzioni,
a.gegb_acc_rischi_indiretti = b.gegb_acc_rischi_indiretti,
a.gegb_acc_massimali_dt = b.gegb_acc_massimali_dt,
a.gegb_acc_sostituzioni_dt = b.gegb_acc_sostituzioni_dt,
a.gegb_acc_rischi_indiretti_dt =
b.gegb_acc_rischi_indiretti_dt,
a.gegb_acc_consegne = b.gegb_acc_consegne,
a.gegb_acc_consegne_dt = b.gegb_acc_consegne_dt,
a.gegb_uti_consegne = b.gegb_uti_consegne,
a.gegb_uti_consegne_dt = b.gegb_uti_consegne_dt,
a.gegb_acc_cassa = b.gegb_acc_cassa,
a.gegb_acc_cassa_bt = b.gegb_acc_cassa_bt,
a.gegb_acc_cassa_mlt = b.gegb_acc_cassa_mlt,
a.gegb_acc_firma = b.gegb_acc_firma,
a.gegb_acc_firma_dt = b.gegb_acc_firma_dt,
a.gegb_acc_smobilizzo = b.gegb_acc_smobilizzo,
a.gegb_tot_gar = b.gegb_tot_gar,
a.gegb_uti_cassa = b.gegb_uti_cassa,
a.gegb_uti_cassa_bt = b.gegb_uti_cassa_bt,
a.gegb_uti_cassa_mlt = b.gegb_uti_cassa_mlt,
a.gegb_uti_firma = b.gegb_uti_firma,
a.gegb_uti_firma_dt = b.gegb_uti_firma_dt,
a.gegb_uti_smobilizzo = b.gegb_uti_smobilizzo,
a.glgb_uti_massimali = b.glgb_uti_massimali,
a.glgb_uti_sostituzioni = b.glgb_uti_sostituzioni,
a.glgb_uti_rischi_indiretti = b.glgb_uti_rischi_indiretti,
a.glgb_uti_massimali_dt = b.glgb_uti_massimali_dt,
a.glgb_uti_sostituzioni_dt = b.glgb_uti_sostituzioni_dt,
a.glgb_uti_rischi_indiretti_dt =
b.glgb_uti_rischi_indiretti_dt,
a.glgb_acc_massimali = b.glgb_acc_massimali,
a.glgb_acc_sostituzioni = b.glgb_acc_sostituzioni,
a.glgb_acc_rischi_indiretti = b.glgb_acc_rischi_indiretti,
a.glgb_acc_massimali_dt = b.glgb_acc_massimali_dt,
a.glgb_acc_sostituzioni_dt = b.glgb_acc_sostituzioni_dt,
a.glgb_acc_rischi_indiretti_dt =
b.glgb_acc_rischi_indiretti_dt,
a.glgb_acc_consegne = b.glgb_acc_consegne,
a.glgb_acc_consegne_dt = b.glgb_acc_consegne_dt,
a.glgb_uti_consegne = b.glgb_uti_consegne,
a.glgb_uti_consegne_dt = b.glgb_uti_consegne_dt,
a.glgb_acc_cassa = b.glgb_acc_cassa,
a.glgb_acc_cassa_bt = b.glgb_acc_cassa_bt,
a.glgb_acc_cassa_mlt = b.glgb_acc_cassa_mlt,
a.glgb_acc_firma = b.glgb_acc_firma,
a.glgb_acc_firma_dt = b.glgb_acc_firma_dt,
a.glgb_acc_smobilizzo = b.glgb_acc_smobilizzo,
a.glgb_tot_gar = b.glgb_tot_gar,
a.glgb_uti_cassa = b.glgb_uti_cassa,
a.glgb_uti_cassa_bt = b.glgb_uti_cassa_bt,
a.glgb_uti_cassa_mlt = b.glgb_uti_cassa_mlt,
a.glgb_uti_firma = b.glgb_uti_firma,
a.glgb_uti_firma_dt = b.glgb_uti_firma_dt,
a.glgb_uti_smobilizzo = b.glgb_uti_smobilizzo,
a.gegb_mau = b.gegb_mau, a.glgb_mau = b.glgb_mau,
a.scgb_mau = b.scgb_mau,
--------------------------- VERIFY
/* a.gb_val_mau = DECODE (b.flg_gruppo_economico,1,b.gegb_mau,--mau GE su GB
decode(b.flg_gruppo_legame, 1,b.glgb_mau, --mau GL su GB
b.scgb_mau)), */
a.gb_val_mau = NULL,
a.scgb_acc_tot = b.scgb_acc_cassa + b.scgb_acc_firma,
a.scgb_uti_tot = b.scgb_uti_cassa + b.scgb_uti_firma,
a.gegb_acc_tot = b.gegb_acc_cassa + b.gegb_acc_firma,
a.gegb_uti_tot = b.gegb_uti_cassa + b.gegb_uti_firma,
a.glgb_acc_tot = b.glgb_acc_cassa + b.glgb_acc_firma,
a.glgb_uti_tot = b.glgb_uti_cassa + b.glgb_uti_firma,
a.id_dper_gb = b.id_dper,
a.gb_dta_riferimento = b.dta_riferimento
WHEN NOT MATCHED THEN
INSERT (cod_abi_istituto, cod_ndg, cod_abi_cartolarizzato,
gegb_uti_sostituzioni, gegb_uti_massimali,
gegb_uti_rischi_indiretti, gegb_uti_sostituzioni_dt,
gegb_uti_massimali_dt, gegb_uti_rischi_indiretti_dt,
gegb_acc_sostituzioni, gegb_acc_massimali,
gegb_acc_rischi_indiretti, gegb_acc_sostituzioni_dt,
gegb_acc_massimali_dt, gegb_acc_rischi_indiretti_dt,
gegb_uti_cassa, gegb_uti_firma, gegb_uti_tot,
gegb_acc_cassa, gegb_acc_firma, gegb_acc_tot,
gegb_uti_cassa_bt, gegb_uti_cassa_mlt,
gegb_uti_smobilizzo, gegb_uti_firma_dt, gegb_acc_cassa_bt,
gegb_acc_cassa_mlt, gegb_acc_smobilizzo,
gegb_acc_firma_dt, gegb_tot_gar, gegb_mau,
--gegb_DTA_RIFERIMENTO ,
gegb_acc_consegne, gegb_acc_consegne_dt,
gegb_uti_consegne, gegb_uti_consegne_dt,
scgb_uti_sostituzioni, scgb_uti_massimali,
scgb_uti_rischi_indiretti, scgb_uti_sostituzioni_dt,
scgb_uti_massimali_dt, scgb_uti_rischi_indiretti_dt,
scgb_acc_sostituzioni, scgb_acc_massimali,
scgb_acc_rischi_indiretti, scgb_acc_sostituzioni_dt,
scgb_acc_massimali_dt, scgb_acc_rischi_indiretti_dt,
scgb_uti_cassa, scgb_uti_firma, scgb_uti_tot,
scgb_acc_cassa, scgb_acc_firma, scgb_acc_tot,
scgb_uti_cassa_bt, scgb_uti_cassa_mlt,
scgb_uti_smobilizzo, scgb_uti_firma_dt, scgb_acc_cassa_bt,
scgb_acc_cassa_mlt, scgb_acc_smobilizzo,
scgb_acc_firma_dt, scgb_tot_gar, scgb_mau,
--scgb_DTA_RIFERIMENTO ,
scgb_acc_consegne, scgb_acc_consegne_dt,
scgb_uti_consegne, scgb_uti_consegne_dt,
glgb_uti_sostituzioni, glgb_uti_massimali,
glgb_uti_rischi_indiretti, glgb_uti_sostituzioni_dt,
glgb_uti_massimali_dt, glgb_uti_rischi_indiretti_dt,
glgb_acc_sostituzioni, glgb_acc_massimali,
glgb_acc_rischi_indiretti, glgb_acc_sostituzioni_dt,
glgb_acc_massimali_dt, glgb_acc_rischi_indiretti_dt,
glgb_uti_cassa, glgb_uti_firma, glgb_uti_tot,
glgb_acc_cassa, glgb_acc_firma, glgb_acc_tot,
glgb_uti_cassa_bt, glgb_uti_cassa_mlt,
glgb_uti_smobilizzo, glgb_uti_firma_dt, glgb_acc_cassa_bt,
glgb_acc_cassa_mlt, glgb_acc_smobilizzo,
glgb_acc_firma_dt, glgb_tot_gar, glgb_mau,
--glgb_DTA_RIFERIMENTO ,
glgb_acc_consegne, glgb_acc_consegne_dt,
glgb_uti_consegne, glgb_uti_consegne_dt, gb_val_mau,
gb_dta_riferimento, cod_sndg, dta_ins, id_dper_gb)
VALUES (b.cod_abi_istituto, b.cod_ndg, b.cod_abi_cartolarizzato,

-----------------------GE
b.gegb_uti_sostituzioni, b.gegb_uti_massimali,
b.gegb_uti_rischi_indiretti, b.gegb_uti_sostituzioni_dt,
b.gegb_uti_massimali_dt, b.gegb_uti_rischi_indiretti_dt,
b.gegb_acc_sostituzioni, b.gegb_acc_massimali,
b.gegb_acc_rischi_indiretti, b.gegb_acc_sostituzioni_dt,
b.gegb_acc_massimali_dt, b.gegb_acc_rischi_indiretti_dt,
b.gegb_uti_cassa, b.gegb_uti_firma, b.gegb_uti_tot,
b.gegb_acc_cassa, b.gegb_acc_firma, b.gegb_acc_tot,
b.gegb_uti_cassa_bt, b.gegb_uti_cassa_mlt,
b.gegb_uti_smobilizzo, b.gegb_uti_firma_dt,
b.gegb_acc_cassa_bt, b.gegb_acc_cassa_mlt,
b.gegb_acc_smobilizzo, b.gegb_acc_firma_dt,
b.gegb_tot_gar, b.gegb_mau, --b.gegb_DTA_RIFERIMENTO ,
b.gegb_acc_consegne,
b.gegb_acc_consegne_dt, b.gegb_uti_consegne,
b.gegb_uti_consegne_dt,
-----------------------SC
b.scgb_uti_sostituzioni,
b.scgb_uti_massimali, b.scgb_uti_rischi_indiretti,
b.scgb_uti_sostituzioni_dt, b.scgb_uti_massimali_dt,
b.scgb_uti_rischi_indiretti_dt, b.scgb_acc_sostituzioni,
b.scgb_acc_massimali, b.scgb_acc_rischi_indiretti,
b.scgb_acc_sostituzioni_dt, b.scgb_acc_massimali_dt,
b.scgb_acc_rischi_indiretti_dt, b.scgb_uti_cassa,
b.scgb_uti_firma, b.scgb_uti_tot, b.scgb_acc_cassa,
b.scgb_acc_firma, b.scgb_acc_tot, b.scgb_uti_cassa_bt,
b.scgb_uti_cassa_mlt, b.scgb_uti_smobilizzo,
b.scgb_uti_firma_dt, b.scgb_acc_cassa_bt,
b.scgb_acc_cassa_mlt, b.scgb_acc_smobilizzo,
b.scgb_acc_firma_dt, b.scgb_tot_gar, b.scgb_mau,
--b.scgb_DTA_RIFERIMENTO ,
b.scgb_acc_consegne, b.scgb_acc_consegne_dt,
b.scgb_uti_consegne, b.scgb_uti_consegne_dt,

-----------------------GL
b.glgb_uti_sostituzioni, b.glgb_uti_massimali,
b.glgb_uti_rischi_indiretti, b.glgb_uti_sostituzioni_dt,
b.glgb_uti_massimali_dt, b.glgb_uti_rischi_indiretti_dt,
b.glgb_acc_sostituzioni, b.glgb_acc_massimali,
b.glgb_acc_rischi_indiretti, b.glgb_acc_sostituzioni_dt,
b.glgb_acc_massimali_dt, b.glgb_acc_rischi_indiretti_dt,
b.glgb_uti_cassa, b.glgb_uti_firma, b.glgb_uti_tot,
b.glgb_acc_cassa, b.glgb_acc_firma, b.glgb_acc_tot,
b.glgb_uti_cassa_bt, b.glgb_uti_cassa_mlt,
b.glgb_uti_smobilizzo, b.glgb_uti_firma_dt,
b.glgb_acc_cassa_bt, b.glgb_acc_cassa_mlt,
b.glgb_acc_smobilizzo, b.glgb_acc_firma_dt,
b.glgb_tot_gar, b.glgb_mau, --b.glgb_DTA_RIFERIMENTO ,
b.glgb_acc_consegne,
b.glgb_acc_consegne_dt, b.glgb_uti_consegne,
b.glgb_uti_consegne_dt,
-----------------------Vari
----------------------------------- VERIFY
NULL, --- MAU
b.dta_riferimento, b.cod_sndg, b.dta_ins, b.id_dper);
COMMIT;
RETURN ok;
EXCEPTION
WHEN OTHERS
THEN
log_caricamenti ('fnc_load_pcr_gb_merge', SQLCODE, SQLERRM);
RETURN ko;
END;
END PKG_MCRE0_PCR;
/


CREATE SYNONYM MCRE_APP.PKG_MCRE0_PCR FOR MCRE_OWN.PKG_MCRE0_PCR;


CREATE SYNONYM MCRE_USR.PKG_MCRE0_PCR FOR MCRE_OWN.PKG_MCRE0_PCR;


GRANT EXECUTE, DEBUG ON MCRE_OWN.PKG_MCRE0_PCR TO MCRE_USR;

