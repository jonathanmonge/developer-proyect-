USE master
GO
DROP DATABASE SysLibreria
GO
CREATE DATABASE SysLibreria
GO
USE SysLibreria
GO
CREATE TABLE Categoria(
CategoriaId INT NOT NULL PRIMARY KEY IDENTITY,
NombreCategoria VARCHAR(60),
EstadoCategoria VARCHAR(10)
);
GO
CREATE TABLE Proveedor(
ProveedorId INT NOT NULL PRIMARY KEY IDENTITY,
NombreProveedor VARCHAR(60),
DireccionProveedor VARCHAR(200),
TelefonoProveedor VARCHAR(9),
CorreoProveedor VARCHAR(90),
EstadoProveedor VARCHAR(50)
);
GO
CREATE TABLE Producto(
ProductoId INT NOT NULL PRIMARY KEY IDENTITY,
NombreProducto VARCHAR(100),
DescripcionProducto VARCHAR(200),
PrecioCompra DECIMAL(10,2),
Margen DECIMAL(10,2),
PrecioVenta DECIMAL(10,2),
Stock INT,
ImagenProducto IMAGE,
EstadoProducto VARCHAR(50),
CategoriaId INT NOT NULL FOREIGN KEY REFERENCES Categoria(CategoriaId),
ProveedorId INT NOT NULL FOREIGN KEY REFERENCES Proveedor(ProveedorId)
);
GO
CREATE TABLE Compra(
CompraId INT NOT NULL PRIMARY KEY IDENTITY,
Fecha DATE,
Estado INT,
ProveedorId INT NOT NULL FOREIGN KEY REFERENCES Proveedor(ProveedorId)
);
GO
CREATE TABLE DetalleCompra(
DetalleCompraId INT NOT NULL PRIMARY KEY IDENTITY,
Cantidad INT NOT NULL,
TotalEstimado DECIMAL(10,2),
ProductoId INT NOT NULL FOREIGN KEY REFERENCES Producto(ProductoId),
CompraId INT NOT NULL FOREIGN KEY REFERENCES Compra(CompraId)
);
GO
CREATE TABLE Venta(
VentaId INT NOT NULL PRIMARY KEY IDENTITY,
Fecha DATE
);
GO
CREATE TABLE DetalleVenta(
DetalleVentaId INT NOT NULL PRIMARY KEY IDENTITY,
Cantidad INT,
Total DECIMAL(10,2),
TipoDocumento VARCHAR(50),
ProductoId INT FOREIGN KEY REFERENCES Producto(ProductoId),
VentaId INT FOREIGN KEY REFERENCES Venta(VentaId)
);
GO
CREATE TABLE Usser(
UserId INT NOT NULL PRIMARY KEY IDENTITY,
Nombre VARCHAR(50) NOT NULL,
Apellido VARCHAR(50) NOT NULL,
Dui VARCHAR(10) NOT NULL,
Direccion VARCHAR(200) NOT NULL,
Telefono VARCHAR(9) NOT NULL,
NombreUser VARCHAR(50) unique NOT NULL,
Pass VARBINARY(100) NOT NULL,
Acceso VARCHAR(1) NOT NULL,
Correo VARCHAR(90) NOT NULL
)
GO
-- INSERTANDO USUARIOS DEL SISTEMA, 1 ADMIN, 2 VENDEDORES
INSERT INTO Usser VALUES('Eli', 'Monge', '2222', 'casa', '32323', 'Admin', CONVERT(VARBINARY, '123456789'), '1','Jmonge465@gmail.com')
INSERT INTO Usser VALUES('Marvin', 'Recinos', '2222', 'casa', '32323', 'Vendedor1', CONVERT(VARBINARY, '77777'), '2','marvinrecinos99@gmail.com')
INSERT INTO Usser VALUES('Josue', 'Duran', '2222', 'casa', '32323', 'Vendedor2', CONVERT(VARBINARY, '999'), '2','josue2duran@hotmail.com')
GO

-- SP VER LISTA DE USUARIOS
CREATE PROCEDURE ver_Usuarios
AS
SELECT Nombre, Apellido, Telefono, Dui, Direccion, NombreUser, REPLACE (REPLACE(Acceso, '1', 'Administrador'), '2', 'Vendedor') AS Rol, Correo  FROM Usser 
GO
-- SP CATEGORIAS
CREATE PROCEDURE mostrar_categoria
AS
SELECT CategoriaID AS ID, NombreCategoria AS Nombre, EstadoCategoria FROM Categoria
GO
CREATE PROCEDURE insertar_Categoria
@nombrecateg VARCHAR(60)
AS
INSERT INTO Categoria (NombreCategoria, EstadoCategoria) VALUES (@nombrecateg, 'Activa')
GO
CREATE PROCEDURE editar_Categoria
@id INT,
@nombrecateg VARCHAR(60)
AS
UPDATE categoria SET NombreCategoria = @nombrecateg 
WHERE CategoriaId = @id 
GO
CREATE PROCEDURE desactivar_Categoria
@id INT
AS
UPDATE Categoria SET EstadoCategoria =  'Inactiva' WHERE CategoriaId = @id
GO
CREATE PROCEDURE activar_Categoria
@id INT
AS
UPDATE Categoria SET EstadoCategoria =  'Activa' WHERE CategoriaId = @id
GO
-- SP PROVEEDORES
CREATE PROCEDURE mostrar_Proveedor
AS
SELECT ProveedorId As ID, NombreProveedor AS Nombre, DireccionProveedor AS Direccion, TelefonoProveedor AS Telefono, CorreoProveedor AS CorreoElectronico, EstadoProveedor AS Estado FROM Proveedor
GO
CREATE PROCEDURE insertar_Proveedor
@Nombre VARCHAR(60),
@direccion VARCHAR(200),
@telefono VARCHAR(9),
@correo VARCHAR(90)
AS
INSERT INTO Proveedor(NombreProveedor, DireccionProveedor, TelefonoProveedor, CorreoProveedor, EstadoProveedor)
VALUES (@nombre, @direccion, @telefono, @correo, 'Activo')
GO
CREATE PROCEDURE editar_Proveedor
@id INT,
@nombre VARCHAR(50),
@direccion VARCHAR(200),
@telefono VARCHAR(9),
@correo VARCHAR(90)
AS
UPDATE Proveedor SET NombreProveedor = @nombre, DireccionProveedor = @direccion, TelefonoProveedor = @telefono, CorreoProveedor = @correo 
WHERE ProveedorId = @id 
GO
CREATE PROCEDURE desactivar_Proveedor
@id INT
AS
UPDATE Proveedor SET EstadoProveedor = 'Inactivo' 
WHERE ProveedorId = @id
GO
CREATE PROCEDURE activar_Proveedor
@id INT
AS
UPDATE Proveedor SET EstadoProveedor = 'Activo' 
WHERE ProveedorId = @id
GO
-- SP PRODUCTOS
CREATE PROCEDURE mostrar_ProductoIMG
AS
SELECT p.ProductoId AS ID, p.EstadoProducto AS Estado, p.Stock AS Existencias, p.NombreProducto, p.DescripcionProducto AS Descripcion, p.PrecioCompra, p.PrecioVenta, p.Margen, c.NombreCategoria As Categoria, pr.NombreProveedor As Proveedor, CONVERT(VARBINARY(MAX),p.imagenProducto) AS Imagen
FROM Categoria AS c INNER JOIN Producto AS p 
ON c.CategoriaId = p.CategoriaId INNER JOIN Proveedor As pr 
ON p.ProveedorId = pr.ProveedorId
GROUP BY p.ProductoId, p.EstadoProducto, p.Stock, p.NombreProducto, p.DescripcionProducto, p.PrecioCompra, p.PrecioVenta, p.Margen, c.NombreCategoria, pr.NombreProveedor, CONVERT(VARBINARY(MAX),p.imagenProducto)
GO
CREATE PROCEDURE insertar_Producto
@nombre VARCHAR(100),
@descripcion VARCHAR(200),
@precioCompra DECIMAL(10,2),
@margen DECIMAL(10,2),
@precioVenta DECIMAL(10,2),
@stock INT,
@imagen IMAGE,
@categoriaid INT,
@proveedorid INT
AS
INSERT INTO Producto (NombreProducto, DescripcionProducto, PrecioCompra, Margen, PrecioVenta, Stock, ImagenProducto, EstadoProducto, CategoriaId, ProveedorId)
VALUES (@nombre, @descripcion, @precioCompra, @margen, @precioVenta, @stock, @imagen, 'Activo', @CategoriaId, @ProveedorId)
GO
CREATE PROCEDURE insertar_ProductoSinIMG
@nombre VARCHAR(100),
@descripcion VARCHAR(200),
@precioCompra DECIMAL(10,2),
@margen DECIMAL(10,2),
@precioVenta DECIMAL(10,2),
@stock INT,
@categoriaid INT,
@proveedorid INT
AS
INSERT INTO Producto (NombreProducto, DescripcionProducto, PrecioCompra, Margen, PrecioVenta, Stock, EstadoProducto, CategoriaId, ProveedorId)
VALUES (@nombre, @descripcion, @precioCompra, @margen, @precioVenta, @stock, 'Activo', @CategoriaId, @ProveedorId)
GO
CREATE PROCEDURE editar_Producto
@productoid INT,
@nombre VARCHAR(100),
@descripcion VARCHAR(200),
@precioCompra DECIMAL(10,2),
@margen DECIMAL(10,2),
@precioVenta DECIMAL(10,2),
@stock INT,
@imagen IMAGE,
@categoriaid INT,
@proveedorid INT
AS
UPDATE Producto SET NombreProducto = @nombre, DescripcionProducto = @descripcion, PrecioCompra = @precioCompra, margen=@margen, PrecioVenta = @precioVenta, Stock = @stock, ImagenProducto = @imagen, CategoriaId = @categoriaid, proveedorid=@proveedorid
WHERE ProductoId=@productoid
GO
CREATE PROCEDURE activar_Producto
@productoId INT
AS
UPDATE Producto SET EstadoProducto = 'Activo'
WHERE ProductoId = @productoId
GO
CREATE PROCEDURE desactivar_Producto
@productoId INT
AS
UPDATE Producto SET EstadoProducto = 'Inactivo'
WHERE ProductoId = @productoId
GO
-- SP COMPRA
CREATE PROCEDURE mostrar_OrdComp
AS
SELECT c.CompraId AS ID, c.Fecha, REPLACE(REPLACE(REPLACE(c.Estado, 3, 'Cancelado'),  2, 'Recibido'), 1, 'En espera...') AS EstadoPedido, p.NombreProveedor AS Proveedor 
FROM Compra AS c INNER JOIN Proveedor AS p
ON c.ProveedorId = p.ProveedorId ORDER BY c.CompraId DESC
GO
CREATE PROCEDURE mostrar_OrdCompEstado1
AS
SELECT oc.CompraId AS ID, oc.Fecha, REPLACE(oc.Estado, 1, 'En espera...') AS EstadoPedido, p.NombreProveedor AS Proveedor 
FROM Compra AS oc INNER JOIN Proveedor AS p
ON oc.ProveedorId = p.ProveedorId
WHERE oc.Estado = 1 ORDER BY oc.CompraId DESC 
GO
CREATE PROCEDURE insertar_OrdComp
@proveedorid INT
AS 
INSERT INTO Compra (fecha,Estado,ProveedorId)
VALUES (GETDATE(), 1, @ProveedorId)
GO
CREATE PROCEDURE editarOrdEst2
@ordenid INT
AS
UPDATE Compra SET fecha=GETDATE(), Estado=2
WHERE CompraId = @ordenid
GO
CREATE PROCEDURE editarOrdEst3
@ordenid INT
AS
UPDATE Compra SET fecha=GETDATE(), Estado=3
WHERE CompraId = @ordenid
GO 

-- SP DETALLES COMPRAS
CREATE PROCEDURE mostrarDetalleCompra
AS
SELECT c.CompraId AS ID, c.Fecha, REPLACE(REPLACE(REPLACE(c.Estado, 3, 'Cancelado'),  2, 'Recibido'), 1, 'En espera...') AS EstadoPedido, p.NombreProducto AS Producto, dc.Cantidad, dc.TotalEstimado, pr.NombreProveedor AS Proveedor 
FROM DetalleCompra AS dc INNER JOIN Compra AS c 
ON dc.CompraId = c.CompraId 
INNER JOIN Proveedor AS pr
ON c.ProveedorId = pr.ProveedorId 
INNER JOIN Producto AS p
ON dc.ProductoId = p.ProductoId ORDER BY c.CompraId DESC
GO

CREATE PROCEDURE mostrarDetalleCompra2
AS
SELECT c.CompraId AS ID, c.Fecha, REPLACE(REPLACE(REPLACE(c.Estado, 3, 'Cancelado'),  2, 'Recibido'), 1, 'En espera...') AS EstadoPedido, p.NombreProveedor AS Proveedor 
FROM Compra AS c INNER JOIN Proveedor AS p
ON c.ProveedorId = p.ProveedorId ORDER BY c.CompraId DESC
GO

CREATE PROCEDURE mostrarDetalleCompraSeleccionado
@id INT
AS
SELECT c.Fecha, p.NombreProducto AS Producto, dc.Cantidad, dc.TotalEstimado AS Total, pr.NombreProveedor AS Proveedor 
FROM DetalleCompra AS dc INNER JOIN Compra AS c 
ON dc.CompraId = c.CompraId 
INNER JOIN Proveedor AS pr
ON c.ProveedorId = pr.ProveedorId 
INNER JOIN Producto AS p
ON dc.ProductoId = p.ProductoId 
WHERE c.CompraId = @id
GO
CREATE PROCEDURE mostrarDetalleCompraRecien
@id INT
AS
SELECT c.CompraId AS ID, dc.DetalleCompraId AS ID, c.Fecha, p.ProductoId AS IDProducto, p.NombreProducto AS Producto, dc.Cantidad, p.PrecioCompra AS PrecioUnitario, dc.TotalEstimado
FROM DetalleCompra AS dc INNER JOIN Compra AS c 
ON dc.CompraId = c.CompraId 
INNER JOIN Producto AS p
ON dc.ProductoId = p.ProductoId
WHERE c.CompraId = @id
GO
CREATE PROCEDURE editarCantidadDetalleCompraRecien
@id INT,
@cantidad INT,
@precio DECIMAL(10,2)
AS
UPDATE DetalleCompra 
SET Cantidad = @Cantidad, TotalEstimado = @precio
WHERE  DetalleCompraId = @id
GO

CREATE PROCEDURE insertar_DetalleOrdComp
@ordencompraid INT,
@productoid INT,
@cantidad INT,
@precio DECIMAL(10,2)
AS 
INSERT INTO DetalleCompra (Cantidad, TotalEstimado, ProductoId, CompraId)
VALUES (@Cantidad, @precio, @ProductoId, @OrdenCompraId)
GO

CREATE PROCEDURE editar_DetalleOrdComp
@detallecompra INT,
@ordencompraid INT,
@productoid INT,
@cantidad INT,
@precio DECIMAL(10,2)

AS UPDATE DetalleCompra 
SET Cantidad = @cantidad, TotalEstimado = @precio, CompraId=@ordencompraid, ProductoId = @productoid 
WHERE DetalleCompraId = @detallecompra 
GO

CREATE PROCEDURE eliminar_detallecompra
@detalle_compraid INT
AS
DELETE FROM DetalleCompra WHERE DetalleCompraId=@detalle_compraid 
GO

------------------------ TABLA VENTA -------------------------
CREATE PROCEDURE insertar_Venta
AS
INSERT INTO Venta VALUES (GETDATE())
GO
CREATE PROCEDURE mostrar_Venta
AS
SELECT VentaId AS CodigoVenta, Fecha FROM Venta
GO
CREATE PROCEDURE eliminar_Venta 
@id INT
AS
DELETE FROM Venta WHERE VentaId = @id
GO
------------------------ TABLA DETALLEVENTA -------------------------
CREATE PROCEDURE ReporteVenta
AS
SELECT v.VentaId AS VentaID, v.Fecha, p.NombreProducto AS ProductoVendido, dv.Cantidad, dv.Total
FROM DetalleVenta AS dv INNER JOIN Producto AS p 
ON dv.ProductoId = p.ProductoId INNER JOIN Venta AS v
ON dv.VentaId = v.VentaId
GO
CREATE PROCEDURE mostrar_detalleventa
AS
SELECT dv.DetalleVentaId AS ID, v.VentaId AS VentaID, v.Fecha, p.NombreProducto AS Producto, dv.Cantidad, dv.Total
FROM DetalleVenta AS dv INNER JOIN Producto AS p 
ON dv.ProductoId = p.ProductoId INNER JOIN Venta AS v
ON dv.VentaId = v.VentaId
GO

CREATE PROCEDURE mostrar_detalleventaRecien
@idVenta int
AS
SELECT dv.DetalleVentaId, v.VentaId, p.ProductoId, p.NombreProducto, p.PrecioVenta AS PrecioUnidad, dv.Cantidad, dv.Total
FROM DetalleVenta AS dv INNER JOIN Producto AS p 
ON dv.ProductoId = p.ProductoId INNER JOIN Venta AS v
ON dv.VentaId = v.VentaId
WHERE v.VentaId = @idVenta
GO
CREATE PROCEDURE insertar_DetalleVentaSinDoc
@cantidad INT,
@precio_venta DECIMAL(10,2),
@productoid INT,
@ventaid INT
AS
INSERT INTO DetalleVenta (Cantidad,Total, ProductoId, VentaId) 
VALUES (@cantidad,@precio_venta, @productoid,@ventaid) 
GO
CREATE PROCEDURE masVendido
AS
SELECT TOP 3 dv.ProductoId AS CodigoProducto, p.NombreProducto, Count(dv.ProductoId) AS CantidadVendida 
FROM DetalleVenta AS dv INNER JOIN
Producto AS p ON dv.ProductoId = p.ProductoId
GROUP BY dv.ProductoId, p.NombreProducto ORDER BY CantidadVendida DESC
GO
CREATE PROCEDURE modificar_DetalleVenta
@detalle_ventaid INT,
@cantidad INT,
@precio_venta DECIMAL(10,2),
@productoid INT,
@ventaid INT
AS
UPDATE DetalleVenta 
SET Cantidad=@cantidad,Total = @precio_venta, ProductoId =@productoid,VentaId=@ventaid 
WHERE DetalleVentaId =@detalle_ventaid 
GO
CREATE PROCEDURE editarCantidadDetalleVentaRecien
@id INT,
@cantidad INT,
@precio DECIMAL(10,2)
AS
UPDATE DetalleVenta
SET Cantidad = @Cantidad, Total = @precio
WHERE  DetalleVentaId = @id
GO
CREATE PROCEDURE eliminar_detalleventa
@detalle_ventaid INT
AS
DELETE FROM DetalleVenta WHERE DetalleVentaId=@detalle_ventaid 
GO
-- TRIGGERS
CREATE TRIGGER DisminuirInventario 
ON DetalleVenta
AFTER INSERT
AS 
BEGIN
Declare 
@Cantidad int, 
@ProductoId int, 
@existencias INT,
@estadoProducto VARCHAR(10),
@id INT;

Select @id = i.DetalleVentaId FROM inserted i;
Select @Cantidad = i.Cantidad from inserted i;
Select @ProductoId = i.ProductoId from inserted i;
Select @existencias = p.Stock From Producto AS p WHERE @ProductoId = p.ProductoId 
SELECT @estadoProducto = p.EstadoProducto FROM Producto AS p WHERE @ProductoId = p.ProductoId

IF (@existencias > 0 AND @Cantidad <= @existencias)
begin
IF @estadoProducto = 'Activo'
begin 
Update Producto 
set Stock = Stock-@Cantidad
where ProductoId = @ProductoId
end 
ELSE IF @estadoProducto = 'Inactivo'
begin
RAISERROR('Este producto no se encuentra disponible', 16, 1)
DELETE FROM DetalleVenta WHERE DetalleVentaId = @id AND ProductoId = @ProductoId 
end 
end 
ELSE IF (@Cantidad > @existencias) 
begin 
IF @estadoProducto = 'Inactivo'
begin
RAISERROR('Este producto no se encuentra disponible', 16, 1)
DELETE FROM DetalleVenta WHERE DetalleVentaId = @id AND ProductoId = @ProductoId 
end
ELSE
begin
RAISERROR('Existencias insuficientes para realizar la venta', 16, 1)
DELETE FROM DetalleVenta WHERE DetalleVentaId = @id AND ProductoId = @ProductoId 
end
end
ELSE
Begin
IF @estadoProducto = 'Inactivo'
begin
RAISERROR('Este producto no se encuentra disponible', 16, 1)
DELETE FROM DetalleVenta WHERE DetalleVentaId = @id AND ProductoId = @ProductoId 
end
ELSE
begin
RAISERROR('No hay existencias de este producto', 16, 1)
DELETE FROM DetalleVenta WHERE DetalleVentaId = @id AND ProductoId = @ProductoId 
end
end
END
GO

CREATE TRIGGER RecibirCompra
ON Compra
AFTER UPDATE
AS
BEGIN
DECLARE @estado INT;

SELECT @estado = c.Estado FROM inserted c
IF (@estado = 2)
begin
UPDATE Producto 
SET Stock = Stock + (i.Cantidad)
FROM Producto AS p 
INNER JOIN DetalleCompra AS i
ON p.ProductoId = i.ProductoId
INNER JOIN  inserted AS c
ON c.CompraId = i.CompraId 
end
END
GO

CREATE TRIGGER RegresarStock
ON DetalleVenta
AFTER DELETE
AS
BEGIN
DECLARE @estado VARCHAR(10);
IF @estado = 'Activo'
begin
UPDATE Producto
SET Stock = Stock + (dv.Cantidad)
FROM Producto AS p
INNER JOIN deleted AS dv
ON p.ProductoId = dv.ProductoId
end
END
GO

CREATE TRIGGER desactivarCategoria
ON Categoria
AFTER UPDATE
AS
BEGIN
DECLARE @estado VARCHAR(10),
@estadoProv VARCHAR(10);

SELECT @estadoProv = pv.EstadoProveedor 
FROM Proveedor AS pv INNER JOIN Producto AS p 
ON p.ProveedorId = pv.ProveedorId 
INNER JOIN inserted AS c 
ON c.CategoriaId = p.CategoriaId 

SELECT @estado = c.EstadoCategoria FROM inserted AS c

IF @estado = 'Inactiva'
begin
UPDATE Producto 
SET EstadoProducto = 'Inactivo'
FROM Producto AS p
INNER JOIN inserted AS c
ON c.CategoriaId = p.CategoriaId 
end 
ELSE IF @estado = 'Activa'
begin 
If @estadoProv = 'Inactivo'
begin   
UPDATE Producto 
SET EstadoProducto = 'Inactivo'
FROM Producto AS p
INNER JOIN inserted AS c
ON c.CategoriaId = p.CategoriaId
end
ELSE IF @estadoProv = 'Activo'
begin 
UPDATE Producto 
SET EstadoProducto = 'Activo'
FROM Producto AS p
INNER JOIN inserted AS c
ON c.CategoriaId = p.CategoriaId
end
end

END 
GO

CREATE TRIGGER desactivarProveedor
ON Proveedor
AFTER UPDATE
AS 
BEGIN
DECLARE @estado VARCHAR(10);
SELECT @estado = c.EstadoProveedor FROM inserted AS c
IF @estado = 'Inactivo'
begin
UPDATE Producto 
SET EstadoProducto = 'Inactivo'
FROM Producto AS p
INNER JOIN inserted AS c
ON c.ProveedorId = p.ProveedorId 
end
ELSE IF @estado = 'Activo'
begin
UPDATE Producto 
SET EstadoProducto = 'Activo'
FROM Producto AS p
INNER JOIN inserted AS c
ON c.ProveedorId = p.ProveedorId
end
END
GO
--SELECT TOP 1 VentaId FROM Venta ORDER BY VentaId DESC

-- INSERCION DE DATOS PARA PROBAR VENTA
--EXEC insertar_Categoria 'Papeleria';
--EXEC insertar_Categoria 'Lectura';
--EXEC insertar_Categoria 'Utiles Escolares';
--SELECT * FROM Categoria

--EXEC insertar_Proveedor 'Carlos', 'Casa', '2301-2301', 'correo@gmail.com'; 
--EXEC insertar_Proveedor 'Pedro', 'Casa', '2301-2301', 'correo@gmail.com';
--EXEC insertar_Proveedor 'Juan', 'Casa', '2301-2301', 'correo@gmail.com';
--SELECT * FROM Proveedor 

--EXEC insertar_ProductoSinIMG 'El minimun vitaum', 'novela filosofica', 2.00, 0.50, 2.50, 64, 2, 1
--EXEC insertar_ProductoSinIMG 'El Dinero Maldito', 'novela filosofica', 2.00, 0.50, 2.50, 100, 1, 2
--EXEC insertar_ProductoSinIMG 'Lapiz 6B', 'Lapiz de dibujo', 1.00, 0.25, 1.25, 120, 1, 2
--EXEC insertar_ProductoSinIMG 'Popol Vuh', 'Obra Literaria', 2.00, 0.50, 2.50, 24, 1, 2
--EXEC insertar_ProductoSinIMG 'Cuaderno SCRIBE', 'Cuaderno rayado', 2.00, 0.50, 2.50, 32, 1, 2
--EXEC insertar_ProductoSinIMG 'Cuaderno SCRIBE', 'Cuaderno rayado', 2.00, 0.50, 2.50, 0, 1, 2
--SELECT * FROM Producto

--EXEC insertar_Venta 
--SELECT * FROM Venta 

--EXEC insertar_DetalleVentaSinDoc 1, 10.00, 2, 1
--EXEC insertar_DetalleVentaSinDoc 1, 10.00, 6, 1
--SELECT * FROM DetalleVenta 

--EXEC insertar_DetalleVentaSinDoc 10, 10.00, 2, 29
--EXEC insertar_DetalleVentaSinDoc 301, 10.00, 7, 29
--SELECT * FROM DetalleVenta 

--EXEC insertar_OrdComp 2
--SELECT * FROM Compra 

--EXEC insertar_DetalleOrdComp 2, 2, 20, 2.00
--EXEC insertar_DetalleOrdComp 2, 1, 20, 2.00
--EXEC insertar_DetalleOrdComp 2, 3, 10, 1.00
--EXEC insertar_DetalleOrdComp 2, 3, 10, 2.00

--EXEC insertar_DetalleOrdComp 3, 2, 20, 2.00
--EXEC insertar_DetalleOrdComp 3, 1, 20, 2.00
--EXEC insertar_DetalleOrdComp 3, 3, 10, 1.00
--EXEC insertar_DetalleOrdComp 3, 3, 10, 2.00

--EXEC insertar_DetalleOrdComp 4, 2, 20, 2.00
--EXEC insertar_DetalleOrdComp 4, 1, 20, 2.00
--EXEC insertar_DetalleOrdComp 5, 3, 10, 1.00
--EXEC insertar_DetalleOrdComp 5, 3, 10, 2.00

--EXEC insertar_DetalleOrdComp 6, 2, 20, 2.00
--EXEC insertar_DetalleOrdComp 6, 1, 20, 2.00
--EXEC insertar_DetalleOrdComp 7, 3, 10, 1.00
--EXEC insertar_DetalleOrdComp 7, 3, 10, 2.00

--EXEC insertar_DetalleOrdComp 8, 2, 20, 2.00
--EXEC insertar_DetalleOrdComp 8, 1, 20, 2.00
--EXEC insertar_DetalleOrdComp 8, 3, 10, 1.00
--EXEC insertar_DetalleOrdComp 8, 3, 10, 2.00

--SELECT * FROM DetalleCompra 

--EXEC mostrar_OrdComp 
--EXEC mostrarDetalleCompra 

--EXEC insertar_ProductoSinIMG 'El minimun vitaum', 'novela filosofica', 2.00, 0.50, 2.50, 64, 2,  1

--SELECT COUNT(*) AS Cuenta FROM Proveedor

-- INSERCION DE DATOS PARA PROBAR COMPRA
--SELECT * FROM Producto 

--EXEC insertar_OrdComp 1
--SELECT * FROM Compra

--EXEC insertar_DetalleOrdComp 28, 6, 120, 2.50;
--EXEC insertar_DetalleOrdComp 28, 5, 120, 2.50;
--EXEC insertar_DetalleOrdComp 28, 4, 120, 2.50; 
--SELECT * FROM DetalleCompra WHERE CompraId = 28

--EXEC insertar_DetalleOrdComp 29, 2, 150, 2.50;
--EXEC insertar_DetalleOrdComp 29, 3, 100, 2.50; 
--SELECT * FROM DetalleCompra WHERE CompraId = 29

--EXEC insertar_DetalleOrdComp 30, 1, 70, 2.50;
--SELECT * FROM DetalleCompra WHERE CompraId = 30

--EXEC insertar_DetalleOrdComp 32, 1, 10, 2.50;
--EXEC insertar_DetalleOrdComp 32, 2, 10, 2.50;
--EXEC insertar_DetalleOrdComp 32, 3, 10, 2.50;
--EXEC insertar_DetalleOrdComp 32, 4, 10, 2.50;
--EXEC insertar_DetalleOrdComp 32, 5, 10, 2.50;
--EXEC insertar_DetalleOrdComp 32, 6, 10, 2.50;
--SELECT * FROM DetalleCompra WHERE CompraId = 32

--EXEC insertar_DetalleOrdComp 33, 1, 10, 2.50;
--EXEC insertar_DetalleOrdComp 33, 2, 10, 2.50;
--EXEC insertar_DetalleOrdComp 33, 3, 10, 2.50;
--EXEC insertar_DetalleOrdComp 33, 4, 10, 2.50;
--EXEC insertar_DetalleOrdComp 33, 5, 10, 2.50;
--EXEC insertar_DetalleOrdComp 33, 6, 10, 2.50;
--EXEC insertar_DetalleOrdComp 33, 1, 50, 2.50;
--EXEC insertar_DetalleOrdComp 33, 2, 50, 2.50;
--EXEC insertar_DetalleOrdComp 33, 3, 50, 2.50;
--EXEC insertar_DetalleOrdComp 33, 4, 50, 2.50;
--EXEC insertar_DetalleOrdComp 33, 5, 50, 2.50;
--EXEC insertar_DetalleOrdComp 33, 6, 50, 2.50;
--SELECT * FROM detalleCompra WHERE CompraId = 33

--EXEC editarOrdEst2 30
--EXEC editarOrdEst2 29
--EXEC editarOrdEst2 28
--EXEC editarOrdEst2 31
--EXEC editarOrdEst2 32
--EXEC editarOrdEst2 33

---- MUESTRA LOS PRODUCTOS SUMADOS
--SELECT CompraId, ProductoId, SUM(Cantidad) AS Cantidad, TotalEstimado FROM DetalleCompra WHERE CompraId = 33
--GROUP BY CompraId, ProductoId, TotalEstimado 

--EXEC mostrarDetalleCompraRecien 33 

--SELECT * From DetalleCompra
--SELECT * FROM Producto 

--EXEC insertar_Venta 
--SELECT * FROM Venta 

--EXEC insertar_DetalleVentaSinDoc 10, 2.50, 2, 34
--EXEC insertar_DetalleVentaSinDoc 10, 2.50, 1, 34
--SELECT * FROM DetalleVenta WHERE VentaId = 34

--DELETE FROM DetalleVenta WHERE VentaId = 32

--EXEC activar_Categoria 1
--EXEC desactivar_Categoria 1
--SELECT * FROM Categoria 
--SELECT * FROM Producto 
--SELECT * FROM Proveedor

--EXEC activar_Proveedor 1
--EXEC desactivar_Proveedor 2

--SELECT * FROM Compra WHERE CompraId = 11
--SELECT * FROM DetalleVenta WHERE VentaID = 39
--SELECT * FROM DetalleCompra WHERE CompraId = 11
--SELECT * FROM Proveedor
--EXEC mostrar_OrdCompEstado1
