/* Formatted on 21/07/2014 18:33:22 (QP5 v5.227.12220.39754) */
CREATE OR REPLACE FORCE VIEW MCRE_OWN.V_MCRE0_APP_COMUNIC_NEW_OUT
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
          X.COD_ABI_CARTOLARIZZATO,
          X.COD_ABI_ISTITUTO,
          X.COD_NDG,
          X.ID_UTENTE,
          NULL ID_UTENTE_PRE,
          X.DESC_NOME_CONTROPARTE,
          X.DESC_GRUPPO_ECONOMICO VAL_ANA_GRE,
          X.COD_STATO,
          X.COD_STATO_PRECEDENTE,
          X.COD_PROCESSO,
          X.COD_PROCESSO_PRE,
          X.COD_COMPARTO,
          X.COD_COMPARTO_CALCOLATO,
          X.COD_COMPARTO_CALCOLATO_PRE,
          X.COD_RAMO_CALCOLATO,
          X.DTA_UTENTE_ASSEGNATO,
          NULL DTA_UTENTE_DISASS,
          X.DTA_UTENTE_ASSEGNATO DTA_IN_OUT
     FROM V_MCRE0_APP_UPD_FIELDS X
    --          mv_mcre0_app_upd_field x,
    --          t_mcre0_app_anagrafica_gruppo ge,
    --          t_mcre0_app_anagr_gre g,
    --          mv_mcre0_app_istituti i
    WHERE               --    (TRUNC (SYSDATE) - x.dta_utente_assegnato) <= 15
          --   (TRUNC (SYSDATE) - x.dta_utente_assegnato) <= 15
          --    x.dta_utente_assegnato >=    (TRUNC (SYSDATE) - 15)
          X.DTA_UTENTE_ASSEGNATO >= TRUNC (SYSDATE) - 15 --          AND x.cod_sndg = ge.cod_sndg(+)
                         --          AND x.cod_gruppo_economico = g.cod_gre(+)
                         --          AND x.cod_stato IN (SELECT cod_microstato
                    --                                FROM t_mcre0_app_stati s
                   --                               WHERE s.flg_stato_chk = 1)
           AND X.FLG_CHK = '1' --          AND x.cod_abi_istituto = i.cod_abi(+)
                               --          AND NVL (x.flg_outsourcing, 'N') = 'Y'
          AND X.FLG_OUTSOURCING = 'Y'       --          AND i.flg_target = 'Y'
                                     AND X.FLG_TARGET = 'Y'
   UNION ALL
   SELECT COD_ABI_CARTOLARIZZATO,
          COD_ABI_ISTITUTO,
          COD_NDG,
          ID_UTENTE,
          ID_UTENTE_PRE,
          DESC_NOME_CONTROPARTE,
          VAL_ANA_GRE,
          COD_STATO,
          COD_STATO_PRECEDENTE,
          COD_PROCESSO,
          '' COD_PROCESSO_PRE,
          COD_COMPARTO,
          COD_COMPARTO_CALCOLATO,
          COD_COMPARTO_CALCOLATO_PRE,
          '' COD_RAMO_CALCOLATO,
          NULL DTA_UTENTE_ASSEGNATO,
          DTA_FINE_VALIDITA DTA_UTENTE_DISASS,
          DTA_FINE_VALIDITA DTA_IN_OUT
     FROM (SELECT /*+index(e IX2_T_MCRE0_APP_STORICO_EVENTI)  no_parallel(e)*/
                 DISTINCT
                  COD_ABI_CARTOLARIZZATO,
                  COD_ABI_ISTITUTO,
                  COD_NDG,
                  NULL ID_UTENTE,
                  ID_UTENTE ID_UTENTE_PRE,
                  DESC_NOME_CONTROPARTE,
                  VAL_ANA_GRE,
                  COD_STATO,
                  COD_STATO_PRECEDENTE,
                  COD_PROCESSO,
                  '' COD_PROCESSO_PRE,
                  NVL (E.COD_COMPARTO_ASSEGNATO, E.COD_COMPARTO_CALCOLATO)
                     COD_COMPARTO,
                  E.COD_COMPARTO_CALCOLATO,
                  E.COD_COMPARTO_CALCOLATO_PRE,
                  '' COD_RAMO_CALCOLATO,
                  DTA_FINE_VALIDITA,
                  MAX (
                     DTA_FINE_VALIDITA)
                  OVER (
                     PARTITION BY COD_ABI_CARTOLARIZZATO,
                                  COD_NDG,
                                  TRUNC (DTA_FINE_VALIDITA))
                     DTA_FINE_VALIDITA_MAX
             FROM T_MCRE0_APP_STORICO_EVENTI E,
                  --     t_mcre0_app_anagrafica_gruppo ge,
                  T_MCRE0_APP_ANAGR_GRE G,
                  --    mv_mcre0_app_istituti i
                  T_MCRE0_APP_STATI S
            WHERE     FLG_CAMBIO_GESTORE = '1'
                  --AND TRUNC (dta_fine_validita) >= TRUNC (SYSDATE) - 15
                  AND DTA_FINE_VAL_TR >= TRUNC (SYSDATE) - 15
                  AND S.FLG_STATO_CHK = 1
                  --    AND e.cod_sndg = ge.cod_sndg(+)
                  AND E.COD_GRUPPO_ECONOMICO = G.COD_GRE                 --(+)
                  --    AND NVL (i.flg_outsourcing, 'N') = 'Y'
                  --    AND i.flg_target = 'Y'
                  --    AND e.cod_abi_istituto = i.cod_abi(+)
                  AND E.COD_STATO = S.COD_MICROSTATO)
    WHERE DTA_FINE_VALIDITA = DTA_FINE_VALIDITA_MAX;
