USE Freetour;
GO

--obtener la cantidad de propina de recibida por un guia historicamente para
--conocer que guias tienen un mejor manejo y habilidades en este negocio
CREATE FUNCTION Obtener_propina_por_guía (
	@idGuía INT
)
RETURNS DECIMAL(15,2)
AS
BEGIN
	DECLARE @total DECIMAL(15,2);
	SELECT	@total = SUM(p.montoPropina)
	FROM Propinas as p
	WHERE p.idGuía = @idGuía;

	RETURN @total;
END;
GO


--Obtener la humedad promedio de una region de colombia
CREATE FUNCTION Promedio_humedad_región (@idRegión INT)
RETURNS DECIMAL(15,2)
AS
BEGIN
	DECLARE @total DECIMAL(15,2);
	SELECT @total = AVG(c.humedadPromedioClima)
	FROM ClimasPorDepartamentos as cd
	JOIN Departamentos as d
		ON cd.idDepartamento = d.idDepartamento
	JOIN Climas as c
		ON c.idClima = cd.idClima
	JOIN Regiones as r
		ON r.idRegión = d.idRegión
	WHERE @idRegión = r.idRegión;

	RETURN @total;
END;
GO


--Obtenemos la cantidad de tours disponibles que tiene un guia en su catalogo
CREATE FUNCTION Cantidad_tours_disponibles_por_guía (@idGuia INT)
RETURNS INT
AS
BEGIN
	DECLARE @total INT;
	SELECT @total = COUNT(t.idTour)
	FROM Tours as t
	JOIN EstadosDelTour as et
		ON et.idTour = t.idTour
	JOIN Estados as e
		ON e.idEstado = et.idEstado
	WHERE e.nombreEstado = 'Disponible' AND t.idGuíaTour = @idGuia;

	RETURN @total;
END;
GO


--Retorna todos los tours que se realizan en algun sitio en especifico 
CREATE FUNCTION Tours_sitio (@sitio Varchar(100))
RETURNS TABLE
AS
RETURN
	SELECT s.nombreSitio, t.nombreTour, t.maxParticipantesTour 
	FROM Tours as t
	JOIN Sitios as s
		ON s.idSitio = t.idSitio
	WHERE LOWER(@sitio) = LOWER(s.nombreSitio);
GO

		
--Corrobora si los servicios de un punto de interes especifico tiene un costo elevado o aceptable
CREATE FUNCTION Clasificación_precio_Servicios_por_puntoInteres (@idPuntoInteres INT, @valorMinimo DECIMAL(15,2))
RETURNS TABLE
AS 
RETURN 
	SELECT pdi.nombrePuntoDeInterés ,s.nombreServicio, 
			CASE
				WHEN s.costoServicio > @valorMinimo THEN 'Costoso'
				ELSE 'Precio aceptable'
				END as [clasificación precio]
	FROM Servicios as s
	JOIN ServiciosPuntosDeInterés as spi
		ON spi.idServicio = s.idServicio
	JOIN PuntosDeInterés as pdi
		ON pdi.idPuntoDeInterés = spi.idPuntoDeInterés
	WHERE pdi.idPuntoDeInterés = @idPuntoInteres;
GO


--Ranking de los departamentos de una region en especifico
CREATE FUNCTION Ranking_departamentos_cantidad_tours_por_región(@idRegion INT)
RETURNS TABLE
AS
RETURN 
	SELECT	d.nombreDepartamento,
			COUNT(t.idTour) as [cantidad de tours],
			ROW_NUMBER() OVER(ORDER BY COUNT(t.idTour) DESC) as [ranking]
	FROM Tours as t
	JOIN Sitios as s
		ON s.idSitio = t.idSitio
	JOIN Departamentos as d
		ON d.idDepartamento = s.idDepartamento
	JOIN Regiones as r
		ON r.idRegión = d.idRegión
	WHERE r.idRegión = @idRegion
	GROUP BY d.nombreDepartamento,d.idDepartamento;
GO

--Promedio de calificación de x guía
CREATE FUNCTION promedio_calificación_guía (@idGuía INT)
RETURNS DECIMAL(15,2)
AS 
BEGIN
	DECLARE @resultado DECIMAL(2,2);
	SELECT @resultado = AVG(vc.valorNumérico)
	FROM ReseñasDelGuía as rg
	JOIN Guías as g
		ON g.idPerfilGuía = rg.idGuiaReseñado
	JOIN Reseñas as r
		ON r.idReseña = rg.idReseñaGuía
	JOIN ValoresCalificación as vc
		ON vc.idValorCalificación = r.idValorCalificación
	WHERE rg.idGuiaReseñado=@idGuía;

	RETURN @resultado;
END;
GO


--Promedio de calificación de x tour
CREATE FUNCTION promedio_calificación_tour (@idTour INT)
RETURNS DECIMAL(15,2)
AS 
BEGIN
	DECLARE @resultado DECIMAL(2,2);
	SELECT @resultado = AVG(vc.valorNumérico)
	FROM ReseñasDelTour as rt
	JOIN Tours as t
		ON t.idTour = rt.idTour
	JOIN Reseñas as r
		ON r.idReseña = rt.idReseñaTour
	JOIN ValoresCalificación as vc
		ON vc.idValorCalificación = r.idValorCalificación
	WHERE rt.idTour = @idTour;

	RETURN @resultado;
END;
GO


--Obtener todos los tours asociados a un rango de edad en especifico 
CREATE FUNCTION Tours_por_rangoEdad(@idRangoEdad INT)
RETURNS TABLE
AS
RETURN 
	SELECT re.nombreRangoEdad, t.nombreTour
	FROM Tours as t
	JOIN TemáticasDelTour as tt
		ON tt.idTour = t.idTour
	JOIN Temáticas as te
		ON te.idTemática = tt.idTemática
	JOIN RangosEdades as re
		ON re.idRangoEdad = te.idRangoEdadRecomendada
	WHERE @idRangoEdad = re.idRangoEdad;
GO


--Obtener la temperatura promedio de una region de colombia
CREATE FUNCTION Promedio_temperatura_región (@idRegión INT)
RETURNS DECIMAL(15,2)
AS
BEGIN
	DECLARE @total DECIMAL(15,2);
	SELECT @total = AVG(c.temperaturaPromedioClima)
	FROM ClimasPorDepartamentos as cd
	JOIN Departamentos as d
		ON cd.idDepartamento = d.idDepartamento
	JOIN Climas as c
		ON c.idClima = cd.idClima
	JOIN Regiones as r
		ON r.idRegión = d.idRegión
	WHERE @idRegión = r.idRegión;

	RETURN @total;
END;
GO

--Obtiene los tours por guías 
CREATE FUNCTION Tours_por_guía (@idGuía INT)
RETURNS TABLE
AS 
RETURN 
	SELECT	t.idTour, t.idGuíaTour, t.nombreTour as [nombre tour], u.nombreUsuario as [nombre guía]
	FROM Tours as t
	JOIN Guías as g
		ON g.idPerfilGuía = t.idGuíaTour
	JOIN Perfiles as p
		ON p.idPerfilUsuario = g.idPerfilGuía
	JOIN Usuarios as u
		ON u.idUsuario = p.idPerfilUsuario
	WHERE @idGuía = g.idPerfilGuía;
GO
