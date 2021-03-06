CREATE OR REPLACE FORCE VIEW V_MCRE0_ASSEGNA_COMPARTO_GB_AV
(
   COD_GRUPPO_SUPER,
   COD_COMPARTO_PROPOSTO
)
AS
   SELECT DISTINCT COD_GRUPPO_SUPER, COD_COMPARTO_PROPOSTO
     FROM (SELECT F.COD_GRUPPO_SUPER,
                  G.COD_COMPARTO_PROPOSTO,
                  DTA_STATO,
                  MIN (dta_stato) OVER (PARTITION BY cod_gruppo_super)
                     min_dtata_stato
             FROM mcre_own.t_mcre0_all_data F,--post disassegnazioni
                  (SELECT COD_ABI_CARTOLARIZZATO,
                          COD_NDG,
                          COD_COMPARTO_PROPOSTO,
                          DTA_STATO
                     FROM T_MCRE0_APP_GB_GESTIONE
                    WHERE FLG_STATO = 1
                   UNION
                   SELECT COD_ABI_CARTOLARIZZATO,
                          COD_NDG,
                          COD_COMPARTO_AV,
                          DTA_STATO
                     FROM T_MCRE0_APP_AV_GESTIONE
                    WHERE FLG_STATO = 1) G
            WHERE     F.COD_ABI_CARTOLARIZZATO = G.COD_ABI_CARTOLARIZZATO
                  AND F.COD_NDG = G.COD_NDG
                  AND F.COD_COMPARTO_ASSEGNATO IS NULL)
    WHERE DTA_STATO = min_dtata_stato AND COD_COMPARTO_PROPOSTO IS NOT NULL;
