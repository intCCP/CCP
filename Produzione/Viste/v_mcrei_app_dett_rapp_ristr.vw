/* Formatted on 17/06/2014 18:08:02 (QP5 v5.227.12220.39754) */
CREATE OR REPLACE FORCE VIEW MCRE_OWN.V_MCREI_APP_DETT_RAPP_RISTR
(
   COD_ABI,
   COD_NDG,
   DTA_STIMA,
   COD_PROT_DELIBERA,
   COD_RAPPORTO,
   COD_TIPO_RAPPORTO,
   VAL_NUM_RAPPORTO,
   VAL_FORMA_TECNICA,
   VAL_UTILIZZATO_LORDO,
   VAL_UTILIZZATO_NETTO,
   VAL_UTILIZZATO_MORA,
   VAL_UTILIZZATO_FIRMA,
   COD_OPERAT_RIENTRO,
   FLG_RISTRUTT,
   FLG_RECUPERO_TOT,
   VAL_RETTIFICA_LIVELLO_RAPPORTO,
   VAL_STIMA_DI_REC,
   FLG_STORICO,
   VAL_INTERVALLO,
   FLG_FONDO_TERZI,
   COD_PROT_PACCHETTO,
   VAL_PERCENTUALE,
   VAL_IMP_PREV_PREGR,
   VAL_IMP_RETTIFICA_PREGR,
   VAL_RDV_TOT,
   FONDO_TERZI,
   VAL_UTILIZZATO_SOSTI,
   VAL_RDV_RAPP_OPERATIVI,
   VAL_IMP_RETTIFICA_ATT,
   VAL_RETT_CASSA_QTA_CAP,
   VAL_RDV_FIRMA,
   VAL_RDV_PREGR_CASSA,
   VAL_RDV_PREGR_FIRMA,
   COD_NPE,
   VAL_ACCORDATO_DELIB,
   COD_FTECNICA,
   DTA_EFFICACIA_RISTR,
   DTA_EFFICACIA_ADD,
   DTA_INIZIO_SEGNALAZIONE_RISTR,
   DTA_FINE_SEGNALAZIONE_RISTR,
   LAST_FLG_RISTR
)
AS
   SELECT                   --- 12 LUGLIO, CREATA PER GESTIRE RISTRUTTURAZIONI
         a."COD_ABI",
          a."COD_NDG",
          a."DTA_STIMA",
          a."COD_PROT_DELIBERA",
          a."COD_RAPPORTO",
          a."COD_TIPO_RAPPORTO",
          a."VAL_NUM_RAPPORTO",
          a."VAL_FORMA_TECNICA",
          a."VAL_UTILIZZATO_LORDO",
          a."VAL_UTILIZZATO_NETTO",
          a."VAL_UTILIZZATO_MORA",
          a."VAL_UTILIZZATO_FIRMA",
          a."COD_OPERAT_RIENTRO",
          a."FLG_RISTRUTT",
          a."FLG_RECUPERO_TOT",
          a."VAL_RETTIFICA_LIVELLO_RAPPORTO",
          a."VAL_STIMA_DI_REC",
          a."FLG_STORICO",
          a."VAL_INTERVALLO",
          a."FLG_FONDO_TERZI",
          a."COD_PROT_PACCHETTO",
          a."VAL_PERCENTUALE",
          a."VAL_IMP_PREV_PREGR",
          a."VAL_IMP_RETTIFICA_PREGR",
          a."VAL_RDV_TOT",
          a."FONDO_TERZI",
          a."VAL_UTILIZZATO_SOSTI",
          a."VAL_RDV_RAPP_OPERATIVI",
          a."VAL_IMP_RETTIFICA_ATT",
          a."VAL_RETT_CASSA_QTA_CAP",
          a."VAL_RDV_FIRMA",
          a."VAL_RDV_PREGR_CASSA",
          a."VAL_RDV_PREGR_FIRMA",
          a."COD_NPE",
          a."VAL_ACCORDATO_DELIB",
          a."COD_FTECNICA",
          a."DTA_EFFICACIA_RISTR",
          a."DTA_EFFICACIA_ADD",
          a."DTA_INIZIO_SEGNALAZIONE_RISTR",
          a."DTA_FINE_SEGNALAZIONE_RISTR",
          NVL (b.flg_ristrutturato, 'N') AS last_flg_ristr
     FROM mcre_own.v_mcrei_app_dett_rapporti_rv a
          LEFT JOIN
          (SELECT cod_abi,
                  cod_ndg,
                  cod_rapporto,
                  flg_ristrutturato
             FROM (SELECT cod_abi,
                          cod_ndg,
                          cod_rapporto,
                          flg_ristrutturato,
                          RANK ()
                          OVER (PARTITION BY cod_abi, cod_ndg, cod_rapporto
                                ORDER BY val_ordinale DESC)
                             rn
                     FROM t_mcrei_hst_rapp_ristr t
                    WHERE     t.cod_abi =
                                 SUBSTR (
                                    (SYS_CONTEXT ('userenv', 'client_info')),
                                    1,
                                    5)
                          AND t.cod_ndg =
                                 SUBSTR (
                                    (SYS_CONTEXT ('userenv', 'client_info')),
                                    6,
                                    16))
            WHERE rn = 1) b
             ON     a.cod_abi = b.cod_abi
                AND a.cod_ndg = b.cod_ndg
                AND a.cod_rapporto = b.cod_rapporto;


GRANT DELETE, INSERT, REFERENCES, SELECT, UPDATE, ON COMMIT REFRESH, QUERY REWRITE, DEBUG, FLASHBACK, MERGE VIEW ON MCRE_OWN.V_MCREI_APP_DETT_RAPP_RISTR TO MCRE_USR;
