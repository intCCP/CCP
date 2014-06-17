/* Formatted on 17/06/2014 18:14:35 (QP5 v5.227.12220.39754) */
CREATE OR REPLACE FORCE VIEW MCRE_OWN.VOMCRE0_APP_SCHEDA_PERCORSI
(
   COD_ABI_CARTOLARIZZATO,
   COD_ABI_ISTITUTO,
   COD_NDG,
   COD_PERCORSO,
   COD_PROCESSO,
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
   FLG_MOPLE
)
AS
   SELECT SP.*,
          CASE WHEN MPL.COD_ABI_CARTOLARIZZATO IS NOT NULL THEN 1 ELSE 0 END
             AS FLG_MOPLE
     FROM (SELECT DISTINCT TFIN.COD_ABI_CARTOLARIZZATO,
                           TFIN.COD_ABI_ISTITUTO,
                           TFIN.COD_NDG,
                           TFIN.COD_PERCORSO,
                           TFIN.COD_PROCESSO,
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
                                          OTMP.COD_STATO_PRECEDENTE,
                                          OTMP.COD_STATO,
                                          OTMP.DTA_DECORRENZA_STATO,
                                          OTMP.DTA_SCADENZA_STATO
                             ORDER BY ORDINE)
                             NOME
                     --, m.tms
                     FROM (                                      -------------
                           SELECT M.COD_ABI_CARTOLARIZZATO,
                                  M.COD_ABI_ISTITUTO,
                                  M.COD_NDG,
                                  M.COD_PERCORSO,
                                  M.COD_PROCESSO,
                                  M.COD_STATO_PRECEDENTE,
                                  M.COD_STATO,
                                  M.DTA_DECORRENZA_STATO,
                                  M.DTA_SCADENZA_STATO,
                                     NVL (F.COD_COMPARTO_ASSEGNATO,
                                          F.COD_COMPARTO_CALCOLATO)
                                  || U.COD_MATRICOLA
                                     VAL_UNITA_OPERATIVA,
                                  F.ID_UTENTE,
                                  U.COGNOME,
                                  U.NOME                             --, m.tms
                                        ----
                                  ,
                                  2 ORDINE
                             FROM T_MCRE0_APP_MOPLE M
                                  INNER JOIN
                                  T_MCRE0_APP_FILE_GUIDA F
                                     ON (    F.COD_ABI_CARTOLARIZZATO =
                                                M.COD_ABI_CARTOLARIZZATO
                                         AND F.COD_NDG = M.COD_NDG)
                                  LEFT OUTER JOIN T_MCRE0_APP_UTENTI U
                                     ON (U.ID_UTENTE = F.ID_UTENTE)
                            WHERE 1 = 1
                           UNION
                           SELECT PTMP.COD_ABI_CARTOLARIZZATO,
                                  PTMP.COD_ABI_ISTITUTO,
                                  PTMP.COD_NDG,
                                  PTMP.COD_PERCORSO,
                                  PTMP.COD_PROCESSO,
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
                          TEV.COD_STATO_PRECEDENTE,
                          TEV.COD_STATO,
                          TEV.DTA_DECORRENZA_STATO,
                          TEV.DTA_SCADENZA_STATO,
                          TEV.VAL_UNITA_OPERATIVA,
                          TEV.ID_UTENTE,
                          TEV.COGNOME,
                          TEV.NOME
                     --, m.tms
                     FROM (SELECT OTMP.COD_ABI_CARTOLARIZZATO,
                                  OTMP.COD_ABI_ISTITUTO,
                                  OTMP.COD_NDG,
                                  OTMP.COD_PERCORSO,
                                  OTMP.COD_PROCESSO,
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
                                  LEFT OUTER JOIN T_MCRE0_APP_UTENTI U
                                     ON (U.ID_UTENTE = OTMP.ID_UTENTE)
                            WHERE     1 = 1
                                  AND OTMP.FLG_CAMBIO_STATO = 1
                                  AND OTMP.DTA_FINE_VALIDITA >
                                         TRUNC (SYSDATE) + 8 / 24) TEV
                    WHERE 1 = 1 AND TEV.ULTIMO_PERCORSO = TEV.COD_PERCORSO) TFIN) SP
          LEFT JOIN
          T_MCRE0_APP_MOPLE MPL
             ON     MPL.COD_ABI_CARTOLARIZZATO = SP.COD_ABI_CARTOLARIZZATO
                AND MPL.COD_NDG = SP.COD_NDG
                AND MPL.DTA_DECORRENZA_STATO = SP.DTA_DECORRENZA_STATO
                AND MPL.DTA_SCADENZA_STATO = SP.DTA_SCADENZA_STATO
                AND MPL.COD_STATO_PRECEDENTE = SP.COD_STATO_PRECEDENTE;


GRANT DELETE, INSERT, REFERENCES, SELECT, UPDATE, ON COMMIT REFRESH, QUERY REWRITE, DEBUG, FLASHBACK, MERGE VIEW ON MCRE_OWN.VOMCRE0_APP_SCHEDA_PERCORSI TO MCRE_USR;
