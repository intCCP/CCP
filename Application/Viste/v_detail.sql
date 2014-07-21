/* Formatted on 21/07/2014 18:31:24 (QP5 v5.227.12220.39754) */
CREATE OR REPLACE FORCE VIEW MCRE_OWN.V_DETAIL
(
   COD_ANNOMESE,
   COD_ANNOMESEGIORNO,
   COD_ABI,
   COD_NDG,
   COD_STATO_RISCHIO,
   DTA_INIZIO_STATO,
   DTA_FINE_STATO,
   COD_FILIALE,
   COD_FILIALE_AREA,
   COD_GESTIONE,
   COD_STATO_GIURIDICO,
   VAL_VANT,
   VAL_UTI_RET,
   VAL_ATT,
   VAL_GARANZIE_REALI_PERSONALI,
   VAL_GARANZIE_REALI,
   VAL_GARANZIE_IPOTECARIE,
   VAL_GARANZIE_PIGNORATIZIE,
   VAL_GARANZIE_PERSONALI,
   VAL_GARANZIE_ALTRE_ALTRI,
   VAL_GARANZIE_ALTRE,
   VAL_GARANZIE_ALTRI,
   FLG_NDG,
   FLG_NUOVO_INGRESSO,
   FLG_PORTAFOGLIO,
   FLG_GARANZIE_REALI_PERSONALI,
   FLG_GARANZIE_REALI,
   FLG_GARANZIE_IPOTECARIE,
   FLG_GARANZIE_PIGNORATIZIE,
   FLG_GARANZIE_PERSONALI,
   FLG_GARANZIE_ALTRE_ALTRI,
   FLG_GARANZIE_ALTRE,
   FLG_GARANZIE_ALTRI,
   FASCIA_IMPORTO
)
AS
   SELECT SUBSTR (id_dper, 1, 6) COD_ANNOMESE,
          id_dper COD_ANNOMESEGIORNO,
          COD_ABI,
          COD_NDG,
          cod_stato_rischio,
          dta_decorrenza_stato dta_inizio_stato,
          TO_DATE ('99991231', 'yyyymmdd') dta_fine_stato,
          COD_FILIALE,
          COD_FILIALE_AREA,
          cod_livello cod_gestione,
          cod_stato_giuridico,
          val_vant,
          val_uti_ret,
          val_att,
          val_garanzie_reali_personali,
          val_garanzie_reali,
          val_garanzie_ipotecarie,
          val_garanzie_pignoratizie,
          val_garanzie_personali,
          val_garanzie_altre_altri,
          val_garanzie_altre,
          val_garanzie_altri,
          1 flg_ndg,
          CASE
             WHEN TO_CHAR (DTA_DECORRENZA_STATO, 'yyyy') =
                     SUBSTR (id_dper, 1, 4)
             THEN
                1
             ELSE
                0
          END
             flg_nuovo_ingresso,
          1 flg_portafoglio,
          CASE WHEN val_garanzie_reali_personali > 0 THEN 1 ELSE 0 END
             flg_garanzie_reali_personali,
          CASE WHEN val_garanzie_reali > 0 THEN 1 ELSE 0 END
             flg_garanzie_reali,
          CASE WHEN val_garanzie_ipotecarie > 0 THEN 1 ELSE 0 END
             flg_garanzie_ipotecarie,
          CASE WHEN val_garanzie_pignoratizie > 0 THEN 1 ELSE 0 END
             flg_garanzie_pignoratizie,
          CASE WHEN val_garanzie_personali > 0 THEN 1 ELSE 0 END
             flg_garanzie_personali,
          CASE WHEN val_garanzie_altre_altri > 0 THEN 1 ELSE 0 END
             flg_garanzie_altre_altri,
          CASE WHEN val_garanzie_altre > 0 THEN 1 ELSE 0 END
             flg_garanzie_altre,
          CASE WHEN val_garanzie_altri > 0 THEN 1 ELSE 0 END
             flg_garanzie_altri,
          CASE
             WHEN val_uti_ret <= 15500 THEN 1
             WHEN val_uti_ret > 15500 AND val_uti_ret <= 250000 THEN 2
             WHEN val_uti_ret > 250000 AND val_uti_ret <= 500000 THEN 3
             WHEN val_uti_ret > 500000 AND val_uti_ret <= 2500000 THEN 4
             WHEN val_uti_ret > 2500000 THEN 5
          END
             fascia_importo
     FROM (  SELECT cp.id_dper,
                    cp.cod_stato_rischio,
                    cp.cod_filiale,
                    cp.cod_filiale_area,
                    cp.cod_abi,
                    cp.cod_ndg,
                    UPPER (cp.cod_stato_giuridico) cod_stato_giuridico,
                    MIN (cp.dta_decorrenza_stato) dta_decorrenza_stato,
                    SUM (cp.val_vant) val_vant,
                    SUM (cp.val_uti_ret) val_uti_ret,
                    SUM (cp.val_att) val_att,
                    SUM (
                         NVL (val_imp_garanzie_personali, 0)
                       + NVL (val_imp_garanzia_ipotecaria, 0)
                       + NVL (val_imp_garanzie_pignoratizie, 0))
                       val_garanzie_reali_personali,
                    SUM (
                         NVL (val_imp_garanzia_ipotecaria, 0)
                       + NVL (val_imp_garanzie_pignoratizie, 0))
                       val_garanzie_reali,
                    SUM (NVL (val_imp_garanzia_ipotecaria, 0))
                       val_garanzie_ipotecarie,
                    SUM (NVL (val_imp_garanzie_pignoratizie, 0))
                       val_garanzie_pignoratizie,
                    SUM (NVL (val_imp_garanzie_personali, 0))
                       val_garanzie_personali,
                    SUM (
                         NVL (val_imp_garanzie_altre, 0)
                       + NVL (val_imp_garanzie_altri, 0))
                       val_garanzie_altre_altri,
                    SUM (NVL (val_imp_garanzie_altre, 0)) val_garanzie_altre,
                    SUM (NVL (val_imp_garanzie_altri, 0)) val_garanzie_altri
               FROM mcre_own.T_MCRES_APP_SISBA_CP cp, t_mcres_app_sisba s
              WHERE     cp.cod_abi = s.cod_abi(+)
                    AND cp.cod_ndg = s.cod_ndg(+)
                    AND cp.id_dper = s.id_dper(+)
                    AND cp.cod_rapporto = s.cod_rapporto_sisba(+)
                    AND cp.cod_sportello = s.cod_filiale_rapporto(+)
                    AND cp.id_dper = SYS_CONTEXT ('userenv', 'client_info')
                    AND ( (   (    UPPER (cp.cod_stato_rischio) = 'S'
                               AND VAL_FIRMA != 'FIRMA')
                           OR (UPPER (cp.cod_stato_rischio) = 'I')))
           GROUP BY cp.id_dper,
                    cp.cod_stato_rischio,
                    cp.COD_FILIALE,
                    cp.COD_FILIALE_AREA,
                    cp.COD_ABI,
                    cp.COD_NDG,
                    cp.cod_stato_giuridico) s,
          mcre_own.T_MCRE0_APP_STRUTTURA_ORG i
    WHERE     s.COD_ABI = i.COD_ABI_ISTITUTO
          AND s.COD_FILIALE_AREA = i.COD_STRUTTURA_COMPETENTE;
