 /* Find out the average speed of the PCs produced by maker A. */
select avg(speed)
  from product as pr inner join
       PC on pr.maker = 'A'
   and pr.model = pc.model