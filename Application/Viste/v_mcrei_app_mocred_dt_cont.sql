/* Formatted on 21/07/2014 18:40:29 (QP5 v5.227.12220.39754) */
CREATE OR REPLACE FORCE VIEW MCRE_OWN.V_MCREI_APP_MOCRED_DT_CONT
(
   COD_ABI,
   COD_NDG,
   COD_SNDG,
   COD_STATO,
   DTA_DECORRENZA_STATO,
   DESC_NOME_CONTROPARTE,
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
   FLG_DATO_FORZATO
)
AS
   SELECT "COD_ABI",
          "COD_NDG",
          "COD_SNDG",
          "COD_STATO",
          "DTA_DECORRENZA_STATO",
          "DESC_NOME_CONTROPARTE",
          "ACCORDATO_CASSA",
          "ACCORDATO_FIRMA",
          "ACCORDATO_DERIVATI",
          "UTILIZZATO_CASSA",
          "UTILIZZATO_FIRMA",
          "UTILIZZATO_DERIVATI",
          "RETTIFICATO_CASSA",
          "RETTIFICATO_FIRMA",
          "RETTIFICATO_DERIVATI",
          "ATTUALIZZAZIONE",
          "STRALCIO_BREVE",
          "STRALCIO_MLT",
          "RECUPERO",
          "FLAG_DATO_FORZATO"
     FROM (SELECT DISTINCT
                  /*
                  Da eseguire prima di interogare la vista.
                  BEGIN
                  dbms_application_info.set_client_info(cod_sndg);
                  END;
                  */
                  cp.cod_abi,
                  cp.cod_ndg,
                  cp.cod_sndg,
                  AD.COD_STATO,
                  AD.DTA_DECORRENZA_STATO,
                  AD.DESC_NOME_CONTROPARTE,
                  TO_NUMBER (NULL) AS ACCORDATO_CASSA,
                  TO_NUMBER (NULL) AS ACCORDATO_FIRMA,
                  TO_NUMBER (NULL) AS ACCORDATO_DERIVATI,
                  SUM (cp.val_uti_ret)
                     OVER (PARTITION BY cp.cod_abi, cp.cod_ndg)
                     AS UTILIZZATO_CASSA,
                  SUM (CP.VAL_UTI_FIRMA)
                     OVER (PARTITION BY cp.cod_abi, cp.cod_ndg)
                     AS UTILIZZATO_FIRMA,
                  TO_NUMBER (NULL) AS UTILIZZATO_DERIVATI,
                  SUM ( (cp.VAL_UTI_RET - cp.VAL_NUM_DUBBIO_ESITO))
                     OVER (PARTITION BY cp.cod_abi, cp.cod_ndg)
                     AS RETTIFICATO_CASSA,
                  SUM ( (cp.VAL_UTI_FIRMA - cp.VAL_NUM_DUBBIO_ESITO))
                     OVER (PARTITION BY cp.cod_abi, cp.cod_ndg)
                     AS RETTIFICATO_FIRMA,
                  TO_NUMBER (NULL) AS RETTIFICATO_DERIVATI,
                  SUM (CP.VAL_ATT) OVER (PARTITION BY cp.cod_abi, cp.cod_ndg)
                     AS ATTUALIZZAZIONE,
                  (  SELECT SUM (m.VAL_CR_TOT) AS stralcio_mlt
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
                            AND M.COD_NDG = CP.COD_NDG
                            --and m.cod_rapporto = cp.cod_rapporto
                            AND s.cod_durata = 1
                   GROUP BY m.cod_abi, m.cod_ndg)
                     AS STRALCIO_BREVE,
                  (  SELECT SUM (m.VAL_CR_TOT) AS stralcio_mlt
                       FROM MCRE_OWN.T_MCRES_APP_MOVIMENTI_MOD_MOV m,
                            MCRE_OWN.T_MCRES_APP_SISBA s
                      WHERE     m.DESC_MODULO IN
                                   ('PERDITE CON UTILIZZO DEL FONDO',
                                    'PERDITE CON UTILIZZO DELLA RISERVA GENERICA',
                                    'PERDITE SENZA UTILIZZO DEL FONDO',
                                    'PERDITE DA CESSIONE')
                            AND s.cod_abi = m.cod_abi
                            AND s.cod_ndg = M.cod_ndg
                            AND M.COD_ABI = CP.COD_ABI
                            AND m.cod_ndg = cp.cod_ndg
                            --and m.cod_rapporto = cp.cod_rapporto
                            AND s.cod_durata = 2
                   GROUP BY m.cod_abi, m.cod_ndg)
                     AS STRALCIO_MLT,
                  (  SELECT SUM (mv.VAL_CR_TOT)
                       FROM MCRE_OWN.T_MCRES_APP_MOVIMENTI_MOD_MOV MV
                      WHERE     mv.DESC_MODULO IN
                                   ('INCASSI',
                                    'INCASSI INTERESSI DI MORA',
                                    'INCASSI DA CESSIONE',
                                    'INCASSI PER CALCOLO RIPRESA DI VALORE')
                            AND mv.cod_abi = cp.cod_abi
                            AND MV.COD_NDG = CP.COD_NDG
                   --and   mv.cod_rapporto = cp.cod_rapporto
                   GROUP BY mv.cod_abi, mv.cod_ndg)
                     AS RECUPERO,
                  NULL AS FLAG_DATO_FORZATO
             FROM T_MCRES_APP_SISBA_CP CP, T_MCRE0_APP_ALL_DATA AD
            WHERE     CP.COD_ABI = AD.COD_ABI_CARTOLARIZZATO
                  AND cp.cod_filiale = ad.cod_filiale
                  AND CP.COD_NDG = AD.COD_NDG
                  AND CP.COD_SNDG = AD.COD_SNDG
                  AND CP.COD_SNDG =
                         SUBSTR ( (SYS_CONTEXT ('userenv', 'client_info')),
                                 1,
                                 16));
