/* Formatted on 17/06/2014 18:17:52 (QP5 v5.227.12220.39754) */
CREATE OR REPLACE FORCE VIEW MCRE_OWN.VTMCREI_POSIZIONI_LAVORABILI
(
   COD_ABI,
   COD_NDG,
   COD_SNDG,
   FLG_LAVORABILE,
   FLG_SNDG_LAVORABILE
)
AS
   SELECT DISTINCT /*+ FIRST_ROWS(10) */
          cod_abi,
          cod_ndg,
          cod_sndg,
          DECODE (
             MIN (flg_lavorabile)
                OVER (PARTITION BY COD_ABI, COD_NDG, COD_SNDG),
             '1', 'Y',
             'N')
             flg_lavorabile,
          DECODE (MIN (flg_lavorabile_sndg) OVER (PARTITION BY COD_SNDG),
                  '1', 'Y',
                  'N')
             AS FLG_SNDG_LAVORABILE
     FROM (SELECT                         --check sugli abi Cruscotto caricati
                 cod_abi_cartolarizzato AS cod_abi,
                  cod_ndg,
                  cod_sndg,
                  FLG_ABI_LAVORATO AS flg_lavorabile,
                  CASE
                     WHEN NVL (a.SCSB_UTI_TOT, 0) + NVL (SCSB_ACC_TOT, 0) > 0
                     THEN
                        FLG_ABI_LAVORATO
                     ELSE
                        '1'
                  END
                     AS flg_lavorabile_sndg
             FROM t_mcre0_app_all_data_DAY a, mv_mcre0_app_istituti i
            WHERE     a.cod_abi_cartolarizzato = i.cod_abi
                  AND A.COD_SNDG = A.COD_SNDG
                  AND I.DTA_ABI_ELAB IS NOT NULL
           UNION                                --check sugli abi INC caricati
           SELECT cod_abi_cartolarizzato AS cod_abi,
                  cod_ndg,
                  cod_sndg,
                  TO_CHAR (FLG_ABI_LAVORATO) AS flg_lavorabile,
                  TO_CHAR (FLG_ABI_LAVORATO) AS flg_lavorabile_sndg
             FROM t_mcre0_app_all_data_DAY a, t_mcrei_wrk_abi_lavorati i
            WHERE     NVL (a.SCSB_UTI_TOT, 0) + NVL (SCSB_ACC_TOT, 0) > 0
                  AND a.cod_abi_cartolarizzato = i.cod_abi
                  AND A.COD_SNDG = A.COD_SNDG
           UNION                 --check sulla tabella di migrazione - cedenti
           SELECT a.cod_abi_cartolarizzato AS cod_abi,
                  a.cod_ndg,
                  a.cod_sndg,
                  '0' AS flg_lavorabile,
                  '0' AS flg_lavorabile_sndg
             FROM t_mcre0_app_all_data_DAY a, T_MCRE0_APP_MIG_RECODE_NDG m
            WHERE     a.cod_abi_cartolarizzato = M.COD_ABI_OLD
                  AND A.COD_NDG = m.cod_ndg_old
                  AND NVL (a.SCSB_UTI_TOT, 0) + NVL (SCSB_ACC_TOT, 0) > 0
                  AND M.FLG_PRESA_VISIONE < 2
           UNION               --check sulla tabella di migrazione - riceventi
           SELECT a.cod_abi_cartolarizzato AS cod_abi,
                  a.cod_ndg,
                  a.cod_sndg,
                  '0' AS flg_lavorabile,
                  '0' AS flg_lavorabile_sndg
             FROM t_mcre0_app_all_data_DAY a, T_MCRE0_APP_MIG_RECODE_NDG m
            WHERE     a.cod_abi_cartolarizzato = M.COD_ABI_new
                  AND A.COD_NDG = m.cod_ndg_new
                  AND NVL (a.SCSB_UTI_TOT, 0) + NVL (SCSB_ACC_TOT, 0) > 0
                  AND M.FLG_PRESA_VISIONE < 2);


GRANT DELETE, INSERT, REFERENCES, SELECT, UPDATE, ON COMMIT REFRESH, QUERY REWRITE, DEBUG, FLASHBACK ON MCRE_OWN.VTMCREI_POSIZIONI_LAVORABILI TO MCRE_USR;
