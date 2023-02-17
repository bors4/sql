/* Find the makers producing at least three distinct models of PCs.
Result set: maker, number of PC models.
*/


with pcmaker(maker,model) as (select maker
       , model
    from product
   where type = 'PC'
 )
select maker
     , count(model) as count_model
  from pcmaker
 group by maker
having count(model) >= 3