FROM postgres:17.5-alpine

 WORKDIR /app

COPY init.sh /docker-entrypoint-initdb.d/init.sh
RUN chmod +x /docker-entrypoint-initdb.d/init.sh
COPY seed.sql ./scripts/db/seed.sql
