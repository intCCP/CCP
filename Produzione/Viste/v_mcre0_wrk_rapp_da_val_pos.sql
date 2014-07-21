/* Formatted on 17/06/2014 18:07:16 (QP5 v5.227.12220.39754) */
CREATE OR REPLACE FORCE VIEW MCRE_OWN.V_MCRE0_WRK_RAPP_DA_VAL_POS
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
          SUBSTR (concs, 38, 17) AS cod_protocollo_delibera,
          TO_NUMBER (SUBSTR (concs, 55)) val_cnt_rapporti,
          'R' AS val_alert,
          1 AS val_cnt_delibere,
          DECODE (concs, TO_CHAR (NULL), 0, 1) AS flg_acc
     FROM (SELECT uf.cod_stato,
                  uf.cod_abi_cartolarizzato,
                  uf.cod_ndg,
                  uf.cod_sndg,
                  (SELECT -- 04.10.2012 V3 - AGGIUNTA EXISTS SULLE STIME, DA OTTIMIZZARE SE POSSIBILE
 -- 04.10.2012 V4 - RICOSTRUITA LOGICA CON JOIN SENZA T_MCRE0_APP_ALL_DATA, COD_STATO S SEMPRE A NULL
                                     -- 12.10.2012 V4.1 - AGGIUNTE STIME EXTRA
 -- 15.10.2012   V.4.2 TOLTE STIME EXTRA -- LA PAGINA DI EXTRA DELIBERA NON COMPORTA LA SCRITTURA NELLA STIME EXTRA
                                             -- CREATA VISTA V_MCREI_MAX_STIME
                         DISTINCT
                            pr.cod_abi
                         || pr.cod_ndg
                         || pr.cod_sndg
                         || pr.cod_protocollo_delibera
                         || TO_CHAR (
                               COUNT (pr.cod_rapporto)
                                  OVER (PARTITION BY pr.cod_abi, pr.cod_ndg))
                    FROM (SELECT DISTINCT ppcr.cod_abi,
                                          ppcr.cod_ndg,
                                          ppcr.cod_sndg,
                                          ppcr.cod_rapporto,
                                          ppcr.cod_protocollo_delibera
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
                                            val_imp_utilizzato
                                    FROM t_mcrei_app_rapporti_estero re,
                                         t_mcrei_app_pcr_rapporti pcr,
                                         V_MCREI_MAX_STIME s1,
                                         T_MCRE0_APP_NATURA_FTECNICA ft
                                   WHERE     pcr.cod_abi = s1.cod_abi
                                         AND pcr.cod_ndg = s1.cod_ndg
                                         AND pcr.cod_abi = re.cod_abi(+)
                                         AND pcr.cod_ndg = re.cod_ndg(+)
                                         AND pcr.cod_rapporto =
                                                re.cod_rapporto_estero(+)
                                         AND re.cod_rapporto_estero IS NULL
                                         AND PCR.COD_CLASSE_FT IS NOT NULL
                                         AND PCR.cod_forma_tecnica =
                                                ft.cod_ftecnica
                                         --                                          AND PCR.COD_CLASSE_FT IN
                                         --                                                 ('CA', 'FI')
                                         --                                          AND ft.cod_natura = '02'
                                         AND (   PCR.COD_CLASSE_FT = 'FI'
                                              OR (    PCR.COD_CLASSE_FT = 'CA'
                                                  AND ft.cod_natura = '02'))) ppcr
                           WHERE ppcr.val_imp_utilizzato > 0) pr,
                         --- (2) PCR A MENO DI RAPPORTI ESTERI E POS
                         V_MCREI_MAX_STIME2 s2
                   --- (2) STIME LIVELLO RAPPORTO INSIEMI CON MAX_DTA_STIMA
                   WHERE     pr.cod_abi = s2.cod_abi(+)
                         AND pr.cod_ndg = s2.cod_ndg(+)
                         AND pr.cod_rapporto = s2.cod_rapporto(+)
                         AND PR.COD_PROTOCOLLO_DELIBERA =
                                S2.COD_PROTOCOLLO_DELIBERA(+)
                         AND s2.cod_rapporto IS NULL
                         AND pr.cod_abi = uf.cod_abi_cartolarizzato
                         AND pr.cod_ndg = uf.cod_ndg)
                     concs
             FROM v_mcre0_app_upd_fields uf
            WHERE     flg_target = 'Y'
                  AND flg_outsourcing = 'Y'
                  AND uf.cod_stato = 'IN'
                  AND uf.id_utente IS NOT NULL
                  AND uf.id_utente != -1)
    WHERE concs IS NOT NULL;


GRANT DELETE, INSERT, REFERENCES, SELECT, UPDATE, ON COMMIT REFRESH, QUERY REWRITE, DEBUG, FLASHBACK, MERGE VIEW ON MCRE_OWN.V_MCRE0_WRK_RAPP_DA_VAL_POS TO MCRE_USR;
