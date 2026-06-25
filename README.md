# 🗄️ Tecda Maniquí - Base de Datos MySQL v2.1

Este módulo contiene el diseño físico, los scripts de inicialización y la lógica programable de la base de datos para la fábrica de maniquíes **Tecda**.

---

## 🏛️ Características de la Arquitectura

1. **Esquema Relacional:** Normalizado con soporte para Producción, Ventas y Auditoría.
2. **Borrado Lógico:** Soporte para invisibilizar registros sin perder integridad referencial (`activo = 0`).
3. **Ensamblaje Robusto:** Procedimiento almacenado `EnsamblarManiqui` con validación de stock y atomización transaccional.
4. **Auditoría Automática:** Triggers en tablas críticas como Precios y Usuarios para registrar cambios históricos.
5. **Vistas Financieras y de Control:** `Vista_Rentabilidad` y `Vista_Stock_Critico`.

---

## 🚀 Instalación y Despliegue Rápido

### Requisitos Previos
* Docker y Docker Compose instalados.

### Paso 1: Levantar el contenedor de MariaDB/MySQL
Navega al directorio del contenedor y levanta el servicio local expuesto en el puerto **`3307`**:
```bash
cd docker/mariadb
docker compose up -d
```

### Paso 2: Importar la estructura y los datos
Ejecuta el script maestro de configuración que cargará automáticamente todos los módulos en orden de dependencia:
```bash
# Importar la base de datos completa utilizando el setup master
mysql -h 127.0.0.1 -P 3307 -u root -p tecda_maniqui < scripts/main_setup.sql
```

---

## 📂 Estructura de Scripts (`/scripts`)

* **`main_setup.sql`**: Script maestro de configuración que orquesta y ejecuta todos los archivos en orden.
* **`step1_schema_and_catalogs.sql`**: Creación de tablas, relaciones y catálogos estáticos.
* **`step2_triggers_and_automation.sql`**: Automatización de folios de auditoría y validación "Anti-Frankenstein".
* **`step3_logic_sp_and_functions.sql`**: Lógica transaccional (SP `EnsamblarManiqui` y funciones UDF).
* **`step4_user_management.sql`**: Configuración de seguridad, roles, usuarios y permisos.
* **`step5_enterprise_features.sql`**: Gestión de auditorías avanzadas y facturación electrónica.
* **`step6_supply_and_logistics.sql`**: Módulo de abastecimiento, proveedores y órdenes de compra.
* **`step7_quality_and_settings.sql`**: Control de calidad de piezas y configuraciones operativas.
* **`seed_data_v2.sql`**: Carga de datos de prueba para validación y desarrollo.

---

## 🧪 Pruebas de Calidad (`/tests/db`)

* `test_reforma_v2.sql`: Suite de pruebas de regresión para validar el comportamiento del SP de ensamblaje, triggers de validación y control de stock.
