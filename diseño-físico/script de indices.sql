USE Freetour
GO

CREATE INDEX idx_sitioTour ON Tours(idSitio)

CREATE INDEX idx_sitioGuía ON Guías(idSitioGuía)

CREATE INDEX idx_reservaTour ON Reservas(idSesiónTour)

CREATE INDEX idx_propinaGuía ON Propinas(idGuía)

CREATE INDEX idx_NombreSitio ON Sitios(NombreSitio)

CREATE INDEX idx_fechaRealizaciónReserva ON Reservas(fechaRealizaciónReserva)

CREATE INDEX idx_fechaTour ON Fechastour(fecha)

CREATE INDEX idx_Reservas_TuristaSesion ON Reservas(idSesiónTour)

CREATE INDEX idx_EstadosPorReserva_ReservaFecha ON EstadosPorReserva(idReserva, fechaInicioEstado)

CREATE INDEX idx_regiónNombre ON Regiones(nombreRegión)

CREATE INDEX idx_ReseñasTour_idTour ON ReseñasDelTour(idTour, idReseñaTour)

CREATE INDEX idx_ReseñasPunto_idPunto ON ReseñasDelPuntoTurístico(idPuntoTurístico, idReseñaPunto)

CREATE INDEX idx_ReseñasGuía_idGuía ON ReseñasDelGuía(idGuíaReseñado, idReseñaGuía)

CREATE INDEX idx_emailPerfil ON Perfiles(emailPerfil)

CREATE INDEX idx_nombreApellidoUsuario ON Usuarios(nombreUsuario, apellidoUsuario)
