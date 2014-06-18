/* Formatted on 17/06/2014 18:02:21 (QP5 v5.227.12220.39754) */
CREATE OR REPLACE FORCE VIEW MCRE_OWN.V_MCRE0_APP_POS_COLLEGATE
(
   COD_ABI_ISTITUTO,
   COD_ABI_CARTOLARIZZATO,
   COD_NDG,
   COD_SNDG,
   DESC_NOME_CONTROPARTE,
   COD_GRUPPO_ECONOMICO,
   COD_GRUPPO_SUPER,
   DESC_GRUPPO_ECONOMICO,
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
   SELECT /*+ INDEX(fg IGS_T_MCRE0_APP_ALL_DATA) */
     -- 10.02 tolto filtro mople, check outsourcing da mople, anche stato null
                                        -- 110921: flg_alert anzichè stato_chk
         FG.COD_ABI_ISTITUTO,
         FG.COD_ABI_CARTOLARIZZATO,
         FG.COD_NDG,
         FG.COD_SNDG,
         DESC_NOME_CONTROPARTE,
         COD_GRUPPO_ECONOMICO,
         COD_GRUPPO_SUPER,
         DESC_GRUPPO_ECONOMICO,                                 --val_ana_gre,
         COD_LEGAME,
         FLG_CAPOLEGAME,
         COD_STATO,
         COD_MACROSTATO,
         DESC_ISTITUTO,
         FG.FLG_CONDIVISO,
         FG.FLG_GRUPPO_ECONOMICO,
         FG.FLG_GRUPPO_LEGAME,
         FG.FLG_SINGOLO,
         --NVL (mp.flg_outsourcing, ist.flg_outsourcing)
         FLG_OUTSOURCING,                                         --verificare
         FLG_TARGET
    FROM V_MCRE0_APP_UPD_FIELDS_ALL FG
         --      t_mcre0_app_file_guida fg
         --          LEFT OUTER JOIN t_mcre0_app_mople mp
         --             ON (fg.cod_abi_cartolarizzato = mp.cod_abi_cartolarizzato
         --                 AND fg.cod_ndg = mp.cod_ndg)
         --          LEFT OUTER JOIN t_mcre0_app_anagrafica_gruppo ang
         --             ON (fg.cod_sndg = ang.cod_sndg)
         --          LEFT OUTER JOIN t_mcre0_app_anagr_gre ange
         --             ON (fg.cod_gruppo_economico = ange.cod_gre)
         LEFT OUTER JOIN T_MCRE0_APP_GRUPPO_LEGAME GRPL
            ON (FG.COD_SNDG = GRPL.COD_SNDG)
   --          LEFT OUTER JOIN t_mcre0_app_istituti ist
   --             ON (fg.cod_abi_cartolarizzato = ist.cod_abi)
   WHERE     (   FG.FLG_CONDIVISO = '1'
              OR FG.FLG_GRUPPO_ECONOMICO = '1'
              OR FG.FLG_GRUPPO_LEGAME = '1')
         AND FG.FLG_ACTIVE = '1'
         --      AND FG.ID_DPER = (SELECT A.IDPER
         --                          FROM V_MCRE0_ULTIMA_ACQUISIZIONE A
         --                         WHERE A.COD_FILE = 'FILE_GUIDA')
         AND (                          -- NVL (mp.flg_outsourcing, 'N') = 'N'
              FLG_OUTSOURCING = 'N'
              OR (FLG_OUTSOURCING = 'Y' AND FLG_TARGET IS NULL)
              OR FLG_ALERT IS NULL --           OR COD_STATO NOT IN (SELECT COD_MICROSTATO
                  --                                  FROM T_MCRE0_APP_STATI S
                 --                                 WHERE S.FLG_STATO_CHK = 1)
 --           OR COD_STATO = '-1'                                       --IS NULL
             );


GRANT DELETE, INSERT, REFERENCES, SELECT, UPDATE, ON COMMIT REFRESH, QUERY REWRITE, DEBUG, FLASHBACK, MERGE VIEW ON MCRE_OWN.V_MCRE0_APP_POS_COLLEGATE TO MCRE_USR;
