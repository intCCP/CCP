CREATE OR REPLACE PACKAGE MCRE_OWN."PKG_MCREI_REFRESH_AGGREGATE" AS
  /******************************************************************************
     NAME:       PKG_MCREI_REFRESH_MV
     PURPOSE:

     REVISIONS:
     Ver        Date              Author             Description
     ---------  ----------      -----------------  ------------------------------------
     1.0      13/12/2011         E.Pellizzi         Created this package.
     1.1      13/12/2011         E.Pellizzi         Gestite tabelle fisiche.
     1.2      14/12/2011            M.Murro         Aggiunta gestione Rate Impagate
     1.3      14/12/2011            M.Murro         Mascherati valori -1 su utenti e stati
     1.4      15/12/2011            M.Murro         Mascherati valori -1 su gruppo_eco
     1.5      31/01/2012            M.Murro         aggiornata procedure posiz_inc_ri
     1.6      01/02/2012            M.Murro         aggiornata procedure posiz_con_classif
     1.7      02/02/2012            D'ERRICO        aggiunta rank a popolamento posiz_inc_ri
     1.8      07/02/2012            M.Murro         delete invece di truncate, check ultimo refresh
     1.9      15/02/2012            M.Murro         filtrati no delibera e fasi annullate
     2.0      22/02/2012            M.Murro         aggiunta gestione t_mcrei_app_pcr_rapp_aggr
     2.1      22/02/2012            M.Murro         corretta gestione t_mcrei_app_pcr_rapp_aggr
     2.2      27/02/2012            M.Murro         rimosso filtro no CI/CS su posiz inc/ri
     2.3      14/03/2012            M.Murro         fix calcolo data iniziale per delete
     2.4      28/03/2012            M.Murro         fix order by in rank posiz inc_ri
     2.5      30/03/2012            D'errico        modificato calcolo rdv totale in CA + FI
     2.6.     04/04/2012            M.Murro         variata gestione per evitare chiamate simultanee
     2.7      10/04/2012            d'errico        modificata order by per la ranck di recupero rdv_progressiva in posiz_inc_ri
     2.8      26/04/2012            M.Murro         data incaglio da pratiche in posiz_inc_ri
     2.9      06/06/2012            d'errico        modificato cod_tipo_GEstione per posiz_inc_ri
     3.0      13/06/2012            d'errico        aggiunto flg_target , outsourcing e outer su rapp_aggr nall posiz_inc_ri
     3.1      28/06/2012            M.Murro         aggiunto NULLS LAST sul rank della posiz_inc_ri
     3.2      04/07/2012            d'errico        modificata gestione dta_scadenza_stato nelle posiz_inc_ri e con classif
     3.3      17/07/2012            M.Murro         fix posiz inc_ri e con_classif
     3.4      09/11/2012            M.Murro         estensione tabelle con campi DV
     3.5      19/11/2012            I.Gueorguieva   fix fnc_upd_pcr_rapp_aggr gegb_uti_tot direttamente dall'all_data
     3.6      23/01/2013            I.Gueorguieva   Aggiunto popolamanto campo cod_livello in fnc_mcrei_mv_posiz_con_classif, fnc_mcrei_mv_posiz_inc_ri     
     3.7      11/02/2013            d'errico        corretta fnc_mcrei_mv_posiz_inc_ri invertendo popolamento data scadenza stato e data scadenza permanenza nel servizio
     3.8      30/05/2013            M.Murro         corretta fnc_mcrei_mv_posiz_inc_ri per cod_tipo_gestione da pratica e non delibera
    ******************************************************************************/
  c_package CONSTANT VARCHAR2(50) := 'PKG_MCREI_REFRESH_AGGREGATE';
  ok NUMBER := 1;
  ko NUMBER := 0;
  delayed CONSTANT NUMBER := -1;

  FUNCTION fnc_mcrei_mv_posiz_inc_ri(seq_flusso IN NUMBER DEFAULT NULL)
    RETURN NUMBER;

  FUNCTION fnc_mcrei_mv_posiz_con_classif(seq_flusso IN NUMBER DEFAULT NULL)
    RETURN NUMBER;

  FUNCTION fnc_upd_rate_impagate(seq_flusso IN NUMBER) RETURN NUMBER;

  FUNCTION fnc_upd_pcr_rapp_aggr(seq_flusso IN NUMBER) RETURN NUMBER;

END pkg_mcrei_refresh_aggregate;
/


CREATE SYNONYM MCRE_APP.PKG_MCREI_REFRESH_AGGREGATE FOR MCRE_OWN.PKG_MCREI_REFRESH_AGGREGATE;


CREATE SYNONYM MCRE_USR.PKG_MCREI_REFRESH_AGGREGATE FOR MCRE_OWN.PKG_MCREI_REFRESH_AGGREGATE;


GRANT EXECUTE, DEBUG ON MCRE_OWN.PKG_MCREI_REFRESH_AGGREGATE TO MCRE_USR;

