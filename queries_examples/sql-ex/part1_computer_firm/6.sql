 /* For each maker producing laptops with a hard drive capacity of 10 Gb or higher , find the speed of such laptops. Result set: maker , speed. */
select distinct prod.maker
     , lap.speed
  from product prod inner join
       laptop lap on prod.model = lap.model
 where prod.type = 'Laptop'
   and lap.hd >= 10