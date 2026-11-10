-- Datos de la tienda para los labs de la semana 14: clientes y sus pedidos.
-- Se puede cargar las veces que quieras: empieza borrando las tablas si ya existen.
SET client_min_messages = warning;
DROP TABLE IF EXISTS pedidos;
DROP TABLE IF EXISTS clientes;

CREATE TABLE clientes (
  id     integer PRIMARY KEY,
  nombre text NOT NULL,
  ciudad text NOT NULL
);

CREATE TABLE pedidos (
  id         integer PRIMARY KEY,
  cliente_id integer NOT NULL REFERENCES clientes (id),
  fecha      date NOT NULL,
  total      numeric(8, 2) NOT NULL
);

INSERT INTO clientes VALUES
  (1, 'Ana Torres', 'Madrid'),
  (2, 'Luis Pérez', 'Bogotá'),
  (3, 'Marta Ruiz', 'Lima'),
  (4, 'Jorge Díaz', 'Ciudad de México'),
  (5, 'Sofía León', 'Santiago');

INSERT INTO pedidos VALUES
  (1, 1, '2026-10-01', 25.50),
  (2, 2, '2026-10-02', 110.00),
  (3, 1, '2026-10-03', 8.99),
  (4, 3, '2026-10-05', 42.00),
  (5, 4, '2026-10-06', 15.75),
  (6, 2, '2026-10-08', 64.20),
  (7, 5, '2026-10-09', 230.00),
  (8, 1, '2026-10-11', 12.00),
  (9, 3, '2026-10-12', 77.40),
  (10, 2, '2026-10-15', 5.00),
  (11, 4, '2026-10-18', 99.99),
  (12, 1, '2026-10-20', 48.30);
