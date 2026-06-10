# 🐳 Entorno Docker y Despliegue Rápido (Motores SQL)

Para facilitar la ejecución de pruebas y el desarrollo del proyecto **Tecda Maniquí**, se proporcionan entornos de base de datos preconfigurados utilizando **Docker** y **Docker Compose**. Puedes elegir levantar **MariaDB** o **MySQL**.

---

## 🎛️ 1. Entornos Disponibles

El proyecto cuenta con dos configuraciones independientes ubicadas en la carpeta [docker/](../docker):

| Servidor | Directorio | Puerto Externo | Contenedor | Imagen |
| :--- | :--- | :--- | :--- | :--- |
| **MariaDB** | `docker/mariadb/` | `3307` *(Reconfigurado)* | `tecda-mariadb` | `mariadb:latest` |
| **MySQL** | `docker/mysql/` | `3307` | `tecda-mysql` | `mysql:8.0` |

> [!WARNING]
> **Resolución de Conflictos de Puerto:**
> Originalmente MariaDB mapeaba al puerto estándar `3306`. Sin embargo, dado que en tu sistema este puerto suele estar ocupado por otros servicios de base de datos activos (como `secretary-db-dev`), **el contenedor de MariaDB ha sido reconfigurado para exponerse en el puerto externo `3307`**. 
> Asegúrate de **levantar solo uno de los dos entornos a la vez** (MariaDB o MySQL) ya que ambos comparten el mapeo de host `3307`.

---

## ⚙️ 2. Credenciales y Conexión

Ambas bases de datos se inicializan con los mismos parámetros de acceso por defecto:

*   **Host:** `localhost` (o `127.0.0.1`)
*   **Puerto de Conexión:** `3307`
*   **Nombre BBDD:** `gestion_bbdd`
*   **Usuario Administrador (Root):**
    *   *Usuario:* `root`
    *   *Contraseña:* `root`
*   **Usuario de Aplicación (Alumno):**
    *   *Usuario:* `alumno`
    *   *Contraseña:* `password`

### 👥 Usuarios de Prueba (Aplicación)
Todos los usuarios de la aplicación utilizan la contraseña: **`tecda2026`**

| Usuario | Rol | Descripción |
| :--- | :--- | :--- |
| `admin_pablo` | `gerente_prod` | Administrador total del sistema. |
| `ventas_ana` | `vendedor` | Gestión comercial y clientes. |
| `vendedor_test` | `vendedor` | Cuenta para pruebas automatizadas. |
| `gerente_test` | `gerente_prod` | Cuenta para pruebas automatizadas. |
| `vendedor_1` | `vendedor` | Usuario genérico de ventas. |
| `gerente_1` | `gerente_prod` | Usuario genérico de gerencia. |

---

## 🚀 3. Guía de Inicio Rápido

### Paso 1: Navegar al directorio del entorno elegido
Abre una terminal y colócate en la carpeta correspondiente desde la raíz del proyecto. Por ejemplo, para MariaDB:
```bash
cd docker/mariadb
```

### Paso 2: Levantar el contenedor
Inicia el servicio en segundo plano (detached mode):
```bash
docker compose up -d
```

### Paso 3: Verificar que el contenedor esté corriendo
```bash
docker compose ps
```

### Paso 4: Detener el contenedor
Para detener el servicio sin borrar los datos almacenados en el volumen:
```bash
docker compose down
```

---

## 📦 4. Persistencia de Datos y Volúmenes

Para asegurar que tu base de datos no se pierda al apagar o destruir el contenedor, se configuran **Volúmenes Nombrados de Docker**:

*   **MySQL:** `tecda_mysql_data` montado en `/var/lib/mysql`
*   **MariaDB:** `tecda_mariadb_data` montado en `/var/lib/mysql`

### 💡 Limpieza Absoluta de Datos
Si deseas reiniciar la base de datos a su estado original (borrando todos los cambios y datos de prueba que hayas agregado), debes remover el volumen al apagar el contenedor:
```bash
docker compose down -v
```

---

## 💻 5. Comandos Avanzados de Utilidad

### Acceso Directo por Consola (CLI del Contenedor)
Puedes ingresar a la terminal interactiva del motor directamente mediante Docker en tu shell ZSH:

*   **Para MySQL:**
    ```bash
    docker exec -it tecda-mysql mysql -u alumno -ppassword gestion_bbdd
    ```
*   **Para MariaDB:**
    ```bash
    docker exec -it tecda-mariadb mariadb -u alumno -ppassword gestion_bbdd
    ```

### Monitoreo de Logs en Vivo
Si quieres ver qué está ocurriendo internamente en el motor de base de datos o diagnosticar algún error de conexión:
```bash
docker compose logs -f
```
