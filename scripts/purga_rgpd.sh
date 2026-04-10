#!/bin/bash
# purga_rgpd.sh — Purga automática de eventos > 365 días
# Cumplimiento Art. 5.1(e) RGPD — Limitación del plazo de conservación
# VM-04 (10.10.20.30) — Cron: 0 3 1 * * /opt/mariadb-logs/scripts/purga_rgpd.sh
#
# Ejecuta el procedimiento almacenado purgar_eventos_365d() en MariaDB.

set -euo pipefail

CONTAINER="mariadb-logs"
DB="siem_logs"
LOG="/var/log/purga_rgpd.log"

echo "[$(date '+%Y-%m-%d %H:%M:%S')] Iniciando purga RGPD..." >> "$LOG"

docker exec "$CONTAINER" mariadb -u root -p"${MYSQL_ROOT_PASSWORD}" "$DB" \
  -e "CALL purgar_eventos_365d();" >> "$LOG" 2>&1

echo "[$(date '+%Y-%m-%d %H:%M:%S')] Purga completada." >> "$LOG"
