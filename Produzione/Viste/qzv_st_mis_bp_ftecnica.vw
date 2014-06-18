/* Formatted on 17/06/2014 17:59:05 (QP5 v5.227.12220.39754) */
CREATE OR REPLACE FORCE VIEW MCRE_OWN.QZV_ST_MIS_BP_FTECNICA
(
   COD_SRC,
   ID_DPER,
   COD_STATO_RISCHIO,
   DES_STATO_RISCHIO,
   COD_ABI,
   COD_NDG,
   FLG_PORTAFOGLIO,
   FLG_FIRMA,
   FLG_NDG,
   COD_FORMA_TECNICA,
   VAL_GBV,
   VAL_NBV,
   VAL_VANT
)
AS
     SELECT 'BP' cod_src,
            (SELECT MAX (val_annomese) FROM v_mcres_ultima_acq_bilancio)
               id_dper,
            'S' cod_stato_rischio,
            'Sofferenze' des_stato_rischio,
            cod_abi,
            '#' cod_Ndg,
            COUNT (DISTINCT COD_RAPPORTO) flg_portafoglio,
            1 flg_firma,
            COUNT (DISTINCT cod_Ndg) flg_ndg,
            CASE
               WHEN NVL (R.FLG_CONFIDI, 'N') = 'S' THEN 'C'
               WHEN NVL (R.FLG_AGEVOLATO, 'N') = 'S' THEN 'G'
               WHEN NVL (R.FLG_CONTRIBUTO, 'N') = 'S' THEN 'R'
               WHEN NVL (R.FLG_RAPP_CARTOLARIZZATO, 'N') = 'S' THEN 'Z'
               WHEN NVL (R.FLG_RAPP_FONDO_TERZO, 'N') = 'S' THEN 'T'
               ELSE 'A'
            END
               cod_forma_tecnica,
            -SUM (VAL_IMP_GBV) val_gbv,
            -SUM (VAL_IMP_NBV) val_nbv,
            -SUM (VAL_IMP_VANTATO) val_vant
       FROM t_mcres_app_rapporti r
   GROUP BY cod_abi,
            CASE
               WHEN NVL (R.FLG_CONFIDI, 'N') = 'S' THEN 'C'
               WHEN NVL (R.FLG_AGEVOLATO, 'N') = 'S' THEN 'G'
               WHEN NVL (R.FLG_CONTRIBUTO, 'N') = 'S' THEN 'R'
               WHEN NVL (R.FLG_RAPP_CARTOLARIZZATO, 'N') = 'S' THEN 'Z'
               WHEN NVL (R.FLG_RAPP_FONDO_TERZO, 'N') = 'S' THEN 'T'
               ELSE 'A'
            END
   UNION ALL
     SELECT 'BP' cod_src,
            (SELECT MAX (val_annomese) FROM v_mcres_ultima_acq_bilancio)
               id_dper,
            'I' cod_stato_rischio,
            'Incagli' des_stato_rischio,
            cod_abi,
            '#' cod_Ndg,
            COUNT (DISTINCT COD_RAPPORTO) flg_portafoglio,
            1 flg_firma,
            COUNT (DISTINCT cod_Ndg) flg_ndg,
            CASE
               -- WHEN NVL (R.FLG_CONFIDI, 'N') = 'S' THEN 'C'
               -- WHEN NVL (R.FLG_AGEVOLATO, 'N') = 'S' THEN 'G'
               -- WHEN NVL (R.FLG_CONTRIBUTO, 'N') = 'S' THEN 'R'
            WHEN NVL (R.FLG_RAPP_CARTOLARIZZATO, 'N') = 'S' THEN 'Z'
               --WHEN NVL (R.FLG_RAPP_FONDO_TERZO, 'N') = 'S' THEN 'T'
            WHEN NVL (R.FLG_FONDO_TERZI, 'N') = 'S' THEN 'T'
               WHEN NVL (R.FLG_RISTRUTTURATO, 'N') = 'S' THEN 'X'
               ELSE 'A'
            END
               cod_forma_tecnica,
            0 val_gbv,
            0 val_nbv,
            0 val_vant
       FROM t_mcrei_app_rapporti r
      WHERE flg_Attiva = '1'
   GROUP BY cod_abi,
            CASE
               -- WHEN NVL (R.FLG_CONFIDI, 'N') = 'S' THEN 'C'
               -- WHEN NVL (R.FLG_AGEVOLATO, 'N') = 'S' THEN 'G'
               -- WHEN NVL (R.FLG_CONTRIBUTO, 'N') = 'S' THEN 'R'
            WHEN NVL (R.FLG_RAPP_CARTOLARIZZATO, 'N') = 'S' THEN 'Z'
               --WHEN NVL (R.FLG_RAPP_FONDO_TERZO, 'N') = 'S' THEN 'T'
            WHEN NVL (R.FLG_FONDO_TERZI, 'N') = 'S' THEN 'T'
               WHEN NVL (R.FLG_RISTRUTTURATO, 'N') = 'S' THEN 'X'
               ELSE 'A'
            END;


GRANT DELETE, INSERT, REFERENCES, SELECT, UPDATE, ON COMMIT REFRESH, QUERY REWRITE, DEBUG, FLASHBACK, MERGE VIEW ON MCRE_OWN.QZV_ST_MIS_BP_FTECNICA TO MCRE_USR;
