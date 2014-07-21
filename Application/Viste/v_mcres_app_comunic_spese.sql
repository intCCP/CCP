/* Formatted on 21/07/2014 18:41:47 (QP5 v5.227.12220.39754) */
CREATE OR REPLACE FORCE VIEW MCRE_OWN.V_MCRES_APP_COMUNIC_SPESE
(
   COD_PRESIDIO,
   DESC_PRESIDIO,
   VAL_ANNOMESE,
   VAL_TOT_NUM_SPESE,
   VAL_TOT_SPESE,
   VAL_VERDE,
   VAL_ARANCIO,
   VAL_ROSSO
)
AS
     SELECT                                   ---- 20120207 VG: Nuova SP spese
            --- 20120509 VG: uniformata ad Alert
            DECODE (P.VAL_TIPO_GESTIONE, 'E', NULL, P.COD_PRESIDIO)
               COD_PRESIDIO,
            DECODE (P.VAL_TIPO_GESTIONE, 'E', 'Italfondiario', P.DESC_PRESIDIO)
               DESC_PRESIDIO,
            VAL_ANNOMESE,
            SUM (VAL_TOT_NUM_SPESE) VAL_TOT_NUM_SPESE,
            SUM (VAL_TOT_SPESE) VAL_TOT_SPESE,
            SUM (VAL_VERDE) VAL_VERDE,
            SUM (VAL_ARANCIO) VAL_ARANCIO,
            SUM (VAL_ROSSO) VAL_ROSSO
       FROM (  SELECT s.COD_UO_PRATICA,
                      COUNT (S.COD_AUTORIZZAZIONE) VAL_TOT_NUM_SPESE,
                      SUM (S.VAL_IMPORTO) VAL_TOT_SPESE,
                      SUM (
                         CASE
                            WHEN TRUNC (SYSDATE) - S.DTA_AUTORIZZAZIONE BETWEEN 0
                                                                            AND 7
                            THEN
                               1
                            ELSE
                               0
                         END)
                         VAL_VERDE,
                      SUM (
                         CASE
                            WHEN TRUNC (SYSDATE) - S.DTA_AUTORIZZAZIONE BETWEEN 8
                                                                            AND 30
                            THEN
                               1
                            ELSE
                               0
                         END)
                         VAL_ARANCIO,
                      SUM (
                         CASE
                            WHEN TRUNC (SYSDATE) - S.DTA_AUTORIZZAZIONE > 30
                            THEN
                               1
                            ELSE
                               0
                         END)
                         VAL_ROSSO
                 FROM V_MCRES_APP_SOSPESI S
             GROUP BY s.COD_UO_PRATICA) a,
            (SELECT *
               FROM V_MCRES_APP_LISTA_PRESIDI
              WHERE cod_tipo = 'P') P,
            V_MCRES_ULTIMA_ACQuisizione F
      WHERE P.COD_PRESIDIO = A.COD_UO_PRATICA(+) AND f.cod_flusso = 'SISBA_CP'
   GROUP BY DECODE (P.VAL_TIPO_GESTIONE, 'E', NULL, P.COD_PRESIDIO),
            DECODE (P.VAL_TIPO_GESTIONE,
                    'E', 'Italfondiario',
                    P.DESC_PRESIDIO),
            VAL_ANNOMESE;
