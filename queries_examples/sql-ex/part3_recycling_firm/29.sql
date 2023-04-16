/*
Under the assumption that receipts of money (inc) and payouts (out) are registered not more than once a day for each collection point [i.e. the primary key consists of (point, date)], write a query displaying cash flow data (point, date, income, expense).
Use Income_o and Outcome_o tables.
*/
with res as (select t_out_o.point
       , t_out_o.date
       , t_inc_o.inc
       , t_out_o.out
    from income_o as t_inc_o right join
         outcome_o as t_out_o on t_out_o.date=t_inc_o.date
     and t_inc_o.point = t_out_o.point union
select t_inc_o.point
       , t_inc_o.date
       , t_inc_o.inc
       , t_out_o.out
    from income_o as t_inc_o left join
         outcome_o as t_out_o on t_inc_o.date = t_out_o.date
     and t_inc_o.point = t_out_o.point
 )
select point
     , date
     , inc
     , out
  from res
 order by date