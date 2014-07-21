/* Formatted on 21/07/2014 18:40:44 (QP5 v5.227.12220.39754) */
CREATE OR REPLACE FORCE VIEW MCRE_OWN.V_MCREI_APP_RAPPORTI_COLLEGATI
(
   COD_SNDG,
   COD_SNDG_LEGAME,
   DESC_NOME_SNDG_LEGAME,
   COD_ABI,
   COD_NDG,
   COD_UO_RAPPORTO,
   COD_RAPPORTO,
   COD_FORMA_TECNICA,
   DESC_FTECNICA,
   COD_NATURA,
   DESC_NATURA,
   COD_TIPO_RAPPORTO,
   VAL_ACCORDATO_DELIB,
   VAL_IMP_UTILIZZATO,
   COD_RAPPORTO_ATTR,
   COD_TIPO_FIDO,
   COD_CLASSE_FT,
   COD_TIPO_LEGAME,
   VAL_INTERESSI_MORA,
   VAL_UTI_QC
)
AS
   SELECT leg.cod_sndg,
          leg.cod_sndg_legame,
          b.desc_nome_controparte desc_nome_sndg_legame,
          PCR.COD_ABI,
          PCR.COD_NDG,
          PCR.COD_ABI_FIL_OP AS cod_uo_rapporto, --filiale, come con Mople.(prime 5 cifre cod_rapp)
          PCR.COD_RAPPORTO,
          PCR.COD_FORMA_TECNICA,
          NAT.DESC_FTECNICA,
          NAT.COD_NATURA,
          NAT.DESC_NATURA,
          NAT.COD_TIPO_RAPPORTO,
          PCR.VAL_ACCORDATO_DELIB,
          PCR.VAL_IMP_UTILIZZATO,
          PCR.COD_RAPPORTO_ATTR,
          PCR.COD_TIPO_FIDO,
          PCR.COD_CLASSE_FT,
          'TIT' AS cod_tipo_legame,
          TO_NUMBER (RATE.VAL_IMP_MORA) AS val_interessi_MORA,
          PCR.VAL_IMP_UTILIZZATO - NVL (RATE.VAL_IMP_MORA, 0) AS val_uti_qc
     FROM ( (SELECT a.cod_sndg, a.cod_sndg_legame
               FROM t_mcre0_app_legame a
              WHERE cod_legame = 'TIT')
           UNION ALL
           (SELECT c.cod_sndg_legame, c.cod_sndg
              FROM t_mcre0_app_legame c
             WHERE cod_legame = 'TIT')) leg,
          t_mcre0_app_anagrafica_gruppo b,
          t_mcrei_app_pcr_rapporti pcr,
          T_MCRE0_APP_NATURA_FTECNICA NAT,
          T_MCRE0_APP_RATE_DAILY RATE
    WHERE     leg.cod_sndg_legame = pcr.cod_sndg(+)
          AND leg.cod_sndg_legame = b.cod_sndg
          AND PCR.COD_FORMA_TECNICA = NAT.COD_FTECNICA
          AND PCR.COD_ABI = RATE.COD_ABI_CARTOLARIZZATO(+)
          AND PCR.COD_NDG = RATE.COD_NDG(+)
          AND PCR.COD_RAPPORTO = RATE.COD_RAPPORTO(+)
          AND PCR.COD_CLASSE_FT IN ('CA', 'FI', 'ST');
