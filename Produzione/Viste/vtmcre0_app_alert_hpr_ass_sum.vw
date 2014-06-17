/* Formatted on 17/06/2014 18:14:49 (QP5 v5.227.12220.39754) */
CREATE OR REPLACE FORCE VIEW MCRE_OWN.VTMCRE0_APP_ALERT_HPR_ASS_SUM
(
   ID_REFERENTE,
   ID_UTENTE,
   COD_COMPARTO_UTENTE,
   COD_COMPARTO_POSIZIONE,
   COD_RAMO_CALCOLATO,
   ALERT_VERDE,
   ALERT_ARANCIO,
   ALERT_ROSSO
)
AS
     SELECT                                     -- V1 02/12/2010 VG: Congelata
            -- V2 22/12/2010 VG: COD_RAMO_CALCOLATO
            id_referente,
            id_utente,
            cod_comparto_utente,
            cod_comparto_posizione,
            cod_ramo_calcolato,
              MAX (
                 DECODE (cod_stato_4, 'GB', DECODE (alert_4, 'V', cnt, 0), 0))
            + MAX (
                 DECODE (cod_stato_4, 'PT', DECODE (alert_4, 'V', cnt, 0), 0))
            + MAX (
                 DECODE (cod_stato_4, 'RIO', DECODE (alert_4, 'V', cnt, 0), 0))
            + MAX (
                 DECODE (cod_stato_4, 'SC', DECODE (alert_4, 'V', cnt, 0), 0))
            + MAX (
                 DECODE (cod_stato_4, 'IN', DECODE (alert_4, 'V', cnt, 0), 0))
            + MAX (
                 DECODE (cod_stato_4, 'RS', DECODE (alert_4, 'V', cnt, 0), 0))
               alert_verde,
              MAX (
                 DECODE (cod_stato_4, 'GB', DECODE (alert_4, 'A', cnt, 0), 0))
            + MAX (
                 DECODE (cod_stato_4, 'PT', DECODE (alert_4, 'A', cnt, 0), 0))
            + MAX (
                 DECODE (cod_stato_4, 'RIO', DECODE (alert_4, 'A', cnt, 0), 0))
            + MAX (
                 DECODE (cod_stato_4, 'SC', DECODE (alert_4, 'A', cnt, 0), 0))
            + MAX (
                 DECODE (cod_stato_4, 'IN', DECODE (alert_4, 'A', cnt, 0), 0))
            + MAX (
                 DECODE (cod_stato_4, 'IN', DECODE (alert_4, 'A', cnt, 0), 0))
               alert_arancio,
              MAX (
                 DECODE (cod_stato_4, 'GB', DECODE (alert_4, 'R', cnt, 0), 0))
            + MAX (
                 DECODE (cod_stato_4, 'PT', DECODE (alert_4, 'R', cnt, 0), 0))
            + MAX (
                 DECODE (cod_stato_4, 'RIO', DECODE (alert_4, 'R', cnt, 0), 0))
            + MAX (
                 DECODE (cod_stato_4, 'SC', DECODE (alert_4, 'R', cnt, 0), 0))
            + MAX (
                 DECODE (cod_stato_4, 'IN', DECODE (alert_4, 'R', cnt, 0), 0))
            + MAX (
                 DECODE (cod_stato_4, 'RS', DECODE (alert_4, 'R', cnt, 0), 0))
               alert_rosso
       FROM (  SELECT cod_comparto_posizione,
                      p.cod_comparto_utente,
                      cod_ramo_calcolato,
                      p.id_referente,
                      p.id_utente,
                      alert_4,
                      cod_stato_4,
                      COUNT (*) cnt
                 FROM vtmcre0_app_alert_pos p
                WHERE id_utente IS NOT NULL AND alert_4 IS NOT NULL
             GROUP BY p.cod_comparto_posizione,
                      p.cod_comparto_utente,
                      cod_ramo_calcolato,
                      p.id_referente,
                      p.id_utente,
                      alert_4,
                      cod_stato_4)
   GROUP BY cod_comparto_posizione,
            cod_comparto_utente,
            cod_ramo_calcolato,
            id_referente,
            id_utente;


GRANT DELETE, INSERT, REFERENCES, SELECT, UPDATE, ON COMMIT REFRESH, QUERY REWRITE, DEBUG, FLASHBACK ON MCRE_OWN.VTMCRE0_APP_ALERT_HPR_ASS_SUM TO MCRE_USR;
