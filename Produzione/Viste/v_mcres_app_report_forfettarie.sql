/* Formatted on 17/06/2014 18:11:04 (QP5 v5.227.12220.39754) */
CREATE OR REPLACE FORCE VIEW MCRE_OWN.V_MCRES_APP_REPORT_FORFETTARIE
(
   COD_ABI,
   COD_NDG,
   COD_PROTOCOLLO_DELIBERA
)
AS
   SELECT DISTINCT                                           --VG 20140305 New
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
                    WHEN cod_delibera = 'NZ'
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


GRANT SELECT ON MCRE_OWN.V_MCRES_APP_REPORT_FORFETTARIE TO MCRE_USR;
