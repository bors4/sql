select grp.name
     , grp.mest
     , grp.gor
  from V_ZAL_PLAST_WMW_DPS dps right join
       V_DP_GRP_LIT grp on grp.gor=dps.plast
   and grp.mest=dps.mest
 where(dps.obj_class=6 or obj_class is NULL)
   and(dps.name is NULL
           and grp.name is not null)
 group by grp.name, grp.mest, grp.gor
 order by grp.name, grp.mest, grp.gor