/* Formatted on 17/06/2014 18:15:54 (QP5 v5.227.12220.39754) */
CREATE OR REPLACE FORCE VIEW MCRE_OWN.VTMCRE0_APP_GB_PT_UTENTE
(
   COD_ABI_CARTOLARIZZATO,
   COD_NDG,
   COD_SNDG,
   DTA_STATO,
   FLG_STATO,
   FLG_TIPO_UTENTE_INSERENTE,
   COD_COMPARTO_INSERENTE,
   COD_MATRICOLA
)
AS
   SELECT g.cod_abi_cartolarizzato,
          g.cod_ndg,
          g.cod_sndg,
          g.dta_stato,
          g.flg_stato,
          flg_tipo_utente_inserente,
          COD_COMPARTO_INSERENTE,
          cod_matricola
     FROM t_mcre0_app_gb_pt_gestione g, t_mcre0_app_all_data_DAY a
    WHERE     g.flg_stato = 2
          AND g.cod_macrostato_proposto = 'PT'
          AND a.cod_abi_cartolarizzato = g.cod_abi_cartolarizzato
          AND a.cod_ndg = g.cod_ndg
          AND a.cod_macrostato = g.cod_macrostato_proposto
          AND TRUNC (g.dta_stato) = TRUNC (a.dta_decorrenza_stato);


GRANT DELETE, INSERT, REFERENCES, SELECT, UPDATE, ON COMMIT REFRESH, QUERY REWRITE, DEBUG, FLASHBACK ON MCRE_OWN.VTMCRE0_APP_GB_PT_UTENTE TO MCRE_USR;
