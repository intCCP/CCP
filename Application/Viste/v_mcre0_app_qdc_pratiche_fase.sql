/* Formatted on 21/07/2014 18:35:03 (QP5 v5.227.12220.39754) */
CREATE OR REPLACE FORCE VIEW MCRE_OWN.V_MCRE0_APP_QDC_PRATICHE_FASE
(
   RECORD_CHAR
)
AS
   SELECT    TO_CHAR (SYSDATE, 'yyyymm')                             --id_dper
          || '00035'                                               --id_flusso
          || LPAD (TRIM (NVL (F.COD_ABI_CARTOLARIZZATO, 0)), 5, 0) --COD_ABI_CARTOLARIZZATO
          || LPAD (TRIM (NVL (F.COD_NDG, 0)), 16, 0)                 --COD_NDG
          || LPAD (NVL (F.ID_TIPOLOGIA_PRATICA, 0), 1, 0) --ID_TIPOLOGIA_PRATICA
          || LPAD (NVL (f.ID_FASE_GESTIONE, 0), 2, 0)       --ID_FASE_GESTIONE
          || RPAD (NVL (TRIM (TO_CHAR (F.DTA_INS, 'yyyymmdd')), 0), 8, ' ') --DTA_INS
          || RPAD (NVL (TRIM (TO_CHAR (F.DTA_SCADENZA, 'yyyymmdd')), 0),
                   8,
                   ' ')                                         --DTA_SCADENZA
          || LPAD (NVL (F.COD_STATO_RISCHIO, ' '), 2, ' ') --COD_STATO_RISCHIO
          || LPAD (NVL (F.COD_MACROSTATO, ' '), 2, ' ')       --COD_MACROSTATO
          || LPAD (NVL (F.FLG_ESITO_POSITIVO, ' '), 1, ' ') --FLG_ESITO_POSITIVO
          || LPAD (NVL (F.FLG_COMPLETATA, ' '), 1, ' ')       --FLG_COMPLETATA
          || RPAD (NVL (TRIM (F.NOTE), ' '), 600, ' ')                  --NOTE
          || LPAD (TRIM (NVL (f.COD_SNDG, 0)), 16, 0)               --COD_SNDG
          || LPAD (NVL (D.COD_COMPARTO_ASSEGNATO, D.COD_COMPARTO_CALCOLATO),
                   6,
                   ' ')                                         --COD_COMPARTO
          || LPAD (TRIM (NVL (F.COD_PRAT_FASE, 0)), 32, 0)     --COD_PRAT_FASE
          || LPAD (TRIM (NVL (F.ID_AZIONE, 0)), 5, 0)              --ID_AZIONE
          || RPAD (NVL (TRIM (TO_CHAR (F.DTA_UPD, 'yyyymmdd')), 0), 8, ' ') --DTA_UPD
          || RPAD (NVL (TRIM (TO_CHAR (f.DTA_DELETE, 'yyyymmdd')), 0),
                   8,
                   ' ')                                           --DTA_DELETE
          || LPAD (NVL (TRIM (F.FLG_DELETE), 'N'), 1, 'N')        --FLG_DELETE
     FROM T_MCRE0_APP_GEST_PRATICA_FASI f, t_mcre0_app_All_Data d
    WHERE     f.COD_ABI_CARTOLARIZZATO = d.COD_ABI_CARTOLARIZZATO
          AND f.cod_ndg = d.cod_ndg
   UNION
   SELECT DISTINCT
             SUBSTR (ID_DPER, 1, 6)
          || '00036'
          || LPAD (NVL (COD_ABI_OLD, '0'), 5, '0')
          || LPAD (NVL (COD_NDG_OLD, '0'), 16, '0')
          || LPAD (NVL (COD_ABI_NEW, '0'), 5, '0')
          || LPAD (NVL (COD_NDG_NEW, '0'), 16, '0')
             RECORD
     FROM MCRE_OWN.T_MCRE0_ST_MIG_RECODE_NDG
    WHERE SUBSTR (ID_DPER, 1, 6) = TO_NUMBER (TO_CHAR (SYSDATE, 'YYYYMM'));
