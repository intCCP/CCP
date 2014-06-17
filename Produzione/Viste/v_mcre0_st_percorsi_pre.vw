/* Formatted on 17/06/2014 18:06:25 (QP5 v5.227.12220.39754) */
CREATE OR REPLACE FORCE VIEW MCRE_OWN.V_MCRE0_ST_PERCORSI_PRE
(
   COD_ABI_CARTOLARIZZATO,
   COD_NDG,
   COD_PERCORSO,
   DTA_DECORRENZA_STATO_PRE,
   COD_PROCESSO_PRE
)
AS
   WITH perc
        AS (SELECT *
              FROM (SELECT p.cod_abi_cartolarizzato,
                           p.cod_ndg,
                           p.cod_percorso,
                           p.tms,
                           CASE
                              WHEN     LAG (p.cod_abi_cartolarizzato, 1)
                                          OVER (ORDER BY
                                                   p.cod_abi_cartolarizzato,
                                                   p.cod_ndg,
                                                   p.cod_percorso,
                                                   p.tms) =
                                          p.cod_abi_cartolarizzato
                                   AND LAG (p.cod_ndg, 1)
                                          OVER (ORDER BY
                                                   p.cod_abi_cartolarizzato,
                                                   p.cod_ndg,
                                                   p.cod_percorso,
                                                   p.tms) = p.cod_ndg
                                   AND LAG (p.cod_percorso, 1)
                                          OVER (ORDER BY
                                                   p.cod_abi_cartolarizzato,
                                                   p.cod_ndg,
                                                   p.cod_percorso,
                                                   p.tms) = p.cod_percorso
                              THEN
                                 LAG (p.DTA_DECORRENZA_STATO, 1)
                                    OVER (ORDER BY
                                             p.cod_abi_cartolarizzato,
                                             p.cod_ndg,
                                             p.cod_percorso,
                                             p.tms)
                              ELSE
                                 NULL
                           END
                              AS dta_decorrenza_stato_pre,
                           CASE
                              WHEN     LAG (p.cod_abi_cartolarizzato, 1)
                                          OVER (ORDER BY
                                                   p.cod_abi_cartolarizzato,
                                                   p.cod_ndg,
                                                   p.cod_percorso,
                                                   p.tms) =
                                          p.cod_abi_cartolarizzato
                                   AND LAG (p.cod_ndg, 1)
                                          OVER (ORDER BY
                                                   p.cod_abi_cartolarizzato,
                                                   p.cod_ndg,
                                                   p.cod_percorso,
                                                   p.tms) = p.cod_ndg
                                   AND LAG (p.cod_percorso, 1)
                                          OVER (ORDER BY
                                                   p.cod_abi_cartolarizzato,
                                                   p.cod_ndg,
                                                   p.cod_percorso,
                                                   p.tms) = p.cod_percorso
                              THEN
                                 CASE
                                    WHEN p.COD_PROCESSO !=
                                            LAG (
                                               p.COD_PROCESSO,
                                               1)
                                            OVER (
                                               ORDER BY
                                                  p.cod_abi_cartolarizzato,
                                                  p.cod_ndg,
                                                  p.cod_percorso,
                                                  p.tms)
                                    THEN
                                       LAG (p.COD_PROCESSO, 1)
                                          OVER (ORDER BY
                                                   p.cod_abi_cartolarizzato,
                                                   p.cod_ndg,
                                                   p.cod_percorso,
                                                   p.tms)
                                    ELSE
                                       NULL
                                 END
                              ELSE
                                 NULL
                           END
                              AS cod_processo_pre,
                           CASE
                              WHEN     LAG (p.cod_abi_cartolarizzato, 1)
                                          OVER (ORDER BY
                                                   p.cod_abi_cartolarizzato,
                                                   p.cod_ndg,
                                                   p.cod_percorso,
                                                   p.tms) =
                                          p.cod_abi_cartolarizzato
                                   AND LAG (p.cod_ndg, 1)
                                          OVER (ORDER BY
                                                   p.cod_abi_cartolarizzato,
                                                   p.cod_ndg,
                                                   p.cod_percorso,
                                                   p.tms) = p.cod_ndg
                                   AND LAG (p.cod_percorso, 1)
                                          OVER (ORDER BY
                                                   p.cod_abi_cartolarizzato,
                                                   p.cod_ndg,
                                                   p.cod_percorso,
                                                   p.tms) = p.cod_percorso
                              THEN
                                 CASE
                                    WHEN p.COD_PROCESSO !=
                                            LAG (
                                               p.COD_PROCESSO,
                                               1)
                                            OVER (
                                               ORDER BY
                                                  p.cod_abi_cartolarizzato,
                                                  p.cod_ndg,
                                                  p.cod_percorso,
                                                  p.tms)
                                    THEN
                                       1
                                    ELSE
                                       2
                                 END
                              ELSE
                                 0
                           END
                              AS flg_processo_pre,
                           CASE
                              WHEN     LAG (p.cod_abi_cartolarizzato, 1)
                                          OVER (ORDER BY
                                                   p.cod_abi_cartolarizzato,
                                                   p.cod_ndg,
                                                   p.cod_percorso,
                                                   p.tms) =
                                          p.cod_abi_cartolarizzato
                                   AND LAG (p.cod_ndg, 1)
                                          OVER (ORDER BY
                                                   p.cod_abi_cartolarizzato,
                                                   p.cod_ndg,
                                                   p.cod_percorso,
                                                   p.tms) = p.cod_ndg
                                   AND LAG (p.cod_percorso, 1)
                                          OVER (ORDER BY
                                                   p.cod_abi_cartolarizzato,
                                                   p.cod_ndg,
                                                   p.cod_percorso,
                                                   p.tms) = p.cod_percorso
                              THEN
                                 CASE --mm140131 sostituito test su decorrenza e non su stato
                                    WHEN p.DTA_DECORRENZA_STATO !=
                                            LAG (
                                               p.DTA_DECORRENZA_STATO,
                                               1)
                                            OVER (
                                               ORDER BY
                                                  p.cod_abi_cartolarizzato,
                                                  p.cod_ndg,
                                                  p.cod_percorso,
                                                  p.tms)
                                    THEN
                                       1
                                    ELSE
                                       2
                                 END
                              ELSE
                                 0
                           END
                              AS flg_STATO_pre
                      FROM ttmcre0_st_percorsi p --                      and cod_stato IN (SELECT cod_microstato
                                                --                                FROM t_mcre0_app_stati s
                                                --                               WHERE s.flg_stato_chk = 1
                   )),
        cod_processo_pre
        AS (SELECT p.cod_abi_cartolarizzato,
                   p.cod_ndg,
                   p.cod_percorso,
                   p.cod_processo_pre
              FROM (SELECT p.cod_abi_cartolarizzato,
                           p.cod_ndg,
                           p.cod_percorso,
                           p.cod_processo_pre,
                           COUNT (
                              *)
                           OVER (
                              PARTITION BY p.cod_abi_cartolarizzato,
                                           p.cod_ndg)
                              AS mycount
                      FROM (SELECT p.cod_abi_cartolarizzato,
                                   p.cod_ndg,
                                   p.cod_percorso,
                                   p.cod_processo_pre,
                                   RANK ()
                                   OVER (
                                      PARTITION BY p.cod_abi_cartolarizzato,
                                                   p.cod_ndg,
                                                   p.cod_percorso
                                      ORDER BY tms DESC)         --0131 desc?!
                                      AS myrank
                              FROM perc p
                             WHERE flg_processo_pre = 1) p
                     WHERE myrank = 1) p
             WHERE mycount = 1),
        dta_decorrenza_stato_pre
        AS (SELECT p.cod_abi_cartolarizzato,
                   p.cod_ndg,
                   p.cod_percorso,
                   p.dta_decorrenza_stato_pre
              FROM (SELECT p.cod_abi_cartolarizzato,
                           p.cod_ndg,
                           p.cod_percorso,
                           p.dta_decorrenza_stato_pre,
                           COUNT (
                              *)
                           OVER (
                              PARTITION BY p.cod_abi_cartolarizzato,
                                           p.cod_ndg)
                              AS mycount
                      FROM (SELECT p.cod_abi_cartolarizzato,
                                   p.cod_ndg,
                                   p.cod_percorso,
                                   p.dta_decorrenza_stato_pre,
                                   RANK ()
                                   OVER (
                                      PARTITION BY p.cod_abi_cartolarizzato,
                                                   p.cod_ndg,
                                                   p.cod_percorso
                                      ORDER BY tms DESC)         --0131 desc?!
                                      AS myrank
                              FROM perc p           --WHERE flg_stato_pre  = 1
                                         ) p
                     WHERE myrank = 1) p
             WHERE mycount = 1)
   SELECT s.cod_abi_cartolarizzato,
          s.cod_ndg,
          s.cod_percorso,
          NVL (
             d.dta_decorrenza_stato_pre,
             (SELECT m.dta_decorrenza_stato_pre
                FROM mcre_own.t_mcre0_dwh_mopl m
               WHERE     s.cod_abi_cartolarizzato = m.cod_abi_cartolarizzato
                     AND s.cod_ndg = m.cod_ndg))
             dta_decorrenza_stato_pre,
          NVL (
             p.cod_processo_pre,
             (SELECT m.cod_processo_pre
                FROM mcre_own.t_mcre0_dwh_mopl m
               WHERE     s.cod_abi_cartolarizzato = m.cod_abi_cartolarizzato
                     AND s.cod_ndg = m.cod_ndg))
             cod_processo_pre
     FROM t_mcre0_stg_mopl s, dta_decorrenza_stato_pre d, cod_processo_pre p
    WHERE     s.cod_abi_cartolarizzato = p.cod_abi_cartolarizzato(+)
          AND s.cod_ndg = p.cod_ndg(+)
          AND s.cod_percorso = p.cod_percorso(+)
          AND s.cod_abi_cartolarizzato = d.cod_abi_cartolarizzato(+)
          AND s.cod_ndg = d.cod_ndg(+)
          --mm140114
          --          AND s.cod_stato IN (SELECT cod_microstato
          --                                FROM t_mcre0_app_stati s
          --                               WHERE s.flg_stato_chk = 1)
          AND s.cod_percorso = d.cod_percorso(+);


GRANT SELECT ON MCRE_OWN.V_MCRE0_ST_PERCORSI_PRE TO MCRE_USR;
