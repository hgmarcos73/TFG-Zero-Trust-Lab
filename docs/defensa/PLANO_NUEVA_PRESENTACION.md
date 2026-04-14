# PLANO DE LA NUEVA PRESENTACIÓN — 16 DIAPOSITIVAS

> **Paleta de color propuesta:** Fondo oscuro navy (`#0B1929`) con acentos en teal (`#00BFA6`),  
> naranja suave (`#FF8A65`) para alertas/datos destacados, blanco (`#FFFFFF`) para texto principal,  
> gris claro (`#B0BEC5`) para texto secundario.  
> **Tipografía:** Títulos en **Arial Black** o **Montserrat Bold**, cuerpo en **Calibri** o **Inter**.  
> **Motivo visual recurrente:** Icono de escudo con candado abierto→cerrado como metáfora  
> de la transición de red abierta a Zero Trust. Borde lateral izquierdo teal en todas las slides de contenido.

---

## SLIDE 1 — CARÁTULA

**Layout:** Fondo completo navy oscuro. Centrado vertical.

**Elementos:**
- **Icono grande** (centro-arriba): Escudo con candado cerrado, en teal, ~200px. Estilo flat/minimalista.
- **Título principal** (centro): `IMPLEMENTACIÓN AVANZADA DE ARQUITECTURA ZERO TRUST` — Arial Black, 40pt, blanco.
- **Subtítulo** (debajo): `con SIEM, Base de Datos y Contenedores` — Calibri italic, 20pt, teal.
- **Línea separadora horizontal** teal, 60% del ancho.
- **Autor** (debajo línea): `Marcos Hernández García` — Calibri Bold, 18pt, blanco.
- **Datos institucionales** (pie): `I.E.S. Al-Andalus · ASIR 2024/25 | Tutores: Federico Martínez Pérez · Daniel Alberto Moreno Barón` — Calibri, 11pt, gris claro.
- **Esquina inferior derecha**: Texto discreto `IES Al-Andalus · 2025` — 9pt, gris.

**Speaker notes:**
> Buenos días. Como ya he sido presentado, paso directamente al contenido. El proyecto que voy a exponer se titula "Implementación Avanzada de Arquitectura Zero Trust con SIEM, Base de Datos y Contenedores".

---

## SLIDE 2 — ÍNDICE DE LA PRESENTACIÓN

**Layout:** Fondo claro (blanco roto `#F5F7FA`). Borde izquierdo teal.

**Elementos:**
- **Título**: `Estructura de la presentación` — 36pt, navy.
- **Lista numerada** en dos columnas (8+8 o 9+7), cada ítem con:
  - Número en círculo teal (1–16)
  - Texto del nombre de la sección en 14pt negro
  - El ítem activo podría tener highlight (fondo teal suave) si se usa animación

```
1. El problema de partida          9. SIEM — Wazuh AIO
2. ¿Qué es Zero Trust?           10. Logs y base de datos
3. Arquitectura del laboratorio   11. Flujo end-to-end
4. Stack tecnológico              12. Resultados de validación
5. Marco normativo                13. Dificultades reales
6. Perímetro — OPNsense           14. Presupuesto
7. Identidad — FreeIPA            15. Conclusiones
8. (cont. FreeIPA/Wazuh)          16. Trabajo futuro
```

- **Pie de slide**: `Zero Trust Lab · Marcos Hernández García · I.E.S. Al-Andalus · ASIR 2024/25` — 9pt, gris.

**Speaker notes:**
> La presentación sigue la estructura de la memoria: problema, diseño, implementación, pruebas y conclusiones. Vamos directamente al problema que originó el proyecto.

---

## SLIDE 3 — EL PROBLEMA DE PARTIDA

**Layout:** Fondo claro. Grid 2×2 con cuatro tarjetas.

**Elementos:**
- **Título**: `El problema de partida` — 36pt, navy.
- **Subtítulo**: `TechSecure Solutions S.L. — cuatro vulnerabilidades críticas` — 14pt, teal italic.
- **4 tarjetas** en grid 2×2, cada una con:
  - Borde superior rojo/naranja (`#E53935`) como indicador de severidad
  - Etiqueta `PT-01`, `PT-02`, `PT-03`, `PT-04` en badge naranja
  - Icono representativo (flat, ~40px): red/nodos, gráfico sin datos, candado abierto, documento vacío
  - Título en negrita 18pt
  - 2 líneas de descripción en 13pt gris oscuro

```
PT-01 — Red plana
Icono: nodos interconectados sin barrera
"Sin segmentación lógica entre equipos.
Cualquier equipo comprometido accede a toda la red."

PT-02 — Sin SIEM
Icono: gráfico de barras con signo de interrogación
"Ausencia de monitorización de eventos de seguridad.
Los incidentes no se detectan en tiempo real."

PT-03 — Sin identidad centralizada
Icono: candado abierto
"No existe control sobre quién accede a qué recurso.
Credenciales gestionadas localmente por servicio."

PT-04 — Nula trazabilidad
Icono: documento con X roja
"Sin registro estructurado de eventos.
Imposible investigar incidentes a posteriori."
```

**Speaker notes:**
> TechSecure Solutions es una consultora TI simulada de tamaño medio. Su infraestructura inicial tenía cuatro vulnerabilidades críticas. Red plana: cualquier equipo comprometido accede a toda la red. Sin SIEM: los incidentes no se detectan. Sin identidad centralizada: no hay control de acceso. Y sin trazabilidad: si pasa algo, no hay registros. El proyecto resuelve estos cuatro problemas con software libre.

---

## SLIDE 4 — ¿QUÉ ES ZERO TRUST?

**Layout:** Fondo navy oscuro. Dos columnas: izquierda texto, derecha diagrama.

**Elementos:**
- **Título**: `¿Qué es Zero Trust?` — 36pt, blanco.
- **Subtítulo**: `NIST SP 800-207 — "Nunca confíes, verifica siempre"` — 14pt, teal.
- **Columna izquierda** (55%): 3–4 principios clave como bloques con icono:
  - 🔒 `Verificación explícita` — Cada acceso se autentica y autoriza, independientemente de la ubicación.
  - 🎯 `Mínimo privilegio` — Solo se concede el acceso estrictamente necesario.
  - 🔍 `Asumir la brecha` — La red interna se trata como terreno hostil.
  - 📊 `Monitorización continua` — Todo se registra y se analiza en tiempo real.
- **Columna derecha** (45%): Diagrama conceptual simple:
  - Dos bloques: "MODELO PERIMETRAL" (arriba, tachado con X roja, con un muro y "confianza implícita dentro") vs. "MODELO ZERO TRUST" (abajo, con checkmarks verdes, con verificación en cada acceso)
  - Flecha descendente grande entre ambos con texto "Evolución"

**Speaker notes:**
> El modelo Zero Trust del NIST propone eliminar la confianza implícita basada en la ubicación. En el modelo clásico, si estás dentro de la red, tienes acceso. En Zero Trust, cada acceso se verifica: quién eres, desde dónde, a qué recurso, con qué permisos. Esto es exactamente lo que implementa el laboratorio.

---

## SLIDE 5 — ARQUITECTURA DEL LABORATORIO

**Layout:** Fondo claro. Diagrama central grande.

**Elementos:**
- **Título**: `Arquitectura del laboratorio` — 36pt, navy.
- **Subtítulo**: `5 VMs · 5 zonas de seguridad · VMware Workstation Pro 17 · deny-by-default` — 13pt, teal.
- **Diagrama central** (ocupa ~70% de la slide): Representación tipo topología de red:
  - **Arriba**: Nube "INTERNET" con icono de globo
  - **Centro**: Bloque grande OPNsense (VM-01) con 5 interfaces saliendo como rayos. Color teal.
  - **Izquierda abajo**: Bloque VM-05 Cliente (VLAN 10, 10.10.10.0/24) — color azul claro
  - **Derecha abajo**: Grupo de 3 bloques VM-02, VM-03, VM-04 (VLAN 20, 10.10.20.0/24) — color navy
  - **Lateral derecho**: Bloque Gestión VLAN 99 (10.10.99.0/24) — color naranja
  - **Flechas** entre bloques con etiquetas de los puertos permitidos (1514/1515 entre VLAN 10→20)
  - **X rojas** en las flechas bloqueadas (VLAN 10 → VLAN 99)
  - **VLAN 30 DMZ** (10.10.30.0/24) indicada como "reservada" en gris, sin conexiones activas
- **Etiquetas** de cada VM: nombre + función principal + IP (texto 10pt)

**IMPORTANTE:** La DMZ (VLAN 30) debe aparecer aunque esté reservada — la memoria documenta 5 zonas y 5 interfaces (em0–em4). Omitirla generó inconsistencia en la PPTX anterior.

**Speaker notes:**
> La solución estructura la red en cinco zonas aisladas mediante VLANs sobre switches virtuales VMnet en modo Host-only. Todo el tráfico entre zonas pasa obligatoriamente por OPNsense con política deny-by-default. La VLAN 30 DMZ está reservada para servicios expuestos en una fase futura. El orden de arranque es obligatorio: OPNsense primero porque da red, luego FreeIPA para DNS, después Wazuh y MariaDB, y por último el cliente.

---

## SLIDE 6 — STACK TECNOLÓGICO

**Layout:** Fondo claro. Grid 3×2 + 1 (7 tarjetas pequeñas tipo "card").

**Elementos:**
- **Título**: `Stack tecnológico` — 36pt, navy.
- **Subtítulo**: `7 herramientas · 100% open source · Docker Compose donde aplica` — 13pt, teal.
- **7 tarjetas** organizadas en grid (3 arriba, 3 centro, 1 abajo centrada o 4+3):
  Cada tarjeta tiene: icono/logo representativo (flat, no logos reales por copyright — usar iconos genéricos), nombre en bold, función en 12pt, nota técnica en 10pt gris.

```
1. OPNsense + Suricata     → Firewall perimetral + IDS/IPS inline · ET Open ruleset
2. FreeIPA 4.11             → Identidad centralizada · LDAP + Kerberos + DNS
3. Wazuh 4.7.5 AIO          → SIEM/XDR · correlación tiempo real · Docker Compose
4. Rsyslog                   → Recepción de logs · 514/UDP · módulo ommysql · NATIVO
5. MariaDB 10.11 LTS         → Persistencia estructurada · 5 tablas 3FN · Docker
6. WireGuard                 → VPN acceso remoto · Curve25519 · solo VLAN 99
7. Docker Compose            → Orquestación de Wazuh AIO y MariaDB · reproducibilidad
```

- Tarjetas 3 y 5 con badge `Docker` en esquina. Tarjeta 4 con badge `Nativo`.

**Speaker notes:**
> Siete herramientas, todas open source. Docker Compose gestiona Wazuh y MariaDB. Rsyslog se mantiene nativo: el módulo ommysql necesita acceso directo al socket TCP de MariaDB en 127.0.0.1 y el socket UDP 514 tiene problemas de permisos dentro de contenedores. Cada herramienta cubre un principio distinto del modelo NIST.

---

## SLIDE 7 — MARCO NORMATIVO

**Layout:** Fondo navy. Tres columnas iguales.

**Elementos:**
- **Título**: `Marco normativo` — 36pt, blanco.
- **Subtítulo**: `Tres marcos de cumplimiento simultáneo` — 13pt, teal.
- **3 columnas** con tarjeta vertical cada una:

```
Columna 1: NIST SP 800-207
Icono: escudo con check
"Arquitectura Zero Trust"
"7/7 principios cubiertos con evidencia directa"
"Referencia principal del diseño"
Nivel: ALTO ✅

Columna 2: ENS — Categoría MEDIA
Icono: bandera España estilizada
"Esquema Nacional de Seguridad"
"RD 311/2022"
"Controles: mp.com.4, op.net.1, op.exp.8"
"PYME con datos internos, sin datos clasificados"

Columna 3: RGPD — Art. 25 y 32
Icono: escudo con candado EU
"Reglamento General de Protección de Datos"
"Retención 365 días con purga automática"
"Segregación de privilegios en BD"
"Privacidad desde el diseño"
```

- **Líneas de conexión** teal entre las tres columnas en la parte inferior, indicando que se cumplen simultáneamente.

**Speaker notes:**
> El proyecto cumple simultáneamente tres marcos normativos. El NIST SP 800-207 es la referencia de diseño: los siete principios Zero Trust están cubiertos con evidencia. El ENS en categoría MEDIA encaja con el perfil de una PYME con datos internos. Y el RGPD se aplica en la retención de logs y la segregación de privilegios en la base de datos. MEDIA y no ALTA porque ALTA exigiría alta disponibilidad y cifrado extremo a extremo, que exceden el alcance de un TFG.

---

## SLIDE 8 — PERÍMETRO: OPNSENSE + SURICATA

**Layout:** Fondo claro. Dos paneles: izquierda políticas, derecha Suricata.

**Elementos:**
- **Título**: `Perímetro — OPNsense 24.x` — 36pt, navy.
- **Subtítulo**: `VM-01 · Firewall + IDS/IPS + VPN` — 13pt, teal.
- **Panel izquierdo** (55%) — Tabla de políticas entre zonas:

```
VLAN 10 → VLAN 20    Solo 1514/1515 (Wazuh)
VLAN 10 → VLAN 99    BLOQUEADO
VLAN 20 → VLAN 10    BLOQUEADO
VLAN 20 → VLAN 99    Solo gestión
VLAN 99 → Todas      Administración (firewall)
WAN → LAN            Solo VPN (51820/UDP)
```

  Filas con fondo alterno. Texto "BLOQUEADO" en rojo bold. Puertos permitidos en teal.

  **CORRECCIÓN vs. PPTX anterior:** Cambiado "Permitido *" por "Solo 1514/1515 (Wazuh)" — verificado en memoria §3.3.4 y PR-01.

- **Panel derecho** (45%) — Bloque Suricata:
  - Icono radar/antena
  - Texto: `Suricata modo IPS inline`
  - Subpuntos: "Inspección profunda de paquetes (DPI)" / "Ruleset ET Open" / "Bloqueo en tiempo real, no solo detección"
  - Debajo: Bloque "Syslog → Wazuh": "Eventos del firewall reenviados vía 514/UDP a VM-03"
  - Debajo: Bloque "WireGuard VPN": "Túnel 10.10.200.0/24 · AllowedIPs = solo VLAN 99"

**CORRECCIÓN vs. PPTX anterior:** Se listan 5 interfaces (incluyendo DMZ reservada) en vez de 4.

**Speaker notes:**
> OPNsense gestiona cinco interfaces: WAN, LAN, Servidores, DMZ reservada y Gestión. La política es deny-by-default: desde la VLAN de clientes solo se permiten los puertos 1514 y 1515 hacia Wazuh, nada más. Suricata corre en modo IPS inline: no solo detecta, bloquea en tiempo real. Los logs del firewall se reenvían a Wazuh por UDP 514 para correlación centralizada.

---

## SLIDE 9 — IDENTIDAD: FREEIPA

**Layout:** Fondo claro. Dos paneles: izquierda datos FreeIPA, derecha flujo HBAC.

**Elementos:**
- **Título**: `Identidad — FreeIPA` — 36pt, navy.
- **Subtítulo**: `VM-02 · Rocky Linux 9 · dominio lab.techsecure.local` — 13pt, teal.
- **Panel izquierdo** (50%) — Datos clave en lista con iconos:
  ```
  🔑 Servicios: LDAP + Kerberos + DNS + PKI (Dogtag)
  👤 Usuarios: 4 (admin, operador1, operador2, auditor)
  👥 Grupos: 3 (administradores, operadores, auditores)
  📋 HBAC: Políticas por grupo y servicio
  🔗 Cliente unido: VM-05 al dominio
  📡 Agente Wazuh: instalado, envía logs al SIEM
  ```

- **Panel derecho** (50%) — Diagrama de flujo HBAC:
  - 3 bloques verticales: "Usuario" → "Política HBAC" → "Recurso"
  - Ejemplo visual:
    - `admin` → ✅ SSH → `freeipa.lab.techsecure.local`
    - `operador1` → ❌ SSH → `freeipa.lab.techsecure.local` (denegado por HBAC)
  - Flechas verdes (permitido) y rojas (bloqueado)

**Speaker notes:**
> FreeIPA centraliza la autenticación con LDAP, Kerberos y DNS propios. Cuatro usuarios, tres grupos. Las políticas HBAC determinan qué usuario puede acceder a qué máquina con qué servicio. Si un operador intenta hacer SSH al servidor de identidad, FreeIPA lo deniega antes de evaluar la contraseña. El agente Wazuh en VM-02 envía ese evento al SIEM.

---

## SLIDE 10 — SIEM: WAZUH AIO

**Layout:** Fondo navy. Paneles con datos clave.

**Elementos:**
- **Título**: `SIEM — Wazuh 4.7.5 AIO` — 36pt, blanco.
- **Subtítulo**: `VM-03 · Docker Compose · 3 contenedores` — 13pt, teal.
- **Fila superior**: 3 bloques horizontales (componentes):
  ```
  Manager          Indexer (OpenSearch)     Dashboard (HTTPS)
  Correlación      Almacenamiento          Visualización
  Puerto 1514      Puerto 9200             Puerto 443
  ```
  Cada bloque con icono representativo y conectados con flechas → entre ellos.

- **Fila inferior**: 4 bloques tipo "feature card":
  ```
  Reglas custom              Active Response
  100001: Fuerza bruta SSH   firewall-drop automático
  100002: Escaneo puertos    6 intentos → bloqueo 600 s
  Nivel 10 / Nivel 8         white_list VLAN 99

  FIM Realtime               Agentes activos
  syscheck /etc con inotify  VM-02 (FreeIPA)
  Detección en 42 s          VM-05 (Cliente)
  Hash SHA256 antes/después  Estado: Active
  ```

**Speaker notes:**
> Wazuh se despliega como All-in-One con Docker Compose: tres contenedores — Manager, Indexer y Dashboard. Las reglas personalizadas 100001 y 100002 detectan fuerza bruta SSH y escaneo de puertos. La respuesta activa bloquea al atacante en iptables en 3 segundos. El módulo FIM vigila el directorio /etc en tiempo real y detecta cambios en 42 segundos.

---

## SLIDE 11 — LOGS Y BASE DE DATOS

**Layout:** Fondo claro. Dos paneles con separador visual.

**Elementos:**
- **Título**: `Logs y base de datos` — 36pt, navy.
- **Subtítulo**: `VM-04 · Rsyslog (nativo) + MariaDB 10.11 (Docker)` — 13pt, teal.
- **Panel izquierdo** — Rsyslog (badge `NATIVO` en naranja):
  ```
  Recepción: 514/UDP en 0.0.0.0
  Orígenes: OPNsense, FreeIPA, VM-05
  Módulo BD: ommysql (paquete rsyslog-mysql)
  Conexión: 127.0.0.1:3306 — TCP forzado
  ⚠ ommysql + socket UDP = incompatible con red Docker → por eso nativo
  ```

- **Panel derecho** — MariaDB (badge `DOCKER` en teal):
  ```
  Imagen: mariadb:10.11 (Docker Hub)
  Esquema: siem_logs — 5 tablas, normalización 3FN
  Secretos: fichero .env (fuera del Compose)
  Volumen: persistencia dedicada + healthcheck
  Retención RGPD: purga > 365 días (cron)
  Backup: mysqldump diario automatizado
  ```

- **Bloque inferior** centrado — Segregación de privilegios:
  Diagrama tipo "doble candado":
  ```
  rsyslog → INSERT ✅ | SELECT ❌ | DELETE ❌
  analyst → SELECT ✅ | INSERT ❌ | DELETE ❌
  ```
  Texto: `Mínimo privilegio a nivel de base de datos (ZT-02)`

**Speaker notes:**
> Rsyslog recibe los logs de toda la infraestructura por UDP 514 y los inserta en MariaDB mediante el módulo ommysql. El esquema tiene cinco tablas normalizadas. La segregación de privilegios es clave: el usuario rsyslog solo inserta, el analyst solo lee. Nadie puede borrar. La purga automática elimina registros de más de 365 días según exige el RGPD.

---

## SLIDE 12 — FLUJO END-TO-END

**Layout:** Fondo navy. Diagrama horizontal tipo pipeline.

**Elementos:**
- **Título**: `Flujo end-to-end verificado` — 36pt, blanco.
- **Subtítulo**: `Generación → Correlación → Persistencia` — 13pt, teal.
- **Pipeline horizontal** (5 nodos conectados con flechas ▶):
  ```
  [VM-05 Cliente]  →  [Agente Wazuh]  →  [Manager]  →  [Dashboard]  →  [MariaDB]
   Evento generado     Captura y          Correlación    Visible         Persistido
   (ataque/cambio)     reenvío            y reglas       < 30 s          1.847 ev/24h
  ```
  Cada nodo es un bloque redondeado con icono. Flechas con label de transporte (TCP 1514, syslog, HTTPS, ommysql).

- **Dos callouts grandes** debajo del pipeline:
  ```
  1.847                    < 30 s
  eventos registrados      latencia end-to-end
  en 24 h de operación     generación → Dashboard
  ```
  Números en 60pt naranja, texto descriptivo en 12pt gris.

**Speaker notes:**
> La prueba más importante es que el flujo funciona de extremo a extremo. Un evento generado en el cliente es capturado por el agente, correlacionado por el Manager, visible en el Dashboard en menos de 30 segundos y persistido en MariaDB bajo una estructura relacional auditable. Los 1.847 eventos en 24 horas de operación continua muestran que no es un caso puntual.

---

## SLIDE 13 — RESULTADOS DE VALIDACIÓN

**Layout:** Fondo claro. Tabla + callouts grandes.

**Elementos:**
- **Título**: `Resultados de validación` — 36pt, navy.
- **Subtítulo**: `9 pruebas funcionales · 100% PASS` — 13pt, teal.
- **4 callouts grandes** en fila superior:
  ```
  9/9          8/8              7/7                3
  Pruebas      Objetivos        Principios ZT      Marcos normativos
  PASS         cumplidos        cubiertos          NIST · ENS · RGPD
  ```
  Cada número en 56pt (teal, naranja, violeta, blanco) con texto 12pt debajo.

- **Tabla** debajo (9 filas, compacta):

  ```
  PR-01  Firewall deny-by-default       87 s        ✅
  PR-02  Suricata → alerta Wazuh        < 30 s      ✅
  PR-03  Fuerza bruta + bloqueo auto     3 s (AR)    ✅
  PR-04  Credenciales FreeIPA            < 5 s       ✅
  PR-05  Dashboard Wazuh (12 alertas)    —           ✅
  PR-06  FIM integridad (SHA256)         42 s        ✅
  PR-07  Rsyslog → MariaDB              1,2 s       ✅
  PR-08  Auditoría + segregación         —           ✅
  PR-09  VPN WireGuard                   6 s         ✅
  ```

  Checks verdes. Tiempos en teal. Columnas: ID | Descripción | Tiempo | Estado.

**Speaker notes:**
> Nueve pruebas funcionales, nueve resultados PASS. Los ocho objetivos específicos definidos en la sección 1.3.2 están cumplidos con evidencia empírica directa. Los siete principios Zero Trust del NIST quedan cubiertos con nivel Alto, verificado en la tabla 5.7.3 de la memoria. Y el sistema cumple tres marcos normativos simultáneamente.

---

## SLIDE 14 — DIFICULTADES REALES

**Layout:** Fondo navy. 5 bloques (NO 4 como antes).

**Elementos:**
- **Título**: `Dificultades reales de integración` — 36pt, blanco.
- **Subtítulo**: `5 obstáculos · causa raíz · solución aplicada` — 13pt, teal.
- **5 tarjetas** organizadas en layout 3 arriba + 2 abajo (o 2+2+1):

  Cada tarjeta con: badge ID (D-1..D-5) en naranja, título bold, causa en texto normal, solución en teal.

```
D-1 — pfSense → OPNsense
Causa: Netgate retiró soporte gratuito para VMware.
Solución: Migración a OPNsense 24.x en 12 h. Sin impacto.
[Ref: Cambio C-01, Cap. 1]

D-2 — vm.max_map_count insuficiente
Causa: Valor kernel por defecto 65530. Wazuh Indexer necesita 262144.
Solución: sysctl + persistencia en /etc/sysctl.conf.
[Ref: Hallazgo H-03, Cap. 7]

D-3 — Reglas Wazuh no persistían tras reinicio
Causa: Volumen Docker no mapeado. Contenedor arrancaba con reglas por defecto.
Solución: Bind mount en docker-compose.yml. Verificado con ossec-logtest.
[Ref: Dificultad D-04, Cap. 7]

D-4 — FIM tardaba 12 horas en detectar cambios
Causa: syscheck frequency por defecto = 43.200 s. Sin realtime.
Solución: Añadir realtime="yes" en ossec.conf. Detección: 12 h → 42 s.
[Ref: Hallazgo H-01, Cap. 7]

D-5 — rsyslog-mysql no incluido en Ubuntu 22.04
Causa: Paquete no instalado por defecto. ommysql falla silenciosamente.
Solución: apt install rsyslog-mysql + configuración manual del módulo.
[Ref: Hallazgo H-04, Cap. 7]
```

**CORRECCIÓN vs. PPTX anterior:** 5 dificultades en vez de 4. Coincide con la memoria (§7.2: "cinco fricciones documentadas"). Se incluyen H-03 (vm.max_map_count) y H-04 (rsyslog-mysql) que faltaban.

**Speaker notes:**
> Cinco problemas reales que aparecen cuando integras servicios en un entorno real. El primero: pfSense descontinuó su edición Community para VMware. Migré a OPNsense en 12 horas. El segundo: el kernel Linux no trae el parámetro de memoria que necesita el Indexer de Wazuh. El tercero: sin volumen Docker mapeado, las reglas personalizadas desaparecían al reiniciar. El cuarto: el FIM por defecto revisa cada 12 horas, inaceptable para respuesta rápida. Y el quinto: el paquete rsyslog-mysql no viene con Ubuntu 22.04 y el error es silencioso. Todos resueltos y documentados con causa raíz.

---

## SLIDE 15 — PRESUPUESTO

**Layout:** Fondo claro. Tres callouts grandes + tabla resumen.

**Elementos:**
- **Título**: `Presupuesto` — 36pt, navy.
- **Subtítulo**: `Coste real vs. valoración de mercado` — 13pt, teal.
- **3 callouts** en fila:
  ```
  21,60 €              5.000 €                ≈ 11.400 €
  Coste real            Valoración RRHH        Valoración de mercado
  (consumo eléctrico)   (200 h × 25 €/h)      (consultoría completa)
  ```
  Números en 48pt. Primer número en verde, segundo en naranja, tercero en teal.

- **Tabla simplificada** debajo:
  ```
  Concepto                    Coste real     Mercado
  Recursos humanos (200 h)    0 €            5.000 €
  Diseño + implementación     0 €            5.775 €
  Hardware                    0 €            800 €
  Software y licencias        0 €            0 € (open source)
  Consumo eléctrico           21,60 €        21,60 €
  TOTAL                       ≈ 21,60 €      ≈ 11.400 €
  ```

- **Dato impacto** abajo a la derecha: `Ratio conocimiento/inversión: 528:1` — 14pt naranja bold.

**Speaker notes:**
> El proyecto ha costado 21 euros y 60 céntimos: solo el consumo eléctrico del equipo durante las 200 horas de trabajo. Todo el software es open source. Si una empresa hubiera contratado este proyecto como consultoría externa, el coste estimado sería de 11.400 euros según tarifas de mercado en España en 2025. La ratio es 528 a 1: por cada euro invertido se ha generado 528 euros de valor profesional.

---

## SLIDE 16 — CONCLUSIONES + TRABAJO FUTURO + CIERRE

**Layout:** Fondo navy. Dos mitades: conclusiones arriba, trabajo futuro abajo.

**Elementos:**
- **Título**: `Conclusiones y trabajo futuro` — 36pt, blanco.

- **Mitad superior** — Conclusiones (3 puntos clave):
  ```
  ✅ 8/8 objetivos cumplidos con evidencia empírica verificable
  ✅ Zero Trust viable con software libre y hardware modesto (21,60 €)
  ✅ Alineación certificada con NIST SP 800-207, ENS MEDIA y RGPD
  ```

- **Mitad inferior** — 4 líneas de trabajo futuro en grid 2×2:
  ```
  🖥 Alta disponibilidad           🤖 SOAR — Respuesta automatizada
  Clúster 3 nodos, Wazuh           Shuffle + TheHive + Cortex
  multi-nodo, downtime → 0         Alerta → webhook → bloqueo + ticket

  🔐 Microsegmentación Capa 7      ☁ Extensión cloud / AD
  Autorización por identidad,      freeipa-ad-trust con AD
  no solo por VLAN                  Wazuh Indexer en AWS/Azure
  ```

- **Frase de cierre** (centrada, pie de slide, italic teal, 16pt):
  > *Muchas gracias. Quedo a disposición del tribunal para las preguntas que considere oportunas.*

- **Competencias ASIR** (5 badges pequeños en una línea debajo de conclusiones o como franja):
  ```
  SAD · ASO · SRI · ASGBD · IAW
  ```

**Speaker notes:**
> Los ocho objetivos específicos se han cumplido con evidencia verificable. El laboratorio demuestra que Zero Trust es viable con software libre y 21 euros de inversión. Las líneas de trabajo futuro son cuatro: alta disponibilidad, automatización con SOAR, microsegmentación por identidad y extensión a cloud. Con esto doy por concluida la exposición y quedo a disposición del tribunal para las preguntas que consideren oportunas.

---

## RESUMEN DE CORRECCIONES APLICADAS vs. PPTX ANTERIOR

| # | Problema detectado | Corrección en esta nueva versión |
|---|---|---|
| 1 | "Permitido *" en VLAN 10→20 | Cambiado a "Solo 1514/1515 (Wazuh)" — verificado §3.3.4 y PR-01 |
| 2 | "4 interfaces" en OPNsense | Corregido a 5 interfaces incluyendo DMZ VLAN 30 (reservada) |
| 3 | Solo 4 dificultades (D-1 a D-4) | Ampliado a 5: se incluyen H-03 (vm.max_map_count) y H-04 (rsyslog-mysql) |
| 4 | "16.880 €/año" sin fuente clara | Eliminado. Se usan solo cifras verificables del Cap. 6: 21,60 € / 5.000 € / 11.400 € |
| 5 | Sin slide de marco normativo | Nueva slide 7 dedicada a NIST + ENS + RGPD |
| 6 | Sin slide de presupuesto propia | Nueva slide 15 con desglose económico |
| 7 | Sin slide "¿Qué es Zero Trust?" | Nueva slide 4 — contexto para tribunal que no conozca el modelo |
| 8 | Sin índice | Nueva slide 2 con estructura de la presentación |

---

## NOTAS DE ESTILO VISUAL

- **Fondo oscuro (navy)** para: carátula, Zero Trust, SIEM, flujo, dificultades, cierre = slides "de impacto".
- **Fondo claro (blanco roto)** para: índice, problema, arquitectura, stack, perímetro, identidad, logs, resultados, presupuesto = slides "de datos".
- **Patrón "sandwich"**: oscuro → claro → claro → oscuro. Alterna para que el tribunal no se aburra.
- **Iconos**: Usar set consistente (Lucide, Heroicons o similar). Nunca mezclar estilos de iconos.
- **Sin animaciones** excepto transición suave (fade) entre slides. Nada que distraiga.
- **Pie de slide** consistente en todas: `Zero Trust Lab · Marcos Hernández García · I.E.S. Al-Andalus · ASIR 2024/25`.
- **No usar líneas decorativas debajo de títulos** — sustituir por borde lateral teal.
