/* Get the makers producing both PCs having a speed of 750 MHz or higher and laptops with a speed of 750 MHz or higher.
Result set: maker
*/



with listofmodels(model) as (select model
    from pc
   where speed >= 750 union
select model
    from laptop
   where speed >= 750
 )
select maker
  from product
 where type in ('PC','Laptop')
   and model in  (select distinct(model)
                    from product intersect
select distinct(model)
                    from listofmodels
                 )
 group by maker
 order by maker