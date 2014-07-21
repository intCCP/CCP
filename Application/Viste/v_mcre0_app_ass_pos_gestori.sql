/* Formatted on 21/07/2014 18:33:19 (QP5 v5.227.12220.39754) */
CREATE OR REPLACE FORCE VIEW MCRE_OWN.V_MCRE0_APP_ASS_POS_GESTORI
(
   COD_COMPARTO_POSIZIONE,
   COD_ABI_CARTOLARIZZATO,
   COD_NDG,
   COD_MACROSTATO,
   ID_UTENTE,
   ID_REFERENTE,
   COGNOME,
   NOME,
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
          U.COGNOME,
          U.NOME,
          -- NVL (u.cod_comparto_assegn, u.cod_comparto_appart)
          U.COD_COMPARTO_UTENTE
     FROM                                          --mv_mcre0_app_upd_field x,
         V_MCRE0_APP_UPD_FIELDS_P1 X,
          T_MCRE0_APP_UTENTI U,
          T_MCRE0_APP_STATI S
    WHERE                                        --  u.id_utente = x.id_utente
         X    .FLG_OUTSOURCING = 'Y'
          AND X.COD_STATO = COD_MICROSTATO
          AND S.FLG_STATO_CHK = '1'
          AND X.ID_UTENTE = U.ID_UTENTE
          AND X.ID_UTENTE <> -1;
