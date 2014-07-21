/* Formatted on 21/07/2014 18:42:21 (QP5 v5.227.12220.39754) */
CREATE OR REPLACE FORCE VIEW MCRE_OWN.V_MCRES_APP_MAIN_GR_SOFF
(
   COD_ABI,
   COD_SNDG,
   DESC_NOME_CONTROPARTE,
   COD_GRUPPO_ECONOMICO,
   VAL_ANA_GRE,
   VAL_ANNOMESE,
   VAL_VANTATO,
   VAL_GBV,
   VAL_NBV,
   VAL_GAR_REALI,
   VAL_GAR_PERSONALI
)
AS
   SELECT                                     -- v1 19/10/2011 VG: abs vantato
                             -- v2 17/09/2011 AG: nuova vesione con cod_cli_ge
         -1 cod_abi,
         CASE WHEN LENGTH (s.cod_cli_ge) = 16 THEN s.cod_cli_ge END cod_sndg,
         CASE
            WHEN LENGTH (s.cod_cli_ge) = 16
            THEN
               NVL (a.desc_nome_controparte, t.desc_nome_gruppo_cliente) --nel caso in cu descrizione nel file top_30 ma non in anagrafica
         END
            desc_nome_controparte,
         CASE WHEN LENGTH (cod_cli_ge) = 8 THEN cod_cli_ge END
            cod_gruppo_economico,
         CASE WHEN LENGTH (cod_cli_ge) = 8 THEN g.val_ana_gre END val_ana_gre,
         s.val_annomese,
         s.val_vantato,
         s.val_gbv,
         s.val_nbv,
         s.val_gar_reali,
         s.val_gar_personali
    FROM t_mcres_fen_main_gr_soff s,
         t_mcre0_app_anagrafica_gruppo a,
         t_mcre0_app_anagr_gre g,
         t_mcres_app_top_30_nt t
   WHERE     0 = 0
         AND s.cod_cli_ge = a.cod_sndg(+)
         AND s.cod_cli_ge = g.cod_gre(+)
         AND s.cod_cli_ge = t.cod_sndg_gruppo_cliente(+);
