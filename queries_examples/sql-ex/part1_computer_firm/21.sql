/* Find out the maximum PC price for each maker having models in the PC table. 
Result set: maker, maximum price
*/


with maxprice(model,max_price) as (select model
       , max(price) as max_price
    from pc as pc
   group by model
 )
select pr.maker
     , max(mp.max_price)
  from maxprice as mp join
       product as pr on mp.model = pr.model
 group by pr.maker