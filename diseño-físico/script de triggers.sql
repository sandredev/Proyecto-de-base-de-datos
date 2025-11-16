USE Freetour;
GO

CREATE OR ALTER TRIGGER verificarEspecializaciónDisjuntaTeléfonosUsuarios
ON TeléfonosUsuarios
INSTEAD OF INSERT, UPDATE
AS
BEGIN
    SET NOCOUNT ON;
    
    IF EXISTS(
        SELECT 1
        FROM inserted i
        WHERE EXISTS(SELECT 1 FROM TeléfonosPrestadoresDeServicio WHERE idTeléfono = i.idTeléfono)
           OR EXISTS(SELECT 1 FROM TeléfonosEps WHERE idTeléfono = i.idTeléfono)
    )
    BEGIN
        RAISERROR('Este teléfono ya está registrado en otra tabla', 16, 1);
        RETURN;
    END
    
    IF EXISTS(SELECT 1 FROM deleted)
    BEGIN
        UPDATE tu
        SET tu.idUsuario = i.idUsuario
        FROM TeléfonosUsuarios tu
        INNER JOIN deleted d ON tu.idTeléfono = d.idTeléfono
        INNER JOIN inserted i ON d.idTeléfono = i.idTeléfono;
    END
    ELSE
    BEGIN
        INSERT INTO TeléfonosUsuarios (idTeléfono, idUsuario)
        SELECT idTeléfono, idUsuario FROM inserted;
    END
END;
GO

CREATE OR ALTER TRIGGER verificarEspecializaciónDisjuntaTeléfonosPrestadores
ON TeléfonosPrestadoresDeServicio
INSTEAD OF INSERT, UPDATE
AS
BEGIN
    SET NOCOUNT ON;
    
    IF EXISTS(
        SELECT 1
        FROM inserted i
        WHERE EXISTS(SELECT 1 FROM TeléfonosUsuarios WHERE idTeléfono = i.idTeléfono)
           OR EXISTS(SELECT 1 FROM TeléfonosEps WHERE idTeléfono = i.idTeléfono)
    )
    BEGIN
        RAISERROR('Este teléfono ya está registrado en otra tabla', 16, 1);
        RETURN;
    END
    
    IF EXISTS(SELECT 1 FROM deleted)
    BEGIN
        UPDATE tps
        SET tps.idPrestadorServicio = i.idPrestadorServicio
        FROM TeléfonosPrestadoresDeServicio tps
        INNER JOIN deleted d ON tps.idTeléfono = d.idTeléfono
        INNER JOIN inserted i ON d.idTeléfono = i.idTeléfono;
    END
    ELSE
    BEGIN
        INSERT INTO TeléfonosPrestadoresDeServicio (idTeléfono, idPrestadorServicio)
        SELECT idTeléfono, idPrestadorServicio FROM inserted;
    END
END;
GO

CREATE OR ALTER TRIGGER verificarEspecializaciónDisjuntaTeléfonosEPS
ON TeléfonosEps
INSTEAD OF INSERT, UPDATE
AS
BEGIN
    SET NOCOUNT ON;
    
    IF EXISTS(
        SELECT 1
        FROM inserted i
        WHERE EXISTS(SELECT 1 FROM TeléfonosPrestadoresDeServicio WHERE idTeléfono = i.idTeléfono)
           OR EXISTS(SELECT 1 FROM TeléfonosUsuarios WHERE idTeléfono = i.idTeléfono)
    )
    BEGIN
        RAISERROR('Este teléfono ya está registrado en otra tabla', 16, 1);
        RETURN;
    END
    
    IF EXISTS(SELECT 1 FROM deleted)
    BEGIN
        UPDATE teps
        SET teps.idEps = i.idEps
        FROM TeléfonosEps teps
        INNER JOIN deleted d ON teps.idTeléfono = d.idTeléfono
        INNER JOIN inserted i ON d.idTeléfono = i.idTeléfono;
    END
    ELSE
    BEGIN
        INSERT INTO TeléfonosEps (idTeléfono, idEps)
        SELECT idTeléfono, idEps FROM inserted;
    END
END;
GO

CREATE OR ALTER TRIGGER verificarEspecializaciónDisjuntaReseñasDelTour
ON ReseñasDelTour
INSTEAD OF INSERT, UPDATE
AS
BEGIN
    SET NOCOUNT ON;
    
    IF EXISTS(
        SELECT 1
        FROM inserted i
        WHERE EXISTS(SELECT 1 FROM ReseñasDelGuía WHERE idReseñaGuía = i.idReseñaTour)
           OR EXISTS(SELECT 1 FROM ReseñasDelPuntoTurístico WHERE idReseñaPunto = i.idReseñaTour)
           OR EXISTS(SELECT 1 FROM ReseñasPrestadorDeServicios WHERE idReseñaPrestador = i.idReseñaTour)
    )
    BEGIN
        RAISERROR('La reseña ya está registrada en otra tabla', 16, 1);
        RETURN;
    END
    
    IF EXISTS(SELECT 1 FROM deleted)
    BEGIN
        UPDATE rt
        SET rt.idTour = i.idTour
        FROM ReseñasDelTour rt
        INNER JOIN deleted d ON rt.idReseñaTour = d.idReseñaTour
        INNER JOIN inserted i ON d.idReseñaTour = i.idReseñaTour;
    END
    ELSE
    BEGIN
        INSERT INTO ReseñasDelTour (idReseñaTour, idTour)
        SELECT idReseñaTour, idTour FROM inserted;
    END
END;
GO

CREATE OR ALTER TRIGGER verificarEspecializaciónDisjuntaReseñasPunto
ON ReseñasDelPuntoTurístico
INSTEAD OF INSERT, UPDATE
AS
BEGIN
    SET NOCOUNT ON;
    
    IF EXISTS(
        SELECT 1
        FROM inserted i
        WHERE EXISTS(SELECT 1 FROM ReseñasDelGuía WHERE idReseñaGuía = i.idReseñaPunto)
           OR EXISTS(SELECT 1 FROM ReseñasDelTour WHERE idReseñaTour = i.idReseñaPunto)
           OR EXISTS(SELECT 1 FROM ReseñasPrestadorDeServicios WHERE idReseñaPrestador = i.idReseñaPunto)
    )
    BEGIN
        RAISERROR('La reseña ya está registrada en otra tabla', 16, 1);
        RETURN;
    END
    
    IF EXISTS(SELECT 1 FROM deleted)
    BEGIN
        UPDATE rpt
        SET rpt.idPuntoTurístico = i.idPuntoTurístico
        FROM ReseñasDelPuntoTurístico rpt
        INNER JOIN deleted d ON rpt.idReseñaPunto = d.idReseñaPunto
        INNER JOIN inserted i ON d.idReseñaPunto = i.idReseñaPunto;
    END
    ELSE
    BEGIN
        INSERT INTO ReseñasDelPuntoTurístico (idReseñaPunto, idPuntoTurístico)
        SELECT idReseñaPunto, idPuntoTurístico FROM inserted;
    END
END;
GO

CREATE OR ALTER TRIGGER verificarEspecializaciónDisjuntaReseñasPrestador
ON ReseñasPrestadorDeServicios
INSTEAD OF INSERT, UPDATE
AS
BEGIN
    SET NOCOUNT ON;
    
    IF EXISTS(
        SELECT 1
        FROM inserted i
        WHERE EXISTS(SELECT 1 FROM ReseñasDelGuía WHERE idReseñaGuía = i.idReseñaPrestador)
           OR EXISTS(SELECT 1 FROM ReseñasDelPuntoTurístico WHERE idReseñaPunto = i.idReseñaPrestador)
           OR EXISTS(SELECT 1 FROM ReseñasDelTour WHERE idReseñaTour = i.idReseñaPrestador)
    )
    BEGIN
        RAISERROR('La reseña ya está registrada en otra tabla', 16, 1);
        RETURN;
    END
    
    IF EXISTS(SELECT 1 FROM deleted)
    BEGIN
        UPDATE rps
        SET rps.idPrestadorDeServicios = i.idPrestadorDeServicios
        FROM ReseñasPrestadorDeServicios rps
        INNER JOIN deleted d ON rps.idReseñaPrestador = d.idReseñaPrestador
        INNER JOIN inserted i ON d.idReseñaPrestador = i.idReseñaPrestador;
    END
    ELSE
    BEGIN
        INSERT INTO ReseñasPrestadorDeServicios (idReseñaPrestador, idPrestadorDeServicios)
        SELECT idReseñaPrestador, idPrestadorDeServicios FROM inserted;
    END
END;
GO

CREATE OR ALTER TRIGGER verificarEspecializaciónDisjuntaReseñasGuía
ON ReseñasDelGuía
INSTEAD OF INSERT, UPDATE
AS
BEGIN
    SET NOCOUNT ON;
    
    IF EXISTS(
        SELECT 1
        FROM inserted i
        WHERE EXISTS(SELECT 1 FROM ReseñasDelTour WHERE idReseñaTour = i.idReseñaGuía)
           OR EXISTS(SELECT 1 FROM ReseñasDelPuntoTurístico WHERE idReseñaPunto = i.idReseñaGuía)
           OR EXISTS(SELECT 1 FROM ReseñasPrestadorDeServicios WHERE idReseñaPrestador = i.idReseñaGuía)
    )
    BEGIN
        RAISERROR('La reseña ya está registrada en otra tabla', 16, 1);
        RETURN;
    END
    
    IF EXISTS(SELECT 1 FROM deleted)
    BEGIN
        UPDATE rg
        SET rg.idGuíaReseñado = i.idGuíaReseñado
        FROM ReseñasDelGuía rg
        INNER JOIN deleted d ON rg.idReseñaGuía = d.idReseñaGuía
        INNER JOIN inserted i ON d.idReseñaGuía = i.idReseñaGuía;
    END
    ELSE
    BEGIN
        INSERT INTO ReseñasDelGuía (idReseñaGuía, idGuíaReseñado)
        SELECT idReseñaGuía, idGuíaReseñado FROM inserted;
    END
END;
GO

CREATE OR ALTER TRIGGER verificarFechaRealización
ON Reservas
AFTER UPDATE
AS
BEGIN
    IF EXISTS(
        SELECT 1
        FROM inserted as i 
        JOIN deleted as d ON d.idReserva = i.idReserva
        WHERE i.fechaRealizaciónReserva < d.fechaRealizaciónReserva
    )
    BEGIN
        RAISERROR('ERROR: Una o más fechas no se pueden actualizar debido a que su fecha de realización nueva, es anterior a la fecha actualizada', 16, 1);
        ROLLBACK TRANSACTION;
    END
END;
GO

CREATE OR ALTER TRIGGER impedirCambioSitioTour
ON Tours
AFTER UPDATE
AS
BEGIN 
    IF EXISTS(
        SELECT 1
        FROM inserted as i
        JOIN deleted as d ON d.idTour = i.idTour
        WHERE i.idSitio <> d.idSitio
    )
    BEGIN 
        RAISERROR('ERROR: No se permite cambiar el sitio asignado al tour.', 16, 1);
        ROLLBACK TRANSACTION;
        RETURN;
    END
END;
GO

CREATE OR ALTER TRIGGER actualizaciónEstados 
ON EstadosPorReserva
AFTER INSERT
AS
BEGIN
    UPDATE epr
    SET epr.fechaFinEstado = GETDATE()
    FROM EstadosPorReserva epr
    JOIN inserted as i ON i.idReserva = epr.idReserva
    WHERE epr.fechaFinEstado IS NULL 
      AND epr.idEstadosPorReserva <> i.idEstadosPorReserva

    UPDATE epr
    SET epr.fechaInicioEstado = GETDATE()
    FROM EstadosPorReserva as epr
    JOIN inserted as i ON i.idReserva = epr.idReserva
    WHERE i.idEstadosPorReserva = epr.idEstadosPorReserva 
      AND epr.fechaFinEstado IS NULL
END;
GO

CREATE OR ALTER TRIGGER validarFechasNoFuturas
ON FechasTour
AFTER INSERT
AS
BEGIN
    IF EXISTS (
        SELECT 1 
        FROM inserted 
        WHERE fecha < CAST(GETDATE() AS DATE)
    )
    BEGIN
        RAISERROR('ERROR: No se permite programar un tour con fecha en el pasado.', 16, 1);
        ROLLBACK TRANSACTION;
        RETURN;
    END
END;
GO