# MySQL_Cristopher_Buitrago

## CONSULTAS

- CONSULTAS
DESCRIBE ciudad;
DESCRIBE oficina;

-- 1. Devuelve un listado con el código de oficina y la ciudad donde hay oficinas.
	SELECT o.codigoOficina AS Cod_Oficina, c.nombreCiudad AS ciudad
FROM oficina AS o
JOIN ciudad AS c
ON c.codigoCiudad = o.fkCiudad
WHERE o.fkCiudad IS NOT NULL;

-- 2. Devuelve un listado con la ciudad y el teléfono de las oficinas de España.
SELECT c.nombreCiudad AS Ciudad, o.telefono AS Telefono_Oficina, o.codigoOficina AS Cod_Oficina
FROM oficina AS o
JOIN ciudad AS c
ON c.codigoCiudad = o.fkCiudad
WHERE o.fkPais = 'ESP';

-- 3. Devuelve un listado con el nombre, apellidos y email de los empleados cuyo
--    jefe tiene un código de jefe igual a 7.
SELECT e.nombre, e.apellido1, e.apellido2, e.email
FROM empleado AS e
GROUP BY e.fkCodigoJefe
WHERE e.fkCodigoJefe = 7;


-- 4. Devuelve el nombre del puesto, nombre, apellidos y email del jefe de la
--    empresa.
SELECT e.nombre, e.apellido1, e.apellido2, e.email, e.puesto
FROM empleado AS e
WHERE fkCodigoJefe IS NULL;

-- 5. Devuelve un listado con el nombre, apellidos y puesto de aquellos
--    empleados que no sean representantes de ventas.
SELECT e.nombre, e.apellido1, e.apellido2, e.puesto
FROM empleado AS e
WHERE puesto != 'Representante ventas';

-- 6. Devuelve un listado con el nombre de los todos los clientes españoles.
SELECT c.nombre1Cliente
FROM cliente AS c
WHERE fkPais = 'ESP';

-- 7. Devuelve un listado con los distintos estados por los que puede pasar un
--    pedido.
SELECT e.nombreEstado AS Pedido_Estado
FROM estado AS e;

-- 8. Devuelve un listado con el código de cliente de aquellos clientes que
--    realizaron algún pago en 2008. Tenga en cuenta que deberá eliminar
--    aquellos códigos de cliente que aparezcan repetidos.
SELECT c.codigoCliente AS Cod_Cliente, c.nombreCliente AS Cliente
FROM cliente AS c
JOIN pago AS p
ON p.fkCodigoCliente = c.codigoCliente
WHERE YEAR(fechaPago) = 2008
GROUP BY Cod_Cliente;

SELECT c.codigoCliente AS Cod_Cliente, c.nombreCliente AS Cliente
FROM cliente AS c
JOIN pago AS p
ON p.fkCodigoCliente = c.codigoCliente
WHERE p.fechaPago LIKE '2008%'
GROUP BY Cod_Cliente;

-- 9. Devuelve un listado con el código de pedido, código de cliente, fecha
--    esperada y fecha de entrega de los pedidos que no han sido entregados a
--    tiempo.
SELECT p.codigoPedido, c.codigoCliente, p.fechaEsperada, p.fechaEntregada
FROM pedido AS p
JOIN cliente AS c
ON c.codigoCliente = p.fkCodigoCliente
WHERE p.fechaEntregada > p.fechaEsperada;

-- 10. Devuelve un listado con el código de pedido, código de cliente, fecha
--     esperada y fecha de entrega de los pedidos cuya fecha de entrega ha sido al
--     menos dos días antes de la fecha esperada.
SELECT p.codigoPedido, c.codigoCliente, p.fechaEsperada, p.fechaEntregada
FROM pedido AS p
JOIN cliente AS c
ON c.codigoCliente = p.fkCodigoCliente
WHERE (p.fechaEntregada - p.fechaEsperada) <= -2;

SELECT p.codigoPedido, c.codigoCliente, p.fechaEsperada, p.fechaEntregada
FROM pedido AS p
JOIN cliente AS c
ON c.codigoCliente = p.fkCodigoCliente
WHERE DATEDIFF(p.fechaEntregada,p.fechaEsperada) <= -2;

-- 11. Devuelve un listado de todos los pedidos que fueron rechazados en 2009.
SELECT p.codigoPedido AS Cod_Pedido
FROM pedido AS p
WHERE (p.fkEstado = 'Rechazado') AND (YEAR(p.fechaPedido) = 2009);

-- 12. Devuelve un listado de todos los pedidos que han sido entregados en el
--     mes de enero de cualquier año.
SELECT p.codigoPedido, p.fechaEntregada
FROM pedido AS p
WHERE MONTH(p.fechaEntregada) = 01;

-- 13. Devuelve un listado con todos los pagos que se realizaron en el
--     año 2008 mediante Paypal. Ordene el resultado de mayor a menor.
SELECT p.idTransaccion AS numero_transaccion, p.formaPago AS forma_de_pago, p.fechaPago AS Fecha
FROM pago AS p
WHERE YEAR(p.fechapago) = 2008 AND p.formaPago = 'Tarjeta de credito'; 

-- 14. Devuelve un listado con todas las formas de pago que aparecen en la
--     tabla pago. Tenga en cuenta que no deben aparecer formas de pago
--     repetidas.
SELECT p.formaPago
FROM pago AS p
GROUP BY p.formaPago;

-- 15. Devuelve un listado con todos los productos que pertenecen a la
--     gama Ornamentales y que tienen más de 100 unidades en stock. El listado
--     deberá estar ordenado por su precio de venta, mostrando en primer lugar
--     los de mayor precio.
SELECT p.nombre AS producto, p.cantidadEnStock AS Stock, p.precioVenta AS Precio_Unidad
FROM producto AS p
WHERE cantidadEnStock > 100 AND fkGama = 'Ornamental'
ORDER BY Precio_Unidad DESC;

-- 16. Devuelve un listado con todos los clientes que sean de la ciudad de Madrid y
--     cuyo representante de ventas tenga el código de empleado 11 o 30.
SELECT c.nombreCliente AS Cliente, c.fkCiudad AS Ciudad, c.fkEmpleadoRepVentas AS Rep_ventas
FROM cliente AS c
WHERE c.fkEmpleadoRepVentas = 11 OR c.fkEmpleadoRepVentas = 30;