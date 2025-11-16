USE Freetour;
GO

---Vistas---
-----1. tours disponibles--------
CREATE OR ALTER VIEW ToursDisponibles AS
SELECT 
    t.idTour,
    t.nombreTour AS 'Nombre Tour',
    f.fecha,
    CONCAT(U.nombreUsuario, ' ', U.apellidoUsuario) AS 'Nombre guía',
    t.maxParticipantesTour AS 'Cupos disponibles',
    i.nombreIdioma AS 'Idioma del Tour',
    r.nombreRegión AS 'Región'
FROM Tours t
INNER JOIN EstadosDelTour edt ON t.idTour = edt.idTour
INNER JOIN Estados e ON edt.idEstado = e.idEstado
LEFT JOIN GuíasPorTour gpt ON t.idTour = gpt.idTour
LEFT JOIN Guías g ON gpt.idGuía = g.idPerfilGuía
LEFT JOIN Perfiles p ON g.idPerfilGuía = p.idPerfilUsuario
LEFT JOIN Usuarios u ON p.idPerfilUsuario = u.idUsuario
LEFT JOIN IdiomasPorTour it ON t.idTour = it.idTour
LEFT JOIN Idiomas i ON it.idIdioma = i.idIdioma
LEFT JOIN Sitios s ON t.idSitio = s.idSitio
LEFT JOIN Departamentos d ON s.idDepartamento = d.idDepartamento
LEFT JOIN Regiones r ON d.idRegión = r.idRegión
LEFT JOIN FechasPorTour fpt ON t.idTour = fpt.idTour
LEFT JOIN FechasTour f ON fpt.idFechaTour = f.idFechaTour
WHERE e.nombreEstado = 'disponible'

GO

--------2. Reservas activas por turistas--------------
CREATE OR ALTER VIEW ReservasActivas AS
SELECT 
    r.idReserva,
    t.nombreTour AS 'Nombre Tour',
    r.fechaRealizaciónReserva AS 'Fecha reserva',
    ER.nombreEstado AS 'Estado reserva',
    CONCAT(u.nombreUsuario, ' ', u.apellidoUsuario) AS 'Nombre turista'
FROM Reservas r
JOIN SesionesTour st ON r.idSesiónTour = ST.idSesiónTour
JOIN FechasTour ft ON st.idFechaTour = ft.idFechaTour
JOIN FechasPorTour fpt ON ft.idFechaTour = fpt.idFechaTour
JOIN Tours t ON fpt.idTour = t.idTour
LEFT JOIN EstadosPorReserva EPR ON r.idReserva = epr.idReserva
LEFT JOIN EstadosReserva er ON epr.idEstado = er.idEstadoReserva
JOIN Turistas tu ON r.idTurista = tu.idPerfilTurista
JOIN Perfiles pe ON tu.idPerfilTurista = pe.idPerfilUsuario
JOIN Usuarios u ON pe.idPerfilUsuario = u.idUsuario
WHERE er.nombreEstado IN ('Pendiente', 'Confirmada', 'En curso');

GO 

--------------------3. Reservas por turistas-------------------------
CREATE OR ALTER VIEW ReservaPorUsuario AS
SELECT
    CONCAT(u.nombreUsuario, ' ', u.apellidoUsuario) AS 'Nombre turistas',
    tou.nombreTour AS 'Nombre tour',
    s.horaInicioSesión AS 'Hora tour',
    ft.fecha AS 'Fecha Tour',
    r.cuposReservados AS Cupos,
    er.nombreEstado AS 'Estado reserva'
FROM Reservas r
JOIN Turistas tu ON r.idTurista = tu.idPerfilTurista
JOIN Perfiles p ON tu.idPerfilTurista = p.idPerfilUsuario
JOIN Usuarios u ON p.idPerfilUsuario = u.idUsuario
JOIN SesionesTour s ON r.idSesiónTour = s.idSesiónTour
JOIN FechasTour ft ON s.idFechaTour = ft.idFechaTour
JOIN FechasPorTour fpt ON ft.idFechaTour = fpt.idFechaTour
JOIN Tours tou ON fpt.idTour = tou.idTour
JOIN EstadosPorReserva epr ON r.idReserva = epr.idReserva
JOIN EstadosReserva er ON epr.idEstado = er.idEstadoReserva;

GO

-----------------4. Duracion en horas de cada sesion de los tours------------
CREATE OR ALTER VIEW DuracionSesiones AS
SELECT 
    s.idSesiónTour,
    t.nombreTour AS 'Nombre Tour',
    CAST(DATEDIFF(MINUTE, s.horaInicioSesión, s.horaFinSesión) / 60.0 AS DECIMAL(4,2)) AS 'Duración en horas'
FROM SesionesTour s
JOIN FechasTour ft ON s.idFechaTour = ft.idFechaTour
JOIN FechasPorTour fpt ON ft.idFechaTour = fpt.idFechaTour
JOIN Tours t ON fpt.idTour = t.idTour;

GO

------------5. Propinas totales por guia-----------------------------
CREATE OR ALTER  VIEW PropinasPorGuia AS
SELECT
    g.idPerfilGuía AS idGuia,
    CONCAT(u.nombreUsuario, ' ', u.apellidoUsuario) AS 'Nombre Guía',
    SUM(p.montoPropina) AS 'Total propinas',
    COUNT(p.idPropina) AS 'Cantidad propinas'
FROM Guías g
JOIN Perfiles pr ON g.idPerfilGuía = pr.idPerfilUsuario
JOIN Usuarios u ON pr.idPerfilUsuario = u.idUsuario
LEFT JOIN Propinas p ON g.idPerfilGuía = p.idGuía
GROUP BY g.idPerfilGuía, u.nombreUsuario, u.apellidoUsuario;

GO

------------------6. Promedio propias por tour--------------------
CREATE OR ALTER VIEW PromedioPropinasPorTour AS
WITH CTEPropinas AS (
    SELECT 
        p.idTour,
        p.montoPropina
    FROM Propinas p
)
SELECT
    t.idTour,
    t.nombreTour AS [Nombre Tour],
    CAST(AVG(c.montoPropina) AS DECIMAL(10,2)) AS [Promedio propinas],
    CAST(SUM(c.montoPropina) AS DECIMAL(10,2)) AS [Total propinas],
    COUNT(c.montoPropina) AS [Cantidad propinas]
FROM Tours t
LEFT JOIN CTEPropinas c ON t.idTour = c.idTour
GROUP BY t.idTour, t.nombreTour;

GO

---------------7. Fechas por cada tour--------------------------
CREATE OR ALTER VIEW ToursCantidadFechas AS
WITH Fechas AS (
    SELECT 
        fpt.idTour,
        COUNT(fpt.idFechaTour) AS totalFechas
    FROM FechasPorTour fpt
    GROUP BY fpt.idTour
)
SELECT
    t.idTour,
    t.nombreTour AS 'Nombre Tour',
    ISNULL(f.totalFechas, 0) AS 'Total fechas'
FROM Tours t
LEFT JOIN Fechas f ON t.idTour = f.idTour;

GO

------------------8. Guias con mas tours-----------------------
CREATE OR ALTER VIEW GuiasConMasTours AS
WITH ToursPorGuia AS (
    SELECT
        gpt.idGuía AS idGuia,
        COUNT(gpt.idTour) AS totalTours
    FROM GuíasPorTour gpt
    GROUP BY gpt.idGuía
)
SELECT
    g.idPerfilGuía AS idGuia,
    CONCAT(u.nombreUsuario, ' ', u.apellidoUsuario) AS 'Nombre guía',
    ISNULL(ct.totalTours, 0) AS 'Total tours'
FROM Guías g
JOIN Perfiles p ON g.idPerfilGuía = p.idPerfilUsuario
JOIN Usuarios u ON p.idPerfilUsuario = u.idUsuario
LEFT JOIN ToursPorGuia ct ON g.idPerfilGuía = ct.idGuia

GO

-----------------9. Cantidad de idiomas manejados por los guias-------------
CREATE OR ALTER VIEW CantidadIdiomasGuia AS
SELECT 
    g.idPerfilGuía AS idGuia,
    CONCAT(u.nombreUsuario, ' ', u.apellidoUsuario) AS 'Nombre guía',
    COUNT(ip.idIdioma) AS 'Cantidad de idiomas'
FROM Guías g
JOIN Perfiles p ON g.idPerfilGuía = p.idPerfilUsuario
JOIN Usuarios u ON p.idPerfilUsuario = u.idUsuario
LEFT JOIN IdiomasPorPerfil ip ON p.idPerfilUsuario = ip.idPerfil
GROUP BY g.idPerfilGuía, u.nombreUsuario, u.apellidoUsuario;

GO

----------10. Servicios mas ofrecidos por los prestadores de servicio-------
CREATE OR ALTER VIEW ServiciosMasOfrecidos AS
SELECT 
    s.idServicio,
    s.nombreServicio AS 'Nombre servicio',
    COUNT(spp.idPrestadorServicio) AS 'Cantidad de prestadores'
FROM Servicios s
LEFT JOIN ServiciosPorPrestador spp
    ON s.idServicio = spp.idServicio
GROUP BY s.idServicio, s.nombreServicio

GO

-----11. medios de pagos más usados para dar propinas -----
CREATE OR ALTER VIEW mediosDePagoMásUsados AS
SELECT 
	m.nombreMedioDePago AS 'Medio de pago',
	COUNT(*) AS 'Cantidad de propinas'
FROM MediosDePago m
JOIN Propinas p ON p.idMedioDePago = m.idMedioDePago
GROUP BY m.nombreMedioDePago

GO

------12. personas que sean guia y turista--------------
CREATE OR ALTER VIEW personasQueSonGuiasYTuristas AS
SELECT 
    u.idUsuario,
    CONCAT(u.nombreUsuario,' ',U.apellidoUsuario) AS 'Nombre completo',
    u.documentoUsuario
FROM Usuarios u
WHERE u.idUsuario IN (
    SELECT p1.idPerfilUsuario
	FROM Perfiles p1
	JOIN Guías g ON g.idPerfilGuía = p1.idPerfilUsuario

	INTERSECT

	SELECT p2.idPerfilUsuario
	FROM Perfiles p2
	JOIN Turistas t ON t.idPerfilTurista = p2.idPerfilUsuario
);

GO

--------13. los tours más largos en terminar -----------
CREATE OR ALTER VIEW toursMasLargos AS
SELECT TOP 3
    nombreTour AS 'Nombre Tour', 
    duraciónTour AS 'Duración Tour',
    DENSE_RANK() OVER(ORDER BY duraciónTour DESC) AS 'Posición'
FROM Tours;

GO

--------14. Datos de los usarios (EPS, # telefono y pais) ----
CREATE OR ALTER VIEW vistaUsuarios AS
SELECT
     u.nombreUsuario AS 'Nombre',  
     e.nombreEps AS 'EPS',
     tt.nombreTipoTeléfono AS 'Tipo Teléfono',
     t.númeroTeléfono AS 'Número Teléfono',
     p.nombrePaís AS 'País'
FROM Usuarios u
JOIN Eps e ON e.idEps = u.idEps
JOIN TeléfonosUsuarios tu ON tu.idUsuario = u.idUsuario
JOIN Teléfonos t ON t.idTeléfono = tu.idTeléfono
JOIN TiposTeléfonos tt ON tt.idTipoTeléfono = t.idTipoTeléfono
JOIN PaísesPorUsuarios pu ON pu.idUsuario = u.idUsuario
JOIN Países p ON p.idPaís = pu.idPaís;

GO

--------15. Los departamentos con más guías ----------
CREATE OR ALTER VIEW departamentosConMasGuias AS
SELECT 
	d.idDepartamento,
    d.nombreDepartamento AS 'Nombre Departamento',
    COUNT(g.idPerfilGuía) AS 'Cantidad de usuarios'
FROM Guías g 
LEFT JOIN Sitios s ON g.idSitioGuía = s.idSitio
LEFT JOIN Departamentos d ON s.idDepartamento = d.idDepartamento
GROUP BY d.nombreDepartamento, d.idDepartamento

GO

-------16. Los guías que tienen más de 3 temáticas preferidas ------
CREATE OR ALTER VIEW guiasVersátiles AS
SELECT 
	g.idPerfilGuía, 
    u.idUsuario, 
	CONCAT(u.nombreUsuario,' ', u.apellidoUsuario) AS 'Nombre Guía'
FROM Guías g
JOIN Perfiles p ON p.idPerfilUsuario = g.idPerfilGuía
JOIN Usuarios u ON u.idUsuario = p.idPerfilUsuario
WHERE (
        SELECT COUNT(*)
        FROM TemáticasPreferidasPorGuía tg1
        WHERE tg1.idGuía = g.idPerfilGuía
      ) > 3

GO

---------- 17. Puntos de interés con menos de 3 reseñas ----------.
CREATE OR ALTER VIEW PuntosPocoReseñados AS
SELECT 
     p.nombrePuntoDeInterés AS 'Nombre Punto',
    COUNT(r.idReseña) AS 'Cantidad de Reseñas'
FROM PuntosDeInterés p
JOIN ReseñasDelPuntoTurístico rp ON rp.idPuntoTurístico = p.idPuntoDeInterés
JOIN Reseñas r ON r.idPerfil = rp.idReseñaPunto
GROUP BY p.nombrePuntoDeInterés
HAVING COUNT(r.idReseña) < 3

GO

------- 18. Tours más antiguos ---------------
CREATE OR ALTER VIEW AntiguedadDeTours AS
SELECT
    t.idTour,
    t.nombreTour AS 'Nombre Tour',
    MIN(ft.fecha) AS 'Primera fecha del tour',
    ABS(DATEDIFF(DAY, MIN(ft.fecha), GETDATE())) AS 'Edad del tour en días'

FROM Tours t
JOIN FechasPorTour fpt ON t.idTour = fpt.idTour
JOIN FechasTour ft ON fpt.idFechaTour = ft.idFechaTour
GROUP BY t.idTour, t.nombreTour

GO

------- 19. Ranking de guías con más propinas ---------
CREATE OR ALTER VIEW RankingGuiasPorPropinas AS
SELECT 
    CONCAT(u.nombreUsuario, ' ', u.apellidoUsuario) AS 'Nombre guía',
    SUM(p.montoPropina) AS 'Propinas totales',
    DENSE_RANK() OVER(ORDER BY SUM(p.montoPropina) DESC) AS 'Posición'
FROM Guías g
JOIN Perfiles pr ON g.idPerfilGuía = pr.idPerfilUsuario
JOIN Usuarios u ON pr.idPerfilUsuario = u.idUsuario
JOIN Propinas p ON p.idGuía = g.idPerfilGuía
GROUP BY g.idPerfilGuía, u.nombreUsuario, u.apellidoUsuario;

GO

------- 20. Duración de tours promedio por región ---------
CREATE OR ALTER VIEW DuracionPromedioToursPorRegion AS
WITH Duraciones AS (
    SELECT 
        t.idTour,
        r.nombreRegión,
        DATEDIFF(MINUTE, s.horaInicioSesión, s.horaFinSesión) AS DuracionMinutos
    FROM Tours t
    JOIN FechasPorTour fpt ON t.idTour = fpt.idTour
    JOIN FechasTour ft ON fpt.idFechaTour = ft.idFechaTour
    JOIN SesionesTour s ON ft.idFechaTour = s.idFechaTour
    JOIN Sitios si ON t.idSitio = si.idSitio
    JOIN Departamentos d ON si.idDepartamento = d.idDepartamento
    JOIN Regiones r ON d.idRegión = r.idRegión
)
SELECT 
    nombreRegión AS 'Región',
    AVG(DuracionMinutos) AS 'Duración promedio (min)',
    MAX(DuracionMinutos) AS 'Duración máxima (min)',
    MIN(DuracionMinutos) AS 'Duración mínima (min)',
    COUNT(idTour) AS 'Cantidad de tours'
FROM Duraciones
GROUP BY nombreRegión;
