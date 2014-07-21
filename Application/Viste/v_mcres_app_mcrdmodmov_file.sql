/* Formatted on 21/07/2014 18:42:24 (QP5 v5.227.12220.39754) */
CREATE OR REPLACE FORCE VIEW MCRE_OWN.V_MCRES_APP_MCRDMODMOV_FILE
(
   LINE,
   COD_ABI
)
AS
   SELECT    ID_DPER
          || ','
          || COD_ABI
          || ','
          || DTA_MOD_MOV
          || ','
          || DESC_MODULO
          || ','
          || COD_NDG
          || ','
          || VAL_CR_ORDINARIO
          || ','
          || VAL_CR_SPEC
          || ','
          || VAL_CR_INDU
          || ','
          || VAL_CR_TOT
          || ','
          || VAL_DUBES_PREC
          || ','
          || VAL_DUBES_ATT
          || ','
          || COD_STATO_RISCHIO
             line,
          cod_abi
     FROM t_mcres_app_movimenti_mod_mov
    WHERE id_dper = (SELECT id_dper
                       FROM V_MCRES_ULTIMA_ACQUISIZIONE
                      WHERE cod_flusso = 'MCRDMODMOV');
