 /* Get the models and prices for all commercially available products ( of any type ) produced by maker B. */
select pr.model
     , pc.price
  from Product as pr inner join
       PC as pc on pr.model = pc.model
   and pr.maker = 'B' union
select pr.model
     , lap.price
  from Product as pr inner join
       Laptop as lap on pr.model = lap.model
   and pr.maker = 'B' union
select pr.model
     , printer.price
  from Product as pr inner join
       Printer as printer on pr.model = printer.model
   and pr.maker = 'B'