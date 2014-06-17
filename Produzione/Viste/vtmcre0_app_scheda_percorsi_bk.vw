/* Formatted on 17/06/2014 18:17:14 (QP5 v5.227.12220.39754) */
CREATE OR REPLACE FORCE VIEW MCRE_OWN.VTMCRE0_APP_SCHEDA_PERCORSI_BK
(
   COD_ABI_CARTOLARIZZATO,
   COD_ABI_ISTITUTO,
   COD_NDG,
   COD_PERCORSO,
   COD_PROCESSO,
   DTA_PROCESSO,
   COD_STATO_PRECEDENTE,
   COD_STATO,
   DTA_DECORRENZA_STATO,
   DTA_SCADENZA_STATO,
   VAL_UNITA_OPERATIVA,
   ID_UTENTE,
   COGNOME,
   NOME,
   TMS,
   FLG_ANNULLO,
   FLG_MOPLE,
   ESISTE_DEL_ATTIVA
)
AS
   SELECT   --110926: corretto nullif cod_stato, condizione su stati non nulli
          --111004: Escludo se stato GB
          --111114: MM aggiunto segnaposto ESISTE_DEL_ATTIVA (da calcolare)
          --120709: MM esposta dta_processo per ordinamento a video
          --130314: MM backup dell apercorsi attuale
          SP.COD_ABI_CARTOLARIZZATO,
          SP.COD_ABI_ISTITUTO,
          SP.COD_NDG,
          SP.COD_PERCORSO,
          SP.COD_PROCESSO,
          SP.DTA_PROCESSO,                                                --MM
          NULLIF (SP.COD_STATO_PRECEDENTE, '-1') COD_STATO_PRECEDENTE,
          NULLIF (SP.COD_STATO, '-1') COD_STATO,
          SP.DTA_DECORRENZA_STATO,
          SP.DTA_SCADENZA_STATO,
          SP.VAL_UNITA_OPERATIVA,
          NULLIF (SP.ID_UTENTE, -1) ID_UTENTE,
          SP.COGNOME,
          SP.NOME,
          SP.TMS,
          SP.FLG_ANNULLO,
          CASE WHEN MPL.COD_ABI_CARTOLARIZZATO IS NOT NULL THEN 1 ELSE 0 END
             AS FLG_MOPLE,
          'N' ESISTE_DEL_ATTIVA
     FROM (SELECT DISTINCT TFIN.COD_ABI_CARTOLARIZZATO,
                           TFIN.COD_ABI_ISTITUTO,
                           TFIN.COD_NDG,
                           TFIN.COD_PERCORSO,
                           TFIN.COD_PROCESSO,
                           TFIN.DTA_PROCESSO,                             --MM
                           TFIN.COD_STATO_PRECEDENTE,
                           TFIN.COD_STATO,
                           TFIN.DTA_DECORRENZA_STATO,
                           TFIN.DTA_SCADENZA_STATO,
                           TFIN.VAL_UNITA_OPERATIVA,
                           TFIN.ID_UTENTE,
                           TFIN.COGNOME,
                           TFIN.NOME,
                           TFIN.DTA_DECORRENZA_STATO TMS,
                           NULL FLG_ANNULLO
             FROM (                                         --Mople + Percorsi
                   SELECT DISTINCT
                          OTMP.COD_ABI_CARTOLARIZZATO,
                          OTMP.COD_ABI_ISTITUTO,
                          OTMP.COD_NDG,
                          OTMP.COD_PERCORSO,
                          OTMP.COD_PROCESSO,
                          OTMP.DTA_PROCESSO,                              --MM
                          OTMP.COD_STATO_PRECEDENTE,
                          OTMP.COD_STATO,
                          OTMP.DTA_DECORRENZA_STATO,
                          OTMP.DTA_SCADENZA_STATO,
                          FIRST_VALUE (
                             OTMP.VAL_UNITA_OPERATIVA)
                          OVER (
                             PARTITION BY OTMP.COD_ABI_CARTOLARIZZATO,
                                          OTMP.COD_ABI_ISTITUTO,
                                          OTMP.COD_NDG,
                                          OTMP.COD_PERCORSO,
                                          OTMP.COD_PROCESSO,
                                          OTMP.DTA_PROCESSO,              --MM
                                          OTMP.COD_STATO_PRECEDENTE,
                                          OTMP.COD_STATO,
                                          OTMP.DTA_DECORRENZA_STATO,
                                          OTMP.DTA_SCADENZA_STATO
                             ORDER BY ORDINE)
                             VAL_UNITA_OPERATIVA,
                          FIRST_VALUE (
                             OTMP.ID_UTENTE)
                          OVER (
                             PARTITION BY OTMP.COD_ABI_CARTOLARIZZATO,
                                          OTMP.COD_ABI_ISTITUTO,
                                          OTMP.COD_NDG,
                                          OTMP.COD_PERCORSO,
                                          OTMP.COD_PROCESSO,
                                          OTMP.DTA_PROCESSO,              --MM
                                          OTMP.COD_STATO_PRECEDENTE,
                                          OTMP.COD_STATO,
                                          OTMP.DTA_DECORRENZA_STATO,
                                          OTMP.DTA_SCADENZA_STATO
                             ORDER BY ORDINE)
                             ID_UTENTE,
                          FIRST_VALUE (
                             OTMP.COGNOME)
                          OVER (
                             PARTITION BY OTMP.COD_ABI_CARTOLARIZZATO,
                                          OTMP.COD_ABI_ISTITUTO,
                                          OTMP.COD_NDG,
                                          OTMP.COD_PERCORSO,
                                          OTMP.COD_PROCESSO,
                                          OTMP.DTA_PROCESSO,              --MM
                                          OTMP.COD_STATO_PRECEDENTE,
                                          OTMP.COD_STATO,
                                          OTMP.DTA_DECORRENZA_STATO,
                                          OTMP.DTA_SCADENZA_STATO
                             ORDER BY ORDINE)
                             COGNOME,
                          FIRST_VALUE (
                             OTMP.NOME)
                          OVER (
                             PARTITION BY OTMP.COD_ABI_CARTOLARIZZATO,
                                          OTMP.COD_ABI_ISTITUTO,
                                          OTMP.COD_NDG,
                                          OTMP.COD_PERCORSO,
                                          OTMP.COD_PROCESSO,
                                          OTMP.DTA_PROCESSO,              --MM
                                          OTMP.COD_STATO_PRECEDENTE,
                                          OTMP.COD_STATO,
                                          OTMP.DTA_DECORRENZA_STATO,
                                          OTMP.DTA_SCADENZA_STATO
                             ORDER BY ORDINE)
                             NOME
                     --, m.tms
                     FROM (                                      -------------
                           SELECT COD_ABI_CARTOLARIZZATO,
                                  COD_ABI_ISTITUTO,
                                  COD_NDG,
                                  COD_PERCORSO,
                                  COD_PROCESSO,
                                  DTA_PROCESSO,                           --MM
                                  COD_STATO_PRECEDENTE,
                                  COD_STATO,
                                  DTA_DECORRENZA_STATO,
                                  DTA_SCADENZA_STATO,
                                     NVL (COD_COMPARTO_ASSEGNATO,
                                          COD_COMPARTO_CALCOLATO)
                                  || COD_MATRICOLA
                                     VAL_UNITA_OPERATIVA,
                                  V.ID_UTENTE,
                                  COGNOME,
                                  NOME                                 --, tms
                                      ----
                                  ,
                                  2 ORDINE
                             FROM VTMCRE0_APP_UPD_FIELDS_PALL V,
                                  T_MCRE0_APP_UTENTI U
                            WHERE V.ID_UTENTE = U.ID_UTENTE(+)
                           UNION
                           SELECT PTMP.COD_ABI_CARTOLARIZZATO,
                                  PTMP.COD_ABI_ISTITUTO,
                                  PTMP.COD_NDG,
                                  PTMP.COD_PERCORSO,
                                  PTMP.COD_PROCESSO,
                                  PTMP.DTA_PROCESSO,                      --MM
                                  PTMP.COD_STATO_PRECEDENTE,
                                  PTMP.COD_STATO,
                                  PTMP.DTA_DECORRENZA_STATO,
                                  PTMP.DTA_SCADENZA_STATO,
                                  PTMP.VAL_UNITA_OPERATIVA,
                                  PTMP.ID_UTENTE,
                                  PTMP.COGNOME,
                                  PTMP.NOME                       --, ptmp.tms
                                           ,
                                  PTMP.ORDINE
                             FROM (SELECT P.COD_ABI_CARTOLARIZZATO,
                                          P.COD_ABI_ISTITUTO,
                                          P.COD_NDG,
                                          P.COD_PERCORSO,
                                          P.COD_PROCESSO,
                                          P.DTA_PROCESSO,                 --MM
                                          P.COD_STATO_PRECEDENTE,
                                          P.COD_STATO,
                                          P.DTA_DECORRENZA_STATO,
                                          P.DTA_SCADENZA_STATO,
                                          P.COD_CODUTRM VAL_UNITA_OPERATIVA,
                                          U.ID_UTENTE,
                                          U.COGNOME,
                                          U.NOME                     --, m.tms
                                                ----
                                          ,
                                          MAX (
                                             P.COD_PERCORSO)
                                          OVER (
                                             PARTITION BY P.COD_ABI_CARTOLARIZZATO,
                                                          P.COD_NDG)
                                             ULTIMO_PERCORSO,
                                          1 ORDINE
                                     FROM T_MCRE0_APP_PERCORSI P
                                          INNER JOIN
                                          T_MCRE0_APP_UTENTI U
                                             ON (SUBSTR (P.COD_CODUTRM, 7) =
                                                    U.COD_MATRICOLA(+))) PTMP
                            WHERE 1 = 1) OTMP
                   --------------------------------------------------------
                   UNION
                   --Storico Eventi
                   SELECT TEV.COD_ABI_CARTOLARIZZATO,
                          TEV.COD_ABI_ISTITUTO,
                          TEV.COD_NDG,
                          TEV.COD_PERCORSO,
                          TEV.COD_PROCESSO,
                          TEV.DTA_PROCESSO,                               --MM
                          TEV.COD_STATO_PRECEDENTE,
                          TEV.COD_STATO,
                          TEV.DTA_DECORRENZA_STATO,
                          TEV.DTA_SCADENZA_STATO,
                          TEV.VAL_UNITA_OPERATIVA,
                          TEV.ID_UTENTE,
                          TEV.COGNOME,
                          TEV.NOME
                     --, m.tms
                     FROM (SELECT /*+index(otmp IX2_T_MCRE0_APP_STORICO_EVENTI) no_parallel(otmp)
       no_parallel(u)*/
                                 OTMP.COD_ABI_CARTOLARIZZATO,
                                  OTMP.COD_ABI_ISTITUTO,
                                  OTMP.COD_NDG,
                                  OTMP.COD_PERCORSO,
                                  OTMP.COD_PROCESSO,
                                  OTMP.DTA_PROCESSO,                      --MM
                                  OTMP.COD_STATO_PRECEDENTE,
                                  OTMP.COD_STATO,
                                  /*otmp.dta_fine_validita*/
                                  DTA_DECORRENZA_STATO
                                     AS DTA_DECORRENZA_STATO,
                                  OTMP.DTA_SCADENZA_STATO,
                                     NVL (OTMP.COD_COMPARTO_ASSEGNATO,
                                          OTMP.COD_COMPARTO_CALCOLATO)
                                  || U.COD_MATRICOLA
                                     VAL_UNITA_OPERATIVA,
                                  U.ID_UTENTE,
                                  U.COGNOME,
                                  U.NOME                          --, otmp.tms
                                        ,
                                  MAX (
                                     OTMP.COD_PERCORSO)
                                  OVER (
                                     PARTITION BY OTMP.COD_ABI_CARTOLARIZZATO,
                                                  OTMP.COD_NDG)
                                     ULTIMO_PERCORSO
                             FROM T_MCRE0_APP_STORICO_EVENTI OTMP
                                  INNER JOIN T_MCRE0_APP_UTENTI U
                                     ON (U.ID_UTENTE = OTMP.ID_UTENTE)
                            WHERE     OTMP.FLG_CAMBIO_STATO = '1'
                                  AND OTMP.DTA_FINE_VALIDITA >
                                         TRUNC (SYSDATE) + 8 / 24
                                  AND OTMP.DTA_FINE_VAL_TR = TRUNC (SYSDATE)) TEV
                    WHERE 1 = 1 AND TEV.ULTIMO_PERCORSO = TEV.COD_PERCORSO) TFIN) SP
          LEFT JOIN
          T_MCRE0_APP_ALL_DATA MPL
             ON     MPL.COD_ABI_CARTOLARIZZATO = SP.COD_ABI_CARTOLARIZZATO
                AND MPL.COD_NDG = SP.COD_NDG
                AND MPL.DTA_DECORRENZA_STATO = SP.DTA_DECORRENZA_STATO
                AND MPL.DTA_SCADENZA_STATO = SP.DTA_SCADENZA_STATO
                AND MPL.COD_STATO_PRECEDENTE = SP.COD_STATO_PRECEDENTE
    WHERE     NOT (SP.COD_STATO = '-1' AND SP.COD_STATO_PRECEDENTE = '-1')
          AND SP.COD_STATO != 'GB';


GRANT DELETE, INSERT, REFERENCES, SELECT, UPDATE, ON COMMIT REFRESH, QUERY REWRITE, DEBUG, FLASHBACK ON MCRE_OWN.VTMCRE0_APP_SCHEDA_PERCORSI_BK TO MCRE_USR;
