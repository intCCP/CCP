/* Formatted on 21/07/2014 18:40:23 (QP5 v5.227.12220.39754) */
CREATE OR REPLACE FORCE VIEW MCRE_OWN.V_MCREI_APP_INFO_PER_CALCO_OD
(
   ABI_SETT,
   NSG_SET,
   SNDG,
   COD_DELIB,
   COD_PAC,
   COD_TIP,
   FILIERA,
   IM_RET_CONF,
   IM_UTILIZZO,
   IM_RET_INS,
   IM_RIN_CONT_OK,
   IM_RIN_CONT,
   IM_RIN_CONF,
   IM_RIN_INS,
   "IM-LMT-GEST",
   "TOT IM-LMT-GEST",
   IM_DT_SCA,
   TASSO
)
AS
   SELECT DISTINCT
          DE1.COD_ABI AS "ABI_SETT",
          NVL (DE1.COD_NDG, '0000000000000000') AS "NSG_SET",
          NVL (DE1.COD_SNDG, '0000000000000000') AS "SNDG",
          NVL (DE1.COD_PROTOCOLLO_DELIBERA, '00000000000000000')
             AS "COD_DELIB",
          DE1.COD_PROTOCOLLO_PACCHETTO AS "COD_PAC",
          DE1.COD_MICROTIPOLOGIA_DELIB AS "COD_TIP",
          NULL AS FILIERA,
          NVL (
             CASE
                WHEN DE1.COD_ABI = '01025'
                THEN
                   SUM (
                      NVL (DE1.VAL_RDV_MAX_1025, 0) * FASE_DELIBERA_CO)
                   OVER (
                      PARTITION BY DE1.COD_ABI,
                                   DE1.COD_NDG,
                                   DE1.COD_PROTOCOLLO_DELIBERA)
                ELSE
                   SUM (NVL (DE1.VAL_RDV_MAX_NN1025, 0) * FASE_DELIBERA_CO)
                      OVER (PARTITION BY DE1.COD_ABI, DE1.COD_NDG --                                        DE1.COD_PROTOCOLLO_PACCHETTO,
                                                                 --                                        DE1.COD_MICROTIPOLOGIA_DELIB
                      )
             END,
             0)
             AS IM_RET_CONF,
          PCR.SCSB_UTI_cassa AS IM_UTILIZZO,
          NVL (
             CASE
                WHEN DE1.COD_ABI = '01025'
                THEN
                   SUM ( (NVL (DE1.VAL_RDV_MAX_1025, 0)) * FASE_DELIBERA_IN)
                      OVER (PARTITION BY DE1.COD_PROTOCOLLO_PACCHETTO --                                        DE1.COD_MICROTIPOLOGIA_DELIB
                                                                     )
                ELSE
                   SUM (
                      NVL (DE1.VAL_RDV_MAX_NN1025, 0) * FASE_DELIBERA_IN)
                   OVER (
                      PARTITION BY DE1.COD_ABI,
                                   DE1.COD_NDG,
                                   DE1.COD_PROTOCOLLO_PACCHETTO --                                        DE1.COD_MICROTIPOLOGIA_DELIB
                                                               )
             END,
             0)
             AS "IM_RET_INS",
          NVL (
             CASE
                WHEN DE1.COD_ABI = '01025' AND DE1.COD_FASE_DELIBERA = 'CT'
                THEN
                   SUM (
                      NVL (DE1.VAL_SACRIF_CAPIT_MORA, 0))
                   OVER (
                      PARTITION BY DE1.COD_PROTOCOLLO_PACCHETTO,
                                   DE1.COD_MICROTIPOLOGIA_DELIB)
                WHEN DE1.COD_ABI <> '01025' AND DE1.COD_FASE_DELIBERA = 'CT'
                THEN
                   SUM (
                      NVL (DE1.VAL_SACRIF_CAPIT_MORA, 0))
                   OVER (
                      PARTITION BY DE1.COD_ABI,
                                   DE1.COD_NDG,
                                   DE1.COD_PROTOCOLLO_PACCHETTO,
                                   DE1.COD_MICROTIPOLOGIA_DELIB)
                ELSE
                   0
             END,
             0)
             AS "IM_RIN_CONT_OK",
          NVL (
             CASE
                WHEN DE1.COD_ABI = '01025'
                THEN
                   SUM (
                      NVL (DE1.VAL_SACRIF_CAPIT_MORA, 0) * FASE_DELIBERA_CT)
                   OVER (PARTITION BY NULL)
                ELSE
                   SUM (
                      NVL (DE1.VAL_SACRIF_CAPIT_MORA, 0) * FASE_DELIBERA_CT)
                   OVER (PARTITION BY DE1.COD_ABI, DE1.COD_NDG --                                        DE1.COD_PROTOCOLLO_PACCHETTO,
                                                              --                                        DE1.COD_MICROTIPOLOGIA_DELIB
                   )
             END,
             0)
             AS "IM_RIN_CONT",
          NVL (
             CASE
                WHEN DE1.COD_ABI = '01025'
                THEN
                   SUM (
                      NVL (DE1.VAL_SACRIF_CAPIT_MORA, 0) * FASE_DELIBERA_CO)
                   OVER (PARTITION BY NULL)
                ELSE
                   SUM (
                      NVL (DE1.VAL_SACRIF_CAPIT_MORA, 0) * FASE_DELIBERA_CO)
                   OVER (PARTITION BY DE1.COD_ABI, DE1.COD_NDG --                                        DE1.COD_PROTOCOLLO_PACCHETTO,
                                                              --                                        DE1.COD_MICROTIPOLOGIA_DELIB
                   )
             END,
             0)
             AS "IM_RIN_CONF",
          NVL (
             CASE
                WHEN DE1.COD_ABI = '01025'
                THEN
                   SUM (
                      NVL (DE1.VAL_SACRIF_CAPIT_MORA, 0) * FASE_DELIBERA_IN)
                   OVER (
                      PARTITION BY DE1.COD_PROTOCOLLO_PACCHETTO,
                                   DE1.COD_MICROTIPOLOGIA_DELIB)
                ELSE
                   SUM (
                      NVL (DE1.VAL_SACRIF_CAPIT_MORA, 0) * FASE_DELIBERA_IN)
                   OVER (
                      PARTITION BY DE1.COD_ABI,
                                   DE1.COD_NDG,
                                   DE1.COD_PROTOCOLLO_PACCHETTO,
                                   DE1.COD_MICROTIPOLOGIA_DELIB)
             END,
             0)
             AS "IM_RIN_INS",
          0 AS "IM-LMT-GEST",
          NVL (PCR.GEGB_MAU,                             --               CASE
                             --                  WHEN DE1.COD_ABI = '01025'
                             --                  THEN
                             --                     SUM(NVL (PCR.GEGB_MAU, 0))
                             --                        OVER (
                             --                           PARTITION BY DE1.COD_PROTOCOLLO_PACCHETTO,
                             --                                        DE1.COD_MICROTIPOLOGIA_DELIB
                             --                        )
                             --                  ELSE
                             --                     SUM(NVL (PCR.GEGB_MAU, 0))
                             --                        OVER (
                             --                           PARTITION BY DE1.COD_ABI,
                             --                                        DE1.COD_NDG,
                             --                                        DE1.COD_PROTOCOLLO_PACCHETTO,
                             --                                        DE1.COD_MICROTIPOLOGIA_DELIB
                             --                        )
                             --               END,
                             0) AS "TOT IM-LMT-GEST",
          CASE
             WHEN DE1.COD_ABI = '01025'
             THEN
                MAX (
                   DE1.DTA_SCADENZA)
                OVER (
                   PARTITION BY DE1.COD_PROTOCOLLO_PACCHETTO,
                                DE1.COD_MICROTIPOLOGIA_DELIB)
             ELSE
                MAX (
                   DE1.DTA_SCADENZA)
                OVER (
                   PARTITION BY DE1.COD_ABI,
                                DE1.COD_NDG,
                                DE1.COD_PROTOCOLLO_PACCHETTO,
                                DE1.COD_MICROTIPOLOGIA_DELIB)
          END
             AS "IM_DT_SCA",
          DE1.VAL_TASSO_BASE_APPL AS "TASSO"
     FROM (SELECT D1.COD_ABI,
                  D1.COD_NDG,
                  D1.COD_PROTOCOLLO_DELIBERA,
                  D1.COD_SNDG,
                  D1.COD_PROTOCOLLO_PACCHETTO,
                  D1.COD_MICROTIPOLOGIA_DELIB,
                  D1.DTA_SCADENZA,
                  D.COD_FASE_DELIBERA,
                  D.VAL_SACRIF_CAPIT_MORA,
                  D.VAL_TASSO_BASE_APPL,
                  D.VAL_RDV_QC_PROGRESSIVA,
                  CASE WHEN D.COD_FASE_DELIBERA = 'CT' THEN 1 ELSE 0 END
                     AS FASE_DELIBERA_CT,
                  CASE WHEN D.COD_FASE_DELIBERA = 'CO' THEN 1 ELSE 0 END
                     AS FASE_DELIBERA_CO,
                  CASE WHEN D.COD_FASE_DELIBERA = 'IN' THEN 1 ELSE 0 END
                     AS FASE_DELIBERA_IN,
                  CASE
                     WHEN NVL (D1.DTA_LAST_UPD_DELIBERA, D1.DTA_INS_DELIBERA) =
                             D1.DTA_LAST_DELIB_1025
                     THEN
                        D1.VAL_RDV_QC_PROGRESSIVA
                     ELSE
                        0
                  END
                     AS VAL_RDV_MAX_1025,
                  CASE
                     WHEN NVL (D1.DTA_LAST_UPD_DELIBERA, D1.DTA_INS_DELIBERA) =
                             D1.DTA_LAST_DELIB_NN1025
                     THEN
                        D1.VAL_RDV_QC_PROGRESSIVA
                     ELSE
                        0
                  END
                     AS VAL_RDV_MAX_NN1025
             FROM (SELECT DISTINCT
                          COD_ABI,
                          COD_NDG,
                          COD_PROTOCOLLO_DELIBERA,
                          COD_SNDG,
                          COD_PROTOCOLLO_PACCHETTO,
                          COD_MICROTIPOLOGIA_DELIB,
                          DTA_SCADENZA,
                          DTA_LAST_UPD_DELIBERA,
                          DTA_INS_DELIBERA,
                          MAX (
                             NVL (DTA_LAST_UPD_DELIBERA, DTA_INS_DELIBERA))
                          OVER (
                             PARTITION BY COD_PROTOCOLLO_PACCHETTO,
                                          COD_MICROTIPOLOGIA_DELIB)
                             AS DTA_LAST_DELIB_1025,
                          MAX (
                             NVL (DTA_LAST_UPD_DELIBERA, DTA_INS_DELIBERA))
                          OVER (
                             PARTITION BY COD_ABI,
                                          COD_NDG,
                                          COD_PROTOCOLLO_PACCHETTO,
                                          COD_MICROTIPOLOGIA_DELIB)
                             AS DTA_LAST_DELIB_NN1025,
                          VAL_RDV_QC_PROGRESSIVA
                     FROM T_MCREI_APP_DELIBERE
                    WHERE     COD_FASE_DELIBERA NOT IN ('AN', 'VA', 'AS')
                          AND FLG_NO_DELIBERA = '0'                    --13dic
                   UNION
                   SELECT DISTINCT
                          '01025' COD_ABI,
                          NULL COD_NDG,
                          NULL COD_PROTOCOLLO_DELIBERA,
                          NULL COD_SNDG,
                          COD_PROTOCOLLO_PACCHETTO,
                          COD_MICROTIPOLOGIA_DELIB,
                          TO_DATE (NULL, 'yyyqymmdd') DTA_SCADENZA,
                          DTA_LAST_UPD_DELIBERA,
                          DTA_INS_DELIBERA,
                          MAX (
                             NVL (DTA_LAST_UPD_DELIBERA, DTA_INS_DELIBERA))
                          OVER (
                             PARTITION BY COD_PROTOCOLLO_PACCHETTO,
                                          COD_MICROTIPOLOGIA_DELIB)
                             AS DTA_LAST_DELIB_1025,
                          MAX (
                             NVL (DTA_LAST_UPD_DELIBERA, DTA_INS_DELIBERA))
                          OVER (
                             PARTITION BY COD_ABI,
                                          COD_NDG,
                                          COD_PROTOCOLLO_PACCHETTO,
                                          COD_MICROTIPOLOGIA_DELIB)
                             AS DTA_LAST_DELIB_NN1025,
                          VAL_RDV_QC_PROGRESSIVA
                     FROM T_MCREI_APP_DELIBERE
                    WHERE    COD_PROTOCOLLO_PACCHETTO
                          || COD_MICROTIPOLOGIA_DELIB NOT IN
                             (SELECT    COD_PROTOCOLLO_PACCHETTO
                                     || COD_MICROTIPOLOGIA_DELIB
                                FROM T_MCREI_APP_DELIBERE
                               WHERE     COD_ABI = '01025'
                                     AND COD_FASE_DELIBERA NOT IN
                                            ('AN', 'VA', 'AS')         --13dic
                                     AND FLG_NO_DELIBERA = '0')) D1,
                  T_MCREI_APP_DELIBERE D
            WHERE     D1.COD_ABI = D.COD_ABI(+)
                  AND D1.COD_NDG = D.COD_NDG(+)
                  AND D1.COD_PROTOCOLLO_DELIBERA =
                         D.COD_PROTOCOLLO_DELIBERA(+)
                  AND D.FLG_NO_DELIBERA = '0') DE1,
          T_MCRE0_APP_PCR PCR
    WHERE /*DA ESEGUIRE PRIMA DELLA CHIAMATA ALLA VISTA
                    BEGIN dbms_application_info.set_client_info( COD_PROTOCOLLO_PACCHETTO); END;*/
         DE1  .COD_ABI = PCR.COD_ABI_CARTOLARIZZATO(+)
          AND DE1.COD_NDG = PCR.COD_NDG(+)
          AND DE1.COD_PROTOCOLLO_PACCHETTO =
                 SUBSTR ( (SYS_CONTEXT ('userenv', 'client_info')), 1, 30);
