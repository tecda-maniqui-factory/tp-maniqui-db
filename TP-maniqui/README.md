# Gestión de Bases de Datos - Sistema "Tecda Maniquí"

Este repositorio contiene el diseño, la implementación y la documentación de la base de datos para la gestión de inventario y producción de la fábrica de maniquíes **Tecda**.

## 🚀 Secuencia de Ejecución

Para montar la base de datos completa, ejecute los scripts en la carpeta `/scripts` en el siguiente orden:

1.  **`01_initial_schema.sql`**: Crea la base de datos, tablas y restricciones.
2.  **`02_trigger_serial_inteligente.sql`**: Configura la lógica de serialización profesional y validación de ensamblaje.
3.  **`03_initial_populate__schema.sql`**: Carga los datos maestros y de ejemplo.
4.  **`04_vista_produccion_maniquies.sql`**: Genera vistas para reportes de producción.
5.  **`05_initial_test_post_populate_schema.sql`**: Pruebas de validación de datos.

## 🏗️ Arquitectura del Sistema

La base de datos está organizada en tres capas lógicas:
1.  **Capa de Catálogos**: Estandariza atributos (sexos, estilos, tipos de cuerpo).
2.  **Capa de Modelos**: Define las especificaciones técnicas (Molde).
3.  **Capa de Inventario**: Gestiona piezas y maniquíes ensamblados.

## 📂 Estructura de Archivos

*   **/diseño**: Archivos `.mwb` y análisis de diseño.
*   **/docker**: Entornos rápidos con Docker Compose.
*   **/guia_base_de_datos**: Material de aprendizaje sobre procedimientos, transacciones y funciones.
*   **/scripts**: Scripts operativos numerados para el despliegue.

---
*Este proyecto forma parte de la currícula de Gestión de BBDD - TECDA.*