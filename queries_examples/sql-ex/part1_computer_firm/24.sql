/* List the models of any type having the highest price of all products present in the database.
*/


with allmodels(model,price) as (select model
       , price
    from PC union
select model
       , price
    from laptop union
select model
       , price
    from printer
 )
select model
  from allmodels
 where price = (select max(price)
                  from allmodels
               ) 