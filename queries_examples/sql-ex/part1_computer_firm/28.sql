/* Using Product table, find out the number of makers who produce only one model.
*/



with m as (select maker
       , count(model) as qty
    from product
   group by maker
  having count(model) = 1
 )
select count(*)
  from product
 where maker in  (select maker
                    from m
                 )