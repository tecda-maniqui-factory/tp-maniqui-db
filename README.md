# 🗃️ Tecda Maniquí - Catálogo y Motores (Database)

Este repositorio contiene el diseño físico y lógico, scripts de instalación y automatización de la **Base de Datos MariaDB/MySQL** para el sistema de producción de la fábrica de maniquíes **Tecda**.

Este proyecto forma parte de la currícula de la materia **Gestión de Bases de Datos - TERCER AÑO**.

---

## 📂 Estructura de Carpetas Sincrónica

Este repositorio sigue una estructura simétrica de carpetas corporativa:

*   **/docs**: Centro de documentación técnica.
    *   `README.md`: Guía de navegación de la base de datos.
    *   `tp-maniqui-db.md`: Diseño lógico, físico y triggers.
    *   `tp-maniqui-docker.md`: Entornos de contenedores Docker (puerto `3307`).
    *   `scripts-guia.md`: Manual operativo de scripts SQL.
*   **/scripts**: Scripts SQL de despliegue numerados.
*   **/docker**: Entornos rápidos con Docker Compose.
*   **/diseño**: Modelos gráficos `.mwb` y análisis.
*   **/guia_base_de_datos**: Procedimientos, funciones y transacciones de aprendizaje.

---

## 🚀 Guía de Inicio Rápido

Para explorar y levantar la base de datos de manera ágil:

1.  Navega al centro de documentación técnica:
    👉 **[docs/README.md](docs/README.md)**
2.  Levanta el contenedor Docker e inyecta la base de datos:
    ```bash
    cd docker/mariadb
    docker compose up -d
    ```

---
*Desarrollado de forma modular e independiente bajo la organización @tecda-maniqui-factory.*