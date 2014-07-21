/* Formatted on 21/07/2014 18:46:08 (QP5 v5.227.12220.39754) */
CREATE OR REPLACE FORCE VIEW MCRE_OWN.VOMCRE0_APP_COMUNIC_NEW_OUT
(
   COD_ABI_CARTOLARIZZATO,
   COD_ABI_ISTITUTO,
   COD_NDG,
   ID_UTENTE,
   ID_UTENTE_PRE,
   DESC_NOME_CONTROPARTE,
   VAL_ANA_GRE,
   COD_STATO,
   COD_STATO_PRECEDENTE,
   COD_PROCESSO,
   COD_PROCESSO_PRE,
   COD_COMPARTO,
   COD_COMPARTO_CALCOLATO,
   COD_COMPARTO_CALCOLATO_PRE,
   COD_RAMO_CALCOLATO,
   DTA_UTENTE_ASSEGNATO,
   DTA_UTENTE_DISASS,
   DTA_IN_OUT
)
AS
   SELECT                                       -- V1 02/12/2010 VG: Congelata
          -- V2 22/12/2010 VG: COD_RAMO_CALCOLATO
          -- v3 16/02/2011 VG: upd_field
          -- v4 08/03/2011 VG: dta_utente_disass - dta_in_out TO_DO
          -- v5 14/03/2011 VG: comparto
          -- v6 04/04/2011 VG: presi anche disassegnati
          -- v7 14/04/2011 VG: FLG_OUTSOURCING=Y
          -- v8 20/04/2011 VG: FLG_OUTSOURCING=Y x storico e target='Y'
          -- v9 11/05/2011 VG: trunc(DTA_FINE_VALIDITA) indice su ST_EVENTI
          -- v10 24/05/2011 VG: eliminata File_Guida
          x.cod_abi_cartolarizzato,
          x.cod_abi_istituto,
          x.cod_ndg,
          x.id_utente,
          NULL id_utente_pre,
          ge.desc_nome_controparte,
          g.val_ana_gre,
          x.cod_stato,
          x.cod_stato_precedente,
          x.cod_processo,
          x.cod_processo_pre,
          x.cod_comparto,
          x.cod_comparto_calcolato,
          x.cod_comparto_calcolato_pre,
          x.cod_ramo_calcolato,
          x.dta_utente_assegnato,
          NULL dta_utente_disass,
          x.dta_utente_assegnato dta_in_out
     FROM mv_mcre0_app_upd_field x,
          t_mcre0_app_anagrafica_gruppo ge,
          t_mcre0_app_anagr_gre g,
          mv_mcre0_app_istituti i
    WHERE     (TRUNC (SYSDATE) - x.dta_utente_assegnato) <= 15
          AND x.cod_sndg = ge.cod_sndg(+)
          AND x.cod_gruppo_economico = g.cod_gre(+)
          AND x.cod_stato IN (SELECT cod_microstato
                                FROM t_mcre0_app_stati s
                               WHERE s.flg_stato_chk = 1)
          AND x.cod_abi_istituto = i.cod_abi(+)
          AND NVL (x.flg_outsourcing, 'N') = 'Y'
          AND i.flg_target = 'Y'
   UNION ALL
   SELECT cod_abi_cartolarizzato,
          cod_abi_istituto,
          cod_ndg,
          id_utente,
          id_utente_pre,
          desc_nome_controparte,
          val_ana_gre,
          cod_stato,
          cod_stato_precedente,
          cod_processo,
          '' cod_processo_pre,
          cod_comparto,
          cod_comparto_calcolato,
          cod_comparto_calcolato_pre,
          '' cod_ramo_calcolato,
          NULL dta_utente_assegnato,
          dta_fine_validita dta_utente_disass,
          dta_fine_validita dta_in_out
     FROM (SELECT DISTINCT
                  cod_abi_cartolarizzato,
                  e.cod_abi_istituto,
                  cod_ndg,
                  NULL id_utente,
                  id_utente id_utente_pre,
                  ge.desc_nome_controparte,
                  g.val_ana_gre,
                  cod_stato,
                  cod_stato_precedente,
                  cod_processo,
                  '' cod_processo_pre,
                  NVL (e.cod_comparto_assegnato, e.cod_comparto_calcolato)
                     cod_comparto,
                  e.cod_comparto_calcolato,
                  e.cod_comparto_calcolato_pre,
                  '' cod_ramo_calcolato,
                  dta_fine_validita,
                  MAX (
                     dta_fine_validita)
                  OVER (
                     PARTITION BY cod_abi_cartolarizzato,
                                  cod_ndg,
                                  TRUNC (dta_fine_validita))
                     dta_fine_validita_max
             FROM t_mcre0_app_storico_eventi e,
                  t_mcre0_app_anagrafica_gruppo ge,
                  t_mcre0_app_anagr_gre g,
                  mv_mcre0_app_istituti i
            WHERE     flg_cambio_gestore = 1
                  AND TRUNC (dta_fine_validita) >= TRUNC (SYSDATE) - 15
                  AND e.cod_sndg = ge.cod_sndg(+)
                  AND e.cod_gruppo_economico = g.cod_gre(+)
                  AND NVL (i.flg_outsourcing, 'N') = 'Y'
                  AND i.flg_target = 'Y'
                  AND e.cod_abi_istituto = i.cod_abi(+)
                  AND e.cod_stato IN (SELECT cod_microstato
                                        FROM t_mcre0_app_stati s
                                       WHERE s.flg_stato_chk = 1))
    WHERE dta_fine_validita = dta_fine_validita_max;
