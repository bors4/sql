 /* Get pairs of PC models with identical speeds and the same RAM capacity. Each resulting pair should be displayed only once, i.e. (i, j) but not (j, i).
Result set: model with the bigger number, model with the smaller number, speed, and RAM. */
select max(model) as 'model'
     , min(model) as 'model'
     , speed
     , ram
  from PC
 group by speed, ram
having max(model) > min(model)
 order by max(model) ,
min(model) asc