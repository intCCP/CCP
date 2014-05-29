CREATE OR REPLACE PACKAGE BODY MCRE_OWN.pkg_mcrei_web_cr_inc
AS
   /******************************************************************************
    NAME:       pkg_mcrei_web_cr_inc
    PURPOSE:

    REVISIONS:
    Ver        Date              Author             Description
    ---------  ----------      -----------------  ------------------------------------
    1.0        17/12/2012        E.Pellizzi         Created this package.
   ******************************************************************************/
   FUNCTION salva_nota (
      p_cod_abi              IN   VARCHAR2,
      p_cod_ndg              IN   VARCHAR2,
      p_cod_numero_pratica   IN   VARCHAR2,
      p_val_anno             IN   NUMERIC,
      p_val_nota             IN   VARCHAR2,
      p_cod_motivo           IN   VARCHAR2,
      p_utente               IN   VARCHAR2
   )
      RETURN NUMBER
   IS
      c_nome   CONSTANT VARCHAR2 (100)          := c_package || '.salva_note';
      note              t_mcrei_wrk_audit_caricamenti.note%TYPE := 'GENERALE';
   BEGIN
      note :=
            'UPDATE T_MCREI_APP_PRATICHE  :'|| p_cod_abi|| ', '|| p_cod_ndg|| ', '|| p_cod_numero_pratica|| ', '|| p_val_anno;

      UPDATE t_mcrei_app_pratiche
         SET val_nota = p_val_nota,
             cod_motivo = p_cod_motivo,
           --  id_utente = p_utente,
             dta_upd = SYSDATE
       WHERE cod_abi = p_cod_abi
         AND cod_ndg = p_cod_ndg
         AND cod_pratica = p_cod_numero_pratica
         AND val_anno_pratica = p_val_anno;

      pkg_mcrei_audit.log_app (c_nome,
                               pkg_mcrei_audit.c_debug,
                               SQLCODE,
                               SQLERRM,
                               note,
                               NULL
                              );
      RETURN ok;
   EXCEPTION
      WHEN OTHERS
      THEN
         pkg_mcrei_audit.log_app (c_nome,
                                  pkg_mcrei_audit.c_debug,
                                  SQLCODE,
                                  SQLERRM,
                                  note,
                                  NULL
                                 );
         RETURN ko;
   END;
END pkg_mcrei_web_cr_inc;
/


CREATE SYNONYM MCRE_APP.PKG_MCREI_WEB_CR_INC FOR MCRE_OWN.PKG_MCREI_WEB_CR_INC;


CREATE SYNONYM MCRE_USR.PKG_MCREI_WEB_CR_INC FOR MCRE_OWN.PKG_MCREI_WEB_CR_INC;


GRANT EXECUTE, DEBUG ON MCRE_OWN.PKG_MCREI_WEB_CR_INC TO MCRE_USR;

