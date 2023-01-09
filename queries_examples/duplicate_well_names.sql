select OBJFULLNAME
     , NWELL
     , COUNT(*)
  from (select WL.NWELL_ID
             , WL.NWELL
             , O.OBJFULLNAME
          from (select W.NWELL_ID
                     , W.OBJCODE
                     , WN.NWELL
                  from WELLLIST W INNER JOIN
                       WELLNAME WN ON W.NWELL_ID = WN.NWELL_ID
               ) WL inner join
               DP_SPROBJCODE O On WL.OBJCODE = O.OBJCODE
         order by O.OBJFULLNAME, WL.NWELL
       )
 GROUP BY OBJFULLNAME, NWELL
HAVING COUNT(*) > 1