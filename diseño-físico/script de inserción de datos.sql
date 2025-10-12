INSERT INTO TiposDeLocalización (idTipoLocalización, nombreTipoLocalización)
VALUES 
(1, 'Ciudad'),
(2, 'Pueblo'),
(3, 'Playa'),
(4, 'Montaña');

INSERT INTO Localizaciones (idLocalización, nombre, latitud, longitud, idTipoLocalización)
VALUES
(1, 'Bogotá', 4.7110, -74.0721, 1),
(2, 'Medellín', 6.2442, -75.5812, 1),
(3, 'Cartagena', 10.3910, -75.4794, 3);

INSERT INTO Idiomas (idIdioma, nombre)
VALUES
(1, 'Español'),
(2, 'Inglés'),
(3, 'Francés');

INSERT INTO Guías (idGuía, nombres, apellidos, documento, fotoDePerfil, email, teléfono, esVerificado, biografía, idLocalización)
VALUES
(1, 'Carlos', 'Pérez', 12345678, 'carlos.jpg', 'carlos@correo.com', '+573001234567', 1, 'Guía experimentado en Bogotá.', 1),
(2, 'Laura', 'Gómez', 87654321, 'laura.png', 'laura@correo.com', '+573221234567', 0, 'Apasionada por la historia de Medellín.', 2);

INSERT INTO Turistas (idTurista, nombres, apellidos, email, teléfono, fotoDePerfil, documento, perfil)
VALUES
(1, 'Ana', 'Torres', 'ana@correo.com', '+573101234567', 'ana.png', 10023456, 'Amante del turismo cultural.'),
(2, 'Javier', 'López', 'javier@correo.com', '+573501234567', 'javier.jpg', 20034567, 'Turista frecuente en Colombia.');

INSERT INTO Tours (idTour, temática, duración, nombre, puntoDeEncuentro, puntosDeInterés, disponibilidad, descripción, numParticipantes, estáActivo, idLocalización)
VALUES
(1, 'Historia', 180, 'Tour por el centro de Bogotá', 'Plaza Bolívar', 'Museo del Oro, Plaza Bolívar', 'Diario', 'Recorrido histórico por el centro de la ciudad.', 20, 1, 1),
(2, 'Cultura', 120, 'Tour en Medellín', 'Parque Berrío', 'Museo de Antioquia, Comuna 13', 'Fin de semana', 'Conoce la transformación social de Medellín.', 15, 1, 2);

INSERT INTO IdiomasPorGuia (idIdioma, idGuía)
VALUES
(1, 1), 
(2, 1), 
(1, 2); 
INSERT INTO IdiomasPorTour (idIdioma, idTour)
VALUES
(1, 1),
(2, 1),
(1, 2);

INSERT INTO IdiomasPorTurista (idIdioma, idTurista)
VALUES
(1, 1),
(2, 1),
(1, 2);

INSERT INTO Reservas (idReserva, cuposReservados, estadoReserva, idTuristaReserva, idTour)
VALUES
(1, 2, 'Confirmada', 1, 1),
(2, 3, 'Pendiente', 2, 2);

