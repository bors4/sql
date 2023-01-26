 /* Find the makers of PCs with a processor speed of 450 MHz or more. Result set: maker. */
select distinct maker
  from product as pr inner join
       pc on pr.type = 'PC'
   and pc.speed >= 450
   and pr.model = pc.model