/* Formatted on 21/07/2014 18:42:24 (QP5 v5.227.12220.39754) */
CREATE OR REPLACE FORCE VIEW MCRE_OWN.V_MCRES_APP_MCRDSISBACP_FILE
(
   LINE,
   COD_ABI
)
AS
   SELECT    ID_DPER
          || ','
          || COD_ABI
          || ','
          || DTA_SISBA_CP
          || ','
          || COD_FILIALE_AREA
          || ','
          || COD_FILIALE
          || ','
          || COD_NDG
          || ','
          || COD_SNDG
          || ','
          || COD_STATO_GIURIDICO
          || ','
          || DTA_DECORRENZA_STATO
          || ','
          || COD_SPORTELLO
          || ','
          || COD_RAPPORTO
          || ','
          || COD_RAPPORTO_ORIG
          || ','
          || COD_FORMA_TECN
          || ','
          || COD_FORMA_TECN_CMLT
          || ','
          || VAL_UTI_RET
          || ','
          || VAL_VANT
          || ','
          || VAL_ATT
          || ','
          || COD_SEGM_IRB
          || ','
          || COD_SEGM_STAND
          || ','
          || COD_R437
          || ','
          || VAL_IMP_GAR_IPOT
          || ','
          || VAL_MORA
          || ','
          || VAL_RATEO_MORA
          || ','
          || VAL_RATEO_CORR
          || ','
          || VAL_UTI_FIRMA
          || ','
          || VAL_STRALCI_FISC_CAP
          || ','
          || VAL_STRALCI_FISC_MORA
          || ','
          || VAL_STRALCI_ALTRI_CAP
          || ','
          || VAL_STRALCI_ALTRI_MORA
          || ','
          || VAL_SOPRAVVENIENZE
          || ','
          || VAL_NUM_ATT
          || ','
          || VAL_NUM_DUBBIO_ESITO
          || ','
          || VAL_DELTA_IAS_LORDO
          || ','
          || VAL_DELTA_IAS_RET
          || ','
          || VAL_FIRMA
          || ','
          || COD_STATO_RISCHIO
          || ','
             line,
          COD_ABI
     --DTA_INS||','||
     --DTA_UPD||','||
     --COD_OPERATORE_INS_UPD||','||
     --FLG_TAPPO||','||
     --VAL_UTI_RET_OLD||','||
     --VAL_ATT_OLD||','||
     FROM t_mcres_app_sisba_cp
    WHERE id_dper = (SELECT id_dper
                       FROM V_MCRES_ULTIMA_ACQUISIZIONE
                      WHERE cod_flusso = 'MCRDSISBACP');
