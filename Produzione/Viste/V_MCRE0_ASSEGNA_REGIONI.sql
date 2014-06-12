CREATE OR REPLACE FORCE VIEW V_MCRE0_ASSEGNA_REGIONI
(
   MX,
   ID_UTENTE_ASSEGNATO,
   ID_UTENTE_ASSEGNATO_PT,
   COD_GRUPPO_SUPER,
   COD_COMPARTO_CALCOLATO,
   ID_UTENTE,
   COD_ABI_CARTOLARIZZATO,
   COD_NDG,
   COD_SNDG,
   COD_FILIALE,
   COD_STATO,
   VAL_DEC,
   ID_CORR,
   COD_PROCESSO
)
AS
   SELECT MAX (v.val_dec) OVER (PARTITION BY cod_gruppo_super) AS mx,
          v.id_utente_assegnato,
          v.id_utente_assegnato_pt,
          v.cod_gruppo_super,
          v.cod_comparto_calcolato,
          v.id_utente,
          v.cod_abi_cartolarizzato,
          v.cod_ndg,
          v.cod_sndg,
          v.cod_filiale,
          v.cod_stato,
          v.val_dec,
          CASE
             --    WHEN V.VAL_DEC = MAX (V.VAL_DEC) OVER (PARTITION BY COD_GRUPPO_SUPER) --old
             --mm 05/07 variato test
             WHEN MAX (v.val_dec) OVER (PARTITION BY cod_gruppo_super) > 1
             THEN
                v.id_utente_assegnato
             ELSE
                v.id_utente_assegnato_pt
          END
             ID_CORR,
          v.cod_processo
     FROM (SELECT DECODE (x.cod_processo,
                          '*', p_merge.cod_processo,
                          x.cod_processo)
                     AS cod_processo,
                  x.id_utente_assegnato,
                  x.id_utente_assegnato_pt,
                  x.cod_struttura_competente_fi,
                  x.cod_abi_istituto,
                  p_merge.cod_gruppo_super,
                  p_merge.cod_comparto_calcolato,
                  p_merge.id_utente,
                  p_merge.cod_abi_cartolarizzato,
                  p_merge.cod_ndg,
                  p_merge.cod_sndg,
                  p_merge.cod_filiale,
                  p_merge.cod_stato,
                  p_merge.val_ordine,
                  p_merge.flg_active,
                  p_merge.val_dec
             FROM t_mcre0_app_associa_gestori_uo x,
                  (SELECT a.cod_processo,
                          a.cod_gruppo_super,
                          a.cod_comparto_calcolato,
                          a.id_utente,
                          a.cod_abi_cartolarizzato,
                          a.cod_ndg,
                          a.cod_sndg,
                          a.cod_filiale,
                          a.cod_stato,
                          s.val_ordine,
                          '1' FLG_ACTIVE,
                          DECODE (NVL (S.VAL_ORDINE, '0'),  10, 1,  0, 1,  2)
                             AS VAL_DEC
                     FROM T_MCRE0_APP_STATI S, t_mcre0_all_data a
                    WHERE     a.ID_UTENTE = -1
                          AND A.FLG_ACTIVE = '1'
                          AND S.COD_MICROSTATO = A.COD_STATO
                          --DA TESTARE!!!
                          AND S.FLG_STATO_CHK = '1'
                          AND A.FLG_OUTSOURCING = 'Y'
                          --
                          AND (   MCRE_OWN.FNC_MCREI_IS_NUMERIC (
                                     a.COD_GRUPPO_SUPER) = 1
                               --mc 27/05/14 OR aggiunto per variazione perimetro DR
                               OR EXISTS
                                     (SELECT DISTINCT
                                             cod_struttura_competente
                                        FROM t_mcre0_app_struttura_org
                                       WHERE     cod_livello IN ('AR', 'DI')
                                             AND cod_comparto =
                                                    NVL (
                                                       a.cod_comparto_assegnato,
                                                       a.cod_comparto_calcolato)
                                             AND cod_struttura_competente =
                                                    '01911'))) P_MERGE
            WHERE     X.COD_ABI_ISTITUTO = P_MERGE.COD_ABI_CARTOLARIZZATO
                  AND X.COD_STRUTTURA_COMPETENTE_FI = P_MERGE.COD_FILIALE
                  AND X.COD_COMPARTO_ASSEGNATARIO =
                         SUBSTR (P_MERGE.COD_COMPARTO_CALCOLATO, -5, 5) --0612
                  AND X.FLG_ATTIVO = '1'
                  -------------DR-------------
                  AND DECODE (X.cod_processo, '*', '1', x.cod_processo) =
                         DECODE (X.cod_processo,
                                 '*', '1',
                                 p_merge.cod_processo)) v;
