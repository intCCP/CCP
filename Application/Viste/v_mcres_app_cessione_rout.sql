/* Formatted on 21/07/2014 18:41:43 (QP5 v5.227.12220.39754) */
CREATE OR REPLACE FORCE VIEW MCRE_OWN.V_MCRES_APP_CESSIONE_ROUT
(
   COD_ABI,
   ID_DPER,
   COD_NDG,
   VAL_DENOM_CLIENTE,
   COD_FILIALE_PRINCIPALE,
   DTA_PASSAGGIO_SOFF,
   COD_FISCALE_CLIENTE,
   COD_FISCALE_COINT,
   VAL_VIA,
   VAL_CITTA,
   VAL_CAP,
   VAL_PROVINCIA,
   VAL_IMP_CAP,
   VAL_IMP_INTERESSI,
   VAL_IMP_MORA,
   VAL_PREZZO_CESSIONE,
   COD_NDG_CESSIONARIA,
   VAL_DENOM_CESSIONARIA,
   DTA_CESSIONE,
   DTA_INVIO,
   FLG_INVIO,
   DTA_INS,
   DTA_UPD,
   COD_OPERATORE_INS_UPD,
   VAL_EMAIL_PRINCIPALE,
   VAL_EMAIL_SECONDARIE
)
AS
   SELECT                                       -- 20140707 VG Controllo clone
         a."COD_ABI",
          a."ID_DPER",
          a."COD_NDG",
          a."VAL_DENOM_CLIENTE",
          a."COD_FILIALE_PRINCIPALE",
          a."DTA_PASSAGGIO_SOFF",
          a."COD_FISCALE_CLIENTE",
          a."COD_FISCALE_COINT",
          a."VAL_VIA",
          a."VAL_CITTA",
          a."VAL_CAP",
          a."VAL_PROVINCIA",
          a."VAL_IMP_CAP",
          a."VAL_IMP_INTERESSI",
          a."VAL_IMP_MORA",
          a."VAL_PREZZO_CESSIONE",
          a."COD_NDG_CESSIONARIA",
          a."VAL_DENOM_CESSIONARIA",
          a."DTA_CESSIONE",
          a."DTA_INVIO",
          a."FLG_INVIO",
          a."DTA_INS",
          a."DTA_UPD",
          a."COD_OPERATORE_INS_UPD",
          val_IND_MAIL_SOC_CESSIONE VAL_EMAIL_PRINCIPALE,
          (SELECT    'uo'
                  || ist.COD_ISTITUTO_SOA
                  || a.COD_FILIALE_PRINCIPALE
                  || '@'
                  || dom.DOMINIO_POSTA
             FROM T_MCRES_APP_ISTITUTI ist, T_MCRE0_CL_DOMINI_SOCIETA dom
            WHERE     ist.COD_ABI = a.cod_abi
                  AND dom.COD_SOCIETA = ist.COD_ISTITUTO_SOA
                  AND TRIM (dom.DOMINIO_POSTA) IS NOT NULL)
             AS VAL_EMAIL_SECONDARIE
     FROM T_MCRES_app_CEDUTE_ROUT a
    WHERE INSTR ( (SELECT VALORE_COSTANTE
                     FROM T_MCRES_WRK_CONFIGURAZIONE
                    WHERE NOME_COSTANTE = 'ABI_RACCOLTA_DOCUMENTALE'),
                 ',' || cod_abi || ',') != 0;
