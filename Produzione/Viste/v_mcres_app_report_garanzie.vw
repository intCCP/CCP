/* Formatted on 17/06/2014 18:11:05 (QP5 v5.227.12220.39754) */
CREATE OR REPLACE FORCE VIEW MCRE_OWN.V_MCRES_APP_REPORT_GARANZIE
(
   ID_DPER,
   COD_ABI,
   COD_NDG,
   COD_GARANZIA,
   COD_NDG_GARANTE,
   COD_NDG_GARANTITO,
   COD_RAPPORTO,
   COD_FORMA_TECNICA,
   VAL_IMPORTO_GARANZIA,
   DTA_SCADENZA_GARANZIA,
   COD_TIPO_COPERTURA,
   COD_STATO_GARANZIA,
   DTA_DELIBERA_GARANZIA,
   DTA_PERFEZIONAMENTO_GARANZIA,
   COD_ABI_CARTOLARIZZAZIONE,
   COD_SNDG,
   DTA_INS,
   DTA_UPD,
   COD_OPERATORE_INS_UPD
)
AS
   SELECT "ID_DPER",
          "COD_ABI",
          "COD_NDG",
          "COD_GARANZIA",
          "COD_NDG_GARANTE",
          "COD_NDG_GARANTITO",
          "COD_RAPPORTO",
          "COD_FORMA_TECNICA",
          "VAL_IMPORTO_GARANZIA",
          "DTA_SCADENZA_GARANZIA",
          "COD_TIPO_COPERTURA",
          "COD_STATO_GARANZIA",
          "DTA_DELIBERA_GARANZIA",
          "DTA_PERFEZIONAMENTO_GARANZIA",
          "COD_ABI_CARTOLARIZZAZIONE",
          "COD_SNDG",
          "DTA_INS",
          "DTA_UPD",
          "COD_OPERATORE_INS_UPD"
     FROM T_MCRES_APP_GARANZIE P
    WHERE     DTA_SCADENZA_GARANZIA = TO_DATE ('99991231', 'YYYYMMDD')
          AND ID_DPER <
                 (SELECT TO_CHAR (ID_DPER - 5, 'YYYYMMDD')
                    FROM T_MCRES_WRK_LAST_ACQUISIZIONE A
                   WHERE COD_FLUSSO = 'GARANZIE' AND A.COD_ABI = P.COD_ABI);


GRANT DELETE, INSERT, REFERENCES, SELECT, UPDATE, ON COMMIT REFRESH, QUERY REWRITE, DEBUG, FLASHBACK, MERGE VIEW ON MCRE_OWN.V_MCRES_APP_REPORT_GARANZIE TO MCRE_USR;
