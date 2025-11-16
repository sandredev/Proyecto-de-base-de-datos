USE Freetour;
GO
-- Procedimiento 1: registra una reseña en la base de datos.
CREATE OR ALTER PROCEDURE registrarReseña
	@comentarioReseña VARCHAR(500),
	@idUsuario INT,
	@valorCalificación INT,
	@idReseña INT OUT
AS
BEGIN
	SET NOCOUNT ON;
	-- Verifica que el valor de la calificación a ingresar sea correcto.
	DECLARE @EsCalificaciónVálida BIT = 
		CASE 
			WHEN @valorCalificación BETWEEN 0 AND 5 THEN 1
			ELSE 0
		END;
	IF @EsCalificaciónVálida = 0
		RAISERROR ('Calificación fuera del rango válido (0 - 5)', 16, 1);
	ELSE
	BEGIN
		DECLARE @idPerfilUsuario INT;
		SELECT @idPerfilUsuario = idPerfilUsuario
		FROM Perfiles p
		JOIN Usuarios u ON u.idUsuario = p.idPerfilUsuario
		WHERE u.idUsuario = @idUsuario;
		IF @idPerfilUsuario IS NULL 
			RAISERROR('Usuario no registrado en la plataforma', 16, 1);
		ELSE
		BEGIN
			DECLARE @idValorCalificación INT;
			SELECT @idValorCalificación = idValorCalificación
			FROM ValoresCalificación
			WHERE valorNumérico = @valorCalificación;
			INSERT INTO Reseñas(fechaPublicaciónReseña, comentarioReseña, idPerfil, idValorCalificación)
			VALUES
			(GETDATE(), @comentarioReseña, @idPerfilUsuario, @idValorCalificación);
			SET @idReseña = SCOPE_IDENTITY();
		END;
	END;
END;
GO
-- Procedimiento 2: añade detalles a una reseña ya registrada.
CREATE OR ALTER PROCEDURE añadirDetalleReseña
	@idReseña INT,
	@detalle VARCHAR(50),
	@descripciónDetalle VARCHAR(500) = NULL,
	@valorCalificación INT,
	@idDetalleReseña INT OUT
AS 
BEGIN
	SET NOCOUNT ON;
	DECLARE @esCalificaciónVálida BIT = 
		CASE 
			WHEN @valorCalificación BETWEEN 0 AND 5 THEN 1
			ELSE 0
		END;
	IF @esCalificaciónVálida = 0
		RAISERROR ('Calificación fuera del rango válido (0 - 5)', 16, 1);
	ELSE
	BEGIN
		DECLARE @idValorCalificación INT;
		SELECT @idValorCalificación = idValorCalificación
		FROM ValoresCalificación
		WHERE @valorCalificación = valorNumérico;

		DECLARE @idDetalleAdicional INT;
		-- Busca si existe ya el detalle añadido a la tabla detalles.
		-- Si ya existe, guarda el id de ese detalle para almacenarlo en el nuevo
		-- registro de la tabla DetallesReseñas.
		SELECT @idDetalleAdicional = idDetalleAdicional
		FROM DetallesAdicionales 
		WHERE nombreDetalle = @detalle;
		-- Si no existe el detalle adicional, lo añade a la tabla y guarda el
		-- nuevo id generado.
		IF @idDetalleAdicional IS NULL
		BEGIN
			INSERT INTO DetallesAdicionales(nombreDetalle, descripciónDetalle)
			VALUES
				(@detalle, @descripciónDetalle);
			SET @idDetalleAdicional = SCOPE_IDENTITY();
		END;
		INSERT INTO DetallesReseñas(idDetalleAdicional, idValorCalificación, idReseña)
		VALUES 
			(@idDetalleAdicional, @idValorCalificación, @idReseña);
		SET @idDetalleReseña = SCOPE_IDENTITY()
	END;
END;
GO
-- Procedimiento 3: registra a un usuario que es guía
CREATE OR ALTER PROCEDURE registrarUsuarioGuía
	@nombreUsuario VARCHAR(50),
	@apellidoUsuario VARCHAR(50),
	@nombrePerfil VARCHAR(50),
	@contraseñaPerfil VARCHAR(50),
	@documentoUsuario VARCHAR(25),
	@Eps VARCHAR(50),
	@email VARCHAR(254),
	@fotoDePerfil VARCHAR(30),
	@pesoFotoDePerfil INT,
	@formatoFotoDePerfil VARCHAR(30),
	@esVerificado BIT,
	@biografíaGuía VARCHAR(500),
	@descripciónGuía VARCHAR(500),
	@sitioPreferido VARCHAR(100)
AS
BEGIN
	SET NOCOUNT ON;
	DECLARE @idUsuario INT;
	DECLARE @idRol INT;
	DECLARE @idFotoDePerfil INT;
	DECLARE @idTipoFormato INT;
	DECLARE @idEps INT;
	SELECT @idFotoDePerfil = idArchivoMultimedia
	FROM ArchivosMultimedia
	WHERE @fotoDePerfil = nombreArchivoMultimedia;
	SELECT @idTipoFormato = idTipoFormato
	FROM TiposDeFormato
	WHERE @formatoFotoDePerfil = nombreTipoFormato; 
	-- Verifica si ya está subida la foto de perfil.
	-- Si no lo está, la registra en la tabla archivos multimedia.

	-- El formato no se verifica pues solo habrán ciertos tipos de formatos
	-- admitidos predefinidos.
	IF @idFotoDePerfil IS NULL
	BEGIN
		INSERT INTO ArchivosMultimedia(nombreArchivoMultimedia, pesoEnMB, idTipoFormato)
		VALUES
			(@fotoDePerfil, @pesoFotoDePerfil, @idTipoFormato);
		SET @idFotoDePerfil = SCOPE_IDENTITY();
	END;
	SELECT @idEps = idEps
	FROM Eps
	WHERE nombreEps = @Eps;
	INSERT INTO Usuarios(nombreUsuario, apellidoUsuario, documentoUsuario, idEps)
	VALUES 
		(@nombreUsuario, @apellidoUsuario, @documentoUsuario, @idEps);
	SET @idUsuario = SCOPE_IDENTITY();
	SELECT @idRol = idRol
	FROM Roles
	WHERE nombreRol = 'Guía';
	INSERT INTO Perfiles(idPerfilUsuario, nombrePerfiL, contraseñaPerfil, emailPerfil, idFotoDePerfil, idRol, fechaCreaciónPerfil)
	VALUES 
		(@idUsuario, @nombrePerfil, @contraseñaPerfil, @email, @idFotoDePerfil, @idRol, GETDATE());
	DECLARE @idSitioPreferidoPorElGuía INT;
	SELECT @idSitioPreferidoPorElGuía = idSitio
	FROM Sitios
	WHERE @sitioPreferido = nombreSitio;
	INSERT INTO Guías(idPerfilGuía, esVerificado, biografíaGuía, descripciónGuía, idSitioGuía)
	VALUES
		(@idUsuario, @esVerificado, @biografíaGuía, @descripciónGuía, @idSitioPreferidoPorElGuía)
END;
GO
-- Procedimiento 4: registra a un usuario si solo es turista
CREATE OR ALTER PROCEDURE registrarUsuarioTurista
	@nombreUsuario VARCHAR(50),
	@apellidoUsuario VARCHAR(50),
	@nombrePerfil VARCHAR(50),
	@contraseñaPerfil VARCHAR(50),
	@documentoUsuario VARCHAR(25),
	@Eps VARCHAR(50),
	@email VARCHAR(254),
	@fotoDePerfil VARCHAR(30),
	@pesoFotoDePerfil DECIMAL(9, 2),
	@formatoFotoDePerfil VARCHAR(30)
AS
BEGIN
	SET NOCOUNT ON;
	DECLARE @idUsuario INT;
	DECLARE @idRol INT;
	DECLARE @idFotoDePerfil INT;
	DECLARE @idTipoFormato INT;
	DECLARE @idEps INT;
	SELECT @idFotoDePerfil = idArchivoMultimedia
	FROM ArchivosMultimedia
	WHERE @fotoDePerfil = nombreArchivoMultimedia;
	SELECT @idTipoFormato = idTipoFormato
	FROM TiposDeFormato
	WHERE @formatoFotoDePerfil = nombreTipoFormato; 
	-- Verifica si ya está subida la foto de perfil.
	-- Si no lo está, la registra en la tabla archivos multimedia.

	-- El formato no se verifica pues solo habrán ciertos tipos de formatos
	-- admitidos predefinidos.
	IF @idFotoDePerfil IS NULL
	BEGIN
		INSERT INTO ArchivosMultimedia(nombreArchivoMultimedia, pesoEnMB, idTipoFormato)
		VALUES
			(@fotoDePerfil, @pesoFotoDePerfil, @idTipoFormato);
		SET @idFotoDePerfil = SCOPE_IDENTITY();
	END;
	SELECT @idEps = idEps
	FROM Eps
	WHERE nombreEps = @Eps;
	INSERT INTO Usuarios(nombreUsuario, apellidoUsuario, documentoUsuario, idEps)
	VALUES 
		(@nombreUsuario, @apellidoUsuario, @documentoUsuario, @idEps);
	SET @idUsuario = SCOPE_IDENTITY();
	SELECT @idRol = idRol
	FROM Roles
	WHERE nombreRol = 'Turista';
	INSERT INTO Perfiles(idPerfilUsuario,  nombrePerfiL, contraseñaPerfil, emailPerfil, idFotoDePerfil, idRol, fechaCreaciónPerfil)
	VALUES 
		(@idUsuario, @nombrePerfil, @contraseñaPerfil, @email, @idFotoDePerfil, @idRol, GETDATE());
	INSERT INTO Turistas (idPerfilTurista)
	VALUES
		(@idUsuario);
END;
GO
-- Procedimiento 5: registra a un usuario si tiene ambos roles (guía y turista)
CREATE OR ALTER PROCEDURE registrarUsuarioTuristaGuía
	@nombreUsuario VARCHAR(50),
	@apellidoUsuario VARCHAR(50),
	@nombrePerfil VARCHAR(50),
	@contraseñaPerfil VARCHAR(50),
	@documentoUsuario VARCHAR(25),
	@Eps VARCHAR(50),
	@email VARCHAR(254),
	@fotoDePerfil VARCHAR(30),
	@pesoFotoDePerfil DECIMAL(9,2),
	@formatoFotoDePerfil VARCHAR(30),
	@rolPrincipal VARCHAR(10),
	@esVerificado BIT,
	@biografíaGuía VARCHAR(500),
	@descripciónGuía VARCHAR(500),
	@sitioPreferido VARCHAR(100)
AS
BEGIN
	SET NOCOUNT ON;
	DECLARE @idUsuario INT;
	DECLARE @idRol INT;
	DECLARE @idFotoDePerfil INT;
	DECLARE @idTipoFormato INT;
	DECLARE @idEps INT;
	SELECT @idFotoDePerfil = idArchivoMultimedia
	FROM ArchivosMultimedia
	WHERE @fotoDePerfil = nombreArchivoMultimedia;
	SELECT @idTipoFormato = idTipoFormato
	FROM TiposDeFormato
	WHERE @formatoFotoDePerfil = nombreTipoFormato; 
	-- Verifica si ya está subida la foto de perfil.
	-- Si no lo está, la registra en la tabla archivos multimedia.
	-- El formato no se verifica pues solo habrán ciertos tipos de formatos
	-- admitidos predefinidos.
	IF @idFotoDePerfil IS NULL
	BEGIN
		INSERT INTO ArchivosMultimedia(nombreArchivoMultimedia, pesoEnMB, idTipoFormato)
		VALUES
			(@fotoDePerfil, @pesoFotoDePerfil, @idTipoFormato);
		SET @idFotoDePerfil = SCOPE_IDENTITY();
	END;
	SELECT @idEps = idEps
	FROM Eps
	WHERE nombreEps = @Eps;
	INSERT INTO Usuarios(nombreUsuario, apellidoUsuario, documentoUsuario, idEps)
	VALUES 
		(@nombreUsuario, @apellidoUsuario, @documentoUsuario, @idEps);
	SET @idUsuario = SCOPE_IDENTITY();
	SELECT @idRol = idRol
	FROM Roles
	WHERE nombreRol = @rolPrincipal;
	INSERT INTO Perfiles (idPerfilUsuario, nombrePerfiL, contraseñaPerfil, emailPerfil, idFotoDePerfil, idRol, fechaCreaciónPerfil)
	VALUES 
		(@idUsuario, @nombrePerfil, @contraseñaPerfil, @email, @idFotoDePerfil, @idRol, GETDATE());
	INSERT INTO Turistas (idPerfilTurista)
	VALUES
		(@idUsuario);
	DECLARE @idSitioPreferidoPorElGuía INT;
	SELECT @idSitioPreferidoPorElGuía = idSitio
	FROM Sitios
	WHERE @sitioPreferido = nombreSitio;
	INSERT INTO Guías(idPerfilGuía, esVerificado, biografíaGuía, descripciónGuía, idSitioGuía)
	VALUES
		(@idUsuario, @esVerificado, @biografíaGuía, @descripciónGuía, @idSitioPreferidoPorElGuía);
END;
GO
-- Procedimiento 6: actualiza la contraseña de un usuario solo si se ingresa la antigua contraseña adecuadamente
-- (para implementar la función de cambio de contraseña en el sistema)
CREATE OR ALTER PROCEDURE actualizarContraseña 
	@nombrePerfil VARCHAR(50),
	@emailPerfil VARCHAR(254),
	@antiguaContraseña VARCHAR(50),
	@nuevaContraseña VARCHAR(50)
AS
BEGIN
	SET NOCOUNT ON;
	DECLARE @idPerfil INT;
	SELECT @idPerfil = idPerfilUsuario
	FROM Perfiles 
	WHERE nombrePerfiL = @nombrePerfil;
	DECLARE @coincideContraseña BIT;
	SELECT @coincideContraseña  =
			CASE 
				WHEN COUNT(*) = 0 THEN 0
				ELSE 1
			END
	FROM Perfiles 
	WHERE idPerfilUsuario = @idPerfil AND @antiguaContraseña = contraseñaPerfil;
	IF @coincideContraseña = 0
		RAISERROR ('la antigua contraseña ingresada no coincide', 16, 1);
	ELSE 
	BEGIN
		UPDATE Perfiles
		SET contraseñaPerfil = @nuevaContraseña
		WHERE idPerfilUsuario = @idPerfil;
	END;
END; 
GO
-- Procedimiento 7: registra una reserva en la base de datos
CREATE OR ALTER PROCEDURE reservar
	@nombrePerfilQueReserva VARCHAR(50),
	@cuposReservados INT,
	@idSesiónTour INT
AS
BEGIN
	SET NOCOUNT ON;
	DECLARE @idPerfil INT;
	DECLARE @existeSesión BIT;
	DECLARE @esTurista BIT;
	DECLARE @idRolTurista INT;
	DECLARE @ahora DATETIME2 = GETDATE(); -- Para evitar conflictos de implementación
	-- Se busca cuál es el índice correspondiente al turista en la tabla roles
	SELECT @idRolTurista = idRol
	FROM Roles
	WHERE nombreRol = 'Turista';
	-- Se selecciona el id del perfil del usuario y un booleano para indicar si es turista
	SELECT @idPerfil = idPerfilUsuario, 
		@esTurista = 
		CASE 
			WHEN idRol = @idRolTurista THEN 1
			ELSE 0
		END
	FROM Perfiles
	WHERE nombrePerfiL = @nombrePerfilQueReserva;
	-- Se verifica si existe la sesión en la base de datos
	SELECT @existeSesión =
		CASE
			WHEN COUNT(*) = 0 THEN 0
			ELSE 1
		END
	FROM SesionesTour
	WHERE idSesiónTour = @idSesiónTour;
	IF @idPerfil IS NULL
		RAISERROR('Perfil que intenta reservar no existe', 16, 1);
	ELSE IF @existeSesión = 0
		RAISERROR('No existe esa sesión para reservar', 16, 1);
	ELSE
	BEGIN
		INSERT INTO Reservas(idTurista, cuposReservados, idSesiónTour, fechaRealizaciónReserva)
		VALUES (@idPerfil, @cuposReservados, @idSesiónTour, @ahora);
		DECLARE @idEstadoConfirmado INT;
		SELECT @idEstadoConfirmado = idEstadoReserva
		FROM EstadosReserva
		WHERE nombreEstado = 'Confirmada';
		INSERT INTO EstadosPorReserva(idReserva, idEstado, fechaInicioEstado)
		VALUES (SCOPE_IDENTITY(), @idEstadoConfirmado, @ahora);
	END;
END;
GO
-- Procedimiento 8: cambia el estado de una reserva
CREATE OR ALTER PROCEDURE cambiarEstadoReserva
	@idReserva INT,
	@nuevoEstado VARCHAR(20),
	@descripciónCambioDeEstado VARCHAR(500)
AS
BEGIN
	SET NOCOUNT ON;
	UPDATE EstadosPorReserva
	SET fechaFinEstado = GETDATE()
	WHERE fechaFinEstado IS NULL AND idReserva = @idReserva;
	DECLARE @idEstado INT;
	SELECT @idEstado = idEstadoReserva
	FROM EstadosReserva
	WHERE nombreEstado = @nuevoEstado;
	INSERT INTO EstadosPorReserva(idReserva, idEstado, descripciónEstadosPorReserva, fechaInicioEstado)
	VALUES (@idReserva, @idEstado, @descripciónCambioDeEstado, GETDATE());
END

GO
-- Procedimiento 9: registra un teléfono en la base de datos
CREATE OR ALTER PROCEDURE registrarTeléfono
    @númeroTeléfono VARCHAR(20),
    @observacionesTeléfono VARCHAR(500) = NULL,
    @esPrincipal BIT = 0,
    @idTipoTeléfono INT,
    @idPaís INT,
    @idUsuario INT = NULL,
    @idPrestadorServicio INT = NULL,
    @idEps INT = NULL,
    @idTeléfono INT OUT
AS
BEGIN
    SET NOCOUNT ON;
	-- Cuenta la cantidad de opciones a ingresar como teléfono elegidas por el administrador
    DECLARE @contador INT =
        (CASE WHEN @idUsuario IS NULL THEN 0 ELSE 1 END) +
        (CASE WHEN @idPrestadorServicio IS NULL THEN 0 ELSE 1 END) +
        (CASE WHEN @idEps IS NULL THEN 0 ELSE 1 END)
    IF @contador <> 1
    BEGIN
        RAISERROR ('Debe especificar únicamente una entidad: Usuario, Prestador o EPS.', 16, 1);
        RETURN;
    END;
	DECLARE @ExisteTipoTeléfono BIT;
	SELECT @ExisteTipoTeléfono = 
		CASE 
			WHEN COUNT(*) = 0 THEN 0
			ELSE 1
		END
	FROM TiposTeléfonos 
	WHERE idTipoTeléfono = @idTipoTeléfono;
    IF @ExisteTipoTeléfono = 0
    BEGIN
        RAISERROR ('El tipo de teléfono especificado no existe.', 16, 1);
        RETURN;
    END;
	DECLARE @ExistePaís BIT;
	SELECT @ExistePaís = 
		CASE 
			WHEN COUNT(*) = 0 THEN 0
			ELSE 1
		END
	FROM Países 
	WHERE idPaís = @idPaís;
    IF @ExistePaís = 0
    BEGIN
        RAISERROR ('El país especificado no existe.', 16, 1);
        RETURN;
    END;
    INSERT INTO Teléfonos(númeroTeléfono, observacionesTeléfono, esPrincipal, idTipoTeléfono, idPaís)
    VALUES (@númeroTeléfono, @observacionesTeléfono, @esPrincipal, @idTipoTeléfono, @idPaís);
    SET @idTeléfono = SCOPE_IDENTITY();
    IF @idUsuario IS NOT NULL
    BEGIN
        INSERT INTO TeléfonosUsuarios (idTeléfono, idUsuario)
        VALUES (@idTeléfono, @idUsuario);
    END;
    IF @idPrestadorServicio IS NOT NULL
    BEGIN
        INSERT INTO TeléfonosPrestadoresDeServicio (idTeléfono, idPrestadorServicio)
        VALUES (@idTeléfono, @idPrestadorServicio);
    END;
    IF @idEps IS NOT NULL
    BEGIN
        INSERT INTO TeléfonosEps (idTeléfono, idEps)
        VALUES (@idTeléfono, @idEps);
    END;
END;
GO
-- Procedimiento 10: sube un archivo multimedia en un tipo de formato especificado.
-- Si el formato no existe, lo añade a la base de datos.
CREATE OR ALTER PROCEDURE subirArchivoMultimedia
	@nombreArchivo VARCHAR(50),
	@pesoEnMB DECIMAL(9, 2),
	@tipoFormato VARCHAR(30)
AS
BEGIN
	SET NOCOUNT ON;
	DECLARE @idTipoFormato INT;
	SELECT @idTipoFormato = idTipoFormato
	FROM TiposDeFormato
	WHERE nombreTipoFormato = @tipoFormato;
	IF @idTipoFormato IS NULL
	BEGIN	
		INSERT INTO TiposDeFormato(nombreTipoFormato)
		VALUES (@tipoFormato)
		SET @idTipoFormato = SCOPE_IDENTITY()
	END;
	INSERT INTO ArchivosMultimedia(nombreArchivoMultimedia, pesoEnMB, idTipoFormato)
	VALUES (@nombreArchivo, @pesoEnMB, @idTipoFormato);
END;