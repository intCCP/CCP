/* Formatted on 21/07/2014 18:37:29 (QP5 v5.227.12220.39754) */
CREATE OR REPLACE FORCE VIEW MCRE_OWN.V_MCRE0_POSIZIONI_CONFERIMENTI
(
   COD_ABI,
   COD_NDG,
   FLG_LAVORABILE
)
AS
   SELECT /*+ FIRST_ROWS(10) */
         a.cod_abi_cartolarizzato,
          a.cod_ndg,
          DECODE (flg_lavorabile, '0', 'N', 'Y') flg_lavorabile
     FROM (                      --check sulla tabella di migrazione - cedenti
           SELECT M.COD_ABI_OLD AS cod_abi,
                  m.cod_ndg_old AS cod_ndg,
                  '0' AS flg_lavorabile
             FROM T_MCRE0_APP_MIG_RECODE_NDG m
            WHERE M.FLG_PRESA_VISIONE < 2
           UNION               --check sulla tabella di migrazione - riceventi
           SELECT M.COD_ABI_NEW AS cod_abi,
                  m.cod_ndg_new AS cod_ndg,
                  '0' AS flg_lavorabile
             FROM T_MCRE0_APP_MIG_RECODE_NDG m
            WHERE M.FLG_PRESA_VISIONE < 2) p,
          t_mcre0_app_all_data a
    WHERE     a.cod_abi_cartolarizzato = p.cod_abi(+)
          AND a.cod_ndg = p.cod_ndg(+);
