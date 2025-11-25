USE PRUEBA_PROYECTO;
GO

CREATE TABLE Regiones (
	idRegi�n INT IDENTITY(1, 1) PRIMARY KEY,
	nombreRegi�n VARCHAR(100) NOT NULL CHECK (TRIM(nombreRegi�n) <> ''),
	descripci�nRegi�n VARCHAR(500) NULL CHECK (TRIM(descripci�nRegi�n) <> ''),
	superficieRegi�n DECIMAL(10, 2) NULL CHECK (superficieRegi�n > 0),
	CONSTRAINT NombreRegi�nV�lido CHECK (nombreRegi�n NOT LIKE '%[0-9]%')
);

CREATE TABLE Departamentos (
	idDepartamento INT IDENTITY(1, 1) PRIMARY KEY,
	nombreDepartamento VARCHAR(100) NOT NULL CHECK (TRIM(nombreDepartamento) <> ''),
	descripci�nDepartamento VARCHAR(500) NULL CHECK (TRIM(descripci�nDepartamento) <> ''),
	c�digoDane INT NOT NULL CHECK (c�digoDane > 0),
	idRegi�n INT REFERENCES Regiones(idRegi�n),
	CONSTRAINT NombreDepartamentoV�lido CHECK (nombreDepartamento NOT LIKE '%[0-9]%')
);

CREATE TABLE TiposDeLocalizaciones (
	idTipoLocalizaci�n INT IDENTITY(1, 1) PRIMARY KEY,
	nombreTipoLocalizaci�n VARCHAR(100) NOT NULL CHECK (TRIM(nombreTipoLocalizaci�n) <> ''),
	descripci�nTipoLocalizaci�n VARCHAR(500) CHECK (TRIM(descripci�nTipoLocalizaci�n) <> ''),
	CONSTRAINT NombreTipoLocalizaci�nV�lido CHECK (nombreTipoLocalizaci�n NOT LIKE '%[0-9]%')
); 

CREATE TABLE Sitios (
	idSitio INT IDENTITY(1, 1) PRIMARY KEY,
	nombreSitio VARCHAR(100) NOT NULL CHECK (TRIM(nombreSitio) <> ''),
	latitudSitio DECIMAL(8, 6) NOT NULL,
	longitudSitio DECIMAL(9, 6) NOT NULL,
	idTipoLocalizaci�n INT REFERENCES TiposDeLocalizaciones(idTipoLocalizaci�n),
	idDepartamento INT  REFERENCES Departamentos(idDepartamento),
	CONSTRAINT SitioEnRangoGeogr�ficoColombia CHECK (latitudSitio BETWEEN -4.2 AND 13.5
											AND longitudSitio BETWEEN -79.0 AND -66.0)
); -- la restricci�n que evita que no se puedan ingresar n�meros en el nombre de la entidad aqu� no es
   -- necesaria pues pueden existir sitios como "la 30" con n�meros en su nombre.


CREATE TABLE Climas (
	idClima INT IDENTITY(1, 1) PRIMARY KEY,
	nombreClima VARCHAR(100) NOT NULL CHECK (TRIM(nombreClima) <> ''),
	descripci�nClima VARCHAR(500) NULL CHECK (TRIM(descripci�nClima) <> ''),
	temperaturaPromedioClima DECIMAL(5, 2) NOT NULL,
	humedadPromedioClima DECIMAL(4, 2) NOT NULL, -- formato en porcentajes (ejemplo: 40 corresponde a 40%)
	CONSTRAINT TemperaturaEnCelsius CHECK (temperaturaPromedioClima > -273.15),
	CONSTRAINT HumedadPromedioEnFormatoPorcentual CHECK (humedadPromedioClima BETWEEN 0 AND 100)
);

CREATE TABLE ClimasPorDepartamentos (
	idClima INT  REFERENCES Climas(idClima),
	idDepartamento INT  REFERENCES Departamentos(idDepartamento),
	PRIMARY KEY (idClima, idDepartamento)
);

CREATE TABLE Eps (
	idEps INT IDENTITY(1, 1) PRIMARY KEY,
	NITEps VARCHAR(20) UNIQUE NOT NULL CHECK (TRIM(NITEps) <> ''),
	nombreEps VARCHAR(50) NOT NULL CHECK (TRIM(nombreEps) <> ''),
	direcci�nEps VARCHAR(50) NOT NULL CHECK (TRIM(direcci�nEps) <> ''),
	emailEps VARCHAR(254) UNIQUE NOT NULL,
	CONSTRAINT EmailEpsFormatoV�lido CHECK (emailEps LIKE '_%@_%._%')
);

CREATE TABLE Usuarios (
	idUsuario INT IDENTITY(1, 1) PRIMARY KEY,
	nombreUsuario VARCHAR(50) NOT NULL CHECK (TRIM(nombreUsuario) <> ''),
	apellidoUsuario VARCHAR(50) NOT NULL CHECK (TRIM(apellidoUsuario) <> ''),
	documentoUsuario VARCHAR(25) NOT NULL UNIQUE CHECK (TRIM(documentoUsuario) <> ''),
	idEps INT NULL REFERENCES Eps(idEps),
	activoUsuario BIT DEFAULT 1 not NULL,
	CONSTRAINT NombresUsuarioV�lido CHECK (nombreUsuario NOT LIKE '%[0-9]%'),
	CONSTRAINT ApellidoUsuarioV�lido CHECK (apellidoUsuario NOT LIKE '%[0-9]%'),
	CONSTRAINT DocumentoV�lido CHECK (LEN(documentoUsuario) >= 9)
);

CREATE TABLE TiposDeFormato (
	idTipoFormato INT IDENTITY(1, 1) PRIMARY KEY,
	nombreTipoFormato VARCHAR(30) NOT NULL CHECK (TRIM(nombreTipoFormato) <> ''),
	descripci�nTipoFormato VARCHAR(500) NULL CHECK (TRIM(descripci�nTipoFormato) <> '')
);

CREATE TABLE ArchivosMultimedia (
	idArchivoMultimedia INT IDENTITY(1, 1) PRIMARY KEY,
	nombreArchivoMultimedia VARCHAR(30) NOT NULL CHECK (TRIM(nombreArchivoMultimedia) <> ''),
	pesoEnMB DECIMAL(9,2) CHECK (pesoEnMB >= 0), -- a
	idTipoFormato INT NOT NULL REFERENCES TiposDeFormato(idTipoFormato)
);

CREATE TABLE Roles (
	idRol INT IDENTITY(1, 1) PRIMARY KEY,
	nombreRol VARCHAR(10) NOT NULL CHECK (TRIM(nombreRol) <> ''),
	CONSTRAINT RolV�lido CHECK (nombreRol IN ('Gu�a', 'Turista'))
);

CREATE TABLE Perfiles (
	idPerfilUsuario INT PRIMARY KEY REFERENCES Usuarios(idUsuario)ON DELETE NO ACTION ,
	nombrePerfil VARCHAR(50) UNIQUE CHECK (TRIM(nombrePerfil) <> ''),
	contrase�aPerfil VARCHAR(50) CHECK (TRIM(contrase�aPerfil) <> ''),
	emailPerfil VARCHAR(254) UNIQUE NOT NULL,
	idFotoDePerfil INT NULL REFERENCES ArchivosMultimedia(idArchivoMultimedia),
	idRol INT NOT NULL REFERENCES Roles(idRol),
	fechaCreaci�nPerfil DATE CHECK (fechaCreaci�nPerfil <= GETDATE()),
	CONSTRAINT EmailPerfilFormatoV�lido CHECK (emailPerfil LIKE '_%@_%._%')
);

CREATE TABLE Turistas (
	idPerfilTurista INT PRIMARY KEY  REFERENCES Perfiles(idPerfilUsuario)
);

CREATE TABLE Gu�as (
	idPerfilGu�a INT PRIMARY KEY  REFERENCES Perfiles(idPerfilUsuario),
	esVerificado BIT NOT NULL DEFAULT 0,
	biograf�aGu�a VARCHAR(500) NULL CHECK (TRIM(biograf�aGu�a) <> ''),
	descripci�nGu�a VARCHAR(500) NOT NULL CHECK (TRIM(descripci�nGu�a) <> ''),
	idSitioGu�a INT  REFERENCES Sitios(idSitio)
);

CREATE TABLE Idiomas (
	idIdioma INT IDENTITY(1, 1) PRIMARY KEY,
	nombreIdioma VARCHAR(30) NOT NULL UNIQUE CHECK (TRIM(nombreIdioma) <> ''),
	descripci�nIdioma VARCHAR(MAX) NULL CHECK (TRIM(descripci�nIdioma) <> '')
);

CREATE TABLE IdiomasPorPerfil (
	idIdioma INT  REFERENCES Idiomas(idIdioma) ON DELETE CASCADE,
	idPerfil INT  REFERENCES Perfiles(idPerfilUsuario) ON DELETE CASCADE,
	PRIMARY KEY (idIdioma, idPerfil)
);

CREATE TABLE RangosEdades (
	idRangoEdad INT IDENTITY(1, 1) PRIMARY KEY,
	nombreRangoEdad VARCHAR(25) NOT NULL CHECK (TRIM(nombreRangoEdad) <> ''),
	descripci�nRangoEdad VARCHAR(500) NULL,
	CONSTRAINT RangoEdadV�lido CHECK (nombreRangoEdad IN ('Para toda la familia', 'Para mayores de 10', 'Para mayores de 12', 'Para mayores de 17', 'Solo adultos'))
);

CREATE TABLE Tem�ticas (
	idTem�tica INT IDENTITY(1, 1) PRIMARY KEY,
	nombreTem�tica VARCHAR(50) NOT NULL CHECK (TRIM(nombreTem�tica) <> ''),
	descripci�nTem�tica VARCHAR(500) NULL CHECK (TRIM(descripci�nTem�tica) <> ''),
	idRangoEdadRecomendada INT NOT NULL  REFERENCES RangosEdades(idRangoEdad),
	CONSTRAINT NombreTem�ticaV�lida CHECK (nombreTem�tica NOT LIKE '%[0-9]%')
);

CREATE TABLE PuntosDeInter�s (
	idPuntoDeInter�s INT IDENTITY(1, 1) PRIMARY KEY,
	nombrePuntoDeInter�s VARCHAR(50) NOT NULL CHECK (TRIM(nombrePuntoDeInter�s) <> ''),
	descripcionPuntoDeInter�s VARCHAR(MAX) NULL CHECK (TRIM(descripcionPuntoDeInter�s) <> ''),
	latitudPuntoDeInter�s DECIMAL(8,6),
	longitudPuntoDeInter�s DECIMAL(9,6),
	CONSTRAINT PuntoEnRangoGeogr�ficoColombia CHECK (latitudPuntoDeInter�s BETWEEN -4.2 AND 13.5
											AND longitudPuntoDeInter�s BETWEEN -79.0 AND -66.0)
);

CREATE TABLE Tours (
	idTour INT IDENTITY(1, 1) PRIMARY KEY,
	nombreTour VARCHAR(30) NOT NULL CHECK (TRIM(nombreTour) <> ''),
	-- Puede que un punto de encuentro a�n no est� definido
	idPuntoDeEncuentroTour INT NULL REFERENCES PuntosDeInter�s(idPuntoDeInter�s),
	-- Puede que se desconozca temporalmente el m�ximo de participantes por tour
	maxParticipantesTour INT NULL CHECK (maxParticipantesTour > 0),
	-- Almacena la duraci�n del tour en horas, m�ximo 1 mes (30 d�as)
	duraci�nTour DECIMAL(4, 2) NULL,
	descripci�nTour VARCHAR(500) NULL CHECK (TRIM(descripci�nTour) <> ''),
	idGu�aPrincipalTour INT  REFERENCES Gu�as(idPerfilGu�a),
	idSitio INT  REFERENCES Sitios(idSitio),
	CONSTRAINT Duraci�nTourDentroDelRango CHECK (duraci�nTour BETWEEN 0 AND 720.00)
);

CREATE TABLE IdiomasPorTour (
	idIdioma INT  REFERENCES Idiomas(idIdioma),
	idTour INT  REFERENCES Tours(idTour),
	PRIMARY KEY (idIdioma, idTour)
);

CREATE TABLE Tem�ticasDelTour (
	idTem�tica INT  REFERENCES Tem�ticas(idTem�tica),
	idTour INT  REFERENCES Tours(idTour),
	PRIMARY KEY (idTem�tica, idTour)
);

CREATE TABLE puntosDeInter�sPorTour (
	idPuntoDeInter�sTour INT IDENTITY(1, 1) PRIMARY KEY,
	idPuntoDeInter�s INT  REFERENCES PuntosDeInter�s(idPuntoDeInter�s),
	idTour INT  REFERENCES Tours(idTour)
);

CREATE TABLE FechasTour (
	idFechaTour INT IDENTITY(1, 1) PRIMARY KEY,
	fecha DATE
);

CREATE TABLE FechasPorTour (
	idFechaTour INT  REFERENCES FechasTour(idFechaTour),
	idTour INT  REFERENCES Tours(idTour),
	PRIMARY KEY (idFechaTour, idTour)
);

CREATE TABLE SesionesTour (
	idSesi�nTour INT IDENTITY(1, 1) PRIMARY KEY,
	idFechaTour INT  REFERENCES FechasTour(idFechaTour),
	horaInicioSesi�n TIME,
	horaFinSesi�n TIME,
	idIdioma INT REFERENCES Idiomas(idIdioma),
	CONSTRAINT RangoSesi�nTourV�lido CHECK (horaInicioSesi�n <= horaFinSesi�n)
);

CREATE TABLE Reservas (
	idReserva INT IDENTITY(1, 1) PRIMARY KEY,
	idTurista INT  REFERENCES Turistas(idPerfilTurista),
	cuposReservados INT DEFAULT 1 CHECK (cuposReservados > 0),
	idSesi�nTour INT  REFERENCES SesionesTour(idSesi�nTour),
	fechaRealizaci�nReserva DATE,
	fechaFinalizaci�nReserva DATE NULL,
	CONSTRAINT FechasReservasV�lidas CHECK (fechaRealizaci�nReserva <= fechaFinalizaci�nReserva),
	CONSTRAINT FechaRealizaci�nReservaPasada CHECK (fechaRealizaci�nReserva <= GETDATE())
);

CREATE TABLE EstadosReserva (
	idEstadoReserva INT IDENTITY(1, 1) PRIMARY KEY,
	nombreEstado VARCHAR(20) NOT NULL CHECK (TRIM(nombreEstado) <> ''),
	-- Ejemplo: expirado = no se us� el servicio
	descripci�nEstado VARCHAR(500) NULL CHECK (TRIM(descripci�nEstado) <> ''), 
	CONSTRAINT NombreEstadoReservaV�lido CHECK (nombreEstado IN ('Pendiente', 'Confirmada', 'Cancelada', 'Finalizada', 'Expirada', 'En curso'))
);

CREATE TABLE EstadosPorReserva (
	idEstadosPorReserva INT IDENTITY(1, 1) PRIMARY KEY,
	idReserva INT  REFERENCES Reservas(idReserva),
	idEstado INT  REFERENCES EstadosReserva(idEstadoReserva),
	-- Explica el por qu� una reserva estuvo en un estado con m�s detalle
	descripci�nEstadosPorReserva VARCHAR(500) NULL,
	fechaInicioEstado DATETIME2 NOT NULL CHECK (fechaInicioEstado <= GETDATE()),
	fechaFinEstado DATETIME2 CHECK (fechaFinEstado <= GETDATE()),
	CONSTRAINT RangoFechasEstadoReservasV�lido CHECK (fechaInicioEstado <= fechaFinEstado)
);

-- Estados para tours y puntos de inter�s (trabaja en ese dominio)
CREATE TABLE Estados (
	idEstado INT IDENTITY(1, 1) PRIMARY KEY,
	nombreEstado VARCHAR(20) NOT NULL CHECK (TRIM(nombreEstado) <> ''),
	descripci�nEstado VARCHAR(500) NULL CHECK (TRIM(descripci�nEstado) <> '')
);

CREATE TABLE EstadosDelTour (
	idEstadoDelTour INT IDENTITY(1, 1) PRIMARY KEY,
	idEstado INT REFERENCES Estados(idEstado),
	idTour INT REFERENCES Tours(idTour)
	estadoActivo BIT DEFAULT 1 NOT NULL
);

CREATE TABLE EstadosDelPuntoDeInter�s (
	idEstadoDelPunto INT IDENTITY PRIMARY KEY,
	idEstado INT  REFERENCES Estados(idEstado),
	idPuntoDeInter�s INT  REFERENCES PuntosDeInter�s(idPuntoDeInter�s),
	fechaInicioEstado DATETIME2 CHECK (fechaInicioEstado <= GETDATE()),
	fechaFinEstado DATETIME2 CHECK (fechaFinEstado <= GETDATE()),
	descripci�nEstadoPorPunto VARCHAR(500) NULL CHECK(TRIM(descripci�nEstadoPorPunto) <> ''),
	CONSTRAINT RangoFechasEstadosPuntoDeInter�s CHECK (fechaInicioEstado <= fechaFinEstado)
);

CREATE TABLE Tem�ticasPreferidasPorGu�a (
	idGu�a INT  REFERENCES Gu�as(idPerfilGu�a),
	idTem�tica INT  REFERENCES Tem�ticas(idTem�tica),
	PRIMARY KEY (idGu�a, idTem�tica)
);
CREATE TABLE Tem�ticasPreferidaPorTurista (
	idTurista INT REFERENCES Turistas(idPerfilTurista),
	idTem�tica INT REFERENCES Tem�ticas(idTem�tica),
	PRIMARY KEY (idTurista, idTem�tica)
);

CREATE TABLE Servicios (
	idServicio INT IDENTITY(1, 1) PRIMARY KEY,
	nombreServicio VARCHAR(50) NOT NULL CHECK (TRIM(nombreServicio) <> ''),
	descripci�nServicio VARCHAR(500) NULL CHECK (TRIM(descripci�nServicio) <> ''),
	-- el servicio m�s caro puede ser de 99.999.999,99 
	costoServicio DECIMAL(10,2) NULL DEFAULT NULL CHECK (costoServicio > 0),
	idRangoEdad INT  REFERENCES RangosEdades(idRangoEdad)
);

CREATE TABLE Tem�ticasDelPuntoDeInter�s (
	idTem�tica INT  REFERENCES Tem�ticas(idTem�tica),
	idPuntoDeInter�s INT  REFERENCES PuntosDeInter�s(idPuntoDeInter�s),
	PRIMARY KEY (idTem�tica, idPuntoDeInter�s)
);

CREATE TABLE ServiciosPuntosDeInter�s (
	idServiciosDelPunto INT IDENTITY(1, 1) PRIMARY KEY,
	idPuntoDeInter�s INT  REFERENCES PuntosDeInter�s(idPuntoDeInter�s),
	idServicio INT  REFERENCES Servicios(idServicio)
);

CREATE TABLE DetallesAdicionales (
	idDetalleAdicional INT IDENTITY(1, 1) PRIMARY KEY,
	nombreDetalle VARCHAR(50) NOT NULL CHECK (TRIM(nombreDetalle) <> ''),
	descripci�nDetalle VARCHAR(500) NULL CHECK (TRIM(descripci�nDetalle) <> '')
);

CREATE TABLE ValoresCalificaci�n (
	idValorCalificaci�n INT IDENTITY(1, 1) PRIMARY KEY,
	-- nombre que representa una calificaci�n (ejemplo: deficiente)
	rasgoCaracter�stico VARCHAR(100) NOT NULL CHECK (TRIM(rasgoCaracter�stico) <> ''),
	-- se puede hacer una valoraci�n de entre 0 y 5
	valorNum�rico INT CHECK (valorNum�rico BETWEEN 0 AND 5)
);

CREATE TABLE Rese�as (
	idRese�a INT IDENTITY(1, 1) PRIMARY KEY,
	fechaPublicaci�nRese�a DATETIME2,
	comentarioRese�a VARCHAR(500) NULL CHECK (TRIM(comentarioRese�a) <> ''),
	idPerfil INT REFERENCES Perfiles(idPerfilUsuario),
	idValorCalificaci�n INT REFERENCES ValoresCalificaci�n(idValorCalificaci�n),
	visible BIT NOT NULL DEFAULT 1
);


CREATE TABLE Pa�ses (
    idPa�s INT IDENTITY(1,1) PRIMARY KEY,
    nombrePa�s VARCHAR(50) NOT NULL,
    c�digoIsoN�merico INT NOT NULL UNIQUE CHECK (c�digoIsoN�merico > 0),
    c�digoIso3 VARCHAR(3) NOT NULL UNIQUE CHECK (TRIM(c�digoIso3) <> ''),
    c�digoTel�fonico VARCHAR(30) NOT NULL UNIQUE
);

CREATE TABLE Monedas (
    idMoneda INT IDENTITY(1,1) PRIMARY KEY,
    nombreMoneda VARCHAR(50) NOT NULL CHECK (TRIM(nombreMoneda) <> ''),
    c�digoIsoMoneda VARCHAR(10) NOT NULL UNIQUE CHECK (TRIM(c�digoIsoMoneda) <> ''),
    s�mboloMoneda VARCHAR(10) NOT NULL CHECK (TRIM(s�mboloMoneda) <> '')
);

CREATE TABLE Pa�sesPorUsuarios (
    idUsuario INT NOT NULL  REFERENCES Usuarios(idUsuario),
    idPa�s INT NOT NULL  REFERENCES Pa�ses(idPa�s),
    PRIMARY KEY (idUsuario, idPa�s)
);

CREATE TABLE MonedasPorPa�ses (
    idMoneda INT NOT NULL  REFERENCES Monedas(idMoneda),
    idPa�s INT NOT NULL REFERENCES Pa�ses(idPa�s),
    PRIMARY KEY (idMoneda, idPa�s)
);

CREATE TABLE TiposTel�fonos (
    idTipoTel�fono INT IDENTITY(1, 1) PRIMARY KEY,
    nombreTipoTel�fono VARCHAR(50) NOT NULL CHECK (TRIM(nombreTipoTel�fono) <> ''),
    descripci�nTipoTel�fono VARCHAR(255) NULL CHECK (TRIM(descripci�nTipoTel�fono) <> '') 
);

CREATE TABLE PrestadoresDeServicios (
    idPrestadorServicio INT IDENTITY(1, 1) PRIMARY KEY,
    nombreComercialPrestador VARCHAR(50) NOT NULL,
    emailPrestadorServicio VARCHAR(254) UNIQUE NOT NULL,
    raz�nSocialPrestadorServicio VARCHAR(100) NOT NULL CHECK (TRIM(raz�nSocialPrestadorServicio) <> ''),
    descripci�nPrestadorServicio VARCHAR(500) NULL CHECK (TRIM(descripci�nPrestadorServicio) <> '')
);

CREATE TABLE Tel�fonos (
    idTel�fono INT IDENTITY(1, 1) PRIMARY KEY,
    n�meroTel�fono VARCHAR(20) NOT NULL CHECK (TRIM(n�meroTel�fono) <> ''),
    observacionesTel�fono VARCHAR(500) NULL CHECK (TRIM(observacionesTel�fono) <> ''),
    esPrincipal BIT NOT NULL DEFAULT 0,
    idTipoTel�fono INT NOT NULL  REFERENCES TiposTel�fonos(idTipoTel�fono),
    idPa�s INT NOT NULL REFERENCES Pa�ses(idPa�s),
	CONSTRAINT Tel�fonoV�lido CHECK (n�meroTel�fono LIKE '+[0-9][0-9] %[0-9]%' 
									OR n�meroTel�fono LIKE '+[0-9][0-9][0-9] %[0-9]%')
);

CREATE TABLE Tel�fonosUsuarios (
    idTel�fono INT NOT NULL  REFERENCES Tel�fonos(idTel�fono),
    idUsuario INT NOT NULL  REFERENCES Usuarios(idUsuario),
	PRIMARY KEY (idTel�fono, idUsuario)
);

CREATE TABLE Tel�fonosPrestadoresDeServicio (
    idTel�fono INT NOT NULL  REFERENCES Tel�fonos(idTel�fono),
    idPrestadorServicio INT NOT NULL  REFERENCES PrestadoresDeServicios(idPrestadorServicio)
	PRIMARY KEY (idTel�fono, idPrestadorServicio)
);

CREATE TABLE Tel�fonosEps (
    idTel�fono INT NOT NULL REFERENCES Tel�fonos(idTel�fono),
    idEps INT NOT NULL REFERENCES Eps(idEps)
	PRIMARY KEY (idTel�fono, idEps)
);

CREATE TABLE Etiquetas (
	idEtiqueta INT IDENTITY(1, 1) PRIMARY KEY,
	nombreEtiqueta VARCHAR(50) NOT NULL CHECK (TRIM(nombreEtiqueta) <> ''),
	descripci�nEtiqueta VARCHAR(500) NULL CHECK (TRIM(descripci�nEtiqueta) <> '')
);

CREATE TABLE EtiquetasPorRese�a (
	idEtiquetaRese�a INT IDENTITY(1, 1) PRIMARY KEY,
	idEtiqueta INT  REFERENCES Etiquetas(idEtiqueta),
	idRese�a INT  REFERENCES Rese�as(idRese�a)
);

CREATE TABLE TiposPrestadoresDeServicios (
    idTipoPrestadorServicio INT IDENTITY(1, 1) PRIMARY KEY,
    nombreTipoPrestador VARCHAR(50) NOT NULL CHECK (TRIM(nombreTipoPrestador) <> ''),
    descripci�nTipoPrestador VARCHAR(500) NULL CHECK (TRIM(descripci�nTipoPrestador) <> '')
);

CREATE TABLE Rese�asDelPuntoTur�stico (
    idRese�aPunto INT PRIMARY KEY REFERENCES Rese�as(idRese�a),
    idPuntoTur�stico INT NOT NULL REFERENCES PuntosDeInter�s(idPuntoDeInter�s)
);

CREATE TABLE Rese�asDelTour (
    idRese�aTour INT PRIMARY KEY REFERENCES Rese�as(idRese�a),
    idTour INT NOT NULL REFERENCES Tours(idTour)
);

CREATE TABLE Rese�asDelGu�a (
    idRese�aGu�a INT PRIMARY KEY REFERENCES Rese�as(idRese�a),
	idGu�aRese�ado INT REFERENCES Gu�as(idPerfilGu�a)
);

CREATE TABLE Rese�asPrestadorDeServicios (
    idRese�aPrestador INT PRIMARY KEY REFERENCES Rese�as(idRese�a),
    idPrestadorDeServicios INT NOT NULL REFERENCES PrestadoresDeServicios(idPrestadorServicio)
);

CREATE TABLE TipoPorPrestadorDeServicio (
    idPrestadorServicio INT NOT NULL  REFERENCES PrestadoresDeServicios(idPrestadorServicio),
    idTipoPrestadorServicio INT NOT NULL  REFERENCES TiposPrestadoresDeServicios(idTipoPrestadorServicio),
	PRIMARY KEY (idPrestadorServicio, idTipoPrestadorServicio)
);

CREATE TABLE ServiciosPorPrestador (
	idPrestadorServicio INT  REFERENCES PrestadoresDeServicios(idPrestadorServicio),
	idServicio INT  REFERENCES Servicios(idServicio)
	PRIMARY KEY (idPrestadorServicio, idServicio)
);

CREATE TABLE SitiosPorPrestadorDeServicio (
	idPrestadorServicio INT  REFERENCES PrestadoresDeServicios(idPrestadorServicio),
	idSitio INT  REFERENCES Sitios(idSitio),
	PRIMARY KEY (idPrestadorServicio, idSitio)
);

CREATE TABLE ArchivosPorRese�as (
	idArchivoRese�a INT IDENTITY(1, 1) PRIMARY KEY,
	fechaSubidaArchivo DATETIME2 CHECK (fechaSubidaArchivo <= GETDATE()),
	idRese�a INT REFERENCES Rese�as(idRese�a),
	idArchivoMultimedia INT  REFERENCES ArchivosMultimedia(idArchivoMultimedia)
);

CREATE TABLE DetallesRese�as (
	idDetalleRese�a INT IDENTITY(1, 1) PRIMARY KEY,
	idDetalleAdicional INT  REFERENCES DetallesAdicionales(idDetalleAdicional),
	idValorCalificaci�n INT  REFERENCES ValoresCalificaci�n(idValorCalificaci�n),
	idRese�a INT  REFERENCES Rese�as(idRese�a)
);

CREATE TABLE MediosDePago (
    idMedioDePago INT IDENTITY(1, 1) PRIMARY KEY,
    nombreMedioDePago VARCHAR(50) NOT NULL CHECK (TRIM(nombreMedioDePago) <> ''),
    descripci�nMedioDePago VARCHAR(500) NULL CHECK (TRIM(descripci�nMedioDePago) <> ''),
    requiereComisi�n BIT NOT NULL DEFAULT 0,
	estaPermitido BIT NOT NULL DEFAULT 1
);

CREATE TABLE Propinas (
    idPropina INT IDENTITY(1, 1) PRIMARY KEY,
    fechaPagoPropina DATETIME2 NOT NULL CHECK (fechaPagoPropina <= GETDATE()),
    montoPropina DECIMAL(10,2) NOT NULL CHECK (montoPropina > 0),
    idGu�a INT NOT NULL  REFERENCES Gu�as(idPerfilGu�a),
    idMedioDePago INT NOT NULL  REFERENCES MediosDePago(idMedioDePago),
    idTour INT NOT NULL  REFERENCES Tours(idTour),
    idMoneda INT NOT NULL REFERENCES Monedas(idMoneda)
);

CREATE TABLE CalificacionesRese�a (
    idCalificaci�n INT IDENTITY(1, 1) PRIMARY KEY,
    idRese�a INT NOT NULL REFERENCES Rese�as(idRese�a),
    idValorCalificaci�n INT NOT NULL REFERENCES ValoresCalificaci�n(idValorCalificaci�n),
    comentario VARCHAR(500) NULL CHECK (TRIM(comentario) <> ''),
);

CREATE TABLE CalificacionesDeLaRese�aPorPerfil (
    idCalificaci�n INT NOT NULL  REFERENCES CalificacionesRese�a(idCalificaci�n),
    idPerfil INT NOT NULL  REFERENCES Perfiles(idPerfilUsuario)
    PRIMARY KEY (idCalificaci�n, idPerfil),
);

CREATE TABLE Tem�ticasPreferidasPorTurista (
    idTurista INT NOT NULL  REFERENCES Turistas(idPerfilTurista),
    idTem�tica INT NOT NULL REFERENCES Tem�ticas(idTem�tica),
    PRIMARY KEY (idTurista, idTem�tica),
);

CREATE TABLE Gu�asPorTour (
	idGu�a INT REFERENCES Gu�as(idPerfilGu�a),
	idTour INT REFERENCES Tours(idTour),
	PRIMARY KEY (idGu�a, idTour)
);

CREATE TABLE ArchivosMultimediaPorPuntoDeInter�s (
	idArchivoMultimedia INT REFERENCES ArchivosMultimedia(idArchivoMultimedia),
	idPuntoDeInter�s INT REFERENCES PuntosDeInter�s(idPuntoDeInter�s),
	PRIMARY KEY (idArchivoMultimedia, idPuntoDeInter�s)
);

CREATE TABLE ArchivosMultimediaPorRese�a (
	idArchivoMultimedia INT REFERENCES ArchivosMultimedia(idArchivoMultimedia),
	idRese�a INT REFERENCES Rese�as(idRese�a),
	fechaSubida DATETIME2 CHECK (fechaSubida <= GETDATE()),
	PRIMARY KEY (idArchivoMultimedia, idRese�a)
);

CREATE TABLE ArchivosMultimediaPorTour (
	idArchivoMultimedia INT REFERENCES ArchivosMultimedia(idArchivoMultimedia),
	idTour INT REFERENCES Tours(idTour),
	fechaSubida DATETIME2 CHECK (fechaSubida <= GETDATE()),
	PRIMARY KEY (idArchivoMultimedia, idTour)
);

CREATE TABLE ToursHistorial (
	idVersi�nTour INT IDENTITY(1,1) PRIMARY KEY,
	idTour INT NOT NULL,
	nombreTour VARCHAR(30) NULL,
	puntoDeEncuentroTour INT NULL,
	maxParticipantesTour INT NULL,
	duraci�nTour DECIMAL(4, 2) NULL,
	descripci�nTour VARCHAR(500) NULL,
	idGu�aPrincipalTour INT NULL,
	idSitio INT NULL,
	idDisponibilidad INT NULL,
	fechaCreaci�n DATETIME NOT NULL,
	creadaPor VARCHAR(50) NOT NULL,
	fechaModificaci�n DATETIME NULL,
	modificadaPor VARCHAR(50) NULL,
	fechaRegistroHistorial DATETIME NOT NULL DEFAULT GETDATE(),
	usuarioSistema VARCHAR(50) NOT NULL DEFAULT SYSTEM_USER
);


CREATE TABLE ReservasHistorial (
	idVersi�nReserva INT IDENTITY(1, 1) PRIMARY KEY,
	idReserva INT NOT NULL,
	idTurista INT NULL,
	cuposReservados INT NULL,
	idSesi�nTour INT NULL,
	fechaRealizaci�nReserva DATE NULL,
	fechaFinalizaci�nReserva DATE NULL,
	fechaCreaci�n DATETIME NOT NULL,
	creadaPor VARCHAR(50) NOT NULL,
	fechaModificaci�n DATETIME NULL,
	modificadaPor VARCHAR(50) NULL,
	fechaRegistroHistorial DATETIME NOT NULL DEFAULT GETDATE(),
	usuarioSistema VARCHAR(50) NOT NULL DEFAULT SYSTEM_USER
);


CREATE TABLE Gu�asHistorial (
	idVersi�nGu�a INT IDENTITY(1, 1) PRIMARY KEY,
	idPerfilGu�a INT NOT NULL,
	esVerificado BIT NULL,
	biograf�aGu�a VARCHAR(MAX) NULL,
	descripci�nGu�a VARCHAR(MAX) NOT NULL,
	idSitioGu�a INT NULL,
	fechaCreaci�n DATETIME NOT NULL,
	creadaPor VARCHAR(50) NOT NULL,
	fechaModificaci�n DATETIME NULL,
	modificadaPor VARCHAR(50) NULL,
	fechaRegistroHistorial DATETIME NOT NULL DEFAULT GETDATE(),
	usuarioSistema VARCHAR(50) NOT NULL DEFAULT SYSTEM_USER
);


CREATE TABLE UsuariosHistorial (
	idVersi�nUsuario INT IDENTITY(1, 1) PRIMARY KEY,
	idUsuario INT NOT NULL,
	nombreUsuario VARCHAR(50) NULL,
	apellidoUsuario VARCHAR(50) NULL,
	documentoUsuario VARCHAR(25) NULL,
	idEps INT NULL,
	fechaCreaci�n DATETIME NOT NULL,                 
	creadaPor VARCHAR(50) NOT NULL,                  
	fechaModificaci�n DATETIME NULL,                      
	modificadaPor VARCHAR(50) NULL,                       
	fechaRegistroHistorial DATETIME NOT NULL DEFAULT GETDATE(),  
	usuarioSistema VARCHAR(50) NOT NULL DEFAULT SYSTEM_USER
);

CREATE TABLE PerfilesHistorial (
	idVersi�nPerfil INT IDENTITY(1, 1) PRIMARY KEY,
	idPerfilUsuario INT NOT NULL,
	nombrePerfil VARCHAR(50) UNIQUE CHECK (TRIM(nombrePerfil) <> ''),
	contrase�aPerfil VARCHAR(50) CHECK (TRIM(contrase�aPerfil) <> ''),
	emailPerfil VARCHAR(254) NULL,
	idFotoDePerfil INT NULL,
	idRol INT NULL,
	fechaCreaci�nPerfil DATE NULL,
	fechaCreaci�n DATETIME NOT NULL,                 
	creadaPor VARCHAR(50) NOT NULL,                  
	fechaModificaci�n DATETIME NULL,                      
	modificadaPor VARCHAR(50) NULL,                       
	fechaRegistroHistorial DATETIME NOT NULL DEFAULT GETDATE(),  
	usuarioSistema VARCHAR(50) NOT NULL DEFAULT SYSTEM_USER
);

CREATE TABLE PuntosDeInter�sHistorial (
	idVersi�nPuntoDeInter�s INT IDENTITY(1, 1) PRIMARY KEY,
	idPuntoDeInter�s INT NOT NULL,
	nombrePuntoDeInter�s VARCHAR(50) NULL,
	descripcionPuntoDeInter�s VARCHAR(MAX) NULL,
	latitudPuntoDeInter�s DECIMAL(8,6) NULL,
	longitudPuntoDeInter�s DECIMAL(9,6) NULL,
	fechaCreaci�n DATETIME NOT NULL,                 
	creadaPor VARCHAR(50) NOT NULL,                  
	fechaModificaci�n DATETIME NULL,                      
	modificadaPor VARCHAR(50) NULL,                       
	fechaRegistroHistorial DATETIME NOT NULL DEFAULT GETDATE(),  
	usuarioSistema VARCHAR(50) NOT NULL DEFAULT SYSTEM_USER
);


CREATE TABLE ServiciosHistorial (
	idVersi�nServicio INT IDENTITY(1, 1) PRIMARY KEY,
	idServicio INT NOT NULL,
	nombreServicio VARCHAR(50) NULL,
	descripci�nServicio VARCHAR(500) NULL,
	costoServicio DECIMAL(10,2) NULL,
	idRangoEdad INT NULL,
	fechaCreaci�n DATETIME NOT NULL,                 
	creadaPor VARCHAR(50) NOT NULL,                  
	fechaModificaci�n DATETIME NULL,                      
	modificadaPor VARCHAR(50) NULL,                       
	fechaRegistroHistorial DATETIME NOT NULL DEFAULT GETDATE(),  
	usuarioSistema VARCHAR(50) NOT NULL DEFAULT SYSTEM_USER
);

CREATE TABLE Rese�asHistorial (
	idVersi�nRese�a INT IDENTITY(1, 1) PRIMARY KEY,
	idRese�a INT NOT NULL,
	fechaPublicaci�nRese�a DATETIME2 NULL,
	comentarioRese�a VARCHAR(500) NULL,
	idPerfil INT NULL,
	idValorCalificaci�n INT NULL,
	fechaCreaci�n DATETIME NOT NULL,                 
	creadaPor VARCHAR(50) NOT NULL,                  
	fechaModificaci�n DATETIME NULL,                      
	modificadaPor VARCHAR(50) NULL,                       
	fechaRegistroHistorial DATETIME NOT NULL DEFAULT GETDATE(),  
	usuarioSistema VARCHAR(50) NOT NULL DEFAULT SYSTEM_USER
);
