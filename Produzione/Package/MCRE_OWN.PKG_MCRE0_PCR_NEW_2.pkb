CREATE OR REPLACE PACKAGE BODY MCRE_OWN.PKG_MCRE0_PCR_NEW_2 AS
/******************************************************************************
NAME: PKG_MCRE0_PCR
PURPOSE: Gestione alert ed evidenze

REVISIONS:
Ver Date Author Description
--------- ---------- ----------------- ------------------------------------
1.0 07/06/2011 Galli Valeria Created this package.
1.1 13/06/2011 Galli Valeria A mano.
******************************************************************************/

-- Procedura per calcolo MAU 
-- stato esecuzione 1 OK 0 Errori 
FUNCTION fnc_calcolo_mau (p_id_dper t_mcre0_app_pcr_sc_sb.id_dper%type default null) 
RETURN NUMBER IS
 
CURSOR GEC IS
SELECT G.COD_GRUPPO_ECONOMICO, count(distinct gb_val_mau)
FROM NEW_T_MCRE0_APP_PCR P,
T_MCRE0_APP_FILE_GUIDA G
WHERE P.COD_ABI_CARTOLARIZZATO=G.COD_ABI_CARTOLARIZZATO
AND P.COD_NDG=G.COD_NDG
and g.COD_GRUPPO_ECONOMICO is not null
GROUP BY G.COD_GRUPPO_ECONOMICO
HAVING COUNT(DISTINCT GB_VAL_MAU)>1;
 
begin

BEGIN
MERGE INTO NEW_T_MCRE0_APP_PCR A
USING ( SELECT DISTINCT F.COD_ABI_CARTOLARIZZATO, f.COD_NDG, f.FLG_GRUPPO_ECONOMICO, f.FLG_GRUPPO_LEGAME
FROM T_MCRE0_APP_FILE_GUIDA F,
NEW_T_MCRE0_APP_PCR P
WHERE F.COD_ABI_CARTOLARIZZATO = P.COD_ABI_CARTOLARIZZATO
AND F.COD_NDG = P.COD_NDG
and p.gb_val_mau is null
)b
ON (A.COD_ABI_CARTOLARIZZATO = B.COD_ABI_CARTOLARIZZATO
AND A.COD_NDG = B.COD_NDG)
WHEN MATCHED THEN
UPDATE SET
a.gb_val_mau = decode(b.FLG_GRUPPO_ECONOMICO,1,gegb_mau,decode(FLG_GRUPPO_legame,1,glgb_mau,scgb_mau));
COMMIT;
EXCEPTION
WHEN OTHERS THEN
LOG_CARICAMENTI('fnc_calcolo_mau',SQLCODE,'UPDATE MAU PCR - new_t_mcre0_app_pcr - SQLERRM='||SQLERRM);
ROLLBACK;
RETURN KO;
END;
 
begin
FOR GE IN GEC LOOP
BEGIN
MERGE INTO NEW_T_MCRE0_APP_PCR A
USING 
(SELECT p.cod_sndg, p.GEGB_ACC_CASSA, p.GEGB_ACC_FIRMA,p.GEGB_UTI_CASSA,p.GEGB_UTI_FIRMA, p.GEGB_MAU, p.GB_VAL_MAU
FROM T_MCRE0_APP_FILE_GUIDA F,
NEW_T_MCRE0_APP_PCR P
WHERE F.COD_ABI_CARTOLARIZZATO = P.COD_ABI_CARTOLARIZZATO
AND F.COD_NDG = P.COD_NDG
AND F.COD_GRUPPO_ECONOMICO = GE.COD_GRUPPO_ECONOMICO
and p.id_dper_gb = nvl(p_id_dper,(
select idper
FROM V_MCRE0_ULTIMA_ACQUISIZIONE
WHERE COD_FILE = 'PCR_GB' ))
AND ROWNUM = 1) C
ON (A.COD_SNDG = C.COD_SNDG) 
WHEN MATCHED THEN
UPDATE SET
A.GEGB_ACC_CASSA = C.GEGB_ACC_CASSA,
A.GEGB_ACC_FIRMA = C.GEGB_ACC_FIRMA,
A.GEGB_UTI_CASSA = C.GEGB_UTI_CASSA,
A.GEGB_UTI_FIRMA = C.GEGB_UTI_FIRMA, 
A.GEGB_MAU = C.GEGB_MAU,
a.GB_VAL_MAU = c.GB_VAL_MAU;
EXCEPTION 
WHEN OTHERS THEN
LOG_CARICAMENTI('fnc_calcolo_mau',SQLCODE,'GEGB uniforme - new_t_mcre0_app_pcr - ge: '||GE.COD_GRUPPO_ECONOMICO||' - SQLERRM='||SQLERRM);
END;
END LOOP;
commit;
END; 
return ok;
 
EXCEPTION
WHEN OTHERS THEN
LOG_CARICAMENTI('fnc_calcolo_mau',SQLCODE,'generale - new_t_mcre0_app_pcr - SQLERRM='||SQLERRM);
ROLLBACK;
RETURN KO; 
end;

-- Procedura per pulizia storico delle posizioni di file guida senza pcr
-- stato esecuzione 1 OK 0 Errori 
FUNCTION fnc_clean_no_pcr (p_id_dper t_mcre0_app_pcr_sc_sb.id_dper%type default null) 
RETURN NUMBER IS

begin 
begin
update new_t_mcre0_app_pcr p 
SET 
SCsB_ACC_consegne = NULL,
SCsB_ACC_consegne_dt = NULL,
SCsB_uti_consegne = NULL,
SCSB_UTI_CONSEGNE_DT = NULL,
SCSB_ACC_CASSA = NULL,
SCSB_ACC_CASSA_BT = NULL,
SCSB_ACC_CASSA_MLT = NULL,
SCSB_ACC_FIRMA = NULL,
SCSB_ACC_FIRMA_DT = NULL,
SCSB_ACC_MASSIMALI = NULL,
SCSB_ACC_MASSIMALI_DT = NULL,
SCSB_ACC_RISCHI_INDIRETTI = NULL,
SCSB_ACC_RISCHI_INDIRETTI_DT = NULL,
SCSB_ACC_SMOBILIZZO = NULL,
SCSB_ACC_SOSTITUZIONI = NULL,
SCSB_ACC_SOSTITUZIONI_DT = NULL,
SCSB_ACC_TOT = NULL,
SCSB_DTA_RIFERIMENTO = NULL,
SCSB_TOT_GAR = NULL,
SCSB_UTI_CASSA = NULL,
SCSB_UTI_CASSA_BT = NULL,
SCSB_UTI_CASSA_MLT = NULL,
SCSB_UTI_FIRMA = NULL,
SCSB_UTI_FIRMA_DT = NULL,
SCSB_UTI_MASSIMALI = NULL,
SCSB_UTI_MASSIMALI_DT = NULL,
SCSB_UTI_RISCHI_INDIRETTI = NULL,
SCSB_UTI_RISCHI_INDIRETTI_DT = NULL,
SCSB_UTI_SMOBILIZZO = NULL,
SCSB_UTI_SOSTITUZIONI = NULL,
SCSB_UTI_SOSTITUZIONI_DT = NULL,
SCSB_UTI_TOT = NULL
where id_dper_scsb < nvl(p_id_dper,(
select idper
FROM V_MCRE0_ULTIMA_ACQUISIZIONE
WHERE COD_FILE = 'FILE_GUIDA' ))
AND id_dper_scsb IN (
select id_dper from (
SELECT DISTINCT ID_DPER
FROM T_MCRE0_APP_PCR_SC_SB
where id_dper <= nvl(p_id_dper,id_dper)
ORDER BY ID_DPER DESC
)where rownum<3)
and exists ( 
select distinct 1
from t_mcre0_app_file_guida f
where f.cod_abi_cartolarizzato = p.cod_abi_cartolarizzato
and f.cod_ndg = p.cod_ndg
and f.id_dper = (
select idper
from V_MCRE0_ULTIMA_ACQUISIZIONE
where COD_FILE = 'FILE_GUIDA' ) ) ;
-- and SCSB_DTA_RIFERIMENTO is not null;
commit;
exception
when others then
LOG_CARICAMENTI('fnc_clean_no_pcr',SQLCODE,'UPDATE NO PCR - new_t_mcre0_app_pcr - SQLERRM='||SQLERRM);
rollback;
return ko;
END; 
 
begin
update new_t_mcre0_app_pcr p 
SET 
scgb_ACC_consegne = NULL,
scgb_ACC_consegne_dt = NULL,
scgb_uti_consegne = NULL,
scgb_UTI_CONSEGNE_DT = NULL,
scgb_ACC_CASSA = NULL,
scgb_ACC_CASSA_BT = NULL,
scgb_ACC_CASSA_MLT = NULL,
scgb_ACC_FIRMA = NULL,
scgb_ACC_FIRMA_DT = NULL,
scgb_ACC_MASSIMALI = NULL,
scgb_ACC_MASSIMALI_DT = NULL,
scgb_ACC_RISCHI_INDIRETTI = NULL,
scgb_ACC_RISCHI_INDIRETTI_DT = NULL,
scgb_ACC_SMOBILIZZO = NULL,
scgb_ACC_SOSTITUZIONI = NULL,
scgb_ACC_SOSTITUZIONI_DT = NULL,
scgb_ACC_TOT = NULL,
scgb_TOT_GAR = NULL,
scgb_UTI_CASSA = NULL,
scgb_UTI_CASSA_BT = NULL,
scgb_UTI_CASSA_MLT = NULL,
scgb_UTI_FIRMA = NULL,
scgb_UTI_FIRMA_DT = NULL,
scgb_UTI_MASSIMALI = NULL,
scgb_UTI_MASSIMALI_DT = NULL,
scgb_UTI_RISCHI_INDIRETTI = NULL,
scgb_UTI_RISCHI_INDIRETTI_DT = NULL,
scgb_UTI_SMOBILIZZO = NULL,
scgb_UTI_SOSTITUZIONI = NULL,
SCGB_UTI_SOSTITUZIONI_DT = NULL,
SCGB_UTI_TOT = NULL,
gegb_ACC_consegne = NULL,
gegb_ACC_consegne_dt = NULL,
gegb_uti_consegne = NULL,
gegb_UTI_CONSEGNE_DT = NULL,
gegb_ACC_CASSA = NULL,
gegb_ACC_CASSA_BT = NULL,
gegb_ACC_CASSA_MLT = NULL,
gegb_ACC_FIRMA = NULL,
gegb_ACC_FIRMA_DT = NULL,
gegb_ACC_MASSIMALI = NULL,
gegb_ACC_MASSIMALI_DT = NULL,
gegb_ACC_RISCHI_INDIRETTI = NULL,
gegb_ACC_RISCHI_INDIRETTI_DT = NULL,
gegb_ACC_SMOBILIZZO = NULL,
gegb_ACC_SOSTITUZIONI = NULL,
gegb_ACC_SOSTITUZIONI_DT = NULL,
gegb_ACC_TOT = NULL,
gegb_TOT_GAR = NULL,
gegb_UTI_CASSA = NULL,
gegb_UTI_CASSA_BT = NULL,
gegb_UTI_CASSA_MLT = NULL,
gegb_UTI_FIRMA = NULL,
gegb_UTI_FIRMA_DT = NULL,
gegb_UTI_MASSIMALI = NULL,
gegb_UTI_MASSIMALI_DT = NULL,
gegb_UTI_RISCHI_INDIRETTI = NULL,
gegb_UTI_RISCHI_INDIRETTI_DT = NULL,
gegb_UTI_SMOBILIZZO = NULL,
gegb_UTI_SOSTITUZIONI = NULL,
gegb_UTI_SOSTITUZIONI_DT = NULL,
gegb_UTI_TOT = NULL,
glgb_ACC_consegne = NULL,
glgb_ACC_consegne_dt = NULL,
glgb_uti_consegne = NULL,
glgb_UTI_CONSEGNE_DT = NULL,
glgb_ACC_CASSA = NULL,
glgb_ACC_CASSA_BT = NULL,
glgb_ACC_CASSA_MLT = NULL,
glgb_ACC_FIRMA = NULL,
glgb_ACC_FIRMA_DT = NULL,
glgb_ACC_MASSIMALI = NULL,
glgb_ACC_MASSIMALI_DT = NULL,
glgb_ACC_RISCHI_INDIRETTI = NULL,
glgb_ACC_RISCHI_INDIRETTI_DT = NULL,
glgb_ACC_SMOBILIZZO = NULL,
glgb_ACC_SOSTITUZIONI = NULL,
glgb_ACC_SOSTITUZIONI_DT = NULL,
glgb_ACC_TOT = NULL,
glgb_TOT_GAR = NULL,
glgb_UTI_CASSA = NULL,
glgb_UTI_CASSA_BT = NULL,
glgb_UTI_CASSA_MLT = NULL,
glgb_UTI_FIRMA = NULL,
glgb_UTI_FIRMA_DT = NULL,
glgb_UTI_MASSIMALI = NULL,
glgb_UTI_MASSIMALI_DT = NULL,
glgb_UTI_RISCHI_INDIRETTI = NULL,
glgb_UTI_RISCHI_INDIRETTI_DT = NULL,
glgb_UTI_SMOBILIZZO = NULL,
glgb_UTI_SOSTITUZIONI = NULL,
GLGB_UTI_SOSTITUZIONI_DT = NULL,
GLGB_UTI_TOT = NULL,
GB_DTA_RIFERIMENTO = NULL,
GEGB_MAU = NULL,
GLGB_MAU = NULL,
SCGB_MAU = NULL,
gb_val_mau = null
where id_dper_gb < nvl(p_id_dper,(
select idper
FROM V_MCRE0_ULTIMA_ACQUISIZIONE
WHERE COD_FILE = 'FILE_GUIDA' ))
AND id_dper_gb IN (
select id_dper from (
SELECT DISTINCT ID_DPER
FROM T_MCRE0_APP_PCR_gB
where id_dper <= nvl(p_id_dper,id_dper)
ORDER BY ID_DPER DESC
)where rownum<3)
and exists ( 
select distinct 1
FROM T_MCRE0_APP_FILE_GUIDA F
where f.cod_abi_cartolarizzato = p.cod_abi_cartolarizzato
and f.cod_ndg = p.cod_ndg
and f.id_dper = (
select idper
from V_MCRE0_ULTIMA_ACQUISIZIONE
where COD_FILE = 'FILE_GUIDA' ) ) ;
-- and SCSB_DTA_RIFERIMENTO is not null;
commit;
exception
when others then
LOG_CARICAMENTI('fnc_clean_no_pcr',SQLCODE,'UPDATE NO PCR - new_t_mcre0_app_pcr - SQLERRM='||SQLERRM);
rollback;
RETURN KO;
END; 
 
begin
update new_t_mcre0_app_pcr p 
set 
geGB_ACC_consegne = NULL,
geGB_ACC_consegne_dt = NULL,
geGB_uti_consegne = NULL,
geGB_uti_consegne_dt = NULL,
gesB_ACC_consegne = NULL,
gesB_ACC_consegne_dt = NULL,
gesB_uti_consegne = NULL,
gesB_uti_consegne_dt = NULL,
GEGB_ACC_CASSA = NULL, 
GEGB_ACC_CASSA_BT = NULL, 
GEGB_ACC_CASSA_MLT = NULL, 
GEGB_ACC_FIRMA = NULL, 
GEGB_ACC_FIRMA_DT = NULL, 
GEGB_ACC_MASSIMALI = NULL, 
GEGB_ACC_MASSIMALI_DT = NULL, 
GEGB_ACC_RISCHI_INDIRETTI = NULL, 
GEGB_ACC_RISCHI_INDIRETTI_DT = NULL, 
GEGB_ACC_SMOBILIZZO = NULL, 
GEGB_ACC_SOSTITUZIONI = NULL, 
GEGB_ACC_SOSTITUZIONI_DT = NULL, 
GEGB_ACC_TOT = NULL, 
GEGB_MAU = NULL, 
GEGB_TOT_GAR = NULL, 
GEGB_UTI_CASSA = NULL, 
GEGB_UTI_CASSA_BT = NULL, 
GEGB_UTI_CASSA_MLT = NULL, 
GEGB_UTI_FIRMA = NULL, 
GEGB_UTI_FIRMA_DT = NULL, 
GEGB_UTI_MASSIMALI = NULL, 
GEGB_UTI_MASSIMALI_DT = NULL, 
GEGB_UTI_RISCHI_INDIRETTI = NULL, 
GEGB_UTI_RISCHI_INDIRETTI_DT = NULL, 
GEGB_UTI_SMOBILIZZO = NULL, 
GEGB_UTI_SOSTITUZIONI = NULL, 
GEGB_UTI_SOSTITUZIONI_DT = NULL, 
GEGB_UTI_TOT = NULL, 
GESB_ACC_CASSA = NULL, 
GESB_ACC_CASSA_BT = NULL, 
GESB_ACC_CASSA_MLT = NULL, 
GESB_ACC_FIRMA = NULL, 
GESB_ACC_FIRMA_DT = NULL, 
GESB_ACC_MASSIMALI = NULL, 
GESB_ACC_MASSIMALI_DT = NULL, 
GESB_ACC_RISCHI_INDIRETTI = NULL, 
GESB_ACC_RISCHI_INDIRETTI_DT = NULL, 
GESB_ACC_SMOBILIZZO = NULL, 
GESB_ACC_SOSTITUZIONI = NULL, 
GESB_ACC_SOSTITUZIONI_DT = NULL, 
GESB_ACC_TOT = NULL, 
GESB_DTA_RIFERIMENTO = NULL, 
GESB_TOT_GAR = NULL, 
GESB_UTI_CASSA = NULL, 
GESB_UTI_CASSA_BT = NULL, 
GESB_UTI_CASSA_MLT = NULL, 
GESB_UTI_FIRMA = NULL, 
GESB_UTI_FIRMA_DT = NULL, 
GESB_UTI_MASSIMALI = NULL, 
GESB_UTI_MASSIMALI_DT = NULL, 
GESB_UTI_RISCHI_INDIRETTI = NULL, 
GESB_UTI_RISCHI_INDIRETTI_DT = NULL, 
GESB_UTI_SMOBILIZZO = NULL, 
GESB_UTI_SOSTITUZIONI = NULL, 
GESB_UTI_SOSTITUZIONI_DT = NULL, 
GESB_UTI_TOT = NULL, 
DTA_UPD = SYSDATE,
FLG_CONDIVISO = P.FLG_CONDIVISO,
FLG_GRUPPO_ECONOMICO = NULL,
FLG_GRUPPO_LEGAME = P.FLG_GRUPPO_LEGAME,
GB_VAL_MAU = null
WHERE (
not exists (
select distinct 1
from t_mcre0_app_gruppo_economico e
WHERE E.COD_SNDG = P.COD_SNDG
)
or exists (
SELECT DISTINCT 1 FROM T_MCRE0_APP_FILE_GUIDA F
WHERE P.COD_ABI_CARTOLARIZZATO = F.COD_ABI_CARTOLARIZZATO
AND P.COD_NDG = F.COD_NDG
AND F.FLG_GRUPPO_ECONOMICO = 0
)
)
and ID_DPER_GB IN (
select id_dper from (
SELECT DISTINCT ID_DPER
FROM T_MCRE0_APP_PCR_GB
where id_dper <= nvl(p_id_dper,id_dper)
ORDER BY ID_DPER DESC
)WHERE ROWNUM<3 );
commit;
exception
WHEN OTHERS THEN
LOG_CARICAMENTI('fnc_clean_no_pcr',SQLCODE,'UPDATE USCITI dal gruppo economico - new_t_mcre0_app_pcr - SQLERRM='||SQLERRM);
rollback;
RETURN KO;
end;
 
BEGIN
update new_t_mcre0_app_pcr p 
set 
glGB_ACC_consegne = NULL,
glGB_ACC_consegne_dt = NULL,
glGB_uti_consegne = NULL,
glGB_uti_consegne_dt = NULL,
GLGB_ACC_CASSA = NULL, 
GLGB_ACC_CASSA_BT = NULL, 
GLGB_ACC_CASSA_MLT = NULL, 
GLGB_ACC_FIRMA = NULL, 
GLGB_ACC_FIRMA_DT = NULL, 
GLGB_ACC_MASSIMALI = NULL, 
GLGB_ACC_MASSIMALI_DT = NULL, 
GLGB_ACC_RISCHI_INDIRETTI = NULL, 
GLGB_ACC_RISCHI_INDIRETTI_DT = NULL, 
GLGB_ACC_SMOBILIZZO = NULL, 
GLGB_ACC_SOSTITUZIONI = NULL, 
GLGB_ACC_SOSTITUZIONI_DT = NULL, 
GLGB_ACC_TOT = NULL, 
GLGB_MAU = NULL, 
GLGB_TOT_GAR = NULL, 
GLGB_UTI_CASSA = NULL, 
GLGB_UTI_CASSA_BT = NULL, 
GLGB_UTI_CASSA_MLT = NULL, 
GLGB_UTI_FIRMA = NULL, 
GLGB_UTI_FIRMA_DT = NULL, 
GLGB_UTI_MASSIMALI = NULL, 
GLGB_UTI_MASSIMALI_DT = NULL, 
GLGB_UTI_RISCHI_INDIRETTI = NULL, 
GLGB_UTI_RISCHI_INDIRETTI_DT = NULL, 
GLGB_UTI_SMOBILIZZO = NULL, 
GLGB_UTI_SOSTITUZIONI = NULL, 
GLGB_UTI_SOSTITUZIONI_DT = NULL, 
GLGB_UTI_TOT = NULL, 
DTA_UPD = SYSDATE,
FLG_CONDIVISO = P.FLG_CONDIVISO,
FLG_GRUPPO_ECONOMICO = P.FLG_GRUPPO_ECONOMICO,
FLG_GRUPPO_LEGAME = NULL,
GB_VAL_MAU = null
WHERE (
not exists (
SELECT DISTINCT 1
from t_mcre0_app_gruppo_legame e
WHERE E.COD_SNDG = P.COD_SNDG
)
or exists (
SELECT DISTINCT 1 FROM T_MCRE0_APP_FILE_GUIDA F
WHERE P.COD_ABI_CARTOLARIZZATO = F.COD_ABI_CARTOLARIZZATO
AND P.COD_NDG = F.COD_NDG
AND F.FLG_GRUPPO_legame = 0
)
)
and ID_DPER_GB IN (
select id_dper from (
SELECT DISTINCT ID_DPER
FROM T_MCRE0_APP_PCR_GB
where id_dper <= nvl(p_id_dper,id_dper)
ORDER BY ID_DPER DESC
)where rownum<3 );
commit;
exception
WHEN OTHERS THEN
LOG_CARICAMENTI('fnc_clean_no_pcr',SQLCODE,'UPDATE USCITI da legame - new_t_mcre0_app_pcr - SQLERRM='||SQLERRM);
rollback;
RETURN KO;
end; 
 
begin
delete from new_t_mcre0_app_pcr
where geGB_ACC_consegne is NULL and
geGB_ACC_consegne_dt is NULL and
geGB_uti_consegne is NULL and
geGB_uti_consegne_dt is NULL and
gesB_ACC_consegne is NULL and
gesB_ACC_consegne_dt is NULL and
gesB_uti_consegne is NULL and
gesB_uti_consegne_dt is NULL and
glGB_ACC_consegne is NULL and
glGB_ACC_consegne_dt is NULL and
glGB_uti_consegne is NULL and
glGB_uti_consegne_dt is NULL and
scGB_uti_consegne_dt is NULL and
scGB_uti_consegne is NULL and
scGB_acc_consegne_dt is NULL and
scGB_acc_consegne is NULL and
scsB_uti_consegne_dt is NULL and
scsB_uti_consegne is NULL and
scsB_acc_consegne_dt is NULL and
scsB_acc_consegne is NULL and
GEGB_ACC_CASSA IS NULL AND 
GEGB_ACC_CASSA_BT IS NULL AND 
GEGB_ACC_CASSA_MLT IS NULL AND 
GEGB_ACC_FIRMA IS NULL AND 
GEGB_ACC_FIRMA_DT IS NULL AND 
GEGB_ACC_MASSIMALI IS NULL AND 
GEGB_ACC_MASSIMALI_DT IS NULL AND 
GEGB_ACC_RISCHI_INDIRETTI IS NULL AND 
GEGB_ACC_RISCHI_INDIRETTI_DT IS NULL AND 
GEGB_ACC_SMOBILIZZO IS NULL AND 
GEGB_ACC_SOSTITUZIONI IS NULL AND 
GEGB_ACC_SOSTITUZIONI_DT IS NULL AND 
GEGB_ACC_TOT IS NULL AND 
GEGB_UTI_CASSA IS NULL AND 
GEGB_UTI_CASSA_BT IS NULL AND 
GEGB_UTI_CASSA_MLT IS NULL AND 
GEGB_UTI_FIRMA IS NULL AND 
GEGB_UTI_FIRMA_DT IS NULL AND 
GEGB_UTI_MASSIMALI IS NULL AND 
GEGB_UTI_MASSIMALI_DT IS NULL AND 
GEGB_UTI_RISCHI_INDIRETTI IS NULL AND 
GEGB_UTI_RISCHI_INDIRETTI_DT IS NULL AND 
GEGB_UTI_SMOBILIZZO IS NULL AND 
GEGB_UTI_SOSTITUZIONI IS NULL AND 
GEGB_UTI_SOSTITUZIONI_DT IS NULL AND 
GEGB_UTI_TOT IS NULL AND 
GESB_ACC_CASSA IS NULL AND 
GESB_ACC_CASSA_BT IS NULL AND 
GESB_ACC_CASSA_MLT IS NULL AND 
GESB_ACC_FIRMA IS NULL AND 
GESB_ACC_FIRMA_DT IS NULL AND 
GESB_ACC_MASSIMALI IS NULL AND 
GESB_ACC_MASSIMALI_DT IS NULL AND 
GESB_ACC_RISCHI_INDIRETTI IS NULL AND 
GESB_ACC_RISCHI_INDIRETTI_DT IS NULL AND 
GESB_ACC_SMOBILIZZO IS NULL AND 
GESB_ACC_SOSTITUZIONI IS NULL AND 
GESB_ACC_SOSTITUZIONI_DT IS NULL AND 
GESB_ACC_TOT IS NULL AND 
GESB_UTI_CASSA IS NULL AND 
GESB_UTI_CASSA_BT IS NULL AND 
GESB_UTI_CASSA_MLT IS NULL AND 
GESB_UTI_FIRMA IS NULL AND 
GESB_UTI_FIRMA_DT IS NULL AND 
GESB_UTI_MASSIMALI IS NULL AND 
GESB_UTI_MASSIMALI_DT IS NULL AND 
GESB_UTI_RISCHI_INDIRETTI IS NULL AND 
GESB_UTI_RISCHI_INDIRETTI_DT IS NULL AND 
GESB_UTI_SMOBILIZZO IS NULL AND 
GESB_UTI_SOSTITUZIONI IS NULL AND 
GESB_UTI_SOSTITUZIONI_DT IS NULL AND 
GESB_UTI_TOT IS NULL AND 
GLGB_ACC_CASSA IS NULL AND 
GLGB_ACC_CASSA_BT IS NULL AND 
GLGB_ACC_CASSA_MLT IS NULL AND 
GLGB_ACC_FIRMA IS NULL AND 
GLGB_ACC_FIRMA_DT IS NULL AND 
GLGB_ACC_MASSIMALI IS NULL AND 
GLGB_ACC_MASSIMALI_DT IS NULL AND 
GLGB_ACC_RISCHI_INDIRETTI IS NULL AND 
GLGB_ACC_RISCHI_INDIRETTI_DT IS NULL AND 
GLGB_ACC_SMOBILIZZO IS NULL AND 
GLGB_ACC_SOSTITUZIONI IS NULL AND 
GLGB_ACC_SOSTITUZIONI_DT IS NULL AND 
GLGB_ACC_TOT IS NULL AND 
GLGB_UTI_CASSA IS NULL AND 
GLGB_UTI_CASSA_BT IS NULL AND 
GLGB_UTI_CASSA_MLT IS NULL AND 
GLGB_UTI_FIRMA IS NULL AND 
GLGB_UTI_FIRMA_DT IS NULL AND 
GLGB_UTI_MASSIMALI IS NULL AND 
GLGB_UTI_MASSIMALI_DT IS NULL AND 
GLGB_UTI_RISCHI_INDIRETTI IS NULL AND 
GLGB_UTI_RISCHI_INDIRETTI_DT IS NULL AND 
GLGB_UTI_SMOBILIZZO IS NULL AND 
GLGB_UTI_SOSTITUZIONI IS NULL AND 
GLGB_UTI_SOSTITUZIONI_DT IS NULL AND 
GLGB_UTI_TOT IS NULL AND 
SCGB_ACC_CASSA IS NULL AND 
SCGB_ACC_CASSA_BT IS NULL AND 
SCGB_ACC_CASSA_MLT IS NULL AND 
SCGB_ACC_FIRMA IS NULL AND 
SCGB_ACC_FIRMA_DT IS NULL AND 
SCGB_ACC_MASSIMALI IS NULL AND 
SCGB_ACC_MASSIMALI_DT IS NULL AND 
SCGB_ACC_RISCHI_INDIRETTI IS NULL AND 
SCGB_ACC_RISCHI_INDIRETTI_DT IS NULL AND 
SCGB_ACC_SMOBILIZZO IS NULL AND 
SCGB_ACC_SOSTITUZIONI IS NULL AND 
SCGB_ACC_SOSTITUZIONI_DT IS NULL AND 
SCGB_ACC_TOT IS NULL AND 
SCGB_UTI_CASSA IS NULL AND 
SCGB_UTI_CASSA_BT IS NULL AND 
SCGB_UTI_CASSA_MLT IS NULL AND 
SCGB_UTI_FIRMA IS NULL AND 
SCGB_UTI_FIRMA_DT IS NULL AND 
SCGB_UTI_MASSIMALI IS NULL AND 
SCGB_UTI_MASSIMALI_DT IS NULL AND 
SCGB_UTI_RISCHI_INDIRETTI IS NULL AND 
SCGB_UTI_RISCHI_INDIRETTI_DT IS NULL AND 
SCGB_UTI_SMOBILIZZO IS NULL AND 
SCGB_UTI_SOSTITUZIONI IS NULL AND 
SCGB_UTI_SOSTITUZIONI_DT IS NULL AND 
SCGB_UTI_TOT IS NULL AND 
SCSB_ACC_CASSA IS NULL AND 
SCSB_ACC_CASSA_BT IS NULL AND 
SCSB_ACC_CASSA_MLT IS NULL AND 
SCSB_ACC_FIRMA IS NULL AND 
SCSB_ACC_FIRMA_DT IS NULL AND 
SCSB_ACC_MASSIMALI IS NULL AND 
SCSB_ACC_MASSIMALI_DT IS NULL AND 
SCSB_ACC_RISCHI_INDIRETTI IS NULL AND 
SCSB_ACC_RISCHI_INDIRETTI_DT IS NULL AND 
SCSB_ACC_SMOBILIZZO IS NULL AND 
SCSB_ACC_SOSTITUZIONI IS NULL AND 
SCSB_ACC_SOSTITUZIONI_DT IS NULL AND 
SCSB_ACC_TOT IS NULL AND 
SCSB_UTI_CASSA IS NULL AND 
SCSB_UTI_CASSA_BT IS NULL AND 
SCSB_UTI_CASSA_MLT IS NULL AND 
SCSB_UTI_FIRMA IS NULL AND 
SCSB_UTI_FIRMA_DT IS NULL AND 
SCSB_UTI_MASSIMALI IS NULL AND 
SCSB_UTI_MASSIMALI_DT IS NULL AND 
SCSB_UTI_RISCHI_INDIRETTI IS NULL AND 
SCSB_UTI_RISCHI_INDIRETTI_DT IS NULL AND 
SCSB_UTI_SMOBILIZZO IS NULL AND 
SCSB_UTI_SOSTITUZIONI IS NULL AND 
SCSB_UTI_SOSTITUZIONI_DT IS NULL AND 
SCSB_UTI_TOT IS NULL;
commit;
exception
when others then
LOG_CARICAMENTI('fnc_clean_no_pcr',SQLCODE,'DELETE NO PCR - new_t_mcre0_app_pcr - SQLERRM='||SQLERRM);
rollback;
end;
 
return ok;
exception
when others then
log_caricamenti('fnc_clean_no_pcr',SQLCODE,'CLEAN PCR - new_t_mcre0_app_pcr - SQLERRM='||SQLERRM);
return ko;
end;

-- Procedura per calcolo pcr
-- stato esecuzione 1 OK 0 Errori 
FUNCTION fnc_load_pcr (p_id_dper t_mcre0_app_pcr_sc_sb.id_dper%type default null) 
RETURN NUMBER IS

val_ok integer; 

begin
 
LOG_CARICAMENTI('fnc_load_pcr - SCSB m',-1,'start..');
val_ok := fnc_load_pcr_scsb_merge(p_id_dper);
if(val_ok=ko)then return ko; end if;
LOG_CARICAMENTI('fnc_load_pcr - GESB m',-1,'start..');
val_ok := fnc_load_pcr_gesb_merge(p_id_dper);
if(val_ok=ko)then return ko; end if;
LOG_CARICAMENTI('fnc_load_pcr - GB m',-1,'start..');
val_ok := fnc_load_pcr_gb_merge(p_id_dper);
if(val_ok=ko)then return ko; end if;
LOG_CARICAMENTI('fnc_load_pcr - DELETE ',-1,'start..');
val_ok := fnc_clean_no_pcr(p_id_dper);
IF(VAL_OK=KO)THEN RETURN KO; END IF;
LOG_CARICAMENTI('fnc_load_pcr - MAU ',-1,'start..');
VAL_OK := FNC_CALCOLO_MAU(p_id_dper);
IF(VAL_OK=KO)THEN RETURN KO; END IF;
 
return ok;
EXCEPTION
WHEN OTHERS THEN
log_caricamenti('fnc_load_pcr',SQLCODE,'GENERALE - SQLERRM='||SQLERRM);
return ko;
end; 

-- Procedura per calcolo pcr scsb usando la MERGE
-- stato esecuzione 1 OK 0 Errori 
FUNCTION fnc_load_pcr_scsb_merge(p_id_dper t_mcre0_app_pcr_sc_sb.id_dper%type default null) RETURN NUMBER IS

begin

MERGE INTO mcre_own.new_t_mcre0_app_pcr a
USING ( SELECT
XX.COD_ABI_ISTITUTO,XX.COD_ABI_CARTOLARIZZATO,
XX.COD_NDG,
val_tot_ACC_CONSEGNE SCSB_ACC_CONSEGNE,
val_tot_ACC_CONSEGNE_DT SCSB_ACC_CONSEGNE_DT,
val_tot_UTI_CONSEGNE SCSB_UTI_CONSEGNE,
val_tot_UTI_CONSEGNE_DT SCSB_UTI_CONSEGNE_DT,
val_tot_uti_MASSIMALI scsb_uti_massimali,
val_tot_uti_sostituzioni scsb_uti_sostituzioni,
val_tot_uti_rischi_indiretti scsb_uti_rischi_indiretti,
val_tot_dett_uti_MASSIMALI scsb_uti_massimali_dt,
val_tot_dett_uti_sostituzioni scsb_uti_sostituzioni_dt,
val_tot_dett_uti_rischi_ind scsb_uti_rischi_indiretti_dt,
val_tot_acc_MASSIMALI scsb_acc_massimali,
val_tot_acc_sostituzioni scsb_acc_sostituzioni,
val_tot_acc_rischi_indiretti scsb_acc_rischi_indiretti,
val_tot_dett_acc_MASSIMALI scsb_acc_massimali_dt,
val_tot_dett_acc_sostituzioni scsb_acc_sostituzioni_dt,
val_tot_dett_acc_rischi_ind scsb_acc_rischi_indiretti_dt,
val_tot_uti_cassa scsb_uti_cassa,
val_tot_uti_firma scsb_uti_firma,
(val_tot_uti_cassa+val_tot_uti_firma) scsb_uti_tot,
val_tot_acc_cassa scsb_acc_cassa,
val_tot_acc_firma scsb_acc_firma,
(val_tot_acc_cassa+val_tot_acc_firma) scsb_acc_tot,
val_tot_dett_uti_cassa_bt scsb_uti_cassa_bt,
val_tot_dett_uti_cassa_mlt scsb_uti_cassa_mlt,
val_tot_dett_uti_smobilizzo scsb_uti_smobilizzo,
val_tot_dett_uti_firma scsb_uti_firma_dt,
val_tot_dett_acc_cassa_bt scsb_acc_cassa_bt,
val_tot_dett_acc_cassa_mlt scsb_acc_cassa_mlt,
val_tot_dett_acc_smobilizzo scsb_acc_smobilizzo,
val_tot_dett_acc_firma scsb_acc_firma_dt,
val_tot_gar scsb_tot_gar,
dta_riferimento scsb_dta_riferimento,
xx.cod_sndg,
sysdate dta_ins, id_dper, sysdate dta_upd
FROM (SELECT cod_abi_istituto, cod_ndg, id_dper,
SUM
(CASE
WHEN cl.cod_classe_appl_cf = 'CO'
THEN pcr.val_imp_uti_cli
ELSE 0
END
) val_tot_uti_CONSEGNE,
SUM
(CASE
WHEN cl.cod_classe_appl_cf = 'CO'
THEN pcr.val_imp_uti_cli
ELSE 0
END
) val_tot_uti_CONSEGNE_DT,
SUM
(CASE
WHEN cl.cod_classe_appl_cf = 'CO'
THEN pcr.val_imp_ACC_cli
ELSE 0
END
) val_tot_ACC_CONSEGNE,
SUM
(CASE
WHEN cl.cod_classe_appl_cf = 'CO'
THEN pcr.val_imp_ACC_cli
ELSE 0
END
) val_tot_ACC_CONSEGNE_DT,
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
max(pcr.dta_riferimento)dta_riferimento
FROM t_mcre0_app_pcr_sc_sb pcr,
T_MCRE0_APP_NATURA_FTECNICA CL
 
WHERE PCR.COD_FORMA_TECNICA = CL.COD_FTECNICA
and pcr.id_dper =nvl(p_id_dper,(SELECT a.idper
FROM V_MCRE0_ULTIMA_ACQUISIZIONE A
WHERE A.COD_FILE = 'PCR_SC_SB') ) 
GROUP BY PCR.COD_ABI_ISTITUTO, PCR.COD_NDG, PCR.ID_DPER) S ,
(select distinct cod_sndg, COD_ABI_CARTOLARIZZATO, COD_ABI_ISTITUTO,COD_NDG
from t_mcre0_app_file_guida f
where 
f.id_dper = (SELECT a.idper
FROM v_mcre0_ultima_acquisizione a
WHERE A.COD_FILE = 'FILE_GUIDA')) XX
WHERE XX.COD_ABI_ISTITUTO = S.COD_ABI_ISTITUTO
and xx.COD_NDG = S.cod_ndg
) b
ON (a.COD_ABI_CARTOLARIZZATO = b.COD_ABI_CARTOLARIZZATO
and a.COD_NDG = b.cod_ndg)
WHEN MATCHED THEN
UPDATE SET a.SCSB_UTI_CASSA = b.SCSB_UTI_CASSA ,
a.SCSB_UTI_FIRMA = b.SCSB_UTI_FIRMA ,
a.SCSB_UTI_TOT = b.SCSB_UTI_TOT ,
a.SCSB_ACC_CASSA = b.SCSB_ACC_CASSA ,
a.SCSB_ACC_FIRMA = b.SCSB_ACC_FIRMA ,
a.SCSB_ACC_TOT = b.SCSB_ACC_TOT ,
a.SCSB_UTI_CASSA_BT = b.SCSB_UTI_CASSA_BT ,
a.SCSB_UTI_CASSA_MLT = b.SCSB_UTI_CASSA_MLT ,
a.SCSB_UTI_SMOBILIZZO = b.SCSB_UTI_SMOBILIZZO ,
a.SCSB_UTI_FIRMA_DT = b.SCSB_UTI_FIRMA_DT ,
a.SCSB_ACC_CASSA_BT = b.SCSB_ACC_CASSA_BT ,
a.SCSB_ACC_CASSA_MLT = b.SCSB_ACC_CASSA_MLT ,
a.SCSB_ACC_SMOBILIZZO = b.SCSB_ACC_SMOBILIZZO ,
a.SCSB_ACC_FIRMA_DT = b.SCSB_ACC_FIRMA_DT ,
a.SCSB_TOT_GAR = b.SCSB_TOT_GAR ,
a.SCSB_DTA_RIFERIMENTO = b.SCSB_DTA_RIFERIMENTO ,
a.scsb_uti_massimali = b.scsb_uti_massimali,
a.scsb_uti_sostituzioni = b.scsb_uti_sostituzioni,
a.scsb_uti_rischi_indiretti = b.scsb_uti_rischi_indiretti,
a.scsb_uti_massimali_dt = b.scsb_uti_massimali_dt,
a.scsb_uti_sostituzioni_dt = b.scsb_uti_sostituzioni_dt,
a.scsb_uti_rischi_indiretti_dt = b.scsb_uti_rischi_indiretti_dt,
a.scsb_acc_massimali = b.scsb_acc_massimali,
a.scsb_acc_sostituzioni = b.scsb_acc_sostituzioni,
a.scsb_acc_rischi_indiretti = b.scsb_acc_rischi_indiretti,
a.scsb_acc_massimali_dt = b.scsb_acc_massimali_dt,
a.scsb_acc_sostituzioni_dt = b.scsb_acc_sostituzioni_dt,
a.scsb_acc_rischi_indiretti_dt = b.scsb_acc_rischi_indiretti_dt,
a.scsb_acc_CONSEGNE = b.scsb_acc_CONSEGNE,
a.scsb_acc_CONSEGNE_DT = b.scsb_acc_CONSEGNE_DT,
a.scsb_UTI_CONSEGNE = b.scsb_UTI_CONSEGNE,
A.SCSB_UTI_CONSEGNE_DT = B.SCSB_UTI_CONSEGNE_DT,
a.COD_SNDG = b.COD_SNDG,
a.dta_upd = b.dta_upd,
a.id_dper_scsb = b.id_dper
WHEN NOT MATCHED THEN
INSERT (COD_ABI_ISTITUTO ,COD_NDG ,COD_ABI_CARTOLARIZZATO,
scsb_uti_sostituzioni,scsb_uti_massimali, scsb_uti_rischi_indiretti,
scsb_uti_sostituzioni_dt,scsb_uti_massimali_dt, scsb_uti_rischi_indiretti_dt,
scsb_acc_sostituzioni,scsb_acc_massimali, scsb_acc_rischi_indiretti,
scsb_acc_sostituzioni_dt,scsb_acc_massimali_dt, scsb_acc_rischi_indiretti_dt,
scsb_acc_CONSEGNE,scsb_acc_CONSEGNE_DT,scsb_UTI_CONSEGNE,scsb_UTI_CONSEGNE_DT,
SCSB_UTI_CASSA ,SCSB_UTI_FIRMA ,SCSB_UTI_TOT ,SCSB_ACC_CASSA ,SCSB_ACC_FIRMA ,SCSB_ACC_TOT ,
SCSB_UTI_CASSA_BT ,SCSB_UTI_CASSA_MLT ,SCSB_UTI_SMOBILIZZO ,SCSB_UTI_FIRMA_DT ,SCSB_ACC_CASSA_BT ,
SCSB_ACC_CASSA_MLT ,SCSB_ACC_SMOBILIZZO ,SCSB_ACC_FIRMA_DT ,SCSB_TOT_GAR ,SCSB_DTA_RIFERIMENTO ,
COD_SNDG , DTA_INS, ID_DPER_SCSB)
VALUES (b.COD_ABI_ISTITUTO ,b.COD_NDG ,B.COD_ABI_CARTOLARIZZATO,
b.scsb_uti_sostituzioni,b.scsb_uti_massimali, b.scsb_uti_rischi_indiretti,
b.scsb_uti_sostituzioni_dt,b.scsb_uti_massimali_dt, b.scsb_uti_rischi_indiretti_dt,
b.scsb_acc_sostituzioni,b.scsb_acc_massimali, b.scsb_acc_rischi_indiretti,
b.scsb_acc_sostituzioni_dt,b.scsb_acc_massimali_dt, b.scsb_acc_rischi_indiretti_dt,
b.scsb_acc_CONSEGNE,b.scsb_acc_CONSEGNE_DT,b.scsb_UTI_CONSEGNE,b.scsb_UTI_CONSEGNE_DT,
B.SCSB_UTI_CASSA ,B.SCSB_UTI_FIRMA ,B.SCSB_UTI_TOT ,B.SCSB_ACC_CASSA ,B.SCSB_ACC_FIRMA ,B.SCSB_ACC_TOT ,
B.SCSB_UTI_CASSA_BT ,B.SCSB_UTI_CASSA_MLT ,B.SCSB_UTI_SMOBILIZZO ,B.SCSB_UTI_FIRMA_DT ,B.SCSB_ACC_CASSA_BT ,
B.SCSB_ACC_CASSA_MLT ,B.SCSB_ACC_SMOBILIZZO ,B.SCSB_ACC_FIRMA_DT ,B.SCSB_TOT_GAR ,B.SCSB_DTA_RIFERIMENTO ,
b.COD_SNDG ,b.dta_ins,b.id_dper);
commit;
return ok;

EXCEPTION
WHEN OTHERS THEN
log_caricamenti('fnc_load_pcr_scsb_merge',SQLCODE,SQLERRM);
return ko;
end;

-- Procedura per calcolo pcr gesb usando la MERGE
-- stato esecuzione 1 OK 0 Errori 
FUNCTION fnc_load_pcr_gesb_merge(p_id_dper t_mcre0_app_pcr_sc_sb.id_dper%type default null) RETURN NUMBER IS
begin
MERGE INTO mcre_own.new_t_mcre0_app_pcr a
USING (
select id_dper, 
gesb_ACC_CONSEGNe,
gesb_ACC_CONSEGNE_DT,
gesb_UTI_CONSEGNE,
gesb_UTI_CONSEGNE_DT,
gesb_uti_sostituzioni,
gesb_uti_massimali, 
gesb_uti_rischi_indiretti,
gesb_uti_sostituzioni_dt,
gesb_uti_massimali_dt, 
gesb_uti_rischi_indiretti_dt,
gesb_acc_sostituzioni,
gesb_acc_massimali, 
gesb_acc_rischi_indiretti,
gesb_acc_sostituzioni_dt,
gesb_acc_massimali_dt, 
gesb_acc_rischi_indiretti_dt,
geSB_UTI_CASSA ,
geSB_UTI_FIRMA ,
geSB_ACC_CASSA 
,geSB_ACC_FIRMA ,
geSB_UTI_CASSA_BT ,
geSB_UTI_CASSA_MLT ,
geSB_UTI_SMOBILIZZO ,
geSB_UTI_FIRMA_DT ,
geSB_ACC_CASSA_BT ,
geSB_ACC_CASSA_MLT ,
geSB_ACC_SMOBILIZZO ,
geSB_ACC_FIRMA_DT ,
geSB_TOT_GAR,
GESB_dta_riferimento,
GESB_ACC_CASSA+GESB_ACC_FIRMA GESB_ACC_TOT,
GESB_UTI_CASSA+GESB_UTI_FIRMA GESB_UTI_TOT,
XX.COD_SNDG, XX.COD_ABI_ISTITUTO,
xx.COD_NDG,COD_ABI_CARTOLARIZZATO,
sysdate dta_ins, sysdate dta_upd
from (
SELECT pcr.cod_abi_istituto, pcr.cod_sndg, pcr.id_dper, ge.cod_gruppo_economico,
SUM
(CASE
WHEN cl.cod_classe_appl_cf = 'CO'
THEN pcr.val_imp_uti_gre
ELSE 0
END
) gesb_uti_CONSEGNE,
SUM
(CASE
WHEN cl.cod_classe_appl_cf = 'CO'
THEN pcr.val_imp_uti_gre
ELSE 0
END
) gesb_uti_CONSEGNE_DT,
SUM
(CASE
WHEN cl.cod_classe_appl_cf = 'CO'
THEN pcr.val_imp_ACC_gre
ELSE 0
END
) gesb_ACC_CONSEGNE,
SUM
(CASE
WHEN cl.cod_classe_appl_cf = 'CO'
THEN pcr.val_imp_ACC_gre
ELSE 0
END
) gesb_ACC_CONSEGNE_DT,
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
max(pcr.dta_riferimento) GESB_dta_riferimento
FROM t_mcre0_app_pcr_ge_sb pcr,
t_mcre0_app_natura_ftecnica cl,
mcre_own.t_mcre0_app_gruppo_economico ge
WHERE pcr.cod_forma_tecn = cl.cod_ftecnica
AND PCR.COD_SNDG = GE.COD_SNDG
AND pcr.id_dper =nvl(p_id_dper,(SELECT a.idper
FROM V_MCRE0_ULTIMA_ACQUISIZIONE A
WHERE a.cod_file = 'PCR_GE_SB'))
GROUP BY pcr.cod_abi_istituto,
pcr.cod_sndg,
ge.cod_gruppo_economico,
PCR.ID_DPER) P ,
(select distinct cod_sndg, COD_ABI_CARTOLARIZZATO,
COD_ABI_ISTITUTO,COD_NDG
from t_mcre0_app_file_guida f
WHERE 
f.id_dper = nvl(p_id_dper,(SELECT a.idper
FROM V_MCRE0_ULTIMA_ACQUISIZIONE A
WHERE a.cod_file = 'FILE_GUIDA')) ) xx
where xx.cod_sndg = p.cod_sndg
and xx.cod_abi_istituto = p.cod_abi_istituto
--and rownum<101
) b
ON (a.COD_ABI_CARTOLARIZZATO = b.COD_ABI_CARTOLARIZZATO
and a.COD_NDG = b.cod_ndg)
WHEN MATCHED THEN
UPDATE SET 
a.GESB_ACC_CASSA = b.GESB_ACC_CASSA,
a.GESB_ACC_CASSA_BT = b.GESB_ACC_CASSA_BT,
a.GESB_ACC_CASSA_MLT = b.GESB_ACC_CASSA_MLT,
a.GESB_ACC_FIRMA = b.GESB_ACC_FIRMA,
a.GESB_ACC_FIRMA_DT = b.GESB_ACC_FIRMA_DT,
a.GESB_ACC_SMOBILIZZO = b.GESB_ACC_SMOBILIZZO,
a.GESB_DTA_RIFERIMENTO = b.GESB_DTA_RIFERIMENTO,
a.GESB_TOT_GAR = b.GESB_TOT_GAR,
a.GESB_UTI_CASSA = b.GESB_UTI_CASSA,
a.GESB_UTI_CASSA_BT = b.GESB_UTI_CASSA_BT,
a.GESB_UTI_CASSA_MLT = b.GESB_UTI_CASSA_MLT,
a.GESB_UTI_FIRMA = b.GESB_UTI_FIRMA,
a.GESB_UTI_FIRMA_DT = b.GESB_UTI_FIRMA_DT,
a.GESB_UTI_SMOBILIZZO = b.GESB_UTI_SMOBILIZZO,
a.GESB_ACC_TOT = b.GESB_ACC_TOT,
a.GESB_UTI_TOT = b.GESB_UTI_TOT,
a.gesb_uti_massimali = b.gesb_uti_massimali,
a.gesb_uti_sostituzioni = b.gesb_uti_sostituzioni,
a.gesb_uti_rischi_indiretti = b.gesb_uti_rischi_indiretti,
a.gesb_uti_massimali_dt = b.gesb_uti_massimali_dt,
a.gesb_uti_sostituzioni_dt = b.gesb_uti_sostituzioni_dt,
a.gesb_uti_rischi_indiretti_dt = b.gesb_uti_rischi_indiretti_dt,
a.gesb_acc_massimali = b.gesb_acc_massimali,
a.gesb_acc_sostituzioni = b.gesb_acc_sostituzioni,
a.gesb_acc_rischi_indiretti = b.gesb_acc_rischi_indiretti,
a.gesb_acc_massimali_dt = b.gesb_acc_massimali_dt,
a.gesb_acc_sostituzioni_dt = b.gesb_acc_sostituzioni_dt,
a.gesb_acc_rischi_indiretti_dt = b.gesb_acc_rischi_indiretti_dt,
a.gesb_acc_CONSEGNE = b.gesb_acc_CONSEGNE,
a.gesb_acc_CONSEGNE_DT = b.gesb_acc_CONSEGNE_DT,
a.gesb_UTI_CONSEGNE = b.gesb_UTI_CONSEGNE,
a.gesb_UTI_CONSEGNE_DT = b.gesb_UTI_CONSEGNE_DT,
a.id_dper_gesb = b.id_dper
WHEN NOT MATCHED THEN
INSERT (COD_ABI_ISTITUTO ,COD_NDG ,COD_ABI_CARTOLARIZZATO,
gesb_uti_sostituzioni,gesb_uti_massimali, gesb_uti_rischi_indiretti,
gesb_uti_sostituzioni_dt,gesb_uti_massimali_dt, gesb_uti_rischi_indiretti_dt,
gesb_acc_sostituzioni,gesb_acc_massimali, gesb_acc_rischi_indiretti,
gesb_acc_sostituzioni_dt,gesb_acc_massimali_dt, gesb_acc_rischi_indiretti_dt,
gesb_UTI_CONSEGNE,gesb_UTI_CONSEGNE_DT,gesb_ACC_CONSEGNE,gesb_ACC_CONSEGNE_DT,
geSB_UTI_CASSA ,geSB_UTI_FIRMA ,geSB_UTI_TOT ,geSB_ACC_CASSA ,geSB_ACC_FIRMA ,
geSB_ACC_TOT ,geSB_UTI_CASSA_BT ,geSB_UTI_CASSA_MLT ,geSB_UTI_SMOBILIZZO ,geSB_UTI_FIRMA_DT ,
geSB_ACC_CASSA_BT ,geSB_ACC_CASSA_MLT ,geSB_ACC_SMOBILIZZO ,geSB_ACC_FIRMA_DT ,
GESB_TOT_GAR ,GESB_DTA_RIFERIMENTO ,COD_SNDG ,
DTA_INS, ID_DPER_GESB)
VALUES (b.COD_ABI_ISTITUTO ,b.COD_NDG ,B.COD_ABI_CARTOLARIZZATO,
b.gesb_uti_sostituzioni,b.gesb_uti_massimali, b.gesb_uti_rischi_indiretti,
b.gesb_uti_sostituzioni_dt,b.gesb_uti_massimali_dt, b.gesb_uti_rischi_indiretti_dt,
b.gesb_acc_sostituzioni,b.gesb_acc_massimali, b.gesb_acc_rischi_indiretti,
b.gesb_acc_sostituzioni_dt,b.gesb_acc_massimali_dt, b.gesb_acc_rischi_indiretti_dt,
b.gesb_UTI_CONSEGNE,b.gesb_UTI_CONSEGNE_DT,b.gesb_ACC_CONSEGNE,b.gesb_ACC_CONSEGNE_DT,
b.geSB_UTI_CASSA ,b.geSB_UTI_FIRMA ,b.geSB_UTI_TOT ,b.geSB_ACC_CASSA ,b.geSB_ACC_FIRMA ,b.geSB_ACC_TOT ,
b.geSB_UTI_CASSA_BT ,b.geSB_UTI_CASSA_MLT ,b.geSB_UTI_SMOBILIZZO ,b.geSB_UTI_FIRMA_DT ,b.geSB_ACC_CASSA_BT ,b.geSB_ACC_CASSA_MLT ,
B.GESB_ACC_SMOBILIZZO ,B.GESB_ACC_FIRMA_DT ,B.GESB_TOT_GAR ,B.GESB_DTA_RIFERIMENTO ,B.COD_SNDG ,
b.dta_ins,b.id_dper);
commit;
return ok;

EXCEPTION
WHEN OTHERS THEN
log_caricamenti('fnc_load_pcr_gesb_merge',SQLCODE,SQLERRM);
return ko;
end;
-- Procedura per calcolo pcr gb usando la MERGE
-- stato esecuzione 1 OK 0 Errori 
FUNCTION fnc_load_pcr_gb_merge(p_id_dper t_mcre0_app_pcr_sc_sb.id_dper%type default null) RETURN NUMBER IS
begin

MERGE INTO mcre_own.new_t_mcre0_app_pcr a
USING (SELECT ID_DPER, 
xx.cod_sndg, xx.COD_ABI_ISTITUTO, COD_ABI_CARTOLARIZZATO,
xx.COD_NDG, p.dta_riferimento,
sysdate dta_ins, sysdate dta_upd,
gegb_TOT_GAR,
scgb_TOT_GAR,
glgb_TOT_GAR,
SCgb_ACC_CONSEGNE,
SCgb_ACC_CONSEGNE_DT,
SCgb_UTI_CONSEGNE,
SCgb_UTI_CONSEGNE_DT,
GEgb_ACC_CONSEGNE,
GEgb_ACC_CONSEGNE_DT,
GEgb_UTI_CONSEGNE,
GEgb_UTI_CONSEGNE_DT,
GLgb_ACC_CONSEGNE,
GLgb_ACC_CONSEGNE_DT,
GLgb_UTI_CONSEGNE,
GLgb_UTI_CONSEGNE_DT,
scgb_uti_massimali,
scgb_uti_sostituzioni,
scgb_uti_rischi_indiretti,
scgb_uti_massimali_dt,
scgb_uti_sostituzioni_dt,
scgb_uti_rischi_indiretti_dt,
scgb_acc_massimali,
scgb_acc_sostituzioni,
scgb_acc_rischi_indiretti,
scgb_acc_massimali_dt,
scgb_acc_sostituzioni_dt,
scgb_acc_rischi_indiretti_dt,
gegb_uti_massimali,
gegb_uti_sostituzioni,
gegb_uti_rischi_indiretti,
gegb_uti_massimali_dt,
gegb_uti_sostituzioni_dt,
gegb_uti_rischi_indiretti_dt,
gegb_acc_massimali,
gegb_acc_sostituzioni,
gegb_acc_rischi_indiretti,
gegb_acc_massimali_dt,
gegb_acc_sostituzioni_dt,
gegb_acc_rischi_indiretti_dt,
glgb_uti_massimali,
glgb_uti_sostituzioni,
glgb_uti_rischi_indiretti,
glgb_uti_massimali_dt,
glgb_uti_sostituzioni_dt,
glgb_uti_rischi_indiretti_dt,
glgb_acc_massimali,
glgb_acc_sostituzioni,
glgb_acc_rischi_indiretti,
glgb_acc_massimali_dt,
glgb_acc_sostituzioni_dt,
glgb_acc_rischi_indiretti_dt,
scgb_uti_cassa, scgb_uti_firma, scgb_acc_cassa,
scgb_acc_firma, scgb_uti_cassa_bt, scgb_uti_cassa_mlt,
scgb_uti_smobilizzo, scgb_uti_firma_dt, scgb_acc_cassa_bt,
scgb_acc_cassa_mlt, scgb_acc_smobilizzo, scgb_acc_firma_dt,
gegb_uti_cassa, gegb_uti_firma, gegb_acc_cassa, gegb_acc_firma,
gegb_uti_cassa_bt, gegb_uti_cassa_mlt, gegb_uti_smobilizzo,
gegb_uti_firma_dt, gegb_acc_cassa_bt, gegb_acc_cassa_mlt,
gegb_acc_smobilizzo, gegb_acc_firma_dt, glgb_uti_cassa,
glgb_uti_firma, glgb_acc_cassa, glgb_acc_firma,
glgb_uti_cassa_bt, glgb_uti_cassa_mlt, glgb_uti_smobilizzo,
glgb_uti_firma_dt, glgb_acc_cassa_bt, glgb_acc_cassa_mlt,
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
(gegb_uti_cassa + gegb_uti_firma)
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
) gegb_uti_CONSEGNE,
SUM 
(CASE
WHEN cl.cod_classe_appl_cf = 'CO'
THEN pcr.val_imp_uti_gre
ELSE 0
END
) gegb_uti_CONSEGNE_DT,
SUM 
(CASE
WHEN cl.cod_classe_appl_cf = 'CO'
THEN pcr.val_imp_ACC_gre
ELSE 0
END
) gegb_ACC_CONSEGNE,
SUM 
(CASE
WHEN cl.cod_classe_appl_cf = 'CO'
THEN pcr.val_imp_ACC_gre
ELSE 0
END
) gegb_ACC_CONSEGNE_DT,
SUM 
(CASE
WHEN cl.cod_classe_appl_cf = 'CO'
THEN pcr.val_imp_uti_CLI
ELSE 0
END
) SCgb_uti_CONSEGNE,
SUM 
(CASE
WHEN cl.cod_classe_appl_cf = 'CO'
THEN pcr.val_imp_uti_CLI
ELSE 0
END
) SCgb_uti_CONSEGNE_DT, 
SUM 
(CASE
WHEN cl.cod_classe_appl_cf = 'CO'
THEN pcr.val_imp_ACC_CLI
ELSE 0
END
) SCgb_ACC_CONSEGNE, 
SUM 
(CASE
WHEN cl.cod_classe_appl_cf = 'CO'
THEN pcr.val_imp_ACC_CLI
ELSE 0
END
) SCgb_ACC_CONSEGNE_DT, 
SUM 
(CASE
WHEN cl.cod_classe_appl_cf = 'CO'
THEN pcr.val_imp_uti_LEG
ELSE 0
END
) GLgb_uti_CONSEGNE, 
SUM 
(CASE
WHEN cl.cod_classe_appl_cf = 'CO'
THEN pcr.val_imp_uti_LEG
ELSE 0
END
) GLgb_uti_CONSEGNE_DT, 
SUM 
(CASE
WHEN cl.cod_classe_appl_cf = 'CO'
THEN pcr.val_imp_ACC_LEG
ELSE 0
END
) GLgb_ACC_CONSEGNE, 
SUM 
(CASE
WHEN cl.cod_classe_appl_cf = 'CO'
THEN pcr.val_imp_ACC_LEG
ELSE 0
END
) GLgb_ACC_CONSEGNE_DT, 
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
WHEN CL.COD_CLASSE_APPL_CF = 'RI'
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
WHEN CL.COD_CLASSE_APPL_DETT = 'C'
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
WHEN CL.COD_CLASSE_APPL_DETT = 'FI'
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
max(pcr.dta_riferimento) dta_riferimento
FROM t_mcre0_app_pcr_gb pcr, t_mcre0_app_natura_ftecnica cl
WHERE PCR.COD_FORMA_TECNICA = CL.COD_FTECNICA
AND pcr.id_dper = nvl(p_id_dper,(SELECT a.idper
FROM V_MCRE0_ULTIMA_ACQUISIZIONE A
WHERE a.cod_file = 'PCR_GB'))
GROUP BY PCR.COD_SNDG,PCR.ID_DPER ) P ,
(SELECT DISTINCT COD_SNDG, COD_ABI_CARTOLARIZZATO,
COD_ABI_ISTITUTO, COD_NDG
from T_MCRE0_APP_FILE_GUIDA F
WHERE F.COD_SNDG!='0000000000000000' ) XX
where xx.cod_sndg = p.cod_sndg
) b
ON (A.COD_NDG = B.COD_NDG
and A.COD_ABI_CARTOLARIZZATO = b.COD_ABI_CARTOLARIZZATO )
WHEN MATCHED THEN
UPDATE SET 
a.scgb_uti_massimali = b.scgb_uti_massimali,
a.scgb_uti_sostituzioni = b.scgb_uti_sostituzioni,
a.scgb_uti_rischi_indiretti = b.scgb_uti_rischi_indiretti,
a.scgb_uti_massimali_dt = b.scgb_uti_massimali_dt,
a.scgb_uti_sostituzioni_dt = b.scgb_uti_sostituzioni_dt,
a.scgb_uti_rischi_indiretti_dt = b.scgb_uti_rischi_indiretti_dt,
a.scgb_acc_massimali = b.scgb_acc_massimali,
a.scgb_acc_sostituzioni = b.scgb_acc_sostituzioni,
a.scgb_acc_rischi_indiretti = b.scgb_acc_rischi_indiretti,
a.scgb_acc_massimali_dt = b.scgb_acc_massimali_dt,
a.scgb_acc_sostituzioni_dt = b.scgb_acc_sostituzioni_dt,
a.scgb_acc_rischi_indiretti_dt = b.scgb_acc_rischi_indiretti_dt,
a.SCgb_acc_CONSEGNE = b.SCgb_acc_CONSEGNE,
a.SCgb_acc_CONSEGNE_DT = b.SCgb_acc_CONSEGNE_DT,
a.SCgb_UTI_CONSEGNE = b.SCgb_UTI_CONSEGNE,
a.SCgb_UTI_CONSEGNE_DT = b.SCgb_UTI_CONSEGNE_DT,
a.SCGB_ACC_CASSA = b.SCGB_ACC_CASSA ,
a.SCGB_ACC_CASSA_BT = b.SCGB_ACC_CASSA_BT ,
a.SCGB_ACC_CASSA_MLT = b.SCGB_ACC_CASSA_MLT ,
a.SCGB_ACC_FIRMA = b.SCGB_ACC_FIRMA ,
a.SCGB_ACC_FIRMA_DT = b.SCGB_ACC_FIRMA_DT ,
a.SCGB_ACC_SMOBILIZZO = b.SCGB_ACC_SMOBILIZZO ,
a.SCGB_TOT_GAR = b.scgb_TOT_GAR ,
a.SCGB_UTI_CASSA = b.SCGB_UTI_CASSA ,
a.SCGB_UTI_CASSA_BT = b.SCGB_UTI_CASSA_BT ,
a.SCGB_UTI_CASSA_MLT = b.SCGB_UTI_CASSA_MLT ,
a.SCGB_UTI_FIRMA = b.SCGB_UTI_FIRMA ,
a.SCGB_UTI_FIRMA_DT = b.SCGB_UTI_FIRMA_DT ,
a.SCGB_UTI_SMOBILIZZO = b.SCGB_UTI_SMOBILIZZO ,
a.gegb_uti_massimali = b.gegb_uti_massimali,
a.gegb_uti_sostituzioni = b.gegb_uti_sostituzioni,
a.gegb_uti_rischi_indiretti = b.gegb_uti_rischi_indiretti,
a.gegb_uti_massimali_dt = b.gegb_uti_massimali_dt,
a.gegb_uti_sostituzioni_dt = b.gegb_uti_sostituzioni_dt,
a.gegb_uti_rischi_indiretti_dt = b.gegb_uti_rischi_indiretti_dt,
a.gegb_acc_massimali = b.gegb_acc_massimali,
a.gegb_acc_sostituzioni = b.gegb_acc_sostituzioni,
a.gegb_acc_rischi_indiretti = b.gegb_acc_rischi_indiretti,
a.gegb_acc_massimali_dt = b.gegb_acc_massimali_dt,
a.gegb_acc_sostituzioni_dt = b.gegb_acc_sostituzioni_dt,
a.gegb_acc_rischi_indiretti_dt = b.gegb_acc_rischi_indiretti_dt,
a.gegb_acc_CONSEGNE = b.gegb_acc_CONSEGNE,
a.gegb_acc_CONSEGNE_DT = b.gegb_acc_CONSEGNE_DT,
a.gegb_UTI_CONSEGNE = b.gegb_UTI_CONSEGNE,
a.gegb_UTI_CONSEGNE_DT = b.gegb_UTI_CONSEGNE_DT,
a.GEGB_ACC_CASSA = b.GEGB_ACC_CASSA ,
a.GEGB_ACC_CASSA_BT = b.GEGB_ACC_CASSA_BT ,
a.GEGB_ACC_CASSA_MLT = b.GEGB_ACC_CASSA_MLT ,
a.GEGB_ACC_FIRMA = b.GEGB_ACC_FIRMA ,
a.GEGB_ACC_FIRMA_DT = b.GEGB_ACC_FIRMA_DT ,
a.GEGB_ACC_SMOBILIZZO = b.GEGB_ACC_SMOBILIZZO ,
a.GEGB_TOT_GAR = b.gegb_TOT_GAR ,
a.GEGB_UTI_CASSA = b.GEGB_UTI_CASSA ,
a.GEGB_UTI_CASSA_BT = b.GEGB_UTI_CASSA_BT ,
a.GEGB_UTI_CASSA_MLT = b.GEGB_UTI_CASSA_MLT ,
a.GEGB_UTI_FIRMA = b.GEGB_UTI_FIRMA ,
a.GEGB_UTI_FIRMA_DT = b.GEGB_UTI_FIRMA_DT ,
a.GEGB_UTI_SMOBILIZZO = b.GEGB_UTI_SMOBILIZZO ,
a.glgb_uti_massimali = b.glgb_uti_massimali,
a.glgb_uti_sostituzioni = b.glgb_uti_sostituzioni,
a.glgb_uti_rischi_indiretti = b.glgb_uti_rischi_indiretti,
a.glgb_uti_massimali_dt = b.glgb_uti_massimali_dt,
a.glgb_uti_sostituzioni_dt = b.glgb_uti_sostituzioni_dt,
a.glgb_uti_rischi_indiretti_dt = b.glgb_uti_rischi_indiretti_dt,
a.glgb_acc_massimali = b.glgb_acc_massimali,
a.glgb_acc_sostituzioni = b.glgb_acc_sostituzioni,
a.glgb_acc_rischi_indiretti = b.glgb_acc_rischi_indiretti,
a.glgb_acc_massimali_dt = b.glgb_acc_massimali_dt,
a.glgb_acc_sostituzioni_dt = b.glgb_acc_sostituzioni_dt,
a.glgb_acc_rischi_indiretti_dt = b.glgb_acc_rischi_indiretti_dt,
a.gLgb_acc_CONSEGNE = b.gLgb_acc_CONSEGNE,
a.gLgb_acc_CONSEGNE_DT = b.gLgb_acc_CONSEGNE_DT,
a.gLgb_UTI_CONSEGNE = b.gLgb_UTI_CONSEGNE,
a.gLgb_UTI_CONSEGNE_DT = b.gLgb_UTI_CONSEGNE_DT,
a.GLGB_ACC_CASSA = b.GLGB_ACC_CASSA ,
a.GLGB_ACC_CASSA_BT = b.GLGB_ACC_CASSA_BT ,
a.GLGB_ACC_CASSA_MLT = b.GLGB_ACC_CASSA_MLT ,
a.GLGB_ACC_FIRMA = b.GLGB_ACC_FIRMA ,
a.GLGB_ACC_FIRMA_DT = b.GLGB_ACC_FIRMA_DT ,
a.GLGB_ACC_SMOBILIZZO = b.GLGB_ACC_SMOBILIZZO ,
a.GLGB_TOT_GAR = b.glgb_TOT_GAR ,
a.GLGB_UTI_CASSA = b.GLGB_UTI_CASSA ,
a.GLGB_UTI_CASSA_BT = b.GLGB_UTI_CASSA_BT ,
a.GLGB_UTI_CASSA_MLT = b.GLGB_UTI_CASSA_MLT ,
a.GLGB_UTI_FIRMA = b.GLGB_UTI_FIRMA ,
a.GLGB_UTI_FIRMA_DT = b.GLGB_UTI_FIRMA_DT ,
a.GLGB_UTI_SMOBILIZZO = b.GLGB_UTI_SMOBILIZZO ,
a.gegb_mau = b.GEGB_MAU ,
a.glgb_mau = b.GLGB_MAU ,
A.SCGB_MAU = B.SCGB_MAU ,
--------------------------- VERIFY
/* a.gb_val_mau = DECODE (b.flg_gruppo_economico,1,b.gegb_mau,--mau GE su GB
decode(b.flg_gruppo_legame, 1,b.glgb_mau, --mau GL su GB
b.scgb_mau)), */
a.gb_val_mau = NULL,
a.SCGB_ACC_TOT = b.SCGB_ACC_CASSA+b.SCGB_ACC_FIRMA,
a.SCGB_UTI_TOT = b.SCGB_UTI_CASSA+b.SCGB_UTI_FIRMA, 
a.GEGB_ACC_TOT = b.GEGB_ACC_CASSA+b.GEGB_ACC_FIRMA,
a.GEGB_UTI_TOT = b.GEGB_UTI_CASSA+b.GEGB_UTI_FIRMA,
a.GLGB_ACC_TOT = b.GLGB_ACC_CASSA+b.GLGB_ACC_FIRMA,
a.GLGB_UTI_TOT = b.GLGB_UTI_CASSA+b.GLGB_UTI_FIRMA,
a.id_dper_gb = b.id_dper,
a.gb_dta_riferimento = b.dta_riferimento
WHEN NOT MATCHED THEN
INSERT (COD_ABI_ISTITUTO ,COD_NDG ,COD_ABI_CARTOLARIZZATO,
gegb_uti_sostituzioni, gegb_uti_massimali, gegb_uti_rischi_indiretti,
gegb_uti_sostituzioni_dt, gegb_uti_massimali_dt, gegb_uti_rischi_indiretti_dt,
gegb_acc_sostituzioni,gegb_acc_massimali, gegb_acc_rischi_indiretti,
gegb_acc_sostituzioni_dt,gegb_acc_massimali_dt, gegb_acc_rischi_indiretti_dt,
gegb_UTI_CASSA ,gegb_UTI_FIRMA ,gegb_UTI_TOT ,gegb_ACC_CASSA ,gegb_ACC_FIRMA ,
gegb_ACC_TOT ,gegb_UTI_CASSA_BT ,gegb_UTI_CASSA_MLT ,gegb_UTI_SMOBILIZZO ,gegb_UTI_FIRMA_DT ,
gegb_ACC_CASSA_BT ,gegb_ACC_CASSA_MLT ,gegb_ACC_SMOBILIZZO ,gegb_ACC_FIRMA_DT ,
gegb_TOT_GAR ,gegb_mau,--gegb_DTA_RIFERIMENTO ,
GEGB_ACC_CONSEGNE,GEGB_ACC_CONSEGNE_DT,GEGB_UTI_CONSEGNE,GEGB_UTI_CONSEGNE_DT,
scgb_uti_sostituzioni,scgb_uti_massimali, scgb_uti_rischi_indiretti,
scgb_uti_sostituzioni_dt,scgb_uti_massimali_dt, scgb_uti_rischi_indiretti_dt,
scgb_acc_sostituzioni,scgb_acc_massimali, scgb_acc_rischi_indiretti,
scgb_acc_sostituzioni_dt,scgb_acc_massimali_dt, scgb_acc_rischi_indiretti_dt,
scgb_UTI_CASSA ,scgb_UTI_FIRMA ,scgb_UTI_TOT ,scgb_ACC_CASSA ,scgb_ACC_FIRMA ,
scgb_ACC_TOT ,scgb_UTI_CASSA_BT ,scgb_UTI_CASSA_MLT ,scgb_UTI_SMOBILIZZO ,scgb_UTI_FIRMA_DT ,
scgb_ACC_CASSA_BT ,scgb_ACC_CASSA_MLT ,scgb_ACC_SMOBILIZZO ,scgb_ACC_FIRMA_DT ,
scgb_TOT_GAR ,scgb_mau,--scgb_DTA_RIFERIMENTO ,
SCGB_ACC_CONSEGNE,SCGB_ACC_CONSEGNE_DT,SCGB_UTI_CONSEGNE,SCGB_UTI_CONSEGNE_DT,
glgb_uti_sostituzioni,glgb_uti_massimali, glgb_uti_rischi_indiretti,
glgb_uti_sostituzioni_dt,glgb_uti_massimali_dt, glgb_uti_rischi_indiretti_dt,
glgb_acc_sostituzioni,glgb_acc_massimali, glgb_acc_rischi_indiretti,
glgb_acc_sostituzioni_dt,glgb_acc_massimali_dt, glgb_acc_rischi_indiretti_dt,
glgb_UTI_CASSA ,glgb_UTI_FIRMA ,glgb_UTI_TOT ,glgb_ACC_CASSA ,glgb_ACC_FIRMA ,
glgb_ACC_TOT ,glgb_UTI_CASSA_BT ,glgb_UTI_CASSA_MLT ,glgb_UTI_SMOBILIZZO ,glgb_UTI_FIRMA_DT ,
glgb_ACC_CASSA_BT ,glgb_ACC_CASSA_MLT ,glgb_ACC_SMOBILIZZO ,glgb_ACC_FIRMA_DT ,
glgb_TOT_GAR ,glgb_mau,--glgb_DTA_RIFERIMENTO ,
GLGB_ACC_CONSEGNE,GLGB_ACC_CONSEGNE_DT,GLGB_UTI_CONSEGNE,GLGB_UTI_CONSEGNE_DT,
gb_val_mau,
gb_dta_riferimento,
COD_SNDG , 
DTA_INS, ID_DPER_GB)
VALUES (b.COD_ABI_ISTITUTO ,b.COD_NDG ,b.COD_ABI_CARTOLARIZZATO,
-----------------------GE
b.gegb_uti_sostituzioni,b.gegb_uti_massimali, b.gegb_uti_rischi_indiretti,
b.gegb_uti_sostituzioni_dt,b.gegb_uti_massimali_dt, b.gegb_uti_rischi_indiretti_dt, 
b.gegb_acc_sostituzioni,b.gegb_acc_massimali, b.gegb_acc_rischi_indiretti,
b.gegb_acc_sostituzioni_dt,b.gegb_acc_massimali_dt, b.gegb_acc_rischi_indiretti_dt,
b.gegb_UTI_CASSA ,b.gegb_UTI_FIRMA ,b.gegb_UTI_TOT ,b.gegb_ACC_CASSA ,b.gegb_ACC_FIRMA ,b.gegb_ACC_TOT ,
b.gegb_UTI_CASSA_BT ,b.gegb_UTI_CASSA_MLT ,b.gegb_UTI_SMOBILIZZO ,b.gegb_UTI_FIRMA_DT ,b.gegb_ACC_CASSA_BT ,b.gegb_ACC_CASSA_MLT ,
b.gegb_ACC_SMOBILIZZO ,b.gegb_ACC_FIRMA_DT ,b.gegb_TOT_GAR,b.gegb_mau,--b.gegb_DTA_RIFERIMENTO ,
b.GEGB_ACC_CONSEGNE,b.GEGB_ACC_CONSEGNE_DT,b.GEGB_UTI_CONSEGNE,b.GEGB_UTI_CONSEGNE_DT,
-----------------------SC
b.scgb_uti_sostituzioni,b.scgb_uti_massimali, b.scgb_uti_rischi_indiretti,
b.scgb_uti_sostituzioni_dt,b.scgb_uti_massimali_dt, b.scgb_uti_rischi_indiretti_dt,
b.scgb_acc_sostituzioni,b.scgb_acc_massimali, b.scgb_acc_rischi_indiretti,
b.scgb_acc_sostituzioni_dt,b.scgb_acc_massimali_dt, b.scgb_acc_rischi_indiretti_dt,
b.scgb_UTI_CASSA ,b.scgb_UTI_FIRMA ,b.scgb_UTI_TOT ,b.scgb_ACC_CASSA ,b.scgb_ACC_FIRMA ,b.scgb_ACC_TOT ,
b.scgb_UTI_CASSA_BT ,b.scgb_UTI_CASSA_MLT ,b.scgb_UTI_SMOBILIZZO ,b.scgb_UTI_FIRMA_DT ,b.scgb_ACC_CASSA_BT ,b.scgb_ACC_CASSA_MLT ,
b.scgb_ACC_SMOBILIZZO ,b.scgb_ACC_FIRMA_DT ,b.scgb_TOT_GAR ,b.scgb_mau,--b.scgb_DTA_RIFERIMENTO ,
b.SCGB_ACC_CONSEGNE,b.SCGB_ACC_CONSEGNE_DT,b.SCGB_UTI_CONSEGNE,b.SCGB_UTI_CONSEGNE_DT,
-----------------------GL
b.glgb_uti_sostituzioni,b.glgb_uti_massimali, b.glgb_uti_rischi_indiretti,
b.glgb_uti_sostituzioni_dt,b.glgb_uti_massimali_dt, b.glgb_uti_rischi_indiretti_dt,
b.glgb_acc_sostituzioni,b.glgb_acc_massimali, b.glgb_acc_rischi_indiretti,
b.glgb_acc_sostituzioni_dt,b.glgb_acc_massimali_dt, b.glgb_acc_rischi_indiretti_dt,
b.glgb_UTI_CASSA ,b.glgb_UTI_FIRMA ,b.glgb_UTI_TOT ,b.glgb_ACC_CASSA ,b.glgb_ACC_FIRMA ,b.glgb_ACC_TOT ,
b.glgb_UTI_CASSA_BT ,b.glgb_UTI_CASSA_MLT ,b.glgb_UTI_SMOBILIZZO ,b.glgb_UTI_FIRMA_DT ,b.glgb_ACC_CASSA_BT ,b.glgb_ACC_CASSA_MLT ,
b.glgb_ACC_SMOBILIZZO ,b.glgb_ACC_FIRMA_DT , b.glgb_TOT_GAR ,b.glgb_mau,--b.glgb_DTA_RIFERIMENTO ,
b.GLGB_ACC_CONSEGNE,b.GLGB_ACC_CONSEGNE_DT,b.GLGB_UTI_CONSEGNE,b.GLGB_UTI_CONSEGNE_DT,
-----------------------Vari
----------------------------------- VERIFY
NULL, --- MAU
b.DTA_RIFERIMENTO, b.COD_SNDG , b.dta_ins,b.id_dper);
commit;
return ok;

EXCEPTION
WHEN OTHERS THEN
log_caricamenti('fnc_load_pcr_gb_merge',SQLCODE,SQLERRM);
return ko;
end; 

END PKG_MCRE0_PCR_NEW_2;
/


CREATE SYNONYM MCRE_APP.PKG_MCRE0_PCR_NEW_2 FOR MCRE_OWN.PKG_MCRE0_PCR_NEW_2;


CREATE SYNONYM MCRE_USR.PKG_MCRE0_PCR_NEW_2 FOR MCRE_OWN.PKG_MCRE0_PCR_NEW_2;


GRANT EXECUTE, DEBUG ON MCRE_OWN.PKG_MCRE0_PCR_NEW_2 TO MCRE_USR;

