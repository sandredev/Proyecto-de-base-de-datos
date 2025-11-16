CREATE DATABASE Freetour
GO
USE Freetour 
GO

CREATE TABLE Regiones (
	idRegión INT IDENTITY(1, 1) PRIMARY KEY,
	nombreRegión VARCHAR(100) NOT NULL CHECK (TRIM(nombreRegión) <> ''),
	descripciónRegión VARCHAR(500) NULL CHECK (TRIM(descripciónRegión) <> ''),
	superficieRegión DECIMAL(10, 2) NULL CHECK (superficieRegión > 0),
	CONSTRAINT NombreRegiónVálido CHECK (nombreRegión NOT LIKE '%[0-9]%')
);

CREATE TABLE Departamentos (
	idDepartamento INT IDENTITY(1, 1) PRIMARY KEY,
	nombreDepartamento VARCHAR(100) NOT NULL CHECK (TRIM(nombreDepartamento) <> ''),
	descripciónDepartamento VARCHAR(500) NULL CHECK (TRIM(descripciónDepartamento) <> ''),
	códigoDane INT NOT NULL CHECK (códigoDane > 0),
	idRegión INT REFERENCES Regiones(idRegión),
	CONSTRAINT NombreDepartamentoVálido CHECK (nombreDepartamento NOT LIKE '%[0-9]%')
);

CREATE TABLE TiposDeLocalizaciones (
	idTipoLocalización INT IDENTITY(1, 1) PRIMARY KEY,
	nombreTipoLocalización VARCHAR(100) NOT NULL CHECK (TRIM(nombreTipoLocalización) <> ''),
	descripciónTipoLocalización VARCHAR(500) CHECK (TRIM(descripciónTipoLocalización) <> ''),
	CONSTRAINT NombreTipoLocalizaciónVálido CHECK (nombreTipoLocalización NOT LIKE '%[0-9]%')
); 

CREATE TABLE Sitios (
	idSitio INT IDENTITY(1, 1) PRIMARY KEY,
	nombreSitio VARCHAR(100) NOT NULL CHECK (TRIM(nombreSitio) <> ''),
	latitudSitio DECIMAL(8, 6) NOT NULL,
	longitudSitio DECIMAL(9, 6) NOT NULL,
	idTipoLocalización INT REFERENCES TiposDeLocalizaciones(idTipoLocalización),
	idDepartamento INT  REFERENCES Departamentos(idDepartamento),
	CONSTRAINT SitioEnRangoGeográficoColombia CHECK (latitudSitio BETWEEN -4.2 AND 13.5
											AND longitudSitio BETWEEN -79.0 AND -66.0)
); -- la restricción que evita que no se puedan ingresar números en el nombre de la entidad aquí no es
   -- necesaria pues pueden existir sitios como "la 30" con números en su nombre.


CREATE TABLE Climas (
	idClima INT IDENTITY(1, 1) PRIMARY KEY,
	nombreClima VARCHAR(100) NOT NULL CHECK (TRIM(nombreClima) <> ''),
	descripciónClima VARCHAR(500) NULL CHECK (TRIM(descripciónClima) <> ''),
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
	direcciónEps VARCHAR(50) NOT NULL CHECK (TRIM(direcciónEps) <> ''),
	emailEps VARCHAR(254) UNIQUE NOT NULL,
	CONSTRAINT EmailEpsFormatoVálido CHECK (emailEps LIKE '_%@_%._%')
);

CREATE TABLE Usuarios (
	idUsuario INT IDENTITY(1, 1) PRIMARY KEY,
	nombreUsuario VARCHAR(50) NOT NULL CHECK (TRIM(nombreUsuario) <> ''),
	apellidoUsuario VARCHAR(50) NOT NULL CHECK (TRIM(apellidoUsuario) <> ''),
	documentoUsuario VARCHAR(25) NOT NULL UNIQUE CHECK (TRIM(documentoUsuario) <> ''),
	idEps INT NULL REFERENCES Eps(idEps),
	CONSTRAINT NombresUsuarioVálido CHECK (nombreUsuario NOT LIKE '%[0-9]%'),
	CONSTRAINT ApellidoUsuarioVálido CHECK (apellidoUsuario NOT LIKE '%[0-9]%'),
	CONSTRAINT DocumentoVálido CHECK (LEN(documentoUsuario) >= 9)
);

CREATE TABLE TiposDeFormato (
	idTipoFormato INT IDENTITY(1, 1) PRIMARY KEY,
	nombreTipoFormato VARCHAR(30) NOT NULL CHECK (TRIM(nombreTipoFormato) <> ''),
	descripciónTipoFormato VARCHAR(500) NULL CHECK (TRIM(descripciónTipoFormato) <> '')
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
	CONSTRAINT RolVálido CHECK (nombreRol IN ('Guía', 'Turista'))
);

CREATE TABLE Perfiles (
	idPerfilUsuario INT PRIMARY KEY REFERENCES Usuarios(idUsuario),
	nombrePerfil VARCHAR(50) UNIQUE CHECK (TRIM(nombrePerfil) <> ''),
	contraseñaPerfil VARCHAR(50) CHECK (TRIM(contraseñaPerfil) <> ''),
	emailPerfil VARCHAR(254) UNIQUE NOT NULL,
	idFotoDePerfil INT NULL REFERENCES ArchivosMultimedia(idArchivoMultimedia),
	idRol INT NOT NULL REFERENCES Roles(idRol),
	fechaCreaciónPerfil DATE CHECK (fechaCreaciónPerfil <= GETDATE()),
	CONSTRAINT EmailPerfilFormatoVálido CHECK (emailPerfil LIKE '_%@_%._%')
);

CREATE TABLE Turistas (
	idPerfilTurista INT PRIMARY KEY  REFERENCES Perfiles(idPerfilUsuario)
);

CREATE TABLE Guías (
	idPerfilGuía INT PRIMARY KEY  REFERENCES Perfiles(idPerfilUsuario),
	esVerificado BIT NOT NULL DEFAULT 0,
	biografíaGuía VARCHAR(500) NULL CHECK (TRIM(biografíaGuía) <> ''),
	descripciónGuía VARCHAR(500) NOT NULL CHECK (TRIM(descripciónGuía) <> ''),
	idSitioGuía INT  REFERENCES Sitios(idSitio)
);

CREATE TABLE Idiomas (
	idIdioma INT IDENTITY(1, 1) PRIMARY KEY,
	nombreIdioma VARCHAR(30) NOT NULL UNIQUE CHECK (TRIM(nombreIdioma) <> ''),
	descripciónIdioma VARCHAR(MAX) NULL CHECK (TRIM(descripciónIdioma) <> '')
);

CREATE TABLE IdiomasPorPerfil (
	idIdioma INT  REFERENCES Idiomas(idIdioma),
	idPerfil INT  REFERENCES Perfiles(idPerfilUsuario),
	PRIMARY KEY (idIdioma, idPerfil)
);

CREATE TABLE RangosEdades (
	idRangoEdad INT IDENTITY(1, 1) PRIMARY KEY,
	nombreRangoEdad VARCHAR(25) NOT NULL CHECK (TRIM(nombreRangoEdad) <> ''),
	descripciónRangoEdad VARCHAR(500) NULL,
	CONSTRAINT RangoEdadVálido CHECK (nombreRangoEdad IN ('Para toda la familia', 'Para mayores de 10', 'Para mayores de 12', 'Para mayores de 17', 'Solo adultos'))
);

CREATE TABLE Temáticas (
	idTemática INT IDENTITY(1, 1) PRIMARY KEY,
	nombreTemática VARCHAR(50) NOT NULL CHECK (TRIM(nombreTemática) <> ''),
	descripciónTemática VARCHAR(500) NULL CHECK (TRIM(descripciónTemática) <> ''),
	idRangoEdadRecomendada INT NOT NULL  REFERENCES RangosEdades(idRangoEdad),
	CONSTRAINT NombreTemáticaVálida CHECK (nombreTemática NOT LIKE '%[0-9]%')
);

CREATE TABLE PuntosDeInterés (
	idPuntoDeInterés INT IDENTITY(1, 1) PRIMARY KEY,
	nombrePuntoDeInterés VARCHAR(50) NOT NULL CHECK (TRIM(nombrePuntoDeInterés) <> ''),
	descripcionPuntoDeInterés VARCHAR(MAX) NULL CHECK (TRIM(descripcionPuntoDeInterés) <> ''),
	latitudPuntoDeInterés DECIMAL(8,6),
	longitudPuntoDeInterés DECIMAL(9,6),
	CONSTRAINT PuntoEnRangoGeográficoColombia CHECK (latitudPuntoDeInterés BETWEEN -4.2 AND 13.5
											AND longitudPuntoDeInterés BETWEEN -79.0 AND -66.0)
);

CREATE TABLE Tours (
	idTour INT IDENTITY(1, 1) PRIMARY KEY,
	nombreTour VARCHAR(30) NOT NULL CHECK (TRIM(nombreTour) <> ''),
	-- Puede que un punto de encuentro aún no esté definido
	idPuntoDeEncuentroTour INT NULL REFERENCES PuntosDeInterés(idPuntoDeInterés),
	-- Puede que se desconozca temporalmente el máximo de participantes por tour
	maxParticipantesTour INT NULL CHECK (maxParticipantesTour > 0),
	-- Almacena la duración del tour en horas, máximo 1 mes (30 días)
	duraciónTour DECIMAL(4, 2) NULL,
	descripciónTour VARCHAR(500) NULL CHECK (TRIM(descripciónTour) <> ''),
	idGuíaPrincipalTour INT  REFERENCES Guías(idPerfilGuía),
	idSitio INT  REFERENCES Sitios(idSitio),
	CONSTRAINT DuraciónTourDentroDelRango CHECK (duraciónTour BETWEEN 0 AND 720.00)
);

CREATE TABLE IdiomasPorTour (
	idIdioma INT  REFERENCES Idiomas(idIdioma),
	idTour INT  REFERENCES Tours(idTour),
	PRIMARY KEY (idIdioma, idTour)
);

CREATE TABLE TemáticasDelTour (
	idTemática INT  REFERENCES Temáticas(idTemática),
	idTour INT  REFERENCES Tours(idTour),
	PRIMARY KEY (idTemática, idTour)
);

CREATE TABLE puntosDeInterésPorTour (
	idPuntoDeInterésTour INT IDENTITY(1, 1) PRIMARY KEY,
	idPuntoDeInterés INT  REFERENCES PuntosDeInterés(idPuntoDeInterés),
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
	idSesiónTour INT IDENTITY(1, 1) PRIMARY KEY,
	idFechaTour INT  REFERENCES FechasTour(idFechaTour),
	horaInicioSesión TIME,
	horaFinSesión TIME,
	idIdioma INT REFERENCES Idiomas(idIdioma),
	CONSTRAINT RangoSesiónTourVálido CHECK (horaInicioSesión <= horaFinSesión)
);

CREATE TABLE Reservas (
	idReserva INT IDENTITY(1, 1) PRIMARY KEY,
	idTurista INT  REFERENCES Turistas(idPerfilTurista),
	cuposReservados INT DEFAULT 1 CHECK (cuposReservados > 0),
	idSesiónTour INT  REFERENCES SesionesTour(idSesiónTour),
	fechaRealizaciónReserva DATE,
	fechaFinalizaciónReserva DATE NULL,
	CONSTRAINT FechasReservasVálidas CHECK (fechaRealizaciónReserva <= fechaFinalizaciónReserva),
	CONSTRAINT FechaRealizaciónReservaPasada CHECK (fechaRealizaciónReserva <= GETDATE())
);

CREATE TABLE EstadosReserva (
	idEstadoReserva INT IDENTITY(1, 1) PRIMARY KEY,
	nombreEstado VARCHAR(20) NOT NULL CHECK (TRIM(nombreEstado) <> ''),
	-- Ejemplo: expirado = no se usó el servicio
	descripciónEstado VARCHAR(500) NULL CHECK (TRIM(descripciónEstado) <> ''), 
	CONSTRAINT NombreEstadoReservaVálido CHECK (nombreEstado IN ('Pendiente', 'Confirmada', 'Cancelada', 'Finalizada', 'Expirada', 'En curso'))
);

CREATE TABLE EstadosPorReserva (
	idEstadosPorReserva INT IDENTITY(1, 1) PRIMARY KEY,
	idReserva INT  REFERENCES Reservas(idReserva),
	idEstado INT  REFERENCES EstadosReserva(idEstadoReserva),
	-- Explica el por qué una reserva estuvo en un estado con más detalle
	descripciónEstadosPorReserva VARCHAR(500) NULL,
	fechaInicioEstado DATETIME2 NOT NULL CHECK (fechaInicioEstado <= GETDATE()),
	fechaFinEstado DATETIME2 CHECK (fechaFinEstado <= GETDATE()),
	CONSTRAINT RangoFechasEstadoReservasVálido CHECK (fechaInicioEstado <= fechaFinEstado)
);

-- Estados para tours y puntos de interés (trabaja en ese dominio)
CREATE TABLE Estados (
	idEstado INT IDENTITY(1, 1) PRIMARY KEY,
	nombreEstado VARCHAR(20) NOT NULL CHECK (TRIM(nombreEstado) <> ''),
	descripciónEstado VARCHAR(500) NULL CHECK (TRIM(descripciónEstado) <> '')
);

CREATE TABLE EstadosDelTour (
	idEstadoDelTour INT IDENTITY(1, 1) PRIMARY KEY,
	idEstado INT REFERENCES Estados(idEstado),
	idTour INT REFERENCES Tours(idTour)
);

CREATE TABLE EstadosDelPuntoDeInterés (
	idEstadoDelPunto INT IDENTITY PRIMARY KEY,
	idEstado INT  REFERENCES Estados(idEstado),
	idPuntoDeInterés INT  REFERENCES PuntosDeInterés(idPuntoDeInterés),
	fechaInicioEstado DATETIME2 CHECK (fechaInicioEstado <= GETDATE()),
	fechaFinEstado DATETIME2 CHECK (fechaFinEstado <= GETDATE()),
	descripciónEstadoPorPunto VARCHAR(500) NULL CHECK(TRIM(descripciónEstadoPorPunto) <> ''),
	CONSTRAINT RangoFechasEstadosPuntoDeInterés CHECK (fechaInicioEstado <= fechaFinEstado)
);

CREATE TABLE TemáticasPreferidasPorGuía (
	idGuía INT  REFERENCES Guías(idPerfilGuía),
	idTemática INT  REFERENCES Temáticas(idTemática),
	PRIMARY KEY (idGuía, idTemática)
);
CREATE TABLE TemáticasPreferidaPorTurista (
	idTurista INT REFERENCES Turistas(idPerfilTurista),
	idTemática INT REFERENCES Temáticas(idTemática),
	PRIMARY KEY (idTurista, idTemática)
);

CREATE TABLE Servicios (
	idServicio INT IDENTITY(1, 1) PRIMARY KEY,
	nombreServicio VARCHAR(50) NOT NULL CHECK (TRIM(nombreServicio) <> ''),
	descripciónServicio VARCHAR(500) NULL CHECK (TRIM(descripciónServicio) <> ''),
	-- el servicio más caro puede ser de 99.999.999,99 
	costoServicio DECIMAL(10,2) NULL DEFAULT NULL CHECK (costoServicio > 0),
	idRangoEdad INT  REFERENCES RangosEdades(idRangoEdad)
);

CREATE TABLE TemáticasDelPuntoDeInterés (
	idTemática INT  REFERENCES Temáticas(idTemática),
	idPuntoDeInterés INT  REFERENCES PuntosDeInterés(idPuntoDeInterés),
	PRIMARY KEY (idTemática, idPuntoDeInterés)
);

CREATE TABLE ServiciosPuntosDeInterés (
	idServiciosDelPunto INT IDENTITY(1, 1) PRIMARY KEY,
	idPuntoDeInterés INT  REFERENCES PuntosDeInterés(idPuntoDeInterés),
	idServicio INT  REFERENCES Servicios(idServicio)
);

CREATE TABLE DetallesAdicionales (
	idDetalleAdicional INT IDENTITY(1, 1) PRIMARY KEY,
	nombreDetalle VARCHAR(50) NOT NULL CHECK (TRIM(nombreDetalle) <> ''),
	descripciónDetalle VARCHAR(500) NULL CHECK (TRIM(descripciónDetalle) <> '')
);

CREATE TABLE ValoresCalificación (
	idValorCalificación INT IDENTITY(1, 1) PRIMARY KEY,
	-- nombre que representa una calificación (ejemplo: deficiente)
	rasgoCaracterístico VARCHAR(100) NOT NULL CHECK (TRIM(rasgoCaracterístico) <> ''),
	-- se puede hacer una valoración de entre 0 y 5
	valorNumérico INT CHECK (valorNumérico BETWEEN 0 AND 5)
);

CREATE TABLE Reseñas (
	idReseña INT IDENTITY(1, 1) PRIMARY KEY,
	fechaPublicaciónReseña DATETIME2,
	comentarioReseña VARCHAR(500) NULL CHECK (TRIM(comentarioReseña) <> ''),
	idPerfil INT REFERENCES Perfiles(idPerfilUsuario),
	idValorCalificación INT REFERENCES ValoresCalificación(idValorCalificación)
);


CREATE TABLE Países (
    idPaís INT IDENTITY(1,1) PRIMARY KEY,
    nombrePaís VARCHAR(50) NOT NULL,
    códigoIsoNúmerico INT NOT NULL UNIQUE CHECK (códigoIsoNúmerico > 0),
    códigoIso3 VARCHAR(3) NOT NULL UNIQUE CHECK (TRIM(códigoIso3) <> ''),
    códigoTeléfonico VARCHAR(30) NOT NULL UNIQUE
);

CREATE TABLE Monedas (
    idMoneda INT IDENTITY(1,1) PRIMARY KEY,
    nombreMoneda VARCHAR(50) NOT NULL CHECK (TRIM(nombreMoneda) <> ''),
    códigoIsoMoneda VARCHAR(10) NOT NULL UNIQUE CHECK (TRIM(códigoIsoMoneda) <> ''),
    símboloMoneda VARCHAR(10) NOT NULL CHECK (TRIM(símboloMoneda) <> '')
);

CREATE TABLE PaísesPorUsuarios (
    idUsuario INT NOT NULL  REFERENCES Usuarios(idUsuario),
    idPaís INT NOT NULL  REFERENCES Países(idPaís),
    PRIMARY KEY (idUsuario, idPaís)
);

CREATE TABLE MonedasPorPaíses (
    idMoneda INT NOT NULL  REFERENCES Monedas(idMoneda),
    idPaís INT NOT NULL REFERENCES Países(idPaís),
    PRIMARY KEY (idMoneda, idPaís)
);

CREATE TABLE TiposTeléfonos (
    idTipoTeléfono INT IDENTITY(1, 1) PRIMARY KEY,
    nombreTipoTeléfono VARCHAR(50) NOT NULL CHECK (TRIM(nombreTipoTeléfono) <> ''),
    descripciónTipoTeléfono VARCHAR(255) NULL CHECK (TRIM(descripciónTipoTeléfono) <> '') 
);

CREATE TABLE PrestadoresDeServicios (
    idPrestadorServicio INT IDENTITY(1, 1) PRIMARY KEY,
    nombreComercialPrestador VARCHAR(50) NOT NULL,
    emailPrestadorServicio VARCHAR(254) UNIQUE NOT NULL,
    razónSocialPrestadorServicio VARCHAR(100) NOT NULL CHECK (TRIM(razónSocialPrestadorServicio) <> ''),
    descripciónPrestadorServicio VARCHAR(500) NULL CHECK (TRIM(descripciónPrestadorServicio) <> '')
);

CREATE TABLE Teléfonos (
    idTeléfono INT IDENTITY(1, 1) PRIMARY KEY,
    númeroTeléfono VARCHAR(20) NOT NULL CHECK (TRIM(númeroTeléfono) <> ''),
    observacionesTeléfono VARCHAR(500) NULL CHECK (TRIM(observacionesTeléfono) <> ''),
    esPrincipal BIT NOT NULL DEFAULT 0,
    idTipoTeléfono INT NOT NULL  REFERENCES TiposTeléfonos(idTipoTeléfono),
    idPaís INT NOT NULL REFERENCES Países(idPaís),
	CONSTRAINT TeléfonoVálido CHECK (númeroTeléfono LIKE '+[0-9][0-9] %[0-9]%' 
									OR númeroTeléfono LIKE '+[0-9][0-9][0-9] %[0-9]%')
);

CREATE TABLE TeléfonosUsuarios (
    idTeléfono INT NOT NULL  REFERENCES Teléfonos(idTeléfono),
    idUsuario INT NOT NULL  REFERENCES Usuarios(idUsuario),
	PRIMARY KEY (idTeléfono, idUsuario)
);

CREATE TABLE TeléfonosPrestadoresDeServicio (
    idTeléfono INT NOT NULL  REFERENCES Teléfonos(idTeléfono),
    idPrestadorServicio INT NOT NULL  REFERENCES PrestadoresDeServicios(idPrestadorServicio)
	PRIMARY KEY (idTeléfono, idPrestadorServicio)
);

CREATE TABLE TeléfonosEps (
    idTeléfono INT NOT NULL REFERENCES Teléfonos(idTeléfono),
    idEps INT NOT NULL REFERENCES Eps(idEps)
	PRIMARY KEY (idTeléfono, idEps)
);

CREATE TABLE Etiquetas (
	idEtiqueta INT IDENTITY(1, 1) PRIMARY KEY,
	nombreEtiqueta VARCHAR(50) NOT NULL CHECK (TRIM(nombreEtiqueta) <> ''),
	descripciónEtiqueta VARCHAR(500) NULL CHECK (TRIM(descripciónEtiqueta) <> '')
);

CREATE TABLE EtiquetasPorReseña (
	idEtiquetaReseña INT IDENTITY(1, 1) PRIMARY KEY,
	idEtiqueta INT  REFERENCES Etiquetas(idEtiqueta),
	idReseña INT  REFERENCES Reseñas(idReseña)
);

CREATE TABLE TiposPrestadoresDeServicios (
    idTipoPrestadorServicio INT IDENTITY(1, 1) PRIMARY KEY,
    nombreTipoPrestador VARCHAR(50) NOT NULL CHECK (TRIM(nombreTipoPrestador) <> ''),
    descripciónTipoPrestador VARCHAR(500) NULL CHECK (TRIM(descripciónTipoPrestador) <> '')
);

CREATE TABLE ReseñasDelPuntoTurístico (
    idReseñaPunto INT PRIMARY KEY REFERENCES Reseñas(idReseña),
    idPuntoTurístico INT NOT NULL REFERENCES PuntosDeInterés(idPuntoDeInterés)
);

CREATE TABLE ReseñasDelTour (
    idReseñaTour INT PRIMARY KEY REFERENCES Reseñas(idReseña),
    idTour INT NOT NULL REFERENCES Tours(idTour)
);

CREATE TABLE ReseñasDelGuía (
    idReseñaGuía INT PRIMARY KEY REFERENCES Reseñas(idReseña),
	idGuíaReseñado INT REFERENCES Guías(idPerfilGuía)
);

CREATE TABLE ReseñasPrestadorDeServicios (
    idReseñaPrestador INT PRIMARY KEY REFERENCES Reseñas(idReseña),
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

CREATE TABLE ArchivosPorReseñas (
	idArchivoReseña INT IDENTITY(1, 1) PRIMARY KEY,
	fechaSubidaArchivo DATETIME2 CHECK (fechaSubidaArchivo <= GETDATE()),
	idReseña INT REFERENCES Reseñas(idReseña),
	idArchivoMultimedia INT  REFERENCES ArchivosMultimedia(idArchivoMultimedia)
);

CREATE TABLE DetallesReseñas (
	idDetalleReseña INT IDENTITY(1, 1) PRIMARY KEY,
	idDetalleAdicional INT  REFERENCES DetallesAdicionales(idDetalleAdicional),
	idValorCalificación INT  REFERENCES ValoresCalificación(idValorCalificación),
	idReseña INT  REFERENCES Reseñas(idReseña)
);

CREATE TABLE MediosDePago (
    idMedioDePago INT IDENTITY(1, 1) PRIMARY KEY,
    nombreMedioDePago VARCHAR(50) NOT NULL CHECK (TRIM(nombreMedioDePago) <> ''),
    descripciónMedioDePago VARCHAR(500) NULL CHECK (TRIM(descripciónMedioDePago) <> ''),
    requiereComisión BIT NOT NULL DEFAULT 0
);

CREATE TABLE Propinas (
    idPropina INT IDENTITY(1, 1) PRIMARY KEY,
    fechaPagoPropina DATETIME2 NOT NULL CHECK (fechaPagoPropina <= GETDATE()),
    montoPropina DECIMAL(10,2) NOT NULL CHECK (montoPropina > 0),
    idGuía INT NOT NULL  REFERENCES Guías(idPerfilGuía),
    idMedioDePago INT NOT NULL  REFERENCES MediosDePago(idMedioDePago),
    idTour INT NOT NULL  REFERENCES Tours(idTour),
    idMoneda INT NOT NULL REFERENCES Monedas(idMoneda)
);

CREATE TABLE CalificacionesReseña (
    idCalificación INT IDENTITY(1, 1) PRIMARY KEY,
    idReseña INT NOT NULL REFERENCES Reseñas(idReseña),
    idValorCalificación INT NOT NULL REFERENCES ValoresCalificación(idValorCalificación),
    comentario VARCHAR(500) NULL CHECK (TRIM(comentario) <> ''),
);

CREATE TABLE CalificacionesDeLaReseñaPorPerfil (
    idCalificación INT NOT NULL  REFERENCES CalificacionesReseña(idCalificación),
    idPerfil INT NOT NULL  REFERENCES Perfiles(idPerfilUsuario)
    PRIMARY KEY (idCalificación, idPerfil),
);

CREATE TABLE TemáticasPreferidasPorTurista (
    idTurista INT NOT NULL  REFERENCES Turistas(idPerfilTurista),
    idTemática INT NOT NULL REFERENCES Temáticas(idTemática),
    PRIMARY KEY (idTurista, idTemática),
);

CREATE TABLE GuíasPorTour (
	idGuía INT REFERENCES Guías(idPerfilGuía),
	idTour INT REFERENCES Tours(idTour),
	PRIMARY KEY (idGuía, idTour)
);

CREATE TABLE ArchivosMultimediaPorPuntoDeInterés (
	idArchivoMultimedia INT REFERENCES ArchivosMultimedia(idArchivoMultimedia),
	idPuntoDeInterés INT REFERENCES PuntosDeInterés(idPuntoDeInterés),
	PRIMARY KEY (idArchivoMultimedia, idPuntoDeInterés)
);

CREATE TABLE ArchivosMultimediaPorReseña (
	idArchivoMultimedia INT REFERENCES ArchivosMultimedia(idArchivoMultimedia),
	idReseña INT REFERENCES Reseñas(idReseña),
	fechaSubida DATETIME2 CHECK (fechaSubida <= GETDATE()),
	PRIMARY KEY (idArchivoMultimedia, idReseña)
);

CREATE TABLE ArchivosMultimediaPorTour (
	idArchivoMultimedia INT REFERENCES ArchivosMultimedia(idArchivoMultimedia),
	idTour INT REFERENCES Tours(idTour),
	fechaSubida DATETIME2 CHECK (fechaSubida <= GETDATE()),
	PRIMARY KEY (idArchivoMultimedia, idTour)
);

CREATE TABLE ToursHistorial (
	idVersiónTour INT IDENTITY(1,1) PRIMARY KEY,
	idTour INT NOT NULL,
	nombreTour VARCHAR(30) NULL,
	puntoDeEncuentroTour INT NULL,
	maxParticipantesTour INT NULL,
	duraciónTour DECIMAL(4, 2) NULL,
	descripciónTour VARCHAR(500) NULL,
	idGuíaPrincipalTour INT NULL,
	idSitio INT NULL,
	idDisponibilidad INT NULL,
	fechaCreación DATETIME NOT NULL,
	creadaPor VARCHAR(50) NOT NULL,
	fechaModificación DATETIME NULL,
	modificadaPor VARCHAR(50) NULL,
	fechaRegistroHistorial DATETIME NOT NULL DEFAULT GETDATE(),
	usuarioSistema VARCHAR(50) NOT NULL DEFAULT SYSTEM_USER
);


CREATE TABLE ReservasHistorial (
	idVersiónReserva INT IDENTITY(1, 1) PRIMARY KEY,
	idReserva INT NOT NULL,
	idTurista INT NULL,
	cuposReservados INT NULL,
	idSesiónTour INT NULL,
	fechaRealizaciónReserva DATE NULL,
	fechaFinalizaciónReserva DATE NULL,
	fechaCreación DATETIME NOT NULL,
	creadaPor VARCHAR(50) NOT NULL,
	fechaModificación DATETIME NULL,
	modificadaPor VARCHAR(50) NULL,
	fechaRegistroHistorial DATETIME NOT NULL DEFAULT GETDATE(),
	usuarioSistema VARCHAR(50) NOT NULL DEFAULT SYSTEM_USER
);


CREATE TABLE GuíasHistorial (
	idVersiónGuía INT IDENTITY(1, 1) PRIMARY KEY,
	idPerfilGuía INT NOT NULL,
	esVerificado BIT NULL,
	biografíaGuía VARCHAR(MAX) NULL,
	descripciónGuía VARCHAR(MAX) NOT NULL,
	idSitioGuía INT NULL,
	fechaCreación DATETIME NOT NULL,
	creadaPor VARCHAR(50) NOT NULL,
	fechaModificación DATETIME NULL,
	modificadaPor VARCHAR(50) NULL,
	fechaRegistroHistorial DATETIME NOT NULL DEFAULT GETDATE(),
	usuarioSistema VARCHAR(50) NOT NULL DEFAULT SYSTEM_USER
);


CREATE TABLE UsuariosHistorial (
	idVersiónUsuario INT IDENTITY(1, 1) PRIMARY KEY,
	idUsuario INT NOT NULL,
	nombreUsuario VARCHAR(50) NULL,
	apellidoUsuario VARCHAR(50) NULL,
	documentoUsuario VARCHAR(25) NULL,
	idEps INT NULL,
	fechaCreación DATETIME NOT NULL,                 
	creadaPor VARCHAR(50) NOT NULL,                  
	fechaModificación DATETIME NULL,                      
	modificadaPor VARCHAR(50) NULL,                       
	fechaRegistroHistorial DATETIME NOT NULL DEFAULT GETDATE(),  
	usuarioSistema VARCHAR(50) NOT NULL DEFAULT SYSTEM_USER
);

CREATE TABLE PerfilesHistorial (
	idVersiónPerfil INT IDENTITY(1, 1) PRIMARY KEY,
	idPerfilUsuario INT NOT NULL,
	nombrePerfil VARCHAR(50) UNIQUE CHECK (TRIM(nombrePerfil) <> ''),
	contraseñaPerfil VARCHAR(50) CHECK (TRIM(contraseñaPerfil) <> ''),
	emailPerfil VARCHAR(254) NULL,
	idFotoDePerfil INT NULL,
	idRol INT NULL,
	fechaCreaciónPerfil DATE NULL,
	fechaCreación DATETIME NOT NULL,                 
	creadaPor VARCHAR(50) NOT NULL,                  
	fechaModificación DATETIME NULL,                      
	modificadaPor VARCHAR(50) NULL,                       
	fechaRegistroHistorial DATETIME NOT NULL DEFAULT GETDATE(),  
	usuarioSistema VARCHAR(50) NOT NULL DEFAULT SYSTEM_USER
);

CREATE TABLE PuntosDeInterésHistorial (
	idVersiónPuntoDeInterés INT IDENTITY(1, 1) PRIMARY KEY,
	idPuntoDeInterés INT NOT NULL,
	nombrePuntoDeInterés VARCHAR(50) NULL,
	descripcionPuntoDeInterés VARCHAR(MAX) NULL,
	latitudPuntoDeInterés DECIMAL(8,6) NULL,
	longitudPuntoDeInterés DECIMAL(9,6) NULL,
	fechaCreación DATETIME NOT NULL,                 
	creadaPor VARCHAR(50) NOT NULL,                  
	fechaModificación DATETIME NULL,                      
	modificadaPor VARCHAR(50) NULL,                       
	fechaRegistroHistorial DATETIME NOT NULL DEFAULT GETDATE(),  
	usuarioSistema VARCHAR(50) NOT NULL DEFAULT SYSTEM_USER
);


CREATE TABLE ServiciosHistorial (
	idVersiónServicio INT IDENTITY(1, 1) PRIMARY KEY,
	idServicio INT NOT NULL,
	nombreServicio VARCHAR(50) NULL,
	descripciónServicio VARCHAR(500) NULL,
	costoServicio DECIMAL(10,2) NULL,
	idRangoEdad INT NULL,
	fechaCreación DATETIME NOT NULL,                 
	creadaPor VARCHAR(50) NOT NULL,                  
	fechaModificación DATETIME NULL,                      
	modificadaPor VARCHAR(50) NULL,                       
	fechaRegistroHistorial DATETIME NOT NULL DEFAULT GETDATE(),  
	usuarioSistema VARCHAR(50) NOT NULL DEFAULT SYSTEM_USER
);

CREATE TABLE ReseñasHistorial (
	idVersiónReseña INT IDENTITY(1, 1) PRIMARY KEY,
	idReseña INT NOT NULL,
	fechaPublicaciónReseña DATETIME2 NULL,
	comentarioReseña VARCHAR(500) NULL,
	idPerfil INT NULL,
	idValorCalificación INT NULL,
	fechaCreación DATETIME NOT NULL,                 
	creadaPor VARCHAR(50) NOT NULL,                  
	fechaModificación DATETIME NULL,                      
	modificadaPor VARCHAR(50) NULL,                       
	fechaRegistroHistorial DATETIME NOT NULL DEFAULT GETDATE(),  
	usuarioSistema VARCHAR(50) NOT NULL DEFAULT SYSTEM_USER
);
