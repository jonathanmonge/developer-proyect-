USE [SysLibreria]
GO
/****** Object:  StoredProcedure [dbo].[ReporteVenta]    Script Date: 13/03/2021 09:23:42 p. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE ReporteVentasXFechas
	-- Add the parameters for the stored procedure here
	@FechaI date,@FechaF date

AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	SELECT v.VentaId AS VentaID, v.Fecha, p.NombreProducto AS ProductoVendido, dv.Cantidad, dv.Total
FROM DetalleVenta AS dv INNER JOIN Producto AS p 
ON dv.ProductoId = p.ProductoId INNER JOIN Venta AS v
ON dv.VentaId = v.VentaId where v.Fecha BETWEEN @FechaI AND @FechaF
END
GO
