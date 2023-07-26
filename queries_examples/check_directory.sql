with mest_object as (select objname
       , objcode
       , mest
       , objfullname
    from dp_sprobjcode
   where upper(objfullname) like upper(trim('<objectname>'))
 )
select sprpl.plast as plast_sprl
     , sprpl.gor as gor_sprl
     , sprpl.comment_ as comment_sprpl
     , sortplast.plast as plast_sortplast
     , sortplast.comment_ as comment_sortplast
     , sortplast.hor as hor_sortplast
     , obj.plast as plast_obj
     , obr.strat_id as stratid_sprobr
     , obr.pl_1 as pl1_obr
     , class.cd_1 as cd1_class
     , class.ne_1 as ne1_class
     , case when sprpl.comment_ = sortplast.comment_ then null
                                                     else 'no'
       end as comment_is_equal
     , case when sprpl.plast = sortplast.plast and sprpl.plast = obr.strat_id then null
                                                                              else 'no'
       end as code_plast_is_equal
     , case when obr.pl_1 = class.cd_1 or(obr.pl_1 is null
                                              and class.cd_1 is null) then null
                                                                      else 'no'
       end as ois_code_is_equal
     , case when ROW_NUMBER() OVER(PARTITION BY sprpl.comment_
                                     ORDER BY sprpl.comment_) > 1 then 'no'
                                                                  else null
       END AS not_duplicate
     , case when exists (SELECT plast
                           FROM dp_adr
                          WHERE plast = sprpl.plast
                            and substr(nwell_id,1,2) in  (select mest
                                                            from mest_object
                                                         )
                        ) then null
                          else 'no'
       END AS data_in_adr
     , case when exists (SELECT plast
                           FROM dp_fnd
                          WHERE plast = sprpl.plast
                            and substr(nwell_id,1,2) in  (select mest
                                                            from mest_object
                                                         )
                            and datecr >= trunc(SYSDATE - interval '1' year,'YEAR')
                        ) then null
                          else 'no'
       END AS data_in_fnd
  from dp_sprpl sprpl full join
       dp_sortplast sortplast on sprpl.plast = sortplast.plast full join
       dp_sprobj obj on sprpl.plast = obj.plast left join
       dp_sprobr obr on sortplast.plast = obr.strat_id
   and obr.mest in  (select mest
                       from mest_object
                    ) full join
       class on obr.pl_1 = class.cd_1
 where sprpl.mest = (select mest
                       from mest_object
                    ) union all
select null as plast_sprpl
     , null as gor_sprpl
     , '-' as comment_sprpl
     , null as plast_sortplast
     , null as comment_sortplast
     , null as hor_sortplast
     , obj.plast as plast_obj
     , null as stratid_sprobr
     , null as pl1_obr
     , null as cd1_class
     , null as ne1_class
     , '-' as comment_is_equal
     , '-' as code_plast_is_equal
     , '-' as ois_code_is_equal
     , '-' as not_duplicate
     , '-' as data_in_adr
     , '-' as data_in_fnd
  from dp_sprobj obj left join
       dp_sprpl sprpl on obj.plast = sprpl.plast
   and sprpl.mest in  (select mest
                         from mest_object
                      )
 where sprpl.plast is null
   and obj.objname = (select objname
                        from mest_object
                     )
 order by comment_sprpl, plast_sprl, plast_obj, comment_is_equal, code_plast_is_equal, not_duplicate, data_in_fnd, data_in_adr desc