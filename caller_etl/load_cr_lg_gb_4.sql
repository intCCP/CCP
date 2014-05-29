Insert into T_MCRE0_ETL_CALLER (CALLER,SQL_ORD,SQL_TEXT,STEP,FLG_EXEC,LAST_UPDATE_DATE,NOTE) values ('load_cr_lg_gb','4','insert into T_MCRE0_DAY_CLGG 
select COD_SNDG_LG, 
       VAL_ACC_LGGB, 
       VAL_UTI_LGGB, 
       VAL_SCO_LGGB, 
       VAL_GAR_LGGB, 
       VAL_ACC_SIS_LG, 
       VAL_UTI_SIS_LG, 
       VAL_SCO_SIS_LG, 
       VAL_IMP_GAR_SIS_LG, 
       DTA_RIFERIMENTO_CR, 
       sysdate as DTA_INS, 
       sysdate as DTA_UPD, 
       ID_DPER
from V_MCRE0_DAY_CLGG','DAY','1',to_date('11-MAR-2014 13:08:17','DD-MON-YYYY HH24:MI:SS'),'insert into T_MCRE0_DAY_CLGG ');