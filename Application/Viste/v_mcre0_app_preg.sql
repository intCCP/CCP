/* Formatted on 21/07/2014 18:34:37 (QP5 v5.227.12220.39754) */
CREATE OR REPLACE FORCE VIEW MCRE_OWN.V_MCRE0_APP_PREG
(
   COD_SNDG,
   COD_TIPO_NOTIZIA,
   DESC_TIPO_NOTIZIA
)
AS
     SELECT cod_sndg,
            RTRIM (
               XMLAGG (XMLELEMENT ("x", cod_tipo_notizia || ',') ORDER BY
                                                                    cod_tipo_notizia).EXTRACT (
                  '//text()'),
               ',')
               cod_tipo_notizia,
            RTRIM (
               XMLAGG (XMLELEMENT ("x", desc_tipo_notizia || ',') ORDER BY
                                                                     cod_tipo_notizia).EXTRACT (
                  '//text()'),
               ',')
               desc_tipo_notizia
       FROM (SELECT cod_sndg,
                    cod_tipo_notizia,
                    dta_elaborazione,
                    desc_tipo_notizia
               FROM (SELECT cod_sndg,
                            cod_tipo_notizia,
                            dta_elaborazione,
                            desc_tipo_notizia,
                            RANK ()
                            OVER (PARTITION BY cod_sndg
                                  ORDER BY dta_elaborazione DESC)
                               last_5
                       FROM t_mcre0_app_pregiudizievoli) a
              WHERE last_5 < 6) b
   GROUP BY cod_sndg;
