/* Formatted on 21/07/2014 18:39:36 (QP5 v5.227.12220.39754) */
CREATE OR REPLACE FORCE VIEW MCRE_OWN.V_MCREI_APP_DELIBERE
(
   COD_ABI,
   COD_NDG,
   COD_SNDG,
   COD_PROTOCOLLO_PACCHETTO,
   COD_PROTOCOLLO_DELIBERA,
   COD_FASE_DELIBERA,
   COD_FASE_MICROTIPOLOGIA,
   COD_FASE_PACCHETTO,
   COD_MICROTIPOLOGIA_DELIB,
   COD_MACROTIPOLOGIA_DELIB,
   FLG_NO_DELIBERA,
   DESC_TIPO_GESTIONE,
   DTA_UPD_FASE_DELIBERA,
   COD_PACCHETTO_MODIFICATO,
   COD_DELIBERA_MODIFICATO,
   COD_PACCHETTO_SERVIZIO,
   COD_DELIBERA_SERVIZIO,
   FLG_PACCHETTO_CLONATO,
   COD_MICROTIP_VARIAZIONE,
   DTA_CONFERMA_HOST,
   COD_GRUPPO_SUPER,
   FLG_PACCHETTO_TRASFERITO,
   DTA_TRASF_PACCHETTO,
   DESC_NO_DELIBERA
)
AS
   SELECT D.COD_ABI,
          D.COD_NDG,
          D.COD_SNDG,
          D.COD_PROTOCOLLO_PACCHETTO,
          D.COD_PROTOCOLLO_DELIBERA,
          D.COD_FASE_DELIBERA,
          d.COD_FASE_MICROTIPOLOGIA,
          D.COD_FASE_PACCHETTO,
          D.COD_MICROTIPOLOGIA_DELIB,
          D.COD_MACROTIPOLOGIA_DELIB,
          DECODE (d.FLG_NO_DELIBERA,
                  1, 'Y',
                  0, 'N',
                  2, 'U',
                  d.FLG_NO_DELIBERA)
             AS FLG_NO_DELIBERA,
          D.DESC_TIPO_GESTIONE,
          D.DTA_UPD_FASE_DELIBERA,
          D.COD_PACCHETTO_MODIFICATO,
          D.COD_DELIBERA_MODIFICATO,
          D.COD_PACCHETTO_SERVIZIO,
          D.COD_DELIBERA_SERVIZIO,
          D.FLG_PACCHETTO_CLONATO,
          D.COD_MICROTIP_VARIAZIONE,
          D.DTA_CONFERMA_HOST,
          A.COD_GRUPPO_SUPER,
          D.FLG_PACCHETTO_TRASFERITO,
          DTA_TRASF_PACCHETTO,
          D.DESC_NO_DELIBERA                                       -- 20131230
     FROM T_MCREI_APP_DELIBERE D, T_MCRE0_APP_ALL_DATA A
    WHERE D.COD_ABI = A.COD_ABI_CARTOLARIZZATO AND d.cod_ndg = A.COD_NDG;
