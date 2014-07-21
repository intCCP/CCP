/* Formatted on 21/07/2014 18:44:42 (QP5 v5.227.12220.39754) */
CREATE OR REPLACE FORCE VIEW MCRE_OWN.V_MCRES_WRK_SAP_ITF
(
   LINE
)
AS
     SELECT line
       FROM (SELECT cod_sap_societa,
                    val_ordine_tipo_record,
                    val_progressivo,
                    line
               FROM v_mcres_wrk_body_sap_itf
             UNION ALL
               SELECT cod_sap_societa,
                      99 val_ordine_tipo_record,
                      POWER (10, 9) val_progressivo,
                         --------
                         ' EF'                                  -- tipo record
                      || SUBSTR (cod_sap_societa, 1, 4)         -- cod_sap_soc
                      || TO_CHAR (SYSDATE, 'yyyymmdd')        -- dta_creazione
                      || TO_CHAR (SYSDATE, 'hh24miss')         -- ora crazione
                      || '*MCT*'                      -- identificativo flusso
                      || LPAD (
                            SUM (
                                 DECODE (val_ordine_tipo_record, 2, 1, 0)
                               + DECODE (val_ordine_tipo_record, 4, 1, 0)),
                            5,
                            '0')                           -- numero_documenti
                      || LPAD (COUNT (*) + 1, 6, '0')         -- numero_record
                      || RPAD (' ', 223, ' ')                        -- filler
                         line
                 FROM v_mcres_wrk_body_sap_itf
             GROUP BY cod_sap_societa)
   ORDER BY cod_sap_societa, val_progressivo, val_ordine_tipo_record;
