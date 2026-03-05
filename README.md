# CNPG PostgreSQL with pg_stat_monitor

Custom [CloudNativePG](https://cloudnative-pg.io/) PostgreSQL images with [Percona pg_stat_monitor](https://docs.percona.com/pg-stat-monitor/) extension pre-installed.

Built on top of the official `ghcr.io/cloudnative-pg/postgresql` images with multi-arch support (amd64, arm64).

## Available images

```
ghcr.io/amoniacou/cloud-native-pg-postgresql-with-pg-stat-monitor:<pg_version>-standard-<variant>
```

**PostgreSQL versions:** 16, 17
**Debian variants:** `standard-bookworm`, `standard-trixie`

Example:
```
ghcr.io/amoniacou/cloud-native-pg-postgresql-with-pg-stat-monitor:17.9-standard-bookworm
```

## Usage with CloudNativePG

```yaml
apiVersion: postgresql.cnpg.io/v1
kind: Cluster
metadata:
  name: my-cluster
spec:
  instances: 3
  imageName: ghcr.io/amoniacou/cloud-native-pg-postgresql-with-pg-stat-monitor:17.9-standard-bookworm

  postgresql:
    shared_preload_libraries:
      - pg_stat_monitor
```

Then enable the extension in your database:

```sql
CREATE EXTENSION pg_stat_monitor;
```

## How it works

The [Dockerfile](Dockerfile) takes the official CNPG PostgreSQL image and installs `percona-pg-stat-monitor` from Percona's apt repository (already configured in the base image).

Build arguments:

| Argument | Default | Description |
|---|---|---|
| `PG_VERSION` | `17.6` | PostgreSQL version |
| `DEB_VERSION` | `standard-trixie` | Debian variant |

## Auto-updates

A [daily workflow](.github/workflows/check-updates.yaml) checks for new PostgreSQL minor versions published by CloudNativePG and automatically builds images for any versions not yet in our registry. This means new PostgreSQL patch releases (e.g., 17.9 -> 17.10) are picked up automatically without manual intervention.

You can also trigger the check manually via the "Run workflow" button in GitHub Actions.

## Building locally

```bash
docker buildx build \
  --build-arg PG_VERSION=17.9 \
  --build-arg DEB_VERSION=standard-bookworm \
  --platform linux/amd64,linux/arm64 \
  -t my-pg-with-pgsm:17.9-standard-bookworm \
  .
```

## License

This project is provided as-is. The base PostgreSQL images are maintained by the [CloudNativePG](https://github.com/cloudnative-pg/postgres-containers) project. pg_stat_monitor is developed by [Percona](https://github.com/percona/pg_stat_monitor).
