Insert into T_MCRE0_ETL_CALLER (CALLER,SQL_ORD,SQL_TEXT,STEP,FLG_EXEC,LAST_UPDATE_DATE,NOTE) values ('load_abielab','4','insert into t_mcre0_day_abi  
select COD_ABI_ISTITUTO,
       DTA_ELABORAZIONE,
       TMS_ULTIMA_ELABORAZIONE,
       SYSDATE as DTA_INS,
       SYSDATE as DTA_UPD,
       ID_DPER
from   T_MCRE0_STG_ABI','DAY','1',to_date('18-NOV-2013 00:47:46','DD-MON-YYYY HH24:MI:SS'),'insert into t_mcre0_day_abi  
select COD_ABI_ISTITUTO,
       DTA_ELABORAZIONE,
       TMS_ULTIMA_ELABORAZIONE,
       SYSDATE as DTA_INS,
       SYSDATE as DTA_UPD,
       ID_DPER
from   T_MCRE0_STG_ABI');