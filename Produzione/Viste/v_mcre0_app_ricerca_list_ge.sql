/* Formatted on 17/06/2014 18:03:07 (QP5 v5.227.12220.39754) */
CREATE OR REPLACE FORCE VIEW MCRE_OWN.V_MCRE0_APP_RICERCA_LIST_GE
(
   COD_GRE,
   VAL_ANA_GRE,
   COD_SNDG,
   DESC_NOME_CONTROPARTE,
   FLG_CAPOGRUPPO
)
AS
   SELECT                                       -- V1 02/12/2010 VG: Congelata
                                   -- V1 10/12/2010 VG: Non solo la capogruppo
           -- V1 04/01/2010 ML: Aggiunto a.flg_capogruppo tra i campi estratti
         e.cod_gre,
         e.val_ana_gre,
         a.cod_sndg,
         g.desc_nome_controparte,
         a.flg_capogruppo
    FROM t_mcre0_app_gruppo_economico a,
         t_mcre0_app_anagr_gre e,
         t_mcre0_app_anagrafica_gruppo g
   WHERE a.cod_gruppo_economico = e.cod_gre       --AND a.flg_capogruppo = 'S'
                                           AND a.cod_sndg = g.cod_sndg;


GRANT DELETE, INSERT, REFERENCES, SELECT, UPDATE, ON COMMIT REFRESH, QUERY REWRITE, DEBUG, FLASHBACK, MERGE VIEW ON MCRE_OWN.V_MCRE0_APP_RICERCA_LIST_GE TO MCRE_USR;
