# 🗄️ Tecda Maniquí - Base de Datos MySQL v2.1

Este módulo contiene el diseño físico y la lógica programable de la fábrica de maniquíes.

---

## 🏛️ Características de la Arquitectura

1.  **Esquema Relacional:** Normalizado con soporte para Producción, Ventas y Auditoría.
2.  **Borrado Lógico:** Soporte para invisibilizar registros sin perder integridad referencial (`activo = 0`).
3.  **Ensamblaje Robusto:** Procedimiento almacenado `EnsamblarManiqui` con validación de stock y atomización.
4.  **Auditoría Automática:** Triggers en Precios y Usuarios.
5.  **Vistas Financieras:** `Vista_Rentabilidad` y `Vista_Stock_Critico`.

---

## 📂 Estructura de Scripts (`/scripts`)

*   **step1...**: Creación de tablas, catálogos y borrado lógico.
*   **step2...**: Triggers de seriales y validación "Anti-Frankenstein".
*   **step3...**: Business Logic (SP de Ensamblaje y UDF de Descuentos).
*   **step4...**: Gestión de Usuarios y roles.
*   **step5...**: Auditoría y Facturación Electrónica.

---

## 🧪 Pruebas de Calidad (`/tests/db`)

*   `test_reforma_v2.sql`: Suite de regresión para validar toda la lógica nueva.

