------------------------------------------------------------
-- TABLA: Localizaciones
------------------------------------------------------------
-- CHECK NombreLocalizaciónVálida
INSERT INTO Localizaciones (nombre, latitud, longitud, idTipoLocalización)
VALUES ('   ', 4.5, -74.0, 1);

-- CHECK RangoGeográficoColombia (latitud fuera del rango)
INSERT INTO Localizaciones (nombre, latitud, longitud, idTipoLocalización)
VALUES ('Fuera de Colombia', -10.0, -74.0, 1);

-- Violación FKTipoLocalización (tipo inexistente)
INSERT INTO Localizaciones (nombre, latitud, longitud, idTipoLocalización)
VALUES ('Lugar Fantasma', 5.0, -73.0, 99);


------------------------------------------------------------
-- TABLA: PuntosDeInterés
------------------------------------------------------------
-- Nombre vacío
INSERT INTO PuntosDeInterés (nombre, descripción, latitud, longitud, tipos, serviciosYActividades, estado)
VALUES ('', 'Descripción válida', 4.5, -74.0, 'Tipo', 'Servicio', 'Activo');

-- Descripción vacía
INSERT INTO PuntosDeInterés (nombre, descripción, latitud, longitud, tipos, serviciosYActividades, estado)
VALUES ('Punto sin descripción', '   ', 4.5, -74.0, 'Tipo', 'Servicio', 'Activo');

-- Latitud fuera del rango permitido
INSERT INTO PuntosDeInterés (nombre, descripción, latitud, longitud, tipos, serviciosYActividades, estado)
VALUES ('Punto fuera', 'Fuera de Colombia', 20.0, -74.0, 'Tipo', 'Servicio', 'Activo');

-- Tipos vacío
INSERT INTO PuntosDeInterés (nombre, descripción, latitud, longitud, tipos, serviciosYActividades, estado)
VALUES ('Punto sin tipo', 'Tiene descripción', 4.5, -74.0, ' ', 'Servicio', 'Activo');

-- ServiciosYActividades vacío
INSERT INTO PuntosDeInterés (nombre, descripción, latitud, longitud, tipos, serviciosYActividades, estado)
VALUES ('Punto sin servicios', 'Descripción', 4.5, -74.0, 'Tipo', '   ', 'Activo');

-- Estado vacío
INSERT INTO PuntosDeInterés (nombre, descripción, latitud, longitud, tipos, serviciosYActividades, estado)
VALUES ('Punto sin estado', 'Descripción', 4.5, -74.0, 'Tipo', 'Servicio', '   ');


------------------------------------------------------------
-- TABLA: Tours
------------------------------------------------------------
-- Nombre vacío
INSERT INTO Tours (temática, duración, nombre, idPuntoDeInterésInicial, disponibilidad, descripción, maxParticipantes, estáActivo, idLocalización)
VALUES ('Historia', 4.0, '', 1, '2025-11-01', 'Desc.', 10, 1, 1);

-- Temática vacía
INSERT INTO Tours (temática, duración, nombre, idPuntoDeInterésInicial, disponibilidad, descripción, maxParticipantes, estáActivo, idLocalización)
VALUES (' ', 4.0, 'Tour sin temática', 1, '2025-11-01', 'Desc.', 10, 1, 1);

-- maxParticipantes <= 0
INSERT INTO Tours (temática, duración, nombre, idPuntoDeInterésInicial, disponibilidad, descripción, maxParticipantes, estáActivo, idLocalización)
VALUES ('Historia', 4.0, 'Tour sin cupos', 1, '2025-11-01', 'Desc.', 0, 1, 1);

-- duración fuera del rango
INSERT INTO Tours (temática, duración, nombre, idPuntoDeInterésInicial, disponibilidad, descripción, maxParticipantes, estáActivo, idLocalización)
VALUES ('Historia', 1000, 'Tour largo', 1, '2025-11-01', 'Desc.', 10, 1, 1);

-- descripción vacía
INSERT INTO Tours (temática, duración, nombre, idPuntoDeInterésInicial, disponibilidad, descripción, maxParticipantes, estáActivo, idLocalización)
VALUES ('Historia', 4.0, 'Tour sin descripción', 1, '2025-11-01', '   ', 10, 1, 1);

-- FKLocalizaciónTour inválida
INSERT INTO Tours (temática, duración, nombre, idPuntoDeInterésInicial, disponibilidad, descripción, maxParticipantes, estáActivo, idLocalización)
VALUES ('Historia', 4.0, 'Tour con localización inexistente', 1, '2025-11-01', 'Desc.', 10, 1, 999);

-- FKPuntoDeInicioTour inválida
INSERT INTO Tours (temática, duración, nombre, idPuntoDeInterésInicial, disponibilidad, descripción, maxParticipantes, estáActivo, idLocalización)
VALUES ('Historia', 4.0, 'Tour con punto inexistente', 999, '2025-11-01', 'Desc.', 10, 1, 1);


------------------------------------------------------------
-- TABLA: Usuarios
------------------------------------------------------------
-- Nombres vacíos
INSERT INTO Usuarios (nombres, apellidos, teléfono, tieneEPS, documentoUsuario, idLocalización)
VALUES (' ', 'Ramírez', '+57 3000000000', 1, '123456789', 1);

-- Apellidos vacíos
INSERT INTO Usuarios (nombres, apellidos, teléfono, tieneEPS, documentoUsuario, idLocalización)
VALUES ('Carlos', ' ', '+57 3000000000', 1, '123456789', 1);

-- Documento corto
INSERT INTO Usuarios (nombres, apellidos, teléfono, tieneEPS, documentoUsuario, idLocalización)
VALUES ('Carlos', 'Ramírez', '+57 3000000000', 1, '1234', 1);

-- Teléfono duplicado
INSERT INTO Usuarios (nombres, apellidos, teléfono, tieneEPS, documentoUsuario, idLocalización)
VALUES ('Juan', 'Pérez', '+57 3001234567', 1, '987654321', 1);

-- Teléfono formato inválido
INSERT INTO Usuarios (nombres, apellidos, teléfono, tieneEPS, documentoUsuario, idLocalización)
VALUES ('Juan', 'Pérez', '3001234567', 1, '123456789', 1);

-- FKLocalizaciónUsuario inválida
INSERT INTO Usuarios (nombres, apellidos, teléfono, tieneEPS, documentoUsuario, idLocalización)
VALUES ('Laura', 'López', '+57 3110000000', 0, '111222333', 999);


------------------------------------------------------------
-- TABLA: Perfiles
------------------------------------------------------------
-- Foto de perfil vacía
INSERT INTO Perfiles (idPerfil, fotoDePerfil, email, fechaCreación, idIdioma)
VALUES (1, ' ', 'foto@example.com', '2024-12-01', 1);

-- Email inválido
INSERT INTO Perfiles (idPerfil, fotoDePerfil, email, fechaCreación, idIdioma)
VALUES (2, 'perfil.png', 'correo_invalido', '2024-12-01', 1);

-- Fecha de creación futura
INSERT INTO Perfiles (idPerfil, fotoDePerfil, email, fechaCreación, idIdioma)
VALUES (3, 'perfil.png', 'futuro@example.com', '2100-01-01', 1);

-- FKPerfilesUsuario inválida
INSERT INTO Perfiles (idPerfil, fotoDePerfil, email, fechaCreación, idIdioma)
VALUES (999, 'perfil.png', 'error@example.com', '2024-12-01', 1);


------------------------------------------------------------
-- TABLA: Guías
------------------------------------------------------------
-- Biografía vacía
INSERT INTO Guías (idGuía, esVerificado, biografía, descripción)
VALUES (1, 0, '   ', 'Descripción válida');

-- FKGuíaPerfil inválida
INSERT INTO Guías (idGuía, esVerificado, biografía, descripción)
VALUES (999, 0, 'Biografía válida', 'Descripción válida');


------------------------------------------------------------
-- TABLA: Turistas
------------------------------------------------------------
-- FKTuristaPerfil inválida
INSERT INTO Turistas (idTurista)
VALUES (999);


------------------------------------------------------------
-- TABLA: Idiomas
------------------------------------------------------------
-- Nombre vacío
INSERT INTO Idiomas (nombre)
VALUES (' ');

-- Nombre duplicado
INSERT INTO Idiomas (nombre)
VALUES ('Español');


------------------------------------------------------------
-- TABLA: IdiomasPorPerfil
------------------------------------------------------------
-- FKIdiomaGuía inválida
INSERT INTO IdiomasPorPerfil (idIdioma, idPerfil)
VALUES (999, 1);

-- FKPerfil inválida
INSERT INTO IdiomasPorPerfil (idIdioma, idPerfil)
VALUES (1, 999);


------------------------------------------------------------
-- TABLA: IdiomasPorTour
------------------------------------------------------------
-- FKIdiomaTour inválida
INSERT INTO IdiomasPorTour (idIdioma, idTour)
VALUES (999, 1);

-- FKTourIdioma inválida
INSERT INTO IdiomasPorTour (idIdioma, idTour)
VALUES (1, 999);


------------------------------------------------------------
-- TABLA: Reservas
------------------------------------------------------------
-- Cupos negativos
INSERT INTO Reservas (cuposReservados, estadoReserva, idTuristaReserva, idTour)
VALUES (-5, 'Activa', 3, 1);

-- Estado vacío
INSERT INTO Reservas (cuposReservados, estadoReserva, idTuristaReserva, idTour)
VALUES (2, ' ', 3, 1);

-- FKTuristaReserva inválida
INSERT INTO Reservas (cuposReservados, estadoReserva, idTuristaReserva, idTour)
VALUES (2, 'Activa', 999, 1);

-- FKTourReserva inválida
INSERT INTO Reservas (cuposReservados, estadoReserva, idTuristaReserva, idTour)
VALUES (2, 'Activa', 3, 999);

