 /* Find out the average speed of the laptops priced over $1000. */
select avg(speed)
  from laptop
 where price > 1000