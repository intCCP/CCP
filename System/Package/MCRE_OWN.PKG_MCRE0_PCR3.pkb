CREATE OR REPLACE PACKAGE BODY MCRE_OWN."PKG_MCRE0_PCR3" AS
/******************************************************************************
NAME: PKG_MCRE0_PCR3
PURPOSE: Gestione alert ed evidenze

REVISIONS:
Ver Date Author Description
--------- ---------- ----------------- ------------------------------------
1.0 07/06/2011 Galli Valeria Created this package.
1.1 09/06/2011 Galli Valeria Tabella T_mcre0_app_PCR e LOG
2.0 08/08/2011 Marco Murro Aggiunta Gestioen today_flg - tuning!
2.1 02/09/2011 Marco Murro Fix Gestioen today_flg - tuning!
2.2 05/09/2011 Marco Murro Fix gb_merge per sndg variati
2.3 06/09/2011 Marco Murro Fix merge per sndg variati + gestione ko
2.4 18/10/2011 Luca Ferretti Modifiche Paola..
3.0 16/03/2012 Paola Goitre versione senza merge senza update e senza delete
3.1 02/04/2012 Paola Goitre variato e fixato calcolo MAU con derivati
******************************************************************************/


-- Procedura per calcolo pcr
-- INPUT :
-- OUTPUT :
-- stato esecuzione 1 OK 0 Errori
FUNCTION FNC_LOAD_PCR (
P_COD_LOG T_MCRE0_WRK_AUDIT_ETL.ID%TYPE DEFAULT NULL )
RETURN NUMBER IS

VAL_OK INTEGER;
V_COD_LOG T_MCRE0_WRK_AUDIT_ETL.ID%TYPE;

e_invalid_pcr EXCEPTION;

begin

IF( P_COD_LOG IS NULL) THEN
SELECT SEQ_MCR0_LOG_ETL.NEXTVAL
INTO V_COD_LOG
FROM DUAL;
ELSE
V_COD_LOG := P_COD_LOG;
end if;

-- fase1: determino i contributi attivi di SCSB
PKG_MCRE0_AUDIT.LOG_ETL(V_COD_LOG,'PKG_MCRE0_PCR3.FNC_LOAD_PCR',PKG_MCRE0_AUDIT.C_DEBUG,SQLCODE,SQLERRM,'SCSB - START');
val_ok := fnc_load_pcr_scsb_merge(V_COD_LOG );
PKG_MCRE0_AUDIT.LOG_ETL(V_COD_LOG,'PKG_MCRE0_PCR3.FNC_LOAD_PCR',PKG_MCRE0_AUDIT.C_DEBUG,SQLCODE,SQLERRM,'SCSB - END');
IF(VAL_OK=KO)THEN
raise e_invalid_pcr;
END IF;
-- fase2: determino i contributi attivi di GESB
PKG_MCRE0_AUDIT.LOG_ETL(V_COD_LOG,'PKG_MCRE0_PCR3.FNC_LOAD_PCR',PKG_MCRE0_AUDIT.C_DEBUG,SQLCODE,SQLERRM,'GESB - START');
val_ok := fnc_load_pcr_gesb_merge(V_COD_LOG);
PKG_MCRE0_AUDIT.LOG_ETL(V_COD_LOG,'PKG_MCRE0_PCR3.FNC_LOAD_PCR',PKG_MCRE0_AUDIT.C_DEBUG,SQLCODE,SQLERRM,'GESB - END');
if(val_ok=ko)then
raise e_invalid_pcr;
end if;
-- fase3: determino i contributi attivi di GB
PKG_MCRE0_AUDIT.LOG_ETL(V_COD_LOG,'PKG_MCRE0_PCR3.FNC_LOAD_PCR',PKG_MCRE0_AUDIT.C_DEBUG,SQLCODE,SQLERRM,'GB - START');
val_ok := fnc_load_pcr_gb_merge(V_COD_LOG);
PKG_MCRE0_AUDIT.LOG_ETL(V_COD_LOG,'PKG_MCRE0_PCR3.FNC_LOAD_PCR',PKG_MCRE0_AUDIT.C_DEBUG,SQLCODE,SQLERRM,'GB - END');
IF(VAL_OK=KO)THEN
raise e_invalid_pcr;
END IF;
-- fase4: insert in tabella WRK
PKG_MCRE0_AUDIT.LOG_ETL(V_COD_LOG,'PKG_MCRE0_PCR3.FNC_LOAD_PCR',PKG_MCRE0_AUDIT.C_DEBUG,SQLCODE,SQLERRM,'WRK - START');
val_ok := fnc_load_pcr_wrk(V_COD_LOG);
PKG_MCRE0_AUDIT.LOG_ETL(V_COD_LOG,'PKG_MCRE0_PCR3.FNC_LOAD_PCR',PKG_MCRE0_AUDIT.C_DEBUG,SQLCODE,SQLERRM,'WRK - END');
IF(VAL_OK=KO)THEN
raise e_invalid_pcr;
END IF;

-- fase5: SWAP tabella WRK con PCR + create indice PK + drop indice WRK
PKG_MCRE0_AUDIT.LOG_ETL(V_COD_LOG,'PKG_MCRE0_PCR3.FNC_LOAD_PCR',PKG_MCRE0_AUDIT.C_DEBUG,SQLCODE,SQLERRM,'SWAP - START');
val_ok := fnc_swap_pcr_wrk(V_COD_LOG);
PKG_MCRE0_AUDIT.LOG_ETL(V_COD_LOG,'PKG_MCRE0_PCR3.FNC_LOAD_PCR',PKG_MCRE0_AUDIT.C_DEBUG,SQLCODE,SQLERRM,'SWAP - END');
IF(VAL_OK=KO)THEN
raise e_invalid_pcr;
END IF;


return ok;

EXCEPTION
WHEN e_invalid_pcr THEN
PKG_MCRE0_AUDIT.LOG_ETL(V_COD_LOG,'PKG_MCRE0_PCR3.FNC_LOAD_PCR',PKG_MCRE0_AUDIT.C_ERROR,SQLCODE,SQLERRM,'e_invalid_pcr - SQLERRM='||SQLERRM);
return ok;

WHEN OTHERS THEN
PKG_MCRE0_AUDIT.LOG_ETL(V_COD_LOG,'PKG_MCRE0_PCR3.FNC_LOAD_PCR',PKG_MCRE0_AUDIT.C_ERROR,SQLCODE,SQLERRM,'GENERALE - SQLERRM='||SQLERRM);
return ko;
end;

-- Procedura per calcolo pcr scsb usando la MERGE
-- INPUT :
-- OUTPUT :
-- stato esecuzione 1 OK 0 Errori
FUNCTION fnc_load_pcr_scsb_merge (
P_COD_LOG T_MCRE0_WRK_AUDIT_ETL.ID%TYPE DEFAULT NULL )
RETURN NUMBER IS

V_COD_LOG T_MCRE0_WRK_AUDIT_ETL.ID%TYPE;

begin

IF( P_COD_LOG IS NULL) THEN
SELECT SEQ_MCR0_LOG_ETL.NEXTVAL
INTO V_COD_LOG
FROM DUAL;
ELSE
V_COD_LOG := P_COD_LOG;
end if;


execute immediate 'truncate table mcre_own.T_MCRE0_APP_PCR_SCSB_MRG reuse storage';
PKG_MCRE0_AUDIT.LOG_ETL(V_COD_LOG,'PKG_MCRE0_PCR3.FNC_LOAD_PCR_SCSB_MERGE',PKG_MCRE0_AUDIT.C_DEBUG,SQLCODE,SQLERRM,'SCSB - truncate completed');

insert  /*+append*/ into mcre_own.T_MCRE0_APP_PCR_SCSB_MRG --mcre_own.GTT_pcr_scsb_mrg
select ID_DPER_SCSB, FLG_LAST_RUN, ID_DPER, COD_ABI_ISTITUTO, COD_ABI_CARTOLARIZZATO, COD_NDG, COD_SNDG,
SCSB_ACC_CONSEGNE, SCSB_ACC_CONSEGNE_DT, SCSB_UTI_CONSEGNE, SCSB_UTI_CONSEGNE_DT, SCSB_UTI_MASSIMALI, SCSB_UTI_SOSTITUZIONI, SCSB_UTI_RISCHI_INDIRETTI, SCSB_UTI_MASSIMALI_DT, SCSB_UTI_SOSTITUZIONI_DT, SCSB_UTI_RISCHI_INDIRETTI_DT, SCSB_ACC_MASSIMALI, SCSB_ACC_SOSTITUZIONI, SCSB_ACC_RISCHI_INDIRETTI, SCSB_ACC_MASSIMALI_DT, SCSB_ACC_SOSTITUZIONI_DT, SCSB_ACC_RISCHI_INDIRETTI_DT, SCSB_UTI_CASSA, SCSB_UTI_FIRMA, SCSB_UTI_TOT, SCSB_ACC_CASSA, SCSB_ACC_FIRMA, SCSB_ACC_TOT, SCSB_UTI_CASSA_BT, SCSB_UTI_CASSA_MLT, SCSB_UTI_SMOBILIZZO, SCSB_UTI_FIRMA_DT, SCSB_ACC_CASSA_BT, SCSB_ACC_CASSA_MLT, SCSB_ACC_SMOBILIZZO, SCSB_ACC_FIRMA_DT, SCSB_TOT_GAR, SCSB_DTA_RIFERIMENTO,
DTA_INS, DTA_UPD,my_rnk
from
(
select rank() over (partition by --COD_ABI_ISTITUTO,
COD_NDG,COD_ABI_CARTOLARIZZATO order by ID_DPER_SCSB desc) my_rnk,
COD_ABI_ISTITUTO              ,
COD_ABI_CARTOLARIZZATO        ,
COD_NDG                       ,
COD_SNDG                      ,
ID_DPER_SCSB                  ,
FLG_LAST_RUN,
ID_DPER                       ,
case when ID_DPER_SCSB<ID_DPER then NULL else SCSB_ACC_CONSEGNE end        SCSB_ACC_CONSEGNE,
case when ID_DPER_SCSB<ID_DPER then NULL else SCSB_ACC_CONSEGNE_DT         end SCSB_ACC_CONSEGNE_DT        ,
case when ID_DPER_SCSB<ID_DPER then NULL else SCSB_UTI_CONSEGNE            end SCSB_UTI_CONSEGNE           ,
case when ID_DPER_SCSB<ID_DPER then NULL else SCSB_UTI_CONSEGNE_DT         end SCSB_UTI_CONSEGNE_DT        ,
case when ID_DPER_SCSB<ID_DPER then NULL else SCSB_UTI_MASSIMALI           end SCSB_UTI_MASSIMALI          ,
case when ID_DPER_SCSB<ID_DPER then NULL else SCSB_UTI_SOSTITUZIONI        end SCSB_UTI_SOSTITUZIONI       ,
case when ID_DPER_SCSB<ID_DPER then NULL else SCSB_UTI_RISCHI_INDIRETTI    end SCSB_UTI_RISCHI_INDIRETTI   ,
case when ID_DPER_SCSB<ID_DPER then NULL else SCSB_UTI_MASSIMALI_DT        end SCSB_UTI_MASSIMALI_DT       ,
case when ID_DPER_SCSB<ID_DPER then NULL else SCSB_UTI_SOSTITUZIONI_DT     end SCSB_UTI_SOSTITUZIONI_DT    ,
case when ID_DPER_SCSB<ID_DPER then NULL else SCSB_UTI_RISCHI_INDIRETTI_DT end SCSB_UTI_RISCHI_INDIRETTI_DT,
case when ID_DPER_SCSB<ID_DPER then NULL else SCSB_ACC_MASSIMALI           end SCSB_ACC_MASSIMALI          ,
case when ID_DPER_SCSB<ID_DPER then NULL else SCSB_ACC_SOSTITUZIONI        end SCSB_ACC_SOSTITUZIONI       ,
case when ID_DPER_SCSB<ID_DPER then NULL else SCSB_ACC_RISCHI_INDIRETTI    end SCSB_ACC_RISCHI_INDIRETTI   ,
case when ID_DPER_SCSB<ID_DPER then NULL else SCSB_ACC_MASSIMALI_DT        end SCSB_ACC_MASSIMALI_DT       ,
case when ID_DPER_SCSB<ID_DPER then NULL else SCSB_ACC_SOSTITUZIONI_DT     end SCSB_ACC_SOSTITUZIONI_DT    ,
case when ID_DPER_SCSB<ID_DPER then NULL else SCSB_ACC_RISCHI_INDIRETTI_DT end SCSB_ACC_RISCHI_INDIRETTI_DT,
case when ID_DPER_SCSB<ID_DPER then NULL else SCSB_UTI_CASSA               end SCSB_UTI_CASSA              ,
case when ID_DPER_SCSB<ID_DPER then NULL else SCSB_UTI_FIRMA               end SCSB_UTI_FIRMA              ,
case when ID_DPER_SCSB<ID_DPER then NULL else SCSB_UTI_TOT                 end SCSB_UTI_TOT                ,
case when ID_DPER_SCSB<ID_DPER then NULL else SCSB_ACC_CASSA               end SCSB_ACC_CASSA              ,
case when ID_DPER_SCSB<ID_DPER then NULL else SCSB_ACC_FIRMA               end SCSB_ACC_FIRMA              ,
case when ID_DPER_SCSB<ID_DPER then NULL else SCSB_ACC_TOT                 end SCSB_ACC_TOT                ,
case when ID_DPER_SCSB<ID_DPER then NULL else SCSB_UTI_CASSA_BT            end SCSB_UTI_CASSA_BT           ,
case when ID_DPER_SCSB<ID_DPER then NULL else SCSB_UTI_CASSA_MLT           end SCSB_UTI_CASSA_MLT          ,
case when ID_DPER_SCSB<ID_DPER then NULL else SCSB_UTI_SMOBILIZZO          end SCSB_UTI_SMOBILIZZO         ,
case when ID_DPER_SCSB<ID_DPER then NULL else SCSB_UTI_FIRMA_DT            end SCSB_UTI_FIRMA_DT           ,
case when ID_DPER_SCSB<ID_DPER then NULL else SCSB_ACC_CASSA_BT            end SCSB_ACC_CASSA_BT           ,
case when ID_DPER_SCSB<ID_DPER then NULL else SCSB_ACC_CASSA_MLT           end SCSB_ACC_CASSA_MLT          ,
case when ID_DPER_SCSB<ID_DPER then NULL else SCSB_ACC_SMOBILIZZO          end SCSB_ACC_SMOBILIZZO         ,
case when ID_DPER_SCSB<ID_DPER then NULL else SCSB_ACC_FIRMA_DT            end SCSB_ACC_FIRMA_DT           ,
case when ID_DPER_SCSB<ID_DPER then NULL else SCSB_TOT_GAR                 end SCSB_TOT_GAR                ,
case when ID_DPER_SCSB<ID_DPER then NULL else SCSB_DTA_RIFERIMENTO         end SCSB_DTA_RIFERIMENTO        ,
DTA_INS                      ,
DTA_UPD
from
(
SELECT pcr.id_dper id_dper_scsb,pcr.FLG_LAST_RUN,
xx.id_dper,
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
sysdate dta_ins,   sysdate dta_upd
FROM (SELECT cod_abi_istituto, cod_ndg, pcr.id_dper,r.FLG_LAST_RUN,
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
FROM t_mcre0_app_pcr_sc_sb24 pcr,
T_MCRE0_APP_NATURA_FTECNICA CL,
(SELECT id_dper,
CASE WHEN RANK () OVER (ORDER BY id_dper DESC) = 1 THEN 1 ELSE 0 END flg_last_run
FROM (  SELECT DISTINCT ID_DPER
FROM T_MCRE0_APP_PCR_GB24
ORDER BY ID_DPER DESC)
WHERE ROWNUM < 3) r
WHERE PCR.COD_FORMA_TECNICA = CL.COD_FTECNICA
and pcr.id_dper =r.id_dper
GROUP BY PCR.COD_ABI_ISTITUTO, PCR.COD_NDG, PCR.ID_DPER,R.FLG_LAST_RUN) pcr ,
(select cod_sndg, COD_ABI_CARTOLARIZZATO, COD_ABI_ISTITUTO,COD_NDG,id_dper
from t_mcre0_app_file_guida24 f
where f.id_dper = (SELECT a.idper
FROM v_mcre0_ultima_acquisizione a
WHERE A.COD_FILE = 'FILE_GUIDA')) XX
WHERE XX.COD_ABI_ISTITUTO = pcr.COD_ABI_ISTITUTO
and xx.COD_NDG = pcr.cod_ndg)
)
where my_rnk=1;


commit;
PKG_MCRE0_AUDIT.LOG_ETL(V_COD_LOG,'PKG_MCRE0_PCR3.FNC_LOAD_PCR_SCSB_MERGE',PKG_MCRE0_AUDIT.C_DEBUG,SQLCODE,SQLERRM,'SCSB - insert completed');

return ok;

EXCEPTION
WHEN OTHERS THEN
PKG_MCRE0_AUDIT.LOG_ETL(V_COD_LOG,'PKG_MCRE0_PCR3.FNC_LOAD_PCR_SCSB_MERGE',PKG_MCRE0_AUDIT.C_ERROR,SQLCODE,SQLERRM,'SCSB - SQLERRM='||SQLERRM);
return ko;
end;

-- Procedura per calcolo pcr gesb usando la MERGE
-- INPUT :
-- OUTPUT :
-- stato esecuzione 1 OK 0 Errori
FUNCTION fnc_load_pcr_gesb_merge (
P_COD_LOG T_MCRE0_WRK_AUDIT_ETL.ID%TYPE DEFAULT NULL )
RETURN NUMBER IS

V_COD_LOG T_MCRE0_WRK_AUDIT_ETL.ID%TYPE;

begin

IF( P_COD_LOG IS NULL) THEN
SELECT SEQ_MCR0_LOG_ETL.NEXTVAL
INTO V_COD_LOG
FROM DUAL;
ELSE
V_COD_LOG := P_COD_LOG;
end if;

execute immediate 'truncate table mcre_own.T_MCRE0_APP_PCR_GESB_MRG reuse storage';
PKG_MCRE0_AUDIT.LOG_ETL(V_COD_LOG,'PKG_MCRE0_PCR3.FNC_LOAD_PCR_GESB_MERGE',PKG_MCRE0_AUDIT.C_DEBUG,SQLCODE,SQLERRM,'GESB - truncate completed');

insert /*+append*/  into mcre_own.T_MCRE0_APP_PCR_GESB_MRG
select ID_DPER_GESB,FLG_LAST_RUN,ID_DPER,COD_ABI_ISTITUTO,COD_ABI_CARTOLARIZZATO,COD_NDG,COD_SNDG,GESB_ACC_CONSEGNE,GESB_ACC_CONSEGNE_DT,GESB_UTI_CONSEGNE,GESB_UTI_CONSEGNE_DT,GESB_UTI_SOSTITUZIONI,GESB_UTI_MASSIMALI,GESB_UTI_RISCHI_INDIRETTI,GESB_UTI_SOSTITUZIONI_DT,GESB_UTI_MASSIMALI_DT,GESB_UTI_RISCHI_INDIRETTI_DT,GESB_ACC_SOSTITUZIONI,GESB_ACC_MASSIMALI,GESB_ACC_RISCHI_INDIRETTI,GESB_ACC_SOSTITUZIONI_DT,GESB_ACC_MASSIMALI_DT,GESB_ACC_RISCHI_INDIRETTI_DT,GESB_UTI_CASSA,GESB_UTI_FIRMA,GESB_ACC_CASSA,GESB_ACC_FIRMA,GESB_UTI_CASSA_BT,GESB_UTI_CASSA_MLT,GESB_UTI_SMOBILIZZO,GESB_UTI_FIRMA_DT,GESB_ACC_CASSA_BT,GESB_ACC_CASSA_MLT,GESB_ACC_SMOBILIZZO,GESB_ACC_FIRMA_DT,GESB_TOT_GAR,GESB_DTA_RIFERIMENTO,GESB_ACC_TOT,GESB_UTI_TOT,DTA_INS,DTA_UPD
from
(
select pcr.id_dper id_dper_gesb,1 FLG_LAST_RUN,xx.id_dper,
gesb_acc_consegne,
gesb_acc_consegne_dt,
gesb_uti_consegne,
gesb_uti_consegne_dt,
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
gesb_uti_cassa    ,
gesb_uti_firma    ,
gesb_acc_cassa ,
gesb_acc_firma    ,
gesb_uti_cassa_bt    ,
gesb_uti_cassa_mlt    ,
gesb_uti_smobilizzo    ,
gesb_uti_firma_dt    ,
gesb_acc_cassa_bt    ,
gesb_acc_cassa_mlt    ,
gesb_acc_smobilizzo    ,
gesb_acc_firma_dt    ,
gesb_tot_gar,
gesb_dta_riferimento,
gesb_acc_cassa+gesb_acc_firma gesb_acc_tot,
gesb_uti_cassa+gesb_uti_firma gesb_uti_tot,
xx.cod_sndg, xx.cod_abi_istituto,
xx.cod_ndg,cod_abi_cartolarizzato,
sysdate dta_ins, sysdate dta_upd
from
(
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
FROM t_mcre0_app_pcr_ge_sb24 pcr,
t_mcre0_app_natura_ftecnica cl,
mcre_own.t_mcre0_app_gruppo_economico24 ge
WHERE pcr.cod_forma_tecn = cl.cod_ftecnica
AND PCR.COD_SNDG = GE.COD_SNDG
AND pcr.id_dper =(SELECT a.idper
FROM V_MCRE0_ULTIMA_ACQUISIZIONE A
WHERE a.cod_file = 'PCR_GE_SB')
GROUP BY pcr.cod_abi_istituto,
pcr.cod_sndg,
ge.cod_gruppo_economico,
PCR.ID_DPER) pcr ,
(select id_dper, cod_sndg, COD_ABI_CARTOLARIZZATO,
COD_ABI_ISTITUTO,COD_NDG
from T_MCRE0_APP_FILE_GUIDA24 f
WHERE f.id_dper = (SELECT a.idper
FROM V_MCRE0_ULTIMA_ACQUISIZIONE A
WHERE a.cod_file = 'FILE_GUIDA')) xx
where xx.cod_sndg = pcr.cod_sndg
and xx.cod_abi_istituto = pcr.cod_abi_istituto);


commit;
PKG_MCRE0_AUDIT.LOG_ETL(V_COD_LOG,'PKG_MCRE0_PCR3.FNC_LOAD_PCR_GESB_MERGE',PKG_MCRE0_AUDIT.C_DEBUG,SQLCODE,SQLERRM,'GESB - insert completed');

return ok;

EXCEPTION
WHEN OTHERS THEN
PKG_MCRE0_AUDIT.LOG_ETL(V_COD_LOG,'PKG_MCRE0_PCR3.FNC_LOAD_PCR_GESB_MERGE',PKG_MCRE0_AUDIT.C_ERROR,SQLCODE,SQLERRM,'GESB - SQLERRM='||SQLERRM);
return ko;
end;

-- Procedura per calcolo pcr gb usando la MERGE
-- INPUT :
-- OUTPUT :
-- stato esecuzione 1 OK 0 Errori
FUNCTION fnc_load_pcr_gb_merge (
P_COD_LOG T_MCRE0_WRK_AUDIT_ETL.ID%TYPE DEFAULT NULL )
RETURN NUMBER IS

V_COD_LOG T_MCRE0_WRK_AUDIT_ETL.ID%TYPE;

begin

IF( P_COD_LOG IS NULL) THEN
SELECT SEQ_MCR0_LOG_ETL.NEXTVAL
INTO V_COD_LOG
FROM DUAL;
ELSE
V_COD_LOG := P_COD_LOG;
end if;




insert into mcre_own.GTT_PCR_GB_MRG
SELECT pcr.cod_sndg,
pcr.id_dper id_dper,
1 FLG_LAST_RUN,
MAX (val_imp_gar_gre) gegb_tot_gar,
MAX (val_imp_gar_cli) scgb_tot_gar,
MAX (val_imp_gar_leg) glgb_tot_gar,
SUM (
CASE
WHEN cl.cod_classe_appl_cf = 'CO'
THEN
pcr.val_imp_uti_gre
ELSE
0
END)
gegb_uti_CONSEGNE,
SUM (
CASE
WHEN cl.cod_classe_appl_cf = 'CO'
THEN
pcr.val_imp_uti_gre
ELSE
0
END)
gegb_uti_CONSEGNE_DT,
SUM (
CASE
WHEN cl.cod_classe_appl_cf = 'CO'
THEN
pcr.val_imp_ACC_gre
ELSE
0
END)
gegb_ACC_CONSEGNE,
SUM (
CASE
WHEN cl.cod_classe_appl_cf = 'CO'
THEN
pcr.val_imp_ACC_gre
ELSE
0
END)
gegb_ACC_CONSEGNE_DT,
SUM (
CASE
WHEN cl.cod_classe_appl_cf = 'CO'
THEN
pcr.val_imp_uti_CLI
ELSE
0
END)
SCgb_uti_CONSEGNE,
SUM (
CASE
WHEN cl.cod_classe_appl_cf = 'CO'
THEN
pcr.val_imp_uti_CLI
ELSE
0
END)
SCgb_uti_CONSEGNE_DT,
SUM (
CASE
WHEN cl.cod_classe_appl_cf = 'CO'
THEN
pcr.val_imp_ACC_CLI
ELSE
0
END)
SCgb_ACC_CONSEGNE,
SUM (
CASE
WHEN cl.cod_classe_appl_cf = 'CO'
THEN
pcr.val_imp_ACC_CLI
ELSE
0
END)
SCgb_ACC_CONSEGNE_DT,
SUM (
CASE
WHEN cl.cod_classe_appl_cf = 'CO'
THEN
pcr.val_imp_uti_LEG
ELSE
0
END)
GLgb_uti_CONSEGNE,
SUM (
CASE
WHEN cl.cod_classe_appl_cf = 'CO'
THEN
pcr.val_imp_uti_LEG
ELSE
0
END)
GLgb_uti_CONSEGNE_DT,
SUM (
CASE
WHEN cl.cod_classe_appl_cf = 'CO'
THEN
pcr.val_imp_ACC_LEG
ELSE
0
END)
GLgb_ACC_CONSEGNE,
SUM (
CASE
WHEN cl.cod_classe_appl_cf = 'CO'
THEN
pcr.val_imp_ACC_LEG
ELSE
0
END)
GLgb_ACC_CONSEGNE_DT,
SUM (
CASE
WHEN cl.cod_classe_appl_cf = 'ST'
THEN
pcr.val_imp_uti_gre
ELSE
0
END)
gegb_uti_sostituzioni,
SUM (
CASE
WHEN cl.cod_classe_appl_cf = 'MS'
THEN
pcr.val_imp_uti_gre
ELSE
0
END)
gegb_uti_massimali,
SUM (
CASE
WHEN cl.cod_classe_appl_cf = 'RI'
THEN
pcr.val_imp_uti_gre
ELSE
0
END)
gegb_uti_rischi_indiretti,
SUM (
CASE
WHEN cl.cod_classe_appl_cf = 'ST'
THEN
pcr.val_imp_acc_gre
ELSE
0
END)
gegb_acc_sostituzioni,
SUM (
CASE
WHEN cl.cod_classe_appl_cf = 'MS'
THEN
pcr.val_imp_acc_gre
ELSE
0
END)
gegb_acc_massimali,
SUM (
CASE
WHEN cl.cod_classe_appl_cf = 'RI'
THEN
pcr.val_imp_acc_gre
ELSE
0
END)
gegb_acc_rischi_indiretti,
SUM (
CASE
WHEN cl.cod_classe_appl_cf = 'ST'
THEN
pcr.val_imp_uti_gre
ELSE
0
END)
gegb_uti_sostituzioni_dt,
SUM (
CASE
WHEN cl.cod_classe_appl_cf = 'MS'
THEN
pcr.val_imp_uti_gre
ELSE
0
END)
gegb_uti_massimali_dt,
SUM (
CASE
WHEN cl.cod_classe_appl_cf = 'RI'
THEN
pcr.val_imp_uti_gre
ELSE
0
END)
gegb_uti_rischi_indiretti_dt,
SUM (
CASE
WHEN cl.cod_classe_appl_cf = 'ST'
THEN
pcr.val_imp_acc_gre
ELSE
0
END)
gegb_acc_sostituzioni_dt,
SUM (
CASE
WHEN cl.cod_classe_appl_cf = 'MS'
THEN
pcr.val_imp_acc_gre
ELSE
0
END)
gegb_acc_massimali_dt,
SUM (
CASE
WHEN cl.cod_classe_appl_cf = 'RI'
THEN
pcr.val_imp_acc_gre
ELSE
0
END)
gegb_acc_rischi_indiretti_dt,
SUM (
CASE
WHEN cl.cod_classe_appl_cf = 'ST'
THEN
pcr.val_imp_uti_cli
ELSE
0
END)
scgb_uti_sostituzioni,
SUM (
CASE
WHEN cl.cod_classe_appl_cf = 'MS'
THEN
pcr.val_imp_uti_cli
ELSE
0
END)
scgb_uti_massimali,
SUM (
CASE
WHEN cl.cod_classe_appl_cf = 'RI'
THEN
pcr.val_imp_uti_cli
ELSE
0
END)
scgb_uti_rischi_indiretti,
SUM (
CASE
WHEN cl.cod_classe_appl_cf = 'ST'
THEN
pcr.val_imp_acc_cli
ELSE
0
END)
scgb_acc_sostituzioni,
SUM (
CASE
WHEN cl.cod_classe_appl_cf = 'MS'
THEN
pcr.val_imp_acc_cli
ELSE
0
END)
scgb_acc_massimali,
SUM (
CASE
WHEN CL.COD_CLASSE_APPL_CF = 'RI'
THEN
pcr.val_imp_acc_cli
ELSE
0
END)
scgb_acc_rischi_indiretti,
SUM (
CASE
WHEN cl.cod_classe_appl_cf = 'ST'
THEN
pcr.val_imp_uti_cli
ELSE
0
END)
scgb_uti_sostituzioni_dt,
SUM (
CASE
WHEN cl.cod_classe_appl_cf = 'MS'
THEN
pcr.val_imp_uti_cli
ELSE
0
END)
scgb_uti_massimali_dt,
SUM (
CASE
WHEN cl.cod_classe_appl_cf = 'RI'
THEN
pcr.val_imp_uti_cli
ELSE
0
END)
scgb_uti_rischi_indiretti_dt,
SUM (
CASE
WHEN cl.cod_classe_appl_cf = 'ST'
THEN
pcr.val_imp_acc_cli
ELSE
0
END)
scgb_acc_sostituzioni_dt,
SUM (
CASE
WHEN cl.cod_classe_appl_cf = 'MS'
THEN
pcr.val_imp_acc_cli
ELSE
0
END)
scgb_acc_massimali_dt,
SUM (
CASE
WHEN cl.cod_classe_appl_cf = 'RI'
THEN
pcr.val_imp_acc_cli
ELSE
0
END)
scgb_acc_rischi_indiretti_dt,
SUM (
CASE
WHEN cl.cod_classe_appl_cf = 'ST'
THEN
pcr.val_imp_uti_leg
ELSE
0
END)
glgb_uti_sostituzioni,
SUM (
CASE
WHEN cl.cod_classe_appl_cf = 'MS'
THEN
pcr.val_imp_uti_leg
ELSE
0
END)
glgb_uti_massimali,
SUM (
CASE
WHEN cl.cod_classe_appl_cf = 'RI'
THEN
pcr.val_imp_uti_leg
ELSE
0
END)
glgb_uti_rischi_indiretti,
SUM (
CASE
WHEN cl.cod_classe_appl_cf = 'ST'
THEN
pcr.val_imp_acc_leg
ELSE
0
END)
glgb_acc_sostituzioni,
SUM (
CASE
WHEN cl.cod_classe_appl_cf = 'MS'
THEN
pcr.val_imp_acc_leg
ELSE
0
END)
glgb_acc_massimali,
SUM (
CASE
WHEN cl.cod_classe_appl_cf = 'RI'
THEN
pcr.val_imp_acc_leg
ELSE
0
END)
glgb_acc_rischi_indiretti,
SUM (
CASE
WHEN cl.cod_classe_appl_cf = 'ST'
THEN
pcr.val_imp_uti_leg
ELSE
0
END)
glgb_uti_sostituzioni_dt,
SUM (
CASE
WHEN cl.cod_classe_appl_cf = 'MS'
THEN
pcr.val_imp_uti_leg
ELSE
0
END)
glgb_uti_massimali_dt,
SUM (
CASE
WHEN cl.cod_classe_appl_cf = 'RI'
THEN
pcr.val_imp_uti_leg
ELSE
0
END)
glgb_uti_rischi_indiretti_dt,
SUM (
CASE
WHEN cl.cod_classe_appl_cf = 'ST'
THEN
pcr.val_imp_acc_leg
ELSE
0
END)
glgb_acc_sostituzioni_dt,
SUM (
CASE
WHEN cl.cod_classe_appl_cf = 'MS'
THEN
pcr.val_imp_acc_leg
ELSE
0
END)
glgb_acc_massimali_dt,
SUM (
CASE
WHEN cl.cod_classe_appl_cf = 'RI'
THEN
pcr.val_imp_acc_leg
ELSE
0
END)
glgb_acc_rischi_indiretti_dt,
---------------------------------------- OLD
SUM (
CASE
WHEN cl.cod_classe_appl_cf = 'CA'
THEN
pcr.val_imp_uti_cli
ELSE
0
END)
scgb_uti_cassa,
SUM (
CASE
WHEN cl.cod_classe_appl_cf = 'FI'
THEN
pcr.val_imp_uti_cli
ELSE
0
END)
scgb_uti_firma,
SUM (
CASE
WHEN cl.cod_classe_appl_cf = 'CA'
THEN
pcr.val_imp_acc_cli
ELSE
0
END)
scgb_acc_cassa,
SUM (
CASE
WHEN cl.cod_classe_appl_cf = 'FI'
THEN
pcr.val_imp_acc_cli
ELSE
0
END)
scgb_acc_firma,
SUM (
CASE
WHEN cl.cod_classe_appl_dett = 'CB'
THEN
pcr.val_imp_uti_cli
ELSE
0
END)
scgb_uti_cassa_bt,
SUM (
CASE
WHEN cl.cod_classe_appl_dett = 'CM'
THEN
pcr.val_imp_uti_cli
ELSE
0
END)
scgb_uti_cassa_mlt,
SUM (
CASE
WHEN cl.cod_classe_appl_dett = 'SM'
THEN
pcr.val_imp_uti_cli
ELSE
0
END)
scgb_uti_smobilizzo,
SUM (
CASE
WHEN cl.cod_classe_appl_dett = 'FI'
THEN
pcr.val_imp_uti_cli
ELSE
0
END)
scgb_uti_firma_dt,
SUM (
CASE
WHEN cl.cod_classe_appl_dett = 'CB'
THEN
pcr.val_imp_acc_cli
ELSE
0
END)
scgb_acc_cassa_bt,
SUM (
CASE
WHEN CL.COD_CLASSE_APPL_DETT = 'C'
THEN
pcr.val_imp_acc_cli
ELSE
0
END)
scgb_acc_cassa_mlt,
SUM (
CASE
WHEN cl.cod_classe_appl_dett = 'SM'
THEN
pcr.val_imp_acc_cli
ELSE
0
END)
scgb_acc_smobilizzo,
SUM (
CASE
WHEN cl.cod_classe_appl_dett = 'FI'
THEN
pcr.val_imp_acc_cli
ELSE
0
END)
scgb_acc_firma_dt,
SUM (
CASE
WHEN cl.cod_classe_appl_cf = 'CA'
THEN
pcr.val_imp_uti_gre
ELSE
0
END)
gegb_uti_cassa,
SUM (
CASE
WHEN cl.cod_classe_appl_cf = 'FI'
THEN
pcr.val_imp_uti_gre
ELSE
0
END)
gegb_uti_firma,
SUM (
CASE
WHEN cl.cod_classe_appl_cf = 'CA'
THEN
pcr.val_imp_acc_gre
ELSE
0
END)
gegb_acc_cassa,
SUM (
CASE
WHEN cl.cod_classe_appl_cf = 'FI'
THEN
pcr.val_imp_acc_gre
ELSE
0
END)
gegb_acc_firma,
SUM (
CASE
WHEN cl.cod_classe_appl_dett = 'CB'
THEN
pcr.val_imp_uti_gre
ELSE
0
END)
gegb_uti_cassa_bt,
SUM (
CASE
WHEN cl.cod_classe_appl_dett = 'CM'
THEN
pcr.val_imp_uti_gre
ELSE
0
END)
gegb_uti_cassa_mlt,
SUM (
CASE
WHEN cl.cod_classe_appl_dett = 'SM'
THEN
pcr.val_imp_uti_gre
ELSE
0
END)
gegb_uti_smobilizzo,
SUM (
CASE
WHEN CL.COD_CLASSE_APPL_DETT = 'FI'
THEN
pcr.val_imp_uti_gre
ELSE
0
END)
gegb_uti_firma_dt,
SUM (
CASE
WHEN cl.cod_classe_appl_dett = 'CB'
THEN
pcr.val_imp_acc_gre
ELSE
0
END)
gegb_acc_cassa_bt,
SUM (
CASE
WHEN cl.cod_classe_appl_dett = 'CM'
THEN
pcr.val_imp_acc_gre
ELSE
0
END)
gegb_acc_cassa_mlt,
SUM (
CASE
WHEN cl.cod_classe_appl_dett = 'SM'
THEN
pcr.val_imp_acc_gre
ELSE
0
END)
gegb_acc_smobilizzo,
SUM (
CASE
WHEN cl.cod_classe_appl_dett = 'FI'
THEN
pcr.val_imp_acc_gre
ELSE
0
END)
gegb_acc_firma_dt,
SUM (
CASE
WHEN cl.cod_classe_appl_cf = 'CA'
THEN
pcr.val_imp_uti_leg
ELSE
0
END)
glgb_uti_cassa,
SUM (
CASE
WHEN cl.cod_classe_appl_cf = 'FI'
THEN
pcr.val_imp_uti_leg
ELSE
0
END)
glgb_uti_firma,
SUM (
CASE
WHEN cl.cod_classe_appl_cf = 'CA'
THEN
pcr.val_imp_acc_leg
ELSE
0
END)
glgb_acc_cassa,
SUM (
CASE
WHEN cl.cod_classe_appl_cf = 'FI'
THEN
pcr.val_imp_acc_leg
ELSE
0
END)
glgb_acc_firma,
SUM (
CASE
WHEN cl.cod_classe_appl_dett = 'CB'
THEN
pcr.val_imp_uti_leg
ELSE
0
END)
glgb_uti_cassa_bt,
SUM (
CASE
WHEN cl.cod_classe_appl_dett = 'CM'
THEN
pcr.val_imp_uti_leg
ELSE
0
END)
glgb_uti_cassa_mlt,
SUM (
CASE
WHEN cl.cod_classe_appl_dett = 'SM'
THEN
pcr.val_imp_uti_leg
ELSE
0
END)
glgb_uti_smobilizzo,
SUM (
CASE
WHEN cl.cod_classe_appl_dett = 'FI'
THEN
pcr.val_imp_uti_leg
ELSE
0
END)
glgb_uti_firma_dt,
SUM (
CASE
WHEN cl.cod_classe_appl_dett = 'CB'
THEN
pcr.val_imp_acc_leg
ELSE
0
END)
glgb_acc_cassa_bt,
SUM (
CASE
WHEN cl.cod_classe_appl_dett = 'CM'
THEN
pcr.val_imp_acc_leg
ELSE
0
END)
glgb_acc_cassa_mlt,
SUM (
CASE
WHEN cl.cod_classe_appl_dett = 'SM'
THEN
pcr.val_imp_acc_leg
ELSE
0
END)
glgb_acc_smobilizzo,
SUM (
CASE
WHEN cl.cod_classe_appl_dett = 'FI'
THEN
pcr.val_imp_acc_leg
ELSE
0
END)
glgb_acc_firma_dt,
MAX (pcr.dta_riferimento) dta_riferimento,
SYSDATE dta_ins,
SYSDATE DTA_UPD
FROM t_mcre0_app_pcr_gb24 pcr,
t_mcre0_app_natura_ftecnica cl
WHERE PCR.COD_FORMA_TECNICA = CL.COD_FTECNICA
AND pcr.id_dper = (SELECT a.idper
FROM V_MCRE0_ULTIMA_ACQUISIZIONE A
WHERE a.cod_file = 'PCR_GB')
GROUP BY PCR.COD_SNDG, PCR.ID_DPER;

commit;
PKG_MCRE0_AUDIT.LOG_ETL(V_COD_LOG,'PKG_MCRE0_PCR3.FNC_LOAD_PCR_GB_MERGE',PKG_MCRE0_AUDIT.C_DEBUG,SQLCODE,SQLERRM,'GB - last run in GTT_PCR_GB_MRG');



insert into mcre_own.GTT_PCR_GB_MRG
select  COD_SNDG                    ,
ID_DPER                       ,
0 FLG_LAST_RUN                  ,
null GEGB_TOT_GAR                  ,
null SCGB_TOT_GAR                  ,
null GLGB_TOT_GAR                  ,
null GEGB_UTI_CONSEGNE             ,
null GEGB_UTI_CONSEGNE_DT          ,
null GEGB_ACC_CONSEGNE             ,
null GEGB_ACC_CONSEGNE_DT          ,
null SCGB_UTI_CONSEGNE             ,
null SCGB_UTI_CONSEGNE_DT          ,
null SCGB_ACC_CONSEGNE             ,
null SCGB_ACC_CONSEGNE_DT          ,
null GLGB_UTI_CONSEGNE             ,
null GLGB_UTI_CONSEGNE_DT          ,
null GLGB_ACC_CONSEGNE             ,
null GLGB_ACC_CONSEGNE_DT          ,
null GEGB_UTI_SOSTITUZIONI         ,
null GEGB_UTI_MASSIMALI            ,
null GEGB_UTI_RISCHI_INDIRETTI     ,
null GEGB_ACC_SOSTITUZIONI         ,
null GEGB_ACC_MASSIMALI            ,
null GEGB_ACC_RISCHI_INDIRETTI     ,
null GEGB_UTI_SOSTITUZIONI_DT      ,
null GEGB_UTI_MASSIMALI_DT         ,
null GEGB_UTI_RISCHI_INDIRETTI_DT  ,
null GEGB_ACC_SOSTITUZIONI_DT      ,
null GEGB_ACC_MASSIMALI_DT         ,
null GEGB_ACC_RISCHI_INDIRETTI_DT  ,
null SCGB_UTI_SOSTITUZIONI         ,
null SCGB_UTI_MASSIMALI            ,
null SCGB_UTI_RISCHI_INDIRETTI     ,
null SCGB_ACC_SOSTITUZIONI         ,
null SCGB_ACC_MASSIMALI            ,
null SCGB_ACC_RISCHI_INDIRETTI     ,
null SCGB_UTI_SOSTITUZIONI_DT      ,
null SCGB_UTI_MASSIMALI_DT         ,
null SCGB_UTI_RISCHI_INDIRETTI_DT  ,
null SCGB_ACC_SOSTITUZIONI_DT      ,
null SCGB_ACC_MASSIMALI_DT         ,
null SCGB_ACC_RISCHI_INDIRETTI_DT  ,
null GLGB_UTI_SOSTITUZIONI         ,
null GLGB_UTI_MASSIMALI            ,
null GLGB_UTI_RISCHI_INDIRETTI     ,
null GLGB_ACC_SOSTITUZIONI         ,
null GLGB_ACC_MASSIMALI            ,
null GLGB_ACC_RISCHI_INDIRETTI     ,
null GLGB_UTI_SOSTITUZIONI_DT      ,
null GLGB_UTI_MASSIMALI_DT         ,
null GLGB_UTI_RISCHI_INDIRETTI_DT  ,
null GLGB_ACC_SOSTITUZIONI_DT      ,
null GLGB_ACC_MASSIMALI_DT         ,
null GLGB_ACC_RISCHI_INDIRETTI_DT  ,
null SCGB_UTI_CASSA                ,
null SCGB_UTI_FIRMA                ,
null SCGB_ACC_CASSA                ,
null SCGB_ACC_FIRMA                ,
null SCGB_UTI_CASSA_BT             ,
null SCGB_UTI_CASSA_MLT            ,
null SCGB_UTI_SMOBILIZZO           ,
null SCGB_UTI_FIRMA_DT             ,
null SCGB_ACC_CASSA_BT             ,
null SCGB_ACC_CASSA_MLT            ,
null SCGB_ACC_SMOBILIZZO           ,
null SCGB_ACC_FIRMA_DT             ,
null GEGB_UTI_CASSA                ,
null GEGB_UTI_FIRMA                ,
null GEGB_ACC_CASSA                ,
null GEGB_ACC_FIRMA                ,
null GEGB_UTI_CASSA_BT             ,
null GEGB_UTI_CASSA_MLT            ,
null GEGB_UTI_SMOBILIZZO           ,
null GEGB_UTI_FIRMA_DT             ,
null GEGB_ACC_CASSA_BT             ,
null GEGB_ACC_CASSA_MLT            ,
null GEGB_ACC_SMOBILIZZO           ,
null GEGB_ACC_FIRMA_DT             ,
null GLGB_UTI_CASSA                ,
null GLGB_UTI_FIRMA                ,
null GLGB_ACC_CASSA                ,
null GLGB_ACC_FIRMA                ,
null GLGB_UTI_CASSA_BT             ,
null GLGB_UTI_CASSA_MLT            ,
null GLGB_UTI_SMOBILIZZO           ,
null GLGB_UTI_FIRMA_DT             ,
null GLGB_ACC_CASSA_BT             ,
null GLGB_ACC_CASSA_MLT            ,
null GLGB_ACC_SMOBILIZZO           ,
null GLGB_ACC_FIRMA_DT             ,
null DTA_RIFERIMENTO               ,
sysdate DTA_INS                    ,
sysdate DTA_UPD
from
(
select cod_sndg,(select MAX (TO_CHAR (periodo_riferimento, 'YYYYMMDD')) idper
FROM mcre_own.t_mcre0_wrk_acquisizione w
WHERE stato = 'CARICATO'
and TO_CHAR (periodo_riferimento, 'YYYYMMDD')<  (SELECT a.idper
FROM V_MCRE0_ULTIMA_ACQUISIZIONE A WHERE a.cod_file = 'PCR_GB')
) id_dper
FROM t_mcre0_app_pcr_gb24 pcr
WHERE id_dper=
(select MAX (TO_CHAR (periodo_riferimento, 'YYYYMMDD')) idper
FROM mcre_own.t_mcre0_wrk_acquisizione w
WHERE stato = 'CARICATO'
and TO_CHAR (periodo_riferimento, 'YYYYMMDD')<  (SELECT a.idper
FROM V_MCRE0_ULTIMA_ACQUISIZIONE A WHERE a.cod_file = 'PCR_GB')
)
minus
select cod_sndg,(select MAX (TO_CHAR (periodo_riferimento, 'YYYYMMDD')) idper
FROM mcre_own.t_mcre0_wrk_acquisizione w
WHERE stato = 'CARICATO'
and TO_CHAR (periodo_riferimento, 'YYYYMMDD')<  (SELECT a.idper
FROM V_MCRE0_ULTIMA_ACQUISIZIONE A WHERE a.cod_file = 'PCR_GB')
) id_dper
from mcre_own.GTT_PCR_GB_MRG
);

commit;
PKG_MCRE0_AUDIT.LOG_ETL(V_COD_LOG,'PKG_MCRE0_PCR3.FNC_LOAD_PCR_GB_MERGE',PKG_MCRE0_AUDIT.C_DEBUG,SQLCODE,SQLERRM,'GB - last run -1 in GTT_PCR_GB_MRG');


execute immediate 'truncate table mcre_own.T_MCRE0_APP_PCR_GB_MRG reuse storage';
PKG_MCRE0_AUDIT.LOG_ETL(V_COD_LOG,'PKG_MCRE0_PCR3.FNC_LOAD_PCR',PKG_MCRE0_AUDIT.C_DEBUG,SQLCODE,SQLERRM,'GB - truncate completed');


INSERT /*+append*/
INTO   mcre_own.T_MCRE0_APP_PCR_GB_MRG
SELECT gb.ID_DPER ID_DPER_GB,
FLG_LAST_RUN,
TODAY_FLG,
COD_ABI_ISTITUTO,
COD_ABI_CARTOLARIZZATO,
COD_NDG,
f.COD_SNDG,
null   FLG_SNDG_GE,--nolonger used
f.ID_DPER,
case when f.cod_gruppo_economico is null then 0 else 1 end flg_gruppo_economico, --nvl( (select  decode (ge.cod_gruppo_economico, null, '0', '1')  from mcre_own.t_mcre0_app_gruppo_economico ge where f.cod_sndg = ge.cod_sndg(+) ),'0') flg_gruppo_economico,
f.cod_gruppo_economico, --(select  ge.cod_gruppo_economico from mcre_own.t_mcre0_app_gruppo_economico ge where f.cod_sndg = ge.cod_sndg(+) ) cod_gruppo_economico,
case when f.cod_gruppo_legame is null then 0 else 1 end flg_gruppo_legame, --nvl( (select decode (cod_gruppo_legame, null, '0', '1') from mcre_own.t_mcre0_app_gruppo_legame gl where  f.cod_sndg = gl.cod_sndg(+)),'0') flg_gruppo_legame,
DTA_RIFERIMENTO gb_dta_riferimento,
gegb_tot_gar,
scgb_tot_gar,
glgb_tot_gar,
scgb_acc_consegne,
scgb_acc_consegne_dt,
scgb_uti_consegne,
scgb_uti_consegne_dt,
gegb_acc_consegne,
gegb_acc_consegne_dt,
gegb_uti_consegne,
gegb_uti_consegne_dt,
glgb_acc_consegne,
glgb_acc_consegne_dt,
glgb_uti_consegne,
glgb_uti_consegne_dt,
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
scgb_uti_cassa,
scgb_uti_firma,
scgb_acc_cassa,
scgb_acc_firma,
scgb_uti_cassa_bt,
scgb_uti_cassa_mlt,
scgb_uti_smobilizzo,
scgb_uti_firma_dt,
scgb_acc_cassa_bt,
scgb_acc_cassa_mlt,
scgb_acc_smobilizzo,
scgb_acc_firma_dt,
gegb_uti_cassa,
gegb_uti_firma,
gegb_acc_cassa,
gegb_acc_firma,
gegb_uti_cassa_bt,
gegb_uti_cassa_mlt,
gegb_uti_smobilizzo,
gegb_uti_firma_dt,
gegb_acc_cassa_bt,
gegb_acc_cassa_mlt,
gegb_acc_smobilizzo,
gegb_acc_firma_dt,
glgb_uti_cassa,
glgb_uti_firma,
glgb_acc_cassa,
glgb_acc_firma,
glgb_uti_cassa_bt,
glgb_uti_cassa_mlt,
glgb_uti_smobilizzo,
glgb_uti_firma_dt,
glgb_acc_cassa_bt,
glgb_acc_cassa_mlt,
glgb_acc_smobilizzo,
glgb_acc_firma_dt,
gegb_uti_cassa + gegb_uti_firma gegb_uti_tot,
gegb_acc_cassa + gegb_acc_firma gegb_acc_tot,
glgb_uti_cassa + glgb_uti_firma glgb_uti_tot,
glgb_acc_cassa + glgb_acc_firma glgb_acc_tot,
scgb_uti_cassa + scgb_uti_firma scgb_uti_tot,
scgb_acc_cassa + scgb_acc_firma scgb_acc_tot,
/* nuovo mau*/
DECODE (SIGN (  (gegb_uti_cassa + gegb_uti_firma + gegb_uti_sostituzioni)
- (gegb_acc_cassa + gegb_acc_firma + gegb_acc_sostituzioni)
),
-1, (gegb_acc_cassa + gegb_acc_firma + gegb_acc_sostituzioni),
(gegb_uti_cassa + gegb_uti_firma + gegb_uti_sostituzioni)
) gegb_mau,
DECODE (SIGN (  (glgb_uti_cassa + glgb_uti_firma + glgb_uti_sostituzioni)
- (glgb_acc_cassa + glgb_acc_firma + glgb_acc_sostituzioni)
),
-1, (glgb_acc_cassa + glgb_acc_firma + glgb_acc_sostituzioni),
(glgb_uti_cassa + glgb_uti_firma + glgb_uti_sostituzioni)
) glgb_mau,
DECODE (SIGN (  (scgb_uti_cassa + scgb_uti_firma + scgb_uti_sostituzioni)
- (scgb_acc_cassa + scgb_acc_firma + scgb_acc_sostituzioni)
),
-1, (scgb_acc_cassa + scgb_acc_firma + scgb_acc_sostituzioni),
(scgb_uti_cassa + scgb_uti_firma + scgb_uti_sostituzioni)
) scgb_mau,
gb.DTA_INS,
gb.DTA_UPD,
1 my_rnk
FROM t_mcre0_app_file_guida24 f, mcre_own.GTT_PCR_GB_MRG gb
WHERE f.cod_sndg = gb.cod_sndg(+);

commit;
PKG_MCRE0_AUDIT.LOG_ETL(V_COD_LOG,'PKG_MCRE0_PCR3.FNC_LOAD_PCR_GB_MERGE',PKG_MCRE0_AUDIT.C_DEBUG,SQLCODE,SQLERRM,'GB - insert completed');

return ok;

EXCEPTION
WHEN OTHERS THEN
PKG_MCRE0_AUDIT.LOG_ETL(V_COD_LOG,'PKG_MCRE0_PCR3.FNC_LOAD_PCR_GB_MERGE',PKG_MCRE0_AUDIT.C_ERROR,SQLCODE,SQLERRM,'GB - ERROR');
return ko;
end;


-- Procedura per load della tabella di working, che conterrà la PCR definitiva
--    drop index prima dell'insert massiva
--    stato esecuzione 1 OK 0 Errori
FUNCTION fnc_load_pcr_wrk (
P_COD_LOG T_MCRE0_WRK_AUDIT_ETL.ID%TYPE DEFAULT NULL )
RETURN NUMBER IS

V_COD_LOG T_MCRE0_WRK_AUDIT_ETL.ID%TYPE;

begin

IF( P_COD_LOG IS NULL) THEN
SELECT SEQ_MCR0_LOG_ETL.NEXTVAL
INTO V_COD_LOG
FROM DUAL;
ELSE
V_COD_LOG := P_COD_LOG;
end if;

execute immediate 'truncate table mcre_own.T_MCRE0_APP_PCR_WRK reuse storage';
PKG_MCRE0_AUDIT.LOG_ETL(V_COD_LOG,'PKG_MCRE0_PCR3.FNC_LOAD_PCR_WRK',PKG_MCRE0_AUDIT.C_DEBUG,SQLCODE,SQLERRM,'WRK - truncate completed');


INSERT /*+append*/
INTO mcre_own.GTT_PCR_WRK
(DTA_INS,
DTA_UPD,
TODAY_FLG,
COD_ABI_ISTITUTO,
COD_ABI_CARTOLARIZZATO,
COD_NDG,
COD_SNDG,
SCSB_ACC_CASSA,
SCSB_ACC_CASSA_BT,
SCSB_ACC_CASSA_MLT,
SCSB_ACC_FIRMA,
SCSB_ACC_FIRMA_DT,
SCSB_ACC_SMOBILIZZO,
SCSB_ACC_TOT,
SCSB_DTA_RIFERIMENTO,
SCSB_TOT_GAR,
SCSB_UTI_CASSA,
SCSB_UTI_CASSA_BT,
SCSB_UTI_CASSA_MLT,
SCSB_UTI_FIRMA,
SCSB_UTI_FIRMA_DT,
SCSB_UTI_SMOBILIZZO,
SCSB_UTI_TOT,
GESB_ACC_CASSA,
GESB_ACC_CASSA_BT,
GESB_ACC_CASSA_MLT,
GESB_ACC_FIRMA,
GESB_ACC_FIRMA_DT,
GESB_ACC_SMOBILIZZO,
GESB_DTA_RIFERIMENTO,
GESB_TOT_GAR,
GESB_UTI_CASSA,
GESB_UTI_CASSA_BT,
GESB_UTI_CASSA_MLT,
GESB_UTI_FIRMA,
GESB_UTI_FIRMA_DT,
GESB_UTI_SMOBILIZZO,
SCGB_ACC_CASSA,
SCGB_ACC_CASSA_BT,
SCGB_ACC_CASSA_MLT,
SCGB_ACC_FIRMA,
SCGB_ACC_FIRMA_DT,
SCGB_ACC_SMOBILIZZO,
SCGB_TOT_GAR,
SCGB_UTI_CASSA,
SCGB_UTI_CASSA_BT,
SCGB_UTI_CASSA_MLT,
SCGB_UTI_FIRMA,
SCGB_UTI_FIRMA_DT,
SCGB_UTI_SMOBILIZZO,
GEGB_ACC_CASSA,
GEGB_ACC_CASSA_BT,
GEGB_ACC_CASSA_MLT,
GEGB_ACC_FIRMA,
GEGB_ACC_FIRMA_DT,
GEGB_ACC_SMOBILIZZO,
GEGB_TOT_GAR,
GEGB_UTI_CASSA,
GEGB_UTI_CASSA_BT,
GEGB_UTI_CASSA_MLT,
GEGB_UTI_FIRMA,
GEGB_UTI_FIRMA_DT,
GEGB_UTI_SMOBILIZZO,
GLGB_ACC_CASSA,
GLGB_ACC_CASSA_BT,
GLGB_ACC_CASSA_MLT,
GLGB_ACC_FIRMA,
GLGB_ACC_FIRMA_DT,
GLGB_ACC_SMOBILIZZO,
GLGB_TOT_GAR,
GLGB_UTI_CASSA,
GLGB_UTI_CASSA_BT,
GLGB_UTI_CASSA_MLT,
GLGB_UTI_FIRMA,
GLGB_UTI_FIRMA_DT,
GLGB_UTI_SMOBILIZZO,
GB_VAL_MAU,
GESB_ACC_TOT,
GESB_UTI_TOT,
GEGB_MAU,
GLGB_MAU,
SCGB_MAU,
ID_DPER_SCSB,
ID_DPER_GESB,
ID_DPER_GB,
SCSB_UTI_SOSTITUZIONI,
SCSB_UTI_MASSIMALI,
SCSB_UTI_RISCHI_INDIRETTI,
SCSB_UTI_SOSTITUZIONI_DT,
SCSB_UTI_MASSIMALI_DT,
SCSB_UTI_RISCHI_INDIRETTI_DT,
SCSB_ACC_SOSTITUZIONI,
SCSB_ACC_SOSTITUZIONI_DT,
SCSB_ACC_MASSIMALI,
SCSB_ACC_MASSIMALI_DT,
SCSB_ACC_RISCHI_INDIRETTI,
SCSB_ACC_RISCHI_INDIRETTI_DT,
GESB_UTI_MASSIMALI,
GESB_UTI_RISCHI_INDIRETTI,
GESB_UTI_SOSTITUZIONI_DT,
GESB_UTI_MASSIMALI_DT,
GESB_UTI_RISCHI_INDIRETTI_DT,
GESB_ACC_SOSTITUZIONI,
GESB_ACC_SOSTITUZIONI_DT,
GESB_ACC_MASSIMALI,
GESB_ACC_MASSIMALI_DT,
GESB_ACC_RISCHI_INDIRETTI,
GESB_ACC_RISCHI_INDIRETTI_DT,
SCGB_UTI_MASSIMALI,
SCGB_UTI_RISCHI_INDIRETTI,
SCGB_UTI_SOSTITUZIONI_DT,
SCGB_UTI_MASSIMALI_DT,
SCGB_UTI_RISCHI_INDIRETTI_DT,
SCGB_ACC_SOSTITUZIONI,
SCGB_ACC_SOSTITUZIONI_DT,
SCGB_ACC_MASSIMALI,
SCGB_ACC_MASSIMALI_DT,
SCGB_ACC_RISCHI_INDIRETTI,
SCGB_ACC_RISCHI_INDIRETTI_DT,
GLGB_UTI_MASSIMALI,
GLGB_UTI_RISCHI_INDIRETTI,
GLGB_UTI_SOSTITUZIONI_DT,
GLGB_UTI_MASSIMALI_DT,
GLGB_UTI_RISCHI_INDIRETTI_DT,
GLGB_ACC_SOSTITUZIONI,
GLGB_ACC_SOSTITUZIONI_DT,
GLGB_ACC_MASSIMALI,
GLGB_ACC_MASSIMALI_DT,
GLGB_ACC_RISCHI_INDIRETTI,
GLGB_ACC_RISCHI_INDIRETTI_DT,
GESB_UTI_SOSTITUZIONI,
SCGB_UTI_SOSTITUZIONI,
GEGB_UTI_SOSTITUZIONI,
GLGB_UTI_SOSTITUZIONI,
GEGB_UTI_MASSIMALI,
GEGB_UTI_RISCHI_INDIRETTI,
GEGB_UTI_MASSIMALI_DT,
GEGB_UTI_SOSTITUZIONI_DT,
GEGB_UTI_RISCHI_INDIRETTI_DT,
GEGB_ACC_SOSTITUZIONI,
GEGB_ACC_SOSTITUZIONI_DT,
GEGB_ACC_MASSIMALI,
GEGB_ACC_MASSIMALI_DT,
GEGB_ACC_RISCHI_INDIRETTI,
GEGB_ACC_RISCHI_INDIRETTI_DT,
SCGB_UTI_TOT,
SCGB_ACC_TOT,
GEGB_UTI_TOT,
GEGB_ACC_TOT,
GLGB_UTI_TOT,
GLGB_ACC_TOT,
GB_DTA_RIFERIMENTO,
SCSB_UTI_CONSEGNE,
SCSB_ACC_CONSEGNE,
SCGB_UTI_CONSEGNE,
SCGB_ACC_CONSEGNE,
GESB_UTI_CONSEGNE,
GESB_ACC_CONSEGNE,
GEGB_UTI_CONSEGNE,
GEGB_ACC_CONSEGNE,
GLGB_UTI_CONSEGNE,
GLGB_ACC_CONSEGNE,
SCSB_UTI_CONSEGNE_DT,
SCSB_ACC_CONSEGNE_DT,
SCGB_UTI_CONSEGNE_DT,
SCGB_ACC_CONSEGNE_DT,
GESB_UTI_CONSEGNE_DT,
GESB_ACC_CONSEGNE_DT,
GEGB_UTI_CONSEGNE_DT,
GEGB_ACC_CONSEGNE_DT,
GLGB_UTI_CONSEGNE_DT,
GLGB_ACC_CONSEGNE_DT,
cod_gruppo_economico)
SELECT DISTINCT SYSDATE DTA_INS,
SYSDATE DTA_UPD,
TODAY_FLG,
COD_ABI_ISTITUTO,
COD_ABI_CARTOLARIZZATO,
COD_NDG,
COD_SNDG,
SCSB_ACC_CASSA,
SCSB_ACC_CASSA_BT,
SCSB_ACC_CASSA_MLT,
SCSB_ACC_FIRMA,
SCSB_ACC_FIRMA_DT,
SCSB_ACC_SMOBILIZZO,
SCSB_ACC_TOT,
SCSB_DTA_RIFERIMENTO,
SCSB_TOT_GAR,
SCSB_UTI_CASSA,
SCSB_UTI_CASSA_BT,
SCSB_UTI_CASSA_MLT,
SCSB_UTI_FIRMA,
SCSB_UTI_FIRMA_DT,
SCSB_UTI_SMOBILIZZO,
SCSB_UTI_TOT,
GESB_ACC_CASSA,
GESB_ACC_CASSA_BT,
GESB_ACC_CASSA_MLT,
GESB_ACC_FIRMA,
GESB_ACC_FIRMA_DT,
GESB_ACC_SMOBILIZZO,
GESB_DTA_RIFERIMENTO,
GESB_TOT_GAR,
GESB_UTI_CASSA,
GESB_UTI_CASSA_BT,
GESB_UTI_CASSA_MLT,
GESB_UTI_FIRMA,
GESB_UTI_FIRMA_DT,
GESB_UTI_SMOBILIZZO,
SCGB_ACC_CASSA,
SCGB_ACC_CASSA_BT,
SCGB_ACC_CASSA_MLT,
SCGB_ACC_FIRMA,
SCGB_ACC_FIRMA_DT,
SCGB_ACC_SMOBILIZZO,
SCGB_TOT_GAR,
SCGB_UTI_CASSA,
SCGB_UTI_CASSA_BT,
SCGB_UTI_CASSA_MLT,
SCGB_UTI_FIRMA,
SCGB_UTI_FIRMA_DT,
SCGB_UTI_SMOBILIZZO,
GEGB_ACC_CASSA,
GEGB_ACC_CASSA_BT,
GEGB_ACC_CASSA_MLT,
GEGB_ACC_FIRMA,
GEGB_ACC_FIRMA_DT,
GEGB_ACC_SMOBILIZZO,
GEGB_TOT_GAR,
GEGB_UTI_CASSA,
GEGB_UTI_CASSA_BT,
GEGB_UTI_CASSA_MLT,
GEGB_UTI_FIRMA,
GEGB_UTI_FIRMA_DT,
GEGB_UTI_SMOBILIZZO,
GLGB_ACC_CASSA,
GLGB_ACC_CASSA_BT,
GLGB_ACC_CASSA_MLT,
GLGB_ACC_FIRMA,
GLGB_ACC_FIRMA_DT,
GLGB_ACC_SMOBILIZZO,
GLGB_TOT_GAR,
GLGB_UTI_CASSA,
GLGB_UTI_CASSA_BT,
GLGB_UTI_CASSA_MLT,
GLGB_UTI_FIRMA,
GLGB_UTI_FIRMA_DT,
GLGB_UTI_SMOBILIZZO,
--min(case when COD_GRUPPO_ECONOMICO=(SELECT  ge.cod_gruppo_economico FROM mcre_own.t_mcre0_app_gruppo_economico ge WHERE g.cod_sndg = ge.cod_sndg(+) ) then DECODE (flg_gruppo_economico,1, GEGB_MAU,DECODE (flg_gruppo_legame, 1, glgb_mau, scgb_mau)) else null end) gb_val_mau
DECODE (
flg_gruppo_economico,
1, GEGB_MAU,
DECODE (flg_gruppo_legame, 1, glgb_mau, scgb_mau))
GB_VAL_MAU,
GESB_ACC_TOT,
GESB_UTI_TOT,
GEGB_MAU,
GLGB_MAU,
SCGB_MAU,
ID_DPER_SCSB,
ID_DPER_GESB,
ID_DPER_GB,
SCSB_UTI_SOSTITUZIONI,
SCSB_UTI_MASSIMALI,
SCSB_UTI_RISCHI_INDIRETTI,
SCSB_UTI_SOSTITUZIONI_DT,
SCSB_UTI_MASSIMALI_DT,
SCSB_UTI_RISCHI_INDIRETTI_DT,
SCSB_ACC_SOSTITUZIONI,
SCSB_ACC_SOSTITUZIONI_DT,
SCSB_ACC_MASSIMALI,
SCSB_ACC_MASSIMALI_DT,
SCSB_ACC_RISCHI_INDIRETTI,
SCSB_ACC_RISCHI_INDIRETTI_DT,
GESB_UTI_MASSIMALI,
GESB_UTI_RISCHI_INDIRETTI,
GESB_UTI_SOSTITUZIONI_DT,
GESB_UTI_MASSIMALI_DT,
GESB_UTI_RISCHI_INDIRETTI_DT,
GESB_ACC_SOSTITUZIONI,
GESB_ACC_SOSTITUZIONI_DT,
GESB_ACC_MASSIMALI,
GESB_ACC_MASSIMALI_DT,
GESB_ACC_RISCHI_INDIRETTI,
GESB_ACC_RISCHI_INDIRETTI_DT,
SCGB_UTI_MASSIMALI,
SCGB_UTI_RISCHI_INDIRETTI,
SCGB_UTI_SOSTITUZIONI_DT,
SCGB_UTI_MASSIMALI_DT,
SCGB_UTI_RISCHI_INDIRETTI_DT,
SCGB_ACC_SOSTITUZIONI,
SCGB_ACC_SOSTITUZIONI_DT,
SCGB_ACC_MASSIMALI,
SCGB_ACC_MASSIMALI_DT,
SCGB_ACC_RISCHI_INDIRETTI,
SCGB_ACC_RISCHI_INDIRETTI_DT,
GLGB_UTI_MASSIMALI,
GLGB_UTI_RISCHI_INDIRETTI,
GLGB_UTI_SOSTITUZIONI_DT,
GLGB_UTI_MASSIMALI_DT,
GLGB_UTI_RISCHI_INDIRETTI_DT,
GLGB_ACC_SOSTITUZIONI,
GLGB_ACC_SOSTITUZIONI_DT,
GLGB_ACC_MASSIMALI,
GLGB_ACC_MASSIMALI_DT,
GLGB_ACC_RISCHI_INDIRETTI,
GLGB_ACC_RISCHI_INDIRETTI_DT,
GESB_UTI_SOSTITUZIONI,
SCGB_UTI_SOSTITUZIONI,
GEGB_UTI_SOSTITUZIONI,
GLGB_UTI_SOSTITUZIONI,
GEGB_UTI_MASSIMALI,
GEGB_UTI_RISCHI_INDIRETTI,
GEGB_UTI_MASSIMALI_DT,
GEGB_UTI_SOSTITUZIONI_DT,
GEGB_UTI_RISCHI_INDIRETTI_DT,
GEGB_ACC_SOSTITUZIONI,
GEGB_ACC_SOSTITUZIONI_DT,
GEGB_ACC_MASSIMALI,
GEGB_ACC_MASSIMALI_DT,
GEGB_ACC_RISCHI_INDIRETTI,
GEGB_ACC_RISCHI_INDIRETTI_DT,
SCGB_UTI_TOT,
SCGB_ACC_TOT,
GEGB_UTI_TOT,
GEGB_ACC_TOT,
GLGB_UTI_TOT,
GLGB_ACC_TOT,
GB_DTA_RIFERIMENTO,
SCSB_UTI_CONSEGNE,
SCSB_ACC_CONSEGNE,
SCGB_UTI_CONSEGNE,
SCGB_ACC_CONSEGNE,
GESB_UTI_CONSEGNE,
GESB_ACC_CONSEGNE,
GEGB_UTI_CONSEGNE,
GEGB_ACC_CONSEGNE,
GLGB_UTI_CONSEGNE,
GLGB_ACC_CONSEGNE,
SCSB_UTI_CONSEGNE_DT,
SCSB_ACC_CONSEGNE_DT,
SCGB_UTI_CONSEGNE_DT,
SCGB_ACC_CONSEGNE_DT,
GESB_UTI_CONSEGNE_DT,
GESB_ACC_CONSEGNE_DT,
GEGB_UTI_CONSEGNE_DT,
GEGB_ACC_CONSEGNE_DT,
GLGB_UTI_CONSEGNE_DT,
GLGB_ACC_CONSEGNE_DT
,cod_gruppo_economico
FROM (SELECT  /*+pq_distribute(ge,hash,hash)*/
fgb.id_dper,
fgb.FLG_LAST_RUN,
fgb.cod_abi_cartolarizzato,
fgb.cod_ndg,
fgb.today_flg,
CASE
WHEN NVL (sc.flg_last_run, '0') = '0'
AND NVL (sc.id_dper_scsb, '00000000') <>
NVL (p.id_dper_scsb, '00000000')
THEN
p.COD_SNDG
ELSE
fgb.cod_sndg
END
cod_sndg,
--FLG_SNDG_GE,
CASE
WHEN NVL (sc.flg_last_run, '0') = '0'
AND NVL (sc.id_dper_scsb, '00000000') <>
NVL (p.id_dper_scsb, '00000000')
THEN
p.cod_abi_istituto
ELSE
fgb.cod_abi_istituto
END
cod_abi_istituto,
NVL (fgb.flg_gruppo_economico, '0')
flg_gruppo_economico,
fgb.cod_gruppo_economico,
NVL (fgb.flg_gruppo_legame, '0') flg_gruppo_legame,
--PCR
CASE
WHEN NVL (sc.flg_last_run, '0') = '0'
AND NVL (sc.id_dper_scsb, '00000000') <>
NVL (p.id_dper_scsb, '00000000')
THEN
p.id_dper_scsb
ELSE
sc.id_dper_scsb
END
id_dper_scsb,
CASE
WHEN ge.id_dper_gesb IS NULL THEN p.id_dper_gesb
ELSE ge.id_dper_gesb
END
id_dper_gesb,
CASE
WHEN NVL (fgb.flg_last_run, '0') = '0'
AND NVL (fgb.id_dper_gb, '00000000') <>
NVL (p.id_dper_gb, '00000000')
THEN
p.id_dper_gb
ELSE
fgb.id_dper_gb
END
id_dper_gb,
CASE
WHEN NVL (sc.flg_last_run, '0') = '0'
AND NVL (sc.id_dper_scsb, '00000000') <>
NVL (p.id_dper_scsb, '00000000')
THEN
p.SCSB_ACC_CONSEGNE
ELSE
sc.SCSB_ACC_CONSEGNE
END
SCSB_ACC_CONSEGNE,
CASE
WHEN NVL (sc.flg_last_run, '0') = '0'
AND NVL (sc.id_dper_scsb, '00000000') <>
NVL (p.id_dper_scsb, '00000000')
THEN
p.SCSB_ACC_CONSEGNE_DT
ELSE
sc.SCSB_ACC_CONSEGNE_DT
END
SCSB_ACC_CONSEGNE_DT,
CASE
WHEN NVL (sc.flg_last_run, '0') = '0'
AND NVL (sc.id_dper_scsb, '00000000') <>
NVL (p.id_dper_scsb, '00000000')
THEN
p.SCSB_UTI_CONSEGNE
ELSE
sc.SCSB_UTI_CONSEGNE
END
SCSB_UTI_CONSEGNE,
CASE
WHEN NVL (sc.flg_last_run, '0') = '0'
AND NVL (sc.id_dper_scsb, '00000000') <>
NVL (p.id_dper_scsb, '00000000')
THEN
p.SCSB_UTI_CONSEGNE_DT
ELSE
sc.SCSB_UTI_CONSEGNE_DT
END
SCSB_UTI_CONSEGNE_DT,
CASE
WHEN NVL (sc.flg_last_run, '0') = '0'
AND NVL (sc.id_dper_scsb, '00000000') <>
NVL (p.id_dper_scsb, '00000000')
THEN
p.SCSB_UTI_MASSIMALI
ELSE
sc.SCSB_UTI_MASSIMALI
END
SCSB_UTI_MASSIMALI,
CASE
WHEN NVL (sc.flg_last_run, '0') = '0'
AND NVL (sc.id_dper_scsb, '00000000') <>
NVL (p.id_dper_scsb, '00000000')
THEN
p.SCSB_UTI_SOSTITUZIONI
ELSE
sc.SCSB_UTI_SOSTITUZIONI
END
SCSB_UTI_SOSTITUZIONI,
CASE
WHEN NVL (sc.flg_last_run, '0') = '0'
AND NVL (sc.id_dper_scsb, '00000000') <>
NVL (p.id_dper_scsb, '00000000')
THEN
p.SCSB_UTI_RISCHI_INDIRETTI
ELSE
sc.SCSB_UTI_RISCHI_INDIRETTI
END
SCSB_UTI_RISCHI_INDIRETTI,
CASE
WHEN NVL (sc.flg_last_run, '0') = '0'
AND NVL (sc.id_dper_scsb, '00000000') <>
NVL (p.id_dper_scsb, '00000000')
THEN
p.SCSB_UTI_MASSIMALI_DT
ELSE
sc.SCSB_UTI_MASSIMALI_DT
END
SCSB_UTI_MASSIMALI_DT,
CASE
WHEN NVL (sc.flg_last_run, '0') = '0'
AND NVL (sc.id_dper_scsb, '00000000') <>
NVL (p.id_dper_scsb, '00000000')
THEN
p.SCSB_UTI_SOSTITUZIONI_DT
ELSE
sc.SCSB_UTI_SOSTITUZIONI_DT
END
SCSB_UTI_SOSTITUZIONI_DT,
CASE
WHEN NVL (sc.flg_last_run, '0') = '0'
AND NVL (sc.id_dper_scsb, '00000000') <>
NVL (p.id_dper_scsb, '00000000')
THEN
p.SCSB_UTI_RISCHI_INDIRETTI_DT
ELSE
sc.SCSB_UTI_RISCHI_INDIRETTI_DT
END
SCSB_UTI_RISCHI_INDIRETTI_DT,
CASE
WHEN NVL (sc.flg_last_run, '0') = '0'
AND NVL (sc.id_dper_scsb, '00000000') <>
NVL (p.id_dper_scsb, '00000000')
THEN
p.SCSB_ACC_MASSIMALI
ELSE
sc.SCSB_ACC_MASSIMALI
END
SCSB_ACC_MASSIMALI,
CASE
WHEN NVL (sc.flg_last_run, '0') = '0'
AND NVL (sc.id_dper_scsb, '00000000') <>
NVL (p.id_dper_scsb, '00000000')
THEN
p.SCSB_ACC_SOSTITUZIONI
ELSE
sc.SCSB_ACC_SOSTITUZIONI
END
SCSB_ACC_SOSTITUZIONI,
CASE
WHEN NVL (sc.flg_last_run, '0') = '0'
AND NVL (sc.id_dper_scsb, '00000000') <>
NVL (p.id_dper_scsb, '00000000')
THEN
p.SCSB_ACC_RISCHI_INDIRETTI
ELSE
sc.SCSB_ACC_RISCHI_INDIRETTI
END
SCSB_ACC_RISCHI_INDIRETTI,
CASE
WHEN NVL (sc.flg_last_run, '0') = '0'
AND NVL (sc.id_dper_scsb, '00000000') <>
NVL (p.id_dper_scsb, '00000000')
THEN
p.SCSB_ACC_MASSIMALI_DT
ELSE
sc.SCSB_ACC_MASSIMALI_DT
END
SCSB_ACC_MASSIMALI_DT,
CASE
WHEN NVL (sc.flg_last_run, '0') = '0'
AND NVL (sc.id_dper_scsb, '00000000') <>
NVL (p.id_dper_scsb, '00000000')
THEN
p.SCSB_ACC_SOSTITUZIONI_DT
ELSE
sc.SCSB_ACC_SOSTITUZIONI_DT
END
SCSB_ACC_SOSTITUZIONI_DT,
CASE
WHEN NVL (sc.flg_last_run, '0') = '0'
AND NVL (sc.id_dper_scsb, '00000000') <>
NVL (p.id_dper_scsb, '00000000')
THEN
p.SCSB_ACC_RISCHI_INDIRETTI_DT
ELSE
sc.SCSB_ACC_RISCHI_INDIRETTI_DT
END
SCSB_ACC_RISCHI_INDIRETTI_DT,
CASE
WHEN NVL (sc.flg_last_run, '0') = '0'
AND NVL (sc.id_dper_scsb, '00000000') <>
NVL (p.id_dper_scsb, '00000000')
THEN
p.SCSB_UTI_CASSA
ELSE
sc.SCSB_UTI_CASSA
END
SCSB_UTI_CASSA,
CASE
WHEN NVL (sc.flg_last_run, '0') = '0'
AND NVL (sc.id_dper_scsb, '00000000') <>
NVL (p.id_dper_scsb, '00000000')
THEN
p.SCSB_UTI_FIRMA
ELSE
sc.SCSB_UTI_FIRMA
END
SCSB_UTI_FIRMA,
CASE
WHEN NVL (sc.flg_last_run, '0') = '0'
AND NVL (sc.id_dper_scsb, '00000000') <>
NVL (p.id_dper_scsb, '00000000')
THEN
p.SCSB_UTI_TOT
ELSE
sc.SCSB_UTI_TOT
END
SCSB_UTI_TOT,
CASE
WHEN NVL (sc.flg_last_run, '0') = '0'
AND NVL (sc.id_dper_scsb, '00000000') <>
NVL (p.id_dper_scsb, '00000000')
THEN
p.SCSB_ACC_CASSA
ELSE
sc.SCSB_ACC_CASSA
END
SCSB_ACC_CASSA,
CASE
WHEN NVL (sc.flg_last_run, '0') = '0'
AND NVL (sc.id_dper_scsb, '00000000') <>
NVL (p.id_dper_scsb, '00000000')
THEN
p.SCSB_ACC_FIRMA
ELSE
sc.SCSB_ACC_FIRMA
END
SCSB_ACC_FIRMA,
CASE
WHEN NVL (sc.flg_last_run, '0') = '0'
AND NVL (sc.id_dper_scsb, '00000000') <>
NVL (p.id_dper_scsb, '00000000')
THEN
p.SCSB_ACC_TOT
ELSE
sc.SCSB_ACC_TOT
END
SCSB_ACC_TOT,
CASE
WHEN NVL (sc.flg_last_run, '0') = '0'
AND NVL (sc.id_dper_scsb, '00000000') <>
NVL (p.id_dper_scsb, '00000000')
THEN
p.SCSB_UTI_CASSA_BT
ELSE
sc.SCSB_UTI_CASSA_BT
END
SCSB_UTI_CASSA_BT,
CASE
WHEN NVL (sc.flg_last_run, '0') = '0'
AND NVL (sc.id_dper_scsb, '00000000') <>
NVL (p.id_dper_scsb, '00000000')
THEN
p.SCSB_UTI_CASSA_MLT
ELSE
sc.SCSB_UTI_CASSA_MLT
END
SCSB_UTI_CASSA_MLT,
CASE
WHEN NVL (sc.flg_last_run, '0') = '0'
AND NVL (sc.id_dper_scsb, '00000000') <>
NVL (p.id_dper_scsb, '00000000')
THEN
p.SCSB_UTI_SMOBILIZZO
ELSE
sc.SCSB_UTI_SMOBILIZZO
END
SCSB_UTI_SMOBILIZZO,
CASE
WHEN NVL (sc.flg_last_run, '0') = '0'
AND NVL (sc.id_dper_scsb, '00000000') <>
NVL (p.id_dper_scsb, '00000000')
THEN
p.SCSB_UTI_FIRMA_DT
ELSE
sc.SCSB_UTI_FIRMA_DT
END
SCSB_UTI_FIRMA_DT,
CASE
WHEN NVL (sc.flg_last_run, '0') = '0'
AND NVL (sc.id_dper_scsb, '00000000') <>
NVL (p.id_dper_scsb, '00000000')
THEN
p.SCSB_ACC_CASSA_BT
ELSE
sc.SCSB_ACC_CASSA_BT
END
SCSB_ACC_CASSA_BT,
CASE
WHEN NVL (sc.flg_last_run, '0') = '0'
AND NVL (sc.id_dper_scsb, '00000000') <>
NVL (p.id_dper_scsb, '00000000')
THEN
p.SCSB_ACC_CASSA_MLT
ELSE
sc.SCSB_ACC_CASSA_MLT
END
SCSB_ACC_CASSA_MLT,
CASE
WHEN NVL (sc.flg_last_run, '0') = '0'
AND NVL (sc.id_dper_scsb, '00000000') <>
NVL (p.id_dper_scsb, '00000000')
THEN
p.SCSB_ACC_SMOBILIZZO
ELSE
sc.SCSB_ACC_SMOBILIZZO
END
SCSB_ACC_SMOBILIZZO,
CASE
WHEN NVL (sc.flg_last_run, '0') = '0'
AND NVL (sc.id_dper_scsb, '00000000') <>
NVL (p.id_dper_scsb, '00000000')
THEN
p.SCSB_ACC_FIRMA_DT
ELSE
sc.SCSB_ACC_FIRMA_DT
END
SCSB_ACC_FIRMA_DT,
CASE
WHEN NVL (sc.flg_last_run, '0') = '0'
AND NVL (sc.id_dper_scsb, '00000000') <>
NVL (p.id_dper_scsb, '00000000')
THEN
p.SCSB_TOT_GAR
ELSE
sc.SCSB_TOT_GAR
END
SCSB_TOT_GAR,
CASE
WHEN NVL (sc.flg_last_run, '0') = '0'
AND NVL (sc.id_dper_scsb, '00000000') <>
NVL (p.id_dper_scsb, '00000000')
THEN
p.SCSB_DTA_RIFERIMENTO
ELSE
sc.SCSB_DTA_RIFERIMENTO
END
SCSB_DTA_RIFERIMENTO,
--GESB
CASE
WHEN NVL (fgb.flg_last_run, '0') = '0'
AND NVL (fgb.id_dper_gb, '00000000') <>
NVL (p.id_dper_gb, '00000000')
THEN
p.GESB_ACC_CONSEGNE
WHEN NVL (fgb.flg_gruppo_economico, '0') = 0
THEN
NULL
ELSE
ge.GESB_ACC_CONSEGNE
END
GESB_ACC_CONSEGNE,
CASE
WHEN NVL (fgb.flg_last_run, '0') = '0'
AND NVL (fgb.id_dper_gb, '00000000') <>
NVL (p.id_dper_gb, '00000000')
THEN
p.GESB_ACC_CONSEGNE_DT
WHEN NVL (fgb.flg_gruppo_economico, '0') = 0
THEN
NULL
ELSE
ge.GESB_ACC_CONSEGNE_DT
END
GESB_ACC_CONSEGNE_DT,
CASE
WHEN NVL (fgb.flg_last_run, '0') = '0'
AND NVL (fgb.id_dper_gb, '00000000') <>
NVL (p.id_dper_gb, '00000000')
THEN
p.GESB_UTI_CONSEGNE
WHEN NVL (fgb.flg_gruppo_economico, '0') = 0
THEN
NULL
ELSE
ge.GESB_UTI_CONSEGNE
END
GESB_UTI_CONSEGNE,
CASE
WHEN NVL (fgb.flg_last_run, '0') = '0'
AND NVL (fgb.id_dper_gb, '00000000') <>
NVL (p.id_dper_gb, '00000000')
THEN
p.GESB_UTI_CONSEGNE_DT
WHEN NVL (fgb.flg_gruppo_economico, '0') = 0
THEN
NULL
ELSE
ge.GESB_UTI_CONSEGNE_DT
END
GESB_UTI_CONSEGNE_DT,
CASE
WHEN NVL (fgb.flg_last_run, '0') = '0'
AND NVL (fgb.id_dper_gb, '00000000') <>
NVL (p.id_dper_gb, '00000000')
THEN
p.GESB_UTI_SOSTITUZIONI
WHEN NVL (fgb.flg_gruppo_economico, '0') = 0
THEN
NULL
ELSE
ge.GESB_UTI_SOSTITUZIONI
END
GESB_UTI_SOSTITUZIONI,
CASE
WHEN NVL (fgb.flg_last_run, '0') = '0'
AND NVL (fgb.id_dper_gb, '00000000') <>
NVL (p.id_dper_gb, '00000000')
THEN
p.GESB_UTI_MASSIMALI
WHEN NVL (fgb.flg_gruppo_economico, '0') = 0
THEN
NULL
ELSE
ge.GESB_UTI_MASSIMALI
END
GESB_UTI_MASSIMALI,
CASE
WHEN NVL (fgb.flg_last_run, '0') = '0'
AND NVL (fgb.id_dper_gb, '00000000') <>
NVL (p.id_dper_gb, '00000000')
THEN
p.GESB_UTI_RISCHI_INDIRETTI
WHEN NVL (fgb.flg_gruppo_economico, '0') = 0
THEN
NULL
ELSE
ge.GESB_UTI_RISCHI_INDIRETTI
END
GESB_UTI_RISCHI_INDIRETTI,
CASE
WHEN NVL (fgb.flg_last_run, '0') = '0'
AND NVL (fgb.id_dper_gb, '00000000') <>
NVL (p.id_dper_gb, '00000000')
THEN
p.GESB_UTI_SOSTITUZIONI_DT
WHEN NVL (fgb.flg_gruppo_economico, '0') = 0
THEN
NULL
ELSE
ge.GESB_UTI_SOSTITUZIONI_DT
END
GESB_UTI_SOSTITUZIONI_DT,
CASE
WHEN NVL (fgb.flg_last_run, '0') = '0'
AND NVL (fgb.id_dper_gb, '00000000') <>
NVL (p.id_dper_gb, '00000000')
THEN
p.GESB_UTI_MASSIMALI_DT
WHEN NVL (fgb.flg_gruppo_economico, '0') = 0
THEN
NULL
ELSE
ge.GESB_UTI_MASSIMALI_DT
END
GESB_UTI_MASSIMALI_DT,
CASE
WHEN NVL (fgb.flg_last_run, '0') = '0'
AND NVL (fgb.id_dper_gb, '00000000') <>
NVL (p.id_dper_gb, '00000000')
THEN
p.GESB_UTI_RISCHI_INDIRETTI_DT
WHEN NVL (fgb.flg_gruppo_economico, '0') = 0
THEN
NULL
ELSE
ge.GESB_UTI_RISCHI_INDIRETTI_DT
END
GESB_UTI_RISCHI_INDIRETTI_DT,
CASE
WHEN NVL (fgb.flg_last_run, '0') = '0'
AND NVL (fgb.id_dper_gb, '00000000') <>
NVL (p.id_dper_gb, '00000000')
THEN
p.GESB_ACC_SOSTITUZIONI
WHEN NVL (fgb.flg_gruppo_economico, '0') = 0
THEN
NULL
ELSE
ge.GESB_ACC_SOSTITUZIONI
END
GESB_ACC_SOSTITUZIONI,
CASE
WHEN NVL (fgb.flg_last_run, '0') = '0'
AND NVL (fgb.id_dper_gb, '00000000') <>
NVL (p.id_dper_gb, '00000000')
THEN
p.GESB_ACC_MASSIMALI
WHEN NVL (fgb.flg_gruppo_economico, '0') = 0
THEN
NULL
ELSE
ge.GESB_ACC_MASSIMALI
END
GESB_ACC_MASSIMALI,
CASE
WHEN NVL (fgb.flg_last_run, '0') = '0'
AND NVL (fgb.id_dper_gb, '00000000') <>
NVL (p.id_dper_gb, '00000000')
THEN
p.GESB_ACC_RISCHI_INDIRETTI
WHEN NVL (fgb.flg_gruppo_economico, '0') = 0
THEN
NULL
ELSE
ge.GESB_ACC_RISCHI_INDIRETTI
END
GESB_ACC_RISCHI_INDIRETTI,
CASE
WHEN NVL (fgb.flg_last_run, '0') = '0'
AND NVL (fgb.id_dper_gb, '00000000') <>
NVL (p.id_dper_gb, '00000000')
THEN
p.GESB_ACC_SOSTITUZIONI_DT
WHEN NVL (fgb.flg_gruppo_economico, '0') = 0
THEN
NULL
ELSE
ge.GESB_ACC_SOSTITUZIONI_DT
END
GESB_ACC_SOSTITUZIONI_DT,
CASE
WHEN NVL (fgb.flg_last_run, '0') = '0'
AND NVL (fgb.id_dper_gb, '00000000') <>
NVL (p.id_dper_gb, '00000000')
THEN
p.GESB_ACC_MASSIMALI_DT
WHEN NVL (fgb.flg_gruppo_economico, '0') = 0
THEN
NULL
ELSE
ge.GESB_ACC_MASSIMALI_DT
END
GESB_ACC_MASSIMALI_DT,
CASE
WHEN NVL (fgb.flg_last_run, '0') = '0'
AND NVL (fgb.id_dper_gb, '00000000') <>
NVL (p.id_dper_gb, '00000000')
THEN
p.GESB_ACC_RISCHI_INDIRETTI_DT
WHEN NVL (fgb.flg_gruppo_economico, '0') = 0
THEN
NULL
ELSE
ge.GESB_ACC_RISCHI_INDIRETTI_DT
END
GESB_ACC_RISCHI_INDIRETTI_DT,
CASE
WHEN NVL (fgb.flg_last_run, '0') = '0'
AND NVL (fgb.id_dper_gb, '00000000') <>
NVL (p.id_dper_gb, '00000000')
THEN
p.GESB_UTI_CASSA
WHEN NVL (fgb.flg_gruppo_economico, '0') = 0
THEN
NULL
ELSE
ge.GESB_UTI_CASSA
END
GESB_UTI_CASSA,
CASE
WHEN NVL (fgb.flg_last_run, '0') = '0'
AND NVL (fgb.id_dper_gb, '00000000') <>
NVL (p.id_dper_gb, '00000000')
THEN
p.GESB_UTI_FIRMA
WHEN NVL (fgb.flg_gruppo_economico, '0') = 0
THEN
NULL
ELSE
ge.GESB_UTI_FIRMA
END
GESB_UTI_FIRMA,
CASE
WHEN NVL (fgb.flg_last_run, '0') = '0'
AND NVL (fgb.id_dper_gb, '00000000') <>
NVL (p.id_dper_gb, '00000000')
THEN
p.GESB_ACC_CASSA
WHEN NVL (fgb.flg_gruppo_economico, '0') = 0
THEN
NULL
ELSE
ge.GESB_ACC_CASSA
END
GESB_ACC_CASSA,
CASE
WHEN NVL (fgb.flg_last_run, '0') = '0'
AND NVL (fgb.id_dper_gb, '00000000') <>
NVL (p.id_dper_gb, '00000000')
THEN
p.GESB_ACC_FIRMA
WHEN NVL (fgb.flg_gruppo_economico, '0') = 0
THEN
NULL
ELSE
ge.GESB_ACC_FIRMA
END
GESB_ACC_FIRMA,
CASE
WHEN NVL (fgb.flg_last_run, '0') = '0'
AND NVL (fgb.id_dper_gb, '00000000') <>
NVL (p.id_dper_gb, '00000000')
THEN
p.GESB_UTI_CASSA_BT
WHEN NVL (fgb.flg_gruppo_economico, '0') = 0
THEN
NULL
ELSE
ge.GESB_UTI_CASSA_BT
END
GESB_UTI_CASSA_BT,
CASE
WHEN NVL (fgb.flg_last_run, '0') = '0'
AND NVL (fgb.id_dper_gb, '00000000') <>
NVL (p.id_dper_gb, '00000000')
THEN
p.GESB_UTI_CASSA_MLT
WHEN NVL (fgb.flg_gruppo_economico, '0') = 0
THEN
NULL
ELSE
ge.GESB_UTI_CASSA_MLT
END
GESB_UTI_CASSA_MLT,
CASE
WHEN NVL (fgb.flg_last_run, '0') = '0'
AND NVL (fgb.id_dper_gb, '00000000') <>
NVL (p.id_dper_gb, '00000000')
THEN
p.GESB_UTI_SMOBILIZZO
WHEN NVL (fgb.flg_gruppo_economico, '0') = 0
THEN
NULL
ELSE
ge.GESB_UTI_SMOBILIZZO
END
GESB_UTI_SMOBILIZZO,
CASE
WHEN NVL (fgb.flg_last_run, '0') = '0'
AND NVL (fgb.id_dper_gb, '00000000') <>
NVL (p.id_dper_gb, '00000000')
THEN
p.GESB_UTI_FIRMA_DT
WHEN NVL (fgb.flg_gruppo_economico, '0') = 0
THEN
NULL
ELSE
ge.GESB_UTI_FIRMA_DT
END
GESB_UTI_FIRMA_DT,
CASE
WHEN NVL (fgb.flg_last_run, '0') = '0'
AND NVL (fgb.id_dper_gb, '00000000') <>
NVL (p.id_dper_gb, '00000000')
THEN
p.GESB_ACC_CASSA_BT
WHEN NVL (fgb.flg_gruppo_economico, '0') = 0
THEN
NULL
ELSE
ge.GESB_ACC_CASSA_BT
END
GESB_ACC_CASSA_BT,
CASE
WHEN NVL (fgb.flg_last_run, '0') = '0'
AND NVL (fgb.id_dper_gb, '00000000') <>
NVL (p.id_dper_gb, '00000000')
THEN
p.GESB_ACC_CASSA_MLT
WHEN NVL (fgb.flg_gruppo_economico, '0') = 0
THEN
NULL
ELSE
ge.GESB_ACC_CASSA_MLT
END
GESB_ACC_CASSA_MLT,
CASE
WHEN NVL (fgb.flg_last_run, '0') = '0'
AND NVL (fgb.id_dper_gb, '00000000') <>
NVL (p.id_dper_gb, '00000000')
THEN
p.GESB_ACC_SMOBILIZZO
WHEN NVL (fgb.flg_gruppo_economico, '0') = 0
THEN
NULL
ELSE
ge.GESB_ACC_SMOBILIZZO
END
GESB_ACC_SMOBILIZZO,
CASE
WHEN NVL (fgb.flg_last_run, '0') = '0'
AND NVL (fgb.id_dper_gb, '00000000') <>
NVL (p.id_dper_gb, '00000000')
THEN
p.GESB_ACC_FIRMA_DT
WHEN NVL (fgb.flg_gruppo_economico, '0') = 0
THEN
NULL
ELSE
ge.GESB_ACC_FIRMA_DT
END
GESB_ACC_FIRMA_DT,
CASE
WHEN NVL (fgb.flg_last_run, '0') = '0'
AND NVL (fgb.id_dper_gb, '00000000') <>
NVL (p.id_dper_gb, '00000000')
THEN
p.GESB_TOT_GAR
WHEN NVL (fgb.flg_gruppo_economico, '0') = 0
THEN
NULL
ELSE
ge.GESB_TOT_GAR
END
GESB_TOT_GAR,
CASE
WHEN NVL (fgb.flg_last_run, '0') = '0'
AND NVL (fgb.id_dper_gb, '00000000') <>
NVL (p.id_dper_gb, '00000000')
THEN
p.GESB_DTA_RIFERIMENTO
WHEN NVL (fgb.flg_gruppo_economico, '0') = 0
THEN
NULL
ELSE
ge.GESB_DTA_RIFERIMENTO
END
GESB_DTA_RIFERIMENTO,
--p.GESB_ACC_TOT GESB_ACC_TOT_1,
--ge.GESB_ACC_TOT GESB_ACC_TOT_2,
CASE
WHEN NVL (fgb.flg_last_run, '0') = '0'
AND NVL (fgb.id_dper_gb, '00000000') <>
NVL (p.id_dper_gb, '00000000')
THEN
p.GESB_ACC_TOT
WHEN NVL (fgb.flg_gruppo_economico, '0') = 0
THEN
NULL
ELSE
ge.GESB_ACC_TOT
END
GESB_ACC_TOT,
CASE
WHEN NVL (fgb.flg_last_run, '0') = '0'
AND NVL (fgb.id_dper_gb, '00000000') <>
NVL (p.id_dper_gb, '00000000')
THEN
p.GESB_UTI_TOT
WHEN NVL (fgb.flg_gruppo_economico, '0') = 0
THEN
NULL
ELSE
ge.GESB_UTI_TOT
END
GESB_UTI_TOT,
--GB
CASE
WHEN NVL (fgb.flg_last_run, '0') = '0'
AND NVL (fgb.id_dper_gb, '00000000') <>
NVL (p.id_dper_gb, '00000000')
THEN
p.GB_DTA_RIFERIMENTO
ELSE
fgb.GB_DTA_RIFERIMENTO
END
GB_DTA_RIFERIMENTO,
CASE
WHEN NVL (fgb.flg_last_run, '0') = '0'
AND NVL (fgb.id_dper_gb, '00000000') <>
NVL (p.id_dper_gb, '00000000')
THEN
p.GEGB_ACC_CASSA_BT
WHEN NVL (fgb.flg_gruppo_economico, '0') = 0
THEN
NULL
ELSE
fgb.GEGB_ACC_CASSA_BT
END
GEGB_ACC_CASSA_BT,
CASE
WHEN NVL (fgb.flg_last_run, '0') = '0'
AND NVL (fgb.id_dper_gb, '00000000') <>
NVL (p.id_dper_gb, '00000000')
THEN
p.GEGB_ACC_CASSA_MLT
WHEN NVL (fgb.flg_gruppo_economico, '0') = 0
THEN
NULL
ELSE
fgb.GEGB_ACC_CASSA_MLT
END
GEGB_ACC_CASSA_MLT,
CASE
WHEN NVL (fgb.flg_last_run, '0') = '0'
AND NVL (fgb.id_dper_gb, '00000000') <>
NVL (p.id_dper_gb, '00000000')
THEN
p.GEGB_ACC_CONSEGNE
WHEN NVL (fgb.flg_gruppo_economico, '0') = 0
THEN
NULL
ELSE
fgb.GEGB_ACC_CONSEGNE
END
GEGB_ACC_CONSEGNE,
CASE
WHEN NVL (fgb.flg_last_run, '0') = '0'
AND NVL (fgb.id_dper_gb, '00000000') <>
NVL (p.id_dper_gb, '00000000')
THEN
p.GEGB_ACC_CONSEGNE_DT
WHEN NVL (fgb.flg_gruppo_economico, '0') = 0
THEN
NULL
ELSE
fgb.GEGB_ACC_CONSEGNE_DT
END
GEGB_ACC_CONSEGNE_DT,
CASE
WHEN NVL (fgb.flg_last_run, '0') = '0'
AND NVL (fgb.id_dper_gb, '00000000') <>
NVL (p.id_dper_gb, '00000000')
THEN
p.GEGB_ACC_FIRMA_DT
WHEN NVL (fgb.flg_gruppo_economico, '0') = 0
THEN
NULL
ELSE
fgb.GEGB_ACC_FIRMA_DT
END
GEGB_ACC_FIRMA_DT,
CASE
WHEN NVL (fgb.flg_last_run, '0') = '0'
AND NVL (fgb.id_dper_gb, '00000000') <>
NVL (p.id_dper_gb, '00000000')
THEN
p.GEGB_ACC_MASSIMALI
WHEN NVL (fgb.flg_gruppo_economico, '0') = 0
THEN
NULL
ELSE
fgb.GEGB_ACC_MASSIMALI
END
GEGB_ACC_MASSIMALI,
CASE
WHEN NVL (fgb.flg_last_run, '0') = '0'
AND NVL (fgb.id_dper_gb, '00000000') <>
NVL (p.id_dper_gb, '00000000')
THEN
p.GEGB_ACC_MASSIMALI_DT
WHEN NVL (fgb.flg_gruppo_economico, '0') = 0
THEN
NULL
ELSE
fgb.GEGB_ACC_MASSIMALI_DT
END
GEGB_ACC_MASSIMALI_DT,
CASE
WHEN NVL (fgb.flg_last_run, '0') = '0'
AND NVL (fgb.id_dper_gb, '00000000') <>
NVL (p.id_dper_gb, '00000000')
THEN
p.GEGB_ACC_RISCHI_INDIRETTI
WHEN NVL (fgb.flg_gruppo_economico, '0') = 0
THEN
NULL
ELSE
fgb.GEGB_ACC_RISCHI_INDIRETTI
END
GEGB_ACC_RISCHI_INDIRETTI,
CASE
WHEN NVL (fgb.flg_last_run, '0') = '0'
AND NVL (fgb.id_dper_gb, '00000000') <>
NVL (p.id_dper_gb, '00000000')
THEN
p.GEGB_ACC_RISCHI_INDIRETTI_DT
WHEN NVL (fgb.flg_gruppo_economico, '0') = 0
THEN
NULL
ELSE
fgb.GEGB_ACC_RISCHI_INDIRETTI_DT
END
GEGB_ACC_RISCHI_INDIRETTI_DT,
CASE
WHEN NVL (fgb.flg_last_run, '0') = '0'
AND NVL (fgb.id_dper_gb, '00000000') <>
NVL (p.id_dper_gb, '00000000')
THEN
p.GEGB_ACC_SMOBILIZZO
WHEN NVL (fgb.flg_gruppo_economico, '0') = 0
THEN
NULL
ELSE
fgb.GEGB_ACC_SMOBILIZZO
END
GEGB_ACC_SMOBILIZZO,
CASE
WHEN NVL (fgb.flg_last_run, '0') = '0'
AND NVL (fgb.id_dper_gb, '00000000') <>
NVL (p.id_dper_gb, '00000000')
THEN
p.GEGB_ACC_SOSTITUZIONI
WHEN NVL (fgb.flg_gruppo_economico, '0') = 0
THEN
NULL
ELSE
fgb.GEGB_ACC_SOSTITUZIONI
END
GEGB_ACC_SOSTITUZIONI,
CASE
WHEN NVL (fgb.flg_last_run, '0') = '0'
AND NVL (fgb.id_dper_gb, '00000000') <>
NVL (p.id_dper_gb, '00000000')
THEN
p.GEGB_ACC_SOSTITUZIONI_DT
WHEN NVL (fgb.flg_gruppo_economico, '0') = 0
THEN
NULL
ELSE
fgb.GEGB_ACC_SOSTITUZIONI_DT
END
GEGB_ACC_SOSTITUZIONI_DT,
CASE
WHEN NVL (fgb.flg_last_run, '0') = '0'
AND NVL (fgb.id_dper_gb, '00000000') <>
NVL (p.id_dper_gb, '00000000')
THEN
p.GEGB_TOT_GAR
WHEN NVL (fgb.flg_gruppo_economico, '0') = 0
THEN
NULL
ELSE
fgb.GEGB_TOT_GAR
END
GEGB_TOT_GAR,
CASE
WHEN NVL (fgb.flg_last_run, '0') = '0'
AND NVL (fgb.id_dper_gb, '00000000') <>
NVL (p.id_dper_gb, '00000000')
THEN
p.GEGB_UTI_CASSA_BT
WHEN NVL (fgb.flg_gruppo_economico, '0') = 0
THEN
NULL
ELSE
fgb.GEGB_UTI_CASSA_BT
END
GEGB_UTI_CASSA_BT,
CASE
WHEN NVL (fgb.flg_last_run, '0') = '0'
AND NVL (fgb.id_dper_gb, '00000000') <>
NVL (p.id_dper_gb, '00000000')
THEN
p.GEGB_UTI_CASSA_MLT
WHEN NVL (fgb.flg_gruppo_economico, '0') = 0
THEN
NULL
ELSE
fgb.GEGB_UTI_CASSA_MLT
END
GEGB_UTI_CASSA_MLT,
CASE
WHEN NVL (fgb.flg_last_run, '0') = '0'
AND NVL (fgb.id_dper_gb, '00000000') <>
NVL (p.id_dper_gb, '00000000')
THEN
p.GEGB_UTI_CONSEGNE
WHEN NVL (fgb.flg_gruppo_economico, '0') = 0
THEN
NULL
ELSE
fgb.GEGB_UTI_CONSEGNE
END
GEGB_UTI_CONSEGNE,
CASE
WHEN NVL (fgb.flg_last_run, '0') = '0'
AND NVL (fgb.id_dper_gb, '00000000') <>
NVL (p.id_dper_gb, '00000000')
THEN
p.GEGB_UTI_CONSEGNE_DT
WHEN NVL (fgb.flg_gruppo_economico, '0') = 0
THEN
NULL
ELSE
fgb.GEGB_UTI_CONSEGNE_DT
END
GEGB_UTI_CONSEGNE_DT,
CASE
WHEN NVL (fgb.flg_last_run, '0') = '0'
AND NVL (fgb.id_dper_gb, '00000000') <>
NVL (p.id_dper_gb, '00000000')
THEN
p.GEGB_UTI_FIRMA_DT
WHEN NVL (fgb.flg_gruppo_economico, '0') = 0
THEN
NULL
ELSE
fgb.GEGB_UTI_FIRMA_DT
END
GEGB_UTI_FIRMA_DT,
CASE
WHEN NVL (fgb.flg_last_run, '0') = '0'
AND NVL (fgb.id_dper_gb, '00000000') <>
NVL (p.id_dper_gb, '00000000')
THEN
p.GEGB_UTI_MASSIMALI
WHEN NVL (fgb.flg_gruppo_economico, '0') = 0
THEN
NULL
ELSE
fgb.GEGB_UTI_MASSIMALI
END
GEGB_UTI_MASSIMALI,
CASE
WHEN NVL (fgb.flg_last_run, '0') = '0'
AND NVL (fgb.id_dper_gb, '00000000') <>
NVL (p.id_dper_gb, '00000000')
THEN
p.GEGB_UTI_MASSIMALI_DT
WHEN NVL (fgb.flg_gruppo_economico, '0') = 0
THEN
NULL
ELSE
fgb.GEGB_UTI_MASSIMALI_DT
END
GEGB_UTI_MASSIMALI_DT,
CASE
WHEN NVL (fgb.flg_last_run, '0') = '0'
AND NVL (fgb.id_dper_gb, '00000000') <>
NVL (p.id_dper_gb, '00000000')
THEN
p.GEGB_UTI_RISCHI_INDIRETTI
WHEN NVL (fgb.flg_gruppo_economico, '0') = 0
THEN
NULL
ELSE
fgb.GEGB_UTI_RISCHI_INDIRETTI
END
GEGB_UTI_RISCHI_INDIRETTI,
CASE
WHEN NVL (fgb.flg_last_run, '0') = '0'
AND NVL (fgb.id_dper_gb, '00000000') <>
NVL (p.id_dper_gb, '00000000')
THEN
p.GEGB_UTI_RISCHI_INDIRETTI_DT
WHEN NVL (fgb.flg_gruppo_economico, '0') = 0
THEN
NULL
ELSE
fgb.GEGB_UTI_RISCHI_INDIRETTI_DT
END
GEGB_UTI_RISCHI_INDIRETTI_DT,
CASE
WHEN NVL (fgb.flg_last_run, '0') = '0'
AND NVL (fgb.id_dper_gb, '00000000') <>
NVL (p.id_dper_gb, '00000000')
THEN
p.GEGB_UTI_SMOBILIZZO
WHEN NVL (fgb.flg_gruppo_economico, '0') = 0
THEN
NULL
ELSE
fgb.GEGB_UTI_SMOBILIZZO
END
GEGB_UTI_SMOBILIZZO,
CASE
WHEN NVL (fgb.flg_last_run, '0') = '0'
AND NVL (fgb.id_dper_gb, '00000000') <>
NVL (p.id_dper_gb, '00000000')
THEN
p.GEGB_UTI_SOSTITUZIONI
WHEN NVL (fgb.flg_gruppo_economico, '0') = 0
THEN
NULL
ELSE
fgb.GEGB_UTI_SOSTITUZIONI
END
GEGB_UTI_SOSTITUZIONI,
CASE
WHEN NVL (fgb.flg_last_run, '0') = '0'
AND NVL (fgb.id_dper_gb, '00000000') <>
NVL (p.id_dper_gb, '00000000')
THEN
p.GEGB_UTI_SOSTITUZIONI_DT
WHEN NVL (fgb.flg_gruppo_economico, '0') = 0
THEN
NULL
ELSE
fgb.GEGB_UTI_SOSTITUZIONI_DT
END
GEGB_UTI_SOSTITUZIONI_DT,
CASE
WHEN NVL (fgb.flg_last_run, '0') = '0'
AND NVL (fgb.id_dper_gb, '00000000') <>
NVL (p.id_dper_gb, '00000000')
THEN
p.GLGB_ACC_CASSA
WHEN NVL (fgb.flg_gruppo_legame, '0') = 0
THEN
NULL
ELSE
fgb.GLGB_ACC_CASSA
END
GLGB_ACC_CASSA,
CASE
WHEN NVL (fgb.flg_last_run, '0') = '0'
AND NVL (fgb.id_dper_gb, '00000000') <>
NVL (p.id_dper_gb, '00000000')
THEN
p.GLGB_ACC_CASSA_BT
WHEN NVL (fgb.flg_gruppo_legame, '0') = 0
THEN
NULL
ELSE
fgb.GLGB_ACC_CASSA_BT
END
GLGB_ACC_CASSA_BT,
CASE
WHEN NVL (fgb.flg_last_run, '0') = '0'
AND NVL (fgb.id_dper_gb, '00000000') <>
NVL (p.id_dper_gb, '00000000')
THEN
p.GLGB_ACC_CASSA_MLT
WHEN NVL (fgb.flg_gruppo_legame, '0') = 0
THEN
NULL
ELSE
fgb.GLGB_ACC_CASSA_MLT
END
GLGB_ACC_CASSA_MLT,
CASE
WHEN NVL (fgb.flg_last_run, '0') = '0'
AND NVL (fgb.id_dper_gb, '00000000') <>
NVL (p.id_dper_gb, '00000000')
THEN
p.GLGB_ACC_CONSEGNE
WHEN NVL (fgb.flg_gruppo_legame, '0') = 0
THEN
NULL
ELSE
fgb.GLGB_ACC_CONSEGNE
END
GLGB_ACC_CONSEGNE,
CASE
WHEN NVL (fgb.flg_last_run, '0') = '0'
AND NVL (fgb.id_dper_gb, '00000000') <>
NVL (p.id_dper_gb, '00000000')
THEN
p.GLGB_ACC_CONSEGNE_DT
WHEN NVL (fgb.flg_gruppo_legame, '0') = 0
THEN
NULL
ELSE
fgb.GLGB_ACC_CONSEGNE_DT
END
GLGB_ACC_CONSEGNE_DT,
CASE
WHEN NVL (fgb.flg_last_run, '0') = '0'
AND NVL (fgb.id_dper_gb, '00000000') <>
NVL (p.id_dper_gb, '00000000')
THEN
p.GLGB_ACC_FIRMA
WHEN NVL (fgb.flg_gruppo_legame, '0') = 0
THEN
NULL
ELSE
fgb.GLGB_ACC_FIRMA
END
GLGB_ACC_FIRMA,
CASE
WHEN NVL (fgb.flg_last_run, '0') = '0'
AND NVL (fgb.id_dper_gb, '00000000') <>
NVL (p.id_dper_gb, '00000000')
THEN
p.GLGB_ACC_FIRMA_DT
WHEN NVL (fgb.flg_gruppo_legame, '0') = 0
THEN
NULL
ELSE
fgb.GLGB_ACC_FIRMA_DT
END
GLGB_ACC_FIRMA_DT,
CASE
WHEN NVL (fgb.flg_last_run, '0') = '0'
AND NVL (fgb.id_dper_gb, '00000000') <>
NVL (p.id_dper_gb, '00000000')
THEN
p.GLGB_ACC_MASSIMALI
WHEN NVL (fgb.flg_gruppo_legame, '0') = 0
THEN
NULL
ELSE
fgb.GLGB_ACC_MASSIMALI
END
GLGB_ACC_MASSIMALI,
CASE
WHEN NVL (fgb.flg_last_run, '0') = '0'
AND NVL (fgb.id_dper_gb, '00000000') <>
NVL (p.id_dper_gb, '00000000')
THEN
p.GLGB_ACC_MASSIMALI_DT
WHEN NVL (fgb.flg_gruppo_legame, '0') = 0
THEN
NULL
ELSE
fgb.GLGB_ACC_MASSIMALI_DT
END
GLGB_ACC_MASSIMALI_DT,
CASE
WHEN NVL (fgb.flg_last_run, '0') = '0'
AND NVL (fgb.id_dper_gb, '00000000') <>
NVL (p.id_dper_gb, '00000000')
THEN
p.GLGB_ACC_RISCHI_INDIRETTI
WHEN NVL (fgb.flg_gruppo_legame, '0') = 0
THEN
NULL
ELSE
fgb.GLGB_ACC_RISCHI_INDIRETTI
END
GLGB_ACC_RISCHI_INDIRETTI,
CASE
WHEN NVL (fgb.flg_last_run, '0') = '0'
AND NVL (fgb.id_dper_gb, '00000000') <>
NVL (p.id_dper_gb, '00000000')
THEN
p.GLGB_ACC_RISCHI_INDIRETTI_DT
WHEN NVL (fgb.flg_gruppo_legame, '0') = 0
THEN
NULL
ELSE
fgb.GLGB_ACC_RISCHI_INDIRETTI_DT
END
GLGB_ACC_RISCHI_INDIRETTI_DT,
CASE
WHEN NVL (fgb.flg_last_run, '0') = '0'
AND NVL (fgb.id_dper_gb, '00000000') <>
NVL (p.id_dper_gb, '00000000')
THEN
p.GLGB_ACC_SMOBILIZZO
WHEN NVL (fgb.flg_gruppo_legame, '0') = 0
THEN
NULL
ELSE
fgb.GLGB_ACC_SMOBILIZZO
END
GLGB_ACC_SMOBILIZZO,
CASE
WHEN NVL (fgb.flg_last_run, '0') = '0'
AND NVL (fgb.id_dper_gb, '00000000') <>
NVL (p.id_dper_gb, '00000000')
THEN
p.GLGB_ACC_SOSTITUZIONI
WHEN NVL (fgb.flg_gruppo_legame, '0') = 0
THEN
NULL
ELSE
fgb.GLGB_ACC_SOSTITUZIONI
END
GLGB_ACC_SOSTITUZIONI,
CASE
WHEN NVL (fgb.flg_last_run, '0') = '0'
AND NVL (fgb.id_dper_gb, '00000000') <>
NVL (p.id_dper_gb, '00000000')
THEN
p.GLGB_ACC_SOSTITUZIONI_DT
WHEN NVL (fgb.flg_gruppo_legame, '0') = 0
THEN
NULL
ELSE
fgb.GLGB_ACC_SOSTITUZIONI_DT
END
GLGB_ACC_SOSTITUZIONI_DT,
CASE
WHEN NVL (fgb.flg_last_run, '0') = '0'
AND NVL (fgb.id_dper_gb, '00000000') <>
NVL (p.id_dper_gb, '00000000')
THEN
p.GLGB_ACC_TOT
WHEN NVL (fgb.flg_gruppo_legame, '0') = 0
THEN
NULL
ELSE
fgb.GLGB_ACC_TOT
END
GLGB_ACC_TOT,
CASE
WHEN NVL (fgb.flg_last_run, '0') = '0'
AND NVL (fgb.id_dper_gb, '00000000') <>
NVL (p.id_dper_gb, '00000000')
THEN
p.GLGB_TOT_GAR
WHEN NVL (fgb.flg_gruppo_legame, '0') = 0
THEN
NULL
ELSE
fgb.GLGB_TOT_GAR
END
GLGB_TOT_GAR,
CASE
WHEN NVL (fgb.flg_last_run, '0') = '0'
AND NVL (fgb.id_dper_gb, '00000000') <>
NVL (p.id_dper_gb, '00000000')
THEN
p.GLGB_UTI_CASSA
WHEN NVL (fgb.flg_gruppo_legame, '0') = 0
THEN
NULL
ELSE
fgb.GLGB_UTI_CASSA
END
GLGB_UTI_CASSA,
CASE
WHEN NVL (fgb.flg_last_run, '0') = '0'
AND NVL (fgb.id_dper_gb, '00000000') <>
NVL (p.id_dper_gb, '00000000')
THEN
p.GLGB_UTI_CASSA_BT
WHEN NVL (fgb.flg_gruppo_legame, '0') = 0
THEN
NULL
ELSE
fgb.GLGB_UTI_CASSA_BT
END
GLGB_UTI_CASSA_BT,
CASE
WHEN NVL (fgb.flg_last_run, '0') = '0'
AND NVL (fgb.id_dper_gb, '00000000') <>
NVL (p.id_dper_gb, '00000000')
THEN
p.GLGB_UTI_CASSA_MLT
WHEN NVL (fgb.flg_gruppo_legame, '0') = 0
THEN
NULL
ELSE
fgb.GLGB_UTI_CASSA_MLT
END
GLGB_UTI_CASSA_MLT,
CASE
WHEN NVL (fgb.flg_last_run, '0') = '0'
AND NVL (fgb.id_dper_gb, '00000000') <>
NVL (p.id_dper_gb, '00000000')
THEN
p.GLGB_UTI_CONSEGNE
WHEN NVL (fgb.flg_gruppo_legame, '0') = 0
THEN
NULL
ELSE
fgb.GLGB_UTI_CONSEGNE
END
GLGB_UTI_CONSEGNE,
CASE
WHEN NVL (fgb.flg_last_run, '0') = '0'
AND NVL (fgb.id_dper_gb, '00000000') <>
NVL (p.id_dper_gb, '00000000')
THEN
p.GLGB_UTI_CONSEGNE_DT
WHEN NVL (fgb.flg_gruppo_legame, '0') = 0
THEN
NULL
ELSE
fgb.GLGB_UTI_CONSEGNE_DT
END
GLGB_UTI_CONSEGNE_DT,
CASE
WHEN NVL (fgb.flg_last_run, '0') = '0'
AND NVL (fgb.id_dper_gb, '00000000') <>
NVL (p.id_dper_gb, '00000000')
THEN
p.GLGB_UTI_FIRMA
WHEN NVL (fgb.flg_gruppo_legame, '0') = 0
THEN
NULL
ELSE
fgb.GLGB_UTI_FIRMA
END
GLGB_UTI_FIRMA,
CASE
WHEN NVL (fgb.flg_last_run, '0') = '0'
AND NVL (fgb.id_dper_gb, '00000000') <>
NVL (p.id_dper_gb, '00000000')
THEN
p.GLGB_UTI_FIRMA_DT
WHEN NVL (fgb.flg_gruppo_legame, '0') = 0
THEN
NULL
ELSE
fgb.GLGB_UTI_FIRMA_DT
END
GLGB_UTI_FIRMA_DT,
CASE
WHEN NVL (fgb.flg_last_run, '0') = '0'
AND NVL (fgb.id_dper_gb, '00000000') <>
NVL (p.id_dper_gb, '00000000')
THEN
p.GLGB_UTI_MASSIMALI
WHEN NVL (fgb.flg_gruppo_legame, '0') = 0
THEN
NULL
ELSE
fgb.GLGB_UTI_MASSIMALI
END
GLGB_UTI_MASSIMALI,
CASE
WHEN NVL (fgb.flg_last_run, '0') = '0'
AND NVL (fgb.id_dper_gb, '00000000') <>
NVL (p.id_dper_gb, '00000000')
THEN
p.GLGB_UTI_MASSIMALI_DT
WHEN NVL (fgb.flg_gruppo_legame, '0') = 0
THEN
NULL
ELSE
fgb.GLGB_UTI_MASSIMALI_DT
END
GLGB_UTI_MASSIMALI_DT,
CASE
WHEN NVL (fgb.flg_last_run, '0') = '0'
AND NVL (fgb.id_dper_gb, '00000000') <>
NVL (p.id_dper_gb, '00000000')
THEN
p.GLGB_UTI_RISCHI_INDIRETTI
WHEN NVL (fgb.flg_gruppo_legame, '0') = 0
THEN
NULL
ELSE
fgb.GLGB_UTI_RISCHI_INDIRETTI
END
GLGB_UTI_RISCHI_INDIRETTI,
CASE
WHEN NVL (fgb.flg_last_run, '0') = '0'
AND NVL (fgb.id_dper_gb, '00000000') <>
NVL (p.id_dper_gb, '00000000')
THEN
p.GLGB_UTI_RISCHI_INDIRETTI_DT
WHEN NVL (fgb.flg_gruppo_legame, '0') = 0
THEN
NULL
ELSE
fgb.GLGB_UTI_RISCHI_INDIRETTI_DT
END
GLGB_UTI_RISCHI_INDIRETTI_DT,
CASE
WHEN NVL (fgb.flg_last_run, '0') = '0'
AND NVL (fgb.id_dper_gb, '00000000') <>
NVL (p.id_dper_gb, '00000000')
THEN
p.GLGB_UTI_SMOBILIZZO
WHEN NVL (fgb.flg_gruppo_legame, '0') = 0
THEN
NULL
ELSE
fgb.GLGB_UTI_SMOBILIZZO
END
GLGB_UTI_SMOBILIZZO,
CASE
WHEN NVL (fgb.flg_last_run, '0') = '0'
AND NVL (fgb.id_dper_gb, '00000000') <>
NVL (p.id_dper_gb, '00000000')
THEN
p.GLGB_UTI_SOSTITUZIONI
WHEN NVL (fgb.flg_gruppo_legame, '0') = 0
THEN
NULL
ELSE
fgb.GLGB_UTI_SOSTITUZIONI
END
GLGB_UTI_SOSTITUZIONI,
CASE
WHEN NVL (fgb.flg_last_run, '0') = '0'
AND NVL (fgb.id_dper_gb, '00000000') <>
NVL (p.id_dper_gb, '00000000')
THEN
p.GLGB_UTI_SOSTITUZIONI_DT
WHEN NVL (fgb.flg_gruppo_legame, '0') = 0
THEN
NULL
ELSE
fgb.GLGB_UTI_SOSTITUZIONI_DT
END
GLGB_UTI_SOSTITUZIONI_DT,
CASE
WHEN NVL (fgb.flg_last_run, '0') = '0'
AND NVL (fgb.id_dper_gb, '00000000') <>
NVL (p.id_dper_gb, '00000000')
THEN
p.GLGB_UTI_TOT
WHEN NVL (fgb.flg_gruppo_legame, '0') = 0
THEN
NULL
ELSE
fgb.GLGB_UTI_TOT
END
GLGB_UTI_TOT,
CASE
WHEN NVL (fgb.flg_last_run, '0') = '0'
AND NVL (fgb.id_dper_gb, '00000000') <>
NVL (p.id_dper_gb, '00000000')
THEN
p.SCGB_ACC_CASSA
ELSE
fgb.SCGB_ACC_CASSA
END
SCGB_ACC_CASSA,
CASE
WHEN NVL (fgb.flg_last_run, '0') = '0'
AND NVL (fgb.id_dper_gb, '00000000') <>
NVL (p.id_dper_gb, '00000000')
THEN
p.SCGB_ACC_CASSA_BT
ELSE
fgb.SCGB_ACC_CASSA_BT
END
SCGB_ACC_CASSA_BT,
CASE
WHEN NVL (fgb.flg_last_run, '0') = '0'
AND NVL (fgb.id_dper_gb, '00000000') <>
NVL (p.id_dper_gb, '00000000')
THEN
p.SCGB_ACC_CASSA_MLT
ELSE
fgb.SCGB_ACC_CASSA_MLT
END
SCGB_ACC_CASSA_MLT,
CASE
WHEN NVL (fgb.flg_last_run, '0') = '0'
AND NVL (fgb.id_dper_gb, '00000000') <>
NVL (p.id_dper_gb, '00000000')
THEN
p.SCGB_ACC_CONSEGNE
ELSE
fgb.SCGB_ACC_CONSEGNE
END
SCGB_ACC_CONSEGNE,
CASE
WHEN NVL (fgb.flg_last_run, '0') = '0'
AND NVL (fgb.id_dper_gb, '00000000') <>
NVL (p.id_dper_gb, '00000000')
THEN
p.SCGB_ACC_CONSEGNE_DT
ELSE
fgb.SCGB_ACC_CONSEGNE_DT
END
SCGB_ACC_CONSEGNE_DT,
CASE
WHEN NVL (fgb.flg_last_run, '0') = '0'
AND NVL (fgb.id_dper_gb, '00000000') <>
NVL (p.id_dper_gb, '00000000')
THEN
p.SCGB_ACC_FIRMA
ELSE
fgb.SCGB_ACC_FIRMA
END
SCGB_ACC_FIRMA,
CASE
WHEN NVL (fgb.flg_last_run, '0') = '0'
AND NVL (fgb.id_dper_gb, '00000000') <>
NVL (p.id_dper_gb, '00000000')
THEN
p.SCGB_ACC_FIRMA_DT
ELSE
fgb.SCGB_ACC_FIRMA_DT
END
SCGB_ACC_FIRMA_DT,
CASE
WHEN NVL (fgb.flg_last_run, '0') = '0'
AND NVL (fgb.id_dper_gb, '00000000') <>
NVL (p.id_dper_gb, '00000000')
THEN
p.SCGB_ACC_MASSIMALI
ELSE
fgb.SCGB_ACC_MASSIMALI
END
SCGB_ACC_MASSIMALI,
CASE
WHEN NVL (fgb.flg_last_run, '0') = '0'
AND NVL (fgb.id_dper_gb, '00000000') <>
NVL (p.id_dper_gb, '00000000')
THEN
p.SCGB_ACC_MASSIMALI_DT
ELSE
fgb.SCGB_ACC_MASSIMALI_DT
END
SCGB_ACC_MASSIMALI_DT,
CASE
WHEN NVL (fgb.flg_last_run, '0') = '0'
AND NVL (fgb.id_dper_gb, '00000000') <>
NVL (p.id_dper_gb, '00000000')
THEN
p.SCGB_ACC_RISCHI_INDIRETTI
ELSE
fgb.SCGB_ACC_RISCHI_INDIRETTI
END
SCGB_ACC_RISCHI_INDIRETTI,
CASE
WHEN NVL (fgb.flg_last_run, '0') = '0'
AND NVL (fgb.id_dper_gb, '00000000') <>
NVL (p.id_dper_gb, '00000000')
THEN
p.SCGB_ACC_RISCHI_INDIRETTI_DT
ELSE
fgb.SCGB_ACC_RISCHI_INDIRETTI_DT
END
SCGB_ACC_RISCHI_INDIRETTI_DT,
CASE
WHEN NVL (fgb.flg_last_run, '0') = '0'
AND NVL (fgb.id_dper_gb, '00000000') <>
NVL (p.id_dper_gb, '00000000')
THEN
p.SCGB_ACC_SMOBILIZZO
ELSE
fgb.SCGB_ACC_SMOBILIZZO
END
SCGB_ACC_SMOBILIZZO,
CASE
WHEN NVL (fgb.flg_last_run, '0') = '0'
AND NVL (fgb.id_dper_gb, '00000000') <>
NVL (p.id_dper_gb, '00000000')
THEN
p.SCGB_ACC_SOSTITUZIONI
ELSE
fgb.SCGB_ACC_SOSTITUZIONI
END
SCGB_ACC_SOSTITUZIONI,
CASE
WHEN NVL (fgb.flg_last_run, '0') = '0'
AND NVL (fgb.id_dper_gb, '00000000') <>
NVL (p.id_dper_gb, '00000000')
THEN
p.SCGB_ACC_SOSTITUZIONI_DT
ELSE
fgb.SCGB_ACC_SOSTITUZIONI_DT
END
SCGB_ACC_SOSTITUZIONI_DT,
CASE
WHEN NVL (fgb.flg_last_run, '0') = '0'
AND NVL (fgb.id_dper_gb, '00000000') <>
NVL (p.id_dper_gb, '00000000')
THEN
p.SCGB_ACC_TOT
ELSE
fgb.SCGB_ACC_TOT
END
SCGB_ACC_TOT,
CASE
WHEN NVL (fgb.flg_last_run, '0') = '0'
AND NVL (fgb.id_dper_gb, '00000000') <>
NVL (p.id_dper_gb, '00000000')
THEN
p.SCGB_TOT_GAR
ELSE
fgb.SCGB_TOT_GAR
END
SCGB_TOT_GAR,
CASE
WHEN NVL (fgb.flg_last_run, '0') = '0'
AND NVL (fgb.id_dper_gb, '00000000') <>
NVL (p.id_dper_gb, '00000000')
THEN
p.SCGB_UTI_CASSA
ELSE
fgb.SCGB_UTI_CASSA
END
SCGB_UTI_CASSA,
CASE
WHEN NVL (fgb.flg_last_run, '0') = '0'
AND NVL (fgb.id_dper_gb, '00000000') <>
NVL (p.id_dper_gb, '00000000')
THEN
p.SCGB_UTI_CASSA_BT
ELSE
fgb.SCGB_UTI_CASSA_BT
END
SCGB_UTI_CASSA_BT,
CASE
WHEN NVL (fgb.flg_last_run, '0') = '0'
AND NVL (fgb.id_dper_gb, '00000000') <>
NVL (p.id_dper_gb, '00000000')
THEN
p.SCGB_UTI_CASSA_MLT
ELSE
fgb.SCGB_UTI_CASSA_MLT
END
SCGB_UTI_CASSA_MLT,
CASE
WHEN NVL (fgb.flg_last_run, '0') = '0'
AND NVL (fgb.id_dper_gb, '00000000') <>
NVL (p.id_dper_gb, '00000000')
THEN
p.SCGB_UTI_CONSEGNE
ELSE
fgb.SCGB_UTI_CONSEGNE
END
SCGB_UTI_CONSEGNE,
CASE
WHEN NVL (fgb.flg_last_run, '0') = '0'
AND NVL (fgb.id_dper_gb, '00000000') <>
NVL (p.id_dper_gb, '00000000')
THEN
p.SCGB_UTI_CONSEGNE_DT
ELSE
fgb.SCGB_UTI_CONSEGNE_DT
END
SCGB_UTI_CONSEGNE_DT,
CASE
WHEN NVL (fgb.flg_last_run, '0') = '0'
AND NVL (fgb.id_dper_gb, '00000000') <>
NVL (p.id_dper_gb, '00000000')
THEN
p.SCGB_UTI_FIRMA
ELSE
fgb.SCGB_UTI_FIRMA
END
SCGB_UTI_FIRMA,
CASE
WHEN NVL (fgb.flg_last_run, '0') = '0'
AND NVL (fgb.id_dper_gb, '00000000') <>
NVL (p.id_dper_gb, '00000000')
THEN
p.SCGB_UTI_FIRMA_DT
ELSE
fgb.SCGB_UTI_FIRMA_DT
END
SCGB_UTI_FIRMA_DT,
CASE
WHEN NVL (fgb.flg_last_run, '0') = '0'
AND NVL (fgb.id_dper_gb, '00000000') <>
NVL (p.id_dper_gb, '00000000')
THEN
p.SCGB_UTI_MASSIMALI
ELSE
fgb.SCGB_UTI_MASSIMALI
END
SCGB_UTI_MASSIMALI,
CASE
WHEN NVL (fgb.flg_last_run, '0') = '0'
AND NVL (fgb.id_dper_gb, '00000000') <>
NVL (p.id_dper_gb, '00000000')
THEN
p.SCGB_UTI_MASSIMALI_DT
ELSE
fgb.SCGB_UTI_MASSIMALI_DT
END
SCGB_UTI_MASSIMALI_DT,
CASE
WHEN NVL (fgb.flg_last_run, '0') = '0'
AND NVL (fgb.id_dper_gb, '00000000') <>
NVL (p.id_dper_gb, '00000000')
THEN
p.SCGB_UTI_RISCHI_INDIRETTI
ELSE
fgb.SCGB_UTI_RISCHI_INDIRETTI
END
SCGB_UTI_RISCHI_INDIRETTI,
CASE
WHEN NVL (fgb.flg_last_run, '0') = '0'
AND NVL (fgb.id_dper_gb, '00000000') <>
NVL (p.id_dper_gb, '00000000')
THEN
p.SCGB_UTI_RISCHI_INDIRETTI_DT
ELSE
fgb.SCGB_UTI_RISCHI_INDIRETTI_DT
END
SCGB_UTI_RISCHI_INDIRETTI_DT,
CASE
WHEN NVL (fgb.flg_last_run, '0') = '0'
AND NVL (fgb.id_dper_gb, '00000000') <>
NVL (p.id_dper_gb, '00000000')
THEN
p.SCGB_UTI_SMOBILIZZO
ELSE
fgb.SCGB_UTI_SMOBILIZZO
END
SCGB_UTI_SMOBILIZZO,
CASE
WHEN NVL (fgb.flg_last_run, '0') = '0'
AND NVL (fgb.id_dper_gb, '00000000') <>
NVL (p.id_dper_gb, '00000000')
THEN
p.SCGB_UTI_SOSTITUZIONI
ELSE
fgb.SCGB_UTI_SOSTITUZIONI
END
SCGB_UTI_SOSTITUZIONI,
CASE
WHEN NVL (fgb.flg_last_run, '0') = '0'
AND NVL (fgb.id_dper_gb, '00000000') <>
NVL (p.id_dper_gb, '00000000')
THEN
p.SCGB_UTI_SOSTITUZIONI_DT
ELSE
fgb.SCGB_UTI_SOSTITUZIONI_DT
END
SCGB_UTI_SOSTITUZIONI_DT,
CASE
WHEN NVL (fgb.flg_last_run, '0') = '0'
AND NVL (fgb.id_dper_gb, '00000000') <>
NVL (p.id_dper_gb, '00000000')
AND NVL (fgb.flg_last_run, '0') = '0'
THEN
p.SCGB_UTI_TOT
ELSE
fgb.SCGB_UTI_TOT
END
SCGB_UTI_TOT,
--MAU
CASE
WHEN NVL (fgb.flg_last_run, '0') = '0'
AND NVL (fgb.id_dper_gb, '00000000') <>
NVL (p.id_dper_gb, '00000000')
THEN
p.SCGB_MAU
ELSE
fgb.SCGB_MAU
END
SCGB_MAU,
--p.GB_VAL_MAU GB_VAL_MAU_1,
NVL (
p.gb_val_mau,
DECODE (
NVL (fgb.flg_gruppo_economico, '0'),
1, fgb.gegb_mau,
DECODE (NVL (fgb.flg_gruppo_legame, '0'),
1, fgb.glgb_mau,
fgb.scgb_mau)))
GB_VAL_MAU_2,
CASE
WHEN NVL (fgb.flg_last_run, '0') = '0'
AND NVL (fgb.id_dper_gb, '00000000') <>
NVL (p.id_dper_gb, '00000000')
THEN
p.GB_VAL_MAU
ELSE
NVL (
p.gb_val_mau,
DECODE (
NVL (fgb.flg_gruppo_economico, '0'),
1, fgb.gegb_mau,
DECODE (
NVL (fgb.flg_gruppo_legame, '0'),
1, fgb.glgb_mau,
fgb.scgb_mau)))
END
GB_VAL_MAU,
CASE
WHEN NVL (fgb.flg_last_run, '0') = '0'
AND NVL (fgb.id_dper_gb, '00000000') <>
NVL (p.id_dper_gb, '00000000')
THEN
p.GLGB_MAU
WHEN NVL (fgb.flg_gruppo_legame, '0') = 0
THEN
NULL
ELSE
fgb.GLGB_MAU
END
GLGB_MAU,
CASE
WHEN NVL (fgb.flg_last_run, '0') = '0'
AND NVL (fgb.id_dper_gb, '00000000') <>
NVL (p.id_dper_gb, '00000000')
THEN
p.GEGB_MAU
WHEN NVL (fgb.flg_gruppo_economico, '0') = 0
THEN
NULL
ELSE
fgb.GEGB_MAU
END
GEGB_MAU,
CASE
WHEN NVL (fgb.flg_last_run, '0') = '0'
AND NVL (fgb.id_dper_gb, '00000000') <>
NVL (p.id_dper_gb, '00000000')
THEN
p.GEGB_UTI_CASSA
WHEN NVL (fgb.flg_gruppo_economico, '0') = 0
THEN
NULL
ELSE
fgb.GEGB_UTI_CASSA
END
GEGB_UTI_CASSA,
CASE
WHEN NVL (fgb.flg_last_run, '0') = '0'
AND NVL (fgb.id_dper_gb, '00000000') <>
NVL (p.id_dper_gb, '00000000')
THEN
p.GEGB_UTI_FIRMA
WHEN NVL (fgb.flg_gruppo_economico, '0') = 0
THEN
NULL
ELSE
fgb.GEGB_UTI_FIRMA
END
GEGB_UTI_FIRMA,
CASE
WHEN NVL (fgb.flg_last_run, '0') = '0'
AND NVL (fgb.id_dper_gb, '00000000') <>
NVL (p.id_dper_gb, '00000000')
THEN
p.GEGB_UTI_TOT
WHEN NVL (fgb.flg_gruppo_economico, '0') = 0
THEN
NULL
ELSE
fgb.GEGB_UTI_TOT
END
GEGB_UTI_TOT,
CASE
WHEN NVL (fgb.flg_last_run, '0') = '0'
AND NVL (fgb.id_dper_gb, '00000000') <>
NVL (p.id_dper_gb, '00000000')
THEN
p.GEGB_ACC_CASSA
WHEN NVL (fgb.flg_gruppo_economico, '0') = 0
THEN
NULL
ELSE
fgb.GEGB_ACC_CASSA
END
GEGB_ACC_CASSA,
CASE
WHEN NVL (fgb.flg_last_run, '0') = '0'
AND NVL (fgb.id_dper_gb, '00000000') <>
NVL (p.id_dper_gb, '00000000')
THEN
p.GEGB_ACC_FIRMA
WHEN NVL (fgb.flg_gruppo_economico, '0') = 0
THEN
NULL
ELSE
fgb.GEGB_ACC_FIRMA
END
GEGB_ACC_FIRMA,
CASE
WHEN NVL (fgb.flg_last_run, '0') = '0'
AND NVL (fgb.id_dper_gb, '00000000') <>
NVL (p.id_dper_gb, '00000000')
THEN
p.GEGB_ACC_TOT
WHEN NVL (fgb.flg_gruppo_economico, '0') = 0
THEN
NULL
ELSE
fgb.GEGB_ACC_TOT
END
GEGB_ACC_TOT
FROM MCRE_OWN.T_MCRE0_APP_PCR_GB_MRG fgb,
MCRE_OWN.T_MCRE0_APP_PCR24 p,
MCRE_OWN.T_MCRE0_APP_PCR_SCSB_MRG sc,
MCRE_OWN.T_MCRE0_APP_PCR_GESB_MRG ge
WHERE fgb.cod_abi_cartolarizzato =
p.cod_abi_cartolarizzato(+)
AND fgb.cod_ndg = p.cod_ndg(+)
AND fgb.cod_abi_cartolarizzato =
sc.cod_abi_cartolarizzato(+)
AND fgb.cod_ndg = sc.cod_ndg(+)
AND fgb.cod_abi_cartolarizzato =
ge.cod_abi_cartolarizzato(+)
AND fgb.cod_ndg = ge.cod_ndg(+))
WHERE NOT (
    geGB_ACC_consegne IS NULL
AND geGB_ACC_consegne_dt IS NULL
AND geGB_uti_consegne IS NULL
AND geGB_uti_consegne_dt IS NULL
AND gesB_ACC_consegne IS NULL
AND gesB_ACC_consegne_dt IS NULL
AND gesB_uti_consegne IS NULL
AND gesB_uti_consegne_dt IS NULL
AND glGB_ACC_consegne IS NULL
AND glGB_ACC_consegne_dt IS NULL
AND glGB_uti_consegne IS NULL
AND glGB_uti_consegne_dt IS NULL
AND scGB_uti_consegne_dt IS NULL
AND scGB_uti_consegne IS NULL
AND scGB_acc_consegne_dt IS NULL
AND scGB_acc_consegne IS NULL
AND scsB_uti_consegne_dt IS NULL
AND scsB_uti_consegne IS NULL
AND scsB_acc_consegne_dt IS NULL
AND scsB_acc_consegne IS NULL
AND GEGB_ACC_CASSA IS NULL
AND GEGB_ACC_CASSA_BT IS NULL
AND GEGB_ACC_CASSA_MLT IS NULL
AND GEGB_ACC_FIRMA IS NULL
AND GEGB_ACC_FIRMA_DT IS NULL
AND GEGB_ACC_MASSIMALI IS NULL
AND GEGB_ACC_MASSIMALI_DT IS NULL
AND GEGB_ACC_RISCHI_INDIRETTI IS NULL
AND GEGB_ACC_RISCHI_INDIRETTI_DT IS NULL
AND GEGB_ACC_SMOBILIZZO IS NULL
AND GEGB_ACC_SOSTITUZIONI IS NULL
AND GEGB_ACC_SOSTITUZIONI_DT IS NULL
AND GEGB_ACC_TOT IS NULL
AND GEGB_UTI_CASSA IS NULL
AND GEGB_UTI_CASSA_BT IS NULL
AND GEGB_UTI_CASSA_MLT IS NULL
AND GEGB_UTI_FIRMA IS NULL
AND GEGB_UTI_FIRMA_DT IS NULL
AND GEGB_UTI_MASSIMALI IS NULL
AND GEGB_UTI_MASSIMALI_DT IS NULL
AND GEGB_UTI_RISCHI_INDIRETTI IS NULL
AND GEGB_UTI_RISCHI_INDIRETTI_DT IS NULL
AND GEGB_UTI_SMOBILIZZO IS NULL
AND GEGB_UTI_SOSTITUZIONI IS NULL
AND GEGB_UTI_SOSTITUZIONI_DT IS NULL
AND GEGB_UTI_TOT IS NULL
AND GESB_ACC_CASSA IS NULL
AND GESB_ACC_CASSA_BT IS NULL
AND GESB_ACC_CASSA_MLT IS NULL
AND GESB_ACC_FIRMA IS NULL
AND GESB_ACC_FIRMA_DT IS NULL
AND GESB_ACC_MASSIMALI IS NULL
AND GESB_ACC_MASSIMALI_DT IS NULL
AND GESB_ACC_RISCHI_INDIRETTI IS NULL
AND GESB_ACC_RISCHI_INDIRETTI_DT IS NULL
AND GESB_ACC_SMOBILIZZO IS NULL
AND GESB_ACC_SOSTITUZIONI IS NULL
AND GESB_ACC_SOSTITUZIONI_DT IS NULL
AND GESB_ACC_TOT IS NULL
AND GESB_UTI_CASSA IS NULL
AND GESB_UTI_CASSA_BT IS NULL
AND GESB_UTI_CASSA_MLT IS NULL
AND GESB_UTI_FIRMA IS NULL
AND GESB_UTI_FIRMA_DT IS NULL
AND GESB_UTI_MASSIMALI IS NULL
AND GESB_UTI_MASSIMALI_DT IS NULL
AND GESB_UTI_RISCHI_INDIRETTI IS NULL
AND GESB_UTI_RISCHI_INDIRETTI_DT IS NULL
AND GESB_UTI_SMOBILIZZO IS NULL
AND GESB_UTI_SOSTITUZIONI IS NULL
AND GESB_UTI_SOSTITUZIONI_DT IS NULL
AND GESB_UTI_TOT IS NULL
AND GLGB_ACC_CASSA IS NULL
AND GLGB_ACC_CASSA_BT IS NULL
AND GLGB_ACC_CASSA_MLT IS NULL
AND GLGB_ACC_FIRMA IS NULL
AND GLGB_ACC_FIRMA_DT IS NULL
AND GLGB_ACC_MASSIMALI IS NULL
AND GLGB_ACC_MASSIMALI_DT IS NULL
AND GLGB_ACC_RISCHI_INDIRETTI IS NULL
AND GLGB_ACC_RISCHI_INDIRETTI_DT IS NULL
AND GLGB_ACC_SMOBILIZZO IS NULL
AND GLGB_ACC_SOSTITUZIONI IS NULL
AND GLGB_ACC_SOSTITUZIONI_DT IS NULL
AND GLGB_ACC_TOT IS NULL
AND GLGB_UTI_CASSA IS NULL
AND GLGB_UTI_CASSA_BT IS NULL
AND GLGB_UTI_CASSA_MLT IS NULL
AND GLGB_UTI_FIRMA IS NULL
AND GLGB_UTI_FIRMA_DT IS NULL
AND GLGB_UTI_MASSIMALI IS NULL
AND GLGB_UTI_MASSIMALI_DT IS NULL
AND GLGB_UTI_RISCHI_INDIRETTI IS NULL
AND GLGB_UTI_RISCHI_INDIRETTI_DT IS NULL
AND GLGB_UTI_SMOBILIZZO IS NULL
AND GLGB_UTI_SOSTITUZIONI IS NULL
AND GLGB_UTI_SOSTITUZIONI_DT IS NULL
AND GLGB_UTI_TOT IS NULL
AND SCGB_ACC_CASSA IS NULL
AND SCGB_ACC_CASSA_BT IS NULL
AND SCGB_ACC_CASSA_MLT IS NULL
AND SCGB_ACC_FIRMA IS NULL
AND SCGB_ACC_FIRMA_DT IS NULL
AND SCGB_ACC_MASSIMALI IS NULL
AND SCGB_ACC_MASSIMALI_DT IS NULL
AND SCGB_ACC_RISCHI_INDIRETTI IS NULL
AND SCGB_ACC_RISCHI_INDIRETTI_DT IS NULL
AND SCGB_ACC_SMOBILIZZO IS NULL
AND SCGB_ACC_SOSTITUZIONI IS NULL
AND SCGB_ACC_SOSTITUZIONI_DT IS NULL
AND SCGB_ACC_TOT IS NULL
AND SCGB_UTI_CASSA IS NULL
AND SCGB_UTI_CASSA_BT IS NULL
AND SCGB_UTI_CASSA_MLT IS NULL
AND SCGB_UTI_FIRMA IS NULL
AND SCGB_UTI_FIRMA_DT IS NULL
AND SCGB_UTI_MASSIMALI IS NULL
AND SCGB_UTI_MASSIMALI_DT IS NULL
AND SCGB_UTI_RISCHI_INDIRETTI IS NULL
AND SCGB_UTI_RISCHI_INDIRETTI_DT IS NULL
AND SCGB_UTI_SMOBILIZZO IS NULL
AND SCGB_UTI_SOSTITUZIONI IS NULL
AND SCGB_UTI_SOSTITUZIONI_DT IS NULL
AND SCGB_UTI_TOT IS NULL
AND SCSB_ACC_CASSA IS NULL
AND SCSB_ACC_CASSA_BT IS NULL
AND SCSB_ACC_CASSA_MLT IS NULL
AND SCSB_ACC_FIRMA IS NULL
AND SCSB_ACC_FIRMA_DT IS NULL
AND SCSB_ACC_MASSIMALI IS NULL
AND SCSB_ACC_MASSIMALI_DT IS NULL
AND SCSB_ACC_RISCHI_INDIRETTI IS NULL
AND SCSB_ACC_RISCHI_INDIRETTI_DT IS NULL
AND SCSB_ACC_SMOBILIZZO IS NULL
AND SCSB_ACC_SOSTITUZIONI IS NULL
AND SCSB_ACC_SOSTITUZIONI_DT IS NULL
AND SCSB_ACC_TOT IS NULL
AND SCSB_UTI_CASSA IS NULL
AND SCSB_UTI_CASSA_BT IS NULL
AND SCSB_UTI_CASSA_MLT IS NULL
AND SCSB_UTI_FIRMA IS NULL
AND SCSB_UTI_FIRMA_DT IS NULL
AND SCSB_UTI_MASSIMALI IS NULL
AND SCSB_UTI_MASSIMALI_DT IS NULL
AND SCSB_UTI_RISCHI_INDIRETTI IS NULL
AND SCSB_UTI_RISCHI_INDIRETTI_DT IS NULL
AND SCSB_UTI_SMOBILIZZO IS NULL
AND SCSB_UTI_SOSTITUZIONI IS NULL
AND SCSB_UTI_SOSTITUZIONI_DT IS NULL
AND SCSB_UTI_TOT IS NULL);

commit;
PKG_MCRE0_AUDIT.LOG_ETL(V_COD_LOG,'PKG_MCRE0_PCR3.FNC_LOAD_PCR_WRK',PKG_MCRE0_AUDIT.C_DEBUG,SQLCODE,SQLERRM,'WRK - GTT insert completed');

insert into mcre_own.GTT_PCR_MAU
SELECT g.COD_GRUPPO_ECONOMICO, --count(distinct gb_val_mau),
min(case when COD_GRUPPO_ECONOMICO=(SELECT  ge.cod_gruppo_economico FROM mcre_own.t_mcre0_app_gruppo_economico24 ge WHERE g.cod_sndg = ge.cod_sndg(+) ) then gb_val_mau else null end) GB_VAL_MAU,
min(case when COD_GRUPPO_ECONOMICO=(SELECT  ge.cod_gruppo_economico FROM mcre_own.t_mcre0_app_gruppo_economico24 ge WHERE g.cod_sndg = ge.cod_sndg(+) ) then GEGB_MAU else null end) GEGB_MAU,
min(case when COD_GRUPPO_ECONOMICO=(SELECT  ge.cod_gruppo_economico FROM mcre_own.t_mcre0_app_gruppo_economico24 ge WHERE g.cod_sndg = ge.cod_sndg(+) ) then GEGB_UTI_FIRMA else null end) GEGB_UTI_FIRMA,
min(case when COD_GRUPPO_ECONOMICO=(SELECT  ge.cod_gruppo_economico FROM mcre_own.t_mcre0_app_gruppo_economico24 ge WHERE g.cod_sndg = ge.cod_sndg(+) ) then GEGB_UTI_CASSA else null end) GEGB_UTI_CASSA,
min(case when COD_GRUPPO_ECONOMICO=(SELECT  ge.cod_gruppo_economico FROM mcre_own.t_mcre0_app_gruppo_economico24 ge WHERE g.cod_sndg = ge.cod_sndg(+) ) then GEGB_ACC_FIRMA else null end) GEGB_ACC_FIRMA,
min(case when COD_GRUPPO_ECONOMICO=(SELECT  ge.cod_gruppo_economico FROM mcre_own.t_mcre0_app_gruppo_economico24 ge WHERE g.cod_sndg = ge.cod_sndg(+) ) then GEGB_ACC_CASSA else null end) GEGB_ACC_CASSA
FROM GTT_PCR_WRK g where g.COD_GRUPPO_ECONOMICO is not null
GROUP BY G.COD_GRUPPO_ECONOMICO
HAVING COUNT(DISTINCT GB_VAL_MAU)>1;
commit;
PKG_MCRE0_AUDIT.LOG_ETL(V_COD_LOG,'PKG_MCRE0_PCR3.FNC_LOAD_PCR_WRK',PKG_MCRE0_AUDIT.C_DEBUG,SQLCODE,SQLERRM,'WRK - MAU insert completed');

insert into mcre_own.T_MCRE0_APP_PCR_WRK
select TODAY_FLG, COD_ABI_ISTITUTO, COD_ABI_CARTOLARIZZATO, COD_NDG, COD_SNDG, SCSB_ACC_CASSA, SCSB_ACC_CASSA_BT, SCSB_ACC_CASSA_MLT, SCSB_ACC_FIRMA, SCSB_ACC_FIRMA_DT, SCSB_ACC_SMOBILIZZO, SCSB_ACC_TOT, SCSB_DTA_RIFERIMENTO, SCSB_TOT_GAR, SCSB_UTI_CASSA, SCSB_UTI_CASSA_BT, SCSB_UTI_CASSA_MLT, SCSB_UTI_FIRMA, SCSB_UTI_FIRMA_DT, SCSB_UTI_SMOBILIZZO, SCSB_UTI_TOT, GESB_ACC_CASSA, GESB_ACC_CASSA_BT, GESB_ACC_CASSA_MLT, GESB_ACC_FIRMA, GESB_ACC_FIRMA_DT, GESB_ACC_SMOBILIZZO, GESB_DTA_RIFERIMENTO, GESB_TOT_GAR, GESB_UTI_CASSA, GESB_UTI_CASSA_BT, GESB_UTI_CASSA_MLT, GESB_UTI_FIRMA, GESB_UTI_FIRMA_DT, GESB_UTI_SMOBILIZZO, SCGB_ACC_CASSA, SCGB_ACC_CASSA_BT, SCGB_ACC_CASSA_MLT, SCGB_ACC_FIRMA, SCGB_ACC_FIRMA_DT, SCGB_ACC_SMOBILIZZO, SCGB_TOT_GAR, SCGB_UTI_CASSA, SCGB_UTI_CASSA_BT, SCGB_UTI_CASSA_MLT, SCGB_UTI_FIRMA, SCGB_UTI_FIRMA_DT, SCGB_UTI_SMOBILIZZO,
nvl(m.GEGB_ACC_CASSA,w.GEGB_ACC_CASSA) GEGB_ACC_CASSA, GEGB_ACC_CASSA_BT, GEGB_ACC_CASSA_MLT,
nvl(m.GEGB_ACC_FIRMA,w.GEGB_ACC_FIRMA) GEGB_ACC_FIRMA, GEGB_ACC_FIRMA_DT, GEGB_ACC_SMOBILIZZO, GEGB_TOT_GAR,
nvl(m.GEGB_UTI_CASSA,w.GEGB_UTI_CASSA) GEGB_UTI_CASSA, GEGB_UTI_CASSA_BT, GEGB_UTI_CASSA_MLT,
nvl(m.GEGB_UTI_FIRMA,w.GEGB_UTI_FIRMA) GEGB_UTI_FIRMA, GEGB_UTI_FIRMA_DT, GEGB_UTI_SMOBILIZZO, GLGB_ACC_CASSA, GLGB_ACC_CASSA_BT, GLGB_ACC_CASSA_MLT, GLGB_ACC_FIRMA, GLGB_ACC_FIRMA_DT, GLGB_ACC_SMOBILIZZO, GLGB_TOT_GAR, GLGB_UTI_CASSA, GLGB_UTI_CASSA_BT, GLGB_UTI_CASSA_MLT, GLGB_UTI_FIRMA, GLGB_UTI_FIRMA_DT, GLGB_UTI_SMOBILIZZO,
nvl(m.GB_VAL_MAU,w.GB_VAL_MAU) GB_VAL_MAU,
DTA_INS, GESB_ACC_TOT, GESB_UTI_TOT,
nvl(m.GEGB_MAU,w.GEGB_MAU) GEGB_MAU,
GLGB_MAU, SCGB_MAU, ID_DPER_SCSB, ID_DPER_GESB, ID_DPER_GB, DTA_UPD, SCSB_UTI_SOSTITUZIONI, SCSB_UTI_MASSIMALI, SCSB_UTI_RISCHI_INDIRETTI, SCSB_UTI_SOSTITUZIONI_DT, SCSB_UTI_MASSIMALI_DT, SCSB_UTI_RISCHI_INDIRETTI_DT, SCSB_ACC_SOSTITUZIONI, SCSB_ACC_SOSTITUZIONI_DT, SCSB_ACC_MASSIMALI, SCSB_ACC_MASSIMALI_DT, SCSB_ACC_RISCHI_INDIRETTI, SCSB_ACC_RISCHI_INDIRETTI_DT, GESB_UTI_MASSIMALI, GESB_UTI_RISCHI_INDIRETTI, GESB_UTI_SOSTITUZIONI_DT, GESB_UTI_MASSIMALI_DT, GESB_UTI_RISCHI_INDIRETTI_DT, GESB_ACC_SOSTITUZIONI, GESB_ACC_SOSTITUZIONI_DT, GESB_ACC_MASSIMALI, GESB_ACC_MASSIMALI_DT, GESB_ACC_RISCHI_INDIRETTI, GESB_ACC_RISCHI_INDIRETTI_DT, SCGB_UTI_MASSIMALI, SCGB_UTI_RISCHI_INDIRETTI, SCGB_UTI_SOSTITUZIONI_DT, SCGB_UTI_MASSIMALI_DT, SCGB_UTI_RISCHI_INDIRETTI_DT, SCGB_ACC_SOSTITUZIONI, SCGB_ACC_SOSTITUZIONI_DT, SCGB_ACC_MASSIMALI, SCGB_ACC_MASSIMALI_DT, SCGB_ACC_RISCHI_INDIRETTI, SCGB_ACC_RISCHI_INDIRETTI_DT, GLGB_UTI_MASSIMALI, GLGB_UTI_RISCHI_INDIRETTI, GLGB_UTI_SOSTITUZIONI_DT, GLGB_UTI_MASSIMALI_DT, GLGB_UTI_RISCHI_INDIRETTI_DT, GLGB_ACC_SOSTITUZIONI, GLGB_ACC_SOSTITUZIONI_DT, GLGB_ACC_MASSIMALI, GLGB_ACC_MASSIMALI_DT, GLGB_ACC_RISCHI_INDIRETTI, GLGB_ACC_RISCHI_INDIRETTI_DT, GESB_UTI_SOSTITUZIONI, SCGB_UTI_SOSTITUZIONI, GEGB_UTI_SOSTITUZIONI, GLGB_UTI_SOSTITUZIONI, GEGB_UTI_MASSIMALI, GEGB_UTI_RISCHI_INDIRETTI, GEGB_UTI_MASSIMALI_DT, GEGB_UTI_SOSTITUZIONI_DT, GEGB_UTI_RISCHI_INDIRETTI_DT, GEGB_ACC_SOSTITUZIONI, GEGB_ACC_SOSTITUZIONI_DT, GEGB_ACC_MASSIMALI, GEGB_ACC_MASSIMALI_DT, GEGB_ACC_RISCHI_INDIRETTI, GEGB_ACC_RISCHI_INDIRETTI_DT, SCGB_UTI_TOT, SCGB_ACC_TOT,
nvl(m.gegb_uti_cassa,w.gegb_uti_cassa) + nvl(m.gegb_uti_firma,w.gegb_uti_firma) GEGB_UTI_TOT,
nvl(m.gegb_acc_cassa,w.gegb_acc_cassa) + nvl(m.gegb_acc_firma,w.gegb_acc_firma) GEGB_ACC_TOT,
GLGB_UTI_TOT, GLGB_ACC_TOT, GB_DTA_RIFERIMENTO, SCSB_UTI_CONSEGNE, SCSB_ACC_CONSEGNE, SCGB_UTI_CONSEGNE, SCGB_ACC_CONSEGNE, GESB_UTI_CONSEGNE, GESB_ACC_CONSEGNE, GEGB_UTI_CONSEGNE, GEGB_ACC_CONSEGNE, GLGB_UTI_CONSEGNE, GLGB_ACC_CONSEGNE, SCSB_UTI_CONSEGNE_DT, SCSB_ACC_CONSEGNE_DT, SCGB_UTI_CONSEGNE_DT, SCGB_ACC_CONSEGNE_DT, GESB_UTI_CONSEGNE_DT, GESB_ACC_CONSEGNE_DT, GEGB_UTI_CONSEGNE_DT, GEGB_ACC_CONSEGNE_DT, GLGB_UTI_CONSEGNE_DT, GLGB_ACC_CONSEGNE_DT
from  mcre_own.GTT_PCR_WRK w, mcre_own.GTT_PCR_MAU m
where w.cod_gruppo_economico=m.cod_gruppo_economico(+);

commit;
PKG_MCRE0_AUDIT.LOG_ETL(V_COD_LOG,'PKG_MCRE0_PCR3.FNC_LOAD_PCR_WRK',PKG_MCRE0_AUDIT.C_DEBUG,SQLCODE,SQLERRM,'WRK - insert completed');

return ok;

EXCEPTION
WHEN OTHERS THEN
PKG_MCRE0_AUDIT.LOG_ETL(V_COD_LOG,'PKG_MCRE0_PCR3.FNC_LOAD_PCR_WRK',PKG_MCRE0_AUDIT.C_ERROR,SQLCODE,SQLERRM,'WRK - SQLERRM='||SQLERRM);
return ko;
end;



FUNCTION fnc_swap_pcr_wrk (
P_COD_LOG T_MCRE0_WRK_AUDIT_ETL.ID%TYPE DEFAULT NULL )
RETURN NUMBER IS

V_COD_LOG T_MCRE0_WRK_AUDIT_ETL.ID%TYPE;

begin

IF( P_COD_LOG IS NULL) THEN
SELECT SEQ_MCR0_LOG_ETL.NEXTVAL
INTO V_COD_LOG
FROM DUAL;
ELSE
V_COD_LOG := P_COD_LOG;
end if;


execute immediate 'rename T_MCRE0_APP_PCR24 to T_MCRE0_APP_PCR_TMP';
PKG_MCRE0_AUDIT.LOG_ETL(V_COD_LOG,'PKG_MCRE0_PCR3.FNC_SWAP_PCR_WRK',PKG_MCRE0_AUDIT.C_DEBUG,SQLCODE,SQLERRM,'WRK - renamed table name PCR to TMP');

execute immediate 'rename T_MCRE0_APP_PCR_WRK to T_MCRE0_APP_PCR24';
PKG_MCRE0_AUDIT.LOG_ETL(V_COD_LOG,'PKG_MCRE0_PCR3.FNC_SWAP_PCR_WRK',PKG_MCRE0_AUDIT.C_DEBUG,SQLCODE,SQLERRM,'WRK - renamed table name WRK to PCR');

execute immediate 'rename T_MCRE0_APP_PCR_TMP to T_MCRE0_APP_PCR_WRK';
PKG_MCRE0_AUDIT.LOG_ETL(V_COD_LOG,'PKG_MCRE0_PCR3.FNC_SWAP_PCR_WRK',PKG_MCRE0_AUDIT.C_DEBUG,SQLCODE,SQLERRM,'WRK - renamed table name TMP to WRK');

PKG_MCRE0_AUDIT.LOG_ETL(V_COD_LOG,'PKG_MCRE0_PCR3.FNC_SWAP_PCR_WRK',PKG_MCRE0_AUDIT.C_DEBUG,SQLCODE,SQLERRM,'WRK - table name swap completed');


execute immediate 'alter table T_MCRE0_APP_PCR_WRK drop constraint PKT_MCRE0_APP_PCR';
PKG_MCRE0_AUDIT.LOG_ETL(V_COD_LOG,'PKG_MCRE0_PCR3.FNC_SWAP_PCR_WRK',PKG_MCRE0_AUDIT.C_DEBUG,SQLCODE,SQLERRM,'WRK - PK constraint dropped');

execute immediate 'drop index PKT_MCRE0_APP_PCR';
PKG_MCRE0_AUDIT.LOG_ETL(V_COD_LOG,'PKG_MCRE0_PCR3.FNC_SWAP_PCR_WRK',PKG_MCRE0_AUDIT.C_DEBUG,SQLCODE,SQLERRM,'WRK - PK index dropped');

execute immediate 'CREATE UNIQUE INDEX PKT_MCRE0_APP_PCR ON T_MCRE0_APP_PCR24 (COD_ABI_CARTOLARIZZATO,COD_NDG,TODAY_FLG) TABLESPACE TSI_MCRE_OWN NOLOGGING LOCAL NOPARALLEL';
PKG_MCRE0_AUDIT.LOG_ETL(V_COD_LOG,'PKG_MCRE0_PCR3.FNC_SWAP_PCR_WRK',PKG_MCRE0_AUDIT.C_DEBUG,SQLCODE,SQLERRM,'WRK - PK index created');

execute immediate 'ALTER TABLE T_MCRE0_APP_PCR24 ADD ( CONSTRAINT PKT_MCRE0_APP_PCR PRIMARY KEY (COD_ABI_CARTOLARIZZATO, COD_NDG, TODAY_FLG) USING INDEX LOCAL)';
PKG_MCRE0_AUDIT.LOG_ETL(V_COD_LOG,'PKG_MCRE0_PCR3.FNC_SWAP_PCR_WRK',PKG_MCRE0_AUDIT.C_DEBUG,SQLCODE,SQLERRM,'WRK - PK constraint created');



commit;
PKG_MCRE0_AUDIT.LOG_ETL(V_COD_LOG,'PKG_MCRE0_PCR3.FNC_SWAP_PCR_WRK',PKG_MCRE0_AUDIT.C_DEBUG,SQLCODE,SQLERRM,'WRK - insert completed');
return ok;

EXCEPTION
WHEN OTHERS THEN
PKG_MCRE0_AUDIT.LOG_ETL(V_COD_LOG,'PKG_MCRE0_PCR3.FNC_SWAP_PCR_WRK',PKG_MCRE0_AUDIT.C_ERROR,SQLCODE,SQLERRM,'SWAP - SQLERRM='||SQLERRM);
return ko;
end;

END PKG_MCRE0_PCR3;
/


CREATE SYNONYM MCRE_APP.PKG_MCRE0_PCR3 FOR MCRE_OWN.PKG_MCRE0_PCR3;


CREATE SYNONYM MCRE_USR.PKG_MCRE0_PCR3 FOR MCRE_OWN.PKG_MCRE0_PCR3;


GRANT EXECUTE, DEBUG ON MCRE_OWN.PKG_MCRE0_PCR3 TO MCRE_USR;

