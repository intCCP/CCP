/* Formatted on 17/06/2014 18:09:13 (QP5 v5.227.12220.39754) */
CREATE OR REPLACE FORCE VIEW MCRE_OWN.V_MCRES_APP_ALERT
(
   COD_ABI,
   ID_ALERT,
   DESC_ALERT,
   ID_FUNZIONE,
   COD_PRIVILEGIO,
   COD_UO_PRATICA,
   COD_MATR_PRATICA,
   COD_MATRICOLA,
   VAL_ROSSO,
   VAL_ARANCIO,
   VAL_VERDE,
   VAL_TOTALE,
   VAL_ANNOMESE,
   FLG_ORDINE,
   DTA_INS,
   DESC_PRESIDIO,
   VAL_TOT_SPESE,
   VAL_CONDIZIONE_ALERT
)
AS
   SELECT                   ---20131106 VG aggiunto campo val_condizione_alert
          ---20140507 AP aggiunto campo cod matricola per alert 15 spese in corso di lavorazione (POTENZA)
          "COD_ABI",
          b."ID_ALERT",
          "DESC_ALERT",
          "ID_FUNZIONE",
          "COD_PRIVILEGIO",
          "COD_UO_PRATICA",
          "COD_MATR_PRATICA",
          "COD_MATRICOLA",
          "VAL_ROSSO",
          "VAL_ARANCIO",
          "VAL_VERDE",
          VAL_ROSSO + VAL_ARANCIO + VAL_VERDE VAL_TOTALE,
          f.val_annomese_sisba_cp VAL_ANNOMESE,
          "FLG_ORDINE",
          "DTA_INS",
          -- AP 12/10/2012
          DESC_STRUTTURA_COMPETENTE DESC_PRESIDIO,
          val_tot_spese,
          (SELECT    'verde <= '
                  || VAL_CURRENT_GREEN
                  || ', giallo > '
                  || (VAL_CURRENT_GREEN)
                  || ' < '
                  || (VAL_CURRENT_ORANGE + 1)
                  || ', rosso >= '
                  || (VAL_CURRENT_ORANGE + 1)
             FROM T_MCRES_APP_GESTIONE_ALERT al
            WHERE al.id_alert = b.id_alert)
             val_condizione_alert
     FROM (  SELECT COD_ABI,
                    ID_ALERT,
                    COD_UO_PRATICA,
                    COD_MATR_PRATICA,
                    SUM (VAL_ROSSO) VAL_ROSSO,
                    SUM (VAL_ARANCIO) VAL_ARANCIO,
                    SUM (VAL_VERDE) VAL_VERDE,
                    MAX (DTA_INS) DTA_INS,
                    SUM (val_importo) val_tot_spese,
                    COD_MATRICOLA
               FROM t_mcres_fen_alert_pos
           GROUP BY COD_ABI,
                    ID_ALERT,
                    COD_UO_PRATICA,
                    COD_MATR_PRATICA,
                    COD_MATRICOLA) B,
          T_MCRES_APP_ALERT_RUOLI R,
          V_MCRES_APP_ULTIMO_ANNOMESE F,
          --AP 12/10/2012
          t_mcre0_app_struttura_org org
    WHERE     b.ID_ALERT = R.ID_ALERT
          AND R.COD_PRIVILEGIO = 'A'
          AND r.FLG_ATTIVO = 'A'
          -- AP 12/10/2012
          AND org.cod_abi_istituto(+) = b.cod_abi
          AND org.cod_struttura_competente(+) = b.cod_uo_pratica;


GRANT DELETE, INSERT, REFERENCES, SELECT, UPDATE, ON COMMIT REFRESH, QUERY REWRITE, DEBUG, FLASHBACK, MERGE VIEW ON MCRE_OWN.V_MCRES_APP_ALERT TO MCRE_USR;
