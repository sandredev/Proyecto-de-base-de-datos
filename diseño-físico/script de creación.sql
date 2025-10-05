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
	CONSTRAINT RangoGeograficoColombia CHECK (latitud BETWEEN -4.2 AND 13.5
											AND longitud BETWEEN -79.0 AND -66.0)
);

CREATE TABLE Guías (
	idGuía INT,
	nombres VARCHAR(50) NOT NULL,
	apellidos VARCHAR(50) NOT NULL,
	documento BIGINT NOT NULL,
	foroDePerfil VARCHAR(MAX) NOT NULL,
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
	CONSTRAINT BiografíaGuíaVálida CHECK (TRIM(biografía) <> '')
);

CREATE TABLE Tours (
	idTour INT,
	temática VARCHAR(100) NOT NULL,
	duración INT NOT NULL,
	nombre VARCHAR(100) NOT NULL,
	puntoDeEncuentro VARCHAR(150),
	puntosDeInterés VARCHAR(1000) NOT NULL,
	disponibilidad DATETIME2 NOT NULL,
	descripción VARCHAR(1000) NOT NULL,
	numParticipantes INT,
	estáActivo BIT NOT NULL,
	idLocalización INT NOT NULL,
	CONSTRAINT PKTours PRIMARY KEY (idTour),
	CONSTRAINT NombreTourVálido CHECK (TRIM(nombre) <> ''),
	CONSTRAINT TemáticaVálida CHECK (TRIM(temática) <> ''),
	CONSTRAINT PuntoVálida CHECK (TRIM(puntoDeEncuentro) <> ''),
	CONSTRAINT NumeroParticipantesPositivos CHECK (numParticipantes > 0),
	CONSTRAINT DuraciónVálida CHECK (duración > 0 AND duración <= 720),
	CONSTRAINT PuntosDeInterésVálidos CHECK (TRIM(puntosDeInterés) <> ''), 
	CONSTRAINT DescripciónVálida CHECK (TRIM(descripción) <> ''),
	CONSTRAINT FKLocalizaciónTour FOREIGN KEY (idLocalización) REFERENCES Localizaciones(idLocalización)
);

CREATE TABLE Idiomas (
	idIdioma INT,
	nombre VARCHAR(30) NOT NULL,
	CONSTRAINT PKIdiomas PRIMARY KEY (idIdioma),
	CONSTRAINT nombreIdiomaÚnico UNIQUE (nombre),
	CONSTRAINT NombreIdiomaVálido CHECK (TRIM(nombre) <> '') 
);

CREATE TABLE IdiomasPorTour (
	idIdioma INT,
	idGuía INT,
	CONSTRAINT FKIdiomaTour FOREIGN KEY (idIdioma) REFERENCES Idiomas(idIdioma),
	CONSTRAINT FKGuíaTour FOREIGN KEY (idGuía) REFERENCES Guías(idGuía),
);

CREATE TABLE Turistas (
	idTurista INT,
	nombres VARCHAR(50) NOT NULL,
	apellidos VARCHAR(50) NOT NULL,
	email VARCHAR(254) NOT NULL,
	teléfono VARCHAR(20) NOT NULL,
	fotoDePerfil VARCHAR(MAX) NOT NULL,
	documento BIGINT NOT NULL,
	perfil VARCHAR(MAX), 
	CONSTRAINT PKTurista PRIMARY KEY (idTurista),
	CONSTRAINT TeléfonoTuristaÚnico UNIQUE (teléfono),
	CONSTRAINT documentoTuristaVálido CHECK (LEN(CAST(documento AS VARCHAR(20))) >= 7
								   AND LEN(CAST(documento AS VARCHAR(20))) <= 18),
	CONSTRAINT NombresTuristaVálidos CHECK (TRIM(nombres) <> ''),
	CONSTRAINT ApellidosTuristaVálidos CHECK (TRIM(apellidos) <> ''),
	CONSTRAINT NúmeroTuristaVálido CHECK (teléfono LIKE '+%'),
	CONSTRAINT EmailTuristaVálido CHECK (email LIKE '_%@_%._%')
);

CREATE TABLE IdiomasPorGuia (
	idIdioma INT,
	idGuía INT,
	CONSTRAINT FKIdiomaGuía FOREIGN KEY (idIdioma) REFERENCES Idiomas(idIdioma),
	CONSTRAINT FKGuía FOREIGN KEY (idGuía) REFERENCES Guías(idGuía),
);

CREATE TABLE Reservas (
	idReserva INT,
	cuposReservados INT NOT NULL,
	estadoReserva VARCHAR(20) NOT NULL,
	idTuristaReserva INT,
	idTour INT
	CONSTRAINT PKReservas PRIMARY KEY (idReserva),
	CONSTRAINT PKPositiva CHECK (idReserva > 0),
	CONSTRAINT FKTuristaReserva FOREIGN KEY (idTuristaReserva) REFERENCES Turistas(idTurista),
	CONSTRAINT FKTourReserva FOREIGN KEY (idTour) REFERENCES Tours(idTour),
	CONSTRAINT CuposPositivos CHECK (cuposReservados > 0),
	CONSTRAINT estadoVálido CHECK (TRIM(estadoReserva) <> '')
);

CREATE TABLE IdiomasPorTurista (
	idIdioma INT,
	idTurista INT,
	CONSTRAINT FKIdiomaPorTurista FOREIGN KEY (idTurista) REFERENCES Turistas(idTurista),
	CONSTRAINT FKTuristaPorIdioma FOREIGN KEY (idIdioma) REFERENCES Idiomas(idIdioma)
); 