USE Freetour;
GO

SET NOCOUNT ON;

PRINT '============================================================================';
PRINT 'SCRIPT DE PRUEBA - TRIGGERS ADICIONALES (CON INSERCIÓN MANUAL DE DATOS)';
PRINT '============================================================================';
PRINT '';

-- ============================================================================
-- DECLARACIÓN DE VARIABLES GLOBALES
-- ============================================================================

-- Variables para capturar IDs generados en inserción de datos base
DECLARE @idRegion INT, @idDepartamento INT, @idTipoLocalizacion INT;
DECLARE @idSitio1 INT, @idSitio2 INT, @idPuntoInteres INT;
DECLARE @idEps INT, @idUsuario1 INT, @idUsuario2 INT;
DECLARE @idRolGuia INT, @idRolTurista INT;
DECLARE @idTour INT;

-- Variables para las pruebas de triggers
DECLARE @idFechaTour1 INT, @idFechaTour2 INT;
DECLARE @idSesionTour INT;
DECLARE @idReserva1 INT, @idReserva2 INT;
DECLARE @idEstadoPorReserva1 INT, @idEstadoPorReserva2 INT;

-- ============================================================================
-- PASO 1: INSERCIÓN MANUAL DE DATOS BASE
-- ============================================================================

PRINT '============================================================================';
PRINT 'PASO 1: INSERTANDO DATOS BASE';
PRINT '============================================================================';
PRINT '';

BEGIN TRY
    BEGIN TRANSACTION;

    -- Insertar Roles
    PRINT 'Insertando Roles...';
    INSERT INTO Roles (nombreRol) VALUES ('Guía');
    SET @idRolGuia = SCOPE_IDENTITY();
    INSERT INTO Roles (nombreRol) VALUES ('Turista');
    SET @idRolTurista = SCOPE_IDENTITY();
    PRINT '✓ Roles insertados (IDs: ' + CAST(@idRolGuia AS VARCHAR) + ', ' + CAST(@idRolTurista AS VARCHAR) + ')';

    -- Insertar Región
    PRINT 'Insertando Región...';
    INSERT INTO Regiones (nombreRegión, descripciónRegión, superficieRegión)
    VALUES ('Región Caribe', 'Región de prueba para triggers', 5000.00);
    SET @idRegion = SCOPE_IDENTITY();
    PRINT '✓ Región insertada (ID: ' + CAST(@idRegion AS VARCHAR) + ')';

    -- Insertar Departamento
    PRINT 'Insertando Departamento...';
    INSERT INTO Departamentos (nombreDepartamento, descripciónDepartamento, códigoDane, idRegión)
    VALUES ('Magdalena', 'Departamento de prueba', 47, @idRegion);
    SET @idDepartamento = SCOPE_IDENTITY();
    PRINT '✓ Departamento insertado (ID: ' + CAST(@idDepartamento AS VARCHAR) + ')';

    -- Insertar Tipo de Localización
    PRINT 'Insertando Tipo de Localización...';
    INSERT INTO TiposDeLocalizaciones (nombreTipoLocalización, descripciónTipoLocalización)
    VALUES ('Ciudad Costera', 'Ciudades ubicadas en la costa');
    SET @idTipoLocalizacion = SCOPE_IDENTITY();
    PRINT '✓ Tipo de Localización insertado (ID: ' + CAST(@idTipoLocalizacion AS VARCHAR) + ')';

    -- Insertar Sitios
    PRINT 'Insertando Sitios...';
    INSERT INTO Sitios (nombreSitio, latitudSitio, longitudSitio, idTipoLocalización, idDepartamento)
    VALUES ('Santa Marta', 11.240000, -74.199997, @idTipoLocalizacion, @idDepartamento);
    SET @idSitio1 = SCOPE_IDENTITY();
    
    INSERT INTO Sitios (nombreSitio, latitudSitio, longitudSitio, idTipoLocalización, idDepartamento)
    VALUES ('Taganga', 11.266667, -74.183333, @idTipoLocalizacion, @idDepartamento);
    SET @idSitio2 = SCOPE_IDENTITY();
    PRINT '✓ Sitios insertados (IDs: ' + CAST(@idSitio1 AS VARCHAR) + ', ' + CAST(@idSitio2 AS VARCHAR) + ')';

    -- Insertar Punto de Interés
    PRINT 'Insertando Punto de Interés...';
    INSERT INTO PuntosDeInterés (nombrePuntoDeInterés, descripcionPuntoDeInterés, latitudPuntoDeInterés, longitudPuntoDeInterés)
    VALUES ('Parque Simón Bolívar', 'Punto de encuentro central', 11.240000, -74.199997);
    SET @idPuntoInteres = SCOPE_IDENTITY();
    PRINT '✓ Punto de Interés insertado (ID: ' + CAST(@idPuntoInteres AS VARCHAR) + ')';

    -- Insertar EPS
    PRINT 'Insertando EPS...';
    INSERT INTO Eps (NITEps, nombreEps, direcciónEps, emailEps)
    VALUES ('900111222-3', 'Salud Total', 'Calle 22 #3-45', 'contacto@saludtotal.com');
    SET @idEps = SCOPE_IDENTITY();
    PRINT '✓ EPS insertada (ID: ' + CAST(@idEps AS VARCHAR) + ')';

    -- Insertar Usuarios
    PRINT 'Insertando Usuarios...';
    INSERT INTO Usuarios (nombreUsuario, apellidoUsuario, documentoUsuario, idEps)
    VALUES ('Carlos', 'Rodriguez', '1001234567', @idEps);
    SET @idUsuario1 = SCOPE_IDENTITY();
    
    INSERT INTO Usuarios (nombreUsuario, apellidoUsuario, documentoUsuario, idEps)
    VALUES ('Maria', 'Gomez', '1007654321', @idEps);
    SET @idUsuario2 = SCOPE_IDENTITY();
    PRINT '✓ Usuarios insertados (IDs: ' + CAST(@idUsuario1 AS VARCHAR) + ', ' + CAST(@idUsuario2 AS VARCHAR) + ')';

    -- Insertar Perfiles
    PRINT 'Insertando Perfiles...';
    INSERT INTO Perfiles (idPerfilUsuario, nombrePerfil, contraseñaPerfil, emailPerfil, idRol, fechaCreaciónPerfil)
    VALUES (@idUsuario1, 'carlos_guia', 'password123', 'carlos@freetour.com', @idRolGuia, GETDATE());
    
    INSERT INTO Perfiles (idPerfilUsuario, nombrePerfil, contraseñaPerfil, emailPerfil, idRol, fechaCreaciónPerfil)
    VALUES (@idUsuario2, 'maria_turista', 'password456', 'maria@freetour.com', @idRolTurista, GETDATE());
    PRINT '✓ Perfiles insertados';

    -- Insertar Guía
    PRINT 'Insertando Guía...';
    INSERT INTO Guías (idPerfilGuía, esVerificado, biografíaGuía, descripciónGuía, idSitioGuía)
    VALUES (@idUsuario1, 1, 'Guía certificado con 5 años de experiencia', 'Experto en historia y cultura local', @idSitio1);
    PRINT '✓ Guía insertado';

    -- Insertar Turista
    PRINT 'Insertando Turista...';
    INSERT INTO Turistas (idPerfilTurista)
    VALUES (@idUsuario2);
    PRINT '✓ Turista insertado';

    -- Insertar Tour
    PRINT 'Insertando Tour...';
    INSERT INTO Tours (nombreTour, idPuntoDeEncuentroTour, maxParticipantesTour, duraciónTour, descripciónTour, idGuíaPrincipalTour, idSitio)
    VALUES ('City Tour Santa Marta', @idPuntoInteres, 15, 3.00, 'Recorrido por el centro histórico de Santa Marta', @idUsuario1, @idSitio1);
    SET @idTour = SCOPE_IDENTITY();
    PRINT '✓ Tour insertado (ID: ' + CAST(@idTour AS VARCHAR) + ')';

    -- Insertar Estados de Reserva
    PRINT 'Insertando Estados de Reserva...';
    INSERT INTO EstadosReserva (nombreEstado, descripciónEstado)
    VALUES 
        ('Pendiente', 'Reserva en espera de confirmación'),
        ('Confirmada', 'Reserva confirmada por el guía'),
        ('Cancelada', 'Reserva cancelada'),
        ('Finalizada', 'Tour completado'),
        ('Expirada', 'Reserva no utilizada'),
        ('En curso', 'Tour en progreso');
    PRINT '✓ Estados de Reserva insertados';

    COMMIT TRANSACTION;
    PRINT '';
    PRINT '✓✓✓ TODOS LOS DATOS BASE INSERTADOS CORRECTAMENTE ✓✓✓';
    PRINT '';
END TRY
BEGIN CATCH
    ROLLBACK TRANSACTION;
    PRINT '✗✗✗ ERROR EN INSERCIÓN DE DATOS BASE ✗✗✗';
    PRINT 'Error: ' + ERROR_MESSAGE();
    PRINT 'Línea: ' + CAST(ERROR_LINE() AS VARCHAR);
    -- RETURN; -- Removido para continuar con las pruebas
END CATCH;

-- ============================================================================
-- PASO 2: PRUEBAS DE TRIGGERS
-- ============================================================================

PRINT '============================================================================';
PRINT 'PASO 2: INICIANDO PRUEBAS DE TRIGGERS';
PRINT '============================================================================';
PRINT '';

-- ============================================================================
-- PRUEBA 1: TRIGGER validarFechasNoFuturas
-- ============================================================================

PRINT '============================================================================';
PRINT 'PRUEBA 1: TRIGGER validarFechasNoFuturas';
PRINT '============================================================================';
PRINT '';

PRINT 'Caso 1.1: Insertar fecha FUTURA (debe funcionar)';
BEGIN TRY
    INSERT INTO FechasTour (fecha)
    VALUES (DATEADD(DAY, 10, GETDATE()));
    SET @idFechaTour1 = SCOPE_IDENTITY();
    PRINT '✓ Fecha futura insertada correctamente (ID: ' + CAST(@idFechaTour1 AS VARCHAR) + ')';
END TRY
BEGIN CATCH
    PRINT '✗ Error: ' + ERROR_MESSAGE();
END CATCH;

PRINT '';
PRINT 'Caso 1.2: Insertar fecha de HOY (debe funcionar)';
BEGIN TRY
    INSERT INTO FechasTour (fecha)
    VALUES (CAST(GETDATE() AS DATE));
    SET @idFechaTour2 = SCOPE_IDENTITY();
    PRINT '✓ Fecha de hoy insertada correctamente (ID: ' + CAST(@idFechaTour2 AS VARCHAR) + ')';
END TRY
BEGIN CATCH
    PRINT '✗ Error: ' + ERROR_MESSAGE();
END CATCH;

PRINT '';
PRINT 'Caso 1.3: Intentar insertar fecha PASADA (debe fallar)';
BEGIN TRY
    INSERT INTO FechasTour (fecha)
    VALUES (DATEADD(DAY, -5, GETDATE()));
    PRINT '✗ ERROR: Se permitió fecha pasada (TRIGGER NO FUNCIONA)';
END TRY
BEGIN CATCH
    PRINT '✓ CORRECTO: Fecha pasada rechazada';
    PRINT '  Mensaje: ' + ERROR_MESSAGE();
END CATCH;

PRINT '';

-- ============================================================================
-- PRUEBA 2: TRIGGER impedirCambioSitioTour
-- ============================================================================

PRINT '============================================================================';
PRINT 'PRUEBA 2: TRIGGER impedirCambioSitioTour';
PRINT '============================================================================';
PRINT '';

PRINT 'Caso 2.1: Actualizar otros campos del tour (debe funcionar)';
BEGIN TRY
    UPDATE Tours
    SET nombreTour = 'City Tour Actualizado'
    WHERE idTour = @idTour;
    PRINT '✓ Nombre del tour actualizado correctamente';
END TRY
BEGIN CATCH
    PRINT '✗ Error: ' + ERROR_MESSAGE();
END CATCH;

PRINT '';
PRINT 'Caso 2.2: Intentar cambiar el sitio del tour (debe fallar)';
BEGIN TRY
    UPDATE Tours
    SET idSitio = @idSitio2
    WHERE idTour = @idTour;
    PRINT '✗ ERROR: Se permitió cambiar el sitio (TRIGGER NO FUNCIONA)';
END TRY
BEGIN CATCH
    PRINT '✓ CORRECTO: Cambio de sitio rechazado';
    PRINT '  Mensaje: ' + ERROR_MESSAGE();
END CATCH;

PRINT '';
PRINT 'Verificando que el sitio NO cambió:';
SELECT 
    idTour,
    nombreTour,
    idSitio,
    CASE WHEN idSitio = @idSitio1 THEN '✓ Sitio original mantenido'
         ELSE '✗ ERROR: Sitio fue cambiado'
    END AS Resultado
FROM Tours
WHERE idTour = @idTour;

PRINT '';

-- ============================================================================
-- PRUEBA 3: TRIGGER verificarFechaRealización
-- ============================================================================

PRINT '============================================================================';
PRINT 'PRUEBA 3: TRIGGER verificarFechaRealización';
PRINT '============================================================================';
PRINT '';

-- Preparar datos para la prueba
BEGIN TRY
    BEGIN TRANSACTION;

    PRINT 'Preparando datos para prueba...';
    INSERT INTO SesionesTour (idFechaTour, horaInicioSesión, horaFinSesión)
    VALUES (@idFechaTour1, '09:00:00', '12:00:00');
    SET @idSesionTour = SCOPE_IDENTITY();

    INSERT INTO Reservas (idTurista, cuposReservados, idSesiónTour, fechaRealizaciónReserva)
    VALUES 
        (@idUsuario2, 2, @idSesionTour, DATEADD(DAY, -10, GETDATE())),
        (@idUsuario2, 1, @idSesionTour, DATEADD(DAY, -5, GETDATE()));
    
    SELECT @idReserva1 = MIN(idReserva) FROM Reservas WHERE idTurista = @idUsuario2 AND cuposReservados = 2;
    SELECT @idReserva2 = MAX(idReserva) FROM Reservas WHERE idTurista = @idUsuario2;

    COMMIT TRANSACTION;
    PRINT '✓ Reservas creadas (IDs: ' + CAST(@idReserva1 AS VARCHAR) + ', ' + CAST(@idReserva2 AS VARCHAR) + ')';
    PRINT '';
END TRY
BEGIN CATCH
    ROLLBACK TRANSACTION;
    PRINT '✗ Error creando reservas: ' + ERROR_MESSAGE();
    -- RETURN; -- Removido para continuar
END CATCH;

PRINT 'Caso 3.1: Actualizar fecha a una fecha POSTERIOR (debe funcionar)';
PRINT 'Fecha original: ' + CAST(DATEADD(DAY, -10, GETDATE()) AS VARCHAR);
PRINT 'Fecha nueva: ' + CAST(DATEADD(DAY, -3, GETDATE()) AS VARCHAR);
BEGIN TRY
    UPDATE Reservas
    SET fechaRealizaciónReserva = DATEADD(DAY, -3, GETDATE())
    WHERE idReserva = @idReserva1;
    PRINT '✓ Fecha actualizada a fecha posterior correctamente';
END TRY
BEGIN CATCH
    PRINT '✗ Error: ' + ERROR_MESSAGE();
END CATCH;

PRINT '';
PRINT 'Caso 3.2: Intentar actualizar fecha a una fecha ANTERIOR (debe fallar)';
PRINT 'Fecha actual: ' + CAST(DATEADD(DAY, -3, GETDATE()) AS VARCHAR);
PRINT 'Intentando cambiar a: ' + CAST(DATEADD(DAY, -15, GETDATE()) AS VARCHAR);
BEGIN TRY
    UPDATE Reservas
    SET fechaRealizaciónReserva = DATEADD(DAY, -15, GETDATE())
    WHERE idReserva = @idReserva1;
    PRINT '✗ ERROR: Se permitió fecha anterior (TRIGGER NO FUNCIONA)';
END TRY
BEGIN CATCH
    PRINT '✓ CORRECTO: Fecha anterior rechazada';
    PRINT '  Mensaje: ' + ERROR_MESSAGE();
END CATCH;

PRINT '';

-- ============================================================================
-- PRUEBA 4: TRIGGER actualizaciónEstados
-- ============================================================================

PRINT '============================================================================';
PRINT 'PRUEBA 4: TRIGGER actualizaciónEstados';
PRINT '============================================================================';
PRINT '';

-- Preparar primer estado
BEGIN TRY
    BEGIN TRANSACTION;

    PRINT 'Insertando estado inicial de reserva...';
    INSERT INTO EstadosPorReserva (idReserva, idEstado, descripciónEstadosPorReserva, fechaInicioEstado)
    VALUES (@idReserva2, 1, 'Estado inicial - Pendiente', GETDATE());
    SET @idEstadoPorReserva1 = SCOPE_IDENTITY();

    COMMIT TRANSACTION;
    PRINT '✓ Estado inicial creado (ID: ' + CAST(@idEstadoPorReserva1 AS VARCHAR) + ')';
    PRINT '';
END TRY
BEGIN CATCH
    ROLLBACK TRANSACTION;
    PRINT '✗ Error: ' + ERROR_MESSAGE();
    -- RETURN; -- Removido para continuar
END CATCH;

PRINT 'Estado ANTES de insertar nuevo estado:';
SELECT 
    idEstadosPorReserva,
    idReserva,
    idEstado,
    CONVERT(VARCHAR, fechaInicioEstado, 120) AS fechaInicioEstado,
    CONVERT(VARCHAR, fechaFinEstado, 120) AS fechaFinEstado,
    CASE 
        WHEN fechaFinEstado IS NULL THEN '✓ Estado ACTIVO'
        ELSE '✗ Estado FINALIZADO'
    END AS EstadoActual
FROM EstadosPorReserva
WHERE idReserva = @idReserva2;

PRINT '';
PRINT 'Caso 4.1: Insertar nuevo estado (debe actualizar fechas del anterior)';
BEGIN TRY
    PRINT 'Esperando 2 segundos para diferencia de tiempo...';
    -- Insertar el segundo estado manualmente
WAITFOR DELAY '00:00:02'; -- Esperar 2 segundos

INSERT INTO EstadosPorReserva (idReserva, idEstado, descripciónEstadosPorReserva, fechaInicioEstado)
VALUES (2, 2, 'Estado actualizado - Confirmada', GETDATE());

-- Verificar los resultados
SELECT 
    idEstadosPorReserva,
    idReserva,
    idEstado,
    CONVERT(VARCHAR, fechaInicioEstado, 120) AS fechaInicio,
    CONVERT(VARCHAR, fechaFinEstado, 120) AS fechaFin,
    CASE 
        WHEN fechaFinEstado IS NULL THEN '✓ Estado ACTIVO'
        ELSE '✓ Estado FINALIZADO'
    END AS EstadoActual
FROM EstadosPorReserva
WHERE idReserva = 2
ORDER BY idEstadosPorReserva;
    
    PRINT '✓ Nuevo estado insertado (ID: ' + CAST(@idEstadoPorReserva2 AS VARCHAR) + ')';
END TRY
BEGIN CATCH
    PRINT '✗ Error: ' + ERROR_MESSAGE();
END CATCH;

PRINT '';
PRINT 'Estado DESPUÉS de insertar nuevo estado:';
SELECT 
    idEstadosPorReserva,
    idReserva,
    idEstado,
    CONVERT(VARCHAR, fechaInicioEstado, 120) AS fechaInicioEstado,
    CONVERT(VARCHAR, fechaFinEstado, 120) AS fechaFinEstado,
    CASE 
        WHEN fechaFinEstado IS NULL THEN '✓ Estado ACTIVO'
        ELSE '✓ Estado FINALIZADO'
    END AS EstadoActual
FROM EstadosPorReserva
WHERE idReserva = @idReserva2
ORDER BY idEstadosPorReserva;

PRINT '';
PRINT 'Verificando funcionamiento del trigger:';

-- Verificación 1: Estado anterior debe tener fechaFinEstado
IF EXISTS(
    SELECT 1 FROM EstadosPorReserva 
    WHERE idEstadosPorReserva = @idEstadoPorReserva1 
    AND fechaFinEstado IS NOT NULL
)
    PRINT '✓ Estado anterior tiene fechaFinEstado actualizada'
ELSE
    PRINT '✗ ERROR: Estado anterior no tiene fechaFinEstado';

-- Verificación 2: Estado nuevo debe tener fechaInicioEstado y fechaFinEstado NULL
IF EXISTS(
    SELECT 1 FROM EstadosPorReserva 
    WHERE idEstadosPorReserva = @idEstadoPorReserva2 
    AND fechaInicioEstado IS NOT NULL
    AND fechaFinEstado IS NULL
)
    PRINT '✓ Estado nuevo tiene fechaInicioEstado y fechaFinEstado es NULL'
ELSE
    PRINT '✗ ERROR: Estado nuevo no tiene las fechas correctas';

PRINT '';

-- ============================================================================
-- RESUMEN FINAL
-- ============================================================================

PRINT '============================================================================';
PRINT 'RESUMEN DE RESULTADOS';
PRINT '============================================================================';
PRINT '';
PRINT 'TRIGGERS EVALUADOS:';
PRINT '';
PRINT '1. validarFechasNoFuturas';
PRINT '   └─ Debe rechazar fechas pasadas en FechasTour';
PRINT '';
PRINT '2. impedirCambioSitioTour';
PRINT '   └─ Debe impedir modificar el idSitio de un Tour';
PRINT '';
PRINT '3. verificarFechaRealización';
PRINT '   └─ Debe impedir que fechaRealizaciónReserva retroceda en el tiempo';
PRINT '';
PRINT '4. actualizaciónEstados';
PRINT '   └─ Debe actualizar automáticamente las fechas cuando se inserta un nuevo estado';
PRINT '';
PRINT '============================================================================';
PRINT 'FIN DE LAS PRUEBAS';
PRINT '============================================================================';
