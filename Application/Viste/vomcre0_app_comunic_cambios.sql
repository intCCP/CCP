/* Formatted on 21/07/2014 18:46:06 (QP5 v5.227.12220.39754) */
CREATE OR REPLACE FORCE VIEW MCRE_OWN.VOMCRE0_APP_COMUNIC_CAMBIOS
(
   COD_PERCORSO,
   COD_ABI_CARTOLARIZZATO,
   COD_ABI_ISTITUTO,
   COD_NDG,
   DESC_NOME_CONTROPARTE,
   VAL_ANA_GRE,
   COD_STATO,
   DTA_DECORRENZA_STATO,
   COD_STATO_PRECEDENTE,
   DTA_DECORRENZA_STATO_PRE,
   ID_UTENTE,
   COD_COMPARTO
)
AS
   SELECT /*+ first_rows */
                                                -- V1 02/12/2010 VG: Congelata
                                            -- V1 17/12/2010 VG: LAG eliminata
                             -- V2 13/01/2011 MM: invertica condizione <=15gg!
                                                -- V3 16/02/2011 VG: upd_field
                                                  -- V4 14/03/2011 VG: comparo
                                        -- v5 14/04/2011 VG: FLG_OUTSOURCING=Y
                 -- v6 20/04/2011 VG: FLG_OUTSOURCING=Y x storico e target='Y'
                                              -- v7 09/06/2011 VG: Tolta MOPLE
         x.cod_percorso,
         x.cod_abi_cartolarizzato,
         x.cod_abi_istituto,
         x.cod_ndg,
         ge.desc_nome_controparte,
         g.val_ana_gre,
         x.cod_stato,
         x.dta_decorrenza_stato,
         x.cod_stato_precedente,
         x.dta_decorrenza_stato_pre,
         x.id_utente,
         x.cod_comparto
    FROM mv_mcre0_app_upd_field x,
         t_mcre0_app_anagrafica_gruppo ge,
         t_mcre0_app_anagr_gre g,
         mv_mcre0_app_istituti i
   WHERE     (TRUNC (SYSDATE) - x.dta_decorrenza_stato) <= 15
         AND x.cod_sndg = ge.cod_sndg(+)
         AND x.cod_gruppo_economico = g.cod_gre(+)
         AND x.id_utente IS NOT NULL
         AND x.cod_stato != x.cod_stato_precedente
         AND NVL (x.flg_outsourcing, 'N') = 'Y'
         AND x.cod_abi_istituto = i.cod_abi(+)
         AND i.flg_target = 'Y'
         AND x.cod_comparto IN (SELECT c.cod_comparto
                                  FROM t_mcre0_app_comparti c
                                 WHERE c.flg_chk = 1)
         AND x.cod_stato IN (SELECT cod_microstato
                               FROM t_mcre0_app_stati s
                              WHERE s.flg_stato_chk = 1);
