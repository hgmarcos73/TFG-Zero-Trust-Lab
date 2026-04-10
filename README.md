# Implementación Avanzada de Arquitectura Zero Trust con SIEM, Base de Datos y Contenedores

**Trabajo de Fin de Grado — Ciclo Superior ASIR**  
**Marcos Hernández García** · I.E.S. Al-Ándalus · Curso 2025-26

---

## Descripción

Diseño, implementación y validación de una arquitectura de ciberseguridad corporativa basada en el modelo **Zero Trust (NIST SP 800-207)** para la empresa simulada *TechSecure Solutions S.L.*, desplegada íntegramente en un laboratorio virtualizado con **VMware Workstation Pro 17** y herramientas **100% open source**.

### Problema de partida

| ID    | Problema                        | Impacto                                      |
|-------|---------------------------------|----------------------------------------------|
| PT-01 | Red plana sin segmentación      | Propagación lateral de malware               |
| PT-02 | Sin SIEM ni IDS/IPS             | Imposibilidad de detectar incidentes         |
| PT-03 | Sin autenticación centralizada  | Accesos no auditables                        |
| PT-04 | Sin trazabilidad de eventos     | Incumplimiento RGPD, sin análisis forense    |

### Solución implementada

Arquitectura de **4 zonas de seguridad** (VLANs 10, 20, 30, 99) con 7 herramientas integradas:

| Componente         | Función                                | VM    |
|--------------------|----------------------------------------|-------|
| **OPNsense 24.x**  | Firewall perimetral + NAT              | VM-01 |
| **Suricata 7.x**   | IDS/IPS inline (ET Open)               | VM-01 |
| **WireGuard**       | VPN acceso remoto (solo VLAN 99)       | VM-01 |
| **FreeIPA 4.11+**   | Identidad: LDAP/Kerberos/DNS/HBAC     | VM-02 |
| **Wazuh 4.7.5 AIO** | SIEM/XDR (Docker Compose, 3 cont.)    | VM-03 |
| **MariaDB 10.11**   | Persistencia de logs (Docker)          | VM-04 |
| **Rsyslog 8.x**     | Recolección syslog → MariaDB (nativo) | VM-04 |

### Resultados

- **9/9 pruebas superadas** (PR-01 a PR-09)
- **7/7 principios Zero Trust** cubiertos con nivel Alto
- **8/8 objetivos específicos** cumplidos con evidencia empírica
- Coste real: **≈ 21,60 €** · Valoración de mercado: **≈ 11.400 €**

---

## Estructura del repositorio

```
TFG-Zero-Trust-Lab/
├── README.md                       ← Este fichero
├── LICENSE                         ← GPL v3
├── docs/
│   ├── TFG_Lab_Docker_v2_final.pdf ← Memoria completa (7 capítulos + anexos)
│   └── ORDEN_DE_INSTALACION.docx   ← Guía paso a paso de despliegue
├── docker/
│   ├── wazuh-aio/
│   │   └── docker-compose.yml      ← Wazuh AIO: Manager + Indexer + Dashboard
│   └── mariadb/
│       ├── docker-compose.yml      ← MariaDB 10.11 contenedor
│       ├── .env.example            ← Variables de entorno (sin contraseñas)
│       └── init.sql                ← Esquema siem_logs completo (3FN)
├── opnsense/
│   └── firewall-rules.xml          ← Reglas exportables (LAN, MGMT, syslog, NAT)
├── scripts/
│   ├── purga_rgpd.sh               ← Purga automática RGPD (365 días)
│   └── backup_siem.sh              ← Backup diario comprimido de MariaDB
├── wazuh/
│   ├── local_rules.xml             ← Reglas personalizadas 100001 y 100002
│   └── ossec-remote-syslog.xml     ← Bloque <remote> para syslog 514/UDP
└── config/
    └── rsyslog/
        ├── rsyslog-udp.conf        ← Módulos de recepción remota UDP/TCP
        └── 30-mysql.conf           ← Plantilla de inserción en MariaDB
```

---

## Requisitos del host

| Componente      | Mínimo          | Usado en el laboratorio     |
|-----------------|-----------------|-----------------------------|
| CPU             | 4 cores, VT-x   | Intel i7                    |
| RAM             | 16 GB            | 32 GB                       |
| Almacenamiento  | 250 GB SSD       | SSD NVMe                    |
| S.O. host       | Windows 10/11    | Windows 11                  |
| Hipervisor      | VMware WS Pro 17 | VMware Workstation Pro 17.x |

### Orden de arranque obligatorio

```
VM-01 (OPNsense) → VM-02 (FreeIPA) → VM-03 (Wazuh) → VM-04 (Logs/BD) → VM-05 (Cliente)
```

---

## Direccionamiento IP

| Componente       | IP            | VLAN | Función                    |
|------------------|---------------|------|----------------------------|
| OPNsense LAN gw  | 10.10.10.1    | 10   | Gateway clientes           |
| OPNsense SRV gw  | 10.10.20.1    | 20   | Gateway servidores         |
| OPNsense MGMT gw | 10.10.99.1    | 99   | Gateway gestión            |
| FreeIPA           | 10.10.20.10   | 20   | IdM (LDAP/Kerberos/DNS)    |
| Wazuh AIO         | 10.10.20.20   | 20   | SIEM                       |
| Rsyslog + MariaDB | 10.10.20.30   | 20   | Persistencia de logs       |
| Cliente Linux     | 10.10.10.10   | 10   | Equipo usuario + agente    |
| Admin (gestión)   | 10.10.99.10   | 99   | Acceso administración      |

---

## Marco normativo

El proyecto demuestra cumplimiento verificable con:

- **NIST SP 800-207** — Zero Trust Architecture (7/7 principios)
- **ENS categoría MEDIA** (RD 311/2022) — ≥ 85% controles cubiertos
- **RGPD** — Arts. 5.1(e), 25, 32, 33 (retención 365 días, purga automática)

---

## Notas técnicas importantes

- `vm.max_map_count=262144` debe configurarse **antes** de arrancar Wazuh (OpenSearch lo requiere)
- Rsyslog conecta a MariaDB por `127.0.0.1`, **no** por `localhost` (fuerza TCP sobre socket Unix)
- El paquete `rsyslog-mysql` **no** viene instalado en Ubuntu 22.04 — requiere `apt install rsyslog-mysql`
- La versión del agente Wazuh debe coincidir con el Manager: **4.7.5-1**
- Las reglas personalizadas necesitan volumen Docker mapeado para persistir

---

## Licencia

Este proyecto utiliza exclusivamente software libre. El código propio se distribuye bajo **GNU GPL v3**.  
Consultar [LICENSE](LICENSE) para más detalles.

---

## Autor

**Marcos Hernández García**  
Ciclo Superior en Administración de Sistemas Informáticos en Red (ASIR)  
I.E.S. Al-Ándalus — Almería — Curso 2025-26  
Tutores: Federico Martínez Pérez · Daniel Alberto Moreno Barón
