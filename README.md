
# LaravelInit – Entorno Docker para Desarrollo Web (DAW / ASIR)

Este repositorio proporciona un **entorno de desarrollo con Docker** preparado para trabajar con:

* PHP (PHP-FPM)
* Nginx
* MySQL
* Xdebug (depuración desde VSCode)

Está pensado para **uso docente**, de forma que:

* funcione igual en **Windows, Linux y macOS**
* no haya problemas de permisos
* los alumnos puedan empezar a programar y depurar desde el primer día

---

## Requisitos previos

Antes de empezar, asegúrate de tener instalado:

* **Docker**
* **Docker Compose**
* **Visual Studio Code**
* Extensión de VSCode: **PHP Debug**

No es necesario instalar PHP ni MySQL en el sistema anfitrión.

---

## Estructura del proyecto

```
laravelinit/
├── docker/
│   ├── nginx/
│   │   └── default.conf
│   ├── php/
│   │   ├── Dockerfile
│   │   ├── entrypoint.sh
│   │   └── xdebug.ini
│   └── mysql/
│       └── init/
│           └── 01-grants.sql
├── src/
│   └── public/
│       └── index.php
├── scripts/
├── docker-compose.yml
└── README.md
```

---

## Servicios Docker

El entorno levanta **tres servicios**:

| Servicio | Descripción      |
| -------- | ---------------- |
| `php`    | PHP-FPM + Xdebug |
| `nginx`  | Servidor web     |
| `mysql`  | Base de datos    |

Los nombres de los servicios son **importantes**, ya que se usan para:

* conexiones internas
* acceder a los contenedores (`docker compose exec`)

---

## Puertos utilizados

| Servicio | Puerto                  |
| -------- | ----------------------- |
| Nginx    | `http://localhost:8080` |
| MySQL    | `localhost:3307`        |
| Xdebug   | `9003`                  |

---

## Credenciales de MySQL

* **Usuario root**

  * usuario: `root`
  * contraseña: `administrador`

* **Usuario alumno**

  * usuario: `alumno`
  * contraseña: `alumno`
  * base de datos inicial: `test`
  * permisos: **administrador global** (puede crear bases de datos)

---

## Puesta en marcha del entorno

### 1️⃣ Clonar el repositorio

```bash
git clone https://github.com/jbeteta-ies/laravelinit.git
cd laravelinit
git checkout version.2
```

---

### 2️⃣ Levantar el entorno (primera vez o reinicio completo)

```bash
docker compose down -v
docker compose up -d --build
```

> ⚠️ El comando `down -v` elimina la base de datos y la vuelve a crear desde cero.
> Es el comando recomendado cuando algo no funciona.

---

### 3️⃣ Acceder desde el navegador

Abre:

```
http://localhost:8080
```

Deberías ver una página con **“Hola mundo”** y la información de PHP (`phpinfo()`).

---

## Acceso a los contenedores (muy importante)

### Entrar al contenedor PHP

```bash
docker compose exec php bash
```

### Entrar a MySQL como alumno

```bash
docker compose exec mysql mysql -ualumno -palumno
```

### Entrar a MySQL como root

```bash
docker compose exec mysql mysql -uroot -padministrador
```

---

## Depuración con Xdebug (VSCode)

### 1️⃣ Configuración de VSCode

Crea el archivo:

```
.vscode/launch.json
```

Con este contenido:

```json
{
  "version": "0.2.0",
  "configurations": [
    {
      "name": "Listen for Xdebug",
      "type": "php",
      "request": "launch",
      "port": 9003,
      "pathMappings": {
        "/var/www": "${workspaceFolder}/src"
      }
    }
  ]
}
```

---

### 2️⃣ Probar la depuración

1. Abre `src/public/index.php`
2. Pon un **breakpoint** en una línea PHP
3. En VSCode: **Run and Debug → Listen for Xdebug**
4. Recarga `http://localhost:8080`

✔️ El programa debe detenerse en el breakpoint.

Xdebug está **siempre activo** en este entorno (no hay que activar nada).

---

## Carpeta scripts (copias de seguridad)

La carpeta `scripts/` se utiliza para intercambiar archivos `.sql` con MySQL.

### Importar una base de datos

```bash
docker compose exec mysql mysql -uroot -padministrador test < /scripts/backup.sql
```

### Exportar una base de datos

```bash
docker compose exec mysql mysqldump -uroot -padministrador test > /scripts/backup.sql
```

---

## Comprobaciones finales (OBLIGATORIAS)

Antes de empezar a trabajar, **todos los alumnos deben comprobar**:

### ✔️ 1. El entorno levanta

```bash
docker compose ps
```

### ✔️ 2. La web funciona

* `http://localhost:8080` carga correctamente

### ✔️ 3. Se puede entrar a los contenedores

```bash
docker compose exec php bash
docker compose exec mysql mysql -ualumno -palumno
```

### ✔️ 4. Permisos correctos (especialmente en Linux)

Desde el host:

```bash
touch src/prueba.txt
rm src/prueba.txt
```

Desde el contenedor:

```bash
docker compose exec php touch /var/www/prueba2.txt
```

### ✔️ 5. Xdebug funciona

* VSCode escuchando
* Breakpoint activo
* La ejecución se detiene

---

## Problemas frecuentes

### ❌ MySQL no aplica cambios de usuario o contraseña

Solución:

```bash
docker compose down -v
docker compose up -d --build
```

### ❌ Xdebug no se conecta

* Comprueba que VSCode está escuchando
* Comprueba que el puerto es `9003`
* Comprueba el `pathMappings`

---

## Objetivo del entorno

Este entorno está diseñado para:

* evitar diferencias entre sistemas operativos
* reducir errores de configuración
* centrarse en **programar, depurar y aprender bases de datos**

---

Si necesitas reiniciar todo, recuerda:

```bash
docker compose down -v
docker compose up -d --build
```

---

**Fin del README**

---

Cuando quieras, en el siguiente paso puedo:

* adaptarlo exactamente al formato MkDocs
* reducirlo a una versión “entregable para alumnos”
* o preparar una hoja de incidencias rápidas para clase
