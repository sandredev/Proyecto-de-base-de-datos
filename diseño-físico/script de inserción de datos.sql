INSERT INTO TiposDeLocalización (nombreTipoLocalización)
VALUES ('Ciudad'), ('Pueblo'), ('Parque Natural'), ('Sitio Arqueológico');

INSERT INTO Localizaciones (nombre, latitud, longitud, idTipoLocalización)
VALUES 
('Bogotá', 4.7110, -74.0721, 1),
('Medellín', 6.2518, -75.5636, 1),
('Villa de Leyva', 5.6340, -73.5233, 2),
('Tayrona', 11.3000, -74.0833, 3);

INSERT INTO PuntosDeInterés (nombre, descripción, latitud, longitud, tipos, serviciosYActividades, estado)
VALUES
('Museo del Oro', 'Museo histórico con una amplia colección precolombina.', 4.5981, -74.0760, 'Cultural', 'Visitas guiadas', 'Activo'),
('Parque Arví', 'Reserva ecológica con senderos naturales y actividades al aire libre.', 6.3106, -75.5080, 'Ecológico', 'Caminatas, picnic', 'Activo'),
('Plaza Mayor de Villa de Leyva', 'Plaza central colonial rodeada de arquitectura tradicional.', 5.6345, -73.5237, 'Histórico', 'Turismo cultural', 'Activo');

INSERT INTO Tours (temática, duración, nombre, idPuntoDeInterésInicial, disponibilidad, descripción, maxParticipantes, estáActivo, idLocalización)
VALUES
('Historia Precolombina', 4.5, 'Tour Museo del Oro', 1, '2025-11-01 09:00:00', 'Recorrido guiado por el Museo del Oro.', 20, 1, 1),
('Aventura Natural', 6.0, 'Senderismo en Arví', 2, '2025-11-02 08:00:00', 'Excursión por los senderos del Parque Arví.', 15, 1, 2),
('Turismo Colonial', 3.0, 'Tour por Villa de Leyva', 3, '2025-11-03 10:00:00', 'Caminata guiada por la plaza mayor y calles históricas.', 25, 1, 3);


INSERT INTO Usuarios (nombres, apellidos, teléfono, tieneEPS, documentoUsuario, idLocalización)
VALUES
('Carlos', 'Ramírez', '+57 3001234567', 1, '123456789', 1),
('Laura', 'González', '+57 3117654321', 1, '987654321', 2),
('Andrés', 'Martínez', '+57 3029988776', 0, '135792468', 3);


INSERT INTO Idiomas (nombre)
VALUES ('Español'), ('Inglés'), ('Francés');


INSERT INTO Perfiles (idPerfil, fotoDePerfil, email, fechaCreación, idIdioma)
VALUES
(1, 'carlos.jpg', 'carlos@example.com', '2024-12-01', 1),
(2, 'laura.png', 'laura@example.com', '2025-01-15', 2),
(3, 'andres.jpeg', 'andres@example.com', '2025-02-10', 1);


INSERT INTO Guías (idGuía, esVerificado, biografía, descripción)
VALUES
(1, 1, 'Guía con experiencia en historia y arqueología.', 'Especialista en tours culturales e históricos.'),
(2, 0, 'Apasionada por la naturaleza y los deportes al aire libre.', 'Guía de senderismo y actividades ecológicas.');


INSERT INTO Turistas (idTurista)
VALUES (3);


INSERT INTO PuntosDeInterésDelTour (idTour, idPuntoDeInterés)
VALUES
(1, 1),
(2, 2),
(3, 3);


INSERT INTO IdiomasPorPerfil (idIdioma, idPerfil)
VALUES
(1, 1),
(2, 2),
(1, 3);


INSERT INTO IdiomasPorTour (idIdioma, idTour)
VALUES
(1, 1),
(2, 1),
(1, 2),
(3, 3);


INSERT INTO Reservas (cuposReservados, estadoReserva, idTuristaReserva, idTour)
VALUES
(2, 'Confirmada', 3, 1),
(1, 'Pendiente', 3, 2);
