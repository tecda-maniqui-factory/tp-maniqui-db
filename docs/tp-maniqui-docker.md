# 🐳 Entorno Docker y Despliegue Rápido

Para facilitar la ejecución de pruebas y el desarrollo del proyecto **Tecda Maniquí**, se proporcionan entornos de base de datos preconfigurados utilizando **Docker** y **Docker Compose**. Puedes elegir entre **MariaDB** o **MySQL**.

---

## 🎛️ 1. Entornos Disponibles

El proyecto cuenta con dos configuraciones independientes ubicadas en la carpeta [docker/](file:///home/jmro/Documentos/TECDA/TERCERO/Gestion_BBDD/TP-maniqui/docker):

| Servidor | Directorio | Puerto Externo | Contenedor | Imagen |
| :--- | :--- | :--- | :--- | :--- |
| **MariaDB** | `docker/mariadb/` | `3306` | `tecda-mariadb` | `mariadb:latest` |
| **MySQL** | `docker/mysql/` | `3307` | `tecda-mysql` | `mysql:8.0` |

> [!WARNING]
> Si tienes una base de datos local corriendo en el puerto por defecto `3306` de tu máquina host, utiliza el entorno de **MySQL** que mapea hacia el puerto externo **`3307`** para evitar conflictos.

---

## ⚙️ 2. Credenciales y Conexión

Ambas bases de datos se inicializan con los mismos parámetros de acceso por defecto:

*   **Host:** `localhost` (o `127.0.0.1`)
*   **Nombre BBDD:** `gestion_bbdd`
*   **Usuario Administrador (Root):**
    *   *Usuario:* `root`
    *   *Contraseña:* `root`
*   **Usuario de Aplicación (Alumno):**
    *   *Usuario:* `alumno`
    *   *Contraseña:* `password`

---

## 🚀 3. Guía de Inicio Rápido

### Paso 1: Navegar al directorio del entorno elegido
Abre una terminal y colócate en la carpeta correspondiente. Por ejemplo, para MySQL:
```bash
cd TP-maniqui/docker/mysql
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
Para detener el servicio sin borrar los datos almacenados:
```bash
docker compose down
```

---

## 📦 4. Persistencia de Datos y Volúmenes

Para asegurar que tu base de datos no se borre al apagar o destruir el contenedor, se configuran **Volúmenes Nombrados de Docker**:

*   **MySQL:** `tecda_mysql_data` montado en `/var/lib/mysql`
*   **MariaDB:** `tecda_mariadb_data` montado en `/var/lib/mysql`

### 💡 Limpieza Absoluta de Datos
Si deseas reiniciar la base de datos a su estado original (borrando todos los cambios y datos agregados), debes remover el volumen al apagar el contenedor:
```bash
docker compose down -v
```

---

## 💻 5. Comandos Avanzados de Utilidad

### Acceso Directo por Consola (CLI)
Puedes ingresar a la terminal interactiva del motor directamente mediante Docker:

*   **Para MySQL:**
    ```bash
    docker exec -it tecda-mysql mysql -u alumno -ppassword gestion_bbdd
    ```
*   **Para MariaDB:**
    ```bash
    docker exec -it tecda-mariadb mariadb -u alumno -ppassword gestion_bbdd
    ```

### Monitoreo de Logs en Vivo
Si quieres ver qué está ocurriendo en el servidor o diagnosticar un error de conexión:
```bash
docker compose logs -f
```
