select obj.objfullname
     , wn.nwell
     , wl.objcode
  from welllist wl left join
       wellname wn on wn.nwell_id = wl.nwell_id
   and wn.nwell_id in  (select distinct(nwell_id)
                          from profile_info
                       ) left join
       dp_sprobjcode obj on obj.objcode = wl.objcode
 group by obj.objfullname, wl.objcode, wn.nwell