/* Formatted on 17/06/2014 18:02:29 (QP5 v5.227.12220.39754) */
CREATE OR REPLACE FORCE VIEW MCRE_OWN.V_MCRE0_APP_PREGIUDIZIEVOLI
(
   COD_SNDG,
   COD_TIPO_NOTIZIA,
   DTA_ELABORAZIONE,
   DESC_TIPO_NOTIZIA
)
AS
   SELECT cod_sndg,
          cod_tipo_notizia,
          dta_elaborazione,
          desc_tipo_notizia
     FROM (SELECT cod_sndg,
                  cod_tipo_notizia,
                  dta_elaborazione,
                  desc_tipo_notizia,
                  RANK ()
                  OVER (PARTITION BY cod_sndg ORDER BY dta_elaborazione DESC)
                     last_5
             FROM t_mcre0_app_pregiudizievoli) a
    WHERE last_5 < 6;


GRANT DELETE, INSERT, REFERENCES, SELECT, UPDATE, ON COMMIT REFRESH, QUERY REWRITE, DEBUG, FLASHBACK, MERGE VIEW ON MCRE_OWN.V_MCRE0_APP_PREGIUDIZIEVOLI TO MCRE_USR;
