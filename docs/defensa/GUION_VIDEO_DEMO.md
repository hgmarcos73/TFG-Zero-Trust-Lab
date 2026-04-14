# Guion técnico — Vídeo demostrativo del laboratorio

> **Duración objetivo:** 10–12 minutos  
> **Resolución:** 1920×1080 · 30 fps · Bitrate ≥ 8 000 kbps  
> **Herramienta:** OBS Studio (captura de pantalla completa)  
> **Audio:** Voz en off grabada en postproducción (ver `NARRACION_VOZ_EN_OFF.md`)

---

## Principios de grabación

El vídeo **es** la demo ante el tribunal. No hay demostración en directo.  
Tres técnicas para que sea irrefutable:

1. **Reloj del host visible** en la barra de tareas durante toda la grabación → demuestra sesión continua.
2. **Causa → efecto en tiempo real** → cada comando produce una reacción visible en otro componente.
3. **Comandos tecleados en directo** → si se pegan, al menos que se vea el prompt antes y después.

---

## Preparación previa (antes de pulsar REC)

```text
[ ] Fuente del terminal a 16 pt mínimo (preferible 18 pt)
[ ] Tema terminal: fondo negro, texto verde/blanco (máximo contraste)
[ ] Barra de tareas del host visible con reloj
[ ] Limpiar historial de alertas en Wazuh Dashboard (las nuevas serán frescas)
[ ] Verificar que las 5 VMs están encendidas y estables
[ ] Verificar que el agente Wazuh de VM-05 aparece como Active
[ ] Desbloquear la IP 10.10.10.10 en VM-02 si quedó bloqueada de pruebas anteriores:
      sudo iptables -D INPUT -s 10.10.10.10 -j DROP
[ ] Restaurar /etc/passwd en VM-05 si fue modificado:
      sudo cp /etc/passwd.bak /etc/passwd
[ ] Comprobar que Hydra y nmap están instalados en VM-05
[ ] Comprobar acceso a https://10.10.99.1 y https://10.10.20.10 y https://10.10.20.20
```

---

## BLOQUE 0 — Carátula (10 s)

**Tipo:** Slide estática (se añade en edición)

```text
Implementación Avanzada de Arquitectura Zero Trust
con SIEM, Base de Datos y Contenedores

Marcos Hernández García
Tutores: Federico Martínez Pérez · Daniel Alberto Moreno Barón
I.E.S. Al-Andalus — ASIR — 2024/2025

Vídeo demostrativo del laboratorio — sesión continua
```

**Audio:** Ninguno.

---

## BLOQUE 1 — Panorámica del laboratorio (~90 s)

**Objetivo:** Demostrar que las 5 VMs existen, están corriendo y cada una cumple su función.

### Paso 1.1 — VMware Workstation

**Pantalla:** VMware abierto con las 5 VMs en la barra lateral. Reloj del host visible.

### Paso 1.2 — VM-01 OPNsense

**Pantalla:** Click en VM-01 → consola OPNsense con menú principal (5 interfaces asignadas).

### Paso 1.3 — VM-02 FreeIPA

**Pantalla:** Click en VM-02 → prompt Rocky Linux.

```bash
hostname -f
# Salida esperada: freeipa.lab.techsecure.local
```

### Paso 1.4 — VM-03 Wazuh AIO

**Pantalla:** Click en VM-03 → prompt Ubuntu.

```bash
docker ps --format "table {{.Names}}\t{{.Status}}\t{{.Ports}}"
# Salida esperada: 3 contenedores (manager, indexer, dashboard) con status "Up"
```

### Paso 1.5 — VM-04 Logs/BD

**Pantalla:** Click en VM-04 → prompt Ubuntu.

```bash
docker ps --format "table {{.Names}}\t{{.Status}}"
# Salida esperada: contenedor MariaDB con status "Up"

systemctl status rsyslog --no-pager -l | head -5
# Salida esperada: active (running)
```

### Paso 1.6 — VM-05 Cliente

**Pantalla:** Click en VM-05 → prompt Ubuntu.

```bash
ip -4 addr show | grep "inet 10\."
# Salida esperada: inet 10.10.10.10/24 (VLAN 10)
```

---

## BLOQUE 2 — Segmentación de red y firewall · PR-01 (~80 s)

**Objetivo:** Demostrar deny-by-default entre VLANs.

### Paso 2.1 — WebUI OPNsense

**Pantalla:** Navegador → `https://10.10.99.1` → login.

### Paso 2.2 — Interfaces

**Pantalla:** Interfaces > Overview → se ven las 5 interfaces con IPs:

```text
WAN  (em0)  → DHCP
LAN  (em1)  → 10.10.10.1/24   VLAN 10 Clientes
OPT1 (em2)  → 10.10.20.1/24   VLAN 20 Servidores
OPT2 (em3)  → 10.10.30.1/24   VLAN 30 DMZ
OPT3 (em4)  → 10.10.99.1/24   VLAN 99 Gestión
```

### Paso 2.3 — Reglas firewall VLAN 10

**Pantalla:** Firewall > Rules > LAN → reglas visibles: solo puertos 1514, 1515 hacia VLAN 20.

### Paso 2.4 — Escaneo nmap desde VM-05

**Pantalla dividida:** Izquierda = terminal VM-05, derecha = OPNsense WebUI.

```bash
# En VM-05
nmap -sS -T4 10.10.20.20 -p 22,80,443,1514,1515,3306,9200
```

### Paso 2.5 — Resultado

**Salida esperada:**

```text
PORT     STATE    SERVICE
22/tcp   filtered ssh
80/tcp   filtered http
443/tcp  filtered https
1514/tcp open     unknown
1515/tcp open     unknown
3306/tcp filtered mysql
9200/tcp filtered wap-wsp
```

Solo 1514 y 1515 abiertos. Resto → `filtered`. **PR-01 PASS.**

---

## BLOQUE 3 — Suricata detecta el escaneo · PR-02 (~60 s)

**Objetivo:** El nmap anterior disparó alertas en Suricata → Wazuh. Encadena causa-efecto con B2.

### Paso 3.1 — Alertas Suricata en OPNsense

**Pantalla:** OPNsense > Services > Intrusion Detection > Alerts.

**Buscar:** Alertas recientes con firma `ET SCAN`, IP origen `10.10.10.10`, timestamp coherente.

### Paso 3.2 — Correlación en Wazuh Dashboard

**Pantalla:** Navegador → `https://10.10.20.20` → Security Events → filtrar por `10.10.10.10`.

**Buscar:** Alerta Suricata nivel ≥ 6 + regla personalizada 100002 (escaneo de puertos, nivel 8).

**PR-02 PASS.**

---

## BLOQUE 4 — Fuerza bruta SSH + respuesta automática · PR-03 (~120 s)

**Objetivo:** Bloque estrella. Ataque en directo → detección → clasificación MITRE → bloqueo.

### Layout de pantalla

```text
┌─────────────────────────┬─────────────────────────┐
│                         │  Wazuh Dashboard         │
│  Terminal VM-05          │  Security Events         │
│  (atacante)             ├─────────────────────────┤
│                         │  Terminal VM-02           │
│                         │  tail -f /var/log/secure  │
└─────────────────────────┴─────────────────────────┘
```

### Paso 4.1 — Preparar la vista triple

**Derecha abajo:** SSH a VM-02.

```bash
# En VM-02
sudo tail -f /var/log/secure
```

**Derecha arriba:** Wazuh Dashboard → Security Events (abierto, sin filtros).

**Izquierda:** Terminal VM-05 listo.

### Paso 4.2 — Lanzar ataque

```bash
# En VM-05
hydra -l admin -P /usr/share/wordlists/rockyou.txt ssh://10.10.20.10 -t 4 -V
```

### Paso 4.3 — Observar logs en VM-02

Se ven líneas `Failed password for admin from 10.10.10.10` apareciendo en tiempo real.

### Paso 4.4 — Hydra pierde conexión

Tras ~6 intentos, Hydra reporta `[ERROR] target did not complete` o similar.

### Paso 4.5 — Alerta en Wazuh Dashboard

Refrescar Security Events. Aparece:

```text
Regla: 100001
Nivel: 10
Descripción: Brute force attack detected
MITRE: T1110.001 — Brute Force: Password Guessing
IP origen: 10.10.10.10
```

### Paso 4.6 — Bloqueo en iptables de VM-02

```bash
# En VM-02
sudo iptables -L INPUT -n --line-numbers | grep 10.10.10.10
# Salida esperada: DROP  all  --  10.10.10.10  0.0.0.0/0
```

### Paso 4.7 — Confirmar que el atacante está bloqueado

```bash
# En VM-05
ssh admin@10.10.20.10
# Salida esperada: Connection refused / timeout
```

**PR-03 PASS.**

### Limpieza post-bloque (NO grabar)

```bash
# En VM-02 — desbloquear para siguientes pruebas
sudo iptables -D INPUT -s 10.10.10.10 -j DROP
```

---

## BLOQUE 5 — FreeIPA: identidad y HBAC · PR-04 (~60 s)

**Objetivo:** Demostrar gestión de identidad y control de acceso basado en host.

### Paso 5.1 — WebUI FreeIPA

**Pantalla:** Navegador → `https://10.10.20.10` → login como admin.

### Paso 5.2 — Usuarios

**Pantalla:** Identity > Users → 4 usuarios visibles.

### Paso 5.3 — Grupos

**Pantalla:** Identity > Groups → 3 grupos.

### Paso 5.4 — Política HBAC

**Pantalla:** Policy > Host-Based Access Control → regla activa visible.

### Paso 5.5 — Prueba de denegación HBAC

```bash
# En VM-05
ssh operador1@10.10.20.10
# Salida esperada: acceso denegado por política HBAC
```

### Paso 5.6 — Alerta en Wazuh

**Pantalla:** Wazuh Dashboard → filtrar por `rule.id:5710`.

Aparece alerta de autenticación fallida, nivel 5.

**PR-04 PASS.**

---

## BLOQUE 6 — FIM: integridad de archivos · PR-06 (~70 s)

**Objetivo:** Modificar archivo crítico → Wazuh detecta en tiempo real.

### Layout de pantalla

```text
┌─────────────────────────┬─────────────────────────┐
│  Terminal VM-05           │  Wazuh Dashboard         │
│                          │  Security Events         │
└─────────────────────────┴─────────────────────────┘
```

### Paso 6.1 — Backup y modificación

```bash
# En VM-05
sudo cp /etc/passwd /etc/passwd.bak
sudo bash -c 'echo "# test FIM $(date +%H:%M:%S)" >> /etc/passwd'
```

### Paso 6.2 — Esperar alerta (~30-40 s)

Refrescar Dashboard. Si tarda, acelerar en edición con overlay `[acelerado ×2]`.

**Buscar:** Alerta Rule 550, nivel 7, hashes SHA256 antes/después.

### Paso 6.3 — Restaurar

```bash
# En VM-05
sudo cp /etc/passwd.bak /etc/passwd
```

**PR-06 PASS.**

---

## BLOQUE 7 — Persistencia de logs en MariaDB · PR-07 + PR-08 (~80 s)

**Objetivo:** Logs reales en BD + segregación de privilegios.

### Paso 7.1 — Contenedor MariaDB

```bash
# En VM-04
docker ps --format "table {{.Names}}\t{{.Status}}"
```

### Paso 7.2 — Consulta como analyst

```bash
mysql -u analyst -p -h 127.0.0.1 siem_logs
```

```sql
SELECT COUNT(*) FROM SystemEvents;

SELECT ReceivedAt, FromHost, SysLogTag, Message
FROM SystemEvents
ORDER BY ReceivedAt DESC
LIMIT 10;
```

### Paso 7.3 — Segregación: analyst NO puede escribir

```sql
INSERT INTO SystemEvents (Message) VALUES ('test');
-- ERROR 1142 (42000): INSERT command denied to user 'analyst'
```

### Paso 7.4 — Segregación: rsyslog NO puede leer

```bash
# Salir y reconectar
mysql -u rsyslog -p -h 127.0.0.1 siem_logs
```

```sql
SELECT * FROM SystemEvents LIMIT 1;
-- ERROR 1142 (42000): SELECT command denied to user 'rsyslog'
```

**PR-07 + PR-08 PASS.**

---

## BLOQUE 8 — VPN WireGuard · PR-09 (~70 s)

**Objetivo:** Túnel VPN → acceso a VLAN 99 → denegación a otras VLANs.

### Paso 8.1 — Levantar túnel

```bash
# En equipo externo (o VM fuera de las VLANs)
sudo wg-quick up wg0
```

### Paso 8.2 — Verificar handshake

```bash
sudo wg show
# Buscar: latest handshake: X seconds ago
```

### Paso 8.3 — Acceso a VLAN 99

```bash
curl -ks https://10.10.99.1 | grep -i '<title>'
# Salida esperada: <title>OPNsense</title>
```

### Paso 8.4 — Denegación a VLAN 10

```bash
ping -c 2 10.10.10.10
# Salida esperada: Network is unreachable
```

### Paso 8.5 — Cerrar túnel

```bash
sudo wg-quick down wg0
```

**PR-09 PASS.**

---

## BLOQUE 9 — Cierre (15 s)

**Tipo:** Slide estática (se añade en edición)

```text
RESULTADOS DE LA DEMOSTRACIÓN

PR-01  Firewall deny-by-default     ✅ PASS
PR-02  Suricata IDS → Wazuh         ✅ PASS
PR-03  Fuerza bruta + bloqueo auto  ✅ PASS
PR-04  FreeIPA HBAC                 ✅ PASS
PR-05  Dashboard Wazuh              ✅ PASS  (mostrado a lo largo del vídeo)
PR-06  FIM integridad archivos      ✅ PASS
PR-07  Rsyslog → MariaDB            ✅ PASS
PR-08  Segregación de privilegios   ✅ PASS
PR-09  VPN WireGuard                ✅ PASS

9/9 pruebas superadas — 8/8 objetivos cumplidos
```

**Audio:** Narración de cierre (ver `NARRACION_VOZ_EN_OFF.md`).

---

## Orden de grabación recomendado

| Prioridad | Bloque | Motivo |
|---|---|---|
| 1 | B4 — Hydra + active response | Más delicado: depende de timing de Wazuh |
| 2 | B6 — FIM | Depende de inotify (~40 s de espera) |
| 3 | B8 — WireGuard | Requiere endpoint bien configurado |
| 4 | B2 + B3 juntos | Encadenados: nmap → Suricata → Wazuh |
| 5 | B7 — MariaDB | Puro comando-resultado, sin timing |
| 6 | B5 — FreeIPA | WebUI + SSH denegado |
| 7 | B1 — Panorámica | Al final, cuando todo está estable |
| 8 | B0 + B9 | Slides estáticas, se añaden en edición |

---

## Duración estimada por bloque

```text
B0  Carátula .............. 10 s
B1  Panorámica ............ 90 s
B2  Red + firewall ........ 80 s
B3  Suricata → Wazuh ...... 60 s
B4  Hydra + bloqueo ....... 120 s
B5  FreeIPA + HBAC ........ 60 s
B6  FIM ................... 70 s
B7  MariaDB ............... 80 s
B8  WireGuard ............. 70 s
B9  Cierre ................ 15 s
─────────────────────────────────
TOTAL ≈ 10 min 55 s
```
