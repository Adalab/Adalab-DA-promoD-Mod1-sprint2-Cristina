/*Ejercicios de SQL
Para esta evaluación usaremos la BBDD de northwind.

1. Selecciona todos los campos de los productos, que pertenezcan a los proveedores con códigos: 1, 3, 7, 8 y 9, que tengan stock en el almacén,
y al mismo tiempo que sus precios unitarios estén entre 50 y 100. Por último, ordena los resultados 
por código de proveedor de forma ascendente.*/

SELECT *
FROM products
WHERE supplier_id IN (1, 3, 7, 8, 9) AND units_in_stock > 0 AND unit_price BETWEEN 50 AND 100
ORDER BY supplier_id DESC;

/* 2. Devuelve el nombre y apellidos y el id de los empleados con códigos entre el 3 y el 6, además que hayan vendido a clientes que tengan 
códigos que comiencen con las letras de la A hasta la G. Por último, en esta búsqueda queremos filtrar solo por aquellos envíos que la 
fecha de pedido este comprendida entre el 22 y el 31 de Diciembre de cualquier año.*/


SELECT last_name, first_name, employee_id
FROM employees
WHERE employee_id IN (
						SELECT employee_id
						FROM orders
						WHERE DAY(order_date) BETWEEN 22 AND 31 AND MONTH(order_date) = 12 AND customer_id REGEXP '^[A-G]' 
						AND employee_id BETWEEN 3 AND 6);
						
SELECT employee_id, customer_id, order_id
FROM orders
WHERE DAY(order_date) BETWEEN 22 AND 31 AND MONTH(order_date) = 12 AND customer_id REGEXP '^[A-G]' AND employee_id BETWEEN 3 AND 6;


/*3.Calcula el precio de venta de cada pedido una vez aplicado el descuento. Muestra el id del la orden, el id del producto, el nombre del 
producto, el precio unitario, la cantidad, el descuento y el precio de venta después de haber aplicado el descuento.*/

SELECT order_details.order_id, products.product_id, products.product_name, order_details.quantity, order_details.unit_price, 
		order_details.discount, ((order_details.unit_price *quantity)*(1-discount)) AS precio_pedido_con_descuento
FROM products
CROSS JOIN order_details
WHERE order_details.unit_price = products.unit_price; 

/*4.Usando una subconsulta, muestra los productos cuyos precios estén por encima del precio medio total de los productos de la BBDD.*/

SELECT product_name, unit_price
FROM products 
	WHERE unit_price > (
							SELECT AVG(unit_price)
                            FROM products);
                         
/*5.¿Qué productos ha vendido cada empleado y cuál es la cantidad vendida de cada uno de ellos?

/*Basándonos en la query anterior, ¿qué empleado es el que vende más productos? Soluciona este ejercicio con una subquery
BONUS ¿Podríais solucionar este mismo ejercicio con una CTE?*/

SELECT SUM(quantity), product_id, employee_id
	FROM order_details NATURAL JOIN orders
    GROUP BY product_id, employee_id;

SELECT employee_id, last_name, first_name
	FROM employees
    WHERE employee_id > ALL (SELECT SUM(quantity)
							FROM order_details NATURAL JOIN orders
							GROUP BY product_id, employee_id);
	