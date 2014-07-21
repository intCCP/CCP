/* Formatted on 17/06/2014 18:15:41 (QP5 v5.227.12220.39754) */
CREATE OR REPLACE FORCE VIEW MCRE_OWN.VTMCRE0_APP_EMAIL
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
          e.val_tel_uff,
          e.cod_socpspo,
          cod_uo_pspo,
          DECODE (e.cod_lopuops,
                  'SC', 'SEDE CENTRALE',
                  'FI', 'FILIALE',
                  NULL),
          e.flg_web,
          g.val_nome_gruppo
     FROM mcre_own.t_mcre0_dwh_rubr e, t_mcre0_app_email_gruppi g
    WHERE e.cod_matric = g.cod_matricola(+);


GRANT DELETE, INSERT, REFERENCES, SELECT, UPDATE, ON COMMIT REFRESH, QUERY REWRITE, DEBUG, FLASHBACK ON MCRE_OWN.VTMCRE0_APP_EMAIL TO MCRE_USR;
