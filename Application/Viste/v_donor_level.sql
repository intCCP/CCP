/* Formatted on 21/07/2014 18:31:26 (QP5 v5.227.12220.39754) */
CREATE OR REPLACE FORCE VIEW MCRE_OWN.V_DONOR_LEVEL
(
   DONOR_ID,
   PLEDGE_ID,
   DONOR_NAME,
   AMOUNT_PLEDGED
)
AS
   SELECT D.DONOR_ID,
          DD.PLEDGE_ID,
          D.DONOR_NAME,
          DD.AMOUNT_PLEDGED
     FROM DONOR D, DONATION DD
    WHERE D.DONOR_ID = DD.DONOR_ID AND DD.AMOUNT_PLEDGED > 0.2
   WITH CHECK OPTION CONSTRAINT CHK_DONOR_LEVEL;