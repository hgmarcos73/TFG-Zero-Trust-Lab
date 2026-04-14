# TFG-Zero-Trust-Lab

**Implementación Avanzada de Arquitectura Zero Trust con SIEM, Base de Datos y Contenedores**

> Proyecto Final de Grado Superior — ASIR  
> Alumno: Marcos Hernández García  
> Tutores: Federico Martínez Pérez · Daniel Alberto Moreno Barón  
> Centro: I.E.S. Al-Andalus — Curso 2024/2025

---

## Descripción

Laboratorio de ciberseguridad que implementa una arquitectura Zero Trust completa sobre VMware Workstation Pro 17 con cinco máquinas virtuales. El proyecto demuestra que una infraestructura corporativa basada en el modelo NIST SP 800-207 es viable con software libre y hardware modesto.

**Componentes desplegados:**

- **OPNsense 24.x** — Firewall, Suricata IDS/IPS inline, WireGuard VPN
- **FreeIPA** sobre Rocky Linux 9 — Identidad centralizada (LDAP/Kerberos/DNS)
- **Wazuh 4.7.5 AIO** vía Docker Compose — SIEM con correlación y respuesta activa
- **MariaDB 10.11** vía Docker Compose — Persistencia de logs con esquema 3FN
- **Rsyslog** nativo — Recepción UDP 514 + inserción en MariaDB vía ommysql

**Marco normativo:** NIST SP 800-207 · ENS categoría MEDIA · RGPD

**Resultado:** 9/9 pruebas superadas (PR-01 a PR-09) · 8/8 objetivos cumplidos

---

## Estructura del repositorio

```text
TFG-Zero-Trust-Lab/
├── README.md                        ← Este fichero
├── LICENSE                          ← GPL v3
│
├── docs/
│   ├── TFG_Lab_Docker_v2_final.pdf  ← Memoria completa (7 capítulos + anexos)
│   ├── ORDEN_DE_INSTALACION.docx    ← Guía paso a paso de despliegue
│   └── defensa/                     ← Material de preparación de la defensa oral
│       ├── README.md                ← Índice de la carpeta
│       ├── GUION_VIDEO_DEMO.md      ← Guion técnico del vídeo demostrativo
│       ├── NARRACION_VOZ_EN_OFF.md  ← Texto íntegro de narración para el vídeo
│       ├── GUION_DEFENSA_ORAL.md    ← Estructura de la exposición (20 min)
│       ├── BANCO_PREGUNTAS_TRIBUNAL.md ← 15 preguntas probables + respuestas
│       └── CHECKLIST_GRABACION.md   ← Checklist día de grabación y día de defensa
│
├── docker/
│   ├── wazuh-aio/
│   │   └── docker-compose.yml       ← Wazuh AIO: Manager + Indexer + Dashboard
│   └── mariadb/
│       ├── docker-compose.yml       ← MariaDB 10.11 contenedor
│       ├── .env.example             ← Variables de entorno (sin contraseñas)
│       └── init.sql                 ← Esquema siem_logs completo (3FN)
│
├── opnsense/
│   └── firewall-rules.xml           ← Reglas exportables (LAN, MGMT, syslog, NAT)
│
├── scripts/
│   ├── purga_rgpd.sh                ← Purga automática RGPD (365 días)
│   └── backup_siem.sh               ← Backup diario comprimido de MariaDB
│
├── wazuh/
│   ├── local_rules.xml              ← Reglas personalizadas 100001 y 100002
│   └── ossec-remote-syslog.xml      ← Bloque <remote> para syslog 514/UDP
│
└── config/
    └── rsyslog/
        ├── rsyslog-udp.conf         ← Módulos de recepción remota UDP/TCP
        └── 30-mysql.conf            ← Plantilla de inserción en MariaDB
```

---

## Arquitectura del laboratorio

```text
                        ┌──────────────┐
                        │   INTERNET   │
                        └──────┬───────┘
                               │ WAN (DHCP)
                     ┌─────────┴─────────┐
                     │    VM-01          │
                     │    OPNsense 24.x  │
                     │    Suricata IPS   │
                     │    WireGuard VPN  │
                     └──┬──┬──┬──┬───────┘
           VLAN 10 ─────┘  │  │  └───── VLAN 99
          10.10.10.0/24    │  │       10.10.99.0/24
               │      VLAN 20 VLAN 30       │
               │    10.10.20.0/24  (reservada)  │
               │           │                │
          ┌────┴────┐  ┌───┴────────────┐  Gestión
          │  VM-05  │  │  VM-02  VM-03  │  admin
          │ Cliente │  │ FreeIPA Wazuh  │
          │ Agente  │  │  VM-04         │
          │ Wazuh   │  │ MariaDB+Rsyslog│
          └─────────┘  └────────────────┘
```

---

## Segmentación de red

| VLAN | Subred | Gateway OPNsense | Componentes | Política |
|---|---|---|---|---|
| **WAN** | DHCP | em0 | Internet | Deny all entrante, NAT saliente |
| **10 — LAN** | 10.10.10.0/24 | 10.10.10.1 | VM-05 Cliente | Solo puertos 1514/1515 hacia VLAN 20 |
| **20 — Servidores** | 10.10.20.0/24 | 10.10.20.1 | VM-02, VM-03, VM-04 | Aislada. Tráfico explícito desde VLAN 10/99 |
| **30 — DMZ** | 10.10.30.0/24 | 10.10.30.1 | Reservada | Sin acceso a VLAN 20 |
| **99 — Gestión** | 10.10.99.0/24 | 10.10.99.1 | Administración | Inaccesible desde VLAN 10 |

---

## Resultados de las pruebas

| ID | Prueba | Resultado | Tiempo |
|---|---|---|---|
| PR-01 | Firewall deny-by-default (nmap) | ✅ PASS | 87 s |
| PR-02 | Suricata IDS → alerta en Wazuh | ✅ PASS | < 30 s |
| PR-03 | Fuerza bruta SSH + bloqueo automático | ✅ PASS | 3 s (AR) |
| PR-04 | Credenciales FreeIPA + alerta SIEM | ✅ PASS | < 5 s |
| PR-05 | Dashboard Wazuh (12 alertas) | ✅ PASS | — |
| PR-06 | FIM integridad archivos (SHA256) | ✅ PASS | 42 s |
| PR-07 | Rsyslog → MariaDB (UDP 514) | ✅ PASS | 1,2 s |
| PR-08 | Auditoría MariaDB + segregación | ✅ PASS | — |
| PR-09 | VPN WireGuard (VLAN 99 only) | ✅ PASS | 6 s |

---

## Despliegue rápido

**Orden de arranque obligatorio:** VM-01 → VM-02 → VM-03 → VM-04 → VM-05

**Prerequisito crítico en VM-03 (antes de Wazuh):**

```bash
sudo sysctl -w vm.max_map_count=262144
echo "vm.max_map_count=262144" | sudo tee -a /etc/sysctl.conf
```

**Wazuh AIO (VM-03):**

```bash
cd /opt/wazuh-docker && docker compose up -d
```

**MariaDB (VM-04):**

```bash
cd /opt/mariadb-logs && docker compose up -d
```

---

## Gotchas documentados

- `vm.max_map_count=262144` obligatorio antes de arrancar Wazuh (el Indexer falla sin él)
- Rsyslog conecta a MariaDB vía `127.0.0.1`, no `localhost` (fuerza TCP sobre Unix socket)
- `rsyslog-mysql` no viene instalado por defecto en Ubuntu 22.04
- Agente Wazuh debe ser exactamente versión 4.7.5-1 (match con el Manager)
- Reglas custom de Wazuh requieren volumen Docker mapeado para persistir
- OPNsense syslog remoto en v24.x: System → Settings → Logging → Remote
- VMware NAT Service y DHCP Service del host → Automático y corriendo
- Suricata en modo IPS inline bloquea tráfico saliente → desactivar durante instalación de paquetes
- `ipa` commands en Rocky Linux 9 minimal: `export PATH=$PATH:/usr/sbin`
- FreeIPA hostname debe ser FQDN antes de ejecutar el instalador

---

## Licencia

GPL v3 — ver [LICENSE](LICENSE)

---

## Autor

**Marcos Hernández García**  
Ciclo Formativo de Grado Superior — Administración de Sistemas Informáticos en Red (ASIR)  
I.E.S. Al-Andalus · Curso 2024/2025
