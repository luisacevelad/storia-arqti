# storia-arqti

Taller 3 de ISIS-2411: arquitectura de TI de Storia en MySQL 8.

## Base local

```bash
docker compose up -d                              # prende MySQL; la primera vez corre los scripts de sql/
docker compose stop                               # la apaga
docker compose down -v && docker compose up -d    # la recrea desde cero
```

Conexión: `127.0.0.1:3306`, usuario `root`, clave `root`.

## Scripts

Se ejecutan en orden sobre una base vacía, que es como los corren los evaluadores.

| Script | Contenido |
|---|---|
| `01_esquema.sql` | Esquema del curso, sin cambios |
| `02_ajustes_esquema.sql` | Tabla `requerimiento_componente` (requerimiento funcional ↔ aplicación) |
| `03_capacidades.sql` | 60 capacidades (`C-01` a `C-60`) |
| `04_bac69_requerimientos.sql` | BAC-69: `RF-01` a `RF-57` y `RNF-01` a `RNF-12` |

## Para agregar tu parte

1. Crea tu script con el siguiente número (`05_…`, `06_…`) y empiézalo con `USE taller3;` y `SET NAMES utf8mb4;`.
2. Usa los IDs ya cargados: capacidades `C-xx`, requerimientos `RF-xx`. Para repartir los requerimientos entre aplicaciones usa `requerimiento_componente`.
3. Cada BAC se muestra con una vista llamada `bacXX_nombre`, igual que las vistas `bac69a` y `bac69b` del curso.
4. Antes de subir, recrea la base desde cero y verifica que todos los scripts corran sin errores.
