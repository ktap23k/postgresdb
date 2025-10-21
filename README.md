# PostgreSQL Docker Production Setup

Production-ready PostgreSQL database setup with Docker Compose, including pgAdmin for database management.

## Features

- **PostgreSQL 16 Alpine** - Lightweight and secure
- **Production-optimized configuration** - Performance tuning for production workloads
- **Health checks** - Automatic container health monitoring
- **Persistent storage** - Data persistence with Docker volumes
- **pgAdmin** - Web-based database management interface
- **Resource limits** - CPU and memory constraints
- **Logging** - Comprehensive query and duration logging
- **Auto-restart** - Automatic container restart on failure

## Quick Start

1. **Copy environment file**
   ```bash
   cp .env.example .env
   ```

2. **Edit .env file with your credentials**
   ```bash
   nano .env
   ```
   ⚠️ **Important:** Change default passwords before deploying to production!

3. **Start the services**
   ```bash
   docker-compose up -d
   ```

4. **Check status**
   ```bash
   docker-compose ps
   ```

5. **View logs**
   ```bash
   docker-compose logs -f postgres
   ```

## Access

- **PostgreSQL Database**: `localhost:5432`
- **pgAdmin Web Interface**: `http://localhost:5050`

### Connect to PostgreSQL

```bash
docker exec -it postgres_production psql -U admin -d production_db
```

Or use any PostgreSQL client with:
- Host: `localhost`
- Port: `5432`
- Database: `production_db`
- Username: `admin`
- Password: (from your .env file)

### pgAdmin Access

1. Open browser: `http://localhost:5050`
2. Login with credentials from .env file
3. Add new server:
   - Name: `Production DB`
   - Host: `postgres` (service name)
   - Port: `5432`
   - Username: `admin`
   - Password: (from your .env file)

## Configuration

### Performance Tuning

The configuration includes optimized PostgreSQL settings for production:

- `shared_buffers=256MB` - Memory for caching data
- `effective_cache_size=1GB` - OS cache estimate
- `work_mem=8MB` - Memory per operation
- `max_connections=100` - Maximum concurrent connections
- Parallel query execution enabled
- Write-Ahead Logging (WAL) optimization

Adjust these values in `docker-compose.yml` based on your server resources.

### Resource Limits

Current limits:
- CPU: 2 cores (max), 1 core (reserved)
- Memory: 2GB (max), 1GB (reserved)

Modify in the `deploy.resources` section of docker-compose.yml.

## Initialization Scripts

Place SQL or shell scripts in the `init/` directory. They will be executed automatically on first startup:

- `init/01-init.sh` - Example initialization script
- Add more scripts as needed (executed in alphabetical order)

## Backup & Restore

### Create Backup

```bash
docker exec postgres_production pg_dump -U admin -d production_db > backups/backup_$(date +%Y%m%d_%H%M%S).sql
```

Or with custom format (recommended for large databases):

```bash
docker exec postgres_production pg_dump -U admin -Fc -d production_db > backups/backup_$(date +%Y%m%d_%H%M%S).dump
```

### Restore from Backup

From SQL file:
```bash
docker exec -i postgres_production psql -U admin -d production_db < backups/backup_file.sql
```

From custom format:
```bash
docker exec -i postgres_production pg_restore -U admin -d production_db < backups/backup_file.dump
```

## Maintenance Commands

### Stop services
```bash
docker-compose down
```

### Stop and remove volumes (⚠️ deletes all data)
```bash
docker-compose down -v
```

### Restart services
```bash
docker-compose restart
```

### View resource usage
```bash
docker stats postgres_production
```

### Check database size
```bash
docker exec postgres_production psql -U admin -d production_db -c "SELECT pg_size_pretty(pg_database_size('production_db'));"
```

## Monitoring

### Check logs
```bash
docker-compose logs -f postgres
```

### Check connection count
```bash
docker exec postgres_production psql -U admin -d production_db -c "SELECT count(*) FROM pg_stat_activity;"
```

### View active queries
```bash
docker exec postgres_production psql -U admin -d production_db -c "SELECT pid, usename, application_name, client_addr, state, query FROM pg_stat_activity WHERE state != 'idle';"
```

## Security Recommendations

1. ✅ Change all default passwords in `.env`
2. ✅ Use strong, unique passwords
3. ✅ Never commit `.env` file to version control
4. ✅ Restrict port access with firewall rules
5. ✅ Use SSL/TLS for production connections
6. ✅ Regular security updates: `docker-compose pull && docker-compose up -d`
7. ✅ Regular backups (automated recommended)
8. ✅ Monitor logs for suspicious activity

## Troubleshooting

### Container won't start
```bash
docker-compose logs postgres
```

### Reset everything (⚠️ deletes all data)
```bash
docker-compose down -v
docker-compose up -d
```

### Permission issues
```bash
docker-compose down
sudo chown -R $(id -u):$(id -g) postgres_data
docker-compose up -d
```

## License

See LICENSE file for details.
