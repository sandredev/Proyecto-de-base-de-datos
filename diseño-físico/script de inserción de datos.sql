USE freetour
-- Datos de prueba
INSERT INTO Países(nombrePaís, códigoIsoNúmerico, códigoIso3, códigoTeléfonico)
VALUES ('Colombia', 123, 'COL', '+57');         
INSERT INTO Eps(NITEps, nombreEps, direcciónEps, emailEps)
VALUES (1232131, 'Sanitas', 'Cr 21 #20-25', 'sanitasEps@gmail.com');
INSERT INTO Usuarios(nombreUsuario, apellidoUsuario, documentoUsuario, idEps)
VALUES ('Santiago', 'Torres', '111111111', 1);
INSERT INTO Roles(nombreRol)
VALUES ('turista'), ('guía');
INSERT INTO Perfiles(idPerfilUsuario, nombrePerfil, contraseñaPerfil, emailPerfil, idFotoDePerfil, idRol, fechaCreaciónPerfil)
VALUES
	(1, 'santielpro12' ,'asadasadsda','andrestofor@gmail.com', NULL, 1, GETDATE());
INSERT INTO Turistas(idPerfilTurista)
VALUES (1);
INSERT INTO ValoresCalificación(rasgoCaracterístico, valorNumérico)
VALUES
	('Terrible', 0),
	('Decepcionante', 1),
	('Mejorable', 2),
	('Bien', 3),
	('Excelente', 4),
	('Perfecto', 5);
INSERT INTO TiposDeFormato(nombreTipoFormato)
VALUES ('png'), ('jpeg'), ('jpg'), ('webt');
INSERT INTO Regiones(nombreRegión, descripciónRegión, superficieRegión)
VALUES ('Caribe', 'Se ubica al norte del país', 231888);
INSERT INTO Departamentos (nombreDepartamento, descripciónDepartamento,  códigoDane, idRegión)
VALUES ('Magdalena', 'Departamento más antigüo de Colombia', 2131231231, 1);
INSERT INTO TiposDeLocalizaciones(nombreTipoLocalización)
VALUES ('Universidad');
INSERT INTO Sitios(idDepartamento, nombreSitio, latitudSitio, longitudSitio, idTipoLocalización)
VALUES (1, 'Universidad del Magdalena', 11.13, -74.11, 1);
INSERT INTO PuntosDeInterés(nombrePuntoDeInterés, latitudPuntoDeInterés, longitudPuntoDeInterés)
VALUES ('Entrada campus', 11.13, -74.11);
INSERT INTO Guías(idPerfilGuía, descripciónGuía, esVerificado, biografíaGuía, idSitioGuía)
VALUES (1, 'Ama jugar al osu', 1, 'Nació en Santa Marta', 1);
INSERT INTO Tours(nombreTour, idPuntoDeEncuentroTour, maxParticipantesTour, duraciónTour, descripciónTour, idGuíaPrincipalTour, idSitio)
VALUES ('Tour unimag', 1, 30, 7.0, 'Un tour por el campus de la Universidad del Magdalena', 1, 1);
INSERT INTO FechasTour(fecha) 
VALUES ('2026-01-01');
INSERT INTO FechasPorTour(idFechaTour, idTour)
VALUES (1, 1);
INSERT INTO SesionesTour(idFechaTour, horaInicioSesión, horaFinSesión)
VALUES (1, '14:30', '21:30');
INSERT INTO EstadosReserva(nombreEstado, descripciónEstado)
VALUES
	('Pendiente', 'Especifica si una reseña está pendiente por ser confirmada'),
	('Confirmada', 'Indica que el cliente hará uso del servicio'),
	('Cancelada', 'La reserva fue cancelada'),
	('Finalizada', 'El cliente hizo uso de la reserva'),
	('Expirada', 'El cliente no hizo uso de la reserva y ya pasó la fecha'),
	('En curso', 'El cliente está haciendo uso de la reserva en este instante');
INSERT INTO TiposTeléfonos(nombreTipoTeléfono)
VALUES ('iPhone');

-- IMPORTANTE: estas inserciones requieren de haber ejecutado con anterioridad 
-- el script de creación de los procedimientos
DECLARE @idReseñaRegistrada INT;
EXEC registrarReseña
	'El guía que me atendió fue terrible',
	1,
	0,
	@idReseña = @idReseñaRegistrada OUT


EXEC registrarReseña
	'La comida es excelente',
	1,
	5,
	@idReseña = @idReseñaRegistrada


DECLARE @idDetalleReseñaGenerado INT;
EXEC añadirDetalleReseña
	@idReseña = 1,
	@detalle = 'servicio al cliente',
	@valorCalificación = 2,
	@idDetalleReseña = @idDetalleReseñaGenerado;

EXEC añadirDetalleReseña
	@idReseña = 2,
	@detalle = 'servicio al cliente',
	@valorCalificación = 4,
	@idDetalleReseña = @idDetalleReseñaGenerado;

EXEC registrarUsuarioTuristaGuía
	'Samuel', 'Polo', 'Polo777', '123456', '2222221222', 'Sanitas', 'pololo@gmail.com', 'shrek_musculoso', 1.2, 'png', 'Guía', 1,
	 'Nací en Santa Marta, estudié ingeniería de sistemas y terminé siendo asesor turistico', 'sabe inglés', 'Universidad del Magdalena'

EXEC reservar 
	'santielpro12',
	12,
	1

DECLARE @idTel INT;
EXEC registrarTeléfono
    @númeroTeléfono = '+57 3123456789',
    @idTipoTeléfono = 1,
    @idPaís = 1,
    @idUsuario = 1,
    @idTeléfono = @idTel OUT;

EXEC cambiarEstadoReserva
	1,
	'Cancelada',
	'El cliente no llegó al punto de encuentro'
