CREATE TABLE MCRE_OWN.T_MCRE0_FL_LGD_PAR_S(
ID_DPER         NUMBER(8),
COD_ABI                    VARCHAR2(5 BYTE),  
COD_NDG                    VARCHAR2(16 BYTE),
DTA_RIF_SISBA              DATE,
COD_RAPP_UO                VARCHAR2(5 BYTE),
COD_RAPP_PROD              VARCHAR2(4 BYTE),
COD_RAPP_NUM               VARCHAR2(8 BYTE),
COD_RAPP_SISBA             VARCHAR2(32 BYTE),
COD_TIPO_RISCHIO           VARCHAR2(2 BYTE),
COD_SEGMENTO_ECO           VARCHAR2(2 BYTE),
VAL_R014_MORTAGE           VARCHAR2(1 BYTE),
COD_TIPO_PROD              VARCHAR2(1 BYTE),
COD_AREA_GEO_ORIG          VARCHAR2(5 BYTE),
COD_AREA_GEO               VARCHAR2(2 BYTE),
COD_ST_GIUR_ORIG           VARCHAR2(1 BYTE),
COD_NAT_GIUR               VARCHAR2(1 BYTE),
DTA_VAL_RISCHIO            DATE,
VAL_TPERM_ST_RICHIO        NUMBER  (3 ,0),
FLG_CASSA_FIRMA            VARCHAR2(1 BYTE),
COD_FTC_SISBA_ORIG         VARCHAR2(5 BYTE),
COD_R791_PR_FTC_SISBA      VARCHAR2(2 BYTE),
COD_FTC_LGD_ORIG           VARCHAR2(7 BYTE),
COD_FTC_LGD                VARCHAR2(3 BYTE),
COD_TIPO_LEASING           VARCHAR2(2 BYTE),
COD_TIPO_ESP_FACT          VARCHAR2(2 BYTE),
FLG_PRES_ASSICUR           VARCHAR2(2 BYTE),
VAL_CAP_PIU_INT            NUMBER  (15,2),                       
VAL_INT_MORA               NUMBER  (15,2),                        
VAL_IMP_RATA_MORA          NUMBER  (15,2),
VAL_IMP_CRE_FIRMA          NUMBER  (15,2),                        
VAL_IMP_STO_INT_MUT        NUMBER  (15,2),                         
VAL_ESP_FSC_CL_CAS         NUMBER  (15,2),                         
VA_ESP_FSC_CL_FIR          NUMBER  (15,2),                         
VAL_ESP_FSC_RAPP           NUMBER  (15,2),                         
VAL_IMP_GAR_IPOT           NUMBER  (15,2),
VAL_COP_GAR_IPOT           NUMBER  (5 ,2),                          
VAL_COP_GAR_IPOT_RAPP      NUMBER  (15,2),
VAL_PERC_LGD_IPO           NUMBER  (5 ,2),                         
VAL_RETT_VAL_IPO           NUMBER  (15,2),                          
VAL_GAR_PIGN               NUMBER  (15,2),                          
VAL_COP_GAR_PIGN_RAPP      NUMBER  (15,2),
VAL_PERC_LGD_PIGN          NUMBER  (5 ,2),                         
VAL_RETT_VAL_PIGN          NUMBER  (15,2),                        
VAL_GAR_PERS               NUMBER  (15,2),                        
VAL_COP_GAR_PERS_RAPP      NUMBER  (15,2),
VAL_PERC_LGD_PERS          NUMBER  (5 ,2),                       
VAL_RETT_VAL_PERS          NUMBER  (15,2),                         
VAL_CAP_RAPP_NON_GAR       NUMBER  (15,2),
VAL_PERC_LGD_NON_GAR       NUMBER  (5 ,2),                         
VAL_RETT_VAL_NON_GAR       NUMBER  (15,2),                          
VAL_RETT_TOTALE            NUMBER  (15,2),                         
VAL_RETT_TOT_PIU_MORA      NUMBER  (15,2),
VAL_MM_PIANO               NUMBER  (3 ,0),                        
VAL_VALORE_ATTUALE         NUMBER  (15,2),                      
VAL_COSTO_ATTUALIZ         NUMBER  (15,2),
DTA_INS       DATE DEFAULT SYSDATE NOT NULL,
DTA_PERIODO   DATE NOT NULL
)
TABLESPACE TSD_MCRE_OWN
PARTITION BY LIST(COD_ABI)
(
PARTITION INC_PALTRI VALUES (DEFAULT) TABLESPACE TSD_MCRE_OWN
)
RESULT_CACHE (MODE DEFAULT);

GRANT SELECT,INSERT,UPDATE,DELETE ON MCRE_OWN.T_MCRE0_FL_LGD_PAR_S TO MCRE_APP;
GRANT SELECT,INSERT,UPDATE,DELETE ON MCRE_OWN.T_MCRE0_FL_LGD_PAR_S TO MCRE_USR;

CREATE PUBLIC SYNONYM T_MCRE0_FL_LGD_PAR_S FOR MCRE_OWN.T_MCRE0_FL_LGD_PAR_S;

