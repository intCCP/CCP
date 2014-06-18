/* Formatted on 17/06/2014 18:02:27 (QP5 v5.227.12220.39754) */
CREATE OR REPLACE FORCE VIEW MCRE_OWN.V_MCRE0_APP_POSIZIONI_STATO
(
   COD_ABI_ISTITUTO,
   COD_ABI_CARTOLARIZZATO,
   FLG_OUTSOURCING,
   COD_COMPARTO,
   COD_STRUTTURA_COMPETENTE,
   COD_STRUTTURA_COMPETENTE_DV,
   COD_STRUTTURA_COMPETENTE_DC,
   COD_STRUTTURA_COMPETENTE_RG,
   COD_STRUTTURA_COMPETENTE_AR,
   COD_STRUTTURA_COMPETENTE_FI,
   ID_UTENTE,
   COD_MACROSTATO,
   DESC_ISTITUTO,
   VAL_LABEL_MACROSTATO,
   VAL_ORDINE,
   VAL_GRUPPO,
   DTA_VALIDITA,
   NUM_POSIZIONI,
   TOT_UTI_CASSA,
   TOT_UTI_FIRMA,
   TOT_UTI_CASSA_GB,
   TOT_UTI_FIRMA_GB,
   COD_LIVELLO
)
AS
     SELECT -- 1.0  21/05/2012 Valeria Galli   area e regione (Commenti con label:  VG - CIB/BDT - INIZIO)
           cod_abi_istituto,
            cod_abi_cartolarizzato,
            flg_outsourcing,
            cod_comparto,
            --------------------  VG - CIB/BDT - INIZIO --------------------
            cod_struttura_competente,
            cod_struttura_competente_dv,
            cod_struttura_competente_dc,
            cod_struttura_competente_rg,
            cod_struttura_competente_ar,
            cod_struttura_competente_fi,
            --------------------  VG - CIB/BDT - FINE --------------------
            NULLIF (id_utente, -1) id_utente,
            cod_macrostato,
            MAX (desc_istituto) desc_istituto,
            MAX (val_label_macrostato) val_label_macrostato,
            MAX (val_ordine) val_ordine,
            MAX (val_gruppo) val_gruppo,
            TRUNC (SYSDATE) dta_validita,
            COUNT (*) num_posizioni,
            SUM (scsb_uti_cassa) tot_uti_cassa,
            SUM (scsb_uti_firma) tot_uti_firma,
            SUM (scsb_uti_cassa * flg_somma) tot_uti_cassa_gb,
            SUM (scsb_uti_firma * flg_somma) tot_uti_firma_gb,
            cod_livello
       FROM v_mcre0_app_upd_fields
      WHERE flg_stato_chk = '1'
   GROUP BY cod_abi_istituto,
            cod_abi_cartolarizzato,
            flg_outsourcing,
            cod_comparto,
            id_utente,
            cod_macrostato,
            --------------------  VG - CIB/BDT - INIZIO --------------------
            cod_struttura_competente,
            cod_struttura_competente_dv,
            cod_struttura_competente_dc,
            cod_struttura_competente_rg,
            cod_struttura_competente_ar,
            cod_struttura_competente_fi,
            cod_livello
--------------------   VG - CIB/BDT - FINE --------------------;;
;


GRANT DELETE, INSERT, REFERENCES, SELECT, UPDATE, ON COMMIT REFRESH, QUERY REWRITE, DEBUG, FLASHBACK, MERGE VIEW ON MCRE_OWN.V_MCRE0_APP_POSIZIONI_STATO TO MCRE_USR;
