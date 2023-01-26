 /* Find the printer models having the highest price. Result set: model , price. */
select model
     , price
  from printer
 where price in  (select max(price)
                    from printer
                 )