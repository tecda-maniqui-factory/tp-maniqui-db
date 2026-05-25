# 📖 Centro de Documentación Técnica - Base de Datos

Bienvenido al centro de documentación técnica de la **Base de Datos** del proyecto **Tecda Maniquí**, correspondiente a la materia de **Gestión de Bases de Datos**.

Aquí encontrarás toda la documentación detallada del diseño físico, lógico, automatización mediante triggers, y el entorno de contenedores Docker del motor de base de datos.

---

## 🗺️ Mapa de Navegación del Repositorio

Para facilitar la exploración de la base de datos, la documentación se organiza en las siguientes secciones (utilizando enlaces relativos portables):

1. ### 🧬 [Diseño de Base de Datos y Triggers](tp-maniqui-db.md)
   * Explicación de las tres capas del modelo de datos (Catálogos, Modelos, Inventario).
   * Diagrama Entidad-Relación (Mermaid) renderizado en alta definición.
   * Lógica técnica de los **Triggers Inteligentes** (Autogenerador de Seriales y Validador "Anti-Frankenstein").

2. ### 🐳 [Entorno Docker y Despliegue Rápido](tp-maniqui-docker.md)
   * Configuración de contenedores Docker para **MySQL** y **MariaDB** reconfigurados en puerto **`3307`** para evitar colisiones.
   * Parámetros de conexión, usuarios (`alumno`/`password`), administración de volúmenes y persistencia.

3. ### 🗃️ [Guía de Scripts SQL y Despliegue](scripts-guia.md)
   * Secuencia operativa numerada para la ejecución de scripts (DDL y DML).
   * Carga de catálogos base, triggers, vistas analíticas, suites de pruebas y carga masiva de datos.
   * Rutinas y scripts avanzados de stored procedures, índices y control transaccional.

---

## 🔌 Capas Desacopladas (Backend & APIs)

Para mantener una arquitectura limpia y simétrica de nivel profesional, la capa de servicios y su documentación han sido desacopladas y migradas a sus repositorios independientes correspondientes:

* **Especificación OpenAPI (`openapi.yaml`):** El contrato Swagger que mapea endpoints a stored procedures y vistas de base de datos ha sido migrado al repositorio del Backend.
  👉 *Consulta:* [docs/openapi.yaml en tp-maniqui-backend](https://github.com/tecda-maniqui-factory/tp-maniqui-backend/blob/main/docs/openapi.yaml)
* **Suite de Pruebas (.http):** Los archivos de requests interactivos para REST Client que testean endpoints y triggers desde el editor residen en el backend.
  👉 *Consulta:* [docs/api_tests.http en tp-maniqui-backend](https://github.com/tecda-maniqui-factory/tp-maniqui-backend/blob/main/docs/api_tests.http)

---
> [!NOTE]
> Toda esta documentación utiliza enlaces relativos portables. Es 100% compatible con cualquier editor (Neovim, VS Code) y se renderiza de forma espectacular directamente en la web de GitHub.
