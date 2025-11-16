-- ============================================================================
-- SCRIPT DE PRUEBA PARA TRIGGERS DE ESPECIALIZACIÓN
-- Base de datos: Freetour
-- ============================================================================

USE Freetour;
GO

PRINT '============================================================================';
PRINT 'INICIO DE PRUEBAS DE TRIGGERS';
PRINT '============================================================================';
PRINT '';

-- ============================================================================
-- CONFIGURACIÓN INICIAL - DATOS BASE NECESARIOS
-- ============================================================================
PRINT '--- CONFIGURACIÓN INICIAL ---';
PRINT '';

-- Insertar datos base necesarios para las pruebas
DECLARE @idPais INT, @idTipoTelefono INT, @idEps INT;
DECLARE @idUsuario1 INT, @idUsuario2 INT, @idUsuario3 INT;
DECLARE @idReseña1 INT, @idReseña2 INT, @idReseña3 INT;
DECLARE @idRol INT, @idValorCalificacion INT;

-- País
IF NOT EXISTS(SELECT 1 FROM Países WHERE códigoIso3 = 'COL')
BEGIN
    INSERT INTO Países (nombrePaís, códigoIsoNúmerico, códigoIso3, códigoTeléfonico)
    VALUES ('Colombia', 170, 'COL', '+57');
    SET @idPais = SCOPE_IDENTITY();
END
ELSE
    SELECT @idPais = idPaís FROM Países WHERE códigoIso3 = 'COL';

-- Tipo de Teléfono
IF NOT EXISTS(SELECT 1 FROM TiposTeléfonos WHERE nombreTipoTeléfono = 'Móvil')
BEGIN
    INSERT INTO TiposTeléfonos (nombreTipoTeléfono, descripciónTipoTeléfono)
    VALUES ('Móvil', 'Teléfono celular');
    SET @idTipoTelefono = SCOPE_IDENTITY();
END
ELSE
    SELECT @idTipoTelefono = idTipoTeléfono FROM TiposTeléfonos WHERE nombreTipoTeléfono = 'Móvil';

-- EPS
IF NOT EXISTS(SELECT 1 FROM Eps WHERE NITEps = '900123456-1')
BEGIN
    INSERT INTO Eps (NITEps, nombreEps, direcciónEps, emailEps)
    VALUES ('900123456-1', 'EPS Test', 'Calle 123 #45-67', 'test@epstest.com');
    SET @idEps = SCOPE_IDENTITY();
END
ELSE
    SELECT @idEps = idEps FROM Eps WHERE NITEps = '900123456-1';

-- Usuarios
INSERT INTO Usuarios (nombreUsuario, apellidoUsuario, documentoUsuario, idEps)
VALUES 
    ('Juan', 'Pérez', '123456789', @idEps),
    ('María', 'González', '987654321', @idEps),
    ('Carlos', 'Rodríguez', '456789123', @idEps);

SELECT @idUsuario1 = idUsuario FROM Usuarios WHERE documentoUsuario = '123456789';
SELECT @idUsuario2 = idUsuario FROM Usuarios WHERE documentoUsuario = '987654321';
SELECT @idUsuario3 = idUsuario FROM Usuarios WHERE documentoUsuario = '456789123';

-- Rol
IF NOT EXISTS(SELECT 1 FROM Roles WHERE nombreRol = 'Turista')
BEGIN
    INSERT INTO Roles (nombreRol) VALUES ('Turista');
    SET @idRol = SCOPE_IDENTITY();
END
ELSE
    SELECT @idRol = idRol FROM Roles WHERE nombreRol = 'Turista';

-- Valor Calificación
IF NOT EXISTS(SELECT 1 FROM ValoresCalificación WHERE valorNumérico = 5)
BEGIN
    INSERT INTO ValoresCalificación (rasgoCaracterístico, valorNumérico)
    VALUES ('Excelente', 5);
    SET @idValorCalificacion = SCOPE_IDENTITY();
END
ELSE
    SELECT @idValorCalificacion = idValorCalificación FROM ValoresCalificación WHERE valorNumérico = 5;

-- Perfiles
INSERT INTO Perfiles (idPerfilUsuario, nombrePerfil, contraseñaPerfil, emailPerfil, idRol, fechaCreaciónPerfil)
VALUES 
    (@idUsuario1, 'juan_perez', 'pass123', 'juan@test.com', @idRol, GETDATE()),
    (@idUsuario2, 'maria_gonzalez', 'pass456', 'maria@test.com', @idRol, GETDATE()),
    (@idUsuario3, 'carlos_rodriguez', 'pass789', 'carlos@test.com', @idRol, GETDATE());

-- Turistas (para especialización de Perfiles)
INSERT INTO Turistas (idPerfilTurista)
VALUES (@idUsuario1), (@idUsuario2), (@idUsuario3);

-- Reseñas base
INSERT INTO Reseñas (fechaPublicaciónReseña, comentarioReseña, idPerfil, idValorCalificación)
VALUES 
    (GETDATE(), 'Excelente experiencia', @idUsuario1, @idValorCalificacion),
    (GETDATE(), 'Muy bueno', @idUsuario2, @idValorCalificacion),
    (GETDATE(), 'Regular', @idUsuario3, @idValorCalificacion);

SELECT @idReseña1 = idReseña FROM Reseñas WHERE comentarioReseña = 'Excelente experiencia';
SELECT @idReseña2 = idReseña FROM Reseñas WHERE comentarioReseña = 'Muy bueno';
SELECT @idReseña3 = idReseña FROM Reseñas WHERE comentarioReseña = 'Regular';

PRINT '✓ Datos base insertados correctamente';
PRINT '';

-- ============================================================================
-- PRUEBA 1: ESPECIALIZACIÓN DISJUNTA - TELÉFONOS
-- ============================================================================
PRINT '--- PRUEBA 1: ESPECIALIZACIÓN DISJUNTA - TELÉFONOS ---';
PRINT '';

-- Insertar teléfonos base
DECLARE @idTelefono1 INT, @idTelefono2 INT, @idTelefono3 INT;

INSERT INTO Teléfonos (númeroTeléfono, observacionesTeléfono, esPrincipal, idTipoTeléfono, idPaís)
VALUES 
    ('+57 300 1234567', 'Teléfono de prueba 1', 1, @idTipoTelefono, @idPais),
    ('+57 301 2345678', 'Teléfono de prueba 2', 0, @idTipoTelefono, @idPais),
    ('+57 302 3456789', 'Teléfono de prueba 3', 0, @idTipoTelefono, @idPais);

SELECT @idTelefono1 = idTeléfono FROM Teléfonos WHERE númeroTeléfono = '+57 300 1234567';
SELECT @idTelefono2 = idTeléfono FROM Teléfonos WHERE númeroTeléfono = '+57 301 2345678';
SELECT @idTelefono3 = idTeléfono FROM Teléfonos WHERE númeroTeléfono = '+57 302 3456789';

PRINT '✓ Teléfonos base insertados correctamente';

-- Caso 1: Insertar en TeléfonosUsuarios (debería funcionar)
BEGIN TRY
    INSERT INTO TeléfonosUsuarios (idTeléfono, idUsuario) 
    VALUES (@idTelefono1, @idUsuario1);
    PRINT '✓ CASO 1 CORRECTO: Teléfono insertado en TeléfonosUsuarios';
END TRY
BEGIN CATCH
    PRINT '✗ CASO 1 FALLÓ: ' + ERROR_MESSAGE();
END CATCH;

-- Caso 2: Intentar insertar el mismo teléfono en TeléfonosEps (debería fallar)
BEGIN TRY
    INSERT INTO TeléfonosEps (idTeléfono, idEps) 
    VALUES (@idTelefono1, @idEps);
    PRINT '✗ CASO 2 FALLÓ: Se permitió duplicado (ERROR EN TRIGGER)';
END TRY
BEGIN CATCH
    PRINT '✓ CASO 2 CORRECTO: Duplicado rechazado - ' + ERROR_MESSAGE();
END CATCH;

-- Caso 3: Intentar insertar el mismo teléfono en Prestadores (debería fallar)
-- Primero crear un prestador
DECLARE @idPrestador INT;
INSERT INTO PrestadoresDeServicios (nombreComercialPrestador, emailPrestadorServicio, razónSocialPrestadorServicio)
VALUES ('Prestador Test', 'prestador@test.com', 'Prestador Test SAS');
SET @idPrestador = SCOPE_IDENTITY();

BEGIN TRY
    INSERT INTO TeléfonosPrestadoresDeServicio (idTeléfono, idPrestadorServicio) 
    VALUES (@idTelefono1, @idPrestador);
    PRINT '✗ CASO 3 FALLÓ: Se permitió duplicado (ERROR EN TRIGGER)';
END TRY
BEGIN CATCH
    PRINT '✓ CASO 3 CORRECTO: Duplicado rechazado - ' + ERROR_MESSAGE();
END CATCH;

-- Caso 4: Insertar teléfono diferente en otra tabla (debería funcionar)
BEGIN TRY
    INSERT INTO TeléfonosEps (idTeléfono, idEps) 
    VALUES (@idTelefono2, @idEps);
    PRINT '✓ CASO 4 CORRECTO: Teléfono 2 insertado en TeléfonosEps';
END TRY
BEGIN CATCH
    PRINT '✗ CASO 4 FALLÓ: ' + ERROR_MESSAGE();
END CATCH;

PRINT '';

-- ============================================================================
-- PRUEBA 2: ESPECIALIZACIÓN DISJUNTA - RESEÑAS
-- ============================================================================
PRINT '--- PRUEBA 2: ESPECIALIZACIÓN DISJUNTA - RESEÑAS ---';
PRINT '';

-- Crear datos necesarios para reseñas especializadas
DECLARE @idTour INT, @idPuntoInteres INT, @idGuia INT;

-- Crear región, departamento, tipo localización, sitio
DECLARE @idRegion INT, @idDepartamento INT, @idTipoLocalizacion INT, @idSitio INT;

INSERT INTO Regiones (nombreRegión, descripciónRegión, superficieRegión)
VALUES ('Caribe', 'Región Caribe', 132218.00);
SET @idRegion = SCOPE_IDENTITY();

INSERT INTO Departamentos (nombreDepartamento, descripciónDepartamento, códigoDane, idRegión)
VALUES ('Magdalena', 'Departamento del Magdalena', 47, @idRegion);
SET @idDepartamento = SCOPE_IDENTITY();

INSERT INTO TiposDeLocalizaciones (nombreTipoLocalización, descripciónTipoLocalización)
VALUES ('Ciudad', 'Área urbana');
SET @idTipoLocalizacion = SCOPE_IDENTITY();

INSERT INTO Sitios (nombreSitio, latitudSitio, longitudSitio, idTipoLocalización, idDepartamento)
VALUES ('Santa Marta', 11.2408, -74.1990, @idTipoLocalizacion, @idDepartamento);
SET @idSitio = SCOPE_IDENTITY();

-- Crear guía
DECLARE @idUsuarioGuia INT;
INSERT INTO Usuarios (nombreUsuario, apellidoUsuario, documentoUsuario, idEps)
VALUES ('Pedro', 'Martínez', '111222333', @idEps);
SET @idUsuarioGuia = SCOPE_IDENTITY();

DECLARE @idRolGuia INT;
IF NOT EXISTS(SELECT 1 FROM Roles WHERE nombreRol = 'Guía')
    INSERT INTO Roles (nombreRol) VALUES ('Guía');
SELECT @idRolGuia = idRol FROM Roles WHERE nombreRol = 'Guía';

INSERT INTO Perfiles (idPerfilUsuario, nombrePerfil, contraseñaPerfil, emailPerfil, idRol, fechaCreaciónPerfil)
VALUES (@idUsuarioGuia, 'pedro_guia', 'pass123', 'pedro@test.com', @idRolGuia, GETDATE());

INSERT INTO Guías (idPerfilGuía, esVerificado, biografíaGuía, descripciónGuía, idSitioGuía)
VALUES (@idUsuarioGuia, 1, 'Guía experimentado', 'Guía turístico', @idSitio);
SET @idGuia = @idUsuarioGuia;

-- Crear punto de interés
INSERT INTO PuntosDeInterés (nombrePuntoDeInterés, descripcionPuntoDeInterés, latitudPuntoDeInterés, longitudPuntoDeInterés)
VALUES ('Parque Tayrona', 'Parque natural', 11.3000, -74.0500);
SET @idPuntoInteres = SCOPE_IDENTITY();

-- Crear tour
INSERT INTO Tours (nombreTour, idPuntoDeEncuentroTour, maxParticipantesTour, duraciónTour, descripciónTour, idGuíaPrincipalTour, idSitio)
VALUES ('City Tour', @idPuntoInteres, 20, 3.00, 'Tour por la ciudad', @idGuia, @idSitio);
SET @idTour = SCOPE_IDENTITY();

PRINT '✓ Datos base para reseñas creados';

-- Caso 1: Insertar en ReseñasDelTour (debería funcionar)
BEGIN TRY
    INSERT INTO ReseñasDelTour (idReseñaTour, idTour) 
    VALUES (@idReseña1, @idTour);
    PRINT '✓ CASO 1 CORRECTO: Reseña insertada en ReseñasDelTour';
END TRY
BEGIN CATCH
    PRINT '✗ CASO 1 FALLÓ: ' + ERROR_MESSAGE();
END CATCH;

-- Caso 2: Intentar insertar la misma reseña en ReseñasDelGuía (debería fallar)
BEGIN TRY
    INSERT INTO ReseñasDelGuía (idReseñaGuía, idGuíaReseñado) 
    VALUES (@idReseña1, @idGuia);
    PRINT '✗ CASO 2 FALLÓ: Se permitió duplicado (ERROR EN TRIGGER)';
END TRY
BEGIN CATCH
    PRINT '✓ CASO 2 CORRECTO: Duplicado rechazado - ' + ERROR_MESSAGE();
END CATCH;

-- Caso 3: Insertar reseña diferente (debería funcionar)
BEGIN TRY
    INSERT INTO ReseñasDelGuía (idReseñaGuía, idGuíaReseñado) 
    VALUES (@idReseña2, @idGuia);
    PRINT '✓ CASO 3 CORRECTO: Reseña 2 insertada en ReseñasDelGuía';
END TRY
BEGIN CATCH
    PRINT '✗ CASO 3 FALLÓ: ' + ERROR_MESSAGE();
END CATCH;

-- Caso 4: Intentar insertar en otra tabla especializada (debería fallar)
BEGIN TRY
    INSERT INTO ReseñasDelPuntoTurístico (idReseñaPunto, idPuntoTurístico) 
    VALUES (@idReseña1, @idPuntoInteres);
    PRINT '✗ CASO 4 FALLÓ: Se permitió duplicado (ERROR EN TRIGGER)';
END TRY
BEGIN CATCH
    PRINT '✓ CASO 4 CORRECTO: Duplicado rechazado - ' + ERROR_MESSAGE();
END CATCH;

PRINT '';



-- ============================================================================
-- RESUMEN DE ESTADO ACTUAL
-- ============================================================================
PRINT '============================================================================';
PRINT 'RESUMEN DE ESTADO ACTUAL DE LAS TABLAS';
PRINT '============================================================================';
PRINT '';

PRINT 'Teléfonos por categoría:';
SELECT 'TeléfonosUsuarios' AS Tabla, COUNT(*) AS Total FROM TeléfonosUsuarios
UNION ALL
SELECT 'TeléfonosEps', COUNT(*) FROM TeléfonosEps
UNION ALL
SELECT 'TeléfonosPrestadoresDeServicio', COUNT(*) FROM TeléfonosPrestadoresDeServicio;

PRINT '';
PRINT 'Reseñas por categoría:';
SELECT 'ReseñasDelTour' AS Tabla, COUNT(*) AS Total FROM ReseñasDelTour
UNION ALL
SELECT 'ReseñasDelGuía', COUNT(*) FROM ReseñasDelGuía
UNION ALL
SELECT 'ReseñasDelPuntoTurístico', COUNT(*) FROM ReseñasDelPuntoTurístico
UNION ALL
SELECT 'ReseñasPrestadorDeServicios', COUNT(*) FROM ReseñasPrestadorDeServicios;

PRINT '';
PRINT 'Perfiles por categoría:';
SELECT 'Guías' AS Tabla, COUNT(*) AS Total FROM Guías
UNION ALL
SELECT 'Turistas', COUNT(*) FROM Turistas;

PRINT '';