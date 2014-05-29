CREATE OR REPLACE PACKAGE MCRE_OWN."PKG_MCRE0_PCR"
AS
   /******************************************************************************
      NAME:     PKG_MCRE0_PCR
      PURPOSE: Gestione alert ed evidenze

      REVISIONS:
      Ver        Date        Author             Description
      ---------  ----------  -----------------  ------------------------------------
      1.0        07/06/2011  Galli Valeria      Created this package.
      1.1        09/06/2011  Galli Valeria      Tabella T_mcre0_app_PCR e LOG
      2.0        08/08/2011  Marco Murro        Aggiunta Gestioen today_flg - tuning!
      2.1        02/09/2011  Marco Murro        Fix Gestioen today_flg - tuning!
      2.2        05/09/2011  Marco Murro        Fix gb_merge per sndg variati
      2.3        06/09/2011  Marco Murro        Fix merge per sndg variati + gestione ko
      2.4        18/10/2011  Luca Ferretti      Modifiche Paola..
      2.5        27/12/2011  Paola Goitre       pcr2 eseguita insieme file_guida (dopo update_file_guida_pre),sostituito NVL(p_id_dper,id_dper) con  NVL(p_id_dper,'99999999')
 
   ******************************************************************************/
   ok   NUMBER := 1;
   ko   NUMBER := 0;

   -- Procedura per calcolo MAU
   -- INPUT :
   -- OUTPUT :
   --    stato esecuzione 1 OK 0 Errori
   FUNCTION fnc_calcolo_mau (
      p_cod_log   t_mcre0_wrk_audit_etl.ID%TYPE DEFAULT NULL,
      p_id_dper   t_mcre0_app_pcr_sc_sb.id_dper%TYPE DEFAULT NULL
   )
      RETURN NUMBER;

   -- Procedura per pulizia delle posizioni di file guida senza pcr
   -- INPUT :
   -- OUTPUT :
   --    stato esecuzione 1 OK 0 Errori
   FUNCTION fnc_clean_no_pcr (
      p_cod_log   t_mcre0_wrk_audit_etl.ID%TYPE DEFAULT NULL,
      p_id_dper   t_mcre0_app_pcr_sc_sb.id_dper%TYPE DEFAULT NULL
   )
      RETURN NUMBER;

   -- Procedura per calcolo pcr
   -- INPUT :
   -- OUTPUT :
   --    stato esecuzione 1 OK 0 Errori
   FUNCTION fnc_load_pcr (
      p_cod_log   t_mcre0_wrk_audit_etl.ID%TYPE DEFAULT NULL,
      p_id_dper   t_mcre0_app_pcr_sc_sb.id_dper%TYPE DEFAULT NULL
   )
      RETURN NUMBER;

   -- Procedura per calcolo pcr scsb con Merge
   --    stato esecuzione 1 OK 0 Errori
   FUNCTION fnc_load_pcr_scsb_merge (
      p_cod_log   t_mcre0_wrk_audit_etl.ID%TYPE DEFAULT NULL,
      p_id_dper   t_mcre0_app_pcr_sc_sb.id_dper%TYPE DEFAULT NULL
   )
      RETURN NUMBER;

   -- Procedura per calcolo pcr gesb con Merge
   --    stato esecuzione 1 OK 0 Errori
   FUNCTION fnc_load_pcr_gesb_merge (
      p_cod_log   t_mcre0_wrk_audit_etl.ID%TYPE DEFAULT NULL,
      p_id_dper   t_mcre0_app_pcr_sc_sb.id_dper%TYPE DEFAULT NULL
   )
      RETURN NUMBER;

   -- Procedura per calcolo pcr gb con Merge
   --    stato esecuzione 1 OK 0 Errori
   FUNCTION fnc_load_pcr_gb_merge (
      p_cod_log   t_mcre0_wrk_audit_etl.ID%TYPE DEFAULT NULL,
      p_id_dper   t_mcre0_app_pcr_sc_sb.id_dper%TYPE DEFAULT NULL
   )
      RETURN NUMBER;
END PKG_MCRE0_PCR;
/


CREATE SYNONYM MCRE_APP.PKG_MCRE0_PCR FOR MCRE_OWN.PKG_MCRE0_PCR;


CREATE SYNONYM MCRE_USR.PKG_MCRE0_PCR FOR MCRE_OWN.PKG_MCRE0_PCR;


GRANT EXECUTE, DEBUG ON MCRE_OWN.PKG_MCRE0_PCR TO MCRE_USR;

