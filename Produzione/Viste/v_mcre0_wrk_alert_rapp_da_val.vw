/* Formatted on 17/06/2014 18:07:11 (QP5 v5.227.12220.39754) */
CREATE OR REPLACE FORCE VIEW MCRE_OWN.V_MCRE0_WRK_ALERT_RAPP_DA_VAL
(
   COD_ABI,
   COD_NDG,
   COD_SNDG,
   COD_STATO,
   VAL_ALERT,
   VAL_CNT_DELIBERE,
   VAL_CNT_RAPPORTI,
   DTA_INS,
   COD_PROTOCOLLO_DELIBERA
)
AS
   SELECT DISTINCT
          -- 04.10.2012 V3 - aggiunta exists sulle stime, da ottimizzare se possibile
          -- 04.10.2012 V4 - RICOSTRUITA LOGICA CON JOIN SENZA T_MCRE0_APP_ALL_DATA, COD_STATO S SEMPRE A nulL
          -- 12.10.2012 V4.1 - AGGIUNTE STIME EXTRA
          -- 15.10.2012   V.4.2 Tolte stime extra -- la pagina di extra delibera non comporta la scrittura nella stime extra
          ppcr.cod_abi,
          ppcr.cod_ndg,
          ppcr.cod_sndg,
          TO_CHAR (NULL) AS cod_stato,
          'R' AS val_alert,
          1 AS val_cnt_delibere,
          COUNT (ppcr.cod_rapporto)
             OVER (PARTITION BY ppcr.cod_abi, ppcr.cod_ndg)
             val_cnt_rapporti,
          SYSDATE AS dta_ins,
          NULL AS cod_protocollo_delibera
     FROM (SELECT pcr.cod_abi,
                  pcr.cod_ndg,
                  pcr.cod_sndg,
                  pcr.cod_rapporto
             FROM (SELECT /*+ ORDERED INDEX (D PK_MCREI_APP_DELIBERE) INDEX(S1 PK_T_MCREI_APP_STIME)*/
                         DISTINCT s1.cod_abi, s1.cod_ndg
                     FROM t_mcrei_app_stime PARTITION (inc_pattive) s1,
                          t_mcrei_app_delibere PARTITION (inc_pattive) d
                    WHERE     d.cod_abi = s1.cod_abi
                          AND d.cod_ndg = s1.cod_ndg
                          AND d.cod_protocollo_delibera =
                                 s1.cod_protocollo_delibera
                          AND d.cod_fase_delibera = 'CO'
                          AND d.flg_no_delibera = 0
                          AND d.flg_attiva = '1'
                          AND d.cod_microtipologia_delib IN
                                 ('A0', 'T4', 'RV', 'IM')) pos,
                  -- (1) LE POSIZIONI
                  (SELECT /*+ index(re IX_MCREI_APP_RAPPORTI_ESTERO)*/
                         DISTINCT
                          pcr.cod_abi,
                          pcr.cod_ndg,
                          pcr.cod_sndg,
                          pcr.cod_rapporto,
                          SUM (
                             pcr.val_imp_utilizzato)
                          OVER (
                             PARTITION BY pcr.cod_abi,
                                          pcr.cod_ndg,
                                          pcr.cod_rapporto)
                             val_imp_utilizzato
                     FROM t_mcrei_app_rapporti_estero re,
                          t_mcrei_app_pcr_rapporti pcr
                    WHERE     pcr.cod_abi = re.cod_abi(+)
                          AND pcr.cod_ndg = re.cod_ndg(+)
                          AND pcr.cod_rapporto = re.cod_rapporto_estero(+)
                          AND re.cod_rapporto_estero IS NULL) pcr
            -- (1) PCR A MENO DI RAPPORTI ESTERI
            WHERE     pos.cod_abi = pcr.cod_abi
                  AND pos.cod_ndg = pcr.cod_ndg
                  AND pcr.val_imp_utilizzato > 0) ppcr,
          --- (2) PCR A MENO DI RAPPORTI ESTERI E POS
          (SELECT s3.cod_abi,
                  s3.cod_ndg,
                  s3.cod_rapporto,
                  s3.dta_stima
             FROM (SELECT s2.cod_abi,
                          s2.cod_ndg,
                          s2.cod_rapporto,
                          s2.max_dta
                     FROM (SELECT cod_abi,
                                  cod_ndg,
                                  cod_rapporto,
                                  MAX (
                                     s11.dta_stima)
                                  OVER (
                                     PARTITION BY s11.cod_abi, s11.cod_ndg)
                                     AS max_dta
                             FROM t_mcrei_app_stime s11) s2) max_st2,
                  ---- (2.1) STIME E STIME EXTRA CON MAX_DTA
                  t_mcrei_app_stime s3          ---- (2.1) STIME E STIME EXTRA
            WHERE     max_st2.cod_abi = s3.cod_abi
                  AND max_st2.cod_ndg = s3.cod_ndg
                  AND max_st2.cod_rapporto = s3.cod_rapporto
                  AND max_st2.max_dta = s3.dta_stima) s2
    --- (2) STIME livello rapporto insiemi con MAX_DTA_STIMA
    WHERE     ppcr.cod_abi = s2.cod_abi(+)
          AND ppcr.cod_ndg = s2.cod_ndg(+)
          AND ppcr.cod_rapporto = s2.cod_rapporto(+)
          AND s2.cod_rapporto IS NULL;


GRANT DELETE, INSERT, REFERENCES, SELECT, UPDATE, ON COMMIT REFRESH, QUERY REWRITE, DEBUG, FLASHBACK, MERGE VIEW ON MCRE_OWN.V_MCRE0_WRK_ALERT_RAPP_DA_VAL TO MCRE_USR;
