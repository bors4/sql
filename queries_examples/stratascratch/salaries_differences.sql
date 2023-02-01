/*PostgreSQL
Query that calculates the difference between the highest salaries found 
in the marketing and engineering departments
*/

with engineeringId(id) as (
select 
    id, department 
from db_dept
where department in ('marketing', 'engineering')
order by id
)

select 
     COALESCE(salary_difference, 0) as salary_difference 
from(
    select 
          sal - lag(sal) over(order by sal) as salary_difference 
     from (
          select 
            max(salary) as sal
          from engineeringId as dept
          join db_employee as employee
          on dept.id = employee.department_id
          group by department) as maxSalaries) 
as res 
where salary_difference <> 0