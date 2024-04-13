with res_table as (
  select 
    ds.tpp_name, 
    ds.objfullname, 
    wn.nwell, 
    f.nwell_id, 
    sp.comment_, 
    to_char(f.datecr, 'dd.mm.yyyy') as f_date, 
    sf.name, 
    wl.objcode, 
    f.plast, 
    f.fond 
  from 
    dp_fnd f 
    left join welllist wl on f.nwell_id = wl.nwell_id 
    left join dp_sprobjcode ds on wl.objcode = ds.objcode 
    left join wellname wn on wn.nwell_id = wl.nwell_id 
    left join dp_sortplast sp on f.plast = sp.plast 
    left join dp_sprfnd sf on sf.fond = f.fond 
  where 
    datecr = to_date('01.01.2023', 'dd.mm.yyyy') 
  order by 
    ds.tpp_name, 
    ds.objfullname, 
    wn.nwell, 
    f.nwell_id, 
    sp.comment_, 
    f_date, 
    sf.name
) 
select 
  res1.*, 
  res2.*, 
  case when res1.fond = res2.fond then 'true' 
  else 'false' end as compare 
from 
  res_table res1 full 
  join res_table_pgs_temp res2 on res1.tpp_name = res2.tpp_name 
  and res1.objcode = res2.objcode 
  and res1.nwell_id = res2.nwell_id 
  and res1.plast = res2.plast