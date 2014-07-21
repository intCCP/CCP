/* Formatted on 21/07/2014 18:38:58 (QP5 v5.227.12220.39754) */
CREATE OR REPLACE FORCE VIEW MCRE_OWN.V_MCREB_STATO_GIURIDICO
(
   COD_STATO_GIURIDICO,
   ORD_STATO_GIURIDICO,
   DES_STATO_GIURIDICO
)
AS
   SELECT DISTINCT
          NVL (UPPER (cod_stato_giuridico), '#') cod_stato_giuridico,
          CASE
             WHEN UPPER (cod_stato_giuridico) = 'C' THEN 1
             WHEN UPPER (cod_stato_giuridico) IN ('A', 'B', 'D', 'E') THEN 2
             ELSE 3
          END
             ord_stato_giuridico,
          CASE
             WHEN UPPER (cod_stato_giuridico) = 'C'
             THEN
                'Procedure concorsuai: fallimento'
             WHEN UPPER (cod_stato_giuridico) IN ('A', 'B', 'D', 'E')
             THEN
                'Procedure concorsuai: altre'
             ELSE
                'Procedure concorsuai: nessuna'
          END
             des_stato_giuridico
     FROM mcre_own.T_MCRES_APP_SISBA_CP s
    WHERE     s.id_dper = SYS_CONTEXT ('userenv', 'client_info')
          AND UPPER (s.cod_stato_rischio) IN ('I', 'S')
          AND VAL_FIRMA != 'FIRMA';
