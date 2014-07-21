/* Formatted on 21/07/2014 18:40:30 (QP5 v5.227.12220.39754) */
CREATE OR REPLACE FORCE VIEW MCRE_OWN.V_MCREI_APP_MOCRED_DT_CONT_RAP
(
   COD_ABI,
   COD_NDG,
   COD_SNDG,
   COD_STATO,
   DTA_DECORRENZA_STATO,
   COD_RAPPORTO,
   VAL_ACCORDATO_CASSA,
   VAL_ACCORDATO_FIRMA,
   VAL_ACCORDATO_DERIVATI,
   VAL_UTILIZZATO_CASSA,
   VAL_UTILIZZATO_FIRMA,
   VAL_UTILIZZATO_DERIVATI,
   VAL_RETTIFICATO_CASSA,
   VAL_RETTIFICATO_FIRMA,
   VAL_RETTIFICATO_DERIVATI,
   VAL_ATTUALIZZAZIONE,
   VAL_STRALCIO_BREVE,
   VAL_STRALCIO_MLT,
   RECUPERO,
   FLG_DATO_FORZATO,
   FLG_RISTRUTTURAZIONE
)
AS
   SELECT COD_ABI,
          COD_NDG,
          COD_SNDG,
          COD_STATO,
          DTA_DECORRENZA_STATO,
          COD_RAPPORTO,
          VAL_ACCORDATO_CASSA,
          VAL_ACCORDATO_FIRMA,
          VAL_ACCORDATO_DERIVATI,
          VAL_UTILIZZATO_CASSA,
          VAL_UTILIZZATO_FIRMA,
          VAL_UTILIZZATO_DERIVATI,
          VAL_RETTIFICATO_CASSA,
          VAL_RETTIFICATO_FIRMA,
          VAL_RETTIFICATO_DERIVATI,
          VAL_ATTUALIZZAZIONE,
          VAL_STRALCIO_BREVE,
          VAL_STRALCIO_MLT,
          RECUPERO,
          FLG_DATO_FORZATO,
          FLG_RISTRUTTURAZIONE
     FROM (SELECT cp.cod_abi,
                  cp.cod_ndg,
                  cp.cod_sndg,
                  AD.COD_STATO,
                  AD.DTA_DECORRENZA_STATO,
                  cp.cod_rapporto,
                  TO_NUMBER (NULL) AS VAL_ACCORDATO_CASSA,
                  TO_NUMBER (NULL) AS VAL_ACCORDATO_FIRMA,
                  TO_NUMBER (NULL) AS VAL_ACCORDATO_DERIVATI,
                  cp.val_uti_ret AS VAL_UTILIZZATO_CASSA,
                  CP.VAL_UTI_FIRMA AS VAL_UTILIZZATO_FIRMA,
                  TO_NUMBER (NULL) AS VAL_UTILIZZATO_DERIVATI,
                  (cp.VAL_UTI_RET - cp.VAL_NUM_DUBBIO_ESITO)
                     AS VAL_RETTIFICATO_CASSA,
                  (cp.VAL_UTI_FIRMA - cp.VAL_NUM_DUBBIO_ESITO)
                     AS VAL_RETTIFICATO_FIRMA,
                  TO_NUMBER (NULL) AS VAL_RETTIFICATO_DERIVATI,
                  CP.VAL_ATT AS VAL_ATTUALIZZAZIONE,
                  (SELECT m.VAL_CR_TOT AS VAL_stralcio_mlt
                     FROM MCRE_OWN.T_MCRES_APP_MOVIMENTI_MOD_MOV m,
                          MCRE_OWN.T_MCRES_APP_SISBA s
                    WHERE     m.DESC_MODULO IN
                                 ('PERDITE CON UTILIZZO DEL FONDO',
                                  'PERDITE CON UTILIZZO DELLA RISERVA GENERICA',
                                  'PERDITE SENZA UTILIZZO DEL FONDO',
                                  'PERDITE DA CESSIONE')
                          AND s.cod_abi = m.cod_abi
                          AND s.cod_ndg = M.cod_ndg
                          AND m.cod_abi = cp.cod_abi
                          AND m.cod_ndg = cp.cod_ndg
                          --and m.cod_rapporto = cp.cod_rapporto
                          AND s.cod_durata = 1)
                     AS VAL_STRALCIO_BREVE,
                  (SELECT m.VAL_CR_TOT AS stralcio_mlt
                     FROM MCRE_OWN.T_MCRES_APP_MOVIMENTI_MOD_MOV m,
                          MCRE_OWN.T_MCRES_APP_SISBA s
                    WHERE     m.DESC_MODULO IN
                                 ('PERDITE CON UTILIZZO DEL FONDO',
                                  'PERDITE CON UTILIZZO DELLA RISERVA GENERICA',
                                  'PERDITE SENZA UTILIZZO DEL FONDO',
                                  'PERDITE DA CESSIONE')
                          AND s.cod_abi = m.cod_abi
                          AND s.cod_ndg = M.cod_ndg
                          AND m.cod_abi = cp.cod_abi
                          AND m.cod_ndg = cp.cod_ndg
                          --and m.cod_rapporto = cp.cod_rapporto
                          AND s.cod_durata = 2)
                     AS VAL_STRALCIO_MLT,
                  (SELECT mv.VAL_CR_TOT
                     FROM MCRE_OWN.T_MCRES_APP_MOVIMENTI_MOD_MOV MV
                    WHERE     mv.DESC_MODULO IN
                                 ('INCASSI',
                                  'INCASSI INTERESSI DI MORA',
                                  'INCASSI DA CESSIONE',
                                  'INCASSI PER CALCOLO RIPRESA DI VALORE')
                          AND mv.cod_abi = cp.cod_abi
                          AND MV.COD_NDG = CP.COD_NDG -- and   mv.cod_rapporto = cp.cod_rapporto
                                                     )
                     AS RECUPERO,
                  NULL AS FLG_DATO_FORZATO,
                  cp.id_dper,
                  MAX (cp.id_dper)
                     OVER (PARTITION BY cp.cod_abi, cp.cod_ndg, cp.cod_sndg)
                     AS m_id_dper,
                  (SELECT DISTINCT (si.flg_ristrutturato)
                     FROM t_mcrei_app_sisba si
                    WHERE     CP.COD_NDG = si.COD_NDG
                          AND CP.COD_SNDG = si.COD_SNDG
                          AND cp.cod_abi = si.cod_abi
                          AND cp.cod_rapporto = si.cod_rapporto_sisba)
                     AS flg_ristrutturazione
             FROM T_MCRES_APP_SISBA_CP CP, T_MCRE0_APP_ALL_DATA AD
            WHERE     CP.COD_ABI = AD.COD_ABI_CARTOLARIZZATO
                  AND cp.cod_filiale = ad.cod_filiale
                  AND CP.COD_NDG = AD.COD_NDG
                  AND CP.COD_SNDG = AD.COD_SNDG)
    WHERE ID_DPER = M_ID_DPER;
