# 🖥️ Gestión de Bases de Datos — TECDA

Bienvenidos al repositorio central de **Gestión de Bases de Datos** de la carrera **TECDA** (Tercer Año). Este espacio está diseñado bajo estándares profesionales de desarrollo de software para albergar los proyectos, diseños lógicos, automatización de bases de datos y configuraciones de infraestructura como código (Docker).

---

## 📂 Estructura del Repositorio

El proyecto se encuentra estrictamente organizado para separar la lógica de negocio de la infraestructura y de la documentación técnica detallada:

```
├── .gitignore             # Exclusiones de control de versiones
├── README.md              # Portal de bienvenida (este archivo)
├── docs/                  # Centro de Documentación Corporativa
│   ├── README.md          # Índice general de la documentación
│   ├── tp-maniqui-db.md   # Diseño lógico, físico y triggers inteligentes
│   ├── tp-maniqui-docker.md # Manual de infraestructura y contenedores Docker
│   └── scripts-guia.md    # Guía de secuencias y despliegue de scripts SQL
└── TP-maniqui/            # Código fuente y recursos del TP
    ├── diseño/            # Diagramas relacionales y análisis conceptuales
    ├── docker/            # Archivos Docker Compose (MySQL y MariaDB)
    ├── guia_base_de_datos/# Recursos educativos de BBDD avanzada
    └── scripts/           # Scripts operativos SQL (DDL, DML, Triggers, Vistas)
```

---

## 🚀 Proyectos Destacados

### 📂 [Trabajo Práctico: Tecda Maniquí](file:///home/jmro/Documentos/TECDA/TERCERO/Gestion_BBDD/TP-maniqui/README.md)
Un sistema corporativo de gestión de inventario y producción para una fábrica de maniquíes a escala industrial. 

*   **Esquema Relacional:** Capa de Catálogos, Capa de Modelos y Capa de Piezas/Stock.
*   **Automatización de Base de Datos:**
    *   **Trigger Autogenerador:** Serialización inteligente y libre de colisiones en alta concurrencia.
    *   **Trigger "Anti-Frankenstein":** Validación en base de datos para impedir el ensamblaje de piezas incompatibles entre modelos.
*   **Infraestructura:** Entornos portables listos para desarrollo local sobre **MySQL** y **MariaDB** utilizando Docker Compose.

---

## 📖 Centro de Documentación Técnica

Si quieres profundizar en los detalles técnicos de la implementación, despliegue o diseño de los proyectos, visita nuestro:

👉 **[Portal de Documentación (/docs)](file:///home/jmro/Documentos/TECDA/TERCERO/Gestion_BBDD/docs/README.md)**

*Aquí encontrarás diagramas Entidad-Relación (`mermaid.js`), manuales detallados de Docker y el orden secuencial de ejecución de los scripts de bases de datos.*

---

## 🛠️ Tecnologías y Estándares

El desarrollo de este repositorio se rige por buenas prácticas de ingeniería de software:

*   **Motores de BBDD:** MySQL 8.0 y MariaDB (Motores ACID InnoDB).
*   **Virtualización:** Docker & Docker Compose.
*   **Modelado:** MySQL Workbench (Archivos `.mwb`).
*   **Metodología Git:** Estructuración al nivel de Organizaciones de GitHub, manteniendo una raíz limpia, un `.gitignore` optimizado y documentación centralizada.

---
*Desarrollado y mantenido como parte de la currícula académica de TECDA.*