-- =======================================================
-- 1. CREACIÓN DE BASE DE DATOS Y TABLAS INDEPENDIENTES
-- =======================================================
CREATE DATABASE GestionTramites_DB;
GO

USE GestionTramites_DB;
GO

-- Entidad: Cliente (Sin claves foráneas)
CREATE TABLE Cliente (
    OIDCliente INT PRIMARY KEY,
    nroCliente INT,
    nombreCliente VARCHAR(100),
    fechaHoraBajaCliente DATETIME NULL
);

-- Entidad: EstadoTramite (Sin claves foráneas)
CREATE TABLE EstadoTramite (
    OIDEstadoTramite INT PRIMARY KEY,
    codEstadoTramite VARCHAR(20),
    descripcionEstadoTramite VARCHAR(200),
    fechaHoraBajaEstadoTramite DATETIME NULL,
    nombreEstadoTramite VARCHAR(50)
);

-- Entidad: TipoTramite (Sin claves foráneas)
CREATE TABLE TipoTramite (
    OIDTipoTramite INT PRIMARY KEY,
    codTipoTramite VARCHAR(20),
    nombreTipoTramite VARCHAR(100),
    descripTipoTramite VARCHAR(200),
    FechaHoraBajaTipoTramite DATETIME NULL,
    cantidadMaxDiasParaDocumentacion INT
);

-- Entidad: TipoDocumentacion (Sin claves foráneas)
CREATE TABLE TipoDocumentacion (
    OIDTipoDocumentacion INT PRIMARY KEY,
    codTipoDocumentacion VARCHAR(20),
    descripcionTipoDocumentacion VARCHAR(200),
    fechaHoraBajaTipoDocumentacion DATETIME NULL,
    nombreTipoDocumentacion VARCHAR(100),
    requiereEntregaPresencial BIT
);

-- =======================================================
-- 2. CREACIÓN DE TABLAS DEPENDIENTES (CON CLAVES FORÁNEAS)
-- =======================================================

-- Entidad: Tramite (Depende de EstadoTramite, TipoTramite y Cliente)
CREATE TABLE Tramite (
    OIDTramite INT PRIMARY KEY,
    nroTramite INT,
    fechaHoraFinalizacionTramite DATETIME NULL,
    fechaHoraInicioTramite DATETIME,
    fechaHoraRegistroTramite DATETIME,
    observacionesTramite VARCHAR(255),
    OIDEstadoTramite INT,
    OIDTipoTramite INT,
    OIDCliente INT,
    FOREIGN KEY (OIDEstadoTramite) REFERENCES EstadoTramite(OIDEstadoTramite),
    FOREIGN KEY (OIDTipoTramite) REFERENCES TipoTramite(OIDTipoTramite),
    FOREIGN KEY (OIDCliente) REFERENCES Cliente(OIDCliente)
);

-- Entidad: TramiteEstado (Depende de Tramite y EstadoTramite)
CREATE TABLE TramiteEstado (
    OIDTramiteEstado INT PRIMARY KEY,
    contadorTramite INT,
    fechaHoraInicioTramiteEstado DATETIME,
    fechaHoraFinTramiteEstado DATETIME NULL,
    observacionesTramiteEstado VARCHAR(255),
    OIDTramite INT,
    OIDEstadoTramite INT,
    FOREIGN KEY (OIDTramite) REFERENCES Tramite(OIDTramite),
    FOREIGN KEY (OIDEstadoTramite) REFERENCES EstadoTramite(OIDEstadoTramite)
);

-- Entidad: TipoTramiteTipoDocumentacion (Tabla intermedia)
CREATE TABLE TipoTramiteTipoDocumentacion (
    OIDTipoTramiteTipoDocumentacion INT PRIMARY KEY,
    contadorTipoTramite INT,
    fechaHoraFinVigenciaTipoTramiteTipoDocumentacion DATETIME NULL,
    fechaHoraInicioVigenciaTipoTramiteTipoDocumentacio DATETIME,
    OIDTipoTramite INT,
    OIDTipoDocumentacion INT,
    FOREIGN KEY (OIDTipoTramite) REFERENCES TipoTramite(OIDTipoTramite),
    FOREIGN KEY (OIDTipoDocumentacion) REFERENCES TipoDocumentacion(OIDTipoDocumentacion)
);

-- Entidad: TramiteTipoDocumentacion (Tabla intermedia)
CREATE TABLE TramiteTipoDocumentacion (
    OIDTramiteTipoDocumentacion INT PRIMARY KEY,
    fechaHoraRegistroTramiteTipoDocumentacion DATETIME,
    urlArchivoTramiteTipoDocumentacion VARCHAR(255),
    OIDTramite INT,
    OIDTipoDocumentacion INT,
    FOREIGN KEY (OIDTramite) REFERENCES Tramite(OIDTramite),
    FOREIGN KEY (OIDTipoDocumentacion) REFERENCES TipoDocumentacion(OIDTipoDocumentacion)
);

-- =======================================================
-- 3. INSERCIÓN DE DATOS DE PRUEBA
-- =======================================================
INSERT INTO Cliente VALUES 
(1, 1001, 'Maria Soloa', NULL),
(2, 1002, 'Lucas Perez', NULL);

INSERT INTO EstadoTramite VALUES 
(1, 'EST-01', 'El trámite ingresó al sistema', NULL, 'Iniciado'),
(2, 'EST-02', 'El trámite está siendo evaluado', NULL, 'En Proceso');

INSERT INTO TipoTramite VALUES 
(1, 'TIP-01', 'Solicitud de Portabilidad', 'Gestión de cambio de empresa telefónica', NULL, 5),
(2, 'TIP-02', 'Reclamo Técnico', 'Falla de servicio de fibra óptica', NULL, 2);

INSERT INTO TipoDocumentacion VALUES 
(1, 'DOC-01', 'Documento Nacional de Identidad', NULL, 'DNI Frente y Dorso', 0),
(2, 'DOC-02', 'Factura del mes anterior', NULL, 'Factura Servicio', 0);

INSERT INTO Tramite VALUES 
(1, 5001, NULL, '2026-11-03 08:00:00', '2026-11-03 08:05:00', 'Solicita mantener el número', 1, 1, 1),
(2, 5002, NULL, '2026-11-03 09:00:00', '2026-11-03 09:10:00', 'Falla de router', 2, 2, 2);

INSERT INTO TramiteTipoDocumentacion VALUES 
(1, '2026-11-03 08:15:00', '/archivos/dni_maria.pdf', 1, 1),
(2, '2026-11-03 09:15:00', '/archivos/factura_lucas.pdf', 2, 2);

-- =======================================================
-- 4. CONSULTA PARA MOSTRAR EN LA ENTREVISTA
-- =======================================================
-- Muestra el número de trámite, el cliente, el tipo de gestión, el estado actual y el documento adjunto
SELECT 
    t.nroTramite AS 'Numero Tramite',
    c.nombreCliente AS 'Cliente',
    tt.nombreTipoTramite AS 'Tipo de Gestion',
    et.nombreEstadoTramite AS 'Estado Actual',
    td.nombreTipoDocumentacion AS 'Documento Presentado',
    ttd.urlArchivoTramiteTipoDocumentacion AS 'Archivo'
FROM Tramite t
INNER JOIN Cliente c ON t.OIDCliente = c.OIDCliente
INNER JOIN TipoTramite tt ON t.OIDTipoTramite = tt.OIDTipoTramite
INNER JOIN EstadoTramite et ON t.OIDEstadoTramite = et.OIDEstadoTramite
INNER JOIN TramiteTipoDocumentacion ttd ON t.OIDTramite = ttd.OIDTramite
INNER JOIN TipoDocumentacion td ON ttd.OIDTipoDocumentacion = td.OIDTipoDocumentacion;
