USE Freetour;
GO
SET NOCOUNT ON;

--------------------------------------------------------------------------------
-- BASES / CATÁLOGOS SIMPLES
--------------------------------------------------------------------------------

-- Regiones
INSERT INTO Regiones (nombreRegión, descripciónRegión, superficieRegión) VALUES
('Andina','Zona montañosa central del país',250000.00),
('Caribe','Costa norte con climas cálidos',70000.50),
('Pacífica','Costa pacífica y selva cercana',90000.00),
('Orinoquía','Llanuras orientales',150000.00);

-- Países
INSERT INTO Países (nombrePaís, códigoIsoNúmerico, códigoIso3, códigoTeléfonico) VALUES
('Colombia',170,'COL','+57'),
('Estados Unidos',840,'USA','+1');

-- Monedas
INSERT INTO Monedas (nombreMoneda, códigoIsoMoneda, símboloMoneda) VALUES
('Peso colombiano','COP','$'),
('Dólar estadounidense','USD','US$');

-- TiposDeLocalizaciones
INSERT INTO TiposDeLocalizaciones (nombreTipoLocalización, descripciónTipoLocalización) VALUES
('Parque','Áreas abiertas de recreación'),
('Museo','Lugares culturales con colecciones'),
('Playa','Ubicaciones costeras'),
('Monumento','Lugares históricos o esculturas');

-- TiposDeFormato
INSERT INTO TiposDeFormato (nombreTipoFormato, descripciónTipoFormato) VALUES
('Imagen','Formato de imagen (jpg, png)'),
('Video','Formato de vídeo (mp4)'),
('Documento','PDF o similar');

-- TiposTeléfonos
INSERT INTO TiposTeléfonos (nombreTipoTeléfono, descripciónTipoTeléfono) VALUES
('Móvil','Teléfono celular'),
('Fijo','Línea fija'),
('Trabajo','Teléfono laboral');

-- TiposPrestadoresDeServicios
INSERT INTO TiposPrestadoresDeServicios (nombreTipoPrestador, descripciónTipoPrestador) VALUES
('Transporte','Servicios de transporte'),
('Alimentación','Restauración'),
('Operador Aventura','Actividades de aventura');

-- RangosEdades
INSERT INTO RangosEdades (nombreRangoEdad, descripciónRangoEdad) VALUES
('Para toda la familia','Apto para todas las edades'),
('Para mayores de 10','Niños menores de 10 no recomendados'),
('Para mayores de 12','Actividad con algo de esfuerzo'),
('Para mayores de 17','Requiere responsabilidad'),
('Solo adultos','18+');

-- Roles
INSERT INTO Roles (nombreRol) VALUES ('Guía'),('Turista');

-- ValoresCalificación
INSERT INTO ValoresCalificación (rasgoCaracterístico, valorNumérico) VALUES
('Deficiente',1),('Regular',2),('Bueno',3),('Muy bueno',4),('Excelente',5);

-- DetallesAdicionales
INSERT INTO DetallesAdicionales (nombreDetalle, descripciónDetalle) VALUES
('Accesibilidad','Rutas accesibles para sillas de ruedas'),
('Mascotas','Se permiten mascotas con correa'),
('Guía bilingüe','Guía que habla inglés');

-- Estados (generales)
INSERT INTO Estados (nombreEstado, descripciónEstado) VALUES
('Operativo','Disponible para visitas'),
('Mantenimiento','Temporalmente en mantenimiento'),
('Cerrado','Cerrado permanentemente o temporalmente');

-- Climas
INSERT INTO Climas (nombreClima, descripciónClima, temperaturaPromedioClima, humedadPromedioClima) VALUES
('Ecuatorial','Clima húmedo y caliente',27.50,85.00),
('Templado','Clima templado de montaña',15.00,70.00),
('Seco','Zonas con menor humedad',28.00,50.00);

--------------------------------------------------------------------------------
-- DEPARTAMENTOS (requieren Regiones)
--------------------------------------------------------------------------------
INSERT INTO Departamentos (nombreDepartamento, descripciónDepartamento, códigoDane, idRegión) VALUES
('Cundinamarca','Departamento central donde está Bogotá',25,1),
('Antioquia','Región andina con Medellín',5,1),
('Atlántico','Costa Caribe con Barranquilla',8,2),
('Bolívar','Cartagena y zona caribe',13,2),
('Chocó','Región pacífica',27,3),
('Meta','Orinoquía con Villavicencio',50,4),
('Risaralda','Eje cafetero',66,1),
('Valle del Cauca','Cali y sus valles',76,1),
('Nariño','Suroccidente, costa pacífica',52,3),
('Boyacá','Zona andina',15,1);

--------------------------------------------------------------------------------
-- SITIOS (requieren TiposDeLocalizaciones, Departamentos)
--------------------------------------------------------------------------------
INSERT INTO Sitios (nombreSitio, latitudSitio, longitudSitio, idTipoLocalización, idDepartamento) VALUES
('Centro Histórico', 4.711111, -74.071111, 4, 1),
('Parque Nacional', 5.054000, -75.520000, 1, 7),
('Playa Central', 10.988000, -74.804000, 3, 3),
('Museo Central', 4.712000, -74.070500, 2, 1),
('Reserva Bosque', 3.200500, -76.520500, 1, 5),
('Mirador del Valle', 6.259000, -75.561000, 1, 2),
('Zona Gastronómica', 4.715500, -74.073500, 4, 1),
('Pueblo Histórico', 6.265000, -75.565000, 4, 2),
('Sendero Natural', 5.060000, -75.525000, 1, 7),
('Playa Sur', 2.450000, -78.900000, 3, 9),
('Centro Cultural', 4.730500, -74.049500, 2, 1),
('Estación Mirador', 6.261000, -75.562000, 1, 2);

--------------------------------------------------------------------------------
-- EPS
--------------------------------------------------------------------------------
INSERT INTO Eps (NITEps, nombreEps, direcciónEps, emailEps) VALUES
('900123456-1','SaludTotal','Calle 10 #20-30','contacto@saludtotal.com'),
('800654321-2','Nueva EPS','Avenida 5 #40-10','info@nuevaeps.com.co'),
('900000111-3','EPSEjemplo','Carrera 7 #50-20','servicios@epsejemplo.co');

--------------------------------------------------------------------------------
-- USUARIOS
--------------------------------------------------------------------------------
INSERT INTO Usuarios (nombreUsuario, apellidoUsuario, documentoUsuario, idEps) VALUES
('Andrés','Gómez','CC100000001',1),
('María','Pérez','CC100000002',2),
('Juan','Rodríguez','CC100000003',1),
('Laura','Martínez','CC100000004',3),
('Diego','Santos','CC100000005',1),
('Catalina','Ruiz','CC100000006',2),
('Santiago','Vargas','CC100000007',1),
('Ana','López','CC100000008',2),
('Miguel','Cárdenas','CC100000009',1),
('Lucía','Castro','CC100000010',3),
('Pedro','Mejía','CC100000011',1),
('Valentina','Ríos','CC100000012',2),
('Camilo','Ortiz','CC100000013',1),
('Paula','Herrera','CC100000014',2),
('Esteban','Ruíz','CC100000015',3);

--------------------------------------------------------------------------------
-- PERFILES (usa ids de Usuarios ya insertados: idPerfilUsuario coincide con idUsuario)
--------------------------------------------------------------------------------
INSERT INTO Perfiles (idPerfilUsuario, nombrePerfil, contraseñaPerfil, emailPerfil, idFotoDePerfil, idRol, fechaCreaciónPerfil)
VALUES
(1,'andres_g','Pwd12345','andres.g@example.com',NULL,2,'2024-08-01'),
(2,'maria_p','Pwd12345','maria.p@example.com',NULL,2,'2024-09-12'),
(3,'juan_r','Pwd12345','juan.r@example.com',NULL,2,'2024-07-03'),
(4,'laura_m','Pwd12345','laura.m@example.com',NULL,2,'2024-10-01'),
(5,'diego_s','Pwd12345','diego.s@example.com',NULL,2,'2024-06-20'),
(6,'catalina_r','Pwd12345','catalina.r@example.com',NULL,2,'2024-05-15'),
(7,'santiago_v','Pwd12345','santiago.v@example.com',NULL,2,'2024-04-10'),
(8,'ana_l','Pwd12345','ana.l@example.com',NULL,2,'2024-11-01'),
(9,'miguel_c','Pwd12345','miguel.c@example.com',NULL,2,'2024-03-21'),
(10,'lucia_c','Pwd12345','lucia.c@example.com',NULL,2,'2024-08-15'),
(11,'pedro_m','Pwd12345','pedro.m@example.com',NULL,1,'2024-02-10'),
(12,'valentina_r','Pwd12345','valentina.r@example.com',NULL,1,'2024-01-05'),
(13,'camilo_o','Pwd12345','camilo.o@example.com',NULL,1,'2024-09-20'),
(14,'paula_h','Pwd12345','paula.h@example.com',NULL,1,'2024-07-10'),
(15,'esteban_r','Pwd12345','esteban.r@example.com',NULL,1,'2024-11-05');

--------------------------------------------------------------------------------
-- TURISTAS (perfiles 1..10)
--------------------------------------------------------------------------------
INSERT INTO Turistas (idPerfilTurista) VALUES (1),(2),(3),(4),(5),(6),(7),(8),(9),(10);

--------------------------------------------------------------------------------
-- GUÍAS (perfiles 11..15)
--------------------------------------------------------------------------------
INSERT INTO Guías (idPerfilGuía, esVerificado, biografíaGuía, descripciónGuía, idSitioGuía) VALUES
(1,1,'Guía certificado con 3 años de experiencia','Especializado en rutas urbanas',6),
(11,1,'Guía local certificado con 8 años de experiencia','Especializado en rutas históricas',4),
(12,0,'Guía naturalista y fotógrafo','Rutas de naturaleza y observación de aves',5),
(13,1,'Guía bilingüe (es/en)','Tours culturales y gastronómicos',11),
(14,0,'Guía con experiencia en turismo joven','Rutas urbanas y nocturnas',6),
(15,0,'Guía ocasional','Apoya en eventos puntuales',1);

--------------------------------------------------------------------------------
-- IDIOMAS
--------------------------------------------------------------------------------
INSERT INTO Idiomas (nombreIdioma, descripciónIdioma) VALUES
('Español','Idioma principal en Colombia'),
('Inglés','Idioma internacional'),
('Portugués','Idioma fronterizo en algunos sitios');

-- IdiomasPorPerfil (asignaciones)
INSERT INTO IdiomasPorPerfil (idIdioma, idPerfil) VALUES
(1,11),(2,11),(1,12),(1,13),(2,13),(1,14),(1,15);

--------------------------------------------------------------------------------
-- TiposDeFormato y ArchivosMultimedia (archivos usados en perfiles/reseñas)
--------------------------------------------------------------------------------
INSERT INTO ArchivosMultimedia (nombreArchivoMultimedia, pesoEnMB, idTipoFormato) VALUES
('foto_perfil_1.jpg',0.45,1),
('foto_tour_1.jpg',1.20,1),
('video_presentacion.mp4',12.50,2),
('mapa_ruta.pdf',0.80,3),
('foto_punto_1.jpg',0.90,1),
('foto_guia_1.jpg',0.50,1);

-- Actualiza Perfiles para asociar foto de perfil 1 a id 1 como ejemplo
UPDATE Perfiles SET idFotoDePerfil = 1 WHERE idPerfilUsuario = 1;

--------------------------------------------------------------------------------
-- TEMÁTICAS
--------------------------------------------------------------------------------
INSERT INTO Temáticas (nombreTemática, descripciónTemática, idRangoEdadRecomendada) VALUES
('Historia','Tours sobre el pasado y patrimonio',1),
('Naturaleza','Observación y senderismo',1),
('Gastronomía','Rutas culinarias',1),
('Aventura','Actividades de aventura',3),
('Nocturno','Rutas y eventos nocturnos',4),
('Fotografía','Rutas para fotografía',1);

--------------------------------------------------------------------------------
-- PUNTOS DE INTERÉS
--------------------------------------------------------------------------------
INSERT INTO PuntosDeInterés (nombrePuntoDeInterés, descripcionPuntoDeInterés, latitudPuntoDeInterés, longitudPuntoDeInterés) VALUES
('Plaza Mayor','Plaza histórica del centro',4.710988,-74.072090),
('Museo Colonial','Colección de objetos coloniales',4.711000,-74.070000),
('Parque Central','Parque urbano con vegetación',4.720000,-74.080000),
('Playa Azul','Playa con oleaje moderado',10.990000,-74.800000),
('Mirador Verde','Mirador con vista panorámica',6.250000,-75.570000),
('Bosque Andino','Área protegida para senderismo',5.050000,-75.520000),
('Cascada Escondida','Cascada en zona de selva',3.200000,-76.520000),
('Museo de Arte','Colecciones modernas',6.266667,-75.567778),
('Plaza del Mar','Plaza frente al mar',10.987000,-74.805000),
('Ruta Gastronómica','Zona con restaurantes locales',4.715000,-74.073000),
('Piedra Histórica','Roca con significado cultural',6.260000,-75.560000),
('Jardín Botánico','Colección de flora nativa',4.730000,-74.050000);

--------------------------------------------------------------------------------
-- TOURS
--------------------------------------------------------------------------------
INSERT INTO Tours (nombreTour, puntoDeEncuentroTour, maxParticipantesTour, duraciónTour, descripciónTour, idGuíaPrincipalTour, idSitio)
VALUES
('Tour Histórico Centro',1,20,2.50,'Recorrido por la plaza y museos principales',11,4),
('Sendero Bosque',6,12,4.00,'Sendero guiado por bosque andino',12,5),
('Tour Gastronómico',10,15,3.00,'Degustación de platos locales',13,7),
('Mirador y Atardecer',5,10,1.75,'Caminata hasta el mirador y vista al atardecer',14,6),
('Playas del Norte',4,30,5.00,'Día en la playa con actividades',11,3);

--------------------------------------------------------------------------------
-- IdiomasPorTour, TemáticasDelTour, puntosDeInterésPorTour
--------------------------------------------------------------------------------
INSERT INTO IdiomasPorTour (idIdioma,idTour) VALUES
(1,1),(1,2),(1,3),(2,3),(2,5),(1,5);

INSERT INTO TemáticasDelTour (idTemática,idTour) VALUES
(1,1),(2,2),(3,3),(6,5),(2,5);

INSERT INTO puntosDeInterésPorTour (idPuntoDeInterés,idTour) VALUES
(1,1),(2,1),(3,1),
(6,2),(7,2),
(10,3),(11,3),
(5,4),(9,5);

--------------------------------------------------------------------------------
-- FechasTour y FechasPorTour
--------------------------------------------------------------------------------
INSERT INTO FechasTour (fecha) VALUES
('2025-10-20'),('2022-9-22'),('2024-12-01'),('2025-12-05'),('2025-11-25'),('2025-11-30');

INSERT INTO FechasPorTour (idFechaTour, idTour) VALUES
(1,1),(2,1),(3,2),(1,2),(4,3),(5,3),(6,4),(2,5);

--------------------------------------------------------------------------------
-- SesionesTour (usa CAST para TIME)
--------------------------------------------------------------------------------
INSERT INTO SesionesTour (idFechaTour, horaInicioSesión, horaFinSesión) VALUES
(1,CAST('09:00' AS TIME),CAST('11:30' AS TIME)),
(2,CAST('14:00' AS TIME),CAST('16:30' AS TIME)),
(3,CAST('08:00' AS TIME),CAST('12:00' AS TIME)),
(4,CAST('10:00' AS TIME),CAST('13:00' AS TIME)),
(5,CAST('17:00' AS TIME),CAST('20:00' AS TIME)),
(6,CAST('06:30' AS TIME),CAST('12:30' AS TIME));

--------------------------------------------------------------------------------
-- EstadosReserva
--------------------------------------------------------------------------------
INSERT INTO EstadosReserva (nombreEstado, descripciónEstado) VALUES
('Pendiente','Reserva creada, pendiente de confirmación'),
('Confirmada','Reserva confirmada por el guía'),
('Cancelada','Reserva cancelada por usuario o guía'),
('Finalizada','Reserva que se cumplió'),
('Expirada','No se usó el servicio'),
('En curso','Reserva en desarrollo');

--------------------------------------------------------------------------------
-- RESERVAS (referencian Turistas y SesionesTour)
--------------------------------------------------------------------------------
INSERT INTO Reservas (idTurista, cuposReservados, idSesiónTour, fechaRealizaciónReserva, fechaFinalizaciónReserva)
VALUES
(1,2,1,'2025-10-01','2025-11-20'),
(2,1,2,'2025-10-05','2025-11-22'),
(3,3,3,'2025-09-10',NULL),
(4,1,4,'2025-08-20',NULL);

--------------------------------------------------------------------------------
-- EstadosPorReserva (registro histórico)
--------------------------------------------------------------------------------

INSERT INTO EstadosPorReserva (idReserva, idEstado, descripciónEstadosPorReserva, fechaInicioEstado, fechaFinEstado) VALUES
(1,1,'Reserva creada','2025-01-01 10:00','2025-10-02 12:00'),
(1,2,'Confirmada por guía','2025-01-02 12:00','2025-11-15 00:00'),
(2,1,'Pendiente de pago','2025-10-05 09:00','2025-10-06 09:00'),
(3,5,'Expirada por no asistir','2025-09-15 00:00','2025-09-16 00:00');

--------------------------------------------------------------------------------
-- TemáticasPreferidasPorGuía y TemáticasPreferidaPorTurista
--------------------------------------------------------------------------------
INSERT INTO TemáticasPreferidasPorGuía (idGuía, idTemática) VALUES
(11,1),(11,2),(11,3),(11,4),(12,2),(13,3),(14,5);

INSERT INTO TemáticasPreferidaPorTurista (idTurista, idTemática) VALUES
(1,1),(2,3),(3,2),(4,3),(5,6);

--------------------------------------------------------------------------------
-- SERVICIOS
--------------------------------------------------------------------------------
INSERT INTO Servicios (nombreServicio, descripciónServicio, costoServicio, idRangoEdad) VALUES
('Transporte','Transporte ida y vuelta',45000.00,1),
('Almuerzo','Almuerzo típico incluido',30000.00,1),
('Equipo de seguridad','Arnés y casco (si aplica)',15000.00,3);

--------------------------------------------------------------------------------
-- TemáticasDelPuntoDeInterés y ServiciosPuntosDeInterés
--------------------------------------------------------------------------------
INSERT INTO TemáticasDelPuntoDeInterés (idTemática, idPuntoDeInterés) VALUES
(1,1),(2,6),(3,10),(6,7),(4,8);

INSERT INTO ServiciosPuntosDeInterés (idPuntoDeInterés, idServicio) VALUES
(6,1),(5,2),(7,3),(10,2);

--------------------------------------------------------------------------------
-- PRESTADORES DE SERVICIOS
--------------------------------------------------------------------------------
INSERT INTO PrestadoresDeServicios (nombreComercialPrestador, emailPrestadorServicio, razónSocialPrestadorServicio, descripciónPrestadorServicio) VALUES
('Transporte Express','contacto@transporteexp.com','Transporte Express S.A.S.','Servicio de transporte turístico'),
('Catering Local','info@cateringlocal.com','Catering Local S.A.','Servicios de alimentación para eventos'),
('Aventuras SAS','hola@aventuras.com','Aventuras SAS','Operador de actividades de aventura');

-- TipoPorPrestadorDeServicio (relaciones)
INSERT INTO TipoPorPrestadorDeServicio (idPrestadorServicio, idTipoPrestadorServicio) VALUES
(1,1),(2,2),(3,3);

-- ServiciosPorPrestador (sin duplicados)
INSERT INTO ServiciosPorPrestador (idPrestadorServicio, idServicio) VALUES
(1,1),(2,2),(3,3);

-- SitiosPorPrestadorDeServicio
INSERT INTO SitiosPorPrestadorDeServicio (idPrestadorServicio, idSitio) VALUES
(1,1),(2,7),(3,5);

--------------------------------------------------------------------------------
-- TELÉFONOS (cumplen CHECK +CC NNN...)
--------------------------------------------------------------------------------
INSERT INTO Teléfonos (númeroTeléfono, observacionesTeléfono, esPrincipal, idTipoTeléfono, idPaís) VALUES
('+57 3001234567','Personal',1,1,1),
('+57 3109876543','Oficina',0,3,1),
('+57 6021234567','Fijo oficina',0,2,1),
('+01 2025550183','Contacto USA',1,1,2);

-- TeléfonosUsuarios
INSERT INTO TeléfonosUsuarios (idTeléfono, idUsuario) VALUES
(1,1),(2,2),(3,11),(4,15);

-- TeléfonosPrestadoresDeServicio
INSERT INTO TeléfonosPrestadoresDeServicio (idTeléfono, idPrestadorServicio) VALUES
(2,1),(3,2);

-- TeléfonosEps
INSERT INTO TeléfonosEps (idTeléfono, idEps) VALUES
(1,1),(2,2);

--------------------------------------------------------------------------------
-- ETIQUETAS Y RELACIONES CON RESEÑAS
--------------------------------------------------------------------------------
INSERT INTO Etiquetas (nombreEtiqueta, descripciónEtiqueta) VALUES
('Familiar','Apto para familias'),('Aventura','Actividades de aventura'),
('Cultural','Interés cultural'),('Relax','Actividades tranquilas');

--------------------------------------------------------------------------------
-- RESEÑAS (INSERTAR ANTES DE TABLAS QUE DEPENDEN DE ELLAS)
--------------------------------------------------------------------------------
INSERT INTO Reseñas (fechaPublicaciónReseña, comentarioReseña, idPerfil, idValorCalificación) VALUES
('2025-01-10 12:00','Recorrido muy interesante',1,5),
('2025-03-05 16:30','Buena experiencia, guía amable',2,4),
('2025-06-20 09:00','El sendero estaba bien mantenido',3,4),
('2025-07-01 11:00','Comida deliciosa',4,5);

--------------------------------------------------------------------------------
-- ARCHIVOSPORRESEÑAS y ARCHIVOS MULTIMEDIA ya cargados arriba
INSERT INTO ArchivosPorReseñas (fechaSubidaArchivo, idReseña, idArchivoMultimedia) VALUES
('2021-01-05 11:40',3,3),
('2025-01-10 12:05',1,1),
('2025-03-05 16:40',2,2);

-- ReseñasDelPuntoTurístico / ReseñasDelTour / ReseñasDelGuía / ReseñasPrestadorDeServicios
INSERT INTO ReseñasDelPuntoTurístico (idReseñaPunto, idPuntoTurístico) VALUES (1,1);
INSERT INTO ReseñasDelTour (idReseñaTour, idTour) VALUES (2,1);
INSERT INTO ReseñasDelGuía (idReseñaGuía, idGuíaReseñado) VALUES (3,12);
-- No se inserta ReseñasPrestadorDeServicios con NULL; si quieres agregar, indica idPrestador válido.

-- EtiquetasPorReseña (usa reseñas ya existentes)
INSERT INTO EtiquetasPorReseña (idEtiqueta, idReseña) VALUES (1,1),(3,2),(2,3);

--------------------------------------------------------------------------------
-- DETALLESRESEÑAS (dependen de DetallesAdicionales y ValoresCalificación y Reseñas)
--------------------------------------------------------------------------------
INSERT INTO DetallesReseñas (idDetalleAdicional, idValorCalificación, idReseña) VALUES
(1,5,1),(3,4,2);

--------------------------------------------------------------------------------
-- MEDIOSDE PAGO
--------------------------------------------------------------------------------
INSERT INTO MediosDePago (nombreMedioDePago, descripciónMedioDePago, requiereComisión) VALUES
('Tarjeta crédito','Pago con tarjeta',1),
('Efectivo','Pago en efectivo',0),
('Transferencia','PSE o transferencia bancaria',1);

--------------------------------------------------------------------------------
-- PROPINAS (requieren Guías, MediosDePago, Tours y Monedas)
--------------------------------------------------------------------------------
INSERT INTO Propinas (fechaPagoPropina, montoPropina, idGuía, idMedioDePago, idTour, idMoneda) VALUES
('2025-07-02 14:00',20000.00,11,2,1,1),
('2025-08-10 12:30',15000.00,12,1,2,1);

--------------------------------------------------------------------------------
-- CALIFICACIONESRESEÑA Y CALIFICACIONESDE LARESENA POR PERFIL
--------------------------------------------------------------------------------
INSERT INTO CalificacionesReseña (idReseña, idValorCalificación, comentario) VALUES
(1,5,'Excelente reseña y muy útil'),
(2,4,'Opinión sólida');

INSERT INTO CalificacionesDeLaReseñaPorPerfil (idCalificación, idPerfil) VALUES
(1,2),(2,1);

--------------------------------------------------------------------------------
-- TEMÁTICAS RELACIONADAS CON PUNTOS DE INTERÉS y SERVICIOS ya pobladas arriba
--------------------------------------------------------------------------------

--------------------------------------------------------------------------------
-- GUÍAS POR TOUR (evita repetir pares)
--------------------------------------------------------------------------------
INSERT INTO GuíasPorTour (idGuía, idTour) VALUES
(11,1),(12,2),(13,3),(14,4),(11,5),(12,5);

--------------------------------------------------------------------------------
-- PAISES POR USUARIOS y MONEDAS POR PAISES
--------------------------------------------------------------------------------
INSERT INTO PaísesPorUsuarios (idUsuario, idPaís) VALUES (1,1),(2,1),(4,1),(15,2);
INSERT INTO MonedasPorPaíses (idMoneda, idPaís) VALUES (1,1),(2,2);

--------------------------------------------------------------------------------
-- FIN
SET NOCOUNT OFF;
GO

