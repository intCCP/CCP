/* Formatted on 21/07/2014 18:37:02 (QP5 v5.227.12220.39754) */
CREATE OR REPLACE FORCE VIEW MCRE_OWN.V_MCRE0_ETL_LAVORABILI
(
   FLG_ACTIVE,
   COD_ABI,
   COD_ABI_CARTOLARIZZATO,
   COD_NDG,
   COD_SNDG,
   COD_GRUPPO_SUPER,
   FLG_LAVORABILE,
   FLG_SNDG_LAVORABILE,
   FLG_GRUPPO_LAVORABILE,
   COD_BLOCCO_ABI,
   COD_BLOCCO_SNDG,
   COD_BLOCCO_GRUPPO,
   COD_BLOCCO,
   DESC_BLOCCO_ABI,
   DESC_BLOCCO_SNDG,
   DESC_BLOCCO_GRUPPO,
   DESC_BLOCCO
)
AS
   SELECT FLG_ACTIVE,
          COD_ABI,
          COD_ABI_CARTOLARIZZATO,
          COD_NDG,
          COD_SNDG,
          COD_GRUPPO_SUPER,
          FLG_LAVORABILE,
          FLG_SNDG_LAVORABILE,
          FLG_GRUPPO_LAVORABILE,
          COD_BLOCCO_ABI,
          COD_BLOCCO_SNDG,
          COD_BLOCCO_GRUPPO,
          COD_BLOCCO,
          (SELECT MIN (desc_blocco)
             FROM T_MCRE0_CL_LAVORABILE c
            WHERE c.cod_blocco = COD_BLOCCO_ABI)
             DESC_BLOCCO_ABI,
          (SELECT MIN (desc_blocco)
             FROM T_MCRE0_CL_LAVORABILE c
            WHERE c.cod_blocco = COD_BLOCCO_SNDG)
             DESC_BLOCCO_SNDG,
          (SELECT MIN (desc_blocco)
             FROM T_MCRE0_CL_LAVORABILE c
            WHERE c.cod_blocco = COD_BLOCCO_GRUPPO)
             DESC_BLOCCO_GRUPPO,
          (SELECT MIN (desc_blocco)
             FROM T_MCRE0_CL_LAVORABILE c
            WHERE c.cod_blocco = COD_BLOCCO)
             DESC_BLOCCO
     FROM (SELECT '1' flg_active,
                  COD_ABI_ISTITUTO COD_ABI,
                  COD_ABI_CARTOLARIZZATO,
                  COD_NDG,
                  COD_SNDG,
                  cod_gruppo_super,
                  CASE WHEN flg_blocco_abi = '1' THEN 0 ELSE 1 END
                     FLG_LAVORABILE,
                  CASE WHEN FLG_BLOCCO_SNDG = '1' THEN 0 ELSE 1 END
                     FLG_SNDG_LAVORABILE,
                  CASE WHEN flg_blocco_gruppo = '1' THEN 0 ELSE 1 END
                     flg_gruppo_lavorabile,
                  CASE WHEN flg_blocco_abi = '1' THEN 100 ELSE 0 END
                     cod_blocco_abi,
                  CASE WHEN flg_blocco_sndg = '1' THEN 200 ELSE 0 END
                     cod_blocco_sndg,
                  CASE WHEN flg_blocco_gruppo = '1' THEN 300 ELSE 0 END
                     cod_blocco_gruppo,
                  CASE
                     WHEN (SELECT VALORE_COSTANTE
                             FROM T_MCRE0_WRK_CONFIGURAZIONE
                            WHERE NOME_COSTANTE = 'STATO_PORTALE') = 0
                     THEN
                        300
                     WHEN flg_blocco_abi = '1'
                     THEN
                        100
                     WHEN flg_blocco_sndg = '1'
                     THEN
                        200
                     WHEN flg_blocco_gruppo = '1'
                     THEN
                        300
                     WHEN flg_blocco_abi = '0'
                     THEN
                        0
                     ELSE
                        300
                  END
                     cod_blocco
             FROM t_mcre0_mis_data);
