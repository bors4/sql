/* Find the makers of the cheapest color printers.
Result set: maker, price.*/


with res(maker,price) as (select p.maker
       , pr.price
    from product as p join
         printer as pr on pr.model = p.model
     and pr.color = 'y'
     and p.type = 'Printer'
 )
select r.maker
     , r.price
  from res as r
 where r.price = (select min(price)
                    from res as rr
                 )