/* Get the laptop models that have a speed smaller than the speed of any PC.
Result set: type, model, speed.*/


select p.type
     , p.model
     , l.speed
  from product as p , (select model
                            , speed
                         from laptop
                      ) as l
 where speed < any (select min(speed)
                      from pc
                   )
   and l.model = p.model