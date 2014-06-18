/* Formatted on 17/06/2014 18:11:27 (QP5 v5.227.12220.39754) */
CREATE OR REPLACE FORCE VIEW MCRE_OWN.V_MCRES_APP_SP_FORNITORI
(
   COD_SAP_FORNITORE,
   VAL_RAGIONE_SOCIALE1,
   VAL_RAGIONE_SOCIALE2,
   VAL_PARTITA_IVA,
   VAL_CODICE_FISCALE,
   VAL_PARTITA_IVA_UE,
   VAL_PARTITA_IVA_EXTRA_UE,
   VAL_INDIRIZZO,
   VAL_CAP,
   VAL_LOCALITA,
   VAL_PAESE,
   VAL_REGIONE,
   DTA_CENSIMENTO,
   COD_SOCIETA,
   VAL_PERC_RITENUTA,
   VAL_ALIQUOTA_CPA,
   VAL_ALIQUOTA_CPA2,
   VAL_ALIQUOTA_RITENUTA,
   VAL_IBAN1,
   VAL_IBAN2,
   VAL_IBAN3,
   VAL_IBAN4,
   VAL_IBAN5,
   VAL_IBAN6,
   VAL_IBAN7,
   VAL_IBAN8,
   VAL_IBAN9,
   VAL_IBAN10,
   COD_ABI,
   FLG_LEGALE,
   FLG_ALBO,
   FLG_CONVENZ,
   COD_PRESIDIO,
   COD_ID_LEGALE
)
AS
     SELECT a.COD_SAP_FORNITORE,
            a.VAL_RAGIONE_SOCIALE1,
            a.VAL_RAGIONE_SOCIALE2,
            a.VAL_PARTITA_IVA,
            a.VAL_CODICE_FISCALE,
            a.VAL_PARTITA_IVA_UE,
            a.VAL_PARTITA_IVA_EXTRA_UE,
            a.VAL_INDIRIZZO,
            a.VAL_CAP,
            a.VAL_LOCALITA,
            a.VAL_PAESE,
            a.VAL_REGIONE,
            a.DTA_CENSIMENTO,
            a.COD_SOCIETA,
            a.VAL_PERC_RITENUTA,
            a.VAL_ALIQUOTA_CPA,
            a.VAL_ALIQUOTA_CPA2,
            a.VAL_ALIQUOTA_RITENUTA,
            a.VAL_IBAN1,
            a.VAL_IBAN2,
            a.VAL_IBAN3,
            a.VAL_IBAN4,
            a.VAL_IBAN5,
            a.VAL_IBAN6,
            a.VAL_IBAN7,
            a.VAL_IBAN8,
            a.VAL_IBAN9,
            a.VAL_IBAN10,
            b.cod_abi,
            CASE WHEN c.val_legale_codfisc IS NULL THEN 'N' ELSE 'S' END
               AS flg_legale,
            c.flg_albo AS flg_albo,
            c.flg_convenz,
            c.cod_presidio,
            c.cod_id_legale
       FROM t_mcres_app_fornitori a
            JOIN t_mcres_cl_sap b ON a.cod_societa = b.cod_societa
            LEFT JOIN
            t_mcres_app_legali_esterni c
               ON (    a.val_codice_fiscale = c.val_legale_codfisc
                   AND c.flg_active = 1)
   -- A.P. Commentato il 31/01/2014 per visualizzazione su ricerca fornitori
   -- anche quando non Ú valorizzato il codice fiscale
   --WHERE a.val_codice_fiscale is not null
   ORDER BY a.VAL_RAGIONE_SOCIALE1;


GRANT DELETE, INSERT, REFERENCES, SELECT, UPDATE, ON COMMIT REFRESH, QUERY REWRITE, DEBUG, FLASHBACK, MERGE VIEW ON MCRE_OWN.V_MCRES_APP_SP_FORNITORI TO MCRE_USR;
