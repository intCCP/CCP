/* Formatted on 17/06/2014 18:04:23 (QP5 v5.227.12220.39754) */
CREATE OR REPLACE FORCE VIEW MCRE_OWN.V_MCRE0_APP_SCHEDA_ANAG_SNDG
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
   VAL_MAU,
   COD_GRUPPO_SUPER
)
AS
   SELECT DISTINCT /*+ NOPARALLEL(A) NOPARALLEL(X) NOPARALLEL(SA)*/
          /******************************************************************************
          -- V1 02/12/2010 VG: Congelata

          Data di creazione:
          Autore:

          mod    : 001
          data   : 22.04.2014
          desc   : Variazione Perimetro DR: aggiunta campo COD_GRUPPO_SUPER
          Autore : Reply - S. De Cesaris

          mod    : 002
          data   : 04.06.2014
          desc   : Fix calcolo COD_COMPARTO per l'estrazione delle Direzioni Generali
          Autore : Reply - S. De Cesaris

          mod    :
          data   :
          desc   :
          autore :
          *****************************************************************************/
          a.desc_nome_controparte,
          f.cod_sndg,
          a.val_partita_iva,
          f.cod_gruppo_economico,
          f.cod_gruppo_legame,
          f.desc_gruppo_economico val_ana_gre,
          --MM14.02 escludo active a 0 a meno che non lo sia l'intero sndg
          CASE
             WHEN MAX (f.flg_active)
                     OVER (PARTITION BY f.cod_sndg, f.cod_gruppo_super) = '1'
             THEN
                MAX (DECODE (flg_active, '1', f.cod_comparto, NULL))
                   OVER (PARTITION BY f.cod_sndg, f.cod_gruppo_super)
             ELSE
                MAX (f.cod_comparto)
                   OVER (PARTITION BY f.cod_sndg, f.cod_gruppo_super)
          END
             cod_comparto,
          CASE
             WHEN MAX (f.flg_active)
                     OVER (PARTITION BY f.cod_sndg, f.cod_gruppo_super) = '1'
             THEN
                MAX (DECODE (flg_active, '1', f.desc_comparto, NULL))
                   OVER (PARTITION BY f.cod_sndg, f.cod_gruppo_super)
             ELSE
                MAX (f.desc_comparto)
                   OVER (PARTITION BY f.cod_sndg, f.cod_gruppo_super)
          END
             desc_comparto,                                           --11 giu
          MAX (f.nome) OVER (PARTITION BY f.cod_sndg, f.cod_gruppo_super)
             nome,
          MAX (f.cognome) OVER (PARTITION BY f.cod_sndg, f.cod_gruppo_super)
             cognome,
          MAX (f.cod_matricola)
             OVER (PARTITION BY f.cod_sndg, f.cod_gruppo_super)
             cod_matricola,
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
          f.gb_val_mau AS val_mau,
          --mod. 001
          f.cod_gruppo_super
     FROM v_mcre0_app_upd_fields_all f,
          t_mcre0_app_anagrafica_gruppo a,
          t_mcre0_app_sag sa
    WHERE f.cod_sndg = a.cod_sndg --AND f.flg_active = '1' AD. 22 gen:commentato per allineare sndg visualizzati a scheda anag
                                 AND f.cod_sndg = sa.cod_sndg(+);


GRANT DELETE, INSERT, REFERENCES, SELECT, UPDATE, ON COMMIT REFRESH, QUERY REWRITE, DEBUG, FLASHBACK, MERGE VIEW ON MCRE_OWN.V_MCRE0_APP_SCHEDA_ANAG_SNDG TO MCRE_USR;
