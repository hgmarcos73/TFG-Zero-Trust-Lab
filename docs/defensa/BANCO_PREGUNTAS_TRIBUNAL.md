# Banco de preguntas del tribunal — Respuestas preparadas

> 15 preguntas ordenadas por probabilidad.  
> Formato: pregunta → respuesta corta (para decir en voz alta) → referencia a la memoria.

---

## Q01 — ¿Por qué Rsyslog nativo y no en Docker?

**Respuesta:** El módulo ommysql de Rsyslog conecta a MariaDB por TCP en 127.0.0.1:3306. Si Rsyslog estuviera en un contenedor, necesitaría acceso al socket UDP 514 del host con permisos especiales y una capa de red adicional entre contenedores. La complejidad no compensaba: Rsyslog nativo escucha en UDP 514 sin problemas y conecta a MariaDB (que sí está en Docker) por el puerto expuesto. Es una decisión de simplicidad operativa.

**Referencia:** Cambio C-02, Cap. 1 §1.5.1. Configuración en Cap. 4 §4.5.

---

## Q02 — ¿Por qué migraste de pfSense a OPNsense?

**Respuesta:** Netgate restringió el soporte de pfSense Community Edition para entornos de virtualización KVM/QEMU. OPNsense es un fork de pfSense con licencia BSD, integra Suricata de forma nativa sin configuración adicional y tiene un ciclo de actualizaciones más frecuente. La migración costó unas 12 horas de reconfiguración de interfaces y reglas, pero no se perdió ningún diseño.

**Referencia:** Cambio C-01, Cap. 1 §1.5.1. Justificación técnica en Cap. 3 §3.1.

---

## Q03 — ¿Por qué ENS MEDIA y no ALTA?

**Respuesta:** El laboratorio simula una PYME — TechSecure Solutions — con datos internos, no datos clasificados ni especialmente protegidos. La categoría MEDIA del ENS encaja con ese perfil de riesgo. ALTA exigiría alta disponibilidad en todos los componentes, cifrado extremo a extremo, auditoría continua 24/7 y certificación formal. Eso excede el alcance de un TFG de Grado Superior y requeriría hardware dedicado que no está disponible.

**Referencia:** Cap. 2 §2.2 (análisis normativo ENS).

---

## Q04 — ¿Qué pasa si la VM-03 (Wazuh) cae?

**Respuesta:** Al ser una arquitectura All-in-One, caen los tres componentes a la vez: Manager, Indexer y Dashboard. Se pierde la capacidad de correlación, búsqueda y visualización de alertas. Los agentes en las VMs siguen generando logs localmente, pero no pueden enviarlos al Manager. Esto está documentado como riesgo R1. La línea futura es desplegar los tres componentes en nodos independientes.

**Referencia:** Riesgo R1, Cap. 2 §2.6. Línea futura, Cap. 7 §7.2.

---

## Q05 — ¿Las reglas custom de Wazuh persisten tras reinicio?

**Respuesta:** Solo si el volumen Docker está correctamente mapeado. Fue una de las cinco dificultades técnicas reales del proyecto. La primera vez que reinicié los contenedores, las reglas personalizadas 100001 y 100002 desaparecieron porque la carpeta de reglas no tenía un volumen persistente en el docker-compose.yml. Se solucionó añadiendo un bind mount al directorio de reglas del Manager.

**Referencia:** Dificultad D-04, Cap. 7 §7.1.3.

---

## Q06 — ¿Por qué Wazuh 4.7.5 y no la última versión?

**Respuesta:** El agente Wazuh debe coincidir exactamente con la versión del Manager. Si instalo un agente 4.8 contra un Manager 4.7.5, la comunicación falla. Elegí la 4.7.5 porque era la versión estable en el momento del despliegue y la documentación oficial estaba completa para esa versión. Subir de versión requiere actualizar Manager, Indexer, Dashboard y todos los agentes a la vez.

**Referencia:** Cap. 4 §4.4 (despliegue Wazuh). Dificultad D-03.

---

## Q07 — ¿Qué aporta Docker si solo MariaDB y Wazuh lo usan?

**Respuesta:** Tres cosas. Primero, reproducibilidad: con docker-compose up se recrea el entorno exacto. Segundo, versionado fijo: el tag mariadb:10.11 garantiza la misma versión siempre, sin depender de los repositorios del sistema operativo. Tercero, aislamiento: los servicios corren en su propio espacio de nombres de red y filesystem. Además, Docker fue requisito aprobado por la facultad como componente obligatorio del proyecto.

**Referencia:** Cap. 3 §3.4 (diseño software). Anexo B (docker-compose.yml).

---

## Q08 — ¿Cómo garantizas el orden de arranque de las VMs?

**Respuesta:** Es manual y secuencial: VM-01, VM-02, VM-03, VM-04, VM-05. Las dependencias son técnicas: OPNsense proporciona la red y el enrutamiento; FreeIPA proporciona el DNS del dominio; Wazuh necesita ambos para recibir agentes; MariaDB necesita red para recibir logs. Si se encienden en desorden, los servicios no resuelven nombres ni rutas. En un entorno de producción se automatizaría con un orquestador, pero en VMware Workstation no hay esa funcionalidad nativa.

**Referencia:** Cap. 4 §4.1.

---

## Q09 — ¿Las métricas de rendimiento son extrapolables a producción?

**Respuesta:** No. El laboratorio corre en un solo host con recursos compartidos: 13 GB de RAM repartidos entre cinco VMs, sin carga sostenida ni concurrencia real de usuarios. Los tiempos medidos (3 s de bloqueo, 42 s de FIM, 1,2 s de inserción en MariaDB) son válidos para el lab, no para producción. Con hardware dedicado y carga real, las métricas serían diferentes. Esto está documentado como limitación explícita.

**Referencia:** Cap. 1 §1.4.2 (limitaciones del entorno).

---

## Q10 — ¿Qué harías diferente si empezaras de cero?

**Respuesta:** Tres cosas. Empezar directamente con OPNsense para evitar las 12 horas de migración desde pfSense. Configurar los volúmenes Docker desde el primer despliegue, antes de crear ninguna regla personalizada. Y reservar más horas para la fase de pruebas: los hallazgos H-01 a H-04 se habrían detectado antes con un plan de testing más temprano.

---

## Q11 — ¿Cómo funciona la respuesta activa de Wazuh?

**Respuesta:** El Manager monitoriza el flujo de alertas en tiempo real. Cuando una alerta supera un umbral definido — en mi caso, 6 intentos fallidos de SSH en menos de 60 segundos — dispara un comando predefinido. El comando firewall-drop se ejecuta en el agente del servidor atacado y añade una regla iptables que bloquea la IP de origen durante 600 segundos. Tras ese tiempo, la regla se elimina automáticamente. La white_list de la VLAN 99 evita que el administrador se bloquee a sí mismo.

**Referencia:** Cap. 4 §4.4 (config ossec.conf). Hallazgo H-02 (white_list). PR-03, Cap. 5 §5.3.

---

## Q12 — ¿Qué es el vm.max_map_count y por qué fue un problema?

**Respuesta:** Es un parámetro del kernel Linux que define el número máximo de áreas de memoria mapeada que puede tener un proceso. Wazuh Indexer, que internamente es OpenSearch, necesita un mínimo de 262144. El valor por defecto en Ubuntu 22.04 es 65530, insuficiente. Si no se ajusta antes de arrancar los contenedores, el Indexer falla al iniciarse. Se configura con sysctl y se persiste en /etc/sysctl.conf.

**Referencia:** Hallazgo H-03, Cap. 7 §7.1.3. Config en Cap. 4 §4.4.

---

## Q13 — ¿Por qué FreeIPA y no Active Directory?

**Respuesta:** FreeIPA es software libre, integra LDAP, Kerberos, DNS, NTP y PKI en un solo servidor, y corre sobre Rocky Linux que es una distribución enterprise. Active Directory requeriría una licencia de Windows Server que no estaba disponible. Además, el proyecto se centra en soluciones open source. FreeIPA cubre los mismos principios de identidad centralizada que AD: autenticación fuerte con Kerberos, directorio LDAP para usuarios y grupos, y políticas de acceso granulares con HBAC.

**Referencia:** Cap. 3 §3.1 (selección de tecnologías).

---

## Q14 — ¿Cómo aseguras la inmutabilidad de los logs en MariaDB?

**Respuesta:** Con segregación de privilegios a nivel de base de datos. El usuario rsyslog solo tiene permisos INSERT: puede escribir logs pero no leerlos, modificarlos ni borrarlos. El usuario analyst solo tiene permisos SELECT: puede leer pero no escribir ni borrar. Ningún usuario tiene DELETE ni UPDATE. La purga automática (logs de más de 365 días) se ejecuta mediante un cron con un usuario de sistema, no a través de los usuarios de la aplicación. Esto cumple con el artículo 25 del RGPD — privacidad desde el diseño.

**Referencia:** Cap. 4 §4.5.1 (esquema SQL). PR-08, Cap. 5 §5.5.2.

---

## Q15 — ¿Cómo se integra el proyecto con el RGPD?

**Respuesta:** En tres puntos concretos. Primero, la retención de logs está limitada a 365 días con purga automática — no se almacenan datos indefinidamente. Segundo, la segregación de privilegios en MariaDB impide el acceso indiscriminado a los datos de auditoría. Tercero, el acceso administrativo se restringe a la VLAN 99 y solo por VPN, limitando quién puede acceder a los datos almacenados. El proyecto no trata datos personales reales (es un laboratorio), pero implementa los controles como si los hubiera.

**Referencia:** Cap. 2 §2.2 (marco normativo RGPD). Cap. 4 §4.5 (retención y purga).
