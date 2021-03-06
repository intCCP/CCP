/* Formatted on 21/07/2014 18:44:28 (QP5 v5.227.12220.39754) */
CREATE OR REPLACE FORCE VIEW MCRE_OWN.V_MCRES_MIGRRAPP
(
   VAL_SOURCE,
   ID_DPER,
   COD_ABI,
   COD_NDG,
   COD_RAPPORTO_OLD,
   COD_RAPPORTO_NEW,
   COD_FILIALE_ORIG,
   COD_FILIALE_DEST,
   FLG_TIPO_MIGRRAPP,
   DTA_INS
)
AS
   SELECT E.VAL_SOURCE,
          TO_CHAR (SYSDATE, 'YYYYMMDD') ID_DPER,
          I.COD_ABI,
          LPAD (E.COD_NDG_OLD, 16, '0') COD_NDG,
          E.COD_RAPPORTO_OLD,
          E.COD_RAPPORTO_NEW,
          NULL COD_FILIALE_ORIG,
          NULL cod_filiale_dest,
          2 flg_tipo_migrrapp,
          SYSDATE DTA_INS
     FROM te_MCRES_MIGRRAPP_M0_CMLT E,
          T_MCRES_APP_ISTITUTI I,
          T_MCRES_WRK_MIGRRAPP_FILE M
    WHERE     E.COD_ISTITUTO = LPAD (I.COD_ISTITUTO, 3, '0')
          AND I.COD_ABI = M.COD_ABI
          AND INSTR (M.COD_FILE, E.VAL_SOURCE) > 0
          AND M.FLG_ATTIVO = 1
   UNION ALL
   SELECT E.VAL_SOURCE,
          TO_CHAR (SYSDATE, 'YYYYMMDD') ID_DPER,
          I.COD_ABI,
          LPAD (E.COD_NDG_OLD, 16, '0') COD_NDG,
          E.COD_RAPPORTO_OLD,
          E.COD_RAPPORTO_NEW,
          NULL COD_FILIALE_ORIG,
          NULL cod_filiale_dest,
          2 flg_tipo_migrrapp,
          SYSDATE DTA_INS
     FROM te_MCRES_MIGRRAPP_M0_gic E,
          T_MCRES_APP_ISTITUTI I,
          T_MCRES_WRK_MIGRRAPP_FILE M
    WHERE     E.COD_ISTITUTO = LPAD (I.COD_ISTITUTO, 3, '0')
          AND I.COD_ABI = M.COD_ABI
          AND INSTR (M.COD_FILE, E.VAL_SOURCE) > 0
          AND M.FLG_ATTIVO = 1
   UNION ALL
   SELECT DISTINCT 'MIGRRAPP_NEW' VAL_SOURCE,
                   ID_DPER,
                   E.COD_ABI,
                   LPAD (E.COD_NDG, 16, '0') COD_NDG,
                   E.COD_RAPPORTO_OLD,
                   E.COD_RAPPORTO_NEW,
                   E.COD_FILIALE_ORIG,
                   E.cod_filiale_dest,
                   3 FLG_TIPO_MIGRRAPP,
                   SYSDATE DTA_INS
     FROM TE_MCRES_MIGRRAPP_NEW E,
          T_MCRES_WRK_MIGRRAPP_FILE M,
          T_MCRES_CL_MIGRRAPP C
    WHERE     ID_DPER NOT LIKE '1.208.%'
          AND TO_NUMBER (E.ID_DPER) >= C.DTA_MIGRRAPP
          AND C.FLG_TIPO_MIGRRAPP = 3
          AND E.COD_ABI = M.COD_ABI
          AND M.COD_FILE = 'MIGRRAPP_NEW'
          AND M.FLG_ATTIVO = 1;
