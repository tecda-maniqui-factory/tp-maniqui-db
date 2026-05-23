# 📖 Centro de Documentación Técnica

Bienvenido al centro de documentación del proyecto **Tecda Maniquí**, correspondiente a la materia de **Gestión de Bases de Datos**. 

Aquí encontrarás toda la documentación detallada del diseño físico, lógico, automatización mediante triggers, la especificación de API de nivel industrial y el entorno de contenedores Docker del sistema.

## 🗺️ Mapa de Navegación

Para facilitar la exploración del proyecto, la documentación se divide en las siguientes secciones detalladas:

1.  ### 🧬 [Diseño de Base de Datos y Triggers](file:///home/jmro/Documentos/TECDA/TERCERO/Gestion_BBDD/docs/tp-maniqui-db.md)
    *   Explicación de las tres capas del modelo de datos (Catálogos, Modelos, Inventario).
    *   Diagrama Entidad-Relación (Mermaid) renderizado en alta definición.
    *   Detalle y lógica técnica de los **Triggers Inteligentes** (Autogenerador de Seriales y Validador "Anti-Frankenstein").

2.  ### 🔌 [Especificación de API REST (OpenAPI / Swagger)](file:///home/jmro/Documentos/TECDA/TERCERO/Gestion_BBDD/docs/openapi.yaml)
    *   Definición formal e interactiva de los endpoints del sistema (CRUD, filtros, respuestas de error).
    *   Mapeo directo de **Vistas SQL** en endpoints de reportes analíticos (`GET /reportes/produccion`).
    *   Endpoints de automatización que ejecutan **Procedimientos Almacenados** (`POST /maniquies`) e invocan **Funciones SQL** (`GET /modelos/{id}/descuento`).
    *   *Nota: Consulta abajo cómo renderizar interactivamente esta especificación.*

3.  ### 🐳 [Entorno Docker y Despliegue Rápido](file:///home/jmro/Documentos/TECDA/TERCERO/Gestion_BBDD/docs/tp-maniqui-docker.md)
    *   Configuración paso a paso de los contenedores Docker para **MySQL** y **MariaDB**.
    *   Parámetros de conexión, puertos (3306/3307), contraseñas y volúmenes persistentes.
    *   Comandos útiles para la gestión diaria de los contenedores.

4.  ### 🗃️ [Guía de Scripts SQL](file:///home/jmro/Documentos/TECDA/TERCERO/Gestion_BBDD/docs/scripts-guia.md)
    *   Secuencia recomendada para la ejecución manual de los scripts SQL del proyecto.
    *   Pruebas de validación de datos maestro y carga masiva.
    *   Procedimientos almacenados, funciones, índices y gestión de permisos.

---

## 🎨 ¿Cómo Visualizar la API de forma Interactiva?

La especificación está escrita bajo el estándar mundial **OpenAPI 3.0 (YAML)**. Puedes visualizarla, explorarla e incluso probar sus consultas de forma gráfica mediante dos métodos muy sencillos:

### Método A: Swagger Editor (En la Web - Sin Instalar Nada)
1.  Abre el archivo [docs/openapi.yaml](file:///home/jmro/Documentos/TECDA/TERCERO/Gestion_BBDD/docs/openapi.yaml) y copia todo su contenido de texto.
2.  Ingresa a: **[Swagger Editor](https://editor.swagger.io/)** en tu navegador.
3.  Borra el contenido de ejemplo del editor, pega tu código YAML copiado y ¡listo! En el panel derecho verás renderizada la interfaz interactiva en tiempo real de forma espectacular.

### Método B: Extensión de VS Code / Cursor
Si prefieres verlo directamente en tu entorno de desarrollo:
1.  Instala la extensión **"OpenAPI Swagger Editor"** o **"Swagger Viewer"** en tu editor.
2.  Abre el archivo `docs/openapi.yaml` y presiona `Shift + Alt + P` (o haz clic en el icono "Preview" de la extensión en la esquina superior derecha).

---
> [!NOTE]
> Esta documentación sigue estándares corporativos para organizaciones de GitHub, permitiendo una rápida integración y comprensión para desarrolladores y administradores de bases de datos.
