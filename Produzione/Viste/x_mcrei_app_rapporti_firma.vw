/* Formatted on 17/06/2014 18:17:55 (QP5 v5.227.12220.39754) */
CREATE OR REPLACE FORCE VIEW MCRE_OWN.X_MCREI_APP_RAPPORTI_FIRMA
(
   COD_RAPPORTO,
   COD_FORMA_TECNICA,
   COD_NATURA,
   VAL_ACCORDATO,
   VAL_UTILIZZATO
)
AS
   SELECT PCR.COD_RAPPORTO,
          PCR.COD_FORMA_TECNICA,                                       --PROVA
          NAT.COD_NATURA,
          PCR.VAL_ACCORDATO_DELIB,
          PCR.VAL_IMP_UTILIZZATO
     FROM T_MCREI_APP_PCR_RAPPORTI pcr,                              --422.748
                                       T_MCRE0_APP_NATURA_FTECNICA nat
    WHERE     PCR.COD_FORMA_TECNICA = NAT.COD_FTECNICA
          AND PCR.COD_CLASSE_FT = 'FI';


GRANT DELETE, INSERT, REFERENCES, SELECT, UPDATE, ON COMMIT REFRESH, QUERY REWRITE, DEBUG, FLASHBACK, MERGE VIEW ON MCRE_OWN.X_MCREI_APP_RAPPORTI_FIRMA TO MCRE_USR;
