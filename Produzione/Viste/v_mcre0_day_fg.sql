/* Formatted on 17/06/2014 18:05:06 (QP5 v5.227.12220.39754) */
CREATE OR REPLACE FORCE VIEW MCRE_OWN.V_MCRE0_DAY_FG
(
   ID_DPER,
   COD_ABI_ISTITUTO,
   COD_ABI_CARTOLARIZZATO,
   COD_NDG,
   COD_SNDG,
   COD_GRUPPO_ECONOMICO,
   COD_GRUPPO_LEGAME,
   FLG_GRUPPO_ECONOMICO,
   FLG_GRUPPO_LEGAME,
   FLG_SINGOLO,
   FLG_CONDIVISO,
   FLG_SOMMA
)
AS
   SELECT id_dper,
          cod_abi_istituto,
          cod_abi_cartolarizzato,
          cod_ndg,
          cod_sndg,
          cod_gruppo_economico,
          cod_gruppo_legame,
          flg_gruppo_economico,
          flg_gruppo_legame,
          TO_CHAR (flg_singolo) flg_singolo,
          TO_CHAR (flg_condiviso) flg_condiviso,
          TO_CHAR (flg_somma) flg_somma
     FROM (SELECT f.id_dper,
                  f.cod_abi_istituto,
                  f.cod_abi_cartolarizzato,
                  f.cod_ndg,
                  f.cod_sndg,
                  NVL ( (ge.cod_gruppo_economico), -1)
                     AS cod_gruppo_economico,
                  NVL ( (DECODE (ge.cod_gruppo_economico, NULL, '0', '1')),
                       '0')
                     AS flg_gruppo_economico,
                  NVL ( (cod_gruppo_legame), -1) AS cod_gruppo_legame,
                  NVL ( (DECODE (cod_gruppo_legame, NULL, '0', '1')), '0')
                     AS flg_gruppo_legame,
                  SIGN (
                       COUNT (DISTINCT f.cod_ndg)
                          OVER (PARTITION BY f.cod_sndg)
                     - 1)
                     flg_condiviso,
                  ABS (
                       1
                     - SIGN (
                            COUNT (DISTINCT f.cod_ndg)
                               OVER (PARTITION BY f.cod_sndg)
                          - 1))
                     flg_singolo,
                  CASE
                     WHEN     f.cod_abi_istituto != f.cod_abi_cartolarizzato
                          AND COUNT (cod_abi_istituto)
                                 OVER (PARTITION BY f.cod_ndg, f.cod_sndg) >
                                 1
                          AND COUNT (DISTINCT cod_abi_cartolarizzato)
                                 OVER (PARTITION BY f.cod_ndg, f.cod_sndg) >
                                 1
                     THEN
                        0
                     ELSE
                        1
                  END
                     flg_somma
             FROM t_mcre0_stg_fg f,
                  t_mcre0_dwh_gl gl,
                  v_mcre0_st_gruppo_economico ge
            WHERE f.cod_sndg = gl.cod_sndg(+) AND f.cod_sndg = ge.cod_sndg(+))
   UNION
   SELECT id_dperfg id_dper,
          cod_abi_istituto,
          cod_abi_cartolarizzato,
          cod_ndg,
          cod_sndg,
          cod_gruppo_economico,
          cod_gruppo_legame,
          flg_gruppo_economico,
          flg_gruppo_legame,
          flg_singolo,
          flg_condiviso,
          flg_somma
     FROM v_mcre0_pos_mancanti;


GRANT SELECT ON MCRE_OWN.V_MCRE0_DAY_FG TO MCRE_USR;
