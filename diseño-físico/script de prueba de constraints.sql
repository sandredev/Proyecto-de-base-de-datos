-------------------------------------------
-- TiposDeLocalización
-------------------------------------------
-- Violación de PRIMARY KEY (idTipoLocalización duplicado)
INSERT INTO TiposDeLocalización (idTipoLocalización, nombreTipoLocalización)
VALUES (1, 'Ciudad duplicada'); 

-------------------------------------------
-- Localizaciones
-------------------------------------------
-- Violación de CHECK (nombre vacío)
INSERT INTO Localizaciones (idLocalización, nombre, latitud, longitud, idTipoLocalización)
VALUES (4, '   ', 4.7110, -74.0721, 1);

-- Violación de CHECK (coordenadas fuera de rango de Colombia)
INSERT INTO Localizaciones (idLocalización, nombre, latitud, longitud, idTipoLocalización)
VALUES (5, 'Tokio', 35.6895, 139.6917, 1);

-- Violación de FOREIGN KEY (tipo de localización inexistente)
INSERT INTO Localizaciones (idLocalización, nombre, latitud, longitud, idTipoLocalización)
VALUES (6, 'Lugar Fantasma', 5.0000, -74.0000, 999);

-------------------------------------------
-- Idiomas
-------------------------------------------
-- Violación de UNIQUE (nombre repetido)
INSERT INTO Idiomas (idIdioma, nombre)
VALUES (4, 'Español');

-- Violación de CHECK (nombre vacío)
INSERT INTO Idiomas (idIdioma, nombre)
VALUES (5, '  ');

-------------------------------------------
-- Guías
-------------------------------------------
-- Violación de UNIQUE (teléfono repetido)
INSERT INTO Guías (idGuía, nombres, apellidos, documento, fotoDePerfil, email, teléfono, esVerificado, biografía, idLocalización)
VALUES (3, 'Pedro', 'Rojas', 33333333, 'pedro.jpg', 'pedro@correo.com', '+573001234567', 1, 'Guía duplicado teléfono', 1);

-- Violación de CHECK (documento con longitud < 7)
INSERT INTO Guías (idGuía, nombres, apellidos, documento, fotoDePerfil, email, teléfono, esVerificado, biografía, idLocalización)
VALUES (4, 'Luis', 'Mejía', 123, 'luis.jpg', 'luis@correo.com', '+573444555666', 1, 'Documento demasiado corto', 1);

-- Violación de CHECK (nombre vacío)
INSERT INTO Guías (idGuía, nombres, apellidos, documento, fotoDePerfil, email, teléfono, esVerificado, biografía, idLocalización)
VALUES (5, '   ', 'Santos', 55555555, 'foto.jpg', 'santos@correo.com', '+573887654321', 1, 'Nombre vacío', 1);

-- Violación de CHECK (teléfono sin '+')
INSERT INTO Guías (idGuía, nombres, apellidos, documento, fotoDePerfil, email, teléfono, esVerificado, biografía, idLocalización)
VALUES (6, 'Marta', 'Díaz', 99999999, 'marta.jpg', 'marta@correo.com', '3001112233', 1, 'Teléfono sin prefijo +', 1);

-- Violación de CHECK (email sin formato correcto)
INSERT INTO Guías (idGuía, nombres, apellidos, documento, fotoDePerfil, email, teléfono, esVerificado, biografía, idLocalización)
VALUES (7, 'Esteban', 'Moreno', 88888888, 'esteban.jpg', 'estebancorreo.com', '+573009876543', 1, 'Email sin @', 1);

-- Violación de FOREIGN KEY (idLocalización inexistente)
INSERT INTO Guías (idGuía, nombres, apellidos, documento, fotoDePerfil, email, teléfono, esVerificado, biografía, idLocalización)
VALUES (8, 'Diego', 'Suárez', 77777777, 'diego.jpg', 'diego@correo.com', '+573002221111', 1, 'Localización inválida', 999);

-------------------------------------------
-- Turistas
-------------------------------------------
-- Violación de UNIQUE (teléfono repetido)
INSERT INTO Turistas (idTurista, nombres, apellidos, email, teléfono, fotoDePerfil, documento, perfil)
VALUES (3, 'María', 'Pérez', 'maria@correo.com', '+573101234567', 'maria.jpg', 55555555, 'Teléfono duplicado');

-- Violación de CHECK (documento con longitud > 18)
INSERT INTO Turistas (idTurista, nombres, apellidos, email, teléfono, fotoDePerfil, documento, perfil)
VALUES (4, 'Pedro', 'López', 'pedro@correo.com', '+573601234567', 'pedro.jpg', 1234567890123456789, 'Documento demasiado largo');

-- Violación de CHECK (email inválido)
INSERT INTO Turistas (idTurista, nombres, apellidos, email, teléfono, fotoDePerfil, documento, perfil)
VALUES (5, 'Andrea', 'Gómez', 'andrea_correo.com', '+573771234567', 'andrea.jpg', 12345678, 'Email incorrecto');

-------------------------------------------
-- Tours
-------------------------------------------
-- Violación de CHECK (nombre vacío)
INSERT INTO Tours (idTour, temática, duración, nombre, puntoDeEncuentro, puntosDeInterés, disponibilidad, descripción, numParticipantes, estáActivo, idLocalización)
VALUES (3, 'Naturaleza', 120, '  ', 'Parque Central', 'Bosque Alto', 'Diario', 'Nombre vacío', 10, 1, 1);

-- Violación de CHECK (duración negativa)
INSERT INTO Tours (idTour, temática, duración, nombre, puntoDeEncuentro, puntosDeInterés, disponibilidad, descripción, numParticipantes, estáActivo, idLocalización)
VALUES (4, 'Aventura', -30, 'Tour extremo', 'Puente Colgante', 'Cascada del Sol', 'Mensual', 'Duración negativa', 10, 1, 1);

-- Violación de FOREIGN KEY (localización inexistente)
INSERT INTO Tours (idTour, temática, duración, nombre, puntoDeEncuentro, puntosDeInterés, disponibilidad, descripción, numParticipantes, estáActivo, idLocalización)
VALUES (5, 'Arte', 60, 'Tour de arte', 'Museo de Arte', 'Galería Nacional', 'Semanal', 'Localización inexistente', 10, 1, 999);

-------------------------------------------
-- IdiomasPorGuia
-------------------------------------------
-- Violación de FOREIGN KEY (idioma inexistente)
INSERT INTO IdiomasPorGuia (idIdioma, idGuía)
VALUES (999, 1);

-- Violación de FOREIGN KEY (guía inexistente)
INSERT INTO IdiomasPorGuia (idIdioma, idGuía)
VALUES (1, 999);

-------------------------------------------
-- IdiomasPorTour
-------------------------------------------
-- Violación de FOREIGN KEY (tour inexistente)
INSERT INTO IdiomasPorTour (idIdioma, idTour)
VALUES (1, 999);

-------------------------------------------
-- IdiomasPorTurista
-------------------------------------------
-- Violación de FOREIGN KEY (turista inexistente)
INSERT INTO IdiomasPorTurista (idIdioma, idTurista)
VALUES (1, 999);

-------------------------------------------
-- Reservas
-------------------------------------------
-- Violación de CHECK (cuposReservados <= 0)
INSERT INTO Reservas (idReserva, cuposReservados, estadoReserva, idTuristaReserva, idTour)
VALUES (3, 0, 'Confirmada', 1, 1);

-- Violación de CHECK (estadoReserva vacío)
INSERT INTO Reservas (idReserva, cuposReservados, estadoReserva, idTuristaReserva, idTour)
VALUES (4, 3, '   ', 1, 1);

-- Violación de FOREIGN KEY (idTour inexistente)
INSERT INTO Reservas (idReserva, cuposReservados, estadoReserva, idTuristaReserva, idTour)
VALUES (5, 2, 'Pendiente', 1, 999);

