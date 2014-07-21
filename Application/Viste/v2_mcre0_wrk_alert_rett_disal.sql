/* Formatted on 21/07/2014 18:44:52 (QP5 v5.227.12220.39754) */
CREATE OR REPLACE FORCE VIEW MCRE_OWN.V2_MCRE0_WRK_ALERT_RETT_DISAL
(
   COD_ABI,
   COD_NDG,
   COD_STATO,
   COD_PROTOCOLLO_DELIBERA
)
AS
   SELECT COD_ABI,
          COD_NDG,
          COD_STATO,
          COD_PROTOCOLLO_DELIBERA
     FROM (SELECT UF.COD_ABI_CARTOLARIZZATO AS COD_ABI,
                  UF.COD_NDG,
                  UF.COD_STATO,
                  (SELECT b.cod_protocollo_delibera
                     FROM (SELECT DISTINCT
                                  cod_abi,
                                  cod_sndg,
                                  cod_ndg,
                                  dta_stima,
                                  flg_tipo_dato,
                                  cod_protocollo_delibera,
                                  cod_classe_ft,
                                  SUM (
                                     DECODE (COD_CLASSE_FT,
                                             'CA', VAL_RDV_TOT,
                                             TO_CHAR (NULL), VAL_RDV_TOT,
                                             0))
                                  OVER (
                                     PARTITION BY cod_abi,
                                                  cod_ndg,
                                                  cod_protocollo_delibera)
                                     RDV_STIME_CA,
                                  SUM (
                                     DECODE (COD_CLASSE_fT,
                                             'FI', VAL_RDV_TOT,
                                             0))
                                  OVER (
                                     PARTITION BY cod_abi,
                                                  cod_ndg,
                                                  cod_protocollo_delibera)
                                     RDV_STIME_FI,
                                  MAX (dta_stima)
                                     OVER (PARTITION BY cod_abi, cod_ndg)
                                     AS max_stima
                             FROM t_mcrei_app_stime PARTITION (inc_pattive)) s,
                          (SELECT DISTINCT
                                  cod_abi,
                                  cod_sndg,
                                  cod_ndg,
                                  dta_stima,
                                  flg_tipo_dato,
                                  cod_protocollo_delibera,
                                  cod_classe_ft,
                                  SUM (
                                     DECODE (COD_CLASSE_FT,
                                             'CA', VAL_RDV_TOT,
                                             TO_CHAR (NULL), VAL_RDV_TOT,
                                             0))
                                  OVER (
                                     PARTITION BY cod_abi,
                                                  cod_ndg,
                                                  cod_protocollo_delibera)
                                     RDV_STIME_BATCH_CA,
                                  SUM (
                                     DECODE (COD_CLASSE_fT,
                                             'FI', VAL_RDV_TOT,
                                             0))
                                  OVER (
                                     PARTITION BY cod_abi,
                                                  cod_ndg,
                                                  cod_protocollo_delibera)
                                     RDV_STIME_BATCH_FI,
                                  MAX (dta_stima)
                                     OVER (PARTITION BY cod_abi, cod_ndg)
                                     AS max_stima_batch
                             FROM t_mcrei_app_stime_batch --where to_char(dta_stima, 'mmyyyy') = to_char(sysdate,'mmyyyy')
                                                         ) b,
                          T_MCREI_APP_DELIBERE D
                    WHERE     D.COD_ABI = UF.COD_ABI_CARTOLARIZZATO
                          AND D.COD_NDG = UF.COD_NDG
                          AND s.cod_abi = b.cod_abi
                          AND s.cod_ndg = b.cod_ndg
                          AND s.flg_tipo_dato = b.flg_tipo_dato
                          AND s.cod_protocollo_delibera =
                                 b.cod_protocollo_delibera
                          AND s.dta_stima = s.max_stima
                          AND b.dta_stima = b.max_stima_batch
                          AND b.max_stima_batch > s.max_stima
                          AND S.COD_CLASSE_FT = B.COD_CLASSE_fT
                          AND S.COD_ABI = D.COD_ABI
                          AND S.COD_NDG = D.COD_NDG
                          AND S.COD_PROTOCOLLO_DELIBERA =
                                 D.COD_PROTOCOLLO_DELIBERA
                          AND D.cod_tipo_pacchetto = 'M'
                          AND (   S.RDV_STIME_CA <> B.RDV_STIME_BATCH_CA
                               OR S.RDV_STIME_FI <> B.RDV_STIME_BATCH_FI))
                     COD_PROTOCOLLO_DELIBERA
             FROM V_MCRE0_APP_UPD_FIELDS_P1 UF
            WHERE     UF.FLG_TARGET = 'Y'
                  AND UF.FLG_OUTSOURCING = 'Y'
                  AND UF.COD_STATO IN ('IN', 'RS'))
    WHERE COD_PROTOCOLLO_DELIBERA IS NOT NULL;
