# MySQL Any Version

MySQL service for Railway. Choose the MySQL version via the `MYSQL_VERSION` variable (e.g. `8.0.35`, `8.0.40`, `5.7`).

## Required variable

- **MYSQL_ROOT_PASSWORD** – Root password. The container will not start without it.

## Optional variables

- **MYSQL_VERSION** – Docker image tag (e.g. `8.0.35`, `8.0.40`, `5.7`). Default: `8.0.35`.
- **MYSQL_DATABASE** – Database name created on first run. Default: `railway`.
- **MYSQL_CONFIG** – MySQL configuration preset or custom settings (see below). If not set, MySQL uses its defaults.

## Volume

Mount a volume at **`/var/lib/mysql`** for persistent data.

## Custom MySQL Configuration (MYSQL_CONFIG)

Use the `MYSQL_CONFIG` variable to tune MySQL settings without rebuilding the image.

### Presets

Use one of the predefined modes for quick setup:

| Mode | RAM (idle) | Use case |
|------|------------|----------|
| `low` | ~100-200MB | Development, low-traffic apps, saving costs |
| `normal` | ~300-400MB | Standard production workloads |
| `high` | ~500-700MB | High-traffic, performance-critical apps |

If `MYSQL_CONFIG` is not set, MySQL uses its built-in defaults (~400-500MB).

**Example:**
```
MYSQL_CONFIG=low
```

### Custom Configuration

For fine-tuned control, pass a comma-separated list of `shortname=value` pairs:

```
MYSQL_CONFIG=ibps=64M,kbs=4M,toc=128,mc=75
```

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

You can also use full MySQL option names: `MYSQL_CONFIG=innodb_buffer_pool_size=64M,max_connections=50`

### Preset Details

**low** – Minimal memory footprint:
```
ibps=32M, kbs=1M, toc=64, tcs=4, tts=2M, mhts=2M, ilbs=256K, mc=50
```

**normal** – Balanced for typical workloads:
```
ibps=128M, kbs=8M, toc=256, tcs=8, tts=16M, mhts=16M, ilbs=1M, mc=100
```

**high** – Optimized for performance:
```
ibps=256M, kbs=16M, toc=512, tcs=16, tts=32M, mhts=32M, ilbs=4M, mc=200
```

## Changing the MySQL version

Changing `MYSQL_VERSION` (e.g. from `8.0.35` to `8.0.40` or to `5.7`) and redeploying may work without any extra steps—for example, patch updates within the same minor version often keep compatibility.

The new version can be **incompatible** with the existing data directory, and the service may then fail to start or accept connections.

**If you run into connection or startup issues after changing the version:** wipe the volume so the data directory matches the chosen version.

1. In the MySQL service on Railway, open the volume and run **Wipe**.
2. Let Railway redeploy (or trigger a redeploy). The new version will initialize on an empty data directory and you should be able to connect again.

Wiping removes all data in the volume. Back up anything you need before wiping.

## Example (Railway variables)

| Variable             | Example   |
|----------------------|-----------|
| MYSQL_ROOT_PASSWORD  | (your secret) |
| MYSQL_VERSION        | 8.0.40    |
| MYSQL_DATABASE       | railway   |
| MYSQL_CONFIG         | low |
