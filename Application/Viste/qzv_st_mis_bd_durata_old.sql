/* Formatted on 21/07/2014 18:30:24 (QP5 v5.227.12220.39754) */
CREATE OR REPLACE FORCE VIEW MCRE_OWN.QZV_ST_MIS_BD_DURATA_OLD
(
   COD_SRC,
   ID_DPER,
   DTA_COMPETENZA,
   COD_STATO_RISCHIO,
   DES_STATO_RISCHIO,
   COD_ABI,
   COD_NDG,
   COD_FIRMA,
   FLG_FIRMA,
   FLG_PORTAFOGLIO,
   FLG_NDG,
   VAL_VANT,
   VAL_GBV,
   VAL_NBV,
   VAL_GARANZIE_REALI_PERSONALI,
   VAL_GARANZIE_REALI,
   VAL_GARANZIE_IPOTECARIE,
   VAL_GARANZIE_PIGNORATIZIE,
   VAL_GARANZIE_PERSONALI,
   VAL_GARANZIE_ALTRE_ALTRI,
   VAL_GARANZIE_ALTRE,
   VAL_GARANZIE_ALTRI
)
AS
     SELECT 'BD' cod_src,
            SUBSTR (cp.id_dper, 1, 6) id_dper,
            cp.id_dper DTA_COMPETENZA,
            UPPER (cp.cod_stato_rischio) COD_STATO_RISCHIO,
            CASE
               WHEN UPPER (cp.cod_stato_rischio) = 'S' THEN 'Sofferenze'
               WHEN UPPER (cp.cod_stato_rischio) = 'I' THEN 'Incagli'
               WHEN UPPER (cp.cod_stato_rischio) = 'R' THEN 'Ristrutturati'
               ELSE NULL
            END
               des_stato_rischio,
            cp.cod_abi,
            cp.cod_ndg,
            cp.VAL_FIRMA COD_FIRMA,
            1 flg_firma,
            COUNT (DISTINCT cp.COD_RAPPORTO) flg_portafoglio,
            COUNT (DISTINCT cp.cod_Ndg) flg_ndg,
            SUM (cp.val_vant) val_vant,
            SUM (Cp.VAL_UTI_RET) VAL_GBV,
            SUM (cp.VAL_ATT) VAL_NBV,
            SUM (
                 NVL (val_imp_garanzie_personali, 0)
               + NVL (val_imp_garanzia_ipotecaria, 0)
               + NVL (val_imp_garanzie_pignoratizie, 0))
               val_garanzie_reali_personali,
            SUM (
                 NVL (val_imp_garanzia_ipotecaria, 0)
               + NVL (val_imp_garanzie_pignoratizie, 0))
               val_garanzie_reali,
            SUM (NVL (val_imp_garanzia_ipotecaria, 0)) val_garanzie_ipotecarie,
            SUM (NVL (val_imp_garanzie_pignoratizie, 0))
               val_garanzie_pignoratizie,
            SUM (NVL (val_imp_garanzie_personali, 0)) val_garanzie_personali,
            SUM (
                 NVL (val_imp_garanzie_altre, 0)
               + NVL (val_imp_garanzie_altri, 0))
               val_garanzie_altre_altri,
            SUM (NVL (val_imp_garanzie_altre, 0)) val_garanzie_altre,
            SUM (NVL (val_imp_garanzie_altri, 0)) val_garanzie_altri
       FROM T_MCRES_APP_SISBA_CP Cp, t_mcres_app_sisba t
      WHERE     cp.cod_abi = t.cod_abi(+)
            AND cp.cod_ndg = t.cod_ndg(+)
            AND cp.id_dper = t.id_dper(+)
            AND Cp.COD_RAPPORTO = T.COD_RAPPORTO_SISBA(+)
            AND Cp.COD_SPORTELLO = T.COD_FILIALE_RAPPORTO(+)
            AND UPPER (cp.cod_stato_rischio) IN ('I', 'S')
            AND cp.id_dper = SYS_CONTEXT ('userenv', 'client_info') --and cp.id_dper=20111130
   GROUP BY Cp.COD_ABI,
            cp.cod_ndg,
            cp.ID_DPER,
            cp.VAL_FIRMA,
            UPPER (cp.cod_stato_rischio);
