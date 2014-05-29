CREATE OR REPLACE PACKAGE BODY MCRE_OWN."PKG_MCRE0_ALIMENTAZIONE" AS
/******************************************************************************
   NAME:       PKG_MCRE0_ALIMENTAZIONE
   PURPOSE:

   REVISIONS:
   Ver        Date        Author             Description
   ---------  ----------  -----------------  ------------------------------------
   1.0        21/04/2010  Andrea Bartolomei  Created this package.
   2.0        24/02/2010  Chiara Giannangeli Storico mensile.
   3.0        25/05/2011  Luca Ferretti      Aggiunta caricamento ANADIP
   3.0.1      19/12/2011  Andrea Galliano    Aggiunta caricamento DTA_NASCITA su Anagrafica di gruppo
   4.0        24/05/2012  Valeria galli      Caricamento Email
   4.0.1      19/06/2012  Emiliano Pellizzi  Evolutiva Caricamento Email
   5.0        19/06/2012  Emiliano Pellizzi  Evolutiva Caricamento Iris
   5.1        22/06/2012  Emiliano Pellizzi  Add function FND_MCRE0_alimenta_IRIS_ap_st
   6.0        17/07/2012  Emiliano Pellizzi  Caricamento Pregiudizievoli
   6.1        08/11/2012  Luca Ferretti      Modifica Merge sul file_guida
   6.2        18/03/2012  M.murro            rimossa l'indicazione del cambio mese su storicizza_mople
   6.3        14/10/2013  T.Bernardi         Aggiunto FLG_FATAL al flusso IRIS
******************************************************************************/

   FUNCTION fnd_mcre0_alimenta_pregiudiz (p_rec IN f_slave_par_type)
      RETURN BOOLEAN
   IS
      c_nome   CONSTANT VARCHAR2 (100)
                           := c_package || '.FND_MCRE0_alimenta_PREGIUDIZIEV';
      b_flag            BOOLEAN;
      v_cur             pkg_mcre0_utils.cur_abi_type;
      v_count           NUMBER;
   BEGIN
      DBMS_OUTPUT.put_line ('INIZIALIZZO CURSORE X SOTTOPARTIZIONE COD_ABI');

      OPEN v_cur FOR
         SELECT DISTINCT cod_abi
                    FROM t_mcre0_app_istituti;

      DBMS_OUTPUT.put_line ('CURSORE X SOTTOPARTIZIONE COD_ABI INIZIALIZZATO');
      b_flag :=
         pkg_mcre0_partizioni.fnd_mcre0_add_partition (p_rec.seq_flusso,
                                                       p_rec.tab_trg,
                                                       p_rec.periodo,
                                                       v_cur
                                                      );

      IF (b_flag)
      THEN
         INSERT
            WHEN     num_recs = 1
                 AND TRIM (TO_CHAR (id_dper)) IS NOT NULL
                 AND TRIM (cod_tipo_notizia) IS NOT NULL
                 AND dta_elaborazione IS NOT NULL
            THEN
           INTO t_mcre0_st_pregiudizievoli
                (id_dper, cod_sndg, cod_tipo_notizia, desc_tipo_notizia,
                 dta_elaborazione
                )
         VALUES (id_dper, cod_sndg, cod_tipo_notizia, desc_tipo_notizia,
                 dta_elaborazione
                )
            WHEN    num_recs > 1
                 OR TRIM (TO_CHAR (id_dper)) IS NULL
                 OR TRIM (cod_tipo_notizia) IS NULL
                 OR dta_elaborazione IS NULL
            THEN
           INTO t_mcre0_sc_vincoli_preg
                (id_seq, id_dper, cod_sndg, cod_tipo_notizia,
                 desc_tipo_notizia, dta_elaborazione, pk_null
                )
         VALUES (p_rec.seq_flusso, id_dper, cod_sndg, cod_tipo_notizia,
                 desc_tipo_notizia, dta_elaborazione, '1'
                )
            SELECT *
              FROM (SELECT COUNT (1) OVER (PARTITION BY id_dper, cod_sndg, cod_tipo_notizia, dta_elaborazione)
                                                                     num_recs,
                           id_dper, cod_sndg, cod_tipo_notizia,
                           desc_tipo_notizia, dta_elaborazione
                      FROM t_mcre0_fl_pregiudizievoli) tmp;
         COMMIT;

         SELECT COUNT (*)
           INTO v_count
           FROM t_mcre0_sc_vincoli_preg sc
          WHERE sc.id_seq = p_rec.seq_flusso;

         UPDATE t_mcre0_wrk_acquisizione
            SET scarti_vincoli = v_count
          WHERE id_flusso = p_rec.seq_flusso;

         COMMIT;
         b_flag := TRUE;
      END IF;

      IF (b_flag)
      THEN
         pkg_mcre0_log.spo_mcre0_log_evento (p_rec.seq_flusso,
                                             c_nome,
                                             'OK',
                                             'DATI INSERITI CORRETTAMENTE'
                                            );
      END IF;

      RETURN b_flag;
   EXCEPTION
      WHEN OTHERS
      THEN
         DBMS_OUTPUT.put_line ('ERRORE IN FND_MCRE0_alimenta_PREGIUDIZIEV');
         DBMS_OUTPUT.put_line (SUBSTR (SQLERRM, 1, 255));
         ROLLBACK;

         IF (v_cur%ISOPEN)
         THEN
            CLOSE v_cur;

            DBMS_OUTPUT.put_line
                  ('ERRORE IN FND_MCRE0_alimenta_PREGIUDIZIEV - CLOSE CURSOR');
         END IF;

         pkg_mcre0_log.spo_mcre0_log_evento_no_commit (p_rec.seq_flusso,
                                                       p_rec.tab_trg,
                                                       'ERRORE',
                                                       SUBSTR (SQLERRM, 1,
                                                               255)
                                                      );
         RETURN FALSE;
   END fnd_mcre0_alimenta_pregiudiz;

   FUNCTION fnd_mcre0_alimenta_pregiud_ap (p_rec IN f_slave_par_type)
      RETURN BOOLEAN
   IS
      v_partition   VARCHAR2 (20);
      v_sql         VARCHAR2 (32000);
   BEGIN
      v_partition := 'CCP_P' || TO_CHAR (p_rec.periodo, 'yyyymmdd');
      v_sql :=
            'BEGIN

      MERGE INTO t_mcre0_app_PREGIUDIZIEVOLI24 trg
          USING t_mcre0_st_PREGIUDIZIEVOLI PARTITION('

         || v_partition
         || ')    src
            ON (src.COD_SNDG = trg.COD_SNDG AND
                src.COD_TIPO_NOTIZIA = trg.COD_TIPO_NOTIZIA  AND
                src.DTA_ELABORAZIONE = trg.DTA_ELABORAZIONE)
      WHEN MATCHED THEN

           UPDATE
              SET  trg.DESC_TIPO_NOTIZIA = src.DESC_TIPO_NOTIZIA ,
                   trg.dta_upd = SYSDATE,
                   trg.ID_DPER = SRC.ID_DPER
      WHEN NOT MATCHED THEN
           INSERT
                  (trg.ID_DPER, trg.COD_SNDG, trg.COD_TIPO_NOTIZIA,
                   trg.DESC_TIPO_NOTIZIA, trg.DTA_ELABORAZIONE, trg.dta_ins)
          VALUES
                  (src.ID_DPER, src.COD_SNDG, src.COD_TIPO_NOTIZIA,
                   src.DESC_TIPO_NOTIZIA, src.DTA_ELABORAZIONE, SYSDATE);

                commit;
            END;';
      DBMS_OUTPUT.put_line (v_sql);

      EXECUTE IMMEDIATE v_sql;

      RETURN TRUE;
   EXCEPTION
      WHEN OTHERS
      THEN
         DBMS_OUTPUT.put_line (SUBSTR (SQLERRM, 1, 255));
   END fnd_mcre0_alimenta_pregiud_ap;

   FUNCTION fnd_mcre0_alimenta_email (p_rec IN f_slave_par_type)
      RETURN BOOLEAN
   IS
      c_nome   CONSTANT VARCHAR2 (100)
                                  := c_package || '.FND_MCRE0_alimenta_EMAIL';
      b_flag            BOOLEAN;
      v_cur             pkg_mcre0_utils.cur_abi_type;
      v_count           NUMBER;
   BEGIN
      DBMS_OUTPUT.put_line ('INIZIALIZZO CURSORE X SOTTOPARTIZIONE COD_ABI');

      OPEN v_cur FOR
         SELECT DISTINCT cod_abi
                    FROM t_mcre0_app_istituti;

      DBMS_OUTPUT.put_line ('CURSORE X SOTTOPARTIZIONE COD_ABI INIZIALIZZATO');
      b_flag :=
         pkg_mcre0_partizioni.fnd_mcre0_add_partition (p_rec.seq_flusso,
                                                       p_rec.tab_trg,
                                                       p_rec.periodo,
                                                       v_cur
                                                      );

      IF (b_flag)
      THEN
         INSERT
            WHEN     num_recs = 1
                 AND TRIM (TO_CHAR (id_dper)) IS NOT NULL
                 AND TRIM (TO_CHAR (cod_matric)) IS NOT NULL

            THEN
           INTO t_mcre0_st_email
                (id_dper, cod_tipo_rec, desc_rec, ts_aggiorn, cod_soc_gdr,
                 desc_soc_gdr, cod_tip_dip, cod_matric, val_cognome,
                 val_nome, cod_pos_org, desc_pos_org, cod_prf_sic,
                 desc_prf_sic, dta_prfsini, dta_prfsfin, cod_matr_ps,
                 cod_tipuops, cod_socpspo, cod_uo_pspo, desc_uo_pspo,
                 cod_lopuops, cod_socw2k, cod_uow2k, id_sn_w2k, cod_socpss1,
                 cod_uo_pss1, desc_uo_pss1, cod_socpss2, cod_uo_pss2,
                 desc_uo_pss2, cod_socpss3, cod_uo_pss3, desc_uo_pss3,
                 cod_socpss4, cod_uo_pss4, cod_socpss5, cod_uo_pss5,
                 cod_socpss6, cod_uo_pss6, cod_socpss7, cod_uo_pss7,
                 cod_socsost, cod_uo_sost, desc_uo_sost, cod_po_sost,
                 cod_ps_sost, desc_ps_sost, dta_sostini, dta_sostfin,
                 cod_socass, cod_uo_ass, desc_uo_ass, dta_assini, dta_assfin,
                 cod_po_ass, dta_poinass, dta_pofiass, cod_socodis,
                 cod_uo_dis, desc_uo_dis, dta_disini, dta_disfin, cod_po_dis,
                 dta_poindis, dta_pofidis, cod_tip_pal, cod_socpal,
                 cod_uo_pal, desc_uo_pal, indirizzo, citta, cap, provincia,
                 cod_nazione, id_sesso, cod_fiscale, dta_assunz, dta_cessaz,
                 cod_grado, dta_grado, cod_ufficio, cod_ruolo, val_tel_uff,
                 val_tel_cel, val_fax, an_stanzat, cod_app_gr1, cod_app_gr2,
                 cod_app_gr3, cod_app_gr4, cod_dg_old, cod_dg_new, val_email,
                 cod_psigap, desc_po_ass, desc_po_dis, fl_respon, flagd,
                 cod_inc, cod_uoinc, cod_gruppo, cod_azienda, cod_matr_10,
                 fl_eml_sic
                )
         VALUES (id_dper, cod_tipo_rec, desc_rec, ts_aggiorn, cod_soc_gdr,
                 desc_soc_gdr, cod_tip_dip, cod_matric, val_cognome,
                 val_nome, cod_pos_org, desc_pos_org, cod_prf_sic,
                 desc_prf_sic, dta_prfsini, dta_prfsfin, cod_matr_ps,
                 cod_tipuops, cod_socpspo, cod_uo_pspo, desc_uo_pspo,
                 cod_lopuops, cod_socw2k, cod_uow2k, id_sn_w2k, cod_socpss1,
                 cod_uo_pss1, desc_uo_pss1, cod_socpss2, cod_uo_pss2,
                 desc_uo_pss2, cod_socpss3, cod_uo_pss3, desc_uo_pss3,
                 cod_socpss4, cod_uo_pss4, cod_socpss5, cod_uo_pss5,
                 cod_socpss6, cod_uo_pss6, cod_socpss7, cod_uo_pss7,
                 cod_socsost, cod_uo_sost, desc_uo_sost, cod_po_sost,
                 cod_ps_sost, desc_ps_sost, dta_sostini, dta_sostfin,
                 cod_socass, cod_uo_ass, desc_uo_ass, dta_assini, dta_assfin,
                 cod_po_ass, dta_poinass, dta_pofiass, cod_socodis,
                 cod_uo_dis, desc_uo_dis, dta_disini, dta_disfin, cod_po_dis,
                 dta_poindis, dta_pofidis, cod_tip_pal, cod_socpal,
                 cod_uo_pal, desc_uo_pal, indirizzo, citta, cap, provincia,
                 cod_nazione, id_sesso, cod_fiscale, dta_assunz, dta_cessaz,
                 cod_grado, dta_grado, cod_ufficio, cod_ruolo, val_tel_uff,
                 val_tel_cel, val_fax, an_stanzat, cod_app_gr1, cod_app_gr2,
                 cod_app_gr3, cod_app_gr4, cod_dg_old, cod_dg_new, val_email,
                 cod_psigap, desc_po_ass, desc_po_dis, fl_respon, flagd,
                 cod_inc, cod_uoinc, cod_gruppo, cod_azienda, cod_matr_10,
                 fl_eml_sic
                )
            WHEN    num_recs > 1
                 OR TRIM (TO_CHAR (id_dper)) IS NULL
                 OR TRIM (TO_CHAR (cod_matric)) IS NULL

            THEN
           INTO t_mcre0_sc_vincoli_email
                (id_seq, id_dper, cod_tipo_rec, desc_rec,
                 ts_aggiorn, cod_soc_gdr, desc_soc_gdr, cod_tip_dip,
                 cod_matric, val_cognome, val_nome, cod_pos_org,
                 desc_pos_org, cod_prf_sic, desc_prf_sic, dta_prfsini,
                 dta_prfsfin, cod_matr_ps, cod_tipuops, cod_socpspo,
                 cod_uo_pspo, desc_uo_pspo, cod_lopuops, cod_socw2k,
                 cod_uow2k, id_sn_w2k, cod_socpss1, cod_uo_pss1,
                 desc_uo_pss1, cod_socpss2, cod_uo_pss2, desc_uo_pss2,
                 cod_socpss3, cod_uo_pss3, desc_uo_pss3, cod_socpss4,
                 cod_uo_pss4, cod_socpss5, cod_uo_pss5, cod_socpss6,
                 cod_uo_pss6, cod_socpss7, cod_uo_pss7, cod_socsost,
                 cod_uo_sost, desc_uo_sost, cod_po_sost, cod_ps_sost,
                 desc_ps_sost, dta_sostini, dta_sostfin, cod_socass,
                 cod_uo_ass, desc_uo_ass, dta_assini, dta_assfin, cod_po_ass,
                 dta_poinass, dta_pofiass, cod_socodis, cod_uo_dis,
                 desc_uo_dis, dta_disini, dta_disfin, cod_po_dis,
                 dta_poindis, dta_pofidis, cod_tip_pal, cod_socpal,
                 cod_uo_pal, desc_uo_pal, indirizzo, citta, cap, provincia,
                 cod_nazione, id_sesso, cod_fiscale, dta_assunz, dta_cessaz,
                 cod_grado, dta_grado, cod_ufficio, cod_ruolo, val_tel_uff,
                 val_tel_cel, val_fax, an_stanzat, cod_app_gr1, cod_app_gr2,
                 cod_app_gr3, cod_app_gr4, cod_dg_old, cod_dg_new, val_email,
                 cod_psigap, desc_po_ass, desc_po_dis, fl_respon, flagd,
                 cod_inc, cod_uoinc, cod_gruppo, cod_azienda, cod_matr_10,
                 fl_eml_sic, pk_null
                )
         VALUES (p_rec.seq_flusso, id_dper, cod_tipo_rec, desc_rec,
                 ts_aggiorn, cod_soc_gdr, desc_soc_gdr, cod_tip_dip,
                 cod_matric, val_cognome, val_nome, cod_pos_org,
                 desc_pos_org, cod_prf_sic, desc_prf_sic, dta_prfsini,
                 dta_prfsfin, cod_matr_ps, cod_tipuops, cod_socpspo,
                 cod_uo_pspo, desc_uo_pspo, cod_lopuops, cod_socw2k,
                 cod_uow2k, id_sn_w2k, cod_socpss1, cod_uo_pss1,
                 desc_uo_pss1, cod_socpss2, cod_uo_pss2, desc_uo_pss2,
                 cod_socpss3, cod_uo_pss3, desc_uo_pss3, cod_socpss4,
                 cod_uo_pss4, cod_socpss5, cod_uo_pss5, cod_socpss6,
                 cod_uo_pss6, cod_socpss7, cod_uo_pss7, cod_socsost,
                 cod_uo_sost, desc_uo_sost, cod_po_sost, cod_ps_sost,
                 desc_ps_sost, dta_sostini, dta_sostfin, cod_socass,
                 cod_uo_ass, desc_uo_ass, dta_assini, dta_assfin, cod_po_ass,
                 dta_poinass, dta_pofiass, cod_socodis, cod_uo_dis,
                 desc_uo_dis, dta_disini, dta_disfin, cod_po_dis,
                 dta_poindis, dta_pofidis, cod_tip_pal, cod_socpal,
                 cod_uo_pal, desc_uo_pal, indirizzo, citta, cap, provincia,
                 cod_nazione, id_sesso, cod_fiscale, dta_assunz, dta_cessaz,
                 cod_grado, dta_grado, cod_ufficio, cod_ruolo, val_tel_uff,
                 val_tel_cel, val_fax, an_stanzat, cod_app_gr1, cod_app_gr2,
                 cod_app_gr3, cod_app_gr4, cod_dg_old, cod_dg_new, val_email,
                 cod_psigap, desc_po_ass, desc_po_dis, fl_respon, flagd,
                 cod_inc, cod_uoinc, cod_gruppo, cod_azienda, cod_matr_10,
                 fl_eml_sic, '1'
                )
            SELECT *
              FROM (SELECT COUNT (1) OVER (PARTITION BY id_dper, cod_matric)
                                                                     num_recs,
                           id_dper, cod_tipo_rec, desc_rec, ts_aggiorn,
                           cod_soc_gdr, desc_soc_gdr, cod_tip_dip, cod_matric,
                           val_cognome, val_nome, cod_pos_org, desc_pos_org,
                           cod_prf_sic, desc_prf_sic, dta_prfsini,
                           dta_prfsfin, cod_matr_ps, cod_tipuops, cod_socpspo,
                           cod_uo_pspo, desc_uo_pspo, cod_lopuops, cod_socw2k,
                           cod_uow2k, id_sn_w2k, cod_socpss1, cod_uo_pss1,
                           desc_uo_pss1, cod_socpss2, cod_uo_pss2,
                           desc_uo_pss2, cod_socpss3, cod_uo_pss3,
                           desc_uo_pss3, cod_socpss4, cod_uo_pss4,
                           cod_socpss5, cod_uo_pss5, cod_socpss6, cod_uo_pss6,
                           cod_socpss7, cod_uo_pss7, cod_socsost, cod_uo_sost,
                           desc_uo_sost, cod_po_sost, cod_ps_sost,
                           desc_ps_sost, dta_sostini, dta_sostfin, cod_socass,
                           cod_uo_ass, desc_uo_ass, dta_assini, dta_assfin,
                           cod_po_ass, dta_poinass, dta_pofiass, cod_socodis,
                           cod_uo_dis, desc_uo_dis, dta_disini, dta_disfin,
                           cod_po_dis, dta_poindis, dta_pofidis, cod_tip_pal,
                           cod_socpal, cod_uo_pal, desc_uo_pal, indirizzo,
                           citta, cap, provincia, cod_nazione, id_sesso,
                           cod_fiscale, dta_assunz, dta_cessaz, cod_grado,
                           dta_grado, cod_ufficio, cod_ruolo, val_tel_uff,
                           val_tel_cel, val_fax, an_stanzat, cod_app_gr1,
                           cod_app_gr2, cod_app_gr3, cod_app_gr4, cod_dg_old,
                           cod_dg_new, val_email, cod_psigap, desc_po_ass,
                           desc_po_dis, fl_respon, flagd, cod_inc, cod_uoinc,
                           cod_gruppo, cod_azienda, cod_matr_10, fl_eml_sic
                      FROM t_mcre0_fl_email) tmp;
--                  INSERT
--             WHEN
--             NUM_RECS = 1
--             AND TRIM(TO_CHAR(ID_DPER)) IS NOT NULL
--             AND TRIM(TO_CHAR(COD_MATRICOLA)) IS NOT NULL

         --            THEN

         --            INTO T_MCRE0_ST_EMAIL (
--            ID_DPER    ,
--            COD_MATRICOLA    ,
--             VAL_cognome    ,
--            VAL_NOME    ,
--            VAL_EMAIL    ,
--            VAL_TELEFONO    ,
--            cod_istituto,
--            cod_uo,
--            VAL_SEDE
--            )
--            VALUES (
--            ID_DPER    ,
--            COD_MATRICOLA    ,
--             VAL_cognome    ,
--            VAL_NOME    ,
--            VAL_EMAIL    ,
--            VAL_TELEFONO    ,
--            cod_istituto,
--            cod_uo,
--            VAL_SEDE        )

         --             WHEN
--             NUM_RECS > 1
--             OR TRIM(TO_CHAR(ID_DPER)) IS NULL
--             OR TRIM(TO_CHAR(COD_MATRICOLA)) IS NULL

         --             THEN
--             INTO T_MCRE0_SC_VINCOLI_EMAIL (
--                ID_SEQ    ,
--                 ID_DPER    ,
--                COD_MATRICOLA   ,
--             VAL_cognome    ,
--                VAL_NOME    ,
--                VAL_EMAIL    ,
--                VAL_TELEFONO    ,
--            cod_istituto,
--            cod_uo,
--                VAL_SEDE    ,
--                PK_NULL
--                )

         --                VALUES (
--                p_rec.SEQ_FLUSSO,
--                ID_DPER    ,
--                COD_MATRICOLA    ,
--             VAL_cognome    ,
--                VAL_NOME    ,
--                VAL_EMAIL    ,
--                VAL_TELEFONO    ,
--            cod_istituto,
--            cod_uo,
--                VAL_SEDE    ,
--                '1')

         --             SELECT * FROM
--        (
--            SELECT
--                COUNT(1) OVER(PARTITION BY  ID_DPER,  COD_matricola) NUM_RECS,
--                ID_DPER    ,
--                COD_MATRICOLA    ,
--             VAL_cognome    ,
--                VAL_NOME    ,
--                VAL_EMAIL    ,
--                VAL_TELEFONO    ,
--            cod_istituto,
--            cod_uo,
--                VAL_SEDE

         --            FROM
--              T_MCRE0_FL_EMAIL
--        ) tmp;
         COMMIT;

         SELECT COUNT (*)
           INTO v_count
           FROM t_mcre0_sc_vincoli_email sc
          WHERE sc.id_seq = p_rec.seq_flusso;

         UPDATE t_mcre0_wrk_acquisizione
            SET scarti_vincoli = v_count
          WHERE id_flusso = p_rec.seq_flusso;

         COMMIT;
         b_flag := TRUE;
      END IF;

      IF (b_flag)
      THEN
         pkg_mcre0_log.spo_mcre0_log_evento (p_rec.seq_flusso,
                                             c_nome,
                                             'OK',
                                             'DATI INSERITI CORRETTAMENTE'
                                            );
      END IF;

      RETURN b_flag;
   EXCEPTION
      WHEN OTHERS
      THEN
         DBMS_OUTPUT.put_line ('ERRORE IN FND_MCRE0_alimenta_EMAIL');
         DBMS_OUTPUT.put_line (SUBSTR (SQLERRM, 1, 255));
         ROLLBACK;

         IF (v_cur%ISOPEN)
         THEN
            CLOSE v_cur;

            DBMS_OUTPUT.put_line
                         ('ERRORE IN FND_MCRE0_alimenta_EMAIL - CLOSE CURSOR');
         END IF;

         pkg_mcre0_log.spo_mcre0_log_evento_no_commit (p_rec.seq_flusso,
                                                       p_rec.tab_trg,
                                                       'ERRORE',
                                                       SUBSTR (SQLERRM, 1,
                                                               255)
                                                      );
         RETURN FALSE;
   END fnd_mcre0_alimenta_email;

   FUNCTION fnd_mcre0_alimenta_email_ap (p_rec IN f_slave_par_type)
      RETURN BOOLEAN
   IS
      v_partition   VARCHAR2 (20);
      v_sql         VARCHAR2 (32000);
   BEGIN
      v_partition := 'CCP_P' || TO_CHAR (p_rec.periodo, 'yyyymmdd');
      v_sql :=
            'BEGIN

    MERGE INTO t_mcre0_app_email trg
       USING t_mcre0_st_email PARTITION('

         || v_partition
         || ')    src
       ON (src.cod_matric = trg.cod_matric AND NVL (trg.flg_web, 0) = 0)
       WHEN MATCHED THEN
          UPDATE
             SET trg.id_dper = src.id_dper, trg.cod_tipo_rec = src.cod_tipo_rec,
                 trg.desc_rec = src.desc_rec, trg.ts_aggiorn = src.ts_aggiorn,
                 trg.cod_soc_gdr = src.cod_soc_gdr,
                 trg.desc_soc_gdr = src.desc_soc_gdr,
                 trg.cod_tip_dip = src.cod_tip_dip,
                 trg.val_cognome = src.val_cognome, trg.val_nome = src.val_nome,
                 trg.cod_pos_org = src.cod_pos_org,
                 trg.desc_pos_org = src.desc_pos_org,
                 trg.cod_prf_sic = src.cod_prf_sic,
                 trg.desc_prf_sic = src.desc_prf_sic,
                 trg.dta_prfsini = src.dta_prfsini,
                 trg.dta_prfsfin = src.dta_prfsfin,
                 trg.cod_matr_ps = src.cod_matr_ps,
                 trg.cod_tipuops = src.cod_tipuops,
                 trg.cod_socpspo = src.cod_socpspo,
                 trg.cod_uo_pspo = src.cod_uo_pspo,
                 trg.desc_uo_pspo = src.desc_uo_pspo,
                 trg.cod_lopuops = src.cod_lopuops,
                 trg.cod_socw2k = src.cod_socw2k, trg.cod_uow2k = src.cod_uow2k,
                 trg.id_sn_w2k = src.id_sn_w2k, trg.cod_socpss1 = src.cod_socpss1,
                 trg.cod_uo_pss1 = src.cod_uo_pss1,
                 trg.desc_uo_pss1 = src.desc_uo_pss1,
                 trg.cod_socpss2 = src.cod_socpss2,
                 trg.cod_uo_pss2 = src.cod_uo_pss2,
                 trg.desc_uo_pss2 = src.desc_uo_pss2,
                 trg.cod_socpss3 = src.cod_socpss3,
                 trg.cod_uo_pss3 = src.cod_uo_pss3,
                 trg.desc_uo_pss3 = src.desc_uo_pss3,
                 trg.cod_socpss4 = src.cod_socpss4,
                 trg.cod_uo_pss4 = src.cod_uo_pss4,
                 trg.cod_socpss5 = src.cod_socpss5,
                 trg.cod_uo_pss5 = src.cod_uo_pss5,
                 trg.cod_socpss6 = src.cod_socpss6,
                 trg.cod_uo_pss6 = src.cod_uo_pss6,
                 trg.cod_socpss7 = src.cod_socpss7,
                 trg.cod_uo_pss7 = src.cod_uo_pss7,
                 trg.cod_socsost = src.cod_socsost,
                 trg.cod_uo_sost = src.cod_uo_sost,
                 trg.desc_uo_sost = src.desc_uo_sost,
                 trg.cod_po_sost = src.cod_po_sost,
                 trg.cod_ps_sost = src.cod_ps_sost,
                 trg.desc_ps_sost = src.desc_ps_sost,
                 trg.dta_sostini = src.dta_sostini,
                 trg.dta_sostfin = src.dta_sostfin,
                 trg.cod_socass = src.cod_socass, trg.cod_uo_ass = src.cod_uo_ass,
                 trg.desc_uo_ass = src.desc_uo_ass,
                 trg.dta_assini = src.dta_assini, trg.dta_assfin = src.dta_assfin,
                 trg.cod_po_ass = src.cod_po_ass,
                 trg.dta_poinass = src.dta_poinass,
                 trg.dta_pofiass = src.dta_pofiass,
                 trg.cod_socodis = src.cod_socodis,
                 trg.cod_uo_dis = src.cod_uo_dis,
                 trg.desc_uo_dis = src.desc_uo_dis,
                 trg.dta_disini = src.dta_disini, trg.dta_disfin = src.dta_disfin,
                 trg.cod_po_dis = src.cod_po_dis,
                 trg.dta_poindis = src.dta_poindis,
                 trg.dta_pofidis = src.dta_pofidis,
                 trg.cod_tip_pal = src.cod_tip_pal,
                 trg.cod_socpal = src.cod_socpal, trg.cod_uo_pal = src.cod_uo_pal,
                 trg.desc_uo_pal = src.desc_uo_pal, trg.indirizzo = src.indirizzo,
                 trg.citta = src.citta, trg.cap = src.cap,
                 trg.provincia = src.provincia, trg.cod_nazione = src.cod_nazione,
                 trg.id_sesso = src.id_sesso, trg.cod_fiscale = src.cod_fiscale,
                 trg.dta_assunz = src.dta_assunz, trg.dta_cessaz = src.dta_cessaz,
                 trg.cod_grado = src.cod_grado, trg.dta_grado = src.dta_grado,
                 trg.cod_ufficio = src.cod_ufficio, trg.cod_ruolo = src.cod_ruolo,
                 trg.val_tel_uff = src.val_tel_uff,
                 trg.val_tel_cel = src.val_tel_cel, trg.val_fax = src.val_fax,
                 trg.an_stanzat = src.an_stanzat,
                 trg.cod_app_gr1 = src.cod_app_gr1,
                 trg.cod_app_gr2 = src.cod_app_gr2,
                 trg.cod_app_gr3 = src.cod_app_gr3,
                 trg.cod_app_gr4 = src.cod_app_gr4,
                 trg.cod_dg_old = src.cod_dg_old, trg.cod_dg_new = src.cod_dg_new,
                 trg.val_email = src.val_email, trg.cod_psigap = src.cod_psigap,
                 trg.desc_po_ass = src.desc_po_ass,
                 trg.desc_po_dis = src.desc_po_dis, trg.fl_respon = src.fl_respon,
                 trg.flagd = src.flagd, trg.cod_inc = src.cod_inc,
                 trg.cod_uoinc = src.cod_uoinc, trg.cod_gruppo = src.cod_gruppo,
                 trg.cod_azienda = src.cod_azienda,
                 trg.cod_matr_10 = src.cod_matr_10,
                 trg.fl_eml_sic = src.fl_eml_sic, trg.dta_upd = SYSDATE
       WHEN NOT MATCHED THEN
          INSERT (trg.id_dper, trg.cod_tipo_rec, trg.desc_rec, trg.ts_aggiorn,
                  trg.cod_soc_gdr, trg.desc_soc_gdr, trg.cod_tip_dip,
                  trg.cod_matric, trg.val_cognome, trg.val_nome,
                  trg.cod_pos_org, trg.desc_pos_org, trg.cod_prf_sic,
                  trg.desc_prf_sic, trg.dta_prfsini, trg.dta_prfsfin,
                  trg.cod_matr_ps, trg.cod_tipuops, trg.cod_socpspo,
                  trg.cod_uo_pspo, trg.desc_uo_pspo, trg.cod_lopuops,
                  trg.cod_socw2k, trg.cod_uow2k, trg.id_sn_w2k, trg.cod_socpss1,
                  trg.cod_uo_pss1, trg.desc_uo_pss1, trg.cod_socpss2,
                  trg.cod_uo_pss2, trg.desc_uo_pss2, trg.cod_socpss3,
                  trg.cod_uo_pss3, trg.desc_uo_pss3, trg.cod_socpss4,
                  trg.cod_uo_pss4, trg.cod_socpss5, trg.cod_uo_pss5,
                  trg.cod_socpss6, trg.cod_uo_pss6, trg.cod_socpss7,
                  trg.cod_uo_pss7, trg.cod_socsost, trg.cod_uo_sost,
                  trg.desc_uo_sost, trg.cod_po_sost, trg.cod_ps_sost,
                  trg.desc_ps_sost, trg.dta_sostini, trg.dta_sostfin,
                  trg.cod_socass, trg.cod_uo_ass, trg.desc_uo_ass, trg.dta_assini,
                  trg.dta_assfin, trg.cod_po_ass, trg.dta_poinass,
                  trg.dta_pofiass, trg.cod_socodis, trg.cod_uo_dis,
                  trg.desc_uo_dis, trg.dta_disini, trg.dta_disfin, trg.cod_po_dis,
                  trg.dta_poindis, trg.dta_pofidis, trg.cod_tip_pal,
                  trg.cod_socpal, trg.cod_uo_pal, trg.desc_uo_pal, trg.indirizzo,
                  trg.citta, trg.cap, trg.provincia, trg.cod_nazione,
                  trg.id_sesso, trg.cod_fiscale, trg.dta_assunz, trg.dta_cessaz,
                  trg.cod_grado, trg.dta_grado, trg.cod_ufficio, trg.cod_ruolo,
                  trg.val_tel_uff, trg.val_tel_cel, trg.val_fax, trg.an_stanzat,
                  trg.cod_app_gr1, trg.cod_app_gr2, trg.cod_app_gr3,
                  trg.cod_app_gr4, trg.cod_dg_old, trg.cod_dg_new, trg.val_email,
                  trg.cod_psigap, trg.desc_po_ass, trg.desc_po_dis, trg.fl_respon,
                  trg.flagd, trg.cod_inc, trg.cod_uoinc, trg.cod_gruppo,
                  trg.cod_azienda, trg.cod_matr_10, trg.fl_eml_sic, trg.dta_ins)
          VALUES (src.id_dper, src.cod_tipo_rec, src.desc_rec, src.ts_aggiorn,
                  src.cod_soc_gdr, src.desc_soc_gdr, src.cod_tip_dip,
                  src.cod_matric, src.val_cognome, src.val_nome,
                  src.cod_pos_org, src.desc_pos_org, src.cod_prf_sic,
                  src.desc_prf_sic, src.dta_prfsini, src.dta_prfsfin,
                  src.cod_matr_ps, src.cod_tipuops, src.cod_socpspo,
                  src.cod_uo_pspo, src.desc_uo_pspo, src.cod_lopuops,
                  src.cod_socw2k, src.cod_uow2k, src.id_sn_w2k, src.cod_socpss1,
                  src.cod_uo_pss1, src.desc_uo_pss1, src.cod_socpss2,
                  src.cod_uo_pss2, src.desc_uo_pss2, src.cod_socpss3,
                  src.cod_uo_pss3, src.desc_uo_pss3, src.cod_socpss4,
                  src.cod_uo_pss4, src.cod_socpss5, src.cod_uo_pss5,
                  src.cod_socpss6, src.cod_uo_pss6, src.cod_socpss7,
                  src.cod_uo_pss7, src.cod_socsost, src.cod_uo_sost,
                  src.desc_uo_sost, src.cod_po_sost, src.cod_ps_sost,
                  src.desc_ps_sost, src.dta_sostini, src.dta_sostfin,
                  src.cod_socass, src.cod_uo_ass, src.desc_uo_ass, src.dta_assini,
                  src.dta_assfin, src.cod_po_ass, src.dta_poinass,
                  src.dta_pofiass, src.cod_socodis, src.cod_uo_dis,
                  src.desc_uo_dis, src.dta_disini, src.dta_disfin, src.cod_po_dis,
                  src.dta_poindis, src.dta_pofidis, src.cod_tip_pal,
                  src.cod_socpal, src.cod_uo_pal, src.desc_uo_pal, src.indirizzo,
                  src.citta, src.cap, src.provincia, src.cod_nazione,
                  src.id_sesso, src.cod_fiscale, src.dta_assunz, src.dta_cessaz,
                  src.cod_grado, src.dta_grado, src.cod_ufficio, src.cod_ruolo,
                  src.val_tel_uff, src.val_tel_cel, src.val_fax, src.an_stanzat,
                  src.cod_app_gr1, src.cod_app_gr2, src.cod_app_gr3,
                  src.cod_app_gr4, src.cod_dg_old, src.cod_dg_new, src.val_email,
                  src.cod_psigap, src.desc_po_ass, src.desc_po_dis, src.fl_respon,
                  src.flagd, src.cod_inc, src.cod_uoinc, src.cod_gruppo,
                  src.cod_azienda, src.cod_matr_10, src.fl_eml_sic, SYSDATE);

                commit;
            END;';
      DBMS_OUTPUT.put_line (v_sql);

      EXECUTE IMMEDIATE v_sql;

      RETURN TRUE;
   EXCEPTION
      WHEN OTHERS
      THEN
         DBMS_OUTPUT.put_line (SUBSTR (SQLERRM, 1, 255));
   END fnd_mcre0_alimenta_email_ap;


FUNCTION FND_MCRE0_alimenta_ABI_ELAB(p_rec IN f_slave_par_type) RETURN BOOLEAN IS

        c_nome CONSTANT VARCHAR2(100) := c_package || '.FND_MCRE0_alimenta_ABI_ELAB';
        b_flag BOOLEAN;
        v_cur PKG_MCRE0_UTILS.cur_abi_type;
        v_count NUMBER;



   BEGIN

     DBMS_OUTPUT.PUT_LINE('INIZIALIZZO CURSORE X SOTTOPARTIZIONE COD_ABI');

     open v_cur for select distinct COD_ABI
     from T_MCRE0_APP_ISTITUTI;

       DBMS_OUTPUT.PUT_LINE('CURSORE X SOTTOPARTIZIONE COD_ABI INIZIALIZZATO');

     b_flag := PKG_MCRE0_PARTIZIONI.FND_MCRE0_add_partition(p_rec.SEQ_FLUSSO,p_rec.TAB_TRG,p_rec.PERIODO,v_cur);


     IF(b_flag) THEN

             insert
             when
             NUM_RECS = 1
             AND TRIM(TO_CHAR(ID_DPER)) IS NOT NULL
             AND TRIM(TO_CHAR(COD_ABI_ISTITUTO)) IS NOT NULL

             then
                INTO T_MCRE0_ST_ABI_ELABORATI
                            (ID_DPER,
                             COD_ABI_ISTITUTO,
                             DTA_ELABORAZIONE,
                             TMS_ULTIMA_ELABORAZIONE)

                           VALUES (

                             ID_DPER,
                             COD_ABI_ISTITUTO,
                             DTA_ELABORAZIONE,
                             TMS_ULTIMA_ELABORAZIONE )

             when
             NUM_RECS > 1
             OR TRIM(TO_CHAR(ID_DPER)) IS NULL
             OR TRIM(TO_CHAR(COD_ABI_ISTITUTO)) IS NULL

             then
             INTO T_MCRE0_SC_VINCOLI_ABI_ELAB (
            ID_SEQ    ,
            ID_DPER    ,
            COD_ABI_ISTITUTO    ,
            DTA_ELABORAZIONE    ,
            TMS_ULTIMA_ELABORAZIONE    ,
            PK_NULL
            )
            VALUES (
            p_rec.SEQ_FLUSSO,
            ID_DPER,
            COD_ABI_ISTITUTO,
            DTA_ELABORAZIONE,
            TMS_ULTIMA_ELABORAZIONE,
            '1')


             select * from
        (
            SELECT
                COUNT(1) OVER(PARTITION BY ID_DPER, COD_ABI_ISTITUTO) NUM_RECS,
                ID_DPER,
                COD_ABI_ISTITUTO,
                DTA_ELABORAZIONE,
                TMS_ULTIMA_ELABORAZIONE

            FROM
              T_MCRE0_FL_ABI_ELABORATI
        ) tmp;
        COMMIT;



          SELECT COUNT(*)
          INTO v_count
          FROM T_MCRE0_SC_VINCOLI_ABI_ELAB SC
          WHERE SC.ID_SEQ = p_rec.SEQ_FLUSSO;


          UPDATE T_MCRE0_WRK_ACQUISIZIONE
          SET SCARTI_VINCOLI = v_count
          WHERE ID_FLUSSO = p_rec.SEQ_FLUSSO;
          commit;


            b_flag := TRUE;

     END IF;




         IF(b_flag) THEN

        PKG_MCRE0_LOG.SPO_MCRE0_LOG_EVENTO(p_rec.SEQ_FLUSSO,c_nome,'OK','DATI INSERITI CORRETTAMENTE');

        END IF;


        RETURN TRUE;


            EXCEPTION


        WHEN OTHERS THEN

        DBMS_OUTPUT.PUT_LINE('ERRORE IN FND_MCRE0_alimenta_ABI_ELAB');
         DBMS_OUTPUT.PUT_LINE(SUBSTR(SQLERRM, 1, 255));
            ROLLBACK;




           IF(v_cur%ISOPEN) THEN

                    CLOSE v_cur;

                     DBMS_OUTPUT.PUT_LINE('ERRORE IN FND_MCRE0_alimenta_ABI_ELAB - CLOSE CURSOR');

                END IF;

            PKG_MCRE0_LOG.SPO_MCRE0_log_evento_no_commit(p_rec.SEQ_FLUSSO,p_rec.TAB_TRG,'ERRORE',SUBSTR(SQLERRM, 1, 255));

            RETURN FALSE;

     END FND_MCRE0_alimenta_ABI_ELAB;

FUNCTION FND_MCRE0_alimenta_ABI_ELAB_AP(p_rec IN f_slave_par_type) RETURN BOOLEAN IS

  v_partition varchar2(20);
  v_sql varchar2(5000);

   begin


   v_partition := 'CCP_P'|| to_char(p_rec.PERIODO, 'yyyymmdd');



          v_sql :=  'BEGIN MERGE

               INTO  T_MCRE0_APP_ABI_ELABORATI24 trg

               USING T_MCRE0_ST_ABI_ELABORATI  PARTITION(' || v_partition || ') src

               ON  ( src.COD_ABI_ISTITUTO = trg.COD_ABI_ISTITUTO)
            WHEN MATCHED

            THEN

              UPDATE

              SET


                trg.DTA_ELABORAZIONE = src.DTA_ELABORAZIONE,
                trg.TMS_ULTIMA_ELABORAZIONE = src.TMS_ULTIMA_ELABORAZIONE,
                trg.DTA_UPD = sysdate,
                trg.COD_OPERATORE_INS_UPD = NULL,
                trg.ID_DPER = src.ID_DPER

           WHEN NOT MATCHED
           THEN
              INSERT (
                        trg.COD_ABI_ISTITUTO,
                        trg.DTA_ELABORAZIONE,
                        trg.TMS_ULTIMA_ELABORAZIONE,
                        trg.DTA_INS,
                        trg.DTA_UPD,
                        trg.COD_OPERATORE_INS_UPD,
                        trg.ID_DPER )

              VALUES (
                        src.COD_ABI_ISTITUTO,
                        src.DTA_ELABORAZIONE,
                        src.TMS_ULTIMA_ELABORAZIONE,
                        sysdate,
                        sysdate,
                        NULL,
                        src.ID_DPER );

            commit;
            END;';


            DBMS_OUTPUT.PUT_LINE(v_sql);


              execute immediate v_sql;

              RETURN TRUE;


                EXCEPTION WHEN OTHERS THEN

                  DBMS_OUTPUT.PUT_LINE(SUBSTR(SQLERRM, 1, 255));



                end FND_MCRE0_alimenta_ABI_ELAB_AP;

FUNCTION FND_MCRE0_alimenta_FILE_GUIDA(p_rec IN f_slave_par_type) RETURN BOOLEAN IS

        c_nome CONSTANT VARCHAR2(100) := c_package || '.FND_MCRE0_alimenta_FILE_GUIDA';
        b_flag BOOLEAN;
        v_cur PKG_MCRE0_UTILS.cur_abi_type;
        v_count NUMBER;



   BEGIN

     DBMS_OUTPUT.PUT_LINE('INIZIALIZZO CURSORE X SOTTOPARTIZIONE COD_ABI');

     open v_cur for select distinct COD_ABI
     from T_MCRE0_APP_ISTITUTI;

       DBMS_OUTPUT.PUT_LINE('CURSORE X SOTTOPARTIZIONE COD_ABI INIZIALIZZATO');

     b_flag := PKG_MCRE0_PARTIZIONI.FND_MCRE0_add_partition(p_rec.SEQ_FLUSSO,p_rec.TAB_TRG,p_rec.PERIODO,v_cur);


     IF(b_flag) THEN

             insert
             when
             NUM_RECS = 1
             AND TRIM(TO_CHAR(ID_DPER)) IS NOT NULL
             AND TRIM(TO_CHAR(COD_ABI_CARTOLARIZZATO)) IS NOT NULL
             AND TRIM(TO_CHAR(COD_NDG)) IS NOT NULL

             then
               INTO T_MCRE0_ST_FILE_GUIDA
            (ID_DPER    ,
            COD_ABI_ISTITUTO    ,
            COD_ABI_CARTOLARIZZATO    ,
            COD_NDG    ,
            COD_SNDG
            )

            values (
                    ID_DPER    ,
                    COD_ABI_ISTITUTO    ,
                    COD_ABI_CARTOLARIZZATO    ,
                    COD_NDG    ,
                    COD_SNDG
                    )

             when
             NUM_RECS > 1
             or TRIM(TO_CHAR(ID_DPER)) IS NULL
             or TRIM(TO_CHAR(COD_ABI_CARTOLARIZZATO)) IS NULL
             or TRIM(TO_CHAR(COD_NDG)) IS NULL

             then
             INTO T_MCRE0_SC_VINCOLI_FILE_GUIDA (
            ID_SEQ    ,
            ID_DPER    ,
            COD_ABI_ISTITUTO    ,
            COD_ABI_CARTOLARIZZATO    ,
            COD_NDG    ,
            COD_SNDG    ,
            PK_NULL
            )
            values (
            p_rec.SEQ_FLUSSO,
            ID_DPER,
            COD_ABI_ISTITUTO,
            COD_ABI_CARTOLARIZZATO,
            COD_NDG,
            COD_SNDG,
            '1')


             select * from
        (
            SELECT
                COUNT(1) OVER(PARTITION BY ID_DPER, COD_ABI_CARTOLARIZZATO,COD_NDG ) NUM_RECS,
                ID_DPER    ,
                COD_ABI_ISTITUTO    ,
                COD_ABI_CARTOLARIZZATO    ,
                COD_NDG    ,
                COD_SNDG

            FROM
              T_MCRE0_FL_FILE_GUIDA
        ) tmp;
        COMMIT;


          SELECT COUNT(*)
          INTO v_count
          FROM T_MCRE0_SC_VINCOLI_FILE_GUIDA SC
          WHERE SC.ID_SEQ = p_rec.SEQ_FLUSSO;


          UPDATE T_MCRE0_WRK_ACQUISIZIONE
          SET SCARTI_VINCOLI = v_count
          WHERE ID_FLUSSO = p_rec.SEQ_FLUSSO;
          commit;

         b_flag := TRUE;

     END IF;

         IF(b_flag) THEN

        PKG_MCRE0_LOG.SPO_MCRE0_LOG_EVENTO(p_rec.SEQ_FLUSSO,c_nome,'OK','DATI INSERITI CORRETTAMENTE');

        END IF;

      --close v_cur;

           /*  BEGIN

                SELECT VALORE_COSTANTE INTO v_mesi_svecchiamento
                FROM T_MCRE0_WRK_CONFIGURAZIONE
                WHERE NOME_COSTANTE = 'MESI_SVECCHIAMENTO_FILE_GUIDA';

            EXCEPTION

                WHEN OTHERS THEN

                    v_mesi_svecchiamento := 0;

                    PKG_MCRE0_LOG.SPO_MCRE0_LOG_EVENTO(p_rec.SEQ_FLUSSO,c_nome,'ATTENZIONE','Svecchiamento non eseguibile per problemi di rilevamento della costante ''MESI_SVECCHIAMENTO_FILE_GUIDA'' nella tabella ''T_MCRE0_WRK_CONFIGURAZIONE''');

            END;

            IF(v_mesi_svecchiamento > 0) THEN

             b_flag := svecchiamento_p31(p_rec.SEQ_FLUSSO,p_rec.TAB_TRG,p_rec.PERIODO,v_mesi_svecchiamento);

            END IF;*/



        RETURN b_flag;


            EXCEPTION


        WHEN OTHERS THEN

        DBMS_OUTPUT.PUT_LINE('ERRORE IN FND_MCRE0_alimenta_FILE_GUIDA');
         DBMS_OUTPUT.PUT_LINE(SUBSTR(SQLERRM, 1, 255));
            ROLLBACK;

           IF(v_cur%ISOPEN) THEN

                    CLOSE v_cur;

                     DBMS_OUTPUT.PUT_LINE('ERRORE IN FND_MCRE0_alimenta_FILE_GUIDA - CLOSE CURSOR');

                END IF;

            PKG_MCRE0_LOG.SPO_MCRE0_log_evento_no_commit(p_rec.SEQ_FLUSSO,p_rec.TAB_TRG,'ERRORE',SUBSTR(SQLERRM, 1, 255));

            RETURN FALSE;

     END FND_MCRE0_alimenta_FILE_GUIDA;


FUNCTION FND_MCRE0_alim_FILE_GUIDA_AP(p_rec IN f_slave_par_type) RETURN BOOLEAN IS

  v_partition varchar2(20);
  v_sql varchar2(5000);

   begin


    v_partition := 'CCP_P'|| to_char(p_rec.PERIODO, 'yyyymmdd');
    v_sql :=  'BEGIN MERGE
               INTO  T_MCRE0_APP_FILE_GUIDA24 trg
               USING T_MCRE0_ST_FILE_GUIDA  PARTITION(' || v_partition || ') src
               ON  ( src.COD_ABI_CARTOLARIZZATO = trg.COD_ABI_CARTOLARIZZATO
                     and src.COD_NDG = trg.COD_NDG)
            WHEN MATCHED
            THEN
              UPDATE
              SET
                trg.COD_ABI_ISTITUTO=src.COD_ABI_ISTITUTO,
                trg.FLG_RIPORTAFOGLIATO= ''0'',
                trg.COD_SNDG=src.COD_SNDG,
                trg.DTA_UPD= sysdate,
                trg.COD_OPERATORE_INS_UPD = NULL,
                trg.ID_DPER = src.ID_DPER,
                trg.FLG_ACTIVE=''1''
           WHEN NOT MATCHED
           THEN
              INSERT (
                        trg.COD_ABI_ISTITUTO,
                        trg.FLG_RIPORTAFOGLIATO,
                        trg.COD_ABI_CARTOLARIZZATO,
                        trg.COD_NDG,
                        trg.COD_SNDG,
                        trg.DTA_INS,
                        trg.DTA_UPD,
                        trg.COD_OPERATORE_INS_UPD,
                        trg.ID_DPER,
                        trg.FLG_ACTIVE )
              VALUES (
                        src.COD_ABI_ISTITUTO,
                        ''0'',
                        src.COD_ABI_CARTOLARIZZATO,
                        src.COD_NDG,
                        src.COD_SNDG,
                        sysdate,
                        sysdate,
                        NULL,
                        src.ID_DPER,
                        ''1'' );
            commit;
            END;';
    
--          v_sql :=  'BEGIN MERGE

--               INTO  T_MCRE0_APP_FILE_GUIDA trg

--               USING T_MCRE0_ST_FILE_GUIDA  PARTITION(' || v_partition || ') src

--               ON  ( src.COD_ABI_CARTOLARIZZATO = trg.COD_ABI_CARTOLARIZZATO
--                     and src.COD_NDG = trg.COD_NDG)

--            WHEN MATCHED

--            THEN

--              UPDATE

--              SET

--                trg.COD_ABI_ISTITUTO=src.COD_ABI_ISTITUTO,
--                trg.FLG_RIPORTAFOGLIATO= ''0'',
--                trg.COD_SNDG=src.COD_SNDG,
--                trg.DTA_UPD= sysdate,
--                trg.COD_OPERATORE_INS_UPD = NULL,
--                trg.ID_DPER = src.ID_DPER


--           WHEN NOT MATCHED
--           THEN
--              INSERT (
--                        trg.COD_ABI_ISTITUTO,
--                        trg.FLG_RIPORTAFOGLIATO,
--                        trg.COD_ABI_CARTOLARIZZATO,
--                        trg.COD_NDG,
--                        trg.COD_SNDG,
--                        trg.DTA_INS,
--                        trg.DTA_UPD,
--                        trg.COD_OPERATORE_INS_UPD,
--                        trg.ID_DPER )

--              VALUES (
--                        src.COD_ABI_ISTITUTO,
--                        ''0'',
--                        src.COD_ABI_CARTOLARIZZATO,
--                        src.COD_NDG,
--                        src.COD_SNDG,
--                        sysdate,
--                        sysdate,
--                        NULL,
--                        src.ID_DPER );

--            commit;
--            END;';


            DBMS_OUTPUT.PUT_LINE(v_sql);


              execute immediate v_sql;

              RETURN TRUE;


                EXCEPTION WHEN OTHERS THEN

                  DBMS_OUTPUT.PUT_LINE(SUBSTR(SQLERRM, 1, 255));



                end FND_MCRE0_alim_FILE_GUIDA_AP;


FUNCTION FND_MCRE0_alimenta_GRUPPO_ECO(p_rec IN f_slave_par_type) RETURN BOOLEAN IS

        c_nome CONSTANT VARCHAR2(100) := c_package || '.FND_MCRE0_alimenta_GRUPPO_ECO';
        b_flag BOOLEAN;
        v_cur PKG_MCRE0_UTILS.cur_abi_type;
        v_count NUMBER;



   BEGIN

     DBMS_OUTPUT.PUT_LINE('INIZIALIZZO CURSORE X SOTTOPARTIZIONE COD_ABI');

     open v_cur for select distinct COD_ABI
     from T_MCRE0_APP_ISTITUTI;

       DBMS_OUTPUT.PUT_LINE('CURSORE X SOTTOPARTIZIONE COD_ABI INIZIALIZZATO');

     b_flag := PKG_MCRE0_PARTIZIONI.FND_MCRE0_add_partition(p_rec.SEQ_FLUSSO,p_rec.TAB_TRG,p_rec.PERIODO,v_cur);


     IF(b_flag) THEN

             insert
             when
             NUM_RECS = 1
             AND TRIM(TO_CHAR(ID_DPER)) IS NOT NULL
             AND TRIM(TO_CHAR(COD_SNDG)) IS NOT NULL


            then
            INTO T_MCRE0_ST_GRUPPO_ECONOMICO
            (ID_DPER    ,
            COD_SNDG    ,
            COD_GRUPPO_ECONOMICO    ,
            FLG_CAPOGRUPPO
            )

             values (
                ID_DPER    ,
                COD_SNDG    ,
                COD_GRUPPO_ECONOMICO    ,
                FLG_CAPOGRUPPO    )


             when
             NUM_RECS > 1
             or TRIM(TO_CHAR(ID_DPER)) IS NULL
             or TRIM(TO_CHAR(COD_SNDG)) IS NULL

             then
             INTO T_MCRE0_SC_VINCOLI_GRUPPO_ECO (
                ID_SEQ    ,
                ID_DPER    ,
                COD_SNDG    ,
                COD_GRUPPO_ECONOMICO    ,
                FLG_CAPOGRUPPO    ,
                PK_NULL
                )
             VALUES (
                p_rec.SEQ_FLUSSO ,
                ID_DPER,
                COD_SNDG,
                COD_GRUPPO_ECONOMICO,
                FLG_CAPOGRUPPO,
                '1')


             select * from
        (
            SELECT
                COUNT(1) OVER(PARTITION BY  ID_DPER, COD_SNDG  ) NUM_RECS,
                ID_DPER,
                COD_SNDG,
                COD_GRUPPO_ECONOMICO,
                FLG_CAPOGRUPPO

            FROM
              T_MCRE0_FL_GRUPPO_ECONOMICO
        ) tmp;
        COMMIT;


          SELECT COUNT(*)
          INTO v_count
          FROM T_MCRE0_SC_VINCOLI_GRUPPO_ECO SC
          WHERE SC.ID_SEQ = p_rec.SEQ_FLUSSO;


          UPDATE T_MCRE0_WRK_ACQUISIZIONE
          SET SCARTI_VINCOLI = v_count
          WHERE ID_FLUSSO = p_rec.SEQ_FLUSSO;
          commit;

        b_flag := TRUE;

     END IF;

         IF(b_flag) THEN

        PKG_MCRE0_LOG.SPO_MCRE0_LOG_EVENTO(p_rec.SEQ_FLUSSO,c_nome,'OK','DATI INSERITI CORRETTAMENTE');

        END IF;

      --close v_cur;

           /*  BEGIN

                SELECT VALORE_COSTANTE INTO v_mesi_svecchiamento
                FROM T_MCRE0_WRK_CONFIGURAZIONE
                WHERE NOME_COSTANTE = 'MESI_SVECCHIAMENTO_GRUPPO_ECO';

            EXCEPTION

                WHEN OTHERS THEN

                    v_mesi_svecchiamento := 0;

                    PKG_MCRE0_LOG.SPO_MCRE0_LOG_EVENTO(p_rec.SEQ_FLUSSO,c_nome,'ATTENZIONE','Svecchiamento non eseguibile per problemi di rilevamento della costante ''MESI_SVECCHIAMENTO_GRUPPO_ECO'' nella tabella ''T_MCRE0_WRK_CONFIGURAZIONE''');

            END;

            IF(v_mesi_svecchiamento > 0) THEN

             b_flag := svecchiamento_p31(p_rec.SEQ_FLUSSO,p_rec.TAB_TRG,p_rec.PERIODO,v_mesi_svecchiamento);

            END IF;*/



        RETURN b_flag;


            EXCEPTION


        WHEN OTHERS THEN

        DBMS_OUTPUT.PUT_LINE('ERRORE IN FND_MCRE0_alimenta_GRUPPO_ECO');
         DBMS_OUTPUT.PUT_LINE(SUBSTR(SQLERRM, 1, 255));
            ROLLBACK;

           IF(v_cur%ISOPEN) THEN

                    CLOSE v_cur;

                     DBMS_OUTPUT.PUT_LINE('ERRORE IN FND_MCRE0_alimenta_GRUPPO_ECO - CLOSE CURSOR');

                END IF;

            PKG_MCRE0_LOG.SPO_MCRE0_log_evento_no_commit(p_rec.SEQ_FLUSSO,p_rec.TAB_TRG,'ERRORE',SUBSTR(SQLERRM, 1, 255));

            RETURN FALSE;

     END FND_MCRE0_alimenta_GRUPPO_ECO;


FUNCTION FND_MCRE0_alim_GRUPPO_ECO_AP(p_rec IN f_slave_par_type) RETURN BOOLEAN IS

  v_partition varchar2(20);
  v_sql varchar2(5000);

   begin


   v_partition := 'CCP_P'|| to_char(p_rec.PERIODO, 'yyyymmdd');

          v_sql :=  'BEGIN MERGE

               INTO  T_MCRE0_APP_GRUPPO_ECONOMICO24 trg

               USING T_MCRE0_ST_GRUPPO_ECONOMICO  PARTITION(' || v_partition || ') src

               ON  ( src.COD_SNDG = trg.COD_SNDG)

            WHEN MATCHED

            THEN

              UPDATE

              SET

                trg.COD_GRUPPO_ECONOMICO = src.COD_GRUPPO_ECONOMICO    ,
                trg.FLG_CAPOGRUPPO = src.FLG_CAPOGRUPPO    ,
                trg.DTA_UPD= sysdate,
                trg.COD_OPERATORE_INS_UPD = NULL,
                trg.ID_DPER = src.ID_DPER


           WHEN NOT MATCHED
           THEN
              INSERT (
                        trg.COD_SNDG,
                        trg.COD_GRUPPO_ECONOMICO,
                        trg.FLG_CAPOGRUPPO,
                        DTA_INS    ,
                        DTA_UPD    ,
                        COD_OPERATORE_INS_UPD    ,
                        trg.ID_DPER )

              VALUES (
                        src.COD_SNDG,
                        src.COD_GRUPPO_ECONOMICO,
                        src.FLG_CAPOGRUPPO,
                        SYSDATE,
                        SYSDATE,
                        NULL,
                        src.ID_DPER );

            commit;
            END;';


            DBMS_OUTPUT.PUT_LINE(v_sql);


              execute immediate v_sql;

              RETURN TRUE;


                EXCEPTION WHEN OTHERS THEN

                  DBMS_OUTPUT.PUT_LINE(SUBSTR(SQLERRM, 1, 255));



                end FND_MCRE0_alim_GRUPPO_ECO_AP;

FUNCTION FND_MCRE0_alimenta_LEGAME(p_rec IN f_slave_par_type) RETURN BOOLEAN IS

        c_nome CONSTANT VARCHAR2(100) := c_package || '.FND_MCRE0_alimenta_LEGAME';
        b_flag BOOLEAN;
        v_cur PKG_MCRE0_UTILS.cur_abi_type;
        v_count NUMBER;



   BEGIN

     DBMS_OUTPUT.PUT_LINE('INIZIALIZZO CURSORE X SOTTOPARTIZIONE COD_ABI');

     open v_cur for select distinct COD_ABI
     from T_MCRE0_APP_ISTITUTI;

       DBMS_OUTPUT.PUT_LINE('CURSORE X SOTTOPARTIZIONE COD_ABI INIZIALIZZATO');

     b_flag := PKG_MCRE0_PARTIZIONI.FND_MCRE0_add_partition(p_rec.SEQ_FLUSSO,p_rec.TAB_TRG,p_rec.PERIODO,v_cur);


     IF(b_flag) THEN


                  insert
             when
             NUM_RECS = 1
             AND TRIM(TO_CHAR(ID_DPER)) IS NOT NULL
             AND TRIM(TO_CHAR(COD_SNDG)) IS NOT NULL
             AND TRIM(TO_CHAR(COD_SNDG_LEGAME)) IS NOT NULL
             AND TRIM(TO_CHAR(COD_LEGAME)) IS NOT NULL


            then

            INTO T_MCRE0_ST_LEGAME (
            ID_DPER    ,
            COD_SNDG    ,
            COD_SNDG_LEGAME    ,
            COD_LEGAME
            )
            VALUES (
            ID_DPER    ,
            COD_SNDG    ,
            COD_SNDG_LEGAME    ,
            COD_LEGAME    )

             when
             NUM_RECS > 1
             OR TRIM(TO_CHAR(ID_DPER)) IS NULL
             OR TRIM(TO_CHAR(COD_SNDG)) IS NULL
             OR TRIM(TO_CHAR(COD_SNDG_LEGAME)) IS NULL
             OR TRIM(TO_CHAR(COD_LEGAME)) IS NULL


             then
             INTO T_MCRE0_SC_VINCOLI_LEGAME (
                ID_SEQ    ,
                ID_DPER    ,
                COD_SNDG    ,
                COD_SNDG_LEGAME    ,
                COD_LEGAME    ,
                PK_NULL
                )

                VALUES (
                p_rec.SEQ_FLUSSO,
                ID_DPER    ,
                COD_SNDG    ,
                COD_SNDG_LEGAME    ,
                COD_LEGAME    ,
                '1')


             select * from
        (
            SELECT
                COUNT(1) OVER(PARTITION BY  ID_DPER, COD_SNDG, COD_SNDG_LEGAME, COD_LEGAME) NUM_RECS,
                ID_DPER    ,
                COD_SNDG    ,
                COD_SNDG_LEGAME    ,
                COD_LEGAME

            FROM
              T_MCRE0_FL_LEGAME
        ) tmp;
        COMMIT;


          SELECT COUNT(*)
          INTO v_count
          FROM T_MCRE0_SC_VINCOLI_LEGAME SC
          WHERE SC.ID_SEQ = p_rec.SEQ_FLUSSO;


          UPDATE T_MCRE0_WRK_ACQUISIZIONE
          SET SCARTI_VINCOLI = v_count
          WHERE ID_FLUSSO = p_rec.SEQ_FLUSSO;
          commit;

        b_flag := TRUE;


     END IF;

         IF(b_flag) THEN

        PKG_MCRE0_LOG.SPO_MCRE0_LOG_EVENTO(p_rec.SEQ_FLUSSO,c_nome,'OK','DATI INSERITI CORRETTAMENTE');

        END IF;

      --close v_cur;

           /*  BEGIN

                SELECT VALORE_COSTANTE INTO v_mesi_svecchiamento
                FROM T_MCRE0_WRK_CONFIGURAZIONE
                WHERE NOME_COSTANTE = 'MESI_SVECCHIAMENTO_LEGAME';

            EXCEPTION

                WHEN OTHERS THEN

                    v_mesi_svecchiamento := 0;

                    PKG_MCRE0_LOG.SPO_MCRE0_LOG_EVENTO(p_rec.SEQ_FLUSSO,c_nome,'ATTENZIONE','Svecchiamento non eseguibile per problemi di rilevamento della costante ''MESI_SVECCHIAMENTO_LEGAME'' nella tabella ''T_MCRE0_WRK_CONFIGURAZIONE''');

            END;

            IF(v_mesi_svecchiamento > 0) THEN

             b_flag := svecchiamento_p31(p_rec.SEQ_FLUSSO,p_rec.TAB_TRG,p_rec.PERIODO,v_mesi_svecchiamento);

            END IF;*/


        RETURN b_flag;


            EXCEPTION


        WHEN OTHERS THEN

        DBMS_OUTPUT.PUT_LINE('ERRORE IN FND_MCRE0_alimenta_LEGAME');
         DBMS_OUTPUT.PUT_LINE(SUBSTR(SQLERRM, 1, 255));
            ROLLBACK;

           IF(v_cur%ISOPEN) THEN

                    CLOSE v_cur;

                     DBMS_OUTPUT.PUT_LINE('ERRORE IN FND_MCRE0_alimenta_LEGAME - CLOSE CURSOR');

                END IF;

            PKG_MCRE0_LOG.SPO_MCRE0_log_evento_no_commit(p_rec.SEQ_FLUSSO,p_rec.TAB_TRG,'ERRORE',SUBSTR(SQLERRM, 1, 255));

            RETURN FALSE;

     END FND_MCRE0_alimenta_LEGAME;


FUNCTION FND_MCRE0_alimenta_LEGAME_AP(p_rec IN f_slave_par_type) RETURN BOOLEAN IS

  v_partition varchar2(20);
  v_sql varchar2(5000);


   begin


   v_partition := 'CCP_P'|| to_char(p_rec.PERIODO, 'yyyymmdd');

          v_sql :=  'BEGIN MERGE

               INTO  T_MCRE0_APP_LEGAME24 trg

               USING T_MCRE0_ST_LEGAME  PARTITION(' || v_partition || ') src

               ON  (src.COD_SNDG    = trg.COD_SNDG
                and src.COD_SNDG_LEGAME    = trg.COD_SNDG_LEGAME
                and src.COD_LEGAME = trg.COD_LEGAME)

            WHEN MATCHED

            THEN

              UPDATE

              SET
                trg.DTA_UPD= sysdate,
                trg.COD_OPERATORE_INS_UPD = NULL,
                trg.ID_DPER = src.ID_DPER


           WHEN NOT MATCHED
           THEN
              INSERT (
                        trg.COD_SNDG    ,
                        trg.COD_SNDG_LEGAME    ,
                        trg.COD_LEGAME    ,
                        trg.DTA_INS    ,
                        trg.DTA_UPD    ,
                        trg.COD_OPERATORE_INS_UPD    ,
                        trg.ID_DPER

                        )

              VALUES (
                        src.COD_SNDG,
                        src.COD_SNDG_LEGAME,
                        src.COD_LEGAME,
                        sysdate,
                        sysdate,
                        NULL,
                        src.ID_DPER );

            commit;
            END;';


            DBMS_OUTPUT.PUT_LINE(v_sql);


              execute immediate v_sql;

              RETURN TRUE;


                EXCEPTION WHEN OTHERS THEN

                  DBMS_OUTPUT.PUT_LINE(SUBSTR(SQLERRM, 1, 255));



                end FND_MCRE0_alimenta_LEGAME_AP;


FUNCTION FND_MCRE0_alimenta_MOPLE(p_rec IN f_slave_par_type) RETURN BOOLEAN IS

        c_nome CONSTANT VARCHAR2(100) := c_package || '.FND_MCRE0_alimenta_MOPLE';
        b_flag BOOLEAN;
        v_seq number;
        v_period number;
        v_cur PKG_MCRE0_UTILS.cur_abi_type;
        v_count NUMBER;




   BEGIN

      v_seq := p_rec.SEQ_FLUSSO;
      v_period := to_number(TO_CHAR(p_rec.PERIODO, 'yyyymmdd'));


     DBMS_OUTPUT.PUT_LINE('INIZIALIZZO CURSORE X SOTTOPARTIZIONE COD_ABI');

     open v_cur for select distinct COD_ABI
     from T_MCRE0_APP_ISTITUTI;

       DBMS_OUTPUT.PUT_LINE('CURSORE X SOTTOPARTIZIONE COD_ABI INIZIALIZZATO');

     b_flag := PKG_MCRE0_PARTIZIONI.FND_MCRE0_add_partition(p_rec.SEQ_FLUSSO,p_rec.TAB_TRG,p_rec.PERIODO,v_cur);


     IF(b_flag) THEN

             insert
             when NUM_RECS = 1
             and ID_DPER is not null
             and COD_ABI_CARTOLARIZZATO is not null
             and COD_NDG is not null
             then
                into T_MCRE0_ST_MOPLE (
                                        ID_DPER    ,
                                        COD_ABI_ISTITUTO    ,
                                        COD_ABI_CARTOLARIZZATO    ,
                                        COD_NDG    ,
                                        COD_SNDG    ,
                                        DTA_INTERCETTAMENTO    ,
                                        COD_FILIALE    ,
                                        COD_STRUTTURA_COMPETENTE    ,
                                        COD_TIPO_INGRESSO    ,
                                        COD_CAUSALE_INGRESSO    ,
                                        COD_PERCORSO    ,
                                        COD_PROCESSO    ,
                                        COD_STATO    ,
                                        DTA_DECORRENZA_STATO    ,
                                        DTA_SCADENZA_STATO    ,
                                        COD_STATO_PRECEDENTE    ,
                                        ID_STATO_POSIZIONE    ,
                                        COD_CLIENTE_ESTESO    ,
                                        ID_CLIENTE_ESTESO    ,
                                        DESC_ANAG_GESTORE_MKT    ,
                                        COD_GESTORE_MKT    ,
                                        COD_TIPO_PORTAFOGLIO    ,
                                        FLG_GESTIONE_ESTERNA    ,
                                        VAL_PERC_DECURTAZIONE,
                                        ID_TRANSIZIONE,
                                        DTA_PROCESSO,
                                        COD_MATR_RISCHIO    ,
                                        COD_UO_RISCHIO    ,
                                        COD_DISP_RISCHIO
                                        )

                              values (  ID_DPER    ,
                                        COD_ABI_ISTITUTO    ,
                                        COD_ABI_CARTOLARIZZATO    ,
                                        COD_NDG    ,
                                        COD_SNDG    ,
                                        DTA_INTERCETTAMENTO    ,
                                        COD_FILIALE    ,
                                        COD_STRUTTURA_COMPETENTE    ,
                                        COD_TIPO_INGRESSO    ,
                                        COD_CAUSALE_INGRESSO    ,
                                        COD_PERCORSO    ,
                                        COD_PROCESSO    ,
                                        COD_STATO    ,
                                        DTA_DECORRENZA_STATO    ,
                                        DTA_SCADENZA_STATO    ,
                                        COD_STATO_PRECEDENTE    ,
                                        ID_STATO_POSIZIONE    ,
                                        COD_CLIENTE_ESTESO    ,
                                        ID_CLIENTE_ESTESO    ,
                                        DESC_ANAG_GESTORE_MKT    ,
                                        COD_GESTORE_MKT    ,
                                        COD_TIPO_PORTAFOGLIO    ,
                                        FLG_GESTIONE_ESTERNA    ,
                                        VAL_PERC_DECURTAZIONE,
                                        ID_TRANSIZIONE,
                                        DTA_PROCESSO,
                                        COD_MATR_RISCHIO    ,
                                        COD_UO_RISCHIO    ,
                                        COD_DISP_RISCHIO
                                        )
             when NUM_RECS > 1
             or ID_DPER is null
             or COD_ABI_CARTOLARIZZATO is null
             or COD_NDG is null

             then
                into T_MCRE0_SC_VINCOLI_MOPLE ( ID_SEQ    ,
                                                ID_DPER    ,
                                                COD_ABI_ISTITUTO    ,
                                                COD_ABI_CARTOLARIZZATO    ,
                                                COD_NDG    ,
                                                COD_SNDG    ,
                                                DTA_INTERCETTAMENTO    ,
                                                COD_FILIALE    ,
                                                COD_STRUTTURA_COMPETENTE    ,
                                                COD_TIPO_INGRESSO    ,
                                                COD_CAUSALE_INGRESSO    ,
                                                COD_PERCORSO    ,
                                                COD_PROCESSO    ,
                                                COD_STATO    ,
                                                DTA_DECORRENZA_STATO    ,
                                                DTA_SCADENZA_STATO    ,
                                                COD_STATO_PRECEDENTE    ,
                                                ID_STATO_POSIZIONE    ,
                                                COD_CLIENTE_ESTESO    ,
                                                ID_CLIENTE_ESTESO    ,
                                                DESC_ANAG_GESTORE_MKT    ,
                                                COD_GESTORE_MKT    ,
                                                COD_TIPO_PORTAFOGLIO    ,
                                                FLG_GESTIONE_ESTERNA    ,
                                                VAL_PERC_DECURTAZIONE    ,
                                                ID_TRANSIZIONE,
                                                DTA_PROCESSO,
                                                COD_MATR_RISCHIO    ,
                                                COD_UO_RISCHIO    ,
                                                COD_DISP_RISCHIO
                                                )


                                      values (  v_seq,
                                                v_period,
                                                COD_ABI_ISTITUTO    ,
                                                COD_ABI_CARTOLARIZZATO    ,
                                                COD_NDG    ,
                                                COD_SNDG    ,
                                                DTA_INTERCETTAMENTO    ,
                                                COD_FILIALE    ,
                                                COD_STRUTTURA_COMPETENTE    ,
                                                COD_TIPO_INGRESSO    ,
                                                COD_CAUSALE_INGRESSO    ,
                                                COD_PERCORSO    ,
                                                COD_PROCESSO    ,
                                                COD_STATO    ,
                                                DTA_DECORRENZA_STATO    ,
                                                DTA_SCADENZA_STATO    ,
                                                COD_STATO_PRECEDENTE    ,
                                                ID_STATO_POSIZIONE    ,
                                                COD_CLIENTE_ESTESO    ,
                                                ID_CLIENTE_ESTESO    ,
                                                DESC_ANAG_GESTORE_MKT    ,
                                                COD_GESTORE_MKT    ,
                                                COD_TIPO_PORTAFOGLIO    ,
                                                FLG_GESTIONE_ESTERNA    ,
                                                VAL_PERC_DECURTAZIONE,
                                                ID_TRANSIZIONE,
                                                DTA_PROCESSO,
                                                COD_MATR_RISCHIO    ,
                                                COD_UO_RISCHIO    ,
                                                COD_DISP_RISCHIO
                                                )


             select * from
        (
            SELECT
              COUNT(1) OVER(PARTITION BY fl.ID_DPER, fl.COD_ABI_CARTOLARIZZATO, fl.COD_NDG) NUM_RECS,
                ID_DPER    ,
                COD_ABI_ISTITUTO    ,
                COD_ABI_CARTOLARIZZATO    ,
                COD_NDG    ,
                COD_SNDG    ,
                DTA_INTERCETTAMENTO    ,
                COD_FILIALE    ,
                COD_STRUTTURA_COMPETENTE    ,
                COD_TIPO_INGRESSO    ,
                COD_CAUSALE_INGRESSO    ,
                COD_PERCORSO    ,
                COD_PROCESSO    ,
                COD_STATO    ,
                DTA_DECORRENZA_STATO    ,
                DTA_SCADENZA_STATO    ,
                COD_STATO_PRECEDENTE    ,
                ID_STATO_POSIZIONE    ,
                COD_CLIENTE_ESTESO    ,
                ID_CLIENTE_ESTESO    ,
                DESC_ANAG_GESTORE_MKT    ,
                COD_GESTORE_MKT    ,
                COD_TIPO_PORTAFOGLIO    ,
                FLG_GESTIONE_ESTERNA    ,
                VAL_PERC_DECURTAZIONE    ,
                ID_TRANSIZIONE,
                DTA_PROCESSO,
                COD_MATR_RISCHIO    ,
                COD_UO_RISCHIO    ,
                COD_DISP_RISCHIO


            FROM
              T_MCRE0_FL_MOPLE fl
        ) tmp;
        COMMIT;

                  SELECT COUNT(*)
          INTO v_count
          FROM T_MCRE0_SC_VINCOLI_MOPLE SC
          WHERE SC.ID_SEQ = p_rec.SEQ_FLUSSO;


          UPDATE T_MCRE0_WRK_ACQUISIZIONE
          SET SCARTI_VINCOLI = v_count
          WHERE ID_FLUSSO = p_rec.SEQ_FLUSSO;
          commit;

         b_flag := TRUE;

     END IF;




         IF(b_flag) THEN

        PKG_MCRE0_LOG.SPO_MCRE0_LOG_EVENTO(p_rec.SEQ_FLUSSO,c_nome,'OK','DATI INSERITI CORRETTAMENTE');

        END IF;



        RETURN b_flag;


            EXCEPTION


        WHEN OTHERS THEN

        DBMS_OUTPUT.PUT_LINE('ERRORE IN FND_MCRE0_alimenta_MOPLE');
         DBMS_OUTPUT.PUT_LINE(SUBSTR(SQLERRM, 1, 255));
            ROLLBACK;

           IF(v_cur%ISOPEN) THEN

                    CLOSE v_cur;

                     DBMS_OUTPUT.PUT_LINE('ERRORE IN FND_MCRE0_alimenta_MOPLE - CLOSE CURSOR');

                END IF;

            PKG_MCRE0_LOG.SPO_MCRE0_log_evento_no_commit(p_rec.SEQ_FLUSSO,p_rec.TAB_TRG,'ERRORE',SUBSTR(SQLERRM, 1, 255));

            RETURN FALSE;

     END FND_MCRE0_alimenta_MOPLE;




FUNCTION FND_MCRE0_alimenta_MOPLE_AP(p_rec IN f_slave_par_type) RETURN BOOLEAN IS

  v_partition varchar2(20);
  v_sql varchar2(7000);


   begin


   v_partition := 'CCP_P'|| to_char(p_rec.PERIODO, 'yyyymmdd');

          v_sql :=  'BEGIN MERGE
               INTO  T_MCRE0_APP_MOPLE24 trg
               USING (  select      a.* ,
                                    CASE
                                         WHEN a.cod_stato = ''SO''
                                            THEN DECODE (b.cod_livello,
                                                         ''PL'', ''N'',
                                                         ''IP'', ''N'',
                                                         ''IC'', ''N'',
                                                         ''RC'', ''N'',
                                                         nvl(c.FLG_OUTSOURCING, ''N'')
                                                        )
                                         ELSE nvl(c.FLG_OUTSOURCING, ''N'')
                                    END flg_outsourcing
                        FROM        T_MCRE0_ST_MOPLE PARTITION(' || v_partition || ') a,
                                    T_MCRE0_APP_STRUTTURA_ORG b,
                                    T_MCRE0_APP_ISTITUTI c
                        where       a.COD_ABI_CARTOLARIZZATO = b.COD_ABI_ISTITUTO(+)
                        and         a.COD_STRUTTURA_COMPETENTE = b.COD_STRUTTURA_COMPETENTE(+)
                        and         c.COD_ABI = a.COD_ABI_CARTOLARIZZATO ) src
               ON  (src.COD_ABI_CARTOLARIZZATO = trg.COD_ABI_CARTOLARIZZATO
                    and src.COD_NDG = trg.COD_NDG)
            WHEN MATCHED
            THEN
              UPDATE
              SET
                trg.COD_ABI_ISTITUTO=src.COD_ABI_ISTITUTO,
                trg.COD_SNDG=src.COD_SNDG,
                trg.DTA_INTERCETTAMENTO=src.DTA_INTERCETTAMENTO,
                trg.COD_FILIALE=src.COD_FILIALE,
                trg.COD_STRUTTURA_COMPETENTE=src.COD_STRUTTURA_COMPETENTE,
                trg.COD_TIPO_INGRESSO=src.COD_TIPO_INGRESSO,
                trg.COD_CAUSALE_INGRESSO=src.COD_CAUSALE_INGRESSO,
                trg.COD_PERCORSO=src.COD_PERCORSO,
                trg.COD_PROCESSO=src.COD_PROCESSO,
                trg.COD_STATO=src.COD_STATO,
                trg.DTA_DECORRENZA_STATO=src.DTA_DECORRENZA_STATO,
                trg.DTA_SCADENZA_STATO=src.DTA_SCADENZA_STATO,
                trg.COD_STATO_PRECEDENTE=src.COD_STATO_PRECEDENTE,
                trg.ID_STATO_POSIZIONE=src.ID_STATO_POSIZIONE,
                trg.COD_CLIENTE_ESTESO=src.COD_CLIENTE_ESTESO,
                trg.ID_CLIENTE_ESTESO=src.ID_CLIENTE_ESTESO,
                trg.DESC_ANAG_GESTORE_MKT=src.DESC_ANAG_GESTORE_MKT,
                trg.COD_GESTORE_MKT=src.COD_GESTORE_MKT,
                trg.COD_TIPO_PORTAFOGLIO=src.COD_TIPO_PORTAFOGLIO,
                trg.FLG_GESTIONE_ESTERNA=src.FLG_GESTIONE_ESTERNA,
                trg.VAL_PERC_DECURTAZIONE=src.VAL_PERC_DECURTAZIONE,
                trg.DTA_UPD= sysdate,
                trg.COD_OPERATORE_INS_UPD = NULL,
                trg.ID_DPER = src.ID_DPER,
                trg.ID_TRANSIZIONE = src.ID_TRANSIZIONE,
                trg.DTA_PROCESSO= src.DTA_PROCESSO,
                -- NUOVO CAMPO
                trg.FLG_OUTSOURCING=src.FLG_OUTSOURCING,
                -- NUOVO CAMPI
                trg.COD_MATR_RISCHIO=src.COD_MATR_RISCHIO    ,
                trg.COD_UO_RISCHIO=src.COD_UO_RISCHIO    ,
                trg.COD_DISP_RISCHIO=src.COD_DISP_RISCHIO
           WHEN NOT MATCHED
           THEN
              INSERT (
                        trg.COD_ABI_ISTITUTO,
                        trg.COD_ABI_CARTOLARIZZATO,
                        trg.COD_NDG,
                        trg.COD_SNDG,
                        trg.DTA_INTERCETTAMENTO,
                        trg.COD_FILIALE,
                        trg.COD_STRUTTURA_COMPETENTE,
                        trg.COD_TIPO_INGRESSO,
                        trg.COD_CAUSALE_INGRESSO,
                        trg.COD_PERCORSO,
                        trg.COD_PROCESSO,
                        trg.COD_STATO,
                        trg.DTA_DECORRENZA_STATO,
                        trg.DTA_SCADENZA_STATO,
                        trg.COD_STATO_PRECEDENTE,
                        trg.ID_STATO_POSIZIONE,
                        trg.COD_CLIENTE_ESTESO,
                        trg.ID_CLIENTE_ESTESO,
                        trg.DESC_ANAG_GESTORE_MKT,
                        trg.COD_GESTORE_MKT,
                        trg.COD_TIPO_PORTAFOGLIO,
                        trg.FLG_GESTIONE_ESTERNA,
                        trg.VAL_PERC_DECURTAZIONE,
                        trg.DTA_INS    ,
                        trg.DTA_UPD    ,
                        trg.COD_OPERATORE_INS_UPD    ,
                        trg.ID_DPER    ,
                        trg.ID_TRANSIZIONE,
                        trg.DTA_PROCESSO,
                        trg.FLG_OUTSOURCING,
                        trg.COD_MATR_RISCHIO,
                        trg.COD_UO_RISCHIO    ,
                        trg.COD_DISP_RISCHIO

                        )
              VALUES (
                        src.COD_ABI_ISTITUTO,
                        src.COD_ABI_CARTOLARIZZATO,
                        src.COD_NDG,
                        src.COD_SNDG,
                        src.DTA_INTERCETTAMENTO,
                        src.COD_FILIALE,
                        src.COD_STRUTTURA_COMPETENTE,
                        src.COD_TIPO_INGRESSO,
                        src.COD_CAUSALE_INGRESSO,
                        src.COD_PERCORSO,
                        src.COD_PROCESSO,
                        src.COD_STATO,
                        src.DTA_DECORRENZA_STATO,
                        src.DTA_SCADENZA_STATO,
                        src.COD_STATO_PRECEDENTE,
                        src.ID_STATO_POSIZIONE,
                        src.COD_CLIENTE_ESTESO,
                        src.ID_CLIENTE_ESTESO,
                        src.DESC_ANAG_GESTORE_MKT,
                        src.COD_GESTORE_MKT,
                        src.COD_TIPO_PORTAFOGLIO,
                        src.FLG_GESTIONE_ESTERNA,
                        src.VAL_PERC_DECURTAZIONE,
                        sysdate,
                        sysdate,
                        NULL,
                        src.ID_DPER ,
                        src.ID_TRANSIZIONE,
                        src.DTA_PROCESSO,
                        src.FLG_OUTSOURCING,
                        src.COD_MATR_RISCHIO,
                        src.COD_UO_RISCHIO    ,
                        src.COD_DISP_RISCHIO
                        );

            commit;
            END;';


            DBMS_OUTPUT.PUT_LINE(v_sql);


              execute immediate v_sql;

              RETURN TRUE;


                EXCEPTION WHEN OTHERS THEN

                  DBMS_OUTPUT.PUT_LINE(SUBSTR(SQLERRM, 1, 255));



                end FND_MCRE0_alimenta_MOPLE_AP;


FUNCTION FND_MCRE0_alimenta_PCR_SC_SB(p_rec IN f_slave_par_type) RETURN BOOLEAN IS

        c_nome CONSTANT VARCHAR2(100) := c_package || '.FND_MCRE0_alimenta_PCR_SC_SB';
        b_flag BOOLEAN;
        v_cur PKG_MCRE0_UTILS.cur_abi_type;
        v_count NUMBER;



   BEGIN

     DBMS_OUTPUT.PUT_LINE('INIZIALIZZO CURSORE X SOTTOPARTIZIONE COD_ABI');

     open v_cur for select distinct COD_ABI
     from T_MCRE0_APP_ISTITUTI;

       DBMS_OUTPUT.PUT_LINE('CURSORE X SOTTOPARTIZIONE COD_ABI INIZIALIZZATO');

     b_flag := PKG_MCRE0_PARTIZIONI.FND_MCRE0_add_partition(p_rec.SEQ_FLUSSO,p_rec.TAB_TRG,p_rec.PERIODO,v_cur);


     IF(b_flag) THEN


                  insert
             when
             NUM_RECS = 1
             AND TRIM(TO_CHAR(ID_DPER)) IS NOT NULL
             AND TRIM(TO_CHAR(COD_ABI_ISTITUTO)) IS NOT NULL
             AND TRIM(TO_CHAR(COD_NDG)) IS NOT NULL
             AND TRIM(TO_CHAR(COD_FORMA_TECNICA)) IS NOT NULL


            then

            INTO T_MCRE0_ST_PCR_SC_SB (
                ID_DPER    ,
                COD_ABI_ISTITUTO    ,
                COD_NDG    ,
                COD_FORMA_TECNICA    ,
                VAL_IMP_UTI_CLI    ,
                VAL_IMP_ACC_CLI    ,
                DTA_RIFERIMENTO    ,
                COD_NATURA    ,
                VAL_IMP_GAR_TOT   ,
                DTA_SCADENZA_LDC
            )
            VALUES (
                ID_DPER,
                COD_ABI_ISTITUTO    ,
                COD_NDG    ,
                COD_FORMA_TECNICA    ,
                VAL_IMP_UTI_CLI    ,
                VAL_IMP_ACC_CLI    ,
                DTA_RIFERIMENTO    ,
                COD_NATURA    ,
                VAL_IMP_GAR_TOT  ,
                DTA_SCADENZA_LDC  )

             when
             NUM_RECS > 1
             OR TRIM(TO_CHAR(ID_DPER)) IS NULL
             OR TRIM(TO_CHAR(COD_ABI_ISTITUTO)) IS NULL
             OR TRIM(TO_CHAR(COD_NDG)) IS NULL
             OR TRIM(TO_CHAR(COD_FORMA_TECNICA)) IS NULL

             then
             INTO T_MCRE0_SC_VINCOLI_PCR_SC_SB (
                ID_SEQ    ,
                ID_DPER    ,
                COD_ABI_ISTITUTO    ,
                COD_NDG    ,
                COD_FORMA_TECNICA    ,
                VAL_IMP_UTI_CLI    ,
                VAL_IMP_ACC_CLI    ,
                DTA_RIFERIMENTO    ,
                COD_NATURA    ,
                VAL_IMP_GAR_TOT   ,
                DTA_SCADENZA_LDC

                )

                VALUES (
                p_rec.SEQ_FLUSSO,
                ID_DPER    ,
                COD_ABI_ISTITUTO    ,
                COD_NDG    ,
                COD_FORMA_TECNICA    ,
                VAL_IMP_UTI_CLI    ,
                VAL_IMP_ACC_CLI    ,
                DTA_RIFERIMENTO    ,
                COD_NATURA    ,
                VAL_IMP_GAR_TOT   ,
                DTA_SCADENZA_LDC )


             select * from
        (
            SELECT
                COUNT(1) OVER(PARTITION BY  ID_DPER, COD_ABI_ISTITUTO, COD_NDG, COD_FORMA_TECNICA) NUM_RECS,
                ID_DPER    ,
                COD_ABI_ISTITUTO    ,
                COD_NDG    ,
                COD_FORMA_TECNICA    ,
                VAL_IMP_UTI_CLI    ,
                VAL_IMP_ACC_CLI    ,
                DTA_RIFERIMENTO    ,
                COD_NATURA    ,
                VAL_IMP_GAR_TOT   ,
                DTA_SCADENZA_LDC
            FROM
              T_MCRE0_FL_PCR_SC_SB
        ) tmp;
        COMMIT;

                       SELECT COUNT(*)
          INTO v_count
          FROM T_MCRE0_SC_VINCOLI_PCR_SC_SB  SC
          WHERE SC.ID_SEQ = p_rec.SEQ_FLUSSO;


          UPDATE T_MCRE0_WRK_ACQUISIZIONE
          SET SCARTI_VINCOLI = v_count
          WHERE ID_FLUSSO = p_rec.SEQ_FLUSSO;
          commit;



        b_flag := TRUE;


     END IF;

         IF(b_flag) THEN

        PKG_MCRE0_LOG.SPO_MCRE0_LOG_EVENTO(p_rec.SEQ_FLUSSO,c_nome,'OK','DATI INSERITI CORRETTAMENTE');

        END IF;

      --close v_cur;

           /*  BEGIN

                SELECT VALORE_COSTANTE INTO v_mesi_svecchiamento
                FROM T_MCRE0_WRK_CONFIGURAZIONE
                WHERE NOME_COSTANTE = 'MESI_SVECCHIAMENTO_PCR_SC_SB';

            EXCEPTION

                WHEN OTHERS THEN

                    v_mesi_svecchiamento := 0;

                    PKG_MCRE0_LOG.SPO_MCRE0_LOG_EVENTO(p_rec.SEQ_FLUSSO,c_nome,'ATTENZIONE','Svecchiamento non eseguibile per problemi di rilevamento della costante ''MESI_SVECCHIAMENTO_PCR_SC_SB'' nella tabella ''T_MCRE0_WRK_CONFIGURAZIONE''');

            END;

            IF(v_mesi_svecchiamento > 0) THEN

             b_flag := svecchiamento_p31(p_rec.SEQ_FLUSSO,p_rec.TAB_TRG,p_rec.PERIODO,v_mesi_svecchiamento);

            END IF;*/


        RETURN b_flag;


            EXCEPTION


        WHEN OTHERS THEN

        DBMS_OUTPUT.PUT_LINE('ERRORE IN FND_MCRE0_alimenta_PCR_SC_SB');
         DBMS_OUTPUT.PUT_LINE(SUBSTR(SQLERRM, 1, 255));
            ROLLBACK;

           IF(v_cur%ISOPEN) THEN

                    CLOSE v_cur;

                     DBMS_OUTPUT.PUT_LINE('ERRORE IN FND_MCRE0_alimenta_PCR_SC_SB - CLOSE CURSOR');

                END IF;

            PKG_MCRE0_LOG.SPO_MCRE0_log_evento_no_commit(p_rec.SEQ_FLUSSO,p_rec.TAB_TRG,'ERRORE',SUBSTR(SQLERRM, 1, 255));

            RETURN FALSE;

     END FND_MCRE0_alimenta_PCR_SC_SB;






FUNCTION FND_MCRE0_alim_PCR_SC_SB_AP(p_rec IN f_slave_par_type) RETURN BOOLEAN IS

  v_partition varchar2(20);
  v_sql varchar2(5000);


   begin


   v_partition := 'CCP_P'|| to_char(p_rec.PERIODO, 'yyyymmdd');

          v_sql :=  'BEGIN MERGE

               INTO  T_MCRE0_APP_PCR_SC_SB24 trg

               USING T_MCRE0_ST_PCR_SC_SB  PARTITION(' || v_partition || ') src

               ON  (src.COD_ABI_ISTITUTO=trg.COD_ABI_ISTITUTO
                and src.COD_FORMA_TECNICA=trg.COD_FORMA_TECNICA
                and src.COD_NDG = trg.COD_NDG)

              WHEN MATCHED THEN
              UPDATE

              SET
                trg.VAL_IMP_UTI_CLI=src.VAL_IMP_UTI_CLI,
                trg.VAL_IMP_ACC_CLI=src.VAL_IMP_ACC_CLI,
                trg.DTA_RIFERIMENTO=src.DTA_RIFERIMENTO,
                trg.COD_NATURA=src.COD_NATURA,
                trg.VAL_IMP_GAR_TOT=src.VAL_IMP_GAR_TOT,
                trg.DTA_SCADENZA_LDC=src.DTA_SCADENZA_LDC,
                trg.DTA_UPD= sysdate,
                trg.COD_OPERATORE_INS_UPD = NULL,
                trg.ID_DPER = src.ID_DPER


           WHEN NOT MATCHED
           THEN
              INSERT (  trg.COD_ABI_ISTITUTO,
                        trg.COD_NDG,
                        trg.COD_FORMA_TECNICA,
                        trg.VAL_IMP_UTI_CLI,
                        trg.VAL_IMP_ACC_CLI,
                        trg.DTA_RIFERIMENTO,
                        trg.COD_NATURA,
                        trg.VAL_IMP_GAR_TOT,
                        trg.DTA_SCADENZA_LDC,
                        trg.DTA_INS    ,
                        trg.DTA_UPD    ,
                        trg.COD_OPERATORE_INS_UPD    ,
                        trg.ID_DPER     )

              VALUES (
                        src.COD_ABI_ISTITUTO,
                        src.COD_NDG,
                        src.COD_FORMA_TECNICA,
                        src.VAL_IMP_UTI_CLI,
                        src.VAL_IMP_ACC_CLI,
                        src.DTA_RIFERIMENTO,
                        src.COD_NATURA,
                        src.VAL_IMP_GAR_TOT,
                        src.DTA_SCADENZA_LDC,
                        sysdate,
                        sysdate,
                        NULL,
                        src.ID_DPER );

            commit;
            END;';


            DBMS_OUTPUT.PUT_LINE(v_sql);


              execute immediate v_sql;

              RETURN TRUE;


                EXCEPTION WHEN OTHERS THEN

                  DBMS_OUTPUT.PUT_LINE(SUBSTR(SQLERRM, 1, 255));
                    RETURN FALSE;


                end FND_MCRE0_alim_PCR_SC_SB_AP;


FUNCTION FND_MCRE0_alimenta_PERCORSI(p_rec IN f_slave_par_type) RETURN BOOLEAN IS

        c_nome CONSTANT VARCHAR2(100) := c_package || '.FND_MCRE0_alimenta_PERCORSI';
        b_flag BOOLEAN;
        v_cur PKG_MCRE0_UTILS.cur_abi_type;
        v_count NUMBER;



   BEGIN

     DBMS_OUTPUT.PUT_LINE('INIZIALIZZO CURSORE X SOTTOPARTIZIONE COD_ABI');

     open v_cur for select distinct COD_ABI
     from T_MCRE0_APP_ISTITUTI;

       DBMS_OUTPUT.PUT_LINE('CURSORE X SOTTOPARTIZIONE COD_ABI INIZIALIZZATO');

     b_flag := PKG_MCRE0_PARTIZIONI.FND_MCRE0_add_partition(p_rec.SEQ_FLUSSO,p_rec.TAB_TRG,p_rec.PERIODO,v_cur);


     IF(b_flag) THEN


                  insert
             when
             NUM_RECS = 1
             AND TRIM(TO_CHAR(ID_DPER)) IS NOT NULL
             AND TRIM(TO_CHAR(COD_ABI_CARTOLARIZZATO)) IS NOT NULL
             AND TRIM(TO_CHAR(COD_NDG)) IS NOT NULL
             AND TRIM(TO_CHAR(TMS)) IS NOT NULL



            then

            INTO T_MCRE0_ST_PERCORSI (
                    ID_DPER    ,
                    COD_ABI_ISTITUTO    ,
                    COD_ABI_CARTOLARIZZATO    ,
                    COD_NDG    ,
                    COD_STATO_PRECEDENTE    ,
                    COD_STATO    ,
                    DTA_DECORRENZA_STATO    ,
                    DTA_SCADENZA_STATO    ,
                    DTA_USCITA_STATO    ,
                    COD_PERCORSO    ,
                    TMS    ,
                    FLG_ANNULLO    ,
                    COD_CODUTRM    ,
                    COD_PROCESSO    ,
                    VAL_IMP_ACC_CASSA    ,
                    VAL_IMP_UTI_CASSA    ,
                    VAL_IMP_ACC_FIRMA    ,
                    VAL_IMP_UTI_FIRMA    ,
                    DTA_PROCESSO    ,
                    COD_TIPO_VARIAZIONE    ,
                    FLG_FATAL
            )

            VALUES (
                    ID_DPER    ,
                    COD_ABI_ISTITUTO    ,
                    COD_ABI_CARTOLARIZZATO    ,
                    COD_NDG    ,
                    COD_STATO_PRECEDENTE    ,
                    COD_STATO    ,
                    DTA_DECORRENZA_STATO    ,
                    DTA_SCADENZA_STATO    ,
                    DTA_USCITA_STATO    ,
                    COD_PERCORSO    ,
                    TMS    ,
                    FLG_ANNULLO    ,
                    COD_CODUTRM    ,
                    COD_PROCESSO    ,
                    VAL_IMP_ACC_CASSA    ,
                    VAL_IMP_UTI_CASSA    ,
                    VAL_IMP_ACC_FIRMA    ,
                    VAL_IMP_UTI_FIRMA    ,
                    DTA_PROCESSO    ,
                    COD_TIPO_VARIAZIONE    ,
                    FLG_FATAL
                    )

             when
             NUM_RECS > 1
             OR TRIM(TO_CHAR(ID_DPER)) IS NULL
             OR TRIM(TO_CHAR(COD_ABI_CARTOLARIZZATO)) IS NULL
             OR TRIM(TO_CHAR(COD_NDG)) IS NULL
             OR TRIM(TO_CHAR(TMS)) IS NULL


             then
             INTO T_MCRE0_SC_VINCOLI_PERCORSI (
                ID_SEQ    ,
                ID_DPER    ,
                COD_ABI_ISTITUTO    ,
                COD_ABI_CARTOLARIZZATO    ,
                COD_NDG    ,
                COD_STATO_PRECEDENTE    ,
                COD_STATO    ,
                DTA_DECORRENZA_STATO    ,
                DTA_SCADENZA_STATO    ,
                DTA_USCITA_STATO    ,
                COD_PERCORSO    ,
                TMS    ,
                FLG_ANNULLO    ,
                COD_CODUTRM    ,
                COD_PROCESSO    ,
                VAL_IMP_ACC_CASSA    ,
                VAL_IMP_UTI_CASSA    ,
                VAL_IMP_ACC_FIRMA    ,
                VAL_IMP_UTI_FIRMA    ,
                DTA_PROCESSO    ,
                COD_TIPO_VARIAZIONE    ,
                FLG_FATAL
                )

                VALUES (
                p_rec.SEQ_FLUSSO,
                ID_DPER    ,
                COD_ABI_ISTITUTO    ,
                COD_ABI_CARTOLARIZZATO    ,
                COD_NDG    ,
                COD_STATO_PRECEDENTE    ,
                COD_STATO    ,
                DTA_DECORRENZA_STATO    ,
                DTA_SCADENZA_STATO    ,
                DTA_USCITA_STATO    ,
                COD_PERCORSO    ,
                TMS    ,
                FLG_ANNULLO    ,
                COD_CODUTRM    ,
                COD_PROCESSO    ,
                VAL_IMP_ACC_CASSA    ,
                VAL_IMP_UTI_CASSA    ,
                VAL_IMP_ACC_FIRMA    ,
                VAL_IMP_UTI_FIRMA    ,
                DTA_PROCESSO    ,
                COD_TIPO_VARIAZIONE    ,
                FLG_FATAL
                )


             select * from
        (
            SELECT
                COUNT(1) OVER(PARTITION BY  ID_DPER, COD_ABI_CARTOLARIZZATO, COD_NDG, TMS) NUM_RECS,
                ID_DPER    ,
                COD_ABI_ISTITUTO    ,
                COD_ABI_CARTOLARIZZATO    ,
                COD_NDG    ,
                COD_STATO_PRECEDENTE    ,
                COD_STATO    ,
                DTA_DECORRENZA_STATO    ,
                DTA_SCADENZA_STATO    ,
                DTA_USCITA_STATO    ,
                COD_PERCORSO    ,
                TMS    ,
                FLG_ANNULLO    ,
                COD_CODUTRM    ,
                COD_PROCESSO    ,
                VAL_IMP_ACC_CASSA    ,
                VAL_IMP_UTI_CASSA    ,
                VAL_IMP_ACC_FIRMA    ,
                VAL_IMP_UTI_FIRMA    ,
                DTA_PROCESSO    ,
                COD_TIPO_VARIAZIONE    ,
                FLG_FATAL


            FROM
              T_MCRE0_FL_PERCORSI
        ) tmp;
        COMMIT;


          SELECT COUNT(*)
          INTO v_count
          FROM T_MCRE0_SC_VINCOLI_PERCORSI   SC
          WHERE SC.ID_SEQ = p_rec.SEQ_FLUSSO;


          UPDATE T_MCRE0_WRK_ACQUISIZIONE
          SET SCARTI_VINCOLI = v_count
          WHERE ID_FLUSSO = p_rec.SEQ_FLUSSO;
          commit;




        b_flag := TRUE;


     END IF;

         IF(b_flag) THEN

        PKG_MCRE0_LOG.SPO_MCRE0_LOG_EVENTO(p_rec.SEQ_FLUSSO,c_nome,'OK','DATI INSERITI CORRETTAMENTE');

        END IF;

      --close v_cur;

           /*  BEGIN

                SELECT VALORE_COSTANTE INTO v_mesi_svecchiamento
                FROM T_MCRE0_WRK_CONFIGURAZIONE
                WHERE NOME_COSTANTE = 'MESI_SVECCHIAMENTO_PERCORSI';

            EXCEPTION

                WHEN OTHERS THEN

                    v_mesi_svecchiamento := 0;

                    PKG_MCRE0_LOG.SPO_MCRE0_LOG_EVENTO(p_rec.SEQ_FLUSSO,c_nome,'ATTENZIONE','Svecchiamento non eseguibile per problemi di rilevamento della costante ''MESI_SVECCHIAMENTO_PERCORSI'' nella tabella ''T_MCRE0_WRK_CONFIGURAZIONE''');

            END;

            IF(v_mesi_svecchiamento > 0) THEN

             b_flag := svecchiamento_p31(p_rec.SEQ_FLUSSO,p_rec.TAB_TRG,p_rec.PERIODO,v_mesi_svecchiamento);

            END IF;*/


        RETURN b_flag;


            EXCEPTION


        WHEN OTHERS THEN

        DBMS_OUTPUT.PUT_LINE('ERRORE IN FND_MCRE0_alimenta_PERCORSI');
         DBMS_OUTPUT.PUT_LINE(SUBSTR(SQLERRM, 1, 255));
            ROLLBACK;

           IF(v_cur%ISOPEN) THEN

                    CLOSE v_cur;

                     DBMS_OUTPUT.PUT_LINE('ERRORE IN FND_MCRE0_alimenta_PERCORSI - CLOSE CURSOR');

                END IF;

            PKG_MCRE0_LOG.SPO_MCRE0_log_evento_no_commit(p_rec.SEQ_FLUSSO,p_rec.TAB_TRG,'ERRORE',SUBSTR(SQLERRM, 1, 255));

            RETURN FALSE;

     END FND_MCRE0_alimenta_PERCORSI;

FUNCTION FND_MCRE0_alimenta_PERCORSI_AP(p_rec IN f_slave_par_type) RETURN BOOLEAN IS

  v_partition varchar2(20);
  v_sql varchar2(5000);


   begin


   v_partition := 'CCP_P'|| to_char(p_rec.PERIODO, 'yyyymmdd');

          v_sql :=  'BEGIN
            MERGE

               INTO  T_MCRE0_APP_PERCORSI24 trg

               USING T_MCRE0_ST_PERCORSI  PARTITION(' || v_partition || ')  src

               ON  (src.COD_ABI_CARTOLARIZZATO    = trg.COD_ABI_CARTOLARIZZATO
                and src.COD_NDG    = trg.COD_NDG
                and src.TMS = trg.TMS)


            WHEN MATCHED

            THEN

              UPDATE

              SET
                trg.COD_ABI_ISTITUTO=src.COD_ABI_ISTITUTO    ,
                trg.COD_STATO_PRECEDENTE=src.COD_STATO_PRECEDENTE    ,
                trg.COD_STATO=src.COD_STATO    ,
                trg.DTA_DECORRENZA_STATO=src.DTA_DECORRENZA_STATO    ,
                trg.DTA_SCADENZA_STATO=src.DTA_SCADENZA_STATO    ,
                trg.DTA_USCITA_STATO=src.DTA_USCITA_STATO    ,
                trg.COD_PERCORSO=src.COD_PERCORSO    ,
                trg.FLG_ANNULLO=src.FLG_ANNULLO    ,
                trg.COD_CODUTRM=src.COD_CODUTRM    ,
                trg.COD_PROCESSO=src.COD_PROCESSO    ,
                trg.VAL_IMP_ACC_CASSA=src.VAL_IMP_ACC_CASSA    ,
                trg.VAL_IMP_UTI_CASSA=src.VAL_IMP_UTI_CASSA    ,
                trg.VAL_IMP_ACC_FIRMA=src.VAL_IMP_ACC_FIRMA    ,
                trg.VAL_IMP_UTI_FIRMA=src.VAL_IMP_UTI_FIRMA    ,
                trg.DTA_PROCESSO=src.DTA_PROCESSO,
                trg.COD_TIPO_VARIAZIONE=src.COD_TIPO_VARIAZIONE,
                trg.FLG_FATAL=src.FLG_FATAL,
                trg.DTA_UPD= sysdate,
                trg.COD_OPERATORE_INS_UPD = NULL,
                trg.ID_DPER = src.ID_DPER


           WHEN NOT MATCHED
           THEN
              INSERT (
                    trg.COD_ABI_ISTITUTO,
                    trg.COD_ABI_CARTOLARIZZATO,
                    trg.COD_NDG,
                    trg.COD_STATO_PRECEDENTE,
                    trg.COD_STATO,
                    trg.DTA_DECORRENZA_STATO,
                    trg.DTA_SCADENZA_STATO,
                    trg.DTA_USCITA_STATO,
                    trg.COD_PERCORSO,
                    trg.TMS,
                    trg.FLG_ANNULLO,
                    trg.COD_CODUTRM,
                    trg.COD_PROCESSO,
                    trg.VAL_IMP_ACC_CASSA,
                    trg.VAL_IMP_UTI_CASSA,
                    trg.VAL_IMP_ACC_FIRMA,
                    trg.VAL_IMP_UTI_FIRMA,
                    trg.DTA_PROCESSO,
                    trg.COD_TIPO_VARIAZIONE,
                    trg.FLG_FATAL,
                    trg.DTA_INS ,
                    trg.DTA_UPD ,
                    trg.COD_OPERATORE_INS_UPD ,
                    trg.ID_DPER

                        )

              VALUES (
                        src.COD_ABI_ISTITUTO,
                        src.COD_ABI_CARTOLARIZZATO,
                        src.COD_NDG,
                        src.COD_STATO_PRECEDENTE,
                        src.COD_STATO,
                        src.DTA_DECORRENZA_STATO,
                        src.DTA_SCADENZA_STATO,
                        src.DTA_USCITA_STATO,
                        src.COD_PERCORSO,
                        src.TMS,
                        src.FLG_ANNULLO,
                        src.COD_CODUTRM,
                        src.COD_PROCESSO,
                        src.VAL_IMP_ACC_CASSA,
                        src.VAL_IMP_UTI_CASSA,
                        src.VAL_IMP_ACC_FIRMA,
                        src.VAL_IMP_UTI_FIRMA,
                        src.DTA_PROCESSO,
                        src.COD_TIPO_VARIAZIONE,
                        src.FLG_FATAL,
                        sysdate,
                        sysdate,
                        NULL,
                        src.ID_DPER );

            commit;
            END;';


            DBMS_OUTPUT.PUT_LINE(v_sql);


              execute immediate v_sql;

              RETURN TRUE;


                EXCEPTION WHEN OTHERS THEN

                  DBMS_OUTPUT.PUT_LINE(SUBSTR(SQLERRM, 1, 255));



                end FND_MCRE0_alimenta_PERCORSI_AP;


FUNCTION FND_MCRE0_alimenta_ANAGR_GRP(p_rec IN f_slave_par_type) RETURN BOOLEAN IS

        c_nome CONSTANT VARCHAR2(100) := c_package || '.FND_MCRE0_alimenta_ANAGR_GRP';
        b_flag BOOLEAN;
        v_cur PKG_MCRE0_UTILS.cur_abi_type;
        v_count NUMBER;



   BEGIN

     DBMS_OUTPUT.PUT_LINE('INIZIALIZZO CURSORE X SOTTOPARTIZIONE COD_ABI');

     open v_cur for select distinct COD_ABI
     from T_MCRE0_APP_ISTITUTI;

       DBMS_OUTPUT.PUT_LINE('CURSORE X SOTTOPARTIZIONE COD_ABI INIZIALIZZATO');

     b_flag := PKG_MCRE0_PARTIZIONI.FND_MCRE0_add_partition(p_rec.SEQ_FLUSSO,p_rec.TAB_TRG,p_rec.PERIODO,v_cur);


     IF(b_flag) THEN


                  insert
             when
             NUM_RECS = 1
             AND TRIM(TO_CHAR(ID_DPER)) IS NOT NULL
             AND TRIM(TO_CHAR(COD_SNDG)) IS NOT NULL


            then

            INTO T_MCRE0_ST_ANAGRAFICA_GRUPPO (
                                    ID_DPER,
                                    COD_SNDG,
                                    DESC_NOME_CONTROPARTE,
                                    VAL_PARTITA_IVA,
                                    VAL_SETTORE_ECONOMICO,
                                    VAL_RAMO_ECONOMICO,
                                    FLG_ART_136,
                                    COD_SNDG_SOGGETTO,
                                    VAL_SEGMENTO_REGOLAMENTARE,
                                    DTA_SEGMENTO_REGOLAMENTARE,
                                    VAL_PD_ONLINE,
                                    DTA_RIF_PD_ONLINE,
                                    DTA_INIZIO_RELAZIONE,
                                    VAL_RATING_ONLINE,
                                    DTA_NASCITA_COSTITUZIONE
            )

            VALUES (
                        ID_DPER,
                        COD_SNDG,
                        DESC_NOME_CONTROPARTE,
                        VAL_PARTITA_IVA,
                        VAL_SETTORE_ECONOMICO,
                        VAL_RAMO_ECONOMICO,
                        FLG_ART_136,
                        COD_SNDG_SOGGETTO,
                        VAL_SEGMENTO_REGOLAMENTARE,
                        DTA_SEGMENTO_REGOLAMENTARE,
                        VAL_PD_ONLINE,
                        DTA_RIF_PD_ONLINE,
                        DTA_INIZIO_RELAZIONE,
                        VAL_RATING_ONLINE,
                        DTA_NASCITA_COSTITUZIONE

                            )

             when
             NUM_RECS > 1
             OR TRIM(TO_CHAR(ID_DPER)) IS NULL
             OR TRIM(TO_CHAR(COD_SNDG)) IS NULL


             then
             INTO T_MCRE0_SC_VINCOLI_ANAGR_GRP (
                                    ID_DPER,
                                    COD_SNDG,
                                    DESC_NOME_CONTROPARTE,
                                    VAL_PARTITA_IVA,
                                    VAL_SETTORE_ECONOMICO,
                                    VAL_RAMO_ECONOMICO,
                                    FLG_ART_136,
                                    COD_SNDG_SOGGETTO,
                                    VAL_SEGMENTO_REGOLAMENTARE,
                                    DTA_SEGMENTO_REGOLAMENTARE,
                                    VAL_PD_ONLINE,
                                    DTA_RIF_PD_ONLINE,
                                    DTA_INIZIO_RELAZIONE   ,
                                    VAL_RATING_ONLINE,
                                    DTA_NASCITA_COSTITUZIONE
                )

                            VALUES (
                                    ID_DPER,
                                    COD_SNDG,
                                    DESC_NOME_CONTROPARTE,
                                    VAL_PARTITA_IVA,
                                    VAL_SETTORE_ECONOMICO,
                                    VAL_RAMO_ECONOMICO,
                                    FLG_ART_136,
                                    COD_SNDG_SOGGETTO,
                                    VAL_SEGMENTO_REGOLAMENTARE,
                                    DTA_SEGMENTO_REGOLAMENTARE,
                                    VAL_PD_ONLINE,
                                    DTA_RIF_PD_ONLINE,
                                    DTA_INIZIO_RELAZIONE,
                                    VAL_RATING_ONLINE,
                                    DTA_NASCITA_COSTITUZIONE)


             select * from
        (
            SELECT
                COUNT(1) OVER(PARTITION BY  ID_DPER, COD_SNDG) NUM_RECS,
                                    ID_DPER,
                                    COD_SNDG,
                                    DESC_NOME_CONTROPARTE,
                                    VAL_PARTITA_IVA,
                                    VAL_SETTORE_ECONOMICO,
                                    VAL_RAMO_ECONOMICO,
                                    FLG_ART_136,
                                    COD_SNDG_SOGGETTO,
                                    VAL_SEGMENTO_REGOLAMENTARE,
                                    DTA_SEGMENTO_REGOLAMENTARE,
                                    VAL_PD_ONLINE,
                                    DTA_RIF_PD_ONLINE,
                                    DTA_INIZIO_RELAZIONE,
                                    VAL_RATING_ONLINE,
                                    DTA_NASCITA_COSTITUZIONE

            FROM
              T_MCRE0_FL_ANAGRAFICA_GRUPPO
        ) tmp;
        COMMIT;

          SELECT COUNT(*)
          INTO v_count
          FROM T_MCRE0_SC_VINCOLI_ANAGR_GRP   SC
          WHERE SC.ID_SEQ = p_rec.SEQ_FLUSSO;


          UPDATE T_MCRE0_WRK_ACQUISIZIONE
          SET SCARTI_VINCOLI = v_count
          WHERE ID_FLUSSO = p_rec.SEQ_FLUSSO;
          commit;


        b_flag := TRUE;


     END IF;

         IF(b_flag) THEN

        PKG_MCRE0_LOG.SPO_MCRE0_LOG_EVENTO(p_rec.SEQ_FLUSSO,c_nome,'OK','DATI INSERITI CORRETTAMENTE');

        END IF;

      --close v_cur;

           /*  BEGIN

                SELECT VALORE_COSTANTE INTO v_mesi_svecchiamento
                FROM T_MCRE0_WRK_CONFIGURAZIONE
                WHERE NOME_COSTANTE = 'MESI_SVECCHIAMENTO_ANAGR_GRP';

            EXCEPTION

                WHEN OTHERS THEN

                    v_mesi_svecchiamento := 0;

                    PKG_MCRE0_LOG.SPO_MCRE0_LOG_EVENTO(p_rec.SEQ_FLUSSO,c_nome,'ATTENZIONE','Svecchiamento non eseguibile per problemi di rilevamento della costante ''MESI_SVECCHIAMENTO_ANAGR_GRP'' nella tabella ''T_MCRE0_WRK_CONFIGURAZIONE''');

            END;

            IF(v_mesi_svecchiamento > 0) THEN

             b_flag := svecchiamento_p31(p_rec.SEQ_FLUSSO,p_rec.TAB_TRG,p_rec.PERIODO,v_mesi_svecchiamento);

            END IF;*/


        RETURN b_flag;


            EXCEPTION


        WHEN OTHERS THEN

        DBMS_OUTPUT.PUT_LINE('ERRORE IN FND_MCRE0_alimenta_ANAGR_GRP');
         DBMS_OUTPUT.PUT_LINE(SUBSTR(SQLERRM, 1, 255));
            ROLLBACK;

           IF(v_cur%ISOPEN) THEN

                    CLOSE v_cur;

                     DBMS_OUTPUT.PUT_LINE('ERRORE IN FND_MCRE0_alimenta_ANAGR_GRP - CLOSE CURSOR');

                END IF;

            PKG_MCRE0_LOG.SPO_MCRE0_log_evento_no_commit(p_rec.SEQ_FLUSSO,p_rec.TAB_TRG,'ERRORE',SUBSTR(SQLERRM, 1, 255));

            RETURN FALSE;

     END FND_MCRE0_alimenta_ANAGR_GRP;



FUNCTION FND_MCRE0_alim_ANAGR_GRP_AP(p_rec IN f_slave_par_type) RETURN BOOLEAN IS

  v_partition varchar2(20);
  v_sql varchar2(5000);


   begin


   v_partition := 'CCP_P'|| to_char(p_rec.PERIODO, 'yyyymmdd');

          v_sql :=  'BEGIN

            MERGE

               INTO  T_MCRE0_APP_ANAGRAFICA_GRUPPO2 trg

               USING T_MCRE0_ST_ANAGRAFICA_GRUPPO  PARTITION (' || v_partition || ') src

               ON  (src.COD_SNDG = trg.COD_SNDG)


            WHEN MATCHED

            THEN

              UPDATE

              SET

                trg.DESC_NOME_CONTROPARTE=src.DESC_NOME_CONTROPARTE,
                trg.VAL_PARTITA_IVA=src.VAL_PARTITA_IVA,
                trg.VAL_SETTORE_ECONOMICO=src.VAL_SETTORE_ECONOMICO,
                trg.VAL_RAMO_ECONOMICO=src.VAL_RAMO_ECONOMICO,
                trg.FLG_ART_136=src.FLG_ART_136,
                trg.COD_SNDG_SOGGETTO=src.COD_SNDG_SOGGETTO,
                trg.VAL_SEGMENTO_REGOLAMENTARE=src.VAL_SEGMENTO_REGOLAMENTARE,
                trg.DTA_SEGMENTO_REGOLAMENTARE=src.DTA_SEGMENTO_REGOLAMENTARE,
                trg.VAL_PD_ONLINE=src.VAL_PD_ONLINE,
                trg.DTA_RIF_PD_ONLINE=src.DTA_RIF_PD_ONLINE,
                trg.DTA_INIZIO_RELAZIONE=src.DTA_INIZIO_RELAZIONE ,
                trg.DTA_UPD= sysdate,
                trg.COD_OPERATORE_INS_UPD = NULL,
                trg.ID_DPER = src.ID_DPER,
                trg.VAL_RATING_ONLINE = src.VAL_RATING_ONLINE,
                trg.DTA_NASCITA_COSTITUZIONE = src.DTA_NASCITA_COSTITUZIONE


           WHEN NOT MATCHED
           THEN
              INSERT (

                    trg.COD_SNDG,
                    trg.DESC_NOME_CONTROPARTE,
                    trg.VAL_PARTITA_IVA,
                    trg.VAL_SETTORE_ECONOMICO,
                    trg.VAL_RAMO_ECONOMICO,
                    trg.FLG_ART_136,
                    trg.COD_SNDG_SOGGETTO,
                    trg.VAL_SEGMENTO_REGOLAMENTARE,
                    trg.DTA_SEGMENTO_REGOLAMENTARE,
                    trg.VAL_PD_ONLINE,
                    trg.DTA_RIF_PD_ONLINE,
                    trg.DTA_INIZIO_RELAZIONE ,
                    trg.DTA_INS ,
                    trg.DTA_UPD ,
                    trg.COD_OPERATORE_INS_UPD ,
                    trg.ID_DPER ,
                    trg.VAL_RATING_ONLINE,
                    trg.DTA_NASCITA_COSTITUZIONE

                        )

              VALUES (

                        src.COD_SNDG,
                        src.DESC_NOME_CONTROPARTE,
                        src.VAL_PARTITA_IVA,
                        src.VAL_SETTORE_ECONOMICO,
                        src.VAL_RAMO_ECONOMICO,
                        src.FLG_ART_136,
                        src.COD_SNDG_SOGGETTO,
                        src.VAL_SEGMENTO_REGOLAMENTARE,
                        src.DTA_SEGMENTO_REGOLAMENTARE,
                        src.VAL_PD_ONLINE,
                        src.DTA_RIF_PD_ONLINE,
                        src.DTA_INIZIO_RELAZIONE,
                        sysdate,
                        sysdate,
                        NULL,
                        src.ID_DPER,
                        src.VAL_RATING_ONLINE,
                        src.DTA_NASCITA_COSTITUZIONE );

            commit;
            END;';


            DBMS_OUTPUT.PUT_LINE(v_sql);


              execute immediate v_sql;

              RETURN TRUE;


                EXCEPTION WHEN OTHERS THEN

                  DBMS_OUTPUT.PUT_LINE(SUBSTR(SQLERRM, 1, 255));



                end FND_MCRE0_alim_ANAGR_GRP_AP;



FUNCTION FND_MCRE0_alimenta_RATE_ARR(p_rec IN f_slave_par_type) RETURN BOOLEAN IS

        c_nome CONSTANT VARCHAR2(100) := c_package || '.FND_MCRE0_alimenta_RATE_ARR';
        b_flag BOOLEAN;
        v_cur PKG_MCRE0_UTILS.cur_abi_type;
        v_count NUMBER;



   BEGIN

     DBMS_OUTPUT.PUT_LINE('INIZIALIZZO CURSORE X SOTTOPARTIZIONE COD_ABI');

     open v_cur for select distinct COD_ABI
     from T_MCRE0_APP_ISTITUTI;

       DBMS_OUTPUT.PUT_LINE('CURSORE X SOTTOPARTIZIONE COD_ABI INIZIALIZZATO');

     b_flag := PKG_MCRE0_PARTIZIONI.FND_MCRE0_add_partition(p_rec.SEQ_FLUSSO,p_rec.TAB_TRG,p_rec.PERIODO,v_cur);


     IF(b_flag) THEN


                  insert
             when
             NUM_RECS = 1
             AND TRIM(TO_CHAR(ID_DPER)) IS NOT NULL
             AND TRIM(TO_CHAR(COD_ABI_CARTOLARIZZATO)) IS NOT NULL
             AND TRIM(TO_CHAR(COD_NDG)) IS NOT NULL
             AND TRIM(TO_CHAR(TMS)) IS NOT NULL
             AND TRIM(TO_CHAR(COD_RAPPORTO)) IS NOT NULL

            then

            INTO T_MCRE0_ST_RATE_ARRETRATE (
            ID_DPER    ,
            COD_ABI_ISTITUTO    ,
            COD_ABI_CARTOLARIZZATO    ,
            COD_NDG    ,
            TMS    ,
            COD_RAPPORTO    ,
            VAL_COEFF_RATE_ARRETRATE    ,
            COD_PERIODO    ,
            DTA_SCADENZA    ,
            VAL_IMP_ARRETRATO    ,
            VAL_IMP_MORA    ,
            VAL_IMP_ULTIMA_RATA    ,
            VAL_IMP_DEBITO_RESIDUO,
            COD_PERCORSO
            )

            VALUES (
            ID_DPER    ,
            COD_ABI_ISTITUTO    ,
            COD_ABI_CARTOLARIZZATO    ,
            COD_NDG    ,
            TMS    ,
            COD_RAPPORTO    ,
            VAL_COEFF_RATE_ARRETRATE    ,
            COD_PERIODO    ,
            DTA_SCADENZA    ,
            VAL_IMP_ARRETRATO    ,
            VAL_IMP_MORA    ,
            VAL_IMP_ULTIMA_RATA    ,
            VAL_IMP_DEBITO_RESIDUO,
            COD_PERCORSO    )

             when
             NUM_RECS > 1
             OR TRIM(TO_CHAR(ID_DPER)) IS NULL
             OR TRIM(TO_CHAR(COD_ABI_CARTOLARIZZATO)) IS NULL
             OR TRIM(TO_CHAR(COD_NDG)) IS NULL
             OR TRIM(TO_CHAR(TMS)) IS NULL
             OR TRIM(TO_CHAR(COD_RAPPORTO)) IS NULL


             then
             INTO T_MCRE0_SC_VINCOLI_RATE_ARR (
                ID_SEQ    ,
                ID_DPER    ,
                COD_ABI_ISTITUTO    ,
                COD_ABI_CARTOLARIZZATO    ,
                COD_NDG    ,
                TMS    ,
                COD_RAPPORTO    ,
                VAL_COEFF_RATE_ARRETRATE    ,
                COD_PERIODO    ,
                DTA_SCADENZA    ,
                VAL_IMP_ARRETRATO    ,
                VAL_IMP_MORA    ,
                VAL_IMP_ULTIMA_RATA    ,
                VAL_IMP_DEBITO_RESIDUO,
                COD_PERCORSO
                )

                VALUES (
                p_rec.SEQ_FLUSSO,
                ID_DPER    ,
                COD_ABI_ISTITUTO    ,
                COD_ABI_CARTOLARIZZATO    ,
                COD_NDG    ,
                TMS    ,
                COD_RAPPORTO    ,
                VAL_COEFF_RATE_ARRETRATE    ,
                COD_PERIODO    ,
                DTA_SCADENZA    ,
                VAL_IMP_ARRETRATO    ,
                VAL_IMP_MORA    ,
                VAL_IMP_ULTIMA_RATA    ,
                VAL_IMP_DEBITO_RESIDUO,
                COD_PERCORSO)


             select * from
        (
            SELECT
                COUNT(1) OVER(PARTITION BY  ID_DPER, COD_ABI_CARTOLARIZZATO, COD_NDG, TMS, COD_RAPPORTO) NUM_RECS,
                ID_DPER    ,
                COD_ABI_ISTITUTO    ,
                COD_ABI_CARTOLARIZZATO    ,
                COD_NDG    ,
                TMS    ,
                COD_RAPPORTO    ,
                VAL_COEFF_RATE_ARRETRATE    ,
                COD_PERIODO    ,
                DTA_SCADENZA    ,
                VAL_IMP_ARRETRATO    ,
                VAL_IMP_MORA    ,
                VAL_IMP_ULTIMA_RATA    ,
                VAL_IMP_DEBITO_RESIDUO,
                COD_PERCORSO

            FROM
              T_MCRE0_FL_RATE_ARRETRATE
        ) tmp;
        COMMIT;


          SELECT COUNT(*)
          INTO v_count
          FROM T_MCRE0_SC_VINCOLI_RATE_ARR    SC
          WHERE SC.ID_SEQ = p_rec.SEQ_FLUSSO;


          UPDATE T_MCRE0_WRK_ACQUISIZIONE
          SET SCARTI_VINCOLI = v_count
          WHERE ID_FLUSSO = p_rec.SEQ_FLUSSO;
          commit;



        b_flag := TRUE;


     END IF;

         IF(b_flag) THEN

        PKG_MCRE0_LOG.SPO_MCRE0_LOG_EVENTO(p_rec.SEQ_FLUSSO,c_nome,'OK','DATI INSERITI CORRETTAMENTE');

        END IF;

      --close v_cur;

           /*  BEGIN

                SELECT VALORE_COSTANTE INTO v_mesi_svecchiamento
                FROM T_MCRE0_WRK_CONFIGURAZIONE
                WHERE NOME_COSTANTE = 'MESI_SVECCHIAMENTO_RATE_ARR';

            EXCEPTION

                WHEN OTHERS THEN

                    v_mesi_svecchiamento := 0;

                    PKG_MCRE0_LOG.SPO_MCRE0_LOG_EVENTO(p_rec.SEQ_FLUSSO,c_nome,'ATTENZIONE','Svecchiamento non eseguibile per problemi di rilevamento della costante ''MESI_SVECCHIAMENTO_RATE_ARR'' nella tabella ''T_MCRE0_WRK_CONFIGURAZIONE''');

            END;

            IF(v_mesi_svecchiamento > 0) THEN

             b_flag := svecchiamento_p31(p_rec.SEQ_FLUSSO,p_rec.TAB_TRG,p_rec.PERIODO,v_mesi_svecchiamento);

            END IF;*/


        RETURN b_flag;


            EXCEPTION


        WHEN OTHERS THEN

        DBMS_OUTPUT.PUT_LINE('ERRORE IN FND_MCRE0_alimenta_RATE_ARR');
         DBMS_OUTPUT.PUT_LINE(SUBSTR(SQLERRM, 1, 255));
            ROLLBACK;

           IF(v_cur%ISOPEN) THEN

                    CLOSE v_cur;

                     DBMS_OUTPUT.PUT_LINE('ERRORE IN FND_MCRE0_alimenta_RATE_ARR - CLOSE CURSOR');

                END IF;

            PKG_MCRE0_LOG.SPO_MCRE0_log_evento_no_commit(p_rec.SEQ_FLUSSO,p_rec.TAB_TRG,'ERRORE',SUBSTR(SQLERRM, 1, 255));

            RETURN FALSE;

     END FND_MCRE0_alimenta_RATE_ARR;

FUNCTION FND_MCRE0_alimenta_RATE_ARR_AP(p_rec IN f_slave_par_type) RETURN BOOLEAN IS

  v_partition varchar2(20);
  v_sql varchar2(5000);


   begin


   v_partition := 'CCP_P'|| to_char(p_rec.PERIODO, 'yyyymmdd');

          v_sql :=  'BEGIN MERGE

               INTO  T_MCRE0_APP_RATE_ARRETRATE24 trg

               USING T_MCRE0_ST_RATE_ARRETRATE  PARTITION(' || v_partition || ') src

               ON  (src.COD_ABI_CARTOLARIZZATO    = trg.COD_ABI_CARTOLARIZZATO
                and src.COD_NDG    = trg.COD_NDG
                and src.TMS = trg.TMS
                and src.COD_RAPPORTO = trg.COD_RAPPORTO)

            WHEN MATCHED

            THEN

              UPDATE

              SET

                trg.COD_ABI_ISTITUTO=src.COD_ABI_ISTITUTO,
                trg.VAL_COEFF_RATE_ARRETRATE=src.VAL_COEFF_RATE_ARRETRATE,
                trg.COD_PERIODO=src.COD_PERIODO,
                trg.DTA_SCADENZA=src.DTA_SCADENZA,
                trg.VAL_IMP_ARRETRATO=src.VAL_IMP_ARRETRATO,
                trg.VAL_IMP_MORA=src.VAL_IMP_MORA,
                trg.VAL_IMP_ULTIMA_RATA=src.VAL_IMP_ULTIMA_RATA,
                trg.VAL_IMP_DEBITO_RESIDUO=src.VAL_IMP_DEBITO_RESIDUO,
                trg.DTA_UPD= sysdate,
                trg.COD_OPERATORE_INS_UPD = NULL,
                trg.ID_DPER = src.ID_DPER,
                trg.COD_PERCORSO = src.COD_PERCORSO


           WHEN NOT MATCHED
           THEN
              INSERT (

                        trg.COD_ABI_ISTITUTO,
                        trg.COD_ABI_CARTOLARIZZATO,
                        trg.COD_NDG,
                        trg.TMS,
                        trg.COD_RAPPORTO,
                        trg.VAL_COEFF_RATE_ARRETRATE,
                        trg.COD_PERIODO,
                        trg.DTA_SCADENZA,
                        trg.VAL_IMP_ARRETRATO,
                        trg.VAL_IMP_MORA,
                        trg.VAL_IMP_ULTIMA_RATA,
                        trg.VAL_IMP_DEBITO_RESIDUO,
                        trg.DTA_INS    ,
                        trg.DTA_UPD    ,
                        trg.COD_OPERATORE_INS_UPD    ,
                        trg.ID_DPER    ,
                        trg.COD_PERCORSO

                        )

              VALUES (

                        src.COD_ABI_ISTITUTO,
                        src.COD_ABI_CARTOLARIZZATO,
                        src.COD_NDG,
                        src.TMS,
                        src.COD_RAPPORTO,
                        src.VAL_COEFF_RATE_ARRETRATE,
                        src.COD_PERIODO,
                        src.DTA_SCADENZA,
                        src.VAL_IMP_ARRETRATO,
                        src.VAL_IMP_MORA,
                        src.VAL_IMP_ULTIMA_RATA,
                        src.VAL_IMP_DEBITO_RESIDUO,
                        sysdate,
                        sysdate,
                        NULL,
                        src.ID_DPER,
                        src.COD_PERCORSO );

            commit;
            END;';


            DBMS_OUTPUT.PUT_LINE(v_sql);


              execute immediate v_sql;

              RETURN TRUE;


                EXCEPTION WHEN OTHERS THEN

                  DBMS_OUTPUT.PUT_LINE(SUBSTR(SQLERRM, 1, 255));



                end FND_MCRE0_alimenta_RATE_ARR_AP;


FUNCTION FND_MCRE0_alimenta_SAG(p_rec IN f_slave_par_type) RETURN BOOLEAN IS

        c_nome CONSTANT VARCHAR2(100) := c_package || '.FND_MCRE0_alimenta_SAG';
        b_flag BOOLEAN;
        v_cur PKG_MCRE0_UTILS.cur_abi_type;
        v_count NUMBER;



   BEGIN

     DBMS_OUTPUT.PUT_LINE('INIZIALIZZO CURSORE X SOTTOPARTIZIONE COD_ABI');

     open v_cur for select distinct COD_ABI
     from T_MCRE0_APP_ISTITUTI;

       DBMS_OUTPUT.PUT_LINE('CURSORE X SOTTOPARTIZIONE COD_ABI INIZIALIZZATO');

     b_flag := PKG_MCRE0_PARTIZIONI.FND_MCRE0_add_partition(p_rec.SEQ_FLUSSO,p_rec.TAB_TRG,p_rec.PERIODO,v_cur);


     IF(b_flag) THEN


                  insert
             when
             NUM_RECS = 1
             AND TRIM(TO_CHAR(ID_DPER)) IS NOT NULL
             AND TRIM(TO_CHAR(COD_SNDG)) IS NOT NULL


            then

            INTO T_MCRE0_ST_SAG (
            ID_DPER    ,
            COD_SNDG    ,
            COD_SAG    ,
            DTA_CALCOLO_SAG    ,
            FLG_ALLINEAMENTO    ,
            FLG_CONFERMA    ,
            DTA_CONFERMA

            )
            VALUES (
                    ID_DPER    ,
                    COD_SNDG    ,
                    COD_SAG    ,
                    DTA_CALCOLO_SAG    ,
                    FLG_ALLINEAMENTO    ,
                    FLG_CONFERMA    ,
                    DTA_CONFERMA
                        )

             when
             NUM_RECS > 1
             OR TRIM(TO_CHAR(ID_DPER)) IS NULL
             OR TRIM(TO_CHAR(COD_SNDG)) IS NULL



             then
             INTO T_MCRE0_SC_VINCOLI_SAG (
                    ID_SEQ    ,
                    ID_DPER    ,
                    COD_SNDG    ,
                    COD_SAG    ,
                    DTA_CALCOLO_SAG    ,
                    FLG_ALLINEAMENTO    ,
                    FLG_CONFERMA    ,
                    DTA_CONFERMA
                )

                VALUES (
                    p_rec.SEQ_FLUSSO,
                    ID_DPER    ,
                    COD_SNDG    ,
                    COD_SAG    ,
                    DTA_CALCOLO_SAG    ,
                    FLG_ALLINEAMENTO    ,
                    FLG_CONFERMA    ,
                    DTA_CONFERMA)


             select * from
        (
            SELECT
                COUNT(1) OVER(PARTITION BY  ID_DPER, COD_SNDG) NUM_RECS,
                ID_DPER    ,
                COD_SNDG    ,
                COD_SAG    ,
                DTA_CALCOLO_SAG    ,
                FLG_ALLINEAMENTO    ,
                FLG_CONFERMA    ,
                DTA_CONFERMA

            FROM
              T_MCRE0_FL_SAG
        ) tmp;
        COMMIT;

          SELECT COUNT(*)
          INTO v_count
          FROM T_MCRE0_SC_VINCOLI_SAG    SC
          WHERE SC.ID_SEQ = p_rec.SEQ_FLUSSO;


          UPDATE T_MCRE0_WRK_ACQUISIZIONE
          SET SCARTI_VINCOLI = v_count
          WHERE ID_FLUSSO = p_rec.SEQ_FLUSSO;
          commit;



        b_flag := TRUE;


     END IF;

         IF(b_flag) THEN

        PKG_MCRE0_LOG.SPO_MCRE0_LOG_EVENTO(p_rec.SEQ_FLUSSO,c_nome,'OK','DATI INSERITI CORRETTAMENTE');

        END IF;

      --close v_cur;

           /*  BEGIN

                SELECT VALORE_COSTANTE INTO v_mesi_svecchiamento
                FROM T_MCRE0_WRK_CONFIGURAZIONE
                WHERE NOME_COSTANTE = 'MESI_SVECCHIAMENTO_SAG';

            EXCEPTION

                WHEN OTHERS THEN

                    v_mesi_svecchiamento := 0;

                    PKG_MCRE0_LOG.SPO_MCRE0_LOG_EVENTO(p_rec.SEQ_FLUSSO,c_nome,'ATTENZIONE','Svecchiamento non eseguibile per problemi di rilevamento della costante ''MESI_SVECCHIAMENTO_SAG'' nella tabella ''T_MCRE0_WRK_CONFIGURAZIONE''');

            END;

            IF(v_mesi_svecchiamento > 0) THEN

             b_flag := svecchiamento_p31(p_rec.SEQ_FLUSSO,p_rec.TAB_TRG,p_rec.PERIODO,v_mesi_svecchiamento);

            END IF;*/


        RETURN b_flag;


            EXCEPTION


        WHEN OTHERS THEN

        DBMS_OUTPUT.PUT_LINE('ERRORE IN FND_MCRE0_alimenta_SAG');
         DBMS_OUTPUT.PUT_LINE(SUBSTR(SQLERRM, 1, 255));
            ROLLBACK;

           IF(v_cur%ISOPEN) THEN

                    CLOSE v_cur;

                     DBMS_OUTPUT.PUT_LINE('ERRORE IN FND_MCRE0_alimenta_SAG - CLOSE CURSOR');

                END IF;

            PKG_MCRE0_LOG.SPO_MCRE0_log_evento_no_commit(p_rec.SEQ_FLUSSO,p_rec.TAB_TRG,'ERRORE',SUBSTR(SQLERRM, 1, 255));

            RETURN FALSE;

     END FND_MCRE0_alimenta_SAG;


FUNCTION FND_MCRE0_alimenta_SAG_AP(p_rec IN f_slave_par_type) RETURN BOOLEAN IS

  v_partition varchar2(20);
  v_sql varchar2(5000);


   begin


   v_partition := 'CCP_P'|| to_char(p_rec.PERIODO, 'yyyymmdd');

          v_sql :=  'BEGIN MERGE

               INTO  T_MCRE0_APP_SAG24 trg

               USING T_MCRE0_ST_SAG  PARTITION(' || v_partition || ') src

               ON  (src.COD_SNDG    = trg.COD_SNDG)

            WHEN MATCHED

            THEN

              UPDATE

              SET

                trg.COD_SAG=src.COD_SAG,
                trg.DTA_CALCOLO_SAG=src.DTA_CALCOLO_SAG,
                trg.FLG_ALLINEAMENTO=src.FLG_ALLINEAMENTO,
                trg.FLG_CONFERMA=src.FLG_CONFERMA,
                trg.DTA_CONFERMA=src.DTA_CONFERMA ,
                trg.DTA_UPD= sysdate,
                trg.COD_OPERATORE_INS_UPD = NULL,
                trg.ID_DPER = src.ID_DPER


           WHEN NOT MATCHED
           THEN
              INSERT (
                        trg.COD_SNDG,
                        trg.COD_SAG,
                        trg.DTA_CALCOLO_SAG,
                        trg.FLG_ALLINEAMENTO,
                        trg.FLG_CONFERMA,
                        trg.DTA_CONFERMA,
                        trg.DTA_INS    ,
                        trg.DTA_UPD    ,
                        trg.COD_OPERATORE_INS_UPD    ,
                        trg.ID_DPER

                        )

              VALUES (
                        src.COD_SNDG,
                        src.COD_SAG,
                        src.DTA_CALCOLO_SAG,
                        src.FLG_ALLINEAMENTO,
                        src.FLG_CONFERMA,
                        src.DTA_CONFERMA,
                        sysdate,
                        sysdate,
                        NULL,
                        src.ID_DPER );

            commit;
            END;';


            DBMS_OUTPUT.PUT_LINE(v_sql);


              execute immediate v_sql;

              RETURN TRUE;


                EXCEPTION WHEN OTHERS THEN

                  DBMS_OUTPUT.PUT_LINE(SUBSTR(SQLERRM, 1, 255));



                end FND_MCRE0_alimenta_SAG_AP;

FUNCTION FND_MCRE0_alimenta_SAB_XRA(p_rec IN f_slave_par_type) RETURN BOOLEAN IS

        c_nome CONSTANT VARCHAR2(100) := c_package || '.FND_MCRE0_alimenta_SAB_XRA';
        b_flag BOOLEAN;
        v_cur PKG_MCRE0_UTILS.cur_abi_type;
        v_count NUMBER;



   BEGIN

     DBMS_OUTPUT.PUT_LINE('INIZIALIZZO CURSORE X SOTTOPARTIZIONE COD_ABI');

     open v_cur for select distinct COD_ABI
     from T_MCRE0_APP_ISTITUTI;

       DBMS_OUTPUT.PUT_LINE('CURSORE X SOTTOPARTIZIONE COD_ABI INIZIALIZZATO');

     b_flag := PKG_MCRE0_PARTIZIONI.FND_MCRE0_add_partition(p_rec.SEQ_FLUSSO,p_rec.TAB_TRG,p_rec.PERIODO,v_cur);


     IF(b_flag) THEN


                  insert
             when
             NUM_RECS = 1
             AND TRIM(TO_CHAR(ID_DPER)) IS NOT NULL
             AND TRIM(TO_CHAR(COD_ABI_CARTOLARIZZATO)) IS NOT NULL
             AND TRIM(TO_CHAR(COD_NDG)) IS NOT NULL


            then

            INTO T_MCRE0_ST_SAB_XRA (
            ID_DPER    ,
            COD_ABI_ISTITUTO    ,
            COD_ABI_CARTOLARIZZATO    ,
            COD_NDG    ,
            COD_SAB    ,
            FLG_SOGLIA    ,
            NUM_GIORNI_SCONFINO    ,
            COD_RAP    ,
            NUM_GIORNI_SCONFINO_RAP  ,
            VAL_IMP_SCONFINO

            )
            VALUES (
            ID_DPER    ,
            COD_ABI_ISTITUTO ,
            COD_ABI_CARTOLARIZZATO    ,
            COD_NDG    ,
            COD_SAB    ,
            FLG_SOGLIA    ,
            NUM_GIORNI_SCONFINO    ,
            COD_RAP    ,
            NUM_GIORNI_SCONFINO_RAP   ,
            VAL_IMP_SCONFINO )

             when
             NUM_RECS > 1
             OR TRIM(TO_CHAR(ID_DPER)) IS NULL
             OR TRIM(TO_CHAR(COD_ABI_CARTOLARIZZATO)) IS NULL
             OR TRIM(TO_CHAR(COD_NDG)) IS NULL



             then
             INTO T_MCRE0_SC_VINCOLI_SAB_XRA (
                ID_SEQ    ,
                ID_DPER    ,
                COD_ABI_ISTITUTO ,
                COD_ABI_CARTOLARIZZATO    ,
                COD_NDG    ,
                COD_SAB    ,
                FLG_SOGLIA    ,
                NUM_GIORNI_SCONFINO    ,
                COD_RAP    ,
                NUM_GIORNI_SCONFINO_RAP  ,
                VAL_IMP_SCONFINO
                )

                VALUES (
                p_rec.SEQ_FLUSSO,
                ID_DPER    ,
                COD_ABI_ISTITUTO ,
                COD_ABI_CARTOLARIZZATO    ,
                COD_NDG    ,
                COD_SAB    ,
                FLG_SOGLIA    ,
                NUM_GIORNI_SCONFINO    ,
                COD_RAP    ,
                NUM_GIORNI_SCONFINO_RAP ,
                VAL_IMP_SCONFINO)


             select * from
        (
            SELECT
                COUNT(1) OVER(PARTITION BY  ID_DPER, COD_ABI_CARTOLARIZZATO, COD_NDG) NUM_RECS,
                ID_DPER    ,
                COD_ABI_ISTITUTO ,
                COD_ABI_CARTOLARIZZATO    ,
                COD_NDG    ,
                COD_SAB    ,
                FLG_SOGLIA    ,
                NUM_GIORNI_SCONFINO    ,
                COD_RAP    ,
                NUM_GIORNI_SCONFINO_RAP  ,
                VAL_IMP_SCONFINO

            FROM
              T_MCRE0_FL_SAB_XRA
        ) tmp;
        COMMIT;


                  SELECT COUNT(*)
          INTO v_count
          FROM T_MCRE0_SC_VINCOLI_SAB_XRA    SC
          WHERE SC.ID_SEQ = p_rec.SEQ_FLUSSO;


          UPDATE T_MCRE0_WRK_ACQUISIZIONE
          SET SCARTI_VINCOLI = v_count
          WHERE ID_FLUSSO = p_rec.SEQ_FLUSSO;
          commit;


        b_flag := TRUE;


     END IF;

         IF(b_flag) THEN

        PKG_MCRE0_LOG.SPO_MCRE0_LOG_EVENTO(p_rec.SEQ_FLUSSO,c_nome,'OK','DATI INSERITI CORRETTAMENTE');

        END IF;

      --close v_cur;

           /*  BEGIN

                SELECT VALORE_COSTANTE INTO v_mesi_svecchiamento
                FROM T_MCRE0_WRK_CONFIGURAZIONE
                WHERE NOME_COSTANTE = 'MESI_SVECCHIAMENTO_SAB_XRA';

            EXCEPTION

                WHEN OTHERS THEN

                    v_mesi_svecchiamento := 0;

                    PKG_MCRE0_LOG.SPO_MCRE0_LOG_EVENTO(p_rec.SEQ_FLUSSO,c_nome,'ATTENZIONE','Svecchiamento non eseguibile per problemi di rilevamento della costante ''MESI_SVECCHIAMENTO_SAB_XRA'' nella tabella ''T_MCRE0_WRK_CONFIGURAZIONE''');

            END;

            IF(v_mesi_svecchiamento > 0) THEN

             b_flag := svecchiamento_p31(p_rec.SEQ_FLUSSO,p_rec.TAB_TRG,p_rec.PERIODO,v_mesi_svecchiamento);

            END IF;*/


        RETURN b_flag;


            EXCEPTION


        WHEN OTHERS THEN

        DBMS_OUTPUT.PUT_LINE('ERRORE IN FND_MCRE0_alimenta_SAB_XRA');
         DBMS_OUTPUT.PUT_LINE(SUBSTR(SQLERRM, 1, 255));
            ROLLBACK;

           IF(v_cur%ISOPEN) THEN

                    CLOSE v_cur;

                     DBMS_OUTPUT.PUT_LINE('ERRORE IN FND_MCRE0_alimenta_SAB_XRA - CLOSE CURSOR');

                END IF;

            PKG_MCRE0_LOG.SPO_MCRE0_log_evento_no_commit(p_rec.SEQ_FLUSSO,p_rec.TAB_TRG,'ERRORE',SUBSTR(SQLERRM, 1, 255));

            RETURN FALSE;

     END FND_MCRE0_alimenta_SAB_XRA;

FUNCTION FND_MCRE0_alimenta_SAB_XRA_AP(p_rec IN f_slave_par_type) RETURN BOOLEAN IS

  v_partition varchar2(20);
  v_sql varchar2(5000);


   begin


   v_partition := 'CCP_P'|| to_char(p_rec.PERIODO, 'yyyymmdd');

          v_sql :=  'BEGIN MERGE

               INTO  T_MCRE0_APP_SAB_XRA24 trg

               USING T_MCRE0_ST_SAB_XRA  PARTITION(' || v_partition || ') src

               ON  (src.COD_ABI_CARTOLARIZZATO    = trg.COD_ABI_CARTOLARIZZATO
                    and src.COD_NDG    = trg.COD_NDG)

            WHEN MATCHED

            THEN

              UPDATE

              SET

                trg.COD_ABI_ISTITUTO=src.COD_ABI_ISTITUTO,
                trg.COD_SAB=src.COD_SAB,
                trg.FLG_SOGLIA=src.FLG_SOGLIA,
                trg.NUM_GIORNI_SCONFINO=src.NUM_GIORNI_SCONFINO,
                trg.COD_RAP=src.COD_RAP,
                trg.NUM_GIORNI_SCONFINO_RAP=src.NUM_GIORNI_SCONFINO_RAP,
                trg.VAL_IMP_SCONFINO=src.VAL_IMP_SCONFINO,
                trg.DTA_UPD= sysdate,
                trg.COD_OPERATORE_INS_UPD = NULL,
                trg.ID_DPER = src.ID_DPER


           WHEN NOT MATCHED
           THEN
              INSERT (  trg.COD_ABI_ISTITUTO,
                        trg.COD_ABI_CARTOLARIZZATO,
                        trg.COD_NDG,
                        trg.COD_SAB,
                        trg.FLG_SOGLIA,
                        trg.NUM_GIORNI_SCONFINO,
                        trg.COD_RAP,
                        trg.NUM_GIORNI_SCONFINO_RAP,
                        trg.VAL_IMP_SCONFINO,
                        trg.DTA_INS    ,
                        trg.DTA_UPD    ,
                        trg.COD_OPERATORE_INS_UPD    ,
                        trg.ID_DPER

                        )

              VALUES (  src.COD_ABI_ISTITUTO,
                        src.COD_ABI_CARTOLARIZZATO,
                        src.COD_NDG,
                        src.COD_SAB,
                        src.FLG_SOGLIA,
                        src.NUM_GIORNI_SCONFINO,
                        src.COD_RAP,
                        src.NUM_GIORNI_SCONFINO_RAP,
                        src.VAL_IMP_SCONFINO,
                        sysdate,
                        sysdate,
                        NULL,
                        src.ID_DPER );

            commit;
            END;';


            DBMS_OUTPUT.PUT_LINE(v_sql);


              execute immediate v_sql;

              RETURN TRUE;


                EXCEPTION WHEN OTHERS THEN

                  DBMS_OUTPUT.PUT_LINE(SUBSTR(SQLERRM, 1, 255));



                end FND_MCRE0_alimenta_SAB_XRA_AP;



FUNCTION FND_MCRE0_alimenta_ANAGR_GRE(p_rec IN f_slave_par_type) RETURN BOOLEAN IS

        c_nome CONSTANT VARCHAR2(100) := c_package || '.FND_MCRE0_alimenta_ANAGR_GRE';
        b_flag BOOLEAN;
        v_cur PKG_MCRE0_UTILS.cur_abi_type;
        v_count NUMBER;



   BEGIN

     DBMS_OUTPUT.PUT_LINE('INIZIALIZZO CURSORE X SOTTOPARTIZIONE COD_ABI');

     open v_cur for select distinct COD_ABI
     from T_MCRE0_APP_ISTITUTI;

       DBMS_OUTPUT.PUT_LINE('CURSORE X SOTTOPARTIZIONE COD_ABI INIZIALIZZATO');

     b_flag := PKG_MCRE0_PARTIZIONI.FND_MCRE0_add_partition(p_rec.SEQ_FLUSSO,p_rec.TAB_TRG,p_rec.PERIODO,v_cur);


     IF(b_flag) THEN


                  insert
             when
             NUM_RECS = 1
             AND TRIM(TO_CHAR(ID_DPER)) IS NOT NULL
             AND TRIM(TO_CHAR(COD_GRUPPO_ECO)) IS NOT NULL



            then

            INTO T_MCRE0_ST_ANAGR_GRE (
            ID_DPER    ,
            COD_GRUPPO_ECO    ,
            DESC_GRUPPO_ECO

            )
            VALUES (
            ID_DPER    ,
            COD_GRUPPO_ECO    ,
            DESC_GRUPPO_ECO        )

             when
             NUM_RECS > 1
             OR TRIM(TO_CHAR(ID_DPER)) IS NULL
             OR TRIM(TO_CHAR(COD_GRUPPO_ECO)) IS NULL


             then
             INTO T_MCRE0_SC_VINCOLI_ANAGR_GRE (
                ID_SEQ    ,
                ID_DPER    ,
                COD_GRUPPO_ECO    ,
                DESC_GRUPPO_ECO
                )

                VALUES (
                p_rec.SEQ_FLUSSO,
                ID_DPER    ,
                COD_GRUPPO_ECO    ,
                DESC_GRUPPO_ECO     )


             select * from
        (
            SELECT
                COUNT(1) OVER(PARTITION BY  ID_DPER, COD_GRUPPO_ECO) NUM_RECS,
                ID_DPER    ,
                COD_GRUPPO_ECO    ,
                DESC_GRUPPO_ECO

            FROM
              T_MCRE0_FL_ANAGRAFICA_GRE
        ) tmp;
        COMMIT;

          SELECT COUNT(*)
          INTO v_count
          FROM T_MCRE0_SC_VINCOLI_ANAGR_GRE    SC
          WHERE SC.ID_SEQ = p_rec.SEQ_FLUSSO;


          UPDATE T_MCRE0_WRK_ACQUISIZIONE
          SET SCARTI_VINCOLI = v_count
          WHERE ID_FLUSSO = p_rec.SEQ_FLUSSO;
          commit;


        b_flag := TRUE;


     END IF;

         IF(b_flag) THEN

        PKG_MCRE0_LOG.SPO_MCRE0_LOG_EVENTO(p_rec.SEQ_FLUSSO,c_nome,'OK','DATI INSERITI CORRETTAMENTE');

        END IF;

      --close v_cur;

           /*  BEGIN

                SELECT VALORE_COSTANTE INTO v_mesi_svecchiamento
                FROM T_MCRE0_WRK_CONFIGURAZIONE
                WHERE NOME_COSTANTE = 'MESI_SVECCHIAMENTO_ANAGR_GRE';

            EXCEPTION

                WHEN OTHERS THEN

                    v_mesi_svecchiamento := 0;

                    PKG_MCRE0_LOG.SPO_MCRE0_LOG_EVENTO(p_rec.SEQ_FLUSSO,c_nome,'ATTENZIONE','Svecchiamento non eseguibile per problemi di rilevamento della costante ''MESI_SVECCHIAMENTO_ANAGR_GRE'' nella tabella ''T_MCRE0_WRK_CONFIGURAZIONE''');

            END;

            IF(v_mesi_svecchiamento > 0) THEN

             b_flag := svecchiamento_p31(p_rec.SEQ_FLUSSO,p_rec.TAB_TRG,p_rec.PERIODO,v_mesi_svecchiamento);

            END IF;*/


        RETURN b_flag;


            EXCEPTION


        WHEN OTHERS THEN

        DBMS_OUTPUT.PUT_LINE('ERRORE IN FND_MCRE0_alimenta_ANAGR_GRE');
         DBMS_OUTPUT.PUT_LINE(SUBSTR(SQLERRM, 1, 255));
            ROLLBACK;

           IF(v_cur%ISOPEN) THEN

                    CLOSE v_cur;

                     DBMS_OUTPUT.PUT_LINE('ERRORE IN FND_MCRE0_alimenta_ANAGR_GRE - CLOSE CURSOR');

                END IF;

            PKG_MCRE0_LOG.SPO_MCRE0_log_evento_no_commit(p_rec.SEQ_FLUSSO,p_rec.TAB_TRG,'ERRORE',SUBSTR(SQLERRM, 1, 255));

            RETURN FALSE;

     END FND_MCRE0_alimenta_ANAGR_GRE;


FUNCTION FND_MCRE0_alim_ANAGR_GRE_AP(p_rec IN f_slave_par_type) RETURN BOOLEAN IS

  v_partition varchar2(20);
  v_sql varchar2(5000);


   begin


   v_partition := 'CCP_P'|| to_char(p_rec.PERIODO, 'yyyymmdd');

          v_sql :=  'BEGIN MERGE

               INTO  T_MCRE0_APP_ANAGR_GRE24 trg

               USING T_MCRE0_ST_ANAGR_GRE  PARTITION(' || v_partition || ') src

               ON  (
                trg.COD_GRE=src.COD_GRUPPO_ECO
                )

            WHEN MATCHED

            THEN

              UPDATE

              SET

                trg.VAL_ANA_GRE = src.DESC_GRUPPO_ECO,
                trg.DTA_UPD= sysdate,
                trg.COD_OPERATORE_INS_UPD = NULL,
                trg.ID_DPER = src.ID_DPER


           WHEN NOT MATCHED
           THEN
              INSERT (
                        trg.COD_GRE,
                        trg.VAL_ANA_GRE,
                        trg.DTA_INS    ,
                        trg.DTA_UPD    ,
                        trg.COD_OPERATORE_INS_UPD    ,
                        trg.ID_DPER

                        )

              VALUES (
                        src.COD_GRUPPO_ECO,
                        src.DESC_GRUPPO_ECO,
                        sysdate,
                        sysdate,
                        NULL,
                        src.ID_DPER );

            commit;
            END;';


            DBMS_OUTPUT.PUT_LINE(v_sql);


              execute immediate v_sql;

              RETURN TRUE;


                EXCEPTION WHEN OTHERS THEN

                  DBMS_OUTPUT.PUT_LINE(SUBSTR(SQLERRM, 1, 255));



                end FND_MCRE0_alim_ANAGR_GRE_AP;


FUNCTION FND_MCRE0_alimenta_PCR_GB(p_rec IN f_slave_par_type) RETURN BOOLEAN IS

        c_nome CONSTANT VARCHAR2(100) := c_package || '.FND_MCRE0_alimenta_PCR_GB';
        b_flag BOOLEAN;
        v_cur PKG_MCRE0_UTILS.cur_abi_type;
        v_count NUMBER;



   BEGIN

     DBMS_OUTPUT.PUT_LINE('INIZIALIZZO CURSORE X SOTTOPARTIZIONE COD_ABI');

     open v_cur for select distinct COD_ABI
     from T_MCRE0_APP_ISTITUTI;

       DBMS_OUTPUT.PUT_LINE('CURSORE X SOTTOPARTIZIONE COD_ABI INIZIALIZZATO');

     b_flag := PKG_MCRE0_PARTIZIONI.FND_MCRE0_add_partition(p_rec.SEQ_FLUSSO,p_rec.TAB_TRG,p_rec.PERIODO,v_cur);


     IF(b_flag) THEN


                  insert
             when
             NUM_RECS = 1
             AND TRIM(TO_CHAR(ID_DPER)) IS NOT NULL
             AND TRIM(TO_CHAR(COD_SNDG)) IS NOT NULL
             AND TRIM(TO_CHAR(COD_FORMA_TECNICA)) IS NOT NULL


            then

            INTO T_MCRE0_ST_PCR_GB (
            ID_DPER    ,
            COD_SNDG    ,
            COD_FORMA_TECNICA    ,
            VAL_IMP_UTI_CLI    ,
            VAL_IMP_ACC_CLI    ,
            VAL_IMP_UTI_GRE    ,
            VAL_IMP_ACC_GRE    ,
            VAL_IMP_UTI_LEG    ,
            VAL_IMP_ACC_LEG    ,
            COD_NATURA    ,
            DTA_RIFERIMENTO    ,
            MAU_GRP    ,
            MAU_CLI    ,
            VAL_IMP_GAR_CLI    ,
            DTA_SCADENZA_LDC_CLI    ,
            VAL_IMP_GAR_GRE    ,
            DTA_SCADENZA_LDC_GRE    ,
            VAL_IMP_GAR_LEG    ,
            DTA_SCADENZA_LDC_LEG    ,
            MAU_LEG

            )

            VALUES (
            ID_DPER    ,
            COD_SNDG    ,
            COD_FORMA_TECNICA    ,
            VAL_IMP_UTI_CLI    ,
            VAL_IMP_ACC_CLI    ,
            VAL_IMP_UTI_GRE    ,
            VAL_IMP_ACC_GRE    ,
            VAL_IMP_UTI_LEG    ,
            VAL_IMP_ACC_LEG    ,
            COD_NATURA    ,
            DTA_RIFERIMENTO    ,
            MAU_GRP    ,
            MAU_CLI    ,
            VAL_IMP_GAR_CLI    ,
            DTA_SCADENZA_LDC_CLI    ,
            VAL_IMP_GAR_GRE    ,
            DTA_SCADENZA_LDC_GRE    ,
            VAL_IMP_GAR_LEG    ,
            DTA_SCADENZA_LDC_LEG    ,
            MAU_LEG
                )

             when
             NUM_RECS > 1
             OR TRIM(TO_CHAR(ID_DPER)) IS NULL
             OR TRIM(TO_CHAR(COD_SNDG)) IS NULL
             OR TRIM(TO_CHAR(COD_FORMA_TECNICA)) IS NULL



             then
             INTO T_MCRE0_SC_VINCOLI_PCR_GB (
                ID_SEQ    ,
                ID_DPER    ,
                COD_SNDG    ,
                COD_FORMA_TECNICA    ,
                VAL_IMP_UTI_CLI    ,
                VAL_IMP_ACC_CLI    ,
                VAL_IMP_UTI_GRE    ,
                VAL_IMP_ACC_GRE    ,
                VAL_IMP_UTI_LEG    ,
                VAL_IMP_ACC_LEG    ,
                COD_NATURA    ,
                DTA_RIFERIMENTO    ,
                MAU_GRP    ,
                MAU_CLI    ,
                VAL_IMP_GAR_CLI    ,
                DTA_SCADENZA_LDC_CLI    ,
                VAL_IMP_GAR_GRE    ,
                DTA_SCADENZA_LDC_GRE    ,
                VAL_IMP_GAR_LEG    ,
                DTA_SCADENZA_LDC_LEG    ,
                MAU_LEG


                )

                VALUES (
                p_rec.SEQ_FLUSSO,
                ID_DPER    ,
                COD_SNDG    ,
                COD_FORMA_TECNICA    ,
                VAL_IMP_UTI_CLI    ,
                VAL_IMP_ACC_CLI    ,
                VAL_IMP_UTI_GRE    ,
                VAL_IMP_ACC_GRE    ,
                VAL_IMP_UTI_LEG    ,
                VAL_IMP_ACC_LEG    ,
                COD_NATURA    ,
                DTA_RIFERIMENTO    ,
                MAU_GRP    ,
                MAU_CLI    ,
                VAL_IMP_GAR_CLI    ,
                DTA_SCADENZA_LDC_CLI    ,
                VAL_IMP_GAR_GRE    ,
                DTA_SCADENZA_LDC_GRE    ,
                VAL_IMP_GAR_LEG    ,
                DTA_SCADENZA_LDC_LEG    ,
                MAU_LEG

                )


             select * from
        (
            SELECT
                COUNT(1) OVER(PARTITION BY  ID_DPER, COD_SNDG, COD_FORMA_TECNICA) NUM_RECS,
                    ID_DPER    ,
                    COD_SNDG    ,
                    COD_FORMA_TECNICA    ,
                    VAL_IMP_UTI_CLI    ,
                    VAL_IMP_ACC_CLI    ,
                    VAL_IMP_UTI_GRE    ,
                    VAL_IMP_ACC_GRE    ,
                    VAL_IMP_UTI_LEG    ,
                    VAL_IMP_ACC_LEG    ,
                    COD_NATURA    ,
                    DTA_RIFERIMENTO    ,
                    MAU_GRP    ,
                    MAU_CLI    ,
                    VAL_IMP_GAR_CLI    ,
                    DTA_SCADENZA_LDC_CLI    ,
                    VAL_IMP_GAR_GRE    ,
                    DTA_SCADENZA_LDC_GRE    ,
                    VAL_IMP_GAR_LEG    ,
                    DTA_SCADENZA_LDC_LEG    ,
                    MAU_LEG



            FROM
              T_MCRE0_FL_PCR_GB
        ) tmp;
        COMMIT;


          SELECT COUNT(*)
          INTO v_count
          FROM T_MCRE0_SC_VINCOLI_PCR_GB SC
          WHERE SC.ID_SEQ = p_rec.SEQ_FLUSSO;


          UPDATE T_MCRE0_WRK_ACQUISIZIONE
          SET SCARTI_VINCOLI = v_count
          WHERE ID_FLUSSO = p_rec.SEQ_FLUSSO;
          commit;



        b_flag := TRUE;


     END IF;

         IF(b_flag) THEN

        PKG_MCRE0_LOG.SPO_MCRE0_LOG_EVENTO(p_rec.SEQ_FLUSSO,c_nome,'OK','DATI INSERITI CORRETTAMENTE');

        END IF;

      --close v_cur;

           /*  BEGIN

                SELECT VALORE_COSTANTE INTO v_mesi_svecchiamento
                FROM T_MCRE0_WRK_CONFIGURAZIONE
                WHERE NOME_COSTANTE = 'MESI_SVECCHIAMENTO_PCR_GB';

            EXCEPTION

                WHEN OTHERS THEN

                    v_mesi_svecchiamento := 0;

                    PKG_MCRE0_LOG.SPO_MCRE0_LOG_EVENTO(p_rec.SEQ_FLUSSO,c_nome,'ATTENZIONE','Svecchiamento non eseguibile per problemi di rilevamento della costante ''MESI_SVECCHIAMENTO_PCR_GB'' nella tabella ''T_MCRE0_WRK_CONFIGURAZIONE''');

            END;

            IF(v_mesi_svecchiamento > 0) THEN

             b_flag := svecchiamento_p31(p_rec.SEQ_FLUSSO,p_rec.TAB_TRG,p_rec.PERIODO,v_mesi_svecchiamento);

            END IF;*/


        RETURN b_flag;


            EXCEPTION


        WHEN OTHERS THEN

        DBMS_OUTPUT.PUT_LINE('ERRORE IN FND_MCRE0_alimenta_PCR_GB');
         DBMS_OUTPUT.PUT_LINE(SUBSTR(SQLERRM, 1, 255));
            ROLLBACK;

           IF(v_cur%ISOPEN) THEN

                    CLOSE v_cur;

                     DBMS_OUTPUT.PUT_LINE('ERRORE IN FND_MCRE0_alimenta_PCR_GB - CLOSE CURSOR');

                END IF;

            PKG_MCRE0_LOG.SPO_MCRE0_log_evento_no_commit(p_rec.SEQ_FLUSSO,p_rec.TAB_TRG,'ERRORE',SUBSTR(SQLERRM, 1, 255));

            RETURN FALSE;

     END FND_MCRE0_alimenta_PCR_GB;

FUNCTION FND_MCRE0_alimenta_PCR_GB_AP(p_rec IN f_slave_par_type) RETURN BOOLEAN IS

  v_partition varchar2(20);
  v_sql varchar2(5000);


   begin


   v_partition := 'CCP_P'|| to_char(p_rec.PERIODO, 'yyyymmdd');

          v_sql :=  'BEGIN MERGE

               INTO  T_MCRE0_APP_PCR_GB24 trg

               USING T_MCRE0_ST_PCR_GB  PARTITION(' || v_partition || ') src

               ON  (
               trg.COD_SNDG=src.COD_SNDG and
               trg.COD_FORMA_TECNICA=src.COD_FORMA_TECNICA)

            WHEN MATCHED

            THEN

              UPDATE

              SET

                trg.VAL_IMP_UTI_CLI=src.VAL_IMP_UTI_CLI,
                trg.VAL_IMP_ACC_CLI=src.VAL_IMP_ACC_CLI,
                trg.VAL_IMP_UTI_GRE=src.VAL_IMP_UTI_GRE,
                trg.VAL_IMP_ACC_GRE=src.VAL_IMP_ACC_GRE,
                trg.VAL_IMP_UTI_LEG=src.VAL_IMP_UTI_LEG,
                trg.VAL_IMP_ACC_LEG=src.VAL_IMP_ACC_LEG,
                trg.COD_NATURA=src.COD_NATURA,
                trg.DTA_RIFERIMENTO=src.DTA_RIFERIMENTO,
                trg.MAU_GRP=src.MAU_GRP,
                trg.MAU_CLI=src.MAU_CLI,
                trg.VAL_IMP_GAR_CLI=src.VAL_IMP_GAR_CLI,
                trg.DTA_SCADENZA_LDC_CLI=src.DTA_SCADENZA_LDC_CLI,
                trg.VAL_IMP_GAR_GRE=src.VAL_IMP_GAR_GRE,
                trg.DTA_SCADENZA_LDC_GRE=src.DTA_SCADENZA_LDC_GRE,
                trg.VAL_IMP_GAR_LEG=src.VAL_IMP_GAR_LEG,
                trg.DTA_SCADENZA_LDC_LEG=src.DTA_SCADENZA_LDC_LEG,
                trg.MAU_LEG=src.MAU_LEG ,
                trg.DTA_UPD= sysdate,
                trg.COD_OPERATORE_INS_UPD = NULL,
                trg.ID_DPER = src.ID_DPER


           WHEN NOT MATCHED
           THEN
              INSERT (

                        trg.COD_SNDG,
                        trg.COD_FORMA_TECNICA,
                        trg.VAL_IMP_UTI_CLI,
                        trg.VAL_IMP_ACC_CLI,
                        trg.VAL_IMP_UTI_GRE,
                        trg.VAL_IMP_ACC_GRE,
                        trg.VAL_IMP_UTI_LEG,
                        trg.VAL_IMP_ACC_LEG,
                        trg.COD_NATURA,
                        trg.DTA_RIFERIMENTO,
                        trg.MAU_GRP,
                        trg.MAU_CLI,
                        trg.VAL_IMP_GAR_CLI,
                        trg.DTA_SCADENZA_LDC_CLI,
                        trg.VAL_IMP_GAR_GRE,
                        trg.DTA_SCADENZA_LDC_GRE,
                        trg.VAL_IMP_GAR_LEG,
                        trg.DTA_SCADENZA_LDC_LEG,
                        trg.MAU_LEG,
                        trg.DTA_INS    ,
                        trg.DTA_UPD    ,
                        trg.COD_OPERATORE_INS_UPD    ,
                        trg.ID_DPER

                        )

              VALUES (

                        src.COD_SNDG,
                        src.COD_FORMA_TECNICA,
                        src.VAL_IMP_UTI_CLI,
                        src.VAL_IMP_ACC_CLI,
                        src.VAL_IMP_UTI_GRE,
                        src.VAL_IMP_ACC_GRE,
                        src.VAL_IMP_UTI_LEG,
                        src.VAL_IMP_ACC_LEG,
                        src.COD_NATURA,
                        src.DTA_RIFERIMENTO,
                        src.MAU_GRP,
                        src.MAU_CLI,
                        src.VAL_IMP_GAR_CLI,
                        src.DTA_SCADENZA_LDC_CLI,
                        src.VAL_IMP_GAR_GRE,
                        src.DTA_SCADENZA_LDC_GRE,
                        src.VAL_IMP_GAR_LEG,
                        src.DTA_SCADENZA_LDC_LEG,
                        src.MAU_LEG,
                        sysdate,
                        sysdate,
                        NULL,
                        src.ID_DPER );

            commit;
            END;';


            DBMS_OUTPUT.PUT_LINE(v_sql);


              execute immediate v_sql;

              RETURN TRUE;


                EXCEPTION WHEN OTHERS THEN

                  DBMS_OUTPUT.PUT_LINE(SUBSTR(SQLERRM, 1, 255));

                       RETURN FALSE;



                end FND_MCRE0_alimenta_PCR_GB_AP;



FUNCTION FND_MCRE0_alimenta_PCR_GE_SB(p_rec IN f_slave_par_type) RETURN BOOLEAN IS

        c_nome CONSTANT VARCHAR2(100) := c_package || '.FND_MCRE0_alimenta_PCR_GE_SB';
        b_flag BOOLEAN;
        v_cur PKG_MCRE0_UTILS.cur_abi_type;
        v_count NUMBER;



   BEGIN

     DBMS_OUTPUT.PUT_LINE('INIZIALIZZO CURSORE X SOTTOPARTIZIONE COD_ABI');

     open v_cur for select distinct COD_ABI
     from T_MCRE0_APP_ISTITUTI;

       DBMS_OUTPUT.PUT_LINE('CURSORE X SOTTOPARTIZIONE COD_ABI INIZIALIZZATO');

     b_flag := PKG_MCRE0_PARTIZIONI.FND_MCRE0_add_partition(p_rec.SEQ_FLUSSO,p_rec.TAB_TRG,p_rec.PERIODO,v_cur);


     IF(b_flag) THEN


                  insert
             when
             NUM_RECS = 1
             AND TRIM(TO_CHAR(ID_DPER)) IS NOT NULL
             AND TRIM(TO_CHAR(COD_ABI_ISTITUTO)) IS NOT NULL
             AND TRIM(TO_CHAR(COD_SNDG)) IS NOT NULL
             AND TRIM(TO_CHAR(COD_FORMA_TECN)) IS NOT NULL


            then

            INTO T_MCRE0_ST_PCR_GE_SB (
            ID_DPER    ,
            COD_ABI_ISTITUTO    ,
            COD_SNDG    ,
            COD_FORMA_TECN ,
            VAL_IMP_GAR_GRE    ,
            VAL_IMP_UTI_GRE    ,
            VAL_IMP_ACC_GRE    ,
            DTA_RIFERIMENTO    ,
            COD_NATURA    ,
            DTA_SCADENZA_LDC
            )

            VALUES (
            ID_DPER    ,
            COD_ABI_ISTITUTO    ,
            COD_SNDG    ,
            COD_FORMA_TECN ,
            VAL_IMP_GAR_GRE    ,
            VAL_IMP_UTI_GRE    ,
            VAL_IMP_ACC_GRE    ,
            DTA_RIFERIMENTO    ,
            COD_NATURA    ,
            DTA_SCADENZA_LDC
                )

             when
             NUM_RECS > 1
             OR TRIM(TO_CHAR(ID_DPER)) IS NULL
             OR TRIM(TO_CHAR(COD_ABI_ISTITUTO)) IS NULL
             OR TRIM(TO_CHAR(COD_SNDG)) IS NULL
             OR TRIM(TO_CHAR(COD_FORMA_TECN)) IS NULL


             then
             INTO T_MCRE0_SC_VINCOLI_PCR_GE_SB (
                ID_SEQ    ,
                ID_DPER    ,
                COD_ABI_ISTITUTO    ,
                COD_SNDG    ,
                COD_FORMA_TECN ,
                VAL_IMP_GAR_GRE    ,
                VAL_IMP_UTI_GRE    ,
                VAL_IMP_ACC_GRE    ,
                DTA_RIFERIMENTO    ,
                COD_NATURA   ,
                DTA_SCADENZA_LDC
                )

                VALUES (
                p_rec.SEQ_FLUSSO,
                ID_DPER    ,
                COD_ABI_ISTITUTO    ,
                COD_SNDG    ,
                COD_FORMA_TECN ,
                VAL_IMP_GAR_GRE    ,
                VAL_IMP_UTI_GRE    ,
                VAL_IMP_ACC_GRE    ,
                DTA_RIFERIMENTO    ,
                COD_NATURA  ,
                DTA_SCADENZA_LDC)


             select * from
        (
            SELECT
                COUNT(1) OVER(PARTITION BY  ID_DPER, COD_ABI_ISTITUTO, COD_SNDG, COD_FORMA_TECN) NUM_RECS,
            ID_DPER    ,
            COD_ABI_ISTITUTO    ,
            COD_SNDG    ,
            COD_FORMA_TECN ,
            VAL_IMP_GAR_GRE    ,
            VAL_IMP_UTI_GRE    ,
            VAL_IMP_ACC_GRE    ,
            DTA_RIFERIMENTO    ,
            COD_NATURA    ,
            DTA_SCADENZA_LDC

            FROM
              T_MCRE0_FL_PCR_GE_SB
        ) tmp;
        COMMIT;

          SELECT COUNT(*)
          INTO v_count
          FROM T_MCRE0_SC_VINCOLI_PCR_GE_SB  SC
          WHERE SC.ID_SEQ = p_rec.SEQ_FLUSSO;


          UPDATE T_MCRE0_WRK_ACQUISIZIONE
          SET SCARTI_VINCOLI = v_count
          WHERE ID_FLUSSO = p_rec.SEQ_FLUSSO;
          commit;


        b_flag := TRUE;


     END IF;

         IF(b_flag) THEN

        PKG_MCRE0_LOG.SPO_MCRE0_LOG_EVENTO(p_rec.SEQ_FLUSSO,c_nome,'OK','DATI INSERITI CORRETTAMENTE');

        END IF;

      --close v_cur;

           /*  BEGIN

                SELECT VALORE_COSTANTE INTO v_mesi_svecchiamento
                FROM T_MCRE0_WRK_CONFIGURAZIONE
                WHERE NOME_COSTANTE = 'MESI_SVECCHIAMENTO_PCR_GE_SB';

            EXCEPTION

                WHEN OTHERS THEN

                    v_mesi_svecchiamento := 0;

                    PKG_MCRE0_LOG.SPO_MCRE0_LOG_EVENTO(p_rec.SEQ_FLUSSO,c_nome,'ATTENZIONE','Svecchiamento non eseguibile per problemi di rilevamento della costante ''MESI_SVECCHIAMENTO_PCR_GE_SB'' nella tabella ''T_MCRE0_WRK_CONFIGURAZIONE''');

            END;

            IF(v_mesi_svecchiamento > 0) THEN

             b_flag := svecchiamento_p31(p_rec.SEQ_FLUSSO,p_rec.TAB_TRG,p_rec.PERIODO,v_mesi_svecchiamento);

            END IF;*/


        RETURN b_flag;


            EXCEPTION


        WHEN OTHERS THEN

        DBMS_OUTPUT.PUT_LINE('ERRORE IN FND_MCRE0_alimenta_PCR_GE_SB');
         DBMS_OUTPUT.PUT_LINE(SUBSTR(SQLERRM, 1, 255));
            ROLLBACK;

           IF(v_cur%ISOPEN) THEN

                    CLOSE v_cur;

                     DBMS_OUTPUT.PUT_LINE('ERRORE IN FND_MCRE0_alimenta_PCR_GE_SB - CLOSE CURSOR');

                END IF;

            PKG_MCRE0_LOG.SPO_MCRE0_log_evento_no_commit(p_rec.SEQ_FLUSSO,p_rec.TAB_TRG,'ERRORE',SUBSTR(SQLERRM, 1, 255));

            RETURN FALSE;

     END FND_MCRE0_alimenta_PCR_GE_SB;



FUNCTION FND_MCRE0_alim_PCR_GE_SB_AP(p_rec IN f_slave_par_type) RETURN BOOLEAN IS

  v_partition varchar2(20);
  v_sql varchar2(5000);


   begin


   v_partition := 'CCP_P'|| to_char(p_rec.PERIODO, 'yyyymmdd');

          v_sql :=  'BEGIN MERGE

               INTO  T_MCRE0_APP_PCR_GE_SB24 trg

               USING T_MCRE0_ST_PCR_GE_SB  PARTITION(' || v_partition || ') src

               ON  (trg.COD_ABI_ISTITUTO=src.COD_ABI_ISTITUTO
               and trg.COD_SNDG=src.COD_SNDG
               and trg.COD_FORMA_TECN=src.COD_FORMA_TECN)

            WHEN MATCHED

            THEN

              UPDATE

              SET

                trg.VAL_IMP_GAR_GRE=src.VAL_IMP_GAR_GRE,
                trg.VAL_IMP_UTI_GRE=src.VAL_IMP_UTI_GRE,
                trg.VAL_IMP_ACC_GRE=src.VAL_IMP_ACC_GRE,
                trg.DTA_RIFERIMENTO=src.DTA_RIFERIMENTO,
                trg.COD_NATURA=src.COD_NATURA,
                trg.DTA_SCADENZA_LDC=src.DTA_SCADENZA_LDC,
                trg.DTA_UPD= sysdate,
                trg.COD_OPERATORE_INS_UPD = NULL,
                trg.ID_DPER = src.ID_DPER



           WHEN NOT MATCHED
           THEN
              INSERT (  trg.COD_FORMA_TECN ,
                        trg.COD_ABI_ISTITUTO,
                        trg.COD_SNDG,
                        trg.VAL_IMP_GAR_GRE,
                        trg.VAL_IMP_UTI_GRE,
                        trg.VAL_IMP_ACC_GRE,
                        trg.DTA_RIFERIMENTO,
                        trg.COD_NATURA,
                        trg.DTA_SCADENZA_LDC,
                        trg.DTA_INS    ,
                        trg.DTA_UPD    ,
                        trg.COD_OPERATORE_INS_UPD    ,
                        trg.ID_DPER

                        )

              VALUES (  src.COD_FORMA_TECN ,
                        src.COD_ABI_ISTITUTO,
                        src.COD_SNDG,
                        src.VAL_IMP_GAR_GRE,
                        src.VAL_IMP_UTI_GRE,
                        src.VAL_IMP_ACC_GRE,
                        src.DTA_RIFERIMENTO,
                        src.COD_NATURA,
                        src.DTA_SCADENZA_LDC,
                        sysdate,
                        sysdate,
                        NULL,
                        src.ID_DPER );

            commit;
            END;';


            DBMS_OUTPUT.PUT_LINE(v_sql);


              execute immediate v_sql;

              RETURN TRUE;


                EXCEPTION WHEN OTHERS THEN

                  DBMS_OUTPUT.PUT_LINE(SUBSTR(SQLERRM, 1, 255));

                    RETURN false;

                end FND_MCRE0_alim_PCR_GE_SB_AP;



FUNCTION FND_MCRE0_alimenta_RICH_MON(p_rec IN f_slave_par_type) RETURN BOOLEAN IS

        c_nome CONSTANT VARCHAR2(100) := c_package || '.FND_MCRE0_alimenta_RICH_MON';
        b_flag BOOLEAN;
        v_cur PKG_MCRE0_UTILS.cur_abi_type;
        v_count NUMBER;



   BEGIN

     DBMS_OUTPUT.PUT_LINE('INIZIALIZZO CURSORE X SOTTOPARTIZIONE COD_ABI');

     open v_cur for select distinct COD_ABI
     from T_MCRE0_APP_ISTITUTI;

       DBMS_OUTPUT.PUT_LINE('CURSORE X SOTTOPARTIZIONE COD_ABI INIZIALIZZATO');

     b_flag := PKG_MCRE0_PARTIZIONI.FND_MCRE0_add_partition(p_rec.SEQ_FLUSSO,p_rec.TAB_TRG,p_rec.PERIODO,v_cur);


     IF(b_flag) THEN


                  insert
             when
             NUM_RECS = 1
             AND TRIM(TO_CHAR(ID_DPER)) IS NOT NULL
             AND TRIM(TO_CHAR(COD_SNDG)) IS NOT NULL



            then

            INTO T_MCRE0_ST_RICH_MON (
            ID_DPER    ,
            COD_SNDG
            )
            VALUES (
            ID_DPER    ,
            COD_SNDG)

             when
             NUM_RECS > 1
             OR TRIM(TO_CHAR(ID_DPER)) IS NULL
             OR TRIM(TO_CHAR(COD_SNDG)) IS NULL


             then
             INTO T_MCRE0_SC_VINCOLI_RICH_MON (
                ID_SEQ    ,
                ID_DPER    ,
                COD_SNDG
                )

                VALUES (
                p_rec.SEQ_FLUSSO,
                ID_DPER    ,
                COD_SNDG    )


             select * from
        (
            SELECT
                COUNT(1) OVER(PARTITION BY  ID_DPER, COD_SNDG) NUM_RECS,
                ID_DPER    ,
                COD_SNDG

            FROM
              T_MCRE0_FL_RICH_MON
        ) tmp;
        COMMIT;

           SELECT COUNT(*)
          INTO v_count
          FROM T_MCRE0_SC_VINCOLI_RICH_MON   SC
          WHERE SC.ID_SEQ = p_rec.SEQ_FLUSSO;


          UPDATE T_MCRE0_WRK_ACQUISIZIONE
          SET SCARTI_VINCOLI = v_count
          WHERE ID_FLUSSO = p_rec.SEQ_FLUSSO;
          commit;



        b_flag := TRUE;


     END IF;

         IF(b_flag) THEN

        PKG_MCRE0_LOG.SPO_MCRE0_LOG_EVENTO(p_rec.SEQ_FLUSSO,c_nome,'OK','DATI INSERITI CORRETTAMENTE');

        END IF;

      --close v_cur;

           /*  BEGIN

                SELECT VALORE_COSTANTE INTO v_mesi_svecchiamento
                FROM T_MCRE0_WRK_CONFIGURAZIONE
                WHERE NOME_COSTANTE = 'MESI_SVECCHIAMENTO_RICH_MON';

            EXCEPTION

                WHEN OTHERS THEN

                    v_mesi_svecchiamento := 0;

                    PKG_MCRE0_LOG.SPO_MCRE0_LOG_EVENTO(p_rec.SEQ_FLUSSO,c_nome,'ATTENZIONE','Svecchiamento non eseguibile per problemi di rilevamento della costante ''MESI_SVECCHIAMENTO_RICH_MON'' nella tabella ''T_MCRE0_WRK_CONFIGURAZIONE''');

            END;

            IF(v_mesi_svecchiamento > 0) THEN

             b_flag := svecchiamento_p31(p_rec.SEQ_FLUSSO,p_rec.TAB_TRG,p_rec.PERIODO,v_mesi_svecchiamento);

            END IF;*/


        RETURN b_flag;


            EXCEPTION


        WHEN OTHERS THEN

        DBMS_OUTPUT.PUT_LINE('ERRORE IN FND_MCRE0_alimenta_RICH_MON');
         DBMS_OUTPUT.PUT_LINE(SUBSTR(SQLERRM, 1, 255));
            ROLLBACK;

           IF(v_cur%ISOPEN) THEN

                    CLOSE v_cur;

                     DBMS_OUTPUT.PUT_LINE('ERRORE IN FND_MCRE0_alimenta_RICH_MON - CLOSE CURSOR');

                END IF;

            PKG_MCRE0_LOG.SPO_MCRE0_log_evento_no_commit(p_rec.SEQ_FLUSSO,p_rec.TAB_TRG,'ERRORE',SUBSTR(SQLERRM, 1, 255));

            RETURN FALSE;

     END FND_MCRE0_alimenta_RICH_MON;


FUNCTION FND_MCRE0_alim_RICH_MON_AP(p_rec IN f_slave_par_type) RETURN BOOLEAN IS

  v_partition varchar2(20);
  v_sql varchar2(5000);


   begin


   v_partition := 'CCP_P'|| to_char(p_rec.PERIODO, 'yyyymmdd');

          v_sql :=  'BEGIN MERGE

               INTO  T_MCRE0_APP_RICH_MON trg

               USING T_MCRE0_ST_RICH_MON  PARTITION(' || v_partition || ') src

               ON  ( trg.COD_SNDG=src.COD_SNDG)

            WHEN MATCHED

            THEN

              UPDATE

              SET

                trg.DTA_UPD= sysdate,
                trg.COD_OPERATORE_INS_UPD = NULL,
                trg.ID_DPER = src.ID_DPER



           WHEN NOT MATCHED
           THEN
              INSERT (

                        trg.COD_SNDG,
                        trg.DTA_INS    ,
                        trg.DTA_UPD    ,
                        trg.COD_OPERATORE_INS_UPD    ,
                        trg.ID_DPER

                        )

              VALUES (  src.COD_SNDG,
                        sysdate,
                        sysdate,
                        NULL,
                        src.ID_DPER );

            commit;
            END;';


            DBMS_OUTPUT.PUT_LINE(v_sql);


              execute immediate v_sql;

              RETURN TRUE;


                EXCEPTION WHEN OTHERS THEN

                  DBMS_OUTPUT.PUT_LINE(SUBSTR(SQLERRM, 1, 255));



                end FND_MCRE0_alim_RICH_MON_AP;


/*FUNCTION FND_MCRE0_alimenta_CR(p_rec IN f_slave_par_type) RETURN BOOLEAN IS

        c_nome CONSTANT VARCHAR2(100) := c_package || '.FND_MCRE0_alimenta_CR';
        b_flag BOOLEAN;
        v_cur PKG_MCRE0_UTILS.cur_abi_type;
        v_count NUMBER;



   BEGIN

     DBMS_OUTPUT.PUT_LINE('INIZIALIZZO CURSORE X SOTTOPARTIZIONE COD_ABI');

     open v_cur for select distinct COD_ABI
     from T_MCRE0_APP_ISTITUTI;

       DBMS_OUTPUT.PUT_LINE('CURSORE X SOTTOPARTIZIONE COD_ABI INIZIALIZZATO');

     b_flag := PKG_MCRE0_PARTIZIONI.FND_MCRE0_add_partition(p_rec.SEQ_FLUSSO,p_rec.TAB_TRG,p_rec.PERIODO,v_cur);


     IF(b_flag) THEN


                  insert
             when
             NUM_RECS = 1
             AND TRIM(TO_CHAR(ID_DPER)) IS NOT NULL
             AND TRIM(TO_CHAR(COD_NDG)) IS NOT NULL



            then

            INTO T_MCRE0_ST_CR (
            ID_DPER    ,
            COD_ABI_ISTITUTO    ,
            COD_NDG    ,
            DTA_SISTEMA    ,
            STATO_SISTEMA

            )
            VALUES (
            ID_DPER    ,
            COD_ABI_ISTITUTO    ,
            COD_NDG    ,
            DTA_SISTEMA    ,
            STATO_SISTEMA    )

             when
             NUM_RECS > 1
             OR TRIM(TO_CHAR(ID_DPER)) IS NULL
             OR TRIM(TO_CHAR(COD_NDG)) IS NULL



             then
             INTO T_MCRE0_SC_VINCOLI_CR (
                ID_SEQ    ,
                ID_DPER    ,
                COD_ABI_ISTITUTO    ,
                COD_NDG    ,
                DTA_SISTEMA    ,
                STATO_SISTEMA
                )

                VALUES (
                p_rec.SEQ_FLUSSO,
                ID_DPER    ,
                COD_ABI_ISTITUTO    ,
                COD_NDG    ,
                DTA_SISTEMA    ,
                STATO_SISTEMA)


             select * from
        (
            SELECT
                COUNT(1) OVER(PARTITION BY  ID_DPER, COD_NDG) NUM_RECS,
                ID_DPER    ,
                COD_ABI_ISTITUTO    ,
                COD_NDG    ,
                DTA_SISTEMA    ,
                STATO_SISTEMA

            FROM
              T_MCRE0_FL_CR
        ) tmp;
        COMMIT;


         SELECT COUNT(*)
          INTO v_count
          FROM T_MCRE0_SC_VINCOLI_CR   SC
          WHERE SC.ID_SEQ = p_rec.SEQ_FLUSSO;


          UPDATE T_MCRE0_WRK_ACQUISIZIONE
          SET SCARTI_VINCOLI = v_count
          WHERE ID_FLUSSO = p_rec.SEQ_FLUSSO;
          commit;



        b_flag := TRUE;


     END IF;

         IF(b_flag) THEN

        PKG_MCRE0_LOG.SPO_MCRE0_LOG_EVENTO(p_rec.SEQ_FLUSSO,c_nome,'OK','DATI INSERITI CORRETTAMENTE');

        END IF;

      --close v_cur;

           /*  BEGIN

                SELECT VALORE_COSTANTE INTO v_mesi_svecchiamento
                FROM T_MCRE0_WRK_CONFIGURAZIONE
                WHERE NOME_COSTANTE = 'MESI_SVECCHIAMENTO_CR';

            EXCEPTION

                WHEN OTHERS THEN

                    v_mesi_svecchiamento := 0;

                    PKG_MCRE0_LOG.SPO_MCRE0_LOG_EVENTO(p_rec.SEQ_FLUSSO,c_nome,'ATTENZIONE','Svecchiamento non eseguibile per problemi di rilevamento della costante ''MESI_SVECCHIAMENTO_CR'' nella tabella ''T_MCRE0_WRK_CONFIGURAZIONE''');

            END;

            IF(v_mesi_svecchiamento > 0) THEN

             b_flag := svecchiamento_p31(p_rec.SEQ_FLUSSO,p_rec.TAB_TRG,p_rec.PERIODO,v_mesi_svecchiamento);

            END IF;*/


    /*    RETURN b_flag;


            EXCEPTION


        WHEN OTHERS THEN

        DBMS_OUTPUT.PUT_LINE('ERRORE IN FND_MCRE0_alimenta_CR');
         DBMS_OUTPUT.PUT_LINE(SUBSTR(SQLERRM, 1, 255));
            ROLLBACK;

           IF(v_cur%ISOPEN) THEN

                    CLOSE v_cur;

                     DBMS_OUTPUT.PUT_LINE('ERRORE IN FND_MCRE0_alimenta_CR - CLOSE CURSOR');

                END IF;

            PKG_MCRE0_LOG.SPO_MCRE0_log_evento_no_commit(p_rec.SEQ_FLUSSO,p_rec.TAB_TRG,'ERRORE',SUBSTR(SQLERRM, 1, 255));

            RETURN FALSE;

     END FND_MCRE0_alimenta_CR;


FUNCTION FND_MCRE0_alimenta_CR_AP(p_rec IN f_slave_par_type) RETURN BOOLEAN IS

  v_partition varchar2(20);
  v_sql varchar2(5000);


   begin


   v_partition := 'CCP_P'|| to_char(p_rec.PERIODO, 'yyyymmdd');

          v_sql :=  'BEGIN MERGE

               INTO  T_MCRE0_APP_CR trg

               USING T_MCRE0_ST_CR  PARTITION(' || v_partition || ') src

               ON  (src.COD_NDG = trg.COD_NDG)

            WHEN MATCHED

            THEN

              UPDATE

              SET

                trg.COD_ABI_ISTITUTO=src.COD_ABI_ISTITUTO,
                trg.COD_NDG=src.COD_NDG,
                trg.DTA_SISTEMA=src.DTA_SISTEMA,
                trg.STATO_SISTEMA=src.STATO_SISTEMA,
                trg.DTA_UPD= sysdate,
                trg.COD_OPERATORE_INS_UPD = NULL,
                trg.ID_DPER = src.ID_DPER


           WHEN NOT MATCHED
           THEN
              INSERT (  trg.COD_ABI_ISTITUTO,
                        trg.COD_NDG,
                        trg.DTA_SISTEMA,
                        trg.STATO_SISTEMA,
                        trg.DTA_INS,
                        trg.DTA_UPD,
                        trg.COD_OPERATORE_INS_UPD,
                        trg.ID_DPER

                        )



              VALUES (  src.COD_ABI_ISTITUTO,
                        src.COD_NDG,
                        src.DTA_SISTEMA,
                        src.STATO_SISTEMA,
                        sysdate,
                        sysdate,
                        NULL,
                        src.ID_DPER );

            commit;
            END;';


            DBMS_OUTPUT.PUT_LINE(v_sql);


              execute immediate v_sql;

              RETURN TRUE;


                EXCEPTION WHEN OTHERS THEN

                  DBMS_OUTPUT.PUT_LINE(SUBSTR(SQLERRM, 1, 255));



                end FND_MCRE0_alimenta_CR_AP;


FUNCTION FND_MCRE0_alimenta_CR_SNDG(p_rec IN f_slave_par_type) RETURN BOOLEAN IS

        c_nome CONSTANT VARCHAR2(100) := c_package || '.FND_MCRE0_alimenta_CR_SNDG';
        b_flag BOOLEAN;
        v_cur PKG_MCRE0_UTILS.cur_abi_type;
        v_count NUMBER;



   BEGIN

     DBMS_OUTPUT.PUT_LINE('INIZIALIZZO CURSORE X SOTTOPARTIZIONE COD_ABI');

     open v_cur for select distinct COD_ABI
     from T_MCRE0_APP_ISTITUTI;

       DBMS_OUTPUT.PUT_LINE('CURSORE X SOTTOPARTIZIONE COD_ABI INIZIALIZZATO');

     b_flag := PKG_MCRE0_PARTIZIONI.FND_MCRE0_add_partition(p_rec.SEQ_FLUSSO,p_rec.TAB_TRG,p_rec.PERIODO,v_cur);


     IF(b_flag) THEN


                  insert
             when
             NUM_RECS = 1
             AND TRIM(TO_CHAR(ID_DPER)) IS NOT NULL
             AND TRIM(TO_CHAR(COD_SNDG)) IS NOT NULL



            then

            INTO T_MCRE0_ST_CR_SNDG (
            ID_DPER    ,
            COD_SNDG    ,
            COD_GRE    ,
            DTA_SISTEMA    ,
            STATO_SISTEMA    ,
            VAL_IMP_UTI_CLI    ,
            VAL_IMP_ACC_CLI    ,
            VAL_IMP_GAR_CLI    ,
            DTA_RIFERIMENTO_CLI    ,
            VAL_IMP_UTI_SIS    ,
            VAL_IMP_ACC_SIS    ,
            VAL_IMP_GAR_SIS    ,
            DTA_RIFERIMENTO_SIS


            )
            VALUES (
            ID_DPER    ,
            COD_SNDG    ,
            COD_GRE    ,
            DTA_SISTEMA    ,
            STATO_SISTEMA    ,
            VAL_IMP_UTI_CLI    ,
            VAL_IMP_ACC_CLI    ,
            VAL_IMP_GAR_CLI    ,
            DTA_RIFERIMENTO_CLI    ,
            VAL_IMP_UTI_SIS    ,
            VAL_IMP_ACC_SIS    ,
            VAL_IMP_GAR_SIS    ,
            DTA_RIFERIMENTO_SIS
               )

             when
             NUM_RECS > 1
             OR TRIM(TO_CHAR(ID_DPER)) IS NULL
             OR TRIM(TO_CHAR(COD_SNDG)) IS NULL



             then
             INTO T_MCRE0_SC_VINCOLI_CR_SNDG (
                ID_SEQ,
                ID_DPER    ,
                COD_SNDG    ,
                COD_GRE    ,
                DTA_SISTEMA    ,
                STATO_SISTEMA    ,
                VAL_IMP_UTI_CLI    ,
                VAL_IMP_ACC_CLI    ,
                VAL_IMP_GAR_CLI    ,
                DTA_RIFERIMENTO_CLI    ,
                VAL_IMP_UTI_SIS    ,
                VAL_IMP_ACC_SIS    ,
                VAL_IMP_GAR_SIS    ,
                DTA_RIFERIMENTO_SIS
                )

                VALUES (
                p_rec.SEQ_FLUSSO,
                ID_DPER    ,
                COD_SNDG    ,
                COD_GRE    ,
                DTA_SISTEMA    ,
                STATO_SISTEMA    ,
                VAL_IMP_UTI_CLI    ,
                VAL_IMP_ACC_CLI    ,
                VAL_IMP_GAR_CLI    ,
                DTA_RIFERIMENTO_CLI    ,
                VAL_IMP_UTI_SIS    ,
                VAL_IMP_ACC_SIS    ,
                VAL_IMP_GAR_SIS    ,
                DTA_RIFERIMENTO_SIS    )


             select * from
        (
            SELECT
                COUNT(1) OVER(PARTITION BY  ID_DPER, COD_SNDG) NUM_RECS,
                ID_DPER    ,
                COD_SNDG    ,
                COD_GRE    ,
                DTA_SISTEMA    ,
                STATO_SISTEMA    ,
                VAL_IMP_UTI_CLI    ,
                VAL_IMP_ACC_CLI    ,
                VAL_IMP_GAR_CLI    ,
                DTA_RIFERIMENTO_CLI    ,
                VAL_IMP_UTI_SIS    ,
                VAL_IMP_ACC_SIS    ,
                VAL_IMP_GAR_SIS    ,
                DTA_RIFERIMENTO_SIS

            FROM
              T_MCRE0_FL_CR_SNDG
        ) tmp;
        COMMIT;

        b_flag := TRUE;


     END IF;

         IF(b_flag) THEN

        PKG_MCRE0_LOG.SPO_MCRE0_LOG_EVENTO(p_rec.SEQ_FLUSSO,c_nome,'OK','DATI INSERITI CORRETTAMENTE');

        END IF;

      --close v_cur;

           /*  BEGIN

                SELECT VALORE_COSTANTE INTO v_mesi_svecchiamento
                FROM T_MCRE0_WRK_CONFIGURAZIONE
                WHERE NOME_COSTANTE = 'MESI_SVECCHIAMENTO_CR_SNDG';

            EXCEPTION

                WHEN OTHERS THEN

                    v_mesi_svecchiamento := 0;

                    PKG_MCRE0_LOG.SPO_MCRE0_LOG_EVENTO(p_rec.SEQ_FLUSSO,c_nome,'ATTENZIONE','Svecchiamento non eseguibile per problemi di rilevamento della costante ''MESI_SVECCHIAMENTO_CR_SNDG'' nella tabella ''T_MCRE0_WRK_CONFIGURAZIONE''');

            END;

            IF(v_mesi_svecchiamento > 0) THEN

             b_flag := svecchiamento_p31(p_rec.SEQ_FLUSSO,p_rec.TAB_TRG,p_rec.PERIODO,v_mesi_svecchiamento);

            END IF;*/


 /*       RETURN b_flag;


            EXCEPTION


        WHEN OTHERS THEN

        DBMS_OUTPUT.PUT_LINE('ERRORE IN FND_MCRE0_alimenta_CR_SNDG');
         DBMS_OUTPUT.PUT_LINE(SUBSTR(SQLERRM, 1, 255));
            ROLLBACK;

           IF(v_cur%ISOPEN) THEN

                    CLOSE v_cur;

                     DBMS_OUTPUT.PUT_LINE('ERRORE IN FND_MCRE0_alimenta_CR_SNDG - CLOSE CURSOR');

                END IF;

            PKG_MCRE0_LOG.SPO_MCRE0_log_evento_no_commit(p_rec.SEQ_FLUSSO,p_rec.TAB_TRG,'ERRORE',SUBSTR(SQLERRM, 1, 255));

            RETURN FALSE;

     END FND_MCRE0_alimenta_CR_SNDG;


FUNCTION FND_MCRE0_alimenta_CR_SNDG_AP(p_rec IN f_slave_par_type) RETURN BOOLEAN IS

  v_partition varchar2(20);
  v_sql varchar2(5000);


   begin


   v_partition := 'CCP_P'|| to_char(p_rec.PERIODO, 'yyyymmdd');

          v_sql :=  'BEGIN MERGE

               INTO  T_MCRE0_APP_CR_SNDG trg

               USING T_MCRE0_ST_CR_SNDG  PARTITION(' || v_partition || ') src

               ON  (src.COD_SNDG = trg.COD_SNDG)

            WHEN MATCHED

            THEN

              UPDATE

              SET
                trg.COD_GRE=src.COD_GRE,
                trg.DTA_SISTEMA=src.DTA_SISTEMA,
                trg.STATO_SISTEMA=src.STATO_SISTEMA,
                trg.VAL_IMP_UTI_CLI=src.VAL_IMP_UTI_CLI,
                trg.VAL_IMP_ACC_CLI=src.VAL_IMP_ACC_CLI,
                trg.VAL_IMP_GAR_CLI=src.VAL_IMP_GAR_CLI,
                trg.DTA_RIFERIMENTO_CLI=src.DTA_RIFERIMENTO_CLI,
                trg.VAL_IMP_UTI_SIS=src.VAL_IMP_UTI_SIS,
                trg.VAL_IMP_ACC_SIS=src.VAL_IMP_ACC_SIS,
                trg.VAL_IMP_GAR_SIS=src.VAL_IMP_GAR_SIS,
                trg.DTA_RIFERIMENTO_SIS=src.DTA_RIFERIMENTO_SIS,
                trg.DTA_UPD= sysdate,
                trg.COD_OPERATORE_INS_UPD = NULL,
                trg.ID_DPER = src.ID_DPER


           WHEN NOT MATCHED
           THEN
              INSERT (
                        trg.COD_SNDG,
                        trg.COD_GRE,
                        trg.DTA_SISTEMA,
                        trg.STATO_SISTEMA,
                        trg.VAL_IMP_UTI_CLI,
                        trg.VAL_IMP_ACC_CLI,
                        trg.VAL_IMP_GAR_CLI,
                        trg.DTA_RIFERIMENTO_CLI,
                        trg.VAL_IMP_UTI_SIS,
                        trg.VAL_IMP_ACC_SIS,
                        trg.VAL_IMP_GAR_SIS,
                        trg.DTA_RIFERIMENTO_SIS,
                        trg.DTA_INS,
                        trg.DTA_UPD,
                        trg.COD_OPERATORE_INS_UPD,
                        trg.ID_DPER

                        )



              VALUES (
                        src.COD_SNDG,
                        src.COD_GRE,
                        src.DTA_SISTEMA,
                        src.STATO_SISTEMA,
                        src.VAL_IMP_UTI_CLI,
                        src.VAL_IMP_ACC_CLI,
                        src.VAL_IMP_GAR_CLI,
                        src.DTA_RIFERIMENTO_CLI,
                        src.VAL_IMP_UTI_SIS,
                        src.VAL_IMP_ACC_SIS,
                        src.VAL_IMP_GAR_SIS,
                        src.DTA_RIFERIMENTO_SIS,
                        sysdate,
                        sysdate,
                        NULL,
                        src.ID_DPER );

            commit;
            END;';


            DBMS_OUTPUT.PUT_LINE(v_sql);


              execute immediate v_sql;

              RETURN TRUE;


                EXCEPTION WHEN OTHERS THEN

                  DBMS_OUTPUT.PUT_LINE(SUBSTR(SQLERRM, 1, 255));



                end FND_MCRE0_alimenta_CR_SNDG_AP;


FUNCTION FND_MCRE0_alimenta_CR_SNDG_GE(p_rec IN f_slave_par_type) RETURN BOOLEAN IS

        c_nome CONSTANT VARCHAR2(100) := c_package || '.FND_MCRE0_alimenta_CR_SNDG_GE';
        b_flag BOOLEAN;
        v_cur PKG_MCRE0_UTILS.cur_abi_type;
        v_count NUMBER;



   BEGIN

     DBMS_OUTPUT.PUT_LINE('INIZIALIZZO CURSORE X SOTTOPARTIZIONE COD_ABI');

     open v_cur for select distinct COD_ABI
     from T_MCRE0_APP_ISTITUTI;

       DBMS_OUTPUT.PUT_LINE('CURSORE X SOTTOPARTIZIONE COD_ABI INIZIALIZZATO');

     b_flag := PKG_MCRE0_PARTIZIONI.FND_MCRE0_add_partition(p_rec.SEQ_FLUSSO,p_rec.TAB_TRG,p_rec.PERIODO,v_cur);


     IF(b_flag) THEN


                  insert
             when
             NUM_RECS = 1
             AND TRIM(TO_CHAR(ID_DPER)) IS NOT NULL
             AND TRIM(TO_CHAR(COD_GRE)) IS NOT NULL



            then

            INTO T_MCRE0_ST_CR_SNDG_GE (
                ID_DPER    ,
                COD_GRE    ,
                VAL_IMP_UTI_SIS    ,
                VAL_IMP_ACC_SIS    ,
                VAL_IMP_GAR_SIS    ,
                DTA_RIFERIMENTO_SIS    ,
                VAL_IMP_UTI_GRE    ,
                VAL_IMP_ACC_GRE    ,
                VAL_IMP_GAR_GRE    ,
                DTA_RIFERIMENTO_GRE
            )


            VALUES (
                ID_DPER    ,
                COD_GRE    ,
                VAL_IMP_UTI_SIS    ,
                VAL_IMP_ACC_SIS    ,
                VAL_IMP_GAR_SIS    ,
                DTA_RIFERIMENTO_SIS    ,
                VAL_IMP_UTI_GRE    ,
                VAL_IMP_ACC_GRE    ,
                VAL_IMP_GAR_GRE    ,
                DTA_RIFERIMENTO_GRE

               )

             when
             NUM_RECS > 1
             OR TRIM(TO_CHAR(ID_DPER)) IS NULL
             OR TRIM(TO_CHAR(COD_GRE)) IS NULL



             then
             INTO T_MCRE0_SC_VINC_CR_SNDG_GE (
                ID_SEQ,
                ID_DPER    ,
                COD_GRE    ,
                VAL_IMP_UTI_SIS    ,
                VAL_IMP_ACC_SIS    ,
                VAL_IMP_GAR_SIS    ,
                DTA_RIFERIMENTO_SIS    ,
                VAL_IMP_UTI_GRE    ,
                VAL_IMP_ACC_GRE    ,
                VAL_IMP_GAR_GRE    ,
                DTA_RIFERIMENTO_GRE

                )

                VALUES (
                p_rec.SEQ_FLUSSO,
                ID_DPER    ,
                COD_GRE    ,
                VAL_IMP_UTI_SIS    ,
                VAL_IMP_ACC_SIS    ,
                VAL_IMP_GAR_SIS    ,
                DTA_RIFERIMENTO_SIS    ,
                VAL_IMP_UTI_GRE    ,
                VAL_IMP_ACC_GRE    ,
                VAL_IMP_GAR_GRE    ,
                DTA_RIFERIMENTO_GRE
                )


             select * from
        (
            SELECT
                COUNT(1) OVER(PARTITION BY  ID_DPER, COD_GRE) NUM_RECS,
                ID_DPER    ,
                COD_GRE    ,
                VAL_IMP_UTI_SIS    ,
                VAL_IMP_ACC_SIS    ,
                VAL_IMP_GAR_SIS    ,
                DTA_RIFERIMENTO_SIS    ,
                VAL_IMP_UTI_GRE    ,
                VAL_IMP_ACC_GRE    ,
                VAL_IMP_GAR_GRE    ,
                DTA_RIFERIMENTO_GRE


            FROM
              T_MCRE0_FL_CR_SNDG_GE
        ) tmp;
        COMMIT;



         SELECT COUNT(*)
          INTO v_count
          FROM T_MCRE0_SC_VINC_CR_SNDG_GE    SC
          WHERE SC.ID_SEQ = p_rec.SEQ_FLUSSO;


          UPDATE T_MCRE0_WRK_ACQUISIZIONE
          SET SCARTI_VINCOLI = v_count
          WHERE ID_FLUSSO = p_rec.SEQ_FLUSSO;
          commit;




        b_flag := TRUE;


     END IF;

         IF(b_flag) THEN

        PKG_MCRE0_LOG.SPO_MCRE0_LOG_EVENTO(p_rec.SEQ_FLUSSO,c_nome,'OK','DATI INSERITI CORRETTAMENTE');

        END IF;

      --close v_cur;

           /*  BEGIN

                SELECT VALORE_COSTANTE INTO v_mesi_svecchiamento
                FROM T_MCRE0_WRK_CONFIGURAZIONE
                WHERE NOME_COSTANTE = 'MESI_SVECCHIAMENTO_CR_SNDG_GE';

            EXCEPTION

                WHEN OTHERS THEN

                    v_mesi_svecchiamento := 0;

                    PKG_MCRE0_LOG.SPO_MCRE0_LOG_EVENTO(p_rec.SEQ_FLUSSO,c_nome,'ATTENZIONE','Svecchiamento non eseguibile per problemi di rilevamento della costante ''MESI_SVECCHIAMENTO_CR_SNDG_GE'' nella tabella ''T_MCRE0_WRK_CONFIGURAZIONE''');

            END;

            IF(v_mesi_svecchiamento > 0) THEN

             b_flag := svecchiamento_p31(p_rec.SEQ_FLUSSO,p_rec.TAB_TRG,p_rec.PERIODO,v_mesi_svecchiamento);

            END IF;*/


 /*       RETURN b_flag;


            EXCEPTION


        WHEN OTHERS THEN

        DBMS_OUTPUT.PUT_LINE('ERRORE IN FND_MCRE0_alimenta_CR_SNDG_GE');
         DBMS_OUTPUT.PUT_LINE(SUBSTR(SQLERRM, 1, 255));
            ROLLBACK;

           IF(v_cur%ISOPEN) THEN

                    CLOSE v_cur;

                     DBMS_OUTPUT.PUT_LINE('ERRORE IN FND_MCRE0_alimenta_CR_SNDG_GE - CLOSE CURSOR');

                END IF;

            PKG_MCRE0_LOG.SPO_MCRE0_log_evento_no_commit(p_rec.SEQ_FLUSSO,p_rec.TAB_TRG,'ERRORE',SUBSTR(SQLERRM, 1, 255));

            RETURN FALSE;

     END FND_MCRE0_alimenta_CR_SNDG_GE;


FUNCTION FND_MCRE0_alim_CR_SNDG_GE_AP(p_rec IN f_slave_par_type) RETURN BOOLEAN IS

  v_partition varchar2(20);
  v_sql varchar2(5000);


   begin


   v_partition := 'CCP_P'|| to_char(p_rec.PERIODO, 'yyyymmdd');

          v_sql :=  'BEGIN MERGE

               INTO  T_MCRE0_APP_CR_SNDG_GE trg

               USING T_MCRE0_ST_CR_SNDG_GE  PARTITION(' || v_partition || ') src

               ON  (src.COD_GRE = trg.COD_GRE)

            WHEN MATCHED

            THEN

              UPDATE

              SET

                    trg.COD_GRE=src.COD_GRE,
                    trg.VAL_IMP_UTI_SIS=src.VAL_IMP_UTI_SIS,
                    trg.VAL_IMP_ACC_SIS=src.VAL_IMP_ACC_SIS,
                    trg.VAL_IMP_GAR_SIS=src.VAL_IMP_GAR_SIS,
                    trg.DTA_RIFERIMENTO_SIS=src.DTA_RIFERIMENTO_SIS,
                    trg.VAL_IMP_UTI_GRE=src.VAL_IMP_UTI_GRE,
                    trg.VAL_IMP_ACC_GRE=src.VAL_IMP_ACC_GRE,
                    trg.VAL_IMP_GAR_GRE=src.VAL_IMP_GAR_GRE,
                    trg.DTA_RIFERIMENTO_GRE=src.DTA_RIFERIMENTO_GRE,
                    trg.DTA_UPD= sysdate,
                    trg.COD_OPERATORE_INS_UPD = NULL,
                    trg.ID_DPER = src.ID_DPER


           WHEN NOT MATCHED
           THEN
              INSERT (
                        trg.COD_SNDG,
                        trg.COD_GRE,
                        trg.DTA_SISTEMA,
                        trg.STATO_SISTEMA,
                        trg.VAL_IMP_UTI_CLI,
                        trg.VAL_IMP_ACC_CLI,
                        trg.VAL_IMP_GAR_CLI,
                        trg.DTA_RIFERIMENTO_CLI,
                        trg.VAL_IMP_UTI_SIS,
                        trg.VAL_IMP_ACC_SIS,
                        trg.VAL_IMP_GAR_SIS,
                        trg.DTA_RIFERIMENTO_SIS,
                        trg.DTA_INS,
                        trg.DTA_UPD,
                        trg.COD_OPERATORE_INS_UPD,
                        trg.ID_DPER

                        )



              VALUES (
                        src.COD_SNDG,
                        src.COD_GRE,
                        src.DTA_SISTEMA,
                        src.STATO_SISTEMA,
                        src.VAL_IMP_UTI_CLI,
                        src.VAL_IMP_ACC_CLI,
                        src.VAL_IMP_GAR_CLI,
                        src.DTA_RIFERIMENTO_CLI,
                        src.VAL_IMP_UTI_SIS,
                        src.VAL_IMP_ACC_SIS,
                        src.VAL_IMP_GAR_SIS,
                        src.DTA_RIFERIMENTO_SIS,
                        sysdate,
                        sysdate,
                        NULL,
                        src.ID_DPER );

            commit;
            END;';


            DBMS_OUTPUT.PUT_LINE(v_sql);


              execute immediate v_sql;

              RETURN TRUE;


                EXCEPTION WHEN OTHERS THEN

                  DBMS_OUTPUT.PUT_LINE(SUBSTR(SQLERRM, 1, 255));



                end FND_MCRE0_alim_CR_SNDG_GE_AP;


FUNCTION FND_MCRE0_alimenta_CR_NDG_SETT(p_rec IN f_slave_par_type) RETURN BOOLEAN IS

        c_nome CONSTANT VARCHAR2(100) := c_package || '.FND_MCRE0_alimenta_CR_NDG_SETT';
        b_flag BOOLEAN;
        v_cur PKG_MCRE0_UTILS.cur_abi_type;
        v_count NUMBER;



   BEGIN

     DBMS_OUTPUT.PUT_LINE('INIZIALIZZO CURSORE X SOTTOPARTIZIONE COD_ABI');

     open v_cur for select distinct COD_ABI
     from T_MCRE0_APP_ISTITUTI;

       DBMS_OUTPUT.PUT_LINE('CURSORE X SOTTOPARTIZIONE COD_ABI INIZIALIZZATO');

     b_flag := PKG_MCRE0_PARTIZIONI.FND_MCRE0_add_partition(p_rec.SEQ_FLUSSO,p_rec.TAB_TRG,p_rec.PERIODO,v_cur);


     IF(b_flag) THEN


                  insert
             when
             NUM_RECS = 1
             AND TRIM(TO_CHAR(ID_DPER)) IS NOT NULL
             AND TRIM(TO_CHAR(COD_NDG)) IS NOT NULL
             AND TRIM(TO_CHAR(COD_GRE)) IS NOT NULL



            then

            INTO T_MCRE0_ST_CR_NDG_SETT (
                        ID_DPER    ,
                        COD_ABI_ISTITUTO    ,
                        COD_NDG    ,
                        COD_GRE    ,
                        VAL_IMP_UTI_CLI    ,
                        VAL_IMP_ACC_CLI    ,
                        VAL_IMP_GAR_CLI    ,
                        DTA_RIFERIMENTO_CLI
            )


            VALUES (
                        ID_DPER    ,
                        COD_ABI_ISTITUTO    ,
                        COD_NDG    ,
                        COD_GRE    ,
                        VAL_IMP_UTI_CLI    ,
                        VAL_IMP_ACC_CLI    ,
                        VAL_IMP_GAR_CLI    ,
                        DTA_RIFERIMENTO_CLI

               )

             when
             NUM_RECS > 1
             OR TRIM(TO_CHAR(ID_DPER)) IS NULL
             OR TRIM(TO_CHAR(COD_NDG)) IS NULL
             OR TRIM(TO_CHAR(COD_GRE)) IS NULL



             then
             INTO T_MCRE0_SC_VINCOLI_CR_NDG_SETT (
                        ID_SEQ,
                        ID_DPER    ,
                        COD_ABI_ISTITUTO    ,
                        COD_NDG    ,
                        COD_GRE    ,
                        VAL_IMP_UTI_CLI    ,
                        VAL_IMP_ACC_CLI    ,
                        VAL_IMP_GAR_CLI    ,
                        DTA_RIFERIMENTO_CLI

                )

                VALUES (
                         p_rec.SEQ_FLUSSO,
                        ID_DPER    ,
                        COD_ABI_ISTITUTO    ,
                        COD_NDG    ,
                        COD_GRE    ,
                        VAL_IMP_UTI_CLI    ,
                        VAL_IMP_ACC_CLI    ,
                        VAL_IMP_GAR_CLI    ,
                        DTA_RIFERIMENTO_CLI
                    )


             select * from
        (
            SELECT
                COUNT(1) OVER(PARTITION BY  ID_DPER, COD_NDG, COD_GRE) NUM_RECS,
                    ID_DPER    ,
                    COD_ABI_ISTITUTO    ,
                    COD_NDG    ,
                    COD_GRE    ,
                    VAL_IMP_UTI_CLI    ,
                    VAL_IMP_ACC_CLI    ,
                    VAL_IMP_GAR_CLI    ,
                    DTA_RIFERIMENTO_CLI


            FROM
              T_MCRE0_FL_CR_NDG_SETT
        ) tmp;
        COMMIT;

          SELECT COUNT(*)
          INTO v_count
          FROM T_MCRE0_SC_VINCOLI_CR_NDG_SETT     SC
          WHERE SC.ID_SEQ = p_rec.SEQ_FLUSSO;


          UPDATE T_MCRE0_WRK_ACQUISIZIONE
          SET SCARTI_VINCOLI = v_count
          WHERE ID_FLUSSO = p_rec.SEQ_FLUSSO;
          commit;


        b_flag := TRUE;


     END IF;

         IF(b_flag) THEN

        PKG_MCRE0_LOG.SPO_MCRE0_LOG_EVENTO(p_rec.SEQ_FLUSSO,c_nome,'OK','DATI INSERITI CORRETTAMENTE');

        END IF;

      --close v_cur;

           /*  BEGIN

                SELECT VALORE_COSTANTE INTO v_mesi_svecchiamento
                FROM T_MCRE0_WRK_CONFIGURAZIONE
                WHERE NOME_COSTANTE = 'MESI_SVECCHIAMENTO_CR_NDG_SETT';

            EXCEPTION

                WHEN OTHERS THEN

                    v_mesi_svecchiamento := 0;

                    PKG_MCRE0_LOG.SPO_MCRE0_LOG_EVENTO(p_rec.SEQ_FLUSSO,c_nome,'ATTENZIONE','Svecchiamento non eseguibile per problemi di rilevamento della costante ''MESI_SVECCHIAMENTO_CR_NDG_SETT'' nella tabella ''T_MCRE0_WRK_CONFIGURAZIONE''');

            END;

            IF(v_mesi_svecchiamento > 0) THEN

             b_flag := svecchiamento_p31(p_rec.SEQ_FLUSSO,p_rec.TAB_TRG,p_rec.PERIODO,v_mesi_svecchiamento);

            END IF;*/


 /*       RETURN b_flag;


            EXCEPTION


        WHEN OTHERS THEN

        DBMS_OUTPUT.PUT_LINE('ERRORE IN FND_MCRE0_alimenta_CR_NDG_SETT');
         DBMS_OUTPUT.PUT_LINE(SUBSTR(SQLERRM, 1, 255));
            ROLLBACK;

           IF(v_cur%ISOPEN) THEN

                    CLOSE v_cur;

                     DBMS_OUTPUT.PUT_LINE('ERRORE IN FND_MCRE0_alimenta_CR_NDG_SETT - CLOSE CURSOR');

                END IF;

            PKG_MCRE0_LOG.SPO_MCRE0_log_evento_no_commit(p_rec.SEQ_FLUSSO,p_rec.TAB_TRG,'ERRORE',SUBSTR(SQLERRM, 1, 255));

            RETURN FALSE;

     END FND_MCRE0_alimenta_CR_NDG_SETT;


FUNCTION FND_MCRE0_alim_CR_NDG_SETT_AP(p_rec IN f_slave_par_type) RETURN BOOLEAN IS

  v_partition varchar2(20);
  v_sql varchar2(5000);


   begin


   v_partition := 'CCP_P'|| to_char(p_rec.PERIODO, 'yyyymmdd');

          v_sql :=  'BEGIN MERGE

               INTO  T_MCRE0_APP_CR_NDG_SETT trg

               USING T_MCRE0_ST_CR_NDG_SETT  PARTITION(' || v_partition || ') src

               ON  (src.COD_NDG = trg.COD_NDG
                    and src.COD_GRE = trg.COD_GRE)

            WHEN MATCHED

            THEN

              UPDATE

              SET

                    trg.COD_ABI_ISTITUTO=src.COD_ABI_ISTITUTO,
                    trg.VAL_IMP_UTI_CLI=src.VAL_IMP_UTI_CLI,
                    trg.VAL_IMP_ACC_CLI=src.VAL_IMP_ACC_CLI,
                    trg.VAL_IMP_GAR_CLI=src.VAL_IMP_GAR_CLI,
                    trg.DTA_RIFERIMENTO_CLI=src.DTA_RIFERIMENTO_CLI,
                    trg.DTA_UPD= sysdate,
                    trg.COD_OPERATORE_INS_UPD = NULL,
                    trg.ID_DPER = src.ID_DPER


           WHEN NOT MATCHED
           THEN
              INSERT (
                        trg.COD_ABI_ISTITUTO,
                        trg.COD_NDG,
                        trg.COD_GRE,
                        trg.VAL_IMP_UTI_CLI,
                        trg.VAL_IMP_ACC_CLI,
                        trg.VAL_IMP_GAR_CLI,
                        trg.DTA_RIFERIMENTO_CLI,
                        trg.DTA_INS,
                        trg.DTA_UPD,
                        trg.COD_OPERATORE_INS_UPD,
                        trg.ID_DPER

                        )



              VALUES (
                        src.COD_ABI_ISTITUTO,
                        src.COD_NDG,
                        src.COD_GRE,
                        src.VAL_IMP_UTI_CLI,
                        src.VAL_IMP_ACC_CLI,
                        src.VAL_IMP_GAR_CLI,
                        src.DTA_RIFERIMENTO_CLI,
                        sysdate,
                        sysdate,
                        NULL,
                        src.ID_DPER );

            commit;
            END;';


            DBMS_OUTPUT.PUT_LINE(v_sql);


              execute immediate v_sql;

              RETURN TRUE;


                EXCEPTION WHEN OTHERS THEN

                  DBMS_OUTPUT.PUT_LINE(SUBSTR(SQLERRM, 1, 255));



                end FND_MCRE0_alim_CR_NDG_SETT_AP;

 FUNCTION FND_MCRE0_alim_CR_NDG_SETT_GE(p_rec IN f_slave_par_type) RETURN BOOLEAN IS

        c_nome CONSTANT VARCHAR2(100) := c_package || '.FND_MCRE0_alimenta_CR_NDG_SETT_GE';
        b_flag BOOLEAN;
        v_cur PKG_MCRE0_UTILS.cur_abi_type;
        v_count NUMBER;



   BEGIN

     DBMS_OUTPUT.PUT_LINE('INIZIALIZZO CURSORE X SOTTOPARTIZIONE COD_ABI');

     open v_cur for select distinct COD_ABI
     from T_MCRE0_APP_ISTITUTI;

       DBMS_OUTPUT.PUT_LINE('CURSORE X SOTTOPARTIZIONE COD_ABI INIZIALIZZATO');

     b_flag := PKG_MCRE0_PARTIZIONI.FND_MCRE0_add_partition(p_rec.SEQ_FLUSSO,p_rec.TAB_TRG,p_rec.PERIODO,v_cur);


     IF(b_flag) THEN


                  insert
             when
             NUM_RECS = 1
             AND TRIM(TO_CHAR(ID_DPER)) IS NOT NULL
             AND TRIM(TO_CHAR(COD_GRE)) IS NOT NULL




            then

            INTO T_MCRE0_ST_CR_NDG_SETT_GE (
                        ID_DPER    ,
                        COD_ABI_ISTITUTO    ,
                        COD_GRE    ,
                        VAL_IMP_UTI_GRE    ,
                        VAL_IMP_ACC_GRE    ,
                        VAL_IMP_GAR_GRE    ,
                        DTA_RIFERIMENTO_GRE

            )


            VALUES (
                        ID_DPER    ,
                        COD_ABI_ISTITUTO    ,
                        COD_GRE    ,
                        VAL_IMP_UTI_GRE    ,
                        VAL_IMP_ACC_GRE    ,
                        VAL_IMP_GAR_GRE    ,
                        DTA_RIFERIMENTO_GRE
               )

             when
             NUM_RECS > 1
             OR TRIM(TO_CHAR(ID_DPER)) IS NULL
             OR TRIM(TO_CHAR(COD_GRE)) IS NULL



             then
             INTO T_MCRE0_SC_VINC_CR_NDG_SETT_GE (
                        ID_SEQ ,
                        ID_DPER    ,
                        COD_ABI_ISTITUTO ,
                        COD_GRE ,
                        VAL_IMP_UTI_GRE    ,
                        VAL_IMP_ACC_GRE    ,
                        VAL_IMP_GAR_GRE    ,
                        DTA_RIFERIMENTO_GRE


                )

                VALUES (
                        p_rec.SEQ_FLUSSO,
                        ID_DPER    ,
                        COD_ABI_ISTITUTO    ,
                        COD_GRE    ,
                        VAL_IMP_UTI_GRE    ,
                        VAL_IMP_ACC_GRE    ,
                        VAL_IMP_GAR_GRE    ,
                        DTA_RIFERIMENTO_GRE

                    )


             select * from
        (
            SELECT
                COUNT(1) OVER(PARTITION BY  ID_DPER, COD_GRE) NUM_RECS,
                    ID_DPER    ,
                    COD_ABI_ISTITUTO    ,
                    COD_GRE    ,
                    VAL_IMP_UTI_GRE    ,
                    VAL_IMP_ACC_GRE    ,
                    VAL_IMP_GAR_GRE    ,
                    DTA_RIFERIMENTO_GRE



            FROM
              T_MCRE0_FL_CR_NDG_SETT_GE
        ) tmp;
        COMMIT;

        b_flag := TRUE;


     END IF;

         IF(b_flag) THEN

        PKG_MCRE0_LOG.SPO_MCRE0_LOG_EVENTO(p_rec.SEQ_FLUSSO,c_nome,'OK','DATI INSERITI CORRETTAMENTE');

        END IF;

      --close v_cur;

           /*  BEGIN

                SELECT VALORE_COSTANTE INTO v_mesi_svecchiamento
                FROM T_MCRE0_WRK_CONFIGURAZIONE
                WHERE NOME_COSTANTE = 'MESI_SVECCHIAMENTO_CR_NDG_SETT_GE';

            EXCEPTION

                WHEN OTHERS THEN

                    v_mesi_svecchiamento := 0;

                    PKG_MCRE0_LOG.SPO_MCRE0_LOG_EVENTO(p_rec.SEQ_FLUSSO,c_nome,'ATTENZIONE','Svecchiamento non eseguibile per problemi di rilevamento della costante ''MESI_SVECCHIAMENTO_CR_NDG_SETT_GE'' nella tabella ''T_MCRE0_WRK_CONFIGURAZIONE''');

            END;

            IF(v_mesi_svecchiamento > 0) THEN

             b_flag := svecchiamento_p31(p_rec.SEQ_FLUSSO,p_rec.TAB_TRG,p_rec.PERIODO,v_mesi_svecchiamento);

            END IF;*/


 /*       RETURN b_flag;


            EXCEPTION


        WHEN OTHERS THEN

        DBMS_OUTPUT.PUT_LINE('ERRORE IN FND_MCRE0_alimenta_CR_NDG_SETT_GE');
         DBMS_OUTPUT.PUT_LINE(SUBSTR(SQLERRM, 1, 255));
            ROLLBACK;

           IF(v_cur%ISOPEN) THEN

                    CLOSE v_cur;

                     DBMS_OUTPUT.PUT_LINE('ERRORE IN FND_MCRE0_alimenta_CR_NDG_SETT_GE - CLOSE CURSOR');

                END IF;

            PKG_MCRE0_LOG.SPO_MCRE0_log_evento_no_commit(p_rec.SEQ_FLUSSO,p_rec.TAB_TRG,'ERRORE',SUBSTR(SQLERRM, 1, 255));

            RETURN FALSE;

     END FND_MCRE0_alim_CR_NDG_SETT_GE;


FUNCTION FND_MCRE0_alim_CR_NdgSetGe_AP(p_rec IN f_slave_par_type) RETURN BOOLEAN IS

  v_partition varchar2(20);
  v_sql varchar2(5000);


   begin


   v_partition := 'CCP_P'|| to_char(p_rec.PERIODO, 'yyyymmdd');

          v_sql :=  'BEGIN MERGE

               INTO  T_MCRE0_APP_CR_NDG_SETT_GE trg

               USING T_MCRE0_ST_CR_NDG_SETT_GE  PARTITION(' || v_partition || ') src

               ON  (src.COD_NDG = trg.COD_NDG
                    and src.COD_GRE = trg.COD_GRE)

            WHEN MATCHED

            THEN

              UPDATE

              SET

                    trg.COD_ABI_ISTITUTO=src.COD_ABI_ISTITUTO,
                    trg.COD_GRE=src.COD_GRE,
                    trg.VAL_IMP_UTI_GRE=src.VAL_IMP_UTI_GRE,
                    trg.VAL_IMP_ACC_GRE=src.VAL_IMP_ACC_GRE,
                    trg.VAL_IMP_GAR_GRE=src.VAL_IMP_GAR_GRE,
                    trg.DTA_RIFERIMENTO_GRE=src.DTA_RIFERIMENTO_GRE,
                    trg.DTA_UPD= sysdate,
                    trg.COD_OPERATORE_INS_UPD = NULL,
                    trg.ID_DPER = src.ID_DPER


           WHEN NOT MATCHED
           THEN
              INSERT (
                        trg.COD_ABI_ISTITUTO,
                        trg.COD_GRE,
                        trg.VAL_IMP_UTI_GRE,
                        trg.VAL_IMP_ACC_GRE,
                        trg.VAL_IMP_GAR_GRE,
                        trg.DTA_RIFERIMENTO_GRE,
                        trg.DTA_INS,
                        trg.DTA_UPD,
                        trg.COD_OPERATORE_INS_UPD,
                        trg.ID_DPER

                        )



              VALUES (
                        src.COD_ABI_ISTITUTO,
                        src.COD_GRE,
                        src.VAL_IMP_UTI_GRE,
                        src.VAL_IMP_ACC_GRE,
                        src.VAL_IMP_GAR_GRE,
                        src.DTA_RIFERIMENTO_GRE,
                        src.DTA_RIFERIMENTO_CLI,
                        sysdate,
                        sysdate,
                        NULL,
                        src.ID_DPER );

            commit;
            END;';


            DBMS_OUTPUT.PUT_LINE(v_sql);


              execute immediate v_sql;

              RETURN TRUE;


                EXCEPTION WHEN OTHERS THEN

                  DBMS_OUTPUT.PUT_LINE(SUBSTR(SQLERRM, 1, 255));



                end FND_MCRE0_alim_CR_NdgSetGe_AP;*/


 FUNCTION FND_MCRE0_storicizza_MOPLE(p_rec IN f_slave_par_type) RETURN BOOLEAN is

    v_partition varchar2(20);
    c_nome CONSTANT VARCHAR2(100) := c_package || '.FND_MCRE0_storicizza_MOPLE';
    b_flag BOOLEAN;
    v_sql varchar2(5000);

    v_new_per date;
    v_last_period date;
    v_last_month number := 0;
    v_flg_mese number := 0;

      begin

         b_flag := FALSE;
         v_partition := 'CCP_P'|| to_char(p_rec.PERIODO, 'yyyymmdd');

         v_last_month := 0;

--              select (max(PERIODO_RIFERIMENTO))
--              into v_new_per
--              FROM T_MCRE0_WRK_ACQUISIZIONE
--              where PERIODO_RIFERIMENTO = (SELECT MAX(PERIODO_RIFERIMENTO) FROM V_MCRE0_ULTIMA_ACQUISIZIONE);


--              select (max(PERIODO_RIFERIMENTO))
--              into v_last_period
--              FROM T_MCRE0_WRK_ACQUISIZIONE
--              where PERIODO_RIFERIMENTO < v_new_per
--              and FLG_ETL_2 <> 0;

--          if  extract (month from v_last_period) <>  extract (month from v_new_per) then

--          v_last_month:= TO_NUMBER(TO_CHAR(v_last_period, 'yyyymmdd'));
--          v_flg_mese := 1;

--          end if;


         EXECUTE IMMEDIATE 'TRUNCATE TABLE T_MCRE0_TMP_LISTA_STORICO';

         v_sql := '
                BEGIN

                insert into T_MCRE0_TMP_LISTA_STORICO(
                COD_ABI_CARTOLARIZZATO    ,
                COD_NDG    ,
                COD_SNDG,
                FLG_STATO    ,
                FLG_COMPARTO ,
                FLG_GESTORE ,
                FLG_MESE,
                COD_MESE_HST
                )

               select
                src.COD_ABI_CARTOLARIZZATO    ,
                src.COD_NDG    ,
                src.COD_SNDG,
                1,
                0,
                0,
                '|| v_flg_mese || ', '
                || v_last_month ||'

               from T_MCRE0_ST_MOPLE  PARTITION(' || v_partition || ') src INNER JOIN T_MCRE0_APP_MOPLE24 app
               on
               src.COD_ABI_CARTOLARIZZATO  = APP.COD_ABI_CARTOLARIZZATO
               and src.COD_NDG = APP.COD_NDG
               where src.COD_STATO <> app.COD_STATO;
               commit;
               END;';

         DBMS_OUTPUT.PUT_LINE(v_sql);
         execute immediate v_sql;

         b_flag := TRUE;
         RETURN b_flag;

         IF(b_flag) THEN

        PKG_MCRE0_LOG.SPO_MCRE0_LOG_EVENTO(p_rec.SEQ_FLUSSO,c_nome,'OK','POPOLATA T_MCRE0_TMP_LISTA_STORICO ');

        else
        PKG_MCRE0_LOG.SPO_MCRE0_LOG_EVENTO(p_rec.SEQ_FLUSSO,c_nome,'ERRORE', SUBSTR(SQLERRM, 1, 255));
        RETURN b_flag;

        END IF;




                EXCEPTION WHEN OTHERS THEN

                  DBMS_OUTPUT.PUT_LINE(SUBSTR(SQLERRM, 1, 255));

                  PKG_MCRE0_LOG.SPO_MCRE0_LOG_EVENTO(p_rec.SEQ_FLUSSO,c_nome,'ERRORE', SUBSTR(SQLERRM, 1, 255));

                   RETURN FALSE;

                end FND_MCRE0_storicizza_MOPLE;


 FUNCTION FND_MCRE0_alimenta_PCR_LEGAME(p_rec IN f_slave_par_type) RETURN BOOLEAN IS

        c_nome CONSTANT VARCHAR2(100) := c_package || '.FND_MCRE0_alimenta_PCR_LEGAME';
        b_flag BOOLEAN;
        v_cur PKG_MCRE0_UTILS.cur_abi_type;
        v_count NUMBER;



   BEGIN

     DBMS_OUTPUT.PUT_LINE('INIZIALIZZO CURSORE X SOTTOPARTIZIONE COD_ABI');

     open v_cur for select distinct COD_ABI
     from T_MCRE0_APP_ISTITUTI;

       DBMS_OUTPUT.PUT_LINE('CURSORE X SOTTOPARTIZIONE COD_ABI INIZIALIZZATO');

     b_flag := PKG_MCRE0_PARTIZIONI.FND_MCRE0_add_partition(p_rec.SEQ_FLUSSO,p_rec.TAB_TRG,p_rec.PERIODO,v_cur);


     IF(b_flag) THEN


                  insert
             when
             NUM_RECS = 1
             AND TRIM(TO_CHAR(ID_DPER)) IS NOT NULL
             AND TRIM(TO_CHAR(COD_SNDG)) IS NOT NULL
             AND TRIM(TO_CHAR(COD_SNDG_LEGANTE)) IS NOT NULL
             AND TRIM(TO_CHAR(COD_FORMA_TECNICA)) IS NOT NULL



            then

            INTO T_MCRE0_ST_PCR_LEGAME (
            ID_DPER    ,
            COD_SNDG    ,
            COD_FORMA_TECNICA    ,
            VAL_UTI_LEG    ,
            VAL_ACC_LEG    ,
            COD_SNDG_LEGANTE    ,
            COD_LEGAME    ,
            DTA_RIFERIMENTO    ,
            COD_NATURA    ,
            VAL_IMP_GAR_LEG    ,
            DTA_SCADENZA_LDC

            )
            VALUES (
            ID_DPER    ,
            COD_SNDG    ,
            COD_FORMA_TECNICA    ,
            VAL_UTI_LEG    ,
            VAL_ACC_LEG    ,
            COD_SNDG_LEGANTE    ,
            COD_LEGAME    ,
            DTA_RIFERIMENTO    ,
            COD_NATURA    ,
            VAL_IMP_GAR_LEG    ,
            DTA_SCADENZA_LDC
)

             when
             NUM_RECS > 1
             OR TRIM(TO_CHAR(ID_DPER)) IS NULL
             OR TRIM(TO_CHAR(COD_SNDG)) IS NULL
             OR TRIM(TO_CHAR(COD_SNDG_LEGANTE)) IS NULL
             OR TRIM(TO_CHAR(COD_FORMA_TECNICA)) IS NULL


             then
             INTO T_MCRE0_SC_VINCOLI_PCR_LEGAME (
                ID_SEQ    ,
                ID_DPER    ,
                COD_SNDG    ,
                COD_FORMA_TECNICA    ,
                VAL_UTI_LEG    ,
                VAL_ACC_LEG    ,
                COD_SNDG_LEGANTE    ,
                COD_LEGAME    ,
                DTA_RIFERIMENTO    ,
                COD_NATURA    ,
                VAL_IMP_GAR_LEG    ,
                DTA_SCADENZA_LDC
                )

                VALUES (
                p_rec.SEQ_FLUSSO,
                ID_DPER    ,
                COD_SNDG    ,
                COD_FORMA_TECNICA    ,
                VAL_UTI_LEG    ,
                VAL_ACC_LEG    ,
                COD_SNDG_LEGANTE    ,
                COD_LEGAME    ,
                DTA_RIFERIMENTO    ,
                COD_NATURA    ,
                VAL_IMP_GAR_LEG    ,
                DTA_SCADENZA_LDC     )


             select * from
        (
            SELECT
                COUNT(1) OVER(PARTITION BY  ID_DPER, COD_SNDG, COD_SNDG_LEGANTE, COD_FORMA_TECNICA) NUM_RECS,
                ID_DPER    ,
                COD_SNDG    ,
                COD_FORMA_TECNICA    ,
                VAL_UTI_LEG    ,
                VAL_ACC_LEG    ,
                COD_SNDG_LEGANTE    ,
                COD_LEGAME    ,
                DTA_RIFERIMENTO    ,
                COD_NATURA    ,
                VAL_IMP_GAR_LEG    ,
                DTA_SCADENZA_LDC

            FROM
              T_MCRE0_FL_PCR_LEGAME
        ) tmp;
        COMMIT;

           SELECT COUNT(*)
          INTO v_count
          FROM T_MCRE0_SC_VINCOLI_PCR_LEGAME   SC
          WHERE SC.ID_SEQ = p_rec.SEQ_FLUSSO;


          UPDATE T_MCRE0_WRK_ACQUISIZIONE
          SET SCARTI_VINCOLI = v_count
          WHERE ID_FLUSSO = p_rec.SEQ_FLUSSO;
          commit;



        b_flag := TRUE;


     END IF;

         IF(b_flag) THEN

        PKG_MCRE0_LOG.SPO_MCRE0_LOG_EVENTO(p_rec.SEQ_FLUSSO,c_nome,'OK','DATI INSERITI CORRETTAMENTE');

        END IF;



        RETURN b_flag;


            EXCEPTION


        WHEN OTHERS THEN

        DBMS_OUTPUT.PUT_LINE('ERRORE IN FND_MCRE0_alimenta_PCR_LEGAME');
         DBMS_OUTPUT.PUT_LINE(SUBSTR(SQLERRM, 1, 255));
            ROLLBACK;

           IF(v_cur%ISOPEN) THEN

                    CLOSE v_cur;

                     DBMS_OUTPUT.PUT_LINE('ERRORE IN FND_MCRE0_alimenta_PCR_LEGAME - CLOSE CURSOR');

                END IF;

            PKG_MCRE0_LOG.SPO_MCRE0_log_evento_no_commit(p_rec.SEQ_FLUSSO,p_rec.TAB_TRG,'ERRORE',SUBSTR(SQLERRM, 1, 255));

            RETURN FALSE;

     END FND_MCRE0_alimenta_PCR_LEGAME;

FUNCTION FND_MCRE0_alim_PCR_LEGAME_AP(p_rec IN f_slave_par_type) RETURN BOOLEAN IS

  v_partition varchar2(20);
  v_sql varchar2(5000);


   begin


   v_partition := 'CCP_P'|| to_char(p_rec.PERIODO, 'yyyymmdd');

          v_sql :=  'BEGIN MERGE

               INTO  T_MCRE0_APP_PCR_LEGAME trg

               USING T_MCRE0_ST_PCR_LEGAME  PARTITION(' || v_partition || ') src

               ON  ( trg.COD_SNDG=src.COD_SNDG
                      and trg.COD_FORMA_TECNICA=src.COD_FORMA_TECNICA
                      and trg.COD_SNDG_LEGANTE=src.COD_SNDG_LEGANTE)

            WHEN MATCHED

            THEN

              UPDATE

              SET
                trg.VAL_UTI_LEG=src.VAL_UTI_LEG,
                trg.VAL_ACC_LEG=src.VAL_ACC_LEG,
                trg.COD_LEGAME=src.COD_LEGAME,
                trg.DTA_RIFERIMENTO=src.DTA_RIFERIMENTO,
                trg.COD_NATURA=src.COD_NATURA,
                trg.VAL_IMP_GAR_LEG=src.VAL_IMP_GAR_LEG,
                trg.DTA_SCADENZA_LDC=src.DTA_SCADENZA_LDC,
                trg.DTA_UPD= sysdate,
                trg.COD_OPERATORE_INS_UPD = NULL,
                trg.ID_DPER = src.ID_DPER



           WHEN NOT MATCHED
           THEN
              INSERT (

                        trg.COD_SNDG,
                        trg.COD_FORMA_TECNICA,
                        trg.VAL_UTI_LEG,
                        trg.VAL_ACC_LEG,
                        trg.COD_SNDG_LEGANTE,
                        trg.COD_LEGAME,
                        trg.DTA_RIFERIMENTO,
                        trg.COD_NATURA,
                        trg.VAL_IMP_GAR_LEG,
                        trg.DTA_SCADENZA_LDC,
                        trg.DTA_INS    ,
                        trg.DTA_UPD    ,
                        trg.COD_OPERATORE_INS_UPD    ,
                        trg.ID_DPER

                        )

              VALUES (  src.COD_SNDG,
                        src.COD_FORMA_TECNICA,
                        src.VAL_UTI_LEG,
                        src.VAL_ACC_LEG,
                        src.COD_SNDG_LEGANTE,
                        src.COD_LEGAME,
                        src.DTA_RIFERIMENTO,
                        src.COD_NATURA,
                        src.VAL_IMP_GAR_LEG,
                        src.DTA_SCADENZA_LDC,
                        sysdate,
                        sysdate,
                        NULL,
                        src.ID_DPER );

            commit;
            END;';


            DBMS_OUTPUT.PUT_LINE(v_sql);


              execute immediate v_sql;

              RETURN TRUE;


                EXCEPTION WHEN OTHERS THEN

                  DBMS_OUTPUT.PUT_LINE(SUBSTR(SQLERRM, 1, 255));



                end FND_MCRE0_alim_PCR_LEGAME_AP;


   FUNCTION fnd_mcre0_alimenta_iris (p_rec IN f_slave_par_type)
      RETURN BOOLEAN
   IS
      c_nome   CONSTANT VARCHAR2 (100)
                                   := c_package || '.FND_MCRE0_alimenta_IRIS';
      b_flag            BOOLEAN;
      v_cur             pkg_mcre0_utils.cur_abi_type;
      v_count           NUMBER;
   BEGIN
      DBMS_OUTPUT.put_line ('INIZIALIZZO CURSORE X SOTTOPARTIZIONE COD_ABI');

      OPEN v_cur FOR
         SELECT DISTINCT cod_abi
                    FROM t_mcre0_app_istituti;

      DBMS_OUTPUT.put_line ('CURSORE X SOTTOPARTIZIONE COD_ABI INIZIALIZZATO');
      b_flag :=
         pkg_mcre0_partizioni.fnd_mcre0_add_partition (p_rec.seq_flusso,
                                                       p_rec.tab_trg,
                                                       p_rec.periodo,
                                                       v_cur
                                                      );

      IF (b_flag)
      THEN
         INSERT
            WHEN     num_recs = 1
                 AND TRIM (TO_CHAR (id_dper)) IS NOT NULL
                 AND TRIM (TO_CHAR (cod_sndg)) IS NOT NULL
            THEN
           INTO t_mcre0_st_iris
                (id_dper, cod_sndg, dta_riferimento, val_iris_gre,
                 val_iris_cli, val_liv_rischio_gre, val_liv_rischio_cli,
                 val_lgd, dta_lgd, val_ead, dta_ead, val_pa, dta_pa,
                 val_pd_monitoraggio, dta_pd_monitoraggio,
                 val_rating_monitoraggio,
                                         --5.0
                                         val_ind_utl_interno,
                 val_ind_utl_esterno, val_ind_utl_complessivo, val_ind_rata,
                 VAL_IND_ROTAZIONE, VAL_IND_INDEBITAMENTO,
                 val_ind_insol_portaf,FLG_FATAL
                --
                )
         VALUES (id_dper, cod_sndg, dta_riferimento, val_iris_gre,
                 val_iris_cli, val_liv_rischio_gre, val_liv_rischio_cli,
                 val_lgd, dta_lgd, val_ead, dta_ead, val_pa, dta_pa,
                 val_pd_monitoraggio, dta_pd_monitoraggio,
                 val_rating_monitoraggio,
                                         --5.0
                                         val_ind_utl_interno,
                 val_ind_utl_esterno, val_ind_utl_complessivo, val_ind_rata,
                 VAL_IND_ROTAZIONE, VAL_IND_INDEBITAMENTO,
                 val_ind_insol_portaf,FLG_FATAL
                --
                )
            WHEN    num_recs > 1
                 OR TRIM (TO_CHAR (id_dper)) IS NULL
                 OR TRIM (TO_CHAR (cod_sndg)) IS NULL
            THEN
           INTO t_mcre0_sc_vincoli_iris
                (id_seq, id_dper, cod_sndg, dta_riferimento,
                 val_iris_gre, val_iris_cli, val_liv_rischio_gre,
                 val_liv_rischio_cli, val_lgd, dta_lgd, val_ead, dta_ead,
                 val_pa, dta_pa, val_pd_monitoraggio, dta_pd_monitoraggio,
                 val_rating_monitoraggio,
                                         --5.0
                                         val_ind_utl_interno,
                 val_ind_utl_esterno, val_ind_utl_complessivo, val_ind_rata,
                 VAL_IND_ROTAZIONE, VAL_IND_INDEBITAMENTO,
                 val_ind_insol_portaf,FLG_FATAL
                --
                )
         VALUES (p_rec.seq_flusso, id_dper, cod_sndg, dta_riferimento,
                 val_iris_gre, val_iris_cli, val_liv_rischio_gre,
                 val_liv_rischio_cli, val_lgd, dta_lgd, val_ead, dta_ead,
                 val_pa, dta_pa, val_pd_monitoraggio, dta_pd_monitoraggio,
                 val_rating_monitoraggio,
                                         --5.0
                                         val_ind_utl_interno,
                 val_ind_utl_esterno, val_ind_utl_complessivo, val_ind_rata,
                 VAL_IND_ROTAZIONE, VAL_IND_INDEBITAMENTO,
                 val_ind_insol_portaf,FLG_FATAL
                --
                )
            SELECT *
              FROM (SELECT COUNT (1) OVER (PARTITION BY id_dper, cod_sndg)
                                                                     num_recs,
                           id_dper, cod_sndg, dta_riferimento, val_iris_gre,
                           val_iris_cli, val_liv_rischio_gre,
                           val_liv_rischio_cli, val_lgd, dta_lgd, val_ead,
                           dta_ead, val_pa, dta_pa, val_pd_monitoraggio,
                           dta_pd_monitoraggio, val_rating_monitoraggio,

                           --5.0
                           val_ind_utl_interno, val_ind_utl_esterno,
                           val_ind_utl_complessivo, val_ind_rata,
                           VAL_IND_ROTAZIONE, VAL_IND_INDEBITAMENTO,
                           val_ind_insol_portaf,FLG_FATAL
                      --
                    FROM   t_mcre0_fl_iris) tmp;
         COMMIT;

         SELECT COUNT (*)
           INTO v_count
           FROM t_mcre0_sc_vincoli_iris sc
          WHERE sc.id_seq = p_rec.seq_flusso;

         UPDATE t_mcre0_wrk_acquisizione
            SET scarti_vincoli = v_count
          WHERE id_flusso = p_rec.seq_flusso;

         COMMIT;
         b_flag := TRUE;
      END IF;

      IF (b_flag)
      THEN
         pkg_mcre0_log.spo_mcre0_log_evento (p_rec.seq_flusso,
                                             c_nome,
                                             'OK',
                                             'DATI INSERITI CORRETTAMENTE'
                                            );
      END IF;

      RETURN b_flag;
   EXCEPTION
      WHEN OTHERS
      THEN
         DBMS_OUTPUT.put_line ('ERRORE IN FND_MCRE0_alimenta_IRIS');
         DBMS_OUTPUT.put_line (SUBSTR (SQLERRM, 1, 255));
         ROLLBACK;

         IF (v_cur%ISOPEN)
         THEN
            CLOSE v_cur;

            DBMS_OUTPUT.put_line
                          ('ERRORE IN FND_MCRE0_alimenta_IRIS - CLOSE CURSOR');
         END IF;

         pkg_mcre0_log.spo_mcre0_log_evento_no_commit (p_rec.seq_flusso,
                                                       p_rec.tab_trg,
                                                       'ERRORE',
                                                       SUBSTR (SQLERRM, 1,
                                                               255)
                                                      );
         RETURN FALSE;
   END fnd_mcre0_alimenta_iris;

   FUNCTION fnd_mcre0_alimenta_iris_ap (p_rec IN f_slave_par_type)
      RETURN BOOLEAN
   IS
      v_partition   VARCHAR2 (20);
      v_sql         VARCHAR2 (32000);
   BEGIN
      v_partition := 'CCP_P' || TO_CHAR (p_rec.periodo, 'yyyymmdd');
      v_sql :=
            'BEGIN MERGE

               INTO  T_MCRE0_APP_IRIS24 trg

               USING T_MCRE0_ST_IRIS  PARTITION('
         || v_partition
         || ') src

               ON  ( trg.COD_SNDG=src.COD_SNDG)

            WHEN MATCHED

            THEN

              UPDATE

              SET
                trg.DTA_RIFERIMENTO=src.DTA_RIFERIMENTO    ,
                trg.VAL_IRIS_GRE=src.VAL_IRIS_GRE    ,
                trg.VAL_IRIS_CLI=src.VAL_IRIS_CLI    ,
                trg.VAL_LIV_RISCHIO_GRE=src.VAL_LIV_RISCHIO_GRE    ,
                trg.VAL_LIV_RISCHIO_CLI=src.VAL_LIV_RISCHIO_CLI    ,
                trg.VAL_LGD=src.VAL_LGD    ,
                trg.DTA_LGD=src.DTA_LGD    ,
                trg.VAL_EAD=src.VAL_EAD    ,
                trg.DTA_EAD=src.DTA_EAD    ,
                trg.VAL_PA=src.VAL_PA    ,
                trg.DTA_PA=src.DTA_PA    ,
                trg.VAL_PD_MONITORAGGIO=src.VAL_PD_MONITORAGGIO    ,
                trg.DTA_PD_MONITORAGGIO=src.DTA_PD_MONITORAGGIO    ,
                trg.VAL_RATING_MONITORAGGIO=src.VAL_RATING_MONITORAGGIO    ,
                trg.DTA_UPD= sysdate,
                trg.COD_OPERATORE_INS_UPD = NULL,
                trg.ID_DPER = src.ID_DPER ,
                --5.0
                trg.VAL_IND_UTL_INTERNO=src.VAL_IND_UTL_INTERNO,
                trg.VAL_IND_UTL_ESTERNO=src.VAL_IND_UTL_ESTERNO ,
                trg.VAL_IND_UTL_COMPLESSIVO=src.VAL_IND_UTL_COMPLESSIVO,
                trg.VAL_IND_RATA=src.VAL_IND_RATA,
                trg.VAL_IND_ROTAZIONE=src.VAL_IND_ROTAZIONE,
                trg.VAL_IND_INDEBITAMENTO=src.VAL_IND_INDEBITAMENTO,
                trg.VAL_IND_INSOL_PORTAF=src.VAL_IND_INSOL_PORTAF,
                trg.FLG_FATAL= NVL(src.FLG_FATAL,''0'')
               --

           WHEN NOT MATCHED
           THEN
              INSERT (
                        trg.COD_SNDG,
                        trg.DTA_RIFERIMENTO,
                        trg.VAL_IRIS_GRE,
                        trg.VAL_IRIS_CLI,
                        trg.VAL_LIV_RISCHIO_GRE,
                        trg.VAL_LIV_RISCHIO_CLI,
                        trg.VAL_LGD,
                        trg.DTA_LGD,
                        trg.VAL_EAD,
                        trg.DTA_EAD,
                        trg.VAL_PA,
                        trg.DTA_PA,
                        trg.VAL_PD_MONITORAGGIO,
                        trg.DTA_PD_MONITORAGGIO,
                        trg.VAL_RATING_MONITORAGGIO,
                        trg.DTA_INS    ,
                        trg.DTA_UPD    ,
                        trg.COD_OPERATORE_INS_UPD    ,
                        trg.ID_DPER,
                         --5.0
                       trg.VAL_IND_UTL_INTERNO, trg.VAL_IND_UTL_ESTERNO, trg.VAL_IND_UTL_COMPLESSIVO,
                       trg.VAL_IND_RATA, trg.VAL_IND_ROTAZIONE, trg.VAL_IND_INDEBITAMENTO, trg.VAL_IND_INSOL_PORTAF,
                       trg.FLG_FATAL
                       --
                        )

              VALUES (
                        src.COD_SNDG,
                        src.DTA_RIFERIMENTO,
                        src.VAL_IRIS_GRE,
                        src.VAL_IRIS_CLI,
                        src.VAL_LIV_RISCHIO_GRE,
                        src.VAL_LIV_RISCHIO_CLI,
                        src.VAL_LGD,
                        src.DTA_LGD,
                        src.VAL_EAD,
                        src.DTA_EAD,
                        src.VAL_PA,
                        src.DTA_PA,
                        src.VAL_PD_MONITORAGGIO,
                        src.DTA_PD_MONITORAGGIO,
                        src.VAL_RATING_MONITORAGGIO,
                        sysdate,
                        sysdate,
                        NULL,
                        src.ID_DPER ,
                         --5.0
                        src.VAL_IND_UTL_INTERNO, src.VAL_IND_UTL_ESTERNO, src.VAL_IND_UTL_COMPLESSIVO,
                        src.VAL_IND_RATA, src.VAL_IND_ROTAZIONE, src.VAL_IND_INDEBITAMENTO, src.VAL_IND_INSOL_PORTAF,
                        NVL(src.FLG_FATAL,''0'')
                         --
                        );

            commit;
            END;';
      DBMS_OUTPUT.put_line (v_sql);

      EXECUTE IMMEDIATE v_sql;

      RETURN TRUE;
   EXCEPTION
      WHEN OTHERS
      THEN
         DBMS_OUTPUT.put_line (SUBSTR (SQLERRM, 1, 255));
   END fnd_mcre0_alimenta_iris_ap;

   FUNCTION fnd_mcre0_alimenta_iris_ap_st (p_rec IN f_slave_par_type)
      RETURN BOOLEAN
   IS
      c_nome   CONSTANT VARCHAR2 (100)
                             := c_package || '.FND_MCRE0_alimenta_IRIS_AP_ST';
      b_flag            BOOLEAN;
      v_cur             pkg_mcre0_utils.cur_abi_type;
      v_count           NUMBER;
      v_partition       VARCHAR2 (20);
      v_sql             VARCHAR2 (32000);
   BEGIN







      b_flag :=
         pkg_mcre0_partizioni.fnd_mcre0_add_part_storica
                                                 (p_rec.seq_flusso,
                                                  'T_MCRE0_APP_IRIS_STORICO',
                                                  p_rec.periodo
                                                 );

      IF (b_flag)
      THEN
         v_partition := 'CCP_P' || TO_CHAR (p_rec.periodo, 'yyyymmdd');
         v_sql :=
               'BEGIN MERGE

               INTO  T_MCRE0_APP_IRIS_STORICO trg

               USING  (SELECT to_number(substr(to_char(ID_DPER),0,6)) Id_dper, COD_SNDG, DTA_RIFERIMENTO, VAL_IRIS_GRE, VAL_IRIS_CLI, VAL_LIV_RISCHIO_GRE,
                              VAL_LIV_RISCHIO_CLI, VAL_LGD, DTA_LGD, VAL_EAD, DTA_EAD, VAL_PA, DTA_PA,
                              VAL_PD_MONITORAGGIO, DTA_PD_MONITORAGGIO, VAL_RATING_MONITORAGGIO,
                              VAL_IND_UTL_INTERNO, VAL_IND_UTL_ESTERNO, VAL_IND_UTL_COMPLESSIVO,
                              VAL_IND_RATA, VAL_IND_ROTAZIONE, VAL_IND_INDEBITAMENTO, VAL_IND_INSOL_PORTAF,ID_DPER AS ID_DPER_RIF,FLG_FATAL
                        FROM T_MCRE0_ST_IRIS  PARTITION('
            || v_partition
            || ')) src

               ON  ( trg.COD_SNDG=src.COD_SNDG AND
                     trg.id_dper =src.id_dper)

            WHEN MATCHED

            THEN

              UPDATE

              SET
                trg.DTA_RIFERIMENTO=src.DTA_RIFERIMENTO    ,
                trg.VAL_IRIS_GRE=src.VAL_IRIS_GRE    ,
                trg.VAL_IRIS_CLI=src.VAL_IRIS_CLI    ,
                trg.VAL_LIV_RISCHIO_GRE=src.VAL_LIV_RISCHIO_GRE    ,
                trg.VAL_LIV_RISCHIO_CLI=src.VAL_LIV_RISCHIO_CLI    ,
                trg.VAL_LGD=src.VAL_LGD    ,
                trg.DTA_LGD=src.DTA_LGD    ,
                trg.VAL_EAD=src.VAL_EAD    ,
                trg.DTA_EAD=src.DTA_EAD    ,
                trg.VAL_PA=src.VAL_PA    ,
                trg.DTA_PA=src.DTA_PA    ,
                trg.VAL_PD_MONITORAGGIO=src.VAL_PD_MONITORAGGIO    ,
                trg.DTA_PD_MONITORAGGIO=src.DTA_PD_MONITORAGGIO    ,
                trg.VAL_RATING_MONITORAGGIO=src.VAL_RATING_MONITORAGGIO    ,
                trg.DTA_UPD= sysdate,
                trg.COD_OPERATORE_INS_UPD = NULL,
                trg.ID_DPER_RIF = src.ID_DPER_RIF ,
                trg.VAL_IND_UTL_INTERNO=src.VAL_IND_UTL_INTERNO,
                trg.VAL_IND_UTL_ESTERNO=src.VAL_IND_UTL_ESTERNO ,
                trg.VAL_IND_UTL_COMPLESSIVO=src.VAL_IND_UTL_COMPLESSIVO,
                trg.VAL_IND_RATA=src.VAL_IND_RATA,
                trg.VAL_IND_ROTAZIONE=src.VAL_IND_ROTAZIONE,
                trg.VAL_IND_INDEBITAMENTO=src.VAL_IND_INDEBITAMENTO,
                trg.VAL_IND_INSOL_PORTAF=src.VAL_IND_INSOL_PORTAF,
                trg.FLG_FATAL=src.FLG_FATAL


           WHEN NOT MATCHED
           THEN
              INSERT (
                        trg.COD_SNDG,
                        trg.DTA_RIFERIMENTO,
                        trg.VAL_IRIS_GRE,
                        trg.VAL_IRIS_CLI,
                        trg.VAL_LIV_RISCHIO_GRE,
                        trg.VAL_LIV_RISCHIO_CLI,
                        trg.VAL_LGD,
                        trg.DTA_LGD,
                        trg.VAL_EAD,
                        trg.DTA_EAD,
                        trg.VAL_PA,
                        trg.DTA_PA,
                        trg.VAL_PD_MONITORAGGIO,
                        trg.DTA_PD_MONITORAGGIO,
                        trg.VAL_RATING_MONITORAGGIO,
                        trg.DTA_INS    ,
                        trg.DTA_UPD    ,
                        trg.COD_OPERATORE_INS_UPD    ,
                        trg.ID_DPER,
                        trg.VAL_IND_UTL_INTERNO, trg.VAL_IND_UTL_ESTERNO, trg.VAL_IND_UTL_COMPLESSIVO,
                        trg.VAL_IND_RATA, trg.VAL_IND_ROTAZIONE, trg.VAL_IND_INDEBITAMENTO, trg.VAL_IND_INSOL_PORTAF,
                        trg.ID_DPER_RIF,
                        trg.FLG_FATAL

                        )

              VALUES (
                        src.COD_SNDG,
                        src.DTA_RIFERIMENTO,
                        src.VAL_IRIS_GRE,
                        src.VAL_IRIS_CLI,
                        src.VAL_LIV_RISCHIO_GRE,
                        src.VAL_LIV_RISCHIO_CLI,
                        src.VAL_LGD,
                        src.DTA_LGD,
                        src.VAL_EAD,
                        src.DTA_EAD,
                        src.VAL_PA,
                        src.DTA_PA,
                        src.VAL_PD_MONITORAGGIO,
                        src.DTA_PD_MONITORAGGIO,
                        src.VAL_RATING_MONITORAGGIO,
                        sysdate,
                        null,
                        NULL,
                        src.ID_DPER ,
                        src.VAL_IND_UTL_INTERNO, src.VAL_IND_UTL_ESTERNO, src.VAL_IND_UTL_COMPLESSIVO,
                        src.VAL_IND_RATA, src.VAL_IND_ROTAZIONE, src.VAL_IND_INDEBITAMENTO, src.VAL_IND_INSOL_PORTAF,
                        src.ID_DPER_RIF,
                        src.FLG_FATAL

                        );

            commit;
            END;';

         EXECUTE IMMEDIATE v_sql;

         b_flag := TRUE;
      END IF;

      IF (b_flag)
      THEN
         pkg_mcre0_log.spo_mcre0_log_evento (p_rec.seq_flusso,
                                             c_nome,
                                             'OK',
                                             'DATI INSERITI CORRETTAMENTE'
                                            );
      END IF;

      RETURN b_flag;
   EXCEPTION
      WHEN OTHERS
      THEN
         DBMS_OUTPUT.put_line ('ERRORE IN FND_MCRE0_alimenta_IRIS');
         DBMS_OUTPUT.put_line (SUBSTR (SQLERRM, 1, 255));
         ROLLBACK;

         IF (v_cur%ISOPEN)
         THEN
            CLOSE v_cur;

            DBMS_OUTPUT.put_line
                          ('ERRORE IN FND_MCRE0_alimenta_IRIS - CLOSE CURSOR');
         END IF;

         pkg_mcre0_log.spo_mcre0_log_evento_no_commit (p_rec.seq_flusso,
                                                       p_rec.tab_trg,
                                                       'ERRORE',
                                                       SUBSTR (SQLERRM, 1,
                                                               255)
                                                      );
         RETURN FALSE;
   END fnd_mcre0_alimenta_iris_ap_st;



FUNCTION FND_MCRE0_alimenta_PEF(p_rec IN f_slave_par_type) RETURN BOOLEAN IS

        c_nome CONSTANT VARCHAR2(100) := c_package || '.FND_MCRE0_alimenta_PEF';
        b_flag BOOLEAN;
        v_cur PKG_MCRE0_UTILS.cur_abi_type;
        v_count NUMBER;



   BEGIN

     DBMS_OUTPUT.PUT_LINE('INIZIALIZZO CURSORE X SOTTOPARTIZIONE COD_ABI');

     OPEN v_cur FOR SELECT DISTINCT COD_ABI
     FROM T_MCRE0_APP_ISTITUTI;

       DBMS_OUTPUT.PUT_LINE('CURSORE X SOTTOPARTIZIONE COD_ABI INIZIALIZZATO');

     b_flag := PKG_MCRE0_PARTIZIONI.FND_MCRE0_add_partition(p_rec.SEQ_FLUSSO,p_rec.TAB_TRG,p_rec.PERIODO,v_cur);


     IF(b_flag) THEN

             INSERT
             WHEN
             NUM_RECS = 1
             AND TRIM(TO_CHAR(ID_DPER)) IS NOT NULL
             AND TRIM(TO_CHAR(COD_ABI_ISTITUTO)) IS NOT NULL
             AND TRIM(TO_CHAR(COD_NDG)) IS NOT NULL

             THEN
                INTO T_MCRE0_ST_PEF
                            (ID_DPER    ,
                            COD_ABI_ISTITUTO    ,
                            COD_NDG    ,
                            COD_PEF    ,
                            COD_FASE_PEF    ,
                            DTA_ULTIMA_REVISIONE    ,
                            DTA_SCADENZA_FIDO    ,
                            DTA_ULTIMA_DELIBERA    ,
                            FLG_FIDI_SCADUTI    ,
                            DAT_ULTIMO_SCADUTO    ,
                            COD_ULTIMO_ODE    ,
                            COD_CTS_ULTIMO_ODE    ,
                            COD_STRATEGIA_CRZ    ,
                            COD_ODE    ,
                            DTA_COMPLETAMENTO_PEF,
                            DTA_SCA_REV_PEF
                            )

                           VALUES (
                             ID_DPER    ,
                            COD_ABI_ISTITUTO    ,
                            COD_NDG    ,
                            COD_PEF    ,
                            COD_FASE_PEF    ,
                            DTA_ULTIMA_REVISIONE    ,
                            DTA_SCADENZA_FIDO    ,
                            DTA_ULTIMA_DELIBERA    ,
                            FLG_FIDI_SCADUTI    ,
                            DAT_ULTIMO_SCADUTO    ,
                            COD_ULTIMO_ODE    ,
                            COD_CTS_ULTIMO_ODE    ,
                            COD_STRATEGIA_CRZ    ,
                            COD_ODE    ,
                            DTA_COMPLETAMENTO_PEF,
                            DTA_SCA_REV_PEF
                             )

             WHEN
             NUM_RECS > 1
             OR TRIM(TO_CHAR(ID_DPER)) IS NULL
             OR TRIM(TO_CHAR(COD_ABI_ISTITUTO)) IS NULL
             OR TRIM(TO_CHAR(COD_NDG)) IS NULL

             THEN
             INTO T_MCRE0_SC_VINCOLI_PEF (
            ID_SEQ    ,
            ID_DPER    ,
            COD_ABI_ISTITUTO    ,
            COD_NDG    ,
            COD_PEF    ,
            COD_FASE_PEF    ,
            DTA_ULTIMA_REVISIONE    ,
            DTA_SCADENZA_FIDO    ,
            DTA_ULTIMA_DELIBERA    ,
            FLG_FIDI_SCADUTI    ,
            DAT_ULTIMO_SCADUTO    ,
            COD_ULTIMO_ODE    ,
            COD_CTS_ULTIMO_ODE    ,
            COD_STRATEGIA_CRZ    ,
            COD_ODE    ,
            DTA_COMPLETAMENTO_PEF,
            DTA_SCA_REV_PEF

            )
            VALUES (
            p_rec.SEQ_FLUSSO,
            ID_DPER    ,
            COD_ABI_ISTITUTO    ,
            COD_NDG    ,
            COD_PEF    ,
            COD_FASE_PEF    ,
            DTA_ULTIMA_REVISIONE    ,
            DTA_SCADENZA_FIDO    ,
            DTA_ULTIMA_DELIBERA    ,
            FLG_FIDI_SCADUTI    ,
            DAT_ULTIMO_SCADUTO    ,
            COD_ULTIMO_ODE    ,
            COD_CTS_ULTIMO_ODE    ,
            COD_STRATEGIA_CRZ    ,
            COD_ODE    ,
            DTA_COMPLETAMENTO_PEF,
            DTA_SCA_REV_PEF
            )


             SELECT * FROM
        (
            SELECT
                COUNT(1) OVER(PARTITION BY ID_DPER, COD_ABI_ISTITUTO, COD_NDG) NUM_RECS,
                 ID_DPER    ,
            COD_ABI_ISTITUTO    ,
            COD_NDG    ,
            COD_PEF    ,
            COD_FASE_PEF    ,
            DTA_ULTIMA_REVISIONE    ,
            DTA_SCADENZA_FIDO    ,
            DTA_ULTIMA_DELIBERA    ,
            FLG_FIDI_SCADUTI    ,
            DAT_ULTIMO_SCADUTO    ,
            COD_ULTIMO_ODE    ,
            COD_CTS_ULTIMO_ODE    ,
            COD_STRATEGIA_CRZ    ,
            COD_ODE    ,
            DTA_COMPLETAMENTO_PEF,
            DTA_SCA_REV_PEF

            FROM
              T_MCRE0_FL_PEF
        ) tmp;
        COMMIT;



          SELECT COUNT(*)
          INTO v_count
          FROM T_MCRE0_SC_VINCOLI_PEF SC
          WHERE SC.ID_SEQ = p_rec.SEQ_FLUSSO;


          UPDATE T_MCRE0_WRK_ACQUISIZIONE
          SET SCARTI_VINCOLI = v_count
          WHERE ID_FLUSSO = p_rec.SEQ_FLUSSO;
          COMMIT;


            b_flag := TRUE;

     END IF;




         IF(b_flag) THEN

        PKG_MCRE0_LOG.SPO_MCRE0_LOG_EVENTO(p_rec.SEQ_FLUSSO,c_nome,'OK','DATI INSERITI CORRETTAMENTE');

        END IF;

      --close v_cur;

           /*  BEGIN

                SELECT VALORE_COSTANTE INTO v_mesi_svecchiamento
                FROM T_MCRE0_WRK_CONFIGURAZIONE
                WHERE NOME_COSTANTE = 'MESI_SVECCHIAMENTO_PEFORATI';

            EXCEPTION

                WHEN OTHERS THEN

                    v_mesi_svecchiamento := 0;

                    PKG_MCRE0_LOG.SPO_MCRE0_LOG_EVENTO(p_rec.SEQ_FLUSSO,c_nome,'ATTENZIONE','Svecchiamento non eseguibile per problemi di rilevamento della costante ''MESI_SVECCHIAMENTO_PEFORATI'' nella tabella ''T_MCRE0_WRK_CONFIGURAZIONE''');

            END;

            IF(v_mesi_svecchiamento > 0) THEN

             b_flag := svecchiamento_p31(p_rec.SEQ_FLUSSO,p_rec.TAB_TRG,p_rec.PERIODO,v_mesi_svecchiamento);

            END IF;*/



        RETURN TRUE;


            EXCEPTION


        WHEN OTHERS THEN

        DBMS_OUTPUT.PUT_LINE('ERRORE IN FND_MCRE0_alimenta_PEF');
         DBMS_OUTPUT.PUT_LINE(SUBSTR(SQLERRM, 1, 255));
            ROLLBACK;




           IF(v_cur%ISOPEN) THEN

                    CLOSE v_cur;

                     DBMS_OUTPUT.PUT_LINE('ERRORE IN FND_MCRE0_alimenta_PEF - CLOSE CURSOR');

                END IF;

            PKG_MCRE0_LOG.SPO_MCRE0_log_evento_no_commit(p_rec.SEQ_FLUSSO,p_rec.TAB_TRG,'ERRORE',SUBSTR(SQLERRM, 1, 255));

            RETURN FALSE;

     END FND_MCRE0_alimenta_PEF;

FUNCTION FND_MCRE0_alimenta_PEF_ap(p_rec IN f_slave_par_type) RETURN BOOLEAN IS

  v_partition varchar2(20);
  v_sql varchar2(5000);


   BEGIN


   v_partition := 'CCP_P'|| TO_CHAR(p_rec.PERIODO, 'yyyymmdd');

          v_sql :=  'BEGIN MERGE

               INTO  T_MCRE0_APP_PEF24 trg

               USING T_MCRE0_ST_PEF  PARTITION('||v_partition||') src

               ON  ( trg.COD_ABI_ISTITUTO=src.COD_ABI_ISTITUTO
                     and trg.COD_NDG=src.COD_NDG)

            WHEN MATCHED

            THEN

              UPDATE

              SET

                trg.COD_PEF= src.COD_PEF,
                trg.COD_FASE_PEF= src.COD_FASE_PEF,
                trg.DTA_ULTIMA_REVISIONE= src.DTA_ULTIMA_REVISIONE,
                trg.DTA_SCADENZA_FIDO= src.DTA_SCADENZA_FIDO,
                trg.DTA_ULTIMA_DELIBERA= src.DTA_ULTIMA_DELIBERA,
                trg.FLG_FIDI_SCADUTI= src.FLG_FIDI_SCADUTI,
                trg.DAT_ULTIMO_SCADUTO= src.DAT_ULTIMO_SCADUTO,
                trg.COD_ULTIMO_ODE= src.COD_ULTIMO_ODE,
                trg.COD_CTS_ULTIMO_ODE= src.COD_CTS_ULTIMO_ODE,
                trg.COD_STRATEGIA_CRZ= src.COD_STRATEGIA_CRZ,
                trg.COD_ODE= src.COD_ODE,
                trg.DTA_COMPLETAMENTO_PEF= src.DTA_COMPLETAMENTO_PEF,
                trg.DTA_UPD= sysdate,
                trg.COD_OPERATORE_INS_UPD = NULL,
                trg.ID_DPER = src.ID_DPER,
                trg.DTA_SCA_REV_PEF = src.DTA_SCA_REV_PEF



           WHEN NOT MATCHED
           THEN
              INSERT (
                        trg.COD_ABI_ISTITUTO,
                        trg.COD_NDG,
                        trg.COD_PEF,
                        trg.COD_FASE_PEF,
                        trg.DTA_ULTIMA_REVISIONE,
                        trg.DTA_SCADENZA_FIDO,
                        trg.DTA_ULTIMA_DELIBERA,
                        trg.FLG_FIDI_SCADUTI,
                        trg.DAT_ULTIMO_SCADUTO,
                        trg.COD_ULTIMO_ODE,
                        trg.COD_CTS_ULTIMO_ODE,
                        trg.COD_STRATEGIA_CRZ,
                        trg.COD_ODE,
                        trg.DTA_COMPLETAMENTO_PEF,
                        trg.DTA_INS    ,
                        trg.DTA_UPD    ,
                        trg.COD_OPERATORE_INS_UPD    ,
                        trg.ID_DPER,
                        trg.DTA_SCA_REV_PEF

                        )



              VALUES (
                        src.COD_ABI_ISTITUTO,
                        src.COD_NDG,
                        src.COD_PEF,
                        src.COD_FASE_PEF,
                        src.DTA_ULTIMA_REVISIONE,
                        src.DTA_SCADENZA_FIDO,
                        src.DTA_ULTIMA_DELIBERA,
                        src.FLG_FIDI_SCADUTI,
                        src.DAT_ULTIMO_SCADUTO,
                        src.COD_ULTIMO_ODE,
                        src.COD_CTS_ULTIMO_ODE,
                        src.COD_STRATEGIA_CRZ,
                        src.COD_ODE,
                        src.DTA_COMPLETAMENTO_PEF,
                        sysdate,
                        sysdate,
                        NULL,
                        src.ID_DPER,
                        src.DTA_SCA_REV_PEF );

            commit;
            END;';


            DBMS_OUTPUT.PUT_LINE(v_sql);


              EXECUTE IMMEDIATE v_sql;

              RETURN TRUE;


                EXCEPTION WHEN OTHERS THEN

                  DBMS_OUTPUT.PUT_LINE(SUBSTR(SQLERRM, 1, 255));



                END FND_MCRE0_alimenta_PEF_ap;


---------------------------------------------------------------------------
/********************** FLUSSI CR *******************************/
---------------------------------------------------------------------------

FUNCTION FND_MCRE0_alimenta_CR_SC_GB(p_rec IN f_slave_par_type) RETURN BOOLEAN IS

        c_nome CONSTANT VARCHAR2(100) := c_package || '.FND_MCRE0_alimenta_CR_SC_GB';
        b_flag BOOLEAN;
        v_cur PKG_MCRE0_UTILS.cur_abi_type;
        v_count NUMBER;



   BEGIN

     DBMS_OUTPUT.PUT_LINE('INIZIALIZZO CURSORE X SOTTOPARTIZIONE COD_ABI');

     open v_cur for select distinct COD_ABI
     from T_MCRE0_APP_ISTITUTI;

       DBMS_OUTPUT.PUT_LINE('CURSORE X SOTTOPARTIZIONE COD_ABI INIZIALIZZATO');

     b_flag := PKG_MCRE0_PARTIZIONI.FND_MCRE0_add_partition(p_rec.SEQ_FLUSSO,p_rec.TAB_TRG,p_rec.PERIODO,v_cur);


     IF(b_flag) THEN


                  insert
             when
             NUM_RECS = 1
             AND TRIM(TO_CHAR(ID_DPER)) IS NOT NULL
             AND TRIM(TO_CHAR(COD_SNDG)) IS NOT NULL



            then

            INTO T_MCRE0_ST_CR_SC_GB (
            ID_DPER    ,
            DTA_RIFERIMENTO_CR    ,
            DTA_STATO_SIS    ,
            VAL_ACC_CR_SC    ,
            VAL_ACC_SIS_SC    ,
            VAL_GAR_CR_SC    ,
            VAL_GAR_SIS_SC    ,
            VAL_SCO_CR_SC    ,
            VAL_SCO_SIS_SC    ,
            VAL_UTI_CR_SC    ,
            VAL_UTI_SIS_SC    ,
            COD_SNDG    ,
            COD_STATO_SIS


            )
            VALUES (
            ID_DPER    ,
            DTA_RIFERIMENTO_CR    ,
            DTA_STATO_SIS    ,
            VAL_ACC_CR_SC    ,
            VAL_ACC_SIS_SC    ,
            VAL_GAR_CR_SC    ,
            VAL_GAR_SIS_SC    ,
            VAL_SCO_CR_SC    ,
            VAL_SCO_SIS_SC    ,
            VAL_UTI_CR_SC    ,
            VAL_UTI_SIS_SC    ,
            COD_SNDG    ,
            COD_STATO_SIS
            )

             when
             NUM_RECS > 1
             OR TRIM(TO_CHAR(ID_DPER)) IS NULL
             OR TRIM(TO_CHAR(COD_SNDG)) IS NULL


             then
             INTO T_MCRE0_SC_VINCOLI_CR_SC_GB (
                ID_SEQ    ,
                ID_DPER ,
                DTA_RIFERIMENTO_CR    ,
                DTA_STATO_SIS    ,
                VAL_ACC_CR_SC    ,
                VAL_ACC_SIS_SC    ,
                VAL_GAR_CR_SC    ,
                VAL_GAR_SIS_SC    ,
                VAL_SCO_CR_SC    ,
                VAL_SCO_SIS_SC    ,
                VAL_UTI_CR_SC    ,
                VAL_UTI_SIS_SC    ,
                COD_SNDG    ,
                COD_STATO_SIS
                )

                VALUES (
                p_rec.SEQ_FLUSSO,
                ID_DPER ,
                DTA_RIFERIMENTO_CR    ,
                DTA_STATO_SIS    ,
                VAL_ACC_CR_SC    ,
                VAL_ACC_SIS_SC    ,
                VAL_GAR_CR_SC    ,
                VAL_GAR_SIS_SC    ,
                VAL_SCO_CR_SC    ,
                VAL_SCO_SIS_SC    ,
                VAL_UTI_CR_SC    ,
                VAL_UTI_SIS_SC    ,
                COD_SNDG    ,
                COD_STATO_SIS
                   )


             select * from
        (
            SELECT
                COUNT(1) OVER(PARTITION BY  ID_DPER, COD_SNDG) NUM_RECS,
                ID_DPER    ,
                DTA_RIFERIMENTO_CR    ,
                DTA_STATO_SIS    ,
                VAL_ACC_CR_SC    ,
                VAL_ACC_SIS_SC    ,
                VAL_GAR_CR_SC    ,
                VAL_GAR_SIS_SC    ,
                VAL_SCO_CR_SC    ,
                VAL_SCO_SIS_SC    ,
                VAL_UTI_CR_SC    ,
                VAL_UTI_SIS_SC    ,
                COD_SNDG    ,
                COD_STATO_SIS


            FROM
              T_MCRE0_FL_CR_SC_GB
        ) tmp;
        COMMIT;

           SELECT COUNT(*)
          INTO v_count
          FROM T_MCRE0_SC_VINCOLI_CR_SC_GB   SC
          WHERE SC.ID_SEQ = p_rec.SEQ_FLUSSO;


          UPDATE T_MCRE0_WRK_ACQUISIZIONE
          SET SCARTI_VINCOLI = v_count
          WHERE ID_FLUSSO = p_rec.SEQ_FLUSSO;
          commit;



        b_flag := TRUE;


     END IF;

         IF(b_flag) THEN

        PKG_MCRE0_LOG.SPO_MCRE0_LOG_EVENTO(p_rec.SEQ_FLUSSO,c_nome,'OK','DATI INSERITI CORRETTAMENTE');

        END IF;



        RETURN b_flag;


            EXCEPTION


        WHEN OTHERS THEN

        DBMS_OUTPUT.PUT_LINE('ERRORE IN FND_MCRE0_alimenta_CR_SC_GB');
         DBMS_OUTPUT.PUT_LINE(SUBSTR(SQLERRM, 1, 255));
            ROLLBACK;

           IF(v_cur%ISOPEN) THEN

                    CLOSE v_cur;

                     DBMS_OUTPUT.PUT_LINE('ERRORE IN FND_MCRE0_alimenta_CR_SC_GB - CLOSE CURSOR');

                END IF;

            PKG_MCRE0_LOG.SPO_MCRE0_log_evento_no_commit(p_rec.SEQ_FLUSSO,p_rec.TAB_TRG,'ERRORE',SUBSTR(SQLERRM, 1, 255));

            RETURN FALSE;

     END FND_MCRE0_alimenta_CR_SC_GB;


FUNCTION FND_MCRE0_alimenta_CR_SC_GB_ap(p_rec IN f_slave_par_type) RETURN BOOLEAN IS

  v_partition varchar2(20);
  v_sql varchar2(5000);


   begin


   v_partition := 'CCP_P'|| to_char(p_rec.PERIODO, 'yyyymmdd');

          v_sql :=  'BEGIN MERGE

               INTO  T_MCRE0_APP_CR_SC_GB24 trg

               USING T_MCRE0_ST_CR_SC_GB  PARTITION(' || v_partition || ') src

               ON  ( trg.COD_SNDG=src.COD_SNDG)

            WHEN MATCHED

            THEN

              UPDATE

              SET
                trg.DTA_RIFERIMENTO_CR=src.DTA_RIFERIMENTO_CR,
                trg.DTA_STATO_SIS=src.DTA_STATO_SIS,
                trg.VAL_ACC_CR_SC=src.VAL_ACC_CR_SC,
                trg.VAL_ACC_SIS_SC=src.VAL_ACC_SIS_SC,
                trg.VAL_GAR_CR_SC=src.VAL_GAR_CR_SC,
                trg.VAL_GAR_SIS_SC=src.VAL_GAR_SIS_SC,
                trg.VAL_SCO_CR_SC=src.VAL_SCO_CR_SC,
                trg.VAL_SCO_SIS_SC=src.VAL_SCO_SIS_SC,
                trg.VAL_UTI_CR_SC=src.VAL_UTI_CR_SC,
                trg.VAL_UTI_SIS_SC=src.VAL_UTI_SIS_SC,
                trg.COD_STATO_SIS=src.COD_STATO_SIS,
                trg.DTA_UPD= sysdate,
                trg.COD_OPERATORE_INS_UPD = NULL,
                trg.ID_DPER = src.ID_DPER



           WHEN NOT MATCHED
           THEN
              INSERT (
                        trg.DTA_RIFERIMENTO_CR,
                        trg.DTA_STATO_SIS,
                        trg.VAL_ACC_CR_SC,
                        trg.VAL_ACC_SIS_SC,
                        trg.VAL_GAR_CR_SC,
                        trg.VAL_GAR_SIS_SC,
                        trg.VAL_SCO_CR_SC,
                        trg.VAL_SCO_SIS_SC,
                        trg.VAL_UTI_CR_SC,
                        trg.VAL_UTI_SIS_SC,
                        trg.COD_SNDG,
                        trg.COD_STATO_SIS,
                        trg.DTA_INS    ,
                        trg.DTA_UPD    ,
                        trg.COD_OPERATORE_INS_UPD    ,
                        trg.ID_DPER

                        )

              VALUES (
                        src.DTA_RIFERIMENTO_CR,
                        src.DTA_STATO_SIS,
                        src.VAL_ACC_CR_SC,
                        src.VAL_ACC_SIS_SC,
                        src.VAL_GAR_CR_SC,
                        src.VAL_GAR_SIS_SC,
                        src.VAL_SCO_CR_SC,
                        src.VAL_SCO_SIS_SC,
                        src.VAL_UTI_CR_SC,
                        src.VAL_UTI_SIS_SC,
                        src.COD_SNDG,
                        src.COD_STATO_SIS,
                        sysdate,
                        sysdate,
                        NULL,
                        src.ID_DPER );

            commit;
            END;';


            DBMS_OUTPUT.PUT_LINE(v_sql);


              execute immediate v_sql;

              RETURN TRUE;


                EXCEPTION WHEN OTHERS THEN

                  DBMS_OUTPUT.PUT_LINE(SUBSTR(SQLERRM, 1, 255));



                end FND_MCRE0_alimenta_CR_SC_GB_ap;



FUNCTION FND_MCRE0_alimenta_CR_GE_GB(p_rec IN f_slave_par_type) RETURN BOOLEAN IS

        c_nome CONSTANT VARCHAR2(100) := c_package || '.FND_MCRE0_alimenta_CR_GE_GB';
        b_flag BOOLEAN;
        v_cur PKG_MCRE0_UTILS.cur_abi_type;
        v_count NUMBER;



   BEGIN

     DBMS_OUTPUT.PUT_LINE('INIZIALIZZO CURSORE X SOTTOPARTIZIONE COD_ABI');

     open v_cur for select distinct COD_ABI
     from T_MCRE0_APP_ISTITUTI;

       DBMS_OUTPUT.PUT_LINE('CURSORE X SOTTOPARTIZIONE COD_ABI INIZIALIZZATO');

     b_flag := PKG_MCRE0_PARTIZIONI.FND_MCRE0_add_partition(p_rec.SEQ_FLUSSO,p_rec.TAB_TRG,p_rec.PERIODO,v_cur);


     IF(b_flag) THEN


                  insert
             when
             NUM_RECS = 1
             AND TRIM(TO_CHAR(ID_DPER)) IS NOT NULL
             AND TRIM(TO_CHAR(COD_SNDG_GE)) IS NOT NULL



            then

            INTO T_MCRE0_ST_CR_GE_GB (
                ID_DPER    ,
                DTA_RIFERIMENTO_CR    ,
                VAL_ACC_CR_GE    ,
                VAL_ACC_SIS_GE    ,
                VAL_GAR_CR_GE    ,
                VAL_GAR_SIS_GE    ,
                VAL_SCO_CR_GE    ,
                VAL_SCO_SIS_GE    ,
                VAL_UTI_CR_GE    ,
                VAL_UTI_SIS_GE    ,
                COD_SNDG_GE



            )
            VALUES (
                ID_DPER    ,
                DTA_RIFERIMENTO_CR    ,
                VAL_ACC_CR_GE    ,
                VAL_ACC_SIS_GE    ,
                VAL_GAR_CR_GE    ,
                VAL_GAR_SIS_GE    ,
                VAL_SCO_CR_GE    ,
                VAL_SCO_SIS_GE    ,
                VAL_UTI_CR_GE    ,
                VAL_UTI_SIS_GE    ,
                COD_SNDG_GE
            )

             when
             NUM_RECS > 1
             OR TRIM(TO_CHAR(ID_DPER)) IS NULL
             OR TRIM(TO_CHAR(COD_SNDG_GE)) IS NULL


             then
             INTO T_MCRE0_SC_VINCOLI_CR_GE_GB (
                ID_SEQ    ,
                ID_DPER    ,
                DTA_RIFERIMENTO_CR    ,
                VAL_ACC_CR_GE    ,
                VAL_ACC_SIS_GE    ,
                VAL_GAR_CR_GE    ,
                VAL_GAR_SIS_GE    ,
                VAL_SCO_CR_GE    ,
                VAL_SCO_SIS_GE    ,
                VAL_UTI_CR_GE    ,
                VAL_UTI_SIS_GE    ,
                COD_SNDG_GE
                )

                VALUES (
                p_rec.SEQ_FLUSSO,
                ID_DPER    ,
                DTA_RIFERIMENTO_CR    ,
                VAL_ACC_CR_GE    ,
                VAL_ACC_SIS_GE    ,
                VAL_GAR_CR_GE    ,
                VAL_GAR_SIS_GE    ,
                VAL_SCO_CR_GE    ,
                VAL_SCO_SIS_GE    ,
                VAL_UTI_CR_GE    ,
                VAL_UTI_SIS_GE    ,
                COD_SNDG_GE
                   )


             select * from
        (
            SELECT
                COUNT(1) OVER(PARTITION BY  ID_DPER, COD_SNDG_GE) NUM_RECS,
                ID_DPER    ,
                DTA_RIFERIMENTO_CR    ,
                VAL_ACC_CR_GE    ,
                VAL_ACC_SIS_GE    ,
                VAL_GAR_CR_GE    ,
                VAL_GAR_SIS_GE    ,
                VAL_SCO_CR_GE    ,
                VAL_SCO_SIS_GE    ,
                VAL_UTI_CR_GE    ,
                VAL_UTI_SIS_GE    ,
                COD_SNDG_GE


            FROM
              T_MCRE0_FL_CR_GE_GB
        ) tmp;
        COMMIT;

           SELECT COUNT(*)
          INTO v_count
          FROM T_MCRE0_SC_VINCOLI_CR_GE_GB   SC
          WHERE SC.ID_SEQ = p_rec.SEQ_FLUSSO;


          UPDATE T_MCRE0_WRK_ACQUISIZIONE
          SET SCARTI_VINCOLI = v_count
          WHERE ID_FLUSSO = p_rec.SEQ_FLUSSO;
          commit;



        b_flag := TRUE;


     END IF;

         IF(b_flag) THEN

        PKG_MCRE0_LOG.SPO_MCRE0_LOG_EVENTO(p_rec.SEQ_FLUSSO,c_nome,'OK','DATI INSERITI CORRETTAMENTE');

        END IF;



        RETURN b_flag;


            EXCEPTION


        WHEN OTHERS THEN

        DBMS_OUTPUT.PUT_LINE('ERRORE IN FND_MCRE0_alimenta_CR_GE_GB');
         DBMS_OUTPUT.PUT_LINE(SUBSTR(SQLERRM, 1, 255));
            ROLLBACK;

           IF(v_cur%ISOPEN) THEN

                    CLOSE v_cur;

                     DBMS_OUTPUT.PUT_LINE('ERRORE IN FND_MCRE0_alimenta_CR_GE_GB - CLOSE CURSOR');

                END IF;

            PKG_MCRE0_LOG.SPO_MCRE0_log_evento_no_commit(p_rec.SEQ_FLUSSO,p_rec.TAB_TRG,'ERRORE',SUBSTR(SQLERRM, 1, 255));

            RETURN FALSE;

     END FND_MCRE0_alimenta_CR_GE_GB;


FUNCTION FND_MCRE0_alimenta_CR_GE_GB_ap(p_rec IN f_slave_par_type) RETURN BOOLEAN IS

  v_partition varchar2(20);
  v_sql varchar2(5000);


   begin


   v_partition := 'CCP_P'|| to_char(p_rec.PERIODO, 'yyyymmdd');

          v_sql :=  'BEGIN MERGE

               INTO  T_MCRE0_APP_CR_GE_GB24 trg

               USING T_MCRE0_ST_CR_GE_GB  PARTITION(' || v_partition || ') src

               ON  (trg.COD_SNDG_GE=src.COD_SNDG_GE)

            WHEN MATCHED

            THEN

              UPDATE

              SET
                trg.DTA_RIFERIMENTO_CR=src.DTA_RIFERIMENTO_CR,
                trg.VAL_ACC_CR_GE=src.VAL_ACC_CR_GE,
                trg.VAL_ACC_SIS_GE=src.VAL_ACC_SIS_GE,
                trg.VAL_GAR_CR_GE=src.VAL_GAR_CR_GE,
                trg.VAL_GAR_SIS_GE=src.VAL_GAR_SIS_GE,
                trg.VAL_SCO_CR_GE=src.VAL_SCO_CR_GE,
                trg.VAL_SCO_SIS_GE=src.VAL_SCO_SIS_GE,
                trg.VAL_UTI_CR_GE=src.VAL_UTI_CR_GE,
                trg.VAL_UTI_SIS_GE=src.VAL_UTI_SIS_GE,
                trg.DTA_UPD= sysdate,
                trg.COD_OPERATORE_INS_UPD = NULL,
                trg.ID_DPER = src.ID_DPER



           WHEN NOT MATCHED
           THEN
              INSERT (
                        trg.DTA_RIFERIMENTO_CR,
                        trg.VAL_ACC_CR_GE,
                        trg.VAL_ACC_SIS_GE,
                        trg.VAL_GAR_CR_GE,
                        trg.VAL_GAR_SIS_GE,
                        trg.VAL_SCO_CR_GE,
                        trg.VAL_SCO_SIS_GE,
                        trg.VAL_UTI_CR_GE,
                        trg.VAL_UTI_SIS_GE,
                        trg.COD_SNDG_GE,
                        trg.DTA_INS    ,
                        trg.DTA_UPD    ,
                        trg.COD_OPERATORE_INS_UPD    ,
                        trg.ID_DPER

                        )

              VALUES (
                        src.DTA_RIFERIMENTO_CR,
                        src.VAL_ACC_CR_GE,
                        src.VAL_ACC_SIS_GE,
                        src.VAL_GAR_CR_GE,
                        src.VAL_GAR_SIS_GE,
                        src.VAL_SCO_CR_GE,
                        src.VAL_SCO_SIS_GE,
                        src.VAL_UTI_CR_GE,
                        src.VAL_UTI_SIS_GE,
                        src.COD_SNDG_GE,
                        sysdate,
                        sysdate,
                        NULL,
                        src.ID_DPER );

            commit;
            END;';


            DBMS_OUTPUT.PUT_LINE(v_sql);


              execute immediate v_sql;

              RETURN TRUE;


                EXCEPTION WHEN OTHERS THEN

                  DBMS_OUTPUT.PUT_LINE(SUBSTR(SQLERRM, 1, 255));



                end FND_MCRE0_alimenta_CR_GE_GB_ap;



FUNCTION FND_MCRE0_alimenta_CR_LG_GB(p_rec IN f_slave_par_type) RETURN BOOLEAN IS

        c_nome CONSTANT VARCHAR2(100) := c_package || '.FND_MCRE0_alimenta_CR_LG_GB';
        b_flag BOOLEAN;
        v_cur PKG_MCRE0_UTILS.cur_abi_type;
        v_count NUMBER;



   BEGIN

     DBMS_OUTPUT.PUT_LINE('INIZIALIZZO CURSORE X SOTTOPARTIZIONE COD_ABI');

     open v_cur for select distinct COD_ABI
     from T_MCRE0_APP_ISTITUTI;

       DBMS_OUTPUT.PUT_LINE('CURSORE X SOTTOPARTIZIONE COD_ABI INIZIALIZZATO');

     b_flag := PKG_MCRE0_PARTIZIONI.FND_MCRE0_add_partition(p_rec.SEQ_FLUSSO,p_rec.TAB_TRG,p_rec.PERIODO,v_cur);


     IF(b_flag) THEN


                  insert
             when
             NUM_RECS = 1
             AND TRIM(TO_CHAR(ID_DPER)) IS NOT NULL
             AND TRIM(TO_CHAR(COD_SNDG_LG)) IS NOT NULL



            then

            INTO T_MCRE0_ST_CR_LG_GB (
                ID_DPER    ,
                COD_SNDG_LG    ,
                VAL_ACC_LGGB    ,
                VAL_UTI_LGGB    ,
                VAL_SCO_LGGB    ,
                VAL_GAR_LGGB    ,
                VAL_ACC_SIS_LG    ,
                VAL_UTI_SIS_LG    ,
                VAL_SCO_SIS_LG    ,
                VAL_IMP_GAR_SIS_LG    ,
                DTA_RIFERIMENTO_CR


            )
            VALUES (
                ID_DPER    ,
                COD_SNDG_LG    ,
                VAL_ACC_LGGB    ,
                VAL_UTI_LGGB    ,
                VAL_SCO_LGGB    ,
                VAL_GAR_LGGB    ,
                VAL_ACC_SIS_LG    ,
                VAL_UTI_SIS_LG    ,
                VAL_SCO_SIS_LG    ,
                VAL_IMP_GAR_SIS_LG    ,
                DTA_RIFERIMENTO_CR
            )

             when
             NUM_RECS > 1
             OR TRIM(TO_CHAR(ID_DPER)) IS NULL
             OR TRIM(TO_CHAR(COD_SNDG_LG)) IS NULL


             then
             INTO T_MCRE0_SC_VINCOLI_CR_LG_GB (
                ID_SEQ    ,
                ID_DPER    ,
                COD_SNDG_LG    ,
                VAL_ACC_LGGB    ,
                VAL_UTI_LGGB    ,
                VAL_SCO_LGGB    ,
                VAL_GAR_LGGB    ,
                VAL_ACC_SIS_LG    ,
                VAL_UTI_SIS_LG    ,
                VAL_SCO_SIS_LG    ,
                VAL_IMP_GAR_SIS_LG    ,
                DTA_RIFERIMENTO_CR
                )

                VALUES (
                p_rec.SEQ_FLUSSO,
                ID_DPER    ,
                COD_SNDG_LG    ,
                VAL_ACC_LGGB    ,
                VAL_UTI_LGGB    ,
                VAL_SCO_LGGB    ,
                VAL_GAR_LGGB    ,
                VAL_ACC_SIS_LG    ,
                VAL_UTI_SIS_LG    ,
                VAL_SCO_SIS_LG    ,
                VAL_IMP_GAR_SIS_LG    ,
                DTA_RIFERIMENTO_CR
                   )


             select * from
        (
            SELECT
                COUNT(1) OVER(PARTITION BY  ID_DPER, COD_SNDG_LG) NUM_RECS,
                ID_DPER    ,
                COD_SNDG_LG    ,
                VAL_ACC_LGGB    ,
                VAL_UTI_LGGB    ,
                VAL_SCO_LGGB    ,
                VAL_GAR_LGGB    ,
                VAL_ACC_SIS_LG    ,
                VAL_UTI_SIS_LG    ,
                VAL_SCO_SIS_LG    ,
                VAL_IMP_GAR_SIS_LG    ,
                DTA_RIFERIMENTO_CR


            FROM
              T_MCRE0_FL_CR_LG_GB
        ) tmp;
        COMMIT;

           SELECT COUNT(*)
          INTO v_count
          FROM T_MCRE0_SC_VINCOLI_CR_LG_GB   SC
          WHERE SC.ID_SEQ = p_rec.SEQ_FLUSSO;


          UPDATE T_MCRE0_WRK_ACQUISIZIONE
          SET SCARTI_VINCOLI = v_count
          WHERE ID_FLUSSO = p_rec.SEQ_FLUSSO;
          commit;



        b_flag := TRUE;


     END IF;

         IF(b_flag) THEN

        PKG_MCRE0_LOG.SPO_MCRE0_LOG_EVENTO(p_rec.SEQ_FLUSSO,c_nome,'OK','DATI INSERITI CORRETTAMENTE');

        END IF;



        RETURN b_flag;


            EXCEPTION


        WHEN OTHERS THEN

        DBMS_OUTPUT.PUT_LINE('ERRORE IN FND_MCRE0_alimenta_CR_LG_GB');
         DBMS_OUTPUT.PUT_LINE(SUBSTR(SQLERRM, 1, 255));
            ROLLBACK;

           IF(v_cur%ISOPEN) THEN

                    CLOSE v_cur;

                     DBMS_OUTPUT.PUT_LINE('ERRORE IN FND_MCRE0_alimenta_CR_LG_GB - CLOSE CURSOR');

                END IF;

            PKG_MCRE0_LOG.SPO_MCRE0_log_evento_no_commit(p_rec.SEQ_FLUSSO,p_rec.TAB_TRG,'ERRORE',SUBSTR(SQLERRM, 1, 255));

            RETURN FALSE;

     END FND_MCRE0_alimenta_CR_LG_GB;


FUNCTION FND_MCRE0_alimenta_CR_LG_GB_ap(p_rec IN f_slave_par_type) RETURN BOOLEAN IS

  v_partition varchar2(20);
  v_sql varchar2(5000);


   begin


   v_partition := 'CCP_P'|| to_char(p_rec.PERIODO, 'yyyymmdd');

          v_sql :=  'BEGIN MERGE

               INTO  T_MCRE0_APP_CR_LG_GB24 trg

               USING T_MCRE0_ST_CR_LG_GB  PARTITION(' || v_partition || ') src

               ON  (trg.COD_SNDG_LG=src.COD_SNDG_LG)

            WHEN MATCHED

            THEN

              UPDATE

              SET
                    trg.VAL_ACC_LGGB=src.VAL_ACC_LGGB,
                    trg.VAL_UTI_LGGB=src.VAL_UTI_LGGB,
                    trg.VAL_SCO_LGGB=src.VAL_SCO_LGGB,
                    trg.VAL_GAR_LGGB=src.VAL_GAR_LGGB,
                    trg.VAL_ACC_SIS_LG=src.VAL_ACC_SIS_LG,
                    trg.VAL_UTI_SIS_LG=src.VAL_UTI_SIS_LG,
                    trg.VAL_SCO_SIS_LG=src.VAL_SCO_SIS_LG,
                    trg.VAL_IMP_GAR_SIS_LG=src.VAL_IMP_GAR_SIS_LG,
                    trg.DTA_RIFERIMENTO_CR=src.DTA_RIFERIMENTO_CR,
                    trg.DTA_UPD= sysdate,
                    trg.COD_OPERATORE_INS_UPD = NULL,
                    trg.ID_DPER = src.ID_DPER



           WHEN NOT MATCHED
           THEN
              INSERT (
                        trg.COD_SNDG_LG,
                        trg.VAL_ACC_LGGB,
                        trg.VAL_UTI_LGGB,
                        trg.VAL_SCO_LGGB,
                        trg.VAL_GAR_LGGB,
                        trg.VAL_ACC_SIS_LG,
                        trg.VAL_UTI_SIS_LG,
                        trg.VAL_SCO_SIS_LG,
                        trg.VAL_IMP_GAR_SIS_LG,
                        trg.DTA_RIFERIMENTO_CR,
                        trg.DTA_INS    ,
                        trg.DTA_UPD    ,
                        trg.COD_OPERATORE_INS_UPD    ,
                        trg.ID_DPER

                        )

              VALUES (
                        src.COD_SNDG_LG,
                        src.VAL_ACC_LGGB,
                        src.VAL_UTI_LGGB,
                        src.VAL_SCO_LGGB,
                        src.VAL_GAR_LGGB,
                        src.VAL_ACC_SIS_LG,
                        src.VAL_UTI_SIS_LG,
                        src.VAL_SCO_SIS_LG,
                        src.VAL_IMP_GAR_SIS_LG,
                        src.DTA_RIFERIMENTO_CR,
                        sysdate,
                        sysdate,
                        NULL,
                        src.ID_DPER );

            commit;
            END;';


            DBMS_OUTPUT.PUT_LINE(v_sql);


              execute immediate v_sql;

              RETURN TRUE;


                EXCEPTION WHEN OTHERS THEN

                  DBMS_OUTPUT.PUT_LINE(SUBSTR(SQLERRM, 1, 255));



                end FND_MCRE0_alimenta_CR_LG_GB_ap;


FUNCTION FND_MCRE0_alimenta_CR_GE_SB(p_rec IN f_slave_par_type) RETURN BOOLEAN IS

        c_nome CONSTANT VARCHAR2(100) := c_package || '.FND_MCRE0_alimenta_CR_GE_SB';
        b_flag BOOLEAN;
        v_cur PKG_MCRE0_UTILS.cur_abi_type;
        v_count NUMBER;



   BEGIN

     DBMS_OUTPUT.PUT_LINE('INIZIALIZZO CURSORE X SOTTOPARTIZIONE COD_ABI');

     open v_cur for select distinct COD_ABI
     from T_MCRE0_APP_ISTITUTI;

       DBMS_OUTPUT.PUT_LINE('CURSORE X SOTTOPARTIZIONE COD_ABI INIZIALIZZATO');

     b_flag := PKG_MCRE0_PARTIZIONI.FND_MCRE0_add_partition(p_rec.SEQ_FLUSSO,p_rec.TAB_TRG,p_rec.PERIODO,v_cur);


     IF(b_flag) THEN


                  insert
             when
             NUM_RECS = 1
             AND TRIM(TO_CHAR(ID_DPER)) IS NOT NULL
             AND TRIM(TO_CHAR(COD_ABI_CARTOLARIZZATO)) IS NOT NULL
             AND TRIM(TO_CHAR(COD_SNDG_GE)) IS NOT NULL



            then

            INTO T_MCRE0_ST_CR_GE_SB (
                ID_DPER    ,
                COD_ABI_CARTOLARIZZATO    ,
                DTA_CR_GESB    ,
                VAL_ACC_CR_GESB    ,
                VAL_GAR_CR_GESB    ,
                VAL_SCO_CR_GESB    ,
                VAL_UTI_CR_GESB    ,
                COD_SNDG_GE


            )
            VALUES (
                ID_DPER    ,
                COD_ABI_CARTOLARIZZATO    ,
                DTA_CR_GESB    ,
                VAL_ACC_CR_GESB    ,
                VAL_GAR_CR_GESB    ,
                VAL_SCO_CR_GESB    ,
                VAL_UTI_CR_GESB    ,
                COD_SNDG_GE
            )

             when
             NUM_RECS > 1
             OR TRIM(TO_CHAR(ID_DPER)) IS NULL
             OR TRIM(TO_CHAR(COD_ABI_CARTOLARIZZATO)) IS NULL
             OR TRIM(TO_CHAR(COD_SNDG_GE)) IS NULL


             then
             INTO T_MCRE0_SC_VINCOLI_CR_GE_SB (
                ID_SEQ    ,
                ID_DPER    ,
                COD_ABI_CARTOLARIZZATO    ,
                DTA_CR_GESB    ,
                VAL_ACC_CR_GESB    ,
                VAL_GAR_CR_GESB    ,
                VAL_SCO_CR_GESB    ,
                VAL_UTI_CR_GESB    ,
                COD_SNDG_GE
                )

                VALUES (
                p_rec.SEQ_FLUSSO,
                ID_DPER    ,
                COD_ABI_CARTOLARIZZATO    ,
                DTA_CR_GESB    ,
                VAL_ACC_CR_GESB    ,
                VAL_GAR_CR_GESB    ,
                VAL_SCO_CR_GESB    ,
                VAL_UTI_CR_GESB    ,
                COD_SNDG_GE
                   )


             select * from
        (
            SELECT
                COUNT(1) OVER(PARTITION BY  ID_DPER, COD_ABI_CARTOLARIZZATO, COD_SNDG_GE ) NUM_RECS,
                ID_DPER    ,
                COD_ABI_CARTOLARIZZATO    ,
                DTA_CR_GESB    ,
                VAL_ACC_CR_GESB    ,
                VAL_GAR_CR_GESB    ,
                VAL_SCO_CR_GESB    ,
                VAL_UTI_CR_GESB    ,
                COD_SNDG_GE



            FROM
              T_MCRE0_FL_CR_GE_SB
        ) tmp;
        COMMIT;

           SELECT COUNT(*)
          INTO v_count
          FROM T_MCRE0_SC_VINCOLI_CR_GE_SB   SC
          WHERE SC.ID_SEQ = p_rec.SEQ_FLUSSO;


          UPDATE T_MCRE0_WRK_ACQUISIZIONE
          SET SCARTI_VINCOLI = v_count
          WHERE ID_FLUSSO = p_rec.SEQ_FLUSSO;
          commit;



        b_flag := TRUE;


     END IF;

         IF(b_flag) THEN

        PKG_MCRE0_LOG.SPO_MCRE0_LOG_EVENTO(p_rec.SEQ_FLUSSO,c_nome,'OK','DATI INSERITI CORRETTAMENTE');

        END IF;



        RETURN b_flag;


            EXCEPTION


        WHEN OTHERS THEN

        DBMS_OUTPUT.PUT_LINE('ERRORE IN FND_MCRE0_alimenta_CR_GE_SB');
         DBMS_OUTPUT.PUT_LINE(SUBSTR(SQLERRM, 1, 255));
            ROLLBACK;

           IF(v_cur%ISOPEN) THEN

                    CLOSE v_cur;

                     DBMS_OUTPUT.PUT_LINE('ERRORE IN FND_MCRE0_alimenta_CR_GE_SB - CLOSE CURSOR');

                END IF;

            PKG_MCRE0_LOG.SPO_MCRE0_log_evento_no_commit(p_rec.SEQ_FLUSSO,p_rec.TAB_TRG,'ERRORE',SUBSTR(SQLERRM, 1, 255));

            RETURN FALSE;

     END FND_MCRE0_alimenta_CR_GE_SB;


FUNCTION FND_MCRE0_alimenta_CR_GE_SB_ap(p_rec IN f_slave_par_type) RETURN BOOLEAN IS

  v_partition varchar2(20);
  v_sql varchar2(5000);


   begin


   v_partition := 'CCP_P'|| to_char(p_rec.PERIODO, 'yyyymmdd');

          v_sql :=  'BEGIN MERGE

               INTO  T_MCRE0_APP_CR_GE_SB24 trg

               USING T_MCRE0_ST_CR_GE_SB  PARTITION(' || v_partition || ') src

               ON  (trg.COD_ABI_CARTOLARIZZATO=src.COD_ABI_CARTOLARIZZATO
               and trg.COD_SNDG_GE=src.COD_SNDG_GE)

            WHEN MATCHED

            THEN

              UPDATE

              SET

                trg.DTA_CR_GESB=src.DTA_CR_GESB,
                trg.VAL_ACC_CR_GESB=src.VAL_ACC_CR_GESB,
                trg.VAL_GAR_CR_GESB=src.VAL_GAR_CR_GESB,
                trg.VAL_SCO_CR_GESB=src.VAL_SCO_CR_GESB,
                trg.VAL_UTI_CR_GESB=src.VAL_UTI_CR_GESB,
                trg.DTA_UPD= sysdate,
                trg.COD_OPERATORE_INS_UPD = NULL,
                trg.ID_DPER = src.ID_DPER



           WHEN NOT MATCHED
           THEN
              INSERT (
                        trg.COD_ABI_CARTOLARIZZATO,
                        trg.DTA_CR_GESB,
                        trg.VAL_ACC_CR_GESB,
                        trg.VAL_GAR_CR_GESB,
                        trg.VAL_SCO_CR_GESB,
                        trg.VAL_UTI_CR_GESB,
                        trg.COD_SNDG_GE,
                        trg.DTA_INS    ,
                        trg.DTA_UPD    ,
                        trg.COD_OPERATORE_INS_UPD    ,
                        trg.ID_DPER

                        )

              VALUES (
                        src.COD_ABI_CARTOLARIZZATO,
                        src.DTA_CR_GESB,
                        src.VAL_ACC_CR_GESB,
                        src.VAL_GAR_CR_GESB,
                        src.VAL_SCO_CR_GESB,
                        src.VAL_UTI_CR_GESB,
                        src.COD_SNDG_GE,
                        sysdate,
                        sysdate,
                        NULL,
                        src.ID_DPER );

            commit;
            END;';


            DBMS_OUTPUT.PUT_LINE(v_sql);


              execute immediate v_sql;

              RETURN TRUE;


                EXCEPTION WHEN OTHERS THEN

                  DBMS_OUTPUT.PUT_LINE(SUBSTR(SQLERRM, 1, 255));



                end FND_MCRE0_alimenta_CR_GE_SB_ap;

FUNCTION FND_MCRE0_alimenta_CR_SC_SB(p_rec IN f_slave_par_type) RETURN BOOLEAN IS

        c_nome CONSTANT VARCHAR2(100) := c_package || '.FND_MCRE0_alimenta_CR_SC_SB';
        b_flag BOOLEAN;
        v_cur PKG_MCRE0_UTILS.cur_abi_type;
        v_count NUMBER;



   BEGIN

     DBMS_OUTPUT.PUT_LINE('INIZIALIZZO CURSORE X SOTTOPARTIZIONE COD_ABI');

     open v_cur for select distinct COD_ABI
     from T_MCRE0_APP_ISTITUTI;

       DBMS_OUTPUT.PUT_LINE('CURSORE X SOTTOPARTIZIONE COD_ABI INIZIALIZZATO');

     b_flag := PKG_MCRE0_PARTIZIONI.FND_MCRE0_add_partition(p_rec.SEQ_FLUSSO,p_rec.TAB_TRG,p_rec.PERIODO,v_cur);


     IF(b_flag) THEN


                  insert
             when
             NUM_RECS = 1
             AND TRIM(TO_CHAR(ID_DPER)) IS NOT NULL
             AND TRIM(TO_CHAR(COD_ABI_CARTOLARIZZATO)) IS NOT NULL
             AND TRIM(TO_CHAR(COD_NDG)) IS NOT NULL



            then

            INTO T_MCRE0_ST_CR_SC_SB (
                ID_DPER    ,
                COD_ABI_CARTOLARIZZATO    ,
                DTA_CR_SCSB    ,
                VAL_ACC_CR_SCSB    ,
                VAL_GAR_CR_SCSB    ,
                VAL_SCO_CR_SCSB    ,
                VAL_UTI_CR_SCSB    ,
                COD_NDG


            )
            VALUES (
                ID_DPER    ,
                COD_ABI_CARTOLARIZZATO    ,
                DTA_CR_SCSB    ,
                VAL_ACC_CR_SCSB    ,
                VAL_GAR_CR_SCSB    ,
                VAL_SCO_CR_SCSB    ,
                VAL_UTI_CR_SCSB    ,
                COD_NDG
            )

             when
             NUM_RECS > 1
             OR TRIM(TO_CHAR(ID_DPER)) IS NULL
             OR TRIM(TO_CHAR(COD_ABI_CARTOLARIZZATO)) IS NULL
             OR TRIM(TO_CHAR(COD_NDG)) IS NULL


             then
             INTO T_MCRE0_SC_VINCOLI_CR_SC_SB (
                ID_SEQ    ,
                ID_DPER    ,
                COD_ABI_CARTOLARIZZATO    ,
                DTA_CR_SCSB    ,
                VAL_ACC_CR_SCSB    ,
                VAL_GAR_CR_SCSB    ,
                VAL_SCO_CR_SCSB    ,
                VAL_UTI_CR_SCSB    ,
                COD_NDG
                )

                VALUES (
                p_rec.SEQ_FLUSSO,
                ID_DPER    ,
                COD_ABI_CARTOLARIZZATO    ,
                DTA_CR_SCSB    ,
                VAL_ACC_CR_SCSB    ,
                VAL_GAR_CR_SCSB    ,
                VAL_SCO_CR_SCSB    ,
                VAL_UTI_CR_SCSB    ,
                COD_NDG
                   )


             select * from
        (
            SELECT
                COUNT(1) OVER(PARTITION BY  ID_DPER, COD_ABI_CARTOLARIZZATO, COD_NDG ) NUM_RECS,
                ID_DPER    ,
                COD_ABI_CARTOLARIZZATO    ,
                DTA_CR_SCSB    ,
                VAL_ACC_CR_SCSB    ,
                VAL_GAR_CR_SCSB    ,
                VAL_SCO_CR_SCSB    ,
                VAL_UTI_CR_SCSB    ,
                COD_NDG




            FROM
              T_MCRE0_FL_CR_SC_SB
        ) tmp;
        COMMIT;

           SELECT COUNT(*)
          INTO v_count
          FROM T_MCRE0_SC_VINCOLI_CR_SC_SB   SC
          WHERE SC.ID_SEQ = p_rec.SEQ_FLUSSO;


          UPDATE T_MCRE0_WRK_ACQUISIZIONE
          SET SCARTI_VINCOLI = v_count
          WHERE ID_FLUSSO = p_rec.SEQ_FLUSSO;
          commit;



        b_flag := TRUE;


     END IF;

         IF(b_flag) THEN

        PKG_MCRE0_LOG.SPO_MCRE0_LOG_EVENTO(p_rec.SEQ_FLUSSO,c_nome,'OK','DATI INSERITI CORRETTAMENTE');

        END IF;



        RETURN b_flag;


            EXCEPTION


        WHEN OTHERS THEN

        DBMS_OUTPUT.PUT_LINE('ERRORE IN FND_MCRE0_alimenta_CR_SC_SB');
         DBMS_OUTPUT.PUT_LINE(SUBSTR(SQLERRM, 1, 255));
            ROLLBACK;

           IF(v_cur%ISOPEN) THEN

                    CLOSE v_cur;

                     DBMS_OUTPUT.PUT_LINE('ERRORE IN FND_MCRE0_alimenta_CR_SC_SB - CLOSE CURSOR');

                END IF;

            PKG_MCRE0_LOG.SPO_MCRE0_log_evento_no_commit(p_rec.SEQ_FLUSSO,p_rec.TAB_TRG,'ERRORE',SUBSTR(SQLERRM, 1, 255));

            RETURN FALSE;

     END FND_MCRE0_alimenta_CR_SC_SB;


FUNCTION FND_MCRE0_alimenta_CR_SC_SB_ap(p_rec IN f_slave_par_type) RETURN BOOLEAN IS

  v_partition varchar2(20);
  v_sql varchar2(5000);


   begin


   v_partition := 'CCP_P'|| to_char(p_rec.PERIODO, 'yyyymmdd');

          v_sql :=  'BEGIN MERGE

               INTO  T_MCRE0_APP_CR_SC_SB24 trg

               USING T_MCRE0_ST_CR_SC_SB  PARTITION(' || v_partition || ') src

               ON  (trg.COD_ABI_CARTOLARIZZATO=src.COD_ABI_CARTOLARIZZATO
               and trg.COD_NDG=src.COD_NDG)

            WHEN MATCHED

            THEN

              UPDATE

              SET

                    trg.DTA_CR_SCSB=src.DTA_CR_SCSB,
                    trg.VAL_ACC_CR_SCSB=src.VAL_ACC_CR_SCSB,
                    trg.VAL_GAR_CR_SCSB=src.VAL_GAR_CR_SCSB,
                    trg.VAL_SCO_CR_SCSB=src.VAL_SCO_CR_SCSB,
                    trg.VAL_UTI_CR_SCSB=src.VAL_UTI_CR_SCSB,
                    trg.DTA_UPD= sysdate,
                    trg.COD_OPERATORE_INS_UPD = NULL,
                    trg.ID_DPER = src.ID_DPER

           WHEN NOT MATCHED
           THEN
              INSERT (
                        trg.COD_ABI_CARTOLARIZZATO,
                        trg.DTA_CR_SCSB,
                        trg.VAL_ACC_CR_SCSB,
                        trg.VAL_GAR_CR_SCSB,
                        trg.VAL_SCO_CR_SCSB,
                        trg.VAL_UTI_CR_SCSB,
                        trg.COD_NDG,
                        trg.DTA_INS    ,
                        trg.DTA_UPD    ,
                        trg.COD_OPERATORE_INS_UPD    ,
                        trg.ID_DPER

                        )

              VALUES (
                        src.COD_ABI_CARTOLARIZZATO,
                        src.DTA_CR_SCSB,
                        src.VAL_ACC_CR_SCSB,
                        src.VAL_GAR_CR_SCSB,
                        src.VAL_SCO_CR_SCSB,
                        src.VAL_UTI_CR_SCSB,
                        src.COD_NDG,
                        sysdate,
                        sysdate,
                        NULL,
                        src.ID_DPER );

            commit;
            END;';


            DBMS_OUTPUT.PUT_LINE(v_sql);


              execute immediate v_sql;

              RETURN TRUE;


                EXCEPTION WHEN OTHERS THEN

                  DBMS_OUTPUT.PUT_LINE(SUBSTR(SQLERRM, 1, 255));



                end FND_MCRE0_alimenta_CR_SC_SB_ap;


    FUNCTION FND_MCRE0_ALIMENTA_ANADIP (p_rec IN f_slave_par_type) RETURN BOOLEAN IS

            c_nome CONSTANT VARCHAR2(100) := c_package || '.FND_MCRE0_ALIMENTA_ANADIP';
            b_flag BOOLEAN;
            v_cur PKG_MCRE0_UTILS.cur_abi_type;
            v_count NUMBER;

        BEGIN

            DBMS_OUTPUT.PUT_LINE('INIZIALIZZO CURSORE X SOTTOPARTIZIONE COD_ABI');
             open v_cur for select distinct COD_ABI
             from T_MCRE0_APP_ISTITUTI;

             DBMS_OUTPUT.PUT_LINE('CURSORE X SOTTOPARTIZIONE COD_ABI INIZIALIZZATO');
             b_flag := PKG_MCRE0_PARTIZIONI.FND_MCRE0_add_partition(p_rec.SEQ_FLUSSO,p_rec.TAB_TRG,p_rec.PERIODO,v_cur);

            IF(b_flag) THEN
                INSERT
                    WHEN    NUM_RECS = 1
                    AND     TRIM(TO_CHAR(ID_DPER)) IS not NULL
                    AND     TRIM(TO_CHAR(COD_STRUTTURA_COMPETENTE)) IS not NULL
                THEN INTO T_MCRE0_ST_ANADIP
                        (
                             ID_DPER
                            ,COD_ABI_ISTITUTO
                            ,COD_STRUTTURA_COMPETENTE
                            ,DESC_STRUTTURA_COMPETENTE
                            ,COD_FASC
                            ,COD_STR_ORG_SUP
                            ,COD_LIVELLO
                            ,COD_DIV
                            ,FREE_AREA
                            ,COD_UTRUM
                            ,DAT_UPD
                            ,LIVELLO
                         )
                         VALUES
                         (
                             ID_DPER
                            ,COD_ABI_ISTITUTO
                            ,COD_STRUTTURA_COMPETENTE
                            ,DESC_STRUTTURA_COMPETENTE
                            ,COD_FASC
                            ,COD_STR_ORG_SUP
                            ,COD_LIVELLO
                            ,COD_DIV
                            ,FREE_AREA
                            ,COD_UTRUM
                            ,DAT_UPD
                            ,LIVELLO
                         )
                    WHEN    NUM_RECS > 1
                    OR      TRIM(TO_CHAR(ID_DPER)) IS NULL
                    OR      TRIM(TO_CHAR(COD_STRUTTURA_COMPETENTE)) IS NULL
                THEN INTO T_MCRE0_SC_VINCOLI_ANADIP
                        (
                             ID_SEQ
                            ,ID_DPER
                            ,COD_ABI_ISTITUTO
                            ,COD_STRUTTURA_COMPETENTE
                            ,DESC_STRUTTURA_COMPETENTE
                            ,COD_FASC
                            ,COD_STR_ORG_SUP
                            ,COD_LIVELLO
                            ,COD_DIV
                            ,FREE_AREA
                            ,COD_UTRUM
                            ,DAT_UPD
                            ,LIVELLO
                        )
                        VALUES
                        (
                             p_rec.SEQ_FLUSSO
                            ,ID_DPER
                            ,COD_ABI_ISTITUTO
                            ,COD_STRUTTURA_COMPETENTE
                            ,DESC_STRUTTURA_COMPETENTE
                            ,COD_FASC
                            ,COD_STR_ORG_SUP
                            ,COD_LIVELLO
                            ,COD_DIV
                            ,FREE_AREA
                            ,COD_UTRUM
                            ,DAT_UPD
                            ,LIVELLO
                        )
                SELECT * FROM
                    (
                        SELECT
                            COUNT(1) OVER(PARTITION BY ID_DPER, COD_ABI_ISTITUTO, COD_STRUTTURA_COMPETENTE) NUM_RECS
                            ,ID_DPER
                            ,COD_ABI_ISTITUTO
                            ,COD_STRUTTURA_COMPETENTE
                            ,DESC_STRUTTURA_COMPETENTE
                            ,COD_FASC
                            ,COD_STR_ORG_SUP
                            ,COD_LIVELLO
                            ,COD_DIV
                            ,FREE_AREA
                            ,COD_UTRUM
                            ,DAT_UPD
                            ,LIVELLO
                        FROM T_MCRE0_FL_ANADIP
                    ) tmp;
                COMMIT;

                SELECT COUNT(*) INTO v_count
                FROM T_MCRE0_SC_VINCOLI_ANADIP   SC
                WHERE SC.ID_SEQ = p_rec.SEQ_FLUSSO;

                UPDATE T_MCRE0_WRK_ACQUISIZIONE
                SET SCARTI_VINCOLI = v_count
                WHERE ID_FLUSSO = p_rec.SEQ_FLUSSO;
                commit;

                b_flag := TRUE;

            END IF;

                IF(b_flag) THEN
                    PKG_MCRE0_LOG.SPO_MCRE0_LOG_EVENTO(p_rec.SEQ_FLUSSO,c_nome,'OK','DATI INSERITI CORRETTAMENTE');
                END IF;



                RETURN b_flag;

        EXCEPTION WHEN OTHERS THEN
            DBMS_OUTPUT.PUT_LINE('ERRORE IN FND_MCRE0_ALIMENTA_ANADIP');
            DBMS_OUTPUT.PUT_LINE(SUBSTR(SQLERRM, 1, 255));
            ROLLBACK;

            IF(v_cur%ISOPEN) THEN
                CLOSE v_cur;
                DBMS_OUTPUT.PUT_LINE('ERRORE IN FND_MCRE0_ALIMENTA_ANADIP - CLOSE CURSOR');
            END IF;

            PKG_MCRE0_LOG.SPO_MCRE0_log_evento_no_commit(p_rec.SEQ_FLUSSO,p_rec.TAB_TRG,'ERRORE',SUBSTR(SQLERRM, 1, 255));
            RETURN FALSE;
        END FND_MCRE0_ALIMENTA_ANADIP;


        FUNCTION FND_MCRE0_ALIMENTA_ANADIP_AP (p_rec IN f_slave_par_type) RETURN BOOLEAN IS

            v_partition varchar2(20);
            v_sql varchar2(5000);

            BEGIN
                v_partition := 'CCP_P'|| to_char(p_rec.PERIODO, 'yyyymmdd');

                v_sql :=  'BEGIN
                                MERGE INTO T_MCRE0_APP_ANADIP trg
                                USING T_MCRE0_ST_ANADIP  PARTITION(' || v_partition || ') src
                                ON  (trg.COD_ABI_ISTITUTO=src.COD_ABI_ISTITUTO
                                and  trg.COD_STRUTTURA_COMPETENTE=src.COD_STRUTTURA_COMPETENTE)
                            WHEN MATCHED THEN
                                UPDATE SET
                                    trg.ID_DPER                     = src.ID_DPER,
                                    trg.DESC_STRUTTURA_COMPETENTE   = src.desc_struttura_competente,
                                    trg.COD_FASC                    = src.cod_fasc,
                                    trg.COD_STR_ORG_SUP             = src.COD_STR_ORG_SUP,
                                    trg.COD_LIVELLO                 = src.cod_livello,
                                    trg.COD_DIV                     = src.cod_div,
                                    trg.FREE_AREA                   = src.free_area,
                                    trg.COD_UTRUM                   = src.cod_utrum,
                                    trg.DAT_UPD                     = src.dat_upd,
                                    trg.LIVELLO                     = src.livello
                            WHEN NOT MATCHED
                            THEN
                              INSERT (
                                         trg.ID_DPER
                                        ,trg.COD_ABI_ISTITUTO
                                        ,trg.COD_STRUTTURA_COMPETENTE
                                        ,trg.DESC_STRUTTURA_COMPETENTE
                                        ,trg.COD_FASC
                                        ,trg.COD_STR_ORG_SUP
                                        ,trg.COD_LIVELLO
                                        ,trg.COD_DIV
                                        ,trg.FREE_AREA
                                        ,trg.COD_UTRUM
                                        ,trg.DAT_UPD
                                        ,trg.LIVELLO
                                        )
                              VALUES (
                                        src.ID_DPER,
                                        src.COD_ABI_ISTITUTO,
                                        src.COD_STRUTTURA_COMPETENTE,
                                        src.desc_struttura_competente,
                                        src.cod_fasc,
                                        src.COD_STR_ORG_SUP,
                                        src.cod_livello,
                                        src.cod_div,
                                        src.free_area,
                                        src.cod_utrum,
                                        src.dat_upd,
                                        src.livello
                    );
                        commit;
                        END;';
                DBMS_OUTPUT.PUT_LINE(v_sql);
                execute immediate v_sql;

                RETURN TRUE;

            EXCEPTION WHEN OTHERS THEN

                DBMS_OUTPUT.PUT_LINE(SUBSTR(SQLERRM, 1, 255));

            END FND_MCRE0_ALIMENTA_ANADIP_AP;


END PKG_MCRE0_ALIMENTAZIONE;
/


CREATE SYNONYM MCRE_APP.PKG_MCRE0_ALIMENTAZIONE FOR MCRE_OWN.PKG_MCRE0_ALIMENTAZIONE;


CREATE SYNONYM MCRE_USR.PKG_MCRE0_ALIMENTAZIONE FOR MCRE_OWN.PKG_MCRE0_ALIMENTAZIONE;


GRANT EXECUTE, DEBUG ON MCRE_OWN.PKG_MCRE0_ALIMENTAZIONE TO MCRE_USR;

