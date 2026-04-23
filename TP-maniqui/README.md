# Gestión de Bases de Datos - Sistema "Tecda Maniquí"

Este repositorio contiene el diseño, la implementación y la documentación de la base de datos para la gestión de inventario y producción de la fábrica de maniquíes **Tecda**.

## 🏗️ Arquitectura del Sistema

La base de datos está organizada en tres capas lógicas para garantizar la integridad de los datos y la escalabilidad:

1.  **Capa de Catálogos (Parametría)**: Estandariza atributos como sexos, estilos, tipos de cuerpo, tipos de partes y acabados.
2.  **Capa de Modelos (Planos)**: Define las especificaciones técnicas, dimensiones y costos base para cada modelo de maniquí producido.
3.  **Capa de Inventario y Producción**: Gestiona el stock físico de piezas individuales y el ensamblaje de unidades finales (maniquíes terminados).

## 🚀 Características Principales

### 1. Gestión de Stock Dinámico
El sistema utiliza una lógica de claves foráneas opcionales en la tabla `Piezas`:
*   **Pieza Suelta**: Cuando `maniqui_id` es NULL, la pieza cuenta como stock de repuesto o materia prima.
*   **Pieza Ensamblada**: Cuando tiene un `maniqui_id`, forma parte de una unidad terminada, permitiendo rastrear exactamente qué partes componen cada maniquí.

### 2. Trazabilidad Total
Cada maniquí tiene un `numero_serie` único y cada parte tiene un `serial_parte`. Esto permite el seguimiento desde el origen de la pieza hasta el cliente final.

### 3. Cálculo de Capacidad de Producción
Mediante consultas avanzadas sobre el stock de piezas sueltas agrupadas por tipo, el sistema puede determinar cuántas unidades de un modelo específico se pueden ensamblar actualmente.

## 📂 Estructura de Archivos

*   **/diseño**: Contiene los archivos `.mwb` (MySQL Workbench) y el análisis técnico del diseño.
*   **/docker**: Archivos `docker-compose.yml` para levantar entornos rápidos de MariaDB o MySQL.
*   **/guia_base_de_datos**: Colección de scripts SQL con lógica de negocio (Triggers para seriales automáticos, Vistas de producción y Funciones de cálculo).
*   **/scripts**: Esquemas de inicialización y scripts de carga de datos de prueba.

---
*Este proyecto forma parte de la currícula de Gestión de BBDD - TECDA.*