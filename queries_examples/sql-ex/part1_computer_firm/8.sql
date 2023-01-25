 /* Find the makers producing PCs but not laptops. */
select maker
  from product as pr
 where type in ('PC') except
select maker
  from product as pr
 where type in ('Laptop')