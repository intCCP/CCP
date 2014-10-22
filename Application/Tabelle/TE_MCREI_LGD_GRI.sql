CREATE TABLE MCRE_OWN.TE_MCREI_LGD_GRI(
ID_DPER           VARCHAR2(8 BYTE),
COD_ABI					  VARCHAR2(5 BYTE),
SEGM_ECO					VARCHAR2(2 BYTE),
COD_TIPO_RISK			VARCHAR2(2 BYTE),
TIPO_PROD					VARCHAR2(1 BYTE),
IND_C_F					  VARCHAR2(2 BYTE),
AREA_GEO					VARCHAR2(2 BYTE),
TIPO_LEAS					VARCHAR2(2 BYTE),
TIPO_ESP_FACT			VARCHAR2(2 BYTE),
IND_PRES_ASS			VARCHAR2(2 BYTE),
NAT_GIUR					VARCHAR2(1 BYTE),
FORMA_TEC					VARCHAR2(3 BYTE),
TIPO_GAR					VARCHAR2(2 BYTE),
TPERM_ST_RISK			VARCHAR2(3 BYTE),
SEGNO_ESPOS_CLI		VARCHAR2(1 BYTE),
ESPOS_CLI					VARCHAR2(13 BYTE),
SEGNO_ESPOS_RAPP	VARCHAR2(1 BYTE),
ESPOS_RAPP				VARCHAR2(13 BYTE),
COP_GAR_IMMOB			VARCHAR2(5 BYTE),
PERC_LGD					VARCHAR2(5 BYTE),
TMR_1					    VARCHAR2(3 BYTE),
TMR_2					    VARCHAR2(3 BYTE),
DT_ESTRAZ					VARCHAR2(8 BYTE)
)
ORGANIZATION EXTERNAL
(
  TYPE ORACLE_LOADER 
  DEFAULT DIRECTORY D_MCREI_WORK 
  ACCESS PARAMETERS 
  ( 
    RECORDS DELIMITED BY newline
    CHARACTERSET UTF8
    STRING SIZES ARE IN BYTES
    BADFILE 'D_MCRE0_BAD':'LGD_GRI.bad'
    NODISCARDFILE
    LOGFILE 'D_MCRE0_LOG':'LGD_GRI.log'
    FIELDS
    MISSING FIELD VALUES ARE NULL
    (
      ID_DPER           POSITION(74 : 81)       CHAR(8),
      COD_ABI					  POSITION(1 : 5)         CHAR(5),
      SEGM_ECO					POSITION(6 : 7)         CHAR(2),
      COD_TIPO_RISK			POSITION(8 : 9)         CHAR(2),
      TIPO_PROD					POSITION(10 : 10)       CHAR(1),
      IND_C_F					  POSITION(11 : 12)       CHAR(2),
      AREA_GEO					POSITION(13 : 14)       CHAR(2),
      TIPO_LEAS					POSITION(15 : 16)       CHAR(2),
      TIPO_ESP_FACT			POSITION(17 : 18)       CHAR(2),
      IND_PRES_ASS			POSITION(19 : 20)       CHAR(2),
      NAT_GIUR					POSITION(21 : 21)       CHAR(1),
      FORMA_TEC					POSITION(22 : 24)       CHAR(3),
      TIPO_GAR					POSITION(25 : 26)       CHAR(2),
      TPERM_ST_RISK			POSITION(27 : 29)       CHAR(3),
      SEGNO_ESPOS_CLI		POSITION(30 : 30)       CHAR(1),
      ESPOS_CLI					POSITION(31 : 43)       CHAR(13),
      SEGNO_ESPOS_RAPP	POSITION(44 : 44)       CHAR(1),
      ESPOS_RAPP				POSITION(45 : 57)       CHAR(13),
      COP_GAR_IMMOB			POSITION(58 : 62)       CHAR(5),
      PERC_LGD					POSITION(63 : 67)       CHAR(5),
      TMR_1					    POSITION(68 : 70)       CHAR(3),
      TMR_2					    POSITION(71 : 73)       CHAR(3),
      DT_ESTRAZ					POSITION(74 : 81)       CHAR(8)
    )
  ) 
  LOCATION 
  ( 
    D_MCREI_WORK: 'LGD_GRI.01010'
  , D_MCREI_WORK: 'LGD_GRI.01025'
  , D_MCREI_WORK: 'LGD_GRI.03059'
  , D_MCREI_WORK: 'LGD_GRI.03239'
  , D_MCREI_WORK: 'LGD_GRI.03240'
  , D_MCREI_WORK: 'LGD_GRI.03249'
  , D_MCREI_WORK: 'LGD_GRI.03296'
  , D_MCREI_WORK: 'LGD_GRI.03309'
  , D_MCREI_WORK: 'LGD_GRI.03359'
  , D_MCREI_WORK: 'LGD_GRI.05748'
  , D_MCREI_WORK: 'LGD_GRI.06010'
  , D_MCREI_WORK: 'LGD_GRI.06065'
  , D_MCREI_WORK: 'LGD_GRI.06080'
  , D_MCREI_WORK: 'LGD_GRI.06125'
  , D_MCREI_WORK: 'LGD_GRI.06130'
  , D_MCREI_WORK: 'LGD_GRI.06160'
  , D_MCREI_WORK: 'LGD_GRI.06165'
  , D_MCREI_WORK: 'LGD_GRI.06225'
  , D_MCREI_WORK: 'LGD_GRI.06260'
  , D_MCREI_WORK: 'LGD_GRI.06280'
  , D_MCREI_WORK: 'LGD_GRI.06315'
  , D_MCREI_WORK: 'LGD_GRI.06340'
  , D_MCREI_WORK: 'LGD_GRI.06345'
  , D_MCREI_WORK: 'LGD_GRI.06380'
  , D_MCREI_WORK: 'LGD_GRI.06385'
  , D_MCREI_WORK: 'LGD_GRI.06930'
  , D_MCREI_WORK: 'LGD_GRI.10637' 
  ) 
)
REJECT LIMIT UNLIMITED;

GRANT SELECT ON MCRE_OWN.TE_MCREI_LGD_GRI TO MCRE_APP;
GRANT SELECT ON MCRE_OWN.TE_MCREI_LGD_GRI TO MCRE_USR;
CREATE PUBLIC SYNONYM TE_MCREI_LGD_GRI FOR MCRE_OWN.TE_MCREI_LGD_GRI;