# Laravel Docker Setup

Entorno de desarrollo local para Laravel con Docker (Nginx, PHP 8.2, MySQL 8, Xdebug).

## 🚀 Quick Start

### 1. Levantar el entorno
```bash
docker compose up -d --build
```
> La web estará disponible en: **http://localhost:8080**

### 2. Instalar Laravel (Si `src/` está vacío)
Si es la primera vez y no tienes el proyecto creado:
```bash
# Entrar al contenedor
docker compose exec php bash

# Instalar Laravel (¡Importante el punto al final!)
composer create-project laravel/laravel .

# Salir
exit
```

### 3. Configurar `.env`
Para que Laravel conecte con la base de datos del contenedor, edita `src/.env`:

```ini
DB_CONNECTION=mysql
DB_HOST=mysql
DB_PORT=3306
DB_DATABASE=test
DB_USERNAME=alumno
DB_PASSWORD=alumno
```
> Ejecutar migraciones: `docker compose exec php php artisan migrate`

---

## 🔑 Credenciales & Puertos

| Servicio | Host (Externo) | Container (Interno) | Usuario / Pass |
| :--- | :--- | :--- | :--- |
| **Nginx** | `localhost:8080` | `80` | - |
| **MySQL** | `localhost:3307` | `3306` | `alumno` / `alumno` |
| **MySQL Root**| - | - | `root` / `administrador` |
| **Xdebug** | - | `9003` | - |

---

## 🛠 Comandos Útiles

**Entrar a la terminal de PHP (Artisan, Composer):**
```bash
docker compose exec php bash
```

**Entrar a MySQL (Cliente SQL):**
```bash
docker compose exec mysql mysql -ualumno -palumno test
```

**Reiniciar todo (Borra la Base de Datos):**
```bash
docker compose down -v
docker compose up -d
```

**Exportar Base de Datos (Backup):**
```bash
docker compose exec mysql mysqldump -uroot -padministrador test > scripts/backup.sql
```

**Importar Base de Datos:**
```bash
docker compose exec mysql mysql -uroot -padministrador test < scripts/backup.sql
```

---

## 🐛 Configuración Xdebug (VS Code)

Para depurar, usa esta configuración en tu `.vscode/launch.json`:

```json
{
    "version": "0.2.0",
    "configurations": [
        {
            "name": "Docker Xdebug",
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

## 📝 Notas / Troubleshooting

* **Error `entrypoint.sh not found`:** Asegúrate de que el archivo `docker/php/entrypoint.sh` tenga saltos de línea **LF** (no CRLF) en VS Code.
* **Permisos en Linux:** Si tienes problemas de escritura en `storage`, ejecuta:
    `docker compose exec php chown -R www-data:www-data storage bootstrap/cache`
* **Carpeta `src`:** Todo lo que pongas aquí se sincroniza automáticamente con `/var/www` en el contenedor.