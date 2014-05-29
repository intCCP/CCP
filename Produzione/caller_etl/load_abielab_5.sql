Insert into T_MCRE0_ETL_CALLER (CALLER,SQL_ORD,SQL_TEXT,STEP,FLG_EXEC,LAST_UPDATE_DATE,NOTE) values ('load_abielab','5','MERGE INTO T_MCRE0_DWH_ABI trg
USING T_MCRE0_DAY_ABI src
ON  ( src.COD_ABI_ISTITUTO = trg.COD_ABI_ISTITUTO)
WHEN MATCHED THEN UPDATE
              SET
                trg.DTA_ELABORAZIONE = src.DTA_ELABORAZIONE,
                trg.TMS_ULTIMA_ELABORAZIONE = src.TMS_ULTIMA_ELABORAZIONE,
                trg.DTA_UPD = sysdate,                
                trg.ID_DPER = src.ID_DPER
WHEN NOT MATCHED THEN INSERT (
                        trg.COD_ABI_ISTITUTO,
                        trg.DTA_ELABORAZIONE,
                        trg.TMS_ULTIMA_ELABORAZIONE,
                        trg.DTA_INS,
                        trg.DTA_UPD,
                        trg.ID_DPER )
              VALUES (
                        src.COD_ABI_ISTITUTO,
                        src.DTA_ELABORAZIONE,
                        src.TMS_ULTIMA_ELABORAZIONE,
                        sysdate,
                        sysdate,                        
                        src.ID_DPER )','DWH','1',to_date('18-NOV-2013 00:47:46','DD-MON-YYYY HH24:MI:SS'),'MERGE INTO T_MCRE0_DWH_ABI ');