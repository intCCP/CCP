/* Formatted on 21/07/2014 18:43:59 (QP5 v5.227.12220.39754) */
CREATE OR REPLACE FORCE VIEW MCRE_OWN.V_MCRES_FEN_MONIT_FTECNICA
(
   COD_ABI,
   ID_DPER,
   VAL_ANNOMESE,
   VAL_GBV,
   VAL_NBV,
   VAL_IND_COP,
   COD_FTECNICA
)
AS
     SELECT C.COD_ABI,
            C.ID_DPER,
            SUBSTR (C.ID_DPER, 1, 6) VAL_ANNOMESE,
            SUM (C.VAL_UTI_RET) VAL_GBV,
            SUM (C.VAL_ATT) VAL_NBV,
            DECODE (SUM (C.VAL_UTI_RET),
                    0, 0,
                    (1 - SUM (C.VAL_ATT) / SUM (C.VAL_UTI_RET)))
               VAL_IND_COP,
            NVL (t.cod_ftecnica, 'A') cod_ftecnica
       FROM T_MCRES_APP_SISBA_CP C,
            (  SELECT COD_ABI,
                      COD_NDG,
                      CASE
                         WHEN NVL (R.FLG_CONFIDI, 'N') = 'S' THEN 'C'
                         WHEN NVL (R.FLG_AGEVOLATO, 'N') = 'S' THEN 'G'
                         WHEN NVL (R.FLG_CONTRIBUTO, 'N') = 'S' THEN 'R'
                         WHEN NVL (R.FLG_RAPP_CARTOLARIZZATO, 'N') = 'S' THEN 'Z'
                         WHEN NVL (R.FLG_RAPP_FONDO_TERZO, 'N') = 'S' THEN 'T'
                         ELSE 'A'
                      END
                         cod_ftecnica
                 FROM T_MCRES_APP_RAPPORTI r
             GROUP BY COD_ABI,
                      COD_NDG,
                      CASE
                         WHEN NVL (R.FLG_CONFIDI, 'N') = 'S'
                         THEN
                            'C'
                         WHEN NVL (R.FLG_AGEVOLATO, 'N') = 'S'
                         THEN
                            'G'
                         WHEN NVL (R.FLG_CONTRIBUTO, 'N') = 'S'
                         THEN
                            'R'
                         WHEN NVL (R.FLG_RAPP_CARTOLARIZZATO, 'N') = 'S'
                         THEN
                            'Z'
                         WHEN NVL (R.FLG_RAPP_FONDO_TERZO, 'N') = 'S'
                         THEN
                            'T'
                         ELSE
                            'A'
                      END) t
      WHERE     c.cod_abi = t.cod_abi(+)
            AND C.COD_NDG = T.COD_NDG(+)
            AND C.COD_STATO_RISCHIO = 'S'
   GROUP BY C.COD_ABI, C.ID_DPER, NVL (t.cod_ftecnica, 'A');
