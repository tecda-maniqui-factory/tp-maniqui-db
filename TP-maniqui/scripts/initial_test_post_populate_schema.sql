-- =============================================================================
-- 5. REPORTES DE CONTROL DE INVENTARIO (ACTUALIZADO CON AS)
-- =============================================================================

/* EXPLICACIÓN DE LAS "FORMAS NUEVAS":
   1. Usamos AS en las tablas (ej. Piezas AS p) para crear un "Alias" o apodo.
      Esto evita escribir nombres largos y ayuda al motor (Engine) a no confundirse.
   2. Usamos AS en las columnas (ej. m.numero_serie AS Maniqui_Asignado) 
      para que el encabezado del reporte sea legible para humanos.
*/

SELECT 
    -- 'm.' es el apodo de Maniquies. 'AS' renombra el título del reporte.
    m.numero_serie AS Maniqui_Asignado,
    
    -- 'mo.' es el apodo de Modelos. Evitamos usar 'mod' porque da error.
    mo.nombre AS Diseño_Modelo,
    
    -- 'p.' es el apodo de Piezas.
    p.serial_parte AS Serial_de_Pieza,
    
    -- 'tp.' es el apodo de Cat_TiposParte.
    tp.nombre AS Tipo_de_Pieza,
    
    -- 'ta.' es el apodo de Cat_TonosAcabado.
    ta.nombre AS Color,
    ta.acabado AS Tipo_Acabado

-- Definimos los apodos (Alias) de las tablas usando AS
FROM Piezas AS p

-- JOIN conecta las tablas obligatorias (Si falta el tipo o el modelo, la pieza no sale)
JOIN Cat_TiposParte AS tp ON p.tipo_parte_id = tp.id
JOIN Cat_TonosAcabado AS ta ON p.tono_acabado_id = ta.id
JOIN Modelos AS mo ON p.modelo_id = mo.id

-- LEFT JOIN es fundamental para el inventario:
-- Si el 'maniqui_id' es NULL (pieza suelta), el LEFT JOIN mantiene la pieza en la lista
-- pero deja la columna 'Maniqui_Asignado' vacía.
LEFT JOIN Maniquies AS m ON p.maniqui_id = m.id;