USE Freetour;
GO
-- Procedimiento 1: registra una rese�a en la base de datos.
CREATE OR ALTER PROCEDURE registrarRese�a
	@comentarioRese�a VARCHAR(500),
	@idUsuario INT,
	@valorCalificaci�n INT,
	@idRese�a INT OUT
AS
BEGIN
	SET NOCOUNT ON;
	-- Verifica que el valor de la calificaci�n a ingresar sea correcto.
	DECLARE @EsCalificaci�nV�lida BIT = 
		CASE 
			WHEN @valorCalificaci�n BETWEEN 0 AND 5 THEN 1
			ELSE 0
		END;
	IF @EsCalificaci�nV�lida = 0
		RAISERROR ('Calificaci�n fuera del rango v�lido (0 - 5)', 16, 1);

	ELSE
	BEGIN
		--verificamos si el usuario existe en la base de datos (se pudo hacer con EXISTS)
		DECLARE @idPerfilUsuario INT;
		SELECT @idPerfilUsuario = idPerfilUsuario
		FROM Perfiles p
		JOIN Usuarios u ON u.idUsuario = p.idPerfilUsuario
		WHERE u.idUsuario = @idUsuario;

		IF @idPerfilUsuario IS NULL 
			RAISERROR('Usuario no registrado en la plataforma', 16, 1);
		ELSE
		BEGIN
			--Inicio Procedimiento, Fin de validaciones 

			--Obtenemos el id del valor de la calificaci�n
			DECLARE @idValorCalificaci�n INT;
			SELECT @idValorCalificaci�n = idValorCalificaci�n
			FROM ValoresCalificaci�n
			WHERE valorNum�rico = @valorCalificaci�n;

			--insetamos valores
			INSERT INTO Rese�as(fechaPublicaci�nRese�a, comentarioRese�a, idPerfil, idValorCalificaci�n)
			VALUES
			(GETDATE(), @comentarioRese�a, @idPerfilUsuario, @idValorCalificaci�n);

			--retornamos la rese�a nueva 
			SET @idRese�a = SCOPE_IDENTITY();
		END;
	END;
END;
GO


-- Procedimiento 2: a�ade detalles a una rese�a ya registrada.
CREATE OR ALTER PROCEDURE a�adirDetalleRese�a
	@idRese�a INT,
	@detalle VARCHAR(50),
	@descripci�nDetalle VARCHAR(500) = NULL,
	@valorCalificaci�n INT,
	@idDetalleRese�a INT OUT
AS 
BEGIN
	SET NOCOUNT ON;
	DECLARE @esCalificaci�nV�lida BIT = 
		CASE 
			WHEN @valorCalificaci�n BETWEEN 0 AND 5 THEN 1
			ELSE 0
		END;
	IF @esCalificaci�nV�lida = 0
		RAISERROR ('Calificaci�n fuera del rango v�lido (0 - 5)', 16, 1);
	ELSE
	BEGIN
		DECLARE @idValorCalificaci�n INT;
		SELECT @idValorCalificaci�n = idValorCalificaci�n
		FROM ValoresCalificaci�n
		WHERE @valorCalificaci�n = valorNum�rico;

		DECLARE @idDetalleAdicional INT;
		-- Busca si existe ya el detalle a�adido a la tabla detalles.
		-- Si ya existe, guarda el id de ese detalle para almacenarlo en el nuevo
		-- registro de la tabla DetallesRese�as.
		SELECT @idDetalleAdicional = idDetalleAdicional
		FROM DetallesAdicionales 
		WHERE nombreDetalle = @detalle;
		-- Si no existe el detalle adicional, lo a�ade a la tabla y guarda el
		-- nuevo id generado.
		IF @idDetalleAdicional IS NULL
		BEGIN
			INSERT INTO DetallesAdicionales(nombreDetalle, descripci�nDetalle)
			VALUES
				(@detalle, @descripci�nDetalle);
			SET @idDetalleAdicional = SCOPE_IDENTITY();
		END;
		INSERT INTO DetallesRese�as(idDetalleAdicional, idValorCalificaci�n, idRese�a)
		VALUES 
			(@idDetalleAdicional, @idValorCalificaci�n, @idRese�a);
		SET @idDetalleRese�a = SCOPE_IDENTITY()
	END;
END;
GO


-- Procedimiento 3: registra a un usuario que es gu�a
CREATE OR ALTER PROCEDURE registrarUsuarioGu�a
	@nombreUsuario VARCHAR(50),
	@apellidoUsuario VARCHAR(50),
	@nombrePerfil VARCHAR(50),
	@contrase�aPerfil VARCHAR(50),
	@documentoUsuario VARCHAR(25),
	@Eps VARCHAR(50),
	@email VARCHAR(254),
	@fotoDePerfil VARCHAR(30),
	@pesoFotoDePerfil INT,
	@formatoFotoDePerfil VARCHAR(30),
	@esVerificado BIT,
	@biograf�aGu�a VARCHAR(500),
	@descripci�nGu�a VARCHAR(500),
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
	-- Verifica si ya est� subida la foto de perfil.
	-- Si no lo est�, la registra en la tabla archivos multimedia.

	-- El formato no se verifica pues solo habr�n ciertos tipos de formatos
	-- admitidos predefinidos.
	IF @idFotoDePerfil IS NULL
	BEGIN
		INSERT INTO ArchivosMultimedia(nombreArchivoMultimedia, pesoEnMB, idTipoFormato)
		VALUES
			(@fotoDePerfil, @pesoFotoDePerfil, @idTipoFormato);
		SET @idFotoDePerfil = SCOPE_IDENTITY();
	END;

	--obtenemos el id de la EPS a partir de su nombre
	SELECT @idEps = idEps
	FROM Eps
	WHERE nombreEps = @Eps;

	--registramos el usario 
	INSERT INTO Usuarios(nombreUsuario, apellidoUsuario, documentoUsuario, idEps)
	VALUES 
		(@nombreUsuario, @apellidoUsuario, @documentoUsuario, @idEps);
	SET @idUsuario = SCOPE_IDENTITY();

	--procedemos a registrarlo como gu�a, primero registramos su perfil

	--Obtenemos el id del rol
	SELECT @idRol = idRol
	FROM Roles
	WHERE nombreRol = 'Gu�a';

	--insetamos el perfil del usuario
	INSERT INTO Perfiles(idPerfilUsuario, nombrePerfiL, contrase�aPerfil, emailPerfil, idFotoDePerfil, idRol, fechaCreaci�nPerfil)
	VALUES 
		(@idUsuario, @nombrePerfil, @contrase�aPerfil, @email, @idFotoDePerfil, @idRol, GETDATE());

	DECLARE @idSitioPreferidoPorElGu�a INT;
	SELECT @idSitioPreferidoPorElGu�a = idSitio
	FROM Sitios
	WHERE @sitioPreferido = nombreSitio;

	--insertamos en gu�as 
	INSERT INTO Gu�as(idPerfilGu�a, esVerificado, biograf�aGu�a, descripci�nGu�a, idSitioGu�a)
	VALUES
		(@idUsuario, @esVerificado, @biograf�aGu�a, @descripci�nGu�a, @idSitioPreferidoPorElGu�a)
END;
GO


-- Procedimiento 4: registra a un usuario si solo es turista
CREATE OR ALTER PROCEDURE registrarUsuarioTurista
	@nombreUsuario VARCHAR(50),
	@apellidoUsuario VARCHAR(50),
	@nombrePerfil VARCHAR(50),
	@contrase�aPerfil VARCHAR(50),
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

	--obtenemos el id de la foto de perfil
	SELECT @idFotoDePerfil = idArchivoMultimedia
	FROM ArchivosMultimedia
	WHERE @fotoDePerfil = nombreArchivoMultimedia;

	SELECT @idTipoFormato = idTipoFormato
	FROM TiposDeFormato
	WHERE @formatoFotoDePerfil = nombreTipoFormato; 
	-- Verifica si ya est� subida la foto de perfil.
	-- Si no lo est�, la registra en la tabla archivos multimedia.

	-- El formato no se verifica pues solo habr�n ciertos tipos de formatos
	-- admitidos predefinidos.
	IF @idFotoDePerfil IS NULL
	BEGIN
		INSERT INTO ArchivosMultimedia(nombreArchivoMultimedia, pesoEnMB, idTipoFormato)
		VALUES
			(@fotoDePerfil, @pesoFotoDePerfil, @idTipoFormato);
		SET @idFotoDePerfil = SCOPE_IDENTITY();
	END;

	--obtenemos el id de la EPS
	SELECT @idEps = idEps
	FROM Eps
	WHERE nombreEps = @Eps;

	--Insertamos en usuarios
	INSERT INTO Usuarios(nombreUsuario, apellidoUsuario, documentoUsuario, idEps)
	VALUES 
		(@nombreUsuario, @apellidoUsuario, @documentoUsuario, @idEps);
	SET @idUsuario = SCOPE_IDENTITY();

	--Insertamos ahora el turista, pero primero necesitamos registrar su perfil

	--obtenemos el id del rol
	SELECT @idRol = idRol
	FROM Roles
	WHERE nombreRol = 'Turista';

	--insetamos en el perfil
	INSERT INTO Perfiles(idPerfilUsuario,  nombrePerfiL, contrase�aPerfil, emailPerfil, idFotoDePerfil, idRol, fechaCreaci�nPerfil)
	VALUES 
		(@idUsuario, @nombrePerfil, @contrase�aPerfil, @email, @idFotoDePerfil, @idRol, GETDATE());

	--insetamos el turista
	INSERT INTO Turistas (idPerfilTurista)
	VALUES
		(@idUsuario);
END;
GO


-- Procedimiento 5: registra a un usuario si tiene ambos roles (gu�a y turista)
CREATE OR ALTER PROCEDURE registrarUsuarioTuristaGu�a
	@nombreUsuario VARCHAR(50),
	@apellidoUsuario VARCHAR(50),
	@nombrePerfil VARCHAR(50),
	@contrase�aPerfil VARCHAR(50),
	@documentoUsuario VARCHAR(25),
	@Eps VARCHAR(50),
	@email VARCHAR(254),
	@fotoDePerfil VARCHAR(30),
	@pesoFotoDePerfil DECIMAL(9,2),
	@formatoFotoDePerfil VARCHAR(30),
	@rolPrincipal VARCHAR(10),
	@esVerificado BIT,
	@biograf�aGu�a VARCHAR(500),
	@descripci�nGu�a VARCHAR(500),
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
	-- Verifica si ya est� subida la foto de perfil.
	-- Si no lo est�, la registra en la tabla archivos multimedia.
	-- El formato no se verifica pues solo habr�n ciertos tipos de formatos
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

	--ingresamos el usuario
	INSERT INTO Usuarios(nombreUsuario, apellidoUsuario, documentoUsuario, idEps)
	VALUES 
		(@nombreUsuario, @apellidoUsuario, @documentoUsuario, @idEps);
	SET @idUsuario = SCOPE_IDENTITY();

	--colocamos el rol principal 
	SELECT @idRol = idRol
	FROM Roles
	WHERE nombreRol = @rolPrincipal;

	--insertamos el perfil
	INSERT INTO Perfiles (idPerfilUsuario, nombrePerfiL, contrase�aPerfil, emailPerfil, idFotoDePerfil, idRol, fechaCreaci�nPerfil)
	VALUES 
		(@idUsuario, @nombrePerfil, @contrase�aPerfil, @email, @idFotoDePerfil, @idRol, GETDATE());

	--insertamos en turista
	INSERT INTO Turistas (idPerfilTurista)
	VALUES
		(@idUsuario);

	DECLARE @idSitioPreferidoPorElGu�a INT;
	SELECT @idSitioPreferidoPorElGu�a = idSitio
	FROM Sitios
	WHERE @sitioPreferido = nombreSitio;

	--insertamos en gu�a
	INSERT INTO Gu�as(idPerfilGu�a, esVerificado, biograf�aGu�a, descripci�nGu�a, idSitioGu�a)
	VALUES
		(@idUsuario, @esVerificado, @biograf�aGu�a, @descripci�nGu�a, @idSitioPreferidoPorElGu�a);
END;
GO


-- Procedimiento 6: actualiza la contrase�a de un usuario solo si se ingresa la antigua contrase�a adecuadamente
-- (para implementar la funci�n de cambio de contrase�a en el sistema)
CREATE OR ALTER PROCEDURE actualizarContrase�a 
	@nombrePerfil VARCHAR(50),
	@emailPerfil VARCHAR(254),
	@antiguaContrase�a VARCHAR(50),
	@nuevaContrase�a VARCHAR(50)
AS
BEGIN
	SET NOCOUNT ON;

	--obtenemos el id del perfil
	DECLARE @idPerfil INT;
	SELECT @idPerfil = idPerfilUsuario
	FROM Perfiles 
	WHERE nombrePerfiL = @nombrePerfil;

	--corroboramos la contrase�a
	DECLARE @coincideContrase�a BIT;
	SELECT @coincideContrase�a  =
			CASE 
				WHEN COUNT(*) = 0 THEN 0
				ELSE 1
			END
	FROM Perfiles 
	WHERE idPerfilUsuario = @idPerfil AND @antiguaContrase�a = contrase�aPerfil;

	--validamos
	IF @coincideContrase�a = 0
		RAISERROR ('la antigua contrase�a ingresada no coincide', 16, 1);
	ELSE 
	BEGIN
		--realizamos el update
		UPDATE Perfiles
		SET contrase�aPerfil = @nuevaContrase�a
		WHERE idPerfilUsuario = @idPerfil;
	END;
END; 
GO


-- Procedimiento 7: registra una reserva en la base de datos
CREATE OR ALTER PROCEDURE reservar
	@nombrePerfilQueReserva VARCHAR(50),
	@cuposReservados INT,
	@idSesi�nTour INT
AS
BEGIN
	SET NOCOUNT ON;
	DECLARE @idPerfil INT;
	DECLARE @existeSesi�n BIT;
	DECLARE @esTurista BIT;
	DECLARE @idRolTurista INT;
	DECLARE @ahora DATETIME2 = GETDATE(); 
	-- Para evitar conflictos de implementaci�n
	-- Se busca cu�l es el �ndice correspondiente al turista en la tabla roles

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

	-- Se verifica si existe la sesi�n en la base de datos
	SELECT @existeSesi�n =
		CASE
			WHEN COUNT(*) = 0 THEN 0
			ELSE 1
		END
	FROM SesionesTour
	WHERE idSesi�nTour = @idSesi�nTour;

	--validamos 
	IF @idPerfil IS NULL
		RAISERROR('Perfil que intenta reservar no existe', 16, 1);
	ELSE IF @existeSesi�n = 0
		RAISERROR('No existe esa sesi�n para reservar', 16, 1);
	ELSE
	BEGIN
		INSERT INTO Reservas(idTurista, cuposReservados, idSesi�nTour, fechaRealizaci�nReserva)
		VALUES (@idPerfil, @cuposReservados, @idSesi�nTour, @ahora);

		--obtenemos el id del estado 'Confirmada' para hacer la inserci�n
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
	@descripci�nCambioDeEstado VARCHAR(500)
AS
BEGIN
	SET NOCOUNT ON;

	--actualizamos la fecha fin del estado
	UPDATE EstadosPorReserva
	SET fechaFinEstado = GETDATE()
	WHERE fechaFinEstado IS NULL AND idReserva = @idReserva;

	--obtenemos el id del nuevo estado
	DECLARE @idEstado INT;
	SELECT @idEstado = idEstadoReserva
	FROM EstadosReserva
	WHERE nombreEstado = @nuevoEstado;

	--insertamos en la tabla
	INSERT INTO EstadosPorReserva(idReserva, idEstado, descripci�nEstadosPorReserva, fechaInicioEstado)
	VALUES (@idReserva, @idEstado, @descripci�nCambioDeEstado, GETDATE());
END

GO


-- Procedimiento 9: registra un tel�fono en la base de datos
CREATE OR ALTER PROCEDURE registrarTel�fono
    @n�meroTel�fono VARCHAR(20),
    @observacionesTel�fono VARCHAR(500) = NULL,
    @esPrincipal BIT = 0,
    @idTipoTel�fono INT,
    @idPa�s INT,
    @idUsuario INT = NULL,
    @idPrestadorServicio INT = NULL,
    @idEps INT = NULL,
    @idTel�fono INT OUT
AS
BEGIN
    SET NOCOUNT ON;
	-- Cuenta la cantidad de opciones a ingresar como tel�fono elegidas por el administrador
    DECLARE @contador INT =
        (CASE WHEN @idUsuario IS NULL THEN 0 ELSE 1 END) +
        (CASE WHEN @idPrestadorServicio IS NULL THEN 0 ELSE 1 END) +
        (CASE WHEN @idEps IS NULL THEN 0 ELSE 1 END)
    IF @contador <> 1
    BEGIN
        RAISERROR ('Debe especificar �nicamente una entidad: Usuario, Prestador o EPS.', 16, 1);
        RETURN;
    END;

	--verifica si existe el tipo de tel�fono
	DECLARE @ExisteTipoTel�fono BIT;
	SELECT @ExisteTipoTel�fono = 
		CASE 
			WHEN COUNT(*) = 0 THEN 0
			ELSE 1
		END
	FROM TiposTel�fonos 
	WHERE idTipoTel�fono = @idTipoTel�fono;
	
	--validaci�n
    IF @ExisteTipoTel�fono = 0
    BEGIN
        RAISERROR ('El tipo de tel�fono especificado no existe.', 16, 1);
        RETURN;
    END;

	--verifica si existe el pa�s
	DECLARE @ExistePa�s BIT;
	SELECT @ExistePa�s = 
		CASE 
			WHEN COUNT(*) = 0 THEN 0
			ELSE 1
		END
	FROM Pa�ses 
	WHERE idPa�s = @idPa�s;

	--Valida
    IF @ExistePa�s = 0
    BEGIN
        RAISERROR ('El pa�s especificado no existe.', 16, 1);
        RETURN;
    END;

	--insertamos en tel�fonos (super entidad)
    INSERT INTO Tel�fonos(n�meroTel�fono, observacionesTel�fono, esPrincipal, idTipoTel�fono, idPa�s)
    VALUES (@n�meroTel�fono, @observacionesTel�fono, @esPrincipal, @idTipoTel�fono, @idPa�s);
    SET @idTel�fono = SCOPE_IDENTITY();

	--corrobora para cual de los tipos ser� clasificado el n�mero
    IF @idUsuario IS NOT NULL
    BEGIN
        INSERT INTO Tel�fonosUsuarios (idTel�fono, idUsuario)
        VALUES (@idTel�fono, @idUsuario);
    END;
    IF @idPrestadorServicio IS NOT NULL
    BEGIN
        INSERT INTO Tel�fonosPrestadoresDeServicio (idTel�fono, idPrestadorServicio)
        VALUES (@idTel�fono, @idPrestadorServicio);
    END;
    IF @idEps IS NOT NULL
    BEGIN
        INSERT INTO Tel�fonosEps (idTel�fono, idEps)
        VALUES (@idTel�fono, @idEps);
    END;
END;
GO


-- Procedimiento 10: sube un archivo multimedia en un tipo de formato especificado.
-- Si el formato no existe, lo a�ade a la base de datos.
CREATE OR ALTER PROCEDURE subirArchivoMultimedia
	@nombreArchivo VARCHAR(50),
	@pesoEnMB DECIMAL(9, 2),
	@tipoFormato VARCHAR(30)
AS
BEGIN
	SET NOCOUNT ON;

	--verificamos si existe el tipo de formato
	DECLARE @idTipoFormato INT;
	SELECT @idTipoFormato = idTipoFormato
	FROM TiposDeFormato
	WHERE nombreTipoFormato = @tipoFormato;

	--validaci�n
	IF @idTipoFormato IS NULL
	BEGIN	
		INSERT INTO TiposDeFormato(nombreTipoFormato)
		VALUES (@tipoFormato)
		SET @idTipoFormato = SCOPE_IDENTITY()
	END;

	--si est� registrado el tipo de formato...
	INSERT INTO ArchivosMultimedia(nombreArchivoMultimedia, pesoEnMB, idTipoFormato)
	VALUES (@nombreArchivo, @pesoEnMB, @idTipoFormato);
END;
