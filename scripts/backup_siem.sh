#!/bin/bash
# backup_siem.sh — Backup diario comprimido de MariaDB siem_logs
# VM-04 (10.10.20.30) — Cron: 0 2 * * * /opt/mariadb-logs/scripts/backup_siem.sh
#
# Genera volcado mysqldump comprimido en /var/backups/siem/
# Elimina copias con más de 30 días de antigüedad.

set -euo pipefail

CONTAINER="mariadb-logs"
DB="siem_logs"
BACKUP_DIR="/var/backups/siem"
DATE=$(date '+%Y%m%d_%H%M%S')
RETENTION_DAYS=30
LOG="/var/log/backup_siem.log"

mkdir -p "$BACKUP_DIR"

echo "[$(date '+%Y-%m-%d %H:%M:%S')] Iniciando backup de $DB..." >> "$LOG"

docker exec "$CONTAINER" mariadb-dump -u root -p"${MYSQL_ROOT_PASSWORD}" \
  --single-transaction --routines "$DB" | gzip > "${BACKUP_DIR}/siem_logs_${DATE}.sql.gz"

# Purga de backups antiguos (> 30 días)
find "$BACKUP_DIR" -name "siem_logs_*.sql.gz" -mtime +${RETENTION_DAYS} -delete

echo "[$(date '+%Y-%m-%d %H:%M:%S')] Backup completado: siem_logs_${DATE}.sql.gz" >> "$LOG"
