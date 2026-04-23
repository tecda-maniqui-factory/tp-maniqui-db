-- =============================================================================
-- 1. Inserción en Catálogos
-- =============================================================================
INSERT INTO Cat_Sexos (nombre) VALUES ('Masculino'), ('Femenino'), ('Unisex');

INSERT INTO Cat_Estilos (nombre) VALUES ('Realista'), ('Abstracto'), ('Vintage');

INSERT INTO Cat_TiposCuerpo (nombre) VALUES ('Entero'), ('Busto'), ('Torso');

INSERT INTO Cat_TiposParte (nombre, codigo) VALUES 
('Cabeza', 'CAB'), 
('Torso', 'TOR'), 
('Brazo Derecho', 'BRA-D'), 
('Brazo Izquierdo', 'BRA-I'), 
('Pierna Derecha', 'PIE-D'), 
('Pierna Izquierda', 'PIE-I');

INSERT INTO Cat_TonosAcabado (nombre, acabado) VALUES 
('Blanco Nieve', 'Mate'), 
('Negro Piano', 'Brillante'), 
('Piel Clara', 'Satinado');

INSERT INTO Origenes_Piezas (nombre, codigo, tipo) VALUES 
('Planta Principal', 'INT', 'Produccion Interna'),
('Proveedor Externo A', 'EXT-A', 'Proveedor Externo');

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
-- 4. Registro de Piezas (El serial_parte se genera automáticamente por el trigger)
-- =============================================================================
INSERT INTO Piezas (tipo_parte_id, modelo_id, origen_id, tono_acabado_id, maniqui_id)
VALUES 
(1, 1, 1, 1, 1), -- Cabeza vinculada al maniquí 1
(2, 1, 1, 1, 1), -- Torso vinculado al maniquí 1
(3, 1, 2, 1, NULL); -- Brazo Derecho SUELTO (en stock)
