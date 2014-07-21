/* Formatted on 17/06/2014 18:11:48 (QP5 v5.227.12220.39754) */
CREATE OR REPLACE FORCE VIEW MCRE_OWN.V_MCRES_APP_STORICO_VOLTURA
(
   COD_ABI,
   COD_FILIALE,
   DESC_ISTITUTO,
   COD_NDG,
   DESC_NOME_CONTROPARTE,
   VAL_NUMERO_SOFF,
   COD_RAPPORTO_ORIG,
   DTA_CONTABILE,
   VAL_OPERAZIONE,
   ID,
   COD_UO_PRATICA
)
AS
   SELECT DISTINCT VOL.COD_ABI,
                   VOL.COD_FILIALE,
                   IST.DESC_ISTITUTO,
                   VOL.COD_NDG,
                   AG.DESC_NOME_CONTROPARTE,
                   VOL.VAL_NUMERO_SOFF,
                   VOL.COD_RAPPORTO_ORIG,
                   VOL.DTA_CONTABILE,
                   VOL.VAL_OPERAZIONE,
                   VOL.ID,
                   PR.COD_UO_PRATICA
     FROM (SELECT ID,
                  COD_ABI,
                  COD_FILIALE,
                  COD_NDG,
                  VAL_NUMERO_SOFF,
                  COD_RAPPORTO_ORIG,
                  DTA_CONTABILE,
                  'ACCENSIONE SOFFERENZA' VAL_OPERAZIONE
             FROM T_MCRES_APP_ACC_SOFF
           UNION
           SELECT ID,
                  COD_ABI,
                  COD_FILIALE,
                  COD_NDG,
                  VAL_NUMERO_SOFF,
                  COD_RAPPORTO_ORIG,
                  DTA_CONTABILE,
                  'GIRO INTERESSI' VAL_OPERAZIONE
             FROM T_MCRES_APP_GIRO_INT_ORIG) VOL
          JOIN T_MCRES_APP_POSIZIONI Z
             ON (Z.COD_ABI = VOL.COD_ABI AND Z.COD_NDG = VOL.COD_NDG)
          JOIN T_MCRES_APP_PRATICHE PR
             ON VOL.COD_ABI = PR.COD_ABI AND VOL.COD_NDG = PR.COD_NDG
          JOIN T_MCRES_APP_ISTITUTI IST ON VOL.COD_ABI = IST.COD_ABI
          LEFT JOIN T_MCRE0_APP_ANAGRAFICA_GRUPPO AG
             ON (AG.COD_SNDG = Z.COD_SNDG);


GRANT SELECT ON MCRE_OWN.V_MCRES_APP_STORICO_VOLTURA TO MCRE_USR;
