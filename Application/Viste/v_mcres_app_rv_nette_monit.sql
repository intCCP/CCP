/* Formatted on 21/07/2014 18:42:56 (QP5 v5.227.12220.39754) */
CREATE OR REPLACE FORCE VIEW MCRE_OWN.V_MCRES_APP_RV_NETTE_MONIT
(
   COD_ABI,
   VAL_ANNOMESE,
   VAL_EFF_VALUTAZIONI,
   VAL_EFF_TRANSAZIONI,
   VAL_RETTIFICA_NETTA,
   VAL_DRC_YTD,
   DESC_ISTITUTO,
   DESC_BREVE,
   FLG_TIPO_ABI
)
AS
   SELECT n.COD_ABI,
          a.VAL_ANNOMESE,
          a.VAL_EFF_VALUTAZIONI,
          a.VAL_EFF_TRANSAZIONI,
          a.VAL_RETTIFICA_NETTA,
          a.VAL_DRC_YTD,
          n.DESC_ISTITUTO,
          n.DESC_BREVE,
          n.FLG_TIPO_ABI
     FROM (  SELECT Z.COD_ABI,
                    Z.VAL_ANNOMESE,
                    SUM (
                       CASE
                          WHEN FLG_GRUPPO = 1 THEN Z.VAL_EFF_VALUTAZIONI
                          ELSE 0
                       END)
                       VAL_EFF_VALUTAZIONI,
                    SUM (
                       CASE
                          WHEN FLG_GRUPPO = 1 THEN Z.VAL_EFF_TRANSAZIONI
                          ELSE 0
                       END)
                       VAL_EFF_TRANSAZIONI,
                    SUM (
                       CASE
                          WHEN FLG_GRUPPO = 1 THEN Z.VAL_RETTIFICA_NETTA
                          ELSE 0
                       END)
                       VAL_RETTIFICA_NETTA,
                    SUM (
                       CASE
                          WHEN FLG_GRUPPO = 5 THEN Z.VAL_RETTIFICA_NETTA
                          ELSE 0
                       END)
                       VAL_DRC_YTD
               FROM T_MCRES_FEN_RETTIFICHE_POS_M Z
              WHERE     VAL_ANNOMESE >=
                           (SELECT SUBSTR (MAX (P.VAL_ANNOMESE), 1, 4) || '01'
                              FROM T_MCRES_FEN_RETTIFICHE_POS_M P)
                    --and n.cod_abi =z.cod_abi(+)
                    AND flg_gruppo IN (1, 5)
           GROUP BY Z.COD_ABI, Z.VAL_ANNOMESE) a,
          t_mcres_app_istituti n
    WHERE n.cod_abi = a.cod_abi(+);
