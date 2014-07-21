/* Formatted on 17/06/2014 18:02:54 (QP5 v5.227.12220.39754) */
CREATE OR REPLACE FORCE VIEW MCRE_OWN.V_MCRE0_APP_QDC_DIM_ORG_DELIB
(
   ID_DPER,
   RECORD_CHAR
)
AS
   SELECT TO_CHAR (SYSDATE, 'yyyymm') AS id_dper,
             '00008'
          || LPAD (NVL (TRIM (cod_abi_istituto), ' '), 5, ' ')
          || LPAD (NVL (TRIM (cod_organo_deliberante), ' '), 2, ' ')
          || LPAD (NVL (TRIM (desc_organo_deliberante), ' '), 250, ' ')
          || '           '
          || 'QDC_DIM_ORG_DELIB'
     FROM (SELECT cod_abi cod_abi_istituto,
                  cod_organo_deliberante,
                  desc_organo_deliberante
             FROM t_mcre0_cl_org_delib
           UNION
           SELECT cod_abi_istituto,
                  cod_organo_deliberante,
                  desc_organo_deliberante
             FROM t_mcre0_cl_organi_deliberanti c
            WHERE     cod_stato_riferimento = 'IN'
                  AND dta_scadenza > SYSDATE
                  AND NOT EXISTS
                             (SELECT NULL
                                FROM t_mcre0_cl_org_delib d
                               WHERE     d.cod_abi = c.cod_abi_istituto
                                     AND d.cod_organo_deliberante =
                                            c.cod_organo_deliberante));


GRANT DELETE, INSERT, REFERENCES, SELECT, UPDATE, ON COMMIT REFRESH, QUERY REWRITE, DEBUG, FLASHBACK, MERGE VIEW ON MCRE_OWN.V_MCRE0_APP_QDC_DIM_ORG_DELIB TO MCRE_USR;
