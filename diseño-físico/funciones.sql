USE PRUEBA_PROYECTO;
GO

--obtener la cantidad de propina de recibida por un guia historicamente para
--conocer que guias tienen un mejor manejo y habilidades en este negocio
CREATE FUNCTION Obtener_propina_por_gu�a (
	@idGu�a INT
)
RETURNS DECIMAL(15,2)
AS
BEGIN
	DECLARE @total DECIMAL(15,2);
	SELECT	@total = SUM(p.montoPropina)--AGRE
	FROM Propinas as p
	WHERE p.idGu�a = @idGu�a;

	RETURN @total;
END;
GO


--Obtener la humedad promedio de una region de colombia
CREATE FUNCTION Promedio_humedad_regi�n (@idRegi�n INT)
RETURNS DECIMAL(15,2)
AS
BEGIN
	DECLARE @total DECIMAL(15,2);
	SELECT @total = AVG(c.humedadPromedioClima)--AGREGACION
	FROM ClimasPorDepartamentos as cd
	JOIN Departamentos as d
		ON cd.idDepartamento = d.idDepartamento
	JOIN Climas as c
		ON c.idClima = cd.idClima
	JOIN Regiones as r
		ON r.idRegi�n = d.idRegi�n
	WHERE @idRegi�n = r.idRegi�n;

	RETURN @total;
END;
GO


--Obtenemos la cantidad de tours disponibles que tiene un guia en su catalogo
CREATE FUNCTION Cantidad_tours_principales_por_gu�a (@idGuia INT)
RETURNS INT
AS
BEGIN
	DECLARE @total INT;
	SELECT @total = COUNT(t.idTour)--AGREGACION
	FROM Tours as t
	where t.idGu�aPrincipalTour = @idGuia;

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
	WHERE LOWER(@sitio) = LOWER(s.nombreSitio);--FUNCION ESCALAR 
GO

		
--Corrobora si los servicios de un punto de interes especifico tiene un costo elevado o aceptable
CREATE FUNCTION Clasificaci�n_precio_Servicios_por_puntoInteres (@idPuntoInteres INT, @valorMinimo DECIMAL(15,2))
RETURNS TABLE
AS 
RETURN 
	SELECT pdi.nombrePuntoDeInter�s ,s.nombreServicio, s.costoServicio as CostoServicio, 
			CASE
				WHEN s.costoServicio > @valorMinimo THEN 'Costoso'
				ELSE 'Precio aceptable'--EXPRESION CONDICIONAL
				END as [clasificaci�n precio]
	FROM Servicios as s
	JOIN ServiciosPuntosDeInter�s as spi
		ON spi.idServicio = s.idServicio
	JOIN PuntosDeInter�s as pdi
		ON pdi.idPuntoDeInter�s = spi.idPuntoDeInter�s
	WHERE pdi.idPuntoDeInter�s = @idPuntoInteres;--FILTRADO DE FILAS
GO


--Ranking de los departamentos de una region en especifico
CREATE FUNCTION Ranking_departamentos_cantidad_tours_por_regi�n(@idRegion INT)
RETURNS TABLE
AS
RETURN 
	SELECT	d.nombreDepartamento,
			COUNT(t.idTour) as [cantidad de tours],--FUNCION DE AGREGACION 
			ROW_NUMBER() OVER( ORDER BY COUNT(t.idTour) DESC) as [ranking]--FUNCION VENTANA PARA RANKEAR
	FROM Tours as t
	JOIN Sitios as s
		ON s.idSitio = t.idSitio
	JOIN Departamentos as d
		ON d.idDepartamento = s.idDepartamento
	JOIN Regiones as r
		ON r.idRegi�n = d.idRegi�n
	WHERE r.idRegi�n = @idRegion
	GROUP BY d.idDepartamento , d.nombreDepartamento;--AGRUPACION
GO


--Promedio de calificaci�n de x gu�a
CREATE FUNCTION promedio_calificaci�n_gu�a (@idGu�a INT)
RETURNS DECIMAL(15,2)
AS 
BEGIN
	DECLARE @resultado DECIMAL(2,2);
	SELECT @resultado = AVG(vc.valorNum�rico)
	FROM Rese�asDelGu�a as rg
	JOIN Gu�as as g
		ON g.idPerfilGu�a = rg.idGu�aRese�ado
	JOIN Rese�as as r
		ON r.idRese�a = rg.idRese�aGu�a
	JOIN ValoresCalificaci�n as vc
		ON vc.idValorCalificaci�n = r.idValorCalificaci�n--AGREGACION
	WHERE rg.idGu�aRese�ado=@idGu�a;

	RETURN @resultado;
END;
GO


--Promedio de calificaci�n de x tour
CREATE FUNCTION promedio_calificaci�n_tour (@idTour INT)
RETURNS DECIMAL(15,2)
AS 
BEGIN
	DECLARE @resultado DECIMAL(2,2);
	SELECT @resultado = AVG(vc.valorNum�rico)
	FROM Rese�asDelTour as rt
	JOIN Tours as t
		ON t.idTour = rt.idTour
	JOIN Rese�as as r
		ON r.idRese�a = rt.idRese�aTour
	JOIN ValoresCalificaci�n as vc
		ON vc.idValorCalificaci�n = r.idValorCalificaci�n
	WHERE rt.idTour = @idTour;

	RETURN @resultado;--AGREGACION
END;
GO


--Obtener todos los tours asociados a un rango de edad en especifico 
CREATE FUNCTION Tours_por_rangoEdad(@idRangoEdad INT)
RETURNS TABLE
AS
RETURN 
	SELECT re.nombreRangoEdad, t.nombreTour
	FROM Tours as t
	JOIN Tem�ticasDelTour as tt
		ON tt.idTour = t.idTour
	JOIN Tem�ticas as te
		ON te.idTem�tica = tt.idTem�tica
	JOIN RangosEdades as re
		ON re.idRangoEdad = te.idRangoEdadRecomendada
	WHERE @idRangoEdad = re.idRangoEdad;
GO


--Obtener la temperatura promedio de una region de colombia
CREATE FUNCTION Promedio_temperatura_regi�n (@idRegi�n INT)
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
		ON r.idRegi�n = d.idRegi�n
	WHERE @idRegi�n = r.idRegi�n;

	RETURN @total;--USO DE FUNCIONES DE AGREGACION 
END;
GO

--Obtiene los tours por gu�as 
CREATE FUNCTION Tours_por_gu�a (@idGu�a INT)
RETURNS TABLE
AS 
RETURN 
	SELECT	t.idTour, gt.idGu�a, t.nombreTour as [nombre tour], u.nombreUsuario as [nombre gu�a]
	FROM Tours as t
	JOIN Gu�asPorTour as gt ON t.idTour=gt.idTour
	JOIN Gu�as as g
		ON g.idPerfilGu�a = gt.idGu�a
	JOIN Usuarios as u
		ON u.idUsuario = gt.idGu�a
	WHERE @idGu�a = g.idPerfilGu�a;---OBTENER NORMAL
GO



CREATE OR ALTER FUNCTION devolver_total_sesiones_anio_por_tour
(
    @anio INT, 
    @nombreTour VARCHAR(200)
)
RETURNS TABLE
AS
RETURN
(
    SELECT 
        ISNULL([January], 0)   AS Enero,
        ISNULL([February], 0)  AS Febrero,
        ISNULL([March], 0)     AS Marzo,
        ISNULL([April], 0)     AS Abril,
        ISNULL([May], 0)       AS Mayo,
        ISNULL([June], 0)      AS Junio,
        ISNULL([July], 0)      AS Julio,
        ISNULL([August], 0)    AS Agosto,
        ISNULL([September], 0) AS Septiembre,
        ISNULL([October], 0)   AS Octubre,
        ISNULL([November], 0)  AS Noviembre,
        ISNULL([December], 0)  AS Diciembre
    FROM
    (
        SELECT 
            DATENAME(MONTH, ft.fecha) AS Mes,
            st.idSesionTour
        FROM SesionesTour st
        JOIN FechasTour ft ON st.idFechaTour = ft.idFechaTour
        JOIN FechasPorTour fpt ON fpt.idFechaTour = ft.idFechaTour
        JOIN Tours t ON t.idTour = fpt.idTour
        WHERE YEAR(ft.fecha) = @anio
          AND t.nombreTour = @nombreTour
    ) AS Datos
    PIVOT
    (
        COUNT(idSesionTour)
        FOR Mes IN (
            [January], [February], [March], [April],
            [May], [June], [July], [August],
            [September], [October], [November], [December]
        )
    ) AS Resultado
);--- DEVUELVE TABLA USANDO PIVOTE. OPERADOR DE TRANSFORMACION DE DATOS

