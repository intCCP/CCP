CREATE TABLE MCRE_OWN.T_MCRE0_SC_CONVERT_LGD_PAR(
ID_FLUSSO         NUMBER,
ID_DPER           VARCHAR2(8 BYTE),
COD_ABI		        VARCHAR2(5 BYTE),
COD_NSG		        VARCHAR2(13 BYTE),
DT_RIF_SISBA		  VARCHAR2(10 BYTE),
CODRAPP_UO		    VARCHAR2(5 BYTE),
CODRAPP_PROD		  VARCHAR2(4 BYTE),
CODRAPP_NUM		    VARCHAR2(8 BYTE),
KEY_SISBA		      VARCHAR2(32 BYTE),
COD_STATO		      VARCHAR2(2 BYTE),
COD_SEG		        VARCHAR2(2 BYTE),
R014_MORTGAGE		  VARCHAR2(1 BYTE),
TIPO_PROD		      VARCHAR2(1 BYTE),
AREA_GEO_ORIG		  VARCHAR2(5 BYTE),
AREA_GEO		      VARCHAR2(2 BYTE),
ST_GIUR_ORIG		  VARCHAR2(1 BYTE),
STATO_GIUR		    VARCHAR2(1 BYTE),
DT_IN_VAL_RISC		VARCHAR2(10 BYTE),
TEMPO_PERMAN		  VARCHAR2(3 BYTE),
FLG_C_F		        VARCHAR2(1 BYTE),
FTC_SISBA_ORIG		VARCHAR2(5 BYTE),
R791_PR_FTCSIS		VARCHAR2(2 BYTE),
FTC_LGD_ORIG		  VARCHAR2(7 BYTE),
FTC_LGD		        VARCHAR2(3 BYTE),
TIPO_LEASING		  VARCHAR2(2 BYTE),
TIPO_FACTORING		VARCHAR2(2 BYTE),
PRES_ASSICUR		  VARCHAR2(2 BYTE),
SEGNO_VOCE_0004		VARCHAR2(1 BYTE),
VOCE_0004		      VARCHAR2(15 BYTE),
SEGNO_VOCE_9024		VARCHAR2(1 BYTE),
VOCE_9024		      VARCHAR2(15 BYTE),
SEGNO_VOCE_9026		VARCHAR2(1 BYTE),
VOCE_9026		      VARCHAR2(15 BYTE),
SEGNO_VOCE_0628		VARCHAR2(1 BYTE),
VOCE_0628		      VARCHAR2(15 BYTE),
SEGNO_ST_I_MUT		VARCHAR2(1 BYTE),
V8369_ST_I_MUT		    VARCHAR2(15 BYTE),
SEGNO_ESP_FSC_CL_CAS	VARCHAR2(1 BYTE),
ESP_FSC_CL_CAS		    VARCHAR2(15 BYTE),
SEGNO_ESP_FSC_CL_FIR  VARCHAR2(1 BYTE),
ESP_FSC_CL_FIR        VARCHAR2(15 BYTE),
SEGNO_ESP_FSC_RAPP    VARCHAR2(1 BYTE),
ESP_FSC_RAPP          VARCHAR2(15 BYTE),
SEGNO_V0968_GAR_IPOT  VARCHAR2(1 BYTE),
V0968_GAR_IPOT        VARCHAR2(15 BYTE),
QTA_COP_GAR_IP        VARCHAR2(5 BYTE),
SEGNO_QC_RAPP_IPO     VARCHAR2(1 BYTE),
QC_RAPP_IPO           VARCHAR2(15 BYTE),
PERC_LGD_IPO          VARCHAR2(5 BYTE),
SEGNO_RETT_VAL_IPO    VARCHAR2(1 BYTE),
RETT_VAL_IPO          VARCHAR2(15 BYTE),
SEGNO_V9042_GAR_PIGN  VARCHAR2(1 BYTE),
V9042_GAR_PIGN        VARCHAR2(15 BYTE),
SEGNO_QC_RAPP_PIGN    VARCHAR2(1 BYTE),
QC_RAPP_PIGN          VARCHAR2(15 BYTE),
PERC_LGD_PIGN         VARCHAR2(5 BYTE),
SEGNO_RETT_VAL_PIGN   VARCHAR2(1 BYTE),
RETT_VAL_PIGN         VARCHAR2(15 BYTE),
SEGNO_VGAR_PERS       VARCHAR2(1 BYTE),
VGAR_PERS             VARCHAR2(15 BYTE),
SEGNO_QC_RAPP_PERS    VARCHAR2(1 BYTE),
QC_RAPP_PERS          VARCHAR2(15 BYTE),
PERC_LGD_PERS         VARCHAR2(5 BYTE),
SEGNO_RETT_VAL_PERS   VARCHAR2(1 BYTE),
RETT_VAL_PERS         VARCHAR2(15 BYTE),
SEGNO_QC_RAPP_NOGAR   VARCHAR2(1 BYTE),
QC_RAPP_NOGAR         VARCHAR2(15 BYTE),
PERC_LGD_NOGAR        VARCHAR2(5 BYTE),
SEGNO_RETT_VAL_NOGAR  VARCHAR2(1 BYTE),
RETT_VAL_NOGAR        VARCHAR2(15 BYTE),
SEGNO_RETT_VAL_TOT    VARCHAR2(1 BYTE),
RETT_VAL_TOT          VARCHAR2(15 BYTE),
SEGNO_VOCE_1495       VARCHAR2(1 BYTE),
VOCE_1495             VARCHAR2(15 BYTE),
TEMPO_MM_PIANO        VARCHAR2(3 BYTE),
SEGNO_VALORE_ATTUALE  VARCHAR2(1 BYTE),
VALORE_ATTUALE        VARCHAR2(15 BYTE),
SEGNO_COSTO_ATTUALIZ  VARCHAR2(1 BYTE),
COSTO_ATTUALIZ        VARCHAR2(15 BYTE),
DT_ESTRAZ             VARCHAR2(8 BYTE)
--,FLG_CONVERT_VALID NUMBER(1)
--,FLG_VINCOLI_VALID NUMBER(1)
)
TABLESPACE TSD_MCRE_ST_OWN
RESULT_CACHE (MODE DEFAULT);   

CREATE INDEX MCRE_OWN.IX_T_MCRE0_SC_CONV_LGD_PAR_01 ON MCRE_OWN.T_MCRE0_SC_CONVERT_LGD_PAR(ID_FLUSSO) TABLESPACE TSI_MCRE_OWN;
CREATE INDEX MCRE_OWN.IX_T_MCRE0_SC_CONV_LGD_PAR_02 ON MCRE_OWN.T_MCRE0_SC_CONVERT_LGD_PAR(ID_DPER) TABLESPACE TSI_MCRE_OWN;

GRANT SELECT,INSERT,UPDATE,DELETE ON MCRE_OWN.T_MCRE0_SC_CONVERT_LGD_PAR TO MCRE_APP;
GRANT SELECT,INSERT,UPDATE,DELETE ON MCRE_OWN.T_MCRE0_SC_CONVERT_LGD_PAR TO MCRE_USR;

CREATE PUBLIC SYNONYM T_MCRE0_SC_CONVERT_LGD_PAR FOR MCRE_OWN.T_MCRE0_SC_CONVERT_LGD_PAR;
