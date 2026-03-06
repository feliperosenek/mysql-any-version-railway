# Deploy and Host

Deploy this repository as a new service on Railway. The service runs MySQL in a container and persists data to a volume. Configure `MYSQL_ROOT_PASSWORD` (required) and optionally `MYSQL_VERSION`, `MYSQL_DATABASE`, and `MYSQL_CONFIG` in the service variables.

## About Hosting

This template is hosted as a Docker-based service on Railway. MySQL runs from the official Docker image; the version is chosen via the `MYSQL_VERSION` build variable. Data is stored in a volume mounted at `/var/lib/mysql`. Use Railway's TCP Proxy if you need to connect from outside Railway.

## Why Deploy

- **Choose your MySQL version** – Set `MYSQL_VERSION` (e.g. `8.0.35`, `8.0.40`, `5.7`) instead of being locked to a single version.
- **Memory presets** – Use `MYSQL_CONFIG` to choose between `low`, `normal`, or `high` memory profiles, or define custom settings.
- **Simple setup** – Set `MYSQL_ROOT_PASSWORD` and optionally the database name; no extra config required.
- **Persistent data** – Attach a volume at `/var/lib/mysql` so data survives redeploys.
- **General-purpose config** – utf8mb4 and a strict sql_mode suitable for most applications.

## Memory Presets

Control MySQL memory usage via the `MYSQL_CONFIG` variable:

| Preset | RAM (idle) | Use case |
|--------|------------|----------|
| `low` | ~100-200MB | Development, low-traffic apps, cost savings |
| `normal` | ~300-400MB | Standard production workloads |
| `high` | ~500-700MB | High-traffic, performance-critical apps |

If `MYSQL_CONFIG` is not set, MySQL uses its built-in defaults.

### Shortname Reference

| Shortname | MySQL Option | Description |
|-----------|--------------|-------------|
| `ibps` | innodb_buffer_pool_size | InnoDB buffer pool (main memory consumer) |
| `kbs` | key_buffer_size | MyISAM index cache |
| `toc` | table_open_cache | Number of open tables cache |
| `tcs` | thread_cache_size | Cached threads for reuse |
| `tts` | tmp_table_size | Max size of internal in-memory temp tables |
| `mhts` | max_heap_table_size | Max size of MEMORY tables |
| `ilbs` | innodb_log_buffer_size | InnoDB log buffer |
| `mc` | max_connections | Maximum simultaneous connections |
| `qcs` | query_cache_size | Query cache size (MySQL 5.7 only) |
| `qct` | query_cache_type | Query cache type (MySQL 5.7 only) |
| `ifc` | innodb_flush_log_at_trx_commit | Flush behavior (1=safe, 2=fast) |
| `ilfs` | innodb_log_file_size | InnoDB log file size |
| `sbs` | sort_buffer_size | Sort buffer per connection |
| `rbs` | read_buffer_size | Read buffer per connection |
| `rrbs` | read_rnd_buffer_size | Random read buffer |
| `jbs` | join_buffer_size | Join buffer per connection |

You can also pass custom settings: `MYSQL_CONFIG=ibps=64M,mc=75,tcs=6`
or  use full MySQL option names: `MYSQL_CONFIG=innodb_buffer_pool_size=64M,max_connections=50`

## Common Use Cases

- Backend database for web apps (Node, PHP, Python, etc.)
- Development or staging MySQL when you need a specific version (e.g. 8.0 for Magento 2.4)
- Low-memory MySQL for hobby projects or cost-sensitive deployments
- Any project that needs MySQL with a configurable version on Railway

## Dependencies for

This template provides a MySQL server. Your application (or other services) depend on it for database storage.

### Deployment Dependencies

- **MYSQL_ROOT_PASSWORD** (required) – Root password for MySQL. Set this in the service variables before or at deploy; the container will not start without it.
- **Volume** – Add a volume mounted at `/var/lib/mysql` for persistent data. Without it, data is lost on redeploy.
- **MYSQL_VERSION** (optional) – Docker image tag (e.g. `8.0.35`, `5.7`). Default: `8.0.35`.
- **MYSQL_DATABASE** (optional) – Database name created on first run. Default: `railway`.
- **MYSQL_CONFIG** (optional) – Memory preset (`low`, `normal`, `high`) or custom config. If not set, MySQL uses its defaults.
