# 🏭 Tecda Maniquí Factory - Gestión de Base de Datos

Este repositorio contiene el diseño e implementación de la base de datos relacional para la fábrica de maniquíes **Tecda**. El proyecto está estructurado como un **Camino de Aprendizaje**, permitiendo seguir la evolución desde el esquema básico hasta la automatización avanzada.

---

## 🎓 Camino de Aprendizaje (Step-by-Step)

Para entender o replicar el proyecto, ejecuta los scripts en el siguiente orden:

1.  **[Step 1: Schema & Catalogs](scripts/step1_schema_and_catalogs.sql)**  
    Creación de la base de datos `tecda_maniqui`, tablas de catálogos y carga de datos maestros iniciales.
2.  **[Step 2: Triggers & Automation](scripts/step2_triggers_and_automation.sql)**  
    Implementación de la inteligencia del motor: Generador automático de seriales y el **Trigger Anti-Frankenstein** para validación de modelos.
3.  **[Step 3: Business Logic (SP & UDF)](scripts/step3_logic_sp_and_functions.sql)**  
    Rutinas programadas: Procedimiento transaccional para el ensamblaje atómico y funciones para cálculos de descuentos.
4.  **[Step 4: Analytical Views](scripts/step4_analytical_views.sql)**  
    Capa de reportes: Vistas SQL que consolidan costos, precios y márgenes de ganancia en tiempo real.
5.  **[Step 5: Testing & Data Bulk](scripts/step5_testing_and_data_bulk.sql)**  
    Validación a escala: Scripts de poblado masivo (100+ unidades) y consultas de control de inventario.

---

## 🛠️ Conceptos Clave Implementados

*   **Integridad Referencial:** Uso estricto de llaves foráneas y restricciones.
*   **Automatización:** Nomenclatura inteligente de piezas mediante Triggers.
*   **Transaccionalidad:** Uso de `START TRANSACTION` y `ROLLBACK` en procedimientos críticos para evitar datos inconsistentes.
*   **Analítica:** Cálculos dinámicos de costos agregados mediante Vistas.

---

## 📖 Documentación Complementaria
Puedes encontrar guías detalladas sobre conceptos específicos en la carpeta:  
👉 **[/guia_base_de_datos](guia_base_de_datos/)**

*Desarrollado para la materia Gestión de Bases de Datos - TECDA.*
