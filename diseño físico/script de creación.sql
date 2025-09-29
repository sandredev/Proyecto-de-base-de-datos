CREATE TABLE Paises (
	idPaís INT,
	nombrePaís VARCHAR(56) NOT NULL,
	CONSTRAINT PKPaíses PRIMARY KEY (idPaís)
);

CREATE TABLE Ciudades (
	idCiudad INT,
	nombreCiudad VARCHAR(85) NOT NULL,
	idPaísCiudad INT NOT NULL,
	CONSTRAINT PKCiudades PRIMARY KEY (idCiudad),
	CONSTRAINT FKPaís FOREIGN KEY (idPaísCiudad) REFERENCES Paises(idPaís)
);

CREATE TABLE Guías (
	idGuía INT,
	nombresGuía VARCHAR(60) NOT NULL,
	apellidosGuía VARCHAR(60) NOT NULL,
	foroDePerfilGuía VARCHAR(MAX) NOT NULL,
	emailGuía VARCHAR(254) NOT NULL,
	telefonoGuía VARCHAR(20) NOT NULL,
	esVerificado BIT NOT NULL,
	biografiaGuia VARCHAR(MAX) NOT NULL,
	idCiudadGuía INT NOT NULL,
	CONSTRAINT PKGuías PRIMARY KEY (idGuía),
	CONSTRAINT FKCiudadGuía FOREIGN KEY (idCiudadGuía) REFERENCES Ciudades(idCiudad)
);

CREATE TABLE Tours (
	idTour INT,
	tematicaTour VARCHAR(100) NOT NULL,
	duracionTour TIME NOT NULL,
	nombreTour VARCHAR(100) NOT NULL,
	puntoDeEncuentroTour VARCHAR(MAX) NOT NULL,
	disponibilidadTour DATETIME NOT NULL,
	descripciónTour VARCHAR(MAX) NOT NULL,
	numParticipantesTour INT NOT NULL,
	estáActivo BIT NOT NULL,
	idCiudadTour INT NOT NULL,
	CONSTRAINT PKTours PRIMARY KEY (idTour),
	CONSTRAINT FKCiudadTour FOREIGN KEY (idCiudadTour) REFERENCES Ciudades(idCiudad)
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
	CONSTRAINT PKTurista PRIMARY KEY (idTurista)
);

CREATE TABLE IdiomasPorTurista (
	idIdioma INT,
	idTurista INT,
	CONSTRAINT FKIdiomaTurista FOREIGN KEY (idIdioma) REFERENCES Idiomas(idIdioma),
	CONSTRAINT FKTurista FOREIGN KEY (idTurista) REFERENCES Turistas(idTurista),
);

CREATE TABLE Reservas (
	idReserva INT,
	cuposReservados INT NOT NULL,
	estadoReserva VARCHAR(20) NOT NULL,
	idTuristaReserva INT,
	CONSTRAINT PKReservas PRIMARY KEY (idReserva),
	CONSTRAINT FKTuristaReserva FOREIGN KEY (idTuristaReserva) REFERENCES Turistas(idTurista)
);