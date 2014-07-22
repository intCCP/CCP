/* Formatted on 21/07/2014 18:39:07 (QP5 v5.227.12220.39754) */
CREATE OR REPLACE FORCE VIEW MCRE_OWN.V_MCREI_APP_BENI_PROPOSTE_HST
(
   ID_LOGICAL_BENE,
   COD_ABI,
   COD_NDG,
   COD_SNDG,
   COD_PROTOCOLLO_DELIBERA,
   COD_PROTOCOLLO_PACCHETTO,
   VAL_ANNO_PROPOSTA,
   VAL_PROGR_PROPOSTA,
   DESC_INTESTATARIO,
   DESC_COMUNE,
   COD_TIPO_BENE,
   DESC_COD_TIPO_BENE,
   COD_FOGL_MAP_SUB,
   FOGLIO,
   MAPPALE,
   SUBALTERNO,
   COD_DIRITTO,
   DESC_DIRITTO,
   VAL_QUOTA_DIR,
   FLG_MANUALE,
   FLG_TIPO_DATO,
   DTA_VISURA
)
AS
   SELECT "ID_LOGICAL_BENE",
          "COD_ABI",
          "COD_NDG",
          "COD_SNDG",
          "COD_PROTOCOLLO_DELIBERA",
          "COD_PROTOCOLLO_PACCHETTO",
          "VAL_ANNO_PROPOSTA",
          "VAL_PROGR_PROPOSTA",
          "DESC_INTESTATARIO",
          "DESC_COMUNE",
          "COD_TIPO_BENE",
          "DESC_COD_TIPO_BENE",
          "COD_FOGL_MAP_SUB",
          "FOGLIO",
          "MAPPALE",
          "SUBALTERNO",
          "COD_DIRITTO",
          "DESC_DIRITTO",
          "VAL_QUOTA_DIR",
          "FLG_MANUALE",
          "FLG_TIPO_DATO",
          "DTA_VISURA"
     FROM V_MCREI_APP_BENI_PROPOSTE;