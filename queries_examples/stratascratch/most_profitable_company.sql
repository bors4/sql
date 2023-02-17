/*MySQL
Most Profitable Companies

Forbes
Medium
General Practice

Find the 3 most profitable companies in the entire world.
Output the result along with the corresponding company name.
Sort the result based on profits in descending order.
*/

with res(company,profits) as (select company
       , profits
    from forbes_global_2010_2014
   order by profits desc
 )
select *
  from res
 where profits > 0 limit 3