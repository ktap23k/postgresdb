#!/bin/bash
set -e

# Create additional databases if needed
psql -v ON_ERROR_STOP=1 --username "$POSTGRES_USER" --dbname "$POSTGRES_DB" <<-EOSQL
    -- Create extensions
    CREATE EXTENSION IF NOT EXISTS "uuid-ossp";
    CREATE EXTENSION IF NOT EXISTS "pg_stat_statements";
    
    -- Create example schema
    CREATE SCHEMA IF NOT EXISTS app;
    
    -- Grant privileges
    GRANT ALL PRIVILEGES ON SCHEMA app TO $POSTGRES_USER;
    
    -- Example table (you can remove this)
    -- CREATE TABLE app.users (
    --     id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    --     username VARCHAR(255) UNIQUE NOT NULL,
    --     email VARCHAR(255) UNIQUE NOT NULL,
    --     created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
    -- );
EOSQL

echo "Database initialization completed."
