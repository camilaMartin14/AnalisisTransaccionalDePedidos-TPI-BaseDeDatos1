// Program.cs (.NET 8 Minimal API) 
using System.Data;
using Dapper;
using Microsoft.AspNetCore.Builder;
using Microsoft.Data.SqlClient;

var builder = WebApplication.CreateBuilder(args);

// 🔑 CONEXIÓN: ajustá la base de datos si corresponde
var connStr = builder.Configuration.GetConnectionString("Sql");
if (string.IsNullOrWhiteSpace(connStr))
{
    throw new InvalidOperationException("Connection string 'Sql' is not configured.");
}

builder.Services.AddScoped<IDbConnection>(_ => new SqlConnection(connStr));
builder.Services.AddCors(o => o.AddDefaultPolicy(p => p
    .AllowAnyOrigin().AllowAnyHeader().AllowAnyMethod())); // en prod, restringilo
builder.Services.AddEndpointsApiExplorer();
builder.Services.AddSwaggerGen();

var app = builder.Build();

if (app.Environment.IsDevelopment())
{
    app.UseSwagger();
    app.UseSwaggerUI();
}

app.UseCors();

// ---------- Consulta #1: Retrasos de entrega ----------
app.MapGet("/api/retrasos", async (IDbConnection db) =>
{
    var sql = @"
SELECT  
    p.nro_pedido,
    c.nombre + ' ' + c.apellido AS Cliente,
    CONVERT(VARCHAR(10), p.fecha, 103) AS FechaPedido,
    CONVERT(VARCHAR(10), p.fecha_entrega, 103) AS FechaPrevista,
    es.estado_actual AS EstadoActual,
    DATEDIFF(DAY, p.fecha_entrega, GETDATE()) AS DiasRetraso,
    SUM(dp.cantidad * dp.precio) AS TotalEstimado,
    te.fecha_estado AS UltimaActualizacion
FROM pedidos p
JOIN clientes c ON p.cod_cliente = c.cod_cliente
JOIN detalle_pedidos dp ON p.nro_pedido = dp.nro_pedido
JOIN tracking_envios te ON te.id_tracking = (
    SELECT TOP 1 id_tracking FROM tracking_envios t2 
    WHERE t2.nro_pedido =  p.nro_pedido ORDER BY t2.fecha_estado DESC
)
JOIN estados_envios es ON te.id_estado_envio = es.id_estado_envio
WHERE es.estado_actual != 'Entregado' AND p.fecha_entrega < GETDATE()
GROUP BY p.nro_pedido, c.nombre, c.apellido, p.fecha, p.fecha_entrega, es.estado_actual, te.fecha_estado
ORDER BY DiasRetraso DESC;";
    var data = await db.QueryAsync(sql);
    // camelCase para el front
    return Results.Ok(data.Select(r => new {
        nro_pedido = (int)r.nro_pedido,
        cliente = (string)r.Cliente,
        fechaPedido = (string)r.FechaPedido,
        fechaPrevista = (string)r.FechaPrevista,
        estadoActual = (string)r.EstadoActual,
        diasRetraso = (int)r.DiasRetraso,
        totalEstimado = (decimal)r.TotalEstimado,
        ultimaActualizacion = ((DateTime)r.UltimaActualizacion).ToString("yyyy-MM-dd HH:mm")
    }));
});

// ---------- Consulta #2: Clientes de alto valor ----------
app.MapGet("/api/clientes/top", async (IDbConnection db) =>
{
    var sql = @"
SELECT  
    c.cod_cliente,
    c.apellido + ' ' + c.nombre AS Cliente,
    COUNT(DISTINCT f.nro_factura) AS CantidadCompras,
    SUM(d.cantidad * d.precio) AS TotalGastado,
    (
        SELECT TOP 1 l.titulo  
        FROM libros l
        JOIN detalle_facturas d2 ON l.cod_libro = d2.cod_libro 
        JOIN facturas f2 ON d2.nro_factura = f2.nro_factura 
        WHERE f2.cod_cliente = c.cod_cliente 
        GROUP BY l.titulo 
        ORDER BY SUM(d2.cantidad * d2.precio) DESC
    ) AS LibroMasComprado
FROM clientes c
JOIN facturas f ON c.cod_cliente = f.cod_cliente
JOIN detalle_facturas d ON f.nro_factura = d.nro_factura
GROUP BY c.cod_cliente, c.apellido, c.nombre
HAVING SUM(d.cantidad * d.precio) > (
    SELECT AVG(total) FROM (
        SELECT SUM(d2.cantidad * d2.precio) AS total
        FROM facturas f2 
        JOIN detalle_facturas d2 ON f2.nro_factura = d2.nro_factura
        GROUP BY f2.cod_cliente
    ) AS totales
)
ORDER BY TotalGastado DESC;";
    var data = await db.QueryAsync(sql);
    return Results.Ok(data.Select(r => new {
        cod_cliente = (int)r.cod_cliente,
        cliente = (string)r.Cliente,
        cantidadCompras = (int)r.CantidadCompras,
        totalGastado = (decimal)r.TotalGastado,
        libroMasComprado = (string?)r.LibroMasComprado
    }));
});

// ---------- Consulta #3: Facturación mensual ----------
app.MapGet("/api/facturacion", async (IDbConnection db) =>
{
    var sql = @"
SELECT 
    E.editorial AS Editorial, 
    C.categoria AS Categoría, 
    YEAR(F.fecha) AS Año, 
    MONTH(F.fecha) AS Mes,
    COUNT(DISTINCT F.nro_factura) AS CantFacturas, 
    SUM(DF.cantidad) AS CantVendidas,
    SUM(DF.cantidad * DF.precio) AS ImporteTotal, 
    AVG(DF.precio * 1.0) AS PrecioPromedio,
    MIN(CAST(F.fecha AS DATE)) AS PrimeraVenta, 
    MAX(CAST(F.fecha AS DATE)) AS ÚltimaVenta
FROM facturas F
JOIN detalle_facturas DF ON F.nro_factura = DF.nro_factura
JOIN libros L ON DF.cod_libro = L.cod_libro
JOIN editoriales E ON L.id_editorial = E.id_editorial
JOIN idiomas I ON L.id_idioma = I.id_idioma
JOIN libros_categorias LC ON L.cod_libro = LC.id_libro
JOIN categorias C ON LC.id_categoria = C.id_categoria
WHERE I.idioma = 'Español'
  AND F.fecha >= '2020-07-01' 
  AND F.fecha < DATEFROMPARTS(YEAR(GETDATE()), MONTH(GETDATE()), 1)
  AND L.stock > 0
GROUP BY E.editorial, C.categoria, YEAR(F.fecha), MONTH(F.fecha)
HAVING AVG(DF.precio * 1.0) < (
  SELECT AVG(DF2.precio * 1.0)
  FROM facturas F2 
  JOIN detalle_facturas DF2 ON DF2.nro_factura = F2.nro_factura
  JOIN libros L2 ON L2.cod_libro = DF2.cod_libro 
  JOIN idiomas I2 ON I2.id_idioma = L2.id_idioma
  WHERE I2.idioma = 'Español' AND L2.stock > 0 
    AND YEAR(F2.fecha) = YEAR(F.fecha) 
    AND MONTH(F2.fecha) = MONTH(F.fecha)
)
ORDER BY [Año] DESC, [Mes], [Editorial];";
    var data = await db.QueryAsync(sql);
    return Results.Ok(data.Select(r => new {
        editorial = (string)r.Editorial,
        categoria = (string)r.Categoría,
        anio = (int)r.Año,
        mes = (int)r.Mes,
        cantFacturas = (int)r.CantFacturas,
        cantVendidas = (int)r.CantVendidas,
        importeTotal = (decimal)r.ImporteTotal,
        precioPromedio = (decimal)r.PrecioPromedio,
        primeraVenta = (DateTime?)r.PrimeraVenta,
        ultimaVenta = (DateTime?)r.ÚltimaVenta
    }));
});

// ---------- Consulta #4: Ranking gasto anual ----------
app.MapGet("/api/gasto-anual", async (IDbConnection db) =>
{
    // Usamos tabla temporal como en el enunciado
    var sql = @"
IF OBJECT_ID('tempdb..#GastoClientes') IS NOT NULL DROP TABLE #GastoClientes;
SELECT  
    c.cod_cliente, 
    c.apellido + ' ' + c.nombre AS Cliente, 
    SUM(dp.cantidad * dp.precio) AS TotalGastado
INTO #GastoClientes
FROM clientes c
JOIN pedidos p ON c.cod_cliente = p.cod_cliente
JOIN detalle_pedidos dp ON p.nro_pedido = dp.nro_pedido
WHERE YEAR(p.fecha) = YEAR(GETDATE())
GROUP BY c.cod_cliente, c.apellido, c.nombre;

SELECT cod_cliente, Cliente, TotalGastado
FROM #GastoClientes
WHERE TotalGastado > ( SELECT AVG(TotalGastado) FROM #GastoClientes )
ORDER BY TotalGastado DESC;";
    var data = await db.QueryAsync(sql);
    return Results.Ok(data.Select(r => new {
        cod_cliente = (int)r.cod_cliente,
        cliente = (string)r.Cliente,
        totalGastado = (decimal)r.TotalGastado
    }));
});

// ---------- SP: crear autor ----------
app.MapPost("/api/autores", async (IDbConnection db, AutorDto dto) =>
{
    // Llamamos al SP como indica el PDF; si no existe, devolvemos error claro.
    var p = new DynamicParameters();
    p.Add("@nombre", dto.nombre);
    p.Add("@apellido", dto.apellido);
    p.Add("@biografia", dto.biografia);
    p.Add("@fecha_nacimiento", dto.fecha_nacimiento);
    p.Add("@id_nacionalidad", dbType: DbType.Int32, value: null); // se puede pasar por nombre también
    p.Add("@nacionalidad", dto.nacionalidad);
    p.Add("@id_sexo", dbType: DbType.Int32, value: null);
    p.Add("@sexo", dto.sexo);

    try {
        await db.ExecuteAsync("dbo.sp_crear_autor", p, commandType: CommandType.StoredProcedure);
        return Results.Ok("Autor creado correctamente.");
    } catch (SqlException ex) {
        return Results.BadRequest($"Error al crear autor: {ex.Message}");
    }
});

app.Run();

record AutorDto(
    string nombre, 
    string apellido, 
    string? biografia, 
    DateTime? fecha_nacimiento, 
    string? nacionalidad, 
    string? sexo);

