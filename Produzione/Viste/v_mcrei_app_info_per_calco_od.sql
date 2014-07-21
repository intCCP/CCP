/* Formatted on 17/06/2014 18:08:21 (QP5 v5.227.12220.39754) */
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
          de1.cod_abi AS "ABI_SETT",
          NVL (de1.cod_ndg, '0000000000000000') AS "NSG_SET",
          NVL (de1.cod_sndg, '0000000000000000') AS "SNDG",
          NVL (de1.cod_protocollo_delibera, '00000000000000000')
             AS "COD_DELIB",
          de1.cod_protocollo_pacchetto AS "COD_PAC",
          de1.cod_microtipologia_delib AS "COD_TIP",
          NULL AS filiera,
          NVL (
             CASE
                WHEN de1.cod_abi = '01025'
                THEN
                   SUM (
                      NVL (de1.val_rdv_max_1025, 0) * fase_delibera_co)
                   OVER (
                      PARTITION BY de1.cod_abi,
                                   de1.cod_ndg,
                                   de1.cod_protocollo_delibera)
                ELSE
                   SUM (NVL (de1.val_rdv_max_nn1025, 0) * fase_delibera_co)
                      OVER (PARTITION BY de1.cod_abi, de1.cod_ndg --                                        DE1.COD_PROTOCOLLO_PACCHETTO,
        --                                        DE1.COD_MICROTIPOLOGIA_DELIB
                      )
             END,
             0)
             AS im_ret_conf,
          pcr.scsb_uti_cassa AS im_utilizzo,
          NVL (
             CASE
                WHEN de1.cod_abi = '01025'
                THEN
                   SUM ( (NVL (de1.val_rdv_max_1025, 0)) * fase_delibera_in)
                      OVER (PARTITION BY de1.cod_protocollo_pacchetto --                                        DE1.COD_MICROTIPOLOGIA_DELIB
                                                                     )
                ELSE
                   SUM (
                      NVL (de1.val_rdv_max_nn1025, 0) * fase_delibera_in)
                   OVER (
                      PARTITION BY de1.cod_abi,
                                   de1.cod_ndg,
                                   de1.cod_protocollo_pacchetto --                                        DE1.COD_MICROTIPOLOGIA_DELIB
                                                               )
             END,
             0)
             AS "IM_RET_INS",
          NVL (
             CASE
                WHEN de1.cod_abi = '01025' AND de1.cod_fase_delibera = 'CT'
                THEN
                   SUM (
                      NVL (de1.val_sacrif_capit_mora, 0))
                   OVER (
                      PARTITION BY de1.cod_protocollo_pacchetto,
                                   de1.cod_microtipologia_delib)
                WHEN de1.cod_abi <> '01025' AND de1.cod_fase_delibera = 'CT'
                THEN
                   SUM (
                      NVL (de1.val_sacrif_capit_mora, 0))
                   OVER (
                      PARTITION BY de1.cod_abi,
                                   de1.cod_ndg,
                                   de1.cod_protocollo_pacchetto,
                                   de1.cod_microtipologia_delib)
                ELSE
                   0
             END,
             0)
             AS "IM_RIN_CONT_OK",
          NVL (
             CASE
                WHEN de1.cod_abi = '01025'
                THEN
                   SUM (
                      NVL (de1.val_sacrif_capit_mora, 0) * fase_delibera_ct)
                   OVER (PARTITION BY NULL)
                ELSE
                   SUM (
                      NVL (de1.val_sacrif_capit_mora, 0) * fase_delibera_ct)
                   OVER (PARTITION BY de1.cod_abi, de1.cod_ndg --                                        DE1.COD_PROTOCOLLO_PACCHETTO,
        --                                        DE1.COD_MICROTIPOLOGIA_DELIB
                   )
             END,
             0)
             AS "IM_RIN_CONT",
          NVL (
             CASE
                WHEN de1.cod_abi = '01025'
                THEN
                   SUM (
                      NVL (de1.val_sacrif_capit_mora, 0) * fase_delibera_co)
                   OVER (PARTITION BY NULL)
                ELSE
                   SUM (
                      NVL (de1.val_sacrif_capit_mora, 0) * fase_delibera_co)
                   OVER (PARTITION BY de1.cod_abi, de1.cod_ndg --                                        DE1.COD_PROTOCOLLO_PACCHETTO,
        --                                        DE1.COD_MICROTIPOLOGIA_DELIB
                   )
             END,
             0)
             AS "IM_RIN_CONF",
          NVL (
             CASE
                WHEN de1.cod_abi = '01025'
                THEN
                   SUM (
                      NVL (de1.val_sacrif_capit_mora, 0) * fase_delibera_in)
                   OVER (
                      PARTITION BY de1.cod_protocollo_pacchetto,
                                   de1.cod_microtipologia_delib)
                ELSE
                   SUM (
                      NVL (de1.val_sacrif_capit_mora, 0) * fase_delibera_in)
                   OVER (
                      PARTITION BY de1.cod_abi,
                                   de1.cod_ndg,
                                   de1.cod_protocollo_pacchetto,
                                   de1.cod_microtipologia_delib)
             END,
             0)
             AS "IM_RIN_INS",
          0 AS "IM-LMT-GEST",
          NVL (pcr.gegb_mau,                             --               CASE
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
             WHEN de1.cod_abi = '01025'
             THEN
                MAX (
                   de1.dta_scadenza)
                OVER (
                   PARTITION BY de1.cod_protocollo_pacchetto,
                                de1.cod_microtipologia_delib)
             ELSE
                MAX (
                   de1.dta_scadenza)
                OVER (
                   PARTITION BY de1.cod_abi,
                                de1.cod_ndg,
                                de1.cod_protocollo_pacchetto,
                                de1.cod_microtipologia_delib)
          END
             AS "IM_DT_SCA",
          de1.val_tasso_base_appl AS "TASSO"
     FROM (SELECT d1.cod_abi,
                  d1.cod_ndg,
                  d1.cod_protocollo_delibera,
                  d1.cod_sndg,
                  d1.cod_protocollo_pacchetto,
                  d1.cod_microtipologia_delib,
                  d1.dta_scadenza,
                  d.cod_fase_delibera,
                  d.val_sacrif_capit_mora,
                  d.val_tasso_base_appl,
                  d.val_rdv_qc_progressiva,
                  CASE WHEN d.cod_fase_delibera = 'CT' THEN 1 ELSE 0 END
                     AS fase_delibera_ct,
                  CASE WHEN d.cod_fase_delibera = 'CO' THEN 1 ELSE 0 END
                     AS fase_delibera_co,
                  CASE WHEN d.cod_fase_delibera = 'IN' THEN 1 ELSE 0 END
                     AS fase_delibera_in,
                  CASE
                     WHEN NVL (d1.dta_last_upd_delibera, d1.dta_ins_delibera) =
                             d1.dta_last_delib_1025
                     THEN
                        d1.val_rdv_qc_progressiva
                     ELSE
                        0
                  END
                     AS val_rdv_max_1025,
                  CASE
                     WHEN NVL (d1.dta_last_upd_delibera, d1.dta_ins_delibera) =
                             d1.dta_last_delib_nn1025
                     THEN
                        d1.val_rdv_qc_progressiva
                     ELSE
                        0
                  END
                     AS val_rdv_max_nn1025
             FROM (SELECT DISTINCT
                          cod_abi,
                          cod_ndg,
                          cod_protocollo_delibera,
                          cod_sndg,
                          cod_protocollo_pacchetto,
                          cod_microtipologia_delib,
                          dta_scadenza,
                          dta_last_upd_delibera,
                          dta_ins_delibera,
                          MAX (
                             NVL (dta_last_upd_delibera, dta_ins_delibera))
                          OVER (
                             PARTITION BY cod_protocollo_pacchetto,
                                          cod_microtipologia_delib)
                             AS dta_last_delib_1025,
                          MAX (
                             NVL (dta_last_upd_delibera, dta_ins_delibera))
                          OVER (
                             PARTITION BY cod_abi,
                                          cod_ndg,
                                          cod_protocollo_pacchetto,
                                          cod_microtipologia_delib)
                             AS dta_last_delib_nn1025,
                          val_rdv_qc_progressiva
                     FROM t_mcrei_app_delibere
                    WHERE     cod_fase_delibera NOT IN ('AN', 'VA', 'AS')
                          AND flg_no_delibera = '0'                    --13dic
                   UNION
                   SELECT DISTINCT
                          '01025' cod_abi,
                          NULL cod_ndg,
                          NULL cod_protocollo_delibera,
                          NULL cod_sndg,
                          cod_protocollo_pacchetto,
                          cod_microtipologia_delib,
                          TO_DATE (NULL, 'yyyqymmdd') dta_scadenza,
                          dta_last_upd_delibera,
                          dta_ins_delibera,
                          MAX (
                             NVL (dta_last_upd_delibera, dta_ins_delibera))
                          OVER (
                             PARTITION BY cod_protocollo_pacchetto,
                                          cod_microtipologia_delib)
                             AS dta_last_delib_1025,
                          MAX (
                             NVL (dta_last_upd_delibera, dta_ins_delibera))
                          OVER (
                             PARTITION BY cod_abi,
                                          cod_ndg,
                                          cod_protocollo_pacchetto,
                                          cod_microtipologia_delib)
                             AS dta_last_delib_nn1025,
                          val_rdv_qc_progressiva
                     FROM t_mcrei_app_delibere
                    WHERE    cod_protocollo_pacchetto
                          || cod_microtipologia_delib NOT IN
                             (SELECT    cod_protocollo_pacchetto
                                     || cod_microtipologia_delib
                                FROM t_mcrei_app_delibere
                               WHERE     cod_abi = '01025'
                                     AND cod_fase_delibera NOT IN
                                            ('AN', 'VA', 'AS')
                                     --13dic
                                     AND flg_no_delibera = '0')) d1,
                  t_mcrei_app_delibere d
            WHERE     d1.cod_abi = d.cod_abi(+)
                  AND d1.cod_ndg = d.cod_ndg(+)
                  AND d1.cod_protocollo_delibera =
                         d.cod_protocollo_delibera(+)
                  AND d.flg_no_delibera = '0') de1,
          t_mcre0_app_pcr pcr
    WHERE /*DA ESEGUIRE PRIMA DELLA CHIAMATA ALLA VISTA
                    BEGIN dbms_application_info.set_client_info( COD_PROTOCOLLO_PACCHETTO); END;*/
         de1  .cod_abi = pcr.cod_abi_cartolarizzato(+)
          AND de1.cod_ndg = pcr.cod_ndg(+)
          AND de1.cod_protocollo_pacchetto =
                 SUBSTR ( (SYS_CONTEXT ('userenv', 'client_info')), 1, 30);


GRANT DELETE, INSERT, REFERENCES, SELECT, UPDATE, ON COMMIT REFRESH, QUERY REWRITE, DEBUG, FLASHBACK, MERGE VIEW ON MCRE_OWN.V_MCREI_APP_INFO_PER_CALCO_OD TO MCRE_USR;
