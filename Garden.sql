-- creacion de la base de datos
CREATE DATABASE Garden;
USE Garden;

-- creacion de tablas independientes

-- tabla gama_producto
CREATE TABLE gama_producto(
	gama VARCHAR(50) NOT NULL,
	descripcionTexto TEXT,
	descripcionHtml TEXT,
	imagen VARCHAR(256),
	
	CONSTRAINT pk_gama PRIMARY KEY (gama)
);

-- tabla pais
CREATE TABLE pais(
	codigoPais VARCHAR(6),
	nombre VARCHAR(56) NOT NULL,
	continente VARCHAR(21) NOT NULL,
	area DECIMAL(15,2) NOT NULL,

	CONSTRAINT pk_Pais PRIMARY KEY (codigoPais)
);

-- tabla estados
CREATE TABLE estado(
	nombreEstado VARCHAR(180) NOT NULL,
	descripcion TEXT NOT NULL,
	
	CONSTRAINT Pk_Estado PRIMARY KEY (nombreEstado)
);

-- creacion de tablas DEPENDIENTES

-- tabla region
CREATE TABLE region(
	codigoRegion VARCHAR(6) NOT NULL,
	nombreRegion VARCHAR(85) NOT NULL,
	fkPais VARCHAR(6) NOT NULL,
	
	CONSTRAINT pk_Region PRIMARY KEY (codigoRegion), 
	CONSTRAINT fk_Pais_Region FOREIGN KEY (fkPais) REFERENCES pais(codigoPais)
);

-- tabla ciudad
CREATE TABLE ciudad(
	codigoCiudad VARCHAR(6) NOT NULL,
	nombreCiudad VARCHAR(168) NOT NULL,
	fkRegion VARCHAR(6) NOT NULL,
	
	CONSTRAINT pk_Ciudad PRIMARY KEY (codigoCiudad),
	CONSTRAINT fk_Region_Ciudad FOREIGN KEY (fkRegion) REFERENCES region(codigoRegion)
);

-- tabla oficina
CREATE TABLE oficina(
	codigoOficina VARCHAR(10) NOT NULL,
	fkCiudad VARCHAR(30) NOT NULL,
	fkPais VARCHAR(50) NOT NULL,
	fkRegion VARCHAR(50),
	codigoPostal VARCHAR(10) NOT NULL,
	telefono VARCHAR(20) NOT NULL,
	lineaDireccion1 VARCHAR(50) NOT NULL,
	lineaDireccion2 VARCHAR(50),
	
	CONSTRAINT pk_codigoOficina PRIMARY KEY (codigoOficina),
	CONSTRAINT fk_Ciudad_Oficina FOREIGN KEY (fkCiudad) REFERENCES ciudad(codigoCiudad),
	CONSTRAINT fk_Pais_Oficina FOREIGN KEY (fkPais) REFERENCES pais(codigoPais),
	CONSTRAINT fk_Region_Oficina FOREIGN KEY (fkRegion) REFERENCES region(codigoRegion)
);

-- tabla proveedor : pendiente
CREATE TABLE proveedor(
	idProveedor INT(11) NOT NULL,
	nombreProveedor VARCHAR(50) NOT NULL,
	nombreContacto VARCHAR(50) NOT NULL,
	cargoContacto VARCHAR(50) NOT NULL,
	direccion VARCHAR(50) NOT NULL,
	codigoPostal VARCHAR(10) NOT NULL,
	fkCiudad VARCHAR(6) NOT NULL,
	fkPais VARCHAR(6) NOT NULL,
	telefono VARCHAR(12) NOT NULL,
	fax VARCHAR(15) NOT NULL,
	terminosPago VARCHAR(10) NOT NULL,
	email VARCHAR(100) NOT NULL,
	
	CONSTRAINT pk_proveedor PRIMARY KEY (idProveedor),
	CONSTRAINT fk_Ciudad_Proveedor FOREIGN KEY (fkCiudad) REFERENCES ciudad(codigoCiudad),
	CONSTRAINT fk_Pais_Proveedor FOREIGN KEY (fkPais) REFERENCES pais(codigoPais)
);

-- tabla empleados : pendiente
CREATE TABLE empleado(
	codigoEmpleado INT(11) NOT NULL,
	nombre VARCHAR(50) NOT NULL,
	apellido1 VARCHAR(50) NOT NULL,
	apellido2 VARCHAR(50),
	extension VARCHAR(10) NOT NULL,
	email VARCHAR(100) NOT NULL,
	fkCodigoOficina VARCHAR(10) NOT NULL,
	fkCodigoJefe INT(11),
	puesto VARCHAR(50),
	
	CONSTRAINT pk_empleado PRIMARY KEY (codigoEmpleado),
	CONSTRAINT fk_Oficina_Empleado FOREIGN KEY (fkCodigoOficina) REFERENCES oficina (codigoOficina),
	CONSTRAINT fk_Empleado_Empleado FOREIGN KEY (fkCodigoJefe) REFERENCES empleado(codigoEmpleado)
);

-- tabla producto : pendiente
CREATE TABLE producto(
	codigoProducto VARCHAR(15) NOT NULL,
	nombre VARCHAR(70) NOT NULL,
	fkGama VARCHAR(50) NOT NULL,
	dimensiones VARCHAR(25),
	fkProveedor INT(11) NOT NULL,
	descripcion TEXT,
	cantidadEnStock SMALLINT(6) NOT NULL,
	precioVenta DECIMAL(15,2) NOT NULL,
	precioProveedor DECIMAL(15,2),
	
	CONSTRAINT pk_producto PRIMARY KEY (codigoProducto),	
	CONSTRAINT fk_GamaProducto_Producto FOREIGN KEY (fkGama) REFERENCES gama_producto (gama),
	CONSTRAINT fk_Proveedor_Producto FOREIGN KEY (fkProveedor) REFERENCES proveedor (idProveedor)
);

-- tabla cliente : pendiente
CREATE TABLE cliente(
	codigoCliente INT(11) NOT NULL,
	nombreCliente VARCHAR(50) NOT NULL,
	nombreContacto VARCHAR(30),
	apellidoContacto VARCHAR(30),
	telefono VARCHAR(15) NOT NULL,
	fax VARCHAR(15) NOT NULL,
	lineaDireccion1 VARCHAR(50) NOT NULL,
	lineaDireccion2 VARCHAR(50),
	fkCiudad VARCHAR(50) NOT NULL,
	fkRegion VARCHAR(50),
	fkPais VARCHAR(50),
	codigo_postal VARCHAR(10),
	fkEmpleadoRepVentas INT(11),
	limiteCredito DECIMAL(15,2),
	
	CONSTRAINT pk_Cliente PRIMARY KEY (codigoCliente),
	CONSTRAINT fk_Empleado_Cliente FOREIGN KEY (fkEmpleadoRepVentas) REFERENCES empleado(codigoEmpleado),
	CONSTRAINT fk_Ciudad_Cliente FOREIGN KEY (fkCiudad) REFERENCES ciudad(codigoCiudad),
	CONSTRAINT fk_Region_Cliente FOREIGN KEY (fkRegion) REFERENCES region(codigoRegion),
	CONSTRAINT fk_Pais_Cliente FOREIGN KEY (fkPais) REFERENCES pais(codigoPais)
);

-- tabla pago : pendiente
CREATE TABLE pago(
	idTransaccion VARCHAR(50) NOT NULL,
	formaPago ENUM('Tarjeta de credito', 'Tarjeta de debito', 'Efectivo'),
	fkCodigoCliente INT(11) NOT NULL,
	fechaPago DATE NOT NULL,
	total DECIMAL(15,2) NOT NULL,
	
	CONSTRAINT pk_Pago PRIMARY KEY (idTransaccion),
	CONSTRAINT fk_Cleinte_Pago FOREIGN KEY (fkCodigoCliente) REFERENCES cliente(codigoCliente)
);

-- tabla pedido
CREATE TABLE pedido(
	codigoPedido INT(11) NOT NULL,
	fechaPedido DATE NOT NULL,
	fechaEsperada DATE NOT NULL,
	fechaEntregada DATE,
	fkEstado VARCHAR(180),
	comentarios TEXT,
	fkCodigoCliente INT(11) NOT NULL,
	
	CONSTRAINT pk_pedido PRIMARY KEY (codigoPedido),
	CONSTRAINT fk_Cliente_Pedido FOREIGN KEY (fkCodigoCliente) REFERENCES cliente(codigoCliente),
	CONSTRAINT fk_Estado_Pedido FOREIGN KEY (fkEstado) REFERENCES estado(nombreEstado)
);

-- tabla detalle_pedido
CREATE TABLE detalle_pedido(
	FkCodigoPedido INT(11) NOT NULL,
	FkCodigoProducto VARCHAR(15) NOT NULL,
	cantidad INT(11) NOT NULL,
	fkPrecioUnidad VARCHAR(15) NOT NULL,
	numeroLinea SMALLINT(6) NOT NULL,
	
	CONSTRAINT pk_detallePedido PRIMARY KEY (FkCodigoPedido, FkCodigoProducto),
	CONSTRAINT fk_Pedido_DetallePedido FOREIGN KEY (FkCodigoPedido) REFERENCES pedido(codigoPedido),
	CONSTRAINT fk_Producto_DetallePedido FOREIGN KEY (FkCodigoProducto) REFERENCES producto(codigoProducto),
	CONSTRAINT fk_ProductoPrecio_DetallePedido FOREIGN KEY (fkPrecioUnidad) REFERENCES producto(codigoProducto)
);

-- INSERTS
-- tabla estado (Opcional - segun necesidades)
INSERT INTO estado(nombreEstado, descripcion) VALUES
('Entregado', 'El producto se entregó exitosamente'),
('No Entregado', 'El producto no fue entregado al cliente'),
('Averiado', 'El producto se averio en el trayecto'),
('Rechazado', 'El producto fue rechazado por el cliente');

-- tabla gama producto
INSERT INTO gama_producto (gama, descripcionTexto, descripcionHtml, imagen) VALUES
('Gama Alta', 'Productos de alta calidad con materiales premium.', '<p>Productos de alta calidad con <strong>materiales premium</strong>.</p>', 'https://example.com/images/gama-alta.jpg'),
('Gama Media', 'Buena calidad a un precio accesible.', '<p>Buena calidad a un <em>precio accesible</em>.</p>', 'https://example.com/images/gama-media.jpg'),
('Gama Baja', 'Productos económicos y funcionales.', '<p>Productos económicos y <strong>funcionales</strong>.</p>', 'https://example.com/images/gama-baja.jpg');

-- tabla pais
INSERT INTO pais (codigoPais, nombre, continente, area) VALUES
('ARG', 'Argentina', 'América del Sur', 2780400.00),
('BRA', 'Brasil', 'América del Sur', 8515767.00),
('CAN', 'Canadá', 'América del Norte', 9984670.00),
('CHN', 'China', 'Asia', 9596961.00),
('FRA', 'Francia', 'Europa', 551695.00),
('DEU', 'Alemania', 'Europa', 357022.00),
('IND', 'India', 'Asia', 3287263.00),
('IDN', 'Indonesia', 'Asia', 1904569.00),
('ITA', 'Italia', 'Europa', 301340.00),
('JPN', 'Japón', 'Asia', 377975.00),
('MEX', 'México', 'América del Norte', 1964375.00),
('RUS', 'Rusia', 'Europa/Asia', 17098242.00),
('SAU', 'Arabia Saudita', 'Asia', 2149690.00),
('ZAF', 'Sudáfrica', 'África', 1219090.00),
('KOR', 'Corea del Sur', 'Asia', 100210.00),
('ESP', 'España', 'Europa', 505992.00),
('SWE', 'Suecia', 'Europa', 450295.00),
('CHE', 'Suiza', 'Europa', 41285.00),
('TUR', 'Turquía', 'Europa/Asia', 783562.00),
('GBR', 'Reino Unido', 'Europa', 243610.00);

-- tabla region
INSERT INTO region (codigoRegion, nombreRegion, fkPais) VALUES
('REG001', 'Región Norte', 'ARG'),
('REG002', 'Región Sur', 'ARG'),
('REG003', 'Región Este', 'BRA'),
('REG004', 'Región Oeste', 'BRA'),
('REG005', 'Región Este', 'CAN'),
('REG006', 'Región Oeste', 'CAN'),
('REG007', 'Región Norte', 'CHN'),
('REG008', 'Región Sur', 'CHN'),
('REG009', 'Región Norte', 'FRA'),
('REG010', 'Región Sur', 'FRA'),
('REG011', 'Región Norte', 'DEU'),
('REG012', 'Región Sur', 'DEU'),
('REG013', 'Región Este', 'IND'),
('REG014', 'Región Oeste', 'IND'),
('REG015', 'Región Este', 'IDN'),
('REG016', 'Región Oeste', 'IDN'),
('REG017', 'Región Norte', 'ITA'),
('REG018', 'Región Sur', 'ITA'),
('REG019', 'Región Este', 'JPN'),
('REG020', 'Región Oeste', 'JPN'),
('REG021', 'Region Oeste', 'ESP');

-- tabla ciudad 
INSERT INTO ciudad (codigoCiudad, nombreCiudad, fkRegion) VALUES
('C001', 'Buenos Aires', 'REG001'), -- Argentina - Región Norte
('C002', 'Córdoba', 'REG001'), -- Argentina - Región Norte
('C003', 'São Paulo', 'REG003'), -- Brasil - Región Este
('C004', 'Río de Janeiro', 'REG003'), -- Brasil - Región Este
('C005', 'Toronto', 'REG005'), -- Canadá - Región Este
('C006', 'Montreal', 'REG005'), -- Canadá - Región Este
('C007', 'Beijing', 'REG007'), -- China - Región Norte
('C008', 'Shanghai', 'REG007'), -- China - Región Norte
('C009', 'París', 'REG009'), -- Francia - Región Norte
('C010', 'Marsella', 'REG009'), -- Francia - Región Norte
('C011', 'Berlín', 'REG011'), -- Alemania - Región Norte
('C012', 'Múnich', 'REG011'), -- Alemania - Región Norte
('C013', 'Delhi', 'REG013'), -- India - Región Este
('C014', 'Bombay', 'REG013'), -- India - Región Este
('C015', 'Yakarta', 'REG015'), -- Indonesia - Región Este
('C016', 'Surabaya', 'REG015'), -- Indonesia - Región Este
('C017', 'Roma', 'REG017'), -- Italia - Región Norte
('C018', 'Milán', 'REG017'), -- Italia - Región Norte
('C019', 'Tokio', 'REG019'), -- Japón - Región Este
('C020', 'Osaka', 'REG019'), -- Japón - Región Este0
('C021','Madrid', 'REG021');

-- tabla oficina
INSERT INTO oficina (codigoOficina, fkCiudad, fkPais, fkRegion, codigoPostal, telefono, lineaDireccion1, lineaDireccion2) VALUES
('OF001', 'C001', 'ARG', 'REG001', '1000', '+54 11 1234 5678', 'Av. Siempre Viva 123', NULL),
('OF002', 'C002', 'ARG', 'REG001', '5000', '+54 351 1234 5678', 'Calle Falsa 456', NULL),
('OF003', 'C003', 'BRA', 'REG003', '01000-000', '+55 11 1234 5678', 'Rua das Flores 789', NULL),
('OF004', 'C004', 'BRA', 'REG003', '20000-000', '+55 21 1234 5678', 'Avenida Atlântica 1011', NULL),
('OF005', 'C005', 'CAN', 'REG005', 'M5H 2N2', '+1 416 123 4567', 'Queen St W 1213', NULL),
('OF006', 'C006', 'CAN', 'REG005', 'H3B 2Y3', '+1 514 123 4567', 'Boulevard René-Lévesque 1415', NULL),
('OF007', 'C007', 'CHN', 'REG007', '100000', '+86 10 1234 5678', 'Changan Avenue 1617', NULL),
('OF008', 'C008', 'CHN', 'REG007', '200000', '+86 21 1234 5678', 'Nanjing Road 1819', NULL),
('OF009', 'C009', 'FRA', 'REG009', '75000', '+33 1 1234 5678', 'Champs-Élysées 2021', NULL),
('OF010', 'C010', 'FRA', 'REG009', '13000', '+33 4 1234 5678', 'Rue de la République 2223', NULL),
('OF011', 'C011', 'DEU', 'REG011', '10115', '+49 30 1234 5678', 'Unter den Linden 2425', NULL),
('OF012', 'C012', 'DEU', 'REG011', '80331', '+49 89 1234 5678', 'Marienplatz 2627', NULL),
('OF013', 'C013', 'IND', 'REG013', '110001', '+91 11 1234 5678', 'Connaught Place 2829', NULL),
('OF014', 'C014', 'IND', 'REG013', '400001', '+91 22 1234 5678', 'Marine Drive 3031', NULL),
('OF015', 'C015', 'IDN', 'REG015', '10110', '+62 21 1234 5678', 'Jalan MH Thamrin 3233', NULL),
('OF016', 'C016', 'IDN', 'REG015', '60271', '+62 31 1234 5678', 'Jalan Tunjungan 3435', NULL),
('OF017', 'C017', 'ITA', 'REG017', '00100', '+39 06 1234 5678', 'Via del Corso 3637', NULL),
('OF018', 'C018', 'ITA', 'REG017', '20121', '+39 02 1234 5678', 'Via Montenapoleone 3839', NULL),
('OF019', 'C019', 'JPN', 'REG019', '100-0001', '+81 3 1234 5678', 'Chiyoda 4041', NULL),
('OF020', 'C020', 'JPN', 'REG019', '530-0001', '+81 6 1234 5678', 'Kita-ku 4243', NULL),
('OF021', 'C021', 'ESP', 'REG021', '1000', '+54 11 1239 5689', 'Av. CuadraPicha', 'Cll. La Rosita');

-- tabla proveedor
INSERT INTO proveedor (idProveedor, nombreProveedor, nombreContacto, cargoContacto, direccion, codigoPostal, fkCiudad, fkPais, telefono, fax, terminosPago, email) VALUES
(1, 'Proveedor Alfa', 'Juan Pérez', 'Gerente', 'Calle Falsa 123', '1001', 'C001', 'ARG', '+5411134567', '+5411123567', '30 días', 'juan.perez@alfa.com'),
(2, 'Proveedor Beta', 'María López', 'Administradora', 'Avenida Siempre Viva 456', '1002', 'C002', 'ARG', '+5431234567', '+5435134567', '45 días', 'maria.lopez@beta.com'),
(3, 'Proveedor Gamma', 'José da Silva', 'Director', 'Rua das Flores 789', '2001', 'C003', 'BRA', '+55119865432', '+55119765432', '60 días', 'jose.silva@gamma.com'),
(4, 'Proveedor Delta', 'Ana Sousa', 'Coordinadora', 'Avenida Brasil 987', '2002', 'C004', 'BRA', '+55219875432', '+55218765432', '30 días', 'ana.sousa@delta.com'),
(5, 'Proveedor Épsilon', 'John Smith', 'Manager', 'Maple Street 123', '3001', 'C005', 'CAN', '+141612356', '+141623456', '45 días', 'john.smith@epsilon.com'),
(6, 'Proveedor Zeta', 'Robert Brown', 'Supervisor', 'Pine Avenue 456', '3002', 'C006', 'CAN', '+151444566', '+151445566', '60 días', 'robert.brown@zeta.com'),
(7, 'Proveedor Eta', 'Li Wei', 'General Manager', 'Wangfujing Street 789', '4001', 'C007', 'CHN', '+8610134567', '+8610234567', '30 días', 'li.wei@eta.com'),
(8, 'Proveedor Theta', 'Chen Yu', 'Sales Manager', 'Nanjing Road 987', '4002', 'C008', 'CHN', '+8621754321', '+8621654321', '45 días', 'chen.yu@theta.com'),
(9, 'Proveedor Iota', 'Jean Dupont', 'Directeur', 'Rue de Rivoli 123', '5001', 'C009', 'FRA', '+331235678', '+331235679', '60 días', 'jean.dupont@iota.com'),
(10, 'Proveedor Kappa', 'Marie Martin', 'Responsable', 'Boulevard Saint-Germain 456', '5002', 'C010', 'FRA', '+334976543', '+334876543', '30 días', 'marie.martin@kappa.com'),
(11, 'Proveedor Lambda', 'Hans Müller', 'Geschäftsführer', 'Unter den Linden 789', '6001', 'C011', 'DEU', '+49301122334', '+49311122334', '45 días', 'hans.muller@lambda.com'),
(12, 'Proveedor Mu', 'Klaus Schmidt', 'Leiter', 'Marienplatz 987', '6002', 'C012', 'DEU', '+49894455677', '+49894456677', '60 días', 'klaus.schmidt@mu.com'),
(13, 'Proveedor Nu', 'Rajesh Kumar', 'Head', 'Connaught Place 123', '7001', 'C013', 'IND', '+9111123567', '+9111123467', '30 días', 'rajesh.kumar@nu.com'),
(14, 'Proveedor Xi', 'Amit Patel', 'Manager', 'Nariman Point 456', '7002', 'C014', 'IND', '+9122875432', '+9122765432', '45 días', 'amit.patel@xi.com'),
(15, 'Proveedor Omicron', 'Budi Santoso', 'Director', 'Jalan Sudirman 789', '8001', 'C015', 'IDN', '+62111223344', '+62211223345', '60 días', 'budi.santoso@omicron.com'),
(16, 'Proveedor Pi', 'Dewi Lestari', 'Coordinator', 'Jalan Tunjungan 987', '8002', 'C016', 'IDN', '+62314455778', '+62314466779', '30 días', 'dewi.lestari@pi.com'),
(17, 'Proveedor Rho', 'Giuseppe Rossi', 'Amministratore', 'Via Condotti 123', '9001', 'C017', 'ITA', '+390612567', '+390634568', '45 días', 'giuseppe.rossi@rho.com'),
(18, 'Proveedor Sigma', 'Luca Bianchi', 'Responsabile', 'Corso Buenos Aires 456', '9002', 'C018', 'ITA', '+390654321', '+390654322', '60 días', 'luca.bianchi@sigma.com'),
(19, 'Proveedor Tau', 'Kenji Tanaka', 'Manager', 'Ginza 789', '10001', 'C019', 'JPN', '+8131123344', '+8131122335', '30 días', 'kenji.tanaka@tau.com'),
(20, 'Proveedor Upsilon', 'Hiroshi Yamamoto', 'Coordinator', 'Dotonbori 987', '10002', 'C020', 'JPN', '+8164456678', '+8164466779', '45 días', 'hiroshi.yamamoto@upsilon.com');

-- tabla empleados
INSERT INTO empleado (codigoEmpleado, nombre, apellido1, apellido2, extension, email, fkCodigoOficina, fkCodigoJefe, puesto) VALUES
(1, 'Juan', 'López', NULL, '1001', 'juan.lopez@empresa.com', 'OF001', NULL, 'Gerente General'),
(2, 'María', 'González', NULL, '1002', 'maria.gonzalez@empresa.com', 'OF002', 1, 'Jefe de Equipo'),
(3, 'Carlos', 'Martínez', NULL, '1003', 'carlos.martinez@empresa.com', 'OF003', 1, 'Jefe de Equipo'),
(4, 'Ana', 'Rodríguez', NULL, '1004', 'ana.rodriguez@empresa.com', 'OF004', 1, 'Jefe de Equipo'),
(5, 'Pedro', 'Hernández', NULL, '1005', 'pedro.hernandez@empresa.com', 'OF005', 1, 'Jefe de Equipo'),
(6, 'Laura', 'Pérez', NULL, '1006', 'laura.perez@empresa.com', 'OF006', 2, 'Asistente'),
(7, 'José', 'Sánchez', NULL, '1007', 'jose.sanchez@empresa.com', 'OF007', 3, 'Asistente'),
(8, 'Isabel', 'Gómez', NULL, '1008', 'isabel.gomez@empresa.com', 'OF008', 4, 'Asistente'),
(9, 'Lucía', 'Díaz', NULL, '1009', 'lucia.diaz@empresa.com', 'OF009', 5, 'Asistente'),
(10, 'Daniel', 'Martín', NULL, '1010', 'daniel.martin@empresa.com', 'OF010', 2, 'Asistente'),
(11, 'Sara', 'Ruiz', NULL, '1011', 'sara.ruiz@empresa.com', 'OF011', 3, 'Asistente'),
(12, 'Javier', 'Jiménez', NULL, '1012', 'javier.jimenez@empresa.com', 'OF012', 4, 'Asistente'),
(13, 'Elena', 'López', NULL, '1013', 'elena.lopez@empresa.com', 'OF013', 5, 'Asistente'),
(14, 'Marcos', 'Fernández', NULL, '1014', 'marcos.fernandez@empresa.com', 'OF014', 2, 'Asistente'),
(15, 'Nuria', 'Sanz', NULL, '1015', 'nuria.sanz@empresa.com', 'OF015', 3, 'Asistente'),
(16, 'Miguel', 'Serrano', NULL, '1016', 'miguel.serrano@empresa.com', 'OF016', 4, 'Asistente'),
(17, 'Carmen', 'Lorenzo', NULL, '1017', 'carmen.lorenzo@empresa.com', 'OF017', 5, 'Asistente'),
(18, 'Pablo', 'Vidal', NULL, '1018', 'pablo.vidal@empresa.com', 'OF018', 2, 'Asistente'),
(19, 'Luisa', 'Cabrera', NULL, '1019', 'luisa.cabrera@empresa.com', 'OF019', 3, 'Asistente'),
(20, 'Diego', 'Mendoza', NULL, '1020', 'diego.mendoza@empresa.com', 'OF020', 4, 'Asistente');

-- tabla producto
INSERT INTO producto (codigoProducto, nombre, fkGama, dimensiones, fkProveedor, descripcion, cantidadEnStock, precioVenta, precioProveedor) VALUES
('PROD001', 'Teléfono inteligente XYZ', 'Gama Alta', '15x7x0.8 cm', 1, 'Teléfono inteligente de última generación con características avanzadas.', 100, 699.99, 550),
('PROD002', 'Portátil ABC', 'Gama Alta', '35x25x1.5 cm', 1, 'Portátil ligero y potente ideal para profesionales.', 50, 1499.99, 1200),
('PROD003', 'Tablet 123', 'Gama Media', '20x15x0.7 cm', 2, 'Tablet versátil con buen rendimiento y precio accesible.', 75, 299.99, 220),
('PROD004', 'Smartwatch DEF', 'Gama Media', '4x4x1 cm', 2, 'Smartwatch con múltiples funciones y diseño elegante.', 120, 199.99, 150),
('PROD005', 'Cámara GHI', 'Gama Alta', '12x8x6 cm', 3, 'Cámara profesional con excelente calidad de imagen y grabación 4K.', 30, 899.99, 750),
('PROD006', 'Impresora JKL', 'Gama Media', '40x30x20 cm', 3, 'Impresora multifunción rápida y eficiente para uso doméstico.', 40, 249.99, 180),
('PROD007', 'Auriculares MNO', 'Gama Media', '20x18x8 cm', 4, 'Auriculares inalámbricos con sonido de alta fidelidad y cancelación de ruido.', 90, 129.99, 100),
('PROD008', 'Altavoz PQR', 'Gama Baja', '15x10x8 cm', 4, 'Altavoz Bluetooth portátil con buen rendimiento y precio económico.', 150, 49.99, 35),
('PROD009', 'Teclado RGB', 'Gama Alta', '45x15x3 cm', 5, 'Teclado mecánico retroiluminado con múltiples opciones de personalización.', 60, 129.99, 100),
('PROD010', 'Ratón Gaming', 'Gama Baja', '12x8x4 cm', 5, 'Ratón ergonómico con sensor óptico y diseño para jugadores ocasionales.', 100, 29.99, 20),
('PROD011', 'Mochila TUV', 'Gama Media', '45x30x15 cm', 6, 'Mochila resistente con múltiples compartimentos y acolchado para portátil.', 80, 79.99, 60),
('PROD012', 'Bolígrafo WXZ', 'Gama Baja', '15x1 cm', 6, 'Bolígrafo clásico con tinta de larga duración y cuerpo ergonómico.', 200, 2.99, 1.5),
('PROD013', 'Funda para móvil LMN', 'Gama Baja', '16x8x1 cm', 7, 'Funda protectora para móvil con diseño minimalista y materiales duraderos.', 120, 14.99, 10),
('PROD014', 'Cable USB UVW', 'Gama Media', '150 cm', 7, 'Cable USB de alta velocidad y calidad con conectores reforzados.', 150, 9.99, 7),
('PROD015', 'Batería externa XYZ', 'Gama Media', '10x5x2 cm', 8, 'Batería externa compacta y ligera con capacidad para múltiples cargas.', 100, 39.99, 30),
('PROD016', 'Adaptador de corriente DEF', 'Gama Baja', '7x5x3 cm', 8, 'Adaptador de corriente universal para dispositivos electrónicos.', 200, 19.99, 15),
('PROD017', 'Mousepad GHI', 'Gama Baja', '30x25 cm', 9, 'Mousepad de tela con base antideslizante y borde reforzado.', 300, 4.99, 3),
('PROD018', 'Soporte para móvil JKL', 'Gama Media', '10x8x6 cm', 9, 'Soporte ajustable para móvil con diseño compacto y estable.', 150, 12.99, 9),
('PROD019', 'Cable HDMI MNO', 'Gama Baja', '200 cm', 10, 'Cable HDMI de alta velocidad y calidad para conexión de dispositivos.', 200, 7.99, 5),
('PROD020', 'Lámpara LED PQR', 'Gama Baja', '20x10x10 cm', 10, 'Lámpara LED portátil con tres niveles de intensidad y batería recargable.', 100, 19.99, 15);

-- tabla cliente
INSERT INTO cliente (codigoCliente, nombreCliente, nombreContacto, apellidoContacto, telefono, fax, lineaDireccion1, lineaDireccion2, fkCiudad, fkRegion, fkPais, codigo_postal, fkEmpleadoRepVentas, limiteCredito) VALUES
(1, 'ElectroTech Solutions', 'Ana', 'Martínez', '+123456789', '+123456789', '123 Main Street', 'Suite 100', 'C001', 'REG001', 'ARG', '1001', 2, 50000.00),
(2, 'TechNova', 'David', 'García', '+234567890', '+234567890', '456 Elm Avenue', NULL, 'C002', 'REG002', 'ARG', '1002', 3, 75000.00),
(3, 'Global Electronics', 'Luisa', 'Sánchez', '+345678901', '+345678901', '789 Oak Boulevard', NULL, 'C003', 'REG003', 'BRA', '2001', 4, 100000.00),
(4, 'InnoTech Solutions', 'Juan', 'Gómez', '+456789012', '+456789012', '321 Pine Street', NULL, 'C004', 'REG004', 'BRA', '2002', 5, 60000.00),
(5, 'SmartDevices Inc.', 'Marta', 'Fernández', '+567890123', '+567890123', '654 Cedar Lane', NULL, 'C005', 'REG005', 'CAN', '3001', 6, 80000.00),
(6, 'FutureTech Innovations', 'Pedro', 'López', '+678901234', '+678901234', '987 Maple Drive', NULL, 'C006', 'REG006', 'CAN', '3002', 7, 90000.00),
(7, 'TechPro Solutions', 'Carmen', 'Díaz', '+789012345', '+789012345', '159 Birch Street', NULL, 'C007', 'REG007', 'CHN', '4001', 8, 120000.00),
(8, 'GlobalTech Enterprises', 'Carlos', 'Hernández', '+890123456', '+890123456', '357 Willow Road', NULL, 'C008', 'REG008', 'CHN', '4002', 9, 110000.00),
(9, 'ElectroWorld Ltd.', 'Sara', 'Martínez', '+901234567', '+901234567', '753 Pinecrest Avenue', NULL, 'C009', 'REG009', 'FRA', '5001', 10, 95000.00),
(10, 'TechZone Corporation', 'Javier', 'González', '+012345678', '+012345678', '852 Cedar Lane', NULL, 'C010', 'REG010', 'FRA', '5002', 11, 70000.00),
(11, 'InnoSolutions', 'María', 'Hernández', '+123456789', '+123456789', '963 Elm Street', NULL, 'C011', 'REG011', 'DEU', '6001', 12, 80000.00),
(12, 'SmartTech GmbH', 'Jorge', 'Pérez', '+234567890', '+234567890', '147 Oak Avenue', NULL, 'C012', 'REG012', 'DEU', '6002', 13, 65000.00),
(13, 'ElectroMasters', 'Laura', 'Gómez', '+345678901', '+345678901', '369 Maple Drive', NULL, 'C013', 'REG013', 'IND', '7001', 14, 75000.00),
(14, 'TechGenius Solutions', 'Pablo', 'Fernández', '+456789012', '+456789012', '258 Birch Street', NULL, 'C014', 'REG014', 'IND', '7002', 15, 90000.00),
(15, 'GadgetWorld', 'Andrea', 'López', '+567890123', '+567890123', '741 Pinecrest Avenue', NULL, 'C015', 'REG015', 'IDN', '8001', 16, 60000.00),
(16, 'ElectroTronics', 'José', 'Martínez', '+678901234', '+678901234', '369 Cedar Lane', NULL, 'C016', 'REG016', 'IDN', '8002', 17, 85000.00),
(17, 'TechSolutions Ltd.', 'Elena', 'García', '+789012345', '+789012345', '147 Elm Street', NULL, 'C017', 'REG017', 'ITA', '9001', 18, 70000.00),
(18, 'InnoTech Innovations', 'Daniel', 'Hernández', '+890123456', '+890123456', '852 Oak Avenue', NULL, 'C018', 'REG018', 'ITA', '9002', 19, 75000.00),
(19, 'Global Gadgets Inc.', 'Sandra', 'Pérez', '+901234567', '+901234567', '963 Maple Drive', NULL, 'C019', 'REG019', 'JPN', '10001', 20, 80000.00);

-- tabla pago
INSERT INTO pago (idTransaccion, formaPago, fkCodigoCliente, fechaPago, total) VALUES
('TRANS001', 'Tarjeta de credito', 1, '2024-05-01', 1500.00),
('TRANS002', 'Tarjeta de credito', 2, '2024-05-02', 2200.00),
('TRANS003', 'Efectivo', 3, '2024-05-03', 1800.00),
('TRANS004', 'Tarjeta de debito', 4, '2024-05-04', 1250.00),
('TRANS005', 'Efectivo', 5, '2024-05-05', 2000.00),
('TRANS006', 'Tarjeta de credito', 6, '2024-05-06', 3000.00),
('TRANS007', 'Efectivo', 7, '2024-05-07', 1600.00),
('TRANS008', 'Tarjeta de credito', 8, '2024-05-08', 2400.00),
('TRANS009', 'Tarjeta de credito', 4, '2024-05-09', 1750.00),
('TRANS010', 'Tarjeta de debito', 10, '2024-05-10', 1400.00),
('TRANS011', 'Efectivo', 11, '2024-05-11', 1850.00),
('TRANS012', 'Tarjeta de credito', 11, '2024-05-12', 2100.00),
('TRANS013', 'Tarjeta de debito', 1, '2024-05-13', 1950.00),
('TRANS014', 'Efectivo', 1, '2024-05-14', 1700.00),
('TRANS015', 'Tarjeta de credito', 15, '2024-05-15', 2300.00),
('TRANS016', 'Efectivo', 11, '2024-05-16', 2050.00),
('TRANS017', 'Tarjeta de debito', 17, '2024-05-17', 1550.00),
('TRANS018', 'Tarjeta de credito', 18, '2024-05-18', 2200.00),
('TRANS019', 'Efectivo', 1, '2024-05-19', 1650.00),
('TRANS020', 'Tarjeta de credito', 2, '2024-05-20', 1900.00);

-- tabla pedido
INSERT INTO pedido (codigoPedido, fechaPedido, fechaEsperada, fechaEntregada, fkEstado, comentarios, fkCodigoCliente) VALUES
(1, '2024-05-01', '2024-05-15', '2024-05-17', 'Entregado', 'Todo entregado en buen estado.', 1),
(2, '2024-05-02', '2024-05-16', '2024-05-18', 'Entregado', 'Pedido entregado a tiempo.', 2),
(3, '2024-05-03', '2024-05-17', '2024-05-19', 'Rechazado', 'El cliente rechazó el pedido por tardanza', 3),
(4, '2024-05-04', '2024-05-18', NULL, 'No entregado', 'Problemas de logística, pedido aún no entregado.', 4),
(5, '2024-05-05', '2024-05-19', '2024-05-20', 'Entregado', 'Pedido entregado sin inconvenientes.', 5),
(6, '2024-05-06', '2024-05-20', '2024-05-21', 'Entregado', 'Cliente contento con la rapidez de entrega.', 6),
(7, '2024-05-07', '2024-05-21', '2024-05-22', 'Entregado', 'Productos en buen estado al recibirlos.', 7),
(8, '2024-05-08', '2024-05-22', '2024-05-23', 'No Entregado', 'Entrega realizada sin problemas.', 8),
(9, '2024-05-09', '2024-05-23', NULL, 'Rechazado', 'El cliente rechazó el pedido sin motivo aparente', 9),
(10, '2024-05-10', '2024-05-24', NULL, 'No entregado', 'Reprogramación de entrega necesaria debido a problemas de transporte.', 10),
(11, '2024-05-11', '2024-05-25', '2024-05-26', 'Entregado', 'Entrega realizada dentro del plazo previsto.', 11),
(12, '2024-05-12', '2024-05-26', '2024-05-27', 'Entregado', 'Pedido entregado en perfectas condiciones.', 12),
(13, '2024-05-13', '2024-05-27', NULL, 'Averiado', 'En el trayecto se perdieron varias cargas', 13),
(14, '2024-05-14', '2024-05-28', '2024-05-29', 'Rechazado', 'Cliente contento con la entrega.', 14),
(15, '2024-05-15', '2024-05-29', '2024-05-30', 'Entregado', 'Todo en orden al recibir el pedido.', 15),
(16, '2024-05-16', '2024-05-30', '2024-05-31', 'Entregado', 'Pedido entregado dentro del plazo.', 16),
(17, '2024-05-17', '2024-05-31', NULL, 'No entregado', 'Problemas de transporte, pedido aún no entregado.', 17),
(18, '2024-05-18', '2024-06-01', '2024-06-02', 'Entregado', 'Entrega realizada sin contratiempos.', 18),
(19, '2024-05-19', '2024-06-02', '2024-06-03', 'Entregado', 'Cliente satisfecho con la entrega.', 19),
(20, '2024-05-20', '2024-06-03', '2024-06-04', 'Entregado', 'Productos recibidos en buen estado.', 2),
(21, '2024-01-01', '2024-02-15','2024-02-13', 'Entregado', 'Llegó antes del tiempo estipulado', 4),
(22, '2023-01-12', '2023-02-01','2023-02-15', 'Rechazado', 'El cliente rechazó el producto por la tardanza', 13),
(23, '2009-01-12', '2009-02-01','2009-02-15', 'Rechazado', 'El cliente rechazó el producto por la tardanza', 12);

-- tabla detalle pedido
INSERT INTO detalle_pedido (FkCodigoPedido, FkCodigoProducto, cantidad, fkPrecioUnidad, numeroLinea) VALUES
(1, 'PROD001', 2, 'PROD001', 1),
(1, 'PROD003', 3, 'PROD003', 2),
(2, 'PROD005', 1, 'PROD005', 1),
(2, 'PROD007', 4, 'PROD007', 2),
(3, 'PROD009', 2, 'PROD009', 1),
(3, 'PROD011', 1, 'PROD011', 2),
(4, 'PROD013', 3, 'PROD013', 1),
(4, 'PROD015', 2, 'PROD015', 2),
(5, 'PROD017', 1, 'PROD017', 1),
(5, 'PROD019', 5, 'PROD019', 2),
(6, 'PROD002', 2, 'PROD002', 1),
(6, 'PROD004', 3, 'PROD004', 2),
(7, 'PROD006', 1, 'PROD006', 1),
(7, 'PROD008', 4, 'PROD008', 2),
(8, 'PROD010', 2, 'PROD010', 1),
(8, 'PROD012', 1, 'PROD012', 2),
(9, 'PROD014', 3, 'PROD014', 1),
(9, 'PROD016', 2, 'PROD016', 2),
(10, 'PROD018', 1, 'PROD018', 1),
(10, 'PROD020', 5, 'PROD020', 2);