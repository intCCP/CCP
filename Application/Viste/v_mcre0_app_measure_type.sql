/* Formatted on 21/07/2014 18:34:12 (QP5 v5.227.12220.39754) */
CREATE OR REPLACE FORCE VIEW MCRE_OWN.V_MCRE0_APP_MEASURE_TYPE
(
   MEASURE_TYPE,
   MEASURE_TYPE_DES,
   MEASURE_TYPE_CTX,
   MEASURE_TYPE_CTX_DES
)
AS
   (SELECT 1 measure_type,
           'Totale Portafoglio' measure_type_des,
           '1' measure_type_ctx,
           'Stock' measure_type_ctx_des
      FROM DUAL
    UNION ALL
    SELECT 2 measure_type,
           'Totale Garanzie Reali' measure_type_des,
           '1' measure_type_ctx,
           'Stock' measure_type_ctx_des
      FROM DUAL
    UNION ALL
    SELECT 3 measure_type,
           'Totale Garanzie Reali e Personali' measure_type_des,
           '1' measure_type_ctx,
           'Stock' measure_type_ctx_des
      FROM DUAL);
