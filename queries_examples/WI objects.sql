/* object stratums WI */
 select DISTINCT(GOR)
     , STRAT_ID
  from WELL_SLOI@"UWIDBWEB"
 where STRAT_ID in  (select DISTINCT(strat_id)
                       from WELL_SLOI_HDR@"UWIDBWEB"
                      where well_hdr_id in  (select DISTINCT(ID)
                                               from WELL_HDR@"UWIDBWEB" wl
                                              where UWI like '340_______'
                                            )
                    )
 ORDER by GOR 
 
 /* wells of stratum WI*/
select NOM_SKV
     , KOOR_X
     , KOOR_Y
     , UWI
  from WELL_HDR@"UWIDBWEB" wl
 where ID in  (select WELL_HDR_ID
                 from WELL_SLOI_HDR@"UWIDBWEB"
                where well_hdr_id in  (select DISTINCT(ID)
                                         from WELL_HDR@"UWIDBWEB" wl
                                        where UWI like '340_______'
                                      )
                  and STRAT_ID in (15419,16055,14465,13827)
              )