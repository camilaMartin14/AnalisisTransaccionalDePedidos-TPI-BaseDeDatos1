CREATE DATABASE BDVENTALIBROS05;
GO
USE BDVENTALIBROS05
GO

SET DATEFORMAT DMY
CREATE TABLE provincias (
 id_provincia INT IDENTITY,
 provincia VARCHAR(20) NOT NULL,
 CONSTRAINT pk_provincia PRIMARY KEY(id_provincia));

CREATE TABLE sexos (
 id_sexo INT IDENTITY,
 sexo VARCHAR(10) NOT NULL,
 CONSTRAINT pk_sexo PRIMARY KEY(id_sexo));

CREATE TABLE editoriales (
 id_editorial INT IDENTITY,
 editorial VARCHAR(50) NOT NULL,
 CONSTRAINT pk_editorial PRIMARY KEY (id_editorial));

CREATE TABLE categorias (
 id_categoria INT IDENTITY,
 categoria VARCHAR(50) NOT NULL,
 CONSTRAINT pk_categoria PRIMARY KEY (id_categoria));

CREATE TABLE formas_pagos (
 id_forma_pago INT IDENTITY,
 forma_pago VARCHAR(50) NOT NULL,
 CONSTRAINT pk_forma_pago PRIMARY KEY (id_forma_pago));

CREATE TABLE estados_envios (
 id_estado_envio INT IDENTITY,
 estado_actual VARCHAR(20) NOT NULL,
 CONSTRAINT pk_estado_envio PRIMARY KEY (id_estado_envio));

CREATE TABLE formas_envios (
 id_forma_envio INT IDENTITY,
 forma_envio VARCHAR(20) NOT NULL,
 CONSTRAINT pk_forma_envio PRIMARY KEY (id_forma_envio));

CREATE TABLE tipos_documentos (
 id_tipo_doc INT IDENTITY,
 tipo VARCHAR(50) NOT NULL,
 CONSTRAINT pk_tipo_doc PRIMARY KEY(id_tipo_doc));

CREATE TABLE generos (
 id_genero INT IDENTITY,
 genero VARCHAR(50) NOT NULL,
 CONSTRAINT pk_genero PRIMARY KEY(id_genero));

CREATE TABLE tipos_contactos (
 id_tipo_contacto INT IDENTITY,
 tipo VARCHAR(20) NOT NULL,
 CONSTRAINT pk_tipo_contacto PRIMARY KEY(id_tipo_contacto));

CREATE TABLE financieras (
 id_financiera INT IDENTITY,
 nombre VARCHAR(20) NOT NULL,
 CONSTRAINT pk_financiera PRIMARY KEY(id_financiera));

CREATE TABLE nacionalidades (
 id_nacionalidad INT IDENTITY,
 nacionalidad VARCHAR(20) NOT NULL,
 CONSTRAINT pk_nacionalidad PRIMARY KEY(id_nacionalidad));

CREATE TABLE ciudades (
 id_ciudad INT IDENTITY,
 ciudad VARCHAR(50) NOT NULL,
 id_provincia INT NOT NULL,
 CONSTRAINT pk_ciudad PRIMARY KEY (id_ciudad),
 CONSTRAINT fk_ciudad_provincia FOREIGN KEY(id_provincia) REFERENCES
provincias(id_provincia));

CREATE TABLE barrios (
 id_barrio INT IDENTITY,
 barrio VARCHAR(50) NOT NULL,
 id_ciudad INT NOT NULL,
 CONSTRAINT pk_barrio PRIMARY KEY(id_barrio),
 CONSTRAINT fk_ciudad_barrio FOREIGN KEY(id_ciudad) REFERENCES
ciudades(id_ciudad));

CREATE TABLE autores (
 id_autor INT IDENTITY,
 nombre VARCHAR(50) NOT NULL,
 apellido VARCHAR(50) NOT NULL,
 biografia VARCHAR(200),
 fecha_nacimiento DATE,
 id_nacionalidad INT NOT NULL,
 id_sexo INT NOT NULL,
 CONSTRAINT pk_autor PRIMARY KEY (id_autor),
 CONSTRAINT fk_autor_nacionalidad FOREIGN KEY(id_nacionalidad) REFERENCES
nacionalidades(id_nacionalidad),
 CONSTRAINT fk_autor_sexo FOREIGN KEY(id_sexo) REFERENCES sexos(id_sexo));

CREATE TABLE clientes (
 cod_cliente INT IDENTITY,
 nombre VARCHAR(50) NOT NULL,
 apellido VARCHAR(50) NOT NULL,
 nro_doc INT NOT NULL,
 contraseña VARCHAR(20) NOT NULL,
 id_tipo_doc INT NOT NULL,
 id_sexo INT NOT NULL,
 id_nacionalidad INT NOT NULL,
 fecha_registro DATETIME NOT NULL,
fecha_nacimiento DATE,
id_barrio int not null,
    calle VARCHAR(50) NOT NULL,
    nro INT NOT NULL,
    piso VARCHAR(10),
    dpto VARCHAR(10),
    cp VARCHAR(10),
 CONSTRAINT pk_cliente PRIMARY KEY(cod_cliente),
 CONSTRAINT fk_cliente_tiposdoc FOREIGN KEY(id_tipo_doc) REFERENCES
tipos_documentos(id_tipo_doc),
CONSTRAINT fk_cliente_sexo FOREIGN KEY(id_sexo) REFERENCES sexos(id_sexo),
 CONSTRAINT fk_cliente_nacionalidad FOREIGN KEY(id_nacionalidad) REFERENCES
nacionalidades(id_nacionalidad),
 CONSTRAINT fk_cliente_barrio FOREIGN KEY(id_barrio) REFERENCES
barrios(id_barrio));

CREATE TABLE contactos (
 id_contacto INT IDENTITY,
 contacto VARCHAR(50),
 id_tipo_contacto INT,
 cod_cliente INT,
 CONSTRAINT pk_contacto PRIMARY KEY(id_contacto),
 CONSTRAINT fk_contactos_tipos FOREIGN KEY(id_tipo_contacto) REFERENCES
tipos_contactos(id_tipo_contacto),
 CONSTRAINT fk_contactos_clientes FOREIGN KEY(cod_cliente) REFERENCES
clientes(cod_cliente));


CREATE TABLE facturas (
 nro_factura INT,
 fecha DATETIME NOT NULL,
 fecha_entrega DATETIME NOT NULL,
 fecha_pago DATETIME NOT NULL,
 cod_cliente INT NOT NULL,
 id_forma_envio INT NOT NULL,
costo_envio DECIMAL(10,2),
 CONSTRAINT pk_factura PRIMARY KEY(nro_factura),
 CONSTRAINT fk_facturas_clientes FOREIGN KEY(cod_cliente) REFERENCES
clientes(cod_cliente),
 CONSTRAINT fk_facturas_formasenvio FOREIGN KEY(id_forma_envio) REFERENCES
formas_envios(id_forma_envio));

CREATE TABLE facturas_formaspago (
 id_factura_pago INT IDENTITY,
 monto_parcial DECIMAL(10,2) NOT NULL,
 id_forma_pago INT NOT NULL,
 nro_factura INT NOT NULL,
 CONSTRAINT pk_facturas_formaspago PRIMARY KEY(id_factura_pago),
 CONSTRAINT fk_facturas_pagos FOREIGN KEY(id_forma_pago) REFERENCES
formas_pagos(id_forma_pago),
 CONSTRAINT fk_facturas_factura FOREIGN KEY(nro_factura) REFERENCES
facturas(nro_factura));

CREATE TABLE formapagos_clientes (
 id_formapago_cliente INT IDENTITY,
 num_tarjeta INT,
 fecha_vencimiento DATE,
 cvv INT,
 cod_cliente INT NOT NULL,
 id_forma_pago INT NOT NULL,
 id_financiera INT NOT NULL,
 CONSTRAINT pk_formapagos_clientes PRIMARY KEY (id_formapago_cliente),
 CONSTRAINT fk_financieras FOREIGN KEY(id_financiera) REFERENCES
financieras(id_financiera),
 CONSTRAINT fk_clientes FOREIGN KEY(cod_cliente) REFERENCES clientes(cod_cliente),
 CONSTRAINT fk_formaspago FOREIGN KEY(id_forma_pago) REFERENCES
formas_pagos(id_forma_pago));

CREATE TABLE idiomas (
 id_idioma INT IDENTITY,
 idioma VARCHAR(50) NOT NULL,
 CONSTRAINT pk_idioma PRIMARY KEY (id_idioma));

CREATE TABLE libros (
 cod_libro INT IDENTITY,
 isbn VARCHAR(50) NOT NULL,
 titulo VARCHAR(50) NOT NULL,
 precio DECIMAL(10,2) NOT NULL,
 descripcion VARCHAR(200),
 stock INT NOT NULL,
id_editorial INT NOT NULL,
fecha_lanzamiento date NOT NULL,
id_idioma int not null,
CONSTRAINT pk_libro PRIMARY KEY (cod_libro),
 CONSTRAINT fk_libros_editoriales FOREIGN KEY(id_editorial) REFERENCES
editoriales(id_editorial),
CONSTRAINT fk_libros_idiomas FOREIGN KEY(id_idioma) REFERENCES
idiomas(id_idioma));

CREATE TABLE libros_generos(
id_libro_genero int NOT NULL,
id_libro int NOT NULL,
id_genero int NOT NULL,
constraint Pk_libro_genero primary key (id_libro_genero),
constraint fk_librosgeneros foreign key (id_libro) references Libros (cod_libro),
constraint fk_generoslibros foreign key (id_genero) references Generos (id_genero));

CREATE TABLE detalle_facturas (
 id_detalle_factura INT IDENTITY,
 cantidad INT NOT NULL,
 precio DECIMAL(10,2) NOT NULL,
 recargo DECIMAL(10,2),
 nro_factura INT NOT NULL,
 cod_libro INT NOT NULL,
 CONSTRAINT pk_detalle_fac PRIMARY KEY (id_detalle_factura),
 CONSTRAINT fk_detalle_factura FOREIGN KEY(nro_factura) REFERENCES
facturas(nro_factura),
 CONSTRAINT fk_detalle_libro FOREIGN KEY(cod_libro) REFERENCES libros(cod_libro));


CREATE TABLE pedidos (
 nro_pedido INT IDENTITY,
 fecha DATETIME NOT NULL,
 fecha_entrega DATE NOT NULL,
 instrucciones_adicionales VARCHAR(100),
 cod_cliente INT NOT NULL,
 id_forma_envio INT NOT NULL,
 CONSTRAINT pk_nro_pedido PRIMARY KEY (nro_pedido),
 CONSTRAINT fk_pedidos_clientes FOREIGN KEY(cod_cliente) REFERENCES
clientes(cod_cliente),
 CONSTRAINT fk_pedidos_formas FOREIGN KEY(id_forma_envio) REFERENCES
formas_envios(id_forma_envio));

CREATE TABLE detalle_pedidos (
 id_detalle_pedido INT IDENTITY,
 cantidad INT NOT NULL,
 precio DECIMAL(10,2) NOT NULL,
 cod_libro INT NOT NULL,
 nro_pedido INT NOT NULL,
 CONSTRAINT pk_detalle_pedidos PRIMARY KEY (id_detalle_pedido),
 CONSTRAINT fk_detallepedidos_libros FOREIGN KEY(cod_libro) REFERENCES
libros(cod_libro),
 CONSTRAINT fk_detallepedidos_pedido FOREIGN KEY(nro_pedido) REFERENCES
pedidos(nro_pedido));

CREATE TABLE tracking_envios (
 id_tracking INT PRIMARY KEY IDENTITY,
 nro_pedido INT NOT NULL,
 id_estado_envio INT NOT NULL,
 fecha_estado DATETIME NOT NULL,
 observaciones VARCHAR(200),
 CONSTRAINT fk_tracking_pedido FOREIGN KEY(nro_pedido) REFERENCES
pedidos(nro_pedido),
 CONSTRAINT fk_tracking_estado FOREIGN KEY(id_estado_envio) REFERENCES
estados_envios(id_estado_envio));

CREATE TABLE libros_categorias (
id_libro_categoria int NOT NULL,
id_libro int NOT NULL,
id_categoria int NOT NULL,
CONSTRAINT pk_libro_categoria primary key (id_libro_categoria),
CONSTRAINT fk_libros_categoria foreign key (id_libro) references Libros (cod_libro),
CONSTRAINT fk_categorias_libros foreign key (id_categoria) references Categorias
(id_categoria));

CREATE TABLE autores_libros(
id_autor_libro int NOT NULL,
id_libro int NOT NULL,
id_autor int NOT NULL,
constraint pk_autor_libro primary key (id_autor_libro),
constraint fk_librosAutores foreign key (id_libro) references Libros (cod_libro),
constraint fk_autor foreign key (id_autor) references Autores (id_autor));

INSERT INTO provincias (provincia) VALUES 
('Buenos Aires'), ('Córdoba'), ('Santa Fe');

INSERT INTO ciudades (ciudad, id_provincia) VALUES
('CABA', 1), ('Rosario', 3), ('Córdoba Capital', 2);

INSERT INTO barrios (barrio, id_ciudad) VALUES
('Palermo', 1), ('Recoleta', 1), ('Centro', 2), ('Nueva Córdoba', 3);

INSERT INTO sexos (sexo) VALUES 
('Masculino'), ('Femenino');

INSERT INTO tipos_documentos (tipo) VALUES 
('DNI'), ('Pasaporte');

INSERT INTO nacionalidades (nacionalidad) VALUES 
('Argentina'), ('Uruguaya'), ('Chilena'), ('Colombiana'), ('Estadounidense'), ('Mexicana'), ('Alemana'), ('Japonesa'), ('Rusa'), ('Brasileña'), ('Italiana');

INSERT INTO autores (nombre, apellido, biografia, fecha_nacimiento, id_nacionalidad, id_sexo) VALUES
('Gabriel', 'García Márquez', 'Escritor colombiano reconocido por El Amor en los Tiempos del Cólera', '06/03/1927', 2, 1),
('Isabel', 'Allende', 'Escritora chilena conocida por La Casa de los Espíritus', '02/08/1942', 3, 2),
('Julio', 'Cortázar', 'Escritor argentino, figura central del boom latinoamericano, autor de "Rayuela".', '1914/08/26', 1, 1),
('Jane', 'Austen', 'Novelista inglesa, una de las autoras más influyentes de la literatura, célebre por "Orgullo y prejuicio".', '1775/12/16', 4, 2),
('Jorge Luis', 'Borges', 'Escritor y poeta argentino, uno de los mayores referentes de la literatura universal del siglo XX.', '1899/08/24', 1, 1),
('Mary', 'Shelley', 'Escritora inglesa, autora de la novela gótica "Frankenstein o el moderno Prometeo".', '1797/08/30', 5, 2),
('Mario', 'Vargas Llosa', 'Escritor estadounidense, Premio Nobel de Literatura 2010, autor de "La ciudad y los perros".', '1936/03/28', 5, 1),
('Emily', 'Dickinson', 'Poetisa estadounidense considerada una de las más influyentes de la literatura anglosajona.', '1830/12/10', 5, 2),
('Franz', 'Kafka', 'Escritor checo en lengua alemana, célebre por obras como "La metamorfosis".', '1883/07/03', 7, 1),
('Virginia', 'Woolf', 'Escritora británica, pionera del modernismo literario del siglo XX, autora de "La señora Dalloway".', '1882/01/25', 4, 2),
('Haruki', 'Murakami', 'Novelista japonés contemporáneo, reconocido por obras como "Tokio Blues" y "Kafka en la orilla".', '1949/01/12', 8, 1),
('León', 'Tolstói', 'Escritor ruso, uno de los más importantes de la literatura mundial, autor de "Guerra y paz".', '1828/09/09', 9, 1),
('Clarice', 'Lispector', 'Escritora brasileña, destacada por su estilo introspectivo y novelas como "La hora de la estrella".', '1920/12/10', 10, 2),
('Umberto', 'Eco', 'Escritor y filósofo italiano, autor de "El nombre de la rosa".', '1932/01/05', 11, 1),
('Sor', 'Juana Inés de la Cruz', 'Poetisa y filósofa mexicana del Siglo de Oro, considerada una de las más grandes escritoras en lengua española.', '1648/11/12',6 , 2);

INSERT INTO clientes (nombre, apellido, nro_doc, contraseña, id_tipo_doc, id_sexo, id_nacionalidad, fecha_registro, fecha_nacimiento, id_barrio, calle, nro, piso, dpto, cp)
VALUES
('Juan', 'Pérez', 12345678, 'pass123', 1, 1, 1, '2025-08-01', '1990-05-12', 1, 'Córdoba', 123, '1', 'A', '5000'),
('María', 'Gómez', 23456789, 'pass234', 1, 2, 1, '2025-08-02', '1985-11-22', 2, 'Rivadavia', 456, NULL, NULL, '5001'),
('Luis', 'Fernández', 34567890, 'pass345', 1, 1, 1, '2025-08-03', '1992-07-15', 3, 'San Martín', 789, '2', 'B', '5002'),
('Ana', 'Martínez', 45678901, 'pass456', 1, 2, 1, '2025-08-04', '1988-03-10', 1, 'Maipú', 101, '1', 'C', '5003'),
('Carlos', 'Rodríguez', 56789012, 'pass567', 1, 1, 1, '2025-08-05', '1991-12-05', 2, 'Belgrano', 202, NULL, NULL, '5004'),
('Sofía', 'López', 67890123, 'pass678', 1, 2, 1, '2025-08-06', '1993-08-20', 3, 'Mitre', 303, '2', 'D', '5005'),
('Diego', 'Sánchez', 78901234, 'pass789', 1, 1, 1, '2025-08-07', '1987-04-15', 1, 'Lavalle', 404, NULL, NULL, '5006'),
('Lucía', 'Torres', 89012345, 'pass890', 1, 2, 1, '2025-08-08', '1995-11-30', 2, 'Entre Ríos', 505, '3', 'A', '5007'),
('Martín', 'Ramírez', 90123456, 'pass901', 1, 1, 1, '2025-08-09', '1989-06-25', 3, 'Urquiza', 606, NULL, NULL, '5008'),
('Valentina', 'García', 12345012, 'pass012', 1, 2, 1, '2025-08-10', '1994-02-17', 1, 'Sarmiento', 707, '1', 'B', '5009');

INSERT INTO tipos_contactos (tipo) VALUES 
('Email'), ('Teléfono'), ('WhatsApp');

INSERT INTO contactos (contacto, id_tipo_contacto, cod_cliente) VALUES
('juan.perez@email.com', 1, 1),
('1122334455', 2, 1),
('maria.gomez@email.com', 1, 2),
('5544332211', 2, 2);

INSERT INTO editoriales (editorial) VALUES 
('Editorial Sudamericana'), ('Planeta'), ('Penguin Random House');

INSERT INTO idiomas (idioma) VALUES
('Español'), ('Inglés');

INSERT INTO libros (isbn, titulo, precio, descripcion, stock, id_editorial, fecha_lanzamiento, id_idioma) VALUES
('978/9876543210', 'Aprendiendo C#', 1200.00, 'Guía completa de programación en C#', 10, 1, '15/01/2025', 1),
('978/1234567890', 'SQL Server Avanzado', 1500.00, 'Optimización y procedimientos almacenados', 5, 2, '10/08/2021', 1),
('978/9871234567', 'Diseño de Bases de Datos', 900.00, 'Modelado y normalización de datos', 8, 3, '20/05/2020', 1),
('978/4567891230', 'Java desde cero', 1100.00, 'Aprenda Java paso a paso', 12, 1, '05/11/2019', 1),
('978/3216549870', 'Python para científicos', 1300.00, 'Aplicaciones científicas con Python', 7, 2, '12/07/2025', 1),
('978/6549873210', 'Fundamentos de HTML5', 700.00, 'Curso práctico de HTML5', 15, 3, '20/02/2018', 1),
('978/7891234560', 'CSS y diseño web', 800.00, 'Aprenda CSS moderno', 9, 1, '18/03/2019', 1),
('978/1472583690', 'JavaScript Avanzado', 950.00, 'Programación avanzada en JS', 11, 2, '25/09/2021', 1),
('978/3692581470', 'React para principiantes', 1050.00, 'Construyendo aplicaciones con React', 6, 3, '01/12/2025', 1),
('978/1597534860', 'Angular en acción', 1150.00, 'Framework Angular paso a paso', 8, 1, '22/04/2021', 1),
('978/7531594860', 'Node.js desde cero', 1250.00, 'Servidor y backend con Node.js', 10, 2, '30/10/2020', 1),
('978/9517534862', 'Aprende Django', 1400.00, 'Desarrollo web con Django', 5, 3, '15/06/2021', 1),
('978/8529637410', 'Inteligencia Artificial', 2000.00, 'Conceptos de IA y machine learning', 4, 1, '10/02/2025', 1),
('978/1478523690', 'Algoritmos y estructuras', 1100.00, 'Estructuras de datos y algoritmos', 9, 2, '05/07/2019', 1),
('978/9638527410', 'Big Data práctico', 1750.00, 'Manejo de grandes volúmenes de datos', 7, 3, '28/03/2025', 1),
('978/7418529630', 'Seguridad informática', 1300.00, 'Protección de sistemas y redes', 6, 1, '15/01/2021', 1),
('978/2587413690', 'Git y GitHub', 600.00, 'Control de versiones práctico', 20, 2, '10/08/2018', 1),
('978/3691472580', 'Docker y contenedores', 1250.00, 'Despliegue de aplicaciones con Docker', 8, 3, '22/11/2020', 1),
('978/1479632580', 'Kubernetes en acción', 1550.00, 'Orquestación de contenedores', 5, 1, '15/09/2021', 1),
('978/2583691470', 'Programación Funcional', 1000.00, 'Conceptos de programación funcional', 12, 2, '10/05/2019', 1),
('978/001', 'C# Avanzado', 1200, 'C# avanzado para programadores', 10, 1, '10/01/2021', 1),
('978/002', 'SQL Server 2019', 1500, 'Administración y optimización', 8, 2, '20/05/2020', 1),
('978/003', 'HTML5 y CSS3', 900, 'Diseño web moderno', 12, 3, '15/08/2020', 1),
('978/004', 'Python Data Science', 1300, 'Análisis de datos con Python', 6, 1, '05/03/2021', 1),
('978/005', 'ReactJS Básico', 1100, 'Introducción a React', 9, 2, '22/02/2025', 1);

INSERT INTO categorias (categoria) VALUES 
('Ficción'), ('No Ficción'), ('Romance'), ('Ciencia');

INSERT INTO generos (genero) VALUES 
('Romance'), ('Aventura'), ('Ciencia Ficción'), ('Histórico');

INSERT INTO autores_libros (id_autor_libro, id_libro, id_autor) VALUES
(1, 1, 1),
(2, 2, 2);

INSERT INTO libros_generos (id_libro_genero, id_libro, id_genero) VALUES
(1, 1, 1), 
(2, 2, 1); 

INSERT INTO libros_categorias (id_libro_categoria, id_libro, id_categoria) VALUES
(1, 1, 1),
(2, 2, 1); 

INSERT INTO formas_pagos (forma_pago) VALUES 
('Tarjeta de Crédito'), ('Tarjeta de Débito'), ('Mercado Pago'), ('Efectivo');

INSERT INTO financieras (nombre) VALUES 
('Banco Nación'), ('Banco Galicia'), ('Banco Macro');

INSERT INTO formapagos_clientes (num_tarjeta, fecha_vencimiento, cvv, cod_cliente, id_forma_pago, id_financiera) VALUES
(12345678, '01/01/2026', 123, 1, 1, 1),
(98765432, '01/12/2025', 456, 2, 1, 2);

INSERT INTO formas_envios (forma_envio) VALUES 
('Correo Argentino'), ('OCA'), ('Andreani');

INSERT INTO estados_envios (estado_actual) VALUES 
('Recibido'), ('Preparando'), ('Enviado'), ('Entregado');

SET DATEFORMAT DMY;

INSERT INTO pedidos (fecha, fecha_entrega, instrucciones_adicionales, cod_cliente, id_forma_envio) VALUES
('01/08/2025', '05/08/2025', 'Entregar en horario de oficina', 1, 1),
('02/08/2025', '06/08/2025', 'Llamar antes de entregar', 2, 2),
('08/08/2025', '12/08/2025', 'Entregar solo a nombre del cliente', 8, 1),
('09/08/2025', '13/08/2025', 'Llamar al llegar', 3, 2),
('10/08/2025', '14/08/2025', 'Dejar en recepción', 4, 3),
('11/08/2025', '15/08/2025', 'Entregar entre 10:00 y 12:00', 5, 1),
('12/08/2025', '16/08/2025', 'No dejar en la puerta', 6, 2),
('13/08/2025', '17/08/2025', 'Si no hay nadie, devolver al depósito', 7, 3),
('14/08/2025', '18/08/2025', 'Contactar por teléfono antes de entregar', 8, 1),
('15/08/2025', '19/08/2025', 'Dejar con portero si no hay nadie', 9, 2),
('16/08/2025', '20/08/2025', 'Entregar en horario de oficina', 10, 3),
('17/08/2025', '21/08/2025', 'Si no hay nadie, avisar por email', 10, 1),
('18/08/2025', '22/08/2025', 'Llamar antes de entregar', 1, 2),
('19/08/2025', '23/08/2025', 'Entregar después de las 17:00', 2, 3),
('20/08/2025', '24/08/2025', 'Dejar con conserje', 3, 1),
('21/08/2025', '25/08/2025', 'Contactar por WhatsApp antes de entregar', 4, 2),
('22/08/2025', '26/08/2025', 'Si no hay nadie, dejar en la esquina', 5, 3),
('23/08/2025', '27/08/2025', 'Entregar solo si hay alguien en casa', 6, 1),
('24/08/2025', '28/08/2025', 'Avisar por teléfono antes de entregar', 7, 2),
('25/08/2025', '29/08/2025', 'Entregar entre 14:00 y 16:00', 8, 3),
('26/08/2025', '30/08/2025', 'Dejar en portería si no hay nadie', 9, 1),
('27/08/2025', '31/08/2025', 'Llamar al llegar', 10, 2);

INSERT INTO detalle_pedidos (cantidad, precio, cod_libro, nro_pedido) VALUES
(1, 300, 2, 1),
(3, 150, 3, 2),
(1, 450, 4, 3),
(2, 200, 5, 3),
(1, 1500, 2, 1),
(3, 900, 3, 2),   
(1, 1100, 4, 2),
(2, 1300, 5, 3),  
(1, 700, 1, 3),
(1, 800, 2, 4),  
(2, 950, 3, 5);
SET DATEFORMAT DMY;

INSERT INTO facturas (nro_factura, fecha, fecha_entrega, fecha_pago, cod_cliente, id_forma_envio, costo_envio) VALUES
(2, '02/08/2025', '06/08/2025', '02/08/2025', 2, 2, 250),
(3, '03/08/2025', '07/08/2025', '03/08/2025', 3, 1, 220),
(4, '04/08/2025', '08/08/2025', '04/08/2025', 1, 2, 210),
(5, '05/08/2025', '09/08/2025', '05/08/2025', 2, 1, 230),
(8, '08/08/2025', '12/08/2025', '08/08/2025', 2, 2, 250),
(9, '09/08/2025', '13/08/2025', '09/08/2025', 3, 1, 220),
(10, '10/08/2025', '14/08/2025', '10/08/2025', 1, 2, 210),
(11, '11/08/2025', '15/08/2025', '11/08/2025', 2, 1, 230),
(14, '14/08/2025', '18/08/2025', '14/08/2025', 2, 2, 250),
(15, '15/08/2025', '19/08/2025', '15/08/2025', 3, 1, 220),
(16, '16/08/2025', '20/08/2025', '16/08/2025', 1, 2, 210),
(17, '17/08/2025', '21/08/2025', '17/08/2025', 2, 1, 230),
(20, '20/08/2025', '24/08/2025', '20/08/2025', 2, 2, 250),
(21, '21/08/2025', '25/08/2025', '21/08/2025', 3, 1, 220),
(22, '22/08/2025', '26/08/2025', '22/08/2025', 1, 2, 210),
(23, '23/08/2025', '27/08/2025', '23/08/2025', 2, 1, 230),
(26, '26/08/2025', '30/08/2025', '26/08/2025', 2, 2, 250),
(27, '27/08/2025', '31/08/2025', '27/08/2025', 3, 1, 220),
(28, '28/08/2025', '01/09/2025', '28/08/2025', 1, 2, 210),
(29, '29/08/2025', '02/09/2025', '29/08/2025', 2, 1, 230),
(32, '01/09/2025', '05/09/2025', '01/09/2025', 2, 2, 250),
(33, '02/09/2025', '06/09/2025', '02/09/2025', 3, 1, 220),
(34, '03/09/2025', '07/09/2025', '03/09/2025', 1, 2, 210),
(35, '04/09/2025', '08/09/2025', '04/09/2025', 2, 1, 230),
(38, '07/09/2025', '11/09/2025', '07/09/2025', 2, 2, 250),
(39, '08/09/2025', '12/09/2025', '08/09/2025', 3, 1, 220),
(40, '09/09/2025', '13/09/2025', '09/09/2025', 1, 2, 210),
(41, '10/09/2025', '14/09/2025', '10/09/2025', 2, 1, 230),
(12086, '10/08/2020', '12/08/2020', '11/08/2020', 2, 2, 180),
(12087, '15/01/2021', '18/01/2021', '16/01/2021', 3, 1, 150),
(12088, '20/02/2021', '23/02/2021', '21/02/2021', 1, 2, 160),
(12089, '05/03/2025', '08/03/2025', '06/03/2025', 2, 1, 200),
(12090, '12/04/2025', '15/04/2025', '13/04/2025', 3, 2, 180);

INSERT INTO detalle_facturas (cantidad, precio, recargo, nro_factura, cod_libro) VALUES
(2, 1200, 100, 2, 2),
(1, 1300, 50, 3, 3),
(2, 1400, 0, 4, 1),
(1, 1200, 20, 5, 2),
(3, 1500, 0, 8, 3),
(2, 1600, 100, 9, 1),
(1, 1700, 50, 8, 2),
(2, 1400, 0, 9, 3),
(1, 1300, 30, 10, 1),
(2, 1500, 0, 11, 2),
(1, 1600, 20, 14, 3),
(3, 1700, 0, 20, 1),
(2, 1400, 50, 14, 2),
(1, 1300, 0, 15, 3),
(2, 1500, 30, 16, 1),
(1, 1600, 0, 17, 2),
(2, 1700, 20, 21, 3),
(1, 1400, 0, 12090, 1),
(2, 1300, 50, 12090, 2),
(1, 1500, 0, 12086, 3),
(3, 1600, 20, 22, 1),
(2, 1700, 0, 23, 2),
(1, 1400, 50, 23, 3),
(2, 1300, 0, 23, 1),
(1, 1500, 30, 26, 2),
(2, 1600, 0, 27, 3),
(1, 1700, 50, 28, 1),
(2, 1400, 0, 29, 2),
(1, 1600, 50, 32, 2),
(2, 1700, 0, 33, 3),
(1, 1400, 30, 34, 1),
(2, 1300, 0, 35, 2),
(2, 1600, 0, 38, 1),
(1, 1700, 20, 38, 2),
(2, 1400, 0, 39, 3),
(1, 1300, 50, 40, 1),
(2, 1500, 0, 41, 2),
(1, 1300, 0, 34, 16),
(2, 600, 0, 35, 17),
(1, 1250, 0, 39, 18),
(2, 1550, 0,40, 19),
(1, 1000, 0, 41, 20);

INSERT INTO tracking_envios (nro_pedido, id_estado_envio, fecha_estado, observaciones) VALUES
(1, 1, '01/08/2025', 'Pedido recibido'),
(1, 2, '02/08/2025', 'Preparando pedido'),
(2, 1, '02/08/2025', 'Pedido recibido');


-- Nuevos clientes
INSERT INTO clientes (nombre, apellido, nro_doc, contraseña, id_tipo_doc, id_sexo, id_nacionalidad, fecha_registro, fecha_nacimiento, id_barrio, calle, nro, piso, dpto, cp)
VALUES
('Fernando', 'Alvarez', 98765432, 'pass987', 1, 1, 1, '15-08-2025', '10-01-1980', 1, 'Libertador', 800, '2', 'B', '5010'),
('Carolina', 'Rojas', 87654321, 'pass876', 1, 2, 1, '16-08-2025', '22-03-1983', 2, 'Mitre', 900, NULL, NULL, '5011');

-- Formas de pago para los nuevos clientes
INSERT INTO formapagos_clientes (num_tarjeta, fecha_vencimiento, cvv, cod_cliente, id_forma_pago, id_financiera)
VALUES
(11223344, '01-01-2026', 321, 12, 1, 1),
(22334455, '01-01-2026', 654, 13, 1, 2);

-- Pedidos de alto valor
INSERT INTO pedidos (fecha, fecha_entrega, instrucciones_adicionales, cod_cliente, id_forma_envio)
VALUES
('20-08-2025', '25-08-2025', 'Entregar en horario de oficina', 12, 1),
('21-08-2025', '26-08-2025', 'Llamar antes de entregar', 13, 2);

-- Detalle de pedidos con montos altos
INSERT INTO detalle_pedidos (cantidad, precio, cod_libro, nro_pedido)
VALUES
(5, 2000, 13, 25),  -- Fernando
(3, 1750, 16, 26);  -- Carolina

-- Facturas correspondientes
INSERT INTO facturas (nro_factura, fecha, fecha_entrega, fecha_pago, cod_cliente, id_forma_envio, costo_envio)
VALUES
(12091, '20-08-2025', '25-08-2025', '20-08-2025', 12, 1, 300),
(12092, '21-08-2025', '26-08-2025', '21-08-2025', 13, 2, 250);

-- Detalle de facturas
INSERT INTO detalle_facturas (cantidad, precio, recargo, nro_factura, cod_libro)
VALUES
(5, 2000, 100, 12091, 13),  -- Fernando
(3, 1750, 50, 12092, 16);   -- Carolina


-- Clientes
INSERT INTO clientes (nombre, apellido, nro_doc, contraseña, id_tipo_doc, id_sexo, id_nacionalidad, fecha_registro, fecha_nacimiento, id_barrio, calle, nro)
VALUES 
('Juan', 'Pérez', '12345678', 'pass123', 1, 1, 1, '01/01/2025', '15/05/1990', 1, 'Calle Falsa', '123'),
('María', 'Gómez', '23456789', 'pass456', 1, 2, 1, '02/01/2025', '20/06/1985', 2, 'Av. Siempre Viva', '456'),
('Carlos', 'López', '34567890', 'pass789', 2, 1, 1, '03/01/2025', '10/09/1992', 3, 'Calle Luna', '789'),
('Lucía', 'Fernández', '45678901', 'pass321', 1, 2, 1, '04/01/2025', '05/03/1995', 2, 'Av. del Sol', '101'),
('Miguel', 'Santos', '56789012', 'pass654', 2, 1, 1, '05/01/2025', '12/12/1988', 3, 'Calle Estrella', '202');

select * from facturas;
-- Facturas
INSERT INTO facturas (nro_factura, fecha, fecha_entrega, fecha_pago, cod_cliente, id_forma_envio, costo_envio)
VALUES
(42, '01/08/2025', '05/08/2025', '01/08/2025', 1, 1, 200),
(43, '02/08/2025', '06/08/2025', '02/08/2025', 2, 1, 150),
(44, '03/08/2025', '07/08/2025', '03/08/2025', 3, 2, 180),
(45, '04/08/2025', '08/08/2025', '04/08/2025', 4, 1, 200),
(46, '05/08/2025', '09/08/2025', '05/08/2025', 5, 2, 170);


-- Detalle de Facturas

INSERT INTO detalle_facturas (nro_factura, cod_libro, cantidad, precio)
VALUES
(42, 1, 2, 500),
(43, 2, 1, 300),
(44, 1, 1, 500),
(45, 3, 2, 400),
(46, 2, 3, 300),
(3, 3, 1, 400),
(4, 4, 2, 250),
(4, 5, 1, 350),
(5, 1, 1, 500),
(5, 5, 2, 350);


SELECT  
    p.nro_pedido,
    c.nombre + ' ' + c.apellido AS Cliente,
    CONVERT(VARCHAR(10), p.fecha, 103) AS FechaPedido,
    CONVERT(VARCHAR(10), p.fecha_entrega, 103) AS FechaPrevista,
    es.estado_actual AS EstadoActual,
    DATEDIFF(DAY, p.fecha_entrega, GETDATE()) AS DiasRetraso,
    SUM(dp.cantidad * dp.precio) AS TotalEstimado,
    te.fecha_estado AS UltimaActualizacion
FROM pedidos p
JOIN clientes c ON p.cod_cliente = c.cod_cliente
JOIN detalle_pedidos dp ON p.nro_pedido = dp.nro_pedido
JOIN tracking_envios te ON te.id_tracking = (
    SELECT TOP 1 id_tracking FROM tracking_envios t2 
    WHERE t2.nro_pedido =  p.nro_pedido ORDER BY t2.fecha_estado DESC
)
JOIN estados_envios es ON te.id_estado_envio = es.id_estado_envio
WHERE es.estado_actual != 'Entregado' AND p.fecha_entrega < GETDATE()
GROUP BY p.nro_pedido, c.nombre, c.apellido, p.fecha, p.fecha_entrega, es.estado_actual, te.fecha_estado
ORDER BY DiasRetraso DESC;


SELECT  
    c.cod_cliente,
    c.apellido + ' ' + c.nombre AS Cliente,
    COUNT(DISTINCT f.nro_factura) AS CantidadCompras,
    SUM(d.cantidad * d.precio) AS TotalGastado,
    (
        SELECT TOP 1 l.titulo  
        FROM libros l
        JOIN detalle_facturas d2 ON l.cod_libro = d2.cod_libro 
        JOIN facturas f2 ON d2.nro_factura = f2.nro_factura 
        WHERE f2.cod_cliente = c.cod_cliente 
        GROUP BY l.titulo 
        ORDER BY SUM(d2.cantidad * d2.precio) DESC
    ) AS LibroMasComprado
FROM clientes c
JOIN facturas f ON c.cod_cliente = f.cod_cliente
JOIN detalle_facturas d ON f.nro_factura = d.nro_factura
GROUP BY c.cod_cliente, c.apellido, c.nombre
HAVING SUM(d.cantidad * d.precio) > (
    SELECT AVG(total) FROM (
        SELECT SUM(d2.cantidad * d2.precio) AS total
        FROM facturas f2 
        JOIN detalle_facturas d2 ON f2.nro_factura = d2.nro_factura
        GROUP BY f2.cod_cliente
    ) AS totales
)
ORDER BY TotalGastado DESC;


SELECT 
    E.editorial AS Editorial, 
    C.categoria AS Categoría, 
    YEAR(F.fecha) AS Año, 
    MONTH(F.fecha) AS Mes,
    COUNT(DISTINCT F.nro_factura) AS CantFacturas, 
    SUM(DF.cantidad) AS CantVendidas,
    SUM(DF.cantidad * DF.precio) AS ImporteTotal, 
    AVG(DF.precio * 1.0) AS PrecioPromedio,
    MIN(CAST(F.fecha AS DATE)) AS PrimeraVenta, 
    MAX(CAST(F.fecha AS DATE)) AS ÚltimaVenta
FROM facturas F
JOIN detalle_facturas DF ON F.nro_factura = DF.nro_factura
JOIN libros L ON DF.cod_libro = L.cod_libro
JOIN editoriales E ON L.id_editorial = E.id_editorial
JOIN idiomas I ON L.id_idioma = I.id_idioma
JOIN libros_categorias LC ON L.cod_libro = LC.id_libro
JOIN categorias C ON LC.id_categoria = C.id_categoria
WHERE I.idioma = 'Español'
  AND F.fecha >= '2020-07-01' 
  AND F.fecha < DATEFROMPARTS(YEAR(GETDATE()), MONTH(GETDATE()), 1)
  AND L.stock > 0
GROUP BY E.editorial, C.categoria, YEAR(F.fecha), MONTH(F.fecha)
HAVING AVG(DF.precio * 1.0) < (
  SELECT AVG(DF2.precio * 1.0)
  FROM facturas F2 
  JOIN detalle_facturas DF2 ON DF2.nro_factura = F2.nro_factura
  JOIN libros L2 ON L2.cod_libro = DF2.cod_libro 
  JOIN idiomas I2 ON I2.id_idioma = L2.id_idioma
  WHERE I2.idioma = 'Español' AND L2.stock > 0 
    AND YEAR(F2.fecha) = YEAR(F.fecha) 
    AND MONTH(F2.fecha) = MONTH(F.fecha)
)
ORDER BY [Año] DESC, [Mes], [Editorial];



IF OBJECT_ID('tempdb..#GastoClientes') IS NOT NULL DROP TABLE #GastoClientes;
SELECT  
    c.cod_cliente, 
    c.apellido + ' ' + c.nombre AS Cliente, 
    SUM(dp.cantidad * dp.precio) AS TotalGastado
INTO #GastoClientes
FROM clientes c
JOIN pedidos p ON c.cod_cliente = p.cod_cliente
JOIN detalle_pedidos dp ON p.nro_pedido = dp.nro_pedido
WHERE YEAR(p.fecha) = YEAR(GETDATE())
GROUP BY c.cod_cliente, c.apellido, c.nombre;

SELECT cod_cliente, Cliente, TotalGastado
FROM #GastoClientes
WHERE TotalGastado > ( SELECT AVG(TotalGastado) FROM #GastoClientes )
ORDER BY TotalGastado DESC;