/* Find out the average hard disk drive capacity of PCs produced by makers who also manufacture printers.
Result set: maker, average HDD capacity.
*/


with maker2(maker,model) as (select maker
       , model
    from product
   where maker in  (select maker
                      from product
                     where type = 'Printer'
                   )
     and type = 'PC'
 )
select m.maker
     , avg(pc.hd) as avg_price
  from maker2 as m join
       PC as pc on m.model = pc.model
 group by maker