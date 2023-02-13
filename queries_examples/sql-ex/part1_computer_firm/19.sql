/* For each maker having models in the Laptop table, find out the average screen size of the laptops he produces.
Result set: maker, average screen size.
*/


with averageScreen(maker,screen,model) as (select p.maker as maker
       , l.screen as screen
       , l.model as model
    from product p join
         laptop as l on l.model = p.model
     and l.screen > 0
 )
select maker
     , avg(screen) as avg_screen
  from averageScreen
 group by maker