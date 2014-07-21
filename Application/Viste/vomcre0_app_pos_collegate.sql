/* Formatted on 21/07/2014 18:46:12 (QP5 v5.227.12220.39754) */
CREATE OR REPLACE FORCE VIEW MCRE_OWN.VOMCRE0_APP_POS_COLLEGATE
(
   COD_ABI_ISTITUTO,
   COD_ABI_CARTOLARIZZATO,
   COD_NDG,
   COD_SNDG,
   DESC_NOME_CONTROPARTE,
   COD_GRUPPO_ECONOMICO,
   COD_GRUPPO_SUPER,
   VAL_ANA_GRE,
   COD_LEGAME,
   FLG_CAPOLEGAME,
   COD_STATO,
   COD_MACROSTATO,
   DESC_ISTITUTO,
   FLG_CONDIVISO,
   FLG_GRUPPO_ECONOMICO,
   FLG_GRUPPO_LEGAME,
   FLG_SINGOLO,
   FLG_OUTSOURCING,
   FLG_TARGET
)
AS
   SELECT -- 10.02 tolto filtro mople, check outsourcing da mople, anche stato null
         fg.cod_abi_istituto,
          fg.cod_abi_cartolarizzato,
          fg.cod_ndg,
          fg.cod_sndg,
          desc_nome_controparte,
          cod_gruppo_economico,
          cod_gruppo_super,
          val_ana_gre,
          cod_legame,
          flg_capolegame,
          cod_stato,
          cod_macrostato,
          desc_istituto,
          fg.flg_condiviso,
          fg.flg_gruppo_economico,
          fg.flg_gruppo_legame,
          fg.flg_singolo,
          NVL (mp.flg_outsourcing, ist.flg_outsourcing) flg_outsourcing,
          ist.flg_target
     FROM t_mcre0_app_file_guida fg
          LEFT OUTER JOIN
          t_mcre0_app_mople mp
             ON (    fg.cod_abi_cartolarizzato = mp.cod_abi_cartolarizzato
                 AND fg.cod_ndg = mp.cod_ndg)
          LEFT OUTER JOIN t_mcre0_app_anagrafica_gruppo ang
             ON (fg.cod_sndg = ang.cod_sndg)
          LEFT OUTER JOIN t_mcre0_app_anagr_gre ange
             ON (fg.cod_gruppo_economico = ange.cod_gre)
          LEFT OUTER JOIN t_mcre0_app_gruppo_legame grpl
             ON (fg.cod_sndg = grpl.cod_sndg)
          LEFT OUTER JOIN t_mcre0_app_istituti ist
             ON (fg.cod_abi_cartolarizzato = ist.cod_abi)
    WHERE     (   fg.flg_condiviso = 1
               OR fg.flg_gruppo_economico = 1
               OR fg.flg_gruppo_legame = 1)
          --      AND (   MP.ID_DPER = (SELECT A.IDPER
          --                              FROM V_MCRE0_ULTIMA_ACQUISIZIONE A
          --                             WHERE A.COD_FILE = 'MOPLE')
          --           OR MP.ID_DPER IS NULL
          --          )
          AND fg.id_dper = (SELECT a.idper
                              FROM v_mcre0_ultima_acquisizione a
                             WHERE a.cod_file = 'FILE_GUIDA')
          AND (   NVL (mp.flg_outsourcing, 'N') = 'N'
               OR (mp.flg_outsourcing = 'Y' AND ist.flg_target IS NULL)
               OR cod_stato NOT IN (SELECT cod_microstato
                                      FROM t_mcre0_app_stati s
                                     WHERE s.flg_stato_chk = 1)
               OR cod_stato IS NULL);
