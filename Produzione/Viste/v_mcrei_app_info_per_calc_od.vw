/* Formatted on 17/06/2014 18:08:20 (QP5 v5.227.12220.39754) */
CREATE OR REPLACE FORCE VIEW MCRE_OWN.V_MCREI_APP_INFO_PER_CALC_OD
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
 -- 0808 AGGIUNTO RECUPERO NDG PER 01025 DA ALL_DATA NEL CASO NON CI SIA NEL PACCHETTO
 -- 1008 CAMNPO TASSO ESPOSTO NULL, IN ATTESA DI CHIARMENTI DEL VALORE CORRETTO DA ESPORRE
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
                     NVL (pcr0.gb_val_mau, 0))
                  ---30 MAGGIO: CORRETTO VALORE DEL MAU
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
         TO_NUMBER (NULL) AS val_tasso_base_appl
    -- de1.val_tasso_base_appl AS "TASSO"
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
                 pkg_mcrei_gest_delibere.fnc_mcrei_get_last_rinuncia (cod_abi,
                                                                      cod_ndg,
                                                                      'CT')
                    AS "IM_RIN_CONT",
                 pkg_mcrei_gest_delibere.fnc_mcrei_get_last_rinuncia (cod_abi,
                                                                      cod_ndg,
                                                                      'CO')
                    AS "IM_RIN_CONF",
                 pkg_mcrei_gest_delibere.fnc_mcrei_get_last_rinuncia (cod_abi,
                                                                      cod_ndg,
                                                                      'CM')
                    AS "IM_RIN_INS",
                 NVL (dta_scadenza, dta_scadenza_transaz) AS dta_scadenza,
                 val_tasso_base_appl                ---> in effetti e' un flag
            FROM t_mcrei_app_delibere
           WHERE     cod_fase_delibera NOT IN ('AN', 'VA')        --13Dicembre
                 AND flg_no_delibera = '0'
                 AND flg_attiva = 1
                 AND cod_protocollo_pacchetto =
                        SUBSTR (SYS_CONTEXT ('userenv', 'client_info'), 1, 30)
          UNION
          SELECT DISTINCT
                 '01025' AS cod_abi,
                 NVL (
                    (SELECT cod_ndg
                       FROM t_mcre0_app_all_data ad
                      WHERE     ad.cod_abi_cartolarizzato = '01025'
                            AND ad.cod_sndg = in_sel.cod_sndg
                            AND ROWNUM = 1),
                    '0000000000000000')
                    AS cod_ndg,
                 in_sel.cod_sndg,
                 '00000000000000000' cod_protocollo_delibera,
                 SUBSTR ( (SYS_CONTEXT ('userenv', 'client_info')), 1, 30)
                    cod_protocollo_pacchetto,
                 cod_microtipologia_delib,
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
            FROM (SELECT DISTINCT cod_microtipologia_delib, cod_sndg
                    FROM t_mcrei_app_delibere
                   WHERE     flg_attiva = '1'
                         AND cod_protocollo_pacchetto =
                                SUBSTR (
                                   (SYS_CONTEXT ('userenv', 'client_info')),
                                   1,
                                   30)) in_sel
           WHERE '01025' || cod_microtipologia_delib NOT IN
                    (SELECT cod_abi || cod_microtipologia_delib
                       FROM t_mcrei_app_delibere
                      WHERE     cod_abi = '01025'
                            AND flg_attiva = '1'
                            AND cod_protocollo_pacchetto =
                                   SUBSTR (
                                      (SYS_CONTEXT ('userenv', 'client_info')),
                                      1,
                                      30))) de1,
         t_mcre0_app_pcr pcr0
   WHERE     de1.cod_abi = pcr0.cod_abi_cartolarizzato(+)
         AND de1.cod_ndg = pcr0.cod_ndg(+);


GRANT DELETE, INSERT, REFERENCES, SELECT, UPDATE, ON COMMIT REFRESH, QUERY REWRITE, DEBUG, FLASHBACK, MERGE VIEW ON MCRE_OWN.V_MCREI_APP_INFO_PER_CALC_OD TO MCRE_USR;
