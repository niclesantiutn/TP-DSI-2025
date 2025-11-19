-- ========================================
-- SISTEMA DE GESTIÓN HOTELERA - HOTEL PREMIER
-- Script de Inicialización de Base de Datos
-- ========================================

-- ========================================
-- TABLA: conserjes
-- Descripción: Almacena los usuarios del sistema (conserjes) con sus credenciales
-- ========================================
CREATE TABLE IF NOT EXISTS conserjes (
    id BIGSERIAL PRIMARY KEY,
    username VARCHAR(50) NOT NULL UNIQUE,
    password VARCHAR(255) NOT NULL, -- Almacena password hasheado con BCrypt
    role VARCHAR(50) NOT NULL DEFAULT 'ROLE_CONSERJE',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Índice para mejorar búsquedas por username
CREATE INDEX idx_conserjes_username ON conserjes(username);

-- Comentarios sobre la tabla:
-- - id: Identificador único autoincrementable
-- - username: Nombre de usuario único para login
-- - password: Contraseña hasheada usando BCrypt (nunca se almacena en texto plano)
-- - role: Rol del usuario para control de acceso (ej: ROLE_CONSERJE, ROLE_ADMIN)
-- - created_at: Fecha de creación del registro
-- - updated_at: Fecha de última actualización

-- ========================================
-- TABLA: paises
-- Descripción: Catálogo de países
-- ========================================
CREATE TABLE IF NOT EXISTS paises (
    id BIGSERIAL PRIMARY KEY,
    nombre VARCHAR(100) NOT NULL UNIQUE
);

-- Índice para mejorar búsquedas por nombre
CREATE INDEX idx_paises_nombre ON paises(nombre);

-- ========================================
-- TABLA: provincias
-- Descripción: Catálogo de provincias/estados
-- ========================================
CREATE TABLE IF NOT EXISTS provincias (
    id BIGSERIAL PRIMARY KEY,
    nombre VARCHAR(100) NOT NULL,
    pais_id BIGINT NOT NULL,
    CONSTRAINT fk_provincias_pais FOREIGN KEY (pais_id) REFERENCES paises(id),
    CONSTRAINT uk_provincias_nombre_pais UNIQUE (nombre, pais_id)
);

-- Índices
CREATE INDEX idx_provincias_nombre ON provincias(nombre);
CREATE INDEX idx_provincias_pais_id ON provincias(pais_id);

-- ========================================
-- TABLA: localidades
-- Descripción: Catálogo de localidades/ciudades
-- ========================================
CREATE TABLE IF NOT EXISTS localidades (
    id BIGSERIAL PRIMARY KEY,
    nombre VARCHAR(100) NOT NULL,
    provincia_id BIGINT NOT NULL,
    CONSTRAINT fk_localidades_provincia FOREIGN KEY (provincia_id) REFERENCES provincias(id),
    CONSTRAINT uk_localidades_nombre_provincia UNIQUE (nombre, provincia_id)
);

-- Índices
CREATE INDEX idx_localidades_nombre ON localidades(nombre);
CREATE INDEX idx_localidades_provincia_id ON localidades(provincia_id);

-- ========================================
-- TABLA: nacionalidades
-- Descripción: Catálogo de nacionalidades
-- ========================================
CREATE TABLE IF NOT EXISTS nacionalidades (
    id BIGSERIAL PRIMARY KEY,
    nombre VARCHAR(100) NOT NULL UNIQUE
);

-- Índice para mejorar búsquedas por nombre
CREATE INDEX idx_nacionalidades_nombre ON nacionalidades(nombre);

-- ========================================
-- TABLA: direcciones
-- Descripción: Direcciones físicas de personas
-- ========================================
CREATE TABLE IF NOT EXISTS direcciones (
    id BIGSERIAL PRIMARY KEY,
    calle VARCHAR(100) NOT NULL,
    numero VARCHAR(5) NOT NULL,
    piso VARCHAR(5),
    departamento VARCHAR(5),
    codigo_postal VARCHAR(4),
    localidad_id BIGINT NOT NULL,
    CONSTRAINT fk_direcciones_localidad FOREIGN KEY (localidad_id) REFERENCES localidades(id)
);

-- Índice para mejorar búsquedas por localidad
CREATE INDEX idx_direcciones_localidad_id ON direcciones(localidad_id);

-- ========================================
-- TABLA: personas (Tabla padre - JOINED inheritance)
-- Descripción: Tabla padre abstracta para huéspedes y responsables de pago
-- ========================================
CREATE TABLE IF NOT EXISTS personas (
    id BIGSERIAL PRIMARY KEY,
    cuit VARCHAR(11),
    telefono VARCHAR(20) NOT NULL,
    info VARCHAR(100),
    direccion_id BIGINT NOT NULL,
    CONSTRAINT fk_personas_direccion FOREIGN KEY (direccion_id) REFERENCES direcciones(id)
);

-- Índices
CREATE INDEX idx_personas_cuit ON personas(cuit);
CREATE INDEX idx_personas_direccion_id ON personas(direccion_id);

-- ========================================
-- TABLA: huespedes (Tabla hija - JOINED inheritance)
-- Descripción: Información específica de los huéspedes del hotel
-- ========================================
CREATE TABLE IF NOT EXISTS huespedes (
    id BIGINT PRIMARY KEY,
    nombre VARCHAR(100) NOT NULL,
    apellido VARCHAR(100) NOT NULL,
    tipo_documento VARCHAR(20),
    documento VARCHAR(8) NOT NULL,
    fecha_nacimiento DATE NOT NULL,
    email VARCHAR(100),
    ocupacion VARCHAR(100) NOT NULL,
    posicion_frente_al_iva VARCHAR(30),
    nacionalidad_id BIGINT NOT NULL,
    CONSTRAINT fk_huespedes_persona FOREIGN KEY (id) REFERENCES personas(id) ON DELETE CASCADE,
    CONSTRAINT fk_huespedes_nacionalidad FOREIGN KEY (nacionalidad_id) REFERENCES nacionalidades(id)
);

-- Índices
CREATE INDEX idx_huespedes_documento ON huespedes(documento);
CREATE INDEX idx_huespedes_email ON huespedes(email);
CREATE INDEX idx_huespedes_nacionalidad_id ON huespedes(nacionalidad_id);
CREATE INDEX idx_huespedes_apellido_nombre ON huespedes(apellido, nombre);

-- ========================================
-- TABLA: responsables_de_pago (Tabla hija - JOINED inheritance)
-- Descripción: Información específica de los responsables de pago
-- ========================================
CREATE TABLE IF NOT EXISTS responsables_de_pago (
    id BIGINT PRIMARY KEY,
    razon_social VARCHAR(200) NOT NULL,
    CONSTRAINT fk_responsables_de_pago_persona FOREIGN KEY (id) REFERENCES personas(id) ON DELETE CASCADE
);

-- Índice para búsquedas por razón social
CREATE INDEX idx_responsables_de_pago_razon_social ON responsables_de_pago(razon_social);

-- Comentarios sobre la estrategia de herencia JOINED:
-- - La tabla 'personas' contiene los atributos comunes (id, cuit, telefono, info, direccion_id)
-- - La tabla 'huespedes' hereda de 'personas' mediante FK en el id
-- - La tabla 'responsables_de_pago' hereda de 'personas' mediante FK en el id
-- - El id en ambas tablas hijas es PK y FK a la vez
-- - ON DELETE CASCADE asegura que al eliminar una persona se eliminen sus registros hijos

-- ========================================
-- TABLA: bancos
-- Descripción: Catálogo de bancos emisores
-- ========================================
CREATE TABLE IF NOT EXISTS bancos (
    id BIGSERIAL PRIMARY KEY,
    nombre VARCHAR(100) NOT NULL UNIQUE
);

-- Índice para mejorar búsquedas por nombre
CREATE INDEX idx_bancos_nombre ON bancos(nombre);

-- ========================================
-- TABLA: items_consumo
-- Descripción: Catálogo de items consumibles (servicios adicionales del hotel)
-- ========================================
CREATE TABLE IF NOT EXISTS items_consumo (
    id BIGSERIAL PRIMARY KEY,
    nombre VARCHAR(100) NOT NULL,
    precio REAL NOT NULL
);

-- Índice para mejorar búsquedas por nombre
CREATE INDEX idx_items_consumo_nombre ON items_consumo(nombre);

-- ========================================
-- TABLA: habitaciones
-- Descripción: Habitaciones del hotel
-- ========================================
CREATE TABLE IF NOT EXISTS habitaciones (
    id BIGSERIAL PRIMARY KEY,
    nombre VARCHAR(5) NOT NULL,
    precio REAL NOT NULL,
    tipo_habitacion VARCHAR(20) NOT NULL,
    estado_habitacion VARCHAR(20) NOT NULL
);

-- Índice para mejorar búsquedas por nombre y estado
CREATE INDEX idx_habitaciones_nombre ON habitaciones(nombre);
CREATE INDEX idx_habitaciones_estado ON habitaciones(estado_habitacion);

-- Comentarios sobre tipos enumerados:
-- tipo_habitacion: SIMPLE, DOBLE, TRIPLE, SUITE
-- estado_habitacion: DISPONIBLE, OCUPADA, MANTENIMIENTO, LIMPIEZA

-- ========================================
-- TABLA: habitaciones_fuera_servicio
-- Descripción: Registro de períodos en que una habitación está fuera de servicio
-- ========================================
CREATE TABLE IF NOT EXISTS habitaciones_fuera_servicio (
    id BIGSERIAL PRIMARY KEY,
    motivo VARCHAR(255) NOT NULL,
    fecha_inicio DATE NOT NULL,
    fecha_fin DATE,
    habitacion_id BIGINT NOT NULL,
    CONSTRAINT fk_habitaciones_fuera_servicio_habitacion FOREIGN KEY (habitacion_id) REFERENCES habitaciones(id)
);

-- Índices
CREATE INDEX idx_habitaciones_fuera_servicio_habitacion_id ON habitaciones_fuera_servicio(habitacion_id);
CREATE INDEX idx_habitaciones_fuera_servicio_fechas ON habitaciones_fuera_servicio(fecha_inicio, fecha_fin);

-- ========================================
-- TABLA: reservas
-- Descripción: Reservas de habitaciones realizadas por huéspedes
-- ========================================
CREATE TABLE IF NOT EXISTS reservas (
    id BIGSERIAL PRIMARY KEY,
    fecha_ingreso DATE NOT NULL,
    fecha_egreso DATE NOT NULL,
    nombre_huesped VARCHAR(100) NOT NULL,
    apellido_huesped VARCHAR(100) NOT NULL,
    telefono_huesped VARCHAR(20) NOT NULL,
    huesped_id BIGINT,
    CONSTRAINT fk_reservas_huesped FOREIGN KEY (huesped_id) REFERENCES huespedes(id)
);

-- Índices
CREATE INDEX idx_reservas_huesped_id ON reservas(huesped_id);
CREATE INDEX idx_reservas_fechas ON reservas(fecha_ingreso, fecha_egreso);
CREATE INDEX idx_reservas_apellido_nombre ON reservas(apellido_huesped, nombre_huesped);

-- ========================================
-- TABLA: reserva_habitaciones
-- Descripción: Tabla de relación many-to-many entre reservas y habitaciones
-- ========================================
CREATE TABLE IF NOT EXISTS reserva_habitaciones (
    reserva_id BIGINT NOT NULL,
    habitacion_id BIGINT NOT NULL,
    PRIMARY KEY (reserva_id, habitacion_id),
    CONSTRAINT fk_reserva_habitaciones_reserva FOREIGN KEY (reserva_id) REFERENCES reservas(id) ON DELETE CASCADE,
    CONSTRAINT fk_reserva_habitaciones_habitacion FOREIGN KEY (habitacion_id) REFERENCES habitaciones(id)
);

-- Índices
CREATE INDEX idx_reserva_habitaciones_reserva_id ON reserva_habitaciones(reserva_id);
CREATE INDEX idx_reserva_habitaciones_habitacion_id ON reserva_habitaciones(habitacion_id);

-- ========================================
-- TABLA: estadias
-- Descripción: Estadías de huéspedes en el hotel
-- ========================================
CREATE TABLE IF NOT EXISTS estadias (
    id BIGSERIAL PRIMARY KEY,
    fecha_hora_ingreso TIMESTAMP NOT NULL,
    fecha_hora_egreso TIMESTAMP,
    huesped_id BIGINT NOT NULL,
    habitacion_id BIGINT NOT NULL,
    reserva_id BIGINT,
    CONSTRAINT fk_estadias_huesped FOREIGN KEY (huesped_id) REFERENCES huespedes(id),
    CONSTRAINT fk_estadias_habitacion FOREIGN KEY (habitacion_id) REFERENCES habitaciones(id),
    CONSTRAINT fk_estadias_reserva FOREIGN KEY (reserva_id) REFERENCES reservas(id)
);

-- Índices
CREATE INDEX idx_estadias_huesped_id ON estadias(huesped_id);
CREATE INDEX idx_estadias_habitacion_id ON estadias(habitacion_id);
CREATE INDEX idx_estadias_reserva_id ON estadias(reserva_id);
CREATE INDEX idx_estadias_fecha_ingreso ON estadias(fecha_hora_ingreso);

-- ========================================
-- TABLA: estadia_huespedes_acompaniantes
-- Descripción: Tabla de relación one-to-many entre estadías y huéspedes acompañantes
-- ========================================
CREATE TABLE IF NOT EXISTS estadia_huespedes_acompaniantes (
    estadia_id BIGINT NOT NULL,
    huesped_id BIGINT NOT NULL,
    PRIMARY KEY (estadia_id, huesped_id),
    CONSTRAINT fk_estadia_acompaniantes_estadia FOREIGN KEY (estadia_id) REFERENCES estadias(id) ON DELETE CASCADE,
    CONSTRAINT fk_estadia_acompaniantes_huesped FOREIGN KEY (huesped_id) REFERENCES huespedes(id)
);

-- Índices
CREATE INDEX idx_estadia_acompaniantes_estadia_id ON estadia_huespedes_acompaniantes(estadia_id);
CREATE INDEX idx_estadia_acompaniantes_huesped_id ON estadia_huespedes_acompaniantes(huesped_id);

-- ========================================
-- TABLA: estadias_items_consumo
-- Descripción: Tabla de relación many-to-many entre estadías e items de consumo
-- ========================================
CREATE TABLE IF NOT EXISTS estadias_items_consumo (
    estadia_id BIGINT NOT NULL,
    item_consumo_id BIGINT NOT NULL,
    PRIMARY KEY (estadia_id, item_consumo_id),
    CONSTRAINT fk_estadias_items_estadia FOREIGN KEY (estadia_id) REFERENCES estadias(id) ON DELETE CASCADE,
    CONSTRAINT fk_estadias_items_item FOREIGN KEY (item_consumo_id) REFERENCES items_consumo(id)
);

-- Índices
CREATE INDEX idx_estadias_items_estadia_id ON estadias_items_consumo(estadia_id);
CREATE INDEX idx_estadias_items_item_id ON estadias_items_consumo(item_consumo_id);

-- ========================================
-- TABLA: facturas
-- Descripción: Facturas emitidas por estadías
-- ========================================
CREATE TABLE IF NOT EXISTS facturas (
    id BIGSERIAL PRIMARY KEY,
    estado_factura VARCHAR(10) NOT NULL,
    numero_habitacion VARCHAR(5),
    fecha_emision DATE NOT NULL,
    fecha_hora_salida TIMESTAMP NOT NULL,
    tipo_factura CHAR(1) NOT NULL,
    valor_estadia REAL NOT NULL,
    monto_total REAL NOT NULL,
    id_responsable_de_pago BIGINT NOT NULL,
    id_estadia BIGINT NOT NULL,
    CONSTRAINT fk_facturas_responsable FOREIGN KEY (id_responsable_de_pago) REFERENCES responsables_de_pago(id),
    CONSTRAINT fk_facturas_estadia FOREIGN KEY (id_estadia) REFERENCES estadias(id)
);

-- Índices
CREATE INDEX idx_facturas_responsable_id ON facturas(id_responsable_de_pago);
CREATE INDEX idx_facturas_estadia_id ON facturas(id_estadia);
CREATE INDEX idx_facturas_fecha_emision ON facturas(fecha_emision);
CREATE INDEX idx_facturas_estado ON facturas(estado_factura);

-- Comentarios sobre tipos enumerados:
-- estado_factura: PAGADA, PENDIENTE, CANCELADA
-- tipo_factura: A, B

-- ========================================
-- TABLA: factura_detalles
-- Descripción: Líneas de detalle de las facturas
-- ========================================
CREATE TABLE IF NOT EXISTS factura_detalles (
    id BIGSERIAL PRIMARY KEY,
    descripcion VARCHAR(255) NOT NULL,
    cantidad INTEGER NOT NULL,
    unidad_medida VARCHAR(10) NOT NULL,
    precio_unitario REAL NOT NULL,
    subtotal REAL NOT NULL,
    factura_id BIGINT NOT NULL,
    CONSTRAINT fk_factura_detalles_factura FOREIGN KEY (factura_id) REFERENCES facturas(id) ON DELETE CASCADE
);

-- Índice
CREATE INDEX idx_factura_detalles_factura_id ON factura_detalles(factura_id);

-- ========================================
-- TABLA: medios_de_pago (Tabla padre - JOINED inheritance)
-- Descripción: Tabla padre abstracta para medios de pago (tarjetas y cheques)
-- ========================================
CREATE TABLE IF NOT EXISTS medios_de_pago (
    id BIGSERIAL PRIMARY KEY,
    tipo VARCHAR(15) NOT NULL
);

-- Índice
CREATE INDEX idx_medios_de_pago_tipo ON medios_de_pago(tipo);

-- Comentarios sobre tipos enumerados:
-- tipo: TARJETA_CREDITO, TARJETA_DEBITO, CHEQUE

-- ========================================
-- TABLA: cheques (Tabla hija - JOINED inheritance)
-- Descripción: Información específica de cheques como medio de pago
-- ========================================
CREATE TABLE IF NOT EXISTS cheques (
    id BIGINT PRIMARY KEY,
    numero VARCHAR(8) NOT NULL,
    plaza VARCHAR(100) NOT NULL,
    tipo_cheque VARCHAR(10) NOT NULL,
    banco_id BIGINT NOT NULL,
    CONSTRAINT fk_cheques_medio_de_pago FOREIGN KEY (id) REFERENCES medios_de_pago(id) ON DELETE CASCADE,
    CONSTRAINT fk_cheques_banco FOREIGN KEY (banco_id) REFERENCES bancos(id)
);

-- Índices
CREATE INDEX idx_cheques_numero ON cheques(numero);
CREATE INDEX idx_cheques_banco_id ON cheques(banco_id);

-- Comentarios sobre tipos enumerados:
-- tipo_cheque: PROPIO, DE_TERCERO

-- ========================================
-- TABLA: tarjetas (Tabla hija - JOINED inheritance)
-- Descripción: Información específica de tarjetas como medio de pago
-- ========================================
CREATE TABLE IF NOT EXISTS tarjetas (
    id BIGINT PRIMARY KEY,
    red_de_pago VARCHAR(10) NOT NULL,
    banco_id BIGINT NOT NULL,
    CONSTRAINT fk_tarjetas_medio_de_pago FOREIGN KEY (id) REFERENCES medios_de_pago(id) ON DELETE CASCADE,
    CONSTRAINT fk_tarjetas_banco FOREIGN KEY (banco_id) REFERENCES bancos(id)
);

-- Índices
CREATE INDEX idx_tarjetas_red_de_pago ON tarjetas(red_de_pago);
CREATE INDEX idx_tarjetas_banco_id ON tarjetas(banco_id);

-- Comentarios sobre tipos enumerados:
-- red_de_pago: VISA, MASTERCARD

-- Comentarios sobre la estrategia de herencia JOINED para medios de pago:
-- - La tabla 'medios_de_pago' contiene los atributos comunes (id, tipo)
-- - La tabla 'cheques' hereda de 'medios_de_pago' mediante FK en el id
-- - La tabla 'tarjetas' hereda de 'medios_de_pago' mediante FK en el id
-- - El id en ambas tablas hijas es PK y FK a la vez
-- - ON DELETE CASCADE asegura que al eliminar un medio de pago se eliminen sus registros hijos

-- ========================================
-- TABLA: pagos
-- Descripción: Pagos realizados de facturas
-- ========================================
CREATE TABLE IF NOT EXISTS pagos (
    id BIGSERIAL PRIMARY KEY,
    fecha_cobro DATE NOT NULL,
    moneda VARCHAR(10) NOT NULL,
    importe REAL NOT NULL,
    cotizacion REAL,
    factura_id BIGINT NOT NULL,
    medio_de_pago_id BIGINT NOT NULL,
    CONSTRAINT fk_pagos_factura FOREIGN KEY (factura_id) REFERENCES facturas(id),
    CONSTRAINT fk_pagos_medio_de_pago FOREIGN KEY (medio_de_pago_id) REFERENCES medios_de_pago(id)
);

-- Índices
CREATE INDEX idx_pagos_factura_id ON pagos(factura_id);
CREATE INDEX idx_pagos_medio_de_pago_id ON pagos(medio_de_pago_id);
CREATE INDEX idx_pagos_fecha_cobro ON pagos(fecha_cobro);

-- Comentarios sobre tipos enumerados:
-- moneda: PESOS, DOLARES, EUROS

-- ========================================
-- TABLA: notas_de_credito
-- Descripción: Notas de crédito emitidas para cancelar facturas
-- ========================================
CREATE TABLE IF NOT EXISTS notas_de_credito (
    id BIGSERIAL PRIMARY KEY,
    fecha_emision DATE NOT NULL,
    monto_total REAL NOT NULL
);

-- Índice
CREATE INDEX idx_notas_de_credito_fecha_emision ON notas_de_credito(fecha_emision);

-- ========================================
-- TABLA: notas_de_credito_facturas_canceladas
-- Descripción: Tabla de relación one-to-many entre notas de crédito y facturas canceladas
-- ========================================
CREATE TABLE IF NOT EXISTS notas_de_credito_facturas_canceladas (
    nota_de_credito_id BIGINT NOT NULL,
    factura_id BIGINT NOT NULL,
    PRIMARY KEY (nota_de_credito_id, factura_id),
    CONSTRAINT fk_notas_facturas_nota FOREIGN KEY (nota_de_credito_id) REFERENCES notas_de_credito(id) ON DELETE CASCADE,
    CONSTRAINT fk_notas_facturas_factura FOREIGN KEY (factura_id) REFERENCES facturas(id)
);

-- Índices
CREATE INDEX idx_notas_facturas_nota_id ON notas_de_credito_facturas_canceladas(nota_de_credito_id);
CREATE INDEX idx_notas_facturas_factura_id ON notas_de_credito_facturas_canceladas(factura_id);
