/* Formatted on 17/06/2014 18:10:35 (QP5 v5.227.12220.39754) */
CREATE OR REPLACE FORCE VIEW MCRE_OWN.V_MCRES_APP_LISTA_TRIMESTRI
(
   COD_LABEL_TRIM,
   DESC_LABEL_TRIM
)
AS
     SELECT val_anno || val_mese cod_label_trim,
            val_mese || '/' || val_anno desc_label_trim
       FROM (SELECT '03' val_mese FROM DUAL
             UNION
             SELECT '06' val_mese FROM DUAL
             UNION
             SELECT '09' val_mese FROM DUAL
             UNION
             SELECT '12' VAL_MESE FROM DUAL) A,
            (SELECT TO_NUMBER (TO_CHAR (SYSDATE, 'YYYY')) val_anno FROM DUAL
             UNION
             SELECT TO_NUMBER (TO_CHAR (SYSDATE, 'YYYY')) - 1 val_anno
               FROM DUAL
             UNION
             SELECT TO_NUMBER (TO_CHAR (SYSDATE, 'YYYY')) - 2 val_anno
               FROM DUAL
             UNION
             SELECT TO_NUMBER (TO_CHAR (SYSDATE, 'YYYY')) - 3 val_anno
               FROM DUAL
             UNION
             SELECT TO_NUMBER (TO_CHAR (SYSDATE, 'YYYY')) - 4 VAL_ANNO
               FROM DUAL) B
   ORDER BY val_anno || val_mese;


GRANT SELECT ON MCRE_OWN.V_MCRES_APP_LISTA_TRIMESTRI TO MCRE_USR;
