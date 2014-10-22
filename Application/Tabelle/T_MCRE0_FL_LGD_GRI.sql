CREATE TABLE MCRE_OWN.T_MCRE0_FL_LGD_GRI(
ID_DPER         NUMBER(8),
COD_ABI					VARCHAR2(5 BYTE),
COD_SEGMENTO_ECO  VARCHAR2(2 BYTE),
COD_TIPO_RISCHIO VARCHAR2(2 BYTE), 
COD_TIPO_PROD				VARCHAR2(1 BYTE),
FLG_CASSA_FIRMA		VARCHAR2(2 BYTE),
COD_AREA_GEO				VARCHAR2(2 BYTE),
COD_TIPO_LEASING	  VARCHAR2(2 BYTE),
COD_TIPO_ESP_FACT		VARCHAR2(2 BYTE),
FLG_PRES_ASSICUR		VARCHAR2(2 BYTE),
COD_NAT_GIUR		VARCHAR2(1 BYTE),
COD_FTC_LGD		VARCHAR2(3 BYTE),
COD_TIPO_GAR		VARCHAR2(2 BYTE),
VAL_TPERM_ST_RICHIO	NUMBER(3),
VAL_ESP_FSC_CL_CAS		NUMBER(13), 
VAL_ESP_FSC_RAPP					NUMBER(13),
VAL_COP_GAR_IPOT					NUMBER(5,2), 
VAL_PERC_LGD					NUMBER(5,2),
VAL_TMR_1					NUMBER(3), 
VAL_TMR_2					NUMBER(3), 
DTA_INS       DATE DEFAULT SYSDATE NOT NULL,
DTA_PERIODO   DATE NOT NULL
)
TABLESPACE TSD_MCRE_OWN
PARTITION BY LIST(COD_ABI)
(
PARTITION INC_PALTRI VALUES (DEFAULT) TABLESPACE TSD_MCRE_OWN
)
RESULT_CACHE (MODE DEFAULT);

GRANT SELECT,INSERT,UPDATE,DELETE,INSERT,UPDATE,DELETE ON MCRE_OWN.T_MCRE0_FL_LGD_GRI TO MCRE_APP;
GRANT SELECT,INSERT,UPDATE,DELETE,INSERT,UPDATE,DELETE ON MCRE_OWN.T_MCRE0_FL_LGD_GRI TO MCRE_USR;

CREATE PUBLIC SYNONYM T_MCRE0_FL_LGD_GRI FOR MCRE_OWN.T_MCRE0_FL_LGD_GRI;
