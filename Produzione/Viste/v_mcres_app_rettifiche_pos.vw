/* Formatted on 17/06/2014 18:11:14 (QP5 v5.227.12220.39754) */
CREATE OR REPLACE FORCE VIEW MCRE_OWN.V_MCRES_APP_RETTIFICHE_POS
(
   COD_ABI,
   COD_NDG,
   COD_SNDG,
   COD_GRUPPO_ECONOMICO,
   DESC_NOME_CONTROPARTE,
   VAL_ANA_GRE,
   COD_PRESIDIO,
   VAL_ANNOMESE,
   COD_Q,
   VAL_RETTIFICA_NETTA,
   VAL_ANNOMESE_DRC_CONT,
   VAL_ANNOMESE_DRC_DACONT,
   FLG_GAR_REALI_PERSONALI,
   FLG_GAR_REALI
)
AS
     SELECT COD_ABI,
            COD_NDG,
            p.COD_SNDG,
            N.COD_GRUPPO_ECONOMICO,
            G.DESC_NOME_CONTROPARTE,
            C.VAL_ANA_GRE,
            p.cod_presidio,
            VAL_ANNOMESE,
            COD_Q,
            SUM (VAL_RETTIFICA_NETTA) VAL_RETTIFICA_NETTA,
            VAL_ANNOMESE_DRC_CONT,
            VAL_ANNOMESE_DRC_DACONT,
            FLG_GAR_REALI_PERSONALI,
            FLG_GAR_REALI
       FROM (  SELECT R.COD_ABI,
                      R.COD_NDG,
                      COD_SNDG,
                      R.COD_DIVISIONE,
                      cod_presidio,
                      TO_NUMBER (
                         SUBSTR (SYS_CONTEXT ('userenv', 'client_info'), 1, 6))
                         val_annomese,
                      TO_NUMBER (TO_CHAR (TO_DATE (val_annomese, 'yyyymm'), 'Q'))
                         cod_q,
                      TO_NUMBER (
                         TO_CHAR (
                              ADD_MONTHS (
                                 TRUNC (TO_DATE (val_annomese, 'yyyymm'), 'Q'),
                                 3)
                            - 1,
                            'YYYYMM'))
                         fine_number,
                      SUM (R.VAL_RETTIFICA_NETTA) VAL_RETTIFICA_NETTA,
                      r.FLG_GAR_REALI,
                      r.FLG_GAR_REALI_PERSONALI,
                      TO_NUMBER (NULL) VAL_ANNOMESE_DRC_CONT,
                      TO_NUMBER (NULL) VAL_ANNOMESE_DRC_DACONT
                 FROM t_mcres_fen_rettifiche_pos_m r
                WHERE     r.flg_gruppo = 1
                      AND val_annomese BETWEEN    SUBSTR (
                                                     SYS_CONTEXT ('userenv',
                                                                  'client_info'),
                                                     1,
                                                     4)
                                               || '01'
                                           AND SUBSTR (
                                                  SYS_CONTEXT ('userenv',
                                                               'client_info'),
                                                  1,
                                                  6)
                      AND cod_abi =
                             SUBSTR (SYS_CONTEXT ('userenv', 'client_info'),
                                     7,
                                     5)
             GROUP BY R.COD_ABI,
                      R.COD_NDG,
                      COD_SNDG,
                      R.COD_DIVISIONE,
                      cod_presidio,
                      SUBSTR (SYS_CONTEXT ('userenv', 'client_info'), 1, 6),
                      TO_CHAR (TO_DATE (val_annomese, 'yyyymm'), 'Q'),
                        ADD_MONTHS (
                           TRUNC (TO_DATE (val_annomese, 'yyyymm'), 'Q'),
                           3)
                      - 1,
                      r.flg_gar_reali,
                      r.FLG_GAR_REALI_PERSONALI
             UNION ALL
             SELECT e.COD_ABI,
                    E.COD_NDG,
                    COD_SNDG,
                    E.COD_DIVISIONE,
                    cod_presidio,
                    E.VAL_ANNOMESE,
                    5 COD_Q,
                    VAL_ANNOMESE FINE_NUMBER,
                    E.VAL_RETTIFICA_NETTA,
                    E.FLG_GAR_REALI,
                    E.FLG_GAR_REALI_PERSONALI,
                    TO_NUMBER (NULL) VAL_ANNOMESE_DRC_CONT,
                    TO_NUMBER (NULL) VAL_ANNOMESE_DRC_DACONT
               FROM T_MCRES_FEN_RETTIFICHE_POS_M e
              WHERE     flg_gruppo = 1
                    AND cod_abi =
                           SUBSTR (SYS_CONTEXT ('userenv', 'client_info'),
                                   7,
                                   5)
             UNION ALL
             SELECT e.COD_ABI,
                    E.COD_NDG,
                    COD_SNDG,
                    E.COD_DIVISIONE,
                    cod_presidio,
                    E.VAL_ANNOMESE,
                    CASE
                       WHEN E.FLG_GRUPPO = 4 THEN 8
                       WHEN E.FLG_GRUPPO = 5 THEN 9
                    END
                       COD_Q,
                    VAL_ANNOMESE FINE_NUMBER,
                    E.VAL_RETTIFICA_NETTA,
                    E.FLG_GAR_REALI,
                    E.FLG_GAR_REALI_PERSONALI,
                    VAL_ANNOMESE_DRC_CONT,
                    VAL_ANNOMESE_DRC_DACONT
               FROM T_MCRES_FEN_RETTIFICHE_POS_M e
              WHERE     flg_gruppo IN (4, 5)
                    AND cod_abi =
                           SUBSTR (SYS_CONTEXT ('userenv', 'client_info'),
                                   7,
                                   5)
             UNION ALL
             SELECT e.COD_ABI,
                    E.COD_NDG,
                    COD_SNDG,
                    E.COD_DIVISIONE,
                    cod_presidio,
                    E.VAL_ANNOMESE,
                    CASE
                       WHEN E.FLG_GRUPPO = 2 THEN 6
                       WHEN E.FLG_GRUPPO = 3 THEN 7
                       WHEN E.FLG_GRUPPO = 4 THEN 8
                       WHEN E.FLG_GRUPPO = 5 THEN 9
                       WHEN E.FLG_GRUPPO = 6 THEN 10
                    END
                       COD_Q,
                    VAL_ANNOMESE FINE_NUMBER,
                    E.VAL_RETTIFICA_NETTA,
                    E.FLG_GAR_REALI,
                    E.FLG_GAR_REALI_PERSONALI,
                    VAL_ANNOMESE_DRC_CONT,
                    VAL_ANNOMESE_DRC_DACONT
               FROM T_MCRES_FEN_RETTIFICHE_POS_D E
              WHERE     e.flg_gruppo IN (2, 3, 6)
                    AND cod_abi =
                           SUBSTR (SYS_CONTEXT ('userenv', 'client_info'),
                                   7,
                                   5)) P,
            T_MCRE0_APP_ANAGRAFICA_GRUPPO G,
            T_MCRE0_APP_GRUPPO_ECONOMICO n,
            T_MCRE0_APP_ANAGR_GRE C
      WHERE     P.COD_SNDG = G.COD_SNDG(+)
            AND P.COD_SNDG = N.COD_SNDG(+)
            AND N.COD_GRUPPO_ECONOMICO = C.COD_GRE(+)
   GROUP BY COD_ABI,
            COD_NDG,
            p.COD_SNDG,
            N.COD_GRUPPO_ECONOMICO,
            G.DESC_NOME_CONTROPARTE,
            C.VAL_ANA_GRE,
            p.cod_presidio,
            VAL_ANNOMESE,
            COD_Q,
            VAL_ANNOMESE_DRC_CONT,
            VAL_ANNOMESE_DRC_DACONT,
            flg_gar_reali_personali,
            FLG_GAR_REALI;


GRANT DELETE, INSERT, REFERENCES, SELECT, UPDATE, ON COMMIT REFRESH, QUERY REWRITE, DEBUG, FLASHBACK, MERGE VIEW ON MCRE_OWN.V_MCRES_APP_RETTIFICHE_POS TO MCRE_USR;
