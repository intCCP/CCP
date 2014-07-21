/* Formatted on 21/07/2014 18:45:20 (QP5 v5.227.12220.39754) */
CREATE OR REPLACE FORCE VIEW MCRE_OWN.VNMCRE0_APP_ASS_POS_GESTORI
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
         x.cod_comparto cod_comparto_posizione,
          x.cod_abi_cartolarizzato,
          x.cod_ndg,
          x.cod_macrostato,
          x.id_utente,
          x.id_referente,
          x.cognome,
          -- NVL (u.cod_comparto_assegn, u.cod_comparto_appart)
          x.cod_comparto_utente
     FROM                     --mv_mcre0_app_upd_field x, t_mcre0_app_utenti u
         V_MCRE0_APP_UPD_FIELDS_P1 x
    WHERE                                        --  u.id_utente = x.id_utente
              -- AND x.id_utente IS NOT NULL
              x.id_utente <> -1
          --AND NVL (x.flg_outsourcing, 'N') = 'Y'
          AND X.FLG_OUTSOURCING = 'Y'
          --   AND X.FLG_STATO_CHK = '1'
          AND x.cod_stato IN (SELECT cod_microstato
                                FROM t_mcre0_app_stati s
                               WHERE s.flg_stato_chk = 1);
