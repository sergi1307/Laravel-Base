-- Asegura privilegios globales para el usuario 'alumno'
-- Nota: el usuario lo crea MySQL automáticamente con MYSQL_USER/MYSQL_PASSWORD

GRANT ALL PRIVILEGES ON *.* TO 'alumno'@'%' WITH GRANT OPTION;
FLUSH PRIVILEGES;
