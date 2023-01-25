 /* Find the model number , speed and hard drive capacity of PCs cheaper than $600 having a 12x or a 24x CD drive. */
select model
     , speed
     , hd
  from pc
 where cd in ('12x','24x')
   and price < 600