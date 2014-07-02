/* Formatted on 17/06/2014 18:17:53 (QP5 v5.227.12220.39754) */
CREATE OR REPLACE FORCE VIEW MCRE_OWN.X_MCREI_APP_RAPPORTI_CASSA
(
   COD_RAPPORTO,
   COD_FORMA_TECNICA,
   COD_NATURA,
   VAL_ACCORDATO,
   VAL_UTILIZZATO,
   DI_CUI_CAPITALE,
   DI_CUI_MORA,
   NUMERO_RATE_IMPAGATE,
   IMPORTO_TOTALE_RATE_IMPAGATE,
   VAL_IMP_DEBITO_RESIDUO,
   PERIODICIT�
)
AS
   SELECT PCR.COD_RAPPORTO,
          PCR.COD_FORMA_TECNICA,
          NAT.COD_NATURA,
          PCR.VAL_ACCORDATO_DELIB,
          PCR.VAL_IMP_UTILIZZATO,
          NULL,
          NULL,
          RATE.VAL_COEFF_RATE_ARRETRATE,
          RATE.VAL_IMP_ARRETRATO,
          RATE.VAL_IMP_DEBITO_RESIDUO,
          RATE.COD_PERIODO
     --  29/11/2011   Luca Ferretti   Creazione vista
     FROM T_MCREI_APP_PCR_RAPPORTI pcr,                              --422.748
          T_MCRE0_APP_NATURA_FTECNICA nat,                               -- 45
          T_MCRE0_APP_RATE_ARRETRATE rate                         -- 2.456.454
    WHERE     PCR.COD_FORMA_TECNICA = NAT.COD_FTECNICA
          AND PCR.COD_ABI = RATE.COD_ABI_CARTOLARIZZATO
          AND PCR.COD_NDG = RATE.COD_NDG
          AND PCR.COD_RAPPORTO = RATE.COD_RAPPORTO
          AND PCR.COD_CLASSE_FT = 'CA';


GRANT DELETE, INSERT, REFERENCES, SELECT, UPDATE, ON COMMIT REFRESH, QUERY REWRITE, DEBUG, FLASHBACK, MERGE VIEW ON MCRE_OWN.X_MCREI_APP_RAPPORTI_CASSA TO MCRE_USR;