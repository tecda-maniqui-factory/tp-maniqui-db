-- =============================================================================
-- TECDA MANIQUÍ - Creación de Vistas (Reports & Dashboards)
-- Descripción: Reporte consolidado de producción con costos y márgenes.
-- =============================================================================

USE tecda_maniqui;

-- Una VISTA es una consulta almacenada que se puede consultar como una tabla.
-- No duplica los datos, solo los muestra de forma organizada.

CREATE OR REPLACE VIEW Vista_Produccion_Maniquies AS
SELECT 
    m.numero_serie AS 'Serial_Maniqui',
    modl.nombre AS 'Modelo',
    s.nombre AS 'Sexo',
    e.nombre AS 'Estilo',
    tc.nombre AS 'Tipo_Cuerpo',
    m.status AS 'Estado',
    -- COSTOS:
    modl.costo_unitario AS 'Costo_Base_Modelo',
    COALESCE(SUM(p.costo), 0) AS 'Costo_Total_Piezas',
    (modl.costo_unitario + COALESCE(SUM(p.costo), 0)) AS 'Costo_Final_Produccion',
    -- PRECIO Y MARGEN:
    modl.precio_venta AS 'Precio_Venta',
    (modl.precio_venta - (modl.costo_unitario + COALESCE(SUM(p.costo), 0))) AS 'Margen_Ganancia'
FROM Maniquies m
JOIN Modelos modl ON m.modelo_id = modl.id
JOIN Cat_Sexos s ON modl.sexo_id = s.id
JOIN Cat_Estilos e ON modl.estilo_id = e.id
JOIN Cat_TiposCuerpo tc ON modl.cuerpo_id = tc.id
LEFT JOIN Piezas p ON p.maniqui_id = m.id -- Usamos LEFT JOIN por si un maniquí aún no tiene piezas asignadas
GROUP BY m.id, modl.nombre, s.nombre, e.nombre, tc.nombre, m.status, modl.costo_unitario, modl.precio_venta;

-- =============================================================================
-- CÓMO USAR LA VISTA:
-- SELECT * FROM Vista_Produccion_Maniquies;
-- SELECT * FROM Vista_Produccion_Maniquies WHERE Estado = 'Disponible';
-- =============================================================================
