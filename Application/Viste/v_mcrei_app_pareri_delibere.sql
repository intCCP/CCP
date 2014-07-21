/* Formatted on 21/07/2014 18:40:32 (QP5 v5.227.12220.39754) */
CREATE OR REPLACE FORCE VIEW MCRE_OWN.V_MCREI_APP_PARERI_DELIBERE
(
   COD_ABI,
   COD_NDG,
   COD_SNDG,
   COD_PROTOCOLLO_DELIBERA,
   FLG_DIFFORME,
   DESC_PARERE,
   DESC_TIPO_PARERE,
   COD_PROGR_PARERE,
   COD_TIPO_PAR,
   ID_PARERE,
   COD_UO,
   COD_UTENTE,
   DTA_INS_PARERE,
   DESC_NOTE_DELIBERE_ANNULLATE,
   DESC_PARERE_ESTESO
)
AS
   SELECT r."COD_ABI",
          r."COD_NDG",
          r."COD_SNDG",
          r."COD_PROTOCOLLO_DELIBERA",
          r."FLG_DIFFORME",
          r."DESC_PARERE",
          r."DESC_TIPO_PARERE",
          r."COD_PROGR_PARERE",
          r."COD_TIPO_PAR",
          r."ID_PARERE",
          r."COD_UO",
          r."COD_UTENTE",
          r."DTA_INS_PARERE",
          r."DESC_NOTE_DELIBERE_ANNULLATE",
          NVL (P.DESC_PARERE_ESTESO, TO_CLOB (P.DESC_PARERE))
             AS desc_parere_esteso
     FROM (SELECT DI.COD_ABI,
                  DI.COD_NDG,
                  DI.cod_sndg,
                  DI.cod_protocollo_delibera,
                  flg_difforme,
                  P.DESC_PARERE,
                  DECODE (cod_dominio, NULL, 'n.d.', do.desc_dominio)
                     desc_tipo_parere,
                  P.cod_progr_parere,
                  P.cod_tipo_par AS cod_tipo_par,
                  p.id_parere,
                  P.cod_uo,
                  p.cod_utente,
                  P.DTA_INS_PARERE,
                  CASE
                     WHEN (    DI.COD_FASE_DELIBERA = 'AN'
                           AND DI.FLG_TO_COPY = '9') --14Gennaio2014: condizione per visualizzare le delibere annullate con flg_to_copi='9'
                     THEN
                        DI.DESC_NOTE_DELIBERE_ANNULLATE
                     ELSE
                        NULL
                  END
                     DESC_NOTE_DELIBERE_ANNULLATE
             FROM T_MCREI_APP_PARERI P,
                  T_MCREI_CL_DOMINI DO,
                  T_MCREI_APP_DELIBERE DI
            WHERE     P.COD_TIPO_PAR = DO.VAL_DOMINIO(+)
                  AND DO.COD_DOMINIO(+) = 'TIPO_PARERE'
                  AND (   p.flg_attiva = '1'
                       OR (p.flg_attiva IS NULL AND di.flg_to_copy = '9'))
                  AND (P.FLG_DELETE IS NULL OR P.FLG_DELETE = 0)
                  AND p.cod_abi(+) = di.cod_abi
                  AND P.COD_NDG(+) = DI.COD_NDG
                  AND P.COD_PROTOCOLLO_DELIBERA(+) =
                         DI.COD_PROTOCOLLO_DELIBERA
           UNION                                                        -- ALL
           SELECT P.cod_abi,
                  P.cod_ndg,
                  P.cod_sndg,
                  P.cod_protocollo_delibera,
                  flg_difforme,
                  P.DESC_PARERE,
                  DECODE (cod_dominio, NULL, 'n.d.', do.desc_dominio)
                     desc_tipo_parere,
                  p.cod_progr_parere,
                  p.cod_tipo_par AS cod_tipo_par,
                  p.id_parere,
                  p.cod_uo,
                  p.cod_utente,
                  P.DTA_INS_PARERE,
                  NULL AS DESC_NOTE_DELIBERE_ANNULLATE
             FROM t_mcrei_app_pareri p,
                  T_MCREI_CL_DOMINI DO,
                  t_mcres_app_delibere ds
            WHERE     p.cod_tipo_par = do.val_dominio(+)
                  AND DO.COD_DOMINIO(+) = 'TIPO_PARERE'
                  AND p.flg_attiva = '1' -- AND do.val_dominio(+) NOT IN ('A01', 'A07', 'F01', 'F02')
                  AND (p.flg_delete IS NULL OR p.flg_delete = 0)
                  AND P.COD_ABI(+) = DS.COD_ABI
                  AND P.COD_NDG(+) = DS.COD_NDG
                  AND P.COD_PROTOCOLLO_DELIBERA(+) =
                         DS.COD_PROTOCOLLO_DELIBERA) r,
          t_mcrei_app_pareri p
    WHERE     P.COD_ABI(+) = r.COD_ABI
          AND P.COD_NDG(+) = r.COD_NDG
          AND P.COD_PROTOCOLLO_DELIBERA(+) = r.COD_PROTOCOLLO_DELIBERA
          AND P.COD_TIPO_PAR(+) = R.COD_TIPO_PAR
          AND P.ID_PARERE(+) = R.ID_PARERE;
