/* Formatted on 21/07/2014 18:33:30 (QP5 v5.227.12220.39754) */
CREATE OR REPLACE FORCE VIEW MCRE_OWN.V_MCRE0_APP_EMAIL
(
   COD_MATRICOLA,
   VAL_COGNOME,
   VAL_NOME,
   VAL_EMAIL,
   VAL_TELEFONO,
   COD_ISTITUTO,
   COD_UO,
   VAL_SEDE,
   FLG_WEB,
   VAL_NOME_GRUPPO
)
AS
   SELECT e.cod_matric,
          e.val_cognome,
          e.val_nome,
          e.val_email,
          e.val_tel_UFF,
          e.COD_SOCPSPO,
          COD_UO_PSPO,
          DECODE (e.COD_LOPUOPS,
                  'SC', 'SEDE CENTRALE',
                  'FI', 'FILIALE',
                  NULL),
          e.flg_web,
          g.val_nome_gruppo
     FROM t_mcre0_app_email e, t_mcre0_app_email_gruppi g
    WHERE e.cod_matric = g.cod_matricola(+);
