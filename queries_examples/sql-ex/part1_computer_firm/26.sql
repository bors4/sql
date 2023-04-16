/* Find out the average price of PCs and laptops produced by maker A.
Result set: one overall average price for all items.
*/


SELECT( (SELECT SUM(price)
    FROM Product INNER JOIN
         PC ON Product.model = PC.model
   WHERE maker='A'
 ) + (SELECT SUM(price)
        FROM Product INNER JOIN
             Laptop ON Product.model = Laptop.model
       WHERE maker='A'
     )) /( (SELECT COUNT(price)
              FROM Product INNER JOIN
                   PC ON Product.model = PC.model
             WHERE maker='A'
           ) + (SELECT COUNT(price)
                  FROM Product INNER JOIN
                       Laptop ON Product.model = Laptop.model
                 WHERE maker='A'
               )) AS AVG_price ;