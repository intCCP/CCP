/* Formatted on 21/07/2014 18:38:47 (QP5 v5.227.12220.39754) */
CREATE OR REPLACE FORCE VIEW MCRE_OWN.V_MCRE0_WRK_RAPP_DA_VAL_POS_OP
(
   COD_STATO,
   COD_ABI,
   COD_NDG,
   COD_SNDG,
   COD_PROTOCOLLO_DELIBERA,
   VAL_CNT_RAPPORTI,
   VAL_ALERT,
   VAL_CNT_DELIBERE,
   FLG_ACC
)
AS
   SELECT cod_stato,
          cod_abi_cartolarizzato cod_abi,
          cod_ndg,
          cod_sndg,
          SUBSTR (concs, 39, 17) AS cod_protocollo_delibera,
          TO_NUMBER (SUBSTR (concs, 56)) val_cnt_rapporti,
          'R' AS val_alert,
          1 AS val_cnt_delibere,
          DECODE (concs, TO_CHAR (NULL), 0, 1) AS flg_acc
     FROM (SELECT uf.cod_stato,
                  uf.cod_abi_cartolarizzato,
                  uf.cod_ndg,
                  uf.cod_sndg,
                  (SELECT DISTINCT conc_int
                     FROM (SELECT -- 04.10.2012 V3 - AGGIUNTA EXISTS SULLE STIME, DA OTTIMIZZARE SE POSSIBILE
 -- 04.10.2012 V4 - RICOSTRUITA LOGICA CON JOIN SENZA T_MCRE0_APP_ALL_DATA, COD_STATO S SEMPRE A NULL
                                     -- 12.10.2012 V4.1 - AGGIUNTE STIME EXTRA
 -- 15.10.2012   V.4.2 TOLTE STIME EXTRA -- LA PAGINA DI EXTRA DELIBERA NON COMPORTA LA SCRITTURA NELLA STIME EXTRA
                                             -- CREATA VISTA V_MCREI_MAX_STIME
                                 DISTINCT
                                    DECODE (
                                       COUNT (DECODE (cod_natura, '02', 1))
                                       OVER (PARTITION BY pr.cod_abi, pr.cod_ndg),
                                       0, 1)
                                 || pr.cod_abi
                                 || pr.cod_ndg
                                 || pr.cod_sndg
                                 || pr.cod_protocollo_delibera
                                 || TO_CHAR (
                                       COUNT (pr.cod_rapporto)
                                       OVER (PARTITION BY pr.cod_abi, pr.cod_ndg))
                                    conc_int,
                                 pr.cod_abi,
                                 pr.cod_ndg,
                                 cod_natura
                            FROM (SELECT DISTINCT
                                         ppcr.cod_abi,
                                         ppcr.cod_ndg,
                                         ppcr.cod_sndg,
                                         ppcr.cod_rapporto,
                                         ppcr.cod_protocollo_delibera,
                                         cod_natura
                                    --count(decode(cod_natura,'02',1)) OVER (PARTITION BY ppcr.cod_abi, ppcr.cod_ndg) as count_rientri
                                    FROM (SELECT DISTINCT
                                                 pcr.cod_abi,
                                                 pcr.cod_ndg,
                                                 pcr.cod_sndg,
                                                 pcr.cod_rapporto,
                                                 s1.cod_protocollo_delibera,
                                                 SUM (
                                                    pcr.val_imp_utilizzato)
                                                 OVER (
                                                    PARTITION BY pcr.cod_abi,
                                                                 pcr.cod_ndg,
                                                                 pcr.cod_rapporto)
                                                    val_imp_utilizzato,
                                                 ft.cod_natura
                                            FROM t_mcrei_app_rapporti_estero re,
                                                 t_mcrei_app_pcr_rapporti pcr,
                                                 V_MCREI_MAX_STIME_bis s1,
                                                 T_MCRE0_APP_NATURA_FTECNICA ft
                                           WHERE     pcr.cod_abi = s1.cod_abi
                                                 AND pcr.cod_ndg = s1.cod_ndg
                                                 AND pcr.cod_abi =
                                                        re.cod_abi(+)
                                                 AND pcr.cod_ndg =
                                                        re.cod_ndg(+)
                                                 AND pcr.cod_rapporto =
                                                        re.cod_rapporto_estero(+)
                                                 AND re.cod_rapporto_estero
                                                        IS NULL
                                                 AND PCR.COD_CLASSE_FT
                                                        IS NOT NULL
                                                 AND PCR.COD_CLASSE_FT = 'CA'
                                                 AND PCR.cod_forma_tecnica =
                                                        ft.cod_ftecnica) ppcr
                                   WHERE ppcr.val_imp_utilizzato > 0) pr,
                                 --- (2) PCR A MENO DI RAPPORTI ESTERI E POS
                                 V_MCREI_MAX_STIME2_bis s2
                           --- (2) STIME LIVELLO RAPPORTO INSIEMI CON MAX_DTA_STIMA
                           WHERE     pr.cod_abi = s2.cod_abi(+)
                                 AND pr.cod_ndg = s2.cod_ndg(+)
                                 AND pr.cod_rapporto = s2.cod_rapporto(+)
                                 AND PR.COD_PROTOCOLLO_DELIBERA =
                                        S2.COD_PROTOCOLLO_DELIBERA(+)
                                 AND s2.cod_rapporto IS NULL) pprr
                    WHERE     pprr.cod_abi = uf.cod_abi_cartolarizzato
                          AND pprr.cod_ndg = uf.cod_ndg
                          AND cod_natura <> '02')
                     concs
             FROM v_mcre0_app_upd_fields uf
            WHERE     flg_target = 'Y'
                  AND flg_outsourcing = 'Y'
                  AND uf.cod_stato = 'IN'
                  AND uf.id_utente IS NOT NULL
                  AND uf.id_utente != -1)
    WHERE concs IS NOT NULL AND SUBSTR (concs, 1, 1) = 1;
