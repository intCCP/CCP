/* Formatted on 17/06/2014 18:12:29 (QP5 v5.227.12220.39754) */
CREATE OR REPLACE FORCE VIEW MCRE_OWN.V_MCRES_FEN_MCRD_RETTIFICHE_EE
(
   COD_ABI,
   ID_DPER,
   COD_DIVISIONE,
   VAL_RETTIFICA_MESE
)
AS
     SELECT                                                   -- AG 14/12/2011
            -- AG 13/02/2012
            -- AG 09/05/2012
            ee.cod_abi,
            ee.id_dper,
            NVL (cod_divisione, 3) cod_divisione,
            SUM (
                 (ee.val_per_ce + ee.val_rett_sval + ee.val_rett_att)
               - (  ee.val_rip_mora
                  + ee.val_quota_sval
                  + ee.val_quota_att
                  + ee.val_rip_sval
                  + ee.val_rip_att
                  + ee.val_attualizzazione))
               val_rettifica_mese
       FROM t_mcres_app_mcrdeffeeco ee,
            (SELECT id_dper,
                    cod_abi,
                    cod_ndg,
                    CASE
                       WHEN cod_div IN ('DIVRE', 'DIVCI', 'DIVPR')
                       THEN
                          1
                       WHEN o.cod_div IN ('DIVCC', 'DIVLC', 'DIVFI', 'DIVES')
                       THEN
                          2
                       ELSE
                          3
                    END
                       cod_divisione
               FROM (  SELECT id_dper,
                              cod_abi,
                              cod_ndg,
                              MAX (cod_filiale) cod_filiale
                         FROM t_mcres_app_mcrdsisbacp
                        WHERE cod_stato_rischio = 'S'
                     GROUP BY id_dper, cod_abi, cod_ndg) cp,
                    t_mcre0_app_struttura_org o
              WHERE     cod_abi = cod_abi_istituto(+)
                    AND cod_filiale = cod_struttura_competente(+)) d
      WHERE     0 = 0
            AND (ee.cod_stato_fin = 'S' OR ee.cod_stato_ini = 'S')
            AND ee.id_dper = d.id_dper(+)
            AND ee.cod_abi = d.cod_abi(+)
            AND ee.cod_ndg = d.cod_ndg(+)
   GROUP BY ee.id_dper, ee.cod_abi, NVL (cod_divisione, 3);


GRANT SELECT ON MCRE_OWN.V_MCRES_FEN_MCRD_RETTIFICHE_EE TO MCRE_USR;
