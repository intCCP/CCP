/* Formatted on 21/07/2014 18:30:21 (QP5 v5.227.12220.39754) */
CREATE OR REPLACE FORCE VIEW MCRE_OWN.QZV_ST_MIS_ABI
(
   COD_ABI,
   ORD_ABI,
   DES_ISTITUTO,
   DES_BREVE,
   ORD_TIPO_ABI,
   DES_TIPO_ABI,
   FLG_OUTSOURCING,
   FLG_OUTSOURCING_DRC,
   FLG_TARGET
)
AS
     SELECT COD_ABI,
            ORD_ABI,
            DES_ISTITUTO,
            DES_BREVE,
            ORD_TIPO_ABI,
            DES_TIPO_ABI,
            FLG_OUTSOURCING,
            FLG_OUTSOURCING_DRC,
            FLG_TARGET
       FROM (SELECT COD_ABI,
                    VAL_ORDINE ORD_ABI,
                    DESC_ISTITUTO DES_ISTITUTO,
                    DESC_BREVE DES_BREVE,
                    VAL_ORDINE_TIPO_ABI ORD_TIPO_ABI,
                    CASE
                       WHEN LOWER (DESC_TIPO_ABI) LIKE
                               'banca dei territori%altre%'
                       THEN
                          'Banche Territori - altre società'
                       WHEN LOWER (DESC_TIPO_ABI) LIKE 'banca dei territori%'
                       THEN
                          'Banche Territori'
                       WHEN LOWER (DESC_TIPO_ABI) LIKE 'cib%'
                       THEN
                          'CIB'
                       WHEN LOWER (DESC_TIPO_ABI) LIKE '%altre%'
                       THEN
                          'Altre Società'
                       WHEN LOWER (DESC_TIPO_ABI) LIKE '%estere%'
                       THEN
                          'Banche Estere'
                       ELSE
                          'No description'
                    END
                       DES_TIPO_ABI,
                    FLG_OUTSOURCING,
                    FLG_OUTSOURCING_DRC,
                    FLG_TARGET
               FROM mcre_own.T_MCRE0_APP_ISTITUTI_ALL
              WHERE FLG_SOFF = 1)
   ORDER BY ORD_TIPO_ABI, ORD_ABI;
