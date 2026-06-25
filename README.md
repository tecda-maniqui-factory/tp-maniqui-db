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
Ejecuta la secuencia de scripts para estructurar la base de datos o importa la suite completa:
```bash
# Conectarse e importar los archivos desde el cliente de base de datos
mysql -h 127.0.0.1 -P 3307 -u root -p tecda_maniqui < scripts/step1_schema.sql
# ... (repetir para los siguientes pasos o ejecutar el script automatizado de setup)
```

---

## 📂 Estructura de Scripts (`/scripts`)

* **`step1_schema.sql`**: Creación de tablas, catálogos y configuración de borrado lógico.
* **`step2_triggers.sql`**: Triggers de generación de seriales y validación "Anti-Frankenstein" (reglas de ensamblaje).
* **`step3_procedures.sql`**: Lógica de negocio (SP de Ensamblaje y funciones UDF de Descuentos).
* **`step4_roles.sql`**: Gestión de Usuarios, privilegios y asignación de roles.
* **`step5_audit.sql`**: Tablas de auditoría y facturación electrónica.

---

## 🧪 Pruebas de Calidad (`/tests/db`)

* `test_reforma_v2.sql`: Suite de pruebas de regresión para validar el comportamiento del SP de ensamblaje, triggers de validación y control de stock.
