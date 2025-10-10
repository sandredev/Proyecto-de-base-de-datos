CREATE TABLE TiposDeLocalización (
	idTipoLocalización INT,
	nombreTipoLocalización VARCHAR(100),
	CONSTRAINT PKTiposDeLocalización PRIMARY KEY (idTipoLocalización)
);

CREATE TABLE Localizaciones (
	idLocalización INT,
	nombre VARCHAR(100) NOT NULL,
	latitud DECIMAL(8, 6) NOT NULL,
	longitud DECIMAL(9, 6) NOT NULL,
	idTipoLocalización INT NOT NULL,
	CONSTRAINT PKLocalizaciones PRIMARY KEY (idLocalización),
	CONSTRAINT FKTipoLocalización FOREIGN KEY (idTipoLocalización) REFERENCES TiposDeLocalización(idTipoLocalización),
	CONSTRAINT NombreLocalizaciónVálida CHECK (TRIM(nombre) <> ''),
	CONSTRAINT RangoGeográficoColombia CHECK (latitud BETWEEN -4.2 AND 13.5
											AND longitud BETWEEN -79.0 AND -66.0)
);

CREATE TABLE Guías (
	idGuía INT,
	nombres VARCHAR(50) NOT NULL,
	apellidos VARCHAR(50) NOT NULL,
	documento BIGINT NOT NULL,
	fotoDePerfil VARCHAR(MAX) NOT NULL,
	email VARCHAR(254) NOT NULL,
	teléfono VARCHAR(20) NOT NULL,
	esVerificado BIT NOT NULL,
	biografía VARCHAR(1000),
	idLocalización INT,
	CONSTRAINT PKGuías PRIMARY KEY (idGuía),
	CONSTRAINT FKLocalizaciónGuía FOREIGN KEY (idLocalización) REFERENCES Localizaciones(idLocalización),
	CONSTRAINT TelefonoGuíaÚnico UNIQUE (teléfono),
	CONSTRAINT DocumentoGuíaÚnico UNIQUE (documento),
	CONSTRAINT documentoGuíaVálido CHECK (LEN(CAST(documento AS VARCHAR(20))) >= 7
								   AND LEN(CAST(documento AS VARCHAR(20))) <= 18),
	CONSTRAINT NombresGuíaVálidos CHECK (TRIM(nombres) <> ''),
	CONSTRAINT ApellidosGuíaVálidos CHECK (TRIM(apellidos) <> ''),
	CONSTRAINT NúmeroGuíaVálido CHECK (teléfono LIKE '+%'),
	CONSTRAINT EmailGuíaVálido CHECK (email LIKE '_%@_%._%'),
	CONSTRAINT BiografíaGuíaVálida CHECK (TRIM(biografía) <> ''),
	CONSTRAINT FotoDePerfilVálida CHECK (TRIM(fotoDePerfil) <> '' AND fotoDePerfil LIKE '_%._%')
);

CREATE TABLE Tours (
	idTour INT,
	temática VARCHAR(100) NOT NULL,
	duración INT NOT NULL,
	nombre VARCHAR(100) NOT NULL,
	puntoDeEncuentro VARCHAR(150),
	puntosDeInterés VARCHAR(1000) NOT NULL,
	disponibilidad VARCHAR(100) NOT NULL,
	descripción VARCHAR(1000) NOT NULL,
	maxParticipantes INT,
	estáActivo BIT NOT NULL,
	idLocalización INT NOT NULL,
	CONSTRAINT PKTours PRIMARY KEY (idTour),
	CONSTRAINT NombreTourVálido CHECK (TRIM(nombre) <> ''),
	CONSTRAINT TemáticaVálida CHECK (TRIM(temática) <> ''),
	CONSTRAINT PuntoVálida CHECK (TRIM(puntoDeEncuentro) <> ''),
	CONSTRAINT NumeroParticipantesPositivos CHECK (maxParticipantes > 0),
	CONSTRAINT DuraciónVálida CHECK (duración > 0 AND duración <= 720), 
	CONSTRAINT DescripciónVálida CHECK (TRIM(descripción) <> ''),
	CONSTRAINT FKLocalizaciónTour FOREIGN KEY (idLocalización) REFERENCES Localizaciones(idLocalización)
);

CREATE TABLE Usuarios (
	idUsuario INT,
	nombres VARCHAR(50) NOT NULL,
	apellidos VARCHAR(50) NOT NULL,
	teléfono VARCHAR(20) NOT NULL,
	tieneEPS BIT NOT NULL,
	documentoUsuario VARCHAR(30) NOT NULL,
	idLocalización INT NOT NULL,
	CONSTRAINT PKUsuarios PRIMARY KEY (idUsuario),
	CONSTRAINT FKLocalizaciónUsuario FOREIGN KEY (idLocalización) REFERENCES Localizaciones(idLocalización),
	CONSTRAINT NombresVálidos CHECK (TRIM(nombres) <> '' AND nombres NOT LIKE '%[^0-9]%'),
	CONSTRAINT ApellidosVálidos CHECK (TRIM(apellidos) <> '' AND apellidos NOT LIKE '%[^0-9]%'),
	CONSTRAINT DocumentoVálido CHECK (TRIM(documentoUsuario) <> '' AND LEN(documentoUsuario) >= 7),
	CONSTRAINT TeléfonoÚnico UNIQUE (teléfono),
	CONSTRAINT TeléfonoVálido CHECK (teléfono LIKE '+[0-9][0-9] %[0-9]%' 
									OR teléfono LIKE '+[0-9][0-9][0-9] %[0-9]%') -- cadenas que empiezan en +núm 
																		         -- donde núm es un número de 2 a 3 digitos
																				 -- y les sigue una cadena con almenos un número en ellas
																				 -- (es lo más cercano que se puede hacer a validar un número de teléfono)
);

CREATE TABLE PuntosDeInterés (
	idPuntoDeInterés INT,
	nombre VARCHAR(100) NOT NULL,
	descripción VARCHAR(1000),
	latitud DECIMAL(8, 6) NOT NULL,
	longitud DECIMAL(9, 6) NOT NULL,
	tipos VARCHAR(100) NOT NULL,
	serviciosYActividades VARCHAR(100) NOT NULL,
	estado VARCHAR(20) NOT NULL,
	CONSTRAINT PKPuntosDeInterés PRIMARY KEY (idPuntoDeInterés),
	CONSTRAINT NombrePuntoDeInterésNoVacío CHECK (TRIM(nombre) <> ''),
	CONSTRAINT DescripciónPuntoDeInterésVálida CHECK (TRIM(descripción) <> ''),
	CONSTRAINT RangoGeográficoColombiaPuntoDeInterés CHECK (latitud BETWEEN -4.2 AND 13.5
											AND longitud BETWEEN -79.0 AND -66.0),
	CONSTRAINT TiposPuntoDeInterésNoVacío CHECK (TRIM(tipos) <> ''),
	CONSTRAINT ServiciosYActividadesNoVacío CHECK (TRIM(serviciosYActividades) <> ''),
	CONSTRAINT EstadoPuntoDeInterésNoVacío CHECK (TRIM(estado) <> '')
);

CREATE TABLE PuntosDeInterésDelTour (
	idTour INT,
	idPuntoDeInterés INT,
	idPuntoTour INT,
	CONSTRAINT FKTourPorPuntosDeInterés FOREIGN KEY (idTour) REFERENCES Tours(idTour),
	CONSTRAINT FKPuntosDeInterésPorTour FOREIGN KEY (idPuntoDeInterés) REFERENCES PuntosDeInterés(idPuntoDeInterés),
	CONSTRAINT PKPuntosDeInterésDelTour PRIMARY KEY (idPuntoTour)
);

CREATE TABLE Idiomas (
	idIdioma INT,
	nombre VARCHAR(30) NOT NULL,
	CONSTRAINT PKIdiomas PRIMARY KEY (idIdioma),
	CONSTRAINT nombreIdiomaÚnico UNIQUE (nombre),
	CONSTRAINT NombreIdiomaVálido CHECK (TRIM(nombre) <> '') 
);

CREATE TABLE Perfiles (
	idPerfil INT,
	fotoDePerfil VARCHAR(100),
	email VARCHAR(254),
	fechaCreación DATETIME2,
	idIdioma INT,
	idTour INT,
	CONSTRAINT FKIdiomaTour FOREIGN KEY (idIdioma) REFERENCES Idiomas(idIdioma),
	CONSTRAINT FKTourIdioma FOREIGN KEY (idTour) REFERENCES Tours(idTour),
);

CREATE TABLE Turistas (
	idTurista INT,
	CONSTRAINT PKTurista PRIMARY KEY (idTurista),
	CONSTRAINT FKTuristaPerfil FOREIGN KEY (idTurista) REFERENCES Perfiles(idPerfil)
);

CREATE TABLE IdiomasPorPerfil (
	idIdioma INT,
	idPerfil INT,
	CONSTRAINT FKIdiomaGuía FOREIGN KEY (idIdioma) REFERENCES Idiomas(idIdioma),
	CONSTRAINT FKPerfil FOREIGN KEY (idPerfil) REFERENCES Perfiles(idPerfil),
);

CREATE TABLE IdiomasPorTour (
	idIdioma INT,
	idTour INT,
	CONSTRAINT FKIdiomaTour FOREIGN KEY (idIdioma) REFERENCES Idiomas(idIdioma),
	CONSTRAINT FKTourIdioma FOREIGN KEY (idTour) REFERENCES Tours(idTour)
);

CREATE TABLE Reservas (
	idReserva INT,
	cuposReservados INT NOT NULL,
	estadoReserva VARCHAR(20) NOT NULL,
	idTuristaReserva INT,
	idTour INT,
	CONSTRAINT PKReservas PRIMARY KEY (idReserva),
	CONSTRAINT PKPositiva CHECK (idReserva > 0),
	CONSTRAINT FKTuristaReserva FOREIGN KEY (idTuristaReserva) REFERENCES Turistas(idTurista),
	CONSTRAINT FKTourReserva FOREIGN KEY (idTour) REFERENCES Tours(idTour),
	CONSTRAINT CuposPositivos CHECK (cuposReservados > 0),
	CONSTRAINT estadoVálido CHECK (TRIM(estadoReserva) <> '')
);