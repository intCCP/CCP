/* Formatted on 21/07/2014 18:41:44 (QP5 v5.227.12220.39754) */
CREATE OR REPLACE FORCE VIEW MCRE_OWN.V_MCRES_APP_COMUNIC_DELIBERE
(
   VAL_ANNOMESE,
   COD_TIPO_GESTIONE,
   COD_PRESIDIO,
   DESC_PRESIDIO,
   VAL_VERDE,
   VAL_ARANCIO,
   VAL_ROSSO
)
AS
     SELECT -- 20120912     AG      Semaforo legato a V_MCRES_APP_DEL_ENTE_CENTRALE
                                         -- 20140703 VG tolto outer join su so
            u.val_annomese,
            CASE
               WHEN so.cod_livello IN ('PL', 'RC') THEN 'I'
               WHEN so.cod_livello IN ('IP', 'IC') THEN 'E'
            END
               cod_tipo_gestione,
            p.cod_uo_pratica cod_presidio,
            so.desc_struttura_competente desc_presidio,
            SUM (
               CASE WHEN TRUNC (SYSDATE) - TRUNC (dta_inoltro) <= 7 THEN 1 ELSE 0 END)
               val_verde,
            SUM (
               CASE
                  WHEN TRUNC (SYSDATE) - TRUNC (dta_inoltro) BETWEEN 8 AND 30 THEN 1
                  ELSE 0
               END)
               val_arancio,
            SUM (
               CASE WHEN TRUNC (SYSDATE) - TRUNC (dta_inoltro) > 30 THEN 1 ELSE 0 END)
               val_rosso
       FROM t_mcres_app_pratiche p,
            t_mcres_app_delibere s,
            t_mcre0_app_struttura_org so,
            v_mcres_ultima_acquisizione u  -- prodotto cartesiano con una riga
      WHERE     0 = 0
            AND p.flg_attiva = 1
            AND p.cod_matr_pratica IS NOT NULL
            AND p.cod_abi = s.cod_abi
            AND p.cod_ndg = s.cod_ndg
            AND p.cod_pratica = s.cod_pratica
            AND p.val_anno = s.val_anno_pratica
            AND p.cod_abi = so.cod_abi_istituto
            AND p.cod_uo_pratica = so.cod_struttura_competente
            AND u.cod_flusso = 'SISBA_CP'
            ---specifico dell'alert
            AND s.cod_stato_delibera = 'IT'
            AND EXISTS
                   (SELECT 1
                      FROM t_mcres_app_delibere s2
                     WHERE     0 = 0
                           AND s.cod_abi = s2.cod_abi
                           AND s.cod_ndg = s2.cod_ndg
                           AND s.cod_protocollo_delibera =
                                  s2.cod_protocollo_delibera_coll
                           AND s2.cod_stato_delibera = 'TR')
   GROUP BY val_annomese,
            CASE
               WHEN so.cod_livello IN ('PL', 'RC') THEN 'I'
               WHEN so.cod_livello IN ('IP', 'IC') THEN 'E'
            END,
            p.cod_uo_pratica,
            so.desc_struttura_competente;
