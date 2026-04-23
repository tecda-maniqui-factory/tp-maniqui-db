-- =============================================================================
-- 1. Inserción en Catálogos
-- =============================================================================
INSERT INTO Cat_Sexos (nombre) VALUES ('Masculino'), ('Femenino'), ('Unisex');

INSERT INTO Cat_Estilos (nombre) VALUES ('Realista'), ('Abstracto'), ('Vintage');

INSERT INTO Cat_TiposCuerpo (nombre) VALUES ('Entero'), ('Busto'), ('Torso');

INSERT INTO Cat_TiposParte (nombre) VALUES 
('Cabeza'), ('Torso'), ('Brazo Derecho'), ('Brazo Izquierdo'), ('Pierna Derecha'), ('Pierna Izquierda');

INSERT INTO Cat_TonosAcabado (nombre, acabado) VALUES 
('Blanco Nieve', 'Mate'), 
('Negro Piano', 'Brillante'), 
('Piel Clara', 'Satinado');

INSERT INTO Origenes_Piezas (nombre, tipo) VALUES 
('Planta Principal', 'Produccion Interna'),
('Proveedor Externo A', 'Proveedor Externo');

-- =============================================================================
-- 2. Creación de un Modelo (El "Molde")
-- =============================================================================
INSERT INTO Modelos (nombre, sexo_id, altura_cm, ancho_cm, estilo_id, cuerpo_id, talla)
VALUES ('Alpha-Male-01', 1, 185.00, 50.00, 1, 1, 'M');

-- =============================================================================
-- 3. Registro de un Maniquí Físico (La unidad final)
-- =============================================================================
INSERT INTO Maniquies (numero_serie, modelo_id, fecha_ensamblaje, numero_lote, status)
VALUES ('MQ-2026-001', 1, NOW(), 'LOTE-APR-26', 'Disponible');

-- =============================================================================
-- 4. Registro de Piezas y su vinculación al Maniquí
-- =============================================================================
-- Aquí usamos el ID 1 que es el Maniquí que acabamos de crear
INSERT INTO Piezas (serial_parte, tipo_parte_id, modelo_id, origen_id, tono_acabado_id, maniqui_id)
VALUES 
('PZ-CAB-001', 1, 1, 1, 1, 1), -- Cabeza vinculada al maniquí 1
('PZ-TOR-001', 2, 1, 1, 1, 1), -- Torso vinculado al maniquí 1
('PZ-BD-001', 3, 1, 2, 1, NULL); -- Brazo Derecho SUELTO (en stock, maniqui_id es NULL)