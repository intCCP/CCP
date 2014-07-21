/* Formatted on 17/06/2014 17:59:18 (QP5 v5.227.12220.39754) */
CREATE OR REPLACE FORCE VIEW MCRE_OWN.QZV_ST_MIS_RT
(
   COD_SRC,
   ID_DPER,
   DTA_COMPETENZA,
   COD_STATO_RISCHIO,
   DES_STATO_RISCHIO,
   COD_ABI,
   COD_NDG,
   FLG_NDG,
   FLG_PORTAFOGLIO,
   FLG_NUOVO_INGRESSO,
   FLG_CMP_DRC,
   VAL_RIP_MORA,
   VAL_PER_CE,
   VAL_QUOTA_SVAL,
   VAL_QUOTA_ATT,
   VAL_RETT_SVAL,
   VAL_RIP_SVAL,
   VAL_RETT_ATT,
   VAL_RIP_ATT,
   VAL_ATTUALIZZAZIONE
)
AS
     SELECT 'RT' COD_SRC,
            SUBSTR (ID_DPER, 1, 4) || '03' ID_DPER,
            SUBSTR (ID_DPER, 1, 4) || '0331' DTA_COMPETENZA,
            COD_STATO_RISCHIO,
            des_stato_rischio,                                 --cod_presidio,
            COD_ABI,
            COD_NDG,
            CASE WHEN COD_NDG != '#' AND COD_NDG != '0' THEN 0 ELSE 1 END
               flg_ndg,
            flg_portafoglio,
            CASE
               WHEN TO_CHAR (DTA_INIZIO_STATO, 'YYYY') = SUBSTR (ID_DPER, 1, 4)
               THEN
                  1
               ELSE
                  0
            END
               flg_nuovo_ingresso,
            flg_cmp_drc,
            SUM (VAL_RIP_MORA) VAL_RIP_MORA,
            SUM (VAL_PER_CE) VAL_PER_CE,
            SUM (VAL_QUOTA_SVAL) VAL_QUOTA_SVAL,
            SUM (VAL_QUOTA_ATT) VAL_QUOTA_ATT,
            SUM (VAL_RETT_SVAL) VAL_RETT_SVAL,
            SUM (VAL_RIP_SVAL) VAL_RIP_SVAL,
            SUM (VAL_RETT_ATT) VAL_RETT_ATT,
            SUM (VAL_RIP_ATT) VAL_RIP_ATT,
            SUM (VAL_ATTUALIZZAZIONE) VAL_ATTUALIZZAZIONE
       FROM QZT_FT_MIS_MON_INC_SOF x
      WHERE     cod_src = 'RM'
            AND x.id_dper BETWEEN SUBSTR (ID_DPER, 1, 4) || '01'
                              AND SUBSTR (ID_DPER, 1, 4) || '03'
   GROUP BY SUBSTR (ID_DPER, 1, 4),
            COD_STATO_RISCHIO,
            des_stato_rischio,
            COD_ABI,
            COD_NDG,
            CASE WHEN COD_NDG != '#' AND COD_NDG != '0' THEN 0 ELSE 1 END,
            flg_portafoglio,
            CASE
               WHEN TO_CHAR (DTA_INIZIO_STATO, 'YYYY') =
                       SUBSTR (ID_DPER, 1, 4)
               THEN
                  1
               ELSE
                  0
            END,
            flg_cmp_drc
   UNION ALL
     SELECT 'RT' COD_SRC,
            SUBSTR (ID_DPER, 1, 4) || '06' ID_DPER,
            SUBSTR (ID_DPER, 1, 4) || '0630' DTA_COMPETENZA,
            COD_STATO_RISCHIO,
            des_stato_rischio,                                 --cod_presidio,
            COD_ABI,
            COD_NDG,
            CASE WHEN COD_NDG != '#' AND COD_NDG != '0' THEN 0 ELSE 1 END
               flg_ndg,
            flg_portafoglio,
            CASE
               WHEN TO_CHAR (DTA_INIZIO_STATO, 'YYYY') = SUBSTR (ID_DPER, 1, 4)
               THEN
                  1
               ELSE
                  0
            END
               flg_nuovo_ingresso,
            flg_cmp_drc,
            SUM (VAL_RIP_MORA) VAL_RIP_MORA,
            SUM (VAL_PER_CE) VAL_PER_CE,
            SUM (VAL_QUOTA_SVAL) VAL_QUOTA_SVAL,
            SUM (VAL_QUOTA_ATT) VAL_QUOTA_ATT,
            SUM (VAL_RETT_SVAL) VAL_RETT_SVAL,
            SUM (VAL_RIP_SVAL) VAL_RIP_SVAL,
            SUM (VAL_RETT_ATT) VAL_RETT_ATT,
            SUM (VAL_RIP_ATT) VAL_RIP_ATT,
            SUM (VAL_ATTUALIZZAZIONE) VAL_ATTUALIZZAZIONE
       FROM QZT_FT_MIS_MON_INC_SOF x
      WHERE     cod_src = 'RM'
            AND x.id_dper BETWEEN SUBSTR (ID_DPER, 1, 4) || '04'
                              AND SUBSTR (ID_DPER, 1, 4) || '06'
   GROUP BY SUBSTR (ID_DPER, 1, 4),
            COD_STATO_RISCHIO,
            des_stato_rischio,
            COD_ABI,
            COD_NDG,
            CASE WHEN COD_NDG != '#' AND COD_NDG != '0' THEN 0 ELSE 1 END,
            flg_portafoglio,
            CASE
               WHEN TO_CHAR (DTA_INIZIO_STATO, 'YYYY') =
                       SUBSTR (ID_DPER, 1, 4)
               THEN
                  1
               ELSE
                  0
            END,
            flg_cmp_drc
   UNION ALL
     SELECT 'RT' COD_SRC,
            SUBSTR (ID_DPER, 1, 4) || '09' ID_DPER,
            SUBSTR (ID_DPER, 1, 4) || '0930' DTA_COMPETENZA,
            COD_STATO_RISCHIO,
            des_stato_rischio,                                 --cod_presidio,
            COD_ABI,
            COD_NDG,
            CASE WHEN COD_NDG != '#' AND COD_NDG != '0' THEN 0 ELSE 1 END
               flg_ndg,
            flg_portafoglio,
            CASE
               WHEN TO_CHAR (DTA_INIZIO_STATO, 'YYYY') = SUBSTR (ID_DPER, 1, 4)
               THEN
                  1
               ELSE
                  0
            END
               flg_nuovo_ingresso,
            flg_cmp_drc,
            SUM (VAL_RIP_MORA) VAL_RIP_MORA,
            SUM (VAL_PER_CE) VAL_PER_CE,
            SUM (VAL_QUOTA_SVAL) VAL_QUOTA_SVAL,
            SUM (VAL_QUOTA_ATT) VAL_QUOTA_ATT,
            SUM (VAL_RETT_SVAL) VAL_RETT_SVAL,
            SUM (VAL_RIP_SVAL) VAL_RIP_SVAL,
            SUM (VAL_RETT_ATT) VAL_RETT_ATT,
            SUM (VAL_RIP_ATT) VAL_RIP_ATT,
            SUM (VAL_ATTUALIZZAZIONE) VAL_ATTUALIZZAZIONE
       FROM QZT_FT_MIS_MON_INC_SOF x
      WHERE     cod_src = 'RM'
            AND x.id_dper BETWEEN SUBSTR (ID_DPER, 1, 4) || '07'
                              AND SUBSTR (ID_DPER, 1, 4) || '09'
   GROUP BY SUBSTR (ID_DPER, 1, 4),
            COD_STATO_RISCHIO,
            des_stato_rischio,
            COD_ABI,
            COD_NDG,
            CASE WHEN COD_NDG != '#' AND COD_NDG != '0' THEN 0 ELSE 1 END,
            flg_portafoglio,
            CASE
               WHEN TO_CHAR (DTA_INIZIO_STATO, 'YYYY') =
                       SUBSTR (ID_DPER, 1, 4)
               THEN
                  1
               ELSE
                  0
            END,
            flg_cmp_drc
   UNION ALL
     SELECT 'RT' COD_SRC,
            SUBSTR (ID_DPER, 1, 4) || '12' ID_DPER,
            SUBSTR (ID_DPER, 1, 4) || '1231' DTA_COMPETENZA,
            COD_STATO_RISCHIO,
            des_stato_rischio,                                 --cod_presidio,
            COD_ABI,
            COD_NDG,
            CASE WHEN COD_NDG != '#' AND COD_NDG != '0' THEN 0 ELSE 1 END
               flg_ndg,
            flg_portafoglio,
            CASE
               WHEN TO_CHAR (DTA_INIZIO_STATO, 'YYYY') = SUBSTR (ID_DPER, 1, 4)
               THEN
                  1
               ELSE
                  0
            END
               flg_nuovo_ingresso,
            flg_cmp_drc,
            SUM (VAL_RIP_MORA) VAL_RIP_MORA,
            SUM (VAL_PER_CE) VAL_PER_CE,
            SUM (VAL_QUOTA_SVAL) VAL_QUOTA_SVAL,
            SUM (VAL_QUOTA_ATT) VAL_QUOTA_ATT,
            SUM (VAL_RETT_SVAL) VAL_RETT_SVAL,
            SUM (VAL_RIP_SVAL) VAL_RIP_SVAL,
            SUM (VAL_RETT_ATT) VAL_RETT_ATT,
            SUM (VAL_RIP_ATT) VAL_RIP_ATT,
            SUM (VAL_ATTUALIZZAZIONE) VAL_ATTUALIZZAZIONE
       FROM QZT_FT_MIS_MON_INC_SOF x
      WHERE     cod_src = 'RM'
            AND x.id_dper BETWEEN SUBSTR (ID_DPER, 1, 4) || '10'
                              AND SUBSTR (ID_DPER, 1, 4) || '12'
   GROUP BY SUBSTR (ID_DPER, 1, 4),
            COD_STATO_RISCHIO,
            des_stato_rischio,
            COD_ABI,
            COD_NDG,
            CASE WHEN COD_NDG != '#' AND COD_NDG != '0' THEN 0 ELSE 1 END,
            flg_portafoglio,
            CASE
               WHEN TO_CHAR (DTA_INIZIO_STATO, 'YYYY') =
                       SUBSTR (ID_DPER, 1, 4)
               THEN
                  1
               ELSE
                  0
            END,
            flg_cmp_drc;


GRANT DELETE, INSERT, REFERENCES, SELECT, UPDATE, ON COMMIT REFRESH, QUERY REWRITE, DEBUG, FLASHBACK, MERGE VIEW ON MCRE_OWN.QZV_ST_MIS_RT TO MCRE_USR;
