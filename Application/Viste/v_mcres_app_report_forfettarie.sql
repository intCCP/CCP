/* Formatted on 21/07/2014 18:42:44 (QP5 v5.227.12220.39754) */
CREATE OR REPLACE FORCE VIEW MCRE_OWN.V_MCRES_APP_REPORT_FORFETTARIE
(
   COD_ABI,
   COD_NDG,
   COD_PROTOCOLLO_DELIBERA
)
AS
   SELECT DISTINCT                                           --VG 20140305 New
                   --VG 20140616 Modifica per NZ con controllo su inserimento nuovo parere
                   d.COD_ABI, d.COD_NDG, d.COD_PROTOCOLLO_DELIBERA
     FROM T_MCRES_APP_DELIBERE d,
          t_MCRES_APP_POSIZIONI pos,
          t_mcres_app_documenti doc
    WHERE     d.COD_ABI = pos.COD_ABI
          AND d.COD_NDG = pos.COD_NDG
          AND NVL (d.DTA_INSERIMENTO_DELIBERA, d.DTA_AGGIORNAMENTO_DELIBERA) BETWEEN pos.DTA_PASSAGGIO_SOFF
                                                                                 AND pos.DTA_CHIUSURA
          AND COALESCE (d.DTA_INSERIMENTO_DELIBERA,
                        d.DTA_DELIBERA,
                        d.DTA_AGGIORNAMENTO_DELIBERA) >=
                 pos.DTA_PASSAGGIO_SOFF
          AND d.COD_STATO_RISCHIO = 'S'
          AND NVL (doc.cod_Aut_protoc, 'NULL_AUT_PROTOC') =
                 CASE
                    WHEN     cod_delibera = 'NZ'
                         AND (SELECT MAX (TRUNC (dta_ins_parere))
                                FROM t_mcrei_app_pareri p
                               WHERE     d.cod_abi = p.cod_abi
                                     AND d.cod_ndg = p.cod_ndg
                                     AND d.COD_PROTOCOLLO_DELIBERA =
                                            p.COD_PROTOCOLLO_DELIBERA) =
                                TRUNC (SYSDATE)
                    THEN
                       NVL (doc.cod_Aut_protoc, 'NULL_AUT_PROTOC') -- 'NULL_AUT_PROTOC'
                    WHEN     cod_delibera = 'NZ'
                         AND (SELECT MAX (TRUNC (dta_ins_parere))
                                FROM t_mcrei_app_pareri p
                               WHERE     d.cod_abi = p.cod_abi
                                     AND d.cod_ndg = p.cod_ndg
                                     AND d.COD_PROTOCOLLO_DELIBERA =
                                            p.COD_PROTOCOLLO_DELIBERA) !=
                                TRUNC (SYSDATE)
                    THEN
                       'NULL_AUT_PROTOC'
                    WHEN     cod_delibera = 'FZ'
                         AND TRUNC (d.DTA_AGGIORNAMENTO_DELIBERA) =
                                TRUNC (SYSDATE)
                    THEN
                       NVL (doc.cod_Aut_protoc, 'NULL_AUT_PROTOC')
                    WHEN     cod_delibera = 'FZ'
                         AND TRUNC (d.DTA_AGGIORNAMENTO_DELIBERA) !=
                                TRUNC (SYSDATE)
                    THEN
                       'NULL_AUT_PROTOC'
                    ELSE
                       'DELIBERE_ESCLUSE'
                 END
          AND cod_delibera IN ('NZ', 'FZ')
          AND FLG_STEP5_ACTIVE = 1
          AND d.cod_protocollo_delibera = doc.cod_Aut_protoc(+)
          AND doc.cod_tipo_documento(+) = 'AL'
          AND doc.cod_stato(+) = 'CO';
