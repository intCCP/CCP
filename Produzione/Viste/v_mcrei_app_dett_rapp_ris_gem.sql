/* Formatted on 17/06/2014 18:08:01 (QP5 v5.227.12220.39754) */
CREATE OR REPLACE FORCE VIEW MCRE_OWN.V_MCREI_APP_DETT_RAPP_RIS_GEM
(
   COD_ABI,
   COD_NDG,
   DTA_STIMA,
   COD_PROT_DELIBERA,
   COD_PROT_PACCHETTO,
   COD_RAPPORTO,
   COD_TIPO_RAPPORTO,
   VAL_FORMA_TECNICA,
   VAL_UTILIZZATO_LORDO,
   VAL_UTILIZZATO_MORA,
   VAL_UTILIZZATO_FIRMA,
   COD_OPERAT_RIENTRO,
   FLG_RISTRUTT,
   COD_NPE,
   COD_FTECNICA,
   DTA_INIZIO_SEGNALAZIONE_RISTR,
   DTA_FINE_SEGNALAZIONE_RISTR,
   LAST_FLG_RISTR
)
AS
   SELECT DISTINCT          --- 12 LUGLIO, CREATA PER GESTIRE RISTRUTTURAZIONI
          H.COD_ABI,
          H.COD_NDG,
          R.DTA_STIMA,
          H.COD_PROTOCOLLO_DELIBERA AS COD_PROT_DELIBERA,
          H.COD_PROTOCOLLO_PACCHETTO AS COD_PROT_PACCHETTO,
          R.COD_RAPPORTO,
          R.FLG_TIPO_dATO AS COD_TIPO_RAPPORTO,
          nat.cod_ftecnica || ' ' || nat.desc_ftecnica AS VAL_FORMA_TECNICA,
          DECODE (COD_CLASSE_FT, 'CA', VAL_ESPOSIZIONE, NULL)
             AS VAL_UTILIZZATO_LORDO,
          R.VAL_UTILIZZATO_MORA,
          DECODE (COD_CLASSE_FT, 'FI', VAL_ESPOSIZIONE, NULL)
             AS VAL_UTILIZZATO_FIRMA,
          R.FLG_TIPO_dATO AS COD_OPERAT_RIENTRO,
          R.FLG_RISTRUTTURATO AS FLG_RISTRUTT,
          R.COD_NPE,
          R.COD_fORMA_TECNICA AS COD_FTECNICA,
          R.DTA_INIZIO_SEGNALAZIONE_RISTR,
          (CASE
              WHEN TRUNC (R.DTA_FINE_SEGNALAZIONE_RISTR) !=
                      TRUNC (R.dta_estinzione)
              THEN
                 R.DTA_FINE_SEGNALAZIONE_RISTR
              ELSE
                 NULL
           END)
             AS "DTA_FINE_SEGNALAZIONE_RISTR",
          NVL (R.flg_ristrutturato, 'N') AS last_flg_ristr
     FROM T_MCREI_HST_RISTRUTTURAZIONI H,
          (SELECT *
             FROM t_mcrei_hst_rapp_ristr
            WHERE DTA_NASCITA IS NULL) R,
          t_mcre0_app_natura_ftecnica nat
    WHERE     H.COD_PROTOCOLLO_DELIBERA = R.COD_PROTOCOLLO_DELIBERA_PADRE
          AND H.COD_ABI = R.COD_ABI(+)
          AND H.COD_NDG = R.COD_NDG(+)
          AND H.VAL_ORDINALE = R.VAL_ORDINALE(+)
          AND R.cod_forma_tecnica = nat.cod_ftecnica(+);


GRANT DELETE, INSERT, REFERENCES, SELECT, UPDATE, ON COMMIT REFRESH, QUERY REWRITE, DEBUG, FLASHBACK, MERGE VIEW ON MCRE_OWN.V_MCREI_APP_DETT_RAPP_RIS_GEM TO MCRE_USR;
