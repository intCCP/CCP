/* Formatted on 21/07/2014 18:43:27 (QP5 v5.227.12220.39754) */
CREATE OR REPLACE FORCE VIEW MCRE_OWN.V_MCRES_APP_ULTIMO_ANMEABI
(
   COD_ABI,
   VAL_ANNOMESE,
   VAL_ANNOMESE_SISBA_CP,
   VAL_ANNOMESE_SISBA_CP_PREC,
   VAL_ANNOMESE_SISBA,
   VAL_ANNOMESE_SISBA_PREC,
   VAL_ANNOMESE_FINE_ANNO,
   VAL_ANNOMESE_ULTIMO_SISBA,
   VAL_ANNOMESE_PENULTIMO_SISBA,
   VAL_ANNOMESE_PENULTIMO_CP,
   VAL_ANNOMESE_ULTIMO_SISBA_CP,
   VAL_ANNOMESE_START_LAST_Q_CONT,
   VAL_ANNOMESE_END_LAST_Q_CONT
)
AS
   SELECT CP.COD_ABI,
          CP.VAL_ANNOMESE,
          CASE
             WHEN CP.VAL_ANNOMESE < S.VAL_ANNOMESE THEN CP.VAL_ANNOMESE
             ELSE TO_CHAR (ADD_MONTHS (CP.DTA_DPER, -1), 'YYYYMM')
          END
             VAL_ANNOMESE_SISBA_CP, --Di riferimento per le rettifiche, "quasi
          -- sempre" il mese precedente a quello dell'ultimo SISBA
          CASE
             WHEN CP.VAL_ANNOMESE < S.VAL_ANNOMESE
             THEN
                TO_CHAR (ADD_MONTHS (CP.DTA_DPER, -1), 'YYYYMM')
             ELSE
                TO_CHAR (ADD_MONTHS (CP.DTA_DPER, -2), 'YYYYMM')
          END
             VAL_ANNOMESE_SISBA_CP_PREC,    --Precedente a quello di cui sopra
          CASE
             WHEN CP.VAL_ANNOMESE < S.VAL_ANNOMESE
             THEN
                TO_CHAR (ADD_MONTHS (CP.DTA_DPER, 1), 'YYYYMM')
             ELSE
                S.VAL_ANNOMESE
          END
             VAL_ANNOMESE_SISBA, --Di riferimeto per le rettifiche, "quasi sempre"
          -- coincide con quello dell'ultimo SISBA arrivato
          CASE
             WHEN CP.VAL_ANNOMESE < S.VAL_ANNOMESE THEN CP.VAL_ANNOMESE
             ELSE TO_CHAR (ADD_MONTHS (S.DTA_DPER, -1), 'YYYYMM')
          END
             VAL_ANNOMESE_SISBA_PREC,       --Predecente a quello di cui sopra
          (CP.VAL_ANNO - 1) || '12' VAL_ANNOMESE_FINE_ANNO, --Fine dell'ultimo anno di bilancio
          S.VAL_ANNOMESE VAL_ANNOMESE_ULTIMO_SISBA,   --Dell'ultimo SISBA (non
          -- necessariamente coicidente con VAL_ANNOMESE_SISBA)
          TO_CHAR (ADD_MONTHS (s.DTA_DPER, -1), 'YYYYMM')
             VAL_ANNOMESE_PENULTIMO_SISBA,
          TO_CHAR (ADD_MONTHS (cp.DTA_DPER, -1), 'YYYYMM')
             VAL_ANNOMESE_PENULTIMO_CP,
          CP.VAL_ANNOMESE VAL_ANNOMESE_ULTIMO_SISBA_CP,
          TO_CHAR (TRUNC (cp.DTA_DPER + 1, 'Q') - 1, 'YYYYMM') - 2
             val_annomese_start_last_q_cont, --Inizio ultimo trimestre contabilizzato
          TO_CHAR (TRUNC (cp.DTA_DPER + 1, 'Q') - 1, 'YYYYMM')
             val_annomese_end_last_q_cont --Fine ultimo trimestre contabilizzato
     FROM (SELECT DISTINCT COD_FILE,
                           W.COD_ABI,
                           W.COD_FLUSSO,
                           ID_FLUSSO,
                           TRUNC (id_dper) DTA_DPER,
                           TO_CHAR (ID_DPER, 'YYYYMMDD') ID_DPER,
                           TO_CHAR (ID_DPER, 'YYYYMM') VAL_ANNOMESE,
                           TO_CHAR (ID_DPER, 'YYYY') VAL_ANNO
             FROM MCRE_OWN.T_MCRES_WRK_ACQUISIZIONE W
            WHERE     COD_STATO IN ('CARICATO', 'CARICATO_APP')
                  AND COD_FLUSSO = 'SISBA') S,
          (SELECT DISTINCT COD_FILE,
                           W.COD_ABI,
                           W.COD_FLUSSO,
                           ID_FLUSSO,
                           TRUNC (id_dper) DTA_DPER,
                           TO_CHAR (ID_DPER, 'YYYYMMDD') ID_DPER,
                           TO_CHAR (ID_DPER, 'YYYYMM') VAL_ANNOMESE,
                           TO_CHAR (ID_DPER, 'YYYY') VAL_ANNO
             FROM MCRE_OWN.T_MCRES_WRK_ACQUISIZIONE W
            WHERE     COD_STATO IN ('CARICATO', 'CARICATO_APP')
                  AND COD_FLUSSO IN ('SISBA_CP', 'MCRDSISBACP')) CP
    WHERE cp.COD_ABI = s.COD_ABI(+);
