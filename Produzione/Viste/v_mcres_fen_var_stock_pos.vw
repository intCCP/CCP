/* Formatted on 17/06/2014 18:13:13 (QP5 v5.227.12220.39754) */
CREATE OR REPLACE FORCE VIEW MCRE_OWN.V_MCRES_FEN_VAR_STOCK_POS
(
   COD_ABI,
   VAL_ANNOMESE,
   VAL_VAR_AUMENTO_MESE,
   VAL_VAR_AUMENTO_TRIM,
   VAL_VAR_AUMENTO_ANNO,
   VAL_VAR_DIMINUZIONE_MESE,
   VAL_VAR_DIMINUZIONE_TRIM,
   VAL_VAR_DIMINUZIONE_ANNO,
   VAL_INCASSI_MESE,
   VAL_INCASSI_TRIM,
   VAL_INCASSI_ANNO,
   VAL_GBV_INIZIALE_MESE,
   VAL_GBV_INIZIALE_TRIM,
   VAL_GBV_INIZIALE_ANNO,
   VAL_GBV_FINALE_MESE,
   VAL_GBV_FINALE_TRIM,
   VAL_GBV_FINALE_ANNO,
   VAL_TMR_MESE,
   VAL_TMR_TRIM,
   VAL_TMR_ANNO,
   VAL_STOCK_MEDIO_ANNO,
   FLG_GAR_REALI_PERSONALI,
   FLG_GAR_REALI
)
AS
   WITH                                                        --VG 24/10/2011
       MOVIMENTI
        AS (  SELECT MOV.COD_ABI,
                     F.VAL_ANNOMESE,
                     SUM (
                        CASE
                           WHEN     UPPER (MOV.DESC_MODULO) IN
                                       ('ALL.1 - NUOVE SOFFERENZE DA INCAGLIO',
                                        'ALL.2 - NUOVE SOFFERENZE DA BONIS',
                                        'ALL.3 - ADDEBITI SU SOFFERENZE')
                                AND MOV.ID_DPER = F.ID_DPER
                           THEN
                              MOV.VAL_CR_TOT
                           ELSE
                              0
                        END)
                        VAL_VAR_AUMENTO_MESE,
                     SUM (
                        CASE
                           WHEN     UPPER (MOV.DESC_MODULO) IN
                                       ('ALL.1 - NUOVE SOFFERENZE DA INCAGLIO',
                                        'ALL.2 - NUOVE SOFFERENZE DA BONIS',
                                        'ALL.3 - ADDEBITI SU SOFFERENZE')
                                AND SUBSTR (MOV.ID_DPER, 1, 6) BETWEEN   TO_CHAR (
                                                                              TRUNC (
                                                                                   F.DTA_DPER
                                                                                 + 1,
                                                                                 'Q')
                                                                            - 1,
                                                                            'YYYYMM')
                                                                       - 2
                                                                   AND TO_CHAR (
                                                                            TRUNC (
                                                                                 F.DTA_DPER
                                                                               + 1,
                                                                               'Q')
                                                                          - 1,
                                                                          'YYYYMM')
                           THEN
                              MOV.VAL_CR_TOT
                           ELSE
                              0
                        END)
                        VAL_VAR_AUMENTO_TRIM,
                     SUM (
                        CASE
                           WHEN UPPER (MOV.DESC_MODULO) IN
                                   ('ALL.1 - NUOVE SOFFERENZE DA INCAGLIO',
                                    'ALL.2 - NUOVE SOFFERENZE DA BONIS',
                                    'ALL.3 - ADDEBITI SU SOFFERENZE')
                           THEN
                              MOV.VAL_CR_TOT
                           ELSE
                              0
                        END)
                        VAL_VAR_AUMENTO_ANNO,
                     SUM (
                        CASE
                           WHEN     UPPER (MOV.DESC_MODULO) IN
                                       ('ALL.5 - SOFFERENZE TRASFERITE A BONIS',
                                        'ALL.6 - SOFFERENZE ESTINTE',
                                        'ALL.7 - SOFFERENZE RIDOTTE',
                                        'ALL.8 - STRALCI SU SOFFERENZE')
                                AND MOV.ID_DPER = F.ID_DPER
                           THEN
                              MOV.VAL_CR_TOT
                           ELSE
                              0
                        END)
                        VAL_VAR_DIMINUZIONE_MESE,
                     SUM (
                        CASE
                           WHEN     UPPER (MOV.DESC_MODULO) IN
                                       ('ALL.5 - SOFFERENZE TRASFERITE A BONIS',
                                        'ALL.6 - SOFFERENZE ESTINTE',
                                        'ALL.7 - SOFFERENZE RIDOTTE',
                                        'ALL.8 - STRALCI SU SOFFERENZE')
                                AND SUBSTR (MOV.ID_DPER, 1, 6) BETWEEN   TO_CHAR (
                                                                              TRUNC (
                                                                                   F.DTA_DPER
                                                                                 + 1,
                                                                                 'Q')
                                                                            - 1,
                                                                            'YYYYMM')
                                                                       - 2
                                                                   AND TO_CHAR (
                                                                            TRUNC (
                                                                                 F.DTA_DPER
                                                                               + 1,
                                                                               'Q')
                                                                          - 1,
                                                                          'YYYYMM')
                           THEN
                              MOV.VAL_CR_TOT
                           ELSE
                              0
                        END)
                        VAL_VAR_DIMINUZIONE_TRIM,
                     SUM (
                        CASE
                           WHEN UPPER (MOV.DESC_MODULO) IN
                                   ('ALL.5 - SOFFERENZE TRASFERITE A BONIS',
                                    'ALL.6 - SOFFERENZE ESTINTE',
                                    'ALL.7 - SOFFERENZE RIDOTTE',
                                    'ALL.8 - STRALCI SU SOFFERENZE')
                           THEN
                              MOV.VAL_CR_TOT
                           ELSE
                              0
                        END)
                        VAL_VAR_DIMINUZIONE_ANNO,
                     SUM (
                        CASE
                           WHEN     UPPER (MOV.DESC_MODULO) IN
                                       ('ALL.6 - SOFFERENZE ESTINTE',
                                        'ALL.7 - SOFFERENZE RIDOTTE')
                                AND MOV.ID_DPER = F.ID_DPER
                           THEN
                              MOV.VAL_CR_TOT
                           ELSE
                              0
                        END)
                        VAL_INCASSI_MESE,
                     SUM (
                        CASE
                           WHEN     UPPER (MOV.DESC_MODULO) IN
                                       ('ALL.6 - SOFFERENZE ESTINTE',
                                        'ALL.7 - SOFFERENZE RIDOTTE')
                                AND SUBSTR (MOV.ID_DPER, 1, 6) BETWEEN   TO_CHAR (
                                                                              TRUNC (
                                                                                   F.DTA_DPER
                                                                                 + 1,
                                                                                 'Q')
                                                                            - 1,
                                                                            'YYYYMM')
                                                                       - 2
                                                                   AND TO_CHAR (
                                                                            TRUNC (
                                                                                 F.DTA_DPER
                                                                               + 1,
                                                                               'Q')
                                                                          - 1,
                                                                          'YYYYMM')
                           THEN
                              MOV.VAL_CR_TOT
                           ELSE
                              0
                        END)
                        VAL_INCASSI_TRIM,
                     SUM (
                        CASE
                           WHEN UPPER (MOV.DESC_MODULO) IN
                                   ('ALL.6 - SOFFERENZE ESTINTE',
                                    'ALL.7 - SOFFERENZE RIDOTTE')
                           THEN
                              MOV.VAL_CR_TOT
                           ELSE
                              0
                        END)
                        VAL_INCASSI_ANNO
                FROM T_MCRES_APP_MOVIMENTI_MOD_MOV MOV,
                     V_MCRES_ULTIMA_ACQ_FILE F
               WHERE     SUBSTR (MOV.ID_DPER, 1, 4) =
                            SUBSTR (F.VAL_ANNOMESE, 1, 4)
                     AND F.COD_ABI = MOV.COD_ABI
                     AND F.COD_FLUSSO = 'MOVIMENTI_MOD_MOV'
            GROUP BY MOV.COD_ABI, F.VAL_ANNOMESE),
        SISBA_CP
        AS (  SELECT CP.COD_ABI,
                     COUNT (DISTINCT CP.COD_NDG) VAL_stock_ANNO,
                     SUM (
                        CASE
                           WHEN SUBSTR (CP.ID_DPER, 1, 6) =
                                   (F.VAL_ANNO - 1) || '12' --FINE ULTIMO ANNO CONTABILIZZATO (OSSIA INIZIO ANNO IN
                           -- CORSO)
                           THEN
                              CP.VAL_UTI_RET
                           ELSE
                              0
                        END)
                        VAL_GBV_INIZIALE_ANNO,
                     SUM (
                        CASE
                           WHEN SUBSTR (CP.ID_DPER, 1, 6) =
                                   TO_CHAR (
                                      ADD_MONTHS (TRUNC (f.DTA_DPER, 'Q'), -4),
                                      'YYYYMM') --FINE PENULTIMO TRIMESTRE CONTABILIZZATO (
                           -- OSSIA
                           -- INIZIO ULIMO TRIMESTRE CONTABILIZZATO)
                           THEN
                              CP.VAL_UTI_RET
                           ELSE
                              0
                        END)
                        VAL_GBV_INIZIALE_TRIM,
                     SUM (
                        CASE
                           WHEN SUBSTR (CP.ID_DPER, 1, 6) =
                                   TO_CHAR (ADD_MONTHS (F.DTA_DPER, -1),
                                            'YYYYMM') --FINE PERNULTIMO MESE CONTABILIZZATO (OSSIA INIZIO
                           -- ULTIMO MESE CONTABILIZZATO)
                           THEN
                              CP.VAL_UTI_RET
                           ELSE
                              0
                        END)
                        VAL_GBV_INIZIALE_MESE,
                     SUM (CASE WHEN CP.ID_DPER = F.ID_DPER --FINE ULTIMO MESE CONTABILIZZATO (GBV
                                        -- FINAL ANCHE PER IL CALCOLO ANNUALE)
                           THEN CP.VAL_UTI_RET ELSE 0 END) VAL_GBV_FINALE,
                     SUM (
                        CASE
                           WHEN SUBSTR (CP.ID_DPER, 1, 6) =
                                   TO_CHAR (
                                      ADD_MONTHS (TRUNC (f.DTA_DPER, 'Q'), -1),
                                      'YYYYMM') --FINE ULTIMO TRIMESTRE CONTABILIZZATO
                           THEN
                              CP.VAL_UTI_RET
                           ELSE
                              0
                        END)
                        VAL_GBV_FINALE_TRIM,
                     SUBSTR (F.ID_DPER, 5, 2) + 1 NUM_MESI, --NUMERO MESI PER IL CALCOLO DEL
                       -- GBV MEDIO ANNUALE
                       SUBSTR (F.ID_DPER, 5, 2)
                     - MOD (SUBSTR (F.ID_DPER, 5, 2), 3)
                     + 1
                        NUM_MESI_TRIM, --NUMERO MESI PER IL CALCOLO DEL GBV MEDIO TRIMESTRALE
                     SUM (
                        CASE
                           WHEN SUBSTR (CP.ID_DPER, 1, 6) <=
                                   TO_CHAR (TRUNC (F.DTA_DPER + 1, 'Q') - 1,
                                            'YYYYMM')
                           THEN
                              CP.VAL_UTI_RET
                           ELSE
                              0
                        END)
                        VAL_GBV_TOTALE_TRIM, --TOTALE DA INIAZIO ANNO A FINE ULTIMO
                     -- TRIMESTRE CONTABILIZZATO (PER IL CALCOLO DEL TMR)
                     SUM (CP.VAL_UTI_RET) VAL_GBV_TOTALE_ANNO, --TOTALE DA INIZIO ANNO A FINE
                     -- ULTIMO MESE CONTABILIZZATO (PER IL CALCOLO DEL TMR)
                     CASE
                        WHEN (   NVL (S.VAL_IMP_GARANZIE_PERSONALI, 0) > 0
                              OR NVL (S.VAL_IMP_GARANZIA_IPOTECARIA, 0) > 0
                              OR NVL (S.VAL_IMP_GARANZIE_PIGNORATIZIE, 0) > 0)
                        THEN
                           1
                        ELSE
                           0
                     END
                        FLG_GAR_REALI_PERSONALI,
                     CASE
                        WHEN (   NVL (S.VAL_IMP_GARANZIE_PIGNORATIZIE, 0) > 0
                              OR NVL (S.VAL_IMP_GARANZIA_IPOTECARIA, 0) > 0)
                        THEN
                           1
                        ELSE
                           0
                     END
                        FLG_GAR_REALI
                FROM T_MCRES_APP_SISBA_CP CP,
                     T_MCRES_APP_SISBA S,
                     V_MCRES_ULTIMA_ACQ_FILE F
               WHERE     CP.COD_STATO_RISCHIO = 'S'
                     AND CP.VAL_FIRMA != 'FIRMA'
                     AND F.COD_FLUSSO = 'SISBA_CP'
                     AND CP.COD_ABI = F.COD_ABI
                     AND SUBSTR (CP.ID_DPER, 1, 6) >= (F.VAL_ANNO - 1) || '12'
                     AND CP.COD_ABI = S.COD_ABI(+)
                     AND CP.COD_NDG = S.COD_NDG(+)
                     AND CP.ID_DPER = S.ID_DPER(+)
                     AND CP.COD_RAPPORTO = S.COD_RAPPORTO_SISBA(+)
                     AND CP.COD_SPORTELLO = S.COD_FILIALE_RAPPORTO(+)
            GROUP BY CP.COD_ABI,
                     SUBSTR (F.ID_DPER, 5, 2) + 1,
                       SUBSTR (F.ID_DPER, 5, 2)
                     - MOD (SUBSTR (F.ID_DPER, 5, 2), 3)
                     + 1,
                     CASE
                        WHEN (   NVL (S.VAL_IMP_GARANZIE_PERSONALI, 0) > 0
                              OR NVL (S.VAL_IMP_GARANZIA_IPOTECARIA, 0) > 0
                              OR NVL (S.VAL_IMP_GARANZIE_PIGNORATIZIE, 0) > 0)
                        THEN
                           1
                        ELSE
                           0
                     END,
                     CASE
                        WHEN (   NVL (S.VAL_IMP_GARANZIE_PIGNORATIZIE, 0) > 0
                              OR NVL (S.VAL_IMP_GARANZIA_IPOTECARIA, 0) > 0)
                        THEN
                           1
                        ELSE
                           0
                     END)
   SELECT M.COD_ABI,
          M.VAL_ANNOMESE,
          M.VAL_VAR_AUMENTO_MESE,
          M.VAL_VAR_AUMENTO_TRIM,
          M.VAL_VAR_AUMENTO_ANNO,
          M.VAL_VAR_DIMINUZIONE_MESE,
          M.VAL_VAR_DIMINUZIONE_TRIM,
          M.VAL_VAR_DIMINUZIONE_ANNO,
          M.VAL_INCASSI_MESE,
          M.VAL_INCASSI_TRIM,
          M.VAL_INCASSI_ANNO,
          S.VAL_GBV_INIZIALE_MESE,
          S.VAL_GBV_INIZIALE_TRIM,
          S.VAL_GBV_INIZIALE_ANNO,
          S.VAL_GBV_FINALE VAL_GBV_FINALE_MESE,
          S.VAL_GBV_FINALE_TRIM,
          S.VAL_GBV_FINALE VAL_GBV_FINALE_ANNO,
            (  (  M.VAL_INCASSI_ANNO
                / (  DECODE (S.VAL_GBV_TOTALE_ANNO,
                             0, NULL,
                             S.VAL_GBV_TOTALE_ANNO)
                   / S.NUM_MESI))
             / S.NUM_MESI)
          * 12
             VAL_TMR_MESE,                                          --UGUALE A
            -- QUELLO ANNUALE!
            (  (  M.VAL_INCASSI_TRIM
                / (  DECODE (S.VAL_GBV_TOTALE_TRIM,
                             0, NULL,
                             S.VAL_GBV_TOTALE_TRIM)
                   / S.NUM_MESI_TRIM))
             / S.NUM_MESI_TRIM)
          * 12
          * 12
             VAL_TMR_TRIM,
            (  (  M.VAL_INCASSI_ANNO
                / (  DECODE (S.VAL_GBV_TOTALE_ANNO,
                             0, NULL,
                             S.VAL_GBV_TOTALE_ANNO)
                   / S.NUM_MESI))
             / S.NUM_MESI)
          * 12
             VAL_TMR_ANNO,
          VAL_STOCK_ANNO / S.NUM_MESI VAL_STOCK_MEDIO_ANNO,
          FLG_GAR_REALI_PERSONALI,
          FLG_GAR_REALI
     FROM MOVIMENTI M, SISBA_CP S
    WHERE M.COD_ABI = S.COD_ABI;


GRANT DELETE, INSERT, REFERENCES, SELECT, UPDATE, ON COMMIT REFRESH, QUERY REWRITE, DEBUG, FLASHBACK, MERGE VIEW ON MCRE_OWN.V_MCRES_FEN_VAR_STOCK_POS TO MCRE_USR;
