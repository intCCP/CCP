/* Formatted on 17/06/2014 18:09:00 (QP5 v5.227.12220.39754) */
CREATE OR REPLACE FORCE VIEW MCRE_OWN.V_MCREI_MAX_STIME2
(
   COD_ABI,
   COD_NDG,
   COD_RAPPORTO,
   DTA_STIMA,
   COD_PROTOCOLLO_DELIBERA
)
AS
   SELECT s3.cod_abi,
          s3.cod_ndg,
          s3.cod_rapporto,
          s3.dta_stima,
          s3.cod_protocollo_delibera
     FROM (SELECT s2.cod_abi,
                  s2.cod_ndg,
                  s2.cod_rapporto,
                  s2.cod_protocollo_delibera,
                  s2.max_dta
             FROM (SELECT DISTINCT
                          s11.cod_abi,
                          s11.cod_ndg,
                          s11.cod_rapporto,
                          s11.cod_protocollo_delibera,
                          MAX (
                             s11.dta_stima)
                          OVER (
                             PARTITION BY s11.cod_abi,
                                          s11.cod_ndg,
                                          s11.cod_rapporto)
                             AS max_dta
                     FROM t_mcrei_app_stime s11, t_mcrei_app_delibere d
                    WHERE     s11.cod_abi = d.cod_abi
                          AND s11.cod_ndg = d.cod_ndg
                          AND s11.cod_protocollo_delibera =
                                 d.cod_protocollo_delibera
                          AND d.cod_fase_delibera = 'CO'
                          AND d.flg_no_delibera = 0
                          AND d.flg_attiva = '1'
                          AND d.cod_microtipologia_delib IN
                                 ('A0', 'T4', 'RV', 'IM')) s2) max_st2,
          ---- (2.1) STIME E STIME EXTRA CON MAX_DTA
          t_mcrei_app_stime s3
    ---- (2.1) STIME E STIME EXTRA
    WHERE     max_st2.cod_abi = s3.cod_abi
          AND max_st2.cod_ndg = s3.cod_ndg
          AND max_st2.cod_rapporto = s3.cod_rapporto
          AND max_st2.max_dta = s3.dta_stima
          AND max_st2.cod_protocollo_delibera = s3.cod_protocollo_delibera;


GRANT SELECT ON MCRE_OWN.V_MCREI_MAX_STIME2 TO MCRE_USR;
