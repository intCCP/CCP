CREATE OR REPLACE PACKAGE BODY MCRE_OWN."PKG_MCRE0_STORICIZZA" AS
/******************************************************************************
   NAME:       PKG_MCRE0_STORICIZZA
   PURPOSE:

   REVISIONS:
   Ver        Date        Author           Description
   ---------  ----------  ---------------  ------------------------------------
   1.0        18/10/2010          M.Murro. Created this package.
   2.0        23/11/2010          M.Murro. Uso MV, cambio gestione flag
   2.1        08/02/2011          M.Murro. fix storicizza operatore_ins_upd
   2.2        21/02/2011          Gianna . storicizza mese
   3.0        07/03/2011          M.Murro  Storico esteso da nuova ana_gen
   3.1        05/04/2011          M.Murro  Nuova gestione flg_stato 2, storico mensile non su 1900
   3.2        19/04/2011          M.Murro  Fix cursore variati su storico caricamenti
   3.3        22/04/2011          M.Murro  Fix storicizzazione con filtro su max(id_dper)
   3.4        04/05/2011          M.Murro  Aggiunta gestione CR e Servizio
   3.5        16/06/2011          M.Murro  Aggiunta cod_sag
   3.6        30/06/2011          M.Murro  sostituita Log_error!
   3.7        11/07/2011          M.Murro  integrati nuyovi campi PCR
   4.0        25/07/2011          M.Murro  TUNING.. campo fine_val_tr
******************************************************************************/


-- salva lo stato generale per singolo abi/ndg - no commit
  function insert_storico_ndg(p_abi_cart IN varchar2, p_ndg IN varchar2,
            p_fl_comparto varchar2, p_fl_gestore varchar2, p_fl_stato varchar2, p_fl_mese varchar2) return number IS

  new_record  MCRE_OWN.V_MCRE0_ANAGRAFICA_GENERALE%rowtype;

  dt_inizio_val date := null;
  dt_fine_gestore date  := null;
  dt_inival_storico date := null;
  last_id_utente number := -1;
  v_oper varchar2(20) := null;

  fl_cambio_gestore  varchar2(1) := 0;
  fl_cambio_comparto varchar2(1) := 0;
  fl_cambio_stato    varchar2(1) := 0;
  fl_cambio_mese     varchar2(1) := 0;


  BEGIN

   begin
    --registro la situazione attuale dalla MV+tabelle live
    select *
    into new_record
    from MCRE_OWN.V_MCRE0_ANAGRAFICA_GENERALE mv
    where mv.COD_ABI_CARTOLARIZZATO = p_abi_cart
    and  mv.COD_NDG = p_ndg;

   exception when others then
        log_error(c_package||'.insert_storico_ndg:new_record', SQLCODE, SQLERRM ||' abi cart:'||p_abi_cart||' ndg:'||p_ndg);
        return ok;
   end;

  --V3.1 non effettuo più gli arricchimenti accessori
  /*
    --recupero la data fine validità dell'ultimo record storico inserito (se esistente)
    begin

    select DTA_INI_VALIDITA, nvl(DTA_FINE_VALIDITA, trunc(sysdate)), nvl(id_utente,-1)
    into dt_inival_storico, dt_inizio_val, last_id_utente
    from (
        select DTA_INI_VALIDITA, DTA_FINE_VALIDITA, id_utente
        from MCRE_OWN.T_MCRE0_APP_STORICO_EVENTI r
        where r.COD_ABI_CARTOLARIZZATO = p_abi_cart
        and r.COD_NDG = p_ndg
        order by DTA_FINE_VALIDITA desc)
    where rownum = 1;

    exception when no_data_found then
        dt_inizio_val := sysdate;
        last_id_utente := -1;
    end;

    --segno la fine gestore sullo storico se ho un cambio gestore
    begin

    if (nvl(NEW_RECORD.ID_UTENTE,-1) != last_id_utente) then
        update MCRE_OWN.T_MCRE0_APP_STORICO_EVENTI
        set DTA_FINE_UTENTE = dt_inizio_val
        where COD_ABI_CARTOLARIZZATO = p_abi_cart
        and COD_NDG = p_ndg
        and DTA_INI_VALIDITA = dt_inival_storico;
    end if;

    exception when others then
        log_caricamenti(c_package||'.insert_storico_ndg - chiusura gestore storico',sqlcode, sqlerrm|| 'abi: '||p_abi_cart||' ndg: '||p_ndg);
    end;
   */
    --calcolo l'utente che opera l'upd
    -- v4.0 è quello di ALL_DATA --> MV_ana_gen
--    begin
--     select COD_OPERATORE_INS_UPD into v_oper from
--        (select F.COD_OPERATORE_INS_UPD, F.DTA_UPD from MCRE_OWN.T_MCRE0_APP_FILE_GUIDA f
--        where F.COD_ABI_CARTOLARIZZATO = p_abi_cart
--        and F.COD_NDG = p_ndg
--        union all
--        select M.COD_OPERATORE_INS_UPD, M.DTA_UPD from MCRE_OWN.T_MCRE0_APP_MOPLE m
--        where M.COD_ABI_CARTOLARIZZATO = p_abi_cart
--        and M.COD_NDG = p_ndg
--        order by DTA_UPD desc)
--     where rownum = 1;
--    exception when others then
--        v_oper := null;
--    end;

    --inserisco la nuova riga di storico
    begin

    INSERT INTO MCRE_OWN.T_MCRE0_APP_STORICO_EVENTI
            (COD_ABI_ISTITUTO, COD_ABI_CARTOLARIZZATO,
             COD_NDG, COD_SNDG, DTA_INI_VALIDITA, DTA_FINE_VALIDITA,DTA_FINE_VAL_TR,
             FLG_CAMBIO_STATO, FLG_CAMBIO_GESTORE, FLG_CAMBIO_COMPARTO,
             FLG_CAMBIO_MESE, DESC_NOME_CONTROPARTE,
             COD_GRUPPO_LEGAME, COD_GRUPPO_ECONOMICO,
             COD_GRUPPO_SUPER, DTA_INTERCETTAMENTO,
             COD_FILIALE, COD_STRUTTURA_COMPETENTE,
             COD_COMPARTO_HOST,COD_RAMO_HOST,
             COD_COMPARTO_CALCOLATO_PRE,
             COD_COMPARTO_CALCOLATO,
             COD_COMPARTO_ASSEGNATO, COD_PERCORSO,
             COD_PROCESSO, COD_STATO,
             DTA_DECORRENZA_STATO, DTA_SCADENZA_STATO,
             COD_STATO_PRECEDENTE, COD_TIPO_INGRESSO,
             ID_TRANSIZIONE, DTA_PROCESSO,
             ID_REFERENTE, ID_UTENTE,
             ID_UTENTE_PRE, DTA_INI_UTENTE,
             DTA_FINE_UTENTE, FLG_SOMMA,
             FLG_RIPORTAFOGLIATO, FLG_GRUPPO_ECONOMICO,
             FLG_GRUPPO_LEGAME, FLG_SINGOLO,
             FLG_CONDIVISO, COD_OPERATORE_INS_UPD,
             SCSB_UTI_CASSA, SCSB_UTI_FIRMA,
             SCSB_ACC_CASSA, SCSB_ACC_FIRMA,
             SCSB_UTI_CASSA_BT, SCSB_UTI_CASSA_MLT,
             SCSB_UTI_SMOBILIZZO, SCSB_UTI_FIRMA_DT,
             SCSB_ACC_CASSA_BT, SCSB_ACC_CASSA_MLT,
             SCSB_ACC_SMOBILIZZO, SCSB_ACC_FIRMA_DT,
             SCSB_TOT_GAR, SCSB_UTI_TOT,
             SCSB_ACC_TOT, SCSB_DTA_RIFERIMENTO,
             GESB_UTI_CASSA, GESB_UTI_FIRMA,
             GESB_ACC_CASSA, GESB_ACC_FIRMA,
             GESB_UTI_CASSA_BT, GESB_UTI_CASSA_MLT,
             GESB_UTI_SMOBILIZZO, GESB_UTI_FIRMA_DT,
             GESB_ACC_CASSA_BT, GESB_ACC_CASSA_MLT,
             GESB_ACC_SMOBILIZZO, GESB_ACC_FIRMA_DT,
             GESB_TOT_GAR, GESB_DTA_RIFERIMENTO,
             SCGB_UTI_CASSA, SCGB_UTI_FIRMA,
             SCGB_ACC_CASSA, SCGB_ACC_FIRMA,
             SCGB_UTI_CASSA_BT, SCGB_UTI_CASSA_MLT,
             SCGB_UTI_SMOBILIZZO, SCGB_UTI_FIRMA_DT,
             SCGB_ACC_CASSA_BT, SCGB_ACC_CASSA_MLT,
             SCGB_ACC_SMOBILIZZO, SCGB_ACC_FIRMA_DT,
             SCGB_TOT_GAR, GEGB_UTI_CASSA,
             GEGB_UTI_FIRMA, GEGB_ACC_CASSA,
             GEGB_ACC_FIRMA, GEGB_UTI_CASSA_BT,
             GEGB_UTI_CASSA_MLT, GEGB_UTI_SMOBILIZZO,
             GEGB_UTI_FIRMA_DT, GEGB_ACC_CASSA_BT,
             GEGB_ACC_CASSA_MLT, GEGB_ACC_SMOBILIZZO,
             GEGB_ACC_FIRMA_DT, GEGB_TOT_GAR,
             GLGB_UTI_CASSA, GLGB_UTI_FIRMA,
             GLGB_ACC_CASSA, GLGB_ACC_FIRMA,
             GLGB_UTI_CASSA_BT, GLGB_UTI_CASSA_MLT,
             GLGB_UTI_SMOBILIZZO, GLGB_UTI_FIRMA_DT,
             GLGB_ACC_CASSA_BT, GLGB_ACC_CASSA_MLT,
             GLGB_ACC_SMOBILIZZO, GLGB_ACC_FIRMA_DT,
             GLGB_TOT_GAR, GB_DTA_RIFERIMENTO,
             GB_VAL_MAU, VAL_LGD, DTA_LGD,
             VAL_EAD, DTA_EAD, VAL_PA,
             DTA_PA, VAL_PD_ONLINE,
             DTA_PD_ONLINE, VAL_RATING_ONLINE,
             VAL_PD, DTA_PD, VAL_RATING,
             VAL_IRIS_GE, VAL_IRIS_CLI, DTA_IRIS,
             LIV_RISCHIO_GE, LIV_RISCHIO_CLI,
             VAL_SCONFINO, COD_RAP,
             VAL_SCONFINO_RAP, FLG_ALLINEATO_SAG,
             FLG_CONFERMA_SAG, DTA_CONFERMA_SAG,
             --v3.0
             ID_DPER_FG, COD_PEF, COD_FASE_PEF,
             DTA_ULTIMA_REVISIONE_PEF, DTA_SCADENZA_FIDO, DTA_ULTIMA_DELIBERA,
             FLG_FIDI_SCADUTI, DAT_ULTIMO_SCADUTO, COD_ULTIMO_ODE, COD_CTS_ULTIMO_ODE,
             COD_STRATEGIA_CRZ, COD_ODE, DTA_COMPLETAMENTO_PEF,
             --v3.4
             COD_SERVIZIO, DTA_SERVIZIO,
             SCSB_ACC_CR, SCSB_UTI_CR, SCSB_GAR_CR,
             SCSB_SCO_CR, SCSB_QIS_ACC, SCSB_QIS_UTI,
             SCGB_ACC_CR, SCGB_ACC_SIS, SCGB_GAR_CR,
             SCGB_GAR_SIS, SCGB_SCO_CR, SCGB_SCO_SIS, SCGB_UTI_CR,
             SCGB_UTI_SIS, SCGB_QIS_ACC, SCGB_QIS_UTI,
             SCGB_DTA_RIF_CR, SCGB_DTA_STATO_SIS, SCGB_COD_STATO_SIS,
             SCGB_ID_DPER, GESB_ACC_CR, GESB_UTI_CR, GESB_GAR_CR,
             GESB_SCO_CR, GESB_QIS_ACC, GESB_QIS_UTI,
             GEGB_ACC_CR, GEGB_ACC_SIS, GEGB_UTI_CR, GEGB_UTI_SIS,
             GEGB_GAR_CR, GEGB_GAR_SIS, GEGB_SCO_CR, GEGB_SCO_SIS,
             GEGB_QIS_ACC, GEGB_QIS_UTI, GLGB_ACC_CR,
             GLGB_UTI_CR, GLGB_SCO_CR, GLGB_GAR_CR, GLGB_ACC_SIS,
             GLGB_UTI_SIS, GLGB_SCO_SIS, GLGB_IMP_GAR_SIS,
             GLGB_QIS_ACC, GLGB_QIS_UTI, GEGB_DTA_RIF_CR,
             GESB_DTA_CR, GLGB_DTA_RIF_CR, SCSB_DTA_CR,
             --v3.5
             COD_SAG,
             --v3.7 nuovi pcr
             SCSB_UTI_SOSTITUZIONI, SCSB_UTI_MASSIMALI, SCSB_UTI_RISCHI_INDIRETTI,
             SCSB_ACC_SOSTITUZIONI, SCSB_ACC_MASSIMALI, SCSB_ACC_RISCHI_INDIRETTI, GESB_UTI_MASSIMALI,
             GESB_UTI_RISCHI_INDIRETTI, GESB_ACC_SOSTITUZIONI, GESB_ACC_MASSIMALI, GESB_ACC_RISCHI_INDIRETTI,
             SCGB_UTI_MASSIMALI, SCGB_UTI_RISCHI_INDIRETTI, SCGB_ACC_SOSTITUZIONI, SCGB_ACC_MASSIMALI,
             SCGB_ACC_RISCHI_INDIRETTI, GLGB_UTI_MASSIMALI, GLGB_UTI_RISCHI_INDIRETTI, GLGB_ACC_SOSTITUZIONI,
             GLGB_ACC_MASSIMALI, GLGB_ACC_RISCHI_INDIRETTI, GESB_UTI_SOSTITUZIONI, SCGB_UTI_SOSTITUZIONI,
             GEGB_UTI_SOSTITUZIONI, GLGB_UTI_SOSTITUZIONI, GEGB_UTI_MASSIMALI, GEGB_UTI_RISCHI_INDIRETTI,
             GEGB_ACC_SOSTITUZIONI, GEGB_ACC_MASSIMALI, GEGB_ACC_RISCHI_INDIRETTI, SCSB_UTI_CONSEGNE,
             SCSB_ACC_CONSEGNE, SCGB_UTI_CONSEGNE, SCGB_ACC_CONSEGNE, GESB_UTI_CONSEGNE, GESB_ACC_CONSEGNE,
             GEGB_UTI_CONSEGNE, GEGB_ACC_CONSEGNE, GLGB_UTI_CONSEGNE, GLGB_ACC_CONSEGNE
            )
     VALUES (NEW_RECORD.COD_ABI_ISTITUTO, NEW_RECORD.COD_ABI_CARTOLARIZZATO,
             NEW_RECORD.COD_NDG, NEW_RECORD.COD_SNDG, DT_INIZIO_VAL, SYSDATE, trunc(SYSDATE),
             P_FL_STATO, P_FL_GESTORE, P_FL_COMPARTO,
             P_FL_MESE, NEW_RECORD.DESC_NOME_CONTROPARTE,
             NEW_RECORD.COD_GRUPPO_LEGAME, NEW_RECORD.COD_GRUPPO_ECONOMICO,
             NEW_RECORD.COD_GRUPPO_SUPER, NEW_RECORD.DTA_INTERCETTAMENTO,
             NEW_RECORD.COD_FILIALE, NEW_RECORD.COD_STRUTTURA_COMPETENTE,
             NEW_RECORD.COD_COMPARTO_HOST,NEW_RECORD.COD_RAMO_HOST,
             NEW_RECORD.COD_COMPARTO_CALCOLATO_PRE,
             NEW_RECORD.COD_COMPARTO_CALCOLATO,
             NEW_RECORD.COD_COMPARTO_ASSEGNATO, NEW_RECORD.COD_PERCORSO,
             NEW_RECORD.COD_PROCESSO, NEW_RECORD.COD_STATO,
             NEW_RECORD.DTA_DECORRENZA_STATO, NEW_RECORD.DTA_SCADENZA_STATO,
             NEW_RECORD.COD_STATO_PRECEDENTE, NEW_RECORD.COD_TIPO_INGRESSO,
             NEW_RECORD.ID_TRANSIZIONE, NEW_RECORD.DTA_PROCESSO,
             NEW_RECORD.ID_REFERENTE, NEW_RECORD.ID_UTENTE,
             NEW_RECORD.ID_UTENTE_PRE, NEW_RECORD.DTA_UTENTE_ASSEGNATO,
             DT_FINE_GESTORE, NEW_RECORD.FLG_SOMMA,
             NEW_RECORD.FLG_RIPORTAFOGLIATO, NEW_RECORD.FLG_GRUPPO_ECONOMICO,
             NEW_RECORD.FLG_GRUPPO_LEGAME, NEW_RECORD.FLG_SINGOLO,
             NEW_RECORD.FLG_CONDIVISO, NEW_RECORD.COD_OPERATORE_INS_UPD, -- <--v_oper,
             NEW_RECORD.SCSB_UTI_CASSA, NEW_RECORD.SCSB_UTI_FIRMA,
             NEW_RECORD.SCSB_ACC_CASSA, NEW_RECORD.SCSB_ACC_FIRMA,
             NEW_RECORD.SCSB_UTI_CASSA_BT, NEW_RECORD.SCSB_UTI_CASSA_MLT,
             NEW_RECORD.SCSB_UTI_SMOBILIZZO, NEW_RECORD.SCSB_UTI_FIRMA_DT,
             NEW_RECORD.SCSB_ACC_CASSA_BT, NEW_RECORD.SCSB_ACC_CASSA_MLT,
             NEW_RECORD.SCSB_ACC_SMOBILIZZO, NEW_RECORD.SCSB_ACC_FIRMA_DT,
             NEW_RECORD.SCSB_TOT_GAR, NEW_RECORD.SCSB_UTI_TOT,
             NEW_RECORD.SCSB_ACC_TOT, NEW_RECORD.SCSB_DTA_RIFERIMENTO,
             NEW_RECORD.GESB_UTI_CASSA, NEW_RECORD.GESB_UTI_FIRMA,
             NEW_RECORD.GESB_ACC_CASSA, NEW_RECORD.GESB_ACC_FIRMA,
             NEW_RECORD.GESB_UTI_CASSA_BT, NEW_RECORD.GESB_UTI_CASSA_MLT,
             NEW_RECORD.GESB_UTI_SMOBILIZZO, NEW_RECORD.GESB_UTI_FIRMA_DT,
             NEW_RECORD.GESB_ACC_CASSA_BT, NEW_RECORD.GESB_ACC_CASSA_MLT,
             NEW_RECORD.GESB_ACC_SMOBILIZZO, NEW_RECORD.GESB_ACC_FIRMA_DT,
             NEW_RECORD.GESB_TOT_GAR, NEW_RECORD.GESB_DTA_RIFERIMENTO,
             NEW_RECORD.SCGB_UTI_CASSA, NEW_RECORD.SCGB_UTI_FIRMA,
             NEW_RECORD.SCGB_ACC_CASSA, NEW_RECORD.SCGB_ACC_FIRMA,
             NEW_RECORD.SCGB_UTI_CASSA_BT, NEW_RECORD.SCGB_UTI_CASSA_MLT,
             NEW_RECORD.SCGB_UTI_SMOBILIZZO, NEW_RECORD.SCGB_UTI_FIRMA_DT,
             NEW_RECORD.SCGB_ACC_CASSA_BT, NEW_RECORD.SCGB_ACC_CASSA_MLT,
             NEW_RECORD.SCGB_ACC_SMOBILIZZO, NEW_RECORD.SCGB_ACC_FIRMA_DT,
             NEW_RECORD.SCGB_TOT_GAR, NEW_RECORD.GEGB_UTI_CASSA,
             NEW_RECORD.GEGB_UTI_FIRMA, NEW_RECORD.GEGB_ACC_CASSA,
             NEW_RECORD.GEGB_ACC_FIRMA, NEW_RECORD.GEGB_UTI_CASSA_BT,
             NEW_RECORD.GEGB_UTI_CASSA_MLT, NEW_RECORD.GEGB_UTI_SMOBILIZZO,
             NEW_RECORD.GEGB_UTI_FIRMA_DT, NEW_RECORD.GEGB_ACC_CASSA_BT,
             NEW_RECORD.GEGB_ACC_CASSA_MLT, NEW_RECORD.GEGB_ACC_SMOBILIZZO,
             NEW_RECORD.GEGB_ACC_FIRMA_DT, NEW_RECORD.GEGB_TOT_GAR,
             NEW_RECORD.GLGB_UTI_CASSA, NEW_RECORD.GLGB_UTI_FIRMA,
             NEW_RECORD.GLGB_ACC_CASSA, NEW_RECORD.GLGB_ACC_FIRMA,
             NEW_RECORD.GLGB_UTI_CASSA_BT, NEW_RECORD.GLGB_UTI_CASSA_MLT,
             NEW_RECORD.GLGB_UTI_SMOBILIZZO, NEW_RECORD.GLGB_UTI_FIRMA_DT,
             NEW_RECORD.GLGB_ACC_CASSA_BT, NEW_RECORD.GLGB_ACC_CASSA_MLT,
             NEW_RECORD.GLGB_ACC_SMOBILIZZO, NEW_RECORD.GLGB_ACC_FIRMA_DT,
             NEW_RECORD.GLGB_TOT_GAR, NEW_RECORD.GB_DTA_RIFERIMENTO,
             NEW_RECORD.GB_VAL_MAU, NEW_RECORD.VAL_LGD, NEW_RECORD.DTA_LGD,
             NEW_RECORD.VAL_EAD, NEW_RECORD.DTA_EAD, NEW_RECORD.VAL_PA,
             NEW_RECORD.DTA_PA, NEW_RECORD.VAL_PD_ONLINE,
             NEW_RECORD.DTA_PD_ONLINE, NEW_RECORD.VAL_RATING_ONLINE,
             NEW_RECORD.VAL_PD, NEW_RECORD.DTA_PD, NEW_RECORD.VAL_RATING,
             NEW_RECORD.VAL_IRIS_GE, NEW_RECORD.VAL_IRIS_CLI, NEW_RECORD.DTA_IRIS,
             NEW_RECORD.LIV_RISCHIO_GE, NEW_RECORD.LIV_RISCHIO_CLI,
             NEW_RECORD.VAL_SCONFINO, NEW_RECORD.COD_RAP,
             NEW_RECORD.VAL_SCONFINO_RAP, NEW_RECORD.FLG_ALLINEATO_SAG,
             NEW_RECORD.FLG_CONFERMA_SAG, NEW_RECORD.DTA_CONFERMA_SAG,
             --v3.0
             NEW_RECORD.ID_DPER_FG, NEW_RECORD.COD_PEF, NEW_RECORD.COD_FASE_PEF,
             NEW_RECORD.DTA_ULTIMA_REVISIONE_PEF, NEW_RECORD.DTA_SCADENZA_FIDO,
             NEW_RECORD.DTA_ULTIMA_DELIBERA, NEW_RECORD.FLG_FIDI_SCADUTI,
             NEW_RECORD.DAT_ULTIMO_SCADUTO, NEW_RECORD.COD_ULTIMO_ODE, NEW_RECORD.COD_CTS_ULTIMO_ODE,
             NEW_RECORD.COD_STRATEGIA_CRZ, NEW_RECORD.COD_ODE, NEW_RECORD.DTA_COMPLETAMENTO_PEF,
             --v3.4
             NEW_RECORD.COD_SERVIZIO, NEW_RECORD.DTA_SERVIZIO,
             NEW_RECORD.SCSB_ACC_CR, NEW_RECORD.SCSB_UTI_CR, NEW_RECORD.SCSB_GAR_CR,
             NEW_RECORD.SCSB_SCO_CR, NEW_RECORD.SCSB_QIS_ACC, NEW_RECORD.SCSB_QIS_UTI,
             NEW_RECORD.SCGB_ACC_CR, NEW_RECORD.SCGB_ACC_SIS, NEW_RECORD.SCGB_GAR_CR,
             NEW_RECORD.SCGB_GAR_SIS, NEW_RECORD.SCGB_SCO_CR, NEW_RECORD.SCGB_SCO_SIS,
             NEW_RECORD.SCGB_UTI_CR, NEW_RECORD.SCGB_UTI_SIS, NEW_RECORD.SCGB_QIS_ACC,
             NEW_RECORD.SCGB_QIS_UTI, NEW_RECORD.SCGB_DTA_RIF_CR, NEW_RECORD.SCGB_DTA_STATO_SIS,
             NEW_RECORD.SCGB_COD_STATO_SIS, NEW_RECORD.SCGB_ID_DPER, NEW_RECORD.GESB_ACC_CR,
             NEW_RECORD.GESB_UTI_CR, NEW_RECORD.GESB_GAR_CR, NEW_RECORD.GESB_SCO_CR,
             NEW_RECORD.GESB_QIS_ACC, NEW_RECORD.GESB_QIS_UTI, NEW_RECORD.GEGB_ACC_CR,
             NEW_RECORD.GEGB_ACC_SIS, NEW_RECORD.GEGB_UTI_CR, NEW_RECORD.GEGB_UTI_SIS,
             NEW_RECORD.GEGB_GAR_CR, NEW_RECORD.GEGB_GAR_SIS, NEW_RECORD.GEGB_SCO_CR,
             NEW_RECORD.GEGB_SCO_SIS, NEW_RECORD.GEGB_QIS_ACC, NEW_RECORD.GEGB_QIS_UTI,
             NEW_RECORD.GLGB_ACC_CR, NEW_RECORD.GLGB_UTI_CR, NEW_RECORD.GLGB_SCO_CR,
             NEW_RECORD.GLGB_GAR_CR, NEW_RECORD.GLGB_ACC_SIS, NEW_RECORD.GLGB_UTI_SIS,
             NEW_RECORD.GLGB_SCO_SIS, NEW_RECORD.GLGB_IMP_GAR_SIS,
             NEW_RECORD.GLGB_QIS_ACC, NEW_RECORD.GLGB_QIS_UTI, NEW_RECORD.GEGB_DTA_RIF_CR,
             NEW_RECORD.GESB_DTA_CR, NEW_RECORD.GLGB_DTA_RIF_CR, NEW_RECORD.SCSB_DTA_CR,
             --V3.5
             NEW_RECORD.COD_SAG,
             --v3.7 nuovi pcr
             NEW_RECORD.SCSB_UTI_SOSTITUZIONI,
             NEW_RECORD.SCSB_UTI_MASSIMALI, NEW_RECORD.SCSB_UTI_RISCHI_INDIRETTI,
             NEW_RECORD.SCSB_ACC_SOSTITUZIONI, NEW_RECORD.SCSB_ACC_MASSIMALI,
             NEW_RECORD.SCSB_ACC_RISCHI_INDIRETTI, NEW_RECORD.GESB_UTI_MASSIMALI,
             NEW_RECORD.GESB_UTI_RISCHI_INDIRETTI, NEW_RECORD.GESB_ACC_SOSTITUZIONI,
             NEW_RECORD.GESB_ACC_MASSIMALI, NEW_RECORD.GESB_ACC_RISCHI_INDIRETTI,
             NEW_RECORD.SCGB_UTI_MASSIMALI, NEW_RECORD.SCGB_UTI_RISCHI_INDIRETTI,
             NEW_RECORD.SCGB_ACC_SOSTITUZIONI, NEW_RECORD.SCGB_ACC_MASSIMALI,
             NEW_RECORD.SCGB_ACC_RISCHI_INDIRETTI, NEW_RECORD.GLGB_UTI_MASSIMALI,
             NEW_RECORD.GLGB_UTI_RISCHI_INDIRETTI, NEW_RECORD.GLGB_ACC_SOSTITUZIONI,
             NEW_RECORD.GLGB_ACC_MASSIMALI, NEW_RECORD.GLGB_ACC_RISCHI_INDIRETTI,
             NEW_RECORD.GESB_UTI_SOSTITUZIONI, NEW_RECORD.SCGB_UTI_SOSTITUZIONI,
             NEW_RECORD.GEGB_UTI_SOSTITUZIONI, NEW_RECORD.GLGB_UTI_SOSTITUZIONI,
             NEW_RECORD.GEGB_UTI_MASSIMALI, NEW_RECORD.GEGB_UTI_RISCHI_INDIRETTI,
             NEW_RECORD.GEGB_ACC_SOSTITUZIONI, NEW_RECORD.GEGB_ACC_MASSIMALI,
             NEW_RECORD.GEGB_ACC_RISCHI_INDIRETTI, NEW_RECORD.SCSB_UTI_CONSEGNE,
             NEW_RECORD.SCSB_ACC_CONSEGNE, NEW_RECORD.SCGB_UTI_CONSEGNE,
             NEW_RECORD.SCGB_ACC_CONSEGNE, NEW_RECORD.GESB_UTI_CONSEGNE,
             NEW_RECORD.GESB_ACC_CONSEGNE,
             NEW_RECORD.GEGB_UTI_CONSEGNE, NEW_RECORD.GEGB_ACC_CONSEGNE,
             NEW_RECORD.GLGB_UTI_CONSEGNE, NEW_RECORD.GLGB_ACC_CONSEGNE

            );
            --commit;

            --rimuovo la la posizione dalla tmp_lista storico
            begin
            delete MCRE_OWN. T_MCRE0_TMP_LISTA_STORICO t
            where COD_ABI_CARTOLARIZZATO = p_abi_cart
            and COD_NDG = p_ndg;
            exception when others then
                null;
            end;

            return ok;
    exception when others then
        log_caricamenti(c_package||'.insert_storico_ndg', SQLCODE, SQLERRM ||' abi cart:'||p_abi_cart||' ndg:'||p_ndg);
        return ko;
    end;
  END;

  function insert_storico_caricamenti_ndg(p_abi_cart IN varchar2, p_ndg IN varchar2,
            p_fl_comparto varchar2, p_fl_gestore varchar2, p_fl_stato varchar2, p_fl_mese varchar2, p_cod_mese_hst number, seq number) return number IS

  new_record  MCRE_OWN.MV_MCRE0_ANAGRAFICA_GENERALE%rowtype;

  dt_inizio_val date := null;
  dt_fine_gestore date  := null;

  fl_cambio_gestore  varchar2(1) := 0;
  fl_cambio_comparto varchar2(1) := 0;
  fl_cambio_stato    varchar2(1) := 0;
  fl_cambio_mese     varchar2(1) := 0;

  err_code number := -1;
  err_msg  varchar2(1000):= '';

  BEGIN

   begin
    --registro la situazione attuale dalla MV
    select *
    into new_record
    from MCRE_OWN.MV_MCRE0_ANAGRAFICA_GENERALE mv
    where mv.COD_ABI_CARTOLARIZZATO = p_abi_cart
    and  mv.COD_NDG = p_ndg;

   exception when others then
        PKG_MCRE0_AUDIT.LOG_APP (seq, c_package||'.insert_storico_caricamenti_ndg:new_record', 2, SQLCODE, SQLERRM, ' abi cart:'||p_abi_cart||' ndg:'||p_ndg, '' );
        return ok;
   end;

    --recupero la data fine validità dell'ultimo record storico inserito (se esistente)
    begin

    select nvl(max(DTA_FINE_VALIDITA), trunc(sysdate))
    into dt_inizio_val
    from MCRE_OWN.T_MCRE0_APP_STORICO_EVENTI r
    where r.COD_ABI_CARTOLARIZZATO = p_abi_cart
      and r.COD_NDG = p_ndg;

    exception when no_data_found then
        dt_inizio_val := sysdate;
    end;

    --inserisco la nuova riga di storico
    begin

      INSERT INTO MCRE_OWN.T_MCRE0_APP_STORICO_EVENTI

                    (COD_ABI_CARTOLARIZZATO, COD_ABI_ISTITUTO, COD_COMPARTO_ASSEGNATO,
                    COD_COMPARTO_CALCOLATO, COD_COMPARTO_CALCOLATO_PRE,
                    COD_COMPARTO_HOST, COD_FILIALE, COD_GRUPPO_ECONOMICO,
                    COD_GRUPPO_LEGAME, COD_GRUPPO_SUPER, COD_NDG,
                    COD_OPERATORE_INS_UPD, COD_PERCORSO, COD_PROCESSO,
                    COD_RAMO_HOST, COD_RAP, COD_SNDG, COD_STATO,
                    COD_STATO_PRECEDENTE, COD_STRUTTURA_COMPETENTE, COD_TIPO_INGRESSO,
                    DESC_NOME_CONTROPARTE, DTA_CONFERMA_SAG, DTA_DECORRENZA_STATO,
                    DTA_EAD, DTA_FINE_UTENTE, DTA_FINE_VALIDITA, DTA_FINE_VAL_TR,
                    DTA_INI_UTENTE, DTA_INI_VALIDITA, DTA_INTERCETTAMENTO,
                    DTA_IRIS, DTA_LGD, DTA_PA, DTA_PD,
                    DTA_PD_ONLINE, DTA_PROCESSO, DTA_SCADENZA_STATO,
                    FLG_ALLINEATO_SAG,
                    FLG_CAMBIO_STATO,
                    FLG_CAMBIO_GESTORE,
                    FLG_CAMBIO_COMPARTO,
                    FLG_CAMBIO_MESE,
                    FLG_CONDIVISO,
                    FLG_CONFERMA_SAG, FLG_GRUPPO_ECONOMICO, FLG_GRUPPO_LEGAME,
                    FLG_RIPORTAFOGLIATO, FLG_SINGOLO, FLG_SOMMA,
                    GB_DTA_RIFERIMENTO, GB_VAL_MAU, GEGB_ACC_CASSA,
                    GEGB_ACC_CASSA_BT, GEGB_ACC_CASSA_MLT, GEGB_ACC_FIRMA,
                    GEGB_ACC_FIRMA_DT, GEGB_ACC_SMOBILIZZO, GEGB_TOT_GAR,
                    GEGB_UTI_CASSA, GEGB_UTI_CASSA_BT, GEGB_UTI_CASSA_MLT,
                    GEGB_UTI_FIRMA, GEGB_UTI_FIRMA_DT, GEGB_UTI_SMOBILIZZO,
                    GESB_ACC_CASSA, GESB_ACC_CASSA_BT, GESB_ACC_CASSA_MLT,
                    GESB_ACC_FIRMA, GESB_ACC_FIRMA_DT, GESB_ACC_SMOBILIZZO,
                    GESB_DTA_RIFERIMENTO, GESB_TOT_GAR, GESB_UTI_CASSA,
                    GESB_UTI_CASSA_BT, GESB_UTI_CASSA_MLT, GESB_UTI_FIRMA,
                    GESB_UTI_FIRMA_DT, GESB_UTI_SMOBILIZZO, GLGB_ACC_CASSA,
                    GLGB_ACC_CASSA_BT, GLGB_ACC_CASSA_MLT, GLGB_ACC_FIRMA,
                    GLGB_ACC_FIRMA_DT, GLGB_ACC_SMOBILIZZO, GLGB_TOT_GAR,
                    GLGB_UTI_CASSA, GLGB_UTI_CASSA_BT, GLGB_UTI_CASSA_MLT,
                    GLGB_UTI_FIRMA, GLGB_UTI_FIRMA_DT, GLGB_UTI_SMOBILIZZO,
                    ID_REFERENTE, ID_TRANSIZIONE, ID_UTENTE, ID_UTENTE_PRE,
                    LIV_RISCHIO_CLI, LIV_RISCHIO_GE, SCGB_ACC_CASSA,
                    SCGB_ACC_CASSA_BT, SCGB_ACC_CASSA_MLT, SCGB_ACC_FIRMA,
                    SCGB_ACC_FIRMA_DT, SCGB_ACC_SMOBILIZZO, SCGB_TOT_GAR,
                    SCGB_UTI_CASSA, SCGB_UTI_CASSA_BT, SCGB_UTI_CASSA_MLT,
                    SCGB_UTI_FIRMA, SCGB_UTI_FIRMA_DT, SCGB_UTI_SMOBILIZZO,
                    SCSB_ACC_CASSA, SCSB_ACC_CASSA_BT, SCSB_ACC_CASSA_MLT,
                    SCSB_ACC_FIRMA, SCSB_ACC_FIRMA_DT, SCSB_ACC_SMOBILIZZO,
                    SCSB_ACC_TOT, SCSB_DTA_RIFERIMENTO, SCSB_TOT_GAR,
                    SCSB_UTI_CASSA, SCSB_UTI_CASSA_BT, SCSB_UTI_CASSA_MLT,
                    SCSB_UTI_FIRMA, SCSB_UTI_FIRMA_DT, SCSB_UTI_SMOBILIZZO,
                    SCSB_UTI_TOT, VAL_EAD, VAL_IRIS_CLI, VAL_IRIS_GE,
                    VAL_LGD, VAL_PA, VAL_PD, VAL_PD_ONLINE,
                    VAL_RATING_ONLINE, VAL_SCONFINO, VAL_SCONFINO_RAP,
                    COD_MESE_HST, val_rating,
                    --V3.0
                    ID_DPER_FG, COD_PEF, COD_FASE_PEF,
                    DTA_ULTIMA_REVISIONE_PEF, DTA_SCADENZA_FIDO, DTA_ULTIMA_DELIBERA,
                    FLG_FIDI_SCADUTI, DAT_ULTIMO_SCADUTO, COD_ULTIMO_ODE, COD_CTS_ULTIMO_ODE,
                    COD_STRATEGIA_CRZ, COD_ODE, DTA_COMPLETAMENTO_PEF,
                    --v3.4
                    COD_SERVIZIO, DTA_SERVIZIO,
                    SCSB_ACC_CR, SCSB_UTI_CR, SCSB_GAR_CR,
                    SCSB_SCO_CR, SCSB_QIS_ACC, SCSB_QIS_UTI,
                    SCGB_ACC_CR, SCGB_ACC_SIS, SCGB_GAR_CR,
                    SCGB_GAR_SIS, SCGB_SCO_CR, SCGB_SCO_SIS, SCGB_UTI_CR,
                    SCGB_UTI_SIS, SCGB_QIS_ACC, SCGB_QIS_UTI,
                    SCGB_DTA_RIF_CR, SCGB_DTA_STATO_SIS, SCGB_COD_STATO_SIS,
                    SCGB_ID_DPER, GESB_ACC_CR, GESB_UTI_CR, GESB_GAR_CR,
                    GESB_SCO_CR, GESB_QIS_ACC, GESB_QIS_UTI,
                    GEGB_ACC_CR, GEGB_ACC_SIS, GEGB_UTI_CR, GEGB_UTI_SIS,
                    GEGB_GAR_CR, GEGB_GAR_SIS, GEGB_SCO_CR, GEGB_SCO_SIS,
                    GEGB_QIS_ACC, GEGB_QIS_UTI, GLGB_ACC_CR,
                    GLGB_UTI_CR, GLGB_SCO_CR, GLGB_GAR_CR, GLGB_ACC_SIS,
                    GLGB_UTI_SIS, GLGB_SCO_SIS, GLGB_IMP_GAR_SIS,
                    GLGB_QIS_ACC, GLGB_QIS_UTI, GEGB_DTA_RIF_CR,
                    GESB_DTA_CR, GLGB_DTA_RIF_CR, SCSB_DTA_CR,
                    --V3.5
                    COD_SAG,
                    --v3.7 nuovi pcr
                    SCSB_UTI_SOSTITUZIONI, SCSB_UTI_MASSIMALI, SCSB_UTI_RISCHI_INDIRETTI,
                    SCSB_ACC_SOSTITUZIONI, SCSB_ACC_MASSIMALI, SCSB_ACC_RISCHI_INDIRETTI, GESB_UTI_MASSIMALI,
                    GESB_UTI_RISCHI_INDIRETTI, GESB_ACC_SOSTITUZIONI, GESB_ACC_MASSIMALI, GESB_ACC_RISCHI_INDIRETTI,
                    SCGB_UTI_MASSIMALI, SCGB_UTI_RISCHI_INDIRETTI, SCGB_ACC_SOSTITUZIONI, SCGB_ACC_MASSIMALI,
                    SCGB_ACC_RISCHI_INDIRETTI, GLGB_UTI_MASSIMALI, GLGB_UTI_RISCHI_INDIRETTI, GLGB_ACC_SOSTITUZIONI,
                    GLGB_ACC_MASSIMALI, GLGB_ACC_RISCHI_INDIRETTI, GESB_UTI_SOSTITUZIONI, SCGB_UTI_SOSTITUZIONI,
                    GEGB_UTI_SOSTITUZIONI, GLGB_UTI_SOSTITUZIONI, GEGB_UTI_MASSIMALI, GEGB_UTI_RISCHI_INDIRETTI,
                    GEGB_ACC_SOSTITUZIONI, GEGB_ACC_MASSIMALI, GEGB_ACC_RISCHI_INDIRETTI, SCSB_UTI_CONSEGNE,
                    SCSB_ACC_CONSEGNE, SCGB_UTI_CONSEGNE, SCGB_ACC_CONSEGNE, GESB_UTI_CONSEGNE, GESB_ACC_CONSEGNE,
                    GEGB_UTI_CONSEGNE, GEGB_ACC_CONSEGNE, GLGB_UTI_CONSEGNE, GLGB_ACC_CONSEGNE
                    )
                    values (
                    NEW_RECORD.COD_ABI_CARTOLARIZZATO, NEW_RECORD.COD_ABI_ISTITUTO, NEW_RECORD.COD_COMPARTO_ASSEGNATO_OLD,
                    NEW_RECORD.COD_COMPARTO_CALCOLATO, NEW_RECORD.COD_COMPARTO_CALCOLATO_PRE, NEW_RECORD.COD_COMPARTO_HOST,
                    NEW_RECORD.COD_FILIALE, NEW_RECORD.COD_GRUPPO_ECONOMICO, NEW_RECORD.COD_GRUPPO_LEGAME,
                    NEW_RECORD.COD_GRUPPO_SUPER, NEW_RECORD.COD_NDG, NULL, NEW_RECORD.COD_PERCORSO,
                    NEW_RECORD.COD_PROCESSO_OLD, NEW_RECORD.COD_RAMO_HOST, NEW_RECORD.COD_RAP, NEW_RECORD.COD_SNDG,
                    NEW_RECORD.COD_STATO_OLD, NEW_RECORD.COD_STATO_PRECEDENTE_OLD, NEW_RECORD.COD_STRUTTURA_COMPETENTE,
                    NEW_RECORD.COD_TIPO_INGRESSO, NEW_RECORD.DESC_NOME_CONTROPARTE, NEW_RECORD.DTA_CONFERMA_SAG,
                    NEW_RECORD.DTA_DECORRENZA_STATO_OLD, NEW_RECORD.DTA_EAD, NULL,
                    sysdate, trunc(sysdate),
                    NEW_RECORD.DTA_UTENTE_ASSEGNATO_OLD, dt_inizio_val, NEW_RECORD.DTA_INTERCETTAMENTO,
                    NEW_RECORD.DTA_IRIS, NEW_RECORD.DTA_LGD, NEW_RECORD.DTA_PA, NEW_RECORD.DTA_PD,
                    NEW_RECORD.DTA_PD_ONLINE, NEW_RECORD.DTA_PROCESSO, NEW_RECORD.DTA_SCADENZA_STATO_OLD,
                    NEW_RECORD.FLG_ALLINEATO_SAG,
                    P_FL_STATO,
                    P_FL_GESTORE,
                    P_FL_COMPARTO,
                    P_FL_MESE,
                    NEW_RECORD.FLG_CONDIVISO, NEW_RECORD.FLG_CONFERMA_SAG, NEW_RECORD.FLG_GRUPPO_ECONOMICO, NEW_RECORD.FLG_GRUPPO_LEGAME,
                    NEW_RECORD.FLG_RIPORTAFOGLIATO, NEW_RECORD.FLG_SINGOLO, NEW_RECORD.FLG_SOMMA, NEW_RECORD.GB_DTA_RIFERIMENTO,
                    NEW_RECORD.GB_VAL_MAU, NEW_RECORD.GEGB_ACC_CASSA, NEW_RECORD.GEGB_ACC_CASSA_BT, NEW_RECORD.GEGB_ACC_CASSA_MLT,
                    NEW_RECORD.GEGB_ACC_FIRMA, NEW_RECORD.GEGB_ACC_FIRMA_DT, NEW_RECORD.GEGB_ACC_SMOBILIZZO, NEW_RECORD.GEGB_TOT_GAR,
                    NEW_RECORD.GEGB_UTI_CASSA, NEW_RECORD.GEGB_UTI_CASSA_BT, NEW_RECORD.GEGB_UTI_CASSA_MLT, NEW_RECORD.GEGB_UTI_FIRMA,
                    NEW_RECORD.GEGB_UTI_FIRMA_DT, NEW_RECORD.GEGB_UTI_SMOBILIZZO, NEW_RECORD.GESB_ACC_CASSA, NEW_RECORD.GESB_ACC_CASSA_BT,
                    NEW_RECORD.GESB_ACC_CASSA_MLT, NEW_RECORD.GESB_ACC_FIRMA, NEW_RECORD.GESB_ACC_FIRMA_DT, NEW_RECORD.GESB_ACC_SMOBILIZZO,
                    NEW_RECORD.GESB_DTA_RIFERIMENTO, NEW_RECORD.GESB_TOT_GAR, NEW_RECORD.GESB_UTI_CASSA, NEW_RECORD.GESB_UTI_CASSA_BT,
                    NEW_RECORD.GESB_UTI_CASSA_MLT, NEW_RECORD.GESB_UTI_FIRMA, NEW_RECORD.GESB_UTI_FIRMA_DT, NEW_RECORD.GESB_UTI_SMOBILIZZO,
                    NEW_RECORD.GLGB_ACC_CASSA, NEW_RECORD.GLGB_ACC_CASSA_BT, NEW_RECORD.GLGB_ACC_CASSA_MLT, NEW_RECORD.GLGB_ACC_FIRMA,
                    NEW_RECORD.GLGB_ACC_FIRMA_DT, NEW_RECORD.GLGB_ACC_SMOBILIZZO, NEW_RECORD.GLGB_TOT_GAR, NEW_RECORD.GLGB_UTI_CASSA,
                    NEW_RECORD.GLGB_UTI_CASSA_BT, NEW_RECORD.GLGB_UTI_CASSA_MLT, NEW_RECORD.GLGB_UTI_FIRMA, NEW_RECORD.GLGB_UTI_FIRMA_DT,
                    NEW_RECORD.GLGB_UTI_SMOBILIZZO, NEW_RECORD.ID_REFERENTE_OLD, NEW_RECORD.ID_TRANSIZIONE, NEW_RECORD.ID_UTENTE_OLD,
                    NEW_RECORD.ID_UTENTE_PRE_OLD, NEW_RECORD.LIV_RISCHIO_CLI, NEW_RECORD.LIV_RISCHIO_GE, NEW_RECORD.SCGB_ACC_CASSA,
                    NEW_RECORD.SCGB_ACC_CASSA_BT, NEW_RECORD.SCGB_ACC_CASSA_MLT, NEW_RECORD.SCGB_ACC_FIRMA, NEW_RECORD.SCGB_ACC_FIRMA_DT,
                    NEW_RECORD.SCGB_ACC_SMOBILIZZO, NEW_RECORD.SCGB_TOT_GAR, NEW_RECORD.SCGB_UTI_CASSA, NEW_RECORD.SCGB_UTI_CASSA_BT,
                    NEW_RECORD.SCGB_UTI_CASSA_MLT, NEW_RECORD.SCGB_UTI_FIRMA, NEW_RECORD.SCGB_UTI_FIRMA_DT, NEW_RECORD.SCGB_UTI_SMOBILIZZO,
                    NEW_RECORD.SCSB_ACC_CASSA, NEW_RECORD.SCSB_ACC_CASSA_BT, NEW_RECORD.SCSB_ACC_CASSA_MLT, NEW_RECORD.SCSB_ACC_FIRMA,
                    NEW_RECORD.SCSB_ACC_FIRMA_DT, NEW_RECORD.SCSB_ACC_SMOBILIZZO, NEW_RECORD.SCSB_ACC_TOT, NEW_RECORD.SCSB_DTA_RIFERIMENTO,
                    NEW_RECORD.SCSB_TOT_GAR, NEW_RECORD.SCSB_UTI_CASSA, NEW_RECORD.SCSB_UTI_CASSA_BT, NEW_RECORD.SCSB_UTI_CASSA_MLT,
                    NEW_RECORD.SCSB_UTI_FIRMA, NEW_RECORD.SCSB_UTI_FIRMA_DT, NEW_RECORD.SCSB_UTI_SMOBILIZZO, NEW_RECORD.SCSB_UTI_TOT,
                    NEW_RECORD.VAL_EAD, NEW_RECORD.VAL_IRIS_CLI, NEW_RECORD.VAL_IRIS_GE, NEW_RECORD.VAL_LGD, NEW_RECORD.VAL_PA,
                    NEW_RECORD.VAL_PD, NEW_RECORD.VAL_PD_ONLINE, NEW_RECORD.VAL_RATING_ONLINE, NEW_RECORD.VAL_SCONFINO,
                    NEW_RECORD.VAL_SCONFINO_RAP, p_cod_mese_hst, NEW_RECORD.VAL_RATING,
                    --V3.0
                    NEW_RECORD.ID_DPER_FG, NEW_RECORD.COD_PEF, NEW_RECORD.COD_FASE_PEF,
                    NEW_RECORD.DTA_ULTIMA_REVISIONE_PEF, NEW_RECORD.DTA_SCADENZA_FIDO,
                    NEW_RECORD.DTA_ULTIMA_DELIBERA, NEW_RECORD.FLG_FIDI_SCADUTI,
                    NEW_RECORD.DAT_ULTIMO_SCADUTO, NEW_RECORD.COD_ULTIMO_ODE, NEW_RECORD.COD_CTS_ULTIMO_ODE,
                    NEW_RECORD.COD_STRATEGIA_CRZ, NEW_RECORD.COD_ODE, NEW_RECORD.DTA_COMPLETAMENTO_PEF,
                     --v3.4
                     NEW_RECORD.COD_SERVIZIO_OLD, NEW_RECORD.DTA_SERVIZIO_OLD,
                     NEW_RECORD.SCSB_ACC_CR, NEW_RECORD.SCSB_UTI_CR, NEW_RECORD.SCSB_GAR_CR,
                     NEW_RECORD.SCSB_SCO_CR, NEW_RECORD.SCSB_QIS_ACC, NEW_RECORD.SCSB_QIS_UTI,
                     NEW_RECORD.SCGB_ACC_CR, NEW_RECORD.SCGB_ACC_SIS, NEW_RECORD.SCGB_GAR_CR,
                     NEW_RECORD.SCGB_GAR_SIS, NEW_RECORD.SCGB_SCO_CR, NEW_RECORD.SCGB_SCO_SIS,
                     NEW_RECORD.SCGB_UTI_CR, NEW_RECORD.SCGB_UTI_SIS, NEW_RECORD.SCGB_QIS_ACC,
                     NEW_RECORD.SCGB_QIS_UTI, NEW_RECORD.SCGB_DTA_RIF_CR, NEW_RECORD.SCGB_DTA_STATO_SIS,
                     NEW_RECORD.SCGB_COD_STATO_SIS, NEW_RECORD.SCGB_ID_DPER, NEW_RECORD.GESB_ACC_CR,
                     NEW_RECORD.GESB_UTI_CR, NEW_RECORD.GESB_GAR_CR, NEW_RECORD.GESB_SCO_CR,
                     NEW_RECORD.GESB_QIS_ACC, NEW_RECORD.GESB_QIS_UTI, NEW_RECORD.GEGB_ACC_CR,
                     NEW_RECORD.GEGB_ACC_SIS, NEW_RECORD.GEGB_UTI_CR, NEW_RECORD.GEGB_UTI_SIS,
                     NEW_RECORD.GEGB_GAR_CR, NEW_RECORD.GEGB_GAR_SIS, NEW_RECORD.GEGB_SCO_CR,
                     NEW_RECORD.GEGB_SCO_SIS, NEW_RECORD.GEGB_QIS_ACC, NEW_RECORD.GEGB_QIS_UTI,
                     NEW_RECORD.GLGB_ACC_CR, NEW_RECORD.GLGB_UTI_CR, NEW_RECORD.GLGB_SCO_CR,
                     NEW_RECORD.GLGB_GAR_CR, NEW_RECORD.GLGB_ACC_SIS, NEW_RECORD.GLGB_UTI_SIS,
                     NEW_RECORD.GLGB_SCO_SIS, NEW_RECORD.GLGB_IMP_GAR_SIS,
                     NEW_RECORD.GLGB_QIS_ACC, NEW_RECORD.GLGB_QIS_UTI, NEW_RECORD.GEGB_DTA_RIF_CR,
                     NEW_RECORD.GESB_DTA_CR, NEW_RECORD.GLGB_DTA_RIF_CR, NEW_RECORD.SCSB_DTA_CR,
                     --V3.5
                     NEW_RECORD.COD_SAG,
                     --v3.7 nuovi pcr
                     NEW_RECORD.SCSB_UTI_SOSTITUZIONI,
                     NEW_RECORD.SCSB_UTI_MASSIMALI, NEW_RECORD.SCSB_UTI_RISCHI_INDIRETTI,
                     NEW_RECORD.SCSB_ACC_SOSTITUZIONI, NEW_RECORD.SCSB_ACC_MASSIMALI,
                     NEW_RECORD.SCSB_ACC_RISCHI_INDIRETTI, NEW_RECORD.GESB_UTI_MASSIMALI,
                     NEW_RECORD.GESB_UTI_RISCHI_INDIRETTI, NEW_RECORD.GESB_ACC_SOSTITUZIONI,
                     NEW_RECORD.GESB_ACC_MASSIMALI, NEW_RECORD.GESB_ACC_RISCHI_INDIRETTI,
                     NEW_RECORD.SCGB_UTI_MASSIMALI, NEW_RECORD.SCGB_UTI_RISCHI_INDIRETTI,
                     NEW_RECORD.SCGB_ACC_SOSTITUZIONI, NEW_RECORD.SCGB_ACC_MASSIMALI,
                     NEW_RECORD.SCGB_ACC_RISCHI_INDIRETTI, NEW_RECORD.GLGB_UTI_MASSIMALI,
                     NEW_RECORD.GLGB_UTI_RISCHI_INDIRETTI, NEW_RECORD.GLGB_ACC_SOSTITUZIONI,
                     NEW_RECORD.GLGB_ACC_MASSIMALI, NEW_RECORD.GLGB_ACC_RISCHI_INDIRETTI,
                     NEW_RECORD.GESB_UTI_SOSTITUZIONI, NEW_RECORD.SCGB_UTI_SOSTITUZIONI,
                     NEW_RECORD.GEGB_UTI_SOSTITUZIONI, NEW_RECORD.GLGB_UTI_SOSTITUZIONI,
                     NEW_RECORD.GEGB_UTI_MASSIMALI, NEW_RECORD.GEGB_UTI_RISCHI_INDIRETTI,
                     NEW_RECORD.GEGB_ACC_SOSTITUZIONI, NEW_RECORD.GEGB_ACC_MASSIMALI,
                     NEW_RECORD.GEGB_ACC_RISCHI_INDIRETTI, NEW_RECORD.SCSB_UTI_CONSEGNE,
                     NEW_RECORD.SCSB_ACC_CONSEGNE, NEW_RECORD.SCGB_UTI_CONSEGNE,
                     NEW_RECORD.SCGB_ACC_CONSEGNE, NEW_RECORD.GESB_UTI_CONSEGNE,
                     NEW_RECORD.GESB_ACC_CONSEGNE,
                     NEW_RECORD.GEGB_UTI_CONSEGNE, NEW_RECORD.GEGB_ACC_CONSEGNE,
                     NEW_RECORD.GLGB_UTI_CONSEGNE, NEW_RECORD.GLGB_ACC_CONSEGNE

                    );
                    COMMIT;
            return ok;
    exception when others then
        PKG_MCRE0_AUDIT.LOG_APP (seq, c_package||'.insert_storico_caricamenti_ndg', 1, SQLCODE, SQLERRM, ' abi cart:'||p_abi_cart||' ndg:'||p_ndg, '' );
        return ko;
    end;

  END;

  -- salva lo stato generale per tutti i settoriali di un SNDG - no commit
  FUNCTION insert_storico_sndg(p_abi_cart IN varchar2, p_ndg IN varchar2, p_sndg IN varchar2,p_fl_comparto varchar2, p_fl_gestore varchar2, p_fl_stato varchar2, p_fl_mese varchar2) return number is

  err_code number := -1;
  err_msg  varchar2(1000):= '';

  v_abi_cart MCRE_OWN.T_MCRE0_APP_ALL_DATA.COD_ABI_CARTOLARIZZATO%type;
  v_cod_ndg  MCRE_OWN.T_MCRE0_APP_ALL_DATA.COD_NDG%type;
  v_fl_stato varchar2(1);

  esito number := 0;

  cursor collegati is
    select COD_ABI_CARTOLARIZZATO, COD_NDG
    from MCRE_OWN.T_MCRE0_APP_ALL_DATA
    where COD_SNDG = p_sndg;

  begin

  open collegati;
  loop
    fetch collegati into v_abi_cart, v_cod_ndg;
    exit when collegati%notfound;
    --V3.1 cambio stato a 1 su abi/ndg, 2 sui collegati!

    if (p_fl_stato = '1' and (v_abi_cart != p_abi_cart or  v_cod_ndg != p_ndg))
    then v_fl_stato := '2';
    else v_fl_stato := p_fl_stato;
    end if ;

    esito := PKG_MCRE0_STORICIZZA.INSERT_STORICO_NDG(v_abi_cart, v_cod_ndg, p_fl_comparto, p_fl_gestore, v_fl_stato, p_fl_mese);
    if esito = ko then
        --rollback;
        return ko;
    end if;

  end loop;
  close collegati;

  return ok;

  end;

  --storicizzo le variazioni del mattino
  FUNCTION storicizza_caricamenti(seq number) return number is

  esito number := 0;
  result number := 1;

  err_code number := -1;
  err_msg  varchar2(1000):= '';
  result2 boolean := false;


  cursor variati is
    select COD_ABI_CARTOLARIZZATO, COD_NDG, COD_SNDG, min (FLG_STATO) FLG_STATO, max(FLG_COMPARTO) FLG_COMPARTO,
    max(FLG_GESTORE) FLG_GESTORE, max(FLG_MESE) FLG_MESE, max(COD_MESE_HST) COD_MESE_HST
    from
     ( select an.COD_ABI_CARTOLARIZZATO, an.COD_NDG, an.COD_SNDG,
       (case
        when tmp.FLG_STATO = 0 then 0
        when an.COD_ABI_CARTOLARIZZATO = tmp.COD_ABI_CARTOLARIZZATO
        and an.COD_NDG = tmp.COD_NDG
        and tmp.FLG_STATO = 1 then 1
        else 2
        end)
        as FLG_STATO, tmp.FLG_COMPARTO, tmp.FLG_GESTORE, tmp.FLG_MESE, tmp.COD_MESE_HST
       FROM MV_MCRE0_ANAGRAFICA_GENERALE AN LEFT JOIN
       (select  COD_ABI_CARTOLARIZZATO, COD_NDG, COD_SNDG,
         max(FLG_STATO)FLG_STATO, max(FLG_COMPARTO)FLG_COMPARTO, max(FLG_GESTORE)FLG_GESTORE,
         max(FLG_MESE)FLG_MESE, max(COD_MESE_HST)COD_MESE_HST
        from  T_MCRE0_TMP_LISTA_STORICO
        group by COD_ABI_CARTOLARIZZATO, COD_NDG, COD_SNDG, FLG_MESE, COD_MESE_HST) TMP
       ON AN.COD_SNDG=TMP.COD_SNDG
       WHERE  TMP.COD_SNDG IS not NULL
       and AN.ID_DPER_FG=(select max(id_dper_fg) from MV_MCRE0_ANAGRAFICA_GENERALE
                          WHERE TODAY_FLG = '1'  )--v4.0
      )
     group by COD_ABI_CARTOLARIZZATO, COD_NDG, COD_SNDG;

       riga variati%rowtype;


  begin

    --per ogni posizione variata in notturna storicizzo l'intero sndg
    open variati;
    loop
        fetch variati into riga;
        exit when variati%notfound;

        begin
        esito := PKG_MCRE0_STORICIZZA.INSERT_STORICO_CARICAMENTI_NDG(riga.COD_ABI_CARTOLARIZZATO, riga.COD_NDG,
                riga.FLG_COMPARTO, riga.FLG_GESTORE, riga.FLG_STATO, riga.FLG_MESE, riga.cod_mese_hst, seq);
        result := result*esito;
        exception when others then
            PKG_MCRE0_AUDIT.log_etl (seq,c_package||'.storicizza_caricamenti', PKG_MCRE0_AUDIT.C_ERROR, sqlcode, sqlerrm, ' abi cart:'||riga.COD_ABI_CARTOLARIZZATO||' ndg:'||riga.COD_NDG);
            rollback;
            return ko;
        end;

    end loop;
    close variati;

    if (result = 0) then
        rollback;
    else
        commit;
    end if;

    --v. 2.2 chiamata storicizzazione mensile
--    if (storicizza_mese(seq)) then
--      PKG_MCRE0_AUDIT.log_etl (seq,c_package||'.storicizza_caricamenti', PKG_MCRE0_AUDIT.C_DEBUG, sqlcode, 'STORICIZZA_MESE - ok', '');
--    else
--      PKG_MCRE0_AUDIT.log_etl (seq,c_package||'.storicizza_caricamenti', PKG_MCRE0_AUDIT.C_WARNING, sqlcode, 'STORICIZZA_MESE - errore', '');
--    end if;

  execute immediate 'truncate table  T_MCRE0_TMP_LISTA_STORICO';
  return result;

  end;


FUNCTION storicizza_mese(seq number) return boolean is

    v_new_per date;
    v_last_period date;
    v_last_month number;



    begin

    v_last_month := 0;

     select (max(PERIODO_RIFERIMENTO))
     into v_new_per
     FROM T_MCRE0_WRK_ACQUISIZIONE
     where PERIODO_RIFERIMENTO = ( select (max(PERIODO_RIFERIMENTO))
                                    FROM T_MCRE0_WRK_ACQUISIZIONE
                                    where STATO='CARICATO');

     select (max(PERIODO_RIFERIMENTO))
     into v_last_period
     FROM T_MCRE0_WRK_ACQUISIZIONE
     where PERIODO_RIFERIMENTO < v_new_per
     and FLG_ETL_2 <> 0;

     if  extract (month from v_last_period) <>  extract (month from v_new_per) then

        v_last_month:= TO_NUMBER(TO_CHAR(v_last_period, 'yyyymmdd'));

     end if;

        IF (v_last_month <> 0) THEN

                    INSERT INTO MCRE_OWN.T_MCRE0_APP_STORICO_EVENTI

                    (COD_ABI_CARTOLARIZZATO, COD_ABI_ISTITUTO,
                    COD_COMPARTO_ASSEGNATO, COD_COMPARTO_CALCOLATO,
                    COD_COMPARTO_CALCOLATO_PRE, COD_COMPARTO_HOST,
                    COD_FILIALE, COD_GRUPPO_ECONOMICO,
                    COD_GRUPPO_LEGAME, COD_GRUPPO_SUPER,
                    COD_NDG, COD_OPERATORE_INS_UPD,
                    COD_PERCORSO, COD_PROCESSO,
                    COD_RAMO_HOST, COD_RAP,
                    COD_SNDG, COD_STATO,
                    COD_STATO_PRECEDENTE, COD_STRUTTURA_COMPETENTE,
                    COD_TIPO_INGRESSO, DESC_NOME_CONTROPARTE,
                    DTA_CONFERMA_SAG, DTA_DECORRENZA_STATO,
                    DTA_EAD, DTA_FINE_UTENTE, DTA_FINE_VAL_TR,
                    DTA_FINE_VALIDITA, DTA_INI_UTENTE,
                    DTA_INI_VALIDITA, DTA_INTERCETTAMENTO,
                    DTA_IRIS, DTA_LGD,
                    DTA_PA, DTA_PD,
                    DTA_PD_ONLINE, DTA_PROCESSO,
                    DTA_SCADENZA_STATO, FLG_ALLINEATO_SAG,
                    FLG_CAMBIO_COMPARTO, FLG_CAMBIO_GESTORE,
                    FLG_CAMBIO_MESE, FLG_CAMBIO_STATO,
                    FLG_CONDIVISO, FLG_CONFERMA_SAG,
                    FLG_GRUPPO_ECONOMICO, FLG_GRUPPO_LEGAME,
                    FLG_RIPORTAFOGLIATO, FLG_SINGOLO,
                    FLG_SOMMA, GB_DTA_RIFERIMENTO,
                    GB_VAL_MAU, GEGB_ACC_CASSA,
                    GEGB_ACC_CASSA_BT, GEGB_ACC_CASSA_MLT,
                    GEGB_ACC_FIRMA, GEGB_ACC_FIRMA_DT,
                    GEGB_ACC_SMOBILIZZO, GEGB_TOT_GAR,
                    GEGB_UTI_CASSA, GEGB_UTI_CASSA_BT,
                    GEGB_UTI_CASSA_MLT, GEGB_UTI_FIRMA,
                    GEGB_UTI_FIRMA_DT, GEGB_UTI_SMOBILIZZO,
                    GESB_ACC_CASSA, GESB_ACC_CASSA_BT,
                    GESB_ACC_CASSA_MLT, GESB_ACC_FIRMA,
                    GESB_ACC_FIRMA_DT, GESB_ACC_SMOBILIZZO,
                    GESB_DTA_RIFERIMENTO, GESB_TOT_GAR,
                    GESB_UTI_CASSA, GESB_UTI_CASSA_BT,
                    GESB_UTI_CASSA_MLT, GESB_UTI_FIRMA,
                    GESB_UTI_FIRMA_DT, GESB_UTI_SMOBILIZZO,
                    GLGB_ACC_CASSA, GLGB_ACC_CASSA_BT,
                    GLGB_ACC_CASSA_MLT, GLGB_ACC_FIRMA,
                    GLGB_ACC_FIRMA_DT, GLGB_ACC_SMOBILIZZO,
                    GLGB_TOT_GAR, GLGB_UTI_CASSA,
                    GLGB_UTI_CASSA_BT, GLGB_UTI_CASSA_MLT,
                    GLGB_UTI_FIRMA, GLGB_UTI_FIRMA_DT,
                    GLGB_UTI_SMOBILIZZO, ID_REFERENTE,
                    ID_TRANSIZIONE, ID_UTENTE,
                    ID_UTENTE_PRE, LIV_RISCHIO_CLI,
                    LIV_RISCHIO_GE, SCGB_ACC_CASSA,
                    SCGB_ACC_CASSA_BT, SCGB_ACC_CASSA_MLT,
                    SCGB_ACC_FIRMA, SCGB_ACC_FIRMA_DT,
                    SCGB_ACC_SMOBILIZZO, SCGB_TOT_GAR,
                    SCGB_UTI_CASSA, SCGB_UTI_CASSA_BT,
                    SCGB_UTI_CASSA_MLT, SCGB_UTI_FIRMA,
                    SCGB_UTI_FIRMA_DT, SCGB_UTI_SMOBILIZZO,
                    SCSB_ACC_CASSA, SCSB_ACC_CASSA_BT,
                    SCSB_ACC_CASSA_MLT, SCSB_ACC_FIRMA,
                    SCSB_ACC_FIRMA_DT, SCSB_ACC_SMOBILIZZO,
                    SCSB_ACC_TOT, SCSB_DTA_RIFERIMENTO,
                    SCSB_TOT_GAR, SCSB_UTI_CASSA,
                    SCSB_UTI_CASSA_BT, SCSB_UTI_CASSA_MLT,
                    SCSB_UTI_FIRMA, SCSB_UTI_FIRMA_DT,
                    SCSB_UTI_SMOBILIZZO, SCSB_UTI_TOT,
                    VAL_EAD, VAL_IRIS_CLI,
                    VAL_IRIS_GE, VAL_LGD,
                    VAL_PA, VAL_PD, VAL_RATING,
                    VAL_PD_ONLINE, VAL_RATING_ONLINE,
                    VAL_SCONFINO, VAL_SCONFINO_RAP, COD_MESE_HST,
                    --v3.0
                    ID_DPER_FG, COD_PEF, COD_FASE_PEF,
                    DTA_ULTIMA_REVISIONE_PEF, DTA_SCADENZA_FIDO, DTA_ULTIMA_DELIBERA,
                    FLG_FIDI_SCADUTI, DAT_ULTIMO_SCADUTO, COD_ULTIMO_ODE, COD_CTS_ULTIMO_ODE,
                    COD_STRATEGIA_CRZ, COD_ODE, DTA_COMPLETAMENTO_PEF,
                    --v3.4
                     COD_SERVIZIO, DTA_SERVIZIO,
                     SCSB_ACC_CR, SCSB_UTI_CR, SCSB_GAR_CR,
                     SCSB_SCO_CR, SCSB_QIS_ACC, SCSB_QIS_UTI,
                     SCGB_ACC_CR, SCGB_ACC_SIS, SCGB_GAR_CR,
                     SCGB_GAR_SIS, SCGB_SCO_CR, SCGB_SCO_SIS, SCGB_UTI_CR,
                     SCGB_UTI_SIS, SCGB_QIS_ACC, SCGB_QIS_UTI,
                     SCGB_DTA_RIF_CR, SCGB_DTA_STATO_SIS, SCGB_COD_STATO_SIS,
                     SCGB_ID_DPER, GESB_ACC_CR, GESB_UTI_CR, GESB_GAR_CR,
                     GESB_SCO_CR, GESB_QIS_ACC, GESB_QIS_UTI,
                     GEGB_ACC_CR, GEGB_ACC_SIS, GEGB_UTI_CR, GEGB_UTI_SIS,
                     GEGB_GAR_CR, GEGB_GAR_SIS, GEGB_SCO_CR, GEGB_SCO_SIS,
                     GEGB_QIS_ACC, GEGB_QIS_UTI, GLGB_ACC_CR,
                     GLGB_UTI_CR, GLGB_SCO_CR, GLGB_GAR_CR, GLGB_ACC_SIS,
                     GLGB_UTI_SIS, GLGB_SCO_SIS, GLGB_IMP_GAR_SIS,
                     GLGB_QIS_ACC, GLGB_QIS_UTI, GEGB_DTA_RIF_CR,
                     GESB_DTA_CR, GLGB_DTA_RIF_CR, SCSB_DTA_CR,
                    --V3.5
                    COD_SAG,
                    --v3.7 nuovi pcr
                    SCSB_UTI_SOSTITUZIONI, SCSB_UTI_MASSIMALI, SCSB_UTI_RISCHI_INDIRETTI,
                    SCSB_ACC_SOSTITUZIONI, SCSB_ACC_MASSIMALI, SCSB_ACC_RISCHI_INDIRETTI, GESB_UTI_MASSIMALI,
                    GESB_UTI_RISCHI_INDIRETTI, GESB_ACC_SOSTITUZIONI, GESB_ACC_MASSIMALI, GESB_ACC_RISCHI_INDIRETTI,
                    SCGB_UTI_MASSIMALI, SCGB_UTI_RISCHI_INDIRETTI, SCGB_ACC_SOSTITUZIONI, SCGB_ACC_MASSIMALI,
                    SCGB_ACC_RISCHI_INDIRETTI, GLGB_UTI_MASSIMALI, GLGB_UTI_RISCHI_INDIRETTI, GLGB_ACC_SOSTITUZIONI,
                    GLGB_ACC_MASSIMALI, GLGB_ACC_RISCHI_INDIRETTI, GESB_UTI_SOSTITUZIONI, SCGB_UTI_SOSTITUZIONI,
                    GEGB_UTI_SOSTITUZIONI, GLGB_UTI_SOSTITUZIONI, GEGB_UTI_MASSIMALI, GEGB_UTI_RISCHI_INDIRETTI,
                    GEGB_ACC_SOSTITUZIONI, GEGB_ACC_MASSIMALI, GEGB_ACC_RISCHI_INDIRETTI, SCSB_UTI_CONSEGNE,
                    SCSB_ACC_CONSEGNE, SCGB_UTI_CONSEGNE, SCGB_ACC_CONSEGNE, GESB_UTI_CONSEGNE, GESB_ACC_CONSEGNE,
                    GEGB_UTI_CONSEGNE, GEGB_ACC_CONSEGNE, GLGB_UTI_CONSEGNE, GLGB_ACC_CONSEGNE

                    )

                    select COD_ABI_CARTOLARIZZATO, COD_ABI_ISTITUTO,
                    COD_COMPARTO_ASSEGNATO_OLD, COD_COMPARTO_CALCOLATO,
                    COD_COMPARTO_CALCOLATO_PRE, COD_COMPARTO_HOST,
                    COD_FILIALE, COD_GRUPPO_ECONOMICO,
                    COD_GRUPPO_LEGAME, COD_GRUPPO_SUPER,
                    COD_NDG, NULL,
                    COD_PERCORSO, COD_PROCESSO_OLD,
                    COD_RAMO_HOST, COD_RAP,
                    an.COD_SNDG, COD_STATO_OLD,
                    COD_STATO_PRECEDENTE_OLD, COD_STRUTTURA_COMPETENTE,
                    COD_TIPO_INGRESSO, DESC_NOME_CONTROPARTE,
                    DTA_CONFERMA_SAG, DTA_DECORRENZA_STATO_OLD,
                    DTA_EAD, NULL, trunc(SYSDATE),--v4.0
                    SYSDATE, DTA_UTENTE_ASSEGNATO_OLD, --v3.1 fine validità a Sysdate anzichè 01.01.1900
                    SYSDATE, DTA_INTERCETTAMENTO,  --v3.1 ini validità a Sysdate anzichè null
                    DTA_IRIS, DTA_LGD,
                    DTA_PA, DTA_PD,
                    DTA_PD_ONLINE, DTA_PROCESSO,
                    DTA_SCADENZA_STATO_OLD, FLG_ALLINEATO_SAG,
                    0, 0, 1, 0,
                    FLG_CONDIVISO, FLG_CONFERMA_SAG,
                    FLG_GRUPPO_ECONOMICO, FLG_GRUPPO_LEGAME,
                    FLG_RIPORTAFOGLIATO, FLG_SINGOLO,
                    FLG_SOMMA, GB_DTA_RIFERIMENTO,
                    GB_VAL_MAU, GEGB_ACC_CASSA,
                    GEGB_ACC_CASSA_BT, GEGB_ACC_CASSA_MLT,
                    GEGB_ACC_FIRMA, GEGB_ACC_FIRMA_DT,
                    GEGB_ACC_SMOBILIZZO, GEGB_TOT_GAR,
                    GEGB_UTI_CASSA, GEGB_UTI_CASSA_BT,
                    GEGB_UTI_CASSA_MLT, GEGB_UTI_FIRMA,
                    GEGB_UTI_FIRMA_DT, GEGB_UTI_SMOBILIZZO,
                    GESB_ACC_CASSA, GESB_ACC_CASSA_BT,
                    GESB_ACC_CASSA_MLT, GESB_ACC_FIRMA,
                    GESB_ACC_FIRMA_DT, GESB_ACC_SMOBILIZZO,
                    GESB_DTA_RIFERIMENTO, GESB_TOT_GAR,
                    GESB_UTI_CASSA, GESB_UTI_CASSA_BT,
                    GESB_UTI_CASSA_MLT, GESB_UTI_FIRMA,
                    GESB_UTI_FIRMA_DT, GESB_UTI_SMOBILIZZO,
                    GLGB_ACC_CASSA, GLGB_ACC_CASSA_BT,
                    GLGB_ACC_CASSA_MLT, GLGB_ACC_FIRMA,
                    GLGB_ACC_FIRMA_DT, GLGB_ACC_SMOBILIZZO,
                    GLGB_TOT_GAR, GLGB_UTI_CASSA,
                    GLGB_UTI_CASSA_BT, GLGB_UTI_CASSA_MLT,
                    GLGB_UTI_FIRMA, GLGB_UTI_FIRMA_DT,
                    GLGB_UTI_SMOBILIZZO, ID_REFERENTE_OLD,
                    ID_TRANSIZIONE, ID_UTENTE_OLD,
                    ID_UTENTE_PRE_OLD,
                    LIV_RISCHIO_CLI, LIV_RISCHIO_GE,
                    SCGB_ACC_CASSA, SCGB_ACC_CASSA_BT,
                    SCGB_ACC_CASSA_MLT, SCGB_ACC_FIRMA,
                    SCGB_ACC_FIRMA_DT, SCGB_ACC_SMOBILIZZO,
                    SCGB_TOT_GAR, SCGB_UTI_CASSA,
                    SCGB_UTI_CASSA_BT, SCGB_UTI_CASSA_MLT,
                    SCGB_UTI_FIRMA, SCGB_UTI_FIRMA_DT,
                    SCGB_UTI_SMOBILIZZO, SCSB_ACC_CASSA,
                    SCSB_ACC_CASSA_BT, SCSB_ACC_CASSA_MLT,
                    SCSB_ACC_FIRMA, SCSB_ACC_FIRMA_DT,
                    SCSB_ACC_SMOBILIZZO, SCSB_ACC_TOT,
                    SCSB_DTA_RIFERIMENTO, SCSB_TOT_GAR,
                    SCSB_UTI_CASSA, SCSB_UTI_CASSA_BT,
                    SCSB_UTI_CASSA_MLT, SCSB_UTI_FIRMA,
                    SCSB_UTI_FIRMA_DT, SCSB_UTI_SMOBILIZZO,
                    SCSB_UTI_TOT, VAL_EAD,
                    VAL_IRIS_CLI, VAL_IRIS_GE,
                    VAL_LGD, VAL_PA,
                    VAL_PD, VAL_RATING, VAL_PD_ONLINE,
                    VAL_RATING_ONLINE, VAL_SCONFINO,
                    VAL_SCONFINO_RAP, v_last_month,
                    --v3.0
                    ID_DPER_FG, COD_PEF, COD_FASE_PEF,
                    DTA_ULTIMA_REVISIONE_PEF, DTA_SCADENZA_FIDO, DTA_ULTIMA_DELIBERA,
                    FLG_FIDI_SCADUTI, DAT_ULTIMO_SCADUTO, COD_ULTIMO_ODE, COD_CTS_ULTIMO_ODE,
                    COD_STRATEGIA_CRZ, COD_ODE, DTA_COMPLETAMENTO_PEF,
                     --v3.4
                     COD_SERVIZIO_OLD, DTA_SERVIZIO_OLD,
                     SCSB_ACC_CR, SCSB_UTI_CR, SCSB_GAR_CR,
                     SCSB_SCO_CR, SCSB_QIS_ACC, SCSB_QIS_UTI,
                     SCGB_ACC_CR, SCGB_ACC_SIS, SCGB_GAR_CR,
                     SCGB_GAR_SIS, SCGB_SCO_CR, SCGB_SCO_SIS, SCGB_UTI_CR,
                     SCGB_UTI_SIS, SCGB_QIS_ACC, SCGB_QIS_UTI,
                     SCGB_DTA_RIF_CR, SCGB_DTA_STATO_SIS, SCGB_COD_STATO_SIS,
                     SCGB_ID_DPER, GESB_ACC_CR, GESB_UTI_CR, GESB_GAR_CR,
                     GESB_SCO_CR, GESB_QIS_ACC, GESB_QIS_UTI,
                     GEGB_ACC_CR, GEGB_ACC_SIS, GEGB_UTI_CR, GEGB_UTI_SIS,
                     GEGB_GAR_CR, GEGB_GAR_SIS, GEGB_SCO_CR, GEGB_SCO_SIS,
                     GEGB_QIS_ACC, GEGB_QIS_UTI, GLGB_ACC_CR,
                     GLGB_UTI_CR, GLGB_SCO_CR, GLGB_GAR_CR, GLGB_ACC_SIS,
                     GLGB_UTI_SIS, GLGB_SCO_SIS, GLGB_IMP_GAR_SIS,
                     GLGB_QIS_ACC, GLGB_QIS_UTI, GEGB_DTA_RIF_CR,
                     GESB_DTA_CR, GLGB_DTA_RIF_CR, SCSB_DTA_CR,
                    --V3.5
                    COD_SAG,
                    --v3.7 nuovi pcr
                    SCSB_UTI_SOSTITUZIONI, SCSB_UTI_MASSIMALI, SCSB_UTI_RISCHI_INDIRETTI,
                    SCSB_ACC_SOSTITUZIONI, SCSB_ACC_MASSIMALI, SCSB_ACC_RISCHI_INDIRETTI, GESB_UTI_MASSIMALI,
                    GESB_UTI_RISCHI_INDIRETTI, GESB_ACC_SOSTITUZIONI, GESB_ACC_MASSIMALI, GESB_ACC_RISCHI_INDIRETTI,
                    SCGB_UTI_MASSIMALI, SCGB_UTI_RISCHI_INDIRETTI, SCGB_ACC_SOSTITUZIONI, SCGB_ACC_MASSIMALI,
                    SCGB_ACC_RISCHI_INDIRETTI, GLGB_UTI_MASSIMALI, GLGB_UTI_RISCHI_INDIRETTI, GLGB_ACC_SOSTITUZIONI,
                    GLGB_ACC_MASSIMALI, GLGB_ACC_RISCHI_INDIRETTI, GESB_UTI_SOSTITUZIONI, SCGB_UTI_SOSTITUZIONI,
                    GEGB_UTI_SOSTITUZIONI, GLGB_UTI_SOSTITUZIONI, GEGB_UTI_MASSIMALI, GEGB_UTI_RISCHI_INDIRETTI,
                    GEGB_ACC_SOSTITUZIONI, GEGB_ACC_MASSIMALI, GEGB_ACC_RISCHI_INDIRETTI, SCSB_UTI_CONSEGNE,
                    SCSB_ACC_CONSEGNE, SCGB_UTI_CONSEGNE, SCGB_ACC_CONSEGNE, GESB_UTI_CONSEGNE, GESB_ACC_CONSEGNE,
                    GEGB_UTI_CONSEGNE, GEGB_ACC_CONSEGNE, GLGB_UTI_CONSEGNE, GLGB_ACC_CONSEGNE

                    FROM MV_MCRE0_ANAGRAFICA_GENERALE AN
                    LEFT JOIN (select distinct COD_SNDG from  T_MCRE0_TMP_LISTA_STORICO) TMP
                    --where FLG_STATO = 1) TMP --v3.1 considero tutti i record della TMP!
                    ON AN.COD_SNDG=TMP.COD_SNDG
                    WHERE TMP.COD_SNDG IS NULL
                    and AN.ID_DPER_FG=(select max(id_dper_fg) from MV_MCRE0_ANAGRAFICA_GENERALE
                                       WHERE TODAY_FLG = '1' ); --v4.0

                    commit;
        END IF;
       return TRUE;

   exception when others then
    PKG_MCRE0_AUDIT.log_etl (seq,c_package||'.STORICIZZA_MESE', PKG_MCRE0_AUDIT.C_ERROR, sqlcode, sqlerrm, '');
    return FALSE;

   end storicizza_mese;

END PKG_MCRE0_STORICIZZA;
/


CREATE SYNONYM MCRE_APP.PKG_MCRE0_STORICIZZA FOR MCRE_OWN.PKG_MCRE0_STORICIZZA;


CREATE SYNONYM MCRE_USR.PKG_MCRE0_STORICIZZA FOR MCRE_OWN.PKG_MCRE0_STORICIZZA;


GRANT EXECUTE, DEBUG ON MCRE_OWN.PKG_MCRE0_STORICIZZA TO MCRE_USR;

