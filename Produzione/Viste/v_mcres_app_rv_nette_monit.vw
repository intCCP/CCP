/* Formatted on 17/06/2014 18:11:18 (QP5 v5.227.12220.39754) */
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
     SELECT Z.COD_ABI,
            Z.VAL_ANNOMESE,
            SUM (
               CASE WHEN FLG_GRUPPO = 1 THEN Z.VAL_EFF_VALUTAZIONI ELSE 0 END)
               VAL_EFF_VALUTAZIONI,
            SUM (
               CASE WHEN FLG_GRUPPO = 1 THEN Z.VAL_EFF_TRANSAZIONI ELSE 0 END)
               VAL_EFF_TRANSAZIONI,
            SUM (
               CASE WHEN FLG_GRUPPO = 4 THEN Z.VAL_RETTIFICA_NETTA ELSE 0 END)
               VAL_RETTIFICA_NETTA,
            SUM (
               CASE WHEN FLG_GRUPPO = 5 THEN Z.VAL_RETTIFICA_NETTA ELSE 0 END)
               VAL_DRC_YTD,
            n.desc_istituto,
            n.desc_breve,
            n.flg_tipo_abi
       FROM T_MCRES_FEN_RETTIFICHE_POS_M Z, T_MCRE0_APP_ISTITUTI N
      WHERE     VAL_ANNOMESE >=
                   (SELECT SUBSTR (MAX (P.VAL_ANNOMESE), 1, 4) || '01'
                      FROM T_MCRES_FEN_RETTIFICHE_POS_M P)
            AND n.cod_abi = z.cod_abi
            AND n.flg_soff = 1
   GROUP BY Z.COD_ABI,
            Z.VAL_ANNOMESE,
            n.desc_istituto,
            n.desc_breve,
            n.flg_tipo_abi;


GRANT DELETE, INSERT, REFERENCES, SELECT, UPDATE, ON COMMIT REFRESH, QUERY REWRITE, DEBUG, FLASHBACK, MERGE VIEW ON MCRE_OWN.V_MCRES_APP_RV_NETTE_MONIT TO MCRE_USR;
