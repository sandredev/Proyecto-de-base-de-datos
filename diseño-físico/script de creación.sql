CREATE TABLE TiposDeLocalización (
	idTipoLocalización INT,
	nombreTipoLocalización VARCHAR(100),
	CONSTRAINT PKTiposDeLocalización PRIMARY KEY (idTipoLocalización)
);

CREATE TABLE Localizaciones (
	idLocalización INT,
	nombreLocalización VARCHAR(100) NOT NULL,
	idTipoLocalización INT NOT NULL,
	CONSTRAINT PKLocalizaciones PRIMARY KEY (idLocalización),
	CONSTRAINT FKTipoLocalización FOREIGN KEY (idTipoLocalización) REFERENCES TiposDeLocalización(idTipoLocalización)
);

CREATE TABLE Guías (
	idGuía INT,
	nombresGuía VARCHAR(60) NOT NULL,
	apellidosGuía VARCHAR(60) NOT NULL,
	documentoGuía INT NOT NULL,
	foroDePerfilGuía VARCHAR(MAX) NOT NULL,
	emailGuía VARCHAR(254) NOT NULL,
	telefonoGuía VARCHAR(20) NOT NULL,
	esVerificado BIT NOT NULL,
	biografiaGuia VARCHAR(MAX),
	idLocalización INT,
	CONSTRAINT PKGuías PRIMARY KEY (idGuía),
	CONSTRAINT FKLocalizaciónGuía FOREIGN KEY (idLocalización) REFERENCES Localizaciones(idLocalización),
	CONSTRAINT TelefonoGuíaÚnico UNIQUE (telefonoGuía),
	CONSTRAINT DocumentoGuíaÚnico UNIQUE (documentoGuía)
);

CREATE TABLE Tours (
	idTour INT,
	tematicaTour VARCHAR(100) NOT NULL,
	duracionTour TIME NOT NULL,
	nombreTour VARCHAR(100) NOT NULL,
	puntoDeEncuentroTour VARCHAR(150),
	disponibilidadTour DATETIME NOT NULL,
	descripciónTour VARCHAR(1000) NOT NULL,
	numParticipantesTour INT,
	estáActivo BIT NOT NULL,
	idLocalización INT NOT NULL,
	CONSTRAINT PKTours PRIMARY KEY (idTour),
	CONSTRAINT FKLocalizaciónTour FOREIGN KEY (idLocalización) REFERENCES Localizaciones(idLocalización)
);

CREATE TABLE Idiomas (
	idIdioma INT,
	nombreIdioma VARCHAR(30) NOT NULL,
	CONSTRAINT PKIdiomas PRIMARY KEY (idIdioma),
	CONSTRAINT nombreIdiomaÚnico UNIQUE (nombreIdioma)
);

CREATE TABLE IdiomasPorTour (
	idIdioma INT,
	idGuía INT,
	CONSTRAINT FKIdiomaTour FOREIGN KEY (idIdioma) REFERENCES Idiomas(idIdioma),
	CONSTRAINT FKGuíaTour FOREIGN KEY (idGuía) REFERENCES Guías(idGuía),
);

CREATE TABLE Turistas (
	idTurista INT,
	nombresTurista VARCHAR(60) NOT NULL,
	apellidosTurista VARCHAR(60) NOT NULL,
	emailTurista VARCHAR(254) NOT NULL,
	telefonoTurista VARCHAR(20) NOT NULL,
	fotoDePerfilTurista VARCHAR(MAX) NOT NULL,
	perfilTurista VARCHAR(MAX) NOT NULL, 
	CONSTRAINT PKTurista PRIMARY KEY (idTurista),
	CONSTRAINT TelefonoTuristaÚnico UNIQUE (telefonoTurista)
);

CREATE TABLE IdiomasPorGuia (
	idIdioma INT,
	idGuía INT,
	CONSTRAINT FKIdiomaGuia FOREIGN KEY (idIdioma) REFERENCES Idiomas(idIdioma),
	CONSTRAINT FKGuía FOREIGN KEY (idGuía) REFERENCES Guías(idGuía),
);

CREATE TABLE Reservas (
	idReserva INT,
	cuposReservados INT NOT NULL,
	estadoReserva VARCHAR(20) NOT NULL,
	idTuristaReserva INT,
	CONSTRAINT PKReservas PRIMARY KEY (idReserva),
	CONSTRAINT FKTuristaReserva FOREIGN KEY (idTuristaReserva) REFERENCES Turistas(idTurista)
);

CREATE TABLE IdiomasPorTurista (
	idIdioma INT,
	idTurista INT,
	CONSTRAINT FKIdiomaPorTurista FOREIGN KEY (idTurista) REFERENCES Turistas(idTurista),
	CONSTRAINT FKTuristaPorIdioma FOREIGN KEY (idIdioma) REFERENCES Idiomas(idIdioma)
);