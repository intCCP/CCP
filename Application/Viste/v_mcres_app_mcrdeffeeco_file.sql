/* Formatted on 21/07/2014 18:42:23 (QP5 v5.227.12220.39754) */
CREATE OR REPLACE FORCE VIEW MCRE_OWN.V_MCRES_APP_MCRDEFFEECO_FILE
(
   LINE,
   COD_ABI
)
AS
   SELECT    ID_DPER
          || ','
          || COD_ABI
          || ','
          || DTA_EFFETTI_ECONOMICI
          || ','
          || COD_NDG
          || ','
          || VAL_RIP_MORA
          || ','
          || VAL_PER_CE
          || ','
          || VAL_QUOTA_SVAL
          || ','
          || VAL_QUOTA_ATT
          || ','
          || VAL_RETT_SVAL
          || ','
          || VAL_RIP_SVAL
          || ','
          || VAL_RETT_ATT
          || ','
          || VAL_RIP_ATT
          || ','
          || VAL_ATTUALIZZAZIONE
          || ','
          || COD_STATO_INI
          || ','
          || COD_STATO_FIN
             line,
          COD_ABI
     FROM t_mcres_app_effetti_economici
    WHERE id_dper = (SELECT id_dper
                       FROM V_MCRES_ULTIMA_ACQUISIZIONE
                      WHERE cod_flusso = 'MCRDEFFEECO');
