# storia-arqti

Taller 3 de ISIS-2411: arquitectura de TI de Storia en MySQL 8.

Los scripts de `sql/` se ejecutan en orden (`01_`, `02_`, …) sobre una base vacía.

## Base local

```bash
docker compose up -d                 # prende MySQL y la primera vez corre los scripts de sql/
docker compose stop                  # la apaga
docker compose down -v && docker compose up -d   # la recrea desde cero
```

Conexión: `127.0.0.1:3306`, usuario `root`, clave `root`.
