CREATE OR REPLACE PACKAGE BODY MCRE_OWN.PKG_MCRES_FUNZIONI_PORTALEprod
AS
  /******************************************************************************
  NAME:       PKG_MCRES_FUNZIONI_PORTALE
  PURPOSE:
  REVISIONS:
  Ver        Date        Author             Description
  ---------  ----------      -----------------  ------------------------------------
  1.0      14/10/2011  V.Galli       Created this package.
  1.1      29/11/2011  V.Galli       Aggiunta gestione Spese
  1.2      04/01/2012  M.Palladino   creazione funzioni contesto spese(under test)
  1.3      19/01/2012  V.Galli       Gestori
  ******************************************************************************/
  -- Funzione per il mantenimento dello storico dei Gestori delle Pratiche Legali
FUNCTION FNC_MCRES_ALIMENTA_GESTORI(
    P_REC IN F_SLAVE_PAR_TYPE)
  RETURN NUMBER
IS
  c_nome constant varchar2(100) := c_package || '.FNC_MCRES_ALIMENTA_GESTORI';
  v_note varchar2(1000)           :='GENERALE';
  V_COD_ABI T_MCRES_WRK_ACQUISIZIONE.COD_ABI%TYPE;
  
  CURSOR C_LISTA_GESTORI(P_COD_ABI t_mcres_app_pratiche.cod_abi%type)
  IS
    SELECT --- Nuova riga
      P.COD_ABI,
      P.COD_NDG,
      P.COD_PRATICA,
      P.COD_UO_PRATICA,
      P.DTA_APERTURA,
      P.DTA_CHIUSURA,
      p.val_anno,
      substr(p.cod_matr_pratica,2,length(p.cod_matr_pratica)) cod_matr_pratica,
      p.dta_assegn_addet,
      P.FLG_ATTIVA,
      --- Vecchia Riga
      g.cod_matr_pratica cod_matr_pratica_old,
      g.dta_decorrenzaincarico dta_decorrenzaincarico_old
    from t_mcres_app_pratiche p,
           ( select * from (
                select l.cod_abi,l.cod_ndg,l.cod_pratica,l.val_anno_apertura_pl,l.dta_decorrenzaincarico,l.COD_MATR_PRATICA,l.dta_finedecorrenzaincarico,
                      lag(l.dta_decorrenzaincarico) over (partition by l.cod_abi,l.cod_ndg,l.cod_pratica,l.val_anno_apertura_pl order by dta_decorrenzaincarico desc, dta_ins desc ) dta_dec_precedente
                from t_mcres_app_gestori_pl l
                where l.cod_tipo_storico            = 'G'
                ) where dta_dec_precedente is null ) g
    WHERE P.COD_ABI                   = G.COD_ABI
    AND P.COD_NDG                     = G.COD_NDG
    and p.cod_pratica                 = g.cod_pratica
    and p.val_anno = g.val_anno_apertura_pl
    and substr(p.cod_matr_pratica,2,length(p.cod_matr_pratica))  != g.cod_matr_pratica
    and nvl(P.COD_MATR_PRATICA,'U-') != 'U-'
    and g.dta_finedecorrenzaincarico is null
    and p.cod_abi=P_COD_ABI;
    
  CURSOR C_LISTA_NUOVE_PRATICHE(P_COD_ABI t_mcres_app_pratiche.cod_abi%type)
  IS
    SELECT P.COD_ABI,
      P.COD_NDG,
      P.COD_PRATICA,
      P.COD_UO_PRATICA,
      P.DTA_APERTURA,
      P.DTA_CHIUSURA,
      p.val_anno,
      substr(p.cod_matr_pratica,2,length(p.cod_matr_pratica)) cod_matr_pratica,
      p.dta_assegn_addet,
      P.FLG_ATTIVA
    FROM T_MCRES_APP_PRATICHE p
    WHERE NOT EXISTS
      ( SELECT DISTINCT 1
      FROM T_MCRES_APP_GESTORI_PL G
      WHERE g.COD_ABI        = p.COD_ABI
      AND g.COD_NDG          = p.COD_NDG
      and g.cod_pratica      = p.cod_pratica
      and g.val_anno_apertura_pl = p.val_anno
      AND G.COD_TIPO_STORICO = 'G'
      )
    and nvl(P.COD_MATR_PRATICA,'U-') != 'U-'
    and p.cod_abi=P_COD_ABI;
      
begin
  
   BEGIN
    SELECT COD_ABI
    INTO V_COD_ABI
    FROM T_MCRES_WRK_ACQUISIZIONE
    WHERE ID_FLUSSO = P_REC.SEQ_FLUSSO;
  exception
  WHEN OTHERS THEN
    pkg_mcres_audit.log_caricamenti(p_rec.seq_flusso,c_nome,pkg_mcres_audit.c_error,sqlcode,sqlerrm,'COD_ABI='||v_cod_abi);
  end;

  FOR REC_LISTA_GESTORI IN C_LISTA_GESTORI(V_COD_ABI)
  loop
    begin
      v_note := ' Set FINE - Pratica='||rec_lista_gestori.cod_pratica||' ABI='||rec_lista_gestori.cod_abi||' NDG='||rec_lista_gestori.cod_ndg;
      update t_mcres_app_gestori_pl
      SET DTA_FINEDECORRENZAINCARICO  = rec_lista_gestori.dta_assegn_addet-1,
        DTA_UPD                       = SYSDATE
      where cod_pratica               = rec_lista_gestori.cod_pratica
      and val_anno_apertura_pl               = rec_lista_gestori.val_anno
      and cod_abi               = rec_lista_gestori.cod_abi
      and dta_decorrenzaincarico = rec_lista_gestori.dta_decorrenzaincarico_old
      AND DTA_FINEDECORRENZAINCARICO IS NULL
      and cod_matr_pratica            = rec_lista_gestori.cod_matr_pratica_old;
      
      v_note  := ' InsGES - Pratica='||rec_lista_gestori.cod_pratica||' ABI='||rec_lista_gestori.cod_abi||' NDG='||rec_lista_gestori.cod_ndg;
      INSERT
      INTO T_MCRES_APP_GESTORI_PL
        (
          COD_ABI,
          COD_NDG,
          COD_PRATICA,
          COD_UO_PRATICA,
          DTA_APERTURA_PL,
          DTA_CHIUSURA_PL,
          VAL_ANNO_APERTURA_PL,
          COD_MATR_PRATICA,
          DTA_DECORRENZAINCARICO,
          DTA_FINEDECORRENZAINCARICO,
          COD_TIPO_STORICO,
          FLG_ATTIVA,
          DTA_INS
        )
        VALUES
        (
          REC_LISTA_GESTORI.COD_ABI,
          REC_LISTA_GESTORI.COD_NDG,
          REC_LISTA_GESTORI.COD_PRATICA,
          REC_LISTA_GESTORI.COD_UO_PRATICA,
          REC_LISTA_GESTORI.DTA_APERTURA,
          REC_LISTA_GESTORI.DTA_CHIUSURA,
          REC_LISTA_GESTORI.VAL_ANNO,
          rec_lista_gestori.cod_matr_pratica,
          REC_LISTA_GESTORI.dta_assegn_addet, -- DTA_DECORRENZAINCARICO
          NULL,    -- DTA_FINEDECORRENZAINCARICO
          'G',     -- COD_TIPO_STORICO
          REC_LISTA_GESTORI.FLG_ATTIVA,
          SYSDATE  --DTA_INS
        );
      commit;
      
    EXCEPTION
    WHEN OTHERS THEN
      PKG_MCRES_AUDIT.LOG_CARICAMENTI(P_REC.SEQ_FLUSSO,C_NOME,PKG_MCRES_AUDIT.C_ERROR,SQLCODE,SQLERRM,V_NOTE);
      RETURN KO;
    END;
  end loop;
  
  for rec_lista_nuove_pratiche in c_lista_nuove_pratiche(v_cod_abi)
  loop
    begin
      v_note := ' InsPr - Pratica='||rec_lista_nuove_pratiche.cod_pratica||' ABI='||rec_lista_nuove_pratiche.cod_abi||' NDG='||rec_lista_nuove_pratiche.cod_ndg;
      INSERT
      INTO T_MCRES_APP_GESTORI_PL
        (
          COD_ABI,
          COD_NDG,
          COD_PRATICA,
          COD_UO_PRATICA,
          DTA_APERTURA_PL,
          DTA_CHIUSURA_PL,
          VAL_ANNO_APERTURA_PL,
          COD_MATR_PRATICA,
          DTA_DECORRENZAINCARICO,
          DTA_FINEDECORRENZAINCARICO,
          COD_TIPO_STORICO,
          FLG_ATTIVA,
          DTA_INS
        )
        VALUES
        (
          REC_LISTA_NUOVE_PRATICHE.COD_ABI,
          REC_LISTA_NUOVE_PRATICHE.COD_NDG,
          REC_LISTA_NUOVE_PRATICHE.COD_PRATICA,
          REC_LISTA_NUOVE_PRATICHE.COD_UO_PRATICA,
          REC_LISTA_NUOVE_PRATICHE.DTA_APERTURA,
          REC_LISTA_NUOVE_PRATICHE.DTA_CHIUSURA,
          REC_LISTA_NUOVE_PRATICHE.VAL_ANNO,
          rec_lista_nuove_pratiche.cod_matr_pratica,
          REC_LISTA_NUOVE_PRATICHE.dta_assegn_addet, -- DTA_DECORRENZAINCARICO
          NULL,    -- DTA_FINEDECORRENZAINCARICO
          'G',     -- COD_TIPO_STORICO
          REC_LISTA_NUOVE_PRATICHE.FLG_ATTIVA,
          SYSDATE  --DTA_INS
        );
      COMMIT;
    EXCEPTION
    WHEN OTHERS THEN
      PKG_MCRES_AUDIT.LOG_CARICAMENTI(P_REC.SEQ_FLUSSO,C_NOME,PKG_MCRES_AUDIT.C_ERROR,SQLCODE,SQLERRM,V_NOTE);
      RETURN KO;
    END;
  END LOOP;
  RETURN ok;
EXCEPTION
WHEN OTHERS THEN
  PKG_MCRES_AUDIT.LOG_CARICAMENTI(p_rec.SEQ_FLUSSO,C_NOME,PKG_MCRES_AUDIT.C_ERROR,SQLCODE,SQLERRM,V_NOTE);
  RETURN KO;
END FNC_MCRES_ALIMENTA_GESTORI;

END Pkg_Mcres_Funzioni_Portaleprod;
/


CREATE SYNONYM MCRE_APP.PKG_MCRES_FUNZIONI_PORTALEPROD FOR MCRE_OWN.PKG_MCRES_FUNZIONI_PORTALEPROD;


CREATE SYNONYM MCRE_USR.PKG_MCRES_FUNZIONI_PORTALEPROD FOR MCRE_OWN.PKG_MCRES_FUNZIONI_PORTALEPROD;


GRANT EXECUTE, DEBUG ON MCRE_OWN.PKG_MCRES_FUNZIONI_PORTALEPROD TO MCRE_USR;

