/* Formatted on 17/06/2014 18:17:12 (QP5 v5.227.12220.39754) */
CREATE OR REPLACE FORCE VIEW MCRE_OWN.VTMCRE0_APP_SCHEDA_ANAG_SNDG
(
   DESC_NOME_CONTROPARTE,
   COD_SNDG,
   VAL_PARTITA_IVA,
   COD_GRUPPO_ECONOMICO,
   COD_GRUPPO_LEGAME,
   VAL_ANA_GRE,
   COD_COMPARTO,
   DESC_COMPARTO,
   NOME,
   COGNOME,
   COD_MATRICOLA,
   VAL_SEGMENTO_REGOLAMENTARE,
   DTA_SEGMENTO_REGOLAMENTARE,
   DTA_INIZIO_RELAZIONE,
   VAL_PD_ONLINE,
   DTA_RIF_PD_ONLINE,
   COD_SAG,
   FLG_CONFERMA,
   FLG_ALLINEAMENTO,
   DTA_SAG,
   FLG_ART_136,
   COD_SNDG_SOGGETTO,
   VAL_SETTORE_ECONOMICO,
   VAL_RAMO_ECONOMICO,
   DTA_NASCITA_COSTITUZIONE,
   VAL_MAU
)
AS
   SELECT DISTINCT /*+ NOPARALLEL(A) NOPARALLEL(X) NOPARALLEL(SA)*/
          -- V1 02/12/2010 VG: Congelata
          a.desc_nome_controparte,
          f.cod_sndg,
          a.val_partita_iva,
          f.cod_gruppo_economico,
          f.cod_gruppo_legame,
          f.desc_gruppo_economico val_ana_gre,
          --MM14.02 escludo active a 0 a meno che non lo sia l'intero sndg
          CASE
             WHEN MAX (f.flg_active) OVER (PARTITION BY f.cod_sndg) = '1'
             THEN
                MAX (DECODE (flg_active, '1', f.cod_comparto, NULL))
                   OVER (PARTITION BY f.cod_sndg)
             ELSE
                MAX (f.cod_comparto) OVER (PARTITION BY f.cod_sndg)
          END
             cod_comparto,
          CASE
             WHEN MAX (f.flg_active) OVER (PARTITION BY f.cod_sndg) = '1'
             THEN
                MAX (DECODE (flg_active, '1', f.desc_comparto, NULL))
                   OVER (PARTITION BY f.cod_sndg)
             ELSE
                MAX (f.desc_comparto) OVER (PARTITION BY f.cod_sndg)
          END
             desc_comparto,                                           --11 giu
          MAX (f.nome) OVER (PARTITION BY f.cod_sndg) nome,
          MAX (f.cognome) OVER (PARTITION BY f.cod_sndg) cognome,
          MAX (f.cod_matricola) OVER (PARTITION BY f.cod_sndg) cod_matricola,
          a.val_segmento_regolamentare,
          a.dta_segmento_regolamentare,
          a.dta_inizio_relazione,
          a.val_pd_online,
          a.dta_rif_pd_online,
          sa.cod_sag,
          sa.flg_conferma,
          sa.flg_allineamento,
          CASE
             WHEN sa.flg_conferma = 'S' THEN sa.dta_conferma
             ELSE sa.dta_calcolo_sag
          END
             dta_sag,
          a.flg_art_136,
          a.cod_sndg_soggetto,
          a.val_settore_economico,
          a.val_ramo_economico,
          a.dta_nascita_costituzione,
          f.gb_val_mau AS val_mau
     FROM vtmcre0_app_upd_fields_all f,
          t_mcre0_app_anagrafica_gruppo a,
          t_mcre0_app_sag sa
    WHERE f.cod_sndg = a.cod_sndg --AND f.flg_active = '1' AD. 22 gen:commentato per allineare sndg visualizzati a scheda anag
                                 AND f.cod_sndg = sa.cod_sndg(+);


GRANT DELETE, INSERT, REFERENCES, SELECT, UPDATE, ON COMMIT REFRESH, QUERY REWRITE, DEBUG, FLASHBACK ON MCRE_OWN.VTMCRE0_APP_SCHEDA_ANAG_SNDG TO MCRE_USR;
