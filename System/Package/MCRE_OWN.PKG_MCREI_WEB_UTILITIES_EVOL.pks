CREATE OR REPLACE PACKAGE MCRE_OWN.PKG_MCREI_WEB_UTILITIES_EVOL AS
/******************************************************************************
NAME:       PKG_MCREI_WEB_UTILITIES_EVOL
PURPOSE:

REVISIONS:
Ver        Date        Author           Description
---------  ----------  ---------------  ------------------------------------
1.0        04/09/2012                    Created this package.
1.1        21/01/2014   T.Bernardi       Modificate le fnc FNC_ANNULLA_PAC_MODIFICATO, FNC_ANNULLA_PAC_MODIFICATO con aggiunta campi annullo delibera
IN PRODUZIONE ESEGUIRE PRIMA:
ALTER TABLE T_MCREI_APP_DELIBERE ADD
(COD_FASE_MICROTIP_PRE_ADD VARCHAR2(5),
COD_FASE_DELIB_PRE_ADD VARCHAR2(2),
COD_PACCHETTO_MODIFICATO VARCHAR2(30),
COD_MICROTIP_VARIAZIONE VARCHAR2(200),
COD_DELIBERA_MODIFICATO VARCHAR2(17)
);
******************************************************************************/
const_esito_ok         CONSTANT NUMBER := 1;
const_esito_ko         CONSTANT NUMBER := 0;
c_package VARCHAR2(30) := 'PKG_MCREI_WEB_UTILITIES_EVOL';


FUNCTION fnc_modifica_fasi(p_cod_abi t_mcrei_app_delibere.cod_abi%TYPE,
             p_cod_ndg t_mcrei_app_delibere.cod_ndg%TYPE,
             p_cod_sndg t_mcrei_app_delibere.cod_sndg%TYPE,
             p_cod_protocollo_delibera t_mcrei_app_delibere.cod_protocollo_delibera%TYPE,
             p_utente_ins   VARCHAR2,
             p_elenco_flag  VARCHAR2,
             p_cod_protocollo_pacchetto t_mcrei_app_delibere.cod_protocollo_pacchetto%TYPE default NULL,
             p_flg_sostituzione VARCHAR2 default NULL --Deve valere 1 per sostituzioni
            )
             RETURN VARCHAR2;

FUNCTION fnc_conf_pac_modificato
                (p_cod_protocollo_pacchetto t_mcrei_app_delibere.cod_protocollo_pacchetto%TYPE,
                 p_flg_sostituzione VARCHAR2 default NULL --Deve valere 1 per sostituzioni
                 )
                  RETURN NUMBER;

FUNCTION FNC_ANNULLA_PAC_MODIFICATO(P_COD_PROTOCOLLO_PACCHETTO T_MCREI_APP_DELIBERE.COD_PROTOCOLLO_PACCHETTO%TYPE,
                                    P_COD_MICROTIPOLOGIA_DELIB T_MCREI_APP_DELIBERE.COD_MICROTIPOLOGIA_DELIB%TYPE DEFAULT NULL--,
                                   -- P_DTA_ANNULLO IN T_MCREI_APP_DELIBERE.DTA_ANNULLO%TYPE DEFAULT SYSDATE,
                                    --P_COD_MATRICOLA_ANNULLO IN T_MCREI_APP_DELIBERE.COD_MATRICOLA_ANNULLO%TYPE DEFAULT NULL,
                                    --P_COD_OPERA_COME_ANNULLO IN T_MCREI_APP_DELIBERE.COD_OPERA_COME_ANNULLO%TYPE DEFAULT NULL,
                                    --P_DESC_NOTE_DELIBERE_ANNULLATE IN T_MCREI_APP_DELIBERE.DESC_NOTE_DELIBERE_ANNULLATE%TYPE DEFAULT NULL
                                    )
                                    RETURN NUMBER;


FUNCTION FNC_IS_AR_RG_LIV_AREA(P_COD_COMPARTO IN T_MCRE0_APP_ALL_DATA.COD_COMPARTO_ASSEGNATO%TYPE) RETURN BOOLEAN;

   FUNCTION new_rap_conf_invio_host(p_cod_abi T_MCRE0_APP_NEW_RAPP_OP.cod_abi%TYPE,
             p_cod_ndg T_MCRE0_APP_NEW_RAPP_OP.cod_ndg%TYPE,
             p_cod_protocollo_delibera T_MCRE0_APP_NEW_RAPP_OP.cod_protocollo_delibera%TYPE,
             p_val_ordinale T_MCRE0_APP_NEW_RAPP_OP.val_ordinale%TYPE
            )
             RETURN VARCHAR2;




END PKG_MCREI_WEB_UTILITIES_EVOL;
/


CREATE SYNONYM MCRE_APP.PKG_MCREI_WEB_UTILITIES_EVOL FOR MCRE_OWN.PKG_MCREI_WEB_UTILITIES_EVOL;


CREATE SYNONYM MCRE_USR.PKG_MCREI_WEB_UTILITIES_EVOL FOR MCRE_OWN.PKG_MCREI_WEB_UTILITIES_EVOL;


GRANT EXECUTE, DEBUG ON MCRE_OWN.PKG_MCREI_WEB_UTILITIES_EVOL TO MCRE_USR;

