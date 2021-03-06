/* Formatted on 21/07/2014 18:46:05 (QP5 v5.227.12220.39754) */
CREATE OR REPLACE FORCE VIEW MCRE_OWN.VOMCRE0_APP_ASS_POS_GESTORI
(
   COD_COMPARTO_POSIZIONE,
   COD_ABI_CARTOLARIZZATO,
   COD_NDG,
   COD_MACROSTATO,
   ID_UTENTE,
   ID_REFERENTE,
   COGNOME,
   COD_COMPARTO_UTENTE
)
AS
   SELECT                            --v1.1 27.04 MM: aggiunto comparto_utente
         X.COD_COMPARTO COD_COMPARTO_POSIZIONE,
          X.COD_ABI_CARTOLARIZZATO,
          X.COD_NDG,
          X.COD_MACROSTATO,
          X.ID_UTENTE,
          U.ID_REFERENTE,
          COGNOME,
          NVL (U.COD_COMPARTO_ASSEGN, U.COD_COMPARTO_APPART)
             COD_COMPARTO_UTENTE
     FROM MV_MCRE0_APP_UPD_FIELD X, T_MCRE0_APP_UTENTI U
    WHERE     U.ID_UTENTE = X.ID_UTENTE
          AND X.ID_UTENTE IS NOT NULL
          AND NVL (X.FLG_OUTSOURCING, 'N') = 'Y'
          AND X.COD_STATO IN (SELECT COD_MICROSTATO
                                FROM T_MCRE0_APP_STATI S
                               WHERE S.FLG_STATO_CHK = 1);
