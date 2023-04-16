/* Find the printer makers also producing PCs with the lowest RAM capacity and the highest processor speed of all PCs having the lowest RAM capacity.
Result set: maker.
*/


select maker
  from product
 where model in  (select distinct(model)
                    from PC
                   where ram = (select min(ram)
                                  from PC
                               )
                     and speed in  (select speed
                                      from PC
                                     where ram in  (select min(ram)
                                                      from PC
                                                   )
                                   )
                   group by speed, model, ram
                  having speed = max(speed)
                 )
   and maker in  (select maker
                    from product
                   where type = 'PC'
                     and maker in  (select maker
                                      from product
                                     where type = 'Printer'
                                   )
                 )