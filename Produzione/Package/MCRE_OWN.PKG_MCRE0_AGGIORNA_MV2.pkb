CREATE OR REPLACE PACKAGE BODY MCRE_OWN."PKG_MCRE0_AGGIORNA_MV2" AS
FUNCTION aggiorna_AnaGenETL(
P_COD_LOG T_MCRE0_WRK_AUDIT_ETL.ID%TYPE DEFAULT NULL
) RETURN NUMBER IS
V_COD_LOG T_MCRE0_WRK_AUDIT_ETL.ID%TYPE;
begin
IF( P_COD_LOG IS NULL) THEN
SELECT SEQ_MCR0_LOG_ETL.NEXTVAL
INTO V_COD_LOG
from dual;
ELSE
V_COD_LOG := P_COD_LOG;
end if;
PKG_MCRE0_AUDIT.LOG_ETL(V_COD_LOG,c_package||'.aggiorna_AnaGen',PKG_MCRE0_AUDIT.C_DEBUG,SQLCODE,SQLERRM,'START');
DBMS_MVIEW.REFRESH(
LIST => 'MCRE_OWN.MV_MCRE0_ANAGRAFICA_GENERALE'
,METHOD => 'C'
,PURGE_OPTION => 1
,PARALLELISM => 4
,ATOMIC_REFRESH => FALSE
,NESTED => FALSE);
PKG_MCRE0_AUDIT.LOG_ETL(V_COD_LOG,c_package||'.aggiorna_AnaGen',PKG_MCRE0_AUDIT.C_DEBUG,SQLCODE,SQLERRM,'END');
return ok;
EXCEPTION WHEN OTHERS THEN
PKG_MCRE0_AUDIT.LOG_ETL(V_COD_LOG,c_package||'.aggiorna_AnaGen',PKG_MCRE0_AUDIT.C_ERROR,SQLCODE,SQLERRM,'Refresh');
return ko;
end;
--4.1 rimane per la shell delle 23: chiama anche le Restore Guida e Mople
FUNCTION aggiorna_AnaGen(
P_COD_LOG T_MCRE0_WRK_AUDIT_ETL.ID%TYPE DEFAULT NULL
) RETURN NUMBER IS
V_COD_LOG T_MCRE0_WRK_AUDIT_ETL.ID%TYPE;
RetVal number :=0;
esito number := ok;
begin
IF( P_COD_LOG IS NULL) THEN
SELECT SEQ_MCR0_LOG_ETL.NEXTVAL
INTO V_COD_LOG
from dual;
ELSE
V_COD_LOG := P_COD_LOG;
end if;
--chiamo AnaGen originale
RetVal := MCRE_OWN.PKG_MCRE0_AGGIORNA_MV2.aggiorna_AnaGenETL(V_COD_LOG);
--restore Mople
RetVal := MCRE_OWN.PKG_MCRE0_GESTIONE_ALL_DATA.ETL_RESTORE_MOPLE(V_COD_LOG);
IF RetVal = KO THEN
PKG_MCRE0_AUDIT.log_etl (V_COD_LOG,'PKG_MCRE0_GESTIONE_ALL_DATA.ETL_RESTORE_MOPLE', PKG_MCRE0_AUDIT.C_ERROR, sqlcode, 'Esito '||RetVal, 'Restore Mople Terminato con errore ');
esito := ko;
--andrebbe bloccato l'intero caricamento notturno.. 1o livello
END IF;
PKG_MCRE0_AUDIT.log_etl (V_COD_LOG,'PKG_MCRE0_GESTIONE_ALL_DATA.ETL_RESTORE_MOPLE', PKG_MCRE0_AUDIT.C_DEBUG, sqlcode, 'Esito '||RetVal, 'eseguito Restore Mople');
RetVal := MCRE_OWN.PKG_MCRE0_GESTIONE_ALL_DATA.ETL_RESTORE_FILE_GUIDA(V_COD_LOG);
IF RetVal = KO THEN
PKG_MCRE0_AUDIT.log_etl (V_COD_LOG,'PKG_MCRE0_GESTIONE_ALL_DATA.ETL_RESTORE_FILE_GUIDA', PKG_MCRE0_AUDIT.C_ERROR, sqlcode, 'Esito '||RetVal, 'Restore FGuida Terminato con errore ');
esito := ko;
--andrebbe bloccato l'intero caricamento notturno.. 1o livello
END IF;
PKG_MCRE0_AUDIT.log_etl (V_COD_LOG,'PKG_MCRE0_GESTIONE_ALL_DATA.ETL_RESTORE_FILE_GUIDA', PKG_MCRE0_AUDIT.C_DEBUG, sqlcode, 'Esito '||RetVal, 'eseguito FGuida Mople');
if esito = ok then
return ok;
--andrebbe bloccato l'intero caricamento notturno.. 1o livello
else
return ko;
end if;
EXCEPTION WHEN OTHERS THEN
PKG_MCRE0_AUDIT.LOG_ETL(V_COD_LOG,c_package||'.aggiorna_AnaGen',PKG_MCRE0_AUDIT.C_ERROR,SQLCODE,SQLERRM,'Errore!!!');
return ko;
end;
--aggiorna la MV_MCRE0_APP_PCR_GB_AGGR
FUNCTION aggiorna_PCR_GB(
P_COD_LOG T_MCRE0_WRK_AUDIT_ETL.ID%TYPE DEFAULT NULL
) RETURN NUMBER IS
V_COD_LOG T_MCRE0_WRK_AUDIT_ETL.ID%TYPE;
begin
IF( P_COD_LOG IS NULL) THEN
SELECT SEQ_MCR0_LOG_ETL.NEXTVAL
INTO V_COD_LOG
from dual;
ELSE
V_COD_LOG := P_COD_LOG;
end if;
PKG_MCRE0_AUDIT.LOG_ETL(V_COD_LOG,c_package||'.aggiorna_PCR_GB',PKG_MCRE0_AUDIT.C_DEBUG,SQLCODE,SQLERRM,'START');
DBMS_MVIEW.REFRESH(
LIST => 'MCRE_OWN.MV_MCRE0_APP_PCR_GB_AGGR'
,METHOD => 'C'
,PURGE_OPTION => 1
,PARALLELISM => 4
--,ATOMIC_REFRESH => TRUE
,NESTED => FALSE);
PKG_MCRE0_AUDIT.LOG_ETL(V_COD_LOG,c_package||'.aggiorna_PCR_GB',PKG_MCRE0_AUDIT.C_DEBUG,SQLCODE,SQLERRM,'END');
return ok;
EXCEPTION WHEN OTHERS THEN
PKG_MCRE0_AUDIT.LOG_ETL(V_COD_LOG,c_package||'.aggiorna_PCR_GB',PKG_MCRE0_AUDIT.C_ERROR,SQLCODE,SQLERRM,'Refresh');
return ko;
end;
--aggiorna la MV_MCRE0_APP_PCR_GE_SB_AGGR
FUNCTION aggiorna_PCR_GE(
P_COD_LOG T_MCRE0_WRK_AUDIT_ETL.ID%TYPE DEFAULT NULL
) RETURN NUMBER IS
V_COD_LOG T_MCRE0_WRK_AUDIT_ETL.ID%TYPE;
begin
IF( P_COD_LOG IS NULL) THEN
SELECT SEQ_MCR0_LOG_ETL.NEXTVAL
INTO V_COD_LOG
from dual;
ELSE
V_COD_LOG := P_COD_LOG;
end if;
PKG_MCRE0_AUDIT.LOG_ETL(V_COD_LOG,c_package||'.aggiorna_PCR_GE',PKG_MCRE0_AUDIT.C_DEBUG,SQLCODE,SQLERRM,'START');
DBMS_MVIEW.REFRESH(
LIST => 'MCRE_OWN.MV_MCRE0_APP_PCR_GE_SB_AGGR'
,METHOD => 'C'
,PURGE_OPTION => 1
,PARALLELISM => 4
--,ATOMIC_REFRESH => TRUE
,NESTED => FALSE);
PKG_MCRE0_AUDIT.LOG_ETL(V_COD_LOG,c_package||'.aggiorna_PCR_GE',PKG_MCRE0_AUDIT.C_DEBUG,SQLCODE,SQLERRM,'END');
return ok;
exception when others then
PKG_MCRE0_AUDIT.LOG_ETL(V_COD_LOG,c_package||'.aggiorna_PCR_GE',PKG_MCRE0_AUDIT.C_ERROR,SQLCODE,SQLERRM,'Refresh');
return ko;
end;
--aggiorna la MV_MCRE0_APP_PCR_SC_SB_AGGR
FUNCTION aggiorna_PCR_SC(
P_COD_LOG T_MCRE0_WRK_AUDIT_ETL.ID%TYPE DEFAULT NULL
) RETURN NUMBER IS
V_COD_LOG T_MCRE0_WRK_AUDIT_ETL.ID%TYPE;
begin
IF( P_COD_LOG IS NULL) THEN
SELECT SEQ_MCR0_LOG_ETL.NEXTVAL
INTO V_COD_LOG
from dual;
ELSE
V_COD_LOG := P_COD_LOG;
end if;
PKG_MCRE0_AUDIT.LOG_ETL(V_COD_LOG,c_package||'.aggiorna_PCR_SC',PKG_MCRE0_AUDIT.C_DEBUG,SQLCODE,SQLERRM,'START');
DBMS_MVIEW.REFRESH(
LIST => 'MCRE_OWN.MV_MCRE0_APP_PCR_SC_SB_AGGR'
,METHOD => 'C'
,PURGE_OPTION => 1
,PARALLELISM => 4
--,ATOMIC_REFRESH => TRUE
,NESTED => FALSE);
PKG_MCRE0_AUDIT.LOG_ETL(V_COD_LOG,c_package||'.aggiorna_PCR_SC',PKG_MCRE0_AUDIT.C_DEBUG,SQLCODE,SQLERRM,'END');
return ok;
exception when others then
PKG_MCRE0_AUDIT.LOG_ETL(V_COD_LOG,c_package||'.aggiorna_PCR_SC',PKG_MCRE0_AUDIT.C_ERROR,SQLCODE,SQLERRM,'Refresh');
return ko;
end;
--aggiorna la V_MCRE0_APP_ELENCO_POS
FUNCTION aggiorna_ELENCO_POS(
P_COD_LOG T_MCRE0_WRK_AUDIT_ETL.ID%TYPE DEFAULT NULL
) RETURN NUMBER IS
V_COD_LOG T_MCRE0_WRK_AUDIT_ETL.ID%TYPE;
begin
IF( P_COD_LOG IS NULL) THEN
SELECT SEQ_MCR0_LOG_ETL.NEXTVAL
INTO V_COD_LOG
from dual;
ELSE
V_COD_LOG := P_COD_LOG;
end if;
PKG_MCRE0_AUDIT.LOG_ETL(V_COD_LOG,c_package||'.aggiorna_ELENCO_POS',PKG_MCRE0_AUDIT.C_DEBUG,SQLCODE,SQLERRM,'START');
DBMS_MVIEW.REFRESH(
LIST => 'MCRE_OWN.V_MCRE0_APP_ELENCO_POS'
,METHOD => 'C'
,PURGE_OPTION => 1
,PARALLELISM => 4
--,ATOMIC_REFRESH => TRUE
,NESTED => FALSE);
PKG_MCRE0_AUDIT.LOG_ETL(V_COD_LOG,c_package||'.aggiorna_ELENCO_POS',PKG_MCRE0_AUDIT.C_DEBUG,SQLCODE,SQLERRM,'END');
return ok;
exception when others then
PKG_MCRE0_AUDIT.LOG_ETL(V_COD_LOG,c_package||'.aggiorna_ELENCO_POS',PKG_MCRE0_AUDIT.C_ERROR,SQLCODE,SQLERRM,'Refresh');
return ko;
end;
--aggiorna la V_MCRE0_APP_HP_EXCEL
FUNCTION aggiorna_HP_EXCEL(
P_COD_LOG T_MCRE0_WRK_AUDIT_ETL.ID%TYPE DEFAULT NULL
) RETURN NUMBER IS
V_COD_LOG T_MCRE0_WRK_AUDIT_ETL.ID%TYPE;
begin
IF( P_COD_LOG IS NULL) THEN
SELECT SEQ_MCR0_LOG_ETL.NEXTVAL
INTO V_COD_LOG
from dual;
ELSE
V_COD_LOG := P_COD_LOG;
end if;
PKG_MCRE0_AUDIT.LOG_ETL(V_COD_LOG,c_package||'.aggiorna_HP_EXCEL',PKG_MCRE0_AUDIT.C_DEBUG,SQLCODE,SQLERRM,'START');
DBMS_MVIEW.REFRESH(
LIST => 'MCRE_OWN.V_MCRE0_APP_HP_EXCEL'
,METHOD => 'C'
,PURGE_OPTION => 1
,PARALLELISM => 4
--,ATOMIC_REFRESH => TRUE
,NESTED => FALSE);
PKG_MCRE0_AUDIT.LOG_ETL(V_COD_LOG,c_package||'.aggiorna_HP_EXCEL',PKG_MCRE0_AUDIT.C_DEBUG,SQLCODE,SQLERRM,'END');
return ok;
exception when others then
PKG_MCRE0_AUDIT.LOG_ETL(V_COD_LOG,c_package||'.aggiorna_HP_EXCEL',PKG_MCRE0_AUDIT.C_ERROR,SQLCODE,SQLERRM,'Refresh');
return ko;
end;
--aggiorna la MV_MCRE0_APP_ISTITUTI
FUNCTION aggiorna_ISTITUTI(
P_COD_LOG T_MCRE0_WRK_AUDIT_ETL.ID%TYPE DEFAULT NULL
) RETURN NUMBER IS
V_COD_LOG T_MCRE0_WRK_AUDIT_ETL.ID%TYPE;
begin
IF( P_COD_LOG IS NULL) THEN
SELECT SEQ_MCR0_LOG_ETL.NEXTVAL
INTO V_COD_LOG
from dual;
ELSE
V_COD_LOG := P_COD_LOG;
end if;
PKG_MCRE0_AUDIT.LOG_ETL(V_COD_LOG,c_package||'.aggiorna_ISTITUTI',PKG_MCRE0_AUDIT.C_DEBUG,SQLCODE,SQLERRM,'START');
Dbms_Mview.Refresh(
LIST => 'MCRE_OWN.MV_MCRE0_APP_ISTITUTI'
,METHOD => 'C'
,PURGE_OPTION => 1
,PARALLELISM => 4
--,ATOMIC_REFRESH => TRUE
,NESTED => FALSE);
PKG_MCRE0_AUDIT.LOG_ETL(V_COD_LOG,c_package||'.aggiorna_ISTITUTI',PKG_MCRE0_AUDIT.C_DEBUG,SQLCODE,SQLERRM,'END');
return ok;
exception when others then
PKG_MCRE0_AUDIT.LOG_ETL(V_COD_LOG,c_package||'.aggiorna_ISTITUTI',PKG_MCRE0_AUDIT.C_ERROR,SQLCODE,SQLERRM,'Refresh');
return ko;
end;
--aggiorna la V_MCRE0_APP_POSIZIONI_STATO
FUNCTION aggiorna_POSIZIONI_STATO(
P_COD_LOG T_MCRE0_WRK_AUDIT_ETL.ID%TYPE DEFAULT NULL
) RETURN NUMBER IS
V_COD_LOG T_MCRE0_WRK_AUDIT_ETL.ID%TYPE;
begin
IF( P_COD_LOG IS NULL) THEN
SELECT SEQ_MCR0_LOG_ETL.NEXTVAL
INTO V_COD_LOG
from dual;
ELSE
V_COD_LOG := P_COD_LOG;
end if;
PKG_MCRE0_AUDIT.LOG_ETL(V_COD_LOG,c_package||'.aggiorna_POSIZIONI_STATO',PKG_MCRE0_AUDIT.C_DEBUG,SQLCODE,SQLERRM,'START');
DBMS_MVIEW.REFRESH(
LIST => 'MCRE_OWN.V_MCRE0_APP_POSIZIONI_STATO'
,METHOD => 'C'
,PURGE_OPTION => 1
,PARALLELISM => 4
--,ATOMIC_REFRESH => TRUE
,NESTED => FALSE);
PKG_MCRE0_AUDIT.LOG_ETL(V_COD_LOG,c_package||'.aggiorna_POSIZIONI_STATO',PKG_MCRE0_AUDIT.C_DEBUG,SQLCODE,SQLERRM,'END');
return ok;
exception when others then
PKG_MCRE0_AUDIT.LOG_ETL(V_COD_LOG,c_package||'.aggiorna_POSIZIONI_STATO',PKG_MCRE0_AUDIT.C_ERROR,SQLCODE,SQLERRM,'Refresh');
return ko;
end;
--aggiorna la V_MCRE0_APP_SCHEDA_ANAG_MOV
FUNCTION aggiorna_LAST_PERCORSO(
P_COD_LOG T_MCRE0_WRK_AUDIT_ETL.ID%TYPE DEFAULT NULL
) RETURN NUMBER IS
V_COD_LOG T_MCRE0_WRK_AUDIT_ETL.ID%TYPE;
begin
IF( P_COD_LOG IS NULL) THEN
SELECT SEQ_MCR0_LOG_ETL.NEXTVAL
INTO V_COD_LOG
from dual;
ELSE
V_COD_LOG := P_COD_LOG;
end if;
PKG_MCRE0_AUDIT.LOG_ETL(V_COD_LOG,c_package||'.aggiorna_LAST_PERCORSO',PKG_MCRE0_AUDIT.C_DEBUG,SQLCODE,SQLERRM,'START');
DBMS_MVIEW.REFRESH(
LIST => 'MCRE_OWN.MV_MCRE0_APP_LAST_PERCORSO'
,METHOD => 'C'
,PURGE_OPTION => 1
,PARALLELISM => 4
--,ATOMIC_REFRESH => TRUE
,NESTED => FALSE);
PKG_MCRE0_AUDIT.LOG_ETL(V_COD_LOG,c_package||'.aggiorna_LAST_PERCORSO',PKG_MCRE0_AUDIT.C_DEBUG,SQLCODE,SQLERRM,'END');
return ok;
EXCEPTION WHEN OTHERS THEN
PKG_MCRE0_AUDIT.LOG_ETL(V_COD_LOG,c_package||'.aggiorna_LAST_PERCORSO',PKG_MCRE0_AUDIT.C_ERROR,SQLCODE,SQLERRM,'Refresh');
return ko;
end;
--load delle tabelle MV_MCRE0_APP_PT_POS_USCITE_AUT e MV_MCRE0_APP_PT_POS_USCITE_MAN
FUNCTION aggiorna_USCITE(
P_COD_LOG T_MCRE0_WRK_AUDIT_ETL.ID%TYPE DEFAULT NULL
) RETURN NUMBER IS
V_COD_LOG T_MCRE0_WRK_AUDIT_ETL.ID%TYPE;
v_dta_start_q date;
v_dta_end_q date;
v_cambio_q number(1):=1;
begin
IF( P_COD_LOG IS NULL) THEN
SELECT SEQ_MCR0_LOG_ETL.NEXTVAL
INTO V_COD_LOG
from dual;
ELSE
V_COD_LOG := P_COD_LOG;
end if;
PKG_MCRE0_AUDIT.LOG_ETL(V_COD_LOG,c_package||'.aggiorna_USCITE',PKG_MCRE0_AUDIT.C_DEBUG,SQLCODE,SQLERRM,'START');
execute immediate 'alter session enable parallel dml';
--execute immediate 'truncate table mcre_own.mv_mcre0_app_pt_pos_uscite_man reuse storage';
--execute immediate 'truncate table mcre_own.mv_mcre0_app_pt_pos_uscite_aut reuse storage';
/*INSERT
   WHEN id_transizione = 'M'
   THEN
  INTO mcre_own.mv_mcre0_app_pt_pos_uscite_man
       (cod_abi_cartolarizzato, cod_abi_istituto, cod_ndg, cod_filiale,
        dta_uscita_pt, id_utente, id_referente, cod_comparto, cod_macrostato,
        cod_stato, scsb_uti_firma, scsb_uti_cassa, scsb_uti_tot, cod_q,
        cod_struttura_competente_dc, desc_struttura_competente_dc,
        cod_struttura_competente_dv, desc_struttura_competente_dv,
        cod_struttura_competente_ar, desc_struttura_competente_ar,
        cod_struttura_competente_fi, desc_struttura_competente_fi,
        cod_struttura_competente_rg, desc_struttura_competente_rg,
        num_pos_riportafogliati
       )
VALUES (cod_abi_cartolarizzato, cod_abi_istituto, cod_ndg, cod_filiale,
        dta_uscita_pt, id_utente, id_referente, cod_comparto, cod_macrostato,
        cod_stato, scsb_uti_firma, scsb_uti_cassa, scsb_uti_tot, cod_q,
        cod_struttura_competente_dc, desc_struttura_competente_dc,
        cod_struttura_competente_dv, desc_struttura_competente_dv,
        cod_struttura_competente_ar, desc_struttura_competente_ar,
        cod_struttura_competente_fi, desc_struttura_competente_fi,
        cod_struttura_competente_rg, desc_struttura_competente_rg,
        num_pos_riportafogliati
       )
   WHEN id_transizione = 'A'
   THEN
  INTO mcre_own.mv_mcre0_app_pt_pos_uscite_aut
       (cod_abi_cartolarizzato, cod_abi_istituto, cod_ndg, cod_filiale,
        dta_uscita_pt, id_utente, id_referente, cod_comparto, cod_macrostato,
        cod_stato, scsb_uti_firma, scsb_uti_cassa, scsb_uti_tot, cod_q,
        cod_struttura_competente_dc, desc_struttura_competente_dc,
        cod_struttura_competente_dv, desc_struttura_competente_dv,
        cod_struttura_competente_ar, desc_struttura_competente_ar,
        cod_struttura_competente_fi, desc_struttura_competente_fi,
        cod_struttura_competente_rg, desc_struttura_competente_rg,
        num_pos_riportafogliati
       )
VALUES (cod_abi_cartolarizzato, cod_abi_istituto, cod_ndg, cod_filiale,
        dta_uscita_pt, id_utente, id_referente, cod_comparto, cod_macrostato,
        cod_stato, scsb_uti_firma, scsb_uti_cassa, scsb_uti_tot, cod_q,
        cod_struttura_competente_dc, desc_struttura_competente_dc,
        cod_struttura_competente_dv, desc_struttura_competente_dv,
        cod_struttura_competente_ar, desc_struttura_competente_ar,
        cod_struttura_competente_fi, desc_struttura_competente_fi,
        cod_struttura_competente_rg, desc_struttura_competente_rg,
        num_pos_riportafogliati
       )
   SELECT DISTINCT e.cod_abi_cartolarizzato, e.cod_abi_istituto, e.cod_ndg,
                   e1.cod_filiale, e.dta_decorrenza_stato dta_uscita_pt,
                   e1.id_utente, e1.id_referente, e1.cod_comparto,
                   s.cod_macrostato, e.cod_stato, e1.scsb_uti_firma,
                   e1.scsb_uti_cassa, e1.scsb_uti_tot,
                   CASE
                      WHEN e.dta_decorrenza_stato >=
                                  (SELECT dta_start_q
                                     FROM mcre_own.v_mcre0_app_quarters
                                    WHERE cod_q = 5)
                      AND e.dta_decorrenza_stato <=
                                         (SELECT dta_end_q
                                            FROM mcre_own.v_mcre0_app_quarters
                                           WHERE cod_q = 5)
                         THEN 5
                      WHEN e.dta_decorrenza_stato >=
                                         (SELECT dta_start_q
                                            FROM mcre_own.v_mcre0_app_quarters
                                           WHERE cod_q = 4)
                      AND e.dta_decorrenza_stato <=
                                         (SELECT dta_end_q
                                            FROM mcre_own.v_mcre0_app_quarters
                                           WHERE cod_q = 4)
                         THEN 4
                      WHEN e.dta_decorrenza_stato >=
                                         (SELECT dta_start_q
                                            FROM mcre_own.v_mcre0_app_quarters
                                           WHERE cod_q = 3)
                      AND e.dta_decorrenza_stato <=
                                         (SELECT dta_end_q
                                            FROM mcre_own.v_mcre0_app_quarters
                                           WHERE cod_q = 3)
                         THEN 3
                      WHEN e.dta_decorrenza_stato >=
                                         (SELECT dta_start_q
                                            FROM mcre_own.v_mcre0_app_quarters
                                           WHERE cod_q = 2)
                      AND e.dta_decorrenza_stato <=
                                         (SELECT dta_end_q
                                            FROM mcre_own.v_mcre0_app_quarters
                                           WHERE cod_q = 2)
                         THEN 2
                      WHEN e.dta_decorrenza_stato >=
                                         (SELECT dta_start_q
                                            FROM mcre_own.v_mcre0_app_quarters
                                           WHERE cod_q = 1)
                      AND e.dta_decorrenza_stato <=
                                         (SELECT dta_end_q
                                            FROM mcre_own.v_mcre0_app_quarters
                                           WHERE cod_q = 1)
                         THEN 1
                      ELSE 0
                   END cod_q,
                   cod_struttura_competente_dc, desc_struttura_competente_dc,
                   cod_struttura_competente_dv, desc_struttura_competente_dv,
                   cod_struttura_competente_ar, desc_struttura_competente_ar,
                   cod_struttura_competente_fi, desc_struttura_competente_fi,
                   cod_struttura_competente_rg, desc_struttura_competente_rg,
                   0 num_pos_riportafogliati, e.id_transizione
              FROM t_mcre0_app_storico_eventi e,
                   (SELECT DISTINCT scsb_uti_firma, scsb_uti_cassa,
                                    scsb_uti_tot, id_utente, id_referente,
                                    NVL (cod_comparto_assegnato,
                                         cod_comparto_calcolato
                                        ) cod_comparto,
                                    cod_abi_istituto, cod_abi_cartolarizzato,
                                    cod_ndg, cod_filiale,
                                    TRUNC
                                       (e2.dta_fine_validita
                                       ) dta_fine_validita_t,
                                    dta_fine_validita,
                                    MAX
                                       (e2.dta_fine_validita
                                       ) OVER (PARTITION BY e2.cod_abi_cartolarizzato, e2.cod_ndg, TRUNC
                                                                                                     (e2.dta_fine_validita
                                                                                                     ))
                                                        dta_fine_validita_max
                               FROM t_mcre0_app_storico_eventi e2) e1,
                   t_mcre0_app_stati s,
                   mcre_own.mv_mcre0_denorm_str_org s
             WHERE e.cod_stato_precedente = 'PT'
               AND e1.cod_abi_istituto = s.cod_abi_istituto_fi(+)
               AND e1.cod_filiale = s.cod_struttura_competente_fi(+)
               AND e.cod_abi_cartolarizzato = e1.cod_abi_cartolarizzato
               AND e.cod_ndg = e1.cod_ndg
               AND e.dta_decorrenza_stato = e1.dta_fine_validita_t
               AND e1.dta_fine_validita_max = e1.dta_fine_validita
               AND e.cod_stato = s.cod_microstato(+)
               AND (   (    e.cod_stato IN ('BO', 'IN', 'XS', 'XC')
                        AND e.id_transizione = 'A'
                       )
                    OR (    s.cod_macrostato IN ('GA', 'RIO', 'IN', 'SO')
                        AND e.id_transizione = 'M'
                       )
                   );*/

-----VG: 20121217
begin
    select max(dta_start_q), max(dta_end_q)
    into v_dta_start_q, v_dta_end_q
    from mv_mcre0_app_pt_pos_uscite_aut
    where cod_q = 1;
exception
  when others then null;
end;

begin
    select distinct 1
    into v_cambio_q
    from v_mcre0_app_quarters
    where cod_q = 1
    and dta_start_q = v_dta_start_q
    and dta_end_q = v_dta_end_q;
exception
  when others then
    v_cambio_q := 0;
end;

if (v_cambio_q = 0) then

  begin
      delete from  mv_mcre0_app_pt_pos_uscite_man where cod_q = 1;
      delete from  mv_mcre0_app_pt_pos_uscite_aut where cod_q = 1;
      commit;

      update mv_mcre0_app_pt_pos_uscite_man a
      set cod_q = cod_q -1;
      commit;

      update mv_mcre0_app_pt_pos_uscite_aut a
      set cod_q = cod_q -1;
      commit;
   exception
        when others then
          PKG_MCRE0_AUDIT.LOG_ETL(V_COD_LOG,c_package||'.aggiorna_USCITE',PKG_MCRE0_AUDIT.C_ERROR,SQLCODE,SQLERRM,'Delete-Update');
          rollback;
          return ko;
   end;

---- VG: 20121121
INSERT
   WHEN id_transizione = 'M'
   THEN
  INTO mcre_own.mv_mcre0_app_pt_pos_uscite_man
       (cod_abi_cartolarizzato, cod_abi_istituto, cod_ndg, cod_filiale,
        dta_uscita_pt, id_utente, id_referente, cod_comparto, cod_macrostato,
        cod_stato, scsb_uti_firma, scsb_uti_cassa, scsb_uti_tot, cod_q,
        cod_struttura_competente_dc, desc_struttura_competente_dc,
        cod_struttura_competente_dv, desc_struttura_competente_dv,
        cod_struttura_competente_ar, desc_struttura_competente_ar,
        cod_struttura_competente_fi, desc_struttura_competente_fi,
        cod_struttura_competente_rg, desc_struttura_competente_rg,
        num_pos_riportafogliati, dta_start_q, dta_end_q, COD_LIVELLO
       )
VALUES (cod_abi_cartolarizzato, cod_abi_istituto, cod_ndg, cod_filiale,
        dta_uscita_pt, id_utente, id_referente, cod_comparto, cod_macrostato,
        cod_stato, scsb_uti_firma, scsb_uti_cassa, scsb_uti_tot, cod_q,
        cod_struttura_competente_dc, desc_struttura_competente_dc,
        cod_struttura_competente_dv, desc_struttura_competente_dv,
        cod_struttura_competente_ar, desc_struttura_competente_ar,
        cod_struttura_competente_fi, desc_struttura_competente_fi,
        cod_struttura_competente_rg, desc_struttura_competente_rg,
        num_pos_riportafogliati, dta_start_q, dta_end_q, COD_LIVELLO
       )
   WHEN id_transizione = 'A'
   THEN
  INTO mcre_own.mv_mcre0_app_pt_pos_uscite_aut
       (cod_abi_cartolarizzato, cod_abi_istituto, cod_ndg, cod_filiale,
        dta_uscita_pt, id_utente, id_referente, cod_comparto, cod_macrostato,
        cod_stato, scsb_uti_firma, scsb_uti_cassa, scsb_uti_tot, cod_q,
        cod_struttura_competente_dc, desc_struttura_competente_dc,
        cod_struttura_competente_dv, desc_struttura_competente_dv,
        cod_struttura_competente_ar, desc_struttura_competente_ar,
        cod_struttura_competente_fi, desc_struttura_competente_fi,
        cod_struttura_competente_rg, desc_struttura_competente_rg,
        num_pos_riportafogliati, dta_start_q, dta_end_q, COD_LIVELLO
       )
VALUES (cod_abi_cartolarizzato, cod_abi_istituto, cod_ndg, cod_filiale,
        dta_uscita_pt, id_utente, id_referente, cod_comparto, cod_macrostato,
        cod_stato, scsb_uti_firma, scsb_uti_cassa, scsb_uti_tot, cod_q,
        cod_struttura_competente_dc, desc_struttura_competente_dc,
        cod_struttura_competente_dv, desc_struttura_competente_dv,
        cod_struttura_competente_ar, desc_struttura_competente_ar,
        cod_struttura_competente_fi, desc_struttura_competente_fi,
       cod_struttura_competente_rg, desc_struttura_competente_rg,
        num_pos_riportafogliati, dta_start_q, dta_end_q, COD_LIVELLO
       )
   SELECT DISTINCT e.cod_abi_cartolarizzato, e.cod_abi_istituto, e.cod_ndg,
                   e1.cod_filiale, e.dta_decorrenza_stato dta_uscita_pt,
                   e1.id_utente, e1.id_referente, e1.cod_comparto,
                   E1.COD_LIVELLO,
                   s.cod_macrostato, e.cod_stato, e1.scsb_uti_firma,
                   e1.scsb_uti_cassa, e1.scsb_uti_tot,
                   CASE
                      WHEN e.dta_decorrenza_stato >=
                                         (SELECT dta_start_q
                                            FROM mcre_own.v_mcre0_app_quarters
                                           WHERE cod_q = 4)
                      AND e.dta_decorrenza_stato <=
                                         (SELECT dta_end_q
                                            FROM mcre_own.v_mcre0_app_quarters
                                           WHERE cod_q = 4)
                         THEN 4
                      WHEN e.dta_decorrenza_stato >=
                                         (SELECT dta_start_q
                                            FROM mcre_own.v_mcre0_app_quarters
                                           WHERE cod_q = 3)
                      AND e.dta_decorrenza_stato <=
                                         (SELECT dta_end_q
                                            FROM mcre_own.v_mcre0_app_quarters
                                           WHERE cod_q = 3)
                         THEN 3
                      WHEN e.dta_decorrenza_stato >=
                                         (SELECT dta_start_q
                                            FROM mcre_own.v_mcre0_app_quarters
                                           WHERE cod_q = 2)
                      AND e.dta_decorrenza_stato <=
                                         (SELECT dta_end_q
                                            FROM mcre_own.v_mcre0_app_quarters
                                           WHERE cod_q = 2)
                         THEN 2
                      WHEN e.dta_decorrenza_stato >=
                                         (SELECT dta_start_q
                                            FROM mcre_own.v_mcre0_app_quarters
                                           WHERE cod_q = 1)
                      AND e.dta_decorrenza_stato <=
                                         (SELECT dta_end_q
                                            FROM mcre_own.v_mcre0_app_quarters
                                           WHERE cod_q = 1)
                         THEN 1
                      ELSE 0
                   END cod_q,
                   cod_struttura_competente_dc, desc_struttura_competente_dc,
                   cod_struttura_competente_dv, desc_struttura_competente_dv,
                   cod_struttura_competente_ar, desc_struttura_competente_ar,
                   cod_struttura_competente_fi, desc_struttura_competente_fi,
                   cod_struttura_competente_rg, desc_struttura_competente_rg,
                   0 num_pos_riportafogliati, e.id_transizione,
                   (select dta_start_q
                    FROM mcre_own.v_mcre0_app_quarters
                    where e.dta_decorrenza_stato between dta_start_q and dta_end_q)dta_start_q,
                   (select dta_end_q
                    FROM mcre_own.v_mcre0_app_quarters
                    where e.dta_decorrenza_stato between dta_start_q and dta_end_q) dta_end_q
              FROM t_mcre0_app_storico_eventi e,
                   (SELECT DISTINCT scsb_uti_firma, scsb_uti_cassa,
                                    scsb_uti_tot, id_utente, id_referente,
                                    NVL (cod_comparto_assegnato,
                                         cod_comparto_calcolato
                                        ) cod_comparto,
                                     C.COD_LIVELLO,
                                    cod_abi_istituto, cod_abi_cartolarizzato,
                                    cod_ndg, cod_filiale,
                                   e2.dta_decorrenza_stato,
                                    dta_fine_validita,
                                    Min
                                       (e2.dta_fine_validita
                                       ) OVER (PARTITION BY e2.cod_abi_cartolarizzato, e2.cod_ndg, e2.cod_stato_precedente, e2.dta_decorrenza_stato)
                                                        dta_fine_validita_min
                               FROM t_mcre0_app_storico_eventi e2,
                                    T_MCRE0_APP_COMPARTI C
                               where cod_stato_precedente = 'PT'
                                 AND C.COD_COMPARTO =  NVL (cod_comparto_assegnato, cod_comparto_calcolato )
                                 ) e1,
                   t_mcre0_app_stati s,
                   mcre_own.mv_mcre0_denorm_str_org s
             WHERE e.cod_stato_precedente = 'PT'
               AND e1.cod_abi_istituto = s.cod_abi_istituto_fi(+)
               AND e1.cod_filiale = s.cod_struttura_competente_fi(+)
               AND e.cod_abi_cartolarizzato = e1.cod_abi_cartolarizzato
               AND e.cod_ndg = e1.cod_ndg
               AND e.dta_decorrenza_stato = e1.dta_decorrenza_stato
               AND e1.dta_fine_validita_min = e1.dta_fine_validita
               AND e.cod_stato = s.cod_microstato(+)
               AND (   (    e.cod_stato IN ('BO', 'IN', 'XS', 'XC')
                        AND e.id_transizione = 'A'
                       )
                    OR (    s.cod_macrostato IN ('GA', 'RIO', 'IN', 'SO')
                        AND e.id_transizione = 'M'
                       )
                   )
               and e.dta_decorrenza_stato >=
                                         (SELECT dta_start_q
                                            FROM mcre_own.v_mcre0_app_quarters
                                           WHERE cod_q = 4)
               and e.dta_decorrenza_stato <=
                                         (SELECT dta_end_q
                                            FROM mcre_own.v_mcre0_app_quarters
                                           WHERE cod_q = 4);
commit;

end if;

PKG_MCRE0_AUDIT.LOG_ETL(V_COD_LOG,c_package||'.aggiorna_USCITE',PKG_MCRE0_AUDIT.C_DEBUG,SQLCODE,SQLERRM,'END');
return ok;
exception when others then
PKG_MCRE0_AUDIT.LOG_ETL(V_COD_LOG,c_package||'.aggiorna_USCITE',PKG_MCRE0_AUDIT.C_ERROR,SQLCODE,SQLERRM,'Refresh');
return ko;
end;
--aggiorna la MV_MCRE0_APP_RIO_MONITORAGGIO
FUNCTION aggiorna_RIO_MONITORAGGIO(
P_COD_LOG T_MCRE0_WRK_AUDIT_ETL.ID%TYPE DEFAULT NULL
) RETURN NUMBER IS
V_COD_LOG T_MCRE0_WRK_AUDIT_ETL.ID%TYPE;
begin
IF( P_COD_LOG IS NULL) THEN
SELECT SEQ_MCR0_LOG_ETL.NEXTVAL
INTO V_COD_LOG
from dual;
ELSE
V_COD_LOG := P_COD_LOG;
end if;
PKG_MCRE0_AUDIT.LOG_ETL(V_COD_LOG,c_package||'.aggiorna_RIO_Monitoraggio',PKG_MCRE0_AUDIT.C_DEBUG,SQLCODE,SQLERRM,'START');
DBMS_MVIEW.REFRESH(
LIST => 'MCRE_OWN.MV_MCRE0_APP_RIO_MONITORAGGIO'
,METHOD => 'C'
,PURGE_OPTION => 1
,PARALLELISM => 4
,ATOMIC_REFRESH => FALSE --v4.3
,NESTED => FALSE);
PKG_MCRE0_AUDIT.LOG_ETL(V_COD_LOG,c_package||'.aggiorna_RIO_Monitoraggio',PKG_MCRE0_AUDIT.C_DEBUG,SQLCODE,SQLERRM,'END');
return ok;
exception when others then
PKG_MCRE0_AUDIT.LOG_ETL(V_COD_LOG,c_package||'.aggiorna_RIO_Monitoraggio',PKG_MCRE0_AUDIT.C_ERROR,SQLCODE,SQLERRM,'Refresh');
return ko;
end;
--load delle tabelle MV_MCRE0_APP_RIO_ESP_SC e MV_MCRE0_APP_RIO_ESP_GE
FUNCTION aggiorna_RIO_ESP(
P_COD_LOG T_MCRE0_WRK_AUDIT_ETL.ID%TYPE DEFAULT NULL
) RETURN NUMBER IS
V_COD_LOG T_MCRE0_WRK_AUDIT_ETL.ID%TYPE;
begin
IF( P_COD_LOG IS NULL) THEN
SELECT SEQ_MCR0_LOG_ETL.NEXTVAL
INTO V_COD_LOG
from dual;
ELSE
V_COD_LOG := P_COD_LOG;
end if;
PKG_MCRE0_AUDIT.LOG_ETL(V_COD_LOG,c_package||'.aggiorna_RIO_ESP',PKG_MCRE0_AUDIT.C_DEBUG,SQLCODE,SQLERRM,'START');
execute immediate 'alter session enable parallel dml';
execute immediate 'truncate table mcre_own.mv_mcre0_app_rio_esp_ge reuse storage';
execute immediate 'truncate table mcre_own.mv_mcre0_app_rio_esp_sc reuse storage';
/* Formatted on 2011/12/14 14:34 (Formatter Plus v4.8.8) */
INSERT ALL
      INTO mcre_own.mv_mcre0_app_rio_esp_ge
           (cod_abi_cartolarizzato, cod_abi_istituto, desc_istituto, cod_ndg,
            cod_sndg, dta_controllo_at, dta_pcr_at, dta_cr_at,
            gesb_acc_cassa_bt_at, gesb_uti_cassa_bt_at,
            gesb_acc_smobilizzo_at, gesb_uti_smobilizzo_at,
            gesb_acc_cassa_mlt_at, gesb_uti_cassa_mlt_at, gesb_acc_firma_at,
            gesb_uti_firma_at, gesb_acc_tot_at, gesb_uti_tot_at,
            gesb_tot_gar_at, gesb_acc_sostituzioni_at,
            gesb_uti_sostituzioni_at, gesb_acc_massimali_at,
            gesb_uti_massimali_at, gegb_acc_sostituzioni_at,
            gegb_uti_sostituzioni_at, gegb_acc_massimali_at,
            gegb_uti_massimali_at, gegb_acc_cassa_bt_at,
            gegb_uti_cassa_bt_at, gegb_acc_smobilizzo_at,
            gegb_uti_smobilizzo_at, gegb_acc_cassa_mlt_at,
            gegb_uti_cassa_mlt_at, gegb_acc_firma_at, gegb_uti_firma_at,
            gegb_tot_gar_at, gegb_uti_tot_at, gegb_acc_tot_at,
            gesb_qis_acc_at, gesb_qis_uti_at, gegb_qis_acc_at,
            gegb_qis_uti_at, gegb_acc_sis_at, gegb_uti_sis_at, cod_stato_1,
            dta_controllo_1, dta_pcr_1, dta_cr_1,
            gesb_acc_cassa_bt_1, gesb_uti_cassa_bt_1, gesb_acc_smobilizzo_1,
            gesb_uti_smobilizzo_1, gesb_acc_cassa_mlt_1,
            gesb_uti_cassa_mlt_1, gesb_acc_firma_1, gesb_uti_firma_1,
            gesb_acc_tot_1, gesb_acc_sostituzioni_1, gesb_uti_sostituzioni_1,
            gesb_acc_massimali_1, gesb_uti_massimali_1,
            gegb_acc_sostituzioni_1, gegb_uti_sostituzioni_1,
            gegb_acc_massimali_1, gegb_uti_massimali_1, gesb_uti_tot_1,
            gesb_tot_gar_1, gegb_acc_cassa_bt_1, gegb_uti_cassa_bt_1,
            gegb_acc_smobilizzo_1, gegb_uti_smobilizzo_1,
            gegb_acc_cassa_mlt_1, gegb_uti_cassa_mlt_1, gegb_acc_firma_1,
            gegb_uti_firma_1, gegb_tot_gar_1, gegb_uti_tot_1, gegb_acc_sis_1,
            gegb_uti_sis_1, gegb_acc_tot_1, gesb_qis_acc_1, gesb_qis_uti_1,
            gegb_qis_acc_1, gegb_qis_uti_1, cod_stato_2, dta_controllo_2,
            dta_pcr_2, dta_cr_2, gesb_acc_cassa_bt_2,
            gesb_uti_cassa_bt_2, gesb_acc_smobilizzo_2,
            gesb_uti_smobilizzo_2, gesb_acc_cassa_mlt_2,
            gesb_uti_cassa_mlt_2, gesb_acc_firma_2, gesb_uti_firma_2,
            gesb_acc_tot_2, gesb_uti_tot_2, gesb_tot_gar_2,
            gegb_acc_cassa_bt_2, gegb_uti_cassa_bt_2, gegb_acc_smobilizzo_2,
            gegb_uti_smobilizzo_2, gegb_acc_cassa_mlt_2,
            gegb_uti_cassa_mlt_2, gegb_tot_gar_2, gesb_acc_sostituzioni_2,
            gesb_uti_sostituzioni_2, gesb_acc_massimali_2,
            gesb_uti_massimali_2, gegb_acc_sostituzioni_2,
            gegb_uti_sostituzioni_2, gegb_acc_massimali_2,
            gegb_uti_massimali_2, gegb_uti_tot_2, gegb_acc_tot_2,
            gegb_acc_firma_2, gegb_uti_firma_2, gesb_qis_acc_2,
            gesb_qis_uti_2, gegb_qis_acc_2, gegb_qis_uti_2, gegb_acc_sis_2,
            gegb_uti_sis_2, cod_stato_3, dta_controllo_3, dta_pcr_3,
            dta_cr_3, gesb_acc_cassa_bt_3, gesb_uti_cassa_bt_3,
            gesb_acc_smobilizzo_3, gesb_uti_smobilizzo_3,
            gesb_acc_cassa_mlt_3, gesb_uti_cassa_mlt_3, gesb_acc_firma_3,
            gesb_uti_firma_3, gesb_acc_tot_3, gesb_acc_sostituzioni_3,
            gesb_uti_sostituzioni_3, gesb_acc_massimali_3,
            gesb_uti_massimali_3, gegb_acc_sostituzioni_3,
            gegb_uti_sostituzioni_3, gegb_acc_massimali_3,
            gegb_uti_massimali_3, gesb_uti_tot_3, gesb_tot_gar_3,
            gegb_acc_cassa_bt_3, gegb_uti_cassa_bt_3, gegb_acc_smobilizzo_3,
            gegb_uti_smobilizzo_3, gegb_acc_cassa_mlt_3,
            gegb_uti_cassa_mlt_3, gegb_acc_firma_3, gegb_uti_firma_3,
            gegb_tot_gar_3, gegb_uti_tot_3, gegb_acc_tot_3, gesb_qis_acc_3,
            gesb_qis_uti_3, gegb_qis_acc_3, gegb_qis_uti_3, gegb_acc_sis_3,
            gegb_uti_sis_3, cod_stato_4, dta_controllo_4, dta_pcr_4,
            dta_cr_4, gesb_acc_cassa_bt_4, gesb_uti_cassa_bt_4,
            gesb_acc_smobilizzo_4, gesb_uti_smobilizzo_4,
            gesb_acc_cassa_mlt_4, gesb_uti_cassa_mlt_4, gesb_acc_firma_4,
            gesb_uti_firma_4, gesb_acc_tot_4, gesb_uti_tot_4, gesb_tot_gar_4,
            gegb_acc_cassa_bt_4, gegb_uti_cassa_bt_4, gegb_acc_smobilizzo_4,
            gegb_uti_smobilizzo_4, gegb_acc_cassa_mlt_4,
            gegb_uti_cassa_mlt_4, gegb_acc_firma_4, gegb_uti_firma_4,
            gegb_tot_gar_4, gesb_acc_sostituzioni_4, gesb_uti_sostituzioni_4,
            gesb_acc_massimali_4, gesb_uti_massimali_4,
            gegb_acc_sostituzioni_4, gegb_uti_sostituzioni_4,
            gegb_acc_massimali_4, gegb_uti_massimali_4, gegb_uti_tot_4,
            gegb_acc_tot_4, gesb_qis_acc_4, gesb_qis_uti_4, gegb_qis_acc_4,
            gegb_qis_uti_4, gegb_acc_sis_4, gegb_uti_sis_4, cod_stato_5,
            dta_controllo_5, dta_pcr_5, dta_cr_5,
            gesb_acc_cassa_bt_5, gesb_uti_cassa_bt_5, gesb_acc_smobilizzo_5,
            gesb_uti_smobilizzo_5, gesb_acc_cassa_mlt_5,
            gesb_uti_cassa_mlt_5, gesb_acc_firma_5, gesb_uti_firma_5,
            gesb_acc_tot_5, gesb_uti_tot_5, gesb_tot_gar_5,
            gegb_acc_cassa_bt_5, gegb_uti_cassa_bt_5, gegb_acc_smobilizzo_5,
            gegb_uti_smobilizzo_5, gegb_acc_cassa_mlt_5,
            gegb_uti_cassa_mlt_5, gegb_acc_firma_5, gegb_uti_firma_5,
            gegb_tot_gar_5, gesb_acc_sostituzioni_5, gesb_uti_sostituzioni_5,
            gesb_acc_massimali_5, gesb_uti_massimali_5,
            gegb_acc_sostituzioni_5, gegb_uti_sostituzioni_5,
            gegb_acc_massimali_5, gegb_uti_massimali_5, gegb_uti_tot_5,
            gegb_acc_tot_5, gesb_qis_acc_5, gesb_qis_uti_5, gegb_qis_acc_5,
            gegb_qis_uti_5, gegb_acc_sis_5, gegb_uti_sis_5, cod_stato_6,
            dta_controllo_6, dta_pcr_6, dta_cr_6,
            gesb_acc_cassa_bt_6, gesb_uti_cassa_bt_6, gesb_acc_smobilizzo_6,
            gesb_uti_smobilizzo_6, gesb_acc_cassa_mlt_6,
            gesb_uti_cassa_mlt_6, gesb_acc_firma_6, gesb_uti_firma_6,
            gesb_acc_tot_6, gesb_uti_tot_6, gesb_tot_gar_6,
            gesb_acc_sostituzioni_6, gesb_uti_sostituzioni_6,
            gesb_acc_massimali_6, gesb_uti_massimali_6,
            gegb_acc_sostituzioni_6, gegb_uti_sostituzioni_6,
            gegb_acc_massimali_6, gegb_uti_massimali_6, gegb_acc_cassa_bt_6,
            gegb_uti_cassa_bt_6, gegb_acc_smobilizzo_6,
            gegb_uti_smobilizzo_6, gegb_acc_cassa_mlt_6,
            gegb_uti_cassa_mlt_6, gegb_acc_firma_6, gegb_uti_firma_6,
            gegb_tot_gar_6, gegb_uti_tot_6, gegb_acc_tot_6, gesb_qis_acc_6,
            gesb_qis_uti_6, gegb_qis_acc_6, gegb_qis_uti_6, gegb_acc_sis_6,
            gegb_uti_sis_6
           )
    VALUES (cod_abi_cartolarizzato, cod_abi_istituto, desc_istituto, cod_ndg,
            cod_sndg, dta_controllo_at, gesb_dta_pcr_at, gesb_dta_cr_at,
            gesb_acc_cassa_bt_at, gesb_uti_cassa_bt_at,
            gesb_acc_smobilizzo_at, gesb_uti_smobilizzo_at,
            gesb_acc_cassa_mlt_at, gesb_uti_cassa_mlt_at, gesb_acc_firma_at,
            gesb_uti_firma_at, gesb_acc_tot_at, gesb_uti_tot_at,
            gesb_tot_gar_at, gesb_acc_sostituzioni_at,
            gesb_uti_sostituzioni_at, gesb_acc_massimali_at,
            gesb_uti_massimali_at, gegb_acc_sostituzioni_at,
            gegb_uti_sostituzioni_at, gegb_acc_massimali_at,
            gegb_uti_massimali_at, gegb_acc_cassa_bt_at,
            gegb_uti_cassa_bt_at, gegb_acc_smobilizzo_at,
            gegb_uti_smobilizzo_at, gegb_acc_cassa_mlt_at,
            gegb_uti_cassa_mlt_at, gegb_acc_firma_at, gegb_uti_firma_at,
            gegb_tot_gar_at, gegb_uti_tot_at, gegb_acc_tot_at,
            gesb_qis_acc_at, gesb_qis_uti_at, gegb_qis_acc_at,
            gegb_qis_uti_at, gegb_acc_sis_at, gegb_uti_sis_at, cod_stato_1,
            dta_controllo_1, gesb_dta_pcr_1, gesb_dta_cr_1,
            gesb_acc_cassa_bt_1, gesb_uti_cassa_bt_1, gesb_acc_smobilizzo_1,
            gesb_uti_smobilizzo_1, gesb_acc_cassa_mlt_1,
            gesb_uti_cassa_mlt_1, gesb_acc_firma_1, gesb_uti_firma_1,
            gesb_acc_tot_1, gesb_acc_sostituzioni_1, gesb_uti_sostituzioni_1,
            gesb_acc_massimali_1, gesb_uti_massimali_1,
            gegb_acc_sostituzioni_1, gegb_uti_sostituzioni_1,
            gegb_acc_massimali_1, gegb_uti_massimali_1, gesb_uti_tot_1,
            gesb_tot_gar_1, gegb_acc_cassa_bt_1, gegb_uti_cassa_bt_1,
            gegb_acc_smobilizzo_1, gegb_uti_smobilizzo_1,
            gegb_acc_cassa_mlt_1, gegb_uti_cassa_mlt_1, gegb_acc_firma_1,
            gegb_uti_firma_1, gegb_tot_gar_1, gegb_uti_tot_1, gegb_acc_sis_1,
            gegb_uti_sis_1, gegb_acc_tot_1, gesb_qis_acc_1, gesb_qis_uti_1,
            gegb_qis_acc_1, gegb_qis_uti_1, cod_stato_2, dta_controllo_2,
            gesb_dta_pcr_2, gesb_dta_cr_2, gesb_acc_cassa_bt_2,
            gesb_uti_cassa_bt_2, gesb_acc_smobilizzo_2,
            gesb_uti_smobilizzo_2, gesb_acc_cassa_mlt_2,
            gesb_uti_cassa_mlt_2, gesb_acc_firma_2, gesb_uti_firma_2,
            gesb_acc_tot_2, gesb_uti_tot_2, gesb_tot_gar_2,
            gegb_acc_cassa_bt_2, gegb_uti_cassa_bt_2, gegb_acc_smobilizzo_2,
            gegb_uti_smobilizzo_2, gegb_acc_cassa_mlt_2,
            gegb_uti_cassa_mlt_2, gegb_tot_gar_2, gesb_acc_sostituzioni_2,
            gesb_uti_sostituzioni_2, gesb_acc_massimali_2,
            gesb_uti_massimali_2, gegb_acc_sostituzioni_2,
            gegb_uti_sostituzioni_2, gegb_acc_massimali_2,
            gegb_uti_massimali_2, gegb_uti_tot_2, gegb_acc_tot_2,
            gegb_acc_firma_2, gegb_uti_firma_2, gesb_qis_acc_2,
            gesb_qis_uti_2, gegb_qis_acc_2, gegb_qis_uti_2, gegb_acc_sis_2,
            gegb_uti_sis_2, cod_stato_3, dta_controllo_3, gesb_dta_pcr_3,
            gesb_dta_cr_3, gesb_acc_cassa_bt_3, gesb_uti_cassa_bt_3,
            gesb_acc_smobilizzo_3, gesb_uti_smobilizzo_3,
            gesb_acc_cassa_mlt_3, gesb_uti_cassa_mlt_3, gesb_acc_firma_3,
            gesb_uti_firma_3, gesb_acc_tot_3, gesb_acc_sostituzioni_3,
            gesb_uti_sostituzioni_3, gesb_acc_massimali_3,
            gesb_uti_massimali_3, gegb_acc_sostituzioni_3,
            gegb_uti_sostituzioni_3, gegb_acc_massimali_3,
            gegb_uti_massimali_3, gesb_uti_tot_3, gesb_tot_gar_3,
            gegb_acc_cassa_bt_3, gegb_uti_cassa_bt_3, gegb_acc_smobilizzo_3,
            gegb_uti_smobilizzo_3, gegb_acc_cassa_mlt_3,
            gegb_uti_cassa_mlt_3, gegb_acc_firma_3, gegb_uti_firma_3,
            gegb_tot_gar_3, gegb_uti_tot_3, gegb_acc_tot_3, gesb_qis_acc_3,
            gesb_qis_uti_3, gegb_qis_acc_3, gegb_qis_uti_3, gegb_acc_sis_3,
            gegb_uti_sis_3, cod_stato_4, dta_controllo_4, gesb_dta_pcr_4,
            gesb_dta_cr_4, gesb_acc_cassa_bt_4, gesb_uti_cassa_bt_4,
            gesb_acc_smobilizzo_4, gesb_uti_smobilizzo_4,
            gesb_acc_cassa_mlt_4, gesb_uti_cassa_mlt_4, gesb_acc_firma_4,
            gesb_uti_firma_4, gesb_acc_tot_4, gesb_uti_tot_4, gesb_tot_gar_4,
            gegb_acc_cassa_bt_4, gegb_uti_cassa_bt_4, gegb_acc_smobilizzo_4,
            gegb_uti_smobilizzo_4, gegb_acc_cassa_mlt_4,
            gegb_uti_cassa_mlt_4, gegb_acc_firma_4, gegb_uti_firma_4,
            gegb_tot_gar_4, gesb_acc_sostituzioni_4, gesb_uti_sostituzioni_4,
            gesb_acc_massimali_4, gesb_uti_massimali_4,
            gegb_acc_sostituzioni_4, gegb_uti_sostituzioni_4,
            gegb_acc_massimali_4, gegb_uti_massimali_4, gegb_uti_tot_4,
            gegb_acc_tot_4, gesb_qis_acc_4, gesb_qis_uti_4, gegb_qis_acc_4,
            gegb_qis_uti_4, gegb_acc_sis_4, gegb_uti_sis_4, cod_stato_5,
            dta_controllo_5, gesb_dta_pcr_5, gesb_dta_cr_5,
            gesb_acc_cassa_bt_5, gesb_uti_cassa_bt_5, gesb_acc_smobilizzo_5,
            gesb_uti_smobilizzo_5, gesb_acc_cassa_mlt_5,
            gesb_uti_cassa_mlt_5, gesb_acc_firma_5, gesb_uti_firma_5,
            gesb_acc_tot_5, gesb_uti_tot_5, gesb_tot_gar_5,
            gegb_acc_cassa_bt_5, gegb_uti_cassa_bt_5, gegb_acc_smobilizzo_5,
            gegb_uti_smobilizzo_5, gegb_acc_cassa_mlt_5,
            gegb_uti_cassa_mlt_5, gegb_acc_firma_5, gegb_uti_firma_5,
            gegb_tot_gar_5, gesb_acc_sostituzioni_5, gesb_uti_sostituzioni_5,
            gesb_acc_massimali_5, gesb_uti_massimali_5,
            gegb_acc_sostituzioni_5, gegb_uti_sostituzioni_5,
            gegb_acc_massimali_5, gegb_uti_massimali_5, gegb_uti_tot_5,
            gegb_acc_tot_5, gesb_qis_acc_5, gesb_qis_uti_5, gegb_qis_acc_5,
            gegb_qis_uti_5, gegb_acc_sis_5, gegb_uti_sis_5, cod_stato_6,
            dta_controllo_6, gesb_dta_pcr_6, gesb_dta_cr_6,
            gesb_acc_cassa_bt_6, gesb_uti_cassa_bt_6, gesb_acc_smobilizzo_6,
            gesb_uti_smobilizzo_6, gesb_acc_cassa_mlt_6,
            gesb_uti_cassa_mlt_6, gesb_acc_firma_6, gesb_uti_firma_6,
            gesb_acc_tot_6, gesb_uti_tot_6, gesb_tot_gar_6,
            gesb_acc_sostituzioni_6, gesb_uti_sostituzioni_6,
            gesb_acc_massimali_6, gesb_uti_massimali_6,
            gegb_acc_sostituzioni_6, gegb_uti_sostituzioni_6,
            gegb_acc_massimali_6, gegb_uti_massimali_6, gegb_acc_cassa_bt_6,
            gegb_uti_cassa_bt_6, gegb_acc_smobilizzo_6,
            gegb_uti_smobilizzo_6, gegb_acc_cassa_mlt_6,
            gegb_uti_cassa_mlt_6, gegb_acc_firma_6, gegb_uti_firma_6,
            gegb_tot_gar_6, gegb_uti_tot_6, gegb_acc_tot_6, gesb_qis_acc_6,
            gesb_qis_uti_6, gegb_qis_acc_6, gegb_qis_uti_6, gegb_acc_sis_6,
            gegb_uti_sis_6
           )
      INTO mcre_own.mv_mcre0_app_rio_esp_sc
           (cod_abi_cartolarizzato, cod_abi_istituto, desc_istituto, cod_ndg,
            cod_sndg, dta_controllo_at, dta_pcr_at, dta_cr_at,
            scsb_acc_cassa_bt_at, scsb_uti_cassa_bt_at,
            scsb_acc_smobilizzo_at, scsb_uti_smobilizzo_at,
            scsb_acc_cassa_mlt_at, scsb_uti_cassa_mlt_at, scsb_acc_firma_at,
            scsb_uti_firma_at, scsb_acc_tot_at, scsb_uti_tot_at,
            scsb_tot_gar_at, scsb_acc_sostituzioni_at,
            scsb_uti_sostituzioni_at, scsb_acc_massimali_at,
            scsb_uti_massimali_at, scgb_acc_sostituzioni_at,
            scgb_uti_sostituzioni_at, scgb_acc_massimali_at,
            scgb_uti_massimali_at, scgb_acc_cassa_bt_at,
            scgb_uti_cassa_bt_at, scgb_acc_smobilizzo_at,
            scgb_uti_smobilizzo_at, scgb_acc_cassa_mlt_at,
            scgb_uti_cassa_mlt_at, scgb_acc_firma_at, scgb_uti_firma_at,
            scgb_tot_gar_at, scgb_acc_tot_at, scgb_uti_tot_at,
            scsb_qis_acc_at, scsb_qis_uti_at, scgb_qis_acc_at,
            scgb_qis_uti_at, scgb_acc_sis_at, scgb_uti_sis_at, cod_stato_1,
            dta_controllo_1, dta_pcr_1, dta_cr_1,
            scsb_acc_cassa_bt_1, scsb_uti_cassa_bt_1, scsb_acc_smobilizzo_1,
            scsb_uti_smobilizzo_1, scsb_acc_cassa_mlt_1,
            scsb_uti_cassa_mlt_1, scsb_acc_firma_1, scsb_uti_firma_1,
            scsb_acc_tot_1, scsb_uti_tot_1, scsb_tot_gar_1,
            scsb_acc_sostituzioni_1, scsb_uti_sostituzioni_1,
            scsb_acc_massimali_1, scsb_uti_massimali_1,
            scgb_acc_sostituzioni_1, scgb_uti_sostituzioni_1,
            scgb_acc_massimali_1, scgb_uti_massimali_1, scgb_acc_cassa_bt_1,
            scgb_uti_cassa_bt_1, scgb_acc_smobilizzo_1,
            scgb_uti_smobilizzo_1, scgb_acc_cassa_mlt_1,
            scgb_uti_cassa_mlt_1, scgb_acc_firma_1, scgb_uti_firma_1,
            scgb_tot_gar_1, scgb_acc_tot_1, scgb_uti_tot_1, scsb_qis_acc_1,
            scsb_qis_uti_1, scgb_qis_acc_1, scgb_qis_uti_1, scgb_acc_sis_1,
            scgb_uti_sis_1, cod_stato_2, dta_controllo_2, dta_pcr_2,
            dta_cr_2, scsb_acc_cassa_bt_2, scsb_uti_cassa_bt_2,
            scsb_acc_smobilizzo_2, scsb_uti_smobilizzo_2,
            scsb_acc_cassa_mlt_2, scsb_uti_cassa_mlt_2, scsb_acc_firma_2,
            scsb_uti_firma_2, scsb_acc_tot_2, scsb_uti_tot_2, scsb_tot_gar_2,
            scsb_acc_sostituzioni_2, scsb_uti_sostituzioni_2,
            scsb_acc_massimali_2, scsb_uti_massimali_2,
            scgb_acc_sostituzioni_2, scgb_uti_sostituzioni_2,
            scgb_acc_massimali_2, scgb_uti_massimali_2, scgb_acc_cassa_bt_2,
            scgb_uti_cassa_bt_2, scgb_acc_smobilizzo_2,
            scgb_uti_smobilizzo_2, scgb_acc_cassa_mlt_2,
            scgb_uti_cassa_mlt_2, scgb_acc_firma_2, scgb_uti_firma_2,
            scgb_tot_gar_2, scgb_acc_tot_2, scgb_uti_tot_2, scsb_qis_acc_2,
            scsb_qis_uti_2, scgb_qis_acc_2, scgb_qis_uti_2, scgb_acc_sis_2,
            scgb_uti_sis_2, cod_stato_3, dta_controllo_3, dta_pcr_3,
            dta_cr_3, scsb_acc_cassa_bt_3, scsb_uti_cassa_bt_3,
            scsb_acc_smobilizzo_3, scsb_uti_smobilizzo_3,
            scsb_acc_cassa_mlt_3, scsb_uti_cassa_mlt_3, scsb_acc_firma_3,
            scsb_uti_firma_3, scsb_acc_tot_3, scsb_uti_tot_3, scsb_tot_gar_3,
            scsb_acc_sostituzioni_3, scsb_uti_sostituzioni_3,
            scsb_acc_massimali_3, scsb_uti_massimali_3,
            scgb_acc_sostituzioni_3, scgb_uti_sostituzioni_3,
            scgb_acc_massimali_3, scgb_uti_massimali_3, scgb_acc_cassa_bt_3,
            scgb_uti_cassa_bt_3, scgb_acc_smobilizzo_3,
            scgb_uti_smobilizzo_3, scgb_acc_cassa_mlt_3,
            scgb_uti_cassa_mlt_3, scgb_acc_firma_3, scgb_uti_firma_3,
            scgb_tot_gar_3, scgb_acc_tot_3, scgb_uti_tot_3, scsb_qis_acc_3,
            scsb_qis_uti_3, scgb_qis_acc_3, scgb_qis_uti_3, scgb_acc_sis_3,
            scgb_uti_sis_3, cod_stato_4, dta_controllo_4, dta_pcr_4,
            dta_cr_4, scsb_acc_cassa_bt_4, scsb_uti_cassa_bt_4,
            scsb_acc_smobilizzo_4, scsb_uti_smobilizzo_4,
            scsb_acc_cassa_mlt_4, scsb_uti_cassa_mlt_4, scsb_acc_firma_4,
            scsb_uti_firma_4, scsb_acc_tot_4, scsb_uti_tot_4, scsb_tot_gar_4,
            scsb_acc_sostituzioni_4, scsb_uti_sostituzioni_4,
            scsb_acc_massimali_4, scsb_uti_massimali_4,
            scgb_acc_sostituzioni_4, scgb_uti_sostituzioni_4,
            scgb_acc_massimali_4, scgb_uti_massimali_4, scgb_acc_cassa_bt_4,
            scgb_uti_cassa_bt_4, scgb_acc_smobilizzo_4,
            scgb_uti_smobilizzo_4, scgb_acc_cassa_mlt_4,
            scgb_uti_cassa_mlt_4, scgb_acc_firma_4, scgb_uti_firma_4,
            scgb_tot_gar_4, scgb_acc_tot_4, scgb_uti_tot_4, scsb_qis_acc_4,
            scsb_qis_uti_4, scgb_qis_acc_4, scgb_qis_uti_4, scgb_acc_sis_4,
            scgb_uti_sis_4, cod_stato_5, dta_controllo_5, dta_pcr_5,
            dta_cr_5, scsb_acc_cassa_bt_5, scsb_uti_cassa_bt_5,
            scsb_acc_smobilizzo_5, scsb_uti_smobilizzo_5,
            scsb_acc_cassa_mlt_5, scsb_uti_cassa_mlt_5, scsb_acc_firma_5,
            scsb_uti_firma_5, scsb_acc_tot_5, scsb_uti_tot_5, scsb_tot_gar_5,
            scsb_acc_sostituzioni_5, scsb_uti_sostituzioni_5,
            scsb_acc_massimali_5, scsb_uti_massimali_5,
            scgb_acc_sostituzioni_5, scgb_uti_sostituzioni_5,
            scgb_acc_massimali_5, scgb_uti_massimali_5, scgb_acc_cassa_bt_5,
            scgb_uti_cassa_bt_5, scgb_acc_smobilizzo_5,
            scgb_uti_smobilizzo_5, scgb_acc_cassa_mlt_5,
            scgb_uti_cassa_mlt_5, scgb_acc_firma_5, scgb_uti_firma_5,
            scgb_tot_gar_5, scgb_acc_tot_5, scgb_uti_tot_5, scsb_qis_acc_5,
            scsb_qis_uti_5, scgb_qis_acc_5, scgb_qis_uti_5, scgb_acc_sis_5,
            scgb_uti_sis_5, cod_stato_6, dta_controllo_6, dta_pcr_6,
            dta_cr_6, scsb_acc_cassa_bt_6, scsb_uti_cassa_bt_6,
            scsb_acc_smobilizzo_6, scsb_uti_smobilizzo_6,
            scsb_acc_cassa_mlt_6, scsb_uti_cassa_mlt_6, scsb_acc_firma_6,
            scsb_uti_firma_6, scsb_acc_tot_6, scsb_uti_tot_6, scsb_tot_gar_6,
            scsb_acc_sostituzioni_6, scsb_uti_sostituzioni_6,
            scsb_acc_massimali_6, scsb_uti_massimali_6,
            scgb_acc_sostituzioni_6, scgb_uti_sostituzioni_6,
            scgb_acc_massimali_6, scgb_uti_massimali_6, scgb_acc_cassa_bt_6,
            scgb_uti_cassa_bt_6, scgb_acc_smobilizzo_6,
            scgb_uti_smobilizzo_6, scgb_acc_cassa_mlt_6,
            scgb_uti_cassa_mlt_6, scgb_acc_firma_6, scgb_uti_firma_6,
            scgb_tot_gar_6, scgb_acc_tot_6, scgb_uti_tot_6, scsb_qis_acc_6,
            scsb_qis_uti_6, scgb_qis_acc_6, scgb_qis_uti_6, scgb_acc_sis_6,
            scgb_uti_sis_6
           )
    VALUES (cod_abi_cartolarizzato, cod_abi_istituto, desc_istituto, cod_ndg,
            cod_sndg, dta_controllo_at, scsb_dta_pcr_at, scsb_dta_cr_at,
            scsb_acc_cassa_bt_at, scsb_uti_cassa_bt_at,
            scsb_acc_smobilizzo_at, scsb_uti_smobilizzo_at,
            scsb_acc_cassa_mlt_at, scsb_uti_cassa_mlt_at, scsb_acc_firma_at,
            scsb_uti_firma_at, scsb_acc_tot_at, scsb_uti_tot_at,
            scsb_tot_gar_at, scsb_acc_sostituzioni_at,
            scsb_uti_sostituzioni_at, scsb_acc_massimali_at,
            scsb_uti_massimali_at, scgb_acc_sostituzioni_at,
            scgb_uti_sostituzioni_at, scgb_acc_massimali_at,
            scgb_uti_massimali_at, scgb_acc_cassa_bt_at,
            scgb_uti_cassa_bt_at, scgb_acc_smobilizzo_at,
            scgb_uti_smobilizzo_at, scgb_acc_cassa_mlt_at,
            scgb_uti_cassa_mlt_at, scgb_acc_firma_at, scgb_uti_firma_at,
            scgb_tot_gar_at, scgb_acc_tot_at, scgb_uti_tot_at,
            scsb_qis_acc_at, scsb_qis_uti_at, scgb_qis_acc_at,
            scgb_qis_uti_at, scgb_acc_sis_at, scgb_uti_sis_at, cod_stato_1,
            dta_controllo_1, scsb_dta_pcr_1, scsb_dta_cr_1,
            scsb_acc_cassa_bt_1, scsb_uti_cassa_bt_1, scsb_acc_smobilizzo_1,
            scsb_uti_smobilizzo_1, scsb_acc_cassa_mlt_1,
            scsb_uti_cassa_mlt_1, scsb_acc_firma_1, scsb_uti_firma_1,
            scsb_acc_tot_1, scsb_uti_tot_1, scsb_tot_gar_1,
            scsb_acc_sostituzioni_1, scsb_uti_sostituzioni_1,
            scsb_acc_massimali_1, scsb_uti_massimali_1,
            scgb_acc_sostituzioni_1, scgb_uti_sostituzioni_1,
            scgb_acc_massimali_1, scgb_uti_massimali_1, scgb_acc_cassa_bt_1,
            scgb_uti_cassa_bt_1, scgb_acc_smobilizzo_1,
            scgb_uti_smobilizzo_1, scgb_acc_cassa_mlt_1,
            scgb_uti_cassa_mlt_1, scgb_acc_firma_1, scgb_uti_firma_1,
            scgb_tot_gar_1, scgb_acc_tot_1, scgb_uti_tot_1, scsb_qis_acc_1,
            scsb_qis_uti_1, scgb_qis_acc_1, scgb_qis_uti_1, scgb_acc_sis_1,
            scgb_uti_sis_1, cod_stato_2, dta_controllo_2, scsb_dta_pcr_2,
            scsb_dta_cr_2, scsb_acc_cassa_bt_2, scsb_uti_cassa_bt_2,
            scsb_acc_smobilizzo_2, scsb_uti_smobilizzo_2,
            scsb_acc_cassa_mlt_2, scsb_uti_cassa_mlt_2, scsb_acc_firma_2,
            scsb_uti_firma_2, scsb_acc_tot_2, scsb_uti_tot_2, scsb_tot_gar_2,
            scsb_acc_sostituzioni_2, scsb_uti_sostituzioni_2,
            scsb_acc_massimali_2, scsb_uti_massimali_2,
            scgb_acc_sostituzioni_2, scgb_uti_sostituzioni_2,
            scgb_acc_massimali_2, scgb_uti_massimali_2, scgb_acc_cassa_bt_2,
            scgb_uti_cassa_bt_2, scgb_acc_smobilizzo_2,
            scgb_uti_smobilizzo_2, scgb_acc_cassa_mlt_2,
            scgb_uti_cassa_mlt_2, scgb_acc_firma_2, scgb_uti_firma_2,
            scgb_tot_gar_2, scgb_acc_tot_2, scgb_uti_tot_2, scsb_qis_acc_2,
            scsb_qis_uti_2, scgb_qis_acc_2, scgb_qis_uti_2, scgb_acc_sis_2,
            scgb_uti_sis_2, cod_stato_3, dta_controllo_3, scsb_dta_pcr_3,
            scsb_dta_cr_3, scsb_acc_cassa_bt_3, scsb_uti_cassa_bt_3,
            scsb_acc_smobilizzo_3, scsb_uti_smobilizzo_3,
            scsb_acc_cassa_mlt_3, scsb_uti_cassa_mlt_3, scsb_acc_firma_3,
            scsb_uti_firma_3, scsb_acc_tot_3, scsb_uti_tot_3, scsb_tot_gar_3,
            scsb_acc_sostituzioni_3, scsb_uti_sostituzioni_3,
            scsb_acc_massimali_3, scsb_uti_massimali_3,
            scgb_acc_sostituzioni_3, scgb_uti_sostituzioni_3,
            scgb_acc_massimali_3, scgb_uti_massimali_3, scgb_acc_cassa_bt_3,
            scgb_uti_cassa_bt_3, scgb_acc_smobilizzo_3,
            scgb_uti_smobilizzo_3, scgb_acc_cassa_mlt_3,
            scgb_uti_cassa_mlt_3, scgb_acc_firma_3, scgb_uti_firma_3,
            scgb_tot_gar_3, scgb_acc_tot_3, scgb_uti_tot_3, scsb_qis_acc_3,
            scsb_qis_uti_3, scgb_qis_acc_3, scgb_qis_uti_3, scgb_acc_sis_3,
            scgb_uti_sis_3, cod_stato_4, dta_controllo_4, scsb_dta_pcr_4,
            scsb_dta_cr_4, scsb_acc_cassa_bt_4, scsb_uti_cassa_bt_4,
            scsb_acc_smobilizzo_4, scsb_uti_smobilizzo_4,
            scsb_acc_cassa_mlt_4, scsb_uti_cassa_mlt_4, scsb_acc_firma_4,
            scsb_uti_firma_4, scsb_acc_tot_4, scsb_uti_tot_4, scsb_tot_gar_4,
            scsb_acc_sostituzioni_4, scsb_uti_sostituzioni_4,
            scsb_acc_massimali_4, scsb_uti_massimali_4,
            scgb_acc_sostituzioni_4, scgb_uti_sostituzioni_4,
            scgb_acc_massimali_4, scgb_uti_massimali_4, scgb_acc_cassa_bt_4,
            scgb_uti_cassa_bt_4, scgb_acc_smobilizzo_4,
            scgb_uti_smobilizzo_4, scgb_acc_cassa_mlt_4,
            scgb_uti_cassa_mlt_4, scgb_acc_firma_4, scgb_uti_firma_4,
            scgb_tot_gar_4, scgb_acc_tot_4, scgb_uti_tot_4, scsb_qis_acc_4,
            scsb_qis_uti_4, scgb_qis_acc_4, scgb_qis_uti_4, scgb_acc_sis_4,
            scgb_uti_sis_4, cod_stato_5, dta_controllo_5, scsb_dta_pcr_5,
            scsb_dta_cr_5, scsb_acc_cassa_bt_5, scsb_uti_cassa_bt_5,
            scsb_acc_smobilizzo_5, scsb_uti_smobilizzo_5,
            scsb_acc_cassa_mlt_5, scsb_uti_cassa_mlt_5, scsb_acc_firma_5,
            scsb_uti_firma_5, scsb_acc_tot_5, scsb_uti_tot_5, scsb_tot_gar_5,
            scsb_acc_sostituzioni_5, scsb_uti_sostituzioni_5,
            scsb_acc_massimali_5, scsb_uti_massimali_5,
            scgb_acc_sostituzioni_5, scgb_uti_sostituzioni_5,
            scgb_acc_massimali_5, scgb_uti_massimali_5, scgb_acc_cassa_bt_5,
            scgb_uti_cassa_bt_5, scgb_acc_smobilizzo_5,
            scgb_uti_smobilizzo_5, scgb_acc_cassa_mlt_5,
            scgb_uti_cassa_mlt_5, scgb_acc_firma_5, scgb_uti_firma_5,
            scgb_tot_gar_5, scgb_acc_tot_5, scgb_uti_tot_5, scsb_qis_acc_5,
            scsb_qis_uti_5, scgb_qis_acc_5, scgb_qis_uti_5, scgb_acc_sis_5,
            scgb_uti_sis_5, cod_stato_6, dta_controllo_6, scsb_dta_pcr_6,
            scsb_dta_cr_6, scsb_acc_cassa_bt_6, scsb_uti_cassa_bt_6,
            scsb_acc_smobilizzo_6, scsb_uti_smobilizzo_6,
            scsb_acc_cassa_mlt_6, scsb_uti_cassa_mlt_6, scsb_acc_firma_6,
            scsb_uti_firma_6, scsb_acc_tot_6, scsb_uti_tot_6, scsb_tot_gar_6,
            scsb_acc_sostituzioni_6, scsb_uti_sostituzioni_6,
            scsb_acc_massimali_6, scsb_uti_massimali_6,
            scgb_acc_sostituzioni_6, scgb_uti_sostituzioni_6,
            scgb_acc_massimali_6, scgb_uti_massimali_6, scgb_acc_cassa_bt_6,
            scgb_uti_cassa_bt_6, scgb_acc_smobilizzo_6,
            scgb_uti_smobilizzo_6, scgb_acc_cassa_mlt_6,
            scgb_uti_cassa_mlt_6, scgb_acc_firma_6, scgb_uti_firma_6,
            scgb_tot_gar_6, scgb_acc_tot_6, scgb_uti_tot_6, scsb_qis_acc_6,
            scsb_qis_uti_6, scgb_qis_acc_6, scgb_qis_uti_6, scgb_acc_sis_6,
            scgb_uti_sis_6
           )
   SELECT *
     FROM mcre_own.v_mcre0_app_rio_esp;
commit;
PKG_MCRE0_AUDIT.LOG_ETL(V_COD_LOG,c_package||'.aggiorna_RIO_ESP',PKG_MCRE0_AUDIT.C_DEBUG,SQLCODE,SQLERRM,'END');
return ok;
exception when others then
PKG_MCRE0_AUDIT.LOG_ETL(V_COD_LOG,c_package||'.aggiorna_RIO_ESP',PKG_MCRE0_AUDIT.C_ERROR,SQLCODE,SQLERRM,'Refresh');
return ko;
end;
--load delle tabelle MV_MCRE0_APP_RIO_ESP_SC_ANN e MV_MCRE0_APP_RIO_ESP_GE_ANN
FUNCTION aggiorna_RIO_ESP_ANN(
P_COD_LOG T_MCRE0_WRK_AUDIT_ETL.ID%TYPE DEFAULT NULL
) RETURN NUMBER IS
V_COD_LOG T_MCRE0_WRK_AUDIT_ETL.ID%TYPE;
begin
IF( P_COD_LOG IS NULL) THEN
SELECT SEQ_MCR0_LOG_ETL.NEXTVAL
INTO V_COD_LOG
from dual;
ELSE
V_COD_LOG := P_COD_LOG;
end if;
PKG_MCRE0_AUDIT.LOG_ETL(V_COD_LOG,c_package||'.aggiorna_RIO_ESP_ANN',PKG_MCRE0_AUDIT.C_DEBUG,SQLCODE,SQLERRM,'START');
execute immediate 'alter session enable parallel dml';
execute immediate 'truncate table mcre_own.mv_mcre0_app_rio_esp_ge_ann reuse storage';
execute immediate 'truncate table mcre_own.mv_mcre0_app_rio_esp_sc_ann reuse storage';
/* Formatted on 2011/12/14 14:33 (Formatter Plus v4.8.8) */
INSERT ALL
      INTO mcre_own.mv_mcre0_app_rio_esp_ge_ann
           (cod_abi_cartolarizzato, cod_abi_istituto, desc_istituto, cod_ndg,
            cod_sndg, cod_stato_at, dta_controllo_at,
            dta_pcr_at, dta_cr_at, gesb_acc_cassa_bt_at,
            gesb_uti_cassa_bt_at, gesb_acc_smobilizzo_at,
            gesb_uti_smobilizzo_at, gesb_acc_cassa_mlt_at,
            gesb_uti_cassa_mlt_at, gesb_acc_firma_at, gesb_uti_firma_at,
            gesb_acc_tot_at, gesb_uti_tot_at, gesb_tot_gar_at,
            gesb_acc_sostituzioni_at, gesb_uti_sostituzioni_at,
            gesb_acc_massimali_at, gesb_uti_massimali_at,
            gegb_acc_sostituzioni_at, gegb_uti_sostituzioni_at,
            gegb_acc_massimali_at, gegb_uti_massimali_at,
            gegb_acc_cassa_bt_at, gegb_uti_cassa_bt_at,
            gegb_acc_smobilizzo_at, gegb_uti_smobilizzo_at,
            gegb_acc_cassa_mlt_at, gegb_uti_cassa_mlt_at, gegb_acc_firma_at,
            gegb_uti_firma_at, gegb_tot_gar_at, gegb_acc_tot_at,
            gegb_uti_tot_at, gesb_qis_acc_at, gesb_qis_uti_at,
            gegb_qis_acc_at, gegb_qis_uti_at, cod_stato_mp,
            dta_controllo_mp, dta_pcr_mp, dta_cr_mp,
            gesb_acc_cassa_bt_mp, gesb_uti_cassa_bt_mp,
            gesb_acc_smobilizzo_mp, gesb_uti_smobilizzo_mp,
            gesb_acc_cassa_mlt_mp, gesb_uti_cassa_mlt_mp, gesb_acc_firma_mp,
            gesb_uti_firma_mp, gesb_acc_tot_mp, gesb_uti_tot_mp,
            gesb_tot_gar_mp, gegb_acc_cassa_bt_mp, gegb_uti_cassa_bt_mp,
            gegb_acc_smobilizzo_mp, gegb_uti_smobilizzo_mp,
            gegb_acc_cassa_mlt_mp, gegb_uti_cassa_mlt_mp, gegb_acc_firma_mp,
            gegb_uti_firma_mp, gegb_tot_gar_mp, gesb_acc_sostituzioni_mp,
            gesb_uti_sostituzioni_mp, gesb_acc_massimali_mp,
            gesb_uti_massimali_mp, gegb_acc_sostituzioni_mp,
            gegb_uti_sostituzioni_mp, gegb_acc_massimali_mp,
            gegb_uti_massimali_mp, gegb_acc_tot_mp, gegb_uti_tot_mp,
            gesb_qis_acc_mp, gesb_qis_uti_mp, gegb_qis_acc_mp,
            gegb_qis_uti_mp, cod_stato_ly, dta_controllo_ly,
            dta_pcr_ly, dta_cr_ly, gesb_acc_cassa_bt_ly,
            gesb_uti_cassa_bt_ly, gesb_acc_smobilizzo_ly,
            gesb_uti_smobilizzo_ly, gesb_acc_cassa_mlt_ly,
            gesb_uti_cassa_mlt_ly, gesb_acc_firma_ly, gesb_uti_firma_ly,
            gesb_acc_tot_ly, gesb_uti_tot_ly, gesb_tot_gar_ly,
            gesb_acc_sostituzioni_ly, gesb_uti_sostituzioni_ly,
            gesb_acc_massimali_ly, gesb_uti_massimali_ly,
            gegb_acc_sostituzioni_ly, gegb_uti_sostituzioni_ly,
            gegb_acc_massimali_ly, gegb_uti_massimali_ly,
            gegb_acc_cassa_bt_ly, gegb_uti_cassa_bt_ly,
            gegb_acc_smobilizzo_ly, gegb_uti_smobilizzo_ly,
            gegb_acc_cassa_mlt_ly, gegb_uti_cassa_mlt_ly, gegb_acc_firma_ly,
            gegb_uti_firma_ly, gegb_tot_gar_ly, gegb_acc_tot_ly,
            gegb_uti_tot_ly, gesb_qis_acc_ly, gesb_qis_uti_ly,
            gegb_qis_acc_ly, gegb_qis_uti_ly, cod_stato_ly2,
            dta_controllo_ly2, dta_pcr_ly2, dta_cr_ly2,
            gesb_acc_cassa_bt_ly2, gesb_uti_cassa_bt_ly2,
            gesb_acc_smobilizzo_ly2, gesb_uti_smobilizzo_ly2,
            gesb_acc_cassa_mlt_ly2, gesb_uti_cassa_mlt_ly2,
            gesb_acc_firma_ly2, gesb_uti_firma_ly2, gesb_acc_tot_ly2,
            gesb_uti_tot_ly2, gesb_tot_gar_ly2, gesb_acc_sostituzioni_ly2,
            gesb_uti_sostituzioni_ly2, gesb_acc_massimali_ly2,
            gesb_uti_massimali_ly2, gegb_acc_sostituzioni_ly2,
            gegb_uti_sostituzioni_ly2, gegb_acc_massimali_ly2,
            gegb_uti_massimali_ly2, gegb_acc_cassa_bt_ly2,
            gegb_uti_cassa_bt_ly2, gegb_acc_smobilizzo_ly2,
            gegb_uti_smobilizzo_ly2, gegb_acc_cassa_mlt_ly2,
            gegb_uti_cassa_mlt_ly2, gegb_acc_firma_ly2, gegb_uti_firma_ly2,
            gegb_tot_gar_ly2, gegb_acc_tot_ly2, gegb_uti_tot_ly2,
            gesb_qis_acc_ly2, gesb_qis_uti_ly2, gegb_qis_acc_ly2,
            gegb_qis_uti_ly2
           )
    VALUES (cod_abi_cartolarizzato, cod_abi_istituto, desc_istituto, cod_ndg,
            cod_sndg, gesb_cod_stato_at, gesb_dta_controllo_at,
            gesb_dta_pcr_at, gesb_dta_cr_at, gesb_acc_cassa_bt_at,
            gesb_uti_cassa_bt_at, gesb_acc_smobilizzo_at,
            gesb_uti_smobilizzo_at, gesb_acc_cassa_mlt_at,
            gesb_uti_cassa_mlt_at, gesb_acc_firma_at, gesb_uti_firma_at,
            gesb_acc_tot_at, gesb_uti_tot_at, gesb_tot_gar_at,
            gesb_acc_sostituzioni_at, gesb_uti_sostituzioni_at,
            gesb_acc_massimali_at, gesb_uti_massimali_at,
            gegb_acc_sostituzioni_at, gegb_uti_sostituzioni_at,
            gegb_acc_massimali_at, gegb_uti_massimali_at,
            gegb_acc_cassa_bt_at, gegb_uti_cassa_bt_at,
            gegb_acc_smobilizzo_at, gegb_uti_smobilizzo_at,
            gegb_acc_cassa_mlt_at, gegb_uti_cassa_mlt_at, gegb_acc_firma_at,
            gegb_uti_firma_at, gegb_tot_gar_at, gegb_acc_tot_at,
            gegb_uti_tot_at, gesb_qis_acc_at, gesb_qis_uti_at,
            gegb_qis_acc_at, gegb_qis_uti_at, gesb_cod_stato_mp,
            gesb_dta_controllo_mp, gesb_dta_pcr_mp, gesb_dta_cr_mp,
            gesb_acc_cassa_bt_mp, gesb_uti_cassa_bt_mp,
            gesb_acc_smobilizzo_mp, gesb_uti_smobilizzo_mp,
            gesb_acc_cassa_mlt_mp, gesb_uti_cassa_mlt_mp, gesb_acc_firma_mp,
            gesb_uti_firma_mp, gesb_acc_tot_mp, gesb_uti_tot_mp,
            gesb_tot_gar_mp, gegb_acc_cassa_bt_mp, gegb_uti_cassa_bt_mp,
            gegb_acc_smobilizzo_mp, gegb_uti_smobilizzo_mp,
            gegb_acc_cassa_mlt_mp, gegb_uti_cassa_mlt_mp, gegb_acc_firma_mp,
            gegb_uti_firma_mp, gegb_tot_gar_mp, gesb_acc_sostituzioni_mp,
            gesb_uti_sostituzioni_mp, gesb_acc_massimali_mp,
            gesb_uti_massimali_mp, gegb_acc_sostituzioni_mp,
            gegb_uti_sostituzioni_mp, gegb_acc_massimali_mp,
            gegb_uti_massimali_mp, gegb_acc_tot_mp, gegb_uti_tot_mp,
            gesb_qis_acc_mp, gesb_qis_uti_mp, gegb_qis_acc_mp,
            gegb_qis_uti_mp, gesb_cod_stato_ly, gesb_dta_controllo_ly,
            gesb_dta_pcr_ly, gesb_dta_cr_ly, gesb_acc_cassa_bt_ly,
            gesb_uti_cassa_bt_ly, gesb_acc_smobilizzo_ly,
            gesb_uti_smobilizzo_ly, gesb_acc_cassa_mlt_ly,
            gesb_uti_cassa_mlt_ly, gesb_acc_firma_ly, gesb_uti_firma_ly,
            gesb_acc_tot_ly, gesb_uti_tot_ly, gesb_tot_gar_ly,
            gesb_acc_sostituzioni_ly, gesb_uti_sostituzioni_ly,
            gesb_acc_massimali_ly, gesb_uti_massimali_ly,
            gegb_acc_sostituzioni_ly, gegb_uti_sostituzioni_ly,
            gegb_acc_massimali_ly, gegb_uti_massimali_ly,
            gegb_acc_cassa_bt_ly, gegb_uti_cassa_bt_ly,
            gegb_acc_smobilizzo_ly, gegb_uti_smobilizzo_ly,
            gegb_acc_cassa_mlt_ly, gegb_uti_cassa_mlt_ly, gegb_acc_firma_ly,
            gegb_uti_firma_ly, gegb_tot_gar_ly, gegb_acc_tot_ly,
            gegb_uti_tot_ly, gesb_qis_acc_ly, gesb_qis_uti_ly,
            gegb_qis_acc_ly, gegb_qis_uti_ly, gesb_cod_stato_ly2,
            gesb_dta_controllo_ly2, gesb_dta_pcr_ly2, gesb_dta_cr_ly2,
            gesb_acc_cassa_bt_ly2, gesb_uti_cassa_bt_ly2,
            gesb_acc_smobilizzo_ly2, gesb_uti_smobilizzo_ly2,
            gesb_acc_cassa_mlt_ly2, gesb_uti_cassa_mlt_ly2,
            gesb_acc_firma_ly2, gesb_uti_firma_ly2, gesb_acc_tot_ly2,
            gesb_uti_tot_ly2, gesb_tot_gar_ly2, gesb_acc_sostituzioni_ly2,
            gesb_uti_sostituzioni_ly2, gesb_acc_massimali_ly2,
            gesb_uti_massimali_ly2, gegb_acc_sostituzioni_ly2,
            gegb_uti_sostituzioni_ly2, gegb_acc_massimali_ly2,
            gegb_uti_massimali_ly2, gegb_acc_cassa_bt_ly2,
            gegb_uti_cassa_bt_ly2, gegb_acc_smobilizzo_ly2,
            gegb_uti_smobilizzo_ly2, gegb_acc_cassa_mlt_ly2,
            gegb_uti_cassa_mlt_ly2, gegb_acc_firma_ly2, gegb_uti_firma_ly2,
            gegb_tot_gar_ly2, gegb_acc_tot_ly2, gegb_uti_tot_ly2,
            gesb_qis_acc_ly2, gesb_qis_uti_ly2, gegb_qis_acc_ly2,
            gegb_qis_uti_ly2
           )
      INTO mcre_own.mv_mcre0_app_rio_esp_sc_ann
           (cod_abi_cartolarizzato, cod_abi_istituto, desc_istituto, cod_ndg,
            cod_sndg, cod_stato_at, dta_controllo_at,
            dta_pcr_at, dta_cr_at, scsb_acc_cassa_bt_at,
            scsb_uti_cassa_bt_at, scsb_acc_smobilizzo_at,
            scsb_uti_smobilizzo_at, scsb_acc_cassa_mlt_at,
            scsb_uti_cassa_mlt_at, scsb_acc_firma_at, scsb_uti_firma_at,
            scsb_acc_tot_at, scsb_uti_tot_at, scsb_tot_gar_at,
            scsb_acc_sostituzioni_at, scsb_uti_sostituzioni_at,
            scsb_acc_massimali_at, scsb_uti_massimali_at,
            scgb_acc_sostituzioni_at, scgb_uti_sostituzioni_at,
            scgb_acc_massimali_at, scgb_uti_massimali_at,
            scgb_acc_cassa_bt_at, scgb_uti_cassa_bt_at,
            scgb_acc_smobilizzo_at, scgb_uti_smobilizzo_at,
            scgb_acc_cassa_mlt_at, scgb_uti_cassa_mlt_at, scgb_acc_firma_at,
            scgb_uti_firma_at, scgb_tot_gar_at, scgb_acc_tot_at,
            scgb_uti_tot_at, scsb_qis_acc_at, scsb_qis_uti_at,
            scgb_qis_acc_at, scgb_qis_uti_at, cod_stato_mp,
            dta_controllo_mp, dta_pcr_mp, dta_cr_mp,
            scsb_acc_cassa_bt_mp, scsb_uti_cassa_bt_mp,
            scsb_acc_smobilizzo_mp, scsb_uti_smobilizzo_mp,
            scsb_acc_cassa_mlt_mp, scsb_uti_cassa_mlt_mp, scsb_acc_firma_mp,
            scsb_uti_firma_mp, scsb_acc_tot_mp, scsb_uti_tot_mp,
            scsb_tot_gar_mp, scgb_acc_cassa_bt_mp, scgb_uti_cassa_bt_mp,
            scgb_acc_smobilizzo_mp, scgb_uti_smobilizzo_mp,
            scgb_acc_cassa_mlt_mp, scgb_uti_cassa_mlt_mp, scgb_acc_firma_mp,
            scgb_uti_firma_mp, scgb_tot_gar_mp, scsb_acc_sostituzioni_mp,
            scsb_uti_sostituzioni_mp, scsb_acc_massimali_mp,
            scsb_uti_massimali_mp, scgb_acc_sostituzioni_mp,
            scgb_uti_sostituzioni_mp, scgb_acc_massimali_mp,
            scgb_uti_massimali_mp, scgb_acc_tot_mp, scgb_uti_tot_mp,
            scsb_qis_acc_mp, scsb_qis_uti_mp, scgb_qis_acc_mp,
            scgb_qis_uti_mp, cod_stato_ly, dta_controllo_ly,
            dta_pcr_ly, dta_cr_ly, scsb_acc_cassa_bt_ly,
            scsb_uti_cassa_bt_ly, scsb_acc_smobilizzo_ly,
            scsb_uti_smobilizzo_ly, scsb_acc_cassa_mlt_ly,
            scsb_uti_cassa_mlt_ly, scsb_acc_firma_ly, scsb_uti_firma_ly,
            scsb_acc_tot_ly, scsb_uti_tot_ly, scsb_tot_gar_ly,
            scsb_acc_sostituzioni_ly, scsb_uti_sostituzioni_ly,
            scsb_acc_massimali_ly, scsb_uti_massimali_ly,
            scgb_acc_sostituzioni_ly, scgb_uti_sostituzioni_ly,
            scgb_acc_massimali_ly, scgb_uti_massimali_ly,
            scgb_acc_cassa_bt_ly, scgb_uti_cassa_bt_ly,
            scgb_acc_smobilizzo_ly, scgb_uti_smobilizzo_ly,
            scgb_acc_cassa_mlt_ly, scgb_uti_cassa_mlt_ly, scgb_acc_firma_ly,
            scgb_uti_firma_ly, scgb_tot_gar_ly, scgb_acc_tot_ly,
            scgb_uti_tot_ly, scsb_qis_acc_ly, scsb_qis_uti_ly,
            scgb_qis_acc_ly, scgb_qis_uti_ly, cod_stato_ly2,
            dta_controllo_ly2, dta_pcr_ly2, dta_cr_ly2,
            scsb_acc_cassa_bt_ly2, scsb_uti_cassa_bt_ly2,
            scsb_acc_smobilizzo_ly2, scsb_uti_smobilizzo_ly2,
            scsb_acc_cassa_mlt_ly2, scsb_uti_cassa_mlt_ly2,
            scsb_acc_firma_ly2, scsb_uti_firma_ly2, scsb_acc_tot_ly2,
            scsb_uti_tot_ly2, scsb_tot_gar_ly2, scsb_acc_sostituzioni_ly2,
            scsb_uti_sostituzioni_ly2, scsb_acc_massimali_ly2,
            scsb_uti_massimali_ly2, scgb_acc_sostituzioni_ly2,
            scgb_uti_sostituzioni_ly2, scgb_acc_massimali_ly2,
            scgb_uti_massimali_ly2, scgb_acc_cassa_bt_ly2,
            scgb_uti_cassa_bt_ly2, scgb_acc_smobilizzo_ly2,
            scgb_uti_smobilizzo_ly2, scgb_acc_cassa_mlt_ly2,
            scgb_uti_cassa_mlt_ly2, scgb_acc_firma_ly2, scgb_uti_firma_ly2,
            scgb_tot_gar_ly2, scgb_acc_tot_ly2, scgb_uti_tot_ly2,
            scsb_qis_acc_ly2, scsb_qis_uti_ly2, scgb_qis_acc_ly2,
            scgb_qis_uti_ly2
           )
    VALUES (cod_abi_cartolarizzato, cod_abi_istituto, desc_istituto, cod_ndg,
            cod_sndg, scsb_cod_stato_at, scsb_dta_controllo_at,
            scsb_dta_pcr_at, scsb_dta_cr_at, scsb_acc_cassa_bt_at,
            scsb_uti_cassa_bt_at, scsb_acc_smobilizzo_at,
            scsb_uti_smobilizzo_at, scsb_acc_cassa_mlt_at,
            scsb_uti_cassa_mlt_at, scsb_acc_firma_at, scsb_uti_firma_at,
            scsb_acc_tot_at, scsb_uti_tot_at, scsb_tot_gar_at,
            scsb_acc_sostituzioni_at, scsb_uti_sostituzioni_at,
            scsb_acc_massimali_at, scsb_uti_massimali_at,
            scgb_acc_sostituzioni_at, scgb_uti_sostituzioni_at,
            scgb_acc_massimali_at, scgb_uti_massimali_at,
            scgb_acc_cassa_bt_at, scgb_uti_cassa_bt_at,
            scgb_acc_smobilizzo_at, scgb_uti_smobilizzo_at,
            scgb_acc_cassa_mlt_at, scgb_uti_cassa_mlt_at, scgb_acc_firma_at,
            scgb_uti_firma_at, scgb_tot_gar_at, scgb_acc_tot_at,
            scgb_uti_tot_at, scsb_qis_acc_at, scsb_qis_uti_at,
            scgb_qis_acc_at, scgb_qis_uti_at, scsb_cod_stato_mp,
            scsb_dta_controllo_mp, scsb_dta_pcr_mp, scsb_dta_cr_mp,
            scsb_acc_cassa_bt_mp, scsb_uti_cassa_bt_mp,
            scsb_acc_smobilizzo_mp, scsb_uti_smobilizzo_mp,
            scsb_acc_cassa_mlt_mp, scsb_uti_cassa_mlt_mp, scsb_acc_firma_mp,
            scsb_uti_firma_mp, scsb_acc_tot_mp, scsb_uti_tot_mp,
            scsb_tot_gar_mp, scgb_acc_cassa_bt_mp, scgb_uti_cassa_bt_mp,
            scgb_acc_smobilizzo_mp, scgb_uti_smobilizzo_mp,
            scgb_acc_cassa_mlt_mp, scgb_uti_cassa_mlt_mp, scgb_acc_firma_mp,
            scgb_uti_firma_mp, scgb_tot_gar_mp, scsb_acc_sostituzioni_mp,
            scsb_uti_sostituzioni_mp, scsb_acc_massimali_mp,
            scsb_uti_massimali_mp, scgb_acc_sostituzioni_mp,
            scgb_uti_sostituzioni_mp, scgb_acc_massimali_mp,
            scgb_uti_massimali_mp, scgb_acc_tot_mp, scgb_uti_tot_mp,
            scsb_qis_acc_mp, scsb_qis_uti_mp, scgb_qis_acc_mp,
            scgb_qis_uti_mp, scsb_cod_stato_ly, scsb_dta_controllo_ly,
            scsb_dta_pcr_ly, scsb_dta_cr_ly, scsb_acc_cassa_bt_ly,
            scsb_uti_cassa_bt_ly, scsb_acc_smobilizzo_ly,
            scsb_uti_smobilizzo_ly, scsb_acc_cassa_mlt_ly,
            scsb_uti_cassa_mlt_ly, scsb_acc_firma_ly, scsb_uti_firma_ly,
            scsb_acc_tot_ly, scsb_uti_tot_ly, scsb_tot_gar_ly,
            scsb_acc_sostituzioni_ly, scsb_uti_sostituzioni_ly,
            scsb_acc_massimali_ly, scsb_uti_massimali_ly,
            scgb_acc_sostituzioni_ly, scgb_uti_sostituzioni_ly,
            scgb_acc_massimali_ly, scgb_uti_massimali_ly,
            scgb_acc_cassa_bt_ly, scgb_uti_cassa_bt_ly,
            scgb_acc_smobilizzo_ly, scgb_uti_smobilizzo_ly,
            scgb_acc_cassa_mlt_ly, scgb_uti_cassa_mlt_ly, scgb_acc_firma_ly,
            scgb_uti_firma_ly, scgb_tot_gar_ly, scgb_acc_tot_ly,
            scgb_uti_tot_ly, scsb_qis_acc_ly, scsb_qis_uti_ly,
            scgb_qis_acc_ly, scgb_qis_uti_ly, scsb_cod_stato_ly2,
            scsb_dta_controllo_ly2, scsb_dta_pcr_ly2, scsb_dta_cr_ly2,
            scsb_acc_cassa_bt_ly2, scsb_uti_cassa_bt_ly2,
            scsb_acc_smobilizzo_ly2, scsb_uti_smobilizzo_ly2,
            scsb_acc_cassa_mlt_ly2, scsb_uti_cassa_mlt_ly2,
            scsb_acc_firma_ly2, scsb_uti_firma_ly2, scsb_acc_tot_ly2,
            scsb_uti_tot_ly2, scsb_tot_gar_ly2, scsb_acc_sostituzioni_ly2,
            scsb_uti_sostituzioni_ly2, scsb_acc_massimali_ly2,
            scsb_uti_massimali_ly2, scgb_acc_sostituzioni_ly2,
            scgb_uti_sostituzioni_ly2, scgb_acc_massimali_ly2,
            scgb_uti_massimali_ly2, scgb_acc_cassa_bt_ly2,
            scgb_uti_cassa_bt_ly2, scgb_acc_smobilizzo_ly2,
            scgb_uti_smobilizzo_ly2, scgb_acc_cassa_mlt_ly2,
            scgb_uti_cassa_mlt_ly2, scgb_acc_firma_ly2, scgb_uti_firma_ly2,
            scgb_tot_gar_ly2, scgb_acc_tot_ly2, scgb_uti_tot_ly2,
            scsb_qis_acc_ly2, scsb_qis_uti_ly2, scgb_qis_acc_ly2,
            scgb_qis_uti_ly2
           )
   SELECT *
     FROM mcre_own.v_mcre0_app_rio_esp_ann;
commit;
PKG_MCRE0_AUDIT.LOG_ETL(V_COD_LOG,c_package||'.aggiorna_RIO_ESP_ANN',PKG_MCRE0_AUDIT.C_DEBUG,SQLCODE,SQLERRM,'END');
return ok;
exception when others then
PKG_MCRE0_AUDIT.LOG_ETL(V_COD_LOG,c_package||'.aggiorna_RIO_ESP_ANN',PKG_MCRE0_AUDIT.C_ERROR,SQLCODE,SQLERRM,'Refresh');
return ko;
end;

--aggiorna la MV_MCRE0_DENORM_STR_ORG
FUNCTION aggiorna_DENORM_STR_ORG(
P_COD_LOG T_MCRE0_WRK_AUDIT_ETL.ID%TYPE DEFAULT NULL
) RETURN NUMBER IS
V_COD_LOG T_MCRE0_WRK_AUDIT_ETL.ID%TYPE;
begin
IF( P_COD_LOG IS NULL) THEN
SELECT SEQ_MCR0_LOG_ETL.NEXTVAL
INTO V_COD_LOG
from dual;
ELSE
V_COD_LOG := P_COD_LOG;
end if;
PKG_MCRE0_AUDIT.LOG_ETL(V_COD_LOG,c_package||'.aggiorna_DENORM_STR_ORG',PKG_MCRE0_AUDIT.C_DEBUG,SQLCODE,SQLERRM,'START');
DBMS_MVIEW.REFRESH(
LIST => 'MCRE_OWN.MV_MCRE0_DENORM_STR_ORG'
,METHOD => 'C'
,PURGE_OPTION => 1
,PARALLELISM => 4
--,HEAP_SIZE => 3
--,ATOMIC_REFRESH => TRUE
,NESTED => FALSE);
PKG_MCRE0_AUDIT.LOG_ETL(V_COD_LOG,c_package||'.aggiorna_DENORM_STR_ORG',PKG_MCRE0_AUDIT.C_DEBUG,SQLCODE,SQLERRM,'END');
return ok;
exception when others then
PKG_MCRE0_AUDIT.LOG_ETL(V_COD_LOG,c_package||'.aggiorna_DENORM_STR_ORG',PKG_MCRE0_AUDIT.C_ERROR,SQLCODE,SQLERRM,'Refresh');
return ko;
END;
--aggiorna la MV_MCRE0_APP_CR
FUNCTION aggiorna_CR(
P_COD_LOG T_MCRE0_WRK_AUDIT_ETL.ID%TYPE DEFAULT NULL
) RETURN NUMBER IS
V_COD_LOG T_MCRE0_WRK_AUDIT_ETL.ID%TYPE;
begin
IF( P_COD_LOG IS NULL) THEN
SELECT SEQ_MCR0_LOG_ETL.NEXTVAL
INTO V_COD_LOG
from dual;
ELSE
V_COD_LOG := P_COD_LOG;
end if;
PKG_MCRE0_AUDIT.LOG_ETL(V_COD_LOG,c_package||'.aggiorna_CR',PKG_MCRE0_AUDIT.C_DEBUG,SQLCODE,SQLERRM,'START');
DBMS_MVIEW.REFRESH(
LIST => 'MCRE_OWN.MV_MCRE0_APP_CR'
,METHOD => 'C'
,PURGE_OPTION => 1
,PARALLELISM => 4
--,ATOMIC_REFRESH => TRUE
,NESTED => FALSE);
PKG_MCRE0_AUDIT.LOG_ETL(V_COD_LOG,c_package||'.aggiorna_CR',PKG_MCRE0_AUDIT.C_DEBUG,SQLCODE,SQLERRM,'END');
return ok;
exception when others then
PKG_MCRE0_AUDIT.LOG_ETL(V_COD_LOG,c_package||'.aggiorna_CR',PKG_MCRE0_AUDIT.C_ERROR,SQLCODE,SQLERRM,'Refresh');
return ko;
END;
--aggiorna la MV_MCRE0_APP_CR_RI
FUNCTION aggiorna_CR_RI(
P_COD_LOG T_MCRE0_WRK_AUDIT_ETL.ID%TYPE DEFAULT NULL
) RETURN NUMBER IS
V_COD_LOG T_MCRE0_WRK_AUDIT_ETL.ID%TYPE;
begin
IF( P_COD_LOG IS NULL) THEN
SELECT SEQ_MCR0_LOG_ETL.NEXTVAL
INTO V_COD_LOG
from dual;
ELSE
V_COD_LOG := P_COD_LOG;
end if;
PKG_MCRE0_AUDIT.LOG_ETL(V_COD_LOG,c_package||'.aggiorna_CR_RI',PKG_MCRE0_AUDIT.C_DEBUG,SQLCODE,SQLERRM,'START');
DBMS_MVIEW.refresh(
LIST => 'MCRE_OWN.MV_MCRE0_APP_CR_RI'
,METHOD => 'C'
,PURGE_OPTION => 1
,PARALLELISM => 4
--,ATOMIC_REFRESH => TRUE
,NESTED => FALSE);
PKG_MCRE0_AUDIT.LOG_ETL(V_COD_LOG,c_package||'.aggiorna_CR_RI',PKG_MCRE0_AUDIT.C_DEBUG,SQLCODE,SQLERRM,'END');
return ok;
EXCEPTION when OTHERS then
PKG_MCRE0_AUDIT.LOG_ETL(V_COD_LOG,c_package||'.aggiorna_CR_RI',PKG_MCRE0_AUDIT.C_ERROR,SQLCODE,SQLERRM,'Refresh');
return ko;
END;
--aggiorna la MV_MCRE0_APP_CR_SC
FUNCTION aggiorna_CR_SC(
P_COD_LOG T_MCRE0_WRK_AUDIT_ETL.ID%TYPE DEFAULT NULL
) RETURN NUMBER IS
V_COD_LOG T_MCRE0_WRK_AUDIT_ETL.ID%TYPE;
begin
IF( P_COD_LOG IS NULL) THEN
SELECT SEQ_MCR0_LOG_ETL.NEXTVAL
INTO V_COD_LOG
from dual;
ELSE
V_COD_LOG := P_COD_LOG;
end if;
PKG_MCRE0_AUDIT.LOG_ETL(V_COD_LOG,c_package||'.aggiorna_CR_SC',PKG_MCRE0_AUDIT.C_DEBUG,SQLCODE,SQLERRM,'START');
DBMS_MVIEW.refresh(
LIST => 'MCRE_OWN.MV_MCRE0_APP_CR_SC'
,METHOD => 'C'
,PURGE_OPTION => 1
,PARALLELISM => 4
--,ATOMIC_REFRESH => TRUE
,NESTED => FALSE);
PKG_MCRE0_AUDIT.LOG_ETL(V_COD_LOG,c_package||'.aggiorna_CR_SC',PKG_MCRE0_AUDIT.C_DEBUG,SQLCODE,SQLERRM,'END');
return ok;
EXCEPTION WHEN OTHERS THEN
PKG_MCRE0_AUDIT.LOG_ETL(V_COD_LOG,c_package||'.aggiorna_CR_SC',PKG_MCRE0_AUDIT.C_ERROR,SQLCODE,SQLERRM,'Refresh');
return ko;
END;
--aggiorna la MV_MCRE0_APP_CR_SO
FUNCTION aggiorna_CR_SO(
P_COD_LOG T_MCRE0_WRK_AUDIT_ETL.ID%TYPE DEFAULT NULL
) RETURN NUMBER IS
V_COD_LOG T_MCRE0_WRK_AUDIT_ETL.ID%TYPE;
begin
IF( P_COD_LOG IS NULL) THEN
SELECT SEQ_MCR0_LOG_ETL.NEXTVAL
INTO V_COD_LOG
from dual;
ELSE
V_COD_LOG := P_COD_LOG;
end if;
PKG_MCRE0_AUDIT.LOG_ETL(V_COD_LOG,c_package||'.aggiorna_CR_SO',PKG_MCRE0_AUDIT.C_DEBUG,SQLCODE,SQLERRM,'START');
DBMS_MVIEW.refresh(
LIST => 'MCRE_OWN.MV_MCRE0_APP_CR_SO'
,METHOD => 'C'
,PURGE_OPTION => 1
,PARALLELISM => 4
--,ATOMIC_REFRESH => TRUE
,NESTED => FALSE);
PKG_MCRE0_AUDIT.LOG_ETL(V_COD_LOG,c_package||'.aggiorna_CR_SO',PKG_MCRE0_AUDIT.C_DEBUG,SQLCODE,SQLERRM,'END');
return ok;
EXCEPTION when OTHERS then
PKG_MCRE0_AUDIT.LOG_ETL(V_COD_LOG,c_package||'.aggiorna_CR_SO',PKG_MCRE0_AUDIT.C_ERROR,SQLCODE,SQLERRM,'Refresh');
return ko;
END;
--aggiorna tutte le MV di CR solo quando cambia il mese CR
FUNCTION AGGIORNA_CR_ALL(
P_COD_LOG T_MCRE0_WRK_AUDIT_ETL.ID%TYPE DEFAULT NULL
) RETURN NUMBER IS
V_ESITO NUMBER:=KO;
V_EXISTS NUMBER:=0;
V_COD_LOG T_MCRE0_WRK_AUDIT_ETL.ID%TYPE;
BEGIN
IF( P_COD_LOG IS NULL) THEN
SELECT SEQ_MCR0_LOG_ETL.NEXTVAL
INTO V_COD_LOG
from dual;
ELSE
V_COD_LOG := P_COD_LOG;
end if;
PKG_MCRE0_AUDIT.LOG_ETL(V_COD_LOG,c_package||'.aggiorna_CR_ALL',PKG_MCRE0_AUDIT.C_DEBUG,SQLCODE,SQLERRM,'START');
v_esito := ok;
PKG_MCRE0_AUDIT.LOG_ETL(V_COD_LOG,c_package||'.aggiorna_CR_ALL',PKG_MCRE0_AUDIT.C_DEBUG,SQLCODE,'Dati gi¿ caricati','END');
return v_esito;
EXCEPTION
when OTHERS then
PKG_MCRE0_AUDIT.LOG_ETL(V_COD_LOG,c_package||'.aggiorna_CR_ALL',PKG_MCRE0_AUDIT.C_ERROR,SQLCODE,SQLERRM,'Refresh');
return ko;
END;
FUNCTION aggiorna_POS_STATO_ST(
P_COD_LOG T_MCRE0_WRK_AUDIT_ETL.ID%TYPE DEFAULT NULL
) RETURN NUMBER IS
V_COD_LOG T_MCRE0_WRK_AUDIT_ETL.ID%TYPE;
begin
IF( P_COD_LOG IS NULL) THEN
SELECT SEQ_MCR0_LOG_ETL.NEXTVAL
INTO V_COD_LOG
from dual;
ELSE
V_COD_LOG := P_COD_LOG;
end if;
PKG_MCRE0_AUDIT.LOG_ETL(V_COD_LOG,c_package||'.aggiorna_POS_STATO_ST',PKG_MCRE0_AUDIT.C_DEBUG,SQLCODE,SQLERRM,'START');
DBMS_MVIEW.REFRESH(
LIST => 'MCRE_OWN.MV_MCRE0_APP_POS_STATO_ST'
,METHOD => 'C'
,PURGE_OPTION => 1
,PARALLELISM => 4
--,ATOMIC_REFRESH => TRUE
,NESTED => FALSE);
PKG_MCRE0_AUDIT.LOG_ETL(V_COD_LOG,c_package||'.aggiorna_POS_STATO_ST',PKG_MCRE0_AUDIT.C_DEBUG,SQLCODE,SQLERRM,'END');
return ok;
exception when others then
PKG_MCRE0_AUDIT.LOG_ETL(V_COD_LOG,C_PACKAGE||'.aggiorna_POS_STATO_ST',PKG_MCRE0_AUDIT.C_ERROR,SQLCODE,SQLERRM,'Refresh');
return ko;
END;
--cancella i log
FUNCTION drop_snp_log(P_COD_LOG T_MCRE0_WRK_AUDIT_ETL.ID%TYPE DEFAULT NULL) RETURN NUMBER IS
V_COD_LOG T_MCRE0_WRK_AUDIT_ETL.ID%TYPE;
cursor c is
select distinct 'drop materialized view log on '|| a.MASTER mysql
from user_snapshot_logs a;
begin
IF( P_COD_LOG IS NULL) THEN
SELECT SEQ_MCR0_LOG_ETL.NEXTVAL
INTO V_COD_LOG
from dual;
ELSE
V_COD_LOG := P_COD_LOG;
end if;
PKG_MCRE0_AUDIT.LOG_ETL(V_COD_LOG,c_package||'.drop_snp_log',PKG_MCRE0_AUDIT.C_DEBUG,SQLCODE,SQLERRM,'START');
begin
for v in c
loop
execute immediate v.mysql;
end loop;
end;
PKG_MCRE0_AUDIT.LOG_ETL(V_COD_LOG,c_package||'.drop_snp_log',PKG_MCRE0_AUDIT.C_DEBUG,SQLCODE,SQLERRM,'END');
return ok;
end;
--ricrea i log
FUNCTION create_snp_log(P_COD_LOG T_MCRE0_WRK_AUDIT_ETL.ID%TYPE DEFAULT NULL) RETURN NUMBER IS
V_COD_LOG T_MCRE0_WRK_AUDIT_ETL.ID%TYPE;
TYPE mytables IS TABLE OF VARCHAR2(255);
p_tables mytables:=mytables(
 'T_MCRE0_APP_FILE_GUIDA24',
 'T_MCRE0_APP_MOPLE24',
 'T_MCRE0_APP_PCR24',
 'T_MCRE0_APP_ANAGR_GRE24',
 'T_MCRE0_APP_ABI_ELABORATI24',
 'T_MCRE0_APP_ANAGRAFICA_GRUPPO2',
 'T_MCRE0_APP_GB_GESTIONE',
 'T_MCRE0_APP_ISTITUTI_ALL',
 'T_MCRE0_APP_UTENTI');
i integer;
cursor c is
select distinct 'GRANT select on '|| a.LOG_TABLE||' to mcre_app' mysql
from user_snapshot_logs a
union
select distinct 'GRANT select on '|| a.LOG_TABLE||' to mcre_usr' mysql
from user_snapshot_logs a ;
begin
IF( P_COD_LOG IS NULL) THEN
SELECT SEQ_MCR0_LOG_ETL.NEXTVAL
INTO V_COD_LOG
from dual;
ELSE
V_COD_LOG := P_COD_LOG;
end if;
PKG_MCRE0_AUDIT.LOG_ETL(V_COD_LOG,c_package||'.create_snp_log',PKG_MCRE0_AUDIT.C_DEBUG,SQLCODE,SQLERRM,'START');
begin
for i IN p_tables.FIRST .. p_tables.LAST
loop
execute immediate 'create materialized view log on '||p_tables(i) ||
 ' TABLESPACE TSD_MCRE_OWN NOCACHE NOLOGGING '||
 case when i<4 then 'parallel(degree 2 instances 1) ' else 'NOPARALLEL ' end ||
 'WITH ROWID '||
 case when i<4 then 'INCLUDING NEW VALUES' else '' end;
-- execute immediate 'create materialized view log on '||p_tables(i) ||
-- ' TABLESPACE TSD_MCRE_OWN NOCACHE NOLOGGING '||
-- case when i<4 then 'parallel(degree 2 instances 1) ' else 'NOPARALLEL ' end ||
-- 'WITH ROWID INCLUDING NEW VALUES' ;

end loop;
end;
begin
for v in c
loop
execute immediate v.mysql;
end loop;
exception
WHEN OTHERS THEN
PKG_MCRE0_AUDIT.LOG_ETL(V_COD_LOG,C_PACKAGE||'.create_snp_log',PKG_MCRE0_AUDIT.C_ERROR,SQLCODE,SQLERRM,'GRANT LOG');
end;
PKG_MCRE0_AUDIT.LOG_ETL(V_COD_LOG,c_package||'.create_snp_log',PKG_MCRE0_AUDIT.C_DEBUG,SQLCODE,SQLERRM,'END');
return ok;
end;
-- aggiornamento FAST -- da chiamare da portale
FUNCTION REFRESH_FAST_SNP(
P_COD_LOG T_MCRE0_WRK_AUDIT_APPLICATIVO.ID%TYPE DEFAULT NULL,
P_UTENTE T_MCRE0_APP_UTENTI.COD_MATRICOLA%TYPE DEFAULT NULL
) RETURN NUMBER IS
V_COD_LOG T_MCRE0_WRK_AUDIT_APPLICATIVO.ID%TYPE;
begin
return ok;
EXCEPTION WHEN OTHERS THEN
PKG_MCRE0_AUDIT.LOG_APP(V_COD_LOG,C_PACKAGE||'.REFRESH_FAST_SNP',PKG_MCRE0_AUDIT.C_ERROR,SQLCODE,SQLERRM,'REFRESH FAST MV',P_UTENTE);
return ko;
end;
-- aggiornamento FAST -- da Lancia_Tutto (ETL_Secondo_Livello)
FUNCTION refresh_first_fast_snp(
P_COD_LOG T_MCRE0_WRK_AUDIT_ETL.ID%TYPE DEFAULT NULL
) RETURN NUMBER IS
V_COD_LOG T_MCRE0_WRK_AUDIT_ETL.ID%TYPE;
begin
return ok;
EXCEPTION WHEN OTHERS THEN
PKG_MCRE0_AUDIT.LOG_ETL(V_COD_LOG,C_PACKAGE||'.refresh_first_fast_snp',PKG_MCRE0_AUDIT.C_ERROR,SQLCODE,SQLERRM,'REFRESH FAST - FIRST');
return ko;
end;
--refresh complete
FUNCTION refresh_complete_snp(
P_COD_LOG T_MCRE0_WRK_AUDIT_ETL.ID%TYPE DEFAULT NULL
) RETURN NUMBER IS
V_COD_LOG T_MCRE0_WRK_AUDIT_ETL.ID%TYPE;
begin
return ok;
EXCEPTION WHEN OTHERS THEN
PKG_MCRE0_AUDIT.LOG_ETL(V_COD_LOG,C_PACKAGE||'.refresh_complete_snp',PKG_MCRE0_AUDIT.C_ERROR,SQLCODE,SQLERRM,'REFRESH COMPLETE');
return ko;
end;
end PKG_MCRE0_AGGIORNA_MV2;
/


CREATE SYNONYM MCRE_APP.PKG_MCRE0_AGGIORNA_MV2 FOR MCRE_OWN.PKG_MCRE0_AGGIORNA_MV2;


CREATE SYNONYM MCRE_USR.PKG_MCRE0_AGGIORNA_MV2 FOR MCRE_OWN.PKG_MCRE0_AGGIORNA_MV2;


GRANT EXECUTE, DEBUG ON MCRE_OWN.PKG_MCRE0_AGGIORNA_MV2 TO MCRE_USR;

