/* Formatted on 17/06/2014 18:14:48 (QP5 v5.227.12220.39754) */
CREATE OR REPLACE FORCE VIEW MCRE_OWN.VTMCRE0_APP_ALERT_HP_SUM
(
   COD_COMPARTO_POSIZIONE,
   COD_RAMO_CALCOLATO,
   COD_GRUPPO_COMPARTI,
   COD_PRIVILEGIO,
   ID_GRUPPO,
   ID_UTENTE,
   ID_REFERENTE,
   ALERT_VERDE,
   ALERT_ARANCIO,
   ALERT_ROSSO
)
AS
     SELECT a.cod_comparto_posizione,
            cod_ramo_calcolato,
            a.COD_GRUPPO_COMPARTI,                    --121108 post divisioni!
            a.cod_privilegio,
            a.id_gruppo,
            a.id_utente,
            a.id_referente,
            SUM (a.gb_v + a.in_v + a.pt_v + a.rio_v + a.sc_v + a.rs_v + a.so_v)
               alert_verde,
            SUM (a.gb_a + a.in_a + a.pt_a + a.rio_a + a.sc_a + a.rs_a + a.so_a)
               alert_arancio,
            SUM (a.gb_r + a.in_r + a.pt_r + a.rio_r + a.sc_r + a.rs_r + a.so_r)
               alert_rosso
       FROM vtmcre0_app_alert_cnt a
      WHERE cod_privilegio = 'A'
   GROUP BY a.cod_comparto_posizione,
            cod_ramo_calcolato,
            COD_GRUPPO_COMPARTI,
            cod_privilegio,
            id_gruppo,
            a.id_utente,
            a.id_referente;


GRANT DELETE, INSERT, REFERENCES, SELECT, UPDATE, ON COMMIT REFRESH, QUERY REWRITE, DEBUG, FLASHBACK ON MCRE_OWN.VTMCRE0_APP_ALERT_HP_SUM TO MCRE_USR;
