/* Formatted on 21/07/2014 18:39:08 (QP5 v5.227.12220.39754) */
CREATE OR REPLACE FORCE VIEW MCRE_OWN.V_MCREI_APP_CALC_OD_1
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
   IM_RIN_CONT,
   IM_RIN_CONF,
   IM_RIN_INS,
   IM_LMT_GEST,
   TOT_IM_LMT_GEST,
   IM_DT_SCA,
   TASSO
)
AS
   SELECT /*DA ESEGUIRE PRIMA DELLA CHIAMATA ALLA VISTA:
                       BEGIN dbms_application_info.set_client_info( COD_PROTOCOLLO_PACCHETTO); END;*/
         de1.cod_abi AS "ABI_SETT",
          de1.cod_ndg AS "NSG_SET",
          NVL (de1.cod_sndg, pcr0.cod_sndg) AS "SNDG",
          de1.cod_protocollo_delibera AS "COD_DELIB",
          de1.cod_protocollo_pacchetto AS "COD_PAC",
          de1.cod_microtipologia_delib AS "COD_TIP",
          TO_CHAR (NULL) AS "FILIERA",
          de1.im_ret_conf AS "IM_RET_CONF",
          pkg_mcrei_gest_delibere.fnc_mcrei_get_sum_utilizzati (
             de1.cod_abi,
             de1.cod_ndg,
             SUBSTR ( (SYS_CONTEXT ('userenv', 'client_info')), 1, 30))
             AS im_utilizzo,
          de1.im_ret_ins AS "IM_RET_INS",
          de1.im_rin_cont AS "IM_RIN_CONT",
          de1.im_rin_conf AS "IM_RIN_CONF",
          de1.im_rin_ins AS "IM_RIN_INS",
          pcr0.gb_val_mau AS "IM_LMT_GEST",
          NVL (
             CASE
                WHEN de1.cod_abi = '01025'
                THEN
                   SUM (
                      NVL (pcr0.gb_val_mau, 0))
                   OVER (
                      PARTITION BY de1.cod_protocollo_pacchetto,
                                   de1.cod_microtipologia_delib)
                ELSE
                   SUM (
                      NVL (pcr0.gb_val_mau, 0)) ---30 MAGGIO: CORRETTO VALORE DEL MAU
                   OVER (
                      PARTITION BY de1.cod_abi,
                                   de1.cod_ndg,
                                   de1.cod_protocollo_pacchetto,
                                   de1.cod_microtipologia_delib)
             END,
             0)
             AS "TOT_IM_LMT_GEST",
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
     FROM (SELECT DISTINCT
                  cod_abi,
                  cod_ndg,
                  cod_sndg,
                  cod_protocollo_delibera,
                  cod_protocollo_pacchetto,
                  cod_microtipologia_delib,
                  pkg_mcrei_gest_delibere.fnc_mcrei_get_max_rdv (
                     cod_abi,
                     cod_ndg,
                     'CO',
                     SUBSTR (SYS_CONTEXT ('userenv', 'client_info'),
                             1,
                             30))
                     AS "IM_RET_CONF",
                  pkg_mcrei_gest_delibere.fnc_mcrei_get_max_rdv (
                     cod_abi,
                     cod_ndg,
                     'CM',
                     SUBSTR (SYS_CONTEXT ('userenv', 'client_info'),
                             1,
                             30))
                     AS "IM_RET_INS",
                  pkg_mcrei_gest_delibere.fnc_mcrei_get_last_rinuncia (
                     cod_abi,
                     cod_ndg,
                     'CT')
                     AS "IM_RIN_CONT",
                  pkg_mcrei_gest_delibere.fnc_mcrei_get_last_rinuncia (
                     cod_abi,
                     cod_ndg,
                     'CO')
                     AS "IM_RIN_CONF",
                  pkg_mcrei_gest_delibere.fnc_mcrei_get_last_rinuncia (
                     cod_abi,
                     cod_ndg,
                     'CM')
                     AS "IM_RIN_INS",
                  NVL (dta_scadenza, DTA_SCADENZA_TRANSAZ) AS DTA_SCADENZA,
                  val_tasso_base_appl               ---> in effetti e' un flag
             FROM t_mcrei_app_delibere
            WHERE     cod_fase_delibera <> 'AN'
                  AND flg_no_delibera = '0'
                  AND flg_attiva = 1
                  AND cod_protocollo_pacchetto =
                         SUBSTR (SYS_CONTEXT ('userenv', 'client_info'),
                                 1,
                                 30)
           UNION
           SELECT DISTINCT
                  '01025' AS COD_ABI,
                  NVL (
                     (SELECT COD_NDG
                        FROM (  SELECT COD_NDG AS COD_NDG
                                  FROM T_MCRE0_APP_ALL_DATA AD
                                 WHERE     AD.COD_ABI_CARTOLARIZZATO = '01025'
                                       AND AD.COD_SNDG = D1.COD_SNDG
                              ORDER BY FLG_ACTIVE DESC)
                       WHERE ROWNUM = 1),
                     '0000000000000000')
                     AS COD_NDG,
                  D1.cod_sndg,
                  D1.cod_protocollo_delibera,
                  D1.cod_protocollo_pacchetto,
                  D1.cod_microtipologia_delib,
                  pkg_mcrei_gest_delibere.fnc_mcrei_get_max_rdv (
                     '01025',
                     NULL,
                     'CO',
                     SUBSTR (SYS_CONTEXT ('userenv', 'client_info'), 1, 30))
                     AS "IM_RET_CONF",
                  pkg_mcrei_gest_delibere.fnc_mcrei_get_max_rdv (
                     '01025',
                     NULL,
                     'CM',
                     SUBSTR (SYS_CONTEXT ('userenv', 'client_info'), 1, 30))
                     AS "IM_RET_INS",
                  pkg_mcrei_gest_delibere.fnc_mcrei_get_sum_rin (
                     '01025',
                     NULL,
                     'CT',
                     SUBSTR (SYS_CONTEXT ('userenv', 'client_info'), 1, 30))
                     AS "IM_RIN_CONT",
                  pkg_mcrei_gest_delibere.fnc_mcrei_get_sum_rin (
                     '01025',
                     NULL,
                     'CO',
                     SUBSTR (SYS_CONTEXT ('userenv', 'client_info'), 1, 30))
                     AS "IM_RIN_CONF",
                  pkg_mcrei_gest_delibere.fnc_mcrei_get_sum_rin (
                     '01025',
                     NULL,
                     'CM',
                     SUBSTR (SYS_CONTEXT ('userenv', 'client_info'), 1, 30))
                     AS "IM_RIN_INS",
                  TO_DATE (NULL, 'YYYYMMDD') AS "IM_DT_SCA",
                  TO_CHAR (NULL) AS val_tasso_base_appl
             FROM t_mcrei_app_delibere D1, t_mcrei_app_delibere D2
            WHERE     D1.cod_fase_delibera <> 'AN'
                  AND D1.flg_no_delibera = '0'
                  AND D1.flg_attiva = 1
                  AND D1.cod_protocollo_pacchetto =
                         SUBSTR (SYS_CONTEXT ('userenv', 'client_info'),
                                 1,
                                 30)
                  AND D1.COD_ABI = D2.COD_ABI(+)
                  AND D1.COD_NDG = D2.COD_NDG(+)
                  AND D1.COD_PROTOCOLLO_PACCHETTO =
                         D2.COD_PROTOCOLLO_PACCHETTO(+)
                  AND D2.COD_ABI(+) = '01025'
                  AND D2.FLG_ATTIVA(+) = '1'
                  AND D2.COD_ABI IS NULL) de1,
          t_mcre0_app_pcr pcr0
    WHERE     de1.cod_abi = pcr0.cod_abi_cartolarizzato(+)
          AND de1.cod_ndg = pcr0.cod_ndg(+);
